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

Write-Host "XxXxX ===== RULE FIRING ROOT FIX SAVE START ===== XxXxX"

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

$ExpectedBase = "21ee27e1fcb69b5bf0fc639ee25702f1cc057de9"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess.")
}

$SuitRulePath = "BRAIN_LEARNING\SUIT_FIRST_BEFORE_ROUTE_LOADOUT_RULE_20260520.md"
$RootRulePath = "BRAIN_LEARNING\ROOT_PROBLEM_CLEANUP_AND_CORRECTION_CAPTURE_RULE_20260520.md"
$BossGhostTodoPath = "HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md"
$MuleAuditPath = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\BIG_OVERALL_JOB_20260520_051710_RETURN_INTAKE_20260520_054120\RAW_RETURN_DUMP\JOB_04_TOOL_SUIT_RULE_LIFECYCLE_AUDIT.md"

foreach ($Path in @($SuitRulePath,$RootRulePath,$BossGhostTodoPath,$MuleAuditPath)) {
    if (-not (Test-Path -LiteralPath $Path)) { throw ("Required file missing: " + $Path) }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Required file empty: " + $Path) }
}

Assert-Needle -Path $SuitRulePath -Needle "Suit fit -> current worn loadout -> then route work"
Assert-Needle -Path $RootRulePath -Needle "A real fix removes or contains the source of the problem"
Assert-Needle -Path $BossGhostTodoPath -Needle "Rule storage mistaken for rule firing"
Assert-Needle -Path $MuleAuditPath -Needle "The unload map should be a retrieval map, not a promotion queue"

$LiveProofPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\SUIT_LOADOUT_BEFORE_BOSS_GHOST_LIVE_USE_PROOF_20260520.md"
$SelectedRoutePath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RULE_STORAGE_MISTAKEN_FOR_RULE_FIRING_SELECTED_CHILD_ROUTE_20260520.md"
$GateRulePath = "BRAIN_LEARNING\RULE_FIRING_CONFIRMATION_BEFORE_ACTION_GATE_20260520.md"
$GateCardPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\RULE_FIRING_CONFIRMATION_CARD_20260520.md"
$TodoPath = "HOUSE_WORK\TODO\RULE_STORAGE_MISTAKEN_FOR_RULE_FIRING_CONFIRMATION_GATE_LIVE_USE_TODO_20260520.md"
$SuitTodoPath = "HOUSE_WORK\TODO\SUIT_LOADOUT_BEFORE_BOSS_GHOST_ROUTE_LIVE_USE_TODO_20260520.md"
$RcePath = "HOUSE_WORK\WORK_SHED\RELATION_MAPS\RULE_CONCEPT_EVENT_LINK_MAP_SEED_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ReceiptPath = "PROOF_HISTORY\RULE_FIRING_ROOT_FIX_CONFIRMATION_GATE_RECEIPT_20260520.txt"

$LiveProof = @'
# Suit Loadout Before Boss/Ghost - Live Use Proof

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: live-use proof / no promotion
Base HEAD before save: 21ee27e1fcb69b5bf0fc639ee25702f1cc057de9
Authority: proof of one live use only

## What happened

The saved anchor required:

Suit fit -> current worn loadout -> then Boss/Ghost TODO if still selected.

The assistant/user performed the required read sequence:

1. read current anchor;
2. read Suit First Before Route Loadout Rule;
3. read Root Problem Cleanup And Correction Capture Rule;
4. read Suit Loadout Before Boss/Ghost Route Live Use TODO;
5. read Correction Root Fix And Suit-First Dissection;
6. read Mule Tool/Suit Rule Lifecycle Audit;
7. then read Boss/Ghost Rule-Firing Cycle Flow TODO under the suit.

This proves the corrected order fired once.

## Worn suit/loadout for this moment

- Mule-custody shell: mule output is support evidence, not command authority.
- Suit-first ordering: the route was not entered naked.
- Relevant Root Key selector: only keys/tools that change the move are active.
- No Rule King / Better-Fit guard: no single item becomes king.
- Boss/Ghost routing frame: downstream routing after suit fit.
- Tool-Suit-Rule lifecycle filter: retrieval/disposition only, not promotion queue.
- Root-cleanup scalpel: missed trigger/correction must be cleaned at root.

## Selected downstream child route

Rule storage mistaken for rule firing.

Reason:
This is the live root pattern shown by recent misses:
- report style gate existed but did not fire;
- known-path mule pickup existed but did not fire;
- suit-first ordering was nearly skipped after mule recommendation;
- Boss/Ghost TODO explicitly names this as an activation flaw.

