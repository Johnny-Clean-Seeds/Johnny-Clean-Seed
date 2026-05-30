# User-Said-First Crosscheck House-Rope V1 Failure — Powerplay / Crime Scene

Date: 2026-05-30
Status: POWERPLAY / CRIME SCENE / REPAIR EVIDENCE / NOT DOCTRINE
WorkKey: USFCHR-20260530-USER-SAID-FIRST-CROSSCHECK-HOUSE-ROPE
RepairKey: POWERPLAY-CRIME-SCENE-20260530-USFCHR-V1-REPAIR
FileKey: FILE-POWERPLAY-CRIME-SCENE-NOTE
SourceBase: origin/main @ 8ed7dbac1389d2bea885561798b3fff458d92bc9

## Scene

V1 Code Gate probe passed. Direct save failed during Git staging.

Observed failure class:
Ignored Work Shed paths were included in a normal `git add --` call.

Known failed staging group:
- HOUSE_WORK/WORK_SHED/SORTING_BENCH/USER_SAID_FIRST_CROSSCHECK_HOUSE_ROPE_SOURCE_CROSSCHECK_20260530.md
- HOUSE_WORK/WORK_SHED/INDEXES/USER_SAID_FIRST_CROSSCHECK_HOUSE_ROPE_LEGEND_LEDGER_KEYMAP_20260530.md

## Diagnosis

The rule concept was not the failed object. The save body was not fully house-native because it did not use the lane-locked ignored-path save exception.

## Exposed missing companion

Ignored Work Shed files require:

1. lane decision;
2. exact-file force-add only;
3. ignored-path manifest;
4. role/lane/reason/size/SHA256/ignore-witness;
5. staged-set verification;
6. commit, push, remote match, and final clean proof before PASS.

## Repair behavior in V1.1

V1.1 checks the dirty repo as a crime scene. It continues only if every dirty path is in the planned repair footprint. It writes this crime-scene note, creates an ignored-path manifest, force-adds only exact ignored files, verifies staged set, commits, pushes, verifies remote match, and checks final clean status.

## Dirty status before V1.1 repair

```text
M  ACTIVE_ANCHOR.txt
A  BRAIN_LEARNING/USER_SAID_FIRST_CROSSCHECK_HOUSE_ROPE_LIVING_RULE_20260530.md
M  HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md
A  HOUSE_WORK/CHAT_COCKPIT/USER_SAID_FIRST_CROSSCHECK_HOUSE_ROPE_SUIT_CARD_V1_20260530.md
M  HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
A  PROOF_HISTORY/USER_SAID_FIRST_CROSSCHECK_HOUSE_ROPE_LOCK_RECEIPT_20260530.txt
```

## Boundary

No broad cleanup. No delete. No folder force-add. No wildcard force-add. No doctrine. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX. No automation. No watcher. No Whirlpool. No implementation. No full batch unlock.