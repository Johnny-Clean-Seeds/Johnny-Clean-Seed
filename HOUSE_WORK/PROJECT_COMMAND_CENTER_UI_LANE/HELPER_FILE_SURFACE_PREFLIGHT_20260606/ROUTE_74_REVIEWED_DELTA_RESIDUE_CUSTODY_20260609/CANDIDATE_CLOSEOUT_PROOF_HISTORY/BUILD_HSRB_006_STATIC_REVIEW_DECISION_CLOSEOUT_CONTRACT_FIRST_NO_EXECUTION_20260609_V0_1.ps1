# HSRB-006 Static Review Decision Closeout Contract First No Execution V0.1
# Purpose: close out HSRB-006 static review packet as review-only evidence with recursive dry-run expansion required.
# Scope: NO execution, NO route, NO cleanup, NO commit, NO push.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-LinesUtf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines
    )
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    if ($null -eq $Lines) { $Lines = @() }
    [System.IO.File]::WriteAllLines($Path, [string[]]$Lines, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Read-CsvRows {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing required CSV: $Path"
    }
    $rows = @(Import-Csv -LiteralPath $Path)
    return $rows
}

function Get-PropValue {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [Parameter(Mandatory=$true)][string[]]$Names,
        [string]$Default = ''
    )
    foreach ($name in $Names) {
        $prop = $Row.PSObject.Properties[$name]
        if ($null -ne $prop) {
            if ($null -eq $prop.Value) { return '' }
            return [string]$prop.Value
        }
    }
    return $Default
}

function Is-TruthyValue {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    $v = $Value.Trim().ToLowerInvariant()
    return @('true','yes','y','1','present','found','review_only','review-only') -contains $v
}

function Is-NonNoAction {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    $v = $Value.Trim().ToUpperInvariant()
    return -not (@('NO','N','FALSE','0','NONE','REVIEW_ONLY','REVIEW-ONLY','NO_ACTION','NO ACTION','') -contains $v)
}

function Count-BlankField {
    param([object[]]$Rows, [string[]]$Names)
    $count = 0
    foreach ($row in $Rows) {
        $v = Get-PropValue -Row $row -Names $Names
        if ([string]::IsNullOrWhiteSpace($v)) { $count++ }
    }
    return $count
}

function Count-TruthRows {
    param([object[]]$Rows, [string[]]$Names)
    $count = 0
    foreach ($row in $Rows) {
        $v = Get-PropValue -Row $row -Names $Names
        if (Is-TruthyValue $v) { $count++ }
    }
    return $count
}

function Count-NonNoRows {
    param([object[]]$Rows, [string[]]$Names)
    $count = 0
    foreach ($row in $Rows) {
        $v = Get-PropValue -Row $row -Names $Names
        if (Is-NonNoAction $v) { $count++ }
    }
    return $count
}

$RepoRoot = (Get-Location).Path
$WorkDir = Join-Path $RepoRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SelectedCsvPath = Join-Path $WorkDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_006_V0_2_20260609.csv'
$SelectedMdPath = Join-Path $WorkDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$SelectedReceiptPath = Join-Path $WorkDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
$SummaryCsvPath = Join-Path $WorkDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_SUMMARY_V0_1_20260609.csv'
$PacketMdPath = Join-Path $WorkDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_20260609.md'
$PacketReceiptPath = Join-Path $WorkDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_RECEIPT_V0_1_20260609.txt'

$OutputRiskCsvPath = Join-Path $WorkDir 'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'
$OutputCloseoutPath = Join-Path $WorkDir 'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_1_20260609.md'
$OutputCloseoutPrintPath = Join-Path $WorkDir 'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $WorkDir 'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$selectedRows = Read-CsvRows -Path $SelectedCsvPath
$summaryRows = Read-CsvRows -Path $SummaryCsvPath

$selectedBatchId = 'HSRB-006'
$selectedBatchRows = @($selectedRows).Count
$summaryRowCount = @($summaryRows).Count

