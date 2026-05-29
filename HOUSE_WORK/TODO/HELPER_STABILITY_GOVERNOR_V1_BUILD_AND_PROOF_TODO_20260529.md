# TODO — Build and Prove Helper Stability Governor V1

Date: 2026-05-29
Status: OPEN
Parent object: HELPER_STABILITY_GOVERNOR_V1
First child target: RUN_SOURCE_WASH_FULL_CYCLE_V1.1.ps1

## Goal

Embed Helper Stability Governor V1 into Source Wash Controller V1.1 and prove adaptive pacing without expanding authority.

## Required V1.1 changes

- Add governor parameters.
- Add governor state section to state JSON.
- Add HELPER_GOVERNOR_LEDGER_V1_<RunId>.csv.
- Add governor summary to report.
- Add governor verdict and governor ledger hash to receipt.
- Keep no Git, no move/delete, no doctrine.
- Keep Code Gate first.

## Proof sequence

1. Code Gate probe PASS.
2. Passive governor ledger proof.
3. Ramp proof on clean consecutive batches.
4. Throttle proof with forced watch/pressure condition.
5. Safe stop proof with forced blocked condition.
6. Real bounded Sorting Bench proof.
7. Review whether a second helper should reuse the same contract before module extraction.

## Close condition

Do not close the governor as a reusable pattern until at least one child helper proves it and a second helper reuse proof is planned or completed.
