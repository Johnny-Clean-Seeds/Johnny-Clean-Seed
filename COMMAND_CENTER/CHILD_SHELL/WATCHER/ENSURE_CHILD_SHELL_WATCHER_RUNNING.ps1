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
