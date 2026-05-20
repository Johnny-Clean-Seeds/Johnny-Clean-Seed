# Control-State-First / Rule-Firing / Boss-Ghost Gate

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: active support rule candidate for assistant work-entry behavior
Authority: support rule; not active guide; not doctrine rewrite

## Root problem

The house did not fail because it lacked ideas.

The house failed because the assistant sometimes answered the surface task before checking the controlling state.

The key failure phrase is:

Rule exists does not mean rule fired.

## Parent boss

Parent Boss:
Rule Activation / Work-Order Control

Meaning:
The main issue is whether the right rule fires before action.

## Ghosts under the parent boss

These are ghosts, symptoms, or child issues. They should not be fought as separate parent bosses unless proof shows otherwise.

1. Worker-custody slip
   - Symptom: assistant tries helpful house work while a mule/worker is active.
   - Parent: Rule Activation / Work-Order Control.
   - Fix: Control state first; worker present means hands off.

2. Mule duplicate-work risk
   - Symptom: mule is sent to fix issues the house already fixed.
   - Parent: Rule Activation / Work-Order Control.
   - Fix: before mule kickoff or mule intake, compare against current anchor, status, receipts, and current HEAD.

3. Surface-command mimicry
   - Symptom: assistant mimics the literal request without understanding task lane, state, or rule context.
   - Parent: Rule Activation / Work-Order Control.
   - Fix: suit the task; classify the controlling state before obeying the surface command.

4. TODO not boss-sorted
   - Symptom: TODO lists become flat piles.
   - Parent: Rule Activation / Work-Order Control.
   - Fix: large lists and TODO items must split parent bosses from ghosts, symptoms, tools, evidence, and children.

5. Completion standard drift
   - Symptom: completed/done is treated as pass.
   - Parent: Rule Activation / Work-Order Control.
   - Fix: each task must define what complete means before action.

6. Loose idea/tool debris
   - Symptom: tools, links, screenshots, mule output, old chat, or ideas are used but left without placement.
   - Parent: Rule Activation / Work-Order Control.
   - Fix: apply, park, save, cite, reject-with-reason, or ignore as irrelevant.

7. Cycle disconnect
   - Symptom: idea capture, TODO, mule, proof, and learning cycles do not hand off cleanly.
   - Parent: Rule Activation / Work-Order Control.
   - Fix: use the cycle-flow route below.

## Control-State-First Gate

Before any nontrivial house task, the assistant must classify the controlling state before responding to the surface request.

Required questions:

1. What is the user asking for?
2. Is a worker/mule active or present?
3. What lane is this task in?
4. Which active rules govern this lane?
5. Which neighboring lanes could be disturbed?
6. What does complete mean for this task?
7. What is the stop condition?

If a worker/mule is active or possibly active:

- no repo edits,
- no commits,
- no pushes,
- no receipts,
- no anchor/status/queue changes,
- no rule saves,
- no restructuring,
- no side fixes,
- no local commands except explicit read-only checks.

Allowed during worker custody:

- answer from known state,
- clarify instructions,
- help communicate with the worker,
- read/interpret user-provided worker output,
- prepare off-house notes that do not touch Mr.Kleen.

## Pre-Action Rule Confirmation Gate

Before house-touching work, the assistant must name the rules that are firing.

Compact format:

Task:
Control state:
Custody:
Lane:
Rules firing:
Neighbor lanes:
Completion standard:
Stop condition:

This prevents passive stored rules from being mistaken for active rules.

## Task Request to Rule Candidate Gate

When the user gives a correction or instruction that cleanly improves order, safety, proof, routing, naming, or fit, the assistant must not treat it as a one-time preference.

It must be sorted into one of these lanes:

- already active rule: confirm it;
- candidate rule: capture it;
- TODO support: list it;
- Work Shed / Sorting Bench: dissect it;
- Idea Bag: preserve it;
- Source Ore: park as raw material;
- Proof History: receipt only when evidence/proof was produced;
- blocked: reject with reason.

## Boss/Ghost Sorting Gate For TODO And Idea Capture