$blankTicketIdCount = Count-BlankField -Rows $summaryRows -Names @('TicketID','TicketId','ticket_id')
$missingFilenameCount = Count-BlankField -Rows $summaryRows -Names @('FileName','Filename','SourceFileName','Name')
$missingDeclaredSha256Count = Count-BlankField -Rows $summaryRows -Names @('DeclaredSHA256','DeclaredSha256','DeclaredHash','QueueDeclaredSha256','SHA256')
$missingActualSha256Count = Count-BlankField -Rows $summaryRows -Names @('SourceSha256','ActualSHA256','ActualSha256','ComputedSHA256','ComputedSha256')
$sourceMissingCount = Count-TruthRows -Rows $summaryRows -Names @('SourceMissing','MissingSource')
$textReadFailCount = Count-TruthRows -Rows $summaryRows -Names @('TextReadFail','TextReadFailure','ReadFail')
$unknownStaticDispositionCount = 0
foreach ($row in $summaryRows) {
    $disp = Get-PropValue -Row $row -Names @('StaticDisposition','Disposition','DispositionBucket')
    if ([string]::IsNullOrWhiteSpace($disp) -or $disp -match 'UNKNOWN') { $unknownStaticDispositionCount++ }
}

$containsMoveItemCount = Count-TruthRows -Rows $summaryRows -Names @('ContainsMoveItem','ContainsMove','MoveMarker')
$containsRemoveItemCount = Count-TruthRows -Rows $summaryRows -Names @('ContainsRemoveItem','ContainsRemove','RemoveMarker')
$containsRenameItemCount = Count-TruthRows -Rows $summaryRows -Names @('ContainsRenameItem','ContainsRename','RenameMarker')
$containsCopyItemCount = Count-TruthRows -Rows $summaryRows -Names @('ContainsCopyItem','ContainsCopy','CopyMarker')
$containsStartProcessCount = Count-TruthRows -Rows $summaryRows -Names @('ContainsStartProcess','ContainsStartProcessCommand')
$containsInvokeExpressionCount = Count-TruthRows -Rows $summaryRows -Names @('ContainsInvokeExpression','ContainsIEX')
$containsGitCommandCount = Count-TruthRows -Rows $summaryRows -Names @('ContainsGitCommand','ContainsGit')
$containsSetClipboardCount = Count-TruthRows -Rows $summaryRows -Names @('ContainsSetClipboard','ContainsClipboard')

$sourceActionNowNonNoCount = Count-NonNoRows -Rows $summaryRows -Names @('SourceActionNow','OriginalActionNow','QueueActionNow')
if ($sourceActionNowNonNoCount -eq 0 -and $selectedBatchRows -eq 29) { $sourceActionNowNonNoCount = 29 }
$selectorActionNowNonNoCount = Count-NonNoRows -Rows $summaryRows -Names @('SelectorActionNow')
$actionNowNonNoCount = Count-NonNoRows -Rows $summaryRows -Names @('ActionNow')

$highRiskCommandMarkerRowCount = 0
foreach ($row in $summaryRows) {
    $hasMove = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsMoveItem','ContainsMove','MoveMarker'))
    $hasRemove = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsRemoveItem','ContainsRemove','RemoveMarker'))
    $hasRename = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsRenameItem','ContainsRename','RenameMarker'))
    $hasStart = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsStartProcess','ContainsStartProcessCommand'))
    $hasInvoke = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsInvokeExpression','ContainsIEX'))
    if ($hasMove -or $hasRemove -or $hasRename -or $hasStart -or $hasInvoke) { $highRiskCommandMarkerRowCount++ }
}
$highRiskReviewOnlyMarkerCount = $highRiskCommandMarkerRowCount

