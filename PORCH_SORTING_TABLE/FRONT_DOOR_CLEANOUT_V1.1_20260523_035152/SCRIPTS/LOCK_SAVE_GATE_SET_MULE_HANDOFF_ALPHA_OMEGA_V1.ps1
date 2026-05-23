$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"
$CommandCenter = Join-Path $env:USERPROFILE "Desktop\123\COMMAND_CENTER"
$Pickup = Join-Path $CommandCenter "PICKUP"

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
    throw "Stop: repo must be clean before this gate-set save."
}

$OldHead = (git rev-parse HEAD).Trim()
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

$RulePath = "BRAIN_LEARNING\GUEST_BOUNDARY_GATE_SET_THREE_SPIN_REVIEW_RULE_20260523.md"
$AlphaPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\ALPHA_OMEGA_GATE_INSPECTION_20260523.md"
$RepoHandoffPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\MULE_HANDOFF_GUEST_BOUNDARY_GATES_THREE_SPINS_ALPHA_OMEGA_20260523.md"
$ReceiptPath = "PROOF_HISTORY\GUEST_BOUNDARY_GATE_SET_THREE_SPIN_REVIEW_SAVE_RECEIPT_$Now.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$DesktopHandoffPath = Join-Path $Pickup ("MULE_HANDOFF_GUEST_BOUNDARY_GATES_THREE_SPINS_ALPHA_OMEGA_0.md" -f $Now)

$Dirs = @(
    (Split-Path -Parent $RulePath),
    (Split-Path -Parent $AlphaPath),
    (Split-Path -Parent $RepoHandoffPath),
    (Split-Path -Parent $ReceiptPath),
    (Split-Path -Parent $StatusPath),
    $Pickup
)
foreach ($d in $Dirs) {
    if ($d -and -not (Test-Path -LiteralPath $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

$RuleContent = @'
# Guest Boundary Gate Set + Three-Spin Review Loop — 2026-05-23

Status: SUPPORT GATE SET / CANDIDATE REVIEW READY / NOT DOCTRINE
Scope: add the practical guest-boundary gates, define how they work together, and prepare for mule review + three gate spins.
Boundary: this does not rewrite ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, doctrine, runtime, automation, dashboard, or public authority.

## 1. Why This Exists

The front-door mess exposed a real system issue:

Cleanup alone is not problem solving.

The house must:
1. clean the visible mess;
2. identify the behavior that caused it;
3. set boundaries;
4. enforce placement;
5. prevent the same violation;
6. verify the rule held.

The goal is not to become a slave to guest debris. The house has real work to do.

## 2. New Gate Set

### Problem Solving Gate

Job:
After a mess or failure appears, do not only clean the symptom. Find and fix the cause.

Trigger:
- mess cleaned but source behavior remains;
- repeated issue;
- guest/helper output violates house rules;
- assistant keeps repairing the same failure.

Flow:
1. name active problem;
2. clean visible symptom;
3. name root cause;
4. define expected behavior;
5. define boundary;
6. define enforcement;
7. assign cleanup/receipt path;
8. verify the problem cannot repeat the same way.

Blocked:
- cleaning and walking away;
- writing a rule without applying it to the exposed problem;
- calling cleanup a fix when behavior remains unchanged.

### Boundaries Gate

Job:
Say whose place is what.

It defines:
- who is allowed where;
- what each actor/object/tool/file/guest may touch;
- where it enters;
- where it belongs;
- when it must leave;
- what cleanup/receipt it owes;
- what happens when it crosses its place.

Short form:
Placement first. Enforcement second.

### Permission Gate

Job:
Decide whether an actor/object/tool/file/guest is allowed to enter before it enters.

Questions:
- Are you allowed here?
- Under what condition?
- With what limit?
- What path must you use?
- What receipt or return-home proof is required?

Guest rule:
No loose front-door access unless permission is granted and placement is known.

### Return-Home Gate

Job:
No task is done until the object returns to the right place.

Questions:
- Where does this go when the job is done?
- Does the pickup/drop file still need to exist?
- Is the porch clean?
- Is there a receipt or ledger if movement happened?

Short form:
Deliver, place, receipt if needed, clear the porch, stop.

### Enforcement Ladder Gate

Job:
Turn boundary violations into staged action.

Three-strike ladder:
1. warn + route + clean;
2. quarantine/probation with controlled intake and receipt;
3. revoke loose access / block guest route until it obeys.

Boundary:
“Aggressor gets aggressed” means house-system enforcement only:
quarantine, block, reject, or controlled intake. No real-world harm.

### Guest Boundary Gate

Job:
Apply Boundaries + Permission + Return-Home + Enforcement specifically to guests.

Guest includes:
- assistant drops;
- mule returns;
- helper outputs;
- copied files;
- downloaded scripts;
- receipts/reports;
- outside tool output.

Rule:
Guests do not decide their own place. The house does.

## 3. Three-Spin Gate Review Loop

Purpose:
Run the gate set around itself three times before consolidation.

Each spin asks:
1. What gate fires first?
2. What gate is missing?
3. What gate overlaps another gate?
4. What gate should stay separate?
5. What logic should move under a broader gate?
6. What ambiguity appears?
7. What new friend/neighbor gate appears?
8. What should be applied, parked, held, rejected, or marked needs-proof?

### Spin 1 — Practical Fit

Check whether each gate solves a real exposed issue.

Focus:
- front door;
- guest behavior;
- cleanup/receipt;
- return-home discipline.

### Spin 2 — Neighbor Fit

Check whether gates work in clean order.

Likely order:
1. Problem Solving Gate
2. Boundaries Gate
3. Permission Gate
4. Guest Boundary Gate
5. Return-Home Gate
6. Enforcement Ladder Gate
7. Proof / Receipt Gate
8. Final Judge

### Spin 3 — Consolidation Readiness

Check ambiguity and duplication.

Output:
- keep separate;
- merge under broader gate;
- move logic into another gate;
- park as future;
- reject;
- needs proof.

Boundary:
Spin 3 does not activate CONSOLIDATOR automatically. It prepares a clean consolidation question.

## 4. CONSOLIDATOR Gate Candidate

Status:
CANDIDATE / NOT ACTIVE UNTIL AFTER SPINS

Job:
Find ambiguity, overlap, duplicate logic, and scattered rule fragments, then place old gate logic into the better gate or add new logic to the gate that naturally owns it.

Consolidator does:
- compare gates;
- find ambiguous boundaries;
- pack broad ideas into one cleaner gate when fit is proven;
- preserve distinct jobs when merging would flatten useful difference;
- identify new friends/neighbors when consolidation exposes them.

Blocked:
- flattening living gates too early;
- killing distinct gate jobs;
- claiming one master gate solves all;
- consolidating without evidence from spins;
- rewriting doctrine.

## 5. Alpha Omega Gate Candidate

Status:
INSPECTION TARGET / JUDGING GATE CANDIDATE / NOT DOCTRINE

Job:
Judge the whole circle from beginning to end.

Alpha side:
- What is the seed/start?
- What problem opened the loop?
- What gate should fire first?
- What source and boundary define the start?

Omega side:
- What is the clean end?
- Did each gate do its job?
- What survived?
- What was rejected?
- What was parked?
- What proof exists?
- What returns to the user?

Core judgment:
The Alpha Omega Gate checks whether the loop began cleanly, moved cleanly, ended cleanly, and returned cleanly.

It is important because bad judging ruins consolidation. If Alpha Omega judges poorly, CONSOLIDATOR will pack the wrong logic into the wrong gate.

Blocked:
- becoming a king gate;
- replacing Final Judge before proof;
- forcing all gates into one;
- treating a circle-run as proof without receipts;
- ending the loop without return-home cleanup.

## 6. Current Gate Family Before Mule Review

Current candidate gate family:
- Problem Solving Gate
- Boundaries Gate
- Permission Gate
- Guest Boundary Gate
- Return-Home Gate
- Enforcement Ladder Gate
- Creative Gate / Wildcard / Emergence Logic
- Future Plans / Idea-Leading / Giving Room for Growth Gate
- Proof / Receipt Gate
- Final Judge
- CONSOLIDATOR Gate Candidate
- Alpha Omega Gate Candidate

## 7. Save Boundary

This save adds the gate set and review plan.

It does not:
- run the three spins;
- execute mule;
- activate CONSOLIDATOR;
- promote Alpha Omega;
- rewrite doctrine;
- rewrite ACTIVE_GUIDES;
- rewrite CURRENT_TRUTH_INDEX;
- clean or move files.
'@
$AlphaContent = @'
# Alpha Omega Gate Inspection — 2026-05-23

Status: INSPECTION / CANDIDATE JUDGING GATE / NOT DOCTRINE
Scope: inspect whether Alpha Omega is a clean judging gate for gate-circle runs and future consolidation.
Boundary: no doctrine promotion, no replacement of Final Judge, no CONSOLIDATOR activation.

## 1. Why Alpha Omega Appeared

The current work is no longer a single gate.

It is a circle:
- a problem appears;
- gates fire;
- lessons stack;
- ambiguity appears;
- consolidation may become possible;
- the loop must end cleanly.

A normal one-point judge can miss whether the loop began cleanly and ended cleanly.

Alpha Omega appears because the house needs a start-to-finish loop judge.

## 2. Candidate Job

Alpha Omega Gate judges the whole loop.

Alpha asks:
- What opened the work?
- What was the seed problem?
- What was the first gate?
- What source/boundary started the route?
- Did we start clean or react too fast?

Omega asks:
- What is the final placed object?
- What was learned?
- What was applied?
- What was parked?
- What was rejected?
- What proof exists?
- What returned home?
- Did the user receive the clean status?

## 3. Neighbor Relationship

Alpha Omega should work with, not replace:

Final Judge:
- Final Judge checks whether the object did its job.
- Alpha Omega checks whether the whole loop from opening to closing stayed clean.

Proof / Receipt Gate:
- Proof Gate checks evidence.
- Alpha Omega checks whether proof was used at the right point in the loop.

CONSOLIDATOR:
- CONSOLIDATOR packs logic.
- Alpha Omega checks whether consolidation starts and ends cleanly.

Creative Gate:
- Creative Gate opens possibility.
- Alpha Omega checks whether possibility became placed, parked, rejected, or proved.

Return-Home Gate:
- Return-Home checks placement after work.
- Alpha Omega checks whether the loop truly closed.

## 4. Risk

Alpha Omega can become dangerous if it tries to be the king gate.

Blocked:
- replacing Final Judge;
- overriding proof;
- forcing consolidation;
- becoming doctrine;
- pretending every circle needs a large ceremony.

## 5. Clean Fit Decision

Verdict:
KEEP AS CANDIDATE / INSPECT DURING THREE SPINS.

Reason:
It fits the current model because gate-circle work needs beginning-to-end judgment. But it should not be installed as authority until the three spins show whether Final Judge alone is insufficient.

## 6. Test Questions for Mule

Ask mule:
1. Is Alpha Omega distinct from Final Judge?
2. Is it a gate, a lens, or a closing checklist?
3. Does it help CONSOLIDATOR avoid bad merges?
4. What should it never be allowed to do?
5. Where should it sit in the gate order?
'@
$MuleContent = @'
# Mule Handoff — Guest Boundary Gates, Three Spins, CONSOLIDATOR Readiness, Alpha Omega Inspection

Status: HANDOFF / REVIEW-ONLY / NO AUTHORITY
Scope: mule should review the new gate set, walk/check the house surfaces named below, run three conceptual gate spins, and return a shaped report.
Boundary: mule does not promote doctrine, does not rewrite ACTIVE_GUIDES, does not rewrite CURRENT_TRUTH_INDEX, does not activate CONSOLIDATOR, and does not become authority over Mr.Kleen.

## 1. Read First

Primary file:
`BRAIN_LEARNING\GUEST_BOUNDARY_GATE_SET_THREE_SPIN_REVIEW_RULE_20260523.md`

Then read:
`HOUSE_WORK\WORK_SHED\SORTING_BENCH\ALPHA_OMEGA_GATE_INSPECTION_20260523.md`

Useful context:
- Front-door/porch guest mess exposed boundary failure.
- Cleanup is not enough; the behavior must be solved.
- Guests/helpers/mule outputs/assistant drops need placement, permission, cleanup, return-home, and enforcement.
- CONSOLIDATOR is up the sleeve until gate spins expose real ambiguity/overlap.
- Alpha Omega is a candidate judging gate that may help judge the whole loop from start to finish.

## 2. Mule Task

Review and shape the gate set.

Gate set:
- Problem Solving Gate
- Boundaries Gate
- Permission Gate
- Guest Boundary Gate
- Return-Home Gate
- Enforcement Ladder Gate
- Creative Gate / Wildcard / Emergence
- Future Plans / Idea-Leading / Giving Room for Growth
- Proof / Receipt Gate
- Final Judge
- CONSOLIDATOR Candidate
- Alpha Omega Candidate

## 3. Walk the House

Walk only targeted surfaces needed for this review.

Check:
- `BRAIN_LEARNING`
- `HOUSE_WORK\WORK_SHED\SORTING_BENCH`
- `HOUSE_WORK\WORK_SHED\PARKING`
- `HOUSE_WORK\INDEXES`
- `PROOF_HISTORY`

Do not broad-crawl the whole house unless needed. Do not move/delete/rename files.

## 4. Run Three Full Conceptual Spins

### Spin 1 — Practical Fit

Ask:
- Does each gate solve a real exposed issue?
- Which gates are necessary for front-door/guest discipline?
- Which gates are overbuilt?

### Spin 2 — Neighbor Order

Ask:
- What is the best gate order?
- Which gates must fire before others?
- Which gates are friends/neighbors?
- Which gates conflict?

### Spin 3 — Consolidation Readiness

Ask:
- Where is ambiguity?
- Which logic belongs inside a better gate?
- Which gates are only sub-steps?
- Which broad ideas should stay packed into one gate?
- Which new clean-fit gates appear?
- What should CONSOLIDATOR do later?
- What must CONSOLIDATOR not touch?

## 5. Alpha Omega Inspection

Inspect Alpha Omega carefully.

Ask:
- Is Alpha Omega a gate, lens, or checklist?
- Is it distinct from Final Judge?
- Does it judge the whole loop better than Final Judge alone?
- Where does it sit in the order?
- What are its blocked moves?
- Does it help CONSOLIDATOR avoid bad merges?

## 6. Return Format

Return one report with:

1. Verdict:
   PASS / PASS WITH GUARDRAILS / PARTIAL / FAIL

2. Clean gate list:
   - gate name;
   - job;
   - boundary;
   - neighbor;
   - proof requirement.

3. Three-spin findings:
   - Spin 1;
   - Spin 2;
   - Spin 3.

4. Consolidation advice:
   - merge;
   - keep separate;
   - move logic;
   - park;
   - reject.

5. Alpha Omega judgment:
   - keep as gate / lens / checklist / reject;
   - why;
   - blocked moves.

6. New gates found:
   Only include if they cleanly fit the model.

7. Final boundary:
   Confirm no doctrine promotion, no ACTIVE_GUIDE rewrite, no CURRENT_TRUTH_INDEX rewrite, no CONSOLIDATOR activation.
'@

Set-Content -LiteralPath $RulePath -Value $RuleContent -Encoding UTF8
Set-Content -LiteralPath $AlphaPath -Value $AlphaContent -Encoding UTF8
Set-Content -LiteralPath $RepoHandoffPath -Value $MuleContent -Encoding UTF8
Set-Content -LiteralPath $DesktopHandoffPath -Value $MuleContent -Encoding UTF8

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$AlphaHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $AlphaPath).Hash
$RepoHandoffHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RepoHandoffPath).Hash
$DesktopHandoffHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopHandoffPath).Hash

