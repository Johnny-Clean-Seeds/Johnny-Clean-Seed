$ErrorActionPreference = "Stop"

function Stop-Fail {
    param([Parameter(Mandatory=$true)][string]$Message)
    throw "STOP. $Message"
}

function Write-Utf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Value
    )
    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
    }
    Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8
}

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Dropzone = Join-Path $ChildRoot "DROPZONE"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Receipts = Join-Path $CC "RECEIPTS"

if (-not (Test-Path -LiteralPath $CC)) {
    Stop-Fail "Command Center not found: $CC"
}

New-Item -ItemType Directory -Force -Path $Dropzone, $Inbox, $Outbox, $Rejected, $Processed, $WatchDir, $Runners, $Receipts | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Date = Get-Date -Format "yyyyMMdd"

$WatcherLoop = Join-Path $WatchDir "CHILD_SHELL_WATCHER_LOOP.ps1"
$StartWatcher = Join-Path $WatchDir "START_CHILD_SHELL_WATCHER.ps1"
$StopWatcher = Join-Path $WatchDir "STOP_CHILD_SHELL_WATCHER.ps1"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
$EnsureWatcher = Join-Path $WatchDir "ENSURE_CHILD_SHELL_WATCHER_RUNNING.ps1"
$Level1Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"

foreach ($Needed in @($WatcherLoop, $StartWatcher, $StopWatcher, $Level1Runner)) {
    if (-not (Test-Path -LiteralPath $Needed)) {
        Stop-Fail "Missing required route file: $Needed"
    }
}

$EnsureContent = @'
$ErrorActionPreference = "Stop"

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
$StartWatcher = Join-Path $WatchDir "START_CHILD_SHELL_WATCHER.ps1"
$EnsureReceipt = Join-Path $WatchDir "ENSURE_CHILD_SHELL_WATCHER_LAST_RECEIPT.txt"

if (-not (Test-Path -LiteralPath $StartWatcher)) {
    throw "STOP. Start watcher script missing: $StartWatcher"
}

$BeforePid = "[missing]"
$BeforeState = "NO_PID_FILE"
$Action = "NONE"

if (Test-Path -LiteralPath $PidFile) {
    $BeforePid = (Get-Content -LiteralPath $PidFile -Raw).Trim()
    if ($BeforePid -match '^\d+$') {
        $BeforeProcess = Get-Process -Id ([int]$BeforePid) -ErrorAction SilentlyContinue
        if ($null -ne $BeforeProcess) {
            $BeforeState = "RUNNING"
        }
        else {
            $BeforeState = "STALE_OR_STOPPED"
        }
    }
    else {
        $BeforeState = "PID_FILE_NON_NUMERIC"
    }
}

if ($BeforeState -eq "RUNNING") {
    $Action = "KEPT_RUNNING"
}
else {
    $Action = "STARTED_OR_RESTARTED"
    & $StartWatcher | Out-File -FilePath (Join-Path $WatchDir "ENSURE_START_OUTPUT.txt") -Encoding UTF8
}

Start-Sleep -Seconds 3

if (-not (Test-Path -LiteralPath $PidFile)) {
    throw "STOP. Watcher PID file missing after ensure."
}

$AfterPid = (Get-Content -LiteralPath $PidFile -Raw).Trim()
if ($AfterPid -notmatch '^\d+$') {
    throw "STOP. Watcher PID file non-numeric after ensure: $AfterPid"
}

$AfterProcess = Get-Process -Id ([int]$AfterPid) -ErrorAction SilentlyContinue
if ($null -eq $AfterProcess) {
    throw "STOP. Watcher process not running after ensure. PID: $AfterPid"
}

$Receipt = @"
CHILD SHELL WATCHER ENSURE RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / WATCHER IS RUNNING

Before PID:
$BeforePid

Before state:
$BeforeState

Action:
$Action

After PID:
$AfterPid

After state:
RUNNING

Boundary:
Command Center Child Shell watcher control only.
No Mr.Kleen repo write.
No git.
No doctrine install.
No raw shell expansion.
No broad filesystem crawl.
No permission expansion.
No junction/symlink teleporter.
"@

Set-Content -LiteralPath $EnsureReceipt -Value $Receipt -Encoding UTF8

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER ENSURE"
Write-Host "Verdict: PASS / WATCHER IS RUNNING"
Write-Host "Before PID: $BeforePid"
Write-Host "Before state: $BeforeState"
Write-Host "Action: $Action"
Write-Host "After PID: $AfterPid"
Write-Host "After state: RUNNING"
Write-Host "Receipt: $EnsureReceipt"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
'@

