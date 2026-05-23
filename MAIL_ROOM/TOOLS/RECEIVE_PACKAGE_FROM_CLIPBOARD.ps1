$ErrorActionPreference = "Stop"

$Root = "$env:USERPROFILE\Desktop\123\MAIL_ROOM"
$Delivered = Join-Path $Root "DELIVERED"
$Receipts = Join-Path $Root "RECEIPTS"
$Rejected = Join-Path $Root "REJECTED"

New-Item -ItemType Directory -Force -Path $Delivered,$Receipts,$Rejected | Out-Null

$Raw = Get-Clipboard -Raw

if (-not $Raw -or $Raw -notmatch "PACKAGE_V0") {
    throw "Clipboard does not contain PACKAGE_V0."
}

function Get-HeaderValue([string]$Text, [string]$Name) {
    $m = [regex]::Match($Text, "(?m)^" + [regex]::Escape($Name) + ":\s*(.+?)\s*$")
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return $null
}

$Target = Get-HeaderValue $Raw "target"
$Filename = Get-HeaderValue $Raw "filename"
$Nonce = Get-HeaderValue $Raw "nonce"
$PackageId = Get-HeaderValue $Raw "package_id"

if ($Target -ne "DESKTOP_123_MAIL_ROOM") {
    throw "Package target mismatch: $Target"
}

if (-not $Filename) {
    throw "Missing filename."
}

if ($Filename -match '[\\/:*?"<>|]' -or $Filename -match '\.\.') {
    throw "Unsafe filename: $Filename"
}

$ContentMatch = [regex]::Match($Raw, "(?s)---CONTENT---\s*(.*?)\s*---END_CONTENT---")
if (-not $ContentMatch.Success) {
    throw "Missing content block."
}

$Content = $ContentMatch.Groups[1].Value
$Content = $Content -replace "`r`n", "`n"
$Content = $Content -replace "`r", "`n"

$DeliveredPath = Join-Path $Delivered $Filename
if (Test-Path -LiteralPath $DeliveredPath) {
    $Base = [IO.Path]::GetFileNameWithoutExtension($Filename)
    $Ext = [IO.Path]::GetExtension($Filename)
    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DeliveredPath = Join-Path $Delivered "$Base.$Stamp$Ext"
}

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText($DeliveredPath, $Content, $Utf8NoBom)

$DeliveredHash = (Get-FileHash -LiteralPath $DeliveredPath -Algorithm SHA256).Hash
$RawHash = [System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($Raw))).Replace("-","")

$Stamp2 = Get-Date -Format "yyyyMMdd_HHmmss"
$ReceiptPath = Join-Path $Receipts "MAIL_ROOM_RECEIPT_$Stamp2.txt"

@"
MAIL_ROOM V0 RECEIPT
Verdict: PASS / PACKAGE DELIVERED
PackageId: $PackageId
Nonce: $Nonce
Target: $Target
DeliveredPath: $DeliveredPath
DeliveredSHA256: $DeliveredHash
RawClipboardSHA256: $RawHash
ReceivedLocal: $(Get-Date -Format o)
Boundary: Desktop 123 MAIL_ROOM only; package receiver does not create authority
"@ | Set-Content -Path $ReceiptPath -Encoding UTF8

Get-Content -LiteralPath $ReceiptPath
