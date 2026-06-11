$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$LaneDir = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$QueueCsvPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$QueueMdPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.md'
$QueuePrintPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_COPY_PRINT_V0_2_20260609.txt'
$QueueReceiptPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_RECEIPT_V0_2_20260609.txt'

$ExpectedQueueCsvSha = '791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43'
$ExpectedQueueMdSha = 'FDDE84E707460948DEA21115B31D2738FED10E9DA74EE87D2B4480043BB295C5'
$ExpectedQueuePrintSha = '50DA5C4F65FA3EF26B62E5A4849D841AAAA417CEA892FB89D963922EB19F071A'
$ExpectedQueueReceiptSha = '8CDA1DCB238C360A13E3648E549190485035FD02C9EFE755F9881176C10995CB'

$OutputBatchIndexCsvPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_BATCH_INDEX_V0_1_20260609.csv'
$OutputSelectedBatchCsvPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_001_V0_1_20260609.csv'
$OutputMdPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$OutputPrintPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Add-TextLine {
    param(
        [System.Collections.ArrayList] $List,
        [AllowNull()] $Text
    )
    [void]$List.Add([string]$Text)
}

function Count-Items {
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
        $actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
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

function Get-ReviewFamily {
    param([string] $FileName)

    if ($FileName -like 'BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609*') {
        return 'ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN'
    }
    if (($FileName -like 'BUILD_HELPER_FILE_SURFACE_PREFLIGHT*') -or ($FileName -like 'BUILD_PLANETARY_GATE*')) {
        return 'PLANETARY_PREFLIGHT_CLOSEOUT_FAMILY'
    }
    if (($FileName -like '*ROOT_HELD_GROUP_ROUTE_OR_HOLD*') -or ($FileName -like '*ROOT_HELD_GROUP_ROUTE_PLAN_ONLY*') -or ($FileName -like '*ROOT_HELD_GROUP_SCRIPT_CUSTODY*') -or ($FileName -like '*ROOT_HELD_GROUP_NON_SCRIPT*')) {
        return 'ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY'
    }
    if (($FileName -like 'BUILD_ROOT_DROP_INTAKE_WASHER*') -or ($FileName -like 'RUN_ROOT_DROP_INTAKE_WASHER*')) {
        return 'ROOT_DROP_INTAKE_WASHER_FAMILY'
    }
    if (($FileName -like '*GENERATED_RUNNER_SAFE_TEMPLATE*') -or ($FileName -like 'FIELD_APPLY_GENERATED_RUNNER*') -or ($FileName -like 'FREEZE_GENERATED_RUNNER*') -or ($FileName -like 'FREEZE_GIT_SNAPSHOT*')) {
        return 'GENERATED_RUNNER_DEFECT_FAMILY'
    }
    if ($FileName -like 'ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER*') {
        return 'ROUGH_LOCAL_IMPORT_ROOT_DROP_FAMILY'
    }
    if ($FileName -like 'ROUGH_LOCAL_IMPORT_ROOT_HELD_GROUP*') {
        return 'ROUGH_LOCAL_IMPORT_ROOT_HELD_FAMILY'
    }
    if ($FileName -like 'RUN_*') {
        return 'RUN_FIELD_TEST_FAMILY'
    }
    return 'OTHER_HELPER_REVIEW_FAMILY'
}

function Get-FamilyRank {
    param([string] $Family)
    switch ($Family) {
        'ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN' { return 1 }
        'PLANETARY_PREFLIGHT_CLOSEOUT_FAMILY' { return 2 }
        'ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY' { return 3 }
        'ROOT_DROP_INTAKE_WASHER_FAMILY' { return 4 }
        'GENERATED_RUNNER_DEFECT_FAMILY' { return 5 }
        'ROUGH_LOCAL_IMPORT_ROOT_DROP_FAMILY' { return 6 }
        'ROUGH_LOCAL_IMPORT_ROOT_HELD_FAMILY' { return 7 }
        'RUN_FIELD_TEST_FAMILY' { return 8 }
        default { return 9 }
    }
}

function Get-BatchIdForFamily {
    param([string] $Family)
    switch ($Family) {
        'ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN' { return 'HSRB-001' }
        'PLANETARY_PREFLIGHT_CLOSEOUT_FAMILY' { return 'HSRB-002' }
        'ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY' { return 'HSRB-003' }
        'ROOT_DROP_INTAKE_WASHER_FAMILY' { return 'HSRB-004' }
        'GENERATED_RUNNER_DEFECT_FAMILY' { return 'HSRB-005' }
        'ROUGH_LOCAL_IMPORT_ROOT_DROP_FAMILY' { return 'HSRB-006' }
        'ROUGH_LOCAL_IMPORT_ROOT_HELD_FAMILY' { return 'HSRB-007' }
        'RUN_FIELD_TEST_FAMILY' { return 'HSRB-008' }
        default { return 'HSRB-009' }
    }
}

function Get-BatchReasonForFamily {
    param([string] $Family)
    switch ($Family) {
        'ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN' { return 'First review because it is the active generated-script defect chain already touched in this session.' }
        'PLANETARY_PREFLIGHT_CLOSEOUT_FAMILY' { return 'Review preflight and planetary selector builders after the active defect chain.' }
        'ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY' { return 'Review root-held custody and route-or-hold helpers as one conceptual family.' }
        'ROOT_DROP_INTAKE_WASHER_FAMILY' { return 'Review root drop intake washer helpers and runners as one family.' }
        'GENERATED_RUNNER_DEFECT_FAMILY' { return 'Review generated-runner template, field apply, and freeze helpers as one family.' }
        'ROUGH_LOCAL_IMPORT_ROOT_DROP_FAMILY' { return 'Review rough-local import root-drop helper copies as one family.' }
        'ROUGH_LOCAL_IMPORT_ROOT_HELD_FAMILY' { return 'Review rough-local import root-held helper copies as one family.' }
        'RUN_FIELD_TEST_FAMILY' { return 'Review run and field-test helper scripts last because they are runner-shaped and never execution-approved here.' }
        default { return 'Review remaining helper scripts only after named families are complete.' }
    }
}

$blockers = @()
$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'queue_csv' -Path $QueueCsvPath -ExpectedSha $ExpectedQueueCsvSha
$hashChecks += Test-ExpectedHash -Name 'queue_md' -Path $QueueMdPath -ExpectedSha $ExpectedQueueMdSha
$hashChecks += Test-ExpectedHash -Name 'queue_print' -Path $QueuePrintPath -ExpectedSha $ExpectedQueuePrintSha
$hashChecks += Test-ExpectedHash -Name 'queue_receipt' -Path $QueueReceiptPath -ExpectedSha $ExpectedQueueReceiptSha

foreach ($h in $hashChecks) {
    if (-not $h.Exists) {
        $blockers += ('MISSING_{0}: {1}' -f $h.Name, $h.Path)
    } elseif (-not $h.HashMatch) {
        $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256)
    }
}

