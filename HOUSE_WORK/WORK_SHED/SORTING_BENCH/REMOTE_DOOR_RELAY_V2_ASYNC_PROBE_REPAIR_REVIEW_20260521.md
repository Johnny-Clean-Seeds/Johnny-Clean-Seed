# Remote Door Relay V2 Async Probe Repair Review

Created: 2026-05-21T14:14:25.3650869-04:00

Run ID: REMOTE_DOOR_RELAY_V2_20260521_141101

## Starting Repo State

Repo:

`C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz`

Base HEAD:

`fc21912`

Base full HEAD:

`fc21912f9f636155b46e0d28f409b1413f4ad0c9`

Origin main:

`fc21912f9f636155b46e0d28f409b1413f4ad0c9`

Base status:

clean

## Why This Repair Exists

The first Remote Door Relay V2 `/probe` endpoint was synchronous. It could create Child Shell receipts, but remote/web callers could time out while one HTTP request waited for Child Shell.

That timeout is not a Child Shell failure by itself.

## Repair Summary

Added:

`GET /door/v2/probe_async?token=TOKEN&nonce=NONCE`

Kept:

`GET /door/v2/status?token=TOKEN`

Repaired:

`GET /door/v2/receipt?token=TOKEN&job_id=JOB_ID`

Async job pattern:

`CHILDJOB-YYYYMMDD-HHMMSS-REMOTE-DOOR-V2-ASYNC-PROBE`

V2 fallback:

Serialized dispatcher fallback with a V2-side lock and retry loop so simultaneous async probes do not collide around the existing Child Shell dispatcher.

## Local Async Proof

Status:

PASS / REMOTE DOOR V2 QUIET EAR READY

Wrong token:

REJECTED / WRONG TOKEN

Duplicate nonce:

REJECTED / DUPLICATE NONCE

Probe async:

ACCEPTED / ASYNC CHILD SHELL JOB CREATED

Local job:

`CHILDJOB-20260521-141256-REMOTE-DOOR-V2-ASYNC-PROBE`

Initial receipt poll:

PENDING / RECEIPT NOT READY

Final receipt poll:

PASS / CHILD SHELL RECEIPT CREATED

Local receipt:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\OUTBOX\CHILDJOB-20260521-141256-REMOTE-DOOR-V2-ASYNC-PROBE.receipt.txt`

Local receipt SHA256:

`7B72E34516379058B2B6E3A242F686AB23D4621D86E742405055E01CFA383A4B`

Local proof file:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\RECEIPTS\REMOTE_DOOR_V2_LOCAL_SELF_TEST_20260521_141302.json`

Local proof SHA256:

`A8131739AD5477F2351D8D04E9103CD6C2E50962E261E47891C981E2CC316039`

## Mule External Async Proof

Method:

Jina Reader external fetch service.

Mule external job:

`CHILDJOB-20260521-141351-REMOTE-DOOR-V2-ASYNC-PROBE`

Mule external receipt:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\OUTBOX\CHILDJOB-20260521-141351-REMOTE-DOOR-V2-ASYNC-PROBE.receipt.txt`

Mule external receipt SHA256:

`F45E8163253F84D573079ABA5C37A712CCB760AA5D4D9D8EB9E033D9F0272EB9`

Mule external proof:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\RECEIPTS\REMOTE_DOOR_V2_MULE_EXTERNAL_ASYNC_TEST_20260521_1413.json`

Mule external proof SHA256:

`6E75665431660DE48465F0EB245D2EBB6625343A80F0D2011CC8FE4348FDD7A4`

This is mule external proof, not direct ChatGPT proof.

## Direct ChatGPT Proof State

READY FOR CHATGPT FINAL TEST / NOT YET CLAIMED.

The ChatGPT-only nonce was generated after mule proof and verified absent from the nonce ledger. It is not stored in this repo.

## Boundary Held

No arbitrary shell endpoint.

No raw command endpoint.

No broad crawl endpoint.

No delete endpoint.

No cleanup endpoint.

No repo write endpoint.

No git write endpoint.

No Level 3 endpoint.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No doctrine rewrite.

No permission expansion.

No junction/symlink teleporter.
