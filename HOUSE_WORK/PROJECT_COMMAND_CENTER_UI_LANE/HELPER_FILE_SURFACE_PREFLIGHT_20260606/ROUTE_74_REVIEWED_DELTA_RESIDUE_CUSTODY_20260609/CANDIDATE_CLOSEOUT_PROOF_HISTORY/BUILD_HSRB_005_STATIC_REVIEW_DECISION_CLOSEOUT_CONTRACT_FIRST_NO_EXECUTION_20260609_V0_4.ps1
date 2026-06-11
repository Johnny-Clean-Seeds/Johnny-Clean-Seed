<#
BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_20260609_V0_4.ps1
Purpose: Correct HSRB-005 V0.3 closeout wording/count reconciliation after the V0.1 false-positive move-marker path and V0.3 overbroad final verdict language.
Scope: NO EXECUTION / NO ROUTE / NO CLEANUP / NO COMMIT / NO PUSH.
Repair class: micro-contract wording/count reconciliation; proves move/high-risk markers are zero according to the static summary and V0.3 risk index.
Design note: no typed list factories, no pipeline .Add(), no row-text fallback command scanning, blank-safe writer.
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

$V01RiskCsvPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'
$V01CloseoutPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_1_20260609.md'
$V01ReceiptPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$V03RiskCsvPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_3_20260609.csv'
$V03CloseoutPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_3_20260609.md'
$V03ReceiptPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_3_20260609.txt'

$V03CorrectionFreezePath = Join-Path $Lane 'ERROR_FREEZE__HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_3_HIGH_RISK_VERDICT_WORDING_OVERCLAIM_20260609.md'
$FixNotePath = Join-Path $Lane 'FIX_NOTE__HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_4_MICRO_CONTRACT_COUNT_AND_VERDICT_RECONCILIATION_20260609.md'
$FixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_4_REPAIR_20260609.txt'

$OutputRiskCsvPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_4_20260609.csv'
$OutputCloseoutPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_4_20260609.md'
$OutputCloseoutPrintPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_COPY_PRINT_V0_4_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_4_20260609.txt'

$ExpectedSelectedBatchSha = '2B27276D9B580AFDD883387BB755F2C5DC808B7C861A05C5160E7A0549316C13'
$ExpectedStaticSummarySha = 'BFEAF1DF2F09BE1C6C193A293AF029DB5EF61CFCF89227C6A6F781602F31716D'
$ExpectedStaticPacketSha = '36355621C2874541AB806B286202EDA6DDFD2E63539C5676EB78F8445486DB23'
$ExpectedStaticPacketReceiptSha = '766FC59AB439FCA184BF1A7AC1E283F61D6EFBF5165B5AD2237ED6013F0F8537'
$ExpectedSelectorReportSha = '89152B0A51615FD6606FEE7B1CC27513EDC3D09FE242414A381920AF4291B8D5'
$ExpectedSelectorReceiptSha = 'BC9BF014B380FBB9405D5D072A23EA2DF93731F78D6DD0100CC308A318806C9B'
$ExpectedV03RiskCsvSha = '79F3EBD5DA7541D3422FFC21C2FC57B01A941780FB91DAB9E9B4D07C4B39C74B'
$ExpectedV03CloseoutSha = 'F0A1BB7968DCC5E0B9D6A76A4565B64F90DDBB7E8AE68C1C952A54497FD50D0E'
$ExpectedV03ReceiptSha = '64DCC03BA1F57FDF442B6665C5D9D63BEB6DBED4E936F676E05E25BD062F4FA1'

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
    param([Parameter(Mandatory=$true)][string]$Path, $Lines)
    if ($null -eq $Lines) { $Lines = @() }
    $safeLines = @()
    foreach ($line in $Lines) {
        if ($null -eq $line) { $safeLines += '' } else { $safeLines += [string]$line }
    }
    [System.IO.File]::WriteAllLines($Path, [string[]]$safeLines, [System.Text.UTF8Encoding]::new($false))
}

function Import-CsvArray {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing CSV: $Path" }
    $rows = @(Import-Csv -LiteralPath $Path)
    return $rows
}

