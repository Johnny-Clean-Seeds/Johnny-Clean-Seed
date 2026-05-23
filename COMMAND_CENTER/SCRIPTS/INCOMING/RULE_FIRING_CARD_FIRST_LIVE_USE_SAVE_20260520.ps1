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

Write-Host "XxXxX ===== RULE FIRING CARD FIRST LIVE USE SAVE START ===== XxXxX"

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

$ExpectedBase = "0cdae63ba8075224e51502b25d01846fdedb7314"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess.")
}

$GatePath = "BRAIN_LEARNING\RULE_FIRING_CONFIRMATION_BEFORE_ACTION_GATE_20260520.md"
$CardPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\RULE_FIRING_CONFIRMATION_CARD_20260520.md"
$GateTodoPath = "HOUSE_WORK\TODO\RULE_STORAGE_MISTAKEN_FOR_RULE_FIRING_CONFIRMATION_GATE_LIVE_USE_TODO_20260520.md"
$HabitTodoPath = "HOUSE_WORK\TODO\HABIT_PATTERN_MIMIC_ADOPT_ADAPT_LIVE_USE_TODO_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$RcePath = "HOUSE_WORK\WORK_SHED\RELATION_MAPS\RULE_CONCEPT_EVENT_LINK_MAP_SEED_20260520.md"

foreach ($Path in @($GatePath,$CardPath,$GateTodoPath,$HabitTodoPath,$AnchorPath,$StatusPath,$RcePath)) {
    if (-not (Test-Path -LiteralPath $Path)) { throw ("Required file missing: " + $Path) }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Required file empty: " + $Path) }
}

Assert-Needle -Path $CardPath -Needle "If the card cannot be filled, do not act yet"
Assert-Needle -Path $GatePath -Needle "Before any nontrivial Mr.Kleen house-touching action"
Assert-Needle -Path $GateTodoPath -Needle "On the next nontrivial Mr.Kleen action, the assistant uses the card before action"
Assert-Needle -Path $HabitTodoPath -Needle "a rule fires or fails to fire more than once"

$ProofPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RULE_FIRING_CONFIRMATION_CARD_FIRST_LIVE_USE_PROOF_20260520.md"
$HabitUsePath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\HABIT_MAA_LENS_FIRST_LIVE_USE_RULE_FIRING_PATTERN_20260520.md"
$ReceiptPath = "PROOF_HISTORY\RULE_FIRING_CONFIRMATION_CARD_FIRST_LIVE_USE_RECEIPT_20260520.txt"

$Proof = @'
# Rule-Firing Confirmation Card - First Live Use Proof

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: first live-use proof / no promotion
Base HEAD before save: 0cdae63ba8075224e51502b25d01846fdedb7314
Authority: proof of one live use only

## What happened

After saving the Rule-Firing Confirmation Before Action Gate, the next nontrivial Mr.Kleen house-touching action was a route read.

Before the read, the assistant used the confirmation card:

- State: main @ 0cdae63, clean by last proof.
- Intended action: read current anchor plus active gate/TODO state and choose next route.
- Fired gate: Rule-Firing Confirmation Before Action Gate.
- Why it fired: the saved gate requires confirmation before nontrivial Mr.Kleen house-touching action.
- Blocked: no save, no doctrine, no active guide, no CURRENT_TRUTH_INDEX, no dashboard, no automation, no runtime, no knowledge graph, no promotion.
- Proof needed: HEAD == origin/main, status clean, active anchor read, active TODO/gate context read.
- Disposition: read-only route selection.

The user then ran the read command.

## Files read in live use

- ACTIVE_ANCHOR.txt
- HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\RULE_FIRING_CONFIRMATION_CARD_20260520.md
- HOUSE_WORK\TODO\HABIT_PATTERN_MIMIC_ADOPT_ADAPT_LIVE_USE_TODO_20260520.md
- HOUSE_WORK\TODO\RULE_STORAGE_MISTAKEN_FOR_RULE_FIRING_CONFIRMATION_GATE_LIVE_USE_TODO_20260520.md
- HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md

## Result

PASS as first live-use proof.

The card fired before action.

The card validated the action as read-only.

The card blocked immediate save/repair/promotion.

The action read the active anchor, card, habit/MAA TODO, rule-firing TODO, and current status tail.

## What this proves

It proves one instance of the confirmation card working as an interruption point before action.

It does not prove promotion.

It does not prove the gate is closed.

It does not prove all future rules will fire.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from this proof.
'@

$HabitUse = @'
# Habit / MAA Lens First Live Use - Rule-Firing Pattern

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: first live-use proof / support lens only
Parent Boss: Rule Activation / Work-Order Control
Authority: pattern lens proof only; not doctrine

## Trigger

The Habit / MAA TODO says to use the lens when:

- a behavior repeats across multiple events;
- a rule fires or fails to fire more than once;
- a plan works in one room and appears useful in another;
- the house is about to copy a method, rule, script, packet, or workflow into a different lane.

This trigger is present.

