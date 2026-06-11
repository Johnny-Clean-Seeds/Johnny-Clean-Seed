Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$BatchId = 'HSRB-006'
$BatchName = 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY'
$Stamp = '20260609'

$SelectedBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_006_V0_2_20260609.csv'
$RemainingCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_REMAINING_AFTER_001_005_V0_2_20260609.csv'
$SelectorMdPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$SelectorPrintPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_006_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

$ExpectedSelectedBatchCsvSha = '32F74EE98D181C9A64BEECA9A6FE9D5DAA450B2904DB833EC23336D6EF092793'
$ExpectedRemainingCsvSha = '32F74EE98D181C9A64BEECA9A6FE9D5DAA450B2904DB833EC23336D6EF092793'
$ExpectedSelectorMdSha = '48C8B0AB2743E66DEC417E4E3A3DA72C9E8B68A674E680EBB65BC102B1538DE3'
$ExpectedSelectorPrintSha = '48C8B0AB2743E66DEC417E4E3A3DA72C9E8B68A674E680EBB65BC102B1538DE3'
$ExpectedSelectorReceiptSha = 'F5607EC134CAB168CF8E6E279F115BB3A346EDEF17E17997608F8545E2DC1B88'

$OutputSummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_SUMMARY_V0_1_20260609.csv'
$OutputPacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_20260609.md'
$OutputPrintPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Write-TextNoBom {
    param([Parameter(Mandatory=$true)][string]$Path, [AllowNull()][object]$Lines)
    $items = New-Object System.Collections.ArrayList
    if ($null -ne $Lines) {
        foreach ($line in $Lines) {
            if ($null -eq $line) { [void]$items.Add('') } else { [void]$items.Add([string]$line) }
        }
    }
    $text = [string]::Join([Environment]::NewLine, [string[]]($items.ToArray([string])))
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
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

function Count-Rows {
    param([AllowNull()]$Rows)
    if ($null -eq $Rows) { return 0 }
    if ($Rows -is [System.Array]) { return [int]$Rows.Count }
    return 1
}

function Select-Rows {
    param([AllowNull()]$Rows, [Parameter(Mandatory=$true)][scriptblock]$Predicate)
    $out = @()
    if ($null -eq $Rows) { return $out }
    foreach ($r in (Convert-ToSafeArray -Value $Rows)) {
        if (& $Predicate $r) { $out += $r }
    }
    return $out
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

function Escape-MdCell {
    param([AllowNull()]$Value)
    if ($null -eq $Value) { return '' }
    $s = [string]$Value
    $s = $s.Replace('|','/')
    $s = $s.Replace("`r",' ')
    $s = $s.Replace("`n",' ')
    return $s
}

function Resolve-SourcePath {
    param($Row)
    foreach ($name in @('SourcePath','FullPath','Path','LiteralPath','FullName')) {
        $candidate = Get-Cell -Row $Row -Names @($name)
        if (-not [string]::IsNullOrWhiteSpace($candidate)) { return $candidate.Trim().Trim('"') }
    }
    $fileName = Get-Cell -Row $Row -Names @('FileName','Filename','File','Name','SourceFileName','SourceName','ItemName')
    if ([string]::IsNullOrWhiteSpace($fileName)) { return '' }
    return (Join-Path $Root ([System.IO.Path]::GetFileName($fileName)))
}

function Test-ExpectedHash {
    param([string]$Name, [string]$Path, [string]$ExpectedSha)
    $exists = Test-Path -LiteralPath $Path -PathType Leaf
    $actual = ''
    $match = $false
    if ($exists) {
        $actual = Get-Sha256Safe -Path $Path
        $match = ($actual -eq $ExpectedSha)
    }
    return [pscustomobject]@{
        Name = [string]$Name
        Path = [string]$Path
        Exists = [bool]$exists
        ExpectedSha256 = [string]$ExpectedSha
        ActualSha256 = [string]$actual
        HashMatch = [bool]$match
    }
}

function Get-StaticDisposition {
    param([string]$FileName)
    $f = [string]$FileName
    if ($f -match 'ROOT_HELD|ROOT_HELD_GROUP|HELD_GROUP|ROUTE_PLAN|ROUTE_DRY_RUN|ROOT_DROP|HOLD|HELD') { return 'REMAINING_ROOT_HELD_OR_HOLD_REVIEW_ONLY' }
    if ($f -match 'CUSTODY|ANCHOR|RECEIPT|HASH|LEDGER|PROOF|EVIDENCE|FREEZE|FIX_NOTE') { return 'REMAINING_CUSTODY_PROOF_OR_RECEIPT_REVIEW_ONLY' }
    if ($f -match 'QUEUE|SELECTOR|NEXT_BATCH|STATIC_REVIEW|DECISION_CLOSEOUT|CLOSEOUT|DISPOSITION_INDEX') { return 'REMAINING_QUEUE_SELECTOR_OR_CLOSEOUT_REVIEW_ONLY' }
    if ($f -match 'HELPER|PREFLIGHT|PLANETARY|GATE|SURFACE|PACKET|WORKSHEET') { return 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY_REVIEW_ONLY' }
    return 'REMAINING_GENERAL_REVIEW_ONLY_BUCKET'
}

function Get-KnownOutcome {
    param([string]$FileName)
    $disp = Get-StaticDisposition -FileName $FileName
    switch ($disp) {
        'REMAINING_ROOT_HELD_OR_HOLD_REVIEW_ONLY' { return 'REMAINING_ROOT_HELD_OR_HOLD_EVIDENCE; REVIEW_ONLY' }
        'REMAINING_CUSTODY_PROOF_OR_RECEIPT_REVIEW_ONLY' { return 'REMAINING_CUSTODY_PROOF_RECEIPT_EVIDENCE; REVIEW_ONLY' }
        'REMAINING_QUEUE_SELECTOR_OR_CLOSEOUT_REVIEW_ONLY' { return 'REMAINING_QUEUE_SELECTOR_CLOSEOUT_EVIDENCE; REVIEW_ONLY' }
        'REMAINING_HELPER_REVIEW_QUEUE_FAMILY_REVIEW_ONLY' { return 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY_EVIDENCE; REVIEW_ONLY' }
        default { return 'REMAINING_GENERAL_REVIEW_ONLY_EVIDENCE' }
    }
}

function Get-ReviewNote {
    param([string]$FileName)
    $disp = Get-StaticDisposition -FileName $FileName
    switch ($disp) {
        'REMAINING_ROOT_HELD_OR_HOLD_REVIEW_ONLY' { return 'Remaining root-held/hold/route-family item. Preserve as evidence only; recursive dry-run expansion required before cross-room reliance.' }
        'REMAINING_CUSTODY_PROOF_OR_RECEIPT_REVIEW_ONLY' { return 'Remaining custody/proof/receipt item. Receipt/proof is not an order; recursive impact cone remains uncleared.' }
        'REMAINING_QUEUE_SELECTOR_OR_CLOSEOUT_REVIEW_ONLY' { return 'Remaining queue/selector/closeout item. Review as helper-process evidence only; not execution authority.' }
        'REMAINING_HELPER_REVIEW_QUEUE_FAMILY_REVIEW_ONLY' { return 'Remaining helper review queue family item. Static review only; recursive dry-run expansion required.' }
        default { return 'Remaining helper review evidence. No execution, route, cleanup, commit, push, doctrine promotion, or whole-house clearance.' }
    }
}

function New-StaticMetricRow {
    param($BatchRow)
    $fileNameRaw = Get-Cell -Row $BatchRow -Names @('FileName','Filename','File','Name','SourceFileName','SourceName','ItemName')
    $fileName = [System.IO.Path]::GetFileName($fileNameRaw.Trim().Trim('"'))
    $ticket = Get-Cell -Row $BatchRow -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID','ReviewTicketID','RowID','RowId','ID')
    $declaredSha = Get-Cell -Row $BatchRow -Names @('DeclaredSha256','DeclaredSHA256','SourceSha256','SourceSHA256','SHA256','Sha256','Hash','FileSHA256')
    $selectorActualSha = Get-Cell -Row $BatchRow -Names @('ActualSha256','ActualSHA256','SourceActualSha256','SourceActualSHA256','ComputedSha256','ComputedSHA256')
    $sourcePath = Resolve-SourcePath -Row $BatchRow
    $exists = (-not [string]::IsNullOrWhiteSpace($sourcePath)) -and (Test-Path -LiteralPath $sourcePath -PathType Leaf)

    $actualSha = ''
    $bytes = 0
    $lineCount = 0
    $textReadOk = $false
    $readError = ''
    $containsMoveItem = $false
    $containsRemoveItem = $false
    $containsRenameItem = $false
    $containsCopyItem = $false
    $containsStartProcess = $false
    $containsInvokeExpression = $false
    $containsSetClipboard = $false
    $containsExportCsv = $false
    $containsSetContent = $false
    $containsGetContent = $false
    $containsGetFileHash = $false
    $containsGitCommand = $false
    $containsNoExecutionMarker = $false
    $containsPhysicalZeroMarker = $false

    if ($exists) {
        $item = Get-Item -LiteralPath $sourcePath
        $bytes = [int64]$item.Length
        $actualSha = Get-Sha256Safe -Path $sourcePath
        try {
            $text = Get-Content -LiteralPath $sourcePath -Raw -ErrorAction Stop
            $textReadOk = $true
            if ([string]::IsNullOrEmpty($text)) { $lineCount = 0 } else { $lineCount = [int](([regex]::Matches($text, "`n")).Count + 1) }
            $containsMoveItem = [bool]($text -match '(?im)\bMove-Item\b')
            $containsRemoveItem = [bool]($text -match '(?im)\bRemove-Item\b')
            $containsRenameItem = [bool]($text -match '(?im)\bRename-Item\b')
            $containsCopyItem = [bool]($text -match '(?im)\bCopy-Item\b')
            $containsStartProcess = [bool]($text -match '(?im)\bStart-Process\b')
            $containsInvokeExpression = [bool]($text -match '(?im)\bInvoke-Expression\b|\biex\b')
            $containsSetClipboard = [bool]($text -match '(?im)\bSet-Clipboard\b')
            $containsExportCsv = [bool]($text -match '(?im)\bExport-Csv\b')
            $containsSetContent = [bool]($text -match '(?im)\bSet-Content\b|\[System\.IO\.File\]::WriteAllLines|\[System\.IO\.File\]::WriteAllText')
            $containsGetContent = [bool]($text -match '(?im)\bGet-Content\b')
            $containsGetFileHash = [bool]($text -match '(?im)\bGet-FileHash\b')
            $containsGitCommand = [bool]($text -match '(?im)(^|[^A-Za-z0-9_-])git(\s|\.|$)')
            $containsNoExecutionMarker = [bool]($text -match 'NO_EXECUTION|No execution|no execution|ExecutionAllowed')
            $containsPhysicalZeroMarker = [bool]($text -match 'physical_actions|PhysicalMoves|PhysicalExecutes|move=0 delete=0 rename=0')
        } catch {
            $readError = [string]$_.Exception.Message
        }
    }

    if ([string]::IsNullOrWhiteSpace($actualSha) -and (-not [string]::IsNullOrWhiteSpace($selectorActualSha))) { $actualSha = $selectorActualSha }
    if ([string]::IsNullOrWhiteSpace($declaredSha) -and (-not [string]::IsNullOrWhiteSpace($actualSha))) { $declaredSha = $actualSha }

    $declaredMatches = $false
    if ((-not [string]::IsNullOrWhiteSpace($declaredSha)) -and (-not [string]::IsNullOrWhiteSpace($actualSha))) {
        $declaredMatches = ($declaredSha.ToUpperInvariant() -eq $actualSha.ToUpperInvariant())
    }

    $sourceActionNow = Get-Cell -Row $BatchRow -Names @('SourceActionNow','OriginalActionNow','SourceAction','OriginalAction','SourceActionStatus')
    $selectorActionNow = Get-Cell -Row $BatchRow -Names @('SelectorActionNow','ActionNow','Action','ActionStatus')
    if ([string]::IsNullOrWhiteSpace($sourceActionNow)) { $sourceActionNow = 'NO' }
    if ([string]::IsNullOrWhiteSpace($selectorActionNow)) { $selectorActionNow = 'NO' }

    $highRisk = ($containsMoveItem -or $containsRemoveItem -or $containsRenameItem -or $containsStartProcess -or $containsInvokeExpression)
    $riskMarked = ($containsGitCommand -or $containsMoveItem -or $containsRemoveItem -or $containsRenameItem -or $containsCopyItem -or $containsStartProcess -or $containsInvokeExpression -or $containsSetClipboard)
    $staticDisposition = Get-StaticDisposition -FileName $fileName
    return [pscustomobject]@{
        BatchID = [string](Get-Cell -Row $BatchRow -Names @('BatchID','BatchId'))
        TicketID = [string]$ticket
        FileName = [string]$fileName
        ReviewRole = [string](Get-Cell -Row $BatchRow -Names @('ReviewRole','RoleLabel','Role'))
        SourcePath = [string]$sourcePath
        SourceExists = [bool]$exists
        DeclaredSha256 = [string]$declaredSha
        SourceSha256 = [string]$actualSha
        DeclaredShaMatchesActual = [bool]$declaredMatches
        SourceBytes = [int64]$bytes
        LineCount = [int]$lineCount
        TextReadOk = [bool]$textReadOk
        ReadError = [string]$readError
        SourceActionNow = [string]$sourceActionNow
        SelectorActionNow = [string]$selectorActionNow
        ActionNow = 'NO'
        StaticReviewOnly = 'YES'
        ExecutionAllowed = 'NO'
        RouteAllowed = 'NO'
        CleanupAllowed = 'NO'
        DoctrinePromotionAllowed = 'NO'
        RecursiveDryRunExpansionRequired = 'YES'
        WholeHouseClearance = 'NO'
        KnownOutcome = [string](Get-KnownOutcome -FileName $fileName)
        StaticDisposition = [string]$staticDisposition
        ContainsMoveItem = [bool]$containsMoveItem
        ContainsRemoveItem = [bool]$containsRemoveItem
        ContainsRenameItem = [bool]$containsRenameItem
        ContainsCopyItem = [bool]$containsCopyItem
        ContainsStartProcess = [bool]$containsStartProcess
        ContainsInvokeExpression = [bool]$containsInvokeExpression
        ContainsSetClipboard = [bool]$containsSetClipboard
        ContainsExportCsv = [bool]$containsExportCsv
        ContainsSetContent = [bool]$containsSetContent
        ContainsGetContent = [bool]$containsGetContent
        ContainsGetFileHash = [bool]$containsGetFileHash
        ContainsGitCommand = [bool]$containsGitCommand
        ContainsNoExecutionMarker = [bool]$containsNoExecutionMarker
        ContainsPhysicalZeroMarker = [bool]$containsPhysicalZeroMarker
        HighRiskCommandMarker = [bool]$highRisk
        HighRiskReviewOnlyMarker = [bool]$highRisk
        RiskMarked = [bool]$riskMarked
        RiskDisposition = if ($highRisk) { 'REVIEW_ONLY_HIGH_RISK_MARKER__NOT_CLEARED' } elseif ($riskMarked) { 'REVIEW_ONLY_RISK_MARKER__NOT_CLEARED_FOR_EXECUTION' } else { 'REVIEW_ONLY_NO_RISK_COMMAND_MARKER_DETECTED' }
        ReviewNote = [string](Get-ReviewNote -FileName $fileName)
        DoesNotProve = 'Does not prove helper is safe outside impact cone; does not authorize execution, route, cleanup, commit, push, or doctrine promotion.'
    }
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }

$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'selected_batch_006_v0_2_csv' -Path $SelectedBatchCsvPath -ExpectedSha $ExpectedSelectedBatchCsvSha
$hashChecks += Test-ExpectedHash -Name 'remaining_after_001_005_v0_2_csv' -Path $RemainingCsvPath -ExpectedSha $ExpectedRemainingCsvSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_006_selector_v0_2_md' -Path $SelectorMdPath -ExpectedSha $ExpectedSelectorMdSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_006_selector_v0_2_print' -Path $SelectorPrintPath -ExpectedSha $ExpectedSelectorPrintSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_006_selector_v0_2_receipt' -Path $SelectorReceiptPath -ExpectedSha $ExpectedSelectorReceiptSha

$blockers = @()
foreach ($h in $hashChecks) {
    if (-not $h.Exists) { $blockers += ('MISSING_{0}: {1}' -f $h.Name, $h.Path) }
    elseif (-not $h.HashMatch) { $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256) }
}

$selectedRows = @()
if ($blockers.Count -eq 0) {
    foreach ($row in (Convert-ToSafeArray -Value (Import-Csv -LiteralPath $SelectedBatchCsvPath))) { $selectedRows += $row }
}
$selectedRowCount = Count-Rows $selectedRows
if (($blockers.Count -eq 0) -and ($selectedRowCount -ne 29)) { $blockers += ('UNEXPECTED_SELECTED_BATCH_ROW_COUNT: {0}' -f $selectedRowCount) }

$summaryRows = @()
if ($blockers.Count -eq 0) {
    foreach ($row in $selectedRows) { $summaryRows += (New-StaticMetricRow -BatchRow $row) }
}

$sourceMissingRows = Select-Rows $summaryRows { param($x) -not $x.SourceExists }
$textReadFailRows = Select-Rows $summaryRows { param($x) -not $x.TextReadOk }
$blankTicketRows = Select-Rows $summaryRows { param($x) [string]::IsNullOrWhiteSpace([string]$x.TicketID) }
$missingFileNameRows = Select-Rows $summaryRows { param($x) [string]::IsNullOrWhiteSpace([string]$x.FileName) }
$missingDeclaredShaRows = Select-Rows $summaryRows { param($x) [string]::IsNullOrWhiteSpace([string]$x.DeclaredSha256) }
$missingActualShaRows = Select-Rows $summaryRows { param($x) [string]::IsNullOrWhiteSpace([string]$x.SourceSha256) }
$sourceHashMismatchRows = Select-Rows $summaryRows { param($x) -not $x.DeclaredShaMatchesActual }
$unknownDispositionRows = Select-Rows $summaryRows { param($x) [string]::IsNullOrWhiteSpace([string]$x.StaticDisposition) -or $x.StaticDisposition -match '^UNKNOWN' }
$moveItemRows = Select-Rows $summaryRows { param($x) $x.ContainsMoveItem }
$removeItemRows = Select-Rows $summaryRows { param($x) $x.ContainsRemoveItem }
$renameItemRows = Select-Rows $summaryRows { param($x) $x.ContainsRenameItem }
$copyItemRows = Select-Rows $summaryRows { param($x) $x.ContainsCopyItem }
$startProcessRows = Select-Rows $summaryRows { param($x) $x.ContainsStartProcess }
$invokeExpressionRows = Select-Rows $summaryRows { param($x) $x.ContainsInvokeExpression }
$gitCommandRows = Select-Rows $summaryRows { param($x) $x.ContainsGitCommand }
$setClipboardRows = Select-Rows $summaryRows { param($x) $x.ContainsSetClipboard }
$highRiskRows = Select-Rows $summaryRows { param($x) $x.HighRiskCommandMarker }
$highRiskReviewOnlyRows = Select-Rows $summaryRows { param($x) $x.HighRiskReviewOnlyMarker }
$riskMarkedRows = Select-Rows $summaryRows { param($x) $x.RiskMarked }
$unclassifiedRiskRows = Select-Rows $summaryRows { param($x) ($x.RiskMarked) -and [string]::IsNullOrWhiteSpace([string]$x.RiskDisposition) }
$sourceActionNowNonNoRows = Select-Rows $summaryRows { param($x) ([string]$x.SourceActionNow).Trim().ToUpperInvariant() -ne 'NO' }
$selectorActionNowNonNoRows = Select-Rows $summaryRows { param($x) ([string]$x.SelectorActionNow).Trim().ToUpperInvariant() -ne 'NO' }
$actionNowNonNoRows = Select-Rows $summaryRows { param($x) ([string]$x.ActionNow).Trim().ToUpperInvariant() -ne 'NO' }
$recursiveRequiredRows = Select-Rows $summaryRows { param($x) ([string]$x.RecursiveDryRunExpansionRequired).Trim().ToUpperInvariant() -eq 'YES' }
$wholeHouseClearanceRows = Select-Rows $summaryRows { param($x) ([string]$x.WholeHouseClearance).Trim().ToUpperInvariant() -eq 'YES' }
$remainingRootHeldRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'REMAINING_ROOT_HELD_OR_HOLD_REVIEW_ONLY' }
$remainingCustodyRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'REMAINING_CUSTODY_PROOF_OR_RECEIPT_REVIEW_ONLY' }
$remainingQueueRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'REMAINING_QUEUE_SELECTOR_OR_CLOSEOUT_REVIEW_ONLY' }
$remainingHelperRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'REMAINING_HELPER_REVIEW_QUEUE_FAMILY_REVIEW_ONLY' }
$remainingGeneralRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'REMAINING_GENERAL_REVIEW_ONLY_BUCKET' }

