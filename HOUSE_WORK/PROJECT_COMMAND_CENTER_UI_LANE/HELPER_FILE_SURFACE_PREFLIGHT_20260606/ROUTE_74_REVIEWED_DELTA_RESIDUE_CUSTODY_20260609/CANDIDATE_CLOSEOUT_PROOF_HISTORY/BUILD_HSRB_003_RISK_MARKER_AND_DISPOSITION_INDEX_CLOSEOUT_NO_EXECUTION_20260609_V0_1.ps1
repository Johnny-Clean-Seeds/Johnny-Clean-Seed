# BUILD_HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1
# Purpose: close out the HSRB-003 risk-marker and disposition index after V0.2 repair. No helper execution. No route/cleanup/commit/push.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$Expected = [ordered]@{
    RiskIndexCsvPath = Join-Path $Lane 'HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_V0_2_20260609.csv'
    RiskIndexCsvSha256 = 'A1C84777AC0EF18C9D0F5E375C173BD8D3055B3F1C126B4EADF9A71F77DF8E5A'
    RiskIndexMdPath = Join-Path $Lane 'HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_V0_2_20260609.md'
    RiskIndexMdSha256 = '40FCD6E49AB37C4F648E2FBBEBD3C08572CBE0D72593426B98BCD8F5CB08A8B8'
    RiskIndexPrintPath = Join-Path $Lane 'HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
    RiskIndexPrintSha256 = '40FCD6E49AB37C4F648E2FBBEBD3C08572CBE0D72593426B98BCD8F5CB08A8B8'
    RiskIndexReceiptPath = Join-Path $Lane 'HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
    RiskIndexReceiptSha256 = '4A9E456BAF65D6234F17A0BBEDB13609572ED5AD93B1249C324779176A6F1C81'
    ContractCloseoutPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_2_20260609.md'
    ContractCloseoutSha256 = '4668440DFF2243D568F97977A1BF4D37EAA3974CCF8E07A153CE60C72F151ECA'
    ContractCloseoutReceiptPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
    ContractCloseoutReceiptSha256 = '45A575022A8D503F598DF789E6A2A9670D3A420E38EC8C24A03BF4930E104EF0'
    RiskIndexV01ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_V0_1_RISK_CLASS_MISMATCH_AND_BLANK_CSV_SHA_20260609.md'
    RiskIndexV01ErrorFreezeSha256 = '6BAEDF5C4DB4CD16E008802FDF3C5178E4DA316179CD49EB92D874A9CA448F55'
    RiskIndexFixNotePath = Join-Path $Lane 'FIX_NOTE__HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_V0_2_RISK_CLASS_AND_CSV_SHA_REPAIR_20260609.md'
    RiskIndexFixNoteSha256 = '7B8809E955208489028AAF7214C197CCB307F2BB8F47A332AD612C5226E1D875'
    RiskIndexFixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_V0_2_REPAIR_20260609.txt'
    RiskIndexFixReceiptSha256 = '8E97F52CE942E75229479CC346E67E3598E6BE51003F2474F938E941F31CC2DB'
}

$OutCloseoutPath = Join-Path $Lane 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_V0_1_20260609.md'
$OutCloseoutPrintPath = Join-Path $Lane 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutReceiptPath = Join-Path $Lane 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

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

function Test-ExpectedFile {
    param([string]$Name, [string]$Path, [string]$ExpectedSha256)
    $exists = Test-Path -LiteralPath $Path -PathType Leaf
    $actual = ''
    $match = $false
    if ($exists) {
        $actual = Get-Sha256Safe -Path $Path
        $match = ($actual -eq $ExpectedSha256.ToUpperInvariant())
    }
    return [pscustomobject]@{
        Name = [string]$Name
        Path = [string]$Path
        Exists = [bool]$exists
        ExpectedSha256 = [string]$ExpectedSha256.ToUpperInvariant()
        ActualSha256 = [string]$actual
        HashMatch = [bool]$match
    }
}

