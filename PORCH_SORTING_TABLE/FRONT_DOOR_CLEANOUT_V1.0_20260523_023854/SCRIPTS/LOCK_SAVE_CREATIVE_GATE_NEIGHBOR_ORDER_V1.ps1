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
    throw "Stop: repo must be clean before this save to avoid mixing unrelated work."
}

$OldHead = (git rev-parse HEAD).Trim()
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

$RulePath = "BRAIN_LEARNING\CREATIVE_GATE_FRIENDSHIP_NEIGHBOR_ORDER_RULE_20260523.md"
$MapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CREATIVE_GATE_FRIENDSHIP_NEIGHBOR_ORDER_MAP_20260523.md"
$ReservePath = "HOUSE_WORK\WORK_SHED\PARKING\FUTURE_PLANS_IDEA_LEADING_CONSOLIDATOR_RESERVE_20260523.md"
$ReceiptPath = "PROOF_HISTORY\CREATIVE_GATE_FRIENDSHIP_NEIGHBOR_ORDER_RECEIPT_$Now.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$Paths = @($RulePath, $MapPath, $ReservePath, $ReceiptPath, $StatusPath)
foreach ($p in $Paths) {
    $parent = Split-Path -Parent $p
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

$RuleContent = @'
# Creative Gate + Gate Friendship Neighbor Order Rule — 2026-05-23

Status: LOCKED SUPPORT RULE / HOUSE GATE COMPANION / NOT DOCTRINE
Scope: add a Creative Gate for other gates to work with; define the best neighbor/friendship order for gate runs; define Giving Room for Growth / Future Plans / Idea-Leading behavior.
Boundary: this does not rewrite ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, doctrine, runtime, automation, or public authority. It does not install the future CONSOLIDATOR idea.

## 1. Core Rule

When a gate run is needed, do not let gates fire as a random pile.

Use a friendship neighbor order.

The gates should help each other in a clean sequence:
- source first;
- fit before mutation;
- creative synthesis before final narrowing;
- growth room before forced rejection;
- compatibility before save;
- proof before PASS;
- Final Judge opens and closes the run.

## 2. Creative Gate

The Creative Gate is a companion gate for all other gates.

Job:
Before finalizing a gate decision, check whether available resources can improve the move without breaking the active lane.

Creative Gate checks:
- available ideas;
- tools;
- concepts;
- links;
- ladders;
- analogies;
- prior captures;
- source ore;
- comparison methods;
- candidate rooms;
- candidate tools;
- candidate method-combinations;
- large-model fit.

Allowed:
- enrich an active gate's options;
- propose candidate rooms/tools/methods;
- create rough/slop shapes for later cleanup;
- expose a better neighbor relationship;
- mark an idea as future-plan reserve.

Blocked:
- overriding the active gate;
- turning rough slop into proof;
- installing a candidate without fit/proof;
- creating a new pile of gates;
- using creativity to bypass source custody, proof, or Final Judge.

Short form:
Creative Gate enriches the gate run. It does not crown itself.

## 3. Future Plans / Idea-Leading / Giving Room for Growth Gate

Some strong ideas should not be injected immediately.

This gate protects planned growth space.

Job:
When a strong idea appears but should not enter the current active structure yet, name it, hold it, and lead it forward without contaminating the present gate stack.

This is not vague parking.

Required fields:
1. idea name;
2. why it is being held;
3. what current structure it must not contaminate;
4. future lane;
5. return trigger;
6. risk if injected now;
7. proof needed before activation.

Allowed:
- keep a trick up the sleeve;
- preserve a future plan;
- lead an idea toward a future fit moment;
- keep the current build clean by not injecting early.

Blocked:
- indefinite loose parking;
- pretending a held idea is active;
- smuggling a reserve idea into the current gate;
- forgetting the return trigger;
- rejecting a strong idea only because it is early.

Short form:
Hold strong future ideas with a lane and return trigger. Do not inject early.

## 4. Gate Friendship Neighbor Order

The recommended order for a nontrivial gate run is:

0. Final Judge opens the run.
   - Ask: what object is being judged, what job should it do, and which gates must fire?

1. Intake Pause / Classification Gate.
   - Identify task type, lane, boundary, active rule, proof need, and what must not change.

2. Source Custody / Founding Original Gate.
   - Preserve raw source and clean translation as linked pair when relevant.

3. Rule-Fit / No Side-Mutation Gate.
   - Define the exact change and block unrelated mutation.

4. Creative Gate.
   - Pull ideas/tools/concepts/links/ladders/resources and propose candidate improvements.

5. Clean-Placed Growth / Clean BLOAT Gate.
   - Decide whether added structure has name, lane, purpose, boundary, neighbor fit, proof status, use condition, and retirement condition.

6. Future Plans / Idea-Leading / Giving Room for Growth Gate.
   - Hold strong early ideas as tactical reserve when injecting now would contaminate the current structure.

7. Multi-Rule Batch Compatibility Apply Gate.
   - Run the active gates/rules against each other for scope, authority, conflict, bounded exceptions, and neighbor fit.

8. Proof / Receipt / False-PASS Recovery Gate.
   - Require the right proof object before PASS language.

9. Final Judge closes the run.
   - Confirm each object and each gate did its own job, stayed in lane, and did not overreach.

## 5. Neighbor Principles

Gates are friends, not kings.

No gate should:
- steal another gate's job;
- skip its neighbor;
- expand beyond its lane;
- kill growth because it is messy;
- bless growth without proof;
- turn future plans into active rules too early.

## 6. CONSOLIDATOR Boundary

CONSOLIDATOR is explicitly up the sleeve.

It is not installed here.
It is not made active here.
It is not used to merge or gobble gates here.

It may return later only when:
- several gate neighbors are stable;
- repeated duplication or overlap is proven;
- the house has enough clean gate material to consolidate without flattening living distinctions;
- a separate request or gate run activates it.

Short form:
CONSOLIDATOR is held reserve, not injected.

## 7. Proof Standard

This rule is locked as support behavior only when committed, pushed, remote-matched, and final status is clean.

No Git PASS exists without those checks.
'@
$MapContent = @'
# Creative Gate Friendship Neighbor Order Map — 2026-05-23

Status: SORTING BENCH MAP / SUPPORT RULE COMPANION / NO PROMOTION
Purpose: map the gate neighborhood after adding Creative Gate and Giving Room for Growth Gate.
Boundary: this is not doctrine, not an ACTIVE_GUIDE rewrite, not CURRENT_TRUTH_INDEX, and not the CONSOLIDATOR install.

## 1. Why This Exists

The house now has many gates.

Problem:
If many gates fire without order, they become noise, drag, conflict, or bloat.

Clean move:
Give the gates a friendship order so each gate helps the next one without stealing its job.

## 2. Current Gate Cluster

Relevant existing neighbors:
- Intake Pause Gate
- Rule-Fit / No Side-Mutation Gate
- Clean-Placed Growth / Clean BLOAT Gate
- Founding Original -> Clean Translation Gate
- Source-Safe Reframe Gate
- Edit / Review Before Clean Gate
- Correction Handling Gate
- Multi-Item Save Completeness Gate
- Proof Language Guard
- Awareness Routing Rule
- Alarm Friction Rule
- No Parking Without Fit Decision Rule
- Save Location / Git Save Gate
- Multi-Rule Batch Compatibility Apply Gate
- Final Judge Gate

New companion gates:
- Creative Gate
- Future Plans / Idea-Leading / Giving Room for Growth Gate

Held reserve:
- CONSOLIDATOR

## 3. Best Friendship Order

Final Judge opens.

1. Intake Pause Gate
2. Source Custody / Founding Original Gate
3. Source-Safe Reframe Gate
4. Rule-Fit / No Side-Mutation Gate
5. Correction Handling Gate, only if a correction/failure triggered the run
6. Creative Gate
7. Edit / Review Before Clean Gate
8. Clean-Placed Growth / Clean BLOAT Gate
9. Future Plans / Idea-Leading / Giving Room for Growth Gate
10. No Parking Without Fit Decision Rule
11. Multi-Item Save Completeness Gate, if save packet contains several objects
12. Multi-Rule Batch Compatibility Apply Gate
13. Save Location / Git Save Gate, if durable save is needed
14. Proof Language / Receipt / False-PASS Recovery Gate
15. Final Judge closes.

## 4. Gate Pair Notes

Intake + Source:
Know what the task is before touching source.

Source + Rule-Fit:
Do not make a rule from dirty or detached source.

Rule-Fit + Creative:
Fit defines the lane; Creative expands resources inside that lane.

Creative + Clean-Placed Growth:
Creativity may generate options; Clean-Placed Growth decides whether more has a real place.

Clean-Placed Growth + Future Plans:
If the idea is good but too early, do not reject it and do not inject it. Hold it with lane and return trigger.

Future Plans + No Parking:
Future reserve is allowed only when named and retrievable. No floating gold pile.

Compatibility + Proof:
Before save, run rules against each other. After save, require proof before PASS.

Final Judge:
Final Judge does not become a king. It checks whether every object and gate did its own job.

## 5. CONSOLIDATOR Up-Sleeve Note

CONSOLIDATOR should not be activated yet.

Reason:
The gate neighborhood is still being mapped and exercised. Early consolidation could flatten live distinctions, erase useful neighbor roles, or create a false master gate.

Return trigger:
Bring CONSOLIDATOR back only after enough gate runs show repeated overlap, stable friendships, and proven consolidation value.

## 6. Verdict

PASS WITH GUARDRAILS as a support map if saved with Git proof.

Guardrail:
Do not add this to active doctrine or promote CONSOLIDATOR.
'@
$ReserveContent = @'
# Future Plans / Idea-Leading Reserve — CONSOLIDATOR Held Up Sleeve — 2026-05-23

Status: HELD RESERVE / FUTURE PLAN / NOT ACTIVE
Scope: record the CONSOLIDATOR idea without injecting it into the current gate stack.
Boundary: this file does not install, activate, promote, or execute a CONSOLIDATOR gate.

## 1. Founding Source

User correction:
- keep tricks up the sleeve;
- this is called making future plans or ideas;
- leading the idea;
- giving room for growth gate;
- do not inject CONSOLIDATOR yet.

## 2. Clean Translation

A strong idea may be intentionally held for later.

This is not vague parking.

It is future-plan reserve:
- name the idea;
- hold it cleanly;
- keep it from contaminating the current structure;
- define how it may return;
- let it grow toward the right future moment.

## 3. Held Idea

Name:
CONSOLIDATOR

Potential future job:
Review many gates/rules after they have enough evidence, then merge, compress, retire, or reorganize duplicate/overlapping structures without killing living distinctions.

Why held now:
The current task is to add Creative Gate and map gate neighbor order. Injecting CONSOLIDATOR now would be premature and could become a fake master gate.

Risk if injected now:
- flattens gate friendships too early;
- merges gates before their jobs are proven;
- creates a new boss gate;
- hides useful distinctions;
- causes bloat under the name of cleanup.

Future lane:
Gate review / consolidation candidate / cleanup after repeated gate-run evidence.

Return trigger:
Reopen when:
1. several gate runs have used the neighbor order;
2. repeated overlap or duplication is visible;
3. Creative Gate and Giving Room for Growth Gate have proof of use;
4. the house needs compression, not expansion;
5. the user explicitly calls for consolidation or a saved gate review recommends it.

Proof needed before activation:
- map of overlapping gates;
- evidence that overlap is repeated, not imagined;
- preservation plan for distinct jobs;
- rejected/parked/merged list;
- Final Judge review.

## 4. Short Form

CONSOLIDATOR stays up the sleeve.

Lead the idea forward.
Do not inject it early.
'@

Set-Content -LiteralPath $RulePath -Value $RuleContent -Encoding UTF8
Set-Content -LiteralPath $MapPath -Value $MapContent -Encoding UTF8
Set-Content -LiteralPath $ReservePath -Value $ReserveContent -Encoding UTF8

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$MapHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $MapPath).Hash
$ReserveHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReservePath).Hash

