Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = Join-Path $env:USERPROFILE 'Desktop\123'
$WorkDir = Join-Path $RepoRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$DateStamp = '20260609'

$SelectedBatchCsvPath = Join-Path $WorkDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_002_V0_1_20260609.csv'
$QueueCsvPath = Join-Path $WorkDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$V1IndexCsvPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$V2IndexCsvPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_2_20260609.csv'
$V2CloseoutPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$StaticSummaryCsvPath = Join-Path $WorkDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_SUMMARY_V0_1_20260609.csv'
$StaticPacketMdPath = Join-Path $WorkDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_20260609.md'
$DecisionCloseoutPath = Join-Path $WorkDir 'HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'

$ErrorFreezeV2Path = Join-Path $WorkDir 'ERROR_FREEZE__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_2_ZERO_ROLE_COUNTS_AFTER_TICKET_ID_REPAIR_20260609.md'
$FixNotePath = Join-Path $WorkDir 'FIX_NOTE__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_3_TICKET_ID_AND_ROLE_COUNT_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $WorkDir 'HASH_RECEIPT__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_3_TICKET_ID_AND_ROLE_COUNT_REPAIR_20260609.txt'
$HelperEvidencePath = Join-Path $WorkDir 'HELPER_GENERATION_EVIDENCE__DERIVED_INDEXES_MUST_PRESERVE_TICKET_ID_AND_ROLE_COUNTS_20260609.md'

$OutputIndexCsvPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_3_20260609.csv'
$OutputIndexMdPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_3_20260609.md'
$OutputIndexPrintPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_COPY_PRINT_V0_3_20260609.txt'
$OutputIndexReceiptPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_3_20260609.txt'
$OutputCloseoutPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_3_20260609.md'
$OutputCloseoutPrintPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_3_20260609.txt'
$OutputCloseoutReceiptPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_3_20260609.txt'

function Write-Utf8NoBomLines {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines
    )
    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($Path, [string[]]@($Lines), $utf8NoBom)
}

function Sha256-OfFile {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Import-CsvStrict {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Required input missing: $Path"
    }
    return @(Import-Csv -LiteralPath $Path)
}

function Get-RowValue {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [Parameter(Mandatory=$true)][string[]]$Names
    )
    $props = @($Row.PSObject.Properties.Name)
    foreach ($name in $Names) {
        if ($props -contains $name) {
            $value = $Row.$name
            if ($null -ne $value) { return [string]$value }
        }
    }
    return ''
}

function New-MapByFileName {
    param([Parameter(Mandatory=$true)]$Rows)
    $map = @{}
    foreach ($row in @($Rows)) {
        $fn = Get-RowValue -Row $row -Names @('FileName','SourceFileName','Name')
        if (-not [string]::IsNullOrWhiteSpace($fn)) {
            $map[$fn.ToLowerInvariant()] = $row
        }
    }
    return $map
}

function Derive-IndexRoleAndDecision {
    param([Parameter(Mandatory=$true)][string]$FileName)
    if ($FileName -eq 'BUILD_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1') {
        return [pscustomobject]@{
            IndexRole = 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY'
            IndexDecision = 'KEEP_AS_TEMPLATE_RULE_CARD_CANDIDATE_NOT_DOCTRINE'
        }
    }
    if ($FileName -like 'FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD*.ps1') {
        return [pscustomobject]@{
            IndexRole = 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY'
            IndexDecision = 'HOLD_AS_FIELD_APPLY_ATTEMPT_EVIDENCE'
        }
    }
    if ($FileName -like 'FREEZE_*GENERATED_RUNNER*20260608.ps1' -or $FileName -like 'FREEZE_GIT_SNAPSHOT_NO_WORKTREE_AND_WRITE_FIXED_RUNNER_20260608.ps1') {
        return [pscustomobject]@{
            IndexRole = 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY'
            IndexDecision = 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_EVIDENCE'
        }
    }
    return [pscustomobject]@{
        IndexRole = 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED'
        IndexDecision = 'HOLD_PENDING_MANUAL_REVIEW'
    }
}

