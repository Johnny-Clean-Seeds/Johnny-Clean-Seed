# Project Command Center Pointer Read/Write Rules V0.4 Shape

Saved: 20260603_133312

## Pointer write receipt shape

{
  "ReceiptType": "POINTER_WRITE_RECEIPT",
  "ReceiptVersion": "V0.4_DESIGN",
  "GeneratedAt": "ISO-8601",
  "WriteReason": "SAVE_GATE_PASS",
  "Trigger": "COMMAND_GRAMMAR_V0_3_SAVE_PASS",
  "OldPointerPath": "path",
  "OldPointerSHA256": "hash",
  "NewPointerPath": "path",
  "NewPointerSHA256": "hash",
  "ChangedFields": [],
  "EvidencePath": "path",
  "EvidenceSHA256": "hash",
  "RepoHead": "hash",
  "RepoOriginMain": "hash",
  "RepoClean": true,
  "DoesNotProve": "Pointer receipt proves only this pointer update.",
  "StopLine": "Do not execute from pointer without confirmation card."
}

## Pointer repair card fields

CardType:
POINTER_REPAIR_CARD

VisibleIssue:
PointerPath:
PointerSHA256:
DetectedProblem:
CandidateActiveObjects:
EvidenceForEachCandidate:
RecommendedRepair:
FilesToRead:
FilesToWrite:
ConfirmationRequired:
DoesNotProve:
StopLine:

## Pointer read result card fields

ResolvedCommand:
ReadPointer:
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

## StopLine

The pointer resolves state. It does not execute, save, or mutate by itself.
