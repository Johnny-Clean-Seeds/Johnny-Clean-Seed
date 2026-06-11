# MULE ROOT NO LOOSE FILES RULE V1

Date: 2026-06-04
Status: RULE CANDIDATE / USER-CORRECTION CAPTURE / NOT REPO-SAVED HERE
WorkKey: MULE-ROOT-NO-LOOSE-FILES-20260604-V1

## Core rule

The mule/helper must not leave loose generated, temporary, work, report, script, receipt, package, or scratch files in the project root.

A file appearing in the project root is not automatically acceptable just because the mule created it.

Default judgment:

`ROOT_LOOSE_FILE_WRONG_LANE_UNTIL_PROVEN_ALLOWED`

## User correction

The user has repeatedly told the mule to stop leaving files in the root.

The failure is no longer merely “file placement cleanup.”

The failure class is:

`REPEATED_USER_STOP_SIGN_NOT_PROMOTED_TO_RULE`

That means the mule/helper heard the correction, cleaned or moved something locally, but failed to install the behavioral rule that prevents recurrence.

## Allowed root exceptions

Root-level files are allowed only when they are explicitly part of the house entry contract.

Examples of possible allowed root files:

- stable front-door pointer;
- current start ledger;
- explicitly approved root anchor;
- intentionally placed user drop/intake file waiting for classification.

Even these must be named and justified.

No broad exception is allowed.

## Forbidden root residue

The mule/helper must not leave these loose in root:

- generated scripts;
- generated reports;
- temporary drafts;
- package fragments;
- helper work files;
- copied source chunks;
- test outputs;
- receipts that belong in proof history;
- manifests that belong in proof history or report lane;
- local runners;
- scratch notes;
- duplicate handoff files;
- abandoned failed-attempt files.

## Required behavior before closeout

Before any mule/helper closeout, perform a root residue check.

The closeout must answer:

1. What new files did this mule/helper create?
2. Where did each file land?
3. Does each file belong in that lane?
4. Did anything land in root?
5. If yes, is it an explicitly allowed root object?
6. If not allowed, where was it moved or parked?
7. Was the movement recorded?
8. Does final root contain only allowed root objects?

## Wrong-lane handling

If a mule/helper creates or discovers loose root files:

1. Stop the affected lane.
2. Classify each file by name, path, purpose, and source.
3. Move only files that are clearly safe to move.
4. Park uncertain files instead of deleting.
5. Record the event as root residue evidence.
6. Do not claim clean closeout until the root is checked again.

## No silent cleanup

The mule/helper must not silently clean its own wrong-lane files.

If it created files in the wrong root lane, the receipt or closeout must say so.

Correct language:

`WRONG_LANE_ROOT_RESIDUE_FOUND_AND_ROUTED`

or

`ROOT_RESIDUE_BLOCKS_CLEAN_CLOSE`

Incorrect language:

`All good`

`Cleaned up`

`No issue`

when wrong-lane residue existed.

## Rule promotion trigger

This rule should be promoted from candidate to durable repo rule if the user approves a save route or if a future local worker saves it through the normal proof path.

Suggested durable placement:

`BRAIN_LEARNING/MULE_ROOT_NO_LOOSE_FILES_RULE_20260604.md`

Possible support receipt:

`PROOF_HISTORY/MULE_ROOT_NO_LOOSE_FILES_RULE_RECEIPT_20260604.txt`

## Fit with existing house rules

This rule supports:

- root clean / name-location compare-proof;
- wrong-lane placement disclosure;
- no-op/no-commit latch;
- root-drop intake event handling;
- mule/helper start and closeout checks;
- user-said-first correction capture.

## Final closeout line

A mule/helper cannot close clean while it has left unclassified loose files in root.

Required verdict when clean:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Required verdict when blocked:

`ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

## Boundary

This artifact does not move files.
It does not delete files.
It does not run a helper.
It does not claim repo save.
It does not claim Git status.
It is a written rule candidate generated from the user correction.
