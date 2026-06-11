# INDEX: GENERATED POWERSHELL COLLECTION / PARAMETER-BINDING DEFECT

Status:
GENERATED_POWERSHELL_COLLECTION_PARAMETER_BINDING_DEFECT_INDEX_WRITTEN_NO_EXECUTION / NO_EXECUTION / NO_PHYSICAL_ACTION

Purpose:
Build one bounded index of the generated PowerShell collection, enumeration, parameter-binding, blank-line, null-list, count-property, and list-array failure family.

Branch source:
Generated PowerShell collection/parameter-binding template defect remains open as a helper/template quality branch after root route lane closeout.

Counts:
- total_indexed_artifact_count: 36
- error_freeze_count: 13
- fix_or_repair_note_count: 9
- rule_or_template_card_count: 12
- rollup_or_generated_runner_context_count: 2

Artifact role groups:

Count Name
----- ----
   13 ERROR_FREEZE
   12 RULE_OR_TEMPLATE_CARD
    9 FIX_OR_REPAIR_NOTE
    2 ROLLUP_OR_GENERATED_RUNNER_CONTEXT



Defect family groups:

Count Name
----- ----
   16 GENERAL_COLLECTION_PARAMETER_BINDING_DEFECT
    5 COLLECTION_FACTORY_OR_NULL_COLLECTION
    3 ARGUMENT_TYPE_MISMATCH
    3 SAFE_COLLECTION_ENUMERATION_REPAIR
    2 BLANK_OR_EMPTY_LINE_BINDING
    2 LIST_ARRAY_ENUMERATION
    1 COLLECTION_CAST_FAILURE
    1 COUNT_AND_STRING_CAST_REPAIR
    1 COUNT_PROPERTY_FAILURE
    1 EMPTY_COLLECTION_BINDING
    1 LINE_LIST_FACTORY



Latest error freezes:

Name
----                                                                                                             
FREEZE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_1_FAILED_BEFORE_VALID_VERDICT_COLLECTION_FACTORY_DEFECT_20260609.md
ERROR_FREEZE__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_1_COLLECTION_CAST_FAILURE_2026060
9.md
ERROR_FREEZE__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_2_COUNT_PROPERTY_FAILURE_20260609
.md
ERROR_FREEZE__HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_V0_2_BLANK_LINE_WRITER_PARAMETER_BINDING_FAILURE_20260609.
md
ERROR_FREEZE__HSRB_005_NEXT_BATCH_SELECTOR_V0_1_NULL_QUEUE_ROWS_COLLECTION_FACTORY_20260609.md
ERROR_FREEZE__HSRB_004_DISPOSITION_INDEX_V0_1_LIST_ARRAY_ARGUMENT_TYPE_MISMATCH_20260609.md
ERROR_FREEZE__HSRB_002_TICKET_ID_REPAIR_V0_1_NULL_LINE_LIST_FACTORY_20260609.md
ERROR_FREEZE__HSRB_002_STATIC_REVIEW_DECISION_CLOSEOUT_V0_1_EMPTY_STRING_LINES_BINDING_20260609.md
ERROR_FREEZE__HSRB_001_PROOF_INDEX_CLOSEOUT_V0_1_EMPTY_COLLECTION_BINDING_20260609.md
ERROR_FREEZE__STATIC_REVIEW_PACKET_BATCH_HSRB_001_V0_1_NULL_LINE_LIST_20260609.md
ERROR_FREEZE__HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_1_ARGUMENT_TYPES_MISMATCH_20260609.md
ERROR_FREEZE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_1_ARGUMENT_TYPES_MISMATCH_20260609.md



Latest fix / repair notes:

Name
----                                                                                                             
REPAIR_NOTE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_2_COLLECTION_FACTORY_NO_EXECUTION_20260609.md
FIX_NOTE__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_3_EXPLICIT_LIST_COUNTERS_20260609.md
FIX_NOTE__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_2_SAFE_COLLECTION_ENUMERATION_2026060
9.md
FIX_NOTE__HSRB_005_NEXT_BATCH_SELECTOR_V0_2_UNDERLYING_COLLECTION_PATTERN_REPAIR_20260609.md
FIX_NOTE__HSRB_004_DISPOSITION_INDEX_V0_3_ARRAY_ENUMERATION_REPAIR_20260609.md
FIX_NOTE__HSRB_004_DISPOSITION_INDEX_V0_2_LIST_ARRAY_REPAIR_20260609.md
FIX_NOTE__HSRB_001_PROOF_INDEX_CLOSEOUT_V0_2_LIST_PARAMETER_REPAIR_20260609.md
FIX_NOTE__STATIC_REVIEW_PACKET_BATCH_HSRB_001_V0_2_LINE_LIST_FACTORY_REPAIR_20260609.md
FIX_NOTE__HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_V0_2_COUNT_AND_STRING_CAST_REPAIR_20260609.md



Core finding:
The repeated defect family is not one isolated script bug. It is a generated PowerShell output-contract defect family involving one or more of:
- scalar string passed where list/array is expected
- empty collection binding
- null line-list factory
- blank-line writer parameter binding
- unsafe collection enumeration
- count property failure
- list-array mismatch
- over-trust in generated rollups before static proof

Control rule:
Generated helpers in this family must be treated as untrusted until they pass a static contract gate and a dry-run fixture gate.
Manual coverage findings may be used as evidence only when their source counts, filenames, and route boundaries are explicitly recorded.

DoesNotProve:
This index does not repair any script.
This index does not authorize execution, routing, cleanup, deletion, rename, move, commit, push, source rewrite, doctrine promotion, or helper execution.
This index does not make any generated rollup active authority.
This index only groups the defect family and prepares the next repair-control step.

Next single action:
BUILD_GENERATED_POWERSHELL_COLLECTION_PARAMETER_BINDING_REPAIR_CONTRACT_NO_EXECUTION

Final verdict:
GENERATED_POWERSHELL_COLLECTION_PARAMETER_BINDING_DEFECT_INDEX_WRITTEN_NO_EXECUTION
