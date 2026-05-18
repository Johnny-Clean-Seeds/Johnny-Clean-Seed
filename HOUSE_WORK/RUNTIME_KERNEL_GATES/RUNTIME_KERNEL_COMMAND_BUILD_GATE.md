# Runtime Kernel Command-Build Gate

## Purpose

Define the gate that must pass before an approved command proposal candidate may become a built command file.

This gate exists because an approved proposal candidate is not a command.

## Core rule

Approved proposal candidate does not equal built command.

No command file may be created until build lane, filename, callable surface, allowed inputs, blocked inputs, output mode, proof mode, failure mode, rollback path, user approval boundary, and no-hidden-live-build checks are defined and passed.

## Required build fields

A command-build proposal must define:

1. command_name
2. approved_proposal_source
3. build_lane
4. command_filename
5. callable_surface
6. allowed_caller
7. authority_level
8. allowed_inputs
9. blocked_inputs
10. default_output_mode
11. save_or_proof_output_mode
12. proof_requirement
13. failure_behavior
14. recovery_behavior
15. rollback_or_supersession_path
16. user_approval_required
17. forbidden_side_effects
18. close_condition

## Required proof before build

Before a command file is built, proof must show:

- approved proposal candidate exists
- command has one job
- command file name is defined
- build lane is defined
- callable surface is defined
- default output is bounded
- save/proof output is bounded
- failure behavior is bounded
- recovery behavior is bounded
- rollback or supersession path exists
- user approval boundary is clear
- no /system is created unless separately approved
- no live ledger is created unless separately approved
- no live map is created unless separately approved
- no live index is created unless separately approved
- no live lock engine is created unless separately approved
- no Hard Suit promotion happens from build alone

## Build boundary

This gate may approve a later command-build dry run.

This gate does not create any command.

This gate does not create /system.

This gate does not create live runtime files.

This gate does not promote anything to Hard Suit.

## User approval boundary

User approval is required before any command file is created.

User approval is required before any callable command is installed.

User approval is required before /system is created.

User approval is required before live runtime files are created.

User approval is required before Hard Suit promotion.

## Forbidden movement

Do not turn an approved proposal candidate into a command file automatically.

Do not build a command because a proposal passed.

Do not create aliases from convenience.

Do not create /system as part of command build unless a separate /system gate passes.

Do not create live runtime files as part of command build unless separate live-build proof passes.

Do not treat command build as Hard Suit promotion.

Do not treat command execution as proof.

Do not allow a command to overwrite active files without explicit approval.

## PASS meaning

PASS means this build gate is defined and may be walked.

PASS does not approve command creation.

PASS does not approve /system.

PASS does not approve live runtime.

PASS does not approve Hard Suit promotion.

## Close condition

This gate passes only if it blocks movement from approved proposal candidate to built command until build lane, callable surface, output mode, proof mode, failure mode, recovery, rollback, and user approval are defined.
