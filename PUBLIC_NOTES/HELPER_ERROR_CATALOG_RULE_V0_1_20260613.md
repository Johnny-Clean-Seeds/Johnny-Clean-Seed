# Helper Error Catalog Rule V0.1

Status: PUBLIC_NOTE / HELPER_ERROR_CATALOG / ACTIVE_LIMITED_SUPPORT / NOT_DOCTRINE
Date: 2026-06-13

Purpose:
Build a reusable helper-facing error catalog from real errors, intentional negative tests, clean fixes, lowest causes, and DoesNotProve so future helpers can recognize failure shapes without guessing.

## Core Rule

Error examples are training evidence, not shame and not authority.

Each catalog row must name:

- error family;
- trigger;
- bad command or bad condition;
- exact symptom or error text;
- lowest cause;
- clean fix or containment;
- helper that should fire next time;
- proof after fix;
- DoesNotProve.

## Seed Source

User-provided error lists are source material. If the named path is stale, log `PATH_FRESHNESS_CHECK_NEEDED` and use the resolved source only if it is found by exact local evidence.

Known seed attempt:

`C:\Users\13527\Desktop\project_draft notes\errs.txt`

Resolved current seed during install:

`C:\Users\13527\Downloads\errs.txt`

## Intentional Negative Tests

Induce only safe, bounded failures:

- parser/path syntax mistakes;
- missing local paths;
- invalid URL seed;
- broad crawl blocked;
- missing Chat Drop peer;
- coding mutation blocked;
- missing packet root;
- invalid numeric limits.

Do not induce destructive, credential, private-data, network-abuse, package-install, deletion, Git push/pull, or broad crawl failures.

## Tool

Catalog builder:

`TOOLS\Invoke-HelperErrorCatalogBuild.ps1`

The tool writes a timestamped catalog under:

`C:\Users\13527\Desktop\123\_HELPER_ERROR_CATALOGS`

## Does Not Prove

This rule does not prove every possible helper error is covered, does not authorize risky induced failures, and does not replace real evidence from a live incident.
