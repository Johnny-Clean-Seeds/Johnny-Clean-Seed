# UPDATE_RULE_SETS_STABLE_OVERWRITE_NEIGHBOR_RESPECT.ps1
# Local-only rule-set updater.
# Updates stable active chat-gate files and assistant-local mirror.
# No Git. No push. No public export. No new version-suffix rule clutter.

$ErrorActionPreference = "Stop"

function Get-HashText {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    }
    return "MISSING"
}

function Upsert-Section {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Marker,
        [Parameter(Mandatory=$true)][string]$Section
    )
    if (!(Test-Path -LiteralPath $Path)) { throw "TARGET FILE MISSING: $Path" }
    $Text = Get-Content -LiteralPath $Path -Raw
    $Start = "<!-- $Marker START -->"
    $End = "<!-- $Marker END -->"
    $Block = "$Start`r`n$Section`r`n$End"
    $Pattern = [regex]::Escape($Start) + ".*?" + [regex]::Escape($End)
    if ($Text -match $Pattern) {
        $Text = [regex]::Replace($Text,$Pattern,$Block,[System.Text.RegularExpressions.RegexOptions]::Singleline)
    } else {
        $Text = $Text.TrimEnd() + "`r`n`r`n" + $Block + "`r`n"
    }
    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
}

$Desktop = Join-Path $env:USERPROFILE "Desktop"
$PromptRoot = Join-Path $Desktop "GPT_Prompts"
$Active = Join-Path $PromptRoot "CHAT_GATE_SYSTEM_PACKAGE"
$Intake = Join-Path $PromptRoot "_PACKAGE_INTAKE"
$PromptReceipts = Join-Path $Intake "RECEIPTS"
$ActiveReceipts = Join-Path $Active "_RECEIPTS"
$AssistantLocal = Join-Path $Desktop "ASSISTANT_LOCAL"
$AssistantRules = Join-Path $AssistantLocal "CHAT_RULES_LOCAL_ONLY"
$AssistantReceipts = Join-Path $AssistantLocal "_RECEIPTS"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (!(Test-Path -LiteralPath $Active)) { throw "ACTIVE PACKAGE ROOT MISSING: $Active" }
New-Item -ItemType Directory -Path $PromptReceipts,$ActiveReceipts -Force | Out-Null

$Required = @(
"00_LOAD_FIRST__CHAT_GATE_SYSTEM.md",
"01_TASK_ROUTER_GATE.md",
"02_STOP_FIX_VERIFY_GATE.md",
"03_SMOKE_BREAK_FOCUS_GATE.md",
"04_CONDENSE_SOURCE_LINK_GATE.md",
"05_SELF_AUDIT_IDEA_CAPTURE_GATE.md",
"06_START_OVER_CARRY_FORWARD_GATE.md",
"07_NEIGHBOR_COMPOUND_GROWTH_GATE.md",
"08_LOCAL_ONLY_PROMPT_PACKAGE_GATE.md",
"09_SINGLE_LOAD_CARD.md",
"10_BABBLING_FOOL_GATE.md",
"11_SUIT_ADOPT_ADAPT_GATE.md",
"12_LIVE_IDEA_INTAKE_AND_NEIGHBOR_HANDOFF_GATE.md",
"13_HOUSE_LINKED_CHAT_SUIT_ARMATURE_GATE.md",
"14_CHAT_SUIT_HOUSE_LINK_MAP.md",
"15_RESPECTFUL_SUIT_MAP_AND_FORKS_GATE.md",
"16_SOURCE_LINKS_AND_PROOF.md",
"MANIFEST.md"
)

$MissingBefore = @()
foreach ($R in $Required) {
    if (!(Test-Path -LiteralPath (Join-Path $Active $R))) { $MissingBefore += $R }
}
if ($MissingBefore.Count -gt 0) {
    throw "BLOCKED: active package missing required files before update: $($MissingBefore -join ', ')"
}

$Marker = "STABLE_OVERWRITE_MULTI_SURFACE_UPDATE_DISCIPLINE"

$SectionLoad = @'
## Stable Overwrite / Multi-Surface Rule-Set Discipline

When updating an existing rule set, update the stable active filename in this package. Do not create more partial update folders, version-suffixed rule files, or duplicate active rule rooms unless the user explicitly asks.

Active rule room:
`C:\Users\13527\Desktop\GPT_Prompts\CHAT_GATE_SYSTEM_PACKAGE`

Source/custody room:
`C:\Users\13527\Desktop\GPT_Prompts\_PACKAGE_INTAKE`

Rule updates must respect:
- build/model/concept;
- neighbor gates;
- house-linked Suits;
- source links;
- cycles;
- proof surfaces;
- local-only boundary.

If a rule affects assistant runtime behavior, mirror the distilled behavior in assistant-local chat rules. Do not put prompt packages in Git.
'@

$SectionLocalPrompt = @'
## Stable Overwrite / Clean Package Room Rule

Prompt-package updates use stable filenames in the active package room.

