# PowerShell Collection Shape / Count Guard

Date: 2026-05-30
Status: BRAIN LEARNING / SAVE-ROUTE GUARD / NOT DOCTRINE
WorkKey: LOWER-LAYER-SAVE-ROUTE-HARNESS-ROOT-REPAIR-20260530-V1-2

## Rule

Generated PowerShell must normalize command/list results to arrays before using `.Count`.

## Why

PowerShell may collapse function output into `$null` or a scalar object when there are zero or one results. Under strict mode, calling `.Count` on the wrong shape can fail.

## Correct pattern

Use array wrappers at the call site:

```powershell
$staged = @(Get-GitNameList -GitArgs @('diff','--cached','--name-only'))
$unstaged = @(Get-GitNameList -GitArgs @('diff','--name-only'))
```

When returning arrays from helper functions, use unary comma for array return when needed:

```powershell
return ,@($items)
```

## Need-to-know helper impact

- PowerShell generator: normalize list outputs.
- Git/save helper: all staged/unstaged/status collections are arrays.
- Code Gate lane: parser PASS does not prove collection-shape behavior unless the branch runs with representative data.

## Boundary

Save-route guard only. No broad refactor, delete, move, watcher, automation, Whirlpool, doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, universal mapper, graph database, or whole-house crawl.