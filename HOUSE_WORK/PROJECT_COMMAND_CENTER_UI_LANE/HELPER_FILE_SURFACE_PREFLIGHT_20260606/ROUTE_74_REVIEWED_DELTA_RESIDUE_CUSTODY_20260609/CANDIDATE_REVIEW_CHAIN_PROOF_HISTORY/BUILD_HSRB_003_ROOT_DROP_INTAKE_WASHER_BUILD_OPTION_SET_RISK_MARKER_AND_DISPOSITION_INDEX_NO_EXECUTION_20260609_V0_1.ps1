# BUILD_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_20260609_V0_1.ps1
# Purpose: build the HSRB-003 risk-marker and disposition index after contract-first decision closeout. No helper execution. No route/cleanup/commit/push.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$Expected = [ordered]@{
    SelectorBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_003_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_003_V0_2_20260609.csv'
    SelectorBatchCsvSha256 = '46453987B9A3E61AD054AB9063BB3C5EBBA5749996C1935EF9DB909D61632BE5'
    SummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_SUMMARY_V0_1_20260609.csv'
    SummaryCsvSha256 = 'BDA4237D9453936BDEE9C43D270B6E82B9CC3255A34A05DD210CEAE6EB4F59BF'
    StaticPacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_V0_1_20260609.md'
    StaticPacketMdSha256 = 'CDDAD451AE35644EBA42694119F96E8AB348B14E245CFA4EA58FCD9DDDC1B4FF'
    StaticPacketReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_CHAIN_RECEIPT_V0_1_20260609.txt'
    StaticPacketReceiptSha256 = '1925821AEBE747D1797E4EE8544338104B8ABD301DC12F6540734A5DA42D6544'
    ContractRiskCsvPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_2_20260609.csv'
    ContractRiskCsvSha256 = '64567DA8BE64400D70A7B768A0FCE58C4421F952AF2DAF82CA5E7D07F63B3C5A'
    ContractCloseoutPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_2_20260609.md'
    ContractCloseoutSha256 = '4668440DFF2243D568F97977A1BF4D37EAA3974CCF8E07A153CE60C72F151ECA'
    ContractCloseoutReceiptPath = Join-Path $Lane 'HSRB_003_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
    ContractCloseoutReceiptSha256 = '45A575022A8D503F598DF789E6A2A9670D3A420E38EC8C24A03BF4930E104EF0'
    Hsrb002ContractEvidencePath = Join-Path $Lane 'HELPER_GENERATION_EVIDENCE__DERIVED_INDEXES_MUST_VALIDATE_TICKET_ID_ROLE_COUNTS_AND_SHA_TOGETHER_20260609.md'
    Hsrb002ContractEvidenceSha256 = '32D8D09C1C9043785F8A5D3FE4355533A9B7DFF868B4E8D7E5845E7DAE592FC8'
    Hsrb003SelectorContractEvidencePath = Join-Path $Lane 'HELPER_GENERATION_EVIDENCE__BATCH_SELECTORS_MUST_VALIDATE_TICKET_ID_AND_SHA_TOGETHER_20260609.md'
    Hsrb003SelectorContractEvidenceSha256 = '6BD3DBA31BC5386DC4E60BA5FA6FA4B206975469BC331CC4233DEE5872ABC798'
}

$OutIndexCsvPath = Join-Path $Lane 'HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$OutIndexMdPath = Join-Path $Lane 'HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_V0_1_20260609.md'
$OutIndexPrintPath = Join-Path $Lane 'HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutReceiptPath = Join-Path $Lane 'HSRB_003_ROOT_DROP_INTAKE_WASHER_BUILD_OPTION_SET_RISK_MARKER_AND_DISPOSITION_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

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

function Count-Items {
    param([AllowNull()]$Value)
    return [int](@($Value).Count)
}

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
    $stringLines = foreach ($line in @($Lines)) {
        if ($null -eq $line) { '' } else { [string]$line }
    }
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

