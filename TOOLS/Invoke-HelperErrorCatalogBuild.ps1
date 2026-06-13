[CmdletBinding()]
param(
    [string]$SeedErrorPath = 'C:\Users\13527\Desktop\project_draft notes\errs.txt',
    [string]$FallbackSeedErrorPath = 'C:\Users\13527\Downloads\errs.txt',
    [string]$OutputRoot = 'C:\Users\13527\Desktop\123\_HELPER_ERROR_CATALOGS',
    [string]$RepoRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}
$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
$runRoot = Join-Path $OutputRoot ('HELPER_ERROR_CATALOG_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
$reportRoot = Join-Path $runRoot 'REPORTS'
$logRoot = Join-Path $runRoot 'LOGS'
New-Item -ItemType Directory -Force -Path $reportRoot, $logRoot | Out-Null

$rows = New-Object System.Collections.Generic.List[object]

function Add-CatalogRow {
    param(
        [string]$ErrorFamily,
        [string]$Trigger,
        [string]$BadCondition,
        [string]$Symptom,
        [string]$LowestCause,
        [string]$CleanFix,
        [string]$HelperToUse,
        [string]$ProofAfterFix,
        [string]$DoesNotProve,
        [string]$EvidencePath = ''
    )

    $rows.Add([PSCustomObject]@{
        ErrorFamily = $ErrorFamily
        Trigger = $Trigger
        BadCondition = $BadCondition
        Symptom = $Symptom
        LowestCause = $LowestCause
        CleanFix = $CleanFix
        HelperToUse = $HelperToUse
        ProofAfterFix = $ProofAfterFix
        EvidencePath = $EvidencePath
        DoesNotProve = $DoesNotProve
    })
}

function Invoke-BadCommand {
    param(
        [string]$Name,
        [scriptblock]$Command
    )

    $logPath = Join-Path $logRoot (($Name -replace '[^A-Za-z0-9_-]', '_') + '.log')
    $oldErrorActionPreference = $ErrorActionPreference
    $output = ''
    $exitCode = 0
    try {
        $ErrorActionPreference = 'Continue'
        $global:LASTEXITCODE = 0
        $output = (& $Command *>&1 | Out-String -Width 260)
        $exitCode = if ($null -eq $global:LASTEXITCODE) { 0 } else { $global:LASTEXITCODE }
    } catch {
        $output = (($output, $_.Exception.Message) -join [Environment]::NewLine).Trim()
        $exitCode = 1
    } finally {
        $ErrorActionPreference = $oldErrorActionPreference
    }
    $output | Set-Content -LiteralPath $logPath -Encoding UTF8
    return [PSCustomObject]@{
        LogPath = $logPath
        Output = $output
        ExitCode = $exitCode
    }
}

$seedUsed = ''
if (Test-Path -LiteralPath $SeedErrorPath -PathType Leaf) {
    $seedUsed = (Resolve-Path -LiteralPath $SeedErrorPath).Path
} elseif (Test-Path -LiteralPath $FallbackSeedErrorPath -PathType Leaf) {
    $seedUsed = (Resolve-Path -LiteralPath $FallbackSeedErrorPath).Path
    Add-CatalogRow `
        -ErrorFamily 'PATH_FRESHNESS_CHECK_NEEDED' `
        -Trigger 'User-mentioned errs.txt path did not exist at read time.' `
        -BadCondition $SeedErrorPath `
        -Symptom 'Desktop project_draft notes folder existed, but errs.txt was not present there; fallback Downloads errs.txt was found.' `
        -LowestCause 'source, custody, and path freshness' `
        -CleanFix 'Check the exact local path first, then use a found fallback only when clearly named in the report.' `
        -HelperToUse 'helper_gap_and_cause_ladder + helper_error_catalog' `
        -ProofAfterFix $seedUsed `
        -DoesNotProve 'Does not prove the Downloads file is the intended latest copy.'
}

if (-not [string]::IsNullOrWhiteSpace($seedUsed)) {
    Copy-Item -LiteralPath $seedUsed -Destination (Join-Path $runRoot 'SEED_errs.txt') -Force
    $seedText = Get-Content -LiteralPath $seedUsed -Raw
    if ($seedText -like '*Unexpected token*USERPROFILE*Desktop*') {
        Add-CatalogRow `
            -ErrorFamily 'POWERSHELL_ENV_PATH_PARSE_ERROR' `
            -Trigger 'PowerShell command used $env:USERPROFILE directly next to a path suffix.' `
            -BadCondition '$env:USERPROFILE\Desktop\ORGANIZE_HOUSE_DOCK_SAVE_PACKET_V1.ps1' `
            -Symptom 'Unexpected token path suffix in expression or statement.' `
            -LowestCause 'command, tool, and environment shape' `
            -CleanFix 'Use Join-Path or quote/interpolate the full path, then invoke with &: & (Join-Path $env:USERPROFILE ''Desktop\script.ps1'').' `
            -HelperToUse 'safe coding helper seed + helper error evidence logging' `
            -ProofAfterFix 'Parser error avoided when path is built as a string before invocation.' `
            -DoesNotProve 'Does not prove the target script exists.'
    }
    if ($seedText -like '*not recognized as a name of a cmdlet*ORGANIZE_HOUSE_DOCK_SAVE_PACKET*') {
        Add-CatalogRow `
            -ErrorFamily 'POWERSHELL_SCRIPT_PATH_MISSING' `
            -Trigger 'Quoted invocation syntax was correct, but the target script was absent.' `
            -BadCondition '& "$HOME\Desktop\ORGANIZE_HOUSE_DOCK_SAVE_PACKET_V1.ps1"' `
            -Symptom 'The term is not recognized as a cmdlet, function, script file, or executable program.' `
            -LowestCause 'source, custody, and path freshness' `
            -CleanFix 'Run Test-Path before invocation; if missing, find the actual file or stop with PATH_FRESHNESS_CHECK_NEEDED.' `
            -HelperToUse 'helper gap cause scanner + safe coding helper seed' `
            -ProofAfterFix 'Test-Path returns true before running a script.' `
            -DoesNotProve 'Does not prove the script is safe or should be run.'
    }
} else {
    Add-CatalogRow `
        -ErrorFamily 'ERROR_SEED_FILE_MISSING' `
        -Trigger 'No seed error file found.' `
        -BadCondition "$SeedErrorPath ; $FallbackSeedErrorPath" `
        -Symptom 'Neither seed path exists.' `
        -LowestCause 'source, custody, and path freshness' `
        -CleanFix 'Ask user for exact file path or wait for attached file to materialize.' `
        -HelperToUse 'helper gap cause ladder' `
        -ProofAfterFix 'Exact readable path exists.' `
        -DoesNotProve 'Does not prove there are no user error notes.'
}

$badUrl = Invoke-BadCommand 'invalid_seed_url' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-CleanWebCrawl.ps1') -OutputRoot (Join-Path $runRoot 'INDUCED_WEB') -SeedUrls 'not-a-url' -IntentionalNegativeTestName 'catalog invalid seed URL' -ExpectedFailureContains 'INVALID_SEED_URL'
}
Add-CatalogRow 'WEB_CRAWL_INVALID_SEED_URL' 'Intentional negative test' 'SeedUrls=not-a-url' $badUrl.Output 'command, tool, and environment shape' 'Validate seed URL is absolute HTTP/HTTPS before crawl.' 'web search crawl ladder' 'Script exits nonzero and writes INVALID_SEED_URL evidence.' 'Does not prove all crawl inputs are safe.' $badUrl.LogPath

