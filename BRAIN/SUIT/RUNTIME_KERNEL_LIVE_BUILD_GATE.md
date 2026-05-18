# Runtime Kernel Live-Build Gate

## Purpose

Define the gate that must be passed before any Runtime Kernel work creates live runtime files, a live ledger, a live parent/child map, a live index, a live lock engine, /system, or command behavior.

This gate exists because the Soft Suit trio has passed multiple dry runs but is still not live runtime.

## Scope

This gate applies to:

- Universal State Machine
- Single System Ledger
- Parent/Child Map
- Combined Promotion Gate
- future live ledger
- future live parent/child map
- future live index
- future lock/write handling
- future /system folder
- future command surface

## Core rule

Dry-run success does not authorize live build.

Live build requires a separate explicit gate.

## Required proof before live build

Before live runtime files can be created, all of the following must be true:

1. The target live artifact is named.
2. The target live artifact has a lane.
3. The target live artifact has a job.
4. The target live artifact has a boundary.
5. The target live artifact has a proof path.
6. The target live artifact has a failure path.
7. The target live artifact has a recovery path.
8. The target live artifact has a close condition.
9. The target live artifact has an owner/authority level.
10. The target live artifact has a rollback/supersession path.

## Required checks

### State check

The artifact must obey Universal State Machine movement.

No captured item may jump directly to promoted or live.

No blocked item may close without reason.

No Soft Suit item may become live runtime without proof.

### Ledger check

If a live ledger is proposed:

- ledger remains pointer/event spine
- ledger is not proof
- ledger is not authority
- ledger does not authorize promotion
- ledger has duplicate handling
- ledger has malformed row handling
- ledger has append/retrieval behavior
- ledger has write safety policy

### Parent/Child Map check

If a live map is proposed:

- map remains containment/reporting only
- map is not proof
- map is not authority
- map does not authorize promotion
- map refuses parent close when child is open
- map refuses parent close when child is blocked
- map handles cross-file references
- map has lookup/recovery path

### Index check

If a live index is proposed:

- index is not proof
- index is not authority
- index points to existing files
- index has stale-link handling
- index has missing-target handling
- index can be rebuilt from source files

### Lock/write check

If live writes are proposed:

- write order is defined
- conflict handling is defined
- lock behavior is defined
- retry behavior is defined
- failed write capture is defined
- proof of no data loss is required

### /system check

/system must not be created until:

- its exact purpose is named
- its boundary against BRAIN, HOUSE_WORK, SOURCE_ORE, and PROOF_HISTORY is defined
- it does not steal authority from active guides
- it does not become a junk drawer
- it has a rollback path
- it has a proof receipt

### Command gate check

Commands must not be created until:

- command names are defined
- command authority is defined
- allowed inputs are defined
- blocked inputs are defined
- output lane is defined
- failure behavior is defined
- proof behavior is defined
- user approval boundary is defined

## Forbidden movement

Do not create live runtime files from dry-run success alone.

Do not create /system from excitement.

Do not create commands from convenience.

Do not promote Soft Suit candidates to Hard Suit because they passed dry runs.

Do not treat live ledger as proof.

Do not treat live map as authority.

Do not let index become doctrine.

Do not hide failed writes.

Do not delete failed dry-run evidence.

## Allowed verdicts

- PASS
- FAIL
- PARTIAL
- BLOCKED
- PASS WITH HOLD

## PASS meaning

PASS means the live-build gate is defined and may be used in a later live-build review.

PASS does not mean live runtime may be built.

## PASS WITH HOLD meaning

PASS WITH HOLD means the gate is useful but more proof is needed before live build.

## Close condition

This gate passes only if it clearly separates:

- Soft Suit dry-run proof
- Hard Suit promotion proof
- live-build proof
- command proof
- user approval
- rollback/supersession
