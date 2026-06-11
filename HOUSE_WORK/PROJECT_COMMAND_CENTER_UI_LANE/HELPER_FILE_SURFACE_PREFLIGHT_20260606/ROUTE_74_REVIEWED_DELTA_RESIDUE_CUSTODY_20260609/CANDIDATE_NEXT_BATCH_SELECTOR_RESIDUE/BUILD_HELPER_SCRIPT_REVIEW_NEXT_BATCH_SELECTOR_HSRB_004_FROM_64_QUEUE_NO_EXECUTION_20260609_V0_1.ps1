Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$Stamp = '20260609'
$BatchId = 'HSRB-004'
$BatchName = 'HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN'

$QueueCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$HsrB003RiskIndexCloseoutPath = Join-Path $Lane 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$HsrB003RiskIndexCloseoutReceiptPath = Join-Path $Lane 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedQueueSha = '791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43'
$ExpectedHsrB003CloseoutSha = 'F13DB92367A72054D44D7810295850A7E0513A08EF17FA5ED2678A1800E41C2F'
$ExpectedHsrB003CloseoutReceiptSha = '8CC56ACB7B60C521F1ED37BC0663E465BF455679B0E0792E5EDB1BDAD8869CDB'

$OutSelectedCsv = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_004_V0_1_20260609.csv'
$OutMd = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$OutPrint = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutReceipt = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Write-TextNoBom {
    param([Parameter(Mandatory=$true)][string]$Path, [AllowNull()]$Lines)
    $items = @()
    foreach ($line in @($Lines)) {
        if ($null -eq $line) { $items += '' } else { $items += [string]$line }
    }
    $text = [string]::Join([Environment]::NewLine, [string[]]$items)
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256Safe {
    param([AllowNull()][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Count-Items {
    param([AllowNull()]$Value)
    return [int](@($Value).Count)
}

function Get-Cell {
    param($Row, [string[]]$Names)
    if ($null -eq $Row) { return '' }
    $props = @($Row.PSObject.Properties)
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

function Normalize-Key {
    param([AllowNull()]$Value)
    $s = [string]$Value
    if ([string]::IsNullOrWhiteSpace($s)) { return '' }
    return ([System.IO.Path]::GetFileName($s.Trim().Trim('"'))).ToLowerInvariant()
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
    foreach ($name in @('SourcePath','FullPath','Path','LiteralPath','FullName')) {
        $candidate = Get-Cell -Row $Row -Names @($name)
        if (-not [string]::IsNullOrWhiteSpace($candidate)) { return $candidate.Trim().Trim('"') }
    }
    if ([string]::IsNullOrWhiteSpace($FileName)) { return '' }
    return (Join-Path $Root $FileName)
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }
if (-not (Test-Path -LiteralPath $QueueCsvPath -PathType Leaf)) { throw "Queue CSV not found: $QueueCsvPath" }

$QueueSha = Get-Sha256Safe -Path $QueueCsvPath
$HsrB003CloseoutSha = Get-Sha256Safe -Path $HsrB003RiskIndexCloseoutPath
$HsrB003CloseoutReceiptSha = Get-Sha256Safe -Path $HsrB003RiskIndexCloseoutReceiptPath

$InputQueueVerified = ($QueueSha -eq $ExpectedQueueSha)
$HsrB003RiskIndexCloseoutVerified = ($HsrB003CloseoutSha -eq $ExpectedHsrB003CloseoutSha)
$HsrB003RiskIndexCloseoutReceiptVerified = ($HsrB003CloseoutReceiptSha -eq $ExpectedHsrB003CloseoutReceiptSha)

$queueRows = @(Import-Csv -LiteralPath $QueueCsvPath)

$targetFileNames = @(
    'BUILD_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.ps1',
    'BUILD_PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608.ps1',
    'BUILD_PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608_HEAVY_BOUNDARY.ps1'
)

$ticketFallback = @{
    'build_helper_file_surface_preflight_lane_closeout_card_20260608.ps1' = 'RHG-DRY-002'
    'build_planetary_gate_helper_file_surface_preflight_closeout_or_next_selector_20260608.ps1' = 'RHG-DRY-003'
    'build_planetary_gate_next_object_selector_from_helper_file_surface_preflight_20260608_heavy_boundary.ps1' = 'RHG-DRY-004'
}

$selectedRows = @()
foreach ($file in $targetFileNames) {
    $key = Normalize-Key $file
    $matches = @($queueRows | Where-Object { (Normalize-Key (Get-FileNameCell -Row $_)) -eq $key })
    $sourceRow = $null
    if ((Count-Items $matches) -gt 0) { $sourceRow = $matches[0] }

    $ticket = ''
    $ticketSource = 'MISSING'
    if ($null -ne $sourceRow) {
        $ticket = Get-Cell -Row $sourceRow -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID','ReviewTicketID','RowID','RowId','ID')
        if (-not [string]::IsNullOrWhiteSpace($ticket)) { $ticketSource = 'SOURCE_FIELD' }
    }
    if ([string]::IsNullOrWhiteSpace($ticket) -and $ticketFallback.ContainsKey($key)) {
        $ticket = $ticketFallback[$key]
        $ticketSource = 'STATIC_QUEUE_ORDER_FALLBACK'
    }

    $sourcePath = ''
    if ($null -ne $sourceRow) { $sourcePath = Resolve-SourcePath -Row $sourceRow -FileName $file }
    if ([string]::IsNullOrWhiteSpace($sourcePath)) { $sourcePath = Join-Path $Root $file }
    $sourcePresent = Test-Path -LiteralPath $sourcePath -PathType Leaf

    $declaredSha = ''
    if ($null -ne $sourceRow) {
        $declaredSha = Get-Cell -Row $sourceRow -Names @('SourceSha256','SourceSHA256','SHA256','Sha256','Hash','FileSHA256','ActualSha256')
    }
    $actualSha = ''
    if ($sourcePresent) { $actualSha = Get-Sha256Safe -Path $sourcePath }
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = $actualSha }

    $roleLabel = ''
    $riskLabel = ''
    $userDecision = ''
    if ($null -ne $sourceRow) {
        $roleLabel = Get-Cell -Row $sourceRow -Names @('RoleLabel','Role','OriginalRoleLabel','BoardClass','Class','ReviewRole')
        $riskLabel = Get-Cell -Row $sourceRow -Names @('RiskLabel','Risk','OriginalRiskLabel','RiskClass')
        $userDecision = Get-Cell -Row $sourceRow -Names @('UserDecision','Decision','ManualDecision')
    }

    $reviewDisposition = 'REVIEW_ONLY__HELPER_FILE_SURFACE_PREFLIGHT_PLANETARY_GATE_SELECTOR_CHAIN'
    if ($null -eq $sourceRow) { $reviewDisposition = 'MISSING_FROM_64_QUEUE_BLOCKER' }

    $selectedRows += [pscustomobject]@{
        BatchID = $BatchId
        BatchName = $BatchName
        TicketID = [string]$ticket
        TicketIDSource = [string]$ticketSource
        FileName = [string]$file
        SourcePath = [string]$sourcePath
        SourcePresent = [bool]$sourcePresent
        DeclaredSha256 = [string]$declaredSha
        ActualSha256 = [string]$actualSha
        SourceHashMatch = [bool]((-not [string]::IsNullOrWhiteSpace($declaredSha)) -and (-not [string]::IsNullOrWhiteSpace($actualSha)) -and ($declaredSha -eq $actualSha))
        RoleLabel = [string]$roleLabel
        RiskLabel = [string]$riskLabel
        UserDecision = [string]$userDecision
        StaticReviewOnly = 'YES'
        ExecutionAllowed = 'NO'
        RouteAllowed = 'NO'
        CleanupAllowed = 'NO'
        DoctrinePromotionAllowed = 'NO'
        ActionNow = 'NO'
        ReviewDisposition = [string]$reviewDisposition
    }
}

$selectedRows | Export-Csv -LiteralPath $OutSelectedCsv -NoTypeInformation -Encoding UTF8
$OutSelectedCsvSha = Get-Sha256Safe -Path $OutSelectedCsv

$selectedCount = Count-Items $selectedRows
$sourcePresentCount = Count-Items (@($selectedRows | Where-Object { $_.SourcePresent -eq $true }))
$sourceMissingCount = Count-Items (@($selectedRows | Where-Object { $_.SourcePresent -ne $true }))
$blankTicketIdCount = Count-Items (@($selectedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.TicketID) }))
$missingFileNameCount = Count-Items (@($selectedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.FileName) }))
$missingDeclaredShaCount = Count-Items (@($selectedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.DeclaredSha256) }))
$missingActualShaCount = Count-Items (@($selectedRows | Where-Object { [string]::IsNullOrWhiteSpace($_.ActualSha256) }))
$sourceHashMismatchCount = Count-Items (@($selectedRows | Where-Object { $_.SourceHashMatch -ne $true }))
$reviewOnlyCount = Count-Items (@($selectedRows | Where-Object { $_.StaticReviewOnly -eq 'YES' -and $_.ExecutionAllowed -eq 'NO' -and $_.RouteAllowed -eq 'NO' -and $_.CleanupAllowed -eq 'NO' }))
$actionNowNonNoCount = Count-Items (@($selectedRows | Where-Object { $_.ActionNow -ne 'NO' }))

