# Helper Save Preflight Router Tool TODO

Created: 2026-06-03
Status: TODO / TOOL DESIGN / NOT ACTIVE / NOT DOCTRINE
Source: helper-control blocker-chain root intake

## Task

Design a preflight router that reads an intended save manifest, classifies blocker family, and returns the next safe route without repairing or saving by itself.

## Required Decisions

```text
Input manifest shape
Supported blocker families
Required proof commands
Stop conditions
Receipt fields
Ignored-file exception handling
Final-sentinel expectation
```

## Starter Checks

- manifest exists before staging;
- expected paths exist or are explicitly parked;
- ignored expected paths have named exceptions;
- staged set is rebuilt after rewrite;
- `git diff --check --cached` runs after staging;
- final sentinel is required before PASS;
- dirty protected files stop the route.

## Done Condition

A read-only router spec exists with fixtures showing at least one PASS route and one BLOCKED route for each blocker family.

## Blocked Uses

Do not activate, install, or call the router current until fixtures and a proof receipt exist.
