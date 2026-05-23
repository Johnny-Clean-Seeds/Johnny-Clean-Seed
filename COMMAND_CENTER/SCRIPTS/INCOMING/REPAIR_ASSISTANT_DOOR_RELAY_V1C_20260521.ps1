# THIS CODE IS FOR LOCAL.
# REPAIR_ASSISTANT_DOOR_RELAY_V1C_20260521.ps1
# Purpose: repair Assistant Door Relay V1B line-119 native cmd failure and prove a bounded manual door relay.
# Repair root: V1B used cmd.exe dir to locate old jobs; "File Not Found" surfaced as a native command error.
# V1C uses PowerShell-only bounded searches inside Child Shell and tries to clone the known-good Level 1 job shape.
# Boundary: no repo write, no git write, no delete, no cleanup, no broad crawl, no arbitrary shell, no raw command, no Level 3 save.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Stop-Custody {
    param([string]$Message)
    Write-Host "FOG / CUSTODY FAIL: STOP"
    Write-Host $Message
    exit 1
}

function New-DirectoryIfMissing {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Write-NewFileStrict {
    param([string]$Path, [string]$Content)
    if (Test-Path -LiteralPath $Path) {
        Stop-Custody "Refusing to overwrite existing file: $Path"
    }
    $Parent = Split-Path -Parent $Path
    if ($Parent) { New-DirectoryIfMissing $Parent }
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Get-HashOrMissing {
    param([string]$Path)
    if ($Path -and (Test-Path -LiteralPath $Path)) {
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    }
    return "[missing]"
}

function Find-InChildShell {
    param(
        [string]$ChildShellRoot,
        [string]$Pattern
    )
    if (-not (Test-Path -LiteralPath $ChildShellRoot)) { return @() }
    return @(Get-ChildItem -LiteralPath $ChildShellRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like $Pattern -or $_.FullName -like "*$Pattern*" } |
        Select-Object -ExpandProperty FullName)
}

function Try-RunPsFile {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return "[missing: $Path]" }
    try {
        return (& powershell -NoProfile -ExecutionPolicy Bypass -File $Path *>&1 | Out-String).Trim()
    }
    catch {
        return "ERROR running $Path : $($_.Exception.Message)"
    }
}

$Now = Get-Date
$Date = $Now.ToString("yyyyMMdd")
$Stamp = $Now.ToString("yyyyMMdd_HHmmss")
$IsoNow = $Now.ToString("o")
$RunId = "ASSISTANT_DOOR_RELAY_V1C_REPAIR_$Stamp"

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$ChildShell = Join-Path $CommandCenter "CHILD_SHELL"
$Dropzone = Join-Path $ChildShell "DROPZONE"
$Outbox = Join-Path $ChildShell "OUTBOX"
$Watcher = Join-Path $ChildShell "WATCHER"
$Runners = Join-Path $ChildShell "RUNNERS"
$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"

$RelayRoot = Join-Path $CommandCenter "ASSISTANT_DOOR_RELAY"
$RelayTools = Join-Path $RelayRoot "TOOLS"
$RelayRuns = Join-Path $RelayRoot "RUNS"
$RelayReceipts = Join-Path $RelayRoot "RECEIPTS"
$RunDir = Join-Path $RelayRuns $RunId

$HelperPath = Join-Path $RelayTools "DROP_CHAT_JOB_FROM_CLIPBOARD_V1C_TEMPLATE_DISPATCH.ps1"
$JournalPath = Join-Path $RunDir "JOURNAL_ENTRY_$Stamp.md"
$ScanPath = Join-Path $RunDir "DEEP_SCAN_SUMMARY_$Stamp.md"
$RepairReceiptPath = Join-Path $RelayReceipts "ASSISTANT_DOOR_RELAY_V1C_REPAIR_RECEIPT_$Stamp.txt"

