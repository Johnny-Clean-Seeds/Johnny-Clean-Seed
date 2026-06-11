$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$LaneDir = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SummaryCsvPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_SUMMARY_V0_2_20260609.csv'
$StaticPacketMdPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_2_20260609.md'
$StaticPacketPrintPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_COPY_PRINT_V0_2_20260609.txt'
$StaticPacketReceiptPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_RECEIPT_V0_2_20260609.txt'
$CloseoutPath = Join-Path $LaneDir 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$CloseoutPrintPath = Join-Path $LaneDir 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$CloseoutReceiptPath = Join-Path $LaneDir 'HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

$ExpectedSummaryCsvSha = '9C2E922097CB4C9DC35F931678A3D70F87B56037978FCD8A45213DA46375721D'
$ExpectedStaticPacketMdSha = '3EB8D2223F0685216227D146FBF95515D71F8F6F4CEA000EF0DC2A0E5F6A03D1'
$ExpectedStaticPacketPrintSha = '542422B7754B1B50FD9FB2A539E70EC98A5BA3069BCA8A252B356E8DB4ABEE88'
$ExpectedStaticPacketReceiptSha = '595200DD309D26DFBD4D8F7DB1DC74A6D0E1EB46E9E7BC9E1D4890C906D8CF08'
$ExpectedCloseoutSha = '03B63C7F03192B2001F4D2113DCDBC18302464B2D631110207A88A3607AE311A'
$ExpectedCloseoutPrintSha = 'E108E4495549AB30DD74500C55C6132E0EFC35211D9E607914AB324D041883B9'
$ExpectedCloseoutReceiptSha = '7FFE5E5900602791F4DD53B1BC028DDE2BD02227ECF07FA15E98F553B9DF7B75'

$OutputIndexCsvPath = Join-Path $LaneDir 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$OutputIndexMdPath = Join-Path $LaneDir 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION_V0_1_20260609.md'
$OutputIndexPrintPath = Join-Path $LaneDir 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $LaneDir 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

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

function Get-IndexRole {
    param([string] $StaticDisposition)
    if ($StaticDisposition -eq 'KEEP_AS_LAST_PASSING_PROOF_HELPER_REVIEW_ONLY') {
        return 'LAST_PASSING_PROOF_KEEP_AS_EVIDENCE_ONLY'
    }
    if ($StaticDisposition -eq 'HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN') {
        return 'SUPERSEDED_FAILED_ATTEMPT_HOLD_AS_EVIDENCE_ONLY'
    }
    return 'UNKNOWN_STATIC_DISPOSITION_REVIEW_REQUIRED'
}

function Get-FailureFamily {
    param([string] $FileName)
    switch -Regex ($FileName) {
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609\.ps1$' { return 'SCALAR_COUNT_STRICTMODE_OR_COUNT_SHAPE' }
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_2\.ps1$' { return 'STRICT_PARAM_BINDING_INPUT_SHAPE' }
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_3\.ps1$' { return 'UNESCAPED_WINDOWS_PATH_REGEX' }
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_4\.ps1$' { return 'ARGUMENT_TYPES_MISMATCH_AFTER_BROKEN_PARSER_CHAIN' }
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_5\.ps1$' { return 'LAST_PASSING_CONSERVATIVE_SELECTOR_PARSER_REMOVED' }
        default { return 'UNKNOWN_WITHIN_HSRB_001' }
    }
}

function Get-IndexNote {
    param(
        [string] $FileName,
        [string] $IndexRole
    )
    if ($IndexRole -eq 'LAST_PASSING_PROOF_KEEP_AS_EVIDENCE_ONLY') {
        return 'Keep as the last passing proof helper for this defect chain. Still not movement authority, route authority, source authority, or execution approval.'
    }
    if ($IndexRole -eq 'SUPERSEDED_FAILED_ATTEMPT_HOLD_AS_EVIDENCE_ONLY') {
        return 'Hold as superseded failed attempt evidence. Do not execute. Do not route. Do not clean up from this index.'
    }
    return 'Unknown role requires later manual review. Do not execute.'
}

$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'summary_csv' -Path $SummaryCsvPath -ExpectedSha $ExpectedSummaryCsvSha
$hashChecks += Test-ExpectedHash -Name 'static_packet_md' -Path $StaticPacketMdPath -ExpectedSha $ExpectedStaticPacketMdSha
$hashChecks += Test-ExpectedHash -Name 'static_packet_print' -Path $StaticPacketPrintPath -ExpectedSha $ExpectedStaticPacketPrintSha
$hashChecks += Test-ExpectedHash -Name 'static_packet_receipt' -Path $StaticPacketReceiptPath -ExpectedSha $ExpectedStaticPacketReceiptSha
$hashChecks += Test-ExpectedHash -Name 'decision_closeout_md' -Path $CloseoutPath -ExpectedSha $ExpectedCloseoutSha
$hashChecks += Test-ExpectedHash -Name 'decision_closeout_print' -Path $CloseoutPrintPath -ExpectedSha $ExpectedCloseoutPrintSha
$hashChecks += Test-ExpectedHash -Name 'decision_closeout_receipt' -Path $CloseoutReceiptPath -ExpectedSha $ExpectedCloseoutReceiptSha

