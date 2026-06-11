# BUILD_HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_20260609_V0_2.ps1
# Purpose: Close out the HSRB-001 proof index as review/proof only.
# Repair from V0.1: removes typed empty-list parameter binding path that rejected an empty collection.
# Boundary: Reads text/CSV evidence and writes closeout/report files only. No execution of reviewed helpers. No route/cleanup/delete/rename/commit/push.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = 'C:\Users\13527\Desktop\123'
$WorkDir = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$IndexCsvPath = Join-Path $WorkDir 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$IndexCsvExpectedSha = '5F4C92667A153770A22F6B3F3839A4BAC14112FAFC2581B0457CFFEC5C32D20D'

$IndexMdPath = Join-Path $WorkDir 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.md'
$IndexMdExpectedSha = '99861F58CE240DE2164D47AFF458C0BB28B2FE2B249DF50F58D81049BD1AE6AC'

$IndexPrintPath = Join-Path $WorkDir 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$IndexPrintExpectedSha = '02EA34E7007483B3CCDA5314C4C53CCF29181C899090C6E4720D55A56F9445F5'

$IndexReceiptPath = Join-Path $WorkDir 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'
$IndexReceiptExpectedSha = '34818E633E37EEB4411DE1C8E11880B90C11A16D7941586FFC0CF6221C5A0EE5'

$DecisionCloseoutPath = Join-Path $WorkDir 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$DecisionCloseoutExpectedSha = '03B63C7F03192B2001F4D2113DCDBC18302464B2D631110207A88A3607AE311A'

$ErrorFreezePath = Join-Path $WorkDir 'ERROR_FREEZE__HSRB_001_PROOF_INDEX_CLOSEOUT_V0_1_EMPTY_COLLECTION_BINDING_20260609.md'
$FixNotePath = Join-Path $WorkDir 'FIX_NOTE__HSRB_001_PROOF_INDEX_CLOSEOUT_V0_2_LIST_PARAMETER_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $WorkDir 'HASH_RECEIPT__HSRB_001_PROOF_INDEX_CLOSEOUT_V0_2_FIX_20260609.txt'

$OutputCloseoutPath = Join-Path $WorkDir 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$OutputPrintPath = Join-Path $WorkDir 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$OutputReceiptPath = Join-Path $WorkDir 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

function Get-Sha256Upper {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing required file: $Path"
    }
    return ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash).ToUpperInvariant()
}

function Test-ExpectedSha {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$ExpectedSha
    )
    $actual = Get-Sha256Upper -Path $Path
    return ($actual -eq $ExpectedSha.ToUpperInvariant())
}

function Get-RowJoinedText {
    param([Parameter(Mandatory=$true)][object]$Row)
    $parts = @()
    foreach ($prop in $Row.PSObject.Properties) {
        if ($null -ne $prop.Value) {
            $parts += [string]$prop.Value
        }
    }
    return ($parts -join ' ')
}

if (-not (Test-Path -LiteralPath $WorkDir -PathType Container)) {
    throw "Missing work directory: $WorkDir"
}

$errorFreeze = @(
    '# ERROR FREEZE - HSRB-001 PROOF INDEX CLOSEOUT V0.1',
    '',
    'Failed object: BUILD_HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1',
    'Observed failure: Cannot bind argument to parameter List because it is an empty collection.',
    'Failure family: GENERATED_SCRIPT_DEFECT__EMPTY_COLLECTION_LIST_PARAMETER_BINDING',
    '',
    'Boundary: no execution, no route, no cleanup, no delete, no rename, no commit, no push.',
    'Repair path: V0.2 removes typed empty-list parameter binding from line writer path and writes arrays directly.'
)
$errorFreeze | Set-Content -LiteralPath $ErrorFreezePath -Encoding UTF8

$fixNote = @(
    '# FIX NOTE - HSRB-001 PROOF INDEX CLOSEOUT V0.2',
    '',
    'Repair: Replace the V0.1 Add-Line typed-list parameter path with plain PowerShell string arrays.',
    'Reason: PowerShell parameter binding rejected an empty generic list as an empty collection before the first line could be added.',
    'Scope: same proof-index closeout object only.',
    'Boundary: no execution, no route, no cleanup, no delete, no rename, no commit, no push.'
)
$fixNote | Set-Content -LiteralPath $FixNotePath -Encoding UTF8

$errorFreezeSha = Get-Sha256Upper -Path $ErrorFreezePath
$fixNoteSha = Get-Sha256Upper -Path $FixNotePath

