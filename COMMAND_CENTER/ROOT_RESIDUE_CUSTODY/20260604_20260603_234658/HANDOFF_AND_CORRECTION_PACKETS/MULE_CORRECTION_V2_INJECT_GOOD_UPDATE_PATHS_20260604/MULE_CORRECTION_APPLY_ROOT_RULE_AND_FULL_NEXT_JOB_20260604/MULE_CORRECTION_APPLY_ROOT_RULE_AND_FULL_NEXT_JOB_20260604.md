# MULE CORRECTION ORDER — APPLY ROOT RULE AND DO FULL NEXT JOB

Date: 2026-06-04
Status: CORRECTION ORDER / APPLY-NOW GATE / FULL NEXT JOB / REVIEW AFTER COMPLETION
WorkKey: MULE-CORRECTION-APPLY-ROOT-RULE-AND-FULL-NEXT-JOB-20260604

## Why this correction exists

The prior handoff was too weak.

It told the mule to read, route, and save the repeated-correction parent rule and root-no-loose-files child rule, but it did not force the mule to apply the child rule to the actual root mess before continuing.

That created another failure:

`RULE_REVIEW_WITHOUT_RULE_ENFORCEMENT`

The user’s correction is valid:

The root is still messy.

So this correction order overrides the weak part of the prior handoff.

## Prime order

Do not stop at “read verdict.”

Do not only say the rules should be saved.

Do not continue while the actual offending root surface is still messy.

Required sequence:

1. `APPLY_ROOT_RULE_NOW`
2. `CLASSIFY_AND_ROUTE_ROOT_RESIDUE`
3. `SAVE_OR_ROUTE_PARENT_RULE`
4. `SAVE_OR_ROUTE_CHILD_RULE`
5. `REVIEW_ROW_001_STATIC_FIXTURE`
6. `PRODUCE_REPORTS_RECEIPTS_MANIFESTS`
7. `FINAL_ROOT_NO_LOOSE_FILES_CHECK`
8. `FINAL_STATUS_FOR_USER_REVIEW`

## Gate 1 — APPLY_ROOT_RULE_NOW

Before any rule-save, Row 001 review, report polishing, or next work, inspect:

`C:\Users\13527\Desktop\123`

The root currently contains at least these new loose files/folders from the prior work:

Root-level files reported:

- `REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_V1_1.md`
  - SHA256: `4C951E17813ACFC5D9EF8F485A3B4648721959F7CC31AE915D3D14D1F03BC8F7`
- `ROW_001_DISPOSABLE_FIXTURE_DESIGN_V1.md`
  - SHA256: `6B52947701E4E5C94C17C7C77226E4F928D55B7E9A1FE637C83B6AA9B838F303`
- `SHA256_MANIFEST_ROW_001_DISPOSABLE_FIXTURE_V1.csv`
  - SHA256: `7E8B9E688BF9D4C34B9AF74ADE79C23199893AA02BEECC9597774AFB84EFED38`

Root-level folders reported:

- `ROW_001_DISPOSABLE_FIXTURE_V1`
- `MULE_HANDOFF_ROW_001_RULE_CAPTURE_20260604`

There may be additional loose root residue. Inspect the full root.

Required root judgment:

`ROOT_LOOSE_FILE_WRONG_LANE_UNTIL_PROVEN_ALLOWED`

## What to do with the current root residue

Classify each loose root object as one of:

- `ALLOWED_ROOT_POINTER`
- `USER_DROP_INTAKE_PENDING`
- `WRONG_LANE_RULE_CANDIDATE`
- `WRONG_LANE_FIXTURE`
- `WRONG_LANE_HANDOFF_PACKET`
- `WRONG_LANE_MANIFEST`
- `WRONG_LANE_REPORT`
- `UNCERTAIN_PARK_DO_NOT_DELETE`
- `DO_NOT_TOUCH_USER_ORIGINAL`

Expected decisions for known objects unless local context proves otherwise:

- `REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_V1_1.md`
  - likely `WRONG_LANE_RULE_CANDIDATE`
  - route/save to proper durable rule lane or rule-candidate lane.
- `MULE_ROOT_NO_LOOSE_FILES_RULE_V1.md`
  - if present in root, likely `WRONG_LANE_RULE_CANDIDATE`
  - route/save to proper durable rule lane or rule-candidate lane.
- `ROW_001_DISPOSABLE_FIXTURE_DESIGN_V1.md`
  - likely `WRONG_LANE_FIXTURE`
  - route to Helper Stress Bench / Row 001 review lane.
- `SHA256_MANIFEST_ROW_001_DISPOSABLE_FIXTURE_V1.csv`
  - likely `WRONG_LANE_MANIFEST`
  - route with the Row 001 fixture packet or proof/history lane.
- `ROW_001_DISPOSABLE_FIXTURE_V1`
  - likely `WRONG_LANE_FIXTURE`
  - route to Helper Stress Bench / Row 001 review lane.
- `MULE_HANDOFF_ROW_001_RULE_CAPTURE_20260604`
  - likely `WRONG_LANE_HANDOFF_PACKET`
  - route to Mule Workshop incoming/completed handoff lane, or park if not sure.

Do not delete durable source/proof material.

If safe move is uncertain, park it in the proper review/parking lane and report the ambiguity.

## Gate 2 — save/route parent rule

Parent rule candidate:

`REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_V1_1`

Core judgment:

`REPEATED_USER_CORRECTION_FORCES_LOOK_AND_RULE_DECISION`

Required decision:

Say explicitly whether this becomes:

- durable living rule;
- child of an existing repeated-correction/capture rule;
- checklist item;
- closeout gate;
- parked candidate;
- rejected with reason.

Likely durable placement if no better local lane exists:

`BRAIN_LEARNING/REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_20260604.md`

If saved, receipt in:

`PROOF_HISTORY/REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_RECEIPT_20260604.txt`

If not saved, explain why and where it is parked.

## Gate 3 — save/route child rule

Child rule candidate:

`MULE_ROOT_NO_LOOSE_FILES_RULE_V1`

Core judgment:

`ROOT_LOOSE_FILE_WRONG_LANE_UNTIL_PROVEN_ALLOWED`

Required closeout pass line:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Required blocked line:

`ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

Required decision:

Say explicitly whether this becomes:

- durable living rule;
- mule closeout checklist;
- root clean gate;
- child of wrong-lane/root-drop rule;
- parked candidate;
- rejected with reason.

Likely durable placement if no better local lane exists:

`BRAIN_LEARNING/MULE_ROOT_NO_LOOSE_FILES_RULE_20260604.md`

Possible closeout/checklist support:

`HOUSE_WORK/WORK_SHED/MULE_WORKSHOP/`
or the current mule helper closeout/checklist lane if one exists.

If saved, receipt in:

`PROOF_HISTORY/MULE_ROOT_NO_LOOSE_FILES_RULE_RECEIPT_20260604.txt`

## Gate 4 — Row 001 static fixture review

The target helper still has not run.

Do not run it.

The failed object is the generated-runner layer, not the target helper.

Review only:

- `ROW_001_DISPOSABLE_FIXTURE_DESIGN_V1.md`
- `ROW_001_DISPOSABLE_FIXTURE_V1`
- `ROW_001_DISPOSABLE_FIXTURE_V1.zip` if present
- `SHA256_MANIFEST_ROW_001_DISPOSABLE_FIXTURE_V1.csv`

Required verification:

- fixture folder is inert;
- markdown/csv only;
- no `.ps1`;
- no `.cmd`;
- no `.bat`;
- no launcher;
- no watcher;
- no automation;
- no target-helper command;
- zip listing confirms same inert shape if zip is present;
- do not extract zip into root.

Required Row 001 report placement:

Use the current Helper Stress Bench / Row 001 lane. If the exact known lane exists, use:

`HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_20260603/`

If not, create/use the nearest proper Row 001 review lane under the house, not root.

Required Row 001 verdict options:

- `PASS_STATIC_FIXTURE_REVIEW`
- `WATCH_STATIC_FIXTURE_REVIEW`
- `BLOCK_STATIC_FIXTURE_REVIEW`

Required target status wording:

`TARGET_HELPER_NOT_RUN`

`NO_TARGET_HELPER_RESULT_EXISTS`

`RUNNER_LAYER_UNSTABLE`

`STATIC_FIXTURE_REVIEW_ONLY`

Forbidden wording:

Do not say helper failed, helper passed, target repaired, or repair complete.

## Gate 5 — proof/report packet

Create a report/receipt packet that records:

- input objects and hashes;
- all root objects found;
- classification for each root object;
- destination for each moved/routed object;
- objects left in root and why each is allowed;
- parent rule decision;
- child rule decision;
- Row 001 static review verdict;
- target-helper status;
- whether any Git commit/push happened;
- exact HEAD/origin/final clean proof if Git commit/push happened;
- final root-residue check.

If Git is used, prove it. If Git is not used, say:

`NO_COMMIT_NO_PUSH`

Do not claim a save without status proof.

## Gate 6 — final root check

After routing/saving/parking, inspect root again.

The final answer must include one of:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

or

`ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

If blocked, list exactly what remains in root and why.

If wrong-lane residue existed and was routed, include:

`WRONG_LANE_ROOT_RESIDUE_FOUND_AND_ROUTED`

## Final answer required shape

Use this final shape:

`MULE_CORRECTION_ORDER_COMPLETE` or `MULE_CORRECTION_ORDER_BLOCKED`

Root application:
`APPLY_ROOT_RULE_NOW_DONE`

Root residue:
`WRONG_LANE_ROOT_RESIDUE_FOUND_AND_ROUTED` or `ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED` or `ROOT_NO_LOOSE_FILES_CHECK_PASS`

Parent rule:
`SAVED_PARENT_RULE` / `ROUTED_PARENT_RULE` / `PARKED_PARENT_RULE` / `REJECTED_PARENT_RULE_WITH_REASON`

Child rule:
`SAVED_CHILD_RULE` / `ROUTED_CHILD_RULE` / `PARKED_CHILD_RULE` / `REJECTED_CHILD_RULE_WITH_REASON`

Row 001:
`PASS_STATIC_FIXTURE_REVIEW` / `WATCH_STATIC_FIXTURE_REVIEW` / `BLOCK_STATIC_FIXTURE_REVIEW`

Target helper:
`TARGET_HELPER_NOT_RUN`

Git:
`COMMIT_AND_PUSH_PROVED` / `NO_COMMIT_NO_PUSH`

Final root:
`ROOT_NO_LOOSE_FILES_CHECK_PASS` / `ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

## Hard boundary

No generated runner.
No target helper execution.
No silent cleanup.
No loose new files in root.
No doctrine promotion without normal path.
No fake PASS.
No save claim without proof.
