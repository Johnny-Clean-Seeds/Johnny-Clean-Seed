# Problem Solver Sweep and Single-Boss Collapse Rule — 20260521

## Status

ACTIVE PROVISIONAL RULE / SAVED AFTER LIVE FAILURE REPAIR

## Trigger

Use this when a task hits an execution issue, generated artifact issue, command issue, proof issue, or overcorrection issue.

## Required Sweep

1. Name the active issue.
2. Name the concrete root cause.
3. Capture the prevention rule or stack.
4. Patch the failing artifact or route.
5. Test the patched route.
6. Report the fix proof.
7. Return to the original task outcome.

## Collapse Requirement

During an active blocker, solve one boss only.

Do not fan out into broad infrastructure, extra architecture, rule-folder expansion, unrelated scripts, or multi-branch analysis unless the user explicitly selects that route.

## Live Example

The watcher failed because PowerShell variable names are case-insensitive and $Pid collided with the read-only automatic $PID variable.

Correct response:

Repair the watcher variable names only, rerun the watcher self-test, and return to the watcher task.

Incorrect response:

Build a large general Problem Solver infrastructure package while the active blocker is still only the PID collision.

## Balanced Rule

Problem solving should be connected, not sprawling.

Small blocker gets small patch.

Whole connected task gets one clean sweep.

Proof decides completion.
