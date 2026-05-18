# Runtime Kernel Command Proposal Card

## Purpose

Define the required card format for any future Runtime Kernel command proposal.

A command may not be created, named as active, placed in /system, or treated as callable until this card is filled, judged, and passed through the Command Gate.

## Core rule

No command without a card.

No card without proof.

No proof without lane boundaries.

No command creation from idea alone.

## Required card fields

Every command proposal must include:

1. command_name
2. command_job
3. allowed_caller
4. authority_level
5. allowed_inputs
6. blocked_inputs
7. required_context
8. missing_context_behavior
9. invalid_input_behavior
10. ambiguous_input_behavior
11. output_lane
12. proof_lane
13. failure_lane
14. recovery_path
15. rollback_or_supersession_path
16. close_condition
17. user_approval_required
18. forbidden_side_effects
19. dry_run_required
20. promotion_rule

## Required judgment

Each command proposal must be judged against:

- Runtime Kernel Command Gate
- Runtime Kernel Live-Build Gate
- Universal State Machine
- Single System Ledger boundary
- Parent/Child Map boundary
- Combined Promotion Gate

## Required proof before command creation

A command proposal may not create a command until proof shows:

- the card is complete
- the command has one job
- the command does not override the core
- the command does not create /system by itself
- the command does not create live runtime by itself
- the command does not promote by itself
- the command does not treat ledger as proof
- the command does not treat map as authority
- the command has a failure path
- the command has a recovery path
- the command has a rollback or supersession path
- user approval boundary is clear

## Forbidden movement

Do not create command files from this card.

Do not create callable commands from this card.

Do not create /system from this card.

Do not create live ledger, live map, live index, or live lock engine from this card.

Do not promote anything to Hard Suit from this card.

## PASS meaning

PASS means the proposal card format is usable.

PASS does not mean any command is approved.

## Close condition

This card format passes only if it gives future command candidates a judgeable shape without creating command behavior.
