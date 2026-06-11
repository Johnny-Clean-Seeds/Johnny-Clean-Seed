# BUILD_HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_20260609_V0_1.ps1
# Purpose: contract-first closeout for HSRB-004 static review packet. Classifies git markers as REVIEW_ONLY evidence; does not execute, move, delete, rename, route, clean, commit, or push.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$Expected = [ordered]@{
    SelectorBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_004_V0_1_20260609.csv'
    SelectorBatchCsvSha256 = 'CD5A144CFAB6A56FA37C3D83A3D63F70B18292D6DFF8D5AE8313C1F91A18C47D'
    SelectorReportPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
    SelectorReportSha256 = 'DA9BC5A0CB426ADA37739073610796F8EA99E195676C69501219DD2B5B171BCE'
    SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'
    SelectorReceiptSha256 = '647FCE8F77E02DBE0E79895B3312F71863442430C35994F53721B343BA85BB56'
    Hsrb003CloseoutPath = Join-Path $Lane 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
    Hsrb003CloseoutSha256 = 'F13DB92367A72054D44D7810295850A7E0513A08EF17FA5ED2678A1800E41C2F'
    Hsrb003CloseoutReceiptPath = Join-Path $Lane 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'
    Hsrb003CloseoutReceiptSha256 = '8CC56ACB7B60C521F1ED37BC0663E465BF455679B0E0792E5EDB1BDAD8869CDB'
    SummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_SUMMARY_V0_1_20260609.csv'
    SummaryCsvSha256 = 'B91829990D3AE011A8F7D8221487BC9302079ECF55CF722CE7C138DA67244C8C'
    PacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_20260609.md'
    PacketMdSha256 = 'ACB93394A06256D4EC421E37233F7D64C04E8EF12AAA691B02D2B8FAAF175B8A'
    PacketPrintPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_COPY_PRINT_V0_1_20260609.txt'
    PacketPrintSha256 = 'ACB93394A06256D4EC421E37233F7D64C04E8EF12AAA691B02D2B8FAAF175B8A'
    PacketReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_RECEIPT_V0_1_20260609.txt'
    PacketReceiptSha256 = '7C55B2BBA90D4EAAB3A963843FFD8A5E579850577761C552A657145EA999AFF2'
}

