# Packet Top-Block / Read-Order Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Parent Boss: Rule Activation / Work-Order Control
Status: active support rule candidate for dense packet entry
Authority: support rule; not active guide; not doctrine rewrite; not dashboard

## Root problem

Dense packets can carry the right information but still be hard to enter.

A packet can be correct and still slow the assistant, mule, or user because the controlling state is buried inside the body.

This creates these risks:

- reader starts in the wrong place,
- old context gets treated as active,
- output lane is missed,
- hard bans are discovered too late,
- completion standard is unclear,
- stop condition is not seen before action.

## Root rule

Future dense packets, mule packets, handoff files, large instruction files, deep review files, and major reference files should start with a short top block.

The top block does not replace the full packet.

It gives the reader the control state before the body.

## Required top-block fields

A packet top block should include:

1. Task
2. Control state
3. Authority / lane
4. Read order
5. Input evidence
6. Output lane
7. Hard bans
8. Completion standard
9. Stop condition
10. Status / expiration condition when relevant

## Why this belongs under Rule Activation / Work-Order Control

This is not a formatting preference.

It helps the right rule fire before action.

It supports:

- control-state-first,
- rule confirmation,
- boss/ghost sorting,
- completion-standard gate,
- mule duplicate-work guard,
- no random moves,
- no mule inertia,
- claim-scoped proof.

## When this rule applies

Apply to future files when the file is dense enough that a reader could miss:

- current task,
- active authority,
- output lane,
- proof requirement,
- hard bans,
- stop condition.

Examples:

- mule active packet,
- mule return intake packet,
- deep house walkthrough,
- large critique handoff,
- dense rule package,
- major Work Shed reference,
- future outside-review packet.

## When this rule does not apply

Do not force top blocks onto:

- short notes,
- receipts,
- small TODO files,
- simple one-purpose rule files,
- files where the title and first paragraph already carry the control state.

Do not churn old files just to add top blocks.

Use on future packets or selected revisions only.

## Top block authority boundary

A top block is a routing aid.

It is not higher authority than:

- CURRENT_TRUTH_INDEX,
- ACTIVE_ANCHOR,
- active guides,
- AGENTS rules,
- current git proof,
- user command.

If a top block conflicts with higher authority, higher authority wins.

## Completion standard

This rule is complete when:

- rule file is saved,
- template is saved,
- dissection note is saved,
- TODO support file is saved,
- receipt exists,
- commit/push/fetch proof succeeds,
- HEAD equals origin/main,
- status is clean.

## Boundary

This rule does not:

- rewrite active guides,
- rewrite CURRENT_TRUTH_INDEX,
- rewrite old packets,
- create a dashboard,
- create automation,
- create a knowledge graph,
- promote a tool/checker/Soft Suit,
- create /system,
- run a mule pass.
