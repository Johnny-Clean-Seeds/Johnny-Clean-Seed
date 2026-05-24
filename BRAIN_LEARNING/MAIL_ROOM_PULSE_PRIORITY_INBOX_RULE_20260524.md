# Mail Room Pulse Priority Inbox Rule

Date: 2026-05-24
Status: BRAIN LEARNING / active support rule.

## Rule

The user and assistant may work at the same time through a pulse-based inbox.

The assistant should not treat every new file drop as an instant command and should not ignore drops until they become root clutter.

Use deliberate pulses:

- start of task
- after a new user message
- before file edits
- before final answer
- later heartbeat only when requested

At each pulse, check for loose root files and active MAIL_ROOM incoming mail. Classify by priority before changing the work.

Before inventing a new route, inspect whether the house already has a matching room, lane, or tool.

## Priority

- P0: stop line, safety, data loss, wrong root, secret, destructive risk.
- P1: active task mail, explicit user source, correction to current logic.
- P2: near-task evidence, read before final if it can change the report.
- P3: source ore, custody now and process later.
- P4: parking, useful but not now.
- P5: quiet archive, processed or stale.

## Root Cause Fixed Here

The active MAIL_ROOM scripts had hard-coded `C:\Users\13527\Desktop\123\MAIL_ROOM` paths even though the real mail room lives inside the house repo:

`C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz\MAIL_ROOM`

That could create a ghost inbox at the 123 root. The active scripts now resolve MAIL_ROOM from their own script location.

## Logic Guard

When a drop appears during work, say which of these applies:

- changes active task
- informs active task
- parked for later
- blocked or local-only

If it changes assumptions already used, rerun the affected reasoning.

This protects the assistant's thinking from silent drift while still allowing the user to keep dropping files.

## Modify Without Stopping

When mail changes the pattern but does not carry P0 risk, do not stop the job.

Secure it, name the change, patch the route, and keep moving.

The job stops only for P0: safety, data loss, wrong root, secret, destructive action, corruption, or direct user stop.

## Existing Structure Link

Use `EXISTING_STRUCTURE_INSPECTION_BEFORE_INVENTION_GATE_20260524.md` with this rule.

The inbox case proved the need:

- requested function: shared inbox / mail / pulse lane
- existing structure found: `MAIL_ROOM`
- failure found: hard-coded ghost root path in active tools
- correct move: repair and extend, not invent from scratch
- live correction added: pattern-changing mail modifies the route without stopping the job unless P0

## No Forever Watcher

No always-running scan.

Use one-shot tools, explicit pulses, or requested heartbeats. Doors can open for a pulse, then close.
