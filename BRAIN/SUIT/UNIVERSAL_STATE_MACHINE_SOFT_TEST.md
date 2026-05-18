# Universal State Machine Soft Test

## Purpose

Soft Suit test candidate for Runtime Kernel Boss 1.

This file does not implement the runtime kernel.

This file defines the smallest candidate state machine to test whether every seed-like part can move through one shared legal flow without changing the Clean Seed / Clean Milk core.

## Candidate status

Status: active-soft-suit-candidate

Boss stack source:

- HOUSE_WORK/RUNTIME_KERNEL_BOSS_STACK_20260517_234653.md

## Problem

The brain has many parts:

- seeds
- guides
- checkers
- bridges
- proof files
- parked ideas
- source ore
- suit candidates
- boss stacks
- learning rules

The current weakness is that these parts can be described cleanly but may not share one enforceable movement path.

## Candidate state set

Minimum proposed states:

1. captured
2. classified
3. routed
4. active
5. blocked
6. parked
7. proof-needed
8. judged
9. promoted
10. closed
11. archived

## State meanings

captured:
The item has been seen and saved from being lost. It is not active and not proven.

classified:
The item has type, lane, source/context, and rough purpose.

routed:
The item has a destination lane and next action.

active:
The item is currently being worked or tested.

blocked:
The item cannot move because a condition, proof, permission, or dependency is missing.

parked:
The item is useful but not current. It remains retrievable.

proof-needed:
The item needs evidence before it can be judged, promoted, closed, or used as authority.

judged:
The item has been checked against its pass/fail/partial/blocked condition.

promoted:
The item has earned a stronger placement, such as Hard Suit, active guide, index, or operating rule.

closed:
The item has a clean ending and no open movement remains.

archived:
The item remains as history/source/proof, not active operating weight.

## Allowed movement

captured -> classified
classified -> routed
routed -> active
routed -> parked
routed -> blocked
active -> proof-needed
active -> blocked
active -> judged
proof-needed -> judged
judged -> promoted
judged -> parked
judged -> blocked
judged -> closed
closed -> archived
parked -> classified
blocked -> routed

## Forbidden movement

captured -> promoted

captured -> active without classification

active -> promoted without proof/judgment

parked -> promoted without reclassification and proof

blocked -> closed without reason

source ore -> active file without suit/proof gate

Soft Suit -> Hard Suit without proof

Hard Suit support link -> active pack slot without promotion proof

## Test question

Can this state set describe the movement of current Clean Seed parts without forcing a doctrine change?

## Fit check

This candidate fits only if it:

- protects capture from promotion
- protects parked material from deletion
- protects proof from being skipped
- gives blocked items a recovery route
- lets closed items archive without active weight
- can apply to seeds, guides, proof, source ore, suit items, boss stacks, and learning rules
- does not create a new command surface yet

## Next action

Walk this state set around the current brain.

Check whether it fits:

- capture helper pack
- runtime kernel source ore
- boss stack files
- Soft Suit
- Hard Suit
- proof history
- learning rules
- parked/support candidates

## Close condition

This Soft Test passes only if the state set can explain current movement without violating existing gates.

It does not promote itself.
