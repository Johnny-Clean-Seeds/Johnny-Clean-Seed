param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Basic')]
    [string]$Auth,

    [string]$SiteRoot = 'p00psticks',

    [string]$SiteDir = 'C:\CleanSeedsBuild\NEOCITIES_CLEAN_SITE',

    [string]$OutDir = 'C:\CleanSeedsBuild'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Stop-Fail {
    param([string]$Message)

    'FAIL'
    $Message
    exit 1
}

function ConvertFrom-Secret {
    param([Security.SecureString]$Secret)

    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secret)
    try {
        [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        if ($bstr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }
}

function Quote-CurlConfigValue {
    param([string]$Value)

    '"' + ($Value -replace '\\', '\\' -replace '"', '\"') + '"'
}

function First-Text {
    param([object[]]$Values)

    foreach ($value in $Values) {
        if (-not [string]::IsNullOrWhiteSpace([string]$value)) {
            return [string]$value
        }
    }

    'unknown error'
}

function Invoke-CurlJson {
    param([string[]]$ConfigLines)

    $body = $ConfigLines | & curl.exe --config - 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw ("curl failed with exit code {0}" -f $LASTEXITCODE)
    }

    $text = ($body | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($text)) {
        throw 'empty response from Neocities API'
    }

    try {
        $text | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        throw 'non-JSON response from Neocities API'
    }
}

function Invoke-NeocitiesList {
    param([string]$UserName, [string]$Password)

    $config = @(
        'silent'
        'show-error'
        'url = ' + (Quote-CurlConfigValue 'https://neocities.org/api/list')
        'user = ' + (Quote-CurlConfigValue "$($UserName):$Password")
    )

    $response = Invoke-CurlJson -ConfigLines $config
    if ($response.result -ne 'success') {
        throw ('auth/list failed: ' + (First-Text @($response.message, $response.error_type)))
    }

    if ($null -eq $response.files) {
        throw 'auth/list returned no files field'
    }

    @($response.files)
}

function Invoke-NeocitiesUpload {
    param([string]$UserName, [string]$Password, [object[]]$UploadFiles)

    $config = [System.Collections.Generic.List[string]]::new()
    $config.Add('silent')
    $config.Add('show-error')
    $config.Add('url = ' + (Quote-CurlConfigValue 'https://neocities.org/api/upload'))
    $config.Add('user = ' + (Quote-CurlConfigValue "$($UserName):$Password"))

    foreach ($file in $UploadFiles) {
        $config.Add('form = ' + (Quote-CurlConfigValue "$($file.RemotePath)=@$($file.LocalPath)"))
    }

    $response = Invoke-CurlJson -ConfigLines $config.ToArray()
    if ($response.result -ne 'success') {
        throw ('upload failed: ' + (First-Text @($response.message, $response.error_type)))
    }

    $response
}

