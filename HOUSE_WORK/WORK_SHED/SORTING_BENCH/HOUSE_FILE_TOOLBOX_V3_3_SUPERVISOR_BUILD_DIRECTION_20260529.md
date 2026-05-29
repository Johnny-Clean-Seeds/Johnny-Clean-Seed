# House File Toolbox V3.3 Supervisor Build Direction — 2026-05-29

## Status

Type: build direction / progress lock.

Object: HOUSE_FILE_TOOLBOX_V3.3_SUPERVISOR.

This file locks the design target and build path. It does not claim the supervisor exists yet.

## Why this is needed

Recent toolbox work exposed several repeated failure shapes:

- missing or wrong launch path;
- menu/output text pasted into PowerShell as commands;
- repeated command concatenation;
- report existed but had not been read;
- review builder printed UNKNOWN fields while raw report had the values;
- skipped/non-text rows were too close to being misread as rough spots;
- Git save wrappers grew vine/branch failures when Git ignore/status interpretation was allowed to steer staging.

The fix is a supervisor system, not another flat menu.

## Target architecture

`
BOOTSTRAP
  -> PREFLIGHT
  -> FRONT DOOR / MENU
  -> ACTION MANIFEST
  -> RUNNER
  -> WATCHER
  -> RECOVERY LADDER
  -> REPORT / VIEWER
  -> WINDOW CLEANUP
  -> LEARNING LEDGER
  -> NEXT SUGGESTED ACTION
`

## Rooms to preserve

### 1. Bootstrap Room

Creates or repairs:

- C:\Users\13527\Desktop\file tools
- local .cmd launcher;
- local .ps1 engine;
- output folders;
- command cards;
- bootstrap receipt.

The .cmd owns missing .ps1 repair because a missing script cannot repair itself after PowerShell fails to load it.

### 2. Preflight Room

Checks:

- ToolHome exists;
- repo root exists;
- washer exists;
- Code Gate runner exists;
- output root exists;
- launch surface is clean;
- old failed action exists;
- tracked toolbox-owned windows exist;
- dirty repo only if Git save is selected.

### 3. Menu Room

The menu is only a selector.

Groups:

- Wash / Report
- Browse / Inspect
- Index / Transcript
- Code Intake / Code Gate
- Git Save
- Settings / Repair
- Recovery / Resume

Top-level recovery entries should include:

- Resume last failed action
- What happened last?
- Open latest failure card
- Write clean command card
- Repair ToolHome and relaunch
- Close toolbox-opened windows

### 4. Action Manifest Room

Every nontrivial action writes manifest JSON first.

Required fields:

- ManifestVersion
- ActionId
- ActionName
- RequestedBy
- CreatedAt
- ToolVersion
- ToolHome
- RepoRoot
- Mode
- Root
- Inputs
- Parameters
- ExpectedOutputs
- AllowedReads
- AllowedWrites
- AllowedGitFiles
- GitAllowed
- ViewerAction
- WindowCleanupPolicy
- RecoveryLadder
- CloseStandard
- Boundary
- Status

### 5. Runner Room

Runner types:

- Run-WashAction
- Run-ReviewBuildAction
- Run-IndexAction
- Run-TranscriptPackAction
- Run-CodeIntakeAction
- Run-CodeGateAction
- Run-GitSaveAction
- Run-OpenViewerAction
- Run-RepairAction

Every runner returns structured result data.

### 6. Watcher Room

The watcher checks the action close standard.

It must not rely only on console output.

### 7. Recovery Ladder Room

Known failure classes to install first:

- MISSING_TOOL_HOME
- MISSING_ENGINE_NEXT_TO_CMD
- WRONG_LAUNCH_SURFACE
- DUPLICATE_COMMAND_CONCAT
- OUTPUT_PASTED_AS_COMMAND
- CODE_GATE_PROBE_ONLY
- REPORT_EXISTS_BUT_NOT_READ
- RAW_REPORT_THIN
- SKIP_MISREAD_AS_ROUGH
- GIT_DIRTY_BEFORE_SAVE
- IGNORED_PATH_STAGING
- OPEN_WINDOW_RESIDUE
- POPUP_AFTER_ACTION

Each class should have:

- Detect
- Explain
- Recover
- Verify
- NextAction

### 8. Learning Ledger Room

The learning ledger records local failure/recovery patterns.

It is not doctrine.

Each card should include:

- PatternId
- FirstSeen
- LastSeen
- SourceActionId
- TriggerText
- DetectedClass
- Cause
- RecoveryUsed
- RecoveryPassed
- RecoveryFailed
- NextTimeRoute
- Confidence
- HumanNote
- DoNotAutoRun
- PromoteToKnownFailure

### 9. Window Manager Room

The toolbox records only windows it opens.

Fields:

- PID
- ProcessName
- FileOpened
- Purpose
- OpenedAt
- ActionId
- CanAutoClose
- RequiresConfirmBeforeClose

Notepad close must be user-confirmed unless explicitly allowed.

### 10. Transcript / Console Capture Room

Action transcripts may be captured per action, not as endless shell noise.

### 11. Wash / Report Room

Uses saved Source Wash V1.3 controller.

Every wash should offer:

- build/open mule-style review;
- open raw report;
- open decision ledger;
- open rough/skip ledger;
- open governor telemetry;
- open run folder.

### 12. Mule Review Room

Required sections:

- Verdict
- Boundary
- Run Proof Summary
- File Mix
- Role Counts
- Decision Counts
- Governor Behavior
- Skip vs Rough Interpretation
- Parked Review Items
- Code Pattern Items
- Boundary/Authority Items
- Source Ore Items
- What The House Said
- What To Inspect Next
- What Not To Claim
- Next Clean Moves

### 13. Index / Transcript Room

Outputs should include:

- ALL_FILES_INDEX.csv
- ALL_FILES_INDEX.md
- TRANSCRIPT_PACK.md
- TRANSCRIPT_MANIFEST.json

### 14. Code Intake Room

Handles code upload/prep.

Default local lane:

C:\Users\13527\Desktop\123\_MISC_DRAWER\READY_FOR_CODE

### 15. Code Gate Room

Wraps existing Code Gate and opens report.

Still: Code Gate PASS is not job PASS.

### 16. Git Save Room

Locked exact-file manifest workflow only.

Sequence:

show porcelain status -> select exact files -> build save manifest -> dry-run staged set -> confirm -> stage exact files -> verify staged set -> commit -> push -> verify HEAD equals origin/main -> verify clean.

### 17. Settings / Repair Room

Must include:

- install/repair ToolHome;
- open ToolHome;
- open output folder;
- open fail-safe ledger;
- open latest failure card;
- write clean command card;
- close toolbox-opened windows;
- reset Git Save Mode OFF;
- show current config.

### 18. Status / Current State Room

Maintain:

CURRENT_TOOLBOX_STATE.json

## Build stance

This is a north-star build target.

Do not try to build all rooms in one fragile pass.

Start with the smallest supervisor skeleton that proves:

1. bootstrap ToolHome;
2. action manifest creation;
3. one safe action runner;
4. one watcher;
5. one failure card;
6. one recovery route;
7. one window registry entry;
8. one cleanup option.

Then grow.

## Boundary

This is a build direction and progress lock only.

No doctrine promotion.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No automation.

No dashboard.

No broad file move/delete.

No Git save except exact-file manifest save for this lock.