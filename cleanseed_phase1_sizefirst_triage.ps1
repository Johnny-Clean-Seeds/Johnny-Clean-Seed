param(
  [string]$TargetPath = 'C:\Users\13527\Desktop\New folder (2)'
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $TargetPath -PathType Container)) {
  Write-Output "FAIL - target folder not found"
  Write-Output "Checked path:"
  Write-Output $TargetPath
  exit 1
}

$timestamp = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
$reportDir = Join-Path (Split-Path $TargetPath -Parent) "CLEANUP_TRIAGE_REPORT_PHASE1_$timestamp"
New-Item -Path $reportDir -ItemType Directory -Force | Out-Null

$readableExts = '.txt','.md','.html','.htm','.css','.js','.json','.csv','.xml','.ps1'
$riskyExts = '.exe','.dll','.msi','.bat','.cmd','.vbs','.com','.scr','.jar','.py','.ps1','.lnk'

$files = Get-ChildItem -LiteralPath $TargetPath -Recurse -File -Force -ErrorAction SilentlyContinue |
  Where-Object {
    -not ($_.Attributes -band [IO.FileAttributes]::Hidden) -and
    -not ($_.Attributes -band [IO.FileAttributes]::System) -and
    -not ($_.Attributes -band [IO.FileAttributes]::ReparsePoint)
  }

$sizeGroups = $files | Group-Object -Property Length
$hashNeededPaths = @{}
foreach ($g in $sizeGroups) {
  if ($g.Count -gt 1) {
    foreach ($f in $g.Group) {
      $hashNeededPaths[$f.FullName] = $true
    }
  }
}

$manifest = New-Object System.Collections.Generic.List[object]
$textInventory = New-Object System.Collections.Generic.List[object]
$riskySkipped = New-Object System.Collections.Generic.List[object]
$emptyFiles = New-Object System.Collections.Generic.List[object]
$shaMap = @{}

foreach ($f in $files) {
  $full = $f.FullName
  $ext = [IO.Path]::GetExtension($full).ToLowerInvariant()
  $readable = if ($readableExts -contains $ext) { 'YES' } else { 'NO' }
  $risky = if ($riskyExts -contains $ext) { 'YES' } else { 'NO' }

  if ($hashNeededPaths.ContainsKey($full)) {
    try {
      $sha = (Get-FileHash -LiteralPath $full -Algorithm SHA256 -ErrorAction Stop).Hash
    } catch {
      $sha = 'ERROR'
    }
  } else {
    $sha = 'NOT_NEEDED_UNIQUE_SIZE'
  }

  $manifest.Add([PSCustomObject]@{
    Path = $full
    FileName = $f.Name
    Extension = $ext
    Size = $f.Length
    ModifiedUtc = $f.LastWriteTimeUtc.ToString('o')
    SHA256 = $sha
    ReadableText = $readable
    RiskyOrSkipped = $risky
  })

  if ($sha -ne 'ERROR' -and $sha -ne 'NOT_NEEDED_UNIQUE_SIZE') {
    if (-not $shaMap.ContainsKey($sha)) {
      $shaMap[$sha] = New-Object System.Collections.ArrayList
    }
    [void]$shaMap[$sha].Add($full)
  }

  if ($f.Length -eq 0) {
    $emptyFiles.Add([PSCustomObject]@{
      Path = $full
      Size = $f.Length
    })
  }

  if ($risky -eq 'YES' -or $readable -eq 'NO') {
    $riskySkipped.Add([PSCustomObject]@{
      Path = $full
      Extension = $ext
      Size = $f.Length
      Reason = if ($risky -eq 'YES') { 'RISKY_OR_EXECUTABLE_LIKE_OR_SCRIPT' } else { 'NOT_READABLE_TEXT_TYPE' }
    })
  }

  if ($readable -eq 'YES') {
    try {
      $raw = Get-Content -LiteralPath $full -Raw -ErrorAction Stop
    } catch {
      try {
        $raw = Get-Content -LiteralPath $full -Raw -Encoding Default -ErrorAction Stop
      } catch {
        $raw = $null
      }
    }

    if ($null -ne $raw) {
      $norm = $raw -replace "`r`n", "`n"
      $norm = $norm -replace "`r", "`n"
      $norm = $norm -replace '[ \t]{2,}', ' '
      $norm = $norm -replace "(`n\s*){3,}", "`n`n"
      $norm = $norm.Trim()

      $bytes = [System.Text.Encoding]::UTF8.GetBytes($norm)
      $shaObj = [System.Security.Cryptography.SHA256]::Create()
      $hashBytes = $shaObj.ComputeHash($bytes)
      $normHash = ($hashBytes | ForEach-Object { $_.ToString("x2") }) -join ''

      $textInventory.Add([PSCustomObject]@{
        Path = $full
        Extension = $ext
        NormalizedHash = $normHash
        NormalizedLength = $bytes.Length
      })
    } else {
      $textInventory.Add([PSCustomObject]@{
        Path = $full
        Extension = $ext
        NormalizedHash = 'ERROR_READING'
        NormalizedLength = 0
      })
    }
  }
}

