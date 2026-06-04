# MULE HANDOFF — UI LANE BIG JOB COMBINED

Date: 2026-06-04
Status: SINGLE START FILE / BIG JOB / BLOCKER BURN-DOWN REQUIRED / REVIEW AFTER COMPLETION
WorkKey: MULE-HANDOFF-UI-LANE-BIG-JOB-COMBINED-20260604

## Start here

This file combines the UI lane build handoff and the blocker burn-down addendum.

The mule must start from this file.

Do not treat the addendum as optional.

Do not close with a read-only review.

Do not use blockers as an excuse to stop unless they are real authority/safety/custody blockers.

## Required final target

`UI_LANE_BIG_JOB_COMPLETE_WITH_BLOCKER_BURNDOWN`

Required if blocked:

`UI_LANE_BIG_JOB_REAL_BLOCKER_STOP_AND_ASK`

## Hard command

Build the UI lane as much as possible.

Safe blockers are work items.

Hash before changes.

Fix, route, reduce, or isolate blockers when allowed.

Update paths, pointers, manifests, status, receipts, and proof surfaces.

Keep root clean.

Commit/push only if the save route is clean and authorized; otherwise report exact no-commit reason.

---

# MULE HANDOFF — BUILD THE WHOLE UI LANE AS MUCH AS POSSIBLE

Date: 2026-06-04
Status: BIG JOB WORK ORDER / UI LANE BUILD / APPLY-NOW / REVIEW AFTER COMPLETION
WorkKey: MULE-HANDOFF-BUILD-UI-LANE-AS-MUCH-AS-POSSIBLE-20260604

## Prime order

Build the UI lane as much as possible.

This is not a read-only review job.

Read-only review is allowed only as the intake phase. It does not satisfy the job.

The job must produce durable project material, update paths/status surfaces, prove what was built, and either commit/push or return a real blocker.

## Current clean checkpoint

Root cleanup has just reached a clean root view by the current allowed-root set.

Allowed root view after Phase 2:

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

Do not dirty this root again.

Before closeout, root must pass:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

If new work material lands in root, route it before closeout.

## Active rules that must fire

### Repeated correction rule

Use:

`LOOK -> ASK SHOULD THIS BE A LIVING RULE / CHECK / GATE? -> DECIDE -> DO WHAT NEEDS TO BE DONE`

Repeated user corrections are not just chat feedback. They are review triggers.

### Root no-loose-files rule

Use:

`ROOT_LOOSE_FILE_WRONG_LANE_UNTIL_PROVEN_ALLOWED`

No loose generated files, reports, scripts, fixtures, packets, drafts, or temp work may remain in root.

### Good-material injection rule

Root cleanup is not enough.

Use:

`GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE`

When good material is found, inject it into the correct durable project lane, update paths/pointers/status/manifest surfaces, and make it usable.

### Packaging rule

No nested zips.

Do not put zip files inside zip files.

When reporting related files, cluster links together with explanation above and placement note below.

## The actual UI lane goal

The user wants a real UI lane for the project.

The UI lane should eventually stand in front of the house/project file system and help the user command, inspect, route, and execute project work without manually digging through folders.

Current language from prior direction:

- Project Command Center is the user-facing tool.
- It sends actions to the House Command Center.
- It should help work with growing files.
- It should support scans, jobs, routes, proof, status, and command grammar.
- It should help short operator phrases resolve into action cards.
- It must not become a fake authority layer.
- It must not bypass proof, gates, receipts, path custody, or user control.

## UI lane meaning

The UI lane is not only a pretty screen.

It includes:

1. **User-facing command surface**
   - short commands;
   - buttons/menu options;
   - job cards;
   - status panels;
   - proof panels;
   - root clean indicator;
   - active task pointer;
   - blocked/parked work view.

2. **Command grammar**
   - aliases such as `inspect last task`, `inspect last job`, `lock save`, `save gate`, `guard review`, `run verifier`, `root check`, `route residue`, `show active task`;
   - command families;
   - confirmation cards before action.

3. **Action-tree layer**
   - command -> intent -> action recipe -> required files -> proof needed -> execution permission -> receipt -> closeout.

4. **House Command Center bridge**
   - UI should not directly pretend to be the house.
   - UI produces or triggers action cards/work orders for House Command Center.
   - House Command Center handles file-facing jobs, proof, receipts, and path updates.

