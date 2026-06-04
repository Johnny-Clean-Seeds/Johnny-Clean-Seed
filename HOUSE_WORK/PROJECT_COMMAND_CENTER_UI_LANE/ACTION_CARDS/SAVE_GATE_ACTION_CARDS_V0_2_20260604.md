# Save-Gate Action Cards V0.2

Date: 2026-06-04
Status: ACTION CARD SET / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: SAVE-GATE-ACTION-CARDS-V0-2-20260604

## Exact-Set Save

Trigger: `save gate`

- Required input: intended path list and commit message.
- Steps: capture branch/HEAD/origin, hash intended files, stage exact paths, show `git diff --cached --name-status`, compare to intended set, run root check.
- Allowed files: intended set only.
- Forbidden files: unrelated dirty work, protected paths, WORK_SHED as durable, local-only runners unless explicitly selected.
- Proof: staged name-status, old HEAD, root clean result, dirty leftovers.
- Receipt: save-gate row or receipt.
- Verdict: `EXACT_SET_READY` or `EXACT_SET_SAVE_BLOCKED_WITH_REASON`.

## Staged Set Verification

Trigger: `stage check`

- Required input: staged index.
- Steps: list staged files, compare against manifest, check for forbidden path patterns, check for Phase/source contamination.
- Proof: name-status and forbidden-pattern result.
- StopLine: any unrelated staged material.

## Commit/Push Proof

Trigger: `lock save`

- Required input: verified staged set.
- Steps: commit with clear message, push, verify new HEAD, verify `HEAD == origin/main`, report leftover dirty work.
- Proof: old HEAD, new HEAD, push range, equality result.
- Verdict: `COMMIT_AND_PUSH_PROVED`.

## No-Commit Blocker

Trigger: commit requested but exact set is unsafe.

- Required input: blocker reason.
- Steps: name blocker, show staged/unstaged split, park or request decision.
- Proof: status short and exact reason.
- Verdict: `NO_COMMIT_NO_PUSH_WITH_REASON`.

## Entangled Dirty File Blocker

Trigger: one tracked file contains both intended and unrelated changes.

- Required input: file path and intended hunk.
- Steps: stage only intended hunk if safe; otherwise stop.
- Proof: staged diff summary and unstaged leftovers.
- Verdict: `EXACT_SET_SAVE_BLOCKED_BY_ENTANGLED_DIRTY_FILE` if hunk split is unsafe.
