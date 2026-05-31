# Invoke-PastWeekIdeaConceptSynthesis.ps1
# Builds reusable indexes from a Past Week Idea Concept Capture run.
# Boundary: reads capture CSVs, writes synthesis files in the same run directory.

[CmdletBinding()]
param(
    [string]$HouseRoot = (Join-Path $env:USERPROFILE 'Desktop\123'),
    [string]$RunDir = ''
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

$ToolName = 'PAST_WEEK_IDEA_CONCEPT_SYNTHESIS_V1_20260531'
$RepoRoot = Join-Path $HouseRoot 'Jxhnny_Kl33N_Seedz'
$RoomRoot = Join-Path $RepoRoot 'HOUSE_WORK\IDEA_CONCEPT_COLLECTION_ROOM\PAST_WEEK_20260524_20260531'

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
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    }
    return ''
}

function Get-LatestRunDir {
    param([Parameter(Mandatory = $true)][string]$Root)
    $dirs = @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like 'RUN_*' } |
        Sort-Object LastWriteTimeUtc -Descending)
    if ($dirs.Count -lt 1) { return '' }
    return $dirs[0].FullName
}

function Get-FirstFile {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Pattern
    )
    $files = @(Get-ChildItem -LiteralPath $Root -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like $Pattern } |
        Sort-Object LastWriteTimeUtc -Descending)
    if ($files.Count -lt 1) { return '' }
    return $files[0].FullName
}

function Normalize-Signal {
    param([AllowEmptyString()][string]$Text = '')
    $t = $Text.ToLowerInvariant()
    $t = $t -replace '`+', ''
    $t = $t -replace '\d{8}(?:_\d{4,6})?', '<date>'
    $t = $t -replace '[a-f0-9]{40,64}', '<hash>'
    $t = $t -replace '\s+', ' '
    return $t.Trim()
}

function Convert-TableRows {
    param(
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Rows,
        [Parameter(Mandatory = $true)][string[]]$Columns
    )

    $lines = @()
    foreach ($row in $Rows) {
        $cells = @()
        foreach ($col in $Columns) {
            $value = (Get-SafeString $row.$col) -replace '\|','/'
            if ($value.Length -gt 170) { $value = $value.Substring(0,170) + '...' }
            $cells += $value
        }
        $lines += '| ' + ($cells -join ' | ') + ' |'
    }
    if ($lines.Count -eq 0) {
        $lines += '| none |'
    }
    return $lines
}

if ([string]::IsNullOrWhiteSpace($RunDir)) {
    $RunDir = Get-LatestRunDir -Root $RoomRoot
}

if ([string]::IsNullOrWhiteSpace($RunDir) -or -not (Test-Path -LiteralPath $RunDir -PathType Container)) {
    throw "Missing run directory: $RunDir"
}

$conceptCsv = Get-FirstFile -Root $RunDir -Pattern '*_CONCEPT_SIGNAL_LEDGER.csv'
$inventoryCsv = Get-FirstFile -Root $RunDir -Pattern '*_LOCAL_RECENT_FILE_INVENTORY.csv'

if (-not (Test-Path -LiteralPath $conceptCsv -PathType Leaf)) {
    throw "Missing concept ledger in $RunDir"
}
if (-not (Test-Path -LiteralPath $inventoryCsv -PathType Leaf)) {
    throw "Missing inventory in $RunDir"
}

$conceptRows = @(Import-Csv -LiteralPath $conceptCsv)
$inventoryRows = @(Import-Csv -LiteralPath $inventoryCsv)

$priority = @{
    'USE_NOW_OR_ENFORCE' = 1
    'NEXT_WORK' = 2
    'WANT_LATER_OR_PARK' = 3
    'REFERENCE' = 4
}

