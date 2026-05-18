# Clean Seed Check — Anchor Sync Check

Lock status: CHECK CANDIDATE / READY FOR PROOF
Lane: brain/learning
Main boss served: Main Boss 01 — State / Anchor Truth Alignment

## Purpose

The Anchor Sync Check prevents the house from resuming from the wrong door.

Before any boss cycle, runtime lane move, command build, promotion, bridge action, large issue ranking, cleanup, or handoff, the house must prove the current active state is aligned.

## Required Inputs

The check must inspect:

1. ACTIVE_ANCHOR.txt
2. CURRENT_TRUTH_INDEX.txt
3. current git branch
4. current git HEAD
5. current git status
6. latest relevant receipt/checkpoint
7. current user command
8. next allowed move
9. blocked moves

## Pass Condition

Anchor Sync passes only when all are true:

- ACTIVE_ANCHOR.txt names one current active ball.
- The active ball matches the current user command or the latest approved checkpoint.
- Current git branch and HEAD are known.
- Working status is clean unless the current task is an approved local repair before commit.
- One next allowed move is named.
- Blocked moves are explicit.
- CURRENT_TRUTH_INDEX.txt is used for house orientation and source routing, not as a stale active-ball override.
- Source-ore, proof-history, receipts, old anchors, and prior chat do not outrank the current active anchor.
- No runtime command, /system, live file, bridge action, or promotion is allowed unless explicitly named by the active anchor and approved scope.

## Fail Condition

Anchor Sync fails if any are true:

- active anchor is missing
- active anchor points to an old commit or old task
- active anchor conflicts with latest saved checkpoint
- next allowed move is unclear
- blocked moves are missing
- dirty status exists without a scoped repair reason
- source-ore is treated as active doctrine
- proof-history is treated as active doctrine by volume
- approval phrase is reused outside its named scope
- the assistant tries to fight a raw issue pile before grouping and ranking parent bosses

## Required Output

Every Anchor Sync Check should return:

- Branch
- HEAD
- Working status
- Active ball
- Next allowed move
- Blocked moves
- Latest relevant receipt/checkpoint
- Verdict: PASS, FAIL, PARTIAL, BLOCKED, or YIELD
- If FAIL or PARTIAL: smallest safe repair target

## Repair Rule

If Anchor Sync fails, repair only the smallest state seam first.

Do not continue into deeper boss work until the anchor is repaired, proved, committed, pushed, and final clean status is shown.

## Current Installed Context

Installed after stale-anchor failure where ACTIVE_ANCHOR.txt still pointed to main @ 756437a and old Boss Cycle Leash work while the current brain had moved to Main Boss 01 — State / Anchor Truth Alignment.

Starting install position:

main @ 7d048b2

## Current Next Use

Use this check before continuing Main Boss 01.

The next allowed move after this check is locked should be:

Run Anchor Sync Check against the current brain, then decide whether Main Boss 01 is closed or whether another state-alignment child remains.
