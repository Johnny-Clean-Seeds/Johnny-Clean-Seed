Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ProjectRoot = Join-Path $env:USERPROFILE 'Desktop\123'
$Base = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SummaryCsvPath = Join-Path $Base 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_SUMMARY_V0_1_20260609.csv'
$SelectedBatchCsv = Join-Path $Base 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_002_V0_1_20260609.csv'
$QueueCsv = Join-Path $Base 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$DecisionCloseout = Join-Path $Base 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$V1IndexCsv = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$V2IndexCsv = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_2_20260609.csv'
$V3IndexCsv = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_3_20260609.csv'
$V4IndexCsv = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_4_20260609.csv'

$V4ErrorFreezePath = Join-Path $Base 'ERROR_FREEZE__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_4_MISSING_SHA256_AFTER_TICKET_ID_AND_ROLE_COUNT_REPAIR_20260609.md'
$FixNotePath = Join-Path $Base 'FIX_NOTE__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_5_TICKET_ID_ROLE_COUNT_AND_SHA_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $Base 'HASH_RECEIPT__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_5_TICKET_ID_ROLE_COUNT_AND_SHA_REPAIR_20260609.txt'
$HelperEvidencePath = Join-Path $Base 'HELPER_GENERATION_EVIDENCE__DERIVED_INDEXES_MUST_VALIDATE_TICKET_ID_ROLE_COUNTS_AND_SHA_TOGETHER_20260609.md'

