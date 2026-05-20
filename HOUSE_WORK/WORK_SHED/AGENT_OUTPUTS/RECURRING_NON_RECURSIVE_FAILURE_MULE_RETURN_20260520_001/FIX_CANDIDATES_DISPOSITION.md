# FIX CANDIDATES DISPOSITION

## Summary

Recommended shape:

`SPLIT INTO TWO FIXES` inside one small save package.

- Parent fix: `After-Fix Carryover Latch`.
- Child fix: `Artifact Self-Check After Send Gate`.

Do not install five separate heavy rules. Keep five candidate names as fields/checks under the parent latch where possible.

## Candidate Matrix

| Candidate | Disposition | Smallest Lane | Why | Proof Needed | Overbuild Risk |
|---|---|---|---|---|---|
| After-Fix Carryover Latch | ACCEPT | `BRAIN_LEARNING` plus Sorting Bench dissection | This directly patches the missing after-fix/before-close transition. | A later fix final answer names carryover status and lane disposition. | Medium if expanded into a full workflow system. |
| Artifact Self-Check After Send Gate | ACCEPT AS CHILD / TODO | `HOUSE_WORK\TODO` first; BRAIN child only if selected | The current example needs this exact artifact rule preserved, but it is a child test case under carryover. | Next artifact is checked before ready/closed, and result is reported. | Medium if every tiny chat answer becomes ceremonial. |
| Memory Is Not House Capture | ACCEPT AS FIELD / SHORT RULE | Include in carryover latch; optional BRAIN section | It separates assistant continuity from Mr.Kleen evidence. | Future final answer says memory-only is not house capture when no file lane was used. | Low if kept as boundary; high if used to force saves for everything. |
| TODO Capture After User Rule Trigger | ADAPT | Include as trigger in latch plus TODO trace reference | "You should always do this" is a strong trigger for TODO/candidate placement, but TODO still must not command work by existence. | A user rule trigger becomes TODO/candidate, park/block, or explicit one-off. | Medium if it bypasses trace/triage. |
| No Close Until Carryover Disposition | ACCEPT WITH LIMITS | Include as stop condition in latch | This is the prevention hook: no full close until placed, parked, blocked, declared one-off, or offered. | Final response includes carryover disposition for meaningful fixes. | High if applied to trivial typo/single-turn answers. |

## Candidate Details

### After-Fix Carryover Latch

Disposition:
`ACCEPT`

Smallest lane:

- `HOUSE_WORK\WORK_SHED\SORTING_BENCH\RECURRING_NON_RECURSIVE_FAILURE_DISSECTION_20260520.md`
- `BRAIN_LEARNING\AFTER_FIX_CARRYOVER_LATCH_RULE_20260520.md`

Why:

It sits exactly where the failure occurred: after current fix/proof and before close.

Minimum trigger:

- user correction,
- "always do this" instruction,
- artifact correction,
- failed proof,
- repeated miss,
- new rule phrase,
- memory-vs-house mismatch,
- TODO placement challenge.

Required final response fields:

- immediate fix status,
- exposed lesson,
- one-off or recurring,
- carryover lane or reason not used,
- whether Mr.Kleen changed,
- next-start improvement.

### Artifact Self-Check After Send Gate

Disposition:
`ACCEPT AS CHILD / TODO`

Smallest lane:

- `HOUSE_WORK\TODO\ARTIFACT_SELF_CHECK_AFTER_SEND_TODO_20260520.md`

Optional later lane:

- BRAIN_LEARNING only after one live-use proof or if user selects direct rule save.

Why:

This rule is concrete and testable. It should not be buried only inside a parent dissection.

Minimum check:

- file exists,
- readable/openable,
- expected sections/markers,
- context not dropped,
- no placeholders/truncation,
- output format matches request,
- no contradiction with current task state.

### Memory Is Not House Capture

Disposition:
`ACCEPT AS FIELD`

Smallest lane:

- Section inside `AFTER_FIX_CARRYOVER_LATCH_RULE_20260520.md`.

Why:

This was the exact boundary failure. Memory may help the assistant, but Mr.Kleen needs path/lane/proof or explicit park/block/no-save disposition.

Do not over-apply:

Not every preference needs a file. The latch should allow "one-off" and "memory-only by explicit user request."

### TODO Capture After User Rule Trigger

Disposition:
`ADAPT`

Smallest lane:

- Trigger row inside carryover latch.
- Link to existing `HOUSE_WORK\TODO\TODO_TRACE_TRIAGE_GATE_20260518.md`.

Why:

The TODO method already exists. The missing part is the trigger from live user correction into TODO/candidate offering.

Constraint:

TODO capture is support, not command authority.

### No Close Until Carryover Disposition

Disposition:
`ACCEPT WITH LIMITS`

Smallest lane:

- Stop condition in carryover latch rule.

Good close states:

- placed,
- parked,
- blocked,
- declared one-off,
- offered as Mr.Kleen save candidate,
- memory-only by explicit user request,
- no house capture needed because no reusable lesson.

Limit:

Do not run a full carryover ceremony for trivial answers that produce no reusable rule, no artifact, no correction, and no house-relevant risk.

## Blocked Candidate Expansions

BLOCK:

- separate BRAIN rule for each candidate name in the first save,
- active guide rewrite,
- `CURRENT_TRUTH_INDEX.txt` rewrite,
- full carryover dashboard,
- automation/reminder/runtime,
- knowledge graph,
- full lesson index,
- broad TODO rebuild,
- proof-history restructure,
- motto-wheel promotion to doctrine,
- another mule pass after this return by inertia.

## Best Fit Call

INFERENCE:

The best current move is a small, claim-scoped save package. The parent latch belongs in BRAIN_LEARNING because it changes assistant behavior. The artifact self-check belongs in TODO first because it is the current test case and should be traced before promotion. The dissection belongs in Sorting Bench because it preserves the parent/ghost diagnosis without rewriting doctrine.

