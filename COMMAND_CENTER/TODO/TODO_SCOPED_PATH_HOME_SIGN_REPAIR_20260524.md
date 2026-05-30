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

<!-- PATH_CLASS_50_WAVE_REPAIR:9DCF7F7CE5032452 -->
## Path-Class 50-Wave Repair Note

Status: CONFIRMED_PATH_CLASS_REPAIR / NOT_DOCTRINE
WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
RunId: 20260530_195739

Object path: COMMAND_CENTER/TODO/TODO_SCOPED_PATH_HOME_SIGN_REPAIR_20260524.md
Source inputs: ROOT_LAYER
Path class: route/path issue
Repair type: ROUTE_PATH_REPAIR
Confirmed fields/classes: MISSING_DISPOSITION_REVIEW

Controlled key:
- WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
- Key tags: PATH_CLASS_REVIEW, CONFIRMED_50_PACKET, INTAKE_GATE_KEY_HASH_GUARD, ROOT_LAYER_DROP_DOWN

Hash-to-receipt join:
- Target SHA256 before repair: 83AACA0797DAD191031475CCFAB9F33E7A9A2E1B3DB7520D74DC9F114013B50F
- Receipt: PROOF_HISTORY/PATH_CLASS_50_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
- Route index: HOUSE_WORK/WORK_SHED/INDEXES/PATH_CLASS_50_WAVE_REPAIR_ROUTE_INDEX_20260530.md
- What this hash proves: the bounded pre-repair target state for this packet.
- What this hash does not prove: doctrine promotion, full object cleanliness, or unrelated field closure.

Route / ledger / map:
- Ledger home: confirmed path-class packet saved with this repair.
- Map relation: Intake Gate finding and Root-Layer watch row -> path-class review -> confirmed packet -> bounded target note -> re-audit compare.
- Return path: confirmed packet and re-audit compare report.

Root-layer drop-down:
- Upper object: parked watch-row finding for this path.
- Lower object: path class, helper/tool, route/path, key/hash/intake, proof-only, or stale-currentness cause.
- Root cause tested: row was reviewed against current target content before repair.
- Separation verdict: repair only the named reviewed fields/classes; do not judge unrelated object health.
- Runtime proof needed: re-run Intake Gate and Root-Layer helpers after repair.

No-op / skip-only latch:
- NO-OP NO-COMMIT LATCH applies to the runner.
- SKIP-ONLY IS NOT REPAIR.
- Commit allowed only when RepairedTargets > 0.
- Commit message must match actual action.

Currentness and disposition:
- Currentness: CURRENT_SUPPORT_REPAIR_NOTE
- Disposition: KEEP_WITH_OBJECT_UNTIL_REAUDIT
- Next condition: re-audit and compare closure for this path and these fields/classes.

Boundary:
- confirmed packet rows only
- no doctrine
- no ACTIVE_GUIDES
- no CURRENT_TRUTH_INDEX
- no broad refactor
- no delete
- no move
- no automation
- no watcher
<!-- /PATH_CLASS_50_WAVE_REPAIR:9DCF7F7CE5032452 -->
