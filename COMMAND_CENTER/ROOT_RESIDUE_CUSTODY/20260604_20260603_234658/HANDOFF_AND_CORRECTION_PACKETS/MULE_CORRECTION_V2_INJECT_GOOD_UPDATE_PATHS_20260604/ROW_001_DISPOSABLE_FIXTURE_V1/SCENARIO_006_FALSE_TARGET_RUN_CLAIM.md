# SCENARIO 006 — FALSE TARGET RUN CLAIM

## Hazard shape

The runner fails before the target helper executes, but the report language blurs that into “the helper failed,” “the target failed,” or “the repair failed.”

## What this tests

Whether the reviewer separates runner status from target-helper status.

## Expected judgment

`TARGET_NOT_RUN`

Secondary judgment:

`CORRECT_RECORD_REQUIRED`

## Required response

State exactly what ran and what did not run.

Record the no-start boundary.

Do not infer target behavior from runner failure.

## Forbidden response

Do not claim a target-helper failure.

Do not claim helper evidence exists.

Do not call a no-start a failed target run.

## Clean wording

Runner failed.

Target helper did not run.

No target-helper result exists.
