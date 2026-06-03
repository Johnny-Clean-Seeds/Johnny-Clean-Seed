# Warning Self-Classification and Explanation Checklist

Saved: 20260603_134421

## If a report prints WARNING_COUNT, it must also print

WARNING_COUNT:
BLOCKING_WARNING_COUNT:
NON_BLOCKING_WARNING_COUNT:
WATCH_WARNING_COUNT:
UNKNOWN_WARNING_COUNT:
NEXT_LEGAL_ACTION:

## For each warning, include

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

## Block movement if

UNKNOWN_WARNING_COUNT > 0

or the warning touches:

authority
source/proof integrity
active files
Git
execution
implementation
protected paths
pointer ambiguity
stale proof
human judgment

## Continue with watch only if

BLOCKING_WARNING_COUNT is 0
UNKNOWN_WARNING_COUNT is 0
NEXT_LEGAL_ACTION is explicit
DoesNotProve is present
StopLine is present
