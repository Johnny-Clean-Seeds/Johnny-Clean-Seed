# Whole-House Outside Review Handoff

Date: 2026-05-19
Base: main @ 74848c3
Active boss: Q-20260519-009 - Whole-House Review / outside-review handoff
Lane: HOUSE_WORK / WORK_SHED / AGENT_HANDOFFS

## Purpose

Give an outside reviewer a bounded review order for Mr.Kleen's current house state.

This is a review request only. It is not permission to edit files, rewrite doctrine, promote tools, change CURRENT_TRUTH_INDEX, or treat source reports as authority.

## Current state summary

Recent lanes closed:
- Mule-leftover custody lane closed.
- Newer mule/work material from 2026-05-17 through now is tracked and clean.
- Older material is tracked/clean but should remain stale/source-ore/old notes unless pulled back with a reason.
- Checker-candidate batch closed as PASS AS CHECKER-CANDIDATE BATCH.
- Checker promotion criteria reviewed.
- Verdict on checker batch: do not promote yet.
- Current Work Queue stale pointer repaired.
- Active boss is now Whole-House Review / outside-review handoff.

## What to review

Review the current house for:
1. stale active pointers,
2. contradiction between status files and queue files,
3. unclosed lanes,
4. source reports being treated as authority,
5. tools/checkers being promoted too early,
6. incoming files mixed into active house without custody,
7. doctrine/guide drift,
8. proof-history items being mistaken for active rules,
9. missing next-action clarity,
10. places where a smaller review should happen before a larger change.

## What not to do

Do not:
- edit active guides,
- rewrite doctrine,
- change CURRENT_TRUTH_INDEX,
- promote checker candidates,
- install tools,
- delete old material,
- treat older source-ore as current truth,
- expand the system just because something is interesting,
- recommend broad cleanup without a bounded inspection path.

## Required reviewer output

Return a report with these sections:

1. Current-state readback
   - What appears to be the current base and active boss?
   - What files/lanes support that conclusion?

2. Top 10 risks
   - List in priority order.
   - For each risk, name the lane, evidence, and why it matters.

3. Stale-pointer check
   - Any queue/status/index/anchor mismatch.
   - Any closed lane still appearing active.

4. Promotion-risk check
   - Any object that looks promoted too early.
   - Any checker/tool/rule that should stay candidate-only.

5. Custody check
   - Any incoming/source/mule material that lacks a clean lane.
   - Any old material being treated as new.

6. Smallest next move
   - Recommend one next action only.
   - It must be small, reversible, and proofable.

7. Do-not-touch list
   - Name anything that should not be edited yet.


## Mule Dump Folder Contract

The outside reviewer/mule must return all output as one clean batch.

Required output shape:

HOUSE_WORK\WORK_SHED\AGENT_OUTPUTS\WHOLE_HOUSE_REVIEW_RETURN_20260519_001

Inside that folder, include:

1. MANIFEST.md
   - lists every returned file,
   - gives the intended read order,
   - says what each file is for,
   - marks each item as report, evidence, candidate, source-ore, or do-not-use.

2. REVIEW_REPORT.md
   - the main review report.

3. OPTIONAL_SUPPORT/
   - any supporting notes, extracts, tables, or evidence.

The mule must not scatter files across the house.

The mule must not require a fresh explanation every run. This handoff is the operating context. The mule is being used as a bounded outside tool in the Mr.Kleen flow.

The mule must not:
- edit the brain directly,
- commit,
- push,
- change active guides,
- change CURRENT_TRUTH_INDEX,
- promote tools,
- install doctrine,
- mix old/source-ore material into active work,
- return loose unnamed files.

The assistant will:
- receive the dump folder as one custody object,
- inspect MANIFEST.md first,
- test the batch as a suit/safe-bin object,
- only then decide what enters the actual house,
- preserve order and custody during intake.

## Output lane

The reviewer should return the report as text or as a file for:

HOUSE_WORK\WORK_SHED\AGENT_OUTPUTS

The reviewer does not commit, push, delete, promote, or rewrite.

## Boundary

This handoff is a review order only.
No outside report has been received yet.
No doctrine rewrite.
No active guide rewrite.
No checker promotion.
No tool installation.
No CURRENT_TRUTH_INDEX change.

