# Decay / Freshness Labels Rule — Candidate V1

Date: 2026-05-28
Status: CANDIDATE RULE / SAVE SELECTED
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX
Boundary: freshness/decay labeling behavior only; not a proof index, dashboard, or registry rebuild

## Core Rule

Current-state files decay. A file can be true when written and still become dangerous later if it keeps looking current after the work has moved.

Use a small label set where freshness affects action:

- FRESH
- WATCH
- STALE
- SUPERSEDED
- RETIRED

Do not add more labels until repeated use proves need.

## Label Meanings

FRESH: current enough to act from.

WATCH: useful but has a named risk.

STALE: contains old current-state or next-action language; do not act from it without checking a newer pointer.

SUPERSEDED: another file or receipt replaced this file's job; keep for history and follow the superseding pointer.

RETIRED: no longer part of the active working model but kept for archive/proof/history.

## Minimum Label Shape

Freshness: WATCH
Reason: current path is usable, but next-action line is aging.
Last checked: 2026-05-28
Proof pointer: PROOF_HISTORY/example_receipt.txt
Superseded by: none

Keep the block small.

## First Use Targets

Use first only where freshness affects action:

- HOUSE_WORK/CENTER_ROOM/CURRENT_CENTER.md
- HOUSE_WORK/ASSISTANT_PATH/ASSISTANT_ENTRY_PATH_CANDIDATE_V1.md
- HOUSE_WORK/BREAK_ROOM_LOCKER/LOCKER_INDEX.md
- active status cards
- helper passports if created later

Do not label every proof receipt. Receipts are historical records.

## Think Tank + Opposition Cross-Check

Think Tank pressure: the house should reduce live-chat burden and explain itself.

Opposite rejected: everything old stays visually current.
Clean inversion: action-facing files should show freshness when decay matters.

Opposite rejected: full dashboard or proof index first.
Clean inversion: start with small visible labels on action-facing files.

Opposite rejected: delete old material to avoid confusion.
Clean inversion: mark stale, superseded, or retired while preserving proof/history.

## Relationship To Center Room

Center Room holds the current key, so it is a high-decay file. It should eventually carry a small freshness block, but it should not be updated every time something happens unless current orientation changes.

## Relationship To Break Room Locker

Break Room Locker holds parked load. Its index should eventually show whether a drop is active, stale, superseded, or retired, without becoming a dashboard.

## Relationship To Proof History

Proof History is historical. Receipts do not need freshness labels by default. A proof receipt can be old and still valid as historical proof.

## Proof Standard

A freshness label is valid only if it names the label, gives a reason, gives a last-checked date or proof pointer when needed, does not claim proof without a pointer, does not delete history, and does not promote itself to doctrine.

## First Implementation Boundary

Save this rule first. Do not relabel the house now.

First later-use candidates:

- CURRENT_CENTER.md
- ASSISTANT_ENTRY_PATH_CANDIDATE_V1.md
- LOCKER_INDEX.md

## Fit Decision

ACCEPT WITH GUARDRAILS / SAVE SELECTED

Reason: the house now has current-state rooms and orientation files. Current-state files decay, and stale state is a real future risk.

Guardrails: small label set only; action-facing files first; no full proof index; no dashboard; no doctrine or ACTIVE_GUIDES edit; no broad sweep.

## One-Line Clean Wrap

Decay labels keep yesterday's useful truth from pretending to be today's active route.
