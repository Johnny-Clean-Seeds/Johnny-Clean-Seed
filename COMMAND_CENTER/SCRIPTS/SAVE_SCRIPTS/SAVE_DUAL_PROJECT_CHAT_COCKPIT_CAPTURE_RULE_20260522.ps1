$ErrorActionPreference = "Stop"

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"

if (-not (Test-Path -LiteralPath $Repo)) {
    throw "Repo not found: $Repo"
}

Set-Location -LiteralPath $Repo

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not in a git repo: $Repo"
}

$DirtyBefore = git status --short
if ($DirtyBefore) {
    Write-Host "BLOCKED - REPO NOT CLEAN"
    Write-Host "Dirty status before save:"
    $DirtyBefore | ForEach-Object { Write-Host $_ }
    exit 1
}

$OldHead = (git rev-parse HEAD).Trim()
$Date = Get-Date -Format "yyyyMMdd"

$RulePath = "BRAIN_LEARNING/DUAL_PROJECT_AND_CHAT_COCKPIT_CAPTURE_RULE_20260522.md"
$CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/DUAL_PROJECT_CHAT_COCKPIT_CAPTURE_FAILURE_CAPTURE_20260522.md"
$ReceiptPath = "PROOF_HISTORY/DUAL_PROJECT_CHAT_COCKPIT_CAPTURE_RULE_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

$ExistingCockpit = Get-ChildItem -LiteralPath . -Recurse -File -Filter "CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "\\.git\\" } |
    Sort-Object FullName |
    Select-Object -First 1

if ($ExistingCockpit) {
    $CockpitPath = (Resolve-Path -LiteralPath $ExistingCockpit.FullName -Relative).TrimStart(".\","./")
} else {
    $CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
}

New-Item -ItemType Directory -Force -Path (Split-Path $RulePath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $CapturePath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $ReceiptPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $StatusPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $CockpitPath) | Out-Null

$Rule = @"
# Dual Project + Chat Cockpit Capture Rule — 20260522

## Status

Type: brain-learning / assistant operating rule.

Boundary:
- This is a project-wide capture-and-route behavior rule.
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not grant permission to save unsafe material.
- This does not bypass proof gates.

## Problem Fixed

The assistant treated project-relevant rules/concepts/ideas as one-lane objects.

That is wrong.

Some material belongs in the durable project house.
Some material belongs in the live chat cockpit.
Some material belongs in both.

When a rule affects how the assistant should behave in chat, saving it only in Mr.Kleen is incomplete.
When a rule affects the project as a whole, keeping it only in chat is incomplete.

## Core Rule

Default to both when the material is project-relevant and assistant-facing.

Unless the user explicitly says otherwise:

1. Save durable project rules/concepts/ideas into the project house through the correct lane and proof route.
2. Also update the chat cockpit/card when the rule changes assistant chat behavior.
3. Keep the project-wide version and chat-facing version linked by name, date, and source correction.

## Previous-Reply Scan Rule

Before replying in Clean Seed / Mr.Kleen work, the assistant must scan its immediately previous answer for project-relevant material it introduced.

The assistant must ask:

1. Did I introduce a rule?
2. Did I introduce a concept?
3. Did I introduce a process?
4. Did I introduce a tool pattern?
5. Did I introduce a project object?
6. Did I create a phrase that should become a short rule?
7. Did the user's last correction reveal a missing rule?
8. Does any of it belong in the chat cockpit?

If yes, route it.

Do not let useful project material float.

## User-Input Scan Rule

When the user says something project-related, treat it as possible source root.

The assistant must decide whether it is:

- founding original / source root
- clean translation candidate
- behavior rule
- tool rule
- proof rule
- save rule
- cockpit rule
- source-ore
- TODO
- parked idea
- rejection / blocked item

Then route it.

## Both-Lanes Rule

A rule belongs in the durable project house when it affects:

- project structure
- file/tool design
- saves
- proof
- source custody
- bridge/mule work
- naming
- routing
- object roles
- recurring behavior
- future work

A rule also belongs in the chat cockpit when it affects:

- how the assistant replies
- how the assistant classifies tasks
- how the assistant handles corrections
- how the assistant delivers code
- how the assistant avoids repeating a mistake
- how the assistant decides whether to save, park, or ask

## Stop Condition

Do not save automatically if:

- repo is dirty
- material is private/sensitive and needs discussion
- user explicitly says no Git / local-only / do not save
- the material is raw transcript that should stay in source custody
- the lane is unclear
- the rule would promote doctrine, active guide, CURRENT_TRUTH_INDEX, automation, or runtime without explicit route

In that case, park or ask.

## Short Form

Project-relevant rule/concept/idea gets routed.

Assistant-facing rule gets cockpit visibility too.

Review previous reply before answering.

No floating project gold.
"@

$Capture = @"
# Dual Project + Chat Cockpit Capture Failure Capture — 20260522

## Status

Type: failure capture / correction-to-rule record.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The assistant saved or prepared rules unevenly and did not consistently treat project-relevant material as needing both durable project placement and chat cockpit visibility.

The user corrected this as a whole-project rule, not a one-off fix.

## Founding Original / Source Root

User correction included:

- "it needs to be done to both always unless i say otherwise that is a rule"
- "theres also a rule that you need to add rules as you see fit when i say or you say something project related"
- "you must re read your old reply everytme when you talk to me then catch if you said something rule/concept/idea/project related in anyway"
- "yes this means you must scan the projcet do it! you need this"
- "also when you notice certain rules belong to chat also brin it in the chat log too meaning the file that gets droupped in chat needs to be updated"

## Clean Translation

Project-relevant rule/concept/idea capture must not be one-lane.

Default handling:

- durable project save when it affects the project
- chat cockpit update when it affects assistant chat behavior
- both when both are true
- unless the user explicitly says otherwise

## Failure Pattern

The assistant waited for explicit save prompts instead of catching project-relevant rules/concepts/ideas from the user's correction or its own prior response.

The assistant also risked saving to the house without updating the chat-facing cockpit card.

## Repair

This save installs a behavior rule and updates the chat cockpit/card file with a compact operating addendum.

## Guardrail

This rule does not mean reckless auto-save.

It means capture, classify, route, and save/update through the right proof lane when project-relevant and safe.
"@

Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = @"
# Chat House Rules Cockpit Card — Applied Version — 20260522

## Status

Type: in-chat assistant operating card / cockpit sheet.

Purpose: hold assistant-facing project rules close enough to use during live work.

Boundary:
- This does not replace Mr.Kleen.
- This does not rewrite doctrine.
- This does not promote new doctrine.
- This is a working cockpit card for chat behavior.
"@
}

