$ErrorActionPreference = "Stop"

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$Dropzone = Join-Path $ChildRoot "DROPZONE"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Dispatcher = Join-Path $Runners "RUN_CHILD_SHELL_DISPATCH_ONCE.ps1"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
$HeartbeatFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER_HEARTBEAT.txt"
$StopSignal = Join-Path $WatchDir "STOP.signal"

New-Item -ItemType Directory -Force -Path $Inbox, $Outbox, $Rejected, $Processed, $Dropzone, $WatchDir | Out-Null

if (-not (Test-Path -LiteralPath $Dispatcher)) {
    throw "STOP. Dispatcher missing: $Dispatcher"
}

Set-Content -LiteralPath $PidFile -Value $PID -Encoding UTF8

while ($true) {
    if (Test-Path -LiteralPath $StopSignal) {
        Remove-Item -LiteralPath $StopSignal -Force -ErrorAction SilentlyContinue
        Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | STOP SIGNAL RECEIVED | PID=$PID" -Encoding UTF8
        break
    }

    Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | WATCHING DISPATCH | PID=$PID" -Encoding UTF8

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
            & $Dispatcher | Out-File -FilePath (Join-Path $WatchDir "LAST_RUN_OUTPUT.txt") -Encoding UTF8
            Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | DISPATCHER ATTEMPTED" -Encoding UTF8
        }
        catch {
            $ErrPath = Join-Path $WatchDir "LAST_RUN_ERROR.txt"
            Set-Content -LiteralPath $ErrPath -Value "$(Get-Date -Format o)`n$($_.Exception.Message)" -Encoding UTF8
            Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | DISPATCHER ERROR | $($_.Exception.Message)" -Encoding UTF8
        }
    }

    Start-Sleep -Seconds 2
}

Remove-Item -LiteralPath $PidFile -Force -ErrorAction SilentlyContinue
