# PATCH_MULE_HANDOFF_RECENT_CHAT_RULES_V1.2.ps1
# Updates mule review handoff/kickoff with recent chat-rule changes after the original mule packet.
# Local-only. Review-only. No Git. No push. No public export. No doctrine.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$Root = Join-Path $Desktop "ASSISTANT_LOCAL"
$MuleReview = Join-Path $Root "MULE_REVIEW"
$ChatRules = Join-Path $Root "CHAT_RULES_LOCAL_ONLY"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$Closeout = Join-Path $Root ("PORCH_CLOSEOUT\MULE_RECENT_CHAT_RULES_PATCH_V1.2_{0}" -f $Stamp)

New-Item -ItemType Directory -Path $MuleReview,$ChatRules,$ReceiptDir,$Closeout -Force | Out-Null

$HandoffPath = Join-Path $MuleReview "MULE_REVIEW_ASSISTANT_LOCAL_STABILIZATION_HANDOFF_V1.md"
$KickoffPath = Join-Path $MuleReview "MULE_KICKOFF_ASSISTANT_LOCAL_STABILIZATION_REVIEW_V1.md"
$DesktopPickup = Join-Path $Desktop "MULE_HANDOFF_ASSISTANT_LOCAL_STABILIZATION_REVIEW_V1.md"

$BroadPacketPath = Join-Path $MuleReview "ASSISTANT_LOCAL_BROAD_STABILIZATION_PACKET_V1.5.md"
$WhyMethodPath = Join-Path $ChatRules "WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md"
$WhyIssuePath = Join-Path $ChatRules "WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md"
$RouterPath = Join-Path $ChatRules "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"

$Required = @($HandoffPath,$KickoffPath,$BroadPacketPath,$WhyMethodPath,$WhyIssuePath,$RouterPath)

foreach ($Path in $Required) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "BLOCKED: expected source missing before mule patch: $Path"
    }
}

$Addendum = @'

---

## RECENT CHAT-RULE CHANGES — REVIEW ONLY — ADDED AFTER ORIGINAL HANDOFF

These changes happened after the original mule review packet was prepared. They are now part of the mule review scope.

Mule must review these as assistant-local/chat-behavior support changes, not as doctrine and not as build authorization.

Recent files to include in review:

1. `WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md`
Local path:
`C:\Users\13527\Desktop\ASSISTANT_LOCAL\CHAT_RULES_LOCAL_ONLY\WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md`

Review purpose:
Check whether the method correctly forces live failure repair instead of explanation-only behavior.

2. `WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md`
Local path:
`C:\Users\13527\Desktop\ASSISTANT_LOCAL\CHAT_RULES_LOCAL_ONLY\WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md`

Review purpose:
Check whether the method was correctly applied to the current issue and whether the live issue was closed with proof.

3. `CHAT_COCKPIT_ROUTER_MAP_V1.0.md`
Local path:
`C:\Users\13527\Desktop\ASSISTANT_LOCAL\CHAT_RULES_LOCAL_ONLY\CHAT_COCKPIT_ROUTER_MAP_V1.0.md`

Review purpose:
Check whether the router is staying a simple router instead of becoming doctrine, and whether it actually triggers house-rule use, targeted house walk when needed, delivery surface choice, tool/resource checks, and Final Judge.

Mule review questions:
- Do these recent chat-rule changes fit the broad stabilization packet?
- Do they conflict with the parked candidate bundle?
- Are they real fixes or overbuilt/ghost fixes?
- Are they placed in the right local lane?
- Do Desktop pickups and receipts matter for mule’s recommendation?
- Does the router actually perform the job it claims, or only name the route?
- Does the Why We Suck method include adoption/adaptation and current-issue application?
- What minimal clean adjustment, if any, should happen before building parking/data-log/index files?

Boundary:
- Review only.
- Do not build.
- Do not delete.
- Do not Git.
- Do not push.
- Do not public export.
- Do not rewrite doctrine.
- Do not rewrite ACTIVE_GUIDES.
- Do not rewrite CURRENT_TRUTH_INDEX.

Mule must classify these recent changes as:
- FITS AS REVIEW INPUT
- NEEDS REFINEMENT
- MERGE WITH EXISTING CHAT RULE
- HOLD / PARK
- REJECT AS GHOST
- NEEDS USER APPROVAL
'@