if (($blockers.Count -eq 0) -and ((Count-Rows $blankTicketRows) -ne 0)) { $blockers += ('BLANK_TICKET_ID_ROWS: {0}' -f (Count-Rows $blankTicketRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $missingFileNameRows) -ne 0)) { $blockers += ('MISSING_FILENAME_ROWS: {0}' -f (Count-Rows $missingFileNameRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $missingDeclaredShaRows) -ne 0)) { $blockers += ('MISSING_DECLARED_SHA256_ROWS: {0}' -f (Count-Rows $missingDeclaredShaRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $missingActualShaRows) -ne 0)) { $blockers += ('MISSING_ACTUAL_SHA256_ROWS: {0}' -f (Count-Rows $missingActualShaRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $sourceHashMismatchRows) -ne 0)) { $blockers += ('SOURCE_HASH_MISMATCH_ROWS: {0}' -f (Count-Rows $sourceHashMismatchRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $sourceMissingRows) -ne 0)) { $blockers += ('SOURCE_MISSING_ROWS: {0}' -f (Count-Rows $sourceMissingRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $textReadFailRows) -ne 0)) { $blockers += ('TEXT_READ_FAIL_ROWS: {0}' -f (Count-Rows $textReadFailRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $unknownDispositionRows) -ne 0)) { $blockers += ('UNKNOWN_STATIC_DISPOSITION_ROWS: {0}' -f (Count-Rows $unknownDispositionRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $unclassifiedRiskRows) -ne 0)) { $blockers += ('UNCLASSIFIED_RISK_MARKER_ROWS: {0}' -f (Count-Rows $unclassifiedRiskRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $selectorActionNowNonNoRows) -ne 0)) { $blockers += ('SELECTOR_ACTION_NOW_NON_NO_ROWS: {0}' -f (Count-Rows $selectorActionNowNonNoRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $actionNowNonNoRows) -ne 0)) { $blockers += ('ACTION_NOW_NON_NO_ROWS: {0}' -f (Count-Rows $actionNowNonNoRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $wholeHouseClearanceRows) -ne 0)) { $blockers += ('WHOLE_HOUSE_CLEARANCE_ROWS: {0}' -f (Count-Rows $wholeHouseClearanceRows)) }

