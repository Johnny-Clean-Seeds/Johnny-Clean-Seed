# Path-Class Review Before 50-Wave Repair Lesson

Date: 2026-05-30
Status: BRAIN LEARNING / SUPPORT LESSON / NOT DOCTRINE
WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1

## Lesson

Watch rows are not repair tickets.

Before any 50-ticket repair wave, parked watch rows must pass a path-class review that uses every required input surface. For this wave, both current inputs were required and used:

- Intake Gate key/hash findings.
- Root-Layer skipped-history findings.

## Rules That Changed Behavior

- 50-WAVE FLOOR: build a real 50-ticket packet before repair.
- NO-OP NO-COMMIT LATCH: commit only when `RepairedTargets > 0`.
- SKIP-ONLY IS NOT REPAIR: skip-only output is local report only.
- ROOT-LAYER DROP-DOWN: separate upper row findings from lower route/helper/proof causes.
- INTAKE GATE KEY/HASH GUARD: confirm key/hash/receipt/purpose/route/return/currentness before claiming closure.
- COMMIT MESSAGE TRUTH GATE: commit message must match actual action.
- ONE / MANY LOOKUP SHAPE GUARD: use `@(...)` around file lookups, CSV imports, helper results, and Git output before `.Count`, indexing, or selection.

## What Worked

- Refreshed stale audit reports before classification.
- Parked source/proof/custody rows instead of forcing them into the repair packet.
- Split helper/tool rows from main repair rows.
- Reserved Root-Layer rows in the selected packet so both inputs were represented.
- Grouped duplicate-path tickets during repair: 50 ticket rows became 39 target edits.
- Re-audited and compared exact packet rows, not only whole-house totals.

## What To Avoid

- Do not let Intake hash gaps consume the whole 50-wave when Root-Layer rows are in scope.
- Do not repair `SOURCE_ORE`, `RULE_INTAKE`, `LEARNING_ROOT`, proof, backup, archive, custody, receipt, or old source-copy paths by default.
- Do not treat a whole-audit residual count as packet failure unless the exact selected row remains open.
- Do not commit report-only/no-op/skip-only runs.

## Proof

- Path-class review: `PATH_CLASS_REVIEW_CLOSEOUT_20260530_195649.md`
- Repair commit: `68085e43146ff5fca1b4faaf963fd3261f8b7cd5`
- Compare report: `HOUSE_WORK/WORK_SHED/SORTING_BENCH/PATH_CLASS_50_WAVE_REPAIR_PACKET_20260530/PATH_CLASS_50_WAVE_REAUDIT_COMPARE_REPORT_20260530.md`

## Return

Return trigger: before the next 50-wave repair, run path-class review on current reports and build a confirmed packet from surviving rows only.
