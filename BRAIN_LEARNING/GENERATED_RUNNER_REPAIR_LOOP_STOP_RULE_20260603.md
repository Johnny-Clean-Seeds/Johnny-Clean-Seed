# Generated Runner Repair Loop Stop Rule

Date: 2026-06-03
Status: BRAIN LEARNING RULE / SUPPORT STANDARD / NOT DOCTRINE
WorkKey: GENERATED-RUNNER-REPAIR-LOOP-STOP-20260603

## Source Custody

Primary local source: `C:\Users\13527\Desktop\123\rawnotes.txt`
Primary source SHA256: `82637CDE75E2A2B0239DB438E9FF99845B7BC973710FC4427895D36B7D6A6525`
Primary source size: 27,413 bytes
Primary source lines: 430

Work-report support source: `C:\Users\13527\.codex\attachments\0eb0f585-ee69-4a51-a5dd-ad3d0051c4f8\pasted-text.txt`
Work-report SHA256: `EBE346884AB65CD3737CEE0B19BBC669A699DFC86E7005C886C416F4025AB2E5`
Work-report size: 76,451 bytes
Work-report lines: 1,310

Source boundary: these sources are intake and reasoning support, not authority by themselves.

## Rule

If a generated runner fails twice in the same lane, stop generating more runners for that lane.

After the stop:

- preserve the last good checkpoint;
- treat the runner failures as lower-layer harness evidence;
- do not run the target/helper;
- do not send or run another repair runner immediately;
- switch to the simplest safe medium: plain-language design, manual review, or a smaller self-checking file only after proof.

## Trigger Examples

- PowerShell quoting or here-string expansion errors.
- Literal `$variable` text being evaluated as live PowerShell.
- `Join-Path` array binding or path construction errors.
- Unset variable errors inside generated report text.
- Repeated "fix runner with another runner" behavior.
- A runner printing a next step that contradicts its own verdict.

## Harness Before Helper

Generated runners must earn trust before they can produce trust.

Every generated runner needs a small identity and preflight card before it is allowed to act as proof support:

- runner name and version;
- intended lane;
- target object;
- allowed writes;
- blocked writes;
- allowed Git commands;
- blocked Git commands;
- whether target execution is allowed;
- whether fixture execution is allowed;
- whether it may write receipts;
- whether it may print `PASS`;
- whether it may mutate pointer or state;
- parse status;
- static status;
- fixture status;
- stop condition;
- last good checkpoint.

## PowerShell-Specific Guards

- Treat evidence text and command text as different materials.
- Use literal templates or explicit escaping when preserving `$`, backticks, quotes, braces, here-strings, colons, or code examples.
- Build important path variables one line at a time before putting them into arrays.
- Do not combine path construction, array construction, file writing, receipt writing, and next-route decision into one dense expression.
- Treat `Set-StrictMode` failures as proof of an unsafe value/shape, not as noise.

## Current First Use

Applied to Helper Stress Bench Row 001.

Last good checkpoint:

`ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_COMPLETE`

Blocked lane:

`DISPOSABLE_FIXTURE_DESIGN_RUNNER`

Target helper:

`READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1`

Target helper execution status:

`NOT RUN`

Next safe medium:

Plain markdown fixture design and incident record. No generated runner. No target execution.

## DoesNotProve

This rule does not prove any helper is safe, correct, active, trusted, or ready to run.

This rule does not prove the failed generated runners are worthless. It only says their lane is stopped until harness proof exists.

This rule does not promote any report, receipt, or runner output to doctrine.

## Boundary

This file does not authorize implementation, helper execution, fixture execution, tool activation, watcher, automation, root cleanup, pointer mutation, ACTIVE_GUIDES edit, CURRENT_TRUTH_INDEX edit, broad Git action, move, delete, rename, commit, push, or doctrine promotion.
