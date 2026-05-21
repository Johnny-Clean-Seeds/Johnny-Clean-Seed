# Remote Door Relay V2E Print Door Review

Date: 2026-05-21
Base before save: main @ b7de646

## Verdict

PASS / V2E print door built and mule-external proof passed.

## What Changed

Remote Door V2 now has a normal V2E print flow:

`/door/v2/status -> /door/v2/probe/<print> -> /door/v2/status`

The PC makes the current/next print pair, validates the current print once, burns it after safely writing the Child Shell job, promotes next to current, and generates a new next print.

The old token/nonce probe routes remain available as rollback/fallback during this build, but they are not the normal proof path.

## Proof

Local proof job:

`CHILDJOB-20260521-161442-REMOTE-DOOR-V2E-PRINT-PROBE`

Local receipt SHA256:

`9CD0D7CD6C7F00A4DF876BCB9E0C9BD1EE7BEA2A661461FA20F721B491BAD664`

Mule external proof job:

`CHILDJOB-20260521-161715-REMOTE-DOOR-V2E-PRINT-PROBE`

Mule external receipt SHA256:

`55FD9377628CD7D1CB8583DE313006EF0A1F0017AA7DF2F548C598393AA96012`

Latest latch after external proof:

`PROCESSED_PASS`

## Safety Checks

- Local `/status` showed `READY`.
- Wrong print rejected.
- Used print rejected.
- Expired print rejected by controlled local-only reseed.
- Reset/reseed dry-run passed.
- Reset/reseed real local reseed passed.
- Status checkpoint was written, hashed, re-read, and verified before print exposure.

## Not Saved Here

No active print, next print, local secret, vault file, tunnel token, or active tunnel URL is saved as authority.

## Boundary

No assistant arbitrary shell, raw shell, broad crawl, delete, repo write through V2, git through V2, Level 3 through V2, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, doctrine rewrite, permission expansion, or junction/symlink teleporter.