$manifest | Export-Csv -Path (Join-Path $reportDir 'manifest.csv') -NoTypeInformation -Encoding UTF8
$textInventory | Export-Csv -Path (Join-Path $reportDir 'text_inventory.csv') -NoTypeInformation -Encoding UTF8
$riskySkipped | Export-Csv -Path (Join-Path $reportDir 'risky_skipped.csv') -NoTypeInformation -Encoding UTF8
$emptyFiles | Export-Csv -Path (Join-Path $reportDir 'empty_files.csv') -NoTypeInformation -Encoding UTF8

$duplicateGroups = @()
foreach ($k in $shaMap.Keys) {
  $paths = $shaMap[$k]
  if ($paths.Count -gt 1) {
    $keeper = $paths | Sort-Object { (Get-Item -LiteralPath $_).LastWriteTimeUtc } -Descending | Select-Object -First 1
    $dupes = $paths | Where-Object { $_ -ne $keeper }

    $duplicateGroups += [PSCustomObject]@{
      SHA256 = $k
      Count = $paths.Count
      KeeperCandidate = $keeper
      DuplicateCandidates = ($dupes -join '; ')
    }
  }
}
$duplicateGroups | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $reportDir 'duplicates.json') -Encoding UTF8

$normGroups = $textInventory |
  Where-Object { $_.NormalizedHash -ne 'ERROR_READING' } |
  Group-Object -Property NormalizedHash |
  Where-Object { $_.Count -gt 1 } |
  ForEach-Object {
    [PSCustomObject]@{
      NormalizedHash = $_.Name
      Count = $_.Count
      Paths = (($_.Group | ForEach-Object { $_.Path }) -join '; ')
    }
  }

$normGroups | Export-Csv -Path (Join-Path $reportDir 'normalized_duplicates.csv') -NoTypeInformation -Encoding UTF8

$totalFiles = $files.Count
$totalSize = ($files | Measure-Object -Property Length -Sum).Sum
$exactDupGroupsCount = ($duplicateGroups | Measure-Object).Count
$normalizedDupGroupsCount = ($normGroups | Measure-Object).Count
$readableTextFileCount = ($textInventory | Measure-Object).Count
$riskySkippedCount = ($riskySkipped | Measure-Object).Count
$emptyFileCount = ($emptyFiles | Measure-Object).Count

$goldPan = [PSCustomObject]@{
  Phase = 'PHASE1_SIZE_FIRST'
  Target = $TargetPath
  ReportFolder = $reportDir
  TotalFiles = $totalFiles
  TotalSizeBytes = $totalSize
  ExactDuplicateGroups = $exactDupGroupsCount
  NormalizedDuplicateGroups = $normalizedDupGroupsCount
  ReadableTextFiles = $readableTextFileCount
  RiskySkipped = $riskySkippedCount
  EmptyFiles = $emptyFileCount
  Rule = 'Size-first hash: SHA256 only computed for exact byte-size collision groups.'
  NextRecommendedPhase = 'Review Phase 1 reports before any containment, blended-gold, near-duplicate, or cleanup work.'
}

$goldPan | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $reportDir 'gold_pan_index_phase1.json') -Encoding UTF8

@"
CLEANSEED PHASE 1 SIZE-FIRST TRIAGE REPORT

Target:
$TargetPath

Report folder:
$reportDir

Boundaries:
Read-only source inspection.
No delete.
No move.
No rename.
No source edits.
No script execution from target.
No archive extraction.
No symlink following.
No hidden/system files included.
No active guide updates.
No CURRENT_TRUTH_INDEX updates.

Phase 1 only:
manifest
size-first SHA256 exact duplicates
readable text inventory
normalized exact text duplicates
risky/skipped list
empty files list
gold pan index
"@ | Set-Content -Path (Join-Path $reportDir 'README.txt') -Encoding UTF8

Write-Output "REPORT_DIR=$reportDir"
Write-Output "TOTAL_FILES=$totalFiles"
Write-Output "TOTAL_SIZE_BYTES=$totalSize"
Write-Output "EXACT_DUP_GROUPS=$exactDupGroupsCount"
Write-Output "NORMALIZED_DUP_GROUPS=$normalizedDupGroupsCount"
Write-Output "READABLE_TEXT_FILES=$readableTextFileCount"
Write-Output "RISKY_SKIPPED=$riskySkippedCount"
Write-Output "EMPTY_FILES=$emptyFileCount"
Write-Output "DONE"

