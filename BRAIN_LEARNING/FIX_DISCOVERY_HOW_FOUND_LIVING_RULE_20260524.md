# Fix Discovery / How-Found Living Rule

Status: LIVING SUPPORT RULE / ADOPT-ADAPT LEARNING / NOT DOCTRINE
Date: 2026-05-24

## Purpose

When a fix, flaw, anomaly, failure, or useful idea is found during house work, do not only save the fix.

Also save how it was found.

The discovery path is part of the lesson.

## Core Rule

Every found fix needs a how-found note:

`found while -> signal -> evidence -> what happened -> why it happened -> fix -> adopt/adapt/park/reject -> proof -> next trigger`

This turns accidents, scan failures, odd signals, and user corrections into living learning instead of loose hindsight.

## Trigger

Fire when:

- a scan finds a repeated pattern;
- a gate fails or judges the wrong object;
- a command errors;
- a PowerShell parser error appears;
- a receipt claim does not match file reality;
- a user correction reveals a missed rule;
- a flatline run reveals a stable root;
- a creative/wildcard idea becomes a real candidate;
- a map/sign mismatch is discovered;
- any "fix this going forward" behavior appears.

## Required How-Found Ledger

| Field | Meaning |
|---|---|
| Fix ID | Short name for the fix. |
| Found while | What work was being done when it appeared. |
| Signal | Error, repeated phrase, mismatch, missing proof, user correction, or anomaly. |
| Evidence | File path, command output, receipt, hash, search count, or observed behavior. |
| What happened | Plain event. |
| Why it happened | Best supported cause, or UNKNOWN if not proven. |
| House family | Gate, proof, source custody, creative, mule, map/sign, script/tool, worker symptom, or other. |
| Decision | ADOPT, ADAPT, PARK, REJECT, PROOF FIRST, or WATCH AGAIN. |
| Fix | The smallest behavior or file-side change. |
| Proof | What proves the fix touched the active issue. |
| Next trigger | When to use it again. |

## If Things Go Wrong

Do not rush into apology, defense, or patching.

Ask:

1. What happened?
2. What was I doing when it happened?
3. What rule or guard should have fired?
4. What evidence proves the cause?
5. Was this a tool error, command-shape error, gate-role error, proof mismatch, source custody issue, or capability fit issue?
6. What is the smallest correction?
7. How do I apply it to the same active work?
8. What proof shows the correction worked?

If the cause is not proven, label it UNKNOWN and keep inspecting.

## Live Discovery Captured

Fix ID:

`POWERSHELL_FOREACH_PIPE_GROUPING_GUARD_20260524`

Found while:

Running broad house pattern scans for the 2026-05-24 evidence/gate inspection.

Signal:

PowerShell `ParserError`: an empty pipe element appeared after a `foreach` script block in a one-line command.

What happened:

The scan attempted to pipe the output of a `foreach` block directly into `Format-Table`, but the command shape was parsed incorrectly.

Why it happened:

The one-liner did not assign the `foreach` output to a variable or wrap the expression before piping. The shell treated the pipe after the script block as an empty pipeline element.

Fix:

For generated scan tables, assign rows first, then pipe:

```powershell
$rows = foreach ($item in $items) {
  [pscustomobject]@{ Name = $item }
}
$rows | Format-Table -AutoSize
```

Decision:

ADOPT AS TOOL-SHAPE GUARD.

Proof:

The corrected scan reran successfully and produced pattern and lane signal counts.

Next trigger:

Any PowerShell one-liner that builds objects in `foreach` and then pipes to formatting, export, or selection.

## Adopt / Adapt Rule

When a found fix matches the house flow:

- ADOPT if it fits current lanes with little change.
- ADAPT if the mechanic is useful but the shape must change.
- PARK if useful but not needed now.
- REJECT if it bloats, conflicts, or misroutes.
- PROOF FIRST if the idea may be right but has not touched the active issue.
- WATCH AGAIN if it appears once but may be a pattern.

## Boundary

- Not doctrine.
- Not an ACTIVE_GUIDES rewrite.
- Not a CURRENT_TRUTH_INDEX rewrite.
- Not a reason to save every observation.
- Not a replacement for receipts, Proof Gate, Worker Symptom Diagnostic, or Issue Encounter Rule Repair Latch.

## Proof

This rule is proved when future work reports not only the fix, but also how the fix was discovered and what changed because of it.
