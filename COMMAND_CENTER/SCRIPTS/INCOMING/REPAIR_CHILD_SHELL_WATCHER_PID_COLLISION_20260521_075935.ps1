$ErrorActionPreference = "Stop"

$Root123 = "C:\Users\13527\Desktop\123"
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
    throw "STOP. Command Center not found: $CC"
}

New-Item -ItemType Directory -Force -Path $Dropzone, $Inbox, $Outbox, $Rejected, $Processed, $WatchDir, $Runners, $Receipts | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$WatcherLoop = Join-Path $WatchDir "CHILD_SHELL_WATCHER_LOOP.ps1"
$StartWatcher = Join-Path $WatchDir "START_CHILD_SHELL_WATCHER.ps1"
$StopWatcher = Join-Path $WatchDir "STOP_CHILD_SHELL_WATCHER.ps1"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
$StopSignal = Join-Path $WatchDir "STOP.signal"
$Level1Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"
$RepairReceipt = Join-Path $Receipts "CHILD_SHELL_WATCHER_PID_COLLISION_REPAIR_RECEIPT_$Stamp.txt"

if (-not (Test-Path -LiteralPath $WatcherLoop)) {
    throw "STOP. Watcher loop missing: $WatcherLoop"
}
if (-not (Test-Path -LiteralPath $Level1Runner)) {
    throw "STOP. Level 1 runner missing: $Level1Runner"
}

$StartWatcherContent = @'
$ErrorActionPreference = "Stop"

$Root123 = "C:\Users\13527\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$WatcherLoop = Join-Path $WatchDir "CHILD_SHELL_WATCHER_LOOP.ps1"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
$StopSignal = Join-Path $WatchDir "STOP.signal"

if (-not (Test-Path -LiteralPath $WatcherLoop)) {
    throw "STOP. Watcher loop missing: $WatcherLoop"
}

if (Test-Path -LiteralPath $StopSignal) {
    Remove-Item -LiteralPath $StopSignal -Force
}

if (Test-Path -LiteralPath $PidFile) {
    $ExistingWatcherPidText = (Get-Content -LiteralPath $PidFile -Raw).Trim()
    if ($ExistingWatcherPidText -match '^\d+$') {
        $ExistingWatcherProcess = Get-Process -Id ([int]$ExistingWatcherPidText) -ErrorAction SilentlyContinue
        if ($null -ne $ExistingWatcherProcess) {
            Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
            Write-Host "CHILD SHELL WATCHER START"
            Write-Host "Verdict: ALREADY RUNNING"
            Write-Host "PID: $ExistingWatcherPidText"
            Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
            return
        }
    }
}

$Pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
if ($null -ne $Pwsh) {
    $Exe = $Pwsh.Source
}
else {
    $Exe = "powershell.exe"
}

$Args = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $WatcherLoop)
$WatcherProcess = Start-Process -FilePath $Exe -ArgumentList $Args -WindowStyle Minimized -PassThru

Start-Sleep -Seconds 2

if (-not (Test-Path -LiteralPath $PidFile)) {
    throw "STOP. Watcher PID file not created."
}

$WatcherPidText = (Get-Content -LiteralPath $PidFile -Raw).Trim()

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER START"
Write-Host "Verdict: STARTED"
Write-Host "PID: $WatcherPidText"
Write-Host "Watcher: $WatcherLoop"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
'@

$StopWatcherContent = @'
$ErrorActionPreference = "Stop"

$Root123 = "C:\Users\13527\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$StopSignal = Join-Path $WatchDir "STOP.signal"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"

New-Item -ItemType Directory -Force -Path $WatchDir | Out-Null
Set-Content -LiteralPath $StopSignal -Value "$(Get-Date -Format o) | STOP REQUESTED" -Encoding UTF8

Start-Sleep -Seconds 4

$RunningState = "UNKNOWN"
if (Test-Path -LiteralPath $PidFile) {
    $WatcherPidText = (Get-Content -LiteralPath $PidFile -Raw).Trim()
    if ($WatcherPidText -match '^\d+$') {
        $WatcherProcess = Get-Process -Id ([int]$WatcherPidText) -ErrorAction SilentlyContinue
        if ($null -ne $WatcherProcess) {
            $RunningState = "STILL_RUNNING"
        }
        else {
            $RunningState = "STOPPED"
        }
    }
}
else {
    $RunningState = "STOPPED"
}

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER STOP"
Write-Host "Verdict: $RunningState"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
'@

Set-Content -LiteralPath $StartWatcher -Value $StartWatcherContent -Encoding UTF8
Set-Content -LiteralPath $StopWatcher -Value $StopWatcherContent -Encoding UTF8

$StartHash = (Get-FileHash -LiteralPath $StartWatcher -Algorithm SHA256).Hash
$StopHash = (Get-FileHash -LiteralPath $StopWatcher -Algorithm SHA256).Hash
$LoopHash = (Get-FileHash -LiteralPath $WatcherLoop -Algorithm SHA256).Hash
$Level1Hash = (Get-FileHash -LiteralPath $Level1Runner -Algorithm SHA256).Hash

