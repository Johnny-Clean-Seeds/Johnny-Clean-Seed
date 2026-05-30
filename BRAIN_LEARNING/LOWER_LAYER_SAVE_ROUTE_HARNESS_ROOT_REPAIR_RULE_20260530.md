# Lower-Layer Save Route Harness Root Repair Rule

Date: 2026-05-30
Status: BRAIN LEARNING / SAVE-ROUTE ROOT REPAIR / NOT DOCTRINE
WorkKey: LOWER-LAYER-SAVE-ROUTE-HARNESS-ROOT-REPAIR-20260530-V1-2-1

## Root issue

The generated save-script body was too custom, too hand-shaped, and too unproven for important house saves.

The repeated failure family:

- V1.2: unsafe PowerShell interpolation, `$Label:`.
- V1.3: unsafe wrapper parameter, `$Args`.
- V1.5: brittle staged-set equality, expecting unchanged intended files to appear in staged diff.
- Readback: partial failed run left a bounded staged footprint needing recovery handling.

## Root repair

Future save scripts must use a stable lower-layer harness pattern, not fresh ad hoc mechanics.

The harness owns:

- PowerShell string safety: use `-f` formatting or `${Name}` when punctuation follows variables.
- Reserved-variable guard: do not use `$Args`, `$Input`, `$Error`, `$Host`, `$PID`, or other automatic variable names as custom parameters.
- Git wrapper standard: `Invoke-Git -GitArgs @(...)`.
- Probe/direct split: Code Gate probe PASS is not job PASS unless the direct branch proof also closes.
- Dirty-state recovery: failed partial footprints must be classified before any next run.
- Staged-set verification: actual staged paths must be inside the allowed footprint; changed required files must be staged; unchanged already-correct files may be absent.
- Manifest/receipt order: content identity first, manifest second, receipt third, final receipt after final HEAD proof.
- Final proof: commit, push, HEAD equals origin/main, final clean status.

## Need-to-know helper evidence

- Parser/generator helpers get syntax and automatic-variable guards.
- Git/save helpers get staging, dirty-footprint, manifest, commit, and push guards.
- Code Gate lane gets probe/direct distinction.
- Upper design objects get only the frozen/resume state.

## Boundary

This is a harness rule, not a broad cleanup license. No delete, move, automation, watcher, Whirlpool, doctrine promotion, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, universal mapper, graph database, or whole-house crawl.

<!-- PATH_CLASS_50_WAVE_REPAIR:85F20B22509280E1 -->
## Path-Class 50-Wave Repair Note

Status: CONFIRMED_PATH_CLASS_REPAIR / NOT_DOCTRINE
WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
RunId: 20260530_195739

Object path: BRAIN_LEARNING/LOWER_LAYER_SAVE_ROUTE_HARNESS_ROOT_REPAIR_RULE_20260530.md
Source inputs: ROOT_LAYER
Path class: route/path issue
Repair type: ROUTE_PATH_REPAIR
Confirmed fields/classes: POSSIBLE_SKIPPED_LOWER_ROOT_REVIEW

Controlled key:
- WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
- Key tags: PATH_CLASS_REVIEW, CONFIRMED_50_PACKET, INTAKE_GATE_KEY_HASH_GUARD, ROOT_LAYER_DROP_DOWN

Hash-to-receipt join:
- Target SHA256 before repair: A7DA45CF7BFDBE909F2D93F752F728639B6D22FA3BFA3FFC51D51041AC7D675A
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
<!-- /PATH_CLASS_50_WAVE_REPAIR:85F20B22509280E1 -->
