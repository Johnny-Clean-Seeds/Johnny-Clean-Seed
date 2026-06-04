# MULE HANDOFF — EXACT-SET SAVE + TOP-DOWN HELPER REVIEW

Date: 2026-06-04
Status: SINGLE START FILE / BIG BUT BOUNDED / EXACT SAVE GATES FIRST / TOP-DOWN HELPER REVIEW
WorkKey: MULE-HANDOFF-EXACT-SET-SAVE-TOP-DOWN-HELPER-REVIEW-20260604

## Start here

This is the next big mule job after UI Lane Phase 2.

Do not build another new layer before cleaning the save/proof surface.

The job is:

1. Lock/save the leftover exact sets that were intentionally not mixed into the UI commits.
2. Save the Row 001 manifest-backed static packet exact set only.
3. Classify Row 001 extras into separate save gates.
4. Build a top-down helper/lower-layer issue map.
5. Leave root clean and repo state proved.

This is not a read-only pass.

This is not a whole-folder add.

This is not a broad crawl.

## Current checkpoint from prior work

UI Lane Phase 2 reported complete and pushed.

Current reported Git:

`main @ 3a3eb770bb13f047799df1e8359b9353b46415f7`

`HEAD == origin/main: True`

`staged_count: 0`

Root:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Commits pushed:

- `7e7bf47 Save project command center UI lane`
- `3a3eb77 Build UI lane phase 2`

Phase 2 proof hashes:

- source handoff: `2C4B6A2851676D6BC015376CDD208B547FECF967D0AC7E43AF27DC02639D2F0F`
- manifest: `EEFAF5A2383653E127F9CEF794D1E2C7BA9A0841A52EB11A61D6532F8AAEEE14`
- rollback: `D8C7C129D6767DB49316C94B09832FD1BDD13DF5AC5CB6B851AEFA0B9C62A057`
- receipt: `AD029037CC8DE34C20AD46EECFD73CF5AB0C59BEBB2EC9C050BA1ADD18784589`

Important leftover from UI Lane Phase 2:

Git was not fully clean because older routed helper/root-cleanup work remained untracked, plus `HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md` had older cleanup status blocks in the working tree. These were not swept into the UI commits because that would have mixed unrelated material into an exact-set save.

## Row 001 sentinel checkpoint

Row 001 static packet sentinel reported:

`HELPER_FINAL_SENTINEL ROW_001_STATIC_CODE_SHAPE_PACKET_READBACK COMPLETE`

Readback only. No files created/changed, no staging, no commit/push, no helper scripts run.

Reported status:

`main @ f7b0de1222823075a8f039bb0c0d49158b3585fc`

`HEAD == origin/main: True`

`staged_count: 0`

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Proof files:

`PROOF_HISTORY/HELPER_STRESS_BENCH_ROW_001_STATIC_PACKET_MANIFEST_20260603.csv`

SHA256:

`B5268801ADB9CEA4646BE81C498E094C26216A8F5E077403ECCA52BC05C13905`

`PROOF_HISTORY/HELPER_STRESS_BENCH_ROW_001_STATIC_PACKET_RECEIPT_20260603.txt`

SHA256:

`9140D045136D2B4E555722A306CEDF10849D1954486B62E38F70A4327FC5EF52`

Readback result:

The manifest-backed Row 001 static packet is coherent. All 6 manifest rows exist, all 6 actual file hashes/byte counts match the manifest and receipt. CSVs parse: command table 84 rows, risk table 29 rows, manifest 6 rows.

Important boundary:

The Row 001 folder is not clean as a whole-folder save. It contains 34 files total, with 28 extra files not in the static-packet manifest, including later adjudication files, disposable fixture material, and a runner-reference script.

Recommendation to honor:

Proceed with exact-set save of only the 8 manifest-backed static packet files: the 6 packet files plus manifest and receipt. Do not `git add` the whole Row 001 folder. Extras need separate adjudication/save gates.

## Big-job data rule

This is big but bounded.

Use:

`READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL`

Do not reread entire folders unless required.

Use manifests, receipts, hashes, path maps, and Git status first.

Read full files only when needed to verify, modify, classify, or save.

## Root rule

Root must stay clean.

