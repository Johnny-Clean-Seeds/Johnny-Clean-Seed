# Warning Self-Classification and Explanation Suit Card

Saved: 20260603_134421

## Wear now

WARNING_SELF_CLASSIFICATION_AND_EXPLANATION_RULE

## Apply when

Any script or report prints WARNING_COUNT.

## Required behavior

1. Do not stop at WARNING_COUNT alone.
2. Classify every warning.
3. Explain every warning.
4. State whether each warning blocks.
5. State why.
6. State what it affects.
7. State what it does not affect.
8. State whether a second review is required.
9. Print the next legal action.
10. Treat unknown warnings as blockers.

## Required stop

STOP / WARNING_CLASSIFICATION_INCOMPLETE

Use when a report has warnings but lacks classification or explanation.

## StopLine

A warning without classification and explanation is incomplete output.
