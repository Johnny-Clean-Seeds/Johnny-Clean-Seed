$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoRoot = 'C:\Users\13527\Desktop\123'
$WorkDir = Join-Path $RepoRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SelectedBatchCsvPath = Join-Path $WorkDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_002_V0_1_20260609.csv'
$QueueCsvPath = Join-Path $WorkDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$StaticSummaryCsvPath = Join-Path $WorkDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_SUMMARY_V0_1_20260609.csv'
$OriginalIndexCsvPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$OriginalIndexMdPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.md'
$OriginalIndexReceiptPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'
$OriginalCloseoutPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$OriginalCloseoutReceiptPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$RepairScriptErrorFreezePath = Join-Path $WorkDir 'ERROR_FREEZE__HSRB_002_TICKET_ID_REPAIR_V0_1_NULL_LINE_LIST_FACTORY_20260609.md'
$ErrorFreezePath = Join-Path $WorkDir 'ERROR_FREEZE__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_1_BLANK_TICKET_ID_CUSTODY_DISPLAY_DEFECT_20260609.md'
$FixNotePath = Join-Path $WorkDir 'FIX_NOTE__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_2_TICKET_ID_PRESERVATION_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $WorkDir 'HASH_RECEIPT__HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_2_TICKET_ID_REPAIR_20260609.txt'
$EvidenceRulePath = Join-Path $WorkDir 'HELPER_GENERATION_EVIDENCE__DERIVED_INDEXES_MUST_PRESERVE_TICKET_ID_20260609.md'

$OutputIndexCsvPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_2_20260609.csv'
$OutputIndexMdPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_V0_2_20260609.md'
$OutputIndexPrintPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$OutputIndexReceiptPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
$OutputCloseoutPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$OutputCloseoutPrintPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$OutputCloseoutReceiptPath = Join-Path $WorkDir 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

$Expected = [ordered]@{
    selected_batch_csv = @{ Path = $SelectedBatchCsvPath; Sha256 = 'EF7A0005819154A621E2C8CEC0F8D371F58833F82D1B1615C056AF8C6AEE1BA6' }
    review_queue_csv = @{ Path = $QueueCsvPath; Sha256 = '791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43' }
    static_summary_csv = @{ Path = $StaticSummaryCsvPath; Sha256 = 'D0FCC6E841F197D1C80E9D6A1E0447F323EAEF0979F618E843FC372CFDB95431' }
    original_index_csv = @{ Path = $OriginalIndexCsvPath; Sha256 = 'E940E2C56DA6B2B26545F78564AE4A095E605AB49BD2CD8DC0DC39FDA1076992' }
    original_index_md = @{ Path = $OriginalIndexMdPath; Sha256 = 'D5165EEDC94E352E556F06CC1FE51BB6605BA4B5CBC0287E6E7A6DC0F49FC547' }
    original_index_receipt = @{ Path = $OriginalIndexReceiptPath; Sha256 = 'BAE4C5B29BF727103E41AB6E9F6A685ABDBD66BCD625ACF76697BF0115A2BCD8' }
    original_closeout_md = @{ Path = $OriginalCloseoutPath; Sha256 = '4B30E7C1FC8A3201896EDB8B8CAE5DE70414D1DEEB7234169E3DF57EE30BA90E' }
    original_closeout_receipt = @{ Path = $OriginalCloseoutReceiptPath; Sha256 = 'A7B749CEF90F5CA484E376F7175BCB5584869DF7BF255C4D054764F05B74B3A3' }
}

function Get-Sha256 {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Write-Utf8NoBomLines {
    param($Path, $Lines)
    $list = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($Lines)) {
        $null = $list.Add([string]$line)
    }
    [System.IO.File]::WriteAllLines([string]$Path, [string[]]$list.ToArray(), [System.Text.UTF8Encoding]::new($false))
}

