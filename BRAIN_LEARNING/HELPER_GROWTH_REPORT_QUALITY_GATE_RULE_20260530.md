# Helper Growth Report Quality Gate Rule

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
Status: SUPPORT RULE / CHECKPOINTED

A helper growth report is not valid unless it answers:

- who acted
- what packet/input it received
- when it acted
- why it acted
- what it did
- what it changed or did not change
- what proof exists
- what boundary was active
- why it stopped
- what it handed off or why it did not hand off
- what ledger changed or why no ledger changed
- what reopens the event

If missing:

`GROWTH_REPORT_SCHEMA_FAIL`

No final reverse summary may claim clean close if required helper reports fail this quality gate.