$AddendumMarker = "## 2.23 Dual Project + Chat Cockpit Capture Rule"

$Addendum = @"

---

$AddendumMarker

Default to both when the material is project-relevant and assistant-facing, unless the user explicitly says otherwise.

When the user or assistant introduces a project-related rule, concept, idea, correction, process, tool pattern, or project object:

1. classify it;
2. decide its durable project lane;
3. decide whether it also changes assistant chat behavior;
4. save or park it through the correct route;
5. update this cockpit card when it belongs in chat behavior.

Before replying during Clean Seed / Mr.Kleen work, scan the immediately previous assistant reply for any rule/concept/idea/project material that should be captured.

Blocked:
- no floating project gold;
- no saving only to the house when the rule must affect chat behavior;
- no updating chat only when the rule belongs in durable project memory;
- no reckless auto-save over dirty repo, privacy, unsafe scope, unclear lane, or promotion boundary.

Short form:
Project-relevant rule/concept/idea gets routed. Assistant-facing rule gets cockpit visibility too.
"@

if ($CockpitText -notlike "*$AddendumMarker*") {
    Set-Content -LiteralPath $CockpitPath -Value ($CockpitText.TrimEnd() + $Addendum) -Encoding UTF8
} else {
    $Pattern = [regex]::Escape($AddendumMarker) + ".*?(?=\r?\n---\r?\n|\z)"
    $NewCockpit = [regex]::Replace($CockpitText, $Pattern, $Addendum.TrimStart(), [System.Text.RegularExpressions.RegexOptions]::Singleline)
    Set-Content -LiteralPath $CockpitPath -Value $NewCockpit -Encoding UTF8
}

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$CaptureHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CapturePath).Hash
$CockpitHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CockpitPath).Hash

$Receipt = @"
DUAL PROJECT + CHAT COCKPIT CAPTURE RULE RECEIPT — 20260522

Verdict:
PASS - DUAL PROJECT CHAT COCKPIT CAPTURE RULE SAVED

Old HEAD:
$OldHead

Saved files:
$RulePath
SHA256: $RuleHash

$CapturePath
SHA256: $CaptureHash

$CockpitPath
SHA256: $CockpitHash

Boundary:
Project-wide capture-and-route behavior rule plus chat cockpit addendum only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No runtime change.

Short form:
Project-relevant rule/concept/idea gets routed.
Assistant-facing rule gets cockpit visibility too.
Review previous reply before answering.
No floating project gold.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

$StatusAppend = @"

## 20260522 — Dual Project + Chat Cockpit Capture Rule

Position before commit: $OldHead

Saved:
- $RulePath
- $CapturePath
- $CockpitPath
- $ReceiptPath

Verdict:
PASS - DUAL PROJECT CHAT COCKPIT CAPTURE RULE SAVED

Boundary:
Project-wide capture-and-route behavior rule plus chat cockpit addendum only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation.

Short form:
Project-relevant rule/concept/idea gets routed. Assistant-facing rule gets cockpit visibility too. Review previous reply before answering. No floating project gold.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $RulePath $CapturePath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Add dual project chat cockpit capture rule" | Out-Host
git push origin main | Out-Host

$NewHead = (git rev-parse HEAD).Trim()
$RemoteHead = (git rev-parse origin/main).Trim()
$FinalStatus = git status --short

if ($NewHead -ne $RemoteHead) {
    Write-Host "BLOCKED - REMOTE HEAD DOES NOT MATCH"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    exit 1
}

if ($FinalStatus) {
    Write-Host "BLOCKED - FINAL STATUS NOT CLEAN"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    exit 1
}

Write-Host "PASS - DUAL PROJECT CHAT COCKPIT CAPTURE RULE SAVED"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Rule: $RulePath"
Write-Host "Capture: $CapturePath"
Write-Host "Cockpit: $CockpitPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Boundary: project-wide capture-and-route behavior rule plus chat cockpit addendum only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation."
