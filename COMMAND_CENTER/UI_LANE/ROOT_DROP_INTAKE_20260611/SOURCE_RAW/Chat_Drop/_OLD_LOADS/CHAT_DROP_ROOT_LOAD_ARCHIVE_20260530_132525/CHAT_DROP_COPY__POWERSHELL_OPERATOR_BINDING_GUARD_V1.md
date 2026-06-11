# PowerShell Command Output Operator-Binding Guard

Date: 2026-05-30
Status: BRAIN LEARNING / SCRIPT-GENERATION GUARD / NOT DOCTRINE
WorkKey: MAX8-20260530-BATCH-SCALE-STEP-AUDIT
RepairKey: POWERPLAY-CRIME-SCENE-20260530-MAX8-V1-OPERATOR-BINDING-REPAIR
GuardKey: POWERSHELL-OPERATOR-BINDING-SPLIT-GUARD-20260530
SourceBase: origin/main @ b4a05a3a7eb9162b52ad6cdd98cfe71455d0e7d2

## Exposure

MAX8 V1 failed after Code Gate probe passed because a command invocation was followed directly by -split:

Invoke-Git -Args @('diff','--cached','--name-only') -split ...

PowerShell parsed -split as a parameter to Invoke-Git, not as the split operator on the returned string.

## Rule

Generated PowerShell must not apply -split, -replace, or similar operators directly to a command/function invocation unless the invocation is explicitly parenthesized.

Preferred generated-script pattern:

`powershell
$raw = Invoke-Git -Args @('diff','--cached','--name-only')
$lines = @($raw -split "`r?`n" | Where-Object { ![string]::IsNullOrWhiteSpace($_) })
`

Best house pattern: variable first, operator second.

## Why

This prevents parser/binder ambiguity and avoids false confidence from Code Gate probe-only runs when a later direct save reaches a branch that was not exercised in the same way.

## Boundary

This is a script-generation guard and repair lesson. It does not authorize broad cleanup, automation, watcher, implementation, full batch, Whirlpool, doctrine, ACTIVE_GUIDES, or CURRENT_TRUTH_INDEX.