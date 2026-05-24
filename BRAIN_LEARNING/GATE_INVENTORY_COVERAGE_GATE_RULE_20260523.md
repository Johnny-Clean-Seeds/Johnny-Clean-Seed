# Gate Inventory / Coverage Gate Rule

Status: SUPPORT GATE / COVERAGE INSPECTOR / NOT DOCTRINE
Date: 2026-05-23

## Purpose

Ask whether the current gate family is complete enough for the work.

This gate does not add growth by itself. It inspects the gate set before the house invents certainty.

Core questions:

- Do we actually have the gates we need?
- Which gates are missing?
- Which gates are duplicates?
- Which items are history, evidence, ledgers, checks, cards, scaffolds, or lenses instead of gates?
- Which useful ideas should be downgraded from fake gate to cleaner support object?
- Where is evidence missing?

## Clean Split

- Growth Gate: adds possible new growth.
- Gate Inventory / Coverage Gate: asks whether the gate family is complete, crowded, duplicated, or missing a real inspector.
- Evidence / History Gate: asks whether history supports the decision.
- CONSOLIDATOR Trial: later decides whether repeated overlap should stay separate, move logic, pack together, park, reject, or watch again.

## Trigger

Use this gate when:

- a new gate is proposed;
- a boss loop keeps yielding the same result;
- the house feels crowded but useful;
- a useful idea might be a scaffold, ledger, lens, or card instead of a gate;
- the system wants to claim the gate family is complete;
- Evidence / History has no record yet;
- Growth adds something and the house must check whether it is clean bloat or muddy drift.

## Order Placement

Default order:

`Alpha -> Router/Classify -> Active Gates -> Creative/Growth -> Gate Inventory/Coverage -> Evidence/History -> Proven-Better Adoption -> Parking/TODO -> Next Spin Sequencer -> CONSOLIDATOR Trial -> Omega -> Final Judge`

True seam:

`Creative/Growth produces candidate objects -> Gate Inventory/Coverage classifies object type and coverage -> Evidence/History checks support -> Proven-Better Adoption decides adopt/adapt/park/reject -> Parking/TODO stores unresolved items -> Sequencer orders next run`

Why here:

- It must run after Growth or Creative has produced candidates.
- It must run before Evidence / History so the evidence question is aimed at the correct object.
- It must run before Proven-Better Adoption so adoption is judging the right type: gate, tool, scaffold, parking item, or proof surface.
- It must run before CONSOLIDATOR so CONSOLIDATOR does not confuse missing coverage with duplication.

Rejected seams:

- Before Creative/Growth: too early; there is no candidate object yet.
- After Evidence/History: too late; evidence may check the wrong object type.
- After Proven-Better Adoption: too late; adoption may promote a scaffold as a gate.
- Inside CONSOLIDATOR: too late and too compressive; missing coverage can be mistaken for duplicate logic.
- After Omega or Final Judge: too late for parking, proof routing, or next-spin ordering.

Placement lock:

Early Worker runs before Alpha as startup preflight. Suit As House Under Test runs horizontally through every gate during a soft suit or boss loop. Gate Inventory/Coverage runs only at the serial seam above.

## Required Labels

Every inspected object gets one label:

- NEEDED GATE: this object decides, blocks, permits, or routes.
- MISSING GATE: the work needs a gate that does not exist yet.
- DUPLICATE GATE: this is repeating another gate without adding a distinct decision.
- NOT A GATE: useful, but it belongs as a tool, scaffold, card, ledger, lens, or proof surface.
- HISTORY/EVIDENCE PROBLEM: the gate question cannot be answered until old proof or new evidence is checked.
- UNKNOWN / WATCH AGAIN: not enough history yet.
- REJECT: dirty bloat, unsafe, misleading, stale, or no useful job.

## Evidence Silence Rule

If there is no evidence or history, do not guess.

Say:

`UNKNOWN / WATCH AGAIN / NOT ENOUGH HISTORY YET`

Then ask:

`Why is there no evidence yet?`

The answer may be:

- this is genuinely new;
- the evidence is in another lane;
- the receipt was never written;
- the history exists but was not read;
- the object is only a feeling signal and needs proof;
- the proposal should park until a real trigger appears.

## Suit Awareness

When this gate runs during a soft suit or boss loop, it must inspect the suit too.

The suit is a house surface under test. It is not doctrine, authority, or final house truth, but it must be judged as part of the current working house because it is shaping the run.

Ask:

- Does the suit add needed coverage?
- Does the suit duplicate a gate?
- Does the suit hide a missing gate?
- Does the suit make a cleaner support object than a new gate?
- Does the suit strengthen the build as clean placed growth?

## Clean Bloat Test

Added structure is clean bloat only if it has:

- name;
- lane;
- purpose;
- boundary;
- neighbor fit;
- proof status;
- use condition;
- cleanup or retirement path.

If any field is missing, mark it PARTIAL or PARK, not PASS.

## Output

Use a small coverage table:

| Object | Claimed Type | Coverage Label | Evidence Status | Neighbor Fit | Decision | Return Trigger |
|---|---|---|---|---|---|---|

## Boundaries

- No doctrine promotion from one inventory pass.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No public authority change.
- No CONSOLIDATOR activation by itself.
- No deleting or flattening gates because they touch.
- No calling feeling proof.

## Proof

Proof is a coverage table that shows which objects are needed gates, missing gates, duplicates, non-gates, history/evidence problems, unknown/watch-again items, or rejects.

The gate is proved in use when a future run avoids both fake gate growth and premature gate flattening.
