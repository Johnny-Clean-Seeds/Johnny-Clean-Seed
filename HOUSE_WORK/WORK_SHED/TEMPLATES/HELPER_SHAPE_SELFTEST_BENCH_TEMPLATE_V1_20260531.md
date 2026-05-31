# Helper Shape Self-Test Bench Template V1

Date: 2026-05-31
Status: TEMPLATE CANDIDATE / PARKED / NOT DOCTRINE
WorkKey: HELPER-SHAPE-SELFTEST-BENCH-TEMPLATE-20260531

## Purpose

Before a generated helper/save script reaches any Git write branch, test the same output-shape and file-writing mechanics in a safe local report space.

## Test cases

Writer must accept and preserve:

1. blank line
2. scalar string
3. string array
4. single-item array
5. empty array
6. null-ish input normalized safely
7. markdown colon line
8. markdown dash list
9. markdown backtick/code marker
10. path with spaces
11. generated content from object rows
12. repeated write / append behavior

## Required invariant

Document-writing helpers must not reject valid document lines merely because a line is empty.

## Example acceptance rules

- Blank line stays blank.
- Scalar text becomes one line.
- Array text stays ordered.
- Null input becomes empty list or explicit blocked state depending on function purpose.
- The self-test runs in `_MISC_DRAWER/READ_REPORTS` or another local-only safe output area.
- The self-test writes no repo source file.
- The self-test performs no Git action.
- The save branch cannot run unless self-test passed in the same execution.

## Project-first guard

If the active object is a project save, the self-test must stay small. It is a gate, not a new project.

## Parking

Lane:
WORK_SHED/TEMPLATES

Return trigger:
After Coding Room proof-chain save clean close.

Proof need:
One generated save script uses this bench and catches the known blank-line/binder failure before direct save.

Future use:
All future generated save scripts that write markdown/report/proof files.
