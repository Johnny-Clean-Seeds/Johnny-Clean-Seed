# Living System Bridge / Tunnel Registry V1.4

Date: 2026-05-30
Status: TOOL-BEARING TUNNEL REGISTRY / PILOT / NOT DOCTRINE
WorkKey: LIVING-SYSTEM-FRONT-DOOR-BRIDGE-TUNNEL-20260530-V1-4

## Rule

A tunnel is not clean unless it names the toolbelt needed to travel it.

## Tunnel fields

BridgeID | SourceNode | RelationType | TargetNode | Direction | RequiredToolbelt | MethodsMode | ProofNeed | LoadShelf | CarryOutLine | LeaveBehind | Boundary | ReturnPath

## Relation types

- INDEXES
- CURRENT_COPY_OF
- PROOF_OF
- SOURCE_OF
- SUPERSEDES
- BLOCKS
- UNLOCKS_AFTER
- RETURNS_TO
- NEIGHBOR_OF
- WATCHES
- ERROR_FAMILY_OF
- LOADS_FOR_CHAT
- DROPS_FROM_CHAT
- TOOLBELT_FOR
- SMOKE_BREAK_BEFORE

## Pilot tunnels

| BridgeID | SourceNode | RelationType | TargetNode | Direction | RequiredToolbelt | MethodsMode | ProofNeed | LoadShelf | CarryOutLine | LeaveBehind | Boundary | ReturnPath |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| BRIDGE-001 | NODE-README | INDEXES | NODE-START-HERE | DOWN | FRONT_DOOR_TOOLBELT | on | README pointer block if selected | LOAD_NOW | Root URL leads to current ledger pointer. | old root wandering | pointer only | Front Door |
| BRIDGE-002 | NODE-START-HERE | INDEXES | NODE-FRONT-DOOR-LEDGER | DOWN | FRONT_DOOR_TOOLBELT | on | file exists | LOAD_NOW | Enter through living front-door ledger. | old chat pile | pointer only | Front Door |
| BRIDGE-003 | NODE-FRONT-DOOR-LEDGER | LOADS_FOR_CHAT | NODE-CHAT-LOAD-MANIFEST | DOWN | CHAT_DROP_TOOLBELT | combined | manifest exists | LOAD_NOW | Load one current manifest. | all stale drop copies | no source authority | Chat Cockpit |
| BRIDGE-004 | NODE-FRONT-DOOR-LEDGER | INDEXES | NODE-BRIDGE-TUNNEL-REGISTRY | DOWN | GRANDMASTER_TOOLBELT | combined | registry exists | LOAD_IF_NEEDED | Follow typed tunnels only. | broad map hunger | no universal graph | Grandmaster |
| BRIDGE-005 | NODE-BRIDGE-TUNNEL-REGISTRY | TOOLBELT_FOR | NODE-HUB-TOOLBELT-REGISTRY | SIDE | WORK_SHED_TOOLBELT | combined | registry exists | LOAD_IF_NEEDED | Pick hub kit before route travel. | method pile | support only | Work Shed |
| BRIDGE-006 | NODE-SAME-PROCESS-LEDGER | SMOKE_BREAK_BEFORE | NODE-FRONT-DOOR-LEDGER | BACK | FRONT_DOOR_TOOLBELT | on/off reset | checkpoint line | LOAD_IF_PROCESS_QUESTION | Reset before next wave. | prior wave phrasing | process only | Front Door |
| BRIDGE-007 | NODE-DRIFT-REVIEW | PROOF_OF | NODE-SAME-PROCESS-LEDGER | BACK | PROOF_ROOM_TOOLBELT | on | hash table | LOAD_IF_DRIFT_QUESTION | V1.4 progresses; V1/V1.1 proof-only. | superseded copies | hash is identity only | Proof Room |
| BRIDGE-008 | NODE-SUIT-CARD | LOADS_FOR_CHAT | NODE-CHAT-LOAD-MANIFEST | SIDE | CHAT_COCKPIT_TOOLBELT | on | Chat Drop copy | LOAD_NOW | Wear the short line, then follow manifest. | long design dump | not doctrine | Chat Cockpit |
| BRIDGE-009 | NODE-CURRENT-STATUS | RETURNS_TO | NODE-FRONT-DOOR-LEDGER | UP | FRONT_DOOR_TOOLBELT | on | status support only | LOAD_NOW | Status supports navigation. | status-as-authority | not active authority | Front Door |
| BRIDGE-010 | NODE-ACTIVE-ANCHOR | BLOCKS | BROAD_REFACTOR | SIDE | BOUNDARY_TOOLBELT | on | active anchor | LOAD_NOW | Block broad refactor unless separately selected. | implementation pressure | no broad refactor | Front Door |

<!-- ORGANIC_PATHING_SOFT_SUIT_DEEPENED_JOIN_V1_START -->
## Organic Pathing support tunnels V1

Status: SUPPORT TUNNELS / NOT DOCTRINE
WorkKey: ORGANIC-PATHING-SOFT-SUIT-INTAKE-GATE-JOIN-20260530-V1

| BridgeID | SourceNode | RelationType | TargetNode | Direction | RequiredToolbelt | MethodsMode | ProofNeed | LoadShelf | CarryOutLine | LeaveBehind | Boundary | ReturnPath |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| BRIDGE-ORGPATH-001 | NODE-FRONT-DOOR-LEDGER | INDEXES | NODE-ORGANIC-PATHING-JOIN | SIDE | ORGANIC_PATHING_TOOLBELT | on | receipt | LOAD_IF_NEEDED | Use path ecology only when route fog appears. | broad map hunger | support only | Front Door |
| BRIDGE-ORGPATH-002 | NODE-ORGANIC-PATHING-JOIN | TOOLBELT_FOR | NODE-ORGANIC-PATH-HEALTH-TEMPLATE | DOWN | ORGANIC_PATHING_TOOLBELT | on | template exists | LOAD_IF_NEEDED | Score 3-5 important routes only. | scoring every file | test support only | Work Shed |
| BRIDGE-ORGPATH-003 | NODE-ORGANIC-PATHING-JOIN | WATCHES | NODE-HELPER-PATHING-HANDOFF | SIDE | HELPER_PATH_EVIDENCE_TOOLBELT | on | handoff exists | LOAD_IF_NEEDED | Ensure helpers return usable path evidence. | vague helper output | support only | Work Shed |
| BRIDGE-ORGPATH-004 | NODE-ORGANIC-PATHING-JOIN | UNLOCKS_AFTER | NODE-INTAKE-GATE-PATH-ECOLOGY-TODO | FORWARD | INTAKE_GATE_JOIN_TOOLBELT | on | clean lock/save of Organic Pathing | PARKED_WITH_RETURN_TRIGGER | Deep dive Intake Gate as path metabolism mouth. | premature intake rewrite | TODO only | Front Door |
<!-- ORGANIC_PATHING_SOFT_SUIT_DEEPENED_JOIN_V1_END -->
