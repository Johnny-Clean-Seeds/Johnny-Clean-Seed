$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$LaneDir = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$SelectedBatchCsvPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_002_V0_1_20260609.csv'
$BatchSelectorMdPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'
$BatchSelectorPrintPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_COPY_PRINT_V0_1_20260609.txt'
$BatchSelectorReceiptPath = Join-Path $LaneDir 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'

$ExpectedSelectedBatchCsvSha = 'EF7A0005819154A621E2C8CEC0F8D371F58833F82D1B1615C056AF8C6AEE1BA6'
$ExpectedBatchSelectorMdSha = '8F699BC033325F61E8C389A5792D25855EECA21CC29E79C2B92734939A754140'
$ExpectedBatchSelectorPrintSha = '4C3D6933E3D1323B11100F473E03313EE14FCC13D6A65E25A6A5D99F0935E007'
$ExpectedBatchSelectorReceiptSha = 'ECA7FF93C1D3D8DD20C22A1003CFDAD5BA3FE5CB0A1AD1D26CC9F9461E5C3137'

$OutputSummaryCsvPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_SUMMARY_V0_1_20260609.csv'
$OutputPacketMdPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_20260609.md'
$OutputPrintPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_COPY_PRINT_V0_1_20260609.txt'
$OutputReceiptPath = Join-Path $LaneDir 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_RECEIPT_V0_1_20260609.txt'

$PhysicalMoves = 0
$PhysicalDeletes = 0
$PhysicalRenames = 0
$PhysicalRoutes = 0
$PhysicalExecutes = 0
$PhysicalCommits = 0
$PhysicalPushes = 0