## Proof claim

PASS as one live-use proof that suit-first fired before Boss/Ghost route.

This does not promote suit-first to doctrine or active guide.

This does not close the TODO.

This does not adopt mule output as command authority.

This proof alone is not the root fix. The root fix is the Rule-Firing Confirmation Gate saved with this package.
'@

$SelectedRoute = @'
# Selected Child Route - Rule Storage Mistaken For Rule Firing

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: selected child route / narrow root fix selected
Parent Boss: Rule Activation / Work-Order Control
Authority: route selection only; not doctrine

## Selected child

Rule storage mistaken for rule firing.

## Why selected

This child is the clearest live root under Parent Boss 01.

The system has saved many rules, but recent work showed rules do not always fire at the moment of need.

Observed event chain:

1. Full report style gate existed but did not fire until user caught it.
2. Known-path mule pickup routine existed in context but did not fire until user caught it.
3. Mule recommendation was nearly treated as immediate route authority until user corrected suit-first ordering.
4. Boss/Ghost TODO names "Rule storage mistaken for rule firing" as an activation flaw requiring confirmation that rules fire before work.
5. Assistant nearly saved only proof of the event rather than the behavior mechanism. User caught that this was the aha moment to fix it.

## Current disposition

NARROW ROOT FIX SELECTED.

## Root fix

The fix is not another broad rule stack.

The fix is a small confirmation gate before house-touching action:

Name the active route.
Name the rule/suit/order that fired.
Name the proof that it fired.
Name what is blocked.
Name whether action is allowed, blocked, parked, or read-only.

## Boundary

- no doctrine rewrite;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no broad TODO repair;
- no promotion from this selection alone.

## Next proof

Use the Rule-Firing Confirmation Card on the next nontrivial Mr.Kleen action before touching the house.
'@

$GateRule = @'
# Rule-Firing Confirmation Before Action Gate

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support rule / narrow behavior mechanism
Parent Boss: Rule Activation / Work-Order Control
Authority: not doctrine, not active guide, not CURRENT_TRUTH_INDEX, not automation

## Core problem

The house can store a rule without the rule firing at the moment of need.

This is not solved by writing another broad rule.

It is solved by adding a small confirmation gate before house-touching action.

## Gate rule

Before any nontrivial Mr.Kleen house-touching action, the assistant must confirm the active rule/suit/order that fired.

Minimum confirmation:

1. Current control state.
2. Intended action.
3. Active gate that fired.
4. Why that gate applies now.
5. Blocked moves.
6. Proof needed.
7. Allowed disposition: read-only, save, park, block, or repair.

## When this gate fires

Use this gate when:

- touching Mr.Kleen files;
- writing a save script;
- reading a selected route after a correction;
- processing mule return;
- turning a correction into a fix;
- selecting TODO/parent boss route;
- any time the user says the right rule did not fire.

## When this gate should stay small

Do not recite the whole rule stack.

Do not create a dashboard.

Do not build automation.

Do not write a new support rule if the gate only needs to select an existing rule.

Use only the active 2-5 rules/tools/suit pieces that change the move.

## Confirmation card

Use this short card before action:

- State:
- Intended action:
- Fired gate:
- Why it fired:
- Blocked:
- Proof needed:
- Disposition:

If any field is unclear, stop and clarify, inspect, or park.

## Root repair claim

This is the narrow root repair for "rule storage mistaken for rule firing."

It creates an interruption point before action so the stored rule must be named as fired, not merely remembered afterward.

## Proof needed

Needs live proof on the next nontrivial Mr.Kleen action.

Pass condition:
The assistant uses the confirmation card before action and the card changes or validates the move.

Fail condition:
The assistant starts action and only explains the rule afterward.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from this save alone.
'@

$GateCard = @'
# Rule-Firing Confirmation Card

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / GEAR_RACK / CODE_CABINET
Status: small reusable card / not a runtime tool
Authority: support card only

## Use before nontrivial Mr.Kleen house-touching action

- State:
- Intended action:
- Fired gate:
- Why it fired:
- Blocked:
- Proof needed:
- Disposition:

## Disposition options

- read-only;
- save;
- park;
- block;
- repair;
- wait;
- ask/clarify.

## Rule

If the card cannot be filled, do not act yet.

Clarify, inspect, or park.

## Boundary

This card is not automation.

It is not a dashboard.

It is not doctrine.

It is a small interruption card to prevent stored rules from failing to fire.
'@