$blockers = @()
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
if (($blockers.Count -eq 0) -and ($summaryRowCount -ne 5)) {
    $blockers += ('UNEXPECTED_SUMMARY_ROW_COUNT: {0}' -f $summaryRowCount)
}

$requiredColumns = @('BatchID','QueueID','SourceTicketID','FileName','SourcePath','SourceExists','SourceSha256','KnownOutcome','StaticDisposition','ContainsMoveItem','ContainsRemoveItem','ContainsRenameItem','ContainsStartProcess','ContainsInvokeExpression','ActionNow')
if (($blockers.Count -eq 0) -and ($summaryRowCount -gt 0)) {
    $actualColumns = @($summaryRows[0].PSObject.Properties.Name)
    foreach ($col in $requiredColumns) {
        if ($actualColumns -notcontains $col) {
            $blockers += ('MISSING_SUMMARY_COLUMN: {0}' -f $col)
        }
    }
}

$indexRows = @()
if ($blockers.Count -eq 0) {
    foreach ($r in $summaryRows) {
        $indexRole = Get-IndexRole -StaticDisposition ([string]$r.StaticDisposition)
        $fileName = [string]$r.FileName
        $indexRows += [pscustomobject]@{
            BatchID = [string]$r.BatchID
            QueueID = [string]$r.QueueID
            SourceTicketID = [string]$r.SourceTicketID
            FileName = [string]$fileName
            SourcePath = [string]$r.SourcePath
            SourceSha256 = [string]$r.SourceSha256
            KnownOutcome = [string]$r.KnownOutcome
            FailureFamily = [string](Get-FailureFamily -FileName $fileName)
            StaticDisposition = [string]$r.StaticDisposition
            IndexRole = [string]$indexRole
            PreserveRule = 'PRESERVE_AS_REVIEW_EVIDENCE_ONLY'
            ExecutionAuthority = 'NO'
            RouteAuthority = 'NO'
            CleanupAuthority = 'NO'
            CommitAuthority = 'NO'
            ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
            IndexNote = [string](Get-IndexNote -FileName $fileName -IndexRole $indexRole)
        }
    }
}

$lastPassingRows = @($indexRows | Where-Object { $_.IndexRole -eq 'LAST_PASSING_PROOF_KEEP_AS_EVIDENCE_ONLY' })
$supersededFailedRows = @($indexRows | Where-Object { $_.IndexRole -eq 'SUPERSEDED_FAILED_ATTEMPT_HOLD_AS_EVIDENCE_ONLY' })
$unknownRoleRows = @($indexRows | Where-Object { $_.IndexRole -eq 'UNKNOWN_STATIC_DISPOSITION_REVIEW_REQUIRED' })
$moveRows = @($summaryRows | Where-Object { ([string]$_.ContainsMoveItem) -eq 'True' })
$removeRows = @($summaryRows | Where-Object { ([string]$_.ContainsRemoveItem) -eq 'True' })
$renameRows = @($summaryRows | Where-Object { ([string]$_.ContainsRenameItem) -eq 'True' })
$startProcessRows = @($summaryRows | Where-Object { ([string]$_.ContainsStartProcess) -eq 'True' })
$invokeExpressionRows = @($summaryRows | Where-Object { ([string]$_.ContainsInvokeExpression) -eq 'True' })

if (($blockers.Count -eq 0) -and ((Count-Items $lastPassingRows) -ne 1)) {
    $blockers += ('UNEXPECTED_LAST_PASSING_PROOF_COUNT: {0}' -f (Count-Items $lastPassingRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $supersededFailedRows) -ne 4)) {
    $blockers += ('UNEXPECTED_SUPERSEDED_FAILED_ATTEMPT_COUNT: {0}' -f (Count-Items $supersededFailedRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $unknownRoleRows) -ne 0)) {
    $blockers += ('UNKNOWN_INDEX_ROLE_COUNT: {0}' -f (Count-Items $unknownRoleRows))
}

if ($blockers.Count -eq 0) {
    $indexRows | Export-Csv -LiteralPath $OutputIndexCsvPath -NoTypeInformation -Encoding UTF8
}