$StatusAppend = @"

## 2026-05-23 — Creative Gate + Gate Friendship Neighbor Order

Status: SAVED BY SCRIPT / SUPPORT RULE / NO DOCTRINE PROMOTION
Old base before save: $OldHead

Saved:
- $RulePath
- $MapPath
- $ReservePath
- $ReceiptPath

Meaning:
- Creative Gate added as a companion gate for other gates to work with;
- gate friendship neighbor order mapped so many gates do not fire as a random pile;
- Future Plans / Idea-Leading / Giving Room for Growth Gate captured as tactical reserve behavior;
- CONSOLIDATOR explicitly held up the sleeve and not injected as an active gate.

Boundary:
No ACTIVE_GUIDE rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine promotion. No CONSOLIDATOR activation. No runtime, automation, dashboard, or public authority change.
"@

if (Test-Path -LiteralPath $StatusPath) {
    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
} else {
    Set-Content -LiteralPath $StatusPath -Value ("# Current House Work Status`r`n" + $StatusAppend) -Encoding UTF8
}

$ReceiptContent = @"
CREATIVE GATE + GATE FRIENDSHIP NEIGHBOR ORDER RECEIPT

Timestamp: $Now
Repo: $Repo
Branch: $Branch
Old HEAD: $OldHead

