Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$BatchId = 'HSRB-004'
$BatchName = 'HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN'
$Stamp = '20260609'

$SelectedBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_004_V0_1_20260609.csv'
$SelectorMdPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$SelectorPrintPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedSelectedBatchCsvSha = 'CD5A144CFAB6A56FA37C3D83A3D63F70B18292D6DFF8D5AE8313C1F91A18C47D'
$ExpectedSelectorMdSha = 'DA9BC5A0CB426ADA37739073610796F8EA99E195676C69501219DD2B5B171BCE'
$ExpectedSelectorPrintSha = 'DA9BC5A0CB426ADA37739073610796F8EA99E195676C69501219DD2B5B171BCE'
$ExpectedSelectorReceiptSha = '647FCE8F77E02DBE0E79895B3312F71863442430C35994F53721B343BA85BB56'

$OutputSummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_SUMMARY_V0_1_20260609.csv'
$OutputPacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_20260609.md'
$OutputPrintPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Write-TextNoBom {
    param([Parameter(Mandatory=$true)][string]$Path, [AllowNull()][object]$Lines)
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
    switch -Regex ($FileName) {
        '^BUILD_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608\.ps1$' { return 'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_REVIEW_ONLY' }
        '^BUILD_PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608\.ps1$' { return 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_REVIEW_ONLY' }
        '^BUILD_PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608_HEAVY_BOUNDARY\.ps1$' { return 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY_REVIEW_ONLY' }
        default { return 'UNKNOWN_STATIC_DISPOSITION_REVIEW_REQUIRED' }
    }
}

function Get-KnownOutcome {
    param([string]$FileName)
    switch -Regex ($FileName) {
        'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD' { return 'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD; REVIEW_ONLY' }
        'HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR' { return 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR; REVIEW_ONLY' }
        'NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT' { return 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_HEAVY_BOUNDARY; REVIEW_ONLY' }
        default { return 'UNKNOWN_WITHIN_HSRB_004' }
    }
}

function Get-ReviewNote {
    param([string]$FileName)
    switch -Regex ($FileName) {
        'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD' { return 'Closeout-card builder for the helper file surface preflight lane. Review evidence only; does not close current work by itself.' }
        'HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR' { return 'Planetary gate closeout-or-next selector for helper file surface preflight. Selector evidence only; not route authority.' }
        'NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT' { return 'Planetary gate next-object selector with heavy boundary. Review as selector candidate evidence only; not doctrine and not execution authority.' }
        default { return 'Unknown HSRB-004 row. Review required; no execution.' }
    }
}

function New-StaticMetricRow {
    param($BatchRow)
    $fileName = Get-Cell -Row $BatchRow -Names @('FileName','Filename','File','Name','SourceFileName','SourceName','ItemName')
    $fileName = [System.IO.Path]::GetFileName($fileName.Trim().Trim('"'))
    $ticket = Get-Cell -Row $BatchRow -Names @('TicketID','TicketId','Ticket','SourceTicketID','QueueTicketID','ReviewTicketID','RowID','RowId','ID')
    $declaredSha = Get-Cell -Row $BatchRow -Names @('DeclaredSha256','DeclaredSHA256','SourceSha256','SourceSHA256','SHA256','Sha256','Hash','FileSHA256')
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
            $containsMoveItem = [bool]($text -match '\bMove-Item\b')
            $containsRemoveItem = [bool]($text -match '\bRemove-Item\b')
            $containsRenameItem = [bool]($text -match '\bRename-Item\b')
            $containsCopyItem = [bool]($text -match '\bCopy-Item\b')
            $containsStartProcess = [bool]($text -match '\bStart-Process\b')
            $containsInvokeExpression = [bool]($text -match '\bInvoke-Expression\b|\biex\b')
            $containsSetClipboard = [bool]($text -match '\bSet-Clipboard\b')
            $containsExportCsv = [bool]($text -match '\bExport-Csv\b')
            $containsSetContent = [bool]($text -match '\bSet-Content\b|\[System\.IO\.File\]::WriteAllLines|\[System\.IO\.File\]::WriteAllText')
            $containsGetContent = [bool]($text -match '\bGet-Content\b')
            $containsGetFileHash = [bool]($text -match '\bGet-FileHash\b')
            $containsGitCommand = [bool]($text -match '(^|[^A-Za-z0-9_])git(\s|\.|$)')
            $containsNoExecutionMarker = [bool]($text -match 'NO_EXECUTION|No execution|no execution|ExecutionAllowed')
            $containsPhysicalZeroMarker = [bool]($text -match 'physical_actions|PhysicalMoves|PhysicalExecutes|move=0 delete=0 rename=0')
        } catch {
            $readError = [string]$_.Exception.Message
        }
    }

    $declaredMatches = $false
    if ((-not [string]::IsNullOrWhiteSpace($declaredSha)) -and (-not [string]::IsNullOrWhiteSpace($actualSha))) {
        $declaredMatches = ($declaredSha.ToUpperInvariant() -eq $actualSha.ToUpperInvariant())
    }

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
        KnownOutcome = [string](Get-KnownOutcome -FileName $fileName)
        StaticDisposition = [string](Get-StaticDisposition -FileName $fileName)
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
        ReviewNote = [string](Get-ReviewNote -FileName $fileName)
        ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
    }
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }

$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'selected_batch_004_v0_1_csv' -Path $SelectedBatchCsvPath -ExpectedSha $ExpectedSelectedBatchCsvSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_004_selector_v0_1_md' -Path $SelectorMdPath -ExpectedSha $ExpectedSelectorMdSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_004_selector_v0_1_print' -Path $SelectorPrintPath -ExpectedSha $ExpectedSelectorPrintSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_004_selector_v0_1_receipt' -Path $SelectorReceiptPath -ExpectedSha $ExpectedSelectorReceiptSha

$blockers = @()
foreach ($h in $hashChecks) {
    if (-not $h.Exists) { $blockers += ('MISSING_{0}: {1}' -f $h.Name, $h.Path) }
    elseif (-not $h.HashMatch) { $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256) }
}

