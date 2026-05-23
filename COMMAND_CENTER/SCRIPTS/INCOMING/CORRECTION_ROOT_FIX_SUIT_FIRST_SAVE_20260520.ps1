$ErrorActionPreference = "Stop"

function Invoke-GitChecked {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(& git @Args 2>&1)
    if ($LASTEXITCODE -ne 0) {
        $Output | ForEach-Object { Write-Host $_ }
        throw ("Git failed: git " + ($Args -join " "))
    }
    return $Output
}

function Get-GitLine {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(Invoke-GitChecked @Args)
    if ($Output.Count -lt 1) {
        throw ("Git returned no output: git " + ($Args -join " "))
    }
    return ([string]($Output | Select-Object -First 1)).Trim()
}

function Write-Utf8Text {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )
    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }
    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Wrote empty file: " + $Path) }
    if ($Raw.Contains([char]0)) { throw ("NUL byte found after write: " + $Path) }
    if ($Raw.Contains([char]0xFFFD)) { throw ("Replacement character found after write: " + $Path) }
}

function Assert-Needle {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle
    )
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if (-not $Raw.Contains($Needle)) {
        throw ("Verification needle missing in " + $Path + ": " + $Needle)
    }
}

function Append-IfMissing {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Text
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        Write-Utf8Text -Path $Path -Text $Text
        return
    }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if (-not $Raw.Contains($Needle)) {
        Add-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    }
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== CORRECTION ROOT FIX + SUIT FIRST SAVE START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$BaseHead = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$BaseShort = Get-GitLine rev-parse --short HEAD
$Status = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") {
    throw ("Wrong branch: " + $Branch)
}

if ($BaseHead -ne $Origin) {
    throw "HEAD does not match origin/main. Stop before save."
}

if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Repo is dirty. Stop before save."
}

$ExpectedBase = "bf71e4adf25ff6a5d2cc2775e6d5610927daf4f7"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess.")
}

$RootRulePath = "BRAIN_LEARNING\ROOT_PROBLEM_CLEANUP_AND_CORRECTION_CAPTURE_RULE_20260520.md"
$SuitRulePath = "BRAIN_LEARNING\SUIT_FIRST_BEFORE_ROUTE_LOADOUT_RULE_20260520.md"
$DissectionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CORRECTION_ROOT_FIX_SUIT_FIRST_DISSECTION_20260520.md"
$TodoPath = "HOUSE_WORK\TODO\SUIT_LOADOUT_BEFORE_BOSS_GHOST_ROUTE_LIVE_USE_TODO_20260520.md"
$RcePath = "HOUSE_WORK\WORK_SHED\RELATION_MAPS\RULE_CONCEPT_EVENT_LINK_MAP_SEED_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ReceiptPath = "PROOF_HISTORY\CORRECTION_ROOT_FIX_SUIT_FIRST_SAVE_RECEIPT_20260520.txt"

$RootRule = @'
# Root Problem Cleanup And Correction Capture Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support rule / root repair behavior
Parent Boss: Rule Activation / Work-Order Control
Neighbor Boss: Memory Health / Rule-Concept-Event / Suit Loadout
Authority: not doctrine, not active guide, not CURRENT_TRUTH_INDEX, not command surface

## Core rule

When the user corrects the assistant, or the assistant corrects itself, and the correction fits the build, the system must not leave the problem sitting as a chat apology.

The correction must trigger root cleanup:

1. admit the miss precisely;
2. identify the rule, suit, order, or route that should have fired;
3. identify the event that exposed the miss;
4. identify the concept family;
5. separate the cluster into atomic pieces;
6. decide adopt / adapt / park / reject / needs proof;
7. save or park the correction in the right lane when project-relevant;
8. update the next route so the same miss is not repeated.

## Patchwork block

Do not cover a real root problem with nicer wording.

A polite correction that does not change routing is air freshener.

A real fix removes or contains the source of the problem.

If the issue is a rule-not-fired event, wrong order, stale state, wrong authority, wrong lane, or mule-output overread, it requires root cleanup.

## Doctor posture

The house should behave like a doctor, not a smell-coverer.

Symptoms matter, but the work is to find the source and clean it.

If a problem is project-relevant and current, do not let it linger. Clean it, place it, or park it with proof.

## Adoption rule

Agreeing with the user is not enough.

Agreement is clean only when the correction fits the build, neighbor rules, evidence, authority boundaries, and current state.