function Get-DispositionBucket {
    param([AllowNull()][string]$StaticDisposition)
    switch ([string]$StaticDisposition) {
        'HELPER_CANDIDATE_OPTION_SET_REVIEW_ONLY' { return 'CANDIDATE_METHOD_REVIEW_REQUIRED_EVIDENCE_ONLY' }
        'OLD_LOAD_OR_SYSTEM_OPTION_SET_REVIEW_ONLY' { return 'OLD_LOAD_OR_SYSTEM_OPTION_REVIEW_ONLY_EVIDENCE_ONLY' }
        'QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_REVIEW_ONLY' { return 'CONTROL_CARD_OR_CLOSEOUT_PROOF_REVIEW_ONLY' }
        'REVIEW_QUEUE_FAMILY_REVIEW_ONLY' { return 'REVIEW_QUEUE_FAMILY_SUPPORT_OR_PROOF_REVIEW_ONLY' }
        'SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_REVIEW_ONLY' { return 'SOURCE_AUTHORITY_CANDIDATE_REVIEW_REQUIRED_EVIDENCE_ONLY' }
        'SUPPORT_CANDIDATE_OPTION_SET_REVIEW_ONLY' { return 'SUPPORT_CANDIDATE_REVIEW_REQUIRED_EVIDENCE_ONLY' }
        'SUPPORT_CARD_SCHEMA_AND_DRY_RUN_REVIEW_ONLY' { return 'SUPPORT_SCHEMA_AND_DRY_RUN_REVIEW_ONLY_EVIDENCE_ONLY' }
        default { return 'UNKNOWN_DISPOSITION_REVIEW_BLOCKER' }
    }
}

function Get-RiskDisposition {
    param($Row)
    $move = Bool-FromCsv $Row.ContainsMoveItem
    $remove = Bool-FromCsv $Row.ContainsRemoveItem
    $rename = Bool-FromCsv $Row.ContainsRenameItem
    $start = Bool-FromCsv $Row.ContainsStartProcess
    $invoke = Bool-FromCsv $Row.ContainsInvokeExpression
    $copy = Bool-FromCsv $Row.ContainsCopyItem
    $git = Bool-FromCsv $Row.ContainsGitCommand
    if ($move -or $remove -or $rename -or $start -or $invoke) { return 'BLOCKED_HIGH_RISK_COMMAND_MARKER_REVIEW_REQUIRED' }
    if ($copy -and $git) { return 'COPY_AND_GIT_MARKERS_REVIEW_ONLY_NOT_CLEARED' }
    if ($copy) { return 'COPY_MARKER_REVIEW_ONLY_NOT_CLEARED' }
    if ($git) { return 'GIT_MARKER_REVIEW_ONLY_NOT_CLEARED' }
    return 'NO_COMMAND_RISK_MARKER_REVIEW_ONLY_NOT_CLEARED'
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }

$hashChecks = @()
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_selector_batch_csv_v0_2' -Path $Expected.SelectorBatchCsvPath -ExpectedSha256 $Expected.SelectorBatchCsvSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_summary_csv_v0_1' -Path $Expected.SummaryCsvPath -ExpectedSha256 $Expected.SummaryCsvSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_static_packet_md_v0_1' -Path $Expected.StaticPacketMdPath -ExpectedSha256 $Expected.StaticPacketMdSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_static_packet_receipt_v0_1' -Path $Expected.StaticPacketReceiptPath -ExpectedSha256 $Expected.StaticPacketReceiptSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_contract_risk_csv_v0_2' -Path $Expected.ContractRiskCsvPath -ExpectedSha256 $Expected.ContractRiskCsvSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_contract_closeout_v0_2' -Path $Expected.ContractCloseoutPath -ExpectedSha256 $Expected.ContractCloseoutSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_contract_closeout_receipt_v0_2' -Path $Expected.ContractCloseoutReceiptPath -ExpectedSha256 $Expected.ContractCloseoutReceiptSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_002_contract_evidence' -Path $Expected.Hsrb002ContractEvidencePath -ExpectedSha256 $Expected.Hsrb002ContractEvidenceSha256
$hashChecks += Test-ExpectedFile -Name 'hsrb_003_selector_contract_evidence' -Path $Expected.Hsrb003SelectorContractEvidencePath -ExpectedSha256 $Expected.Hsrb003SelectorContractEvidenceSha256

