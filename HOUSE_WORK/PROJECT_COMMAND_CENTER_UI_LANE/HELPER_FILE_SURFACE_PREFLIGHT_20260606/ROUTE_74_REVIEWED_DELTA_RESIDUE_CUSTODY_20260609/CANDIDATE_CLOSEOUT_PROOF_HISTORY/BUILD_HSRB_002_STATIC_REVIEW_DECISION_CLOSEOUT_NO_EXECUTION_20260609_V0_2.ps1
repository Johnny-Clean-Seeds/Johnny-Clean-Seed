# BUILD_HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_20260609_V0_2.ps1
# Purpose: close out the static review packet for HSRB-002 without executing, moving, deleting, renaming, routing, committing, or pushing anything.
# Repair over V0.1: fixes Write-Utf8NoBomLines so blank lines in the report are accepted and written safely.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = 'C:\Users\13527\Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$Expected = [ordered]@{
    PacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_20260609.md'
    PacketMdSha256 = '38FC2086733DF84975FD691502B6FA680CDD6033ABD7FF52EAFFD211359B4F8E'
    SummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_SUMMARY_V0_1_20260609.csv'
    SummaryCsvSha256 = 'D0FCC6E841F197D1C80E9D6A1E0447F323EAEF0979F618E843FC372CFDB95431'
    PrintPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_COPY_PRINT_V0_1_20260609.txt'
    PrintSha256 = '89B52B5F21248427F6D5733100A71D171495132EB6D2C80094F1CB27456AF7FF'
    ReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_RECEIPT_V0_1_20260609.txt'
    ReceiptSha256 = 'C8A18CDB8071CBA593AE8245E1C5BF6470BB8D4DDA7B7E80ED323A96F3D78026'
}

$ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_EMPTY_STRING_LINES_BINDING_20260609.md'
$FixNotePath = Join-Path $Lane 'FIX_NOTE__HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_ALLOW_EMPTY_LINES_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_FIX_20260609.txt'

$CloseoutPath = Join-Path $Lane 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$CloseoutPrintPath = Join-Path $Lane 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$CloseoutReceiptPath = Join-Path $Lane 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

function Get-Sha256Text {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { throw 'Path argument was blank.' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Required file missing: $Path"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Test-ExpectedHash {
    param(
        [string]$Path,
        [string]$ExpectedHash
    )
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    if ([string]::IsNullOrWhiteSpace($ExpectedHash)) { return $false }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $false }
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
        [scriptblock] $Predicate
    )
    if ($null -eq $Predicate) { throw 'Predicate was null.' }
    return [int](@($Rows | Where-Object $Predicate).Count)
}

function Write-Utf8NoBomLines {
    param(
        [string]$Path,
        [AllowNull()] [object[]]$Lines
    )
    if ([string]::IsNullOrWhiteSpace($Path)) { throw 'Write path was blank.' }
    if ($null -eq $Lines) { $Lines = @() }
    $stringLines = foreach ($line in @($Lines)) { [string]$line }
    $text = [string]::Join([Environment]::NewLine, @($stringLines))
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $text, $utf8NoBom)
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    throw "Output lane directory missing: $Lane"
}

$errorFreezeLines = @(
    '# ERROR FREEZE - HSRB-002 STATIC REVIEW DECISION CLOSEOUT V0.1 EMPTY STRING LINES BINDING',
    '',
    'Status: GENERATED_SCRIPT_DEFECT / SAME_OBJECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Failed script:',
    '',
    'BUILD_HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1',
    '',
    'Observed failure:',
    '',
    'Write-Utf8NoBomLines could not bind the Lines parameter because the report line array contained blank string elements and the parameter binding rejected an empty string.',
    '',
    'Failure class:',
    '',
    'GENERATED_SCRIPT_DEFECT__EMPTY_STRING_LINES_PARAMETER_BINDING',
    '',
    'Boundary:',
    '',
    'No selected helper script was executed. No move, delete, rename, route, cleanup, commit, or push was authorized or performed.'
)
Write-Utf8NoBomLines -Path $ErrorFreezePath -Lines $errorFreezeLines
$errorFreezeSha = Get-Sha256Text -Path $ErrorFreezePath

