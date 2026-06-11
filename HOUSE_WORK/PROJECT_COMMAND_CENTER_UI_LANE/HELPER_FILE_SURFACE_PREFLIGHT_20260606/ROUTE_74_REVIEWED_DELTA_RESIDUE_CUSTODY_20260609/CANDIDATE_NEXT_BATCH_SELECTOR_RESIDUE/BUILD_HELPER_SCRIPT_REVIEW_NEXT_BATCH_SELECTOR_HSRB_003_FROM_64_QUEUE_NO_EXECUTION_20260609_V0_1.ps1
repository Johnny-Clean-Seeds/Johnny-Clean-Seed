Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$QueueCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_ROOT_HELD_ROUTE_DRY_RUN_V0_5_DECISIONS_V0_2_20260609.csv'
$HsrB001ProofCloseoutPath = Join-Path $Lane 'HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION_V0_2_20260609.md'
$HsrB002IndexCloseoutPath = Join-Path $Lane 'HSRB_002_TEMPLATE_RULE_AND_ATTEMPT_INDEX_CLOSEOUT_NO_EXECUTION_V0_5_20260609.md'
$HsrB002EvidencePath = Join-Path $Lane 'HELPER_GENERATION_EVIDENCE__DERIVED_INDEXES_MUST_VALIDATE_TICKET_ID_ROLE_COUNTS_AND_SHA_TOGETHER_20260609.md'

$BatchId = 'HSRB-003'
$BatchName = 'ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN'
$Stamp = '20260609'

$OutSelectedCsv = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_003_V0_1_20260609.csv'
$OutMd = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$OutPrint = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutReceipt = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

function Get-Sha256Text {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Write-Utf8NoBomLines {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [AllowEmptyCollection()][AllowNull()][string[]]$Lines
    )
    if ($null -eq $Lines) { $Lines = @() }
    $enc = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($Path, [string[]]$Lines, $enc)
}

function Get-Field {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [Parameter(Mandatory=$true)][string]$Name
    )
    if ($Row.PSObject.Properties.Name -contains $Name) {
        $value = $Row.$Name
        if ($null -eq $value) { return '' }
        return [string]$value
    }
    return ''
}

function Resolve-SourcePath {
    param([Parameter(Mandatory=$true)]$Row)
    foreach ($name in @('SourcePath','FullPath','Path','LiteralPath')) {
        $candidate = Get-Field -Row $Row -Name $name
        if (-not [string]::IsNullOrWhiteSpace($candidate)) { return $candidate }
    }
    $fileName = Get-Field -Row $Row -Name 'FileName'
    if ([string]::IsNullOrWhiteSpace($fileName)) { return '' }
    return (Join-Path $Root $fileName)
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    throw "Lane folder not found: $Lane"
}
if (-not (Test-Path -LiteralPath $QueueCsvPath -PathType Leaf)) {
    throw "Input queue CSV not found: $QueueCsvPath"
}

$QueueExpectedSha = '791B70E2A44AE19365D5AB410FB55E5D4AA40BA7F9A957B0A95C5BC8ADB59B43'
$HsrB001ExpectedSha = 'B4CE65335BEBB4771A947066CDD468B81BF9B39EB155D9D53AC3DC71C1A523EA'
$HsrB002ExpectedSha = 'F76388ACDD752D9D72B3E6E7F3B56955D4B4700A094881D5AA6E6E26E23BD776'

$QueueSha = Get-Sha256Text -Path $QueueCsvPath
$HsrB001Sha = Get-Sha256Text -Path $HsrB001ProofCloseoutPath
$HsrB002Sha = Get-Sha256Text -Path $HsrB002IndexCloseoutPath

$InputQueueVerified = ($QueueSha -eq $QueueExpectedSha)
$HsrB001ProofCloseoutVerified = ($HsrB001Sha -eq $HsrB001ExpectedSha)
$HsrB002IndexCloseoutVerified = ($HsrB002Sha -eq $HsrB002ExpectedSha)
$HsrB002EvidencePresent = (Test-Path -LiteralPath $HsrB002EvidencePath -PathType Leaf)

$queueRows = @(Import-Csv -LiteralPath $QueueCsvPath)

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

