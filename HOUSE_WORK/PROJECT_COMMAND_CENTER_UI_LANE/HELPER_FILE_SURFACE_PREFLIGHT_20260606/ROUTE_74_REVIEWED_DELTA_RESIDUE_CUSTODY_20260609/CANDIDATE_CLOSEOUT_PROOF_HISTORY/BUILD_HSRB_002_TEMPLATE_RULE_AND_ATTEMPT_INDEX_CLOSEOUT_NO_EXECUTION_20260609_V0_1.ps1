# BUILD_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1
# Purpose: Close out the HSRB-002 template-rule/attempt index as review/proof only.
# Boundary: Reads existing index/closeout evidence and writes closeout/receipt files only. No helper execution. No route, cleanup, delete, rename, commit, or push.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$LaneDir = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$IndexCsvPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$IndexMdPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.md'
$IndexPrintPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$IndexReceiptPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'
$DecisionCloseoutPath = Join-Path $LaneDir 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'

$ExpectedIndexCsvSha = 'E940E2C56DA6B2B26545F78564AE4A095E605AB49BD2CD8DC0DC39FDA1076992'
$ExpectedIndexMdSha = 'D5165EEDC94E352E556F06CC1FE51BB6605BA4B5CBC0287E6E7A6DC0F49FC547'
$ExpectedIndexPrintSha = '1DCB298DF85C2B366A0A2D614794DF5988F7CCA08EBA541FFE4CE0C1AF2B397F'
$ExpectedIndexReceiptSha = 'BAE4C5B29BF727103E41AB6E9F6A685ABDBD66BCD625ACF76697BF0115A2BCD8'
$ExpectedDecisionCloseoutSha = '524ACDD2D86FD46B69047728323C55D1B5191E58E55E39121565FB18BD5D3215'

$OutputCloseoutPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$OutputPrintPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Get-Sha256Text {
    param([string] $Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash).ToUpperInvariant()
}

function Write-TextLinesNoBom {
    param($Path, $Lines)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $list = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($Lines)) {
        if ($null -eq $line) { [void]$list.Add('') } else { [void]$list.Add([string]$line) }
    }
    $text = [string]::Join([Environment]::NewLine, [string[]]$list.ToArray())
    [System.IO.File]::WriteAllText([string]$Path, $text, $utf8NoBom)
}

function Count-Items {
    param([AllowNull()] $Value)
    return [int](@($Value).Count)
}

function Test-ExpectedHash {
    param(
        [string] $Name,
        [string] $Path,
        [string] $ExpectedSha
    )
    $exists = Test-Path -LiteralPath $Path -PathType Leaf
    $actual = ''
    $match = $false
    if ($exists) {
        $actual = Get-Sha256Text -Path $Path
        $match = ($actual -eq $ExpectedSha.ToUpperInvariant())
    }
    return [pscustomobject]@{
        Name = [string]$Name
        Path = [string]$Path
        Exists = [bool]$exists
        ExpectedSha256 = [string]$ExpectedSha.ToUpperInvariant()
        ActualSha256 = [string]$actual
        HashMatch = [bool]$match
    }
}

if (-not (Test-Path -LiteralPath $LaneDir -PathType Container)) {
    throw "Missing lane directory: $LaneDir"
}

$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_index_csv' -Path $IndexCsvPath -ExpectedSha $ExpectedIndexCsvSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_index_md' -Path $IndexMdPath -ExpectedSha $ExpectedIndexMdSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_index_print' -Path $IndexPrintPath -ExpectedSha $ExpectedIndexPrintSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_index_receipt' -Path $IndexReceiptPath -ExpectedSha $ExpectedIndexReceiptSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_decision_closeout' -Path $DecisionCloseoutPath -ExpectedSha $ExpectedDecisionCloseoutSha

$blockers = @()
foreach ($h in $hashChecks) {
    if (-not $h.Exists) {
        $blockers += ('MISSING_{0}: {1}' -f $h.Name, $h.Path)
    } elseif (-not $h.HashMatch) {
        $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256)
    }
}