$OutRiskCsvPath = Join-Path $Lane 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'
$OutCloseoutPath = Join-Path $Lane 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_1_20260609.md'
$OutCloseoutPrintPath = Join-Path $Lane 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutReceiptPath = Join-Path $Lane 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Get-Sha256Safe {
    param([AllowNull()][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash).ToUpperInvariant()
}

function Test-ExpectedFile {
    param([string]$Name, [string]$Path, [string]$ExpectedSha256)
    $exists = Test-Path -LiteralPath $Path -PathType Leaf
    $actual = ''
    $match = $false
    if ($exists) {
        $actual = Get-Sha256Safe -Path $Path
        $match = ($actual -eq $ExpectedSha256.ToUpperInvariant())
    }
    return [pscustomobject]@{
        Name = [string]$Name
        Path = [string]$Path
        Exists = [bool]$exists
        ExpectedSha256 = [string]$ExpectedSha256.ToUpperInvariant()
        ActualSha256 = [string]$actual
        HashMatch = [bool]$match
    }
}

function Count-Items { param([AllowNull()]$Value) return [int](@($Value).Count) }

function Count-Where {
    param([AllowNull()]$Rows, [scriptblock]$Predicate)
    if ($null -eq $Predicate) { throw 'Predicate was null.' }
    return [int](@($Rows | Where-Object $Predicate).Count)
}

function Bool-FromCsv {
    param([AllowNull()]$Value)
    $s = ([string]$Value).Trim()
    if ($s -match '^(?i:true|1|yes)$') { return $true }
    return $false
}

function Write-LinesNoBom {
    param([Parameter(Mandatory=$true)][string]$Path, [AllowNull()][object[]]$Lines)
    if ($null -eq $Lines) { $Lines = @() }
    $stringLines = foreach ($line in @($Lines)) { if ($null -eq $line) { '' } else { [string]$line } }
    $text = [string]::Join([Environment]::NewLine, @($stringLines))
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
}

function Escape-MdCell {
    param([AllowNull()]$Value)
    if ($null -eq $Value) { return '' }
    $s = [string]$Value
    $s = $s.Replace('|','/')
    $s = $s.Replace("`r",' ')
    $s = $s.Replace("`n",' ')
    return $s
}

function Get-RiskClass {
    param($Row)
    $move = Bool-FromCsv $Row.ContainsMoveItem
    $remove = Bool-FromCsv $Row.ContainsRemoveItem
    $rename = Bool-FromCsv $Row.ContainsRenameItem
    $start = Bool-FromCsv $Row.ContainsStartProcess
    $invoke = Bool-FromCsv $Row.ContainsInvokeExpression
    $copy = Bool-FromCsv $Row.ContainsCopyItem
    $git = Bool-FromCsv $Row.ContainsGitCommand
    $clipboard = $false
    if ($Row.PSObject.Properties.Name -contains 'ContainsSetClipboard') { $clipboard = Bool-FromCsv $Row.ContainsSetClipboard }

    if ($move -or $remove -or $rename -or $start -or $invoke) { return 'BLOCKED_HIGH_RISK_STATIC_MARKER_REVIEW_REQUIRED' }
    if ($copy -and $git) { return 'RISK_MARKED_COPY_AND_GIT_REVIEW_ONLY_NOT_CLEARED' }
    if ($copy) { return 'RISK_MARKED_COPY_REVIEW_ONLY_NOT_CLEARED' }
    if ($git) { return 'RISK_MARKED_GIT_REVIEW_ONLY_NOT_CLEARED' }
    if ($clipboard) { return 'RISK_MARKED_CLIPBOARD_REVIEW_ONLY_NOT_CLEARED' }
    return 'NO_COMMAND_RISK_MARKER_REVIEW_ONLY_NOT_CLEARED'
}

function Get-ReviewDecision {
    param($Row)
    $riskClass = Get-RiskClass -Row $Row
    if ($riskClass -like 'BLOCKED_*') { return 'BLOCKED_STATIC_MARKER_REVIEW_REQUIRED' }
    return 'EVIDENCE_ONLY_NOT_EXECUTION_NOT_ROUTE_NOT_CLEANUP'
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }

$hashChecks = @()
$hashChecks += Test-ExpectedFile -Name 'hsrb_004_selector_batch_csv_v0_1' -Path $Expected.SelectorBatchCsvPath -ExpectedSha256 $Expected.SelectorBatchCsvSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_004_selector_report_v0_1' -Path $Expected.SelectorReportPath -ExpectedSha256 $Expected.SelectorReportSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_004_selector_receipt_v0_1' -Path $Expected.SelectorReceiptPath -ExpectedSha256 $Expected.SelectorReceiptSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_closeout' -Path $Expected.Hsrb003CloseoutPath -ExpectedSha256 $Expected.Hsrb003CloseoutSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_closeout_receipt' -Path $Expected.Hsrb003CloseoutReceiptPath -ExpectedSha256 $Expected.Hsrb003CloseoutReceiptSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_004_summary_csv_v0_1' -Path $Expected.SummaryCsvPath -ExpectedSha256 $Expected.SummaryCsvSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_004_static_packet_md_v0_1' -Path $Expected.PacketMdPath -ExpectedSha256 $Expected.PacketMdSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_004_static_packet_print_v0_1' -Path $Expected.PacketPrintPath -ExpectedSha256 $Expected.PacketPrintSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_004_static_packet_receipt_v0_1' -Path $Expected.PacketReceiptPath -ExpectedSha256 $Expected.PacketReceiptSha256

$blockers = @()
foreach ($h in $hashChecks) {
    if (-not $h.Exists) { $blockers += ('MISSING_INPUT_{0}: {1}' -f $h.Name, $h.Path) }
    elseif (-not $h.HashMatch) { $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256) }
}

