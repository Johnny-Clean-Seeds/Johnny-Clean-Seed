# Manifest First Exact Save Tool TODO

Created: 2026-06-03
Status: TODO / TOOL DESIGN / NOT ACTIVE / NOT DOCTRINE
Source: helper-control blocker-chain root intake

## Task

Build a manifest-first exact-save tool or wrapper that stages only the intended paths, respects ignored-path exceptions, runs staged proof, and refuses closeout without final sentinel evidence.

## Required Fields

```text
ManifestPath
ExpectedPaths
ExpectedIgnoredPaths
AllowedForceAddExceptions
RequiredChecks
ProtectedPaths
ReceiptPath
FinalSentinel
CloseCondition
```

## Required Proofs

- exact staged set equals manifest allowed set;
- ignored expected files are either parked or explicitly exceptioned;
- `git diff --check --cached` passes after staging;
- protected-file scan is clean;
- receipt contains hashes for changed artifacts;
- final sentinel appears after proof and before PASS.

## Done Condition

A fixture-backed dry run proves the tool blocks stale staged index, dirty diff-check, missing final sentinel, and unauthorized force-add.

## Blocked Uses

No commit, push, active helper claim, or doctrine claim comes from this TODO.
