# BATCH_02_HARD_CRITIQUE_AND_MISSING_LOGIC__DUAL_COMMAND_CENTER_AND_PROTOCOL_20260606

Date: 2026-06-06
Status: BATCH_02_COMPLETE / HARD_CRITIQUE / REPORT_ONLY / NOT_DOCTRINE / NO_LIVE_INSTALL
ActiveObject: CHUNKED_ACCEPTANCE_GROWTH_REVIEW_DUAL_COMMAND_CENTER_AND_PROTOCOL_20260606
Batch: 2 of 5
OutsideSourcesUsed: false
Reason: critique concerns internal packet fit, authority, receipts, and install gating; no outside pattern was needed

## Critique Position

The packet family is strong as candidate source material. It is not strong enough to trust for live install approval yet.

The main weakness is not missing philosophy. The main weakness is control surface completion: family-level manifest, hash coverage, human decision fields, install gate, and acceptance checklist are still too loose.

## Weak Wording

### Weak wording 1 - "ready" is overloaded

SOURCE_SUPPORTED:

- Files use `WORKING_ORDER_READY`, `READY_FOR_USER_DECISION`, `READY_FOR_HUMAN_ACCEPTANCE_REVIEW`, and draft approval language.

Issue:

Ready for what is not always forced into the phrase. A future worker could read ready as ready to install.

INFERRED_REPAIR:

Use explicit readiness labels:

- READY_FOR_HUMAN_REVIEW
- READY_FOR_REVISION
- READY_FOR_CANDIDATE_COPY
- NOT_READY_FOR_LIVE_INSTALL
- LIVE_INSTALL_BLOCKED_PENDING_APPROVAL

### Weak wording 2 - "adoption" is under-specified

SOURCE_SUPPORTED:

- Adoption approval draft offers choices, but does not bind target path, hash, user decision date, approving human, or install boundary strongly enough.

INFERRED_REPAIR:

Adoption packet must say whether adoption means candidate helper policy, method card only, exposure ladder only, or live command-center helper.

### Weak wording 3 - "source read" vs "source current path"

SOURCE_SUPPORTED:

- Some receipts now point to current SOURCE_RAW paths after root intake, while older work happened when files were at root.

INFERRED_REPAIR:

Receipts should separate:

```text
ReadAtPath:
OriginalRootPath:
CurrentCustodyPath:
MovedByReceipt:
```

## Missing Fields

Missing across family:

- FamilyPacketId
- FamilyManifestPath
- FamilyHashLedgerPath
- AcceptanceReviewId
- HumanDecisionId
- InstallReadinessVerdict
- UserDecision
- UserDecisionUtc
- ApprovedScope
- RejectedScope
- RequiredBeforeInstall
- SourceSupportedAdditions
- InferredRepairs
- ProposedAdditions
- ParkedItems
- RejectedOrNotUsed

Why it matters:

Without these fields, the family is understandable to a careful reader but brittle for handoff, future automation, and dashboard projection.

## Missing Guards

### Guard 1 - Family split-brain guard

The dual command center sync guard exists for future live state, but the packet family itself does not yet have a review-family split-brain check.

Needed check:

- L0 packet says not installed.
- protocol adoption draft says not approved.
- root-intake receipt says moved true only for source placement.
- final review must not collapse any of those into install or acceptance.

### Guard 2 - Source path drift guard

The root-intake move was valid, but future reviews need a guard that checks old source paths do not remain as canonical active paths without current-custody notes.

### Guard 3 - Exposure overreach guard

The private-work protocol names L0-L4 but does not provide a concrete redaction/excerpt rule for L4 sealed material.

Needed:

- who may downgrade sealed to excerpt
- what receipt is required
- what fields must be removed or summarized
- what DoesNotProve must be attached

### Guard 4 - 33rd overuse guard

The 33rd is strong but can become ritual. The protocol has scale forms; it still needs an acceptance gate requiring the chosen scale to be justified by risk/source size/user instruction.

## Missing Receipt Requirements

Needed receipts before acceptance/install path:

- Family acceptance review receipt.
- Protocol hash ledger receipt.
- Human decision receipt.
- Candidate adoption receipt.
- Future install dry-run receipt.
- Future split-brain guard receipt.
- Future leakage guard receipt.

Receipts must include all required no-mutation flags, not just narrative.

## Missing State Transitions

The family needs a state chain:

```text
RAW_SOURCE_PLACED
REVIEW_PACKET_WRITTEN
HELPER_PREFLIGHT_DONE
WORKING_ORDER_READY
ROOT_INTAKE_DONE
ACCEPTANCE_REVIEW_COMPLETE
USER_DECISION_PENDING
USER_ACCEPTED_CANDIDATE / USER_REQUESTED_REVISION / USER_PARKED / USER_REJECTED
INSTALL_PACKET_DRAFT_ALLOWED / INSTALL_PACKET_BLOCKED
```

Current weakness:

The state exists narratively across receipts, but not as one chain.

## Missing Human Approval Gates

The adoption draft says user decision required, but it should require:

- exact user decision
- approved scope
- excluded scope
- target placement
- whether live install is still blocked
- whether future workers may cite this as current helper policy
- whether 33rd default is accepted as user instruction or only a candidate

Without this, a future worker could overread "review complete" as "accepted".

## Helper-File Exposure Risks

Risk:

The protocol says full source stays private unless needed, but the current working order does not define an excerpt review checklist.

Needed excerpt checklist:

- source identity
- excerpt boundaries
- why excerpt is enough
- omitted sensitive/private material classes
- whether helper map is enough
- receipt path

Risk:

Helper maps could become stale and still be used as current truth.

Needed:

- freshness status required for every helper file used in a major job
- stale helper warning
- current-front-door pointer check

## Mule Overrun Risks

Risk:

Mule may treat root placement authority as future general root move authority.

Repair:

Root intake receipts must say:

`THIS MOVE AUTHORITY IS ONE-TIME AND SOURCE-SPECIFIC.`

Risk:

Mule may run 33rd without packet because it sees a large task.

Repair:

Require `Mule33rdAssigned: true/false` field in every Mule handoff.

## Outside-Source Misuse Risks

Risk:

The 33rd Roof zone mentions outside comparison. A worker might browse by default.

Repair:

Receipt must distinguish:

- OutsideSourcesNeeded: true/false
- OutsideSourcesUsed: true/false
- WhyNeeded
- WhatChanged
- WhatDidNotChange

Risk:

Outside sources could be treated as authority over house packet source.

Repair:

Every outside-source use must state:

`Outside source informs comparison; house source controls unless user approves a source change.`

## Live-Install Risks

STOPPER risk:

The L0 file set and schemas are detailed enough that a careless worker could create live files next.

Repair:

Before any live install approval packet:

- family acceptance review must be complete
- human decision must approve exact install scope
- target paths must be listed
- pre-existing files must be scanned
- no overwrite without review
- dry-run manifest must be written
- rollback/park plan must exist
- leakage/split-brain guards must be prepared

## What Must Be Repaired Before Acceptance

Before human acceptance review:

- Create acceptance standard.
- Create blocker/addition list.
- Create final review packet.
- Create receipt for this chunked review.

Before adoption:

- Add human decision receipt template.
- Add family manifest and hash ledger.
- Add source-supported/inferred/proposed ledger.

Before live install:

- Add install preflight, dry-run, target path check, overwrite policy, leakage guard run, sync guard run, and receipt judge.

## Classification Summary

SOURCE_SUPPORTED:

- No install, no doctrine, helper-file first, exposure ladder, 33rd when invoked/packeted, receipts required, root source placed into SOURCE_RAW.

INFERRED_REPAIR:

- family manifest, hash ledger, human decision fields, source path drift guard, state chain.

PROPOSED_ADDITION:

- excerpt checklist, 33rd scale gate, family split-brain guard, live install preflight checklist.

PARKED:

- full UI implementation details, live dashboard rendering, automation, watcher, template extraction.

REJECTED_OR_NOT_USED:

- generic outside best-practice expansion, live install from current drafts, doctrine promotion, root cleanup by deletion.

## DoesNotProve

- This batch does not prove live install is approved.
- This batch does not prove doctrine promotion is approved.
- This batch does not prove user acceptance.
- This batch does not authorize mutation.
- This batch does not prove all helper files are current.
- This batch does not prove all outside patterns were exhausted.
- This batch does not replace source custody or receipts.

## Batch 2 Verdict

Verdict: BATCH_02_COMPLETE_HARD_CRITIQUE_FINDS_REPAIR_REQUIRED

The packet family is promising and internally aligned, but acceptance must be gated by a clean standard, blocker burndown, and final review. It is not ready for live-install approval.

