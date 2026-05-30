# Key-Code Dispatch Governor and Logical Growth Order Rule

Date: 2026-05-30
Status: SUPPORT RULE / NOT DOCTRINE
Authority: not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Rule

Keys request routes. Keys do not directly spawn helpers.

The ledger/map is the routing brain. It decides what key means what route, with what boundary, proof, order, stop condition, and next surface.

## Required key-route fields

KeyCode:
ObjectHash:
ObjectKey:
RouteName:
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
NextGrowthStep:
NextSurface:
StopCondition:
IfBlocked:
IfDuplicate:
IfUnknown:
IfFailed:
IfPassed:

## Dispatch governor

The governor prevents thundering herd behavior.

A ledger/map may find many keys, but dispatch must be capped by:

- max active helpers;
- batch size;
- priority;
- dependency order;
- lock/mutex group;
- proof-before-next;
- stop-after count;
- lane owner limits.

100000 keys become a queued/keyed ledger, not 1000 helpers at once.

## Logical growth order

The key system is not just routing. It is ordered growth.

Each completed/proven step becomes the stable floor for the next step.

Flow:

KEY FOUND
-> CHECK PREREQUISITES
-> CHECK PROOF
-> CHECK ORDER
-> RUN OR ROUTE ONE BOUNDED STEP
-> RECORD RESULT
-> UNLOCK NEXT KEY

## Maturity states

RAW:
not ready to unlock helper action.

SORTED:
classified and keyed, but not proven.

ROUTED:
assigned to destination/next gate.

TESTED:
manual or helper test ran.

PROVEN:
proof exists for this bounded step.

STABLE:
can become part of normal route.

READY_FOR_NEXT:
can unlock the next bounded step.

PARKED:
held with return trigger.

BLOCKED:
chain stops until repaired or rerouted.

SUPERSEDED:
kept as proof trail or old state, not live carry.

## Core line

Each key is a rung, not a firework.

One rung must hold before the next rung gets weight.
