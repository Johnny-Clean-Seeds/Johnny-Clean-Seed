# Child Shell Level 2 Approved-Helper Repair and Proof Review - 20260521

## Verdict

PASS / LOCK SAVE READY

## Root Cause

The Level 2 approved-helper runner executed the allowlisted PowerShell helper, the helper wrote the expected output, and then the runner rejected the job by checking `$LASTEXITCODE`.

That check was wrong for a `.ps1` helper because `$LASTEXITCODE` can retain stale native-command state and does not prove the approved helper failed.

## Exact Repair

Patched only:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\RUNNERS\RUN_CHILD_SHELL_LEVEL2_APPROVED_HELPER_ONCE.ps1

Patch made:

- removed the stale `$LASTEXITCODE` rejection branch after helper invocation;
- wrapped the approved helper call in `try/catch`;
- reject only when the helper throws;
- keep the existing required output-file check;
- keep helper output hashing before receipt;
- changed the receipt header to `CHILD SHELL LEVEL2 APPROVED HELPER CONSUMED`.

Runner SHA256 after repair:

85B2832186003295ABB54AAF77E2A6A351417F6927D3929A6F7CB02102B78FCF

## Preserved Failed Evidence

Rejected 000007 job:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\REJECTED\CHILDJOB-20260521-000007-LEVEL2-APPROVED-HELPER-STATUS.childjob.json

SHA256:

F07EC69874D57ADA53E2456B4E89727DEAB084590E520F8A51A6C68AE13F46B7

Rejected 000007 note:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\REJECTED\CHILDJOB-20260521-000007-LEVEL2-APPROVED-HELPER-STATUS.level2.rejected.txt

SHA256:

B73D3A0252ED1CD694B046005F50B8FE2B11654D1131BD13029E7891D6616E3E

000007 helper output:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\HELPER_OUTPUT\CHILDJOB-20260521-000007-LEVEL2-APPROVED-HELPER-STATUS.helper-output.txt

SHA256:

F511FA7FEFF3DEB63997558BB47706A59B12E8152466D9FD7A5B99549FAB7534

## Fresh Proof

Job:

CHILDJOB-20260521-000008-LEVEL2-APPROVED-HELPER-RETEST

Route:

COMMAND_CENTER/CHILD_SHELL/WATCHER/DISPATCH/LEVEL2

Action:

run_approved_helper

Helper name:

read_child_shell_status_summary

Helper SHA256:

116719AC1B8588723800B222286C4F373DA7B42C5EA5299EDD13EBF473F2F215

Allowlist SHA256:

686C498FCE458C12B944B6B1BA136EC372CC0DC8CF25D0A4EB81964DAE70A2AF

Processed job:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\PROCESSED\CHILDJOB-20260521-000008-LEVEL2-APPROVED-HELPER-RETEST.childjob.json

Processed job SHA256:

EE8F3D6B136BBADC6C77A3EC070D682B8B9B258C390015B39E139A98F0FCC7F8

Receipt:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000008-LEVEL2-APPROVED-HELPER-RETEST.receipt.txt

Receipt SHA256:

BD1AD5D313A42E2727C70CA4FBBEEA0AD96DA339DA1016293F19944219EB86D7

Helper output:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\HELPER_OUTPUT\CHILDJOB-20260521-000008-LEVEL2-APPROVED-HELPER-RETEST.helper-output.txt

Helper output SHA256:

9240B449D018A055379C12CBAA52C06B634D7D2BA301779A444AB2D07B4378FB

Watcher PID at save time:

10380

Watcher state at save time:

RUNNING

## Boundary Held

Command Center Child Shell Level2 approved-helper only.

No arbitrary shell.

No raw shell expansion.

No Mr.Kleen repo write through Child Shell.

No git through Child Shell.

No doctrine install.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No delete.

No broad filesystem crawl.

No permission expansion.

No junction/symlink teleporter.

No Level 3 install.
