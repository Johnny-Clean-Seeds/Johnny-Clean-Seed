# Save Location Default — Local + URL Unless Special Capture — 20260522

## Status

Type: correction capture / save-routing framing.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user clarified that the assistant should generally know when project saves need both local and URL.

The user also clarified that special cases are the exception, and the user will say when a save should not go to URL.

## Founding Original / Source Root

User correction included:

- "when you save like this is it both local and url"
- "well lets make sure you do what needs it"
- "you should know pretty much when i want it local or not"
- "you cant lkow all cases but thatst when i coime in and i say this one is special dont save to url"

## Clean Translation

Durable project saves default to local repo plus URL/GitHub push.

Local operational support artifacts stay local unless explicitly routed.

The assistant must report the split.

The user can override by saying a case is special or no URL.

## Repair

This save adds a rule, updates the chat cockpit, and exports the updated CHAT drop-copy.

## Guardrail

This is not permission to push everything.

It is a classification rule:
durable project file versus local operational artifact.