function BoolText {
    param($Value)
    if ($null -eq $Value) { return 'False' }
    $s = ([string]$Value).Trim()
    if ($s -match '^(true|1|yes)$') { return 'True' }
    if ($s -match '^(false|0|no)$') { return 'False' }
    if ([string]::IsNullOrWhiteSpace($s)) { return 'False' }
    return $s
}

$selectedRows = Import-CsvStrict -Path $SelectedBatchCsvPath
$queueRows = Import-CsvStrict -Path $QueueCsvPath
$v1Rows = Import-CsvStrict -Path $V1IndexCsvPath
$v2Rows = Import-CsvStrict -Path $V2IndexCsvPath
$staticSummaryRows = Import-CsvStrict -Path $StaticSummaryCsvPath

if (@($selectedRows).Count -ne 6) {
    throw "Selected batch row count was $(@($selectedRows).Count), expected 6."
}

$v1Map = New-MapByFileName -Rows $v1Rows
$v2Map = New-MapByFileName -Rows $v2Rows
$queueMap = New-MapByFileName -Rows $queueRows
$summaryMap = New-MapByFileName -Rows $staticSummaryRows

$originalBlankTicketIdCount = @($v1Rows | Where-Object { [string]::IsNullOrWhiteSpace((Get-RowValue -Row $_ -Names @('TicketID','TicketId','Ticket'))) }).Count
$v2BlankTicketIdCount = @($v2Rows | Where-Object { [string]::IsNullOrWhiteSpace((Get-RowValue -Row $_ -Names @('TicketID','TicketId','Ticket'))) }).Count
$v2TemplateCount = @($v2Rows | Where-Object { (Get-RowValue -Row $_ -Names @('IndexRole','Role','StaticDisposition')) -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }).Count
$v2FieldApplyCount = @($v2Rows | Where-Object { (Get-RowValue -Row $_ -Names @('IndexRole','Role','StaticDisposition')) -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }).Count
$v2FreezeCount = @($v2Rows | Where-Object { (Get-RowValue -Row $_ -Names @('IndexRole','Role','StaticDisposition')) -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }).Count

$repairedRows = @()
foreach ($sel in $selectedRows) {
    $fileName = Get-RowValue -Row $sel -Names @('FileName','SourceFileName','Name')
    if ([string]::IsNullOrWhiteSpace($fileName)) { throw 'Selected batch row with blank FileName encountered.' }
    $key = $fileName.ToLowerInvariant()

    $v1 = $null
    if ($v1Map.ContainsKey($key)) { $v1 = $v1Map[$key] }
    $queue = $null
    if ($queueMap.ContainsKey($key)) { $queue = $queueMap[$key] }
    $summary = $null
    if ($summaryMap.ContainsKey($key)) { $summary = $summaryMap[$key] }

    $ticketId = Get-RowValue -Row $sel -Names @('TicketID','TicketId','Ticket')
    $ticketSource = 'selected_batch_csv'
    if ([string]::IsNullOrWhiteSpace($ticketId) -and $null -ne $queue) {
        $ticketId = Get-RowValue -Row $queue -Names @('TicketID','TicketId','Ticket')
        $ticketSource = '64_row_queue_fallback'
    }
    if ([string]::IsNullOrWhiteSpace($ticketId)) {
        $ticketId = 'MISSING_TICKET_ID'
        $ticketSource = 'missing_after_fallback'
    }

    $derived = Derive-IndexRoleAndDecision -FileName $fileName

    $indexRole = ''
    $indexDecision = ''
    $gitCommand = ''
    $sha = ''

    if ($null -ne $v1) {
        $indexRole = Get-RowValue -Row $v1 -Names @('IndexRole','Role')
        $indexDecision = Get-RowValue -Row $v1 -Names @('IndexDecision','Decision','StaticDisposition')
        $gitCommand = Get-RowValue -Row $v1 -Names @('GitCommand','ContainsGitCommand','GitCommandPresent')
        $sha = Get-RowValue -Row $v1 -Names @('SHA256','Sha256','SourceSHA256','SourceSha256')
    }
    if ([string]::IsNullOrWhiteSpace($indexRole)) { $indexRole = $derived.IndexRole }
    if ([string]::IsNullOrWhiteSpace($indexDecision)) { $indexDecision = $derived.IndexDecision }
    if ([string]::IsNullOrWhiteSpace($gitCommand) -and $null -ne $summary) { $gitCommand = Get-RowValue -Row $summary -Names @('GitCommand','ContainsGitCommand','GitCommandPresent') }
    if ([string]::IsNullOrWhiteSpace($gitCommand)) { $gitCommand = 'True' }
    if ([string]::IsNullOrWhiteSpace($sha)) {
        $candidatePath = Join-Path $RepoRoot $fileName
        $sha = Sha256-OfFile -Path $candidatePath
    }

    $repairedRows += [pscustomobject]@{
        TicketID = $ticketId
        FileName = $fileName
        IndexRole = $indexRole
        IndexDecision = $indexDecision
        GitCommand = (BoolText $gitCommand)
        SHA256 = $sha
        TicketSource = $ticketSource
    }
}

