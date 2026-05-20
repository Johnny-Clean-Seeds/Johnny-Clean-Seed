# TODO First Work Control Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Core Correction

Open TODOs are pending work.

They are not scenery.

They are not background evidence.

They are not "maybe later" unless explicitly parked, blocked, superseded, merged, or closed with proof.

## Failure This Rule Fixes

The assistant said the house needed real work while open TODOs were already present.

That is invalid.

If TODOs exist, the first default work source is the TODO board.

## Rule

After any clean re-entry, save, scan, house walk, proof receipt, or status read, the assistant must check whether open TODOs exist.

If open TODOs exist, the assistant must do one of these:

1. Work the top actionable TODO.
2. Triage the TODO board if priority is unclear.
3. Continue the already selected active TODO route.
4. State clearly that the user has explicitly chosen a live task that outranks TODO work for this turn.

The assistant must not say "we need real work" while open TODOs are visible.

TODO is real work unless disposed.

## Valid TODO States

Each TODO must eventually be assigned one of these states:

- ACTIVE: being worked now.
- DONE: completed with proof.
- PARKED: held with return condition.
- BLOCKED: stopped with blocker and unblock condition.
- SUPERSEDED: replaced by newer route with evidence.
- MERGED: collapsed under a parent boss or larger TODO.
- STALE: needs review because its trigger may no longer apply.

## Re-Entry Selection Order

On clean re-entry:

1. Read ACTIVE_ANCHOR.
2. Read current status tail.
3. Read TODO board/index.
4. Identify open TODOs.
5. Check whether an active TODO is already selected.
6. If no active TODO is selected, triage the board.
7. Select one TODO route.
8. Act or ask only if selection is genuinely ambiguous.

## Correct Meaning Of Continue Normal Work

"Continue normal work" means continue the selected TODO route or select the next actionable TODO.

It does not mean drift.

It does not mean wait for another idea.

It does not mean ignore the board.

## Anti-Bloat Constraint

Do not create a new TODO to avoid doing an existing TODO.

Do not create a new rule to avoid triaging existing TODOs.

Do not open a new boss when an existing TODO is actionable.

New TODOs are allowed only when:

- a real future action cannot be done now;
- a lesson would be lost without capture;
- a blocker must be recorded;
- a parent/child merge needs a trace.

## User Override

The user can always override TODO selection with a live task.

When that happens, the assistant should say the live task overrides TODO work for this turn and then route the live task through the correct proof lanes.

## Boundary

This rule does not install doctrine.

This rule does not rewrite active guides.

This rule does not rewrite CURRENT_TRUTH_INDEX.

This rule does not create automation.

This rule does not create a dashboard.

This rule does not create runtime.

This rule does not make TODOs authority above ACTIVE_ANCHOR.

It makes TODOs active work-control evidence that must be processed.

---

## 2026-05-20 - Weakest-Link Selection Patch

Correction:

The phrase "pick one actionable TODO" must not mean preference selection.

TODO selection must be proof-ranked.

The list chooses through evidence:

1. group TODOs by parent boss;
2. collapse child symptoms/tools/tests under the larger seam;
3. rank parent bosses by biggest issue / weakest link;
4. select the top route from proof;
5. state why it outranks alternatives;
6. work or dispose that route.

Correct next-action language:

"Run TODO weakest-link triage."

Not:

"Pick one TODO."
