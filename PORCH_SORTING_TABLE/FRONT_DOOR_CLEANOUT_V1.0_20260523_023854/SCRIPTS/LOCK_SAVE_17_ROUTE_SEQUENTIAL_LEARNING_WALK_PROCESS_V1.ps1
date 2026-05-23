$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"
if (-not (Test-Path -LiteralPath $Repo)) {
    throw "Mr.Kleen repo not found at $Repo"
}

Set-Location -LiteralPath $Repo

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not in a Git repo. Expected Mr.Kleen at $Repo"
}

$Branch = (git branch --show-current).Trim()
if ($Branch -ne "main") {
    throw "Expected branch main, found '$Branch'"
}

$PreStatus = git --no-pager status --short
if ($PreStatus) {
    Write-Host "PRE-STATUS WAS NOT CLEAN:"
    $PreStatus | ForEach-Object { Write-Host $_ }
    throw "Stop: repo must be clean before this process save to avoid mixing unrelated work."
}

$OldHead = (git rev-parse HEAD).Trim()
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

$RulePath = "BRAIN_LEARNING\UNUSUAL_ENTRY_17_ROUTE_SEQUENTIAL_LEARNING_WALK_PROCESS_RULE_20260523.md"
$PlanPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\UNUSUAL_ENTRY_17_ROUTE_SEQUENTIAL_LEARNING_WALK_PLAN_20260523.md"
$StackPath = "HOUSE_WORK\WORK_SHED\PARKING\PARKED_SUIT_IDEAS_AND_APPLIED_STACK_17_ROUTE_WALK_20260523.md"
$TemplatePath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\TEMPLATES\UNUSUAL_ENTRY_17_ROUTE_STEP_CARD_TEMPLATE_20260523.md"
$ReceiptPath = "PROOF_HISTORY\UNUSUAL_ENTRY_17_ROUTE_SEQUENTIAL_LEARNING_PROCESS_RECEIPT_$Now.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$Paths = @($RulePath, $PlanPath, $StackPath, $TemplatePath, $ReceiptPath, $StatusPath)
foreach ($p in $Paths) {
    $parent = Split-Path -Parent $p
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

$RuleContent = @'
# 17-Route Sequential Learning Walk Process Rule — 2026-05-23

Status: SUPPORT PROCESS RULE / ALL-WAYS WALK PLANNING / NOT DOCTRINE
Scope: define how to run the 17 route families one at a time while carrying lessons forward.
Boundary: this does not rewrite ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, doctrine, runtime, automation, dashboard, or public authority.

## 1. Core Correction

If the route universe has 17 declared route families, do not pretend one or two walks proof the method.

Run the route families as a sequence.

Each route is a step.

Each step must:
1. enter one route family;
2. perform the fresh walk for that route without Git/history bias;
3. record what was seen;
4. extract lessons;
5. park or apply useful ideas;
6. update the working suit/idea stack;
7. carry the updated applied idea into the next route;
8. return to the user and stop before the next route, unless explicitly told to continue.

Short form:

`Route -> learn -> park/apply -> carry forward -> next route`

## 2. The 17 Route Families

1. Root / Front Door Anchors
2. Brain Learning Rules
3. Sorting Bench Work Surfaces
4. Parking / Future Reserve
5. Proof Receipts
6. Status / Index Compass
7. Gate-Named Surfaces
8. Creative / Wildcard / Emergence Surfaces
9. Rope / Map / Link / Bridge Surfaces
10. Source / Original / Ore Surfaces
11. Mule / Handoff Surfaces
12. Recent Pressure Surfaces
13. Quiet Old Surfaces
14. Large Dense Surfaces
15. Tiny Pointer / Stub Surfaces
16. Scripts / Tools
17. Odd Word / Anomaly Surfaces

## 3. Step Memory Rule

The assistant must remember the previous step before entering the next one.

Every route step records:
- route number;
- route family;
- entry lens;
- fresh observations;
- anomaly candidates;
- what was learned;
- what got parked;
- what got applied immediately;
- what was rejected;
- what must be carried into the next route;
- what route comes next.

## 4. Parked Suit Ideas / Applied Idea Stack

When a useful idea appears during a route, do not leave it floating.

Decide one of these:
- APPLY NOW: it improves the next route immediately and is safe.
- PARK AS SUIT IDEA: it is useful but not ready.
- HOLD AS FUTURE PLAN: it is strong but too early.
- REJECT: it does not fit.
- NEEDS PROOF: it may fit but lacks evidence.

Parked Suit Ideas are not junk parking.

They are live candidate suit pieces with:
- name;
- source route;
- job;
- boundary;
- return trigger;
- proof needed;
- next-use condition.

## 5. Applied-Idea-Against-Next Rule

The next route should not start blank.

It should start with the current Applied Idea Stack.

Before each next route, ask:
- what did the last route teach?
- what idea is now safe to apply?
- what warning should guide the next route?
- what should not be repeated?
- what is the next route trying to confirm, challenge, or expand?

## 6. Micro-Consolidation Rule

Consolidation may happen inside the route sequence only as small, bounded micro-consolidation.

Allowed:
- merge duplicate route lessons;
- group repeated anomaly families;
- combine two matching suit ideas;
- rename a clearer shared pattern;
- mark a repeated lesson as stronger.

Blocked:
- activating the full CONSOLIDATOR gate;
- flattening distinct gates prematurely;
- calling one repeated term proof;
- deleting source observations;
- rewriting active doctrine;
- skipping the rest of the 17 routes because early patterns look strong.

Short form:
Micro-consolidate route lessons. Keep CONSOLIDATOR up the sleeve.

## 7. Stop Rule

After each route step, stop and report:
- route completed;
- lesson learned;
- applied idea stack update;
- parked suit idea update;
- next planned route.

Do not automatically continue unless the user explicitly says continue.

## 8. Proof Language

The 17-route sequence is not proofed until coverage is ledgered.

Allowed verdicts:
- FULL COVERAGE
- BOUNDED BROAD COVERAGE
- PARTIAL COVERAGE
- NEEDS MORE WALKS

No route result alone may claim full proof.
'@
$PlanContent = @'
# 17-Route Sequential Learning Walk Plan — 2026-05-23

Status: ROUTE PLAN / STEPWISE WALK / NOT EXECUTED YET
Purpose: define the ordered walk through the 17 route families with learning carried forward after each step.
Boundary: this plan does not run the walk, does not rewrite doctrine, and does not activate CONSOLIDATOR.

## Operating Loop

For each route:

1. Start with Applied Idea Stack from the previous route.
2. Enter the route family fresh.
3. Do not use Git/history during the fresh route walk.
4. Record route observations and anomaly candidates.
5. Extract lessons.
6. Decide APPLY NOW / PARK AS SUIT IDEA / HOLD AS FUTURE PLAN / REJECT / NEEDS PROOF.
7. Update Parked Suit Ideas and Applied Idea Stack.
8. Micro-consolidate repeated route lessons if safe.
9. Name next route.
10. Stop and report.

## Route Order

| Step | Route Family | Entry Lens | Carry-Forward Question |
|---:|---|---|---|
| 1 | Root / Front Door Anchors | front-door truth, anchors, root oddities | What does the house expose before we enter deeper? |
| 2 | Brain Learning Rules | tool rack, assistant learning, operating rules | Which rule lessons should guide all later routes? |
| 3 | Sorting Bench Work Surfaces | rough work, maps, route candidates | What unfinished shapes are trying to become tools? |
| 4 | Parking / Future Reserve | up-sleeve ideas, return triggers | Which held ideas are alive but not ready? |
| 5 | Proof Receipts | proof residue, PASS/partial/failure scars | What does the house actually prove it did? |
| 6 | Status / Index Compass | current orientation, route pressure | Is the house status aligned with what the work says? |
| 7 | Gate-Named Surfaces | gate density, neighbor order | Which gates are friends, crowded, duplicated, or missing? |
| 8 | Creative / Wildcard / Emergence Surfaces | unique ideas, unpredicted outcomes, discovery logic | What new candidate ideas appear when the pattern bends? |
| 9 | Rope / Map / Link / Bridge Surfaces | path custody, navigation, bridge points | Which surfaces point to more doors? |
| 10 | Source / Original / Ore Surfaces | founding source, raw notes, clean translation | What source truth must be preserved before cleaning? |
| 11 | Mule / Handoff Surfaces | guest work, return paths, scoped delegation | What can outside/guest work teach without becoming authority? |
| 12 | Recent Pressure Surfaces | latest movement, live strain | What changed recently that affects the route stack? |
| 13 | Quiet Old Surfaces | neglected old material | What did we keep walking past? |
| 14 | Large Dense Surfaces | dense growth, possible bloat, hidden links | What needs compression or targeted reading later? |
| 15 | Tiny Pointer / Stub Surfaces | small keys, stubs, receipts, pointers | What small object unlocks a larger route? |
| 16 | Scripts / Tools | action surfaces, local command behavior | Which tools help or distort the process? |
| 17 | Odd Word / Anomaly Surfaces | weird terms, failure language, signal clusters | What anomaly family repeats across the whole sequence? |

## Final Stop After Route 17

After step 17:
- do not immediately activate CONSOLIDATOR;
- compare the route lessons;
- create a coverage/lesson ledger;
- only then judge whether consolidation is needed.

## CONSOLIDATOR Boundary

CONSOLIDATOR remains up the sleeve.

It may return only after:
- multiple routes show repeated duplication/overlap;
- route lessons are ledgered;
- distinct gate jobs are protected;
- a separate consolidation review is requested or warranted.
'@
$StackContent = @'
# Parked Suit Ideas and Applied Idea Stack — 17-Route Walk Seed — 2026-05-23

Status: SEED LEDGER / UPDATED DURING ROUTE SEQUENCE
Purpose: hold lessons, suit ideas, and applied ideas discovered during the 17-route walk.
Boundary: this is not doctrine and not proof by itself.

## Current Applied Idea Stack

### A001 — Fresh First, Hindsight Second

Source:
User corrected the Unusual Entry Home Walk order.

Job:
Prevent Git/history from biasing the fresh walk.

Use:
Apply to every route.

Boundary:
Git/history starts only after the fresh route/anomaly stack exists.

### A002 — Path-Forking

Source:
User said each new way should lead to other new walked directions.

Job:
Each route watches for new doors, links, surfaces, and next directions.

Use:
Apply to every route, bounded by route cap and path custody.

Boundary:
Do not wander infinitely. Queue next-door candidates with source route and reason.

### A003 — All-Ways Requires Coverage Ledger

Source:
User corrected that one or two walks do not proof the method.

Job:
Require route-universe inventory and coverage language.

Use:
Apply before any proof claim.

Boundary:
Use FULL COVERAGE / BOUNDED BROAD COVERAGE / PARTIAL COVERAGE / NEEDS MORE WALKS.

### A004 — Route Lessons Stack

Source:
User said each step should add what was learned from the last and apply it against the next.

Job:
The next route starts with prior lessons, not blank.

Use:
Before each route, read the current Applied Idea Stack.

Boundary:
Applied ideas must not override source custody, proof, lane, or Final Judge.

## Parked Suit Ideas

### P001 — 17-Route Comparison Ledger

Status:
PARK AS SUIT IDEA

Job:
After route 17, compare route lessons and anomaly families.

Return trigger:
After all 17 routes are run or a broad enough route batch is complete.

Proof needed:
Route outputs and lesson stack.

### P002 — CONSOLIDATOR Review

Status:
HOLD AS FUTURE PLAN

Job:
Potentially compress/merge repeated gate or route lessons.

Return trigger:
Only after repeated overlap appears across multiple route families and a separate review is warranted.

Boundary:
Do not activate during route walking.

## Update Rule

After each route, append:

- Route completed:
- New lesson:
- Applied now:
- Parked suit idea:
- Future plan:
- Rejected:
- Needs proof:
- Carry into next route:
'@
$TemplateContent = @'
# 17-Route Sequential Walk Step Card Template

Status: TEMPLATE / USE ONE PER ROUTE STEP

## Route Step

Route number:
Route family:
Entry lens:
Previous applied idea stack used:
Next planned route:

## Fresh Walk

Surfaces inspected:
Anomaly candidates:
Odd feeling / signal notes:
Path forks discovered:

## Lesson Extraction

What was learned:
What repeats from earlier routes:
What is new:
What was noise:

## Disposition

APPLY NOW:
PARK AS SUIT IDEA:
HOLD AS FUTURE PLAN:
REJECT:
NEEDS PROOF:

## Micro-Consolidation

Duplicates merged:
Patterns grouped:
Distinct signals preserved:
CONSOLIDATOR boundary checked:

## Stop Report

Completed route:
Carry-forward idea:
Next route:
Stop condition:
'@

Set-Content -LiteralPath $RulePath -Value $RuleContent -Encoding UTF8
Set-Content -LiteralPath $PlanPath -Value $PlanContent -Encoding UTF8
Set-Content -LiteralPath $StackPath -Value $StackContent -Encoding UTF8
Set-Content -LiteralPath $TemplatePath -Value $TemplateContent -Encoding UTF8

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$PlanHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $PlanPath).Hash
$StackHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $StackPath).Hash
$TemplateHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $TemplatePath).Hash