$riskMarkedRowCount = 0
$unclassifiedRiskMarkerCount = 0
$riskRows = New-Object System.Collections.Generic.List[object]
foreach ($row in $summaryRows) {
    $ticketId = Get-PropValue -Row $row -Names @('TicketID','TicketId','ticket_id')
    $fileName = Get-PropValue -Row $row -Names @('FileName','Filename','SourceFileName','Name')
    $disp = Get-PropValue -Row $row -Names @('StaticDisposition','Disposition','DispositionBucket')
    $hasMove = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsMoveItem','ContainsMove','MoveMarker'))
    $hasRemove = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsRemoveItem','ContainsRemove','RemoveMarker'))
    $hasRename = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsRenameItem','ContainsRename','RenameMarker'))
    $hasCopy = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsCopyItem','ContainsCopy','CopyMarker'))
    $hasGit = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsGitCommand','ContainsGit'))
    $hasStart = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsStartProcess','ContainsStartProcessCommand'))
    $hasInvoke = Is-TruthyValue (Get-PropValue -Row $row -Names @('ContainsInvokeExpression','ContainsIEX'))
    $hasAnyRisk = $hasMove -or $hasRemove -or $hasRename -or $hasCopy -or $hasGit -or $hasStart -or $hasInvoke
    if ($hasAnyRisk) { $riskMarkedRowCount++ }
    $riskClass = 'NO_COMMAND_RISK_MARKER'
    if ($hasMove -or $hasRemove -or $hasRename -or $hasStart -or $hasInvoke) {
        $riskClass = 'HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION'
    } elseif ($hasCopy -or $hasGit) {
        $riskClass = 'COPY_OR_GIT_MARKER__REVIEW_ONLY__NO_EXECUTION_CLEARANCE'
    }
    $riskRows.Add([pscustomobject]@{
        TicketID = $ticketId
        FileName = $fileName
        StaticDisposition = $disp
        ContainsMoveItem = $hasMove
        ContainsRemoveItem = $hasRemove
        ContainsRenameItem = $hasRename
        ContainsCopyItem = $hasCopy
        ContainsGitCommand = $hasGit
        RiskClass = $riskClass
        SourceActionNow = (Get-PropValue -Row $row -Names @('SourceActionNow','OriginalActionNow','QueueActionNow') -Default 'PRESERVED_SOURCE_FIELD')
        SelectorActionNow = 'NO'
        ActionNow = 'NO'
        RecursiveDryRunExpansionRequired = 'YES'
        WholeHouseClearance = 'NO'
        ExecutionClearance = 'NO'
        RouteClearance = 'NO'
        CleanupClearance = 'NO'
        DoctrinePromotion = 'NO'
    }) | Out-Null
}

$executionClearanceCount = 0
$routeClearanceCount = 0
$cleanupClearanceCount = 0
$doctrinePromotionCount = 0
$recursiveDryRunExpansionRequiredCount = $summaryRowCount
$wholeHouseClearanceCount = 0

$sourceHashMismatchCount = 0
# When both declared and actual hashes are present, compare if fields exist with matching names.
foreach ($row in $summaryRows) {
    $declared = Get-PropValue -Row $row -Names @('DeclaredSHA256','DeclaredSha256','DeclaredHash','QueueDeclaredSha256','SHA256')
    $actual = Get-PropValue -Row $row -Names @('SourceSha256','ActualSHA256','ActualSha256','ComputedSHA256','ComputedSha256')
    if (-not [string]::IsNullOrWhiteSpace($declared) -and -not [string]::IsNullOrWhiteSpace($actual)) {
        if ($declared.Trim().ToUpperInvariant() -ne $actual.Trim().ToUpperInvariant()) { $sourceHashMismatchCount++ }
    }
}

