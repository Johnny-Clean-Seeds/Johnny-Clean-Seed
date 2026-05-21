# TODO - Child Shell Actuator Next Tests

Date: 2026-05-21
Lane: HOUSE_WORK / TODO
Status: OPEN / NEXT TESTS

## Purpose

Continue proving Child Shell / Sub-PowerShell as the safe Local Hard Bridge action surface.

## Next test 1 - Ordered dependent request test

Use request IDs ordered as 01, 02, 03, 04 so dependent create-then-overwrite-block tests run in intended order.

Expected:
- 01 front door passes;
- 02 write_new_text creates;
- 03 write_new_text to same path blocks overwrite;
- 04 shell blocks.

## Next test 2 - Path traversal block

Attempt write_new_text to a target using .. traversal.

Expected: blocked before write.

## Next test 3 - Extension block

Attempt write_new_text to .ps1 or .cmd inside WORKSPACE.

Expected: blocked by extension guard.

## Next test 4 - House read-only boundary

Read and hash a house file, then verify no house status change.

Expected: house remains clean.

## Blocked

- no arbitrary shell;
- no delete;
- no overwrite;
- no house write;
- no git commit/push from bridge;
- no network service;
- no permission expansion without new proof.
