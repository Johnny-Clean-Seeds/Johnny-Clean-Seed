param(
    [switch]$PasteOnly,
    [switch]$Send,
    [int]$CountdownSeconds = 33
)

$ErrorActionPreference = "Stop"

if (-not $PasteOnly -and -not $Send) {
    $PasteOnly = $true
}

$ChatUrl = "https://chatgpt.com/g/g-p-69f7c56c311c81919d718080a8d79305/c/6a0ea350-a848-83ea-8808-351d2601be4d"

$Stamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssK"
$Nonce = [guid]::NewGuid().ToString("N").Substring(0,12).ToUpper()

$Mode = if ($Send) { "LEVEL_3_AUTO_PASTE_AND_SEND" } else { "LEVEL_2_AUTO_PASTE_NO_SEND" }

$WakePacket = @"
ZzZzZz WAKE_V0
source: JOHN_LOCAL_PC
target: exact Clean Seed / Mr.Kleen ChatGPT chat
intent: wake and refresh this chat
created_local: $Stamp
nonce: $Nonce
proof_mode: $Mode
rule: refresh_verify_click_then_paste
if_wrong_room: do_not_send_recalculate
"@

$WakePacket | Set-Clipboard

Start-Process $ChatUrl

Write-Host ""
Write-Host "WAKE_THIS_CHAT READY"
Write-Host "Mode: $Mode"
Write-Host "Nonce: $Nonce"
Write-Host "CountdownSeconds: $CountdownSeconds"
Write-Host ""
Write-Host "Do this before countdown ends:"
Write-Host "1. Let exact chat open."
Write-Host "2. Press Ctrl+F5 if page looks stale."
Write-Host "3. Confirm this is the right chat."
Write-Host "4. Click the real ChatGPT message box."
Write-Host "5. Do not click PowerShell again."
Write-Host ""

for ($i = $CountdownSeconds; $i -ge 1; $i--) {
    Write-Host "Action in $i..."
    Start-Sleep -Seconds 1
}

$wshell = New-Object -ComObject WScript.Shell
$wshell.SendKeys("^v")

if ($Send) {
    Start-Sleep -Milliseconds 500
    $wshell.SendKeys("{ENTER}")
    $Result = "PASTE_AND_SEND_ATTEMPTED"
} else {
    $Result = "PASTE_ATTEMPTED_NO_SEND"
}

$ReceiptDir = "$env:USERPROFILE\Desktop\WAKE_THIS_CHAT_RECEIPTS"
New-Item -ItemType Directory -Force -Path $ReceiptDir | Out-Null

$SafeStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReceiptPath = Join-Path $ReceiptDir "WAKE_THIS_CHAT_$SafeStamp.txt"

@"
WAKE_THIS_CHAT LOCAL RECEIPT
Result: $Result
Mode: $Mode
Nonce: $Nonce
CreatedLocal: $Stamp
CountdownSeconds: $CountdownSeconds
ChatUrl: $ChatUrl
Boundary: local browser UI wake only; not signed identity proof; not full room verification
ExpectedAssistantReply: WAKE_RECEIVED
"@ | Set-Content -Path $ReceiptPath -Encoding UTF8

Write-Host ""
Write-Host $Result
Write-Host "Nonce: $Nonce"
Write-Host "Receipt: $ReceiptPath"
