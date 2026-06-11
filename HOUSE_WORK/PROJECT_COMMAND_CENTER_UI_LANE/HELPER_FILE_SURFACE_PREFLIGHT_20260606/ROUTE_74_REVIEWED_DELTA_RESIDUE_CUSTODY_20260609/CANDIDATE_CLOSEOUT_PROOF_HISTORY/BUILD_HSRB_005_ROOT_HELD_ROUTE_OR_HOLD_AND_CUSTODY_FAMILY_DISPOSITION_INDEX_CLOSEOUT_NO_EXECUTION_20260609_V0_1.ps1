<#
BUILD_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1
Purpose: Close out the HSRB-005 root-held route-or-hold and custody family disposition index V0.1.
Scope: NO EXECUTION / NO ROUTE / NO CLEANUP / NO COMMIT / NO PUSH.
Design notes:
- Contract-first closeout.
- Blank-safe writer.
- Direct foreach enumeration only; no pipeline .Add() queue pattern.
- Preserves recursive dry-run expansion boundary; does not grant whole-house clearance.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$IndexCsvPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$IndexMdPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_V0_1_20260609.md'
$IndexPrintPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$IndexReceiptPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$V04CloseoutPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_4_20260609.md'
$V04RiskCsvPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_4_20260609.csv'
$V04ReceiptPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_4_20260609.txt'
$StaticSummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_SUMMARY_V0_1_20260609.csv'
$SelectedBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_005_V0_2_20260609.csv'

$OutputCloseoutPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$OutputCloseoutPrintPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$Expected = @(
    @{ Label='hsrb_005_disposition_index_csv_v0_1'; Path=$IndexCsvPath; Sha='74BA38799C2F9EB0AD7D70E5B2FFCE01DA458AB81896671913A247A6BA8B55B9' },
    @{ Label='hsrb_005_disposition_index_md_v0_1'; Path=$IndexMdPath; Sha='CED107B4E43A515D0FB2A49E94FF3A89B08A2F0B05206B02B8FE5B33EFD9D44D' },
    @{ Label='hsrb_005_disposition_index_print_v0_1'; Path=$IndexPrintPath; Sha='CED107B4E43A515D0FB2A49E94FF3A89B08A2F0B05206B02B8FE5B33EFD9D44D' },
    @{ Label='hsrb_005_disposition_index_receipt_v0_1'; Path=$IndexReceiptPath; Sha='8EF88083845DD3AEFFCB0D08191000EFD388A9A89BDABC72E9E8E7514E598321' },
    @{ Label='hsrb_005_v0_4_closeout_md'; Path=$V04CloseoutPath; Sha='81FA4190769520E4324D40FE6820C7B1322475B62EFD9E86B03A92235C28F3A4' },
    @{ Label='hsrb_005_v0_4_risk_csv'; Path=$V04RiskCsvPath; Sha='79F3EBD5DA7541D3422FFC21C2FC57B01A941780FB91DAB9E9B4D07C4B39C74B' },
    @{ Label='hsrb_005_v0_4_receipt'; Path=$V04ReceiptPath; Sha='1BA6FB6E39633C8D6759580B1433928719C5C8C74E8F0C7743AA94DBD365FDEE' },
    @{ Label='hsrb_005_static_summary_csv'; Path=$StaticSummaryCsvPath; Sha='BFEAF1DF2F09BE1C6C193A293AF029DB5EF61CFCF89227C6A6F781602F31716D' },
    @{ Label='hsrb_005_selected_batch_csv_v0_2'; Path=$SelectedBatchCsvPath; Sha='2B27276D9B580AFDD883387BB755F2C5DC808B7C861A05C5160E7A0549316C13' }
)

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

function Write-LinesUtf8 {
    param([Parameter(Mandatory=$true)][string]$Path, [AllowNull()]$Lines)
    if ($null -eq $Lines) { $Lines = @() }
    $safe = @()
    foreach ($line in $Lines) {
        if ($null -eq $line) { $safe += '' } else { $safe += [string]$line }
    }
    [System.IO.File]::WriteAllLines($Path, [string[]]$safe, [System.Text.UTF8Encoding]::new($false))
}

function Bool-Flag {
    param([AllowNull()]$Value)
    if ($null -eq $Value) { return $false }
    $s = ([string]$Value).Trim().ToLowerInvariant()
    return ($s -eq 'true' -or $s -eq '1' -or $s -eq 'yes' -or $s -eq 'y')
}