$indexRows = @()
if ($blockers.Count -eq 0) {
    $indexRows = @(Import-Csv -LiteralPath $IndexCsvPath)
}

$selectedBatchRows = Count-Items $indexRows
$templateRuleRows = @($indexRows | Where-Object { [string]$_.IndexRole -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' })
$fieldApplyRows = @($indexRows | Where-Object { [string]$_.IndexRole -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' })
$freezeRepairRows = @($indexRows | Where-Object { [string]$_.IndexRole -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' })
$unknownIndexRoleRows = @($indexRows | Where-Object { [string]$_.IndexRole -eq 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED' })
$gitCommandRows = @($indexRows | Where-Object { [string]$_.ContainsGitCommand -eq 'True' })
$moveItemRows = @($indexRows | Where-Object { [string]$_.ContainsMoveItem -eq 'True' })
$removeItemRows = @($indexRows | Where-Object { [string]$_.ContainsRemoveItem -eq 'True' })
$renameItemRows = @($indexRows | Where-Object { [string]$_.ContainsRenameItem -eq 'True' })
$startProcessRows = @($indexRows | Where-Object { [string]$_.ContainsStartProcess -eq 'True' })
$invokeExpressionRows = @($indexRows | Where-Object { [string]$_.ContainsInvokeExpression -eq 'True' })

$templateRuleCardCount = Count-Items $templateRuleRows
$fieldApplyAttemptCount = Count-Items $fieldApplyRows
$freezeRepairAttemptCount = Count-Items $freezeRepairRows
$unknownIndexRoleCount = Count-Items $unknownIndexRoleRows
$containsGitCommandCount = Count-Items $gitCommandRows
$containsMoveItemCount = Count-Items $moveItemRows
$containsRemoveItemCount = Count-Items $removeItemRows
$containsRenameItemCount = Count-Items $renameItemRows
$containsStartProcessCount = Count-Items $startProcessRows
$containsInvokeExpressionCount = Count-Items $invokeExpressionRows

if (($blockers.Count -eq 0) -and ($selectedBatchRows -ne 6)) { $blockers += ('UNEXPECTED_SELECTED_BATCH_ROWS: {0}' -f $selectedBatchRows) }
if (($blockers.Count -eq 0) -and ($templateRuleCardCount -ne 1)) { $blockers += ('UNEXPECTED_TEMPLATE_RULE_CARD_COUNT: {0}' -f $templateRuleCardCount) }
if (($blockers.Count -eq 0) -and ($fieldApplyAttemptCount -ne 3)) { $blockers += ('UNEXPECTED_FIELD_APPLY_ATTEMPT_COUNT: {0}' -f $fieldApplyAttemptCount) }
if (($blockers.Count -eq 0) -and ($freezeRepairAttemptCount -ne 2)) { $blockers += ('UNEXPECTED_FREEZE_REPAIR_ATTEMPT_COUNT: {0}' -f $freezeRepairAttemptCount) }
if (($blockers.Count -eq 0) -and ($unknownIndexRoleCount -ne 0)) { $blockers += ('UNKNOWN_INDEX_ROLE_COUNT: {0}' -f $unknownIndexRoleCount) }
if (($blockers.Count -eq 0) -and ($containsMoveItemCount -ne 0)) { $blockers += ('CONTAINS_MOVE_ITEM_COUNT: {0}' -f $containsMoveItemCount) }
if (($blockers.Count -eq 0) -and ($containsRemoveItemCount -ne 0)) { $blockers += ('CONTAINS_REMOVE_ITEM_COUNT: {0}' -f $containsRemoveItemCount) }
if (($blockers.Count -eq 0) -and ($containsRenameItemCount -ne 0)) { $blockers += ('CONTAINS_RENAME_ITEM_COUNT: {0}' -f $containsRenameItemCount) }
if (($blockers.Count -eq 0) -and ($containsStartProcessCount -ne 0)) { $blockers += ('CONTAINS_START_PROCESS_COUNT: {0}' -f $containsStartProcessCount) }
if (($blockers.Count -eq 0) -and ($containsInvokeExpressionCount -ne 0)) { $blockers += ('CONTAINS_INVOKE_EXPRESSION_COUNT: {0}' -f $containsInvokeExpressionCount) }

$blockerCount = [int]$blockers.Count
$nextSingleAction = 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
$finalVerdict = 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
if ($blockerCount -ne 0) {
    $nextSingleAction = 'STOP_AND_REVIEW_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_BLOCKERS_NO_EXECUTION'
    $finalVerdict = 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$closeout = @()
$closeout += '# HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX CLOSEOUT - NO EXECUTION'
$closeout += ''
$closeout += 'Status: REVIEW_PROOF_INDEX_CLOSEOUT_ONLY'
$closeout += 'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
$closeout += ''
$closeout += '## Inputs verified'
$closeout += ('- index_csv_verified: {0}' -f $hashChecks[0].HashMatch)
$closeout += ('- index_md_verified: {0}' -f $hashChecks[1].HashMatch)
$closeout += ('- index_print_verified: {0}' -f $hashChecks[2].HashMatch)
$closeout += ('- index_receipt_verified: {0}' -f $hashChecks[3].HashMatch)
$closeout += ('- decision_closeout_verified: {0}' -f $hashChecks[4].HashMatch)
$closeout += ''
$closeout += '## Counts'
$closeout += '- selected_batch_id: HSRB-002'
$closeout += ('- selected_batch_rows: {0}' -f $selectedBatchRows)
$closeout += ('- template_rule_card_count: {0}' -f $templateRuleCardCount)
$closeout += ('- field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount)
$closeout += ('- freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount)
$closeout += ('- unknown_index_role_count: {0}' -f $unknownIndexRoleCount)
$closeout += ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
$closeout += ''
$closeout += '## Safety scan counts from index rows'
$closeout += ('- contains_move_item_count: {0}' -f $containsMoveItemCount)
$closeout += ('- contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$closeout += ('- contains_rename_item_count: {0}' -f $containsRenameItemCount)
$closeout += ('- contains_start_process_count: {0}' -f $containsStartProcessCount)
$closeout += ('- contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$closeout += ''
$closeout += '## Decision'
$closeout += 'HSRB-002 is closed as a review/index branch. The template-rule-card row is preserved as a candidate, not doctrine. Field-apply rows and freeze/repair rows are held as attempt evidence. Git command mentions remain caution evidence only and authorize no execution.'
$closeout += ''
$closeout += '## Blockers'
if ($blockerCount -eq 0) {
    $closeout += 'None.'
} else {
    foreach ($b in $blockers) { $closeout += ('- {0}' -f $b) }
}
$closeout += ''
$closeout += ('blocker_count: {0}' -f $blockerCount)
$closeout += ('next_single_action: {0}' -f $nextSingleAction)
$closeout += ('final_verdict: {0}' -f $finalVerdict)
$closeout += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-TextLinesNoBom -Path $OutputCloseoutPath -Lines $closeout

$print = @()
$print += 'HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX CLOSEOUT - COPY PRINT'
$print += ''
$print += 'Plain meaning:'
$print += 'HSRB-002 is closed as review/index only. One template-rule-card row remains candidate material, not doctrine. Three field-apply attempts and two freeze/repair attempts remain evidence. Nothing is executable from this closeout.'
$print += ''
$print += ('selected_batch_rows: {0}' -f $selectedBatchRows)
$print += ('template_rule_card_count: {0}' -f $templateRuleCardCount)
$print += ('field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount)
$print += ('freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount)
$print += ('unknown_index_role_count: {0}' -f $unknownIndexRoleCount)
$print += ('contains_git_command_count: {0}' -f $containsGitCommandCount)
$print += ('blocker_count: {0}' -f $blockerCount)
$print += ('next_single_action: {0}' -f $nextSingleAction)
$print += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-TextLinesNoBom -Path $OutputPrintPath -Lines $print
try { Set-Clipboard -Value ($print -join [Environment]::NewLine) } catch { }

$outputCloseoutSha = Get-Sha256Text -Path $OutputCloseoutPath
$outputPrintSha = Get-Sha256Text -Path $OutputPrintPath

$receipt = @()
$receipt += 'HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX CLOSEOUT RECEIPT V0.1'
$receipt += ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
$receipt += ('input_index_csv_path: {0}' -f $IndexCsvPath)
$receipt += ('input_index_csv_expected_sha256: {0}' -f $ExpectedIndexCsvSha)
$receipt += ('input_decision_closeout_path: {0}' -f $DecisionCloseoutPath)
$receipt += ('input_decision_closeout_expected_sha256: {0}' -f $ExpectedDecisionCloseoutSha)
$receipt += ('output_closeout_path: {0}' -f $OutputCloseoutPath)
$receipt += ('output_closeout_sha256: {0}' -f $outputCloseoutSha)
$receipt += ('output_closeout_print_path: {0}' -f $OutputPrintPath)
$receipt += ('output_closeout_print_sha256: {0}' -f $outputPrintSha)
$receipt += 'selected_batch_id: HSRB-002'
$receipt += ('selected_batch_rows: {0}' -f $selectedBatchRows)
$receipt += ('template_rule_card_count: {0}' -f $templateRuleCardCount)
$receipt += ('field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount)
$receipt += ('freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount)
$receipt += ('unknown_index_role_count: {0}' -f $unknownIndexRoleCount)
$receipt += ('contains_git_command_count: {0}' -f $containsGitCommandCount)
$receipt += ('contains_move_item_count: {0}' -f $containsMoveItemCount)
$receipt += ('contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$receipt += ('contains_rename_item_count: {0}' -f $containsRenameItemCount)
$receipt += ('contains_start_process_count: {0}' -f $containsStartProcessCount)
$receipt += ('contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$receipt += ('blocker_count: {0}' -f $blockerCount)
$receipt += ('next_single_action: {0}' -f $nextSingleAction)
$receipt += ('final_verdict: {0}' -f $finalVerdict)
$receipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-TextLinesNoBom -Path $OutputReceiptPath -Lines $receipt
$outputReceiptSha = Get-Sha256Text -Path $OutputReceiptPath

'=== HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX CLOSEOUT V0.1 COMPLETE ==='
('output_closeout_path: {0}' -f $OutputCloseoutPath)
('output_closeout_sha256: {0}' -f $outputCloseoutSha)
('output_closeout_print_path: {0}' -f $OutputPrintPath)
('output_closeout_print_sha256: {0}' -f $outputPrintSha)
('output_receipt_path: {0}' -f $OutputReceiptPath)
('output_receipt_sha256: {0}' -f $outputReceiptSha)
('index_csv_verified: {0}' -f $hashChecks[0].HashMatch)
('index_md_verified: {0}' -f $hashChecks[1].HashMatch)
('index_print_verified: {0}' -f $hashChecks[2].HashMatch)
('index_receipt_verified: {0}' -f $hashChecks[3].HashMatch)
('decision_closeout_verified: {0}' -f $hashChecks[4].HashMatch)
('selected_batch_id: HSRB-002')
('selected_batch_rows: {0}' -f $selectedBatchRows)
('template_rule_card_count: {0}' -f $templateRuleCardCount)
('field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount)
('freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount)
('unknown_index_role_count: {0}' -f $unknownIndexRoleCount)
('contains_git_command_count: {0}' -f $containsGitCommandCount)
('contains_move_item_count: {0}' -f $containsMoveItemCount)
('contains_remove_item_count: {0}' -f $containsRemoveItemCount)
('contains_rename_item_count: {0}' -f $containsRenameItemCount)
('contains_start_process_count: {0}' -f $containsStartProcessCount)
('contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
('blocker_count: {0}' -f $blockerCount)
('next_single_action: {0}' -f $nextSingleAction)
('final_verdict: {0}' -f $finalVerdict)
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
