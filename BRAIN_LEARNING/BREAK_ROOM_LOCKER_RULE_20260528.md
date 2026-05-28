# Break Room Locker Rule — Candidate V1

Date: 2026-05-28  
Status: CANDIDATE ROOM RULE / SAVE SELECTED  
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX  
Boundary: issue-load parking and later-resume support only  

---

## 1. Rule Name

```text
BREAK ROOM LOCKER
```

Short form:

```text
Drop the load without losing it.
```

---

## 2. Purpose

The Break Room Locker is a house room for dropping the whole current issue load when the active workbench needs to be cleared.

It exists so the assistant and user can move to a bigger lane, a different room, or a rest/reset state without carrying dead chat weight and without forgetting unresolved material.

The locker is not a trash can.

The locker is not active doctrine.

The locker is not a promotion lane.

The locker is not a proof substitute.

---

## 3. Core Rule

When a task cluster becomes too heavy, too branched, too stale, or no longer the active object, move the live load into the Break Room Locker.

Each locker drop must preserve:

```text
issue name
status
why it is parked
last proof anchor
risk if forgotten
return trigger
next clean action
do-not-touch boundary
```

After the drop, the live chat should carry only:

```text
current clean anchor
active object, if any
one next move
```

---

## 4. Look-In / Alignment Rule

Before dropping a load, look inward first.

Ask:

```text
What was already going on?
Which room, rule, proof receipt, path file, or parked lane does this align with?
Is this a duplicate of an existing object?
Is this a continuation of a known branch?
Is this a new issue, or just a renamed old one?
What existing return trigger already fits?
What should not be duplicated?
```

The locker must not create a second copy of the house.

It should point back to existing rooms and proof when possible.

Short form:

```text
Look in first, then lock it.
```

---

## 5. What Belongs In The Locker

Use the locker for:

```text
parked issues
watch items
unfinished but non-blocking work
larger-lane candidates
tool friction signals
helper lessons not yet implemented
stale next-action concerns
future cleanup ideas
future registry/proof-index ideas
active-load summaries before switching lanes
```

---

## 6. What Does Not Belong In The Locker

Do not use the locker for:

```text
doctrine promotion
ACTIVE_GUIDES edits
CURRENT_TRUTH_INDEX edits
fake PASS
unverified claims
files needing immediate custody action
security blockers
dirty repo state
unknown source material
material that should be burned as trash
```

If something is unsafe, it goes to a stop/issue report, not the locker.

If something is useless and already extracted, it goes to trash/burn, not the locker.

---

## 7. Room Shape

Preferred room path:

```text
HOUSE_WORK/BREAK_ROOM_LOCKER/
```

Preferred file types:

```text
LOAD_DROP_YYYYMMDD_HHMMSS.md
LOCKER_INDEX.md
```

Optional later:

```text
RETURN_QUEUE.md
BURN_AFTER_EXTRACTION.md
```

Do not build the full system until repeated use proves the shape.

Start with one load drop and one index.

---

## 8. Required Locker Drop Fields

Each load drop should include:

```text
Current anchor:
Why this load is being dropped:
What was already going on:
Alignment map:
Active object closed or paused:
Issue list:
Closed items:
Parked items:
Watch items:
Bigger-lane candidates:
Return triggers:
Do-not-touch:
Next clean move after drop:
```

---

## 9. Think Tank + Opposition Cross-Check

Think Tank pressure:

```text
The house should carry burden instead of live chat.
```

Opposite pattern rejected:

```text
Keep every issue alive in chat until it becomes fog, bloat, or repeated confusion.
```

Clean Seed inversion:

```text
Park the load in a named room with return triggers and proof anchors.
```

Opposite pattern rejected:

```text
Throw old issues away because the user wants to move on.
```

Clean Seed inversion:

```text
Drop the load without forgetting it; burn only after useful content is extracted.
```

Opposite pattern rejected:

```text
Create a giant project-management system before proving a simple room works.
```

Clean Seed inversion:

```text
Start with one room, one index, one load drop.
```

Opposite pattern rejected:

```text
Create a locker that ignores existing rooms and duplicates the house.
```

Clean Seed inversion:

```text
Look inward first and align the drop with existing rooms, rules, proof, and return triggers.
```

---

## 10. Proof Standard

A Break Room Locker save passes only if:

```text
the room exists or is created;
the load drop file is saved;
the locker index is saved or updated;
hashes are recorded;
receipt is written;
commit/push completes if this is a Mr.Kleen save;
final repo status is clean;
boundary says no doctrine/ACTIVE_GUIDES/CURRENT_TRUTH_INDEX.
```

---

## 11. What Not To Do

Do not:

```text
treat locker items as active work;
bury safety blockers in the locker;
create ten new rooms;
build a dashboard first;
rewrite existing authority files;
use the locker as a junk drawer;
duplicate existing rooms without alignment;
carry locker content live after saving it;
```

---

## 12. Fit Decision

```text
ACCEPT WITH GUARDRAILS / SAVE SELECTED
```

Reason:

```text
The current house has enough saved rules, helper lessons, proof receipts, and parked issues that a named load-off room is needed to prevent live-chat burden from becoming the work surface.
```

---

## 13. One-Line Clean Wrap

```text
The Break Room Locker lets the house hold unresolved load cleanly so chat can stop carrying it, while the look-in check keeps each drop aligned with what the house already had going on.
```
