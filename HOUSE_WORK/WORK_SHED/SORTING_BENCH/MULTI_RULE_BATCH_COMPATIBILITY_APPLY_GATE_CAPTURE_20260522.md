# Multi-Rule Batch Compatibility Apply Gate Capture — 20260522

## Status

Type: correction capture / batch-rule installation source capture.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user caught that the assistant saved several recent rules but did not explicitly run them against each other.

The user clarified that when several rules are made or installed together, the assistant must apply them to each other and check that they obey the house.

## Founding Original / Source Root

User correction included:

- "you made the file on my desktop but failed to use the apply rule"
- "when you make seceral rules and are attempting to add them all at once"
- "you need to run them agaisnt each other"
- "ensure they obey each other and house rules"
- "this is one is important"

## Clean Translation

A multi-rule save is not just a bundle.

It needs an apply gate:
run the rules against each other, check existing house rules, identify conflicts, refine or block, then save with proof.

## Repair

This save adds the Multi-Rule Batch Compatibility Apply Gate, adds a recent-rules compatibility matrix, updates the chat cockpit, exports the current chat drop-copy, and records the local+URL split.

## Guardrail

This gate prevents rule piles from becoming internal contradictions.