Allowed:
- overwrite the current active rule file;
- update MANIFEST and source/proof file;
- write local receipt;
- hold source packages under `_PACKAGE_INTAKE`.

Blocked:
- Git add/commit/push;
- public export;
- extra active package rooms;
- version-suffixed duplicates for the same rule;
- leaving package debris at the porch/root.

If a rule is missing, retrieve or install the missing stable file into the active package. Do not create a second active rule set.
'@

$SectionNeighbor = @'
## Rule-Set Update Neighbor Respect

When one gate changes, check its neighbors.

For every rule update:
- source idea;
- affected gate;
- affected Suit;
- upstream neighbor;
- downstream neighbor;
- fork affected;
- proof need;
- final judge.

A change is clean only if it improves the active rule without breaking its neighbor handoff, house link, cycle, or proof surface.
'@

$SectionSource = @'
## Stable Overwrite Source Addition

Captured concept:
When updating existing rule sets, overwrite the existing stable active files so the user knows exactly which ones to grab. Use intake for source custody. Do not make more scattered update folders or duplicate rule sets. Updates must respect the build, model, concept, neighbors, cycles, house-linked Suits, source links, and proof.

Source:
Current user instruction during GPT_Prompts package cleanup.
'@

$SectionSingle = @'
## Stable Update Short Rule

When a chat-gate rule needs improvement:
update the stable active file;
preserve source link;
check neighbor Suit;
write local receipt;
do not Git;
do not create a duplicate active rule room.
'@

Upsert-Section -Path (Join-Path $Active "00_LOAD_FIRST__CHAT_GATE_SYSTEM.md") -Marker $Marker -Section $SectionLoad
Upsert-Section -Path (Join-Path $Active "08_LOCAL_ONLY_PROMPT_PACKAGE_GATE.md") -Marker $Marker -Section $SectionLocalPrompt
Upsert-Section -Path (Join-Path $Active "07_NEIGHBOR_COMPOUND_GROWTH_GATE.md") -Marker $Marker -Section $SectionNeighbor
Upsert-Section -Path (Join-Path $Active "16_SOURCE_LINKS_AND_PROOF.md") -Marker $Marker -Section $SectionSource
Upsert-Section -Path (Join-Path $Active "09_SINGLE_LOAD_CARD.md") -Marker $Marker -Section $SectionSingle

# Update MANIFEST with the stable update discipline.
$ManifestPath = Join-Path $Active "MANIFEST.md"
$ManifestSection = @'
## Update Discipline

This package uses stable overwrite filenames. Update the active files in place. Use `_PACKAGE_INTAKE` for source custody and receipts. Do not create duplicate active rule rooms. Do not put prompts in Git.
'@
Upsert-Section -Path $ManifestPath -Marker $Marker -Section $ManifestSection

# Assistant-local mirror if ASSISTANT_LOCAL exists.
$AssistantMirrorStatus = "ASSISTANT_LOCAL not found; no mirror written"
$AssistantMirrorPath = ""
if (Test-Path -LiteralPath $AssistantLocal) {
    New-Item -ItemType Directory -Path $AssistantRules,$AssistantReceipts -Force | Out-Null
    $AssistantMirrorPath = Join-Path $AssistantRules "RULE_SET_STABLE_OVERWRITE_AND_MULTI_SURFACE_UPDATE_GATE.md"
    $Mirror = @'
# RULE SET STABLE OVERWRITE AND MULTI-SURFACE UPDATE GATE

STATUS: LOCAL-ONLY ASSISTANT RUNTIME MIRROR / NOT DOCTRINE / NOT GIT

PURPOSE:
When a chat-rule or prompt-package rule changes, update the active stable rule files and any needed local runtime mirror. Do not only remember it in chat.

CORE RULE:
Update the real rule rooms that need the behavior:
- active prompt package: `C:\Users\13527\Desktop\GPT_Prompts\CHAT_GATE_SYSTEM_PACKAGE`
- package/source custody: `C:\Users\13527\Desktop\GPT_Prompts\_PACKAGE_INTAKE`
- assistant runtime mirror when behavior affects live assistant work: `C:\Users\13527\Desktop\ASSISTANT_LOCAL\CHAT_RULES_LOCAL_ONLY`

STABLE OVERWRITE:
If a rule already has a stable active filename, overwrite that file. Do not create a second active version or partial duplicate.

NEIGHBOR RESPECT:
Every update checks:
- source;
- affected gate;
- affected Suit;
- upstream neighbor;
- downstream neighbor;
- fork/cycle affected;
- proof need;
- final judge.

BOUNDARY:
- No Git.
- No push.
- No public export.
- No doctrine promotion.
- No duplicate active package rooms.

FINAL JUDGE:
The rule is updated where it actually operates, with source/proof and no package sprawl.
'@
    Set-Content -LiteralPath $AssistantMirrorPath -Value $Mirror -Encoding UTF8

    $RouterPath = Join-Path $AssistantRules "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
    if (Test-Path -LiteralPath $RouterPath) {
        $RouterSection = @'
## Router Addendum — Stable Rule-Set Update / Multi-Surface Respect

ASSISTANT: for updating existing chat rules, prompt packages, or assistant runtime rules, go to the stable overwrite / multi-surface update gate.

Use:
`CHAT_RULES_LOCAL_ONLY\RULE_SET_STABLE_OVERWRITE_AND_MULTI_SURFACE_UPDATE_GATE.md`

Rule:
Update the active stable file, source/proof it, check neighbor Suits and cycles, mirror runtime behavior when needed, and do not create duplicate active rule rooms. No Git for prompt packages.
'@
        Upsert-Section -Path $RouterPath -Marker $Marker -Section $RouterSection
    }
    $AssistantMirrorStatus = "ASSISTANT_LOCAL mirror written"
}