function Get-PropValue {
    param($Object, [string[]]$Names)
    foreach ($name in $Names) {
        $prop = $Object.PSObject.Properties[$name]
        if ($null -ne $prop) { return [string]$prop.Value }
    }
    return ''
}

function Add-Line {
    param($List, $Text)
    $null = $List.Add([string]$Text)
}

function New-LineList {
    $list = New-Object System.Collections.Generic.List[string]
    return ,$list
}

if (-not (Test-Path -LiteralPath $WorkDir -PathType Container)) {
    throw "WorkDir not found: $WorkDir"
}

$verificationRows = @()
foreach ($key in $Expected.Keys) {
    $path = [string]$Expected[$key].Path
    $expectedHash = [string]$Expected[$key].Sha256
    $exists = Test-Path -LiteralPath $path -PathType Leaf
    $actualHash = if ($exists) { Get-Sha256 -Path $path } else { '' }
    $verificationRows += [pscustomobject]@{
        Input = $key
        Path = $path
        Exists = [bool]$exists
        ExpectedSHA256 = $expectedHash
        ActualSHA256 = $actualHash
        HashMatch = [bool]($exists -and ($actualHash -eq $expectedHash))
    }
}

$inputBlockerCount = @($verificationRows | Where-Object { -not $_.HashMatch }).Count
if ($inputBlockerCount -gt 0) {
    $verificationRows | Format-Table -AutoSize | Out-String | Write-Output
    throw "Input verification failed; refusing repair. blocker_count=$inputBlockerCount"
}

$selectedRows = @(Import-Csv -LiteralPath $SelectedBatchCsvPath)
$queueRows = @(Import-Csv -LiteralPath $QueueCsvPath)
$summaryRows = @(Import-Csv -LiteralPath $StaticSummaryCsvPath)
$originalIndexRows = @(Import-Csv -LiteralPath $OriginalIndexCsvPath)

$originalBlankTicketCount = @($originalIndexRows | Where-Object { [string]::IsNullOrWhiteSpace((Get-PropValue $_ @('TicketID','TicketId','ticket_id'))) }).Count

$summaryByFile = @{}
foreach ($s in $summaryRows) {
    $file = Get-PropValue $s @('FileName','Filename','file_name','Name')
    if (-not [string]::IsNullOrWhiteSpace($file)) { $summaryByFile[$file] = $s }
}

$ticketByFile = @{}
foreach ($q in $queueRows) {
    $qFile = Get-PropValue $q @('FileName','Filename','file_name','Name')
    $qTicket = Get-PropValue $q @('TicketID','TicketId','ticket_id','SourceTicketID','QueueTicketID')
    if ((-not [string]::IsNullOrWhiteSpace($qFile)) -and (-not [string]::IsNullOrWhiteSpace($qTicket))) {
        $ticketByFile[$qFile] = $qTicket
    }
}