$summaryRows = @()
if ($blockers.Count -eq 0) { $summaryRows = @(Import-Csv -LiteralPath $Expected.SummaryCsvPath) }
$summaryRowCount = Count-Items $summaryRows

$requiredColumns = @(
    'BatchID','TicketID','FileName','SourcePath','SourceExists','DeclaredSha256','SourceSha256','DeclaredShaMatchesActual','TextReadOk','KnownOutcome','StaticDisposition',
    'ContainsMoveItem','ContainsRemoveItem','ContainsRenameItem','ContainsCopyItem','ContainsStartProcess','ContainsInvokeExpression','ContainsGitCommand','ActionNow'
)
if ($summaryRowCount -gt 0) {
    $props = @($summaryRows[0].PSObject.Properties.Name)
    foreach ($col in $requiredColumns) {
        if ($props -notcontains $col) { $blockers += ('REQUIRED_SUMMARY_COLUMN_MISSING_{0}' -f $col) }
    }
} elseif ($blockers.Count -eq 0) {
    $blockers += 'SUMMARY_CSV_HAS_ZERO_ROWS'
}

$blankTicketIdCount = 0
$missingFileNameCount = 0
$missingDeclaredSha256Count = 0
$missingActualSha256Count = 0
$sourceHashMismatchCount = 0
$sourceMissingCount = 0
$textReadFailCount = 0
$unknownStaticDispositionCount = 0
$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsCopyItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
$containsGitCommandCount = 0
$containsSetClipboardCount = 0
$highRiskCommandMarkerRowCount = 0
$riskMarkedRowCount = 0
$unclassifiedRiskMarkerCount = 0
$executionClearanceCount = 0
$routeClearanceCount = 0
$cleanupClearanceCount = 0
$doctrinePromotionCount = 0
$actionNowNonNoCount = 0

$knownDispositions = @(
    'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_REVIEW_ONLY',
    'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_REVIEW_ONLY',
    'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY_REVIEW_ONLY'
)

