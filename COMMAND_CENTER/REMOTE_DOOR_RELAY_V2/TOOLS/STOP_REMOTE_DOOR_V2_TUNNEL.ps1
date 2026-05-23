[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$V2Root = Split-Path -Parent $PSScriptRoot
$RunDir = Join-Path $V2Root "RUNS"
$PidPath = Join-Path $RunDir "remote_door_v2_tunnel.pid"
$StatePath = Join-Path $RunDir "current_tunnel_state.json"
$Stopped = $false
$PidText = $null

if (Test-Path -LiteralPath $PidPath) {
    $PidText = (Get-Content -LiteralPath $PidPath -Raw).Trim()
    if ($PidText -match '^\d+$') {
        $Process = Get-Process -Id ([int]$PidText) -ErrorAction SilentlyContinue
        if ($Process) {
            Stop-Process -Id ([int]$PidText) -Force
            $Stopped = $true
        }
    }
    Remove-Item -LiteralPath $PidPath -Force -ErrorAction SilentlyContinue
}

[ordered]@{
    verdict = if ($Stopped) { "TUNNEL_STOPPED" } else { "TUNNEL_NOT_RUNNING" }
    pid = $PidText
    state_path = if (Test-Path -LiteralPath $StatePath) { $StatePath } else { $null }
    time_utc = [DateTimeOffset]::UtcNow.ToString("o")
} | ConvertTo-Json -Depth 4
