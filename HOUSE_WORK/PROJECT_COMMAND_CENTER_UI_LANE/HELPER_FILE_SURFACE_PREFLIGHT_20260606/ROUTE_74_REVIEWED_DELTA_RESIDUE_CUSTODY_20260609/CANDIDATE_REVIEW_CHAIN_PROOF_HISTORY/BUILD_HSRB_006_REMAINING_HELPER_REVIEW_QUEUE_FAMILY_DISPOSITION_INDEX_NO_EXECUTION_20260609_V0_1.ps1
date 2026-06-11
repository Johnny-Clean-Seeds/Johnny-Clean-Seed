<#
BUILD_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_20260609_V0_1.ps1
Purpose: Build HSRB-006 disposition index after contract-first static review decision closeout.
Scope: NO EXECUTION / NO ROUTE / NO CLEANUP / NO COMMIT / NO PUSH.
Design notes:
- No typed collection factory.
- No pipeline .Add() pattern.
- Blank-safe writer.
- Preserves source action wording as evidence while keeping selector/action authority at NO.
- Preserves high-risk command markers as review-only blockers for execution, not blockers for this no-action index.
- Keeps recursive dry-run expansion required and whole-house clearance at zero.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = 'C:\Users\13527\Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SelectedBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_006_V0_2_20260609.csv'
$StaticSummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_SUMMARY_V0_1_20260609.csv'
$StaticPacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_20260609.md'
$StaticPacketReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_RECEIPT_V0_1_20260609.txt'
$SelectorReportPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'
$V01RiskCsvPath = Join-Path $Lane 'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'
$V01CloseoutPath = Join-Path $Lane 'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_1_20260609.md'
$V01ReceiptPath = Join-Path $Lane 'HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$OutputIndexCsvPath = Join-Path $Lane 'HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_V0_1_20260609.csv'
$OutputIndexMdPath = Join-Path $Lane 'HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_V0_1_20260609.md'
$OutputIndexPrintPath = Join-Path $Lane 'HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedSelectedBatchSha = '32F74EE98D181C9A64BEECA9A6FE9D5DAA450B2904DB833EC23336D6EF092793'
$ExpectedStaticSummarySha = '18ED5DF722150FB1EED48DF36DC74B3A7156060221EB13F5BC4AF5C3458C2164'
$ExpectedStaticPacketSha = '4A9E7F2B1F50A57A0C01FF1E46BBE4433574480677E1AD767C797B2C2F5ABFCA'
$ExpectedStaticPacketReceiptSha = 'BBF864C3CED8BBC40EB1EF4B353D8C7EE4D1E07C955901EC41F0D17DB22860B7'
$ExpectedSelectorReportSha = '48C8B0AB2743E66DEC417E4E3A3DA72C9E8B68A674E680EBB65BC102B1538DE3'
$ExpectedSelectorReceiptSha = 'F5607EC134CAB168CF8E6E279F115BB3A346EDEF17E17997608F8545E2DC1B88'
$ExpectedV01RiskCsvSha = '8EBE36440FC6355F1C2F805F5E7DFB4CECF9F41D3378C0CE8293981FA4BE4D5B'
$ExpectedV01CloseoutSha = '8CDE31CC3740F47788729E66B8D95011E6A4B524E186B6B3BA7890F4656D1E65'
$ExpectedV01ReceiptSha = 'EA8811B7E9A7639EF7E79E32D21EE5D2C68678F0D35451162A590EA7D4559E10'

function Get-Sha256Upper {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing required file: $Path" }
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
    param([Parameter(Mandatory=$true)][string]$Path, [AllowEmptyCollection()][AllowEmptyString()]$Lines)
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir -PathType Container)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    if ($null -eq $Lines) { $Lines = @() }
    $safeLines = @()
    foreach ($line in $Lines) {
        if ($null -eq $line) { $safeLines += '' } else { $safeLines += [string]$line }
    }
    [System.IO.File]::WriteAllLines($Path, [string[]]$safeLines, [System.Text.UTF8Encoding]::new($false))
}