Large idea lists, TODO lists, critique returns, recovered chat chunks, mule outputs, and issue piles must not be judged flat.

Required flow:

1. Capture raw items.
2. Group by lane.
3. Identify possible parent bosses.
4. Collapse ghosts/symptoms/tools/checks under parent bosses.
5. Rank true parent bosses.
6. Pick the current parent boss only if selected by user command or ACTIVE_ANCHOR.
7. Park non-selected bosses.
8. Attach ghosts as child notes, not separate active bosses.
9. Define proof and completion standard.
10. Stop after selected scope.

Boss means:
A parent issue that explains or controls multiple smaller issues.

Ghost means:
A symptom, duplicate, side-effect, stale echo, tool need, evidence gap, wording snag, or child issue that should not drive the work by itself.

## Mule Duplicate-Work Guard

Before sending work to mule or accepting mule recommendations, compare against current house state.

Check:

- current HEAD and origin/main;
- ACTIVE_ANCHOR;
- CURRENT_HOUSE_WORK_STATUS;
- relevant receipts;
- existing Work Shed / TODO / BRAIN_LEARNING files;
- whether the issue is already fixed, partially fixed, parked, blocked, or still live.

Mule output must be dispositioned as:

- ACCEPT,
- ALREADY FIXED,
- ADAPT,
- PARK,
- BLOCK,
- UNKNOWN.

The mule is a sharpener, not supervisor. The house decides.

## Completion Standard Gate

Each task must define complete before action.

Completion standards:

- Chat answer: direct answer delivered; no local-save claim.
- Held artifact: artifact created/held or linked.
- Local file save: file exists and hash can be computed.
- Mr.Kleen lock/save: files saved, receipt made, commit, push, fetch, HEAD equals origin/main, status clean.
- Mule kickoff: start pointer and return folder contract delivered.
- Mule return intake: required files found, read, dispositioned, then saved if selected.
- Read-only check: inspected with no file changes.
- Worker-active support: helped without touching Mr.Kleen.
- Rule install: rule saved in correct lane, receipt, commit/push proof, and later live-use test when needed.

## Relevant Tool Use

Use all relevant tools, not all tools literally.

Relevant means the tool fits:

- task lane,
- evidence need,
- proof need,
- risk level,
- current authority,
- neighbor impact,
- user command.

Do not crawl everything by default.

Do not under-tool when a task needs evidence, files, proof, web comparison, mule output, queue/TODO, screenshots, or old notes.

Every used tool/source/idea must end in one of these states:

- applied,
- cited,
- parked,
- saved,
- rejected-with-reason,
- ignored as irrelevant.

## Cycle Flow Route

The cycles must hand off cleanly.

1. Work Entry Cycle
   control state -> lane -> rules -> completion standard -> stop condition

2. Idea Capture Cycle
   raw idea -> group -> parent boss / ghost split -> lane placement -> TODO or park

3. TODO Cycle
   parent boss -> child ghosts -> selected active item -> proof standard -> close or park

4. Mule Cycle
   packet -> return -> intake -> dedupe against current house -> disposition -> no mule inertia

5. Proof Cycle
   file/write -> hash -> receipt -> commit -> push -> fetch -> HEAD/origin match -> clean status

6. Learning Cycle
   problem -> diagnosis -> rule candidate -> save if selected -> live-use proof

7. Tightening Cycle
   evidence -> dissect -> compare -> accept/adapt/park/block -> save selected -> stop

No cycle should command another cycle by inertia. Handoff requires user command or active anchor selection.

## Mimic-only behavior is blocked

The assistant must not merely mimic the user's surface request.

The assistant must suit the request to:

- current control state,
- active authority,
- lane,
- proof standard,
- neighbor impact,
- boss/ghost structure,
- stop condition.

A surface request can be valid but still blocked by a higher control state.

Example:
If the user says lock/save while a worker is active, the correct behavior is not automatic saving. The correct behavior is worker-custody stop unless the user explicitly pauses/cancels the worker or asks for read-only support.

## Verdict

This rule package fixes the parent boss by making rule activation, boss/ghost sorting, completion standards, mule dedupe, and cycle flow part of normal work-entry behavior.