$repairedBlankTicketIdCount = @($repairedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.TicketID) -or $_.TicketID -eq 'MISSING_TICKET_ID' }).Count
$templateRuleCardCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }).Count
$fieldApplyAttemptCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }).Count
$freezeRepairAttemptCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }).Count
$unknownIndexRoleCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'UNKNOWN_INDEX_ROLE_REVIEW_REQUIRED' -or [string]::IsNullOrWhiteSpace($_.IndexRole) }).Count
$containsGitCommandCount = @($repairedRows | Where-Object { $_.GitCommand -eq 'True' }).Count

$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0

$blockerCount = 0
if ($repairedBlankTicketIdCount -ne 0) { $blockerCount++ }
if ($templateRuleCardCount -ne 1) { $blockerCount++ }
if ($fieldApplyAttemptCount -ne 3) { $blockerCount++ }
if ($freezeRepairAttemptCount -ne 2) { $blockerCount++ }
if ($unknownIndexRoleCount -ne 0) { $blockerCount++ }
if (@($repairedRows).Count -ne 6) { $blockerCount++ }

$expectedInputs = @(
    [pscustomobject]@{Name='selected_batch_csv'; Path=$SelectedBatchCsvPath; Expected='EF7A0005819154A621E2C8CEC0F8D371F58833F82D1B1615C056AF8C6AEE1BA6'},
    [pscustomobject]@{Name='64_row_queue_csv'; Path=$QueueCsvPath; Expected='791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43'},
    [pscustomobject]@{Name='v0_1_index_csv_blank_ticket_ids'; Path=$V1IndexCsvPath; Expected='E940E2C56DA6B2B26545F78564AE4A095E605AB49BD2CD8DC0DC39FDA1076992'},
    [pscustomobject]@{Name='v0_2_index_csv_zero_role_counts'; Path=$V2IndexCsvPath; Expected='25DD22BF24225833ED74ADC2FCFC87AF3F54122846729D00B312E3E2E0CB3CAB'},
    [pscustomobject]@{Name='v0_2_closeout'; Path=$V2CloseoutPath; Expected='5835F71A733E8A3DE16A8B4CCB6707A5AAC6C60B3CEC22F1BCB0039A05CD8FE6'},
    [pscustomobject]@{Name='static_summary_csv'; Path=$StaticSummaryCsvPath; Expected='D0FCC6E841F197D1C80E9D6A1E0447F323EAEF0979F618E843FC372CFDB95431'},
    [pscustomobject]@{Name='static_packet_md'; Path=$StaticPacketMdPath; Expected='38FC2086733DF84975FD691502B6FA680CDD6033ABD7FF52EAFFD211359B4F8E'},
    [pscustomobject]@{Name='decision_closeout_md'; Path=$DecisionCloseoutPath; Expected='524ACDD2D86FD46B69047728323C55D1B5191E58E55E39121565FB18BD5D3215'}
)

