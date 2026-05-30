# Chat Assistant Rule Flow Living Ledger

## Helper / lane
Chat assistant rule-flow helper.

## Purpose
Track assistant-side rules that must become file-aware, parked, opened, or applied.

## Current state
Freshen' up is a named reset/orientation ritual.

Assistant-side rules are now treated as file-facing candidates. Most are parked until opened by task fit. Some open immediately when they repair the active task.

## Event 001 - Freshen' up was being used as a chat summary stop

### What happened
The assistant began Freshen' up by summarizing state to chat and treating that as the output.

### User correction
The user said Freshen' up should send the summary to the assistant as internal notes, then use that note to push forward. It should trigger when wheel-spinning or losing track, not when deep thinking is actually needed.

### False blame blocked
The problem was not the Freshen' up ritual itself.

The problem was the assistant using the ritual as a public summary endpoint instead of an internal reset and continuation method.

### Fix
Saved support rule: Freshen' up Internal Orientation and Task Continuation Rule.

### Current behavior
Freshen' up should preserve rope, reduce fog, and continue the active task.

### Reopen trigger
Reopen this event if Freshen' up again ends the task, dumps unnecessary summary, loses the active blocker, or prevents needed deep work.

## Event 002 - Assistant rules need file routes

### What happened
The user clarified that all rules for the assistant are now also for files, mostly parked waiting to be opened unless they have a way to go now.

### Fix
Saved support rule: Assistant Rules to File Parking and Opening Rule.

### Current behavior
New assistant rules should be placed in file lanes as parked/openable material, not left as dead chat.

### Reopen trigger
Reopen if a useful assistant rule remains only in chat, or if a parked rule is promoted without task fit/proof.

<!-- LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:6D1966993BEF7772 -->
## Living Object Registry V2 — First-Wave Bounded Repair Note

Status: SELECTED_FIRST_WAVE_REPAIR / NOT_DOCTRINE
WorkKey: LIVING-OBJECT-REGISTRY-V2-FIRST-WAVE-BOUNDED-REPAIR-20260530-V1
RunId: 20260530_150214

Object path: HOUSE_WORK/WORK_SHED/HELPER_MEMORY_LEDGER/CHAT_ASSISTANT_RULE_FLOW_LIVING_LEDGER_20260529.md
Species: HELPER_OBJECT
Owner room: UNKNOWN_OWNER_ROOM
Authority class: HELPER_SUPPORT_NOT_JUDGE
Repair field: ReturnPath
Failure family: ROOM WITHOUT RETURN
Suggested stitch: RETURN STITCH
Repair reason: Helper object should return with verdict/next condition.

Registry key tags:
- LIVING_OBJECT_REGISTRY_V2
- FIRST_WAVE_REPAIR
- HELPER_OBJECT
- ReturnPath

Ledger home: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Map / route home: HOUSE_WORK/WORK_SHED/INDEXES/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR_ROUTE_INDEX_20260530.md
Proof pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Currentness: CURRENT_SUPPORT_REPAIR_NOTE
Disposition: KEEP_WITH_OBJECT_UNTIL_REAUDIT

Allowed action:
- Repair only this named audit gap by adding contract/route/proof/return metadata.

Forbidden actions:
- Do not promote this object to doctrine.
- Do not treat this block as proof of full cleanliness.
- Do not repair unrelated gaps from this block.
- Do not delete or move this object.

Boundary:
- selected ticket path only
- no doctrine
- no ACTIVE_GUIDES
- no CURRENT_TRUTH_INDEX
- no broad refactor
- no delete
- no move
- no automation

## Helper assay fields

Task: Repair selected first-wave registry gap only.
Route tested: selected repair ticket -> target object -> route index -> receipt -> return TODO.
Source: first-wave selected repair plan.
Target: HOUSE_WORK/WORK_SHED/HELPER_MEMORY_LEDGER/CHAT_ASSISTANT_RULE_FLOW_LIVING_LEDGER_20260529.md
Relation: bounded registry repair / selected named gap.
Toolbelt: Living Object Contract; Helper Control Shell; Route Court; Policy Gate.
Proof/source pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Verdict: HELPER_CONTRACT_REPAIRED_PENDING_REAUDIT
<!-- /LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:ReturnPath -->
