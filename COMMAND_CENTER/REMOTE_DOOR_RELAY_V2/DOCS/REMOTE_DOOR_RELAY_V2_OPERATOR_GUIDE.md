# Remote Door Relay V2 Operator Guide

Created: 2026-05-21

## Purpose

Remote Door Relay V2E is a quiet local ear and compact print mouth for one bounded Child Shell action:

`read_command_center_status`

It does not rebuild Child Shell. It only creates normal Level 1 child jobs in:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\DROPZONE`

The normal V2E flow uses a self-rotating one-use print. The old V2D token/nonce endpoints remain available only as rollback/fallback during this build.

## Start

From PowerShell:

```powershell
& 'C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\TOOLS\START_REMOTE_DOOR_V2.ps1'
```

The normal V2E start does not print a legacy token. If a rollback token is needed, run the start script with `-EnableLegacyToken` or use `New-RemoteDoorV2Token.ps1`. Legacy plaintext tokens are printed once and are not stored in `token_state.json`; only SHA256 hash and expiry are stored.

If the print vault is missing or locked, reseed only from local PowerShell:

```powershell
& 'C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\TOOLS\RESET_REMOTE_DOOR_V2_PRINT_LOCAL_ONLY.ps1'
```

The reset script prints only print hashes and a local recovery receipt path. It does not print raw prints or the local secret.

## Local Endpoints

```text
GET http://127.0.0.1:8792/door/v2/status
GET http://127.0.0.1:8792/door/v2/probe/<print>
GET http://127.0.0.1:8792/door/v2/readback/<job_id>
```

The actual port may be 8792 or the next nearby free port.

Use `/status` as the mouth. It returns compact status, latest proof fields, print state, current/next print hashes, and the next exact safe probe URL.

Use `/probe/<print>` once. It accepts only the current print, creates one Level 1 `read_command_center_status` child job, burns that print, promotes next to current, generates a new next print, and returns compact accepted/rejected proof.

The accepted probe response includes `readback_url`:

`/door/v2/readback/<job_id>`

Use that URL for final proof. It checks only the exact job id created by that probe, not the latest status latch.

Readback verdicts are:

- `PASS / RECEIPT FOUND`
- `WAITING / JOB CREATED BUT RECEIPT NOT FOUND YET`
- `FAIL / JOB REJECTED`
- `UNKNOWN / JOB NOT FOUND`

Legacy rollback endpoints:

```text
GET http://127.0.0.1:8792/door/v2/status?token=TOKEN
GET http://127.0.0.1:8792/door/v2/probe?token=TOKEN&nonce=NONCE
GET http://127.0.0.1:8792/door/v2/probe_async?token=TOKEN&nonce=NONCE
GET http://127.0.0.1:8792/door/v2/receipt?token=TOKEN&job_id=JOB_ID
```

These are not the normal V2E proof flow.

## Print Safety

Before status exposes a print, and before probe uses or rotates a print, the server writes a `PRE_PRINT_CHECKPOINT_*` file under:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\PRINT_VAULT_LOCAL_ONLY\PRINT_CHECKPOINTS`

The checkpoint is hashed, re-read, and verified before the print action continues.

Checkpoint retention rule:

- Keep the last 20 successful checkpoints active.
- Keep all failed/recovery checkpoints.
- Archive successful checkpoints older than 7 days into `PRINT_CHECKPOINTS\ARCHIVE`.
- Do not delete proof receipts.
- Do not run cleanup through V2.

Cleanup remains local/manual unless separately proved.

## Tunnel

Start a temporary Cloudflare quick tunnel only after local tests pass:

```powershell
& 'C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\TOOLS\START_REMOTE_DOOR_V2_TUNNEL.ps1' -Port 8792
```

The local server remains bound to `127.0.0.1`; the tunnel exposes only that local port.

Stop tunnel:

```powershell
& 'C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\TOOLS\STOP_REMOTE_DOOR_V2_TUNNEL.ps1'
```

Stop all V2 local processes:

```powershell
& 'C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\TOOLS\STOP_REMOTE_DOOR_V2.ps1'
```

## Boundary

- assistant arbitrary shell blocked
- raw shell blocked
- broad crawl blocked
- delete blocked
- cleanup through V2 blocked except local proved checkpoint archive
- repo write through V2 blocked
- git through V2 blocked
- Level 3 through V2 blocked
- ACTIVE_GUIDES rewrite blocked
- CURRENT_TRUTH_INDEX rewrite blocked
- doctrine rewrite blocked
- permission expansion blocked
- junction/symlink teleporter blocked

## Proof Rule

Do not claim chat-to-PC proof unless an external request to the temporary public URL uses a fresh print, creates the Child Shell job, and `/status` proves the OUTBOX receipt by SHA256.