If the user is correct, adopt or adapt the correction and push on.

If the user is partly correct, separate the valid root from the extra force and save the usable piece.

If the correction is wrong or unsafe, explain the boundary and do not adopt.

## Dissect trigger

Dense corrective language must fire the Dissect Rule.

The assistant should split the message into atomic pieces, not answer as a mood.

Required buckets:

- root problem;
- missed trigger;
- wrong order;
- correct order;
- rule/concept/event link;
- adopt/adapt/park/reject/needs-proof;
- save lane;
- next action.

## Boundary

This rule does not authorize panic edits, doctrine rewrites, active guide rewrites, CURRENT_TRUTH_INDEX rewrites, or broad system rebuilds.

It authorizes precise cleanup of a proven root problem.
'@

$SuitRule = @'
# Suit First Before Route Loadout Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support rule / active loadout ordering
Parent Boss: Rule Activation / Work-Order Control
Neighbor Boss: Tool-Suit-Rule Lifecycle / Boss-Ghost TODO Routing / Mule Return Intake
Authority: not doctrine, not active guide, not CURRENT_TRUTH_INDEX, not tool promotion

## Core rule

Do not walk into a selected route naked when the house state requires a suit.

If a next move depends on active supports, lifecycle state, mule-return boundaries, or multiple live-use watches, the next step is not the downstream task alone.

The next step is:

Suit fit -> current worn loadout -> then route work.

## Why this exists

After mule return intake, the assistant treated the mule's recommended first read target as the immediate next move.

The user corrected this: next needed to be the suit.

That correction fits the build.

The mule output may identify a route, but the house must first decide what suit/loadout is being worn so the route is approached with the right active support and boundaries.

## Suit loadout questions

Before approaching Boss/Ghost TODO work, answer:

1. What are we wearing now?
2. What support rules are active only because their trigger is present?
3. What Soft Suit watches are being worn naturally, not promoted?
4. What tools fire before action?
5. What stays parked?
6. What is not allowed to become king?
7. What would count as proof that the suit helped or failed?
8. What stops the work from becoming another support-rule whirlpool?

## Current intended loadout

For the present state, the likely worn suit includes:

- Mule return custody boundary: mule output is support evidence, not command authority.
- Relevant Root Key selector: choose only the keys/tools that change action.
- No Rule King / Better-Fit: do not let mule output, Boss/Ghost, suit, or selector become king.
- Boss/Ghost map: use parent-boss routing after suit fit.
- Tool-Suit-Rule lifecycle audit: unload map is retrieval/disposition, not promotion queue.
- Report/correction root cleanup: if a missed trigger appears, capture root cause, not apology only.

## Boundary

Suit first does not mean promotion first.

It does not mean a new suit must be created each time.

It means the current working loadout must be named enough to prevent wrong-order work.

After suit fit, the route may still be Boss/Ghost TODO work, or the suit may reveal a safer first move.
'@

$Dissection = @'
# Correction Root Fix And Suit-First Dissection

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: corrective dissection / root fix package
Base HEAD: bf71e4adf25ff6a5d2cc2775e6d5610927daf4f7
Authority: sorting/support only

## Trigger event

After mule return intake was read, the assistant concluded that the next move was the mule's recommended Boss/Ghost TODO target.

User corrected this: next needed to be the suit.

Assistant agreed because the correction fits the build.

User then clarified the deeper rule:

When the assistant or user catches a real problem and the correction fits the build, the system must not let the problem linger or cover it with patchwork. It must separate, dissect, capture, adopt/adapt, and fix root behavior.

## What went wrong

The assistant over-followed the mule's recommendation as immediate route pressure.

The mule output was support evidence, not command authority.

The assistant skipped the predecessor step: suit/loadout fit.

This was a wrong-order failure, not a lack-of-information failure.

## Atomic pieces

### 1. Correction must become root cleanup

Disposition: APPLY.

A real correction that fits the build must trigger root cleanup, not just agreement.

Lane:
BRAIN_LEARNING.

Proof:
Future correction events must produce a clear missed trigger / concept / event / lane decision before continuing.

### 2. No air-freshener patchwork

Disposition: APPLY.

Do not solve root problems by nicer wording, apology, or moving on.

Lane:
BRAIN_LEARNING and proof receipts.

Proof:
Future receipts should name root cause when a failure is repaired.

