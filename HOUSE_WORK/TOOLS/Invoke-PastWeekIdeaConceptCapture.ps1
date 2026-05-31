# Invoke-PastWeekIdeaConceptCapture.ps1
# Local-first idea/concept extractor for recent house files.
# Boundary: reads local files, writes reports under HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM only.

[CmdletBinding()]
param(
    [string]$HouseRoot = (Join-Path $env:USERPROFILE 'Desktop\123'),
    [datetime]$Since = [datetime]'2026-05-24T00:00:00',
    [int]$MaxSignalsPerFile = 32,
    [int]$MaxLineChars = 360,
    [int]$MaxFileMBForSignalScan = 24
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

$ToolName = 'PAST_WEEK_IDEA_CONCEPT_CAPTURE_V1_20260531'
$RunId = Get-Date -Format 'yyyyMMdd_HHmmss'
$RepoRoot = Join-Path $HouseRoot 'Jxhnny_Kl33N_Seedz'
$RoomRoot = Join-Path $RepoRoot 'HOUSE_WORK\IDEA_CONCEPT_COLLECTION_ROOM\PAST_WEEK_20260524_20260531'
$OutDir = Join-Path $RoomRoot "RUN_$RunId"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Text
    )

    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Get-SafeString {
    param([AllowNull()][object]$Value)
    if ($null -eq $Value) { return '' }
    return [string]$Value
}

function Get-Sha256Maybe {
    param([Parameter(Mandatory = $true)][string]$Path)
    try {
        if (Test-Path -LiteralPath $Path -PathType Leaf) {
            return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
        }
    } catch {
        return "HASH_ERROR: $($_.Exception.Message)"
    }
    return ''
}

