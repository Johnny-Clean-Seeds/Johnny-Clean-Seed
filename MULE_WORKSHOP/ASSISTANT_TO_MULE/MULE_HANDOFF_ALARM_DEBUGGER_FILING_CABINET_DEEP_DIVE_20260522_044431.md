# MULE HANDOFF — ALARM / DEBUGGER FILING CABINET DEEP DIVE

## Job ID

MULEJOB-ALARM-DEBUGGER-FILING-CABINET-DEEP-DIVE-20260522

## Current Mr.Kleen base

main @ f62bd3d

Full hash:

f62bd3d9a49e0ee9604861c91e7e945cb6073ace

## Mission

Build a deep, clean, useful alarm/debugger filing-cabinet plan for Mr.Kleen.

The user and assistant are trying to sort all current alarms, debuggers, guards, gates, checkers, rule-firing tools, proof checks, bloat/Whirlpool checks, and meta-alarm governors into a structure that can actually help the house.

This is not a doctrine rewrite.

This is not promotion.

This is not a broad cleanup run.

This is a deep review, deep search, clean-bloat collection, and final integrated recommendation.

## Core idea you must understand

Not all alarms matter equally.

Alarm value changes by growth phase.

Current phase is messy active growth. Useful bloat is allowed if it improves coverage, preserves source pressure, or helps future dense growth. But hard blockers still matter for real house damage.

The alarm/debugger system needs severity and purpose:

- BLOCKER: stops real damage.
- WARNING: names risk and changes the route without freezing all work.
- WATCH: preserves useful mess, anomaly, or future source ore.
- DECORATIVE / NO PROOF: exists as words but has not proven it changes behavior.
- FAILED-TO-FIRE: should have stopped a mistake but did not.
- LATE: only appeared after the user caught the issue.
- PARTIAL: helped somewhat but not soon enough or not cleanly enough.
- WORKING: fired at the right time and changed the action.

## What “better” means

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

## Current working filing-cabinet groups

Use these as the starting structure. Critique them, improve them, merge or split if needed, but do not casually discard useful pieces.

### 1. Authority / Promotion Alarms

Protect who or what is allowed to become authority.

Starting items:

- Authority Drift Alarm
- Promotion Alarm
- CURRENT_TRUTH_INDEX / ACTIVE_GUIDES Rewrite Alarm
- Mule Output Authority Alarm
- Source Ore Authority Alarm

Default severity: BLOCKER.

### 2. Proof / PASS / Save Integrity Alarms

Protect truth claims and saved state.

Starting items:

- False PASS Alarm
- Dirty Repo / Save Danger Alarm
- Wrong Base / Stale State Alarm
- Remote Match Alarm
- Proof Receipt Tracking Alarm
- Ignored Receipt / Force-Add Alarm

Default severity: BLOCKER.

### 3. Source / Lane / Artifact Placement Alarms

Protect where material belongs.

Starting items:

- Source/Lane Corruption Alarm
- Directive-to-Artifact Separation Alarm
- Clean Seed Build vs Other Noise Boundary
- Parked Material Boundary Alarm
- Artifact Scope Alarm

Default severity: BLOCKER when writing files, rules, handoffs, or authority-adjacent material; WARNING in loose discussion.

This group is high priority because it recently failed: live user instruction was injected into artifact content.

### 4. Loss / Destructive Action Alarms

Protect source, proof, and recovery.

Starting items:

- Destructive Action Alarm
- Broad Cleanup Alarm
- Whirlpool Deletion Alarm
- Source Ore Preservation Alarm
- Recovery Path Alarm

Default severity: BLOCKER.

### 5. Route / Root / Next-Move Alarms

Protect task direction.

Starting items:

- Rule-Firing Confirmation Card
- Relevant Root Key Selector
- Fog Alarm
- Boss Selection Alarm
- Next-Move Scope Alarm

Default severity: WARNING; becomes BLOCKER if the next move touches saves, authority, promotion, deletion, or active guides.

### 6. Rule Quality / Wording Coverage Alarms

Protect rule shape.

Starting items:

- Broad Words / Concept-Family Coverage Alarm
- Vague Rule Alarm
- False Linearity Alarm
- Revise Rule Alarm
- Overfit-to-Current-Route Alarm

Default severity: WARNING.

### 7. Growth / Bloat / Whirlpool Alarms

Protect current growth stage and future compression.

Starting items:

- Useful Bloat vs Dirty Bloat Alarm
- Current Growth Bloat Tolerance Alarm
- Whirlpool Timing Alarm
- Powerplay Quality Debugger
- Dense Growth Compression Alarm

Default severity: WATCH or WARNING.

### 8. Tool / Script / Copy Safety Alarms

Protect local execution and save/recovery scripts.

Starting items:

- Copy/Paste Safety Alarm
- PowerShell Function Collision Alarm
- Unsigned Script / Execution Policy Alarm
- Param-First PowerShell Alarm
- Git Add-F Failure Alarm
- Filing Cabinet / Template Reuse Alarm

Default severity: WARNING; becomes BLOCKER during save/recovery scripts.

### 9. Agent / Mule / Bridge Lifecycle Alarms

Protect helper boundaries.

Starting items:

- Mule Boundary Alarm
- Mule Return Authority Alarm
- Bridge Lifecycle Alarm
- Broken Bridge Parking Alarm
- Command Center Local-Only Boundary Alarm
- Parallel Worker Collision Alarm

Default severity: WARNING; becomes BLOCKER if helper output tries to become authority or write into protected lanes.

### 10. Meta Alarm Governors

Control the alarm system itself.

Starting items:

- Alarm Object Purpose Rule
- Alarm Must Create Friction
- Alarm Friction Stage Match
- Alarm Firing Reality Rule
- Phase-Weighted Importance Rule

Default severity: meta-control layer.

## Important recent lessons to preserve

Use these as live evidence, not as doctrine.

1. Directive-to-Artifact Separation failed once. The assistant injected live user instruction into artifact content.
2. Fix-and-Park fired after correction. Problem lessons should be repaired and parked, not lost.
3. Proof / Git gates worked several times: dirty state, ignored PROOF_HISTORY, wrong add behavior, remote/base checks, and status checks.
4. Some alarms are not blockers in messy growth phase. Friction must match phase.
5. Useful bloat should be preserved during active growth if it improves coverage or future compression.
6. Whirlpool/powerplay should not delete bloat by default. It should collapse several related issues into dense growth only when the pattern is understood.
7. Clean Seed Build and Other Noise must stay separated by phase and fit.
8. The Filing Cabinet / Revise Rule behavior has been weak or late. This needs inspection.

## Required read-first files

Start with these orientation files:

- ACTIVE_ANCHOR.txt
- HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md

Then read the recent relevant files if present:

- BRAIN_LEARNING/DIRECTIVE_TO_ARTIFACT_SEPARATION_RULE_20260522.md
- BRAIN_LEARNING/FIX_AND_PARK_EVERY_ENCOUNTERED_PROBLEM_RULE_20260522.md
- BRAIN_LEARNING/CURRENT_GROWTH_BLOAT_TOLERANCE_POLISH_THEN_WHIRLPOOL_RULE_20260522.md
- BRAIN_LEARNING/WHIRLPOOL_POWERPLAY_DENSE_GROWTH_RULE_20260522.md
- BRAIN_LEARNING/BROAD_WORDS_CONCEPT_FAMILY_COVERAGE_RULE_20260522.md
- BRAIN_LEARNING/CLEAN_SEED_BUILD_VS_OTHER_NOISE_PHASE_BOUNDARY_RULE_20260522.md
- HOUSE_WORK/WORK_SHED/GEAR_RACK/LIVE_TESTS/THREE_BOSS_SOFT_SUIT_LIVE_USE_TEST_20260522_033519.md
- HOUSE_WORK/WORK_SHED/GEAR_RACK/LIVE_TESTS/THREE_BOSS_SOFT_SUIT_LIVE_USE_TEST_BROAD_GROWTH_RULE_PACKAGE_*.md
- HOUSE_WORK/WORK_SHED/MULE_WORKSHOP/RETURNS/FULL_SUIT_NEXT_DISPOSITION_RETURN_*/MULE_RETURN_FULL_SUIT_NEXT_DISPOSITION_REPORT.md
- PROOF_HISTORY/BROAD_GROWTH_RULE_PACKAGE_SAVE_RECEIPT_*.txt
- PROOF_HISTORY/CLEAN_SEED_BUILD_VS_OTHER_NOISE_PHASE_BOUNDARY_RECEIPT_*.txt

If a listed file is absent, note it. Do not invent it.

## Deep-dive search scope

You may search deeply inside the Mr.Kleen local brain for relevant alarm/debugger/source material.

Allowed relevant lanes:

- BRAIN_LEARNING
- HOUSE_WORK/WORK_SHED
- HOUSE_WORK/TODO
- HOUSE_WORK/INDEXES
- PROOF_HISTORY
- ACTIVE_ANCHOR.txt
- any clearly named GEAR_RACK, SORTING_BENCH, IDEA_CARDS, HANDY_BAG, TOOL, CHECKER, MULE, BRIDGE, ALARM, DEBUGGER, FOG, PROVENANCE, WHIRLPOOL, POWERPLAY, BROAD WORDS, or RULE-FIRING material

Do not broad-scan private/non-project machine folders.

Do not inspect secrets, credentials, browser caches, auth files, tokens, SSH keys, API keys, or unrelated personal data.

Do not rewrite the repo.

Do not move files.

Do not delete files.

Do not promote anything.

## Required work phases

### Phase 1 — Understand the mission

