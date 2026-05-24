param(
    [string]$PackagePath
)

$ErrorActionPreference = "Stop"

$MailRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$Incoming = Join-Path $MailRoot "INCOMING_PACKAGES"
$Delivered = Join-Path $MailRoot "DELIVERED"
$Receipts = Join-Path $MailRoot "RECEIPTS"
$Processed = Join-Path $MailRoot "PROCESSED"
$Rejected = Join-Path $MailRoot "REJECTED"

New-Item -ItemType Directory -Force -Path $Incoming,$Delivered,$Receipts,$Processed,$Rejected | Out-Null

function Get-HeaderValue([string]$Text, [string]$Name) {
    $m = [regex]::Match($Text, "(?m)^" + [regex]::Escape($Name) + ":\s*(.+?)\s*$")
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return $null
}

function Get-Sha256File([string]$Path) {
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Safe-Name([string]$Name) {
    $safe = $Name -replace '[\\/:*?"<>|]', '_'
    $safe = $safe -replace '\.\.', '_'
    if (-not $safe.Trim()) { return "unnamed.txt" }
    return $safe
}

if (-not $PackagePath) {
    $Item = Get-ChildItem -LiteralPath $Incoming -File |
        Where-Object { $_.Name -notmatch '\.tmp$|\.partial$' } |
        Sort-Object LastWriteTimeUtc |
        Select-Object -First 1

    if (-not $Item) { throw "No incoming file found." }
    $PackagePath = $Item.FullName
}

$PackagePath = (Resolve-Path -LiteralPath $PackagePath).Path
$IncomingResolved = (Resolve-Path -LiteralPath $Incoming).Path

if (-not $PackagePath.StartsWith($IncomingResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Incoming file must come from INCOMING_PACKAGES."
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Raw = Get-Content -Raw -LiteralPath $PackagePath
$SourceHash = Get-Sha256File $PackagePath
$SourceName = [IO.Path]::GetFileName($PackagePath)

try {
    if ($Raw -match "(?m)^PACKAGE_V0\s*$") {
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

        $Filename = Safe-Name $Filename

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
            $DeliveredPath = Join-Path $Delivered "$Base.$Stamp$Ext"
        }

        $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [IO.File]::WriteAllText($DeliveredPath, $Content, $Utf8NoBom)

        $DeliveredHash = Get-Sha256File $DeliveredPath

        $ProcessedPath = Join-Path $Processed $SourceName
        if (Test-Path -LiteralPath $ProcessedPath) {
            $ProcessedPath = Join-Path $Processed "$([IO.Path]::GetFileNameWithoutExtension($SourceName)).$Stamp$([IO.Path]::GetExtension($SourceName))"
        }

        Move-Item -LiteralPath $PackagePath -Destination $ProcessedPath -Force

        $ReceiptPath = Join-Path $Receipts "MAIL_ROOM_PACKAGE_RECEIPT_$Stamp.txt"

@"
MAIL_ROOM RECEIPT
Verdict: PASS / PACKAGE FILE DELIVERED
Mode: PACKAGE_V0
PackageId: $PackageId
Nonce: $Nonce
Target: $Target
SourceProcessedPath: $ProcessedPath
SourceSHA256: $SourceHash
DeliveredPath: $DeliveredPath
DeliveredSHA256: $DeliveredHash
ReceivedLocal: $(Get-Date -Format o)
Boundary: Desktop 123 MAIL_ROOM only; file receiver does not create authority
"@ | Set-Content -Path $ReceiptPath -Encoding UTF8

        Get-Content -LiteralPath $ReceiptPath
        exit 0
    }

    # RAW DROP MODE: no PACKAGE_V0 marker, so deliver the file as ordinary mail.
    $SafeSourceName = Safe-Name $SourceName
    $DeliveredName = "RAW_DROP_$Stamp`_$SafeSourceName"
    $DeliveredPath = Join-Path $Delivered $DeliveredName

    Copy-Item -LiteralPath $PackagePath -Destination $DeliveredPath -Force
    $DeliveredHash = Get-Sha256File $DeliveredPath

    $ProcessedPath = Join-Path $Processed $SourceName
    if (Test-Path -LiteralPath $ProcessedPath) {
        $ProcessedPath = Join-Path $Processed "$([IO.Path]::GetFileNameWithoutExtension($SourceName)).$Stamp$([IO.Path]::GetExtension($SourceName))"
    }

    Move-Item -LiteralPath $PackagePath -Destination $ProcessedPath -Force

    $ReceiptPath = Join-Path $Receipts "MAIL_ROOM_RAW_DROP_RECEIPT_$Stamp.txt"

@"
MAIL_ROOM RECEIPT
Verdict: PASS / RAW FILE DELIVERED
Mode: RAW_DROP
SourceOriginalName: $SourceName
SourceProcessedPath: $ProcessedPath
SourceSHA256: $SourceHash
DeliveredPath: $DeliveredPath
DeliveredSHA256: $DeliveredHash
ReceivedLocal: $(Get-Date -Format o)
Boundary: Desktop 123 MAIL_ROOM only; raw file drop creates no authority
"@ | Set-Content -Path $ReceiptPath -Encoding UTF8

    Get-Content -LiteralPath $ReceiptPath
}
catch {
    $Reason = $_.Exception.Message
    $RejectedPath = Join-Path $Rejected $SourceName
    if (Test-Path -LiteralPath $RejectedPath) {
        $RejectedPath = Join-Path $Rejected "$([IO.Path]::GetFileNameWithoutExtension($SourceName)).$Stamp$([IO.Path]::GetExtension($SourceName))"
    }

    if (Test-Path -LiteralPath $PackagePath) {
        Move-Item -LiteralPath $PackagePath -Destination $RejectedPath -Force
    }

    $ReceiptPath = Join-Path $Receipts "MAIL_ROOM_REJECT_RECEIPT_$Stamp.txt"

@"
MAIL_ROOM RECEIPT
Verdict: REJECTED / FILE NOT DELIVERED
Reason: $Reason
SourceRejectedPath: $RejectedPath
SourceSHA256: $SourceHash
ReceivedLocal: $(Get-Date -Format o)
Boundary: Desktop 123 MAIL_ROOM only; rejected file created no authority
"@ | Set-Content -Path $ReceiptPath -Encoding UTF8

    Get-Content -LiteralPath $ReceiptPath
    exit 1
}