if (-not (Test-Path -LiteralPath $Root123)) { Stop-Custody "123 root missing: $Root123" }
if (-not (Test-Path -LiteralPath $CommandCenter)) { Stop-Custody "Command Center missing: $CommandCenter" }
if (-not (Test-Path -LiteralPath $ChildShell)) { Stop-Custody "Child Shell missing: $ChildShell" }
if (-not (Test-Path -LiteralPath $Dropzone)) { Stop-Custody "DROPZONE missing: $Dropzone" }
if (-not (Test-Path -LiteralPath $Outbox)) { Stop-Custody "OUTBOX missing: $Outbox" }
if (-not (Test-Path -LiteralPath (Join-Path $Repo ".git"))) { Stop-Custody "Mr.Kleen repo .git missing: $Repo" }

Push-Location $Repo
try {
    $RepoHeadShort = (git rev-parse --short HEAD).Trim()
    $RepoHeadFull = (git rev-parse HEAD).Trim()
    $RepoOriginFull = (git rev-parse origin/main).Trim()
    $RepoStatusRaw = (git status --short | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($RepoStatusRaw)) {
        $RepoStatusText = "clean"
    } else {
        Stop-Custody "Mr.Kleen repo is not clean before repair/test. Status:`n$RepoStatusRaw"
    }
}
finally {
    Pop-Location
}

New-DirectoryIfMissing $RelayRoot
New-DirectoryIfMissing $RelayTools
New-DirectoryIfMissing $RelayRuns
New-DirectoryIfMissing $RelayReceipts
New-DirectoryIfMissing $RunDir

$EnsureWatcher = Join-Path $Watcher "ENSURE_CHILD_SHELL_WATCHER_RUNNING.ps1"
$StartWatcher = Join-Path $Watcher "START_CHILD_SHELL_WATCHER.ps1"
$StatusBridge = Join-Path $Watcher "STATUS_CHILD_SHELL_BRIDGE.ps1"
$DispatcherOnce = Join-Path $Runners "RUN_CHILD_SHELL_DISPATCH_ONCE.ps1"
$Level1Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"

if (-not (Test-Path -LiteralPath $DispatcherOnce)) {
    Stop-Custody "Dispatcher once runner missing: $DispatcherOnce"
}

$OldFailedJobId = "CHILDJOB-20260521-125636-ASSISTANT-DOOR-READ-STATUS-TEST"
$OldLocationMatches = Find-InChildShell -ChildShellRoot $ChildShell -Pattern "*$OldFailedJobId*"
if ($OldLocationMatches.Count -eq 0) {
    $OldLocationReport = "[old failed V1 job not found in Child Shell lanes]"
} else {
    $OldLocationReport = ($OldLocationMatches -join "`n")
}

$KnownGoodLevel1JobId = "CHILDJOB-20260521-000009-LEVEL1-REGRESSION-READ-STATUS"
$KnownGoodMatches = Find-InChildShell -ChildShellRoot $ChildShell -Pattern "*$KnownGoodLevel1JobId*.childjob.json"
$KnownGoodJobPath = $null
if ($KnownGoodMatches.Count -gt 0) {
    $KnownGoodJobPath = $KnownGoodMatches[0]
}
$KnownGoodJobHash = Get-HashOrMissing $KnownGoodJobPath

$BeforeStatusOutput = Try-RunPsFile -Path $StatusBridge

$HelperContent = @'
# THIS CODE IS FOR LOCAL.
# DROP_CHAT_JOB_FROM_CLIPBOARD_V1C_TEMPLATE_DISPATCH.ps1
# Purpose: bounded manual relay from clipboard JSON to Child Shell using watcher ensure and dispatcher-once fallback.
# Allowed V1C action: read_command_center_status only.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail-Relay {
    param([string]$Message)
    Write-Host "ASSISTANT DOOR RELAY V1C FAIL"
    Write-Host $Message
    exit 1
}

function Wait-Receipt {
    param([string]$ReceiptPath, [int]$Seconds)
    $Deadline = (Get-Date).AddSeconds($Seconds)
    while ((Get-Date) -lt $Deadline) {
        if (Test-Path -LiteralPath $ReceiptPath) { return $true }
        Start-Sleep -Seconds 1
    }
    return (Test-Path -LiteralPath $ReceiptPath)
}