$Todo = @'
# TODO - Rule Storage Mistaken For Rule Firing Confirmation Gate Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: open / immediate live-use needed
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Suit Loadout / Correction Root Cleanup / Mule Return Intake

## Purpose

Prove the narrow root fix for:

Rule storage mistaken for rule firing.

## Root fix being tested

Rule-Firing Confirmation Before Action Gate.

Before any nontrivial Mr.Kleen house-touching action, the assistant must confirm:

- State;
- Intended action;
- Fired gate;
- Why it fired;
- Blocked moves;
- Proof needed;
- Disposition.

## Why this is needed

Recent events showed stored rules not firing:

1. report style gate missed;
2. known-path mule pickup missed;
3. suit-first route nearly missed;
4. assistant almost saved proof only instead of fixing the behavior mechanism.

## Pass condition

On the next nontrivial Mr.Kleen action, the assistant uses the card before action and the card changes, validates, or blocks the move.

## Fail condition

The assistant performs the action and explains the rule afterward.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from one proof.
'@

$SuitTodo = @'
# TODO - Suit Loadout Before Boss/Ghost Route Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: live-use proof recorded / still open for varied proof
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Tool-Suit-Rule Lifecycle / Mule Return Intake

## Purpose

Prove the corrected order:

Suit fit -> current worn loadout -> then Boss/Ghost TODO route.

## First live use recorded

Date: 2026-05-20

Proof saved:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\SUIT_LOADOUT_BEFORE_BOSS_GHOST_LIVE_USE_PROOF_20260520.md

Receipt:
PROOF_HISTORY\RULE_FIRING_ROOT_FIX_CONFIRMATION_GATE_RECEIPT_20260520.txt

Result:
PASS as one live-use proof.

What passed:
- suit/loadout was read before Boss/Ghost TODO;
- Boss/Ghost was treated as downstream, not king;
- mule recommendation was treated as support evidence, not command;
- one child route was selected after read;
- no promotion occurred.

Selected downstream child:
Rule storage mistaken for rule firing.

Root fix selected:
Rule-Firing Confirmation Before Action Gate.

## Still open

Do not close this TODO from one proof.

Future varied proof should show suit-first ordering on a different downstream route.

## Boundary

No suit promotion.

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No mule-output adoption from this TODO alone.
'@

$RceAppend = @'

## Entry 11 - Rule-Firing Confirmation Before Action Gate

Rule:
Before nontrivial Mr.Kleen house-touching action, confirm the active rule/suit/order that fired using a small card: state, intended action, fired gate, why it fired, blocked moves, proof needed, and disposition.

Concept:
Rule storage mistaken for rule firing; activation gate; point-of-work confirmation; narrow root repair.

Event:
After suit-first was correctly selected before Boss/Ghost, the assistant almost saved only the live-use proof. User caught the aha chance: the real fix was to repair the mechanism so stored rules fire before action.

Trigger phrases:
did you do this; aha chance; can fix this; rule storage mistaken for rule firing; confirm before action; rule not firing; not broad repair.

Proof state:
Saved as support rule and TODO. Needs next live proof.

Neighbor rules:
Suit First Before Route; Root Problem Cleanup; Relevant Root Key Selector; No Rule King; Boss/Ghost map.

Boundary:
Not doctrine, not active guide, not automation, not dashboard.
'@

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Current active ball after this save: Rule-Firing Confirmation Before Action Gate live use

## Last completed move

Saved the narrow root fix for:

Rule storage mistaken for rule firing.

This save includes:

- suit-loadout before Boss/Ghost live-use proof;
- selected child route file;
- Rule-Firing Confirmation Before Action Gate;
- Rule-Firing Confirmation Card;
- immediate live-use TODO;
- Rule-Concept-Event map entry.

## Current control state

Suit-first has one live-use proof.

The root child is selected:

Rule storage mistaken for rule firing.

The narrow fix is selected:

Rule-Firing Confirmation Before Action Gate.

## Next allowed move

Use the Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action.

The card must name:

- State;
- Intended action;
- Fired gate;
- Why it fired;
- Blocked moves;
- Proof needed;
- Disposition.

Then proceed only if allowed.

## Blocked moves

- Do not save proof-only when a root mechanism is needed.
- Do not act first and explain the rule afterward.
- Do not create a broad support-rule stack.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not promote the gate from this one save.
- Do not adopt mule output as command authority.
'@