### 3. Suit first before route

Disposition: APPLY WITH GUARDRAILS.

Before approaching a selected route that depends on active supports, decide the current worn suit/loadout.

Lane:
BRAIN_LEARNING + TODO live-use.

Proof:
Next live work must perform suit fit before Boss/Ghost TODO route.

### 4. Mule output is not next-move authority

Disposition: REAFFIRM / APPLY.

Mule may recommend the first route, but house order controls whether a predecessor step is required.

Lane:
MULE_WORKSHOP / return intake boundary.

Proof:
Mule recommendations must be translated through house state and suit loadout before action.

### 5. Dissect Rule must fire on dense correction clusters

Disposition: APPLY.

This message required dissection because it contained root cleanup, anti-patchwork, doctor posture, adoption/adaptation, and immediate save/capture.

Lane:
BRAIN_LEARNING + Sorting Bench.

Proof:
This file exists and separates the cluster.

### 6. Rule-Concept-Event entries must be updated

Disposition: APPLY.

The correction must be linked to the concept and event.

Lane:
RELATION_MAPS.

Proof:
RCE map receives entries for correction root cleanup and suit-first wrong-order failure.

### 7. Do not promote the suit from this event alone

Disposition: GUARDRAIL.

Suit-first ordering is support behavior, not doctrine or active guide.

Lane:
BRAIN_LEARNING / TODO live-use.

Proof:
Future live use determines whether this becomes stronger.

## Adopt / Adapt / Park / Reject / Needs Proof

APPLY:
- root cleanup after correction;
- no patchwork for rule-not-fired/wrong-order failures;
- suit fit before route when active loadout matters.

ADAPT:
- mule's Boss/Ghost first read target becomes downstream-after-suit, not immediate command.

PARK:
- any dashboard/knowledge graph/full lesson index pressure.

REJECT:
- apology-only fixes;
- mule-output-as-command;
- another mule pass by inertia;
- support-rule whirlpool.

NEEDS PROOF:
- next live suit loadout before Boss/Ghost route;
- whether suit-first should later become a stronger active guide rule.

## Current corrected next order

1. Build/read the current suit loadout.
2. State what active supports are being worn and what stays parked.
3. Only then approach Boss/Ghost Rule-Firing Cycle Flow TODO if the suit still points there.
4. Define proof before any save or repair.
'@

$Todo = @'
# TODO - Suit Loadout Before Boss/Ghost Route Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: open / immediate live-use needed
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Tool-Suit-Rule Lifecycle / Mule Return Intake

## Purpose

Prove the corrected order:

Suit fit -> current worn loadout -> then Boss/Ghost TODO route.

## Trigger

This TODO is triggered now because:

- mule return was imported/read;
- mule recommended Boss/Ghost first read target;
- user corrected that next must be the suit;
- correction fits the build;
- root cleanup has been saved.

## Required next live use

Before reading/repairing `BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md`, produce a suit/loadout fit check that names:

1. active suit/supports being worn;
2. why each one is active now;
3. what is parked;
4. what cannot become king;
5. what proof would show the suit helped;
6. what stop condition prevents support-rule whirlpool;
7. whether Boss/Ghost TODO remains the downstream route.

## Pass condition

The next real work uses the named suit/loadout before the downstream route.

## Fail condition

The assistant jumps directly to Boss/Ghost TODO or another task without naming the current suit/loadout.

## Boundary

No suit promotion.

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No mule-output adoption from this TODO alone.
'@

$RceAppend = @'

## Entry 08 - Correction Must Trigger Root Fix

Rule:
When the user or assistant catches a real problem and the correction fits the build, the system must separate, dissect, capture, adopt/adapt, and fix the root instead of leaving the issue as a chat apology.

Concept:
Root problem cleanup; anti-patchwork; rule activation; doctor posture.

Event:
After mule return intake, assistant agreed that suit should be next but had not yet converted the correction into a saved root fix. User clarified that problems should not linger or be covered with air freshener; they must be cleaned at the root.

Trigger phrases:
correct yourself; I correct you; fits the build; not patchwork; fix the root; do not let it linger; clean it now; adopt adapt push on.

Proof state:
Saved as support rule. Needs future live-use proof on next correction event.

Neighbor rules:
Dissect Rule; Rule-not-fired alarm; No Rule King; Discovery Path learning; FREEZE -> CAPTURE -> POWER PLAY.

