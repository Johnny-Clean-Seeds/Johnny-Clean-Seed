# Chat Handoff Checkpoint + Rope Carry Rule

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
Status: SUPPORT RULE / CHECKPOINTED
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX.

## Rule

When a chat or task lane needs to move, create a compact checkpoint that carries the active rope, current anchor, proof state, last clean commit, current soft suits, saved rules, local-only artifacts, next packet, and blocked actions.

The checkpoint should let the next chat continue without dragging dead chat.

## Rope carry fields

- active object
- current task lane
- latest saved HEAD / origin / clean status if applicable
- current source file and hash
- active Soft Suit being worn
- what just closed
- what is still open
- next exact action
- blocked actions
- files created/exported
- local-only drop-copy locations

## Boundary

A checkpoint is a carry-forward pointer. It is not doctrine, not automation, and not a broad authority grant.
