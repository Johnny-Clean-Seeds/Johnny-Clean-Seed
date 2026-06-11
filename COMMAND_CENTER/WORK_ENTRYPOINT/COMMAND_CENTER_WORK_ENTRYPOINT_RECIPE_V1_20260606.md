# COMMAND CENTER WORK ENTRYPOINT RECIPE V1

## Normal use

`powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File "C:\Users\13527\Desktop\123\COMMAND_CENTER\WORK_ENTRYPOINT\COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
`

## Expected clear result

`	ext
WorkEntryStatus:
WORK_ENTRY_READY_FOR_SELECTED_ACTION

OpenSideQuestRequired:
False

DONE_MARKER:
COMMAND_CENTER_WORK_ENTRYPOINT_FINALIZED
`

## If blocked

If WorkEntryStatus says error harvest is required, do not run the selected main action.
Route to the error-triggered helper harvest lane.

## Required next read

C:\Users\13527\Desktop\123\COMMAND_CENTER\WORK_ENTRYPOINT\CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md