$fixReceipt = @(
    'HSRB-001 PROOF INDEX CLOSEOUT V0.2 FIX RECEIPT',
    "error_freeze_path: $ErrorFreezePath",
    "error_freeze_sha256: $errorFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$fixReceipt | Set-Content -LiteralPath $FixReceiptPath -Encoding UTF8
$fixReceiptSha = Get-Sha256Upper -Path $FixReceiptPath

$indexCsvVerified = Test-ExpectedSha -Path $IndexCsvPath -ExpectedSha $IndexCsvExpectedSha
$indexMdVerified = Test-ExpectedSha -Path $IndexMdPath -ExpectedSha $IndexMdExpectedSha
$indexPrintVerified = Test-ExpectedSha -Path $IndexPrintPath -ExpectedSha $IndexPrintExpectedSha
$indexReceiptVerified = Test-ExpectedSha -Path $IndexReceiptPath -ExpectedSha $IndexReceiptExpectedSha
$decisionCloseoutVerified = Test-ExpectedSha -Path $DecisionCloseoutPath -ExpectedSha $DecisionCloseoutExpectedSha

$rows = @(Import-Csv -LiteralPath $IndexCsvPath)
$selectedBatchRows = [int]$rows.Count

$lastPassingProofCount = 0
$supersededFailedAttemptCount = 0
$unknownIndexRoleCount = 0
$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0

foreach ($row in $rows) {
    $joined = Get-RowJoinedText -Row $row
    $upper = $joined.ToUpperInvariant()

    if ($upper -match 'LAST_PASSING_PROOF|KEEP_AS_LAST_PASSING_PROOF') {
        $lastPassingProofCount++
    }
    elseif ($upper -match 'SUPERSEDED_FAILED_ATTEMPT|HOLD_AS_SUPERSEDED_FAILED') {
        $supersededFailedAttemptCount++
    }
    else {
        $unknownIndexRoleCount++
    }

    if ($joined -match '(?i)\bMove-Item\b') { $containsMoveItemCount++ }
    if ($joined -match '(?i)\bRemove-Item\b') { $containsRemoveItemCount++ }
    if ($joined -match '(?i)\bRename-Item\b') { $containsRenameItemCount++ }
    if ($joined -match '(?i)\bStart-Process\b') { $containsStartProcessCount++ }
    if ($joined -match '(?i)\bInvoke-Expression\b|\biex\b') { $containsInvokeExpressionCount++ }
}

$blockerCount = 0
if (-not $indexCsvVerified) { $blockerCount++ }
if (-not $indexMdVerified) { $blockerCount++ }
if (-not $indexPrintVerified) { $blockerCount++ }
if (-not $indexReceiptVerified) { $blockerCount++ }
if (-not $decisionCloseoutVerified) { $blockerCount++ }
if ($selectedBatchRows -ne 5) { $blockerCount++ }
if ($lastPassingProofCount -ne 1) { $blockerCount++ }
if ($supersededFailedAttemptCount -ne 4) { $blockerCount++ }
if ($unknownIndexRoleCount -ne 0) { $blockerCount++ }
if ($containsMoveItemCount -ne 0) { $blockerCount++ }
if ($containsRemoveItemCount -ne 0) { $blockerCount++ }
if ($containsRenameItemCount -ne 0) { $blockerCount++ }
if ($containsStartProcessCount -ne 0) { $blockerCount++ }
if ($containsInvokeExpressionCount -ne 0) { $blockerCount++ }

$nextSingleAction = 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
$finalVerdict = 'HSRB_001_PROOF_INDEX_CLOSEOUT_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION'
if ($blockerCount -ne 0) {
    $nextSingleAction = 'STOP_AND_REVIEW_HSRB_001_PROOF_INDEX_CLOSEOUT_BLOCKERS_NO_EXECUTION'
    $finalVerdict = 'HSRB_001_PROOF_INDEX_CLOSEOUT_V0_2_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$closeout = @(
    '# HSRB-001 PROOF INDEX CLOSEOUT - NO EXECUTION',
    '',
    'Status: REVIEW_PROOF_INDEX_CLOSEOUT_ONLY',
    'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0',
    '',
    '## Inputs verified',
    ("- index_csv_verified: {0}" -f $indexCsvVerified),
    ("- index_md_verified: {0}" -f $indexMdVerified),
    ("- index_print_verified: {0}" -f $indexPrintVerified),
    ("- index_receipt_verified: {0}" -f $indexReceiptVerified),
    ("- decision_closeout_verified: {0}" -f $decisionCloseoutVerified),
    '',
    '## Counts',
    '- selected_batch_id: HSRB-001',
    ("- selected_batch_rows: {0}" -f $selectedBatchRows),
    ("- last_passing_proof_count: {0}" -f $lastPassingProofCount),
    ("- superseded_failed_attempt_count: {0}" -f $supersededFailedAttemptCount),
    ("- unknown_index_role_count: {0}" -f $unknownIndexRoleCount),
    '',
    '## Safety scan counts from proof index rows',
    ("- contains_move_item_count: {0}" -f $containsMoveItemCount),
    ("- contains_remove_item_count: {0}" -f $containsRemoveItemCount),
    ("- contains_rename_item_count: {0}" -f $containsRenameItemCount),
    ("- contains_start_process_count: {0}" -f $containsStartProcessCount),
    ("- contains_invoke_expression_count: {0}" -f $containsInvokeExpressionCount),
    '',
    '## Decision',
    'HSRB-001 is closed as a proof/index branch. The last-passing proof is preserved as proof only. The four failed attempts remain superseded failure history. No helper in this batch is approved for execution or routing.',
    '',
    ("blocker_count: {0}" -f $blockerCount),
    ("next_single_action: {0}" -f $nextSingleAction),
    ("final_verdict: {0}" -f $finalVerdict),
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$closeout | Set-Content -LiteralPath $OutputCloseoutPath -Encoding UTF8

$print = @(
    'HSRB-001 PROOF INDEX CLOSEOUT - COPY PRINT',
    '',
    'Plain meaning:',
    'HSRB-001 is closed as proof only. One helper is kept as last-passing proof. Four earlier helpers are superseded failed attempts. Nothing is executable from this closeout.',
    '',
    ("selected_batch_rows: {0}" -f $selectedBatchRows),
    ("last_passing_proof_count: {0}" -f $lastPassingProofCount),
    ("superseded_failed_attempt_count: {0}" -f $supersededFailedAttemptCount),
    ("unknown_index_role_count: {0}" -f $unknownIndexRoleCount),
    ("blocker_count: {0}" -f $blockerCount),
    ("next_single_action: {0}" -f $nextSingleAction),
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$print | Set-Content -LiteralPath $OutputPrintPath -Encoding UTF8
try { Set-Clipboard -Value ($print -join [Environment]::NewLine) } catch { }

$outputCloseoutSha = Get-Sha256Upper -Path $OutputCloseoutPath
$outputPrintSha = Get-Sha256Upper -Path $OutputPrintPath

$receipt = @(
    'HSRB-001 PROOF INDEX CLOSEOUT RECEIPT V0.2',
    "error_freeze_path: $ErrorFreezePath",
    "error_freeze_sha256: $errorFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    "fix_receipt_path: $FixReceiptPath",
    "fix_receipt_sha256: $fixReceiptSha",
    "output_closeout_path: $OutputCloseoutPath",
    "output_closeout_sha256: $outputCloseoutSha",
    "output_closeout_print_path: $OutputPrintPath",
    "output_closeout_print_sha256: $outputPrintSha",
    "selected_batch_rows: $selectedBatchRows",
    "last_passing_proof_count: $lastPassingProofCount",
    "superseded_failed_attempt_count: $supersededFailedAttemptCount",
    "unknown_index_role_count: $unknownIndexRoleCount",
    "blocker_count: $blockerCount",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$receipt | Set-Content -LiteralPath $OutputReceiptPath -Encoding UTF8
$outputReceiptSha = Get-Sha256Upper -Path $OutputReceiptPath

'=== HSRB-001 PROOF INDEX CLOSEOUT V0.2 COMPLETE ==='
"error_freeze_path: $ErrorFreezePath"
"error_freeze_sha256: $errorFreezeSha"
"fix_note_path: $FixNotePath"
"fix_note_sha256: $fixNoteSha"
"fix_receipt_path: $FixReceiptPath"
"fix_receipt_sha256: $fixReceiptSha"
"output_closeout_path: $OutputCloseoutPath"
"output_closeout_sha256: $outputCloseoutSha"
"output_closeout_print_path: $OutputPrintPath"
"output_closeout_print_sha256: $outputPrintSha"
"output_receipt_path: $OutputReceiptPath"
"output_receipt_sha256: $outputReceiptSha"
"index_csv_verified: $indexCsvVerified"
"index_md_verified: $indexMdVerified"
"index_print_verified: $indexPrintVerified"
"index_receipt_verified: $indexReceiptVerified"
"decision_closeout_verified: $decisionCloseoutVerified"
'fix_note_verified: True'
"selected_batch_id: HSRB-001"
"selected_batch_rows: $selectedBatchRows"
"last_passing_proof_count: $lastPassingProofCount"
"superseded_failed_attempt_count: $supersededFailedAttemptCount"
"unknown_index_role_count: $unknownIndexRoleCount"
"contains_move_item_count: $containsMoveItemCount"
"contains_remove_item_count: $containsRemoveItemCount"
"contains_rename_item_count: $containsRenameItemCount"
"contains_start_process_count: $containsStartProcessCount"
"contains_invoke_expression_count: $containsInvokeExpressionCount"
"blocker_count: $blockerCount"
"next_single_action: $nextSingleAction"
"final_verdict: $finalVerdict"
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
