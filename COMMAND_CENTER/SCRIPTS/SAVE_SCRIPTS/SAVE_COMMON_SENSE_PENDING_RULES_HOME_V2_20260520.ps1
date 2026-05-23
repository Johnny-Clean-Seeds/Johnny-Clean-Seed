# SAVE_COMMON_SENSE_PENDING_RULES_HOME_V2_20260520.ps1
# CODE CARD: COMMON_SENSE_PENDING_SAVE_V2
# PURPOSE: Home the pending Common Sense source ore and two candidate rules.
# MODE: Real Mr.Kleen save/commit/push with proof.
# BOUNDARY: No mule return intake. No doctrine install. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite.
# LONG-CODE RULE: This script is grouped into labeled tabs so later work can pull the nearest skeleton and tweak only task inputs.

# ============================================================
# TAB 00 — CONTROL STATE / ABORT LATCH
# ============================================================

$ErrorActionPreference = "Stop"

trap {
    Write-Host ""
    Write-Host "XxXxX ===== COMMON SENSE PENDING SAVE FAILED ===== XxXxX"
    Write-Host $_.Exception.Message
    exit 1
}

# ============================================================
# TAB 01 — HELPERS
# ============================================================

function Invoke-GitChecked {
    param([Parameter(Mandatory = $true)][string[]]$Args)

    $Out = & git @Args 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Args -join ' ') failed:`n$($Out -join "`n")"
    }

    return $Out
}

function Write-Utf8FileSafe {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )

    $Dir = Split-Path $Path
    if (-not [string]::IsNullOrWhiteSpace($Dir)) {
        New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    }

    Set-Content -Path $Path -Value $Text -Encoding UTF8
}

function Copy-FileSafe {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    $Dir = Split-Path $Destination
    if (-not [string]::IsNullOrWhiteSpace($Dir)) {
        New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    }

    Copy-Item -Path $Source -Destination $Destination -Force
}

function Assert-FileContains {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if (-not (Test-Path $Path)) {
        throw "Missing file for check '$Name': $Path"
    }

    $Text = Get-Content -Path $Path -Raw
    if ($Text -notmatch [regex]::Escape($Needle)) {
        throw "Required content check failed: $Name"
    }
}

function Assert-NoBadText {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $Text = Get-Content -Path $Path -Raw
    if ($Text.Contains([char]0xFFFD) -or $Text -match "`0") {
        throw "Bad replacement/NUL character found in $Name`: $Path"
    }
    if ($Text -match ("\\[PLACE" + "HOLDER\\]") -or $Text -match ("TODO" + ": fill") -or $Text -match ("lorem " + "ipsum")) {
        throw "Placeholder junk found in $Name`: $Path"
    }
}

# ============================================================
# TAB 02 — REPO GUARDS
# ============================================================

if (-not (Test-Path ".git")) {
    throw "Not inside Mr.Kleen repo home."
}

$Root = ((Invoke-GitChecked @("rev-parse", "--show-toplevel")) -join "").Trim()
Set-Location $Root

$Branch = ((Invoke-GitChecked @("branch", "--show-current")) -join "").Trim()
$HeadBefore = ((Invoke-GitChecked @("rev-parse", "HEAD")) -join "").Trim()

Invoke-GitChecked @("fetch", "origin", "main") | Out-Null
$OriginBefore = ((Invoke-GitChecked @("rev-parse", "origin/main")) -join "").Trim()
$StatusBefore = Invoke-GitChecked @("status", "--short")

if ($HeadBefore -ne $OriginBefore) {
    throw "HEAD does not match origin/main."
}

if ($StatusBefore.Count -gt 0) {
    throw "Working tree not clean before save."
}

# ============================================================
# TAB 03 — SOURCE ORE INPUT VALIDATION
# ============================================================

$Desktop = [Environment]::GetFolderPath("Desktop")
$SourceOreDesktop = Join-Path $Desktop "COMMON_SENSE_DEEP_CLEAN_MODEL_SOURCE_ORE_HELD_20260520.md"
$ExpectedSourceHash = "9642bacf169a6d223c9e878cc71cff3df6beb2f00f83eff885caf827ad99b461"

if (-not (Test-Path $SourceOreDesktop)) {
    throw "Missing source ore file on Desktop: $SourceOreDesktop"
}

