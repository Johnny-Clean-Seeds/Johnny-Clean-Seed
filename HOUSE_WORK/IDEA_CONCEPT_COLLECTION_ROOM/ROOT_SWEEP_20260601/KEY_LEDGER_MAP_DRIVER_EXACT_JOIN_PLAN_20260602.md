# Key / Ledger / Map Driver Exact Join Plan

Date: 2026-06-02
Status: EXACT JOIN PLAN / CANDIDATE SUPPORT / NOT ACTIVE HELPER
WorkKey: KEY-LEDGER-MAP-DRIVER-EXACT-JOIN-PLAN-20260602

## Purpose

Create the first bounded bridge/tunnel link pass for the Key/Ledger/Map Driver family without using the broad candidate field as a write target.

The start scan found a large field, but this plan intentionally narrows the active object to seven known driver files. The plan links roles and custody without rewriting the source files.

## Proof inputs

- Mini-case 01 proof pattern: HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/ROOT_SWEEP_20260601/LOWER_CAUSE_FILE_STAGE_COMMIT_EDGE_PROOF_PATTERN_MINI_CASE_01_20260602.md SHA256 720156D7052B2D5AE9A6E1E681E68080705FBCEA43BB49134A18ED5579689478
- Exact join selector report: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\LEDGER_BRIDGE_TUNNEL\READ_KEY_LEDGER_MAP_DRIVER_FIRST_LINK_PASS_V1_20260602_225158.txt SHA256 75BD178F2606533CE172E330748FCBE1C6B588AA341DC1DB890E9B79378B0521
- Repo HEAD at write: 61a7d5e0981a495f3fdbb2a04adbcccddcbb0c4d

## Exact source set

| Role | Path | SHA256 |
|---|---|---|
| brain_rule | BRAIN_LEARNING/KEY_LEDGER_MAP_DRIVER_RULE_20260530.md | C5AE586CDFCB9E9BD286387D0F477A7077C1F0042059A57AD9DE3B0941DE4CD5 |
| index_map | HOUSE_WORK/WORK_SHED/INDEXES/KEY_LEDGER_MAP_DRIVER_MAP_V1_20260530.md | 434EBFD58171E26532537AB11F3D03BB10DA6CBEF5D1FEF6DC755F8FB7E8FFE6 |
| object_card_template | HOUSE_WORK/WORK_SHED/TEMPLATES/KEY_LEDGER_MAP_DRIVER_OBJECT_CARD_TEMPLATE_V1_20260530.md | F2844392B0586DBCF4B7D821693006E7B8C9264792AD200334329E0F6510F5D3 |
| fit_report | HOUSE_WORK/WORK_SHED/SORTING_BENCH/KEY_LEDGER_MAP_DRIVER_FIT_REPORT_20260530.md | F2BC8395E220434F926231620FBB9E4C5DDA1408B256DCC44B8C32B42CD74A43 |
| cwd_route_learning_event | HOUSE_WORK/WORK_SHED/SORTING_BENCH/KEY_LEDGER_MAP_DRIVER_CWD_ROUTE_LEARNING_EVENT_20260530.md | 4A23AD2074E480DFE12EB5A5B3F9C3579C31C7A7DC4ED409F0DE9A7993D04514 |
| ignored_path_learning_event | HOUSE_WORK/WORK_SHED/SORTING_BENCH/KEY_LEDGER_MAP_DRIVER_IGNORED_PATH_LEARNING_EVENT_20260530.md | 0D54D210FFB3056360EB12BF679CF5FB0D2CF6D2A20698024E965E95CAD8CA47 |
| proof_receipt | PROOF_HISTORY/KEY_LEDGER_MAP_DRIVER_LOCK_RECEIPT_20260530.txt | 943B319A7343138CA6603C8C99D16B4BD51D45D1DB1E97CED51A6FC4E4F3670E |

## Join table

| From | To | Link type | Why |
|---|---|---|---|
| brain_rule | index_map | governs | The rule defines the driver behavior; the map gives navigable structure. |
| index_map | object_card_template | shapes | The map needs a repeatable object card shape to prevent loose route records. |
| fit_report | brain_rule | validates | The fit report explains why the rule belongs and what boundaries it carries. |
| cwd_route_learning_event | index_map | repairs route surface | The CWD event captures the wrong-root/route lesson that the map must preserve. |
| ignored_path_learning_event | index_map | repairs ignored-path surface | The ignored-path event captures the skipped-path/false proof lesson that the map must preserve. |
| proof_receipt | all driver files | proves prior save | The receipt proves the prior driver lock/save, but does not replace content judgment. |
| Mini-case 01 proof pattern | future lock/save | supplies edge gate | Future writes must prove file edge, staged edge, commit edge, receipt edge, and authority boundary. |

## Bridge / tunnel rule for this family

Bridge: connect rule, map, template, fit report, learning events, and receipt so later helpers can find the right source without broad search.

Tunnel: allow route repair lessons to feed the map without moving or rewriting the source files.

The bridge/tunnel does not promote the driver into an active helper. It only prepares a bounded join plan.

## Authority and custody boundaries

- Source files stay in place.
- WORK_SHED files remain source/support in this pass.
- This plan does not rewrite ACTIVE_GUIDES.
- This plan does not rewrite CURRENT_TRUTH_INDEX.
- This plan does not create automation, watchers, command-center execution, or active helper behavior.
- Receipt proves save custody only; it does not become authority by itself.
- Any later save must use the Mini-case 01 proof pattern and the Anchor Coverage Gate.

## Next object options

1. Save this exact join plan and receipt.
2. After save, build a small join index/card only if it has a clear home and proof target.
3. If a broader bridge/tunnel map is needed later, expand from this exact source set, not from the full broad scan field.

## Done condition

This plan is done when it is saved as a two-file set with a receipt, a clean final repo state, and a final HEAD equal to origin/main.

## Blocked uses

- Do not use this as permission to rewrite source driver files.
- Do not use this as permission to stage WORK_SHED changes.
- Do not use this as permission to build a broad crawler from all candidate hits.
- Do not treat the bridge/tunnel link as active runtime behavior.
