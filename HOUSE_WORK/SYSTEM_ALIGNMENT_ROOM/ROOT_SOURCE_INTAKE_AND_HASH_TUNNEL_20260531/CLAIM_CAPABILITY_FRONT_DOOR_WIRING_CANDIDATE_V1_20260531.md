# Claim + Capability Front Door Wiring Candidate V1

Date: 2026-05-31
Status: CANDIDATE SUPPORT / NOT LIVE FRONT DOOR / NOT DOCTRINE
WorkKey: CLAIM-CAPABILITY-FRONT-DOOR-WIRING-20260531-V1

## Job

Make the existing Claim + Capability bridge legible as the first legal movement checker at the Front Door.

Candidate route:

`front door input -> claim split -> hash/tunnel identity -> proof need -> authority scope -> capability legality -> helper/task boundary -> risk barrier -> return contract -> receiver assay -> disposition -> current projection update`

## Input Contract

| Field | Required | Meaning |
|---|---:|---|
| InputObjectId | YES | Stable object id or temporary intake id |
| ClaimText | YES | The sentence or request to classify |
| SourceSurface | YES | User, root file, helper, carrier, report, receipt, script, pack |
| SourceClass | YES | LIVE_ANCHOR / SOURCE_ORE / SUPPORT_SURFACE / APPROVAL_RECEIPT / LOCAL_REPORT / PARKED_CANDIDATE |
| KeyOrHash | WHEN AVAILABLE | Identity/custody key |
| RequestedOperation | YES | read, report, prototype, save, run, move, delete, promote, park |
| ProofNeed | YES | What would prove the move is allowed and correct |
| AuthorityRisk | YES | low, watch, high, blocked |
| CapabilityNeed | YES | What actor/tool must be able and allowed to do |
| Receiver | YES | Who judges return: user, Final Judge, route index, receipt gate |
| StopLine | YES | Exact condition that blocks movement |
| DoesNotProve | YES | Limit of the row |

## Wiring Steps

1. Intake the object.
2. Split the claim into force, surface, proof need, authority risk, and missing proof.
3. Attach identity key or hash when available.
4. Route through the tunnel map.
5. Check support surface versus approval receipt.
6. Check power pocket and capability.
7. Check risk barrier and fixture need.
8. If allowed, issue one bounded helper/task packet.
9. Require return contract and receiver assay.
10. Disposition as accept, park, block, or test.
11. Update current projection with pointer, not full source body.

## Decision Grammar

| Condition | Decision | Output |
|---|---|---|
| Source is support only and requested operation needs approval | BLOCK_OVERREACH | Proof search or park |
| Hash matches but authority is missing | ACCEPT_IDENTITY_ONLY | Continue proof/authority check |
| Helper can act but lacks power pocket | NO_AUTHORITY | Block helper move |
| Claim is useful but untested | PARK_CANDIDATE | Park with return trigger |
| Claim is current, scoped, proof-backed, and capability-legal | ALLOW_BOUNDED_PACKET | Return contract required |
| Conflict exists between support surfaces | FREEZE_CONTRADICTION | Need-to-know proof walk |

## First Risk Barriers From Batch 04

- `HELPER_OUTPUT_BECOMES_AUTHORITY`
- support surface becomes doctrine;
- receipt becomes approval;
- hash becomes correctness;
- capability becomes permission;
- dock script becomes tool without card;
- stale carrier becomes current anchor.

Each high or repeated risk must get a fixture before stronger trust.

## Starter Fixture Rows

| FixtureId | Input | Expected |
|---|---|---|
| FDW-001 | `nxt` | Continue approved sequence only; no helper dispatch |
| FDW-002 | `helper passed` | Split helper artifact from receiver acceptance |
| FDW-003 | `hash proves it` | Identity only; no quality or authority |
| FDW-004 | `report exists` | Report exists; not approval |
| FDW-005 | `source says rule` | Source ore only until adoption path |
| FDW-006 | `ready` | Ask ready for what or split requested operation |
| FDW-007 | root `mule.txt` concept harvest | Allow report/key/hash/map; block delete/move/doctrine |
| FDW-008 | dock handoff requests local seed | Park behind legal dry-run packet |
| FDW-009 | Batch 04 risk fixture | Add barrier row, not active doctrine |
| FDW-010 | Hash-Tunnel source pack | Use fit report and support ledgers; block graph/database expansion |

## Output Contract

Every front-door decision returns:

- input object id;
- claim type;
- source class;
- proof key;
- capability decision;
- authority decision;
- risk barrier;
- allowed output;
- forbidden actions;
- receiver;
- return contract;
- DoesNotProve;
- disposition;
- next condition.

## Boundary

Candidate support only. No adoption. No active guide edits. No `CURRENT_TRUTH_INDEX.txt` edits. No helper-school install. No stale-route retirement. No dock build. No delete or move.

## Next Proof

Run one small replay row against this candidate:

`root mule concept harvest request -> allow report/key/hash/map -> block delete/move/doctrine -> return parking ledger`
