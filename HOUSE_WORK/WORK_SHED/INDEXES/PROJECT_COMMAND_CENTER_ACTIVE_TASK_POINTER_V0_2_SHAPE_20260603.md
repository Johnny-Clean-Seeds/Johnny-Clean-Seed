# Project Command Center Active Task Pointer V0.2 Shape

Saved: 20260603_132531

## Shape

{
  "PointerId": "HOUSE_DOCK_CURRENT_TASK",
  "PointerVersion": "V0.2_SHAPE",
  "UpdatedAt": "ISO-8601",
  "UpdatedBy": "COMMAND_CENTER_OR_ASSISTANT",
  "ActiveLane": "HOUSE_DOCK_CONTROL_ROOM",
  "ActiveObject": "HOUSE_DOCK_MICRO_003_INSPECT_FACE",
  "ActiveStage": "VERIFIED_AND_SAVED_CONTEXT_READY",
  "ActiveMode": "READ_ONLY_FACE_PROVEN_COMMAND_GRAMMAR_DESIGN_ACTIVE",
  "ActiveRunId": null,
  "LastCompletedStep": "COMMAND_GRAMMAR_V0_1_DESIGN_SAVED_AND_PUSHED",
  "CurrentProofState": [
    "MICRO_003_DESIGN_PASS",
    "MICRO_003_GUARD_REVIEW_PASS",
    "MICRO_003_RUN_PASS",
    "MICRO_003_VERIFY_PASS",
    "MICRO_003_AND_COMMAND_GRAMMAR_GOAL_SAVE_PASS",
    "COMMAND_GRAMMAR_V0_1_DESIGN_SAVE_PASS"
  ],
  "NextLegalAction": "COMMAND_GRAMMAR_V0_2_ACTIVE_TASK_POINTER_DESIGN_SAVE_GATE",
  "NextLegalActionMode": "SAVE_GATE",
  "NextActionRequiresConfirmation": true,
  "AllowedPowers": [
    "read_current_repo_status",
    "read_saved_v0_1_command_grammar_files",
    "write_bounded_design_or_save_reports_after_confirmation"
  ],
  "BlockedPowers": [
    "implementation",
    "full_ui",
    "micro_004",
    "tool_execution",
    "watcher",
    "move",
    "delete",
    "cleanup",
    "git_without_confirmation",
    "ACTIVE_GUIDES_rewrite",
    "CURRENT_TRUTH_INDEX_rewrite",
    "doctrine_rewrite"
  ],
  "FilesToRead": [],
  "FilesToWrite": [],
  "FilesToStage": [],
  "FilesToNeverTouch": [
    "ACTIVE_GUIDES",
    "CURRENT_TRUTH_INDEX"
  ],
  "EvidenceReports": [],
  "GuardReceipts": [],
  "RunReports": [],
  "VerifyReports": [],
  "SaveReceipts": [],
  "RepoHead": null,
  "RepoOriginMain": null,
  "RepoCleanRequired": true,
  "DoesNotProve": "This pointer shape does not implement mutable pointer state.",
  "StopLine": "Do not execute commands from this pointer until confirmation card and pointer read/write rules are proven.",
  "PointerStatus": "DESIGN_SHAPE_ONLY",
  "CloseCondition": "Save gate passes and next active object is selected.",
  "RepairCondition": "Missing, stale, contradictory, or closed pointer used as active state."
}

## Inspection card fields

ResolvedCommand:
PointerStatus:
ActiveLane:
ActiveObject:
ActiveStage:
CurrentProofState:
NextLegalAction:
BlockedPowers:
FilesToRead:
DoesNotProve:
StopLine:

## Save gate card fields

ResolvedCommand:
ActiveObject:
ProofReady:
RequiredEvidence:
FilesToStage:
IgnoredPathPolicy:
GitPlan:
ConfirmBeforeAction:

## StopLine

The pointer resolves state. It does not execute, save, or mutate by itself.