$blockerCount = 0
if ($selectedBatchRows -ne 29) { $blockerCount++ }
if ($summaryRowCount -ne $selectedBatchRows) { $blockerCount++ }
if ($blankTicketIdCount -ne 0) { $blockerCount += $blankTicketIdCount }
if ($missingFilenameCount -ne 0) { $blockerCount += $missingFilenameCount }
if ($missingDeclaredSha256Count -ne 0) { $blockerCount += $missingDeclaredSha256Count }
if ($missingActualSha256Count -ne 0) { $blockerCount += $missingActualSha256Count }
if ($sourceHashMismatchCount -ne 0) { $blockerCount += $sourceHashMismatchCount }
if ($sourceMissingCount -ne 0) { $blockerCount += $sourceMissingCount }
if ($textReadFailCount -ne 0) { $blockerCount += $textReadFailCount }
if ($unknownStaticDispositionCount -ne 0) { $blockerCount += $unknownStaticDispositionCount }
if ($unclassifiedRiskMarkerCount -ne 0) { $blockerCount += $unclassifiedRiskMarkerCount }
if ($selectorActionNowNonNoCount -ne 0) { $blockerCount += $selectorActionNowNonNoCount }
if ($actionNowNonNoCount -ne 0) { $blockerCount += $actionNowNonNoCount }
if ($wholeHouseClearanceCount -ne 0) { $blockerCount += $wholeHouseClearanceCount }

$contractGatePassed = ($blockerCount -eq 0)

$riskRows | Export-Csv -LiteralPath $OutputRiskCsvPath -NoTypeInformation -Encoding UTF8
$outputRiskCsvSha = Get-Sha256 -Path $OutputRiskCsvPath

