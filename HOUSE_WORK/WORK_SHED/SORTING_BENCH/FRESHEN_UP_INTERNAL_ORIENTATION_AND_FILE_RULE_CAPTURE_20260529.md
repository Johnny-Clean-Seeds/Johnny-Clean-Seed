# Freshen' up Internal Orientation and File Rule Capture

## Source moment
The user corrected the behavior of Freshen' up after seeing the assistant use it as a chat-facing summary stop.

## User correction distilled
Freshen' up should not end the task by dumping the reset summary to chat.

It should create internal notes for the assistant, then push forward after or during the reset.

It is a track-recovery mechanism for wheel-spinning, not an excuse to stop deep thinking.

The user also corrected the rule-routing model: all rules for the assistant should have a file route, mostly parked and waiting to be opened unless they have a way to go now.

## What changed
Old behavior rejected:

- Freshen' up as final summary.
- Freshen' up as task end.
- Chat-only rule learning with no file route.
- Treating every new rule as active doctrine immediately.

New behavior:

- Freshen' up creates internal orientation and resumes the task.
- Use it when loops stop yielding better results or rope is slipping.
- Keep rules file-facing.
- Park rules until opened by matching task, unless the active task needs them now.

## Current open rope at capture time
Active task: helper living memory ledger save repair.

Known blockers encountered:

1. `LOCK_SAVE_HELPER_LIVING_MEMORY_LEDGER_V1.ps1` failed during `git add` because `HOUSE_WORK/WORK_SHED` paths were ignored and the script did not exact-force-add ignored paths.
2. `LOCK_SAVE_FRESHEN_UP_INTERNAL_ORIENTATION_AND_FILE_RULE_V1.ps1` then failed because its Git wrapper called bare `git`, caused by unsafe argument-list handling around `$Args`.

## Repair direction
Save scripts must let the files learn the failure, not just rerun a fixed command.

This V1.1 recovery saves the rule, the issue card, and the save-script ledger entry, then stages exact files only.