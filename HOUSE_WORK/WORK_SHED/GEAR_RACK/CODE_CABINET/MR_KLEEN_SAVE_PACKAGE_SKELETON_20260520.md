# Mr.Kleen Save Package Skeleton

Date: 2026-05-20

## Status

GEAR RACK / CODE CABINET SKELETON.

## Purpose

Reusable bridge for Mr.Kleen save packages.

This is a construction skeleton, not doctrine and not a runtime tool.

## Standard Shape

1. Preflight
   - confirm .git
   - fetch origin main
   - branch main
   - HEAD equals origin/main
   - clean working tree

2. Task Variables
   - define workflow family
   - define inputs
   - define new files
   - define updated files
   - define receipt
   - define boundary

3. Content Blocks
   - write source/capture/rule/TODO/disposition/artifact proof content
   - label source custody accurately
   - do not overclaim byte custody unless actual byte copy/hash exists

4. Validation
   - file exists
   - readable UTF-8 text
   - nonempty
   - no NUL
   - no replacement character
   - no placeholder marker
   - required phrases present

5. Updates
   - append to TODO/status once
   - write anchor
   - prevent duplicate markers

6. Artifact Self-Check
   - check created artifacts before ready claim
   - prove what was checked
   - do not count future receipt as already checked before writing it

7. Receipt
   - record hashes of created/updated files
   - state proof limits
   - state boundaries

8. Git Save
   - git add expected files
   - force-add ignored proof receipt
   - commit
   - push
   - fetch
   - final HEAD equals origin/main
   - final status clean

9. Final Copy Block
   - commit short hash
   - full HEAD
   - origin/main
   - clean status
   - saved paths
   - receipt hash
   - boundary
   - next move

## Required Claim Discipline

The receipt proves only the claim it names.

Source transcript is not byte custody unless the source file was copied and hash-checked.

Artifact proof must not claim the receipt was checked before the receipt exists.

## Boundary

No doctrine.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No runtime.
No automation.
No dashboard.
No knowledge graph.
No full lesson index.

---

## 2026-05-20 - Delivery Lint Step Patch

Add delivery-lint before final send:

For long PowerShell/save packages, check delivery form before sending.

Allowed forms:

1. one-line command;
2. code-only block;
3. downloadable ps1 file plus one run command.

If using a downloaded ps1 file, include:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & "$env:USERPROFILE\Downloads\FILE.ps1"

Do not let prose, Markdown fence text, or explanatory chat become part of PowerShell input.