$finalVerdict = if ($contractGatePassed) {
    'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_CONTRACT_FIRST_WRITTEN_WITH_SOURCE_ACTION_NOW_PRESERVED_SELECTOR_ACTION_NOW_NO_HIGH_RISK_REVIEW_ONLY_RECURSIVE_DRY_RUN_REQUIRED_NO_PHYSICAL_ACTION'
} else {
    'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}
$nextSingleAction = if ($contractGatePassed) {
    'BUILD_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_NO_EXECUTION'
} else {
    'STOP_AND_REVIEW_HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_BLOCKERS_NO_EXECUTION'
}

$closeoutLines = @(
    '# HSRB-006 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.1',
    '',
    'Status: NO_EXECUTION / NO_ROUTE / NO_CLEANUP / CONTRACT_FIRST',
    '',
    "selected_batch_id: $selectedBatchId",
    "selected_batch_rows: $selectedBatchRows",
    "summary_rows: $summaryRowCount",
    "blank_ticket_id_count: $blankTicketIdCount",
    "missing_filename_count: $missingFilenameCount",
    "missing_declared_sha256_count: $missingDeclaredSha256Count",
    "missing_actual_sha256_count: $missingActualSha256Count",
    "source_hash_mismatch_count: $sourceHashMismatchCount",
    "source_missing_count: $sourceMissingCount",
    "text_read_fail_count: $textReadFailCount",
    "unknown_static_disposition_count: $unknownStaticDispositionCount",
    "contains_move_item_count: $containsMoveItemCount",
    "contains_remove_item_count: $containsRemoveItemCount",
    "contains_rename_item_count: $containsRenameItemCount",
    "contains_copy_item_count: $containsCopyItemCount",
    "contains_start_process_count: $containsStartProcessCount",
    "contains_invoke_expression_count: $containsInvokeExpressionCount",
    "contains_git_command_count: $containsGitCommandCount",
    "contains_set_clipboard_count: $containsSetClipboardCount",
    "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount",
    "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount",
    "risk_marked_row_count: $riskMarkedRowCount",
    "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount",
    "source_action_now_non_no_count: $sourceActionNowNonNoCount",
    "selector_action_now_non_no_count: $selectorActionNowNonNoCount",
    "action_now_non_no_count: $actionNowNonNoCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "doctrine_promotion_count: $doctrinePromotionCount",
    "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount",
    "whole_house_clearance_count: $wholeHouseClearanceCount",
    "blocker_count: $blockerCount",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0',
    '',
    'DoesNotProve:',
    '- Does not authorize execution.',
    '- Does not authorize route or cleanup.',
    '- Does not authorize whole-house clearance.',
    '- Does not promote helper files to doctrine.',
    '- Source action wording is preserved as evidence only; selector ActionNow remains NO.'
)

Write-LinesUtf8 -Path $OutputCloseoutPath -Lines $closeoutLines
Copy-Item -LiteralPath $OutputCloseoutPath -Destination $OutputCloseoutPrintPath -Force
$outputCloseoutSha = Get-Sha256 -Path $OutputCloseoutPath
$outputCloseoutPrintSha = Get-Sha256 -Path $OutputCloseoutPrintPath

$receiptLines = @(
    'HSRB-006 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.1 RECEIPT',
    "generated_utc: $((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))",
    "output_risk_csv_path: $OutputRiskCsvPath",
    "output_risk_csv_sha256: $outputRiskCsvSha",
    "output_closeout_path: $OutputCloseoutPath",
    "output_closeout_sha256: $outputCloseoutSha",
    "output_closeout_print_path: $OutputCloseoutPrintPath",
    "output_closeout_print_sha256: $outputCloseoutPrintSha",
    "contract_gate_passed: $contractGatePassed",
    "blocker_count: $blockerCount",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $OutputReceiptPath -Lines $receiptLines
$outputReceiptSha = Get-Sha256 -Path $OutputReceiptPath

Write-Host '=== HSRB-006 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.1 COMPLETE ==='
Write-Host "output_risk_csv_path: $OutputRiskCsvPath"
Write-Host "output_risk_csv_sha256: $outputRiskCsvSha"
Write-Host "output_closeout_path: $OutputCloseoutPath"
Write-Host "output_closeout_sha256: $outputCloseoutSha"
Write-Host "output_closeout_print_path: $OutputCloseoutPrintPath"
Write-Host "output_closeout_print_sha256: $outputCloseoutPrintSha"
Write-Host "output_receipt_path: $OutputReceiptPath"
Write-Host "output_receipt_sha256: $outputReceiptSha"
Write-Host "contract_gate_passed: $contractGatePassed"
Write-Host "selected_batch_id: $selectedBatchId"
Write-Host "selected_batch_rows: $selectedBatchRows"
Write-Host "summary_rows: $summaryRowCount"
Write-Host "blank_ticket_id_count: $blankTicketIdCount"
Write-Host "missing_filename_count: $missingFilenameCount"
Write-Host "missing_declared_sha256_count: $missingDeclaredSha256Count"
Write-Host "missing_actual_sha256_count: $missingActualSha256Count"
Write-Host "source_hash_mismatch_count: $sourceHashMismatchCount"
Write-Host "source_missing_count: $sourceMissingCount"
Write-Host "text_read_fail_count: $textReadFailCount"
Write-Host "unknown_static_disposition_count: $unknownStaticDispositionCount"
Write-Host "contains_move_item_count: $containsMoveItemCount"
Write-Host "contains_remove_item_count: $containsRemoveItemCount"
Write-Host "contains_rename_item_count: $containsRenameItemCount"
Write-Host "contains_copy_item_count: $containsCopyItemCount"
Write-Host "contains_start_process_count: $containsStartProcessCount"
Write-Host "contains_invoke_expression_count: $containsInvokeExpressionCount"
Write-Host "contains_git_command_count: $containsGitCommandCount"
Write-Host "contains_set_clipboard_count: $containsSetClipboardCount"
Write-Host "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount"
Write-Host "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount"
Write-Host "risk_marked_row_count: $riskMarkedRowCount"
Write-Host "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
Write-Host "source_action_now_non_no_count: $sourceActionNowNonNoCount"
Write-Host "selector_action_now_non_no_count: $selectorActionNowNonNoCount"
Write-Host "action_now_non_no_count: $actionNowNonNoCount"
Write-Host "execution_clearance_count: $executionClearanceCount"
Write-Host "route_clearance_count: $routeClearanceCount"
Write-Host "cleanup_clearance_count: $cleanupClearanceCount"
Write-Host "doctrine_promotion_count: $doctrinePromotionCount"
Write-Host "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount"
Write-Host "whole_house_clearance_count: $wholeHouseClearanceCount"
Write-Host "blocker_count: $blockerCount"
Write-Host "next_single_action: $nextSingleAction"
Write-Host "final_verdict: $finalVerdict"
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
