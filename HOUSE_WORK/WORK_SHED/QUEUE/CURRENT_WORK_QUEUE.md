# Current Work Queue

Last updated: 2026-05-19.
Current base when synced: main @ 3854a3b before anchor/queue state sync.
Authority: Work Shed queue / attention control.

## Re-entry Readback

Anchor sync after prior-mistake Soft Suit test: root checker-batch next move is closed/parked; Q-20260519-009 remains active unless the user selects another boss.

Current base: verify with git before action. Current closed lane position: main @ 3854a3b before anchor/queue state sync.
Active item: Q-20260519-009 - Whole-House Review / outside-review handoff.
Hot guard: point-of-work readback before any PowerShell/git task.
Do not touch yet: automation, broad cleanup, deleting incoming material, full dashboard, full TODO system, promoting checker candidates, or pulling older source-ore back without a reason.

## Motion Before Save Rule

The queue prevents loss. It does not create a save step just because output exists.

Save only when loss risk is higher than motion cost, the user asks to lock/save, the output will be reused later, a decision changes state, proof/evidence would otherwise be lost, or the next worker cannot safely resume without it.

If read-only output is visible and the next safe action is clear, act directly.

## Active Queue

| ID | State | Priority | Parent Boss | Lane | Title | Why It Matters | Next Action | Proof Needed | Dependency | Do-Not-Do Boundary |
|---|---|---:|---|---|---|---|---|---|---|---|
| Q-20260519-006 | DONE | 1 | Incoming Tool Candidate Follow-Through | Incoming File Parking / Tool Candidates | Inspect PowerShell tool candidates as text | Read-only classification made the next safe move clear. The tool candidates were read as text, hashed, risk-word scanned, and grouped. | Saved text inspection result in Incoming File Parking / 02_TOOL_CANDIDATES. | Text inspection notes and hashes. | Queue/Adapt repair saved first because this repair changed the queue rule itself. | No ignored PowerShell tools executed. No force-add, delete, or promotion. |
| Q-20260519-010 | DONE | 1 | Tool Candidate Safety | Incoming File Parking / Tool Candidates | Review/repair Daily House-Walk Digest gate candidate as text | It was the only inspected candidate with write behavior and native git calls. | Repaired script shape as text before execution or remote-brain trust. | Parser check, risk-word scan, and commit contents. | Q-20260519-006. | Script was not executed. Force-add only this related repaired script with this commit. |
| Q-20260519-011 | DONE | 2 | Incoming File Control | Incoming File Parking / Tool Candidates / Gear Rack Review | Review root CHECK_*.ps1 scripts as read-only checker batch | Root checker candidates were inspected, repaired where stale, run through the upgraded saved runner, closed as PASS AS CHECKER-CANDIDATE BATCH, then promotion-reviewed. | Closed; keep parked as tested checker-candidate batch / Gear Rack review object. | Runner pass receipt, checker batch close receipt, promotion criteria review, mule leftover custody closeout. | Q-20260519-010. | Do not promote yet. Do not install as active tools without later repeated-use proof. |
| Q-20260519-008 | PARKED | 3 | Adapt/Adopt Learning | Work Shed / Sorting Bench | Use Adapt/Adopt only when it improves next action | Outside reports and critiques are source material, not authority. | Pull only the piece that changes the active next move; park the rest. | Behavior changed at point of work. | A real report or critique affects active work. | Do not make the user care about an outside report just because it exists. |
| Q-20260519-009 | ACTIVE | 4 | Whole-House Review | Outside-review intake | Full-house outside-review handoff | Custody, incoming, and checker-candidate lanes are now closed enough to support a cleaner outside review. | Build or inspect the handoff target before sending; keep it bounded to current state and known open questions. | Handoff prompt/file names current state, boundaries, what to review, what not to change, and output lane. | Q-20260519-011 closed; mule-leftover custody lane closed. | Do not let the outside reviewer edit doctrine, promote tools, or treat source reports as authority. |

## Done Items

| ID | Done At | Result | Proof |
|---|---|---|---|
| D-20260519-001 | main @ d27eeef | Adapt/Adopt critique learning gate saved and pushed. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-002 | main @ 14c762b | Incoming file parking lanes saved and pushed. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-003 | main @ a690faa | Brain/URL wording and Guard-Fail Stop Card saved and pushed. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-004 | main @ d1ee312 | MULE_REPORT intaken into incoming parking. | Receipt and status update saved in Mr.Kleen. |
| D-20260519-005 | chat / read-only output | Ignored/PC-only file classification completed enough to identify PowerShell tool candidates as next safe action. | Visible read-only classification output; not a saved map. |
| D-20260519-006 | this whirlpool repair save | PowerShell tool candidates inspected as text and classified. | HOUSE_WORK/WORK_SHED/INCOMING_FILE_PARKING/LANES/02_TOOL_CANDIDATES/POWERSHELL_TOOL_CANDIDATE_TEXT_INSPECTION_20260519.md |
| D-20260519-007 | this whirlpool repair save | Daily House-Walk Digest gate candidate repaired as text. | HOUSE_WORK/TOOLS/Invoke-DailyHouseWalkDigestGate.ps1 parser check passed; no execution. |
| D-20260519-008 | main @ 56fb238 | Mule-leftover custody lane closed. Newer mule/work material from 2026-05-17 through now is tracked and clean; older material is tracked/clean but stale/source-ore unless pulled back with a reason. | PROOF_HISTORY/MULE_LEFTOVER_CUSTODY_CLOSEOUT_RECEIPT_20260519.txt |

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



