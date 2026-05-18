# Lifecycle State Change Sync Gate Rule

Status: ACTIVE LEARNING CANDIDATE
Authority: assistant operating support; not command authority by itself

## Problem

Mr.Kleen has a repeated drag loop:

save -> anchor behind -> anchor refresh -> save -> anchor behind again

The issue is not that anchor refresh is wrong.

The issue is that every lifecycle-changing save needs a sync decision so the house knows whether anchor must update, status/index is enough, or trailing is safe.

## Rule

Every risky proof/save that changes lifecycle state must include a sync decision.

Required sync decision field:

- anchor updated now
- anchor refresh required as grouped follow-up
- anchor may trail safely
- status/index update is enough for this move
- defer sync with reason and return trigger

## When Anchor Must Update

Anchor must update when:
- active ball changes
- next allowed move changes materially
- blocked moves change materially
- authority chain changes
- current base becomes misleading without anchor
- user needs a handoff/resume point
- a major boss closes or opens
- proof/save changes what the assistant is allowed to do next

## When Status/Index Is Enough

Status/index may be enough when:
- a support-only file is added
- a Work Shed item is captured but not promoted
- a receipt is added for proof history
- a helper is reviewed but not moved/promoted
- no active ball changes
- no authority changes
- no next allowed move changes

## When Anchor May Trail Safely

Anchor may trail safely only if:
- the final response states the current commit
- git status is clean
- origin/main matches HEAD
- status/index records the save
- no active authority changed
- no user handoff depends on the stale anchor
- the next move does not require anchor as the only source of truth

## Grouped Follow-Up

If anchor refresh is required as grouped follow-up, the receipt must say so.

The next move should then refresh anchor before unrelated work.

## Boundary

This rule does not remove ACTIVE_ANCHOR.txt.

This rule does not make status/index command authority.

This rule does not allow stale anchor to hide real state.

This rule only prevents blind anchor-refresh loops by forcing a sync decision after lifecycle-changing saves.

## Current Application

The Discovery Capture Interrupt Rule save changed assistant behavior and captured the Lifecycle State Change Sync Gate as a candidate.

That save changed current working state.

Sync decision for this design pass:

anchor refresh is not the first move.

Design/prove the sync gate first because the repeated anchor-refresh loop is the exposed boss.
