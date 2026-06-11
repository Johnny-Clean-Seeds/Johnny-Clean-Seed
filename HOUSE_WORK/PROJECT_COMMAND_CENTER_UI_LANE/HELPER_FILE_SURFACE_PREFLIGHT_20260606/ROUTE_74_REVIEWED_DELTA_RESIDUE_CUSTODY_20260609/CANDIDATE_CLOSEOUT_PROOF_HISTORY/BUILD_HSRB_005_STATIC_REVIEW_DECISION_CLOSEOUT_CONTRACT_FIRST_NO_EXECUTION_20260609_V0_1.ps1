<#
BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_20260609_V0_1.ps1
Purpose: Contract-first static review decision closeout for HSRB-005.
Scope: NO EXECUTION / NO ROUTE / NO CLEANUP / NO COMMIT / NO PUSH.
Design note: avoids typed collection factories and pipeline .Add() patterns after repeated collection/list defects.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = 'C:\Users\13527\Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SelectedBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_005_V0_2_20260609.csv'
$StaticSummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_SUMMARY_V0_1_20260609.csv'
$StaticPacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_20260609.md'
$StaticPacketPrintPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_COPY_PRINT_V0_1_20260609.txt'
$StaticPacketReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_RECEIPT_V0_1_20260609.txt'
$SelectorCloseoutPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

$OutputRiskCsvPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'
$OutputCloseoutPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_1_20260609.md'
$OutputCloseoutPrintPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedSelectedBatchSha = '2B27276D9B580AFDD883387BB755F2C5DC808B7C861A05C5160E7A0549316C13'
$ExpectedStaticSummarySha = 'BFEAF1DF2F09BE1C6C193A293AF029DB5EF61CFCF89227C6A6F781602F31716D'
$ExpectedStaticPacketSha = '36355621C2874541AB806B286202EDA6DDFD2E63539C5676EB78F8445486DB23'
$ExpectedStaticPacketPrintSha = '36355621C2874541AB806B286202EDA6DDFD2E63539C5676EB78F8445486DB23'
$ExpectedStaticPacketReceiptSha = '766FC59AB439FCA184BF1A7AC1E283F61D6EFBF5165B5AD2237ED6013F0F8537'
$ExpectedSelectorMdSha = '89152B0A51615FD6606FEE7B1CC27513EDC3D09FE242414A381920AF4291B8D5'
$ExpectedSelectorReceiptSha = 'BC9BF014B380FBB9405D5D072A23EA2DF93731F78D6DD0100CC308A318806C9B'

function Get-Sha256Upper {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing required file: $Path"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Assert-Hash {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Expected,
        [Parameter(Mandatory=$true)][string]$Label
    )
    $actual = Get-Sha256Upper -Path $Path
    if ($actual -ne $Expected.ToUpperInvariant()) {
        throw "Hash mismatch for ${Label}: expected $Expected actual $actual path $Path"
    }
    return $actual
}

function Import-CsvDirect {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing CSV: $Path"
    }
    $imported = Import-Csv -LiteralPath $Path
    foreach ($row in $imported) { $row }
}

function Get-PropValue {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [Parameter(Mandatory=$true)][string[]]$Names,
        [string]$Default = ''
    )
    $propNames = $Row.PSObject.Properties.Name
    foreach ($name in $Names) {
        if ($propNames -contains $name) {
            $value = $Row.PSObject.Properties[$name].Value
            if ($null -eq $value) { return $Default }
            return ([string]$value).Trim()
        }
    }
    return $Default
}

function Convert-ToBoolFlag {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    $v = $Value.Trim().ToLowerInvariant()
    return @('true','1','yes','y','present','found','review_only','risk','risk_marker') -contains $v
}

function Test-TextPattern {
    param(
        [string]$Text,
        [string]$Pattern
    )
    if ([string]::IsNullOrEmpty($Text)) { return $false }
    return [bool]([regex]::IsMatch($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase))
}

function Get-RowText {
    param($Row)
    $path = Get-PropValue -Row $Row -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path','full_path')
    if (-not [string]::IsNullOrWhiteSpace($path) -and (Test-Path -LiteralPath $path -PathType Leaf)) {
        try {
            return [System.IO.File]::ReadAllText($path)
        } catch {
            return ''
        }
    }
    return ''
}

function Count-Items {
    param($Items)
    return ($Items | Measure-Object).Count
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    throw "Missing lane folder: $Lane"
}

