# DUAL_COMMAND_CENTER_L0_STATE_LEDGER_SCHEMAS

Status: L0 SCHEMAS / REVIEW PACKET / NOT INSTALLED
Date: 2026-06-06
SourceBasis: Batches 10B, 10F, and 10G

This file extracts the first state and ledger schemas for the dual command center. It defines headers, JSON shells, JSONL formats, and source-of-truth fields. It does not create live state.

## General Rules

- CSV ledgers start header-only.
- JSONL logs start empty.
- JSON state starts closed and safe.
- Empty state does not prove no events happened elsewhere.
- No starter file may claim mutation authority.
- No receipt row is accepted until judged.
- No user dashboard value may conflict silently with assistant state.

## CSV Headers

WORK_TOKEN_LEDGER.csv:

```text
WorkTokenId,ActiveObject,SelectedActor,OperatingMode,WorkingLane,InputScope,OutputScope,MutationAuthority,StartedUtc,ExpectedReturn,StopConditions,Status,ReceiptPath,ReceiptSHA256,CloseVerdict
```

ROUTER_LEDGER.csv:

```text
RouterDecisionId,CreatedUtc,UserRequest,ActiveObject,DetectedScents,SelectedActor,RejectedActors,WhySelected,WhyRejected,WorkingLane,CustodyPacketPath,AllowedMutationLevel,ForbiddenActions,ExpectedReceipt,WorkTokenId,Status,DoesNotProve
```

CUSTODY_PACKET_INDEX.csv:

```text
PacketId,ActiveObject,Actor,PacketPath,ActorReadableSurface,InstalledWhereActorReads,AllowedMutationLevel,ForbiddenActionsPresent,LosslessCustodyPresent,RootIntakeRulePresent,StopConditionsPresent,DoesNotProvePresent,PacketSHA256,Verdict
```

RECEIPT_INDEX.csv:

```text
ReceiptId,ActiveObject,Actor,ReceiptPath,ReceiptSHA256,Status,ActiveJobDone,RootIntakeDone,Deleted,Moved,Compressed,Archived,Deduped,RestoredInPlace,RecycleBinEmptied,Committed,Pushed,RowsExpected,RowsProcessed,CountsMatched,HashesPresent,DoesNotProvePresent,NextLegalActionPresent,JudgeVerdict
```

HUMAN_REVIEW_QUEUE.csv:

```text
DecisionItem,OriginalPath,CurrentCustodyPath,ProposedAction,RiskLevel,Bytes,HashEvidence,DuplicateEvidence,AccountingStatus,WhyThisMatters,RiskIfApproved,RiskIfDenied,AllowedChoices,HumanDecision,MutationAuthorized,RequiredReceipt,DoesNotProve
```

ROOT_INTAKE_QUEUE.csv:

```text
DetectedUtc,RootFilePath,SizeBytes,SHA256Before,LikelyPurpose,RouteDecision,RoutedPath,SHA256After,RouteReceipt,ActiveObjectBeforeRootIntake,ActiveJobContinued,ActiveJobDone,DoesNotProve
```

ARTIFACT_INDEX.csv:

```text
ArtifactId,TraceId,ActiveObject,Actor,ArtifactType,Path,SHA256,Bytes,CreatedUtc,Purpose,OwnerActor,CustodyLane,RetentionClass,MayDelete,DeleteAuthority,DoesNotProve
```

CATALOG.csv:

```text
EntityId,EntityKind,Name,Owner,Layer,AuthorityBoundary,ReadableBy,WritableBy,MayApproveMutation,MayExecuteMutation,MayAcceptReceipt,Path,ProofPointer,DoesNotProve
```

BYTE_ACCOUNTING_LEDGER.csv:

```text
SnapshotId,CapturedUtc,Current123TotalBytes,Current123TotalMB,RecoveryCustodyFolderBytes,RecoveryCustodyFolderMB,RecoveredPayloadBytes,RecoveredPayloadMB,LiveWorkspaceEstimatedBytesExcludingRecoveryCustody,LiveWorkspaceEstimatedMBExcludingRecoveryCustody,RestoreLiveCandidateBytes,KeepCustodyCandidateBytes,ArchiveCustodyCandidateBytes,DuplicateProvenBytes,UnknownReviewBytes,OrphanMetadataOriginalBytes,CleanupAuthorized,RecoveryCustodyMayBeDeleted,RecycleBinMayBeEmptied,ReceiptPath,ReceiptSHA256
```

## JSON Shells

ACTIVE_OBJECT.json:

```json
{
  "ActiveObjectId": "",
  "Title": "NO_ACTIVE_JOB",
  "CreatedUtc": "",
  "CurrentRoom": "USER_COMMAND_CENTER",
  "CurrentToolbelt": "READ_ROUTE_JUDGE_ONLY",
  "CurrentActor": "NONE",
  "CurrentState": "IDLE",
  "WorkingLane": "C:\\Users\\13527\\Desktop\\123",
  "ProofPointer": "",
  "CustodyPacketPath": "",
  "WorkTokenId": "",
  "NextCondition": "USER_SELECTS_ACTIVE_JOB",
  "BlockedReason": "",
  "DoesNotProve": [
    "Idle command center does not prove any worker has completed anything.",
    "No mutation is authorized by default."
  ]
}
```

Allowed CurrentState values:

- DRAFT
- PACKET_READY
- ACTOR_ASSIGNED
- WORKING
- PAUSED
- BLOCKED
- RETURNED_WITH_RECEIPT
- RECEIPT_REVIEW
- ACCEPTED
- REJECTED
- SUPERSEDED
- CLOSED

Mutation states:

- HUMAN_REVIEW_REQUIRED
- HUMAN_APPROVED_EXACT_SCOPE
- MUTATION_PACKET_READY
- MUTATION_EXECUTED
- MUTATION_RECEIPT_REVIEW
- MUTATION_ACCEPTED
- MUTATION_REJECTED

Forbidden jumps:

- DRAFT -> CLOSED
- ROOT_INTAKE -> CLOSED
- HUMAN_APPROVED -> MUTATION_EXECUTED

ACTOR_BOARD.json:

```json
[
  {
    "Actor": "CHATGPT",
    "Status": "IDLE",
    "ActiveObject": "",
    "OperatingMode": "PLANNING_AND_REVIEW",
    "AllowedMutationLevel": "NO_LOCAL_MUTATION",
    "WorkTokenId": "",
    "CurrentPacket": "",
    "LastReceipt": "",
    "LastReceiptSHA256": "",
    "BlockedReason": "",
    "NextLegalAction": ""
  },
  {
    "Actor": "CODEX",
    "Status": "IDLE",
    "ActiveObject": "",
    "OperatingMode": "",
    "AllowedMutationLevel": "BLOCKED_UNTIL_PACKET",
    "WorkTokenId": "",
    "CurrentPacket": "",
    "LastReceipt": "",
    "LastReceiptSHA256": "",
    "BlockedReason": "No Codex custody packet installed.",
    "NextLegalAction": "Install/read AGENTS.md or Codex task packet before assigning."
  },
  {
    "Actor": "MULE",
    "Status": "IDLE",
    "ActiveObject": "",
    "OperatingMode": "",
    "AllowedMutationLevel": "BLOCKED_UNTIL_PACKET",
    "WorkTokenId": "",
    "CurrentPacket": "",
    "LastReceipt": "",
    "LastReceiptSHA256": "",
    "BlockedReason": "No mule order active.",
    "NextLegalAction": "Create exact mule order before assigning."
  },
  {
    "Actor": "GUARD_AGENT",
    "Status": "IDLE",
    "ActiveObject": "",
    "OperatingMode": "",
    "AllowedMutationLevel": "READ_ONLY_GUARD_AUDIT",
    "WorkTokenId": "",
    "CurrentPacket": "",
    "LastReceipt": "",
    "LastReceiptSHA256": "",
    "BlockedReason": "",
    "NextLegalAction": ""
  },
  {
    "Actor": "HUMAN_REVIEW",
    "Status": "IDLE",
    "ActiveObject": "",
    "OperatingMode": "APPROVAL_ONLY",
    "AllowedMutationLevel": "APPROVE_OR_BLOCK_EXACT_SCOPE",
    "WorkTokenId": "",
    "CurrentPacket": "",
    "LastReceipt": "",
    "LastReceiptSHA256": "",
    "BlockedReason": "",
    "NextLegalAction": ""
  }
]
```

Allowed actor statuses:

- IDLE
- ASSIGNED
- WORKING
- WAITING_FOR_RECEIPT
- WAITING_FOR_HUMAN
- PAUSED
- BLOCKED
- RETURNED
- REJECTED
- CLOSED

BLOCKER_BOARD.json:

```json
{
  "BlockerId": "",
  "ActiveObject": "",
  "DetectedUtc": "",
  "BlockerType": "",
  "Source": "",
  "WhyBlocked": "",
  "RequiredToClear": "",
  "MutationFrozen": true,
  "NextLegalAction": ""
}
```

Blocker types:

- PATH_UNCLEAR
- PACKET_MISSING
- PACKET_NOT_ACTOR_READABLE
- HUMAN_REVIEW_REQUIRED
- LOSSLESS_ACCOUNTING_MISSING
- GUARD_SEMANTIC_GAP
- RECEIPT_INCOMPLETE
- ACTOR_CONFLICT
- PARSER_CONTROL_FAILURE
- ROOT_INTAKE_DONE_ACTIVE_JOB_OPEN
- COUNT_MISMATCH
- HASH_MISMATCH

GUARD_STATUS.json:

```json
{
  "ProtectedFamily": "LOSSLESS_CUSTODY_ACCOUNTING_FAMILY",
  "ProtectedCoreText": "NO MATERIAL LEAVES ACTIVE OR CUSTODY LANES WITHOUT FULL ACCOUNTING.",
  "ProofLevel": "",
  "PresenceCheckPassed": false,
  "RepairCheckPassed": false,
  "SemanticWeakeningCheckPassed": false,
  "BypassCheckPassed": false,
  "ParallelFamilyCheckPassed": false,
  "MutationScriptCheckPassed": false,
  "HandoffSurfaceCheckPassed": false,
  "NonInterventionCheckPassed": false,
  "ActorSurfaceCoverage": {},
  "LastGuardReceipt": "",
  "LastGuardReceiptSHA256": "",
  "GapsRemaining": []
}
```

Proof levels:

- NO_GUARD
- PRESENCE_ONLY
- REPAIR_STRONG
- SEMANTIC_STRONG
- NON_INTERVENTION_STRONG
- HANDOFF_ENFORCED

## JSONL Formats

HANDOFF_TRACE.jsonl, one JSON object per line:

```json
{
  "HandoffId": "",
  "CreatedUtc": "",
  "FromActor": "",
  "ToActor": "",
  "ActiveObject": "",
  "WhyHandoff": "",
  "CustodyPacket": "",
  "AllowedMutationLevel": "",
  "ExpectedReceipt": "",
  "ReturnToActor": "",
  "DoesNotProve": [],
  "Status": ""
}
```

UI_EVENT_LOG.jsonl, one JSON object per line:

```json
{
  "EventId": "",
  "CreatedUtc": "",
  "UserOrActor": "",
  "EventType": "QUERY",
  "TargetObject": "",
  "RequestedAction": "",
  "AuthorityRequired": "",
  "PacketRequired": "",
  "MutationPossible": false,
  "Result": "",
  "ReceiptPath": "",
  "DoesNotProve": []
}
```

Allowed event types:

- QUERY
- SIGNAL
- UPDATE
- MUTATION_REQUEST
- MUTATION_EXECUTION

SYNC event schema from Batch 10G:

```json
{
  "SyncEventId": "",
  "CreatedUtc": "",
  "Direction": "USER_TO_ASSISTANT",
  "SourceFile": "",
  "TargetFile": "",
  "ActiveObject": "",
  "FieldChanged": "",
  "OldValue": "",
  "NewValue": "",
  "AuthorityOwner": "",
  "ReceiptPath": "",
  "DoesNotProve": [],
  "Verdict": ""
}
```

Allowed sync directions:

- USER_TO_ASSISTANT
- ASSISTANT_TO_USER

Blocked sync directions:

- ACTOR_TO_USER_DIRECT
- ACTOR_TO_ROOT_DIRECT
- ASSISTANT_TO_USER_APPROVAL_FABRICATED
- USER_TO_ACTOR_WITHOUT_PACKET

## Field Ownership

| Field / truth | Source of truth |
|---|---|
| User intent | USER_COMMAND_CENTER |
| Human approval | USER_COMMAND_CENTER |
| Final accept / reject | USER_COMMAND_CENTER |
| Mutation authorization | USER_COMMAND_CENTER + mutation packet |
| Active object | USER_COMMAND_CENTER, mirrored to assistant state |
| Actor assignment | ASSISTANT_COMMAND_CENTER |
| Custody packet readiness | ASSISTANT_COMMAND_CENTER |
| Work token state | ASSISTANT_COMMAND_CENTER |
| Receipt completeness | ASSISTANT_COMMAND_CENTER |
| Receipt final acceptance | USER_COMMAND_CENTER after assistant judge |
| Guard proof level | ASSISTANT_COMMAND_CENTER |
| Byte accounting | ASSISTANT_COMMAND_CENTER |
| Root intake state | ASSISTANT_COMMAND_CENTER, projected to user |
| DoesNotProve | BOTH; must match or merge upward |
| Next legal action | ASSISTANT_COMMAND_CENTER proposes, USER_COMMAND_CENTER confirms |

Hard rule:

`NO FIELD WITHOUT OWNER.`

If two files claim ownership of the same field, freeze:

`FIELD_OWNERSHIP_CONFLICT`

## Receipt Verdicts

Receipt judge verdicts:

- RECEIPT_ACCEPTED
- RECEIPT_INCOMPLETE
- FALSE_COMPLETION
- COUNT_MISMATCH
- HASH_MISMATCH
- MUTATION_FLAG_MISSING
- DOES_NOT_PROVE_DROPPED
- ACTIVE_JOB_NOT_DONE
- ROOT_INTAKE_ONLY

Completion rule:

`DONE IS A JUDGED STATE, NOT A WORKER WORD.`

## Does Not Prove

These schemas do not prove that the live state exists, that any ledger row is true, that any receipt is accepted, or that mutation is authorized.

