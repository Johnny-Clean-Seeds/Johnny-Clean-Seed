param()

# THIS CODE IS FOR LOCAL.
# Saves the Alarm / Debugger Filing Cabinet Inventory into the Mr.Kleen house.
# Expected base: main @ 85bd89c

$ErrorActionPreference = "Stop"

Remove-Item Function:\Git -ErrorAction SilentlyContinue

$Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
$ExpectedBase = "85bd89cb8a01d22a40700a3edd7abb98f78db94e"

function Run-Git {
    param([Parameter(Mandatory=$true)][string[]]$GitArgs)

    $out = & git.exe -c safe.directory="$Repo" -C "$Repo" @GitArgs 2>&1
    $code = $LASTEXITCODE

    if ($code -ne 0) {
        throw "git.exe $($GitArgs -join ' ') failed.`n$($out | Out-String)"
    }

    return @($out)
}

function Write-CleanText {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Text
    )

    $Clean = [regex]::Replace($Text, '[ \t]+(?=\r?\n)', '')
    $Clean = [regex]::Replace($Clean, '[ \t]+\z', '')
    [System.IO.File]::WriteAllText($Path, $Clean, [System.Text.UTF8Encoding]::new($false))
}

if (-not (Test-Path (Join-Path $Repo ".git"))) {
    throw "Not in Mr.Kleen repo: $Repo"
}

$Branch = (Run-Git @("branch","--show-current") | Out-String).Trim()
if ($Branch -ne "main") {
    throw "Wrong branch. Expected main; got $Branch"
}

$Head = (Run-Git @("rev-parse","HEAD") | Out-String).Trim()
if ($Head -ne $ExpectedBase) {
    throw "Wrong base. Expected $ExpectedBase but got $Head"
}

$RemoteBefore = ((Run-Git @("ls-remote","origin","refs/heads/main") | Out-String).Trim() -split "\s+")[0]
if ($RemoteBefore -ne $ExpectedBase) {
    throw "Remote mismatch before save. Local $Head / Remote $RemoteBefore"
}