$fixNoteLines = @(
    '# FIX NOTE - HSRB-002 STATIC REVIEW DECISION CLOSEOUT V0.2 ALLOW EMPTY LINES REPAIR',
    '',
    'Status: REPAIR_NOTE / SAME_OBJECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Repair made:',
    '',
    'V0.2 replaces the brittle Write-Utf8NoBomLines function with a version that accepts object arrays, null arrays, and blank string lines. It writes using WriteAllText after joining lines manually.',
    '',
    'Scope preserved:',
    '',
    'The script still only verifies the HSRB-002 static review packet and writes closeout/report/receipt files. It does not execute any selected helper script or authorize movement, cleanup, routing, commits, or pushes.'
)
Write-Utf8NoBomLines -Path $FixNotePath -Lines $fixNoteLines
$fixNoteSha = Get-Sha256Text -Path $FixNotePath

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
if ($summaryCsvVerified) { $summaryRows = @(Import-Csv -LiteralPath $Expected.SummaryCsvPath) }
$selectedBatchRows = [int](@($summaryRows).Count)

$propertyNames = @()
if ($selectedBatchRows -gt 0) { $propertyNames = Get-PropertyNames -Object $summaryRows[0] }

$requiredColumns = @(
    'StaticDisposition',
    'ContainsMoveItem',
    'ContainsRemoveItem',
    'ContainsRenameItem',
    'ContainsStartProcess',
    'ContainsInvokeExpression',
    'ContainsGitCommand'
)
foreach ($col in $requiredColumns) {
    if ($propertyNames -notcontains $col) { $blockers += "REQUIRED_SUMMARY_COLUMN_MISSING_$col" }
}

$templateDisposition = 'REVIEW_AS_TEMPLATE_RULE_CARD_NOT_EXECUTION_AUTHORITY'
$fieldApplyDisposition = 'HOLD_AS_FIELD_APPLY_ATTEMPT_REVIEW_ONLY'
$freezeRepairDisposition = 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY'
$knownDispositions = @($templateDisposition, $fieldApplyDisposition, $freezeRepairDisposition)

$templateRuleCardCount = 0
$fieldApplyAttemptCount = 0
$freezeRepairAttemptCount = 0
$unknownStaticDispositionCount = 0
$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
$containsGitCommandCount = 0

if ($blockers.Count -eq 0) {
    $templateRuleCardCount = Count-Where -Rows $summaryRows -Predicate { $_.StaticDisposition -eq $templateDisposition }
    $fieldApplyAttemptCount = Count-Where -Rows $summaryRows -Predicate { $_.StaticDisposition -eq $fieldApplyDisposition }
    $freezeRepairAttemptCount = Count-Where -Rows $summaryRows -Predicate { $_.StaticDisposition -eq $freezeRepairDisposition }
    $unknownStaticDispositionCount = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace($_.StaticDisposition) -or ($knownDispositions -notcontains $_.StaticDisposition) }

    $containsMoveItemCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsMoveItem }
    $containsRemoveItemCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsRemoveItem }
    $containsRenameItemCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsRenameItem }
    $containsStartProcessCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsStartProcess }
    $containsInvokeExpressionCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsInvokeExpression }
    $containsGitCommandCount = Count-Where -Rows $summaryRows -Predicate { Get-BoolFromCsvValue $_.ContainsGitCommand }
}

