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

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== RCE REPORT GATE PARTIAL PROOF SAVE START ===== XxXxX"

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

$ExpectedBase = "867eb4afb617396d7d95f4a02cf15087f9a058f0"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess.")
}

$RceTodoPath = "HOUSE_WORK\TODO\RULE_CONCEPT_EVENT_LINK_MAP_AND_REPORT_GATE_LIVE_USE_TODO_20260520.md"
$RceMapPath = "HOUSE_WORK\WORK_SHED\RELATION_MAPS\RULE_CONCEPT_EVENT_LINK_MAP_SEED_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$CardPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\RULE_FIRING_CONFIRMATION_CARD_20260520.md"
$GatePath = "BRAIN_LEARNING\RULE_FIRING_CONFIRMATION_BEFORE_ACTION_GATE_20260520.md"

foreach ($Path in @($RceTodoPath,$RceMapPath,$AnchorPath,$StatusPath,$CardPath,$GatePath)) {
    if (-not (Test-Path -LiteralPath $Path)) { throw ("Required file missing: " + $Path) }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Required file empty: " + $Path) }
}

Assert-Needle -Path $RceTodoPath -Needle "Prove that the discussion save becomes action"
Assert-Needle -Path $RceTodoPath -Needle "Rule-Concept-Event map"
Assert-Needle -Path $RceMapPath -Needle "Entry 14 - Rule-Firing Confirmation Card First Live Use"
Assert-Needle -Path $RceMapPath -Needle "Entry 15 - Habit / MAA First Live Use On Rule-Firing Pattern"
Assert-Needle -Path $AnchorPath -Needle "Rule-Firing Confirmation Card has one live-use proof"
Assert-Needle -Path $GatePath -Needle "Before any nontrivial Mr.Kleen house-touching action"

$ProofPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RULE_CONCEPT_EVENT_REPORT_GATE_PARTIAL_LIVE_USE_PROOF_20260520.md"
$ReceiptPath = "PROOF_HISTORY\RULE_CONCEPT_EVENT_REPORT_GATE_PARTIAL_LIVE_USE_RECEIPT_20260520.txt"

$Proof = @'
# Rule-Concept-Event / Report Gate - Partial Live Use Proof

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: partial live-use proof / TODO remains open
Base HEAD before save: 867eb4afb617396d7d95f4a02cf15087f9a058f0
Authority: proof/disposition only; not doctrine

## What happened

The current route selection chose:

HOUSE_WORK\TODO\RULE_CONCEPT_EVENT_LINK_MAP_AND_REPORT_GATE_LIVE_USE_TODO_20260520.md

Reason:
It directly tests the active seam: whether discussion saves become action instead of becoming another stored-but-unfired rule.

The route was read under the Rule-Firing Confirmation Card and Habit / MAA support lens.

## RCE TODO required live uses and disposition

### 1. Full report gate

Disposition: OPEN / NOT TRIGGERED.

Reason:
The user did not ask for a house walk, feel report, full report, or rewritten final report in this event.

Do not claim this as passed.

### 2. Rule-not-fired alarm

Disposition: PASS AS LIVE USE.

Evidence:
A missed rule-firing pattern was caught and handled before normal work continued.

Recent event chain:
- the assistant nearly saved only suit-first proof;
- the user caught the aha point that the actual root fix was needed;
- the missed-rule problem was named as "Rule storage mistaken for rule firing";
- the event exposed the concept family: rule activation / point-of-work confirmation / stored rule not firing;
- a narrow root fix was created: Rule-Firing Confirmation Before Action Gate;
- a proof card and live-use TODO were saved;
- later, first live-use proof was saved.

This satisfies the rule-not-fired alarm shape:
name missed rule, name event, name concept family, capture how it was found, and decide lane/disposition.

### 3. Rule-Concept-Event map

Disposition: PASS AS LIVE USE.

Evidence:
The RCE map now includes entries for the recent real rule/relation saves, including:

- Entry 11 - Rule-Firing Confirmation Before Action Gate;
- Entry 12 - Habits As Pattern Transfer Evidence;
- Entry 13 - Mimic Adopt Adapt Transfer Lens;
- Entry 14 - Rule-Firing Confirmation Card First Live Use;
- Entry 15 - Habit / MAA First Live Use On Rule-Firing Pattern.

These entries include rule, concept, event, trigger phrases, proof state, and boundary.

This satisfies the map live-use requirement without creating a dashboard, knowledge graph, or doctrine surface.

