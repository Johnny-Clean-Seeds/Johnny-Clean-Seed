# Intake + Key-Code Working Rules — Condensed

Date: 2026-05-30
Status: WORKING SUPPORT RULES / NOT DOCTRINE
Authority: not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Job

Turn one selected object into clean, keyed, routed work.

No broad crawl. No automatic run. No fake PASS.

## Core flow

SELECTED OBJECT
-> AUTHORITY LOCK
-> SOURCE CUSTODY
-> HASH / KEY
-> OBJECT SHAPE
-> CONTEXT CARRY
-> CHUNK ONLY IF USEFUL
-> WORD FLAGS
-> RELATION PILES
-> DECISION TABLE
-> LEDGER FIT
-> MAP ROUTE
-> RISK / CODE / UNKNOWN CHECKS
-> HANDOFF
-> PROOF
-> ONE NEXT ACTION

## Root drop rule

Root holds. Root does not watch.

No detectors. No pulsers. No heartbeats. No watchers. No polling.

On explicit intake pass:

ROOT HOLD
-> HASH OBJECT
-> READ OR ASSIGN KEY
-> LEDGER LOOKUP
-> MAP ROUTE
-> ORDER GATE
-> DISPATCH GOVERNOR
-> HELPER / HANDOFF / QUEUE / PARK
-> PROOF RECEIPT

A dropped object does not run itself.

## Key rule

A key does not mean "run now."

A key means:
look me up in the ledger/map, then decide route, order, boundary, proof, limits, and whether dispatch is allowed.

Required key route fields:

- key_code
- object_hash
- object_key
- route_name
- order_index
- prerequisite_keys
- proof_required_to_unlock
- unlocks_keys
- dependency_reason
- lane_owner
- boundary_class
- maturity_state
- allowed_helper_type
- max_concurrent_helpers
- batch_size
- max_fan_out
- lock_group
- next_growth_step
- next_surface
- stop_condition
- if_blocked
- if_failed
- if_passed

## Logical growth rule

Keys are rungs, not fireworks.

Each proven step becomes the floor for the next step.

RAW does not unlock helper action.
SORTED does not claim proof.
ROUTED does not mean done.
TESTED does not mean doctrine.
PROVEN can unlock the next bounded step.
STABLE can become part of normal route.
BLOCKED stops the chain until repaired or parked.

## Branch rule

Parallel branches are allowed only when bounded.

Every branch must declare:

- branch_key
- parent_key
- branch_owner
- proof_required
- expected_output
- stop_condition
- join_back_key
- return_handoff
- main_route_takeoff_key

A branch may finish locally while the vine continues.

Branch close states:

- MERGE_BACK
- END_LOCAL
- PARK_BRANCH
- BLOCK_BRANCH
- SUPERSEDE_BRANCH
- PROMOTE_TO_MAIN_CANDIDATE, only by explicit decision and proof

## Gate family

Use only the gates needed for the object.

Core gates:

- Authority Shell
- Source Custody
- Data Contract
- Context Carry
- Helper Capability
- Chunk
- Chunk Quality
- Word
- Entity Extraction
- Relative Pile
- Decision Table
- Code Branch
- Risk / Blast Radius
- Backpressure / Choke
- Duplicate / Stale / Data Waste
- Ledger Fit
- Map Route
- Dead-Letter / Unknown
- Handoff
- Readiness Review
- Operator Approval
- Feedback Click
- Balance / Wobble
- Escalation
- Runbook / Playbook
- Proof
- Final Judge

## Helper-readiness rule

Every helper-facing route must answer:

- Where am I?
- What object am I touching?
- What key identifies it?
- What lane owns it?
- What may I read?
- What may I write?
- What must I not touch?
- What proof must I produce?
- What event/ledger row should I leave?
- What stop condition applies?
- What next surface receives the handoff?
- When do I ask the operator?

## Backpressure rule

If the system starts wobbling, reduce load before adding machinery.

Wobble signs:

- too many chunks;
- too many unknowns;
- too many branches;
- repeated same correction;
- unclear next action;
- registry/keyring drift;
- proof after PASS instead of before PASS;
- code before judgment;
- broad crawl pressure;
- user confusion.

Recovery:

- carry key, not furniture;
- reduce batch;
- write handoff;
- park overflow with return trigger;
- prove one small action;
- then continue.

## Code rule

Intake does not execute code.

Code-looking material routes to Code Branch / Code Gate.

Git, commit, push, move, delete, network, system, or broad-scan actions require explicit approval and proof path.

## Proof rule

PASS-looking text is not proof.

Proof needs source, key, route, boundary, hash/path/event/receipt as applicable, and Final Judge.

Missing proof blocks PASS or promotion; it does not delete the candidate.

## Final Judge

Close only when:

- every chunk has a fate;
- every route has a reason;
- every risk has a boundary;
- every unknown has a return trigger;
- code was not executed unless properly approved and gated;
- helper handoff exists when another actor must continue;
- key order and branch join-back are clear;
- one next action is selected.

## Boundary

Support working rules only.
No doctrine.
No ACTIVE_GUIDES.
No CURRENT_TRUTH_INDEX.
No automation.
No broad crawler.
No watcher architecture.
No cleanup/delete authority.