$selected = @()
foreach ($file in $targetFileNames) {
    $match = @($queueRows | Where-Object { (Get-Field -Row $_ -Name 'FileName') -eq $file })
    if ($match.Count -gt 0) {
        $row = $match[0]
        $ticketId = Get-Field -Row $row -Name 'TicketID'
        $sourcePath = Resolve-SourcePath -Row $row
        $sourceExists = (-not [string]::IsNullOrWhiteSpace($sourcePath)) -and (Test-Path -LiteralPath $sourcePath -PathType Leaf)
        $sourceSha = ''
        if ($sourceExists) { $sourceSha = Get-Sha256Text -Path $sourcePath }
        $selected += [pscustomobject]@{
            BatchID = $BatchId
            BatchName = $BatchName
            TicketID = $ticketId
            FileName = $file
            ReviewRole = 'ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_REVIEW_ONLY'
            ProposedStaticDisposition = 'STATIC_REVIEW_REQUIRED_NO_EXECUTION'
            SourcePath = $sourcePath
            SourceExists = [bool]$sourceExists
            SHA256 = $sourceSha
            OriginalRoleLabel = (Get-Field -Row $row -Name 'RoleLabel')
            OriginalRiskLabel = (Get-Field -Row $row -Name 'RiskLabel')
            UserDecision = (Get-Field -Row $row -Name 'UserDecision')
        }
    } else {
        $selected += [pscustomobject]@{
            BatchID = $BatchId
            BatchName = $BatchName
            TicketID = ''
            FileName = $file
            ReviewRole = 'ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_REVIEW_ONLY'
            ProposedStaticDisposition = 'MISSING_FROM_QUEUE_BLOCKER'
            SourcePath = ''
            SourceExists = $false
            SHA256 = ''
            OriginalRoleLabel = ''
            OriginalRiskLabel = ''
            UserDecision = ''
        }
    }
}

$selected | Export-Csv -LiteralPath $OutSelectedCsv -NoTypeInformation -Encoding UTF8

$selectedRows = @($selected)
$selectedBatchRows = [int]$selectedRows.Count
$sourcePresentCount = [int]@($selectedRows | Where-Object { $_.SourceExists -eq $true }).Count
$sourceMissingCount = [int]@($selectedRows | Where-Object { $_.SourceExists -ne $true }).Count
$blankTicketIdCount = [int]@($selectedRows | Where-Object { [string]::IsNullOrWhiteSpace([string]$_.TicketID) }).Count
$missingSha256Count = [int]@($selectedRows | Where-Object { [string]::IsNullOrWhiteSpace([string]$_.SHA256) }).Count
$reviewOnlyCount = [int]@($selectedRows | Where-Object { $_.ProposedStaticDisposition -eq 'STATIC_REVIEW_REQUIRED_NO_EXECUTION' }).Count
$queueReviewRows = [int]@($queueRows).Count

$blockerCount = 0
if (-not $InputQueueVerified) { $blockerCount++ }
if (-not $HsrB001ProofCloseoutVerified) { $blockerCount++ }
if (-not $HsrB002IndexCloseoutVerified) { $blockerCount++ }
if (-not $HsrB002EvidencePresent) { $blockerCount++ }
if ($sourceMissingCount -ne 0) { $blockerCount++ }
if ($blankTicketIdCount -ne 0) { $blockerCount++ }
if ($missingSha256Count -ne 0) { $blockerCount++ }
if ($selectedBatchRows -ne 9) { $blockerCount++ }

$nextSingleAction = if ($blockerCount -eq 0) {
    'BUILD_STATIC_REVIEW_PACKET_FOR_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_NO_EXECUTION'
} else {
    'STOP_AND_REVIEW_HSRB_003_BATCH_SELECTOR_BLOCKERS_NO_EXECUTION'
}

