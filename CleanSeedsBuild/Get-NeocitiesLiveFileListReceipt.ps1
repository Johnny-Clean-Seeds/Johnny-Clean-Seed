param(
    [ValidateSet('Basic', 'ApiKey')]
    [string]$Auth = 'Basic',

    [string]$SiteRoot = 'p00psticks',

    [string]$OutDir = 'C:\CleanSeedsBuild'
)

$ErrorActionPreference = 'Stop'

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

function Invoke-CurlJson {
    param([string[]]$ConfigLines)

    $body = $ConfigLines | & curl.exe --config - 2>&1
    if ($LASTEXITCODE -ne 0) {
        Stop-Fail ("curl failed with exit code {0}" -f $LASTEXITCODE)
    }

    $text = ($body | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($text)) {
        Stop-Fail 'empty response from Neocities API'
    }

    try {
        $text | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Stop-Fail 'non-JSON response from Neocities API'
    }
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

function Blank-IfNull {
    param([object]$Value)

    if ($null -eq $Value) {
        return ''
    }

    [string]$Value
}

if (-not (Test-Path -LiteralPath $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir | Out-Null
}

$infoConfig = @(
    'silent'
    'show-error'
    'url = ' + (Quote-CurlConfigValue "https://neocities.org/api/info?sitename=$SiteRoot")
)

$info = Invoke-CurlJson -ConfigLines $infoConfig
if ($info.result -ne 'success') {
    Stop-Fail ('public info failed: ' + (First-Text @($info.message, $info.error_type)))
}

if ($Auth -eq 'Basic') {
    $securePassword = Read-Host "Neocities password for $SiteRoot" -AsSecureString
    $password = ConvertFrom-Secret $securePassword
    try {
        if ([string]::IsNullOrWhiteSpace($password)) {
            Stop-Fail 'blank password'
        }

        $listConfig = @(
            'silent'
            'show-error'
            'url = ' + (Quote-CurlConfigValue 'https://neocities.org/api/list')
            'user = ' + (Quote-CurlConfigValue "$($SiteRoot):$password")
        )

        $r = Invoke-CurlJson -ConfigLines $listConfig
    }
    finally {
        $password = $null
        $securePassword = $null
    }
}
else {
    $secureKey = Read-Host 'Neocities API key' -AsSecureString
    $apiKey = (ConvertFrom-Secret $secureKey).Trim()
    try {
        if ($apiKey -match '^\s*Bearer\s+(.+)$') {
            $apiKey = $Matches[1].Trim()
        }
        if ([string]::IsNullOrWhiteSpace($apiKey)) {
            Stop-Fail 'blank API key'
        }

        $listConfig = @(
            'silent'
            'show-error'
            'url = ' + (Quote-CurlConfigValue 'https://neocities.org/api/list')
            'header = ' + (Quote-CurlConfigValue "Authorization: Bearer $apiKey")
        )

        $r = Invoke-CurlJson -ConfigLines $listConfig
    }
    finally {
        $apiKey = $null
        $secureKey = $null
    }
}

if ($r.result -ne 'success') {
    Stop-Fail ('auth list failed: ' + (First-Text @($r.message, $r.error_type)))
}

if ($null -eq $r.files -or $r.files.Count -le 0) {
    Stop-Fail 'auth list returned zero files'
}

$files = @($r.files)
$dataFiles = @($files | Where-Object { $_.path -like 'data/files/*' })
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$receiptPath = Join-Path $OutDir "NEOCITIES_LIVE_FILE_LIST_VALID_$stamp.txt"

$receipt = [System.Collections.Generic.List[string]]::new()
$receipt.Add('NEOCITIES LIVE FILE LIST RECEIPT')
$receipt.Add('STATUS: PASS')
$receipt.Add("CREATED_AT_LOCAL: $(Get-Date -Format o)")
$receipt.Add("SITE_ROOT: $SiteRoot")
$receipt.Add('AUTH_MODE: ' + $Auth)
$receipt.Add('API_ENDPOINT: https://neocities.org/api/list')
$receipt.Add('PUBLIC_INFO_ENDPOINT: https://neocities.org/api/info?sitename=' + $SiteRoot)
$receipt.Add('REMOTE_FILE_COUNT: ' + $files.Count)
$receipt.Add('DATA_FILES_PATH_COUNT: ' + $dataFiles.Count)
$receipt.Add('')
$receipt.Add('REMOTE_PATHS:')

foreach ($file in ($files | Sort-Object path)) {
    $receipt.Add(('{0}`tDIR={1}`tSIZE={2}`tUPDATED={3}`tSHA1={4}' -f `
        $file.path, `
        $file.is_directory, `
        (Blank-IfNull $file.size), `
        (Blank-IfNull $file.updated_at), `
        (Blank-IfNull $file.sha1_hash)))
}

$receipt | Set-Content -LiteralPath $receiptPath -Encoding UTF8

'PASS'
'receipt path: ' + $receiptPath
'remote file count: ' + $files.Count
'data/files path count: ' + $dataFiles.Count
