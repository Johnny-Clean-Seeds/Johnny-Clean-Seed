# Keyed Intake Manual Test Template V1

Date: 2026-05-30
Status: TEMPLATE / SUPPORT TEST DESIGN

## Test boundary

Selected object only.
Explicit intake pass only.
No detectors/watchers/polling.
No execution.
No Git.
No move/delete.
No broad crawl.
No doctrine.
No automation.

## Test object

SourcePath:
SourceHash:
ObjectKey:
KeyCode:
ObjectType:
ExpectedRoute:

## Ledger/map lookup

KeyCode:
RouteName:
OrderIndex:
PrerequisiteKeys:
ProofRequiredToUnlock:
UnlocksKeys:
BoundaryClass:
AllowedHelperType:
MaxConcurrentHelpers:
BatchSize:
LockGroup:
NextSurface:
StopCondition:

## Order check

PrerequisitesPresent:
ProofPresent:
OrderAllowed:
QueueOrDispatch:
Reason:

## Branch check

IsBranch:
ParentKey:
BranchKey:
JoinBackKey:
ReturnHandoff:
MainRouteTakeoffKey:
BranchStopCondition:

## Helper readiness

CanRead:
CanWrite:
MustNotTouch:
ProofRequired:
EventLedgerRow:
HandoffTarget:
OperatorApprovalNeeded:

## Final Judge

ObjectHasKey:
RouteFound:
OrderValid:
FanOutCapped:
BranchJoinBackClear:
ProofBeforeNext:
OneNextAction:
Verdict:
