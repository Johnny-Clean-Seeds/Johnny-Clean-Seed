# Remote Door Relay V2 Operator Guide

Created: 2026-05-21

## Purpose

Remote Door Relay V2 is a quiet, token-gated local ear and compact mouth for one bounded Child Shell action:

`read_command_center_status`

It does not rebuild Child Shell. It only creates normal Level 1 child jobs in:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\DROPZONE`

## Start

From PowerShell:

```powershell
& 'C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\TOOLS\START_REMOTE_DOOR_V2.ps1'
```

The start script prints a token once. The plaintext token is not stored in `token_state.json`; only its SHA256 hash and expiry are stored.

## Local Endpoints

```text
GET http://127.0.0.1:8792/door/v2/status?token=TOKEN
GET http://127.0.0.1:8792/door/v2/probe?token=TOKEN&nonce=NONCE
GET http://127.0.0.1:8792/door/v2/probe_async?token=TOKEN&nonce=NONCE
GET http://127.0.0.1:8792/door/v2/receipt?token=TOKEN&job_id=JOB_ID
```

The actual port may be 8792 or the next nearby free port.

Use `/probe_async` for remote testing. It returns `ACCEPTED` quickly with a `job_id`; poll `/receipt` with that `job_id` until it returns `PROCESSED / PASS` or `REJECTED`.

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
- cleanup blocked
- repo write through V2 blocked
- git through V2 blocked
- Level 3 through V2 blocked
- ACTIVE_GUIDES rewrite blocked
- CURRENT_TRUTH_INDEX rewrite blocked
- doctrine rewrite blocked
- permission expansion blocked
- junction/symlink teleporter blocked

## Proof Rule

Do not claim chat-to-PC proof unless an external request to the temporary public URL creates the Child Shell job and OUTBOX receipt.
