[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$V2Root = Split-Path -Parent $PSScriptRoot
$RunDir = Join-Path $V2Root "RUNS"
$ServerPidPath = Join-Path $RunDir "remote_door_v2_server.pid"
$TunnelStop = Join-Path $PSScriptRoot "STOP_REMOTE_DOOR_V2_TUNNEL.ps1"
$Stopped = @()

if (Test-Path -LiteralPath $TunnelStop) {
    try {
        $TunnelResult = & $TunnelStop | ConvertFrom-Json
        $Stopped += "tunnel:$($TunnelResult.verdict)"
    }
    catch {
        $Stopped += "tunnel_stop_error:$($_.Exception.Message)"
    }
}

if (Test-Path -LiteralPath $ServerPidPath) {
    $PidText = (Get-Content -LiteralPath $ServerPidPath -Raw).Trim()
    if ($PidText -match '^\d+$') {
        $Process = Get-Process -Id ([int]$PidText) -ErrorAction SilentlyContinue
        if ($Process) {
            Stop-Process -Id ([int]$PidText) -Force
            $Stopped += "server:stopped:$PidText"
        }
        else {
            $Stopped += "server:not_running:$PidText"
        }
    }
    Remove-Item -LiteralPath $ServerPidPath -Force -ErrorAction SilentlyContinue
}
else {
    $Stopped += "server:no_pid_file"
}

[ordered]@{
    verdict = "STOP_ATTEMPTED"
    stopped = $Stopped
    time_utc = [DateTimeOffset]::UtcNow.ToString("o")
} | ConvertTo-Json -Depth 4