function Find-ChildJobLocations {
    param([string]$ChildShellRoot, [string]$JobId)
    if (-not (Test-Path -LiteralPath $ChildShellRoot)) { return @() }
    return @(Get-ChildItem -LiteralPath $ChildShellRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like "*$JobId*" } |
        Select-Object -ExpandProperty FullName)
}

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$ChildShell = Join-Path $CommandCenter "CHILD_SHELL"
$Dropzone = Join-Path $ChildShell "DROPZONE"
$Outbox = Join-Path $ChildShell "OUTBOX"
$Watcher = Join-Path $ChildShell "WATCHER"
$Runners = Join-Path $ChildShell "RUNNERS"

$EnsureWatcher = Join-Path $Watcher "ENSURE_CHILD_SHELL_WATCHER_RUNNING.ps1"
$StartWatcher = Join-Path $Watcher "START_CHILD_SHELL_WATCHER.ps1"
$DispatcherOnce = Join-Path $Runners "RUN_CHILD_SHELL_DISPATCH_ONCE.ps1"

if (-not (Test-Path -LiteralPath $Dropzone)) { Fail-Relay "DROPZONE missing: $Dropzone" }
if (-not (Test-Path -LiteralPath $Outbox)) { Fail-Relay "OUTBOX missing: $Outbox" }
if (-not (Test-Path -LiteralPath $DispatcherOnce)) { Fail-Relay "Dispatcher missing: $DispatcherOnce" }

$Raw = Get-Clipboard -Raw
if ([string]::IsNullOrWhiteSpace($Raw)) { Fail-Relay "Clipboard is empty." }

try {
    $Job = $Raw | ConvertFrom-Json -Depth 40
}
catch {
    Fail-Relay "Clipboard did not contain valid JSON. $($_.Exception.Message)"
}

if (-not $Job.job_id) { Fail-Relay "Missing job_id." }

$JobId = [string]$Job.job_id
if ($JobId -notmatch '^CHILDJOB-[0-9]{8}-[0-9]{6}-ASSISTANT-DOOR-[A-Z0-9-]+$') {
    Fail-Relay "Job ID does not match Assistant Door Relay V1C pattern: $JobId"
}

$ActionCandidates = @()
if ($Job.PSObject.Properties.Name -contains "allowed_action") { $ActionCandidates += [string]$Job.allowed_action }
if ($Job.PSObject.Properties.Name -contains "action") { $ActionCandidates += [string]$Job.action }
if ($Job.PSObject.Properties.Name -contains "type") { $ActionCandidates += [string]$Job.type }

if ($ActionCandidates -notcontains "read_command_center_status") {
    Fail-Relay "Job does not contain allowed read_command_center_status action."
}

$JobPath = Join-Path $Dropzone "$JobId.childjob.json"
$ReceiptPath = Join-Path $Outbox "$JobId.receipt.txt"

if (Test-Path -LiteralPath $JobPath) { Fail-Relay "Refusing duplicate childjob path: $JobPath" }
if (Test-Path -LiteralPath $ReceiptPath) { Fail-Relay "Refusing duplicate receipt path: $ReceiptPath" }

$WatcherOutput = "[no watcher helper used]"
if (Test-Path -LiteralPath $EnsureWatcher) {
    $WatcherOutput = (& powershell -NoProfile -ExecutionPolicy Bypass -File $EnsureWatcher *>&1 | Out-String).Trim()
}
elseif (Test-Path -LiteralPath $StartWatcher) {
    $WatcherOutput = (& powershell -NoProfile -ExecutionPolicy Bypass -File $StartWatcher *>&1 | Out-String).Trim()
}
else {
    $WatcherOutput = "[no ensure/start watcher helper found]"
}

$Raw | Set-Content -LiteralPath $JobPath -Encoding UTF8

$ReceiptAppeared = Wait-Receipt -ReceiptPath $ReceiptPath -Seconds 12
$DispatchOutput = "[dispatcher fallback not used]"

if (-not $ReceiptAppeared) {
    $DispatchOutput = (& powershell -NoProfile -ExecutionPolicy Bypass -File $DispatcherOnce *>&1 | Out-String).Trim()
    $ReceiptAppeared = Wait-Receipt -ReceiptPath $ReceiptPath -Seconds 20
}

