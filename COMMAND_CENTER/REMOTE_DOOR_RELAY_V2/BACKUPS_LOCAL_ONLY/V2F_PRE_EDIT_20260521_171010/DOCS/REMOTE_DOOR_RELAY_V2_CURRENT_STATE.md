# Remote Door Relay V2 Current State

Created: 2026-05-21

## State

V2 is a new lane under:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2`

It is designed as a small 127.0.0.1 listener plus optional temporary tunnel.

V2E changes the normal remote proof flow from manual token/nonce handling to a self-rotating one-use print. The PC is the print maker.

## Allowed Action

`read_command_center_status`

## V2E Required Proof

1. Local `/door/v2/status` shows `print_state: READY` and a `next_probe_url`.
2. Wrong print rejects.
3. Used print rejects.
4. Expired print rejects when tested by a controlled local-only reseed.
5. `/door/v2/probe/<print>` creates exactly one Level 1 `read_command_center_status` Child Shell job.
6. Local `/door/v2/status` refreshes from actual OUTBOX/PROCESSED/REJECTED evidence and shows `PROCESSED_PASS` plus receipt SHA256.
7. The used print is burned, next print is promoted to current, and a new next print is generated.
8. The local-only reset/reseed script is proved or dry-run proved.
9. Temporary tunnel status/probe/status proof works after local proof.

## Latest Proof Latch

`/door/v2/probe/<print>` writes a pending latch to `LATEST_REMOTE_DOOR_RESULT.json`, then `/door/v2/status` refreshes that latch from actual Child Shell evidence.

`/door/v2/status` refreshes and returns the latest proof fields:

`latest_job_id`, `latest_state`, `latest_receipt_sha256`, `latest_receipt_path`, `latest_processed_path`, `latest_rejected_path`, `latest_updated_at`, and `latest_boundary`.

The proof flow is now:

`/door/v2/status -> /door/v2/probe/<print> -> /door/v2/status`

The old V2D token/nonce routes remain present as rollback/fallback during the V2E build:

`/door/v2/probe`, `/door/v2/probe_async`, and `/door/v2/receipt`.

They are not the normal V2E proof flow.

## Print Vault

The local-only vault lives under:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\PRINT_VAULT_LOCAL_ONLY`

The vault holds current/next print metadata, a local secret, a ledger, used-print records, checkpoints, and local recovery receipts. Vault files are local-only and must not be committed to Mr.Kleen.

`/door/v2/status` may expose the current usable print only as the exact `next_probe_url`. It also exposes print hashes and proof fields, but it does not dump vault files or the local secret.

## Print Checkpoint Rule

Before status arms/exposes a print, and before probe uses or rotates a print, the server writes a `PRE_PRINT_CHECKPOINT_*` file, hashes it, re-reads it, and verifies the hash. If checkpoint verification fails, the print is not exposed or rotated.

Checkpoint retention rule:

- Keep the last 20 successful checkpoints active.
- Keep all failed/recovery checkpoints.
- Archive successful checkpoints older than 7 days into `PRINT_CHECKPOINTS\ARCHIVE`.
- Do not delete proof receipts.
- Do not run cleanup through the remote V2 endpoint.

Cleanup remains a local manual rule unless separately proved.

## Local-Only Reset

Use only from local PowerShell on the PC:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\TOOLS\RESET_REMOTE_DOOR_V2_PRINT_LOCAL_ONLY.ps1`

It creates fresh current/next prints, preserves the ledger by appending, writes a local recovery receipt, and prints only hashes. It is not callable through Remote Door.

## Current Boundary

V2E does not add arbitrary shell, raw command, broad crawl, delete, cleanup through V2 except local proved checkpoint archive, repo write, git write, Level 3 save, doctrine rewrite, permission expansion, or junction/symlink teleporters.
