<#
RUN_SOURCE_WASH_FULL_CYCLE_V1.3.ps1

Purpose:
  Report-only source wash controller with embedded HELPER_STABILITY_GOVERNOR_V1.

Primary job:
  Read a bounded root, process source files in controlled batches, classify each file as
  source/proof/code-pattern/index/unknown, write ledgers and a receipt, and throttle itself
  when the machine or file set starts getting heavy. V1.3 keeps the widened governor travel
  range, widens the defaults again for smoother movement, and fixes the V1.2 function-return
  array bug that made an empty broad-root check look like one System.String[] reason.

Safety position:
  - Default is PROBE ONLY. No source read happens unless -Run is supplied.
  - Default mode is ReportOnly. This script does not edit, move, delete, stage, commit, push,
    or rewrite project files.
  - It writes only to an output report directory.
  - It blocks broad roots unless -AllowBroadRoot is explicitly supplied.
  - Code Gate PASS proves parser/risk shape only. The receipt produced by an actual -Run is
    the separate job proof.

Intended Code Gate use:
  pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\Documents\Tools\PowerShellCodeGate\POWERSHELL_CODE_GATE_RUNNER_V1.3.ps1" -Target "$env:USERPROFILE\Downloads\RUN_SOURCE_WASH_FULL_CYCLE_V1.3.ps1"

Intended first real run after Code Gate:
  pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\RUN_SOURCE_WASH_FULL_CYCLE_V1.3.ps1" -Run -Root "$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz\HOUSE_WORK\WORK_SHED\SORTING_BENCH" -MaxFiles 175 -MaxDepth 5 -Mode ReportOnly
#>

[CmdletBinding()]
param(
    [string]$Root = "",
    [ValidateSet("ReportOnly")]
    [string]$Mode = "ReportOnly",
    [int]$MaxFiles = 175,
    [int]$MaxDepth = 5,
    [int]$InitialBatchSize = 12,
    [int]$MinBatchSize = 1,
    [int]$MaxBatchSize = 60,
    [int]$InitialSleepMs = 100,
    [int]$MinSleepMs = 10,
    [int]$MaxSleepMs = 7000,
    [int]$MaxReadChars = 100000,
    [int]$LargeFileBytes = 3000000,
    [int]$SoftLatencyMs = 650,
    [int]$HardLatencyMs = 4000,
    [int]$MemorySoftMB = 3000,
    [int]$MemoryHardMB = 6000,
    [int]$ChokeErrorLimit = 20,
    [int]$ChokeRoughSpotLimit = 80,
    [switch]$Run,
    [switch]$AllowBroadRoot,
    [switch]$IncludeHidden,
    [string]$OutRoot = "",
    [switch]$Quiet
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

$ScriptName = "RUN_SOURCE_WASH_FULL_CYCLE_V1.3.ps1"
$ControllerName = "SOURCE_WASH_FULL_CYCLE_V1.3"
$GovernorName = "HELPER_STABILITY_GOVERNOR_V1_EMBEDDED"
$ScriptVersion = "V1.3"
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$StartedAt = Get-Date

function Write-Status {
    param([string]$Message)
    if (-not $Quiet) {
        Write-Host $Message
    }
}

function ConvertTo-SafeText {
    param([object]$Value)
    if ($null -eq $Value) { return "" }
    $text = [string]$Value
    $text = $text -replace "`r", " "
    $text = $text -replace "`n", " "
    return $text.Trim()
}

function New-DirectoryIfMissing {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw "New-DirectoryIfMissing received an empty path."
    }
    if (-not (Test-Path -LiteralPath $Path)) {
        [void](New-Item -ItemType Directory -Path $Path)
    }
}

function Get-DesktopPath {
    $desktop = [Environment]::GetFolderPath("Desktop")
    if ([string]::IsNullOrWhiteSpace($desktop)) {
        return (Join-Path $HOME "Desktop")
    }
    return $desktop
}

function Resolve-FullPathStrict {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw "Required path is empty."
    }
    $resolved = @(Resolve-Path -LiteralPath $Path -ErrorAction Stop)
    if (@($resolved).Count -gt 1) {
        throw "Path resolved to more than one target: $Path"
    }
    if (@($resolved).Count -lt 1) {
        throw "Path did not resolve: $Path"
    }
    return $resolved[0].Path
}