$broad = Invoke-BadCommand 'broad_crawl_blocked' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-CleanWebCrawl.ps1') -OutputRoot (Join-Path $runRoot 'INDUCED_WEB') -SeedUrls 'https://github.com/Johnny-Clean-Seeds/Johnny-Clean-Seed' -CrawlLevel Level3 -IntentionalNegativeTestName 'catalog broad crawl blocked' -ExpectedFailureContains 'BROAD_CRAWL_LEVEL_BLOCKED'
}
Add-CatalogRow 'WEB_CRAWL_BROAD_LEVEL_BLOCKED' 'Intentional negative test' 'CrawlLevel=Level3 without AllowBroadCrawl' $broad.Output 'mutation permission and route contract' 'Require explicit -AllowBroadCrawl and user approval before Level3.' 'web search crawl ladder' 'Script exits nonzero and writes BROAD_CRAWL_LEVEL_BLOCKED.' 'Does not prove Level1 or Level2 are safe for every host.' $broad.LogPath

$missingPeer = Invoke-BadCommand 'chat_drop_missing_peer' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-ChatDropLocalPull.ps1') -OutputRoot (Join-Path $runRoot 'INDUCED_CHAT_DROP') -PeerChatDrop 'C:\Users\13527\Desktop\123\NO_SUCH_CHAT_DROP_TEST' -IntentionalNegativeTestName 'catalog missing peer Chat Drop' -ExpectedFailureContains 'MISSING_PEER_CHAT_DROP'
}
Add-CatalogRow 'CHAT_DROP_MISSING_PEER' 'Intentional negative test' 'PeerChatDrop points to missing folder.' $missingPeer.Output 'source, custody, and path freshness' 'Check both required Chat Drop roots before bundle/copy; stop if missing.' 'ChatDropFreshnessScanner + Invoke-ChatDropLocalPull' 'Script exits nonzero and writes MISSING_PEER_CHAT_DROP.' 'Does not prove source Chat Drop content is current.' $missingPeer.LogPath