function Count-Rows { param($Rows) return (@($Rows) | Measure-Object).Count }

function Get-PropValue {
    param($Row, [string[]]$Names, [string]$Default = '')
    if ($null -eq $Row) { return $Default }
    $propNames = @($Row.PSObject.Properties.Name)
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

function Count-BoolColumn {
    param($Rows, [string[]]$Names)
    $count = 0
    foreach ($row in $Rows) {
        if (Convert-ToBoolFlag (Get-PropValue -Row $row -Names $Names)) { $count++ }
    }
    return $count
}

function Count-BlankColumn {
    param($Rows, [string[]]$Names)
    $count = 0
    foreach ($row in $Rows) {
        $value = Get-PropValue -Row $row -Names $Names
        if ([string]::IsNullOrWhiteSpace($value)) { $count++ }
    }
    return $count
}

function Count-ValueMatch {
    param($Rows, [string[]]$Names, [string]$Pattern)
    $count = 0
    foreach ($row in $Rows) {
        $value = Get-PropValue -Row $row -Names $Names
        if ($value -match $Pattern) { $count++ }
    }
    return $count
}

function Get-LineCountValue {
    param([string]$Path, [string]$Key)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 'MISSING' }
    $text = Get-Content -LiteralPath $Path -Raw
    $match = [regex]::Match($text, [regex]::Escape($Key) + '\s*:\s*(\d+)')
    if ($match.Success) { return $match.Groups[1].Value }
    return 'NOT_FOUND'
}

function Escape-Md { param([string]$Text) if ($null -eq $Text) { return '' } return ($Text -replace '\|','/' -replace "`r",' ' -replace "`n",' ') }

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Missing lane folder: $Lane" }

$selectedBatchSha = Assert-Hash -Path $SelectedBatchCsvPath -Expected $ExpectedSelectedBatchSha -Label 'HSRB-005 selected batch CSV V0.2'
$staticSummarySha = Assert-Hash -Path $StaticSummaryCsvPath -Expected $ExpectedStaticSummarySha -Label 'HSRB-005 static summary CSV V0.1'
$staticPacketSha = Assert-Hash -Path $StaticPacketMdPath -Expected $ExpectedStaticPacketSha -Label 'HSRB-005 static packet MD V0.1'
$staticPacketReceiptSha = Assert-Hash -Path $StaticPacketReceiptPath -Expected $ExpectedStaticPacketReceiptSha -Label 'HSRB-005 static packet receipt V0.1'
$selectorReportSha = Assert-Hash -Path $SelectorReportPath -Expected $ExpectedSelectorReportSha -Label 'HSRB-005 selector report V0.2'
$selectorReceiptSha = Assert-Hash -Path $SelectorReceiptPath -Expected $ExpectedSelectorReceiptSha -Label 'HSRB-005 selector receipt V0.2'
$v03RiskCsvSha = Assert-Hash -Path $V03RiskCsvPath -Expected $ExpectedV03RiskCsvSha -Label 'HSRB-005 V0.3 risk CSV'
$v03CloseoutSha = Assert-Hash -Path $V03CloseoutPath -Expected $ExpectedV03CloseoutSha -Label 'HSRB-005 V0.3 closeout MD'
$v03ReceiptSha = Assert-Hash -Path $V03ReceiptPath -Expected $ExpectedV03ReceiptSha -Label 'HSRB-005 V0.3 receipt'

$selectedRows = Import-CsvArray -Path $SelectedBatchCsvPath
$summaryRows = Import-CsvArray -Path $StaticSummaryCsvPath
$v03RiskRows = Import-CsvArray -Path $V03RiskCsvPath

$selectedBatchRows = Count-Rows $selectedRows
$summaryRowsCount = Count-Rows $summaryRows
$riskRowsCount = Count-Rows $v03RiskRows
if ($selectedBatchRows -ne 18) { throw "Unexpected selected batch row count: $selectedBatchRows expected 18" }
if ($summaryRowsCount -ne 18) { throw "Unexpected static summary row count: $summaryRowsCount expected 18" }
if ($riskRowsCount -ne 18) { throw "Unexpected V0.3 risk row count: $riskRowsCount expected 18" }

