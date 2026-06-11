<#
BUILD_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_20260609_V0_1.ps1
Purpose: Build the HSRB-005 disposition index after V0.4 reconciled the static review decision closeout.
Scope: NO EXECUTION / NO ROUTE / NO CLEANUP / NO COMMIT / NO PUSH.
Design notes:
- No typed list factory.
- No pipeline .Add() queue pattern.
- Blank-safe writer.
- Uses reconciled V0.4 counts and risk index as authority for this derived index.
- Adds recursive dry-run expansion fields without granting authority.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = 'C:\Users\13527\Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SelectedBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_005_V0_2_20260609.csv'
$StaticSummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_SUMMARY_V0_1_20260609.csv'
$StaticPacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_20260609.md'
$StaticPacketReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_RECEIPT_V0_1_20260609.txt'
$SelectorReportPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
$V04RiskCsvPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_4_20260609.csv'
$V04CloseoutPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_4_20260609.md'
$V04ReceiptPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_4_20260609.txt'

$OutputIndexCsvPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$OutputIndexMdPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_V0_1_20260609.md'
$OutputIndexPrintPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedSelectedBatchSha = '2B27276D9B580AFDD883387BB755F2C5DC808B7C861A05C5160E7A0549316C13'
$ExpectedStaticSummarySha = 'BFEAF1DF2F09BE1C6C193A293AF029DB5EF61CFCF89227C6A6F781602F31716D'
$ExpectedStaticPacketSha = '36355621C2874541AB806B286202EDA6DDFD2E63539C5676EB78F8445486DB23'
$ExpectedStaticPacketReceiptSha = '766FC59AB439FCA184BF1A7AC1E283F61D6EFBF5165B5AD2237ED6013F0F8537'
$ExpectedSelectorReportSha = '89152B0A51615FD6606FEE7B1CC27513EDC3D09FE242414A381920AF4291B8D5'
$ExpectedSelectorReceiptSha = 'BC9BF014B380FBB9405D5D072A23EA2DF93731F78D6DD0100CC308A318806C9B'
$ExpectedV04RiskCsvSha = '79F3EBD5DA7541D3422FFC21C2FC57B01A941780FB91DAB9E9B4D07C4B39C74B'
$ExpectedV04CloseoutSha = '81FA4190769520E4324D40FE6820C7B1322475B62EFD9E86B03A92235C28F3A4'
$ExpectedV04ReceiptSha = '1BA6FB6E39633C8D6759580B1433928719C5C8C74E8F0C7743AA94DBD365FDEE'

function Get-Sha256Upper {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing required file: $Path" }
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

function Write-LinesUtf8 {
    param([Parameter(Mandatory=$true)][string]$Path, $Lines)
    if ($null -eq $Lines) { $Lines = @() }
    $safeLines = @()
    foreach ($line in $Lines) {
        if ($null -eq $line) { $safeLines += '' } else { $safeLines += [string]$line }
    }
    [System.IO.File]::WriteAllLines($Path, [string[]]$safeLines, [System.Text.UTF8Encoding]::new($false))
}

function Import-CsvSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing CSV: $Path" }
    $rows = Import-Csv -LiteralPath $Path
    if ($null -eq $rows) { return @() }
    return $rows
}

function Count-Rows {
    param($Rows)
    $count = 0
    foreach ($row in $Rows) { $count++ }
    return $count
}

function Get-PropValue {
    param($Row, [string[]]$Names, [string]$Default = '')
    if ($null -eq $Row) { return $Default }
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
    param($Value)
    if ($null -eq $Value) { return $false }
    $v = ([string]$Value).Trim().ToLowerInvariant()
    if ([string]::IsNullOrWhiteSpace($v)) { return $false }
    return @('true','1','yes','y','present','found','review_only','risk','risk_marker') -contains $v
}

function Count-Where {
    param($Rows, [scriptblock]$Predicate)
    $count = 0
    foreach ($row in $Rows) {
        if (& $Predicate $row) { $count++ }
    }
    return $count
}

function Row-Key {
    param($Row)
    $ticket = Get-PropValue -Row $Row -Names @('TicketID','TicketId','ticket_id')
    $file = Get-PropValue -Row $Row -Names @('FileName','Name','file_name')
    if (-not [string]::IsNullOrWhiteSpace($ticket)) { return "TICKET::$ticket" }
    return "FILE::$file"
}

