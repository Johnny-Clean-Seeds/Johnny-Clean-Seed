# PowerShell Code Gate / Parse-First Runner Rule
Date: 20260527

## Status

Type: generated-code safety rule / PowerShell execution gate.

This is not doctrine.
This is not ACTIVE_GUIDES material.
This is not CURRENT_TRUTH_INDEX material.
This is not delete authority.
This is not repo authority by itself.
This is not proof replacement.
This is not a universal automation engine.

## Purpose

Prevent generated PowerShell from reaching the user before it has passed a structured code-read gate.

The visible wound was repeated parser/runtime failure in generated PowerShell. The parent problem is broader:

Generated executable material was reaching the user before syntax, risk, execution, and proof boundaries were checked.

## Core rule

Generated PowerShell must pass Code Gate before user execution unless it is a visibly trivial one-line command.

Short form:
Parse first. Run second. Save third.

## Gate layers

Layer 1: Syntax Parse Gate.
Use PowerShell's parser before execution. Parser FAIL means no run.

Layer 2: Style / Fragility Gate.
Watch fragile generated-script patterns, including dense inline command calls, inline if subexpressions inside long calls, return array wrappers, stacked parentheses, and clever one-liners that are hard to inspect.

Layer 3: Risk-Class Gate.
Classify the script before run. Read-only report scripts are lower risk. Local file creation scripts need report lanes. Repo save scripts need save route. Move, delete, network, system, registry, service, scheduled-task, security, or environment-changing scripts need explicit lane approval.

Layer 4: Execution Gate.
Only after syntax and risk pass, run the target. Capture stdout, stderr, exit code, target status, and report path.

Layer 5: Job Proof Gate.
Code Gate PASS means safe enough to run. It does not mean the target job passed. Save scripts still need commit, push, HEAD equals origin/main, and final clean status. Checkers still need failed/watch counts. Move scripts need before/after inventory. Delete scripts need separate approval and proof.

Layer 6: Residue / Root-Slop Gate.
Generated helper scripts and reports must not pile in Desktop\123 root. Reports go to _MISC_DRAWER\READ_REPORTS. Test fixtures and code candidates go under _MISC_DRAWER\READY_FOR_CODE or a stable local tools folder.

## Warning policy

Parser FAIL:
Never run.

Parser PASS with style warnings only:
Allowed for read-only/report scripts.

Parser PASS with Git-write detection:
Block unless the save lane is selected and explicit allow is used.

Parser PASS with move/delete/network/system detection:
Block unless that lane is explicitly selected and approved.

Target exit code 1 with PASS WITH WATCH output:
Treat as watch, not generic failure.

Target says PASS without required proof:
Not job PASS. Proof gate decides.

## Required generated PowerShell style

Do not generate dense inline function calls with nested subexpressions when they can be avoided.

Avoid this shape:
Add-Check plus inline if/subexpression plus nested parentheses in one command.

Use this shape instead:

1. compute Ok;
2. compute Verdict;
3. compute Evidence;
4. call the function with named parameters.

This is less clever and more inspectable.

## Bootstrap rule

The Code Gate runner itself must pass parser check before it is trusted.

Do not hand the user an unchecked checker as if it were proof.

## Local tool

Current proven local runner:
POWERSHELL_CODE_GATE_RUNNER_V1.3.ps1

Recommended local home:
Documents\Tools\PowerShellCodeGate

Reports:
Desktop\123\_MISC_DRAWER\READ_REPORTS

Test fixtures:
Desktop\123\_MISC_DRAWER\READY_FOR_CODE

## Boundaries

Blocked:

- no parser-failing target execution;
- no generated multi-line PowerShell without Code Gate unless visibly trivial;
- no Git-write auto-run without explicit save lane and allow;
- no delete/move/network/system auto-run without explicit lane approval;
- no parser PASS treated as job PASS;
- no root slop;
- no proof/source/receipt burning;
- no ACTIVE_GUIDES rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no doctrine promotion;
- no mule rule change.

## Proof basis

The runner blocked known broken parser fixtures.
The runner allowed read-only/report scripts after parser pass.
The runner blocked fake Git-write and fake delete scripts without allow.
The test ladder passed core safety with one expected WATCH.
The expected WATCH was the false-PASS fixture proving Code Gate PASS is not job PASS.
Runner V1.3 correctly recognized child PASS WITH WATCH instead of treating exit code 1 as generic failure.

## Final short form

Parse first.
Run second.
Save third.
Code Gate PASS is not job PASS.
