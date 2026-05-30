# Freshen' up Internal Orientation and Task Continuation Rule

## Status
Support rule / active workflow behavior.

## Core rule
When the user invokes `Freshen' up`, do not treat the reset as the end of the task and do not dump the whole orientation summary into chat by default.

Freshen' up is a reset/orientation ritual that should create an internal working note for the assistant, then use that note to continue the active task.

## Named sequence
Freshen' up means:

1. Clear dead chat.
2. Smoke break.
3. Walk the house.
4. Read the rules.
5. Walk the house again.
6. Read the rules again.
7. Smoke break.
8. Start or resume the next task.

## Trigger discipline
Freshen' up should mainly fire when the work is looping without yielding better results, losing the rope, blending lanes, or carrying too much dead context.

Do not use Freshen' up to prematurely stop deep thinking when the task genuinely needs a long focused pass.

## Chat behavior
The assistant may report only the short current rope and next action, but should not turn Freshen' up into a long public summary unless the user asks for the summary.

The preferred output after Freshen' up is a clean next move.

## Rope behavior
Freshen' up must preserve the rope:

- active task
- current proof state
- current blocker
- current open error
- last clean pass
- next safest command/action
- forbidden false claims

## Final judge
Freshen' up passes only if the assistant resumes the correct active lane with less fog than before.