# Branch-Cut Save Wrapper / Exact Manifest Authority Rule

Date: 2026-05-29  
Status: BRAIN LEARNING / HELPER SAVE ROUTE RULE CANDIDATE  
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Problem

A proved helper can be clean while the save wrapper around it becomes dirty.

During the Source Wash Full Cycle V1.3 proof save, the controller itself proved clean first, but the lock-save route branched into repeated wrapper failures:

- runner/target contract mismatch;
- brittle proof-field reader;
- ignored-path staging failure;
- dirty-status parser failure;
- Git-ignore witness used as staging authority.

This was a vine failure: the active proof was already stable, but the save wrapper kept generating side branches.

## Rule

When a save wrapper begins branching, cut the branch instead of patching each leaf.

The clean save authority is:

xact manifest -> exact-file force-add -> staged-set verification -> commit -> push -> HEAD/origin match -> final clean status

Do not use Git ignore/status interpretation as the steering authority once residue exists. Git status is proof after the manifest selects exact files. It is not the judge of what should be saved.

## Required behavior

For ignored-path or residue-sensitive saves:

1. write or identify the exact intended files;
2. build a manifest with role, lane, reason, size, and SHA256;
3. stage every intended file with exact-file force-add;
4. verify the staged set equals the manifest set;
5. block if anything extra is staged;
6. block if anything expected is missing;
7. commit only after staged-set verification;
8. push and verify HEAD == origin/main;
9. verify final clean status.

## Blocked

- no folder force-add;
- no wildcard force-add;
- no staged extras;
- no save/PASS claim without commit, push, remote match, and final clean status;
- no doctrine promotion from a helper proof;
- no ACTIVE_GUIDES edit;
- no CURRENT_TRUTH_INDEX edit;
- no raw run-output staging.

## Short form

When the save route becomes a vine, stop asking Git to guess. Manifest chooses exact files. Git proves only the result.