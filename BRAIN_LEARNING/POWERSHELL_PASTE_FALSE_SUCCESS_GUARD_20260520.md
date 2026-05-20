# PowerShell Paste / False-Success Guard

Date: 2026-05-20
Lane: BRAIN_LEARNING
Parent Boss: Rule Activation / Work-Order Control
Status: active support rule candidate for command safety
Authority: support rule; not active guide; not tool promotion

## Purpose

Prevent PowerShell paste failures from becoming false PASS claims.

This rule exists because repeated local-save work showed the same child issue:

- a script throws early,
- interactive paste continues,
- later lines can still print success-looking text,
- the assistant may mistake movement or printed words for proof,
- recovery can become risky if dirty paths are not checked.

## Root rule

A printed PASS line is not proof if any earlier command in the run errored.

Proof requires the final guarded proof sequence:

1. commit succeeds,
2. push succeeds,
3. fetch succeeds,
4. HEAD equals origin/main,
5. git status is clean.

## Command-safety rules

### 1. Code blocks contain code only

Do not put explanatory prose inside copy/paste command blocks.

Explanation belongs outside the code block.

### 2. Root-level file paths must be supported

Any file-writing helper must support both:

- root-level files like ACTIVE_ANCHOR.txt,
- nested files like HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md.

A helper must not call New-Item with an empty directory path.

Safe pattern:

- compute Split-Path;
- create directory only if the directory string is not empty;
- then write the file.

### 3. Stop after first error

If PowerShell throws, do not trust later printed lines.

Do not claim PASS.

Do not continue into save/commit unless a recovery block proves the dirty state is expected.

### 4. Recovery blocks must be narrower than original blocks

A recovery block must:

- check HEAD against origin/main;
- inspect git status;
- allow only expected dirty paths;
- verify required files exist;
- verify required text markers;
- then finish receipt/anchor/status/commit/push.

### 5. No false-clean claims

If final status is not clean, stop.

If HEAD does not equal origin/main after fetch, stop.

If required staged files are missing, stop.

If required checks fail, stop.

### 6. Copy-back standard

After local save, the user should paste only the final proof block.

The final proof block must include:

- PASS label,
- branch,
- HEAD,
- origin/main,
- status clean,
- named parent boss or saved package when relevant.

### 7. Use small command blocks when possible

Prefer narrow task-specific blocks.

Use large blocks only when:

- multiple files must be written together,
- receipt/status/anchor must be synchronized,
- proof path needs one guarded flow.

### 8. Guard-fail means custody lockout

If a guard fails, the run is contaminated for PASS.

The next action is not "keep going."

The next action is:

- inspect,
- classify dirty paths,
- recover narrowly,
- or abort and restore.

## Completion standard for PowerShell save tasks

A PowerShell save task is complete only when:

- intended files exist,
- required text checks pass,
- hashes are recorded,
- receipt exists,
- commit succeeds,
- push succeeds,
- fetch succeeds,
- HEAD equals origin/main,
- git status is clean.

## Boundary

This rule does not create:

- a tool framework,
- automation,
- dashboard,
- knowledge graph,
- active guide rewrite,
- CURRENT_TRUTH_INDEX rewrite,
- script promotion,
- /system,
- mule pass.

## Verdict

PASS as a command-safety support rule when saved and proven.

---

## 2026-05-20 - Delivery Lint Escalation Patch

Repeat-failure patch:

PowerShell paste hygiene now includes delivery-lint before sending.

If a long script is sent through chat and copy/paste errors repeat, do not simply resend the same style.

Escalate delivery:

1. one-line command for simple work;
2. code-only block for medium work;
3. downloadable ps1 file for long work;
4. process-scope execution-policy bypass run command for downloaded ps1 files.

Downloaded ps1 run command shape:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & "$env:USERPROFILE\Downloads\FILE.ps1"

Boundary:
- this is delivery safety;
- not automation;
- not runtime;
- not script/tool promotion.
