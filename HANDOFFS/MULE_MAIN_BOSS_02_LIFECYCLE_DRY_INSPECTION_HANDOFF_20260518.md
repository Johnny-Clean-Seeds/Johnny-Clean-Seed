# Mule Handoff — Main Boss 02 Lifecycle State Machine Dry Inspection

Date: 2026-05-18

## Current Brain Position

Start from:

`main @ 28d6345`

Latest known clean commit:

`28d6345 Close anchor truth alignment boss`

Final status at handoff:

`clean`

## Active Ball

`Main Boss 02 — Lifecycle State Machine`

Main Boss 01 is closed for MVP scope only:

`Main Boss 01 — State / Anchor Truth Alignment`

Do not reopen Main Boss 01 unless Anchor Sync Check fails or new state-boundary evidence appears.

## First Required Move

Run Anchor Sync Check first.

Use the existing saved mechanism:

`BRAIN_LEARNING/CLEAN_SEED_ANCHOR_SYNC_CHECK_20260518.md`

The check must confirm the active anchor still points cleanly into Main Boss 02 and that Boss 01 remains closed for MVP scope.

If Anchor Sync Check fails, stop and repair the anchor/state issue before touching Boss 02.

## Main Boss 02 Job

Perform a dry inspection only.

Do not install a lifecycle rule yet.

The inspection must prove the exact lifecycle gap before any fix is written.

Inspect this lifecycle flow:

`candidate -> testing -> parked/rejected/installed -> worn -> promoted/rolled-back`

## What To Look For

Check whether the brain already has clear, non-conflicting rules for each lifecycle state:

- `candidate`: a new idea, helper, rule, method, metaphor, file, tool, or outside pattern that may help the model.
- `testing`: a candidate being checked through fit, neighbor impact, proof, and limited use.
- `parked`: useful but not ready; held safely without becoming active doctrine.
- `rejected`: proven not to fit, or unsafe for the model/core/lane.
- `installed`: accepted into the correct lane/file after proof.
- `worn`: used as part of the operating suit after installation, not merely saved.
- `promoted`: raised into stronger authority only after repeated fit/proof/use.
- `rolled-back`: removed or demoted after failure, drift, collision, or bad proof.

Find where the chain is missing, fuzzy, duplicated, contradictory, or unsafe.

## Expected Mule Output

Create a dry inspection note only.

The note should identify:

1. Current source files checked.
2. Existing lifecycle language already present.
3. Missing lifecycle states.
4. Conflicting or duplicated lifecycle ideas.
5. Weakest lifecycle gap.
6. Neighbor rules touched.
7. Whether a lifecycle rule is actually needed.
8. Exact recommended smallest clean fix.
9. Proof required before any install.
10. Final verdict: `PASS`, `PARTIAL`, `FAIL`, or `BLOCKED`.

## Save Location

Save the inspection note under a non-doctrine lane unless a better existing lane clearly fits.

Preferred location:

`BRAIN_LEARNING/MAIN_BOSS_02_LIFECYCLE_DRY_INSPECTION_20260518.md`

If the inspection produces proof receipt material, save receipt under:

`PROOF_HISTORY/MAIN_BOSS_02_LIFECYCLE_DRY_INSPECTION_RECEIPT_20260518.txt`

Remember: `PROOF_HISTORY` may be ignored by git, so use intentional force-add only if the receipt belongs in the save package.

## Blocked Moves

Do not fight the full 50-boss list.

Do not fight all 9 parent bosses.

Do not reopen Main Boss 01 unless Anchor Sync Check fails or a new state-alignment child appears.

Do not build the status command runtime lane.

Do not create `/system`.

Do not create a live runtime file.

Do not promote source-ore into active doctrine.

Do not wear an unproven fix.

Do not let metaphor outrank proof.

Do not install a lifecycle rule during dry inspection.

Do not dump Soft Suit candidates into active files.

Do not treat source-ore as doctrine.

## Operating Method

Use the current Clean Seed method:

Capture first.

Sort before judgment.

Respect neighboring lanes.

Fight only the current boss.

Prefer the smallest clean fix.

Proof decides.

If more issues appear, capture and park them instead of expanding the boss.

The current boss is only lifecycle-state clarity.

## Commit Guidance

After the dry inspection file is written and proof receipt is created if needed:

1. Review changed files.
2. Confirm no blocked lane was created.
3. Confirm no lifecycle rule was installed unless a separate approved install step was explicitly started.
4. Add only the inspection file and related receipt.
5. Commit with a clear message.
6. Push.
7. Confirm final status is clean.

Suggested commit message:

`Inspect lifecycle state machine boss`

## Stop Conditions

Stop and report instead of continuing if:

- Anchor Sync Check fails.
- Main Boss 01 appears reopened by contradiction.
- The lifecycle gap cannot be proven.
- A needed neighbor file is missing.
- A proposed fix would require `/system`, runtime command work, live files, or source-ore promotion.
- The task starts expanding into the full boss list.

## Final Handoff Back

Return with:

- commit hash
- files changed
- verdict
- exact lifecycle gap found
- whether install is recommended next
- final `git status --short` result
