# Runtime Kernel Status Output Rule

## Purpose

Define the output rule for any future status command or status-like report.

This rule exists because the status command read-only dry run proved a useful report shape, but it also showed that saved status receipts are not the normal default.

## Core rule

Default status output is chat-only and read-only.

Saved status receipts require explicit save/proof mode.

## Default status behavior

A normal status response should:

- read current orientation
- report current brain position if known
- report clean or dirty state if known
- report active gate or current phase
- report blocked live-build state
- report blocked command state
- report blocked /system state
- report blocked Hard Suit promotion state
- report next clean run
- avoid writing files
- avoid creating proof receipts
- avoid creating command files
- avoid creating live runtime files

## Save/proof mode behavior

A status report may be saved only when one of these is true:

- user explicitly asks to save the status
- user explicitly asks for proof
- the current run requires a proof receipt
- failure capture requires a status receipt
- a gate requires saved evidence

## Forbidden movement

A status report may not:

- create /system
- create a live status file
- create a live ledger
- create a live map
- create a live index
- create a live lock engine
- create command files
- promote anything to Hard Suit
- edit active guides
- overwrite active files
- delete proof history
- convert PASS WITH HOLD into PASS

## Allowed outputs

Allowed default output:

- chat report only

Allowed save/proof output:

- HOUSE_WORK test-only report
- PROOF_HISTORY receipt
- source-ore note if explicitly parked as source material

Blocked output:

- live runtime file
- command file
- /system route
- active guide change
- Hard Suit promotion file

## Status report minimum fields

A status report should include:

1. current brain position
2. clean or dirty state
3. current runtime-kernel phase
4. blocked/unblocked state for live build
5. blocked/unblocked state for commands
6. blocked/unblocked state for /system
7. blocked/unblocked state for Hard Suit promotion
8. next clean run
9. whether the report is chat-only or saved proof mode

## Close condition

This rule passes only if it keeps normal status read-only while allowing saved proof receipts only when explicitly needed.
