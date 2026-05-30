# Intake Gate Run Template V1

Date: 2026-05-30
Status: TEMPLATE / SUPPORT ARCHITECTURE

## 1. Intake Contract

ObjectName:
ObjectType:
SourcePointer:
SourceHash:
SourceActor:
WorkKey:
TraceId:
Boundary:
AllowedActions:
BlockedActions:
MaxChunks:
MaxUnknownsBeforeStop:
CodePolicy:
GitPolicy:
MoveDeletePolicy:
PromotionPolicy:
CloseCondition:

## 2. Context Carry

WorkKey:
TraceId:
SourceKey:
ObjectKey:
ParentKey:
Boundary:
CurrentGate:
Risk:
ProofPointer:
NextSurface:

## 3. Helper Capability

NextHelper:
CanRead:
CanWrite:
MustNotTouch:
NeedsCodeGate:
NeedsOperatorApproval:
ProofRequired:
StopCondition:
HandoffTarget:

## 4. Chunk Index

ChunkKey:
ParentObjectKey:
ChunkType:
ShortLabel:
SourcePosition:
WordFlags:
CodeFlag:
Risk:
CandidatePile:
ProofNeed:

## 5. Pile Ledger

PileKey:
PileName:
ChunkKeys:
ReasonGrouped:
GateOwner:
NextGate:
RouteStatus:

## 6. Route Decision

PileKey:
Verdict:
Destination:
ProofNeeded:
ReturnTrigger:
BlockedMoves:

## 7. Handoff

CurrentState:
ProofTrail:
AllowedNextAction:
NeededContext:
StopCondition:
NextSurface:

## 8. Balance / Wobble

WobbleSigns:
PressureLevel:
Action:
ReturnPoint:

## 9. Final Judge

EveryChunkHasFate:
EveryRouteHasReason:
EveryUnknownHasReturnTrigger:
CodeNotExecuted:
NoBroadCrawl:
OneNextAction:
Verdict:
