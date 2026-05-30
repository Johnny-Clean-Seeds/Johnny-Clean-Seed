# Staged-Set Actual Changed Files Guard

Date: 2026-05-30
Status: BRAIN LEARNING / SAVE-ROUTE GUARD / NOT DOCTRINE
WorkKey: LOWER-LAYER-SAVE-ROUTE-HARNESS-ROOT-REPAIR-20260530-V1-2-1

## Rule

Save scripts must not require unchanged already-correct files to appear in `git diff --cached --name-only`.

## Why

`git add <file>` stages content only when the file differs from HEAD.

If a file is already correct, it may be part of the intended/touched list but absent from the staged set. That is not a failure.

## Correct verification

- Actual staged paths must be inside the allowed footprint.
- Required changed files must be staged.
- Unchanged already-correct files may be absent from staged paths.
- Partial failed footprints from a prior run may be accepted only when every dirty path is inside the known allowed footprint.

## Boundary

This is a save-route guard. It does not authorize broad cleanup, reset, delete, move, automation, watcher, Whirlpool, doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, universal mapper, graph database, or whole-house crawl.