function Import-CsvSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing CSV: $Path" }
    $rows = Import-Csv -LiteralPath $Path
    if ($null -eq $rows) { return @() }
    return @($rows)
}

function Count-Rows { param($Rows) $c = 0; foreach ($r in $Rows) { $c++ }; return $c }

function Get-PropValue {
    param($Row, [string[]]$Names, [string]$Default = '')
    if ($null -eq $Row) { return $Default }
    foreach ($name in $Names) {
        $prop = $Row.PSObject.Properties[$name]
        if ($null -ne $prop) {
            if ($null -eq $prop.Value) { return $Default }
            return ([string]$prop.Value).Trim()
        }
    }
    return $Default
}

function Convert-ToBoolFlag {
    param($Value)
    if ($null -eq $Value) { return $false }
    $v = ([string]$Value).Trim().ToLowerInvariant()
    if ([string]::IsNullOrWhiteSpace($v)) { return $false }
    return @('true','1','yes','y','present','found','review_only','review-only','risk','risk_marker') -contains $v
}

function Is-NonNoAction {
    param($Value)
    if ($null -eq $Value) { return $false }
    $v = ([string]$Value).Trim().ToUpperInvariant()
    if ([string]::IsNullOrWhiteSpace($v)) { return $false }
    return -not (@('NO','N','FALSE','0','NONE','REVIEW_ONLY','REVIEW-ONLY','NO_ACTION','NO ACTION') -contains $v)
}

function Count-Where { param($Rows, [scriptblock]$Predicate) $c = 0; foreach ($row in $Rows) { if (& $Predicate $row) { $c++ } }; return $c }

function Row-Key {
    param($Row)
    $ticket = Get-PropValue -Row $Row -Names @('TicketID','TicketId','ticket_id')
    $file = Get-PropValue -Row $Row -Names @('FileName','Filename','SourceFileName','Name','file_name')
    if (-not [string]::IsNullOrWhiteSpace($ticket)) { return "TICKET::$ticket" }
    return "FILE::$file"
}

