# Runtime Kernel Command Gate

## Purpose

Define the gate that must be passed before any command surface is created for the Runtime Kernel.

This gate exists because command names can become authority keys if they are created too early.

## Core rule

No runtime command may exist until its job, authority, allowed inputs, blocked inputs, output lane, proof behavior, failure behavior, recovery path, user approval boundary, and rollback path are defined.

## Scope

This gate applies to any future command-like behavior, including but not limited to:

- cycle
- check
- status
- promote
- close
- recover
- park
- block
- ledger append
- map update
- index rebuild
- proof capture
- live-build

## Required fields before command creation

Each proposed command must define:

1. command name
2. plain-language job
3. allowed caller
4. authority level
5. allowed inputs
6. blocked inputs
7. input validation rule
8. output lane
9. proof lane
10. failure lane
11. recovery path
12. rollback or supersession path
13. close condition
14. user approval boundary
15. forbidden side effects

## Authority rules

A command may not:

- override the core
- rewrite active guides
- promote Soft Suit to Hard Suit by itself
- create /system by itself
- create live ledger by itself
- create live map by itself
- create live index by itself
- treat ledger as proof
- treat map as authority
- treat index as doctrine
- hide failed proof
- delete failed evidence
- skip user approval when approval is required

## Input rules

Every command must define:

- exact accepted inputs
- exact rejected inputs
- required context
- missing-context behavior
- invalid-input behavior
- ambiguous-input behavior
- no-op behavior
- recovery behavior

## Output rules

Every command must define:

- where output goes
- whether output is test-only, proof-history, source-ore, Soft Suit, Hard Suit, or live
- whether output is allowed to be committed
- whether output requires proof
- whether output requires user approval
- whether output can be rolled back or superseded

## Proof rules

A command does not pass because it runs.

A command passes only when proof shows:

- expected output exists
- forbidden output does not exist
- lane boundaries are preserved
- authority boundaries are preserved
- failure path works or is safely blocked
- recovery path works or is safely blocked
- no hidden promotion happened
- no hidden live build happened

## Failure rules

If a command fails:

- stop movement
- capture failure
- preserve failed evidence
- do not delete failure evidence
- route to failure lane
- define next repair
- do not retry blindly
- do not continue downstream commands

## User approval boundary

User approval is required before a command may:

- create /system
- create live runtime files
- create or change active authority files
- promote to Hard Suit
- delete or overwrite active files
- run a destructive repair
- change command authority
- change command input/output lanes

## Forbidden movement

Do not create command files from dry-run success alone.

Do not create command aliases from convenience.

Do not create command names before jobs are defined.

Do not allow commands to become doctrine.

Do not allow commands to hide uncertainty.

Do not allow commands to convert PASS WITH HOLD into PASS.

Do not allow command success to replace proof.

## Allowed verdicts

- PASS
- FAIL
- PARTIAL
- BLOCKED
- PASS WITH HOLD

## PASS meaning

PASS means this gate is defined and may be walked.

PASS does not mean command creation is approved.

## PASS WITH HOLD meaning

PASS WITH HOLD means the command gate is useful but command creation remains blocked until a specific command proposal passes this gate.

## Close condition

This gate passes only if it blocks command creation until authority, input, output, proof, failure, recovery, approval, and rollback are defined.
