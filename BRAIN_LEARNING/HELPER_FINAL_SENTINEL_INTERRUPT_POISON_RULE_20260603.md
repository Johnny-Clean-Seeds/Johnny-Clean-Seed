# Helper Final Sentinel / Interrupt Poison Rule

Status: SUPPORT RULE / CONTROL REPAIR CANDIDATE
Date: 2026-06-03
Lane: Helper proof integrity / Code Gate / PowerShell helper control

## Rule

PASS is terminal-only.

A helper begins in `BLOCKED_UNTIL_COMPLETE`. It must not assign, print, or export a PASS verdict until every required proof point is complete.

A helper run is not PASS unless all of these are true:

1. The target completed its required proof work.
2. The target emitted a final sentinel.
3. The final sentinel names the expected script and completion state.
4. PASS appears only after the final sentinel.
5. No PASS appears before the final sentinel.
6. Exit code is 0.
7. Required report and hash proof exist when the helper claims them.
8. Any interruption before the sentinel poisons the run.

## Required sentinel

```text
HELPER_FINAL_SENTINEL <SCRIPT_NAME> COMPLETE
PASS  <FINAL_VERDICT>
```

## Non-negotiable failures

```text
NO_FINAL_SENTINEL = NO_PASS
CTRL_C_BEFORE_SENTINEL = INTERRUPTED_NOT_PASS
PASS_BEFORE_SENTINEL = HELPER_BUG
EXIT_0_WITHOUT_SENTINEL = HELPER_BUG
REPORT_WITHOUT_SENTINEL = NOT_ENOUGH
FINALLY_STALE_PASS = HELPER_BUG
```

## Why this exists

PowerShell and console control behavior can make interruption look cleaner than it is. A `finally` block can still run after `CTRL+C`, and an exit code alone is not a house proof. A printed PASS line is only screen output unless it is backed by a final sentinel and full proof.

## Proper helper shape

```text
START
PHASE proof
PHASE proof
REPORT written
REPORT hash
FINAL_SENTINEL
PASS
```

Never:

```text
PASS
still writing report
still hashing
still checking git
still returning through parent
```

## Boundary

This rule does not rewrite existing helpers by itself. Existing helpers must be migrated or wrapped. Old helpers without sentinel support are not automatically invalid historically, but new control-sensitive helpers should be treated as incomplete unless the final sentinel contract is satisfied.
