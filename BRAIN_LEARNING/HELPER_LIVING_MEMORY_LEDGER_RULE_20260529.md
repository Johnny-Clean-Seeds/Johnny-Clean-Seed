# Helper Living Memory Ledger Rule — 2026-05-29

Status: SUPPORT RULE / LIVING IDEA SEED  
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX; not automation.  
Scope: Clean Seed / Mr.Kleen helper design, helper refinery, save scripts, local tools, proof helpers.

## Core idea

Each helper needs a durable memory of its own work.

A helper must not only be repaired in chat. When a helper breaks, falsely blames the wrong thing, exposes a bad checker, proves a better route, or changes its current behavior, the house should capture that learning in the right helper-specific ledger/map.

This is not context reduction. It is keyed accumulation.

The live chat should carry only the active object, blocker, proof pointer, and next condition. The helper ledger carries the deeper stack: what was, what broke, what was falsely blamed, what fixed it, what is current now, what proof exists, what old behavior is rejected, and what should happen next time.

## Rule

Every meaningful helper issue must become a helper memory event.

A helper memory event records:

- helper name / family;
- version or candidate state;
- job the helper was supposed to do;
- exact symptom or failure output;
- wrong early interpretation, if any;
- root cause after inspection;
- fixed mechanism;
- rejected/superseded behavior;
- current correct behavior;
- proof run / receipt / report path;
- hashes when available;
- files touched;
- open follow-up work;
- return trigger.

## What the files must learn

The files should know more than the final slogan.

For each helper, the ledger should preserve enough issue data to prevent repeated amnesia:

- old versions and why they were superseded;
- parse failures, runtime failures, false PASS patterns, false FAIL patterns, and bad proof paths;
- route assumptions that caused the issue;
- the repair that actually fixed the issue;
- evidence that proved the repair;
- current approved route;
- remaining watch items.

The ledger should not become a raw junk pile. Raw logs may stay local or in proof receipts; the helper ledger should carry indexed, useful, searchable learning with links/hashes back to the evidence.

## Placement

Use the smallest correct lane:

- durable cross-helper rule: `BRAIN_LEARNING`;
- helper-specific living ledger: `HOUSE_WORK/WORK_SHED/HELPER_MEMORY_LEDGER`;
- template or reusable structure: `HOUSE_WORK/WORK_SHED/TEMPLATES`;
- relation/index map: `HOUSE_WORK/WORK_SHED/RELATION_MAPS`;
- issue dissection / power play: `HOUSE_WORK/WORK_SHED/SORTING_BENCH`;
- proof of save or run: `PROOF_HISTORY`;
- next unfinished helper work: `HOUSE_WORK/TODO`.

## Required behavior after future fixes

When a helper issue is fixed, do not only say what happened in chat.

Do this sequence:

1. Freeze the helper and issue.
2. Capture the exact symptom.
3. Identify the false blame or bad assumption, if present.
4. Identify the root cause.
5. Describe the repair mechanism.
6. Prove the repaired behavior.
7. Update the helper's living ledger/map.
8. Mark the old behavior rejected or superseded.
9. Record the return trigger for any remaining watch item.
10. Resume the original task only after the issue has a home.

## Blocked behavior

Blocked:

- explaining a helper failure only in chat;
- saving only the user's phrase while losing the actual failure stack;
- treating Code Gate PASS as job PASS;
- treating a probe as use proof;
- treating a false failure as user error without file inspection;
- creating a global memory dump that is not keyed by helper;
- deleting old failure knowledge instead of marking it superseded;
- broad helper audit when helper-by-helper refinery is enough.

## Success condition

A future worker should be able to open a helper ledger and see:

- what the helper used to do;
- what failed;
- what was falsely blamed;
- what changed;
- what is true now;
- what proof exists;
- what to do next if the same family fails again.

Short form:

Each helper gets a living memory. Fixes must teach the files, not only the chat.
