Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$Stamp = '20260609'
$BatchId = 'HSRB-006'
$BatchName = 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY'

$QueueCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$HsrB005CloseoutPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$HsrB005CloseoutReceiptPath = Join-Path $Lane 'HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedQueueSha = '791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43'
$ExpectedHsrB005CloseoutSha = '98A29925F960444199860BE7E9042CB71F67306C3299F91D50703D1B429686D1'
$ExpectedHsrB005CloseoutReceiptSha = '45BFED946102983DCE6E95DF30A95ABEB4A83EB21D39A3304D3DE19ABF935258'

$PreviousSelectedCsvPaths = @(
    (Join-Path $Lane 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_001_V0_1_20260609.csv'),
    (Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_002_V0_1_20260609.csv'),
    (Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_003_V0_2_20260609.csv'),
    (Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_004_V0_1_20260609.csv'),
    (Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_005_V0_2_20260609.csv')
)

$OutSelectedCsv = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_006_V0_1_20260609.csv'
$OutRemainingCsv = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_REMAINING_AFTER_001_005_V0_1_20260609.csv'
$OutMd = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$OutPrint = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutReceipt = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Write-LinesUtf8 {
    param([Parameter(Mandatory=$true)][string]$Path, [AllowNull()][object]$Lines)
    $safeLines = @()
    if ($null -ne $Lines) {
        foreach ($line in $Lines) { $safeLines += [string]$line }
    }
    Set-Content -LiteralPath $Path -Value $safeLines -Encoding UTF8
}

function Get-Sha256Safe {
    param([AllowNull()][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Convert-ToSafeArray {
    param([AllowNull()][object]$Value)
    if ($null -eq $Value) { return [object[]]::new(0) }
    if ($Value -is [System.Array]) { return [object[]]$Value }
    return [object[]](,$Value)
}

function Get-Cell {
    param($Row, [string[]]$Names)
    if ($null -eq $Row) { return '' }
    $props = $Row.PSObject.Properties
    foreach ($name in $Names) {
        foreach ($p in $props) {
            if ($p.Name -ieq $name) {
                if ($null -eq $p.Value) { return '' }
                return [string]$p.Value
            }
        }
    }
    foreach ($name in $Names) {
        $want = ($name -replace '[^A-Za-z0-9]', '').ToLowerInvariant()
        foreach ($p in $props) {
            $have = ($p.Name -replace '[^A-Za-z0-9]', '').ToLowerInvariant()
            if ($have -eq $want) {
                if ($null -eq $p.Value) { return '' }
                return [string]$p.Value
            }
        }
    }
    return ''
}

function Get-FileNameCell {
    param($Row)
    $v = Get-Cell -Row $Row -Names @('FileName','Filename','File','Name','SourceFileName','SourceName','ItemName')
    if (-not [string]::IsNullOrWhiteSpace($v)) { return [System.IO.Path]::GetFileName($v.Trim().Trim('"')) }
    $p = Get-Cell -Row $Row -Names @('SourcePath','Path','FullName','FullPath','LiteralPath')
    if (-not [string]::IsNullOrWhiteSpace($p)) { return [System.IO.Path]::GetFileName($p.Trim().Trim('"')) }
    return ''
}

function Resolve-SourcePath {
    param($Row, [string]$FileName)
    foreach ($name in 'SourcePath','FullPath','Path','LiteralPath','FullName') {
        $candidate = Get-Cell -Row $Row -Names @($name)
        if (-not [string]::IsNullOrWhiteSpace($candidate)) { return $candidate.Trim().Trim('"') }
    }
    if ([string]::IsNullOrWhiteSpace($FileName)) { return '' }
    return (Join-Path $Root $FileName)
}

function Get-ReviewDecision {
    param($Row)
    $v = Get-Cell -Row $Row -Names @('UserDecision','Decision','ManualDecision','ReviewDecision','Disposition')
    if ([string]::IsNullOrWhiteSpace($v)) { return '' }
    return $v.Trim().ToUpperInvariant()
}

function Get-TicketId {
    param($Row)
    return (Get-Cell -Row $Row -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID','ReviewTicketID','RowID','RowId','ID')).Trim()
}

function Get-QueueKey {
    param($Row)
    $ticket = Get-TicketId -Row $Row
    $fileName = Get-FileNameCell -Row $Row
    $sha = Get-Cell -Row $Row -Names @('SourceSha256','SourceSHA256','DeclaredSha256','DeclaredSHA256','SHA256','Sha256','Hash','FileSHA256','ActualSha256','ActualSHA256')
    if (-not [string]::IsNullOrWhiteSpace($ticket)) { return ('TICKET::{0}' -f $ticket.ToUpperInvariant()) }
    return ('FILE_SHA::{0}::{1}' -f $fileName.ToUpperInvariant(), $sha.ToUpperInvariant())
}

function Get-TextOrBlank {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    try { return [System.IO.File]::ReadAllText($Path) } catch { return '' }
}

function Add-KeyIfPresent {
    param([hashtable]$Table, [string]$Key)
    if (-not [string]::IsNullOrWhiteSpace($Key)) { $Table[$Key] = $true }
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }
if (-not (Test-Path -LiteralPath $QueueCsvPath -PathType Leaf)) { throw "Queue CSV not found: $QueueCsvPath" }

$QueueSha = Get-Sha256Safe -Path $QueueCsvPath
$HsrB005CloseoutSha = Get-Sha256Safe -Path $HsrB005CloseoutPath
$HsrB005CloseoutReceiptSha = Get-Sha256Safe -Path $HsrB005CloseoutReceiptPath

$InputQueueVerified = ($QueueSha -eq $ExpectedQueueSha)
$HsrB005CloseoutVerified = ($HsrB005CloseoutSha -eq $ExpectedHsrB005CloseoutSha)
$HsrB005CloseoutReceiptVerified = ($HsrB005CloseoutReceiptSha -eq $ExpectedHsrB005CloseoutReceiptSha)

$importedQueueRows = Import-Csv -LiteralPath $QueueCsvPath
$queueRows = Convert-ToSafeArray -Value $importedQueueRows

$previousKeys = @{}
$previousSelectedFilesFound = 0
$previousSelectedRowsSeen = 0
foreach ($path in $PreviousSelectedCsvPaths) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { continue }
    $previousSelectedFilesFound += 1
    $rows = Convert-ToSafeArray -Value (Import-Csv -LiteralPath $path)
    foreach ($row in $rows) {
        $key = Get-QueueKey -Row $row
        Add-KeyIfPresent -Table $previousKeys -Key $key
        $previousSelectedRowsSeen += 1
    }
}

$selectedRows = @()
$remainingRows = @()
foreach ($row in $queueRows) {
    $decision = Get-ReviewDecision -Row $row
    if ($decision -ne 'REVIEW') { continue }
    $key = Get-QueueKey -Row $row
    if ($previousKeys.ContainsKey($key)) { continue }

    $fileName = Get-FileNameCell -Row $row
    $ticket = Get-TicketId -Row $row
    $sourcePath = Resolve-SourcePath -Row $row -FileName $fileName
    $sourcePresent = $false
    if (-not [string]::IsNullOrWhiteSpace($sourcePath)) { $sourcePresent = Test-Path -LiteralPath $sourcePath -PathType Leaf }

    $declaredSha = Get-Cell -Row $row -Names @('SourceSha256','SourceSHA256','DeclaredSha256','DeclaredSHA256','SHA256','Sha256','Hash','FileSHA256')
    $actualSha = ''
    if ($sourcePresent) { $actualSha = Get-Sha256Safe -Path $sourcePath }
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = $actualSha }

    $roleLabel = Get-Cell -Row $row -Names @('OriginalRoleLabel','RoleLabel','Role','BoardClass','Class','ReviewRole')
    $riskLabel = Get-Cell -Row $row -Names @('OriginalRiskLabel','RiskLabel','Risk','RiskClass')
    $actionNow = Get-Cell -Row $row -Names @('ActionNow','Action','ActionStatus')
    if ([string]::IsNullOrWhiteSpace($actionNow)) { $actionNow = 'NO' }

    $text = Get-TextOrBlank -Path $sourcePath
    $containsGit = $false
    $containsMove = $false
    $containsRemove = $false
    $containsRename = $false
    $containsCopy = $false
    $containsStartProcess = $false
    $containsInvokeExpression = $false
    $containsSetClipboard = $false
    if (-not [string]::IsNullOrWhiteSpace($text)) {
        $containsGit = ($text -match '(?im)(^|[^A-Za-z0-9_-])git(\s|\.|$)')
        $containsMove = ($text -match '(?im)\bMove-Item\b')
        $containsRemove = ($text -match '(?im)\bRemove-Item\b')
        $containsRename = ($text -match '(?im)\bRename-Item\b')
        $containsCopy = ($text -match '(?im)\bCopy-Item\b')
        $containsStartProcess = ($text -match '(?im)\bStart-Process\b')
        $containsInvokeExpression = ($text -match '(?im)\bInvoke-Expression\b|\biex\b')
        $containsSetClipboard = ($text -match '(?im)\bSet-Clipboard\b')
    }

    $highRisk = ($containsMove -or $containsRemove -or $containsRename -or $containsStartProcess -or $containsInvokeExpression)
    $riskMarked = ($containsGit -or $containsMove -or $containsRemove -or $containsRename -or $containsCopy -or $containsStartProcess -or $containsInvokeExpression -or $containsSetClipboard)
    $riskDisposition = if ($highRisk) { 'REVIEW_ONLY_HIGH_RISK_MARKER__NOT_CLEARED' } elseif ($riskMarked) { 'REVIEW_ONLY_RISK_MARKER__NOT_CLEARED_FOR_EXECUTION' } else { 'REVIEW_ONLY_NO_RISK_COMMAND_MARKER_DETECTED' }

    $rowOut = [pscustomobject][ordered]@{
        BatchID = $BatchId
        BatchName = $BatchName
        TicketID = [string]$ticket
        FileName = [string]$fileName
        SourcePath = [string]$sourcePath
        SourcePresent = [bool]$sourcePresent
        DeclaredSha256 = [string]$declaredSha
        ActualSha256 = [string]$actualSha
        SourceHashMatch = [bool]((-not [string]::IsNullOrWhiteSpace($declaredSha)) -and (-not [string]::IsNullOrWhiteSpace($actualSha)) -and ($declaredSha -eq $actualSha))
        RoleLabel = [string]$roleLabel
        RiskLabel = [string]$riskLabel
        UserDecision = [string]$decision
        ActionNow = [string]$actionNow
        StaticReviewOnly = 'YES'
        ExecutionAllowed = 'NO'
        RouteAllowed = 'NO'
        CleanupAllowed = 'NO'
        DoctrinePromotionAllowed = 'NO'
        ContainsGitCommand = [bool]$containsGit
        ContainsMoveItem = [bool]$containsMove
        ContainsRemoveItem = [bool]$containsRemove
        ContainsRenameItem = [bool]$containsRename
        ContainsCopyItem = [bool]$containsCopy
        ContainsStartProcess = [bool]$containsStartProcess
        ContainsInvokeExpression = [bool]$containsInvokeExpression
        ContainsSetClipboard = [bool]$containsSetClipboard
        HighRiskCommandMarker = [bool]$highRisk
        RiskMarked = [bool]$riskMarked
        RiskDisposition = [string]$riskDisposition
        ReviewDisposition = 'REVIEW_ONLY__REMAINING_HELPER_REVIEW_QUEUE_FAMILY'
        RecursiveDryRunExpansionRequired = 'YES'
        WholeHouseClearance = 'NO'
        DoesNotProve = 'Does not prove helper is safe outside impact cone; does not authorize execution, route, cleanup, commit, push, or doctrine promotion.'
    }
    $remainingRows += $rowOut
}

# HSRB-006 deliberately selects all remaining REVIEW rows after HSRB-001 through HSRB-005.
# This is a selector/review surface only, not whole-house clearance.
foreach ($r in $remainingRows) { $selectedRows += $r }

$selectedCount = $selectedRows.Count
$reviewRowsCount = 0
foreach ($row in $queueRows) { if ((Get-ReviewDecision -Row $row) -eq 'REVIEW') { $reviewRowsCount += 1 } }

if ($selectedCount -gt 0) { $selectedRows | Export-Csv -LiteralPath $OutSelectedCsv -NoTypeInformation -Encoding UTF8 }
else {
    [pscustomobject][ordered]@{ BatchID = $BatchId; BatchName = $BatchName; EmptySelection = 'TRUE'; Reason = 'No remaining REVIEW rows after prior selected batches.' } | Export-Csv -LiteralPath $OutSelectedCsv -NoTypeInformation -Encoding UTF8
}

if ($remainingRows.Count -gt 0) { $remainingRows | Export-Csv -LiteralPath $OutRemainingCsv -NoTypeInformation -Encoding UTF8 }
else {
    [pscustomobject][ordered]@{ BatchID = $BatchId; RemainingRows = 0; Note = 'No remaining rows.' } | Export-Csv -LiteralPath $OutRemainingCsv -NoTypeInformation -Encoding UTF8
}

$sourcePresentCount = 0
$sourceMissingCount = 0
$blankTicketCount = 0
$missingFileNameCount = 0
$missingDeclaredShaCount = 0
$missingActualShaCount = 0
$sourceHashMismatchCount = 0
$reviewOnlyCount = 0
$actionNowNonNoCount = 0
$containsGitCount = 0
$containsMoveCount = 0
$containsRemoveCount = 0
$containsRenameCount = 0
$containsCopyCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
$containsSetClipboardCount = 0
$highRiskCount = 0
$riskMarkedCount = 0
$unclassifiedRiskCount = 0
$recursiveDryRunRequiredCount = 0
$wholeHouseClearanceCount = 0
foreach ($row in $selectedRows) {
    if ($row.SourcePresent) { $sourcePresentCount += 1 } else { $sourceMissingCount += 1 }
    if ([string]::IsNullOrWhiteSpace([string]$row.TicketID)) { $blankTicketCount += 1 }
    if ([string]::IsNullOrWhiteSpace([string]$row.FileName)) { $missingFileNameCount += 1 }
    if ([string]::IsNullOrWhiteSpace([string]$row.DeclaredSha256)) { $missingDeclaredShaCount += 1 }
    if ([string]::IsNullOrWhiteSpace([string]$row.ActualSha256)) { $missingActualShaCount += 1 }
    if ((-not [string]::IsNullOrWhiteSpace([string]$row.DeclaredSha256)) -and (-not [string]::IsNullOrWhiteSpace([string]$row.ActualSha256)) -and ([string]$row.DeclaredSha256 -ne [string]$row.ActualSha256)) { $sourceHashMismatchCount += 1 }
    if ([string]$row.StaticReviewOnly -eq 'YES') { $reviewOnlyCount += 1 }
    if (([string]$row.ActionNow).Trim().ToUpperInvariant() -ne 'NO') { $actionNowNonNoCount += 1 }
    if ($row.ContainsGitCommand) { $containsGitCount += 1 }
    if ($row.ContainsMoveItem) { $containsMoveCount += 1 }
    if ($row.ContainsRemoveItem) { $containsRemoveCount += 1 }
    if ($row.ContainsRenameItem) { $containsRenameCount += 1 }
    if ($row.ContainsCopyItem) { $containsCopyCount += 1 }
    if ($row.ContainsStartProcess) { $containsStartProcessCount += 1 }
    if ($row.ContainsInvokeExpression) { $containsInvokeExpressionCount += 1 }
    if ($row.ContainsSetClipboard) { $containsSetClipboardCount += 1 }
    if ($row.HighRiskCommandMarker) { $highRiskCount += 1 }
    if ($row.RiskMarked) { $riskMarkedCount += 1 }
    if (($row.RiskMarked) -and ([string]::IsNullOrWhiteSpace([string]$row.RiskDisposition))) { $unclassifiedRiskCount += 1 }
    if ([string]$row.RecursiveDryRunExpansionRequired -eq 'YES') { $recursiveDryRunRequiredCount += 1 }
    if ([string]$row.WholeHouseClearance -eq 'YES') { $wholeHouseClearanceCount += 1 }
}

$blockers = @()
if (-not $InputQueueVerified) { $blockers += 'INPUT_QUEUE_HASH_MISMATCH_OR_MISSING' }
if (-not $HsrB005CloseoutVerified) { $blockers += 'HSRB_005_CLOSEOUT_HASH_MISMATCH_OR_MISSING' }
if (-not $HsrB005CloseoutReceiptVerified) { $blockers += 'HSRB_005_CLOSEOUT_RECEIPT_HASH_MISMATCH_OR_MISSING' }
if ($previousSelectedFilesFound -lt 5) { $blockers += ('PREVIOUS_SELECTED_BATCH_FILES_FOUND_{0}_EXPECTED_5' -f $previousSelectedFilesFound) }
if ($selectedCount -le 0) { $blockers += 'NO_REMAINING_REVIEW_ROWS_SELECTED' }
if ($sourceMissingCount -gt 0) { $blockers += ('SOURCE_MISSING_COUNT_{0}' -f $sourceMissingCount) }
if ($blankTicketCount -gt 0) { $blockers += ('BLANK_TICKET_ID_COUNT_{0}' -f $blankTicketCount) }
if ($missingFileNameCount -gt 0) { $blockers += ('MISSING_FILENAME_COUNT_{0}' -f $missingFileNameCount) }
if ($missingDeclaredShaCount -gt 0) { $blockers += ('MISSING_DECLARED_SHA256_COUNT_{0}' -f $missingDeclaredShaCount) }
if ($missingActualShaCount -gt 0) { $blockers += ('MISSING_ACTUAL_SHA256_COUNT_{0}' -f $missingActualShaCount) }
if ($sourceHashMismatchCount -gt 0) { $blockers += ('SOURCE_HASH_MISMATCH_COUNT_{0}' -f $sourceHashMismatchCount) }
if ($unclassifiedRiskCount -gt 0) { $blockers += ('UNCLASSIFIED_RISK_MARKER_COUNT_{0}' -f $unclassifiedRiskCount) }
if ($actionNowNonNoCount -gt 0) { $blockers += ('ACTION_NOW_NON_NO_COUNT_{0}' -f $actionNowNonNoCount) }
if ($wholeHouseClearanceCount -gt 0) { $blockers += ('WHOLE_HOUSE_CLEARANCE_NONZERO_{0}' -f $wholeHouseClearanceCount) }

$blockerCount = $blockers.Count
$contractGatePassed = ($blockerCount -eq 0)
$nextSingleAction = if ($contractGatePassed) { 'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_006_SELECTOR_BLOCKERS_NO_EXECUTION' }
$finalVerdict = if ($contractGatePassed) { 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_V0_1_WRITTEN_WITH_REMAINING_REVIEW_ROWS_RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_NO_PHYSICAL_ACTION' } else { 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }

$selectedCsvSha = Get-Sha256Safe -Path $OutSelectedCsv
$remainingCsvSha = Get-Sha256Safe -Path $OutRemainingCsv

$mdLines = @()
$mdLines += '# HELPER SCRIPT REVIEW NEXT BATCH SELECTOR — HSRB-006 FROM 64 QUEUE V0.1'
$mdLines += ''
$mdLines += 'Status: SELECTOR / NO_EXECUTION / RECURSIVE_DRY_RUN_EXPANSION_BOUNDARY / NOT_ROUTE_AUTHORITY'
$mdLines += ''
$mdLines += "selected_batch_id: $BatchId"
$mdLines += "selected_batch_name: $BatchName"
$mdLines += "input_queue_verified: $InputQueueVerified"
$mdLines += "hsrb_005_closeout_verified: $HsrB005CloseoutVerified"
$mdLines += "hsrb_005_closeout_receipt_verified: $HsrB005CloseoutReceiptVerified"
$mdLines += "previous_selected_batch_files_found: $previousSelectedFilesFound"
$mdLines += "previous_selected_rows_seen: $previousSelectedRowsSeen"
$mdLines += "queue_review_rows: $reviewRowsCount"
$mdLines += "selected_batch_rows: $selectedCount"
$mdLines += ''
$mdLines += '## NO-ACTION BOUNDARY'
$mdLines += 'This object only selects the next static review batch from remaining REVIEW rows. It does not authorize helper execution, routing, cleanup, commit, push, or doctrine promotion.'
$mdLines += ''
$mdLines += '## RECURSIVE DRY-RUN EXPANSION NOTE'
$mdLines += 'Every selected row remains local-review evidence only. Recursive dry-run expansion is required before any helper output can be trusted outside its impact cone.'
$mdLines += ''
$mdLines += '## COUNTS'
$mdLines += "source_present_count: $sourcePresentCount"
$mdLines += "source_missing_count: $sourceMissingCount"
$mdLines += "blank_ticket_id_count: $blankTicketCount"
$mdLines += "missing_filename_count: $missingFileNameCount"
$mdLines += "missing_declared_sha256_count: $missingDeclaredShaCount"
$mdLines += "missing_actual_sha256_count: $missingActualShaCount"
$mdLines += "source_hash_mismatch_count: $sourceHashMismatchCount"
$mdLines += "review_only_count: $reviewOnlyCount"
$mdLines += "contains_git_command_count: $containsGitCount"
$mdLines += "contains_move_item_count: $containsMoveCount"
$mdLines += "contains_remove_item_count: $containsRemoveCount"
$mdLines += "contains_rename_item_count: $containsRenameCount"
$mdLines += "contains_copy_item_count: $containsCopyCount"
$mdLines += "contains_start_process_count: $containsStartProcessCount"
$mdLines += "contains_invoke_expression_count: $containsInvokeExpressionCount"
$mdLines += "contains_set_clipboard_count: $containsSetClipboardCount"
$mdLines += "high_risk_command_marker_row_count: $highRiskCount"
$mdLines += "risk_marked_row_count: $riskMarkedCount"
$mdLines += "unclassified_risk_marker_count: $unclassifiedRiskCount"
$mdLines += "action_now_non_no_count: $actionNowNonNoCount"
$mdLines += "recursive_dry_run_expansion_required_count: $recursiveDryRunRequiredCount"
$mdLines += "whole_house_clearance_count: $wholeHouseClearanceCount"
$mdLines += "blocker_count: $blockerCount"
$mdLines += ''
$mdLines += '## BLOCKERS'
if ($blockers.Count -eq 0) { $mdLines += '- none' } else { foreach ($b in $blockers) { $mdLines += "- $b" } }
$mdLines += ''
$mdLines += "next_single_action: $nextSingleAction"
$mdLines += "final_verdict: $finalVerdict"
$mdLines += "physical_actions: move=$PhysicalMoves delete=$PhysicalDeletes rename=$PhysicalRenames route=$PhysicalRoutes execute=$PhysicalExecutes commit=$PhysicalCommits push=$PhysicalPushes"
Write-LinesUtf8 -Path $OutMd -Lines $mdLines
Copy-Item -LiteralPath $OutMd -Destination $OutPrint -Force
$outMdSha = Get-Sha256Safe -Path $OutMd
$outPrintSha = Get-Sha256Safe -Path $OutPrint

$receiptLines = @()
$receiptLines += 'HASH RECEIPT — HSRB-006 NEXT BATCH SELECTOR V0.1'
$receiptLines += "output_selected_batch_csv_path: $OutSelectedCsv"
$receiptLines += "output_selected_batch_csv_sha256: $selectedCsvSha"
$receiptLines += "output_remaining_csv_path: $OutRemainingCsv"
$receiptLines += "output_remaining_csv_sha256: $remainingCsvSha"
$receiptLines += "output_md_path: $OutMd"
$receiptLines += "output_md_sha256: $outMdSha"
$receiptLines += "output_print_path: $OutPrint"
$receiptLines += "output_print_sha256: $outPrintSha"
$receiptLines += "contract_gate_passed: $contractGatePassed"
$receiptLines += "selected_batch_id: $BatchId"
$receiptLines += "selected_batch_rows: $selectedCount"
$receiptLines += "blocker_count: $blockerCount"
$receiptLines += "physical_actions: move=$PhysicalMoves delete=$PhysicalDeletes rename=$PhysicalRenames route=$PhysicalRoutes execute=$PhysicalExecutes commit=$PhysicalCommits push=$PhysicalPushes"
Write-LinesUtf8 -Path $OutReceipt -Lines $receiptLines
$outReceiptSha = Get-Sha256Safe -Path $OutReceipt

Write-Host '=== HELPER SCRIPT REVIEW NEXT BATCH SELECTOR HSRB-006 FROM 64 QUEUE V0.1 COMPLETE ==='
Write-Host "output_selected_batch_csv_path: $OutSelectedCsv"
Write-Host "output_selected_batch_csv_sha256: $selectedCsvSha"
Write-Host "output_remaining_csv_path: $OutRemainingCsv"
Write-Host "output_remaining_csv_sha256: $remainingCsvSha"
Write-Host "output_md_path: $OutMd"
Write-Host "output_md_sha256: $outMdSha"
Write-Host "output_print_path: $OutPrint"
Write-Host "output_print_sha256: $outPrintSha"
Write-Host "output_receipt_path: $OutReceipt"
Write-Host "output_receipt_sha256: $outReceiptSha"
Write-Host "contract_gate_passed: $contractGatePassed"
Write-Host "input_queue_verified: $InputQueueVerified"
Write-Host "hsrb_005_closeout_verified: $HsrB005CloseoutVerified"
Write-Host "hsrb_005_closeout_receipt_verified: $HsrB005CloseoutReceiptVerified"
Write-Host "previous_selected_batch_files_found: $previousSelectedFilesFound"
Write-Host "previous_selected_rows_seen: $previousSelectedRowsSeen"
Write-Host "selected_batch_id: $BatchId"
Write-Host "selected_batch_rows: $selectedCount"
Write-Host "queue_review_rows: $reviewRowsCount"
Write-Host "source_present_count: $sourcePresentCount"
Write-Host "source_missing_count: $sourceMissingCount"
Write-Host "blank_ticket_id_count: $blankTicketCount"
Write-Host "missing_filename_count: $missingFileNameCount"
Write-Host "missing_declared_sha256_count: $missingDeclaredShaCount"
Write-Host "missing_actual_sha256_count: $missingActualShaCount"
Write-Host "source_hash_mismatch_count: $sourceHashMismatchCount"
Write-Host "review_only_count: $reviewOnlyCount"
Write-Host "contains_git_command_count: $containsGitCount"
Write-Host "contains_move_item_count: $containsMoveCount"
Write-Host "contains_remove_item_count: $containsRemoveCount"
Write-Host "contains_rename_item_count: $containsRenameCount"
Write-Host "contains_copy_item_count: $containsCopyCount"
Write-Host "contains_start_process_count: $containsStartProcessCount"
Write-Host "contains_invoke_expression_count: $containsInvokeExpressionCount"
Write-Host "contains_set_clipboard_count: $containsSetClipboardCount"
Write-Host "high_risk_command_marker_row_count: $highRiskCount"
Write-Host "risk_marked_row_count: $riskMarkedCount"
Write-Host "unclassified_risk_marker_count: $unclassifiedRiskCount"
Write-Host "action_now_non_no_count: $actionNowNonNoCount"
Write-Host "recursive_dry_run_expansion_required_count: $recursiveDryRunRequiredCount"
Write-Host "whole_house_clearance_count: $wholeHouseClearanceCount"
Write-Host "blocker_count: $blockerCount"
Write-Host "next_single_action: $nextSingleAction"
Write-Host "final_verdict: $finalVerdict"
Write-Host "physical_actions: move=$PhysicalMoves delete=$PhysicalDeletes rename=$PhysicalRenames route=$PhysicalRoutes execute=$PhysicalExecutes commit=$PhysicalCommits push=$PhysicalPushes"
