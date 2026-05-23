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

Write-Host "XxXxX ===== HABIT PATTERN TRANSFER SAVE START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$BaseHead = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$BaseShort = Get-GitLine rev-parse --short HEAD
$Status = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") { throw ("Wrong branch: " + $Branch) }
if ($BaseHead -ne $Origin) { throw "HEAD does not match origin/main. Stop before save." }
if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Repo is dirty. Stop before save."
}

$ExpectedBase = "e672c2aac40120e0f3a5d8bdefc9d80f0eb90397"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess.")
}

$GatePath = "BRAIN_LEARNING\RULE_FIRING_CONFIRMATION_BEFORE_ACTION_GATE_20260520.md"
$CardPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\RULE_FIRING_CONFIRMATION_CARD_20260520.md"
foreach ($Path in @($GatePath,$CardPath)) {
    if (-not (Test-Path -LiteralPath $Path)) { throw ("Required file missing: " + $Path) }
}
Assert-Needle -Path $GatePath -Needle "Before any nontrivial Mr.Kleen house-touching action"
Assert-Needle -Path $CardPath -Needle "If the card cannot be filled, do not act yet"

$RulePath = "BRAIN_LEARNING\HABIT_PATTERN_MIMIC_ADOPT_ADAPT_TRANSFER_RULE_20260520.md"
$DissectionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\HABIT_PATTERN_MIMIC_ADOPT_ADAPT_DISSECTION_20260520.md"
$TodoPath = "HOUSE_WORK\TODO\HABIT_PATTERN_MIMIC_ADOPT_ADAPT_LIVE_USE_TODO_20260520.md"
$RcePath = "HOUSE_WORK\WORK_SHED\RELATION_MAPS\RULE_CONCEPT_EVENT_LINK_MAP_SEED_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ReceiptPath = "PROOF_HISTORY\HABIT_PATTERN_TRANSFER_RULE_SAVE_RECEIPT_20260520.txt"

$Rule = @'
# Habit Pattern, Mimic, Adopt, And Adapt Transfer Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support rule / pattern-transfer learning
Parent Boss: Rule Activation / Work-Order Control
Neighbor Boss: Growth Cycle / Memory Health / Rule-Concept-Event / Adapt-Adopt
Authority: not doctrine, not active guide, not CURRENT_TRUTH_INDEX, not automation

## Core insight

Habits are not just repeated actions.

Habits are repeated firing patterns.

A habit shows what actually happens often enough to become evidence:

- what rule fires naturally;
- what rule fails to fire;
- what path the system prefers;
- what support is overused;
- what correction repeats;
- what plan transfers into other lanes;
- what breaks when copied without adaptation.

## Why habits matter

A habit gives structure because it turns isolated events into a pattern.

One miss can be noise.

Two similar misses can be a warning.

Three or more similar misses can reveal a root route, a stable behavior, a weak gate, or a reusable plan shape.

The house should inspect habits as evidence, not as moral labels.

## Mimic / Adopt / Adapt system

Mimic, adopt, and adapt form a small transfer system.

### Mimic

Mimic means noticing a working shape and reproducing it carefully.

Use mimic when:
- the target lane is similar;
- the original plan shape is proven;
- direct copying does not violate authority or context;
- the goal is to test whether the same pattern works again.

Risk:
Mimic without context becomes surface-command mimicry.

### Adopt

Adopt means keeping the pattern because it fits the current lane and neighbor rules.

Use adopt when:
- the pattern works as-is;
- proof carries cleanly;
- authority boundary matches;
- it reduces bloat or drift;
- it improves behavior.

Risk:
Adopt without proof becomes fake authority.

### Adapt

Adapt means keeping the useful shape while changing it for a different lane, scale, trigger, or authority level.

Use adapt when:
- the plan works in one area but the new area has different constraints;
- a direct copy would be wrong;
- the concept is useful but the implementation must change.

Risk:
Adapt without preserving the original proof path becomes invention drift.

## Transfer rule

When a plan works in one area, do not automatically promote it everywhere.

Ask:

1. What habit or repeated pattern does this plan reveal?
2. What part is the stable shape?
3. What part is local context?
4. Should the new use mimic, adopt, or adapt?
5. What proof is needed in the new lane?
6. What authority boundary changes?
7. What stale or false-transfer risk appears?

## Relationship to good fog

Habits help turn good fog into walkable structure.

Repeated memories, corrections, and events become fog.

Habit recognition finds trails in the fog.

Mimic/adopt/adapt decides whether a trail can be used in another room.

## Relationship to rule firing

Rule-firing confirmation produces habit evidence over time.

If the same gate fires cleanly across varied situations, that becomes a healthy habit.

If the same rule fails to fire repeatedly, that becomes a root failure pattern.

## Boundary

This rule does not promote any habit to doctrine.

This rule does not authorize copying plans across lanes without proof.

This rule does not create a dashboard, automation, runtime, knowledge graph, or full lesson index.

It is a support lens for pattern transfer and growth-cycle learning.
'@

$Dissection = @'
# Habit Pattern, Mimic, Adopt, And Adapt Dissection

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: dissected learning cluster / support-only
Base HEAD: e672c2aac40120e0f3a5d8bdefc9d80f0eb90397
Authority: sorting/support only

## Trigger event

After the Rule-Firing Confirmation Card was saved and readied for first live use, the user identified another missing puzzle piece:

Habits.

The user said habits help show patterns, give more structure, and show how one plan can work in other areas in different ways. This leads to mimic, adopt, and adaptation. Those three may form a system of their own.

## Why this matters now

The current house problem is not lack of rules.

The current problem is whether rules actually fire, whether repeated behavior becomes visible, and whether working shapes can transfer cleanly without becoming mimic-only or fake authority.

Habit recognition is the bridge between isolated event proof and reusable pattern transfer.

## Atomic pieces

### 1. Habits as evidence

Disposition: APPLY.

A habit is repeated behavior that proves what the system actually does.

It can reveal:
- stable capability;
- repeated failure;
- hidden preference;
- drift route;
- transferable plan shape.

### 2. Habits give structure

Disposition: APPLY.

Habits turn separate events into relation structure.

A single event is evidence.
Repeated events become pattern.
Pattern can become route, warning, or candidate method.

### 3. Mimic

Disposition: APPLY WITH GUARDRAILS.

Mimic copies a working shape into a similar situation.

Good mimic preserves proof path and context.

Bad mimic copies surface behavior without understanding.

### 4. Adopt

Disposition: APPLY WITH GUARDRAILS.

Adopt keeps a pattern as-is because it fits the new lane.

Adoption requires proof, authority fit, neighbor fit, and anti-bloat fit.

### 5. Adapt

Disposition: APPLY.

Adapt carries the useful structure into a different context while changing what must change.

Adapt is the safest transfer path when the pattern is useful but context differs.

### 6. MAA as a mini-system

Disposition: CAPTURE AS SUPPORT LENS.

Mimic -> Adopt -> Adapt can function as a small transfer system.

It helps decide how an idea moves between rooms without pretending all rooms are the same.

### 7. Habit link to Rule-Firing Confirmation

Disposition: APPLY.

Rule-Firing Confirmation Card will generate habit evidence:
- what gate fires;
- what gate misses;
- what route repeats;
- what proof keeps recurring.

## Adopt / Adapt / Park / Reject / Needs Proof

APPLY:
- habits as pattern evidence;
- habits as structure for growth-cycle learning;
- mimic/adopt/adapt as transfer lens.

ADAPT:
- use MAA only as a support lens now, not doctrine.

PARK:
- broad knowledge graph, dashboard, or habit index until repeated proof requires it.

REJECT:
- surface-command mimicry;
- adopting plans across lanes without proof;
- treating one repeated behavior as permanent identity.

NEEDS PROOF:
- first live use where a habit/pattern is identified and routed through mimic/adopt/adapt.
- later review to see whether MAA deserves stronger placement.

## Current meaning

The puzzle pieces now connect:

Event proof shows what happened.
Habit shows what repeats.
Pattern gives structure.
Mimic tests same-shape transfer.
Adopt keeps a fit.
Adapt changes the shape for a new lane.
Growth cycle compresses repeated proof later.
'@

