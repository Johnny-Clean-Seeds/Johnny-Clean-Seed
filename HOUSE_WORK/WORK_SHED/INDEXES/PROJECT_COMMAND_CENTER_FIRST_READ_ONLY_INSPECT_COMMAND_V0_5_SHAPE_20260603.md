# Project Command Center First Read-Only Inspect Command V0.5 Shape

Saved: 20260603_133747

## Inspect card shape

CardType:
INSPECT_ACTIVE_TASK_CARD

CardVersion:
V0.5_DESIGN

ResolvedCommand:
INSPECT_ACTIVE_TASK

SourcePhrase:
original phrase

ResolutionConfidence:
HIGH / MEDIUM / LOW

PointerRead:
YES / NO

PointerStatus:
value

ActiveLane:
value

ActiveObject:
value

ActiveStage:
value

ActiveMode:
value

LastCompletedStep:
value

CurrentProofState:
list

NextLegalAction:
value

NextLegalActionMode:
value

NextActionRequiresConfirmation:
true / false

AllowedPowers:
list

BlockedPowers:
list

FilesRead:
list

FilesNotRead:
list with reason

EvidenceReports:
list

SaveReceipts:
list

RepoHead:
value if pointer has it

RepoOriginMain:
value if pointer has it

RepoCleanRequired:
true / false

DoesNotProve:
This inspect card does not prove action completion.

StopLine:
Do not run, write, save, or mutate from an inspect command.

## Pointer missing card

CardType:
POINTER_MISSING_CARD

VisibleIssue:
User requested inspect active task, but no active pointer is available.

AllowedAction:
Show missing pointer status only.

BlockedAction:
No active-task inference from transcript.

RecommendedNext:
Create or repair pointer through a separate confirmation-required route.

Default:
PAUSE_NO_ACTION

## Pointer stale card

CardType:
POINTER_STALE_CARD

VisibleIssue:
Pointer exists but conflicts with evidence or current repo/proof state.

DetectedProblems:
list

Evidence:
list

AllowedAction:
Read-only report of stale condition.

BlockedAction:
Do not inspect stale pointer as current active task.

RecommendedNext:
Pointer repair card.

Default:
PAUSE_NO_ACTION

## Pointer ambiguous card

CardType:
POINTER_AMBIGUOUS_CARD

VisibleIssue:
Multiple candidate current tasks or pointer fields conflict.

CandidateActiveObjects:
list

EvidenceForEachCandidate:
list

AllowedAction:
Show ambiguity.

BlockedAction:
Do not choose one silently.

RecommendedNext:
Ask for target or run pointer repair route.

Default:
PAUSE_NO_ACTION

## StopLine

No execution from inspect.
