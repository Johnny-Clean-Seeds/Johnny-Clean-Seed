# Source Wash Full Cycle Harness V1

Date: 2026-05-29
Status: LOCKED DESIGN CONTRACT / READY FOR REPORT-ONLY BUILD
Placement: Local Code Workbench -> Source-to-House Wash Helper -> Full Wash Cycle Harness
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX
Mode: report-only design harness
Save scope: durable project rule/candidate + build/proof TODO + receipt

## Final locked object

The real object is:

`SOURCE_WASH_FULL_CYCLE_HARNESS_V1`

The script is only one part of the harness.

The harness requires:

1. Controller script.
2. State/rope ledger.
3. Decision ledger.
4. Rough-spot ledger.
5. Receipt/proof close.

## Locked method chain

`FRONT DOOR -> ALPHA LOCK -> CAPABILITY KEYS -> PREFLIGHT -> STATE INIT -> INVENTORY -> BATCH PLAN -> WASH -> EXTRACT -> FIT DRAFT -> NO-PARKING DISPOSITION -> ROUGH-SPOT MINI-WASH -> CONSOLIDATE -> FINAL JUDGE -> B CLOSE`

This is the full wash cycle. If one room is skipped, the result is not a full cycle; it is only a scanner/report helper.

## Boundary

- No doctrine promotion.
- No ACTIVE_GUIDES edit.
- No CURRENT_TRUTH_INDEX edit.
- No automation.
- No dashboard.
- No Git save in V1 controller.
- No broad scanner.
- No move/delete/system action.
- No helper pretending to decide doctrine.
- No fake PASS from parser/run success alone.

## Capability keys

- `READ_ROOT_KEY` — may read only the exact supplied root.
- `WRITE_REPORT_KEY` — may write only to approved report/output folder.
- `HASH_KEY` — may hash selected files and output artifacts.
- `BATCH_KEY` — may chunk and batch within limits.
- `DECISION_DRAFT_KEY` — may draft ADOPT/ADAPT/PARK/BLOCK/PROOF/LEAVE_BE, not final doctrine.
- `ROUGH_SPOT_KEY` — may classify and stop/continue safely.
- `NO_GIT_KEY_V1` — Git writes are blocked in the V1 controller.
- `NO_MOVE_DELETE_KEY_V1` — move/delete are blocked in the V1 controller.
- `NO_AUTHORITY_PROMOTION_KEY_V1` — no rule promotion.

## State machine

- `INIT`
- `PREFLIGHT_PASS` / `PREFLIGHT_BLOCKED`
- `INVENTORY_READY` / `INVENTORY_BLOCKED`
- `BATCH_PLAN_READY`
- `WASH_RUNNING`
- `WASH_DONE` / `WASH_CHOKED`
- `FIT_DRAFT_RUNNING`
- `DISPOSITION_READY`
- `CONSOLIDATE_READY`
- `FINAL_JUDGE_READY`
- `B_CLEAN_CLOSE` / `B_BLOCKED_WITH_RETURN_POINT` / `B_CHOKE_STOP` / `B_CHOKE_CAUSED_END` / `B_USER_STOP`

Only a B state closes the run.

## Required V1 output files

- `FULL_WASH_CYCLE_STATE_V1_<RunId>.json`
- `FULL_WASH_CYCLE_REPORT_V1_<RunId>.md`
- `FULL_WASH_CYCLE_DECISION_LEDGER_V1_<RunId>.csv`
- `FULL_WASH_CYCLE_ROUGH_SPOT_LEDGER_V1_<RunId>.csv`
- `FULL_WASH_CYCLE_ROPE_LEDGER_V1_<RunId>.md`
- `FULL_WASH_CYCLE_RECEIPT_V1_<RunId>.txt`

## Decision ledger columns

`RunId`, `BatchId`, `RelativePath`, `FullPathHash`, `FileName`, `Extension`, `SizeBytes`, `FileHash`, `EvidenceKind`, `RoleDraft`, `DecisionDraft`, `Confidence`, `Reason`, `AuthorityLevel`, `NeedsHumanFinal`, `ReturnTrigger`, `RoughSpotFlag`, `NextAction`

## Allowed EvidenceKind

`RULE_TEXT`, `HELPER_CODE`, `RECEIPT`, `REPORT`, `INDEX`, `STATUS`, `SOURCE_ORE`, `TRANSCRIPT`, `UNKNOWN`

## Allowed RoleDraft

`MECHANISM`, `PROOF`, `MAP`, `SOURCE`, `WRAPPER`, `STATUS`, `DUPLICATE`, `NOISE`, `UNKNOWN`

## Allowed DecisionDraft

