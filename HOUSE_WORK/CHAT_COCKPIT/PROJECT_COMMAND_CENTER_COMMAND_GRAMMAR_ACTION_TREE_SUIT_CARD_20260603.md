# Project Command Center Command Grammar / Action Tree Suit Card

Saved: 20260603_131528

## Wear now

COMMAND_GRAMMAR_ACTION_TREE_TARGET

## Operating rule

When the user says a short operator phrase, do not treat it as vague chat if the active lane has enough state to resolve it.

Examples:

inspect last task
inspect last job
save gate
lock save
guard review
run verifier
next legal action

## Required behavior

1. Parse the phrase.
2. Resolve aliases and typo variants.
3. Read the active task pointer.
4. Identify current proof state.
5. Choose the action recipe.
6. Present a confirmation card before execution or script generation.
7. Keep output separate from input.
8. Use guard review before risky scripts.
9. Force-add exact ignored paths during save gates when required.
10. Stop if the lower issue is unclear.

## StopLine

Do not build a full command center before V0 lexicon, active task pointer, and confirmation card exist.
