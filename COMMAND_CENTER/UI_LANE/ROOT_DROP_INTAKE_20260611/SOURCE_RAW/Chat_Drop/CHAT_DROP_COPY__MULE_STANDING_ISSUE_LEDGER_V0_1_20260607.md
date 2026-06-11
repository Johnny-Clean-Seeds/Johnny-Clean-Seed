# MULE STANDING ISSUE LEDGER V0.1

Date: 2026-06-07
Status: MULE_OPERATING_LEDGER / LOAD_LAST_AFTER_CURRENT_RULE_ADDENDUM / NOT_DOCTRINE / NOT_SOURCE_AUTHORITY

## READ_ME_FIRST

This ledger records recurring mule failure patterns and mandatory preflight checks.
It is not the house.
It is not doctrine.
It is not Git truth.
It is not project source authority.
It controls mule behavior before touching work.

## RULE 1 - ONE ACTIVE OBJECT

Every mule job must name the one active object.
If multiple jobs appear, collapse to the parent control object or report JOB_COLLISION_REVIEW_REQUIRED.
Do not start side quests.

## RULE 2 - READ ALL CURRENT CHAT DROP HELPERS BEFORE DECIDING

For Chat Drop/helper jobs, read/audit every current top-level CHAT_DROP_COPY__*.md helper before deciding whether to update an existing file or create a new helper/addendum/replacement.
Do not assume a new addendum fixes all old helper problems without checking.

## RULE 3 - HELPER FILE PREFLIGHT

Before acting, read the current relevant helper files.
Do not rely on Git alone.
Do not rely on chat memory alone.
Do not rely on receipts alone.
Do not rely on status summaries alone.
Report HELPER_FILES_USED with path, SHA256, and role when practical.
If required helpers are missing, stale, contradictory, or unreadable, report HELPER_FILE_BLOCKER.

## RULE 4 - TWO-COPY CHAT DROP LAW

There are two required Chat Drop locations by default:

1. C:\Users\13527\Desktop\123\Chat Drop
2. C:\Users\13527\Desktop\Chat Drop

The 123 Chat Drop is the mule working copy.
The Desktop Chat Drop is the user handoff copy and assistant-load copy.
ASSISTANT_LOCAL is not a required mirror unless the user explicitly re-authorizes it.

## RULE 5 - NOTICE TRIGGER

When the user says "NOTICE: I updated Chat Drops," Desktop Chat Drop is the fresh source.
Compare Desktop Chat Drop into 123 Chat Drop.
Do not invent a third mirror.

## RULE 6 - MULE PUBLISH RULE

When the mule creates or updates Chat Drop files inside 123 Chat Drop, the mule must also publish the matching user handoff copy into Desktop Chat Drop.

## RULE 7 - EXISTING HELPER UPDATE AUDIT

When installing a new rule or correcting old guidance, the mule must audit existing current top-level helper files for stale active guidance.

Valid decisions:
UPDATE_EXISTING
CREATE_NEW_ADDENDUM
CREATE_REPLACEMENT
KEEP_AS_CURRENT
KEEP_AS_HISTORY
PROOF_POINTER_ONLY
REVIEW_REQUIRED

Invalid action:
Install a new override rule and assume old helpers are fine without checking them.

## RULE 8 - SUPERSESSION

If older helper files, receipts, reports, or addendums contain stale active guidance, do not silently use it.
Classify it as superseded.
Do not delete proof.
Do not rewrite historical receipts.
Create a replacement helper or update addendum if the stale guidance would mislead future work.

## RULE 9 - RECEIPTS ARE PROOF, NOT ACTIVE ORDERS

Receipts may prove file placement, hashes, or past actions.
Receipts are not current operating authority unless the current helper ledger says so.
Do not treat a receipt hash as proof that the load surface is safe.

## RULE 10 - LOAD SURFACE CHECK

Top-level folders must be classified before claiming clean load state.

