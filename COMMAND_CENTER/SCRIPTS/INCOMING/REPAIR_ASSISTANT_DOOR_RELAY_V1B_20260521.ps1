# THIS CODE IS FOR LOCAL.
# REPAIR_ASSISTANT_DOOR_RELAY_V1B_20260521.ps1
# Purpose: repair/prove the Assistant Door Relay by ensuring/starting watcher and using dispatcher-once fallback.
# Scope: bounded Child Shell read-status test only.
# Boundary: no repo write, no git write, no delete, no cleanup, no broad crawl, no arbitrary shell, no Level 3 save.
# Note: watcher start/ensure may update normal watcher operational state files such as pid/heartbeat/last receipt.

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
    if (Test-Path -LiteralPath $Path) {
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    }
    return "[missing]"
}

function Get-FirstExisting {
    param([string[]]$Paths)
    foreach ($Path in $Paths) {
        if (Test-Path -LiteralPath $Path) { return $Path }
    }
    return $null
}

$Now = Get-Date
$Date = $Now.ToString("yyyyMMdd")
$Stamp = $Now.ToString("yyyyMMdd_HHmmss")
$IsoNow = $Now.ToString("o")
$RunId = "ASSISTANT_DOOR_RELAY_V1B_REPAIR_$Stamp"

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$ChildShell = Join-Path $CommandCenter "CHILD_SHELL"
$Dropzone = Join-Path $ChildShell "DROPZONE"
$Outbox = Join-Path $ChildShell "OUTBOX"
$Processed = Join-Path $ChildShell "PROCESSED"
$Rejected = Join-Path $ChildShell "REJECTED"
$Watcher = Join-Path $ChildShell "WATCHER"
$Runners = Join-Path $ChildShell "RUNNERS"
$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"

$RelayRoot = Join-Path $CommandCenter "ASSISTANT_DOOR_RELAY"
$RelayTools = Join-Path $RelayRoot "TOOLS"
$RelayRuns = Join-Path $RelayRoot "RUNS"
$RelayReceipts = Join-Path $RelayRoot "RECEIPTS"
$RunDir = Join-Path $RelayRuns $RunId

$HelperPath = Join-Path $RelayTools "DROP_CHAT_JOB_FROM_CLIPBOARD_V1B_ENSURE_DISPATCH.ps1"
$JournalPath = Join-Path $RunDir "JOURNAL_ENTRY_$Stamp.md"
$ScanPath = Join-Path $RunDir "DEEP_SCAN_SUMMARY_$Stamp.md"
$RepairReceiptPath = Join-Path $RelayReceipts "ASSISTANT_DOOR_RELAY_V1B_REPAIR_RECEIPT_$Stamp.txt"

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

if (-not (Test-Path -LiteralPath $DispatcherOnce)) {
    Stop-Custody "Dispatcher once runner missing: $DispatcherOnce"
}

$OldFailedJobId = "CHILDJOB-20260521-125636-ASSISTANT-DOOR-READ-STATUS-TEST"
$OldLocationReport = ""
$OldFindOutput = cmd /c dir /s /b "%USERPROFILE%\Desktop\123\COMMAND_CENTER\CHILD_SHELL\*$OldFailedJobId*" 2>$null
if ([string]::IsNullOrWhiteSpace(($OldFindOutput | Out-String).Trim())) {
    $OldLocationReport = "[old failed job not found in Child Shell lanes]"
} else {
    $OldLocationReport = ($OldFindOutput | Out-String).Trim()
}

$BeforeStatusOutput = "[status helper missing]"
if (Test-Path -LiteralPath $StatusBridge) {
    try { $BeforeStatusOutput = (& powershell -NoProfile -ExecutionPolicy Bypass -File $StatusBridge *>&1 | Out-String).Trim() }
    catch { $BeforeStatusOutput = "STATUS HELPER ERROR: $($_.Exception.Message)" }
}

$HelperContent = @'
# THIS CODE IS FOR LOCAL.
# DROP_CHAT_JOB_FROM_CLIPBOARD_V1B_ENSURE_DISPATCH.ps1
# Purpose: bounded manual relay from clipboard JSON to Child Shell. Ensures watcher and uses dispatcher-once fallback.
# Allowed V1B action: read_command_center_status only.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail-Relay {
    param([string]$Message)
    Write-Host "ASSISTANT DOOR RELAY V1B FAIL"
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
    $Job = $Raw | ConvertFrom-Json -Depth 30
}
catch {
    Fail-Relay "Clipboard did not contain valid JSON. $($_.Exception.Message)"
}

if (-not $Job.job_id) { Fail-Relay "Missing job_id." }
if (-not $Job.allowed_action) { Fail-Relay "Missing allowed_action." }

$JobId = [string]$Job.job_id
if ($JobId -notmatch '^CHILDJOB-[0-9]{8}-[0-9]{6}-ASSISTANT-DOOR-[A-Z0-9-]+$') {
    Fail-Relay "Job ID does not match Assistant Door Relay V1B pattern: $JobId"
}

