# Safe Coding Helper Seed Rule V0.1

Status: PUBLIC_NOTE / SAFE_CODING_HELPER_SEED / ACTIVE_LIMITED_SUPPORT / NOT_DOCTRINE
Date: 2026-06-13

Purpose:
Teach coding helpers to start small, narrow, and safe before they touch a project. Coding helpers can be dangerous, so the first live shape is a seed packet maker and dry-task lane, not an autonomous code editor.

## Core Rule

Coding helper work starts with one narrow job, one target surface, one expected output, one proof path, one failure path, and one DoesNotProve.

No coding helper may edit project files until the route has a scoped packet, allowed actions, blocked actions, evidence needs, and explicit user or higher-route authority.

## Current Safe Seed

Current tool:

`TOOLS\New-SafeCodingHelperPacket.ps1`

Default behavior:

- creates a safe coding helper packet outside the Git-tracked repo by default;
- writes a one-job contract;
- blocks mutation by default;
- records allowed actions, blocked actions, proof needed, failure path, and DoesNotProve;
- writes a small fixture suggestion;
- writes a narrow intelligence route, risk gates, decision table, and test ladder;
- does not edit project files, run generated code, install packages, commit, push, or promote doctrine.

## Narrow Intelligence Order

Coding helpers become more useful by adding small proof layers, not by gaining broad autonomy.

Required order:

1. name the exact coding task;
2. name the target surface and whether it is local, public, generated, or unknown;
3. classify risk before mutation;
4. choose the next helper stage from the small chain;
5. name proof needed before action;
6. ask, block, or plan-only when authority is missing;
7. validate the packet before any later coding helper uses it.

Current packet reports:

- `SAFE_CODING_HELPER_CHAIN.csv`
- `SAFE_CODING_MICRO_ROUTE.csv`
- `SAFE_CODING_RISK_GATES.csv`
- `SAFE_CODING_DECISION_TABLE.csv`
- `SAFE_CODING_TEST_LADDER.csv`
- `SAFE_CODING_ANCHOR_MAP.csv`
- `SAFE_CODING_KNOWLEDGE_LEDGER.csv`
- `SAFE_CODING_PICK_RULES.csv`

## Coding Anchor Map

Use a small map/ledger before making new coding helpers.

The map may teach helpers what to pick where and when, but it must stay anchored:

- each row has one anchor, one use-when signal, one blocked-when signal, one evidence need, and one DoesNotProve;
- no row may authorize mutation by itself;
- if the map grows beyond what can be scanned quickly, make a board-clean task instead of adding more rows;
- stale rows must be updated or retired before new rows are piled on top.

## Small Narrow Chain

Coding helpers should link as small helpers:

1. `read_context_helper`: read only the named files or folders.
2. `plan_patch_helper`: describe the smallest patch without editing.
3. `fixture_helper`: create or name a tiny safe fixture.
4. `parse_lint_helper`: run parser/lint/read-only checks.
5. `apply_patch_helper`: edit only after authority and proof.
6. `verify_helper`: rerun exact checks and capture evidence.
7. `receipt_helper`: write what changed, proof, and DoesNotProve.

Do not combine all jobs into one broad helper unless a later proof shows the chain is too fragmented.

## Validation

Current validator:

`TOOLS\Test-SafeCodingHelperPacket.ps1`

Use it after packet creation. It checks that the packet has required sections, mutation remains closed, and the chain ledger includes the narrow helper order.

Validation does not authorize edits.

## Existing Helper Correction Rule

If a living coding helper is broad, vague, self-promoting, mutation-first, or missing a blocked-actions section, treat it as `HELPER_STALE_DETECTED` or `HELPER_GAP_DETECTED`.

Correct by narrowing the smallest unsafe hook first:

- add one job;
- add blocked actions;
- add dry task;
- add proof needed;
- add DoesNotProve;
- keep mutation closed until authorized.

## Blocked Actions

Blocked by this seed:

- editing project code;
- writing into active source folders;
- running generated code;
- package install;
- network calls;
- deletion, move, rename, overwrite, cleanup;
- Git/GitHub commit, push, pull, fetch, branch, PR;
- doctrine promotion;
- automation or watcher work.

## Allowed Actions

Allowed by this seed:

- create a packet in the configured output folder;
- name the coding task, target surface, language, risk, and proof;
- suggest a tiny fixture;
- mark missing helper needs;
- produce a read-only next action.

## Does Not Prove

This rule does not prove a coding helper is safe to edit, run code, install dependencies, change the project, or publish anything. It only creates the first safe coding-helper packet and keeps the route narrow.
