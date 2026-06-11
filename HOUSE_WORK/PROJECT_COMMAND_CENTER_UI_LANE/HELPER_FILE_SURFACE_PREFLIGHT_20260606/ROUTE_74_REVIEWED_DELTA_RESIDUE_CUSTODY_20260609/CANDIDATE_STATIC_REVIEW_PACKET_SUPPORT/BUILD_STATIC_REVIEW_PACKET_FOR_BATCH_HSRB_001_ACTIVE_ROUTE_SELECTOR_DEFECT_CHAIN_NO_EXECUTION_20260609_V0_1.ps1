$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$LaneDir = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$BatchIndexCsvPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_BATCH_INDEX_V0_1_20260609.csv'
$SelectedBatchCsvPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_001_V0_1_20260609.csv'
$BatchSelectorMdPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$BatchSelectorPrintPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$BatchSelectorReceiptPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedBatchIndexCsvSha = 'A80FAFB2F6E8651AD1AF2F7F1C3816F312C2927762D6F07A2D69B14E75DAF570'
$ExpectedSelectedBatchCsvSha = '65458E9677C8A05180B3A2BCA3DEF1A7F548832C7DCB58E630DEC72033D27C66'
$ExpectedBatchSelectorMdSha = 'D2683053448A648174BCCEDA2F26341AB58B3E93B708342356F23B3EA915C350'
$ExpectedBatchSelectorPrintSha = '4F7211F4A8DFBDD311C137E816233F9F098E05A410312316BC3783854C8727D7'
$ExpectedBatchSelectorReceiptSha = '643E0D5AECB3797B09E5CCE0F8A487057FD8A6F18578D2E4C207B1FDE7B5BEE2'

$OutputSummaryCsvPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_SUMMARY_V0_1_20260609.csv'
$OutputPacketMdPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_1_20260609.md'
$OutputPrintPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function New-LineList {
    return [System.Collections.Generic.List[string]]::new()
}

function Add-Line {
    param(
        [System.Collections.Generic.List[string]] $List,
        [AllowNull()] $Text
    )
    $List.Add([string]$Text)
}

