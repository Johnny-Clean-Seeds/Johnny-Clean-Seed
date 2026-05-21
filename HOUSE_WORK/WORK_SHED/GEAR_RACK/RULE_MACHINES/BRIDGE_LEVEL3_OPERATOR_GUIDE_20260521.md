# Bridge Level3 Operator Guide - 20260521

## Start

Use C:\Users\13527\Desktop\123 as the working doorway.

Run watcher ensure before dropping jobs:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\WATCHER\ENSURE_CHILD_SHELL_WATCHER_RUNNING.ps1

Use bridge status for readback:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\WATCHER\STATUS_CHILD_SHELL_BRIDGE.ps1

## Job Levels

Level 1 action: ead_command_center_status.

Level 2 action: un_approved_helper with a named allowlisted helper.

Level 3 action: un_approved_house_save_package with an exact package hash and allowlisted save helper.

## Level3 Rule

A Level3 package must name every write target, every content hash, the commit message, and the expected repo base. The helper rejects missing hashes, wrong helper hash, package hash mismatch, dirty repo, writes outside approved lanes, and origin/main mismatch.

## Never Use This For

Arbitrary shell, raw shell expansion, broad scan, deletion, permission expansion, hidden doctrine changes, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, or unrestricted repo writes.
