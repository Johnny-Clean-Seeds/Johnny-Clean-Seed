$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$LaneDir = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$MarkedCsvPath = Join-Path $LaneDir 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_V0_1_20260609.csv'
$MarkedMdPath = Join-Path $LaneDir 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_V0_1_20260609.md'
$MarkedReceiptPath = Join-Path $LaneDir 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_RECEIPT_V0_1_20260609.txt'
$DecisionCloseoutPath = Join-Path $LaneDir 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_V0_1_20260609.md'
$DecisionCloseoutReceiptPath = Join-Path $LaneDir 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_RECEIPT_V0_1_20260609.txt'

$ExpectedMarkedCsvSha = 'DB41FAF1985E4FA729934CB8258F9084FCC725A476ABB9072FAAC58662A75A5D'
$ExpectedMarkedMdSha = 'DD0A2E7951D6783BC2BC823EE51BFE49657A790C2EE5D4C4B0155546416EDB5F'
$ExpectedMarkedReceiptSha = '595214E86DE6929792ACAB6739DA4C8AAF309C4B996BD775B5516AA0101DE665'
$ExpectedDecisionCloseoutSha = '5151964CA547748825386CF881153CF5FA71B73BD35260FA1D8F8A4B4B81C38F'
$ExpectedDecisionCloseoutReceiptSha = 'C9367818C378F6EE90D33416A835E7C6AD0598F6706AEA1CD305007AE132325B'

$ErrorFreezePath = Join-Path $LaneDir 'ERROR_FREEZE__HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_1_ARGUMENT_TYPES_MISMATCH_20260609.md'
$FixNotePath = Join-Path $LaneDir 'FIX_NOTE__HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_COUNT_AND_STRING_CAST_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $LaneDir 'HASH_RECEIPT__HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_FIX_20260609.txt'

$QueueCsvPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$QueueMdPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.md'
$QueueReceiptPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_RECEIPT_V0_2_20260609.txt'
$QueuePrintPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_COPY_PRINT_V0_2_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Add-Line {
    param(
        [System.Collections.Generic.List[string]] $List,
        [AllowNull()] $Text
    )
    [void]$List.Add([string]$Text)
}

function Count-Array {
    param([AllowNull()] $Value)
    return [int](@($Value).Count)
}

function Write-Utf8Lines {
    param(
        [string] $Path,
        [string[]] $Lines
    )
    $Lines | Set-Content -LiteralPath $Path -Encoding UTF8
}

$blockers = New-Object System.Collections.Generic.List[string]

$errorFreeze = New-Object System.Collections.Generic.List[string]
Add-Line $errorFreeze '# Error Freeze - Helper Script Review Queue V0.1 Argument Types Mismatch'
Add-Line $errorFreeze ''
Add-Line $errorFreeze 'Status: FROZEN_DEFECT / SAME_OBJECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP'
Add-Line $errorFreeze ''
Add-Line $errorFreeze 'Observed failure:'
Add-Line $errorFreeze ''
Add-Line $errorFreeze '```text'
Add-Line $errorFreeze 'OperationStopped: BUILD_HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_NO_EXECUTION_20260609_V0_1.ps1:169'
Add-Line $errorFreeze 'Line 169: $print.Add((''Queue row count: {0}'' -f @($queueRows).Count))'
Add-Line $errorFreeze 'Argument types do not match'
Add-Line $errorFreeze '```'
Add-Line $errorFreeze ''
Add-Line $errorFreeze 'Failure family: LIST_ADD_COUNT_FORMAT_TYPE_BINDING_DEFECT.'
Add-Line $errorFreeze ''
Add-Line $errorFreeze 'Plain meaning: the V0.1 queue builder reached the print stage and failed while adding a formatted count line to a typed string list. This is a generated-script defect, not a data decision failure and not a user error.'
Add-Line $errorFreeze ''
Add-Line $errorFreeze 'Containment: repair only the helper-script review queue builder. Do not change the route board, marked decisions, decision closeout, or any physical file state.'
Write-Utf8Lines -Path $ErrorFreezePath -Lines $errorFreeze.ToArray()
$ErrorFreezeSha = (Get-FileHash -LiteralPath $ErrorFreezePath -Algorithm SHA256).Hash

