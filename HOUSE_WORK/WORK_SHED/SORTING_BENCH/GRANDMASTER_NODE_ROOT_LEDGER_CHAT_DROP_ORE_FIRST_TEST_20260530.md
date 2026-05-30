# Grandmaster Node Root Ledger First Test — Legacy Chat Drop Ore

Date: 2026-05-30
RunId: 20260530_082814
WorkKey: GRANDMASTER-20260530-NODE-ROOT-LEDGER-MAP
TestKey: CHATDROP-LEGACY-ORE-FIRST-TEST
Status: FIRST TEST CANDIDATE / NOT EXECUTED / NOT DOCTRINE

## Object

Use the stale Chat Drop list as the first test of Grandmaster Node Root Ledger.

## Why

The stale Chat Drop files showed that old copies may be stale live carry but still contain useful source ore.

Deleting or loading them blindly are both wrong.

## Test node

NodeKey: CHATDROP-LEGACY-ORE-20260530
Name: Legacy Chat Drop Ore
Type: Legacy Source Ore Lane
OwnerLane: Desktop Chat Drop / Legacy Review
SourceOfTruth: house/repo/proof history when available; otherwise unknown custody
Status: REVIEW_NEEDED
CurrentPointer: Desktop Chat Drop current files remain separate
ParentNode: GRANDMASTER-NODE-ROOT-LEDGER
ChildNodes: stale drop-copy file names
CloseCondition: every stale file is classified

## Classification labels

CURRENT_ACTIVE_COPY.
ALREADY_REPLACED.
LEGACY_SOURCE_ORE.
HARVEST_LATER.
UNKNOWN_CUSTODY.
SOURCE_PROOF_SAFE_DISPOSABLE_COPY.
DO_NOT_DELETE.
PROMOTED_TO_CURRENT.

## First feeler questions

Does this stale name already have a current replacement?

Is the real source safely in house/repo/proof history?

Does this file contain a unique mechanism not represented in Swift Scan or proof review?

Is this a duplicate copy only?

Should this become a row in Legacy Chat Drop Ore Ledger?

Should this be promoted to a current system only after extraction and style wash?

## Boundary

No deletion from house/proof.

No reloading old weird names as live suit.

No new ledger per file.

No current Chat Drop pollution.

No doctrine promotion.
