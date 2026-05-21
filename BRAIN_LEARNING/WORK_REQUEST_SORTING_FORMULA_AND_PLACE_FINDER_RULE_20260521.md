# Work Request Sorting Formula And Place Finder Rule

Date: 2026-05-21
Lane: BRAIN_LEARNING
Status: SUPPORT RULE / LIVE-USE REQUIRED / NOT DOCTRINE

## Purpose

When the user gives a job, task, note pile, file, research request, edit request, mimic/adopt/adapt request, or possible fix, the assistant must not jump straight to writing, researching, saving, or agreeing.

The assistant must first sort the request into the right work mode, decide where the object belongs, and name the proof needed before save/adoption.

## Trigger

Fire this rule when the user says or implies:

- do this job;
- use these notes;
- research this;
- edit/rewrite/revise this;
- mimic this pattern;
- adopt/adapt this fix;
- save/add rules;
- put this into files;
- make future assistants know this;
- this might be a fix;
- this feels like the missing part;
- use the bridge/front door/hard bridge.

## Formula

Use this sequence before action:

1. OBJECT
   Name what the user gave: note, command, problem, evidence, source ore, candidate rule, tool, bridge, file, return, or active job.

2. INTENT
   Identify the requested move: edit, research, mimic, adopt/adapt, diagnose issue, save/lock, test, bridge transfer, handoff, or park.

3. MODE
   Choose one primary mode and any support modes:
   - EDIT: improve existing text/code/file without changing authority.
   - RESEARCH: gather outside/source support and map claims to sources.
   - MIMIC: copy a working pattern shape while adapting to local boundaries.
   - ADOPT/ADAPT: take a found fix or method and fit it into the house after proof.
   - ISSUE/FIX: classify leak, root cause, repair, proof, and close condition.
   - PLACE/FIND: decide the correct room/lane before writing.
   - BRIDGE/TRANSFER: use local hard bridge or mule exchange bridge as carrier, not authority.
   - SAVE/LOCK: write, receipt, git proof, push, and clean status.

4. PLACE
   Run Place Finder before writing. Decide exact lane:
   BRAIN_LEARNING, GEAR_RACK, SORTING_BENCH, TODO, SOURCE_ORE, MULE_WORKSHOP, BRIDGES, PROOF_HISTORY, 123 local-only, or bridge WORKSPACE.

5. AUTHORITY
   Name what can and cannot steer: user command, ACTIVE_ANCHOR, active guides, CURRENT_TRUTH_INDEX, git state, receipts, mule output, bridge output, outside sources, notes.

6. STALENESS
   Ask whether this object is current, stale, docked, copied, old support, source ore, or live active work. A useful object can still be stale as a command.

7. PROOF
   Name proof needed: file exists, hash, bridge response, git status, receipt, live-use test, source-to-claim map, or user review.

8. DISPOSITION
   Choose one: APPLY, ADAPT, PARK, REJECT, BLOCK, NEEDS PROOF, SAVE SUPPORT ONLY, or TEST FIRST.

9. OUTPUT
   Produce only the needed output: answer, file, request packet, bridge request, helper, receipt, or save commit.

10. CLOSE
   State what changed, what did not change, what remains candidate, and the next clean move.

## Default decisions

If the user gives raw notes and says they might matter, default to DISSECT + PLACE + PARK/SUPPORT unless they explicitly request doctrine.

If the user asks to mimic, copy the ability or relation pattern, not the surface costume.

If the user asks to adopt a fix, first ask: where does it live, what proof exists, and what neighbor rule can it disturb?

If the user asks to save a rule everywhere, do not scatter it everywhere. Save it into every appropriate lane: rule, usage card, dissection, TODO/live-use, status, anchor, and receipt.

If the user asks to use the hard bridge, treat bridge output as carrier/proof surface only. It does not become house authority.

## Blocked

- no doctrine install from raw notes;
- no ACTIVE_GUIDES rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no runtime, dashboard, automation, permanent service, or open shell;
- no all-places scatter;
- no bridge output as authority;
- no mule output as authority;
- no editing/saving before Place Finder chooses a lane.

## Live-use standard

This rule must be tested on real user notes and bridge requests before promotion. Until then it is a support rule.
