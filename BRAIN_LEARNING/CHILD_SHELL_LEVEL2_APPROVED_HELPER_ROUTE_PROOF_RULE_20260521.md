# Child Shell Level 2 Approved-Helper Route Proof Rule - 20260521

## Status

PASS / LEVEL2 APPROVED HELPER ROUTE REPAIRED AND PROVED

## Rule

For approved PowerShell helpers, the Level 2 runner must not judge helper success by `$LASTEXITCODE`.

PowerShell `.ps1` helper success is judged by:

- helper name is allowlisted;
- helper path exists;
- helper SHA256 matches the allowlist;
- helper invocation completes without a thrown exception;
- required helper output file exists;
- helper output SHA256 is recorded;
- receipt writes only after validation;
- accepted job moves to PROCESSED only after receipt creation.

## Proof

The failed Level 2 job 000007 is preserved as evidence. It created helper output but was rejected because the runner checked stale `$LASTEXITCODE`.

Fresh watcher-dispatched job:

CHILDJOB-20260521-000008-LEVEL2-APPROVED-HELPER-RETEST

Verdict:

PASS / LEVEL2 APPROVED HELPER JOB CONSUMED

Receipt:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000008-LEVEL2-APPROVED-HELPER-RETEST.receipt.txt

Receipt SHA256:

BD1AD5D313A42E2727C70CA4FBBEEA0AD96DA339DA1016293F19944219EB86D7

Helper output:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\HELPER_OUTPUT\CHILDJOB-20260521-000008-LEVEL2-APPROVED-HELPER-RETEST.helper-output.txt

Helper output SHA256:

9240B449D018A055379C12CBAA52C06B634D7D2BA301779A444AB2D07B4378FB

## Boundary

This proves only one named allowlisted Level 2 helper route.

It does not prove assistant-direct local execution from chat.

It does not prove Level 3 Mr.Kleen house-save execution.

It does not allow arbitrary shell execution, raw shell expansion, git through Child Shell, Mr.Kleen repo write through Child Shell, doctrine install, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, delete, broad filesystem crawl, permission expansion, or junction/symlink teleporter.

## Next Clean Step

Treat Level 2 approved-helper route as repaired and saved. Level 3 remains blocked unless separately designed, installed, and proved.

## STALE UPDATE - LEVEL3 VERIFIED - 20260521

This file previously said or implied Level 3 was blocked, not installed, or not proved.

Update: bounded Level 3 approved house-save package routing is now installed and proved by CHILDJOB-20260521-000011-LEVEL3-BOUNDED-HOUSE-SAVE.

Boundary remains: Level 3 is exact approved package save only. It does not allow assistant-direct local execution from chat, arbitrary shell, raw shell expansion, broad filesystem crawl, delete, permission expansion, unrestricted repo write, uncontrolled git, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, doctrine rewrite, or junction/symlink teleporter.
