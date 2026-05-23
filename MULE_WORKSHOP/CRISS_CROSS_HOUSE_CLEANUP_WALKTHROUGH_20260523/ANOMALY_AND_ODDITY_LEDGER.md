# Anomaly And Oddity Ledger

Date: 2026-05-23

## A1. Root Pickup Split From Active Home Pickup

Finding:
The criss-cross work order exists at `C:\Users\13527\Desktop\123\COMMAND_CENTER\PICKUP`, while the active home pickup lane does not contain that work order.

Why it matters:
The active house can appear unaware of a live root pickup source.

Safe fix:
Wrote `COMMAND_CENTER\PICKUP\CRISS_CROSS_ROOT_PICKUP_CUSTODY_POINTER_20260523.md`.

Return trigger:
When pickup-lane reconciliation is selected, decide whether root `COMMAND_CENTER` remains a porch pickup lane, moves into active home, or is archived.

## A2. Repeated `$Home` / `$HOME` Reserved Variable Pattern

Finding:
Root receipt `CRISS_CROSS_PICKUP_PATH_REPAIR_RECEIPT_20260523_171803.txt` says a previous pickup used `$Home`, causing an output lane under the user profile instead of the active house.

Why it matters:
This repeats the PowerShell reserved-variable issue already covered by the issue latch.

Safe fix:
Captured as evidence and linked to runner/script lifecycle closeout. No script was run or edited.

Return trigger:
Before the next generated `.ps1` runner, apply reserved-variable preflight and used-runner lifecycle closeout.

## A3. Old Home Path Still In Authority-Adjacent Surfaces

Finding:
`README.md`, `CURRENT_TRUTH_INDEX.txt`, `AGENTS.md`, and MR_KLEEN teleporter files still name `C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz`.

Why it matters:
The active home is `C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz`; stale old-home path text can route work to a missing or historical home.

Safe fix:
Parked as Home Path Sync. No authority-adjacent rewrite was performed.

Return trigger:
User selects Home Path Sync candidate with explicit authority to edit scoped files.

## A4. Work Shed References Without Active Work Shed

Finding:
Work Shed reference hits remain high, while `HOUSE_WORK\WORK_SHED` does not exist in the active home. `.gitignore` excludes shed paths.

Why it matters:
TODO/status/proof files can point to absent lanes, making old Work Shed evidence look live.

Safe fix:
Parked as Work Shed Reference Reconciliation. No shed restoration was performed.

Return trigger:
User asks for Work Shed reference reconciliation or a selected TODO requires absent Work Shed evidence.

## A5. Local-Only Named Material Is Tracked

Finding:
122 tracked paths matched local-only/private/shed-like naming. No secret/token/password/key-like tracked paths were found by name scan.

Why it matters:
Local-only labels can disagree with Git tracking state.

Safe fix:
Parked as Local-Only Tracking Audit. No untracking or relabeling was performed.

Return trigger:
User selects Git/local-only lane cleanup.

## A6. Root-Level Tracked Helper / Support Files Need Role Review

Finding:
Root active-home tracked support files include:

- `cleanseed_phase1_sizefirst_triage.ps1`
- `LOCK_SAVE_PROBLEM_SOLVING_ORDER_LATCH_WITH_MULE_WORK_V1.ps1`
- `PROBLEM_SOLVING_ORDER_LATCH_WITH_FRESH_IDEAS_20260523.md`
- `NEOCITIES_DATA_FOLDER_CRAWL_20260512.txt`
- `Johnny-Clean-Seed.url`

Why it matters:
Some are helper/script/source-support shaped, but they are tracked root files. Moving them could be safe later, but blind movement would be a tracked-file restructure.

Safe fix:
Parked as Root Tracked Support File Role Review. No movement was done.

Return trigger:
User selects root file role review, or a script runner cleanup specifically includes tracked root helper files.

## A7. Support Indexes Correctly Warn That Current-Looking Text Can Be Historical

Finding:
`HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md`, TODO index, and TODO control board all say `ACTIVE_ANCHOR` or current user command selects live work.

Why it matters:
This is good material, but it also proves the house has many historical "current" word shapes that need interpretation.

Safe fix:
Preserved. Used as routing rule in this walkthrough.

Return trigger:
If a future work request uses old current-looking language, run support/current word-boundary check.

## A8. Prior Mule Whole-Home Packet Already Parked Several Unknowns

Finding:
`MULE_WORKSHOP\WHOLE_HOME_METATRON_PARK_MAP_RUN_20260523_000146` contains return-home ledgers, set-aside lists, and a final judge of REVIEW / NOT PASS.

Why it matters:
This is valuable evidence, but not authority. It should inform cleanup without commanding moves.

Safe fix:
Linked into the idea/scaffold consolidation.

Return trigger:
User asks to work the Metatron park-map return-home ledger or issue-review list.

## A9. Recent Root Issue Packet Was Saved Separately

Finding:
Commit `1eaadec` saved `MULE_WORKSHOP\ROOT_ISSUE_HISTORY_DIAGNOSIS_AND_FIX_20260523` separately. That matches the mule/assistant lane split rule.

Why it matters:
This is a success pattern: contractor-like packet saved separately from assistant/user progress.

Safe fix:
Preserved as success evidence.

Return trigger:
Use as template for future mule-workshop packet saves.

## A10. Duplicate Learning Lane Shape

Finding:
There is both `BRAIN_LEARNING` and at least one `BRAIN\LEARNING` path in the file list.

Why it matters:
This could be legitimate history or a lane split. It should not be collapsed without review.

Safe fix:
Parked as Learning Lane Split Review.

Return trigger:
User selects brain-learning lane cleanup or search shows active rules split between both lanes.

## A11. Fog Zone And Source Roundtable Need Preservation, Not Flattening

Finding:
Recent rules explicitly protect unproven and small-source material as Fog Zone / source roundtable input.

Why it matters:
Cleanup must not discard odd but useful material just because it is unproven.

Safe fix:
Preserved and linked into `IDEAS_AND_SCAFFOLDS_BROUGHT_TOGETHER.md`.

Return trigger:
When source-heavy notes are selected for use, run source custody plus evidence rating.

## A12. Bridge/Shed Restoration Stayed Out Of Scope

Finding:
Bridge and shed folders remain excluded by ignore patterns and prior user boundary. This walkthrough did not restore them.

Why it matters:
The system should not rebuild excluded lanes just because references exist.

Safe fix:
Reference-only treatment. No bridge/shed restoration.

Return trigger:
User explicitly opens a bridge/shed reconciliation task.