$summaryMoveCount = Count-BoolColumn -Rows $summaryRows -Names @('ContainsMoveItem','contains_move_item','HasMoveItem')
$summaryCopyCount = Count-BoolColumn -Rows $summaryRows -Names @('ContainsCopyItem','contains_copy_item','HasCopyItem')
$summaryGitCount = Count-BoolColumn -Rows $summaryRows -Names @('ContainsGitCommand','contains_git_command','HasGitCommand')
$summaryRemoveCount = Count-BoolColumn -Rows $summaryRows -Names @('ContainsRemoveItem','contains_remove_item','HasRemoveItem')
$summaryRenameCount = Count-BoolColumn -Rows $summaryRows -Names @('ContainsRenameItem','contains_rename_item','HasRenameItem')
$summaryStartCount = Count-BoolColumn -Rows $summaryRows -Names @('ContainsStartProcess','contains_start_process','HasStartProcess')
$summaryInvokeCount = Count-BoolColumn -Rows $summaryRows -Names @('ContainsInvokeExpression','contains_invoke_expression','HasInvokeExpression')
$summarySetClipboardCount = Count-BoolColumn -Rows $summaryRows -Names @('ContainsSetClipboard','contains_set_clipboard','HasSetClipboard')

$riskMoveCount = Count-BoolColumn -Rows $v03RiskRows -Names @('ContainsMoveItem','contains_move_item','HasMoveItem')
$riskCopyCount = Count-BoolColumn -Rows $v03RiskRows -Names @('ContainsCopyItem','contains_copy_item','HasCopyItem')
$riskGitCount = Count-BoolColumn -Rows $v03RiskRows -Names @('ContainsGitCommand','contains_git_command','HasGitCommand')
$riskRemoveCount = Count-BoolColumn -Rows $v03RiskRows -Names @('ContainsRemoveItem','contains_remove_item','HasRemoveItem')
$riskRenameCount = Count-BoolColumn -Rows $v03RiskRows -Names @('ContainsRenameItem','contains_rename_item','HasRenameItem')
$riskStartCount = Count-BoolColumn -Rows $v03RiskRows -Names @('ContainsStartProcess','contains_start_process','HasStartProcess')
$riskInvokeCount = Count-BoolColumn -Rows $v03RiskRows -Names @('ContainsInvokeExpression','contains_invoke_expression','HasInvokeExpression')
$riskSetClipboardCount = Count-BoolColumn -Rows $v03RiskRows -Names @('ContainsSetClipboard','contains_set_clipboard','HasSetClipboard')
$riskMarkedRowCount = Count-BoolColumn -Rows $v03RiskRows -Names @('RiskMarked','risk_marked')
$unclassifiedRiskMarkerCount = Count-BoolColumn -Rows $v03RiskRows -Names @('UnclassifiedRiskMarker','unclassified_risk_marker')
$executionClearanceCount = Count-ValueMatch -Rows $v03RiskRows -Names @('ExecutionClearance','execution_clearance') -Pattern '^(?!NO$).+'
$routeClearanceCount = Count-ValueMatch -Rows $v03RiskRows -Names @('RouteClearance','route_clearance') -Pattern '^(?!NO$).+'
$cleanupClearanceCount = Count-ValueMatch -Rows $v03RiskRows -Names @('CleanupClearance','cleanup_clearance') -Pattern '^(?!NO$).+'
$doctrinePromotionCount = Count-ValueMatch -Rows $v03RiskRows -Names @('DoctrinePromotion','doctrine_promotion') -Pattern '^(?!NO$).+'
$actionNowNonNoCount = Count-ValueMatch -Rows $v03RiskRows -Names @('ActionNow','action_now') -Pattern '^(?!NO$).+'

