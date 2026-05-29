# Helper Output Shape Contract Template

Date: 2026-05-28  
Status: CANDIDATE TEMPLATE / HELPER-REPORT OUTPUT SUPPORT  
Authority: NOT doctrine; NOT ACTIVE_GUIDES; NOT CURRENT_TRUTH_INDEX  
Source proof: Helper Output Shape Contract Tiny Proof Card  
Purpose: provide a small reusable output shape for helper/report pastebacks so the assistant can judge PASS/WATCH/FAIL, proof state, boundary, and next route without rereading the whole run.

---

## 1. Template Role

This template exists to make helper/report outputs easy to judge.

It helps answer:

- did syntax pass?
- did the target run?
- were warnings expected WATCH or blockers?
- what object was worked?
- what files were created or changed?
- what proof was produced?
- what boundary held?
- what failed, if anything?
- what is the next route?

This template does not:

- replace Code Gate;
- replace receipts;
- replace Git proof;
- replace Final Judge;
- promote doctrine;
- rewrite ACTIVE_GUIDES;
- rewrite CURRENT_TRUTH_INDEX;
- authorize helper/code generation;
- make PASS without proof.

---

## 2. When To Use

Use this shape for:

- Code Gate pastebacks;
- save-script outputs;
- repair-script outputs;
- read-only helper reports;
- source custody reports;
- proof-selection reports;
- local-only helper results;
- Local + URL durable save results.

Do not use as a heavy ritual for ordinary chat answers.

---

## 3. Wrapper Output Shape

For Code Gate / wrapper output:

```text
POWERSHELL CODE GATE RUNNER COMPLETE
Final verdict:
Syntax:
Warnings:
Blockers:
Run verdict:
Child target status:
Report:
```

Judgment rules:

- `Syntax: FAIL` means fix parser shape first.
- `Blockers > 0` means target did not run; fix blocker.
- `Run verdict: RUN NONZERO REVIEW` means inspect target output and send fix route.
- `PASS WITH WATCH` can be accepted when the watch is expected and bounded.
- Code Gate PASS is not job PASS.
- Child target status tells whether the job itself passed.

---

## 4. Target Output Shape

For a save/repair/proof target output:

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

Optional fields when useful:

```text
SourceReport:
SourceReportSHA256:
SourceReceipt:
SourceReceiptSHA256:
OriginalLocalOnlyReport:
OldIgnoredReport:
ExpectedStaged:
ActualStaged:
Missing:
Unexpected:
```

---

## 5. Field Meaning

| Field | Job |
|---|---|
| Completion marker | identifies exact completed operation |
| EndState | tells whether target clean-closed |
| Message | gives short human summary |
| Repo | confirms repo root |
| RunId | identifies run instance |
| Report | gives saved/read report path |
| Receipt | gives proof receipt path |
| StatusUpdate | gives current-status file path |
| SHA256 fields | prove file identity |
| BaseHead | shows starting commit |
| CommitHead | shows resulting local commit |
| OriginMain | proves remote alignment |
| FinalStatus | proves clean or dirty end |
| Verdict | bounded judgment |
| Boundary | states what did not happen |
| NextRoute | gives next move without broad re-reading |

---

## 6. PASS / WATCH / FAIL Judgment

### PASS

Accept the run when:

- wrapper parser passed;
- target ran;
- target exit code passed;
- saved paths are named;
- SHA256 values are present when files were created;
- `CommitHead == OriginMain` for Local + URL saves;
- `FinalStatus: CLEAN`;
- boundary is explicit;
- next route is named.

### PASS WITH WATCH

Accept with watch when:

- warnings are expected and bounded;
- Code Gate reports WATCH but target run passed;
- line-ending warnings appear but final status is clean;
- target output is complete enough to judge.

### FAIL / FIX ROUTE

Send fix route when:

- syntax failed;
- blockers exist;
- target did not run;
- target nonzero requires review;
- expected staged files are missing;
- unexpected files are staged;
- final status is dirty;
- HEAD does not match origin/main after push;
- output lacks enough fields to judge.

---

## 7. Minimal Read-Only Report Shape

For read-only/local evidence helpers that do not write Git:

```text
<OBJECT>_READ_REPORT_COMPLETE
EndState:
Message:
Root:
RunId:
Mode:
FilesScanned:
FilesMatched:
Skipped:
Warnings:
Blockers:
Report:
ReportSHA256:
Verdict:
Boundary:
NextRoute:
```

Required boundary:

- no Git writes;
- no deletes;
- no moves unless explicitly selected;
- no authority edits;
- bounded root only.

---

## 8. Minimal Local-Only Helper Shape

For local-only helper output:

```text
<OBJECT>_LOCAL_HELPER_COMPLETE
EndState:
Message:
Root:
RunId:
Tool:
Mode:
Output:
OutputSHA256:
Warnings:
Blockers:
Verdict:
Boundary:
NextRoute:
```

Required boundary:

- local-only;
- no Git claim;
- no URL claim;
- no authority claim;
- no broad scan unless approved.

---

## 9. Minimal Save Script Shape

For durable Local + URL saves:

```text
<OBJECT>_LOCK_SAVE_COMPLETE
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

Required proof:

- exact staged set;
- commit;
- push;
- `HEAD == origin/main`;
- final status clean.

No proof means no PASS.

---

## 10. Fit Decision

ADOPT:

Helper Output Shape Contract Template is fit as candidate support for future helper/report outputs.

ADAPT:

Variants may be refined later for:

- read-only reports;
- local-only helper output;
- source custody;
- repair output;
- proof-selection output;
- future UI/runner output.

PROOF_PARK:

Tiny proof card remains support evidence.

BLOCK:

- doctrine promotion;
- ACTIVE_GUIDES rewrite;
- CURRENT_TRUTH_INDEX edit;
- universal helper standard install;
- helper/code build;
- automation;
- broad scan;
- PASS without proof.

WATCH:

Output shape must not become theater. Each field must support judgment, proof, boundary, or next route.

---

## 11. Final Judge Placement

Placement:

BRAIN_LEARNING candidate template.

Authority:

Not doctrine.
Not ACTIVE_GUIDES.
Not CURRENT_TRUTH_INDEX.
Not active rule install.
Not helper build plan.
Not proof replacement.

Verdict:

PASS CANDIDATE / SMALL TEMPLATE READY / NOT PROMOTED.

---

## 12. One Next Route

Use this template on the next suitable helper/report output.

Do not promote yet.

Recommended next candidate mechanism if continuing proof chain:

House Keyring Graph, but only as a tiny proof-selection pass because it is high value and high authority-risk.

