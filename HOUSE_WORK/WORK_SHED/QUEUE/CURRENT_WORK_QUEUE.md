# Current Work Queue

Last updated: 2026-05-19.
Current base when created: main @ d27eeef.
Authority: Work Shed queue / attention control.

## Re-entry Readback

Current base: main @ d27eeef when this queue was created.
Active item: Current Work Queue / Loss-Prevention Board creation.
Hot guard: point-of-work readback before any PowerShell/git task.
Do not touch yet: automation, broad cleanup, force-adding PC-only files, deleting incoming material, full dashboard, full TODO system.

## Active Queue

| ID | State | Priority | Parent Boss | Lane | Title | Why It Matters | Next Action | Proof Needed | Dependency | Do-Not-Do Boundary |
|---|---|---:|---|---|---|---|---|---|---|---|
| Q-20260519-001 | ACTIVE | 1 | Loss Prevention / Re-entry Control | Work Shed / Queue | Create Current Work Queue / Loss-Prevention Board | Prevent open work from being buried during distractions. | Save/push this queue, then mark complete in next status update if needed. | Commit/push + clean status. | None. | Do not build automation or giant TODO system. |
| Q-20260519-002 | WAITING | 2 | Adapt/Adopt Learning | Outside-review intake | Outside reviewer deep-scan critique report | Must be judged with Adapt/Adopt gate, not accepted blindly. | When report arrives, intake through Adapt/Adopt template. | Compare report against house proof/current status. | Waiting for user paste. | Do not let newest report become authority. |
| Q-20260519-003 | NEXT | 3 | Incoming File Control | Incoming File Parking | Inventory PC-only incoming files | Physical PC-only files exist outside remote brain tracking; they need classification. | List and classify files into incoming parking lanes. | Inventory + lane classification. | Queue saved first. | Do not delete, force-add, or promote before inspection. |
| Q-20260519-004 | NEXT | 4 | Adapt/Adopt Learning | Work Shed / Sorting Bench | Use Adapt/Adopt gate on next report or inventory | The gate is saved but must be used at point of work. | Apply template to the next outside report or incoming-file inventory. | Show adopt/adapt/park/reject/test sorting. | Input item available. | Do not create a rule swamp. |
| Q-20260519-005 | PARKED | 5 | Whole-House Review | Outside-review intake | Full-house outside-review handoff | Useful later after custody/awareness/incoming lanes mature. | Keep parked until current bridge/incoming work stabilizes. | Better current state for reviewer. | Complete active queue items first. | Do not send prematurely. |

## Done Items

| ID | Done At | Result | Proof |
|---|---|---|---|
| D-20260519-001 | main @ d27eeef | Adapt/Adopt critique learning gate saved and pushed. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-002 | main @ 14c762b | Incoming file parking lanes saved and pushed. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-003 | main @ a690faa | Brain/URL wording and Guard-Fail Stop Card saved and pushed. | Receipt and status update saved in Mr.Kleen. |

## Queue Rules

1. One ACTIVE item unless user explicitly switches lanes.
2. WAITING items do not become active until their input arrives.
3. NEXT items are ordered by risk/dependency, not excitement.
4. PARKED items are visible but not active.
5. DONE items remain as proof of closure.
6. Any new important issue must be inserted with state and next action.
7. Re-entry starts here before new work.
