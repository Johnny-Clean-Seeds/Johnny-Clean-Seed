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

<!-- PATH_CLASS_50_WAVE_REPAIR:ABF5F5C2022AF427 -->
## Path-Class 50-Wave Repair Note

Status: CONFIRMED_PATH_CLASS_REPAIR / NOT_DOCTRINE
WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
RunId: 20260530_195739

Object path: HOUSE_WORK/WORK_SHED/SORTING_BENCH/LOWER_LAYER_SAVE_ROUTE_HARNESS_V1_1_NESTED_ARRAY_CRIME_SCENE_20260530.md
Source inputs: ROOT_LAYER
Path class: route/path issue
Repair type: ROUTE_PATH_REPAIR
Confirmed fields/classes: POSSIBLE_SKIPPED_LOWER_ROOT_REVIEW

Controlled key:
- WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
- Key tags: PATH_CLASS_REVIEW, CONFIRMED_50_PACKET, INTAKE_GATE_KEY_HASH_GUARD, ROOT_LAYER_DROP_DOWN

Hash-to-receipt join:
- Target SHA256 before repair: A70BA64702ED101BBFE646602F7711B218C09B72ACFAA46A83FABD590DAF069E
- Receipt: PROOF_HISTORY/PATH_CLASS_50_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
- Route index: HOUSE_WORK/WORK_SHED/INDEXES/PATH_CLASS_50_WAVE_REPAIR_ROUTE_INDEX_20260530.md
- What this hash proves: the bounded pre-repair target state for this packet.
- What this hash does not prove: doctrine promotion, full object cleanliness, or unrelated field closure.

Route / ledger / map:
- Ledger home: confirmed path-class packet saved with this repair.
- Map relation: Intake Gate finding and Root-Layer watch row -> path-class review -> confirmed packet -> bounded target note -> re-audit compare.
- Return path: confirmed packet and re-audit compare report.

Root-layer drop-down:
- Upper object: parked watch-row finding for this path.
- Lower object: path class, helper/tool, route/path, key/hash/intake, proof-only, or stale-currentness cause.
- Root cause tested: row was reviewed against current target content before repair.
- Separation verdict: repair only the named reviewed fields/classes; do not judge unrelated object health.
- Runtime proof needed: re-run Intake Gate and Root-Layer helpers after repair.

No-op / skip-only latch:
- NO-OP NO-COMMIT LATCH applies to the runner.
- SKIP-ONLY IS NOT REPAIR.
- Commit allowed only when RepairedTargets > 0.
- Commit message must match actual action.

Currentness and disposition:
- Currentness: CURRENT_SUPPORT_REPAIR_NOTE
- Disposition: KEEP_WITH_OBJECT_UNTIL_REAUDIT
- Next condition: re-audit and compare closure for this path and these fields/classes.

Boundary:
- confirmed packet rows only
- no doctrine
- no ACTIVE_GUIDES
- no CURRENT_TRUTH_INDEX
- no broad refactor
- no delete
- no move
- no automation
- no watcher
<!-- /PATH_CLASS_50_WAVE_REPAIR:ABF5F5C2022AF427 -->
