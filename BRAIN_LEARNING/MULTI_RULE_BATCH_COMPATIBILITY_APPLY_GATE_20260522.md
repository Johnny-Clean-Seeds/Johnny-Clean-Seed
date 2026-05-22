# Multi-Rule Batch Compatibility Apply Gate — 20260522

## Status

Type: brain-learning / batch-rule installation gate.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not force multiple rules to install if they conflict.
- This does not replace individual proof receipts.
- This does not override source custody, save-routing, or safety gates.

## Core Rule

When the assistant creates or installs several rules together, it must run those rules against each other before saving or as part of the save.

Do not merely bundle several rules and commit them.

A batch rule save needs a compatibility/apply gate.

## Trigger

This gate fires when:

- two or more rules are being created at once;
- a rule bundle includes several captures;
- a new rule modifies how other recent rules should behave;
- a cockpit update adds several sections;
- a save script installs multiple project files with rule effect;
- the assistant notices a rule may affect another rule;
- the user says apply, compare, make sure they obey each other, or similar.

## Required Checks

For every multi-rule batch, check:

1. Scope compatibility.
2. Authority compatibility.
3. Local + URL versus local-only routing.
4. Desktop drop naming versus internal house naming.
5. No-parking / fit-decision routing.
6. Cockpit/drop-copy update requirement.
7. Source custody / no source gets throne.
8. Proof receipt coverage.
9. Final Judge Gate role.
10. Switching-gears/context reset if the work changed lanes.
11. Porch/drop event trigger if files/packages are dropped.
12. Blocked promotion boundaries.
13. Whether any rule creates an exception to another rule.
14. Whether the exception is explicit, named, and bounded.

## Required Output

A batch save must include one of these:

- compatibility matrix;
- apply-gate receipt section;
- cross-check table;
- explicit fit/conflict/refine/block list.

The output must judge each involved rule as:

- FITS;
- FITS WITH BOUNDED EXCEPTION;
- NEEDS REFINEMENT;
- CONFLICTS;
- BLOCKED;
- PARK WITH RETURN TRIGGER.

## Compatibility Matrix Minimum Fields

A clean matrix should include:

- rule name;
- scope;
- affected other rule(s);
- compatibility verdict;
- required boundary;
- save location;
- receipt/proof location;
- remaining risk or follow-up.

## Conflict Handling

If rules conflict:

1. Stop the batch promotion.
2. Name the conflict.
3. Decide which rule has precedence or whether refinement is needed.
4. Refine before save, or park/block with receipt.
5. Do not hide the conflict by committing both silently.

## Bounded Exception Rule

If a rule needs an exception to another rule, the exception must be:

- named;
- scoped;
- justified;
- visible in receipt or matrix;
- not allowed to spread.

Example:
A fixed-name CHAT current-pointer drop-copy may be treated differently from normal versioned Desktop artifacts only if the role is explicitly current-pointer/mirror and not a new user-facing artifact family.

## Relation to No Parking Rule

No Parking says every new project object gets fit decision and route.

This gate applies that logic to batches:
each rule in the batch must be routed and each relationship between rules must be checked.

## Relation to Final Judge Gate

The Final Judge Gate asks whether the gates did their jobs.

For a rule batch, the Final Judge Gate checks whether the compatibility/apply gate actually ran and whether the batch obeyed existing house rules.

## Relation to Desktop Drop Version Naming

Desktop/download/drop helper scripts created for the user should use V naming.

Internal house/repo files should not use V naming.

If a batch creates both, report the split.

## Relation to Local + URL Default

Durable project rules/captures/receipts/status updates default to local + URL.

Local helper scripts, Desktop drop-copies, receipts, plans, dropboxes, and triggers default local-only unless explicitly routed.

A batch receipt must state the split.

## Failure Pattern

Dirty pattern:
Bundling multiple rules and saying "saved" without checking whether they obey each other.

Worse dirty pattern:
Installing two rules that silently conflict.

Worst dirty pattern:
Adding a new rule that should have changed the install process, but not applying it to the current batch.

## Clean Pattern

Clean pattern:

1. Identify the batch.
2. List every rule/object in the batch.
3. Run compatibility matrix.
4. Refine conflicts.
5. Save only the compatible set.
6. Receipt matrix/proof.
7. Update cockpit/drop-copy if assistant-facing.
8. Report local+URL versus local-only.

## Short Form

Several rules at once means apply gate.

Run the rules against each other.

Fit, refine, block, or bounded exception before commit.
