# DUAL_COMMAND_CENTER_SYNC_CONTRACT_L0

Status: L0 SYNC CONTRACT / REVIEW PACKET / NOT INSTALLED
Date: 2026-06-06
SourceBasis: Batch 10G - Dual Command Center Sync Contract / No Split-Brain Standard

This file is included because the source supports the optional sync/no split-brain contract. It does not create live sync, a watcher, or automation.

## Parent Rule

`DUAL_COMMAND_CENTER_SYNC_CONTRACT_V0_1`

Core wording:

`USER_COMMAND_CENTER AND ASSISTANT_COMMAND_CENTER MUST BE KEPT CONSISTENT BY A DECLARED SYNC CONTRACT. BACKSTAGE MAY PROJECT STATUS UPWARD. USER CENTER MAY PROJECT APPROVAL / BLOCK / ACTIVE INTENT DOWNWARD. ANY MISMATCH BECOMES A BLOCKER.`

Carry line:

`USER CENTER IS THE AUTHORITY VIEW. ASSISTANT CENTER IS THE DETAIL STATE. THEY MUST DISAGREE LOUDLY, NEVER QUIETLY.`

## Sync Flows

USER -> ASSISTANT:

- intent
- approval
- block
- acceptance
- selected active job

ASSISTANT -> USER:

- status
- receipt verdict
- blockers
- next legal action
- DoesNotProve

No third hidden flow.

No actor writes directly to the user dashboard unless the assistant center judges the receipt and projects a user-safe summary.

## Source of Truth by Field

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

Failure label:

`FIELD_OWNERSHIP_CONFLICT`

## Projection Rule

The user dashboard should not duplicate the entire assistant state. It should project it.

Projection means:

- take detailed assistant state
- reduce to user-safe summary
- preserve blockers and DoesNotProve
- show proof pointer
- do not create new authority

Forbidden projection phrases:

- Mule done.
- Root clean.
- Job complete.
- Mutation authorized.
- Rules protected.

Unless the required receipt, judgment, human approval, and sync evidence actually support those exact claims.

## User-to-Assistant Events

Allowed user-to-assistant events:

- ACTIVE_JOB_SELECTED
- USER_BLOCK_SET
- USER_BLOCK_CLEARED
- HUMAN_APPROVAL_RECORDED
- RECEIPT_ACCEPTED_BY_USER
- RECEIPT_REJECTED_BY_USER
- NEXT_ACTION_SELECTED

These become assistant-side events in UI_EVENT_LOG.jsonl and, where relevant, ACTIVE_OBJECT.json, HUMAN_REVIEW_QUEUE.csv, BLOCKER_BOARD.json, or WORK_TOKEN_LEDGER.csv.

## Assistant-to-User Events

Allowed assistant-to-user projections:

- ACTOR_STATUS
- RECEIPT_RETURNED
- RECEIPT_JUDGE_VERDICT
- BLOCKER_OPENED
- BLOCKER_CLEARED
- GUARD_STATUS
- BYTE_ACCOUNTING_SUMMARY
- ROOT_INTAKE_STATUS
- NEXT_LEGAL_ACTION_PROPOSED

These update user-facing projection files:

- USER_DASHBOARD.md
- ACTIVE_JOB.md
- BLOCKERS.md
- RECENT_RECEIPTS.md
- DOES_NOT_PROVE.md
- NEXT_LEGAL_ACTION.md

Assistant projection cannot create approval.

Rule:

`ASSISTANT MAY PROJECT STATUS. USER MUST AUTHORIZE RISK.`

## Sync Event Schema

Every sync must be logged:

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

Allowed directions:

- USER_TO_ASSISTANT
- ASSISTANT_TO_USER

Blocked directions:

- ACTOR_TO_USER_DIRECT
- ACTOR_TO_ROOT_DIRECT
- ASSISTANT_TO_USER_APPROVAL_FABRICATED
- USER_TO_ACTOR_WITHOUT_PACKET

Failure labels:

- SYNC_EVENT_MISSING
- UNLOGGED_USER_DASHBOARD_CHANGE
- UNLOGGED_ASSISTANT_STATE_CHANGE
- ACTOR_BYPASSED_ASSISTANT_CENTER
- ASSISTANT_FABRICATED_USER_AUTHORITY

