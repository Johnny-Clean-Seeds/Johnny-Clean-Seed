$ErrorActionPreference = "Stop"

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$SourceDir = Join-Path $Root123 "RULE_INTAKE\GROWTH_SAFE_GATE_JUDGE_ROLE_BOUNDARY_20260522"
New-Item -ItemType Directory -Force -Path $SourceDir | Out-Null

$SourceNote = Join-Path $SourceDir "GROWTH_SAFE_GATE_JUDGE_ROLE_BOUNDARY_SOURCE_CAPTURE_20260522.md"

@"
# Growth-Safe Gate Judge / Gate Role Boundary Source Capture 20260522

Founding original / source-root user wording:

1.
iddddkkk i dont know about that it seems like this is a really good way to kill growth. just becaue you dont know now doesnt mean it isnt until it is you cant go around doing shit like that thats wrong. nothing is DISPROVEN until sometihng is PROVEN that DISPROVES IT!

2.
fuckin right and that fucking idea owns this

3.
its the very foundation of thsi gate

4.
otherwise the gate is a fucking liar

5.
there must be a gate judge to ensure no one steps tjhe fuck out of line it ensure all do their fucking job and only their fucking job each gate job is to mind its fucking buisness and only what it getsfrom the last gate. each gate is really only making the shit nice for the next gate but the gate has no fucking clue because its so busy doing what the fuck it needs to do and only that

Clean translation:
A proof gate must not treat "not proven" as "disproven." Missing proof blocks PASS/promotion/doctrine but does not kill possibility. Each gate must only do its own job, receive only the prior gate's allowed output, clean/prepare that object for the next gate, and avoid reaching sideways into jobs it does not own. A gate judge watches the gates and stops any gate that steps out of role, scope, proof state, or lane.

Rule relationship:
This is foundational to Anti-Fake-PASS / Cargo Cult / proof-integrity gates. Those gates block fake proof, fake PASS, premature promotion, and ritual. They do not destroy live candidates. The gate judge keeps each gate in its lane so a proof gate does not become a growth-killer.

Fit check:
This adds/updates proof discipline and gate-role discipline only. It does not change code delivery style, Desktop\123 pickup, Git save default, source-safe boundaries, or Feynman source-ore status.

Short forms:
Missing proof blocks PASS. Only disproof kills.
Each gate minds its own business.
Gate judge keeps gates in lane.
"@ | Set-Content -Path $SourceNote -Encoding UTF8

$SourceHash = (Get-FileHash -Algorithm SHA256 -Path $SourceNote).Hash

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"
Set-Location $Repo
if (-not (Test-Path ".git")) { throw "Not in Mr.Kleen repo: $Repo" }

$Pre = git status --short
if ($Pre) { throw "Mr.Kleen not clean. Stop.`n$Pre" }

$Old = git rev-parse HEAD

$Rule1 = "BRAIN_LEARNING/GROWTH_SAFE_UNDISPROVED_CANDIDATE_RULE_20260522.md"
$Rule2 = "BRAIN_LEARNING/GATE_JUDGE_ROLE_BOUNDARY_RULE_20260522.md"
$Capture = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/GROWTH_SAFE_GATE_JUDGE_ROLE_BOUNDARY_CAPTURE_20260522.md"
$Status = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"
$Proof = "PROOF_HISTORY/GROWTH_SAFE_GATE_JUDGE_ROLE_BOUNDARY_RECEIPT_20260522.txt"

New-Item -ItemType Directory -Force -Path (Split-Path $Rule1),(Split-Path $Rule2),(Split-Path $Capture),(Split-Path $Status),(Split-Path $Proof) | Out-Null

@"
# Growth-Safe Undisproved Candidate Rule 20260522

Status: ACTIVE BEHAVIOR RULE / FOUNDATION FOR PROOF GATES.

Problem fixed:
A proof gate can become too sharp and accidentally kill growth by treating unproven material as disproven material.

Foundation rule:
Not proven does not mean disproven.

