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

$OutSelectedCsv = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_005_V0_1_20260609.csv'
$OutMd = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$OutPrint = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutReceipt = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function New-ObjList { return [System.Collections.Generic.List[object]]::new() }
function New-StringList { return [System.Collections.Generic.List[string]]::new() }

function Add-Line {
    param([Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$List, [AllowNull()]$Value)
    if ($null -eq $Value) { [void]$List.Add('') } else { [void]$List.Add([string]$Value) }
}

function Write-TextNoBom {
    param([Parameter(Mandatory=$true)][string]$Path, [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Lines)
    $text = [string]::Join([Environment]::NewLine, [string[]]$Lines.ToArray())
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256Safe {
    param([AllowNull()][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
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

function Normalize-Key {
    param([AllowNull()]$Value)
    $s = [string]$Value
    if ([string]::IsNullOrWhiteSpace($s)) { return '' }
    return ([System.IO.Path]::GetFileName($s.Trim().Trim('"'))).ToLowerInvariant()
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

$QueueSha = Get-Sha256Safe -Path $QueueCsvPath
$HsrB004CloseoutSha = Get-Sha256Safe -Path $HsrB004CloseoutPath
$HsrB004CloseoutReceiptSha = Get-Sha256Safe -Path $HsrB004CloseoutReceiptPath

$InputQueueVerified = ($QueueSha -eq $ExpectedQueueSha)
$HsrB004CloseoutVerified = ($HsrB004CloseoutSha -eq $ExpectedHsrB004CloseoutSha)
$HsrB004CloseoutReceiptVerified = ($HsrB004CloseoutReceiptSha -eq $ExpectedHsrB004CloseoutReceiptSha)

$queueRows = New-ObjList
Import-Csv -LiteralPath $QueueCsvPath | ForEach-Object { [void]$queueRows.Add($_) }

$selectedRows = New-ObjList
for ($i = 0; $i -lt $queueRows.Count; $i++) {
    $row = $queueRows[$i]
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

    [void]$selectedRows.Add([pscustomobject]@{
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
    })
}

$selectedRows.ToArray() | Export-Csv -LiteralPath $OutSelectedCsv -NoTypeInformation -Encoding UTF8
$OutSelectedCsvSha = Get-Sha256Safe -Path $OutSelectedCsv

$selectedCount = $selectedRows.Count
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

for ($i = 0; $i -lt $selectedRows.Count; $i++) {
    $r = $selectedRows[$i]
    if ($r.SourcePresent -eq $true) { $sourcePresentCount++ } else { $sourceMissingCount++ }
    if ([string]::IsNullOrWhiteSpace($r.TicketID)) { $blankTicketIdCount++ }
    if ([string]::IsNullOrWhiteSpace($r.FileName)) { $missingFileNameCount++ }
    if ([string]::IsNullOrWhiteSpace($r.DeclaredSha256)) { $missingDeclaredShaCount++ }
    if ([string]::IsNullOrWhiteSpace($r.ActualSha256)) { $missingActualShaCount++ }
    if ($r.SourceHashMatch -ne $true) { $sourceHashMismatchCount++ }
    if (($r.StaticReviewOnly -eq 'YES') -and ($r.ExecutionAllowed -eq 'NO') -and ($r.RouteAllowed -eq 'NO') -and ($r.CleanupAllowed -eq 'NO')) { $reviewOnlyCount++ }
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

$blockers = New-StringList
if (-not $InputQueueVerified) { Add-Line $blockers 'INPUT_QUEUE_HASH_NOT_VERIFIED' }
if (-not $HsrB004CloseoutVerified) { Add-Line $blockers 'HSRB_004_DISPOSITION_INDEX_CLOSEOUT_HASH_NOT_VERIFIED' }
if (-not $HsrB004CloseoutReceiptVerified) { Add-Line $blockers 'HSRB_004_DISPOSITION_INDEX_CLOSEOUT_RECEIPT_HASH_NOT_VERIFIED' }
if ($selectedCount -le 0) { Add-Line $blockers 'NO_HSRB_005_ROWS_SELECTED' }
if ($sourceMissingCount -ne 0) { Add-Line $blockers ('SOURCE_MISSING_COUNT_{0}' -f $sourceMissingCount) }
if ($blankTicketIdCount -ne 0) { Add-Line $blockers ('BLANK_TICKET_ID_COUNT_{0}' -f $blankTicketIdCount) }
if ($missingFileNameCount -ne 0) { Add-Line $blockers ('MISSING_FILENAME_COUNT_{0}' -f $missingFileNameCount) }
if ($missingDeclaredShaCount -ne 0) { Add-Line $blockers ('MISSING_DECLARED_SHA256_COUNT_{0}' -f $missingDeclaredShaCount) }
if ($missingActualShaCount -ne 0) { Add-Line $blockers ('MISSING_ACTUAL_SHA256_COUNT_{0}' -f $missingActualShaCount) }
if ($sourceHashMismatchCount -ne 0) { Add-Line $blockers ('SOURCE_HASH_MISMATCH_COUNT_{0}' -f $sourceHashMismatchCount) }
if ($reviewOnlyCount -ne $selectedCount) { Add-Line $blockers ('REVIEW_ONLY_COUNT_UNEXPECTED_{0}' -f $reviewOnlyCount) }
if ($actionNowNonNoCount -ne 0) { Add-Line $blockers ('ACTION_NOW_NON_NO_COUNT_{0}' -f $actionNowNonNoCount) }
if ($unclassifiedRiskMarkerCount -ne 0) { Add-Line $blockers ('UNCLASSIFIED_RISK_MARKER_COUNT_{0}' -f $unclassifiedRiskMarkerCount) }
if ([string]::IsNullOrWhiteSpace($OutSelectedCsvSha)) { Add-Line $blockers 'OUTPUT_SELECTED_CSV_SHA256_BLANK' }

$blockerCount = $blockers.Count
$contractGatePassed = ($blockerCount -eq 0)
$finalVerdict = if ($contractGatePassed) { 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_V0_1_WRITTEN_WITH_REVIEW_ONLY_ROOT_HELD_ROUTE_OR_HOLD_CUSTODY_ROWS_NO_PHYSICAL_ACTION' } else { 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }
$nextSingleAction = if ($contractGatePassed) { 'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_005_BATCH_SELECTOR_BLOCKERS_NO_EXECUTION' }

$md = New-StringList
Add-Line $md '# Helper Script Review Next Batch Selector HSRB-005 From 64 Queue - No Execution - V0.1'
Add-Line $md ''
Add-Line $md 'Status: BATCH_SELECTOR / CONTRACT_FIRST / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $md ''
Add-Line $md '## Purpose'
Add-Line $md ''
Add-Line $md 'Select HSRB-005 from the 64-row helper-script review queue after HSRB-004 disposition index closeout.'
Add-Line $md ''
Add-Line $md 'HSRB-005 covers root-held route-or-hold, plan-only, script-custody, and non-script custody helper files. This selector writes proof and review surfaces only.'
Add-Line $md ''
Add-Line $md '## Authority boundary'
Add-Line $md ''
Add-Line $md '- No helper script execution.'
Add-Line $md '- No move/delete/rename.'
Add-Line $md '- No route or cleanup.'
Add-Line $md '- No commit or push.'
Add-Line $md '- No doctrine promotion.'
Add-Line $md '- Selected rows remain review-only.'
Add-Line $md ''
Add-Line $md '## Verified inputs'
Add-Line $md ''
Add-Line $md ('- input_queue_verified: {0}' -f $InputQueueVerified)
Add-Line $md ('- input_queue_sha256: `{0}`' -f $QueueSha)
Add-Line $md ('- hsrb_004_disposition_index_closeout_verified: {0}' -f $HsrB004CloseoutVerified)
Add-Line $md ('- hsrb_004_disposition_index_closeout_sha256: `{0}`' -f $HsrB004CloseoutSha)
Add-Line $md ('- hsrb_004_disposition_index_closeout_receipt_verified: {0}' -f $HsrB004CloseoutReceiptVerified)
Add-Line $md ('- hsrb_004_disposition_index_closeout_receipt_sha256: `{0}`' -f $HsrB004CloseoutReceiptSha)
Add-Line $md ''
Add-Line $md '## Counts'
Add-Line $md ''
Add-Line $md ('- contract_gate_passed: {0}' -f $contractGatePassed)
Add-Line $md ('- selected_batch_id: {0}' -f $BatchId)
Add-Line $md ('- selected_batch_rows: {0}' -f $selectedCount)
Add-Line $md ('- source_present_count: {0}' -f $sourcePresentCount)
Add-Line $md ('- source_missing_count: {0}' -f $sourceMissingCount)
Add-Line $md ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount)
Add-Line $md ('- missing_filename_count: {0}' -f $missingFileNameCount)
Add-Line $md ('- missing_declared_sha256_count: {0}' -f $missingDeclaredShaCount)
Add-Line $md ('- missing_actual_sha256_count: {0}' -f $missingActualShaCount)
Add-Line $md ('- source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
Add-Line $md ('- review_only_count: {0}' -f $reviewOnlyCount)
Add-Line $md ('- contains_git_command_count: {0}' -f $containsGitCount)
Add-Line $md ('- contains_move_item_count: {0}' -f $containsMoveCount)
Add-Line $md ('- contains_remove_item_count: {0}' -f $containsRemoveCount)
Add-Line $md ('- contains_rename_item_count: {0}' -f $containsRenameCount)
Add-Line $md ('- contains_copy_item_count: {0}' -f $containsCopyCount)
Add-Line $md ('- contains_start_process_count: {0}' -f $containsStartProcessCount)
Add-Line $md ('- contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
Add-Line $md ('- contains_set_clipboard_count: {0}' -f $containsSetClipboardCount)
Add-Line $md ('- high_risk_command_marker_row_count: {0}' -f $highRiskMarkerCount)
Add-Line $md ('- risk_marked_row_count: {0}' -f $riskMarkedCount)
Add-Line $md ('- unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
Add-Line $md ('- action_now_non_no_count: {0}' -f $actionNowNonNoCount)
Add-Line $md ('- blocker_count: {0}' -f $blockerCount)
Add-Line $md ''
Add-Line $md '## Selected rows'
for ($i = 0; $i -lt $selectedRows.Count; $i++) {
    $item = $selectedRows[$i]
    Add-Line $md ('- {0} | {1} | {2} | {3} | risk_disposition={4}' -f $item.TicketID, $item.FileName, $item.RoleLabel, $item.RiskLabel, $item.RiskDisposition)
}
Add-Line $md ''
Add-Line $md '## Blockers'
if ($blockerCount -eq 0) { Add-Line $md '- NONE' } else { for ($i = 0; $i -lt $blockers.Count; $i++) { Add-Line $md ('- {0}' -f $blockers[$i]) } }
Add-Line $md ''
Add-Line $md '## Next single action'
Add-Line $md $nextSingleAction
Add-Line $md ''
Add-Line $md '## Final verdict'
Add-Line $md $finalVerdict
Add-Line $md ''
Add-Line $md '## Physical actions'
Add-Line $md ('move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-TextNoBom -Path $OutMd -Lines $md
$OutMdSha = Get-Sha256Safe -Path $OutMd

$print = New-StringList
Add-Line $print 'HELPER SCRIPT REVIEW NEXT BATCH SELECTOR HSRB-005 FROM 64 QUEUE - COPY PRINT'
Add-Line $print 'Purpose: select root-held route-or-hold and custody helper batch. No execution.'
Add-Line $print ''
Add-Line $print ('selected_batch_id: {0}' -f $BatchId)
Add-Line $print ('selected_batch_rows: {0}' -f $selectedCount)
Add-Line $print ('source_present_count: {0}' -f $sourcePresentCount)
Add-Line $print ('source_missing_count: {0}' -f $sourceMissingCount)
Add-Line $print ('contains_git_command_count: {0}' -f $containsGitCount)
Add-Line $print ('high_risk_command_marker_row_count: {0}' -f $highRiskMarkerCount)
Add-Line $print ('blocker_count: {0}' -f $blockerCount)
Add-Line $print ''
Add-Line $print 'ROWS:'
for ($i = 0; $i -lt $selectedRows.Count; $i++) {
    $item = $selectedRows[$i]
    Add-Line $print ('Ticket: {0}' -f $item.TicketID)
    Add-Line $print ('File:   {0}' -f $item.FileName)
    Add-Line $print ('Path:   {0}' -f $item.SourcePath)
    Add-Line $print ('SHA256: {0}' -f $item.ActualSha256)
    Add-Line $print ('RiskDisposition: {0}' -f $item.RiskDisposition)
    Add-Line $print 'ExecutionAllowed: NO'
    Add-Line $print '---'
}
Add-Line $print ''
Add-Line $print ('next_single_action: {0}' -f $nextSingleAction)
Add-Line $print ('final_verdict: {0}' -f $finalVerdict)
Add-Line $print ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-TextNoBom -Path $OutPrint -Lines $print
$OutPrintSha = Get-Sha256Safe -Path $OutPrint

$receipt = New-StringList
Add-Line $receipt 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609'
Add-Line $receipt ('timestamp_utc: {0}' -f ([DateTime]::UtcNow.ToString('o')))
Add-Line $receipt ('output_selected_batch_csv_path: {0}' -f $OutSelectedCsv)
Add-Line $receipt ('output_selected_batch_csv_sha256: {0}' -f $OutSelectedCsvSha)
Add-Line $receipt ('output_md_path: {0}' -f $OutMd)
Add-Line $receipt ('output_md_sha256: {0}' -f $OutMdSha)
Add-Line $receipt ('output_print_path: {0}' -f $OutPrint)
Add-Line $receipt ('output_print_sha256: {0}' -f $OutPrintSha)
Add-Line $receipt ('contract_gate_passed: {0}' -f $contractGatePassed)
Add-Line $receipt ('selected_batch_id: {0}' -f $BatchId)
Add-Line $receipt ('selected_batch_rows: {0}' -f $selectedCount)
Add-Line $receipt ('blocker_count: {0}' -f $blockerCount)
Add-Line $receipt ('next_single_action: {0}' -f $nextSingleAction)
Add-Line $receipt ('final_verdict: {0}' -f $finalVerdict)
Add-Line $receipt ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-TextNoBom -Path $OutReceipt -Lines $receipt
$OutReceiptSha = Get-Sha256Safe -Path $OutReceipt

Write-Host '=== HELPER SCRIPT REVIEW NEXT BATCH SELECTOR HSRB-005 FROM 64 QUEUE V0.1 COMPLETE ==='
Write-Host "output_selected_batch_csv_path: $OutSelectedCsv"
Write-Host "output_selected_batch_csv_sha256: $OutSelectedCsvSha"
Write-Host "output_md_path: $OutMd"
Write-Host "output_md_sha256: $OutMdSha"
Write-Host "output_print_path: $OutPrint"
Write-Host "output_print_sha256: $OutPrintSha"
Write-Host "output_receipt_path: $OutReceipt"
Write-Host "output_receipt_sha256: $OutReceiptSha"
Write-Host "contract_gate_passed: $contractGatePassed"
Write-Host "input_queue_verified: $InputQueueVerified"
Write-Host "hsrb_004_disposition_index_closeout_verified: $HsrB004CloseoutVerified"
Write-Host "hsrb_004_disposition_index_closeout_receipt_verified: $HsrB004CloseoutReceiptVerified"
Write-Host "selected_batch_id: $BatchId"
Write-Host "selected_batch_rows: $selectedCount"
Write-Host "source_present_count: $sourcePresentCount"
Write-Host "source_missing_count: $sourceMissingCount"
Write-Host "blank_ticket_id_count: $blankTicketIdCount"
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
Write-Host "high_risk_command_marker_row_count: $highRiskMarkerCount"
Write-Host "risk_marked_row_count: $riskMarkedCount"
Write-Host "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
Write-Host "action_now_non_no_count: $actionNowNonNoCount"
Write-Host "blocker_count: $blockerCount"
Write-Host "next_single_action: $nextSingleAction"
Write-Host "final_verdict: $finalVerdict"
Write-Host ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