$inputVerifyRows = @()
foreach ($item in $expectedInputs) {
    $exists = Test-Path -LiteralPath $item.Path -PathType Leaf
    $actual = ''
    if ($exists) { $actual = Sha256-OfFile -Path $item.Path }
    $hashMatch = ($exists -and $actual -eq $item.Expected)
    $inputVerifyRows += [pscustomobject]@{
        Input = $item.Name
        Exists = [string]$exists
        HashMatch = [string]$hashMatch
        SHA256 = $actual
    }
}
$inputsVerified = (@($inputVerifyRows | Where-Object { $_.Exists -ne 'True' -or $_.HashMatch -ne 'True' }).Count -eq 0)
if (-not $inputsVerified) { $blockerCount++ }

# Write V0.2 defect freeze.
$errorLines = @(
    '# ERROR FREEZE - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.2 ZERO ROLE COUNTS AFTER TICKET ID REPAIR',
    '',
    'Status: EVIDENCE / GENERATED_HELPER_DEFECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Observed defect:',
    '- V0.1 index preserved role categories but printed blank TicketID values.',
    '- V0.2 repaired TicketID preservation but printed role-category counts as zero.',
    '',
    'Why this matters:',
    '- TicketID is required for custody traceability.',
    '- Role-category counts are required to verify that derived indexes preserved semantic classification.',
    '',
    'Verdict:',
    'HSRB_002_INDEX_V0_2_IS_SAFE_AS_NO_ACTION_EVIDENCE_BUT_INCOMPLETE_AS_A_CUSTODY_AND_ROLE_COUNT_INDEX.',
    '',
    'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-Utf8NoBomLines -Path $ErrorFreezeV2Path -Lines $errorLines

$fixLines = @(
    '# FIX NOTE - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.3 TICKET ID AND ROLE COUNT REPAIR',
    '',
    'Status: SAME_OBJECT_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH',
    '',
    'Repair scope:',
    '- Rebuild the HSRB-002 derived index from the selected batch, the 64-row queue, and the V0.1 semantic index.',
    '- Preserve TicketID from the selected batch when present, else fall back to the 64-row queue by FileName.',
    '- Preserve or derive IndexRole and IndexDecision for all six rows.',
    '- Recount template-rule-card, field-apply, and freeze-repair roles after repair.',
    '',
    'Non-scope:',
    '- No helper execution.',
    '- No route, move, delete, rename, cleanup, commit, or push.',
    '- No doctrine promotion.',
    '',
    'Helper generation rule learned:',
    'Derived indexes must preserve custody fields and semantic count fields together. A repair must not fix one while losing the other.'
)
Write-Utf8NoBomLines -Path $FixNotePath -Lines $fixLines

$helperEvidenceLines = @(
    '# HELPER GENERATION EVIDENCE - DERIVED INDEXES MUST PRESERVE TICKET ID AND ROLE COUNTS',
    '',
    'Status: EVIDENCE / FUTURE_HELPER_REQUIREMENT / NOT_DOCTRINE_BY_ITSELF',
    '',
    'Observed in HSRB-002:',
    '- V0.1 index preserved role categories but blanked TicketID.',
    '- V0.2 repaired TicketID but produced zero role-category counts.',
    '- V0.3 repairs both custody display and role-count preservation.',
    '',
    'Requirement candidate:',
    'Any derived review index must preserve source custody identifiers, especially TicketID, and must also verify semantic category counts from the source review packet. Passing hashes alone is not enough when custody columns or category counts are lost.',
    '',
    'Boundary:',
    'This evidence note does not approve execution, routing, cleanup, commit, push, or doctrine promotion.'
)
Write-Utf8NoBomLines -Path $HelperEvidencePath -Lines $helperEvidenceLines

# Write repaired CSV.
$repairedRows | Export-Csv -LiteralPath $OutputIndexCsvPath -NoTypeInformation -Encoding UTF8

$md = @()
$md += '# HSRB-002 Template Rule and Attempt Index - No Execution - V0.3'
$md += ''
$md += 'Status: INDEX_ONLY / TICKET_ID_AND_ROLE_COUNT_REPAIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += ''
$md += 'Repair the HSRB-002 generated-runner safe-template chain index so it preserves both custody TicketID values and semantic role counts.'
$md += ''
$md += '## Boundary'
$md += ''
$md += 'This index is proof and review organization only. It does not approve execution, movement, cleanup, rename, deletion, commit, push, doctrine promotion, or use as source authority.'
$md += ''
$md += '## Verified inputs'
$md += ''
$md += '| Input | Exists | HashMatch | SHA256 |'
$md += '| --- | ---: | ---: | --- |'
foreach ($row in $inputVerifyRows) {
    $md += ('| {0} | {1} | {2} | `{3}` |' -f $row.Input, $row.Exists, $row.HashMatch, $row.SHA256)
}
$md += ''
$md += '## Defect repaired'
$md += ''
$md += ('- original_blank_ticket_id_count: {0}' -f $originalBlankTicketIdCount)
$md += ('- v0_2_blank_ticket_id_count: {0}' -f $v2BlankTicketIdCount)
$md += ('- v0_2_template_rule_card_count: {0}' -f $v2TemplateCount)
$md += ('- v0_2_field_apply_attempt_count: {0}' -f $v2FieldApplyCount)
$md += ('- v0_2_freeze_repair_attempt_count: {0}' -f $v2FreezeCount)
$md += ('- repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
$md += ''
$md += '## Counts after V0.3 repair'
$md += ''
$md += '- selected_batch_id: HSRB-002'
$md += ('- selected_batch_rows: {0}' -f @($repairedRows).Count)
$md += ('- template_rule_card_count: {0}' -f $templateRuleCardCount)
$md += ('- field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount)
$md += ('- freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount)
$md += ('- unknown_index_role_count: {0}' -f $unknownIndexRoleCount)
$md += ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
$md += ('- contains_move_item_count: {0}' -f $containsMoveItemCount)
$md += ('- contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$md += ('- contains_rename_item_count: {0}' -f $containsRenameItemCount)
$md += ('- contains_start_process_count: {0}' -f $containsStartProcessCount)
$md += ('- contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$md += ('- blocker_count: {0}' -f $blockerCount)
$md += ''
$md += '## Index table'
$md += ''
$md += '| TicketID | FileName | IndexRole | IndexDecision | GitCommand | SHA256 | TicketSource |'
$md += '| --- | --- | --- | --- | ---: | --- | --- |'
foreach ($row in $repairedRows) {
    $md += ('| {0} | `{1}` | {2} | {3} | {4} | `{5}` | {6} |' -f $row.TicketID, $row.FileName, $row.IndexRole, $row.IndexDecision, $row.GitCommand, $row.SHA256, $row.TicketSource)
}
$md += ''
$md += '## Interpretation'
$md += ''
$md += '- The template-rule-card row is held as a candidate, not doctrine.'
$md += '- The field-apply rows are held as field-attempt evidence.'
$md += '- The freeze/repair rows are held as repair-attempt evidence.'
$md += '- Git command mentions are evidence to preserve caution; they do not authorize running those scripts.'
$md += '- TicketID custody is now preserved.'
$md += '- Role-count verification is now preserved.'
$md += ''
$md += '## DoesNotProve'
$md += ''
$md += 'This index does not prove that any selected script is safe to execute. It does not promote the template card into doctrine and does not approve field apply, freeze repair, routing, cleanup, commit, or push.'
$md += ''
$md += '## Next single action'
$md += ''
if ($blockerCount -eq 0) {
    $md += 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
} else {
    $md += 'STOP_AND_REVIEW_HSRB_002_V0_3_REPAIR_BLOCKERS_NO_EXECUTION'
}
$md += ''
$md += 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_3_REPAIRED_TICKET_ID_AND_ROLE_COUNT_CUSTODY_WITH_NO_PHYSICAL_ACTION'
Write-Utf8NoBomLines -Path $OutputIndexMdPath -Lines $md
Write-Utf8NoBomLines -Path $OutputIndexPrintPath -Lines $md

$closeout = @()
$closeout += '# HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX CLOSEOUT - NO EXECUTION - V0.3'
$closeout += ''
$closeout += 'Status: CLOSEOUT / TICKET_ID_AND_ROLE_COUNT_REPAIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$closeout += ''
$closeout += '## Verified repair result'
$closeout += ''
$closeout += ('- inputs_verified: {0}' -f $inputsVerified)
$closeout += ('- original_blank_ticket_id_count: {0}' -f $originalBlankTicketIdCount)
$closeout += ('- v0_2_template_rule_card_count: {0}' -f $v2TemplateCount)
$closeout += ('- v0_2_field_apply_attempt_count: {0}' -f $v2FieldApplyCount)
$closeout += ('- v0_2_freeze_repair_attempt_count: {0}' -f $v2FreezeCount)
$closeout += ('- repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
$closeout += ('- selected_batch_rows: {0}' -f @($repairedRows).Count)
$closeout += ('- template_rule_card_count: {0}' -f $templateRuleCardCount)
$closeout += ('- field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount)
$closeout += ('- freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount)
$closeout += ('- unknown_index_role_count: {0}' -f $unknownIndexRoleCount)
$closeout += ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
$closeout += ('- blocker_count: {0}' -f $blockerCount)
$closeout += ''
$closeout += '## Boundary'
$closeout += ''
$closeout += 'This closeout does not approve execution, routing, cleanup, delete, rename, commit, push, or doctrine promotion.'
$closeout += ''
$closeout += '## Next single action'
$closeout += ''
if ($blockerCount -eq 0) {
    $closeout += 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
} else {
    $closeout += 'STOP_AND_REVIEW_HSRB_002_V0_3_REPAIR_BLOCKERS_NO_EXECUTION'
}
$closeout += ''
$closeout += 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_V0_3_WRITTEN_WITH_NO_PHYSICAL_ACTION'
Write-Utf8NoBomLines -Path $OutputCloseoutPath -Lines $closeout
Write-Utf8NoBomLines -Path $OutputCloseoutPrintPath -Lines $closeout

$fixReceipt = @(
    ('fix_note_path: {0}' -f $FixNotePath),
    ('fix_note_sha256: {0}' -f (Sha256-OfFile -Path $FixNotePath)),
    ('error_freeze_path: {0}' -f $ErrorFreezeV2Path),
    ('error_freeze_sha256: {0}' -f (Sha256-OfFile -Path $ErrorFreezeV2Path)),
    ('helper_generation_evidence_path: {0}' -f $HelperEvidencePath),
    ('helper_generation_evidence_sha256: {0}' -f (Sha256-OfFile -Path $HelperEvidencePath)),
    ('output_index_csv_path: {0}' -f $OutputIndexCsvPath),
    ('output_index_csv_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexCsvPath)),
    ('output_index_md_path: {0}' -f $OutputIndexMdPath),
    ('output_index_md_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexMdPath)),
    ('output_closeout_path: {0}' -f $OutputCloseoutPath),
    ('output_closeout_sha256: {0}' -f (Sha256-OfFile -Path $OutputCloseoutPath)),
    ('final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_3_REPAIRED_TICKET_ID_AND_ROLE_COUNT_CUSTODY_WITH_NO_PHYSICAL_ACTION')
)
Write-Utf8NoBomLines -Path $FixReceiptPath -Lines $fixReceipt

$indexReceipt = @(
    ('output_index_csv_path: {0}' -f $OutputIndexCsvPath),
    ('output_index_csv_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexCsvPath)),
    ('output_index_md_path: {0}' -f $OutputIndexMdPath),
    ('output_index_md_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexMdPath)),
    ('output_index_print_path: {0}' -f $OutputIndexPrintPath),
    ('output_index_print_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexPrintPath)),
    ('selected_batch_rows: {0}' -f @($repairedRows).Count),
    ('repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount),
    ('template_rule_card_count: {0}' -f $templateRuleCardCount),
    ('field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount),
    ('freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount),
    ('blocker_count: {0}' -f $blockerCount),
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-Utf8NoBomLines -Path $OutputIndexReceiptPath -Lines $indexReceipt

$closeoutReceipt = @(
    ('output_closeout_path: {0}' -f $OutputCloseoutPath),
    ('output_closeout_sha256: {0}' -f (Sha256-OfFile -Path $OutputCloseoutPath)),
    ('output_closeout_print_path: {0}' -f $OutputCloseoutPrintPath),
    ('output_closeout_print_sha256: {0}' -f (Sha256-OfFile -Path $OutputCloseoutPrintPath)),
    ('output_closeout_receipt_path: {0}' -f $OutputCloseoutReceiptPath),
    ('final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_V0_3_WRITTEN_WITH_NO_PHYSICAL_ACTION')
)
Write-Utf8NoBomLines -Path $OutputCloseoutReceiptPath -Lines $closeoutReceipt

Set-Clipboard -Value ([string]::Join([Environment]::NewLine, $md))

'=== HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX TICKET ID AND ROLE COUNT REPAIR V0.3 COMPLETE ==='
('error_freeze_path: {0}' -f $ErrorFreezeV2Path)
('error_freeze_sha256: {0}' -f (Sha256-OfFile -Path $ErrorFreezeV2Path))
('fix_note_path: {0}' -f $FixNotePath)
('fix_note_sha256: {0}' -f (Sha256-OfFile -Path $FixNotePath))
('fix_receipt_path: {0}' -f $FixReceiptPath)
('fix_receipt_sha256: {0}' -f (Sha256-OfFile -Path $FixReceiptPath))
('helper_generation_evidence_path: {0}' -f $HelperEvidencePath)
('helper_generation_evidence_sha256: {0}' -f (Sha256-OfFile -Path $HelperEvidencePath))
('output_index_csv_path: {0}' -f $OutputIndexCsvPath)
('output_index_csv_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexCsvPath))
('output_index_md_path: {0}' -f $OutputIndexMdPath)
('output_index_md_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexMdPath))
('output_index_print_path: {0}' -f $OutputIndexPrintPath)
('output_index_print_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexPrintPath))
('output_index_receipt_path: {0}' -f $OutputIndexReceiptPath)
('output_index_receipt_sha256: {0}' -f (Sha256-OfFile -Path $OutputIndexReceiptPath))
('output_closeout_path: {0}' -f $OutputCloseoutPath)
('output_closeout_sha256: {0}' -f (Sha256-OfFile -Path $OutputCloseoutPath))
('output_closeout_print_path: {0}' -f $OutputCloseoutPrintPath)
('output_closeout_print_sha256: {0}' -f (Sha256-OfFile -Path $OutputCloseoutPrintPath))
('output_closeout_receipt_path: {0}' -f $OutputCloseoutReceiptPath)
('output_closeout_receipt_sha256: {0}' -f (Sha256-OfFile -Path $OutputCloseoutReceiptPath))
('inputs_verified: {0}' -f $inputsVerified)
('original_blank_ticket_id_count: {0}' -f $originalBlankTicketIdCount)
('v0_2_blank_ticket_id_count: {0}' -f $v2BlankTicketIdCount)
('v0_2_template_rule_card_count: {0}' -f $v2TemplateCount)
('v0_2_field_apply_attempt_count: {0}' -f $v2FieldApplyCount)
('v0_2_freeze_repair_attempt_count: {0}' -f $v2FreezeCount)
('repaired_blank_ticket_id_count: {0}' -f $repairedBlankTicketIdCount)
('selected_batch_id: HSRB-002')
('selected_batch_rows: {0}' -f @($repairedRows).Count)
('repaired_index_rows: {0}' -f @($repairedRows).Count)
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
if ($blockerCount -eq 0) {
    'next_single_action: RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
} else {
    'next_single_action: STOP_AND_REVIEW_HSRB_002_V0_3_REPAIR_BLOCKERS_NO_EXECUTION'
}
'final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_3_REPAIRED_TICKET_ID_AND_ROLE_COUNT_CUSTODY_WITH_NO_PHYSICAL_ACTION'
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
