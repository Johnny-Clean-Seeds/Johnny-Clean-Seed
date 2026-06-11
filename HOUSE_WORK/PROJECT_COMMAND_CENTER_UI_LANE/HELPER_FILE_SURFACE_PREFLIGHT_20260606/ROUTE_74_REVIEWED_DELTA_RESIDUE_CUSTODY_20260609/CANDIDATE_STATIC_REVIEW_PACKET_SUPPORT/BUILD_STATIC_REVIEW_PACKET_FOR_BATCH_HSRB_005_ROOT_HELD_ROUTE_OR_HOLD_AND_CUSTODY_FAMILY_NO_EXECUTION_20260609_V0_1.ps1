Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$BatchId = 'HSRB-005'
$BatchName = 'ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY'
$Stamp = '20260609'

$SelectedBatchCsvPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_005_V0_2_20260609.csv'
$SelectorMdPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_V0_2_20260609.md'
$SelectorPrintPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$SelectorReceiptPath = Join-Path $Lane 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

$ExpectedSelectedBatchCsvSha = '2B27276D9B580AFDD883387BB755F2C5DC808B7C861A05C5160E7A0549316C13'
$ExpectedSelectorMdSha = '89152B0A51615FD6606FEE7B1CC27513EDC3D09FE242414A381920AF4291B8D5'
$ExpectedSelectorPrintSha = '89152B0A51615FD6606FEE7B1CC27513EDC3D09FE242414A381920AF4291B8D5'
$ExpectedSelectorReceiptSha = 'BC9BF014B380FBB9405D5D072A23EA2DF93731F78D6DD0100CC308A318806C9B'

$OutputSummaryCsvPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_SUMMARY_V0_1_20260609.csv'
$OutputPacketMdPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_20260609.md'
$OutputPrintPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $Lane 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_RECEIPT_V0_1_20260609.txt'

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
    foreach ($r in $Rows) {
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
    if ($f -match 'ROOT_HELD|ROOT_HELD_GROUP|HELD_GROUP|ROUTE_PLAN|ROUTE_DRY_RUN|ROOT_DROP') { return 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY_REVIEW_ONLY' }
    if ($f -match 'CUSTODY|ANCHOR|RECEIPT|HASH|LEDGER|PROOF|EVIDENCE|FREEZE|FIX_NOTE') { return 'CUSTODY_PROOF_OR_RECEIPT_FAMILY_REVIEW_ONLY' }
    if ($f -match 'QUEUE|SELECTOR|NEXT_BATCH|STATIC_REVIEW|DECISION_CLOSEOUT|CLOSEOUT') { return 'QUEUE_SELECTOR_OR_CLOSEOUT_FAMILY_REVIEW_ONLY' }
    if ($f -match 'HOLD|HELD|MANUAL_DECISION|USER_REVIEW|REVIEW_PACKET') { return 'HOLD_OR_USER_REVIEW_FAMILY_REVIEW_ONLY' }
    return 'GENERAL_HSRB_005_REVIEW_ONLY_BUCKET'
}

function Get-KnownOutcome {
    param([string]$FileName)
    $disp = Get-StaticDisposition -FileName $FileName
    switch ($disp) {
        'ROOT_HELD_ROUTE_OR_HOLD_FAMILY_REVIEW_ONLY' { return 'ROOT_HELD_ROUTE_OR_HOLD_CANDIDATE_EVIDENCE; REVIEW_ONLY' }
        'CUSTODY_PROOF_OR_RECEIPT_FAMILY_REVIEW_ONLY' { return 'CUSTODY_PROOF_RECEIPT_EVIDENCE; REVIEW_ONLY' }
        'QUEUE_SELECTOR_OR_CLOSEOUT_FAMILY_REVIEW_ONLY' { return 'QUEUE_SELECTOR_CLOSEOUT_EVIDENCE; REVIEW_ONLY' }
        'HOLD_OR_USER_REVIEW_FAMILY_REVIEW_ONLY' { return 'HOLD_OR_USER_REVIEW_EVIDENCE; REVIEW_ONLY' }
        default { return 'HSRB_005_GENERAL_REVIEW_ONLY_EVIDENCE' }
    }
}

function Get-ReviewNote {
    param([string]$FileName)
    $disp = Get-StaticDisposition -FileName $FileName
    switch ($disp) {
        'ROOT_HELD_ROUTE_OR_HOLD_FAMILY_REVIEW_ONLY' { return 'Root-held route, hold, or dry-run family item. Review as evidence only; it does not authorize movement or cleanup.' }
        'CUSTODY_PROOF_OR_RECEIPT_FAMILY_REVIEW_ONLY' { return 'Custody/proof/receipt family item. Preserves evidence or hashes; receipt is not an order.' }
        'QUEUE_SELECTOR_OR_CLOSEOUT_FAMILY_REVIEW_ONLY' { return 'Queue, selector, static packet, or closeout family item. Review as helper process evidence only.' }
        'HOLD_OR_USER_REVIEW_FAMILY_REVIEW_ONLY' { return 'Hold or user-review family item. Review as decision-surface evidence only; not action authority.' }
        default { return 'General HSRB-005 helper-surface evidence. Review only; no execution.' }
    }
}

function New-StaticMetricRow {
    param($BatchRow)
    $fileNameRaw = Get-Cell -Row $BatchRow -Names @('FileName','Filename','File','Name','SourceFileName','SourceName','ItemName')
    $fileName = [System.IO.Path]::GetFileName($fileNameRaw.Trim().Trim('"'))
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
        ReviewNote = [string](Get-ReviewNote -FileName $fileName)
        ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
    }
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) { throw "Lane folder not found: $Lane" }

