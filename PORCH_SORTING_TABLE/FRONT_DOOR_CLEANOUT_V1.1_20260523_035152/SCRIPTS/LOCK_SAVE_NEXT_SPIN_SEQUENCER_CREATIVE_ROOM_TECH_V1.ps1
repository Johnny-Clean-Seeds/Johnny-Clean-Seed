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
    throw "Stop: repo must be clean before this Next Spin Sequencer save."
}

$OldHead = (git rev-parse HEAD).Trim()
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

$RulePath = "BRAIN_LEARNING\NEXT_SPIN_SEQUENCER_GATE_CREATIVE_ROOM_TECH_RULE_20260523.md"
$TechMapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CREATIVE_ROOM_TECH_SCAFFOLDS_NEXT_SPIN_SEQUENCER_FIT_MAP_20260523.md"
$TemplatePath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\TEMPLATES\NEXT_SPIN_SEQUENCE_CARD_TEMPLATE_20260523.md"
$ReceiptPath = "PROOF_HISTORY\NEXT_SPIN_SEQUENCER_GATE_CREATIVE_ROOM_TECH_SAVE_RECEIPT_$Now.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

foreach ($p in @($RulePath, $TechMapPath, $TemplatePath, $ReceiptPath, $StatusPath)) {
    $parent = Split-Path -Parent $p
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

$RuleContent = @'
# Next Spin Sequencer Gate + Creative Room Technology Scaffolds — 2026-05-23

Status: SUPPORT RULE / CANDIDATE GATE + TOOL SCAFFOLDS / NOT DOCTRINE
Scope: save the clean name, role, placement, boundaries, and technology-scaffold fit for the post-run sequence gate.
Boundary: this does not update mule handoff, activate CONSOLIDATOR, promote doctrine, rewrite ACTIVE_GUIDES, rewrite CURRENT_TRUTH_INDEX, or touch local Cube/final-ideas content.

## 1. Name Decision

Use:

`Next Spin Sequencer Gate`

Do not use:
- Gate Digestion Gate
- Order Judge Gate
- Next Order Gate
- Final Order Gate

Reason:
- "Judge" conflicts with Final Judge / judging role.
- "Order" can sound like Final Order.
- "Sequencer" fits the actual job: arrange the next run based on the completed run.

## 2. Core Job

Next Spin Sequencer Gate reviews the completed gate run plus hindsight and proposes the best sequence for the next spin.

It asks:
- Which gate fired too early?
- Which gate fired too late?
- Which gate was missing?
- Which gate did not need to fire?
- Which gate produced useful byproduct?
- Which gate produced fog?
- Which gate needs a friend/neighbor?
- Which repeated overlap should be marked for later CONSOLIDATOR?
- What is the best proposed sequence for the next spin?

## 3. Best Placement

Best placement:

`Hindsight Lens -> Next Spin Sequencer Gate -> Omega closes`

Reason:
- It needs the fresh run before it can sequence.
- It needs proof/receipt output before it can sequence.
- It needs hindsight before it can detect repetition/history patterns.
- It must happen before Omega closes so the proposed next sequence is captured before final loop closure.

## 4. Clean Order With Sequencer

Current candidate loop:

1. Alpha opens fresh
2. Problem Solving Gate
3. Boundaries Gate
4. Permission Gate
5. Guest Boundary Gate
6. Creative Gate / Wildcard / Emergence
7. Future Plans / Idea-Leading / Giving Room for Growth
8. Return-Home Gate
9. Enforcement Ladder Gate
10. Proof / Receipt Gate
11. Hindsight Lens
12. Next Spin Sequencer Gate
13. Omega closes
14. Final Judge / final clean status

This order is still a candidate. Mule and future spins may challenge it.

## 5. What It Is Not

Next Spin Sequencer Gate is not:
- Final Judge;
- Alpha Omega;
- CONSOLIDATOR;
- proof;
- doctrine;
- Final Order;
- a gate merger;
- a gate killer;
- a promotion gate;
- an owner of all new ideas.

## 6. Output Object

Output should be a small object:

`Next Spin Sequence Card`

Fields:
- run identifier;
- current sequence used;
- gate that fired too early;
- gate that fired too late;
- gate that was missing;
- gate that did not need to fire;
- useful byproducts/new ideas;
- fog/waste/confusion produced;
- neighbor/friend discovered;
- proposed next spin sequence;
- possible future CONSOLIDATOR watch item;
- proof/receipt references.

## 7. Routing Byproducts

If the run produces a creative idea:
send to Creative Gate.

If it produces future/use-later material:
send to Future Plans / Parking.

If it produces repeated overlap:
mark for future CONSOLIDATOR watch.

If it produces fog/waste:
reject or park with warning.

If it changes order:
record in Next Spin Sequence Card.

## 8. CONSOLIDATOR Relationship

CONSOLIDATOR comes later.

Next Spin Sequencer Gate may identify repeated ambiguity or overlap, but it does not merge.

CONSOLIDATOR should only act after repeated sequencer findings show stable ambiguity, duplicate logic, or overlap that should be packed into a cleaner gate.

## 9. Short Rule

Hindsight explains what the run means.

Next Spin Sequencer Gate proposes the next gate sequence.

Omega closes the loop.
'@
$TechMapContent = @'
# Creative Room Technology Fit Map — Next Spin Sequencer Gate — 2026-05-23

Status: CREATIVE ROOM FIT MAP / TOOLS AND SCAFFOLDS / NOT NEW GATES
Scope: place useful technology analogies/tools around the Next Spin Sequencer Gate without dirty bloat.
Boundary: these are scaffolds and tools unless later proved as gates.

## 1. Result

Do not add a pile of new gates.

Add one clean gate:
- Next Spin Sequencer Gate

Attach the following as tools/scaffolds:

- Gate Run Trace Card
- Gate Dependency Map
- Gate Firing Decision Table
- Boundary / Permission Policy Table
- Desired-vs-Actual Reconcile Check
- Gate Neighbor Graph

## 2. Gate Run Trace Card

Technology analogy:
workflow event history / process trace.

House role:
Record what actually happened in the spin.

Captures:
- sequence used;
- gates fired;
- gate outputs;
- proof/receipt references;
- byproducts;
- fog;
- parked items;
- rejected items;
- next-sequence evidence.

Placement:
Tool under Proof / Receipt Gate, Hindsight Lens, and Next Spin Sequencer Gate.

Not a gate unless later proved.

## 3. Gate Dependency Map

Technology analogy:
DAG / dependency graph.

House role:
Map before/after constraints between gates.

Captures:
- Gate A must fire before Gate B;
- Gate C only fires if condition X appears;
- Gate D should not run unless Gate E produced evidence;
- cycles or order conflicts.

Placement:
Scaffold under Next Spin Sequencer Gate.

Not a gate.

## 4. Gate Firing Decision Table

Technology analogy:
decision table / DMN-style decision rules.

House role:
Define when a gate should fire.

Fields:
- condition;
- source signal;
- gate to fire;
- blocked move;
- proof required;
- fallback/parking path.

Placement:
Tool under Permission Gate, Boundaries Gate, and Next Spin Sequencer Gate.

Not a gate.

## 5. Boundary / Permission Policy Table

Technology analogy:
policy-as-code / OPA-style policy split.

House role:
Keep boundary rules separate from enforcement.

Fields:
- actor/object;
- allowed place;
- forbidden place;
- required receipt;
- enforcement step;
- return-home path.

Placement:
Tool under Boundaries Gate, Permission Gate, Guest Boundary Gate, and Enforcement Ladder Gate.

Not a gate.

## 6. Desired-vs-Actual Reconcile Check

Technology analogy:
controller reconciliation loop.

House role:
Compare desired clean state against actual state.

Asks:
- Did the run end where expected?
- Is the porch clean?
- Are files placed?
- Did receipts exist?
- Did the actual ending drift from desired ending?

Placement:
Tool under Alpha Omega, Return-Home Gate, and Proof / Receipt Gate.

Not a gate.

## 7. Gate Neighbor Graph

Technology analogy:
graph database / relationship map.

House role:
Represent gates as nodes and relationships as edges.

Edges may include:
- before;
- after;
- feeds;
- blocks;
- parks;
- proves;
- escalates;
- consolidates-later;
- neighbor-of;
- conflict-with.

Placement:
Scaffold for mule review and future tool building.

Not a gate.

## 8. Clean-Bloat Rule

These tools are clean bloat if they have:
- name;
- lane;
- purpose;
- boundary;
- neighbor;
- proof status;
- cleanup/retirement path.

They become dirty bloat if they are:
- unplaced;
- duplicated without value;
- treated as authority;
- promoted without proof;
- used to replace the gates they support.

## 9. Current Decision

Keep:
- Next Spin Sequencer Gate as candidate gate.

Park/use as tools:
- Gate Run Trace Card
- Gate Dependency Map
- Gate Firing Decision Table
- Boundary / Permission Policy Table
- Desired-vs-Actual Reconcile Check
- Gate Neighbor Graph.

Do not activate CONSOLIDATOR.
Do not update mule handoff in this save.
'@
$TemplateContent = @'
# Next Spin Sequence Card Template

Status: TEMPLATE / SUPPORT OBJECT
Use: one card per completed gate spin when sequencing the next spin.

## Run ID

`<date/time or run label>`

## Current Sequence Used

1.
2.
3.

## Gates That Fired

- Gate:
  - output:
  - proof/receipt:
  - byproduct:
  - fog/waste:
  - parking/rejection:

## Fired Too Early

- Gate:
- Evidence:
- Proposed move:

## Fired Too Late

- Gate:
- Evidence:
- Proposed move:

## Missing Gate

- Candidate gate or existing gate:
- Signal:
- Better home if not new gate:

## Unneeded Gate

- Gate:
- Reason:
- Keep / park / skip next spin:

## New Neighbor / Friend Found

- Gate or tool:
- Relationship:
- Proof needed:

## Possible Future CONSOLIDATOR Watch Item

- Ambiguity/overlap:
- Repeated how many times:
- Do not consolidate yet because:

## Proposed Next Spin Sequence

1.
2.
3.

## Close Check

- Hindsight reviewed: YES / NO
- Proof/receipt checked: YES / NO
- Omega ready to close: YES / NO
'@

Set-Content -LiteralPath $RulePath -Value $RuleContent -Encoding UTF8
Set-Content -LiteralPath $TechMapPath -Value $TechMapContent -Encoding UTF8
Set-Content -LiteralPath $TemplatePath -Value $TemplateContent -Encoding UTF8

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$TechMapHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $TechMapPath).Hash
$TemplateHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $TemplatePath).Hash

