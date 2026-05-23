# SAVE_AND_TELEPORT_CHAT_COCKPIT_ROUTER_MAP_V1.0.ps1
# Local-only porch teleporter for CHAT_COCKPIT_ROUTER_MAP_V1.0.
# Places map where it belongs, makes Desktop drop-copy, archives porch sources, writes receipt.
# No Git. No push. No public export. No deletion.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$Root = Join-Path $Desktop "ASSISTANT_LOCAL"
$ChatRules = Join-Path $Root "CHAT_RULES_LOCAL_ONLY"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$Closeout = Join-Path $Root ("PORCH_CLOSEOUT\CHAT_COCKPIT_ROUTER_MAP_V1.0_{0}" -f $Stamp)

New-Item -ItemType Directory -Path $ChatRules,$ReceiptDir,$Closeout -Force | Out-Null

$MapName = "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$SaveScriptName = "SAVE_CHAT_COCKPIT_ROUTER_MAP_V1.0.ps1"
$ZipName = "CHAT_COCKPIT_ROUTER_MAP_PACKET_V1.0.zip"

$SourceMap = Join-Path $Porch $MapName
if (-not (Test-Path -LiteralPath $SourceMap)) {
    throw "BLOCKED: source map missing from porch: $SourceMap"
}

$InstalledMap = Join-Path $ChatRules $MapName
$DesktopDrop = Join-Path $Desktop ("CHAT_DROP_COPY__" + $MapName)

Copy-Item -LiteralPath $SourceMap -Destination $InstalledMap -Force
Copy-Item -LiteralPath $InstalledMap -Destination $DesktopDrop -Force

$ExpectedInstalled = @($InstalledMap, $DesktopDrop)
foreach ($Path in $ExpectedInstalled) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "BLOCKED: expected output missing after copy: $Path"
    }
}

$ArchiveResults = @()
$PorchFiles = @($MapName, $SaveScriptName, $ZipName)

foreach ($Name in $PorchFiles) {
    $Source = Join-Path $Porch $Name
    if (Test-Path -LiteralPath $Source) {
        $Dest = Join-Path $Closeout $Name
        Move-Item -LiteralPath $Source -Destination $Dest -Force
        if (-not (Test-Path -LiteralPath $Dest)) {
            throw "BLOCKED: archive move failed: $Dest"
        }
        if (Test-Path -LiteralPath $Source) {
            throw "BLOCKED: source still loose in porch after archive: $Source"
        }
        $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Dest
        $ArchiveResults += [PSCustomObject]@{
            Name = $Name
            Archived = $Dest
            SHA256 = $Hash.Hash
        }
    }
}

$InstalledHash = Get-FileHash -Algorithm SHA256 -LiteralPath $InstalledMap
$DropHash = Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopDrop

$RemainingTargets = @()
foreach ($Name in $PorchFiles) {
    $Path = Join-Path $Porch $Name
    if (Test-Path -LiteralPath $Path) {
        $RemainingTargets += $Path
    }
}

if ($RemainingTargets.Count -gt 0) {
    throw "BLOCKED: router map packet files still loose in porch: $($RemainingTargets -join ' | ')"
}

$ReceiptPath = Join-Path $ReceiptDir ("CHAT_COCKPIT_ROUTER_MAP_TELEPORTER_RECEIPT_{0}.txt" -f $Stamp)

$Lines = @()
$Lines += "CHAT COCKPIT ROUTER MAP TELEPORTER RECEIPT"
$Lines += "Timestamp: $Stamp"
$Lines += "Verdict: PASS / ROUTER MAP PLACED AND PORCH CLOSED / NO GIT / NO PUSH"
$Lines += ""
$Lines += "Installed:"
$Lines += "- $InstalledMap"
$Lines += "  SHA256: $($InstalledHash.Hash)"
$Lines += ""
$Lines += "Desktop drop-copy:"
$Lines += "- $DesktopDrop"
$Lines += "  SHA256: $($DropHash.Hash)"
$Lines += ""
$Lines += "Archived porch packet:"
foreach ($Item in $ArchiveResults) {
    $Lines += "- $($Item.Name)"
    $Lines += "  Archived: $($Item.Archived)"
    $Lines += "  SHA256: $($Item.SHA256)"
}
$Lines += ""
$Lines += "Closeout:"
$Lines += "- $Closeout"
$Lines += ""
$Lines += "Boundary:"
$Lines += "- Local-only chat cockpit router map."
$Lines += "- No Git commit."
$Lines += "- No push."
$Lines += "- No public export."
$Lines += "- Not doctrine."
$Lines += "- Not ACTIVE_GUIDES."
$Lines += "- Not CURRENT_TRUTH_INDEX."
$Lines += "- No deletion; porch sources archived."

Set-Content -LiteralPath $ReceiptPath -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "CHAT COCKPIT ROUTER MAP TELEPORTER COMPLETE"
Write-Host "Map: $InstalledMap"
Write-Host "Desktop drop-copy: $DesktopDrop"
Write-Host "Closeout: $Closeout"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Verdict: PASS / ROUTER MAP PLACED AND PORCH CLOSED / NO GIT / NO PUSH"
