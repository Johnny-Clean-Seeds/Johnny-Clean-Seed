# Whole House Intake Wash Spec - Open Questions - 20260603

Status: parked questions only
Boundary: questions do not authorize implementation, cleanup, active edits, or doctrine promotion

## Questions Needing User Decision

| ID | Question | Why it matters | Default until answered | Return trigger |
|---|---|---|---|---|
| OQ-1 | Should the preserved and new addendums be pasted into a single canonical spec later? | This packet indexes and adds; it does not rewrite the raw sheet. | keep as addendum packet | user asks for canonical spec merge |
| OQ-2 | Should CLEAN_ROUTE_BOX be renamed globally or kept as an alias with warning? | Source says the name can mislead. | keep alias, warn that clean means eligible only | user asks for naming pass |
| OQ-3 | What exact first test file should READ_ONLY_SINGLE_FILE_INTAKE_WASH_CARD_V0 use? | First build needs a bounded proof target. | no implementation | user authorizes V0 build |
| OQ-4 | Should source nextmove.txt stay only in local root or get a hashed private custody note? | Raw source is large/private and was not copied. | leave raw source out of repo | user asks for source custody packet |
| OQ-5 | Should duplicate/sequence correction become a reusable house rule card? | It affects cleanup safety across the house. | keep as addendum support, not doctrine | user asks for rule promotion review |
| OQ-6 | Should review boxes get a standard CSV/card schema before V0? | It may make later review easier but risks overbuilding. | defer until V0 proves minimum card | V0 design needs schema choice |

## Parked Excess

Broad source cleanup, root cleanup, watcher/automation, full intake tool, UI, command center, tool registry, ACTIVE_GUIDES, and CURRENT_TRUTH_INDEX work are parked because the mission is review/addendum/save only.

DoesNotProve: An open question does not prove blocked work is approved or required.

StopLine: Do not answer these by mutating files or building tools without explicit user authorization.
