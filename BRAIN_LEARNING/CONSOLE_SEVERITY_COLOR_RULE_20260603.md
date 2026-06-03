# Console Severity Color Rule

Saved: 20260603_140117

## Verdict

CONSOLE_SEVERITY_COLOR_RULE_SAVED

## Trigger

After the first read-only inspect test returned a correct POINTER_MISSING_CARD, the warning block was textually correct but visually flat.

User correction:
warning counts and warning messages need to be colored like the other status output.

## Source context

GuardReviewReport:
C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_GUARD_REVIEW_READ_ONLY_INSPECT_ACTIVE_TASK_V0_V1_1_20260603_135756\PROJECT_COMMAND_CENTER_GUARD_REVIEW_READ_ONLY_INSPECT_ACTIVE_TASK_V0_V1_1_20260603_135756.txt
GuardReviewReportSHA256:
DACEF02F3C4B363A2A22F7B22CD56FD7E3CDC136EBED6B7C897576459381EF4E

TargetScript:
C:\Users\13527\Downloads\READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1
TargetScriptSHA256:
343B84EC0F81A813829D4FFC059C7563AC5B0128021BB26B6D2DCF0E753F7B84

## Core rule

Warning counts and warning explanation blocks should be color-coded in terminal output so the operator can see state quickly.

Color is additive.

Color never replaces:
- textual classification
- warning counts
- hashes
- file paths
- DoesNotProve
- StopLine
- final proof
- next legal action

Logs must remain copyable, searchable, and plain-text complete.

## Recommended colors

PASS / clean proof:
Green

WATCH / nonblocking warning:
Yellow

BLOCKING / STOP / failure:
Red

UNKNOWN:
Magenta or Red

INFO / paths / hashes:
Cyan or dim gray

NEXT_LEGAL_ACTION:
Cyan when allowed
Yellow when watch
Red when blocked

DoesNotProve / StopLine:
Dark yellow or gray label plus normal text

## Required behavior

Every future console-facing script that prints warning classification should visibly separate:

WARNING_COUNT
BLOCKING_WARNING_COUNT
NON_BLOCKING_WARNING_COUNT
WATCH_WARNING_COUNT
UNKNOWN_WARNING_COUNT
NEXT_LEGAL_ACTION
RawWarningText
WarningCategory
BlockerStatus
WhyThisCategory
WhatIsHappening
WhyItMatters
WhatItAffects
WhatItDoesNotAffect
SecondReviewRequired

## Boundary

This rule does not change warning classification logic.
This rule does not implement color in existing scripts.
This rule does not authorize a full UI.
This rule does not authorize Micro 004.

## DoesNotProve

This save does not rewrite READ_ONLY_INSPECT_ACTIVE_TASK_V0.
This save does not rerun guard review.
This save does not create pointer state.
This save does not implement UI.

## StopLine

Before editing any script for color, generate a separate color-only update or helper; do not mix color work with logic changes unless explicitly authorized.
