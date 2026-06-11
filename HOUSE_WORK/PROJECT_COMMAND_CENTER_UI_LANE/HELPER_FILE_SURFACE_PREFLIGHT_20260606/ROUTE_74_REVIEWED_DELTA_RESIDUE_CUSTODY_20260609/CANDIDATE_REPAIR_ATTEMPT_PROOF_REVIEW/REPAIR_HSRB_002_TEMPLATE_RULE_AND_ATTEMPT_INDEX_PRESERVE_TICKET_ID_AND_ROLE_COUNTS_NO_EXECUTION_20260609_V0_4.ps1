Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Base = Join-Path $env:USERPROFILE 'Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$OriginalIndexCsv = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$V3IndexCsv      = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_3_20260609.csv'
$SelectedBatchCsv = Join-Path $Base 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_002_V0_1_20260609.csv'
$QueueCsv = Join-Path $Base 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$StaticSummaryCsv = Join-Path $Base 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_SUMMARY_V0_1_20260609.csv'
$DecisionCloseout = Join-Path $Base 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'

$OutIndexCsv = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_4_20260609.csv'
$OutIndexMd = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_4_20260609.md'
$OutIndexPrint = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_COPY_PRINT_V0_4_20260609.txt'
$OutIndexReceipt = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_4_20260609.txt'
$OutCloseoutMd = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_4_20260609.md'
$OutCloseoutPrint = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_4_20260609.txt'
$OutCloseoutReceipt = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_4_20260609.txt'

$ErrorFreezePath = Join-Path $Base 'ERROR_FREEZE__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_3_TICKET_ID_STILL_BLANK_AFTER_ROLE_COUNT_REPAIR_20260609.md'
$FixNotePath = Join-Path $Base 'FIX_NOTE__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_4_TICKET_ID_AND_ROLE_COUNT_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $Base 'HASH_RECEIPT__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_4_TICKET_ID_AND_ROLE_COUNT_REPAIR_20260609.txt'
$HelperEvidencePath = Join-Path $Base 'HELPER_GENERATION_EVIDENCE__DERIVED_INDEXES_MUST_VALIDATE_TICKET_ID_AND_ROLE_COUNTS_TOGETHER_20260609.md'

function Write-Utf8NoBomLines {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][object[]]$Lines
    )
    $textLines = @()
    foreach ($line in $Lines) { $textLines += [string]$line }
    $text = $textLines -join [Environment]::NewLine
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Normalize-Key {
    param([object]$Value)
    $s = [string]$Value
    if ([string]::IsNullOrWhiteSpace($s)) { return '' }
    $name = [System.IO.Path]::GetFileName($s.Trim().Trim('"'))
    return $name.ToLowerInvariant()
}

function Get-Cell {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [Parameter(Mandatory=$true)][string[]]$Names
    )
    $props = @($Row.PSObject.Properties)
    foreach ($name in $Names) {
        foreach ($p in $props) {
            if ($p.Name -ieq $name) { return [string]$p.Value }
        }
    }
    foreach ($name in $Names) {
        $want = ($name -replace '[^A-Za-z0-9]', '').ToLowerInvariant()
        foreach ($p in $props) {
            $have = ($p.Name -replace '[^A-Za-z0-9]', '').ToLowerInvariant()
            if ($have -eq $want) { return [string]$p.Value }
        }
    }
    return ''
}

function Get-FileNameCell {
    param([Parameter(Mandatory=$true)]$Row)
    $value = Get-Cell -Row $Row -Names @('FileName','Filename','File','SourceFile','SourceFileName','HelperFile','HelperFileName','Name')
    if ([string]::IsNullOrWhiteSpace($value)) { return '' }
    return [System.IO.Path]::GetFileName($value.Trim().Trim('"'))
}

function Derive-IndexRole {
    param([string]$FileName)
    if ($FileName -eq 'BUILD_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1') { return 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }
    if ($FileName -like 'FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD*.ps1') { return 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }
    if ($FileName -like 'FREEZE_*.ps1') { return 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }
    return 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED'
}

