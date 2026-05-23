# SAVE_CHAT_COCKPIT_ROUTER_MAP_V1.0.ps1
# Local-only placement for Chat Cockpit Router Map. No Git. No push. No public export.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Root = Join-Path $env:USERPROFILE "Desktop\ASSISTANT_LOCAL"
$ChatRules = Join-Path $Root "CHAT_RULES_LOCAL_ONLY"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$Desktop = Join-Path $env:USERPROFILE "Desktop"

New-Item -ItemType Directory -Path $ChatRules,$ReceiptDir -Force | Out-Null

$MapPath = Join-Path $ChatRules "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$DropCopy = Join-Path $Desktop "CHAT_DROP_COPY__CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$ReceiptPath = Join-Path $ReceiptDir ("CHAT_COCKPIT_ROUTER_MAP_SAVE_RECEIPT_{0}.txt" -f $Stamp)

$SourceCandidates = @(
    (Join-Path $env:USERPROFILE "Downloads\CHAT_COCKPIT_ROUTER_MAP_V1.0.md"),
    (Join-Path $env:USERPROFILE "Desktop\CHAT_COCKPIT_ROUTER_MAP_V1.0.md"),
    (Join-Path $env:USERPROFILE "Desktop\123\CHAT_COCKPIT_ROUTER_MAP_V1.0.md")
)

$Source = $null
foreach ($Candidate in $SourceCandidates) {
    if (Test-Path -LiteralPath $Candidate) {
        $Source = $Candidate
        break
    }
}

if (-not $Source) {
    throw "BLOCKED: CHAT_COCKPIT_ROUTER_MAP_V1.0.md not found in Downloads, Desktop, or Desktop\123."
}

Copy-Item -LiteralPath $Source -Destination $MapPath -Force
Copy-Item -LiteralPath $MapPath -Destination $DropCopy -Force

$MapHash = Get-FileHash -Algorithm SHA256 -LiteralPath $MapPath
$DropHash = Get-FileHash -Algorithm SHA256 -LiteralPath $DropCopy

$Receipt = @"
CHAT COCKPIT ROUTER MAP SAVE RECEIPT
Timestamp: $Stamp
Verdict: PASS / ROUTER MAP SAVED / NO GIT / NO PUSH

Source:
- $Source

Saved:
- $MapPath
  SHA256: $($MapHash.Hash)

Desktop drop-copy:
- $DropCopy
  SHA256: $($DropHash.Hash)

Boundary:
- Local-only chat cockpit router map.
- No Git commit.
- No push.
- No public export.
- Not doctrine.
- Not ACTIVE_GUIDES.
- Not CURRENT_TRUTH_INDEX.

Purpose:
The chat cockpit is a router: ASSISTANT, for X go to house rules for Y.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

Write-Host "CHAT COCKPIT ROUTER MAP SAVE COMPLETE"
Write-Host "Map: $MapPath"
Write-Host "Desktop copy: $DropCopy"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Verdict: PASS / ROUTER MAP SAVED / NO GIT / NO PUSH"