$finalVerdict = if ($blockerCount -eq 0) {
    'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$md = @()
$md += '# HSRB-003 Helper Script Review Next Batch Selector - No Execution - V0.1'
$md += ''
$md += 'Status: SELECTOR_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += ''
$md += 'Select the next static-review batch from the 64-row helper script review queue after HSRB-001 and HSRB-002 closeout. This batch covers the root drop intake washer build and option-set chain.'
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
$md += ('| hsrb_002_helper_generation_evidence | {0} | n/a | `{1}` |' -f $HsrB002EvidencePresent, (Get-Sha256Text -Path $HsrB002EvidencePath))
$md += ''
$md += '## Counts'
$md += ''
$md += ('- queue_review_rows: {0}' -f $queueReviewRows)
$md += ('- selected_batch_id: {0}' -f $BatchId)
$md += ('- selected_batch_rows: {0}' -f $selectedBatchRows)
$md += ('- source_present_count: {0}' -f $sourcePresentCount)
$md += ('- source_missing_count: {0}' -f $sourceMissingCount)
$md += ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$md += ('- missing_sha256_count: {0}' -f $missingSha256Count)
$md += ('- review_only_count: {0}' -f $reviewOnlyCount)
$md += ('- blocker_count: {0}' -f $blockerCount)
$md += ''
$md += '## Selected batch table'
$md += ''
$md += '| BatchID | TicketID | FileName | ReviewRole | ProposedStaticDisposition | SourceExists | SHA256 |'
$md += '| --- | --- | --- | --- | --- | ---: | --- |'
foreach ($row in $selectedRows) {
    $md += ('| {0} | {1} | `{2}` | {3} | {4} | {5} | `{6}` |' -f $row.BatchID, $row.TicketID, $row.FileName, $row.ReviewRole, $row.ProposedStaticDisposition, $row.SourceExists, $row.SHA256)
}
$md += ''
$md += '## Interpretation'
$md += ''
$md += '- These rows are selected for static review only.'
$md += '- TicketID, filename, source existence, and SHA256 are preserved together.'
$md += '- No selected helper script is approved for execution.'
$md += '- HSRB-002 evidence now requires derived indexes to validate TicketID, role/count fields, and SHA together.'
$md += ''
$md += '## Blockers'
$md += ''
if ($blockerCount -eq 0) {
    $md += 'None.'
} else {
    if (-not $InputQueueVerified) { $md += '- Input queue hash mismatch.' }
    if (-not $HsrB001ProofCloseoutVerified) { $md += '- HSRB-001 proof closeout hash mismatch or missing.' }
    if (-not $HsrB002IndexCloseoutVerified) { $md += '- HSRB-002 V0.5 closeout hash mismatch or missing.' }
    if (-not $HsrB002EvidencePresent) { $md += '- HSRB-002 helper-generation evidence missing.' }
    if ($sourceMissingCount -ne 0) { $md += ('- Source missing count is {0}.' -f $sourceMissingCount) }
    if ($blankTicketIdCount -ne 0) { $md += ('- Blank TicketID count is {0}.' -f $blankTicketIdCount) }
    if ($missingSha256Count -ne 0) { $md += ('- Missing SHA256 count is {0}.' -f $missingSha256Count) }
    if ($selectedBatchRows -ne 9) { $md += ('- Selected batch row count expected 9 but got {0}.' -f $selectedBatchRows) }
}
$md += ''
$md += '## Next single action'
$md += ''
$md += $nextSingleAction
$md += ''
$md += ('Final verdict: {0}' -f $finalVerdict)

Write-Utf8NoBomLines -Path $OutMd -Lines $md
Write-Utf8NoBomLines -Path $OutPrint -Lines $md
try { Set-Clipboard -Value ($md -join [Environment]::NewLine) } catch { }

$SelectedCsvSha = Get-Sha256Text -Path $OutSelectedCsv
$MdSha = Get-Sha256Text -Path $OutMd
$PrintSha = Get-Sha256Text -Path $OutPrint

$receipt = @()
$receipt += 'HSRB-003 helper script review next batch selector receipt - no execution - V0.1'
$receipt += ('output_selected_batch_csv_path: {0}' -f $OutSelectedCsv)
$receipt += ('output_selected_batch_csv_sha256: {0}' -f $SelectedCsvSha)
$receipt += ('output_md_path: {0}' -f $OutMd)
$receipt += ('output_md_sha256: {0}' -f $MdSha)
$receipt += ('output_print_path: {0}' -f $OutPrint)
$receipt += ('output_print_sha256: {0}' -f $PrintSha)
$receipt += ('input_queue_verified: {0}' -f $InputQueueVerified)
$receipt += ('hsrb_001_proof_closeout_verified: {0}' -f $HsrB001ProofCloseoutVerified)
$receipt += ('hsrb_002_v0_5_index_closeout_verified: {0}' -f $HsrB002IndexCloseoutVerified)
$receipt += ('hsrb_002_helper_generation_evidence_present: {0}' -f $HsrB002EvidencePresent)
$receipt += ('queue_review_rows: {0}' -f $queueReviewRows)
$receipt += ('selected_batch_id: {0}' -f $BatchId)
$receipt += ('selected_batch_rows: {0}' -f $selectedBatchRows)
$receipt += ('source_present_count: {0}' -f $sourcePresentCount)
$receipt += ('source_missing_count: {0}' -f $sourceMissingCount)
$receipt += ('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$receipt += ('missing_sha256_count: {0}' -f $missingSha256Count)
$receipt += ('review_only_count: {0}' -f $reviewOnlyCount)
$receipt += ('blocker_count: {0}' -f $blockerCount)
$receipt += ('next_single_action: {0}' -f $nextSingleAction)
$receipt += ('final_verdict: {0}' -f $finalVerdict)
$receipt += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Utf8NoBomLines -Path $OutReceipt -Lines $receipt
$ReceiptSha = Get-Sha256Text -Path $OutReceipt

'=== HELPER SCRIPT REVIEW NEXT BATCH SELECTOR HSRB-003 FROM 64 QUEUE V0.1 COMPLETE ==='
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
"hsrb_002_helper_generation_evidence_present: $HsrB002EvidencePresent"
"queue_review_rows: $queueReviewRows"
"selected_batch_id: $BatchId"
"selected_batch_rows: $selectedBatchRows"
"source_present_count: $sourcePresentCount"
"source_missing_count: $sourceMissingCount"
"blank_ticket_id_count: $blankTicketIdCount"
"missing_sha256_count: $missingSha256Count"
"review_only_count: $reviewOnlyCount"
"blocker_count: $blockerCount"
"next_single_action: $nextSingleAction"
"final_verdict: $finalVerdict"
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