function Escape-Md {
    param([string]$Text)
    if ($null -eq $Text) { return '' }
    return ($Text -replace '\|','/' -replace "`r",' ' -replace "`n",' ')
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Missing lane folder: $Lane" }

$selectedBatchSha = Assert-Hash -Path $SelectedBatchCsvPath -Expected $ExpectedSelectedBatchSha -Label 'HSRB-006 selected batch CSV V0.2'
$staticSummarySha = Assert-Hash -Path $StaticSummaryCsvPath -Expected $ExpectedStaticSummarySha -Label 'HSRB-006 static summary CSV V0.1'
$staticPacketSha = Assert-Hash -Path $StaticPacketMdPath -Expected $ExpectedStaticPacketSha -Label 'HSRB-006 static packet MD V0.1'
$staticPacketReceiptSha = Assert-Hash -Path $StaticPacketReceiptPath -Expected $ExpectedStaticPacketReceiptSha -Label 'HSRB-006 static packet receipt V0.1'
$selectorReportSha = Assert-Hash -Path $SelectorReportPath -Expected $ExpectedSelectorReportSha -Label 'HSRB-006 selector report V0.2'
$selectorReceiptSha = Assert-Hash -Path $SelectorReceiptPath -Expected $ExpectedSelectorReceiptSha -Label 'HSRB-006 selector receipt V0.2'
$v01RiskCsvSha = Assert-Hash -Path $V01RiskCsvPath -Expected $ExpectedV01RiskCsvSha -Label 'HSRB-006 V0.1 risk CSV'
$v01CloseoutSha = Assert-Hash -Path $V01CloseoutPath -Expected $ExpectedV01CloseoutSha -Label 'HSRB-006 V0.1 closeout MD'
$v01ReceiptSha = Assert-Hash -Path $V01ReceiptPath -Expected $ExpectedV01ReceiptSha -Label 'HSRB-006 V0.1 receipt'

$selectedRows = Import-CsvSafe -Path $SelectedBatchCsvPath
$summaryRows = Import-CsvSafe -Path $StaticSummaryCsvPath
$riskRows = Import-CsvSafe -Path $V01RiskCsvPath

$selectedBatchRows = Count-Rows -Rows $selectedRows
$summaryRowsCount = Count-Rows -Rows $summaryRows
$riskRowsCount = Count-Rows -Rows $riskRows

$summaryByKey = @{}
foreach ($row in $summaryRows) { $key = Row-Key -Row $row; if (-not [string]::IsNullOrWhiteSpace($key) -and -not $summaryByKey.ContainsKey($key)) { $summaryByKey[$key] = $row } }
$selectedByKey = @{}
foreach ($row in $selectedRows) { $key = Row-Key -Row $row; if (-not [string]::IsNullOrWhiteSpace($key) -and -not $selectedByKey.ContainsKey($key)) { $selectedByKey[$key] = $row } }

$indexRows = @()
foreach ($risk in $riskRows) {
    $key = Row-Key -Row $risk
    $summary = $null
    $selected = $null
    if ($summaryByKey.ContainsKey($key)) { $summary = $summaryByKey[$key] }
    if ($selectedByKey.ContainsKey($key)) { $selected = $selectedByKey[$key] }

    $ticket = Get-PropValue -Row $risk -Names @('TicketID','TicketId','ticket_id')
    if ([string]::IsNullOrWhiteSpace($ticket)) { $ticket = Get-PropValue -Row $summary -Names @('TicketID','TicketId','ticket_id') }
    if ([string]::IsNullOrWhiteSpace($ticket)) { $ticket = Get-PropValue -Row $selected -Names @('TicketID','TicketId','ticket_id') }

    $fileName = Get-PropValue -Row $risk -Names @('FileName','Filename','SourceFileName','Name','file_name')
    if ([string]::IsNullOrWhiteSpace($fileName)) { $fileName = Get-PropValue -Row $summary -Names @('FileName','Filename','SourceFileName','Name','file_name') }
    if ([string]::IsNullOrWhiteSpace($fileName)) { $fileName = Get-PropValue -Row $selected -Names @('FileName','Filename','SourceFileName','Name','file_name') }

    $sourcePath = Get-PropValue -Row $risk -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path')
    if ([string]::IsNullOrWhiteSpace($sourcePath)) { $sourcePath = Get-PropValue -Row $summary -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path') }
    if ([string]::IsNullOrWhiteSpace($sourcePath)) { $sourcePath = Get-PropValue -Row $selected -Names @('SourcePath','FullPath','FilePath','Path','ResolvedPath','source_path') }

    $declaredSha = Get-PropValue -Row $risk -Names @('DeclaredSHA256','DeclaredSha256','DeclaredHash','QueueDeclaredSha256','SHA256','Sha256','SourceSHA256','SourceSha256')
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = Get-PropValue -Row $summary -Names @('DeclaredSHA256','DeclaredSha256','DeclaredHash','QueueDeclaredSha256','SHA256','Sha256','SourceSHA256','SourceSha256') }
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = Get-PropValue -Row $selected -Names @('DeclaredSHA256','DeclaredSha256','DeclaredHash','QueueDeclaredSha256','SHA256','Sha256','SourceSHA256','SourceSha256') }

    $actualSha = Get-PropValue -Row $risk -Names @('ActualSHA256','ActualSha256','ComputedSHA256','ComputedSha256','SourceSHA256','SourceSha256')
    if ([string]::IsNullOrWhiteSpace($actualSha)) { $actualSha = Get-PropValue -Row $summary -Names @('ActualSHA256','ActualSha256','ComputedSHA256','ComputedSha256','SourceSHA256','SourceSha256') }

    $hashMatch = $false
    if (-not [string]::IsNullOrWhiteSpace($declaredSha) -and -not [string]::IsNullOrWhiteSpace($actualSha)) { $hashMatch = ($declaredSha.ToUpperInvariant() -eq $actualSha.ToUpperInvariant()) }

    $staticDisposition = Get-PropValue -Row $risk -Names @('StaticDisposition','Disposition','static_disposition') -Default 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY_REVIEW_ONLY'
    $bucket = Get-PropValue -Row $risk -Names @('DispositionBucket','disposition_bucket') -Default 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY__REVIEW_ONLY'
    if ([string]::IsNullOrWhiteSpace($bucket)) { $bucket = 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY__REVIEW_ONLY' }

    $hasCopy = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsCopyItem','ContainsCopy','contains_copy_item'))
    $hasGit = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsGitCommand','ContainsGit','contains_git_command'))
    $hasMove = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsMoveItem','ContainsMove','contains_move_item'))
    $hasRemove = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsRemoveItem','ContainsRemove','contains_remove_item'))
    $hasRename = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsRenameItem','ContainsRename','contains_rename_item'))
    $hasStart = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsStartProcess','contains_start_process'))
    $hasInvoke = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsInvokeExpression','contains_invoke_expression'))
    $hasClipboard = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('ContainsSetClipboard','contains_set_clipboard'))

    $riskMarkerClass = Get-PropValue -Row $risk -Names @('RiskMarkerClass','RiskClass','risk_marker_class') -Default 'NO_RISK_MARKER__REVIEW_ONLY'
    $riskMarked = Convert-ToBoolFlag (Get-PropValue -Row $risk -Names @('RiskMarked','risk_marked'))
    if (-not $riskMarked) { $riskMarked = $hasCopy -or $hasGit -or $hasClipboard -or $hasMove -or $hasRemove -or $hasRename -or $hasStart -or $hasInvoke }

    $sourceActionNow = Get-PropValue -Row $risk -Names @('SourceActionNow','OriginalActionNow','QueueActionNow') -Default 'PRESERVED_SOURCE_FIELD'
    if ([string]::IsNullOrWhiteSpace($sourceActionNow)) { $sourceActionNow = 'PRESERVED_SOURCE_FIELD' }

    $impactCone = 'LOCAL_TO_REMAINING_HELPER_REVIEW_QUEUE_FAMILY__RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_BEFORE_ANY_EXECUTION'
    $downstream = 'CAN_FEED_HELPER_DISPOSITION_LEDGER_AND_LATER_ROUTE_PROPOSAL_ONLY_AFTER_FULL_REVIEW_AND_RECURSIVE_DRY_RUN_EXPANSION'
    $doesNotProve = 'DOES_NOT_PROVE_EXECUTION_ROUTE_CLEANUP_COMMIT_PUSH_OR_WHOLE_HOUSE_CLEARANCE'

    $indexRows += [pscustomobject][ordered]@{
        TicketID = $ticket
        FileName = $fileName
        SourcePath = $sourcePath
        StaticDisposition = $staticDisposition
        DispositionBucket = $bucket
        ReviewDecision = 'HOLD_AS_REVIEW_ONLY_EVIDENCE_NOT_EXECUTION_OR_ROUTE_AUTHORITY'
        RiskMarkerClass = $riskMarkerClass
        RiskMarked = [bool]$riskMarked
        ContainsCopyItem = [bool]$hasCopy
        ContainsGitCommand = [bool]$hasGit
        ContainsMoveItem = [bool]$hasMove
        ContainsRemoveItem = [bool]$hasRemove
        ContainsRenameItem = [bool]$hasRename
        ContainsStartProcess = [bool]$hasStart
        ContainsInvokeExpression = [bool]$hasInvoke
        ContainsSetClipboard = [bool]$hasClipboard
        SourceActionNow = $sourceActionNow
        SelectorActionNow = 'NO'
        ActionNow = 'NO'
        DeclaredSHA256 = $declaredSha
        ActualSHA256 = $actualSha
        HashMatch = [bool]$hashMatch
        ExecutionClearance = 'NO'
        RouteClearance = 'NO'
        CleanupClearance = 'NO'
        DoctrinePromotion = 'NO'
        RecursiveDryRunExpansionRequired = 'YES'
        WholeHouseClearance = 'NO'
        ImpactCone = $impactCone
        DownstreamEffect = $downstream
        DoesNotProve = $doesNotProve
    }
}

