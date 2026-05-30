# Helper Save Content Validation and Issue Learning Rule

Date: 2026-05-29
Status: ACTIVE SUPPORT RULE CANDIDATE
Lane: Clean Seed / Mr.Kleen helper refinery and save-script safety

## Trigger

When a helper, save script, viewer lifecycle script, Code Gate route, or toolbox step fails during project work, treat the issue as learning material, not dead friction.

## Rule

Every project-relevant issue should be converted into a power-play record when it exposes a reusable fix.

The file record should capture:

- the issue trigger;
- the failed command or failed proof point;
- the observed error text;
- the root cause as narrowly as possible;
- the fix shape;
- the prevention gate;
- the proof that the fix worked;
- the boundary of what was and was not changed.

## Save-Script Content Gate

Before a helper writes planned project artifacts, it must validate the content object for each planned file.

Required checks:

- content is not null;
- content is not empty or whitespace when the artifact is meant to carry a rule/card/receipt;
- unresolved placeholders are not left behind;
- write path is exact and expected;
- hash is captured after write;
- partial prior writes are either recovered explicitly by exact path or blocked.

## Markdown / Here-String Safety

For long markdown content inside PowerShell scripts, prefer single-quoted literal here-strings plus explicit placeholder replacement. This avoids accidental variable expansion and escape-character behavior while still allowing controlled dynamic values.

## Blocked Claims

Do not call a failed helper route clean just because the parser passed.
Do not treat a binder error, empty-content write, false placement fail, or viewer-open-only event as a successful save/proof.
Do not leave the learning only in chat when it applies to the house.

## Current Failure Family

The Freshen' up V1 save script reached write mode and failed while writing the fit card because the content argument arrived as an empty string. The repair is to validate planned content before writes, use safer literal text construction, recover only expected partial paths, and save this issue as a reusable helper-learning rule.

<!-- LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:626C229BAA7BD109 -->
## Living Object Registry V2 — First-Wave Bounded Repair Note

Status: SELECTED_FIRST_WAVE_REPAIR / NOT_DOCTRINE
WorkKey: LIVING-OBJECT-REGISTRY-V2-FIRST-WAVE-BOUNDED-REPAIR-20260530-V1
RunId: 20260530_150214

Object path: BRAIN_LEARNING/HELPER_SAVE_CONTENT_VALIDATION_AND_ISSUE_LEARNING_RULE_20260529.md
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
Target: BRAIN_LEARNING/HELPER_SAVE_CONTENT_VALIDATION_AND_ISSUE_LEARNING_RULE_20260529.md
Relation: bounded registry repair / selected named gap.
Toolbelt: Living Object Contract; Helper Control Shell; Route Court; Policy Gate.
Proof/source pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Verdict: HELPER_CONTRACT_REPAIRED_PENDING_REAUDIT
<!-- /LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:ReturnPath -->
