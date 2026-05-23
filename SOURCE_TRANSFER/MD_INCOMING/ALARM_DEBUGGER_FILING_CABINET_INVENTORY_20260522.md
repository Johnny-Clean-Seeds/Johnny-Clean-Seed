# Alarm / Debugger Filing Cabinet Inventory

Date: 2026-05-22

Status: working inventory / filing-cabinet layout  
Scope: alarm, debugger, checker, gate, and meta-alarm organization  
Authority: not doctrine, not promotion, not an ACTIVE_GUIDES rewrite, not a CURRENT_TRUTH_INDEX rewrite

## Purpose

This file organizes the current alarm/debugger system into a usable filing cabinet.

The goal is not to make a loose list of alarms. The goal is to give each alarm/debugger a primary home, severity model, protected damage type, proof standard, current status, and next tightening target.

A clean alarm/debugger cabinet should answer:

1. What does the alarm protect?
2. What phase does it matter most in?
3. What severity should it have in the current phase?
4. What proves it fired?
5. Is it working, late, partial, decorative, or failed-to-fire?
6. What is the next repair or tightening move?

## Better Alarm / Debugger Standard

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

## Status Labels

Use these labels when judging alarm behavior:

- **WORKING** — fired at the right time and changed behavior.
- **LATE** — appeared only after the user or another check caught the issue.
- **PARTIAL** — helped somewhat but not early, cleanly, or completely enough.
- **DECORATIVE / NO PROOF** — exists as words but has not proven behavior.
- **FAILED-TO-FIRE** — should have stopped a mistake but did not.

## Severity Model

- **BLOCKER** — must stop the move until handled.
- **WARNING** — names risk and changes route, but does not freeze all work.
- **WATCH** — preserves useful mess, anomaly, or future source ore.
- **META** — governs how alarms themselves should be interpreted.

Current phase: messy active growth. This means useful bloat can enter if it improves coverage, preserves source pressure, or helps future dense growth. Hard blockers remain strict for authority, proof, destructive action, save integrity, promotion, and source/lane corruption.

## Primary Filing-Cabinet Groups

Each alarm should have one primary home. Cross-links are allowed, but duplicate primary homes create fog.

---

## 1. Authority / Promotion Alarms

These protect who or what is allowed to become authority.

Default severity: **BLOCKER**

### Includes

- Authority Drift Alarm
- Promotion Alarm
- CURRENT_TRUTH_INDEX / ACTIVE_GUIDES Rewrite Alarm
- Mule Output Authority Alarm
- Source Ore Authority Alarm

### Better Test

Does this stop unproved material from becoming rule, doctrine, active guide, current truth, or promoted system behavior?

### Current Read

Mostly working.

### Next Tightening Move

Keep this group sharp. Any move touching doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, promotion, mule authority, source-ore authority, or active behavior must pass this group before action.

---

## 2. Proof / PASS / Save Integrity Alarms

These protect truth claims and saved state.

Default severity: **BLOCKER**

### Includes

- False PASS Alarm
- Dirty Repo / Save Danger Alarm
- Wrong Base / Stale State Alarm
- Remote Match Alarm
- Proof Receipt Tracking Alarm
- Ignored Receipt / Force-Add Alarm

### Better Test

Does this stop the system from saying saved, proved, clean, or PASS when the repo, receipt, hash, base, staged state, or remote does not prove it?

### Current Read

Working, and recently proven through several failures.

### Next Tightening Move

Preserve the successful Git/save gates. Keep `git status`, base hash, remote match, receipt presence, receipt hash, and ignored receipt handling attached to all save routes.

---

## 3. Source / Lane / Artifact Placement Alarms

These protect where material belongs.

Default severity: **BLOCKER** when writing files, rules, handoffs, or authority-adjacent material. **WARNING** in loose discussion.

### Includes

- Source/Lane Corruption Alarm
- Directive-to-Artifact Separation Alarm
- Clean Seed Build vs Other Noise Boundary
- Parked Material Boundary Alarm
- Artifact Scope Alarm

### Better Test

Does this stop live instructions, source ore, side ideas, mule output, parked material, or other noise from being injected into the wrong artifact, lane, or authority surface?

### Current Read

Weakest important group. This is where the recent directive-injection failure happened.

### Next Tightening Move

Repair first. Before writing an artifact, classify whether each input is:

1. content that belongs inside the artifact,
2. instruction for how to perform the task,
3. source ore,
4. parked material,
5. proof/evidence,
6. current build material,
7. other noise.

Only durable content that belongs in the artifact should enter the artifact.

---

## 4. Loss / Destructive Action Alarms

These protect source, proof, and recovery.

Default severity: **BLOCKER**

### Includes

- Destructive Action Alarm
- Broad Cleanup Alarm
- Whirlpool Deletion Alarm
- Source Ore Preservation Alarm
- Recovery Path Alarm

### Better Test

Does this stop delete, overwrite, broad cleanup, compression, or Whirlpool from destroying useful source, proof, recovery, or future growth material?

### Current Read

Important but less tested recently.

### Next Tightening Move

Attach this group to any cleanup, Whirlpool, deletion, move, overwrite, pruning, compression, or retirement action.

---

## 5. Route / Root / Next-Move Alarms

These protect task direction.

Default severity: **WARNING**. Becomes **BLOCKER** if the next move touches saves, authority, promotion, deletion, or active guides.

