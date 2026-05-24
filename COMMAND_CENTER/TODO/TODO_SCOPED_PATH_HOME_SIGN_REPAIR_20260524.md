# TODO - Scoped Path / Home / Sign Repair

Created: 2026-05-24
Status: pending scoped repair
Priority: high
Owner lane: command center / truth signs

## Why This Exists

The history-stage house walk found that active path signs still reference:

C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz

But the current live house is:

C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz

Existence check on 2026-05-24:

- old path: false
- live path: true

This can route future workers to the wrong door even when the rest of the pass is clean.

## Scope

Map and repair only live routing signs that are supposed to point to the current house.

Likely surfaces:

- AGENTS.md
- CURRENT_TRUTH_INDEX.txt
- COMMAND_CENTER teleporters and front-door signs
- any active pickup notes that claim the current project home

Historical receipts, old proof packets, archived backups, and source ledgers should not be mass-rewritten. They can keep old paths as historical evidence unless a specific live-use sign depends on them.

## Required Washer

1. Create a backup or receipt before editing active signs.
2. Use rg to map all old-path occurrences.
3. Classify each hit as live sign, historical evidence, or uncertain.
4. Repair only live signs.
5. Leave runner notes for historical/uncertain hits.
6. Verify old live signs no longer route workers to the false home.
7. Save local and Git.

## Blockers

- Do not rewrite ACTIVE_GUIDES or CURRENT_TRUTH_INDEX by momentum.
- Do not mass replace old paths through receipts and proof history.
- Do not collapse historical path evidence into current truth.

## Close Condition

Closed only when current live signs agree on the live house path or explicitly mark the old path as historical.
