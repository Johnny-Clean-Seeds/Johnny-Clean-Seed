# Mule Return Finalization Gate Rule

Date: 2026-05-19
Base: main @ e5e9dce
Lane: Brain Learning / Mule Return Workflow
Status: support learning rule, not active guide doctrine

## Rule

Do not treat a mule return as finished merely because:

- the package was intaken,
- MANIFEST.md was read,
- REVIEW_REPORT.md was read,
- the top recommendation was applied,
- one test passed.

Before leaving a mule-return lane or calling a final hash, read every returned file in manifest order and create a per-file/per-suggestion disposition matrix.

## Required dispositions

Each returned file and each material suggestion must be marked as one of:

- applied,
- tested,
- adapted,
- parked/source-ore,
- rejected,
- not-yet,
- needs proof.

Each disposition must name the proof anchor or reason.

## Meaning of all kept

All kept does not mean blindly installed.

All kept means:
- tracked,
- custodied,
- placed,
- role-labeled,
- and accounted for.

## Meaning of 100 percent true

100 percent true does not mean every mule claim becomes active truth.

100 percent true means every claim or suggestion is either:

- proven,
- explicitly unproven and parked,
- adapted with proof,
- rejected with reason,
- or marked not-yet / needs proof.

## Leak label

If this gate is skipped, classify the issue as:

completion-boundary leak / premature lane switch.

## Boundary

This rule does not authorize:
- doctrine rewrite,
- active guide rewrite,
- CURRENT_TRUTH_INDEX change,
- tool promotion,
- Soft Suit promotion,
- automation,
- full lesson index,
- knowledge graph,
- dashboard.

It only prevents unfinished mule-return accounting.
