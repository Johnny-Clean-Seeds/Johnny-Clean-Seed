# Rule-Firing Confirmation Before Action Gate

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support rule / narrow behavior mechanism
Parent Boss: Rule Activation / Work-Order Control
Authority: not doctrine, not active guide, not CURRENT_TRUTH_INDEX, not automation

## Core problem

The house can store a rule without the rule firing at the moment of need.

This is not solved by writing another broad rule.

It is solved by adding a small confirmation gate before house-touching action.

## Gate rule

Before any nontrivial Mr.Kleen house-touching action, the assistant must confirm the active rule/suit/order that fired.

Minimum confirmation:

1. Current control state.
2. Intended action.
3. Active gate that fired.
4. Why that gate applies now.
5. Blocked moves.
6. Proof needed.
7. Allowed disposition: read-only, save, park, block, or repair.

## When this gate fires

Use this gate when:

- touching Mr.Kleen files;
- writing a save script;
- reading a selected route after a correction;
- processing mule return;
- turning a correction into a fix;
- selecting TODO/parent boss route;
- any time the user says the right rule did not fire.

## When this gate should stay small

Do not recite the whole rule stack.

Do not create a dashboard.

Do not build automation.

Do not write a new support rule if the gate only needs to select an existing rule.

Use only the active 2-5 rules/tools/suit pieces that change the move.

## Confirmation card

Use this short card before action:

- State:
- Intended action:
- Fired gate:
- Why it fired:
- Blocked:
- Proof needed:
- Disposition:

If any field is unclear, stop and clarify, inspect, or park.

## Root repair claim

This is the narrow root repair for "rule storage mistaken for rule firing."

It creates an interruption point before action so the stored rule must be named as fired, not merely remembered afterward.

## Proof needed

Needs live proof on the next nontrivial Mr.Kleen action.

Pass condition:
The assistant uses the confirmation card before action and the card changes or validates the move.

Fail condition:
The assistant starts action and only explains the rule afterward.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from this save alone.