$SourceHash = (Get-FileHash -Algorithm SHA256 -Path $SourceOreDesktop).Hash.ToLowerInvariant()
if ($SourceHash -ne $ExpectedSourceHash) {
    throw "Source ore hash mismatch. Expected $ExpectedSourceHash but got $SourceHash"
}

$SourceText = Get-Content -Path $SourceOreDesktop -Raw
if ($SourceText -notmatch "Common Sense / Relation-Aware Fit Judgment Rule") {
    throw "Source ore missing Common Sense rule candidate marker."
}
if ($SourceText -notmatch "Head-to-Toe Clean Publication Gate") {
    throw "Source ore missing publication gate marker."
}
if ($SourceText -notmatch "HELD SOURCE ORE") {
    throw "Source ore missing held-source-ore boundary marker."
}
if ($SourceText.Contains([char]0xFFFD) -or $SourceText -match "`0") {
    throw "Source ore has bad replacement/NUL character."
}

# ============================================================
# TAB 04 — DESTINATION PATHS / FILE NAMES
# ============================================================

$SourceOrePath = "HOUSE_WORK\WORK_SHED\IDEA_BAG\COMMON_SENSE_DEEP_CLEAN_MODEL_SOURCE_ORE_HELD_20260520.md"
$DissectionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\COMMON_SENSE_PENDING_RULES_HOME_DISSECTION_20260520.md"
$CommonSenseRulePath = "HOUSE_WORK\WORK_SHED\IDEA_BAG\COMMON_SENSE_RELATION_AWARE_FIT_JUDGMENT_RULE_CANDIDATE_20260520.md"
$PublicationGatePath = "HOUSE_WORK\WORK_SHED\IDEA_BAG\HEAD_TO_TOE_CLEAN_PUBLICATION_GATE_CANDIDATE_20260520.md"
$TodoPath = "HOUSE_WORK\TODO\COMMON_SENSE_AND_PUBLICATION_GATE_LIVE_USE_TODO_20260520.md"
$ReceiptPath = "PROOF_HISTORY\COMMON_SENSE_PENDING_RULES_HOME_RECEIPT_20260520.txt"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

# ============================================================
# TAB 05 — HOUSE FILE CONTENT / SOURCE ORE COPY
# ============================================================

Copy-FileSafe -Source $SourceOreDesktop -Destination $SourceOrePath

$Dissection = @"
# Common Sense Pending Rules Home Dissection

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: pending rule/source-ore placement
Authority: not doctrine; not active guide; not CURRENT_TRUTH_INDEX

## Why this exists

The common-sense discussion produced two rule-shaped candidates and one large source-ore object.

The user required that the ideas be gathered cleanly and checked from head to toe before treating them as truth.

The mule has completed work, but its return is not being intaken in this save.

This save homes pending ideas only.

## Source ore

Source file copied from Desktop:

$SourceOreDesktop

Expected SHA256:

$ExpectedSourceHash

House copy:

$SourceOrePath

## Candidate 1

Common Sense / Relation-Aware Fit Judgment Rule.

Purpose:
Before judging a nontrivial issue, map what matters, what the issue touches, what scale fits, what proof is enough, what would defeat the claim, and what must carry forward.

## Candidate 2

Head-to-Toe Clean Publication Gate.

Purpose:
Before producing a model file as truth, check coverage, boundary, clean fit, internal consistency, proof scope, bloat, carryover, and artifact health.

## Relationship to existing house pieces

This connects to:

- After-Fix Carryover Latch;
- Relation Method / Across-the-Board Relation Lens;
- Filing Cabinet / Reusable Workflow Skeleton Method;
- Artifact Self-Check After Send Gate;
- proof hygiene;
- memory-is-not-house-capture boundary;
- mule worker boundary.

## Disposition

Accepted as pending house candidates.

Not installed as doctrine.

Not promoted to active guide.

Not written to CURRENT_TRUTH_INDEX.

Not treated as future behavior proof.

## Long-code / Filing Cabinet note

This save script itself is a long-code object and should be treated as a future Filing Cabinet skeleton candidate only if it proves useful.

It is grouped into labeled tabs so later work can retrieve the closest skeleton and tweak target inputs instead of generating another cousin script.

## Blocked

- No mule return intake here.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine install.
- No runtime/tool install.
- No dashboard.
- No automation.
- No knowledge graph.
- No full lesson index.
"@

