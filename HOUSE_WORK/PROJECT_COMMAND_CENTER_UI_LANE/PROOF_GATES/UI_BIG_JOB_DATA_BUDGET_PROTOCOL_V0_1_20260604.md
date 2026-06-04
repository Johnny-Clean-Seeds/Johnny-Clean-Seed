# UI Big Job Data Budget Protocol V0.1

Date: 2026-06-04
Status: DATA CONTROL PROTOCOL / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: UI-BIG-JOB-DATA-BUDGET-PROTOCOL-V0-1-20260604

## Rule

`READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL`

## Operating Protocol

- Start from the latest receipt, manifest, and path map before reading content.
- Read full source files only when modifying, verifying, or extracting an undecided rule.
- Prefer path, hash, status, and verdict tables over repeated prose summaries.
- Avoid broad scans outside the active lane unless a blocker points there.
- Phase work when scope grows; deliver the next usable layer instead of rereading everything.
- Treat data cost as a sizing signal, not a stop excuse, when the next safe action is clear.
- Report data-heavy areas compactly by count, hash, path, and decision.

## Required Report Fields

```text
DataRule: READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL
OrientationFiles:
FullFilesRead:
BroadCrawlUsed: yes/no
ReductionUsed: yes/no
Reason:
DoesNotProve:
```

## Stop Gates

- Two plausible lanes with no clear winner.
- Credential/private-data uncertainty.
- Required package install, watcher, automation, or target/helper execution.
- Commit/push would require unrelated unknown material.