function Write-Utf8Lines {
    param(
        [string] $Path,
        [System.Collections.Generic.List[string]] $Lines
    )
    $Lines | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Count-Items {
    param([AllowNull()] $Value)
    return [int](@($Value).Count)
}

function Escape-MdCell {
    param([AllowNull()] $Value)
    $s = [string]$Value
    $s = $s.Replace('|','/')
    $s = $s.Replace("`r",' ')
    $s = $s.Replace("`n",' ')
    return $s
}

function Test-ExpectedHash {
    param(
        [string] $Name,
        [string] $Path,
        [string] $ExpectedSha
    )
    $exists = Test-Path -LiteralPath $Path
    $actual = ''
    $match = $false
    if ($exists) {
        $actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
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

function Get-KnownOutcome {
    param([string] $FileName)
    switch -Regex ($FileName) {
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609\.ps1$' { return 'FAILED_EARLIER_SCALAR_COUNT_STRICTMODE_OR_COUNT_SHAPE; SUPERSEDED_BY_V0_5' }
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_2\.ps1$' { return 'FAILED_EARLIER_STRICT_PARAM_BINDING_INPUT_SHAPE; SUPERSEDED_BY_V0_5' }
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_3\.ps1$' { return 'FAILED_EARLIER_UNESCAPED_WINDOWS_PATH_REGEX; SUPERSEDED_BY_V0_5' }
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_4\.ps1$' { return 'FAILED_EARLIER_ARGUMENT_TYPES_MISMATCH; SUPERSEDED_BY_V0_5' }
        '^BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_5\.ps1$' { return 'PASSED_CONSERVATIVE_LIVE_ROOT_BOARD_PARSER_REMOVED; PROOF_HELPER_ONLY' }
        default { return 'UNKNOWN_WITHIN_HSRB_001' }
    }
}

function Get-StaticDisposition {
    param([string] $FileName)
    if ($FileName -eq 'BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_5.ps1') {
        return 'KEEP_AS_LAST_PASSING_PROOF_HELPER_REVIEW_ONLY'
    }
    return 'HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN'
}

function Get-ReviewNote {
    param([string] $FileName)
    if ($FileName -eq 'BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_5.ps1') {
        return 'This is the conservative selector that removed the brittle route-plan parser and produced the V0.5 live-root board. It is not route authority.'
    }
    return 'Earlier generated selector version failed during live use and is superseded. Preserve as failure evidence only.'
}

function Get-TextMetricObject {
    param(
        [object] $BatchRow
    )

    $fileName = [string]$BatchRow.FileName
    $sourcePath = [string]$BatchRow.SourcePath
    $exists = Test-Path -LiteralPath $sourcePath
    $sha = ''
    $bytes = 0
    $lineCount = 0
    $containsMoveItem = $false
    $containsRemoveItem = $false
    $containsRenameItem = $false
    $containsStartProcess = $false
    $containsInvokeExpression = $false
    $containsSetClipboard = $false
    $containsExportCsv = $false
    $containsSetContent = $false
    $containsGetContent = $false
    $containsParserRemovedMarker = $false
    $containsExpectedHashMarker = $false
    $containsPhysicalZeroMarker = $false
    $textReadOk = $false
    $readError = ''

    if ($exists) {
        $item = Get-Item -LiteralPath $sourcePath
        $bytes = [int64]$item.Length
        $sha = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash
        try {
            $text = Get-Content -LiteralPath $sourcePath -Raw -ErrorAction Stop
            $textReadOk = $true
            $lineCount = [int](([regex]::Matches($text, "`n")).Count + 1)
            $containsMoveItem = [bool]($text -match '\bMove-Item\b')
            $containsRemoveItem = [bool]($text -match '\bRemove-Item\b')
            $containsRenameItem = [bool]($text -match '\bRename-Item\b')
            $containsStartProcess = [bool]($text -match '\bStart-Process\b')
            $containsInvokeExpression = [bool]($text -match '\bInvoke-Expression\b|\biex\b')
            $containsSetClipboard = [bool]($text -match '\bSet-Clipboard\b')
            $containsExportCsv = [bool]($text -match '\bExport-Csv\b')
            $containsSetContent = [bool]($text -match '\bSet-Content\b')
            $containsGetContent = [bool]($text -match '\bGet-Content\b')
            $containsParserRemovedMarker = [bool]($text -match 'PARSER_REMOVED|parser removed|route-plan parser|brittle route')
            $containsExpectedHashMarker = [bool]($text -match 'Expected.*Sha|Expected.*Hash|Expected[A-Za-z0-9_]*Sha')
            $containsPhysicalZeroMarker = [bool]($text -match 'physical_actions|PhysicalMoves|PhysicalExecutes')
        } catch {
            $readError = [string]$_.Exception.Message
        }
    }

    return [pscustomobject]@{
        BatchID = [string]$BatchRow.BatchID
        QueueID = [string]$BatchRow.QueueID
        SourceTicketID = [string]$BatchRow.SourceTicketID
        FileName = [string]$fileName
        SourcePath = [string]$sourcePath
        SourceExists = [bool]$exists
        SourceSha256 = [string]$sha
        SourceBytes = [int64]$bytes
        LineCount = [int]$lineCount
        TextReadOk = [bool]$textReadOk
        ReadError = [string]$readError
        KnownOutcome = [string](Get-KnownOutcome -FileName $fileName)
        StaticDisposition = [string](Get-StaticDisposition -FileName $fileName)
        ContainsMoveItem = [bool]$containsMoveItem
        ContainsRemoveItem = [bool]$containsRemoveItem
        ContainsRenameItem = [bool]$containsRenameItem
        ContainsStartProcess = [bool]$containsStartProcess
        ContainsInvokeExpression = [bool]$containsInvokeExpression
        ContainsSetClipboard = [bool]$containsSetClipboard
        ContainsExportCsv = [bool]$containsExportCsv
        ContainsSetContent = [bool]$containsSetContent
        ContainsGetContent = [bool]$containsGetContent
        ContainsParserRemovedMarker = [bool]$containsParserRemovedMarker
        ContainsExpectedHashMarker = [bool]$containsExpectedHashMarker
        ContainsPhysicalZeroMarker = [bool]$containsPhysicalZeroMarker
        ReviewNote = [string](Get-ReviewNote -FileName $fileName)
        ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
    }
}

$blockers = @()
$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'batch_index_csv' -Path $BatchIndexCsvPath -ExpectedSha $ExpectedBatchIndexCsvSha
$hashChecks += Test-ExpectedHash -Name 'selected_batch_csv' -Path $SelectedBatchCsvPath -ExpectedSha $ExpectedSelectedBatchCsvSha
$hashChecks += Test-ExpectedHash -Name 'batch_selector_md' -Path $BatchSelectorMdPath -ExpectedSha $ExpectedBatchSelectorMdSha
$hashChecks += Test-ExpectedHash -Name 'batch_selector_print' -Path $BatchSelectorPrintPath -ExpectedSha $ExpectedBatchSelectorPrintSha
$hashChecks += Test-ExpectedHash -Name 'batch_selector_receipt' -Path $BatchSelectorReceiptPath -ExpectedSha $ExpectedBatchSelectorReceiptSha

foreach ($h in $hashChecks) {
    if (-not $h.Exists) {
        $blockers += ('MISSING_{0}: {1}' -f $h.Name, $h.Path)
    } elseif (-not $h.HashMatch) {
        $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256)
    }
}

$selectedRows = @()
if ($blockers.Count -eq 0) {
    $selectedRows = @(Import-Csv -LiteralPath $SelectedBatchCsvPath)
}
$selectedRowCount = Count-Items $selectedRows
if (($blockers.Count -eq 0) -and ($selectedRowCount -ne 5)) {
    $blockers += ('UNEXPECTED_SELECTED_BATCH_ROW_COUNT: {0}' -f $selectedRowCount)
}

$wrongBatchRows = @()
if ($blockers.Count -eq 0) {
    $wrongBatchRows = @($selectedRows | Where-Object { $_.BatchID -ne 'HSRB-001' })
    if ((Count-Items $wrongBatchRows) -ne 0) {
        $blockers += ('UNEXPECTED_BATCH_ID_ROWS: {0}' -f (Count-Items $wrongBatchRows))
    }
}

$summaryRows = @()
if ($blockers.Count -eq 0) {
    foreach ($row in $selectedRows) {
        $summaryRows += Get-TextMetricObject -BatchRow $row
    }
}

$sourceMissingRows = @($summaryRows | Where-Object { -not $_.SourceExists })
$textReadFailRows = @($summaryRows | Where-Object { -not $_.TextReadOk })
$dispositionKeepRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'KEEP_AS_LAST_PASSING_PROOF_HELPER_REVIEW_ONLY' })
$dispositionHoldRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN' })
$moveItemRows = @($summaryRows | Where-Object { $_.ContainsMoveItem })
$removeItemRows = @($summaryRows | Where-Object { $_.ContainsRemoveItem })
$renameItemRows = @($summaryRows | Where-Object { $_.ContainsRenameItem })
$startProcessRows = @($summaryRows | Where-Object { $_.ContainsStartProcess })
$invokeExpressionRows = @($summaryRows | Where-Object { $_.ContainsInvokeExpression })