$Todo = @'
# TODO - Habit Pattern / Mimic Adopt Adapt Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: open / live-use proof needed
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Growth Cycle / Memory Health / Rule-Concept-Event

## Purpose

Prove that habit recognition can help the house identify repeated patterns and route them through mimic, adopt, or adapt.

## Trigger

Use this TODO when:

- a behavior repeats across multiple events;
- a rule fires or fails to fire more than once;
- a plan works in one room and appears useful in another;
- the house is about to copy a method, rule, script, packet, or workflow into a different lane.

## Required live use

On a real repeated pattern, answer:

1. What repeated habit/pattern is visible?
2. Is it healthy, risky, or mixed?
3. What is the stable shape?
4. What is local context only?
5. Should the next use mimic, adopt, or adapt?
6. What proof is needed in the new lane?
7. What authority boundary must hold?
8. What stale/false-transfer risk exists?

## Pass condition

The habit lens changes the decision: mimic, adopt, adapt, park, reject, or needs proof.

## Fail condition

The assistant copies a plan because it feels similar without identifying habit, context, proof, or authority boundary.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from this capture alone.
'@

$RceAppend = @'

## Entry 12 - Habits As Pattern Transfer Evidence

Rule:
Repeated behavior should be treated as habit evidence: it can reveal what actually fires, what fails to fire, and what plan shape may transfer.

Concept:
Habit pattern; growth-cycle evidence; good fog compression; transfer structure.

Event:
After the Rule-Firing Confirmation Card was created, the user identified that habits show patterns, give structure, and reveal how one plan can work in other areas in different ways.

Trigger phrases:
habits; patterns; same plan in other areas; mimic; adopt; adaptation; puzzle parts.

Proof state:
Saved as support learning. Needs first live-use proof on an actual repeated pattern.

Neighbor rules:
Rule-Firing Confirmation Gate; Discovery Path learning; Rule-Concept-Event map; Good Fog; Growth Cycle.

## Entry 13 - Mimic Adopt Adapt Transfer Lens

Rule:
When moving a working plan to another area, decide whether to mimic, adopt, or adapt instead of copying blindly.

Concept:
Pattern transfer; lane/context fit; anti-surface-command mimicry; better-fit adoption.

Event:
User named mimic, adopt, and adaptation as a small system that may explain how habits and plans transfer between areas.

Trigger phrases:
mimic; adopt; adapt; works in other areas; transfer; same shape different lane.

Proof state:
Captured as support lens. Needs varied live use before stronger placement.

Boundary:
Not doctrine, not active guide, not automation, not dashboard.
'@

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Current active ball after this save: Rule-Firing Confirmation Card live use, with Habit / Mimic-Adopt-Adapt lens parked for proof

## Last completed move

Saved Habit Pattern / Mimic Adopt Adapt transfer learning.

This save captured:

- habits as repeated firing-pattern evidence;
- habits as structure for good fog and growth-cycle learning;
- mimic as same-shape transfer test;
- adopt as proof-fit acceptance;
- adapt as shape-preserving/context-changing transfer;
- MAA as a support lens, not doctrine;
- live-use TODO for first proof.

## Current control state

The active next operational gate remains:

Rule-Firing Confirmation Before Action Gate.

The habit/MAA lens is available as support when a repeated pattern or transfer decision appears.

## Next allowed move

Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action.

If that action involves repeated behavior or plan transfer, also use the Habit / Mimic-Adopt-Adapt lens.

## Blocked moves

- Do not promote Habit/MAA from this capture alone.
- Do not create a dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not copy plans across lanes without proof.
'@

Write-Utf8Text -Path $RulePath -Text $Rule
Write-Utf8Text -Path $DissectionPath -Text $Dissection
Write-Utf8Text -Path $TodoPath -Text $Todo
Append-IfMissing -Path $RcePath -Needle "Entry 12 - Habits As Pattern Transfer Evidence" -Text $RceAppend
Write-Utf8Text -Path $AnchorPath -Text $Anchor

$StatusAppend = @"

---

## 2026-05-20 - Habit pattern / mimic-adopt-adapt transfer learning

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- $RulePath
- $DissectionPath
- $TodoPath
- appended entries to $RcePath
- updated $AnchorPath
- updated this status file