$selectedRows = @()
if ($blockers.Count -eq 0) { $selectedRows = @(Import-Csv -LiteralPath $SelectedBatchCsvPath) }
$selectedRowCount = Count-Items $selectedRows
if (($blockers.Count -eq 0) -and ($selectedRowCount -ne 3)) { $blockers += ('UNEXPECTED_SELECTED_BATCH_ROW_COUNT: {0}' -f $selectedRowCount) }

$summaryRows = @()
if ($blockers.Count -eq 0) {
    foreach ($row in $selectedRows) { $summaryRows += New-StaticMetricRow -BatchRow $row }
}

$sourceMissingRows = @($summaryRows | Where-Object { -not $_.SourceExists })
$textReadFailRows = @($summaryRows | Where-Object { -not $_.TextReadOk })
$blankTicketRows = @($summaryRows | Where-Object { [string]::IsNullOrWhiteSpace([string]$_.TicketID) })
$missingFileNameRows = @($summaryRows | Where-Object { [string]::IsNullOrWhiteSpace([string]$_.FileName) })
$missingDeclaredShaRows = @($summaryRows | Where-Object { [string]::IsNullOrWhiteSpace([string]$_.DeclaredSha256) })
$missingActualShaRows = @($summaryRows | Where-Object { [string]::IsNullOrWhiteSpace([string]$_.SourceSha256) })
$sourceHashMismatchRows = @($summaryRows | Where-Object { -not $_.DeclaredShaMatchesActual })
$unknownDispositionRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'UNKNOWN_STATIC_DISPOSITION_REVIEW_REQUIRED' })
$moveItemRows = @($summaryRows | Where-Object { $_.ContainsMoveItem })
$removeItemRows = @($summaryRows | Where-Object { $_.ContainsRemoveItem })
$renameItemRows = @($summaryRows | Where-Object { $_.ContainsRenameItem })
$copyItemRows = @($summaryRows | Where-Object { $_.ContainsCopyItem })
$startProcessRows = @($summaryRows | Where-Object { $_.ContainsStartProcess })
$invokeExpressionRows = @($summaryRows | Where-Object { $_.ContainsInvokeExpression })
$gitCommandRows = @($summaryRows | Where-Object { $_.ContainsGitCommand })
$setClipboardRows = @($summaryRows | Where-Object { $_.ContainsSetClipboard })

$laneCloseoutRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_REVIEW_ONLY' })
$planetaryCloseoutRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_REVIEW_ONLY' })
$planetaryNextSelectorRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY_REVIEW_ONLY' })

