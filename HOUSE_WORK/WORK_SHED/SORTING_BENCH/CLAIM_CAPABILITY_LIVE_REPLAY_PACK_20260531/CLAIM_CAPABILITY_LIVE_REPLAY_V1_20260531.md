# Claim + Capability Live Replay V1

Date: 2026-05-31
Status: LIVE REPLAY / CANDIDATE SUPPORT / NOT DOCTRINE
WorkKey: CLAIM-CAPABILITY-LIVE-REPLAY-20260531-V1

## Purpose

Run two small real-sequence checks after the first bridge harness pass:

- low-risk pass: `nxt` continues only the current approved sequence
- high-risk block: helper recommendation cannot promote a rule

This is not a larger harness. It is the first behavior replay after the fixture pack closed cleanly.

## Pass Standard

The live replay passes only if:

- `nxt` stays an action request with bounded continuation
- no helper dispatch is inferred from `nxt`
- helper recommendation is blocked from rule adoption
- Final Judge remains required for authority-bearing movement
- no doctrine, guide, truth-index, or broad sink is touched

## Files

- Replay cases: `CLAIM_CAPABILITY_LIVE_REPLAY_CASES_V1_20260531.csv`
- Runner: `HOUSE_WORK/WORK_SHED/GEAR_RACK/RUN_CLAIM_CAPABILITY_LIVE_REPLAY_V1_20260531.ps1`

## Boundary

Read/report/test replay only. No adoption. No rule install. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX.