$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'selected_batch_005_v0_2_csv' -Path $SelectedBatchCsvPath -ExpectedSha $ExpectedSelectedBatchCsvSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_005_selector_v0_2_md' -Path $SelectorMdPath -ExpectedSha $ExpectedSelectorMdSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_005_selector_v0_2_print' -Path $SelectorPrintPath -ExpectedSha $ExpectedSelectorPrintSha
$hashChecks += Test-ExpectedHash -Name 'hsrb_005_selector_v0_2_receipt' -Path $SelectorReceiptPath -ExpectedSha $ExpectedSelectorReceiptSha

$blockers = @()
foreach ($h in $hashChecks) {
    if (-not $h.Exists) { $blockers += ('MISSING_{0}: {1}' -f $h.Name, $h.Path) }
    elseif (-not $h.HashMatch) { $blockers += ('HASH_MISMATCH_{0}: expected {1} actual {2}' -f $h.Name, $h.ExpectedSha256, $h.ActualSha256) }
}

$selectedRows = @()
if ($blockers.Count -eq 0) {
    foreach ($row in (Import-Csv -LiteralPath $SelectedBatchCsvPath)) { $selectedRows += $row }
}
$selectedRowCount = Count-Rows $selectedRows
if (($blockers.Count -eq 0) -and ($selectedRowCount -ne 18)) { $blockers += ('UNEXPECTED_SELECTED_BATCH_ROW_COUNT: {0}' -f $selectedRowCount) }

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
$unknownDispositionRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'UNKNOWN_STATIC_DISPOSITION_REVIEW_REQUIRED' }
$moveItemRows = Select-Rows $summaryRows { param($x) $x.ContainsMoveItem }
$removeItemRows = Select-Rows $summaryRows { param($x) $x.ContainsRemoveItem }
$renameItemRows = Select-Rows $summaryRows { param($x) $x.ContainsRenameItem }
$copyItemRows = Select-Rows $summaryRows { param($x) $x.ContainsCopyItem }
$startProcessRows = Select-Rows $summaryRows { param($x) $x.ContainsStartProcess }
$invokeExpressionRows = Select-Rows $summaryRows { param($x) $x.ContainsInvokeExpression }
$gitCommandRows = Select-Rows $summaryRows { param($x) $x.ContainsGitCommand }
$setClipboardRows = Select-Rows $summaryRows { param($x) $x.ContainsSetClipboard }
$rootHeldRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'ROOT_HELD_ROUTE_OR_HOLD_FAMILY_REVIEW_ONLY' }
$custodyRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'CUSTODY_PROOF_OR_RECEIPT_FAMILY_REVIEW_ONLY' }
$queueSelectorRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'QUEUE_SELECTOR_OR_CLOSEOUT_FAMILY_REVIEW_ONLY' }
$holdReviewRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'HOLD_OR_USER_REVIEW_FAMILY_REVIEW_ONLY' }
$generalRows = Select-Rows $summaryRows { param($x) $x.StaticDisposition -eq 'GENERAL_HSRB_005_REVIEW_ONLY_BUCKET' }

