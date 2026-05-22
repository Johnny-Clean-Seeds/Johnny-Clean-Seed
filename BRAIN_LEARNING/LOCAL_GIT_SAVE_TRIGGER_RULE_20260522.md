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
4. Verify clean status before write.
5. Write files to correct lanes.
6. Write a receipt.
7. Stage expected files.
8. Force-add ignored proof receipts when intentionally saving proof.
9. Run diff checks.
10. Commit.
11. Push.
12. Confirm remote HEAD matches local HEAD.
13. Confirm final status clean.

## Exceptions

Do not save when the user explicitly says not to save.

Do not save when blocked by safety, dirty state, wrong base, missing proof, unclear authority, destructive risk, or wrong phase.

When blocked, stop and name the blocker.

## Boundary

This rule does not promote material.

This rule does not rewrite doctrine.

This rule does not rewrite ACTIVE_GUIDES.

This rule does not rewrite CURRENT_TRUTH_INDEX.
