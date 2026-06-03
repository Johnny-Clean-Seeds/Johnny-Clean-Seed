# Command Grammar V0.2 Active Task Pointer Suit Card

Saved: 20260603_132531

## Wear now

COMMAND_GRAMMAR_V0_2_ACTIVE_TASK_POINTER_TARGET

## Apply when

The user says:

inspect last task
inspect last job
inspect current lane
save gate
lock save
next

## Required behavior

1. Resolve against the active task pointer.
2. Do not guess active object from transcript length.
3. If pointer is stale, missing, contradictory, or ambiguous, pause.
4. If the action is read-only, return an inspection card.
5. If the action requires execution, Git, mutation, or implementation, require confirmation.
6. Pointer resolves state only. It does not execute.

## Required pause

PAUSE / ACTIVE TASK POINTER MISSING STALE OR AMBIGUOUS

## StopLine

Do not implement pointer execution until V0.3 confirmation card and V0.4 pointer read/write rules exist.