$queueRows = @()
if ($blockers.Count -eq 0) {
    $queueRows = @(Import-Csv -LiteralPath $QueueCsvPath)
}

$queueRowCount = Count-Items $queueRows
$badActionRows = @($queueRows | Where-Object { $_.ActionNow -ne 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP' })
$badDecisionRows = @($queueRows | Where-Object { $_.UserDecision -ne 'REVIEW' })
$badActionCount = Count-Items $badActionRows
$badDecisionCount = Count-Items $badDecisionRows

if (($blockers.Count -eq 0) -and ($queueRowCount -ne 64)) { $blockers += ('UNEXPECTED_QUEUE_ROW_COUNT: {0}' -f $queueRowCount) }
if (($blockers.Count -eq 0) -and ($badActionCount -ne 0)) { $blockers += ('UNEXPECTED_ACTION_NOW_ROWS: {0}' -f $badActionCount) }
if (($blockers.Count -eq 0) -and ($badDecisionCount -ne 0)) { $blockers += ('UNEXPECTED_USER_DECISION_ROWS: {0}' -f $badDecisionCount) }

$batchRows = @()
$sourceMissingCount = 0
$sourcePresentCount = 0
if ($blockers.Count -eq 0) {
    foreach ($r in $queueRows) {
        $fileName = [string]$r.FileName
        $family = Get-ReviewFamily -FileName $fileName
        $rank = Get-FamilyRank -Family $family
        $batchId = Get-BatchIdForFamily -Family $family
        $batchReason = Get-BatchReasonForFamily -Family $family
        $sourcePath = Join-Path $ProjectRoot $fileName
        $sourceExists = Test-Path -LiteralPath $sourcePath
        $sourceSha = ''
        $sourceBytes = 0
        if ($sourceExists) {
            $sourceSha = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash
            $sourceBytes = [int64](Get-Item -LiteralPath $sourcePath).Length
            $sourcePresentCount++
        } else {
            $sourceMissingCount++
        }
        $batchRows += [pscustomobject]@{
            BatchID = [string]$batchId
            FamilyRank = [int]$rank
            ReviewFamily = [string]$family
            QueueID = [string]$r.QueueID
            SourceTicketID = [string]$r.SourceTicketID
            FileName = [string]$fileName
            SourcePath = [string]$sourcePath
            SourceExists = [bool]$sourceExists
            SourceSha256 = [string]$sourceSha
            SourceBytes = [int64]$sourceBytes
            QueueClass = [string]$r.QueueClass
            RiskLabel = [string]$r.RiskLabel
            ReviewInstruction = 'STATIC_REVIEW_ONLY_DO_NOT_EXECUTE'
            ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
            BatchReason = [string]$batchReason
        }
    }
    $batchRows = @($batchRows | Sort-Object FamilyRank, QueueID)

    $batchRows | Export-Csv -LiteralPath $OutputBatchIndexCsvPath -NoTypeInformation -Encoding UTF8
}

$selectedBatchId = 'HSRB-001'
$selectedBatchRows = @($batchRows | Where-Object { $_.BatchID -eq $selectedBatchId })
$selectedBatchCount = Count-Items $selectedBatchRows
if ($blockers.Count -eq 0) {
    $selectedBatchRows | Export-Csv -LiteralPath $OutputSelectedBatchCsvPath -NoTypeInformation -Encoding UTF8
}

$familyGroups = @()
if ($blockers.Count -eq 0) {
    $familyGroups = @($batchRows | Group-Object BatchID, ReviewFamily | Sort-Object { [int](($_.Group | Select-Object -First 1).FamilyRank) })
}

$md = New-Object System.Collections.ArrayList
Add-TextLine $md '# Helper Script Review Batch Selector From 64 Queue - V0.1'
Add-TextLine $md ''
Add-TextLine $md 'Status: BATCH_SELECTOR / REVIEW_ONLY / STATIC_READ_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP'
Add-TextLine $md ''
Add-TextLine $md '## Purpose'
Add-TextLine $md ''
Add-TextLine $md 'Convert the 64-row helper script review queue into review batches and select Batch HSRB-001 for the next static review packet.'
Add-TextLine $md ''
Add-TextLine $md 'This selector does not execute helper scripts. It does not move, delete, rename, route, commit, push, or clean up anything.'
Add-TextLine $md ''
Add-TextLine $md '## Verified input queue'
Add-TextLine $md ''
Add-TextLine $md '| Input | Exists | HashMatch | SHA256 |'
Add-TextLine $md '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) {
    Add-TextLine $md ('| {0} | {1} | {2} | `{3}` |' -f $h.Name, $h.Exists, $h.HashMatch, $h.ActualSha256)
}
Add-TextLine $md ''
Add-TextLine $md '## Counts'
Add-TextLine $md ''
Add-TextLine $md ('- queue_review_rows: {0}' -f $queueRowCount)
Add-TextLine $md ('- batch_index_rows: {0}' -f (Count-Items $batchRows))
Add-TextLine $md ('- selected_batch_id: {0}' -f $selectedBatchId)
Add-TextLine $md ('- selected_batch_rows: {0}' -f $selectedBatchCount)
Add-TextLine $md ('- source_present_count: {0}' -f $sourcePresentCount)
Add-TextLine $md ('- source_missing_count: {0}' -f $sourceMissingCount)
Add-TextLine $md ('- blocker_count: {0}' -f $blockers.Count)
Add-TextLine $md ''
Add-TextLine $md '## Batch order'
Add-TextLine $md ''
Add-TextLine $md '| BatchID | ReviewFamily | RowCount | Reason |'
Add-TextLine $md '| --- | --- | ---: | --- |'
if ($blockers.Count -eq 0) {
    foreach ($g in $familyGroups) {
        $first = $g.Group | Select-Object -First 1
        Add-TextLine $md ('| {0} | {1} | {2} | {3} |' -f $first.BatchID, $first.ReviewFamily, (Count-Items $g.Group), $first.BatchReason)
    }
} else {
    Add-TextLine $md '| BLOCKED | BLOCKED | 0 | Input queue validation failed. |'
}
Add-TextLine $md ''
Add-TextLine $md '## Selected Batch HSRB-001'
Add-TextLine $md ''
Add-TextLine $md 'Reason: first review stays on the active route-selector defect chain already touched in this session.'
Add-TextLine $md ''
Add-TextLine $md '| QueueID | SourceTicketID | FileName | SourceExists | SourceSha256 | ActionNow |'
Add-TextLine $md '| --- | --- | --- | ---: | --- | --- |'
foreach ($s in $selectedBatchRows) {
    $safeName = ([string]$s.FileName).Replace('|','/')
    Add-TextLine $md ('| {0} | {1} | `{2}` | {3} | `{4}` | {5} |' -f $s.QueueID, $s.SourceTicketID, $safeName, $s.SourceExists, $s.SourceSha256, $s.ActionNow)
}
Add-TextLine $md ''
Add-TextLine $md '## Blockers'
Add-TextLine $md ''
if ($blockers.Count -eq 0) {
    Add-TextLine $md 'None.'
} else {
    foreach ($b in $blockers) { Add-TextLine $md ('- {0}' -f $b) }
}
Add-TextLine $md ''
Add-TextLine $md '## DoesNotProve'
Add-TextLine $md ''
Add-TextLine $md 'This selector proves only that a review order and selected static-review batch were produced from the 64-row queue. It does not prove any helper script is safe, current, useful, execution-approved, route-approved, cleanup-approved, or ready to commit or push.'
Add-TextLine $md ''
Add-TextLine $md '## Next single action'
Add-TextLine $md ''
if ($blockers.Count -eq 0) {
    Add-TextLine $md 'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_NO_EXECUTION'
    Add-TextLine $md ''
    Add-TextLine $md 'Final verdict: HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    Add-TextLine $md 'REPAIR_HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_INPUT_BLOCKERS_NO_EXECUTION'
    Add-TextLine $md ''
    Add-TextLine $md 'Final verdict: HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-Utf8Lines -Path $OutputMdPath -Lines $md.ToArray()

$print = New-Object System.Collections.ArrayList
Add-TextLine $print 'HELPER SCRIPT REVIEW BATCH SELECTOR - COPY PRINT V0.1'
Add-TextLine $print 'Review only. No execution. No route. No cleanup.'
Add-TextLine $print ''
Add-TextLine $print ('Queue rows: {0}' -f $queueRowCount)
Add-TextLine $print ('Selected batch: {0}' -f $selectedBatchId)
Add-TextLine $print ('Selected batch rows: {0}' -f $selectedBatchCount)
Add-TextLine $print ('Source missing count: {0}' -f $sourceMissingCount)
Add-TextLine $print ('Blocker count: {0}' -f $blockers.Count)
Add-TextLine $print ''
Add-TextLine $print 'BATCH ORDER:'
if ($blockers.Count -eq 0) {
    foreach ($g in $familyGroups) {
        $first = $g.Group | Select-Object -First 1
        Add-TextLine $print ('{0} | {1} | rows={2}' -f $first.BatchID, $first.ReviewFamily, (Count-Items $g.Group))
    }
} else {
    Add-TextLine $print 'BLOCKED - input queue validation failed.'
}
Add-TextLine $print ''
Add-TextLine $print 'SELECTED BATCH HSRB-001:'
foreach ($s in $selectedBatchRows) {
    Add-TextLine $print ('{0} | {1} | {2} | exists={3}' -f $s.QueueID, $s.SourceTicketID, $s.FileName, $s.SourceExists)
}
Add-TextLine $print ''
Add-TextLine $print 'NEXT_SINGLE_ACTION:'
if ($blockers.Count -eq 0) {
    Add-TextLine $print 'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_NO_EXECUTION'
} else {
    Add-TextLine $print 'REPAIR_HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_INPUT_BLOCKERS_NO_EXECUTION'
}
Write-Utf8Lines -Path $OutputPrintPath -Lines $print.ToArray()
if ($blockers.Count -eq 0) {
    Set-Clipboard -Value (($print.ToArray()) -join [Environment]::NewLine)
}

$OutputBatchIndexCsvSha = ''
if (Test-Path -LiteralPath $OutputBatchIndexCsvPath) { $OutputBatchIndexCsvSha = (Get-FileHash -LiteralPath $OutputBatchIndexCsvPath -Algorithm SHA256).Hash }
$OutputSelectedBatchCsvSha = ''
if (Test-Path -LiteralPath $OutputSelectedBatchCsvPath) { $OutputSelectedBatchCsvSha = (Get-FileHash -LiteralPath $OutputSelectedBatchCsvPath -Algorithm SHA256).Hash }
$OutputMdSha = (Get-FileHash -LiteralPath $OutputMdPath -Algorithm SHA256).Hash
$OutputPrintSha = (Get-FileHash -LiteralPath $OutputPrintPath -Algorithm SHA256).Hash

$receipt = New-Object System.Collections.ArrayList
Add-TextLine $receipt 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609'
Add-TextLine $receipt ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
Add-TextLine $receipt ('input_queue_csv_path: {0}' -f $QueueCsvPath)
Add-TextLine $receipt ('input_queue_csv_sha256: {0}' -f $ExpectedQueueCsvSha)
Add-TextLine $receipt ('output_batch_index_csv_path: {0}' -f $OutputBatchIndexCsvPath)
Add-TextLine $receipt ('output_batch_index_csv_sha256: {0}' -f $OutputBatchIndexCsvSha)
Add-TextLine $receipt ('output_selected_batch_csv_path: {0}' -f $OutputSelectedBatchCsvPath)
Add-TextLine $receipt ('output_selected_batch_csv_sha256: {0}' -f $OutputSelectedBatchCsvSha)
Add-TextLine $receipt ('output_md_path: {0}' -f $OutputMdPath)
Add-TextLine $receipt ('output_md_sha256: {0}' -f $OutputMdSha)
Add-TextLine $receipt ('output_print_path: {0}' -f $OutputPrintPath)
Add-TextLine $receipt ('output_print_sha256: {0}' -f $OutputPrintSha)
Add-TextLine $receipt ('queue_review_rows: {0}' -f $queueRowCount)
Add-TextLine $receipt ('selected_batch_id: {0}' -f $selectedBatchId)
Add-TextLine $receipt ('selected_batch_rows: {0}' -f $selectedBatchCount)
Add-TextLine $receipt ('source_present_count: {0}' -f $sourcePresentCount)
Add-TextLine $receipt ('source_missing_count: {0}' -f $sourceMissingCount)
Add-TextLine $receipt ('blocker_count: {0}' -f $blockers.Count)
Add-TextLine $receipt ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
if ($blockers.Count -eq 0) {
    Add-TextLine $receipt 'final_verdict: HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    Add-TextLine $receipt 'final_verdict: HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-Utf8Lines -Path $OutputReceiptPath -Lines $receipt.ToArray()
$OutputReceiptSha = (Get-FileHash -LiteralPath $OutputReceiptPath -Algorithm SHA256).Hash

'=== HELPER SCRIPT REVIEW BATCH SELECTOR FROM 64 QUEUE V0.1 COMPLETE ==='
('output_batch_index_csv_path: {0}' -f $OutputBatchIndexCsvPath)
('output_batch_index_csv_sha256: {0}' -f $OutputBatchIndexCsvSha)
('output_selected_batch_csv_path: {0}' -f $OutputSelectedBatchCsvPath)
('output_selected_batch_csv_sha256: {0}' -f $OutputSelectedBatchCsvSha)
('output_md_path: {0}' -f $OutputMdPath)
('output_md_sha256: {0}' -f $OutputMdSha)
('output_print_path: {0}' -f $OutputPrintPath)
('output_print_sha256: {0}' -f $OutputPrintSha)
('output_receipt_path: {0}' -f $OutputReceiptPath)
('output_receipt_sha256: {0}' -f $OutputReceiptSha)
('input_queue_verified: {0}' -f (($hashChecks | Where-Object { $_.Name -eq 'queue_csv' }).HashMatch))
('queue_review_rows: {0}' -f $queueRowCount)
('selected_batch_id: {0}' -f $selectedBatchId)
('selected_batch_rows: {0}' -f $selectedBatchCount)
('source_present_count: {0}' -f $sourcePresentCount)
('source_missing_count: {0}' -f $sourceMissingCount)
('blocker_count: {0}' -f $blockers.Count)
if ($blockers.Count -eq 0) { 'next_single_action: BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_NO_EXECUTION' } else { 'next_single_action: REPAIR_HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_INPUT_BLOCKERS_NO_EXECUTION' }
if ($blockers.Count -eq 0) { 'final_verdict: HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