$conceptBuckets = @{}
foreach ($row in $conceptRows) {
    $theme = Get-SafeString $row.Theme
    $signalText = Get-SafeString $row.SignalText
    $key = "$theme|$(Normalize-Signal -Text $signalText)"
    if (-not $conceptBuckets.ContainsKey($key)) {
        $conceptBuckets[$key] = [ordered]@{
            Theme = $theme
            UseHorizon = Get-SafeString $row.UseHorizon
            Priority = if ($priority.ContainsKey($row.UseHorizon)) { $priority[$row.UseHorizon] } else { 9 }
            SignalText = $signalText
            SignalCount = 0
            Sources = @{}
            Samples = [System.Collections.Generic.List[string]]::new()
        }
    }

    $bucket = $conceptBuckets[$key]
    $bucket.SignalCount = [int]$bucket.SignalCount + 1
    $sourceId = Get-SafeString $row.SourceId
    if (-not [string]::IsNullOrWhiteSpace($sourceId)) {
        $bucket.Sources[$sourceId] = $true
    }

    $relativePath = Get-SafeString $row.RelativePath
    if (-not [string]::IsNullOrWhiteSpace($relativePath) -and -not ($bucket.Samples -contains $relativePath) -and $bucket.Samples.Count -lt 5) {
        $bucket.Samples.Add($relativePath) | Out-Null
    }

    $rowPriority = if ($priority.ContainsKey($row.UseHorizon)) { $priority[$row.UseHorizon] } else { 9 }
    if ($rowPriority -lt [int]$bucket.Priority) {
        $bucket.Priority = $rowPriority
        $bucket.UseHorizon = Get-SafeString $row.UseHorizon
    }
}

$uniqueRows = [System.Collections.Generic.List[object]]::new()
$conceptCounter = 0
foreach ($bucket in $conceptBuckets.Values) {
    $conceptCounter++
    $uniqueRows.Add([pscustomobject]@{
        ConceptId = ('CONCEPT-{0:D5}' -f $conceptCounter)
        Theme = Get-SafeString $bucket.Theme
        UseHorizon = Get-SafeString $bucket.UseHorizon
        SignalText = Get-SafeString $bucket.SignalText
        SignalCount = [int]$bucket.SignalCount
        SourceFileCount = $bucket.Sources.Count
        SampleSources = (@($bucket.Samples) -join '; ')
    }) | Out-Null
}

$uniqueSorted = @($uniqueRows | Sort-Object @{ Expression = { if ($priority.ContainsKey($_.UseHorizon)) { $priority[$_.UseHorizon] } else { 9 } }; Ascending = $true }, @{ Expression = { [int]$_.SourceFileCount }; Descending = $true }, Theme, SignalText)

$roomBuckets = @{}
foreach ($row in $inventoryRows) {
    $lane = Get-SafeString $row.Lane
    if ([string]::IsNullOrWhiteSpace($lane)) { $lane = 'UNKNOWN' }
    if (-not $roomBuckets.ContainsKey($lane)) {
        $roomBuckets[$lane] = [ordered]@{
            Lane = $lane
            Files = 0
            TextLikeFiles = 0
            GitAddedPastWeek = 0
            Bytes = [int64]0
        }
    }
    $roomBuckets[$lane].Files = [int]$roomBuckets[$lane].Files + 1
    if ((Get-SafeString $row.IsTextLike) -eq 'True') { $roomBuckets[$lane].TextLikeFiles = [int]$roomBuckets[$lane].TextLikeFiles + 1 }
    if ((Get-SafeString $row.IsGitAddedPastWeek) -eq 'True') { $roomBuckets[$lane].GitAddedPastWeek = [int]$roomBuckets[$lane].GitAddedPastWeek + 1 }
    $roomBuckets[$lane].Bytes = [int64]$roomBuckets[$lane].Bytes + [int64]$row.Length
}

$roomRows = @($roomBuckets.Values | ForEach-Object {
    [pscustomobject]@{
        Lane = $_.Lane
        Files = $_.Files
        TextLikeFiles = $_.TextLikeFiles
        GitAddedPastWeek = $_.GitAddedPastWeek
        Bytes = $_.Bytes
    }
} | Sort-Object Files -Descending)

$themeBuckets = @{}
foreach ($row in $uniqueSorted) {
    $theme = Get-SafeString $row.Theme
    if (-not $themeBuckets.ContainsKey($theme)) {
        $themeBuckets[$theme] = [ordered]@{
            Theme = $theme
            UniqueConcepts = 0
            UseNow = 0
            NextWork = 0
            WantLater = 0
            Reference = 0
        }
    }
    $themeBuckets[$theme].UniqueConcepts = [int]$themeBuckets[$theme].UniqueConcepts + 1
    switch (Get-SafeString $row.UseHorizon) {
        'USE_NOW_OR_ENFORCE' { $themeBuckets[$theme].UseNow = [int]$themeBuckets[$theme].UseNow + 1 }
        'NEXT_WORK' { $themeBuckets[$theme].NextWork = [int]$themeBuckets[$theme].NextWork + 1 }
        'WANT_LATER_OR_PARK' { $themeBuckets[$theme].WantLater = [int]$themeBuckets[$theme].WantLater + 1 }
        default { $themeBuckets[$theme].Reference = [int]$themeBuckets[$theme].Reference + 1 }
    }
}

