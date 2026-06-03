# Whole House Intake Wash Spec Review Addendum Mule Report - 20260603

Mission: MULE_WHOLE_HOUSE_INTAKE_WASH_SPEC_REVIEW_ADDENDUM_SAVE_MISSION_V0_1
Object: WHOLE_HOUSE_INTAKE_WASH_AND_PLACEMENT_SYSTEM_SPEC_V0_1
Status: review/addendum packet only
Boundary: not doctrine, not active guide, not implementation, not automation, not cleanup

## Source Custody Proof

Exact source report used: C:\Users\13527\Desktop\123\nextmove.txt

Source SHA256: 1463F0D6D17EF3531412CB29A95AB16CF6CE6C5988771E82B6D08E888523FB1D

Source size: 291489 bytes

Source last write: 2026-06-03 14:46:51 local time

Line-reference index used: SOURCE_LINE_REFERENCE_INDEX_20260603.md

Line-reference method: `rg -n` heading/source anchors plus LF count.

LF line count: 14601

DoesNotProve: Source custody proves the reviewed object by path/hash only. It does not prove the source is correct, original, complete, adopted, or active.

StopLine: Do not copy raw source into the repo or promote it to doctrine without explicit user authorization.

## Boundary Proof

Files intended in this packet are documentation, index, TODO, manifest, and receipt files only.

No implementation happened.

No repo code was written.

No kernel/UI code was created.

No tool registry, watcher, automation, or command center action was created.

No ACTIVE_GUIDES or CURRENT_TRUTH_INDEX edits are authorized by this report.

No root cleanup, move, delete, or rename action is authorized by this report.

Git may be touched only for exact-set staging, proof check, commit, and push of this documentation packet.

## Source Inventory

| Area | Anchor | Found? | Review decision |
|---|---:|---|---|
| Gate stack V2 | nextmove.txt:41 | yes | keep as 20-gate spine |
| Gates 00-20 overview | nextmove.txt:43-605 | yes | keep |
| Missing schema | nextmove.txt:626 | yes | keep; add bloat guard |
| Missing state machine | nextmove.txt:714 | yes | keep |
| Missing route matrix | nextmove.txt:748 | yes | keep; route is not action |
| Missing what-not-to-do list | nextmove.txt:791 | yes | keep |
| Missing room map | nextmove.txt:812 | yes | keep |
| Smallest real build later | nextmove.txt:860 | yes | use as first-build boundary |
| Chunk 1 | nextmove.txt:916 | yes | detailed gates 00-02 plus source addendums |
| Chunk 2 | nextmove.txt:1633 | yes | add chunk 2 review addendums |
| Chunk 3 | nextmove.txt:2869 | yes | add chunk 3 review addendums |
| Chunk 4 | nextmove.txt:4609 | yes | add duplicate/sequence guard |
| Chunk 5 | nextmove.txt:6340 | yes | add box exit and hard-stop confidence guard |
| Chunk 6 | nextmove.txt:8083 | yes | add route/action and receipt split guards |
| Chunk 7 | nextmove.txt:9640 | yes | add event/mule/learning boundary guards |
| Chunk 8 | nextmove.txt:11326 | yes | add V0 bloat budget |
| Chunk 9 | nextmove.txt:13067 | yes | add save/build split guard |
| Existing global addendum pass | nextmove.txt:14023 | yes | preserve |
| Existing chunk 1 addendum pass | nextmove.txt:14321 | yes | preserve |
| Addendum passes 2-9 | no matching anchors | missing | filled here as bounded review addendums |

## Chunk Review Table

| Chunk | Source anchor | Found / missing / parked / blocked | First dependency | StopLine | DoesNotProve | Review result |
|---|---:|---|---|---|---|---|
| Overview gate stack | nextmove.txt:41 | found | source custody | no action from overview alone | does not prove detailed behavior | usable spine |
| Chunk 1 gates 00-02 | nextmove.txt:916 | found | arrival and quarantine state | do not act before fingerprint/fixity | does not prove identity/home/safety | source addendums present |
| Chunk 2 gates 03-05 | nextmove.txt:1633 | found | fingerprinted object | do not route from self-declaration alone | does not prove authority | needs addendums ADD-2.1/2.2 |
| Chunk 3 gates 06-08 | nextmove.txt:2869 | found | source/provenance fields | do not promote on provenance label alone | does not prove policy approval | needs addendums ADD-3.1/3.2 |
| Chunk 4 gates 09-11 | nextmove.txt:4609 | found | expected/actual set | do not rename/delete based on number alone | does not prove duplicate collision | needs ADD-4.1 |
| Chunk 5 gates 12-14 | nextmove.txt:6340 | found | risk fields | do not let confidence override hard stops | does not prove action permission | needs ADD-5.1/5.2 |
| Chunk 6 gates 15-17 | nextmove.txt:8083 | found | route recommendation | do not move/place without explicit authorization | does not prove placement by recommendation | needs ADD-6.1/6.2 |
| Chunk 7 gates 18-20 | nextmove.txt:9640 | found | event ledger | do not treat events or mule returns as authority | does not prove adoption | needs ADD-7.1/7.2 |
| Chunk 8 machinery | nextmove.txt:11326 | found | card schema | do not build beyond V0 | does not prove runtime tool | needs ADD-8.1 |
| Chunk 9 operating model | nextmove.txt:13067 | found | saved spec package | do not merge save gate with build gate | does not prove implementation readiness beyond V0 | needs ADD-9.1 |

