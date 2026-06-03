# Command Grammar V0.1 Lexicon / Alias / Input Flow Suit Card

Saved: 20260603_132134

## Wear now

COMMAND_GRAMMAR_V0_1_DESIGN_TARGET

## Apply when

The user says short operator phrases like:

inspect last task
inspect last job
save gate
lock save
guard review
run verifier
next
pause
stop

## Required behavior

1. Parse the phrase.
2. Resolve aliases and typo variants.
3. Check active task pointer.
4. Identify proof state.
5. Choose read-only or confirmation-required mode.
6. Never treat output labels as commands.
7. Never treat prompt text as command input.
8. Prefer one launcher command or file-first scripts.
9. Require confirmation before execution, Git, mutation, or script generation.
10. Stop if the lower issue is unclear.

## StopLine

Do not jump from this design directly to a full UI or autonomous action layer.