function Test-BroadRoot {
    param([string]$ResolvedRoot)

    $rootFull = [System.IO.Path]::GetFullPath($ResolvedRoot).TrimEnd('\', '/')
    $desktop = [System.IO.Path]::GetFullPath((Get-DesktopPath)).TrimEnd('\', '/')
    $homePath = [System.IO.Path]::GetFullPath($HOME).TrimEnd('\', '/')
    $driveRoot = [System.IO.Path]::GetPathRoot($rootFull).TrimEnd('\', '/')

    $broadReasons = New-Object System.Collections.Generic.List[string]

    if ($rootFull.Equals($driveRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        [void]$broadReasons.Add("root is a drive root")
    }
    if ($rootFull.Equals($homePath, [System.StringComparison]::OrdinalIgnoreCase)) {
        [void]$broadReasons.Add("root is the full user profile")
    }
    if ($rootFull.Equals($desktop, [System.StringComparison]::OrdinalIgnoreCase)) {
        [void]$broadReasons.Add("root is the full Desktop")
    }

    # Return the list as pipeline items. Caller wraps with @(...).
    # Do not comma-wrap the array here; comma-wrapping creates one System.String[] object,
    # which made an empty broad-root result look like Count = 1 in V1.2.
    return $broadReasons.ToArray()
}

function Get-RelativePathSafe {
    param(
        [string]$BasePath,
        [string]$ChildPath
    )
    try {
        $baseUri = [System.Uri]::new(([System.IO.Path]::GetFullPath($BasePath).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar))
        $childUri = [System.Uri]::new([System.IO.Path]::GetFullPath($ChildPath))
        $relativeUri = $baseUri.MakeRelativeUri($childUri)
        $relative = [System.Uri]::UnescapeDataString($relativeUri.ToString())
        return ($relative -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    } catch {
        return $ChildPath
    }
}

function Test-ExcludedDirectoryName {
    param([string]$Name)
    $blocked = @(
        ".git", ".svn", ".hg", "node_modules", ".venv", "venv", "__pycache__",
        ".pytest_cache", ".mypy_cache", ".ruff_cache", ".idea", ".vscode"
    )
    foreach ($item in $blocked) {
        if ($Name.Equals($item, [System.StringComparison]::OrdinalIgnoreCase)) { return $true }
    }
    return $false
}

function Test-ReadableTextExtension {
    param([string]$Extension)
    if ([string]::IsNullOrWhiteSpace($Extension)) { return $false }
    $ext = $Extension.ToLowerInvariant()
    $textExt = @(
        ".md", ".txt", ".ps1", ".psm1", ".psd1", ".json", ".csv", ".yml", ".yaml",
        ".xml", ".html", ".htm", ".css", ".js", ".ts", ".py", ".rb", ".go", ".rs",
        ".java", ".c", ".cpp", ".h", ".hpp", ".cs", ".sql", ".toml", ".ini", ".cfg",
        ".log", ".receipt", ".map", ".manifest"
    )
    return ($textExt -contains $ext)
}

function Get-BoundedFileList {
    param(
        [string]$StartRoot,
        [int]$LimitFiles,
        [int]$DepthLimit,
        [switch]$ShowHidden
    )

    $result = New-Object System.Collections.Generic.List[object]
    $queue = New-Object System.Collections.Generic.Queue[object]
    $queue.Enqueue([pscustomobject]@{ Path = $StartRoot; Depth = 0 })

    while ($queue.Count -gt 0 -and $result.Count -lt $LimitFiles) {
        $node = $queue.Dequeue()
        $currentPath = $node.Path
        $currentDepth = [int]$node.Depth

        try {
            $children = Get-ChildItem -LiteralPath $currentPath -Force:$ShowHidden -ErrorAction Stop | Sort-Object -Property PSIsContainer, Name
        } catch {
            [void]$result.Add([pscustomobject]@{
                FullName = $currentPath
                RelativePath = Get-RelativePathSafe -BasePath $StartRoot -ChildPath $currentPath
                IsDirectoryError = $true
                DirectoryReadError = ConvertTo-SafeText $_.Exception.Message
                Length = 0
                Extension = ""
                LastWriteTime = $null
            })
            continue
        }

        foreach ($child in $children) {
            if ($child.PSIsContainer) {
                if ($currentDepth -lt $DepthLimit -and -not (Test-ExcludedDirectoryName -Name $child.Name)) {
                    $queue.Enqueue([pscustomobject]@{ Path = $child.FullName; Depth = ($currentDepth + 1) })
                }
                continue
            }

            if ($result.Count -ge $LimitFiles) { break }

            [void]$result.Add([pscustomobject]@{
                FullName = $child.FullName
                RelativePath = Get-RelativePathSafe -BasePath $StartRoot -ChildPath $child.FullName
                IsDirectoryError = $false
                DirectoryReadError = ""
                Length = [int64]$child.Length
                Extension = [string]$child.Extension
                LastWriteTime = $child.LastWriteTime
            })
        }
    }

    # Return file entries as pipeline items. Caller wraps with @(...).
    # Do not comma-wrap the array here; comma-wrapping creates one System.Object[] item
    # instead of a normal queue of file-entry objects.
    return $result.ToArray()
}

function Initialize-GovernorState {
    param(
        [int]$StartBatchSize,
        [int]$StartSleepMs
    )
    return [ordered]@{
        Name = $GovernorName
        State = "COLD_START"
        Gear = "LOW"
        BatchSize = $StartBatchSize
        SleepMs = $StartSleepMs
        Processed = 0
        Errors = 0
        RoughSpots = 0
        ConsecutiveSmoothBatches = 0
        ConsecutiveHotBatches = 0
        LastLatencyMs = 0
        MovingLatencyMs = 0
        LastMemoryMB = 0
        LastRpm = 0
        LastDecision = "INIT"
        ThrottleEvents = 0
        RampEvents = 0
        ChokeReason = ""
    }
}

function Get-CurrentMemoryMB {
    try {
        $process = Get-Process -Id $PID -ErrorAction Stop
        return [math]::Round(($process.WorkingSet64 / 1MB), 2)
    } catch {
        return 0
    }
}

function Update-GovernorAfterBatch {
    param(
        [hashtable]$Governor,
        [int]$BatchProcessed,
        [double]$BatchElapsedMs,
        [int]$BatchErrors,
        [int]$BatchRoughSpots,
        [int]$MinimumBatchSize,
        [int]$MaximumBatchSize,
        [int]$MinimumSleepMs,
        [int]$MaximumSleepMs,
        [int]$SoftLatency,
        [int]$HardLatency,
        [int]$SoftMemory,
        [int]$HardMemory,
        [int]$ErrorLimit,
        [int]$RoughSpotLimit
    )

    $perFileMs = 0
    if ($BatchProcessed -gt 0) {
        $perFileMs = [math]::Round(($BatchElapsedMs / $BatchProcessed), 2)
    }

    $oldMoving = [double]$Governor.MovingLatencyMs
    if ($oldMoving -le 0) {
        $newMoving = $perFileMs
    } else {
        $newMoving = [math]::Round((($oldMoving * 0.70) + ($perFileMs * 0.30)), 2)
    }

    $memoryNow = Get-CurrentMemoryMB
    $rpm = 0
    if ($perFileMs -gt 0) {
        $rpm = [math]::Round((60000 / $perFileMs), 2)
    }

    $Governor.LastLatencyMs = $perFileMs
    $Governor.MovingLatencyMs = $newMoving
    $Governor.LastMemoryMB = $memoryNow
    $Governor.LastRpm = $rpm
    $Governor.Errors = [int]$Governor.Errors + $BatchErrors
    $Governor.RoughSpots = [int]$Governor.RoughSpots + $BatchRoughSpots
    $Governor.Processed = [int]$Governor.Processed + $BatchProcessed

    $pressure = "NORMAL"
    $pressureReasons = New-Object System.Collections.Generic.List[string]

    if ($newMoving -ge $HardLatency) { $pressure = "HARD"; [void]$pressureReasons.Add("latency hard") }
    elseif ($newMoving -ge $SoftLatency) { $pressure = "SOFT"; [void]$pressureReasons.Add("latency soft") }

    if ($memoryNow -ge $HardMemory) { $pressure = "HARD"; [void]$pressureReasons.Add("memory hard") }
    elseif ($memoryNow -ge $SoftMemory -and $pressure -eq "NORMAL") { $pressure = "SOFT"; [void]$pressureReasons.Add("memory soft") }

    if ($BatchErrors -gt 0) { $pressure = "SOFT"; [void]$pressureReasons.Add("batch error") }
    if ($BatchRoughSpots -gt 4) { $pressure = "SOFT"; [void]$pressureReasons.Add("rough spots") }

    if ([int]$Governor.Errors -ge $ErrorLimit) {
        $Governor.State = "CHOKE_STOP"
        $Governor.ChokeReason = "error limit reached"
        $Governor.LastDecision = "STOP_CHOKE_ERRORS"
        return $Governor
    }

    if ([int]$Governor.RoughSpots -ge $RoughSpotLimit) {
        $Governor.State = "CHOKE_STOP"
        $Governor.ChokeReason = "rough spot limit reached"
        $Governor.LastDecision = "STOP_CHOKE_ROUGH_SPOTS"
        return $Governor
    }

    if ($pressure -eq "HARD") {
        $Governor.ConsecutiveHotBatches = [int]$Governor.ConsecutiveHotBatches + 1
        $Governor.ConsecutiveSmoothBatches = 0
        $Governor.BatchSize = [math]::Max($MinimumBatchSize, ([int]$Governor.BatchSize - 2))
        $Governor.SleepMs = [math]::Min($MaximumSleepMs, ([int]([int]$Governor.SleepMs * 1.75) + 150))
        $Governor.State = "THROTTLED"
        $Governor.Gear = "LOW"
        $Governor.ThrottleEvents = [int]$Governor.ThrottleEvents + 1
        $Governor.LastDecision = "THROTTLE_HARD: " + (($pressureReasons.ToArray()) -join "; ")
        return $Governor
    }

    if ($pressure -eq "SOFT") {
        $Governor.ConsecutiveHotBatches = [int]$Governor.ConsecutiveHotBatches + 1
        $Governor.ConsecutiveSmoothBatches = 0
        $Governor.BatchSize = [math]::Max($MinimumBatchSize, ([int]$Governor.BatchSize - 1))
        $Governor.SleepMs = [math]::Min($MaximumSleepMs, ([int]([int]$Governor.SleepMs * 1.35) + 50))
        $Governor.State = "WATCH_THROTTLE"
        $Governor.Gear = "MEDIUM_LOW"
        $Governor.ThrottleEvents = [int]$Governor.ThrottleEvents + 1
        $Governor.LastDecision = "THROTTLE_SOFT: " + (($pressureReasons.ToArray()) -join "; ")
        return $Governor
    }

    $Governor.ConsecutiveSmoothBatches = [int]$Governor.ConsecutiveSmoothBatches + 1
    $Governor.ConsecutiveHotBatches = 0

    if ([int]$Governor.ConsecutiveSmoothBatches -ge 2) {
        $Governor.BatchSize = [math]::Min($MaximumBatchSize, ([int]$Governor.BatchSize + 1))
        $Governor.SleepMs = [math]::Max($MinimumSleepMs, ([int]([int]$Governor.SleepMs * 0.80)))
        $Governor.State = "SMOOTH_RAMP"
        $Governor.Gear = "CRUISE"
        $Governor.RampEvents = [int]$Governor.RampEvents + 1
        $Governor.LastDecision = "RAMP_SMOOTH"
    } else {
        $Governor.State = "STABLE"
        $Governor.Gear = "MEDIUM"
        $Governor.LastDecision = "HOLD_STABLE"
    }

    return $Governor
}

function Classify-FileForWash {
    param(
        [string]$Path,
        [string]$RelativePath,
        [string]$Extension,
        [int64]$LengthBytes,
        [string]$SampleText,
        [bool]$WasRead,
        [bool]$ReadError
    )

    $lowerRel = $RelativePath.ToLowerInvariant()
    $ext = ""
    if ($null -ne $Extension) { $ext = $Extension.ToLowerInvariant() }

    $role = "UNKNOWN_REVIEW"
    $decision = "PARK_FOR_REVIEW"
    $reason = "no strong pattern"

    if ($ReadError) {
        return [pscustomobject]@{ Role = "READ_ERROR"; Decision = "PROOF_NEEDED"; Reason = "file could not be read" }
    }

    if (-not $WasRead) {
        return [pscustomobject]@{ Role = "SKIPPED_CONTENT"; Decision = "SKIP_CONTENT_READ"; Reason = "not text or above read limit" }
    }

    if ($lowerRel -like "*proof_history*" -or $lowerRel -like "*receipt*" -or $lowerRel -like "*proof*") {
        $role = "PROOF_CONTEXT"
        $decision = "KEEP_AS_PROOF_CONTEXT"
        $reason = "proof or receipt path/name signal"
    } elseif ($lowerRel -like "*current_house_work_status*" -or $lowerRel -like "*active_anchor*" -or $lowerRel -like "*index*") {
        $role = "INDEX_OR_STATUS_CONTEXT"
        $decision = "KEEP_AS_ORIENTATION_CONTEXT"
        $reason = "index/status path/name signal"
    } elseif ($ext -in @(".ps1", ".psm1", ".psd1", ".py", ".js", ".ts", ".rb", ".go", ".rs", ".cs")) {
        $role = "CODE_PATTERN"
        $decision = "READ_PATTERN_ONLY_FILTER_FIRST"
        $reason = "code file must not be direct reuse"
    } elseif ($lowerRel -like "*source_ore*" -or $lowerRel -like "*sorting_bench*" -or $lowerRel -like "*brain_learning*") {
        $role = "SOURCE_OR_WORKBENCH_ORE"
        $decision = "KEEP_AS_SOURCE_ORE"
        $reason = "source/workbench path signal"
    } elseif ($SampleText -match "(?i)boundary held|no doctrine|not doctrine|CURRENT_TRUTH_INDEX|ACTIVE_GUIDES") {
        $role = "BOUNDARY_OR_AUTHORITY_NOTE"
        $decision = "KEEP_WITH_BOUNDARY_NOTE"
        $reason = "authority/boundary language detected"
    } elseif ($SampleText -match "(?i)verdict|pass with watch|clean_close|blocked|choke_stop") {
        $role = "VERDICT_OR_STATE_NOTE"
        $decision = "KEEP_WITH_PROOF_STATE"
        $reason = "verdict/state language detected"
    } elseif ($ext -in @(".md", ".txt", ".json", ".csv", ".yaml", ".yml")) {
        $role = "TEXT_SOURCE"
        $decision = "KEEP_FOR_REVIEW"
        $reason = "readable text source"
    }

    return [pscustomobject]@{ Role = $role; Decision = $decision; Reason = $reason }
}

function Read-FileSampleSafe {
    param(
        [string]$Path,
        [int]$ReadLimitChars
    )

    $output = [ordered]@{
        WasRead = $false
        Text = ""
        Error = ""
        LineCount = 0
    }

    try {
        $raw = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
        if ($raw.Length -gt $ReadLimitChars) {
            $raw = $raw.Substring(0, $ReadLimitChars)
        }
        $output.WasRead = $true
        $output.Text = $raw
        $output.LineCount = (($raw -split "`n").Count)
    } catch {
        $output.Error = ConvertTo-SafeText $_.Exception.Message
    }

    return $output
}

function Get-FileHashSafe {
    param([string]$Path)
    try {
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256 -ErrorAction Stop).Hash
    } catch {
        return "HASH_ERROR: " + (ConvertTo-SafeText $_.Exception.Message)
    }
}

function Convert-ToCsvCell {
    param([object]$Value)
    $text = ConvertTo-SafeText $Value
    $text = $text -replace '"', '""'
    return '"' + $text + '"'
}

function Add-CsvLine {
    param(
        [string]$Path,
        [object[]]$Cells
    )
    $line = (($Cells | ForEach-Object { Convert-ToCsvCell $_ }) -join ",")
    Add-Content -LiteralPath $Path -Value $line -Encoding UTF8
}

function Write-JsonFile {
    param(
        [string]$Path,
        [object]$Object
    )
    $json = $Object | ConvertTo-Json -Depth 8
    Set-Content -LiteralPath $Path -Value $json -Encoding UTF8
}

function Stop-WithProbeOnly {
    Write-Host "RUN_SOURCE_WASH_FULL_CYCLE_V1_3_CODE_GATE_PROBE"
    Write-Host "EndState: CLEAN_CLOSE"
    Write-Host "Message: Probe only. Supply -Run and a bounded -Root after Code Gate passes."
    Write-Host "Mode: $Mode"
    Write-Host "Governor: $GovernorName"
    Write-Host "Boundary: no source read, no move, no delete, no Git, no automation."
    exit 0
}

if (-not $Run) {
    Stop-WithProbeOnly
}

if ($MaxFiles -lt 1) { throw "MaxFiles must be at least 1." }
if ($MaxDepth -lt 0) { throw "MaxDepth must be 0 or greater." }
if ($InitialBatchSize -lt 1) { throw "InitialBatchSize must be at least 1." }
if ($MinBatchSize -lt 1) { throw "MinBatchSize must be at least 1." }
if ($MaxBatchSize -lt $MinBatchSize) { throw "MaxBatchSize cannot be smaller than MinBatchSize." }
if ($InitialSleepMs -lt 0) { throw "InitialSleepMs must be 0 or greater." }
if ($MaxSleepMs -lt $MinSleepMs) { throw "MaxSleepMs cannot be smaller than MinSleepMs." }
if ($MaxReadChars -lt 1000) { throw "MaxReadChars must be at least 1000." }

$ResolvedRoot = Resolve-FullPathStrict -Path $Root
if (-not (Test-Path -LiteralPath $ResolvedRoot -PathType Container)) {
    throw "Root must be an existing directory: $ResolvedRoot"
}

$broadReasons = @(Test-BroadRoot -ResolvedRoot $ResolvedRoot)
if (@($broadReasons).Count -gt 0 -and -not $AllowBroadRoot) {
    $joined = ($broadReasons -join "; ")
    throw "Blocked broad root: $joined. Pick a narrower project folder or rerun with -AllowBroadRoot intentionally."
}

if ([string]::IsNullOrWhiteSpace($OutRoot)) {
    $desktop = Get-DesktopPath
    $OutRoot = Join-Path $desktop "123\_MISC_DRAWER\READ_REPORTS"
}

New-DirectoryIfMissing -Path $OutRoot
$RunDir = Join-Path $OutRoot ("FULL_WASH_CYCLE_V1_3_" + $RunId)
New-DirectoryIfMissing -Path $RunDir

$StateJson = Join-Path $RunDir "state.json"
$ReportMd = Join-Path $RunDir "SOURCE_WASH_FULL_CYCLE_V1_3_REPORT.md"
$DecisionCsv = Join-Path $RunDir "decision_ledger.csv"
$RoughCsv = Join-Path $RunDir "rough_spot_ledger.csv"
$GovernorCsv = Join-Path $RunDir "governor_telemetry.csv"
$ReceiptTxt = Join-Path $RunDir "SOURCE_WASH_FULL_CYCLE_V1_3_RECEIPT.txt"
$RopeLedgerMd = Join-Path $RunDir "rope_ledger.md"

Set-Content -LiteralPath $DecisionCsv -Value 'RunId,Sequence,RelativePath,FullPath,Extension,Bytes,SHA256,WasRead,LineCount,Role,Decision,Reason,ElapsedMs,GovernorState,GovernorGear,GovernorBatchSize,GovernorSleepMs,Error' -Encoding UTF8
Set-Content -LiteralPath $RoughCsv -Value 'RunId,Sequence,RelativePath,IssueType,IssueDetail,Decision' -Encoding UTF8
Set-Content -LiteralPath $GovernorCsv -Value 'RunId,BatchNumber,BatchProcessed,BatchElapsedMs,PerFileMs,MovingLatencyMs,MemoryMB,RPM,State,Gear,BatchSize,SleepMs,Decision,TotalErrors,TotalRoughSpots' -Encoding UTF8

$governor = Initialize-GovernorState -StartBatchSize $InitialBatchSize -StartSleepMs $InitialSleepMs
$fileList = @(Get-BoundedFileList -StartRoot $ResolvedRoot -LimitFiles $MaxFiles -DepthLimit $MaxDepth -ShowHidden:$IncludeHidden)
$totalDiscovered = @($fileList).Count

Write-Status "SOURCE WASH FULL CYCLE V1.3"
Write-Status "Mode: $Mode"
Write-Status "Root: $ResolvedRoot"
Write-Status "RunDir: $RunDir"
Write-Status "Files queued: $totalDiscovered"
Write-Status "Governor: $GovernorName"

$summary = [ordered]@{
    RunId = $RunId
    Controller = $ControllerName
    ScriptVersion = $ScriptVersion
    Governor = $GovernorName
    Mode = $Mode
    Root = $ResolvedRoot
    OutRoot = $OutRoot
    RunDir = $RunDir
    StartedAt = $StartedAt.ToString("o")
    EndedAt = ""
    MaxFiles = $MaxFiles
    MaxDepth = $MaxDepth
    MaxReadChars = $MaxReadChars
    TotalQueued = $totalDiscovered
    Processed = 0
    ReadCount = 0
    SkippedCount = 0
    ErrorCount = 0
    RoughSpotCount = 0
    EndState = "RUNNING"
    WashVerdict = "RUNNING"
    Boundary = "report-only; no source writes; no move/delete; no Git; no doctrine"
    GovernorFinal = $governor
}

$roleCounts = @{}
$decisionCounts = @{}
$batchNumber = 0
$sequence = 0
$index = 0

while ($index -lt @($fileList).Count) {
    if ([string]$governor.State -eq "CHOKE_STOP") { break }

    $batchNumber += 1
    $currentBatchSize = [int]$governor.BatchSize
    if ($currentBatchSize -lt $MinBatchSize) { $currentBatchSize = $MinBatchSize }
    if ($currentBatchSize -gt $MaxBatchSize) { $currentBatchSize = $MaxBatchSize }

    $batchItems = @()
    for ($b = 0; $b -lt $currentBatchSize -and $index -lt @($fileList).Count; $b++) {
        $batchItems += $fileList[$index]
        $index += 1
    }

    $batchSw = [System.Diagnostics.Stopwatch]::StartNew()
    $batchErrors = 0
    $batchRough = 0
    $batchProcessed = 0

    foreach ($item in $batchItems) {
        $sequence += 1
        $fileSw = [System.Diagnostics.Stopwatch]::StartNew()
        $errorText = ""
        $sha = ""
        $wasRead = $false
        $lineCount = 0
        $role = "UNKNOWN_REVIEW"
        $decision = "PARK_FOR_REVIEW"
        $reason = "not processed"
        $roughForFile = 0

        try {
            if ($item.IsDirectoryError) {
                $batchErrors += 1
                $errorText = $item.DirectoryReadError
                $role = "DIRECTORY_READ_ERROR"
                $decision = "PROOF_NEEDED"
                $reason = "directory read failed during bounded inventory"
                Add-CsvLine -Path $RoughCsv -Cells @($RunId, $sequence, $item.RelativePath, "DIRECTORY_READ_ERROR", $errorText, $decision)
                $roughForFile += 1
            } else {
                $isText = Test-ReadableTextExtension -Extension $item.Extension
                $isLarge = ([int64]$item.Length -gt [int64]$LargeFileBytes)
                $sha = Get-FileHashSafe -Path $item.FullName

                if (-not $isText) {
                    $role = "NON_TEXT_OR_UNSUPPORTED"
                    $decision = "SKIP_CONTENT_READ"
                    $reason = "extension not in text-safe list"
                    $summary.SkippedCount = [int]$summary.SkippedCount + 1
                    Add-CsvLine -Path $RoughCsv -Cells @($RunId, $sequence, $item.RelativePath, "INFO_SKIP_NON_TEXT", $item.Extension, $decision)
                    # Normal non-text files are parked/read-skipped, not treated as governor roughness.
                } elseif ($isLarge) {
                    $role = "LARGE_TEXT_SKIPPED"
                    $decision = "SKIP_CONTENT_READ_KEEP_HASH"
                    $reason = "above LargeFileBytes limit"
                    $summary.SkippedCount = [int]$summary.SkippedCount + 1
                    Add-CsvLine -Path $RoughCsv -Cells @($RunId, $sequence, $item.RelativePath, "SKIP_LARGE_TEXT", $item.Length, $decision)
                    $roughForFile += 1
                } else {
                    $read = Read-FileSampleSafe -Path $item.FullName -ReadLimitChars $MaxReadChars
                    $wasRead = [bool]$read.WasRead
                    $lineCount = [int]$read.LineCount
                    if (-not $wasRead) {
                        $batchErrors += 1
                        $errorText = $read.Error
                        $classification = Classify-FileForWash -Path $item.FullName -RelativePath $item.RelativePath -Extension $item.Extension -LengthBytes $item.Length -SampleText "" -WasRead:$false -ReadError:$true
                        $role = $classification.Role
                        $decision = $classification.Decision
                        $reason = $classification.Reason
                        Add-CsvLine -Path $RoughCsv -Cells @($RunId, $sequence, $item.RelativePath, "READ_ERROR", $errorText, $decision)
                        $roughForFile += 1
                    } else {
                        $summary.ReadCount = [int]$summary.ReadCount + 1
                        $classification = Classify-FileForWash -Path $item.FullName -RelativePath $item.RelativePath -Extension $item.Extension -LengthBytes $item.Length -SampleText $read.Text -WasRead:$true -ReadError:$false
                        $role = $classification.Role
                        $decision = $classification.Decision
                        $reason = $classification.Reason
                    }
                }
            }
        } catch {
            $batchErrors += 1
            $errorText = ConvertTo-SafeText $_.Exception.Message
            $role = "PROCESSING_ERROR"
            $decision = "PROOF_NEEDED"
            $reason = "exception during file processing"
            Add-CsvLine -Path $RoughCsv -Cells @($RunId, $sequence, $item.RelativePath, "PROCESSING_ERROR", $errorText, $decision)
            $roughForFile += 1
        } finally {
            $fileSw.Stop()
        }

        if (-not $roleCounts.ContainsKey($role)) { $roleCounts[$role] = 0 }
        if (-not $decisionCounts.ContainsKey($decision)) { $decisionCounts[$decision] = 0 }
        $roleCounts[$role] = [int]$roleCounts[$role] + 1
        $decisionCounts[$decision] = [int]$decisionCounts[$decision] + 1

        if ($roughForFile -gt 0) { $batchRough += $roughForFile }

        Add-CsvLine -Path $DecisionCsv -Cells @(
            $RunId,
            $sequence,
            $item.RelativePath,
            $item.FullName,
            $item.Extension,
            $item.Length,
            $sha,
            $wasRead,
            $lineCount,
            $role,
            $decision,
            $reason,
            $fileSw.ElapsedMilliseconds,
            $governor.State,
            $governor.Gear,
            $governor.BatchSize,
            $governor.SleepMs,
            $errorText
        )

        $batchProcessed += 1
        $summary.Processed = [int]$summary.Processed + 1
    }

    $batchSw.Stop()
    $governor = Update-GovernorAfterBatch `
        -Governor $governor `
        -BatchProcessed $batchProcessed `
        -BatchElapsedMs $batchSw.Elapsed.TotalMilliseconds `
        -BatchErrors $batchErrors `
        -BatchRoughSpots $batchRough `
        -MinimumBatchSize $MinBatchSize `
        -MaximumBatchSize $MaxBatchSize `
        -MinimumSleepMs $MinSleepMs `
        -MaximumSleepMs $MaxSleepMs `
        -SoftLatency $SoftLatencyMs `
        -HardLatency $HardLatencyMs `
        -SoftMemory $MemorySoftMB `
        -HardMemory $MemoryHardMB `
        -ErrorLimit $ChokeErrorLimit `
        -RoughSpotLimit $ChokeRoughSpotLimit

    $perFile = 0
    if ($batchProcessed -gt 0) { $perFile = [math]::Round(($batchSw.Elapsed.TotalMilliseconds / $batchProcessed), 2) }

    Add-CsvLine -Path $GovernorCsv -Cells @(
        $RunId,
        $batchNumber,
        $batchProcessed,
        [math]::Round($batchSw.Elapsed.TotalMilliseconds, 2),
        $perFile,
        $governor.MovingLatencyMs,
        $governor.LastMemoryMB,
        $governor.LastRpm,
        $governor.State,
        $governor.Gear,
        $governor.BatchSize,
        $governor.SleepMs,
        $governor.LastDecision,
        $governor.Errors,
        $governor.RoughSpots
    )

    Write-Status ("Batch {0}: processed {1}; state {2}; gear {3}; batch {4}; sleep {5}ms; rpm {6}; decision {7}" -f $batchNumber, $batchProcessed, $governor.State, $governor.Gear, $governor.BatchSize, $governor.SleepMs, $governor.LastRpm, $governor.LastDecision)

    if ([string]$governor.State -eq "CHOKE_STOP") { break }

    if ([int]$governor.SleepMs -gt 0) {
        Start-Sleep -Milliseconds ([int]$governor.SleepMs)
    }
}

$EndedAt = Get-Date
$summary.EndedAt = $EndedAt.ToString("o")
$summary.ErrorCount = [int]$governor.Errors
$summary.RoughSpotCount = [int]$governor.RoughSpots
$summary.GovernorFinal = $governor

if ([string]$governor.State -eq "CHOKE_STOP") {
    $summary.EndState = "CHOKE_STOP"
    $summary.WashVerdict = "WASH_STOPPED_BY_GOVERNOR"
} elseif ([int]$summary.Processed -eq 0) {
    $summary.EndState = "BLOCKED_WITH_RETURN_POINT"
    $summary.WashVerdict = "NO_FILES_PROCESSED"
} elseif ([int]$summary.RoughSpotCount -gt 0) {
    $summary.EndState = "B_CLEAN_CLOSE"
    $summary.WashVerdict = "WASH_WITH_PARKED_ITEMS"
} else {
    $summary.EndState = "B_CLEAN_CLOSE"
    $summary.WashVerdict = "WASH_CLEAN_REPORT_ONLY"
}

$roleLines = New-Object System.Collections.Generic.List[string]
foreach ($key in ($roleCounts.Keys | Sort-Object)) {
    [void]$roleLines.Add(("- {0}: {1}" -f $key, $roleCounts[$key]))
}
if ($roleLines.Count -eq 0) { [void]$roleLines.Add("- none") }

$decisionLines = New-Object System.Collections.Generic.List[string]
foreach ($key in ($decisionCounts.Keys | Sort-Object)) {
    [void]$decisionLines.Add(("- {0}: {1}" -f $key, $decisionCounts[$key]))
}
if ($decisionLines.Count -eq 0) { [void]$decisionLines.Add("- none") }

$report = @"
# Source Wash Full Cycle V1.3 Report

RunId: $RunId
Controller: $ControllerName
Script: $ScriptName
ScriptVersion: $ScriptVersion
Governor: $GovernorName
Mode: $Mode
Root: $ResolvedRoot
RunDir: $RunDir
StartedAt: $($StartedAt.ToString("o"))
EndedAt: $($EndedAt.ToString("o"))

## Final State

EndState: $($summary.EndState)
WashVerdict: $($summary.WashVerdict)
Processed: $($summary.Processed)
Queued: $($summary.TotalQueued)
ReadCount: $($summary.ReadCount)
SkippedCount: $($summary.SkippedCount)
ErrorCount: $($summary.ErrorCount)
RoughSpotCount: $($summary.RoughSpotCount)

## Governor Final

State: $($governor.State)
Gear: $($governor.Gear)
BatchSize: $($governor.BatchSize)
SleepMs: $($governor.SleepMs)
MovingLatencyMs: $($governor.MovingLatencyMs)
LastMemoryMB: $($governor.LastMemoryMB)
LastRPM: $($governor.LastRpm)
ThrottleEvents: $($governor.ThrottleEvents)
RampEvents: $($governor.RampEvents)
LastDecision: $($governor.LastDecision)
ChokeReason: $($governor.ChokeReason)

## Role Counts

$($roleLines.ToArray() -join "`n")

## Decision Counts

$($decisionLines.ToArray() -join "`n")

## Ledgers

- DecisionLedger: $DecisionCsv
- RoughSpotLedger: $RoughCsv
- GovernorTelemetry: $GovernorCsv
- StateJson: $StateJson
- RopeLedger: $RopeLedgerMd
- Receipt: $ReceiptTxt

## Boundary

Report-only controller. No source writes. No move/delete. No Git. No doctrine. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX. No automation.

## Close Standard

Code Gate PASS is not job PASS. This report and receipt are the job evidence for the bounded run only.
"@

Set-Content -LiteralPath $ReportMd -Value $report -Encoding UTF8

$rope = @"
# Rope Ledger - Source Wash Full Cycle V1.3

RunId: $RunId
Root: $ResolvedRoot
Object: bounded report-only source wash
Governor: $GovernorName

## Rope Notes

1. Entered through explicit -Run and bounded -Root.
2. Inventory stayed within MaxFiles=$MaxFiles and MaxDepth=$MaxDepth.
3. Content reading stayed within MaxReadChars=$MaxReadChars and LargeFileBytes=$LargeFileBytes.
4. Code files were marked pattern-only/filter-first, not direct reuse.
5. Rough items were parked in the rough spot ledger, not repaired in place.
6. Governor adjusted BatchSize and SleepMs from live batch telemetry.
7. End state was named separately from Code Gate parser status.

## Return Point

Inspect the receipt, report, decision ledger, rough spot ledger, and governor telemetry before changing MaxFiles, MaxDepth, or promotion state.
"@
Set-Content -LiteralPath $RopeLedgerMd -Value $rope -Encoding UTF8

Write-JsonFile -Path $StateJson -Object $summary

$receipt = @"
XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX
SOURCE_WASH_FULL_CYCLE_V1_3_COMPLETE
EndState: $($summary.EndState)
WashVerdict: $($summary.WashVerdict)
Message: Report-only source wash completed with embedded helper stability governor.
RepoOrRoot: $ResolvedRoot
RunId: $RunId
RunDir: $RunDir
Report: $ReportMd
DecisionLedger: $DecisionCsv
RoughSpotLedger: $RoughCsv
GovernorTelemetry: $GovernorCsv
StateJson: $StateJson
RopeLedger: $RopeLedgerMd
Processed: $($summary.Processed)
Queued: $($summary.TotalQueued)
ReadCount: $($summary.ReadCount)
SkippedCount: $($summary.SkippedCount)
ErrorCount: $($summary.ErrorCount)
RoughSpotCount: $($summary.RoughSpotCount)
GovernorState: $($governor.State)
GovernorGear: $($governor.Gear)
GovernorBatchSize: $($governor.BatchSize)
GovernorSleepMs: $($governor.SleepMs)
GovernorMovingLatencyMs: $($governor.MovingLatencyMs)
GovernorLastMemoryMB: $($governor.LastMemoryMB)
GovernorLastRPM: $($governor.LastRpm)
GovernorThrottleEvents: $($governor.ThrottleEvents)
GovernorRampEvents: $($governor.RampEvents)
Boundary: report-only; no source writes; no move/delete; no Git; no doctrine; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX; no automation.
XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX
"@
Set-Content -LiteralPath $ReceiptTxt -Value $receipt -Encoding UTF8

Write-Host $receipt

if ($summary.EndState -eq "CHOKE_STOP") {
    exit 2
}

exit 0
