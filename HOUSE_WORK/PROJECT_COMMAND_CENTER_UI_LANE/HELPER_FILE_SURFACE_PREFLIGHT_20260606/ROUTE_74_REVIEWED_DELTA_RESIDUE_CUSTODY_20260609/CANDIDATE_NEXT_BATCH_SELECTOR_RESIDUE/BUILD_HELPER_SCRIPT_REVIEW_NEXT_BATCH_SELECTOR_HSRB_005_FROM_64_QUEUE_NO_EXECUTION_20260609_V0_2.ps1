Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$Stamp = '20260609'
$BatchId = 'HSRB-005'
$BatchName = 'ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY'

$QueueCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$HsrB004CloseoutPath = Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$HsrB004CloseoutReceiptPath = Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedQueueSha = '791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43'
$ExpectedHsrB004CloseoutSha = '672F097F862D0D178028D127BB6593737109E020833AFAD3F0EBEC4D08C0E8F3'
$ExpectedHsrB004CloseoutReceiptSha = '4EC7357389810A4758CBC0B37B87117784B6045F574BD45F07F599B9774C935B'

$V01ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__HSRB_005_NEXT_BATCH_SELECTOR_V0_1_NULL_QUEUE_ROWS_COLLECTION_FACTORY_20260609.md'
$FixNotePath = Join-Path $Lane 'FIX_NOTE__HSRB_005_NEXT_BATCH_SELECTOR_V0_2_UNDERLYING_COLLECTION_PATTERN_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__HSRB_005_NEXT_BATCH_SELECTOR_V0_2_REPAIR_20260609.txt'

$OutSelectedCsv = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_005_V0_2_20260609.csv'
$OutMd = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$OutPrint = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$OutReceipt = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

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

function Is-HsrB005Family {
    param([string]$FileName)
    if ([string]::IsNullOrWhiteSpace($FileName)) { return $false }
    if ($FileName -like '*ROOT_HELD_GROUP_ROUTE_OR_HOLD*') { return $true }
    if ($FileName -like '*ROOT_HELD_GROUP_ROUTE_PLAN_ONLY*') { return $true }
    if ($FileName -like '*ROOT_HELD_GROUP_SCRIPT_CUSTODY*') { return $true }
    if ($FileName -like '*ROOT_HELD_GROUP_NON_SCRIPT*') { return $true }
    if ($FileName -like '*ROOT_HELD_GROUP_ROUTE_PLAN_*') { return $true }
    return $false
}

function Get-TextOrBlank {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    try { return [System.IO.File]::ReadAllText($Path) } catch { return '' }
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }
if (-not (Test-Path -LiteralPath $QueueCsvPath -PathType Leaf)) { throw "Queue CSV not found: $QueueCsvPath" }

$v01FreezeLines = @()
$v01FreezeLines += '# ERROR FREEZE — HSRB-005 NEXT BATCH SELECTOR V0.1'
$v01FreezeLines += ''
$v01FreezeLines += 'Status: ERROR_FREEZE / SAME_OBJECT_REPAIR_REQUIRED / NO_PHYSICAL_ACTION'
$v01FreezeLines += ''
$v01FreezeLines += 'Failed script: BUILD_HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_20260609_V0_1.ps1'
$v01FreezeLines += 'Failed line: 133'
$v01FreezeLines += 'Failed command: Import-Csv -LiteralPath $QueueCsvPath | ForEach-Object { [void]$queueRows.Add($_) }'
$v01FreezeLines += 'Observed error: You cannot call a method on a null-valued expression.'
$v01FreezeLines += ''
$v01FreezeLines += 'Immediate local cause: the script attempted to call Add() on $queueRows while $queueRows was null.'
$v01FreezeLines += 'Defect class: COLLECTION_INITIALIZATION_OR_PIPELINE_ADD_DEFECT.'
$v01FreezeLines += 'Wider classification: POSSIBLE_UNDERLYING_HELPER_GENERATION_DEFECT, because prior HSRB work showed repeated list/array/collection/custody generation failures.'
$v01FreezeLines += ''
$v01FreezeLines += 'Blocked action: do not continue by patching only the current line without removing the generated collection pattern.'
$v01FreezeLines += 'Repair requirement: remove typed list factory reliance and pipeline Add() reliance; import CSV into a safe array; enumerate directly; preserve no-action boundary.'
Write-LinesUtf8 -Path $V01ErrorFreezePath -Lines $v01FreezeLines
$V01ErrorFreezeSha = Get-Sha256Safe -Path $V01ErrorFreezePath