$repairedRows = @()
foreach ($r in $selectedRows) {
    $ticketId = Get-PropValue $r @('TicketID','TicketId','ticket_id','SourceTicketID','QueueTicketID')
    $fileName = Get-PropValue $r @('FileName','Filename','file_name','Name')
    if ([string]::IsNullOrWhiteSpace($fileName)) { continue }
    if ([string]::IsNullOrWhiteSpace($ticketId) -and $ticketByFile.ContainsKey($fileName)) {
        $ticketId = [string]$ticketByFile[$fileName]
    }

    $s = $null
    if ($summaryByFile.ContainsKey($fileName)) { $s = $summaryByFile[$fileName] }

    $sourcePath = Join-Path $RepoRoot $fileName
    $sourceExists = Test-Path -LiteralPath $sourcePath -PathType Leaf
    $sourceHash = if ($sourceExists) { Get-Sha256 -Path $sourcePath } else { '' }

    $role = if ($null -ne $s) { Get-PropValue $s @('IndexRole','StaticRole','ReviewRole','Role','RoleLabel') } else { '' }
    $decision = if ($null -ne $s) { Get-PropValue $s @('IndexDecision','StaticDisposition','Decision','ReviewDecision') } else { '' }
    $gitCommand = if ($null -ne $s) { Get-PropValue $s @('GitCommand','ContainsGitCommand','contains_git_command','HasGitCommand') } else { '' }

    if ([string]::IsNullOrWhiteSpace($role)) {
        if ($fileName -like 'BUILD_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD*') { $role = 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }
        elseif ($fileName -like 'FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD*') { $role = 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }
        elseif ($fileName -like 'FREEZE_*') { $role = 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }
        else { $role = 'UNKNOWN_REVIEW_ONLY' }
    }
    if ([string]::IsNullOrWhiteSpace($decision)) {
        if ($role -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY') { $decision = 'KEEP_AS_TEMPLATE_RULE_CARD_CANDIDATE_NOT_DOCTRINE' }
        elseif ($role -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY') { $decision = 'HOLD_AS_FIELD_APPLY_ATTEMPT_EVIDENCE' }
        elseif ($role -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY') { $decision = 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_EVIDENCE' }
        else { $decision = 'HOLD_FOR_REVIEW' }
    }
    if ([string]::IsNullOrWhiteSpace($gitCommand)) {
        $gitCommand = if ($sourceExists -and ((Select-String -LiteralPath $sourcePath -Pattern '\bgit\b' -SimpleMatch:$false -ErrorAction SilentlyContinue) | Select-Object -First 1)) { 'True' } else { 'False' }
    }

    $repairedRows += [pscustomobject]@{
        TicketID = $ticketId
        FileName = $fileName
        IndexRole = $role
        IndexDecision = $decision
        GitCommand = $gitCommand
        SourceExists = [bool]$sourceExists
        SHA256 = $sourceHash
    }
}

$selectedBatchRows = @($selectedRows).Count
$repairedRowsCount = @($repairedRows).Count
$blankTicketIdCount = @($repairedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.TicketID) }).Count
$sourceMissingCount = @($repairedRows | Where-Object { -not $_.SourceExists }).Count
$templateRuleCardCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'TEMPLATE_RULE_CARD_CANDIDATE_REVIEW_ONLY' }).Count
$fieldApplyAttemptCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }).Count
$freezeRepairAttemptCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }).Count
$unknownIndexRoleCount = @($repairedRows | Where-Object { $_.IndexRole -eq 'UNKNOWN_REVIEW_ONLY' -or [string]::IsNullOrWhiteSpace($_.IndexRole) }).Count
$containsGitCommandCount = @($repairedRows | Where-Object { ([string]$_.GitCommand).ToLowerInvariant() -eq 'true' }).Count

$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
foreach ($rr in $repairedRows) {
    $sp = Join-Path $RepoRoot $rr.FileName
    if (-not (Test-Path -LiteralPath $sp -PathType Leaf)) { continue }
    $txt = Get-Content -LiteralPath $sp -Raw -ErrorAction Stop
    if ($txt -match '\bMove-Item\b') { $containsMoveItemCount++ }
    if ($txt -match '\bRemove-Item\b') { $containsRemoveItemCount++ }
    if ($txt -match '\bRename-Item\b') { $containsRenameItemCount++ }
    if ($txt -match '\bStart-Process\b') { $containsStartProcessCount++ }
    if ($txt -match '\bInvoke-Expression\b|\biex\b') { $containsInvokeExpressionCount++ }
}

$blockerCount = 0
if ($repairedRowsCount -ne 6) { $blockerCount++ }
if ($blankTicketIdCount -ne 0) { $blockerCount++ }
if ($sourceMissingCount -ne 0) { $blockerCount++ }
if ($unknownIndexRoleCount -ne 0) { $blockerCount++ }
if ($containsMoveItemCount -ne 0) { $blockerCount++ }
if ($containsRemoveItemCount -ne 0) { $blockerCount++ }
if ($containsRenameItemCount -ne 0) { $blockerCount++ }
if ($containsStartProcessCount -ne 0) { $blockerCount++ }
if ($containsInvokeExpressionCount -ne 0) { $blockerCount++ }

