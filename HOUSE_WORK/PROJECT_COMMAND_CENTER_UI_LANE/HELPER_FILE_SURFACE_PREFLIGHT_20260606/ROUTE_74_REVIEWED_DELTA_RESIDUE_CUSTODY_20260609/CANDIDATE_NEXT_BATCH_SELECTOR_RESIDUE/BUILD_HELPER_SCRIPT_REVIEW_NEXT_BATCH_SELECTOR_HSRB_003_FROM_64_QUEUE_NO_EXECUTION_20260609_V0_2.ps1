Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$QueueCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$HsrB001ProofCloseoutPath = Join-Path $Lane 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$HsrB002IndexCloseoutPath = Join-Path $Lane 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_5_20260609.md'
$HsrB002EvidencePath = Join-Path $Lane 'HELPER_GENERATION_EVIDENCE__DERIVED_INDEXES_MUST_VALIDATE_TICKET_ID_ROLE_COUNTS_AND_SHA_TOGETHER_20260609.md'
$V01SelectedBatchCsv = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_003_V0_1_20260609.csv'
$V01ReportMd = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'

$BatchId = 'HSRB-003'
$BatchName = 'ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN'
$Stamp = '20260609'

$V01ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__HSRB_003_BATCH_SELECTOR_V0_1_BLANK_TICKET_ID_CUSTODY_DISPLAY_DEFECT_20260609.md'
$FixNotePath = Join-Path $Lane 'FIX_NOTE__HSRB_003_BATCH_SELECTOR_V0_2_TICKET_ID_CUSTODY_REPAIR_20260609.md'
$FixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__HSRB_003_BATCH_SELECTOR_V0_2_TICKET_ID_CUSTODY_REPAIR_20260609.txt'
$HelperEvidencePath = Join-Path $Lane 'HELPER_GENERATION_EVIDENCE__BATCH_SELECTORS_MUST_VALIDATE_TICKET_ID_AND_SHA_TOGETHER_20260609.md'