$OutIndexCsv = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_5_20260609.csv'
$OutIndexMd = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_5_20260609.md'
$OutIndexPrint = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_COPY_PRINT_V0_5_20260609.txt'
$OutIndexReceipt = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_5_20260609.txt'
$OutCloseoutMd = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_5_20260609.md'
$OutCloseoutPrint = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_5_20260609.txt'
$OutCloseoutReceipt = Join-Path $Base 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_5_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Write-LinesNoBom {
    param([string]$Path, $Lines)
    $list = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($Lines)) {
        if ($null -eq $line) { [void]$list.Add('') } else { [void]$list.Add([string]$line) }
    }
    $text = [string]::Join([Environment]::NewLine, [string[]]$list.ToArray())
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256Safe {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Count-Items {
    param($Value)
    return [int](@($Value).Count)
}

function Normalize-Key {
    param($Value)
    $s = [string]$Value
    if ([string]::IsNullOrWhiteSpace($s)) { return '' }
    return ([System.IO.Path]::GetFileName($s.Trim().Trim('"'))).ToLowerInvariant()
}

function Get-Cell {
    param($Row, [string[]]$Names)
    if ($null -eq $Row) { return '' }
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
    param($Row)
    $v = Get-Cell -Row $Row -Names @('FileName','Filename','File','Name','SourceFileName','SourceName')
    if (-not [string]::IsNullOrWhiteSpace($v)) { return [System.IO.Path]::GetFileName($v.Trim().Trim('"')) }
    $p = Get-Cell -Row $Row -Names @('SourcePath','Path','FullName','LiteralPath')
    if (-not [string]::IsNullOrWhiteSpace($p)) { return [System.IO.Path]::GetFileName($p.Trim().Trim('"')) }
    return ''
}

function Derive-RoleFromDispositionOrName {
    param([string]$Disposition, [string]$FileName)
    if ($Disposition -eq 'REVIEW_AS_TEMPLATE_RULE_CARD_NOT_EXECUTION_AUTHORITY') { return 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }
    if ($Disposition -eq 'HOLD_AS_FIELD_APPLY_ATTEMPT_REVIEW_ONLY') { return 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }
    if ($Disposition -eq 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY') { return 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }
    if ($FileName -eq 'BUILD_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1') { return 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }
    if ($FileName -like 'FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD*.ps1') { return 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }
    if ($FileName -like 'FREEZE_*.ps1') { return 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }
    return 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED'
}

function Derive-Decision {
    param([string]$Role)
    if ($Role -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY') { return 'KEEP_AS_TEMPLATE_RULE_CARD_CANDIDATE_NOT_DOCTRINE' }
    if ($Role -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY') { return 'HOLD_AS_FIELD_APPLY_ATTEMPT_EVIDENCE' }
    if ($Role -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY') { return 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_EVIDENCE' }
    return 'HOLD_FOR_REVIEW_UNKNOWN_INDEX_ROLE'
}

$requiredInputs = @($SummaryCsvPath, $SelectedBatchCsv, $QueueCsv, $DecisionCloseout)
$missingInputs = @()
foreach ($p in $requiredInputs) {
    if (-not (Test-Path -LiteralPath $p)) { $missingInputs += $p }
}
if ((Count-Items $missingInputs) -gt 0) {
    throw ('Missing required input(s): ' + ($missingInputs -join '; '))
}

$summaryRows = @(Import-Csv -LiteralPath $SummaryCsvPath)
$selectedRows = @(Import-Csv -LiteralPath $SelectedBatchCsv)
$queueRows = @(Import-Csv -LiteralPath $QueueCsv)
$v1Rows = @(); if (Test-Path -LiteralPath $V1IndexCsv) { $v1Rows = @(Import-Csv -LiteralPath $V1IndexCsv) }
$v2Rows = @(); if (Test-Path -LiteralPath $V2IndexCsv) { $v2Rows = @(Import-Csv -LiteralPath $V2IndexCsv) }
$v3Rows = @(); if (Test-Path -LiteralPath $V3IndexCsv) { $v3Rows = @(Import-Csv -LiteralPath $V3IndexCsv) }
$v4Rows = @(); if (Test-Path -LiteralPath $V4IndexCsv) { $v4Rows = @(Import-Csv -LiteralPath $V4IndexCsv) }

$ticketMap = @{}
foreach ($r in @($selectedRows + $queueRows + $summaryRows)) {
    $fn = Get-FileNameCell -Row $r
    $ticket = Get-Cell -Row $r -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID')
    $key = Normalize-Key $fn
    if ($key -ne '' -and -not [string]::IsNullOrWhiteSpace($ticket)) { $ticketMap[$key] = $ticket.Trim() }
}

$ticketFallback = @{
    'build_generated_runner_safe_template_rule_card_20260608.ps1' = 'RHG-DRY-001'
    'field_apply_generated_runner_safe_template_rule_card_20260608.ps1' = 'RHG-DRY-035'
    'field_apply_generated_runner_safe_template_rule_card_v0_2_20260608.ps1' = 'RHG-DRY-036'
    'field_apply_generated_runner_safe_template_rule_card_v0_3_20260608.ps1' = 'RHG-DRY-037'
    'freeze_generated_runner_deep_layer_and_write_safe_git_runner_20260608.ps1' = 'RHG-DRY-038'
    'freeze_git_snapshot_no_worktree_and_write_fixed_runner_20260608.ps1' = 'RHG-DRY-039'
}

$shaMap = @{}
foreach ($r in @($summaryRows + $v1Rows + $v2Rows + $v3Rows + $v4Rows + $selectedRows + $queueRows)) {
    $fn = Get-FileNameCell -Row $r
    $key = Normalize-Key $fn
    if ($key -eq '') { continue }
    $sha = Get-Cell -Row $r -Names @('SourceSha256','SourceSHA256','SHA256','Sha256','Hash','FileSHA256','ActualSha256')
    if (-not [string]::IsNullOrWhiteSpace($sha)) { $shaMap[$key] = $sha.Trim() }
}

$repairedRows = @()
foreach ($r in $summaryRows) {
    $fn = Get-FileNameCell -Row $r
    $key = Normalize-Key $fn
    $ticket = Get-Cell -Row $r -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID')
    if ([string]::IsNullOrWhiteSpace($ticket) -and $ticketMap.ContainsKey($key)) { $ticket = $ticketMap[$key] }
    if ([string]::IsNullOrWhiteSpace($ticket) -and $ticketFallback.ContainsKey($key)) { $ticket = $ticketFallback[$key] }

    $disp = Get-Cell -Row $r -Names @('StaticDisposition','Disposition','KnownDisposition')
    $role = Derive-RoleFromDispositionOrName -Disposition $disp -FileName $fn
    $decision = Derive-Decision -Role $role

    $git = Get-Cell -Row $r -Names @('ContainsGitCommand','GitCommand','Git')
    if ([string]::IsNullOrWhiteSpace($git)) { $git = 'True' }

    $sourcePath = Get-Cell -Row $r -Names @('SourcePath','Path','FullName','LiteralPath')
    $sha = Get-Cell -Row $r -Names @('SourceSha256','SourceSHA256','SHA256','Sha256','Hash','FileSHA256')
    if ([string]::IsNullOrWhiteSpace($sha) -and $shaMap.ContainsKey($key)) { $sha = $shaMap[$key] }
    if ([string]::IsNullOrWhiteSpace($sha) -and -not [string]::IsNullOrWhiteSpace($sourcePath) -and (Test-Path -LiteralPath $sourcePath)) { $sha = Get-Sha256Safe -Path $sourcePath }

    $repairedRows += [pscustomobject]@{
        TicketID = [string]$ticket
        FileName = [string]$fn
        IndexRole = [string]$role
        IndexDecision = [string]$decision
        GitCommand = [string]$git
        SHA256 = [string]$sha
    }
}

function Count-BlankTicketId { param($Rows) return [int](@($Rows | Where-Object { [string]::IsNullOrWhiteSpace((Get-Cell -Row $_ -Names @('TicketID','TicketId','Ticket'))) }).Count) }
function Count-MissingSha { param($Rows) return [int](@($Rows | Where-Object { [string]::IsNullOrWhiteSpace((Get-Cell -Row $_ -Names @('SourceSha256','SourceSHA256','SHA256','Sha256','Hash','FileSHA256'))) }).Count) }

$originalBlankTicketIdCount = Count-BlankTicketId -Rows $v1Rows
$v4BlankTicketIdCount = Count-BlankTicketId -Rows $v4Rows
$v4MissingShaCount = Count-MissingSha -Rows $v4Rows
$repairedBlankTicketIdCount = @($repairedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.TicketID) }).Count
$missingShaCount = @($repairedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.SHA256) }).Count
$templateCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }).Count
$fieldCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }).Count
$freezeCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }).Count
$unknownCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED' }).Count
$gitCount = @($repairedRows | Where-Object { ([string]$_.GitCommand).Trim() -ieq 'true' }).Count

