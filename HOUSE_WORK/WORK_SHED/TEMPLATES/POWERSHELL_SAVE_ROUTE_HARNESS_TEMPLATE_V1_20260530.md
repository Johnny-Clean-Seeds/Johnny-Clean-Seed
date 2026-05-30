# PowerShell Save Route Harness Template V1

Date: 2026-05-30
Status: TEMPLATE / SAVE-ROUTE LOWER-LAYER HARNESS / NOT DOCTRINE
WorkKey: LOWER-LAYER-SAVE-ROUTE-HARNESS-ROOT-REPAIR-20260530-V1-2-1

## Purpose

Use this shape for future generated PowerShell save scripts before custom save bodies are written.

## Required mechanics

### Param block

The `param(...)` block must be first, except comments/attributes.

### Error settings

Use:

```powershell
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
```

### String safety

Avoid:

```powershell
"Missing $Label: $Path"
```

Use:

```powershell
("Missing {0}: {1}" -f $Label, $Path)
```

or:

```powershell
"Missing ${Label}: $Path"
```

### Automatic-variable guard

Do not use these as custom parameter or local variable names:

`$Args`, `$Input`, `$Error`, `$Host`, `$PID`, `$PSItem`, `$This`, `$Matches`, `$MyInvocation`, `$PSBoundParameters`.

### Git wrapper

Use:

```powershell
function Invoke-Git {
    param([string[]]$GitArgs)
    $out = & git -C $RepoRoot @GitArgs 2>&1
    $code = $LASTEXITCODE
    [pscustomobject]@{
        Code = $code
        Text = (($out | Out-String).Trim())
    }
}
```

### Probe/direct rule

Probe mode may prove parser and read-only path only.

Direct save proof must still prove:

- intended branch ran;
- exact footprint staged;
- commit succeeded;
- push succeeded;
- HEAD equals origin/main;
- final status clean.

### Dirty-state recovery

If a prior failed run left dirty/staged paths:

1. read status;
2. read staged files;
3. read unstaged files;
4. require exact known footprint;
5. block unknown dirty paths;
6. consume or stop;
7. do not reset/delete/clean unless explicitly selected.

### Staged-set verification

Do not compare staged files to all intended/touched files.

Correct test:

- every actual staged path is allowed;
- every required changed file is staged;
- unchanged already-correct files may be absent.

### Receipt order

1. Write content.
2. Write manifest of content identities and allowed footprint.
3. Write preliminary receipt.
4. Stage exact files.
5. Commit.
6. Push.
7. Verify HEAD equals origin/main.
8. Verify clean status.
9. Finalize receipt.
10. Amend receipt only if needed and re-verify.

## Boundary

Template only. No automation, watcher, broad refactor, delete, move, Whirlpool, doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, universal mapper, graph database, or whole-house crawl.