$ErrorActionPreference = "Stop"

$Root123 = "C:\Users\13527\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$Dropzone = Join-Path $ChildRoot "DROPZONE"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Receipts = Join-Path $CC "RECEIPTS"

if (-not (Test-Path -LiteralPath $CC)) {
    throw "STOP. Command Center not found: $CC"
}

New-Item -ItemType Directory -Force -Path $ChildRoot, $Inbox, $Outbox, $Rejected, $Processed, $Dropzone, $WatchDir, $Runners, $Receipts | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Level1Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"
if (-not (Test-Path -LiteralPath $Level1Runner)) {
    throw "STOP. Level 1 runner missing. Prove/install Level 1 first: $Level1Runner"
}

$WatcherLoop = Join-Path $WatchDir "CHILD_SHELL_WATCHER_LOOP.ps1"
$StartWatcher = Join-Path $WatchDir "START_CHILD_SHELL_WATCHER.ps1"
$StopWatcher = Join-Path $WatchDir "STOP_CHILD_SHELL_WATCHER.ps1"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
$HeartbeatFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER_HEARTBEAT.txt"
$StopSignal = Join-Path $WatchDir "STOP.signal"
$InstallReceipt = Join-Path $Receipts "CHILD_SHELL_WATCHER_TRIGGER_INSTALL_RECEIPT_$Stamp.txt"

$WatcherLoopContent = @'
$ErrorActionPreference = "Stop"

$Root123 = "C:\Users\13527\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$Dropzone = Join-Path $ChildRoot "DROPZONE"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Level1Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
$HeartbeatFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER_HEARTBEAT.txt"
$StopSignal = Join-Path $WatchDir "STOP.signal"

New-Item -ItemType Directory -Force -Path $Inbox, $Outbox, $Rejected, $Processed, $Dropzone, $WatchDir | Out-Null

Set-Content -LiteralPath $PidFile -Value $PID -Encoding UTF8

while ($true) {
    if (Test-Path -LiteralPath $StopSignal) {
        Remove-Item -LiteralPath $StopSignal -Force -ErrorAction SilentlyContinue
        Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | STOP SIGNAL RECEIVED | PID=$PID" -Encoding UTF8
        break
    }

    Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | WATCHING | PID=$PID" -Encoding UTF8

    $DropJobs = @(Get-ChildItem -LiteralPath $Dropzone -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
    foreach ($Job in $DropJobs) {
        $Target = Join-Path $Inbox $Job.Name
        if (Test-Path -LiteralPath $Target) {
            $RejectTarget = Join-Path $Rejected "$($Job.BaseName).duplicate-drop.rejected.txt"
            Set-Content -LiteralPath $RejectTarget -Value "Rejected duplicate dropzone job because INBOX target already exists: $($Job.FullName)" -Encoding UTF8
            Move-Item -LiteralPath $Job.FullName -Destination (Join-Path $Rejected $Job.Name) -Force
        }
        else {
            Move-Item -LiteralPath $Job.FullName -Destination $Target -Force
            Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | MOVED DROPZONE JOB TO INBOX | $($Job.Name)" -Encoding UTF8
        }
    }

    $InboxJobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
    if ($InboxJobs.Count -gt 0) {
        try {
            & $Level1Runner | Out-File -FilePath (Join-Path $WatchDir "LAST_RUN_OUTPUT.txt") -Encoding UTF8
            Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | LEVEL1 RUNNER ATTEMPTED" -Encoding UTF8
        }
        catch {
            $ErrPath = Join-Path $WatchDir "LAST_RUN_ERROR.txt"
            Set-Content -LiteralPath $ErrPath -Value "$(Get-Date -Format o)`n$($_.Exception.Message)" -Encoding UTF8
            Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | LEVEL1 RUNNER ERROR | $($_.Exception.Message)" -Encoding UTF8
        }
    }

    Start-Sleep -Seconds 2
}

Remove-Item -LiteralPath $PidFile -Force -ErrorAction SilentlyContinue
'@

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
    $ExistingPid = (Get-Content -LiteralPath $PidFile -Raw).Trim()
    if ($ExistingPid -match '^\d+$') {
        $Existing = Get-Process -Id ([int]$ExistingPid) -ErrorAction SilentlyContinue
        if ($null -ne $Existing) {
            Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
            Write-Host "CHILD SHELL WATCHER START"
            Write-Host "Verdict: ALREADY RUNNING"
            Write-Host "PID: $ExistingPid"
            Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
            return
        }
    }
}

$Pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue)
if ($null -ne $Pwsh) {
    $Exe = $Pwsh.Source
}
else {
    $Exe = "powershell.exe"
}

$Args = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $WatcherLoop)
$Proc = Start-Process -FilePath $Exe -ArgumentList $Args -WindowStyle Minimized -PassThru

Start-Sleep -Seconds 2

if (-not (Test-Path -LiteralPath $PidFile)) {
    throw "STOP. Watcher PID file not created."
}

$Pid = (Get-Content -LiteralPath $PidFile -Raw).Trim()

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER START"
Write-Host "Verdict: STARTED"
Write-Host "PID: $Pid"
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

$Running = "UNKNOWN"
if (Test-Path -LiteralPath $PidFile) {
    $Pid = (Get-Content -LiteralPath $PidFile -Raw).Trim()
    if ($Pid -match '^\d+$') {
        $Proc = Get-Process -Id ([int]$Pid) -ErrorAction SilentlyContinue
        if ($null -ne $Proc) {
            $Running = "STILL_RUNNING"
        }
        else {
            $Running = "STOPPED"
        }
    }
}
else {
    $Running = "STOPPED"
}

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER STOP"
Write-Host "Verdict: $Running"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
'@

Set-Content -LiteralPath $WatcherLoop -Value $WatcherLoopContent -Encoding UTF8
Set-Content -LiteralPath $StartWatcher -Value $StartWatcherContent -Encoding UTF8
Set-Content -LiteralPath $StopWatcher -Value $StopWatcherContent -Encoding UTF8

$WatcherLoopHash = (Get-FileHash -LiteralPath $WatcherLoop -Algorithm SHA256).Hash
$StartWatcherHash = (Get-FileHash -LiteralPath $StartWatcher -Algorithm SHA256).Hash
$StopWatcherHash = (Get-FileHash -LiteralPath $StopWatcher -Algorithm SHA256).Hash
$Level1RunnerHash = (Get-FileHash -LiteralPath $Level1Runner -Algorithm SHA256).Hash

# Start watcher.
& $StartWatcher | Tee-Object -FilePath (Join-Path $WatchDir "START_OUTPUT_$Stamp.txt") | Out-Null

# Create self-test job in DROPZONE.
$JobId = "CHILDJOB-$(Get-Date -Format yyyyMMdd)-000003-WATCHER-READ-STATUS-SELFTEST"
$SelfTestJob = Join-Path $Dropzone "$JobId.childjob.json"
$ExpectedReceipt = Join-Path $Outbox "$JobId.receipt.txt"

if (Test-Path -LiteralPath $ExpectedReceipt) {
    throw "STOP. Self-test receipt already exists: $ExpectedReceipt"
}

$Job = @"
{
  "job_id": "$JobId",
  "created_at": "$(Get-Date -Format o)",
  "requested_by": "child_shell_watcher_install_selftest",
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
    "no delete",
    "no overwrite outside Child Shell route lanes",
    "no bridge permission expansion",
    "no junction or symlink teleporter",
    "no broad filesystem crawl"
  ],
  "stop_conditions": [
    "watcher not running",
    "Command Center missing",
    "allowlist missing",
    "job action not allowlisted",
    "receipt already exists",
    "malformed job"
  ],
  "hash_requirements": []
}
"@

