# Lower Cause Gate Fixture Set Minimum Proof Plan V0.3

Date: 2026-06-02
Status: MINIMUM PROOF PLAN / CANDIDATE SUPPORT / NOT ACTIVE HELPER
WorkKey: LOWER-CAUSE-GATE-FIXTURE-SET-MINIMUM-PROOF-PLAN-20260602-V0-3

## Purpose

Convert the committed lower-cause gate fixture next-work TODO into one small proof plan before changing any helper behavior.

This is smaller than a tool build. It chooses the first proof target, preserves blocked uses, adds the lower-layer issue scan, and sets a stop condition.

## Source custody

- HOUSE_WORK/TODO/LOWER_CAUSE_GATE_FIXTURE_SET_NEXT_WORK_20260601.md - SHA256 E49BB118A434F91B02DD0C28F7E4C43EA9688561622F77566A732F984048F3B0
- HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/ROOT_SWEEP_20260601/LOWER_CAUSE_SOURCE_FILE_AUDIT_TABLE_20260601.csv - SHA256 91E879C21F40A6CFDEB1A33891DE2A5B043DB16B9BD375ACBBCF2E8C28A0833A
- HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/ROOT_SWEEP_20260601/LOWER_CAUSE_METHOD_LAB_ROUTE_INDEX_20260602.md - SHA256 8551BD39BDAC1601A304535CCBC2EFE57A07A1050E074B56CF8EC1E1FDB2C758
- HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/ROOT_SWEEP_20260601/LOWER_CAUSE_SAFE_FIRST_LIVING_INJECTION_REPAIR_REPORT_20260602.md - SHA256 CF785D35C50E508B14070B0EAC5EA8AB44143EA6BEA9F955FFCC3CE7B9442AE9
- HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/ROOT_SWEEP_20260601/MULE_MINIMUM_ANCHOR_LOWER_CAUSE_LIVING_INJECTION_20260601.md - SHA256 0BDC42FC70A1DB31845DE793B7921F0CD7623D21656A94411D6773114349CE44
- BRAIN_LEARNING/ANCHOR_COVERAGE_GATE_SAVE_WORKFLOW_RULE_20260602.md - SHA256 68CDD25E176670962FBE45F44967F2BB80D8F3E2DFF646D2AED528874CF2B0DF

## Scope

In scope:

- lower-cause gate fixture set only;
- candidate fixture rows derived from the committed audit table;
- proof fields for file edge, staged edge, receipt edge, helper output authority, candidate or active label, and duplicate or sequence claim handling;
- lower-layer issue scan for root mechanism, proof horizon, state edge, authority boundary, helper contract, custody, stale evidence, rerun safety, and earlier-layer cause;
- first runnable proof target selection;
- stop condition before helper or tool behavior changes.

Out of scope:

- automation;
- watcher;
- broad refactor;
- ACTIVE_GUIDES rewrite;
- CURRENT_TRUTH_INDEX rewrite;
- WORK_SHED staging;
- mule dumping;
- helper activation or callable-tool promotion.

## Lower-layer issue scan gate

Before fixing the visible symptom, the proof route must check whether a lower-layer issue is causing it.

The scan is bounded to the active object. It is not a broad wandering crawl.

Check these layers:

1. root mechanism - what mechanism actually failed;
2. proof horizon - what the proof actually proves and where it stops;
3. file edge - current path, existence, hash, and readback;
4. staged edge - staged name-status and cached diff proof;
5. commit edge - committed object versus worktree object;
6. receipt edge - custody record versus authority judgment;
7. authority boundary - candidate, support, active, helper, output, receipt;
8. helper contract - what the helper is allowed to claim or do;
9. stale evidence - old proof reused after payload changed;
10. rerun safety - what happens if the script is run again after success;
11. earlier-layer cause - whether the visible failure is downstream from a prior route or tool design.

Pass condition: either a lower-layer issue is named with proof, or the route states that no lower-layer issue was found within the active proof horizon.

## Starter fixture family

1. ready claim without current file-edge proof;
2. commit allowed after failed staged check;
3. content-valid treated as proof-valid;
4. worktree proof used as staged proof;
5. receipt treated as judgment;
6. helper output treated as authority;
7. correction treated as closeout;
8. old proof used for changed payload;
9. candidate tool treated as active or callable;
10. sequence-looking folder treated as duplicate without hash or manifest proof.