function Get-Sha256Text {
    param([string] $Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Write-Utf8NoBomLines {
    param(
        [string] $Path,
        [string[]] $Lines
    )
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($Path, $Lines, $utf8NoBom)
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

function Get-FirstPropertyValue {
    param(
        [object] $Row,
        [string[]] $Names
    )
    foreach ($name in $Names) {
        if ($Row.PSObject.Properties.Name -contains $name) {
            return [string]$Row.$name
        }
    }
    return ''
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
        $actual = Get-Sha256Text -Path $Path
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
    param([string] $FileName)
    switch -Regex ($FileName) {
        '^BUILD_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608\.ps1$' { return 'REVIEW_AS_TEMPLATE_RULE_CARD_NOT_EXECUTION_AUTHORITY' }
        '^FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD(_V0_2|_V0_3)?_20260608\.ps1$' { return 'HOLD_AS_FIELD_APPLY_ATTEMPT_REVIEW_ONLY' }
        '^FREEZE_GENERATED_RUNNER_DEEP_LAYER_AND_WRITE_SAFE_GIT_RUNNER_20260608\.ps1$' { return 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }
        '^FREEZE_GIT_SNAPSHOT_NO_WORKTREE_AND_WRITE_FIXED_RUNNER_20260608\.ps1$' { return 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' }
        default { return 'UNKNOWN_STATIC_DISPOSITION_REVIEW_REQUIRED' }
    }
}

function Get-KnownOutcome {
    param([string] $FileName)
    switch -Regex ($FileName) {
        '^BUILD_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608\.ps1$' { return 'GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CANDIDATE; REVIEW_ONLY' }
        '^FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608\.ps1$' { return 'FIELD_APPLY_TEMPLATE_RULE_CARD_ATTEMPT; REVIEW_ONLY' }
        '^FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_V0_2_20260608\.ps1$' { return 'FIELD_APPLY_TEMPLATE_RULE_CARD_V0_2_ATTEMPT; REVIEW_ONLY' }
        '^FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_V0_3_20260608\.ps1$' { return 'FIELD_APPLY_TEMPLATE_RULE_CARD_V0_3_ATTEMPT; REVIEW_ONLY' }
        '^FREEZE_GENERATED_RUNNER_DEEP_LAYER_AND_WRITE_SAFE_GIT_RUNNER_20260608\.ps1$' { return 'FREEZE_GENERATED_RUNNER_DEEP_LAYER_AND_WRITE_SAFE_GIT_RUNNER_ATTEMPT; REVIEW_ONLY' }
        '^FREEZE_GIT_SNAPSHOT_NO_WORKTREE_AND_WRITE_FIXED_RUNNER_20260608\.ps1$' { return 'FREEZE_GIT_SNAPSHOT_NO_WORKTREE_AND_WRITE_FIXED_RUNNER_ATTEMPT; REVIEW_ONLY' }
        default { return 'UNKNOWN_WITHIN_HSRB_002' }
    }
}

function Get-ReviewNote {
    param([string] $FileName)
    switch -Regex ($FileName) {
        '^BUILD_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608\.ps1$' { return 'Template-rule candidate for safer generated runners. Static review only; not promoted as doctrine and not execution authority.' }
        '^FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD' { return 'Field-apply attempt in the generated-runner safe-template chain. Preserve as review evidence only until separately judged.' }
        '^FREEZE_' { return 'Freeze/repair helper in the generated-runner defect family. Preserve as review evidence only; do not execute from this packet.' }
        default { return 'Unknown HSRB-002 row. Review required; no execution.' }
    }
}

function New-StaticMetricRow {
    param([object] $BatchRow)

    $fileName = Get-FirstPropertyValue -Row $BatchRow -Names @('FileName','Filename','File')
    $ticket = Get-FirstPropertyValue -Row $BatchRow -Names @('TicketID','TicketId','Ticket','SourceTicketID')
    $role = Get-FirstPropertyValue -Row $BatchRow -Names @('RoleLabel','Role')
    $risk = Get-FirstPropertyValue -Row $BatchRow -Names @('RiskLabel','Risk')
    $sourcePath = Get-FirstPropertyValue -Row $BatchRow -Names @('SourcePath','Path')
    if ([string]::IsNullOrWhiteSpace($sourcePath)) { $sourcePath = Join-Path $ProjectRoot $fileName }

    $exists = Test-Path -LiteralPath $sourcePath
    $sha = ''
    $bytes = 0
    $lineCount = 0
    $textReadOk = $false
    $readError = ''
    $containsMoveItem = $false
    $containsRemoveItem = $false
    $containsRenameItem = $false
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
    $containsSafeTemplateMarker = $false
    $containsFreezeMarker = $false

    if ($exists) {
        $item = Get-Item -LiteralPath $sourcePath
        $bytes = [int64]$item.Length
        $sha = Get-Sha256Text -Path $sourcePath
        try {
            $text = Get-Content -LiteralPath $sourcePath -Raw -ErrorAction Stop
            $textReadOk = $true
            if ([string]::IsNullOrEmpty($text)) { $lineCount = 0 } else { $lineCount = [int](([regex]::Matches($text, "`n")).Count + 1) }
            $containsMoveItem = [bool]($text -match '\bMove-Item\b')
            $containsRemoveItem = [bool]($text -match '\bRemove-Item\b')
            $containsRenameItem = [bool]($text -match '\bRename-Item\b')
            $containsStartProcess = [bool]($text -match '\bStart-Process\b')
            $containsInvokeExpression = [bool]($text -match '\bInvoke-Expression\b|\biex\b')
            $containsSetClipboard = [bool]($text -match '\bSet-Clipboard\b')
            $containsExportCsv = [bool]($text -match '\bExport-Csv\b')
            $containsSetContent = [bool]($text -match '\bSet-Content\b|\[System\.IO\.File\]::WriteAllLines')
            $containsGetContent = [bool]($text -match '\bGet-Content\b')
            $containsGetFileHash = [bool]($text -match '\bGet-FileHash\b')
            $containsGitCommand = [bool]($text -match '(^|[^A-Za-z0-9_])git(\s|\.|$)')
            $containsNoExecutionMarker = [bool]($text -match 'NO_EXECUTION|No execution|no execution|ExecutionAllowed')
            $containsPhysicalZeroMarker = [bool]($text -match 'physical_actions|PhysicalMoves|PhysicalExecutes|move=0 delete=0 rename=0')
            $containsSafeTemplateMarker = [bool]($text -match 'SAFE_TEMPLATE|safe template|safe-template|generated runner')
            $containsFreezeMarker = [bool]($text -match 'FREEZE|Freeze|freeze')
        } catch {
            $readError = [string]$_.Exception.Message
        }
    }

    return [pscustomobject]@{
        BatchID = [string](Get-FirstPropertyValue -Row $BatchRow -Names @('BatchID','BatchId'))
        TicketID = [string]$ticket
        FileName = [string]$fileName
        RoleLabel = [string]$role
        RiskLabel = [string]$risk
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
        ContainsGetFileHash = [bool]$containsGetFileHash
        ContainsGitCommand = [bool]$containsGitCommand
        ContainsNoExecutionMarker = [bool]$containsNoExecutionMarker
        ContainsPhysicalZeroMarker = [bool]$containsPhysicalZeroMarker
        ContainsSafeTemplateMarker = [bool]$containsSafeTemplateMarker
        ContainsFreezeMarker = [bool]$containsFreezeMarker
        ReviewNote = [string](Get-ReviewNote -FileName $fileName)
        ActionNow = 'NO_EXECUTION_NO_ROUTE_NO_CLEANUP'
    }
}

if (-not (Test-Path -LiteralPath $LaneDir)) {
    throw "Output lane directory does not exist: $LaneDir"
}

$blockers = @()
$hashChecks = @()
$hashChecks += Test-ExpectedHash -Name 'selected_batch_002_csv' -Path $SelectedBatchCsvPath -ExpectedSha $ExpectedSelectedBatchCsvSha
$hashChecks += Test-ExpectedHash -Name 'next_batch_selector_md' -Path $BatchSelectorMdPath -ExpectedSha $ExpectedBatchSelectorMdSha
$hashChecks += Test-ExpectedHash -Name 'next_batch_selector_print' -Path $BatchSelectorPrintPath -ExpectedSha $ExpectedBatchSelectorPrintSha
$hashChecks += Test-ExpectedHash -Name 'next_batch_selector_receipt' -Path $BatchSelectorReceiptPath -ExpectedSha $ExpectedBatchSelectorReceiptSha

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
if (($blockers.Count -eq 0) -and ($selectedRowCount -ne 6)) {
    $blockers += ('UNEXPECTED_SELECTED_BATCH_ROW_COUNT: {0}' -f $selectedRowCount)
}

$wrongBatchRows = @()
if ($blockers.Count -eq 0) {
    $wrongBatchRows = @($selectedRows | Where-Object { $_.BatchID -ne 'HSRB-002' })
    if ((Count-Items $wrongBatchRows) -ne 0) {
        $blockers += ('UNEXPECTED_BATCH_ID_ROWS: {0}' -f (Count-Items $wrongBatchRows))
    }
}

$summaryRows = @()
if ($blockers.Count -eq 0) {
    foreach ($row in $selectedRows) {
        $summaryRows += New-StaticMetricRow -BatchRow $row
    }
}

$sourceMissingRows = @($summaryRows | Where-Object { -not $_.SourceExists })
$textReadFailRows = @($summaryRows | Where-Object { -not $_.TextReadOk })
$templateRuleRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'REVIEW_AS_TEMPLATE_RULE_CARD_NOT_EXECUTION_AUTHORITY' })
$fieldApplyRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'HOLD_AS_FIELD_APPLY_ATTEMPT_REVIEW_ONLY' })
$freezeRepairRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'HOLD_AS_FREEZE_REPAIR_ATTEMPT_REVIEW_ONLY' })
$unknownDispositionRows = @($summaryRows | Where-Object { $_.StaticDisposition -eq 'UNKNOWN_STATIC_DISPOSITION_REVIEW_REQUIRED' })
$moveItemRows = @($summaryRows | Where-Object { $_.ContainsMoveItem })
$removeItemRows = @($summaryRows | Where-Object { $_.ContainsRemoveItem })
$renameItemRows = @($summaryRows | Where-Object { $_.ContainsRenameItem })
$startProcessRows = @($summaryRows | Where-Object { $_.ContainsStartProcess })
$invokeExpressionRows = @($summaryRows | Where-Object { $_.ContainsInvokeExpression })
$gitCommandRows = @($summaryRows | Where-Object { $_.ContainsGitCommand })