Allowed root set is the known stable folder set plus `desktop.ini`.

Final required line:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

No loose generated reports, handoffs, scripts, packets, manifests, temp files, or zips may remain in root.

## Blocker rule

Blockers are work items, not stop excuses.

Use:

`BLOCKERS_ARE_WORK_ITEMS_NOT_STOP_EXCUSES`

If a blocker is safe, internal, reversible, and does not require new user authority, fix/reduce/park it and continue.

Stop/ask only for real authority/safety/source-custody blockers.

## Reversibility rule

Use:

`HASH_BACKED_REVERSIBILITY_RECORDED`

Before changing, moving, merging, or staging existing files, record:

- path;
- SHA256;
- intended action;
- rollback/custody pointer if needed.

## Phase 0 — current truth check

Start in:

`C:\Users\13527\Desktop\123`

Repo:

`C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz`

Required checks:

1. Root inventory.
2. `git rev-parse HEAD`
3. `git rev-parse origin/main`
4. `HEAD == origin/main`
5. `git status --short`
6. staged count.
7. current branch.

If current HEAD differs from the reported checkpoint, do not panic. Use actual local truth, state the difference, and continue if safe.

## Phase 1 — exact-set save for leftover root-cleanup/helper work

Goal:

Save only the leftover routed helper/root-cleanup work that was intentionally excluded from UI commits.

Do not stage unrelated files.

Candidate families likely include:

- root cleanup receipts/manifests from Phase 1 and Phase 2;
- root no-loose-files rule if not already committed;
- repeated-correction rule if present and not committed;
- packaging link-cluster/no-nested-zips rule and receipt if present and not committed;
- status blocks related to cleanup/rules;
- custody/path reports created by cleanup scripts.

Required:

1. Identify exact leftover set from `git status --short`.
2. Group by family.
3. Decide whether each family is:
   - `SAVE_NOW_EXACT_SET`
   - `PARK_WITH_RETURN_TRIGGER`
   - `WATCH`
   - `BLOCKED_WITH_REASON`
4. Save only coherent families.
5. Do not include Row 001 extras unless they belong to the specific exact-set being saved.
6. Do not include UI Phase 2 files already committed.
7. Do not include unrelated parked packages.

Preferred commit if exact set is coherent:

`Save root cleanup and helper rule receipts`

If not coherent, produce an exact-set save plan instead of broad staging.

## Phase 2 — Row 001 static packet exact-set save

Goal:

Commit only the manifest-backed Row 001 static packet.

Exact set must be derived from:

`PROOF_HISTORY/HELPER_STRESS_BENCH_ROW_001_STATIC_PACKET_MANIFEST_20260603.csv`

and:

`PROOF_HISTORY/HELPER_STRESS_BENCH_ROW_001_STATIC_PACKET_RECEIPT_20260603.txt`

Required files:

- the 6 packet files listed in the manifest;
- the manifest file;
- the receipt file.

Do not stage the whole Row 001 folder.

Do not stage the 28 extras.

Required verification:

1. Parse manifest.
2. Confirm all 6 manifest rows exist.
3. Confirm byte counts and SHA256 match.
4. Confirm receipt references the same packet.
5. Confirm CSVs parse:
   - command table 84 rows;
   - risk table 29 rows;
   - manifest 6 rows.
6. Stage exactly the 8 files.
7. Show staged set.
8. Confirm no Row 001 extras staged.
9. Commit.
10. Push.
11. Verify `HEAD == origin/main`.
12. Verify final staged count 0.

Preferred commit:

`Save Row 001 static code shape packet`

Required verdict:

`ROW_001_STATIC_PACKET_EXACT_SET_SAVE_PROVED`

## Phase 3 — classify Row 001 extras

Goal:

Do not solve all 28 extras now unless it is cheap and exact.

Create a classification report for the 28 extra files in the Row 001 folder.

Do not stage extras by default.

Report categories:

- `ADJUDICATION_FILE_NEEDS_SEPARATE_SAVE_GATE`
- `DISPOSABLE_FIXTURE_NEEDS_SEPARATE_SAVE_GATE`
- `RUNNER_REFERENCE_SCRIPT_LOCAL_OR_ARCHIVE_ONLY`
- `PROOF_RECEIPT_CANDIDATE`
- `DUPLICATE_OR_SUPERSEDED`
- `UNKNOWN_REVIEW_LATER`