if (($blockers.Count -eq 0) -and ((Count-Rows $blankTicketRows) -ne 0)) { $blockers += ('BLANK_TICKET_ID_ROWS: {0}' -f (Count-Rows $blankTicketRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $missingFileNameRows) -ne 0)) { $blockers += ('MISSING_FILENAME_ROWS: {0}' -f (Count-Rows $missingFileNameRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $missingDeclaredShaRows) -ne 0)) { $blockers += ('MISSING_DECLARED_SHA256_ROWS: {0}' -f (Count-Rows $missingDeclaredShaRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $missingActualShaRows) -ne 0)) { $blockers += ('MISSING_ACTUAL_SHA256_ROWS: {0}' -f (Count-Rows $missingActualShaRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $sourceHashMismatchRows) -ne 0)) { $blockers += ('SOURCE_HASH_MISMATCH_ROWS: {0}' -f (Count-Rows $sourceHashMismatchRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $sourceMissingRows) -ne 0)) { $blockers += ('SOURCE_MISSING_ROWS: {0}' -f (Count-Rows $sourceMissingRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $textReadFailRows) -ne 0)) { $blockers += ('TEXT_READ_FAIL_ROWS: {0}' -f (Count-Rows $textReadFailRows)) }
if (($blockers.Count -eq 0) -and ((Count-Rows $unknownDispositionRows) -ne 0)) { $blockers += ('UNKNOWN_STATIC_DISPOSITION_ROWS: {0}' -f (Count-Rows $unknownDispositionRows)) }

$contractGatePassed = ($blockers.Count -eq 0)
if ((Count-Rows $summaryRows) -gt 0) { $summaryRows | Export-Csv -LiteralPath $OutputSummaryCsvPath -NoTypeInformation -Encoding UTF8 }

$packet = @()
$packet += '# Static Review Packet - Batch HSRB-005 Root Held Route or Hold and Custody Family - V0.1'
$packet += ''
$packet += 'Status: STATIC_REVIEW_PACKET / CONTRACT_FIRST / POSSIBLE_UNDERLYING_DEFECT_WATCH / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$packet += ''
$packet += '## Purpose'
$packet += ''
$packet += 'Review Batch HSRB-005 as static text only after the repeated collection/list/array defect red-flag rule was triggered. This packet reads the root-held route-or-hold and custody-family helper files for TicketID custody, SHA custody, source existence, static disposition, and command markers. It does not run any selected helper script.'
$packet += ''
$packet += '## Boundary'
$packet += ''
$packet += 'No selected script is executed. No root file is moved, deleted, renamed, copied, routed, cleaned, committed, or pushed. This output is review evidence only. Repeated script defects remain evidence of a possible underlying helper-generation defect until the lane-level repair pattern proves stable across later batches.'
$packet += ''
$packet += '## Verified selector inputs'
$packet += ''
$packet += '| Input | Exists | HashMatch | SHA256 |'
$packet += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) { $packet += ('| {0} | {1} | {2} | `{3}` |' -f $h.Name, $h.Exists, $h.HashMatch, $h.ActualSha256) }
$packet += ''
$packet += '## Counts'
$packet += ''
$packet += '- selected_batch_id: HSRB-005'
$packet += ('- selected_batch_rows: {0}' -f $selectedRowCount)
$packet += ('- summary_rows: {0}' -f (Count-Rows $summaryRows))
$packet += ('- blank_ticket_id_count: {0}' -f (Count-Rows $blankTicketRows))
$packet += ('- missing_filename_count: {0}' -f (Count-Rows $missingFileNameRows))
$packet += ('- missing_declared_sha256_count: {0}' -f (Count-Rows $missingDeclaredShaRows))
$packet += ('- missing_actual_sha256_count: {0}' -f (Count-Rows $missingActualShaRows))
$packet += ('- source_hash_mismatch_count: {0}' -f (Count-Rows $sourceHashMismatchRows))
$packet += ('- source_missing_count: {0}' -f (Count-Rows $sourceMissingRows))
$packet += ('- text_read_fail_count: {0}' -f (Count-Rows $textReadFailRows))
$packet += ('- root_held_route_or_hold_family_count: {0}' -f (Count-Rows $rootHeldRows))
$packet += ('- custody_proof_or_receipt_family_count: {0}' -f (Count-Rows $custodyRows))
$packet += ('- queue_selector_or_closeout_family_count: {0}' -f (Count-Rows $queueSelectorRows))
$packet += ('- hold_or_user_review_family_count: {0}' -f (Count-Rows $holdReviewRows))
$packet += ('- general_review_only_bucket_count: {0}' -f (Count-Rows $generalRows))
$packet += ('- unknown_static_disposition_count: {0}' -f (Count-Rows $unknownDispositionRows))
$packet += ('- contains_move_item_count: {0}' -f (Count-Rows $moveItemRows))
$packet += ('- contains_remove_item_count: {0}' -f (Count-Rows $removeItemRows))
$packet += ('- contains_rename_item_count: {0}' -f (Count-Rows $renameItemRows))
$packet += ('- contains_copy_item_count: {0}' -f (Count-Rows $copyItemRows))
$packet += ('- contains_start_process_count: {0}' -f (Count-Rows $startProcessRows))
$packet += ('- contains_invoke_expression_count: {0}' -f (Count-Rows $invokeExpressionRows))
$packet += ('- contains_git_command_count: {0}' -f (Count-Rows $gitCommandRows))
$packet += ('- contains_set_clipboard_count: {0}' -f (Count-Rows $setClipboardRows))
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
    $packet += 'BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION'
    $packet += ''
    $packet += 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_WRITTEN_AFTER_COLLECTION_PATTERN_REPAIR_WITH_NO_PHYSICAL_ACTION'
} else {
    $packet += 'STOP_AND_REVIEW_HSRB_005_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION'
    $packet += ''
    $packet += 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}

