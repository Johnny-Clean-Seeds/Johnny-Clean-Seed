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
