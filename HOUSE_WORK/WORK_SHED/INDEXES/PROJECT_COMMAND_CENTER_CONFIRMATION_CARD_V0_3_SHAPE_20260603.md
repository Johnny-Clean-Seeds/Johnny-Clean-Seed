# Project Command Center Confirmation Card V0.3 Shape

Saved: 20260603_132904

## Shape

{
  "CardId": "CONFIRMATION_CARD_ID",
  "CardVersion": "V0.3_SHAPE",
  "GeneratedAt": "ISO-8601",
  "GeneratedBy": "COMMAND_CENTER_OR_ASSISTANT",
  "SourcePhrase": "user phrase",
  "ResolvedCommand": "SAVE_GATE_ACTIVE_OBJECT",
  "ResolvedTarget": "active object from pointer",
  "ResolutionConfidence": "HIGH | MEDIUM | LOW",
  "ResolutionEvidence": [],
  "ActivePointerId": "HOUSE_DOCK_CURRENT_TASK",
  "PointerStatus": "ACTIVE | READY_FOR_SAVE_GATE | STALE | AMBIGUOUS",
  "ActiveLane": "HOUSE_DOCK_CONTROL_ROOM",
  "ActiveObject": "OBJECT_NAME",
  "ActiveStage": "STAGE_NAME",
  "CurrentProofState": [],
  "ProposedAction": "ACTION_NAME",
  "ProposedActionMode": "READ_ONLY | SAVE_GATE | EXECUTE_REVIEWED_SCRIPT | DESIGN_ONLY",
  "RequiresConfirmation": true,
  "ConfirmationQuestion": "Confirm this exact action?",
  "AllowedPowers": [],
  "BlockedPowers": [],
  "FilesToRead": [],
  "FilesToWrite": [],
  "FilesToStage": [],
  "FilesToForceAdd": [],
  "FilesToNeverTouch": [],
  "CommandsToRun": [],
  "ScriptsToRun": [],
  "GuardPlan": null,
  "VerifierPlan": null,
  "GitPlan": null,
  "ExpectedOutputs": [],
  "ExpectedReceipts": [],
  "ExpectedFinalProof": [],
  "LowerIssueCheck": null,
  "DoesNotProve": "Card does not prove action is complete.",
  "StopLine": "Do not act unless proceed condition is met.",
  "UserOptions": ["YES", "NO", "INSPECT", "REPAIR", "CHANGE", "PAUSE"],
  "DefaultIfNoAnswer": "PAUSE_NO_ACTION",
  "ExpirationCondition": [],
  "ProceedCondition": "explicit user confirmation when required",
  "AbortCondition": "user says no, pause, changed state, expired card, or lower issue"
}

## Save gate minimum fields

ResolvedCommand:
ActiveObject:
ProofReady:
RequiredEvidence:
EvidenceHashes:
RepoFilesToWrite:
FilesToStage:
FilesToForceAdd:
IgnoredPathPolicy:
GitPlan:
ExpectedCommitMessage:
FinalProofRequired:
DoesNotProve:
StopLine:
ConfirmBeforeAction:

## Verifier run minimum fields

ResolvedCommand:
VerifierScriptPath:
VerifierScriptSHA256:
GuardReceiptPath:
GuardReceiptSHA256:
InputReports:
ExpectedOutputReport:
ExpectedOutputBoundary:
DoesNotProve:
StopLine:
ConfirmBeforeAction:

## Implementation run minimum fields

ResolvedCommand:
ImplementationScriptPath:
ImplementationScriptSHA256:
GuardReviewReport:
GuardReceipt:
AllowedWrites:
ForbiddenWrites:
ExpectedOutputs:
RollbackOrRepairPlan:
DoesNotProve:
StopLine:
ConfirmBeforeAction:

## Inspect card minimum fields

ResolvedCommand:
ResolvedTarget:
PointerStatus:
ActiveLane:
ActiveObject:
ActiveStage:
CurrentProofState:
NextLegalAction:
BlockedPowers:
FilesInspected:
DoesNotProve:
StopLine:

## StopLine

The confirmation card requests permission. It does not execute, save, or mutate by itself.
