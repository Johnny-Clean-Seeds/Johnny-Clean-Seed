# TODO — Artifact Self-Check After Send Gate

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: open child TODO / live-use test case
Parent: Recursive Carryover / Point-of-Work Link Failure
Parent rule: After-Fix Carryover Latch

## Purpose

Preserve the concrete child case that exposed the carryover failure.

After creating, editing, or sending a user-facing file/artifact, the assistant must self-check the artifact before treating it as ready.

## Trigger

After sending or creating:

- markdown file;
- PowerShell script;
- handoff packet;
- zip/package;
- doc;
- spreadsheet;
- slide deck;
- PDF;
- image output;
- any user-facing artifact.

## Required artifact check

Verify:

- file exists;
- file opens / is readable;
- expected size;
- expected line count, page count, sheet count, or slide count where relevant;
- required sections and markers;
- source-context carryover;
- no stale work-order scope;
- no missing key wording;
- no placeholders left behind;
- no truncation;
- no NUL / replacement characters;
- no contradiction with current house state;
- output format matches user request;
- artifact has not silently dropped source material.

## If failure is found

1. Fix the artifact.
2. Say what was wrong.
3. Say what was corrected.
4. Re-check.
5. Run After-Fix Carryover Latch.

## Proof of use

A later artifact task passes this TODO when the assistant checks the artifact before calling it ready and reports the check cleanly.

## Boundary

This TODO is support only.

It does not become active work by existence.

It does not rewrite active guides or doctrine.

---

## 2026-05-20 — Disposition After Compose-Review First Live Use

Status: STILL OPEN / DISTINCT CHILD TODO.

Disposition:
Artifact Self-Check is not closed by Compose-Review-Reflect-Capture.

Reason:
- Compose-Review-Reflect-Capture checks significant drafts before sending.
- Artifact Self-Check checks created/sent user-facing artifacts before calling them ready.
- After-Fix Carryover fires after a meaningful fix/correction if a reusable lesson was exposed.

Next proof needed:
- a later created/sent artifact is checked for existence, readability, expected size/lines/pages/slides/sheets, required sections, source carryover, no stale scope, no missing wording, no placeholders, no truncation, no NUL/replacement characters, no contradiction with current house state, and correct output format.

Boundary:
- support TODO only;
- no active guide rewrite;
- no doctrine;
- no CURRENT_TRUTH_INDEX rewrite.

---

## 2026-05-20 — Code Cabinet Source Note Quiet Self-Proof / Artifact Self-Check First Live Use

Status: PASS WITH GUARDRAILS AS FIRST LIVE USE.

Artifact package checked:
- Code Cabinet rule;
- save package skeleton;
- skeleton instantiation;
- source note source-ore transcript;
- quiet self-proof behavior rule;
- disposition note;
- live-use TODO;
- artifact self-check proof note;
- receipt after writing.

Checks:
- exists;
- readable UTF-8 text;
- nonempty;
- no NUL;
- no replacement characters;
- no placeholder markers;
- required phrases verified;
- final git proof required clean synced state.

Disposition:
- Artifact Self-Check fired successfully on a real Mr.Kleen artifact package.
- TODO remains open for more varied future artifacts.

---

## 2026-05-20 - Artifact Self-Check Second Live Use

Status: PASS WITH GUARDRAILS AS SECOND / VARIED LIVE USE.

Artifact type:
- downloadable PowerShell script delivery plus Mr.Kleen save package.

Evidence:
- V1 stopped before writing because exact source-text validation was brittle;
- V2 proved downloaded ps1 resolver was needed and stopped before writing because source regex validation was still brittle;
- V3 used resolver-first delivery, parser check, non-brittle source validation, generated-artifact checks, receipt, commit, push, fetch, HEAD equals origin/main, and final clean status.

Routed home:
- HOUSE_WORK\WORK_SHED\SORTING_BENCH\ARTIFACT_SELF_CHECK_SECOND_LIVE_USE_POWERSHELL_DELIVERY_20260520.md

Disposition:
- stronger second live-use proof;
- TODO remains open for more varied artifact types;
- no closure;
- no promotion.
