# Hard Suit Slot Distinction Clarifier

## Purpose

Clarify the difference between a Hard Suit active pack slot and a Hard Suit support link.

This fixes the guardrail found during Runtime Kernel Run 001 Walk-Around Test.

## Core distinction

A Hard Suit active pack slot is proven operating load.

A Hard Suit support link is reference fuel.

They are not the same state.

## Active pack slot

An active pack slot means:

- proven through proof
- promoted through a clear gate
- currently worn as operating load
- allowed to guide active behavior
- counted against the Hard Suit active pack limit
- subject to removal if stale, conflicting, duplicated, or no longer useful

State-machine fit:

captured
→ classified
→ routed
→ active
→ proof-needed
→ judged
→ promoted
→ active pack slot

## Support link

A support link means:

- useful reference
- source, map, helper pack, proof, learning file, or parked support
- may inform judgment
- does not count as active pack weight
- does not gain authority by being linked
- cannot control active behavior by itself
- must be promoted through proof before becoming active pack load

State-machine fit:

captured
→ classified
→ routed
→ parked/support
→ reclassified if needed
→ proof-needed if promotion is requested
→ judged
→ promoted only if proof passes

## Forbidden confusion

Do not treat a support link as a worn Hard Suit item.

Do not count a support link as an active pack slot.

Do not let a support link control active behavior without promotion proof.

Do not promote a support link because it is useful.

Useful is not proven.

Reference is not authority.

Linked is not worn.

## Promotion rule

A support link can become an active pack slot only when:

1. its exact job is named
2. its lane is clear
3. neighbor effects are checked
4. proof need is defined
5. proof passes
6. promotion is recorded
7. active pack slot is intentionally updated

## Removal rule

An active pack slot can be moved out when:

- stale
- duplicated
- conflicting
- too broad
- no longer useful
- replaced by a cleaner proven item
- demoted by proof

Moved-out items may become archived, parked, or support links.

## Close condition

PASS means the Hard Suit can distinguish:

- reference fuel
- support link
- active pack slot
- promoted operating load
