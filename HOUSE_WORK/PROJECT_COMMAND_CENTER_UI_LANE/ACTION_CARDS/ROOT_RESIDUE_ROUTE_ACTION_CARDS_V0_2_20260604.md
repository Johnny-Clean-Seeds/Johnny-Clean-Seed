# Root Residue Route Action Cards V0.2

Date: 2026-06-04
Status: ACTION CARD SET / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: ROOT-RESIDUE-ROUTE-ACTION-CARDS-V0-2-20260604

## Shared Guard

Loose root material is wrong-lane until proven allowed. Source must be hashed and given a durable or parked lane before the root copy is removed.

| Card | Trigger | Route target | Allowed action | Forbidden action | Proof | Closeout |
|---|---|---|---|---|---|---|
| Root loose file | direct file outside allowed root set | source handoff, report room, TODO, or parking | hash, copy/move, verify, remove root copy after custody | delete without custody | before hash, routed hash, final root list | `ROOT_NO_LOOSE_FILES_CHECK_PASS` |
| Root loose folder | direct folder outside allowed root set | parking or owner lane after manifest | manifest folder, classify, route package | rename as duplicate without proof | file count, manifest/hash summary | parked or routed verdict |
| Known runner | script/helper-like object | `_LOCAL_RUNNERS` or runner reference lane | park as local-only unless authorized | run or activate | hash, local-only status | `TARGET_HELPER_NOT_RUN` |
| Handoff packet | mule/order/report source | lane `SOURCE_HANDOFFS` | preserve exact source, extract useful rules | treat source as authority | source hash and derived artifacts | source plus durable outputs |
| Source note | idea/raw note | idea concept room or source notes lane | extract candidates, cite source, preserve boundary | claim doctrine/current | source hash, candidate path | candidate/support verdict |
| Parked package | mixed/unknown package | parking lane with return trigger | inventory and park | call closed without trigger | return trigger and owner | `PARKED_WITH_RETURN_TRIGGER` |
| Zip artifact | archive/package | package review lane or parking | inspect metadata, no nested zip check | create nested zip | archive list, nested verdict | `NO_NESTED_ZIPS` or blocked |
| Unknown user original | unclear source/owner | stop/ask or custody parking | hash and stop before destructive changes | delete/move if ownership unclear | hash and question | `REAL_BLOCKER_STOP_AND_ASK` |