if (($blockers.Count -eq 0) -and ((Count-Items $blankTicketRows) -ne 0)) { $blockers += ('BLANK_TICKET_ID_ROWS: {0}' -f (Count-Items $blankTicketRows)) }
if (($blockers.Count -eq 0) -and ((Count-Items $missingFileNameRows) -ne 0)) { $blockers += ('MISSING_FILENAME_ROWS: {0}' -f (Count-Items $missingFileNameRows)) }
if (($blockers.Count -eq 0) -and ((Count-Items $missingDeclaredShaRows) -ne 0)) { $blockers += ('MISSING_DECLARED_SHA256_ROWS: {0}' -f (Count-Items $missingDeclaredShaRows)) }
if (($blockers.Count -eq 0) -and ((Count-Items $missingActualShaRows) -ne 0)) { $blockers += ('MISSING_ACTUAL_SHA256_ROWS: {0}' -f (Count-Items $missingActualShaRows)) }
if (($blockers.Count -eq 0) -and ((Count-Items $sourceHashMismatchRows) -ne 0)) { $blockers += ('SOURCE_HASH_MISMATCH_ROWS: {0}' -f (Count-Items $sourceHashMismatchRows)) }
if (($blockers.Count -eq 0) -and ((Count-Items $sourceMissingRows) -ne 0)) { $blockers += ('SOURCE_MISSING_ROWS: {0}' -f (Count-Items $sourceMissingRows)) }
if (($blockers.Count -eq 0) -and ((Count-Items $textReadFailRows) -ne 0)) { $blockers += ('TEXT_READ_FAIL_ROWS: {0}' -f (Count-Items $textReadFailRows)) }
if (($blockers.Count -eq 0) -and ((Count-Items $unknownDispositionRows) -ne 0)) { $blockers += ('UNKNOWN_STATIC_DISPOSITION_ROWS: {0}' -f (Count-Items $unknownDispositionRows)) }

$contractGatePassed = ($blockers.Count -eq 0)
if ($summaryRows.Count -gt 0) { $summaryRows | Export-Csv -LiteralPath $OutputSummaryCsvPath -NoTypeInformation -Encoding UTF8 }

