# Parent Child Map Soft Test

## Purpose

Soft Suit test candidate for Runtime Kernel Boss 3.

This file does not implement a runtime kernel.

This file does not create /system.

This file does not create commands.

It defines the smallest candidate parent/child map shape that could let brain parts report upward, stay contained, and avoid becoming a flat pile.

## Candidate status

Status: active-soft-suit-candidate

Boss stack source:

- HOUSE_WORK/RUNTIME_KERNEL_BOSS_STACK_20260517_234653.md

Neighbor dependencies:

- BRAIN/SUIT/UNIVERSAL_STATE_MACHINE_SOFT_TEST.md
- BRAIN/SUIT/SINGLE_SYSTEM_LEDGER_SOFT_TEST.md

## Problem

The brain has many parts that relate to each other:

- source ore feeds boss stacks
- boss stacks open runs
- runs create proof
- proof creates judgments
- judgments create next actions
- Soft Suit tests candidates
- Hard Suit holds proven operating load
- support links inform but do not control
- parked material can return later

Without a parent/child map, the ledger can become a flat event pile and recursive work can lose containment.

## Candidate map principle

A parent/child map should show containment and reporting.

It should not replace the ledger.

It should not replace proof.

It should not replace source ore.

It should not create authority by itself.

It should answer:

- what does this item belong to?
- what depends on this item?
- where does this item report?
- what children must close before parent closes?
- what parent boundary must this child obey?

## Minimum map fields

1. node_id
2. node_name
3. node_type
4. node_path
5. parent_id
6. child_ids
7. lane
8. current_state
9. authority_level
10. proof_path
11. ledger_event_ids
12. open_child_count
13. blocked_child_count
14. close_condition
15. next_action

## Node types

Allowed starter node types:

- brain
- source_ore
- boss_stack
- run
- proof
- soft_suit_candidate
- hard_suit_pack_item
- support_link
- learning_rule
- parked_item
- guide
- checker
- bridge

## State-machine fit

The map must use Universal State Machine language for current_state:

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

## Ledger fit

The map may point to ledger_event_ids.

The map does not replace ledger events.

The ledger records movement.

The parent/child map records containment and reporting.

## Authority boundary

A parent/child map is not authority by itself.

A parent/child map is not proof by itself.

A parent/child map does not authorize promotion.

A parent/child map cannot override lane rules, proof gates, Hard Suit gates, or active guide authority.

## Forbidden movement

Do not treat parent as owner of truth without authority.

Do not let child close parent unless parent close condition is met.

Do not let parent promote child without proof.

Do not let the map flatten all lanes into one pile.

Do not create /system from this test.

Do not create commands from this test.

Do not promote this map to Hard Suit yet.

## Fit check

This candidate fits only if it:

- keeps recursive parts contained
- supports upward reporting
- protects child boundaries
- supports close conditions
- connects to ledger without replacing ledger
- uses state-machine language
- does not create false authority
- helps avoid flat-pile confusion

## Close condition

This Soft Test passes only if the parent/child map can describe containment without replacing ledger, proof, source ore, or authority.