## Required fixture fields

| Field | Required meaning |
|---|---|
| FixtureId | Stable ID for the proof case. |
| FailureClaim | The false or unsafe claim being tested. |
| LowerLayerScan | Root mechanism, proof horizon, state edge, authority boundary, helper contract, custody, stale evidence, rerun safety, and earlier-layer cause. |
| FileEdgeProof | What file path, hash, or readback proves the current object. |
| StageEdgeProof | Whether staged state, worktree state, or committed state is being judged. |
| ReceiptEdgeProof | Whether the receipt proves action, judgment, or only custody. |
| AuthorityBoundary | Candidate, support, active, helper, output, and receipt distinction. |
| PassCondition | What must be true before the claim is allowed. |
| BlockCondition | What stops the route. |
| NextAction | Smallest next safe action after the fixture verdict. |

## Candidate support rows from audit table

Audit row count: 56

Disposition counts:

- inject as candidate support: 20
- keep separate no double injection: 16
- park with return trigger: 6
- indexed and parked: 4
- mined and parked: 4
- park with source packet: 3
- indexed and mined: 2
- mined into method selector/card intake: 1

### First inject-as-candidate-support rows

- Source: CARD_HARVEST_LEDGER_V0_1_LONG_LIST_20260601\CARD_HARVEST_LEDGER_V0_1_LONG_LIST_20260601.md; SHA256: 3D94E68B47C59C052EAE620E3F4AEFDF40DFAF50E009558BC135F6B84D3546E9; ProofNeed: card family breakdown before adoption; ReturnTrigger: when method deck/card pull opens
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\11_C11_POKA_YOKE_FILE_EDGE_GATE_COMBO.md; SHA256: 79D9FE83579569108E30DAE2A633C493EBD20E274552F7CE93859707B7960D8F; ProofNeed: fixture/proof before enforcement; ReturnTrigger: when file-edge prevention is needed
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\12_C12_BOWTIE_BARRIER_STOPLINE_COMBO.md; SHA256: 01A19AA034C94FABE7676CDA879BDA2ABAA36DC566F7B9B450F680993E8AF390; ProofNeed: barriers must map to checks; ReturnTrigger: when risk barrier or stopline is needed
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\13_C13_8D_FRACAS_SCAR_LEDGER_COMBO.md; SHA256: 8FA213BB49E2112440181495247039D635CB079A7A10748BB5C5D6359E42D918; ProofNeed: scar ledger template needed; ReturnTrigger: when recurrence memory is needed
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\14_C14_FMEA_PROOF_FIXTURE_COMBO.md; SHA256: 0FADCAE0E808A975421368E5E9DB947A80D50E1BE986D5D4F39952733CCA4B29; ProofNeed: fixture rows needed; ReturnTrigger: when proof bench is built
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\18_C18_DOUBLE_LOOP_LEARNING_OBJECTIVE_REWRITE_COMBO.md; SHA256: F1FAF59E735027390040639FB7DE9390A5DC88739C4D96D7B9AFD96B7619EE17; ProofNeed: helper objective rewrite proof needed; ReturnTrigger: when helper did weak objective correctly

### First keep-separate no-double-injection rows

- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260602\00_COMBO_METHOD_LAB_INDEX.md; SHA256: 4836D6D8690B33CF5E027AE4BB937E0DB1EFEA5804FDAE88FB5FC630299BFB23; ProofNeed: hash/manifest proof already shows same content; ReturnTrigger: when user confirms sequence meaning
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260602\11_C11_POKA_YOKE_FILE_EDGE_GATE_COMBO.md; SHA256: 79D9FE83579569108E30DAE2A633C493EBD20E274552F7CE93859707B7960D8F; ProofNeed: hash/manifest proof already shows same content; ReturnTrigger: when user confirms sequence meaning
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260602\12_C12_BOWTIE_BARRIER_STOPLINE_COMBO.md; SHA256: 01A19AA034C94FABE7676CDA879BDA2ABAA36DC566F7B9B450F680993E8AF390; ProofNeed: hash/manifest proof already shows same content; ReturnTrigger: when user confirms sequence meaning
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260602\13_C13_8D_FRACAS_SCAR_LEDGER_COMBO.md; SHA256: 8FA213BB49E2112440181495247039D635CB079A7A10748BB5C5D6359E42D918; ProofNeed: hash/manifest proof already shows same content; ReturnTrigger: when user confirms sequence meaning
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260602\14_C14_FMEA_PROOF_FIXTURE_COMBO.md; SHA256: 0FADCAE0E808A975421368E5E9DB947A80D50E1BE986D5D4F39952733CCA4B29; ProofNeed: hash/manifest proof already shows same content; ReturnTrigger: when user confirms sequence meaning

