# User-Said-First Crosscheck House-Rope Suit Card V1

Date: 2026-05-30
Status: CHAT COCKPIT SUPPORT CARD / LIVING RULE / NOT DOCTRINE
WorkKey: USFCHR-20260530-USER-SAID-FIRST-CROSSCHECK-HOUSE-ROPE
RepairKey: POWERPLAY-CRIME-SCENE-20260530-USFCHR-V1-REPAIR
FileKey: FILE-SUIT-CARD
SourceBase: origin/main @ 8ed7dbac1389d2bea885561798b3fff458d92bc9

## Wear line

USER SAID FIRST -> GIT CROSSCHECK -> FRESH LOADED SOURCES -> HOUSE DOOR + ROPE -> BEST ROOM -> BEST NEXT MOVE.

Companion repair line:

EXPOSURE -> POWERPLAY / CRIME SCENE -> PRESERVE -> REPAIR ROUTE -> PROVE -> RESUME.

## What this fixes

The assistant must not immediately process the first obvious next action after a proof/status message. It must first acknowledge the user's stated proof, then check freshness and source authority, then choose the current room/lane based on the task.

## Live use test

When a PASS/status message arrives, answer in this order:

1. You said.
2. Git/current-source cross-check.
3. Loaded project source check.
4. House-rope room choice.
5. Best move and blocked lanes.

When a failure exposes a gap, answer in this order:

1. Freeze the scene.
2. Preserve evidence.
3. Name the exposed route gap.
4. Repair only the current route.
5. Prove before claiming saved/PASS.

## Freshness guard

If GitHub/origin/main has a newer living commit than the carried chat state, stop and load the newer state before saving or advising.

## Key/hash guard

Every created or updated save object gets a FileKey in the legend/ledger/keymap. Final SHA256 values are recorded in the receipt and, where stable, in the keymap.

## Boundary

Support behavior only. No doctrine. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX. No automation. No watcher. No Whirlpool. No implementation. No full batch unlock.