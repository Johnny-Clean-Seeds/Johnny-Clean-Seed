# PowerShell Copy Delivery Lint / Script Execution Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Parent Boss

Rule Activation / Work-Order Control.

## Problem

PowerShell command-safety failures repeated after the paste guard existed.

The failure was no longer only false PASS.

The active weak link was delivery:

- prose got pasted into PowerShell;
- Markdown code-fence markers got pasted into PowerShell;
- a downloaded ps1 file was blocked by execution policy until a process-scope bypass command was used.

## Rule

Before sending PowerShell or long code for the user to run, the assistant must choose a delivery form and lint it.

## Allowed Delivery Forms

### 1. One-line command

Use when the task is simple.

The line must contain only executable PowerShell.

No prose.

No Markdown fences.

### 2. Code-only block

Use only when the user is expected to copy the block from ChatGPT.

The block content must be PowerShell only.

No intro sentence inside the block.

No trailing instruction inside the block.

No Markdown fence text should be copied by the user.

### 3. Downloaded ps1 file plus run command

Use when the script is long.

Provide the file as an artifact.

Give one run command.

For downloaded ps1 files on this machine, include process-scope execution-policy bypass in the run command:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & "$env:USERPROFILE\Downloads\FILE.ps1"

## Required Lint Before Sending

Check:

1. Is there any prose inside the code?
2. Is there any Markdown fence text that the user may paste into PowerShell?
3. Is the block too long for safe chat copy?
4. Should this be a downloadable ps1 instead?
5. If using a ps1, is the run command included with process-scope bypass?
6. Does the command start with a guard and final proof?
7. Does the final proof block say exactly what to paste back?
8. Does the command avoid false PASS after an error?

## Repeated-Failure Escalation

If paste errors repeat, do not keep resending the same delivery style.

Escalate to the safer form:

- from loose chat text to code-only block;
- from giant code-only block to downloaded ps1;
- from unsigned ps1 failure to process-scope bypass run command;
- from repeated user paste confusion to one-line command or file artifact.

## Boundary

This rule does not create automation.

This rule does not create runtime.

This rule does not promote scripts to tools.

This rule does not rewrite active guides.

This rule does not rewrite CURRENT_TRUTH_INDEX.

This rule is delivery safety for PowerShell/code work.