Write-TextNoBom -Path $OutputPacketMdPath -Lines $packet
Write-TextNoBom -Path $OutputPrintPath -Lines $packet

$OutputSummaryCsvSha = Get-Sha256Safe -Path $OutputSummaryCsvPath
$OutputPacketMdSha = Get-Sha256Safe -Path $OutputPacketMdPath
$OutputPrintSha = Get-Sha256Safe -Path $OutputPrintPath

$receipt = @()
$receipt += 'STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_RECEIPT_V0_1_20260609'
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
$receipt += 'selected_batch_id: HSRB-005'
$receipt += ('selected_batch_rows: {0}' -f $selectedRowCount)
$receipt += ('summary_rows: {0}' -f (Count-Rows $summaryRows))
$receipt += ('blank_ticket_id_count: {0}' -f (Count-Rows $blankTicketRows))
$receipt += ('missing_filename_count: {0}' -f (Count-Rows $missingFileNameRows))
$receipt += ('missing_declared_sha256_count: {0}' -f (Count-Rows $missingDeclaredShaRows))
$receipt += ('missing_actual_sha256_count: {0}' -f (Count-Rows $missingActualShaRows))
$receipt += ('source_hash_mismatch_count: {0}' -f (Count-Rows $sourceHashMismatchRows))
$receipt += ('source_missing_count: {0}' -f (Count-Rows $sourceMissingRows))
$receipt += ('text_read_fail_count: {0}' -f (Count-Rows $textReadFailRows))
$receipt += ('root_held_route_or_hold_family_count: {0}' -f (Count-Rows $rootHeldRows))
$receipt += ('custody_proof_or_receipt_family_count: {0}' -f (Count-Rows $custodyRows))
$receipt += ('queue_selector_or_closeout_family_count: {0}' -f (Count-Rows $queueSelectorRows))
$receipt += ('hold_or_user_review_family_count: {0}' -f (Count-Rows $holdReviewRows))
$receipt += ('general_review_only_bucket_count: {0}' -f (Count-Rows $generalRows))
$receipt += ('unknown_static_disposition_count: {0}' -f (Count-Rows $unknownDispositionRows))
$receipt += ('contains_move_item_count: {0}' -f (Count-Rows $moveItemRows))
$receipt += ('contains_remove_item_count: {0}' -f (Count-Rows $removeItemRows))
$receipt += ('contains_rename_item_count: {0}' -f (Count-Rows $renameItemRows))
$receipt += ('contains_copy_item_count: {0}' -f (Count-Rows $copyItemRows))
$receipt += ('contains_start_process_count: {0}' -f (Count-Rows $startProcessRows))
$receipt += ('contains_invoke_expression_count: {0}' -f (Count-Rows $invokeExpressionRows))
$receipt += ('contains_git_command_count: {0}' -f (Count-Rows $gitCommandRows))
$receipt += ('contains_set_clipboard_count: {0}' -f (Count-Rows $setClipboardRows))
$receipt += ('blocker_count: {0}' -f $blockers.Count)
if ($contractGatePassed) {
    $receipt += 'next_single_action: BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION'
    $receipt += 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_WRITTEN_AFTER_COLLECTION_PATTERN_REPAIR_WITH_NO_PHYSICAL_ACTION'
} else {
    $receipt += 'next_single_action: STOP_AND_REVIEW_HSRB_005_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION'
    $receipt += 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
$receipt += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
Write-TextNoBom -Path $OutputReceiptPath -Lines $receipt
$OutputReceiptSha = Get-Sha256Safe -Path $OutputReceiptPath

'=== STATIC REVIEW PACKET FOR BATCH HSRB-005 ROOT HELD ROUTE OR HOLD AND CUSTODY FAMILY V0.1 COMPLETE ==='
"output_summary_csv_path: $OutputSummaryCsvPath"
"output_summary_csv_sha256: $OutputSummaryCsvSha"
"output_packet_md_path: $OutputPacketMdPath"
"output_packet_md_sha256: $OutputPacketMdSha"
"output_print_path: $OutputPrintPath"
"output_print_sha256: $OutputPrintSha"
"output_receipt_path: $OutputReceiptPath"
"output_receipt_sha256: $OutputReceiptSha"
("contract_gate_passed: {0}" -f $contractGatePassed)
'selected_batch_id: HSRB-005'
("selected_batch_rows: {0}" -f $selectedRowCount)
("summary_rows: {0}" -f (Count-Rows $summaryRows))
("blank_ticket_id_count: {0}" -f (Count-Rows $blankTicketRows))
("missing_filename_count: {0}" -f (Count-Rows $missingFileNameRows))
("missing_declared_sha256_count: {0}" -f (Count-Rows $missingDeclaredShaRows))
("missing_actual_sha256_count: {0}" -f (Count-Rows $missingActualShaRows))
("source_hash_mismatch_count: {0}" -f (Count-Rows $sourceHashMismatchRows))
("source_missing_count: {0}" -f (Count-Rows $sourceMissingRows))
("text_read_fail_count: {0}" -f (Count-Rows $textReadFailRows))
("root_held_route_or_hold_family_count: {0}" -f (Count-Rows $rootHeldRows))
("custody_proof_or_receipt_family_count: {0}" -f (Count-Rows $custodyRows))
("queue_selector_or_closeout_family_count: {0}" -f (Count-Rows $queueSelectorRows))
("hold_or_user_review_family_count: {0}" -f (Count-Rows $holdReviewRows))
("general_review_only_bucket_count: {0}" -f (Count-Rows $generalRows))
("unknown_static_disposition_count: {0}" -f (Count-Rows $unknownDispositionRows))
("contains_move_item_count: {0}" -f (Count-Rows $moveItemRows))
("contains_remove_item_count: {0}" -f (Count-Rows $removeItemRows))
("contains_rename_item_count: {0}" -f (Count-Rows $renameItemRows))
("contains_copy_item_count: {0}" -f (Count-Rows $copyItemRows))
("contains_start_process_count: {0}" -f (Count-Rows $startProcessRows))
("contains_invoke_expression_count: {0}" -f (Count-Rows $invokeExpressionRows))
("contains_git_command_count: {0}" -f (Count-Rows $gitCommandRows))
("contains_set_clipboard_count: {0}" -f (Count-Rows $setClipboardRows))
("blocker_count: {0}" -f $blockers.Count)
if ($contractGatePassed) { 'next_single_action: BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION' } else { 'next_single_action: STOP_AND_REVIEW_HSRB_005_STATIC_REVIEW_PACKET_BLOCKERS_NO_EXECUTION' }
if ($contractGatePassed) { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_WRITTEN_AFTER_COLLECTION_PATTERN_REPAIR_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_005_ROOT_HELD_ROUTE_OR_HOLD_AND_CUSTODY_FAMILY_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
("physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}" -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