if ($ReceiptAppeared) {
    $ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash
    Write-Host "ASSISTANT DOOR RELAY V1C PASS"
    Write-Host "Job ID: $JobId"
    Write-Host "Job path: $JobPath"
    Write-Host "Receipt path: $ReceiptPath"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Watcher output:"
    Write-Host $WatcherOutput
    Write-Host "Dispatcher output:"
    Write-Host $DispatchOutput
    exit 0
}

$Locations = Find-ChildJobLocations -ChildShellRoot $ChildShell -JobId $JobId
Write-Host "ASSISTANT DOOR RELAY V1C PARTIAL"
Write-Host "Job ID: $JobId"
Write-Host "Job path: $JobPath"
Write-Host "No OUTBOX receipt after watcher wait and dispatcher fallback."
Write-Host "Known locations:"
if ($Locations.Count -eq 0) { Write-Host "[none]" } else { Write-Host ($Locations -join "`n") }
Write-Host "Watcher output:"
Write-Host $WatcherOutput
Write-Host "Dispatcher output:"
Write-Host $DispatchOutput
exit 2
'@

if (-not (Test-Path -LiteralPath $HelperPath)) {
    Write-NewFileStrict -Path $HelperPath -Content $HelperContent
} else {
    $ExistingHash = Get-HashOrMissing $HelperPath
    $TempExpected = Join-Path $RunDir "EXPECTED_DROP_CHAT_JOB_FROM_CLIPBOARD_V1C_$Stamp.ps1"
    Write-NewFileStrict -Path $TempExpected -Content $HelperContent
    $ExpectedHash = Get-HashOrMissing $TempExpected
    if ($ExistingHash -ne $ExpectedHash) {
        Stop-Custody "Existing V1C helper differs from expected. Existing hash: $ExistingHash Expected hash: $ExpectedHash"
    }
}

$HelperHash = Get-HashOrMissing $HelperPath

$JobId = $null
for ($i = 14; $i -le 999999; $i++) {
    $Candidate = "CHILDJOB-$Date-$($i.ToString('000000'))-ASSISTANT-DOOR-READ-STATUS-RETEST"
    $CandidateMatches = Find-InChildShell -ChildShellRoot $ChildShell -Pattern "*$Candidate*"
    if ($CandidateMatches.Count -eq 0) {
        $JobId = $Candidate
        break
    }
}
if (-not $JobId) { Stop-Custody "Could not find unused V1C job ID." }

$ExpectedReceipt = Join-Path $Outbox "$JobId.receipt.txt"

$TemplateSource = "fallback"
$JobObject = $null

if ($KnownGoodJobPath -and (Test-Path -LiteralPath $KnownGoodJobPath)) {
    try {
        $TemplateRaw = Get-Content -LiteralPath $KnownGoodJobPath -Raw
        $Template = $TemplateRaw | ConvertFrom-Json -Depth 40
        $TemplateSource = $KnownGoodJobPath

        # Convert to an ordered hashtable-like object using JSON roundtrip then mutate common fields.
        $JobObject = $Template | ConvertTo-Json -Depth 40 | ConvertFrom-Json -Depth 40
        if ($JobObject.PSObject.Properties.Name -contains "job_id") { $JobObject.job_id = $JobId }
        if ($JobObject.PSObject.Properties.Name -contains "id") { $JobObject.id = $JobId }
        if ($JobObject.PSObject.Properties.Name -contains "created_at") { $JobObject.created_at = (Get-Date -Format o) }
        if ($JobObject.PSObject.Properties.Name -contains "expected_receipt") { $JobObject.expected_receipt = $ExpectedReceipt }
        if ($JobObject.PSObject.Properties.Name -contains "requested_by") { $JobObject.requested_by = "assistant_door_relay_v1c_template_retest" }
        if ($JobObject.PSObject.Properties.Name -contains "route") { $JobObject.route = "ASSISTANT_DOOR_RELAY_V1C_TEMPLATE_DISPATCH" }
    }
    catch {
        $JobObject = $null
        $TemplateSource = "fallback_after_template_error: $($_.Exception.Message)"
    }
}

