# MANUAL REVIEW CHECKLIST — ROW 001

Use this checklist before any future move from Row 001 into a checker, script, helper run, save packet, or repo mutation.

## Inert fixture checks

- [ ] Every fixture file is inert text or CSV.
- [ ] No `.ps1` file exists in the fixture.
- [ ] No `.cmd` file exists in the fixture.
- [ ] No `.bat` file exists in the fixture.
- [ ] No launcher exists in the fixture.
- [ ] No command is provided that would execute the target helper.

## Boundary checks

- [ ] The fixture tests runner-layer hazards, not helper behavior.
- [ ] Runner status and target-helper status are separated.
- [ ] The target helper is not described as failed unless it actually ran.
- [ ] No no-start result is treated as a failed target run.
- [ ] No skip/no-op result is treated as repair progress.

## Hazard coverage checks

- [ ] Generated-runner repair loop is covered.
- [ ] Code-shaped text inside wrapper is covered.
- [ ] Automatic-variable collision risk is covered.
- [ ] Here-string or literal-text expansion risk is covered.
- [ ] Path construction and wrong-lane write risk is covered.
- [ ] False target-run claim risk is covered.
- [ ] No-op/skip-is-not-repair risk is covered.

## Return-trigger checks

- [ ] A future execution lane requires separately proven harness stability.
- [ ] A future execution lane requires path proof.
- [ ] A future execution lane requires naming guard or static naming review.
- [ ] A future execution lane requires non-expanding literal transport proof if text wrapping is involved.
- [ ] The user or a saved rule must explicitly reopen execution.

## Verdict line

Use one:

`PASS_STATIC_FIXTURE_REVIEW`

`WATCH_STATIC_FIXTURE_REVIEW`

`BLOCK_STATIC_FIXTURE_REVIEW`

Do not use “repair complete” from this fixture alone.