## Split-Brain Detection

Before any closeout, compare:

- USER_DASHBOARD.md against ACTIVE_OBJECT.json.
- ACTIVE_JOB.md against WORK_TOKEN_LEDGER.csv.
- RECENT_RECEIPTS.md against RECEIPT_INDEX.csv.
- BLOCKERS.md against BLOCKER_BOARD.json.
- HUMAN_APPROVALS.md against HUMAN_REVIEW_QUEUE.csv.
- DOES_NOT_PROVE.md against all current active receipts.

If mismatch:

`DUAL_CENTER_SPLIT_BRAIN_BLOCK`

No mutation. No closeout. No done.

## Dashboard Update Rules

USER_DASHBOARD.md inputs:

- ACTIVE_OBJECT.json
- ACTOR_BOARD.json
- RECEIPT_INDEX.csv
- BLOCKER_BOARD.json
- GUARD_STATUS.json
- BYTE_ACCOUNTING_LEDGER.csv

ACTIVE_JOB.md inputs:

- ACTIVE_OBJECT.json
- WORK_TOKEN_LEDGER.csv
- CUSTODY_PACKET_INDEX.csv
- RECEIPT_INDEX.csv

BLOCKERS.md input:

- BLOCKER_BOARD.json

HUMAN_APPROVALS.md input:

- HUMAN_REVIEW_QUEUE.csv

RECENT_RECEIPTS.md input:

- RECEIPT_INDEX.csv

DOES_NOT_PROVE.md inputs:

- active object
- active receipt
- blocker board
- guard status
- human review queue

Rule:

`USER FILES ARE PROJECTIONS FROM STATE PLUS USER DECISIONS.`

## User Decisions Must Not Be Overwritten

Protected user fields:

- HumanDecision
- MutationAuthorized
- UserBlock
- ReceiptAcceptedByUser
- ReceiptRejectedByUser
- SelectedNextAction
- UserNotes

If assistant sync tries to overwrite these without a user event:

`USER_AUTHORITY_OVERWRITE_ATTEMPT`

Freeze and report.

## Assistant State Must Not Hide Bad News

Projection upward must include:

- blockers
- rejected receipts
- missing packets
- guard gaps
- false completion risk
- DoesNotProve

Failure label:

`ASSISTANT_PROJECTION_SANITIZED_BAD_NEWS`

## Sync Guard Report

Future live report target:

`_LOCAL_CUSTODY_N_RECEIPTS/ASSISTANT_COMMAND_CENTER_STATE/DUAL_COMMAND_CENTER_SYNC_GUARD_REPORT.md`

Report fields:

```text
DUAL_COMMAND_CENTER_SYNC_GUARD_REPORT

Status:
CheckedUtc:
UserCenterPath:
AssistantStatePath:

UserDashboardMatchesActiveObject:
ActiveJobMatchesWorkToken:
RecentReceiptsMatchReceiptIndex:
BlockersMatchBlockerBoard:
HumanApprovalsMatchReviewQueue:
DoesNotProvePreserved:

SplitBrainFound:
SplitBrainItems:

UserAuthorityOverwriteAttempt:
AssistantProjectionSanitizedBadNews:
ActorDirectToUserBypass:

FinalVerdict:
NextLegalAction:
```

Verdicts:

- SYNC_PASS
- SYNC_PASS_WITH_WARNINGS
- SYNC_BLOCKED_SPLIT_BRAIN
- SYNC_BLOCKED_USER_AUTHORITY_OVERWRITE
- SYNC_BLOCKED_ASSISTANT_BAD_NEWS_HIDDEN
- SYNC_BLOCKED_ACTOR_BYPASS

## No Silent Auto-Sync

Allowed:

`refresh dashboard from state and write sync event`

Blocked:

`rewrite dashboard silently`

Rule:

`EVERY DASHBOARD CHANGE NEEDS A SYNC EVENT.`

## Does Not Prove

This contract does not prove live sync exists, does not install a watcher, does not authorize automation, and does not prove either command center is currently consistent.

## Next Legal Action

Review the contract. If accepted, prepare a separate sync-guard install or test packet before live use.

