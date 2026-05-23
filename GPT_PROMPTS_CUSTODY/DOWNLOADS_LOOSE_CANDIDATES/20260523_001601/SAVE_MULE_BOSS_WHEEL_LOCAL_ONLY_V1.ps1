# SAVE_MULE_BOSS_WHEEL_LOCAL_ONLY_V1.ps1
# Local-only mule support save. No Git commit. No push. No public export.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Root = Join-Path $env:USERPROFILE "Desktop\123\MULE_LOCAL_ONLY\BOSS_POOL_WHEEL"
$ReceiptDir = Join-Path $Root "RECEIPTS"
New-Item -ItemType Directory -Path $Root,$ReceiptDir -Force | Out-Null

$LockPath = Join-Path $Root "MULE_BOSS_POOL_WHEEL_LOCAL_ONLY_LOCK_V1.md"
$WheelPath = Join-Path $Root "MULE_BOSS_POOL_WHEEL_0_JUDGE_12_GATES_V1.md"
$KickoffPath = Join-Path $Root "MULE_BOSS_POOL_WHEEL_KICKOFF_V1.md"
$ReceiptPath = Join-Path $ReceiptDir ("MULE_BOSS_POOL_WHEEL_LOCAL_ONLY_SAVE_RECEIPT_{0}.txt" -f $Stamp)

$Lock = @'
# Mule Boss Pool Wheel — Local-Only Lock — V1

STATUS: LOCKED LOCAL-ONLY SUPPORT

PURPOSE:
This file locks the mule boss-pool wheel as a local-only support method for mule runs.

BOUNDARY:
- This is not public.
- This is not GitHub material.
- This is not doctrine.
- This is not an ACTIVE_GUIDE rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not a promotion.
- This is not a cleanup pass.
- This is a local-only mule run support lock.

WHY LOCAL ONLY:
These mule boss-pool run files are intentionally missing from the actual public/brain authority path. They exist locally so the mule and the assistant can fill in missing run-shape blanks when the formal brain files do not carry this private mule-run pattern.

CONTROL RULE:
Use this as run-shape support only. It may organize mule runs. It may not override the controller gate, compact spine, active user task, or current run lock.

LOAD-IN-CHAT NOTE:
Assistant should keep the 0 Judge + 12 Gates wheel in working context for mule-file boss-pool runs and use it to fill blanks when the local-only files are absent from the formal brain.

STOP RULE:
If this conflicts with a current user instruction, current mule controller, or safety boundary, stop and ask for the smallest clarification or write an expansion request. Do not improvise authority.
'@

$Wheel = @'
# Mule Boss Pool Wheel — 0 Judge + 12 Gates — V1

CORE SHAPE:
0 JUDGE sits in the center.
1-12 sit around it as ordered gates.
The run moves 1 -> 12, then returns to 1 only after 0 JUDGE closes the cycle.

THREE CONTROLS:
1. Order — every gate fires in sequence.
2. Domain — every gate owns one job.
3. Relationship — every gate has neighbors and an opposite/checking gate.

0. JUDGE GATE — Center / Whole-Wheel Judge
Job: starts the run, watches every gate, judges every gate, and closes the run.
Checks:
- Did each gate fire?
- Did each gate stay in its job?
- Did any gate overreach?
- Did any gate get skipped?
- Did the run finish cleanly?
- Is the output safe for user review?

1. ANCHOR GATE — Current Position
Job: confirms current project position, active task, active lane, what is already closed, and what must not be reopened.

2. RUN LOCK GATE — Run Contract
Job: locks mode, scope, authority, inputs, allowed output, stop rule, and expansion rule before work begins.

3. AUTHORITY GATE — What Can Command
Job: separates command files from reference, stale history, source ore, support, and non-command material.

4. FILE ROLE GATE — Every Object Gets a Job
Job: classifies every mule file as active controller, active spine, active support, optional expansion, stale, retired, duplicate, unknown, or needs user review.

5. VERSION DRIFT GATE — Old vs Current
Job: checks version conflict and decides which version controls normal runs, which versions are support-only, and which versions are stale or ignored.

6. NEIGHBOR FIT GATE — Side-to-Side Compatibility
Job: checks nearby gates, files, rules, lanes, and workflows before changing anything, so one fix does not break its neighbor.

7. MIRROR / OPPOSITE CHECK GATE — Direct Counterbalance
Job: checks the opposite side of the wheel. It asks what the opposite risk is, what a gate would miss by itself, whether the run is too narrow or too broad, and whether the fix creates the opposite problem.

8. CONTROLLER / SPINE FIT GATE — Minimal Working Set
Job: decides whether the controller gate plus compact spine are enough for the mule to run cleanly.

9. EXPANSION GATE — Bigger Context Permission
Job: controls access to bigger files, boards, archives, folders, or broader context. Default is no expansion unless blocked.

10. OUTPUT SHAPE GATE — Return Format
Job: forces mule output into a clean top block and reviewable sections.