$fixNote = New-Object System.Collections.Generic.List[string]
Add-Line $fixNote '# Fix Note - Helper Script Review Queue V0.2 Count And String Cast Repair'
Add-Line $fixNote ''
Add-Line $fixNote 'Status: FIX_NOTE / SAME_OBJECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP'
Add-Line $fixNote ''
Add-Line $fixNote 'V0.2 repairs the V0.1 typed-list print failure by using explicit string insertion and precomputed integer counts.'
Add-Line $fixNote ''
Add-Line $fixNote 'V0.2 does not execute helper scripts. It does not move, delete, rename, route, commit, push, or clean up anything.'
Add-Line $fixNote ''
Add-Line $fixNote 'Output versioning is advanced to V0.2 so the failed V0.1 partial outputs are not treated as the current completed queue.'
Write-Utf8Lines -Path $FixNotePath -Lines $fixNote.ToArray()
$FixNoteSha = (Get-FileHash -LiteralPath $FixNotePath -Algorithm SHA256).Hash

$checks = @(
    @{ Path = $MarkedCsvPath; Expected = $ExpectedMarkedCsvSha; Name = 'marked_csv' },
    @{ Path = $MarkedMdPath; Expected = $ExpectedMarkedMdSha; Name = 'marked_md' },
    @{ Path = $MarkedReceiptPath; Expected = $ExpectedMarkedReceiptSha; Name = 'marked_receipt' },
    @{ Path = $DecisionCloseoutPath; Expected = $ExpectedDecisionCloseoutSha; Name = 'decision_closeout' },
    @{ Path = $DecisionCloseoutReceiptPath; Expected = $ExpectedDecisionCloseoutReceiptSha; Name = 'decision_closeout_receipt' }
)