$StatusAppend = @"

## 2026-05-23 — Next Spin Sequencer Gate + Creative Room Technology Scaffolds

Status: SAVED BY SCRIPT / SUPPORT RULE + TOOL SCAFFOLDS / NO DOCTRINE PROMOTION
Old base before save: $OldHead

Saved:
- $RulePath
- $TechMapPath
- $TemplatePath
- $ReceiptPath

Meaning:
- selected `Next Spin Sequencer Gate` as the clean name;
- placed it after Hindsight Lens and before Omega closure;
- defined it as a next-spin sequencing gate, not Judge, CONSOLIDATOR, proof, Final Order, or doctrine;
- saved technology-inspired scaffolds as tools, not gates: Gate Run Trace Card, Gate Dependency Map, Gate Firing Decision Table, Boundary/Permission Policy Table, Desired-vs-Actual Reconcile Check, and Gate Neighbor Graph.

Boundary:
No mule handoff update. No CONSOLIDATOR activation. No Alpha Omega promotion. No ACTIVE_GUIDE rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine promotion. No local Cube/final-ideas content in Git. No runtime, automation, dashboard, cleanup, delete, or public authority change.
"@

if (Test-Path -LiteralPath $StatusPath) {
    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
} else {
    Set-Content -LiteralPath $StatusPath -Value ("# Current House Work Status`r`n" + $StatusAppend) -Encoding UTF8
}

$StatusHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $StatusPath).Hash

$ReceiptContent = @"
NEXT SPIN SEQUENCER GATE + CREATIVE ROOM TECHNOLOGY SCAFFOLDS SAVE RECEIPT

Timestamp: $Now
Repo: $Repo
Branch: $Branch
Old HEAD: $OldHead

Verdict intended by save:
PASS WITH GUARDRAILS / SUPPORT RULE + TECHNOLOGY SCAFFOLDS SAVED / NO DOCTRINE PROMOTION

Saved files:
- $RulePath
  SHA256: $RuleHash
- $TechMapPath
  SHA256: $TechMapHash
- $TemplatePath
  SHA256: $TemplateHash
- $StatusPath
  SHA256 after append: $StatusHash

Core idea:
Next Spin Sequencer Gate reviews the completed gate run plus hindsight and proposes the best sequence for the next spin. It is not Final Judge, not Alpha Omega, not CONSOLIDATOR, not proof, not Final Order, and not doctrine.

Technology scaffolds saved as tools, not gates:
- Gate Run Trace Card
- Gate Dependency Map
- Gate Firing Decision Table
- Boundary / Permission Policy Table
- Desired-vs-Actual Reconcile Check
- Gate Neighbor Graph

Boundary:
- No mule handoff update.
- No CONSOLIDATOR activation.
- No Alpha Omega promotion.
- No ACTIVE_GUIDE rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine promotion.
- No local Cube/final-ideas content in Git.
- No runtime, automation, dashboard, cleanup, delete, or public authority change.

Final Git HEAD, remote match, and clean status are verified by script output after commit/push.
"@

Set-Content -LiteralPath $ReceiptPath -Value $ReceiptContent -Encoding UTF8
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

git add -- $RulePath $TechMapPath $TemplatePath $StatusPath
git add -f -- $ReceiptPath

$Cached = git --no-pager diff --cached --name-only
if (-not $Cached) {
    throw "No staged changes found. Next Spin Sequencer save did not produce expected dirty paths."
}

$Expected = @(
    $RulePath.Replace("\","/"),
    $TechMapPath.Replace("\","/"),
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

git -c gc.auto=0 -c maintenance.auto=false commit -m "Save Next Spin Sequencer gate scaffolds"

$NewHead = (git rev-parse HEAD).Trim()

git -c gc.auto=0 -c maintenance.auto=false push origin main

git -c gc.auto=0 -c maintenance.auto=false fetch origin main | Out-Null
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
Write-Host "NEXT SPIN SEQUENCER GATE SCAFFOLDS SAVE COMPLETE"
Write-Host "Old base: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Rule: $RulePath"
Write-Host "Rule SHA256: $RuleHash"
Write-Host "Tech map: $TechMapPath"
Write-Host "Tech map SHA256: $TechMapHash"
Write-Host "Template: $TemplatePath"
Write-Host "Template SHA256: $TemplateHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / SUPPORT RULE + TECHNOLOGY SCAFFOLDS SAVED / NO DOCTRINE PROMOTION"
