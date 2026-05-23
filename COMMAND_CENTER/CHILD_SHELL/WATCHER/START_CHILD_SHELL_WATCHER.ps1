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
$WatcherProcess = Start-Process -FilePath $Exe -ArgumentList $Args -WindowStyle Hidden -PassThru

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