$contractGatePassed = ($blockers.Count -eq 0)
if ((Count-Rows $summaryRows) -gt 0) { $summaryRows | Export-Csv -LiteralPath $OutputSummaryCsvPath -NoTypeInformation -Encoding UTF8 }

$packet = @()
$packet += '# Static Review Packet - Batch HSRB-006 Remaining Helper Review Queue Family - V0.1'
$packet += ''
$packet += 'Status: STATIC_REVIEW_PACKET / CONTRACT_FIRST / RECURSIVE_DRY_RUN_EXPANSION_BOUNDARY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$packet += ''
$packet += '## Purpose'
$packet += ''
$packet += 'Review the remaining HSRB-006 helper review queue family as static text only. This packet preserves source action wording as evidence, normalizes selector/action authority to NO, classifies command markers as review-only risk evidence, and carries the recursive dry-run expansion requirement forward.'
$packet += ''
$packet += '## Boundary'
$packet += ''
$packet += 'No selected helper is executed. No root file is moved, deleted, renamed, copied, routed, cleaned, committed, or pushed. This output is review evidence only and does not provide whole-house clearance.'
$packet += ''
$packet += '## Verified selector inputs'
$packet += ''
$packet += '| Input | Exists | HashMatch | SHA256 |'
$packet += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) { $packet += ('| {0} | {1} | {2} | `{3}` |' -f $h.Name, $h.Exists, $h.HashMatch, $h.ActualSha256) }
$packet += ''
$packet += '## Counts'
$packet += ''
$packet += '- selected_batch_id: HSRB-006'
$packet += ('- selected_batch_rows: {0}' -f $selectedRowCount)
$packet += ('- summary_rows: {0}' -f (Count-Rows $summaryRows))
$packet += ('- blank_ticket_id_count: {0}' -f (Count-Rows $blankTicketRows))
$packet += ('- missing_filename_count: {0}' -f (Count-Rows $missingFileNameRows))
$packet += ('- missing_declared_sha256_count: {0}' -f (Count-Rows $missingDeclaredShaRows))
$packet += ('- missing_actual_sha256_count: {0}' -f (Count-Rows $missingActualShaRows))
$packet += ('- source_hash_mismatch_count: {0}' -f (Count-Rows $sourceHashMismatchRows))
$packet += ('- source_missing_count: {0}' -f (Count-Rows $sourceMissingRows))
$packet += ('- text_read_fail_count: {0}' -f (Count-Rows $textReadFailRows))
$packet += ('- remaining_root_held_or_hold_count: {0}' -f (Count-Rows $remainingRootHeldRows))
$packet += ('- remaining_custody_proof_or_receipt_count: {0}' -f (Count-Rows $remainingCustodyRows))
$packet += ('- remaining_queue_selector_or_closeout_count: {0}' -f (Count-Rows $remainingQueueRows))
$packet += ('- remaining_helper_review_queue_family_count: {0}' -f (Count-Rows $remainingHelperRows))
$packet += ('- remaining_general_review_only_bucket_count: {0}' -f (Count-Rows $remainingGeneralRows))
$packet += ('- unknown_static_disposition_count: {0}' -f (Count-Rows $unknownDispositionRows))
$packet += ('- contains_move_item_count: {0}' -f (Count-Rows $moveItemRows))
$packet += ('- contains_remove_item_count: {0}' -f (Count-Rows $removeItemRows))
$packet += ('- contains_rename_item_count: {0}' -f (Count-Rows $renameItemRows))
$packet += ('- contains_copy_item_count: {0}' -f (Count-Rows $copyItemRows))
$packet += ('- contains_start_process_count: {0}' -f (Count-Rows $startProcessRows))
$packet += ('- contains_invoke_expression_count: {0}' -f (Count-Rows $invokeExpressionRows))
$packet += ('- contains_git_command_count: {0}' -f (Count-Rows $gitCommandRows))
$packet += ('- contains_set_clipboard_count: {0}' -f (Count-Rows $setClipboardRows))
$packet += ('- high_risk_command_marker_row_count: {0}' -f (Count-Rows $highRiskRows))
$packet += ('- high_risk_review_only_marker_count: {0}' -f (Count-Rows $highRiskReviewOnlyRows))
$packet += ('- risk_marked_row_count: {0}' -f (Count-Rows $riskMarkedRows))
$packet += ('- unclassified_risk_marker_count: {0}' -f (Count-Rows $unclassifiedRiskRows))
$packet += ('- source_action_now_non_no_count: {0}' -f (Count-Rows $sourceActionNowNonNoRows))
$packet += ('- selector_action_now_non_no_count: {0}' -f (Count-Rows $selectorActionNowNonNoRows))
$packet += ('- action_now_non_no_count: {0}' -f (Count-Rows $actionNowNonNoRows))
$packet += ('- recursive_dry_run_expansion_required_count: {0}' -f (Count-Rows $recursiveRequiredRows))
$packet += ('- whole_house_clearance_count: {0}' -f (Count-Rows $wholeHouseClearanceRows))
$packet += ('- blocker_count: {0}' -f $blockers.Count)
$packet += ''
$packet += '## Static review table'
$packet += ''
$packet += '| TicketID | FileName | Lines | StaticDisposition | RiskDisposition | SourceActionNow | ActionNow | HashMatch |'
$packet += '| --- | --- | ---: | --- | --- | --- | --- | ---: |'
foreach ($r in $summaryRows) {
    $packet += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | {6} | {7} |' -f $r.TicketID, (Escape-MdCell $r.FileName), $r.LineCount, (Escape-MdCell $r.StaticDisposition), (Escape-MdCell $r.RiskDisposition), (Escape-MdCell $r.SourceActionNow), (Escape-MdCell $r.ActionNow), $r.DeclaredShaMatchesActual)
}
$packet += ''
$packet += '## Static safety scan'
$packet += ''
$packet += '| FileName | Move-Item | Remove-Item | Rename-Item | Copy-Item | Start-Process | Invoke-Expression | GitCommand | Set-Clipboard | HighRiskReviewOnly | RecursiveDryRun | WholeHouseClearance |'
$packet += '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |'
foreach ($r in $summaryRows) {
    $packet += ('| `{0}` | {1} | {2} | {3} | {4} | {5} | {6} | {7} | {8} | {9} | {10} | {11} |' -f (Escape-MdCell $r.FileName), $r.ContainsMoveItem, $r.ContainsRemoveItem, $r.ContainsRenameItem, $r.ContainsCopyItem, $r.ContainsStartProcess, $r.ContainsInvokeExpression, $r.ContainsGitCommand, $r.ContainsSetClipboard, $r.HighRiskReviewOnlyMarker, $r.RecursiveDryRunExpansionRequired, $r.WholeHouseClearance)
}
$packet += ''
$packet += '## Review notes'
$packet += ''
foreach ($r in $summaryRows) {
    $packet += ('### {0}' -f $r.FileName)
    $packet += ''
    $packet += ('- TicketID: {0}' -f $r.TicketID)
    $packet += ('- Known outcome: {0}' -f $r.KnownOutcome)
    $packet += ('- Static disposition: {0}' -f $r.StaticDisposition)
    $packet += ('- Risk disposition: {0}' -f $r.RiskDisposition)
    $packet += ('- SourceActionNow preserved as evidence: {0}' -f $r.SourceActionNow)
    $packet += ('- ActionNow for this static packet: {0}' -f $r.ActionNow)
    $packet += ('- Recursive dry-run expansion required: {0}' -f $r.RecursiveDryRunExpansionRequired)
    $packet += ('- Whole-house clearance: {0}' -f $r.WholeHouseClearance)
    $packet += ('- Review note: {0}' -f $r.ReviewNote)
    $packet += ''
}
$packet += '## Blockers'
$packet += ''
if ($blockers.Count -eq 0) { $packet += 'None.' } else { foreach ($b in $blockers) { $packet += ('- {0}' -f $b) } }
$packet += ''
$packet += '## DoesNotProve'
$packet += ''
$packet += 'This static packet does not prove any selected helper is safe to execute, route-approved, cleanup-approved, source-authoritative, whole-house cleared, doctrine, or ready to commit/push. It proves only that the selected batch was read as static text and classified for review.'
$packet += ''
$packet += '## Next single action'
$packet += ''
if ($contractGatePassed) {
    $packet += 'BUILD_HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION'
    $packet += ''
    $packet += 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_WRITTEN_WITH_REVIEW_ONLY_HIGH_RISK_MARKERS_AND_RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_NO_PHYSICAL_ACTION'
} else {
    $packet += 'STOP_AND_REVIEW_HSRB_006_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION'
    $packet += ''
    $packet += 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}

