# Lane-Locked Save Manifest Template

Date: 2026-05-28  
Status: CANDIDATE TEMPLATE / SAVE-ROUTE SUPPORT  
Authority: NOT doctrine; NOT ACTIVE_GUIDES; NOT CURRENT_TRUTH_INDEX  
Source proof: Lane-Locked Manifest Staging Tiny Proof Card  
Purpose: provide a small reusable manifest shape for future save routes so expected object, lane, path, authority status, staged files, blocked-path risk, and proof close are declared before save success is claimed.

---

## 1. Template Role

This template exists to prevent save-route drift.

It helps catch:

- wrong lane;
- ignored path;
- untrackable path;
- raw source accidentally staged;
- authority file touched without selection;
- missing staged file;
- unexpected staged file;
- local-only artifact falsely reported as Local + URL;
- PASS claimed before commit/push/clean proof.

This template does not:

- promote doctrine;
- rewrite ACTIVE_GUIDES;
- rewrite CURRENT_TRUTH_INDEX;
- replace Code Gate;
- replace proof receipts;
- replace Final Judge;
- authorize broad save routes;
- authorize force-add behavior by default.

---

## 2. When To Use

Use before durable project saves when any of these are true:

- new report/card/rule-candidate is being saved;
- more than one file will be staged;
- path may be ignored or unfamiliar;
- source material is involved;
- authority boundary matters;
- Local + URL save is intended;
- previous save route failed or was repaired;
- assistant is about to claim saved/pushed/clean.

Do not use as heavy ritual for trivial read-only chat answers.

---

## 3. Manifest Header

Save Object:

Object Type:

Source / Trigger:

Current Base HEAD:

Branch:

Remote Match Before Save:

Save Mode:

- Local-only
- Local + URL
- Candidate only
- Proof support only
- Authority-touching route

Selected Lane:

Intended Path(s):

Authority Status:

- NOT doctrine
- NOT ACTIVE_GUIDES
- NOT CURRENT_TRUTH_INDEX
- candidate
- proof support
- status update
- receipt
- other

Blocked Moves:

- raw chunks
- raw transcript/source Git staging
- helper/code build
- doctrine promotion
- ACTIVE_GUIDES edit
- CURRENT_TRUTH_INDEX edit
- broad rescan
- all-file archive
- force-add ignored paths unless explicitly approved
- unexpected staged files

---

## 4. Lane and Path Check

For each intended file:

| File | Lane | Role | Expected Git-trackable? | Ignore-risk checked? | Local-only or Local + URL? |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

Required check:

- path exists or parent folder can be created;
- path belongs to declared lane;
- path is not raw source unless explicitly routed;
- path is not an ignored subtree unless intentionally local-only or explicitly approved;
- path does not touch authority files unless selected;
- path naming matches house lane naming.

If path is ignored:

Default decision:

- reroute to a trackable candidate lane, or
- keep local-only with clear report, or
- stop and ask/select a different route.

Do not force-add ignored paths by default.

---

## 5. Expected Staged Set

Expected staged files:

1.
2.
3.

Allowed staged files only:

- exact report/card/template file;
- exact receipt file;
- exact status/index update if selected.

Unexpected staged file rule:

If any staged file is not on the manifest, stop.

Missing staged file rule:

If any manifest file is missing from staged set, stop.

No-diff rule:

If the staged set exists but contains no diff, stop.

---

## 6. Proof Close Requirements

A durable Local + URL save is not complete until all are true:

- exact staged set matches manifest;
- commit succeeds;
- push succeeds;
- HEAD equals origin/main;
- final git status is clean;
- receipt records saved files and SHA256;
- final report separates Local + URL from local-only artifacts;
- boundary statement is printed.

PASS requires proof.

No proof means no PASS.

---

## 7. Receipt Minimum Fields

Receipt should include:

- object name;
- object type;
- lane;
- authority status;
- source/trigger;
- base HEAD;
- saved file paths;
- SHA256 for saved files;
- boundary held;
- fit decision;
- blocked moves;
- next route;
- final verdict.

Receipt should not claim:

- doctrine promotion unless actually promoted through authority route;
- URL push unless commit/push and HEAD == origin/main passed;
- clean repo unless final status is clean.

---

## 8. Fit Decision Fields

ADOPT:

ADAPT:

PROOF_PARK:

BLOCK:

WATCH:

NEXT ROUTE:

---

## 9. Tiny Example From Proof Event

Save object:

The Chuck Norris Pressure Test guardrail.

Initial intended path:

HOUSE_WORK/WORK_SHED/SORTING_BENCH/CHUCK_NORRIS_PRESSURE_TEST_SOURCE_TO_HOUSE_INTAKE_V2_GUARDRAIL_20260528.md

Expected staged files:

- HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
- HOUSE_WORK/WORK_SHED/SORTING_BENCH/CHUCK_NORRIS_PRESSURE_TEST_SOURCE_TO_HOUSE_INTAKE_V2_GUARDRAIL_20260528.md
- PROOF_HISTORY/CHUCK_NORRIS_PRESSURE_TEST_LOCK_RECEIPT_20260528.txt

Actual staged files:

- HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
- PROOF_HISTORY/CHUCK_NORRIS_PRESSURE_TEST_LOCK_RECEIPT_20260528.txt

Mismatch:

The report file was missing from staged set.

Cause:

HOUSE_WORK/WORK_SHED was ignored by .gitignore.

Clean repair:

Reroute same candidate object to BRAIN_LEARNING and stage exact expected files.

Proof result:

Lane-Locked Manifest Staging caught one real failure class.

---

## 10. Final Judge Placement

Placement:

BRAIN_LEARNING candidate template.

Authority:

Not doctrine.
Not ACTIVE_GUIDES.
Not CURRENT_TRUTH_INDEX.
Not universal save rule.
Not forced Git behavior.
Not helper plan.

Verdict:

PASS CANDIDATE / SMALL TEMPLATE READY / NOT PROMOTED.

---

## 11. One Next Route

Use this template on the next suitable save route.

Do not promote yet.

Future proof:

Apply this template to one future save and check whether it reduces path/staging ambiguity without adding too much process weight.