if (($blockers.Count -eq 0) -and ((Count-Items $sourceMissingRows) -ne 0)) {
    $blockers += ('SOURCE_MISSING_ROWS: {0}' -f (Count-Items $sourceMissingRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $textReadFailRows) -ne 0)) {
    $blockers += ('TEXT_READ_FAIL_ROWS: {0}' -f (Count-Items $textReadFailRows))
}
if (($blockers.Count -eq 0) -and ((Count-Items $unknownDispositionRows) -ne 0)) {
    $blockers += ('UNKNOWN_STATIC_DISPOSITION_ROWS: {0}' -f (Count-Items $unknownDispositionRows))
}

if ($blockers.Count -eq 0) {
    $summaryRows | Export-Csv -LiteralPath $OutputSummaryCsvPath -NoTypeInformation -Encoding UTF8
}

$packetLines = @()
$packetLines += '# Static Review Packet - Batch HSRB-002 Generated Runner Safe Template Chain - V0.1'
$packetLines += ''
$packetLines += 'Status: STATIC_REVIEW_PACKET / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$packetLines += ''
$packetLines += '## Purpose'
$packetLines += ''
$packetLines += 'Review Batch HSRB-002 as static text only. This packet reads source script text for evidence, hashes, and review classification. It does not run any selected helper script.'
$packetLines += ''
$packetLines += '## Boundary'
$packetLines += ''
$packetLines += 'No selected script is executed. No root file is moved, deleted, renamed, routed, cleaned, committed, or pushed. The output is review evidence only.'
$packetLines += ''
$packetLines += '## Verified selector inputs'
$packetLines += ''
$packetLines += '| Input | Exists | HashMatch | SHA256 |'
$packetLines += '| --- | ---: | ---: | --- |'
foreach ($h in $hashChecks) {
    $packetLines += ('| {0} | {1} | {2} | `{3}` |' -f $h.Name, $h.Exists, $h.HashMatch, $h.ActualSha256)
}
$packetLines += ''
$packetLines += '## Counts'
$packetLines += ''
$packetLines += '- selected_batch_id: HSRB-002'
$packetLines += ('- selected_batch_rows: {0}' -f $selectedRowCount)
$packetLines += ('- summary_rows: {0}' -f (Count-Items $summaryRows))
$packetLines += ('- source_missing_count: {0}' -f (Count-Items $sourceMissingRows))
$packetLines += ('- text_read_fail_count: {0}' -f (Count-Items $textReadFailRows))
$packetLines += ('- template_rule_card_count: {0}' -f (Count-Items $templateRuleRows))
$packetLines += ('- field_apply_attempt_count: {0}' -f (Count-Items $fieldApplyRows))
$packetLines += ('- freeze_repair_attempt_count: {0}' -f (Count-Items $freezeRepairRows))
$packetLines += ('- unknown_static_disposition_count: {0}' -f (Count-Items $unknownDispositionRows))
$packetLines += ('- contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
$packetLines += ('- contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
$packetLines += ('- contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
$packetLines += ('- contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
$packetLines += ('- contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
$packetLines += ('- contains_git_command_count: {0}' -f (Count-Items $gitCommandRows))
$packetLines += ('- blocker_count: {0}' -f $blockers.Count)
$packetLines += ''
$packetLines += '## Static review table'
$packetLines += ''
$packetLines += '| TicketID | FileName | Lines | KnownOutcome | StaticDisposition | SHA256 |'
$packetLines += '| --- | --- | ---: | --- | --- | --- |'
foreach ($r in $summaryRows) {
    $packetLines += ('| {0} | `{1}` | {2} | {3} | {4} | `{5}` |' -f $r.TicketID, (Escape-MdCell $r.FileName), $r.LineCount, (Escape-MdCell $r.KnownOutcome), (Escape-MdCell $r.StaticDisposition), $r.SourceSha256)
}
$packetLines += ''
$packetLines += '## Static safety scan'
$packetLines += ''
$packetLines += '| FileName | Move-Item | Remove-Item | Rename-Item | Start-Process | Invoke-Expression | GitCommand | Set-Content | Export-Csv | Set-Clipboard |'
$packetLines += '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |'
foreach ($r in $summaryRows) {
    $packetLines += ('| `{0}` | {1} | {2} | {3} | {4} | {5} | {6} | {7} | {8} | {9} |' -f (Escape-MdCell $r.FileName), $r.ContainsMoveItem, $r.ContainsRemoveItem, $r.ContainsRenameItem, $r.ContainsStartProcess, $r.ContainsInvokeExpression, $r.ContainsGitCommand, $r.ContainsSetContent, $r.ContainsExportCsv, $r.ContainsSetClipboard)
}
$packetLines += ''
$packetLines += '## Review notes'
$packetLines += ''
foreach ($r in $summaryRows) {
    $packetLines += ('### {0}' -f $r.FileName)
    $packetLines += ''
    $packetLines += ('- Known outcome: {0}' -f $r.KnownOutcome)
    $packetLines += ('- Static disposition: {0}' -f $r.StaticDisposition)
    $packetLines += ('- Review note: {0}' -f $r.ReviewNote)
    $packetLines += ('- Action now: {0}' -f $r.ActionNow)
    $packetLines += ''
}
$packetLines += '## Blockers'
$packetLines += ''
if ($blockers.Count -eq 0) { $packetLines += 'None.' } else { foreach ($b in $blockers) { $packetLines += ('- {0}' -f $b) } }
$packetLines += ''
$packetLines += '## DoesNotProve'
$packetLines += ''
$packetLines += 'This static packet does not prove any selected script is safe to execute, route-approved, cleanup-approved, source-authoritative, current doctrine, or ready to commit/push. It proves only that the selected batch was read as static text and classified for review.'
$packetLines += ''
$packetLines += '## Next single action'
$packetLines += ''
if ($blockers.Count -eq 0) {
    $packetLines += 'BUILD_HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION'
    $packetLines += ''
    $packetLines += 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $packetLines += 'REPAIR_STATIC_REVIEW_PACKET_BATCH_HSRB_002_INPUT_BLOCKERS_NO_EXECUTION'
    $packetLines += ''
    $packetLines += 'Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-Utf8NoBomLines -Path $OutputPacketMdPath -Lines $packetLines

$printLines = @()
$printLines += 'STATIC REVIEW PACKET - BATCH HSRB-002 GENERATED RUNNER SAFE TEMPLATE CHAIN V0.1'
$printLines += 'Static read only. No execution. No route. No cleanup.'
$printLines += ''
$printLines += ('Selected batch rows: {0}' -f $selectedRowCount)
$printLines += ('Source missing count: {0}' -f (Count-Items $sourceMissingRows))
$printLines += ('Text read fail count: {0}' -f (Count-Items $textReadFailRows))
$printLines += ('Template rule card count: {0}' -f (Count-Items $templateRuleRows))
$printLines += ('Field apply attempt count: {0}' -f (Count-Items $fieldApplyRows))
$printLines += ('Freeze repair attempt count: {0}' -f (Count-Items $freezeRepairRows))
$printLines += ('Unknown static disposition count: {0}' -f (Count-Items $unknownDispositionRows))
$printLines += ('Contains Move-Item count: {0}' -f (Count-Items $moveItemRows))
$printLines += ('Contains Remove-Item count: {0}' -f (Count-Items $removeItemRows))
$printLines += ('Contains Rename-Item count: {0}' -f (Count-Items $renameItemRows))
$printLines += ('Contains Start-Process count: {0}' -f (Count-Items $startProcessRows))
$printLines += ('Contains Invoke-Expression count: {0}' -f (Count-Items $invokeExpressionRows))
$printLines += ('Contains GitCommand count: {0}' -f (Count-Items $gitCommandRows))
$printLines += ('Blocker count: {0}' -f $blockers.Count)
$printLines += ''
$printLines += 'ROWS:'
foreach ($r in $summaryRows) {
    $printLines += ('{0} | {1}' -f $r.TicketID, $r.FileName)
    $printLines += ('KnownOutcome: {0}' -f $r.KnownOutcome)
    $printLines += ('Disposition: {0}' -f $r.StaticDisposition)
    $printLines += ('SHA256: {0}' -f $r.SourceSha256)
    $printLines += '---'
}
$printLines += 'NEXT_SINGLE_ACTION:'
if ($blockers.Count -eq 0) { $printLines += 'BUILD_HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION' } else { $printLines += 'REPAIR_STATIC_REVIEW_PACKET_BATCH_HSRB_002_INPUT_BLOCKERS_NO_EXECUTION' }
Write-Utf8NoBomLines -Path $OutputPrintPath -Lines $printLines
if ($blockers.Count -eq 0) { Set-Clipboard -Value ($printLines -join [Environment]::NewLine) }

$OutputSummaryCsvSha = ''
if (Test-Path -LiteralPath $OutputSummaryCsvPath) { $OutputSummaryCsvSha = Get-Sha256Text -Path $OutputSummaryCsvPath }
$OutputPacketMdSha = Get-Sha256Text -Path $OutputPacketMdPath
$OutputPrintSha = Get-Sha256Text -Path $OutputPrintPath

$receiptLines = @()
$receiptLines += 'STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_RECEIPT_V0_1_20260609'
$receiptLines += ('created_at_local: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
$receiptLines += ('input_selected_batch_csv_path: {0}' -f $SelectedBatchCsvPath)
$receiptLines += ('input_selected_batch_csv_expected_sha256: {0}' -f $ExpectedSelectedBatchCsvSha)
$receiptLines += ('output_summary_csv_path: {0}' -f $OutputSummaryCsvPath)
$receiptLines += ('output_summary_csv_sha256: {0}' -f $OutputSummaryCsvSha)
$receiptLines += ('output_packet_md_path: {0}' -f $OutputPacketMdPath)
$receiptLines += ('output_packet_md_sha256: {0}' -f $OutputPacketMdSha)
$receiptLines += ('output_print_path: {0}' -f $OutputPrintPath)
$receiptLines += ('output_print_sha256: {0}' -f $OutputPrintSha)
$receiptLines += 'selected_batch_id: HSRB-002'
$receiptLines += ('selected_batch_rows: {0}' -f $selectedRowCount)
$receiptLines += ('source_missing_count: {0}' -f (Count-Items $sourceMissingRows))
$receiptLines += ('text_read_fail_count: {0}' -f (Count-Items $textReadFailRows))
$receiptLines += ('template_rule_card_count: {0}' -f (Count-Items $templateRuleRows))
$receiptLines += ('field_apply_attempt_count: {0}' -f (Count-Items $fieldApplyRows))
$receiptLines += ('freeze_repair_attempt_count: {0}' -f (Count-Items $freezeRepairRows))
$receiptLines += ('unknown_static_disposition_count: {0}' -f (Count-Items $unknownDispositionRows))
$receiptLines += ('contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
$receiptLines += ('contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
$receiptLines += ('contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
$receiptLines += ('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
$receiptLines += ('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
$receiptLines += ('contains_git_command_count: {0}' -f (Count-Items $gitCommandRows))
$receiptLines += ('blocker_count: {0}' -f $blockers.Count)
$receiptLines += ('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
if ($blockers.Count -eq 0) {
    $receiptLines += 'next_single_action: BUILD_HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION'
    $receiptLines += 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION'
} else {
    $receiptLines += 'next_single_action: REPAIR_STATIC_REVIEW_PACKET_BATCH_HSRB_002_INPUT_BLOCKERS_NO_EXECUTION'
    $receiptLines += 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION'
}
Write-Utf8NoBomLines -Path $OutputReceiptPath -Lines $receiptLines
$OutputReceiptSha = Get-Sha256Text -Path $OutputReceiptPath

'=== STATIC REVIEW PACKET FOR BATCH HSRB-002 GENERATED RUNNER SAFE TEMPLATE CHAIN V0.1 COMPLETE ==='
('output_summary_csv_path: {0}' -f $OutputSummaryCsvPath)
('output_summary_csv_sha256: {0}' -f $OutputSummaryCsvSha)
('output_packet_md_path: {0}' -f $OutputPacketMdPath)
('output_packet_md_sha256: {0}' -f $OutputPacketMdSha)
('output_print_path: {0}' -f $OutputPrintPath)
('output_print_sha256: {0}' -f $OutputPrintSha)
('output_receipt_path: {0}' -f $OutputReceiptPath)
('output_receipt_sha256: {0}' -f $OutputReceiptSha)
'selected_batch_id: HSRB-002'
('selected_batch_rows: {0}' -f $selectedRowCount)
('source_missing_count: {0}' -f (Count-Items $sourceMissingRows))
('text_read_fail_count: {0}' -f (Count-Items $textReadFailRows))
('template_rule_card_count: {0}' -f (Count-Items $templateRuleRows))
('field_apply_attempt_count: {0}' -f (Count-Items $fieldApplyRows))
('freeze_repair_attempt_count: {0}' -f (Count-Items $freezeRepairRows))
('unknown_static_disposition_count: {0}' -f (Count-Items $unknownDispositionRows))
('contains_move_item_count: {0}' -f (Count-Items $moveItemRows))
('contains_remove_item_count: {0}' -f (Count-Items $removeItemRows))
('contains_rename_item_count: {0}' -f (Count-Items $renameItemRows))
('contains_start_process_count: {0}' -f (Count-Items $startProcessRows))
('contains_invoke_expression_count: {0}' -f (Count-Items $invokeExpressionRows))
('contains_git_command_count: {0}' -f (Count-Items $gitCommandRows))
('blocker_count: {0}' -f $blockers.Count)
if ($blockers.Count -eq 0) { 'next_single_action: BUILD_HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION' } else { 'next_single_action: REPAIR_STATIC_REVIEW_PACKET_BATCH_HSRB_002_INPUT_BLOCKERS_NO_EXECUTION' }
if ($blockers.Count -eq 0) { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION' } else { 'final_verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_002_GENERATED_RUNNER_SAFE_TEMPLATE_CHAIN_V0_1_BLOCKED_WITH_NO_PHYSICAL_ACTION' }
('physical_actions: move={0} delete={1} rename={2} route={3} execute={4} commit={5} push={6}' -f $PhysicalMoves,$PhysicalDeletes,$PhysicalRenames,$PhysicalRoutes,$PhysicalExecutes,$PhysicalCommits,$PhysicalPushes)
