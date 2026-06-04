# Mule Root No Loose Files Rule

Date: 2026-06-04
Status: BRAIN LEARNING RULE / CLOSEOUT GATE / NOT DOCTRINE
WorkKey: MULE-ROOT-NO-LOOSE-FILES-20260604

## Core Rule

Mule/helper work must not leave loose generated, temporary, work, report, script, receipt, package, fixture, handoff, or scratch files in `C:\Users\13527\Desktop\123`.

Default judgment:

`ROOT_LOOSE_FILE_WRONG_LANE_UNTIL_PROVEN_ALLOWED`

## Why This Exists

The user repeatedly corrected root-file residue. The failure was not only file placement; it was repeated cleanup without installing a prevention check.

Failure class:

`REPEATED_USER_STOP_SIGN_NOT_PROMOTED_TO_RULE`

## Allowed Root Exceptions

Root-level objects are allowed only when they are part of the stable entry contract or current intake contract:

- stable root folders already accepted by the house;
- the project repo folder;
- `desktop.ini`;
- an explicitly intentional user drop waiting for classification.

Every other loose work object is wrong-lane until proven otherwise.

## Required Closeout Check

Before closeout, inspect the root and answer:

1. What files/folders are present?
2. Which are allowed root objects?
3. Which are user drops waiting for classification?
4. Which are wrong-lane work residue?
5. Where was each wrong-lane item routed?
6. Was routing recorded with hashes?
7. Does final root contain only allowed root objects?

Clean pass line:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Blocked line:

`ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

Routed-residue line:

`WRONG_LANE_ROOT_RESIDUE_FOUND_AND_ROUTED`

## No Silent Cleanup

If wrong-lane residue existed, the final report must say so. Do not merely say "cleaned up." Name the residue, route, proof, and final root result.

## Boundary

This rule does not authorize deletion of user originals, broad cleanup, doctrine promotion, ACTIVE_GUIDES edits, CURRENT_TRUTH_INDEX edits, watcher, automation, helper execution, or unproven move/delete actions.