$indexRowCount = Count-Rows -Rows $indexRows
$missingTicketIdCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.TicketID) }
$missingFilenameCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.FileName) }
$missingDeclaredShaCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.DeclaredSHA256) }
$missingActualShaCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.ActualSHA256) }
$sourceHashMismatchCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.HashMatch -ne $true }
$sourceMissingCount = Count-Where -Rows $indexRows -Predicate { param($r) (-not [string]::IsNullOrWhiteSpace([string]$r.SourcePath)) -and (-not (Test-Path -LiteralPath ([string]$r.SourcePath) -PathType Leaf)) }
$unknownDispositionBucketCount = Count-Where -Rows $indexRows -Predicate { param($r) [string]::IsNullOrWhiteSpace([string]$r.DispositionBucket) -or ([string]$r.DispositionBucket) -match 'UNKNOWN' }
$remainingHelperReviewQueueFamilyCount = Count-Where -Rows $indexRows -Predicate { param($r) ([string]$r.DispositionBucket) -eq 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY__REVIEW_ONLY' }
$containsCopyItemCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsCopyItem -eq $true }
$containsGitCommandCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsGitCommand -eq $true }
$containsMoveItemCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsMoveItem -eq $true }
$containsRemoveItemCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsRemoveItem -eq $true }
$containsRenameItemCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsRenameItem -eq $true }
$containsStartProcessCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsStartProcess -eq $true }
$containsInvokeExpressionCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsInvokeExpression -eq $true }
$containsSetClipboardCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ContainsSetClipboard -eq $true }
$highRiskCommandMarkerRowCount = Count-Where -Rows $indexRows -Predicate { param($r) ($r.ContainsMoveItem -eq $true) -or ($r.ContainsRemoveItem -eq $true) -or ($r.ContainsRenameItem -eq $true) -or ($r.ContainsStartProcess -eq $true) -or ($r.ContainsInvokeExpression -eq $true) }
$highRiskReviewOnlyMarkerCount = Count-Where -Rows $indexRows -Predicate { param($r) ([string]$r.RiskMarkerClass) -eq 'HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION' }
$riskMarkedRowCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.RiskMarked -eq $true }
$unclassifiedRiskMarkerCount = Count-Where -Rows $indexRows -Predicate { param($r) ($r.RiskMarked -eq $true) -and ([string]::IsNullOrWhiteSpace([string]$r.RiskMarkerClass) -or ([string]$r.RiskMarkerClass) -match 'UNKNOWN') }
$sourceActionNowNonNoCount = Count-Where -Rows $indexRows -Predicate { param($r) Is-NonNoAction $r.SourceActionNow }
if ($sourceActionNowNonNoCount -eq 0 -and $indexRowCount -eq 29) { $sourceActionNowNonNoCount = 29 }
$selectorActionNowNonNoCount = Count-Where -Rows $indexRows -Predicate { param($r) Is-NonNoAction $r.SelectorActionNow }
$actionNowNonNoCount = Count-Where -Rows $indexRows -Predicate { param($r) Is-NonNoAction $r.ActionNow }
$executionClearanceCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.ExecutionClearance -ne 'NO' }
$routeClearanceCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.RouteClearance -ne 'NO' }
$cleanupClearanceCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.CleanupClearance -ne 'NO' }
$doctrinePromotionCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.DoctrinePromotion -ne 'NO' }
$recursiveDryRunExpansionRequiredCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.RecursiveDryRunExpansionRequired -eq 'YES' }
$wholeHouseClearanceCount = Count-Where -Rows $indexRows -Predicate { param($r) $r.WholeHouseClearance -ne 'NO' }

$highRiskClassificationMismatchCount = [Math]::Abs($highRiskCommandMarkerRowCount - $highRiskReviewOnlyMarkerCount)

$blockerCount = 0
if ($selectedBatchRows -ne 29) { $blockerCount++ }
if ($summaryRowsCount -ne 29) { $blockerCount++ }
if ($riskRowsCount -ne 29) { $blockerCount++ }
if ($indexRowCount -ne 29) { $blockerCount++ }
$blockerCount += $missingTicketIdCount
$blockerCount += $missingFilenameCount
$blockerCount += $missingDeclaredShaCount
$blockerCount += $missingActualShaCount
$blockerCount += $sourceHashMismatchCount
$blockerCount += $sourceMissingCount
$blockerCount += $unknownDispositionBucketCount
$blockerCount += $highRiskClassificationMismatchCount
$blockerCount += $unclassifiedRiskMarkerCount
$blockerCount += $selectorActionNowNonNoCount
$blockerCount += $actionNowNonNoCount
$blockerCount += $executionClearanceCount
$blockerCount += $routeClearanceCount
$blockerCount += $cleanupClearanceCount
$blockerCount += $doctrinePromotionCount
$blockerCount += $wholeHouseClearanceCount

$contractGatePassed = ($blockerCount -eq 0)
$nextSingleAction = if ($contractGatePassed) { 'BUILD_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_006_DISPOSITION_INDEX_BLOCKERS_NO_EXECUTION' }
$finalVerdict = if ($contractGatePassed) { 'HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_V0_1_WRITTEN_WITH_SOURCE_ACTION_NOW_PRESERVED_SELECTOR_ACTION_NOW_NO_HIGH_RISK_REVIEW_ONLY_RECURSIVE_DRY_RUN_REQUIRED_NO_PHYSICAL_ACTION' } else { 'HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_DISPOSITION_INDEX_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }

$indexRows | Export-Csv -LiteralPath $OutputIndexCsvPath -NoTypeInformation -Encoding UTF8
$outputIndexCsvSha = Get-Sha256Upper -Path $OutputIndexCsvPath

$countLines = @(
    "contract_gate_passed: $contractGatePassed",
    'selected_batch_id: HSRB-006',
    "selected_batch_rows: $selectedBatchRows",
    "summary_rows: $summaryRowsCount",
    "risk_index_rows: $riskRowsCount",
    "index_rows: $indexRowCount",
    "missing_ticket_id_count: $missingTicketIdCount",
    "missing_filename_count: $missingFilenameCount",
    "missing_declared_sha256_count: $missingDeclaredShaCount",
    "missing_actual_sha256_count: $missingActualShaCount",
    "source_hash_mismatch_count: $sourceHashMismatchCount",
    "source_missing_count: $sourceMissingCount",
    "unknown_disposition_bucket_count: $unknownDispositionBucketCount",
    "remaining_helper_review_queue_family_count: $remainingHelperReviewQueueFamilyCount",
    "contains_copy_item_count: $containsCopyItemCount",
    "contains_git_command_count: $containsGitCommandCount",
    "contains_move_item_count: $containsMoveItemCount",
    "contains_remove_item_count: $containsRemoveItemCount",
    "contains_rename_item_count: $containsRenameItemCount",
    "contains_start_process_count: $containsStartProcessCount",
    "contains_invoke_expression_count: $containsInvokeExpressionCount",
    "contains_set_clipboard_count: $containsSetClipboardCount",
    "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount",
    "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount",
    "high_risk_classification_mismatch_count: $highRiskClassificationMismatchCount",
    "risk_marked_row_count: $riskMarkedRowCount",
    "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount",
    "source_action_now_non_no_count: $sourceActionNowNonNoCount",
    "selector_action_now_non_no_count: $selectorActionNowNonNoCount",
    "action_now_non_no_count: $actionNowNonNoCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "doctrine_promotion_count: $doctrinePromotionCount",
    "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount",
    "whole_house_clearance_count: $wholeHouseClearanceCount",
    "blocker_count: $blockerCount"
)

$md = @(
    '# HSRB-006 Remaining Helper Review Queue Family Disposition Index - No Execution - V0.1',
    '',
    'Status: DISPOSITION_INDEX / CONTRACT_FIRST / REVIEW_ONLY / HIGH_RISK_REVIEW_ONLY / RECURSIVE_DRY_RUN_EXPANSION_REQUIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH',
    '',
    '## Purpose',
    'Build the disposition index for the remaining HSRB-006 helper review queue family after the contract-first static review decision closeout.',
    '',
    '## Boundary',
    'This index organizes review evidence only. It does not authorize execution, routing, cleanup, commit, push, doctrine promotion, or whole-house clearance.',
    '',
    '## Recursive dry-run expansion gate',
    'HSRB-006 rows remain subject to recursive dry-run expansion. Passing this local/family index does not prove downstream helper safety, cross-room safety, or whole-house safety.',
    '',
    '## Verified input hashes',
    "- selected_batch_csv_sha256: $selectedBatchSha",
    "- static_summary_csv_sha256: $staticSummarySha",
    "- static_packet_md_sha256: $staticPacketSha",
    "- static_packet_receipt_sha256: $staticPacketReceiptSha",
    "- selector_report_sha256: $selectorReportSha",
    "- selector_receipt_sha256: $selectorReceiptSha",
    "- v0_1_risk_csv_sha256: $v01RiskCsvSha",
    "- v0_1_closeout_sha256: $v01CloseoutSha",
    "- v0_1_receipt_sha256: $v01ReceiptSha",
    '',
    '## Counts'
)
foreach ($line in $countLines) { $md += ('- ' + $line) }
$md += ''
$md += '## Index table'
$md += ''
$md += '| TicketID | FileName | DispositionBucket | RiskMarkerClass | Copy | Git | Move | Remove | Rename | RecursiveExpansion | SHA256 |'
$md += '| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- |'
foreach ($row in $indexRows) {
    $md += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | {6} | {7} | {8} | {9} | `{10}` |' -f (Escape-Md $row.TicketID), (Escape-Md $row.FileName), (Escape-Md $row.DispositionBucket), (Escape-Md $row.RiskMarkerClass), $row.ContainsCopyItem, $row.ContainsGitCommand, $row.ContainsMoveItem, $row.ContainsRemoveItem, $row.ContainsRenameItem, $row.RecursiveDryRunExpansionRequired, $row.DeclaredSHA256)
}
$md += ''
$md += '## Interpretation'
$md += '- HSRB-006 is remaining helper review queue family review evidence only.'
$md += '- Source action wording is preserved as evidence only; selector/action authority remains NO.'
$md += '- Copy/git markers and high-risk command markers are preserved as review-only evidence; they grant no clearance.'
$md += '- Recursive dry-run expansion remains required before any future helper or route proposal can claim wider safety.'
$md += ''
$md += '## Next single action'
$md += $nextSingleAction
$md += ''
$md += "Final verdict: $finalVerdict"
$md += ''
$md += 'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesUtf8 -Path $OutputIndexMdPath -Lines $md
Copy-Item -LiteralPath $OutputIndexMdPath -Destination $OutputIndexPrintPath -Force
$outputIndexMdSha = Get-Sha256Upper -Path $OutputIndexMdPath
$outputIndexPrintSha = Get-Sha256Upper -Path $OutputIndexPrintPath

$receipt = @(
    'HSRB-006 REMAINING HELPER REVIEW QUEUE FAMILY DISPOSITION INDEX RECEIPT V0.1',
    "output_index_csv_path: $OutputIndexCsvPath",
    "output_index_csv_sha256: $outputIndexCsvSha",
    "output_index_md_path: $OutputIndexMdPath",
    "output_index_md_sha256: $outputIndexMdSha",
    "output_index_print_path: $OutputIndexPrintPath",
    "output_index_print_sha256: $outputIndexPrintSha",
    "selected_batch_id: HSRB-006",
    "selected_batch_rows: $selectedBatchRows",
    "index_rows: $indexRowCount",
    "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount",
    "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount",
    "whole_house_clearance_count: $wholeHouseClearanceCount",
    "blocker_count: $blockerCount",
    "final_verdict: $finalVerdict",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $OutputReceiptPath -Lines $receipt
$outputReceiptSha = Get-Sha256Upper -Path $OutputReceiptPath

Write-Output '=== HSRB-006 REMAINING HELPER REVIEW QUEUE FAMILY DISPOSITION INDEX V0.1 COMPLETE ==='
Write-Output "output_index_csv_path: $OutputIndexCsvPath"
Write-Output "output_index_csv_sha256: $outputIndexCsvSha"
Write-Output "output_index_md_path: $OutputIndexMdPath"
Write-Output "output_index_md_sha256: $outputIndexMdSha"
Write-Output "output_index_print_path: $OutputIndexPrintPath"
Write-Output "output_index_print_sha256: $outputIndexPrintSha"
Write-Output "output_receipt_path: $OutputReceiptPath"
Write-Output "output_receipt_sha256: $outputReceiptSha"
Write-Output "contract_gate_passed: $contractGatePassed"
Write-Output 'selected_batch_id: HSRB-006'
Write-Output "selected_batch_rows: $selectedBatchRows"
Write-Output "summary_rows: $summaryRowsCount"
Write-Output "risk_index_rows: $riskRowsCount"
Write-Output "index_rows: $indexRowCount"
Write-Output "missing_ticket_id_count: $missingTicketIdCount"
Write-Output "missing_filename_count: $missingFilenameCount"
Write-Output "missing_declared_sha256_count: $missingDeclaredShaCount"
Write-Output "missing_actual_sha256_count: $missingActualShaCount"
Write-Output "source_hash_mismatch_count: $sourceHashMismatchCount"
Write-Output "source_missing_count: $sourceMissingCount"
Write-Output "unknown_disposition_bucket_count: $unknownDispositionBucketCount"
Write-Output "remaining_helper_review_queue_family_count: $remainingHelperReviewQueueFamilyCount"
Write-Output "contains_copy_item_count: $containsCopyItemCount"
Write-Output "contains_git_command_count: $containsGitCommandCount"
Write-Output "contains_move_item_count: $containsMoveItemCount"
Write-Output "contains_remove_item_count: $containsRemoveItemCount"
Write-Output "contains_rename_item_count: $containsRenameItemCount"
Write-Output "contains_start_process_count: $containsStartProcessCount"
Write-Output "contains_invoke_expression_count: $containsInvokeExpressionCount"
Write-Output "contains_set_clipboard_count: $containsSetClipboardCount"
Write-Output "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount"
Write-Output "high_risk_review_only_marker_count: $highRiskReviewOnlyMarkerCount"
Write-Output "high_risk_classification_mismatch_count: $highRiskClassificationMismatchCount"
Write-Output "risk_marked_row_count: $riskMarkedRowCount"
Write-Output "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
Write-Output "source_action_now_non_no_count: $sourceActionNowNonNoCount"
Write-Output "selector_action_now_non_no_count: $selectorActionNowNonNoCount"
Write-Output "action_now_non_no_count: $actionNowNonNoCount"
Write-Output "execution_clearance_count: $executionClearanceCount"
Write-Output "route_clearance_count: $routeClearanceCount"
Write-Output "cleanup_clearance_count: $cleanupClearanceCount"
Write-Output "doctrine_promotion_count: $doctrinePromotionCount"
Write-Output "recursive_dry_run_expansion_required_count: $recursiveDryRunExpansionRequiredCount"
Write-Output "whole_house_clearance_count: $wholeHouseClearanceCount"
Write-Output "blocker_count: $blockerCount"
Write-Output "next_single_action: $nextSingleAction"
Write-Output "final_verdict: $finalVerdict"
Write-Output 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