if ($selectedBatchRows -ne 6) { $blockers += "SELECTED_BATCH_ROW_COUNT_NOT_6_ACTUAL_$selectedBatchRows" }
if ($blockers.Count -eq 0 -and $templateRuleCardCount -ne 1) { $blockers += "TEMPLATE_RULE_CARD_COUNT_NOT_1_ACTUAL_$templateRuleCardCount" }
if ($blockers.Count -eq 0 -and $fieldApplyAttemptCount -ne 3) { $blockers += "FIELD_APPLY_ATTEMPT_COUNT_NOT_3_ACTUAL_$fieldApplyAttemptCount" }
if ($blockers.Count -eq 0 -and $freezeRepairAttemptCount -ne 2) { $blockers += "FREEZE_REPAIR_ATTEMPT_COUNT_NOT_2_ACTUAL_$freezeRepairAttemptCount" }
if ($blockers.Count -eq 0 -and $unknownStaticDispositionCount -ne 0) { $blockers += "UNKNOWN_STATIC_DISPOSITION_COUNT_NOT_0_ACTUAL_$unknownStaticDispositionCount" }
if ($blockers.Count -eq 0 -and $containsMoveItemCount -ne 0) { $blockers += "MOVE_ITEM_PRESENT_COUNT_$containsMoveItemCount" }
if ($blockers.Count -eq 0 -and $containsRemoveItemCount -ne 0) { $blockers += "REMOVE_ITEM_PRESENT_COUNT_$containsRemoveItemCount" }
if ($blockers.Count -eq 0 -and $containsRenameItemCount -ne 0) { $blockers += "RENAME_ITEM_PRESENT_COUNT_$containsRenameItemCount" }
if ($blockers.Count -eq 0 -and $containsStartProcessCount -ne 0) { $blockers += "START_PROCESS_PRESENT_COUNT_$containsStartProcessCount" }
if ($blockers.Count -eq 0 -and $containsInvokeExpressionCount -ne 0) { $blockers += "INVOKE_EXPRESSION_PRESENT_COUNT_$containsInvokeExpressionCount" }
if ($blockers.Count -eq 0 -and $containsGitCommandCount -ne 6) { $blockers += "GIT_COMMAND_COUNT_NOT_EXPECTED_6_ACTUAL_$containsGitCommandCount" }

$blockerCount = [int]$blockers.Count