$riskRows = @()
if ($blockers.Count -eq 0) {
    $blankTicketIdCount = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.TicketID) }
    $missingFileNameCount = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.FileName) }
    $missingDeclaredSha256Count = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.DeclaredSha256) }
    $missingActualSha256Count = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.SourceSha256) }
    $sourceHashMismatchCount = Count-Where -Rows $summaryRows -Predicate { -not (Bool-FromCsv $_.DeclaredShaMatchesActual) }
    $sourceMissingCount = Count-Where -Rows $summaryRows -Predicate { -not (Bool-FromCsv $_.SourceExists) }
    $textReadFailCount = Count-Where -Rows $summaryRows -Predicate { -not (Bool-FromCsv $_.TextReadOk) }
    $unknownStaticDispositionCount = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.StaticDisposition) -or ($knownDispositions -notcontains $_.StaticDisposition) }
    $containsMoveItemCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsMoveItem }
    $containsRemoveItemCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsRemoveItem }
    $containsRenameItemCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsRenameItem }
    $containsCopyItemCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsCopyItem }
    $containsStartProcessCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsStartProcess }
    $containsInvokeExpressionCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsInvokeExpression }
    $containsGitCommandCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsGitCommand }
    if ($summaryRows[0].PSObject.Properties.Name -contains 'ContainsSetClipboard') {
        $containsSetClipboardCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsSetClipboard }
    }
    $highRiskCommandMarkerRowCount = Count-Where -Rows $summaryRows -Predicate { (Bool-FromCsv $_.ContainsMoveItem) -or (Bool-FromCsv $_.ContainsRemoveItem) -or (Bool-FromCsv $_.ContainsRenameItem) -or (Bool-FromCsv $_.ContainsStartProcess) -or (Bool-FromCsv $_.ContainsInvokeExpression) }
    $riskMarkedRowCount = Count-Where -Rows $summaryRows -Predicate { (Bool-FromCsv $_.ContainsCopyItem) -or (Bool-FromCsv $_.ContainsGitCommand) -or ((($_.PSObject.Properties.Name -contains 'ContainsSetClipboard') -and (Bool-FromCsv $_.ContainsSetClipboard))) }
    $actionNowNonNoCount = Count-Where -Rows $summaryRows -Predicate { ([string]$_.ActionNow) -notmatch '^(NO|NO_EXECUTION_NO_ROUTE_NO_CLEANUP)$' }

    foreach ($row in $summaryRows) {
        $riskClass = Get-RiskClass -Row $row
        $decision = Get-ReviewDecision -Row $row
        if ([string]::IsNullOrWhiteSpace($riskClass)) { $unclassifiedRiskMarkerCount++ }
        $riskRows += [pscustomobject]@{
            BatchID = [string]$row.BatchID
            TicketID = [string]$row.TicketID
            FileName = [string]$row.FileName
            StaticDisposition = [string]$row.StaticDisposition
            ContainsCopyItem = [string]$row.ContainsCopyItem
            ContainsGitCommand = [string]$row.ContainsGitCommand
            ContainsMoveItem = [string]$row.ContainsMoveItem
            ContainsRemoveItem = [string]$row.ContainsRemoveItem
            ContainsRenameItem = [string]$row.ContainsRenameItem
            ContainsStartProcess = [string]$row.ContainsStartProcess
            ContainsInvokeExpression = [string]$row.ContainsInvokeExpression
            ContainsSetClipboard = if ($row.PSObject.Properties.Name -contains 'ContainsSetClipboard') { [string]$row.ContainsSetClipboard } else { 'False' }
            RiskClass = [string]$riskClass
            ReviewDecision = [string]$decision
            ExecutionCleared = 'False'
            RouteCleared = 'False'
            CleanupCleared = 'False'
            DoctrinePromotion = 'False'
            ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
            DeclaredSha256 = [string]$row.DeclaredSha256
            ActualSha256 = [string]$row.SourceSha256
            HashMatch = [string]$row.DeclaredShaMatchesActual
        }
    }
}

$selectedBatchId = 'HSRB-004'
$selectedBatchRows = $summaryRowCount

if ($blankTicketIdCount -gt 0) { $blockers += ('BLANK_TICKET_ID_COUNT_{0}' -f $blankTicketIdCount) }
if ($missingFileNameCount -gt 0) { $blockers += ('MISSING_FILENAME_COUNT_{0}' -f $missingFileNameCount) }
if ($missingDeclaredSha256Count -gt 0) { $blockers += ('MISSING_DECLARED_SHA256_COUNT_{0}' -f $missingDeclaredSha256Count) }
if ($missingActualSha256Count -gt 0) { $blockers += ('MISSING_ACTUAL_SHA256_COUNT_{0}' -f $missingActualSha256Count) }
if ($sourceHashMismatchCount -gt 0) { $blockers += ('SOURCE_HASH_MISMATCH_COUNT_{0}' -f $sourceHashMismatchCount) }
if ($sourceMissingCount -gt 0) { $blockers += ('SOURCE_MISSING_COUNT_{0}' -f $sourceMissingCount) }
if ($textReadFailCount -gt 0) { $blockers += ('TEXT_READ_FAIL_COUNT_{0}' -f $textReadFailCount) }
if ($unknownStaticDispositionCount -gt 0) { $blockers += ('UNKNOWN_STATIC_DISPOSITION_COUNT_{0}' -f $unknownStaticDispositionCount) }
if ($highRiskCommandMarkerRowCount -gt 0) { $blockers += ('HIGH_RISK_COMMAND_MARKER_ROW_COUNT_{0}' -f $highRiskCommandMarkerRowCount) }
if ($unclassifiedRiskMarkerCount -gt 0) { $blockers += ('UNCLASSIFIED_RISK_MARKER_COUNT_{0}' -f $unclassifiedRiskMarkerCount) }
if ($executionClearanceCount -gt 0) { $blockers += ('EXECUTION_CLEARANCE_COUNT_{0}' -f $executionClearanceCount) }
if ($routeClearanceCount -gt 0) { $blockers += ('ROUTE_CLEARANCE_COUNT_{0}' -f $routeClearanceCount) }
if ($cleanupClearanceCount -gt 0) { $blockers += ('CLEANUP_CLEARANCE_COUNT_{0}' -f $cleanupClearanceCount) }
if ($doctrinePromotionCount -gt 0) { $blockers += ('DOCTRINE_PROMOTION_COUNT_{0}' -f $doctrinePromotionCount) }
if ($actionNowNonNoCount -gt 0) { $blockers += ('ACTION_NOW_NON_NO_COUNT_{0}' -f $actionNowNonNoCount) }
if ($PhysicalMoves -ne 0 -or $PhysicalDeletes -ne 0 -or $PhysicalRenames -ne 0 -or $PhysicalRoutes -ne 0 -or $PhysicalExecutes -ne 0 -or $PhysicalCommits -ne 0 -or $PhysicalPushes -ne 0) { $blockers += 'PHYSICAL_ACTION_COUNT_NOT_ZERO' }

