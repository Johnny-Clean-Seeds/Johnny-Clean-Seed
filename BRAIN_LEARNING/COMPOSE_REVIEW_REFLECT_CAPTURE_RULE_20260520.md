# Compose-Review-Reflect-Capture Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Problem

The assistant can compose a good thought, prompt, handoff, or long code block and still fail to capture the new structure revealed by that composition.

This creates a leak:

draft -> review -> send

when the cleaner route is:

draft -> review -> reflect -> capture or park -> send or save when the moment is right

## Rule

After composing thoughts, prompts, handoffs, long code, save scripts, or structural explanations, and before sending, the assistant must use the draft/review holding point as a Stop-and-Reflect moment.

The assistant must ask:

What did this draft reveal that was not fully depicted before?

If the answer exposes a new rule, relation, lifecycle step, lane boundary, proof condition, parking behavior, injection timing, affected concept list, or missing house object, the assistant must capture it or park it.

## Required Reflection Sweep

Before sending a significant drafted artifact, inspect the bases touched:

- rules;
- ideas;
- concepts;
- Soft Suits;
- parking lanes;
- proof lanes;
- TODO;
- active anchor;
- status;
- source ore;
- mule returns;
- handoff patterns;
- code skeletons;
- prompt skeletons;
- future injection points;
- active guide boundaries;
- CURRENT_TRUTH_INDEX boundaries.

## Capture Moment

A capture moment exists when the draft reveals:

- an under-depicted structure;
- a new connection between existing rules;
- a rule that should fire earlier;
- a recurring weak point;
- a missing list;
- a missing lane;
- a missing proof step;
- a parking/injection distinction;
- a Soft Suit live-use candidate;
- a better future skeleton;
- an affected-concept group.

## Parking Rule

If the idea is real but not ready to install, park it.

Parked material may be worn immediately as a Soft Suit / live-use candidate when it fits the current work.

Parking does not mean promotion.

Parking does not mean doctrine.

Parking does not mean safe.

Parking means the idea has a named home, lane, status, and proof path.

## Proof Rule

A parked idea can influence behavior as a Soft Suit candidate, but it is not marked safe until proof shows it works.

Promotion, gate extraction, active-guide rewrite, doctrine install, trigger-event marking, tool promotion, or injection requires separate proof.

## Injection Timing

Do not inject an idea only because the user says it is interesting.

Do not inject by excitement.

Inject when the correct save/update/code moment naturally arrives and the idea has a clean lane, proof need, and boundary.

## Relation To Existing Rules

This rule complements:

- Long Code Draft-Review-Send Gate Rule;
- Reusable Script Skeleton Pull Rule;
- Soft Suit Trigger Event Proof-Before-Mark Rule;
- Discovery Capture Interrupt Rule;
- After-Fix Carryover Latch;
- Filing Cabinet reusable workflow method;
- Relation Method across-the-board lens.

## Boundary

This rule changes assistant behavior.

It does not rewrite active guides.

It does not rewrite CURRENT_TRUTH_INDEX.

It does not install doctrine.

It does not split Soft Suits.

It does not create runtime, dashboard, automation, knowledge graph, or full lesson index.
