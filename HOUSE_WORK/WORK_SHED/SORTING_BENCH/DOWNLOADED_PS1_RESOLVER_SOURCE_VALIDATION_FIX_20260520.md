# Downloaded ps1 Resolver / Source Validation Fix

Date: 2026-05-20

## Status

PASS WITH GUARDRAILS AS DELIVERY METHOD PATCH.

## Failure Pattern

The earlier safe-save method still allowed two repeated delivery failures:

- exact Downloads path failed when the browser renamed or misplaced the file;
- brittle source validation failed when a source file did not match exact wording or narrow regex wording.

## Fix

The safe downloaded script command now needs a file resolver.

Save scripts should validate old/source files for custody and readability, not exact phrasing.

Exact phrase checks belong on current-run artifacts created or patched by the script.

## Result

The method is tighter:

- find file first;
- print found path;
- parse resolved file;
- run resolved file;
- avoid brittle source text checks;
- still stop on real dirty state, missing file, unreadable file, parser error, or final proof failure.

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No script promotion.