function Get-Value {
    param($Row, [string[]]$Names, [string]$Default = '')
    if ($null -eq $Row) { return $Default }
    $props = $Row.PSObject.Properties.Name
    foreach ($name in $Names) {
        if ($props -contains $name) {
            $v = $Row.PSObject.Properties[$name].Value
            if ($null -eq $v) { return $Default }
            return ([string]$v).Trim()
        }
    }
    return $Default
}

function Escape-Md {
    param([AllowNull()][string]$Text)
    if ($null -eq $Text) { return '' }
    $s = [string]$Text
    $s = $s.Replace('|','/')
    $s = $s.Replace("`r",' ')
    $s = $s.Replace("`n",' ')
    return $s
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }

$blockers = @()
$hashRows = @()
foreach ($e in $Expected) {
    $path = [string]$e.Path
    $expectedSha = ([string]$e.Sha).ToUpperInvariant()
    $actualSha = Get-Sha256Safe -Path $path
    $exists = Test-Path -LiteralPath $path -PathType Leaf
    $match = ($exists -and $actualSha -eq $expectedSha)
    $hashRows += [pscustomobject][ordered]@{
        Label = [string]$e.Label
        Path = $path
        ExpectedSha256 = $expectedSha
        ActualSha256 = $actualSha
        Exists = [bool]$exists
        HashMatch = [bool]$match
    }
    if (-not $exists) { $blockers += ('MISSING_INPUT_' + [string]$e.Label) }
    elseif (-not $match) { $blockers += ('HASH_MISMATCH_' + [string]$e.Label) }
}

$rows = @()
if ($blockers.Count -eq 0) {
    $imported = Import-Csv -LiteralPath $IndexCsvPath
    if ($null -ne $imported) {
        foreach ($row in $imported) { $rows += $row }
    }
}

$indexRows = 0
$missingTicketIdCount = 0
$missingFilenameCount = 0
$missingDeclaredSha256Count = 0
$missingActualSha256Count = 0
$sourceHashMismatchCount = 0
$sourceMissingCount = 0
$unknownDispositionBucketCount = 0
$rootHeldRouteOrHoldFamilyCount = 0
$containsCopyItemCount = 0
$containsGitCommandCount = 0
$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
$containsSetClipboardCount = 0
$highRiskCommandMarkerRowCount = 0
$highRiskReviewOnlyMarkerCount = 0
$riskMarkedRowCount = 0
$unclassifiedRiskMarkerCount = 0
$executionClearanceCount = 0
$routeClearanceCount = 0
$cleanupClearanceCount = 0
$doctrinePromotionCount = 0
$actionNowNonNoCount = 0
$recursiveDryRunExpansionRequiredCount = 0
$wholeHouseClearanceCount = 0
$wholeHouseClearanceExplicitCount = 0

