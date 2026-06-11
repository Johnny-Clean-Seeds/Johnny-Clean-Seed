# Error Freeze - HSRB-001 Static Review Decision Closeout V0.1 Missing Decision Property

Status: ERROR_FREEZE / GENERATED_SCRIPT_DEFECT / SAME_OBJECT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP

Failed script: BUILD_HSRB_001_STATIC_REVIEW_DECISION_CLOSEOUT_NO_EXECUTION_20260609_V0_1.ps1
Failure line: 56
Failure expression: $summaryRows | Where-Object { $_.Decision -eq ... }
Failure message: The property Decision cannot be found on this object.

Classification: GENERATED_SCRIPT_DEFECT__SUMMARY_SCHEMA_MISMATCH_DECISION_COLUMN_EXPECTED_STATIC_DISPOSITION_ACTUAL

Actual source summary column produced by static review packet V0.2: StaticDisposition.

Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0
