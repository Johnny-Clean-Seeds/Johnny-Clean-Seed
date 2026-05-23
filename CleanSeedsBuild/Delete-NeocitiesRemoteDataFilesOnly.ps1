param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Basic')]
    [string]$Auth,

    [string]$SiteRoot = 'p00psticks',

    [string]$PlanPath = 'C:\CleanSeedsBuild\NEOCITIES_REMOTE_DATA_FILES_DELETE_PLAN_20260512_225013.txt',

    [string]$OutDir = 'C:\CleanSeedsBuild',

    [int]$ExpectedTargetCount = 763,

    [int]$BatchSize = 75
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

function Blank-IfNull {
    param([object]$Value)

    if ($null -eq $Value) {
        return ''
    }

    [string]$Value
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

function Invoke-NeocitiesDeleteBatch {
    param([string]$UserName, [string]$Password, [string[]]$Paths)

    if ($Paths.Count -lt 1) {
        throw 'internal error: delete batch had zero paths'
    }

    $config = [System.Collections.Generic.List[string]]::new()
    $config.Add('silent')
    $config.Add('show-error')
    $config.Add('url = ' + (Quote-CurlConfigValue 'https://neocities.org/api/delete'))
    $config.Add('user = ' + (Quote-CurlConfigValue "$($UserName):$Password"))

    foreach ($path in $Paths) {
        $config.Add('data-urlencode = ' + (Quote-CurlConfigValue "filenames[]=$path"))
    }

    $response = Invoke-CurlJson -ConfigLines $config.ToArray()
    if ($response.result -ne 'success') {
        throw ('delete failed: ' + (First-Text @($response.message, $response.error_type)))
    }

    $response
}

function Get-PlanTargets {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "delete plan not found: $Path"
    }

    $lines = Get-Content -LiteralPath $Path -ErrorAction Stop
    $declaredCountLine = $lines | Where-Object { $_ -match '^Delete path count:\s*(\d+)\s*$' } | Select-Object -First 1
    if ($null -eq $declaredCountLine) {
        throw 'delete plan is missing Delete path count'
    }

    if ($declaredCountLine -match '^Delete path count:\s*(\d+)\s*$') {
        $declaredCount = [int]$Matches[1]
    }
    else {
        throw 'delete plan has an unreadable Delete path count'
    }
    if ($declaredCount -ne $ExpectedTargetCount) {
        throw "delete plan declared count $declaredCount, expected $ExpectedTargetCount"
    }

    if (-not ($lines | Where-Object { $_ -match '^Delete executed:\s*NO\s*$' })) {
        throw 'delete plan does not state Delete executed: NO'
    }

    if (-not ($lines | Where-Object { $_ -match '^Upload executed:\s*NO\s*$' })) {
        throw 'delete plan does not state Upload executed: NO'
    }

    $markerIndex = [Array]::IndexOf($lines, 'DELETE PATHS:')
    if ($markerIndex -lt 0) {
        throw 'delete plan is missing DELETE PATHS marker'
    }

    $targets = [System.Collections.Generic.List[object]]::new()

    foreach ($line in $lines[($markerIndex + 1)..($lines.Count - 1)]) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        if ($line -notmatch '^(?<Path>.+?)(?:`tDIR=|\tDIR=|$)') {
            throw "could not parse delete plan line: $line"
        }

        $remotePath = ([string]$Matches['Path']).Trim()
        $isDirectory = $false
        if ($line -match '(?:`tDIR=|\tDIR=)(?<Dir>True|False)') {
            $isDirectory = [bool]::Parse($Matches['Dir'])
        }

        $targets.Add([pscustomobject]@{
            Path = $remotePath
            IsDirectory = $isDirectory
        })
    }

    if ($targets.Count -ne $ExpectedTargetCount) {
        throw "delete plan parsed $($targets.Count) target paths, expected $ExpectedTargetCount"
    }

    $duplicatePaths = @(
        $targets |
            Group-Object Path |
            Where-Object { $_.Count -gt 1 } |
            Select-Object -ExpandProperty Name
    )
    if ($duplicatePaths.Count -gt 0) {
        throw ('delete plan contains duplicate target paths: ' + ($duplicatePaths -join ', '))
    }

    @($targets)
}

