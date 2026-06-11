# Helper Script Generation Base Layer Guard

Date: 2026-05-30
RunId: 20260530_092451
WorkKey: HELPER-GENERATOR-BASE-LAYER-GUARD-20260530
RuleKey: HELPER-SCRIPT-GENERATION-BASE-LAYER-GUARD-V1-2
Status: BRAIN LEARNING / LOWER-LAYER HELPER GENERATION GUARD / NOT DOCTRINE

## Why this exists

V1.2 repair note: V1 direct run exposed a lower-level Git status collection-shape failure after a mashed operator command. V1.1 normalized Git status results with array wrapping before Count checks. V1.2 repairs a second lower-layer report/hash-line collection failure and accepts only the expected partial footprint left by the failed V1.1 route before resuming.

The lower-level breadcrumb chain showed that several failed runs were not failures of the upper task. They were failures in the helper/script-generation base layer.

The trail included PowerShell parser failures, markdown backtick string failures, Sort-Object argument composition, automatic `$Matches` variable collision, Add-Line empty-collection binding, operator-binding ambiguity, manifest-before-manifest save order, and command-surface paste noise.

The correct response is not to patch each upper task until it passes. The correct response is to freeze the upper task, identify the lower failing mechanism, repair the shared generator layer, prove the helper route, then resume.

## Rule

Generated helper scripts must use safe base-layer primitives before task-specific logic.

The assistant must not generate a helper that relies on fragile report-writing, ambiguous PowerShell binding, reserved variable names, markdown backtick fences inside double-quoted strings, manifest or receipt auditing before those files exist, or Code Gate probe PASS as a substitute for actual target/job proof.

## Required generator standards

1. Report lines use a safe append primitive.
2. No mandatory non-empty collection binding for an initially empty output list.
3. Do not name user variables `$Matches`, `$Pid`, `$Args`, `$Input`, or other automatic/reserved PowerShell variables.
4. Do not put markdown backtick fences inside PowerShell double-quoted strings.
5. Prefer tilde fences or single-quoted here-strings for report blocks.
6. Precompute command output into variables before applying operators such as -split or -replace.
7. Use variable-first operator handling.
8. Write content files before writing the manifest.
9. Write the manifest before writing the receipt.
10. Stage exact files only, then verify the staged set.
11. Treat Code Gate PASS as parser/run proof only, not job authority.
12. If Code Gate runs a probe path, the direct path still needs proof.
13. If the direct path reaches a branch not exercised by probe, failure there is a lower-layer breadcrumb candidate.
14. If a helper fails three times in adjacent lower-layer shapes, stop making one-off helpers and inspect the generator pattern.

## Safe report primitive pattern

Use a mutable string-list and an append helper that accepts empty state and null text.

~~~~powershell
function New-StringList {
    return [System.Collections.Generic.List[string]]::new()
}

function Add-ReportLine {
    param(
        [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Lines,
        [AllowNull()][string]$Text
    )
    if ($null -eq $Text) { $Text = '' }
    [void]$Lines.Add($Text)
}
~~~~

## Unsafe patterns to block

- `$linesOut.Add()` through a wrapper that rejects empty collections.
- `$matches = ...` as a normal variable name when the script also uses -match.
- `Invoke-Something ... -split ...` without parenthesizing or precomputing.
- Markdown backtick fences inside PowerShell double-quoted strings.
- Manifest or receipt included in a candidate-hash loop before that file exists.
- Probe-only PASS treated as direct-save proof.
- A direct save rerun after a lower-layer failure without a repaired version.
- Broad audit triggered by a triage report without exact scope.

## Breadcrumb connection

This guard grows from the lower-level freeze rule and the breadcrumb chain summary. It is the next lower-layer object, not a broad audit and not implementation.

## Boundary

This is support behavior and generation discipline. It does not authorize broad audit, full batch, autonomous generation, implementation, watcher, automation, Whirlpool, doctrine promotion, ACTIVE_GUIDES rewrite, or CURRENT_TRUTH_INDEX rewrite.
