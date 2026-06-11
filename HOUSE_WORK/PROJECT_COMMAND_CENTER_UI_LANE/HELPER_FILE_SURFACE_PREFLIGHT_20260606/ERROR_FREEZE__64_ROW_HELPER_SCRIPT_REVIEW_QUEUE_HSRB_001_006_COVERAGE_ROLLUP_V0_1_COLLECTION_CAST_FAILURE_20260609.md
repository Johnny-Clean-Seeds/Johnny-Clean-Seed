# ERROR FREEZE - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.1 COLLECTION CAST FAILURE

failed_script: BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_20260609_V0_1.ps1
failed_line: 210
failed_statement: foreach ($batchFile in @($BatchFiles)) {
error: Argument types do not match

classification: RUNNER_COLLECTION_ENUMERATION_DEFECT
scope: coverage rollup runner only; no route, cleanup, execution, commit, push, or physical action was authorized or observed
does_not_prove: does not prove the 64-row queue is uncovered, duplicated, or damaged
physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0