$StatusAppend = @"

## 2026-05-23 — 17-Route Sequential Learning Walk Process

Status: SAVED BY SCRIPT / SUPPORT PROCESS RULE + PLAN / NO DOCTRINE PROMOTION
Old base before save: $OldHead

Saved:
- $RulePath
- $PlanPath
- $StackPath
- $TemplatePath
- $ReceiptPath

Meaning:
- 17 route families are treated as sequential route steps;
- each route learns from the previous route;
- useful ideas are applied, parked as suit ideas, held as future plans, rejected, or marked needs-proof;
- Applied Idea Stack carries lessons into the next route;
- micro-consolidation is allowed for route lessons only;
- CONSOLIDATOR remains up the sleeve and is not activated;
- each route should come back and stop before the next route unless explicitly continued.

Boundary:
No ACTIVE_GUIDE rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine promotion. No route walk executed by this save. No cleanup/delete/move. No runtime, automation, dashboard, or public authority change.
"@

if (Test-Path -LiteralPath $StatusPath) {
    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
} else {
    Set-Content -LiteralPath $StatusPath -Value ("# Current House Work Status`r`n" + $StatusAppend) -Encoding UTF8
}

$StatusHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $StatusPath).Hash

$ReceiptContent = @"
17-ROUTE SEQUENTIAL LEARNING WALK PROCESS RECEIPT

