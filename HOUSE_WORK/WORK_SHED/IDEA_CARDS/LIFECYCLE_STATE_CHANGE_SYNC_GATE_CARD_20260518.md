# Lifecycle State Change Sync Gate Card

Status: CANDIDATE
Lane: Work Shed idea card
Authority: support only; not command authority

## Source Moment

Main Boss 02 lifecycle deep scan and follow-up discussion exposed a repeated loop:

save -> anchor behind -> anchor refresh -> save -> anchor behind again

## Problem Exposed

Proof/save changes current state, but anchor/current-state surfaces trail immediately unless separately refreshed.

That creates clean but repetitive checkpoint drag.

## Candidate Better System

Every lifecycle-changing save should include a sync-decision field.

Possible sync decisions:
- anchor updated now
- anchor may trail safely
- anchor refresh required as grouped follow-up
- status/index update enough for this move
- defer sync with explicit reason and return trigger

## Why It Matters

Lifecycle state without sync propagation is incomplete.

A rule/helper/file can move state cleanly, but the house still becomes foggy if current-state surfaces do not know what changed.

## Lifecycle State

candidate

## Authority Boundary

This card does not install the gate.

This card only captures the exposed candidate for later design/proof.

## Neighbor Risks

Touches:
- ACTIVE_ANCHOR.txt
- CURRENT_HOUSE_WORK_STATUS.md
- proof receipts
- lifecycle state machine
- Work Shed front shelf
- assistant operating behavior

## Proof Need

Needs a design/proof pass before becoming an active learning rule.

## Next Action

During Main Boss 02 lifecycle state-machine design, include sync propagation as a required section.