Meaning:
Unknown, weird, partial, unproven, early, source-ore, candidate, parked, watch, or not-yet-explained material must not be killed merely because proof is missing.

Correct handling:
- missing proof blocks PASS
- missing proof blocks promotion
- missing proof blocks doctrine
- missing proof blocks active-guide rewrite
- missing proof blocks CURRENT_TRUTH_INDEX rewrite
- missing proof does not prove falsehood
- missing proof does not delete possibility

Disproof standard:
A claim is disproven only when there is positive proof that defeats it, contradicts it, or shows it fails under the relevant test.

State distinction:
- Unknown: not enough evidence yet.
- Unproven: possible, but not proved.
- Candidate: held for testing.
- Source ore: useful raw material, not adopted.
- Partial: some value, incomplete proof.
- Parked: held safely for later.
- Watch: monitor for future signal.
- Failed: failed a specific test.
- Disproven: positive evidence defeats the claim.

Relationship to Anti-Fake-PASS / Cargo Cult / proof-integrity gates:
This rule is foundational to those gates. Those gates may block fake proof, fake PASS, premature promotion, ritual science, and unsupported doctrine. They may not kill live possibility merely because it is unproven.

If a proof gate treats "not proven" as "disproven," the gate is lying about proof.

Blocked:
- killing source ore because it is weird
- deleting a candidate because it is not yet proved
- calling unknown false
- using anti-fake-PASS as anti-growth
- using Cargo Cult logic as an insult or possibility-killer
- requiring doctrine-level proof before allowing source-ore holding
- treating lack of current explanation as disproof

Short forms:
Missing proof blocks PASS. Only disproof kills.
Proof gates protect growth by blocking fake promotion, not by destroying candidates.
"@ | Set-Content -Path $Rule1 -Encoding UTF8

@"
# Gate Judge / Gate Role Boundary Rule 20260522

Status: ACTIVE BEHAVIOR RULE / GATE GOVERNANCE RULE.

Problem fixed:
A gate can step out of line and start doing another gate's job. That causes proof gates to kill growth, source gates to promote, cleanup gates to delete living candidates, or translation gates to erase founding originals.

Rule:
Every gate must mind its own business.

Each gate must:
- receive only the allowed input from the previous gate
- perform only its assigned transformation/check
- preserve the object's current state unless its job explicitly changes that state
- prepare the object cleanly for the next gate
- hand off only what the next gate is allowed to receive
- refuse work outside its lane

Gate judge mission:
The gate judge watches the gate stack and stops any gate that steps outside role, lane, authority, or proof state.

Gate judge checks:
1. What gate is active?
2. What is this gate's exact job?
3. What input did it receive from the previous gate?
4. Is the input allowed for this gate?
5. What output is this gate allowed to produce?
6. Is the gate trying to prove, promote, delete, translate, route, or judge outside its role?
7. Is the gate confusing "unproven" with "disproven"?
8. Is the gate preserving founding originals and source custody?
9. Is the gate preparing the object for the next gate instead of hijacking the whole route?
10. Should the gate stop and hand off?

Gate role examples:
- Source intake gate captures source and custody. It does not promote doctrine.
- Clean translation gate makes a working use-form. It does not erase founding original.
- Proof gate blocks unsupported PASS/promotion. It does not kill possibility.
- Disproof gate can kill only when positive disproof exists.
- Cleanup gate removes only stale, superseded, unsafe, rejected, or valueless duplicate material.
- Promotion gate only promotes when promotion is the tested objective and proof supports it.
- Save gate saves the approved packet. It does not rewrite the idea.
- Delivery gate shapes the command/file ergonomics. It does not change source routing.

Core image:
Each gate is busy doing only its own job. It does not need to know the whole destiny of the build. It receives from the last gate, makes the object cleaner for the next gate, then hands off.

Blocked:
- gate doing another gate's job
- proof gate deleting candidates
- translation gate replacing source truth
- save gate changing content scope
- cleanup gate killing non-stale material
- source gate acting like authority
- promotion gate firing without promotion route
- delivery rule changing source pickup
- source pickup rule changing delivery style