### 4. Mule return intake

Disposition: PARTIAL / WATCH.

Evidence:
The mule return was imported with custody boundaries and later used as support evidence, not command authority.

Do not close the mule-return portion from this event.

Reason:
The next true mule-return event must still freeze/read manifest first, inspect returned files, disposition every item, and prevent a single mule recommendation from being applied before stale/custody check.

## Overall verdict

PASS / PARTIAL.

Passed:
- Rule-not-fired alarm live use.
- Rule-Concept-Event map live use.

Open:
- Full report gate.
- Future mule-return intake proof.
- More varied proof before promotion.

## Habit / MAA read

Repeated pattern:
Discussion saves and support rules can become stored-but-unfired material unless converted into point-of-work action.

Stable shape:
discussion insight -> rule/concept/event placement -> trigger phrase -> proof state -> boundary -> live-use proof.

Mimic:
Keep using RCE entries on real rule/relation saves.

Adopt:
Do not adopt as stronger authority yet.

Adapt:
Use the same traceability shape in other lanes only when proof shows it helps.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No promotion.

## Next

Return to route selection under the Rule-Firing Confirmation Card.

Use Habit / MAA only when repeated pattern or transfer decision appears.
'@

$RceTodo = @'
# TODO - Rule-Concept-Event Link Map And Report Gate Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: partial live-use proof recorded / still open
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Memory Health / Placement-Keying / Good Fog Compression

## Purpose

Prove that the discussion save becomes action, not another stored-but-unfired rule.

## Partial live use recorded

Date: 2026-05-20

Proof:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\RULE_CONCEPT_EVENT_REPORT_GATE_PARTIAL_LIVE_USE_PROOF_20260520.md

Receipt:
PROOF_HISTORY\RULE_CONCEPT_EVENT_REPORT_GATE_PARTIAL_LIVE_USE_RECEIPT_20260520.txt

Verdict:
PASS / PARTIAL.

Passed:
- Rule-not-fired alarm live use.
- Rule-Concept-Event map live use.

Still open:
- Full report gate.
- Future mule-return intake proof.
- More varied proof before any promotion.

## Required live uses

### 1. Full report gate

Next time user asks for house walk / feel report / full report / step back / do the report right:

- run raw feel pass;
- pause/check control state, drift, custody, proof, and blocked moves;
- rewrite final report;
- do not push commands unless the report proves a command is needed.

Status:
OPEN / NOT TRIGGERED BY THIS EVENT.

### 2. Rule-not-fired alarm

Next time a missed rule is caught:

- name the missed rule;
- name the event that exposed it;
- name the concept family;
- capture how it was found;
- decide lane/disposition.

Status:
PASS AS FIRST LIVE USE.

### 3. Rule-Concept-Event map

On the next real rule save or relation save:

- add at least one Rule -> Concept -> Event entry;
- include trigger phrases;
- include proof state;
- include authority boundary.

Status:
PASS AS FIRST LIVE USE.

### 4. Mule return intake

When mule return is provided:

- freeze/read manifest first;
- inspect all returned files;
- disposition every item;
- keep mule output in incoming/source/support lanes until proof.

Status:
PARTIAL / WATCH. Do not close from current event.

## Not allowed

- Do not promote this TODO to active guide.
- Do not build dashboard or knowledge graph from this TODO alone.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not use this TODO as command authority.
- Do not close this TODO from partial proof.
'@

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Current active ball after this save: Route selection under Rule-Firing Confirmation Card

## Last completed move

Saved partial live-use proof for:

Rule-Concept-Event Link Map And Report Gate Live Use.

Verdict:
PASS / PARTIAL.

Passed:
- Rule-not-fired alarm live use.
- Rule-Concept-Event map live use.

Still open:
- Full report gate.
- Future mule-return intake proof.
- more varied proof before promotion.

## Current control state

Rule-Firing Confirmation Card has live-use proof and remains active before nontrivial Mr.Kleen house-touching action.

Habit / MAA lens has live-use proof and remains support-only.

RCE / Report Gate TODO has partial proof and remains open.

No item is promoted.

## Next allowed move

Return to route selection under the Rule-Firing Confirmation Card.

Select one route by current anchor/status and active proof need, not newest-file pressure.

Use Habit / MAA only when repeated pattern or transfer decision appears.

## Blocked moves

- Do not promote RCE map/report gate from partial proof.
- Do not promote the card from limited proof.
- Do not promote Habit/MAA from limited proof.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
'@

