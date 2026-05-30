# Lower-Level Error Powerplay Freeze Rule

Date: 2026-05-30
RuleKey: LOWER-LEVEL-ERROR-POWERPLAY-FREEZE-RULE-V1
WorkKey: LOWERLEVEL-ERROR-POWERPLAY-FREEZE-20260530
Status: RULE CANDIDATE SAVED / ACTIVE SOFT SUIT BEHAVIOR / NOT DOCTRINE

## Job

When the active work is a higher-level object and the failure appears in a lower/base layer, freeze the upper task and repair the lower layer first.

The system must not make the upper object pass by covering a lower-level defect.

## Trigger

Trigger this rule when work on a higher-level object exposes an error in any lower layer, including:

- script helper;
- save order;
- manifest or receipt order;
- Git staging;
- ignored-path handling;
- file custody;
- path or hash helper;
- parser or code-gate wrapper;
- proof runner;
- Chat Drop copy surface;
- operator command surface;
- local execution lane;
- report/receipt order;
- source-fit/source-custody layer.

## Required freeze

On trigger:

1. Stop the higher-level task.
2. Preserve the failure evidence.
3. Name the active upper object.
4. Name the failing lower layer.
5. Decide whether this is a true lower-level mechanism failure or only an upper-object typo.
6. If it is a lower-level mechanism failure, repair at the lowest true failing layer.
7. Prove the lower-level fix.
8. Resume the upper task only after the lower layer is clean.

## Dirty cover-fix ban

A repair is dirty if it makes the upper object pass while hiding the lower-level defect.

Do not call this clean:

- editing one save script while leaving the save-order generator pattern broken;
- correcting one manifest file while leaving manifest/receipt order wrong;
- making one Chat Drop pass while leaving stale/current custody unclear;
- forcing Git add without lane-first/hash-proof staging;
- rerunning a command until it works while ignoring a malformed operator command surface;
- treating Code Gate PASS as job PASS when the direct run exposes a lower layer failure.

## Powerplay classification

Lower-layer failure during higher-layer work is a Powerplay candidate by default.

Use this class:

`LOWER_LEVEL_ERROR_POWERPLAY_FREEZE`

Sub-verdicts:

- LOWER_LAYER_TRUE_FAILURE
- UPPER_OBJECT_LOCAL_BUG_ONLY
- COVER_FIX_ATTEMPT_BLOCKED
- LOWER_LAYER_REPAIR_REQUIRED
- LOWER_LAYER_REPAIR_PROVEN
- UPPER_TASK_RESUME_ALLOWED
- HISTORY_AUDIT_REQUIRED

## Required record fields

Every trigger record must include:

- ActiveUpperObject
- FailingLowerLayer
- FailureEvidence
- WhyThisIsNotJustUpperBug
- RepeatedHistoryCheck
- RootMechanism
- LowerLevelFix
- ProofOfFix
- UpperTaskResumeCondition
- BoundaryHeld
- ReturnPoint

## History audit trigger

If the same lower-layer family appears twice or appears after being supposedly repaired, run a history audit seed.

Ask:

- Did earlier work cover this by fixing only the upper object?
- Did a helper/script/template/generator keep producing the same lower-level defect?
- Did Code Gate only prove parser/probe while direct run exposed the real layer?
- Did a final PASS depend on a workaround that should have become a lower-layer rule?
- Did any previous receipt claim clean while carrying this hidden base defect?

The audit does not automatically invalidate prior work. It classifies risk and identifies where the base mechanism must be repaired.

## Resume rule

The upper task may resume only when:

- the lower-layer mechanism has a named fix;
- the fix has proof;
- the upper task's partial footprint is accounted for;
- no unrelated dirty repo/file state is being dragged forward;
- the resumed run states it is resuming after lower-level repair.

## Boundary

This rule is a Soft Suit behavior and saved rule candidate. It is not doctrine, not an ACTIVE_GUIDES rewrite, not CURRENT_TRUTH_INDEX, not automation, not a watcher, and not permission to broaden every error into a whole-house audit.

Short form:

If the floor breaks while building a higher room, stop building the room. Fix the floor. Prove the floor. Then resume the room.