Meaning:
Habits are repeated firing-pattern evidence. They show what actually repeats, reveal stable or broken routes, and help decide whether a plan should mimic, adopt, or adapt when moved into another lane.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, and no promotion.

Next:
Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action. Use Habit/MAA lens only when repeated pattern or transfer decision appears.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $RulePath -Needle "Mimic, adopt, and adapt form a small transfer system"
Assert-Needle -Path $DissectionPath -Needle "Habit recognition is the bridge"
Assert-Needle -Path $TodoPath -Needle "mimic, adopt, or adapt"
Assert-Needle -Path $RcePath -Needle "Entry 12 - Habits As Pattern Transfer Evidence"
Assert-Needle -Path $AnchorPath -Needle "Habit / Mimic-Adopt-Adapt lens parked for proof"

$HashTargets = @(
    $RulePath,
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
HABIT PATTERN TRANSFER RULE SAVE RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Rule-Firing Confirmation Card used before this save:
- State: clean at e672c2a.
- Intended action: save Habit Pattern / Mimic Adopt Adapt transfer learning.
- Fired gate: Rule-Firing Confirmation Before Action Gate.
- Why it fired: this is a nontrivial Mr.Kleen house-touching action.
- Blocked: doctrine, active guide, CURRENT_TRUTH_INDEX, dashboard, automation, runtime, knowledge graph, full lesson index, promotion.
- Proof needed: files written, receipt, commit, push, final clean state.
- Disposition: save support learning.

Saved:
- $RulePath
- $DissectionPath
- $TodoPath
- $RcePath
- $AnchorPath
- $StatusPath

Core learning:
Habits are repeated firing-pattern evidence. Habits show patterns, add structure, and help decide whether a working plan should be mimicked, adopted, or adapted in another lane.

Disposition:
- APPLY: habits as pattern evidence.
- APPLY: mimic/adopt/adapt as transfer lens.
- ADAPT: keep MAA support-only for now.
- PARK: dashboard, automation, runtime, knowledge graph, full lesson index.
- NEEDS PROOF: first live use on a repeated behavior or transfer decision.

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
- no promotion.

Next move:
Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action. Use Habit/MAA lens only when repeated pattern or transfer decision appears.
"@

Write-Utf8Text -Path $ReceiptPath -Text $Receipt
Assert-Needle -Path $ReceiptPath -Needle "Rule-Firing Confirmation Card used before this save"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) { throw "No changes detected after writing habit transfer package." }

Invoke-GitChecked add -- $RulePath $DissectionPath $TodoPath $RcePath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) { throw "No staged files before commit." }

Invoke-GitChecked commit -m "Add habit pattern transfer lens" | Out-Null
Invoke-GitChecked push origin main | Out-Null
Invoke-GitChecked fetch origin main | Out-Null

$FinalHead = Get-GitLine rev-parse HEAD
$FinalOrigin = Get-GitLine rev-parse origin/main
$FinalShort = Get-GitLine rev-parse --short HEAD
$FinalStatus = @(Invoke-GitChecked status --short)

if ($FinalHead -ne $FinalOrigin) { throw "Final proof failed: HEAD does not match origin/main." }
if ($FinalStatus.Count -ne 0) {
    Write-Host "Final dirty status:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final proof failed: status not clean."
}

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "HABIT PATTERN TRANSFER LENS SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $RulePath)
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
Write-Host "- PASS: Rule-Firing Confirmation Card used before save."
Write-Host "- PASS: habits captured as repeated firing-pattern evidence."
Write-Host "- PASS: mimic/adopt/adapt captured as support transfer lens."
Write-Host "- PASS: lens parked for live-use proof, not promoted."
Write-Host ""
Write-Host "Boundary:"
Write-Host "- No doctrine rewrite."
Write-Host "- No active guide rewrite."
Write-Host "- No CURRENT_TRUTH_INDEX rewrite."
Write-Host "- No dashboard, automation, runtime, knowledge graph, or full lesson index."
Write-Host "- No promotion."
Write-Host ""
Write-Host "Next move:"
Write-Host "- Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action."
Write-Host "- Use Habit/MAA lens only when repeated pattern or transfer decision appears."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