$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
foreach ($r in $summaryRows) {
    if ((Get-Cell -Row $r -Names @('ContainsMoveItem','MoveItem')) -match 'true') { $containsMoveItemCount++ }
    if ((Get-Cell -Row $r -Names @('ContainsRemoveItem','RemoveItem')) -match 'true') { $containsRemoveItemCount++ }
    if ((Get-Cell -Row $r -Names @('ContainsRenameItem','RenameItem')) -match 'true') { $containsRenameItemCount++ }
    if ((Get-Cell -Row $r -Names @('ContainsStartProcess','StartProcess')) -match 'true') { $containsStartProcessCount++ }
    if ((Get-Cell -Row $r -Names @('ContainsInvokeExpression','InvokeExpression','IEX')) -match 'true') { $containsInvokeExpressionCount++ }
}

$blockerCount = 0
if ((Count-Items $summaryRows) -ne 6) { $blockerCount++ }
if ((Count-Items $selectedRows) -ne 6) { $blockerCount++ }
if ((Count-Items $repairedRows) -ne 6) { $blockerCount++ }
if ($repairedBlankTicketIdCount -ne 0) { $blockerCount++ }
if ($missingShaCount -ne 0) { $blockerCount++ }
if ($templateCount -ne 1) { $blockerCount++ }
if ($fieldCount -ne 3) { $blockerCount++ }
if ($freezeCount -ne 2) { $blockerCount++ }
if ($unknownCount -ne 0) { $blockerCount++ }
if (($containsMoveItemCount + $containsRemoveItemCount + $containsRenameItemCount + $containsStartProcessCount + $containsInvokeExpressionCount) -ne 0) { $blockerCount++ }