## Cross-Cutting Review

The raw source has a strong 20-gate custody spine. The strongest repeated boundaries are: wash before home placement, self-declaration is evidence only, unknown routes to review rather than rejection, missing is a state, route recommendation is not action, every home placement needs a receipt, mule return is evidence not authority, and learning capture is not promotion.

The main gap is not the spine. The gap is that review addendums stop after global corrections and chunk 1. Chunks 2-9 are detailed, but they need targeted addendum coverage so the later gates inherit the same no-overclaim and no-action boundaries.

No lower-issue sweep fired as a blocker. The visible issue was incomplete addendum coverage for chunks 2-9, but it was repairable inside the review/addendum mission without touching implementation or protected paths.

## Addendums

### ADD-2.1 - Bundle Completeness Decision Card

AppliesTo: Gates 03-05, especially Bundle / Complete Set Gate at nextmove.txt:1645.

Problem: Waiting for a bundle can become silent delay if no card records what is missing, optional, extra, or blocked.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Every bundle check must produce a Bundle Completeness Decision Card with bundle_id, expected_members, present_members, missing_members, extra_members, blocker_state, allowed_next_gate, DoesNotProve, and StopLine.

Why Needed: It keeps incomplete bundles from being treated as failed, complete, or forgotten.

Affects: Gates 03, 10, 13, 15, 17, and 18.

DoesNotProve: A complete bundle does not prove the bundle is safe, current, authoritative, or home-ready.

StopLine: Do not place, execute, promote, delete, or clean a bundle because it is complete.

### ADD-2.2 - Self-Declaration Conflict Routes, It Does Not Fail

AppliesTo: Self-Declaration Gate at nextmove.txt:2375.

Problem: A file can claim a role that conflicts with name, path, provenance, or policy.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Self-declaration conflict is a route state. It must produce a Conflict or Missing Context card with claim_source_label and evidence_strength, not a hard rejection unless policy or safety blocks it.

Why Needed: Self-declared metadata is useful evidence, but not authority.

Affects: Gates 05, 06, 07, 08, 13, and 15.

DoesNotProve: A self-declaration does not prove origin, safety, authority, freshness, or placement permission.

StopLine: Do not authorize action from self-declaration alone.

### ADD-3.1 - Provenance Missing And Provenance Conflict Are Different States

AppliesTo: Provenance / Chain-of-Custody Gate at nextmove.txt:2885.

Problem: Missing provenance and contradicted provenance have different risk shapes.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Provenance status must distinguish MISSING_PROVENANCE, PARTIAL_PROVENANCE, CONTRADICTED_PROVENANCE, and VERIFIED_PROVENANCE. Missing routes to review or missing-context. Contradicted routes to conflict and can block action.

Why Needed: It prevents unknown source from being confused with disproven source.

Affects: Gates 06, 07, 08, 12, 13, 15, and 19.

DoesNotProve: Verified provenance does not prove authority, quality, currentness, or policy permission.

StopLine: Contradicted provenance blocks placement and promotion until resolved or explicitly parked.

### ADD-3.2 - Authority Cannot Upgrade Without Policy Receipt

AppliesTo: Authority Classification and Policy Gate at nextmove.txt:3441 and nextmove.txt:4027.

Problem: Authority labels can feel like promotion if not separated from policy decision and receipt.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Authority classification is a label, not an upgrade. An object may not become active, doctrine, executable, or current without policy approval, exact target, proof, receipt, and user authorization where required.

Why Needed: It preserves the source/evidence/candidate/active boundary.

Affects: Gates 07, 08, 12, 15, 16, 17, 18, and 20.

DoesNotProve: Authority classification does not prove policy approval or placement permission.

