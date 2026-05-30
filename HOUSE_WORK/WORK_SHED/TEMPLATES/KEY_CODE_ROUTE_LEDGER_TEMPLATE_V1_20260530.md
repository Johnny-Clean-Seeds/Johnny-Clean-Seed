# Key-Code Route Ledger Template V1

Date: 2026-05-30
Status: TEMPLATE / SUPPORT ARCHITECTURE

## Ledger columns

KeyCode:
ObjectHash:
ObjectKey:
SourcePath:
RouteName:
RouteType:
OrderIndex:
Priority:
PrerequisiteKeys:
ProofRequiredToUnlock:
UnlocksKeys:
DependencyReason:
LaneOwner:
BoundaryClass:
MaturityState:
AllowedHelperType:
MaxConcurrentHelpers:
BatchSize:
MaxFanOut:
LockGroup:
BranchKey:
ParentKey:
JoinBackKey:
MainRouteTakeoffKey:
NextGrowthStep:
NextSurface:
StopCondition:
IfBlocked:
IfDuplicate:
IfUnknown:
IfFailed:
IfPassed:
ProofPointer:
HandoffPointer:
LastEventId:
LastUpdated:

## Dispatch verdicts

QUEUE:
key is real but not ready.

PARK:
key is held with return trigger.

BLOCK:
key cannot continue.

DISPATCH_ONE:
one bounded helper/action may proceed.

HANDOFF_ONLY:
write/read handoff, no helper action.

WAIT_FOR_PROOF:
prerequisite not proven.

MERGE_BACK:
branch returns to parent route.

END_LOCAL:
branch complete, vine continues elsewhere.

READY_FOR_NEXT:
proof unlocks next key.

## Safety defaults

MaxConcurrentHelpers: 1
BatchSize: 1
MaxFanOut: 1
BoundaryClass: LOCAL_ONLY unless explicitly routed otherwise
MaturityState: RAW until proven otherwise
