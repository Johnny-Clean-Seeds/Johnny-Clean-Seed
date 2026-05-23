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
    throw "Stop: repo must be clean before this repair save to avoid mixing unrelated work."
}

$OldHead = (git rev-parse HEAD).Trim()
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

$RulePath = "BRAIN_LEARNING\CREATIVE_GATE_FRIENDSHIP_NEIGHBOR_ORDER_RULE_20260523.md"
$MapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CREATIVE_GATE_FRIENDSHIP_NEIGHBOR_ORDER_MAP_20260523.md"
$FitReviewPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CREATIVE_GATE_WILDCARD_EMERGENCE_LOGIC_FIT_REVIEW_20260523.md"
$ReservePath = "HOUSE_WORK\WORK_SHED\PARKING\WILDCARD_GATE_FUTURE_SPLIT_RESERVE_20260523.md"
$ReceiptPath = "PROOF_HISTORY\CREATIVE_GATE_WILDCARD_EMERGENCE_LOGIC_REPAIR_RECEIPT_$Now.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$RequiredExisting = @($RulePath, $MapPath, $StatusPath)
foreach ($p in $RequiredExisting) {
    if (-not (Test-Path -LiteralPath $p)) {
        throw "Required existing file missing: $p"
    }
}

$Paths = @($FitReviewPath, $ReservePath, $ReceiptPath)
foreach ($p in $Paths) {
    $parent = Split-Path -Parent $p
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

$RuleRepair = @'
## Repair — Wildcard / Emergence Logic Inside Creative Gate — 2026-05-23

Status: SUPPORT REPAIR / ACTIVE INSIDE CREATIVE GATE / NOT A STANDALONE GATE

### 1. Wildcard Logic

The Creative Gate must include a wildcard slot.

Job:
Catch non-obvious, out-of-pattern, lateral, strange-but-fitting, missing-piece, unexpected-resource, unique-idea, or unpredicted-outcome moves that normal gate order may miss.

The wildcard slot may ask:
- What useful option is not in the obvious list?
- What weird source, tool, analogy, or old note might fit?
- What hidden neighbor is being ignored?
- What move would solve this without following the expected route?
- What candidate room/tool/method appears only if the pattern is bent?
- What unique idea wants to spawn from this task?
- What unpredicted outcome should be preserved as signal instead of dismissed as noise?
- What strange piece might unlock the larger model?

Allowed:
- propose unusual candidates;
- spawn unique candidate ideas;
- surface unpredicted outcomes;
- surface lateral resources;
- pull odd source ore back into view;
- create rough/slop sketches for Cleanup Bench;
- reveal a missing candidate room/tool;
- suggest a non-default route if it still respects boundaries.

Blocked:
- treating wildcard output as proof;
- using wildcard to bypass source custody;
- using wildcard to skip lane, boundary, neighbor fit, cleanup, or Final Judge;
- installing a spawned idea as authority;
- turning surprise into doctrine without proof;
- creating a separate Wildcard Gate before repeated evidence proves it needs its own job.

Short form:
Wildcard may spawn unique ideas and unpredicted outcomes. It produces candidates, not proof.

### 2. Emergence / Discovery Logic

Wildcard may use emergence logic.

Emergence means:
Several odd, unique, lateral, or unpredicted candidate pieces may combine into a larger pattern that was not visible from any single piece.

Discovery rule:
Do not dismiss a strange output merely because it was not predicted. Treat it as candidate signal until Cleanup Bench and Final Judge sort it.

Emergence may reveal:
- a new candidate idea;
- a hidden pattern;
- a missing room/tool/method;
- a better route through the house;
- a repeated pressure point;
- a future gate split;
- a resource combination that did not exist as a named object before.

Required handling:
1. name the emergent pattern if possible;
2. list the source pieces that produced it;
3. mark it as emergent/wildcard-spawned;
4. state what lane it may fit;
5. route it through Cleanup Bench;
6. run Large Model Fit;
7. decide accept / refine / park with return trigger / split / reject;
8. close with Final Judge.

Boundary:
Emergence is discovery behavior, not authority. It leaves room for future learning without premature doctrine.
'@
$MapRepair = @'
## Repair — Wildcard / Emergence Neighbor Logic — 2026-05-23

Status: MAP REPAIR / CREATIVE GATE COMPANION LOGIC / NO NEW BOSS GATE

Placement:
Wildcard / Emergence Logic sits inside Creative Gate during the gate friendship order.

Neighbor relation:
Rule-Fit defines the lane.
Creative Gate opens resource synthesis.
Wildcard Logic bends the pattern and may spawn unusual candidates or unpredicted outcomes.
Emergence Logic watches whether multiple odd pieces form a larger discoverable pattern.
Cleanup Bench / Edit Review sorts the spawn.
Clean-Placed Growth checks whether the new object has a place.
Future Plans / Idea-Leading holds early strong ideas with lane and return trigger.
Proof and Final Judge decide status.

Do not place Wildcard before source custody or rule-fit.
Do not place Wildcard after proof as a last-minute excuse.
Do not treat Wildcard as a new gate unless repeated runs prove it has an independent job.
Do not treat emergent patterns as installed truth without cleanup and proof.
'@
$FitReviewContent = @'
# Creative Gate Wildcard / Emergence Logic Fit Review — 2026-05-23

Status: SORTING BENCH FIT REVIEW / SUPPORT REPAIR
Scope: decide whether wildcard and emergence belong inside Creative Gate or should become a standalone Wildcard Gate.
Boundary: this review does not activate a standalone Wildcard Gate and does not rewrite doctrine.

## 1. Founding Source

User asked:
- make sure this Creative Gate uses a wildcard in its logic or something;
- maybe make a Wildcard Gate if that is a thing;
- wildcard can or may spawn unique ideas;
- unpredicted outcomes;
- this gate may use emergence or something;
- we will discover more for this concept.

User correction:
- do not call this a surface-covering fix;
- house work should be framed as repair/fix/build work.

## 2. Clean Translation

Wildcard Logic is a controlled creative slot.

It lets Creative Gate search beyond the obvious route and spawn:
- unique ideas;
- strange-but-fitting candidates;
- lateral routes;
- unexpected resource combinations;
- missing-room/tool candidates;
- unpredicted outcomes worth preserving as signal.

Emergence / Discovery Logic watches whether multiple wildcard or strange pieces combine into a larger pattern that was not visible from any one piece.

## 3. Fit Decision

Best current fit:
ACTIVE INSIDE CREATIVE GATE.

Reason:
Creative Gate already owns resource synthesis, candidate room/tool creation, slop sketching, and large-model fit exploration. Wildcard and emergence are logic lenses inside that gate, not yet separate gates.

Standalone Wildcard Gate:
PARK / FUTURE SPLIT CANDIDATE.

Reason:
A separate gate may become clean later if repeated use proves Wildcard has an independent job beyond Creative Gate.

## 4. Required Handling for Wildcard / Emergence Output

Wildcard and emergence output must be routed as candidate/source-shaping material.

Required path:
1. name the spawned item or emergent pattern;
2. mark it wildcard-spawned and/or emergent;
3. state why it appeared;
4. list the source pieces, if known;
5. state what lane it may fit;
6. run source custody if source-based;
7. run Cleanup Bench / Edit Review;
8. run Clean-Placed Growth;
9. run Large Model Fit;
10. decide accept / refine / park with return trigger / split / reject;
11. Final Judge closes.

## 5. Blocked Moves

Blocked:
- surprise equals proof;
- novelty equals value;
- emergence equals doctrine;
- wildcard overrides boundary;
- unique idea becomes installed rule immediately;
- standalone Wildcard Gate activated without repeated proof;
- using wildcard to make random bloat;
- dismissing unpredicted outcomes before checking whether they are signal.

## 6. Verdict

PASS WITH GUARDRAILS as a repair inside Creative Gate.

Future condition:
If Wildcard / Emergence Logic repeatedly produces useful outputs that need their own intake, proof, cleanup, and return route, then reopen the standalone Wildcard Gate candidate.
'@
$ReserveContent = @'
# Wildcard Gate Future Split Reserve — 2026-05-23

Status: HELD RESERVE / FUTURE SPLIT CANDIDATE / NOT ACTIVE
Scope: hold the possible standalone Wildcard Gate without installing it.
Boundary: this is not an active gate, not doctrine, and not proof of independent need.

## 1. Held Idea

Name:
Wildcard Gate

Potential future job:
Act as an independent gate for spawning, capturing, and routing unique ideas, emergent patterns, and unpredicted outcomes that do not fit normal gate order but repeatedly prove useful.

## 2. Why Held Now

Creative Gate already has the right home for wildcard/emergence behavior.

Splitting now would risk:
- unnecessary gate multiplication;
- fake novelty authority;
- random bloat;
- bypassing source custody;
- overbuilding before evidence;
- turning discovery into doctrine too early.

## 3. Return Trigger

Reopen this reserve only if:
1. Wildcard / Emergence Logic is used across several gate runs;
2. it repeatedly produces useful candidates;
3. those candidates need a distinct handling path beyond Creative Gate;
4. Creative Gate becomes overloaded by wildcard duties;
5. proof shows a standalone gate would reduce confusion instead of adding bloat.

## 4. Activation Requirements

Before activation, define:
- name;
- job;
- boundary;
- input;
- output;
- proof path;
- cleanup path;
- neighbor order;
- blocked moves;
- retirement condition.

## 5. Short Form

Wildcard and emergence live inside Creative Gate now.
Wildcard Gate stays up the sleeve until repeated proof earns the split.
'@

$RuleRaw = Get-Content -Raw -LiteralPath $RulePath
$MapRaw = Get-Content -Raw -LiteralPath $MapPath

if ($RuleRaw -notmatch "Wildcard / Emergence Logic Inside Creative Gate") {
    Add-Content -LiteralPath $RulePath -Value ("`r`n" + $RuleRepair) -Encoding UTF8
} else {
    Write-Host "Rule already contains Wildcard / Emergence repair section; not duplicating."
}

if ($MapRaw -notmatch "Wildcard / Emergence Neighbor Logic") {
    Add-Content -LiteralPath $MapPath -Value ("`r`n" + $MapRepair) -Encoding UTF8
} else {
    Write-Host "Map already contains Wildcard / Emergence repair section; not duplicating."
}

Set-Content -LiteralPath $FitReviewPath -Value $FitReviewContent -Encoding UTF8
Set-Content -LiteralPath $ReservePath -Value $ReserveContent -Encoding UTF8

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$MapHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $MapPath).Hash
$FitReviewHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $FitReviewPath).Hash
$ReserveHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReservePath).Hash

$StatusAppend = @"

## 2026-05-23 — Creative Gate Wildcard / Emergence Logic Repair

Status: SAVED BY SCRIPT / SUPPORT REPAIR / NO DOCTRINE PROMOTION
Old base before save: $OldHead

Saved / repaired:
- repaired $RulePath
- repaired $MapPath
- added $FitReviewPath
- added $ReservePath
- added $ReceiptPath

Meaning:
- Creative Gate now includes Wildcard Logic as a controlled slot;
- Wildcard may spawn unique ideas and unpredicted outcomes;
- Emergence / Discovery Logic watches whether multiple odd pieces combine into a larger discoverable pattern;
- wildcard/emergence outputs are candidates/source-shaping material, not proof or authority;
- standalone Wildcard Gate remains a held future split candidate, not active;
- house work is framed as repair/fix/build work, not surface-covering work.

Boundary:
No ACTIVE_GUIDE rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine promotion. No standalone Wildcard Gate activation. No runtime, automation, dashboard, or public authority change.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
$StatusHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $StatusPath).Hash

$ReceiptContent = @"
CREATIVE GATE WILDCARD / EMERGENCE LOGIC REPAIR RECEIPT

Timestamp: $Now
Repo: $Repo
Branch: $Branch
Old HEAD: $OldHead

Verdict intended by save:
PASS WITH GUARDRAILS / SUPPORT REPAIR SAVED / WILDCARD GATE HELD RESERVE

Repaired / saved files:
- $RulePath
  SHA256 after repair: $RuleHash
- $MapPath
  SHA256 after repair: $MapHash
- $FitReviewPath
  SHA256: $FitReviewHash
- $ReservePath
  SHA256: $ReserveHash
- $StatusPath
  SHA256 after append: $StatusHash

Boundary:
- Wildcard Logic is active inside Creative Gate, not a standalone gate.
- Wildcard may spawn unique candidate ideas and unpredicted outcomes.
- Emergence / Discovery Logic may identify larger patterns from multiple odd pieces.
- Wildcard/emergence output is candidate/source-shaping material, not proof or authority.
- Standalone Wildcard Gate is held reserve only.
- No ACTIVE_GUIDE rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine promotion.
- No runtime, automation, dashboard, or public authority change.

Final Git HEAD, remote match, and clean status are verified by script output after commit/push.
"@

Set-Content -LiteralPath $ReceiptPath -Value $ReceiptContent -Encoding UTF8
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

git add -- $RulePath $MapPath $FitReviewPath $ReservePath $StatusPath
git add -f -- $ReceiptPath

$Cached = git --no-pager diff --cached --name-only
if (-not $Cached) {
    throw "No staged changes found. Repair save did not produce expected dirty paths."
}

$Expected = @(
    $RulePath.Replace("\","/"),
    $MapPath.Replace("\","/"),
    $FitReviewPath.Replace("\","/"),
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

git commit -m "Repair creative gate wildcard emergence logic"

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
Write-Host "CREATIVE GATE WILDCARD / EMERGENCE LOGIC REPAIR SAVE COMPLETE"
Write-Host "Old base: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Rule repaired: $RulePath"
Write-Host "Rule SHA256: $RuleHash"
Write-Host "Map repaired: $MapPath"
Write-Host "Map SHA256: $MapHash"
Write-Host "Fit review: $FitReviewPath"
Write-Host "Fit review SHA256: $FitReviewHash"
Write-Host "Reserve: $ReservePath"
Write-Host "Reserve SHA256: $ReserveHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / SUPPORT REPAIR SAVED / WILDCARD GATE HELD RESERVE"
