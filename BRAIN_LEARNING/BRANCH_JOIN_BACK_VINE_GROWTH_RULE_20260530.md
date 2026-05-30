# Branch Join-Back / Vine Growth Rule

Date: 2026-05-30
Status: SUPPORT RULE / NOT DOCTRINE
Authority: not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Rule

Sometimes two bounded routes can run at once. That is allowed when the ledger/map says the branches are safe, independent enough, and bounded.

Parallel work must not branch forever.

Every branch must declare:

- branch key;
- parent key;
- branch owner;
- start condition;
- dependency reason;
- proof required;
- expected output;
- stop condition;
- join-back point;
- return handoff;
- main route takeoff point after join.

## Vine model

A branch can end locally without ending the whole vine.

A side branch may prove a small part, park, block, or return to the main route. The helper must know where to jump back to and where to take off again.

## Join-back flow

BRANCH START
-> BOUNDED BRANCH WORK
-> BRANCH PROOF
-> BRANCH HANDOFF
-> JOIN-BACK POINT
-> MAIN ROUTE RESUMES OR NEXT BRANCH STARTS

## Anti-patterns blocked

Unbounded branch splitting.
Parallel helpers without owner.
No join-back point.
Branch proof missing.
Branch result treated as whole-vine proof.
Side branch becomes new main route without decision.
Two helpers touch same lock group.
Branch keeps running after stop condition.

## Correct close states

MERGE_BACK:
branch returns proof/handoff to parent route.

END_LOCAL:
branch is complete but does not finish whole vine.

PARK_BRANCH:
branch has a return trigger.

BLOCK_BRANCH:
branch cannot continue; parent route is notified.

SUPERSEDE_BRANCH:
branch is preserved but no longer live.

PROMOTE_TO_MAIN_CANDIDATE:
only with explicit decision and proof; not automatic.

## Core line

A branch may finish; the vine continues from the correct join point.
