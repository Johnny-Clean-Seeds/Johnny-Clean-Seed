[CmdletBinding()]
param(
    [string]$Token,
    [switch]$ShowPrintUrl
)

$ErrorActionPreference = "Stop"

$V2Root = Split-Path -Parent $PSScriptRoot
$RunDir = Join-Path $V2Root "RUNS"
$StatePath = Join-Path $RunDir "current_server_state.json"
$PidPath = Join-Path $RunDir "remote_door_v2_server.pid"
$TunnelStatePath = Join-Path $RunDir "current_tunnel_state.json"
$TokenStatePath = Join-Path $V2Root "TOKENS_LOCAL_ONLY\token_state.json"

$State = $null
if (Test-Path -LiteralPath $StatePath) {
    $State = Get-Content -LiteralPath $StatePath -Raw | ConvertFrom-Json
}

$TokenState = $null
$TokenRunId = $null
$TokenExpiresUtc = $null
$TokenExpiresLocal = $null
if (Test-Path -LiteralPath $TokenStatePath) {
    $TokenStateRaw = Get-Content -LiteralPath $TokenStatePath -Raw
    $TokenState = $TokenStateRaw | ConvertFrom-Json
    $RunMatch = [regex]::Match($TokenStateRaw, '"run_id"\s*:\s*"([^"]+)"')
    $UtcMatch = [regex]::Match($TokenStateRaw, '"expires_at_utc"\s*:\s*"([^"]+)"')
    $LocalMatch = [regex]::Match($TokenStateRaw, '"expires_at_local"\s*:\s*"([^"]+)"')
    if ($RunMatch.Success) { $TokenRunId = $RunMatch.Groups[1].Value }
    if ($UtcMatch.Success) { $TokenExpiresUtc = $UtcMatch.Groups[1].Value }
    if ($LocalMatch.Success) { $TokenExpiresLocal = $LocalMatch.Groups[1].Value }
}

$PidText = $null
$ProcessAlive = $false
if (Test-Path -LiteralPath $PidPath) {
    $PidText = (Get-Content -LiteralPath $PidPath -Raw).Trim()
    if ($PidText -match '^\d+$') {
        $ProcessAlive = [bool](Get-Process -Id ([int]$PidText) -ErrorAction SilentlyContinue)
    }
}

$EndpointVerdict = $null
$EndpointLatest = $null
if ($State -and $State.port) {
    $Uri = "http://127.0.0.1:$($State.port)/door/v2/status"
    if ($Token) {
        $Escaped = [System.Uri]::EscapeDataString($Token)
        $Uri = "$Uri?token=$Escaped"
    }
    try {
        $Endpoint = Invoke-RestMethod -Uri $Uri -Method Get -TimeoutSec 10
        $EndpointVerdict = $Endpoint.verdict
        $EndpointLatest = [ordered]@{
            latest_job_id = $Endpoint.latest_job_id
            latest_state = $Endpoint.latest_state
            latest_receipt_sha256 = $Endpoint.latest_receipt_sha256
            latest_receipt_path = $Endpoint.latest_receipt_path
            latest_updated_at = $Endpoint.latest_updated_at
            latest_boundary = $Endpoint.latest_boundary
            print_state = $Endpoint.print_state
            current_print_hash = $Endpoint.current_print_hash
            next_print_hash = $Endpoint.next_print_hash
            next_probe_url = if ($ShowPrintUrl) { $Endpoint.next_probe_url } else { "REDACTED / call /door/v2/status locally when a print URL is needed" }
            expiry = $Endpoint.expiry
            checkpoint_path = $Endpoint.checkpoint_path
            checkpoint_sha256 = $Endpoint.checkpoint_sha256
            recovery_state = $Endpoint.recovery_state
        }
    }
    catch {
        $EndpointVerdict = "STATUS_ENDPOINT_ERROR: $($_.Exception.Message)"
    }
}

$TunnelState = $null
if (Test-Path -LiteralPath $TunnelStatePath) {
    $TunnelState = Get-Content -LiteralPath $TunnelStatePath -Raw | ConvertFrom-Json
}

[ordered]@{
    verdict = if ($ProcessAlive) { "RUNNING" } else { "NOT_RUNNING" }
    pid = $PidText
    process_alive = $ProcessAlive
    bind = if ($State) { $State.bind } else { $null }
    port = if ($State) { $State.port } else { $null }
    run_id = if ($TokenRunId) { $TokenRunId } elseif ($TokenState) { $TokenState.run_id } elseif ($State) { $State.run_id } else { $null }
    token_expires_at_utc = if ($TokenExpiresUtc) { $TokenExpiresUtc } elseif ($TokenState) { $TokenState.expires_at_utc } elseif ($State) { $State.token_expires_at_utc } else { $null }
    token_expires_at_local = if ($TokenExpiresLocal) { $TokenExpiresLocal } elseif ($TokenState) { $TokenState.expires_at_local } else { $null }
    endpoint_verdict = $EndpointVerdict
    endpoint_latest = $EndpointLatest
    tunnel_public_url = if ($TunnelState) { $TunnelState.public_url } else { $null }
    tunnel_pid = if ($TunnelState) { $TunnelState.pid } else { $null }
} | ConvertTo-Json -Depth 5
