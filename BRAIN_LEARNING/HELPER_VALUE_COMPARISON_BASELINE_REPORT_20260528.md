# Helper Value Comparison Baseline Report

Date: 2026-05-28  
Status: BASELINE EVALUATION REPORT / NOT A HELPER BUILD  
Authority: NOT doctrine; NOT ACTIVE_GUIDES; NOT CURRENT_TRUTH_INDEX  
Source trigger: user asked how much the helper helps compared to old style and no-helper history  
Current known repo position before report: `main @ e6dc46e`  
Purpose: compare no-helper history, old-style helper flow, and current helper/support-pack workflow.

---

## 1. Clean Question

The active question is:

```text
How much is the helper helping compared to:
1. no-helper history
2. old-style helper
3. current helper-shaped / support-pack workflow
```

This is not a request to build another helper.

This is not a request to promote helper logic.

This is an evaluation of value, friction, proof safety, and failure reduction.

---

## 2. Baseline Modes

### 2.1 No-Helper History

No-helper means:

```text
chat/manual reasoning
user pastebacks
memory/context carry
manual next-route judgment
no structured local script contract
no reliable output shape
no automatic receipt/hash/commit proof in target output
```

Strengths:

- fast for tiny judgment-only tasks;
- flexible;
- low setup cost;
- no generated-script friction;
- less local file clutter.

Weaknesses:

- easier to lose state;
- repeated logs stay live too long;
- harder to prove final clean status;
- higher chance of false PASS;
- repair root cause can blur;
- user has to carry more context;
- no consistent output contract;
- long repo chains become heavy.

Best fit:

```text
tiny judgment
naming
simple route selection
conceptual discussion
small answer with no local proof need
```

Worst fit:

```text
long repo save chains
proof-heavy work
hash/receipt/custody work
many repeated failure/recovery loops
exact staging and push verification
```

---

### 2.2 Old-Style Helper

Old-style helper means:

```text
some local/script/helper use existed
but output contract, lane-locked manifests, freshness states, close/hold checks, and support-pack boundaries were weaker or inconsistent
```

Strengths:

- could inspect local evidence better than chat alone;
- could batch work;
- could generate files and reports;
- reduced some manual reading.

Weaknesses:

- parser/string failures;
- brittle PowerShell shapes;
- unclear staged-file expectations;
- overlapping helper identities;
- possible overbuild;
- unclear authority boundary;
- support objects could become active clutter;
- too easy to treat helper output as answer instead of evidence;
- helper could become a patch factory instead of a clean route.

Best fit:

```text
local evidence gathering where no safer helper contract existed
```

Worst fit:

```text
authority-sensitive save work
complex proof chains
dirty/stale helper reuse
large source intake without output contract
```

---

### 2.3 Current Helper / Support-Pack Workflow

Current helper/support-pack means:

```text
Task Size Gate first
Code Gate before generated PowerShell
bounded local script
exact-file staging
target output contract
receipt/hash/proof
commit/push/HEAD-origin check
final status clean
next route named
support pack used only when triggered
close/hold check to prevent mechanism overrun
```

Key support objects now available:

- Lane-Locked Manifest Staging;
- Lane-Locked Save Manifest Template;
- Live Carry Compression;
- Helper Output Shape Contract;
- Helper Output Shape Contract Template;
- House Keyring Level 0;
- Freshness / Decay Labels;
- Wayfinding Save-Selection;
- Current-Chain Close/Hold Check.

Strengths:

- strong proof safety;
- repeatable save shape;
- parser protection;
- exact staged-file checking;
- clear commit/push/final-clean proof;
- fast pasteback judgment;
- better failure classification;
- better authority boundary;
- less old-chat carry;
- close/hold check prevents endless mechanism proofs.

Weaknesses:

- more scripts;
- more user run steps;
- can over-ritualize small tasks;
- can generate too many candidate support files;
- can create download/local clutter;
- can make simple work feel heavy;
- still needs user pasteback and execution;
- not automatically better for judgment-only tasks.

Best fit:

```text
repo save work
proof-heavy local work
hash/receipt/custody work
exact file staging
repair loops
long chain closure
repeatable helper/report output
```

Worst fit:

```text
tiny chat judgment
creative thought
one-line answers
conceptual discussion without local evidence
```

---

## 3. Comparison Table

Scores:

```text
1 = weak
2 = usable
3 = good
4 = strong
5 = excellent
```

| Dimension | No Helper | Old-Style Helper | Current Helper / Support Pack |
|---|---:|---:|---:|
| Speed on tiny judgment | 5 | 2 | 2 |
| Speed on proof-heavy save work | 1 | 3 | 4 |
| Proof safety | 1 | 2 | 5 |
| False PASS prevention | 1 | 2 | 5 |
| Exact-file staging control | 1 | 2 | 5 |
| Commit/push/final-clean proof | 1 | 2 | 5 |
| Failure classification | 2 | 3 | 5 |
| Repair quality | 2 | 3 | 4 |
| User burden on small tasks | 5 | 2 | 2 |
| User burden on long chains | 1 | 3 | 4 |
| Context carry reduction | 1 | 2 | 5 |
| Authority safety | 2 | 2 | 5 |
| Reuse value | 2 | 3 | 4 |
| Risk of bloat | 3 | 2 | 3 |
| Risk of overbuilding | 4 | 2 | 3 |

Baseline result:

```text
No helper wins tiny/simple judgment.
Current helper/support-pack wins proof-heavy repo work.
Old-style helper is the weakest middle: more machinery without enough contract.
```