$blockers = @()
if (-not $InputQueueVerified) { $blockers += 'INPUT_QUEUE_HASH_NOT_VERIFIED' }
if (-not $HsrB003RiskIndexCloseoutVerified) { $blockers += 'HSRB_003_RISK_INDEX_CLOSEOUT_HASH_NOT_VERIFIED' }
if (-not $HsrB003RiskIndexCloseoutReceiptVerified) { $blockers += 'HSRB_003_RISK_INDEX_CLOSEOUT_RECEIPT_HASH_NOT_VERIFIED' }
if ($selectedCount -ne 3) { $blockers += ('UNEXPECTED_SELECTED_BATCH_ROWS_{0}' -f $selectedCount) }
if ($sourceMissingCount -ne 0) { $blockers += ('SOURCE_MISSING_COUNT_{0}' -f $sourceMissingCount) }
if ($blankTicketIdCount -ne 0) { $blockers += ('BLANK_TICKET_ID_COUNT_{0}' -f $blankTicketIdCount) }
if ($missingFileNameCount -ne 0) { $blockers += ('MISSING_FILENAME_COUNT_{0}' -f $missingFileNameCount) }
if ($missingDeclaredShaCount -ne 0) { $blockers += ('MISSING_DECLARED_SHA256_COUNT_{0}' -f $missingDeclaredShaCount) }
if ($missingActualShaCount -ne 0) { $blockers += ('MISSING_ACTUAL_SHA256_COUNT_{0}' -f $missingActualShaCount) }
if ($sourceHashMismatchCount -ne 0) { $blockers += ('SOURCE_HASH_MISMATCH_COUNT_{0}' -f $sourceHashMismatchCount) }
if ($reviewOnlyCount -ne 3) { $blockers += ('REVIEW_ONLY_COUNT_UNEXPECTED_{0}' -f $reviewOnlyCount) }
if ($actionNowNonNoCount -ne 0) { $blockers += ('ACTION_NOW_NON_NO_COUNT_{0}' -f $actionNowNonNoCount) }
if ([string]::IsNullOrWhiteSpace($OutSelectedCsvSha)) { $blockers += 'OUTPUT_SELECTED_CSV_SHA256_BLANK' }

