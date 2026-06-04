# UI Command Grammar V0

Date: 2026-06-04
Status: COMMAND GRAMMAR / DESIGN ONLY / NOT EXECUTION
WorkKey: UI-COMMAND-GRAMMAR-V0-20260604

## Pipeline

`operator phrase -> alias map -> resolved intent -> active object -> action card -> proof requirements -> confirmation -> house route -> receipt`

Parsed intent is not permission.

## Command Families

### Inspect

Aliases:

- `inspect`
- `inspect last task`
- `inspect last job`
- `show active task`
- `show proof`
- `show blockers`

Mode:

Read-only unless a later confirmation card grants a bounded write.

### Root

Aliases:

- `root check`
- `route residue`
- `show root`
- `root clean`

Mode:

Inventory, classify, and prepare route cards. Any move/delete requires proof and allowed lane.

### Save Gate

Aliases:

- `lock save`
- `save gate`
- `save it`
- `commit this`

Mode:

Never direct execution. Build exact staged-set card, proof checklist, receipt plan, and confirmation card first.

### Guard Review

Aliases:

- `guard review`
- `run verifier`
- `check script`
- `prove helper`

Mode:

Static or fixture review first. Target/helper execution remains blocked until explicitly authorized and proof gates pass.

### Parking

Aliases:

- `open parking`
- `park this`
- `show parked`

Mode:

Classify, route, and return-trigger work. Parking is not closure.

## Required Action Recipe Fields

- command;
- resolved intent;
- active object;
- target path;
- required inputs;
- allowed actions;
- forbidden actions;
- proof required;
- user confirmation required;
- receipt path;
- root clean check;
- closeout verdict.

## Required Commands In V0

| Phrase | Intent | Default Mode | Confirmation Required |
| --- | --- | --- | --- |
| `inspect last task` | inspect active task pointer or latest task evidence | read-only | no |
| `inspect last job` | inspect latest job/receipt | read-only | no |
| `show active task` | show current active object | read-only | no |
| `root check` | inventory and classify root | read-only first | yes before move/delete |
| `route residue` | prepare route card for wrong-lane material | bounded write | yes |
| `lock save` | prepare exact save gate | write/git possible | yes |
| `save gate` | prepare exact save gate | write/git possible | yes |
| `guard review` | static helper/script review | read-only first | yes before execution |
| `run verifier` | run approved verifier | execution possible | yes |
| `open parking` | show parked objects and return triggers | read-only | no |
| `show blockers` | list blockers by class | read-only | no |
| `show proof` | list proof/receipt surfaces | read-only | no |

## Boundaries

The grammar does not execute commands by itself. It produces intent and action-card requirements.

No UI command may bypass proof, receipts, root clean checks, or user confirmation for risky actions.
