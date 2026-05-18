# Save-to-Save Context Weight Rule

Status: ACTIVE LEARNING CANDIDATE
Authority: assistant operating support; not command authority by itself

## Problem

The assistant can drag old chat, long command output, prior proof text, and resolved transcript weight forward even after Mr.Kleen has a clean saved hash point.

That makes the live working room heavy.

The problem is not proof history existing.

The problem is proof history staying live after it has already been saved.

## Rule

After a real saved hash point with clean status and pushed current position, collapse live context to the saved state.

Live context should hold only:
- current hash
- latest saved receipt/checkpoint
- current active ball
- current allowed next move
- blocked moves
- unresolved open items

Everything else becomes retrieval-on-demand.

## Retrieval-On-Demand

Old chat, long logs, old proof receipts, and prior transcript detail should be pulled back only when needed for:
- rollback
- comparison
- proof audit
- stale-state diagnosis
- user request
- a receipt/status/anchor file that names the old item as needed

## Why This Is Not Deletion

This rule does not delete history.

It moves history out of live working memory after it is safely saved.

The hash point becomes the compression key.

## Patch Warning

This rule may be a patch, not the root fix.

The deeper boss is likely Context Compression / Live-State Boundary.

Possible root causes:
- no hard context-shedding gate after clean hash points
- transcript treated as live state instead of proof/history
- receipts/status/anchor not acting as strong enough compression keys
- command outputs staying active after save
- repeated phase proof/save logs staying live
- weak split between live memory, saved proof, archive/history, and retrieval-on-demand
- checkpoint summaries not designed enough for assistant reload

## Operating Form

After a clean save, the assistant should say or internally hold:

Current base:
main @ <hash>

Latest saved scope:
<commit message / files / receipt>

Next allowed move:
<one current next move>

Blocked:
<named blocked moves>

Open items:
<only unresolved items>

Then stop dragging old chat unless the next task requires it.
