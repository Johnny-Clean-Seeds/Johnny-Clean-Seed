param(
    [int]$WaitSeconds = 60,
    [int]$PasteCountdownSeconds = 10,
    [int]$ReplyWaitSeconds = 600,
    [int]$MaxMailChars = 12000,
    [switch]$OpenChat
)

$ErrorActionPreference = "Stop"

$ChatUrl = "https://chatgpt.com/g/g-p-69f7c56c311c81919d718080a8d79305/c/6a0ea350-a848-83ea-8808-351d2601be4d"

$MailRoot = "$env:USERPROFILE\Desktop\123\MAIL_ROOM"
$Drop = Join-Path $MailRoot "LETTER_DROP"
$ProcessedDrop = Join-Path $MailRoot "LETTER_DROP_PROCESSED"
$RejectedDrop = Join-Path $MailRoot "LETTER_DROP_REJECTED"
$DeliveredDir = Join-Path $MailRoot "DELIVERED"
$ReceiptsDir = Join-Path $MailRoot "RECEIPTS"
$ReplyHold = Join-Path $MailRoot "CHAT_REPLY_HOLD"

$Pickup = Join-Path $MailRoot "TOOLS\PICKUP_TO_MAIL_ROOM.ps1"

New-Item -ItemType Directory -Force -Path $Drop,$ProcessedDrop,$RejectedDrop,$ReplyHold | Out-Null

if (-not (Test-Path -LiteralPath $Pickup)) {
    throw "Missing pickup helper: $Pickup"
}

function Get-TextSha256([string]$Text) {
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $Sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return [BitConverter]::ToString($Sha.ComputeHash($Bytes)).Replace("-", "")
    }
    finally {
        $Sha.Dispose()
    }
}

function New-UniquePath([string]$Dir, [string]$Name) {
    $Dest = Join-Path $Dir $Name
    if (-not (Test-Path -LiteralPath $Dest)) { return $Dest }

    $Base = [IO.Path]::GetFileNameWithoutExtension($Name)
    $Ext = [IO.Path]::GetExtension($Name)
    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss_fff"
    return (Join-Path $Dir "$Base`_$Stamp$Ext")
}

function Test-StableFile([string]$Path) {
    $A = Get-Item -LiteralPath $Path -Force
    if ($A.PSIsContainer) { return $false }

    Start-Sleep -Milliseconds 900

    $B = Get-Item -LiteralPath $Path -Force
    if ($B.PSIsContainer) { return $false }

    return (($A.Length -eq $B.Length) -and ($A.LastWriteTimeUtc -eq $B.LastWriteTimeUtc))
}

function Show-DropState {
    Write-Host ""
    Write-Host "=== LETTER_DROP CONTENTS ==="
    $Items = Get-ChildItem -LiteralPath $Drop -Force -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTimeUtc

    if (-not $Items) {
        Write-Host "EMPTY"
        return
    }

    $Items | Select-Object Name, PSIsContainer, Length, LastWriteTime | Format-Table -AutoSize
}

function Get-NextLetterFile {
    $Files = Get-ChildItem -LiteralPath $Drop -File -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch '\.tmp$|\.partial$|\.crdownload$' } |
        Sort-Object LastWriteTimeUtc

    foreach ($File in $Files) {
        if (Test-StableFile $File.FullName) {
            return (Get-Item -LiteralPath $File.FullName -Force)
        }
    }

    return $null
}

function Test-FolderDropExists {
    $Folders = Get-ChildItem -LiteralPath $Drop -Directory -Force -ErrorAction SilentlyContinue
    return [bool]$Folders
}

Write-Host "DROP LETTER WAKE CHAT ONCE"
Write-Host "Drop folder:"
Write-Host $Drop
Write-Host ""
Write-Host "Rule: if a file is already here, process it now. If empty, wait."
Write-Host "Rule: folder drops are blocked until folder batching/hash gate is installed."
Write-Host "Rule: one file only; next file waits for the reply hash."
Write-Host ""

Show-DropState

$Item = Get-NextLetterFile

if (-not $Item) {
    if (Test-FolderDropExists) {
        throw "Folder drop detected, but folder batching/hash gate is not installed yet. Drop one file for this pass."
    }

    Write-Host ""
    Write-Host "No stable file found yet."
    Write-Host "Waiting up to $WaitSeconds seconds..."
    Write-Host ""

    $Start = Get-Date
    while (((Get-Date) - $Start).TotalSeconds -lt $WaitSeconds) {
        $Item = Get-NextLetterFile
        if ($Item) { break }

        if (Test-FolderDropExists) {
            throw "Folder drop detected, but folder batching/hash gate is not installed yet. Drop one file for this pass."
        }

        Start-Sleep -Seconds 1
    }
}

