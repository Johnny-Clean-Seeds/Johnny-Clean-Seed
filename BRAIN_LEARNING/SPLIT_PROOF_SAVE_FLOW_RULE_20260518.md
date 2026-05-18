# Split Proof / Save Flow Rule

Status: ACTIVE LEARNING RULE AFTER SAVE
Authority: assistant behavior rule; not command authority

## Purpose

Risky Mr.Kleen command blocks must not keep proof and save in one long flow when failure continuation would be costly.

This rule exists because proof has failed, but commit/push commands were still manually continued afterward.

The fix is to split risky work into two phases.

## Core Rule

For risky project-changing work:

Phase 1:
write or update files, run checks, create proof receipt, print receipt, then stop.

Phase 2:
only after Phase 1 shows PASS, run git add, commit, push, final status, and final log.

## Trigger

Use split proof/save flow when:

- proof has many checks
- proof failure would require a repair receipt
- public history could get noisy
- commit/push would appear after a throw guard
- the task touches ACTIVE_ANCHOR.txt
- the task touches PROOF_HISTORY
- the task touches CURRENT_HOUSE_WORK_STATUS.md
- the task touches learning rules
- the task touches room structure
- the task is repairing a previous proof/save mistake
- the user may manually continue after a thrown proof failure

## Phase 1 Requirements

Phase 1 must:

- verify clean starting status
- verify expected head when needed
- write intended files
- run checks
- create proof receipt
- print proof receipt
- throw if checks fail
- stop without git add, commit, or push

## Phase 2 Requirements

Phase 2 may only run after Phase 1 PASS.

Phase 2 must:

- verify clean or expected changed files
- verify proof receipt says PASS
- git add only intended files
- commit
- push
- show final status
- show final position

## Blocked Behavior

Do not put git add, commit, or push after a risky proof phase in the same pasted block.

Do not continue downstream of failed proof.

Do not treat a proof receipt as valid if it says FAIL.

Do not make the user manually remember which commands are unsafe after proof failure.

Do not rewrite history to hide the mistake.

## Relationship To Work Shed

Failed Proof Commit Guard is the front-shelf helper.

Split Proof / Save Flow is the stronger operating rule.

The Work Shed may capture future proof/save failures, but the goal is to prevent recurrence.

## Closing Rule

Risky proof first.

Save second.

Never commit after failed proof.

Proof decides.
