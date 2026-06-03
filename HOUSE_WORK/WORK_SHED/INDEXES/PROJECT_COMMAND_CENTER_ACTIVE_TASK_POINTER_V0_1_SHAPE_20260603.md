# Project Command Center Active Task Pointer V0.1 Shape

Saved: 20260603_132134

## Purpose

Define the fields needed so phrases like inspect last task and save gate can resolve to the correct current object.

## Fields

ActiveLane:
ActiveObject:
ActiveStage:
LastRunId:
LastDesignReport:
LastGuardReceipt:
LastGuardReviewReport:
LastRunReport:
LastVerifyReport:
ProofState:
NextLegalAction:
BlockedPowers:
DoesNotProve:
StopLine:

## Current example

ActiveLane: HOUSE_DOCK_CONTROL_ROOM
ActiveObject: HOUSE_DOCK_MICRO_003_INSPECT_FACE
ActiveStage: VERIFIED_READY_FOR_SAVE
ProofState: DESIGN_PASS, GUARD_REVIEW_PASS, RUN_PASS, VERIFY_PASS
NextLegalAction: SAVE_GATE
BlockedPowers: MICRO_004, FULL_UI, TOOL_EXECUTION, WATCHER, DELETE, MOVE, CLEANUP, ACTIVE_GUIDES_REWRITE, CURRENT_TRUTH_INDEX_REWRITE

## StopLine

Do not allow command grammar execution until active task pointer and confirmation card are both proven.