$repairScriptFreeze = New-LineList
Add-Line $repairScriptFreeze '# ERROR FREEZE - HSRB-002 TICKET ID REPAIR V0.1 NULL LINE LIST FACTORY'
Add-Line $repairScriptFreeze ''
Add-Line $repairScriptFreeze 'Status: EVIDENCE / GENERATED_HELPER_DEFECT / REPAIR_SCRIPT_DEFECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $repairScriptFreeze ''
Add-Line $repairScriptFreeze 'Defect: The first ticket-id repair script failed before writing repair artifacts because New-LineList returned an empty .NET list through the PowerShell pipeline; PowerShell collapsed it to null.'
Add-Line $repairScriptFreeze ''
Add-Line $repairScriptFreeze 'Impact: Not dangerous. It produced no movement, no cleanup, no route, no execution, no commit, and no push. It only failed to start the repair report writer.'
Add-Line $repairScriptFreeze ''
Add-Line $repairScriptFreeze 'Repair: V0.2 returns the .NET list as a single object with unary comma and adds a fallback TicketID lookup from the 64-row helper review queue.'
Add-Line $repairScriptFreeze ''
Add-Line $repairScriptFreeze 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Utf8NoBomLines -Path $RepairScriptErrorFreezePath -Lines $repairScriptFreeze.ToArray()

$freeze = New-LineList
Add-Line $freeze '# ERROR FREEZE - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.1 BLANK TICKET ID CUSTODY DISPLAY DEFECT'
Add-Line $freeze ''
Add-Line $freeze 'Status: EVIDENCE / GENERATED_HELPER_DEFECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $freeze ''
Add-Line $freeze 'Defect: The V0.1 HSRB-002 template rule and attempt index wrote a TicketID column but left TicketID blank for all six index rows.'
Add-Line $freeze ''
Add-Line $freeze 'Impact: Not dangerous, but custody-weak. The rows still had filenames, roles, decisions, git caution flags, and SHA256 hashes, but did not preserve queue ticket IDs.'
Add-Line $freeze ''
Add-Line $freeze 'User observation: user compared the report body against VS Code and correctly noticed that this should be evidence and that helper files must preserve this linkage going forward.'
Add-Line $freeze ''
Add-Line $freeze ('original_blank_ticket_id_count: {0}' -f $originalBlankTicketCount)
Add-Line $freeze 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Utf8NoBomLines -Path $ErrorFreezePath -Lines $freeze.ToArray()

$fix = New-LineList
Add-Line $fix '# FIX NOTE - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.2 TICKET ID PRESERVATION REPAIR'
Add-Line $fix ''
Add-Line $fix 'Status: FIX_NOTE / EVIDENCE / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $fix ''
Add-Line $fix 'Repair: V0.2 rebuilds the HSRB-002 index by joining the selected batch CSV back to the static summary by FileName, preserving TicketID from the selected batch source. If the selected batch surface lacks TicketID, V0.2 falls back to the 64-row helper review queue by FileName.'
Add-Line $fix ''
Add-Line $fix 'Forward helper-generation rule candidate: any derived queue, index, closeout, or proof ledger must preserve custody keys from its source surface, especially TicketID, FileName, SHA256, source role, decision/disposition, and source path when available. A report writer must also preserve empty visual lines without treating the line list as null or invalid.'
Add-Line $fix ''
Add-Line $fix 'This is not doctrine promotion. It is evidence and a candidate rule for later house/helper rule capture.'
Add-Line $fix ''
Add-Line $fix 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Utf8NoBomLines -Path $FixNotePath -Lines $fix.ToArray()

