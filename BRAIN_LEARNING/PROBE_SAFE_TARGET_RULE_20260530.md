# Probe-Safe Target Rule

Date: 2026-05-30
Status: SUPPORT RULE / POWERPLAY REPAIR
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Focal rule

Any target script that Code Gate may run without live task inputs must contain a clean probe path.

The probe path must exit clean with status 0.

Real task strictness belongs inside the real-run gate, not in PowerShell parameter binding.

## Failure exposed

V1.1 word-wash proof trial failed under Code Gate because the target received empty inputs.

Failure shape:
Cannot bind argument to parameter 'InputText' because it is an empty string.

Meaning:
The proof rule was correct, but the script shape was dirty. It failed before the gate could speak.

## Repair

V1.2 added:

- no-input probe path;
- PROBE_ONLY output;
- exit code 0 for Code Gate probe;
- strict real-run validation;
- missing real fields reported as BLOCKED_MISSING_FIELD;
- PowerShell-safe comment-prefixed output.

## Rule

Probe path is not proof pass.
Probe path proves the target can be safely inspected by Code Gate.

Real run pass requires real inputs, proof bridge, final gate verdict, report path, and report hash.

## Hard blocks

No parameter-binding crash for missing live task inputs.
No silent proof pass on empty input.
No hidden target yield.
No random base word.
No unproven base word.
No output without report path.
