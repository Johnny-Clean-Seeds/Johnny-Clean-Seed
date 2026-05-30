# Key/Ledger/Map Driver Rule

Date: 2026-05-30
RunId: 20260530_010525
WorkKey: KEY_2E6F99ED9EFE
SourceName: moving_forwards.txt
SourceSha256: 2E6F99ED9EFE3731CDDFFF1574ED8FE3C4107EFA2FEFF56DC2ABE1B640F83E19
Status: SUPPORT RULE / SOFT SUIT CANDIDATE
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Core rule

Keys, ledgers, and maps are not passive labels.

For major helper-chain, source-heavy, save-heavy, proof-heavy, or repeatedly confusing work, each working part needs a keyed identity and a driver route.

Short form:

Key identifies.
Map routes.
Ledger remembers state.
Event proves motion.
Pointer names next action.
Summary reverse-walks the chain.
Final packet closes only after proof.

## Why this exists

The Helper Growth Chain Flight Recorder needs crawl-ready files, but crawl-ready must not become a broad crawler or a maze of files all claiming authority.

The clean shape is a control plane:

- keyring: identifies each major object and its driver key;
- route map: tells where the object should go next;
- file registry: tells how each file can be read, updated, appended, proved, stopped, and handed off;
- ledger driver index: records state changes and next surfaces;
- append-only event log: records meaningful action history;
- proof receipts: separate evidence from claims;
- reverse-walk summary: compresses the trail without hiding failures;
- final packet: closes only after proof and state agree.

## Working principle

A file should not have to guess what to do next.

A helper should be able to read:

1. current pointer;
2. state machine;
3. keyring route map;
4. file registry;
5. ledger driver index;
6. next action card.

Then it should know:

- what object it is handling;
- which key identifies it;
- which lane owns it;
- what it may update;
- what must be append-only;
- what proof is needed;
- where it hands off;
- what stops the route.

## Fit with existing house

This extends the House Keyring Graph idea into live helper-chain motion.

It does not replace proof.
It does not grant authority by key alone.
It does not automate the house.
It does not allow broad crawling.
It does not promote source material to doctrine.

It turns keyed identity into bounded routing behavior.

## Required file behavior

Each major working part should have:

- ObjectKey or DriverKey;
- Role;
- Lane;
- LifecycleState;
- ReadAfter;
- ReadBefore;
- UpdateMode;
- AppendAllowed;
- ProofNeeded;
- StopIf;
- HandoffTarget;
- NextQuestion.

## Driver map behavior

Driver maps may direct work only inside approved boundaries.

Allowed directions:

- read next file;
- append next event;
- create next proof receipt;
- update ledger view;
- update reverse-walk summary;
- create handoff packet;
- block with return point.

Blocked directions:

- broad crawl;
- Git save without explicit save route;
- deletion;
- moving files;
- network action;
- doctrine promotion;
- ACTIVE_GUIDES rewrite;
- CURRENT_TRUTH_INDEX rewrite;
- final PASS without proof.

## Ledger behavior

Ledgers remember state and next surface.

They must not become authority over truth by themselves.

A ledger entry must point to evidence, event, proof, or blocker.

If proof is missing, ledger state must say pending or blocked.

## Map behavior

Maps route; they do not command beyond lane authority.

A map can connect working parts without merging their authority.

Snap-linking is allowed when it clarifies handoff.
Snap-linking is not doctrine.

## Soft Suit label

SOFT SUIT NOW / UNSAVED UNTIL PROVEN / NOT DOCTRINE

Wear as:

"Keys identify, maps route, ledgers drive state, events prove, summaries reverse-walk."

## First live-use target

Use this on the Helper Growth Chain Flight Recorder first live-use packet.

That packet should include:

- CONTROL/CRAWL_POINTER.json;
- CONTROL/STATE_MACHINE.json;
- CONTROL/KEYRING_ROUTE_MAP.json;
- CONTROL/FILE_REGISTRY.csv;
- MAPS/WORK_PART_DRIVER_MAP.md;
- LEDGERS/LEDGER_DRIVER_INDEX.csv;
- EVENTS/EVENT_LOG.jsonl;
- human-readable Crawl Contract blocks in major markdown files.

## Close condition

This rule earns stronger status only after a real helper-chain run shows that the key/ledger/map driver system reduced confusion, preserved proof, avoided bloat, and did not overreach.