foreach ($row in $rows) {
    $indexRows++
    $ticketId = Get-Value -Row $row -Names @('TicketID','TicketId','ticket_id')
    $fileName = Get-Value -Row $row -Names @('FileName','Name','file_name')
    $declaredSha = Get-Value -Row $row -Names @('DeclaredSHA256','DeclaredSha256','SHA256','Sha256')
    $actualSha = Get-Value -Row $row -Names @('ActualSHA256','ActualSha256','ComputedSHA256','ComputedSha256','SourceSHA256','SourceSha256')
    $hashMatch = Bool-Flag (Get-Value -Row $row -Names @('HashMatch','hash_match'))
    $sourceExistsText = Get-Value -Row $row -Names @('SourceExists','source_exists') -Default 'True'
    $sourceExists = Bool-Flag $sourceExistsText
    $bucket = Get-Value -Row $row -Names @('DispositionBucket','disposition_bucket')
    $riskClass = Get-Value -Row $row -Names @('RiskMarkerClass','risk_marker_class')
    $recursiveRequired = Get-Value -Row $row -Names @('RecursiveDryRunExpansionRequired','recursive_dry_run_expansion_required')
    $wholeHouseClearance = Get-Value -Row $row -Names @('WholeHouseClearance','whole_house_clearance')

    if ([string]::IsNullOrWhiteSpace($ticketId)) { $missingTicketIdCount++ }
    if ([string]::IsNullOrWhiteSpace($fileName)) { $missingFilenameCount++ }
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $missingDeclaredSha256Count++ }
    if ([string]::IsNullOrWhiteSpace($actualSha)) { $missingActualSha256Count++ }
    if (-not $hashMatch) { $sourceHashMismatchCount++ }
    if (-not $sourceExists) { $sourceMissingCount++ }
    if ([string]::IsNullOrWhiteSpace($bucket) -or $bucket -match 'UNKNOWN') { $unknownDispositionBucketCount++ }
    if ($bucket -eq 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY__REVIEW_ONLY') { $rootHeldRouteOrHoldFamilyCount++ }

    $hasCopy = Bool-Flag (Get-Value -Row $row -Names @('ContainsCopyItem','contains_copy_item'))
    $hasGit = Bool-Flag (Get-Value -Row $row -Names @('ContainsGitCommand','contains_git_command'))
    $hasMove = Bool-Flag (Get-Value -Row $row -Names @('ContainsMoveItem','contains_move_item'))
    $hasRemove = Bool-Flag (Get-Value -Row $row -Names @('ContainsRemoveItem','contains_remove_item'))
    $hasRename = Bool-Flag (Get-Value -Row $row -Names @('ContainsRenameItem','contains_rename_item'))
    $hasStart = Bool-Flag (Get-Value -Row $row -Names @('ContainsStartProcess','contains_start_process'))
    $hasInvoke = Bool-Flag (Get-Value -Row $row -Names @('ContainsInvokeExpression','contains_invoke_expression'))
    $hasClipboard = Bool-Flag (Get-Value -Row $row -Names @('ContainsSetClipboard','contains_set_clipboard'))
    $riskMarked = Bool-Flag (Get-Value -Row $row -Names @('RiskMarked','risk_marked'))

    if ($hasCopy) { $containsCopyItemCount++ }
    if ($hasGit) { $containsGitCommandCount++ }
    if ($hasMove) { $containsMoveItemCount++ }
    if ($hasRemove) { $containsRemoveItemCount++ }
    if ($hasRename) { $containsRenameItemCount++ }
    if ($hasStart) { $containsStartProcessCount++ }
    if ($hasInvoke) { $containsInvokeExpressionCount++ }
    if ($hasClipboard) { $containsSetClipboardCount++ }
    if ($hasMove -or $hasRemove -or $hasRename -or $hasStart -or $hasInvoke) { $highRiskCommandMarkerRowCount++ }
    if ($riskClass -eq 'HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION') { $highRiskReviewOnlyMarkerCount++ }
    if ($riskMarked) { $riskMarkedRowCount++ }
    if ($riskMarked -and ([string]::IsNullOrWhiteSpace($riskClass) -or $riskClass -match 'UNKNOWN')) { $unclassifiedRiskMarkerCount++ }

    if ((Get-Value -Row $row -Names @('ExecutionClearance','execution_clearance') -Default 'NO').ToUpperInvariant() -ne 'NO') { $executionClearanceCount++ }
    if ((Get-Value -Row $row -Names @('RouteClearance','route_clearance') -Default 'NO').ToUpperInvariant() -ne 'NO') { $routeClearanceCount++ }
    if ((Get-Value -Row $row -Names @('CleanupClearance','cleanup_clearance') -Default 'NO').ToUpperInvariant() -ne 'NO') { $cleanupClearanceCount++ }
    if ((Get-Value -Row $row -Names @('DoctrinePromotion','doctrine_promotion') -Default 'NO').ToUpperInvariant() -ne 'NO') { $doctrinePromotionCount++ }
    if ((Get-Value -Row $row -Names @('ActionNow','action_now') -Default 'NO').ToUpperInvariant() -ne 'NO') { $actionNowNonNoCount++ }
    if ($recursiveRequired.ToUpperInvariant() -eq 'YES') { $recursiveDryRunExpansionRequiredCount++ }
    if (-not [string]::IsNullOrWhiteSpace($wholeHouseClearance)) { $wholeHouseClearanceExplicitCount++ }
    if ($wholeHouseClearance.ToUpperInvariant() -eq 'YES' -or $wholeHouseClearance.ToUpperInvariant() -eq 'TRUE') { $wholeHouseClearanceCount++ }
}