# Start or reuse watcher with patched start script.
$StartOutputPath = Join-Path $WatchDir "START_AFTER_PID_REPAIR_$Stamp.txt"
& $StartWatcher | Tee-Object -FilePath $StartOutputPath | Out-Null

# Drop one Level 1 self-test job and wait for receipt.
$JobId = "CHILDJOB-$(Get-Date -Format yyyyMMdd)-000004-WATCHER-PID-REPAIR-SELFTEST"
$SelfTestJob = Join-Path $Dropzone "$JobId.childjob.json"
$ExpectedReceipt = Join-Path $Outbox "$JobId.receipt.txt"

if (Test-Path -LiteralPath $ExpectedReceipt) {
    throw "STOP. Self-test receipt already exists: $ExpectedReceipt"
}

$Job = @"
{
  "job_id": "$JobId",
  "created_at": "$(Get-Date -Format o)",
  "requested_by": "watcher_pid_collision_repair_selftest",
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
    "no raw shell expansion",
    "no delete",
    "no permission expansion",
    "no junction or symlink teleporter",
    "no broad filesystem crawl"
  ],
  "stop_conditions": [
    "watcher not running",
    "allowlist missing",
    "job action not allowlisted",
    "receipt already exists",
    "malformed job"
  ],
  "hash_requirements": []
}
"@

Set-Content -LiteralPath $SelfTestJob -Value $Job -Encoding UTF8
$JobHash = (Get-FileHash -LiteralPath $SelfTestJob -Algorithm SHA256).Hash

$Deadline = (Get-Date).AddSeconds(40)
while ((Get-Date) -lt $Deadline) {
    if (Test-Path -LiteralPath $ExpectedReceipt) {
        break
    }
    Start-Sleep -Seconds 1
}

if (-not (Test-Path -LiteralPath $ExpectedReceipt)) {
    throw "STOP. Watcher repair self-test receipt did not appear within timeout: $ExpectedReceipt"
}

$SelfTestReceiptHash = (Get-FileHash -LiteralPath $ExpectedReceipt -Algorithm SHA256).Hash

$WatcherPidTextFinal = "[missing]"
if (Test-Path -LiteralPath $PidFile) {
    $WatcherPidTextFinal = (Get-Content -LiteralPath $PidFile -Raw).Trim()
}

$Receipt = @"
CHILD SHELL WATCHER PID COLLISION REPAIR RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / PID COLLISION REPAIRED AND WATCHER SELF-TESTED

Issue:
PowerShell variable names are case-insensitive. Assigning to `$Pid collided with read-only automatic `$PID.

Fix:
Patched watcher start/stop scripts to use `$WatcherPidText, `$ExistingWatcherPidText, and `$WatcherProcess instead of `$Pid.

Start watcher:
$StartWatcher

Start watcher SHA256:
$StartHash

Stop watcher:
$StopWatcher

Stop watcher SHA256:
$StopHash

Watcher loop:
$WatcherLoop

Watcher loop SHA256:
$LoopHash

Level1 runner:
$Level1Runner

Level1 runner SHA256:
$Level1Hash

Watcher PID:
$WatcherPidTextFinal

Self-test job:
$SelfTestJob

Self-test job SHA256:
$JobHash

Self-test receipt:
$ExpectedReceipt

Self-test receipt SHA256:
$SelfTestReceiptHash

Boundary:
Command Center local read only.
No Mr.Kleen repo write.
No git.
No doctrine install.
No raw shell expansion.
No delete.
No permission expansion.
No junction or symlink teleporter.
No broad filesystem crawl.

Next:
Watcher trigger route is usable for Level 1 read-status childjob drops. Level 2/Level 3 still blocked until separately installed.
"@

Set-Content -LiteralPath $RepairReceipt -Value $Receipt -Encoding UTF8
$RepairReceiptHash = (Get-FileHash -LiteralPath $RepairReceipt -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER PID COLLISION REPAIRED"
Write-Host "Verdict: PASS / PID COLLISION REPAIRED AND WATCHER SELF-TESTED"
Write-Host "Watcher PID: $WatcherPidTextFinal"
Write-Host "Self-test Job SHA256: $JobHash"
Write-Host "Self-test Receipt: $ExpectedReceipt"
Write-Host "Self-test Receipt SHA256: $SelfTestReceiptHash"
Write-Host "Repair Receipt: $RepairReceipt"
Write-Host "Repair Receipt SHA256: $RepairReceiptHash"
Write-Host "Boundary: Command Center local read only; no Mr.Kleen repo write; no git; no doctrine install; no raw shell expansion; no delete; no permission expansion; no junction/symlink teleporter; no broad filesystem crawl."
Write-Host "Next: watcher trigger route is usable for Level 1 read-status childjob drops; Level2/Level3 still blocked until separately installed."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