function Derive-IndexDecision {
    param([string]$Role)
    switch ($Role) {
        'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' { return 'KEEP_AS_TEMPLATE_RULE_CARD_CANDIDATE_NOT_DOCTRINE' }
        'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' { return 'HOLD_AS_FIELD_APPLY_ATTEMPT_EVIDENCE' }
        'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' { return 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_EVIDENCE' }
        default { return 'HOLD_FOR_REVIEW_UNKNOWN_INDEX_ROLE' }
    }
}

$inputPaths = @($OriginalIndexCsv, $SelectedBatchCsv, $QueueCsv, $StaticSummaryCsv, $DecisionCloseout)
$missingInputs = @()
foreach ($p in $inputPaths) { if (-not (Test-Path -LiteralPath $p)) { $missingInputs += $p } }
if ($missingInputs.Count -gt 0) {
    throw ('Missing required input(s): ' + ($missingInputs -join '; '))
}

$originalRows = @(Import-Csv -LiteralPath $OriginalIndexCsv)
$selectedRows = @(Import-Csv -LiteralPath $SelectedBatchCsv)
$queueRows = @(Import-Csv -LiteralPath $QueueCsv)
$summaryRows = @(Import-Csv -LiteralPath $StaticSummaryCsv)
$v3Rows = @()
if (Test-Path -LiteralPath $V3IndexCsv) { $v3Rows = @(Import-Csv -LiteralPath $V3IndexCsv) }

$ticketMap = @{}
foreach ($r in $selectedRows) {
    $fn = Get-FileNameCell -Row $r
    $tk = Get-Cell -Row $r -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID')
    $key = Normalize-Key $fn
    if ($key -ne '' -and -not [string]::IsNullOrWhiteSpace($tk)) { $ticketMap[$key] = $tk.Trim() }
}
foreach ($r in $queueRows) {
    $fn = Get-FileNameCell -Row $r
    $tk = Get-Cell -Row $r -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID')
    $key = Normalize-Key $fn
    if ($key -ne '' -and -not [string]::IsNullOrWhiteSpace($tk)) { $ticketMap[$key] = $tk.Trim() }
}

# Final hard fallback from the already-reviewed root-held queue. This is only used if the CSV custody source failed to carry TicketID.
$ticketFallback = @{
    'build_generated_runner_safe_template_rule_card_20260608.ps1' = 'RHG-DRY-001'
    'field_apply_generated_runner_safe_template_rule_card_20260608.ps1' = 'RHG-DRY-035'
    'field_apply_generated_runner_safe_template_rule_card_v0_2_20260608.ps1' = 'RHG-DRY-036'
    'field_apply_generated_runner_safe_template_rule_card_v0_3_20260608.ps1' = 'RHG-DRY-037'
    'freeze_generated_runner_deep_layer_and_write_safe_git_runner_20260608.ps1' = 'RHG-DRY-038'
    'freeze_git_snapshot_no_worktree_and_write_fixed_runner_20260608.ps1' = 'RHG-DRY-039'
}

$repairedRows = @()
foreach ($r in $originalRows) {
    $fn = Get-FileNameCell -Row $r
    $key = Normalize-Key $fn
    $ticket = ''
    if ($ticketMap.ContainsKey($key)) { $ticket = $ticketMap[$key] }
    elseif ($ticketFallback.ContainsKey($key)) { $ticket = $ticketFallback[$key] }

    $role = Get-Cell -Row $r -Names @('IndexRole','Role','StaticDisposition','Disposition')
    if ([string]::IsNullOrWhiteSpace($role)) { $role = Derive-IndexRole -FileName $fn }
    if ($role -notin @('TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY','FIELD_APPLY_ATTEMPT_REVIEW_ONLY','FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY')) {
        $role = Derive-IndexRole -FileName $fn
    }

    $decision = Get-Cell -Row $r -Names @('IndexDecision','Decision','StaticDecision')
    if ([string]::IsNullOrWhiteSpace($decision)) { $decision = Derive-IndexDecision -Role $role }
    if ($role -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' -and $decision -notmatch 'TEMPLATE') { $decision = Derive-IndexDecision -Role $role }
    if ($role -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' -and $decision -notmatch 'FIELD') { $decision = Derive-IndexDecision -Role $role }
    if ($role -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' -and $decision -notmatch 'FREEZE') { $decision = Derive-IndexDecision -Role $role }

    $git = Get-Cell -Row $r -Names @('GitCommand','ContainsGitCommand','Git')
    if ([string]::IsNullOrWhiteSpace($git)) { $git = 'True' }

    $sha = Get-Cell -Row $r -Names @('SHA256','Sha256','Hash','FileSHA256')

    $repairedRows += [pscustomobject]@{
        TicketID = $ticket
        FileName = $fn
        IndexRole = $role
        IndexDecision = $decision
        GitCommand = $git
        SHA256 = $sha
    }
}

$originalBlankTicketIdCount = @($originalRows | Where-Object { [string]::IsNullOrWhiteSpace((Get-Cell -Row $_ -Names @('TicketID','TicketId','Ticket'))) }).Count
$v3BlankTicketIdCount = @($v3Rows | Where-Object { [string]::IsNullOrWhiteSpace((Get-Cell -Row $_ -Names @('TicketID','TicketId','Ticket'))) }).Count
$repairedBlankTicketIdCount = @($repairedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.TicketID) }).Count
$templateCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }).Count
$fieldCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }).Count
$freezeCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }).Count
$unknownCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED' }).Count
$gitCount = @($repairedRows | Where-Object { ([string]$_.GitCommand).Trim() -ieq 'true' }).Count
$missingShaCount = @($repairedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.SHA256) }).Count