if ($blockerCount -eq 0) {
    $nextSingleAction = 'BUILD_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION'
    $finalVerdict = 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $nextSingleAction = 'STOP_REVIEW_BLOCKERS_BEFORE_ANY_NEXT_OBJECT'
    $finalVerdict = 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$closeoutLines = @(
    '# HSRB-002 Static Review Decision Closeout V0.2',
    '',
    'Status: REVIEW_CLOSEOUT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH',
    '',
    '## Active object',
    '',
    'HSRB-002 generated-runner safe-template/freeze chain static review packet.',
    '',
    '## Boundary',
    '',
    'This closeout verifies the HSRB-002 static review packet and summary counts. It does not execute any selected helper script. It does not move, delete, rename, route, clean up, commit, or push anything.',
    '',
    '## V0.1 failure freeze and repair',
    '',
    "- error_freeze_path: $ErrorFreezePath",
    "- error_freeze_sha256: $errorFreezeSha",
    "- fix_note_path: $FixNotePath",
    "- fix_note_sha256: $fixNoteSha",
    '',
    '## Verified inputs',
    '',
    "- packet_md_verified: $packetMdVerified",
    "- summary_csv_verified: $summaryCsvVerified",
    "- print_verified: $printVerified",
    "- packet_receipt_verified: $receiptVerified",
    '',
    '## Static review counts',
    '',
    "- selected_batch_rows: $selectedBatchRows",
    "- template_rule_card_count: $templateRuleCardCount",
    "- field_apply_attempt_count: $fieldApplyAttemptCount",
    "- freeze_repair_attempt_count: $freezeRepairAttemptCount",
    "- unknown_static_disposition_count: $unknownStaticDispositionCount",
    "- contains_move_item_count: $containsMoveItemCount",
    "- contains_remove_item_count: $containsRemoveItemCount",
    "- contains_rename_item_count: $containsRenameItemCount",
    "- contains_start_process_count: $containsStartProcessCount",
    "- contains_invoke_expression_count: $containsInvokeExpressionCount",
    "- contains_git_command_count: $containsGitCommandCount",
    '',
    '## Decision',
    '',
    '- The template-rule card is review evidence only, not doctrine and not execution authority.',
    '- The three field-apply attempts are held as review-only attempts.',
    '- The two freeze-repair attempts are held as review-only attempts.',
    '- Git-command presence is evidence noted by the static scan, not approval to run anything.',
    '- No selected helper is safe-promoted, route-approved, cleanup-approved, commit-approved, or push-approved by this closeout.',
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

Write-Utf8NoBomLines -Path $CloseoutPath -Lines $closeoutLines
$closeoutSha = Get-Sha256Text -Path $CloseoutPath

$printLines = @(
    'HSRB-002 STATIC REVIEW DECISION CLOSEOUT V0.2',
    'Static decision closeout only. No execution. No route. No cleanup.',
    '',
    "error_freeze_path: $ErrorFreezePath",
    "error_freeze_sha256: $errorFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    "packet_md_verified: $packetMdVerified",
    "summary_csv_verified: $summaryCsvVerified",
    "print_verified: $printVerified",
    "packet_receipt_verified: $receiptVerified",
    "selected_batch_rows: $selectedBatchRows",
    "template_rule_card_count: $templateRuleCardCount",
    "field_apply_attempt_count: $fieldApplyAttemptCount",
    "freeze_repair_attempt_count: $freezeRepairAttemptCount",
    "unknown_static_disposition_count: $unknownStaticDispositionCount",
    "contains_move_item_count: $containsMoveItemCount",
    "contains_remove_item_count: $containsRemoveItemCount",
    "contains_rename_item_count: $containsRenameItemCount",
    "contains_start_process_count: $containsStartProcessCount",
    "contains_invoke_expression_count: $containsInvokeExpressionCount",
    "contains_git_command_count: $containsGitCommandCount",
    "blocker_count: $blockerCount",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-Utf8NoBomLines -Path $CloseoutPrintPath -Lines $printLines
$printSha = Get-Sha256Text -Path $CloseoutPrintPath

$receiptLines = @(
    'HSRB-002 STATIC REVIEW DECISION CLOSEOUT RECEIPT V0.2',
    "error_freeze_path: $ErrorFreezePath",
    "error_freeze_sha256: $errorFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    "closeout_path: $CloseoutPath",
    "closeout_sha256: $closeoutSha",
    "closeout_print_path: $CloseoutPrintPath",
    "closeout_print_sha256: $printSha",
    "packet_md_path: $($Expected.PacketMdPath)",
    "packet_md_sha256_expected: $($Expected.PacketMdSha256)",
    "summary_csv_path: $($Expected.SummaryCsvPath)",
    "summary_csv_sha256_expected: $($Expected.SummaryCsvSha256)",
    "selected_batch_rows: $selectedBatchRows",
    "template_rule_card_count: $templateRuleCardCount",
    "field_apply_attempt_count: $fieldApplyAttemptCount",
    "freeze_repair_attempt_count: $freezeRepairAttemptCount",
    "unknown_static_disposition_count: $unknownStaticDispositionCount",
    "contains_git_command_count: $containsGitCommandCount",
    "blocker_count: $blockerCount",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-Utf8NoBomLines -Path $CloseoutReceiptPath -Lines $receiptLines
$receiptSha = Get-Sha256Text -Path $CloseoutReceiptPath

$fixReceiptLines = @(
    'HSRB-002 STATIC REVIEW DECISION CLOSEOUT V0.2 FIX RECEIPT',
    "error_freeze_path: $ErrorFreezePath",
    "error_freeze_sha256: $errorFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    "closeout_path: $CloseoutPath",
    "closeout_sha256: $closeoutSha",
    "closeout_receipt_path: $CloseoutReceiptPath",
    "closeout_receipt_sha256: $receiptSha",
    'repair_scope: SAME_OBJECT_ONLY',
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-Utf8NoBomLines -Path $FixReceiptPath -Lines $fixReceiptLines
$fixReceiptSha = Get-Sha256Text -Path $FixReceiptPath

try {
    Set-Clipboard -Value ($printLines -join [Environment]::NewLine)
} catch {
    # Clipboard failure is non-blocking. Written files and receipt remain the record.
}

'=== HSRB-002 STATIC REVIEW DECISION CLOSEOUT V0.2 COMPLETE ==='
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
"template_rule_card_count: $templateRuleCardCount"
"field_apply_attempt_count: $fieldApplyAttemptCount"
"freeze_repair_attempt_count: $freezeRepairAttemptCount"
"unknown_static_disposition_count: $unknownStaticDispositionCount"
"contains_move_item_count: $containsMoveItemCount"
"contains_remove_item_count: $containsRemoveItemCount"
"contains_rename_item_count: $containsRenameItemCount"
"contains_start_process_count: $containsStartProcessCount"
"contains_invoke_expression_count: $containsInvokeExpressionCount"
"contains_git_command_count: $containsGitCommandCount"
"blocker_count: $blockerCount"
"next_single_action: $nextSingleAction"
"final_verdict: $finalVerdict"
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
