# Hash-Key Front Gate Save Split Operator Failure Power-Play

Status: FAILURE POWER-PLAY / FIXED IN V1.2 ROUTE
Authority: sorting-bench evidence and helper learning, not doctrine

## What happened

The V1 save route passed Code Gate probe, then failed during `-AllowGitWrites` after planned files were written and staged.

Error:

`A parameter cannot be found that matches parameter name 'split'.`

Failing shape:

`Invoke-Git -GitArgs @('diff','--cached','--name-only') -split "`n"`

## What was falsely blamed

- not the user;
- not learning_material.txt;
- not the hash-key front gate idea;
- not ignored WORK_SHED paths;
- not the Git wrapper argument list;
- not Code Gate parser failure.

## Root cause

The script tried to apply `-split` directly after a function call with named parameters. PowerShell parsed it as another parameter to `Invoke-Git`.

## Fix

Capture the Git output into a variable first, then split the text:

`$stagedRaw = Invoke-Git -GitArgs @('diff','--cached','--name-only')`
`$staged = @($stagedRaw -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() })`

## Learning

This is a powerplay, not a dead-end problem. The helper now gains a rule: proof-critical command output gets captured, named, then transformed. No dense inline command/operator chain in save verification.

## Reopen trigger

Reopen this event if a generated helper fails because an operator was parsed as a command parameter or a command-output transform was embedded too densely in a proof path.