$blockerCount = Count-Items $blockers
$contractGatePassed = ($blockerCount -eq 0)
$finalVerdict = if ($contractGatePassed) { 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }
$nextSingleAction = if ($contractGatePassed) { 'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_004_BATCH_SELECTOR_BLOCKERS_NO_EXECUTION' }

$md = @(
    '# Helper Script Review Next Batch Selector HSRB-004 From 64 Queue - No Execution - V0.1',
    '',
    'Status: BATCH_SELECTOR / CONTRACT_FIRST / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH',
    '',
    '## Purpose',
    '',
    'Select HSRB-004 from the 64-row helper-script review queue after HSRB-003 risk marker and disposition index closeout.',
    '',
    'HSRB-004 covers the helper file surface preflight and planetary gate selector chain. This selector writes proof and review surfaces only.',
    '',
    '## Authority boundary',
    '',
    '- No helper script execution.',
    '- No move/delete/rename.',
    '- No route or cleanup.',
    '- No commit or push.',
    '- No doctrine promotion.',
    '- Selected rows remain review-only.',
    '',
    '## Verified inputs',
    '',
    ('- input_queue_verified: {0}' -f $InputQueueVerified),
    ('- input_queue_sha256: `{0}`' -f $QueueSha),
    ('- hsrb_003_risk_index_closeout_verified: {0}' -f $HsrB003RiskIndexCloseoutVerified),
    ('- hsrb_003_risk_index_closeout_sha256: `{0}`' -f $HsrB003CloseoutSha),
    ('- hsrb_003_risk_index_closeout_receipt_verified: {0}' -f $HsrB003RiskIndexCloseoutReceiptVerified),
    ('- hsrb_003_risk_index_closeout_receipt_sha256: `{0}`' -f $HsrB003CloseoutReceiptSha),
    '',
    '## Counts',
    '',
    ('- selected_batch_id: {0}' -f $BatchId),
    ('- selected_batch_rows: {0}' -f $selectedCount),
    ('- source_present_count: {0}' -f $sourcePresentCount),
    ('- source_missing_count: {0}' -f $sourceMissingCount),
    ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount),
    ('- missing_filename_count: {0}' -f $missingFileNameCount),
    ('- missing_declared_sha256_count: {0}' -f $missingDeclaredShaCount),
    ('- missing_actual_sha256_count: {0}' -f $missingActualShaCount),
    ('- source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount),
    ('- review_only_count: {0}' -f $reviewOnlyCount),
    ('- action_now_non_no_count: {0}' -f $actionNowNonNoCount),
    ('- blocker_count: {0}' -f $blockerCount),
    '',
    '## Selected rows',
    '',
    '| TicketID | FileName | SourcePresent | SHA256 | ReviewDisposition |',
    '| --- | --- | ---: | --- | --- |'
)
foreach ($r in $selectedRows) {
    $md += ('| {0} | `{1}` | {2} | `{3}` | {4} |' -f $r.TicketID, $r.FileName, $r.SourcePresent, $r.ActualSha256, $r.ReviewDisposition)
}
$md += @(
    '',
    '## Blockers',
    ''
)
if ($blockerCount -eq 0) { $md += 'None.' } else { foreach ($b in $blockers) { $md += ('- {0}' -f $b) } }
$md += @(
    '',
    '## Next single action',
    '',
    $nextSingleAction,
    '',
    ('Final verdict: {0}' -f $finalVerdict),
    '',
    ('Physical actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
)

Write-TextNoBom -Path $OutMd -Lines $md
Write-TextNoBom -Path $OutPrint -Lines $md
$OutMdSha = Get-Sha256Safe -Path $OutMd
$OutPrintSha = Get-Sha256Safe -Path $OutPrint

$receipt = @(
    'HSRB-004 BATCH SELECTOR RECEIPT V0.1',
    ('output_selected_batch_csv_path: {0}' -f $OutSelectedCsv),
    ('output_selected_batch_csv_sha256: {0}' -f $OutSelectedCsvSha),
    ('output_md_path: {0}' -f $OutMd),
    ('output_md_sha256: {0}' -f $OutMdSha),
    ('output_print_path: {0}' -f $OutPrint),
    ('output_print_sha256: {0}' -f $OutPrintSha),
    ('input_queue_verified: {0}' -f $InputQueueVerified),
    ('hsrb_003_risk_index_closeout_verified: {0}' -f $HsrB003RiskIndexCloseoutVerified),
    ('hsrb_003_risk_index_closeout_receipt_verified: {0}' -f $HsrB003RiskIndexCloseoutReceiptVerified),
    ('selected_batch_id: {0}' -f $BatchId),
    ('selected_batch_rows: {0}' -f $selectedCount),
    ('source_present_count: {0}' -f $sourcePresentCount),
    ('source_missing_count: {0}' -f $sourceMissingCount),
    ('blank_ticket_id_count: {0}' -f $blankTicketIdCount),
    ('missing_declared_sha256_count: {0}' -f $missingDeclaredShaCount),
    ('missing_actual_sha256_count: {0}' -f $missingActualShaCount),
    ('source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount),
    ('review_only_count: {0}' -f $reviewOnlyCount),
    ('action_now_non_no_count: {0}' -f $actionNowNonNoCount),
    ('blocker_count: {0}' -f $blockerCount),
    ('next_single_action: {0}' -f $nextSingleAction),
    ('final_verdict: {0}' -f $finalVerdict),
    ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
)
Write-TextNoBom -Path $OutReceipt -Lines $receipt
$OutReceiptSha = Get-Sha256Safe -Path $OutReceipt

Write-Host '=== HELPER SCRIPT REVIEW NEXT BATCH SELECTOR HSRB-004 FROM 64 QUEUE V0.1 COMPLETE ==='
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
Write-Host "hsrb_003_risk_index_closeout_verified: $HsrB003RiskIndexCloseoutVerified"
Write-Host "hsrb_003_risk_index_closeout_receipt_verified: $HsrB003RiskIndexCloseoutReceiptVerified"
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
Write-Host "action_now_non_no_count: $actionNowNonNoCount"
Write-Host "blocker_count: $blockerCount"
Write-Host "next_single_action: $nextSingleAction"
Write-Host "final_verdict: $finalVerdict"
Write-Host ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
