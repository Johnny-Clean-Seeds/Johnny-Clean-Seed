# Save Script Pipeline Output Split Rule

Status: SUPPORT RULE / HELPER ISSUE LEARNING
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX

## Trigger

Use this when a PowerShell helper captures output from a function/native command and then immediately tries to split or transform it.

## Failure learned

The failed V1 save script used this dirty shape:

`Invoke-Git -GitArgs @('diff','--cached','--name-only') -split "`n"`

PowerShell treated `-split` as a parameter to `Invoke-Git`, not as the split operator applied to the returned output.

## Correct shape

Capture output first, then transform it:

`$cachedText = Invoke-Git -GitArgs @('diff','--cached','--name-only')`
`$staged = @($cachedText -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() })`

or parenthesize the command output before applying an operator.

## Rule

Do not chain PowerShell operators directly after function/native command parameters when the operator could be parsed as another command parameter.

Use named intermediate variables for proof-critical native output.

## Why this matters

Staged-set verification, receipt parsing, hash checks, and status checks must not fail because transformation code was parsed as a fake parameter.

## Living ledger behavior

This was not a problem to hide. It was a power-play learning event: parser/probe was clean, write mode exposed a proof-route weakness, and the save helper now learns to separate command capture from output transformation.