5. **File lane integration**
   - it should know where UI specs, commands, manifests, action cards, reports, and proofs live.
   - it should update indexes/status so future workers can find them.

6. **Safety/proof layer**
   - no target/helper execution without proof route;
   - no root clutter;
   - no fake pass;
   - no save claim without Git/status proof;
   - no automation/watcher unless explicitly authorized and proven.

## Hard deliverable floor

This is the minimum acceptable output. If any part is blocked, say exactly why.

A valid completion must produce at least these durable artifacts or their local equivalents if a better house lane already exists:

1. UI lane inventory report.
2. UI lane master build spec.
3. UI lane command grammar V0.
4. UI lane action-card template V0.
5. UI lane screen/panel map V0.
6. UI lane file/path map V0.
7. UI lane proof/checklist gate V0.
8. UI lane next-build backlog with phases.
9. Status/index update so the UI lane is findable.
10. Proof receipt/manifest for all created/updated files.
11. Final root clean check.
12. Git status proof and either commit/push proof or explicit no-commit blocker.

Read-only notes alone are not enough.

## Suggested durable placement

Use local judgment and existing house structure first. If no better current lane exists, use this shape:

UI lane root:

`HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/`

Suggested subfolders:

- `SPEC/`
- `COMMAND_GRAMMAR/`
- `ACTION_CARDS/`
- `SCREEN_MAPS/`
- `PATH_MAPS/`
- `PROOF_GATES/`
- `BACKLOG/`
- `REPORTS/`
- `RECEIPTS/`

If an existing Project Command Center or HOUSE_DOCK_CONTROL_ROOM lane already exists, inspect it and decide whether the UI lane belongs there instead. Do not duplicate a better existing lane.

If unsure:

`DIRECTION_UNCLEAR_STOP_AND_ASK`

## Phase 0 — start clean

Before building:

1. Confirm root view.
2. Confirm repo path:
   - `C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz`
3. Confirm no unexpected root residue before starting.
4. Confirm no active helper/target execution is being accidentally triggered.
5. Confirm Git status before changes.

Do not create work files in root.

## Phase 1 — inventory existing UI-related material

Inspect likely local project areas:

- `HOUSE_WORK`
- `BRAIN_LEARNING`
- `COMMAND_CENTER`
- any `PROJECT_COMMAND_CENTER` files/folders
- any `HOUSE_COMMAND_CENTER` files/folders
- any `HOUSE_DOCK_CONTROL_ROOM` parked material if present in custody/review lanes
- any helper/toolbox/toolbelt registry material
- current status/index files
- proof receipts related to command center, UI, helper capability, root cleanup, Row 001, and packaging rules

The inventory must identify:

- existing UI/command-center material;
- relevant rules/gates;
- useful parked packages;
- duplicate/stale material;
- gaps;
- safest build lane.

Do not treat parked packages as installed. If a parked package is useful, extract/prove/inject or leave it parked with reason.

## Phase 2 — choose one active UI build lane

Pick the most likely direction and stay on it.

Do not open every lane.

Use one of these decisions:

- `USE_EXISTING_UI_LANE`
- `CREATE_PROJECT_COMMAND_CENTER_UI_LANE`
- `MERGE_WITH_EXISTING_COMMAND_CENTER_LANE`
- `PARK_UI_BUILD_BLOCKED_WITH_REASON`

The selected lane must have a clear path and owner.

## Phase 3 — build the UI lane artifacts

Build the core artifacts.

### Artifact 1 — UI lane inventory report

Suggested name:

`REPORTS/UI_LANE_INVENTORY_REPORT_20260604.md`

Must include:

- what was found;
- what is usable;
- what is parked/stale;
- what must not be used;
- gaps;
- chosen lane.

### Artifact 2 — master build spec

Suggested name:

`SPEC/PROJECT_COMMAND_CENTER_UI_LANE_MASTER_BUILD_SPEC_V0_1_20260604.md`

Must include:

- mission;
- scope;
- non-goals;
- user-facing functions;
- house-facing bridge;
- file lanes;
- proof lanes;
- build stages;
- blocked items;
- acceptance tests.

### Artifact 3 — command grammar V0

Suggested name:

`COMMAND_GRAMMAR/UI_COMMAND_GRAMMAR_V0_20260604.md`

Must define:

- command families;
- aliases;
- required confirmation card;
- action recipes;
- permission boundary;
- examples.