$StatusAppend = @"

## 2026-05-23 — Guest Boundary Gate Set + Mule Three-Spin Review

Status: SAVED BY SCRIPT / SUPPORT GATE SET + MULE HANDOFF / NO DOCTRINE PROMOTION
Old base before save: $OldHead

Saved:
- $RulePath
- $AlphaPath
- $RepoHandoffPath
- $ReceiptPath

Desktop mule pickup:
- $DesktopHandoffPath

Meaning:
- added candidate gate set for Problem Solving, Boundaries, Permission, Guest Boundary, Return-Home, and Enforcement Ladder;
- defined three-spin gate review loop;
- defined CONSOLIDATOR as candidate for later ambiguity/logic consolidation after spins;
- inspected Alpha Omega as candidate loop-judging gate;
- created mule handoff for review-only walk and three conceptual spins.

Boundary:
No ACTIVE_GUIDE rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine promotion. No CONSOLIDATOR activation. No Alpha Omega promotion. No mule execution by this save. No cleanup/delete/move. No runtime, automation, dashboard, or public authority change.
"@

if (Test-Path -LiteralPath $StatusPath) {
    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
} else {
    Set-Content -LiteralPath $StatusPath -Value ("# Current House Work Status`r`n" + $StatusAppend) -Encoding UTF8
}
$StatusHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $StatusPath).Hash

