# RUNNER HARNESS V1.1 — START HERE

Purpose:
Run future jobs as files, not pasted console blocks.

Core shape:
BOOTSTRAP -> PARENT RUNNER -> CHILD JOB -> CHILD SENTINEL -> PARENT RECEIPT -> FILE READBACK

Use:
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File ".\RUN_FILE_FIRST_JOB_V1_1.ps1" -JobScript "<child job.ps1>" -JobName "<name>" -OutputRoot "<report folder>" -TimeoutSeconds 60

Child job contract:
- Accept param([string]$RunId, [string]$RunDir)
- Write CHILD_STARTED_<RunId>.json
- On success write CHILD_COMPLETE_<RunId>.json with Status COMPLETE and RequiresKeyboardInput false
- On known failure write CHILD_FAILED_<RunId>.json
- Exit with code 0 for success, nonzero for failure
- Never require keyboard input

Status meanings:
PASS = child exited 0 and complete sentinel exists.
FAIL = child exited nonzero, missing complete sentinel, or bad complete sentinel.
HUNG = child did not exit before timeout and parent killed it.

Boundary:
No watcher.
No automation service.
No commit.
No delete.
No move.
No doctrine promotion.