_OLD_LOADS = HISTORICAL_REFERENCE_ONLY / DO_NOT_LOAD_BY_DEFAULT / DO_NOT_DELETE
_SYNC_REPORTS = SYNC_REPORT_FOLDER_NOT_LOAD
_CLEANUP_REPORTS = CLEANUP_REPORTS_NOT_LOAD
RECEIPTS = RECEIPT_FOLDER_NOT_LOAD
unknown top-level items = UNKNOWN_REVIEW_REQUIRED

## RULE 11 - LOAD ORDER

Load current top-level CHAT_DROP_COPY__*.md files.
Load the current two-location Chat Drop rule addendum late.
Load this standing issue ledger last or near-last.
Do not load _OLD_LOADS, _SYNC_REPORTS, _CLEANUP_REPORTS, RECEIPTS, workshop folders, or ASSISTANT_LOCAL by default.

## RULE 12 - VISIBLE FINAL RETURN

After work, tell the user exactly:

- what file/folder changed
- where it is
- what the user should open
- what the user should drop into the assistant
- what blockers remain

Do not bury the answer in receipts only.

## RULE 13 - BLOCKED ACTIONS STAY BLOCKED

Unless explicitly approved in the active job, these remain blocked:
Git export
commit
push
cleanup
rename
delete
merge
rough_state retirement
M1 fixture review
source replay
project script execution
URL opening
doctrine promotion

## RULE 14 - DATA BRAKE

Do not repeat large handoffs or explanations unless requested.
Use the cheapest proof step that answers the current question.
Separate:
VERIFIED
REPORTED
NOT VERIFIED
NEXT_SINGLE_ACTION

## RULE 15 - FINAL VERDICT DISCIPLINE

Do not say DONE, ALL GOOD, SAFE, or READY without scope.
Use scoped verdicts only.
If a known issue pattern was skipped, final verdict cannot be clean.

## KNOWN ISSUE TABLE

| ISSUE_ID | TRIGGER | MANDATORY_CHECK | BLOCK_IF_SKIPPED |
| --- | --- | --- | --- |
| KI_CHAT_DROP_THREE_COPY_DRIFT | Chat Drop job mentions three mirrors or ASSISTANT_LOCAL as required. | Enforce two-copy law. | YES |
| KI_HELPER_FILES_SKIPPED | Any mule job starts without reading current helper files. | HELPER_FILE_PREFLIGHT. | YES |
| KI_READ_ALL_CHATDROPS_SKIPPED | Chat Drop/helper update job starts. | Read/audit every current top-level CHAT_DROP_COPY__*.md before deciding update/new/replacement/history. | YES |
| KI_RECEIPT_COLLAPSE | Receipt/hash treated as proof of safety. | Separate proof receipt from active authority. | YES |
| KI_STALE_HELPER_ACTIVE_GUIDANCE | New override rule installed. | Audit existing helpers for stale active guidance. | YES |
| KI_INVISIBLE_SUCCESS | Mule writes files but user cannot easily find them. | Visible final return with exact folder/file to open. | YES |
| KI_SIDE_QUEST_DRIFT | Mule starts Git, M1, cleanup, rough_state, or another repair while active job differs. | One active object. | YES |
| KI_LOAD_SURFACE_UNCLASSIFIED | Chat Drop/load folder has old loads, receipts, sync folders, cleanup folders, or unknowns. | Classify top-level load surface. | YES |
| KI_OLD_LANGUAGE_NOT_SUPERSEDED | Old helper says a rule that current work corrected. | Mark superseded and create replacement/addendum if needed. | YES |
| KI_DATA_WASTE_LOOP | Repeated corrections or repeated handoffs. | Data brake, one active object, cheapest proof step. | YES |

## DOESNOTPROVE

This standing issue ledger proves only the mule's recurring preflight obligations and known issue checks. It does not prove the project is complete, correct, public-safe, committed, pushed, doctrine, ready for cleanup, ready for rough_state retirement, or ready for M1 fixture review.