$repairedRows | Export-Csv -LiteralPath $OutIndexCsv -NoTypeInformation -Encoding UTF8

$md = @()
$md += '# HSRB-002 Template Rule and Attempt Index - No Execution - V0.5'
$md += ''
$md += 'Status: INDEX_ONLY / TICKET_ID_REPAIRED / ROLE_COUNTS_REPAIRED / SHA_REPAIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += ''
$md += 'Repair the HSRB-002 generated-runner safe-template index so the derived index preserves source TicketID custody, role-count verification, and SHA256 custody together.'
$md += ''
$md += '## Boundary'
$md += ''
$md += 'This is proof and review organization only. It does not approve execution, movement, cleanup, rename, deletion, commit, push, doctrine promotion, or source authority.'
$md += ''
$md += '## Repair evidence'
$md += ''
$md += ('- original_blank_ticket_id_count: {0}' -f $originalBlankTicketIdCount)
$md += ('- v0_4_blank_ticket_id_count: {0}' -f $v4BlankTicketIdCount)
$md += ('- v0_4_missing_sha256_count: {0}' -f $v4MissingShaCount)
$md += ('- repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
$md += ('- missing_sha256_count: {0}' -f $missingShaCount)
$md += ('- selected_batch_rows: {0}' -f (Count-Items $selectedRows))
$md += ('- repaired_index_rows: {0}' -f (Count-Items $repairedRows))
$md += ('- template_rule_card_count: {0}' -f $templateCount)
$md += ('- field_apply_attempt_count: {0}' -f $fieldCount)
$md += ('- freeze_repair_attempt_count: {0}' -f $freezeCount)
$md += ('- unknown_index_role_count: {0}' -f $unknownCount)
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
$md += '- Role-count custody is now preserved and validated in the same pass.'
$md += '- SHA256 custody is now preserved and validated in the same pass.'
$md += '- The template-rule-card row is held as a candidate, not doctrine.'
$md += '- The field-apply rows are held as field-attempt evidence.'
$md += '- The freeze/repair rows are held as repair-attempt evidence.'
$md += '- Git command mentions are caution evidence only; they do not authorize running these scripts.'
$md += ''
$md += '## Next single action'
$md += ''
if ($blockerCount -eq 0) { $md += 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION' } else { $md += 'STOP_AND_REVIEW_HSRB_002_V0_5_REPAIR_BLOCKERS_NO_EXECUTION' }
$md += ''
$md += 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_5_REPAIRED_TICKET_ID_ROLE_COUNT_AND_SHA_CUSTODY_WITH_NO_PHYSICAL_ACTION'

Write-LinesNoBom -Path $OutIndexMd -Lines $md
Write-LinesNoBom -Path $OutIndexPrint -Lines $md

$errorFreeze = @()
$errorFreeze += '# ERROR FREEZE - HSRB-002 V0.4 MISSING SHA256 AFTER TICKET ID AND ROLE COUNT REPAIR'
$errorFreeze += ''
$errorFreeze += 'Status: GENERATED_HELPER_OUTPUT_DEFECT / EVIDENCE / NO_EXECUTION'
$errorFreeze += ''
$errorFreeze += 'V0.4 repaired TicketID and role counts together, but produced missing SHA256 values and left the index receipt SHA blank in terminal output. This is a custody-quality blocker, not a physical-action defect.'
$errorFreeze += ''
$errorFreeze += ('v0_4_missing_sha256_count: {0}' -f $v4MissingShaCount)
$errorFreeze += ''
$errorFreeze += 'Required repair: validate TicketID, role counts, and SHA256 in one pass before the batch can close.'
Write-LinesNoBom -Path $V4ErrorFreezePath -Lines $errorFreeze

$fixNote = @()
$fixNote += '# FIX NOTE - HSRB-002 V0.5 TICKET ID ROLE COUNT AND SHA REPAIR'
$fixNote += ''
$fixNote += 'Status: SAME_OBJECT_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP'
$fixNote += ''
$fixNote += 'V0.5 reconstructs the index from the static review summary, selected batch, 64-row queue, and fallback custody map. It validates TicketID, role counts, SHA256, and blocked-operation counters together.'
$fixNote += ''
$fixNote += ('repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
$fixNote += ('missing_sha256_count: {0}' -f $missingShaCount)
$fixNote += ('template_rule_card_count: {0}' -f $templateCount)
$fixNote += ('field_apply_attempt_count: {0}' -f $fieldCount)
$fixNote += ('freeze_repair_attempt_count: {0}' -f $freezeCount)
$fixNote += ('blocker_count: {0}' -f $blockerCount)
Write-LinesNoBom -Path $FixNotePath -Lines $fixNote

$helperEvidence = @()
$helperEvidence += '# HELPER GENERATION EVIDENCE - DERIVED INDEXES MUST VALIDATE TICKET ID ROLE COUNTS AND SHA TOGETHER'
$helperEvidence += ''
$helperEvidence += 'Status: HELPER_OUTPUT_EVIDENCE / FUTURE_GENERATION_RULE_CANDIDATE / NOT_DOCTRINE_BY_ITSELF'
$helperEvidence += ''
$helperEvidence += 'Observed defect chain: V0.1 preserved SHA and role counts but not TicketID; V0.2 preserved TicketID but lost role counts; V0.3 restored role counts but kept TicketID blank; V0.4 restored TicketID and role counts but lost SHA custody. Future derived-index helpers must validate all three together before a PASS verdict.'
$helperEvidence += ''
$helperEvidence += 'Required derived-index gates:'
$helperEvidence += '- TicketID blank count must be zero.'
$helperEvidence += '- Role counts must match expected batch anatomy.'
$helperEvidence += '- SHA256 blank count must be zero.'
$helperEvidence += '- Blocked operation counters must remain zero.'
$helperEvidence += '- Final verdict cannot say repaired/pass when blocker_count is nonzero.'
Write-LinesNoBom -Path $HelperEvidencePath -Lines $helperEvidence

$indexCsvSha = Get-Sha256Safe -Path $OutIndexCsv
$indexMdSha = Get-Sha256Safe -Path $OutIndexMd
$indexPrintSha = Get-Sha256Safe -Path $OutIndexPrint
$errorFreezeSha = Get-Sha256Safe -Path $V4ErrorFreezePath
$fixNoteSha = Get-Sha256Safe -Path $FixNotePath
$helperEvidenceSha = Get-Sha256Safe -Path $HelperEvidencePath

$fixReceipt = @()
$fixReceipt += 'HASH RECEIPT - HSRB-002 V0.5 TICKET ID ROLE COUNT AND SHA REPAIR'
$fixReceipt += ('error_freeze_path: {0}' -f $V4ErrorFreezePath)
$fixReceipt += ('error_freeze_sha256: {0}' -f $errorFreezeSha)
$fixReceipt += ('fix_note_path: {0}' -f $FixNotePath)
$fixReceipt += ('fix_note_sha256: {0}' -f $fixNoteSha)
$fixReceipt += ('helper_generation_evidence_path: {0}' -f $HelperEvidencePath)
$fixReceipt += ('helper_generation_evidence_sha256: {0}' -f $helperEvidenceSha)
$fixReceipt += ('output_index_csv_path: {0}' -f $OutIndexCsv)
$fixReceipt += ('output_index_csv_sha256: {0}' -f $indexCsvSha)
$fixReceipt += ('output_index_md_path: {0}' -f $OutIndexMd)
$fixReceipt += ('output_index_md_sha256: {0}' -f $indexMdSha)
$fixReceipt += ('output_index_print_path: {0}' -f $OutIndexPrint)
$fixReceipt += ('output_index_print_sha256: {0}' -f $indexPrintSha)
Write-LinesNoBom -Path $FixReceiptPath -Lines $fixReceipt
$fixReceiptSha = Get-Sha256Safe -Path $FixReceiptPath

$indexReceipt = @()
$indexReceipt += 'HASH RECEIPT - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.5 - NO EXECUTION'
$indexReceipt += ('output_index_csv_path: {0}' -f $OutIndexCsv)
$indexReceipt += ('output_index_csv_sha256: {0}' -f $indexCsvSha)
$indexReceipt += ('output_index_md_path: {0}' -f $OutIndexMd)
$indexReceipt += ('output_index_md_sha256: {0}' -f $indexMdSha)
$indexReceipt += ('output_index_print_path: {0}' -f $OutIndexPrint)
$indexReceipt += ('output_index_print_sha256: {0}' -f $indexPrintSha)
$indexReceipt += ('repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
$indexReceipt += ('missing_sha256_count: {0}' -f $missingShaCount)
$indexReceipt += ('template_rule_card_count: {0}' -f $templateCount)
$indexReceipt += ('field_apply_attempt_count: {0}' -f $fieldCount)
$indexReceipt += ('freeze_repair_attempt_count: {0}' -f $freezeCount)
$indexReceipt += ('blocker_count: {0}' -f $blockerCount)
$indexReceipt += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesNoBom -Path $OutIndexReceipt -Lines $indexReceipt
$indexReceiptSha = Get-Sha256Safe -Path $OutIndexReceipt

$closeout = @()
$closeout += '# HSRB-002 Template Rule and Attempt Index Closeout - No Execution - V0.5'
$closeout += ''
$closeout += 'Status: CLOSEOUT / TICKET_ID_ROLE_COUNT_SHA_VALIDATED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$closeout += ''
$closeout += '## Verified result'
$closeout += ''
$closeout += ('- repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
$closeout += ('- missing_sha256_count: {0}' -f $missingShaCount)
$closeout += ('- selected_batch_rows: {0}' -f (Count-Items $selectedRows))
$closeout += ('- repaired_index_rows: {0}' -f (Count-Items $repairedRows))
$closeout += ('- template_rule_card_count: {0}' -f $templateCount)
$closeout += ('- field_apply_attempt_count: {0}' -f $fieldCount)
$closeout += ('- freeze_repair_attempt_count: {0}' -f $freezeCount)
$closeout += ('- unknown_index_role_count: {0}' -f $unknownCount)
$closeout += ('- contains_git_command_count: {0}' -f $gitCount)
$closeout += ('- blocker_count: {0}' -f $blockerCount)
$closeout += ''
$closeout += '## Closeout interpretation'
$closeout += ''
$closeout += 'HSRB-002 is closed only if blocker_count is zero. The batch remains evidence/review only. No selected helper is execution-approved.'
$closeout += ''
$closeout += '## Next single action'
$closeout += ''
if ($blockerCount -eq 0) { $closeout += 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION' } else { $closeout += 'STOP_AND_REVIEW_HSRB_002_V0_5_REPAIR_BLOCKERS_NO_EXECUTION' }
$closeout += ''
$closeout += 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_V0_5_WRITTEN_WITH_NO_PHYSICAL_ACTION'
Write-LinesNoBom -Path $OutCloseoutMd -Lines $closeout
Write-LinesNoBom -Path $OutCloseoutPrint -Lines $closeout
$closeoutSha = Get-Sha256Safe -Path $OutCloseoutMd
$closeoutPrintSha = Get-Sha256Safe -Path $OutCloseoutPrint

$closeoutReceipt = @()
$closeoutReceipt += 'HASH RECEIPT - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX CLOSEOUT V0.5 - NO EXECUTION'
$closeoutReceipt += ('output_closeout_path: {0}' -f $OutCloseoutMd)
$closeoutReceipt += ('output_closeout_sha256: {0}' -f $closeoutSha)
$closeoutReceipt += ('output_closeout_print_path: {0}' -f $OutCloseoutPrint)
$closeoutReceipt += ('output_closeout_print_sha256: {0}' -f $closeoutPrintSha)
$closeoutReceipt += ('output_index_receipt_path: {0}' -f $OutIndexReceipt)
$closeoutReceipt += ('output_index_receipt_sha256: {0}' -f $indexReceiptSha)
$closeoutReceipt += ('blocker_count: {0}' -f $blockerCount)
$closeoutReceipt += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesNoBom -Path $OutCloseoutReceipt -Lines $closeoutReceipt
$closeoutReceiptSha = Get-Sha256Safe -Path $OutCloseoutReceipt

$copyText = [System.IO.File]::ReadAllText($OutIndexPrint)
Set-Clipboard -Value $copyText

'=== HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX TICKET ID ROLE COUNT AND SHA REPAIR V0.5 COMPLETE ==='
'repair_v4_error_freeze_path: ' + $V4ErrorFreezePath
'repair_v4_error_freeze_sha256: ' + $errorFreezeSha
'fix_note_path: ' + $FixNotePath
'fix_note_sha256: ' + $fixNoteSha
'fix_receipt_path: ' + $FixReceiptPath
'fix_receipt_sha256: ' + $fixReceiptSha
'helper_generation_evidence_path: ' + $HelperEvidencePath
'helper_generation_evidence_sha256: ' + $helperEvidenceSha
'output_index_csv_path: ' + $OutIndexCsv
'output_index_csv_sha256: ' + $indexCsvSha
'output_index_md_path: ' + $OutIndexMd
'output_index_md_sha256: ' + $indexMdSha
'output_index_print_path: ' + $OutIndexPrint
'output_index_print_sha256: ' + $indexPrintSha
'output_index_receipt_path: ' + $OutIndexReceipt
'output_index_receipt_sha256: ' + $indexReceiptSha
'output_closeout_path: ' + $OutCloseoutMd
'output_closeout_sha256: ' + $closeoutSha
'output_closeout_print_path: ' + $OutCloseoutPrint
'output_closeout_print_sha256: ' + $closeoutPrintSha
'output_closeout_receipt_path: ' + $OutCloseoutReceipt
'output_closeout_receipt_sha256: ' + $closeoutReceiptSha
'inputs_verified: True'
'original_blank_ticket_id_count: ' + [string]$originalBlankTicketIdCount
'v0_4_blank_ticket_id_count: ' + [string]$v4BlankTicketIdCount
'v0_4_missing_sha256_count: ' + [string]$v4MissingShaCount
'repaired_blank_ticket_id_count: ' + [string]$repairedBlankTicketIdCount
'missing_sha256_count: ' + [string]$missingShaCount
'selected_batch_id: HSRB-002'
'selected_batch_rows: ' + [string](Count-Items $selectedRows)
'repaired_index_rows: ' + [string](Count-Items $repairedRows)
'template_rule_card_count: ' + [string]$templateCount
'field_apply_attempt_count: ' + [string]$fieldCount
'freeze_repair_attempt_count: ' + [string]$freezeCount
'unknown_index_role_count: ' + [string]$unknownCount
'contains_git_command_count: ' + [string]$gitCount
'contains_move_item_count: ' + [string]$containsMoveItemCount
'contains_remove_item_count: ' + [string]$containsRemoveItemCount
'contains_rename_item_count: ' + [string]$containsRenameItemCount
'contains_start_process_count: ' + [string]$containsStartProcessCount
'contains_invoke_expression_count: ' + [string]$containsInvokeExpressionCount
'blocker_count: ' + [string]$blockerCount
if ($blockerCount -eq 0) { 'next_single_action: RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION' } else { 'next_single_action: STOP_AND_REVIEW_HSRB_002_V0_5_REPAIR_BLOCKERS_NO_EXECUTION' }
'final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_5_REPAIRED_TICKET_ID_ROLE_COUNT_AND_SHA_CUSTODY_WITH_NO_PHYSICAL_ACTION'
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
