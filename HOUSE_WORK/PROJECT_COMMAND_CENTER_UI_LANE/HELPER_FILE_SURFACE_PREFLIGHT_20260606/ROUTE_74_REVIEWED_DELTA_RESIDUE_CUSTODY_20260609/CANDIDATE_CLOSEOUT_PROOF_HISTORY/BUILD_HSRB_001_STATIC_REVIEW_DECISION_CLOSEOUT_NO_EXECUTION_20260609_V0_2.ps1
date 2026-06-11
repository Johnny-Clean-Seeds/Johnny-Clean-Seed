# BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_20260609_V0_2.ps1
# Purpose: close out the static review packet for HSRB-001 without executing, moving, deleting, renaming, routing, committing, or pushing anything.
# Boundary: read-only verification of previously generated artifacts plus writing closeout/report/receipt/error-freeze/fix-note files only.
# Repair: V0.1 expected a Decision column. V0.2 uses the actual StaticDisposition column produced by the V0.2 static review packet.

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

$ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_MISSING_DECISION_PROPERTY_20260609.md'
$FixNotePath = Join-Path $Lane 'FIX_NOTE__HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_STATIC_DISPOSITION_COLUMN_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_FIX_20260609.txt'
$CloseoutPath = Join-Path $Lane 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$CloseoutReceiptPath = Join-Path $Lane 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
$CloseoutPrintPath = Join-Path $Lane 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'

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
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $false
    }
    $actual = Get-Sha256Text -Path $Path
    return ($actual -eq $ExpectedHash.ToUpperInvariant())
}

function Get-PropertyNames {
    param([AllowNull()] $Object)
    if ($null -eq $Object) { return @() }
    return @($Object.PSObject.Properties.Name)
}

function Get-BoolFromCsvValue {
    param([AllowNull()] $Value)
    $s = ([string]$Value).Trim()
    if ($s -match '^(?i:true|1|yes)$') { return $true }
    return $false
}

function Count-Where {
    param(
        [AllowNull()] $Rows,
        [Parameter(Mandatory=$true)][scriptblock] $Predicate
    )
    return [int](@($Rows | Where-Object $Predicate).Count)
}

# Freeze and fix record for the just-observed V0.1 defect.
$errorFreezeLines = @(
    '# Error Freeze - HSRB-001 Static Review Decision Closeout V0.1 Missing Decision Property',
    '',
    'Status: ERROR_FREEZE / GENERATED_SCRIPT_DEFECT / SAME_OBJECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Failed script: BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1',
    'Failure line: 56',
    'Failure expression: $summaryRows | Where-Object { $_.Decision -eq ... }',
    'Failure message: The property Decision cannot be found on this object.',
    '',
    'Classification: GENERATED_SCRIPT_DEFECT__SUMMARY_SCHEMA_MISMATCH_DECISION_COLUMN_EXPECTED_STATIC_DISPOSITION_ACTUAL',
    '',
    'Actual source summary column produced by static review packet V0.2: StaticDisposition.',
    '',
    'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$errorFreezeLines | Set-Content -LiteralPath $ErrorFreezePath -Encoding UTF8
$errorFreezeSha = Get-Sha256Text -Path $ErrorFreezePath

$fixNoteLines = @(
    '# Fix Note - HSRB-001 Static Review Decision Closeout V0.2 StaticDisposition Column Repair',
    '',
    'Status: FIX_NOTE / SAME_OBJECT_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'V0.1 failed because it expected a Decision column, but the V0.2 static review packet summary CSV writes StaticDisposition.',
    '',
    'V0.2 repair:',
    '- Read StaticDisposition as the authoritative decision/disposition field for this closeout.',
    '- Guard for missing required columns before counting.',
    '- Count boolean safety fields using safe string-to-boolean parsing rather than integer casts.',
    '- Output paths are versioned to V0.2.',
    '',
    'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$fixNoteLines | Set-Content -LiteralPath $FixNotePath -Encoding UTF8
$fixNoteSha = Get-Sha256Text -Path $FixNotePath

$fixReceiptLines = @(
    'HASH_RECEIPT__HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_FIX_20260609',
    ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')),
    ('error_freeze_path: {0}' -f $ErrorFreezePath),
    ('error_freeze_sha256: {0}' -f $errorFreezeSha),
    ('fix_note_path: {0}' -f $FixNotePath),
    ('fix_note_sha256: {0}' -f $fixNoteSha),
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$fixReceiptLines | Set-Content -LiteralPath $FixReceiptPath -Encoding UTF8
$fixReceiptSha = Get-Sha256Text -Path $FixReceiptPath

$packetMdVerified = Test-ExpectedHash -Path $Expected.PacketMdPath -ExpectedHash $Expected.PacketMdSha256
$summaryCsvVerified = Test-ExpectedHash -Path $Expected.SummaryCsvPath -ExpectedHash $Expected.SummaryCsvSha256
$printVerified = Test-ExpectedHash -Path $Expected.PrintPath -ExpectedHash $Expected.PrintSha256
$receiptVerified = Test-ExpectedHash -Path $Expected.ReceiptPath -ExpectedHash $Expected.ReceiptSha256

$blockers = @()
if (-not $packetMdVerified) { $blockers += 'STATIC_REVIEW_PACKET_MD_HASH_MISMATCH_OR_MISSING' }
if (-not $summaryCsvVerified) { $blockers += 'STATIC_REVIEW_SUMMARY_CSV_HASH_MISMATCH_OR_MISSING' }
if (-not $printVerified) { $blockers += 'STATIC_REVIEW_PRINT_HASH_MISMATCH_OR_MISSING' }
if (-not $receiptVerified) { $blockers += 'STATIC_REVIEW_RECEIPT_HASH_MISMATCH_OR_MISSING' }

$summaryRows = @()
if ($summaryCsvVerified) {
    $summaryRows = @(Import-Csv -LiteralPath $Expected.SummaryCsvPath)
}
$selectedBatchRows = [int](@($summaryRows).Count)

$propertyNames = @()
if ($selectedBatchRows -gt 0) { $propertyNames = Get-PropertyNames -Object $summaryRows[0] }

$requiredColumns = @(
    'StaticDisposition',
    'ContainsMoveItem',
    'ContainsRemoveItem',
    'ContainsRenameItem',
    'ContainsStartProcess',
    'ContainsInvokeExpression'
)
foreach ($col in $requiredColumns) {
    if ($propertyNames -notcontains $col) {
        $blockers += "REQUIRED_SUMMARY_COLUMN_MISSING_$col"
    }
}

$keepDisposition = 'KEEP_AS_LAST_PASSING_PROOF_HELPER_REVIEW_ONLY'
$holdDisposition = 'HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN'

$keepAsLastPassingProofCount = 0
$holdAsSupersededFailedCount = 0
$unknownDispositionCount = 0
$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0

if ($blockers.Count -eq 0) {
    $keepAsLastPassingProofCount = Count-Where -Rows $summaryRows -Predicate { $_.StaticDisposition -eq $keepDisposition }
    $holdAsSupersededFailedCount = Count-Where -Rows $summaryRows -Predicate { $_.StaticDisposition -eq $holdDisposition }
    $unknownDispositionCount = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace($_.StaticDisposition) -or (($_.StaticDisposition -ne $keepDisposition) -and ($_.StaticDisposition -ne $holdDisposition)) }

    $containsMoveItemCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsMoveItem }
    $containsRemoveItemCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsRemoveItem }
    $containsRenameItemCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsRenameItem }
    $containsStartProcessCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsStartProcess }
    $containsInvokeExpressionCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsInvokeExpression }
}

