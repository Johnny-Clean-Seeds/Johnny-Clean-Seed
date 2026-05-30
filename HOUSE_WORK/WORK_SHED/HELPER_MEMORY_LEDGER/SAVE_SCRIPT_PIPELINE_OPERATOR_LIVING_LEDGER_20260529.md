# Save Script Pipeline Operator Living Ledger

HELPER_ID: SAVE_SCRIPT_HELPER
STATUS: LIVING LEDGER EVENT / OPEN-CLOSED BY V1.2 IF SAVE PASSES

## Event

EVENT_ID: SAVE_SCRIPT_PIPELINE_OPERATOR_SPLIT_FAILURE_20260529

## What was

The save helper could write and stage the hash-key front gate package, then verify staged files by calling Git and splitting output inline.

## What broke

`Invoke-Git -GitArgs @('diff','--cached','--name-only') -split "`n"` failed because `-split` was parsed as a parameter to `Invoke-Git`.

## False blames blocked

The idea, source material, user action, ignored-path manifest, and Git wrapper were not the active cause.

## Root cause

Dense inline output transformation in a proof-critical Git check.

## Repair applied

V1.2 captures Git output first, then applies split/trim/filter to the captured text.

## Current behavior expected

Staged-set verification uses a named raw output variable and a named parsed list.

## Proof required

V1.2 must commit, push, verify HEAD equals origin/main, and end with final clean status.

## Reopen trigger

Any future proof path fails because an operator such as `-split`, `-replace`, or a pipeline transform was parsed as a command parameter instead of being applied to command output.