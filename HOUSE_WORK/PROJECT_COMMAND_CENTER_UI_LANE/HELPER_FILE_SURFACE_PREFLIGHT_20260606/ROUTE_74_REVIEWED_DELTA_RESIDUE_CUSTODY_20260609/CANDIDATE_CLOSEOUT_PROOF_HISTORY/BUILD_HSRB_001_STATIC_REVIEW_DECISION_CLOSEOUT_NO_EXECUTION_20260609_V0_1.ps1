# BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1
# Purpose: close out the static review packet for HSRB-001 without executing, moving, deleting, renaming, routing, committing, or pushing anything.
# Boundary: read-only verification of previously generated artifacts plus writing closeout/report/receipt files only.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = 'C:\Users\13527\Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$Expected = [ordered]@{
    PacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_2_20260609.md'
    PacketMdSha256 = '3EB8D2223F0685216227D146FBF95515D71F8F6F4CEA000EF0DC2A0E5F6A03D1'
    SummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_SUMMARY_V0_2_20260609.csv'
    SummaryCsvSha256 = '9C2E922097CB4C9DC35F931678A3D70F87B56037978FCD8A45213DA46375721D'
    PrintPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_COPY_PRINT_V0_2_20260609.txt'
    PrintSha256 = '542422B7754B1B50FD9FB2A539E70EC98A5BA3069BCA8A252B356E8DB4ABEE88'
    ReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_RECEIPT_V0_2_20260609.txt'
    ReceiptSha256 = '595200DD309D26DFBD4D8F7DB1DC74A6D0E1EB46E9E7BC9E1D4890C906D8CF08'
}

$CloseoutPath = Join-Path $Lane 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$CloseoutReceiptPath = Join-Path $Lane 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

function Get-Sha256Text {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Required file missing: $Path"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Test-ExpectedHash {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$ExpectedHash
    )
    $actual = Get-Sha256Text -Path $Path
    return ($actual -eq $ExpectedHash.ToUpperInvariant())
}

$packetMdVerified = Test-ExpectedHash -Path $Expected.PacketMdPath -ExpectedHash $Expected.PacketMdSha256
$summaryCsvVerified = Test-ExpectedHash -Path $Expected.SummaryCsvPath -ExpectedHash $Expected.SummaryCsvSha256
$printVerified = Test-ExpectedHash -Path $Expected.PrintPath -ExpectedHash $Expected.PrintSha256
$receiptVerified = Test-ExpectedHash -Path $Expected.ReceiptPath -ExpectedHash $Expected.ReceiptSha256

$blockers = @()
if (-not $packetMdVerified) { $blockers += 'STATIC_REVIEW_PACKET_MD_HASH_MISMATCH' }
if (-not $summaryCsvVerified) { $blockers += 'STATIC_REVIEW_SUMMARY_CSV_HASH_MISMATCH' }
if (-not $printVerified) { $blockers += 'STATIC_REVIEW_PRINT_HASH_MISMATCH' }
if (-not $receiptVerified) { $blockers += 'STATIC_REVIEW_RECEIPT_HASH_MISMATCH' }

$summaryRows = @(Import-Csv -LiteralPath $Expected.SummaryCsvPath)
$selectedBatchRows = $summaryRows.Count

$keepAsLastPassingProofCount = @($summaryRows | Where-Object { $_.Decision -eq 'KEEP_AS_LAST_PASSING_PROOF' }).Count
$holdAsSupersededFailedCount = @($summaryRows | Where-Object { $_.Decision -eq 'HOLD_AS_SUPERSEDED_FAILED_ATTEMPT' }).Count
$unknownDecisionCount = @($summaryRows | Where-Object { [string]::IsNullOrWhiteSpace($_.Decision) -or (($_.Decision -ne 'KEEP_AS_LAST_PASSING_PROOF') -and ($_.Decision -ne 'HOLD_AS_SUPERSEDED_FAILED_ATTEMPT')) }).Count

$containsMoveItemCount = @($summaryRows | Where-Object { [int]$_.ContainsMoveItem -gt 0 }).Count
$containsRemoveItemCount = @($summaryRows | Where-Object { [int]$_.ContainsRemoveItem -gt 0 }).Count
$containsRenameItemCount = @($summaryRows | Where-Object { [int]$_.ContainsRenameItem -gt 0 }).Count
$containsStartProcessCount = @($summaryRows | Where-Object { [int]$_.ContainsStartProcess -gt 0 }).Count
$containsInvokeExpressionCount = @($summaryRows | Where-Object { [int]$_.ContainsInvokeExpression -gt 0 }).Count

