# Project Command Center Active Task Pointer V0.2 Rule

Saved: 20260603_132531

## Verdict

COMMAND_GRAMMAR_V0_2_ACTIVE_TASK_POINTER_RULE_SAVED

## Source design evidence

DesignReport: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_2_ACTIVE_TASK_POINTER_DESIGN_20260603_132416\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_2_ACTIVE_TASK_POINTER_DESIGN_20260603_132416.txt
DesignReportSHA256: EC61CD40B0BE1EFC20694EC9A6A6E81E6F1F75A0809FE85B5E63A9678E311C93

## Purpose

The active task pointer is the small state object that lets short operator phrases resolve safely.

It answers:

- What lane are we in?
- What object is active?
- What stage is it in?
- What proof exists?
- What proof is missing?
- What is the next legal action?
- What powers are blocked?
- What files belong to this task?
- What should last task mean?
- What should inspect last task inspect?
- What should save gate save?

## Core rule

There is one active task pointer at a time.

A command like inspect last task must resolve against the active pointer, not against transcript length or memory guesswork.

If the pointer is missing, stale, contradictory, or points to a closed task, the Command Center must pause and show a pointer repair card.

## Pointer status values

ACTIVE:
The task is open and current.

READY_FOR_SAVE_GATE:
The object has enough proof to save but save gate has not run.

SAVED_AND_CLOSED:
The object was saved, pushed, and final clean proof exists.

PAUSED_BY_USER:
The user explicitly paused.

BLOCKED_LOWER_ISSUE:
A lower-layer issue must be repaired before continuing.

STALE:
The pointer is older than the active proof state or conflicts with repo/proof evidence.

AMBIGUOUS:
The pointer cannot distinguish between multiple candidate active tasks.

CLOSED_BUT_REFERENCED:
The pointer points to a completed object and must either inspect history or move to next legal action.

## Command resolution rule

inspect last task:
Read pointer, return read-only inspection card, no mutation.

save gate:
Read pointer, confirm proof readiness, present confirmation card, then gather exact files only after confirmation.

next:
Read pointer, show proposed next legal action. If next action requires execution, Git, mutation, guard review, verifier run, or implementation, require confirmation or file-first launcher.

## DoesNotProve

This save does not implement the active task pointer.
This save does not create mutable pointer state.
This save does not authorize automatic command execution.
This save does not implement the confirmation card.
This save does not authorize Micro 004.
This save does not authorize broad Git/mutation/tool execution.

## StopLine

Do not implement command grammar execution until:
1. V0.2 active task pointer design is accepted.
2. V0.3 confirmation card design is accepted.
3. V0.4 pointer read/write rules are accepted.
4. A guard-reviewed implementation script exists.
