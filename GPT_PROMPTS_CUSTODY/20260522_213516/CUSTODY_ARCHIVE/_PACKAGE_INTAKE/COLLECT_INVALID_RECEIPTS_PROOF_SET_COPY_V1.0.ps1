# COLLECT_INVALID_RECEIPTS_PROOF_SET_COPY_V1.0.ps1
# Copies invalid-receipts proof files into one grouped folder.
# Originals stay in place. Copies are hash-verified.
# Writes manifest and receipt.
# Local only. No Git. No push. No public. No doctrine.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Root = Join-Path $Desktop "ASSISTANT_LOCAL"
$Porch = Join-Path $Desktop "123"
$Downloads = Join-Path $env:USERPROFILE "Downloads"

$InvalidRoot = Join-Path $Root "INVALID_RECEIPTS"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$GroupDir = Join-Path $InvalidRoot ("GROUPED_PROOF_SET_COPY_20260522_{0}" -f $Stamp)

if (-not (Test-Path -LiteralPath $Root)) { throw "ASSISTANT_LOCAL root missing: $Root" }
if (-not (Test-Path -LiteralPath $InvalidRoot)) { throw "INVALID_RECEIPTS folder missing: $InvalidRoot" }

New-Item -ItemType Directory -Path $ReceiptDir,$GroupDir -Force | Out-Null

$Names = @(
    "CHAT_RULES_DESKTOP_DROP_COPY_RECEIPT_20260522_172809.txt",
    "CHAT_RULES_DESKTOP_DROP_COPY_REPAIR_RECEIPT_20260522_172936.txt",
    "PORCH_TELEPORTER_ROOT_CLOSEOUT_RECEIPT_20260522_181234.txt",
    "PORCH_TELEPORTER_VALIDATION_REPAIR_RECEIPT_20260522_181337.txt",
    "MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_20260522_190704.txt",
    "MULE_AFTER_WALK_BLOCKER_REPAIR_RECEIPT_20260522_190913.txt",
    "MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_20260522_190913.txt"
)

$SearchRoots = @($Root,$Porch,$Downloads) | Where-Object { Test-Path -LiteralPath $_ }

$Rows = @()
$Missing = @()
$CopiedCount = 0

foreach ($Name in $Names) {
    $Found = @(Get-ChildItem -Path $SearchRoots -Filter $Name -File -Recurse -ErrorAction SilentlyContinue |
        Sort-Object FullName -Unique)

    if ($Found.Count -eq 0) {
        $Missing += $Name
        $Rows += [PSCustomObject]@{
            Name = $Name
            Status = "MISSING"
            SourcePath = ""
            SourceSHA256 = ""
            CopyPath = ""
            CopySHA256 = ""
        }
        continue
    }

    $Pick = $Found | Sort-Object @{
        Expression = {
            if ($_.FullName.StartsWith($Root, [System.StringComparison]::OrdinalIgnoreCase)) { 0 } else { 1 }
        }
    }, LastWriteTime -Descending | Select-Object -First 1

    $Dest = Join-Path $GroupDir $Name
    Copy-Item -LiteralPath $Pick.FullName -Destination $Dest -Force

    if (-not (Test-Path -LiteralPath $Dest)) { throw "COPY FAILED: $Dest" }

    $SourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Pick.FullName).Hash
    $CopyHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Dest).Hash

    if ($SourceHash -ne $CopyHash) {
        throw "HASH MISMATCH after copy for $Name"
    }

    $CopiedCount++

    $Rows += [PSCustomObject]@{
        Name = $Name
        Status = "COPIED"
        SourcePath = $Pick.FullName
        SourceSHA256 = $SourceHash
        CopyPath = $Dest
        CopySHA256 = $CopyHash
    }
}

$ManifestPath = Join-Path $GroupDir "GROUPED_INVALID_RECEIPTS_PROOF_SET_COPY_MANIFEST_20260522.md"

$Manifest = @()
$Manifest += "# Grouped Invalid-Receipts Proof Set Copy — 20260522"
$Manifest += ""
$Manifest += "Status: local-only grouped proof set."
$Manifest += "Purpose: collect referenced invalid/superseded/repair proof receipts in one folder by copy, without moving originals."
$Manifest += "Boundary: no Git, no push, no public, no doctrine."
$Manifest += ""
$Manifest += "Grouped folder: $GroupDir"
$Manifest += ""
$Manifest += "| Name | Status | Source Path | Source SHA256 | Copy Path | Copy SHA256 |"
$Manifest += "|---|---|---|---|---|---|"

