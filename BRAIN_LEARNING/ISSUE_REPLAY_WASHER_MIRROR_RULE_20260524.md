# Issue Replay Washer Mirror Rule

Date: 2026-05-24

Status: active behavior-repair support rule.

## Rule

When a failure, correction, miss, thin answer, bad route, or user "tug the rope" moment appears, do
not only explain the failure.

Run the same issue back through the corrected behavior until the next output visibly changes.

The washer cleans the issue. The mirror shows how the issue happened.

## Trigger

This fires when:

- the user says the answer is thin, vague, rushed, lost, or not using the rope;
- a rule existed but did not change the assistant's next move;
- the assistant understands a correction verbally but keeps the same old output shape;
- a failure report says "activation, not understanding";
- the work needs adopt, apply, test on the same problem.

## Replay Loop

Use this loop:

1. Name the issue.
2. Keep the original work visible.
3. Identify the active object.
4. Trace where the slip happened.
5. Identify what made the slip possible.
6. Adopt one small behavior fix.
7. Apply it immediately to the same issue.
8. Test whether the new output is actually different.

## Pass Standard

PASS only when the corrected output is shaped differently by the correction.

Talking about the lesson is not enough.
Summarizing the lesson is not enough.
Promising to remember is not enough.

The next move must prove the correction fired.

## Dirty Pattern

- The assistant says it understands, then answers in the same old shape.
- The assistant gives the conclusion before showing the walk when the user asked for the walk.
- The assistant names the rope but does not let the rope structure the work.
- The assistant diagnoses the issue but does not replay the same issue through the fix.

## Clean Pattern

The output shows:

- active object;
- pressure;
- slip point;
- cause;
- adopted correction;
- changed result;
- test of difference.

## Relation

This supports Rope Note Weight Visibility Gate, Rule Checker Failure Prevention, Gate Evidence /
How-Found, Same-Problem Rerun behavior, Smoke Break Focus Reset, and Final Judge.