Must include commands such as:

- `inspect last task`
- `inspect last job`
- `show active task`
- `root check`
- `route residue`
- `lock save`
- `save gate`
- `guard review`
- `run verifier`
- `open parking`
- `show blockers`
- `show proof`

### Artifact 4 — action-card template V0

Suggested name:

`ACTION_CARDS/UI_ACTION_CARD_TEMPLATE_V0_20260604.md`

Must include fields:

- command;
- resolved intent;
- active object;
- target path;
- required inputs;
- allowed actions;
- forbidden actions;
- proof required;
- stop/ask conditions;
- closeout verdict;
- receipt path;
- root clean check.

### Artifact 5 — screen/panel map V0

Suggested name:

`SCREEN_MAPS/UI_SCREEN_PANEL_MAP_V0_20260604.md`

Must map:

- dashboard/home;
- active task;
- command input;
- file/object inspector;
- proof/receipt panel;
- root status panel;
- blockers/parking panel;
- action queue;
- final judge/closeout panel.

### Artifact 6 — path map V0

Suggested name:

`PATH_MAPS/UI_LANE_PATH_MAP_V0_20260604.csv`

Must map:

- artifact name;
- path;
- purpose;
- owner lane;
- proof pointer;
- next update trigger.

### Artifact 7 — proof/checklist gate V0

Suggested name:

`PROOF_GATES/UI_LANE_BUILD_PROOF_CHECKLIST_V0_20260604.md`

Must include:

- no root residue;
- no fake pass;
- status updated;
- path map updated;
- receipt created;
- no nested zips;
- no uncontrolled automation;
- no target/helper execution unless authorized;
- commit/push proof if used.

### Artifact 8 — backlog

Suggested name:

`BACKLOG/UI_LANE_NEXT_BUILD_BACKLOG_20260604.md`

Must separate:

- now;
- next;
- later;
- blocked;
- parked;
- needs user decision.

## Phase 4 — optional prototype/scaffold only if safe

If there is already a safe, existing local UI/code lane, the mule may add a bounded prototype/scaffold.

Allowed prototype examples:

- static HTML mockup;
- plain markdown wireframe;
- JSON command schema;
- CSV command map;
- PowerShell menu design document;
- non-executing pseudo-runner plan.

Do not build a live watcher, automation, browser extension, app installer, or background process unless explicitly authorized.

If prototype would require new toolchain, risky execution, package installs, or unclear file ownership:

`PARK_PROTOTYPE_WITH_REASON`

## Phase 5 — update project surfaces

Update the surfaces that make the UI lane findable and usable.

Likely surfaces:

- `HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md`
- a UI lane index/README;
- any existing Project Command Center index;
- proof/manifest paths;
- path map;
- backlog.

Do not leave only chat as the pointer.

## Phase 6 — proof and tests

Run only safe checks.

Required proof:

1. created/updated file list;
2. SHA256 for each output;
3. path map matches actual paths;
4. status/index references exist;
5. no unexpected root residue;
6. no nested zip created;
7. no unauthorized scripts/automation;
8. Git status before/after;
9. staged set proof if committing;
10. HEAD/origin/final clean proof if pushing.

If running tests is not possible, produce proof-checklist status:

- `PASS`
- `WATCH`
- `BLOCKED`

with reasons.

## Phase 7 — save route

If local rules allow commit/push, commit the exact UI lane set and proof files.

Do not stage unrelated parked packages or root cleanup clutter.

Suggested commit title:

`Build project command center UI lane`

If commit/push is done, prove:

- old HEAD;
- new HEAD;
- origin/main;
- `HEAD == origin/main`;
- final status.

If commit/push is not done, say exactly why:

`NO_COMMIT_NO_PUSH_WITH_REASON`

## Stop/ask gates

Stop and ask if:

- the UI lane already exists in a conflicting form;
- multiple paths are plausible and none clearly wins;
- a parked package must be unpacked or installed to continue;
- the work requires live automation/watcher;
- the work requires target/helper execution;
- the work requires package installs;
- the work would dirty root;
- user-original files are mixed with helper residue;
- a commit/push decision is ambiguous;
- the job starts sprawling into unrelated helper-capability systems.

Use:

`DIRECTION_UNCLEAR_STOP_AND_ASK`

Do not sprawl.

## Required final answer shape

Use this exact structure:

`UI_LANE_BIG_JOB_COMPLETE`