function Escape-Md {
    param([string]$Text)
    if ($null -eq $Text) { return '' }
    return ($Text -replace '\|','/' -replace "`r",' ' -replace "`n",' ')
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Missing lane folder: $Lane" }

$selectedBatchSha = Assert-Hash -Path $SelectedBatchCsvPath -Expected $ExpectedSelectedBatchSha -Label 'HSRB-005 selected batch CSV V0.2'
$staticSummarySha = Assert-Hash -Path $StaticSummaryCsvPath -Expected $ExpectedStaticSummarySha -Label 'HSRB-005 static summary CSV V0.1'
$staticPacketSha = Assert-Hash -Path $StaticPacketMdPath -Expected $ExpectedStaticPacketSha -Label 'HSRB-005 static packet MD V0.1'
$staticPacketReceiptSha = Assert-Hash -Path $StaticPacketReceiptPath -Expected $ExpectedStaticPacketReceiptSha -Label 'HSRB-005 static packet receipt V0.1'
$selectorReportSha = Assert-Hash -Path $SelectorReportPath -Expected $ExpectedSelectorReportSha -Label 'HSRB-005 selector report V0.2'
$selectorReceiptSha = Assert-Hash -Path $SelectorReceiptPath -Expected $ExpectedSelectorReceiptSha -Label 'HSRB-005 selector receipt V0.2'
$v04RiskCsvSha = Assert-Hash -Path $V04RiskCsvPath -Expected $ExpectedV04RiskCsvSha -Label 'HSRB-005 V0.4 risk CSV'
$v04CloseoutSha = Assert-Hash -Path $V04CloseoutPath -Expected $ExpectedV04CloseoutSha -Label 'HSRB-005 V0.4 closeout MD'
$v04ReceiptSha = Assert-Hash -Path $V04ReceiptPath -Expected $ExpectedV04ReceiptSha -Label 'HSRB-005 V0.4 receipt'

$selectedRows = Import-CsvSafe -Path $SelectedBatchCsvPath
$summaryRows = Import-CsvSafe -Path $StaticSummaryCsvPath
$riskRows = Import-CsvSafe -Path $V04RiskCsvPath

$selectedBatchRows = Count-Rows -Rows $selectedRows
$summaryRowsCount = Count-Rows -Rows $summaryRows
$riskRowsCount = Count-Rows -Rows $riskRows

$summaryByKey = @{}
foreach ($row in $summaryRows) {
    $key = Row-Key -Row $row
    if (-not [string]::IsNullOrWhiteSpace($key) -and -not $summaryByKey.ContainsKey($key)) { $summaryByKey[$key] = $row }
}

$selectedByKey = @{}
foreach ($row in $selectedRows) {
    $key = Row-Key -Row $row
    if (-not [string]::IsNullOrWhiteSpace($key) -and -not $selectedByKey.ContainsKey($key)) { $selectedByKey[$key] = $row }
}

$indexRows = @()
foreach ($risk in $riskRows) {
    $key = Row-Key -Row $risk
    $summary = $null
    $selected = $null
    if ($summaryByKey.ContainsKey($key)) { $summary = $summaryByKey[$key] }
    if ($selectedByKey.ContainsKey($key)) { $selected = $selectedByKey[$key] }

    $ticket = Get-PropValue -Row $risk -Names @('TicketID','TicketId','ticket_id')
    if ([string]::IsNullOrWhiteSpace($ticket)) { $ticket = Get-PropValue -Row $summary -Names @('TicketID','TicketId','ticket_id') }
    if ([string]::IsNullOrWhiteSpace($ticket)) { $ticket = Get-PropValue -Row $selected -Names @('TicketID','TicketId','ticket_id') }

    $fileName = Get-PropValue -Row $risk -Names @('FileName','Name','file_name')
    if ([string]::IsNullOrWhiteSpace($fileName)) { $fileName = Get-PropValue -Row $summary -Names @('FileName','Name','file_name') }
    if ([string]::IsNullOrWhiteSpace($fileName)) { $fileName = Get-PropValue -Row $selected -Names @('FileName','Name','file_name') }

    $sourcePath = Get-PropValue -Row $risk -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path')
    if ([string]::IsNullOrWhiteSpace($sourcePath)) { $sourcePath = Get-PropValue -Row $summary -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path') }
    if ([string]::IsNullOrWhiteSpace($sourcePath)) { $sourcePath = Get-PropValue -Row $selected -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path') }

    $declaredSha = Get-PropValue -Row $risk -Names @('DeclaredSHA256','DeclaredSha256','SHA256','Sha256','SourceSHA256','SourceSha256')
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = Get-PropValue -Row $summary -Names @('DeclaredSHA256','DeclaredSha256','SHA256','Sha256','SourceSHA256','SourceSha256') }
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = Get-PropValue -Row $selected -Names @('DeclaredSHA256','DeclaredSha256','SHA256','Sha256','SourceSHA256','SourceSha256') }

    $actualSha = Get-PropValue -Row $risk -Names @('ActualSHA256','ActualSha256','ComputedSHA256','ComputedSha256','SourceSHA256','SourceSha256')
    if ([string]::IsNullOrWhiteSpace($actualSha)) { $actualSha = Get-PropValue -Row $summary -Names @('ActualSHA256','ActualSha256','ComputedSHA256','ComputedSha256','SourceSHA256','SourceSha256') }

    $hashMatch = $false
    if (-not [string]::IsNullOrWhiteSpace($declaredSha) -and -not [string]::IsNullOrWhiteSpace($actualSha)) {
        $hashMatch = ($declaredSha.ToUpperInvariant() -eq $actualSha.ToUpperInvariant())
    }

    $staticDisposition = Get-PropValue -Row $risk -Names @('StaticDisposition','Disposition','static_disposition') -Default 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY_REVIEW_ONLY'
    $bucket = Get-PropValue -Row $risk -Names @('DispositionBucket','disposition_bucket') -Default 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY__REVIEW_ONLY'
    if ([string]::IsNullOrWhiteSpace($bucket)) { $bucket = 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY__REVIEW_ONLY' }

    $hasCopy = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsCopyItem','contains_copy_item'))
    $hasGit = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsGitCommand','contains_git_command'))
    $hasMove = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsMoveItem','contains_move_item'))
    $hasRemove = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsRemoveItem','contains_remove_item'))
    $hasRename = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsRenameItem','contains_rename_item'))
    $hasStart = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsStartProcess','contains_start_process'))
    $hasInvoke = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsInvokeExpression','contains_invoke_expression'))
    $hasClipboard = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsSetClipboard','contains_set_clipboard'))

    $riskMarkerClass = Get-PropValue -Row $risk -Names @('RiskMarkerClass','risk_marker_class') -Default 'NO_RISK_MARKER__REVIEW_ONLY'
    $riskMarked = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('RiskMarked','risk_marked'))
    if (-not $riskMarked) { $riskMarked = $hasCopy -or $hasGit -or $hasClipboard -or $hasMove -or $hasRemove -or $hasRename -or $hasStart -or $hasInvoke }

    $impactCone = 'LOCAL_TO_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY__RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_BEFORE_ANY_EXECUTION'
    $downstream = 'CAN_FEED_HELPER_DISPOSITION_LEDGER_AND_LATER_ROUTE_PROPOSAL_ONLY_AFTER_FULL_REVIEW'
    $doesNotProve = 'DOES_NOT_PROVE_EXECUTION_ROUTE_CLEANUP_COMMIT_PUSH_OR_WHOLE_HOUSE_CLEARANCE'

    $indexRows += [pscustomobject][ordered]@{
        TicketID = $ticket
        FileName = $fileName
        SourcePath = $sourcePath
        StaticDisposition = $staticDisposition
        DispositionBucket = $bucket
        ReviewDecision = 'HOLD_AS_REVIEW_ONLY_EVIDENCE_NOT_EXECUTION_OR_ROUTE_AUTHORITY'
        RiskMarkerClass = $riskMarkerClass
        RiskMarked = [bool]$riskMarked
        ContainsCopyItem = [bool]$hasCopy
        ContainsGitCommand = [bool]$hasGit
        ContainsMoveItem = [bool]$hasMove
        ContainsRemoveItem = [bool]$hasRemove
        ContainsRenameItem = [bool]$hasRename
        ContainsStartProcess = [bool]$hasStart
        ContainsInvokeExpression = [bool]$hasInvoke
        ContainsSetClipboard = [bool]$hasClipboard
        DeclaredSHA256 = $declaredSha
        ActualSHA256 = $actualSha
        HashMatch = [bool]$hashMatch
        ExecutionClearance = 'NO'
        RouteClearance = 'NO'
        CleanupClearance = 'NO'
        DoctrinePromotion = 'NO'
        ActionNow = 'NO'
        RecursiveDryRunExpansionRequired = 'YES'
        ImpactCone = $impactCone
        DownstreamEffect = $downstream
        DoesNotProve = $doesNotProve
    }
}

$indexRowCount = Count-Rows -Rows $indexRows
$blankTicketIdCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.TicketID) }
$missingFilenameCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.FileName) }
$missingDeclaredShaCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.DeclaredSHA256) }
$missingActualShaCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.ActualSHA256) }
$sourceHashMismatchCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.HashMatch -ne $true }
$sourceMissingCount = Count-Where -Rows $indexRows -Predicate { param($r) (-not [string]::IsNullOrWhiteSpace([string]$r.SourcePath)) -and (-not (Test-Path -LiteralPath ([string]$r.SourcePath) -PathType Leaf)) }
$unknownDispositionBucketCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.DispositionBucket) -or ([string]$r.DispositionBucket) -match 'UNKNOWN' }
$rootHeldRouteOrHoldFamilyCount = Count-Where -Rows $indexRows -Predicate { param($r) ([string]$r.DispositionBucket) -eq 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY__REVIEW_ONLY' }
$containsCopyItemCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsCopyItem -eq $true }
$containsGitCommandCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsGitCommand -eq $true }
$containsMoveItemCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsMoveItem -eq $true }
$containsRemoveItemCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsRemoveItem -eq $true }
$containsRenameItemCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsRenameItem -eq $true }
$containsStartProcessCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsStartProcess -eq $true }
$containsInvokeExpressionCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsInvokeExpression -eq $true }
$containsSetClipboardCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsSetClipboard -eq $true }
$highRiskCommandMarkerRowCount = $containsMoveItemCount + $containsRemoveItemCount + $containsRenameItemCount + $containsStartProcessCount + $containsInvokeExpressionCount
$highRiskReviewOnlyMarkerCount = Count-Where -Rows $indexRows -Predicate { param($r) ([string]$r.RiskMarkerClass) -eq 'HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION' }
$riskMarkedRowCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.RiskMarked -eq $true }
$unclassifiedRiskMarkerCount = Count-Where -Rows $indexRows -Predicate { param($r) ($r.RiskMarked -eq $true) -and ([string]::IsNullOrWhiteSpace([string]$r.RiskMarkerClass) -or ([string]$r.RiskMarkerClass) -match 'UNKNOWN') }
$executionClearanceCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ExecutionClearance -ne 'NO' }
$routeClearanceCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.RouteClearance -ne 'NO' }
$cleanupClearanceCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.CleanupClearance -ne 'NO' }
$doctrinePromotionCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.DoctrinePromotion -ne 'NO' }
$actionNowNonNoCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ActionNow -ne 'NO' }
$recursiveDryRunExpansionRequiredCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.RecursiveDryRunExpansionRequired -eq 'YES' }
$wholeHouseClearanceCount = 0

