# Context Compression / Live-State Boundary Boss

Status: SORTING BENCH
Authority: support only; not command authority

## Source

The user noticed the chat becoming heavy again and said the save-to-save context rule feels like a patch, not a full fix.

The user also corrected the overbuilding warning:

If placement is clean, abundance is not the enemy.

## Boss Name

Context Compression / Live-State Boundary

## Problem

The assistant can confuse saved proof/history with live working state.

This causes old transcript weight, proof logs, command outputs, and resolved context to keep riding along after a clean hash point.

## Pattern

clean save -> hash exists -> old transcript still carried -> chat feels heavy -> assistant warns about overbuilding -> wrong diagnosis

## Better Diagnosis

The issue is not abundance.

The issue is live-state contamination.

## Candidate Root Causes

- no hard context-shedding gate after clean hash points
- not enough trust in hash/receipt/status as compression keys
- proof receipts written for evidence but not for assistant reload
- status/index records too much or too little in the wrong shape
- old command outputs stay active after final clean status
- unresolved items are not clearly separated from resolved history
- anchor/status/proof/checkpoint roles are not compressed enough
- active state, saved proof, archive/history, and retrieval-on-demand are not sharply separated

## Needed Future Design

A Context Compression Gate should define:
- what remains live after save
- what becomes proof/history
- what gets archived
- what gets retrieved on demand
- what fields every checkpoint needs for fast assistant reload
- when old transcript can be ignored
- when old transcript must be retrieved

## Current Power Play

Save-to-Save Context Weight Rule is an immediate operating fix.

Abundance Through Placement Rule corrects the false overbuilding diagnosis.

This boss remains open for deeper design later.