### First parked-return rows

- Source: CARD_HARVEST_LEDGER_V0_1_LONG_LIST_20260601\CARD_HARVEST_LEDGER_V0_1_RECEIPT_20260601.md; SHA256: A21A9D28FB1B0EEBA46CDA201ECE5BC27DA6CCEF60D4E559F9601A9403133A3A; ProofNeed: receipt proves sandbox file identity only; ReturnTrigger: when checking harvest hash identity
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\15_C15_PDSA_SMALL_PROOF_EXPERIMENT_COMBO.md; SHA256: F96FF11B03FB652BCBADEC95D62EFF01477117685C810B2DC56A0C7F526A016E; ProofNeed: small-cycle proof design needed; ReturnTrigger: when scaling lower-cause gate
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\16_C16_SAFETY_II_SUCCESS_PATH_CONTRAST_COMBO.md; SHA256: 2A200DF292BB5D18A36F2D5BFC1F82FC36D20B566E39EEAFEC8A6C6555B20329; ProofNeed: convert perspective to checklist before use; ReturnTrigger: when blame-free success-path contrast is needed
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\17_C17_CYNEFIN_DOMAIN_ROUTING_COMBO.md; SHA256: 27E0657D2E1B9434B398E1CC3B9999D4DDBFF99540AF30D549BC0A0EE8CE8A1C; ProofNeed: tie domain route to actual next command; ReturnTrigger: when method routing is unclear
- Source: LOWER_CAUSE_COMBO_SEARCH_METHOD_LAB_20260601\COMBO_METHOD_RUN_LEDGER.csv; SHA256: 2E32D783D9F0C6D48F960119397FEEC126B5E81C1BB007FBB1EE4B1B546DC225; ProofNeed: csv parse/use if future table work opens; ReturnTrigger: when comparing combo methods

## First runnable proof target

Target: LOWER_CAUSE_FILE_EDGE_AND_STAGED_EDGE_FIXTURE_MINI_CASE_01

Why this first:

- It is lower-layer and repeated across the recent failures.
- It separates file existence and readback from staged proof.
- It directly prevents commit or save claims after stale, unstaged, or post-change payloads.
- It is small enough to test before any helper behavior changes.

Mini-case 01 should test:

1. lower-layer issue scan completed first;
2. current worktree file exists;
3. current worktree SHA256 is printed;
4. staged version exists when staged proof is claimed;
5. staged name-status includes the file when staged proof is claimed;
6. git diff --check --cached passes before staged proof is allowed;
7. receipt says exactly what it proves and does not judge beyond that proof;
8. candidate or support files do not become active or callable without a separate promotion gate.

## Stop condition

Stop before helper or tool behavior change unless Mini-case 01 proves file-edge and staged-edge distinction cleanly.

Stop immediately if:

- lower-layer issue scan is skipped;
- worktree proof is being used as staged proof;
- receipt proof is being used as authority judgment;
- candidate or support object is being treated as active or callable;
- a changed payload reuses old proof;
- duplicate or sequence claim lacks hash or manifest proof.

## Anchor coverage

AnchorRequired: True for save routes that commit this plan or any follow-on next-route state.

Anchor source: HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/ROOT_SWEEP_20260601/MULE_MINIMUM_ANCHOR_LOWER_CAUSE_LIVING_INJECTION_20260601.md - SHA256 0BDC42FC70A1DB31845DE793B7921F0CD7623D21656A94411D6773114349CE44

The follow-on save route must prove the plan file and receipt are staged and must print their hashes.

## Done condition

- plan file exists in the durable root-sweep room;
- source hashes are printed;
- lower-layer issue scan gate is included;
- first runnable proof target is named;
- blocked uses are preserved;
- no helper behavior has changed;
- no commit or push happens in this write step.
