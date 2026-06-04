# Top-Down Helper Lower-Layer Issue Map

Date: 2026-06-04
Status: REVIEW MAP / NOT IMPLEMENTATION / NOT HELPER EXECUTION
WorkKey: TOP-DOWN-HELPER-LOWER-LAYER-ISSUE-MAP-20260604
Source: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/SOURCE_HANDOFFS/MULE_HANDOFF_EXACT_SET_SAVE_AND_TOP_DOWN_HELPER_REVIEW_20260604.md`

## Boundary

This map uses receipts, manifests, path maps, and compact file inventories. It does not run helper scripts, generated runners, watchers, package installs, or UI automation.

`READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL`

## What Looks Clean

| Surface | Clean result | Proof |
|---|---|---|
| Root discipline | root has no loose files after handoff routing | final root check |
| UI lane | V0.1 and Phase 2 design/proof layers are committed and pushed | commits `7e7bf47`, `3a3eb77` |
| Helper inventory | read-only inventory exact set was saved and pushed | commit `f7b0de1` |
| Root cleanup/helper rules | rules and receipts saved as exact set | commit `aab4727` |
| Row 001 static packet | exact 8-file packet saved, no extras staged | commit `2309446` |
| Target/helper boundary | helper execution remains blocked | receipts state `TARGET_HELPER_NOT_RUN` |

## Parent Boss Grouping

| Rank | Parent boss | Child issues | Current class | Next action |
|---:|---|---|---|---|
| 1 | Helper execution safety | target helper not run, scanner repair needed, runner provenance mixed | BLOCK | keep execution blocked until adjudication packets and fixtures are saved |
| 2 | Row 001 extra custody | 26 remaining extras in same folder after static packet save | FIX_NOW_BY_GATE | save adjudication packets separately; park disposable fixture until duplicate decision |
| 3 | Runner/reference residue | `_LOCAL_RUNNERS` and `_RUNNER_REFERENCE` scripts remain local/inert | PARK | no execution; review provenance only when Code Gate needs it |
| 4 | Status/index residue | `CURRENT_HOUSE_WORK_STATUS.md` still has older unstaged UI/status residue | WATCH | do not sweep into unrelated commits; fix in its own status cleanup gate |
| 5 | UI build pressure | command registry and action cards exist, but no live reader/prototype | WATCH | do not build live UI until lower helper gate is stable |

## Lower-Layer Issue Candidates

| Issue | Lower layer | Evidence | Disposition |
|---|---|---|---|
| Static packet was clean but folder was not | save custody | Row 001 exact save staged 8 files; 26 extras remain | fixed by exact save; extras mapped |
| Adjudication proof exists but is unsaved | proof custody | four Row 001 receipts remain untracked | next exact save gates |
| Disposable fixture has duplicate manifest shape | duplicate/sequence | two `SHA256_MANIFEST_ROW_001_DISPOSABLE_FIXTURE_V1.csv` paths share same hash | duplicate-review before save |
| Runner scripts are nearby but not safe to run | helper safety | `_LOCAL_RUNNERS` and `_RUNNER_REFERENCE` remain untracked/inert | park/watch |
| Status index contains residual non-current edits | status hygiene | tracked file remains modified after exact saves | separate status cleanup gate |

## Fix / Park / Watch / Block

| Item | Class | Reason | Next legal action |
|---|---|---|---|
| Authority language adjudication packet | FIX_NOW | receipt names report/table hashes | exact save gate |
| Git read-only surface adjudication packet | FIX_NOW | receipt names report/table/parser-error hashes | exact save gate |
| Unknown authority rows closeout packet | FIX_NOW | receipts name disposition/final report/table hashes | exact save gate |
| Disposable fixture packet | PARK | duplicate manifest needs decision; fixture remains disposable candidate | duplicate/sequence review, then exact save |
| `_LOCAL_RUNNERS` | PARK | script surfaces are local runner residue | provenance review only; no execution |
| UI live prototype | BLOCK | lower helper safety not stable enough | wait for helper gate proof |
| Target helper execution | BLOCK | receipt verdicts still say repair/scanner review needed | no helper run until static/adjudication gates close |
| Status index cleanup | WATCH | entangled status residue is not part of Row 001 gate | separate exact status cleanup if desired |

## Next Exact-Set Save Gates

1. Authority language adjudication packet plus receipt.
2. Git read-only surface adjudication packet plus receipt.
3. Unknown authority rows disposition/final closeout packet plus receipts.
4. Disposable fixture packet after duplicate manifest decision.
5. Runner/reference provenance packet if needed by Code Gate.
6. Status index cleanup gate if the remaining modified status file should be normalized.

## What Not To Build Yet

- Do not run `READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1`.
- Do not run generated runners.
- Do not build live UI readers.
- Do not start watchers or automation.
- Do not install packages.
- Do not whole-folder stage Row 001.

## Verdict

`TOP_DOWN_HELPER_REVIEW_MAP_BUILT`
