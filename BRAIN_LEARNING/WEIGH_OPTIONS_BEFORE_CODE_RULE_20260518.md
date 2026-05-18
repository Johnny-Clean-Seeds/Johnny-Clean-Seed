# Weigh Options Before Code Rule

Status: ACTIVE LEARNING RULE
Authority: assistant behavior rule; not command authority

## Purpose

This rule prevents first-available-fix behavior without creating overthinking ceremony.

Before creating Mr.Kleen code, project-changing commands, new files, rules, indexes, receipts, or save paths, the assistant must judge whether the choice actually needs option weighing.

Weigh when choice matters.

Do not weigh when the path is already clean.

## Core Rule

Do not write project-changing code from the first available idea when the choice has real consequences.

If the planned change rings several bells at once, the assistant must run a visible logic pass before coding.

If the task is simple, already selected, mechanical, or low-risk, the assistant should not run a full weighing pass.

## Bells / Alarms

A planned code/change rings bells when it touches or risks:

- authority
- proof
- ACTIVE_ANCHOR.txt
- CURRENT_TRUTH_INDEX.txt
- ACTIVE_GUIDES/
- AGENTS.md
- TODO control
- SOURCE_ORE/
- PROOF_HISTORY/
- scripts/tools
- room structure
- public history
- doctrine
- promotion
- cleanup/move/delete
- runtime/status-command work
- multiple neighbor rooms
- repeated mistake pattern
- duplicate commit/message confusion
- source becoming command
- support map becoming authority

## Trigger Logic

Run a full Weigh Options logic pass when:

- three or more bells ring at once
- one high-risk bell rings, such as authority, proof, source promotion, active guide rewrite, public history rewrite, runtime work, cleanup/delete/move, or anchor/current-state change
- there are multiple plausible paths and the wrong choice could create drift
- the user asks what we should do, what is best, or whether the move is worthy
- the assistant is about to create a new rule, index, support map, receipt, or save path that affects future behavior

Do not run a full Weigh Options logic pass when:

- the task is already selected
- the next step is mechanical
- the user only needs status confirmation
- the change is a tiny obvious fix
- the command path is already approved and unchanged
- weighing would add more fog than value

## Mimic Similar Rule Logic

This rule must mimic the working logic of nearby Clean Seed methods.

It should not invent a detached ceremony.

It should copy the useful logic pattern from:

- Sort Before Judgment
- Trace-Gated Boss Control
- Respect Thy Neighbor
- Soft Suit / Hard Suit
- Pattern Transfer
- Proof Before Save
- Done Is Not PASS
- Source Ore Is Not Command

Meaning:

First trace the need.

Then detect bells.

Then group the choices.

Then compare fit.

Then select the cleanest option.

Then code.

Then prove.

Then save.

## Required Logic Pass When Triggered

When the rule triggers, the assistant must generate this same-style logic before code:

1. Active need
2. Bells triggered
3. Similar rules being mimicked
4. Viable options
5. Comparison logic
6. Selected option
7. Blocked options
8. Proof path
9. Save path

## Comparison Logic

Compare options by:

- fit to current anchor
- fit to core rules
- neighbor impact
- proof strength
- risk
- simplicity
- lowest-force change
- long-term placement value
- whether it solves the real boss or only a symptom
- whether it preserves source/support/authority boundaries

## Fit Standard

The best option is not the biggest option.

The best option is the option that solves the current boss with the cleanest placement, lowest unnecessary force, strongest proof path, and least neighbor damage.

## Blocked Behavior

Do not:

- grab the first clean-looking fix when bells are ringing
- write project-changing commands before comparing options when the rule triggers
- solve a symptom while the real boss is visible
- add structure only because it is possible
- skip proof because the idea feels right
- treat a visible list as enough if the logic was not actually compared
- turn this rule into ceremony for simple mechanical work

## Short Form

Few bells:
Move cleanly.

Many bells:
Make the logic visible before code.

Weigh first when choice matters.

Code second.

Proof decides.
