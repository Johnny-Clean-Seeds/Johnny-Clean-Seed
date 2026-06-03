# Anchor Coverage Gate Save Workflow Rule

Date: 2026-06-02
Status: BRAIN LEARNING / SAVE WORKFLOW RULE / ACTIVE CANDIDATE
WorkKey: ANCHOR-COVERAGE-GATE-SAVE-WORKFLOW-20260602

## Rule

Before commit/save, if the batch includes mule handoff, root-sweep state, parking/return trigger, next-work route, or durable support files, the save route must run an anchor coverage gate.

## AnchorRequired=True means

The save route must prove:

- anchor exists;
- anchor lives in a durable non-shed path;
- anchor is included in the exact intended staged set;
- anchor is staged;
- anchor SHA256 is printed in the receipt;
- anchor points to the current object, current state, next move, and stop/hold condition.

## AnchorRequired=False means

The receipt must explicitly print:

`AnchorRequired=False`

and give the reason why no anchor is needed.

## Failure this prevents

Do not dump unresolved state onto the mule without a committed anchor. Do not leave next-work state as chat-only. Do not rely on memory-only continuity for root-sweep, mule, parking, or next-route batches.

## Boundary

This rule does not authorize broad refactor, delete, move, watcher, automation, doctrine rewrite, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, or WORK_SHED promotion by default.