$contractGatePassed = ($blockers.Count -eq 0)

if ($riskRows.Count -gt 0) {
    $riskRows | Export-Csv -LiteralPath $OutRiskCsvPath -NoTypeInformation -Encoding UTF8
} else {
    [System.IO.File]::WriteAllText($OutRiskCsvPath, '', [System.Text.UTF8Encoding]::new($false))
}

$outRiskCsvSha = Get-Sha256Safe -Path $OutRiskCsvPath

$md = @()
$md += '# HSRB-004 Static Review Decision Closeout - Contract First - No Execution - V0.1'
$md += ''
$md += 'Status: CONTRACT_FIRST_CLOSEOUT / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += ''
$md += 'Close out the HSRB-004 helper file surface preflight and planetary gate selector chain static packet under the helper-output custody contract. This classifies git command markers as review-only evidence and does not approve execution, routing, cleanup, doctrine promotion, commit, or push.'
$md += ''
$md += '## Verified inputs'
$md += ''
$md += '| Input | Exists | HashMatch | SHA256 |'
$md += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) {
    $md += ('| {0} | {1} | {2} | `{3}` |' -f (Escape-MdCell $h.Name), $h.Exists, $h.HashMatch, $h.ActualSha256)
}
$md += ''
$md += '## Contract counts'
$md += ''
$md += ('- contract_gate_passed: {0}' -f $contractGatePassed)
$md += ('- selected_batch_id: {0}' -f $selectedBatchId)
$md += ('- selected_batch_rows: {0}' -f $selectedBatchRows)
$md += ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$md += ('- missing_filename_count: {0}' -f $missingFileNameCount)
$md += ('- missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
$md += ('- missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
$md += ('- source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
$md += ('- source_missing_count: {0}' -f $sourceMissingCount)
$md += ('- text_read_fail_count: {0}' -f $textReadFailCount)
$md += ('- unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
$md += ('- contains_copy_item_count: {0}' -f $containsCopyItemCount)
$md += ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
$md += ('- contains_move_item_count: {0}' -f $containsMoveItemCount)
$md += ('- contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$md += ('- contains_rename_item_count: {0}' -f $containsRenameItemCount)
$md += ('- contains_start_process_count: {0}' -f $containsStartProcessCount)
$md += ('- contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$md += ('- contains_set_clipboard_count: {0}' -f $containsSetClipboardCount)
$md += ('- high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
$md += ('- risk_marked_row_count: {0}' -f $riskMarkedRowCount)
$md += ('- unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
$md += ('- execution_clearance_count: {0}' -f $executionClearanceCount)
$md += ('- route_clearance_count: {0}' -f $routeClearanceCount)
$md += ('- cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
$md += ('- doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
$md += ('- action_now_non_no_count: {0}' -f $actionNowNonNoCount)
$md += ('- blocker_count: {0}' -f $blockers.Count)
$md += ''
$md += '## Disposition summary'
$md += ''
$md += '| Bucket | Count |'
$md += '| --- | ---: |'
$md += ('| HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_REVIEW_ONLY | {0} |' -f (Count-Where -Rows $summaryRows -Predicate { $_.StaticDisposition -eq 'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_REVIEW_ONLY' }))
$md += ('| PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_REVIEW_ONLY | {0} |' -f (Count-Where -Rows $summaryRows -Predicate { $_.StaticDisposition -eq 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_REVIEW_ONLY' }))
$md += ('| PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY_REVIEW_ONLY | {0} |' -f (Count-Where -Rows $summaryRows -Predicate { $_.StaticDisposition -eq 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY_REVIEW_ONLY' }))
$md += ''
$md += '## Risk marker index'
$md += ''
$md += '| TicketID | FileName | StaticDisposition | RiskClass | ReviewDecision | Git | Copy | ActionNow |'
$md += '| --- | --- | --- | --- | --- | ---: | ---: | --- |'
foreach ($r in $riskRows) {
    $md += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | {6} | {7} |' -f (Escape-MdCell $r.TicketID), (Escape-MdCell $r.FileName), (Escape-MdCell $r.StaticDisposition), (Escape-MdCell $r.RiskClass), (Escape-MdCell $r.ReviewDecision), $r.ContainsGitCommand, $r.ContainsCopyItem, (Escape-MdCell $r.ActionNow))
}
$md += ''
$md += '## Interpretation'
$md += ''
$md += '- The HSRB-004 files remain review-only evidence.'
$md += '- Git command markers are preserved as static review evidence, not execution clearance.'
$md += '- No file in this batch is cleared for execution, routing, cleanup, doctrine promotion, commit, or push.'
$md += '- This closeout only closes the static decision step for HSRB-004 under the helper-output contract.'
$md += ''
$md += '## Blockers'
$md += ''
if ($blockers.Count -eq 0) { $md += 'None.' } else { foreach ($b in $blockers) { $md += ('- {0}' -f $b) } }
$md += ''
$md += '## Next single action'
$nextAction = if ($contractGatePassed) { 'BUILD_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_BLOCKERS_NO_EXECUTION' }
$md += $nextAction
$md += ''
$md += ('Final verdict: {0}' -f ($(if ($contractGatePassed) { 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_CONTRACT_FIRST_WRITTEN_WITH_REVIEW_ONLY_GIT_MARKERS_NO_PHYSICAL_ACTION' } else { 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' })))
$md += ''
$md += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)

Write-LinesNoBom -Path $OutCloseoutPath -Lines $md
Write-LinesNoBom -Path $OutCloseoutPrintPath -Lines $md

$outCloseoutSha = Get-Sha256Safe -Path $OutCloseoutPath
$outCloseoutPrintSha = Get-Sha256Safe -Path $OutCloseoutPrintPath

$receipt = @()
$receipt += 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RECEIPT_V0_1_20260609'
$receipt += ('output_risk_csv_path: {0}' -f $OutRiskCsvPath)
$receipt += ('output_risk_csv_sha256: {0}' -f $outRiskCsvSha)
$receipt += ('output_closeout_path: {0}' -f $OutCloseoutPath)
$receipt += ('output_closeout_sha256: {0}' -f $outCloseoutSha)
$receipt += ('output_closeout_print_path: {0}' -f $OutCloseoutPrintPath)
$receipt += ('output_closeout_print_sha256: {0}' -f $outCloseoutPrintSha)
$receipt += ('contract_gate_passed: {0}' -f $contractGatePassed)
$receipt += ('selected_batch_id: {0}' -f $selectedBatchId)
$receipt += ('selected_batch_rows: {0}' -f $selectedBatchRows)
$receipt += ('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$receipt += ('missing_filename_count: {0}' -f $missingFileNameCount)
$receipt += ('missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
$receipt += ('missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
$receipt += ('source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
$receipt += ('source_missing_count: {0}' -f $sourceMissingCount)
$receipt += ('text_read_fail_count: {0}' -f $textReadFailCount)
$receipt += ('unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
$receipt += ('contains_copy_item_count: {0}' -f $containsCopyItemCount)
$receipt += ('contains_git_command_count: {0}' -f $containsGitCommandCount)
$receipt += ('contains_move_item_count: {0}' -f $containsMoveItemCount)
$receipt += ('contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$receipt += ('contains_rename_item_count: {0}' -f $containsRenameItemCount)
$receipt += ('contains_start_process_count: {0}' -f $containsStartProcessCount)
$receipt += ('contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$receipt += ('contains_set_clipboard_count: {0}' -f $containsSetClipboardCount)
$receipt += ('high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
$receipt += ('risk_marked_row_count: {0}' -f $riskMarkedRowCount)
$receipt += ('unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
$receipt += ('execution_clearance_count: {0}' -f $executionClearanceCount)
$receipt += ('route_clearance_count: {0}' -f $routeClearanceCount)
$receipt += ('cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
$receipt += ('doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
$receipt += ('action_now_non_no_count: {0}' -f $actionNowNonNoCount)
$receipt += ('blocker_count: {0}' -f $blockers.Count)
$receipt += ('next_single_action: {0}' -f $nextAction)
$receipt += ('final_verdict: {0}' -f ($(if ($contractGatePassed) { 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_CONTRACT_FIRST_WRITTEN_WITH_REVIEW_ONLY_GIT_MARKERS_NO_PHYSICAL_ACTION' } else { 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' })))
$receipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)

Write-LinesNoBom -Path $OutReceiptPath -Lines $receipt
$outReceiptSha = Get-Sha256Safe -Path $OutReceiptPath

'=== HSRB-004 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.1 COMPLETE ==='
('output_risk_csv_path: {0}' -f $OutRiskCsvPath)
('output_risk_csv_sha256: {0}' -f $outRiskCsvSha)
('output_closeout_path: {0}' -f $OutCloseoutPath)
('output_closeout_sha256: {0}' -f $outCloseoutSha)
('output_closeout_print_path: {0}' -f $OutCloseoutPrintPath)
('output_closeout_print_sha256: {0}' -f $outCloseoutPrintSha)
('output_receipt_path: {0}' -f $OutReceiptPath)
('output_receipt_sha256: {0}' -f $outReceiptSha)
('contract_gate_passed: {0}' -f $contractGatePassed)
('selected_batch_id: {0}' -f $selectedBatchId)
('selected_batch_rows: {0}' -f $selectedBatchRows)
('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
('missing_filename_count: {0}' -f $missingFileNameCount)
('missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
('missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
('source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
('source_missing_count: {0}' -f $sourceMissingCount)
('text_read_fail_count: {0}' -f $textReadFailCount)
('unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
('contains_copy_item_count: {0}' -f $containsCopyItemCount)
('contains_git_command_count: {0}' -f $containsGitCommandCount)
('contains_move_item_count: {0}' -f $containsMoveItemCount)
('contains_remove_item_count: {0}' -f $containsRemoveItemCount)
('contains_rename_item_count: {0}' -f $containsRenameItemCount)
('contains_start_process_count: {0}' -f $containsStartProcessCount)
('contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
('contains_set_clipboard_count: {0}' -f $containsSetClipboardCount)
('high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
('risk_marked_row_count: {0}' -f $riskMarkedRowCount)
('unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
('execution_clearance_count: {0}' -f $executionClearanceCount)
('route_clearance_count: {0}' -f $routeClearanceCount)
('cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
('doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
('action_now_non_no_count: {0}' -f $actionNowNonNoCount)
('blocker_count: {0}' -f $blockers.Count)
('next_single_action: {0}' -f $nextAction)
('final_verdict: {0}' -f ($(if ($contractGatePassed) { 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_CONTRACT_FIRST_WRITTEN_WITH_REVIEW_ONLY_GIT_MARKERS_NO_PHYSICAL_ACTION' } else { 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' })))
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
