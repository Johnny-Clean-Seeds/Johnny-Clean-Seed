# Status Command Proposal Card Dry Run

Run stamp: 20260518_004157

## command_name

status

## command_job

Report current runtime-kernel orientation without changing files.

## allowed_caller

assistant with user-visible report request.

## authority_level

read-only proposal candidate.

## allowed_inputs

- status
- current status
- runtime status
- where are we
- what is the current brain position

## blocked_inputs

- create status command
- install status command
- run live status
- build /system
- write live runtime status
- promote status command
- change active guide status
- delete or overwrite files

## required_context

- current brain position
- clean or dirty brain status
- latest runtime-kernel gate state
- current blocked items
- next clean run

## missing_context_behavior

Return BLOCKED and request or run a safe read-only verification step.

## invalid_input_behavior

Return BLOCKED and do not write files.

## ambiguous_input_behavior

Return PARTIAL and report safest read-only interpretation.

## output_lane

Chat report or HOUSE_WORK test-only report only.

## proof_lane

PROOF_HISTORY only if the status command proposal is being tested.

## failure_lane

HOUSE_WORK/RUNTIME_KERNEL_RUNS failure note.

## recovery_path

Stop, capture missing context, rerun read-only verification.

## rollback_or_supersession_path

Supersede this proposal card with a clearer proposal card.

## close_condition

Status report returns current brain position, clean/dirty status, blocked/live-build state, and next clean run without changing active files.

## user_approval_required

Required before creating any command file, callable command, /system route, live status file, or Hard Suit promotion.

## forbidden_side_effects

- no file writes during normal status report
- no /system creation
- no live ledger creation
- no live map creation
- no live index creation
- no command file creation
- no Hard Suit promotion
- no active guide edits
- no deletion
- no overwrite

## dry_run_required

Yes.

## promotion_rule

The status command may not be promoted unless a later dry run proves it can report read-only status without changing files, authority, proof, or runtime state.

## proposal verdict

PASS WITH HOLD.

This proposal is shaped enough for a later status command dry-run test.

No command is created.
