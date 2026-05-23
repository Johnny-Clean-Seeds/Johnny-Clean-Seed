[CmdletBinding()]
param(
    [int]$Port = 8792,
    [string]$CloudflaredPath
)

$ErrorActionPreference = "Stop"

$V2Root = Split-Path -Parent $PSScriptRoot
$RunDir = Join-Path $V2Root "RUNS"
$LogDir = Join-Path $V2Root "LOGS"
$LocalCloudflared = Join-Path $PSScriptRoot "cloudflared.exe"
$StatePath = Join-Path $RunDir "current_tunnel_state.json"
$PidPath = Join-Path $RunDir "remote_door_v2_tunnel.pid"
New-Item -ItemType Directory -Force -Path $RunDir, $LogDir | Out-Null

if (-not $CloudflaredPath) {
    if (Test-Path -LiteralPath $LocalCloudflared) {
        $CloudflaredPath = $LocalCloudflared
    }
    else {
        $Command = Get-Command cloudflared -ErrorAction SilentlyContinue
        if ($Command) { $CloudflaredPath = $Command.Source }
    }
}

if (-not $CloudflaredPath -or -not (Test-Path -LiteralPath $CloudflaredPath)) {
    throw "cloudflared unavailable. Place cloudflared.exe at $LocalCloudflared or install cloudflared, then rerun this script."
}

if (Test-Path -LiteralPath $PidPath) {
    $ExistingPid = (Get-Content -LiteralPath $PidPath -Raw).Trim()
    if ($ExistingPid -match '^\d+$') {
        $ExistingProcess = Get-Process -Id ([int]$ExistingPid) -ErrorAction SilentlyContinue
        if ($ExistingProcess) {
            throw "Tunnel already appears to be running as PID $ExistingPid. Stop it first."
        }
    }
}

$OutLog = Join-Path $LogDir "remote_door_v2_tunnel.stdout.log"
$ErrLog = Join-Path $LogDir "remote_door_v2_tunnel.stderr.log"
$Args = @("tunnel", "--url", "http://127.0.0.1:$Port", "--no-autoupdate")
$Process = Start-Process -FilePath $CloudflaredPath -ArgumentList $Args -WindowStyle Hidden -RedirectStandardOutput $OutLog -RedirectStandardError $ErrLog -PassThru
$Process.Id | Set-Content -LiteralPath $PidPath -Encoding UTF8

$PublicUrl = $null
for ($i = 0; $i -lt 45; $i++) {
    Start-Sleep -Seconds 1
    if ($Process.HasExited) {
        $ErrText = if (Test-Path -LiteralPath $ErrLog) { Get-Content -LiteralPath $ErrLog -Raw } else { "" }
        throw "cloudflared exited during startup. $ErrText"
    }
    $Combined = ""
    if (Test-Path -LiteralPath $OutLog) { $Combined += Get-Content -LiteralPath $OutLog -Raw }
    if (Test-Path -LiteralPath $ErrLog) { $Combined += "`n" + (Get-Content -LiteralPath $ErrLog -Raw) }
    $Match = [regex]::Match($Combined, 'https://[-a-zA-Z0-9]+\.trycloudflare\.com')
    if ($Match.Success) {
        $PublicUrl = $Match.Value
        break
    }
}

if (-not $PublicUrl) {
    throw "cloudflared started but no trycloudflare URL appeared in logs within 45 seconds."
}

$State = [ordered]@{
    verdict = "TUNNEL_STARTED"
    method = "cloudflared quick tunnel"
    public_url = $PublicUrl
    local_url = "http://127.0.0.1:$Port"
    port = $Port
    pid = $Process.Id
    cloudflared_path = $CloudflaredPath
    started_at_utc = [DateTimeOffset]::UtcNow.ToString("o")
    stop_command = "& '$PSScriptRoot\STOP_REMOTE_DOOR_V2_TUNNEL.ps1'"
}
$State | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $StatePath -Encoding UTF8
Write-Output ($State | ConvertTo-Json -Depth 5)
