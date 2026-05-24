param(
    [int]$PasteCountdownSeconds = 10,
    [int]$ReplyWaitSeconds = 600,
    [int]$MaxMailChars = 12000
)

$ErrorActionPreference = "Stop"

$ChatUrl = "https://chatgpt.com/g/g-p-69f7c56c311c81919d718080a8d79305/c/6a0ea350-a848-83ea-8808-351d2601be4d"
$MailRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$DeliveredDir = Join-Path $MailRoot "DELIVERED"
$ReceiptsDir = Join-Path $MailRoot "RECEIPTS"
$ReplyHold = Join-Path $MailRoot "CHAT_REPLY_HOLD"
$Pickup = Join-Path $MailRoot "TOOLS\PICKUP_TO_MAIL_ROOM.ps1"

New-Item -ItemType Directory -Force -Path $ReplyHold | Out-Null

if (-not (Test-Path -LiteralPath $Pickup)) {
    throw "Missing pickup helper: $Pickup"
}

$Delivered = Get-ChildItem -LiteralPath $DeliveredDir -File |
    Sort-Object LastWriteTimeUtc -Descending |
    Select-Object -First 1

if (-not $Delivered) {
    throw "No delivered mail found in $DeliveredDir"
}

$DeliveredHash = (Get-FileHash -LiteralPath $Delivered.FullName -Algorithm SHA256).Hash
$MailText = Get-Content -Raw -LiteralPath $Delivered.FullName

$Truncated = $false
if ($MailText.Length -gt $MaxMailChars) {
    $MailText = $MailText.Substring(0, $MaxMailChars)
    $Truncated = $true
}

$LatestReceiptText = ""
$LatestReceiptPath = ""
if (Test-Path -LiteralPath $ReceiptsDir) {
    $Receipt = Get-ChildItem -LiteralPath $ReceiptsDir -File |
        Sort-Object LastWriteTimeUtc -Descending |
        Select-Object -First 1
    if ($Receipt) {
        $LatestReceiptPath = $Receipt.FullName
        $LatestReceiptText = Get-Content -Raw -LiteralPath $Receipt.FullName
    }
}

$Nonce = -join ((48..57 + 65..70) | Get-Random -Count 12 | ForEach-Object {[char]$_})
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Prompt = @"
MAIL_ROOM_TO_CHAT_TASK_V0

nonce: $Nonce
source: LOCAL_MAIL_ROOM
delivered_path: $($Delivered.FullName)
delivered_sha256: $DeliveredHash
content_truncated: $Truncated

TASK FOR ASSISTANT:
Read the delivered mail below.
Reply with one PACKAGE_V0 only.
Do not give normal chat explanation.
The reply package must target DESKTOP_123_MAIL_ROOM.

Required reply shape:

PACKAGE_V0
package_id: CHAT_REPLY_$Stamp
nonce: $Nonce
target: DESKTOP_123_MAIL_ROOM
filename: CHAT_REPLY_$Stamp.txt
created_by: CHATGPT_ASSISTANT

---CONTENT---
your actual reply goes here
---END_CONTENT---

=== LATEST LOCAL RECEIPT ===
$LatestReceiptText

=== DELIVERED MAIL START ===
$MailText
=== DELIVERED MAIL END ===
"@

Set-Clipboard -Value $Prompt

Write-Host "Prepared latest delivered mail for ChatGPT."
Write-Host "Delivered:"
Write-Host $Delivered.FullName
Write-Host "SHA256:"
Write-Host $DeliveredHash
Write-Host ""
Write-Host "Opening exact chat..."
Start-Process $ChatUrl

Write-Host ""
Write-Host "Click the ChatGPT message box in the correct chat."
Write-Host "Pasting and sending in $PasteCountdownSeconds seconds..."
for ($i = $PasteCountdownSeconds; $i -ge 1; $i--) {
    Write-Host "$i..."
    Start-Sleep -Seconds 1
}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("^v")
Start-Sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

Write-Host ""
Write-Host "Sent mail to chat."
Write-Host "Now wait for assistant reply."
Write-Host "When the PACKAGE_V0 reply appears, copy the whole reply text."
Write-Host "This script will catch the clipboard and send it back into MAIL_ROOM."
Write-Host ""

$Start = Get-Date
$Seen = @{}

while (((Get-Date) - $Start).TotalSeconds -lt $ReplyWaitSeconds) {
    Start-Sleep -Seconds 2

    try {
        $Clip = Get-Clipboard -Raw -ErrorAction Stop
    } catch {
        continue
    }

    if (-not $Clip) { continue }

    $HashBytes = [System.Text.Encoding]::UTF8.GetBytes($Clip)
    $Hash = [BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash($HashBytes)).Replace("-", "")

    if ($Seen.ContainsKey($Hash)) { continue }
    $Seen[$Hash] = $true

    if ($Clip -match "(?m)^\s*PACKAGE_V0\s*$" -and $Clip -match [regex]::Escape($Nonce)) {
        $ReplyPath = Join-Path $ReplyHold "CHAT_REPLY_$Stamp.package.txt"
        $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($ReplyPath, $Clip, $Utf8NoBom)

        Write-Host "Captured assistant reply package:"
        Write-Host $ReplyPath
        Write-Host "SHA256:"
        Write-Host (Get-FileHash -LiteralPath $ReplyPath -Algorithm SHA256).Hash
        Write-Host ""
        Write-Host "Sending assistant reply package into MAIL_ROOM..."

        & $Pickup -Path $ReplyPath -RunWatcher
        exit 0
    }

    Write-Host "Clipboard changed, but it is not the expected PACKAGE_V0 reply for nonce $Nonce."
}

throw "Timed out waiting for copied PACKAGE_V0 assistant reply."
