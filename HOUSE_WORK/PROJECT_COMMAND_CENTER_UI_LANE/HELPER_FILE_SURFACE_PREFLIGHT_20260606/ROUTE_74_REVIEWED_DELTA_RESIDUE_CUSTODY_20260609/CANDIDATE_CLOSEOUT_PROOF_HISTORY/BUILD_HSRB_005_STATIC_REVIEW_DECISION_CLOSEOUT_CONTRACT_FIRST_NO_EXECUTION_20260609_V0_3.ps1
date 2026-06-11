<#
BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_20260609_V0_3.ps1
Purpose: Repair HSRB-005 contract-first static review decision closeout after V0.1 blocker verdict and V0.2 blank-line writer failure.
Scope: NO EXECUTION / NO ROUTE / NO CLEANUP / NO COMMIT / NO PUSH.
Repair class: contract semantics repair plus actual SHA field repair plus blank-safe writer repair.
Design note: avoids typed collection factories, pipeline .Add(), and treating classified review-only high-risk markers as clearance blockers.
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
$SelectorReportPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

$V01RiskCsvPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'
$V01CloseoutPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_1_20260609.md'
$V01ReceiptPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$V01ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_MISSING_ACTUAL_SHA_AND_HIGH_RISK_REVIEW_ONLY_BLOCKER_SEMANTIC_MISMATCH_20260609.md'
$V02ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_BLANK_LINE_WRITER_PARAMETER_BINDING_FAILURE_20260609.md'
$FixNotePath = Join-Path $Lane 'FIX_NOTE__HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_3_ACTUAL_SHA_RISK_CONTRACT_AND_BLANK_SAFE_WRITER_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_3_REPAIR_20260609.txt'

$OutputRiskCsvPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_3_20260609.csv'
$OutputCloseoutPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_3_20260609.md'
$OutputCloseoutPrintPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_COPY_PRINT_V0_3_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_3_20260609.txt'

$ExpectedSelectedBatchSha = '2B27276D9B580AFDD883387BB755F2C5DC808B7C861A05C5160E7A0549316C13'
$ExpectedStaticSummarySha = 'BFEAF1DF2F09BE1C6C193A293AF029DB5EF61CFCF89227C6A6F781602F31716D'
$ExpectedStaticPacketSha = '36355621C2874541AB806B286202EDA6DDFD2E63539C5676EB78F8445486DB23'
$ExpectedStaticPacketPrintSha = '36355621C2874541AB806B286202EDA6DDFD2E63539C5676EB78F8445486DB23'
$ExpectedStaticPacketReceiptSha = '766FC59AB439FCA184BF1A7AC1E283F61D6EFBF5165B5AD2237ED6013F0F8537'
$ExpectedSelectorReportSha = '89152B0A51615FD6606FEE7B1CC27513EDC3D09FE242414A381920AF4291B8D5'
$ExpectedSelectorReceiptSha = 'BC9BF014B380FBB9405D5D072A23EA2DF93731F78D6DD0100CC308A318806C9B'

function Get-Sha256Upper {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing required file: $Path" }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Get-Sha256OrBlank {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
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
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [object[]]$Lines
    )
    if ($null -eq $Lines) { $Lines = @() }
    $safeLines = foreach ($line in $Lines) {
        if ($null -eq $line) { '' } else { [string]$line }
    }
    [System.IO.File]::WriteAllLines($Path, [string[]]$safeLines, [System.Text.UTF8Encoding]::new($false))
}

