# Current Work Queue

Last updated: 2026-05-19.
Current base when repaired: main @ d1ee312.
Authority: Work Shed queue / attention control.

## Re-entry Readback

Current base: verify with git before action. This queue repair began at main @ d1ee312.
Active item: Inspect PowerShell tool candidates as text.
Hot guard: point-of-work readback before any PowerShell/git task.
Do not touch yet: automation, broad cleanup, force-adding PC-only files, deleting incoming material, full dashboard, full TODO system, running ignored PowerShell tools.

## Motion Before Save Rule

The queue prevents loss. It does not create a save step just because output exists.

Save only when loss risk is higher than motion cost, the user asks to lock/save, the output will be reused later, a decision changes state, proof/evidence would otherwise be lost, or the next worker cannot safely resume without it.

If read-only output is visible and the next safe action is clear, act directly.

## Active Queue

| ID | State | Priority | Parent Boss | Lane | Title | Why It Matters | Next Action | Proof Needed | Dependency | Do-Not-Do Boundary |
|---|---|---:|---|---|---|---|---|---|---|---|
| Q-20260519-006 | ACTIVE | 1 | Incoming Tool Candidate Follow-Through | Incoming File Parking / Tool Candidates | Inspect PowerShell tool candidates as text | Read-only classification made the next safe move clear. The tool candidates must be understood before any run, push, or reject decision. | Read the PowerShell tool candidates as text, hash them, check risk words, and understand each job. | Text inspection notes and hashes. | Queue/Adapt repair saved first because this repair changes the queue rule itself. | Do not execute ignored PowerShell tools. Do not force-add, delete, or promote before inspection. |
| Q-20260519-007 | NEXT | 2 | Incoming File Control | Incoming File Parking | Finish classification follow-through | PC-only files were classified enough to reveal tool candidates, but follow-through must inspect the tools next. | After text inspection, decide whether each tool is PC-only hold, remote candidate, archive/delete review, or needs more inspection. | Lane decision per tool. | Q-20260519-006. | Do not treat scripts as trusted because they exist. |
| Q-20260519-008 | PARKED | 3 | Adapt/Adopt Learning | Work Shed / Sorting Bench | Use Adapt/Adopt only when it improves next action | Outside reports and critiques are source material, not authority. | Pull only the piece that changes the active next move; park the rest. | Behavior changed at point of work. | A real report or critique affects active work. | Do not make the user care about an outside report just because it exists. |
| Q-20260519-009 | PARKED | 4 | Whole-House Review | Outside-review intake | Full-house outside-review handoff | Useful later after custody/awareness/incoming lanes mature. | Keep parked until current bridge/incoming work stabilizes. | Better current state for reviewer. | Complete active queue items first. | Do not send prematurely. |

## Done Items

| ID | Done At | Result | Proof |
|---|---|---|---|
| D-20260519-001 | main @ d27eeef | Adapt/Adopt critique learning gate saved and pushed. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-002 | main @ 14c762b | Incoming file parking lanes saved and pushed. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-003 | main @ a690faa | Brain/URL wording and Guard-Fail Stop Card saved and pushed. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-004 | main @ d1ee312 | MULE_REPORT intaken into incoming parking. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-005 | chat / read-only output | Ignored/PC-only file classification completed enough to identify PowerShell tool candidates as next safe action. | Visible read-only classification output; not a saved map. |

## Queue Rules

1. One ACTIVE item unless user explicitly switches lanes.
2. WAITING items do not become active until their input arrives.
3. NEXT items are ordered by risk/dependency, not excitement.
4. PARKED items are visible but not active.
5. DONE items remain as proof of closure.
6. Any new important issue must be inserted with state and next action.
7. Re-entry starts here before new work.
8. Queue entries do not force save-first behavior.
9. If visible read-only output points to the next safe action, take that action instead of saving the output first.

## Label Hygiene

Inspect is not execute.

Save is not act.

Queue is not authority.

Outside report is not command.

Classification is not promotion.

Visible read-only output may be enough to continue when the next step is safe and independently checkable.