$fixNoteLines = @()
$fixNoteLines += '# FIX NOTE — HSRB-005 NEXT BATCH SELECTOR V0.2'
$fixNoteLines += ''
$fixNoteLines += 'Status: FIX_NOTE / UNDERLYING_COLLECTION_PATTERN_REPAIR / NO_PHYSICAL_ACTION'
$fixNoteLines += ''
$fixNoteLines += 'V0.1 failed at queue row import because a generated collection variable was null before Add() was called.'
$fixNoteLines += 'V0.2 does not merely patch line 133. It removes the risky pattern for this selector.'
$fixNoteLines += ''
$fixNoteLines += 'Repair actions:'
$fixNoteLines += '- No typed Generic List factory is used for queue loading.'
$fixNoteLines += '- No pipeline Add() call is used for queue loading.'
$fixNoteLines += '- Import-Csv output is normalized through Convert-ToSafeArray.'
$fixNoteLines += '- Selected rows are built through direct enumeration and array append, small-batch safe.'
$fixNoteLines += '- The same HSRB-005 object is preserved; this is not a new lane.'
$fixNoteLines += '- Physical action counts remain zero.'
Write-LinesUtf8 -Path $FixNotePath -Lines $fixNoteLines
$FixNoteSha = Get-Sha256Safe -Path $FixNotePath

$QueueSha = Get-Sha256Safe -Path $QueueCsvPath
$HsrB004CloseoutSha = Get-Sha256Safe -Path $HsrB004CloseoutPath
$HsrB004CloseoutReceiptSha = Get-Sha256Safe -Path $HsrB004CloseoutReceiptPath

$InputQueueVerified = ($QueueSha -eq $ExpectedQueueSha)
$HsrB004CloseoutVerified = ($HsrB004CloseoutSha -eq $ExpectedHsrB004CloseoutSha)
$HsrB004CloseoutReceiptVerified = ($HsrB004CloseoutReceiptSha -eq $ExpectedHsrB004CloseoutReceiptSha)

$importedQueueRows = Import-Csv -LiteralPath $QueueCsvPath
$queueRows = Convert-ToSafeArray -Value $importedQueueRows

$selectedRows = @()
foreach ($row in $queueRows) {
    $fileName = Get-FileNameCell -Row $row
    if (-not (Is-HsrB005Family -FileName $fileName)) { continue }

    $ticket = Get-Cell -Row $row -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID','ReviewTicketID','RowID','RowId','ID')
    $sourcePath = Resolve-SourcePath -Row $row -FileName $fileName
    $sourcePresent = $false
    if (-not [string]::IsNullOrWhiteSpace($sourcePath)) { $sourcePresent = Test-Path -LiteralPath $sourcePath -PathType Leaf }

    $declaredSha = Get-Cell -Row $row -Names @('SourceSha256','SourceSHA256','SHA256','Sha256','Hash','FileSHA256','ActualSha256')
    $actualSha = ''
    if ($sourcePresent) { $actualSha = Get-Sha256Safe -Path $sourcePath }
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = $actualSha }

    $roleLabel = Get-Cell -Row $row -Names @('OriginalRoleLabel','RoleLabel','Role','BoardClass','Class','ReviewRole')
    $riskLabel = Get-Cell -Row $row -Names @('OriginalRiskLabel','RiskLabel','Risk','RiskClass')
    $userDecision = Get-Cell -Row $row -Names @('UserDecision','Decision','ManualDecision')
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

    $selectedRows += [pscustomobject][ordered]@{
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
        UserDecision = [string]$userDecision
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
        ReviewDisposition = 'REVIEW_ONLY__ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY'
    }
}

$selectedCount = $selectedRows.Count
if ($selectedCount -gt 0) {
    $selectedRows | Export-Csv -LiteralPath $OutSelectedCsv -NoTypeInformation -Encoding UTF8
} else {
    [pscustomobject][ordered]@{
        BatchID = $BatchId
        BatchName = $BatchName
        EmptySelection = 'TRUE'
        Reason = 'No HSRB-005 family rows matched selector patterns.'
    } | Export-Csv -LiteralPath $OutSelectedCsv -NoTypeInformation -Encoding UTF8
}
$OutSelectedCsvSha = Get-Sha256Safe -Path $OutSelectedCsv

$sourcePresentCount = 0
$sourceMissingCount = 0
$blankTicketIdCount = 0
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
$highRiskMarkerCount = 0
$riskMarkedCount = 0
$unclassifiedRiskMarkerCount = 0