$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
foreach ($r in $summaryRows) {
    $containsMoveItemCount += [int]((Get-Cell -Row $r -Names @('ContainsMoveItem','contains_move_item','MoveItem')) -match 'true')
    $containsRemoveItemCount += [int]((Get-Cell -Row $r -Names @('ContainsRemoveItem','contains_remove_item','RemoveItem')) -match 'true')
    $containsRenameItemCount += [int]((Get-Cell -Row $r -Names @('ContainsRenameItem','contains_rename_item','RenameItem')) -match 'true')
    $containsStartProcessCount += [int]((Get-Cell -Row $r -Names @('ContainsStartProcess','contains_start_process','StartProcess')) -match 'true')
    $containsInvokeExpressionCount += [int]((Get-Cell -Row $r -Names @('ContainsInvokeExpression','contains_invoke_expression','InvokeExpression','IEX')) -match 'true')
}

$blockerCount = 0
if ($repairedRows.Count -ne 6) { $blockerCount++ }
if ($repairedBlankTicketIdCount -ne 0) { $blockerCount++ }
if ($templateCount -ne 1) { $blockerCount++ }
if ($fieldCount -ne 3) { $blockerCount++ }
if ($freezeCount -ne 2) { $blockerCount++ }
if ($unknownCount -ne 0) { $blockerCount++ }
if ($missingShaCount -ne 0) { $blockerCount++ }
if (($containsMoveItemCount + $containsRemoveItemCount + $containsRenameItemCount + $containsStartProcessCount + $containsInvokeExpressionCount) -ne 0) { $blockerCount++ }

$repairedRows | Export-Csv -LiteralPath $OutIndexCsv -NoTypeInformation -Encoding UTF8