function Assert-TargetSafety {
    param([object[]]$Targets)

    $protectedExact = @(
        'index.html',
        'style.css',
        'data/CURRENT_STATE.txt',
        'data/NEXT_GATE.txt',
        'data/PROJECT_MANIFEST.json',
        'data/SHED_INDEX.json',
        'data/GAP_TODO_MATCHES.json',
        'data/BRIDGE_OUTPUT_HASHES.json',
        'data/state.json'
    )

    $badTargets = [System.Collections.Generic.List[string]]::new()

    foreach ($target in $Targets) {
        $path = [string]$target.Path

        if ($path -notlike 'data/files/*') {
            $badTargets.Add("outside data/files/*: $path")
            continue
        }

        if ($path -in $protectedExact -or $path -like 'scripts/*' -or $path -like 'assets/*') {
            $badTargets.Add("protected path: $path")
            continue
        }

        if ($path -match '(^|/)\.\.(/|$)' -or $path -match '^[A-Za-z]:\\' -or $path -match '^\\\\') {
            $badTargets.Add("unsafe path syntax: $path")
        }
    }

    if ($badTargets.Count -gt 0) {
        throw ("unsafe delete target(s): " + ($badTargets -join '; '))
    }
}

function Assert-PlanMatchesLive {
    param([object[]]$Targets, [object[]]$LiveDataFiles)

    if ($LiveDataFiles.Count -ne $ExpectedTargetCount) {
        throw "live data/files count $($LiveDataFiles.Count), expected $ExpectedTargetCount"
    }

    $targetPathSet = @{}
    foreach ($target in $Targets) {
        $targetPathSet[[string]$target.Path] = $true
    }

    $livePathSet = @{}
    foreach ($file in $LiveDataFiles) {
        $livePathSet[[string]$file.path] = $true
    }

    $missingFromLive = @($targetPathSet.Keys | Where-Object { -not $livePathSet.ContainsKey($_) } | Sort-Object)
    $extraLive = @($livePathSet.Keys | Where-Object { -not $targetPathSet.ContainsKey($_) } | Sort-Object)

    if ($missingFromLive.Count -gt 0 -or $extraLive.Count -gt 0) {
        $message = "delete plan does not match live data/files list. Missing from live: $($missingFromLive.Count). Extra live: $($extraLive.Count)."
        if ($missingFromLive.Count -gt 0) {
            $message += " First missing: $($missingFromLive[0])"
        }
        if ($extraLive.Count -gt 0) {
            $message += " First extra: $($extraLive[0])"
        }
        throw $message
    }
}

function Split-IntoBatches {
    param([string[]]$Paths, [int]$Size)

    if ($Size -lt 1) {
        throw 'batch size must be at least 1'
    }

    for ($i = 0; $i -lt $Paths.Count; $i += $Size) {
        $end = [Math]::Min($i + $Size - 1, $Paths.Count - 1)
        @($Paths[$i..$end])
    }
}