if (-not $Item) {
    Write-Host ""
    Write-Host "EMPTY / STOPPING"
    Write-Host "No stable letter file arrived in LETTER_DROP within $WaitSeconds seconds."
    exit 0
}

Write-Host ""
Write-Host "LETTER FOUND:"
Write-Host $Item.FullName
Write-Host "SHA256:"
Write-Host (Get-FileHash -LiteralPath $Item.FullName -Algorithm SHA256).Hash
Write-Host ""

Write-Host "Sending dropped letter through MAIL_ROOM..."
& $Pickup -Path $Item.FullName -RunWatcher

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$DropProcessedPath = New-UniquePath -Dir $ProcessedDrop -Name ($Stamp + "_" + $Item.Name)
Move-Item -LiteralPath $Item.FullName -Destination $DropProcessedPath -Force

Write-Host ""
Write-Host "Drop original moved to LETTER_DROP_PROCESSED:"
Write-Host $DropProcessedPath
Write-Host ""

$Delivered = Get-ChildItem -LiteralPath $DeliveredDir -File |
    Sort-Object LastWriteTimeUtc -Descending |
    Select-Object -First 1

if (-not $Delivered) {
    throw "No delivered mail found after pickup."
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
$ReplyStamp = Get-Date -Format "yyyyMMdd_HHmmss"

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
Replace the content with a real answer to the delivered mail.
Do not use placeholder text.
The phrase "your actual reply goes here" is forbidden.

Required reply shape:

PACKAGE_V0
package_id: CHAT_REPLY_$ReplyStamp
nonce: $Nonce
target: DESKTOP_123_MAIL_ROOM
filename: CHAT_REPLY_$ReplyStamp.txt
created_by: CHATGPT_ASSISTANT

---CONTENT---
real answer to the delivered mail goes here
---END_CONTENT---

=== LATEST LOCAL RECEIPT ===
$LatestReceiptText

=== DELIVERED MAIL START ===
$MailText
=== DELIVERED MAIL END ===
"@

$PromptHash = Get-TextSha256 $Prompt
Set-Clipboard -Value $Prompt

Write-Host "Prepared dropped letter for ChatGPT."
Write-Host "Delivered:"
Write-Host $Delivered.FullName
Write-Host "DeliveredSHA256:"
Write-Host $DeliveredHash
Write-Host ""

if ($OpenChat) {
    Write-Host "Opening exact chat..."
    Start-Process $ChatUrl
} else {
    Write-Host "OpenChat=false. Use the already-open exact project chat."
}

Write-Host ""
Write-Host "Click the existing ChatGPT message box in the correct chat."
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
Write-Host "Sent letter to chat."
Write-Host "Now wait for assistant reply."
Write-Host "When the PACKAGE_V0 reply appears, copy the whole reply text."
Write-Host "This script will catch the clipboard and send it back into MAIL_ROOM."
Write-Host ""

$Start = Get-Date
$Seen = @{}
$Seen[$PromptHash] = $true

while (((Get-Date) - $Start).TotalSeconds -lt $ReplyWaitSeconds) {
    Start-Sleep -Seconds 2

    try {
        $Clip = Get-Clipboard -Raw -ErrorAction Stop
    } catch {
        continue
    }

    if (-not $Clip) { continue }

    $Hash = Get-TextSha256 $Clip
    if ($Seen.ContainsKey($Hash)) { continue }
    $Seen[$Hash] = $true

    $Trimmed = $Clip.TrimStart()

    if (
        $Trimmed.StartsWith("PACKAGE_V0") -and
        $Clip -match [regex]::Escape($Nonce) -and
        $Clip -match "(?m)^target:\s*DESKTOP_123_MAIL_ROOM\s*$" -and
        $Clip -match "(?s)---CONTENT---.*---END_CONTENT---"
    ) {
        $ReplyPath = Join-Path $ReplyHold "CHAT_REPLY_$ReplyStamp.package.txt"
        $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($ReplyPath, $Clip, $Utf8NoBom)

        Write-Host "Captured assistant reply package:"
        Write-Host $ReplyPath
        Write-Host "SHA256:"
        Write-Host (Get-FileHash -LiteralPath $ReplyPath -Algorithm SHA256).Hash
        Write-Host ""
        Write-Host "Sending assistant reply package into MAIL_ROOM..."

        & $Pickup -Path $ReplyPath -RunWatcher

        Write-Host ""
        Write-Host "ROUNDTRIP COMPLETE / REPLY HASH RECEIVED"
        exit 0
    }

    Write-Host "Clipboard changed, but it is not the expected PACKAGE_V0 reply for nonce $Nonce."
}

throw "Timed out waiting for copied PACKAGE_V0 assistant reply."

