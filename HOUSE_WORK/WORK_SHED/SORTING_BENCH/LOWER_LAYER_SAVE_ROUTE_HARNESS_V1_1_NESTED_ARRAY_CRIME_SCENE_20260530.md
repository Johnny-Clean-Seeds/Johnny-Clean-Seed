# Crime Scene Freeze — Lower-Layer Save Route Harness V1.1 Nested Array Failure

Date: 2026-05-30
Status: CRIME SCENE / LOWER-LAYER COLLECTION-SHAPE OVERCORRECTION / NOT DESIGN FAILURE
WorkKey: LOWER-LAYER-SAVE-ROUTE-HARNESS-ROOT-REPAIR-20260530-V1-2

## What happened

V1.1 fixed scalar collapse but overcorrected by forcing arrays both at function return and call sites.

Observed failure:

`Crime scene has unstaged files. Stop. Unstaged=[System.Object[]]`

## Meaning

`System.Object[]` is not valid file evidence. It means the helper created a nested/incorrect collection shape.

## Root relation

Same lower-layer save-route harness family:

- interpolation failure;
- Git argument binding failure;
- staged-set equality failure;
- scalar `.Count` failure;
- nested-array evidence failure.

## Repair

V1.2 normalizes at one boundary only:

- helper functions emit flat string items;
- call sites collect with `@(...)`;
- blocker paths automatically print a crime-scene readback before stopping.

## Boundary

No broad refactor, delete, move, watcher, automation, Whirlpool, doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, universal mapper, graph database, or whole-house crawl.