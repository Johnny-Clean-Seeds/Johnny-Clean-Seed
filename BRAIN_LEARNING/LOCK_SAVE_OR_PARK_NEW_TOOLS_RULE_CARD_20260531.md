# Lock / Save / Park Rule Card for New Tools

Date: 2026-05-31
Status: RULE CANDIDATE / PARKED / NOT DOCTRINE
WorkKey: LOCK-SAVE-PARK-NEW-TOOLS-20260531

## Rule candidate

When a new tool, rule, suit behavior, helper method, gate, room method, or reusable proof move is created, it must not remain loose in chat.

Disposition must be one of:

1. LOCK/SAVE
2. PARK
3. TEST FIRST
4. REJECT
5. MERGE INTO EXISTING TOOL
6. WAIT FOR ACTIVE OBJECT TO CLOSE

## Lock/save criteria

Lock/save when:
- the tool changes behavior now,
- proof exists from a real run,
- the lane is known,
- the boundary is known,
- the next use is known,
- saving does not derail a more urgent active object.

## Park criteria

Park when:
- the idea is good but unproved,
- the active project object is still open,
- the tool needs outside research,
- the tool risks becoming bigger than the current job,
- the lane is known but proof is not complete.

## Required parking fields

- candidate name
- lane
- maturity state
- return trigger
- proof need
- intended future use
- blocked actions
- related active object
- owner room
- next smallest test

## Active carry from current event

Project-first/tool-second should be parked immediately and lock-saved after Coding Room proof-chain clean close.

## Boundary

This is a candidate rule. It does not authorize doctrine promotion, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, automation, watcher, broad refactor, move, delete, or universal framework work.