Verdict intended by save:
PASS WITH GUARDRAILS / SUPPORT RULE SAVED / CONSOLIDATOR HELD RESERVE

Saved files:
- $RulePath
  SHA256: $RuleHash
- $MapPath
  SHA256: $MapHash
- $ReservePath
  SHA256: $ReserveHash
- $StatusPath
  SHA256 after append is calculated after this receipt is written.

Boundary:
- Creative Gate is a companion gate, not a boss gate.
- Future Plans / Idea-Leading / Giving Room for Growth is tactical reserve, not vague parking.
- CONSOLIDATOR is up the sleeve and not active.
- No ACTIVE_GUIDE rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine promotion.
- No runtime, automation, dashboard, or public authority change.

Final Git HEAD, remote match, and clean status are verified by script output after commit/push.
"@

Set-Content -LiteralPath $ReceiptPath -Value $ReceiptContent -Encoding UTF8

$StatusHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $StatusPath).Hash
Add-Content -LiteralPath $ReceiptPath -Value "`r`nStatus SHA256 after append: $StatusHash`r`n" -Encoding UTF8

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

git add -- $RulePath $MapPath $ReservePath $StatusPath
git add -f -- $ReceiptPath

$Cached = git --no-pager diff --cached --name-only
if (-not $Cached) {
    throw "No staged changes found. Save did not produce expected dirty paths."
}

$Expected = @(
    $RulePath.Replace("\","/"),
    $MapPath.Replace("\","/"),
    $ReservePath.Replace("\","/"),
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

git commit -m "Add creative gate neighbor order"

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
Write-Host "CREATIVE GATE FRIENDSHIP NEIGHBOR ORDER SAVE COMPLETE"
Write-Host "Old base: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Rule: $RulePath"
Write-Host "Rule SHA256: $RuleHash"
Write-Host "Map: $MapPath"
Write-Host "Map SHA256: $MapHash"
Write-Host "Reserve: $ReservePath"
Write-Host "Reserve SHA256: $ReserveHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / SUPPORT RULE SAVED / CONSOLIDATOR HELD RESERVE"