Think deeply about what this alarm/debugger list is supposed to do.

Do not only reorganize names.

Judge what the filing cabinet should achieve for the house.

Questions to answer:

1. What damage must the alarm system prevent?
2. What should be a blocker in the current growth phase?
3. What should only be a warning or watch item?
4. Which alarms are real because they have evidence?
5. Which alarms are late, partial, decorative, or failed-to-fire?
6. Which alarms overlap and need primary homes plus cross-links?
7. Which groups are missing?
8. Which group needs repair first?

### Phase 2 — Inspect the current list

Start from the ten-group structure above.

Critique it.

Improve it.

Keep the useful bloat.

Do not overcompress too soon.

For each group, determine:

- primary job
- protected damage type
- default severity
- current proof status
- weakness
- next tightening move
- likely phase where it matters most

### Phase 3 — Deep dive through house material

Search the house for existing alarms, debuggers, checkers, tools, ideas, idea bags, prior mistakes, receipts, proof lanes, mule reports, bridge lessons, and repeated failure patterns that should be represented.

Use everything relevant that the house already has.

Look especially for:

- alarm language
- debugger language
- checker patterns
- proof gates
- save gates
- source custody rules
- broad wording rules
- fog rules
- mule boundary rules
- bridge lifecycle rules
- bloat / Whirlpool / powerplay ideas
- filing cabinet / revise / template reuse rules
- repeated assistant mistake patterns

### Phase 4 — Add clean bloat

Add useful additional alarm/debugger ideas.

Do not add random noise.

Clean bloat means:

- it expands real coverage
- it names a missing failure family
- it adds useful variants
- it helps future Whirlpool compression
- it improves firing proof
- it protects source/proof/authority/recovery
- it clarifies phase-specific severity

You may use your own reasoning and any available methods/tools.

If you bring in outside/general ideas, label them as outside pattern candidates, not house authority.

### Phase 5 — Mix from start to finish

After collecting material, merge it cleanly.

Make sure the final structure is not just a pile.

The final structure should have:

1. A small purpose statement.
2. Clean severity model.
3. Phase-weighted importance model.
4. Final alarm/debugger groups.
5. Primary homes and cross-links.
6. Firing proof standards.
7. Current status labels.
8. Top repair targets.
9. What should remain watch/parked.
10. What should not be promoted yet.

### Phase 6 — Final deep sweep

Do one final hard search/review pass.

Look for missing ideas, duplicate names, wrong homes, weak definitions, vague words, false linearity, unproved promotion, and phase mismatch.

This final pass should be deliberate, not shallow.

Report what you checked and what changed after the final sweep.

## Output required

Return files to:

C:\Users\13527\Desktop\123\MULE_WORKSHOP\MULE_TO_ASSISTANT

Create these files:

1. MULE_RETURN_ALARM_DEBUGGER_FILING_CABINET_DEEP_DIVE_20260522.md

Main report.

2. MULE_RETURN_ALARM_DEBUGGER_CLEAN_BLOAT_APPENDIX_20260522.md

Extra ideas, candidate alarms, outside patterns, or house-found source material that should not clutter the main report.

3. MULE_RETURN_ALARM_DEBUGGER_FILE_READ_LIST_20260522.txt

Files read, searched, or used.

## Main report required sections

Use this structure:

1. Verdict
2. Base checked
3. Files read / searched summary
4. Mission understanding
5. Better alarm definition
6. Severity model
7. Phase-weighted importance model
8. Final alarm/debugger filing-cabinet groups
9. Group-by-group analysis
10. Alarm firing status summary
11. Missing alarms / missing debuggers
12. Clean bloat additions
13. Top repair targets
14. Proposed next single move
15. What should stay parked
16. What must not be promoted
17. Boundaries held
18. Final deep sweep notes

## Verdict options

Use one of:

- PASS / ALARM DEBUGGER CABINET CLEAR
- PASS WITH GUARDRAILS / ALARM DEBUGGER CABINET CLEAR
- PARTIAL / MORE HOUSE EVIDENCE NEEDED
- BLOCKED / CANNOT JUDGE CLEANLY
- FAIL / STRUCTURE WOULD CREATE DRIFT

## Boundaries

Do not rewrite doctrine.

Do not rewrite ACTIVE_GUIDES.

Do not rewrite CURRENT_TRUTH_INDEX.

Do not promote Soft Suit candidates.

Do not promote any alarm/debugger.

Do not install automation.

Do not write to Mr.Kleen repo.

Do not delete, move, or overwrite Mr.Kleen files.

Do not treat mule output as authority.

This is a deep review and return-report job only.

## Desired result

The assistant and user need a clean, deep, phase-aware alarm/debugger filing cabinet that can later be saved, revised, tested, or Whirlpool-compressed.

The output should be broad enough to preserve useful bloat, but organized enough that the house can use it.