## Entry 09 - Suit First Before Route

Rule:
When current work depends on active supports, lifecycle state, mule-return boundaries, or multiple watches, run suit/loadout fit before downstream route work.

Concept:
Suit theory; active loadout; wrong-order prevention; tool-suit-rule lifecycle.

Event:
Mule recommended Boss/Ghost TODO as first read target. User corrected that next needed to be the suit. Assistant recognized the correction fit the build.

Trigger phrases:
next needs to be the suit; what are we wearing; loadout; suit first; do not go in naked; approach it with the suit.

Proof state:
Saved as support rule and immediate TODO. Needs live proof before promotion.

Neighbor rules:
Mule output is support only; Relevant Root Key selector; No Rule King; Boss/Ghost map; unload map retrieval/disposition.

## Entry 10 - Mule Recommendation Is Downstream Evidence, Not Command

Rule:
A mule recommendation can identify a downstream route, but the house decides whether predecessor steps are required before action.

Concept:
Mule sharpens, house decides; custody boundary; authority translation; source output not command.

Event:
The assistant treated the mule's first-read recommendation as immediate next action. The user corrected the order to suit-first.

Trigger phrases:
mule says; output says; next target; but the house needs; suit before; not command authority.

Proof state:
Reaffirmed during correction root-fix save. Needs future mule-return intake proof.

Neighbor rules:
Known-path mule pickup; return intake; stale/custody check; no doctrine/guide/index rewrite.
'@

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Current active ball after this save: Suit loadout before Boss/Ghost route

## Last completed move

Saved correction root cleanup and suit-first ordering after the assistant incorrectly treated the mule's Boss/Ghost first-read recommendation as the immediate next move.

Saved:

- root problem cleanup after correction;
- no air-freshener patchwork rule;
- suit first before route loadout rule;
- dissection of the correction event;
- Rule-Concept-Event map entries;
- immediate live-use TODO for suit loadout before Boss/Ghost route.

## Current control state

Mule return is imported/read as support evidence.

Mule output is not command authority.

The next route is not "Boss/Ghost TODO naked."

The next route is:

Suit fit -> current worn loadout -> then Boss/Ghost TODO if still selected.

## Next allowed move

Build/read the current suit loadout for this exact moment.

The loadout must say:

1. what support/suit pieces are active now;
2. why each is active;
3. what stays parked;
4. what cannot become king;
5. what proof shows the suit helped;
6. what stop condition prevents support-rule whirlpool;
7. whether `HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md` remains the downstream route.

## Blocked moves

- Do not jump directly to Boss/Ghost TODO without suit/loadout fit.
- Do not treat mule output as command authority.
- Do not save apology-only patches.
- Do not create another mule pass by inertia.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not promote suit-first, stale checker, relation map, tools, or suits from this one event.
'@

Write-Utf8Text -Path $RootRulePath -Text $RootRule
Write-Utf8Text -Path $SuitRulePath -Text $SuitRule
Write-Utf8Text -Path $DissectionPath -Text $Dissection
Write-Utf8Text -Path $TodoPath -Text $Todo
Write-Utf8Text -Path $AnchorPath -Text $Anchor

Append-IfMissing -Path $RcePath -Needle "Entry 08 - Correction Must Trigger Root Fix" -Text $RceAppend

$StatusAppend = @"

---

## 2026-05-20 - Correction root fix and suit-first ordering

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- $RootRulePath
- $SuitRulePath
- $DissectionPath
- $TodoPath
- appended Rule-Concept-Event entries to $RcePath
- updated $AnchorPath
- updated this status file

Why:
After mule return intake, the assistant treated the mule's Boss/Ghost first-read recommendation as the immediate next move. User corrected that next needed to be the suit. Correction fits the build.

Meaning:
Corrections that fit the build must trigger root cleanup, not apology-only patchwork. The current next order is suit fit -> current worn loadout -> then Boss/Ghost route if still selected.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, no suit/tool/relation-map/stale-checker promotion, and no mule output adoption.

Next:
Build/read current suit loadout for this moment before downstream Boss/Ghost TODO work.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $RootRulePath -Needle "Do not cover a real root problem with nicer wording"
Assert-Needle -Path $SuitRulePath -Needle "Suit fit -> current worn loadout -> then route work"
Assert-Needle -Path $DissectionPath -Needle "mule-output-as-command"
Assert-Needle -Path $TodoPath -Needle "Suit fit -> current worn loadout -> then Boss/Ghost TODO route"
Assert-Needle -Path $RcePath -Needle "Entry 08 - Correction Must Trigger Root Fix"
Assert-Needle -Path $AnchorPath -Needle "Suit loadout before Boss/Ghost route"

