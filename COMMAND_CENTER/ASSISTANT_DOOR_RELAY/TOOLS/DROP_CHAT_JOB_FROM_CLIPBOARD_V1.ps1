# THIS CODE IS FOR LOCAL.
# DROP_CHAT_JOB_FROM_CLIPBOARD_V1.ps1
# Purpose: bounded manual relay from ChatGPT copied JSON -> local Child Shell DROPZONE -> OUTBOX receipt.
# Boundary: accepts JSON from clipboard, permits only safe approved action names, writes one new childjob file, waits for receipt.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail-Relay {
    param([string]$Message)
    Write-Host "ASSISTANT DOOR RELAY FAIL"
    Write-Host $Message
    exit 1
}

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$ChildShell = Join-Path $CommandCenter "CHILD_SHELL"
$Dropzone = Join-Path $ChildShell "DROPZONE"
$Outbox = Join-Path $ChildShell "OUTBOX"

if (-not (Test-Path -LiteralPath $Dropzone)) { Fail-Relay "DROPZONE missing: $Dropzone" }
if (-not (Test-Path -LiteralPath $Outbox)) { Fail-Relay "OUTBOX missing: $Outbox" }

$Raw = Get-Clipboard -Raw
if ([string]::IsNullOrWhiteSpace($Raw)) { Fail-Relay "Clipboard is empty." }

try {
    $Job = $Raw | ConvertFrom-Json -Depth 20
}
catch {
    Fail-Relay "Clipboard did not contain valid JSON. $($_.Exception.Message)"
}

if (-not $Job.job_id) { Fail-Relay "Missing job_id." }
if (-not $Job.allowed_action) { Fail-Relay "Missing allowed_action." }

$JobId = [string]$Job.job_id
if ($JobId -notmatch '^CHILDJOB-[0-9]{8}-[0-9]{6}-ASSISTANT-DOOR-[A-Z0-9-]+$') {
    Fail-Relay "Job ID does not match assistant door relay pattern: $JobId"
}

$AllowedActions = @(
    "read_command_center_status"
)

if ($AllowedActions -notcontains ([string]$Job.allowed_action)) {
    Fail-Relay "Action is not allowed by Assistant Door Relay V1: $($Job.allowed_action)"
}

$JobPath = Join-Path $Dropzone "$JobId.childjob.json"
$ReceiptPath = Join-Path $Outbox "$JobId.receipt.txt"

if (Test-Path -LiteralPath $JobPath) { Fail-Relay "Refusing duplicate childjob path: $JobPath" }
if (Test-Path -LiteralPath $ReceiptPath) { Fail-Relay "Refusing duplicate receipt path: $ReceiptPath" }

$Raw | Set-Content -LiteralPath $JobPath -Encoding UTF8

$Deadline = (Get-Date).AddSeconds(45)
while ((Get-Date) -lt $Deadline) {
    if (Test-Path -LiteralPath $ReceiptPath) { break }
    Start-Sleep -Seconds 1
}

if (Test-Path -LiteralPath $ReceiptPath) {
    $ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash
    Write-Host "ASSISTANT DOOR RELAY PASS"
    Write-Host "Job ID: $JobId"
    Write-Host "Job path: $JobPath"
    Write-Host "Receipt path: $ReceiptPath"
    Write-Host "Receipt SHA256: $ReceiptHash"
    exit 0
}

$KnownLocations = cmd /c dir /s /b "%USERPROFILE%\Desktop\123\COMMAND_CENTER\CHILD_SHELL\*$JobId*" 2>$null
Write-Host "ASSISTANT DOOR RELAY PARTIAL"
Write-Host "Job ID: $JobId"
Write-Host "Job path: $JobPath"
Write-Host "No OUTBOX receipt within wait window."
Write-Host "Known locations:"
Write-Host $KnownLocations
exit 2
