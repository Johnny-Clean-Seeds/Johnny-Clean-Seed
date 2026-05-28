# Code Gate V1.4 Allow-Switch Forwarding Fix Card

## Status

Candidate repair card.

This card documents a proven wrapper bug before any repair is made.

## Observed Issue

PowerShell Code Gate Runner V1.4 is an installed wrapper around V1.3.

V1.4 successfully runs normal read/report targets.

However, when a save helper was run through V1.4 with -AllowGitWrites, V1.3 still blocked the target as a Git-write script.

The same save helper succeeded when run directly through V1.3 with -AllowGitWrites.

## Evidence Summary

Observed behavior:

- V1.4 command included -AllowGitWrites.
- V1.4 invoked V1.3.
- V1.3 report said Git write command blocked.
- Direct V1.3 run with -AllowGitWrites passed and committed the guarded stuck-process recovery card.
- Therefore V1.4 likely did not forward allow switches to V1.3.

## Desired Fix

V1.4 must forward approved allow switches to V1.3.

Minimum forwarding set:

- -AllowGitWrites

Possible later forwarding set, only if already supported by V1.3:

- -AllowDeletes
- -AllowMoves
- -AllowNetwork
- -AllowSystem

Do not invent new permission meanings inside V1.4.

V1.4 should remain a wrapper. V1.3 should still own parsing, risk classification, run verdict, and safety policy.

## Correct Behavior

When user runs:

pwsh -ExecutionPolicy Bypass -File POWERSHELL_CODE_GATE_RUNNER_V1.4.ps1 -Target TARGET.ps1 -AllowGitWrites

V1.4 should call V1.3 with:

-Target TARGET.ps1 -AllowGitWrites

and then add only its warning-title summary layer.

## Non-Goals

This fix must not:

- weaken V1.3 policy;
- bypass Code Gate;
- auto-allow Git writes;
- modify doctrine;
- rewrite ACTIVE_GUIDES;
- rewrite CURRENT_TRUTH_INDEX;
- change save policy;
- push automatically;
- broaden to unrelated runner behavior.

## Test Plan

Use a narrow known save helper that requires Git-write permission.

Expected proof path:

1. Run through V1.4 without -AllowGitWrites.
2. Confirm it blocks Git-write target.
3. Run through V1.4 with -AllowGitWrites.
4. Confirm V1.3 receives the allow switch.
5. Confirm target runs.
6. Confirm report still shows V1.3-owned verdict.
7. Confirm V1.4 only adds post-run warning summary.
8. Confirm Git status is clean or expected.

## Weak-PC Guard

No broad scans.

No full repo hash.

No giant process walk.

No legacy helper extraction during this repair.

## Placement

Lane: Tools / Code Gate / wrapper repair.

Durable placement candidate:

- HOUSE_WORK / WORK_SHED / GEAR_RACK / RULE_MACHINES
- BRAIN_LEARNING candidate rule
- PROOF_HISTORY receipt

## Final Gate Verdict

READY FOR NARROW REPAIR SCRIPT.

Not promoted as doctrine.

Not a policy change.

This is a tool wrapper bug fix candidate.