$PreStatus = (Run-Git @("status","--short") | Out-String).Trim()
if ($PreStatus) {
    throw "Repo dirty before alarm/debugger inventory save. Stop.`n$PreStatus"
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$DateOnly = Get-Date -Format "yyyyMMdd"

$CabinetRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_$DateOnly.md"
$DissectionRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_INTAKE_$Stamp.md"
$TodoRel = "HOUSE_WORK/TODO/ALARM_DEBUGGER_FILING_CABINET_FOLLOWUP_TODO_$Stamp.md"
$ReceiptRel = "PROOF_HISTORY/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_SAVE_RECEIPT_$Stamp.txt"

$CabinetPath = Join-Path $Repo ($CabinetRel -replace "/","\")
$DissectionPath = Join-Path $Repo ($DissectionRel -replace "/","\")
$TodoPath = Join-Path $Repo ($TodoRel -replace "/","\")
$ReceiptPath = Join-Path $Repo ($ReceiptRel -replace "/","\")

foreach ($Path in @($CabinetPath,$DissectionPath,$TodoPath,$ReceiptPath)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $Path) | Out-Null
}

$Cabinet = @"
# Alarm / Debugger Filing Cabinet Inventory

Date: $Stamp

Status: candidate/evidence inventory.
Promotion: none.
Authority changes: none.

## Purpose

This file is the working filing cabinet for Mr.Kleen alarms, debuggers, guards, gates, checkers, rule-firing tools, proof checks, bloat/Whirlpool checks, and meta-alarm governors.

It is not a doctrine rewrite.
It is not an ACTIVE_GUIDES rewrite.
It is not a CURRENT_TRUTH_INDEX rewrite.
It is not a promotion.

The goal is to give every alarm/debugger a primary home, severity, protected damage type, firing proof standard, current status, and next tightening move.

## Better alarm definition

A better alarm/debugger:

1. Prevents real damage.
2. Fires before damage when possible.
3. Names the actual failure family.
4. Creates the correct amount of friction for the current phase.
5. Gives a clear next action.
6. Preserves proof, source, and recovery.
7. Does not stall useful growth work.
8. Leaves evidence that it worked.

A worse alarm/debugger is vague, decorative, late, too narrow, too sensitive, too broad, or blocks useful bloat before it can become growth.

## Severity model

BLOCKER means the action must stop until classified or repaired.

Use BLOCKER for authority drift, false PASS, dirty save danger, wrong base, missing proof, destructive action, source/lane corruption, unproved promotion, or protected-file rewrite risk.

WARNING means continue only with named risk and a controlled route.

Use WARNING for likely confusion, weak wording, route drift, partial proof, late alarm behavior, or task-shape problems.

WATCH means preserve and observe without freezing the work.

Use WATCH for useful bloat, rough growth material, source ore, noncritical anomalies, future Whirlpool pressure, or later-phase ideas.

DECORATIVE / NO PROOF means the alarm exists as wording but has not shown behavior.

FAILED-TO-FIRE means the alarm should have stopped a real mistake and did not.

LATE means the alarm appeared only after the user or another system caught the issue.

PARTIAL means the alarm helped but not soon enough, not cleanly enough, or not completely.

WORKING means the alarm fired at the right time, changed the action, and left usable evidence.

## Phase-weighted importance

Current phase: messy active growth.

In this phase, alarms should not all become hard blockers. Useful bloat may enter when it improves coverage, preserves source pressure, or helps future dense growth.

BLOCKER should stay reserved for house damage.

WARNING should shape the route.

WATCH should preserve useful mess.

Later phases change the weighting:

- Build phase: intake, source preservation, broad coverage, parking, targeted blockers.
- Stabilization phase: alarm/debugger proof, neighbor-fit checks, route clarity, repeated-pattern detection.
- Whirlpool/compression phase: powerplay candidates and multi-issue collapses.
- Wrap phase: concise wording, deduplication, retired noise, clean filing, and final Seed-build form.

## Filing-cabinet standard

Each alarm/debugger should eventually have:

1. Name.
2. Primary group.
3. Cross-links.
4. Severity by phase.
5. Protected damage type.
6. What proves it fired.
7. Current status.
8. Weakness.
9. Next tightening move.

Cross-links are allowed, but duplicate primary homes are not. Every alarm needs one main cabinet drawer.

## 1. Authority / Promotion Alarms

Primary job: protect who or what is allowed to become authority.

Default severity: BLOCKER.

Protected damage type: unproved material becoming rule, doctrine, active guide, current truth, or promoted system behavior.

Starting alarms:

1. Authority Drift Alarm.
2. Promotion Alarm.
3. CURRENT_TRUTH_INDEX / ACTIVE_GUIDES Rewrite Alarm.
4. Mule Output Authority Alarm.
5. Source Ore Authority Alarm.

Firing proof:

- It blocks or reroutes an attempted doctrine, guide, current truth, promotion, or authority claim.
- It names the source of authority confusion.
- It preserves the material as candidate/evidence/parked instead of authority.

Current read: mostly working.

Weakness: may still rely too much on explicit save scripts and user correction rather than pre-output detection.

Next tightening move: give every authority-touching save/handoff a required authority-status line.

## 2. Proof / PASS / Save Integrity Alarms

Primary job: protect truth claims and saved state.

Default severity: BLOCKER.

Protected damage type: saying saved, proved, clean, or PASS when repo state, receipt, hash, base, or remote does not support it.

Starting alarms:

1. False PASS Alarm.
2. Dirty Repo / Save Danger Alarm.
3. Wrong Base / Stale State Alarm.
4. Remote Match Alarm.
5. Proof Receipt Tracking Alarm.
6. Ignored Receipt / Force-Add Alarm.

Firing proof:

- It stops on wrong base, dirty repo, failed diff check, ignored receipt, failed stage, failed push, or remote mismatch.
- It prevents PASS language after failure.
- It verifies local HEAD, remote HEAD, final status, and receipt/hash evidence.

Current read: working, recently proven through several real failures and recoveries.

Weakness: ignored PROOF_HISTORY behavior can still be easy to forget if not in the save skeleton.

Next tightening move: keep proof-receipt force-add handling inside all durable save templates.

## 3. Source / Lane / Artifact Placement Alarms

Primary job: protect where material belongs.

Default severity: BLOCKER when writing files, rules, handoffs, or authority-adjacent material. WARNING in loose discussion.

Protected damage type: live instructions, source ore, side ideas, mule output, parked material, or other noise being injected into the wrong artifact.

Starting alarms:

1. Source/Lane Corruption Alarm.
2. Directive-to-Artifact Separation Alarm.
3. Clean Seed Build vs Other Noise Boundary.
4. Parked Material Boundary Alarm.
5. Artifact Scope Alarm.

Firing proof:

- It prevents live task instructions from becoming artifact content.
- It routes source ore, parked ideas, or mule output to non-authority lanes.
- It preserves current-build material without letting Other Noise bleed into active artifacts.

Current read: weakest high-priority group.

Recent failure: live user instruction was injected into artifact content and had to be corrected by the user.

Weakness: the alarm needs to fire before artifact generation, not after user correction.

Next tightening move: before every durable artifact, ask whether each instruction is a performance directive, source text, concept, rule content, or parked note.

## 4. Loss / Destructive Action Alarms

Primary job: protect source, proof, and recovery.

Default severity: BLOCKER.

Protected damage type: delete, overwrite, cleanup, compression, or Whirlpool action destroying useful source/proof/recovery.

Starting alarms:

1. Destructive Action Alarm.
2. Broad Cleanup Alarm.
3. Whirlpool Deletion Alarm.
4. Source Ore Preservation Alarm.
5. Recovery Path Alarm.

Firing proof:

- It stops delete/move/overwrite/broad cleanup without explicit scope and proof.
- It parks or maps bloat before collapse.
- It keeps receipts/source before cleanup or compression.

Current read: important but less tested recently.

Weakness: not enough live-use proof because destructive actions have mostly been blocked by policy and habit before they occur.

Next tightening move: require Whirlpool/compression tasks to state source preservation and recovery path before any collapse.

## 5. Route / Root / Next-Move Alarms

Primary job: protect task direction.

Default severity: WARNING. It becomes BLOCKER if the next move touches saves, authority, promotion, deletion, or active guides.

Protected damage type: wrong root, wrong next action, wrong scope, broad cleanup when narrow save is needed, or promotion when testing is needed.

Starting alarms:

1. Rule-Firing Confirmation Card.
2. Relevant Root Key Selector.
3. Fog Alarm.
4. Boss Selection Alarm.
5. Next-Move Scope Alarm.

Firing proof:

- It selects the smallest correct next move.
- It names which rules are firing.
- It blocks or narrows a drifted task.
- It produces a clear next route.

Current read: partial. Useful, but not always early enough.

Weakness: can become descriptive after the fact instead of decisive before action.

Next tightening move: force a one-line route/root statement before any multi-step house save or mule handoff.

## 6. Rule Quality / Wording Coverage Alarms

Primary job: protect rule shape.

Default severity: WARNING.

Protected damage type: rules that are too narrow, too vague, falsely linear, overfit to the moment, or saved too rough.

Starting alarms:

1. Broad Words / Concept-Family Coverage Alarm.
2. Vague Rule Alarm.
3. False Linearity Alarm.
4. Revise Rule Alarm.
5. Overfit-to-Current-Route Alarm.

Firing proof:

- It broadens rules to the correct concept family.
- It removes vague slogans that do not guide action.
- It stops current-route instructions from becoming permanent rules.
- It forces a second-pass revision before delivery/save.

Current read: active but still needs tightening.

Weakness: revision and filing-cabinet behavior have fired late in several recent moments.

Next tightening move: apply the Completion Revision / Second-Pass Editing Rule before every durable file or script delivery.

## 7. Growth / Bloat / Whirlpool Alarms

Primary job: protect current growth stage and future compression.

Default severity: WATCH or WARNING.

Protected damage type: deleting useful bloat too early, letting dirty bloat become authority, running cosmetic Whirlpool, or calling cleanup a powerplay when it only hides mess.

Starting alarms:

1. Useful Bloat vs Dirty Bloat Alarm.
2. Current Growth Bloat Tolerance Alarm.
3. Whirlpool Timing Alarm.
4. Powerplay Quality Debugger.
5. Dense Growth Compression Alarm.

Firing proof:

- It preserves useful bloat in the proper lane.
- It blocks dirty bloat from becoming authority.
- It delays Whirlpool when the pattern is not understood.
- It identifies true powerplays that collapse several related issues without proof/source loss.

Current read: conceptually good, not ready for broad Whirlpool.

Weakness: powerplay criteria still need live proof across repeated bloat families.

Next tightening move: when repeated pressure appears, mark it as Whirlpool candidate, not immediate cleanup.

## 8. Tool / Script / Copy Safety Alarms

Primary job: protect local execution and save/recovery scripts.

Default severity: WARNING. It becomes BLOCKER during save/recovery scripts.

Protected damage type: bad command blocks, unsigned script confusion, function collisions, ignored files, partial writes, bad recovery blocks, and repeated script-design failure.

Starting alarms:

1. Copy/Paste Safety Alarm.
2. PowerShell Function Collision Alarm.
3. Unsigned Script / Execution Policy Alarm.
4. Param-First PowerShell Alarm.
5. Git Add-F Failure Alarm.
6. Filing Cabinet / Template Reuse Alarm.

Firing proof:

- It prevents or recovers from known PowerShell/Git mistakes.
- It uses `git.exe` explicitly when function collisions are possible.
- It handles execution-policy bypass cleanly.
- It avoids screen-filling code blocks by delivering `.ps1` files and short launchers.
- It uses known save skeletons instead of rebuilding fragile long blocks.

Current read: mixed. Git gates worked. Filing Cabinet reuse and delivery form were weak but improved.

Weakness: long visible code blocks caused screen flicker and paste-trash markdown fence errors.

Next tightening move: use downloadable `.ps1` artifacts for long scripts and only short launchers in chat.

## 9. Agent / Mule / Bridge Lifecycle Alarms

Primary job: protect helper boundaries.

Default severity: WARNING. It becomes BLOCKER if helper output tries to become authority or write into protected lanes.

Protected damage type: mule, bridge, watcher, or local tool material confusing house authority or lifecycle state.

Starting alarms:

1. Mule Boundary Alarm.
2. Mule Return Authority Alarm.
3. Bridge Lifecycle Alarm.
4. Broken Bridge Parking Alarm.
5. Command Center Local-Only Boundary Alarm.
6. Parallel Worker Collision Alarm.

Firing proof:

- It prevents helper output from becoming authority.
- It keeps helper returns as evidence/candidates until saved through proof.
- It parks broken/old bridges.
- It blocks parallel-worker collision when a mule is active.
- It recognizes no-collision state when mule is not running.

Current read: working enough, but bridge lifecycle remains source-ore heavy.

Weakness: helper lanes can easily accumulate stale scripts and returns.

Next tightening move: require every mule/bridge packet to state active, parked, broken, return-only, or retired.

## 10. Meta Alarm Governors

Primary job: control the alarm system itself.

Default severity: meta-control layer.

Protected damage type: alarms becoming decorative, too painful, phase-wrong, or detached from actual firing evidence.

Starting alarms:

1. Alarm Object Purpose Rule.
2. Alarm Must Create Friction.
3. Alarm Friction Stage Match.
4. Alarm Firing Reality Rule.
5. Phase-Weighted Importance Rule.

Firing proof:

- It classifies alarms as WORKING, LATE, PARTIAL, DECORATIVE/NO PROOF, FAILED-TO-FIRE, WATCH, WARNING, or BLOCKER.
- It makes alarms create the right friction for the phase.
- It prevents every alarm from becoming a shutdown during messy growth.
- It recognizes that an alarm is purposeful even without emotional discomfort.

Current read: newly clarified and important.

Weakness: not yet fully tested across a larger alarm inventory.

Next tightening move: add firing-status fields to the final alarm/debugger cabinet.

## Highest-priority repair targets

First target:

Source / Lane / Artifact Placement Alarms.

Reason: this group failed most visibly when live instruction was injected into artifact content.

Second target:

Rule Quality / Wording Coverage Alarms.

Reason: this group controls broad wording, false linearity, revise quality, and overfit.

Third target:

Tool / Script / Copy Safety Alarms.

Reason: this group caused avoidable command/recovery friction and screen/paste issues.

Fourth target:

Route / Root / Next-Move Alarms.

Reason: these must fire earlier before multi-step work begins.

## What stays parked

The cabinet remains candidate/evidence inventory until tested and revised further.

Do not promote any alarm/debugger from this inventory alone.

Do not rewrite doctrine, ACTIVE_GUIDES, or CURRENT_TRUTH_INDEX from this file.

Do not treat this inventory as final wrap-form.

## Next allowed move

Use this cabinet as the starting object for mule deep review or internal house inspection.

The next clean work is to classify the alarms by firing proof and add missing clean-bloat candidates from house evidence.

## Blocked moves

No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No broad Whirlpool run.
No promotion.
No treating mule output or this inventory as authority.
"@

$Dissection = @"
# Alarm / Debugger Filing Cabinet Inventory Intake

Date: $Stamp

Base:

$ExpectedBase

## Source chain

This intake comes from the alarm/debugger list developed in chat after the user redirected the work away from the helix list and back to the alarms/debuggers.

Upstream local helper handoff:

C:\Users\13527\Desktop\123\MULE_WORKSHOP\ASSISTANT_TO_MULE\MULE_HANDOFF_ALARM_DEBUGGER_FILING_CABINET_DEEP_DIVE_20260522_044431.md

Known handoff SHA256:

BB28C6DE7DC25FCCD9E7519EB209D36AB4B60310DE5003ADCA03A0811992BB4D

Related full method stack already saved at current base:

- BRAIN_LEARNING/COMPLETION_REVISION_SECOND_PASS_EDITING_RULE_20260522.md
- BRAIN_LEARNING/LINKING_PAPERS_EVIDENCE_CHAIN_RULE_20260522.md
- PROOF_HISTORY/MULE_FILING_SAVE_REVISION_LINKING_METHOD_RECEIPT_20260522_045333.txt

## Revision pass

A second-pass revision was applied before this save.

Revision checks performed:

1. The object is saved as an inventory/candidate, not a rule stack.
2. Every group has one primary purpose.
3. Cross-linking is allowed but duplicate primary homes are avoided.
4. The wording is concept-level, not current-chat instruction stuffing.
5. Severity is phase-weighted.
6. Recent failures are named without becoming fake doctrine.
7. The source/evidence chain is named.
8. The next move and blocked moves are explicit.

## Final deeper attempt

The deeper pass added:

1. Firing proof standards for each group.
2. Protected damage type for each group.
3. Weakness and next tightening move for each group.
4. A sharper current-stage severity model.
5. A stronger link between Tool / Script / Copy Safety and the new `.ps1` delivery preference.
6. A clearer status that this cabinet is candidate/evidence inventory, not promotion.

## Fit verdict

PASS WITH GUARDRAILS.

This belongs in Gear Rack as an alarm/debugger cabinet inventory and in Sorting Bench as intake/dissection evidence.

It does not promote any alarm/debugger.

It does not rewrite doctrine.

It does not rewrite ACTIVE_GUIDES.

It does not rewrite CURRENT_TRUTH_INDEX.

It does not install automation.
"@

$Todo = @"
# Alarm / Debugger Filing Cabinet Followup TODO

Date: $Stamp

## Current state

Alarm/debugger filing cabinet inventory has been saved as candidate/evidence.

## Next work

1. Use the cabinet as the starting object for mule deep review when mule is available.
2. Classify each alarm/debugger as WORKING, LATE, PARTIAL, DECORATIVE/NO PROOF, FAILED-TO-FIRE, BLOCKER, WARNING, or WATCH.
3. Add missing clean-bloat candidates only when they expand real coverage.
4. Confirm primary homes and cross-links.
5. Inspect Source / Lane / Artifact Placement first.
6. Inspect Rule Quality / Wording Coverage second.
7. Inspect Tool / Script / Copy Safety third.
8. Preserve phase-weighted severity.

## Watch

Do not treat this inventory as promoted.

Do not turn WATCH alarms into blockers during messy growth unless they touch house damage.

Do not delete useful bloat from the cabinet before mule/deeper review.

Do not let the cabinet become a pile without primary homes.

## Blocked

No doctrine rewrite.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No automation install.

No broad Whirlpool run.

No promotion without separate proof route.
"@

$Receipt = @"
ALARM / DEBUGGER FILING CABINET INVENTORY SAVE RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Saved files:
$CabinetRel
$DissectionRel
$TodoRel

Upstream mule handoff:
C:\Users\13527\Desktop\123\MULE_WORKSHOP\ASSISTANT_TO_MULE\MULE_HANDOFF_ALARM_DEBUGGER_FILING_CABINET_DEEP_DIVE_20260522_044431.md

Upstream handoff SHA256:
BB28C6DE7DC25FCCD9E7519EB209D36AB4B60310DE5003ADCA03A0811992BB4D

Related method stack:
BRAIN_LEARNING/COMPLETION_REVISION_SECOND_PASS_EDITING_RULE_20260522.md
BRAIN_LEARNING/LINKING_PAPERS_EVIDENCE_CHAIN_RULE_20260522.md
PROOF_HISTORY/MULE_FILING_SAVE_REVISION_LINKING_METHOD_RECEIPT_20260522_045333.txt

Revision pass:
Completed before save.

Evidence-chain pass:
Completed before save.

Verdict:
PASS WITH GUARDRAILS / ALARM DEBUGGER FILING CABINET INVENTORY SAVED / NO PROMOTION

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No broad Whirlpool run.
No promotion.
No authority transfer.
"@

Write-CleanText -Path $CabinetPath -Text ($Cabinet + "`n")
Write-CleanText -Path $DissectionPath -Text ($Dissection + "`n")
Write-CleanText -Path $TodoPath -Text ($Todo + "`n")
Write-CleanText -Path $ReceiptPath -Text ($Receipt + "`n")

$AnchorPath = Join-Path $Repo "ACTIVE_ANCHOR.txt"
$Anchor = @"
ACTIVE ANCHOR

Current position:
main after Alarm / Debugger Filing Cabinet inventory save

Base before save:
main @ 85bd89c

Saved:
Alarm / Debugger Filing Cabinet Inventory.
Sorting Bench intake/dissection.
Followup TODO.
Proof receipt.

Verdict:
PASS WITH GUARDRAILS / ALARM DEBUGGER CABINET INVENTORY SAVED / NO PROMOTION

Next allowed move:
Use the cabinet as the starting object for mule deep review or internal house inspection. Classify alarms by firing proof and add clean-bloat candidates only where they expand real coverage.

Blocked:
Do not promote the alarm/debugger inventory.
Do not rewrite doctrine.
Do not rewrite ACTIVE_GUIDES.
Do not rewrite CURRENT_TRUTH_INDEX.
Do not install automation.
Do not run broad Whirlpool.
Do not treat this inventory as final wrap-form.
"@

Write-CleanText -Path $AnchorPath -Text ($Anchor + "`n")

$StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ExistingStatus = Get-Content -LiteralPath $StatusPath -Raw
if (-not $ExistingStatus.EndsWith("`n")) {
    $ExistingStatus += "`n"
}

$StatusAppend = @(
    ""
    "## $DateOnly — Alarm / Debugger Filing Cabinet Inventory Save"
    ""
    "Base before save: main @ 85bd89c"
    "Full base hash: $ExpectedBase"
    "State: PASS WITH GUARDRAILS / ALARM DEBUGGER CABINET INVENTORY SAVED / NO PROMOTION"
    "Saved cabinet: $CabinetRel"
    "Saved dissection: $DissectionRel"
    "Saved TODO: $TodoRel"
    "Receipt: $ReceiptRel"
    "Upstream mule handoff: C:\Users\13527\Desktop\123\MULE_WORKSHOP\ASSISTANT_TO_MULE\MULE_HANDOFF_ALARM_DEBUGGER_FILING_CABINET_DEEP_DIVE_20260522_044431.md"
    "Upstream handoff SHA256: BB28C6DE7DC25FCCD9E7519EB209D36AB4B60310DE5003ADCA03A0811992BB4D"
    "Revision pass: completed"
    "Evidence-chain pass: completed"
    "Promotion: none"
    "Authority changes: none"
    "Next allowed move: use cabinet for mule deep review or internal inspection; classify alarms by firing proof and add clean-bloat candidates only where they expand real coverage."
    "Blocked: no doctrine/guide/index rewrite, no automation install, no broad Whirlpool, no promotion, no final-wrap treatment."
) -join "`n"

Write-CleanText -Path $StatusPath -Text ($ExistingStatus + $StatusAppend + "`n")

$DiffCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --check 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Working diff --check failed.`n$($DiffCheck | Out-String)"
}

Run-Git @(
    "add","--",
    "ACTIVE_ANCHOR.txt",
    "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md",
    $CabinetRel,
    $DissectionRel,
    $TodoRel
) | Out-Null

Run-Git @("add","-f","--",$ReceiptRel) | Out-Null

$CachedCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --cached --check 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Cached diff --check failed.`n$($CachedCheck | Out-String)"
}

Run-Git @("commit","-m","Save alarm debugger filing cabinet inventory") | Out-Null

$NewHead = (Run-Git @("rev-parse","HEAD") | Out-String).Trim()

Run-Git @("push","origin","main") | Out-Null

$FinalStatus = (Run-Git @("status","--short") | Out-String).Trim()
if ($FinalStatus) {
    throw "Final status is not clean.`n$FinalStatus"
}

$RemoteHead = ((Run-Git @("ls-remote","origin","refs/heads/main") | Out-String).Trim() -split "\s+")[0]
if ($RemoteHead -ne $NewHead) {
    throw "Remote mismatch. Local $NewHead / Remote $RemoteHead"
}

$CabinetHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CabinetPath).Hash
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

Write-Host "ALARM DEBUGGER CABINET INVENTORY SAVE COMPLETE"
Write-Host "Old base: $ExpectedBase"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Status: clean"
Write-Host "Cabinet: $CabinetRel"
Write-Host "Cabinet SHA256: $CabinetHash"
Write-Host "Receipt: $ReceiptRel"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / ALARM DEBUGGER CABINET INVENTORY SAVED / NO PROMOTION"
