# Powerplay — Helper Growth Plan Empty Collection Binding Failure

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
Status: POWERPLAY CARD / SORTING BENCH / LEARNING EVENT

## Triggering event

Script: `LOCK_SAVE_HELPER_GROWTH_CHAIN_FLIGHT_RECORDER_CHECKPOINT_V1.ps1`

Failure:

`Add-PlanItem ... Cannot bind argument to parameter 'Plan' because it is an empty collection.`

## What actually happened

The script created an empty `System.Collections.ArrayList` as the plan container, then called `Add-PlanItem` to populate it. PowerShell rejected the empty list at the function parameter binding stage because the parameter was mandatory and did not allow an empty collection.

## False blames blocked

- not a moving_forwards.txt content failure
- not a Git failure
- not an ignored-path failure
- not a Code Gate parser failure
- not user action

## Reusable fix

Allow empty collections on function parameters that intentionally receive a collection before it is populated, or let the plan builder own the collection internally.

## Reopen trigger

Any generated helper fails with a valid empty collection being rejected by parameter binding before work begins.