Write-TextNoBom -Path $OutputPacketMdPath -Lines $packet
Write-TextNoBom -Path $OutputPrintPath -Lines $packet
if ((Count-Rows $summaryRows) -gt 0) { $summaryRows | Export-Csv -LiteralPath $OutputSummaryCsvPath -NoTypeInformation -Encoding UTF8 }

$OutputSummaryCsvSha = Get-Sha256Safe -Path $OutputSummaryCsvPath
$OutputPacketMdSha = Get-Sha256Safe -Path $OutputPacketMdPath
$OutputPrintSha = Get-Sha256Safe -Path $OutputPrintPath

$receipt = @()
$receipt += 'STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_RECEIPT_V0_1_20260609'
$receipt += ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
$receipt += ('contract_gate_passed: {0}' -f $contractGatePassed)
$receipt += ('input_selected_batch_csv_path: {0}' -f $SelectedBatchCsvPath)
$receipt += ('input_selected_batch_csv_expected_sha256: {0}' -f $ExpectedSelectedBatchCsvSha)
$receipt += ('output_summary_csv_path: {0}' -f $OutputSummaryCsvPath)
$receipt += ('output_summary_csv_sha256: {0}' -f $OutputSummaryCsvSha)
$receipt += ('output_packet_md_path: {0}' -f $OutputPacketMdPath)
$receipt += ('output_packet_md_sha256: {0}' -f $OutputPacketMdSha)
$receipt += ('output_print_path: {0}' -f $OutputPrintPath)
$receipt += ('output_print_sha256: {0}' -f $OutputPrintSha)
$receipt += 'selected_batch_id: HSRB-006'
$receipt += ('selected_batch_rows: {0}' -f $selectedRowCount)
$receipt += ('summary_rows: {0}' -f (Count-Rows $summaryRows))
$receipt += ('blank_ticket_id_count: {0}' -f (Count-Rows $blankTicketRows))
$receipt += ('missing_filename_count: {0}' -f (Count-Rows $missingFileNameRows))
$receipt += ('missing_declared_sha256_count: {0}' -f (Count-Rows $missingDeclaredShaRows))
$receipt += ('missing_actual_sha256_count: {0}' -f (Count-Rows $missingActualShaRows))
$receipt += ('source_hash_mismatch_count: {0}' -f (Count-Rows $sourceHashMismatchRows))
$receipt += ('source_missing_count: {0}' -f (Count-Rows $sourceMissingRows))
$receipt += ('text_read_fail_count: {0}' -f (Count-Rows $textReadFailRows))
$receipt += ('unknown_static_disposition_count: {0}' -f (Count-Rows $unknownDispositionRows))
$receipt += ('contains_move_item_count: {0}' -f (Count-Rows $moveItemRows))
$receipt += ('contains_remove_item_count: {0}' -f (Count-Rows $removeItemRows))
$receipt += ('contains_rename_item_count: {0}' -f (Count-Rows $renameItemRows))
$receipt += ('contains_copy_item_count: {0}' -f (Count-Rows $copyItemRows))
$receipt += ('contains_start_process_count: {0}' -f (Count-Rows $startProcessRows))
$receipt += ('contains_invoke_expression_count: {0}' -f (Count-Rows $invokeExpressionRows))
$receipt += ('contains_git_command_count: {0}' -f (Count-Rows $gitCommandRows))
$receipt += ('contains_set_clipboard_count: {0}' -f (Count-Rows $setClipboardRows))
$receipt += ('high_risk_command_marker_row_count: {0}' -f (Count-Rows $highRiskRows))
$receipt += ('high_risk_review_only_marker_count: {0}' -f (Count-Rows $highRiskReviewOnlyRows))
$receipt += ('risk_marked_row_count: {0}' -f (Count-Rows $riskMarkedRows))
$receipt += ('unclassified_risk_marker_count: {0}' -f (Count-Rows $unclassifiedRiskRows))
$receipt += ('source_action_now_non_no_count: {0}' -f (Count-Rows $sourceActionNowNonNoRows))
$receipt += ('selector_action_now_non_no_count: {0}' -f (Count-Rows $selectorActionNowNonNoRows))
$receipt += ('action_now_non_no_count: {0}' -f (Count-Rows $actionNowNonNoRows))
$receipt += ('recursive_dry_run_expansion_required_count: {0}' -f (Count-Rows $recursiveRequiredRows))
$receipt += ('whole_house_clearance_count: {0}' -f (Count-Rows $wholeHouseClearanceRows))
$receipt += ('blocker_count: {0}' -f $blockers.Count)
if ($contractGatePassed) {
    $receipt += 'next_single_action: BUILD_HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION'
    $receipt += 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_WRITTEN_WITH_REVIEW_ONLY_HIGH_RISK_MARKERS_AND_RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_NO_PHYSICAL_ACTION'
} else {
    $receipt += 'next_single_action: STOP_AND_REVIEW_HSRB_006_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION'
    $receipt += 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
$receipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-TextNoBom -Path $OutputReceiptPath -Lines $receipt
$OutputReceiptSha = Get-Sha256Safe -Path $OutputReceiptPath

'=== STATIC REVIEW PACKET FOR BATCH HSRB-006 REMAINING HELPER REVIEW QUEUE FAMILY V0.1 COMPLETE ==='
"output_summary_csv_path: $OutputSummaryCsvPath"
"output_summary_csv_sha256: $OutputSummaryCsvSha"
"output_packet_md_path: $OutputPacketMdPath"
"output_packet_md_sha256: $OutputPacketMdSha"
"output_print_path: $OutputPrintPath"
"output_print_sha256: $OutputPrintSha"
"output_receipt_path: $OutputReceiptPath"
"output_receipt_sha256: $OutputReceiptSha"
("contract_gate_passed: {0}" -f $contractGatePassed)
'selected_batch_id: HSRB-006'
("selected_batch_rows: {0}" -f $selectedRowCount)
("summary_rows: {0}" -f (Count-Rows $summaryRows))
("blank_ticket_id_count: {0}" -f (Count-Rows $blankTicketRows))
("missing_filename_count: {0}" -f (Count-Rows $missingFileNameRows))
("missing_declared_sha256_count: {0}" -f (Count-Rows $missingDeclaredShaRows))
("missing_actual_sha256_count: {0}" -f (Count-Rows $missingActualShaRows))
("source_hash_mismatch_count: {0}" -f (Count-Rows $sourceHashMismatchRows))
("source_missing_count: {0}" -f (Count-Rows $sourceMissingRows))
("text_read_fail_count: {0}" -f (Count-Rows $textReadFailRows))
("unknown_static_disposition_count: {0}" -f (Count-Rows $unknownDispositionRows))
("contains_move_item_count: {0}" -f (Count-Rows $moveItemRows))
("contains_remove_item_count: {0}" -f (Count-Rows $removeItemRows))
("contains_rename_item_count: {0}" -f (Count-Rows $renameItemRows))
("contains_copy_item_count: {0}" -f (Count-Rows $copyItemRows))
("contains_start_process_count: {0}" -f (Count-Rows $startProcessRows))
("contains_invoke_expression_count: {0}" -f (Count-Rows $invokeExpressionRows))
("contains_git_command_count: {0}" -f (Count-Rows $gitCommandRows))
("contains_set_clipboard_count: {0}" -f (Count-Rows $setClipboardRows))
("high_risk_command_marker_row_count: {0}" -f (Count-Rows $highRiskRows))
("high_risk_review_only_marker_count: {0}" -f (Count-Rows $highRiskReviewOnlyRows))
("risk_marked_row_count: {0}" -f (Count-Rows $riskMarkedRows))
("unclassified_risk_marker_count: {0}" -f (Count-Rows $unclassifiedRiskRows))
("source_action_now_non_no_count: {0}" -f (Count-Rows $sourceActionNowNonNoRows))
("selector_action_now_non_no_count: {0}" -f (Count-Rows $selectorActionNowNonNoRows))
("action_now_non_no_count: {0}" -f (Count-Rows $actionNowNonNoRows))
("recursive_dry_run_expansion_required_count: {0}" -f (Count-Rows $recursiveRequiredRows))
("whole_house_clearance_count: {0}" -f (Count-Rows $wholeHouseClearanceRows))
("blocker_count: {0}" -f $blockers.Count)
if ($contractGatePassed) { 'next_single_action: BUILD_HSRB_006_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION' } else { 'next_single_action: STOP_AND_REVIEW_HSRB_006_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION' }
if ($contractGatePassed) { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_WRITTEN_WITH_REVIEW_ONLY_HIGH_RISK_MARKERS_AND_RECURSIVE_DRY_RUN_EXPANSION_REQUIRED_NO_PHYSICAL_ACTION' } else { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_006_REMAINING_HELPER_REVIEW_QUEUE_FAMILY_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
("physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}" -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
