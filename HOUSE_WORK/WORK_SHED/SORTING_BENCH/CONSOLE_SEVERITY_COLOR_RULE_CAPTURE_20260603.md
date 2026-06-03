# Console Severity Color Rule Capture

Saved: 20260603_140117

## Problem

The warning self-classification content was correct, but the terminal output was visually flat.

The operator should not have to scan a wall of equal-weight text to find:

- warning count
- blocker count
- unknown count
- next legal action
- raw warning
- why it matters

## Rule

Console output needs severity lanes.

Keep the text complete.
Add color to make state visible.

## Console lane map

GREEN:
PASS, clean proof, HeadEqualsOrigin True, FinalClean True

YELLOW:
WATCH, nonblocking warning, expected missing pointer, continue-with-watch

RED:
STOP, BLOCKING, failure, unknown unsafe state, failed guard

MAGENTA:
UNKNOWN warnings or ambiguous states that need special attention

CYAN:
Paths, hashes, next legal action when allowed, report paths

GRAY:
DoesNotProve, StopLine, boundary reminders

## Current application

READ_ONLY_INSPECT_ACTIVE_TASK_V0 should eventually print its warning block with color.

Because this is a rule save only, the target script is not rewritten in this save.
