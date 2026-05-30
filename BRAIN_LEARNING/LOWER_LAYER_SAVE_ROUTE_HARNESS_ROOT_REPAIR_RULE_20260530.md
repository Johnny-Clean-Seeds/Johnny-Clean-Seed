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