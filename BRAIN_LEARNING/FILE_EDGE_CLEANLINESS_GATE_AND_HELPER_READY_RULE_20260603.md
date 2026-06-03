# File Edge Cleanliness Gate And Helper Ready Rule

Status: SUPPORT RULE / LOWER-CAUSE GATE CANDIDATE / NOT DOCTRINE
Date: 2026-06-03
Source: ideas.txt root intake, moved to `_SOURCE_RESEARCH_NOTES/ROOT_TEXT_DROPS_20260603/ideas.txt`
SourceHashSHA256: DBE8B9265A409C8774F11C9ECF4D379322DD9DA3D47E58F7879FE71397E9D56D
Neighbor: `BRAIN_LEARNING/LOWER_CAUSE_FILE_EDGE_GATE_AND_FIXTURE_CANDIDATE_20260601.md`

## Rule

A helper or save path is not ready just because the content looks right or the worktree looks calm.

Ready requires the intended staged set to pass a current file-edge proof after the final intended write and after staging.

Minimum gate:

```text
Normalize file edges.
Stage the intended set only.
Run git diff --check --cached.
If it fails, stop.
Repair the failed layer.
Restage the intended set.
Rerun git diff --check --cached.
Only then may a ready or save-close claim continue.
```

## Lower Cause

The visible symptom may be whitespace, extra EOF blank lines, line-ending churn, or a dirty staged check. The lower cause is defect escape: the route allowed a file to become content-valid enough to stage before it was proof-valid enough to commit.

Treat this as SCAR/CAPA material, not only formatting cleanup.

## Required Split

```text
Correction: repair the current file edge.
Corrective action: change the helper/save route that allowed the defect through.
Preventive check: require a current staged file-edge proof before ready/save/commit language.
```

## Invalid States

```text
CONTENT_VALID_AS_SAVE_VALID
WORKTREE_CLEAN_AS_STAGED_CLEAN
OLD_PROOF_FOR_CHANGED_PAYLOAD
HELPER_READY_WITHOUT_STAGED_DIFF_CHECK
COMMIT_PATH_AFTER_FAILED_DIFF_CHECK
CORRECTION_RECORDED_AS_CLOSEOUT
```

## Does Not Prove

```text
This does not prove the lower-cause gate is active.
This does not prove the fixture bench exists.
This does not prove every helper has been migrated.
This does not make any raw source file authoritative.
```

## Return Trigger

Return here whenever `git diff --check --cached` finds a staged defect, a helper claims ready without a staged proof, or a save packet reaches closeout before file-edge proof is current.