function Count-Items { param([AllowNull()]$Value) return [int](@($Value).Count) }

function Count-Where {
    param([AllowNull()]$Rows, [scriptblock]$Predicate)
    if ($null -eq $Predicate) { throw 'Predicate was null.' }
    return [int](@($Rows | Where-Object $Predicate).Count)
}

function Bool-FromCsv {
    param([AllowNull()]$Value)
    $s = ([string]$Value).Trim()
    if ($s -match '^(?i:true|1|yes)$') { return $true }
    return $false
}

function Write-LinesNoBom {
    param([Parameter(Mandatory=$true)][string]$Path, [AllowNull()][object[]]$Lines)
    if ($null -eq $Lines) { $Lines = @() }
    $stringLines = foreach ($line in @($Lines)) { if ($null -eq $line) { '' } else { [string]$line } }
    $text = [string]::Join([Environment]::NewLine, @($stringLines))
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
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

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }

$hashChecks = @()
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_csv_v0_2' -Path $Expected.RiskIndexCsvPath -ExpectedSha256 $Expected.RiskIndexCsvSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_md_v0_2' -Path $Expected.RiskIndexMdPath -ExpectedSha256 $Expected.RiskIndexMdSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_print_v0_2' -Path $Expected.RiskIndexPrintPath -ExpectedSha256 $Expected.RiskIndexPrintSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_receipt_v0_2' -Path $Expected.RiskIndexReceiptPath -ExpectedSha256 $Expected.RiskIndexReceiptSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_contract_closeout_v0_2' -Path $Expected.ContractCloseoutPath -ExpectedSha256 $Expected.ContractCloseoutSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_contract_closeout_receipt_v0_2' -Path $Expected.ContractCloseoutReceiptPath -ExpectedSha256 $Expected.ContractCloseoutReceiptSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_v0_1_error_freeze' -Path $Expected.RiskIndexV01ErrorFreezePath -ExpectedSha256 $Expected.RiskIndexV01ErrorFreezeSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_v0_2_fix_note' -Path $Expected.RiskIndexFixNotePath -ExpectedSha256 $Expected.RiskIndexFixNoteSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_risk_index_v0_2_fix_receipt' -Path $Expected.RiskIndexFixReceiptPath -ExpectedSha256 $Expected.RiskIndexFixReceiptSha256

$blockers = @()
foreach ($h in $hashChecks) {
    if (-not $h.Exists) { $blockers += ('MISSING_INPUT_{0}: {1}' -f $h.Name, $h.Path) }
    elseif (-not $h.HashMatch) { $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256) }
}

$indexRows = @()
if ($blockers.Count -eq 0) { $indexRows = @(Import-Csv -LiteralPath $Expected.RiskIndexCsvPath) }
$indexRowCount = Count-Items $indexRows
if ($blockers.Count -eq 0 -and $indexRowCount -ne 9) { $blockers += ('INDEX_ROW_COUNT_NOT_9_ACTUAL_{0}' -f $indexRowCount) }

$requiredColumns = @('BatchID','TicketID','FileName','StaticDisposition','DispositionBucket','RiskDisposition','ReviewDecision','DeclaredSha256','ActualSha256','HashMatch','SourceExists','TextReadOk','ContainsCopyItem','ContainsGitCommand','ContainsMoveItem','ContainsRemoveItem','ContainsRenameItem','ContainsStartProcess','ContainsInvokeExpression','ExecutionCleared','RouteCleared','CleanupCleared','DoctrinePromotionCleared','ActionNow','SourcePath')
if ($blockers.Count -eq 0) {
    $props = @($indexRows[0].PSObject.Properties.Name)
    foreach ($col in $requiredColumns) { if ($props -notcontains $col) { $blockers += ('REQUIRED_INDEX_COLUMN_MISSING_{0}' -f $col) } }
}

