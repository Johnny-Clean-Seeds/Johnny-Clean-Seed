# Warning Self-Classification and Explanation Rule

Saved: 20260603_134421

## Verdict

WARNING_SELF_CLASSIFICATION_AND_EXPLANATION_RULE_SAVED

## Trigger event

The Command Grammar stack inspection before V0.6 returned:

WARNING_COUNT: 2

It did not classify the warnings before returning control.

A second warning-review script then proved:

FAILURE_COUNT: 0
SOURCE_WARNING_COUNT: 2
EXTRACTED_WARNING_COUNT: 2
BLOCKING_WARNING_COUNT: 0
PASS_WITH_WATCH / STACK_WARNINGS_REVIEWED / READY_FOR_V0_6_DESIGN_ONLY / NO_GIT

## Source evidence

StackInspectionReport:
C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_STACK_INSPECTION_BEFORE_V0_6_20260603_134006\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_STACK_INSPECTION_BEFORE_V0_6_20260603_134006.txt
StackInspectionReportSHA256:
67470932F3E5E027AD2758A2268C60387ED596DBC2944000570B399583A95BF0

WarningReviewReport:
C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_STACK_WARNING_REVIEW_BEFORE_V0_6_20260603_134128\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_STACK_WARNING_REVIEW_BEFORE_V0_6_20260603_134128.txt
WarningReviewReportSHA256:
2B4BF525559446F7DDA3F3DA8EE063BF7EA1CF345E9B44FBCD1C9ECD1DCEF137

## Core rule

Any script or report that emits WARNING_COUNT must classify the warnings before returning control.

A warning without classification is incomplete output.

A warning classification without explanation is also incomplete output.

## Required warning counts

Every report that emits warnings must include:

WARNING_COUNT:
BLOCKING_WARNING_COUNT:
NON_BLOCKING_WARNING_COUNT:
WATCH_WARNING_COUNT:
UNKNOWN_WARNING_COUNT:

If useful, it may also include:

SOURCE_WARNING_COUNT:
EXTRACTED_WARNING_COUNT:
AUTHORITY_WARNING_COUNT:
PROOF_WARNING_COUNT:
GIT_WARNING_COUNT:
EXECUTION_WARNING_COUNT:
IMPLEMENTATION_WARNING_COUNT:
PROTECTED_PATH_WARNING_COUNT:
POINTER_WARNING_COUNT:

## Required explanation per warning

Each warning must explain:

RawWarningText:
WarningCategory:
BlockerStatus:
WhyThisCategory:
EvidenceUsed:
WhatIsHappening:
WhyItMatters:
WhatItAffects:
WhatItDoesNotAffect:
SecondReviewRequired:
NextLegalAction:

## Classification categories

BLOCKING:
The warning touches safety, authority, source/proof integrity, active files, Git, execution, implementation, protected paths, pointer ambiguity, stale proof, unknown state, or user judgment.

NON_BLOCKING:
The warning is cosmetic, wording-only, redundant, expected, or known not to affect the active action.

WATCH:
The warning does not block the current step but should be watched in the next step.

UNKNOWN:
The script cannot safely classify the warning. Unknown warnings block movement until reviewed.

## Second-review rule

A second warning-review script should only be needed when:

- UNKNOWN_WARNING_COUNT is greater than zero
- the warning touches authority
- the warning touches proof/source integrity
- the warning touches active files
- the warning touches Git
- the warning touches execution
- the warning touches implementation
- the warning touches protected paths
- the warning touches pointer ambiguity
- the warning touches stale proof
- the warning requires human judgment

## Next legal action rule

A warning report must print the next legal action.

Examples:

NEXT_LEGAL_ACTION: CONTINUE_WITH_WATCH
NEXT_LEGAL_ACTION: RUN_WARNING_REVIEW
NEXT_LEGAL_ACTION: STOP_AND_REPAIR
NEXT_LEGAL_ACTION: ASK_USER
NEXT_LEGAL_ACTION: SAVE_RULE_BEFORE_CONTINUING

## Why this rule exists

The user should not need a separate script every time WARNING_COUNT is nonzero.

The first report should say what happened and why:

- what the warning is
- whether it blocks
- why it blocks or does not block
- what evidence supports that judgment
- what to do next

## DoesNotProve

This save does not rewrite existing scripts.
This save does not implement warning self-classification in prior tools.
This save does not authorize V0.6 implementation.
This save does not authorize full UI or Micro 004.
This save does not authorize automatic execution.

## StopLine

Before V0.6 or any future script that emits warnings, include warning self-classification and explanation in the report shape.
