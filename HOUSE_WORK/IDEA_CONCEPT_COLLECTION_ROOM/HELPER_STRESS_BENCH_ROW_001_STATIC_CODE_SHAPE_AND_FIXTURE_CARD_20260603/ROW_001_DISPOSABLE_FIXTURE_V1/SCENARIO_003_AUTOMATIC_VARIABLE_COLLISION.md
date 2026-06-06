# SCENARIO 003 — AUTOMATIC VARIABLE COLLISION

## Hazard shape

A generated script uses variable names or identifiers that may collide with PowerShell automatic variables, reserved names, process identifiers, or shell-managed state.

## What this tests

Whether the reviewer blocks execution until naming is checked statically.

## Expected judgment

`REQUIRES_NAME_GUARD`

Secondary judgment:

`BLOCK_STATIC_REVIEW`

## Required response

Rename risky variables in design before execution.

Require a static naming guard if this lane later becomes a checker.

Prefer explicit, lane-specific names over short ambiguous names.

## Forbidden response

Do not run first and repair after collision.

Do not assume lowercase/uppercase variation makes a name safe.

Do not treat one fixed collision as proof the naming surface is safe.

## Clean wording

Name safety is a start condition, not a post-crash cleanup step.