`ADOPT`, `ADAPT`, `PARK`, `BLOCK`, `PROOF`, `LEAVE_BE`

## Rough-spot categories

`MISSING_ROOT`, `PATH_MISMATCH`, `OUTPUT_LANE_MISSING`, `REPORT_WRITE_FAIL`, `STATE_WRITE_FAIL`, `LEDGER_WRITE_FAIL`, `RECEIPT_WRITE_FAIL`, `UNREADABLE_FILE`, `OVERSIZE_FILE`, `LIMIT_HIT`, `EMPTY_INVENTORY`, `HASH_FAIL`, `ENCODING_FAIL`, `DUPLICATE_RUNID`, `RESUME_STATE_MISMATCH`, `DIRTY_SAVE_ROUTE_REQUESTED`, `FORBIDDEN_FLAG`, `CODE_GATE_REQUIRED`, `WRAPPER_CONFUSION`, `UNEXPECTED_EXCEPTION`

Severity: `INFO`, `WATCH`, `BLOCKER`, `CHOKE`

Action: `CONTINUE`, `SKIP_WITH_RECORD`, `PARK_WITH_RETURN`, `STOP_BLOCKED`, `STOP_CHOKE`

## Proof ladder

0. Design contract complete.
1. Parser proof.
2. Risk proof.
3. Tiny sample proof.
4. Real bounded root proof.
5. Receipt proof.
6. B close proof.
7. Human/assistant judgment proof.

V1 PASS is not "script ran." V1 PASS is cycle closure with state, decisions, rough spots, receipt, and B close.

## Source judgment text

Source SHA256: 3B315A237A3795BEA4D9589B9DB2E08137A7AAE59A11C8563AE98071CA0D5FC8