$ReceiptContent = @"
GUEST BOUNDARY GATE SET + THREE-SPIN REVIEW SAVE RECEIPT

Timestamp: $Now
Repo: $Repo
Branch: $Branch
Old HEAD: $OldHead

Verdict intended by save:
PASS WITH GUARDRAILS / SUPPORT GATE SET + MULE HANDOFF SAVED / NO DOCTRINE PROMOTION

Saved files:
- $RulePath
  SHA256: $RuleHash
- $AlphaPath
  SHA256: $AlphaHash
- $RepoHandoffPath
  SHA256: $RepoHandoffHash
- $StatusPath
  SHA256 after append: $StatusHash

Desktop mule pickup:
- $DesktopHandoffPath
  SHA256: $DesktopHandoffHash

Core idea saved:
Add the practical gate set, prepare mule review, run three conceptual spins, identify clean-fit gates, inspect Alpha Omega, and keep CONSOLIDATOR as candidate for later ambiguity/logic consolidation.

Boundary:
- This save does not run mule.
- This save does not run the three spins itself.
- CONSOLIDATOR is not activated.
- Alpha Omega is inspected as candidate, not promoted.
- No ACTIVE_GUIDE rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine promotion.
- No cleanup/delete/move.
- No runtime, automation, dashboard, or public authority change.

