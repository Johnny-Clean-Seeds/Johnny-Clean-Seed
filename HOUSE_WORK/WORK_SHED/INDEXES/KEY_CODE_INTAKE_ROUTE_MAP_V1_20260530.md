# Key-Code Intake Route Map V1

Date: 2026-05-30
Status: SUPPORT MAP / NOT DOCTRINE

## Dispatch sequence

1. Root Hold
2. Explicit Intake Pass
3. Hash Object
4. Read or Assign Key Code
5. Ledger Lookup
6. Map Route Lookup
7. Key Order Gate
8. Dependency Gate
9. Fan-Out Limit Gate
10. Lock / Mutex Gate
11. Queue / Park Gate if not ready
12. Dispatch or Handoff
13. Proof-Before-Next
14. Unlock Next Key
15. Join-Back if branch
16. Final Judge

## Key route types

INTAKE_DESIGN:
read/report/test design only.

MANUAL_TEST:
manual worksheet only.

CODE_REVIEW:
Code Gate required; no execution by intake.

SAVE_ROUTE_CANDIDATE:
requires operator approval and proof.

BRANCH_SIDE_TASK:
requires branch owner, proof, stop condition, and join-back point.

PARKED_RETURN:
parked with return trigger.

BLOCKED_REVIEW:
blocked with reason.

## Ordering rule

The map must sort by:

- order_index;
- prerequisite_keys;
- proof_required_to_unlock;
- priority;
- lane_owner;
- lock_group;
- boundary class.

## Branch rule

A branch route must carry:

- parent_key;
- branch_key;
- join_back_key;
- return_handoff_surface;
- branch_stop_condition;
- main_route_takeoff_key.

No branch route may spawn further branch routes unless explicitly allowed and bounded.
