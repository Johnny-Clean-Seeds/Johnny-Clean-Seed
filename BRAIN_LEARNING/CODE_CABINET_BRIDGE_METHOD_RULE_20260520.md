# Code Cabinet / Bridge Method Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Problem

Long PowerShell/save scripts have been too often generated as giant one-off cousin scripts.

That creates risk:

- stale assumptions;
- repeated helper code drift;
- proof claims that do not match timing;
- source-custody overclaim;
- too much screen/copy burden;
- no reusable bridge for future saves.

## Rule

Before sending a long code artifact, the assistant must use a Code Cabinet / bridge method.

The working pattern is:

saved skeleton -> task instantiation -> task variables -> content blocks -> proof blocks -> artifact self-check -> final copy block

## Required Behavior

For long code, the assistant must identify:

1. Workflow family.
2. Skeleton or closest cousin.
3. Task-specific variables.
4. Files to create.
5. Files to update.
6. Required inputs.
7. Boundaries.
8. Proof checks.
9. Artifact Self-Check conditions.
10. Final claim.

## Skeleton Rule

If no suitable skeleton exists and the task family is recurring, create a skeleton in the Gear Rack / Code Cabinet.

A skeleton is not a runtime tool.

A skeleton is not doctrine.

A skeleton is a reusable construction bridge.

## Bridge Rule

A code bridge must make the long script easier to assemble and audit.

It should separate:

- preflight;
- paths;
- content blocks;
- validation;
- updates;
- receipt;
- git save;
- final proof.

## Boundary

This rule does not install automation.

It does not create runtime.

It does not promote scripts to tools.

It does not rewrite active guides.

It does not rewrite CURRENT_TRUTH_INDEX.

---

## 2026-05-20 - Delivery Lint Bridge Patch

Long-code bridge patch:

Before sending long code, the Code Cabinet bridge must include delivery-lint.

Check:

- should this be a downloadable ps1 instead of a giant chat block;
- if chat block, code only;
- no prose inside the code;
- no Markdown fence text expected to be pasted into PowerShell;
- if downloaded ps1, include process-scope execution-policy bypass run command;
- final copy-back block must be clear.

This patch exists because repeated copy/paste failures proved delivery form was the weakest link.

---

## 2026-05-20 - Handoff Safe Save Method Patch

Handoff patch:

New handoff assistants must use the safe save method for long Mr.Kleen save scripts.

Required flow:

Code Cabinet -> downloadable ps1 when long -> one run command -> parser/lint check -> execute -> receipt -> commit -> push -> fetch -> HEAD equals origin/main -> status clean.

Do not rely on giant chat copy blocks for long PowerShell when delivery errors have repeated.

Handoff card:

HOUSE_WORK\WORK_SHED\AGENT_HANDOFFS\HANDOFF_ASSISTANT_SAFE_SAVE_METHOD_CARD_20260520.md
