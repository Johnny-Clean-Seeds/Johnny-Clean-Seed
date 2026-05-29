# TODO — House File Toolbox V3.3 Supervisor Incremental Build — 2026-05-29

## Status

Type: incremental build TODO.

Purpose: work toward the locked supervisor architecture without trying to install the whole system at once.

## Phase 1 — Skeleton

- [ ] Create HOUSE_FILE_TOOLBOX_V3.3_SUPERVISOR.ps1.
- [ ] Create HOUSE_FILE_TOOLBOX_V3.3_SUPERVISOR.cmd.
- [ ] Create ToolHome bootstrap.
- [ ] Create output root:

  C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\HOUSE_FILE_TOOLBOX_V3_3

- [ ] Create child folders:

  - ACTION_MANIFESTS
  - ACTION_RESULTS
  - FAILSAFE_LEDGER
  - RECOVERY_CARDS
  - WINDOW_REGISTRY
  - TRANSCRIPTS
  - REVIEWS
  - INDEXES
  - CODE_INTAKE
  - RECEIPTS
  - COMMAND_CARDS

- [ ] Create CURRENT_TOOLBOX_STATE.json.

## Phase 2 — Manifest and one safe action

- [ ] Implement action manifest writer.
- [ ] Implement runner result object.
- [ ] Implement latest mule-style review build/open action.
- [ ] Implement watcher close-standard check for review action.
- [ ] Track Notepad PID if opened.
- [ ] Add cleanup menu to close toolbox-opened windows with confirmation.

## Phase 3 — Recovery ladder seed

- [ ] Implement failure card writer.
- [ ] Implement MISSING_TOOL_HOME.
- [ ] Implement MISSING_ENGINE_NEXT_TO_CMD.
- [ ] Implement WRONG_LAUNCH_SURFACE.
- [ ] Implement OUTPUT_PASTED_AS_COMMAND.
- [ ] Implement DUPLICATE_COMMAND_CONCAT.
- [ ] Implement REPORT_EXISTS_BUT_NOT_READ.

## Phase 4 — Wash/report integration

- [ ] Add Quick wash manifest.
- [ ] Add Deep wash manifest.
- [ ] Add Heavy wash manifest.
- [ ] Add Custom wash manifest.
- [ ] Build/open review after wash.
- [ ] Open ledgers and telemetry from Browse / Inspect.

## Phase 5 — Code Intake / Code Gate

- [ ] Code intake to local READY_FOR_CODE.
- [ ] Hash and manifest selected code file.
- [ ] Run Code Gate on selected PowerShell.
- [ ] Open Code Gate report.
- [ ] Save result card locally.

## Phase 6 — Git Save

- [ ] Show dirty state using git status --porcelain.
- [ ] Select exact files.
- [ ] Build Git save manifest.
- [ ] Verify staged set exactly.
- [ ] Commit/push/verify clean.
- [ ] Block folder and wildcard force-add.

## Phase 7 — Proof and lock

- [ ] Code Gate parser/probe.
- [ ] .cmd ToolHome repair proof.
- [ ] Menu open from ToolHome.
- [ ] Action manifest before action proof.
- [ ] Review open proof.
- [ ] Window registry proof.
- [ ] Cleanup confirmation proof.
- [ ] Simulated missing-report failure card proof.
- [ ] Git Save menu no-op/status proof.
- [ ] Only then lock/save V3.3 proof.

## Carry rule

Keep working toward the supervisor design even if only one room is added per pass.

Do not regress to flat menu growth.