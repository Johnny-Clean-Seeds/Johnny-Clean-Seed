# ERROR FREEZE — HSRB-005 NEXT BATCH SELECTOR V0.1

Status: ERROR_FREEZE / SAME_OBJECT_REPAIR_REQUIRED / NO_PHYSICAL_ACTION

Failed script: BUILD_HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_005_FROM_64_QUEUE_NO_EXECUTION_20260609_V0_1.ps1
Failed line: 133
Failed command: Import-Csv -LiteralPath $QueueCsvPath | ForEach-Object { [void]$queueRows.Add($_) }
Observed error: You cannot call a method on a null-valued expression.

Immediate local cause: the script attempted to call Add() on $queueRows while $queueRows was null.
Defect class: COLLECTION_INITIALIZATION_OR_PIPELINE_ADD_DEFECT.
Wider classification: POSSIBLE_UNDERLYING_HELPER_GENERATION_DEFECT, because prior HSRB work showed repeated list/array/collection/custody generation failures.

Blocked action: do not continue by patching only the current line without removing the generated collection pattern.
Repair requirement: remove typed list factory reliance and pipeline Add() reliance; import CSV into a safe array; enumerate directly; preserve no-action boundary.