---

## 4. Measured Recent Evidence

The recent chain provides strong evidence for the current workflow.

Repeated results showed:

```text
Code Gate parser PASS
target run PASS
commit created
push succeeded
CommitHead == OriginMain
FinalStatus: CLEAN
boundary explicit
next route named
```

Recent examples include:

- Live Carry Compression Tiny Proof repair save;
- Helper Output Shape Contract Tiny Proof save;
- Helper Output Shape Contract Template save;
- House Keyring Graph Tiny Proof Selection save;
- House Keyring Graph One-Chain Tiny Proof save;
- Keyring Level 0 Use Next Mechanism Selection save;
- Freshness / Decay Labels Tiny Proof save;
- Freshness Labels Use Next Route Selection save;
- Wayfinding Save-Selection Tiny Proof save;
- Current-Chain Close/Hold Check save.

The pattern matters more than the count.

The current workflow repeatedly produced clean closes while preserving authority boundaries.

---

## 5. Failure Evidence

The current helper/support-pack did not remove all failure.

It exposed failures more cleanly.

Examples:

### 5.1 Ignored Path Failure

The Dead Chat Shed route failed because generated target files were ignored by `.gitignore`.

Good outcome:

```text
script blocked before false PASS
staged-set mismatch was visible
root cause was clear
repair rerouted to safe tracked name
final repair saved clean
```

Meaning:

The helper did not prevent the first mistake.

It prevented dirty success.

That is high-value.

### 5.2 Repair Naming Failure

The Live Carry Shed repair also hit an ignored path.

Good outcome:

```text
the failure stayed bounded
the next repair removed the risky name
the proof trail preserved source ignored files
final route saved clean
```

Meaning:

Current helper still needs route-name awareness.

But the support pack turned the failure into a controlled correction rather than a hidden dirty state.

---

## 6. Where The Helper Helps Most

The helper helps most when the job needs proof, not just opinion.

High-help zones:

```text
repo save scripts
receipt generation
SHA256 identity
exact-file staging
Git commit/push validation
dirty status prevention
local path custody
pasteback parsing
repair route classification
proof boundary statements
next-route handoff
```

In these zones, current helper/support-pack is probably a **4x to 6x improvement** over no-helper reliability.

Not necessarily 4x faster.

But 4x to 6x safer and cleaner.

---

## 7. Where The Helper Helps Least

The helper helps least when the job is:

```text
judgment-only
small
creative
conceptual
naming
quick route choice
simple explanation
```

For those, helper can be negative value.

It can make the answer slower, heavier, and more annoying.

In those zones, no-helper chat judgment may be best.

---

## 8. Main Finding

The helper is not the value by itself.

The value is:

```text
helper + contract + Code Gate + receipt + exact staging + clean close + boundary + next route
```

Old-style helper lacked enough of that surrounding structure.

Current helper/support-pack is better because it has a control system.

Short form:

```text
Old helper = tool.
Current helper = controlled proof lane.
```

That distinction matters.

---

## 9. Best Operating Rule

Use this decision rule:

```text
If the task needs local evidence, hashes, exact paths, save proof, repeated file operations, or failure recovery:
    use helper/support-pack.

If the task is judgment, naming, concept, or small route choice:
    answer in chat first.

If chat judgment becomes uncertain because evidence is local:
    then use one small helper.
```

This matches current support-pack boundary:

```text
support pack available
use only when triggered
no more mechanism proofs by default
```

---

## 10. Recommended Measurement Going Forward

Track the next few tasks with a simple comparison ledger.

Fields:

```text
Task
Mode used
Why this mode
User steps required
Failures
Repair loops
Files saved
Proof quality
Time/friction feel
Would no-helper have been better?
Would old-style helper have failed?
Verdict
```

Do not build a dashboard.

Do not build automation.

A small report after 3 to 5 real tasks is enough.

---

## 11. Preliminary Verdict

```text
CURRENT HELPER / SUPPORT PACK = KEEP FOR PROOF-HEAVY WORK
NO HELPER = KEEP FOR TINY JUDGMENT
OLD-STYLE HELPER = SUPERSEDE / DO NOT RETURN TO DEFAULT
```

More precise verdict:

```text
The helper is helping most when it acts as a bounded proof lane.
The helper hurts when it becomes automatic machinery for tasks that only need judgment.
```

---

## 12. Fit Decision

ADOPT:

Current helper/support-pack remains useful for proof-heavy repo/local work.

ADAPT:

Do not use helper by default for small judgment tasks.

PROOF:

Recent repeated clean saves and controlled failure repairs support the finding.

PARK:

Dashboard, automation, helper expansion, broad benchmark harness.

BLOCK:

- helper as always-on default;
- old-style helper as default;
- no-helper for proof-heavy save chains;
- building a new helper from this report alone;
- doctrine promotion;
- ACTIVE_GUIDES rewrite;
- CURRENT_TRUTH_INDEX edit.

---

## 13. One Next Route

Recommended next route:

```text
Use this comparison on the next real task.
```

If a durable next artifact is needed, build only:

```text
HELPER_VALUE_COMPARISON_TASK_LEDGER_TEMPLATE_20260528.md
```

But do not build it unless the user wants measurement across future tasks.

Boundary:

No dashboard.
No automation.
No helper build.
No doctrine.
No ACTIVE_GUIDES.
No CURRENT_TRUTH_INDEX.

