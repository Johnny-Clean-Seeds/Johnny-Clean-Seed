# BUILD_HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1
# Purpose: Close out the HSRB-001 proof index as review/proof only.
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

$OutputCloseoutPath = Join-Path $WorkDir 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$OutputPrintPath = Join-Path $WorkDir 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $WorkDir 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

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

function Add-Line {
    param(
        [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$List,
        [AllowNull()][object]$Text
    )
    if ($null -eq $Text) { $Text = '' }
    [void]$List.Add([string]$Text)
}

function Get-RowJoinedText {
    param([Parameter(Mandatory=$true)][object]$Row)
    $parts = New-Object System.Collections.Generic.List[string]
    foreach ($prop in $Row.PSObject.Properties) {
        if ($null -ne $prop.Value) {
            [void]$parts.Add([string]$prop.Value)
        }
    }
    return ($parts -join ' ')
}

if (-not (Test-Path -LiteralPath $WorkDir -PathType Container)) {
    throw "Missing work directory: $WorkDir"
}

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
$finalVerdict = 'HSRB_001_PROOF_INDEX_CLOSEOUT_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
if ($blockerCount -ne 0) {
    $nextSingleAction = 'STOP_AND_REVIEW_HSRB_001_PROOF_INDEX_CLOSEOUT_BLOCKERS_NO_EXECUTION'
    $finalVerdict = 'HSRB_001_PROOF_INDEX_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$closeout = New-Object System.Collections.Generic.List[string]
Add-Line $closeout '# HSRB-001 PROOF INDEX CLOSEOUT - NO EXECUTION'
Add-Line $closeout ''
Add-Line $closeout 'Status: REVIEW_PROOF_INDEX_CLOSEOUT_ONLY'
Add-Line $closeout 'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Add-Line $closeout ''
Add-Line $closeout '## Inputs verified'
Add-Line $closeout ("- index_csv_verified: {0}" -f $indexCsvVerified)
Add-Line $closeout ("- index_md_verified: {0}" -f $indexMdVerified)
Add-Line $closeout ("- index_print_verified: {0}" -f $indexPrintVerified)
Add-Line $closeout ("- index_receipt_verified: {0}" -f $indexReceiptVerified)
Add-Line $closeout ("- decision_closeout_verified: {0}" -f $decisionCloseoutVerified)
Add-Line $closeout ''
Add-Line $closeout '## Counts'
Add-Line $closeout ("- selected_batch_id: HSRB-001")
Add-Line $closeout ("- selected_batch_rows: {0}" -f $selectedBatchRows)
Add-Line $closeout ("- last_passing_proof_count: {0}" -f $lastPassingProofCount)
Add-Line $closeout ("- superseded_failed_attempt_count: {0}" -f $supersededFailedAttemptCount)
Add-Line $closeout ("- unknown_index_role_count: {0}" -f $unknownIndexRoleCount)
Add-Line $closeout ''
Add-Line $closeout '## Safety scan counts from proof index rows'
Add-Line $closeout ("- contains_move_item_count: {0}" -f $containsMoveItemCount)
Add-Line $closeout ("- contains_remove_item_count: {0}" -f $containsRemoveItemCount)
Add-Line $closeout ("- contains_rename_item_count: {0}" -f $containsRenameItemCount)
Add-Line $closeout ("- contains_start_process_count: {0}" -f $containsStartProcessCount)
Add-Line $closeout ("- contains_invoke_expression_count: {0}" -f $containsInvokeExpressionCount)
Add-Line $closeout ''
Add-Line $closeout '## Decision'
Add-Line $closeout 'HSRB-001 is closed as a proof/index branch. The last-passing proof is preserved as proof only. The four failed attempts remain superseded failure history. No helper in this batch is approved for execution or routing.'
Add-Line $closeout ''
Add-Line $closeout ("blocker_count: {0}" -f $blockerCount)
Add-Line $closeout ("next_single_action: {0}" -f $nextSingleAction)
Add-Line $closeout ("final_verdict: {0}" -f $finalVerdict)
Add-Line $closeout 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

$closeout | Set-Content -LiteralPath $OutputCloseoutPath -Encoding UTF8

$print = New-Object System.Collections.Generic.List[string]
Add-Line $print 'HSRB-001 PROOF INDEX CLOSEOUT - COPY PRINT'
Add-Line $print ''
Add-Line $print 'Plain meaning:'
Add-Line $print 'HSRB-001 is closed as proof only. One helper is kept as last-passing proof. Four earlier helpers are superseded failed attempts. Nothing is executable from this closeout.'
Add-Line $print ''
Add-Line $print ("selected_batch_rows: {0}" -f $selectedBatchRows)
Add-Line $print ("last_passing_proof_count: {0}" -f $lastPassingProofCount)
Add-Line $print ("superseded_failed_attempt_count: {0}" -f $supersededFailedAttemptCount)
Add-Line $print ("unknown_index_role_count: {0}" -f $unknownIndexRoleCount)
Add-Line $print ("blocker_count: {0}" -f $blockerCount)
Add-Line $print ("next_single_action: {0}" -f $nextSingleAction)
Add-Line $print 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
$print | Set-Content -LiteralPath $OutputPrintPath -Encoding UTF8
try { Set-Clipboard -Value ($print -join [Environment]::NewLine) } catch { }

$outputCloseoutSha = Get-Sha256Upper -Path $OutputCloseoutPath
$outputPrintSha = Get-Sha256Upper -Path $OutputPrintPath

$receipt = New-Object System.Collections.Generic.List[string]
Add-Line $receipt 'HSRB-001 PROOF INDEX CLOSEOUT RECEIPT V0.1'
Add-Line $receipt ("output_closeout_path: {0}" -f $OutputCloseoutPath)
Add-Line $receipt ("output_closeout_sha256: {0}" -f $outputCloseoutSha)
Add-Line $receipt ("output_closeout_print_path: {0}" -f $OutputPrintPath)
Add-Line $receipt ("output_closeout_print_sha256: {0}" -f $outputPrintSha)
Add-Line $receipt ("selected_batch_rows: {0}" -f $selectedBatchRows)
Add-Line $receipt ("last_passing_proof_count: {0}" -f $lastPassingProofCount)
Add-Line $receipt ("superseded_failed_attempt_count: {0}" -f $supersededFailedAttemptCount)
Add-Line $receipt ("unknown_index_role_count: {0}" -f $unknownIndexRoleCount)
Add-Line $receipt ("blocker_count: {0}" -f $blockerCount)
Add-Line $receipt ("next_single_action: {0}" -f $nextSingleAction)
Add-Line $receipt ("final_verdict: {0}" -f $finalVerdict)
Add-Line $receipt 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
$receipt | Set-Content -LiteralPath $OutputReceiptPath -Encoding UTF8
$outputReceiptSha = Get-Sha256Upper -Path $OutputReceiptPath

'=== HSRB-001 PROOF INDEX CLOSEOUT V0.1 COMPLETE ==='
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
