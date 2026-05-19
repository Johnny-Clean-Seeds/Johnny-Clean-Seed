# Guard-Fail Stop Card Critique Intake

Date: 2026-05-19.
State: Work Shed critique intake.
Authority: outside-review source material, not command authority.
Starting base: main @ 2f7851a.

## Verdict

The awareness direction is strong but incomplete.

Guard-Fail Stop Card before custody audit tooling is correct because an audit tool is useless if work continues after the guard already failed.

## Main Correction

Chat-held awareness is not enough.

The card must be recalled at point of work before PowerShell/git tasks.

## Upgrades Accepted

- Use Abort Latch / Custody Lockout mechanics.
- Require point-of-work readback.
- Separate pause/inspect from restart shell/session.
- Define minimum failure capture evidence.
- Do not clean contamination broadly before bounded inspection.
- Keep Hot Rules Strip capped at seven.

## Fatal Triggers Accepted

- wrong root,
- missing .git,
- review-only task trying to write/save/commit,
- native git nonzero or git 128,
- unknown or nonzero LASTEXITCODE,
- unset/null/empty/stale required variable,
- empty/duplicate/unresolved/outside-root expected path,
- PowerShell continuation prompt,
- partial paste after error,
- guard fail before write/commit/push,
- success line after earlier failure,
- evidence mismatch,
- receipt without artifact,
- commit message claiming artifact absent from HEAD,
- delivery-format preference treated as repo save,
- lane change mid-task without approval.

## Reject Now

- full custody audit implementation,
- dashboard/status board expansion,
- full FMEA,
- incident-command procedure,
- full postmortem ritual,
- big checklist systems,
- Saved-clean generators,
- cleanup before inspection,
- hot rule lists longer than seven,
- paste-heavy PowerShell bridges.

## Next

Use point-of-work readback before any further PowerShell/git work.
