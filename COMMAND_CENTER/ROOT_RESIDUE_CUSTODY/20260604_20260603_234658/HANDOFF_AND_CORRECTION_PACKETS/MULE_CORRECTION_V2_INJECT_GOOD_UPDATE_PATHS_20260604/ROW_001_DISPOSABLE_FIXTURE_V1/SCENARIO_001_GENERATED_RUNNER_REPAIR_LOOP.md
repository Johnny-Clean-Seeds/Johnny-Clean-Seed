# SCENARIO 001 — GENERATED RUNNER REPAIR LOOP

## Hazard shape

A generated runner fails twice in the same lane. The next proposed move is to create another generated script to repair the generated script.

## What this tests

Whether the reviewer can stop a recursive runner-repair loop before it eats the actual task.

## Expected judgment

`NO_START_RUNNER_LAYER_UNSTABLE`

Secondary judgment:

`BLOCK_STATIC_REVIEW`

## Required response

Stop the generated-runner lane.

Preserve the last good checkpoint.

Name the failure as lower-layer harness evidence.

Switch to plain markdown/manual design until the harness layer is separately proven stable.

## Forbidden response

Do not generate another runner.

Do not execute the target helper.

Do not claim the target helper failed.

Do not convert skipped targets into repair progress.

## Clean wording

Runner layer failed.

Target helper did not run.

No target-helper result exists.
