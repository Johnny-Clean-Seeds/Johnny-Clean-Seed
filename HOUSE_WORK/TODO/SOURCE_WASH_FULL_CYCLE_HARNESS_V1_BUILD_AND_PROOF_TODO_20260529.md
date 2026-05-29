# TODO — Build and Prove Source Wash Full Cycle Harness V1

Date: 2026-05-29
Status: OPEN
Parent object: SOURCE_WASH_FULL_CYCLE_HARNESS_V1
Lane: Local Code Workbench / Source-to-House Wash Helper

## Goal

Build `RUN_SOURCE_WASH_FULL_CYCLE_V1.ps1` as a report-only controller that proves full wash-cycle closure.

## Required guardrails

- Code Gate before run.
- Report-only V1.
- Exact root only.
- Weak-PC-safe limits.
- No Git writes.
- No move/delete/system actions.
- No doctrine promotion.
- No ACTIVE_GUIDES edit.
- No CURRENT_TRUTH_INDEX edit.
- No fake PASS.

## Required proof sequence

1. Generate script into `Desktop\123\_MISC_DRAWER\READY_FOR_CODE`.
2. Run PowerShell Code Gate.
3. Run tiny sample proof.
4. Run one real bounded root proof.
5. Verify all six required outputs.
6. Verify receipt hashes.
7. Verify B close state.
8. Assistant/user judgment on whether V1.1 or save adapter is warranted.

## Required outputs

- `FULL_WASH_CYCLE_STATE_V1_<RunId>.json`
- `FULL_WASH_CYCLE_REPORT_V1_<RunId>.md`
- `FULL_WASH_CYCLE_DECISION_LEDGER_V1_<RunId>.csv`
- `FULL_WASH_CYCLE_ROUGH_SPOT_LEDGER_V1_<RunId>.csv`
- `FULL_WASH_CYCLE_ROPE_LEDGER_V1_<RunId>.md`
- `FULL_WASH_CYCLE_RECEIPT_V1_<RunId>.txt`

## Close condition

Close only when V1 produces a clean B close on a bounded root and the receipt proves all required output files.
