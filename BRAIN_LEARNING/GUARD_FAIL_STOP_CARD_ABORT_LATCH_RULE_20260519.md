# Guard-Fail Stop Card / Abort Latch Rule

Date: 2026-05-19.
State: active awareness gate.
Authority: operating behavior rule.
Starting base: main @ 2f7851a.

## Core Mechanic

Use Abort Latch / Custody Lockout.

Loose run-poisoned wording is not enough.

If a fatal stop fires, the run is latched. Later success-looking output cannot clear the latch.

Only bounded inspection, restart when needed, and lane restatement can clear it.

## Point-of-Work Readback

Before PowerShell/git work, state:

Lane: __.
Repo root: __.
Intended action: __.
Fatal stops: wrong root, missing .git, review-only write attempt, git nonzero, git 128, unknown or nonzero LASTEXITCODE, unset/null/empty/stale required variable, empty/duplicate/unresolved/outside-root path, PowerShell continuation prompt, partial paste after error, guard fail before write/commit/push, success-after-error, evidence mismatch, receipt without artifact, commit message claiming artifact absent from HEAD, delivery-format preference treated as repo save, lane change without approval.
If any fires: FOG / CUSTODY FAIL: STOP.

## Fatal Stop Response

When latched:

- say FOG / CUSTODY FAIL: STOP,
- do not continue the pasted sequence,
- do not print success,
- do not create more files,
- do not commit,
- do not push,
- do not claim saved clean,
- capture minimum evidence only,
- inspect/restart as needed,
- resume only after state and lane are restated.

## Minimum Failure Capture

Capture only:

- current directory,
- failed guard or command,
- exit code if present,
- visible error text,
- last action attempted,
- files touched if known.

## Cleanup Boundary

Cleanup after contamination requires bounded inspection and approval when deletion or movement risk exists.

Do not auto-clean broadly.

## Hot Rules Strip

Keep these seven hot rules active until reviewed:

1. Review-only means no repo save.
2. Wrong folder stops before write.
3. Guard failure latches Custody Lockout.
4. Git nonzero stops and captures.
5. PowerShell continuation prompt means abort and restart shell.
6. Success after errors is false-pass evidence.
7. No giant interactive paste blocks as trusted save work.

## Boundary

No custody audit implementation.
No dashboard.
No FMEA expansion.
No incident-command procedure.
No postmortem ritual.
No Saved-clean generator.
