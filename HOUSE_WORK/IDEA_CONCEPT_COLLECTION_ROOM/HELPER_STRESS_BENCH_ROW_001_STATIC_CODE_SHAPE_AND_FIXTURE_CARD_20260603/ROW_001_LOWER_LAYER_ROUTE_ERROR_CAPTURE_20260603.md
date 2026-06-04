# Row 001 Lower-Layer Route Error Capture

Date: 20260603
RunId: 20260603_220810

## Failure Class

LOWER_LAYER_REPO_DISCOVERY_NULL_TRIM_FAILURE

## Exact Error

InvalidOperation: C:\Users\13527\Downloads\WRITE_ROW_001_STATIC_CODE_SHAPE_FIXTURE_PACKET_V1.ps1:33
Line |
  33 |  $Repo = (& git rev-parse --show-toplevel 2>$null).Trim()
     |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | You cannot call a method on a null-valued expression.

## Cause

The previous runner was saved under Downloads and executed while the shell stood in Desktop\123 instead of the Git repo.

The command git rev-parse --show-toplevel returned null or empty, then the script called .Trim() on that null value.

## Repair Installed Here

This runner proves the expected repo path first, changes into the repo, checks that git top is non-empty, and only then calls .Trim().

This runner is meant to be copied into and run from a known repo-local runner folder, not executed from Downloads by habit.

## Boundary

Target helper executed: false
Git add/commit/push: false
Root cleanup: false
Pointer/state mutation: false