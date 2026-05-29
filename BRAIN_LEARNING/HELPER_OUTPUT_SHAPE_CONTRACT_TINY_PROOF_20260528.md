# Helper Output Shape Contract Tiny Proof Card

Date: 2026-05-28  
Status: TINY PROOF CARD / CANDIDATE MECHANISM PROOF  
Authority: NOT doctrine; NOT ACTIVE_GUIDES; NOT CURRENT_TRUTH_INDEX  
Mechanism tested: Helper Output Shape Contract  
Source evidence: recent Code Gate pastebacks and lock/save target outputs  
Purpose: prove whether a shaped helper/report output lets the assistant judge a run and choose the next route without rereading the whole run or dragging old logs live.

---

## 1. Proof Object

Mechanism:

Helper Output Shape Contract.

Claim being tested:

A helper/report output should provide enough structured fields for clean judgment:

- whether parser passed;
- whether target ran;
- whether warnings are expected WATCH or true blockers;
- whether the child target succeeded;
- what object was saved;
- what files were saved;
- what hashes prove them;
- whether HEAD equals origin/main;
- whether final status is clean;
- what boundary held;
- what next route is.

Tiny proof question:

Can recent Code Gate pastebacks be judged from their output shape without rereading the whole script or whole prior chat?

Verdict:

PASS CANDIDATE / NOT PROMOTED.

---

## 2. Evidence Events

Recent pastebacks used as evidence:

1. Chuck Norris Pressure Test V1.2 repair.
2. Source-to-House Intake V2 Comparison Layer Addendum save.
3. Source-to-House Intake V2 Mechanism Extraction Report save.
4. Lane-Locked Manifest Staging Tiny Proof save.
5. Lane-Locked Save Manifest Template save.
6. Live Carry Compression Tiny Proof repair save.

These pastebacks had a repeatable shape:

- Code Gate parser status;
- final verdict;
- warnings/blockers;
- target run status;
- child target status;
- target report path;
- copy block start/end markers;
- object-specific completion marker;
- EndState;
- message;
- repo path;
- RunId;
- saved report path;
- receipt path;
- status update path;
- SHA256 values;
- BaseHead;
- CommitHead;
- OriginMain;
- FinalStatus;
- verdict;
- boundary;
- next route.

---

## 3. Output Shape Test

### 3.1 Code Gate Wrapper Shape

Useful wrapper fields:

| Field | Why it matters |
|---|---|
| Final verdict | tells whether target passed, failed, or needs review |
| Syntax | separates parser failure from runtime failure |
| Warnings | shows WATCH versus hard blocker |
| Blockers | tells whether Code Gate blocked execution |
| Run verdict | tells whether target exit code passed |
| Child target status | summarizes target outcome |
| Report path | preserves local proof trail |

Judgment:

PASS.

The wrapper fields allow immediate classification:

- parser FAIL -> do not run / fix syntax;
- blockers -> do not run / fix blocker;
- target nonzero -> read target output and fix route;
- PASS WITH WATCH with expected warnings -> next route.

### 3.2 Target Output Shape

Useful target fields:

| Field | Why it matters |
|---|---|
| Completion marker | identifies exact operation that completed |
| EndState | tells whether the target clean-closed |
| Message | short human summary |
| Repo | confirms repo root |
| RunId | identifies run instance |
| Report / Receipt / StatusUpdate | gives saved proof paths |
| SHA256 values | proves file identity |
| BaseHead / CommitHead / OriginMain | proves Git movement |
| FinalStatus | proves clean close |
| Verdict | provides bounded final judgment |
| Boundary | states what did not happen |
| NextRoute | continues sequence without broad explanation |

Judgment:

PASS.

The target output shape allowed next-route-only responses without reopening the full context.

---

## 4. What The Mechanism Proved

Proved:

A structured helper/report output lets the assistant classify the result quickly.

Proved:

Separating wrapper verdict from child target status prevents false failure classification.

Proved:

Including saved paths and SHA256 values lets old logs leave live carry while proof stays findable.

Proved:

Including `NextRoute` supports the user-requested next-route-only style.

Proved:

Boundary lines prevent PASS from being mistaken for authority promotion.

Not proved:

This is not yet a universal output standard.

Not proved:

This does not replace Code Gate, receipts, Git proof, or Final Judge.

Not proved:

This does not make warnings irrelevant.

Not proved:

This does not authorize helper/code generation.

---

## 5. Minimum Output Shape Candidate

For future helper/report outputs, the minimum useful shape is:

```text
<OBJECT>_COMPLETE
EndState:
Message:
Repo:
RunId:
Report:
Receipt:
StatusUpdate:
ReportSHA256:
ReceiptSHA256:
StatusSHA256:
BaseHead:
CommitHead:
OriginMain:
FinalStatus:
Verdict:
Boundary:
NextRoute:
```

For Code Gate wrapper output, the minimum useful shape is:

```text
Final verdict:
Syntax:
Warnings:
Blockers:
Run verdict:
Child target status:
Report:
```

---

## 6. Fit Decision

ADOPT:

Helper Output Shape Contract is fit as a candidate mechanism for helper/report judgment.

ADAPT:

Exact field list may need variant forms for:

- read-only reports;
- local-only helper outputs;
- save scripts;
- repair scripts;
- source custody reports;
- proof-selection reports.

PROOF_PARK:

This proof card remains support evidence.

BLOCK:

- no doctrine promotion;
- no ACTIVE_GUIDES rewrite;
- no CURRENT_TRUTH_INDEX edit;
- no universal helper standard install;
- no helper/code build;
- no automation;
- no broad scan;
- no PASS without proof.

WATCH:

Output shape must not become output theater. Each field must help judgment, proof, boundary, or next route.

---

## 7. Final Judge Placement

Placement:

BRAIN_LEARNING candidate proof card.

Authority:

Not doctrine.
Not ACTIVE_GUIDES.
Not CURRENT_TRUTH_INDEX.
Not active rule install.
Not replacement proof.
Not helper build plan.

Verdict:

PASS CANDIDATE / HELPER OUTPUT SHAPE CONTRACT PROVED ONE JUDGMENT CLASS / NOT PROMOTED.

---

## 8. One Next Route

Choose one:

1. Build a small Helper Output Shape Contract Template as candidate support.
2. Proof-test the next candidate mechanism.
3. Use Lane-Locked Save Manifest Template on the next suitable save route.

Recommended next route:

Build the small Helper Output Shape Contract Template only if the user wants to keep tightening helper/report outputs.

Boundary:

Template only. No doctrine. No authority edit. No helper build.