$packet = @()
$packet += '# Static Review Packet - Batch HSRB-004 Helper File Surface Preflight and Planetary Gate Selector Chain - V0.1'
$packet += ''
$packet += 'Status: STATIC_REVIEW_PACKET / CONTRACT_FIRST / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$packet += ''
$packet += '## Purpose'
$packet += ''
$packet += 'Review Batch HSRB-004 as static text only. This packet reads the helper file surface preflight and planetary gate selector helper scripts for TicketID custody, SHA custody, source existence, static disposition, and command markers. It does not run any selected helper script.'
$packet += ''
$packet += '## Boundary'
$packet += ''
$packet += 'No selected script is executed. No root file is moved, deleted, renamed, copied, routed, cleaned, committed, or pushed. This output is review evidence only.'
$packet += ''
$packet += '## Verified selector inputs'
$packet += ''
$packet += '| Input | Exists | HashMatch | SHA256 |'
$packet += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) { $packet += ('| {0} | {1} | {2} | `{3}` |' -f $h.Name, $h.Exists, $h.HashMatch, $h.ActualSha256) }
$packet += ''
$packet += '## Counts'
$packet += ''
$packet += '- selected_batch_id: HSRB-004'
$packet += ('- selected_batch_rows: {0}' -f $selectedRowCount)
$packet += ('- summary_rows: {0}' -f (Count-Items $summaryRows))
$packet += ('- blank_ticket_id_count: {0}' -f (Count-Items $blankTicketRows))
$packet += ('- missing_filename_count: {0}' -f (Count-Items $missingFileNameRows))
$packet += ('- missing_declared_sha256_count: {0}' -f (Count-Items $missingDeclaredShaRows))
$packet += ('- missing_actual_sha256_count: {0}' -f (Count-Items $missingActualShaRows))
$packet += ('- source_hash_mismatch_count: {0}' -f (Count-Items $sourceHashMismatchRows))
$packet += ('- source_missing_count: {0}' -f (Count-Items $sourceMissingRows))
$packet += ('- text_read_fail_count: {0}' -f (Count-Items $textReadFailRows))
$packet += ('- helper_file_surface_preflight_lane_closeout_card_count: {0}' -f (Count-Items $laneCloseoutRows))
$packet += ('- planetary_gate_helper_file_surface_preflight_closeout_or_next_selector_count: {0}' -f (Count-Items $planetaryCloseoutRows))
$packet += ('- planetary_gate_next_object_selector_heavy_boundary_count: {0}' -f (Count-Items $planetaryNextSelectorRows))
$packet += ('- unknown_static_disposition_count: {0}' -f (Count-Items $unknownDispositionRows))
$packet += ('- contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
$packet += ('- contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
$packet += ('- contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
$packet += ('- contains_copy_item_count: {0}' -f (Count-Items $copyItemRows))
$packet += ('- contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
$packet += ('- contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
$packet += ('- contains_git_command_count: {0}' -f (Count-Items $gitCommandRows))
$packet += ('- contains_set_clipboard_count: {0}' -f (Count-Items $setClipboardRows))
$packet += ('- blocker_count: {0}' -f $blockers.Count)
$packet += ''
$packet += '## Static review table'
$packet += ''
$packet += '| TicketID | FileName | Lines | KnownOutcome | StaticDisposition | DeclaredSHA256 | ActualSHA256 | HashMatch |'
$packet += '| --- | --- | ---: | --- | --- | --- | --- | ---: |'
foreach ($r in $summaryRows) {
    $packet += ('| {0} | `{1}` | {2} | {3} | {4} | `{5}` | `{6}` | {7} |' -f $r.TicketID, (Escape-MdCell $r.FileName), $r.LineCount, (Escape-MdCell $r.KnownOutcome), (Escape-MdCell $r.StaticDisposition), $r.DeclaredSha256, $r.SourceSha256, $r.DeclaredShaMatchesActual)
}
$packet += ''
$packet += '## Static safety scan'
$packet += ''
$packet += '| FileName | Move-Item | Remove-Item | Rename-Item | Copy-Item | Start-Process | Invoke-Expression | GitCommand | Set-Clipboard | Set-Content | Export-Csv |'
$packet += '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |'
foreach ($r in $summaryRows) {
    $packet += ('| `{0}` | {1} | {2} | {3} | {4} | {5} | {6} | {7} | {8} | {9} | {10} |' -f (Escape-MdCell $r.FileName), $r.ContainsMoveItem, $r.ContainsRemoveItem, $r.ContainsRenameItem, $r.ContainsCopyItem, $r.ContainsStartProcess, $r.ContainsInvokeExpression, $r.ContainsGitCommand, $r.ContainsSetClipboard, $r.ContainsSetContent, $r.ContainsExportCsv)
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
    $packet += ('- Review note: {0}' -f $r.ReviewNote)
    $packet += ('- Action now: {0}' -f $r.ActionNow)
    $packet += ''
}
$packet += '## Blockers'
$packet += ''
if ($blockers.Count -eq 0) { $packet += 'None.' } else { foreach ($b in $blockers) { $packet += ('- {0}' -f $b) } }
$packet += ''
$packet += '## DoesNotProve'
$packet += ''
$packet += 'This static packet does not prove any selected script is safe to execute, route-approved, cleanup-approved, source-authoritative, current doctrine, or ready to commit/push. It proves only that the selected batch was read as static text and classified for review.'
$packet += ''
$packet += '## Next single action'
$packet += ''
if ($contractGatePassed) {
    $packet += 'BUILD_HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION'
    $packet += ''
    $packet += 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $packet += 'STOP_AND_REVIEW_HSRB_004_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION'
    $packet += ''
    $packet += 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}

Write-TextNoBom -Path $OutputPacketMdPath -Lines $packet
Write-TextNoBom -Path $OutputPrintPath -Lines $packet

$OutputSummaryCsvSha = Get-Sha256Safe -Path $OutputSummaryCsvPath
$OutputPacketMdSha = Get-Sha256Safe -Path $OutputPacketMdPath
$OutputPrintSha = Get-Sha256Safe -Path $OutputPrintPath

$receipt = @()
$receipt += 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_RECEIPT_V0_1_20260609'
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
$receipt += 'selected_batch_id: HSRB-004'
$receipt += ('selected_batch_rows: {0}' -f $selectedRowCount)
$receipt += ('summary_rows: {0}' -f (Count-Items $summaryRows))
$receipt += ('blank_ticket_id_count: {0}' -f (Count-Items $blankTicketRows))
$receipt += ('missing_filename_count: {0}' -f (Count-Items $missingFileNameRows))
$receipt += ('missing_declared_sha256_count: {0}' -f (Count-Items $missingDeclaredShaRows))
$receipt += ('missing_actual_sha256_count: {0}' -f (Count-Items $missingActualShaRows))
$receipt += ('source_hash_mismatch_count: {0}' -f (Count-Items $sourceHashMismatchRows))
$receipt += ('source_missing_count: {0}' -f (Count-Items $sourceMissingRows))
$receipt += ('text_read_fail_count: {0}' -f (Count-Items $textReadFailRows))
$receipt += ('unknown_static_disposition_count: {0}' -f (Count-Items $unknownDispositionRows))
$receipt += ('contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
$receipt += ('contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
$receipt += ('contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
$receipt += ('contains_copy_item_count: {0}' -f (Count-Items $copyItemRows))
$receipt += ('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
$receipt += ('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
$receipt += ('contains_git_command_count: {0}' -f (Count-Items $gitCommandRows))
$receipt += ('contains_set_clipboard_count: {0}' -f (Count-Items $setClipboardRows))
$receipt += ('blocker_count: {0}' -f $blockers.Count)
if ($contractGatePassed) {
    $receipt += 'next_single_action: BUILD_HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION'
    $receipt += 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $receipt += 'next_single_action: STOP_AND_REVIEW_HSRB_004_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION'
    $receipt += 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
$receipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-TextNoBom -Path $OutputReceiptPath -Lines $receipt
$OutputReceiptSha = Get-Sha256Safe -Path $OutputReceiptPath

'=== STATIC REVIEW PACKET FOR BATCH HSRB-004 HELPER FILE SURFACE PREFLIGHT AND PLANETARY GATE SELECTOR CHAIN V0.1 COMPLETE ==='
"output_summary_csv_path: $OutputSummaryCsvPath"
"output_summary_csv_sha256: $OutputSummaryCsvSha"
"output_packet_md_path: $OutputPacketMdPath"
"output_packet_md_sha256: $OutputPacketMdSha"
"output_print_path: $OutputPrintPath"
"output_print_sha256: $OutputPrintSha"
"output_receipt_path: $OutputReceiptPath"
"output_receipt_sha256: $OutputReceiptSha"
("contract_gate_passed: {0}" -f $contractGatePassed)
'selected_batch_id: HSRB-004'
("selected_batch_rows: {0}" -f $selectedRowCount)
("summary_rows: {0}" -f (Count-Items $summaryRows))
("blank_ticket_id_count: {0}" -f (Count-Items $blankTicketRows))
("missing_filename_count: {0}" -f (Count-Items $missingFileNameRows))
("missing_declared_sha256_count: {0}" -f (Count-Items $missingDeclaredShaRows))
("missing_actual_sha256_count: {0}" -f (Count-Items $missingActualShaRows))
("source_hash_mismatch_count: {0}" -f (Count-Items $sourceHashMismatchRows))
("source_missing_count: {0}" -f (Count-Items $sourceMissingRows))
("text_read_fail_count: {0}" -f (Count-Items $textReadFailRows))
("helper_file_surface_preflight_lane_closeout_card_count: {0}" -f (Count-Items $laneCloseoutRows))
("planetary_gate_helper_file_surface_preflight_closeout_or_next_selector_count: {0}" -f (Count-Items $planetaryCloseoutRows))
("planetary_gate_next_object_selector_heavy_boundary_count: {0}" -f (Count-Items $planetaryNextSelectorRows))
("unknown_static_disposition_count: {0}" -f (Count-Items $unknownDispositionRows))
("contains_move_item_count: {0}" -f (Count-Items $moveItemRows))
("contains_remove_item_count: {0}" -f (Count-Items $removeItemRows))
("contains_rename_item_count: {0}" -f (Count-Items $renameItemRows))
("contains_copy_item_count: {0}" -f (Count-Items $copyItemRows))
("contains_start_process_count: {0}" -f (Count-Items $startProcessRows))
("contains_invoke_expression_count: {0}" -f (Count-Items $invokeExpressionRows))
("contains_git_command_count: {0}" -f (Count-Items $gitCommandRows))
("contains_set_clipboard_count: {0}" -f (Count-Items $setClipboardRows))
("blocker_count: {0}" -f $blockers.Count)
if ($contractGatePassed) { 'next_single_action: BUILD_HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION' } else { 'next_single_action: STOP_AND_REVIEW_HSRB_004_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION' }
if ($contractGatePassed) { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
("physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}" -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