function Get-RelativePath {
    param(
        [Parameter(Mandatory = $true)][string]$Base,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $baseFull = [System.IO.Path]::GetFullPath($Base).TrimEnd('\') + '\'
    $pathFull = [System.IO.Path]::GetFullPath($Path)
    if ($pathFull.StartsWith($baseFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $pathFull.Substring($baseFull.Length).Replace('\','/')
    }
    return $pathFull
}

function Get-GitAddedSet {
    param([Parameter(Mandatory = $true)][string]$Repo)

    $set = @{}
    if (-not (Test-Path -LiteralPath (Join-Path $Repo '.git') -PathType Container)) {
        return $set
    }

    $raw = @(git -C $Repo log --since='2026-05-24 00:00:00' --diff-filter=A --name-only --pretty=format:)
    foreach ($line in $raw) {
        $trimmed = (Get-SafeString $line).Trim()
        if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
            $set[$trimmed.Replace('\','/')] = $true
        }
    }
    return $set
}

function Get-Lane {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][bool]$InsideRepo
    )

    $parts = @($RelativePath -split '/')
    if ($InsideRepo -and $parts.Count -ge 2 -and $parts[0] -eq 'Jxhnny_Kl33N_Seedz') {
        return "REPO/$($parts[1])"
    }
    if ($parts.Count -ge 1) {
        return $parts[0]
    }
    return 'ROOT'
}

function Get-Disposition {
    param(
        [Parameter(Mandatory = $true)][string]$PathText,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Text
    )

    $hay = ($PathText + "`n" + $Text).ToLowerInvariant()
    if ($hay -match 'active learning rule|status:\s*active|authority:\s*assistant learning rule') { return 'ACTIVE_LEARNING_RULE' }
    if ($hay -match 'todo|next work|next object|next action') { return 'TODO_OR_NEXT_WORK' }
    if ($hay -match 'candidate support|candidate|not tested|parking|parked|reserve') { return 'CANDIDATE_OR_PARKED' }
    if ($hay -match 'receipt|proof_history|proof history') { return 'RECEIPT_OR_PROOF' }
    if ($hay -match 'report|read_report|read reports') { return 'REPORT' }
    if ($hay -match 'source_ore|source ore|transcript|research') { return 'SOURCE_OR_RESEARCH' }
    if ($PathText -match '(?i)\.ps1$') { return 'TOOL_OR_SCRIPT' }
    return 'MATERIAL'
}

function Get-Theme {
    param(
        [Parameter(Mandatory = $true)][string]$PathText,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Text
    )

    $hay = ($PathText + "`n" + $Text).ToLowerInvariant()
    if ($hay -match 'claim.*capability|capability.*claim|capability system|claim engine') { return 'CLAIM_CAPABILITY' }
    if ($hay -match 'helper.*growth|growth.*helper|flight recorder|helper capability|helper living|helper value') { return 'HELPER_GROWTH' }
    if ($hay -match 'shape.*gate|shape contract|selftest|self-test|binder|allowempty|string|collection') { return 'SHAPE_GATE_CONTRACT' }
    if ($hay -match 'proof surface|proof|receipt|evidence|custody|sha256|hash|manifest') { return 'PROOF_CUSTODY' }
    if ($hay -match 'lock_save|lock-save|git|commit|push|save room|dirty tree|staged') { return 'SAVE_LOCK_GIT' }
    if ($hay -match 'source ore|intake|transcript|research|harvest|deep web|web harvest') { return 'SOURCE_INTAKE_RESEARCH' }
    if ($hay -match 'keyring|ledger|map|index|registry|graph') { return 'KEY_LEDGER_MAP_REGISTRY' }
    if ($hay -match 'room|house|route|routing|front door|cockpit|work shed|mail room') { return 'HOUSE_ROUTING_ROOMS' }
    if ($hay -match 'runner|tool|script|powershell|code gate|harness|fixture') { return 'TOOLS_HARNESS_RUNNERS' }
    if ($hay -match 'authority|boundary|allow|block|guard|risk|unsafe|approval') { return 'AUTHORITY_BOUNDARY' }
    if ($hay -match 'chat|handoff|rope|carry|checkpoint|context') { return 'CHAT_HANDOFF_CONTEXT' }
    if ($hay -match 'root clear|root clean|loose|custody|desktop') { return 'ROOT_CLEANOUT_CUSTODY' }
    if ($hay -match 'soft suit|edward|scissor|smell|bone|nerve') { return 'SOFTSUIT_EDWARD_METHOD' }
    if ($hay -match 'future|want later|reserve|parking|idea') { return 'FUTURE_IDEA_PARKING' }
    return 'GENERAL_IDEA'
}

function Get-UseHorizon {
    param(
        [Parameter(Mandatory = $true)][string]$Disposition,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Signal
    )

    $s = $Signal.ToLowerInvariant()
    if ($Disposition -eq 'ACTIVE_LEARNING_RULE' -or $s -match '\b(must|required|do not|rule|guard|block|repair|fix|next object|next work)\b') {
        return 'USE_NOW_OR_ENFORCE'
    }
    if ($Disposition -eq 'TODO_OR_NEXT_WORK' -or $s -match '\b(next|todo|search|review|followup|approval)\b') {
        return 'NEXT_WORK'
    }
    if ($Disposition -eq 'CANDIDATE_OR_PARKED' -or $s -match '\b(candidate|park|reserve|future|maybe|want later|not tested)\b') {
        return 'WANT_LATER_OR_PARK'
    }
    return 'REFERENCE'
}

function Add-ConceptRow {
    param(
        [Parameter(Mandatory = $true)]$Rows,
        [Parameter(Mandatory = $true)]$FileRow,
        [Parameter(Mandatory = $true)][string]$SignalType,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$SignalText,
        [int]$LineNumber = 0
    )

    $text = (Get-SafeString $SignalText).Trim()
    if ([string]::IsNullOrWhiteSpace($text)) { return }
    if ($text.Length -gt $script:MaxLineCharsForTrim) {
        $text = $text.Substring(0, $script:MaxLineCharsForTrim) + '...'
    }

    $theme = Get-Theme -PathText $FileRow.RelativePath -Text $text
    $useHorizon = Get-UseHorizon -Disposition $FileRow.Disposition -Signal $text

    $Rows.Add([pscustomobject]@{
        SourceId = $FileRow.SourceId
        RelativePath = $FileRow.RelativePath
        Lane = $FileRow.Lane
        Theme = $theme
        Disposition = $FileRow.Disposition
        UseHorizon = $useHorizon
        SignalType = $SignalType
        LineNumber = $LineNumber
        SignalText = $text
        IsGitAddedPastWeek = $FileRow.IsGitAddedPastWeek
        IsLocalRecent = $FileRow.IsLocalRecent
    }) | Out-Null
}

function Get-TitleFromName {
    param([Parameter(Mandatory = $true)][string]$Name)
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $stem = $stem -replace '\d{8}(?:_\d{4,6})?', ''
    $stem = $stem -replace 'UNIQUE', ''
    $stem = $stem -replace 'V\d+(?:[._]\d+)*', 'Vx'
    $stem = $stem -replace '[_\-]+', ' '
    return $stem.Trim()
}

$script:MaxLineCharsForTrim = $MaxLineChars
$textExts = @('.md','.txt','.ps1','.psm1','.psd1','.csv','.json','.yml','.yaml','.html','.url')
$signalPattern = '(?i)\b(rule|concept|idea|candidate|todo|next|must|should|do not|boundary|authority|proof|receipt|evidence|guard|gate|helper|growth|capability|claim|harness|fixture|repair|fix|risk|block|allow|approval|source|ore|intake|map|ledger|registry|room|route|parking|future|learning|selftest|self-test|contract|shape|save|lock|git|commit|push)\b'

$gitAddedSet = Get-GitAddedSet -Repo $RepoRoot
$houseFull = [System.IO.Path]::GetFullPath($HouseRoot).TrimEnd('\')
$repoFull = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\')
$roomFull = [System.IO.Path]::GetFullPath($RoomRoot).TrimEnd('\')

$allFiles = @(Get-ChildItem -LiteralPath $HouseRoot -Recurse -Force -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.FullName -notmatch '\\.git\\' -and
        -not ([System.IO.Path]::GetFullPath($_.FullName).StartsWith($roomFull, [System.StringComparison]::OrdinalIgnoreCase)) -and
        ($_.CreationTime -ge $Since -or $_.LastWriteTime -ge $Since)
    } |
    Sort-Object FullName)

$inventoryRows = [System.Collections.Generic.List[object]]::new()
$conceptRows = [System.Collections.Generic.List[object]]::new()
$sourceCounter = 0

foreach ($file in $allFiles) {
    $sourceCounter++
    $fullPath = [System.IO.Path]::GetFullPath($file.FullName)
    $relativeHouse = Get-RelativePath -Base $HouseRoot -Path $fullPath
    $insideRepo = $fullPath.StartsWith(($repoFull + '\'), [System.StringComparison]::OrdinalIgnoreCase)
    $repoRelative = ''
    if ($insideRepo) {
        $repoRelative = Get-RelativePath -Base $RepoRoot -Path $fullPath
    }

    $isGitAdded = ($insideRepo -and $gitAddedSet.ContainsKey($repoRelative))
    $ext = $file.Extension.ToLowerInvariant()
    $isTextLike = ($textExts -contains $ext)
    $hash = ''
    if ($file.Length -le (32MB)) {
        $hash = Get-Sha256Maybe -Path $fullPath
    }

    $fileTitle = Get-TitleFromName -Name $file.Name
    $disposition = Get-Disposition -PathText $relativeHouse -Text $fileTitle
    $lane = Get-Lane -RelativePath $relativeHouse -InsideRepo $insideRepo
    $theme = Get-Theme -PathText $relativeHouse -Text $fileTitle

    $fileRow = [pscustomobject]@{
        SourceId = ('SRC-{0:D5}' -f $sourceCounter)
        FullPath = $fullPath
        RelativePath = $relativeHouse
        RepoRelativePath = $repoRelative
        Lane = $lane
        Extension = $ext
        Length = $file.Length
        CreationTime = $file.CreationTime.ToString('o')
        LastWriteTime = $file.LastWriteTime.ToString('o')
        IsTextLike = $isTextLike
        IsGitAddedPastWeek = $isGitAdded
        IsLocalRecent = $true
        Sha256 = $hash
        Disposition = $disposition
        PrimaryThemeFromName = $theme
        TitleFromName = $fileTitle
    }
    $inventoryRows.Add($fileRow) | Out-Null

    Add-ConceptRow -Rows $conceptRows -FileRow $fileRow -SignalType 'FILENAME_TITLE' -SignalText $fileTitle -LineNumber 0

    if (-not $isTextLike) {
        continue
    }

    if ($file.Length -gt ($MaxFileMBForSignalScan * 1MB)) {
        Add-ConceptRow -Rows $conceptRows -FileRow $fileRow -SignalType 'SCAN_SKIPPED_SIZE_BOUNDARY' -SignalText "File over MaxFileMBForSignalScan=$MaxFileMBForSignalScan; filename captured only." -LineNumber 0
        continue
    }

    $signalsForFile = 0
    $lineNo = 0
    $seenSignals = @{}

    try {
        foreach ($line in [System.IO.File]::ReadLines($fullPath)) {
            $lineNo++
            $trimmed = (Get-SafeString $line).Trim()
            if ([string]::IsNullOrWhiteSpace($trimmed)) { continue }

            $signalType = ''
            if ($ext -eq '.ps1' -and $trimmed -match '^(function)\s+([A-Za-z0-9_-]+)') {
                $signalType = 'POWERSHELL_FUNCTION'
            } elseif ($trimmed -match '^(#{1,4})\s+(.+)$') {
                $signalType = 'MARKDOWN_HEADING'
            } elseif ($ext -eq '.csv' -and $lineNo -eq 1) {
                $signalType = 'CSV_HEADER'
            } elseif ($trimmed -match $signalPattern) {
                $signalType = 'SIGNAL_LINE'
            }

            if ([string]::IsNullOrWhiteSpace($signalType)) { continue }

            $dedupeKey = "$signalType|$trimmed"
            if ($seenSignals.ContainsKey($dedupeKey)) { continue }
            $seenSignals[$dedupeKey] = $true

            Add-ConceptRow -Rows $conceptRows -FileRow $fileRow -SignalType $signalType -SignalText $trimmed -LineNumber $lineNo
            $signalsForFile++

            if ($signalsForFile -ge $MaxSignalsPerFile) {
                break
            }
        }
    } catch {
        Add-ConceptRow -Rows $conceptRows -FileRow $fileRow -SignalType 'READ_ERROR' -SignalText $_.Exception.Message -LineNumber 0
    }
}

$inventoryColumns = @('SourceId','RelativePath','RepoRelativePath','Lane','Extension','Length','CreationTime','LastWriteTime','IsTextLike','IsGitAddedPastWeek','IsLocalRecent','Sha256','Disposition','PrimaryThemeFromName','TitleFromName','FullPath')
$conceptColumns = @('SourceId','RelativePath','Lane','Theme','Disposition','UseHorizon','SignalType','LineNumber','SignalText','IsGitAddedPastWeek','IsLocalRecent')

$inventoryCsv = Join-Path $OutDir "${ToolName}_LOCAL_RECENT_FILE_INVENTORY.csv"
$conceptCsv = Join-Path $OutDir "${ToolName}_CONCEPT_SIGNAL_LEDGER.csv"
$themeCsv = Join-Path $OutDir "${ToolName}_THEME_SUMMARY.csv"
$useCsv = Join-Path $OutDir "${ToolName}_USE_HORIZON_SUMMARY.csv"
$reportMd = Join-Path $OutDir "${ToolName}_ROOM_REPORT.md"
$receiptTxt = Join-Path $OutDir "${ToolName}_RECEIPT.txt"
$readmeMd = Join-Path $RoomRoot 'README.md'
$latestPointer = Join-Path $RoomRoot 'LATEST_RUN_POINTER.txt'

$inventoryRows | Select-Object $inventoryColumns | Export-Csv -LiteralPath $inventoryCsv -NoTypeInformation -Encoding UTF8
$conceptRows | Select-Object $conceptColumns | Export-Csv -LiteralPath $conceptCsv -NoTypeInformation -Encoding UTF8

$themeRows = @($conceptRows | Group-Object Theme | Sort-Object Count -Descending | ForEach-Object {
    [pscustomobject]@{
        Theme = $_.Name
        ConceptSignals = $_.Count
        SourceFiles = @($_.Group | Select-Object -ExpandProperty SourceId -Unique).Count
    }
})
$themeRows | Export-Csv -LiteralPath $themeCsv -NoTypeInformation -Encoding UTF8

$useRows = @($conceptRows | Group-Object UseHorizon | Sort-Object Count -Descending | ForEach-Object {
    [pscustomobject]@{
        UseHorizon = $_.Name
        ConceptSignals = $_.Count
        SourceFiles = @($_.Group | Select-Object -ExpandProperty SourceId -Unique).Count
    }
})
$useRows | Export-Csv -LiteralPath $useCsv -NoTypeInformation -Encoding UTF8

function Convert-TopRows {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Rows)
    $lines = @()
    foreach ($row in $Rows) {
        $a = (Get-SafeString $row.Theme) -replace '\|','/'
        $b = Get-SafeString $row.ConceptSignals
        $c = Get-SafeString $row.SourceFiles
        $lines += "| $a | $b | $c |"
    }
    if ($lines.Count -eq 0) { $lines += "| none | 0 | 0 |" }
    return $lines
}

function Convert-SignalPreview {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Rows)
    $lines = @()
    foreach ($row in $Rows) {
        $theme = (Get-SafeString $row.Theme) -replace '\|','/'
        $horizon = (Get-SafeString $row.UseHorizon) -replace '\|','/'
        $path = (Get-SafeString $row.RelativePath) -replace '\|','/'
        $signal = (Get-SafeString $row.SignalText) -replace '\|','/'
        if ($signal.Length -gt 160) { $signal = $signal.Substring(0,160) + '...' }
        $lines += "| $theme | $horizon | $path | $signal |"
    }
    if ($lines.Count -eq 0) { $lines += "| none | none | none | none |" }
    return $lines
}

$topThemes = Convert-TopRows -Rows @($themeRows | Select-Object -First 20)
$useNowPreview = Convert-SignalPreview -Rows @($conceptRows | Where-Object { $_.UseHorizon -eq 'USE_NOW_OR_ENFORCE' } | Select-Object -First 40)
$wantLaterPreview = Convert-SignalPreview -Rows @($conceptRows | Where-Object { $_.UseHorizon -eq 'WANT_LATER_OR_PARK' } | Select-Object -First 40)
$nextPreview = Convert-SignalPreview -Rows @($conceptRows | Where-Object { $_.UseHorizon -eq 'NEXT_WORK' } | Select-Object -First 40)

$textLikeCount = @($inventoryRows | Where-Object { $_.IsTextLike }).Count
$gitAddedCount = @($inventoryRows | Where-Object { $_.IsGitAddedPastWeek }).Count
$skippedSizeCount = @($conceptRows | Where-Object { $_.SignalType -eq 'SCAN_SKIPPED_SIZE_BOUNDARY' }).Count

$report = @"
# Past Week Idea Concept Capture

RunId: $RunId
Since: $($Since.ToString('o'))
Scope: local-first under `$HouseRoot`

## Counts

| Bucket | Count |
|---|---:|
| Local recent files inventoried | $($inventoryRows.Count) |
| Text/code/data-like files | $textLikeCount |
| Git-added-past-week files among local recent | $gitAddedCount |
| Concept signals captured | $($conceptRows.Count) |
| Size-boundary skipped text files | $skippedSizeCount |

## Top Themes

| Theme | ConceptSignals | SourceFiles |
|---|---:|---:|
$($topThemes -join "`r`n")

## Use Now / Enforce Preview

| Theme | Horizon | Source | Signal |
|---|---|---|---|
$($useNowPreview -join "`r`n")

## Next Work Preview

| Theme | Horizon | Source | Signal |
|---|---|---|---|
$($nextPreview -join "`r`n")

## Want Later / Park Preview

| Theme | Horizon | Source | Signal |
|---|---|---|---|
$($wantLaterPreview -join "`r`n")

## Output Files

- Inventory: `$inventoryCsv`
- Concept signal ledger: `$conceptCsv`
- Theme summary: `$themeCsv`
- Use horizon summary: `$useCsv`
- Receipt: `$receiptTxt`

## Reading Rule

The CSV ledgers are the full list. This markdown report is only a human-sized preview.

## Does Not Prove

This extractor does not decide adoption. It does not replace manual review. It does not approve helpers, scripts, rules, or authority changes. It captures candidate concepts and routes them by theme and use horizon.
"@
Write-Utf8NoBom -Path $reportMd -Text $report

$readme = @"
# Idea Concept Collection Room

Purpose: collect ideas, concepts, rules, future wants, helper growth signals, and next-work candidates discovered during broad local file dives.

Boundary:
- collection and routing only;
- not doctrine;
- not ACTIVE_GUIDES;
- not CURRENT_TRUTH_INDEX;
- not approval;
- not a save-authority grant.

Current packet:

$OutDir

Start here:
- Capture report: $reportMd
- Full local recent file inventory: $inventoryCsv
- Raw concept signal ledger: $conceptCsv
- If synthesis has been run, use the synthesis master index inside the current packet for de-duplicated lists.
"@
Write-Utf8NoBom -Path $readmeMd -Text $readme
Write-Utf8NoBom -Path $latestPointer -Text ("LatestRun: $OutDir`r`nReport: $reportMd`r`nConceptLedger: $conceptCsv`r`nInventory: $inventoryCsv`r`n")

$inventoryHash = Get-Sha256Maybe -Path $inventoryCsv
$conceptHash = Get-Sha256Maybe -Path $conceptCsv
$themeHash = Get-Sha256Maybe -Path $themeCsv
$useHash = Get-Sha256Maybe -Path $useCsv
$reportHash = Get-Sha256Maybe -Path $reportMd

$receipt = @"
PAST_WEEK_IDEA_CONCEPT_CAPTURE_RECEIPT
RunId: $RunId
Since: $($Since.ToString('o'))
HouseRoot: $HouseRoot
RoomRoot: $RoomRoot
OutDir: $OutDir
LocalRecentFilesInventoried: $($inventoryRows.Count)
TextLikeFiles: $textLikeCount
GitAddedPastWeekFilesAmongLocalRecent: $gitAddedCount
ConceptSignalsCaptured: $($conceptRows.Count)
SizeBoundarySkippedTextFiles: $skippedSizeCount
InventoryCsv: $inventoryCsv
InventoryCsvSha256: $inventoryHash
ConceptLedgerCsv: $conceptCsv
ConceptLedgerCsvSha256: $conceptHash
ThemeSummaryCsv: $themeCsv
ThemeSummaryCsvSha256: $themeHash
UseHorizonSummaryCsv: $useCsv
UseHorizonSummaryCsvSha256: $useHash
ReportMd: $reportMd
ReportMdSha256: $reportHash
Boundary: local-first read/report capture; no delete; no move; no Git action from tool; no doctrine; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX; no helper approval.
"@
Write-Utf8NoBom -Path $receiptTxt -Text $receipt
$receiptHash = Get-Sha256Maybe -Path $receiptTxt

Write-Host 'XxXxX ===== COPY BACK TO CHAT START ===== XxXxX'
Write-Host 'PAST_WEEK_IDEA_CONCEPT_CAPTURE_COMPLETE'
Write-Host "RunId: $RunId"
Write-Host "OutDir: $OutDir"
Write-Host "LocalRecentFilesInventoried: $($inventoryRows.Count)"
Write-Host "TextLikeFiles: $textLikeCount"
Write-Host "GitAddedPastWeekFilesAmongLocalRecent: $gitAddedCount"
Write-Host "ConceptSignalsCaptured: $($conceptRows.Count)"
Write-Host "SizeBoundarySkippedTextFiles: $skippedSizeCount"
Write-Host "ReportMd: $reportMd"
Write-Host "ReportMdSha256: $reportHash"
Write-Host "ReceiptTxt: $receiptTxt"
Write-Host "ReceiptTxtSha256: $receiptHash"
Write-Host 'Boundary: local-first read/report capture; no delete; no move; no Git action from tool; no doctrine; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX; no helper approval.'
Write-Host 'XxXxX ===== COPY BACK TO CHAT END ===== XxXxX'

exit 0
