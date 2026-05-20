# TODO - Rule Storage Mistaken For Rule Firing Confirmation Gate Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: open / immediate live-use needed
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Suit Loadout / Correction Root Cleanup / Mule Return Intake

## Purpose

Prove the narrow root fix for:

Rule storage mistaken for rule firing.

## Root fix being tested

Rule-Firing Confirmation Before Action Gate.

Before any nontrivial Mr.Kleen house-touching action, the assistant must confirm:

- State;
- Intended action;
- Fired gate;
- Why it fired;
- Blocked moves;
- Proof needed;
- Disposition.

## Why this is needed

Recent events showed stored rules not firing:

1. report style gate missed;
2. known-path mule pickup missed;
3. suit-first route nearly missed;
4. assistant almost saved proof only instead of fixing the behavior mechanism.

## Pass condition

On the next nontrivial Mr.Kleen action, the assistant uses the card before action and the card changes, validates, or blocks the move.

## Fail condition

The assistant performs the action and explains the rule afterward.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from one proof.
