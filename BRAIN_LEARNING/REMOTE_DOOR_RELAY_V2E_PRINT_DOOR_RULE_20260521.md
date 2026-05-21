# Remote Door Relay V2E Print Door Rule

Date: 2026-05-21

## Rule

When Remote Door proof needs repeated outside access, use a PC-made one-use print instead of asking the user or mule to carry manual token/nonce blocks.

## Required Shape

- `/door/v2/status` is the compact mouth.
- `/door/v2/status` refreshes latest latch state from actual Child Shell OUTBOX, PROCESSED, and REJECTED evidence.
- `/door/v2/status` returns the next safe probe URL at runtime, plus current/next print hashes.
- `/door/v2/probe/<print>` accepts only the current print.
- A used, wrong, or expired print must reject.
- An accepted print creates exactly one Level 1 `read_command_center_status` Child Shell job.
- After the job is safely written, the current print is burned, next is promoted to current, and a new next print is generated.

## Checkpoint Rule

Before status exposes a print, and before probe uses or rotates a print, V2E must write a pre-print checkpoint, hash it, re-read it, and verify it.

If checkpoint verification fails, the print must not be exposed, used, burned, or rotated.

## Local-Only Reset Rule

Print recovery is physical-PC-only.

Use:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\TOOLS\RESET_REMOTE_DOOR_V2_PRINT_LOCAL_ONLY.ps1`

The reset/reseed tool must not be callable through Remote Door, must preserve ledger history by appending, must write a local recovery receipt, and must print only hashes.

## Rollback Lane

The old V2D token/nonce routes can remain as rollback/fallback during the V2E build, but they are not the normal V2E proof flow.

## Boundary

This rule does not add arbitrary shell, raw command, broad crawl, delete, repo write through V2, git through V2, Level 3 through V2, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, doctrine rewrite, permission expansion, or junction/symlink teleporter.
