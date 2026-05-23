[CmdletBinding()]
param(
    [int]$Port = 8792,
    [int]$TokenMinutes = 120,
    [switch]$ReuseToken,
    [switch]$EnableLegacyToken
)

$ErrorActionPreference = "Stop"

$V2Root = Split-Path -Parent $PSScriptRoot
$ServerScript = Join-Path $V2Root "SERVER\remote_door_v2_server.py"
$RunDir = Join-Path $V2Root "RUNS"
$LogDir = Join-Path $V2Root "LOGS"
$TokenScript = Join-Path $PSScriptRoot "New-RemoteDoorV2Token.ps1"
$PidPath = Join-Path $RunDir "remote_door_v2_server.pid"
$StatePath = Join-Path $RunDir "current_server_state.json"

New-Item -ItemType Directory -Force -Path $RunDir, $LogDir | Out-Null

if (-not (Test-Path -LiteralPath $ServerScript)) {
    throw "Server script missing: $ServerScript"
}

function Test-TokenStateActive {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    try {
        $State = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
        return ([DateTimeOffset]::Parse([string]$State.expires_at_utc) -gt [DateTimeOffset]::UtcNow.AddMinutes(1))
    }
    catch {
        return $false
    }
}

function Test-PortFree {
    param([int]$Candidate)
    $Listener = $null
    try {
        $Listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse("127.0.0.1"), $Candidate)
        $Listener.Start()
        return $true
    }
    catch {
        return $false
    }
    finally {
        if ($Listener) { $Listener.Stop() }
    }
}

function Resolve-PythonLaunch {
    $Py = Get-Command py -ErrorAction SilentlyContinue
    if ($Py) {
        return @{
            File = $Py.Source
            PrefixArgs = @("-3", "-u")
        }
    }
    $Python = Get-Command python -ErrorAction SilentlyContinue
    if ($Python) {
        return @{
            File = $Python.Source
            PrefixArgs = @("-u")
        }
    }
    throw "Python 3 not found. The local server requires Python 3."
}

$ChosenPort = $null
for ($Candidate = $Port; $Candidate -le ($Port + 12); $Candidate++) {
    if (Test-PortFree -Candidate $Candidate) {
        $ChosenPort = $Candidate
        break
    }
}
if (-not $ChosenPort) {
    throw "No free loopback port found from $Port through $($Port + 12)."
}

if (Test-Path -LiteralPath $PidPath) {
    $ExistingPid = (Get-Content -LiteralPath $PidPath -Raw).Trim()
    if ($ExistingPid -match '^\d+$') {
        $ExistingProcess = Get-Process -Id ([int]$ExistingPid) -ErrorAction SilentlyContinue
        if ($ExistingProcess) {
            throw "Remote Door V2 server already appears to be running as PID $ExistingPid. Stop it first."
        }
    }
}

$TokenStatePath = Join-Path $V2Root "TOKENS_LOCAL_ONLY\token_state.json"
$TokenResult = $null
if ($EnableLegacyToken -and (-not $ReuseToken -or -not (Test-TokenStateActive -Path $TokenStatePath))) {
    $TokenResult = (& $TokenScript -Minutes $TokenMinutes -V2Root $V2Root) | ConvertFrom-Json
}

$PythonLaunch = Resolve-PythonLaunch
$OutLog = Join-Path $LogDir "remote_door_v2_server.stdout.log"
$ErrLog = Join-Path $LogDir "remote_door_v2_server.stderr.log"
$Arguments = @($PythonLaunch.PrefixArgs) + @($ServerScript, "--root", $V2Root, "--port", [string]$ChosenPort)

$Process = Start-Process -FilePath $PythonLaunch.File -ArgumentList $Arguments -WindowStyle Hidden -RedirectStandardOutput $OutLog -RedirectStandardError $ErrLog -PassThru
Start-Sleep -Milliseconds 900

if ($Process.HasExited) {
    $ErrText = if (Test-Path -LiteralPath $ErrLog) { Get-Content -LiteralPath $ErrLog -Raw } else { "" }
    throw "Remote Door V2 server exited during startup. $ErrText"
}

$StartedState = $null
if (Test-Path -LiteralPath $StatePath) {
    $StartedState = Get-Content -LiteralPath $StatePath -Raw | ConvertFrom-Json
}

$Summary = [ordered]@{
    verdict = "STARTED"
    run_id = if ($StartedState) { $StartedState.run_id } elseif ($TokenResult) { $TokenResult.run_id } else { $null }
    bind = "127.0.0.1"
    port = $ChosenPort
    pid = $Process.Id
    legacy_token = if ($TokenResult) { $TokenResult.token } else { $null }
    legacy_token_note = if ($TokenResult) { "Legacy rollback token printed once because -EnableLegacyToken was used; not stored in plaintext." } elseif ($EnableLegacyToken) { "Reused existing legacy token; plaintext not available from disk." } else { "Legacy token route kept available but not enabled in the normal V2E print flow." }
    expires_at_utc = if ($TokenResult) { $TokenResult.expires_at_utc } elseif ($StartedState) { $StartedState.token_expires_at_utc } else { $null }
    expires_at_local = if ($TokenResult) { $TokenResult.expires_at_local } else { $null }
    status_url = "http://127.0.0.1:$ChosenPort/door/v2/status"
    probe_url_source = "Read next_probe_url from /door/v2/status."
    legacy_status_url_template = "http://127.0.0.1:$ChosenPort/door/v2/status?token=TOKEN"
    legacy_probe_async_url_template = "http://127.0.0.1:$ChosenPort/door/v2/probe_async?token=TOKEN&nonce=NONCE"
    latest_proof_flow = "/door/v2/status -> /door/v2/probe/<print> -> /door/v2/status"
    latest_latch_path = Join-Path $V2Root "LATEST_REMOTE_DOOR_RESULT.json"
    stop_command = "& '$PSScriptRoot\STOP_REMOTE_DOOR_V2.ps1'"
}

Write-Output ($Summary | ConvertTo-Json -Depth 5)