## Repeated habit/pattern visible

Pattern:
Rules are saved correctly, but the assistant sometimes acts before the right rule/gate visibly fires.

Repeated events:
1. full report style gate missed;
2. known-path mule pickup missed;
3. suit-first route nearly missed;
4. assistant nearly saved proof only instead of fixing mechanism;
5. current action correctly used the confirmation card before read.

## Healthy, risky, or mixed

Mixed.

Risk:
stored rules can become inert if not confirmed before action.

Healthy:
the correction loop is now catching misses and turning them into better gates.

## Stable shape

The stable shape is:

event/correction -> identify missed fired gate -> save narrow mechanism -> require card before next action -> live-use proof.

## Local context only

Current local context:
Mr.Kleen house-touching actions, mule return intake, Boss/Ghost routing, support-rule overload.

Do not assume this exact card belongs in every domain outside Mr.Kleen without proof.

## Mimic / Adopt / Adapt decision

Mimic:
Use the same card shape in the next similar Mr.Kleen house-touching action.

Adopt:
Keep the card as support for Mr.Kleen nontrivial actions if it continues to prevent wrong-order work.

Adapt:
For other lanes, adapt the shape rather than copying the exact wording.

## Proof needed in new lane

A future action must show the card changed, validated, or blocked the move before action.

## Authority boundary

Support lens only.

Not doctrine.

Not active guide.

Not automation.

## Stale / false-transfer risk

Risk:
The card could become another ceremony if used for trivial moves.

Guard:
Use only for nontrivial Mr.Kleen house-touching action or when a rule/gate miss is likely.
'@

$GateTodo = @'
# TODO - Rule Storage Mistaken For Rule Firing Confirmation Gate Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: first live-use proof recorded / still open for varied proof
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

## First live use recorded

Date: 2026-05-20

Proof:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\RULE_FIRING_CONFIRMATION_CARD_FIRST_LIVE_USE_PROOF_20260520.md

Result:
PASS as one live-use proof.

What passed:
- card was used before action;
- action was read-only;
- blocked moves were named;
- proof needed was named;
- active anchor, card, habit/MAA TODO, rule-firing TODO, and status tail were read;
- action did not become save/repair/promotion.

## Still open

Do not close this TODO from one proof.

Needs varied proof on another nontrivial house-touching action, preferably one that is not only read-only.

## Fail condition

The assistant performs the action and explains the rule afterward.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from one proof.
'@

$HabitTodo = @'
# TODO - Habit Pattern / Mimic Adopt Adapt Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: first live-use proof recorded / still open for varied proof
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Growth Cycle / Memory Health / Rule-Concept-Event

## Purpose

Prove that habit recognition can help the house identify repeated patterns and route them through mimic, adopt, or adapt.

## First live use recorded

Date: 2026-05-20

Proof:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\HABIT_MAA_LENS_FIRST_LIVE_USE_RULE_FIRING_PATTERN_20260520.md

Result:
PASS as first live use.

Pattern identified:
Rules are saved correctly, but the assistant sometimes acts before the right rule/gate visibly fires.

Mimic/adopt/adapt decision:
- mimic the Rule-Firing Confirmation Card shape on the next similar Mr.Kleen house-touching action;
- adopt only after more varied proof;
- adapt the shape for other lanes instead of copying exact wording.

## Required future live use

On a future real repeated pattern, answer:

1. What repeated habit/pattern is visible?
2. Is it healthy, risky, or mixed?
3. What is the stable shape?
4. What is local context only?
5. Should the next use mimic, adopt, or adapt?
6. What proof is needed in the new lane?
7. What authority boundary must hold?
8. What stale/false-transfer risk exists?

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from this first proof.
'@

$RceAppend = @'

## Entry 14 - Rule-Firing Confirmation Card First Live Use

Rule:
Use the Rule-Firing Confirmation Card before nontrivial Mr.Kleen house-touching action.

Concept:
Point-of-work activation proof; stored rule becomes fired gate; narrow root repair.

Event:
After saving the confirmation gate, the next read action used the card before reading the active anchor, card, Habit/MAA TODO, Rule-Firing TODO, and status tail.

Trigger phrases:
next; before action; confirmation card; nontrivial Mr.Kleen action; rule firing live use.

Proof state:
First live-use proof saved. Needs varied proof before closure or promotion.

Boundary:
Support card only, not doctrine or automation.

## Entry 15 - Habit / MAA First Live Use On Rule-Firing Pattern

Rule:
When repeated rule-firing misses appear, use habit recognition to identify stable shape and decide mimic/adopt/adapt.

Concept:
Habit evidence; pattern transfer; mimic/adopt/adapt support lens; good fog structure.

Event:
The repeated pattern of rules being stored but not firing was identified and routed through MAA: mimic the card shape in similar Mr.Kleen actions, adopt after more proof, adapt for other lanes.

Trigger phrases:
habit; repeated; pattern; mimic/adopt/adapt; same shape; other lanes.

Proof state:
First live-use proof saved. Needs varied pattern proof.

