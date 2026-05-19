# Incoming File Parking Index

Date: 2026-05-19.
State: Work Shed intake lanes.
Authority: parking / sorting structure.
Starting base: main @ a690faa.

## Purpose

Create a clean place for PC-only / not-yet-sorted files before deciding whether they should stay private, be pushed to the remote brain, be archived, or be deleted after approval.

## Language Correction

Do not call these files bad milk.

Do not treat Git ignored as house judgment.

Call them PC-only incoming / not-yet-sorted material until classified.

## Lanes

### 01_NEEDS_INSPECTION
Default lane. File exists but purpose, risk, and destination are not yet known.

### 02_TOOL_CANDIDATES
Scripts, checkers, helpers, gates, or commands that may become useful tools after review.

### 03_PROOF_AND_RECEIPT_CANDIDATES
Receipts, reports, proof records, or review outputs that may need to enter PROOF_HISTORY or source ore.

### 04_BACKUP_HISTORY_HOLD
Backups, older copies, snapshots, or historical material. Hold before deletion or promotion.

### 05_KEEP_PC_ONLY_PRIVATE_OR_SECURITY
Material that should remain on the user's PC only because it may contain private, sensitive, machine-specific, or security-relevant information.

### 06_REMOTE_BRAIN_CANDIDATES
Material that appears useful and safe enough to consider for commit/push after inspection.

### 07_ARCHIVE_OR_DELETE_REVIEW
Material that may be obsolete or clutter, but cannot be deleted without approval and bounded inspection.

## Current Known Incoming Sources

The recent check showed tracked files match remote/URL brain, but ignored PC-only files exist.

Known categories from that output include:

- root CHECK_*.ps1 checker scripts,
- HOUSE_WORK/TOOLS/Invoke-DailyHouseWalkDigestGate.ps1,
- PROOF_HISTORY backup folders,
- PROOF_HISTORY report / review text files.

## Intake Procedure

1. List candidate files.
2. Identify purpose.
3. Identify target or source relation.
4. Identify security/privacy risk.
5. Classify into a lane.
6. Decide: keep PC-only, push candidate, archive, delete after approval, or inspect more.
7. Only commit/push after explicit decision.

## Boundary

This index creates lanes only.

It does not move, delete, add, force-add, commit, or promote the existing PC-only files.
