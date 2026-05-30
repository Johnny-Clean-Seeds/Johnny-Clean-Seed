# Key/Ledger/Map Driver Ignored-Path Learning Event

Date: 2026-05-30
RunId: 20260530_010525
WorkKey: KEY_2E6F99ED9EFE
Status: ACTOR-OWNED LEARNING EVENT / FILE-LEVEL SAVE

## Trigger

LOCK_SAVE_KEY_LEDGER_MAP_DRIVER_V1.1.ps1 repaired the Git CWD route, then failed at staging:

Git refused to add a target under HOUSE_WORK/WORK_SHED because that lane is ignored by .gitignore.

## Actor-owned failure

The save route knew it was writing target files under ignored paths, but the script did not prepare an ignored-path manifest or use exact-file force-add.

The failure was not a Git problem.

It was a lane-staging proof problem.

## Repair rule

When a save object intentionally includes files under ignored paths:

- decide the lane first;
- write an ignored-path manifest;
- include role, lane, reason, size, SHA256, ignore witness, and allowed Git action;
- use exact-file force-add only;
- never force-add a folder;
- never force-add a wildcard;
- verify staged set equals the expected file list;
- then commit, push, verify HEAD equals origin/main, and verify final status clean.

## Connection to Key/Ledger/Map Driver

This failure also proves the driver concept.

A map saying a file belongs in HOUSE_WORK/WORK_SHED is not enough.

The save driver must know the lane is ignored and must route staging through the manifest exception.
