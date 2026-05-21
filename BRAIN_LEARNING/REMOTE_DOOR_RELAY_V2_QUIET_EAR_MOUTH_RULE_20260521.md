# Remote Door Relay V2 Quiet Ear / Mouth Rule

Created: 2026-05-21T13:56:21.8027179-04:00

Run ID: REMOTE_DOOR_RELAY_V2_20260521_135115

## Rule

Remote Door Relay V2 is a transport layer only.

It may expose a temporary quiet local ear on `127.0.0.1` and, when explicitly selected for proof, a temporary outbound tunnel to that local port.

It may create exactly one kind of Child Shell job:

`read_command_center_status`

It must not expose arbitrary command, raw shell, repo write, git, delete, cleanup, Level 3, doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, permission expansion, or junction/symlink teleporter routes.

## Required Shape

- all useful endpoints require a token;
- token is stored locally as SHA256 only and expires;
- nonce is required for `/probe`;
- nonce is single-use;
- duplicate nonce rejects;
- wrong, missing, or expired token rejects;
- `/probe` writes a normal Child Shell Level 1 read-status job into DROPZONE;
- response mouth is compact proof only.

## Proof

Local self-test proof:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\RECEIPTS\REMOTE_DOOR_V2_LOCAL_SELF_TEST_20260521_135212.json`

Local self-test proof SHA256:

`8AEF699160EF5312B9C7A982D790A507AE55E2F8671E275BEEFA331DD994E187`

External fetch proof:

`C:\Users\13527\Desktop\123\COMMAND_CENTER\REMOTE_DOOR_RELAY_V2\RECEIPTS\REMOTE_DOOR_V2_EXTERNAL_JINA_PROOF_20260521_135454.json`

External fetch proof SHA256:

`E528268CFBEE5A78239135D8A3426D972F22BC36688C44D4F9F91553B00332AE`

External Child Shell job:

`CHILDJOB-20260521-135454-REMOTE-DOOR-V2-PROBE`

External Child Shell receipt SHA256:

`298A63824400AB4A605B3EA5AD5D4FC0C560177533E6D21DD65E0F7C65912AF6`

## Caveat

The external proof used the Jina Reader fetch service against the temporary Cloudflare quick tunnel. This proves public external reachability to the PC and Child Shell receipt creation from that request.

Do not claim direct ChatGPT web-fetch proof unless ChatGPT itself calls the public URL with a fresh nonce.

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