if ([string]$Job.allowed_action -ne "read_command_center_status") {
    Fail-Relay "Action is not allowed by Assistant Door Relay V1B: $($Job.allowed_action)"
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

$ReceiptAppeared = Wait-Receipt -ReceiptPath $ReceiptPath -Seconds 15
$DispatchOutput = "[dispatcher fallback not used]"

if (-not $ReceiptAppeared) {
    $DispatchOutput = (& powershell -NoProfile -ExecutionPolicy Bypass -File $DispatcherOnce *>&1 | Out-String).Trim()
    $ReceiptAppeared = Wait-Receipt -ReceiptPath $ReceiptPath -Seconds 20
}

if ($ReceiptAppeared) {
    $ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash
    Write-Host "ASSISTANT DOOR RELAY V1B PASS"
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

$KnownLocations = cmd /c dir /s /b "%USERPROFILE%\Desktop\123\COMMAND_CENTER\CHILD_SHELL\*$JobId*" 2>$null
Write-Host "ASSISTANT DOOR RELAY V1B PARTIAL"
Write-Host "Job ID: $JobId"
Write-Host "Job path: $JobPath"
Write-Host "No OUTBOX receipt after watcher wait and dispatcher fallback."
Write-Host "Known locations:"
Write-Host $KnownLocations
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
    $TempExpected = Join-Path $RunDir "EXPECTED_DROP_CHAT_JOB_FROM_CLIPBOARD_V1B_$Stamp.ps1"
    Write-NewFileStrict -Path $TempExpected -Content $HelperContent
    $ExpectedHash = Get-HashOrMissing $TempExpected
    if ($ExistingHash -ne $ExpectedHash) {
        Stop-Custody "Existing V1B helper differs from expected. Existing hash: $ExistingHash Expected hash: $ExpectedHash"
    }
}

$HelperHash = Get-HashOrMissing $HelperPath

$JobId = $null
for ($i = 13; $i -le 99; $i++) {
    $Candidate = "CHILDJOB-$Date-$($i.ToString('000000'))-ASSISTANT-DOOR-READ-STATUS-RETEST"
    $CandidateReceipt = Join-Path $Outbox "$Candidate.receipt.txt"
    $CandidateDrop = Join-Path $Dropzone "$Candidate.childjob.json"
    $Matches = cmd /c dir /s /b "%USERPROFILE%\Desktop\123\COMMAND_CENTER\CHILD_SHELL\*$Candidate*" 2>$null
    if ((-not (Test-Path -LiteralPath $CandidateReceipt)) -and (-not (Test-Path -LiteralPath $CandidateDrop)) -and [string]::IsNullOrWhiteSpace(($Matches | Out-String).Trim())) {
        $JobId = $Candidate
        break
    }
}

if (-not $JobId) {
    Stop-Custody "Could not find an unused Assistant Door Relay retest job ID from 000013..000099."
}

$ExpectedReceipt = Join-Path $Outbox "$JobId.receipt.txt"

$Job = [ordered]@{
    job_id = $JobId
    created_at = (Get-Date -Format o)
    requested_by = "assistant_door_relay_v1b_repair_test"
    route = "COMMAND_CENTER/CHILD_SHELL/WATCHER"
    allowed_action = "read_command_center_status"
    target_path = $CommandCenter
    input_files = @(
        "README_START_HERE.md",
        "CURRENT_CONTEXT_CART.md",
        "NEXT_ON_THE_PLATE.md",
        "BLOCKED_MOVES.md",
        "ROOM_INDEX.md"
    )
    expected_receipt = $ExpectedReceipt
    boundary = @(
        "Command Center local read only",
        "Assistant Door Relay V1B manual clipboard intake",
        "watcher ensure/start allowed as operational state",
        "dispatcher-once fallback allowed for this bounded test",
        "no Mr.Kleen repo write",
        "no git write",
        "no doctrine install",
        "no ACTIVE_GUIDES rewrite",
        "no CURRENT_TRUTH_INDEX rewrite",
        "no raw shell expansion",
        "no delete",
        "no overwrite outside new relay/test lanes and normal Child Shell routing",
        "no bridge permission expansion",
        "no junction or symlink teleporter",
        "no broad filesystem crawl"
    )
    stop_conditions = @(
        "Command Center missing",
        "watcher unavailable",
        "dispatcher missing",
        "job action not allowlisted",
        "receipt already exists",
        "malformed job"
    )
    hash_requirements = @()
}

$JobJson = $Job | ConvertTo-Json -Depth 30
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
    $Verdict = "PASS / ASSISTANT DOOR RELAY V1B CONSUMED CHILD SHELL JOB"
} else {
    $ReceiptPath = "[missing]"
    $ReceiptHash = "[missing]"
    if ($RelayExitCode -eq 2) {
        $Verdict = "PARTIAL / V1B DROPPED JOB BUT STILL NO OUTBOX RECEIPT"
    } else {
        $Verdict = "FAIL / V1B DID NOT PRODUCE RECEIPT"
    }
}