$blockers = @()
foreach ($h in $hashChecks) {
    if (-not $h.Exists) { $blockers += ('MISSING_INPUT_{0}: {1}' -f $h.Name, $h.Path) }
    elseif (-not $h.HashMatch) { $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256) }
}

$summaryRows = @()
$riskRowsInput = @()
if ($blockers.Count -eq 0) {
    $summaryRows = @(Import-Csv -LiteralPath $Expected.SummaryCsvPath)
    $riskRowsInput = @(Import-Csv -LiteralPath $Expected.ContractRiskCsvPath)
}

$summaryRowCount = Count-Items $summaryRows
$riskInputRowCount = Count-Items $riskRowsInput

if ($blockers.Count -eq 0 -and $summaryRowCount -ne 9) { $blockers += ('SUMMARY_ROW_COUNT_NOT_9_ACTUAL_{0}' -f $summaryRowCount) }
if ($blockers.Count -eq 0 -and $riskInputRowCount -ne 9) { $blockers += ('RISK_INPUT_ROW_COUNT_NOT_9_ACTUAL_{0}' -f $riskInputRowCount) }

$requiredSummaryColumns = @('BatchID','TicketID','FileName','SourcePath','SourceExists','DeclaredSha256','SourceSha256','DeclaredShaMatchesActual','TextReadOk','StaticDisposition','ContainsMoveItem','ContainsRemoveItem','ContainsRenameItem','ContainsCopyItem','ContainsStartProcess','ContainsInvokeExpression','ContainsGitCommand','ActionNow')
$requiredRiskColumns = @('TicketID','FileName','StaticDisposition','ContainsCopyItem','ContainsGitCommand','ContainsMoveItem','ContainsRemoveItem','ContainsRenameItem','ContainsStartProcess','ContainsInvokeExpression','RiskClass','ReviewDecision','ExecutionCleared','RouteCleared','CleanupCleared','DoctrinePromotionCleared','ActionNow')

if ($blockers.Count -eq 0) {
    $summaryProps = @($summaryRows[0].PSObject.Properties.Name)
    foreach ($col in $requiredSummaryColumns) {
        if ($summaryProps -notcontains $col) { $blockers += ('REQUIRED_SUMMARY_COLUMN_MISSING_{0}' -f $col) }
    }
    $riskProps = @($riskRowsInput[0].PSObject.Properties.Name)
    foreach ($col in $requiredRiskColumns) {
        if ($riskProps -notcontains $col) { $blockers += ('REQUIRED_RISK_COLUMN_MISSING_{0}' -f $col) }
    }
}

$blankTicketIdCount = 0
$missingFilenameCount = 0
$missingDeclaredSha256Count = 0
$missingActualSha256Count = 0
$sourceHashMismatchCount = 0
$sourceMissingCount = 0
$textReadFailCount = 0
$unknownStaticDispositionCount = 0
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

$indexRows = @()

