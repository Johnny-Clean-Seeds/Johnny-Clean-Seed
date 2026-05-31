[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string]$WorkbenchRoot,
    [string]$OutputRoot
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
}
if ([string]::IsNullOrWhiteSpace($WorkbenchRoot)) {
    $WorkbenchRoot = Split-Path -Parent $RepoRoot
}
if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $OutputRoot = Join-Path $WorkbenchRoot '_LOCAL_CUSTODY_AND_RECEIPTS\ASSISTANT_CONTEXT_CARRIER_RUNS_20260531'
}

$runId = Get-Date -Format 'yyyyMMdd_HHmmss'
$outDir = Join-Path $OutputRoot "RUN_$runId"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$carrierPath = Join-Path $outDir 'ASSISTANT_CONTEXT_CARRIER.md'
$sourceMapPath = Join-Path $outDir 'ASSISTANT_CONTEXT_CARRIER_SOURCE_MAP.csv'
$doesNotProvePath = Join-Path $outDir 'ASSISTANT_CONTEXT_CARRIER_DOES_NOT_PROVE.md'
$redactionPath = Join-Path $outDir 'ASSISTANT_CONTEXT_CARRIER_REDACTION_CHECK.csv'
$receiptPath = Join-Path $outDir 'ASSISTANT_CONTEXT_CARRIER_RECEIPT.txt'

function Invoke-GitRead {
    param([string[]]$GitArgs)
    try {
        $output = & git -C $RepoRoot @GitArgs 2>&1
        return [pscustomobject]@{
            Ok = ($LASTEXITCODE -eq 0)
            Text = (($output | ForEach-Object { "$_" }) -join "`n").Trim()
        }
    } catch {
        return [pscustomobject]@{ Ok = $false; Text = $_.Exception.Message }
    }
}

function First-Line {
    param([string]$Text)
    if ([string]::IsNullOrWhiteSpace($Text)) { return 'UNKNOWN' }
    return (($Text -split "`r?`n") | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -First 1)
}