Write-Utf8 -Path $EnsureWatcher -Value $EnsureContent
$EnsureHash = (Get-FileHash -LiteralPath $EnsureWatcher -Algorithm SHA256).Hash

# Controlled durability test:
# 1. Stop current watcher if running.
# 2. Write a stale PID value into the PID file.
# 3. Run ensure helper.
# 4. Drop one read-status job and wait for receipt.

$InitialPid = "[missing]"
$InitialState = "UNKNOWN"
if (Test-Path -LiteralPath $PidFile) {
    $InitialPid = (Get-Content -LiteralPath $PidFile -Raw).Trim()
    if ($InitialPid -match '^\d+$') {
        $InitialProcess = Get-Process -Id ([int]$InitialPid) -ErrorAction SilentlyContinue
        if ($null -ne $InitialProcess) {
            $InitialState = "RUNNING"
        }
        else {
            $InitialState = "STALE_OR_STOPPED"
        }
    }
    else {
        $InitialState = "PID_FILE_NON_NUMERIC"
    }
}
else {
    $InitialState = "NO_PID_FILE"
}

if ($InitialState -eq "RUNNING") {
    & $StopWatcher | Out-File -FilePath (Join-Path $WatchDir "LIVENESS_TEST_STOP_OUTPUT_$Stamp.txt") -Encoding UTF8
    Start-Sleep -Seconds 5
}

# Verify no old process is still running if initial PID was numeric.
if ($InitialPid -match '^\d+$') {
    $OldProcessAfterStop = Get-Process -Id ([int]$InitialPid) -ErrorAction SilentlyContinue
    if ($null -ne $OldProcessAfterStop) {
        Stop-Fail "Existing watcher PID $InitialPid still running after stop request. Refusing duplicate watcher test."
    }
}

$StalePidValue = "999999"
Set-Content -LiteralPath $PidFile -Value $StalePidValue -Encoding UTF8

& $EnsureWatcher | Out-File -FilePath (Join-Path $WatchDir "LIVENESS_TEST_ENSURE_OUTPUT_$Stamp.txt") -Encoding UTF8

if (-not (Test-Path -LiteralPath $PidFile)) {
    Stop-Fail "PID file missing after ensure."
}

$RestartedPid = (Get-Content -LiteralPath $PidFile -Raw).Trim()
if ($RestartedPid -notmatch '^\d+$') {
    Stop-Fail "Restarted watcher PID is not numeric: $RestartedPid"
}

$RestartedProcess = Get-Process -Id ([int]$RestartedPid) -ErrorAction SilentlyContinue
if ($null -eq $RestartedProcess) {
    Stop-Fail "Restarted watcher process not running. PID: $RestartedPid"
}

$JobId = "CHILDJOB-$Date-000006-WATCHER-LIVENESS-STALE-PID-RESTART"
$JobPath = Join-Path $Dropzone "$JobId.childjob.json"
$ExpectedReceipt = Join-Path $Outbox "$JobId.receipt.txt"

if (Test-Path -LiteralPath $ExpectedReceipt) {
    Stop-Fail "Self-test receipt already exists: $ExpectedReceipt"
}
if (Test-Path -LiteralPath $JobPath) {
    Stop-Fail "Self-test job already exists in DROPZONE: $JobPath"
}

$Job = @"
{
  "job_id": "$JobId",
  "created_at": "$(Get-Date -Format o)",
  "requested_by": "watcher_liveness_stale_pid_restart_durability_test",
  "route": "COMMAND_CENTER/CHILD_SHELL/WATCHER",
  "allowed_action": "read_command_center_status",
  "target_path": "$($CC.Replace('\','\\'))",
  "input_files": [
    "README_START_HERE.md",
    "CURRENT_CONTEXT_CART.md",
    "NEXT_ON_THE_PLATE.md",
    "BLOCKED_MOVES.md",
    "ROOM_INDEX.md"
  ],
  "expected_receipt": "$($ExpectedReceipt.Replace('\','\\'))",
  "boundary": [
    "Command Center local read only",
    "no Mr.Kleen repo write",
    "no git",
    "no doctrine install",
    "no ACTIVE_GUIDES rewrite",
    "no CURRENT_TRUTH_INDEX rewrite",
    "no raw shell expansion",
    "no broad filesystem crawl",
    "no permission expansion",
    "no junction or symlink teleporter"
  ],
  "stop_conditions": [
    "watcher restart fails",
    "allowlist missing",
    "job action not allowlisted",
    "receipt already exists",
    "malformed job"
  ],
  "hash_requirements": []
}
"@

