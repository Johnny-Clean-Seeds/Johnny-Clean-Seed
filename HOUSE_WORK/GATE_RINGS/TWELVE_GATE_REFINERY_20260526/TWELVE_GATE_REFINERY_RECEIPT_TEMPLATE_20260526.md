# Twelve-Gate Refinery - Proof Receipt Template

Status: SUPPORT TEMPLATE / CANDIDATE TOOL / NOT ACTIVE DOCTRINE
Date: 2026-05-26

## Receipt Fields

- Name of run:
- Date/time:
- Object:
- Object type:
- Source/custody:
- Mode:
- Authority boundary:
- Gate order used:
- Middle trace status: muted / exposed / proof-minimal
- Changed outputs:
- Hard stops encountered:
- Proof evidence:
- Verification verdict:
- Validation verdict:
- Placement:
- Promotion status:
- Return trigger:
- Next action:
- Open risk:
- Retirement/stale condition:
- Final Judge close:

## Verification

Verification asks: did the gate machine run as specified?

Minimum verification checks:

- Alpha locked object/source/mode/lane/boundary/proof level.
- Gates ran in order from Main Light through Old Weight Final.
- Middle gates were muted or trace exposure was justified by mode.
- Old Weight Final spoke.
- Omega / Outer Final Judge closed.
- Fixed verdict set was used.
- Placement was named.

## Validation

Validation asks: did the gate machine produce the right kind of result for the user/house need?

Minimum validation checks:

- less fog;
- correct object;
- correct placement;
- no fake proof;
- no early promotion;
- no rule king;
- useful next action;
- state words match proof.

No validation, no promotion.

## Fixed Verdict Set

- ACCEPT
- ACCEPT WITH GUARDRAILS
- REFINE
- SPLIT
- PARK WITH RETURN TRIGGER
- NEEDS SOURCE
- NEEDS PROOF
- BLOCK
- READY FOR NARROW LIVE USE
- READY FOR SAVE ROUTE
- NOT PROMOTED

## Normal Output Template

Final result:

Placement:

Proof status:

Next action:

## Save Mode Extra Fields

- Files touched:
- Pre-save hash/status:
- Post-save hash/status:
- Git commit:
- Local-only artifacts:
- Blocked promotions:
- Dirty-tree caveat:
