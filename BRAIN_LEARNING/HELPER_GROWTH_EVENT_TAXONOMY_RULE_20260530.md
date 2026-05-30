# Helper Growth Event Taxonomy Rule

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
Status: SUPPORT RULE / CHECKPOINTED

Allowed helper growth event types:

- PACKET_CREATED
- START_CHECK_PASS
- START_CHECK_FAIL
- WORK_STARTED
- ACTION_TAKEN
- FILE_CREATED
- FILE_CHANGED
- HASH_CAPTURED
- PROOF_CREATED
- ISSUE_FOUND
- FALSE_BLAME_BLOCKED
- REPAIR_APPLIED
- LEDGER_UPDATED
- STOP_DONE_PASS
- STOP_DONE_WITH_WATCH
- STOP_BLOCKED
- HANDOFF_CREATED
- REOPEN_TRIGGER_SET
- FINAL_SUMMARY_CREATED

Every event must carry trace id, helper id, packet id when applicable, timestamp, reason, proof pointer where applicable, and stop/handoff state where applicable.
