# Problem Solver Sweep + Single-Boss Collapse Card — 20260521

## Call This Card When

A task hits an issue and the assistant starts to drift into broad analysis or multiple fixes.

## Collapse Sentence

The active blocker is one thing. Solve that one thing first.

## Route

Issue -> root cause -> prevention stack -> smallest patch -> test -> proof -> return to original task.

## Blocks

Do not add unrelated infrastructure.

Do not make multiple repair artifacts.

Do not convert a one-line bug into a full subsystem unless selected.

Do not continue without proof.

## Current Proven Pattern

PowerShell $PID collision in watcher route:

Patch variable names.

Rerun watcher self-test.

Save proof.

Return to Child Shell route.
