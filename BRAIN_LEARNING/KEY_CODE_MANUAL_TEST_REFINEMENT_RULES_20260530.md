# Key-Code Manual Test Refinement Rules

Date: 2026-05-30
Status: SUPPORT RULES / NOT DOCTRINE
Authority: not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Hash identity rule

A hash proves content identity.

A hash does not prove quality, correctness, safety, route fitness, or promotion readiness.

## Key route rule

A key requests a route.

A key is not authority to run, save, execute, promote, or spawn helpers.

## No wildcard key route rule

Do not allow broad wildcard key routes by default.

Blocked unless explicitly bounded and approved:

- ALL
- *
- #
- EVERY
- ROOT_ALL
- any route that expands to every dropped object

A broad key pattern is fan-out in disguise.

## Duplicate / collision rule

Compare hash and key before routing.

Same hash + same key:
same object or duplicate; avoid repeat work.

Same hash + different key:
alias/custody review.

Different hash + same key:
collision or changed object; block until reviewed.

Different hash + different key:
new candidate; route by ledger/map.

## Branch failure rule

A branch pass is local unless it merges back.

If one branch passes and another fails, the vine does not continue.

Required outcomes:

- repair;
- retry bounded;
- park with return trigger;
- block parent route;
- return to operator;
- supersede with proof.

## Join-back artifact rule

A parallel branch route must name its join-back surface before starting.

Branch output must return proof and handoff to that surface.

## Governor scope rule

Governor fields must be preserved in evidence:

- max_concurrent_helpers;
- batch_size;
- max_fan_out;
- lock_group;
- allowed_helper_type;
- stop_condition.

## Next-key unlock rule

A next key does not unlock because a test says PASS.

It unlocks only when the required proof receipt or Final Judge evidence exists, and only within the route boundary.
