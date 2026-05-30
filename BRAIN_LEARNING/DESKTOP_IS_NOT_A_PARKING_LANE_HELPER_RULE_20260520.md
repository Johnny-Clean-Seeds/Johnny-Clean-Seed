# Desktop Is Not A Parking Lane - Helper Delivery Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: ACTIVE BEHAVIOR RULE / DELIVERY HYGIENE
Base before save: 11bf30e

## Rule

Desktop is not a parking lane.

If the assistant creates or sends a one-time helper script, generated file, scratch artifact, download, or temporary delivery file for Desktop use, it must not be left there after its job is complete.

## Default behavior

After successful proof, a temporary Desktop helper must be one of these:

1. deleted from Desktop;
2. moved into Mr.Kleen as a proved tool or tool-candidate with receipt;
3. explicitly marked for the user to keep.

Default = delete after successful proof.

## Correct helper pattern

A one-time helper should not require the user to notice trash and ask for cleanup later.

Correct flow:

helper runs
-> proof passes
-> helper cleans itself or routes itself into the house
-> final copy-back block reports the cleanup/routing

## Blocked behavior

Do not leave one-time helpers on Desktop as loose files.
Do not treat Desktop as Work Shed, Tool Cabinet, Proof History, Source Ore, or archive.
Do not make cleanup a second afterthought when the cleanup could have been built into the successful helper path.
Do not make the user babysit temporary files the assistant created.

## Self-clean standard for future helper scripts

When a generated Desktop helper is temporary, include a final successful-proof cleanup path.

The helper should only clean itself after:

- the intended save/action completed;
- git commit/push proof passed when applicable;
- HEAD matches origin/main when applicable;
- final status is clean when applicable;
- the copy-back block was printed;
- the helper is known to be temporary.

If the helper should be preserved, route it into Mr.Kleen as a tool/tool-candidate instead of leaving it on Desktop.

## Exception

The assistant may leave a file on Desktop only when the user explicitly asks to keep it there, or when it is a user-facing downloadable artifact meant for the user's own use and the assistant clearly labels that role.

## Power-play lesson

A clean repo save is not enough if the delivery path leaves trash outside the house.

The house got clean; the porch got littered. That is a delivery-hygiene failure.

Future saves must judge both:

- house proof;
- delivery cleanup.

<!-- LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:877D27C7F86D4B9C -->
## Living Object Registry V2 — First-Wave Bounded Repair Note

Status: SELECTED_FIRST_WAVE_REPAIR / NOT_DOCTRINE
WorkKey: LIVING-OBJECT-REGISTRY-V2-FIRST-WAVE-BOUNDED-REPAIR-20260530-V1
RunId: 20260530_150214

Object path: BRAIN_LEARNING/DESKTOP_IS_NOT_A_PARKING_LANE_HELPER_RULE_20260520.md
Species: HELPER_OBJECT
Owner room: BRAIN_LEARNING
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
Target: BRAIN_LEARNING/DESKTOP_IS_NOT_A_PARKING_LANE_HELPER_RULE_20260520.md
Relation: bounded registry repair / selected named gap.
Toolbelt: Living Object Contract; Helper Control Shell; Route Court; Policy Gate.
Proof/source pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Verdict: HELPER_CONTRACT_REPAIRED_PENDING_REAUDIT
<!-- /LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:ReturnPath -->
