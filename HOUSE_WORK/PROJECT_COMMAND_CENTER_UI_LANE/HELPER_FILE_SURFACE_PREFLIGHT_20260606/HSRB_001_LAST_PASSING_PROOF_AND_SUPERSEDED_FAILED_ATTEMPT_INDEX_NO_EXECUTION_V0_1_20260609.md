# HSRB-001 Last Passing Proof and Superseded Failed Attempt Index - V0.1

Status: PROOF_INDEX / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH

## Purpose

Index the five scripts in Batch HSRB-001 after static review. This separates the last passing proof helper from the superseded failed generated attempts.

## Boundary

This index does not execute, move, delete, rename, route, clean up, commit, or push anything. It only writes review evidence outputs.

## Verified inputs

| Input | Exists | HashMatch | SHA256 |
| --- | ---: | ---: | --- |
| summary_csv | True | True | `9C2E922097CB4C9DC35F931678A3D70F87B56037978FCD8A45213DA46375721D` |
| static_packet_md | True | True | `3EB8D2223F0685216227D146FBF95515D71F8F6F4CEA000EF0DC2A0E5F6A03D1` |
| static_packet_print | True | True | `542422B7754B1B50FD9FB2A539E70EC98A5BA3069BCA8A252B356E8DB4ABEE88` |
| static_packet_receipt | True | True | `595200DD309D26DFBD4D8F7DB1DC74A6D0E1EB46E9E7BC9E1D4890C906D8CF08` |
| decision_closeout_md | True | True | `03B63C7F03192B2001F4D2113DCDBC18302464B2D631110207A88A3607AE311A` |
| decision_closeout_print | True | True | `E108E4495549AB30DD74500C55C6132E0EFC35211D9E607914AB324D041883B9` |
| decision_closeout_receipt | True | True | `7FFE5E5900602791F4DD53B1BC028DDE2BD02227ECF07FA15E98F553B9DF7B75` |

## Counts

- selected_batch_id: HSRB-001
- selected_batch_rows: 5
- last_passing_proof_count: 1
- superseded_failed_attempt_count: 4
- unknown_index_role_count: 0
- contains_move_item_count: 0
- contains_remove_item_count: 0
- contains_rename_item_count: 0
- contains_start_process_count: 0
- contains_invoke_expression_count: 0
- blocker_count: 0

## Index table

| QueueID | FileName | FailureFamily | IndexRole | SourceSha256 |
| --- | --- | --- | --- | --- |
| HSRQ-016 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_2.ps1` | STRICT_PARAM_BINDING_INPUT_SHAPE | SUPERSEDED_FAILED_ATTEMPT_HOLD_AS_EVIDENCE_ONLY | `7D99F1EE4DC8EBB140A2A097B466F4DA8FD8BCF0E74EC2C131F24B9D7A313322` |
| HSRQ-017 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_3.ps1` | UNESCAPED_WINDOWS_PATH_REGEX | SUPERSEDED_FAILED_ATTEMPT_HOLD_AS_EVIDENCE_ONLY | `7F10DB255DD2A00CCB4AC90BEC2B5A9491A902946A3732933D3AAC86B234DAFB` |
| HSRQ-018 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_4.ps1` | ARGUMENT_TYPES_MISMATCH_AFTER_BROKEN_PARSER_CHAIN | SUPERSEDED_FAILED_ATTEMPT_HOLD_AS_EVIDENCE_ONLY | `FD8B25E4F1620DFECEC4D85B954A4C18100262329167F56F6EE58AFBA3178990` |
| HSRQ-019 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_5.ps1` | LAST_PASSING_CONSERVATIVE_SELECTOR_PARSER_REMOVED | LAST_PASSING_PROOF_KEEP_AS_EVIDENCE_ONLY | `8E0E0E36C347C60F28C22AB34956EFD9E9179E6E173E91E8E8D9CF507EAE7781` |
| HSRQ-020 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609.ps1` | SCALAR_COUNT_STRICTMODE_OR_COUNT_SHAPE | SUPERSEDED_FAILED_ATTEMPT_HOLD_AS_EVIDENCE_ONLY | `C7E77EB8A3B444F544504EA58635A84F87CADAD1C1D6C8D75A82AE8EBE9F2B52` |

## Authority statement

All indexed rows remain review evidence only. The last passing proof row is not route authority or execution authority. The superseded failed rows are preserved as failure evidence only.

## Blockers

None.

## Next single action

BUILD_HSRB_001_PROOF_INDEX_CLOSEOUT_NO_EXECUTION

Final verdict: HSRB_001_LAST_PASSING_PROOF_AND_SUPERSEDED_FAILED_ATTEMPT_INDEX_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION
