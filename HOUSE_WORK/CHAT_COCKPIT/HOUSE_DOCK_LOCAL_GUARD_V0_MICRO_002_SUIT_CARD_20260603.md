# House Dock Local Guard V0 / Micro 002 Suit Card

Saved: 20260603_125519

## Wear now

HOUSE_DOCK_LOCAL_GUARD_V0_SOFT_SUIT

## Use when

- User pastes command/output/prose/transcript into PowerShell.
- A parser error appears.
- A verifier assumption fails.
- A pass line appears after an earlier lower-layer error.
- An auto-fix candidate might apply.
- A user states a new rule or correction.

## Required behavior

1. Do not accept contaminated pass lines.
2. Classify whether the issue is superficial or lower-layer.
3. Auto-correct only exact known safe patterns.
4. If lower-layer, pause with the required pause line.
5. If an auto-fix is wrong or overbroad, mark WRONG_FIX_OR_OVERBROAD_FIX.
6. Stack user-addressed rules for the next durable save gate.
7. Keep output separate from input.

## Required pause line

PAUSE / LOWER-LAYER ISSUE MUST BE RESOLVED FIRST BEFORE CONTINUING THIS LANE

## Current proof

Micro 002 is independently verified by repaired V2 verifier after guard review.

## Next rope

Close this save gate cleanly before Micro 003.
