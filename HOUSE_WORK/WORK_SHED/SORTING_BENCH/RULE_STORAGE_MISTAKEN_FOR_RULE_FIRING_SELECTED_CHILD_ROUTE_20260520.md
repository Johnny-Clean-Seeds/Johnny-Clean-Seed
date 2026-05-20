# Selected Child Route - Rule Storage Mistaken For Rule Firing

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: selected child route / narrow root fix selected
Parent Boss: Rule Activation / Work-Order Control
Authority: route selection only; not doctrine

## Selected child

Rule storage mistaken for rule firing.

## Why selected

This child is the clearest live root under Parent Boss 01.

The system has saved many rules, but recent work showed rules do not always fire at the moment of need.

Observed event chain:

1. Full report style gate existed but did not fire until user caught it.
2. Known-path mule pickup routine existed in context but did not fire until user caught it.
3. Mule recommendation was nearly treated as immediate route authority until user corrected suit-first ordering.
4. Boss/Ghost TODO names "Rule storage mistaken for rule firing" as an activation flaw requiring confirmation that rules fire before work.
5. Assistant nearly saved only proof of the event rather than the behavior mechanism. User caught that this was the aha moment to fix it.

## Current disposition

NARROW ROOT FIX SELECTED.

## Root fix

The fix is not another broad rule stack.

The fix is a small confirmation gate before house-touching action:

Name the active route.
Name the rule/suit/order that fired.
Name the proof that it fired.
Name what is blocked.
Name whether action is allowed, blocked, parked, or read-only.

## Boundary

- no doctrine rewrite;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no broad TODO repair;
- no promotion from this selection alone.

## Next proof

Use the Rule-Firing Confirmation Card on the next nontrivial Mr.Kleen action before touching the house.
