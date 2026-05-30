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

<!-- PATH_CLASS_50_WAVE_REPAIR:CA6ACB36D68C4288 -->
## Path-Class 50-Wave Repair Note

Status: CONFIRMED_PATH_CLASS_REPAIR / NOT_DOCTRINE
WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
RunId: 20260530_195739

Object path: BRAIN_LEARNING/ROOT_DROP_HASH_KEY_INTAKE_RULE_20260530.md
Source inputs: INTAKE
Path class: key/hash/intake issue
Repair type: INTAKE_GATE_KEY_HASH_GUARD
Confirmed fields/classes: Keying

Controlled key:
- WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
- Key tags: PATH_CLASS_REVIEW, CONFIRMED_50_PACKET, INTAKE_GATE_KEY_HASH_GUARD, ROOT_LAYER_DROP_DOWN

Hash-to-receipt join:
- Target SHA256 before repair: 618A44CE6E1611B6FA4CD9B8B75F5B81A7C1FB5D95F2A16649F6753FA8DF3A7E
- Receipt: PROOF_HISTORY/PATH_CLASS_50_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
- Route index: HOUSE_WORK/WORK_SHED/INDEXES/PATH_CLASS_50_WAVE_REPAIR_ROUTE_INDEX_20260530.md
- What this hash proves: the bounded pre-repair target state for this packet.
- What this hash does not prove: doctrine promotion, full object cleanliness, or unrelated field closure.

Route / ledger / map:
- Ledger home: confirmed path-class packet saved with this repair.
- Map relation: Intake Gate finding and Root-Layer watch row -> path-class review -> confirmed packet -> bounded target note -> re-audit compare.
- Return path: confirmed packet and re-audit compare report.

Root-layer drop-down:
- Upper object: parked watch-row finding for this path.
- Lower object: path class, helper/tool, route/path, key/hash/intake, proof-only, or stale-currentness cause.
- Root cause tested: row was reviewed against current target content before repair.
- Separation verdict: repair only the named reviewed fields/classes; do not judge unrelated object health.
- Runtime proof needed: re-run Intake Gate and Root-Layer helpers after repair.

No-op / skip-only latch:
- NO-OP NO-COMMIT LATCH applies to the runner.
- SKIP-ONLY IS NOT REPAIR.
- Commit allowed only when RepairedTargets > 0.
- Commit message must match actual action.

Currentness and disposition:
- Currentness: CURRENT_SUPPORT_REPAIR_NOTE
- Disposition: KEEP_WITH_OBJECT_UNTIL_REAUDIT
- Next condition: re-audit and compare closure for this path and these fields/classes.

Boundary:
- confirmed packet rows only
- no doctrine
- no ACTIVE_GUIDES
- no CURRENT_TRUTH_INDEX
- no broad refactor
- no delete
- no move
- no automation
- no watcher
<!-- /PATH_CLASS_50_WAVE_REPAIR:CA6ACB36D68C4288 -->
