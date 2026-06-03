# Lower Cause File / Stage / Commit Edge Proof Pattern - Mini-case 01

Date: 2026-06-02
Status: PROOF PATTERN / CANDIDATE SUPPORT / NOT ACTIVE HELPER
WorkKey: LOWER-CAUSE-FILE-STAGE-COMMIT-EDGE-PROOF-PATTERN-MINI-CASE-01-20260602

## Purpose

Preserve Mini-case 01 as the reusable proof pattern for separating file edge, staged edge, commit edge, receipt edge, and authority boundary before helper behavior changes.

## Source custody

- Plan: HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/ROOT_SWEEP_20260601/LOWER_CAUSE_GATE_FIXTURE_SET_MINIMUM_PROOF_PLAN_V0_3_20260602.md - SHA256 79DF2C543DE72746DCA121E3E8692E9F553290505210AC218F2A3667CCBA49B6
- Plan receipt: PROOF_HISTORY/LOWER_CAUSE_GATE_FIXTURE_SET_MINIMUM_PROOF_PLAN_WRITE_RECEIPT_20260602.txt - SHA256 B7A34A2801802DC5FDFAAD87EFB6C668153E2481EF867988221EC8144F06B6D1
- Mini-case 01 local report: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\ROOT_SWEEP\READ_LOWER_CAUSE_FILE_EDGE_STAGED_EDGE_MINI_CASE_01_V1_20260602_224049.txt - SHA256 9F8A764CF9D978ECCA5E950C4471210B7FDA0AA4A8983BF69A0E46DBA83D007F
- Repo HEAD at proof: 3afad810cbfdc6a1386ac602f7d10827c7ec19ad

## Lower-layer issue scan

Visible symptom: scripts, saves, or reports can appear to pass while proving the wrong layer.

Lower-layer cause: proof-edge confusion.

Required scan before claiming done:

1. file edge - current file exists and current SHA256 is printed;
2. staged edge - staged set and cached diff are checked when staged proof is claimed;
3. commit edge - object exists in HEAD when committed proof is claimed;
4. receipt edge - receipt says what it proves and does not become authority by itself;
5. authority boundary - candidate/support/active/callable/helper-output are not mixed;
6. stale evidence - old proof is not reused after payload changes;
7. rerun safety - rerun after success is safe or blocks with a clear reason;
8. earlier-layer cause - visible failure is checked against route/tool/custody layer.

## Mini-case 01 pass pattern

PASS means all of these are true:

- HEAD equals origin/main;
- git status is clean;
- plan file exists;
- plan SHA256 matches expected value;
- plan and receipt are tracked;
- plan and receipt exist in HEAD;
- staged name count is zero;
- untracked name count is zero;
- cached plan matches HEAD;
- worktree plan matches index;
- git diff --check --cached passes;
- receipt states no-git boundary;
- receipt names selected object and first target;
- plan remains candidate support and NOT ACTIVE HELPER;
- plan says no helper behavior changed;
- plan names promotion gate warning.

## Block pattern

BLOCK if:

- worktree proof is used as staged proof;
- staged proof is claimed without cached diff and staged set proof;
- commit proof is claimed before object exists in HEAD;
- receipt is treated as authority judgment;
- candidate support is treated as active helper;
- old proof is reused after content changes;
- rerun failure is hidden behind a surface fix.

## Console output rule carried forward

Console output should be a short card:

- PASS, WATCH, or BLOCKED;
- HEAD or COMMIT;
- TARGET;
- EDGE summary;
- FILES;
- NEXT;
- REPORT path and hash.

Full audit detail belongs in the report file, not the console.

## Boundary

This pattern does not activate a helper, promote a tool, rewrite ACTIVE_GUIDES, rewrite CURRENT_TRUTH_INDEX, start automation, start a watcher, or authorize mule dumping.

## Next use

Use this proof pattern before the next helper/tool fixture, save workflow, or command-center route that claims readiness, staged proof, committed proof, or helper authority.
