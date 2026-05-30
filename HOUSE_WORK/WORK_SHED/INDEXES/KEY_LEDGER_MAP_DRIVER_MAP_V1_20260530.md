# Key/Ledger/Map Driver Map V1

Date: 2026-05-30
RunId: 20260530_010525
WorkKey: KEY_2E6F99ED9EFE
Status: DRIVER MAP / SUPPORT ARCHITECTURE

## Driver chain

User words or event
-> Front Door Selector
-> Object declaration
-> ObjectKey / DriverKey
-> Alpha lock
-> Route map
-> File registry
-> State machine
-> Ledger driver
-> Append-only event
-> Proof receipt
-> Reverse-walk summary
-> Handoff packet
-> Final packet

## Key families

WorkKey: identifies the whole run or source-work family.

TraceId: identifies a specific live-use packet or run.

ObjectKey: identifies a major object inside the packet.

DriverKey: identifies the object's route behavior.

ProofKey: identifies evidence and receipt objects.

LedgerKey: identifies state-memory surfaces.

## Required control-plane files

CONTROL/CRAWL_POINTER.json:
current state and next file/action.

CONTROL/STATE_MACHINE.json:
allowed state transitions.

CONTROL/KEYRING_ROUTE_MAP.json:
key-to-route map.

CONTROL/FILE_REGISTRY.csv:
per-file behavior registry.

LEDGERS/LEDGER_DRIVER_INDEX.csv:
state memory.

EVENTS/EVENT_LOG.jsonl:
append-only event stream.

## File behavior rule

No file should need to carry the whole house.

Each file carries a small Crawl Contract, but the registry and control plane drive navigation.

## Map behavior rule

Maps route work to the next correct surface.

Maps do not create authority.

## Ledger behavior rule

Ledgers remember live state and point to proof.

Ledgers do not replace proof.

## Summary behavior rule

Reverse-walk summaries compress the event chain.

Summaries must not hide blockers, failures, or missing proof.

## Final behavior rule

Final packet closes only when event trail, proof receipts, ledger state, next action status, and boundary all agree.
