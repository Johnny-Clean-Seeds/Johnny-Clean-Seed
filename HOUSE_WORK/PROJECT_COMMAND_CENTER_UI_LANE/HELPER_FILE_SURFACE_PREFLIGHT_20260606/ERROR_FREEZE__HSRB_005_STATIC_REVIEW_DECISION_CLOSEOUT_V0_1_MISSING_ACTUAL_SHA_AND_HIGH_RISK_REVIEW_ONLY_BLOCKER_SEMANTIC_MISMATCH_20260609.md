# ERROR FREEZE — HSRB-005 STATIC REVIEW DECISION CLOSEOUT V0.1

Status: ERROR_FREEZE / SAME_OBJECT_REPAIR_REQUIRED / NO_PHYSICAL_ACTION

Failed object: BUILD_HSRB_005_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_20260609_V0_1.ps1
Observed V0.1 contract_gate_passed: False
Observed missing_actual_sha256_count: 18
Observed contains_move_item_count: 6
Observed high_risk_command_marker_row_count: 6
Observed blocker_count: 24

Local cause 1: V0.1 read ActualSHA256 fields but the HSRB-005 static summary names the computed source hash SourceSha256.
Local cause 2: V0.1 treated classified review-only high-risk command markers as blockers even though execution, route, cleanup, doctrine, and action-now clearance were all zero.

Underlying classification: POSSIBLE_UNDERLYING_CONTRACT_SEMANTIC_DEFECT.
Why: repeated helper-generation defects have now appeared in collection handling, custody fields, and risk-marker contract semantics.

v0_1_risk_csv_sha256: 489184233B5FBA46F625BCBA8519C0FE0E4BAAD52C7609C7F48DE67A0320EB68
v0_1_closeout_sha256: 9FE9CFE627BCED47336767D717C93B0F7C33D7D40A646BA1393EAD922C7C77C0
v0_1_receipt_sha256: E46BE8851470ACA21AE5EBE2E5532043F9F6FABD573EFE5AB73F24192E950A03

Blocked interpretation: V0.1 does not authorize physical action and does not close HSRB-005.
Repair requirement: preserve the high-risk markers as review evidence, repair actual SHA mapping, and only pass if all clearances remain NO.
