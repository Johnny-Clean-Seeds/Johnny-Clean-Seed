# Whole-House Outside Review Handoff

Date: 2026-05-19
Base: main @ 4c0f29f
Full base hash: 4c0f29ffeec4811b67e8ed1d52536ae939a22ddf
Active boss: Q-20260519-009 - Whole-House Review / outside-review handoff
Lane: HOUSE_WORK / WORK_SHED / AGENT_HANDOFFS
Status: outside reviewer handoff, report-only, not authority

## Purpose

Give an outside reviewer a bounded review order for Mr.Kleen's current house state.

This is a review request only.

The outside reviewer is not authority.
The outside reviewer output is source material.
The outside reviewer output is not doctrine.

## Required source routing

Read orientation in this order:

1. CURRENT_TRUTH_INDEX.txt
2. ACTIVE_ANCHOR.txt
3. HOUSE_WORK\WORK_SHED\QUEUE\CURRENT_WORK_QUEUE.md
4. This handoff file

CURRENT_TRUTH_INDEX.txt is orientation and source routing.
ACTIVE_ANCHOR.txt holds the active ball, next allowed move, and blocked moves.
The queue keeps attention narrow.
This handoff gives the outside reviewer the bounded review job.

## Current state summary

Current active ball:
Q-20260519-009 - Whole-House Review / outside-review handoff.

Recent lanes closed or held:

- Mule-leftover custody lane closed.
- Newer mule/work material from 2026-05-17 through now is tracked and clean.
- Older material is tracked/clean but should remain stale/source-ore/old notes unless pulled back with a reason.
- Root CHECK_*.ps1 checker batch is closed/parked as a tested checker-candidate batch.
- Checker promotion criteria were reviewed.
- Verdict on checker batch: do not promote yet.
- Prior-Mistake Retrieval And Route Selection Gate Soft Suit candidate was created.
- Prior-Mistake Retrieval And Route Selection Gate live test returned PASS WITH WATCH.
- Prior-Mistake Soft Suit remains a tested candidate only.
- No Hard Suit promotion happened.
- No doctrine rewrite happened.
- No active guide rewrite happened.
- No CURRENT_TRUTH_INDEX change happened.
- No tool promotion happened.
- No automation, full lesson index, knowledge graph, or dashboard was built.
- ACTIVE_ANCHOR.txt was refreshed after the Soft Suit test to point at Q-20260519-009.

## What to review

Review the current house for:

1. stale active pointers,
2. contradiction between status files, anchor files, and queue files,
3. unclosed lanes,
4. source reports being treated as authority,
5. tools/checkers being promoted too early,
6. incoming files mixed into active house without custody,
7. doctrine/guide drift,
8. proof-history items being mistaken for active rules,
9. missing next-action clarity,
10. places where a smaller review should happen before a larger change.

## What not to do

Do not edit files.
Do not commit.
Do not push.
Do not promote tools.
Do not edit active guides.
Do not rewrite doctrine.
Do not change CURRENT_TRUTH_INDEX.
Do not change ACTIVE_ANCHOR.
Do not promote checker candidates.
Do not install tools.
Do not install doctrine.
Do not delete old material.
Do not treat older source-ore as current truth.
Do not treat mule reports as authority.
Do not treat outside reviewer output as doctrine.
Do not expand the system just because something is interesting.
Do not recommend broad cleanup without a bounded inspection path.

## Required reviewer output

Return a report with these sections:

1. Current-state readback
   - What appears to be the current base and active boss?
   - What files/lanes support that conclusion?
   - Any mismatch between CURRENT_TRUTH_INDEX, ACTIVE_ANCHOR, queue, status, and receipts?

2. Top 10 risks
   - List in priority order.
   - For each risk, name the lane, evidence, and why it matters.

3. Stale-pointer check
   - Any queue/status/index/anchor mismatch.
   - Any closed lane still appearing active.
   - Any stale commit/base wording that could mislead the next worker.

4. Promotion-risk check
   - Any object that looks promoted too early.
   - Any checker/tool/rule/Soft Suit that should stay candidate-only.

5. Custody check
   - Any incoming/source/mule material that lacks a clean lane.
   - Any old material being treated as new.
   - Any source material being treated as authority.

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

3. OPTIONAL_SUPPORT\
   - any supporting notes, extracts, tables, or evidence.

The mule must not scatter files across the house.

The mule must not require a fresh explanation every run. This handoff is the operating context. The mule is being used as a bounded outside tool in the Mr.Kleen flow.

The mule must not:
- edit the brain directly,
- commit,
- push,
- change active guides,
- change CURRENT_TRUTH_INDEX,
- change ACTIVE_ANCHOR,
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

The reviewer should return the report as one folder only:

HOUSE_WORK\WORK_SHED\AGENT_OUTPUTS\WHOLE_HOUSE_REVIEW_RETURN_20260519_001

The reviewer does not commit, push, delete, promote, or rewrite.

## Boundary

This handoff is a review order only.
No outside report has been received yet.
No doctrine rewrite.
No active guide rewrite.
No checker promotion.
No tool installation.
No CURRENT_TRUTH_INDEX change.
No ACTIVE_ANCHOR change by the reviewer.
Outside reviewer output is source material.
Outside reviewer output is not authority.
Outside reviewer output is not doctrine.
