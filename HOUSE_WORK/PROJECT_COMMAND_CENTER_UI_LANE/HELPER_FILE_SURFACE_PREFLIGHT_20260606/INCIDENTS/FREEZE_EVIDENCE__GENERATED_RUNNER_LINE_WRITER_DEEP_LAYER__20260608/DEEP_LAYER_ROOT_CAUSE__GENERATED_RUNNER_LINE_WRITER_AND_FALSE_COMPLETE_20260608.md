# DEEP_LAYER_ROOT_CAUSE__GENERATED_RUNNER_LINE_WRITER_AND_FALSE_COMPLETE_20260608

Status: DEEP_LAYER_ROOT_CAUSE / GENERATED_RUNNER_TEMPLATE_DEFECT / FALSE_COMPLETE_GUARD_REQUIRED

Created: 2026-06-08 17:58:07

Root cause family:

GENERATED_RUNNER_LINE_WRITER_DEFECT

Pattern:
Generated PowerShell helpers used functions such as Add-Line or Write-Utf8File with parameters that reject empty collections or empty strings. Then the generated code called those functions with empty or unresolved content.

Symptoms:
- Cannot bind argument to parameter 'Lines' because it is an empty collection.
- Cannot bind argument to parameter 'Lines' because it is an empty string.
- Report/file generation fails before closeout.
- Repair runner repeats the defect because the broken pattern exists in the generator shape, not just one script.

Second root cause family:

FALSE_COMPLETE_AFTER_BLOCKER

Pattern:
A blocker occurred, but the remaining pasted commands continued in the interactive shell. Because variables were null or empty, later Git commands failed, but the final status line still printed a success verdict.

Symptoms:
- BLOCKER_NO_GIT_WORKTREE was real.
- GitTop was null.
- git -C calls failed.
- files_committed_count was 0.
- commit_hash was empty.
- final verdict still claimed committed.

Required fix pattern:

01 Use one safe text writer:
[System.IO.File]::WriteAllText(path, text, UTF8 without BOM)

02 Do not require non-empty Lines arrays for file writing.

03 Build text as a here-string or one string, not as a mandatory array parameter.

04 If a blocker is hit, write a blocker report and Exit 1.

05 Never print final_verdict: COMMITTED unless:
- Git worktree exists.
- exact files are verified.
- exact staged set matches expected.
- git commit exits 0.
- rev-parse HEAD returns a non-empty commit hash.

06 If running in a pasted interactive shell, do not continue after blocker text. Use packaged runner scripts for multi-step operations.

07 Freeze evidence before fix every time.

Updated rule:
When a helper file or generated runner fails, investigate deeper-layer causes: generator template, parameter pattern, path assumption, stale helper, authority mismatch, or false-complete reporting. Capture the deeper layer in the freeze evidence and closeout.

DoesNotProve:
This root-cause report does not by itself fix Git, create a commit, approve source mutation, approve cleanup, or prove future runners are safe. It defines the defect family and the required guard pattern.