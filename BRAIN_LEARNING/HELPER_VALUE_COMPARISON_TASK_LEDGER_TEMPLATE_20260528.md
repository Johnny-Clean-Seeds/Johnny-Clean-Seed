# Helper Value Comparison Task Ledger Template

Date: 2026-05-28  
Status: SMALL MEASUREMENT TEMPLATE / NOT A DASHBOARD / NOT AUTOMATION  
Authority: NOT doctrine; NOT ACTIVE_GUIDES; NOT CURRENT_TRUTH_INDEX  
Source baseline: `BRAIN_LEARNING/HELPER_VALUE_COMPARISON_BASELINE_REPORT_20260528.md`  
Purpose: give a small repeatable ledger for comparing no-helper, old-style helper, and current helper/support-pack value across the next few real tasks.

---

## 1. Clean Thesis

The helper should be judged by task results, not by how much machinery it creates.

This ledger measures whether the current helper/support-pack is actually helping.

It should answer:

```text
Did the selected mode reduce burden, improve proof, prevent failure, and choose the right next move?
```

This ledger is not a dashboard, automation, helper build, broad benchmark harness, doctrine rule, ACTIVE_GUIDES edit, or CURRENT_TRUTH_INDEX edit.

---

## 2. Comparison Modes

Use these three modes:

```text
NO_HELPER
OLD_STYLE_HELPER
CURRENT_HELPER_SUPPORT_PACK
```

### NO_HELPER

Best for tiny judgment, conceptual answer, naming, simple route choice, and chat-only work.

Risk: state loss, weak proof, false PASS on long save chains, and too much live context carry.

### OLD_STYLE_HELPER

Best historical use: local evidence gathering before the current contract existed.

Risk: brittle scripts, parser failures, unclear authority, unclear output contract, and overbuilt helper behavior.

### CURRENT_HELPER_SUPPORT_PACK

Best for repo save work, proof-heavy work, receipt/hash/custody work, exact-file staging, repair loops, pasteback judgment, and clean close.

Risk: too many scripts, over-ritualizing small work, local/download clutter, and slowness for tiny judgment.

---

## 3. One-Task Ledger Row

Copy one row per real task.

| Field | Entry |
|---|---|
| Task ID |  |
| Date |  |
| User ask |  |
| Task type | tiny / small / medium / large / boss |
| Evidence need | none / chat / local files / Git / web / source |
| Mode selected | NO_HELPER / OLD_STYLE_HELPER / CURRENT_HELPER_SUPPORT_PACK |
| Why this mode |  |
| User steps required |  |
| Scripts/files created |  |
| Code Gate needed | yes / no |
| Parser result | PASS / FAIL / n/a |
| Target result | PASS / FAIL / WATCH / n/a |
| Save proof | commit / push / clean / n/a |
| Failures |  |
| Repair loops |  |
| User burden | low / medium / high |
| Proof quality | weak / usable / strong |
| Authority safety | weak / usable / strong |
| Did mode help? | yes / partly / no |
| Would no-helper be better? | yes / no / unclear |
| Would old-style helper be worse? | yes / no / unclear |
| Final verdict |  |
| Next route |  |

---

## 4. Lightweight Scoring

Optional score.

Use only after the task is complete.

```text
1 = poor
2 = weak
3 = usable
4 = strong
5 = excellent
```

| Dimension | Score | Note |
|---|---:|---|
| Speed |  |  |
| User burden |  |  |
| Proof safety |  |  |
| Failure recovery |  |  |
| Context carry reduction |  |  |
| Authority safety |  |  |
| Reuse value |  |  |
| Fit for task size |  |  |

Do not over-score tiny tasks.

The main useful result is not the number. The useful result is whether the chosen mode fit the task.

---

## 5. Decision Rules Before Choosing Mode

```text
If task is tiny judgment:
    prefer NO_HELPER.

If task is proof-heavy, repo/save, local-file, hash, receipt, Git, or repair-loop work:
    prefer CURRENT_HELPER_SUPPORT_PACK.

If task requires local evidence but no current support-pack path exists:
    use one small helper through Code Gate.

Do not default to OLD_STYLE_HELPER.
```

---

## 6. Report Pasteback Rule

When the user sends a Code Gate/save report:

```text
judge the report
update state/memory if needed
if PASS:
    send the next approved code/file route directly
if FAIL:
    send the narrow fix route/code directly
if no code is needed:
    send only the next clean action
```

Do not re-explain successful reports unless the user asks.

This keeps the helper comparison honest: the support-pack should reduce burden after report pasteback, not create extra commentary.

---

## 7. Three-Task Mini-Ledger

Use this after three real tasks.

| Task | Mode Used | Result | Burden | Proof | Verdict |
|---|---|---|---|---|---|
| 1 |  |  |  |  |  |
| 2 |  |  |  |  |  |
| 3 |  |  |  |  |  |

After three rows, ask:

```text
Is current helper/support-pack still helping?
Is no-helper better for this task type?
Is old-style helper still superseded?
What should be narrowed?
What should be dropped?
```

---

## 8. Pass / Watch / Fail For This Ledger

### PASS

The ledger passes if it helps choose the right mode with less argument and less repeated analysis.

### WATCH

Watch if the ledger becomes a dashboard, a ritual for every tiny task, an excuse to make helper code, or another carried burden.

### FAIL

Fail if it makes the user run more machinery than the task needs.

---

## 9. Fit Decision

ADOPT:

Use this ledger only for comparing future real tasks.

ADAPT:

Keep it small. If it grows, summarize after three rows instead of adding columns.

PARK:

Dashboard, automation, broad benchmark harness, helper build.

BLOCK:

- doctrine promotion;
- ACTIVE_GUIDES rewrite;
- CURRENT_TRUTH_INDEX edit;
- old-style helper as default;
- helper as automatic for tiny tasks;
- ledger as dashboard.

---

## 10. One Next Route

Use this ledger on the next real task only if measurement is useful.

If the next user message is another Code Gate/save report:

```text
PASS -> next code
FAIL -> fix code
NO CODE NEEDED -> next clean action
```