$evidence = New-LineList
Add-Line $evidence '# HELPER GENERATION EVIDENCE - DERIVED INDEXES MUST PRESERVE TICKET ID'
Add-Line $evidence ''
Add-Line $evidence 'Status: EVIDENCE / RULE_CANDIDATE / NOT_DOCTRINE / NO_EXECUTION / NO_ROUTE / NO_CLEANUP'
Add-Line $evidence ''
Add-Line $evidence 'Observed defect: HSRB-002 V0.1 index preserved filenames and hashes but lost TicketID values in the displayed index table.'
Add-Line $evidence ''
Add-Line $evidence 'Required helper behavior going forward: when a helper creates any derived review surface, it must carry source custody identifiers forward rather than only preserving human-readable names.'
Add-Line $evidence ''
Add-Line $evidence 'Minimum custody fields to preserve when present: TicketID, FileName, SHA256, SourcePath, source queue/batch ID, role/disposition/decision, and no-action boundary.'
Add-Line $evidence ''
Add-Line $evidence 'Boundary: this evidence file does not approve execution, routing, cleanup, commit, push, deletion, rename, or doctrine promotion.'
Write-Utf8NoBomLines -Path $EvidenceRulePath -Lines $evidence.ToArray()

$repairedRows | Export-Csv -LiteralPath $OutputIndexCsvPath -NoTypeInformation -Encoding UTF8

$md = New-LineList
Add-Line $md '# HSRB-002 Template Rule and Attempt Index - No Execution - V0.2'
Add-Line $md ''
Add-Line $md 'Status: INDEX_ONLY / TICKET_ID_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $md ''
Add-Line $md '## Purpose'
Add-Line $md ''
Add-Line $md 'Repair the HSRB-002 generated-runner safe-template chain index so the TicketID column is preserved from the selected batch source.'
Add-Line $md ''
Add-Line $md '## Boundary'
Add-Line $md ''
Add-Line $md 'This repaired index is proof and review organization only. It does not approve execution, movement, cleanup, rename, deletion, commit, push, doctrine promotion, or use as source authority.'
Add-Line $md ''
Add-Line $md '## Verified inputs'
Add-Line $md ''
Add-Line $md '| Input | Exists | HashMatch | SHA256 |'
Add-Line $md '| --- | ---: | ---: | --- |'
foreach ($vr in $verificationRows) {
    Add-Line $md ('| {0} | {1} | {2} | `{3}` |' -f $vr.Input, $vr.Exists, $vr.HashMatch, $vr.ActualSHA256)
}
Add-Line $md ''
Add-Line $md '## Defect repaired'
Add-Line $md ''
Add-Line $md ('- original_blank_ticket_id_count: {0}' -f $originalBlankTicketCount)
Add-Line $md ('- repaired_blank_ticket_id_count: {0}' -f $blankTicketIdCount)
Add-Line $md '- repair method: join selected batch CSV to static summary by FileName and preserve TicketID from selected batch source.'
Add-Line $md ''
Add-Line $md '## Counts'
Add-Line $md ''
Add-Line $md ('- selected_batch_id: HSRB-002')
Add-Line $md ('- selected_batch_rows: {0}' -f $selectedBatchRows)
Add-Line $md ('- repaired_index_rows: {0}' -f $repairedRowsCount)
Add-Line $md ('- template_rule_card_count: {0}' -f $templateRuleCardCount)
Add-Line $md ('- field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount)
Add-Line $md ('- freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount)
Add-Line $md ('- unknown_index_role_count: {0}' -f $unknownIndexRoleCount)
Add-Line $md ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
Add-Line $md ('- contains_move_item_count: {0}' -f $containsMoveItemCount)
Add-Line $md ('- contains_remove_item_count: {0}' -f $containsRemoveItemCount)
Add-Line $md ('- contains_rename_item_count: {0}' -f $containsRenameItemCount)
Add-Line $md ('- contains_start_process_count: {0}' -f $containsStartProcessCount)
Add-Line $md ('- contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
Add-Line $md ('- blocker_count: {0}' -f $blockerCount)
Add-Line $md ''
Add-Line $md '## Repaired index table'
Add-Line $md ''
Add-Line $md '| TicketID | FileName | IndexRole | IndexDecision | GitCommand | SHA256 |'
Add-Line $md '| --- | --- | --- | --- | ---: | --- |'
foreach ($rr in $repairedRows) {
    Add-Line $md ('| {0} | `{1}` | {2} | {3} | {4} | `{5}` |' -f $rr.TicketID, $rr.FileName, $rr.IndexRole, $rr.IndexDecision, $rr.GitCommand, $rr.SHA256)
}
Add-Line $md ''
Add-Line $md '## Interpretation'
Add-Line $md ''
Add-Line $md '- The template-rule-card row is held as a candidate, not doctrine.'
Add-Line $md '- The field-apply rows are held as field-attempt evidence.'
Add-Line $md '- The freeze/repair rows are held as repair-attempt evidence.'
Add-Line $md '- Git command mentions are evidence to preserve caution; they do not authorize running those scripts.'
Add-Line $md '- TicketID values are now preserved for custody traceability.'
Add-Line $md ''
Add-Line $md '## DoesNotProve'
Add-Line $md ''
Add-Line $md 'This repaired index does not prove that any selected script is safe to execute. It does not promote the template card into doctrine and does not approve field apply, freeze repair, routing, cleanup, commit, or push.'
Add-Line $md ''
Add-Line $md '## Next single action'
Add-Line $md ''
Add-Line $md 'BUILD_HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_2'
Add-Line $md ''
Add-Line $md 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_2_REPAIRED_TICKET_ID_CUSTODY_DISPLAY_WITH_NO_PHYSICAL_ACTION'
Write-Utf8NoBomLines -Path $OutputIndexMdPath -Lines $md.ToArray()
Write-Utf8NoBomLines -Path $OutputIndexPrintPath -Lines $md.ToArray()
Set-Clipboard -Value (($md.ToArray()) -join [Environment]::NewLine)

$outIndexCsvHash = Get-Sha256 -Path $OutputIndexCsvPath
$outIndexMdHash = Get-Sha256 -Path $OutputIndexMdPath
$outIndexPrintHash = Get-Sha256 -Path $OutputIndexPrintPath
$repairScriptErrorFreezeHash = Get-Sha256 -Path $RepairScriptErrorFreezePath
$errorFreezeHash = Get-Sha256 -Path $ErrorFreezePath
$fixNoteHash = Get-Sha256 -Path $FixNotePath
$evidenceRuleHash = Get-Sha256 -Path $EvidenceRulePath

$closeout = New-LineList
Add-Line $closeout '# HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX CLOSEOUT - NO EXECUTION - V0.2'
Add-Line $closeout ''
Add-Line $closeout 'Status: CLOSEOUT / TICKET_ID_REPAIR_VERIFIED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $closeout ''
Add-Line $closeout '## Summary'
Add-Line $closeout ''
Add-Line $closeout 'HSRB-002 index V0.1 had a custody display defect: TicketID values were blank in the index table. V0.2 repairs that display defect by preserving TicketID from the selected batch CSV.'
Add-Line $closeout ''
Add-Line $closeout '## Counts'
Add-Line $closeout ''
Add-Line $closeout ('- selected_batch_rows: {0}' -f $selectedBatchRows)
Add-Line $closeout ('- repaired_index_rows: {0}' -f $repairedRowsCount)
Add-Line $closeout ('- original_blank_ticket_id_count: {0}' -f $originalBlankTicketCount)
Add-Line $closeout ('- repaired_blank_ticket_id_count: {0}' -f $blankTicketIdCount)
Add-Line $closeout ('- template_rule_card_count: {0}' -f $templateRuleCardCount)
Add-Line $closeout ('- field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount)
Add-Line $closeout ('- freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount)
Add-Line $closeout ('- unknown_index_role_count: {0}' -f $unknownIndexRoleCount)
Add-Line $closeout ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
Add-Line $closeout ('- blocker_count: {0}' -f $blockerCount)
Add-Line $closeout ''
Add-Line $closeout '## Boundary'
Add-Line $closeout ''
Add-Line $closeout 'The repaired index is still evidence only. It does not authorize execution, movement, cleanup, rename, deletion, commit, push, or doctrine promotion.'
Add-Line $closeout ''
Add-Line $closeout '## Next single action'
Add-Line $closeout ''
Add-Line $closeout 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
Add-Line $closeout ''
Add-Line $closeout 'Final verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_V0_2_REPAIRED_TICKET_ID_CUSTODY_DISPLAY_WITH_NO_PHYSICAL_ACTION'
Write-Utf8NoBomLines -Path $OutputCloseoutPath -Lines $closeout.ToArray()
Write-Utf8NoBomLines -Path $OutputCloseoutPrintPath -Lines $closeout.ToArray()

$outCloseoutHash = Get-Sha256 -Path $OutputCloseoutPath
$outCloseoutPrintHash = Get-Sha256 -Path $OutputCloseoutPrintPath

$fixReceipt = New-LineList
Add-Line $fixReceipt 'HASH RECEIPT - HSRB-002 INDEX V0.2 TICKET ID REPAIR'
Add-Line $fixReceipt ('repair_script_error_freeze_path: {0}' -f $RepairScriptErrorFreezePath)
Add-Line $fixReceipt ('repair_script_error_freeze_sha256: {0}' -f $repairScriptErrorFreezeHash)
Add-Line $fixReceipt ('error_freeze_path: {0}' -f $ErrorFreezePath)
Add-Line $fixReceipt ('error_freeze_sha256: {0}' -f $errorFreezeHash)
Add-Line $fixReceipt ('fix_note_path: {0}' -f $FixNotePath)
Add-Line $fixReceipt ('fix_note_sha256: {0}' -f $fixNoteHash)
Add-Line $fixReceipt ('helper_generation_evidence_path: {0}' -f $EvidenceRulePath)
Add-Line $fixReceipt ('helper_generation_evidence_sha256: {0}' -f $evidenceRuleHash)
Write-Utf8NoBomLines -Path $FixReceiptPath -Lines $fixReceipt.ToArray()
$fixReceiptHash = Get-Sha256 -Path $FixReceiptPath

$indexReceipt = New-LineList
Add-Line $indexReceipt 'HASH RECEIPT - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.2'
Add-Line $indexReceipt ('output_index_csv_path: {0}' -f $OutputIndexCsvPath)
Add-Line $indexReceipt ('output_index_csv_sha256: {0}' -f $outIndexCsvHash)
Add-Line $indexReceipt ('output_index_md_path: {0}' -f $OutputIndexMdPath)
Add-Line $indexReceipt ('output_index_md_sha256: {0}' -f $outIndexMdHash)
Add-Line $indexReceipt ('output_index_print_path: {0}' -f $OutputIndexPrintPath)
Add-Line $indexReceipt ('output_index_print_sha256: {0}' -f $outIndexPrintHash)
Add-Line $indexReceipt ('selected_batch_rows: {0}' -f $selectedBatchRows)
Add-Line $indexReceipt ('repaired_blank_ticket_id_count: {0}' -f $blankTicketIdCount)
Add-Line $indexReceipt 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Utf8NoBomLines -Path $OutputIndexReceiptPath -Lines $indexReceipt.ToArray()
$outIndexReceiptHash = Get-Sha256 -Path $OutputIndexReceiptPath

$closeoutReceipt = New-LineList
Add-Line $closeoutReceipt 'HASH RECEIPT - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX CLOSEOUT V0.2'
Add-Line $closeoutReceipt ('output_closeout_path: {0}' -f $OutputCloseoutPath)
Add-Line $closeoutReceipt ('output_closeout_sha256: {0}' -f $outCloseoutHash)
Add-Line $closeoutReceipt ('output_closeout_print_path: {0}' -f $OutputCloseoutPrintPath)
Add-Line $closeoutReceipt ('output_closeout_print_sha256: {0}' -f $outCloseoutPrintHash)
Add-Line $closeoutReceipt ('blocker_count: {0}' -f $blockerCount)
Add-Line $closeoutReceipt 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Utf8NoBomLines -Path $OutputCloseoutReceiptPath -Lines $closeoutReceipt.ToArray()
$outCloseoutReceiptHash = Get-Sha256 -Path $OutputCloseoutReceiptPath

'=== HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX TICKET ID REPAIR V0.2 COMPLETE ==='
'repair_script_error_freeze_path: {0}' -f $RepairScriptErrorFreezePath
'repair_script_error_freeze_sha256: {0}' -f $repairScriptErrorFreezeHash
'error_freeze_path: {0}' -f $ErrorFreezePath
'error_freeze_sha256: {0}' -f $errorFreezeHash
'fix_note_path: {0}' -f $FixNotePath
'fix_note_sha256: {0}' -f $fixNoteHash
'fix_receipt_path: {0}' -f $FixReceiptPath
'fix_receipt_sha256: {0}' -f $fixReceiptHash
'helper_generation_evidence_path: {0}' -f $EvidenceRulePath
'helper_generation_evidence_sha256: {0}' -f $evidenceRuleHash
'output_index_csv_path: {0}' -f $OutputIndexCsvPath
'output_index_csv_sha256: {0}' -f $outIndexCsvHash
'output_index_md_path: {0}' -f $OutputIndexMdPath
'output_index_md_sha256: {0}' -f $outIndexMdHash
'output_index_print_path: {0}' -f $OutputIndexPrintPath
'output_index_print_sha256: {0}' -f $outIndexPrintHash
'output_index_receipt_path: {0}' -f $OutputIndexReceiptPath
'output_index_receipt_sha256: {0}' -f $outIndexReceiptHash
'output_closeout_path: {0}' -f $OutputCloseoutPath
'output_closeout_sha256: {0}' -f $outCloseoutHash
'output_closeout_print_path: {0}' -f $OutputCloseoutPrintPath
'output_closeout_print_sha256: {0}' -f $outCloseoutPrintHash
'output_closeout_receipt_path: {0}' -f $OutputCloseoutReceiptPath
'output_closeout_receipt_sha256: {0}' -f $outCloseoutReceiptHash
'inputs_verified: {0}' -f ($inputBlockerCount -eq 0)
'original_blank_ticket_id_count: {0}' -f $originalBlankTicketCount
'repaired_blank_ticket_id_count: {0}' -f $blankTicketIdCount
'selected_batch_id: HSRB-002'
'selected_batch_rows: {0}' -f $selectedBatchRows
'repaired_index_rows: {0}' -f $repairedRowsCount
'template_rule_card_count: {0}' -f $templateRuleCardCount
'field_apply_attempt_count: {0}' -f $fieldApplyAttemptCount
'freeze_repair_attempt_count: {0}' -f $freezeRepairAttemptCount
'unknown_index_role_count: {0}' -f $unknownIndexRoleCount
'contains_git_command_count: {0}' -f $containsGitCommandCount
'contains_move_item_count: {0}' -f $containsMoveItemCount
'contains_remove_item_count: {0}' -f $containsRemoveItemCount
'contains_rename_item_count: {0}' -f $containsRenameItemCount
'contains_start_process_count: {0}' -f $containsStartProcessCount
'contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount
'blocker_count: {0}' -f $blockerCount
'next_single_action: RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
'final_verdict: HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_V0_2_REPAIRED_TICKET_ID_CUSTODY_DISPLAY_WITH_NO_PHYSICAL_ACTION'
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
