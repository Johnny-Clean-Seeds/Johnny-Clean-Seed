# Single System Ledger Soft Test

## Purpose

Soft Suit test candidate for Runtime Kernel Boss 2.

This file does not implement a runtime kernel.

This file does not create /system.

This file does not create commands.

It defines the smallest candidate ledger shape that could let brain events share one event spine without replacing proof history, source ore, learning files, boss stacks, or suit files.

## Candidate status

Status: active-soft-suit-candidate

Boss stack source:

- HOUSE_WORK/RUNTIME_KERNEL_BOSS_STACK_20260517_234653.md

Neighbor dependency:

- BRAIN/SUIT/UNIVERSAL_STATE_MACHINE_SOFT_TEST.md

## Problem

The brain has many event-like movements:

- idea captured
- source ore stored
- boss ranked
- Soft Suit candidate opened
- proof need found
- proof passed
- proof failed
- guardrail found
- guardrail fixed
- item parked
- item promoted
- item closed
- item archived

These events are currently recorded in files, proofs, run notes, and commits, but there is no single ledger shape that can describe them consistently.

## Candidate ledger principle

The ledger should not replace existing lanes.

It should index movement.

A ledger entry is a pointer and event record, not the full truth body.

## Minimum ledger entry fields

1. event_id
2. timestamp
3. event_type
4. subject_name
5. subject_path
6. prior_state
7. new_state
8. lane
9. source_context
10. proof_path
11. decision
12. next_action
13. parent_event
14. related_events
15. status

## Event types

Allowed starter event types:

- capture
- classify
- route
- activate
- park
- block
- proof_needed
- judge
- promote
- close
- archive
- guardrail_found
- guardrail_fixed
- next_run_opened
- next_run_closed

## State-machine fit

The ledger must use the Universal State Machine language.

Valid states include:

- captured
- classified
- routed
- active
- blocked
- parked
- proof-needed
- judged
- promoted
- closed
- archived

## Boundary

The ledger is not doctrine.

The ledger is not proof by itself.

The ledger does not replace proof files.

The ledger does not replace source ore.

The ledger does not replace active guides.

The ledger does not authorize promotion.

The ledger records movement so the brain can find, trace, and review movement later.

## Forbidden movement

Do not treat a ledger entry as proof.

Do not treat a ledger entry as authority.

Do not let the ledger become a junk drawer.

Do not store full long files inside ledger rows.

Do not create commands from this test.

Do not create /system from this test.

Do not promote this ledger to Hard Suit yet.

## Fit check

This candidate fits only if it:

- can point to proof without becoming proof
- can point to source ore without becoming source ore
- can record state movement without deciding state movement
- can connect related events without forcing all files into one folder
- can support next runs and boss stacks
- can work with parent/child map later
- keeps evidence, decision, and authority separate

## Close condition

This Soft Test passes only if a single ledger shape can describe current movement without collapsing lanes or creating false authority.
