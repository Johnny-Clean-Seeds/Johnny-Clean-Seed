# Command Grammar V0.5 First Read-Only Inspect Command Suit Card

Saved: 20260603_133747

## Wear now

COMMAND_GRAMMAR_V0_5_FIRST_READ_ONLY_INSPECT_COMMAND_TARGET

## Apply when

The user says:

inspect last task
inspect current task
inspect active task
show last task
show current task
what is the current task
where are we
what is next
status current task

## Required behavior

1. Treat inspect as read-only.
2. Resolve through the active task pointer.
3. Validate minimum pointer fields.
4. Check stale, ambiguous, missing, and closed states.
5. Return an inspect card.
6. Do not execute.
7. Do not write.
8. Do not stage Git.
9. Do not update pointer.
10. Do not infer missing state as fact.

## Required pause

PAUSE / INSPECT BLOCKED BECAUSE POINTER IS MISSING STALE AMBIGUOUS OR CONTRADICTORY

## StopLine

Do not implement inspect last task until a guard-reviewed local-only read-only implementation script exists.