if ($selectedBatchRows -ne 5) { $blockers += "SELECTED_BATCH_ROW_COUNT_NOT_5_ACTUAL_$selectedBatchRows" }
if ($blockers.Count -eq 0 -and $keepAsLastPassingProofCount -ne 1) { $blockers += "LAST_PASSING_PROOF_COUNT_NOT_1_ACTUAL_$keepAsLastPassingProofCount" }
if ($blockers.Count -eq 0 -and $holdAsSupersededFailedCount -ne 4) { $blockers += "SUPERSEDED_FAILED_COUNT_NOT_4_ACTUAL_$holdAsSupersededFailedCount" }
if ($blockers.Count -eq 0 -and $unknownDispositionCount -ne 0) { $blockers += "UNKNOWN_STATIC_DISPOSITION_COUNT_NOT_0_ACTUAL_$unknownDispositionCount" }
if ($blockers.Count -eq 0 -and $containsMoveItemCount -ne 0) { $blockers += "MOVE_ITEM_PRESENT_COUNT_$containsMoveItemCount" }
if ($blockers.Count -eq 0 -and $containsRemoveItemCount -ne 0) { $blockers += "REMOVE_ITEM_PRESENT_COUNT_$containsRemoveItemCount" }
if ($blockers.Count -eq 0 -and $containsRenameItemCount -ne 0) { $blockers += "RENAME_ITEM_PRESENT_COUNT_$containsRenameItemCount" }
if ($blockers.Count -eq 0 -and $containsStartProcessCount -ne 0) { $blockers += "START_PROCESS_PRESENT_COUNT_$containsStartProcessCount" }
if ($blockers.Count -eq 0 -and $containsInvokeExpressionCount -ne 0) { $blockers += "INVOKE_EXPRESSION_PRESENT_COUNT_$containsInvokeExpressionCount" }

$blockerCount = [int]$blockers.Count