$checkResults = New-Object System.Collections.Generic.List[object]
foreach ($c in $checks) {
    $exists = Test-Path -LiteralPath $c.Path
    $actual = ''
    $match = $false
    if ($exists) {
        $actual = (Get-FileHash -LiteralPath $c.Path -Algorithm SHA256).Hash
        $match = ($actual -eq $c.Expected)
    }
    if (-not $exists) {
        [void]$blockers.Add(('MISSING_{0}: {1}' -f $c.Name, $c.Path))
    } elseif (-not $match) {
        [void]$blockers.Add(('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $c.Name, $c.Expected, $actual))
    }
    [void]$checkResults.Add([pscustomobject]@{
        Name = [string]$c.Name
        Path = [string]$c.Path
        Exists = [bool]$exists
        ExpectedSha256 = [string]$c.Expected
        ActualSha256 = [string]$actual
        HashMatch = [bool]$match
    })
}

$rows = @()
if ((Test-Path -LiteralPath $MarkedCsvPath) -and ($blockers.Count -eq 0)) {
    $rows = @(Import-Csv -LiteralPath $MarkedCsvPath)
}

$totalRows = Count-Array $rows
$reviewRows = @($rows | Where-Object { $_.UserDecision -eq 'REVIEW' })
$holdRows = @($rows | Where-Object { $_.UserDecision -eq 'HOLD' })
$blockRows = @($rows | Where-Object { $_.UserDecision -eq 'BLOCK' })
$laterRows = @($rows | Where-Object { $_.UserDecision -eq 'LATER_APPROVED_ROW_CANDIDATE' })
$blankRows = @($rows | Where-Object { [string]::IsNullOrWhiteSpace($_.UserDecision) })
$invalidRows = @($rows | Where-Object { @('HOLD','REVIEW','BLOCK','LATER_APPROVED_ROW_CANDIDATE') -notcontains $_.UserDecision })

$reviewCount = Count-Array $reviewRows
$holdCount = Count-Array $holdRows
$blockCount = Count-Array $blockRows
$laterCount = Count-Array $laterRows
$blankCount = Count-Array $blankRows
$invalidCount = Count-Array $invalidRows

if (($blockers.Count -eq 0) -and ($totalRows -ne 69)) { [void]$blockers.Add(('UNEXPECTED_TOTAL_ROWS: {0}' -f $totalRows)) }
if (($blockers.Count -eq 0) -and ($reviewCount -ne 64)) { [void]$blockers.Add(('UNEXPECTED_REVIEW_ROWS: {0}' -f $reviewCount)) }
if (($blockers.Count -eq 0) -and ($holdCount -ne 5)) { [void]$blockers.Add(('UNEXPECTED_HOLD_ROWS: {0}' -f $holdCount)) }
if (($blockers.Count -eq 0) -and ($blockCount -ne 0)) { [void]$blockers.Add(('UNEXPECTED_BLOCK_ROWS: {0}' -f $blockCount)) }
if (($blockers.Count -eq 0) -and ($laterCount -ne 0)) { [void]$blockers.Add(('UNEXPECTED_LATER_APPROVED_ROW_CANDIDATE_ROWS: {0}' -f $laterCount)) }
if (($blockers.Count -eq 0) -and ($blankCount -ne 0)) { [void]$blockers.Add(('BLANK_USER_DECISION_ROWS: {0}' -f $blankCount)) }
if (($blockers.Count -eq 0) -and ($invalidCount -ne 0)) { [void]$blockers.Add(('INVALID_USER_DECISION_ROWS: {0}' -f $invalidCount)) }

$queueRows = @()
if ($blockers.Count -eq 0) {
    $i = 1
    foreach ($r in $reviewRows) {
        $ext = [System.IO.Path]::GetExtension([string]$r.FileName)
        $queueClass = 'HELPER_SCRIPT_REVIEW_REQUIRED'
        if ($ext -ne '.ps1') { $queueClass = 'NON_PS1_REVIEW_REQUIRED' }
        $queueRows += [pscustomobject]@{
            QueueID = ('HSRQ-{0:D3}' -f $i)
            SourceTicketID = [string]$r.TicketID
            FileName = [string]$r.FileName
            RoleLabel = [string]$r.RoleLabel
            RiskLabel = [string]$r.RiskLabel
            UserDecision = [string]$r.UserDecision
            QueueClass = [string]$queueClass
            ReviewInstruction = 'REVIEW_SCRIPT_SHAPE_AND_CUSTODY_ONLY_NO_EXECUTION'
            ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
            UserNote = [string]$r.UserNote
        }
        $i++
    }
}

$queueRowCount = Count-Array $queueRows

if ($blockers.Count -eq 0) {
    $queueRows | Export-Csv -LiteralPath $QueueCsvPath -NoTypeInformation -Encoding UTF8
}

$md = New-Object System.Collections.Generic.List[string]
Add-Line $md '# Helper Script Review Queue From Root Held Route Dry-Run V0.5 Decisions V0.2'
Add-Line $md ''
Add-Line $md 'Status: HELPER_SCRIPT_REVIEW_QUEUE / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP'
Add-Line $md ''
Add-Line $md '## Purpose'
Add-Line $md ''
Add-Line $md 'Build the next review-only queue from the 64 rows marked REVIEW in the V0.5 user-marked decision copy.'
Add-Line $md ''
Add-Line $md 'This queue does not execute helper scripts. It does not move, delete, rename, route, commit, push, or clean up anything.'
Add-Line $md ''
Add-Line $md '## V0.1 failure containment'
Add-Line $md ''
Add-Line $md ('- error_freeze_path: `{0}`' -f $ErrorFreezePath)
Add-Line $md ('- error_freeze_sha256: `{0}`' -f $ErrorFreezeSha)
Add-Line $md ('- fix_note_path: `{0}`' -f $FixNotePath)
Add-Line $md ('- fix_note_sha256: `{0}`' -f $FixNoteSha)
Add-Line $md ''
Add-Line $md '## Verified inputs'
Add-Line $md ''
Add-Line $md '| Input | Exists | HashMatch | SHA256 |'
Add-Line $md '| --- | ---: | ---: | --- |'
foreach ($cr in $checkResults) {
    Add-Line $md ('| {0} | {1} | {2} | `{3}` |' -f $cr.Name, $cr.Exists, $cr.HashMatch, $cr.ActualSha256)
}
Add-Line $md ''
Add-Line $md '## Decision counts'
Add-Line $md ''
Add-Line $md ('- total_rows: {0}' -f $totalRows)
Add-Line $md ('- decision_hold_count: {0}' -f $holdCount)
Add-Line $md ('- decision_review_count: {0}' -f $reviewCount)
Add-Line $md ('- decision_block_count: {0}' -f $blockCount)
Add-Line $md ('- decision_later_approved_row_candidate_count: {0}' -f $laterCount)
Add-Line $md ('- blank_user_decision_count: {0}' -f $blankCount)
Add-Line $md ('- invalid_user_decision_count: {0}' -f $invalidCount)
Add-Line $md ('- queue_review_rows: {0}' -f $queueRowCount)
Add-Line $md ''
Add-Line $md '## Queue rows'
Add-Line $md ''
if ($blockers.Count -eq 0) {
    Add-Line $md '| QueueID | SourceTicketID | FileName | QueueClass | RiskLabel | ActionNow |'
    Add-Line $md '| --- | --- | --- | --- | --- | --- |'
    foreach ($q in $queueRows) {
        $safeName = ([string]$q.FileName).Replace('|','/')
        Add-Line $md ('| {0} | {1} | `{2}` | {3} | {4} | {5} |' -f $q.QueueID, $q.SourceTicketID, $safeName, $q.QueueClass, $q.RiskLabel, $q.ActionNow)
    }
} else {
    Add-Line $md 'Queue rows were not produced because blockers were found.'
}
Add-Line $md ''
Add-Line $md '## Blockers'
Add-Line $md ''
if ($blockers.Count -eq 0) {
    Add-Line $md 'None.'
} else {
    foreach ($b in $blockers) { Add-Line $md ('- {0}' -f $b) }
}
Add-Line $md ''
Add-Line $md '## DoesNotProve'
Add-Line $md ''
Add-Line $md 'This queue proves only that the 64 REVIEW rows were copied into a helper-script review queue. It does not prove any script is safe, current, executable, useful, route-approved, cleanup-approved, or ready for Git push.'
Add-Line $md ''
Add-Line $md '## Next single action'
Add-Line $md ''
if ($blockers.Count -eq 0) {
    Add-Line $md 'BUILD_HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION'
    Add-Line $md ''
    Add-Line $md 'Final verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    Add-Line $md 'REPAIR_HELPER_SCRIPT_REVIEW_QUEUE_INPUT_BLOCKERS_NO_EXECUTION'
    Add-Line $md ''
    Add-Line $md 'Final verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-Utf8Lines -Path $QueueMdPath -Lines $md.ToArray()

$print = New-Object System.Collections.Generic.List[string]
Add-Line $print 'HELPER SCRIPT REVIEW QUEUE - COPY PRINT V0.2'
Add-Line $print 'Review only. No execution. No route. No cleanup.'
Add-Line $print ('Queue row count: {0}' -f $queueRowCount)
Add-Line $print ''
foreach ($q in $queueRows) {
    Add-Line $print ('{0} | {1} | {2} | {3}' -f $q.QueueID, $q.SourceTicketID, $q.FileName, $q.ReviewInstruction)
}
Write-Utf8Lines -Path $QueuePrintPath -Lines $print.ToArray()
if ($blockers.Count -eq 0) {
    Set-Clipboard -Value (($print.ToArray()) -join [Environment]::NewLine)
}

$QueueCsvSha = ''
if (Test-Path -LiteralPath $QueueCsvPath) { $QueueCsvSha = (Get-FileHash -LiteralPath $QueueCsvPath -Algorithm SHA256).Hash }
$QueueMdSha = (Get-FileHash -LiteralPath $QueueMdPath -Algorithm SHA256).Hash
$QueuePrintSha = (Get-FileHash -LiteralPath $QueuePrintPath -Algorithm SHA256).Hash

$fixReceipt = New-Object System.Collections.Generic.List[string]
Add-Line $fixReceipt 'HASH_RECEIPT__HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_FIX_20260609'
Add-Line $fixReceipt ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
Add-Line $fixReceipt ('error_freeze_path: {0}' -f $ErrorFreezePath)
Add-Line $fixReceipt ('error_freeze_sha256: {0}' -f $ErrorFreezeSha)
Add-Line $fixReceipt ('fix_note_path: {0}' -f $FixNotePath)
Add-Line $fixReceipt ('fix_note_sha256: {0}' -f $FixNoteSha)
Add-Line $fixReceipt 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Utf8Lines -Path $FixReceiptPath -Lines $fixReceipt.ToArray()
$FixReceiptSha = (Get-FileHash -LiteralPath $FixReceiptPath -Algorithm SHA256).Hash

$receipt = New-Object System.Collections.Generic.List[string]
Add-Line $receipt 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_RECEIPT_V0_2_20260609'
Add-Line $receipt ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
Add-Line $receipt ('marked_csv_path: {0}' -f $MarkedCsvPath)
Add-Line $receipt ('marked_csv_sha256: {0}' -f $ExpectedMarkedCsvSha)
Add-Line $receipt ('decision_closeout_path: {0}' -f $DecisionCloseoutPath)
Add-Line $receipt ('decision_closeout_sha256: {0}' -f $ExpectedDecisionCloseoutSha)
Add-Line $receipt ('error_freeze_path: {0}' -f $ErrorFreezePath)
Add-Line $receipt ('error_freeze_sha256: {0}' -f $ErrorFreezeSha)
Add-Line $receipt ('fix_note_path: {0}' -f $FixNotePath)
Add-Line $receipt ('fix_note_sha256: {0}' -f $FixNoteSha)
Add-Line $receipt ('fix_receipt_path: {0}' -f $FixReceiptPath)
Add-Line $receipt ('fix_receipt_sha256: {0}' -f $FixReceiptSha)
Add-Line $receipt ('output_queue_csv_path: {0}' -f $QueueCsvPath)
Add-Line $receipt ('output_queue_csv_sha256: {0}' -f $QueueCsvSha)
Add-Line $receipt ('output_queue_md_path: {0}' -f $QueueMdPath)
Add-Line $receipt ('output_queue_md_sha256: {0}' -f $QueueMdSha)
Add-Line $receipt ('output_queue_print_path: {0}' -f $QueuePrintPath)
Add-Line $receipt ('output_queue_print_sha256: {0}' -f $QueuePrintSha)
Add-Line $receipt ('total_rows: {0}' -f $totalRows)
Add-Line $receipt ('queue_review_rows: {0}' -f $queueRowCount)
Add-Line $receipt ('blocker_count: {0}' -f $blockers.Count)
Add-Line $receipt ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
if ($blockers.Count -eq 0) {
    Add-Line $receipt 'final_verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    Add-Line $receipt 'final_verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-Utf8Lines -Path $QueueReceiptPath -Lines $receipt.ToArray()
$QueueReceiptSha = (Get-FileHash -LiteralPath $QueueReceiptPath -Algorithm SHA256).Hash

'=== HELPER SCRIPT REVIEW QUEUE FROM 64 REVIEW ROWS V0.2 COMPLETE ==='
('error_freeze_path: {0}' -f $ErrorFreezePath)
('error_freeze_sha256: {0}' -f $ErrorFreezeSha)
('fix_note_path: {0}' -f $FixNotePath)
('fix_note_sha256: {0}' -f $FixNoteSha)
('fix_receipt_path: {0}' -f $FixReceiptPath)
('fix_receipt_sha256: {0}' -f $FixReceiptSha)
('output_queue_csv_path: {0}' -f $QueueCsvPath)
('output_queue_csv_sha256: {0}' -f $QueueCsvSha)
('output_queue_md_path: {0}' -f $QueueMdPath)
('output_queue_md_sha256: {0}' -f $QueueMdSha)
('output_queue_print_path: {0}' -f $QueuePrintPath)
('output_queue_print_sha256: {0}' -f $QueuePrintSha)
('output_receipt_path: {0}' -f $QueueReceiptPath)
('output_receipt_sha256: {0}' -f $QueueReceiptSha)
('marked_csv_verified: {0}' -f (($checkResults | Where-Object { $_.Name -eq 'marked_csv' }).HashMatch))
('decision_closeout_verified: {0}' -f (($checkResults | Where-Object { $_.Name -eq 'decision_closeout' }).HashMatch))
('total_rows: {0}' -f $totalRows)
('queue_review_rows: {0}' -f $queueRowCount)
('decision_hold_count: {0}' -f $holdCount)
('decision_review_count: {0}' -f $reviewCount)
('decision_block_count: {0}' -f $blockCount)
('decision_later_approved_row_candidate_count: {0}' -f $laterCount)
('blocker_count: {0}' -f $blockers.Count)
if ($blockers.Count -eq 0) { 'next_single_action: BUILD_HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION' } else { 'next_single_action: REPAIR_HELPER_SCRIPT_REVIEW_QUEUE_INPUT_BLOCKERS_NO_EXECUTION' }
if ($blockers.Count -eq 0) { 'final_verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
