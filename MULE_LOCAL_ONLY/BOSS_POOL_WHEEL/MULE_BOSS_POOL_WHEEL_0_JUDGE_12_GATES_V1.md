# Mule Boss Pool Wheel - 12-Gate Refinery Current Shape - V2

STATUS: LOCAL SUPPORT / UPDATED GATE-RUN SHAPE / NOT ACTIVE DOCTRINE

This replaces the old 0 Judge + 12 Gates wheel for gate-run behavior.

When the user says to run an object through the gate or gates, use the Twelve-Gate Refinery shape below unless the user explicitly names a different gate system.

## Core Shape

Alpha / House Authority Shell opens before the gates.

The object then moves through gates 1-12 in order.

Middle gates act silently in normal mode.

Only Old Weight Final speaks from the 12-gate sequence.

Omega / Outer Final Judge closes the run.

## Run Order

0. Alpha / House Authority Shell opens.
1. Main Light.
2. Mirror Water.
3. Quick Signal.
4. Sweet Fit.
5. Red Blade.
6. Big Sky.
7. Stone Wall.
8. Lightning Flip.
9. Deep Fog.
10. Root Pit.
11. Road Pull.
12. Old Weight Final speaks.
13. Omega / Outer Final Judge closes.

## Alpha Locks

Alpha locks:

- object;
- source;
- mode;
- lane;
- boundary;
- needed proof level.

No object lock, no gate run.

## Normal Output

Normal mode returns only:

- Final result.
- Placement.
- Proof status.
- Next action.

No gate hallway unless debug/proof/save/repair mode requires trace.

## Fixed Verdict Set

- ACCEPT
- ACCEPT WITH GUARDRAILS
- REFINE
- SPLIT
- PARK WITH RETURN TRIGGER
- NEEDS SOURCE
- NEEDS PROOF
- BLOCK
- READY FOR NARROW LIVE USE
- READY FOR SAVE ROUTE
- NOT PROMOTED

## Boundary

This is a support tool.

It does not promote doctrine.
It does not rewrite ACTIVE_GUIDES.
It does not rewrite CURRENT_TRUTH_INDEX.
It does not replace proof.
It does not make symbolic source material command authority.

Canonical full card file:

HOUSE_WORK/GATE_RINGS/TWELVE_GATE_REFINERY_20260526/TWELVE_GATE_REFINERY_CONTROL_SHELL_AND_CARDS_20260526.md
