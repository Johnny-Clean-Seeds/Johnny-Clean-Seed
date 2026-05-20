# Task-Scoped Rule + Neighbor Search / File-First Capture

Date: 2026-05-19
Base before save: main @ 1a63c4e
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: support capture and dissection, not doctrine

## Why this surfaced

During a mule handoff request, the assistant dumped a long kickoff body into chat instead of packaging the long body as file-first content.

The user corrected that long kickoffs belong in files so chat is not wasted.

The user also identified the deeper rule: before doing any one task, the assistant must search the task's own rules, neighboring rules, and affected lanes. Otherwise the assistant is making choices without knowing the local law touching the task.

## Failure shape

The failure was not only formatting.

It was a task-scoped retrieval failure.

The assistant did not first inspect the mule/handoff lane, agent-output expectations, queue/anchor state, file-first packaging preference, and neighboring rules before choosing how to answer.

## Corrected behavior

For important tasks:

1. name the task lane,
2. check governing rules,
3. check neighbor rules,
4. check affected lanes,
5. check active anchor/status/queue if relevant,
6. check proof and blocked moves,
7. check prior related failures,
8. choose the smallest clean route,
9. package long reusable text into files by default,
10. keep chat short unless the user asks for full text.

## Fit with existing house material

This correction fits existing house material:

- Gear-Up Before House Work says the right lens must fire before saving or placing.
- Handy Idea Bag says use fit-slot retrieval when neighbor/proof/authority risk exists.
- Adapt/Adopt says notes, critiques, proof history, handy bags, bitstrings, receipts, and failures must become behavior at point of work.
- Mule Worker Not Supervisor says mule is bounded and not an endless supervisor.
- Queue Loss Prevention says saving and handoffs should serve motion, not create ceremony.
- Anti-Agreement says user corrections should be verified and tested, not merely flattered.

## Immediate adoption

The correction is adopted as a support behavior rule.

It is not active guide doctrine.

It should be tested in the next real job by requiring the assistant to name the task lane and check relevant neighboring rules before making the next move.

## Parked later issue

A later clean improvement may be needed:

- a mule-start / worker-start access map,
- or a compact point-of-work rule retrieval checklist.

Do not build that now unless selected.

## Boundary

No doctrine rewrite.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No tool promotion.
No checker promotion.
No runtime work.
No mule send.
No full lesson index.
No dashboard.
No knowledge graph.
