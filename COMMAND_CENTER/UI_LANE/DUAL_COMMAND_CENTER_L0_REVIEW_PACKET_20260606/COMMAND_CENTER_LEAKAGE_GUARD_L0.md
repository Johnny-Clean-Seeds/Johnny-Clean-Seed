# COMMAND_CENTER_LEAKAGE_GUARD_L0

Status: L0 GUARD / REVIEW PACKET / REPORT-ONLY / NOT INSTALLED
Date: 2026-06-06
SourceBasis: Batch 10F.14 - Leakage Guard

This guard keeps the root front door user-facing and keeps assistant state out of loose root space. It is a report-only guard by default.

## Rule Identity

RuleName:

`COMMAND_CENTER_ROOT_LEAKAGE_GUARD_V0_1`

Protected rule:

`ROOT FRONT DOOR BELONGS TO USER COMMAND CENTER. ASSISTANT OPS STAYS BEHIND IT OR IN LOCAL CUSTODY.`

## Allowed Root Items

Allowed direct root items:

```text
COMMAND_CENTER\
desktop.ini
```

Allowed direct root pointer if intentionally installed:

```text
START_HERE.md
```

## Blocked Loose Root Patterns

The following patterns are not allowed loose in root without a root-intake packet:

```text
*RECEIPT*.md
*MULE_ORDER*.md
*RUNNER*.ps1
*LOCK_SAVE*.ps1
*LEDGER*.csv
*LEDGER*.md
*PACKET*.md
*GUARD*.md
*REPORT*.md
ACTIVE_OBJECT.json
ACTOR_BOARD.json
ROUTER_LEDGER.csv
WORK_TOKEN_LEDGER.csv
RECEIPT_INDEX.csv
HANDOFF_TRACE.jsonl
```

## Guard Action

Default action:

`REPORT_ONLY`

The guard may:

- inspect root names
- classify possible assistant-state leakage
- identify loose input files
- report required root intake
- write a guard report if separately authorized

The guard may not by default:

- delete
- move
- compress
- archive
- dedupe
- restore in place
- empty Recycle Bin
- rewrite live state
- install automation

Do not move anything unless an explicit root-intake packet exists.

## Guard Verdicts

Allowed verdicts:

- ROOT_FRONT_DOOR_CLEAN
- ROOT_ASSISTANT_STATE_LEAK_FOUND
- ROOT_LOOSE_INPUT_FOUND
- ROOT_INTAKE_REQUIRED
- ROOT_INTAKE_DONE_ACTIVE_JOB_OPEN

## Guard Report Shape

Future live report target:

`_LOCAL_CUSTODY_N_RECEIPTS/ASSISTANT_COMMAND_CENTER_STATE/COMMAND_CENTER_LEAKAGE_GUARD_REPORT.md`

Report fields:

```text
COMMAND_CENTER_LEAKAGE_GUARD_REPORT

Status:
CheckedUtc:
RootPath:
AllowedRootItems:
AllowedPointerItems:
BlockedPatternsChecked:

LooseAssistantStateFound:
LooseAssistantStateItems:
LooseInputFound:
LooseInputItems:

RootIntakeRequired:
RootIntakePacket:
RootIntakeDone:
ActiveJobDone:

Deleted: false
Moved: false
Compressed: false
Archived: false
Deduped: false
RestoredInPlace: false
RecycleBinEmptied: false

FinalVerdict:
DoesNotProve:
NextLegalAction:
```

## Leakage Boundary Rules

- Root shows user control, not assistant guts.
- Assistant state belongs in local custody state.
- Backstage views may exist under COMMAND_CENTER/ASSISTANT_COMMAND_CENTER.
- Root intake is preflight.
- Root intake done is not active job done.
- Leakage evidence is not cleanup authority.
- Duplicate-looking material is not delete authority.
- A guard report is not a mutation packet.

## Failure Labels

- COMMAND_CENTER_ROOT_LEAKAGE_GUARD_MISSING
- ROOT_ASSISTANT_STATE_LEAK_FOUND
- ROOT_LOOSE_INPUT_FOUND
- ROOT_INTAKE_REQUIRED
- ROOT_INTAKE_DONE_ACTIVE_JOB_OPEN
- GUARD_TREATED_AS_JANITOR
- LEAKAGE_PROOF_TREATED_AS_DELETE_AUTHORITY

## Does Not Prove

This guard file does not prove the root is clean, does not prove a scan ran, does not authorize moving or deleting files, and does not install a watcher.

## Next Legal Action

If installed later, run as a report-only guard and judge the report before any root intake or cleanup proposal.