$OutSelectedCsv = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_003_V0_2_20260609.csv'
$OutMd = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$OutPrint = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$OutReceipt = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Write-LinesNoBom {
    param([Parameter(Mandatory=$true)][string]$Path, [AllowNull()]$Lines)
    $list = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($Lines)) {
        if ($null -eq $line) { [void]$list.Add('') } else { [void]$list.Add([string]$line) }
    }
    $text = [string]::Join([Environment]::NewLine, [string[]]$list.ToArray())
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256Safe {
    param([AllowNull()][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Count-Items {
    param($Value)
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
    param($Value)
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
        if (-not [string]::IsNullOrWhiteSpace($candidate)) { return $candidate }
    }
    if ([string]::IsNullOrWhiteSpace($FileName)) { return '' }
    return (Join-Path $Root $FileName)
}

function Is-TrueText {
    param($Value)
    $s = ([string]$Value).Trim()
    return ($s -ieq 'true' -or $s -eq '1' -or $s -ieq 'yes')
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }
if (-not (Test-Path -LiteralPath $QueueCsvPath -PathType Leaf)) { throw "Input queue CSV not found: $QueueCsvPath" }

$QueueExpectedSha = '791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43'
$HsrB001ExpectedSha = 'B4CE65335BEBB4771A947066CDD468B81BF9B39EB155D9D53AC3DC71C1A523EA'
$HsrB002ExpectedSha = 'F76388ACDD752D9D72B3E6E7F3B56955D4B4700A094881D5AA6E6E26E23BD776'
$HsrB002EvidenceExpectedSha = '32D8D09C1C9043785F8A5D3FE4355533A9B7DFF868B4E8D7E5845E7DAE592FC8'
$V01SelectedBatchExpectedSha = '96A011BC696125CD3ADE90E2D46FDBEA04B837EB1183CACA1118A22FFC0E1545'
$V01ReportExpectedSha = '976FBAB6899ED1009864BD8CB68663957B602306793D636E36ABD94E4DCC2C09'

$QueueSha = Get-Sha256Safe -Path $QueueCsvPath
$HsrB001Sha = Get-Sha256Safe -Path $HsrB001ProofCloseoutPath
$HsrB002Sha = Get-Sha256Safe -Path $HsrB002IndexCloseoutPath
$HsrB002EvidenceSha = Get-Sha256Safe -Path $HsrB002EvidencePath
$V01SelectedBatchSha = Get-Sha256Safe -Path $V01SelectedBatchCsv
$V01ReportSha = Get-Sha256Safe -Path $V01ReportMd

$InputQueueVerified = ($QueueSha -eq $QueueExpectedSha)
$HsrB001ProofCloseoutVerified = ($HsrB001Sha -eq $HsrB001ExpectedSha)
$HsrB002IndexCloseoutVerified = ($HsrB002Sha -eq $HsrB002ExpectedSha)
$HsrB002EvidenceVerified = ($HsrB002EvidenceSha -eq $HsrB002EvidenceExpectedSha)
$V01SelectedBatchVerified = ($V01SelectedBatchSha -eq $V01SelectedBatchExpectedSha)
$V01ReportVerified = ($V01ReportSha -eq $V01ReportExpectedSha)

$queueRows = @(Import-Csv -LiteralPath $QueueCsvPath)
$v01Rows = @()
if (Test-Path -LiteralPath $V01SelectedBatchCsv -PathType Leaf) { $v01Rows = @(Import-Csv -LiteralPath $V01SelectedBatchCsv) }

$targetFileNames = @(
    'BUILD_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.ps1',
    'BUILD_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.ps1',
    'BUILD_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.ps1',
    'BUILD_ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_20260608.ps1',
    'BUILD_ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608.ps1',
    'BUILD_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.ps1',
    'BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.ps1',
    'BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.ps1',
    'BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_20260608.ps1'
)

$ticketFallback = @{
    'build_root_drop_intake_washer_helper_candidate_option_set_20260608.ps1' = 'RHG-DRY-005'
    'build_root_drop_intake_washer_old_load_or_system_option_set_v0_2_20260608.ps1' = 'RHG-DRY-006'
    'build_root_drop_intake_washer_queue_closeout_and_next_action_card_20260608.ps1' = 'RHG-DRY-007'
    'build_root_drop_intake_washer_review_queue_20260608.ps1' = 'RHG-DRY-008'
    'build_root_drop_intake_washer_review_queue_summary_and_option_set_20260608.ps1' = 'RHG-DRY-009'
    'build_root_drop_intake_washer_source_authority_candidate_option_set_20260608.ps1' = 'RHG-DRY-010'
    'build_root_drop_intake_washer_support_candidate_option_set_20260608.ps1' = 'RHG-DRY-011'
    'build_root_drop_intake_washer_support_candidate_option_set_v0_2_20260608.ps1' = 'RHG-DRY-012'
    'build_root_drop_intake_washer_support_card_schema_and_dry_run_20260608.ps1' = 'RHG-DRY-013'
}

$ticketMap = @{}
$pathMap = @{}
$shaMap = @{}
$roleLabelMap = @{}
$riskLabelMap = @{}
$userDecisionMap = @{}

foreach ($r in @($queueRows + $v01Rows)) {
    $fn = Get-FileNameCell -Row $r
    $key = Normalize-Key $fn
    if ($key -eq '') { continue }

    $ticket = Get-Cell -Row $r -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID','ReviewTicketID','RowID','RowId','ID')
    if (-not [string]::IsNullOrWhiteSpace($ticket)) { $ticketMap[$key] = $ticket.Trim() }

    $path = Resolve-SourcePath -Row $r -FileName $fn
    if (-not [string]::IsNullOrWhiteSpace($path)) { $pathMap[$key] = $path }

    $sha = Get-Cell -Row $r -Names @('SourceSha256','SourceSHA256','SHA256','Sha256','Hash','FileSHA256','ActualSha256')
    if (-not [string]::IsNullOrWhiteSpace($sha)) { $shaMap[$key] = $sha.Trim() }

    $role = Get-Cell -Row $r -Names @('OriginalRoleLabel','RoleLabel','BoardClass','Class','ReviewRole')
    if (-not [string]::IsNullOrWhiteSpace($role)) { $roleLabelMap[$key] = $role.Trim() }

    $risk = Get-Cell -Row $r -Names @('OriginalRiskLabel','RiskLabel','Risk','RiskClass')
    if (-not [string]::IsNullOrWhiteSpace($risk)) { $riskLabelMap[$key] = $risk.Trim() }

    $decision = Get-Cell -Row $r -Names @('UserDecision','Decision','ManualDecision')
    if (-not [string]::IsNullOrWhiteSpace($decision)) { $userDecisionMap[$key] = $decision.Trim() }
}

$selected = @()
foreach ($file in $targetFileNames) {
    $key = Normalize-Key $file
    $queueMatch = @($queueRows | Where-Object { (Normalize-Key (Get-FileNameCell -Row $_)) -eq $key })
    $v01Match = @($v01Rows | Where-Object { (Normalize-Key (Get-FileNameCell -Row $_)) -eq $key })
    $sourceRow = $null
    if ((Count-Items $queueMatch) -gt 0) { $sourceRow = $queueMatch[0] }
    elseif ((Count-Items $v01Match) -gt 0) { $sourceRow = $v01Match[0] }

    $ticket = ''
    $ticketSource = 'MISSING'
    if ($ticketMap.ContainsKey($key)) { $ticket = $ticketMap[$key]; $ticketSource = 'SOURCE_FIELD' }
    elseif ($ticketFallback.ContainsKey($key)) { $ticket = $ticketFallback[$key]; $ticketSource = 'STATIC_QUEUE_ORDER_FALLBACK' }

    $sourcePath = ''
    if ($pathMap.ContainsKey($key)) { $sourcePath = $pathMap[$key] }
    elseif ($null -ne $sourceRow) { $sourcePath = Resolve-SourcePath -Row $sourceRow -FileName $file }
    else { $sourcePath = Join-Path $Root $file }

    $sourceExists = (-not [string]::IsNullOrWhiteSpace($sourcePath)) -and (Test-Path -LiteralPath $sourcePath -PathType Leaf)
    $sourceSha = ''
    if ($shaMap.ContainsKey($key)) { $sourceSha = $shaMap[$key] }
    if ([string]::IsNullOrWhiteSpace($sourceSha) -and $sourceExists) { $sourceSha = Get-Sha256Safe -Path $sourcePath }

    $presentInQueue = ((Count-Items $queueMatch) -gt 0)
    $presentInV01 = ((Count-Items $v01Match) -gt 0)

    $roleLabel = ''; if ($roleLabelMap.ContainsKey($key)) { $roleLabel = $roleLabelMap[$key] }
    $riskLabel = ''; if ($riskLabelMap.ContainsKey($key)) { $riskLabel = $riskLabelMap[$key] }
    $userDecision = ''; if ($userDecisionMap.ContainsKey($key)) { $userDecision = $userDecisionMap[$key] }

    $disposition = 'STATIC_REVIEW_REQUIRED_NO_EXECUTION'
    if (-not $presentInQueue) { $disposition = 'MISSING_FROM_QUEUE_BLOCKER' }

    $selected += [pscustomobject]@{
        BatchID = $BatchId
        BatchName = $BatchName
        TicketID = [string]$ticket
        TicketIDSource = [string]$ticketSource
        FileName = [string]$file
        ReviewRole = 'ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_REVIEW_ONLY'
        ProposedStaticDisposition = [string]$disposition
        SourcePath = [string]$sourcePath
        SourceExists = [bool]$sourceExists
        SHA256 = [string]$sourceSha
        PresentInQueue = [bool]$presentInQueue
        PresentInV01Selection = [bool]$presentInV01
        OriginalRoleLabel = [string]$roleLabel
        OriginalRiskLabel = [string]$riskLabel
        UserDecision = [string]$userDecision
    }
}

$selectedRows = @($selected)
$selectedRows | Export-Csv -LiteralPath $OutSelectedCsv -NoTypeInformation -Encoding UTF8

$selectedBatchRows = Count-Items $selectedRows
$sourcePresentCount = Count-Items (@($selectedRows | Where-Object { $_.SourceExists -eq $true }))
$sourceMissingCount = Count-Items (@($selectedRows | Where-Object { $_.SourceExists -ne $true }))
$blankTicketIdCount = Count-Items (@($selectedRows | Where-Object { [string]::IsNullOrWhiteSpace([string]$_.TicketID) }))
$fallbackTicketIdCount = Count-Items (@($selectedRows | Where-Object { ([string]$_.TicketIDSource) -eq 'STATIC_QUEUE_ORDER_FALLBACK' }))
$missingSha256Count = Count-Items (@($selectedRows | Where-Object { [string]::IsNullOrWhiteSpace([string]$_.SHA256) }))
$reviewOnlyCount = Count-Items (@($selectedRows | Where-Object { $_.ProposedStaticDisposition -eq 'STATIC_REVIEW_REQUIRED_NO_EXECUTION' }))
$presentInQueueCount = Count-Items (@($selectedRows | Where-Object { $_.PresentInQueue -eq $true }))
$queueReviewRows = Count-Items $queueRows
$v01BlankTicketIdCount = Count-Items (@($v01Rows | Where-Object { [string]::IsNullOrWhiteSpace((Get-Cell -Row $_ -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID','ReviewTicketID','RowID','RowId','ID'))) }))

$blockerCount = 0
if (-not $InputQueueVerified) { $blockerCount++ }
if (-not $HsrB001ProofCloseoutVerified) { $blockerCount++ }
if (-not $HsrB002IndexCloseoutVerified) { $blockerCount++ }
if (-not $HsrB002EvidenceVerified) { $blockerCount++ }
if (-not $V01SelectedBatchVerified) { $blockerCount++ }
if (-not $V01ReportVerified) { $blockerCount++ }
if ($selectedBatchRows -ne 9) { $blockerCount++ }
if ($presentInQueueCount -ne 9) { $blockerCount++ }
if ($sourceMissingCount -ne 0) { $blockerCount++ }
if ($blankTicketIdCount -ne 0) { $blockerCount++ }
if ($missingSha256Count -ne 0) { $blockerCount++ }
if ($reviewOnlyCount -ne 9) { $blockerCount++ }

$nextSingleAction = if ($blockerCount -eq 0) {
    'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_NO_EXECUTION'
} else {
    'STOP_AND_REVIEW_HSRB_003_BATCH_SELECTOR_V0_2_BLOCKERS_NO_EXECUTION'
}
$finalVerdict = if ($blockerCount -eq 0) {
    'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_V0_2_REPAIRED_TICKET_ID_CUSTODY_WITH_NO_PHYSICAL_ACTION'
} else {
    'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_V0_2_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$errorFreeze = @()
$errorFreeze += '# Error freeze - HSRB-003 batch selector V0.1 blank TicketID custody display defect'
$errorFreeze += ''
$errorFreeze += 'Status: ERROR_FREEZE / EVIDENCE_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$errorFreeze += ''
$errorFreeze += 'V0.1 selected nine HSRB-003 rows and preserved source presence and SHA256, but produced blank TicketID for all selected rows.'
$errorFreeze += ''
$errorFreeze += ('v0_1_blank_ticket_id_count: {0}' -f $v01BlankTicketIdCount)
$errorFreeze += 'Classification: GENERATED_HELPER_OUTPUT_DEFECT__BATCH_SELECTOR_DID_NOT_PRESERVE_TICKET_ID_CUSTODY'
$errorFreeze += ''
$errorFreeze += 'This is not a physical-action defect. It does not authorize execution, routing, cleanup, commit, or push. It is a custody-display defect and must be repaired before HSRB-003 static review packet generation.'
Write-LinesNoBom -Path $V01ErrorFreezePath -Lines $errorFreeze

$fixNote = @()
$fixNote += '# Fix note - HSRB-003 batch selector V0.2 TicketID custody repair'
$fixNote += ''
$fixNote += 'Status: FIX_NOTE / EVIDENCE_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$fixNote += ''
$fixNote += 'V0.2 rebuilds the selected HSRB-003 batch with TicketID, filename, source path, source existence, SHA256, and review-only disposition validated together.'
$fixNote += ''
$fixNote += ('v0_1_blank_ticket_id_count: {0}' -f $v01BlankTicketIdCount)
$fixNote += ('repaired_blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$fixNote += ('fallback_ticket_id_count: {0}' -f $fallbackTicketIdCount)
$fixNote += ('missing_sha256_count: {0}' -f $missingSha256Count)
$fixNote += ('blocker_count: {0}' -f $blockerCount)
Write-LinesNoBom -Path $FixNotePath -Lines $fixNote

$helperEvidence = @()
$helperEvidence += '# Helper generation evidence - batch selectors must validate TicketID and SHA together'
$helperEvidence += ''
$helperEvidence += 'Status: HELPER_GENERATION_EVIDENCE / RULE_CANDIDATE / USER_REVIEW_REQUIRED / NO_EXECUTION'
$helperEvidence += ''
$helperEvidence += 'Observed defect: HSRB-003 selector V0.1 selected the right number of rows and preserved SHA256, but produced blank TicketID values. Future batch-selector helpers must fail closed when TicketID, source presence, selected row count, and SHA256 are not validated together.'
$helperEvidence += ''
$helperEvidence += 'Minimum derived-batch selector checks:'
$helperEvidence += '- selected row count must match the planned batch count.'
$helperEvidence += '- blank TicketID count must be zero.'
$helperEvidence += '- missing SHA256 count must be zero.'
$helperEvidence += '- source missing count must be zero.'
$helperEvidence += '- blocker_count must be zero before the next static review packet is built.'
Write-LinesNoBom -Path $HelperEvidencePath -Lines $helperEvidence

$md = @()
$md += '# HSRB-003 Helper Script Review Next Batch Selector - No Execution - V0.2'
$md += ''
$md += 'Status: SELECTOR_ONLY / TICKET_ID_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += ''
$md += 'Repair the HSRB-003 next-batch selector so the selected root drop intake washer build option-set chain preserves TicketID custody, source presence, and SHA256 together before static review packet generation.'
$md += ''
$md += '## Boundary'
$md += ''
$md += 'This selector does not execute helper scripts. It does not approve routing, cleanup, rename, deletion, commit, push, doctrine promotion, or source authority.'
$md += ''
$md += '## Verified inputs'
$md += ''
$md += '| Input | Exists | HashMatch | SHA256 |'
$md += '| --- | ---: | ---: | --- |'
$md += ('| 64_row_helper_script_review_queue | {0} | {1} | `{2}` |' -f (Test-Path -LiteralPath $QueueCsvPath -PathType Leaf), $InputQueueVerified, $QueueSha)
$md += ('| hsrb_001_proof_index_closeout | {0} | {1} | `{2}` |' -f (Test-Path -LiteralPath $HsrB001ProofCloseoutPath -PathType Leaf), $HsrB001ProofCloseoutVerified, $HsrB001Sha)
$md += ('| hsrb_002_v0_5_index_closeout | {0} | {1} | `{2}` |' -f (Test-Path -LiteralPath $HsrB002IndexCloseoutPath -PathType Leaf), $HsrB002IndexCloseoutVerified, $HsrB002Sha)
$md += ('| hsrb_002_helper_generation_evidence | {0} | {1} | `{2}` |' -f (Test-Path -LiteralPath $HsrB002EvidencePath -PathType Leaf), $HsrB002EvidenceVerified, $HsrB002EvidenceSha)
$md += ('| hsrb_003_v0_1_selected_batch | {0} | {1} | `{2}` |' -f (Test-Path -LiteralPath $V01SelectedBatchCsv -PathType Leaf), $V01SelectedBatchVerified, $V01SelectedBatchSha)
$md += ('| hsrb_003_v0_1_selector_report | {0} | {1} | `{2}` |' -f (Test-Path -LiteralPath $V01ReportMd -PathType Leaf), $V01ReportVerified, $V01ReportSha)
$md += ''
$md += '## Counts'
$md += ''
$md += ('- queue_review_rows: {0}' -f $queueReviewRows)
$md += ('- selected_batch_id: {0}' -f $BatchId)
$md += ('- selected_batch_rows: {0}' -f $selectedBatchRows)
$md += ('- present_in_queue_count: {0}' -f $presentInQueueCount)
$md += ('- source_present_count: {0}' -f $sourcePresentCount)
$md += ('- source_missing_count: {0}' -f $sourceMissingCount)
$md += ('- v0_1_blank_ticket_id_count: {0}' -f $v01BlankTicketIdCount)
$md += ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$md += ('- fallback_ticket_id_count: {0}' -f $fallbackTicketIdCount)
$md += ('- missing_sha256_count: {0}' -f $missingSha256Count)
$md += ('- review_only_count: {0}' -f $reviewOnlyCount)
$md += ('- blocker_count: {0}' -f $blockerCount)
$md += ''
$md += '## Selected batch table'
$md += ''
$md += '| BatchID | TicketID | TicketIDSource | FileName | ReviewRole | ProposedStaticDisposition | SourceExists | SHA256 |'
$md += '| --- | --- | --- | --- | --- | --- | ---: | --- |'
foreach ($row in $selectedRows) {
    $md += ('| {0} | {1} | {2} | `{3}` | {4} | {5} | {6} | `{7}` |' -f $row.BatchID, $row.TicketID, $row.TicketIDSource, $row.FileName, $row.ReviewRole, $row.ProposedStaticDisposition, $row.SourceExists, $row.SHA256)
}
$md += ''
$md += '## Interpretation'
$md += ''
$md += '- These rows are selected for static review only.'
$md += '- TicketID, filename, source existence, and SHA256 are preserved together.'
$md += '- No selected helper script is approved for execution.'
$md += '- V0.1 blank TicketID output is frozen as helper-output evidence.'
$md += ''
$md += '## Blockers'
$md += ''
if ($blockerCount -eq 0) {
    $md += 'None.'
} else {
    if (-not $InputQueueVerified) { $md += '- Input queue hash mismatch.' }
    if (-not $HsrB001ProofCloseoutVerified) { $md += '- HSRB-001 proof closeout hash mismatch or missing.' }
    if (-not $HsrB002IndexCloseoutVerified) { $md += '- HSRB-002 V0.5 closeout hash mismatch or missing.' }
    if (-not $HsrB002EvidenceVerified) { $md += '- HSRB-002 helper-generation evidence hash mismatch or missing.' }
    if (-not $V01SelectedBatchVerified) { $md += '- HSRB-003 V0.1 selected batch hash mismatch or missing.' }
    if (-not $V01ReportVerified) { $md += '- HSRB-003 V0.1 selector report hash mismatch or missing.' }
    if ($selectedBatchRows -ne 9) { $md += ('- Selected batch row count expected 9 but got {0}.' -f $selectedBatchRows) }
    if ($presentInQueueCount -ne 9) { $md += ('- Present-in-queue count expected 9 but got {0}.' -f $presentInQueueCount) }
    if ($sourceMissingCount -ne 0) { $md += ('- Source missing count is {0}.' -f $sourceMissingCount) }
    if ($blankTicketIdCount -ne 0) { $md += ('- Blank TicketID count is {0}.' -f $blankTicketIdCount) }
    if ($missingSha256Count -ne 0) { $md += ('- Missing SHA256 count is {0}.' -f $missingSha256Count) }
    if ($reviewOnlyCount -ne 9) { $md += ('- Review-only count expected 9 but got {0}.' -f $reviewOnlyCount) }
}
$md += ''
$md += '## Next single action'
$md += ''
$md += $nextSingleAction
$md += ''
$md += ('Final verdict: {0}' -f $finalVerdict)

Write-LinesNoBom -Path $OutMd -Lines $md
Write-LinesNoBom -Path $OutPrint -Lines $md

$SelectedCsvSha = Get-Sha256Safe -Path $OutSelectedCsv
$MdSha = Get-Sha256Safe -Path $OutMd
$PrintSha = Get-Sha256Safe -Path $OutPrint
$V01ErrorFreezeSha = Get-Sha256Safe -Path $V01ErrorFreezePath
$FixNoteSha = Get-Sha256Safe -Path $FixNotePath
$HelperEvidenceSha = Get-Sha256Safe -Path $HelperEvidencePath

$fixReceipt = @()
$fixReceipt += 'HSRB-003 batch selector V0.2 TicketID custody repair receipt - no execution'
$fixReceipt += ('v0_1_error_freeze_path: {0}' -f $V01ErrorFreezePath)
$fixReceipt += ('v0_1_error_freeze_sha256: {0}' -f $V01ErrorFreezeSha)
$fixReceipt += ('fix_note_path: {0}' -f $FixNotePath)
$fixReceipt += ('fix_note_sha256: {0}' -f $FixNoteSha)
$fixReceipt += ('helper_generation_evidence_path: {0}' -f $HelperEvidencePath)
$fixReceipt += ('helper_generation_evidence_sha256: {0}' -f $HelperEvidenceSha)
$fixReceipt += ('output_selected_batch_csv_path: {0}' -f $OutSelectedCsv)
$fixReceipt += ('output_selected_batch_csv_sha256: {0}' -f $SelectedCsvSha)
$fixReceipt += ('output_md_path: {0}' -f $OutMd)
$fixReceipt += ('output_md_sha256: {0}' -f $MdSha)
$fixReceipt += ('output_print_path: {0}' -f $OutPrint)
$fixReceipt += ('output_print_sha256: {0}' -f $PrintSha)
$fixReceipt += ('input_queue_verified: {0}' -f $InputQueueVerified)
$fixReceipt += ('hsrb_001_proof_closeout_verified: {0}' -f $HsrB001ProofCloseoutVerified)
$fixReceipt += ('hsrb_002_v0_5_index_closeout_verified: {0}' -f $HsrB002IndexCloseoutVerified)
$fixReceipt += ('hsrb_002_helper_generation_evidence_verified: {0}' -f $HsrB002EvidenceVerified)
$fixReceipt += ('hsrb_003_v0_1_selected_batch_verified: {0}' -f $V01SelectedBatchVerified)
$fixReceipt += ('hsrb_003_v0_1_report_verified: {0}' -f $V01ReportVerified)
$fixReceipt += ('queue_review_rows: {0}' -f $queueReviewRows)
$fixReceipt += ('selected_batch_id: {0}' -f $BatchId)
$fixReceipt += ('selected_batch_rows: {0}' -f $selectedBatchRows)
$fixReceipt += ('present_in_queue_count: {0}' -f $presentInQueueCount)
$fixReceipt += ('source_present_count: {0}' -f $sourcePresentCount)
$fixReceipt += ('source_missing_count: {0}' -f $sourceMissingCount)
$fixReceipt += ('v0_1_blank_ticket_id_count: {0}' -f $v01BlankTicketIdCount)
$fixReceipt += ('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$fixReceipt += ('fallback_ticket_id_count: {0}' -f $fallbackTicketIdCount)
$fixReceipt += ('missing_sha256_count: {0}' -f $missingSha256Count)
$fixReceipt += ('review_only_count: {0}' -f $reviewOnlyCount)
$fixReceipt += ('blocker_count: {0}' -f $blockerCount)
$fixReceipt += ('next_single_action: {0}' -f $nextSingleAction)
$fixReceipt += ('final_verdict: {0}' -f $finalVerdict)
$fixReceipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-LinesNoBom -Path $FixReceiptPath -Lines $fixReceipt
$FixReceiptSha = Get-Sha256Safe -Path $FixReceiptPath

$receipt = @()
$receipt += 'HSRB-003 helper script review next batch selector receipt - no execution - V0.2'
$receipt += ('v0_1_error_freeze_path: {0}' -f $V01ErrorFreezePath)
$receipt += ('v0_1_error_freeze_sha256: {0}' -f $V01ErrorFreezeSha)
$receipt += ('fix_note_path: {0}' -f $FixNotePath)
$receipt += ('fix_note_sha256: {0}' -f $FixNoteSha)
$receipt += ('fix_receipt_path: {0}' -f $FixReceiptPath)
$receipt += ('fix_receipt_sha256: {0}' -f $FixReceiptSha)
$receipt += ('helper_generation_evidence_path: {0}' -f $HelperEvidencePath)
$receipt += ('helper_generation_evidence_sha256: {0}' -f $HelperEvidenceSha)
$receipt += ('output_selected_batch_csv_path: {0}' -f $OutSelectedCsv)
$receipt += ('output_selected_batch_csv_sha256: {0}' -f $SelectedCsvSha)
$receipt += ('output_md_path: {0}' -f $OutMd)
$receipt += ('output_md_sha256: {0}' -f $MdSha)
$receipt += ('output_print_path: {0}' -f $OutPrint)
$receipt += ('output_print_sha256: {0}' -f $PrintSha)
$receipt += ('input_queue_verified: {0}' -f $InputQueueVerified)
$receipt += ('hsrb_001_proof_closeout_verified: {0}' -f $HsrB001ProofCloseoutVerified)
$receipt += ('hsrb_002_v0_5_index_closeout_verified: {0}' -f $HsrB002IndexCloseoutVerified)
$receipt += ('hsrb_002_helper_generation_evidence_verified: {0}' -f $HsrB002EvidenceVerified)
$receipt += ('hsrb_003_v0_1_selected_batch_verified: {0}' -f $V01SelectedBatchVerified)
$receipt += ('hsrb_003_v0_1_report_verified: {0}' -f $V01ReportVerified)
$receipt += ('queue_review_rows: {0}' -f $queueReviewRows)
$receipt += ('selected_batch_id: {0}' -f $BatchId)
$receipt += ('selected_batch_rows: {0}' -f $selectedBatchRows)
$receipt += ('present_in_queue_count: {0}' -f $presentInQueueCount)
$receipt += ('source_present_count: {0}' -f $sourcePresentCount)
$receipt += ('source_missing_count: {0}' -f $sourceMissingCount)
$receipt += ('v0_1_blank_ticket_id_count: {0}' -f $v01BlankTicketIdCount)
$receipt += ('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$receipt += ('fallback_ticket_id_count: {0}' -f $fallbackTicketIdCount)
$receipt += ('missing_sha256_count: {0}' -f $missingSha256Count)
$receipt += ('review_only_count: {0}' -f $reviewOnlyCount)
$receipt += ('blocker_count: {0}' -f $blockerCount)
$receipt += ('next_single_action: {0}' -f $nextSingleAction)
$receipt += ('final_verdict: {0}' -f $finalVerdict)
$receipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-LinesNoBom -Path $OutReceipt -Lines $receipt
$ReceiptSha = Get-Sha256Safe -Path $OutReceipt

'=== HELPER SCRIPT REVIEW NEXT BATCH SELECTOR HSRB-003 FROM 64 QUEUE V0.2 COMPLETE ==='
"v0_1_error_freeze_path: $V01ErrorFreezePath"
"v0_1_error_freeze_sha256: $V01ErrorFreezeSha"
"fix_note_path: $FixNotePath"
"fix_note_sha256: $FixNoteSha"
"fix_receipt_path: $FixReceiptPath"
"fix_receipt_sha256: $FixReceiptSha"
"helper_generation_evidence_path: $HelperEvidencePath"
"helper_generation_evidence_sha256: $HelperEvidenceSha"
"output_selected_batch_csv_path: $OutSelectedCsv"
"output_selected_batch_csv_sha256: $SelectedCsvSha"
"output_md_path: $OutMd"
"output_md_sha256: $MdSha"
"output_print_path: $OutPrint"
"output_print_sha256: $PrintSha"
"output_receipt_path: $OutReceipt"
"output_receipt_sha256: $ReceiptSha"
"input_queue_verified: $InputQueueVerified"
"hsrb_001_proof_closeout_verified: $HsrB001ProofCloseoutVerified"
"hsrb_002_v0_5_index_closeout_verified: $HsrB002IndexCloseoutVerified"
"hsrb_002_helper_generation_evidence_verified: $HsrB002EvidenceVerified"
"hsrb_003_v0_1_selected_batch_verified: $V01SelectedBatchVerified"
"hsrb_003_v0_1_report_verified: $V01ReportVerified"
"queue_review_rows: $queueReviewRows"
"selected_batch_id: $BatchId"
"selected_batch_rows: $selectedBatchRows"
"present_in_queue_count: $presentInQueueCount"
"source_present_count: $sourcePresentCount"
"source_missing_count: $sourceMissingCount"
"v0_1_blank_ticket_id_count: $v01BlankTicketIdCount"
"blank_ticket_id_count: $blankTicketIdCount"
"fallback_ticket_id_count: $fallbackTicketIdCount"
"missing_sha256_count: $missingSha256Count"
"review_only_count: $reviewOnlyCount"
"blocker_count: $blockerCount"
"next_single_action: $nextSingleAction"
"final_verdict: $finalVerdict"
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
