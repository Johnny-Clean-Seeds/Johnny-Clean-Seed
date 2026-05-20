# TODO - Suit Loadout Before Boss/Ghost Route Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: open / immediate live-use needed
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Tool-Suit-Rule Lifecycle / Mule Return Intake

## Purpose

Prove the corrected order:

Suit fit -> current worn loadout -> then Boss/Ghost TODO route.

## Trigger

This TODO is triggered now because:

- mule return was imported/read;
- mule recommended Boss/Ghost first read target;
- user corrected that next must be the suit;
- correction fits the build;
- root cleanup has been saved.

## Required next live use

Before reading/repairing `BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md`, produce a suit/loadout fit check that names:

1. active suit/supports being worn;
2. why each one is active now;
3. what is parked;
4. what cannot become king;
5. what proof would show the suit helped;
6. what stop condition prevents support-rule whirlpool;
7. whether Boss/Ghost TODO remains the downstream route.

## Pass condition

The next real work uses the named suit/loadout before the downstream route.

## Fail condition

The assistant jumps directly to Boss/Ghost TODO or another task without naming the current suit/loadout.

## Boundary

No suit promotion.

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No mule-output adoption from this TODO alone.
