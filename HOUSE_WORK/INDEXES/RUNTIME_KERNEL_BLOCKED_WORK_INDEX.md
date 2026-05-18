# Runtime Kernel Blocked Work Index

## Purpose

Track blocked runtime-kernel work so parked items remain retrievable and do not disappear.

## Core rule

Blocked work must have a reason, resume condition, source file, and next safe choice.

## Current blocked items

### Status Command Build

- state: BLOCKED
- reason: exact approval phrase was not given
- required phrase: APPROVE STATUS COMMAND BUILD DRY RUN
- source: HOUSE_WORK/PARKED/RUNTIME_KERNEL_STATUS_COMMAND_BUILD_BLOCKED_20260518_010116.md
- blocked creation: command file, /system, live runtime files, Hard Suit promotion
- resume condition: exact approval phrase or explicit different safe next boss
- current action: parked, not active

## Required fields for future blocked items

1. blocked_item_name
2. blocked_state
3. blocked_reason
4. source_file
5. required_resume_condition
6. forbidden_movement
7. next_safe_choice
8. close_or_review_condition

## Boundary

This index is not authority.

This index is not proof.

This index does not unblock work.

This index does not approve command creation.

This index does not create /system.

This index does not create live runtime files.

This index does not promote anything to Hard Suit.
