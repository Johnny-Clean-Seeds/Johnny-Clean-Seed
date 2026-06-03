# Project Command Center First Read-Only Inspect Command V0.5 Rule

Saved: 20260603_133747

## Verdict

COMMAND_GRAMMAR_V0_5_FIRST_READ_ONLY_INSPECT_COMMAND_RULE_SAVED

## Source design evidence

DesignReport: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_5_FIRST_READ_ONLY_INSPECT_COMMAND_DESIGN_20260603_133615\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_5_FIRST_READ_ONLY_INSPECT_COMMAND_DESIGN_20260603_133615.txt
DesignReportSHA256: 9ECE1AAAC52140C0BC917861ACC8A2805EF9E7B9C800886822091154162412C2

## Purpose

V0.5 defines the first real command shape:

inspect last task

This is the first command because inspect is lower risk than run, save, repair, or implement.

## Core rule

Inspect means read-only.

Inspect may read state and evidence.
Inspect may print an inspection card.
Inspect may not execute, write, stage, commit, push, move, delete, repair, update pointer, or mutate active files.

## Primary phrase

inspect last task

## Aliases

- inspect current task
- inspect active task
- show last task
- show current task
- what is the current task
- where are we
- what is next
- status current task

## Not aliases yet

- run last task
- save last task
- fix last task
- continue last task
- execute last task

Reason:
Those phrases imply action or mutation. V0.5 is read-only.

## Required resolution flow

1. Receive source phrase.
2. Normalize phrase.
3. Match phrase to INSPECT_ACTIVE_TASK.
4. Read active task pointer.
5. Validate pointer minimum fields.
6. Check pointer status.
7. Check stale conditions.
8. Read only referenced evidence if needed and allowed.
9. Build inspect card.
10. Return card to user.
11. Do not update pointer.

## Pointer status handling

ACTIVE:
Return inspect card.

READY_FOR_SAVE_GATE:
Return inspect card and show save gate as possible next action.

SAVED_AND_CLOSED:
Return inspect card and show next active route needed.

PAUSED_BY_USER:
Return inspect card and do not propose action unless user asks next.

BLOCKED_LOWER_ISSUE:
Return inspect card plus blocker summary.

STALE:
Do not inspect as current. Return pointer repair card.

AMBIGUOUS:
Do not guess. Return pointer repair card.

CLOSED_BUT_REFERENCED:
Return historical inspect card and ask whether to inspect history or move to next legal action.

MISSING:
Return pointer missing card.

## DoesNotProve

This save does not implement inspect last task.
This save does not create a pointer file.
This save does not read or update pointer state.
This save does not create UI.
This save does not authorize automatic execution.
This save does not authorize save gates without confirmation.
This save does not authorize Micro 004.
This save does not authorize broad Git/mutation/tool execution.

## StopLine

Do not implement inspect last task until:
1. V0.5 first read-only inspect command design is saved.
2. A guard-reviewed implementation script exists.
3. The implementation is local-only and read-only.
4. The implementation proves no pointer writes, no Git writes, no execution, and no mutation.
