# Helper Gap And Cause Ladder Rule V0.1

Status: PUBLIC_NOTE / HELPER_GAP_CAUSE_LADDER / ACTIVE_LIMITED_SUPPORT / NOT_DOCTRINE
Date: 2026-06-13

Purpose:
Give agents a clean way to notice missing, stale, weak, or contradictory helper coverage without skipping the main task or treating helper files as the house.

## Core Rule

When helper trouble appears, freeze the helper lane, find the lowest cause, treat only that layer, rerun upward, then return to the original task unless the user gave a hard stop or the route is unsafe.

Helper trouble includes:

- no helper exists for a recurring or high-risk task;
- a helper exists but lacks a one-job contract;
- helper names, anchors, Chat Drops, public notes, or local files disagree;
- a helper is stale, missing, contradictory, or too broad;
- a script/helper fails, prints unclear success, or lacks evidence;
- user steering changes a task after work already started.

## Required Signals

Use one of these visible signals:

- `HELPER_GAP_DETECTED` when helper coverage is missing or too weak for the current job.
- `HELPER_STALE_DETECTED` when helper cards, anchors, maps, paths, or mirrors conflict.
- `HELPER_CAUSE_LADDER_CLEAR` when the helper lane has current files, mirrors, route boundaries, and no open packet found by the scanner.

## Lower-Cause Ladder

Check from lowest to highest:

1. entry identity and dead-chat carry;
2. active object and current authority;
3. source, custody, and path freshness;
4. helper presence and helper state;
5. helper contract shape;
6. command, tool, and environment shape;
7. mutation permission and route contract;
8. proof, receipt, and DoesNotProve;
9. public, board, and Chat Drop sync.

Do not fix a higher layer until the lower failing layer is named and contained.

## Helper Gap Packet

When a gap matters, create or fill a helper-gap packet with:

- active task;
- missing helper need;
- trigger evidence;
- lowest cause layer;
- one job;
- allowed actions;
- blocked actions;
- proof needed;
- DoesNotProve;
- public, board, or Chat Drop sync need.

Packet template:

`HOUSE_WORK\HELPER_GAP_AND_CAUSE_LADDER_20260613\HELPER_GAP_PACKET_TEMPLATE_V0_1_20260613.md`

## Promotion Boundary

New helpers start as `candidate_contract`.

They may become `active_limited` only after:

- one narrow job;
- route contract;
- dry fixture or intentional negative test where useful;
- proof receipt;
- blocked actions;
- DoesNotProve.

No helper can promote itself.

## Scanner

Read-only scanner:

`TOOLS\HelperGapCauseScanner.ps1`

The scanner may inspect current helper surfaces, Chat Drop mirrors, anchor visibility, board pressure, and open helper-gap packets.

It must not edit, move, delete, stage, commit, push, clone, fetch, pull from GitHub, or print a success verdict after missing proof.

Dry-run suite:

`TOOLS\Invoke-HelperDryRunSuite.ps1`

Use this when the user asks to run helper files one by one, give helpers dry tasks, log findings, and repair only what evidence proves. The suite covers the current/live helper surface first, writes timestamped reports, and records intentional negative tests separately from cleared scoped checks.

## Agent Behavior

At the start of house/workbench work, name helper files checked, used, skipped, missing, stale, or contradictory.

If no helper exists but one clearly would help, keep the original task active if safe, soft-apply a temporary checklist, then use this rule to decide whether to create a real helper card, packet, or scanner entry before close.

Do not make every good idea a helper. Create helper structure only for repeated pain, high-risk work, cross-surface sync, agent drift, missing/stale authority, tool errors, or tasks likely to recur.

## Does Not Prove

This rule does not authorize cleanup, deletion, overwrite, broad repair, Git/GitHub work, doctrine promotion, automation, or source authority. It only creates a guarded way to detect helper gaps, diagnose lower causes, and store proof.
