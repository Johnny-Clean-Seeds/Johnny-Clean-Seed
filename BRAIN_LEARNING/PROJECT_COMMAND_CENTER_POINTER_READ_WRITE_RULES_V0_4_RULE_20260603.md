# Project Command Center Pointer Read/Write Rules V0.4 Rule

Saved: 20260603_133312

## Verdict

COMMAND_GRAMMAR_V0_4_POINTER_READ_WRITE_RULES_SAVED

## Source design evidence

DesignReport: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_4_POINTER_READ_WRITE_RULES_DESIGN_20260603_133140\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_4_POINTER_READ_WRITE_RULES_DESIGN_20260603_133140.txt
DesignReportSHA256: 01F01C3F0B1D93AC5A390772BA7B75931F82B92FD1A1E4E4BC80D531FBD4FCC5

## Purpose

The active task pointer needs custody rules before implementation.

The pointer may resolve state, but it must not become a loose authority source.

## Core rule

Pointer reads are allowed when read-only state resolution is needed.

Pointer writes require:

1. a specific trigger
2. evidence
3. a before/after pointer comparison
4. a confirmation card if the write is operational or changes next legal action
5. a receipt

## Storage lanes

Local operational pointer candidate:
C:\Users\13527\Desktop\123\HOUSE_DOCK_CONTROL_ROOM\STATE\ACTIVE_TASK_POINTER.json

Local pointer receipt lane:
C:\Users\13527\Desktop\123\HOUSE_DOCK_CONTROL_ROOM\RECEIPTS\POINTER_RECEIPTS

Local pointer history lane:
C:\Users\13527\Desktop\123\HOUSE_DOCK_CONTROL_ROOM\STATE\POINTER_HISTORY

Git support/design lane:
HOUSE_WORK/WORK_SHED/INDEXES/*POINTER*_SHAPE*.md

## Read rules

Read pointer when:

- user says inspect last task
- user says inspect last job
- user says next
- user says save gate
- user says lock save
- user says guard review
- user says run verifier
- user asks current status
- a confirmation card needs active object resolution
- a lower-layer issue asks what lane is active

Read must not write pointer, run scripts, mutate files, stage Git, or infer missing fields as facts.

## Write triggers

Allowed pointer write triggers:

- DESIGN_PASS
- GUARD_REVIEW_PASS
- RUN_PASS
- VERIFY_PASS
- SAVE_GATE_PASS
- USER_PAUSE
- USER_LANE_CHANGE
- LOWER_ISSUE_BLOCK
- POINTER_REPAIR_PASS

Pointer writes are not allowed for speculation, transcript-only memory, unverified pass lines, contaminated output, assistant preference, or future ideas without current lane relation.

## Required evidence for pointer write

Every pointer write must record:

WriteReason
Trigger
OldPointerHash
NewPointerHash
EvidencePath
EvidenceSHA256
RepoHead
RepoOriginMain
RepoClean
ChangedFields
DoesNotProve
StopLine
ReceiptPath
ReceiptSHA256

## Stale conditions

Pointer is stale if:

- pointer RepoHead differs from current repo head when clean repo proof is required
- pointer NextLegalAction conflicts with latest proof state
- pointer ActiveObject is already saved and closed but still marked active
- pointer references missing report paths
- pointer report hashes no longer match
- pointer lacks required fields
- pointer lacks DoesNotProve
- pointer lacks StopLine
- pointer is older than latest active proof receipt

## DoesNotProve

This save does not create the pointer JSON file.
This save does not implement pointer reading.
This save does not implement pointer writing.
This save does not authorize automatic command execution.
This save does not authorize Micro 004.
This save does not authorize broad Git/mutation/tool execution.

## StopLine

Do not implement pointer write behavior until:
1. V0.4 pointer read/write rules are saved.
2. V0.5 first read-only inspect command is designed.
3. A guard-reviewed implementation script exists.
4. Pointer write confirmation rules are enforced.