$themeRows = @($themeBuckets.Values | ForEach-Object {
    [pscustomobject]@{
        Theme = $_.Theme
        UniqueConcepts = $_.UniqueConcepts
        UseNow = $_.UseNow
        NextWork = $_.NextWork
        WantLater = $_.WantLater
        Reference = $_.Reference
    }
} | Sort-Object UniqueConcepts -Descending)

$allConceptsCsv = Join-Path $RunDir "${ToolName}_UNIQUE_CONCEPTS_LEDGER.csv"
$themeClusterCsv = Join-Path $RunDir "${ToolName}_THEME_CLUSTER_LEDGER.csv"
$sourceRoomCsv = Join-Path $RunDir "${ToolName}_SOURCE_ROOM_SUMMARY.csv"
$useNowCsv = Join-Path $RunDir "${ToolName}_USE_NOW_LEDGER.csv"
$nextWorkCsv = Join-Path $RunDir "${ToolName}_NEXT_WORK_LEDGER.csv"
$wantLaterCsv = Join-Path $RunDir "${ToolName}_WANT_LATER_LEDGER.csv"
$masterIndexMd = Join-Path $RunDir "${ToolName}_MASTER_INDEX.md"
$receiptTxt = Join-Path $RunDir "${ToolName}_RECEIPT.txt"

$uniqueSorted | Export-Csv -LiteralPath $allConceptsCsv -NoTypeInformation -Encoding UTF8
$themeRows | Export-Csv -LiteralPath $themeClusterCsv -NoTypeInformation -Encoding UTF8
$roomRows | Export-Csv -LiteralPath $sourceRoomCsv -NoTypeInformation -Encoding UTF8
@($uniqueSorted | Where-Object { $_.UseHorizon -eq 'USE_NOW_OR_ENFORCE' }) | Export-Csv -LiteralPath $useNowCsv -NoTypeInformation -Encoding UTF8
@($uniqueSorted | Where-Object { $_.UseHorizon -eq 'NEXT_WORK' }) | Export-Csv -LiteralPath $nextWorkCsv -NoTypeInformation -Encoding UTF8
@($uniqueSorted | Where-Object { $_.UseHorizon -eq 'WANT_LATER_OR_PARK' }) | Export-Csv -LiteralPath $wantLaterCsv -NoTypeInformation -Encoding UTF8

$topThemeLines = Convert-TableRows -Rows @($themeRows | Select-Object -First 20) -Columns @('Theme','UniqueConcepts','UseNow','NextWork','WantLater','Reference')
$roomLines = Convert-TableRows -Rows @($roomRows | Select-Object -First 30) -Columns @('Lane','Files','TextLikeFiles','GitAddedPastWeek','Bytes')
$useNowLines = Convert-TableRows -Rows @($uniqueSorted | Where-Object { $_.UseHorizon -eq 'USE_NOW_OR_ENFORCE' } | Select-Object -First 60) -Columns @('Theme','SignalText','SourceFileCount','SampleSources')
$nextLines = Convert-TableRows -Rows @($uniqueSorted | Where-Object { $_.UseHorizon -eq 'NEXT_WORK' } | Select-Object -First 60) -Columns @('Theme','SignalText','SourceFileCount','SampleSources')
$wantLines = Convert-TableRows -Rows @($uniqueSorted | Where-Object { $_.UseHorizon -eq 'WANT_LATER_OR_PARK' } | Select-Object -First 60) -Columns @('Theme','SignalText','SourceFileCount','SampleSources')

$index = @"
# Past Week Idea Concept Master Index

RunDir: $RunDir

## Full Lists

- All local recent files inventory: $inventoryCsv
- Raw concept signal ledger: $conceptCsv
- De-duplicated concept ledger: $allConceptsCsv
- Theme cluster ledger: $themeClusterCsv
- Source room summary: $sourceRoomCsv
- Use-now ledger: $useNowCsv
- Next-work ledger: $nextWorkCsv
- Want-later ledger: $wantLaterCsv

## Counts