Write-Utf8 -Path $JobPath -Value $Job
$JobHash = (Get-FileHash -LiteralPath $JobPath -Algorithm SHA256).Hash

$Deadline = (Get-Date).AddSeconds(45)
while ((Get-Date) -lt $Deadline) {
    if (Test-Path -LiteralPath $ExpectedReceipt) {
        break
    }
    Start-Sleep -Seconds 1
}

if (-not (Test-Path -LiteralPath $ExpectedReceipt)) {
    Write-Host "NO RECEIPT AFTER LIVENESS TEST"
    cmd /c dir /s /b "%USERPROFILE%\Desktop\123\COMMAND_CENTER\CHILD_SHELL\*000006*"
    Stop-Fail "Watcher liveness self-test receipt did not appear: $ExpectedReceipt"
}

$SelfTestReceiptHash = (Get-FileHash -LiteralPath $ExpectedReceipt -Algorithm SHA256).Hash

$EnsureReceipt = Join-Path $WatchDir "ENSURE_CHILD_SHELL_WATCHER_LAST_RECEIPT.txt"
$EnsureReceiptHash = (Get-FileHash -LiteralPath $EnsureReceipt -Algorithm SHA256).Hash

$ProofReceipt = Join-Path $Receipts "CHILD_SHELL_WATCHER_LIVENESS_STALE_PID_DURABILITY_RECEIPT_$Stamp.txt"

$Proof = @"
CHILD SHELL WATCHER LIVENESS / STALE PID DURABILITY RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / STALE PID DETECTED, WATCHER RESTARTED, DROP JOB CONSUMED

Initial PID:
$InitialPid

Initial state:
$InitialState

Forced stale PID value:
$StalePidValue

Restarted watcher PID:
$RestartedPid

Restarted watcher state:
RUNNING

Ensure helper:
$EnsureWatcher

Ensure helper SHA256:
$EnsureHash

Ensure receipt:
$EnsureReceipt

Ensure receipt SHA256:
$EnsureReceiptHash

Self-test job:
$JobPath

Self-test job SHA256:
$JobHash

Self-test receipt:
$ExpectedReceipt

Self-test receipt SHA256:
$SelfTestReceiptHash

Boundary:
Command Center Child Shell watcher control only.
No Mr.Kleen repo write.
No git.
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No raw shell expansion.
No broad filesystem crawl.
No permission expansion.
No junction or symlink teleporter.

Meaning:
The watcher liveness helper can recover from a stale PID file by starting a live watcher, and the restarted watcher can consume a dropped Level 1 read-status job.

Not proved:
Assistant-direct local execution from chat.
Level 2 approved-helper execution.
Level 3 Mr.Kleen house-save execution.
Arbitrary shell execution.
"@

Write-Utf8 -Path $ProofReceipt -Value $Proof
$ProofReceiptHash = (Get-FileHash -LiteralPath $ProofReceipt -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER LIVENESS STALE PID DURABILITY PROVED"
Write-Host "Verdict: PASS / STALE PID DETECTED, WATCHER RESTARTED, DROP JOB CONSUMED"
Write-Host "Initial PID: $InitialPid"
Write-Host "Initial state: $InitialState"
Write-Host "Forced stale PID value: $StalePidValue"
Write-Host "Restarted watcher PID: $RestartedPid"
Write-Host "Restarted watcher state: RUNNING"
Write-Host "Ensure helper: $EnsureWatcher"
Write-Host "Ensure helper SHA256: $EnsureHash"
Write-Host "Ensure receipt: $EnsureReceipt"
Write-Host "Ensure receipt SHA256: $EnsureReceiptHash"
Write-Host "Self-test Job ID: $JobId"
Write-Host "Self-test Job SHA256: $JobHash"
Write-Host "Self-test Receipt: $ExpectedReceipt"
Write-Host "Self-test Receipt SHA256: $SelfTestReceiptHash"
Write-Host "Proof Receipt: $ProofReceipt"
Write-Host "Proof Receipt SHA256: $ProofReceiptHash"
Write-Host "Boundary: Command Center Child Shell watcher control only; no Mr.Kleen repo write; no git; no doctrine install; no raw shell expansion; no broad filesystem crawl; no permission expansion; no junction/symlink teleporter."
Write-Host "Next: lock/save watcher liveness durability, then decide Level2 approved-helper route."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
