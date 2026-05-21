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