if ($selectedBatchRows -ne 5) { $blockers += "SELECTED_BATCH_ROW_COUNT_NOT_5_ACTUAL_$selectedBatchRows" }
if ($keepAsLastPassingProofCount -ne 1) { $blockers += "LAST_PASSING_PROOF_COUNT_NOT_1_ACTUAL_$keepAsLastPassingProofCount" }
if ($holdAsSupersededFailedCount -ne 4) { $blockers += "SUPERSEDED_FAILED_COUNT_NOT_4_ACTUAL_$holdAsSupersededFailedCount" }
if ($unknownDecisionCount -ne 0) { $blockers += "UNKNOWN_DECISION_COUNT_NOT_0_ACTUAL_$unknownDecisionCount" }
if ($containsMoveItemCount -ne 0) { $blockers += "MOVE_ITEM_PRESENT_COUNT_$containsMoveItemCount" }
if ($containsRemoveItemCount -ne 0) { $blockers += "REMOVE_ITEM_PRESENT_COUNT_$containsRemoveItemCount" }
if ($containsRenameItemCount -ne 0) { $blockers += "RENAME_ITEM_PRESENT_COUNT_$containsRenameItemCount" }
if ($containsStartProcessCount -ne 0) { $blockers += "START_PROCESS_PRESENT_COUNT_$containsStartProcessCount" }
if ($containsInvokeExpressionCount -ne 0) { $blockers += "INVOKE_EXPRESSION_PRESENT_COUNT_$containsInvokeExpressionCount" }

$blockerCount = $blockers.Count

if ($blockerCount -eq 0) {
    $nextSingleAction = 'BUILD_HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION'
    $finalVerdict = 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $nextSingleAction = 'STOP_REVIEW_BLOCKERS_BEFORE_ANY_NEXT_OBJECT'
    $finalVerdict = 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$closeoutLines = @(
    '# HSRB-001 STATIC REVIEW DECISION CLOSEOUT V0.1',
    '',
    'Status: REVIEW_CLOSEOUT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    '## Active object',
    '',
    'HSRB-001 active route-selector defect chain static review packet.',
    '',
    '## Verified inputs',
    '',
    "- packet_md_verified: $packetMdVerified",
    "- summary_csv_verified: $summaryCsvVerified",
    "- print_verified: $printVerified",
    "- receipt_verified: $receiptVerified",
    '',
    '## Static review counts',
    '',
    "- selected_batch_rows: $selectedBatchRows",
    "- keep_as_last_passing_proof_count: $keepAsLastPassingProofCount",
    "- hold_as_superseded_failed_count: $holdAsSupersededFailedCount",
    "- unknown_decision_count: $unknownDecisionCount",
    "- contains_move_item_count: $containsMoveItemCount",
    "- contains_remove_item_count: $containsRemoveItemCount",
    "- contains_rename_item_count: $containsRenameItemCount",
    "- contains_start_process_count: $containsStartProcessCount",
    "- contains_invoke_expression_count: $containsInvokeExpressionCount",
    '',
    '## Decision',
    '',
    '- Keep exactly one item as last passing proof.',
    '- Hold the four failed route-selector versions as superseded failed attempts.',
    '- Do not execute any selected helper script.',
    '- Do not route, delete, rename, move, commit, or push anything.',
    '',
    '## Blockers',
    '',
    "- blocker_count: $blockerCount"
)

if ($blockerCount -gt 0) {
    foreach ($b in $blockers) { $closeoutLines += "- $b" }
} else {
    $closeoutLines += '- none'
}

$closeoutLines += @(
    '',
    '## Next single action',
    '',
    $nextSingleAction,
    '',
    '## Final verdict',
    '',
    $finalVerdict,
    '',
    '## Physical actions',
    '',
    'move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)

$closeoutLines | Set-Content -LiteralPath $CloseoutPath -Encoding UTF8
$closeoutSha = Get-Sha256Text -Path $CloseoutPath

$receiptLines = @(
    'HSRB-001 STATIC REVIEW DECISION CLOSEOUT RECEIPT V0.1',
    "closeout_path: $CloseoutPath",
    "closeout_sha256: $closeoutSha",
    "packet_md_path: $($Expected.PacketMdPath)",
    "packet_md_sha256_expected: $($Expected.PacketMdSha256)",
    "summary_csv_path: $($Expected.SummaryCsvPath)",
    "summary_csv_sha256_expected: $($Expected.SummaryCsvSha256)",
    "selected_batch_rows: $selectedBatchRows",
    "keep_as_last_passing_proof_count: $keepAsLastPassingProofCount",
    "hold_as_superseded_failed_count: $holdAsSupersededFailedCount",
    "blocker_count: $blockerCount",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)

$receiptLines | Set-Content -LiteralPath $CloseoutReceiptPath -Encoding UTF8
$receiptSha = Get-Sha256Text -Path $CloseoutReceiptPath

'=== HSRB-001 STATIC REVIEW DECISION CLOSEOUT V0.1 COMPLETE ==='
"output_closeout_path: $CloseoutPath"
"output_closeout_sha256: $closeoutSha"
"output_receipt_path: $CloseoutReceiptPath"
"output_receipt_sha256: $receiptSha"
"packet_md_verified: $packetMdVerified"
"summary_csv_verified: $summaryCsvVerified"
"print_verified: $printVerified"
"packet_receipt_verified: $receiptVerified"
"selected_batch_rows: $selectedBatchRows"
"keep_as_last_passing_proof_count: $keepAsLastPassingProofCount"
"hold_as_superseded_failed_count: $holdAsSupersededFailedCount"
"unknown_decision_count: $unknownDecisionCount"
"contains_move_item_count: $containsMoveItemCount"
"contains_remove_item_count: $containsRemoveItemCount"
"contains_rename_item_count: $containsRenameItemCount"
"contains_start_process_count: $containsStartProcessCount"
"contains_invoke_expression_count: $containsInvokeExpressionCount"
"blocker_count: $blockerCount"
"next_single_action: $nextSingleAction"
"final_verdict: $finalVerdict"
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
