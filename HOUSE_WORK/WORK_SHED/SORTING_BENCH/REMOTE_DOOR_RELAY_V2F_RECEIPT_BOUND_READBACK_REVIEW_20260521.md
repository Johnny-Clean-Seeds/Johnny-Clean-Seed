# Remote Door Relay V2F Receipt-Bound Readback Review

Date: 2026-05-21
Base before save: main @ eaeb68b

## Verdict

PASS / V2F receipt-bound readback patch proved locally and through mule external tunnel.

## What Changed

V2F adds:

`/door/v2/readback/<job_id>`

Accepted V2E print probes now return `readback_url` and `job_bound_readback_url` bound to the exact created job id.

The readback endpoint checks exact Child Shell evidence paths for that job id only. It does not use `/door/v2/status` latest state as proof.

## Proof

Previous ChatGPT-created V2E job readback:

`CHILDJOB-20260521-162420-REMOTE-DOOR-V2E-PRINT-PROBE`

Receipt SHA256:

`9ACB76C2011491A083CC3BE397FE8826FD2AC251F7081C9A112B1B3A128B369B`

Local V2F proof job:

`CHILDJOB-20260521-171245-REMOTE-DOOR-V2E-PRINT-PROBE`

Local readback verdict:

`PASS / RECEIPT FOUND`

Local receipt SHA256:

`99FB2925C5C1661D881C28C5CA42FC890CD143FFAA37D1A66EE33EE341E4CEAE`

Mule external V2F proof job:

`CHILDJOB-20260521-171334-REMOTE-DOOR-V2E-PRINT-PROBE`

Mule external readback verdict:

`PASS / RECEIPT FOUND`

Mule external receipt SHA256:

`663B4EA12F702B1395A720A4D04E3DDACADD907FD581E6D95A581326C11DBD50`

## Safety Checks

- Local `/status` showed `READY`.
- Local `/probe/<print>` was accepted.
- Probe response included a readback URL.
- Local readback returned exact-job `PASS / RECEIPT FOUND`.
- Used print still rejected.
- Wrong print still rejected.
- Existing `/status` still worked.
- Legacy `/probe` and `/probe_async` remained present behind the legacy token gate.
- External status/probe/readback proof passed through the public tunnel.

## Not Saved Here

No active print, next print, local secret, vault file, used-print ledger, checkpoint file, tunnel token, or active tunnel URL is saved as authority.

## Boundary

No assistant arbitrary shell, raw shell, broad crawl, delete, repo write through V2, git through V2, Level 2, Level 3, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, doctrine rewrite, permission expansion, or junction/symlink teleporter.
