# Task-Scoped Rule + Neighbor Search / File-First Long Kickoff Rule

Date: 2026-05-19
Base before save: main @ 1a63c4e
Lane: BRAIN_LEARNING
Status: support behavior rule, not active guide doctrine

## Core rule

Before performing any one Clean Seed / Mr.Kleen task, the assistant must identify the task lane and search the rules that directly govern that lane.

The assistant must also check neighboring rules, affected lanes, active anchor/status/queue when relevant, blocked moves, proof requirements, and prior related failures before making choices, rules, handoffs, saves, edits, commands, recommendations, or task-shape decisions.

This is task-scoped retrieval, not whole-house hunting.

The assistant should not act while ignorant of the local law touching the task.

## Required task-scoped search

For each important task, check:

- active task lane,
- governing rule files,
- neighbor lanes,
- affected files/rooms,
- ACTIVE_ANCHOR when active-ball or blocked moves matter,
- CURRENT_HOUSE_WORK_STATUS when room state matters,
- CURRENT_WORK_QUEUE when attention/order matters,
- AGENTS or mule/handoff rules when outside/local workers matter,
- proof/receipt rules when PASS or save is involved,
- Handy Idea Bag / No Random Moves when multiple fixes or neighbor risk exists,
- Adapt/Adopt when user corrections, critiques, source ore, notes, mule output, or proof history are being learned from,
- prior related failures when the issue smells repeated.

## File-first rule for long kickoffs

Long kickoffs, mule handoffs, agent packets, dense instruction packs, and reusable operating text should go into file-first packaging by default.

Chat should receive only:

- short purpose,
- target path/name,
- brief summary,
- and the local save/run instruction if needed.

Do not dump long handoff bodies into chat unless the user explicitly asks to see the full body in chat.

## Mule rhythm correction

The mule is not a go-to endless cycle.

Correct order:

1. house finds issues,
2. house uses/applies/tests fitting fixes where appropriate,
3. house decides whether a bounded mule pass is useful,
4. mule sharpens only the selected bounded target,
5. mule return is intaken and dispositioned,
6. house acts or parks from proof.

The mule is not supervisor, not authority, not default, not a recurring treadmill, and not a substitute for the house learning and acting first.

## Current-task contamination boundary

If a later rule or adoption issue appears during a current task, capture it without letting it hijack the real task.

Finish or safely park the current task first.

Then return to the later rule issue through the correct lane, proof, and save threshold.

## Relationship to existing rules

This rule is a child/companion of:

- Gear-Up Before House Work Gate,
- Handy Idea Bag,
- No Random Moves / Calculation Gate,
- Adapt / Adopt Critique Learning Gate,
- Anti-Agreement / Proof-in-Pudding,
- Better-Fit Adoption / Recursive Disposition,
- Mule Worker Not Supervisor / House Walk First Rule,
- Queue Loss Prevention.

It does not replace those rules.

It tells the assistant to retrieve the relevant ones before acting.

## Boundary

This rule does not authorize:

- doctrine rewrite,
- active guide rewrite,
- CURRENT_TRUTH_INDEX rewrite,
- tool/checker promotion,
- Soft Suit promotion,
- runtime build,
- /system creation,
- automation,
- dashboard,
- knowledge graph,
- full lesson index,
- proof-history restructuring,
- mule-as-supervisor behavior.

## Proof standard

This rule is working only if it changes behavior at point of work.

Good proof signs:

- long kickoff goes to file/package instead of chat dump,
- assistant checks the relevant task rules before acting,
- assistant avoids whole-house hunting when targeted retrieval is enough,
- assistant catches neighbor-lane conflicts earlier,
- assistant does not use mule by inertia,
- assistant separates current task from later adoption issues,
- assistant can explain what governing rules were checked for a task.
