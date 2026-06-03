# Project Command Center Command Grammar V0.6 Guarded Local-Only Read Implementation Design Rule

Saved: 20260603_134856

## Verdict

COMMAND_GRAMMAR_V0_6_GUARDED_LOCAL_ONLY_READ_IMPLEMENTATION_DESIGN_RULE_SAVED

## Source design evidence

DesignReport: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_6_GUARDED_LOCAL_ONLY_READ_IMPLEMENTATION_DESIGN_20260603_134702\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_6_GUARDED_LOCAL_ONLY_READ_IMPLEMENTATION_DESIGN_20260603_134702.txt
DesignReportSHA256: 55E55909AC8A8D1330F2218997C803FAE32B9F07507A1F1E0229FF4138BF4749

## Purpose

V0.6 is the design bridge between the saved command grammar stack and a future local-only read implementation.

It does not implement the command.

It defines what a guarded implementation would be allowed to do later, what it must never do, what guard review must prove, and how warnings must explain themselves before returning control.

## Future implementation target

READ_ONLY_INSPECT_ACTIVE_TASK_V0

## Supported command

Primary phrase:
inspect last task

Allowed aliases:
- inspect current task
- inspect active task
- show last task
- show current task
- what is the current task
- where are we
- what is next
- status current task

Rejected phrases:
- run last task
- save last task
- fix last task
- continue last task
- execute last task
- guard review
- run verifier
- lock save

## Future allowed behavior, after guard-reviewed implementation

- read a local active task pointer JSON file if it exists
- validate required pointer fields
- classify pointer state
- optionally read referenced evidence files if pointer explicitly lists them
- optionally compute hashes of referenced evidence files
- optionally read Git status/head as read-only proof if pointer says repo-clean proof is required
- print an inspect card
- write one local read report only if launcher explicitly requests report output

## Future forbidden behavior

- create pointer file
- write pointer file
- repair pointer
- execute next action
- run guard review
- run verifier
- run implementation scripts
- stage Git
- commit Git
- push Git
- force-add ignored paths
- move files
- delete files
- rename files
- clean folders
- start watcher
- create full UI
- run Micro 004
- edit ACTIVE_GUIDES
- edit CURRENT_TRUTH_INDEX
- rewrite doctrine
- mutate protected paths

## Warning rule built in

Any future V0.6-related report that emits warnings must include:

WARNING_COUNT
BLOCKING_WARNING_COUNT
NON_BLOCKING_WARNING_COUNT
WATCH_WARNING_COUNT
UNKNOWN_WARNING_COUNT
NEXT_LEGAL_ACTION

Every warning must explain what is happening and why.

## DoesNotProve

This save does not implement inspect last task.
This save does not create a pointer file.
This save does not read or update pointer state.
This save does not create UI.
This save does not authorize automatic execution.
This save does not authorize Micro 004.
This save does not authorize broad Git/mutation/tool execution.

## StopLine

Do not implement from this report.

Only after V0.6 design is saved may a separate guard-reviewed local-only read implementation script be proposed.
