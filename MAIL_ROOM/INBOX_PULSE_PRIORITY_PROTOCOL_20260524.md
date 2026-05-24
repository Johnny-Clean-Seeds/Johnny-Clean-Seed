# Inbox Pulse Priority Protocol

Date: 2026-05-24
Status: active support protocol for MAIL_ROOM and 123 root drops.

## Problem

The user may drop files while the assistant is already working. If the assistant reacts to every drop immediately, the active task gets hijacked. If the assistant ignores drops, the root becomes storage and important mail gets lost.

The clean answer is not a forever watcher.

The clean answer is a pulse-based inbox.

## Core Rule

Work continues on the active rope unless a pulse finds mail with enough priority to interrupt.

Every pulse asks:

1. Is there loose mail?
2. Is it root drop, MAIL_ROOM mail, or local-only source?
3. What priority does it have?
4. Does it change the active task?
5. What custody path keeps it safe until the right time?
6. Does the house already have a structure for this before we invent one?

## Pulse Moments

Use these deliberate pulses:

- Start pulse: check root and MAIL_ROOM before beginning a new work run.
- User-message pulse: when the user adds context or drops a file mid-run.
- Before-edit pulse: before changing files, check whether new mail changes the edit scope.
- Before-final pulse: before closing, verify no loose root files remain.
- Heartbeat pulse: only when the user asks for a later follow-up. It wakes the thread or job to check once, then stops.

Do not run a background loop just to watch the PC.

## Priority Scale

### P0 - Stop The Line

Use when mail indicates:

- possible data loss
- destructive file action risk
- wrong active root or path
- secret/credential/private material
- corrupted package or hash mismatch
- user says "stop", "wait", "this is wrong", or equivalent

Action: pause active work, secure custody, report the issue, and do not proceed until the risk is resolved or safely parked.

### P1 - Active Task Mail

Use when mail:

- is explicitly named by the current user request
- contains source needed for the active task
- corrects the current logic
- changes the active target, boundary, or acceptance standard

Action: process now and rerun the active reasoning if it changes assumptions.

### P2 - Near Task Evidence

Use when mail:

- does not stop the task
- may improve the current route
- supplies related evidence, examples, or failure history
- should be read before final summary if time allows

Action: triage during the next pulse or before final. Do not hijack the active work unless it proves P1.

### P3 - Source Ore

Use when mail:

- is useful research
- is a transcript, person file, mule return, or idea packet
- needs deep reading later

Action: place into source custody or local-only room, write a pointer, and keep working.

### P4 - Parking

Use when mail:

- is interesting but not needed now
- duplicates an existing note
- belongs to a future pass

Action: park with return trigger.

### P5 - Quiet Archive

Use when mail:

- is stale
- is already processed
- is proof/history only
- has no active route

Action: keep findable, but do not carry it live.

## File Custody

Root of `123`:

- file means drop event
- root is not storage
- move into house lane or local-only hold
- verify root is clean before final

MAIL_ROOM:

- incoming means waiting mail
- delivered means opened mail
- processed means source custody closed
- rejected means blocked and preserved
- receipts prove handling, not authority

## Logic Integrity Guard

When new mail appears during work, the assistant must name one of these states:

- "This changes the active task."
- "This informs the active task but does not replace it."
- "This is parked for later."
- "This is blocked or local-only."

If the mail changes an assumption already used, rerun that part of the reasoning.

This prevents file drops from silently bending the work.

## Modify Without Stopping

Mail that changes the pattern should modify the route, not stop the job, unless it is P0.

Use this order:

1. secure custody;
2. classify priority;
3. name whether it changes, informs, parks, or blocks;
4. patch the current route if needed;
5. continue the job through the updated route.

This keeps the user free to drop useful corrections while the assistant keeps moving.

## Existing Structure Gate

Before creating a new inbox, workflow, gate, or tool, inspect the house for existing structures.

Verdicts:

- REUSE
- REPAIR
- EXTEND
- CREATE
- PARK

The mail-room repair used REPAIR + EXTEND:

- REPAIR: existing tools pointed at a ghost root mail-room path.
- EXTEND: the existing room needed a pulse-priority rule.

## Door Rule

Doors may open at pulse time.

Doors do not stay open forever.

No hidden watcher should keep scanning the PC. One-shot tools are allowed when explicitly invoked or when a task pulse needs them.

## Processed Mail From This Repair

`MAIL_ROOM\INCOMING_PACKAGES\notes.txt` was moved to:

`MAIL_ROOM\PROCESSED\notes_triaged_root_cause_20260524.txt`

Reason:

It was old live inbox mail, already read during this pass, and its lessons were carried into this protocol.

`C:\Users\13527\Desktop\123\insepction.txt` was moved to:

`MAIL_ROOM\PROCESSED\ROOT_DROP_insepction_triaged_20260524.txt`

Reason:

It was a live root-drop correction proving that the inbox problem is also an existing-structure inspection problem.

`C:\Users\13527\Desktop\123\notice.txt` was moved to:

`MAIL_ROOM\PROCESSED\ROOT_DROP_notice_triaged_20260524.txt`

Reason:

It clarified that pattern-changing mail should modify the live route without stopping the job unless the priority is P0.