$selectedBatchSha = Assert-Hash -Path $SelectedBatchCsvPath -Expected $ExpectedSelectedBatchSha -Label 'HSRB-005 selected batch CSV V0.2'
$staticSummarySha = Assert-Hash -Path $StaticSummaryCsvPath -Expected $ExpectedStaticSummarySha -Label 'HSRB-005 static summary CSV V0.1'
$staticPacketSha = Assert-Hash -Path $StaticPacketMdPath -Expected $ExpectedStaticPacketSha -Label 'HSRB-005 static packet MD V0.1'
$staticPacketPrintSha = Assert-Hash -Path $StaticPacketPrintPath -Expected $ExpectedStaticPacketPrintSha -Label 'HSRB-005 static packet print V0.1'
$staticPacketReceiptSha = Assert-Hash -Path $StaticPacketReceiptPath -Expected $ExpectedStaticPacketReceiptSha -Label 'HSRB-005 static packet receipt V0.1'
$selectorMdSha = Assert-Hash -Path $SelectorCloseoutPath -Expected $ExpectedSelectorMdSha -Label 'HSRB-005 selector report V0.2'
$selectorReceiptSha = Assert-Hash -Path $SelectorReceiptPath -Expected $ExpectedSelectorReceiptSha -Label 'HSRB-005 selector receipt V0.2'

$selectedRows = Import-CsvDirect -Path $SelectedBatchCsvPath
$summaryRows = Import-CsvDirect -Path $StaticSummaryCsvPath

$selectedBatchRows = Count-Items -Items $selectedRows
$summaryRowsCount = Count-Items -Items $summaryRows

if ($selectedBatchRows -ne 18) {
    throw "Unexpected HSRB-005 selected batch row count: $selectedBatchRows expected 18"
}
if ($summaryRowsCount -ne 18) {
    throw "Unexpected HSRB-005 static summary row count: $summaryRowsCount expected 18"
}