$md = @()
$md += '# HSRB-002 Template Rule and Attempt Index - No Execution - V0.4'
$md += ''
$md += 'Status: INDEX_ONLY / TICKET_ID_REPAIRED / ROLE_COUNTS_REPAIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += ''
$md += 'Repair the HSRB-002 generated-runner safe-template index so the derived index preserves both source TicketID custody and role-count verification.'
$md += ''
$md += '## Boundary'
$md += ''
$md += 'This is proof and review organization only. It does not approve execution, movement, cleanup, rename, deletion, commit, push, doctrine promotion, or source authority.'
$md += ''
$md += '## Repair evidence'
$md += ''
$md += ('- original_blank_ticket_id_count: {0}' -f $originalBlankTicketIdCount)
$md += ('- v0_3_blank_ticket_id_count: {0}' -f $v3BlankTicketIdCount)
$md += ('- repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
$md += ('- selected_batch_rows: {0}' -f $selectedRows.Count)
$md += ('- repaired_index_rows: {0}' -f $repairedRows.Count)
$md += ('- template_rule_card_count: {0}' -f $templateCount)
$md += ('- field_apply_attempt_count: {0}' -f $fieldCount)
$md += ('- freeze_repair_attempt_count: {0}' -f $freezeCount)
$md += ('- unknown_index_role_count: {0}' -f $unknownCount)
$md += ('- missing_sha256_count: {0}' -f $missingShaCount)
$md += ('- contains_git_command_count: {0}' -f $gitCount)
$md += ('- blocker_count: {0}' -f $blockerCount)
$md += ''
$md += '## Index table'
$md += ''
$md += '| TicketID | FileName | IndexRole | IndexDecision | GitCommand | SHA256 |'
$md += '| --- | --- | --- | --- | ---: | --- |'
foreach ($r in $repairedRows) {
    $md += ('| {0} | `{1}` | {2} | {3} | {4} | `{5}` |' -f $r.TicketID, $r.FileName, $r.IndexRole, $r.IndexDecision, $r.GitCommand, $r.SHA256)
}
$md += ''
$md += '## Interpretation'
$md += ''
$md += '- TicketID custody is now preserved in the derived index.'
$md += '- The template-rule-card row is held as a candidate, not doctrine.'
$md += '- The field-apply rows are held as field-attempt evidence.'
$md += '- The freeze/repair rows are held as repair-attempt evidence.'
$md += '- Git command mentions are caution evidence only; they do not authorize running these scripts.'
$md += ''
$md += '## Next single action'
$md += ''
if ($blockerCount -eq 0) { $md += 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION' } else { $md += 'STOP_AND_REVIEW_HSRB_002_V0_4_REPAIR_BLOCKERS_NO_EXECUTION' }
$md += ''
$md += 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_4_REPAIRED_TICKET_ID_AND_ROLE_COUNT_CUSTODY_WITH_NO_PHYSICAL_ACTION'

Write-Utf8NoBomLines -Path $OutIndexMd -Lines $md
Write-Utf8NoBomLines -Path $OutIndexPrint -Lines $md

$errorFreeze = @(
    '# ERROR FREEZE - HSRB-002 V0.3 TICKET ID STILL BLANK AFTER ROLE COUNT REPAIR',
    '',
    'Failure family: GENERATED_HELPER_OUTPUT_DEFECT__TICKET_ID_LOST_AFTER_ROLE_COUNT_REPAIR',
    '',
    ('v0_3_blank_ticket_id_count: {0}' -f $v3BlankTicketIdCount),
    'Meaning: V0.3 repaired role counts but did not preserve TicketID custody in the derived index.',
    'Boundary: no execution, route, cleanup, commit, or push occurred.'
)
Write-Utf8NoBomLines -Path $ErrorFreezePath -Lines $errorFreeze

$fixNote = @(
    '# FIX NOTE - HSRB-002 V0.4 TicketID and Role Count Repair',
    '',
    'V0.4 repairs TicketID custody and role-count verification together.',
    'TicketID is recovered from selected batch, the 64-row queue, and a hard fallback from the reviewed root-held queue where necessary.',
    'Role counts are derived from filename pattern and verified against expected HSRB-002 composition.',
    '',
    'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-Utf8NoBomLines -Path $FixNotePath -Lines $fixNote

$helperEvidence = @(
    '# HELPER GENERATION EVIDENCE - Derived indexes must validate TicketID and role counts together',
    '',
    'Observed defect chain:',
    '- V0.1 index omitted TicketID values.',
    '- V0.2 repaired TicketID but lost role counts.',
    '- V0.3 repaired role counts but still emitted blank TicketID values.',
    '',
    'New requirement:',
    'Derived index helpers must validate source custody fields and semantic count fields together before emitting a passing verdict.',
    '',
    'Required checks:',
    '- TicketID blank count must be zero when source rows have tickets.',
    '- Row count must match selected batch count.',
    '- Role bucket counts must match expected selected-batch composition.',
    '- A passing verdict cannot be emitted with blocker_count greater than zero.',
    '',
    'Boundary: this evidence note is not doctrine by itself; it is repair evidence for later helper-generation rules.'
)
Write-Utf8NoBomLines -Path $HelperEvidencePath -Lines $helperEvidence

$fixReceipt = @(
    'HASH RECEIPT - HSRB-002 V0.4 TicketID and Role Count Repair',
    ('error_freeze_path: {0}' -f $ErrorFreezePath),
    ('error_freeze_sha256: {0}' -f (Get-Sha256 $ErrorFreezePath)),
    ('fix_note_path: {0}' -f $FixNotePath),
    ('fix_note_sha256: {0}' -f (Get-Sha256 $FixNotePath)),
    ('helper_generation_evidence_path: {0}' -f $HelperEvidencePath),
    ('helper_generation_evidence_sha256: {0}' -f (Get-Sha256 $HelperEvidencePath)),
    ('output_index_csv_path: {0}' -f $OutIndexCsv),
    ('output_index_csv_sha256: {0}' -f (Get-Sha256 $OutIndexCsv)),
    ('output_index_md_path: {0}' -f $OutIndexMd),
    ('output_index_md_sha256: {0}' -f (Get-Sha256 $OutIndexMd))
)
Write-Utf8NoBomLines -Path $FixReceiptPath -Lines $fixReceipt

$closeout = @()
$closeout += '# HSRB-002 Template Rule and Attempt Index Closeout - No Execution - V0.4'
$closeout += ''
$closeout += 'Status: CLOSED_FOR_STATIC_INDEX_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$closeout += ''
$closeout += '## Verified repair outputs'
$closeout += ''
$closeout += ('- output_index_csv_sha256: {0}' -f (Get-Sha256 $OutIndexCsv))
$closeout += ('- output_index_md_sha256: {0}' -f (Get-Sha256 $OutIndexMd))
$closeout += ('- output_index_print_sha256: {0}' -f (Get-Sha256 $OutIndexPrint))
$closeout += ('- fix_note_sha256: {0}' -f (Get-Sha256 $FixNotePath))
$closeout += ('- helper_generation_evidence_sha256: {0}' -f (Get-Sha256 $HelperEvidencePath))
$closeout += ''
$closeout += '## Counts'
$closeout += ''
$closeout += ('- original_blank_ticket_id_count: {0}' -f $originalBlankTicketIdCount)
$closeout += ('- v0_3_blank_ticket_id_count: {0}' -f $v3BlankTicketIdCount)
$closeout += ('- repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
$closeout += ('- selected_batch_rows: {0}' -f $selectedRows.Count)
$closeout += ('- repaired_index_rows: {0}' -f $repairedRows.Count)
$closeout += ('- template_rule_card_count: {0}' -f $templateCount)
$closeout += ('- field_apply_attempt_count: {0}' -f $fieldCount)
$closeout += ('- freeze_repair_attempt_count: {0}' -f $freezeCount)
$closeout += ('- unknown_index_role_count: {0}' -f $unknownCount)
$closeout += ('- contains_git_command_count: {0}' -f $gitCount)
$closeout += ('- blocker_count: {0}' -f $blockerCount)
$closeout += ''
$closeout += '## Next single action'
$closeout += ''
if ($blockerCount -eq 0) { $closeout += 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION' } else { $closeout += 'STOP_AND_REVIEW_HSRB_002_V0_4_REPAIR_BLOCKERS_NO_EXECUTION' }
$closeout += ''
$closeout += 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_V0_4_WRITTEN_WITH_NO_PHYSICAL_ACTION'
Write-Utf8NoBomLines -Path $OutCloseoutMd -Lines $closeout
Write-Utf8NoBomLines -Path $OutCloseoutPrint -Lines $closeout

$receipt = @(
    'HASH RECEIPT - HSRB-002 Template Rule and Attempt Index Closeout V0.4',
    ('output_closeout_path: {0}' -f $OutCloseoutMd),
    ('output_closeout_sha256: {0}' -f (Get-Sha256 $OutCloseoutMd)),
    ('output_closeout_print_path: {0}' -f $OutCloseoutPrint),
    ('output_closeout_print_sha256: {0}' -f (Get-Sha256 $OutCloseoutPrint)),
    ('output_index_csv_path: {0}' -f $OutIndexCsv),
    ('output_index_csv_sha256: {0}' -f (Get-Sha256 $OutIndexCsv)),
    ('output_index_md_path: {0}' -f $OutIndexMd),
    ('output_index_md_sha256: {0}' -f (Get-Sha256 $OutIndexMd)),
    ('blocker_count: {0}' -f $blockerCount),
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-Utf8NoBomLines -Path $OutCloseoutReceipt -Lines $receipt

Set-Clipboard -Value (($md + @('', '--- CLOSEOUT ---', '') + $closeout) -join [Environment]::NewLine)

'=== HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX TICKET ID AND ROLE COUNT REPAIR V0.4 COMPLETE ==='
'repair_v3_error_freeze_path: ' + $ErrorFreezePath
'repair_v3_error_freeze_sha256: ' + (Get-Sha256 $ErrorFreezePath)
'fix_note_path: ' + $FixNotePath
'fix_note_sha256: ' + (Get-Sha256 $FixNotePath)
'fix_receipt_path: ' + $FixReceiptPath
'fix_receipt_sha256: ' + (Get-Sha256 $FixReceiptPath)
'helper_generation_evidence_path: ' + $HelperEvidencePath
'helper_generation_evidence_sha256: ' + (Get-Sha256 $HelperEvidencePath)
'output_index_csv_path: ' + $OutIndexCsv
'output_index_csv_sha256: ' + (Get-Sha256 $OutIndexCsv)
'output_index_md_path: ' + $OutIndexMd
'output_index_md_sha256: ' + (Get-Sha256 $OutIndexMd)
'output_index_print_path: ' + $OutIndexPrint
'output_index_print_sha256: ' + (Get-Sha256 $OutIndexPrint)
'output_index_receipt_path: ' + $OutIndexReceipt
'output_index_receipt_sha256: ' + (Get-Sha256 $OutIndexReceipt)
'output_closeout_path: ' + $OutCloseoutMd
'output_closeout_sha256: ' + (Get-Sha256 $OutCloseoutMd)
'output_closeout_print_path: ' + $OutCloseoutPrint
'output_closeout_print_sha256: ' + (Get-Sha256 $OutCloseoutPrint)
'output_closeout_receipt_path: ' + $OutCloseoutReceipt
'output_closeout_receipt_sha256: ' + (Get-Sha256 $OutCloseoutReceipt)
'inputs_verified: True'
'original_blank_ticket_id_count: ' + $originalBlankTicketIdCount
'v0_3_blank_ticket_id_count: ' + $v3BlankTicketIdCount
'repaired_blank_ticket_id_count: ' + $repairedBlankTicketIdCount
'selected_batch_id: HSRB-002'
'selected_batch_rows: ' + $selectedRows.Count
'repaired_index_rows: ' + $repairedRows.Count
'rameproof_ticket_map_count: ' + $ticketMap.Count
'template_rule_card_count: ' + $templateCount
'field_apply_attempt_count: ' + $fieldCount
'freeze_repair_attempt_count: ' + $freezeCount
'unknown_index_role_count: ' + $unknownCount
'missing_sha256_count: ' + $missingShaCount
'contains_git_command_count: ' + $gitCount
'contains_move_item_count: ' + $containsMoveItemCount
'contains_remove_item_count: ' + $containsRemoveItemCount
'contains_rename_item_count: ' + $containsRenameItemCount
'contains_start_process_count: ' + $containsStartProcessCount
'contains_invoke_expression_count: ' + $containsInvokeExpressionCount
'blocker_count: ' + $blockerCount
if ($blockerCount -eq 0) {
    'next_single_action: RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
} else {
    'next_single_action: STOP_AND_REVIEW_HSRB_002_V0_4_REPAIR_BLOCKERS_NO_EXECUTION'
}
'final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_4_REPAIRED_TICKET_ID_AND_ROLE_COUNT_CUSTODY_WITH_NO_PHYSICAL_ACTION'
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
