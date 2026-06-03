# Project Command Center Active Task Pointer V0.2 Design

Saved: 20260603_132531

## Source

DesignReport: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_2_ACTIVE_TASK_POINTER_DESIGN_20260603_132416\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_2_ACTIVE_TASK_POINTER_DESIGN_20260603_132416.txt
DesignReportSHA256: EC61CD40B0BE1EFC20694EC9A6A6E81E6F1F75A0809FE85B5E63A9678E311C93

## Object

PROJECT_COMMAND_CENTER_ACTIVE_TASK_POINTER_V0_2

## Purpose

Design the state object that resolves phrases such as:

- inspect last task
- inspect last job
- save gate
- lock save
- next

## Required fields

PointerId:
PointerVersion:
UpdatedAt:
UpdatedBy:
ActiveLane:
ActiveObject:
ActiveStage:
ActiveMode:
ActiveRunId:
LastCompletedStep:
CurrentProofState:
NextLegalAction:
NextLegalActionMode:
NextActionRequiresConfirmation:
AllowedPowers:
BlockedPowers:
FilesToRead:
FilesToWrite:
FilesToStage:
FilesToNeverTouch:
EvidenceReports:
GuardReceipts:
RunReports:
VerifyReports:
SaveReceipts:
RepoHead:
RepoOriginMain:
RepoCleanRequired:
DoesNotProve:
StopLine:
PointerStatus:
CloseCondition:
RepairCondition:

## Placement candidates

Local mutable state candidate:
C:\Users\13527\Desktop\123\HOUSE_DOCK_CONTROL_ROOM\STATE\ACTIVE_TASK_POINTER.json

Git support shape candidate:
HOUSE_WORK/WORK_SHED/INDEXES/PROJECT_COMMAND_CENTER_ACTIVE_TASK_POINTER_V0_2_SHAPE_20260603.md

Future UI state store:
Project Command Center state store

## Boundary

Design only.
No implementation.
No mutable pointer file created.
No full UI.
No Micro 004.
No tool execution.
No Git mutation authorized by this design.