$CommonSenseRule = @"
# Common Sense / Relation-Aware Fit Judgment Rule Candidate

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / IDEA_BAG
Status: rule candidate / pending live-use proof
Authority: not doctrine; not active guide; not CURRENT_TRUTH_INDEX

## Purpose

Use common sense as clean fit judgment, not as vague opinion.

Before judging a nontrivial issue, ask:

- What matters here?
- What does this touch?
- What scale of action fits?
- What proof is enough?
- What would defeat the claim?
- What must carry forward?

## Definition

Common sense is relation-aware relevance control under proof and feedback.

Clean Seed form:

The system knows what matters here, what this touches, what scale of action fits, what proof is enough, and what must carry forward.

## Trigger

Use on:

- new rules;
- repeated failures;
- artifacts;
- mule returns;
- PowerShell/local workflows;
- proof receipts;
- handoffs;
- common-sense claims;
- cross-lane issues;
- anything that feels obvious but may have hidden relations.

## Required fields

1. Home lane.
2. Touched neighbor lanes.
3. Parent boss.
4. Child ghosts.
5. Relevant prior repair memory.
6. Fit action.
7. Proof needed.
8. Carryover disposition.
9. Stop condition.
10. What would defeat the judgment.

## Boundary

Common sense is not authority over proof.

It is a fit signal that must be checked against proof, lane, source, and boundary.

## Proof of use

This candidate passes first live-use proof when a future nontrivial issue is judged by relation-aware fit instead of vibe, assumption, or single-lane reading.
"@

$PublicationGate = @"
# Head-to-Toe Clean Publication Gate Candidate

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / IDEA_BAG
Status: rule candidate / pending live-use proof
Authority: not doctrine; not active guide; not CURRENT_TRUTH_INDEX

## Purpose

Before producing a model file as truth, the assistant must prove the file is clean enough to present.

This gate exists because a clean model file can become authority-like if it is not labeled, checked, and bounded.

## Trigger

Use before printing or delivering:

- model summaries;
- doctrine-like source ore;
- rule candidates;
- handoff packets;
- mule packets;
- deep scans;
- conceptual maps;
- downloadable files;
- anything the user may treat as durable.

## Required checks

### 1. Coverage check

- Are all major ideas included?
- Are earlier corrections included?
- Are missing branches named?

### 2. Boundary check

- Is this truth, source ore, candidate, draft, or installed rule?
- Is authority clearly marked?

### 3. Clean fit check

- Does each idea sit in the right lane?
- Are human, nonhuman, machine, system, and house forms separated cleanly?

### 4. Internal consistency check

- Does any section contradict another?
- Are common sense, proof, relation, carryover, and authority kept distinct?

### 5. Proof check

- Does the file claim only what can be supported?
- Are uncertain areas marked?
- Are future-proof claims blocked unless proof is named?

### 6. Bloat check

- Is anything decorative without function?
- Is anything repeated without adding clarity?

### 7. Carryover check

- What rule, method, TODO, or live-use watch did this expose?
- Is it installed, held, parked, blocked, or memory-only?

### 8. Artifact check

- File exists.
- File opens.
- Required sections exist.
- No placeholders.
- No truncation.
- No bad characters.
- Hash can be provided.

## Stop condition

Do not call the file truth unless it passes these checks or the limits are stated.

## Proof of use

This candidate passes first live-use proof when a future durable file is checked head-to-toe before being presented as clean.
"@

$Todo = @"
# TODO — Common Sense + Head-to-Toe Publication Gate Live-Use Test

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: open support TODO
Authority: TODO support only; not command authority

## Purpose

Test the pending common-sense candidates in real work.

## Candidate A

Common Sense / Relation-Aware Fit Judgment Rule.

Pass condition:
A future nontrivial issue is judged by relation-aware fit, with home lane, touched lanes, proof needed, carryover disposition, and defeat condition named.

## Candidate B

Head-to-Toe Clean Publication Gate.

Pass condition:
A future durable file or model object is checked for coverage, boundary, fit, consistency, proof scope, bloat, carryover, and artifact health before being called clean.

## Source ore

Held source ore copied to:

$SourceOrePath

## Long-code tie-in

When long local code is needed, the assistant should use the Filing Cabinet pattern:

- name the code card;
- label the purpose;
- group it into tabs/sections;
- make target inputs easy to find;
- keep proof and final copy block separate;
- later retrieve and tweak the closest proven skeleton instead of generating from scratch.

## Boundary