if ($blockers.Count -eq 0) {
    if ($indexRows -ne 18) { $blockers += ('INDEX_ROWS_NOT_18_ACTUAL_' + [string]$indexRows) }
    if ($missingTicketIdCount -ne 0) { $blockers += ('MISSING_TICKET_ID_COUNT_' + [string]$missingTicketIdCount) }
    if ($missingFilenameCount -ne 0) { $blockers += ('MISSING_FILENAME_COUNT_' + [string]$missingFilenameCount) }
    if ($missingDeclaredSha256Count -ne 0) { $blockers += ('MISSING_DECLARED_SHA256_COUNT_' + [string]$missingDeclaredSha256Count) }
    if ($missingActualSha256Count -ne 0) { $blockers += ('MISSING_ACTUAL_SHA256_COUNT_' + [string]$missingActualSha256Count) }
    if ($sourceHashMismatchCount -ne 0) { $blockers += ('SOURCE_HASH_MISMATCH_COUNT_' + [string]$sourceHashMismatchCount) }
    if ($sourceMissingCount -ne 0) { $blockers += ('SOURCE_MISSING_COUNT_' + [string]$sourceMissingCount) }
    if ($unknownDispositionBucketCount -ne 0) { $blockers += ('UNKNOWN_DISPOSITION_BUCKET_COUNT_' + [string]$unknownDispositionBucketCount) }
    if ($containsMoveItemCount -ne 0) { $blockers += ('CONTAINS_MOVE_ITEM_COUNT_' + [string]$containsMoveItemCount) }
    if ($highRiskCommandMarkerRowCount -ne 0) { $blockers += ('HIGH_RISK_COMMAND_MARKER_ROW_COUNT_' + [string]$highRiskCommandMarkerRowCount) }
    if ($unclassifiedRiskMarkerCount -ne 0) { $blockers += ('UNCLASSIFIED_RISK_MARKER_COUNT_' + [string]$unclassifiedRiskMarkerCount) }
    if ($executionClearanceCount -ne 0) { $blockers += ('EXECUTION_CLEARANCE_COUNT_' + [string]$executionClearanceCount) }
    if ($routeClearanceCount -ne 0) { $blockers += ('ROUTE_CLEARANCE_COUNT_' + [string]$routeClearanceCount) }
    if ($cleanupClearanceCount -ne 0) { $blockers += ('CLEANUP_CLEARANCE_COUNT_' + [string]$cleanupClearanceCount) }
    if ($doctrinePromotionCount -ne 0) { $blockers += ('DOCTRINE_PROMOTION_COUNT_' + [string]$doctrinePromotionCount) }
    if ($actionNowNonNoCount -ne 0) { $blockers += ('ACTION_NOW_NON_NO_COUNT_' + [string]$actionNowNonNoCount) }
    if ($recursiveDryRunExpansionRequiredCount -ne 18) { $blockers += ('RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_COUNT_NOT_18_ACTUAL_' + [string]$recursiveDryRunExpansionRequiredCount) }
    if ($wholeHouseClearanceCount -ne 0) { $blockers += ('WHOLE_HOUSE_CLEARANCE_COUNT_' + [string]$wholeHouseClearanceCount) }
}

