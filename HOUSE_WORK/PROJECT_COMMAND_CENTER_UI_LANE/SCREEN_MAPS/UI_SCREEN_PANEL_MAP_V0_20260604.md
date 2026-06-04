# UI Screen And Panel Map V0

Date: 2026-06-04
Status: SCREEN MAP / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: UI-SCREEN-PANEL-MAP-V0-20260604

## Dashboard

Shows:

- current lane;
- active object;
- root status;
- Git status summary;
- latest receipt;
- next legal actions;
- blockers count.

## Command Input

Accepts short operator phrases and resolves them to action cards.

It displays parsed intent and required proof before any action can proceed.

## Active Task Panel

Shows:

- active task pointer status;
- target path;
- last completed step;
- next legal action;
- stop line;
- DoesNotProve block.

## File/Object Inspector

Shows:

- file path;
- hash;
- owner lane;
- state;
- relevant receipts;
- whether it is source, candidate, proof, parked, or active.

## Proof/Receipt Panel

Shows:

- manifest path;
- receipt path;
- file hashes;
- staged-set proof if used;
- final status proof if commit/push happened.

## Root Status Panel

Shows:

- allowed root objects;
- loose root files;
- wrong-lane residue;
- route actions;
- final root verdict.

## Blockers/Parking Panel

Shows:

- blocker class;
- fix-now/reduce/real-stop classification;
- parked items;
- return triggers;
- user-decision needs.

## Action Queue

Shows action cards in order:

1. read/inventory;
2. classify;
3. prove;
4. route/write;
5. receipt;
6. final check.

## Final Judge / Closeout Panel

Shows:

- exact verdict;
- root result;
- proof result;
- Git result;
- no-overclaim checks;
- next legal action.