### Includes

- Rule-Firing Confirmation Card
- Relevant Root Key Selector
- Fog Alarm
- Boss Selection Alarm
- Next-Move Scope Alarm

### Better Test

Does this choose the right next move before work starts?

### Current Read

Partial. Useful, but not always early enough.

### Next Tightening Move

Use this group before each nontrivial action. It should identify the active root, the rules that should fire, the fog risk, and the smallest clean move.

---

## 6. Rule Quality / Wording Coverage Alarms

These protect rule shape.

Default severity: **WARNING**

### Includes

- Broad Words / Concept-Family Coverage Alarm
- Vague Rule Alarm
- False Linearity Alarm
- Revise Rule Alarm
- Overfit-to-Current-Route Alarm

### Better Test

Does this stop rules from being too narrow, too vague, falsely linear, overfit to the moment, or saved too rough?

### Current Read

Active but still needs tightening.

### Next Tightening Move

Before saving a rule or rule-like document, check whether it is concept-level, broad enough for the failure family, precise enough to guide action, not falsely linear, and not stuffed with live task instructions.

---

## 7. Growth / Bloat / Whirlpool Alarms

These protect the current growth stage and future compression.

Default severity: **WATCH** or **WARNING**

### Includes

- Useful Bloat vs Dirty Bloat Alarm
- Current Growth Bloat Tolerance Alarm
- Whirlpool Timing Alarm
- Powerplay Quality Debugger
- Dense Growth Compression Alarm

### Better Test

Does this preserve useful bloat while stopping dirty bloat from becoming authority?

### Current Read

Conceptually good, but not ready for broad Whirlpool yet.

### Next Tightening Move

Keep bloat available as growth material. Use Whirlpool only when repeated pressure appears, and only call a move a powerplay when it collapses several related issues without damaging source, proof, authority boundary, recovery, or future movement.

---

## 8. Tool / Script / Copy Safety Alarms

These protect local execution.

Default severity: **WARNING**. Becomes **BLOCKER** during save/recovery scripts.

### Includes

- Copy/Paste Safety Alarm
- PowerShell Function Collision Alarm
- Unsigned Script / Execution Policy Alarm
- Param-First PowerShell Alarm
- Git Add-F Failure Alarm
- Filing Cabinet / Template Reuse Alarm

### Better Test

Does this prevent local command mistakes, partial writes, bad recovery blocks, function collisions, unsigned script friction, and repeated script-design failures?

### Current Read

Mixed. Git gates worked. Filing Cabinet reuse was weak.

### Next Tightening Move

Use proven save/recovery skeletons. Avoid function names that shadow commands. Force-add intentionally tracked ignored receipts. Keep command blocks clean and local-only where needed.

---

## 9. Agent / Mule / Bridge Lifecycle Alarms

These protect helper boundaries.

Default severity: **WARNING**. Becomes **BLOCKER** if helper output tries to become authority or write into protected lanes.

### Includes

- Mule Boundary Alarm
- Mule Return Authority Alarm
- Bridge Lifecycle Alarm
- Broken Bridge Parking Alarm
- Command Center Local-Only Boundary Alarm
- Parallel Worker Collision Alarm

### Better Test

Does this keep helpers useful without letting them rule the house?

### Current Read

Working enough, but bridge lifecycle remains messy and source-ore heavy.

### Next Tightening Move

Keep mule, bridge, watcher, command-center, and local-tool material scoped. Helper output is evidence or source material until separately routed, proved, and saved.

---

## 10. Meta Alarm Governors

These control the alarm system itself.

Default severity: **META**

### Includes

- Alarm Object Purpose Rule
- Alarm Must Create Friction
- Alarm Friction Stage Match
- Alarm Firing Reality Rule
- Phase-Weighted Importance Rule

### Better Test

Does this keep alarms meaningful without making current messy-growth work impossible?

### Current Read

Newly clarified, important, not yet fully tested.

### Next Tightening Move

Make alarms purposeful but phase-aware. Not every alarm should block current growth, but every alarm should have a reason, severity, action implication, and proof standard.

---

## Top Repair Targets

### 1. Source / Lane / Artifact Placement Alarms

Highest priority because this group failed most visibly when a live instruction was injected into artifact content.

### 2. Rule Quality / Wording Coverage Alarms

Second priority because it controls broad wording, false linearity, revise quality, and overfit.

### 3. Tool / Script / Copy Safety Alarms

Third priority because it causes avoidable command/recovery friction.

## Final Cabinet Shape

The filing-cabinet layout should remain:

1. Authority / Promotion
2. Proof / PASS / Save Integrity
3. Source / Lane / Artifact Placement
4. Loss / Destructive Action
5. Route / Root / Next-Move
6. Rule Quality / Wording Coverage
7. Growth / Bloat / Whirlpool
8. Tool / Script / Copy Safety
9. Agent / Mule / Bridge Lifecycle
10. Meta Alarm Governors

This structure preserves useful bloat while giving each alarm a primary home, protected damage type, severity model, proof standard, and next repair direction.

## Boundaries

This inventory is not doctrine.

This inventory does not promote alarms/debuggers.

This inventory does not rewrite ACTIVE_GUIDES.

This inventory does not rewrite CURRENT_TRUTH_INDEX.

This inventory is a working filing cabinet for inspection, mule review, later save, later revision, and future Whirlpool compression.