if ($blockers.Count -eq 0) {
    $blankTicketIdCount = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.TicketID) }
    $missingFilenameCount = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.FileName) }
    $missingDeclaredSha256Count = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.DeclaredSha256) }
    $missingActualSha256Count = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.SourceSha256) }
    $sourceHashMismatchCount = Count-Where -Rows $summaryRows -Predicate { -not (Bool-FromCsv $_.DeclaredShaMatchesActual) }
    $sourceMissingCount = Count-Where -Rows $summaryRows -Predicate { -not (Bool-FromCsv $_.SourceExists) }
    $textReadFailCount = Count-Where -Rows $summaryRows -Predicate { -not (Bool-FromCsv $_.TextReadOk) }
    $known = @('HELPER_CANDIDATE_OPTION_SET_REVIEW_ONLY','OLD_LOAD_OR_SYSTEM_OPTION_SET_REVIEW_ONLY','QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_REVIEW_ONLY','REVIEW_QUEUE_FAMILY_REVIEW_ONLY','SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_REVIEW_ONLY','SUPPORT_CANDIDATE_OPTION_SET_REVIEW_ONLY','SUPPORT_CARD_SCHEMA_AND_DRY_RUN_REVIEW_ONLY')
    $unknownStaticDispositionCount = Count-Where -Rows $summaryRows -Predicate { [string]::IsNullOrWhiteSpace([string]$_.StaticDisposition) -or ($known -notcontains $_.StaticDisposition) }
    $containsCopyItemCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsCopyItem }
    $containsGitCommandCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsGitCommand }
    $containsMoveItemCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsMoveItem }
    $containsRemoveItemCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsRemoveItem }
    $containsRenameItemCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsRenameItem }
    $containsStartProcessCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsStartProcess }
    $containsInvokeExpressionCount = Count-Where -Rows $summaryRows -Predicate { Bool-FromCsv $_.ContainsInvokeExpression }
    $highRiskCommandMarkerRowCount = Count-Where -Rows $summaryRows -Predicate { (Bool-FromCsv $_.ContainsMoveItem) -or (Bool-FromCsv $_.ContainsRemoveItem) -or (Bool-FromCsv $_.ContainsRenameItem) -or (Bool-FromCsv $_.ContainsStartProcess) -or (Bool-FromCsv $_.ContainsInvokeExpression) }
    $riskMarkedRowCount = Count-Where -Rows $summaryRows -Predicate { (Bool-FromCsv $_.ContainsCopyItem) -or (Bool-FromCsv $_.ContainsGitCommand) }
    $executionClearanceCount = Count-Where -Rows $riskRowsInput -Predicate { Bool-FromCsv $_.ExecutionCleared }
    $routeClearanceCount = Count-Where -Rows $riskRowsInput -Predicate { Bool-FromCsv $_.RouteCleared }
    $cleanupClearanceCount = Count-Where -Rows $riskRowsInput -Predicate { Bool-FromCsv $_.CleanupCleared }
    $doctrinePromotionCount = Count-Where -Rows $riskRowsInput -Predicate { Bool-FromCsv $_.DoctrinePromotionCleared }

    foreach ($row in $summaryRows) {
        $matchingRisk = @($riskRowsInput | Where-Object { $_.TicketID -eq $row.TicketID -and $_.FileName -eq $row.FileName })
        if ((Count-Items $matchingRisk) -ne 1) {
            $blockers += ('RISK_ROW_MATCH_COUNT_NOT_1_FOR_{0}_{1}_ACTUAL_{2}' -f $row.TicketID, $row.FileName, (Count-Items $matchingRisk))
            continue
        }
        $risk = $matchingRisk[0]
        $riskDisposition = Get-RiskDisposition -Row $row
        $dispositionBucket = Get-DispositionBucket -StaticDisposition $row.StaticDisposition
        if ($risk.RiskClass -ne $riskDisposition) {
            $blockers += ('RISK_CLASS_MISMATCH_FOR_{0}_{1}_EXPECTED_{2}_ACTUAL_{3}' -f $row.TicketID, $row.FileName, $riskDisposition, $risk.RiskClass)
        }
        if ($dispositionBucket -eq 'UNKNOWN_DISPOSITION_REVIEW_BLOCKER') { $unclassifiedRiskMarkerCount++ }
        $indexRows += [pscustomobject]@{
            BatchID = [string]$row.BatchID
            TicketID = [string]$row.TicketID
            FileName = [string]$row.FileName
            StaticDisposition = [string]$row.StaticDisposition
            DispositionBucket = [string]$dispositionBucket
            RiskDisposition = [string]$riskDisposition
            ReviewDecision = [string]$risk.ReviewDecision
            DeclaredSha256 = [string]$row.DeclaredSha256
            ActualSha256 = [string]$row.SourceSha256
            HashMatch = [string]$row.DeclaredShaMatchesActual
            SourceExists = [string]$row.SourceExists
            TextReadOk = [string]$row.TextReadOk
            ContainsCopyItem = [string]$row.ContainsCopyItem
            ContainsGitCommand = [string]$row.ContainsGitCommand
            ContainsMoveItem = [string]$row.ContainsMoveItem
            ContainsRemoveItem = [string]$row.ContainsRemoveItem
            ContainsRenameItem = [string]$row.ContainsRenameItem
            ContainsStartProcess = [string]$row.ContainsStartProcess
            ContainsInvokeExpression = [string]$row.ContainsInvokeExpression
            ExecutionCleared = 'False'
            RouteCleared = 'False'
            CleanupCleared = 'False'
            DoctrinePromotionCleared = 'False'
            ActionNow = 'NO'
            SourcePath = [string]$row.SourcePath
        }
    }
}

$helperCandidateOptionSetCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'HELPER_CANDIDATE_OPTION_SET_REVIEW_ONLY' }
$oldLoadOrSystemOptionSetCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'OLD_LOAD_OR_SYSTEM_OPTION_SET_REVIEW_ONLY' }
$queueCloseoutAndNextActionCardCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_REVIEW_ONLY' }
$reviewQueueFamilyCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'REVIEW_QUEUE_FAMILY_REVIEW_ONLY' }
$sourceAuthorityCandidateOptionSetCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_REVIEW_ONLY' }
$supportCandidateOptionSetCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'SUPPORT_CANDIDATE_OPTION_SET_REVIEW_ONLY' }
$supportCardSchemaAndDryRunCount = Count-Where -Rows $indexRows -Predicate { $_.StaticDisposition -eq 'SUPPORT_CARD_SCHEMA_AND_DRY_RUN_REVIEW_ONLY' }

if ($blockers.Count -eq 0 -and $blankTicketIdCount -ne 0) { $blockers += ('BLANK_TICKET_ID_COUNT_NOT_0_ACTUAL_{0}' -f $blankTicketIdCount) }
if ($blockers.Count -eq 0 -and $missingFilenameCount -ne 0) { $blockers += ('MISSING_FILENAME_COUNT_NOT_0_ACTUAL_{0}' -f $missingFilenameCount) }
if ($blockers.Count -eq 0 -and $missingDeclaredSha256Count -ne 0) { $blockers += ('MISSING_DECLARED_SHA256_COUNT_NOT_0_ACTUAL_{0}' -f $missingDeclaredSha256Count) }
if ($blockers.Count -eq 0 -and $missingActualSha256Count -ne 0) { $blockers += ('MISSING_ACTUAL_SHA256_COUNT_NOT_0_ACTUAL_{0}' -f $missingActualSha256Count) }
if ($blockers.Count -eq 0 -and $sourceHashMismatchCount -ne 0) { $blockers += ('SOURCE_HASH_MISMATCH_COUNT_NOT_0_ACTUAL_{0}' -f $sourceHashMismatchCount) }
if ($blockers.Count -eq 0 -and $sourceMissingCount -ne 0) { $blockers += ('SOURCE_MISSING_COUNT_NOT_0_ACTUAL_{0}' -f $sourceMissingCount) }
if ($blockers.Count -eq 0 -and $textReadFailCount -ne 0) { $blockers += ('TEXT_READ_FAIL_COUNT_NOT_0_ACTUAL_{0}' -f $textReadFailCount) }
if ($blockers.Count -eq 0 -and $unknownStaticDispositionCount -ne 0) { $blockers += ('UNKNOWN_STATIC_DISPOSITION_COUNT_NOT_0_ACTUAL_{0}' -f $unknownStaticDispositionCount) }
if ($blockers.Count -eq 0 -and $highRiskCommandMarkerRowCount -ne 0) { $blockers += ('HIGH_RISK_COMMAND_MARKER_ROW_COUNT_NOT_0_ACTUAL_{0}' -f $highRiskCommandMarkerRowCount) }
if ($blockers.Count -eq 0 -and $containsCopyItemCount -ne 1) { $blockers += ('CONTAINS_COPY_ITEM_COUNT_NOT_1_ACTUAL_{0}' -f $containsCopyItemCount) }
if ($blockers.Count -eq 0 -and $containsGitCommandCount -ne 9) { $blockers += ('CONTAINS_GIT_COMMAND_COUNT_NOT_9_ACTUAL_{0}' -f $containsGitCommandCount) }
if ($blockers.Count -eq 0 -and $riskMarkedRowCount -ne 9) { $blockers += ('RISK_MARKED_ROW_COUNT_NOT_9_ACTUAL_{0}' -f $riskMarkedRowCount) }
if ($blockers.Count -eq 0 -and $executionClearanceCount -ne 0) { $blockers += ('EXECUTION_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $executionClearanceCount) }
if ($blockers.Count -eq 0 -and $routeClearanceCount -ne 0) { $blockers += ('ROUTE_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $routeClearanceCount) }
if ($blockers.Count -eq 0 -and $cleanupClearanceCount -ne 0) { $blockers += ('CLEANUP_CLEARANCE_COUNT_NOT_0_ACTUAL_{0}' -f $cleanupClearanceCount) }
if ($blockers.Count -eq 0 -and $doctrinePromotionCount -ne 0) { $blockers += ('DOCTRINE_PROMOTION_COUNT_NOT_0_ACTUAL_{0}' -f $doctrinePromotionCount) }

$blockerCount = [int]$blockers.Count
$contractGatePassed = ($blockerCount -eq 0)
if ($contractGatePassed) {
    $nextSingleAction = 'BUILD_HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION'
    $finalVerdict = 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_V0_1_WRITTEN_WITH_REVIEW_ONLY_DISPOSITIONS_NO_PHYSICAL_ACTION'
} else {
    $nextSingleAction = 'STOP_AND_REVIEW_HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_BLOCKERS_NO_EXECUTION'
    $finalVerdict = 'HSRB_003_RISK_MARKER_AND_DISPOSITION_INDEX_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION'
}

if ($contractGatePassed) { $indexRows | Export-Csv -LiteralPath $OutIndexCsvPath -NoTypeInformation -Encoding UTF8 }
$indexCsvSha = Get-Sha256Safe -Path $OutIndexCsvPath

$lines = @()
$lines += '# HSRB-003 Root Drop Intake Washer Build Option Set - Risk Marker and Disposition Index - V0.1'
$lines += ''
$lines += 'Status: RISK_MARKER_AND_DISPOSITION_INDEX / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$lines += ''
$lines += '## Purpose'
$lines += ''
$lines += 'Index the HSRB-003 root drop intake washer build-option-set chain after contract-first closeout. This separates static risk markers from clearance and assigns review-only disposition buckets. It does not run or approve any helper file.'
$lines += ''
$lines += '## Boundary'
$lines += ''
$lines += 'This index is proof organization only. It does not execute, move, delete, rename, copy, route, clean, commit, push, or promote doctrine. Copy/Git markers remain evidence; they are not clearance.'
$lines += ''
$lines += '## Verified parent inputs'
$lines += ''
$lines += '| Input | Exists | HashMatch | SHA256 |'
$lines += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) { $lines += ('| {0} | {1} | {2} | `{3}` |' -f (Escape-MdCell $h.Name), $h.Exists, $h.HashMatch, $h.ActualSha256) }
$lines += ''
$lines += '## Contract gate'
$lines += ''
$lines += ('- contract_gate_passed: {0}' -f $contractGatePassed)
$lines += ('- blocker_count: {0}' -f $blockerCount)
$lines += ('- final_verdict_dominated_by_blocker_count: True')
$lines += ''
$lines += '## Custody counts'
$lines += ''
$lines += '- selected_batch_id: HSRB-003'
$lines += ('- selected_batch_rows: {0}' -f $summaryRowCount)
$lines += ('- index_rows: {0}' -f (Count-Items $indexRows))
$lines += ('- blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$lines += ('- missing_filename_count: {0}' -f $missingFilenameCount)
$lines += ('- missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
$lines += ('- missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
$lines += ('- source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
$lines += ('- source_missing_count: {0}' -f $sourceMissingCount)
$lines += ('- text_read_fail_count: {0}' -f $textReadFailCount)
$lines += ('- unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
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
$lines += ''
$lines += '## Index table'
$lines += ''
$lines += '| TicketID | FileName | StaticDisposition | DispositionBucket | RiskDisposition | Copy | Git | ActionNow |'
$lines += '| --- | --- | --- | --- | --- | ---: | ---: | --- |'
foreach ($r in $indexRows) {
    $lines += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | {6} | {7} |' -f (Escape-MdCell $r.TicketID), (Escape-MdCell $r.FileName), (Escape-MdCell $r.StaticDisposition), (Escape-MdCell $r.DispositionBucket), (Escape-MdCell $r.RiskDisposition), $r.ContainsCopyItem, $r.ContainsGitCommand, $r.ActionNow)
}
$lines += ''
$lines += '## Decision'
$lines += ''
$lines += '- HSRB-003 remains review-only.'
$lines += '- No selected file is cleared for execution.'
$lines += '- No selected file is route authority, cleanup authority, commit authority, push authority, or doctrine authority.'
$lines += '- Copy/Git markers are indexed as review-only evidence and remain non-clearance markers.'
$lines += '- The next object is an index closeout, not execution or route work.'
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

Write-LinesNoBom -Path $OutIndexMdPath -Lines $lines
$indexMdSha = Get-Sha256Safe -Path $OutIndexMdPath
Write-LinesNoBom -Path $OutIndexPrintPath -Lines $lines
$indexPrintSha = Get-Sha256Safe -Path $OutIndexPrintPath

$receiptLines = @()
$receiptLines += 'HSRB-003 RISK MARKER AND DISPOSITION INDEX RECEIPT V0.1'
$receiptLines += ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
$receiptLines += ('output_index_csv_path: {0}' -f $OutIndexCsvPath)
$receiptLines += ('output_index_csv_sha256: {0}' -f $indexCsvSha)
$receiptLines += ('output_index_md_path: {0}' -f $OutIndexMdPath)
$receiptLines += ('output_index_md_sha256: {0}' -f $indexMdSha)
$receiptLines += ('output_index_print_path: {0}' -f $OutIndexPrintPath)
$receiptLines += ('output_index_print_sha256: {0}' -f $indexPrintSha)
$receiptLines += ('contract_gate_passed: {0}' -f $contractGatePassed)
$receiptLines += 'selected_batch_id: HSRB-003'
$receiptLines += ('selected_batch_rows: {0}' -f $summaryRowCount)
$receiptLines += ('index_rows: {0}' -f (Count-Items $indexRows))
$receiptLines += ('blank_ticket_id_count: {0}' -f $blankTicketIdCount)
$receiptLines += ('missing_filename_count: {0}' -f $missingFilenameCount)
$receiptLines += ('missing_declared_sha256_count: {0}' -f $missingDeclaredSha256Count)
$receiptLines += ('missing_actual_sha256_count: {0}' -f $missingActualSha256Count)
$receiptLines += ('source_hash_mismatch_count: {0}' -f $sourceHashMismatchCount)
$receiptLines += ('source_missing_count: {0}' -f $sourceMissingCount)
$receiptLines += ('text_read_fail_count: {0}' -f $textReadFailCount)
$receiptLines += ('unknown_static_disposition_count: {0}' -f $unknownStaticDispositionCount)
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
$receiptLines += ('blocker_count: {0}' -f $blockerCount)
$receiptLines += ('next_single_action: {0}' -f $nextSingleAction)
$receiptLines += ('final_verdict: {0}' -f $finalVerdict)
$receiptLines += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-LinesNoBom -Path $OutReceiptPath -Lines $receiptLines
$receiptSha = Get-Sha256Safe -Path $OutReceiptPath

'=== HSRB-003 RISK MARKER AND DISPOSITION INDEX V0.1 COMPLETE ==='
"output_index_csv_path: $OutIndexCsvPath"
"output_index_csv_sha256: $indexCsvSha"
"output_index_md_path: $OutIndexMdPath"
"output_index_md_sha256: $indexMdSha"
"output_index_print_path: $OutIndexPrintPath"
"output_index_print_sha256: $indexPrintSha"
"output_receipt_path: $OutReceiptPath"
"output_receipt_sha256: $receiptSha"
("contract_gate_passed: {0}" -f $contractGatePassed)
'selected_batch_id: HSRB-003'
("selected_batch_rows: {0}" -f $summaryRowCount)
("index_rows: {0}" -f (Count-Items $indexRows))
("blank_ticket_id_count: {0}" -f $blankTicketIdCount)
("missing_filename_count: {0}" -f $missingFilenameCount)
("missing_declared_sha256_count: {0}" -f $missingDeclaredSha256Count)
("missing_actual_sha256_count: {0}" -f $missingActualSha256Count)
("source_hash_mismatch_count: {0}" -f $sourceHashMismatchCount)
("source_missing_count: {0}" -f $sourceMissingCount)
("text_read_fail_count: {0}" -f $textReadFailCount)
("unknown_static_disposition_count: {0}" -f $unknownStaticDispositionCount)
("helper_candidate_option_set_count: {0}" -f $helperCandidateOptionSetCount)
("old_load_or_system_option_set_count: {0}" -f $oldLoadOrSystemOptionSetCount)
("queue_closeout_and_next_action_card_count: {0}" -f $queueCloseoutAndNextActionCardCount)
("review_queue_family_count: {0}" -f $reviewQueueFamilyCount)
("source_authority_candidate_option_set_count: {0}" -f $sourceAuthorityCandidateOptionSetCount)
("support_candidate_option_set_count: {0}" -f $supportCandidateOptionSetCount)
("support_card_schema_and_dry_run_count: {0}" -f $supportCardSchemaAndDryRunCount)
("contains_copy_item_count: {0}" -f $containsCopyItemCount)
("contains_git_command_count: {0}" -f $containsGitCommandCount)
("contains_move_item_count: {0}" -f $containsMoveItemCount)
("contains_remove_item_count: {0}" -f $containsRemoveItemCount)
("contains_rename_item_count: {0}" -f $containsRenameItemCount)
("contains_start_process_count: {0}" -f $containsStartProcessCount)
("contains_invoke_expression_count: {0}" -f $containsInvokeExpressionCount)
("high_risk_command_marker_row_count: {0}" -f $highRiskCommandMarkerRowCount)
("risk_marked_row_count: {0}" -f $riskMarkedRowCount)
("unclassified_risk_marker_count: {0}" -f $unclassifiedRiskMarkerCount)
("execution_clearance_count: {0}" -f $executionClearanceCount)
("route_clearance_count: {0}" -f $routeClearanceCount)
("cleanup_clearance_count: {0}" -f $cleanupClearanceCount)
("doctrine_promotion_count: {0}" -f $doctrinePromotionCount)
("blocker_count: {0}" -f $blockerCount)
("next_single_action: {0}" -f $nextSingleAction)
("final_verdict: {0}" -f $finalVerdict)
("physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}" -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