$AfterStatusOutput = "[status helper missing]"
if (Test-Path -LiteralPath $StatusBridge) {
    try { $AfterStatusOutput = (& powershell -NoProfile -ExecutionPolicy Bypass -File $StatusBridge *>&1 | Out-String).Trim() }
    catch { $AfterStatusOutput = "STATUS HELPER ERROR: $($_.Exception.Message)" }
}

$JobLocationReport = ""
$JobFindOutput = cmd /c dir /s /b "%USERPROFILE%\Desktop\123\COMMAND_CENTER\CHILD_SHELL\*$JobId*" 2>$null
if ([string]::IsNullOrWhiteSpace(($JobFindOutput | Out-String).Trim())) {
    $JobLocationReport = "[new job not found in Child Shell lanes]"
} else {
    $JobLocationReport = ($JobFindOutput | Out-String).Trim()
}

$KeyFiles = @(
    $HelperPath,
    $StatusBridge,
    $EnsureWatcher,
    $StartWatcher,
    $DispatcherOnce,
    (Join-Path $ChildShell "RUNNERS\RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"),
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
# Journal Entry — Assistant Door Relay V1B Repair/Test

## Identity

Run ID:

$RunId

Created:

$IsoNow

User local machine time:

$($Now.ToString("yyyy-MM-dd HH:mm:ss zzz"))

## Task

Repair the failed Assistant Door Relay V1 test.

V1 installed the door lane and wrote the journal/scan files, but the test did not produce an OUTBOX receipt. The likely weak link was that V1 dropped the childjob without ensuring the watcher was alive and without a dispatcher-once fallback.

V1B repairs the concept narrowly.

## Repair Shape

Assistant Door Relay V1B does four bounded things:

1. Preserve the failed V1 evidence.
2. Create a new V1B clipboard relay helper.
3. Ensure/start watcher if a helper is present.
4. If no receipt appears, call the existing dispatcher-once runner as a bounded fallback.

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

Watcher start/ensure may update normal watcher operational state files such as PID, heartbeat, or last watcher receipt.

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

## Old Failed V1 Evidence

Old failed job ID:

$OldFailedJobId

Known locations:

$OldLocationReport

## V1B Test Packet

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

This is the correct repair because it does not expand power. The failed result did not mean the bridge concept was bad; it meant the intake test did not carry enough local liveness support. A chat-to-local door must not assume the watcher is awake. It must either ensure the watcher is awake or use the existing bounded dispatcher once.

The repair keeps the action at Level 1 read-status. It does not use Level 3. It does not write Mr.Kleen. It does not introduce a raw shell. It only proves that a validated assistant-produced job can enter the local Child Shell path and produce a receipt.

## Verdict

$Verdict

## Next Clean Step

If PASS, Assistant Door Relay V1B is the working manual door.

If PARTIAL or FAIL, inspect only the named job locations, relay output, status output, and rejected note. Do not broaden the scan.
"@

$Scan = @"
# Deep Scan Summary — Assistant Door Relay V1B Repair/Test

## Scan Identity

Run ID:

$RunId

Time:

$IsoNow

## Scope

Bounded scan only.

Checked:
- Mr.Kleen clean state,
- failed V1 job location,
- watcher/status helper availability,
- dispatcher availability,
- V1B relay helper,
- one fresh V1B read-status job,
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

V1 installed the door lane but failed to receive an OUTBOX receipt.

The clean likely cause was not the assistant door concept. The likely cause was local processing not waking or not being forced to dispatch during the wait window.

V1B repairs that by adding:
- watcher ensure/start,
- dispatcher-once fallback,
- stronger evidence capture.

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

Those need separate design.
"@

Write-NewFileStrict -Path $JournalPath -Content $Journal
Write-NewFileStrict -Path $ScanPath -Content $Scan

$JournalHash = Get-HashOrMissing $JournalPath
$ScanHash = Get-HashOrMissing $ScanPath

$RepairReceipt = @"
ASSISTANT DOOR RELAY V1B REPAIR RECEIPT

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
No repo write. No git write. No delete. No cleanup. No broad crawl. No arbitrary shell. No raw command. No Level 3 save. No ACTIVE_GUIDES rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine rewrite. Watcher start/ensure may update normal watcher operational state.

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
Write-Host "ASSISTANT DOOR RELAY V1B REPAIR/TEST COMPLETE"
Write-Host "Verdict: $Verdict"
Write-Host "Run ID: $RunId"
Write-Host "Repo HEAD: $RepoHeadShort"
Write-Host "Repo origin/main: $RepoOriginFull"
Write-Host "Repo status: $RepoStatusText"
Write-Host "Old failed V1 job locations: $OldLocationReport"
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
