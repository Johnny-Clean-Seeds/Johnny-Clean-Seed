[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Token,
    [int]$Port = 8792,
    [string]$BaseUrl
)

$ErrorActionPreference = "Stop"

$V2Root = Split-Path -Parent $PSScriptRoot
$ReceiptDir = Join-Path $V2Root "RECEIPTS"
New-Item -ItemType Directory -Force -Path $ReceiptDir | Out-Null

function Invoke-DoorJson {
    param(
        [string]$Uri,
        [int]$TimeoutSec = 40
    )
    try {
        $Response = Invoke-WebRequest -Uri $Uri -Method Get -TimeoutSec $TimeoutSec -UseBasicParsing
        return [ordered]@{
            status_code = [int]$Response.StatusCode
            json = ($Response.Content | ConvertFrom-Json)
            raw = $Response.Content
        }
    }
    catch {
        $StatusCode = $null
        $Body = ""
        if ($_.Exception.Response) {
            try { $StatusCode = [int]$_.Exception.Response.StatusCode } catch { $StatusCode = $null }
            try {
                $Reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $Body = $Reader.ReadToEnd()
                $Reader.Dispose()
            }
            catch {
                $Body = ""
            }
        }
        if (-not $Body -and $_.ErrorDetails -and $_.ErrorDetails.Message) {
            $Body = [string]$_.ErrorDetails.Message
        }
        $Parsed = $null
        if ($Body) {
            try { $Parsed = $Body | ConvertFrom-Json } catch { $Parsed = $null }
        }
        return [ordered]@{
            status_code = $StatusCode
            json = $Parsed
            raw = $Body
            error = $_.Exception.Message
        }
    }
}

$EscapedToken = [System.Uri]::EscapeDataString($Token)
if (-not $BaseUrl) {
    $BaseUrl = "http://127.0.0.1:$Port"
}
$Base = $BaseUrl.TrimEnd("/")
$Status = Invoke-DoorJson -Uri "$Base/door/v2/status?token=$EscapedToken" -TimeoutSec 15
if ($Status.status_code -ne 200) {
    throw "Status endpoint failed: $($Status.raw)"
}

$Wrong = Invoke-DoorJson -Uri "$Base/door/v2/status?token=WRONG_TOKEN_FOR_REMOTE_DOOR_V2" -TimeoutSec 15
if ($Wrong.status_code -eq 200) {
    throw "Wrong token request unexpectedly succeeded."
}

$DupeNonce = "LOCAL-DUPLICATE-{0}-{1}" -f (Get-Date -Format "yyyyMMddHHmmss"), ([guid]::NewGuid().ToString("N"))
$EscapedDupeNonce = [System.Uri]::EscapeDataString($DupeNonce)
$DupeFirst = Invoke-DoorJson -Uri "$Base/door/v2/probe_async?token=$EscapedToken&nonce=$EscapedDupeNonce" -TimeoutSec 15
if ($DupeFirst.status_code -ne 202) {
    throw "Duplicate nonce first probe failed before duplicate check: $($DupeFirst.raw)"
}
$DupeSecond = Invoke-DoorJson -Uri "$Base/door/v2/probe_async?token=$EscapedToken&nonce=$EscapedDupeNonce" -TimeoutSec 15
if ($DupeSecond.status_code -ge 200 -and $DupeSecond.status_code -lt 300) {
    throw "Duplicate nonce request unexpectedly succeeded."
}

$ProbeNonce = "LOCAL-PROBE-{0}-{1}" -f (Get-Date -Format "yyyyMMddHHmmss"), ([guid]::NewGuid().ToString("N"))
$EscapedProbeNonce = [System.Uri]::EscapeDataString($ProbeNonce)
$ProbeStart = Get-Date
$Probe = Invoke-DoorJson -Uri "$Base/door/v2/probe_async?token=$EscapedToken&nonce=$EscapedProbeNonce" -TimeoutSec 15
$ProbeElapsedMs = [int]((Get-Date) - $ProbeStart).TotalMilliseconds
if ($Probe.status_code -ne 202) {
    throw "Local async probe failed: $($Probe.raw)"
}

$StatusUri = "$Base/door/v2/status?token=$EscapedToken"
$InitialLatest = Invoke-DoorJson -Uri $StatusUri -TimeoutSec 15
if ($InitialLatest.status_code -ne 200) {
    throw "Initial latest status readback failed: $($InitialLatest.raw)"
}

$FinalLatest = $InitialLatest
for ($i = 0; $i -lt 30; $i++) {
    if (
        $FinalLatest.json -and
        [string]$FinalLatest.json.latest_job_id -eq [string]$Probe.json.job_id -and
        [string]$FinalLatest.json.latest_state -eq "PROCESSED_PASS"
    ) { break }
    Start-Sleep -Milliseconds 500
    $FinalLatest = Invoke-DoorJson -Uri $StatusUri -TimeoutSec 15
}
if (
    -not $FinalLatest.json -or
    [string]$FinalLatest.json.latest_job_id -ne [string]$Probe.json.job_id -or
    [string]$FinalLatest.json.latest_state -ne "PROCESSED_PASS"
) {
    throw "Latest status latch did not reach PASS: $($FinalLatest.raw)"
}

$ReceiptSha = $FinalLatest.json.latest_receipt_sha256
$ProofPath = Join-Path $ReceiptDir ("REMOTE_DOOR_V2_LOCAL_SELF_TEST_{0}.json" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
$Proof = [ordered]@{
    verdict = "PASS / LOCAL ASYNC SELF TEST COMPLETE"
    status_endpoint_verdict = $Status.json.verdict
    wrong_token_rejection_verdict = if ($Wrong.status_code -ne 200 -and $Wrong.json -and $Wrong.json.verdict) { $Wrong.json.verdict } elseif ($Wrong.status_code -ne 200) { "REJECTED / WRONG TOKEN HTTP $($Wrong.status_code)" } else { "FAILED" }
    duplicate_nonce_verdict = if ($DupeSecond.status_code -ne 200 -and $DupeSecond.json -and $DupeSecond.json.verdict) { $DupeSecond.json.verdict } elseif ($DupeSecond.status_code -ne 200) { "REJECTED / DUPLICATE NONCE HTTP $($DupeSecond.status_code)" } else { "FAILED" }
    duplicate_nonce_first_job_id = $DupeFirst.json.job_id
    probe_async_verdict = $Probe.json.verdict
    probe_async_elapsed_ms = $ProbeElapsedMs
    local_probe_job_id = $Probe.json.job_id
    local_probe_job_path = $Probe.json.job_path
    local_expected_receipt = $Probe.json.expected_receipt
    readback_route = $Probe.json.readback
    initial_latest_job_id = $InitialLatest.json.latest_job_id
    initial_latest_state = $InitialLatest.json.latest_state
    final_latest_verdict = $FinalLatest.json.latest_verdict
    final_latest_state = $FinalLatest.json.latest_state
    local_probe_processed_path = $FinalLatest.json.latest_result.latest_processed_path
    local_probe_rejected_path = $FinalLatest.json.latest_result.latest_rejected_path
    local_probe_receipt_path = $FinalLatest.json.latest_receipt_path
    local_probe_receipt_sha256 = $ReceiptSha
    latest_boundary = $FinalLatest.json.latest_boundary
    boundary = $FinalLatest.json.boundary
    proof_path = $ProofPath
}

$Proof | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$Proof | ConvertTo-Json -Depth 8
