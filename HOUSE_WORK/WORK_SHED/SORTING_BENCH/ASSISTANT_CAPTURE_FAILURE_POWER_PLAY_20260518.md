# Assistant Capture Failure Power Play

Status: SORTING BENCH
Authority: support only; not command authority

## What Happened

The assistant followed the current lane:

deep scan -> checkpoint -> save -> summarize -> next

But the repeated anchor-behind pattern exposed a larger issue.

The assistant diagnosed it only after the user asked what had been exposed.

## Failure

The assistant treated a recurring drag loop as normal housekeeping instead of a discovery.

The assistant did not stop and capture the idea when it first became visible.

## Cause

The existing flow had proof/save discipline, but the capture interrupt was underdefined.

The assistant had capture tools, but no hard trigger forcing discovery capture during active work.

## Power Play

Install a Discovery Capture Interrupt Rule.

When a repeated pattern, better design, contradiction, hidden connection, or parent boss appears, stop long enough to capture it before continuing.

## Captured Candidate

Lifecycle State Change Sync Gate

## Current State

Discovery Capture Interrupt Rule: active learning candidate

Lifecycle State Change Sync Gate: Work Shed candidate

## Next Safe Move

Prove/save this capture first.

Then return to Main Boss 02 lifecycle state-machine design with sync propagation included.