# Verify all required active files still exist and hash targets.
$MissingAfter = @()
foreach ($R in $Required) {
    if (!(Test-Path -LiteralPath (Join-Path $Active $R))) { $MissingAfter += $R }
}
if ($MissingAfter.Count -gt 0) { throw "FAILED: missing required active files after update: $($MissingAfter -join ', ')" }

$UpdatedFiles = @(
Join-Path $Active "00_LOAD_FIRST__CHAT_GATE_SYSTEM.md",
Join-Path $Active "07_NEIGHBOR_COMPOUND_GROWTH_GATE.md",
Join-Path $Active "08_LOCAL_ONLY_PROMPT_PACKAGE_GATE.md",
Join-Path $Active "09_SINGLE_LOAD_CARD.md",
Join-Path $Active "16_SOURCE_LINKS_AND_PROOF.md",
Join-Path $Active "MANIFEST.md"
)
if ($AssistantMirrorPath) { $UpdatedFiles += $AssistantMirrorPath }
$RouterMaybe = Join-Path $AssistantRules "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
if (Test-Path -LiteralPath $RouterMaybe) { $UpdatedFiles += $RouterMaybe }

$PromptReceipt = Join-Path $PromptReceipts "STABLE_OVERWRITE_MULTI_SURFACE_RULE_UPDATE_$Stamp.txt"
$ActiveReceipt = Join-Path $ActiveReceipts "STABLE_OVERWRITE_MULTI_SURFACE_RULE_UPDATE_$Stamp.txt"
$Lines = @()
$Lines += "STABLE OVERWRITE MULTI-SURFACE RULE UPDATE RECEIPT"
$Lines += "Timestamp: $Stamp"
$Lines += "Verdict: PASS / ACTIVE RULE FILES UPDATED / ASSISTANT MIRROR CHECKED / LOCAL ONLY / NO GIT"
$Lines += ""
$Lines += "Active prompt package:"
$Lines += "- $Active"
$Lines += ""
$Lines += "Assistant-local mirror status:"
$Lines += "- $AssistantMirrorStatus"
$Lines += ""
$Lines += "Required active files verified:"
$Lines += "- $($Required.Count)"
$Lines += "Missing after update:"
$Lines += "- $($MissingAfter.Count)"
$Lines += ""
$Lines += "Updated / checked files:"
foreach ($F in $UpdatedFiles | Sort-Object -Unique) {
    $Lines += "- $F"
    $Lines += "  SHA256: $(Get-HashText -Path $F)"
}
$Lines += ""
$Lines += "Boundary:"
$Lines += "- Local-only."
$Lines += "- No Git."
$Lines += "- No push."
$Lines += "- No public export."
$Lines += "- Not doctrine."
$Lines += "- Stable overwrite filenames preserved."
$Lines += "- Package source/custody remains under GPT_Prompts\\_PACKAGE_INTAKE."
$Lines += ""
$Lines += "Rule:"
$Lines += "- Update active stable files; do not create duplicate active rule rooms."
$Lines += "- Mirror assistant-runtime behavior only where needed."
$Lines += "- Respect build/model/concept/neighbors/cycles/house-linked Suits/source/proof."

Set-Content -LiteralPath $PromptReceipt -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8
Set-Content -LiteralPath $ActiveReceipt -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

if (Test-Path -LiteralPath $AssistantReceipts) {
    $AssistantReceipt = Join-Path $AssistantReceipts "STABLE_OVERWRITE_MULTI_SURFACE_RULE_UPDATE_$Stamp.txt"
    Set-Content -LiteralPath $AssistantReceipt -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8
}

Write-Host "STABLE OVERWRITE MULTI-SURFACE RULE UPDATE COMPLETE"
Write-Host "Active package: $Active"
Write-Host "Required files verified: $($Required.Count)"
Write-Host "Missing after update: $($MissingAfter.Count)"
Write-Host "Assistant mirror: $AssistantMirrorStatus"
Write-Host "Receipt: $PromptReceipt"
Write-Host "Verdict: PASS / RULE SETS UPDATED WHERE NEEDED / LOCAL ONLY / NO GIT"