Required output:

`HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_20260603/ROW_001_EXTRAS_SAVE_GATE_MAP_20260604.md`

or nearest correct lane if path differs.

Required verdict:

`ROW_001_EXTRAS_NOT_WHOLE_FOLDER_STAGED`

## Phase 4 — top-down helper/lower-layer review map

Goal:

Produce a top-down issue map without broad rereading.

Review surfaces from top down:

1. UI lane current files.
2. Command grammar.
3. Action recipes/cards.
4. Proof gates.
5. Root rules.
6. Save gates.
7. Row 001 static packet.
8. Row 001 extras map.
9. Used runners/custody lanes.
10. Receipts/manifests.
11. Status/path maps.

Output:

`HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/REPORTS/TOP_DOWN_HELPER_LOWER_LAYER_ISSUE_MAP_20260604.md`

Must include:

- what looks clean;
- what is weak underneath;
- lower-layer issue candidates;
- parent-boss grouping;
- fix-now / park / watch / block table;
- next exact-set save gates;
- what not to build yet.

Required parent-boss grouping:

Do not rank issues as one flat list.

First group children under parent seams, then rank parent bosses.

Required verdict:

`TOP_DOWN_HELPER_REVIEW_MAP_BUILT`

## Phase 5 — proof packet

Create proof for this job.

Suggested location:

`HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/RECEIPTS/`

Required files:

- job manifest CSV;
- rollback/action manifest CSV;
- receipt TXT or MD.

Must include:

- files read;
- files created/modified;
- files staged/committed;
- hashes;
- commits;
- push proof;
- root check;
- Git final status;
- blockers fixed/reduced/parked.

Required verdict lines:

`EXACT_SET_SAVE_GATES_COMPLETE`

`HASH_BACKED_REVERSIBILITY_RECORDED`

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

## Phase 6 — commit/push policy

Prefer separate commits if coherent:

1. leftover root-cleanup/helper-rule exact set;
2. Row 001 static packet exact set;
3. top-down helper/lower-layer issue map and proof packet.

Do not merge unrelated sets just to reduce commit count.

If exact sets are entangled, pause only if the entanglement cannot be safely reduced.

Allowed blocker:

`EXACT_SET_SAVE_BLOCKED_BY_ENTANGLED_DIRTY_FILE`

But first try safe reduction.

## Required final answer shape

Use one:

`EXACT_SET_SAVE_AND_TOP_DOWN_HELPER_REVIEW_COMPLETE`

or

`REAL_BLOCKER_STOP_AND_ASK`

Then include:

Root:
`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Git:
- starting HEAD;
- ending HEAD;
- `HEAD == origin/main`;
- staged count.

Commits:
List commit hashes/messages, or `NO_COMMIT_WITH_REASON`.

Leftover exact set:
`ROOT_CLEANUP_HELPER_RULE_EXACT_SET_SAVED`
or
`ROOT_CLEANUP_HELPER_RULE_EXACT_SET_BLOCKED_WITH_REASON`

Row 001:
`ROW_001_STATIC_PACKET_EXACT_SET_SAVE_PROVED`
`ROW_001_EXTRAS_NOT_WHOLE_FOLDER_STAGED`

Top-down review:
`TOP_DOWN_HELPER_REVIEW_MAP_BUILT`

Proof:
Manifest path/hash.
Rollback manifest path/hash.
Receipt path/hash.

Blockers:
`BLOCKERS_ARE_WORK_ITEMS_NOT_STOP_EXCUSES`
List fixed/reduced/parked/real blockers.

Data:
`READ_ONCE_USE_MANIFESTS_AVOID_REPEAT_CRAWL`

Final:
`GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE`

## Hard boundaries

No read-only-only closeout.
No whole-folder Row 001 add.
No loose root files.
No nested zips.
No broad crawl.
No target/helper execution unless explicitly authorized.
No generated runner execution.
No package installs.
No deleting user originals.
No staging unrelated junk.
No fake clean.
No commit/push claim without proof.
