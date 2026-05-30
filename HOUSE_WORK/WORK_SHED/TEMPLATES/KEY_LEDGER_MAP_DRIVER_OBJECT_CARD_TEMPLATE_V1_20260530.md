# Key/Ledger/Map Driver Object Card Template V1

Date: 2026-05-30
Status: TEMPLATE / SUPPORT ARCHITECTURE

Use this template for major working parts in helper-chain packets.

## Identity

WorkKey:
TraceId:
ObjectKey:
DriverKey:
ProofKey:
LedgerKey:

## Role

What this object is:
What this object is not:
Lane:
Authority level:

## Crawl Contract

ReadAfter:
ReadBefore:
UpdateMode:
AppendAllowed:
ProofNeeded:
StopIf:
HandoffTarget:
NextQuestion:

## Driver Map

CurrentSurface:
NextSurface:
AllowedMoves:
BlockedMoves:
NeighborLinks:

## Ledger Behavior

StateBefore:
StateAfter:
EventId:
ProofPointer:
BlockedReason:
NextReturnPoint:

## Proof Behavior

EvidenceRequired:
ReceiptRequired:
HashRequired:
PassRule:
FakePassRisk:

## Self-Reflection Behavior

ActorOwnedErrorPossible:

If actor-owned error occurs, write to central incident record, actor-local self-reflection area, event log, and proof receipt after repair.

## Close Behavior

CleanCloseCondition:
BlockedCloseCondition:
FinalPacketCondition:

## Boundary

No doctrine.
No ACTIVE_GUIDES.
No CURRENT_TRUTH_INDEX.
No automation.
No broad crawler.
No PASS without proof.