$md = @()
$md += '# HSRB-001 Last Passing Proof and Superseded Failed Attempt Index - V0.1'
$md += ''
$md += 'Status: PROOF_INDEX / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += ''
$md += 'Index the five scripts in Batch HSRB-001 after static review. This separates the last passing proof helper from the superseded failed generated attempts.'
$md += ''
$md += '## Boundary'
$md += ''
$md += 'This index does not execute, move, delete, rename, route, clean up, commit, or push anything. It only writes review evidence outputs.'
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
$md += ('- selected_batch_id: HSRB-001')
$md += ('- selected_batch_rows: {0}' -f $summaryRowCount)
$md += ('- last_passing_proof_count: {0}' -f (Count-Items $lastPassingRows))
$md += ('- superseded_failed_attempt_count: {0}' -f (Count-Items $supersededFailedRows))
$md += ('- unknown_index_role_count: {0}' -f (Count-Items $unknownRoleRows))
$md += ('- contains_move_item_count: {0}' -f (Count-Items $moveRows))
$md += ('- contains_remove_item_count: {0}' -f (Count-Items $removeRows))
$md += ('- contains_rename_item_count: {0}' -f (Count-Items $renameRows))
$md += ('- contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
$md += ('- contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
$md += ('- blocker_count: {0}' -f $blockers.Count)
$md += ''
$md += '## Index table'
$md += ''
$md += '| QueueID | FileName | FailureFamily | IndexRole | SourceSha256 |'
$md += '| --- | --- | --- | --- | --- |'
foreach ($r in $indexRows) {
    $md += ('| {0} | `{1}` | {2} | {3} | `{4}` |' -f $r.QueueID, (Escape-MdCell $r.FileName), (Escape-MdCell $r.FailureFamily), (Escape-MdCell $r.IndexRole), $r.SourceSha256)
}
$md += ''
$md += '## Authority statement'
$md += ''
$md += 'All indexed rows remain review evidence only. The last passing proof row is not route authority or execution authority. The superseded failed rows are preserved as failure evidence only.'
$md += ''
$md += '## Blockers'
$md += ''
if ($blockers.Count -eq 0) {
    $md += 'None.'
} else {
    foreach ($b in $blockers) { $md += ('- {0}' -f $b) }
}
$md += ''
$md += '## Next single action'
$md += ''
if ($blockers.Count -eq 0) {
    $md += 'BUILD_HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION'
    $md += ''
    $md += 'Final verdict: HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $md += 'REPAIR_HSRB_001_PROOF_INDEX_INPUT_BLOCKERS_NO_EXECUTION'
    $md += ''
    $md += 'Final verdict: HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
$md | Set-Content -LiteralPath $OutputIndexMdPath -Encoding UTF8

$print = @()
$print += 'HSRB-001 LAST PASSING PROOF AND SUPERSEDED FAILED ATTEMPT INDEX V0.1'
$print += 'No execution. No route. No cleanup. No commit. No push.'
$print += ''
$print += ('Selected batch rows: {0}' -f $summaryRowCount)
$print += ('Last passing proof count: {0}' -f (Count-Items $lastPassingRows))
$print += ('Superseded failed attempt count: {0}' -f (Count-Items $supersededFailedRows))
$print += ('Unknown index role count: {0}' -f (Count-Items $unknownRoleRows))
$print += ('Blocker count: {0}' -f $blockers.Count)
$print += ''
$print += 'ROWS:'
foreach ($r in $indexRows) {
    $print += ('{0} | {1}' -f $r.QueueID, $r.FileName)
    $print += ('FailureFamily: {0}' -f $r.FailureFamily)
    $print += ('IndexRole: {0}' -f $r.IndexRole)
    $print += ('ActionNow: {0}' -f $r.ActionNow)
    $print += '---'
}
$print += 'NEXT_SINGLE_ACTION:'
if ($blockers.Count -eq 0) { $print += 'BUILD_HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION' } else { $print += 'REPAIR_HSRB_001_PROOF_INDEX_INPUT_BLOCKERS_NO_EXECUTION' }
$print | Set-Content -LiteralPath $OutputIndexPrintPath -Encoding UTF8
if ($blockers.Count -eq 0) {
    Set-Clipboard -Value ($print -join [Environment]::NewLine)
}

$OutputIndexCsvSha = ''
if (Test-Path -LiteralPath $OutputIndexCsvPath) { $OutputIndexCsvSha = (Get-FileHash -LiteralPath $OutputIndexCsvPath -Algorithm SHA256).Hash }
$OutputIndexMdSha = (Get-FileHash -LiteralPath $OutputIndexMdPath -Algorithm SHA256).Hash
$OutputIndexPrintSha = (Get-FileHash -LiteralPath $OutputIndexPrintPath -Algorithm SHA256).Hash

$receipt = @()
$receipt += 'HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_RECEIPT_V0_1_20260609'
$receipt += ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
$receipt += ('input_summary_csv_path: {0}' -f $SummaryCsvPath)
$receipt += ('input_summary_csv_expected_sha256: {0}' -f $ExpectedSummaryCsvSha)
$receipt += ('input_closeout_path: {0}' -f $CloseoutPath)
$receipt += ('input_closeout_expected_sha256: {0}' -f $ExpectedCloseoutSha)
$receipt += ('output_index_csv_path: {0}' -f $OutputIndexCsvPath)
$receipt += ('output_index_csv_sha256: {0}' -f $OutputIndexCsvSha)
$receipt += ('output_index_md_path: {0}' -f $OutputIndexMdPath)
$receipt += ('output_index_md_sha256: {0}' -f $OutputIndexMdSha)
$receipt += ('output_index_print_path: {0}' -f $OutputIndexPrintPath)
$receipt += ('output_index_print_sha256: {0}' -f $OutputIndexPrintSha)
$receipt += ('selected_batch_id: HSRB-001')
$receipt += ('selected_batch_rows: {0}' -f $summaryRowCount)
$receipt += ('last_passing_proof_count: {0}' -f (Count-Items $lastPassingRows))
$receipt += ('superseded_failed_attempt_count: {0}' -f (Count-Items $supersededFailedRows))
$receipt += ('unknown_index_role_count: {0}' -f (Count-Items $unknownRoleRows))
$receipt += ('contains_move_item_count: {0}' -f (Count-Items $moveRows))
$receipt += ('contains_remove_item_count: {0}' -f (Count-Items $removeRows))
$receipt += ('contains_rename_item_count: {0}' -f (Count-Items $renameRows))
$receipt += ('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
$receipt += ('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
$receipt += ('blocker_count: {0}' -f $blockers.Count)
$receipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
if ($blockers.Count -eq 0) {
    $receipt += 'next_single_action: BUILD_HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION'
    $receipt += 'final_verdict: HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $receipt += 'next_single_action: REPAIR_HSRB_001_PROOF_INDEX_INPUT_BLOCKERS_NO_EXECUTION'
    $receipt += 'final_verdict: HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
$receipt | Set-Content -LiteralPath $OutputReceiptPath -Encoding UTF8
$OutputReceiptSha = (Get-FileHash -LiteralPath $OutputReceiptPath -Algorithm SHA256).Hash

'=== HSRB-001 LAST PASSING PROOF AND SUPERSEDED FAILED ATTEMPT INDEX V0.1 COMPLETE ==='
('output_index_csv_path: {0}' -f $OutputIndexCsvPath)
('output_index_csv_sha256: {0}' -f $OutputIndexCsvSha)
('output_index_md_path: {0}' -f $OutputIndexMdPath)
('output_index_md_sha256: {0}' -f $OutputIndexMdSha)
('output_index_print_path: {0}' -f $OutputIndexPrintPath)
('output_index_print_sha256: {0}' -f $OutputIndexPrintSha)
('output_receipt_path: {0}' -f $OutputReceiptPath)
('output_receipt_sha256: {0}' -f $OutputReceiptSha)
('summary_csv_verified: {0}' -f (($hashChecks | Where-Object { $_.Name -eq 'summary_csv' }).HashMatch))
('static_packet_verified: {0}' -f (($hashChecks | Where-Object { $_.Name -eq 'static_packet_md' }).HashMatch))
('decision_closeout_verified: {0}' -f (($hashChecks | Where-Object { $_.Name -eq 'decision_closeout_md' }).HashMatch))
('selected_batch_id: HSRB-001')
('selected_batch_rows: {0}' -f $summaryRowCount)
('last_passing_proof_count: {0}' -f (Count-Items $lastPassingRows))
('superseded_failed_attempt_count: {0}' -f (Count-Items $supersededFailedRows))
('unknown_index_role_count: {0}' -f (Count-Items $unknownRoleRows))
('contains_move_item_count: {0}' -f (Count-Items $moveRows))
('contains_remove_item_count: {0}' -f (Count-Items $removeRows))
('contains_rename_item_count: {0}' -f (Count-Items $renameRows))
('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
('blocker_count: {0}' -f $blockers.Count)
if ($blockers.Count -eq 0) { 'next_single_action: BUILD_HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION' } else { 'next_single_action: REPAIR_HSRB_001_PROOF_INDEX_INPUT_BLOCKERS_NO_EXECUTION' }
if ($blockers.Count -eq 0) { 'final_verdict: HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