function New-UploadItem {
    param([string]$RemotePath)

    $local = Join-Path $SiteDir ($RemotePath -replace '/', '\')
    if (-not (Test-Path -LiteralPath $local -PathType Leaf)) {
        throw "required upload file missing: $local"
    }

    [pscustomobject]@{
        RemotePath = $RemotePath
        LocalPath = $local
        Size = (Get-Item -LiteralPath $local).Length
        SHA1 = (Get-FileHash -LiteralPath $local -Algorithm SHA1).Hash.ToLowerInvariant()
        SHA256 = (Get-FileHash -LiteralPath $local -Algorithm SHA256).Hash
    }
}

try {
    if ($Auth -ne 'Basic') {
        Stop-Fail 'only -Auth Basic is allowed by this guarded upload script'
    }

    if (-not (Test-Path -LiteralPath $SiteDir -PathType Container)) {
        throw "site folder not found: $SiteDir"
    }

    if (-not (Test-Path -LiteralPath $OutDir -PathType Container)) {
        throw "output folder not found: $OutDir"
    }

    $remotePaths = @(
        'index.html',
        'style.css',
        'robots.txt',
        'index-art.png',
        'scripts/gate.js',
        'scripts/manifest.js',
        'data/BRIDGE_OUTPUT_HASHES.json',
        'data/CURRENT_STATE.txt',
        'data/GAP_TODO_MATCHES.json',
        'data/NEXT_GATE.txt',
        'data/PROJECT_MANIFEST.json',
        'data/SHED_INDEX.json',
        'data/state.json',
        'assets/recursive-core-architecture.png',
        'assets/recursive-ai-growth-theory.png',
        'assets/cure-for-drift.png',
        'assets/controlled-recursive-growth.png'
    )

    $uploadFiles = @($remotePaths | ForEach-Object { New-UploadItem -RemotePath $_ })

    $indexText = Get-Content -LiteralPath (Join-Path $SiteDir 'index.html') -Raw
    $gateText = Get-Content -LiteralPath (Join-Path $SiteDir 'scripts\gate.js') -Raw

    if ($indexText -notmatch 'Bridge Reader' -or $indexText -notmatch 'Concept Maps' -or $indexText -notmatch 'Mom''s Seed Garden') {
        throw 'index.html does not contain the expected mom-front and bridge-reader markers'
    }

    if ($indexText -match 'RedRose137' -or $gateText -match 'RedRose137') {
        throw 'plain password text appears in upload files'
    }

    if ($gateText -notmatch '52C531BF9B3EE927C51C5A1FFF45658A4FF911027F3B76ADE35085B7003643D4') {
        throw 'gate.js does not contain the RedRose137 SHA256 access hash'
    }

    if ($indexText -match 'hacker' -or $indexText -match 'exposing') {
        throw 'index.html contains disallowed literal theme wording'
    }

    $totalBytes = ($uploadFiles | Measure-Object Size -Sum).Sum
    'UPLOAD SET READY'
    "site folder: $SiteDir"
    "target site: $SiteRoot.neocities.org"
    "file count: $($uploadFiles.Count)"
    "total bytes: $totalBytes"
    ''
    'This uploads only the public site files listed by this script.'
    'It does not delete remote files.'
    'It does not upload UPDATE_MANIFEST.ps1, UPDATE_MANIFEST.bat, local backups, receipts, or do-not-upload files.'
    ''

    $securePassword = Read-Host "Neocities password for $SiteRoot" -AsSecureString
    $password = ConvertFrom-Secret $securePassword

    try {
        if ([string]::IsNullOrWhiteSpace($password)) {
            throw 'blank password'
        }

        'Authenticating with GET /api/list before upload...'
        $preFiles = Invoke-NeocitiesList -UserName $SiteRoot -Password $password
        "pre-upload remote file count: $($preFiles.Count)"

        'Uploading guarded public site files...'
        $null = Invoke-NeocitiesUpload -UserName $SiteRoot -Password $password -UploadFiles $uploadFiles

        'Verifying with GET /api/list after upload...'
        $postFiles = Invoke-NeocitiesList -UserName $SiteRoot -Password $password
        $postByPath = @{}
        foreach ($file in $postFiles) {
            if ($null -ne $file.path) {
                $postByPath[[string]$file.path] = $file
            }
        }

        $mismatches = [System.Collections.Generic.List[string]]::new()
        foreach ($file in $uploadFiles) {
            if (-not $postByPath.ContainsKey($file.RemotePath)) {
                $mismatches.Add("missing remote file: $($file.RemotePath)")
                continue
            }

            $remote = $postByPath[$file.RemotePath]
            $remoteSha1 = ([string]$remote.sha1_hash).ToLowerInvariant()
            if ($remoteSha1 -ne $file.SHA1) {
                $mismatches.Add("sha1 mismatch: $($file.RemotePath) local=$($file.SHA1) remote=$remoteSha1")
            }
        }

        if ($mismatches.Count -gt 0) {
            throw ('post-upload verification failed: ' + ($mismatches -join '; '))
        }

        $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $receiptPath = Join-Path $OutDir "NEOCITIES_CLEAN_SITE_UPLOAD_RECEIPT_$stamp.txt"
        $receipt = [System.Collections.Generic.List[string]]::new()
        $receipt.Add('NEOCITIES CLEAN SITE UPLOAD RECEIPT')
        $receipt.Add('STATUS: PASS')
        $receipt.Add("CREATED_AT_LOCAL: $(Get-Date -Format o)")
        $receipt.Add("SITE_ROOT: $SiteRoot")
        $receipt.Add("SITE_DIR: $SiteDir")
        $receipt.Add('AUTH_MODE: Basic')
        $receipt.Add('UPLOAD_ENDPOINT: https://neocities.org/api/upload')
        $receipt.Add('VERIFY_ENDPOINT: https://neocities.org/api/list')
        $receipt.Add("UPLOAD_FILE_COUNT: $($uploadFiles.Count)")
        $receipt.Add("UPLOAD_TOTAL_BYTES: $totalBytes")
        $receipt.Add("PRE_UPLOAD_REMOTE_FILE_COUNT: $($preFiles.Count)")
        $receipt.Add("POST_UPLOAD_REMOTE_FILE_COUNT: $($postFiles.Count)")
        $receipt.Add('REMOTE_DELETE_EXECUTED: NO')
        $receipt.Add('LOCAL_DELETE_EXECUTED: NO')
        $receipt.Add('EXCLUDED: UPDATE_MANIFEST.ps1')
        $receipt.Add('EXCLUDED: UPDATE_MANIFEST.bat')
        $receipt.Add('EXCLUDED: local backups, receipts, and do-not-upload files')
        $receipt.Add('')
        $receipt.Add('UPLOADED FILES:')
        foreach ($file in $uploadFiles) {
            $receipt.Add(('{0}`tSIZE={1}`tSHA1={2}`tSHA256={3}' -f $file.RemotePath, $file.Size, $file.SHA1, $file.SHA256))
        }

        $receipt | Set-Content -LiteralPath $receiptPath -Encoding UTF8

        'PASS'
        'receipt path: ' + $receiptPath
        'uploaded file count: ' + $uploadFiles.Count
        'verified file count: ' + $uploadFiles.Count
        exit 0
    }
    finally {
        $password = $null
        $securePassword = $null
    }
}
catch {
    Stop-Fail $_.Exception.Message
}
