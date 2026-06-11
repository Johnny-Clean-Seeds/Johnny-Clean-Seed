$ErrorActionPreference = 'Stop'

$RepoRoot = Join-Path $env:USERPROFILE 'Desktop\123'
$OutDir = Join-Path $RepoRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

function Get-Sha256Text {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Assert-FileHash {
    param(
        [string]$Path,
        [string]$ExpectedHash,
        [string]$Label
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing required file for ${Label}: $Path"
    }
    $actual = Get-Sha256Text -Path $Path
    if ($actual -ne $ExpectedHash) {
        throw "Hash mismatch for ${Label}: expected $ExpectedHash actual $actual path $Path"
    }
    return $true
}

function Get-FirstPropertyValue {
    param(
        [object]$Row,
        [string[]]$Names
    )
    foreach ($name in $Names) {
        if ($Row.PSObject.Properties.Name -contains $name) {
            return [string]$Row.$name
        }
    }
    return ''
}

function Write-LinesUtf8 {
    param(
        [string]$Path,
        [string[]]$Lines
    )
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($Path, $Lines, $utf8NoBom)
}

if (-not (Test-Path -LiteralPath $OutDir)) {
    throw "Output directory does not exist: $OutDir"
}

$QueueCsv = Join-Path $OutDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$SelectedBatch001Csv = Join-Path $OutDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_001_V0_1_20260609.csv'
$ProofCloseoutMd = Join-Path $OutDir 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$ProofCloseoutReceipt = Join-Path $OutDir 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

[void](Assert-FileHash -Path $QueueCsv -ExpectedHash '791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43' -Label '64-row helper script review queue')
[void](Assert-FileHash -Path $SelectedBatch001Csv -ExpectedHash '65458E9677C8A05180B3A2BCA3DEF1A7F548832C7DCB58E630DEC72033D27C66' -Label 'selected batch HSRB-001')
[void](Assert-FileHash -Path $ProofCloseoutMd -ExpectedHash 'B4CE65335BEBB4771A947066CDD468B81BF9B39EB155D9D53AC3DC71C1A523EA' -Label 'HSRB-001 proof index closeout')
[void](Assert-FileHash -Path $ProofCloseoutReceipt -ExpectedHash 'D21B0116023B0D6CC9861F33D3CC38003C0A2857E06B05A14274EF2FFB9E8781' -Label 'HSRB-001 proof index closeout receipt')

$queueRows = @(Import-Csv -LiteralPath $QueueCsv)
$batch001Rows = @(Import-Csv -LiteralPath $SelectedBatch001Csv)

if ($queueRows.Count -ne 64) {
    throw "Expected 64 queue rows but found $($queueRows.Count)"
}
if ($batch001Rows.Count -ne 5) {
    throw "Expected 5 HSRB-001 rows but found $($batch001Rows.Count)"
}

$closedKeys = @{}
foreach ($row in $batch001Rows) {
    $ticket = Get-FirstPropertyValue -Row $row -Names @('TicketID','TicketId','Ticket')
    $file = Get-FirstPropertyValue -Row $row -Names @('FileName','Filename','File')
    $closedKeys[($ticket + '|' + $file)] = $true
}

$targetFiles = @(
    'BUILD_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1',
    'FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1',
    'FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_V0_2_20260608.ps1',
    'FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_V0_3_20260608.ps1',
    'FREEZE_GENERATED_RUNNER_DEEP_LAYER_AND_WRITE_SAFE_GIT_RUNNER_20260608.ps1',
    'FREEZE_GIT_SNAPSHOT_NO_WORKTREE_AND_WRITE_FIXED_RUNNER_20260608.ps1'
)

$targetSet = @{}
foreach ($name in $targetFiles) { $targetSet[$name] = $true }

$remainingRows = @()
foreach ($row in $queueRows) {
    $ticket = Get-FirstPropertyValue -Row $row -Names @('TicketID','TicketId','Ticket')
    $file = Get-FirstPropertyValue -Row $row -Names @('FileName','Filename','File')
    $key = $ticket + '|' + $file
    if (-not $closedKeys.ContainsKey($key)) {
        $remainingRows += $row
    }
}

$selectedRows = @()
foreach ($row in $remainingRows) {
    $file = Get-FirstPropertyValue -Row $row -Names @('FileName','Filename','File')
    if ($targetSet.ContainsKey($file)) {
        $selectedRows += $row
    }
}

if ($selectedRows.Count -eq 0) {
    $selectedRows = @($remainingRows | Select-Object -First 6)
}

$BatchId = 'HSRB-002'
$BatchTheme = 'GENERATED_RUNNER_SAFE_TEMPLATE_AND_FREEZE_CHAIN'
$NowStamp = Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'

$selectedObjects = @()
$sourcePresentCount = 0
$sourceMissingCount = 0
foreach ($row in $selectedRows) {
    $ticket = Get-FirstPropertyValue -Row $row -Names @('TicketID','TicketId','Ticket')
    $file = Get-FirstPropertyValue -Row $row -Names @('FileName','Filename','File')
    $role = Get-FirstPropertyValue -Row $row -Names @('RoleLabel','Role')
    $risk = Get-FirstPropertyValue -Row $row -Names @('RiskLabel','Risk')
    $sourcePath = Join-Path $RepoRoot $file
    $present = Test-Path -LiteralPath $sourcePath
    if ($present) { $sourcePresentCount++ } else { $sourceMissingCount++ }
    $sha = Get-Sha256Text -Path $sourcePath

    $selectedObjects += [pscustomobject]@{
        BatchID = $BatchId
        BatchTheme = $BatchTheme
        TicketID = $ticket
        FileName = $file
        RoleLabel = $role
        RiskLabel = $risk
        SourcePath = $sourcePath
        SourcePresent = [string]$present
        SourceSha256 = $sha
        StaticReviewOnly = 'YES'
        ExecutionAllowed = 'NO'
        RouteAllowed = 'NO'
        CleanupAllowed = 'NO'
    }
}

$OutputSelectedCsv = Join-Path $OutDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_002_V0_1_20260609.csv'
$OutputMd = Join-Path $OutDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$OutputPrint = Join-Path $OutDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceipt = Join-Path $OutDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$selectedObjects | Export-Csv -LiteralPath $OutputSelectedCsv -NoTypeInformation -Encoding UTF8

$md = @()
$md += '# HELPER SCRIPT REVIEW NEXT BATCH SELECTOR FROM 64 QUEUE - NO EXECUTION'
$md += ''
$md += '## Scope'
$md += 'Selects the next static-review-only helper script batch after HSRB-001 closeout.'
$md += ''
$md += '## Authority boundary'
$md += '- No helper script execution.'
$md += '- No route.'
$md += '- No cleanup.'
$md += '- No move/delete/rename.'
$md += '- No commit/push.'
$md += ''
$md += '## Input proofs'
$md += ('- 64-row queue verified: {0}' -f $QueueCsv)
$md += ('- HSRB-001 selected batch verified: {0}' -f $SelectedBatch001Csv)
$md += ('- HSRB-001 proof closeout verified: {0}' -f $ProofCloseoutMd)
$md += ''
$md += '## Selected batch'
$md += ('- selected_batch_id: {0}' -f $BatchId)
$md += ('- selected_batch_theme: {0}' -f $BatchTheme)
$md += ('- selected_batch_rows: {0}' -f $selectedRows.Count)
$md += ('- source_present_count: {0}' -f $sourcePresentCount)
$md += ('- source_missing_count: {0}' -f $sourceMissingCount)
$md += ''
$md += '## Rows'
foreach ($item in $selectedObjects) {
    $md += ('- {0} | {1} | {2} | {3} | present={4}' -f $item.TicketID, $item.FileName, $item.RoleLabel, $item.RiskLabel, $item.SourcePresent)
}
$md += ''
$md += '## Next single action'
$md += 'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_NO_EXECUTION'
$md += ''
$md += '## Final verdict'
$md += 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
$md += ''
$md += '## Physical actions'
$md += 'move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesUtf8 -Path $OutputMd -Lines $md

$print = @()
$print += 'HELPER SCRIPT REVIEW NEXT BATCH SELECTOR FROM 64 QUEUE - COPY PRINT'
$print += 'Purpose: select next static-review-only helper script batch. No execution.'
$print += ''
$print += ('selected_batch_id: {0}' -f $BatchId)
$print += ('selected_batch_theme: {0}' -f $BatchTheme)
$print += ('selected_batch_rows: {0}' -f $selectedRows.Count)
$print += ('source_present_count: {0}' -f $sourcePresentCount)
$print += ('source_missing_count: {0}' -f $sourceMissingCount)
$print += ''
$print += 'ROWS:'
foreach ($item in $selectedObjects) {
    $print += ('Ticket: {0}' -f $item.TicketID)
    $print += ('File:   {0}' -f $item.FileName)
    $print += ('Role:   {0}' -f $item.RoleLabel)
    $print += ('Risk:   {0}' -f $item.RiskLabel)
    $print += ('Path:   {0}' -f $item.SourcePath)
    $print += ('SHA256: {0}' -f $item.SourceSha256)
    $print += 'ExecutionAllowed: NO'
    $print += '---'
}
$print += ''
$print += 'next_single_action: BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_NO_EXECUTION'
$print += 'final_verdict: HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
$print += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesUtf8 -Path $OutputPrint -Lines $print
Set-Clipboard -Value ($print -join [Environment]::NewLine)

$selectedCsvSha = Get-Sha256Text -Path $OutputSelectedCsv
$mdSha = Get-Sha256Text -Path $OutputMd
$printSha = Get-Sha256Text -Path $OutputPrint
$blockerCount = 0
if ($sourceMissingCount -ne 0) { $blockerCount++ }

$receipt = @()
$receipt += 'HELPER SCRIPT REVIEW NEXT BATCH SELECTOR FROM 64 QUEUE NO EXECUTION RECEIPT V0.1'
$receipt += ('created_at: {0}' -f $NowStamp)
$receipt += ('input_queue_csv_path: {0}' -f $QueueCsv)
$receipt += ('input_queue_csv_sha256: {0}' -f (Get-Sha256Text -Path $QueueCsv))
$receipt += ('input_hsrb_001_selected_batch_path: {0}' -f $SelectedBatch001Csv)
$receipt += ('input_hsrb_001_selected_batch_sha256: {0}' -f (Get-Sha256Text -Path $SelectedBatch001Csv))
$receipt += ('input_hsrb_001_proof_closeout_path: {0}' -f $ProofCloseoutMd)
$receipt += ('input_hsrb_001_proof_closeout_sha256: {0}' -f (Get-Sha256Text -Path $ProofCloseoutMd))
$receipt += ('output_selected_batch_csv_path: {0}' -f $OutputSelectedCsv)
$receipt += ('output_selected_batch_csv_sha256: {0}' -f $selectedCsvSha)
$receipt += ('output_md_path: {0}' -f $OutputMd)
$receipt += ('output_md_sha256: {0}' -f $mdSha)
$receipt += ('output_print_path: {0}' -f $OutputPrint)
$receipt += ('output_print_sha256: {0}' -f $printSha)
$receipt += ('selected_batch_id: {0}' -f $BatchId)
$receipt += ('selected_batch_rows: {0}' -f $selectedRows.Count)
$receipt += ('source_present_count: {0}' -f $sourcePresentCount)
$receipt += ('source_missing_count: {0}' -f $sourceMissingCount)
$receipt += ('blocker_count: {0}' -f $blockerCount)
$receipt += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesUtf8 -Path $OutputReceipt -Lines $receipt
$receiptSha = Get-Sha256Text -Path $OutputReceipt

'=== HELPER SCRIPT REVIEW NEXT BATCH SELECTOR FROM 64 QUEUE V0.1 COMPLETE ==='
"output_selected_batch_csv_path: $OutputSelectedCsv"
"output_selected_batch_csv_sha256: $selectedCsvSha"
"output_md_path: $OutputMd"
"output_md_sha256: $mdSha"
"output_print_path: $OutputPrint"
"output_print_sha256: $printSha"
"output_receipt_path: $OutputReceipt"
"output_receipt_sha256: $receiptSha"
'input_queue_verified: True'
'hsrb_001_selected_batch_verified: True'
'hsrb_001_proof_closeout_verified: True'
'queue_review_rows: 64'
"selected_batch_id: $BatchId"
"selected_batch_rows: $($selectedRows.Count)"
"source_present_count: $sourcePresentCount"
"source_missing_count: $sourceMissingCount"
"blocker_count: $blockerCount"
'next_single_action: BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_NO_EXECUTION'
'final_verdict: HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
