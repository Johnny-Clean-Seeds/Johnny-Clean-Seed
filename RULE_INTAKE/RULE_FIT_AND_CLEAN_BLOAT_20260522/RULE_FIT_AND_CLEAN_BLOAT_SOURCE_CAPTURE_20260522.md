# Rule Fit / Clean BLOAT Source Capture 20260522

Problem:
A new rule was added, but the surrounding working flow mutated. The user corrected that adding a rule must not randomly change code delivery style, source routing, or any unrelated working protocol.

Rule 1:
Rule-Fit / No Side-Mutation Gate.

Meaning:
When adding a new rule or correcting a rule, stop and fit-check it before changing behavior. Identify what the rule controls, what lane it belongs in, what existing flows it touches, whether it conflicts, what must stay unchanged, and what the smallest necessary behavior change is.

Blocked:
- Changing delivery style because source pickup changed.
- Changing source routing because wording changed.
- Removing an idea because a new one arrived.
- Compressing away useful detail before it is stale.
- Treating a new rule as permission to rewrite the room.

Removal standard:
Remove or retire only if stale, superseded, unsafe, duplicate with no added value, or explicitly rejected. Record why.

Rule 2:
Clean-Placed Growth / Clean BLOAT Rule.

Meaning:
Real growth can require adding more rules, notes, lenses, and structure, but only as clean placed objects. More is allowed when more has a clean place.

Clean BLOAT fields:
- name
- lane
- purpose
- boundary
- neighbor fit
- proof status
- use condition
- cleanup or retirement path

Dirty bloat:
Unplaced, stale, conflicting, vague, proofless, duplicate with no value, unsafe, or carried only because nobody sorted it.

Short form:
New rule means fit-tested addition, not random surrounding behavior change.
More is allowed when more has a clean place.
