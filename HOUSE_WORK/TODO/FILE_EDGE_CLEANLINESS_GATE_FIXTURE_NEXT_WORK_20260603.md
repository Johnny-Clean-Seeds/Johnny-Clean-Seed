# File Edge Cleanliness Gate Fixture Next Work

Created: 2026-06-03
Status: TODO / PROOF FIXTURE WORK / NOT DOCTRINE
Source: ideas.txt root intake

## Task

Add fixture coverage for the file-edge cleanliness gate so helper-ready and save-ready claims cannot skip staged proof.

## Fixture Rows To Add

- content-valid file staged without current `git diff --check --cached`;
- worktree proof reused as staged proof;
- file repaired after proof but not restaged;
- staged index stale after rewrite;
- visible EOF blank fix recorded as full lower-cause closeout;
- helper ready claim printed before staged proof;
- commit/save route continued after dirty staged check.

## Required Fields

```text
FixtureId
InputState
BlockedClaim
ExpectedVerdict
RequiredProof
RepairLayer
DoesNotProve
ReturnTrigger
```

## Done Condition

A small fixture table exists and a review receipt states which claims it blocks and what it still does not prove.