Write-Utf8Text -Path $ProofPath -Text $Proof
Write-Utf8Text -Path $RceTodoPath -Text $RceTodo
Write-Utf8Text -Path $AnchorPath -Text $Anchor

$StatusAppend = @"

---

## 2026-05-20 - Rule-Concept-Event / Report Gate partial live use

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- $ProofPath
- updated $RceTodoPath
- updated $AnchorPath
- updated this status file

Verdict:
PASS / PARTIAL.

Passed:
- Rule-not-fired alarm live use.
- Rule-Concept-Event map live use.

Still open:
- Full report gate.
- Future mule-return intake proof.
- More varied proof before promotion.

Meaning:
The RCE/report gate TODO became action instead of another stored-but-unfired rule. It was read, judged, and claim-scoped. The map proof passed because recent RCE entries include rule, concept, event, trigger phrases, proof state, and boundary.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, and no promotion.

Next:
Return to route selection under Rule-Firing Confirmation Card.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $ProofPath -Needle "PASS / PARTIAL"
Assert-Needle -Path $ProofPath -Needle "Rule-not-fired alarm live use"
Assert-Needle -Path $ProofPath -Needle "Rule-Concept-Event map live use"
Assert-Needle -Path $RceTodoPath -Needle "partial live-use proof recorded / still open"
Assert-Needle -Path $AnchorPath -Needle "Route selection under Rule-Firing Confirmation Card"
Assert-Needle -Path $StatusPath -Needle "Rule-Concept-Event / Report Gate partial live use"

$HashTargets = @(
    $ProofPath,
    $RceTodoPath,
    $AnchorPath,
    $StatusPath
)

$HashLines = New-Object System.Collections.Generic.List[string]
foreach ($Path in $HashTargets) {
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    $HashLines.Add("- " + $Path + " | sha256=" + $Hash) | Out-Null
}

$Receipt = @"
RULE-CONCEPT-EVENT REPORT GATE PARTIAL LIVE USE RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Rule-Firing Confirmation Card used before this save:
- State: clean at 867eb4a.
- Intended action: save partial live-use proof for RCE / Report Gate TODO.
- Fired gate: Rule-Firing Confirmation Before Action Gate.
- Why it fired: this is a nontrivial Mr.Kleen house-touching action.
- Blocked: doctrine, active guide, CURRENT_TRUTH_INDEX, dashboard, automation, runtime, knowledge graph, full lesson index, promotion.
- Proof needed: files written, receipt, commit, push, final clean state.
- Disposition: save claim-scoped partial proof.

Saved:
- $ProofPath
- $RceTodoPath
- $AnchorPath
- $StatusPath

Verdict:
PASS / PARTIAL.

Passed:
- Rule-not-fired alarm live use.
- Rule-Concept-Event map live use.

Still open:
- Full report gate.
- Future mule-return intake proof.
- More varied proof before promotion.

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
Return to route selection under Rule-Firing Confirmation Card.
"@

Write-Utf8Text -Path $ReceiptPath -Text $Receipt
Assert-Needle -Path $ReceiptPath -Needle "PASS / PARTIAL"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) { throw "No changes detected after writing RCE partial proof package." }

Invoke-GitChecked add -- $ProofPath $RceTodoPath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) { throw "No staged files before commit." }

Invoke-GitChecked commit -m "Record RCE report gate partial live use" | Out-Null
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
Write-Host "RCE REPORT GATE PARTIAL LIVE USE SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $ProofPath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Updated:"
Write-Host ("- " + $RceTodoPath)
Write-Host ("- " + $AnchorPath)
Write-Host ("- " + $StatusPath)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS / PARTIAL."
Write-Host "- PASS: Rule-not-fired alarm live use."
Write-Host "- PASS: Rule-Concept-Event map live use."
Write-Host "- OPEN: Full report gate."
Write-Host "- OPEN/PARTIAL: Future mule-return intake proof."
Write-Host ""
Write-Host "Boundary:"
Write-Host "- No doctrine rewrite."
Write-Host "- No active guide rewrite."
Write-Host "- No CURRENT_TRUTH_INDEX rewrite."
Write-Host "- No dashboard, automation, runtime, knowledge graph, or full lesson index."
Write-Host "- No promotion."
Write-Host ""
Write-Host "Next move:"
Write-Host "- Return to route selection under Rule-Firing Confirmation Card."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
