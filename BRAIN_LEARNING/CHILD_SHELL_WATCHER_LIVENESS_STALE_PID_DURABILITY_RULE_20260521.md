# Child Shell Watcher Liveness / Stale-PID Durability Rule — 20260521

## Status

PASS / STALE PID DETECTED, WATCHER RESTARTED, DROP JOB CONSUMED

## What Is Proved

The Child Shell watcher liveness helper can recover from a stale PID file.

The proof stopped the existing watcher, forced PID value 999999, ran the ensure helper, restarted the watcher, and confirmed the restarted watcher consumed a dropped Level 1 read-status job.

## Proof Chain

Initial PID:

8908

Initial state:

RUNNING

Forced stale PID:

999999

Restarted watcher PID:

13520

Restarted watcher state:

RUNNING

Self-test job:

CHILDJOB-20260521-000006-WATCHER-LIVENESS-STALE-PID-RESTART

## Validated Local Proof Objects

Ensure helper:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\WATCHER\ENSURE_CHILD_SHELL_WATCHER_RUNNING.ps1

SHA256:

D2322D81EE126DF077F6F4B79526FFACAA7DF63EC873C1A4A74DEA65E6DEC449

Ensure receipt:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\WATCHER\ENSURE_CHILD_SHELL_WATCHER_LAST_RECEIPT.txt

SHA256:

097084DB4922AD40980B4C560BEE2EAB47445F427BE2B322999864ECE78CE06C

Self-test job:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\PROCESSED\CHILDJOB-20260521-000006-WATCHER-LIVENESS-STALE-PID-RESTART.childjob.json

SHA256:

AB41B642478A15E1F05E94125FFC50BE8D0860AFADD0EF957097573C07C6D046

Self-test receipt:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000006-WATCHER-LIVENESS-STALE-PID-RESTART.receipt.txt

SHA256:

EED54160EC90BB858157243BFDCED816C8F9DB21CF10A216C58356EF75485558

Proof receipt:

C:\Users\13527\Desktop\123\COMMAND_CENTER\RECEIPTS\CHILD_SHELL_WATCHER_LIVENESS_STALE_PID_DURABILITY_RECEIPT_20260521_041759.txt

SHA256:

AD85F61684B74BC8A4DD852ADE014B9E1546FEB351EB452814E4F9877C6B3D42

## Meaning

The watcher route has now moved from "works when alive" to "can recover from stale PID by using the ensure helper."

This is durability proof for watcher liveness, not a promotion to broader execution.

## Boundary

This does not prove assistant-direct local execution from chat.

This does not prove Level 2 approved-helper execution.

This does not prove Level 3 Mr.Kleen house-save execution.

This does not allow arbitrary shell execution, raw shell expansion, broad filesystem crawl, delete, permission expansion, junction/symlink teleporter, doctrine install, ACTIVE_GUIDES rewrite, or CURRENT_TRUTH_INDEX rewrite.

## Next Selected Boss

Level 2 approved-helper route is selected next, but it must be separately designed, bounded, allowlisted, tested, and saved.

Do not skip directly to Level 3.

## STALE UPDATE — LEVEL2 VERIFIED — 20260521

This file previously described Level 2 as selected next / not installed.

Update: Level 2 approved-helper route is now verified and saved at main @ e9c9bf1.

Verified proof:
- Repo proof receipt: PROOF_HISTORY\CHILD_SHELL_LEVEL2_APPROVED_HELPER_LOCK_RECEIPT_20260521.txt
- Repo proof receipt SHA256: 6F851F7E88234DDFD3632F9B842C22355360FF16A82BEE2163D3A42894A91EFA
- Level2 receipt: C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000008-LEVEL2-APPROVED-HELPER-RETEST.receipt.txt
- Level2 receipt SHA256: BD1AD5D313A42E2727C70CA4FBBEEA0AD96DA339DA1016293F19944219EB86D7

Boundary remains:
Level 2 approved-helper only. Level 3 remains blocked. No arbitrary shell, no raw shell expansion, no git or Mr.Kleen repo writes through Child Shell.

## STALE UPDATE - LEVEL3 VERIFIED - 20260521

This file previously said or implied Level 3 was blocked, not installed, or not proved.

Update: bounded Level 3 approved house-save package routing is now installed and proved by CHILDJOB-20260521-000011-LEVEL3-BOUNDED-HOUSE-SAVE.

Boundary remains: Level 3 is exact approved package save only. It does not allow assistant-direct local execution from chat, arbitrary shell, raw shell expansion, broad filesystem crawl, delete, permission expansion, unrestricted repo write, uncontrolled git, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, doctrine rewrite, or junction/symlink teleporter.