Timestamp: $Now
Repo: $Repo
Branch: $Branch
Old HEAD: $OldHead

Verdict intended by save:
PASS WITH GUARDRAILS / SUPPORT PROCESS RULE + PLAN SAVED / NO ROUTE WALK EXECUTED

Saved files:
- $RulePath
  SHA256: $RuleHash
- $PlanPath
  SHA256: $PlanHash
- $StackPath
  SHA256: $StackHash
- $TemplatePath
  SHA256: $TemplateHash
- $StatusPath
  SHA256 after append: $StatusHash

Core idea saved:
Each of the 17 route families should be walked as a step. Each step records what was learned, updates Parked Suit Ideas or Applied Idea Stack, applies the safe lesson against the next route, micro-consolidates only repeated route lessons, and stops before continuing.

Boundary:
- This save does not run the 17 route walk.
- Git/history is not used inside fresh route walks.
- Hindsight comes after route output.
- CONSOLIDATOR remains held reserve.
- No ACTIVE_GUIDE rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine promotion.
- No cleanup/delete/move.
- No runtime, automation, dashboard, or public authority change.

Final Git HEAD, remote match, and clean status are verified by script output after commit/push.
"@

Set-Content -LiteralPath $ReceiptPath -Value $ReceiptContent -Encoding UTF8
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