Boundary:
Support lens only, not doctrine.
'@

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Current active ball after this save: Rule-Firing Confirmation Card varied live use / next route selection

## Last completed move

Saved first live-use proof for:

- Rule-Firing Confirmation Card;
- Habit / Mimic-Adopt-Adapt lens applied to the repeated rule-firing pattern.

## Current control state

Rule-Firing Confirmation Card has one live-use proof.

Habit / MAA lens has one live-use proof.

Neither is promoted.

The card remains the active gate before nontrivial Mr.Kleen house-touching actions.

## Next allowed move

Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action.

If the next move involves a repeated pattern or transfer decision, use Habit / MAA lens.

Then select one route by current anchor/status, not by newest file or support pressure.

## Blocked moves

- Do not promote the card from one proof.
- Do not promote Habit/MAA from one proof.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not copy plans across lanes without proof.
'@

Write-Utf8Text -Path $ProofPath -Text $Proof
Write-Utf8Text -Path $HabitUsePath -Text $HabitUse
Write-Utf8Text -Path $GateTodoPath -Text $GateTodo
Write-Utf8Text -Path $HabitTodoPath -Text $HabitTodo
Append-IfMissing -Path $RcePath -Needle "Entry 14 - Rule-Firing Confirmation Card First Live Use" -Text $RceAppend
Write-Utf8Text -Path $AnchorPath -Text $Anchor

$StatusAppend = @"

---

## 2026-05-20 - Rule-Firing Confirmation Card and Habit/MAA first live use

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- $ProofPath
- $HabitUsePath
- updated $GateTodoPath
- updated $HabitTodoPath
- appended entries to $RcePath
- updated $AnchorPath
- updated this status file

Meaning:
The Rule-Firing Confirmation Card fired before the next nontrivial Mr.Kleen action. The action stayed read-only and did not become a save/repair/promotion. Habit/MAA lens also fired because repeated rule-firing misses formed a visible habit pattern.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, and no promotion.

Next:
Use Rule-Firing Confirmation Card before the next nontrivial Mr.Kleen house-touching action. Use Habit/MAA lens only when repeated pattern or transfer decision appears.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $ProofPath -Needle "PASS as first live-use proof"
Assert-Needle -Path $HabitUsePath -Needle "Mimic / Adopt / Adapt decision"
Assert-Needle -Path $GateTodoPath -Needle "first live-use proof recorded"
Assert-Needle -Path $HabitTodoPath -Needle "Mimic/adopt/adapt decision"
Assert-Needle -Path $RcePath -Needle "Entry 14 - Rule-Firing Confirmation Card First Live Use"
Assert-Needle -Path $AnchorPath -Needle "Rule-Firing Confirmation Card has one live-use proof"

$HashTargets = @(
    $ProofPath,
    $HabitUsePath,
    $GateTodoPath,
    $HabitTodoPath,
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
RULE FIRING CONFIRMATION CARD FIRST LIVE USE RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Rule-Firing Confirmation Card used before this save:
- State: clean at 0cdae63.
- Intended action: save first live-use proof for confirmation card and Habit/MAA lens.
- Fired gate: Rule-Firing Confirmation Before Action Gate.
- Why it fired: this is a nontrivial Mr.Kleen house-touching action.
- Blocked: doctrine, active guide, CURRENT_TRUTH_INDEX, dashboard, automation, runtime, knowledge graph, full lesson index, promotion.
- Proof needed: files written, receipt, commit, push, final clean state.
- Disposition: save live-use proof.

Saved:
- $ProofPath
- $HabitUsePath
- $GateTodoPath
- $HabitTodoPath
- $RcePath
- $AnchorPath
- $StatusPath

Proof claims:
- PASS: Rule-Firing Confirmation Card fired before read-only route selection.
- PASS: Habit/MAA lens identified repeated rule-firing miss pattern and classified mimic/adopt/adapt path.
- GUARDRAIL: no promotion from first proof.

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
Assert-Needle -Path $ReceiptPath -Needle "PASS: Rule-Firing Confirmation Card fired before read-only route selection"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) { throw "No changes detected after writing live-use proof package." }

Invoke-GitChecked add -- $ProofPath $HabitUsePath $GateTodoPath $HabitTodoPath $RcePath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) { throw "No staged files before commit." }

Invoke-GitChecked commit -m "Record rule firing card first live use" | Out-Null
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
Write-Host "RULE FIRING CARD FIRST LIVE USE SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $ProofPath)
Write-Host ("- " + $HabitUsePath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Updated:"
Write-Host ("- " + $GateTodoPath)
Write-Host ("- " + $HabitTodoPath)
Write-Host ("- " + $RcePath)
Write-Host ("- " + $AnchorPath)
Write-Host ("- " + $StatusPath)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS: Rule-Firing Confirmation Card fired before read-only route selection."
Write-Host "- PASS: Habit/MAA lens identified repeated rule-firing pattern."
Write-Host "- PASS: no promotion from first proof."
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
