# Awareness / Prior-Mistake / Predictive Learning Dissect Capture

Date: 2026-05-19
Base: main @ 12de5c8
Lane: Work Shed / Sorting Bench
Status: dissect capture and candidate system design, not doctrine

## Source correction

The user identified a repeated structural problem:

We must not keep doing long painful routes when there is an equally safe or safer faster alternative. The assistant must use awareness better, especially awareness of prior mistakes, old receipts, old evidence, old notes, and current house state.

The goal is to build a method that uses:
- what was,
- what is,
- what failed before,
- what worked before,
- what is currently active,
- what is stale,
- what is source-ore,
- what should happen next.

The user calls this "predicting the future."

## Atomic ideas captured

1. Long-route blocker
   If a safe batch/suit/dump-folder route exists, do not process material one painful item at a time.

2. Awareness must connect to prior mistakes
   A prior mistake is not just a receipt. It should become a retrieval signal before similar future work.

3. Old data must become prediction material
   Evidence, notes, receipts, ideas, and failures should help predict better next moves.

4. Use sorting/algorithm/bitstring-style methods
   The house needs a structured comparison method, not vibes.

5. Mule needs a permanent operating context
   The mule should not require the whole story every time.

6. Mule must use a specific dump folder
   Outside outputs must come back as one ordered custody batch, with manifest first.

7. Mule becomes a bounded outside tool
   The mule is not authority and not a messy actor. It is a bounded outside work tool that flows with the model.

8. Big issue handling needs its own folder/lane system
   For large issues, create a clear folder package: current problem, current state, prior mistakes, candidate fixes, mule kickoff, expected return folder.

9. House objects may need to move
   The assistant should move house objects when needed for flow, but only with lane, custody, and proof.

10. Large mule batches need batch handling
    Do not use slow one-by-one house-walk handling for a big connected mule batch when a safe-bin/trial-suit batch test is safer.

11. Local and remote brain must stay synced
    Project-relevant saves should go to both local repo and remote brain unless explicitly local-only/private.

12. Dissect Rule must fire on dense idea streams
    Split, group, preserve, rank, and insert. Do not lose parts.

## Outside pattern scan

Useful outside patterns found:

1. Lessons Learned / Knowledge Management
   Past mistakes must be retrievable and applied, not merely archived.

2. OODA Loop
   Observe, orient, decide, act. Awareness must feed orientation before action.

3. Retrospective / AAR pattern
   Reviews must produce a small number of real action items, not giant unfocused lists.

4. DACI / role clarity
   Clarify driver, approver, contributors, and informed parties to stop authority fog.

5. Knowledge graph / linked retrieval pattern
   Old evidence should be linked by issue type, lane, failure mode, fix, and future trigger.

## Candidate Mr.Kleen method

Name:
Future-Prediction Learning Loop

Job:
Use old house evidence to prevent repeated mistakes and choose better next moves.

Trigger:
- user says this should not happen again,
- repeated mistake appears,
- assistant starts long painful route,
- mule batch arrives,
- old/new/stale material is mixed,
- awareness should have fired but did not,
- big issue needs outside critique.

Loop:
1. Observe current problem.
2. Retrieve prior similar failures and wins.
3. Classify the current shape.
4. Compare current shape to old patterns.
5. Predict likely failure if we continue normally.
6. Choose faster safe alternative if available.
7. Create the smallest proofable fix.
8. If big/uncertain, package it for mule critique.
9. Receive mule output as one dump folder.
10. Test as safe-bin/trial-suit batch.
11. Install only after proof.
12. Save the lesson so next time retrieval improves.

## Proposed folder shape for big issue / mule critique

HOUSE_WORK\WORK_SHED\BIG_ISSUE_LABS\
  PREDICTIVE_LEARNING_AND_MULE_FLOW_20260519\
    00_CURRENT_STATE.md
    01_PRIOR_MISTAKES_AND_RECEIPTS.md
    02_PROBLEM_MAP.md
    03_CANDIDATE_METHOD.md
    04_MULE_KICKOFF.md
    05_EXPECTED_RETURN_CONTRACT.md
    RETURN_INBOX\
      PREDICTIVE_LEARNING_RETURN_20260519_001\
        MANIFEST.md
        REVIEW_REPORT.md
        OPTIONAL_SUPPORT\

## Current verdict

Do not install as doctrine yet.

This is a candidate system and mule-critique target.

Next move:
Send a bounded critique handoff to the mule requiring one ordered return folder.