`	ext
Think Tank verdict: **the main goal is valid, but the helper should not become one monster script.** The clean design is a **wash-cycle controller** wrapped around the already-proven wash helper pattern. The helper engine reads and produces evidence. The controller carries state, batches, decisions, rough spots, and close truth. The saver remains separate until the cycle proves clean.

The house walk says this belongs in:

`Local Code Workbench -> Source-to-House Wash Helper -> Full Wash Cycle Controller`

Not doctrine. Not ACTIVE_GUIDES. Not CURRENT_TRUTH_INDEX. Not automation. Not dashboard. This is a bounded local helper evolution lane.

The strongest rule pressure is this: the suit carry card says the current working route is still **chat judgment -> small local helper -> Code Gate -> weak-PC-safe read/report -> pasteback proof -> next narrow move**, and it specifically says not to drag old broad-scan/evidence-chewing weight forward.  The Codex-down card says code is only justified when the task needs exact local evidence, batch reading, hashes, ledgers, repeatable filtering, or path custody; otherwise judgment stays in chat.  This task does justify code eventually, because “full wash cycles” need bounded local file evidence, repeatable ledgers, batch custody, receipts, and rough-spot classification.

Hard critique: my earlier “controller V1” idea was directionally right but still too flat. It treated the controller mostly like a report wrapper. That is not enough. A real full wash cycle needs a **state machine**.

The full wash-cycle shape should be:

`PRECHECK -> OBJECT LOCK -> INVENTORY -> BATCH PLAN -> WASH -> EXTRACT -> FIT DECISION -> ROUGH-SPOT MINI-WASH -> REPORT -> CLOSE`

That is different from the current wash helper, which proved wash-ready packet generation. The current engine can generate chunks and local outputs, but “full cycle” means it must finish with a decision state, a proof state, a rough-spot state, and a clean return point.

The correct architecture is three-layer, not one-layer.

Layer 1: **Wash Engine**
This is the existing helper pattern. Its job is local evidence: bounded root, selected files, chunks, hashes, unreadable count, oversize count, skipped directories, output paths, and clean/dirty wash result. It should stay boring. It should not become the judge of everything.

Layer 2: **Cycle Controller**
This is the new piece. It decides where the run is in the lifecycle. It says which batch is active, whether the wash finished, whether the decision ledger exists, whether a rough spot occurred, whether an A checkpoint is needed, and whether B close is clean, blocked, choked, or user-stopped.

Layer 3: **Save Adapter**
This is not first. This comes only after report-only full cycle proves stable. The cockpit rule is clear that Code Gate PASS is not job PASS, and save scripts still need commit, push, remote match, and final clean status.  So saving must remain a later adapter, not baked into V1.

The Think Tank pressure map:

`KEEP` — weak-PC defaults, Code Gate first, bounded root, MaxFiles/MaxDepth, batch pauses, progress output, exact-path intake, hashes, receipts, no broad crawl. The Codex-down card explicitly requires these helper defaults. 

`KEEP` — A/B checkpoint truth. Deep batch rules say large/deep/source-heavy work needs A progress checkpoints and B stop truth, with allowed stop labels like `CLEAN_CLOSE`, `BLOCKED_WITH_RETURN_POINT`, `CHOKE_STOP`, `CHOKE_CAUSED_END`, and `USER_STOP`. 

`NARROW` — “full wash cycle” should not mean “scan more.” It should mean “close the lifecycle.” The live carry card already says do not run more broad intake and do not reprocess old material after the wash judge says extraction is ready. 

`SPLIT` — code files are not direct reuse. The suit carry card says working helper scripts can be active patterns, not authority, and code files stay `READ_PATTERN_ONLY_FILTER_FIRST` until filtered and dry-tested.  So old helpers can donate mechanisms, not be pasted wholesale.

`PROOF` — V1 must be report-only. The cockpit says generated PowerShell must pass Code Gate unless trivial, must not leave helper/report slop in Desktop\123 root, and reports belong in `_MISC_DRAWER\READ_REPORTS`. 

`BLOCK` — no auto-save, no doctrine write, no CURRENT_TRUTH_INDEX touch, no ACTIVE_GUIDES edit, no broad whole-drive crawl, no delete/move/system action, no fake PASS.

The real object is:

`RUN_SOURCE_WASH_FULL_CYCLE_V1.ps1`

But the object’s job should be precise:

“Run one bounded local full wash cycle over a selected source/root, using the existing wash-helper pattern as the read engine, then produce a report, decision ledger, rope ledger, receipt, and B close state without saving to Git.”

That gives us the first true boss target.

The controller needs these inputs:

`-Root` exact path to wash
`-OutDir` default `_MISC_DRAWER\READ_REPORTS`
`-MaxFiles` default small
`-MaxDepth` default small
`-MaxBytesPerFile` or `-MaxFileSizeMB`
`-ChunkCharLimit`
`-SleepMs`
`-Mode ReportOnly`
`-RunId optional`
`-AllowGitWrites` absent in V1 or hard-blocked
`-LockSaveIfClean` absent in V1 or hard-blocked

The controller needs these outputs:

`FULL_WASH_CYCLE_REPORT_V1_<RunId>.md`
Human-readable report. It should include object lock, root, limits, batch list, evidence summary, decisions, rough spots, final verdict, and next return point.

`FULL_WASH_CYCLE_DECISION_LEDGER_V1_<RunId>.csv`
Machine-readable ledger. Columns should include file path, role guess, evidence type, decision, confidence, reason, hash, batch, rough spot flag, next action.

`FULL_WASH_CYCLE_ROPE_LEDGER_V1_<RunId>.md`
Rope tracker. It should list A checkpoints per batch and the B checkpoint close.

`FULL_WASH_CYCLE_RECEIPT_V1_<RunId>.txt`
Receipt with script path, script SHA256, root, root exists, file counts, output hashes, end state, and “GitSaved: False.”

The core state machine should use only these end states:

`CLEAN_CLOSE` — all required reports written, no blockers, no choke, no fake PASS.
`BLOCKED_WITH_RETURN_POINT` — safe stop, known missing proof/input/path, clear next action.
`CHOKE_STOP` — tool/script/path failure, but caught before false close.
`CHOKE_CAUSED_END` — bad ending; never PASS, must repair first.
`USER_STOP` — user stopped motion.

The wash verdicts should be separate from end states:

`CLEAN_WASH` — bounded wash completed and decision ledger has no unresolved blocker.
`WASH_WITH_PARKED_ITEMS` — completed, but some material is parked with return trigger.
`WASH_NEEDS_PROOF` — completed, but at least one claim/action needs proof before use.
`WASH_BLOCKED` — cannot continue because a required object/path/proof is missing.
`WASH_CHOKED` — tool/runtime failed.

The decision labels should stay boring:

`ADOPT` — clean reusable mechanism, ready for narrow use.
`ADAPT` — useful but needs modification.
`PARK` — useful but wrong time/lane, return trigger required.
`BLOCK` — unsafe, wrong lane, duplicated, or authority-confused.
`PROOF` — plausible, but needs direct proof before use.
`LEAVE_BE` — source/proof only; do not convert.

Important Think Tank correction: **the helper should not pretend to understand deep meaning.** It can classify evidence shape, file role, hash identity, size, path, repeated pattern, obvious helper mechanism, and obvious proof/receipt language. But semantic final judgment still belongs to the assistant/user unless later proven. That keeps the helper from becoming fake-authority.

So V1 should make **draft decisions**, not final doctrine decisions.

Example:

`DecisionDraft: ADAPT`
`Reason: Contains reusable bounded scan pattern, but code file requires filter-first review.`
`Authority: helper draft only`
`FinalDecisionRequired: true`

That is clean.

The full wash cycle should have four internal “rooms.”

Room 1: **Intake Lock**
The controller proves the root exists, records exact path, records limits, records run mode, confirms report-only, and blocks if the path is missing or if a dirty continuation/path confusion appears.

Room 2: **Evidence Wash**
The engine reads files in bounded batches. It writes chunks, hashes, unreadable/skipped/oversize counts, and batch summaries. This room must be weak-PC-safe.

Room 3: **Fit/Decision Draft**
The controller reads the wash results and produces the decision ledger. It does not promote. It does not save doctrine. It does not rewrite active guides. It marks code as filter-first unless already dry-tested.

Room 4: **Close Truth**
The controller checks whether required outputs exist, hashes them, writes receipt, emits final end state, and gives the next return point. This is where fake PASS gets killed.

The rough-spot mini-wash must be built into V1, even if simple. A rough spot is not just an error. It is any moment where forward motion becomes unsafe. Categories:

`PATH_MISMATCH`
`MISSING_ROOT`
`UNREADABLE_FILE`
`OVERSIZE_FILE`
`LIMIT_HIT`
`CODE_GATE_REQUIRED`
`REPORT_WRITE_FAIL`
`LEDGER_WRITE_FAIL`
`WRAPPER_CONFUSION`
`DIRTY_SAVE_ROUTE_REQUESTED`
`UNEXPECTED_EXCEPTION`

When one appears, the controller must not improvise. It records:

what happened, where, what was preserved, what was skipped, what output exists, what output is missing, whether the run can continue, and the next return point.

This is the part that makes it a “wash cycle” instead of a “script that scanned files.”

My hard recommendation:

Do **not** build V1 as a save helper.
Do **not** build V1 as a general house walker.
Do **not** make V1 decide doctrine.
Do **not** combine old helper extraction, wash engine, controller, and lock-save into one giant script.

Build V1 as:

`local report-only full wash cycle controller`

Then run:

`assistant filter -> Code Gate -> bounded run -> pasteback proof -> judgment`

The next concrete design target should be:

`RUN_SOURCE_WASH_FULL_CYCLE_V1.ps1`

Purpose:

“Given one exact root, run one bounded report-only wash cycle and produce a report, CSV decision ledger, rope ledger, and receipt with a true B checkpoint.”

Success standard:

`Parser: PASS`
`Code Gate: PASS or PASS WITH EXPECTED WATCH`
`Run: PASS`
`Root honored: true`
`Files processed <= MaxFiles`
`Depth honored <= MaxDepth`
`Outputs written: 4/4`
`Receipt hashes outputs`
`GitSaved: False`
`Final EndState: CLEAN_CLOSE`
`WashVerdict: CLEAN_WASH / WASH_WITH_PARKED_ITEMS / WASH_NEEDS_PROOF`
`No loose Desktop\123 root slop`

This gives us a clean next move: **write the V1 controller script, but keep it report-only and Code-Gate-first.**

`
"@

 = @"