if (($blockers.Count -eq 0) -and ((Count-Items $sourceMissingRows) -ne 0)) {
    $blockers += ('SOURCE_MISSING_ROWS: {0}' -f (Count-Items $sourceMissingRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $textReadFailRows) -ne 0)) {
    $blockers += ('TEXT_READ_FAIL_ROWS: {0}' -f (Count-Items $textReadFailRows))
}

if ($blockers.Count -eq 0) {
    $summaryRows | Export-Csv -LiteralPath $OutputSummaryCsvPath -NoTypeInformation -Encoding UTF8
}

$packet = New-LineList
Add-Line $packet '# Static Review Packet - Batch HSRB-001 Active Route Selector Defect Chain - V0.1'
Add-Line $packet ''
Add-Line $packet 'Status: STATIC_REVIEW_PACKET / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $packet ''
Add-Line $packet '## Purpose'
Add-Line $packet ''
Add-Line $packet 'Review Batch HSRB-001 as static text only. This packet reads source script text for evidence, hashes, and review classification. It does not run any helper script.'
Add-Line $packet ''
Add-Line $packet '## Boundary'
Add-Line $packet ''
Add-Line $packet 'No selected script is executed. No root file is moved, deleted, renamed, routed, cleaned, committed, or pushed. The output is review evidence only.'
Add-Line $packet ''
Add-Line $packet '## Verified selector inputs'
Add-Line $packet ''
Add-Line $packet '| Input | Exists | HashMatch | SHA256 |'
Add-Line $packet '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) {
    Add-Line $packet ('| {0} | {1} | {2} | `{3}` |' -f $h.Name, $h.Exists, $h.HashMatch, $h.ActualSha256)
}
Add-Line $packet ''
Add-Line $packet '## Counts'
Add-Line $packet ''
Add-Line $packet ('- selected_batch_id: HSRB-001')
Add-Line $packet ('- selected_batch_rows: {0}' -f $selectedRowCount)
Add-Line $packet ('- summary_rows: {0}' -f (Count-Items $summaryRows))
Add-Line $packet ('- source_missing_count: {0}' -f (Count-Items $sourceMissingRows))
Add-Line $packet ('- text_read_fail_count: {0}' -f (Count-Items $textReadFailRows))
Add-Line $packet ('- keep_as_last_passing_proof_count: {0}' -f (Count-Items $dispositionKeepRows))
Add-Line $packet ('- hold_as_superseded_failed_count: {0}' -f (Count-Items $dispositionHoldRows))
Add-Line $packet ('- contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
Add-Line $packet ('- contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
Add-Line $packet ('- contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
Add-Line $packet ('- contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
Add-Line $packet ('- contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
Add-Line $packet ('- blocker_count: {0}' -f $blockers.Count)
Add-Line $packet ''
Add-Line $packet '## Static review table'
Add-Line $packet ''
Add-Line $packet '| QueueID | FileName | Lines | KnownOutcome | StaticDisposition | SHA256 |'
Add-Line $packet '| --- | --- | ---: | --- | --- | --- |'
foreach ($r in $summaryRows) {
    Add-Line $packet ('| {0} | `{1}` | {2} | {3} | {4} | `{5}` |' -f $r.QueueID, (Escape-MdCell $r.FileName), $r.LineCount, (Escape-MdCell $r.KnownOutcome), (Escape-MdCell $r.StaticDisposition), $r.SourceSha256)
}
Add-Line $packet ''
Add-Line $packet '## Static safety scan'
Add-Line $packet ''
Add-Line $packet '| FileName | Move-Item | Remove-Item | Rename-Item | Start-Process | Invoke-Expression | Set-Content | Export-Csv | Set-Clipboard |'
Add-Line $packet '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |'
foreach ($r in $summaryRows) {
    Add-Line $packet ('| `{0}` | {1} | {2} | {3} | {4} | {5} | {6} | {7} | {8} |' -f (Escape-MdCell $r.FileName), $r.ContainsMoveItem, $r.ContainsRemoveItem, $r.ContainsRenameItem, $r.ContainsStartProcess, $r.ContainsInvokeExpression, $r.ContainsSetContent, $r.ContainsExportCsv, $r.ContainsSetClipboard)
}
Add-Line $packet ''
Add-Line $packet '## Review notes'
Add-Line $packet ''
foreach ($r in $summaryRows) {
    Add-Line $packet ('### {0}' -f $r.FileName)
    Add-Line $packet ''
    Add-Line $packet ('- Known outcome: {0}' -f $r.KnownOutcome)
    Add-Line $packet ('- Static disposition: {0}' -f $r.StaticDisposition)
    Add-Line $packet ('- Review note: {0}' -f $r.ReviewNote)
    Add-Line $packet ('- Action now: {0}' -f $r.ActionNow)
    Add-Line $packet ''
}
Add-Line $packet '## Blockers'
Add-Line $packet ''
if ($blockers.Count -eq 0) {
    Add-Line $packet 'None.'
} else {
    foreach ($b in $blockers) { Add-Line $packet ('- {0}' -f $b) }
}
Add-Line $packet ''
Add-Line $packet '## DoesNotProve'
Add-Line $packet ''
Add-Line $packet 'This static packet does not prove any selected script is safe to execute, route-approved, cleanup-approved, source-authoritative, current doctrine, or ready to commit/push. It proves only that the selected batch was read as static text and classified for review.'
Add-Line $packet ''
Add-Line $packet '## Next single action'
Add-Line $packet ''
if ($blockers.Count -eq 0) {
    Add-Line $packet 'BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION'
    Add-Line $packet ''
    Add-Line $packet 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    Add-Line $packet 'REPAIR_STATIC_REVIEW_PACKET_BATCH_HSRB_001_INPUT_BLOCKERS_NO_EXECUTION'
    Add-Line $packet ''
    Add-Line $packet 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-Utf8Lines -Path $OutputPacketMdPath -Lines $packet

$print = New-LineList
Add-Line $print 'STATIC REVIEW PACKET - BATCH HSRB-001 ACTIVE ROUTE SELECTOR DEFECT CHAIN V0.1'
Add-Line $print 'Static read only. No execution. No route. No cleanup.'
Add-Line $print ''
Add-Line $print ('Selected batch rows: {0}' -f $selectedRowCount)
Add-Line $print ('Source missing count: {0}' -f (Count-Items $sourceMissingRows))
Add-Line $print ('Text read fail count: {0}' -f (Count-Items $textReadFailRows))
Add-Line $print ('Keep as last passing proof count: {0}' -f (Count-Items $dispositionKeepRows))
Add-Line $print ('Hold as superseded failed count: {0}' -f (Count-Items $dispositionHoldRows))
Add-Line $print ('Contains Move-Item count: {0}' -f (Count-Items $moveItemRows))
Add-Line $print ('Contains Remove-Item count: {0}' -f (Count-Items $removeItemRows))
Add-Line $print ('Contains Rename-Item count: {0}' -f (Count-Items $renameItemRows))
Add-Line $print ('Contains Start-Process count: {0}' -f (Count-Items $startProcessRows))
Add-Line $print ('Contains Invoke-Expression count: {0}' -f (Count-Items $invokeExpressionRows))
Add-Line $print ('Blocker count: {0}' -f $blockers.Count)
Add-Line $print ''
Add-Line $print 'ROWS:'
foreach ($r in $summaryRows) {
    Add-Line $print ('{0} | {1}' -f $r.QueueID, $r.FileName)
    Add-Line $print ('KnownOutcome: {0}' -f $r.KnownOutcome)
    Add-Line $print ('Disposition: {0}' -f $r.StaticDisposition)
    Add-Line $print ('SHA256: {0}' -f $r.SourceSha256)
    Add-Line $print '---'
}
Add-Line $print 'NEXT_SINGLE_ACTION:'
if ($blockers.Count -eq 0) {
    Add-Line $print 'BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION'
} else {
    Add-Line $print 'REPAIR_STATIC_REVIEW_PACKET_BATCH_HSRB_001_INPUT_BLOCKERS_NO_EXECUTION'
}
Write-Utf8Lines -Path $OutputPrintPath -Lines $print
if ($blockers.Count -eq 0) {
    Set-Clipboard -Value (($print.ToArray()) -join [Environment]::NewLine)
}

$OutputSummaryCsvSha = ''
if (Test-Path -LiteralPath $OutputSummaryCsvPath) { $OutputSummaryCsvSha = (Get-FileHash -LiteralPath $OutputSummaryCsvPath -Algorithm SHA256).Hash }
$OutputPacketMdSha = (Get-FileHash -LiteralPath $OutputPacketMdPath -Algorithm SHA256).Hash
$OutputPrintSha = (Get-FileHash -LiteralPath $OutputPrintPath -Algorithm SHA256).Hash

$receipt = New-LineList
Add-Line $receipt 'STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_RECEIPT_V0_1_20260609'
Add-Line $receipt ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
Add-Line $receipt ('input_selected_batch_csv_path: {0}' -f $SelectedBatchCsvPath)
Add-Line $receipt ('input_selected_batch_csv_expected_sha256: {0}' -f $ExpectedSelectedBatchCsvSha)
Add-Line $receipt ('output_summary_csv_path: {0}' -f $OutputSummaryCsvPath)
Add-Line $receipt ('output_summary_csv_sha256: {0}' -f $OutputSummaryCsvSha)
Add-Line $receipt ('output_packet_md_path: {0}' -f $OutputPacketMdPath)
Add-Line $receipt ('output_packet_md_sha256: {0}' -f $OutputPacketMdSha)
Add-Line $receipt ('output_print_path: {0}' -f $OutputPrintPath)
Add-Line $receipt ('output_print_sha256: {0}' -f $OutputPrintSha)
Add-Line $receipt ('selected_batch_id: HSRB-001')
Add-Line $receipt ('selected_batch_rows: {0}' -f $selectedRowCount)
Add-Line $receipt ('source_missing_count: {0}' -f (Count-Items $sourceMissingRows))
Add-Line $receipt ('text_read_fail_count: {0}' -f (Count-Items $textReadFailRows))
Add-Line $receipt ('keep_as_last_passing_proof_count: {0}' -f (Count-Items $dispositionKeepRows))
Add-Line $receipt ('hold_as_superseded_failed_count: {0}' -f (Count-Items $dispositionHoldRows))
Add-Line $receipt ('contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
Add-Line $receipt ('contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
Add-Line $receipt ('contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
Add-Line $receipt ('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
Add-Line $receipt ('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
Add-Line $receipt ('blocker_count: {0}' -f $blockers.Count)
Add-Line $receipt ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
if ($blockers.Count -eq 0) {
    Add-Line $receipt 'next_single_action: BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION'
    Add-Line $receipt 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    Add-Line $receipt 'next_single_action: REPAIR_STATIC_REVIEW_PACKET_BATCH_HSRB_001_INPUT_BLOCKERS_NO_EXECUTION'
    Add-Line $receipt 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-Utf8Lines -Path $OutputReceiptPath -Lines $receipt
$OutputReceiptSha = (Get-FileHash -LiteralPath $OutputReceiptPath -Algorithm SHA256).Hash

'=== STATIC REVIEW PACKET FOR BATCH HSRB-001 ACTIVE ROUTE SELECTOR DEFECT CHAIN V0.1 COMPLETE ==='
('output_summary_csv_path: {0}' -f $OutputSummaryCsvPath)
('output_summary_csv_sha256: {0}' -f $OutputSummaryCsvSha)
('output_packet_md_path: {0}' -f $OutputPacketMdPath)
('output_packet_md_sha256: {0}' -f $OutputPacketMdSha)
('output_print_path: {0}' -f $OutputPrintPath)
('output_print_sha256: {0}' -f $OutputPrintSha)
('output_receipt_path: {0}' -f $OutputReceiptPath)
('output_receipt_sha256: {0}' -f $OutputReceiptSha)
('selected_batch_id: HSRB-001')
('selected_batch_rows: {0}' -f $selectedRowCount)
('source_missing_count: {0}' -f (Count-Items $sourceMissingRows))
('text_read_fail_count: {0}' -f (Count-Items $textReadFailRows))
('keep_as_last_passing_proof_count: {0}' -f (Count-Items $dispositionKeepRows))
('hold_as_superseded_failed_count: {0}' -f (Count-Items $dispositionHoldRows))
('contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
('contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
('contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
('blocker_count: {0}' -f $blockers.Count)
if ($blockers.Count -eq 0) { 'next_single_action: BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION' } else { 'next_single_action: REPAIR_STATIC_REVIEW_PACKET_BATCH_HSRB_001_INPUT_BLOCKERS_NO_EXECUTION' }
if ($blockers.Count -eq 0) { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