$HashTargets = @(
    $RootRulePath,
    $SuitRulePath,
    $DissectionPath,
    $TodoPath,
    $RcePath,
    $AnchorPath,
    $StatusPath
)

$HashLines = New-Object System.Collections.Generic.List[string]
foreach ($Path in $HashTargets) {
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    $HashLines.Add("- " + $Path + " | sha256=" + $Hash) | Out-Null
}

$Receipt = @"
CORRECTION ROOT FIX AND SUIT-FIRST SAVE RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Saved:
- $RootRulePath
- $SuitRulePath
- $DissectionPath
- $TodoPath
- $RcePath
- $AnchorPath
- $StatusPath

Core correction:
The assistant treated the mule's Boss/Ghost first-read recommendation as immediate next action. User corrected that next needed to be the suit. The correction fits the build, so it was dissected and saved as a root fix.

Adopt/adapt/park/reject:
- APPLY: correction must trigger root cleanup, not apology-only patchwork.
- APPLY: no air-freshener patchwork for real root problems.
- APPLY WITH GUARDRAILS: suit fit before route when active loadout matters.
- ADAPT: mule's Boss/Ghost first-read target becomes downstream-after-suit, not immediate command.
- PARK: dashboard/knowledge graph/full lesson index pressure.
- REJECT: mule-output-as-command and support-rule whirlpool.
- NEEDS PROOF: next live suit loadout before Boss/Ghost route.

Hashes:
$($HashLines -join [Environment]::NewLine)

Boundary held:
- no doctrine rewrite;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no suit/tool/relation-map/stale-checker promotion;
- no mule output adoption.

Next move:
Build/read current suit loadout for this moment before downstream Boss/Ghost TODO work.
"@

Write-Utf8Text -Path $ReceiptPath -Text $Receipt
Assert-Needle -Path $ReceiptPath -Needle "mule's Boss/Ghost first-read target becomes downstream-after-suit"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) {
    throw "No changes detected after writing correction package."
}

Invoke-GitChecked add -- $RootRulePath $SuitRulePath $DissectionPath $TodoPath $RcePath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "No staged files before commit."
}

Invoke-GitChecked commit -m "Lock correction cleanup suit first order" | Out-Null
Invoke-GitChecked push origin main | Out-Null
Invoke-GitChecked fetch origin main | Out-Null

$FinalHead = Get-GitLine rev-parse HEAD
$FinalOrigin = Get-GitLine rev-parse origin/main
$FinalShort = Get-GitLine rev-parse --short HEAD
$FinalStatus = @(Invoke-GitChecked status --short)

if ($FinalHead -ne $FinalOrigin) {
    throw "Final proof failed: HEAD does not match origin/main."
}

if ($FinalStatus.Count -ne 0) {
    Write-Host "Final dirty status:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final proof failed: status not clean."
}

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CORRECTION ROOT FIX AND SUIT-FIRST ORDER SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $RootRulePath)
Write-Host ("- " + $SuitRulePath)
Write-Host ("- " + $DissectionPath)
Write-Host ("- " + $TodoPath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Updated:"
Write-Host ("- " + $RcePath)
Write-Host ("- " + $AnchorPath)
Write-Host ("- " + $StatusPath)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS: correction was dissected instead of patched."
Write-Host "- PASS: root-cleanup-after-correction rule saved."
Write-Host "- PASS: suit-first-before-route order saved."
Write-Host "- PASS: mule recommendation adapted to downstream-after-suit."
Write-Host ""
Write-Host "Boundary:"
Write-Host "- No doctrine rewrite."
Write-Host "- No active guide rewrite."
Write-Host "- No CURRENT_TRUTH_INDEX rewrite."
Write-Host "- No dashboard, automation, runtime, knowledge graph, or full lesson index."
Write-Host "- No suit/tool/relation-map/stale-checker promotion."
Write-Host "- No mule output adoption."
Write-Host ""
Write-Host "Next move:"
Write-Host "- Build/read the current suit loadout."
Write-Host "- Then approach Boss/Ghost TODO only if the suit still points there."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