Required top block:
STATUS:
RUN LOCK:
FILES READ:
TASK:
SCOPE:
MODE:
NOT DONE:
NEEDS USER REVIEW:

11. NO PROMOTION GATE — Authority Boundary
Job: blocks premature authority changes unless explicitly authorized:
- merge
- doctrine install
- active guide rewrite
- CURRENT_TRUTH_INDEX rewrite
- deletion
- cleanup
- final truth declaration
- broad restructuring

12. FIT DECISION / CARRYOVER GATE — Close and Feed Forward
Job: gives every object a disposition and names the next clean move.

Disposition options:
- use now
- support only
- shed later
- retire
- duplicate
- reject
- unknown / needs review
- expansion candidate
- return trigger

WHEEL MECHANICS:
0 Judge opens.
1 Anchor.
2 Run Lock.
3 Authority.
4 File Role.
5 Version Drift.
6 Neighbor Fit.
7 Mirror/Opposite Check.
8 Controller/Spine Fit.
9 Expansion.
10 Output Shape.
11 No Promotion.
12 Fit Decision / Carryover.
0 Judge closes.

Only after Judge closes clean may 12 feed the next clean start back to 1.
'@

$Kickoff = @'
TASK: MULE BOSS POOL WHEEL RUN V1

Use the local-only mule boss-pool wheel for this run.

LOCAL-ONLY BOUNDARY:
This run pattern is private/local support. Do not make it public. Do not push it. Do not treat it as doctrine. Do not rewrite active guides. Do not rewrite CURRENT_TRUTH_INDEX.

RUN SHAPE:
0 Judge sits in the center.
1-12 run around the wheel in order.
12 may feed the next start back to 1 only after 0 Judge closes the cycle.

RUN ORDER:
0. JUDGE opens.
1. ANCHOR confirms current position.
2. RUN LOCK defines mode, scope, authority, input, output, stop, and expansion rule.
3. AUTHORITY decides what can command.
4. FILE ROLE gives every mule file a job.
5. VERSION DRIFT checks old vs current.
6. NEIGHBOR FIT checks side-to-side compatibility.
7. MIRROR / OPPOSITE CHECK catches the counter-risk.
8. CONTROLLER / SPINE FIT checks the minimal working set.
9. EXPANSION decides whether bigger context is allowed.
10. OUTPUT SHAPE formats the return.
11. NO PROMOTION blocks authority changes.
12. FIT DECISION / CARRYOVER gives every object a disposition and names the next clean move.
0. JUDGE closes.

OUTPUT REQUIRED:
Create one mule return only, unless blocked.

Required top block:
STATUS:
RUN LOCK:
FILES READ:
TASK:
SCOPE:
MODE:
NOT DONE:
NEEDS USER REVIEW:

STOP:
Stop after one clean return or one expansion request.

EXPANSION REQUEST FORMAT:
MISSING FILE OR FIELD:
WHY NEEDED:
MINIMUM EXTRA SCOPE:
EXPECTED OUTPUT IF ALLOWED:
'@

Set-Content -LiteralPath $LockPath -Value $Lock -Encoding UTF8
Set-Content -LiteralPath $WheelPath -Value $Wheel -Encoding UTF8
Set-Content -LiteralPath $KickoffPath -Value $Kickoff -Encoding UTF8

$Hashes = foreach ($Path in @($LockPath,$WheelPath,$KickoffPath)) {
    $H = Get-FileHash -Algorithm SHA256 -LiteralPath $Path
    [PSCustomObject]@{
        Path = $Path
        SHA256 = $H.Hash
    }
}

$ReceiptLines = @()
$ReceiptLines += "MULE BOSS POOL WHEEL LOCAL-ONLY SAVE RECEIPT"
$ReceiptLines += "Timestamp: $Stamp"
$ReceiptLines += "Verdict: PASS / LOCAL-ONLY LOCK SAVED / NO PUBLIC PUSH"
$ReceiptLines += "Root: $Root"
$ReceiptLines += ""
$ReceiptLines += "Boundary:"
$ReceiptLines += "- No Git commit."
$ReceiptLines += "- No push."
$ReceiptLines += "- No doctrine promotion."
$ReceiptLines += "- No ACTIVE_GUIDE rewrite."
$ReceiptLines += "- No CURRENT_TRUTH_INDEX rewrite."
$ReceiptLines += "- No public export."
$ReceiptLines += "- Local-only mule support files only."
$ReceiptLines += ""
$ReceiptLines += "Files:"
foreach ($Item in $Hashes) {
    $ReceiptLines += ("- {0}" -f $Item.Path)
    $ReceiptLines += ("  SHA256: {0}" -f $Item.SHA256)
}
Set-Content -LiteralPath $ReceiptPath -Value ($ReceiptLines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "MULE BOSS POOL WHEEL LOCAL-ONLY SAVE COMPLETE"
Write-Host "Root: $Root"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Verdict: PASS / LOCAL-ONLY / NO GIT / NO PUSH"
