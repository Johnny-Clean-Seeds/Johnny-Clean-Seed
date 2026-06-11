# BUILD_HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_20260609_V0_2.ps1
# Purpose: contract-first closeout for HSRB-003 static packet. Classifies copy/git risk markers as REVIEW_ONLY evidence; does not execute, move, delete, rename, route, clean, commit, or push.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$Expected = [ordered]@{
    SelectorBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_003_V0_2_20260609.csv'
    SelectorBatchCsvSha256 = '46453987B9A3E61AD054AB9063BB3C5EBBA5749996C1935EF9DB909D61632BE5'
    SelectorReportPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
    SelectorReportSha256 = '50BEB51F64B5C4180890EBF87AAF0AFB089A341C6C4EEC8FCF2E06DC1A357343'
    SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
    SelectorReceiptSha256 = 'B26C9C1D86413BCA12D6A71950CD1ACF428D8E96F139EBF5F96C0340831DB2E1'
    SelectorEvidencePath = Join-Path $Lane 'HELPER_GENERATION_EVIDENCE__BATCH_SELECTORS_MUST_VALIDATE_TICKET_ID_AND_SHA_TOGETHER_20260609.md'
    SelectorEvidenceSha256 = '6BD3DBA31BC5386DC4E60BA5FA6FA4B206975469BC331CC4233DEE5872ABC798'
    Hsrb002ContractEvidencePath = Join-Path $Lane 'HELPER_GENERATION_EVIDENCE__DERIVED_INDEXES_MUST_VALIDATE_TICKET_ID_ROLE_COUNTS_AND_SHA_TOGETHER_20260609.md'
    Hsrb002ContractEvidenceSha256 = '32D8D09C1C9043785F8A5D3FE4355533A9B7DFF868B4E8D7E5845E7DAE592FC8'
    PacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_V0_1_20260609.md'
    PacketMdSha256 = 'CDDAD451AE35644EBA42694119F96E8AB348B14E245CFA4EA58FCD9DDDC1B4FF'
    SummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_SUMMARY_V0_1_20260609.csv'
    SummaryCsvSha256 = 'BDA4237D9453936BDEE9C43D270B6E82B9CC3255A34A05DD210CEAE6EB4F59BF'
    PacketPrintPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_COPY_PRINT_V0_1_20260609.txt'
    PacketPrintSha256 = 'CDDAD451AE35644EBA42694119F96E8AB348B14E245CFA4EA58FCD9DDDC1B4FF'
    PacketReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_RECEIPT_V0_1_20260609.txt'
    PacketReceiptSha256 = '1925821AEBE747D1797E4EE8544338104B8ABD301DC12F6540734A5DA42D6544'
}

$OutRiskCsvPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_2_20260609.csv'
$OutCloseoutPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_2_20260609.md'
$OutCloseoutPrintPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$OutReceiptPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

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

function Count-Items {
    param([AllowNull()]$Value)
    return [int](@($Value).Count)
}

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
    $stringLines = foreach ($line in @($Lines)) {
        if ($null -eq $line) { '' } else { [string]$line }
    }
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

    if ($move -or $remove -or $rename -or $start -or $invoke) { return 'BLOCKED_HIGH_RISK_STATIC_MARKER_REVIEW_REQUIRED' }
    if ($copy -and $git) { return 'RISK_MARKED_COPY_AND_GIT_REVIEW_ONLY_NOT_CLEARED' }
    if ($copy) { return 'RISK_MARKED_COPY_REVIEW_ONLY_NOT_CLEARED' }
    if ($git) { return 'RISK_MARKED_GIT_REVIEW_ONLY_NOT_CLEARED' }
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
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_selector_batch_csv_v0_2' -Path $Expected.SelectorBatchCsvPath -ExpectedSha256 $Expected.SelectorBatchCsvSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_selector_report_v0_2' -Path $Expected.SelectorReportPath -ExpectedSha256 $Expected.SelectorReportSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_selector_receipt_v0_2' -Path $Expected.SelectorReceiptPath -ExpectedSha256 $Expected.SelectorReceiptSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_selector_contract_evidence' -Path $Expected.SelectorEvidencePath -ExpectedSha256 $Expected.SelectorEvidenceSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_002_contract_evidence' -Path $Expected.Hsrb002ContractEvidencePath -ExpectedSha256 $Expected.Hsrb002ContractEvidenceSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_static_packet_md_v0_1' -Path $Expected.PacketMdPath -ExpectedSha256 $Expected.PacketMdSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_summary_csv_v0_1' -Path $Expected.SummaryCsvPath -ExpectedSha256 $Expected.SummaryCsvSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_static_packet_print_v0_1' -Path $Expected.PacketPrintPath -ExpectedSha256 $Expected.PacketPrintSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_static_packet_receipt_v0_1' -Path $Expected.PacketReceiptPath -ExpectedSha256 $Expected.PacketReceiptSha256

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
$highRiskCommandMarkerRowCount = 0
$riskMarkedRowCount = 0
$unclassifiedRiskMarkerCount = 0
$executionClearanceCount = 0
$routeClearanceCount = 0
$cleanupClearanceCount = 0
$doctrinePromotionCount = 0

