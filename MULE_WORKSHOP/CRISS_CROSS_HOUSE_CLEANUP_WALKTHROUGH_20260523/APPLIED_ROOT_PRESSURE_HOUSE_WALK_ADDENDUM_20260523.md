# Applied Root-Pressure House-Walk Addendum

Status: APPLIED HOUSE-WALK LENS / NOT DOCTRINE  
Date: 2026-05-23  
Basis: criss-cross walkthrough return + oldstuff fit review  
Purpose: wear the shoe where it fits. Apply the useful root-pressure/dependency lens to the actual house walk.

## Applied Rule Of Use

This is not “source ore only” anymore.

The source was reviewed. Useful parts fit. The good parts are now applied to the criss-cross house walk.

Still blocked:

- no doctrine promotion;
- no ACTIVE_GUIDES rewrite;
- no CURRENT_TRUTH_INDEX edit;
- no delete;
- no Work Shed restoration;
- no mule output adopted as authority.

## 1. Root Pressure Map Applied

### Pressure 1 — Path / Home Drift

Finding:
Old home path references remain in `README.md`, `CURRENT_TRUTH_INDEX.txt`, `AGENTS.md`, and teleporter pointers.

Why it matters:
Wrong home references can cause future scripts, mules, or chat pickup packets to walk the wrong house.

Decision:
FIX-NEXT, but only by a same-shape path-reference review. Do not blindly replace all old paths.

Proof needed:
List every old-home reference, classify whether it is stale, historical, pointer, or still needed, then patch only stale active references.

### Pressure 2 — Root Pickup Outside Active Pickup Lane

Finding:
Root pickup work order exists outside active-home pickup lane.

Why it matters:
Pickup custody can split. A worker may read the wrong handoff or miss the active pointer.

Decision:
PARTLY FIXED. Custody pointer was added. Needs follow-up check, not another move.

Proof needed:
Confirm the active pickup pointer points to the root work order and that no duplicate active work order is competing with it.

### Pressure 3 — Reserved Variable Path Bug

Finding:
Prior receipt shows `$Home` reserved-variable path bug.

Why it matters:
PowerShell may resolve to `C:\Users\13527` instead of active project home. This can create files in the wrong place.

Decision:
ALREADY LEARNED / MUST APPLY IN FUTURE COMMANDS.

Proof needed:
Future scripts must avoid `$Home`, `$PID`, `$Host`, `$Error`, and similar automatic variables. Use names like `$RepoPath`, `$ActiveHomePath`, `$OutputLanePath`.

### Pressure 4 — Work Shed Reference Mismatch

Finding:
Work Shed references remain while active `HOUSE_WORK\WORK_SHED` is absent.

Why it matters:
A referenced room that is missing can cause fake routing, bad handoffs, or confused scans.

Decision:
REVIEW-NEXT. Do not restore Work Shed just because references exist.

Proof needed:
List every Work Shed reference. Classify as historical, stale pointer, intended missing room, or needs replacement path.

### Pressure 5 — Local-Only / Private-Like Tracked Paths

Finding:
122 tracked paths match local-only/private/shed-like naming.

Why it matters:
Some may be harmless names. Some may be misplaced local-only material. Name match alone is not proof.

Decision:
ROLE REVIEW, not delete, not untrack.

Proof needed:
Create a role list: public-safe, house-internal, local-only by content, private-like by name only, needs rename, needs move, blocked.

### Pressure 6 — Root Helper / Support Files

Finding:
Root tracked helper/support files need role review before movement.

Why it matters:
Root clutter can be bad, but moving helper files without knowing role can break active routes.

Decision:
REVIEW BEFORE MOVEMENT.

Proof needed:
For each root helper: role, caller, active/stale status, safe home, movement risk.


Finding:

Why it matters:
Useful material can inform the house walk but cannot become authority without proof.

Decision:
KEEP AS SUPPORT MATERIAL.

Proof needed:
Any use must cite exact fit: what idea, what house pressure, what proof need, what boundary.

## 2. Dependency Ladder Now Applied

Order for next house work:

1. Path/home stale-reference review.
2. Pickup custody duplicate/competition check.
3. Work Shed reference mismatch review.
4. Local-only/private-like tracked path role review.
5. Root helper/support file role review.

Reason:
Path and custody errors can poison every later move. Local-only review and helper movement come later because they require clean route knowledge first.

## 3. What Got Brought In

Accepted from oldstuff/source review:

- root-pressure thinking;
- dependency ladder;
- branch → downstream effect → decision → proof chain;
- idea/resource triage;
- reject bad names but keep useful function.

Rejected:

- running oldstuff.ps1;
- treating oldstuff as a rule;
- retroactively changing the mule required file count;
- authority-heavy names;
- fake PASS from patch output.

## 4. Moving Forward

Before the next criss-cross repair, use this applied addendum as the working map.

Do not just list anomalies.

For each action, prove:

`finding -> branch -> downstream risk -> decision -> proof`

Verdict: PASS WITH GUARDRAILS / GOOD IDEAS APPLIED TO HOUSE WALK
