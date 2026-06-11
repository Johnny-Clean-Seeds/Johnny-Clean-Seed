$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$LaneDir = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SummaryCsvPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_SUMMARY_V0_1_20260609.csv'
$StaticPacketMdPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_20260609.md'
$StaticPacketPrintPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_COPY_PRINT_V0_1_20260609.txt'
$StaticPacketReceiptPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_RECEIPT_V0_1_20260609.txt'
$DecisionCloseoutPath = Join-Path $LaneDir 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$DecisionCloseoutPrintPath = Join-Path $LaneDir 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$DecisionCloseoutReceiptPath = Join-Path $LaneDir 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

$ExpectedSummaryCsvSha = 'D0FCC6E841F197D1C80E9D6A1E0447F323EAEF0979F618E843FC372CFDB95431'
$ExpectedStaticPacketMdSha = '38FC2086733DF84975FD691502B6FA680CDD6033ABD7FF52EAFFD211359B4F8E'
$ExpectedStaticPacketPrintSha = '89B52B5F21248427F6D5733100A71D171495132EB6D2C80094F1CB27456AF7FF'
$ExpectedStaticPacketReceiptSha = 'C8A18CDB8071CBA593AE8245E1C5BF6470BB8D4DDA7B7E80ED323A96F3D78026'
$ExpectedDecisionCloseoutSha = '524ACDD2D86FD46B69047728323C55D1B5191E58E55E39121565FB18BD5D3215'
$ExpectedDecisionCloseoutPrintSha = 'D8E82B10D6DC045D44F971FDB1A28192C7DFE793C3134004F107B65257DFA74D'
$ExpectedDecisionCloseoutReceiptSha = 'E536EB38C74A4A13F821A66B51EAE1DB729A1634A95B74EE0F81CDF31C8A3746'

$OutputIndexCsvPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$OutputIndexMdPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.md'
$OutputIndexPrintPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $LaneDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Get-Sha256Text {
    param([string] $Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Write-TextLinesNoBom {
    param($Path, $Lines)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $list = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($Lines)) {
        if ($null -eq $line) { $list.Add('') } else { $list.Add([string]$line) }
    }
    $text = [string]::Join([Environment]::NewLine, [string[]]$list.ToArray())
    [System.IO.File]::WriteAllText([string]$Path, $text, $utf8NoBom)
}

function Count-Items {
    param([AllowNull()] $Value)
    return [int](@($Value).Count)
}

function Escape-MdCell {
    param([AllowNull()] $Value)
    $s = [string]$Value
    $s = $s.Replace('|','/')
    $s = $s.Replace("`r",' ')
    $s = $s.Replace("`n",' ')
    return $s
}

function Test-ExpectedHash {
    param(
        [string] $Name,
        [string] $Path,
        [string] $ExpectedSha
    )
    $exists = Test-Path -LiteralPath $Path
    $actual = ''
    $match = $false
    if ($exists) {
        $actual = Get-Sha256Text -Path $Path
        $match = ($actual -eq $ExpectedSha)
    }
    return [pscustomobject]@{
        Name = [string]$Name
        Path = [string]$Path
        Exists = [bool]$exists
        ExpectedSha256 = [string]$ExpectedSha
        ActualSha256 = [string]$actual
        HashMatch = [bool]$match
    }
}

function Get-IndexRole {
    param([string] $StaticDisposition)
    switch ($StaticDisposition) {
        'REVIEW_AS_TEMPLATE_RULE_CARD_NOT_EXECUTION_AUTHORITY' { return 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }
        'HOLD_AS_FIELD_APPLY_ATTEMPT_REVIEW_ONLY' { return 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }
        'HOLD_AS_FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' { return 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }
        default { return 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED' }
    }
}

function Get-IndexDecision {
    param([string] $IndexRole)
    switch ($IndexRole) {
        'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' { return 'KEEP_AS_TEMPLATE_RULE_CARD_CANDIDATE_NOT_DOCTRINE' }
        'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' { return 'HOLD_AS_FIELD_APPLY_ATTEMPT_EVIDENCE' }
        'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' { return 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_EVIDENCE' }
        default { return 'HOLD_FOR_SPECIALIST_REVIEW' }
    }
}

function New-IndexRow {
    param($SummaryRow)
    $indexRole = Get-IndexRole -StaticDisposition ([string]$SummaryRow.StaticDisposition)
    $indexDecision = Get-IndexDecision -IndexRole $indexRole
    return [pscustomobject]@{
        BatchID = [string]$SummaryRow.BatchID
        TicketID = [string]$SummaryRow.TicketID
        FileName = [string]$SummaryRow.FileName
        SourcePath = [string]$SummaryRow.SourcePath
        SourceSha256 = [string]$SummaryRow.SourceSha256
        KnownOutcome = [string]$SummaryRow.KnownOutcome
        StaticDisposition = [string]$SummaryRow.StaticDisposition
        IndexRole = [string]$indexRole
        IndexDecision = [string]$indexDecision
        ContainsGitCommand = [string]$SummaryRow.ContainsGitCommand
        ContainsMoveItem = [string]$SummaryRow.ContainsMoveItem
        ContainsRemoveItem = [string]$SummaryRow.ContainsRemoveItem
        ContainsRenameItem = [string]$SummaryRow.ContainsRenameItem
        ContainsStartProcess = [string]$SummaryRow.ContainsStartProcess
        ContainsInvokeExpression = [string]$SummaryRow.ContainsInvokeExpression
        ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
    }
}

if (-not (Test-Path -LiteralPath $LaneDir)) {
    throw "Output lane directory does not exist: $LaneDir"
}

$blockers = @()
$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_summary_csv' -Path $SummaryCsvPath -ExpectedSha $ExpectedSummaryCsvSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_static_packet_md' -Path $StaticPacketMdPath -ExpectedSha $ExpectedStaticPacketMdSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_static_packet_print' -Path $StaticPacketPrintPath -ExpectedSha $ExpectedStaticPacketPrintSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_static_packet_receipt' -Path $StaticPacketReceiptPath -ExpectedSha $ExpectedStaticPacketReceiptSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_decision_closeout_md' -Path $DecisionCloseoutPath -ExpectedSha $ExpectedDecisionCloseoutSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_decision_closeout_print' -Path $DecisionCloseoutPrintPath -ExpectedSha $ExpectedDecisionCloseoutPrintSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_002_decision_closeout_receipt' -Path $DecisionCloseoutReceiptPath -ExpectedSha $ExpectedDecisionCloseoutReceiptSha

foreach ($h in $hashChecks) {
    if (-not $h.Exists) {
        $blockers += ('MISSING_{0}: {1}' -f $h.Name, $h.Path)
    } elseif (-not $h.HashMatch) {
        $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256)
    }
}

$summaryRows = @()
if ($blockers.Count -eq 0) {
    $summaryRows = @(Import-Csv -LiteralPath $SummaryCsvPath)
}
$summaryRowCount = Count-Items $summaryRows
if (($blockers.Count -eq 0) -and ($summaryRowCount -ne 6)) {
    $blockers += ('UNEXPECTED_SUMMARY_ROW_COUNT: {0}' -f $summaryRowCount)
}

$indexRows = @()
if ($blockers.Count -eq 0) {
    foreach ($row in $summaryRows) {
        $indexRows += New-IndexRow -SummaryRow $row
    }
}

$templateRuleRows = @($indexRows | Where-Object { $_.IndexRole -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' })
$fieldApplyRows = @($indexRows | Where-Object { $_.IndexRole -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' })
$freezeRepairRows = @($indexRows | Where-Object { $_.IndexRole -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' })
$unknownIndexRoleRows = @($indexRows | Where-Object { $_.IndexRole -eq 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED' })
$gitCommandRows = @($indexRows | Where-Object { [string]$_.ContainsGitCommand -eq 'True' })
$moveItemRows = @($indexRows | Where-Object { [string]$_.ContainsMoveItem -eq 'True' })
$removeItemRows = @($indexRows | Where-Object { [string]$_.ContainsRemoveItem -eq 'True' })
$renameItemRows = @($indexRows | Where-Object { [string]$_.ContainsRenameItem -eq 'True' })
$startProcessRows = @($indexRows | Where-Object { [string]$_.ContainsStartProcess -eq 'True' })
$invokeExpressionRows = @($indexRows | Where-Object { [string]$_.ContainsInvokeExpression -eq 'True' })

if (($blockers.Count -eq 0) -and ((Count-Items $unknownIndexRoleRows) -ne 0)) {
    $blockers += ('UNKNOWN_INDEX_ROLE_ROWS: {0}' -f (Count-Items $unknownIndexRoleRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $moveItemRows) -ne 0)) {
    $blockers += ('CONTAINS_MOVE_ITEM_ROWS: {0}' -f (Count-Items $moveItemRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $removeItemRows) -ne 0)) {
    $blockers += ('CONTAINS_REMOVE_ITEM_ROWS: {0}' -f (Count-Items $removeItemRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $renameItemRows) -ne 0)) {
    $blockers += ('CONTAINS_RENAME_ITEM_ROWS: {0}' -f (Count-Items $renameItemRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $startProcessRows) -ne 0)) {
    $blockers += ('CONTAINS_START_PROCESS_ROWS: {0}' -f (Count-Items $startProcessRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $invokeExpressionRows) -ne 0)) {
    $blockers += ('CONTAINS_INVOKE_EXPRESSION_ROWS: {0}' -f (Count-Items $invokeExpressionRows))
}

if ($blockers.Count -eq 0) {
    $indexRows | Export-Csv -LiteralPath $OutputIndexCsvPath -NoTypeInformation -Encoding UTF8
}

$md = @()
$md += '# HSRB-002 Template Rule and Attempt Index - No Execution - V0.1'
$md += ''
$md += 'Status: INDEX_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += ''
$md += 'Index the HSRB-002 generated-runner safe-template chain after static review and decision closeout. This separates the template rule-card candidate from field-apply attempts and freeze/repair attempts.'
$md += ''
$md += '## Boundary'
$md += ''
$md += 'This index is proof and review organization only. It does not approve execution, movement, cleanup, rename, deletion, commit, push, doctrine promotion, or use as source authority.'
$md += ''
$md += '## Verified inputs'
$md += ''
$md += '| Input | Exists | HashMatch | SHA256 |'
$md += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) {
    $md += ('| {0} | {1} | {2} | `{3}` |' -f $h.Name, $h.Exists, $h.HashMatch, $h.ActualSha256)
}
$md += ''
$md += '## Counts'
$md += ''
$md += '- selected_batch_id: HSRB-002'
$md += ('- selected_batch_rows: {0}' -f $summaryRowCount)
$md += ('- template_rule_card_count: {0}' -f (Count-Items $templateRuleRows))
$md += ('- field_apply_attempt_count: {0}' -f (Count-Items $fieldApplyRows))
$md += ('- freeze_repair_attempt_count: {0}' -f (Count-Items $freezeRepairRows))
$md += ('- unknown_index_role_count: {0}' -f (Count-Items $unknownIndexRoleRows))
$md += ('- contains_git_command_count: {0}' -f (Count-Items $gitCommandRows))
$md += ('- contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
$md += ('- contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
$md += ('- contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
$md += ('- contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
$md += ('- contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
$md += ('- blocker_count: {0}' -f $blockers.Count)
$md += ''
$md += '## Index table'
$md += ''
$md += '| TicketID | FileName | IndexRole | IndexDecision | GitCommand | SHA256 |'
$md += '| --- | --- | --- | --- | ---: | --- |'
foreach ($r in $indexRows) {
    $md += ('| {0} | `{1}` | {2} | {3} | {4} | `{5}` |' -f $r.TicketID, (Escape-MdCell $r.FileName), (Escape-MdCell $r.IndexRole), (Escape-MdCell $r.IndexDecision), $r.ContainsGitCommand, $r.SourceSha256)
}
$md += ''
$md += '## Interpretation'
$md += ''
$md += '- The template-rule-card row is held as a candidate, not doctrine.'
$md += '- The field-apply rows are held as field-attempt evidence.'
$md += '- The freeze/repair rows are held as repair-attempt evidence.'
$md += '- Git command mentions are evidence to preserve caution; they do not authorize running those scripts.'
$md += ''
$md += '## Blockers'
$md += ''
if ($blockers.Count -eq 0) { $md += 'None.' } else { foreach ($b in $blockers) { $md += ('- {0}' -f $b) } }
$md += ''
$md += '## DoesNotProve'
$md += ''
$md += 'This index does not prove that any selected script is safe to execute. It does not promote the template card into doctrine and does not approve field apply, freeze repair, routing, cleanup, commit, or push.'
$md += ''
$md += '## Next single action'
$md += ''
if ($blockers.Count -eq 0) {
    $md += 'BUILD_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION'
    $md += ''
    $md += 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $md += 'REPAIR_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_INPUT_BLOCKERS_NO_EXECUTION'
    $md += ''
    $md += 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-TextLinesNoBom -Path $OutputIndexMdPath -Lines $md

$print = @()
$print += 'HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.1'
$print += 'Index only. No execution. No route. No cleanup.'
$print += ''
$print += ('Selected batch rows: {0}' -f $summaryRowCount)
$print += ('Template rule card count: {0}' -f (Count-Items $templateRuleRows))
$print += ('Field apply attempt count: {0}' -f (Count-Items $fieldApplyRows))
$print += ('Freeze repair attempt count: {0}' -f (Count-Items $freezeRepairRows))
$print += ('Unknown index role count: {0}' -f (Count-Items $unknownIndexRoleRows))
$print += ('Contains GitCommand count: {0}' -f (Count-Items $gitCommandRows))
$print += ('Blocker count: {0}' -f $blockers.Count)
$print += ''
$print += 'ROWS:'
foreach ($r in $indexRows) {
    $print += ('{0} | {1}' -f $r.TicketID, $r.FileName)
    $print += ('IndexRole: {0}' -f $r.IndexRole)
    $print += ('IndexDecision: {0}' -f $r.IndexDecision)
    $print += ('SHA256: {0}' -f $r.SourceSha256)
    $print += '---'
}
$print += 'NEXT_SINGLE_ACTION:'
if ($blockers.Count -eq 0) { $print += 'BUILD_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION' } else { $print += 'REPAIR_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_INPUT_BLOCKERS_NO_EXECUTION' }
Write-TextLinesNoBom -Path $OutputIndexPrintPath -Lines $print
if ($blockers.Count -eq 0) { Set-Clipboard -Value ($print -join [Environment]::NewLine) }

$OutputIndexCsvSha = ''
if (Test-Path -LiteralPath $OutputIndexCsvPath) { $OutputIndexCsvSha = Get-Sha256Text -Path $OutputIndexCsvPath }
$OutputIndexMdSha = Get-Sha256Text -Path $OutputIndexMdPath
$OutputIndexPrintSha = Get-Sha256Text -Path $OutputIndexPrintPath

$receipt = @()
$receipt += 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609'
$receipt += ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
$receipt += ('input_summary_csv_path: {0}' -f $SummaryCsvPath)
$receipt += ('input_summary_csv_expected_sha256: {0}' -f $ExpectedSummaryCsvSha)
$receipt += ('input_decision_closeout_path: {0}' -f $DecisionCloseoutPath)
$receipt += ('input_decision_closeout_expected_sha256: {0}' -f $ExpectedDecisionCloseoutSha)
$receipt += ('output_index_csv_path: {0}' -f $OutputIndexCsvPath)
$receipt += ('output_index_csv_sha256: {0}' -f $OutputIndexCsvSha)
$receipt += ('output_index_md_path: {0}' -f $OutputIndexMdPath)
$receipt += ('output_index_md_sha256: {0}' -f $OutputIndexMdSha)
$receipt += ('output_index_print_path: {0}' -f $OutputIndexPrintPath)
$receipt += ('output_index_print_sha256: {0}' -f $OutputIndexPrintSha)
$receipt += 'selected_batch_id: HSRB-002'
$receipt += ('selected_batch_rows: {0}' -f $summaryRowCount)
$receipt += ('template_rule_card_count: {0}' -f (Count-Items $templateRuleRows))
$receipt += ('field_apply_attempt_count: {0}' -f (Count-Items $fieldApplyRows))
$receipt += ('freeze_repair_attempt_count: {0}' -f (Count-Items $freezeRepairRows))
$receipt += ('unknown_index_role_count: {0}' -f (Count-Items $unknownIndexRoleRows))
$receipt += ('contains_git_command_count: {0}' -f (Count-Items $gitCommandRows))
$receipt += ('contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
$receipt += ('contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
$receipt += ('contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
$receipt += ('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
$receipt += ('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
$receipt += ('blocker_count: {0}' -f $blockers.Count)
$receipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
if ($blockers.Count -eq 0) {
    $receipt += 'next_single_action: BUILD_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION'
    $receipt += 'final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $receipt += 'next_single_action: REPAIR_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_INPUT_BLOCKERS_NO_EXECUTION'
    $receipt += 'final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-TextLinesNoBom -Path $OutputReceiptPath -Lines $receipt
$OutputReceiptSha = Get-Sha256Text -Path $OutputReceiptPath

'=== HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.1 COMPLETE ==='
('output_index_csv_path: {0}' -f $OutputIndexCsvPath)
('output_index_csv_sha256: {0}' -f $OutputIndexCsvSha)
('output_index_md_path: {0}' -f $OutputIndexMdPath)
('output_index_md_sha256: {0}' -f $OutputIndexMdSha)
('output_index_print_path: {0}' -f $OutputIndexPrintPath)
('output_index_print_sha256: {0}' -f $OutputIndexPrintSha)
('output_receipt_path: {0}' -f $OutputReceiptPath)
('output_receipt_sha256: {0}' -f $OutputReceiptSha)
('summary_csv_verified: {0}' -f ($hashChecks[0].HashMatch))
('static_packet_verified: {0}' -f ($hashChecks[1].HashMatch))
('decision_closeout_verified: {0}' -f ($hashChecks[4].HashMatch))
('selected_batch_id: HSRB-002')
('selected_batch_rows: {0}' -f $summaryRowCount)
('template_rule_card_count: {0}' -f (Count-Items $templateRuleRows))
('field_apply_attempt_count: {0}' -f (Count-Items $fieldApplyRows))
('freeze_repair_attempt_count: {0}' -f (Count-Items $freezeRepairRows))
('unknown_index_role_count: {0}' -f (Count-Items $unknownIndexRoleRows))
('contains_git_command_count: {0}' -f (Count-Items $gitCommandRows))
('contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
('contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
('contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
('blocker_count: {0}' -f $blockers.Count)
if ($blockers.Count -eq 0) { 'next_single_action: BUILD_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION' } else { 'next_single_action: REPAIR_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_INPUT_BLOCKERS_NO_EXECUTION' }
if ($blockers.Count -eq 0) { 'final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