$blockerCount = 0
if ($selectedBatchRows -ne 18) { $blockerCount++ }
if ($summaryRowsCount -ne 18) { $blockerCount++ }
if ($riskRowsCount -ne 18) { $blockerCount++ }
if ($indexRowCount -ne 18) { $blockerCount++ }
$blockerCount += $blankTicketIdCount
$blockerCount += $missingFilenameCount
$blockerCount += $missingDeclaredShaCount
$blockerCount += $missingActualShaCount
$blockerCount += $sourceHashMismatchCount
$blockerCount += $sourceMissingCount
$blockerCount += $unknownDispositionBucketCount
$blockerCount += $highRiskCommandMarkerRowCount
$blockerCount += $unclassifiedRiskMarkerCount
$blockerCount += $executionClearanceCount
$blockerCount += $routeClearanceCount
$blockerCount += $cleanupClearanceCount
$blockerCount += $doctrinePromotionCount
$blockerCount += $actionNowNonNoCount

$contractGatePassed = ($blockerCount -eq 0)
$nextSingleAction = if ($contractGatePassed) { 'BUILD_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_005_DISPOSITION_INDEX_BLOCKERS_NO_EXECUTION' }
$finalVerdict = if ($contractGatePassed) { 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_V0_1_WRITTEN_WITH_RECONCILED_REVIEW_ONLY_COPY_AND_GIT_MARKERS_RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_NO_PHYSICAL_ACTION' } else { 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }

$indexRows | Export-Csv -LiteralPath $OutputIndexCsvPath -NoTypeInformation -Encoding UTF8
$outputIndexCsvSha = Get-Sha256Upper -Path $OutputIndexCsvPath

$countLines = @(
    "contract_gate_passed: $contractGatePassed",
    'selected_batch_id: HSRB-005',
    "selected_batch_rows: $selectedBatchRows",
    "summary_rows: $summaryRowsCount",
    "risk_index_rows: $riskRowsCount",
    "index_rows: $indexRowCount",
    "blank_ticket_id_count: $blankTicketIdCount",
    "missing_filename_count: $missingFilenameCount",
    "missing_declared_sha256_count: $missingDeclaredShaCount",
    "missing_actual_sha256_count: $missingActualShaCount",
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
    "blocker_count: $blockerCount"
)

$md = @(
    '# HSRB-005 Root Held Route or Hold and Custody Family Disposition Index - No Execution - V0.1',
    '',
    'Status: DISPOSITION_INDEX / CONTRACT_FIRST / REVIEW_ONLY / RECURSIVE_DRY_RUN_EXPANSION_REQUIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH',
    '',
    '## Purpose',
    'Build the disposition index for HSRB-005 after the V0.4 micro-contract correction reconciled copy/git/move risk counts and corrected the V0.3 verdict overclaim.',
    '',
    '## Boundary',
    'This index organizes review evidence only. It does not authorize execution, routing, cleanup, commit, push, doctrine promotion, or whole-house clearance.',
    '',
    '## Recursive dry-run expansion gate',
    'HSRB-005 rows remain subject to recursive dry-run expansion. Passing this local/family index does not prove downstream helper safety, cross-room safety, or whole-house safety.',
    '',
    '## Verified input hashes',
    "- selected_batch_csv_sha256: $selectedBatchSha",
    "- static_summary_csv_sha256: $staticSummarySha",
    "- static_packet_md_sha256: $staticPacketSha",
    "- static_packet_receipt_sha256: $staticPacketReceiptSha",
    "- selector_report_sha256: $selectorReportSha",
    "- selector_receipt_sha256: $selectorReceiptSha",
    "- v0_4_risk_csv_sha256: $v04RiskCsvSha",
    "- v0_4_closeout_sha256: $v04CloseoutSha",
    "- v0_4_receipt_sha256: $v04ReceiptSha",
    '',
    '## Counts'
)
foreach ($line in $countLines) { $md += ('- ' + $line) }
$md += ''
$md += '## Index table'
$md += ''
$md += '| TicketID | FileName | DispositionBucket | RiskMarkerClass | Copy | Git | Move | RecursiveExpansion | SHA256 |'
$md += '| --- | --- | --- | --- | ---: | ---: | ---: | --- | --- |'
foreach ($row in $indexRows) {
    $md += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | {6} | {7} | `{8}` |' -f (Escape-Md $row.TicketID), (Escape-Md $row.FileName), (Escape-Md $row.DispositionBucket), (Escape-Md $row.RiskMarkerClass), $row.ContainsCopyItem, $row.ContainsGitCommand, $row.ContainsMoveItem, $row.RecursiveDryRunExpansionRequired, $row.DeclaredSHA256)
}
$md += ''
$md += '## Interpretation'
$md += '- HSRB-005 is root-held route-or-hold family review evidence only.'
$md += '- Copy and git markers are preserved as risk evidence; they grant no clearance.'
$md += '- Move/high-risk command markers are reconciled as zero in this corrected chain.'
$md += '- Recursive dry-run expansion remains required before any future helper or route proposal can claim wider safety.'
$md += ''
$md += '## Next single action'
$md += $nextSingleAction
$md += ''
$md += "Final verdict: $finalVerdict"
$md += ''
$md += 'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesUtf8 -Path $OutputIndexMdPath -Lines $md
Copy-Item -LiteralPath $OutputIndexMdPath -Destination $OutputIndexPrintPath -Force
$outputIndexMdSha = Get-Sha256Upper -Path $OutputIndexMdPath
$outputIndexPrintSha = Get-Sha256Upper -Path $OutputIndexPrintPath

$receipt = @(
    'HSRB-005 ROOT HELD ROUTE OR HOLD AND CUSTODY FAMILY DISPOSITION INDEX RECEIPT V0.1',
    "output_index_csv_path: $OutputIndexCsvPath",
    "output_index_csv_sha256: $outputIndexCsvSha",
    "output_index_md_path: $OutputIndexMdPath",
    "output_index_md_sha256: $outputIndexMdSha",
    "output_index_print_path: $OutputIndexPrintPath",
    "output_index_print_sha256: $outputIndexPrintSha",
    "selected_batch_id: HSRB-005",
    "selected_batch_rows: $selectedBatchRows",
    "index_rows: $indexRowCount",
    "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount",
    "whole_house_clearance_count: $wholeHouseClearanceCount",
    "blocker_count: $blockerCount",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $OutputReceiptPath -Lines $receipt
$outputReceiptSha = Get-Sha256Upper -Path $OutputReceiptPath

Write-Output '=== HSRB-005 ROOT HELD ROUTE OR HOLD AND CUSTODY FAMILY DISPOSITION INDEX V0.1 COMPLETE ==='
Write-Output "output_index_csv_path: $OutputIndexCsvPath"
Write-Output "output_index_csv_sha256: $outputIndexCsvSha"
Write-Output "output_index_md_path: $OutputIndexMdPath"
Write-Output "output_index_md_sha256: $outputIndexMdSha"
Write-Output "output_index_print_path: $OutputIndexPrintPath"
Write-Output "output_index_print_sha256: $outputIndexPrintSha"
Write-Output "output_receipt_path: $OutputReceiptPath"
Write-Output "output_receipt_sha256: $outputReceiptSha"
Write-Output "contract_gate_passed: $contractGatePassed"
Write-Output 'selected_batch_id: HSRB-005'
Write-Output "selected_batch_rows: $selectedBatchRows"
Write-Output "summary_rows: $summaryRowsCount"
Write-Output "risk_index_rows: $riskRowsCount"
Write-Output "index_rows: $indexRowCount"
Write-Output "blank_ticket_id_count: $blankTicketIdCount"
Write-Output "missing_filename_count: $missingFilenameCount"
Write-Output "missing_declared_sha256_count: $missingDeclaredShaCount"
Write-Output "missing_actual_sha256_count: $missingActualShaCount"
Write-Output "source_hash_mismatch_count: $sourceHashMismatchCount"
Write-Output "source_missing_count: $sourceMissingCount"
Write-Output "unknown_disposition_bucket_count: $unknownDispositionBucketCount"
Write-Output "root_held_route_or_hold_family_count: $rootHeldRouteOrHoldFamilyCount"
Write-Output "contains_copy_item_count: $containsCopyItemCount"
Write-Output "contains_git_command_count: $containsGitCommandCount"
Write-Output "contains_move_item_count: $containsMoveItemCount"
Write-Output "contains_remove_item_count: $containsRemoveItemCount"
Write-Output "contains_rename_item_count: $containsRenameItemCount"
Write-Output "contains_start_process_count: $containsStartProcessCount"
Write-Output "contains_invoke_expression_count: $containsInvokeExpressionCount"
Write-Output "contains_set_clipboard_count: $containsSetClipboardCount"
Write-Output "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount"
Write-Output "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount"
Write-Output "risk_marked_row_count: $riskMarkedRowCount"
Write-Output "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
Write-Output "execution_clearance_count: $executionClearanceCount"
Write-Output "route_clearance_count: $routeClearanceCount"
Write-Output "cleanup_clearance_count: $cleanupClearanceCount"
Write-Output "doctrine_promotion_count: $doctrinePromotionCount"
Write-Output "action_now_non_no_count: $actionNowNonNoCount"
Write-Output "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount"
Write-Output "whole_house_clearance_count: $wholeHouseClearanceCount"
Write-Output "blocker_count: $blockerCount"
Write-Output "next_single_action: $nextSingleAction"
Write-Output "final_verdict: $finalVerdict"
Write-Output 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
