# Static Review Packet - Batch HSRB-001 Active Route Selector Defect Chain - V0.2

Status: STATIC_REVIEW_PACKET / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH

## Purpose

Review Batch HSRB-001 as static text only. This packet reads source script text for evidence, hashes, and review classification. It does not run any helper script.

## Boundary

No selected script is executed. No root file is moved, deleted, renamed, routed, cleaned, committed, or pushed. The output is review evidence only.

## Verified selector inputs

| Input | Exists | HashMatch | SHA256 |
| --- | ---: | ---: | --- |
| batch_index_csv | True | True | `A80FAFB2F6E8651AD1AF2F7F1C3816F312C2927762D6F07A2D69B14E75DAF570` |
| selected_batch_csv | True | True | `65458E9677C8A05180B3A2BCA3DEF1A7F548832C7DCB58E630DEC72033D27C66` |
| batch_selector_md | True | True | `D2683053448A648174BCCEDA2F26341AB58B3E93B708342356F23B3EA915C350` |
| batch_selector_print | True | True | `4F7211F4A8DFBDD311C137E816233F9F098E05A410312316BC3783854C8727D7` |
| batch_selector_receipt | True | True | `643E0D5AECB3797B09E5CCE0F8A487057FD8A6F18578D2E4C207B1FDE7B5BEE2` |

## Counts

- selected_batch_id: HSRB-001
- selected_batch_rows: 5
- summary_rows: 5
- source_missing_count: 0
- text_read_fail_count: 0
- keep_as_last_passing_proof_count: 1
- hold_as_superseded_failed_count: 4
- contains_move_item_count: 0
- contains_remove_item_count: 0
- contains_rename_item_count: 0
- contains_start_process_count: 0
- contains_invoke_expression_count: 0
- blocker_count: 0

## Static review table

| QueueID | FileName | Lines | KnownOutcome | StaticDisposition | SHA256 |
| --- | --- | ---: | --- | --- | --- |
| HSRQ-016 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_2.ps1` | 575 | FAILED_EARLIER_STRICT_PARAM_BINDING_INPUT_SHAPE; SUPERSEDED_BY_V0_5 | HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN | `7D99F1EE4DC8EBB140A2A097B466F4DA8FD8BCF0E74EC2C131F24B9D7A313322` |
| HSRQ-017 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_3.ps1` | 600 | FAILED_EARLIER_UNESCAPED_WINDOWS_PATH_REGEX; SUPERSEDED_BY_V0_5 | HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN | `7F10DB255DD2A00CCB4AC90BEC2B5A9491A902946A3732933D3AAC86B234DAFB` |
| HSRQ-018 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_4.ps1` | 635 | FAILED_EARLIER_ARGUMENT_TYPES_MISMATCH; SUPERSEDED_BY_V0_5 | HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN | `FD8B25E4F1620DFECEC4D85B954A4C18100262329167F56F6EE58AFBA3178990` |
| HSRQ-019 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_5.ps1` | 441 | PASSED_CONSERVATIVE_LIVE_ROOT_BOARD_PARSER_REMOVED; PROOF_HELPER_ONLY | KEEP_AS_LAST_PASSING_PROOF_HELPER_REVIEW_ONLY | `8E0E0E36C347C60F28C22AB34956EFD9E9179E6E173E91E8E8D9CF507EAE7781` |
| HSRQ-020 | `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609.ps1` | 485 | FAILED_EARLIER_SCALAR_COUNT_STRICTMODE_OR_COUNT_SHAPE; SUPERSEDED_BY_V0_5 | HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN | `C7E77EB8A3B444F544504EA58635A84F87CADAD1C1D6C8D75A82AE8EBE9F2B52` |

## Static safety scan

| FileName | Move-Item | Remove-Item | Rename-Item | Start-Process | Invoke-Expression | Set-Content | Export-Csv | Set-Clipboard |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_2.ps1` | False | False | False | False | False | False | False | False |
| `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_3.ps1` | False | False | False | False | False | False | False | False |
| `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_4.ps1` | False | False | False | False | False | False | False | False |
| `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_5.ps1` | False | False | False | False | False | False | False | False |
| `BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609.ps1` | False | False | False | False | False | False | False | False |

## Review notes

### BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_2.ps1

- Known outcome: FAILED_EARLIER_STRICT_PARAM_BINDING_INPUT_SHAPE; SUPERSEDED_BY_V0_5
- Static disposition: HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN
- Review note: Earlier generated selector version failed during live use and is superseded. Preserve as failure evidence only.
- Action now: NO_EXECUTION_NO_ROUTE_NO_CLEANUP

### BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_3.ps1

- Known outcome: FAILED_EARLIER_UNESCAPED_WINDOWS_PATH_REGEX; SUPERSEDED_BY_V0_5
- Static disposition: HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN
- Review note: Earlier generated selector version failed during live use and is superseded. Preserve as failure evidence only.
- Action now: NO_EXECUTION_NO_ROUTE_NO_CLEANUP

### BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_4.ps1

- Known outcome: FAILED_EARLIER_ARGUMENT_TYPES_MISMATCH; SUPERSEDED_BY_V0_5
- Static disposition: HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN
- Review note: Earlier generated selector version failed during live use and is superseded. Preserve as failure evidence only.
- Action now: NO_EXECUTION_NO_ROUTE_NO_CLEANUP

### BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609_V0_5.ps1

- Known outcome: PASSED_CONSERVATIVE_LIVE_ROOT_BOARD_PARSER_REMOVED; PROOF_HELPER_ONLY
- Static disposition: KEEP_AS_LAST_PASSING_PROOF_HELPER_REVIEW_ONLY
- Review note: This is the conservative selector that removed the brittle route-plan parser and produced the V0.5 live-root board. It is not route authority.
- Action now: NO_EXECUTION_NO_ROUTE_NO_CLEANUP

### BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609.ps1

- Known outcome: FAILED_EARLIER_SCALAR_COUNT_STRICTMODE_OR_COUNT_SHAPE; SUPERSEDED_BY_V0_5
- Static disposition: HOLD_AS_SUPERSEDED_FAILED_HELPER_DO_NOT_RUN
- Review note: Earlier generated selector version failed during live use and is superseded. Preserve as failure evidence only.
- Action now: NO_EXECUTION_NO_ROUTE_NO_CLEANUP

## Blockers

None.

## DoesNotProve

This static packet does not prove any selected script is safe to execute, route-approved, cleanup-approved, source-authoritative, current doctrine, or ready to commit/push. It proves only that the selected batch was read as static text and classified for review.

## Next single action

BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION

Final verdict: STATIC_REVIEW_PACKET_BATCH_HSRB_001_ACTIVE_ROUTE_SELECTOR_DEFECT_CHAIN_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION
