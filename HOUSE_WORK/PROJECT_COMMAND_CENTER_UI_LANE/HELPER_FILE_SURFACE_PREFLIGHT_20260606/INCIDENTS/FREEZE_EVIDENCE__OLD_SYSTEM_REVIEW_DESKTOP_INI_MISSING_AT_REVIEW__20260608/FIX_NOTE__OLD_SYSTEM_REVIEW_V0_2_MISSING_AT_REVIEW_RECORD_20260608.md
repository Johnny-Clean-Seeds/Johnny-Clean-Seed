# FIX_NOTE__OLD_SYSTEM_REVIEW_V0_2_MISSING_AT_REVIEW_RECORD_20260608

Status: FIX_NOTE / V0_2_REPAIR / MISSING_AT_REVIEW_SAFE_RECORD / NO_CLEANUP

Created: 2026-06-08 19:12:01

Fix:
V0_2 does not crash when an old/system candidate is missing at review time.

Behavior:
- preserves the queue observed path and queue observed SHA256
- records current_status as MISSING_AT_REVIEW_TIME
- records actual current SHA256 as NOT_AVAILABLE_MISSING_AT_REVIEW_TIME
- writes a review card
- blocks cleanup, delete, move, route, Git, restore, and recreation

Reason:
The old/system bucket can include system metadata and stale candidates. Missing at review time is a custody fact, not cleanup authority.

No scope change:
- still read-only
- no cleanup
- no move
- no route
- no Git
- no restore
- no creation

Freeze hash:
0EA466DC840BD32F49B4D632BCE3C0F683A402761CF2AD7011C0797764D900F9

Failed runner copy SHA256:
426B6E5CDE9BFC779F5CE19BBD9D3AC4775430866EB499B0D1B00633B7F164A2

Fixed runner copy SHA256:
4ED1D3AFD0597C3A998CD97C48B98B2449355CF2C579A6177346818C9CE422BD

DoesNotProve:
This fix note does not prove old/system candidates are trash, safe to delete, safe to restore, safe to route, or project complete.