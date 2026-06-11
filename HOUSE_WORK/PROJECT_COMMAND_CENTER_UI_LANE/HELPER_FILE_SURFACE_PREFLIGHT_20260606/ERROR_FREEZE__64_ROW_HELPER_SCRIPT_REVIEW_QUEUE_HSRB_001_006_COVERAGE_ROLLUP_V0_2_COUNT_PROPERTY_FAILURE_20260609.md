# ERROR FREEZE - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.2 COUNT PROPERTY FAILURE

failed_script: BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_20260609_V0_2.ps1
failed_line: 313
failed_statement: $batchCount = (ConvertTo-ObjectArray -Value ($batches | Sort-Object -Unique)).Count
error: The property 'Count' cannot be found on this object. Verify that the property exists.

classification: RUNNER_COUNT_ON_SCALAR_OR_PIPE_OUTPUT_DEFECT
scope: coverage rollup runner only; no route, cleanup, execution, commit, push, or physical action was authorized or observed
does_not_prove: does not prove the 64-row queue is uncovered, duplicated, or damaged
required_repair: avoid Count on pipeline/scalar output; build explicit list collections and count those lists only
physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0