function Get-FileHashOrMissing {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 'MISSING' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-SourceMapRow {
    param(
        [System.Collections.Generic.List[object]]$Rows,
        [string]$FieldName,
        [string]$ValueSummary,
        [string]$SourcePath,
        [string]$SourceType,
        [string]$CarryClass,
        [string]$Freshness,
        [string]$HashOrReceiptIfKnown,
        [string]$DoesNotProve,
        [string]$RedactionLevel
    )
    $Rows.Add([pscustomobject]@{
        FieldName = $FieldName
        ValueSummary = $ValueSummary
        SourcePath = $SourcePath
        SourceType = $SourceType
        CarryClass = $CarryClass
        Freshness = $Freshness
        HashOrReceiptIfKnown = $HashOrReceiptIfKnown
        DoesNotProve = $DoesNotProve
        RedactionLevel = $RedactionLevel
    }) | Out-Null
}

$generatedAt = Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'
$head = Invoke-GitRead -GitArgs @('rev-parse','HEAD')
$origin = Invoke-GitRead -GitArgs @('rev-parse','origin/main')
$status = Invoke-GitRead -GitArgs @('status','--short')
$ignored = Invoke-GitRead -GitArgs @('status','--ignored','--short')

$headValue = First-Line $head.Text
$originValue = First-Line $origin.Text
$headEqualsOrigin = if ($head.Ok -and $origin.Ok) { [string]::Equals($headValue, $originValue, [System.StringComparison]::OrdinalIgnoreCase) } else { 'UNKNOWN' }
$statusLines = if ([string]::IsNullOrWhiteSpace($status.Text)) { @() } else { @($status.Text -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) }
$ignoredLines = if ([string]::IsNullOrWhiteSpace($ignored.Text)) { @() } else { @($ignored.Text -split "`r?`n" | Where-Object { $_ -like '!!*' }) }

$rootFiles = @(Get-ChildItem -LiteralPath $WorkbenchRoot -File -Force | Where-Object { $_.Name -ne 'desktop.ini' } | Sort-Object Name)
$rootState = if ($rootFiles.Count -eq 0) { 'CLEAR_EXCEPT_SYSTEM_FILES' } else { "LOOSE_FILES_PRESENT=$($rootFiles.Count)" }
$rootNames = if ($rootFiles.Count -eq 0) { 'none' } else { (($rootFiles | Select-Object -ExpandProperty Name) -join '; ') }

$activeAnchorPath = Join-Path $RepoRoot 'ACTIVE_ANCHOR.txt'
$startLedgerPath = Join-Path $RepoRoot 'START_HERE_CURRENT_HOUSE_LEDGER.md'
$statusPath = Join-Path $RepoRoot 'HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md'
$alignmentRoomPath = Join-Path $RepoRoot 'HOUSE_WORK\SYSTEM_ALIGNMENT_ROOM\HELPER_LOGIC_RULE_MIRROR_20260531\CURRENT_GAME_PLAN_BOARD_20260531.md'
$carrierRoomPath = Join-Path $RepoRoot 'HOUSE_WORK\SYSTEM_ALIGNMENT_ROOM\ASSISTANT_CONTEXT_CARRIER_20260531\README.md'
$bridgeRoutePath = Join-Path $RepoRoot 'HOUSE_WORK\WORK_SHED\INDEXES\CLAIM_CAPABILITY_BRIDGE_HARNESS_ROUTE_INDEX_20260531.md'
$frontDoorLedgerPath = Join-Path $RepoRoot 'HOUSE_WORK\WORK_SHED\INDEXES\LIVING_SYSTEM_FRONT_DOOR_LEDGER_V1_4_20260530.md'
$carrierSourceRoom = Join-Path $RepoRoot 'HOUSE_WORK\SYSTEM_ALIGNMENT_ROOM\ASSISTANT_CONTEXT_CARRIER_20260531'

$anchorText = if (Test-Path -LiteralPath $activeAnchorPath -PathType Leaf) { Get-Content -LiteralPath $activeAnchorPath -Raw } else { '' }
$anchorCurrent = First-Line (($anchorText -split "`r?`n" | Where-Object { $_ -like 'Current:*' }) -join "`n")
$anchorNext = First-Line (($anchorText -split "`r?`n" | Where-Object { $_ -like 'Next:*' }) -join "`n")
$anchorBoundary = First-Line (($anchorText -split "`r?`n" | Where-Object { $_ -like 'Boundary:*' }) -join "`n")
$activeObjectLabel = if ($anchorCurrent -like 'Current:*') { $anchorCurrent.Substring('Current:'.Length).Trim() } else { $anchorCurrent }

$trackedState = if ($statusLines.Count -eq 0) { 'Clean' } else { "DirtyCount=$($statusLines.Count)" }
$freshness = if ($headEqualsOrigin -eq $true -and $statusLines.Count -eq 0) { 'CURRENT' } elseif ($statusLines.Count -gt 0) { 'PARTIAL_DIRTY_AT_GENERATION' } else { 'NEEDS_VERIFY' }

$latestReceipts = @(
    'PROOF_HISTORY/CLAIM_CAPABILITY_CANDIDATE_SAVE_PACKET_RECEIPT_20260531.txt',
    'PROOF_HISTORY/CLAIM_CAPABILITY_LIVE_REPLAY_RECEIPT_20260531.txt',
    'PROOF_HISTORY/CLAIM_CAPABILITY_BRIDGE_HARNESS_RECEIPT_20260531.txt',
    'HOUSE_WORK/SYSTEM_ALIGNMENT_ROOM/HELPER_LOGIC_RULE_MIRROR_20260531/SYSTEM_ALIGNMENT_CHECK_V1_20260531_RECEIPT.txt'
)

$carrier = @"
# Assistant Context Carrier

GeneratedAt: $generatedAt
Freshness: $freshness
ActualSourceRoot: $WorkbenchRoot
CleanWorkbenchRoot: $WorkbenchRoot
RepoRoot: $RepoRoot
Head: $headValue
OriginMain: $originValue
HeadEqualsOrigin: $headEqualsOrigin
TrackedStatus: $trackedState
IgnoredImportantWatch: IgnoredCount=$($ignoredLines.Count)
RootLooseState: $rootState
RootLooseNames: $rootNames
CurrentAnchor: $anchorCurrent
CurrentActiveObject: $activeObjectLabel
CurrentNextObject: $anchorNext
CurrentRoute: START_HERE -> FRONT_DOOR_LEDGER -> HELPER_LOGIC_RULE_MIRROR -> ASSISTANT_CONTEXT_CARRIER -> CLAIM_CAPABILITY_FRONT_DOOR_WIRING
LatestClosedObjects:
- Helper logic alignment room saved and pushed.
- Past-week idea/concept capture saved and pushed.
- Claim/capability bridge harness candidate support saved.
OpenBlockers:
- No active blocker in carrier generation.
- Local carrier freshness expires when repo/root/status changes.
LocalOnlyEvidence:
- Root packet intake and carrier runs live under _LOCAL_CUSTODY_AND_RECEIPTS.
SupportSurfacesNotApproval:
- Concept ledgers, local helper capability pack, support reports, helper outputs, route indexes.
ApprovalReceipts:
$((($latestReceipts | ForEach-Object { "- $_" }) -join "`r`n"))
StaleOrSuperseded:
- Any older chat carry that claims root clean, commit, or next object without current file proof.
MuleVacationFallback:
- Read this carrier, source map, ACTIVE_ANCHOR, START_HERE, and current game-plan board.
- If conflict appears, freeze and classify support surface versus approval receipt.
AssistantDoNotAssume:
- Do not infer current file state from chat memory.
- Do not infer approval from receipt existence.
- Do not infer tracked custody from Git clean.
- Do not infer helper authority from helper recommendation.
- Do not infer root concepts were applied from root being empty.
SourceMap: $sourceMapPath

END_ASSISTANT_CONTEXT_CARRIER
"@

Set-Content -LiteralPath $carrierPath -Value $carrier -Encoding UTF8

$sourceRows = [System.Collections.Generic.List[object]]::new()
Add-SourceMapRow $sourceRows 'GeneratedAt' $generatedAt $carrierPath 'generated output' 'LOCAL_REPORT' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $carrierPath) 'Does not prove future freshness.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'Freshness' $freshness $carrierPath 'generated output' 'LOCAL_REPORT' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $carrierPath) 'Does not prove status after generation.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'ActualSourceRoot' $WorkbenchRoot $startLedgerPath 'tracked pointer' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $startLedgerPath) 'Does not prove every child file is current.' 'POINTER_ONLY'
Add-SourceMapRow $sourceRows 'RepoRoot' $RepoRoot $RepoRoot 'git probe' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' 'git rev-parse/status probe' 'Does not prove local-only custody is tracked.' 'POINTER_ONLY'
Add-SourceMapRow $sourceRows 'Head' $headValue $RepoRoot 'git probe' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' 'git rev-parse HEAD' 'Does not prove remote remains unchanged.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'OriginMain' $originValue $RepoRoot 'git probe' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' 'git rev-parse origin/main' 'Does not prove network freshness after generation.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'HeadEqualsOrigin' "$headEqualsOrigin" $RepoRoot 'git probe' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' 'HEAD/origin comparison' 'Does not prove ignored files are handled.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'TrackedStatus' $trackedState $RepoRoot 'git status' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' 'git status --short' 'Does not prove ignored files are irrelevant.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'IgnoredImportantWatch' "IgnoredCount=$($ignoredLines.Count)" $RepoRoot 'git status ignored' 'SUPPORT_SURFACE' 'CURRENT_AT_GENERATION' 'git status --ignored --short' 'Does not prove ignored files should be saved.' 'POINTER_ONLY'
Add-SourceMapRow $sourceRows 'RootLooseState' $rootState $WorkbenchRoot 'root file walk' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' 'Get-ChildItem root files' 'Does not prove concepts were applied unless intake receipt exists.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'CurrentAnchor' $anchorCurrent $activeAnchorPath 'tracked anchor' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $activeAnchorPath) 'Does not authorize beyond boundary.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'CurrentNextObject' $anchorNext $activeAnchorPath 'tracked anchor' 'NEXT_OBJECT' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $activeAnchorPath) 'Does not prove implementation is authorized.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'CurrentRoute' 'Start -> front door -> alignment -> carrier -> next wiring' $startLedgerPath 'tracked route pointer' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $startLedgerPath) 'Does not require loading all route files.' 'SAFE_TO_CHAT'
Add-SourceMapRow $sourceRows 'AlignmentRoom' $alignmentRoomPath $alignmentRoomPath 'tracked board' 'SUPPORT_SURFACE' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $alignmentRoomPath) 'Does not adopt doctrine.' 'POINTER_ONLY'
Add-SourceMapRow $sourceRows 'CarrierRoom' $carrierSourceRoom $carrierRoomPath 'tracked room' 'SUPPORT_SURFACE' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $carrierRoomPath) 'Does not prove local generated carrier is current later.' 'POINTER_ONLY'
Add-SourceMapRow $sourceRows 'BridgeRoute' $bridgeRoutePath $bridgeRoutePath 'tracked route' 'SUPPORT_SURFACE' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $bridgeRoutePath) 'Does not implement Front Door wiring.' 'POINTER_ONLY'
Add-SourceMapRow $sourceRows 'FrontDoorLedger' $frontDoorLedgerPath $frontDoorLedgerPath 'tracked route' 'LIVE_ANCHOR' 'CURRENT_AT_GENERATION' (Get-FileHashOrMissing $frontDoorLedgerPath) 'Does not authorize broad load.' 'POINTER_ONLY'