Write-Utf8Text -Path $LiveProofPath -Text $LiveProof
Write-Utf8Text -Path $SelectedRoutePath -Text $SelectedRoute
Write-Utf8Text -Path $GateRulePath -Text $GateRule
Write-Utf8Text -Path $GateCardPath -Text $GateCard
Write-Utf8Text -Path $TodoPath -Text $Todo
Write-Utf8Text -Path $SuitTodoPath -Text $SuitTodo
Write-Utf8Text -Path $AnchorPath -Text $Anchor
Append-IfMissing -Path $RcePath -Needle "Entry 11 - Rule-Firing Confirmation Before Action Gate" -Text $RceAppend

$StatusAppend = @"

---

## 2026-05-20 - Rule-firing root fix confirmation gate

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- suit-loadout before Boss/Ghost live-use proof;
- selected child route: Rule storage mistaken for rule firing;
- Rule-Firing Confirmation Before Action Gate;
- Rule-Firing Confirmation Card;
- immediate live-use TODO;
- appended Rule-Concept-Event entry;
- updated Suit Loadout TODO;
- updated ACTIVE_ANCHOR.

Why:
Saving proof of suit-first was not enough. The live root was rule storage mistaken for rule firing. User caught the aha moment: the root fix is a small before-action confirmation gate so stored rules must fire before action.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, no suit/tool/stale-checker/relation-map promotion, and no mule output adoption.

Next:
Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $LiveProofPath -Needle "The root fix is the Rule-Firing Confirmation Gate saved with this package"
Assert-Needle -Path $SelectedRoutePath -Needle "NARROW ROOT FIX SELECTED"
Assert-Needle -Path $GateRulePath -Needle "Rule-Firing Confirmation Before Action Gate"
Assert-Needle -Path $GateCardPath -Needle "If the card cannot be filled, do not act yet"
Assert-Needle -Path $TodoPath -Needle "assistant almost saved proof only instead of fixing the behavior mechanism"
Assert-Needle -Path $SuitTodoPath -Needle "Root fix selected"
Assert-Needle -Path $RcePath -Needle "Entry 11 - Rule-Firing Confirmation Before Action Gate"
Assert-Needle -Path $AnchorPath -Needle "Rule-Firing Confirmation Before Action Gate live use"

$HashTargets = @(
    $LiveProofPath,
    $SelectedRoutePath,
    $GateRulePath,
    $GateCardPath,
    $TodoPath,
    $SuitTodoPath,
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
RULE FIRING ROOT FIX CONFIRMATION GATE RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Saved:
- $LiveProofPath
- $SelectedRoutePath
- $GateRulePath
- $GateCardPath
- $TodoPath
- $SuitTodoPath
- $RcePath
- $AnchorPath
- $StatusPath

Core correction:
The assistant was about to save only the suit-first proof. User identified the aha point: the selected child "Rule storage mistaken for rule firing" needed an actual narrow fix, not just proof of the event.

Root fix:
Rule-Firing Confirmation Before Action Gate.

Mechanism:
Before nontrivial Mr.Kleen house-touching action, confirm:
- State;
- Intended action;
- Fired gate;
- Why it fired;
- Blocked moves;
- Proof needed;
- Disposition.

Disposition:
- APPLY: suit-first live-use proof recorded.
- APPLY: selected child route recorded.
- APPLY: narrow confirmation gate created.
- NEEDS PROOF: gate must fire on next nontrivial Mr.Kleen action.
- REJECT: proof-only save when root mechanism is needed.
- PARK: dashboard, automation, runtime, knowledge graph, full lesson index.

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
Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action.
"@

Write-Utf8Text -Path $ReceiptPath -Text $Receipt
Assert-Needle -Path $ReceiptPath -Needle "narrow fix, not just proof of the event"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) { throw "No changes detected after writing root fix package." }

Invoke-GitChecked add -- $LiveProofPath $SelectedRoutePath $GateRulePath $GateCardPath $TodoPath $SuitTodoPath $RcePath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) { throw "No staged files before commit." }

Invoke-GitChecked commit -m "Add rule firing confirmation gate" | Out-Null
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
Write-Host "RULE FIRING ROOT FIX CONFIRMATION GATE SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $LiveProofPath)
Write-Host ("- " + $SelectedRoutePath)
Write-Host ("- " + $GateRulePath)
Write-Host ("- " + $GateCardPath)
Write-Host ("- " + $TodoPath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Updated:"
Write-Host ("- " + $SuitTodoPath)
Write-Host ("- " + $RcePath)
Write-Host ("- " + $AnchorPath)
Write-Host ("- " + $StatusPath)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS: suit-first proof saved."
Write-Host "- PASS: selected child route saved."
Write-Host "- PASS: narrow root fix saved."
Write-Host "- PASS: rule-firing confirmation card created."
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
Write-Host "- Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
