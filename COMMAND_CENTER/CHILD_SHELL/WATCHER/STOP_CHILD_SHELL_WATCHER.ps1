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
