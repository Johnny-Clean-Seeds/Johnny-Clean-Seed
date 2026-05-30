# Assistant Door Relay Local Manual Intake Rule

Created: 2026-05-21T13:29:18.0373098-04:00

Run ID: ASSISTANT_DOOR_RELAY_LOCK_SAVE_20260521_132918

## Rule

The bridge is complete through bounded Level 3, but assistant-direct execution from chat remains blocked unless a transport exists.

Assistant Door Relay local manual intake is now a proved narrow bridge surface:

assistant-created job concept -> local PowerShell relay/drop -> Child Shell DROPZONE -> watcher/dispatcher -> OUTBOX receipt.

This proves local manual intake, not zero-copy phone-to-PC execution and not assistant-direct local execution from chat.

## What Passed

Hotfix job:

CHILDJOB-20260521-131016-ASSISTANT-DOOR-READ-STATUS-HOTFIX

Fresh probe job:

CHILDJOB-20260521-132249-ASSISTANT-DOOR-FRESH-PROBE

Both were Level 1 read-status only.

## Boundary

Allowed:

- bounded local manual relay,
- Child Shell DROPZONE intake,
- watcher/dispatcher consumption,
- OUTBOX receipt proof,
- Level 1 read-status probe.

Blocked:

- assistant-direct execution from chat,
- zero-copy phone-to-PC execution,
- arbitrary shell,
- raw command expansion,
- broad crawl,
- delete,
- cleanup,
- repo write through this proof,
- git write through this proof,
- Level 3 save through this proof,
- ACTIVE_GUIDES rewrite,
- CURRENT_TRUTH_INDEX rewrite,
- doctrine rewrite.

## Practical Meaning

The missing piece was not Child Shell capability. Child Shell worked. The missing piece was local intake from assistant output. The manual relay proved a safe local doorway.

Future growth should not widen this door casually. Any stronger remote/zero-copy relay needs separate design, threat boundary, proof, and lock/save.

<!-- PATH_CLASS_50_WAVE_REPAIR:5982997090179FB5 -->
## Path-Class 50-Wave Repair Note

Status: CONFIRMED_PATH_CLASS_REPAIR / NOT_DOCTRINE
WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
RunId: 20260530_195739

Object path: BRAIN_LEARNING/ASSISTANT_DOOR_RELAY_LOCAL_MANUAL_INTAKE_RULE_20260521_132918.md
Source inputs: INTAKE
Path class: key/hash/intake issue
Repair type: INTAKE_GATE_KEY_HASH_GUARD
Confirmed fields/classes: Hash, Keying, Return

Controlled key:
- WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
- Key tags: PATH_CLASS_REVIEW, CONFIRMED_50_PACKET, INTAKE_GATE_KEY_HASH_GUARD, ROOT_LAYER_DROP_DOWN

Hash-to-receipt join:
- Target SHA256 before repair: F79E55835491E21E63D3D6217C704A98A7DA5147E6E283884697E76E5F290AC0
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
<!-- /PATH_CLASS_50_WAVE_REPAIR:5982997090179FB5 -->