Short forms:
Each gate minds its own business.
Gate judge keeps gates in lane.
A gate makes the object ready for the next gate; it does not own the whole house.
"@ | Set-Content -Path $Rule2 -Encoding UTF8

@"
# Growth-Safe Gate Judge / Gate Role Boundary Capture 20260522

Status: FOUNDATION REPAIR / RULE CAPTURE.

Source capture:
$SourceNote

Source capture SHA256:
$SourceHash

Captured founding originals:
- nothing is DISPROVEN until sometihng is PROVEN that DISPROVES IT
- that fucking idea owns this
- its the very foundation of thsi gate
- otherwise the gate is a fucking liar
- there must be a gate judge to ensure no one steps tjhe fuck out of line
- each gate job is to mind its fucking buisness and only what it getsfrom the last gate
- each gate is really only making the shit nice for the next gate

Clean translation:
Proof gates protect growth by blocking fake PASS/promotion, not by destroying candidates. A gate judge ensures each gate performs only its role and passes a cleaner object to the next gate without stealing another gate's authority.

Fit with existing rules:
- Fits Rule-Fit / No Side-Mutation Gate.
- Fits Clean-Placed Growth / Clean BLOAT Rule.
- Fits Founding Original -> Clean Translation Linked Pair Rule.
- Repairs the risk of Cargo Cult / Anti-Fake-PASS becoming growth-killing.
- Strengthens staged gate work.
- Does not change code delivery style.
- Does not change Desktop\123 source pickup default.
- Does not change Git save/push default.
- Does not promote doctrine.

Boundary:
Behavior rules and foundation repair only. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine promotion. No automation.
"@ | Set-Content -Path $Capture -Encoding UTF8

Add-Content -Path $Status -Encoding UTF8 -Value @"

## 20260522 - Growth-safe gate judge and role-boundary rules saved
Saved Growth-Safe Undisproved Candidate Rule and Gate Judge / Gate Role Boundary Rule. These distinguish unproven from disproven and require each gate to do only its own job, receive from the prior gate, and prepare clean output for the next gate. Boundary: behavior rules and foundation repair only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation.
"@

@"
GROWTH SAFE GATE JUDGE ROLE BOUNDARY RECEIPT 20260522
Old HEAD: $Old
Source capture: $SourceNote
Source capture SHA256: $SourceHash

Saved:
- $Rule1
- $Rule2
- $Capture
- $Status

Boundary:
Behavior rules and foundation repair only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation.
"@ | Set-Content -Path $Proof -Encoding UTF8

$All = @($Rule1,$Rule2,$Capture,$Status,$Proof)
$Manifest = ($All | ForEach-Object { (Get-FileHash -Algorithm SHA256 -Path $_).Hash + "  " + $_ }) -join "`n"
Add-Content -Path $Proof -Encoding UTF8 -Value "`nSHA256 MANIFEST:`n$Manifest"

git add -- $Rule1 $Rule2 $Capture $Status
if ($LASTEXITCODE) { throw "git add failed" }

git add -f -- $Proof
if ($LASTEXITCODE) { throw "proof receipt add failed" }

git commit -m "Add growth safe gate judge role rules"
if ($LASTEXITCODE) { throw "commit failed" }

git push origin main
if ($LASTEXITCODE) { throw "push failed" }

$New = git rev-parse HEAD
$Remote = git rev-parse origin/main
$Clean = git status --short

if ($New -ne $Remote) { throw "HEAD != origin/main" }
if ($Clean) { throw "Final status not clean:`n$Clean" }

Write-Host "PASS - GROWTH SAFE GATE JUDGE ROLE RULES SAVED"
Write-Host "Old HEAD: $Old"
Write-Host "New HEAD: $New"
Write-Host "Remote HEAD: $Remote"
Write-Host "Final status: clean"
Write-Host "Receipt: $Proof"