try {
    if ($Auth -ne 'Basic') {
        Stop-Fail 'only -Auth Basic is allowed by this guarded delete script'
    }

    if (-not (Test-Path -LiteralPath $OutDir -PathType Container)) {
        throw "output folder not found: $OutDir"
    }

    $targets = Get-PlanTargets -Path $PlanPath
    Assert-TargetSafety -Targets $targets

    $securePassword = Read-Host "Neocities password for $SiteRoot" -AsSecureString
    $password = ConvertFrom-Secret $securePassword

    try {
        if ([string]::IsNullOrWhiteSpace($password)) {
            throw 'blank password'
        }

        'Authenticating and listing remote site before delete...'
        $preFiles = Invoke-NeocitiesList -UserName $SiteRoot -Password $password
        $preDataFiles = @($preFiles | Where-Object { $_.path -like 'data/files/*' })
        Assert-PlanMatchesLive -Targets $targets -LiveDataFiles $preDataFiles

        'Pre-delete guard passed: live data/files count is exactly 763 and matches the delete plan.'

        $fileTargets = @(
            $targets |
                Where-Object { -not $_.IsDirectory } |
                Select-Object -ExpandProperty Path |
                Sort-Object
        )
        $directoryTargets = @(
            $targets |
                Where-Object { $_.IsDirectory } |
                Select-Object -ExpandProperty Path |
                Sort-Object @{ Expression = { ($_.ToCharArray() | Where-Object { $_ -eq '/' }).Count }; Descending = $true }, @{ Expression = { $_ }; Descending = $true }
        )
        $orderedDeletePaths = @($fileTargets + $directoryTargets)

        if ($orderedDeletePaths.Count -ne $ExpectedTargetCount) {
            throw "internal target order count $($orderedDeletePaths.Count), expected $ExpectedTargetCount"
        }

        $batchNumber = 0
        $batchTotal = [Math]::Ceiling($orderedDeletePaths.Count / [double]$BatchSize)
        foreach ($batch in (Split-IntoBatches -Paths $orderedDeletePaths -Size $BatchSize)) {
            $batchNumber++
            "Deleting guarded batch $batchNumber of $batchTotal ($($batch.Count) paths)..."
            $null = Invoke-NeocitiesDeleteBatch -UserName $SiteRoot -Password $password -Paths $batch
        }

        'Verifying remote site after delete...'
        $postFiles = Invoke-NeocitiesList -UserName $SiteRoot -Password $password
        $postDataFiles = @($postFiles | Where-Object { $_.path -like 'data/files/*' })
        $remainingPaths = @($postDataFiles | Select-Object -ExpandProperty path | Sort-Object)

        $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $receiptPath = Join-Path $OutDir "NEOCITIES_REMOTE_DATA_FILES_DELETE_RECEIPT_VALID_$stamp.txt"
        $planHash = (Get-FileHash -LiteralPath $PlanPath -Algorithm SHA256).Hash

        $receipt = [System.Collections.Generic.List[string]]::new()
        $receipt.Add('NEOCITIES REMOTE DATA FILES DELETE RECEIPT')
        $receipt.Add('STATUS: PASS')
        $receipt.Add("CREATED_AT_LOCAL: $(Get-Date -Format o)")
        $receipt.Add("SITE_ROOT: $SiteRoot")
        $receipt.Add("AUTH_MODE: $Auth")
        $receipt.Add('API_LIST_ENDPOINT: https://neocities.org/api/list')
        $receipt.Add('API_DELETE_ENDPOINT: https://neocities.org/api/delete')
        $receipt.Add("PLAN_PATH: $PlanPath")
        $receipt.Add("PLAN_SHA256: $planHash")
        $receipt.Add("EXPECTED_TARGET_COUNT: $ExpectedTargetCount")
        $receipt.Add("PRE_DELETE_REMOTE_FILE_COUNT: $($preFiles.Count)")
        $receipt.Add("PRE_DELETE_DATA_FILES_COUNT: $($preDataFiles.Count)")
        $receipt.Add("DELETE_TARGET_COUNT: $($orderedDeletePaths.Count)")
        $receipt.Add("DELETE_FILE_TARGET_COUNT: $($fileTargets.Count)")
        $receipt.Add("DELETE_DIRECTORY_TARGET_COUNT: $($directoryTargets.Count)")
        $receipt.Add("DELETE_BATCH_SIZE: $BatchSize")
        $receipt.Add("DELETE_BATCH_COUNT: $batchTotal")
        $receipt.Add('DELETE_ENDPOINT_RESULT: success for every guarded batch')
        $receipt.Add("POST_DELETE_REMOTE_FILE_COUNT: $($postFiles.Count)")
        $receipt.Add("POST_DELETE_DATA_FILES_COUNT: $($postDataFiles.Count)")
        $receipt.Add("POST_DELETE_DATA_FILES_REMAINDER_REPORTED: $($postDataFiles.Count)")
        $receipt.Add('UPLOAD_EXECUTED: NO')
        $receipt.Add('LOCAL_FILE_DELETE_EXECUTED: NO')
        $receipt.Add('PROTECTED_ROOT_PATHS_TARGETED: NO')
        $receipt.Add('')
        $receipt.Add('PROTECTED PATHS NEVER TARGETED:')
        $receipt.Add('index.html')
        $receipt.Add('style.css')
        $receipt.Add('scripts/*')
        $receipt.Add('assets/*')
        $receipt.Add('data/CURRENT_STATE.txt')
        $receipt.Add('data/NEXT_GATE.txt')
        $receipt.Add('data/PROJECT_MANIFEST.json')
        $receipt.Add('data/SHED_INDEX.json')
        $receipt.Add('data/GAP_TODO_MATCHES.json')
        $receipt.Add('data/BRIDGE_OUTPUT_HASHES.json')
        $receipt.Add('data/state.json')
        $receipt.Add('')
        $receipt.Add('REMAINING data/files PATHS:')
        if ($remainingPaths.Count -eq 0) {
            $receipt.Add('(none)')
        }
        else {
            foreach ($remaining in $remainingPaths) {
                $receipt.Add($remaining)
            }
        }

        $receipt | Set-Content -LiteralPath $receiptPath -Encoding UTF8

        'PASS'
        'receipt path: ' + $receiptPath
        'pre-delete data/files path count: ' + $preDataFiles.Count
        'delete target count: ' + $orderedDeletePaths.Count
        'post-delete data/files path count: ' + $postDataFiles.Count
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