$sourceRows | Export-Csv -LiteralPath $sourceMapPath -NoTypeInformation -Encoding UTF8

$doesNotProve = @"
# Assistant Context Carrier Does Not Prove

- Does not prove future freshness after generation.
- Does not prove ignored files are irrelevant.
- Does not prove local-only evidence is Git-saved.
- Does not prove root concepts were read/applied merely because root is clear.
- Does not prove support surfaces are approval receipts.
- Does not prove helper outputs are final judgment.
- Does not authorize doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, watcher, automation, broad refactor, stale-route retirement, helper-school install, or promotion.
"@
Set-Content -LiteralPath $doesNotProvePath -Value $doesNotProve -Encoding UTF8

$carrierText = Get-Content -LiteralPath $carrierPath -Raw
$redactionRows = @(
    [pscustomobject]@{ Check = 'NO_RAW_CODE_FENCE'; Result = if ($carrierText -match '```') { 'FAIL' } else { 'PASS' }; Detail = 'Carrier should not dump raw code.' },
    [pscustomobject]@{ Check = 'NO_SECRET_TOKEN_PATTERNS'; Result = if ($carrierText -match '(?i)(api[_-]?key|secret|password|token=)') { 'REVIEW' } else { 'PASS' }; Detail = 'Carrier should not expose secrets.' },
    [pscustomobject]@{ Check = 'SOURCE_MAP_EXISTS'; Result = if (Test-Path -LiteralPath $sourceMapPath -PathType Leaf) { 'PASS' } else { 'FAIL' }; Detail = $sourceMapPath },
    [pscustomobject]@{ Check = 'DOES_NOT_PROVE_EXISTS'; Result = if (Test-Path -LiteralPath $doesNotProvePath -PathType Leaf) { 'PASS' } else { 'FAIL' }; Detail = $doesNotProvePath },
    [pscustomobject]@{ Check = 'ROOT_CONTENT_NOT_DUMPED'; Result = if ($rootNames.Length -lt 500) { 'PASS' } else { 'REVIEW' }; Detail = 'Root file names only, no file content.' }
)
$redactionRows | Export-Csv -LiteralPath $redactionPath -NoTypeInformation -Encoding UTF8