This TODO does not install the rules.

It does not command active work by existence.

It does not rewrite active guides.

It does not rewrite CURRENT_TRUTH_INDEX.

It does not intake mule return.

## Later disposition

After live use, decide:

- keep as candidate;
- adapt;
- park;
- block;
- save as support behavior;
- promote only through separate proof.
"@

Write-Utf8FileSafe -Path $DissectionPath -Text $Dissection
Write-Utf8FileSafe -Path $CommonSenseRulePath -Text $CommonSenseRule
Write-Utf8FileSafe -Path $PublicationGatePath -Text $PublicationGate
Write-Utf8FileSafe -Path $TodoPath -Text $Todo

# ============================================================
# TAB 06 — CONTENT CHECKS / HEAD-TO-TOE MINI GATE
# ============================================================

$Checks = [ordered]@{
    "Source ore copied" = @($SourceOrePath, "Common Sense — Deep Clean Model Source Ore")
    "Source ore held" = @($SourceOrePath, "HELD SOURCE ORE")
    "Common sense candidate" = @($CommonSenseRulePath, "Common Sense / Relation-Aware Fit Judgment Rule Candidate")
    "Common sense proof" = @($CommonSenseRulePath, "What would defeat the judgment.")
    "Publication candidate" = @($PublicationGatePath, "Head-to-Toe Clean Publication Gate Candidate")
    "Publication artifact check" = @($PublicationGatePath, "Artifact check")
    "TODO candidate A" = @($TodoPath, "Candidate A")
    "TODO candidate B" = @($TodoPath, "Candidate B")
    "TODO long-code tie-in" = @($TodoPath, "name the code card")
    "Dissection no mule intake" = @($DissectionPath, "No mule return intake here.")
    "Dissection filing cabinet note" = @($DissectionPath, "future Filing Cabinet skeleton candidate")
}

foreach ($Name in $Checks.Keys) {
    Assert-FileContains -Path $Checks[$Name][0] -Needle $Checks[$Name][1] -Name $Name
}

$FilesToCleanCheck = @(
    $SourceOrePath,
    $DissectionPath,
    $CommonSenseRulePath,
    $PublicationGatePath,
    $TodoPath
)

foreach ($File in $FilesToCleanCheck) {
    Assert-NoBadText -Path $File -Name $File
}

# ============================================================
# TAB 07 — HASHES / ANCHOR / STATUS UPDATE
# ============================================================

$SourceOreHash = (Get-FileHash -Algorithm SHA256 -Path $SourceOrePath).Hash
$DissectionHash = (Get-FileHash -Algorithm SHA256 -Path $DissectionPath).Hash
$CommonSenseHash = (Get-FileHash -Algorithm SHA256 -Path $CommonSenseRulePath).Hash
$PublicationHash = (Get-FileHash -Algorithm SHA256 -Path $PublicationGatePath).Hash
$TodoHash = (Get-FileHash -Algorithm SHA256 -Path $TodoPath).Hash

$AnchorText = @"
ACTIVE BALL: Common Sense pending rules and source ore homed.

BASE BEFORE SAVE: main @ $($HeadBefore.Substring(0,7))

CURRENT PROVEN ITEMS:
- Common Sense deep clean source ore copied into Idea Bag.
- Common Sense / Relation-Aware Fit Judgment Rule candidate homed.
- Head-to-Toe Clean Publication Gate candidate homed.
- Shared live-use TODO created.
- Sorting Bench dissection saved.
- Long-code grouping / Filing Cabinet tie-in captured in the TODO.
- This is pending/candidate placement only.

NEXT ALLOWED MOVE:
- Get/intake mule return files when ready.
- Do not let this pending save replace mule disposition.
- Use these candidates only as live-use/watch material until proof exists.
- Use labeled tabs/groups for future long local code and prefer prior skeletons when available.

BLOCKED:
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not install doctrine.
- Do not build dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not treat these candidates as live-proven.
"@

Write-Utf8FileSafe -Path $AnchorPath -Text $AnchorText

$StatusText = Get-Content -Path $StatusPath -Raw
$StatusAdd = @"

## Common Sense Pending Rules Home Save

Status: SAVED
Date: 2026-05-20
Base before save: main @ $($HeadBefore.Substring(0,7))

Saved:
- $SourceOrePath
- $DissectionPath
- $CommonSenseRulePath
- $PublicationGatePath
- $TodoPath
- $ReceiptPath

