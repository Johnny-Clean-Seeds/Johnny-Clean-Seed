# Helper Growth Chain Flight Recorder Map Seed

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
SourceSha256: 2E6F99ED9EFE3731CDDFFF1574ED8FE3C4107EFA2FEFF56DC2ABE1B640F83E19
Status: MAP SEED / SUPPORT ONLY

## Chain parent

`COMMAND_CENTER/HELPER_GROWTH_REPORTS/<TRACE_ID>__<JOB_KEY>/`

## Map rule

The trace id groups the whole chain. Helper span ids identify individual helper work. Event ids record individual actions. Proof ids point to receipts. Handoff ids point to next packet movement. Ledger event ids point to durable helper memory.

## Relationship

`TRACE_ID -> PACKET_ID -> HELPER_SPAN_ID -> EVENT_ID -> PROOF_ID -> STOP_REPORT -> HANDOFF_ID -> LEDGER_EVENT_ID -> REVERSE_SUMMARY -> FINAL_PACKET`

## Boundary

This is a map seed. It does not run helpers and does not grant authority.