Set-Content -LiteralPath $SelfTestJob -Value $Job -Encoding UTF8
$SelfTestJobHash = (Get-FileHash -LiteralPath $SelfTestJob -Algorithm SHA256).Hash

$Deadline = (Get-Date).AddSeconds(35)
while ((Get-Date) -lt $Deadline) {
    if (Test-Path -LiteralPath $ExpectedReceipt) {
        break
    }
    Start-Sleep -Seconds 1
}

if (-not (Test-Path -LiteralPath $ExpectedReceipt)) {
    throw "STOP. Watcher self-test receipt did not appear within timeout: $ExpectedReceipt"
}

$SelfTestReceiptHash = (Get-FileHash -LiteralPath $ExpectedReceipt -Algorithm SHA256).Hash

$PidValue = "[missing]"
if (Test-Path -LiteralPath $PidFile) {
    $PidValue = (Get-Content -LiteralPath $PidFile -Raw).Trim()
}

$InstallReceiptContent = @"
CHILD SHELL WATCHER/TRIGGER INSTALL RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / WATCHER TRIGGER ROUTE INSTALLED AND SELF-TESTED

Watcher loop:
$WatcherLoop

Watcher loop SHA256:
$WatcherLoopHash

Start watcher:
$StartWatcher

Start watcher SHA256:
$StartWatcherHash

Stop watcher:
$StopWatcher

Stop watcher SHA256:
$StopWatcherHash

Level1 runner:
$Level1Runner

Level1 runner SHA256:
$Level1RunnerHash

Dropzone:
$Dropzone

Inbox:
$Inbox

Outbox:
$Outbox

Rejected:
$Rejected

Processed:
$Processed

Watcher PID:
$PidValue

Self-test job:
$SelfTestJob

Self-test job SHA256:
$SelfTestJobHash

Self-test receipt:
$ExpectedReceipt

Self-test receipt SHA256:
$SelfTestReceiptHash

Boundary:
Command Center local read only.
No Mr.Kleen repo write.
No git.
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No raw shell expansion.
No delete.
No overwrite outside Child Shell route lanes.
No bridge permission expansion.
No junction or symlink teleporter.
No broad filesystem crawl.

What this proves:
A watcher can stay running, accept a dropped `.childjob.json` in DROPZONE, move it into INBOX, run the Level1 allowlisted read-status runner, and produce an OUTBOX receipt.

What this does not prove:
It does not prove Level2 approved-helper execution.
It does not prove Level3 Mr.Kleen house-save execution.
It does not let the assistant execute arbitrary local commands.
It does not let a hash open a hub.
"@

Set-Content -LiteralPath $InstallReceipt -Value $InstallReceiptContent -Encoding UTF8
$InstallReceiptHash = (Get-FileHash -LiteralPath $InstallReceipt -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER TRIGGER INSTALLED"
Write-Host "Verdict: PASS / WATCHER TRIGGER ROUTE INSTALLED AND SELF-TESTED"
Write-Host "Watcher PID: $PidValue"
Write-Host "Dropzone: $Dropzone"
Write-Host "Inbox: $Inbox"
Write-Host "Outbox: $Outbox"
Write-Host "Watcher Loop: $WatcherLoop"
Write-Host "Start Watcher: $StartWatcher"
Write-Host "Stop Watcher: $StopWatcher"
Write-Host "Self-test Job SHA256: $SelfTestJobHash"
Write-Host "Self-test Receipt: $ExpectedReceipt"
Write-Host "Self-test Receipt SHA256: $SelfTestReceiptHash"
Write-Host "Install Receipt: $InstallReceipt"
Write-Host "Install Receipt SHA256: $InstallReceiptHash"
Write-Host "Boundary: Command Center local read only; no Mr.Kleen repo write; no git; no doctrine install; no raw shell expansion; no delete; no permission expansion; no junction/symlink teleporter; no broad filesystem crawl."
Write-Host "Next: assistant can create .childjob.json files for DROPZONE read-status tests; Level2/Level3 still blocked until separately installed."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
