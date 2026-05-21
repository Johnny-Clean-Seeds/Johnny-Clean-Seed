# Level 2 Approved-Helper Route — Selected Next — 20260521

## Status

SELECTED NEXT / NOT INSTALLED

## Why Selected

Level 0 job consumption passed.

Level 1 read-status passed.

No-script watcher drop passed with guardrail.

Watcher liveness / stale-PID restart durability passed.

The trigger lane is now stable enough to design Level 2.

## Boundary

Level 2 is not Level 3.

Level 2 must only run named approved helpers.

Level 2 must not execute arbitrary shell text.

Level 2 must not perform Mr.Kleen repo house-save execution until Level 3 is separately designed and proved.

## Minimum Level 2 Requirements

- explicit allowlist of helper names;
- helper path hash checks;
- input contract;
- output receipt;
- no delete;
- no raw shell expansion;
- no broad filesystem crawl;
- no permission expansion;
- no junction/symlink teleporter;
- stop on mismatch;
- proof receipt before promotion.

## Next Action

Design the smallest Level 2 approved-helper route.