if ($blockerCount -eq 0) {
    $nextSingleAction = 'BUILD_HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION'
    $finalVerdict = 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $nextSingleAction = 'STOP_REVIEW_BLOCKERS_BEFORE_ANY_NEXT_OBJECT'
    $finalVerdict = 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$closeoutLines = @(
    '# HSRB-001 Static Review Decision Closeout V0.2',
    '',
    'Status: REVIEW_CLOSEOUT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH',
    '',
    '## Active object',
    '',
    'HSRB-001 active route-selector defect chain static review packet.',
    '',
    '## V0.1 failure repaired',
    '',
    '- V0.1 expected a Decision column.',
    '- The actual static review summary column is StaticDisposition.',
    '- V0.2 counts StaticDisposition and keeps this as same-object repair.',
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
    "- unknown_static_disposition_count: $unknownDispositionCount",
    "- contains_move_item_count: $containsMoveItemCount",
    "- contains_remove_item_count: $containsRemoveItemCount",
    "- contains_rename_item_count: $containsRenameItemCount",
    "- contains_start_process_count: $containsStartProcessCount",
    "- contains_invoke_expression_count: $containsInvokeExpressionCount",
    '',
    '## Decision',
    '',
    '- Keep exactly one item as last passing proof helper evidence.',
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

$printLines = @(
    'HSRB-001 STATIC REVIEW DECISION CLOSEOUT V0.2',
    'Static decision closeout only. No execution. No route. No cleanup.',
    '',
    "packet_md_verified: $packetMdVerified",
    "summary_csv_verified: $summaryCsvVerified",
    "print_verified: $printVerified",
    "packet_receipt_verified: $receiptVerified",
    "selected_batch_rows: $selectedBatchRows",
    "keep_as_last_passing_proof_count: $keepAsLastPassingProofCount",
    "hold_as_superseded_failed_count: $holdAsSupersededFailedCount",
    "unknown_static_disposition_count: $unknownDispositionCount",
    "contains_move_item_count: $containsMoveItemCount",
    "contains_remove_item_count: $containsRemoveItemCount",
    "contains_rename_item_count: $containsRenameItemCount",
    "contains_start_process_count: $containsStartProcessCount",
    "contains_invoke_expression_count: $containsInvokeExpressionCount",
    "blocker_count: $blockerCount",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$printLines | Set-Content -LiteralPath $CloseoutPrintPath -Encoding UTF8
$printSha = Get-Sha256Text -Path $CloseoutPrintPath

$receiptLines = @(
    'HSRB-001 STATIC REVIEW DECISION CLOSEOUT RECEIPT V0.2',
    "closeout_path: $CloseoutPath",
    "closeout_sha256: $closeoutSha",
    "closeout_print_path: $CloseoutPrintPath",
    "closeout_print_sha256: $printSha",
    "packet_md_path: $($Expected.PacketMdPath)",
    "packet_md_sha256_expected: $($Expected.PacketMdSha256)",
    "summary_csv_path: $($Expected.SummaryCsvPath)",
    "summary_csv_sha256_expected: $($Expected.SummaryCsvSha256)",
    "selected_batch_rows: $selectedBatchRows",
    "keep_as_last_passing_proof_count: $keepAsLastPassingProofCount",
    "hold_as_superseded_failed_count: $holdAsSupersededFailedCount",
    "unknown_static_disposition_count: $unknownDispositionCount",
    "blocker_count: $blockerCount",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$receiptLines | Set-Content -LiteralPath $CloseoutReceiptPath -Encoding UTF8
$receiptSha = Get-Sha256Text -Path $CloseoutReceiptPath

try {
    Set-Clipboard -Value ($printLines -join [Environment]::NewLine)
} catch {
    # Clipboard failure is non-blocking for this closeout; written files and receipt remain authority.
}

'=== HSRB-001 STATIC REVIEW DECISION CLOSEOUT V0.2 COMPLETE ==='
"error_freeze_path: $ErrorFreezePath"
"error_freeze_sha256: $errorFreezeSha"
"fix_note_path: $FixNotePath"
"fix_note_sha256: $fixNoteSha"
"fix_receipt_path: $FixReceiptPath"
"fix_receipt_sha256: $fixReceiptSha"
"output_closeout_path: $CloseoutPath"
"output_closeout_sha256: $closeoutSha"
"output_closeout_print_path: $CloseoutPrintPath"
"output_closeout_print_sha256: $printSha"
"output_receipt_path: $CloseoutReceiptPath"
"output_receipt_sha256: $receiptSha"
"packet_md_verified: $packetMdVerified"
"summary_csv_verified: $summaryCsvVerified"
"print_verified: $printVerified"
"packet_receipt_verified: $receiptVerified"
"selected_batch_rows: $selectedBatchRows"
"keep_as_last_passing_proof_count: $keepAsLastPassingProofCount"
"hold_as_superseded_failed_count: $holdAsSupersededFailedCount"
"unknown_static_disposition_count: $unknownDispositionCount"
"contains_move_item_count: $containsMoveItemCount"
"contains_remove_item_count: $containsRemoveItemCount"
"contains_rename_item_count: $containsRenameItemCount"
"contains_start_process_count: $containsStartProcessCount"
"contains_invoke_expression_count: $containsInvokeExpressionCount"
"blocker_count: $blockerCount"
"next_single_action: $nextSingleAction"
"final_verdict: $finalVerdict"
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