$missingTicketCount = Count-BlankColumn -Rows $v03RiskRows -Names @('TicketID','TicketId')
$missingFilenameCount = Count-BlankColumn -Rows $v03RiskRows -Names @('FileName','Name')
$missingDeclaredShaCount = Count-BlankColumn -Rows $v03RiskRows -Names @('DeclaredSHA256','DeclaredSha256')
$missingActualShaCount = Count-BlankColumn -Rows $v03RiskRows -Names @('ActualSHA256','ActualSha256','SourceSHA256','SourceSha256')
$unknownBucketCount = Count-ValueMatch -Rows $v03RiskRows -Names @('DispositionBucket','disposition_bucket') -Pattern 'UNKNOWN|^$'

$highRiskCommandMarkerRowCount = $riskMoveCount + $riskRemoveCount + $riskRenameCount + $riskStartCount + $riskInvokeCount
$highRiskReviewOnlyMarkerCount = Count-ValueMatch -Rows $v03RiskRows -Names @('RiskMarkerClass','risk_marker_class') -Pattern '^HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION$'

$v01MoveCount = Get-LineCountValue -Path $V01CloseoutPath -Key 'contains_move_item_count'
$v01HighRiskCount = Get-LineCountValue -Path $V01CloseoutPath -Key 'high_risk_command_marker_row_count'
$v01MissingActualShaCount = Get-LineCountValue -Path $V01CloseoutPath -Key 'missing_actual_sha256_count'

$v03CloseoutText = Get-Content -LiteralPath $V03CloseoutPath -Raw
$v03VerdictOverclaim = ($v03CloseoutText -match 'final_verdict: .*HIGH_RISK') -and ($highRiskCommandMarkerRowCount -eq 0)
$v03VerdictOverclaimCount = if ($v03VerdictOverclaim) { 1 } else { 0 }

$falsePositiveMoveFromV01Count = 'UNKNOWN'
if ($v01MoveCount -match '^\d+$') { $falsePositiveMoveFromV01Count = ([int]$v01MoveCount - $summaryMoveCount).ToString() }

$reconciliationMismatchCount = 0
if ($summaryMoveCount -ne $riskMoveCount) { $reconciliationMismatchCount++ }
if ($summaryCopyCount -ne $riskCopyCount) { $reconciliationMismatchCount++ }
if ($summaryGitCount -ne $riskGitCount) { $reconciliationMismatchCount++ }
if ($summaryRemoveCount -ne $riskRemoveCount) { $reconciliationMismatchCount++ }
if ($summaryRenameCount -ne $riskRenameCount) { $reconciliationMismatchCount++ }
if ($summaryStartCount -ne $riskStartCount) { $reconciliationMismatchCount++ }
if ($summaryInvokeCount -ne $riskInvokeCount) { $reconciliationMismatchCount++ }
if ($summarySetClipboardCount -ne $riskSetClipboardCount) { $reconciliationMismatchCount++ }

$blockerCount = 0
$blockerCount += $missingTicketCount
$blockerCount += $missingFilenameCount
$blockerCount += $missingDeclaredShaCount
$blockerCount += $missingActualShaCount
$blockerCount += $unknownBucketCount
$blockerCount += $unclassifiedRiskMarkerCount
$blockerCount += $executionClearanceCount
$blockerCount += $routeClearanceCount
$blockerCount += $cleanupClearanceCount
$blockerCount += $doctrinePromotionCount
$blockerCount += $actionNowNonNoCount
$blockerCount += $reconciliationMismatchCount

