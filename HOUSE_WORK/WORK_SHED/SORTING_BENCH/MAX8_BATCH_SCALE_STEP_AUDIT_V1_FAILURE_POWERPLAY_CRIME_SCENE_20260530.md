# Max8 Batch Scale-Step Audit V1.1 Failure Powerplay / Crime Scene

Date: 2026-05-30
RunId: 20260530_065926
WorkKey: MAX8-20260530-BATCH-SCALE-STEP-AUDIT
RepairKey: POWERPLAY-CRIME-SCENE-20260530-MAX8-V1-OPERATOR-BINDING-REPAIR
GuardKey: POWERSHELL-OPERATOR-BINDING-SPLIT-GUARD-20260530
Status: POWERPLAY / CRIME SCENE / ROUTE REPAIR / NOT DOCTRINE
SourceBase: origin/main @ b4a05a3a7eb9162b52ad6cdd98cfe71455d0e7d2

## User said

The user reported that after Code Gate passed parser/run probe, direct save failed with:

A parameter cannot be found that matches parameter name 'split'.

The user also noted this has happened more than once and required it to be noted and examined.

## Re-evaluation

The Max8 audit concept is not the failed object. The failure is the V1 save body. V1 wrote/staged the expected Max8 files, then failed during staged-set verification because -split was bound as a parameter to Invoke-Git.

## Root cause

PowerShell operator-binding ambiguity: generated script used command invocation followed directly by -split instead of variable-first splitting.

## V1.1 repair

- Preserve this failure note.
- Add the operator-binding guard.
- Accept only the expected V1 partial-save footprint.
- Abort on any extra repo dirt.
- Rewrite/stage exact intended files.
- Force-add only exact ignored Work Shed files.
- Use variable-first split for staged-set verification.
- Commit, push, verify HEAD equals origin/main, verify final clean status.

## Boundary

No full batch. No implementation. No watcher. No automation. No Whirlpool. No doctrine. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX.