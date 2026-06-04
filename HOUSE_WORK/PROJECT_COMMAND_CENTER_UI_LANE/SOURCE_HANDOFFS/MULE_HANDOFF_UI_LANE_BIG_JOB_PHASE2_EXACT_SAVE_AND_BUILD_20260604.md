# MULE HANDOFF — UI LANE BIG JOB PHASE 2 / EXACT SAVE + BUILD

Date: 2026-06-04
Status: SINGLE START FILE / BIG BUT BOUNDED / EXACT-SET SAVE FIRST / PHASE 2 BUILD / REVIEW AFTER COMPLETION
WorkKey: MULE-HANDOFF-UI-LANE-PHASE2-EXACT-SAVE-AND-BUILD-20260604

## Start here

This is the next big mule job.

It must work like the last successful big job:

- real build work;
- blocker burn-down;
- hash-backed reversibility;
- root clean discipline;
- proof/manifest/receipt;
- no read-only-only closeout.

But this one also has a data-control rule.

The last run used meaningful data. That is acceptable because it produced real project output, but this job must avoid wasting data on repeated rereads, broad crawling, and long summaries.

## Prime order

Do two main things:

1. Lock/save the exact UI-lane work from the last job.
2. Build UI Lane Phase 2 as much as safely possible.

Required high-level chain:

`LOAD_PRIOR_UI_JOB_PROOF -> EXACT_SET_SAVE_GATE -> PHASE2_UI_BUILD -> BLOCKER_BURNDOWN -> UPDATE_PATHS_STATUS_PROOF -> FINAL_ROOT_CHECK -> COMMIT_PUSH_OR_EXACT_BLOCKER`

## Data-control rule

This is big but bounded.

Do not re-read everything.

Do not repeat the same summaries.

Do not crawl unrelated house areas.

Use hashes, manifests, receipts, and path maps as orientation.

Read full files only when needed to modify, verify, or connect them.

Use this rule:

`READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL`

If the work starts consuming too much context because the lane is too broad, reduce scope to the most likely UI-lane direction and continue.

Allowed reduction:

`BROAD_UI_SCOPE_REDUCED_TO_NEXT_USABLE_LAYER`

Do not use data cost as an excuse to stop if the next action is clear.

## Clean checkpoint from prior run

Prior mule reported:

`UI_LANE_BIG_JOB_COMPLETE_WITH_BLOCKER_BURNDOWN`

Core results:

- UI lane built.
- Root handoff routed into repo.
- Root clean check passed.
- Missing mule-root no-loose-files rule added:
  - `BRAIN_LEARNING/MULE_ROOT_NO_LOOSE_FILES_RULE_20260604.md`
  - SHA256: `F531FEFE6199ABE7370A81CEB9867458C199C20D25D7619F97609DCAF915EB83`
- Manifest SHA256:
  - `2D71E6C734775D1B2C08A2D12396ABBAD57B4CAAD7FF12376C4296227121571D`
- Rollback manifest SHA256:
  - `48D408F6845545B9A77393B766216ED6D6BC1E42108C4341CE0D4FB19C0BC0E2`
- Receipt SHA256:
  - `ED92FF1D35C166D535810A40C9893603B8999C08D372FC34490EE400A3ABBFE1`
- Status index after update SHA256:
  - `CB5A047D60C959D2C07C15DB45756B518E4BBDCB90947D3380F39D43DF73B63A`
- Git status:
  - `NO_COMMIT_NO_PUSH_WITH_REASON`
  - Reason: pre-existing modified/untracked work outside the UI lane.
  - `HEAD == origin/main` still true at `50bf9f4404fc49b569472b20639785d12923aedf`.

## Root discipline

Current root must remain clean by allowed-root set.

Allowed root items:

- `_CHAT_DROPS`
- `_LOCAL_CUSTODY_AND_RECEIPTS`
- `_MEDIA_ASSETS`
- `_MISC_DRAWER`
- `_SOURCE_RESEARCH_NOTES`
- `_TOOLS_AND_SCRIPTS`
- `_TRANSCRIPT_CUSTODY`
- `COMMAND_CENTER`
- `Jxhnny_Kl33N_Seedz`
- `desktop.ini`

If this job creates or receives a loose root file, route it before continuing.

Final root must report:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

## Active rules

Use these rules:

`ROOT_LOOSE_FILE_WRONG_LANE_UNTIL_PROVEN_ALLOWED`

`GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE`

`BLOCKERS_ARE_WORK_ITEMS_NOT_STOP_EXCUSES`

`HASH_BACKED_REVERSIBILITY_RECORDED`

`PACKAGING_LINK_CLUSTER_RULE_APPLIED / NO_NESTED_ZIPS`

`READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL`

## Real stop/ask rules

Do not stop for normal internal blockers.

Fix, route, reduce, or isolate safe blockers.

Stop/ask only for:

- destructive overwrite risk with no backup/custody path;
- source ownership unclear;
- user-original files mixed with generated residue;
- package install/network/live automation/watcher needed;
- target/helper execution required;
- credential/private data uncertainty;
- two equally plausible lanes with no clear winner;
- commit/push would require staging unrelated unknown material.

Use:

`REAL_BLOCKER_STOP_AND_ASK`

## Phase 0 — orient from proof, not broad crawl

Start in:

`C:\Users\13527\Desktop\123`

Repo:

`C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz`

Find the prior UI-lane report/receipt/manifest/path map in:

`HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/`

and/or its `RECEIPTS`, `REPORTS`, `PATH_MAPS`, and `SOURCE_HANDOFFS` subfolders.

Use the prior manifest as the source of the exact file set.

Do not rely on chat memory alone.

## Phase 1 — exact-set save gate for prior UI lane work

This is the first hard job.

The previous UI build was built/proved but not committed.

Commit only the exact intended prior UI lane set and its required proof/status files.

Do not stage unrelated dirty/untracked work.

Expected relevant areas include:

- `BRAIN_LEARNING/MULE_ROOT_NO_LOOSE_FILES_RULE_20260604.md`
- `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/**`
- `HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md`
- relevant `PROOF_HISTORY/**UI_LANE**` or prior UI job receipt/manifest files if created there.

But do not trust this list blindly. Use the prior manifest/receipt to identify the actual exact set.

Required exact-save steps:

1. Capture old HEAD.
2. Capture `origin/main`.
3. Run `git status --short`.
4. Identify exact UI-lane file set from prior receipt/manifest.
5. Hash each file before staging.
6. Stage exact files only.
7. Show staged set.
8. Verify staged set contains no unrelated files.
9. Commit with a clear message.
10. Push.
11. Verify new HEAD.
12. Verify `HEAD == origin/main`.
13. Verify final root clean.
14. Report any unrelated dirty/untracked work left outside commit.

Suggested commit message:

`Save project command center UI lane`

If exact-set commit is blocked because unrelated changes are entangled in a file that must be committed, reduce if safe or stop with:

`EXACT_SET_SAVE_BLOCKED_BY_ENTANGLED_DIRTY_FILE`

If commit/push succeeds:

`UI_LANE_EXACT_SET_SAVE_COMMIT_AND_PUSH_PROVED`

## Phase 2 — UI Lane Phase 2 build

After the exact save gate is handled, build Phase 2.

Do not build live automation.

Do not install packages.

Do not run watchers.

Do not execute target/helper.

Build more durable UI lane project material.

## Phase 2 hard deliverable floor

A valid Phase 2 must produce at least these artifacts unless a real blocker prevents them:

1. Command registry V0.2.
2. Action recipe library V0.2.
3. Dashboard state model V0.2.
4. File/object inspector spec V0.2.
5. Proof/receipt viewer spec V0.2.
6. Root-residue route action card set V0.2.
7. Save-gate action card set V0.2.
8. Blocker burn-down action card set V0.2.
9. Data budget protocol for big jobs V0.1.
10. UI lane acceptance test plan V0.1.
11. UI lane Phase 2 receipt/manifest/rollback manifest.
12. Status/index/path-map updates.
13. Final root clean check.
14. Commit/push proof or exact no-commit blocker.

## Suggested Phase 2 placement

Use the existing UI lane created by the previous job.

Likely root:

`HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/`

Suggested paths:

- `COMMAND_GRAMMAR/UI_COMMAND_REGISTRY_V0_2_20260604.md`
- `ACTION_CARDS/UI_ACTION_RECIPE_LIBRARY_V0_2_20260604.md`
- `SCREEN_MAPS/UI_DASHBOARD_STATE_MODEL_V0_2_20260604.md`
- `SCREEN_MAPS/UI_FILE_OBJECT_INSPECTOR_SPEC_V0_2_20260604.md`
- `SCREEN_MAPS/UI_PROOF_RECEIPT_VIEWER_SPEC_V0_2_20260604.md`
- `ACTION_CARDS/ROOT_RESIDUE_ROUTE_ACTION_CARDS_V0_2_20260604.md`
- `ACTION_CARDS/SAVE_GATE_ACTION_CARDS_V0_2_20260604.md`
- `ACTION_CARDS/BLOCKER_BURNDOWN_ACTION_CARDS_V0_2_20260604.md`
- `PROOF_GATES/UI_BIG_JOB_DATA_BUDGET_PROTOCOL_V0_1_20260604.md`
- `PROOF_GATES/UI_LANE_ACCEPTANCE_TEST_PLAN_V0_1_20260604.md`
- `PATH_MAPS/UI_LANE_PATH_MAP_V0_2_20260604.csv`
- `RECEIPTS/UI_LANE_PHASE2_BUILD_RECEIPT_20260604.txt`
- `RECEIPTS/UI_LANE_PHASE2_BUILD_MANIFEST_20260604.csv`
- `RECEIPTS/UI_LANE_PHASE2_ROLLBACK_MANIFEST_20260604.csv`

If the existing folder names differ, use the existing structure and record actual paths.

## Artifact requirements

### Command registry V0.2

Must define command families, canonical commands, aliases, input patterns, output panels, proof needs, and stop gates.

Include at minimum:

- `root check`
- `route residue`
- `inspect object`
- `show proof`
- `save gate`
- `lock save`
- `show blockers`
- `burn blocker`
- `open parking`
- `build lane`
- `review last job`
- `show active pointer`
- `make handoff`
- `cluster files`
- `no nested zip check`

### Action recipe library V0.2

Each recipe must include:

- trigger command;
- required input;
- action steps;
- allowed files;
- forbidden files;
- proof required;
- receipt output;
- closeout verdict;
- rollback/custody path.

### Dashboard state model V0.2

Define the panels and data each panel needs:

- active task;
- root status;
- proof status;
- Git status;
- blockers;
- parked material;
- file/object inspector;
- action queue;
- receipts;
- final judge.

### File/object inspector spec V0.2

Define how UI inspects an object:

- path;
- type;
- hash;
- owner lane;
- proof pointer;
- status;
- related artifacts;
- allowed actions;
- blocked actions;
- last touched receipt.

### Proof/receipt viewer spec V0.2

Define how UI shows proof without dumping everything:

- receipt summary;
- manifest link;
- hashes;
- verdict lines;
- before/after;
- rollback pointer;
- commit/push status.

### Root-residue route action cards V0.2

Create action cards for:

- root loose file;
- root loose folder;
- known runner;
- handoff packet;
- source note;
- parked package;
- zip artifact;
- unknown user original.

### Save-gate action cards V0.2

Create action cards for:

- exact-set save;
- staged set verification;
- commit/push proof;
- no-commit blocker;
- entangled dirty file blocker.

### Blocker burn-down action cards V0.2

Create action cards for:

- fix-now blocker;
- reduce-and-continue blocker;
- conflict parked not overwritten;
- real stop/ask blocker.

### Data budget protocol V0.1

Must include:

- use prior manifests;
- read once;
- do not repeat summaries;
- use hashes/paths/verdicts;
- phase work when data cost rises;
- avoid broad crawls;
- stop only for real blockers;
- report data-heavy areas compactly.

### Acceptance test plan V0.1

Must define tests/checks for:

- root clean indicator;
- command resolution;
- action-card completeness;
- proof viewer completeness;
- save-gate exact-set behavior;
- no nested zip behavior;
- blocker burn-down behavior;
- final root clean check.

## Blocker burn-down required

If a blocker appears:

`NAME_BLOCKER -> CLASSIFY_BLOCKER -> HASH_BEFORE_CHANGE -> BACKUP_OR_CUSTODY_POINTER -> FIX_ROUTE_REDUCE_OR_ISOLATE_IF_ALLOWED -> HASH_AFTER_CHANGE -> UPDATE_PATHS -> CONTINUE`

Required closeout line:

`BLOCKERS_ARE_WORK_ITEMS_NOT_STOP_EXCUSES`

If a real blocker remains:

`UI_LANE_PHASE2_REAL_BLOCKER_STOP_AND_ASK`

## Hash-backed reversibility

Before modifying existing files:

- hash original;
- preserve backup/custody if needed;
- record old path;
- record new path;
- record reason.

After modifying:

- hash final;
- update rollback manifest;
- update path map.

Required closeout line:

`HASH_BACKED_REVERSIBILITY_RECORDED`

## Phase 3 — status/path/proof updates

Update:

- UI lane README or index;
- UI lane path map;
- UI lane backlog;
- `HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md`;
- receipt/manifest/rollback manifest.

The next worker must be able to find the Phase 2 UI lane without chat.

## Phase 4 — save Phase 2 if clean

If Phase 2 creates/updates files cleanly, save it.

This may be a second commit after the exact-set save, or a single commit if the prior exact-set and Phase 2 are intentionally combined and the staged set is exact and proved.

Preferred: two commits if practical:

1. Prior UI lane exact-set save.
2. UI Lane Phase 2 build.

Do not commit unrelated dirty/untracked material.

If commit/push is blocked, report exact reason.

## Required final answer shape

Use one:

`UI_LANE_PHASE2_BIG_JOB_COMPLETE_WITH_BLOCKER_BURNDOWN`

or

`UI_LANE_PHASE2_REAL_BLOCKER_STOP_AND_ASK`

Then include:

Data:
`READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL`
Briefly report whether data was controlled.

Root:
`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Prior save:
`UI_LANE_EXACT_SET_SAVE_COMMIT_AND_PUSH_PROVED`
or
`EXACT_SET_SAVE_BLOCKED_WITH_REASON`

Phase 2 build:
List built files and hashes.

Good material:
`GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE`

Blockers:
`BLOCKERS_ARE_WORK_ITEMS_NOT_STOP_EXCUSES`
List any fixed/reduced/real blockers.

Reversibility:
`HASH_BACKED_REVERSIBILITY_RECORDED`
List rollback manifest path and hash.

Proof:
Manifest path/hash.
Receipt path/hash.
Acceptance checklist path/hash.

Git:
`COMMIT_AND_PUSH_PROVED`
or
`NO_COMMIT_NO_PUSH_WITH_REASON`

Target/helper:
`TARGET_HELPER_NOT_RUN`
unless explicitly authorized otherwise.

Final root:
`ROOT_NO_LOOSE_FILES_CHECK_PASS`

## Hard boundaries

No read-only-only closeout.
No loose files in root.
No nested zips.
No broad crawl.
No repeated summary dump.
No pathless save.
No fake ready claim.
No target/helper execution.
No watcher/automation.
No package installs.
No deleting user originals.
No staging unrelated junk.
No commit/push claim without proof.