StopLine: Do not treat authority label as permission to write active files.

### ADD-4.1 - Duplicate Vs Sequence Safe Rule

AppliesTo: Duplicate / Stale / Shadow Gate at nextmove.txt:5714.

Problem: Numbered folders or repeated child filenames can be legitimate sequence/continuation packages.

Addition / Replacement / Removal: Replacement guard.

Exact Rule Text: Parent folders need unique custody names. Child files may repeat inside separate packages. A "2" is allowed when it is intentional sequence or continuation. A "2" is bad only when it secretly means duplicate/collision copy. Do not rename sequence folders. Use duplicate-review naming only when duplicate or collision status is proven by manifest/hash comparison.

Why Needed: It prevents false duplicate cleanup and protects intentional package structure.

Affects: Gates 09, 10, 11, 12, 13, 15, 16, and 17.

DoesNotProve: A matching name, number, or folder pattern does not prove duplicate, collision, staleness, or safe cleanup.

StopLine: Do not rename, move, delete, or collapse numbered folders until duplicate/collision proof exists and user approves.

### ADD-5.1 - Review Box Exit Criteria

AppliesTo: Review Box Gate at nextmove.txt:6906.

Problem: Review boxes can become parking that looks like closure.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Every review box card must include entry_reason, required_exit_evidence, next_allowed_route, parked_return_trigger if parked, owner_or_decider if known, DoesNotProve, and StopLine.

Why Needed: It keeps review boxes live and reviewable without pretending the issue is solved.

Affects: Gates 13, 15, 18, 19, and 20.

DoesNotProve: Being in a review box does not prove the object is bad, safe, stale, useless, or ready.

StopLine: Do not treat parking or review-box placement as closure.

### ADD-5.2 - Confidence Hard-Stop Override

AppliesTo: Confidence Gate at nextmove.txt:7439.

Problem: Numeric confidence can accidentally override protected paths, risk blocks, or policy constraints.

Addition / Replacement / Removal: Replacement guard.

Exact Rule Text: Confidence scores are advisory only. Any protected-path risk, policy block, destructive action, execution risk, credential/privacy risk, contradicted provenance, or explicit StopLine overrides high confidence.

Why Needed: It prevents math-shaped overconfidence.

Affects: Gates 12, 14, 15, 16, 17, and 19.

DoesNotProve: High confidence does not prove safety, authority, policy approval, or action permission.

StopLine: If a hard-stop condition exists, route to blocked/review even when confidence is high.

### ADD-6.1 - Route Recommendation Is Not Action Authorization

AppliesTo: Route Recommendation Gate at nextmove.txt:8095.

Problem: A route can be mistaken for permission to move, write, delete, commit, execute, or promote.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Route recommendation produces a proposed next lane only. It may not perform the action it recommends. Action requires the relevant action gate, explicit target, proof, receipt, and user authorization where required.

Why Needed: It protects the gap between advice and mutation.

Affects: Gates 15, 16, 17, 18, and 19.

DoesNotProve: Route recommendation does not prove action safety, placement success, authority, or finality.

StopLine: Do not mutate files, Git, pointers, tools, or active rules from a route recommendation alone.

### ADD-6.2 - Home Placement And Receipt Are Separate Proofs

AppliesTo: Home Placement and Placement Receipt Gates at nextmove.txt:8630 and nextmove.txt:9129.

Problem: Placement intent, placement action, and placement proof are separate facts.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Home placement requires pre-placement target proof and no-overwrite proof before action. Placement receipt requires post-placement hash/path proof after action. A planned placement is not a receipt.

Why Needed: It avoids false closure and keeps save gates inspectable.

Affects: Gates 16, 17, 18, and 20.

DoesNotProve: A placement receipt does not prove doctrine-level authority, future currentness, or runtime safety.

StopLine: If post-placement proof cannot be written, mark placement blocked and do not claim saved/placed.

### ADD-7.1 - Event Ledger And Mule Boundary

AppliesTo: Event Ledger and Mule Escalation Gates at nextmove.txt:9652 and nextmove.txt:10306.

Problem: Events and mule returns can be mistaken for command authority.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Event ledger entries record what happened or what was recommended. Mule returns provide evidence and proposed disposition. Neither can move, delete, promote, activate, or close an object without the required local gate proof and authorization.

Why Needed: It keeps memory and external review from becoming uncontrolled action.

Affects: Gates 18, 19, 20, and save receipts.

DoesNotProve: A logged event or mule return does not prove correctness, adoption, or action permission.

StopLine: Do not execute a mule return directly; route it through local gates.

### ADD-7.2 - Learning Harvest Promotion Firewall