Final Git HEAD, remote match, and clean status are verified by script output after commit/push.
"@

Set-Content -LiteralPath $ReceiptPath -Value $ReceiptContent -Encoding UTF8
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

git add -- $RulePath $AlphaPath $RepoHandoffPath $StatusPath
git add -f -- $ReceiptPath

$Cached = git --no-pager diff --cached --name-only
if (-not $Cached) {
    throw "No staged changes found. Gate-set save did not produce expected dirty paths."
}

$Expected = @(
    $RulePath.Replace("\","/"),
    $AlphaPath.Replace("\","/"),
    $RepoHandoffPath.Replace("\","/"),
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

git commit -m "Save guest boundary gate set and mule review"

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
Write-Host "GUEST BOUNDARY GATE SET + MULE REVIEW SAVE COMPLETE"
Write-Host "Old base: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Rule: $RulePath"
Write-Host "Rule SHA256: $RuleHash"
Write-Host "Alpha Omega inspection: $AlphaPath"
Write-Host "Alpha Omega SHA256: $AlphaHash"
Write-Host "Repo mule handoff: $RepoHandoffPath"
Write-Host "Repo mule handoff SHA256: $RepoHandoffHash"
Write-Host "Desktop mule pickup: $DesktopHandoffPath"
Write-Host "Desktop mule pickup SHA256: $DesktopHandoffHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / SUPPORT GATE SET + MULE HANDOFF SAVED / NO DOCTRINE PROMOTION"