| Bucket | Count |
|---|---:|
| Inventory rows | $($inventoryRows.Count) |
| Raw concept signals | $($conceptRows.Count) |
| Unique concept rows | $($uniqueSorted.Count) |
| Use-now rows | $(@($uniqueSorted | Where-Object { $_.UseHorizon -eq 'USE_NOW_OR_ENFORCE' }).Count) |
| Next-work rows | $(@($uniqueSorted | Where-Object { $_.UseHorizon -eq 'NEXT_WORK' }).Count) |
| Want-later rows | $(@($uniqueSorted | Where-Object { $_.UseHorizon -eq 'WANT_LATER_OR_PARK' }).Count) |

## Theme Clusters

| Theme | UniqueConcepts | UseNow | NextWork | WantLater | Reference |
|---|---:|---:|---:|---:|---:|
$($topThemeLines -join "`r`n")

## Source Rooms

| Lane | Files | TextLikeFiles | GitAddedPastWeek | Bytes |
|---|---:|---:|---:|---:|
$($roomLines -join "`r`n")

## Use Now / Enforce Highlights

| Theme | Concept | SourceFiles | SampleSources |
|---|---|---:|---|
$($useNowLines -join "`r`n")

## Next Work Highlights

| Theme | Concept | SourceFiles | SampleSources |
|---|---|---:|---|
$($nextLines -join "`r`n")

## Want Later / Park Highlights

| Theme | Concept | SourceFiles | SampleSources |
|---|---|---:|---|
$($wantLines -join "`r`n")

## Reading Rule

This markdown is a navigational index. The CSV files above are the full lists.

## Does Not Prove

This synthesis does not approve adoption or authority. It does not decide which concepts become active rules. It preserves the ideas and routes them for later review.
"@
Write-Utf8NoBom -Path $masterIndexMd -Text $index

$allHash = Get-Sha256Maybe -Path $allConceptsCsv
$themeHash = Get-Sha256Maybe -Path $themeClusterCsv
$roomHash = Get-Sha256Maybe -Path $sourceRoomCsv
$useNowHash = Get-Sha256Maybe -Path $useNowCsv
$nextHash = Get-Sha256Maybe -Path $nextWorkCsv
$wantHash = Get-Sha256Maybe -Path $wantLaterCsv
$indexHash = Get-Sha256Maybe -Path $masterIndexMd

$receipt = @"
PAST_WEEK_IDEA_CONCEPT_SYNTHESIS_RECEIPT
RunDir: $RunDir
InventoryRows: $($inventoryRows.Count)
RawConceptSignals: $($conceptRows.Count)
UniqueConceptRows: $($uniqueSorted.Count)
AllConceptsCsv: $allConceptsCsv
AllConceptsCsvSha256: $allHash
ThemeClusterCsv: $themeClusterCsv
ThemeClusterCsvSha256: $themeHash
SourceRoomCsv: $sourceRoomCsv
SourceRoomCsvSha256: $roomHash
UseNowCsv: $useNowCsv
UseNowCsvSha256: $useNowHash
NextWorkCsv: $nextWorkCsv
NextWorkCsvSha256: $nextHash
WantLaterCsv: $wantLaterCsv
WantLaterCsvSha256: $wantHash
MasterIndexMd: $masterIndexMd
MasterIndexMdSha256: $indexHash
Boundary: synthesis only; no adoption; no authority change; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX.
"@
Write-Utf8NoBom -Path $receiptTxt -Text $receipt
$receiptHash = Get-Sha256Maybe -Path $receiptTxt

Write-Host 'XxXxX ===== COPY BACK TO CHAT START ===== XxXxX'
Write-Host 'PAST_WEEK_IDEA_CONCEPT_SYNTHESIS_COMPLETE'
Write-Host "RunDir: $RunDir"
Write-Host "InventoryRows: $($inventoryRows.Count)"
Write-Host "RawConceptSignals: $($conceptRows.Count)"
Write-Host "UniqueConceptRows: $($uniqueSorted.Count)"
Write-Host "MasterIndexMd: $masterIndexMd"
Write-Host "MasterIndexMdSha256: $indexHash"
Write-Host "ReceiptTxt: $receiptTxt"
Write-Host "ReceiptTxtSha256: $receiptHash"
Write-Host 'Boundary: synthesis only; no adoption; no authority change; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX.'
Write-Host 'XxXxX ===== COPY BACK TO CHAT END ===== XxXxX'

exit 0
