# Freshen' up Internal Rule Git Wrapper `$Args` Failure Power Play

## Status
Open issue closed by V1.1 only if Git save, push, remote verification, and final clean status pass.

## Failure
The user ran:

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\LOCK_SAVE_FRESHEN_UP_INTERNAL_ORIENTATION_AND_FILE_RULE_V1.ps1" -AllowGitWrites
```

The script failed at line 49:

```text
GIT_FAILED: git  usage: git [-v | --version] ... <command> [<args>]
```

## What this means
The script did not fail because the rule idea was bad.

The script did not fail because Code Gate missed parser syntax.

The script failed because the write-mode Git wrapper reached bare `git` with no subcommand.

## Root cause classification
Failure family: helper Git wrapper argument-list/control-variable error.

Likely cause: using `$Args` as the wrapper parameter name or argument source, colliding with PowerShell automatic/positional argument behavior and causing the intended argument list not to reach the native `git` call.

## New fix
V1.1 uses:

```powershell
function Invoke-Git {
    param([Parameter(Mandatory=$true)][string[]]$GitArgs)
    if($null -eq $GitArgs -or $GitArgs.Count -eq 0){ throw 'GIT_ARGS_EMPTY_BLOCKED: refusing to run bare git.' }
    $out = & git -C $RepoRoot @GitArgs 2>&1
}
```

## Evidence to keep
- Code Gate probe passed for V1 before write mode.
- Write mode failed during Git wrapper execution.
- The failure output printed bare `git` usage.
- V1.1 repairs the wrapper and records the failure in files before retrying.

## Closure condition
Closed only when V1.1 commits, pushes, verifies `HEAD == origin/main`, and final status is clean.

## Reopen trigger
Reopen if any future helper/save script prints bare `git` usage, loses its Git argument list, stages ignored files without exact force-add, or claims saved without remote/clean proof.