foreach ($Row in $Rows) {
    $Manifest += "| $($Row.Name) | $($Row.Status) | $($Row.SourcePath) | $($Row.SourceSHA256) | $($Row.CopyPath) | $($Row.CopySHA256) |"
}

Set-Content -LiteralPath $ManifestPath -Value ($Manifest -join [Environment]::NewLine) -Encoding UTF8
$ManifestHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ManifestPath).Hash

$IndexPath = Join-Path $InvalidRoot "INVALID_RECEIPTS_INDEX_V1.md"
$IndexStatus = "INDEX NOT FOUND"
if (Test-Path -LiteralPath $IndexPath) {
    $IndexText = Get-Content -LiteralPath $IndexPath -Raw
    if ($IndexText -notmatch [regex]::Escape($GroupDir)) {
        $Addendum = @"

## GROUPED PROOF SET COPY — $Stamp

Grouped folder:
`$GroupDir`

Manifest:
`$ManifestPath`

Status:
Copies only. Originals remain in place. Use this folder for one-place review, not as replacement authority.
"@
        Add-Content -LiteralPath $IndexPath -Value $Addendum -Encoding UTF8
        $IndexStatus = "UPDATED WITH GROUPED COPY POINTER"
    } else {
        $IndexStatus = "GROUPED COPY POINTER ALREADY PRESENT"
    }
}

$ReceiptPath = Join-Path $ReceiptDir ("INVALID_RECEIPTS_GROUPED_PROOF_SET_COPY_RECEIPT_20260522_{0}.txt" -f $Stamp)

$ReceiptLines = @()
$ReceiptLines += "INVALID RECEIPTS GROUPED PROOF SET COPY RECEIPT"
$ReceiptLines += "Timestamp: $Stamp"
if ($Missing.Count -eq 0) {
    $ReceiptLines += "Verdict: PASS / ALL FOUND FILES COPIED AND HASH-VERIFIED / NO GIT / NO PUSH"
} else {
    $ReceiptLines += "Verdict: PARTIAL / AVAILABLE FILES COPIED AND HASH-VERIFIED / MISSING FILES LISTED / NO GIT / NO PUSH"
}
$ReceiptLines += ""
$ReceiptLines += "Grouped folder:"
$ReceiptLines += "- $GroupDir"
$ReceiptLines += ""
$ReceiptLines += "Manifest:"
$ReceiptLines += "- $ManifestPath"
$ReceiptLines += "- SHA256: $ManifestHash"
$ReceiptLines += ""
$ReceiptLines += "Copied count: $CopiedCount"
$ReceiptLines += "Missing count: $($Missing.Count)"
$ReceiptLines += ""
$ReceiptLines += "Copied / missing files:"
foreach ($Row in $Rows) {
    $ReceiptLines += "- $($Row.Name)"
    $ReceiptLines += "  Status: $($Row.Status)"
    if ($Row.Status -eq "COPIED") {
        $ReceiptLines += "  Source: $($Row.SourcePath)"
        $ReceiptLines += "  Source SHA256: $($Row.SourceSHA256)"
        $ReceiptLines += "  Copy: $($Row.CopyPath)"
        $ReceiptLines += "  Copy SHA256: $($Row.CopySHA256)"
    }
}
$ReceiptLines += ""
$ReceiptLines += "Invalid index status:"
$ReceiptLines += "- $IndexStatus"
$ReceiptLines += ""
$ReceiptLines += "Boundary:"
$ReceiptLines += "- Copies only; originals remain in place."
$ReceiptLines += "- No move."
$ReceiptLines += "- No delete."
$ReceiptLines += "- No Git."
$ReceiptLines += "- No push."
$ReceiptLines += "- No public export."
$ReceiptLines += "- No doctrine promotion."

Set-Content -LiteralPath $ReceiptPath -Value ($ReceiptLines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "INVALID RECEIPTS PROOF SET COPY COMPLETE"
Write-Host "Grouped folder: $GroupDir"
Write-Host "Manifest: $ManifestPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Copied count: $CopiedCount"
Write-Host "Missing count: $($Missing.Count)"
if ($Missing.Count -gt 0) {
    Write-Host "Missing files:"
    foreach ($Name in $Missing) { Write-Host "- $Name" }
    Write-Host "Verdict: PARTIAL / COPIES MADE / MISSING FILES LISTED / NO GIT / NO PUSH"
} else {
    Write-Host "Verdict: PASS / ALL FILES COPIED AND HASH-VERIFIED / NO GIT / NO PUSH"
}
