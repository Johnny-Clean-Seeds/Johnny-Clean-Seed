# Git Dirty Tree Disposition Before Lock/Save Rule

Date: 2026-05-24

Status: active save-discipline checkpoint.

## Rule

Before any broad lock/save, commit, push, house wash, or "save all areas" request, inspect the Git
working tree and give every modified or untracked item a named disposition.

A dirty tree is not trash and not automatic build material. It is evidence that must be sorted before
it can be trusted.

## Trigger

This fires when:

- `git status` shows modified, deleted, renamed, copied, or untracked files;
- the user says the tree has pre-existing changes, shifted files, dropped files, or mystery material;
- a previous run left untracked packets, receipts, backups, TODOs, parking notes, or local-only data;
- a broad save would otherwise stage more than the current task knowingly touched.

## Required Disposition Labels

Each dirty item must be labeled:

- ADD TO BUILD: safe, durable house material that belongs in Git now.
- UPDATE TRACKED: intentional change to an already tracked house file.
- LOCAL-ONLY HOLD: sensitive, private, raw-source-heavy, credential-like, or local evidence that must
  not be committed.
- PARK WITH RETURN: useful but not ready; needs a clean lane, reason, owner, and next trigger.
- WRONG LANE MOVE: belongs in the house, but not where it is sitting.
- BLOCKED / ASK: cannot be classified from available evidence.

## Clean Handling

1. Capture status before staging.
2. Read or sample enough content to classify each dirty family.
3. Search for local-only or sensitive signals before staging.
4. Move local-only evidence to a named local-only hold lane with a ledger.
5. Keep Git-facing house material in its proper lane with receipts.
6. Stage only classified Git-safe paths.
7. Run staged diff checks.
8. Commit and push only after the disposition is recorded.
9. Verify final status and remote/local HEAD alignment.

## Bad Pattern

- `git add -A` before classification.
- Leaving mystery untracked files in Git-facing lanes after a save.
- Treating a receipt as proof that its referenced local-only source is safe to publish.
- Silently ignoring dirty material because it was pre-existing.
- Moving local-only material without a ledger.

## Clean Pattern

The final report names:

- what was committed;
- what was held local-only and where;
- what was parked for later;
- what remained blocked or intentionally untracked;
- whether local tracked files still exist and match Git's index.

## Relation

This is a checkpoint under Local + Git Save Trigger Rule, Git Save / Push Default Rule, No Parking
Without Fit Decision Rule, Source Safe Reframe Placement Rule, and Save Lane Split Rule.

It does not force sensitive or unclear material into Git. It prevents hidden piles by requiring a
disposition before the save is called clean.