if (-not $JobObject) {
    $JobObject = [ordered]@{
        job_id = $JobId
        id = $JobId
        created_at = (Get-Date -Format o)
        requested_by = "assistant_door_relay_v1c_fallback_retest"
        route = "ASSISTANT_DOOR_RELAY_V1C_TEMPLATE_DISPATCH"
        action = "read_command_center_status"
        allowed_action = "read_command_center_status"
        type = "read_command_center_status"
        target_path = $CommandCenter
        expected_receipt = $ExpectedReceipt
        input_files = @(
            "README_START_HERE.md",
            "CURRENT_CONTEXT_CART.md",
            "NEXT_ON_THE_PLATE.md",
            "BLOCKED_MOVES.md",
            "ROOM_INDEX.md"
        )
        boundary = @(
            "Command Center local read only",
            "Assistant Door Relay V1C manual clipboard intake",
            "watcher ensure/start allowed as operational state",
            "dispatcher-once fallback allowed for this bounded test",
            "no Mr.Kleen repo write",
            "no git write",
            "no doctrine install",
            "no ACTIVE_GUIDES rewrite",
            "no CURRENT_TRUTH_INDEX rewrite",
            "no raw shell expansion",
            "no delete",
            "no bridge permission expansion",
            "no broad filesystem crawl"
        )
    }
}

$JobJson = $JobObject | ConvertTo-Json -Depth 40
$PacketPath = Join-Path $RunDir "$JobId.chatjob.json"
Write-NewFileStrict -Path $PacketPath -Content $JobJson
$PacketHash = Get-HashOrMissing $PacketPath

Set-Clipboard -Value $JobJson

$RelayOutput = ""
$RelayExitCode = 0
try {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $HelperPath *>&1 | ForEach-Object {
        $RelayOutput += ($_ | Out-String)
    }
    $RelayExitCode = $LASTEXITCODE
}
catch {
    $RelayOutput += $_.Exception.Message
    $RelayExitCode = 1
}

if (Test-Path -LiteralPath $ExpectedReceipt) {
    $ReceiptPath = $ExpectedReceipt
    $ReceiptHash = Get-HashOrMissing $ReceiptPath
    $Verdict = "PASS / ASSISTANT DOOR RELAY V1C CONSUMED CHILD SHELL JOB"
} else {
    $ReceiptPath = "[missing]"
    $ReceiptHash = "[missing]"
    if ($RelayExitCode -eq 2) {
        $Verdict = "PARTIAL / V1C DROPPED JOB BUT STILL NO OUTBOX RECEIPT"
    } else {
        $Verdict = "FAIL / V1C DID NOT PRODUCE RECEIPT"
    }
}

$AfterStatusOutput = Try-RunPsFile -Path $StatusBridge
$NewJobLocations = Find-InChildShell -ChildShellRoot $ChildShell -Pattern "*$JobId*"
if ($NewJobLocations.Count -eq 0) { $JobLocationReport = "[new job not found in Child Shell lanes]" } else { $JobLocationReport = ($NewJobLocations -join "`n") }

$KeyFiles = @(
    $HelperPath,
    $StatusBridge,
    $EnsureWatcher,
    $StartWatcher,
    $DispatcherOnce,
    $Level1Runner,
    (Join-Path $ChildShell "BRIDGE_CURRENT_STATE.md"),
    (Join-Path $ChildShell "BRIDGE_OPERATOR_GUIDE.md"),
    (Join-Path $Repo "ACTIVE_ANCHOR.txt"),
    (Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md")
)

$KeyReport = foreach ($File in $KeyFiles) {
    if ($File -and (Test-Path -LiteralPath $File)) {
        "FOUND: $File`nSHA256: $(Get-HashOrMissing $File)"
    } elseif ($File) {
        "MISSING: $File"
    }
}

$LaneReport = foreach ($Lane in @("DROPZONE","OUTBOX","REJECTED","PROCESSED","WATCHER","RUNNERS","HELPERS","HOUSE_SAVE_PACKAGES")) {
    $LanePath = Join-Path $ChildShell $Lane
    if (Test-Path -LiteralPath $LanePath) {
        "$Lane : $(@(Get-ChildItem -LiteralPath $LanePath -File -Force -ErrorAction SilentlyContinue).Count) top-level files"
    } else {
        "$Lane : MISSING"
    }
}

$RecentOutbox = "[none]"
if (Test-Path -LiteralPath $Outbox) {
    $RecentOutbox = (Get-ChildItem -LiteralPath $Outbox -File -Force -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10 FullName, LastWriteTime, Length | Format-List | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($RecentOutbox)) { $RecentOutbox = "[none]" }
}

$Journal = @"
# Journal Entry — Assistant Door Relay V1C Repair/Test

## Identity

Run ID:

$RunId

Created:

$IsoNow

User local machine time:

$($Now.ToString("yyyy-MM-dd HH:mm:ss zzz"))

## Task

Repair the Assistant Door Relay V1B script failure and continue the narrow proof.

V1B did not reach the bridge test because it used a native cmd.exe dir command to find an old failed job. On this machine, "File Not Found" surfaced as a NativeCommandError. V1C removes that failure route by using PowerShell-only bounded Child Shell searches.

## Repair Shape

V1C:
1. Preserves V1 failure evidence.
2. Uses PowerShell-only Child Shell search.
3. Tries to clone the known-good Level 1 regression job shape.
4. Adds common action fields only if falling back.
5. Ensures/starts watcher if available.
6. Uses dispatcher-once fallback.
7. Looks for a real OUTBOX receipt.

## Safety Boundary

No repo write.
No git write.
No delete.
No cleanup.
No broad crawl.
No arbitrary shell.
No raw command execution.
No Level 3 save.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No doctrine rewrite.

## Repo Readback

Repo:

$Repo

HEAD:

$RepoHeadShort

Full HEAD:

$RepoHeadFull

Origin main:

$RepoOriginFull

Status:

$RepoStatusText

## Evidence Inputs

Old failed V1 job:

$OldFailedJobId

Old failed V1 locations:

$OldLocationReport

Known-good Level 1 job template:

$TemplateSource

Known-good Level 1 job hash:

$KnownGoodJobHash

## V1C Test Packet

Job ID:

$JobId

Packet path:

$PacketPath

Packet SHA256:

$PacketHash

## Result

Verdict:

$Verdict

Relay helper:

$HelperPath

Relay helper SHA256:

$HelperHash

Receipt path:

$ReceiptPath

Receipt SHA256:

$ReceiptHash

Relay output:

$RelayOutput

## Status Before

$BeforeStatusOutput

## Status After

$AfterStatusOutput

## Job Locations

$JobLocationReport

## Thought Record

This repair is tighter than guessing. The first relay failure gave evidence: the helper and packet were created, but no receipt appeared. The second repair failed before testing because a diagnostic search used cmd.exe and treated "File Not Found" as a hard native command error. V1C removes that brittle tool and stays inside PowerShell.

The important design point remains the same: we are not expanding Child Shell power. We are repairing intake, not authority. The target remains Level 1 read-status. If this passes, the assistant has a bounded manual door into the local bridge through clipboard relay. If it fails, the receipt absence will point to dispatcher schema or watcher/runner details rather than the general bridge concept.

## Verdict

$Verdict
"@

$Scan = @"
# Deep Scan Summary — Assistant Door Relay V1C Repair/Test

## Scan Identity

Run ID:

$RunId

Time:

$IsoNow

## Scope

Bounded scan only.

Checked:
- Mr.Kleen clean state,
- V1 failed job location,
- known-good Level 1 job template location,
- watcher/status helper availability,
- dispatcher availability,
- V1C relay helper,
- one fresh V1C read-status job,
- OUTBOX receipt presence,
- Child Shell lane counts,
- key route file hashes.

Did not:
- crawl the repo,
- rewrite Mr.Kleen,
- use git write,
- run Level 3,
- delete or cleanup old files,
- touch ACTIVE_GUIDES,
- touch CURRENT_TRUTH_INDEX.

## Diagnosis

V1B failed because the repair script used a native cmd.exe search. This was not a bridge failure. It was a script diagnostics failure.

V1C replaces that with PowerShell-only bounded search and tries to use the known-good Level 1 job shape.

## Key Route Files

$($KeyReport -join "`n`n")

## Lane Counts

$($LaneReport -join "`n")

## Recent OUTBOX

$RecentOutbox

## Result

Verdict:

$Verdict

Job ID:

$JobId

Receipt:

$ReceiptPath

Receipt SHA256:

$ReceiptHash

Relay output:

$RelayOutput

## Remaining Boundary

This proves a manual assistant-door relay if PASS.

It does not prove:
- assistant-direct execution from chat,
- zero-copy phone-to-PC use,
- arbitrary shell,
- raw command bridge,
- Level 3 remote save from chat.
"@

Write-NewFileStrict -Path $JournalPath -Content $Journal
Write-NewFileStrict -Path $ScanPath -Content $Scan
$JournalHash = Get-HashOrMissing $JournalPath
$ScanHash = Get-HashOrMissing $ScanPath

$RepairReceipt = @"
ASSISTANT DOOR RELAY V1C REPAIR RECEIPT

Run ID:
$RunId

Created:
$IsoNow

Verdict:
$Verdict

Repo:
$Repo

Repo HEAD:
$RepoHeadShort

Repo full HEAD:
$RepoHeadFull

Repo origin/main:
$RepoOriginFull

Repo status:
$RepoStatusText

Old failed V1 job:
$OldFailedJobId

Old failed V1 locations:
$OldLocationReport

Known-good Level 1 template:
$TemplateSource

Known-good Level 1 template hash:
$KnownGoodJobHash

Relay helper:
$HelperPath

Relay helper SHA256:
$HelperHash

Test job ID:
$JobId

Test packet:
$PacketPath

Test packet SHA256:
$PacketHash

Receipt:
$ReceiptPath

Receipt SHA256:
$ReceiptHash

Journal:
$JournalPath

Journal SHA256:
$JournalHash

Deep scan:
$ScanPath

Deep scan SHA256:
$ScanHash

Boundary:
No repo write. No git write. No delete. No cleanup. No broad crawl. No arbitrary shell. No raw command. No Level 3 save. No ACTIVE_GUIDES rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine rewrite.

Before status:
$BeforeStatusOutput

After status:
$AfterStatusOutput

Relay output:
$RelayOutput
"@

Write-NewFileStrict -Path $RepairReceiptPath -Content $RepairReceipt
$RepairReceiptHash = Get-HashOrMissing $RepairReceiptPath

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "ASSISTANT DOOR RELAY V1C REPAIR/TEST COMPLETE"
Write-Host "Verdict: $Verdict"
Write-Host "Run ID: $RunId"
Write-Host "Repo HEAD: $RepoHeadShort"
Write-Host "Repo origin/main: $RepoOriginFull"
Write-Host "Repo status: $RepoStatusText"
Write-Host "Old failed V1 job locations: $OldLocationReport"
Write-Host "Known-good Level 1 template: $TemplateSource"
Write-Host "Known-good Level 1 template SHA256: $KnownGoodJobHash"
Write-Host "Relay helper: $HelperPath"
Write-Host "Relay helper SHA256: $HelperHash"
Write-Host "Test job ID: $JobId"
Write-Host "Test packet: $PacketPath"
Write-Host "Test packet SHA256: $PacketHash"
Write-Host "Test receipt: $ReceiptPath"
Write-Host "Test receipt SHA256: $ReceiptHash"
Write-Host "Journal: $JournalPath"
Write-Host "Journal SHA256: $JournalHash"
Write-Host "Deep scan: $ScanPath"
Write-Host "Deep scan SHA256: $ScanHash"
Write-Host "Repair receipt: $RepairReceiptPath"
Write-Host "Repair receipt SHA256: $RepairReceiptHash"
Write-Host "Boundary: no repo write; no git write; no delete; no cleanup; no broad crawl; no arbitrary shell; no raw command; no Level 3 save."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
