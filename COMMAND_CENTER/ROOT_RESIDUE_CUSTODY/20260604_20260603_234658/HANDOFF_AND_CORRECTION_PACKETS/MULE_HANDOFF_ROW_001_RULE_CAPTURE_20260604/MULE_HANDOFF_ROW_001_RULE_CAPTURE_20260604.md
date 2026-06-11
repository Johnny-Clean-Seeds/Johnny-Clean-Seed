# MULE HANDOFF — ROW 001 + REPEATED CORRECTION RULE CAPTURE

Date: 2026-06-04
Status: WORK ORDER / MULE HANDOFF / REVIEW AFTER COMPLETION
WorkKey: MULE-HANDOFF-ROW-001-RULE-CAPTURE-20260604

## One-line order

Do the work that the chat intentionally stopped doing because the lane got messy:

1. install/route the repeated-correction parent rule;
2. install/route the mule-root no-loose-files child rule;
3. review Row 001 static fixture design and inert fixture packet;
4. perform the required root-residue closeout checks;
5. produce receipts/reports;
6. do not run the target helper.

## Current source packet

This handoff packet includes:

- `REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_V1_1.md`
- `MULE_ROOT_NO_LOOSE_FILES_RULE_V1.md`
- `ROW_001_DISPOSABLE_FIXTURE_DESIGN_V1.md`
- `ROW_001_DISPOSABLE_FIXTURE_V1.zip`

Treat these as intake/source packet material, not authority by themselves.

## Primary boss

The boss is not “clean up this one mess.”

The boss is:

`LOOK -> ASK SHOULD THIS BE A LIVING RULE / CHECK / GATE? -> DECIDE -> DO WHAT NEEDS TO BE DONE`

The parent rule candidate is:

`REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_V1_1`

Core judgment:

`REPEATED_USER_CORRECTION_FORCES_LOOK_AND_RULE_DECISION`

This rule means repeated user corrections must trigger a structural review. The worker must inspect relevant files/rules/state enough to decide whether the correction should become a living rule, child rule, checklist item, closeout gate, fixture, watch item, or rejection. If yes, create/route/apply it. If no, say why.

## Child rule to process

Child rule candidate:

`MULE_ROOT_NO_LOOSE_FILES_RULE_V1`

Core judgment:

`ROOT_LOOSE_FILE_WRONG_LANE_UNTIL_PROVEN_ALLOWED`

Closeout pass line:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Blocked closeout line:

`ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

Meaning: mule/helper must not leave loose generated/work files in project root. Root files are wrong-lane unless explicitly allowed as stable root pointers, approved anchors, or intentional root-drop intake files waiting for classification.

## Required local review

Before saving anything, inspect the relevant local house surfaces:

- current repo root;
- current status file if available;
- existing BRAIN_LEARNING rules;
- existing proof receipts around generated runner failures;
- Row 001 / Helper Stress Bench lane;
- root/drop/custody locations;
- any existing root-clean or wrong-lane rules.

Answer these before writing:

1. Does a repeated-correction rule already exist?
2. If yes, why did it not fire?
3. If no, should V1.1 become a durable rule/check?
4. Does a root-no-loose-files rule already exist?
5. If yes, why did it not fire?
6. If no, should V1 become a durable child rule/check?
7. Should either become a checklist item or closeout gate?
8. Where should the files live?
9. What receipt/report proves the move?
10. What current behavior changes immediately?

## Suggested durable placements

Use local judgment, but likely placements are:

Parent rule:

`BRAIN_LEARNING/REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_20260604.md`

Child rule:

`BRAIN_LEARNING/MULE_ROOT_NO_LOOSE_FILES_RULE_20260604.md`

Row 001 fixture/design review:

`HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_20260603/`

or a nearby proper Helper Stress Bench / Sorting Bench review lane if the current house has a newer exact path.

Receipts/manifests:

`PROOF_HISTORY/`

Do not create loose repo-root work files unless the root contract explicitly allows them.

## Row 001 order

The target helper still has not run.

Do not run it.

The failed object is the generated-runner layer, not the target helper.

Work Row 001 as static/manual fixture review only.

Tasks:

1. Open/review `ROW_001_DISPOSABLE_FIXTURE_DESIGN_V1.md`.
2. Open/review `ROW_001_DISPOSABLE_FIXTURE_V1.zip`.
3. Confirm the fixture packet is inert: markdown/csv only, no `.ps1`, `.cmd`, `.bat`, launcher, watcher, automation, or target-helper command.
4. Use the checklist inside the fixture packet.
5. Produce a static fixture review report.
6. Decide whether to park/archive/save the fixture lesson.
7. Do not convert this into a runner.
8. Do not execute the target helper.

Required Row 001 wording:

`TARGET_HELPER_NOT_RUN`

`NO_TARGET_HELPER_RESULT_EXISTS`

`RUNNER_LAYER_UNSTABLE`

`STATIC_FIXTURE_REVIEW_ONLY`

## Forbidden moves

Do not:

- create another generated runner for this lane;
- run the target helper;
- claim the target helper failed;
- claim the target helper passed;
- leave new work files in root;
- silently clean wrong-lane root files;
- make a repo-save claim without proof;
- treat sandbox packet files as already installed house truth;
- promote doctrine without the normal judge/proof path;
- use “repair complete” for a no-op/skip/static review only.

## Required root-residue closeout

Before closeout, inspect root and classify new/loose files.

Closeout must answer:

1. What new files did this mule/helper create?
2. Where did each land?
3. Does each belong in that lane?
4. Did anything land in root?
5. If yes, is it explicitly allowed?
6. If not, where was it moved/parked?
7. Was that movement recorded?
8. Does final root contain only allowed root objects?

If clean, report:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

If blocked, report:

`ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

If wrong-lane residue existed and was routed, report:

`WRONG_LANE_ROOT_RESIDUE_FOUND_AND_ROUTED`

## Required proof packet

Produce a receipt/report that states:

- input files and hashes;
- exact destination paths;
- whether parent rule was saved/routed/parked/rejected;
- whether child rule was saved/routed/parked/rejected;
- Row 001 fixture review verdict;
- root-residue check result;
- target helper status;
- Git status before/after if Git is involved;
- whether any commit/push happened;
- exact HEAD/origin proof if commit/push happened.

## Expected final verdict shape

Use this final structure:

`REPEATED_USER_CORRECTION_REVIEW_FIRED`

Parent rule decision:
`YES_SAVE_OR_ROUTE_PARENT_RULE` / `NO_WITH_REASON` / `ALREADY_EXISTS_AND_APPLICATION_FAILED`

Child rule decision:
`YES_SAVE_OR_ROUTE_CHILD_RULE` / `NO_WITH_REASON` / `ALREADY_EXISTS_AND_APPLICATION_FAILED`

Row 001 decision:
`PASS_STATIC_FIXTURE_REVIEW` / `WATCH_STATIC_FIXTURE_REVIEW` / `BLOCK_STATIC_FIXTURE_REVIEW`

Target helper:
`TARGET_HELPER_NOT_RUN`

Root:
`ROOT_NO_LOOSE_FILES_CHECK_PASS` or `ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

Save:
`NO_COMMIT` or `COMMIT_AND_PUSH_PROVED`

## Review-after-completion note

The user will review what you do after completion. The job is not to impress with volume. The job is to stop recurring failure by installing/routing the missing checks cleanly and proving no new root mess was left behind.
