# Current Work Queue / Loss-Prevention Rule

Date: 2026-05-19.
State: active work-control rule.
Authority: operating behavior rule, not doctrine install.
Starting base: main @ d27eeef.

## Core Rule

Open work must not live only in chat.

Any active issue, critique, incoming file batch, failure, proof gap, outside-review report, user correction, or next move that must not be lost must enter the Current Work Queue.

## Job

The queue is the re-entry door.

When work is interrupted, distracted, or resumed later, check the queue before starting a new task.

## Queue States

Use one state per item:

- ACTIVE: current work item.
- NEXT: next clean move after active item.
- WAITING: blocked on outside input or user paste/report.
- PARKED: useful, not now.
- BLOCKED: cannot proceed until a named condition changes.
- PROOF_NEEDED: idea exists but lacks proof.
- DONE: completed and saved/pushed if required.
- REJECTED_WITH_REASON: not moving forward, reason recorded.

## Priority Sorting

Sort by:

1. custody/proof risk,
2. dirty repo or failed save risk,
3. user-stated urgency,
4. dependency order,
5. active parent boss,
6. freshness only after the above.

## Interrupt Rule

Before accepting a distraction as the new active task, decide:

- interrupt current active item,
- add new task as NEXT,
- add new task as WAITING,
- park it,
- reject it with reason.

Do not silently replace the active item.

## Re-entry Readback

On return from distraction, say:

- current Mr.Kleen base,
- active item,
- waiting items,
- next clean action,
- hot guard,
- what not to touch yet.

## Loss Triggers

Queue the item if:

- user says do not lose this,
- a report is pending,
- a failure occurred,
- a PC-only file set needs sorting,
- a rule/gate is saved but not yet used,
- a proof gap is open,
- a next move is named in a receipt/status file,
- an outside reviewer is working,
- the assistant says maybe/next/later and it matters.

## Boundary

No automation.
No runtime watcher.
No doctrine install.
No active guide rewrite.
No automatic sorting without inspection.

The queue controls attention and re-entry. It does not do the work by itself.