$mutation = Invoke-BadCommand 'safe_coding_mutation_blocked' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\New-SafeCodingHelperPacket.ps1') -OutputRoot (Join-Path $runRoot 'INDUCED_CODING') -TaskName 'catalog mutation test' -AllowProjectMutation -IntentionalNegativeTestName 'catalog coding mutation blocked' -ExpectedFailureContains 'PROJECT_MUTATION_BLOCKED_BY_SAFE_CODING_SEED'
}
Add-CatalogRow 'SAFE_CODING_MUTATION_BLOCKED' 'Intentional negative test' 'AllowProjectMutation supplied to safe seed packet maker.' $mutation.Output 'mutation permission and route contract' 'Keep coding seed no-mutation; use later authorized apply-patch helper only after proof.' 'safe coding helper seed' 'Script exits nonzero and writes PROJECT_MUTATION_BLOCKED_BY_SAFE_CODING_SEED.' 'Does not prove coding edits are unsafe in every later authorized lane.' $mutation.LogPath

$missingPacket = Invoke-BadCommand 'safe_coding_packet_missing' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Test-SafeCodingHelperPacket.ps1') -PacketRoot 'C:\Users\13527\Desktop\123\NO_SUCH_SAFE_CODING_PACKET' -OutputRoot (Join-Path $runRoot 'INDUCED_CODING_VALIDATION')
}
Add-CatalogRow 'SAFE_CODING_PACKET_ROOT_MISSING' 'Intentional negative test' 'PacketRoot points to missing folder.' $missingPacket.Output 'source, custody, and path freshness' 'Validate packet root exists before reading or relying on packet.' 'safe coding packet validator' 'Validator exits nonzero with PACKET_ROOT_MISSING.' 'Does not prove the packet maker is broken.' $missingPacket.LogPath

$catalog = Join-Path $reportRoot 'HELPER_ERROR_CATALOG.csv'
$rows | Export-Csv -LiteralPath $catalog -NoTypeInformation -Encoding UTF8

@(
    'HELPER ERROR CATALOG',
    '',
    "Created: $(Get-Date -Format o)",
    "SeedUsed: $seedUsed",
    "Catalog: $catalog",
    "Rows: $($rows.Count)",
    '',
    'DoesNotProve:',
    'This catalog is a bounded seed list, not exhaustive coverage of every helper error.'
) | Set-Content -LiteralPath (Join-Path $runRoot 'OPEN_THIS_FIRST.txt') -Encoding UTF8

Write-Output "HELPER_ERROR_CATALOG_BUILT: $catalog"
Write-Output "ROWS: $($rows.Count)"
Write-Output 'DOES_NOT_PROVE: This catalog is bounded and does not authorize risky induced failures.'