or

`UI_LANE_BIG_JOB_BLOCKED`

Then include:

Root:
`ROOT_NO_LOOSE_FILES_CHECK_PASS` or blocker.

Lane decision:
`USE_EXISTING_UI_LANE` / `CREATE_PROJECT_COMMAND_CENTER_UI_LANE` / `MERGE_WITH_EXISTING_COMMAND_CENTER_LANE` / `PARK_UI_BUILD_BLOCKED_WITH_REASON`

Built artifacts:
List paths and hashes.

Good material:
`GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE`
or blocker.

Prototype:
`NO_PROTOTYPE_BY_BOUNDARY`
or
`PROTOTYPE_BUILT_AND_PROVED`
or
`PARK_PROTOTYPE_WITH_REASON`

Proof:
Receipt path, manifest path, proof checklist verdict.

Git:
`COMMIT_AND_PUSH_PROVED`
or
`NO_COMMIT_NO_PUSH_WITH_REASON`

Final root:
`ROOT_NO_LOOSE_FILES_CHECK_PASS`

## Hard boundaries

No read-only-only closeout.
No loose files in root.
No nested zips.
No silent cleanup.
No pathless save.
No fake ready claim.
No target/helper execution unless explicitly authorized.
No watcher/automation unless explicitly authorized.
No broad package install.
No deleting user originals.
No committing unrelated junk.
No doctrine promotion without normal proof path.


---

# MULE HANDOFF ADDENDUM — UI LANE BLOCKER BURN-DOWN / HASH-BACKED REVERSIBILITY

Date: 2026-06-04
Status: BIG JOB ADDENDUM / BLOCKERS ARE WORK ITEMS / HASH BEFORE CHANGE / REPORT AFTER
WorkKey: MULE-UI-LANE-BLOCKER-BURNDOWN-ADDENDUM-20260604

## Attach this to

`MULE_HANDOFF_BUILD_UI_LANE_AS_MUCH_AS_POSSIBLE_20260604.md`

This addendum overrides any weak blocker behavior in that handoff.

## Core correction

A blocker is not automatically an excuse to stop.

If the blocker is inside the assigned UI-lane job, safe, reversible, and fixable without new user authority, then the mule must fix, route, reduce, or isolate the blocker and continue.

Stop/ask is only valid for a real authority/safety/custody blocker.

## New required chain

Use this chain when a blocker appears:

1. `NAME_BLOCKER`
2. `CLASSIFY_BLOCKER`
3. `HASH_BEFORE_CHANGE`
4. `MAKE_BACKUP_OR_CUSTODY_POINTER_IF_NEEDED`
5. `FIX_ROUTE_REDUCE_OR_ISOLATE_IF_ALLOWED`
6. `HASH_AFTER_CHANGE`
7. `UPDATE_PATHS_POINTERS_MANIFESTS_STATUS`
8. `CONTINUE_MAIN_JOB`
9. `REPORT_BLOCKER_BURNDOWN_AT_CLOSEOUT`

## Blocker classes

### Fix-now blockers

These must be worked, not used to stop:

- root residue created by this job;
- missing folder for intended UI lane;
- missing index/README needed to make the lane findable;
- missing manifest/receipt surface;
- stale path references inside this job’s outputs;
- duplicate draft files where custody is clear;
- parked material that can be safely copied/injected without destructive move;
- no proof receipt yet for files the mule just created;
- no status append yet for a lane the mule just built;
- safe hash mismatch caused by known regenerated output where old/new are both preserved;
- missing path map for new UI artifacts;
- unclear wording in the mule’s own generated files;
- no final root check yet;
- no staged-set proof yet if committing.

### Reduce-and-continue blockers

These must be reduced to a smaller safe action, then work continues:

- giant existing package too large to fully absorb;
- multiple related parked packages;
- too many candidate files;
- broad UI scope;
- uncertain future prototype toolchain.

Allowed response:

- extract only the clearly relevant good material;
- park the rest with return trigger;
- update path map;
- continue the main UI lane.

Use:

`BLOCKER_REDUCED_AND_MAIN_JOB_CONTINUED`

### Real stop/ask blockers

Only these may stop the job:

- user choice required between two plausible lanes and neither clearly wins;
- unsafe or unauthorized execution;
- package install/network needed;
- live watcher/automation/background process needed;
- target/helper execution required;
- irreversible delete/move risk;
- source custody unclear and moving would risk loss;
- user-original material mixed with generated residue;
- commit/push authority unclear;
- conflict with higher active rule;
- destructive overwrite would be required;
- credentials/secrets/private data handling uncertainty.

Use:

`REAL_BLOCKER_STOP_AND_ASK`

Do not misuse this.

## User instruction

The user explicitly allows internal safe blockers to be handled now and reported later.

Meaning:

Do not stop just because a blocker exists.

If it is bad later, hashes and custody paths should allow rollback or review.

## Hash-backed reversibility rule

Before changing, moving, overwriting, merging, or injecting any existing file, record:

- original path;
- original SHA256;
- intended new path;
- reason for change;
- action type;
- backup/custody path if applicable.

After the action, record:

- final path;
- final SHA256;
- status;
- rollback pointer or custody pointer.

If the file is newly created, record:

- created path;
- SHA256;
- owner lane;
- reason created.

## No destructive overwrite rule

Do not overwrite an existing file unless one of these is true:

1. exact same hash;
2. backup/custody copy was created first;
3. file is generated by this same run and known safe to replace;
4. user explicitly authorized overwrite.

If none is true, park conflict and continue where possible.

Use:

`CONFLICT_PARKED_NOT_OVERWRITTEN`

## Rollback manifest requirement

The mule must create a rollback/action manifest for the UI-lane job.

Suggested path:

`HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/RECEIPTS/UI_LANE_BUILD_ROLLBACK_MANIFEST_20260604.csv`

or the selected UI lane’s receipt/proof folder.

Columns:

- `ActionId`
- `ObjectName`
- `ActionType`
- `OriginalPath`
- `OriginalSha256`
- `BackupOrCustodyPath`
- `NewPath`
- `NewSha256`
- `Reason`
- `RollbackMethod`
- `Status`

## Continue-until-real-blocker rule

A big job must not stop at the first manageable issue.

Required behavior:

- handle safe blockers;
- reduce oversized blockers;
- park unclear side material;
- keep building the selected UI lane;
- report all handled blockers at closeout.

The job may close blocked only if a real stop/ask blocker remains after attempted reduction.

## UI-lane minimum floor still applies

The mule still owes the UI-lane deliverable floor unless a real stop/ask blocker prevents it:

1. UI lane inventory report.
2. UI lane master build spec.
3. UI command grammar V0.
4. UI action-card template V0.
5. UI screen/panel map V0.
6. UI file/path map V0.
7. UI proof/checklist gate V0.
8. UI next-build backlog.
9. Status/index update.
10. Proof receipt/manifest.
11. Rollback/action manifest.
12. Final root clean check.
13. Git status and commit/push proof or explicit no-commit reason.

## Required closeout section

The mule final answer must include:

### Blocker burn-down

For each blocker:

- blocker name;
- class;
- action taken;
- before hash/path;
- after hash/path;
- proof;
- result:
  - `BLOCKER_FIXED_AND_CONTINUED`
  - `BLOCKER_REDUCED_AND_MAIN_JOB_CONTINUED`
  - `CONFLICT_PARKED_NOT_OVERWRITTEN`
  - `REAL_BLOCKER_STOP_AND_ASK`

### Reversibility

Report:

`HASH_BACKED_REVERSIBILITY_RECORDED`

and give rollback manifest path + hash.

## Forbidden behavior

Do not stop after read-only review.

Do not call a normal work item a blocker.

Do not use “blocked” to avoid building.

Do not move files without recording hashes.

Do not overwrite without backup/custody proof.

Do not leave path updates for later.

Do not dirty root.

Do not hide uncertainty.

Do not create nested zips.

Do not run target/helper execution.

## Final verdict shape

Use one:

`UI_LANE_BIG_JOB_COMPLETE_WITH_BLOCKER_BURNDOWN`

or

`UI_LANE_BIG_JOB_REAL_BLOCKER_STOP_AND_ASK`

Required lines:

`BLOCKERS_ARE_WORK_ITEMS_NOT_STOP_EXCUSES`

`HASH_BACKED_REVERSIBILITY_RECORDED`

`GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE`

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

`TARGET_HELPER_NOT_RUN` if target/helper was not explicitly authorized.

If commit/push happened:

`COMMIT_AND_PUSH_PROVED`

If not:

`NO_COMMIT_NO_PUSH_WITH_REASON`

