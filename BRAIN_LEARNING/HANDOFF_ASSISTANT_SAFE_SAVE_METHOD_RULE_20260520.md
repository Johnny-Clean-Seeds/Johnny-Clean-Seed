# Handoff Assistant Safe Save Method Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE / HANDOFF SUPPORT.

## Purpose

Make the current safe save method portable to future handoff assistants.

A new handoff assistant must not relearn the same PowerShell delivery mistakes.

## Rule

For Mr.Kleen saves that require long PowerShell or multiple coordinated files, use the safe save method:

1. Use Code Cabinet / bridge method.
2. Prefer a downloadable ps1 file for long scripts.
3. Provide one run command.
4. Include process-scope execution-policy bypass for downloaded ps1 files.
5. Parser/lint check the ps1 before running when possible.
6. Keep chat prose out of PowerShell copy material.
7. Keep Markdown fence text out of PowerShell copy material.
8. Stop on the first error.
9. If failure happens before commit, do not rerun blindly.
10. Inspect dirty paths.
11. Allow only expected dirty paths.
12. Recover narrowly to receipt, commit, push, fetch, HEAD equals origin/main, and final clean status.

## Standard Run Command Shape

Use this shape for downloaded ps1 files:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $p="$env:USERPROFILE\Downloads\FILE.ps1"; $t=$null; $e=$null; [System.Management.Automation.Language.Parser]::ParseFile($p,[ref]$t,[ref]$e) | Out-Null; if($e.Count){$e | Format-List | Out-String | Write-Host; throw "Parser errors in downloaded script"}; & $p

## Why This Exists

This method exists because the repeated failure was delivery/lint/recovery, not Git.

Git repeatedly proved clean when the final guarded proof ran.

The weak link was sending/running long PowerShell safely.

## Handoff Requirement

Every new handoff assistant working in Mr.Kleen must know:

- long scripts use Code Cabinet;
- delivery must be linted before send;
- downloaded ps1 gets process-scope bypass run command;
- parser check should happen before execution when possible;
- partial dirty state requires narrow recovery, not rerun;
- final proof must include commit, HEAD, origin/main, and status clean.

## Boundary

This rule does not install doctrine.

This rule does not rewrite active guides.

This rule does not rewrite CURRENT_TRUTH_INDEX.

This rule does not create automation.

This rule does not create runtime.

This rule does not promote scripts to tools.

It is a handoff/save-method safety rule.

---

## 2026-05-20 - Downloaded ps1 Resolver and Source Validation Patch

Downloaded ps1 commands must resolve the file before parser-checking.

Do not assume the file is only at Downloads with an exact filename.

Use a resolver that searches expected locations and accepts browser-renamed copies such as (1).

Save scripts should not use brittle exact-text checks against existing source files.

Source file checks should prove custody/readability/nonempty/no obvious corruption.

Exact text checks should be reserved for artifacts created or patched by the current script.