$carrierHash = Get-FileHashOrMissing $carrierPath
$sourceMapHash = Get-FileHashOrMissing $sourceMapPath
$receipt = @"
ASSISTANT_CONTEXT_CARRIER_RECEIPT
RunId: $runId
GeneratedAt: $generatedAt
OutputDir: $outDir
Carrier: $carrierPath
CarrierSha256: $carrierHash
SourceMap: $sourceMapPath
SourceMapSha256: $sourceMapHash
DoesNotProve: $doesNotProvePath
RedactionCheck: $redactionPath
Freshness: $freshness
Head: $headValue
OriginMain: $originValue
HeadEqualsOrigin: $headEqualsOrigin
TrackedStatus: $trackedState
RootLooseState: $rootState
Boundary: local read/report carrier only; no Git write; no move/delete; no doctrine; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX; no watcher; no automation.
"@
Set-Content -LiteralPath $receiptPath -Value $receipt -Encoding UTF8

Write-Host 'ASSISTANT_CONTEXT_CARRIER_COMPLETE'
Write-Host "RunId: $runId"
Write-Host "OutputDir: $outDir"
Write-Host "Carrier: $carrierPath"
Write-Host "CarrierSha256: $carrierHash"
Write-Host "SourceMap: $sourceMapPath"
Write-Host "SourceMapSha256: $sourceMapHash"
Write-Host "Freshness: $freshness"
Write-Host "RootLooseState: $rootState"
