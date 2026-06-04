# UI Lane Acceptance Test Plan V0.1

Date: 2026-06-04
Status: ACCEPTANCE TEST PLAN / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: UI-LANE-ACCEPTANCE-TEST-PLAN-V0-1-20260604

## Boundary

These are manual/static acceptance checks. They do not run helper scripts, launch a UI, install packages, start watchers, or mutate pointers.

| Check | Input | Expected result | Proves | Does not prove |
|---|---|---|---|---|
| Root clean indicator | direct files under `C:\Users\13527\Desktop\123` | only allowed root entries plus `desktop.ini` | root discipline visible | repo clean |
| Command resolution | command registry rows | canonical command or blocked unknown | command grammar completeness | executable parser |
| Action-card completeness | recipe/action card files | trigger, inputs, allowed/forbidden files, proof, receipt, rollback | reviewable actions | action execution |
| Proof viewer completeness | receipt spec and sample receipt | source, manifest, hashes, verdicts, boundaries, DoesNotProve | compact review path | scientific proof |
| Save-gate exact-set behavior | staged name-status | staged files match intended set; leftovers remain visible | no broad add | correctness of content |
| No nested zip behavior | package/zip metadata | nested archive is blocked or parked | packaging guard exists | archive content safety |
| Blocker burn-down behavior | blocker table/card | fix, reduce, park, or real stop/ask | blockers handled visibly | all blockers gone |
| Final root clean check | root listing after route | `ROOT_NO_LOOSE_FILES_CHECK_PASS` | no loose root files | no untracked repo work |

## Minimum Pass

All checks must have either PASS or an explicit blocked/parked reason with a next legal action.

## Required Closeout Lines

- `READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL`
- `GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE`
- `BLOCKERS_ARE_WORK_ITEMS_NOT_STOP_EXCUSES`
- `HASH_BACKED_REVERSIBILITY_RECORDED`
- `TARGET_HELPER_NOT_RUN`
- `ROOT_NO_LOOSE_FILES_CHECK_PASS`