# Source Wash Full Cycle Harness V1 — Fit Report

Date: 2026-05-29
Status: FITS / READY FOR LOCK SAVE
Object: SOURCE_WASH_FULL_CYCLE_HARNESS_V1
Placement: HOUSE_WORK/WORK_SHED/SORTING_BENCH
Authority: design contract and helper-evolution route only

## Fit decision

Verdict: ACCEPT WITH GUARDRAILS

The concept fits the Local Code Workbench and Source-to-House Wash Helper lane. It does not fit doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, automation, or dashboard.

## Why it fits

The harness turns the current wash-helper idea into a closed lifecycle rather than another scanner.

It supplies:

- capability keys;
- exact state machine;
- idempotence rule;
- required output artifacts;
- rough-spot severity/action;
- proof ladder;
- no-fake-PASS closure.

## What it blocks

- monster helper;
- save helper in V1;
- doctrine judge;
- broad scanner;
- Git write in V1 controller;
- move/delete/system action;
- parser/run success being treated as final PASS.

## Ignored-path note

This file lives under `HOUSE_WORK/WORK_SHED`, which may be ignored locally.
This save uses an exact-file manifest exception and `git add -f` only for this fit report.

## Next build object

Desktop/local helper target:

`C:\Users\<user>\Desktop\123\_MISC_DRAWER\READY_FOR_CODE\RUN_SOURCE_WASH_FULL_CYCLE_V1.ps1`

The script must be report-only and Code-Gate-first.

## Return trigger

Build V1 only after this contract is saved clean.
