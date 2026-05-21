# Remote Door Relay V2 Async Probe / Receipt Polling Rule

Created: 2026-05-21T14:14:25.3650869-04:00

Run ID: REMOTE_DOOR_RELAY_V2_20260521_141101

## Rule

Remote Door Relay V2 must not require remote callers to hold one long HTTP request open while Child Shell creates a receipt.

Use this route instead:

1. `/door/v2/status`
2. `/door/v2/probe_async`
3. `/door/v2/receipt`

`/probe_async` validates token, expiry, nonce, and action, creates one Level 1 `read_command_center_status` Child Shell job, and returns immediately with `ACCEPTED`, `request_id`, `job_id`, `expected_receipt`, and `receipt_poll_url`.

`/receipt` is the mouth for proof polling. It may return `PENDING`, `PROCESSED / PASS`, `REJECTED`, or `MISSING`.

## Repair

The async repair also serializes V2 dispatcher fallback with a local lock. The existing Child Shell dispatcher processes the first INBOX job, so V2 fallback must not run competing dispatcher calls for multiple async jobs at the same time.

## Proof

Local async proof:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\RECEIPTS\REMOTE_DOOR_V2_LOCAL_SELF_TEST_20260521_141302.json`

Local async proof SHA256:

`A8131739AD5477F2351D8D04E9103CD6C2E50962E261E47891C981E2CC316039`

Mule external async proof:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\RECEIPTS\REMOTE_DOOR_V2_MULE_EXTERNAL_ASYNC_TEST_20260521_1413.json`

Mule external async proof SHA256:

`6E75665431660DE48465F0EB245D2EBB6625343A80F0D2011CC8FE4348FDD7A4`

Mule external Child Shell job:

`CHILDJOB-20260521-141351-REMOTE-DOOR-V2-ASYNC-PROBE`

Mule external Child Shell receipt SHA256:

`F45E8163253F84D573079ABA5C37A712CCB760AA5D4D9D8EB9E033D9F0272EB9`

## Direct ChatGPT Proof State

READY FOR CHATGPT FINAL TEST / NOT YET CLAIMED.

The ChatGPT-only nonce is not committed to Mr.Kleen and is returned only in the live task response.

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
