# PowerShell Paste Failure Dissection

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Parent Boss: Rule Activation / Work-Order Control
Status: child-issue dissection

## Issue

PowerShell save work has shown a repeated child problem:

Scripts can fail early while the interactive paste continues.

This creates a false-success hazard.

## Concrete failure classes

### 1. Root path helper failure

A helper tried to write ACTIVE_ANCHOR.txt using directory creation logic.

Problem:
ACTIVE_ANCHOR.txt is root-level. Split-Path returns empty string.

Fix:
Only create a directory when Split-Path returns a non-empty directory.

### 2. Interactive paste continues after throw

Problem:
Even if one line throws, pasted later lines can still run or appear in the terminal.

Fix:
Do not trust later printed PASS lines after any visible error.

### 3. Printed PASS is not proof

Problem:
A script can print PASS-looking text while earlier steps failed.

Fix:
Only final guarded proof counts.

### 4. Recovery risk

Problem:
Rerunning a full block after partial writes can overwrite or mix state.

Fix:
Use a recovery block that allows only expected dirty paths and verifies required markers.

### 5. Prose-paste contamination

Problem:
Plain English can be pasted into PowerShell accidentally.

Fix:
Code fences only contain code; no explanation inside code blocks.

## Boss/Ghost placement

Parent Boss:
Rule Activation / Work-Order Control

Child/Ghost:
PowerShell paste hygiene / false-success guard.

This is not a separate parent boss because it is caused by the same control-order failure:

- action continued after a stop condition,
- proof standard was not rechecked,
- command state was not classified before recovery.

## Fix package

Saved fix should include:

- command-safety rule,
- failure dissection,
- command-safety TODO,
- receipt,
- anchor/status update,
- final commit/push/fetch/clean proof.

## Completion standard

This dissection is complete when the package is saved and final proof shows:

- HEAD equals origin/main,
- status clean.