$knownDispositions = @(
    'HELPER_CANDIDATE_OPTION_SET_REVIEW_ONLY',
    'OLD_LOAD_OR_SYSTEM_OPTION_SET_REVIEW_ONLY',
    'QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_REVIEW_ONLY',
    'REVIEW_QUEUE_FAMILY_REVIEW_ONLY',
    'SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_REVIEW_ONLY',
    'SUPPORT_CANDIDATE_OPTION_SET_REVIEW_ONLY',
    'SUPPORT_CARD_SCHEMA_AND_DRY_RUN_REVIEW_ONLY'
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
    $highRiskCommandMarkerRowCount = Count-Where -Rows $summaryRows -Predicate { (Bool-FromCsv $_.ContainsMoveItem) -or (Bool-FromCsv $_.ContainsRemoveItem) -or (Bool-FromCsv $_.ContainsRenameItem) -or (Bool-FromCsv $_.ContainsStartProcess) -or (Bool-FromCsv $_.ContainsInvokeExpression) }
    $riskMarkedRowCount = Count-Where -Rows $summaryRows -Predicate { (Bool-FromCsv $_.ContainsCopyItem) -or (Bool-FromCsv $_.ContainsGitCommand) }

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
            RiskClass = [string]$riskClass
            ReviewDecision = [string]$decision
            ExecutionCleared = 'False'
            RouteCleared = 'False'
            CleanupCleared = 'False'
            DoctrinePromotionCleared = 'False'
            ActionNow = 'NO'
        }
    }
}

if ($summaryRowCount -ne 9) { $blockers += ('SUMMARY_ROW_COUNT_NOT_9_ACTUAL_{0}' -f $summaryRowCount) }
if ($blockers.Count -eq 0 -and $blankTicketIdCount -ne 0) { $blockers += ('BLANK_TICKET_ID_COUNT_NOT_0_ACTUAL_{0}' -f $blankTicketIdCount) }
if ($blockers.Count -eq 0 -and $missingFileNameCount -ne 0) { $blockers += ('MISSING_FILENAME_COUNT_NOT_0_ACTUAL_{0}' -f $missingFileNameCount) }
if ($blockers.Count -eq 0 -and $missingDeclaredSha256Count -ne 0) { $blockers += ('MISSING_DECLARED_SHA256_COUNT_NOT_0_ACTUAL_{0}' -f $missingDeclaredSha256Count) }
if ($blockers.Count -eq 0 -and $missingActualSha256Count -ne 0) { $blockers += ('MISSING_ACTUAL_SHA256_COUNT_NOT_0_ACTUAL_{0}' -f $missingActualSha256Count) }
if ($blockers.Count -eq 0 -and $sourceHashMismatchCount -ne 0) { $blockers += ('SOURCE_HASH_MISMATCH_COUNT_NOT_0_ACTUAL_{0}' -f $sourceHashMismatchCount) }
if ($blockers.Count -eq 0 -and $sourceMissingCount -ne 0) { $blockers += ('SOURCE_MISSING_COUNT_NOT_0_ACTUAL_{0}' -f $sourceMissingCount) }
if ($blockers.Count -eq 0 -and $textReadFailCount -ne 0) { $blockers += ('TEXT_READ_FAIL_COUNT_NOT_0_ACTUAL_{0}' -f $textReadFailCount) }
if ($blockers.Count -eq 0 -and $unknownStaticDispositionCount -ne 0) { $blockers += ('UNKNOWN_STATIC_DISPOSITION_COUNT_NOT_0_ACTUAL_{0}' -f $unknownStaticDispositionCount) }
if ($blockers.Count -eq 0 -and $highRiskCommandMarkerRowCount -ne 0) { $blockers += ('HIGH_RISK_COMMAND_MARKER_ROW_COUNT_NOT_0_ACTUAL_{0}' -f $highRiskCommandMarkerRowCount) }
if ($blockers.Count -eq 0 -and $containsCopyItemCount -ne 1) { $blockers += ('COPY_ITEM_COUNT_NOT_EXPECTED_1_ACTUAL_{0}' -f $containsCopyItemCount) }
if ($blockers.Count -eq 0 -and $containsGitCommandCount -ne 9) { $blockers += ('GIT_COMMAND_COUNT_NOT_EXPECTED_9_ACTUAL_{0}' -f $containsGitCommandCount) }
if ($blockers.Count -eq 0 -and $unclassifiedRiskMarkerCount -ne 0) { $blockers += ('UNCLASSIFIED_RISK_MARKER_COUNT_NOT_0_ACTUAL_{0}' -f $unclassifiedRiskMarkerCount) }

