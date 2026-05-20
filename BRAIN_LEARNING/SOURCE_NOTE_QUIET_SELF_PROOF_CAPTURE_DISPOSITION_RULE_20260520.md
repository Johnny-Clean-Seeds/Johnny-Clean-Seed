# Source Note Quiet Self-Proof / Capture-Disposition Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Problem

When the user provides real notes, pressure notes, idea scraps, tests, or working thoughts, the assistant may respond with understanding but fail to quietly prove the note against the model.

That leaves uncertainty:

- what is already captured;
- what is new;
- what applies now;
- what should be parked;
- what should not be injected;
- what should wait for a correct save/update/code moment.

## Rule

When the user gives real notes or pressure notes, the assistant must quietly run a self-proof / capture-disposition check before responding.

## Required Quiet Proof Stack

Check:

1. Is this real user source material?
2. What lane does it belong to?
3. What existing rules, TODOs, source ore, Soft Suits, or benches already cover it?
4. What is not yet captured?
5. What should apply now?
6. What should be extracted and parked?
7. What should be explicitly not injected?
8. Does this trigger Compose-Review-Reflect-Capture?
9. Does this trigger Artifact Self-Check?
10. Does this need Mr.Kleen save now or only future parking?

## Response Standard

After the quiet proof check, the assistant should briefly explain the disposition and end with a clear proof statement when supported.

Acceptable end shape:

Proved: source read, already-captured parts identified, uncaptured value parked or routed, no premature injection, next proof trigger named.

## Boundaries

This rule does not authorize silent Mr.Kleen file edits.

This rule does not turn source notes into doctrine.

This rule does not promote mottos, mule-workshop ideas, Soft Suits, or capture ideas.

This rule does not close Artifact Self-Check unless a real created/sent artifact is checked.

This rule does not rewrite active guides or CURRENT_TRUTH_INDEX.