git add -- $RulePath $PlanPath $StackPath $TemplatePath $StatusPath
git add -f -- $ReceiptPath

$Cached = git --no-pager diff --cached --name-only
if (-not $Cached) {
    throw "No staged changes found. Process save did not produce expected dirty paths."
}

$Expected = @(
    $RulePath.Replace("\","/"),
    $PlanPath.Replace("\","/"),
    $StackPath.Replace("\","/"),
    $TemplatePath.Replace("\","/"),
    $ReceiptPath.Replace("\","/"),
    $StatusPath.Replace("\","/")
)

$Missing = @()
foreach ($e in $Expected) {
    if ($Cached -notcontains $e) { $Missing += $e }
}
if ($Missing.Count -gt 0) {
    Write-Host "STAGED FILES:"
    $Cached | ForEach-Object { Write-Host $_ }
    throw ("Missing expected staged files: " + ($Missing -join ", "))
}

git commit -m "Save 17-route sequential learning walk process"

$NewHead = (git rev-parse HEAD).Trim()

git push origin main

git fetch origin main | Out-Null
$RemoteHead = (git rev-parse origin/main).Trim()

$FinalStatus = git --no-pager status --short

if ($NewHead -ne $RemoteHead) {
    throw "Remote mismatch after push. Local HEAD $NewHead != origin/main $RemoteHead"
}

if ($FinalStatus) {
    Write-Host "FINAL STATUS WAS NOT CLEAN:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final status not clean."
}

Write-Host ""
Write-Host "17-ROUTE SEQUENTIAL LEARNING WALK PROCESS SAVE COMPLETE"
Write-Host "Old base: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Rule: $RulePath"
Write-Host "Rule SHA256: $RuleHash"
Write-Host "Plan: $PlanPath"
Write-Host "Plan SHA256: $PlanHash"
Write-Host "Applied/Parked Stack: $StackPath"
Write-Host "Applied/Parked Stack SHA256: $StackHash"
Write-Host "Template: $TemplatePath"
Write-Host "Template SHA256: $TemplateHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / SUPPORT PROCESS RULE + PLAN SAVED / NO ROUTE WALK EXECUTED"
