# Alarm / Debugger Filing Cabinet Inventory

Date: 20260522_050130

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
- It uses git.exe explicitly when function collisions are possible.
- It handles execution-policy bypass cleanly.
- It avoids screen-filling code blocks by delivering .ps1 files and short launchers.
- It uses known save skeletons instead of rebuilding fragile long blocks.

Current read: mixed. Git gates worked. Filing Cabinet reuse and delivery form were weak but improved.

Weakness: long visible code blocks caused screen flicker and paste-trash markdown fence errors.

Next tightening move: use downloadable .ps1 artifacts for long scripts and only short launchers in chat.

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