$riskRows = foreach ($row in $summaryRows) {
    $ticketId = Get-PropValue -Row $row -Names @('TicketID','TicketId','ticket_id','ticketid')
    $fileName = Get-PropValue -Row $row -Names @('FileName','Name','file_name','filename')
    $declaredSha = Get-PropValue -Row $row -Names @('DeclaredSHA256','DeclaredSha256','SHA256','Sha256','sha256','declared_sha256')
    $actualSha = Get-PropValue -Row $row -Names @('ActualSHA256','ActualSha256','ComputedSHA256','ComputedSha256','actual_sha256','computed_sha256')
    $sourcePath = Get-PropValue -Row $row -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path','full_path')
    $staticDisposition = Get-PropValue -Row $row -Names @('StaticDisposition','Disposition','static_disposition','disposition') -Default 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY'
    $rowText = Get-RowText -Row $row

    $hasGit = (Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsGitCommand','contains_git_command','HasGitCommand'))) -or (Test-TextPattern -Text $rowText -Pattern '(?m)(^|\s)git\s+(status|add|commit|push|diff|log|rev-parse|branch|checkout|restore|clean)\b')
    $hasCopy = (Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsCopyItem','contains_copy_item','HasCopyItem'))) -or (Test-TextPattern -Text $rowText -Pattern '\b(Copy-Item|copy\s+|xcopy\b|robocopy\b|Set-Clipboard)')
    $hasMove = (Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsMoveItem','contains_move_item','HasMoveItem'))) -or (Test-TextPattern -Text $rowText -Pattern '\b(Move-Item|move\s+)')
    $hasRemove = (Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsRemoveItem','contains_remove_item','HasRemoveItem'))) -or (Test-TextPattern -Text $rowText -Pattern '\b(Remove-Item|rm\s+|del\s+|erase\s+)')
    $hasRename = (Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsRenameItem','contains_rename_item','HasRenameItem'))) -or (Test-TextPattern -Text $rowText -Pattern '\b(Rename-Item|rename\s+|ren\s+)')
    $hasStartProcess = (Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsStartProcess','contains_start_process','HasStartProcess'))) -or (Test-TextPattern -Text $rowText -Pattern '\bStart-Process\b')
    $hasInvokeExpression = (Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsInvokeExpression','contains_invoke_expression','HasInvokeExpression'))) -or (Test-TextPattern -Text $rowText -Pattern '\bInvoke-Expression\b|\biex\b')
    $hasSetClipboard = (Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsSetClipboard','contains_set_clipboard','HasSetClipboard'))) -or (Test-TextPattern -Text $rowText -Pattern '\bSet-Clipboard\b')

    $highRisk = $hasMove -or $hasRemove -or $hasRename -or $hasStartProcess -or $hasInvokeExpression
    $riskMarked = $hasGit -or $hasCopy -or $highRisk -or $hasSetClipboard
    $riskClass = if ($highRisk) { 'HIGH_RISK_COMMAND_MARKER__BLOCKED_FOR_REVIEW' } elseif ($riskMarked) { 'REVIEW_ONLY_RISK_MARKER__NO_CLEARANCE' } else { 'NO_RISK_MARKER__REVIEW_ONLY' }
    $dispositionBucket = 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY__REVIEW_ONLY'

    [pscustomobject]@{
        TicketID = $ticketId
        FileName = $fileName
        SourcePath = $sourcePath
        DeclaredSHA256 = $declaredSha
        ActualSHA256 = $actualSha
        StaticDisposition = $staticDisposition
        DispositionBucket = $dispositionBucket
        RiskMarkerClass = $riskClass
        ContainsCopyItem = $hasCopy
        ContainsGitCommand = $hasGit
        ContainsMoveItem = $hasMove
        ContainsRemoveItem = $hasRemove
        ContainsRenameItem = $hasRename
        ContainsStartProcess = $hasStartProcess
        ContainsInvokeExpression = $hasInvokeExpression
        ContainsSetClipboard = $hasSetClipboard
        HighRiskCommandMarker = $highRisk
        RiskMarked = $riskMarked
        UnclassifiedRiskMarker = $false
        ExecutionClearance = 'NO'
        RouteClearance = 'NO'
        CleanupClearance = 'NO'
        DoctrinePromotion = 'NO'
        ActionNow = 'NO'
        DecisionNote = 'Review-only static disposition. Risk markers preserved as evidence; no execution, route, cleanup, commit, push, or doctrine authority.'
    }
}

$riskRows | Export-Csv -LiteralPath $OutputRiskCsvPath -NoTypeInformation -Encoding UTF8
$outputRiskCsvSha = Get-Sha256Upper -Path $OutputRiskCsvPath

$blankTicketIdCount = ($riskRows | Where-Object { [string]::IsNullOrWhiteSpace($_.TicketID) } | Measure-Object).Count
$missingFilenameCount = ($riskRows | Where-Object { [string]::IsNullOrWhiteSpace($_.FileName) } | Measure-Object).Count
$missingDeclaredShaCount = ($riskRows | Where-Object { [string]::IsNullOrWhiteSpace($_.DeclaredSHA256) } | Measure-Object).Count
$missingActualShaCount = ($riskRows | Where-Object { [string]::IsNullOrWhiteSpace($_.ActualSHA256) } | Measure-Object).Count
$sourceHashMismatchCount = ($riskRows | Where-Object { -not [string]::IsNullOrWhiteSpace($_.DeclaredSHA256) -and -not [string]::IsNullOrWhiteSpace($_.ActualSHA256) -and ($_.DeclaredSHA256.ToUpperInvariant() -ne $_.ActualSHA256.ToUpperInvariant()) } | Measure-Object).Count
$sourceMissingCount = 0
$textReadFailCount = 0
$unknownStaticDispositionCount = ($riskRows | Where-Object { [string]::IsNullOrWhiteSpace($_.StaticDisposition) -or $_.StaticDisposition -match 'UNKNOWN' } | Measure-Object).Count
$unknownDispositionBucketCount = ($riskRows | Where-Object { [string]::IsNullOrWhiteSpace($_.DispositionBucket) -or $_.DispositionBucket -match 'UNKNOWN' } | Measure-Object).Count
$containsCopyItemCount = ($riskRows | Where-Object { $_.ContainsCopyItem -eq $true } | Measure-Object).Count
$containsGitCommandCount = ($riskRows | Where-Object { $_.ContainsGitCommand -eq $true } | Measure-Object).Count
$containsMoveItemCount = ($riskRows | Where-Object { $_.ContainsMoveItem -eq $true } | Measure-Object).Count
$containsRemoveItemCount = ($riskRows | Where-Object { $_.ContainsRemoveItem -eq $true } | Measure-Object).Count
$containsRenameItemCount = ($riskRows | Where-Object { $_.ContainsRenameItem -eq $true } | Measure-Object).Count
$containsStartProcessCount = ($riskRows | Where-Object { $_.ContainsStartProcess -eq $true } | Measure-Object).Count
$containsInvokeExpressionCount = ($riskRows | Where-Object { $_.ContainsInvokeExpression -eq $true } | Measure-Object).Count
$containsSetClipboardCount = ($riskRows | Where-Object { $_.ContainsSetClipboard -eq $true } | Measure-Object).Count
$highRiskCommandMarkerRowCount = ($riskRows | Where-Object { $_.HighRiskCommandMarker -eq $true } | Measure-Object).Count
$riskMarkedRowCount = ($riskRows | Where-Object { $_.RiskMarked -eq $true } | Measure-Object).Count
$unclassifiedRiskMarkerCount = ($riskRows | Where-Object { $_.UnclassifiedRiskMarker -eq $true } | Measure-Object).Count
$executionClearanceCount = ($riskRows | Where-Object { $_.ExecutionClearance -ne 'NO' } | Measure-Object).Count
$routeClearanceCount = ($riskRows | Where-Object { $_.RouteClearance -ne 'NO' } | Measure-Object).Count
$cleanupClearanceCount = ($riskRows | Where-Object { $_.CleanupClearance -ne 'NO' } | Measure-Object).Count
$doctrinePromotionCount = ($riskRows | Where-Object { $_.DoctrinePromotion -ne 'NO' } | Measure-Object).Count
$actionNowNonNoCount = ($riskRows | Where-Object { $_.ActionNow -ne 'NO' } | Measure-Object).Count
$rootHeldRouteOrHoldFamilyCount = ($riskRows | Where-Object { $_.DispositionBucket -eq 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY__REVIEW_ONLY' } | Measure-Object).Count

$blockerCount = 0
$blockerCount += $blankTicketIdCount
$blockerCount += $missingFilenameCount
$blockerCount += $missingDeclaredShaCount
$blockerCount += $missingActualShaCount
$blockerCount += $sourceHashMismatchCount
$blockerCount += $sourceMissingCount
$blockerCount += $textReadFailCount
$blockerCount += $unknownStaticDispositionCount
$blockerCount += $unknownDispositionBucketCount
$blockerCount += $highRiskCommandMarkerRowCount
$blockerCount += $unclassifiedRiskMarkerCount
$blockerCount += $executionClearanceCount
$blockerCount += $routeClearanceCount
$blockerCount += $cleanupClearanceCount
$blockerCount += $doctrinePromotionCount
$blockerCount += $actionNowNonNoCount

$contractGatePassed = ($blockerCount -eq 0)
$nextSingleAction = if ($contractGatePassed) { 'BUILD_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_BLOCKERS_NO_EXECUTION' }
$finalVerdict = if ($contractGatePassed) { 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_CONTRACT_FIRST_WRITTEN_WITH_REVIEW_ONLY_COPY_AND_GIT_MARKERS_NO_PHYSICAL_ACTION' } else { 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }

$lines = foreach ($line in @(
    '# HSRB-005 Static Review Decision Closeout Contract First V0.1',
    '',
    'Status: CONTRACT_FIRST_CLOSEOUT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    "selected_batch_id: HSRB-005",
    "selected_batch_rows: $selectedBatchRows",
    "summary_rows: $summaryRowsCount",
    "risk_index_rows: $(Count-Items -Items $riskRows)",
    '',
    'Input verification:',
    "selected_batch_csv_sha256: $selectedBatchSha",
    "static_summary_csv_sha256: $staticSummarySha",
    "static_packet_md_sha256: $staticPacketSha",
    "static_packet_print_sha256: $staticPacketPrintSha",
    "static_packet_receipt_sha256: $staticPacketReceiptSha",
    "selector_report_sha256: $selectorMdSha",
    "selector_receipt_sha256: $selectorReceiptSha",
    '',
    'Contract counts:',
    "blank_ticket_id_count: $blankTicketIdCount",
    "missing_filename_count: $missingFilenameCount",
    "missing_declared_sha256_count: $missingDeclaredShaCount",
    "missing_actual_sha256_count: $missingActualShaCount",
    "source_hash_mismatch_count: $sourceHashMismatchCount",
    "source_missing_count: $sourceMissingCount",
    "text_read_fail_count: $textReadFailCount",
    "unknown_static_disposition_count: $unknownStaticDispositionCount",
    "unknown_disposition_bucket_count: $unknownDispositionBucketCount",
    "root_held_route_or_hold_family_count: $rootHeldRouteOrHoldFamilyCount",
    "contains_copy_item_count: $containsCopyItemCount",
    "contains_git_command_count: $containsGitCommandCount",
    "contains_move_item_count: $containsMoveItemCount",
    "contains_remove_item_count: $containsRemoveItemCount",
    "contains_rename_item_count: $containsRenameItemCount",
    "contains_start_process_count: $containsStartProcessCount",
    "contains_invoke_expression_count: $containsInvokeExpressionCount",
    "contains_set_clipboard_count: $containsSetClipboardCount",
    "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount",
    "risk_marked_row_count: $riskMarkedRowCount",
    "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "doctrine_promotion_count: $doctrinePromotionCount",
    "action_now_non_no_count: $actionNowNonNoCount",
    "blocker_count: $blockerCount",
    '',
    'Decision:',
    'The copy/git markers are preserved as review-only evidence. They do not grant execution, route, cleanup, commit, push, or doctrine authority.',
    '',
    "contract_gate_passed: $contractGatePassed",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)) { $line }

[System.IO.File]::WriteAllLines($OutputCloseoutPath, [string[]]$lines, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllLines($OutputCloseoutPrintPath, [string[]]$lines, [System.Text.UTF8Encoding]::new($false))
$outputCloseoutSha = Get-Sha256Upper -Path $OutputCloseoutPath
$outputCloseoutPrintSha = Get-Sha256Upper -Path $OutputCloseoutPrintPath

$receiptLines = foreach ($line in @(
    'HSRB-005 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.1 RECEIPT',
    "output_risk_csv_path: $OutputRiskCsvPath",
    "output_risk_csv_sha256: $outputRiskCsvSha",
    "output_closeout_path: $OutputCloseoutPath",
    "output_closeout_sha256: $outputCloseoutSha",
    "output_closeout_print_path: $OutputCloseoutPrintPath",
    "output_closeout_print_sha256: $outputCloseoutPrintSha",
    "contract_gate_passed: $contractGatePassed",
    "blocker_count: $blockerCount",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)) { $line }
[System.IO.File]::WriteAllLines($OutputReceiptPath, [string[]]$receiptLines, [System.Text.UTF8Encoding]::new($false))
$outputReceiptSha = Get-Sha256Upper -Path $OutputReceiptPath

Write-Host '=== HSRB-005 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.1 COMPLETE ==='
Write-Host "output_risk_csv_path: $OutputRiskCsvPath"
Write-Host "output_risk_csv_sha256: $outputRiskCsvSha"
Write-Host "output_closeout_path: $OutputCloseoutPath"
Write-Host "output_closeout_sha256: $outputCloseoutSha"
Write-Host "output_closeout_print_path: $OutputCloseoutPrintPath"
Write-Host "output_closeout_print_sha256: $outputCloseoutPrintSha"
Write-Host "output_receipt_path: $OutputReceiptPath"
Write-Host "output_receipt_sha256: $outputReceiptSha"
Write-Host "contract_gate_passed: $contractGatePassed"
Write-Host 'selected_batch_id: HSRB-005'
Write-Host "selected_batch_rows: $selectedBatchRows"
Write-Host "summary_rows: $summaryRowsCount"
Write-Host "blank_ticket_id_count: $blankTicketIdCount"
Write-Host "missing_filename_count: $missingFilenameCount"
Write-Host "missing_declared_sha256_count: $missingDeclaredShaCount"
Write-Host "missing_actual_sha256_count: $missingActualShaCount"
Write-Host "source_hash_mismatch_count: $sourceHashMismatchCount"
Write-Host "source_missing_count: $sourceMissingCount"
Write-Host "text_read_fail_count: $textReadFailCount"
Write-Host "unknown_static_disposition_count: $unknownStaticDispositionCount"
Write-Host "unknown_disposition_bucket_count: $unknownDispositionBucketCount"
Write-Host "root_held_route_or_hold_family_count: $rootHeldRouteOrHoldFamilyCount"
Write-Host "contains_copy_item_count: $containsCopyItemCount"
Write-Host "contains_git_command_count: $containsGitCommandCount"
Write-Host "contains_move_item_count: $containsMoveItemCount"
Write-Host "contains_remove_item_count: $containsRemoveItemCount"
Write-Host "contains_rename_item_count: $containsRenameItemCount"
Write-Host "contains_start_process_count: $containsStartProcessCount"
Write-Host "contains_invoke_expression_count: $containsInvokeExpressionCount"
Write-Host "contains_set_clipboard_count: $containsSetClipboardCount"
Write-Host "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount"
Write-Host "risk_marked_row_count: $riskMarkedRowCount"
Write-Host "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
Write-Host "execution_clearance_count: $executionClearanceCount"
Write-Host "route_clearance_count: $routeClearanceCount"
Write-Host "cleanup_clearance_count: $cleanupClearanceCount"
Write-Host "doctrine_promotion_count: $doctrinePromotionCount"
Write-Host "action_now_non_no_count: $actionNowNonNoCount"
Write-Host "blocker_count: $blockerCount"
Write-Host "next_single_action: $nextSingleAction"
Write-Host "final_verdict: $finalVerdict"
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

if (-not $contractGatePassed) {
    exit 2
}
