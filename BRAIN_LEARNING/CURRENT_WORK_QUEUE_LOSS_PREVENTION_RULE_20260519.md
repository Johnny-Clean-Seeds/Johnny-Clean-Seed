# Current Work Queue / Loss-Prevention Rule

Date: 2026-05-19.
State: active work-control rule.
Authority: operating behavior rule, not doctrine install.
Starting base: main @ d27eeef.

## Core Rule

Open work must not live only in chat.

Any active issue, critique, incoming file batch, failure, proof gap, outside-review report, user correction, or next move that must not be lost must enter the Current Work Queue.

The queue prevents loss. It does not create a save step just because output exists.

If read-only output is visible, fresh, and already points to the next safe action, take the next safe action directly instead of saving the output first.

## Job

The queue is the re-entry door.

When work is interrupted, distracted, or resumed later, check the queue before starting a new task.

The queue is not a boss, not a proof gate by itself, and not a reason to delay simple motion.

Use the queue to preserve work only when preservation beats motion.

## Save Threshold

Save or queue a work product only when at least one is true:

- loss risk is higher than motion cost,
- the user asks to lock/save,
- the output will be reused later,
- a decision changes state,
- proof/evidence would otherwise be lost,
- the next worker cannot safely resume without it.

Do not save just because:

- an output exists,
- another agent produced a report,
- the assistant wants a tidy checkpoint,
- a classification map is visible in chat,
- the queue has an old dependency saying "save first."

## Motion Rule

If the next safe action is obvious and low risk, act.

For read-only work, visible output can be enough to continue when:

- no state is being changed,
- no artifact needs preservation before the next step,
- the next step can be independently verified,
- the user did not ask to lock/save.

Clean example:

After read-only classification of ignored/PC-only files, the visible output made the next safe action clear: inspect the PowerShell tool candidates as text. The correct move was read-only tool text inspection, not saving the classification map first.

## Inspect / Execute Split

For PowerShell tools:

- inspect means read as text, hash, check risk words, and understand job;
- execute means run the script.

Inspect is allowed only when it fits the current read-only task.

Execute requires explicit decision, scope, and proof need.

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

Do not turn every loss trigger into a save trigger.

First ask:

- Will this be lost before the next action?
- Does saving it reduce risk more than it slows the active route?
- Can the next action proceed safely from visible evidence?

If the next action is safe from visible evidence, do it and leave saving for a real threshold.

## Boundary

No automation.
No runtime watcher.
No doctrine install.
No active guide rewrite.
No automatic sorting without inspection.

The queue controls attention and re-entry. It does not do the work by itself.

It also does not outrank the active next action when that action is clear, safe, and read-only.