Updated:
- $AnchorPath
- $StatusPath

Meaning:
- Common Sense deep clean source ore was copied into Idea Bag.
- Common Sense / Relation-Aware Fit Judgment Rule was homed as a candidate.
- Head-to-Toe Clean Publication Gate was homed as a candidate.
- A shared TODO now tracks live-use proof for both.
- Long-code grouping / Filing Cabinet tie-in was captured.
- This save does not intake or adopt mule return files.

Boundary:
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine install.
- No runtime/tool install.
- No dashboard, automation, knowledge graph, or full lesson index.
"@

if ($StatusText -notmatch "Common Sense Pending Rules Home Save") {
    $StatusText = $StatusText.TrimEnd() + $StatusAdd
}

Write-Utf8FileSafe -Path $StatusPath -Text $StatusText

$AnchorHash = (Get-FileHash -Algorithm SHA256 -Path $AnchorPath).Hash
$StatusHash = (Get-FileHash -Algorithm SHA256 -Path $StatusPath).Hash

# ============================================================
# TAB 08 — RECEIPT
# ============================================================

$Receipt = @"
COMMON SENSE PENDING RULES HOME RECEIPT
Date: 2026-05-20

Branch before save:
$Branch

HEAD before save:
$HeadBefore

origin/main before save:
$OriginBefore

Desktop source ore:
$SourceOreDesktop
SHA256:
$SourceHash

Saved:
- $SourceOrePath
  SHA256: $SourceOreHash
- $DissectionPath
  SHA256: $DissectionHash
- $CommonSenseRulePath
  SHA256: $CommonSenseHash
- $PublicationGatePath
  SHA256: $PublicationHash
- $TodoPath
  SHA256: $TodoHash
- $ReceiptPath

Updated:
- $AnchorPath
  SHA256: $AnchorHash
- $StatusPath
  SHA256: $StatusHash

Verdict:
PASS — common-sense pending source ore and rule candidates homed.

Meaning:
- Common Sense / Relation-Aware Fit Judgment Rule candidate placed.
- Head-to-Toe Clean Publication Gate candidate placed.
- Full common-sense source ore placed.
- Shared live-use TODO created.
- Long-code grouping / Filing Cabinet tie-in captured.

Proof limit:
This proves placement/save only.
It does not prove future live-use behavior.
It does not install doctrine.
It does not intake mule return.

Boundary:
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine install.
- No runtime/tool install.
- No dashboard, automation, knowledge graph, or full lesson index.
"@

Write-Utf8FileSafe -Path $ReceiptPath -Text $Receipt

# ============================================================
# TAB 09 — GIT SAVE / PUSH / FINAL PROOF
# ============================================================

git add -- $SourceOrePath $DissectionPath $CommonSenseRulePath $PublicationGatePath $TodoPath $AnchorPath $StatusPath
git add -f -- $ReceiptPath

$Staged = Invoke-GitChecked @("diff", "--cached", "--name-only")
if ($Staged.Count -eq 0) {
    throw "Nothing staged."
}

Invoke-GitChecked @("commit", "-m", "Home common sense pending rules") | Out-Null
Invoke-GitChecked @("push", "origin", "main") | Out-Null

$FinalStatus = Invoke-GitChecked @("status", "--short")
$FinalHead = ((Invoke-GitChecked @("rev-parse", "HEAD")) -join "").Trim()

Invoke-GitChecked @("fetch", "origin", "main") | Out-Null
$FinalOrigin = ((Invoke-GitChecked @("rev-parse", "origin/main")) -join "").Trim()

if ($FinalStatus.Count -gt 0) {
    throw "Final status not clean:`n$($FinalStatus -join "`n")"
}

if ($FinalHead -ne $FinalOrigin) {
    throw "Final HEAD does not match origin/main."
}

# ============================================================
# TAB 10 — FINAL COPY BLOCK
# ============================================================

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "COMMON SENSE PENDING RULES HOME PASS"
Write-Host "Branch: $Branch"
Write-Host "HEAD: $FinalHead"
Write-Host "origin/main: $FinalOrigin"
Write-Host "Status: clean"
Write-Host "Saved: $SourceOrePath"
Write-Host "Saved: $DissectionPath"
Write-Host "Saved: $CommonSenseRulePath"
Write-Host "Saved: $PublicationGatePath"
Write-Host "Saved: $TodoPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
