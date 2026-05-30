# Save Script Expected Partial Dirty Recovery Living Ledger

HELPER_ID: SAVE_SCRIPT_HELPER
STATUS: LIVING LEDGER EVENT / OPEN-CLOSED BY V1.2 IF SAVE PASSES

## Event

EVENT_ID: SAVE_SCRIPT_EXPECTED_PARTIAL_DIRTY_RECOVERY_20260529

## What was

The save helper expected a clean repo before beginning write mode.

## What broke

A prior failed save had already written and staged planned files. The repaired route saw dirty status and blocked before it could complete the save.

## False blames blocked

This was not user error, not source corruption, not a bad architecture idea, and not random repo dirt until classified.

## Root cause

The save helper lacked an expected-partial dirty-state recovery gate.

## Repair applied

V1.2 parses `git status --short`, extracts dirty paths, compares them against the planned package set and exact prior manifest/receipt family, blocks unknown dirty paths, and carries expected partial paths forward into staged-set verification.

## Current behavior expected

A save helper can recover from its own exact partial save state without deleting evidence or pretending the repo was clean.

## Proof required

V1.2 must commit, push, verify HEAD equals origin/main, and end with final clean status.

## Reopen trigger

Any helper/save route hits dirty repo after a partial failed save and either loses evidence, resets too broadly, or blocks without classifying expected partial state.