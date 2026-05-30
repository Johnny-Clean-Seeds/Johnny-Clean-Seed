# Helper Script Generation Safe Primitives Template V1

Date: 2026-05-30
RunId: 20260530_092451
WorkKey: HELPER-GENERATOR-BASE-LAYER-GUARD-20260530
Status: TEMPLATE / READ-PATTERN-ONLY / NOT AUTHORITY

## Purpose

This is a small pattern source for future generated helpers. It is not a runnable helper by itself and does not skip Code Gate.

## Safe line collection

Prefer simple arrays for generated report/hash lines when mutation-by-reference is not required. This avoids null/empty collection binder traps.

~~~~powershell
$ReportLines = @()
$ReportLines += '# Report title'
$ReportLines += ''
$ReportLines += "Key: $Key"
~~~~

If a mutable list is required, initialize it directly at the call site and do not mark it with a binding shape that rejects empty/null state during repair routes.

~~~~powershell
$ReportLines = [System.Collections.Generic.List[string]]::new()
[void]$ReportLines.Add('# Report title')
~~~~

## Safe command-output operator handling

~~~~powershell
$raw = Invoke-SomeCommand
$lines = @($raw -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
~~~~

## Safe naming

Use names like `$FindingRows`, `$PatternRows`, `$ReportLines`, `$GitArguments`, `$NativeArguments`.

Do not use `$Matches`, `$Pid`, `$Args`, or `$Input` for your own values.

## Save-order rule

Content files first. Manifest second. Receipt third. Stage exact files. Verify staged set. Commit. Push. Verify origin match. Verify clean status.