AppliesTo: Learning / Rule Harvest Gate at nextmove.txt:10696.

Problem: A good lesson can accidentally become an active rule without proof.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Learning harvest creates candidate support only. Promotion requires conflict check, proof fixture or example, save gate, receipt, and explicit activation path. Candidate support is not active behavior.

Why Needed: It allows learning without uncontrolled rule mutation.

Affects: Gate 20, BRAIN_LEARNING, TODO, ACTIVE_GUIDES, and CURRENT_TRUTH_INDEX boundaries.

DoesNotProve: A harvested lesson does not prove active policy or implementation readiness.

StopLine: Do not edit active guides or current truth from a learning card alone.

### ADD-8.1 - V0 Card Bloat Budget

AppliesTo: Cross-cutting machinery and first tiny build at nextmove.txt:11326 and nextmove.txt:12783.

Problem: The full schema can tempt a too-large first implementation.

Addition / Replacement / Removal: Addition.

Exact Rule Text: READ_ONLY_SINGLE_FILE_INTAKE_WASH_CARD_V0 may output only the minimum fields needed to prove read-only intake custody: path, exists, size, modified time, sha256 if readable, format guess, self-declared role if present, initial risk flags, recommended review box, DoesNotProve, and StopLine.

Why Needed: It keeps the first build tiny enough to verify.

Affects: Chunk 8, Chunk 9, first-build TODO, and future tool design.

DoesNotProve: V0 does not prove full 20-gate behavior, home placement, cleanup, policy approval, or active tooling.

StopLine: Do not add moving, deleting, placement, watcher, automation, pointer writes, or full root scan to V0.

### ADD-9.1 - Save Gate And Build Gate Split

AppliesTo: Save package plan and first build after save at nextmove.txt:13788 and nextmove.txt:13878.

Problem: Saving the spec can be confused with starting implementation.

Addition / Replacement / Removal: Addition.

Exact Rule Text: Saving the intake-wash spec closes the design-review packet only. Implementation starts only after a separate exact authorization for READ_ONLY_SINGLE_FILE_INTAKE_WASH_CARD_V0 or another named build lane.

Why Needed: It keeps the review mission from turning into accidental tool work.

Affects: Chunk 9, TODO, proof checklist, and final receipt.

DoesNotProve: A saved spec package does not prove a working intake tool exists.

StopLine: Do not build or activate the tool during the review/save mission.

## First-Build Decision Proof

Recommendation: READ_ONLY_SINGLE_FILE_INTAKE_WASH_CARD_V0 should be first after save.

Source support: the source names the smallest real build at nextmove.txt:860, the first tiny build spec at nextmove.txt:12783, the first build after save at nextmove.txt:13878, and the final project decision at nextmove.txt:13986-14002.

Why before UI: the source frames the first build as a single-file read-only proof, and no UI can be trusted until the read-only card fields and StopLines are stable.

Why before broad kernel power: the source repeatedly blocks full-system implementation before the tiny proof works.

What must exist first: source path input, read-only file stat/hash check, family/format guess, risk flags, recommended review box, DoesNotProve, StopLine, and receipt/log output for the proof run.

What can be stubbed: family classifier details, route scoring, source influence labels, box contracts beyond names, and UI display.

What must be real: no-write enforcement, hash/fixity fields, error handling for missing/unreadable files, and printed DoesNotProve/StopLine.

What must stay blocked: moving, deleting, cleanup, placement, pointer mutation, ACTIVE_GUIDES edits, CURRENT_TRUTH_INDEX edits, watcher/automation, tool activation, and full root scan.

## Assumption Ledger

| Assumption | Type | Source anchor | Risk if wrong | Affects first build? |
|---|---|---:|---|---|
| nextmove.txt is the raw source object for this mission | source-backed | user request plus file hash | wrong source reviewed | yes |
| Review can add missing chunk 2-9 addendums without rewriting the full sheet | source-backed | nextmove.txt:14021 | over-editing or under-editing | no implementation impact |
| WORK_SHED should not be used as durable lane | prior user correction | prior correction in thread | wrong durable placement lane | no |
| READ_ONLY_SINGLE_FILE_INTAKE_WASH_CARD_V0 is the next build, not part of this mission | source-backed | nextmove.txt:13990-14002 | accidental implementation | yes |
| Documentation packet can be committed if exact set and proof pass | source-backed | save mission request | unsaved review packet | no |

## Final Report Verdict

PASS / PROOF-TO-DECISION COVERAGE COMPLETE / REVIEW CAN VERIFY WITHOUT REBUILDING / NO IMPLEMENTATION