$blockerCount = [int]$blockers.Count
$contractGatePassed = ($blockerCount -eq 0)
if ($contractGatePassed) {
    $nextSingleAction = 'BUILD_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION'
    $finalVerdict = 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_CONTRACT_FIRST_WRITTEN_WITH_RISK_MARKERS_CLASSIFIED_AS_REVIEW_ONLY_NO_PHYSICAL_ACTION'
} else {
    $nextSingleAction = 'STOP_AND_REVIEW_HSRB_003_CONTRACT_FIRST_DECISION_CLOSEOUT_BLOCKERS_NO_EXECUTION'
    $finalVerdict = 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_CONTRACT_FIRST_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

if ($contractGatePassed) { $riskRows | Export-Csv -LiteralPath $OutRiskCsvPath -NoTypeInformation -Encoding UTF8 }
$riskCsvSha = Get-Sha256Safe -Path $OutRiskCsvPath

$lines = @()
$lines += '# HSRB-003 Static Review Decision Closeout - Contract First - V0.2'
$lines += ''
$lines += 'Status: CONTRACT_FIRST_REVIEW_CLOSEOUT / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$lines += ''
$lines += '## Purpose'
$lines += ''
$lines += 'Apply the helper-output contract to the HSRB-003 static review packet before any index or later decision work. This closeout classifies copy/git static markers as review evidence only. It does not clear any selected helper file for execution or routing.'
$lines += ''
$lines += '## Boundary'
$lines += ''
$lines += 'This closeout does not execute selected helper scripts. It does not move, delete, rename, copy, route, clean, commit, push, or promote doctrine. Report generation is proof organization only.'
$lines += ''
$lines += '## Verified parent inputs'
$lines += ''
$lines += '| Input | Exists | HashMatch | SHA256 |'
$lines += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) { $lines += ('| {0} | {1} | {2} | `{3}` |' -f (Escape-MdCell $h.Name), $h.Exists, $h.HashMatch, $h.ActualSha256) }
$lines += ''
$lines += '## Contract gate'
$lines += ''
$lines += ('- contract_gate_passed: {0}' -f $contractGatePassed)
$lines += ('- blocker_count: {0}' -f $blockerCount)
$lines += ('- final_verdict_dominated_by_blocker_count: True')
$lines += ''
$lines += '## Custody counts'
$lines += ''
$lines += '- selected_batch_id: HSRB-003'
$lines += ('- selected_batch_rows: {0}' -f $summaryRowCount)
$lines += ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$lines += ('- missing_filename_count: {0}' -f $missingFileNameCount)
$lines += ('- missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
$lines += ('- missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
$lines += ('- source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
$lines += ('- source_missing_count: {0}' -f $sourceMissingCount)
$lines += ('- text_read_fail_count: {0}' -f $textReadFailCount)
$lines += ('- unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
$lines += ''
$lines += '## Risk marker classification'
$lines += ''
$lines += ('- contains_copy_item_count: {0}' -f $containsCopyItemCount)
$lines += ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
$lines += ('- contains_move_item_count: {0}' -f $containsMoveItemCount)
$lines += ('- contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$lines += ('- contains_rename_item_count: {0}' -f $containsRenameItemCount)
$lines += ('- contains_start_process_count: {0}' -f $containsStartProcessCount)
$lines += ('- contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$lines += ('- high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
$lines += ('- risk_marked_row_count: {0}' -f $riskMarkedRowCount)
$lines += ('- unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
$lines += ''
$lines += '## Clearance counts'
$lines += ''
$lines += ('- execution_clearance_count: {0}' -f $executionClearanceCount)
$lines += ('- route_clearance_count: {0}' -f $routeClearanceCount)
$lines += ('- cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
$lines += ('- doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
$lines += ''
$lines += '## Risk marker table'
$lines += ''
$lines += '| TicketID | FileName | StaticDisposition | Copy | Git | RiskClass | ReviewDecision |'
$lines += '| --- | --- | --- | ---: | ---: | --- | --- |'
foreach ($r in $riskRows) {
    $lines += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | {6} |' -f (Escape-MdCell $r.TicketID), (Escape-MdCell $r.FileName), (Escape-MdCell $r.StaticDisposition), $r.ContainsCopyItem, $r.ContainsGitCommand, (Escape-MdCell $r.RiskClass), (Escape-MdCell $r.ReviewDecision))
}
$lines += ''
$lines += '## Decision'
$lines += ''
$lines += '- HSRB-003 static packet generation is accepted as custody evidence only.'
$lines += '- HSRB-003 selected helper files are not cleared for execution.'
$lines += '- HSRB-003 selected helper files are not route authority, cleanup authority, commit authority, push authority, or doctrine authority.'
$lines += '- CopyItem and GitCommand markers are classified as review-only risk evidence, not as approval to run the files.'
$lines += '- The next object must index risk/disposition. It must not execute helpers or route files.'
$lines += ''
$lines += '## Blockers'
$lines += ''
$lines += ('- blocker_count: {0}' -f $blockerCount)
if ($blockerCount -eq 0) { $lines += '- none' } else { foreach ($b in $blockers) { $lines += ('- {0}' -f $b) } }
$lines += ''
$lines += '## Next single action'
$lines += ''
$lines += $nextSingleAction
$lines += ''
$lines += '## Final verdict'
$lines += ''
$lines += $finalVerdict
$lines += ''
$lines += '## Physical actions'
$lines += ''
$lines += 'move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

Write-LinesNoBom -Path $OutCloseoutPath -Lines $lines
$closeoutSha = Get-Sha256Safe -Path $OutCloseoutPath
Write-LinesNoBom -Path $OutCloseoutPrintPath -Lines $lines
$closeoutPrintSha = Get-Sha256Safe -Path $OutCloseoutPrintPath

$receiptLines = @()
$receiptLines += 'HSRB-003 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST RECEIPT V0.2'
$receiptLines += ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
$receiptLines += ('output_risk_csv_path: {0}' -f $OutRiskCsvPath)
$receiptLines += ('output_risk_csv_sha256: {0}' -f $riskCsvSha)
$receiptLines += ('output_closeout_path: {0}' -f $OutCloseoutPath)
$receiptLines += ('output_closeout_sha256: {0}' -f $closeoutSha)
$receiptLines += ('output_closeout_print_path: {0}' -f $OutCloseoutPrintPath)
$receiptLines += ('output_closeout_print_sha256: {0}' -f $closeoutPrintSha)
$receiptLines += ('contract_gate_passed: {0}' -f $contractGatePassed)
$receiptLines += ('selected_batch_id: HSRB-003')
$receiptLines += ('selected_batch_rows: {0}' -f $summaryRowCount)
$receiptLines += ('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$receiptLines += ('missing_filename_count: {0}' -f $missingFileNameCount)
$receiptLines += ('missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
$receiptLines += ('missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
$receiptLines += ('source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
$receiptLines += ('source_missing_count: {0}' -f $sourceMissingCount)
$receiptLines += ('text_read_fail_count: {0}' -f $textReadFailCount)
$receiptLines += ('unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
$receiptLines += ('contains_copy_item_count: {0}' -f $containsCopyItemCount)
$receiptLines += ('contains_git_command_count: {0}' -f $containsGitCommandCount)
$receiptLines += ('contains_move_item_count: {0}' -f $containsMoveItemCount)
$receiptLines += ('contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$receiptLines += ('contains_rename_item_count: {0}' -f $containsRenameItemCount)
$receiptLines += ('contains_start_process_count: {0}' -f $containsStartProcessCount)
$receiptLines += ('contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$receiptLines += ('high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
$receiptLines += ('risk_marked_row_count: {0}' -f $riskMarkedRowCount)
$receiptLines += ('unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
$receiptLines += ('execution_clearance_count: {0}' -f $executionClearanceCount)
$receiptLines += ('route_clearance_count: {0}' -f $routeClearanceCount)
$receiptLines += ('cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
$receiptLines += ('doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
$receiptLines += ('blocker_count: {0}' -f $blockerCount)
$receiptLines += ('next_single_action: {0}' -f $nextSingleAction)
$receiptLines += ('final_verdict: {0}' -f $finalVerdict)
$receiptLines += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-LinesNoBom -Path $OutReceiptPath -Lines $receiptLines
$receiptSha = Get-Sha256Safe -Path $OutReceiptPath

'=== HSRB-003 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.2 COMPLETE ==='
"output_risk_csv_path: $OutRiskCsvPath"
"output_risk_csv_sha256: $riskCsvSha"
"output_closeout_path: $OutCloseoutPath"
"output_closeout_sha256: $closeoutSha"
"output_closeout_print_path: $OutCloseoutPrintPath"
"output_closeout_print_sha256: $closeoutPrintSha"
"output_receipt_path: $OutReceiptPath"
"output_receipt_sha256: $receiptSha"
("contract_gate_passed: {0}" -f $contractGatePassed)
'selected_batch_id: HSRB-003'
("selected_batch_rows: {0}" -f $summaryRowCount)
("blank_ticket_id_count: {0}" -f $blankTicketIdCount)
("missing_filename_count: {0}" -f $missingFileNameCount)
("missing_declared_sha256_count: {0}" -f $missingDeclaredSha256Count)
("missing_actual_sha256_count: {0}" -f $missingActualSha256Count)
("source_hash_mismatch_count: {0}" -f $sourceHashMismatchCount)
("source_missing_count: {0}" -f $sourceMissingCount)
("text_read_fail_count: {0}" -f $textReadFailCount)
("unknown_static_disposition_count: {0}" -f $unknownStaticDispositionCount)
("contains_copy_item_count: {0}" -f $containsCopyItemCount)
("contains_git_command_count: {0}" -f $containsGitCommandCount)
("contains_move_item_count: {0}" -f $containsMoveItemCount)
("contains_remove_item_count: {0}" -f $containsRemoveItemCount)
("contains_rename_item_count: {0}" -f $containsRenameItemCount)
("contains_start_process_count: {0}" -f $containsStartProcessCount)
("contains_invoke_expression_count: {0}" -f $containsInvokeExpressionCount)
("high_risk_command_marker_row_count: {0}" -f $highRiskCommandMarkerRowCount)
("risk_marked_row_count: {0}" -f $riskMarkedRowCount)
("unclassified_risk_marker_count: {0}" -f $unclassifiedRiskMarkerCount)
("execution_clearance_count: {0}" -f $executionClearanceCount)
("route_clearance_count: {0}" -f $routeClearanceCount)
("cleanup_clearance_count: {0}" -f $cleanupClearanceCount)
("doctrine_promotion_count: {0}" -f $doctrinePromotionCount)
("blocker_count: {0}" -f $blockerCount)
("next_single_action: {0}" -f $nextSingleAction)
("final_verdict: {0}" -f $finalVerdict)
("physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}" -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
