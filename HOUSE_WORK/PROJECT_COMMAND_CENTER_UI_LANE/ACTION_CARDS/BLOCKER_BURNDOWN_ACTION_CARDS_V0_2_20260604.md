# Blocker Burn-Down Action Cards V0.2

Date: 2026-06-04
Status: ACTION CARD SET / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: BLOCKER-BURNDOWN-ACTION-CARDS-V0-2-20260604

## Shared Chain

`NAME_BLOCKER -> CLASSIFY_BLOCKER -> HASH_BEFORE_CHANGE -> BACKUP_OR_CUSTODY_POINTER -> FIX_ROUTE_REDUCE_OR_ISOLATE_IF_ALLOWED -> HASH_AFTER_CHANGE -> UPDATE_PATHS -> CONTINUE`

| Card | Use when | Allowed response | Forbidden response | Required proof | Closeout |
|---|---|---|---|---|---|
| Fix-now blocker | issue is local, safe, and inside current lane | patch or route the bounded file | stop without attempting safe fix | before/after hash and reason | blocker fixed |
| Reduce-and-continue blocker | broad scope threatens data or drift | narrow to next usable layer and record reduction | abandon clear next action | reduction reason and delivered subset | `BROAD_UI_SCOPE_REDUCED_TO_NEXT_USABLE_LAYER` |
| Conflict parked not overwritten | useful material conflicts with current lane | park with return trigger | overwrite or silently drop | parked path and trigger | `PARKED_WITH_RETURN_TRIGGER` |
| Real stop/ask blocker | destructive/ownership/auth/package/credential/two-lane risk | stop with exact ask | guess through unsafe condition | blocker class and needed decision | `REAL_BLOCKER_STOP_AND_ASK` |

## Does Not Prove

Burning a blocker proves the local issue was handled or parked. It does not prove the whole lane is complete unless the receipt and manifest also close the required deliverables.
