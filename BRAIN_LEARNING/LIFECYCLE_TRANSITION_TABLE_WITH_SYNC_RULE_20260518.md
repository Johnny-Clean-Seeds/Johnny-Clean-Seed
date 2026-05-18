# Lifecycle Transition Table With Sync Rule

Status: ACTIVE LEARNING CANDIDATE
Authority: assistant operating support; not command authority by itself

## Purpose

Define lifecycle transitions with proof, authority boundary, sync decision, and rollback path.

This prevents lifecycle words from collapsing into each other.

## Core Rule

A lifecycle state is not authority by itself.

A transition is valid only when:
- the item has a named current state
- the target state is allowed
- the proof need is named
- the authority boundary is named
- the sync decision is named
- rollback or failure path is named

## State Transition Table

| From State | To State | Allowed Trigger | Proof Needed | Authority Boundary | Sync Decision | Rollback / Failure Path |
|---|---|---|---|---|---|---|
| raw | captured | useful input appears | source/context captured | cannot command | STATUS_ENOUGH | leave in raw/source ore |
| captured | candidate | item gets name, job, lane, boundary | fit note | cannot command | STATUS_ENOUGH | return to captured/parked |
| candidate | testing | fit judgment says limited trial is useful | test scope + neighbor risk | support only unless explicitly selected | STATUS_ENOUGH or GROUPED_ANCHOR_FOLLOWUP if next move changes | parked/rejected |
| testing | parked | useful but not now | reason + return trigger | cannot command | STATUS_ENOUGH | candidate later |
| testing | rejected | does not fit core/current need | rejection reason | cannot command | STATUS_ENOUGH | archive/source ore if useful |
| testing | installed | limited proof passes and proper lane exists | proof receipt + placement note | installed does not mean promoted | GROUPED_ANCHOR_FOLLOWUP if active behavior changes, else STATUS_ENOUGH | rollback to testing/parked |
| installed | worn | used in real work | live-use receipt or observed application | used does not mean promoted | STATUS_ENOUGH unless next allowed move changes | rollback/supersede |
| worn | promoted | repeated proof + neighbor walk passes | proof + neighbor check + authority review | promoted only inside named lane | ANCHOR_NOW or GROUPED_ANCHOR_FOLLOWUP | superseded/rolled-back |
| installed | rolled-back | failure, bad fit, better replacement, or stale state | rollback receipt | preserve history | GROUPED_ANCHOR_FOLLOWUP if active behavior changes, else STATUS_ENOUGH | parked/archive/superseded |
| worn | rolled-back | live use exposes leak | failure capture + rollback receipt | preserve history | GROUPED_ANCHOR_FOLLOWUP | parked/superseded |
| promoted | superseded | better proven rule replaces it | supersession receipt + comparison | old rule no longer commands | ANCHOR_NOW or GROUPED_ANCHOR_FOLLOWUP | archive/history |
| any | archived | no longer active but useful historically | archive reason | cannot command | STATUS_ENOUGH | retrieve only for proof/rollback/comparison |
| any | source ore | raw/reference value only | source note | cannot command | STATUS_ENOUGH | candidate later if selected |

## Word-Key Separations

captured is not installed.

installed is not proven in use.

front shelf is retrieval, not authority.

support-only is not command-ready.

worn is used, not promoted.

saved is not right.

rolled-back is not deleted.

archived is not erased.

source ore is not command.

## Sync Decision Outputs

Use ANCHOR_NOW when:
- active ball changes
- next allowed move changes materially
- blocked moves change materially
- authority changes
- promoted behavior changes what the assistant is allowed to do

Use GROUPED_ANCHOR_FOLLOWUP when:
- anchor must update but a separate proof/save phase is cleaner
- a save creates a new current base that must become handoff state
- lifecycle state changes affect future routing

Use STATUS_ENOUGH when:
- support-only files are captured
- proof receipts are saved
- Work Shed items are captured/reviewed but not promoted
- no active authority changes

Use SAFE_TRAIL when:
- final response records current commit, saved files, and clean status
- status/index records the save
- origin/main matches HEAD
- no handoff depends on anchor as only source

Use DEFER_WITH_TRIGGER when:
- sync is intentionally postponed
- the reason and return trigger are written

## Boundary

This table does not rewrite active guides.

This table does not make Work Shed command authority.

This table does not promote lifecycle doctrine by itself.

This table is a learning/support rule until proven in live use.
