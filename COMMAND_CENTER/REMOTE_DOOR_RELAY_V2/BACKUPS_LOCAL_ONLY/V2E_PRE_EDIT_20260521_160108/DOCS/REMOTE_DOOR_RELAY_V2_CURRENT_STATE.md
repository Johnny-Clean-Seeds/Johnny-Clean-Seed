# Remote Door Relay V2 Current State

Created: 2026-05-21

## State

V2 is a new lane under:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2`

It is designed as a small 127.0.0.1 listener plus optional temporary tunnel.

## Allowed Action

`read_command_center_status`

## Required Proof

1. Local status endpoint works.
2. Wrong token rejects.
3. Duplicate nonce rejects.
4. Local async probe returns quickly with a job id.
5. Local status readback shows the latest latched job id, receipt path, and receipt SHA256.
6. Temporary tunnel status works.
7. Temporary tunnel async probe creates a Child Shell OUTBOX receipt from an external request, then the same status URL proves it through the latest latch.

## Latest Proof Latch

`/door/v2/probe_async` writes `LATEST_REMOTE_DOOR_RESULT.json`.

`/door/v2/status` refreshes and returns the latest proof fields:

`latest_job_id`, `latest_state`, `latest_receipt_sha256`, `latest_receipt_path`, `latest_updated_at`, `latest_nonce_hash`, and `latest_boundary`.

The proof flow is now:

`/door/v2/status -> /door/v2/probe_async -> /door/v2/status`

## Current Boundary

V2 does not add arbitrary shell, raw command, broad crawl, delete, cleanup, repo write, git write, Level 3 save, doctrine rewrite, permission expansion, or junction/symlink teleporters.