$blankTicketIdCount = 0
$missingFilenameCount = 0
$missingDeclaredSha256Count = 0
$missingActualSha256Count = 0
$sourceHashMismatchCount = 0
$sourceMissingCount = 0
$textReadFailCount = 0
$unknownStaticDispositionCount = 0
$unknownDispositionBucketCount = 0
$containsCopyItemCount = 0
$containsGitCommandCount = 0
$containsMoveItemCount = 0
$containsRemoveItemCount = 0
$containsRenameItemCount = 0
$containsStartProcessCount = 0
$containsInvokeExpressionCount = 0
$highRiskCommandMarkerRowCount = 0
$riskMarkedRowCount = 0
$unclassifiedRiskMarkerCount = 0
$executionClearanceCount = 0
$routeClearanceCount = 0
$cleanupClearanceCount = 0
$doctrinePromotionCount = 0
$actionNowNonNoCount = 0

$helperCandidateOptionSetCount = 0
$oldLoadOrSystemOptionSetCount = 0
$queueCloseoutAndNextActionCardCount = 0
$reviewQueueFamilyCount = 0
$sourceAuthorityCandidateOptionSetCount = 0
$supportCandidateOptionSetCount = 0
$supportCardSchemaAndDryRunCount = 0

if ($blockers.Count -eq 0) {
    $knownStatic = @('HELPER_CANDIDATE_OPTION_SET_REVIEW_ONLY','OLD_LOAD_OR_SYSTEM_OPTION_SET_REVIEW_ONLY','QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_REVIEW_ONLY','REVIEW_QUEUE_FAMILY_REVIEW_ONLY','SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_REVIEW_ONLY','SUPPORT_CANDIDATE_OPTION_SET_REVIEW_ONLY','SUPPORT_CARD_SCHEMA_AND_DRY_RUN_REVIEW_ONLY')
    $knownBuckets = @('CANDIDATE_METHOD_REVIEW_REQUIRED_EVIDENCE_ONLY','OLD_LOAD_OR_SYSTEM_OPTION_REVIEW_ONLY_EVIDENCE_ONLY','CONTROL_CARD_OR_CLOSEOUT_PROOF_REVIEW_ONLY','REVIEW_QUEUE_FAMILY_SUPPORT_OR_PROOF_REVIEW_ONLY','SOURCE_AUTHORITY_CANDIDATE_REVIEW_REQUIRED_EVIDENCE_ONLY','SUPPORT_CANDIDATE_REVIEW_REQUIRED_EVIDENCE_ONLY','SUPPORT_SCHEMA_AND_DRY_RUN_REVIEW_ONLY_EVIDENCE_ONLY')
    $acceptedRisk = @('RISK_MARKED_COPY_AND_GIT_REVIEW_ONLY_NOT_CLEARED','RISK_MARKED_COPY_REVIEW_ONLY_NOT_CLEARED','RISK_MARKED_GIT_REVIEW_ONLY_NOT_CLEARED','NO_COMMAND_RISK_MARKER_REVIEW_ONLY_NOT_CLEARED')

    $blankTicketIdCount = Count-Where -Rows $indexRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.TicketID) }
    $missingFilenameCount = Count-Where -Rows $indexRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.FileName) }
    $missingDeclaredSha256Count = Count-Where -Rows $indexRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.DeclaredSha256) }
    $missingActualSha256Count = Count-Where -Rows $indexRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.ActualSha256) }
    $sourceHashMismatchCount = Count-Where -Rows $indexRows -Predicate { -not (Bool-FromCsv $_.HashMatch) }
    $sourceMissingCount = Count-Where -Rows $indexRows -Predicate { -not (Bool-FromCsv $_.SourceExists) }
    $textReadFailCount = Count-Where -Rows $indexRows -Predicate { -not (Bool-FromCsv $_.TextReadOk) }
    $unknownStaticDispositionCount = Count-Where -Rows $indexRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.StaticDisposition) -or ($knownStatic -notcontains $_.StaticDisposition) }
    $unknownDispositionBucketCount = Count-Where -Rows $indexRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.DispositionBucket) -or ($knownBuckets -notcontains $_.DispositionBucket) }
    $containsCopyItemCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.ContainsCopyItem }
    $containsGitCommandCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.ContainsGitCommand }
    $containsMoveItemCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.ContainsMoveItem }
    $containsRemoveItemCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.ContainsRemoveItem }
    $containsRenameItemCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.ContainsRenameItem }
    $containsStartProcessCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.ContainsStartProcess }
    $containsInvokeExpressionCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.ContainsInvokeExpression }
    $highRiskCommandMarkerRowCount = Count-Where -Rows $indexRows -Predicate { (Bool-FromCsv $_.ContainsMoveItem) -or (Bool-FromCsv $_.ContainsRemoveItem) -or (Bool-FromCsv $_.ContainsRenameItem) -or (Bool-FromCsv $_.ContainsStartProcess) -or (Bool-FromCsv $_.ContainsInvokeExpression) }
    $riskMarkedRowCount = Count-Where -Rows $indexRows -Predicate { (Bool-FromCsv $_.ContainsCopyItem) -or (Bool-FromCsv $_.ContainsGitCommand) }
    $unclassifiedRiskMarkerCount = Count-Where -Rows $indexRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.RiskDisposition) -or ($acceptedRisk -notcontains $_.RiskDisposition) }
    $executionClearanceCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.ExecutionCleared }
    $routeClearanceCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.RouteCleared }
    $cleanupClearanceCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.CleanupCleared }
    $doctrinePromotionCount = Count-Where -Rows $indexRows -Predicate { Bool-FromCsv $_.DoctrinePromotionCleared }
    $actionNowNonNoCount = Count-Where -Rows $indexRows -Predicate { ([string]$_.ActionNow).Trim().ToUpperInvariant() -ne 'NO' }

    $helperCandidateOptionSetCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'HELPER_CANDIDATE_OPTION_SET_REVIEW_ONLY' }
    $oldLoadOrSystemOptionSetCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'OLD_LOAD_OR_SYSTEM_OPTION_SET_REVIEW_ONLY' }
    $queueCloseoutAndNextActionCardCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_REVIEW_ONLY' }
    $reviewQueueFamilyCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'REVIEW_QUEUE_FAMILY_REVIEW_ONLY' }
    $sourceAuthorityCandidateOptionSetCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_REVIEW_ONLY' }
    $supportCandidateOptionSetCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'SUPPORT_CANDIDATE_OPTION_SET_REVIEW_ONLY' }
    $supportCardSchemaAndDryRunCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'SUPPORT_CARD_SCHEMA_AND_DRY_RUN_REVIEW_ONLY' }
}

