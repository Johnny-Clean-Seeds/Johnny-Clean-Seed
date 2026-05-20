# TODO Proof-Ranked Weakest-Link Selection Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Core Correction

The assistant must not "pick" a TODO by preference.

The TODO list must be sorted by proof.

The proof is in the pudding: the biggest issue / weakest link gets worked first.

## Problem

"Pick one actionable TODO" is too muddy.

It can make the assistant choose a convenient item, recent item, easy item, or interesting item instead of the item that best explains the current failure stack.

## Rule

TODO triage must use proof-ranked weakest-link selection.

The assistant must derive the next TODO route from evidence.

## Required Method

When open TODOs exist:

1. Collect current TODO evidence.
2. Group TODOs by parent boss / issue family.
3. Separate parent bosses from child tasks, symptoms, tools, tests, and stale notes.
4. Collapse duplicate or child TODOs under the larger seam.
5. Rank parent bosses by proof of impact.
6. Select the top route from the ranked evidence.
7. State why it outranks the alternatives.
8. Work or dispose that top route.

## Ranking Criteria

Rank higher when the TODO or parent boss:

- blocks current ACTIVE_ANCHOR progress;
- repeats across multiple failures;
- causes point-of-work rule non-firing;
- creates false "done" or false "pass";
- leaves proof incomplete;
- causes wrong-lane action;
- causes active TODOs to be ignored;
- blocks several child TODOs;
- carries high risk of future drift;
- is the weakest link holding the rest back.

Rank lower when the TODO is:

- already covered by a stronger parent;
- only a child symptom;
- stale;
- blocked by missing input;
- a nice-to-have;
- a tool idea with no immediate trigger;
- a future candidate not required by the current route.

## Correct Language

Do not say:

"Pick one TODO."

Say:

"Run TODO weakest-link triage and let the proof-ranked list select the top route."

Or:

"The current weakest link is X because it blocks Y and explains Z."

## User Override

The user may override with a live task.

If the user does, say the live task overrides TODO triage for this turn and route it through the correct proof lanes.

## Boundary

This rule does not install doctrine.

This rule does not rewrite active guides.

This rule does not rewrite CURRENT_TRUTH_INDEX.

This rule does not create automation.

This rule does not create a dashboard.

This rule does not create runtime.

This rule does not make TODOs authority above ACTIVE_ANCHOR.

It makes TODO selection proof-ranked instead of preference-picked.
