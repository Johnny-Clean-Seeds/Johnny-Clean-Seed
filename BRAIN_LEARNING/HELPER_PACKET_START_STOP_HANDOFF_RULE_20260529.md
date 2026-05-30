# Helper Packet Start / Stop / Handoff Rule

Status: SUPPORT RULE / PACKET SAFETY
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX

## Rule

A helper must know why it can start, why it cannot start, why it stopped, and what packet goes next.

## Required start field

`START_STATUS` must be one of:

- `CAN_START`
- `CANNOT_START`

## Start blockers

Allowed `START_BLOCKER` labels:

- `NO_PACKET`
- `WRONG_HELPER`
- `MISSING_SOURCE`
- `DIRTY_STATE`
- `IGNORED_OR_PROTECTED_PATH`
- `MISSING_PERMISSION`
- `STALE_INPUT`
- `DEPENDENCY_NOT_CLOSED`
- `PROOF_PREREQ_MISSING`
- `CAPABILITY_MISMATCH`
- `HANDOFF_UNCLEAR`
- `SAFETY_BLOCK`

If start fails, the helper creates a `NO_START_PACKET` with evidence, missing input, who can unblock it, and a return trigger.

## Required stop field

`STOP_REASON` must be one of:

- `DONE_PASS`
- `DONE_WITH_WATCH`
- `BLOCKED_MISSING_INPUT`
- `BLOCKED_SCOPE_LIMIT`
- `BLOCKED_SAFETY`
- `NEEDS_NEXT_HELPER`
- `NEEDS_PROOF`
- `FAILED_WITH_EVIDENCE`
- `REOPEN_TRIGGERED`

## Pass-the-buck rule

A helper may pass the buck only through a bounded handoff packet. The handoff must say what was received, what was done, what changed, what proof exists, what was not done, why it stopped, who receives next, and what the next helper needs to know only.