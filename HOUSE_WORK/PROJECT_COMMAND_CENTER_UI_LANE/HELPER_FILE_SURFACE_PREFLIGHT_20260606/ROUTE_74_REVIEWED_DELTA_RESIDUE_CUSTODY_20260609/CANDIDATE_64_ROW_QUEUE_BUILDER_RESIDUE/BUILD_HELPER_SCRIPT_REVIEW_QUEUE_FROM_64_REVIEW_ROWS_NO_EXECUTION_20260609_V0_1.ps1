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

$QueueCsvPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_1_20260609.csv'
$QueueMdPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_1_20260609.md'
$QueueReceiptPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_RECEIPT_V0_1_20260609.txt'
$QueuePrintPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_COPY_PRINT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

$blockers = New-Object System.Collections.Generic.List[string]

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
    if (-not $exists) { $blockers.Add(('MISSING_{0}: {1}' -f $c.Name, $c.Path)) }
    elseif (-not $match) { $blockers.Add(('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $c.Name, $c.Expected, $actual)) }
    $checkResults.Add([pscustomobject]@{
        Name = $c.Name
        Path = $c.Path
        Exists = $exists
        ExpectedSha256 = $c.Expected
        ActualSha256 = $actual
        HashMatch = $match
    })
}

$rows = @()
if ((Test-Path -LiteralPath $MarkedCsvPath) -and ($blockers.Count -eq 0)) {
    $rows = @(Import-Csv -LiteralPath $MarkedCsvPath)
}

$totalRows = @($rows).Count
$reviewRows = @($rows | Where-Object { $_.UserDecision -eq 'REVIEW' })
$holdRows = @($rows | Where-Object { $_.UserDecision -eq 'HOLD' })
$blockRows = @($rows | Where-Object { $_.UserDecision -eq 'BLOCK' })
$laterRows = @($rows | Where-Object { $_.UserDecision -eq 'LATER_APPROVED_ROW_CANDIDATE' })
$blankRows = @($rows | Where-Object { [string]::IsNullOrWhiteSpace($_.UserDecision) })
$invalidRows = @($rows | Where-Object { @('HOLD','REVIEW','BLOCK','LATER_APPROVED_ROW_CANDIDATE') -notcontains $_.UserDecision })

if (($blockers.Count -eq 0) -and ($totalRows -ne 69)) { $blockers.Add(('UNEXPECTED_TOTAL_ROWS: {0}' -f $totalRows)) }
if (($blockers.Count -eq 0) -and (@($reviewRows).Count -ne 64)) { $blockers.Add(('UNEXPECTED_REVIEW_ROWS: {0}' -f @($reviewRows).Count)) }
if (($blockers.Count -eq 0) -and (@($holdRows).Count -ne 5)) { $blockers.Add(('UNEXPECTED_HOLD_ROWS: {0}' -f @($holdRows).Count)) }
if (($blockers.Count -eq 0) -and (@($blockRows).Count -ne 0)) { $blockers.Add(('UNEXPECTED_BLOCK_ROWS: {0}' -f @($blockRows).Count)) }
if (($blockers.Count -eq 0) -and (@($laterRows).Count -ne 0)) { $blockers.Add(('UNEXPECTED_LATER_APPROVED_ROW_CANDIDATE_ROWS: {0}' -f @($laterRows).Count)) }
if (($blockers.Count -eq 0) -and (@($blankRows).Count -ne 0)) { $blockers.Add(('BLANK_USER_DECISION_ROWS: {0}' -f @($blankRows).Count)) }
if (($blockers.Count -eq 0) -and (@($invalidRows).Count -ne 0)) { $blockers.Add(('INVALID_USER_DECISION_ROWS: {0}' -f @($invalidRows).Count)) }

$queueRows = New-Object System.Collections.Generic.List[object]
if ($blockers.Count -eq 0) {
    foreach ($r in $reviewRows) {
        $ext = [System.IO.Path]::GetExtension([string]$r.FileName)
        $queueClass = 'HELPER_SCRIPT_REVIEW_REQUIRED'
        if ($ext -ne '.ps1') { $queueClass = 'NON_PS1_REVIEW_REQUIRED' }
        $queueRows.Add([pscustomobject]@{
            QueueID = ('HSRQ-{0:D3}' -f $queueRows.Count)
            SourceTicketID = $r.TicketID
            FileName = $r.FileName
            RoleLabel = $r.RoleLabel
            RiskLabel = $r.RiskLabel
            UserDecision = $r.UserDecision
            QueueClass = $queueClass
            ReviewInstruction = 'REVIEW_SCRIPT_SHAPE_AND_CUSTODY_ONLY_NO_EXECUTION'
            ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
            UserNote = $r.UserNote
        })
    }
}

if ($blockers.Count -eq 0) {
    $queueRows | Export-Csv -LiteralPath $QueueCsvPath -NoTypeInformation -Encoding UTF8
}

$md = New-Object System.Collections.Generic.List[string]
$md.Add('# Helper Script Review Queue From Root Held Route Dry-Run V0.5 Decisions V0.1')
$md.Add('')
$md.Add('Status: HELPER_SCRIPT_REVIEW_QUEUE / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP')
$md.Add('')
$md.Add('## Purpose')
$md.Add('')
$md.Add('Build the next review-only queue from the 64 rows marked REVIEW in the V0.5 user-marked decision copy.')
$md.Add('')
$md.Add('This queue does not execute helper scripts. It does not move, delete, rename, route, commit, push, or clean up anything.')
$md.Add('')
$md.Add('## Verified inputs')
$md.Add('')
$md.Add('| Input | Exists | HashMatch | SHA256 |')
$md.Add('| --- | ---: | ---: | --- |')
foreach ($cr in $checkResults) {
    $md.Add(('| {0} | {1} | {2} | `{3}` |' -f $cr.Name, $cr.Exists, $cr.HashMatch, $cr.ActualSha256))
}
$md.Add('')
$md.Add('## Decision counts')
$md.Add('')
$md.Add(('- total_rows: {0}' -f $totalRows))
$md.Add(('- decision_hold_count: {0}' -f @($holdRows).Count))
$md.Add(('- decision_review_count: {0}' -f @($reviewRows).Count))
$md.Add(('- decision_block_count: {0}' -f @($blockRows).Count))
$md.Add(('- decision_later_approved_row_candidate_count: {0}' -f @($laterRows).Count))
$md.Add(('- blank_user_decision_count: {0}' -f @($blankRows).Count))
$md.Add(('- invalid_user_decision_count: {0}' -f @($invalidRows).Count))
$md.Add('')
$md.Add('## Queue rows')
$md.Add('')
if ($blockers.Count -eq 0) {
    $md.Add('| QueueID | SourceTicketID | FileName | QueueClass | RiskLabel | ActionNow |')
    $md.Add('| --- | --- | --- | --- | --- | --- |')
    foreach ($q in $queueRows) {
        $safeName = ([string]$q.FileName).Replace('|','/')
        $md.Add(('| {0} | {1} | `{2}` | {3} | {4} | {5} |' -f $q.QueueID, $q.SourceTicketID, $safeName, $q.QueueClass, $q.RiskLabel, $q.ActionNow))
    }
} else {
    $md.Add('Queue rows were not produced because blockers were found.')
}
$md.Add('')
$md.Add('## Blockers')
$md.Add('')
if ($blockers.Count -eq 0) { $md.Add('None.') } else { foreach ($b in $blockers) { $md.Add(('- {0}' -f $b)) } }
$md.Add('')
$md.Add('## DoesNotProve')
$md.Add('')
$md.Add('This queue proves only that the 64 REVIEW rows were copied into a helper-script review queue. It does not prove any script is safe, current, executable, useful, route-approved, cleanup-approved, or ready for Git push.')
$md.Add('')
$md.Add('## Next single action')
$md.Add('')
if ($blockers.Count -eq 0) { $md.Add('BUILD_HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION') } else { $md.Add('REPAIR_HELPER_SCRIPT_REVIEW_QUEUE_INPUT_BLOCKERS_NO_EXECUTION') }
$md.Add('')
if ($blockers.Count -eq 0) { $md.Add('Final verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION') } else { $md.Add('Final verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION') }

$md | Set-Content -LiteralPath $QueueMdPath -Encoding UTF8

$print = New-Object System.Collections.Generic.List[string]
$print.Add('HELPER SCRIPT REVIEW QUEUE - COPY PRINT')
$print.Add('Review only. No execution. No route. No cleanup.')
$print.Add(('Queue row count: {0}' -f @($queueRows).Count))
$print.Add('')
foreach ($q in $queueRows) {
    $print.Add(('{0} | {1} | {2} | {3}' -f $q.QueueID, $q.SourceTicketID, $q.FileName, $q.ReviewInstruction))
}
$print | Set-Content -LiteralPath $QueuePrintPath -Encoding UTF8
if ($blockers.Count -eq 0) {
    Set-Clipboard -Value ($print -join [Environment]::NewLine)
}

$QueueCsvSha = ''
if (Test-Path -LiteralPath $QueueCsvPath) { $QueueCsvSha = (Get-FileHash -LiteralPath $QueueCsvPath -Algorithm SHA256).Hash }
$QueueMdSha = (Get-FileHash -LiteralPath $QueueMdPath -Algorithm SHA256).Hash
$QueuePrintSha = (Get-FileHash -LiteralPath $QueuePrintPath -Algorithm SHA256).Hash

$receipt = New-Object System.Collections.Generic.List[string]
$receipt.Add('HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_RECEIPT_V0_1_20260609')
$receipt.Add(('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')))
$receipt.Add(('marked_csv_path: {0}' -f $MarkedCsvPath))
$receipt.Add(('marked_csv_sha256: {0}' -f $ExpectedMarkedCsvSha))
$receipt.Add(('decision_closeout_path: {0}' -f $DecisionCloseoutPath))
$receipt.Add(('decision_closeout_sha256: {0}' -f $ExpectedDecisionCloseoutSha))
$receipt.Add(('output_queue_csv_path: {0}' -f $QueueCsvPath))
$receipt.Add(('output_queue_csv_sha256: {0}' -f $QueueCsvSha))
$receipt.Add(('output_queue_md_path: {0}' -f $QueueMdPath))
$receipt.Add(('output_queue_md_sha256: {0}' -f $QueueMdSha))
$receipt.Add(('output_queue_print_path: {0}' -f $QueuePrintPath))
$receipt.Add(('output_queue_print_sha256: {0}' -f $QueuePrintSha))
$receipt.Add(('total_rows: {0}' -f $totalRows))
$receipt.Add(('queue_review_rows: {0}' -f @($queueRows).Count))
$receipt.Add(('blocker_count: {0}' -f $blockers.Count))
$receipt.Add(('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes))
if ($blockers.Count -eq 0) { $receipt.Add('final_verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION') } else { $receipt.Add('final_verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION') }
$receipt | Set-Content -LiteralPath $QueueReceiptPath -Encoding UTF8
$QueueReceiptSha = (Get-FileHash -LiteralPath $QueueReceiptPath -Algorithm SHA256).Hash

'=== HELPER SCRIPT REVIEW QUEUE FROM 64 REVIEW ROWS V0.1 COMPLETE ==='
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
('queue_review_rows: {0}' -f @($queueRows).Count)
('decision_hold_count: {0}' -f @($holdRows).Count)
('decision_review_count: {0}' -f @($reviewRows).Count)
('decision_block_count: {0}' -f @($blockRows).Count)
('decision_later_approved_row_candidate_count: {0}' -f @($laterRows).Count)
('blocker_count: {0}' -f $blockers.Count)
if ($blockers.Count -eq 0) { 'next_single_action: BUILD_HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION' } else { 'next_single_action: REPAIR_HELPER_SCRIPT_REVIEW_QUEUE_INPUT_BLOCKERS_NO_EXECUTION' }
if ($blockers.Count -eq 0) { 'final_verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