$Handoff = Get-Content -LiteralPath $HandoffPath -Raw
if ($Handoff -notmatch "RECENT CHAT-RULE CHANGES — REVIEW ONLY") {
    Add-Content -LiteralPath $HandoffPath -Value $Addendum -Encoding UTF8
}

$KickoffAdd = @'

Recent change addendum:
Also review recent chat-rule changes as REVIEW ONLY:
- WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md
- WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md
- CHAT_COCKPIT_ROUTER_MAP_V1.0.md

These are in:
C:\Users\13527\Desktop\ASSISTANT_LOCAL\CHAT_RULES_LOCAL_ONLY

Do not build from them. Decide fit, conflict, ghost risk, and minimal next adjustment if any.
'@

$Kickoff = Get-Content -LiteralPath $KickoffPath -Raw
if ($Kickoff -notmatch "Recent change addendum") {
    Add-Content -LiteralPath $KickoffPath -Value $KickoffAdd -Encoding UTF8
}

Copy-Item -LiteralPath $KickoffPath -Destination $DesktopPickup -Force

$ExpectedAfter = @($HandoffPath,$KickoffPath,$DesktopPickup,$BroadPacketPath,$WhyMethodPath,$WhyIssuePath,$RouterPath)
$Hashes = @()

foreach ($Path in $ExpectedAfter) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "BLOCKED: expected file missing after patch: $Path"
    }
    $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Path
    $Hashes += [PSCustomObject]@{ Path = $Path; SHA256 = $Hash.Hash }
}

$ScriptArchive = "Not running from porch"
if ($PSCommandPath) {
    $SelfFull = [System.IO.Path]::GetFullPath($PSCommandPath)
    $PorchFull = [System.IO.Path]::GetFullPath($Porch)
    if ($SelfFull.StartsWith($PorchFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        $ArchivePath = Join-Path $Closeout (Split-Path -Leaf $PSCommandPath)
        Move-Item -LiteralPath $PSCommandPath -Destination $ArchivePath -Force
        if (-not (Test-Path -LiteralPath $ArchivePath)) {
            throw "BLOCKED: script archive failed: $ArchivePath"
        }
        if (Test-Path -LiteralPath $PSCommandPath) {
            throw "BLOCKED: script still loose in porch after archive: $PSCommandPath"
        }
        $ScriptArchive = $ArchivePath
    }
}

$ReceiptPath = Join-Path $ReceiptDir ("MULE_RECENT_CHAT_RULES_PATCH_RECEIPT_{0}.txt" -f $Stamp)

$Lines = @()
$Lines += "MULE RECENT CHAT-RULES PATCH RECEIPT"
$Lines += "Timestamp: $Stamp"
$Lines += "Verdict: PASS / MULE HANDOFF UPDATED WITH RECENT CHAT-RULE CHANGES / NO GIT / NO PUSH"
$Lines += ""
$Lines += "Patched:"
$Lines += "- Handoff: recent chat-rule changes added as REVIEW ONLY."
$Lines += "- Kickoff: recent change addendum added."
$Lines += "- Desktop pickup refreshed from kickoff."
$Lines += ""
$Lines += "Recent review files:"
$Lines += "- WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md"
$Lines += "- WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md"
$Lines += "- CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$Lines += ""
$Lines += "Boundary:"
$Lines += "- Review only."
$Lines += "- No build authorization."
$Lines += "- No delete."
$Lines += "- No Git."
$Lines += "- No push."
$Lines += "- No public export."
$Lines += "- No doctrine rewrite."
$Lines += "- No ACTIVE_GUIDES rewrite."
$Lines += "- No CURRENT_TRUTH_INDEX rewrite."
$Lines += ""
$Lines += "Verified files:"

foreach ($Item in $Hashes) {
    $Lines += "- $($Item.Path)"
    $Lines += "  SHA256: $($Item.SHA256)"
}

$Lines += ""
$Lines += "Porch closeout:"
$Lines += "- Script archive: $ScriptArchive"
$Lines += "- Closeout folder: $Closeout"

Set-Content -LiteralPath $ReceiptPath -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

if (-not (Test-Path -LiteralPath $ReceiptPath)) {
    throw "BLOCKED: receipt missing after write: $ReceiptPath"
}

Write-Host "MULE RECENT CHAT-RULES PATCH COMPLETE"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Desktop kickoff: $DesktopPickup"
Write-Host "Verdict: PASS / MULE UPDATED WITH RECENT CHAT-RULES / NO GIT / NO PUSH"
