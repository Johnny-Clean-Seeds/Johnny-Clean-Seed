# Root Drop Hash/Key Intake Rule

Date: 2026-05-30
Status: SUPPORT RULE / NOT DOCTRINE
Authority: not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Rule

Root drops do not run themselves.

Do not use detectors, pulsers, heartbeats, watchers, or polling to notice root drops.

The root holds. An explicit intake pass reads the selected root/drop surface, computes hashes, assigns or reads key codes, compares against the ledger/map, and routes only new, changed, or selected objects.

## Clean flow

ROOT HOLD
-> EXPLICIT INTAKE PASS
-> HASH OBJECT
-> READ OR ASSIGN KEY CODE
-> LEDGER LOOKUP
-> MAP ROUTE
-> ORDER GATE
-> DISPATCH GOVERNOR
-> HELPER / HANDOFF / QUEUE / PARK
-> PROOF RECEIPT

## Why

This kills load.

The system does not keep asking "anything new?" It proves state only when called.

## Key meaning

A key does not mean "run immediately."

A key means:
look me up in the ledger/map, decide my route, order, limits, proof, and whether I am allowed to dispatch at all.

## Boundary

No watcher architecture.
No background detection.
No automatic execution.
No broad crawl.
No Git unless explicitly selected later.
No move/delete.
No doctrine promotion.