if ($blockers.Count -eq 0 -and $blankTicketIdCount -ne 0) { $blockers += ('BLANK_TICKET_ID_COUNT_NOT_0_ACTUAL_{0}' -f $blankTicketIdCount) }
if ($blockers.Count -eq 0 -and $missingFilenameCount -ne 0) { $blockers += ('MISSING_FILENAME_COUNT_NOT_0_ACTUAL_{0}' -f $missingFilenameCount) }
if ($blockers.Count -eq 0 -and $missingDeclaredSha256Count -ne 0) { $blockers += ('MISSING_DECLARED_SHA256_COUNT_NOT_0_ACTUAL_{0}' -f $missingDeclaredSha256Count) }
if ($blockers.Count -eq 0 -and $missingActualSha256Count -ne 0) { $blockers += ('MISSING_ACTUAL_SHA256_COUNT_NOT_0_ACTUAL_{0}' -f $missingActualSha256Count) }
if ($blockers.Count -eq 0 -and $sourceHashMismatchCount -ne 0) { $blockers += ('SOURCE_HASH_MISMATCH_COUNT_NOT_0_ACTUAL_{0}' -f $sourceHashMismatchCount) }
if ($blockers.Count -eq 0 -and $sourceMissingCount -ne 0) { $blockers += ('SOURCE_MISSING_COUNT_NOT_0_ACTUAL_{0}' -f $sourceMissingCount) }
if ($blockers.Count -eq 0 -and $textReadFailCount -ne 0) { $blockers += ('TEXT_READ_FAIL_COUNT_NOT_0_ACTUAL_{0}' -f $textReadFailCount) }
if ($blockers.Count -eq 0 -and $unknownStaticDispositionCount -ne 0) { $blockers += ('UNKNOWN_STATIC_DISPOSITION_COUNT_NOT_0_ACTUAL_{0}' -f $unknownStaticDispositionCount) }
if ($blockers.Count -eq 0 -and $unknownDispositionBucketCount -ne 0) { $blockers += ('UNKNOWN_DISPOSITION_BUCKET_COUNT_NOT_0_ACTUAL_{0}' -f $unknownDispositionBucketCount) }
if ($blockers.Count -eq 0 -and $highRiskCommandMarkerRowCount -ne 0) { $blockers += ('HIGH_RISK_COMMAND_MARKER_ROW_COUNT_NOT_0_ACTUAL_{0}' -f $highRiskCommandMarkerRowCount) }
if ($blockers.Count -eq 0 -and $unclassifiedRiskMarkerCount -ne 0) { $blockers += ('UNCLASSIFIED_RISK_MARKER_COUNT_NOT_0_ACTUAL_{0}' -f $unclassifiedRiskMarkerCount) }
if ($blockers.Count -eq 0 -and $executionClearanceCount -ne 0) { $blockers += ('EXECUTION_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $executionClearanceCount) }
if ($blockers.Count -eq 0 -and $routeClearanceCount -ne 0) { $blockers += ('ROUTE_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $routeClearanceCount) }
if ($blockers.Count -eq 0 -and $cleanupClearanceCount -ne 0) { $blockers += ('CLEANUP_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $cleanupClearanceCount) }
if ($blockers.Count -eq 0 -and $doctrinePromotionCount -ne 0) { $blockers += ('DOCTRINE_PROMOTION_COUNT_NOT_0_ACTUAL_{0}' -f $doctrinePromotionCount) }
if ($blockers.Count -eq 0 -and $actionNowNonNoCount -ne 0) { $blockers += ('ACTION_NOW_NON_NO_COUNT_NOT_0_ACTUAL_{0}' -f $actionNowNonNoCount) }

$blockerCount = [int]$blockers.Count
$contractGatePassed = ($blockerCount -eq 0)
if ($contractGatePassed) {
    $nextSingleAction = 'RETURN_TO_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_AND_SELECT_NEXT_BATCH_NO_EXECUTION'
    $finalVerdict = 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_V0_1_VERIFIED_REVIEW_ONLY_DISPOSITIONS_NO_PHYSICAL_ACTION'
} else {
    $nextSingleAction = 'STOP_AND_REVIEW_HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_BLOCKERS_NO_EXECUTION'
    $finalVerdict = 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

$lines = @()
$lines += '# HSRB-003 Risk Marker and Disposition Index Closeout - V0.1'
$lines += ''
$lines += 'Status: CLOSEOUT / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$lines += ''
$lines += '## Purpose'
$lines += ''
$lines += 'Close out the HSRB-003 risk-marker and disposition index after the V0.2 same-object repair. This verifies the index as review-only evidence and confirms that no helper execution, routing, cleanup, commit, push, or doctrine promotion was cleared.'
$lines += ''
$lines += '## Boundary'
$lines += ''
$lines += 'This closeout does not execute selected helper scripts. It does not move, delete, rename, copy, route, clean, commit, push, or promote doctrine. It verifies the evidence/index layer only.'
$lines += ''
$lines += '## Verified inputs'
$lines += ''
$lines += '| Input | Exists | HashMatch | SHA256 |'
$lines += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) { $lines += ('| {0} | {1} | {2} | `{3}` |' -f (Escape-MdCell $h.Name), $h.Exists, $h.HashMatch, $h.ActualSha256) }
$lines += ''
$lines += '## Contract gate'
$lines += ''
$lines += ('- contract_gate_passed: {0}' -f $contractGatePassed)
$lines += ('- blocker_count: {0}' -f $blockerCount)
$lines += '- final_verdict_dominated_by_blocker_count: True'
$lines += ''
$lines += '## Custody counts'
$lines += ''
$lines += '- selected_batch_id: HSRB-003'
$lines += ('- selected_batch_rows: {0}' -f $indexRowCount)
$lines += ('- index_rows: {0}' -f $indexRowCount)
$lines += ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$lines += ('- missing_filename_count: {0}' -f $missingFilenameCount)
$lines += ('- missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
$lines += ('- missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
$lines += ('- source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
$lines += ('- source_missing_count: {0}' -f $sourceMissingCount)
$lines += ('- text_read_fail_count: {0}' -f $textReadFailCount)
$lines += ('- unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
$lines += ('- unknown_disposition_bucket_count: {0}' -f $unknownDispositionBucketCount)
$lines += ''
$lines += '## Static disposition counts'
$lines += ''
$lines += ('- helper_candidate_option_set_count: {0}' -f $helperCandidateOptionSetCount)
$lines += ('- old_load_or_system_option_set_count: {0}' -f $oldLoadOrSystemOptionSetCount)
$lines += ('- queue_closeout_and_next_action_card_count: {0}' -f $queueCloseoutAndNextActionCardCount)
$lines += ('- review_queue_family_count: {0}' -f $reviewQueueFamilyCount)
$lines += ('- source_authority_candidate_option_set_count: {0}' -f $sourceAuthorityCandidateOptionSetCount)
$lines += ('- support_candidate_option_set_count: {0}' -f $supportCandidateOptionSetCount)
$lines += ('- support_card_schema_and_dry_run_count: {0}' -f $supportCardSchemaAndDryRunCount)
$lines += ''
$lines += '## Risk and clearance counts'
$lines += ''
$lines += ('- contains_copy_item_count: {0}' -f $containsCopyItemCount)
$lines += ('- contains_git_command_count: {0}' -f $containsGitCommandCount)
$lines += ('- contains_move_item_count: {0}' -f $containsMoveItemCount)
$lines += ('- contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$lines += ('- contains_rename_item_count: {0}' -f $containsRenameItemCount)
$lines += ('- contains_start_process_count: {0}' -f $containsStartProcessCount)
$lines += ('- contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$lines += ('- high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
$lines += ('- risk_marked_row_count: {0}' -f $riskMarkedRowCount)
$lines += ('- unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
$lines += ('- execution_clearance_count: {0}' -f $executionClearanceCount)
$lines += ('- route_clearance_count: {0}' -f $routeClearanceCount)
$lines += ('- cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
$lines += ('- doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
$lines += ('- action_now_non_no_count: {0}' -f $actionNowNonNoCount)
$lines += ''
$lines += '## Decision'
$lines += ''
$lines += '- HSRB-003 risk-marker and disposition index V0.2 is accepted as review-only evidence if contract_gate_passed is True.'
$lines += '- HSRB-003 selected helper files are not cleared for execution.'
$lines += '- HSRB-003 selected helper files are not route authority, cleanup authority, commit authority, push authority, or doctrine authority.'
$lines += '- Copy/Git markers remain indexed as review-only evidence and non-clearance markers.'
$lines += '- If this closeout passes, return to the 64-row helper review queue and select the next batch.'
$lines += ''
$lines += '## Blockers'
$lines += ''
$lines += ('- blocker_count: {0}' -f $blockerCount)
if ($blockerCount -eq 0) { $lines += '- none' } else { foreach ($b in $blockers) { $lines += ('- {0}' -f $b) } }
$lines += ''
$lines += '## Next single action'
$lines += ''
$lines += $nextSingleAction
$lines += ''
$lines += '## Final verdict'
$lines += ''
$lines += $finalVerdict
$lines += ''
$lines += '## Physical actions'
$lines += ''
$lines += 'move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

Write-LinesNoBom -Path $OutCloseoutPath -Lines $lines
$closeoutSha = Get-Sha256Safe -Path $OutCloseoutPath
Write-LinesNoBom -Path $OutCloseoutPrintPath -Lines $lines
$closeoutPrintSha = Get-Sha256Safe -Path $OutCloseoutPrintPath

$receiptLines = @()
$receiptLines += 'HSRB-003 RISK MARKER AND DISPOSITION INDEX CLOSEOUT RECEIPT V0.1'
$receiptLines += ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
$receiptLines += ('output_closeout_path: {0}' -f $OutCloseoutPath)
$receiptLines += ('output_closeout_sha256: {0}' -f $closeoutSha)
$receiptLines += ('output_closeout_print_path: {0}' -f $OutCloseoutPrintPath)
$receiptLines += ('output_closeout_print_sha256: {0}' -f $closeoutPrintSha)
$receiptLines += ('contract_gate_passed: {0}' -f $contractGatePassed)
$receiptLines += 'selected_batch_id: HSRB-003'
$receiptLines += ('selected_batch_rows: {0}' -f $indexRowCount)
$receiptLines += ('index_rows: {0}' -f $indexRowCount)
$receiptLines += ('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$receiptLines += ('missing_filename_count: {0}' -f $missingFilenameCount)
$receiptLines += ('missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
$receiptLines += ('missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
$receiptLines += ('source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
$receiptLines += ('source_missing_count: {0}' -f $sourceMissingCount)
$receiptLines += ('text_read_fail_count: {0}' -f $textReadFailCount)
$receiptLines += ('unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
$receiptLines += ('unknown_disposition_bucket_count: {0}' -f $unknownDispositionBucketCount)
$receiptLines += ('helper_candidate_option_set_count: {0}' -f $helperCandidateOptionSetCount)
$receiptLines += ('old_load_or_system_option_set_count: {0}' -f $oldLoadOrSystemOptionSetCount)
$receiptLines += ('queue_closeout_and_next_action_card_count: {0}' -f $queueCloseoutAndNextActionCardCount)
$receiptLines += ('review_queue_family_count: {0}' -f $reviewQueueFamilyCount)
$receiptLines += ('source_authority_candidate_option_set_count: {0}' -f $sourceAuthorityCandidateOptionSetCount)
$receiptLines += ('support_candidate_option_set_count: {0}' -f $supportCandidateOptionSetCount)
$receiptLines += ('support_card_schema_and_dry_run_count: {0}' -f $supportCardSchemaAndDryRunCount)
$receiptLines += ('contains_copy_item_count: {0}' -f $containsCopyItemCount)
$receiptLines += ('contains_git_command_count: {0}' -f $containsGitCommandCount)
$receiptLines += ('contains_move_item_count: {0}' -f $containsMoveItemCount)
$receiptLines += ('contains_remove_item_count: {0}' -f $containsRemoveItemCount)
$receiptLines += ('contains_rename_item_count: {0}' -f $containsRenameItemCount)
$receiptLines += ('contains_start_process_count: {0}' -f $containsStartProcessCount)
$receiptLines += ('contains_invoke_expression_count: {0}' -f $containsInvokeExpressionCount)
$receiptLines += ('high_risk_command_marker_row_count: {0}' -f $highRiskCommandMarkerRowCount)
$receiptLines += ('risk_marked_row_count: {0}' -f $riskMarkedRowCount)
$receiptLines += ('unclassified_risk_marker_count: {0}' -f $unclassifiedRiskMarkerCount)
$receiptLines += ('execution_clearance_count: {0}' -f $executionClearanceCount)
$receiptLines += ('route_clearance_count: {0}' -f $routeClearanceCount)
$receiptLines += ('cleanup_clearance_count: {0}' -f $cleanupClearanceCount)
$receiptLines += ('doctrine_promotion_count: {0}' -f $doctrinePromotionCount)
$receiptLines += ('action_now_non_no_count: {0}' -f $actionNowNonNoCount)
$receiptLines += ('blocker_count: {0}' -f $blockerCount)
$receiptLines += ('next_single_action: {0}' -f $nextSingleAction)
$receiptLines += ('final_verdict: {0}' -f $finalVerdict)
$receiptLines += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)

Write-LinesNoBom -Path $OutReceiptPath -Lines $receiptLines
$receiptSha = Get-Sha256Safe -Path $OutReceiptPath

Write-Output '=== HSRB-003 RISK MARKER AND DISPOSITION INDEX CLOSEOUT V0.1 COMPLETE ==='
Write-Output ("output_closeout_path: {0}" -f $OutCloseoutPath)
Write-Output ("output_closeout_sha256: {0}" -f $closeoutSha)
Write-Output ("output_closeout_print_path: {0}" -f $OutCloseoutPrintPath)
Write-Output ("output_closeout_print_sha256: {0}" -f $closeoutPrintSha)
Write-Output ("output_receipt_path: {0}" -f $OutReceiptPath)
Write-Output ("output_receipt_sha256: {0}" -f $receiptSha)
Write-Output ("contract_gate_passed: {0}" -f $contractGatePassed)
Write-Output 'selected_batch_id: HSRB-003'
Write-Output ("selected_batch_rows: {0}" -f $indexRowCount)
Write-Output ("index_rows: {0}" -f $indexRowCount)
Write-Output ("blank_ticket_id_count: {0}" -f $blankTicketIdCount)
Write-Output ("missing_filename_count: {0}" -f $missingFilenameCount)
Write-Output ("missing_declared_sha256_count: {0}" -f $missingDeclaredSha256Count)
Write-Output ("missing_actual_sha256_count: {0}" -f $missingActualSha256Count)
Write-Output ("source_hash_mismatch_count: {0}" -f $sourceHashMismatchCount)
Write-Output ("source_missing_count: {0}" -f $sourceMissingCount)
Write-Output ("text_read_fail_count: {0}" -f $textReadFailCount)
Write-Output ("unknown_static_disposition_count: {0}" -f $unknownStaticDispositionCount)
Write-Output ("unknown_disposition_bucket_count: {0}" -f $unknownDispositionBucketCount)
Write-Output ("helper_candidate_option_set_count: {0}" -f $helperCandidateOptionSetCount)
Write-Output ("old_load_or_system_option_set_count: {0}" -f $oldLoadOrSystemOptionSetCount)
Write-Output ("queue_closeout_and_next_action_card_count: {0}" -f $queueCloseoutAndNextActionCardCount)
Write-Output ("review_queue_family_count: {0}" -f $reviewQueueFamilyCount)
Write-Output ("source_authority_candidate_option_set_count: {0}" -f $sourceAuthorityCandidateOptionSetCount)
Write-Output ("support_candidate_option_set_count: {0}" -f $supportCandidateOptionSetCount)
Write-Output ("support_card_schema_and_dry_run_count: {0}" -f $supportCardSchemaAndDryRunCount)
Write-Output ("contains_copy_item_count: {0}" -f $containsCopyItemCount)
Write-Output ("contains_git_command_count: {0}" -f $containsGitCommandCount)
Write-Output ("contains_move_item_count: {0}" -f $containsMoveItemCount)
Write-Output ("contains_remove_item_count: {0}" -f $containsRemoveItemCount)
Write-Output ("contains_rename_item_count: {0}" -f $containsRenameItemCount)
Write-Output ("contains_start_process_count: {0}" -f $containsStartProcessCount)
Write-Output ("contains_invoke_expression_count: {0}" -f $containsInvokeExpressionCount)
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