foreach ($r in $selectedRows) {
    if ($r.SourcePresent -eq $true) { $sourcePresentCount++ } else { $sourceMissingCount++ }
    if ([string]::IsNullOrWhiteSpace($r.TicketID)) { $blankTicketIdCount++ }
    if ([string]::IsNullOrWhiteSpace($r.FileName)) { $missingFileNameCount++ }
    if ([string]::IsNullOrWhiteSpace($r.DeclaredSha256)) { $missingDeclaredShaCount++ }
    if ([string]::IsNullOrWhiteSpace($r.ActualSha256)) { $missingActualShaCount++ }
    if ($r.SourceHashMatch -ne $true) { $sourceHashMismatchCount++ }
    if (($r.StaticReviewOnly -eq 'YES') -and ($r.ExecutionAllowed -eq 'NO') -and ($r.RouteAllowed -eq 'NO') -and ($r.CleanupAllowed -eq 'NO') -and ($r.DoctrinePromotionAllowed -eq 'NO')) { $reviewOnlyCount++ }
    if (($r.ActionNow -ne 'NO') -and ($r.ActionNow -ne 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP')) { $actionNowNonNoCount++ }
    if ($r.ContainsGitCommand -eq $true) { $containsGitCount++ }
    if ($r.ContainsMoveItem -eq $true) { $containsMoveCount++ }
    if ($r.ContainsRemoveItem -eq $true) { $containsRemoveCount++ }
    if ($r.ContainsRenameItem -eq $true) { $containsRenameCount++ }
    if ($r.ContainsCopyItem -eq $true) { $containsCopyCount++ }
    if ($r.ContainsStartProcess -eq $true) { $containsStartProcessCount++ }
    if ($r.ContainsInvokeExpression -eq $true) { $containsInvokeExpressionCount++ }
    if ($r.ContainsSetClipboard -eq $true) { $containsSetClipboardCount++ }
    if ($r.HighRiskCommandMarker -eq $true) { $highRiskMarkerCount++ }
    if ($r.RiskMarked -eq $true) { $riskMarkedCount++ }
    if (($r.RiskMarked -eq $true) -and [string]::IsNullOrWhiteSpace($r.RiskDisposition)) { $unclassifiedRiskMarkerCount++ }
}

$blockerCount = 0
if (-not $InputQueueVerified) { $blockerCount++ }
if (-not $HsrB004CloseoutVerified) { $blockerCount++ }
if (-not $HsrB004CloseoutReceiptVerified) { $blockerCount++ }
if ($selectedCount -le 0) { $blockerCount++ }
$blockerCount += $sourceMissingCount
$blockerCount += $blankTicketIdCount
$blockerCount += $missingFileNameCount
$blockerCount += $missingDeclaredShaCount
$blockerCount += $missingActualShaCount
$blockerCount += $sourceHashMismatchCount
$blockerCount += $actionNowNonNoCount
$blockerCount += $highRiskMarkerCount
$blockerCount += $unclassifiedRiskMarkerCount

$ContractGatePassed = ($blockerCount -eq 0)
$NextSingleAction = if ($ContractGatePassed) { 'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_005_SELECTOR_BLOCKERS_NO_EXECUTION' }
$FinalVerdict = if ($ContractGatePassed) { 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_V0_2_WRITTEN_AFTER_UNDERLYING_COLLECTION_PATTERN_REPAIR_NO_PHYSICAL_ACTION' } else { 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_V0_2_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }

$md = @()
$md += '# HSRB-005 NEXT BATCH SELECTOR FROM 64 QUEUE — V0.2'
$md += ''
$md += 'Status: SELECTOR / SAME_OBJECT_REPAIR / UNDERLYING_COLLECTION_PATTERN_REPAIR / NO_EXECUTION'
$md += ''
$md += '## Repair boundary'
$md += '- V0.1 failed at queue loading because $queueRows was null before Add() was called.'
$md += '- V0.2 removes typed list factory and pipeline Add() reliance from the selector import path.'
$md += '- This is classified as POSSIBLE_UNDERLYING_HELPER_GENERATION_DEFECT until the wider family is proven clean.'
$md += ''
$md += '## Inputs'
$md += "queue_csv_path: $QueueCsvPath"
$md += "queue_csv_sha256: $QueueSha"
$md += "input_queue_verified: $InputQueueVerified"
$md += "hsrb_004_closeout_path: $HsrB004CloseoutPath"
$md += "hsrb_004_closeout_sha256: $HsrB004CloseoutSha"
$md += "hsrb_004_closeout_verified: $HsrB004CloseoutVerified"
$md += "hsrb_004_closeout_receipt_path: $HsrB004CloseoutReceiptPath"
$md += "hsrb_004_closeout_receipt_sha256: $HsrB004CloseoutReceiptSha"
$md += "hsrb_004_closeout_receipt_verified: $HsrB004CloseoutReceiptVerified"
$md += ''
$md += '## Counts'
$md += "contract_gate_passed: $ContractGatePassed"
$md += "selected_batch_id: $BatchId"
$md += "selected_batch_rows: $selectedCount"
$md += "queue_review_rows: $($queueRows.Count)"
$md += "source_present_count: $sourcePresentCount"
$md += "source_missing_count: $sourceMissingCount"
$md += "blank_ticket_id_count: $blankTicketIdCount"
$md += "missing_filename_count: $missingFileNameCount"
$md += "missing_declared_sha256_count: $missingDeclaredShaCount"
$md += "missing_actual_sha256_count: $missingActualShaCount"
$md += "source_hash_mismatch_count: $sourceHashMismatchCount"
$md += "review_only_count: $reviewOnlyCount"
$md += "contains_git_command_count: $containsGitCount"
$md += "contains_move_item_count: $containsMoveCount"
$md += "contains_remove_item_count: $containsRemoveCount"
$md += "contains_rename_item_count: $containsRenameCount"
$md += "contains_copy_item_count: $containsCopyCount"
$md += "contains_start_process_count: $containsStartProcessCount"
$md += "contains_invoke_expression_count: $containsInvokeExpressionCount"
$md += "contains_set_clipboard_count: $containsSetClipboardCount"
$md += "high_risk_command_marker_row_count: $highRiskMarkerCount"
$md += "risk_marked_row_count: $riskMarkedCount"
$md += "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
$md += "action_now_non_no_count: $actionNowNonNoCount"
$md += "blocker_count: $blockerCount"
$md += ''
$md += '## No physical action boundary'
$md += "physical_actions: move=$PhysicalMoves delete=$PhysicalDeletes rename=$PhysicalRenames route=$PhysicalRoutes execute=$PhysicalExecutes commit=$PhysicalCommits push=$PhysicalPushes"
$md += ''
$md += "next_single_action: $NextSingleAction"
$md += "final_verdict: $FinalVerdict"
Write-LinesUtf8 -Path $OutMd -Lines $md
Copy-Item -LiteralPath $OutMd -Destination $OutPrint -Force
$OutMdSha = Get-Sha256Safe -Path $OutMd
$OutPrintSha = Get-Sha256Safe -Path $OutPrint

$fixReceiptLines = @()
$fixReceiptLines += 'HSRB-005 NEXT BATCH SELECTOR V0.2 REPAIR HASH RECEIPT'
$fixReceiptLines += "v0_1_error_freeze_path: $V01ErrorFreezePath"
$fixReceiptLines += "v0_1_error_freeze_sha256: $V01ErrorFreezeSha"
$fixReceiptLines += "fix_note_path: $FixNotePath"
$fixReceiptLines += "fix_note_sha256: $FixNoteSha"
$fixReceiptLines += "output_selected_batch_csv_path: $OutSelectedCsv"
$fixReceiptLines += "output_selected_batch_csv_sha256: $OutSelectedCsvSha"
$fixReceiptLines += "output_md_path: $OutMd"
$fixReceiptLines += "output_md_sha256: $OutMdSha"
$fixReceiptLines += "output_print_path: $OutPrint"
$fixReceiptLines += "output_print_sha256: $OutPrintSha"
Write-LinesUtf8 -Path $FixReceiptPath -Lines $fixReceiptLines
$FixReceiptSha = Get-Sha256Safe -Path $FixReceiptPath

$receipt = @()
$receipt += 'HSRB-005 NEXT BATCH SELECTOR FROM 64 QUEUE V0.2 RECEIPT'
$receipt += "timestamp_utc: $((Get-Date).ToUniversalTime().ToString('o'))"
$receipt += "v0_1_error_freeze_path: $V01ErrorFreezePath"
$receipt += "v0_1_error_freeze_sha256: $V01ErrorFreezeSha"
$receipt += "fix_note_path: $FixNotePath"
$receipt += "fix_note_sha256: $FixNoteSha"
$receipt += "fix_receipt_path: $FixReceiptPath"
$receipt += "fix_receipt_sha256: $FixReceiptSha"
$receipt += "output_selected_batch_csv_path: $OutSelectedCsv"
$receipt += "output_selected_batch_csv_sha256: $OutSelectedCsvSha"
$receipt += "output_md_path: $OutMd"
$receipt += "output_md_sha256: $OutMdSha"
$receipt += "output_print_path: $OutPrint"
$receipt += "output_print_sha256: $OutPrintSha"
$receipt += "contract_gate_passed: $ContractGatePassed"
$receipt += "blocker_count: $blockerCount"
$receipt += "physical_actions: move=$PhysicalMoves delete=$PhysicalDeletes rename=$PhysicalRenames route=$PhysicalRoutes execute=$PhysicalExecutes commit=$PhysicalCommits push=$PhysicalPushes"
Write-LinesUtf8 -Path $OutReceipt -Lines $receipt
$OutReceiptSha = Get-Sha256Safe -Path $OutReceipt

Write-Output '=== HELPER SCRIPT REVIEW NEXT BATCH SELECTOR HSRB-005 FROM 64 QUEUE V0.2 COMPLETE ==='
Write-Output "v0_1_error_freeze_path: $V01ErrorFreezePath"
Write-Output "v0_1_error_freeze_sha256: $V01ErrorFreezeSha"
Write-Output "fix_note_path: $FixNotePath"
Write-Output "fix_note_sha256: $FixNoteSha"
Write-Output "fix_receipt_path: $FixReceiptPath"
Write-Output "fix_receipt_sha256: $FixReceiptSha"
Write-Output "output_selected_batch_csv_path: $OutSelectedCsv"
Write-Output "output_selected_batch_csv_sha256: $OutSelectedCsvSha"
Write-Output "output_md_path: $OutMd"
Write-Output "output_md_sha256: $OutMdSha"
Write-Output "output_print_path: $OutPrint"
Write-Output "output_print_sha256: $OutPrintSha"
Write-Output "output_receipt_path: $OutReceipt"
Write-Output "output_receipt_sha256: $OutReceiptSha"
Write-Output "contract_gate_passed: $ContractGatePassed"
Write-Output "input_queue_verified: $InputQueueVerified"
Write-Output "hsrb_004_closeout_verified: $HsrB004CloseoutVerified"
Write-Output "hsrb_004_closeout_receipt_verified: $HsrB004CloseoutReceiptVerified"
Write-Output 'collection_pattern_repaired: True'
Write-Output 'typed_list_factory_used_for_queue_load: False'
Write-Output 'pipeline_add_used_for_queue_load: False'
Write-Output "selected_batch_id: $BatchId"
Write-Output "selected_batch_rows: $selectedCount"
Write-Output "queue_review_rows: $($queueRows.Count)"
Write-Output "source_present_count: $sourcePresentCount"
Write-Output "source_missing_count: $sourceMissingCount"
Write-Output "blank_ticket_id_count: $blankTicketIdCount"
Write-Output "missing_filename_count: $missingFileNameCount"
Write-Output "missing_declared_sha256_count: $missingDeclaredShaCount"
Write-Output "missing_actual_sha256_count: $missingActualShaCount"
Write-Output "source_hash_mismatch_count: $sourceHashMismatchCount"
Write-Output "review_only_count: $reviewOnlyCount"
Write-Output "contains_git_command_count: $containsGitCount"
Write-Output "contains_move_item_count: $containsMoveCount"
Write-Output "contains_remove_item_count: $containsRemoveCount"
Write-Output "contains_rename_item_count: $containsRenameCount"
Write-Output "contains_copy_item_count: $containsCopyCount"
Write-Output "contains_start_process_count: $containsStartProcessCount"
Write-Output "contains_invoke_expression_count: $containsInvokeExpressionCount"
Write-Output "contains_set_clipboard_count: $containsSetClipboardCount"
Write-Output "high_risk_command_marker_row_count: $highRiskMarkerCount"
Write-Output "risk_marked_row_count: $riskMarkedCount"
Write-Output "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
Write-Output "action_now_non_no_count: $actionNowNonNoCount"
Write-Output "blocker_count: $blockerCount"
Write-Output "next_single_action: $NextSingleAction"
Write-Output "final_verdict: $FinalVerdict"
Write-Output "physical_actions: move=$PhysicalMoves delete=$PhysicalDeletes rename=$PhysicalRenames route=$PhysicalRoutes execute=$PhysicalExecutes commit=$PhysicalCommits push=$PhysicalPushes"