$blockerCount = [int]$blockers.Count
$contractGatePassed = ($blockerCount -eq 0)
if ($contractGatePassed) {
    $nextSingleAction = 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
    $finalVerdict = 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_V0_1_VERIFIED_REVIEW_ONLY_COPY_AND_GIT_MARKERS_RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_NO_PHYSICAL_ACTION'
} else {
    $nextSingleAction = 'STOP_AND_REVIEW_HSRB_005_DISPOSITION_INDEX_CLOSEOUT_BLOCKERS_NO_EXECUTION'
    $finalVerdict = 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$countLines = @(
    "contract_gate_passed: $contractGatePassed",
    'selected_batch_id: HSRB-005',
    'selected_batch_rows: 18',
    'summary_rows: 18',
    'risk_index_rows: 18',
    "index_rows: $indexRows",
    "missing_ticket_id_count: $missingTicketIdCount",
    "missing_filename_count: $missingFilenameCount",
    "missing_declared_sha256_count: $missingDeclaredSha256Count",
    "missing_actual_sha256_count: $missingActualSha256Count",
    "source_hash_mismatch_count: $sourceHashMismatchCount",
    "source_missing_count: $sourceMissingCount",
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
    "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount",
    "risk_marked_row_count: $riskMarkedRowCount",
    "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "doctrine_promotion_count: $doctrinePromotionCount",
    "action_now_non_no_count: $actionNowNonNoCount",
    "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount",
    "whole_house_clearance_count: $wholeHouseClearanceCount",
    "whole_house_clearance_explicit_count: $wholeHouseClearanceExplicitCount",
    "blocker_count: $blockerCount"
)

$md = @()
$md += '# HSRB-005 Root Held Route or Hold and Custody Family Disposition Index Closeout - No Execution - V0.1'
$md += ''
$md += 'Status: CLOSEOUT / CONTRACT_FIRST / REVIEW_ONLY / RECURSIVE_DRY_RUN_EXPANSION_REQUIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += 'Close out the HSRB-005 disposition index after the V0.4 micro-contract correction and V0.1 disposition index creation.'
$md += ''
$md += '## Boundary'
$md += 'This closeout verifies review-only disposition work. It does not authorize execution, routing, cleanup, commit, push, doctrine promotion, or whole-house clearance.'
$md += ''
$md += '## Recursive dry-run expansion boundary'
$md += 'All 18 HSRB-005 rows still require recursive dry-run expansion before they can influence any route proposal beyond review-only evidence. Passing this closeout does not mean the whole house is clear.'
$md += ''
$md += '## Input hash checks'
$md += ''
$md += '| Label | Exists | HashMatch | Expected SHA256 | Actual SHA256 | Path |'
$md += '| --- | ---: | ---: | --- | --- | --- |'
foreach ($h in $hashRows) {
    $md += ('| {0} | {1} | {2} | `{3}` | `{4}` | `{5}` |' -f (Escape-Md $h.Label), $h.Exists, $h.HashMatch, $h.ExpectedSha256, $h.ActualSha256, (Escape-Md $h.Path))
}
$md += ''
$md += '## Counts'
foreach ($line in $countLines) { $md += ('- ' + $line) }
$md += ''
$md += '## Blockers'
if ($blockers.Count -eq 0) {
    $md += '- none'
} else {
    foreach ($b in $blockers) { $md += ('- ' + (Escape-Md $b)) }
}
$md += ''
$md += '## Interpretation'
$md += '- HSRB-005 is closed only as root-held route-or-hold family review evidence.'
$md += '- Copy and git markers are preserved as review-only risk evidence and grant no clearance.'
$md += '- No move, remove, rename, start-process, invoke-expression, execution, route, cleanup, doctrine promotion, commit, or push is authorized.'
$md += '- Recursive dry-run expansion remains required for every row before downstream helper or whole-house claims can be made.'
$md += ''
$md += '## Next single action'
$md += $nextSingleAction
$md += ''
$md += "Final verdict: $finalVerdict"
$md += ''
$md += 'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

Write-LinesUtf8 -Path $OutputCloseoutPath -Lines $md
Copy-Item -LiteralPath $OutputCloseoutPath -Destination $OutputCloseoutPrintPath -Force
$outputCloseoutSha = Get-Sha256Safe -Path $OutputCloseoutPath
$outputCloseoutPrintSha = Get-Sha256Safe -Path $OutputCloseoutPrintPath

$receipt = @()
$receipt += 'HSRB-005 ROOT HELD ROUTE OR HOLD AND CUSTODY FAMILY DISPOSITION INDEX CLOSEOUT RECEIPT V0.1'
$receipt += "output_closeout_path: $OutputCloseoutPath"
$receipt += "output_closeout_sha256: $outputCloseoutSha"
$receipt += "output_closeout_print_path: $OutputCloseoutPrintPath"
$receipt += "output_closeout_print_sha256: $outputCloseoutPrintSha"
$receipt += "selected_batch_id: HSRB-005"
$receipt += "index_rows: $indexRows"
$receipt += "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount"
$receipt += "whole_house_clearance_count: $wholeHouseClearanceCount"
$receipt += "blocker_count: $blockerCount"
$receipt += "next_single_action: $nextSingleAction"
$receipt += "final_verdict: $finalVerdict"
$receipt += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesUtf8 -Path $OutputReceiptPath -Lines $receipt
$outputReceiptSha = Get-Sha256Safe -Path $OutputReceiptPath

Write-Output '=== HSRB-005 ROOT HELD ROUTE OR HOLD AND CUSTODY FAMILY DISPOSITION INDEX CLOSEOUT V0.1 COMPLETE ==='
Write-Output "output_closeout_path: $OutputCloseoutPath"
Write-Output "output_closeout_sha256: $outputCloseoutSha"
Write-Output "output_closeout_print_path: $OutputCloseoutPrintPath"
Write-Output "output_closeout_print_sha256: $outputCloseoutPrintSha"
Write-Output "output_receipt_path: $OutputReceiptPath"
Write-Output "output_receipt_sha256: $outputReceiptSha"
foreach ($line in $countLines) { Write-Output $line }
Write-Output "next_single_action: $nextSingleAction"
Write-Output "final_verdict: $finalVerdict"
Write-Output 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
