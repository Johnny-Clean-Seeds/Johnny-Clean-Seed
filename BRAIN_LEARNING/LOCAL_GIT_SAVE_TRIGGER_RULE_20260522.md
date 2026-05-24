# Local + Git Save Trigger Rule

Date: 20260522_045333

Status: active save-discipline rule.

## Rule

Any durable house-relevant material must be saved to the local Mr.Kleen house and pushed to Git when it is accepted into the house.

This trigger fires from the work type itself.

It must not depend on the user saying save.

## Triggers

This applies to durable house material, including:

1. Rules.
2. Methods.
3. Handoff processes.
4. Receipts.
5. Proof results.
6. Current-position notes.
7. Candidate systems.
8. Lessons from problems.
9. Mule or helper process standards.
10. Alarm/debugger filing structures.
11. Parking decisions.
12. Phase-boundary decisions.
13. Growth-stage operating behavior.
14. Editing/revision methods.
15. Linking-paper/evidence-chain methods.

## Save proof

A valid save must:

1. Verify repo.
2. Verify branch and base.
3. Verify remote base when relevant.
4. Inspect dirty status before write or broad staging.
5. Classify modified/untracked material with Git Dirty Tree Disposition Before Lock/Save Rule when
   the tree is not clean.
6. Write files to correct lanes.
7. Write a receipt.
8. Stage expected files only after classification.
9. Force-add ignored proof receipts when intentionally saving proof.
10. Run diff checks.
11. Commit.
12. Push.
13. Confirm remote HEAD matches local HEAD.
14. Confirm final status clean or name any intentional local-only/untracked hold.

## Exceptions

Do not save when the user explicitly says not to save.

Do not save when blocked by safety, dirty state, wrong base, missing proof, unclear authority, destructive risk, or wrong phase.

When blocked, stop and name the blocker.

## Boundary

This rule does not promote material.

This rule does not rewrite doctrine.

This rule does not rewrite ACTIVE_GUIDES.

This rule does not rewrite CURRENT_TRUTH_INDEX.