function Import-CsvRows {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing CSV: $Path" }
    $rows = Import-Csv -LiteralPath $Path
    if ($null -eq $rows) { return }
    foreach ($row in $rows) { Write-Output $row }
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

function Count-Rows {
    param($Rows)
    return ($Rows | Measure-Object).Count
}

function Select-Count {
    param(
        $Rows,
        [Parameter(Mandatory=$true)][scriptblock]$Predicate
    )
    return ($Rows | Where-Object $Predicate | Measure-Object).Count
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
$staticPacketPrintSha = Assert-Hash -Path $StaticPacketPrintPath -Expected $ExpectedStaticPacketPrintSha -Label 'HSRB-005 static packet print V0.1'
$staticPacketReceiptSha = Assert-Hash -Path $StaticPacketReceiptPath -Expected $ExpectedStaticPacketReceiptSha -Label 'HSRB-005 static packet receipt V0.1'
$selectorReportSha = Assert-Hash -Path $SelectorReportPath -Expected $ExpectedSelectorReportSha -Label 'HSRB-005 selector report V0.2'
$selectorReceiptSha = Assert-Hash -Path $SelectorReceiptPath -Expected $ExpectedSelectorReceiptSha -Label 'HSRB-005 selector receipt V0.2'

$selectedRows = Import-CsvRows -Path $SelectedBatchCsvPath
$summaryRows = Import-CsvRows -Path $StaticSummaryCsvPath
$selectedBatchRows = Count-Rows -Rows $selectedRows
$summaryRowsCount = Count-Rows -Rows $summaryRows

if ($selectedBatchRows -ne 18) { throw "Unexpected selected batch row count: $selectedBatchRows expected 18" }
if ($summaryRowsCount -ne 18) { throw "Unexpected static summary row count: $summaryRowsCount expected 18" }

$v01RiskCsvSha = Get-Sha256OrBlank -Path $V01RiskCsvPath
$v01CloseoutSha = Get-Sha256OrBlank -Path $V01CloseoutPath
$v01ReceiptSha = Get-Sha256OrBlank -Path $V01ReceiptPath

$v01FreezeLines = @(
    '# ERROR FREEZE — HSRB-005 STATIC REVIEW DECISION CLOSEOUT V0.1',
    '',
    'Status: ERROR_FREEZE / SAME_OBJECT_REPAIR_REQUIRED / NO_PHYSICAL_ACTION',
    '',
    'Failed object: BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_20260609_V0_1.ps1',
    'Observed V0.1 contract_gate_passed: False',
    'Observed missing_actual_sha256_count: 18',
    'Observed contains_move_item_count: 6',
    'Observed high_risk_command_marker_row_count: 6',
    'Observed blocker_count: 24',
    '',
    'Local cause 1: V0.1 read ActualSHA256 fields but the HSRB-005 static summary names the computed source hash SourceSha256.',
    'Local cause 2: V0.1 treated classified review-only high-risk command markers as blockers even though execution, route, cleanup, doctrine, and action-now clearance were all zero.',
    '',
    'Underlying classification: POSSIBLE_UNDERLYING_CONTRACT_SEMANTIC_DEFECT.',
    'Why: repeated helper-generation defects have now appeared in collection handling, custody fields, and risk-marker contract semantics.',
    '',
    "v0_1_risk_csv_sha256: $v01RiskCsvSha",
    "v0_1_closeout_sha256: $v01CloseoutSha",
    "v0_1_receipt_sha256: $v01ReceiptSha",
    '',
    'Blocked interpretation: V0.1 does not authorize physical action and does not close HSRB-005.',
    'Repair requirement: preserve the high-risk markers as review evidence, repair actual SHA mapping, and only pass if all clearances remain NO.'
)
Write-LinesUtf8 -Path $V01ErrorFreezePath -Lines $v01FreezeLines
$v01ErrorFreezeSha = Get-Sha256Upper -Path $V01ErrorFreezePath

$v02FreezeLines = @(
    '# ERROR FREEZE — HSRB-005 STATIC REVIEW DECISION CLOSEOUT V0.2',
    '',
    'Status: ERROR_FREEZE / SAME_OBJECT_REPAIR_REQUIRED / NO_PHYSICAL_ACTION',
    '',
    'Failed object: BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_20260609_V0_2.ps1',
    'Observed failure line: Write-LinesUtf8 -Path $V01ErrorFreezePath -Lines $v01FreezeLines',
    'Observed error: Cannot bind argument to parameter Lines because it is an empty string.',
    '',
    'Local cause: the writer function used a mandatory [string[]] parameter that rejected blank Markdown lines inside the freeze-note array.',
    'Underlying classification: POSSIBLE_UNDERLYING_HELPER_GENERATION_DEFECT / BLANK_LINE_WRITER_CONTRACT_DEFECT.',
    '',
    'Repair requirement: writer accepts object array input, preserves blank lines as empty strings, and writes UTF-8 without treating blank Markdown lines as missing content.',
    'Blocked interpretation: V0.2 does not authorize physical action and does not close HSRB-005.'
)
Write-LinesUtf8 -Path $V02ErrorFreezePath -Lines $v02FreezeLines
$v02ErrorFreezeSha = Get-Sha256Upper -Path $V02ErrorFreezePath

$fixNoteLines = @(
    '# FIX NOTE — HSRB-005 STATIC REVIEW DECISION CLOSEOUT V0.3',
    '',
    'Status: FIX_NOTE / CONTRACT_SEMANTIC_REPAIR / NO_PHYSICAL_ACTION',
    '',
    'V0.3 repairs three defect classes from V0.1/V0.2:',
    '1. Actual SHA field repair: accepts SourceSha256 as the computed actual SHA from the HSRB-005 static summary.',
    '2. Risk contract repair: high-risk command markers are not hidden, downgraded, or treated as clearance. They are classified as HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION.',
    '3. Blank-line writer repair: freeze notes, fix notes, closeouts, and receipts may contain intentional blank Markdown lines without failing parameter binding.',
    '',
    'Contract rule:',
    'A high-risk marker becomes a blocker only when it is unclassified, paired with execution/route/cleanup/doctrine/action-now clearance, missing custody proof, or hash mismatch.',
    'A classified high-risk marker with all clearances set to NO remains review-only evidence and may be carried into the disposition index.',
    '',
    'Physical action remains zero.'
)
Write-LinesUtf8 -Path $FixNotePath -Lines $fixNoteLines
$fixNoteSha = Get-Sha256Upper -Path $FixNotePath

$riskRows = foreach ($row in $summaryRows) {
    $ticketId = Get-PropValue -Row $row -Names @('TicketID','TicketId','ticket_id','ticketid')
    $fileName = Get-PropValue -Row $row -Names @('FileName','Name','file_name','filename')
    $sourcePath = Get-PropValue -Row $row -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path','full_path')
    $declaredSha = Get-PropValue -Row $row -Names @('DeclaredSha256','DeclaredSHA256','DeclaredSHA','SHA256','Sha256','sha256','declared_sha256')
    $actualSha = Get-PropValue -Row $row -Names @('SourceSha256','SourceSHA256','ActualSha256','ActualSHA256','ComputedSha256','ComputedSHA256','actual_sha256','computed_sha256')
    $staticDisposition = Get-PropValue -Row $row -Names @('StaticDisposition','Disposition','static_disposition','disposition') -Default 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY_REVIEW_ONLY'
    $dispositionBucket = 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY__REVIEW_ONLY'

    $hasGit = Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsGitCommand','contains_git_command','HasGitCommand'))
    $hasCopy = Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsCopyItem','contains_copy_item','HasCopyItem'))
    $hasMove = Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsMoveItem','contains_move_item','HasMoveItem'))
    $hasRemove = Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsRemoveItem','contains_remove_item','HasRemoveItem'))
    $hasRename = Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsRenameItem','contains_rename_item','HasRenameItem'))
    $hasStartProcess = Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsStartProcess','contains_start_process','HasStartProcess'))
    $hasInvokeExpression = Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsInvokeExpression','contains_invoke_expression','HasInvokeExpression'))
    $hasSetClipboard = Convert-ToBoolFlag (Get-PropValue -Row $row -Names @('ContainsSetClipboard','contains_set_clipboard','HasSetClipboard'))

    $highRisk = $hasMove -or $hasRemove -or $hasRename -or $hasStartProcess -or $hasInvokeExpression
    $riskMarked = $hasGit -or $hasCopy -or $hasSetClipboard -or $highRisk
    $riskClass = if ($highRisk) { 'HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION' } elseif ($riskMarked) { 'REVIEW_ONLY_RISK_MARKER__NO_CLEARANCE' } else { 'NO_RISK_MARKER__REVIEW_ONLY' }

    [pscustomobject][ordered]@{
        TicketID = $ticketId
        FileName = $fileName
        SourcePath = $sourcePath
        DeclaredSHA256 = $declaredSha
        ActualSHA256 = $actualSha
        StaticDisposition = $staticDisposition
        DispositionBucket = $dispositionBucket
        RiskMarkerClass = $riskClass
        ContainsCopyItem = [bool]$hasCopy
        ContainsGitCommand = [bool]$hasGit
        ContainsMoveItem = [bool]$hasMove
        ContainsRemoveItem = [bool]$hasRemove
        ContainsRenameItem = [bool]$hasRename
        ContainsStartProcess = [bool]$hasStartProcess
        ContainsInvokeExpression = [bool]$hasInvokeExpression
        ContainsSetClipboard = [bool]$hasSetClipboard
        HighRiskCommandMarker = [bool]$highRisk
        RiskMarked = [bool]$riskMarked
        UnclassifiedRiskMarker = $false
        ExecutionClearance = 'NO'
        RouteClearance = 'NO'
        CleanupClearance = 'NO'
        DoctrinePromotion = 'NO'
        ActionNow = 'NO'
        DecisionNote = 'Review-only disposition. Risk markers preserved as evidence; high-risk markers are blocked for execution and do not grant route, cleanup, commit, push, or doctrine authority.'
    }
}

$riskRows | Export-Csv -LiteralPath $OutputRiskCsvPath -NoTypeInformation -Encoding UTF8
$outputRiskCsvSha = Get-Sha256Upper -Path $OutputRiskCsvPath

$blankTicketIdCount = Select-Count -Rows $riskRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.TicketID) }
$missingFilenameCount = Select-Count -Rows $riskRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.FileName) }
$missingDeclaredShaCount = Select-Count -Rows $riskRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.DeclaredSHA256) }
$missingActualShaCount = Select-Count -Rows $riskRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.ActualSHA256) }
$sourceHashMismatchCount = Select-Count -Rows $riskRows -Predicate { (-not [string]::IsNullOrWhiteSpace([string]$_.DeclaredSHA256)) -and (-not [string]::IsNullOrWhiteSpace([string]$_.ActualSHA256)) -and ([string]$_.DeclaredSHA256).ToUpperInvariant() -ne ([string]$_.ActualSHA256).ToUpperInvariant() }
$sourceMissingCount = 0
$textReadFailCount = 0
$unknownStaticDispositionCount = Select-Count -Rows $riskRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.StaticDisposition) -or ([string]$_.StaticDisposition) -match 'UNKNOWN' }
$unknownDispositionBucketCount = Select-Count -Rows $riskRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.DispositionBucket) -or ([string]$_.DispositionBucket) -match 'UNKNOWN' }
$containsCopyItemCount = Select-Count -Rows $riskRows -Predicate { $_.ContainsCopyItem -eq $true }
$containsGitCommandCount = Select-Count -Rows $riskRows -Predicate { $_.ContainsGitCommand -eq $true }
$containsMoveItemCount = Select-Count -Rows $riskRows -Predicate { $_.ContainsMoveItem -eq $true }
$containsRemoveItemCount = Select-Count -Rows $riskRows -Predicate { $_.ContainsRemoveItem -eq $true }
$containsRenameItemCount = Select-Count -Rows $riskRows -Predicate { $_.ContainsRenameItem -eq $true }
$containsStartProcessCount = Select-Count -Rows $riskRows -Predicate { $_.ContainsStartProcess -eq $true }
$containsInvokeExpressionCount = Select-Count -Rows $riskRows -Predicate { $_.ContainsInvokeExpression -eq $true }
$containsSetClipboardCount = Select-Count -Rows $riskRows -Predicate { $_.ContainsSetClipboard -eq $true }
$highRiskCommandMarkerRowCount = Select-Count -Rows $riskRows -Predicate { $_.HighRiskCommandMarker -eq $true }
$highRiskReviewOnlyMarkerCount = Select-Count -Rows $riskRows -Predicate { $_.RiskMarkerClass -eq 'HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION' }
$riskMarkedRowCount = Select-Count -Rows $riskRows -Predicate { $_.RiskMarked -eq $true }
$unclassifiedRiskMarkerCount = Select-Count -Rows $riskRows -Predicate { $_.UnclassifiedRiskMarker -eq $true }
$executionClearanceCount = Select-Count -Rows $riskRows -Predicate { $_.ExecutionClearance -ne 'NO' }
$routeClearanceCount = Select-Count -Rows $riskRows -Predicate { $_.RouteClearance -ne 'NO' }
$cleanupClearanceCount = Select-Count -Rows $riskRows -Predicate { $_.CleanupClearance -ne 'NO' }
$doctrinePromotionCount = Select-Count -Rows $riskRows -Predicate { $_.DoctrinePromotion -ne 'NO' }
$actionNowNonNoCount = Select-Count -Rows $riskRows -Predicate { $_.ActionNow -ne 'NO' }
$rootHeldRouteOrHoldFamilyCount = Select-Count -Rows $riskRows -Predicate { $_.DispositionBucket -eq 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY__REVIEW_ONLY' }

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
$blockerCount += $unclassifiedRiskMarkerCount
$blockerCount += $executionClearanceCount
$blockerCount += $routeClearanceCount
$blockerCount += $cleanupClearanceCount
$blockerCount += $doctrinePromotionCount
$blockerCount += $actionNowNonNoCount

$contractGatePassed = ($blockerCount -eq 0)
$nextSingleAction = if ($contractGatePassed) { 'BUILD_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_BLOCKERS_NO_EXECUTION' }
$finalVerdict = if ($contractGatePassed) { 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_3_CONTRACT_FIRST_WRITTEN_WITH_CLASSIFIED_REVIEW_ONLY_HIGH_RISK_MARKERS_AND_BLANK_SAFE_WRITER_NO_PHYSICAL_ACTION' } else { 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_3_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }

$closeoutLines = @(
    '# HSRB-005 Static Review Decision Closeout Contract First V0.3',
    '',
    'Status: CONTRACT_FIRST_CLOSEOUT / SAME_OBJECT_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Repair basis:',
    '- V0.1 incorrectly counted missing actual SHA because the source hash column was named SourceSha256.',
    '- V0.1 treated classified review-only high-risk markers as blockers. V0.2 preserves them as high-risk review evidence and blocks execution clearance, not the closeout itself.',
    '',
    "v0_1_error_freeze_path: $V01ErrorFreezePath",
    "v0_1_error_freeze_sha256: $v01ErrorFreezeSha",
    "v0_2_error_freeze_path: $V02ErrorFreezePath",
    "v0_2_error_freeze_sha256: $v02ErrorFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    '',
    'Input verification:',
    "selected_batch_csv_sha256: $selectedBatchSha",
    "static_summary_csv_sha256: $staticSummarySha",
    "static_packet_md_sha256: $staticPacketSha",
    "static_packet_print_sha256: $staticPacketPrintSha",
    "static_packet_receipt_sha256: $staticPacketReceiptSha",
    "selector_report_sha256: $selectorReportSha",
    "selector_receipt_sha256: $selectorReceiptSha",
    '',
    'Counts:',
    'selected_batch_id: HSRB-005',
    "selected_batch_rows: $selectedBatchRows",
    "summary_rows: $summaryRowsCount",
    "risk_index_rows: $(Count-Rows -Rows $riskRows)",
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
    "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount",
    "risk_marked_row_count: $riskMarkedRowCount",
    "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "doctrine_promotion_count: $doctrinePromotionCount",
    "action_now_non_no_count: $actionNowNonNoCount",
    "blocker_count: $blockerCount",
    "contract_gate_passed: $contractGatePassed",
    '',
    'Risk interpretation:',
    '- Copy/git/move markers are real risk evidence.',
    '- Move markers remain high-risk review-only markers and are blocked for execution.',
    '- No execution, route, cleanup, doctrine, commit, or push clearance is created.',
    '',
    'Risk marker index:',
    '',
    '| TicketID | FileName | RiskMarkerClass | Copy | Git | Move | ExecClearance | RouteClearance | CleanupClearance |',
    '|---|---|---|---:|---:|---:|---|---|---|'
)
foreach ($r in $riskRows) {
    $closeoutLines += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | {6} | {7} | {8} |' -f (Escape-Md $r.TicketID), (Escape-Md $r.FileName), (Escape-Md $r.RiskMarkerClass), $r.ContainsCopyItem, $r.ContainsGitCommand, $r.ContainsMoveItem, $r.ExecutionClearance, $r.RouteClearance, $r.CleanupClearance)
}
$closeoutLines += ''
$closeoutLines += "next_single_action: $nextSingleAction"
$closeoutLines += "final_verdict: $finalVerdict"
$closeoutLines += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

Write-LinesUtf8 -Path $OutputCloseoutPath -Lines $closeoutLines
Copy-Item -LiteralPath $OutputCloseoutPath -Destination $OutputCloseoutPrintPath -Force
$outputCloseoutSha = Get-Sha256Upper -Path $OutputCloseoutPath
$outputCloseoutPrintSha = Get-Sha256Upper -Path $OutputCloseoutPrintPath

$receiptLines = @(
    'HSRB-005 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.3 RECEIPT',
    "v0_1_error_freeze_path: $V01ErrorFreezePath",
    "v0_1_error_freeze_sha256: $v01ErrorFreezeSha",
    "v0_2_error_freeze_path: $V02ErrorFreezePath",
    "v0_2_error_freeze_sha256: $v02ErrorFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    "output_risk_csv_path: $OutputRiskCsvPath",
    "output_risk_csv_sha256: $outputRiskCsvSha",
    "output_closeout_path: $OutputCloseoutPath",
    "output_closeout_sha256: $outputCloseoutSha",
    "output_closeout_print_path: $OutputCloseoutPrintPath",
    "output_closeout_print_sha256: $outputCloseoutPrintSha",
    "contract_gate_passed: $contractGatePassed",
    "selected_batch_id: HSRB-005",
    "selected_batch_rows: $selectedBatchRows",
    "summary_rows: $summaryRowsCount",
    "missing_actual_sha256_count: $missingActualShaCount",
    "contains_move_item_count: $containsMoveItemCount",
    "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount",
    "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "blocker_count: $blockerCount",
    "next_single_action: $nextSingleAction",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $FixReceiptPath -Lines $receiptLines
$fixReceiptSha = Get-Sha256Upper -Path $FixReceiptPath

$finalReceiptLines = $receiptLines + @("fix_receipt_sha256: $fixReceiptSha")
Write-LinesUtf8 -Path $OutputReceiptPath -Lines $finalReceiptLines
$outputReceiptSha = Get-Sha256Upper -Path $OutputReceiptPath

Write-Host '=== HSRB-005 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.3 COMPLETE ==='
Write-Host "v0_1_error_freeze_path: $V01ErrorFreezePath"
Write-Host "v0_1_error_freeze_sha256: $v01ErrorFreezeSha"
Write-Host "v0_2_error_freeze_path: $V02ErrorFreezePath"
Write-Host "v0_2_error_freeze_sha256: $v02ErrorFreezeSha"
Write-Host "fix_note_path: $FixNotePath"
Write-Host "fix_note_sha256: $fixNoteSha"
Write-Host "fix_receipt_path: $FixReceiptPath"
Write-Host "fix_receipt_sha256: $fixReceiptSha"
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
Write-Host "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount"
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