$contractGatePassed = ($blockerCount -eq 0)
$nextSingleAction = if ($contractGatePassed) { 'BUILD_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_005_V0_4_RECONCILIATION_BLOCKERS_NO_EXECUTION' }
$finalVerdict = if ($contractGatePassed) { 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_4_CORRECTED_RECONCILED_REVIEW_ONLY_COPY_AND_GIT_MARKERS_NO_HIGH_RISK_MARKERS_NO_PHYSICAL_ACTION' } else { 'HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_4_WRITTEN_WITH_RECONCILIATION_BLOCKERS_NO_PHYSICAL_ACTION' }

$freezeLines = @(
    '# ERROR FREEZE — HSRB-005 STATIC REVIEW DECISION CLOSEOUT V0.3 VERDICT WORDING OVERCLAIM',
    '',
    'Status: ERROR_FREEZE / MICRO_CONTRACT_WORDING_DEFECT / NO_PHYSICAL_ACTION',
    '',
    'Observed issue:',
    '- V0.3 contract data passed and reported contains_move_item_count: 0 and high_risk_command_marker_row_count: 0.',
    '- V0.3 final verdict still said CLASSIFIED_REVIEW_ONLY_HIGH_RISK_MARKERS, which overclaims high-risk markers when the reconciled count is zero.',
    '',
    'Interpretation:',
    '- V0.1 move/high-risk count was a false positive produced by broad row-text fallback scanning.',
    '- Static packet V0.1 and V0.3 risk CSV agree that HSRB-005 has copy/git markers but no move/high-risk command markers.',
    '- The correction is not to reintroduce the false-positive move count; the correction is to remove the high-risk overclaim from the verdict language.',
    '',
    "v0_1_reported_contains_move_item_count: $v01MoveCount",
    "v0_1_reported_high_risk_command_marker_row_count: $v01HighRiskCount",
    "v0_1_reported_missing_actual_sha256_count: $v01MissingActualShaCount",
    "static_summary_contains_move_item_count: $summaryMoveCount",
    "v0_3_risk_index_contains_move_item_count: $riskMoveCount",
    "v0_3_verdict_overclaim_count: $v03VerdictOverclaimCount",
    '',
    'Blocked interpretation: V0.3 did not authorize physical action, but its verdict wording was too broad and must not be carried forward uncorrected.'
)
Write-LinesUtf8 -Path $V03CorrectionFreezePath -Lines $freezeLines
$v03CorrectionFreezeSha = Get-Sha256Upper -Path $V03CorrectionFreezePath

$fixLines = @(
    '# FIX NOTE — HSRB-005 STATIC REVIEW DECISION CLOSEOUT V0.4',
    '',
    'Status: FIX_NOTE / MICRO_CONTRACT_RECONCILIATION_REPAIR / NO_PHYSICAL_ACTION',
    '',
    'V0.4 correction:',
    '- Treats V0.1 move/high-risk count as a false-positive row-text scanning defect unless confirmed by the static summary and V0.3 risk CSV.',
    '- Confirms static summary and V0.3 risk CSV both report zero move/high-risk markers.',
    '- Corrects the final verdict to name review-only copy/git markers, not high-risk markers.',
    '- Preserves no-execution, no-route, no-cleanup, no-doctrine, no-commit, and no-push boundaries.',
    '',
    'No physical action is authorized.'
)
Write-LinesUtf8 -Path $FixNotePath -Lines $fixLines
$fixNoteSha = Get-Sha256Upper -Path $FixNotePath

# Re-export the reconciled V0.3 risk rows under V0.4 custody after verification.
$v03RiskRows | Export-Csv -LiteralPath $OutputRiskCsvPath -NoTypeInformation -Encoding UTF8
$outputRiskCsvSha = Get-Sha256Upper -Path $OutputRiskCsvPath

$closeoutLines = @(
    '# HSRB-005 Static Review Decision Closeout Contract First V0.4',
    '',
    'Status: CONTRACT_FIRST_CLOSEOUT / MICRO_CONTRACT_RECONCILIATION_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Repair basis:',
    '- V0.1 had a custody-field mapping defect and a broad row-text fallback that produced false-positive move/high-risk counts.',
    '- V0.2 failed while writing freeze evidence because the writer was not blank-line safe.',
    '- V0.3 repaired the data gate but overclaimed high-risk markers in final verdict wording even though the reconciled high-risk count was zero.',
    '- V0.4 reconciles counts against the static summary and V0.3 risk CSV, then corrects the final verdict language.',
    '',
    'Input verification:',
    "selected_batch_csv_sha256: $selectedBatchSha",
    "static_summary_csv_sha256: $staticSummarySha",
    "static_packet_md_sha256: $staticPacketSha",
    "static_packet_receipt_sha256: $staticPacketReceiptSha",
    "selector_report_sha256: $selectorReportSha",
    "selector_receipt_sha256: $selectorReceiptSha",
    "v0_3_risk_csv_sha256: $v03RiskCsvSha",
    "v0_3_closeout_sha256: $v03CloseoutSha",
    "v0_3_receipt_sha256: $v03ReceiptSha",
    '',
    'Correction evidence:',
    "v0_3_correction_freeze_path: $V03CorrectionFreezePath",
    "v0_3_correction_freeze_sha256: $v03CorrectionFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    '',
    'Counts:',
    'selected_batch_id: HSRB-005',
    "selected_batch_rows: $selectedBatchRows",
    "summary_rows: $summaryRowsCount",
    "risk_index_rows: $riskRowsCount",
    "summary_contains_copy_item_count: $summaryCopyCount",
    "summary_contains_git_command_count: $summaryGitCount",
    "summary_contains_move_item_count: $summaryMoveCount",
    "risk_index_contains_copy_item_count: $riskCopyCount",
    "risk_index_contains_git_command_count: $riskGitCount",
    "risk_index_contains_move_item_count: $riskMoveCount",
    "contains_copy_item_count: $riskCopyCount",
    "contains_git_command_count: $riskGitCount",
    "contains_move_item_count: $riskMoveCount",
    "contains_remove_item_count: $riskRemoveCount",
    "contains_rename_item_count: $riskRenameCount",
    "contains_start_process_count: $riskStartCount",
    "contains_invoke_expression_count: $riskInvokeCount",
    "contains_set_clipboard_count: $riskSetClipboardCount",
    "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount",
    "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount",
    "risk_marked_row_count: $riskMarkedRowCount",
    "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount",
    "missing_ticket_id_count: $missingTicketCount",
    "missing_filename_count: $missingFilenameCount",
    "missing_declared_sha256_count: $missingDeclaredShaCount",
    "missing_actual_sha256_count: $missingActualShaCount",
    "unknown_disposition_bucket_count: $unknownBucketCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "doctrine_promotion_count: $doctrinePromotionCount",
    "action_now_non_no_count: $actionNowNonNoCount",
    "reconciliation_mismatch_count: $reconciliationMismatchCount",
    "v0_1_false_positive_move_from_row_text_count: $falsePositiveMoveFromV01Count",
    "v0_3_verdict_overclaim_count: $v03VerdictOverclaimCount",
    "blocker_count: $blockerCount",
    "contract_gate_passed: $contractGatePassed",
    '',
    'Risk interpretation:',
    '- HSRB-005 contains review-only copy/git markers.',
    '- Reconciled source evidence does not support carrying move/high-risk markers forward for HSRB-005.',
    '- No execution, route, cleanup, doctrine, commit, or push clearance is created.',
    '',
    'Risk marker index:',
    '',
    '| TicketID | FileName | RiskMarkerClass | Copy | Git | Move | ExecClearance | RouteClearance | CleanupClearance |',
    '|---|---|---|---:|---:|---:|---|---|---|'
)
foreach ($r in $v03RiskRows) {
    $closeoutLines += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | {6} | {7} | {8} |' -f (Escape-Md (Get-PropValue -Row $r -Names @('TicketID','TicketId'))), (Escape-Md (Get-PropValue -Row $r -Names @('FileName','Name'))), (Escape-Md (Get-PropValue -Row $r -Names @('RiskMarkerClass'))), (Get-PropValue -Row $r -Names @('ContainsCopyItem')), (Get-PropValue -Row $r -Names @('ContainsGitCommand')), (Get-PropValue -Row $r -Names @('ContainsMoveItem')), (Get-PropValue -Row $r -Names @('ExecutionClearance')), (Get-PropValue -Row $r -Names @('RouteClearance')), (Get-PropValue -Row $r -Names @('CleanupClearance')))
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
    'HSRB-005 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.4 RECEIPT',
    "v0_3_correction_freeze_path: $V03CorrectionFreezePath",
    "v0_3_correction_freeze_sha256: $v03CorrectionFreezeSha",
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $fixNoteSha",
    "output_risk_csv_path: $OutputRiskCsvPath",
    "output_risk_csv_sha256: $outputRiskCsvSha",
    "output_closeout_path: $OutputCloseoutPath",
    "output_closeout_sha256: $outputCloseoutSha",
    "output_closeout_print_path: $OutputCloseoutPrintPath",
    "output_closeout_print_sha256: $outputCloseoutPrintSha",
    "contract_gate_passed: $contractGatePassed",
    'selected_batch_id: HSRB-005',
    "selected_batch_rows: $selectedBatchRows",
    "summary_rows: $summaryRowsCount",
    "risk_index_rows: $riskRowsCount",
    "contains_copy_item_count: $riskCopyCount",
    "contains_git_command_count: $riskGitCount",
    "contains_move_item_count: $riskMoveCount",
    "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount",
    "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount",
    "risk_marked_row_count: $riskMarkedRowCount",
    "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "doctrine_promotion_count: $doctrinePromotionCount",
    "action_now_non_no_count: $actionNowNonNoCount",
    "reconciliation_mismatch_count: $reconciliationMismatchCount",
    "v0_1_false_positive_move_from_row_text_count: $falsePositiveMoveFromV01Count",
    "v0_3_verdict_overclaim_count: $v03VerdictOverclaimCount",
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

Write-Host '=== HSRB-005 STATIC REVIEW DECISION CLOSEOUT CONTRACT FIRST V0.4 COMPLETE ==='
Write-Host "v0_3_correction_freeze_path: $V03CorrectionFreezePath"
Write-Host "v0_3_correction_freeze_sha256: $v03CorrectionFreezeSha"
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
Write-Host "risk_index_rows: $riskRowsCount"
Write-Host "summary_contains_copy_item_count: $summaryCopyCount"
Write-Host "summary_contains_git_command_count: $summaryGitCount"
Write-Host "summary_contains_move_item_count: $summaryMoveCount"
Write-Host "risk_index_contains_copy_item_count: $riskCopyCount"
Write-Host "risk_index_contains_git_command_count: $riskGitCount"
Write-Host "risk_index_contains_move_item_count: $riskMoveCount"
Write-Host "contains_copy_item_count: $riskCopyCount"
Write-Host "contains_git_command_count: $riskGitCount"
Write-Host "contains_move_item_count: $riskMoveCount"
Write-Host "contains_remove_item_count: $riskRemoveCount"
Write-Host "contains_rename_item_count: $riskRenameCount"
Write-Host "contains_start_process_count: $riskStartCount"
Write-Host "contains_invoke_expression_count: $riskInvokeCount"
Write-Host "contains_set_clipboard_count: $riskSetClipboardCount"
Write-Host "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount"
Write-Host "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount"
Write-Host "risk_marked_row_count: $riskMarkedRowCount"
Write-Host "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
Write-Host "missing_ticket_id_count: $missingTicketCount"
Write-Host "missing_filename_count: $missingFilenameCount"
Write-Host "missing_declared_sha256_count: $missingDeclaredShaCount"
Write-Host "missing_actual_sha256_count: $missingActualShaCount"
Write-Host "unknown_disposition_bucket_count: $unknownBucketCount"
Write-Host "execution_clearance_count: $executionClearanceCount"
Write-Host "route_clearance_count: $routeClearanceCount"
Write-Host "cleanup_clearance_count: $cleanupClearanceCount"
Write-Host "doctrine_promotion_count: $doctrinePromotionCount"
Write-Host "action_now_non_no_count: $actionNowNonNoCount"
Write-Host "reconciliation_mismatch_count: $reconciliationMismatchCount"
Write-Host "v0_1_false_positive_move_from_row_text_count: $falsePositiveMoveFromV01Count"
Write-Host "v0_3_verdict_overclaim_count: $v03VerdictOverclaimCount"
Write-Host "blocker_count: $blockerCount"
Write-Host "next_single_action: $nextSingleAction"
Write-Host "final_verdict: $finalVerdict"
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
