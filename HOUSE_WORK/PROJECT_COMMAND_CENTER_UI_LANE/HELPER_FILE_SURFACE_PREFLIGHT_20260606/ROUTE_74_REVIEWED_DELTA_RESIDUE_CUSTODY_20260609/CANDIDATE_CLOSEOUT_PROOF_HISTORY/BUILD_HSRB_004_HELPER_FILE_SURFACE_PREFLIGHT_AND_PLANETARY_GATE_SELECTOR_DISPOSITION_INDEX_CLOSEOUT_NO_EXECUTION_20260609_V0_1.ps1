# BUILD_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1
# Purpose: close out HSRB-004 disposition index V0.3 after V0.1/V0.2 same-object repair chain. No execution. No route. No cleanup. No commit. No push.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$ExpectedFiles = @(
    [pscustomobject]@{ Name='hsrb_004_disposition_index_csv_v0_3'; Path=(Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_V0_3_20260609.csv'); Sha='27B20B207142A0E2A2C24EAAC75CE3F798A0FCEEEA8A2DB6F1990E8E58D5C8C2' },
    [pscustomobject]@{ Name='hsrb_004_disposition_index_md_v0_3'; Path=(Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_V0_3_20260609.md'); Sha='53B1B9CA38AD16C094680AB10F4F74FA34925E7FF4DE0A40E09BCB29AF5F5939' },
    [pscustomobject]@{ Name='hsrb_004_disposition_index_print_v0_3'; Path=(Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_COPY_PRINT_V0_3_20260609.txt'); Sha='53B1B9CA38AD16C094680AB10F4F74FA34925E7FF4DE0A40E09BCB29AF5F5939' },
    [pscustomobject]@{ Name='hsrb_004_disposition_index_receipt_v0_3'; Path=(Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_RECEIPT_V0_3_20260609.txt'); Sha='B7145595D5A77E867CE150681E1DD14C20494B5EB61C9B753FEB81E04A696594' },
    [pscustomobject]@{ Name='hsrb_004_contract_closeout_md_v0_1'; Path=(Join-Path $Lane 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_1_20260609.md'); Sha='6E1F661BAA33AD00B73A64E5C28B58AE981E1D20741EA958CA9F4A27AAF53BAE' },
    [pscustomobject]@{ Name='hsrb_004_contract_closeout_receipt_v0_1'; Path=(Join-Path $Lane 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'); Sha='B3B78AB562CE6D4F759DCB53AB5C1D2A0C9391856C7A77C99195CEAFE0D2A999' },
    [pscustomobject]@{ Name='hsrb_004_contract_risk_csv_v0_1'; Path=(Join-Path $Lane 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'); Sha='48C296DD5346E2D70B0AED39B3107B933072F26DE68CF3B03E151FB11B41D4B0' },
    [pscustomobject]@{ Name='hsrb_004_static_packet_md_v0_1'; Path=(Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_20260609.md'); Sha='ACB93394A06256D4EC421E37233F7D64C04E8EF12AAA691B02D2B8FAAF175B8A' },
    [pscustomobject]@{ Name='hsrb_004_v0_1_error_freeze'; Path=(Join-Path $Lane 'ERROR_FREEZE__HSRB_004_DISPOSITION_INDEX_V0_1_LIST_ARRAY_ARGUMENT_TYPE_MISMATCH_20260609.md'); Sha='FAF34D909A7F6994C59CF7EAD1042D743EE37F7C2C972D317986746E84B402D5' },
    [pscustomobject]@{ Name='hsrb_004_v0_2_error_freeze'; Path=(Join-Path $Lane 'ERROR_FREEZE__HSRB_004_DISPOSITION_INDEX_V0_2_VERIFY_ROWS_ARGUMENT_TYPE_MISMATCH_20260609.md'); Sha='EC75AE1F9591B212B57B1DDE945C1BB4A3B397C715D4BD1CC6D400EAC975A855' },
    [pscustomobject]@{ Name='hsrb_004_v0_3_fix_note'; Path=(Join-Path $Lane 'FIX_NOTE__HSRB_004_DISPOSITION_INDEX_V0_3_ARRAY_ENUMERATION_REPAIR_20260609.md'); Sha='C80A3FB7720AA886E8050AD2B215AB722ECB99B85EE05F620BDDA750D94E7653' },
    [pscustomobject]@{ Name='hsrb_004_v0_3_fix_receipt'; Path=(Join-Path $Lane 'HASH_RECEIPT__HSRB_004_DISPOSITION_INDEX_V0_3_REPAIR_20260609.txt'); Sha='A5CAAC85FE38AB26703AAD81B90F0B66D06E93073C91CF08D103D547011AC9F7' }
)

$OutCloseoutPath = Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$OutCloseoutPrintPath = Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutReceiptPath = Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

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

function Bool-FromText {
    param([AllowNull()]$Value)
    $s = ([string]$Value).Trim().ToLowerInvariant()
    if ($s -eq 'true' -or $s -eq '1' -or $s -eq 'yes' -or $s -eq 'y') { return $true }
    return $false
}

function Add-Line {
    param([Parameter(Mandatory=$true)]$List, [AllowNull()]$Text)
    if ($null -eq $Text) { [void]$List.Add('') } else { [void]$List.Add([string]$Text) }
}

function Write-LinesNoBom {
    param([Parameter(Mandatory=$true)][string]$Path, [Parameter(Mandatory=$true)]$List)
    [System.IO.File]::WriteAllLines($Path, $List.ToArray(), [System.Text.UTF8Encoding]::new($false))
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

function Inc-If {
    param([bool]$Condition, [ref]$Counter)
    if ($Condition) { $Counter.Value = [int]$Counter.Value + 1 }
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }

$hashChecks = @()
$blockers = New-Object System.Collections.Generic.List[string]
foreach ($e in $ExpectedFiles) {
    $actual = Get-Sha256Safe -Path $e.Path
    $exists = Test-Path -LiteralPath $e.Path -PathType Leaf
    $match = ($exists -and ($actual -eq ([string]$e.Sha).ToUpperInvariant()))
    $check = [pscustomobject]@{ Name=$e.Name; Path=$e.Path; Exists=$exists; ExpectedSha256=([string]$e.Sha).ToUpperInvariant(); ActualSha256=$actual; HashMatch=$match }
    $hashChecks += $check
    if (-not $exists) { [void]$blockers.Add(('MISSING_INPUT_{0}: {1}' -f $e.Name, $e.Path)) }
    elseif (-not $match) { [void]$blockers.Add(('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $e.Name, $e.Sha, $actual)) }
}

$IndexCsvPath = Join-Path $Lane 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_V0_3_20260609.csv'
$rows = $null
if ($blockers.Count -eq 0) { $rows = Import-Csv -LiteralPath $IndexCsvPath }

$indexRowCount = 0
$blankTicketIdCount = 0
$missingFilenameCount = 0
$missingDeclaredSha256Count = 0
$missingActualSha256Count = 0
$sourceHashMismatchCount = 0
$sourceMissingCount = 0
$unknownDispositionBucketCount = 0
$containsCopyItemCount = 0
$containsGitCommandCount = 0
$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
$containsSetClipboardCount = 0
$highRiskCommandMarkerRowCount = 0
$riskMarkedRowCount = 0
$unclassifiedRiskMarkerCount = 0
$executionClearanceCount = 0
$routeClearanceCount = 0
$cleanupClearanceCount = 0
$doctrinePromotionCount = 0
$actionNowNonNoCount = 0
$helperFileSurfacePreflightLaneCloseoutCardCount = 0
$planetaryGateHelperFileSurfacePreflightCloseoutOrNextSelectorCount = 0
$planetaryGateNextObjectSelectorHeavyBoundaryCount = 0

$requiredColumns = @('TicketID','FileName','DispositionBucket','ReviewDecision','RiskClassification','DeclaredSHA256','ActualSHA256','SourcePath','SourceExists','HashMatch','ContainsGitCommand','ContainsCopyItem','ContainsMoveItem','ContainsRemoveItem','ContainsRenameItem','ContainsStartProcess','ContainsInvokeExpression','ContainsSetClipboard','ExecutionClearance','RouteClearance','CleanupClearance','DoctrinePromotion','ActionNow')
if ($blockers.Count -eq 0) {
    $firstRow = $null
    foreach ($r in $rows) { $firstRow = $r; break }
    if ($null -eq $firstRow) { [void]$blockers.Add('INDEX_HAS_NO_ROWS') }
    else {
        $props = $firstRow.PSObject.Properties.Name
        foreach ($col in $requiredColumns) {
            $found = $false
            foreach ($p in $props) { if ($p -eq $col) { $found = $true; break } }
            if (-not $found) { [void]$blockers.Add(('REQUIRED_INDEX_COLUMN_MISSING_{0}' -f $col)) }
        }
    }
}

if ($blockers.Count -eq 0) {
    foreach ($r in $rows) {
        $indexRowCount++
        $ticket = [string]$r.TicketID
        $file = [string]$r.FileName
        $declared = [string]$r.DeclaredSHA256
        $actual = [string]$r.ActualSHA256
        $bucket = [string]$r.DispositionBucket
        $riskClass = [string]$r.RiskClassification

        if ([string]::IsNullOrWhiteSpace($ticket)) { $blankTicketIdCount++ }
        if ([string]::IsNullOrWhiteSpace($file)) { $missingFilenameCount++ }
        if ([string]::IsNullOrWhiteSpace($declared)) { $missingDeclaredSha256Count++ }
        if ([string]::IsNullOrWhiteSpace($actual)) { $missingActualSha256Count++ }
        if (-not (Bool-FromText $r.HashMatch)) { $sourceHashMismatchCount++ }
        if (-not (Bool-FromText $r.SourceExists)) { $sourceMissingCount++ }

        if ($bucket -eq 'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_REVIEW_ONLY') { $helperFileSurfacePreflightLaneCloseoutCardCount++ }
        elseif ($bucket -eq 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_REVIEW_ONLY') { $planetaryGateHelperFileSurfacePreflightCloseoutOrNextSelectorCount++ }
        elseif ($bucket -eq 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY_REVIEW_ONLY') { $planetaryGateNextObjectSelectorHeavyBoundaryCount++ }
        else { $unknownDispositionBucketCount++ }

        $hasCopy = Bool-FromText $r.ContainsCopyItem
        $hasGit = Bool-FromText $r.ContainsGitCommand
        $hasMove = Bool-FromText $r.ContainsMoveItem
        $hasRemove = Bool-FromText $r.ContainsRemoveItem
        $hasRename = Bool-FromText $r.ContainsRenameItem
        $hasStart = Bool-FromText $r.ContainsStartProcess
        $hasInvoke = Bool-FromText $r.ContainsInvokeExpression
        $hasClipboard = Bool-FromText $r.ContainsSetClipboard

        if ($hasCopy) { $containsCopyItemCount++ }
        if ($hasGit) { $containsGitCommandCount++ }
        if ($hasMove) { $containsMoveItemCount++ }
        if ($hasRemove) { $containsRemoveItemCount++ }
        if ($hasRename) { $containsRenameItemCount++ }
        if ($hasStart) { $containsStartProcessCount++ }
        if ($hasInvoke) { $containsInvokeExpressionCount++ }
        if ($hasClipboard) { $containsSetClipboardCount++ }
        if ($hasMove -or $hasRemove -or $hasRename -or $hasStart -or $hasInvoke) { $highRiskCommandMarkerRowCount++ }
        if ($hasCopy -or $hasGit -or $hasClipboard -or ($riskClass -match 'RISK_MARKER')) { $riskMarkedRowCount++ }
        if (($hasCopy -or $hasGit -or $hasClipboard) -and ($riskClass -notmatch 'REVIEW_ONLY_RISK_MARKER')) { $unclassifiedRiskMarkerCount++ }

        if (([string]$r.ExecutionClearance).Trim().ToUpperInvariant() -ne 'NO') { $executionClearanceCount++ }
        if (([string]$r.RouteClearance).Trim().ToUpperInvariant() -ne 'NO') { $routeClearanceCount++ }
        if (([string]$r.CleanupClearance).Trim().ToUpperInvariant() -ne 'NO') { $cleanupClearanceCount++ }
        if (([string]$r.DoctrinePromotion).Trim().ToUpperInvariant() -ne 'NO') { $doctrinePromotionCount++ }
        if (([string]$r.ActionNow).Trim().ToUpperInvariant() -ne 'NO') { $actionNowNonNoCount++ }
    }
}

if ($blockers.Count -eq 0 -and $indexRowCount -ne 3) { [void]$blockers.Add(('INDEX_ROW_COUNT_NOT_3_ACTUAL_{0}' -f $indexRowCount)) }
if ($blockers.Count -eq 0 -and $blankTicketIdCount -ne 0) { [void]$blockers.Add(('BLANK_TICKET_ID_COUNT_NOT_0_ACTUAL_{0}' -f $blankTicketIdCount)) }
if ($blockers.Count -eq 0 -and $missingFilenameCount -ne 0) { [void]$blockers.Add(('MISSING_FILENAME_COUNT_NOT_0_ACTUAL_{0}' -f $missingFilenameCount)) }
if ($blockers.Count -eq 0 -and $missingDeclaredSha256Count -ne 0) { [void]$blockers.Add(('MISSING_DECLARED_SHA256_COUNT_NOT_0_ACTUAL_{0}' -f $missingDeclaredSha256Count)) }
if ($blockers.Count -eq 0 -and $missingActualSha256Count -ne 0) { [void]$blockers.Add(('MISSING_ACTUAL_SHA256_COUNT_NOT_0_ACTUAL_{0}' -f $missingActualSha256Count)) }
if ($blockers.Count -eq 0 -and $sourceHashMismatchCount -ne 0) { [void]$blockers.Add(('SOURCE_HASH_MISMATCH_COUNT_NOT_0_ACTUAL_{0}' -f $sourceHashMismatchCount)) }
if ($blockers.Count -eq 0 -and $sourceMissingCount -ne 0) { [void]$blockers.Add(('SOURCE_MISSING_COUNT_NOT_0_ACTUAL_{0}' -f $sourceMissingCount)) }
if ($blockers.Count -eq 0 -and $unknownDispositionBucketCount -ne 0) { [void]$blockers.Add(('UNKNOWN_DISPOSITION_BUCKET_COUNT_NOT_0_ACTUAL_{0}' -f $unknownDispositionBucketCount)) }
if ($blockers.Count -eq 0 -and $highRiskCommandMarkerRowCount -ne 0) { [void]$blockers.Add(('HIGH_RISK_COMMAND_MARKER_ROW_COUNT_NOT_0_ACTUAL_{0}' -f $highRiskCommandMarkerRowCount)) }
if ($blockers.Count -eq 0 -and $unclassifiedRiskMarkerCount -ne 0) { [void]$blockers.Add(('UNCLASSIFIED_RISK_MARKER_COUNT_NOT_0_ACTUAL_{0}' -f $unclassifiedRiskMarkerCount)) }
if ($blockers.Count -eq 0 -and $executionClearanceCount -ne 0) { [void]$blockers.Add(('EXECUTION_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $executionClearanceCount)) }
if ($blockers.Count -eq 0 -and $routeClearanceCount -ne 0) { [void]$blockers.Add(('ROUTE_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $routeClearanceCount)) }
if ($blockers.Count -eq 0 -and $cleanupClearanceCount -ne 0) { [void]$blockers.Add(('CLEANUP_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $cleanupClearanceCount)) }
if ($blockers.Count -eq 0 -and $doctrinePromotionCount -ne 0) { [void]$blockers.Add(('DOCTRINE_PROMOTION_COUNT_NOT_0_ACTUAL_{0}' -f $doctrinePromotionCount)) }
if ($blockers.Count -eq 0 -and $actionNowNonNoCount -ne 0) { [void]$blockers.Add(('ACTION_NOW_NON_NO_COUNT_NOT_0_ACTUAL_{0}' -f $actionNowNonNoCount)) }

$blockerCount = [int]$blockers.Count
$contractGatePassed = ($blockerCount -eq 0)
if ($contractGatePassed) {
    $nextSingleAction = 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
    $finalVerdict = 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_V0_1_VERIFIED_REVIEW_ONLY_GIT_MARKERS_NO_PHYSICAL_ACTION'
} else {
    $nextSingleAction = 'STOP_AND_REVIEW_HSRB_004_DISPOSITION_INDEX_CLOSEOUT_BLOCKERS_NO_EXECUTION'
    $finalVerdict = 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$lines = [System.Collections.Generic.List[string]]::new()
Add-Line $lines '# HSRB-004 Helper File Surface Preflight and Planetary Gate Selector Disposition Index Closeout - V0.1'
Add-Line $lines ''
Add-Line $lines 'Status: CLOSEOUT / CONTRACT_FIRST / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $lines ''
Add-Line $lines '## Purpose'
Add-Line $lines ''
Add-Line $lines 'Close out the HSRB-004 disposition index V0.3 after the V0.1 and V0.2 same-object repair chain. This verifies the index as review-only evidence and confirms no helper execution, routing, cleanup, doctrine promotion, commit, or push was cleared.'
Add-Line $lines ''
Add-Line $lines '## Verified inputs'
Add-Line $lines ''
Add-Line $lines '| Input | Exists | HashMatch | SHA256 |'
Add-Line $lines '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) { Add-Line $lines ('| {0} | {1} | {2} | `{3}` |' -f (Escape-MdCell $h.Name), $h.Exists, $h.HashMatch, $h.ActualSha256) }
Add-Line $lines ''
Add-Line $lines '## Contract gate'
Add-Line $lines ''
Add-Line $lines ('- contract_gate_passed: {0}' -f $contractGatePassed)
Add-Line $lines ('- blocker_count: {0}' -f $blockerCount)
Add-Line $lines '- final_verdict_dominated_by_blocker_count: True'
Add-Line $lines ''
Add-Line $lines '## Counts'
Add-Line $lines ''
Add-Line $lines '- selected_batch_id: HSRB-004'
Add-Line $lines ('- selected_batch_rows: {0}' -f $indexRowCount)
Add-Line $lines ('- index_rows: {0}' -f $indexRowCount)
Add-Line $lines ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount)
Add-Line $lines ('- missing_filename_count: {0}' -f $missingFilenameCount)
Add-Line $lines ('- missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
Add-Line $lines ('- missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
Add-Line $lines ('- source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
Add-Line $lines ('- source_missing_count: {0}' -f $sourceMissingCount)
Add-Line $lines ('- unknown_disposition_bucket_count: {0}' -f $unknownDispositionBucketCount)
Add-Line $lines ('- helper_file_surface_preflight_lane_closeout_card_count: {0}' -f $helperFileSurfacePreflightLaneCloseoutCardCount)
Add-Line $lines ('- planetary_gate_helper_file_surface_preflight_closeout_or_next_selector_count: {0}' -f $planetaryGateHelperFileSurfacePreflightCloseoutOrNextSelectorCount)
Add-Line $lines ('- planetary_gate_next_object_selector_heavy_boundary_count: {0}' -f $planetaryGateNextObjectSelectorHeavyBoundaryCount)
Add-Line $lines ('- contains_copy_item_count: {0}' -f $containsCopyItemCount)
Add-Line $lines ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
Add-Line $lines ('- contains_move_item_count: {0}' -f $containsMoveItemCount)
Add-Line $lines ('- contains_remove_item_count: {0}' -f $containsRemoveItemCount)
Add-Line $lines ('- contains_rename_item_count: {0}' -f $containsRenameItemCount)
Add-Line $lines ('- contains_start_process_count: {0}' -f $containsStartProcessCount)
Add-Line $lines ('- contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
Add-Line $lines ('- contains_set_clipboard_count: {0}' -f $containsSetClipboardCount)
Add-Line $lines ('- high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
Add-Line $lines ('- risk_marked_row_count: {0}' -f $riskMarkedRowCount)
Add-Line $lines ('- unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
Add-Line $lines ('- execution_clearance_count: {0}' -f $executionClearanceCount)
Add-Line $lines ('- route_clearance_count: {0}' -f $routeClearanceCount)
Add-Line $lines ('- cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
Add-Line $lines ('- doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
Add-Line $lines ('- action_now_non_no_count: {0}' -f $actionNowNonNoCount)
Add-Line $lines ''
Add-Line $lines '## Decision'
Add-Line $lines ''
Add-Line $lines '- HSRB-004 disposition index V0.3 is accepted as review-only evidence if contract_gate_passed is True.'
Add-Line $lines '- HSRB-004 selected helper files are not cleared for execution.'
Add-Line $lines '- HSRB-004 selected helper files are not route authority, cleanup authority, commit authority, push authority, or doctrine authority.'
Add-Line $lines '- Git markers remain indexed as review-only evidence and non-clearance markers.'
Add-Line $lines '- If this closeout passes, return to the 64-row helper review queue and select the next batch.'
Add-Line $lines ''
Add-Line $lines '## Blockers'
Add-Line $lines ''
Add-Line $lines ('- blocker_count: {0}' -f $blockerCount)
if ($blockerCount -eq 0) { Add-Line $lines '- none' } else { foreach ($b in $blockers) { Add-Line $lines ('- {0}' -f $b) } }
Add-Line $lines ''
Add-Line $lines '## Next single action'
Add-Line $lines ''
Add-Line $lines $nextSingleAction
Add-Line $lines ''
Add-Line $lines '## Final verdict'
Add-Line $lines ''
Add-Line $lines $finalVerdict
Add-Line $lines ''
Add-Line $lines '## Physical actions'
Add-Line $lines ''
Add-Line $lines 'move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

Write-LinesNoBom -Path $OutCloseoutPath -List $lines
$closeoutSha = Get-Sha256Safe -Path $OutCloseoutPath
Copy-Item -LiteralPath $OutCloseoutPath -Destination $OutCloseoutPrintPath -Force
$closeoutPrintSha = Get-Sha256Safe -Path $OutCloseoutPrintPath

$receipt = [System.Collections.Generic.List[string]]::new()
Add-Line $receipt 'HSRB-004 HELPER FILE SURFACE PREFLIGHT AND PLANETARY GATE SELECTOR DISPOSITION INDEX CLOSEOUT RECEIPT V0.1'
Add-Line $receipt ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
Add-Line $receipt ('output_closeout_path: {0}' -f $OutCloseoutPath)
Add-Line $receipt ('output_closeout_sha256: {0}' -f $closeoutSha)
Add-Line $receipt ('output_closeout_print_path: {0}' -f $OutCloseoutPrintPath)
Add-Line $receipt ('output_closeout_print_sha256: {0}' -f $closeoutPrintSha)
Add-Line $receipt ('contract_gate_passed: {0}' -f $contractGatePassed)
Add-Line $receipt 'selected_batch_id: HSRB-004'
Add-Line $receipt ('selected_batch_rows: {0}' -f $indexRowCount)
Add-Line $receipt ('index_rows: {0}' -f $indexRowCount)
Add-Line $receipt ('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
Add-Line $receipt ('missing_filename_count: {0}' -f $missingFilenameCount)
Add-Line $receipt ('missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
Add-Line $receipt ('missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
Add-Line $receipt ('source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
Add-Line $receipt ('source_missing_count: {0}' -f $sourceMissingCount)
Add-Line $receipt ('unknown_disposition_bucket_count: {0}' -f $unknownDispositionBucketCount)
Add-Line $receipt ('helper_file_surface_preflight_lane_closeout_card_count: {0}' -f $helperFileSurfacePreflightLaneCloseoutCardCount)
Add-Line $receipt ('planetary_gate_helper_file_surface_preflight_closeout_or_next_selector_count: {0}' -f $planetaryGateHelperFileSurfacePreflightCloseoutOrNextSelectorCount)
Add-Line $receipt ('planetary_gate_next_object_selector_heavy_boundary_count: {0}' -f $planetaryGateNextObjectSelectorHeavyBoundaryCount)
Add-Line $receipt ('contains_copy_item_count: {0}' -f $containsCopyItemCount)
Add-Line $receipt ('contains_git_command_count: {0}' -f $containsGitCommandCount)
Add-Line $receipt ('contains_move_item_count: {0}' -f $containsMoveItemCount)
Add-Line $receipt ('contains_remove_item_count: {0}' -f $containsRemoveItemCount)
Add-Line $receipt ('contains_rename_item_count: {0}' -f $containsRenameItemCount)
Add-Line $receipt ('contains_start_process_count: {0}' -f $containsStartProcessCount)
Add-Line $receipt ('contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
Add-Line $receipt ('contains_set_clipboard_count: {0}' -f $containsSetClipboardCount)
Add-Line $receipt ('high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
Add-Line $receipt ('risk_marked_row_count: {0}' -f $riskMarkedRowCount)
Add-Line $receipt ('unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
Add-Line $receipt ('execution_clearance_count: {0}' -f $executionClearanceCount)
Add-Line $receipt ('route_clearance_count: {0}' -f $routeClearanceCount)
Add-Line $receipt ('cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
Add-Line $receipt ('doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
Add-Line $receipt ('action_now_non_no_count: {0}' -f $actionNowNonNoCount)
Add-Line $receipt ('blocker_count: {0}' -f $blockerCount)
Add-Line $receipt ('next_single_action: {0}' -f $nextSingleAction)
Add-Line $receipt ('final_verdict: {0}' -f $finalVerdict)
Add-Line $receipt ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)

Write-LinesNoBom -Path $OutReceiptPath -List $receipt
$receiptSha = Get-Sha256Safe -Path $OutReceiptPath

Write-Output '=== HSRB-004 HELPER FILE SURFACE PREFLIGHT AND PLANETARY GATE SELECTOR DISPOSITION INDEX CLOSEOUT V0.1 COMPLETE ==='
Write-Output ("output_closeout_path: {0}" -f $OutCloseoutPath)
Write-Output ("output_closeout_sha256: {0}" -f $closeoutSha)
Write-Output ("output_closeout_print_path: {0}" -f $OutCloseoutPrintPath)
Write-Output ("output_closeout_print_sha256: {0}" -f $closeoutPrintSha)
Write-Output ("output_receipt_path: {0}" -f $OutReceiptPath)
Write-Output ("output_receipt_sha256: {0}" -f $receiptSha)
Write-Output ("contract_gate_passed: {0}" -f $contractGatePassed)
Write-Output 'selected_batch_id: HSRB-004'
Write-Output ("selected_batch_rows: {0}" -f $indexRowCount)
Write-Output ("index_rows: {0}" -f $indexRowCount)
Write-Output ("blank_ticket_id_count: {0}" -f $blankTicketIdCount)
Write-Output ("missing_filename_count: {0}" -f $missingFilenameCount)
Write-Output ("missing_declared_sha256_count: {0}" -f $missingDeclaredSha256Count)
Write-Output ("missing_actual_sha256_count: {0}" -f $missingActualSha256Count)
Write-Output ("source_hash_mismatch_count: {0}" -f $sourceHashMismatchCount)
Write-Output ("source_missing_count: {0}" -f $sourceMissingCount)
Write-Output ("unknown_disposition_bucket_count: {0}" -f $unknownDispositionBucketCount)
Write-Output ("helper_file_surface_preflight_lane_closeout_card_count: {0}" -f $helperFileSurfacePreflightLaneCloseoutCardCount)
Write-Output ("planetary_gate_helper_file_surface_preflight_closeout_or_next_selector_count: {0}" -f $planetaryGateHelperFileSurfacePreflightCloseoutOrNextSelectorCount)
Write-Output ("planetary_gate_next_object_selector_heavy_boundary_count: {0}" -f $planetaryGateNextObjectSelectorHeavyBoundaryCount)
Write-Output ("contains_copy_item_count: {0}" -f $containsCopyItemCount)
Write-Output ("contains_git_command_count: {0}" -f $containsGitCommandCount)
Write-Output ("contains_move_item_count: {0}" -f $containsMoveItemCount)
Write-Output ("contains_remove_item_count: {0}" -f $containsRemoveItemCount)
Write-Output ("contains_rename_item_count: {0}" -f $containsRenameItemCount)
Write-Output ("contains_start_process_count: {0}" -f $containsStartProcessCount)
Write-Output ("contains_invoke_expression_count: {0}" -f $containsInvokeExpressionCount)
Write-Output ("contains_set_clipboard_count: {0}" -f $containsSetClipboardCount)
Write-Output ("high_risk_command_marker_row_count: {0}" -f $highRiskCommandMarkerRowCount)
Write-Output ("risk_marked_row_count: {0}" -f $riskMarkedRowCount)
Write-Output ("unclassified_risk_marker_count: {0}" -f $unclassifiedRiskMarkerCount)
Write-Output ("execution_clearance_count: {0}" -f $executionClearanceCount)
Write-Output ("route_clearance_count: {0}" -f $routeClearanceCount)
Write-Output ("cleanup_clearance_count: {0}" -f $cleanupClearanceCount)
Write-Output ("doctrine_promotion_count: {0}" -f $doctrinePromotionCount)
Write-Output ("action_now_non_no_count: {0}" -f $actionNowNonNoCount)
Write-Output ("blocker_count: {0}" -f $blockerCount)
Write-Output ("next_single_action: {0}" -f $nextSingleAction)
Write-Output ("final_verdict: {0}" -f $finalVerdict)
Write-Output ("physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}" -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
