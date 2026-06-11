# ROOT HELD GROUP ROUTE PLAN ONLY V0_1 STRESS BENCH 20260608

Status: ROUTE_PLAN_ONLY_STRESS_BENCH / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH
Created: 2026-06-08 21:42:32 -04:00
Active object: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608

## Stress results

- PASS script_plan_row_count_is_53
- PASS non_script_plan_row_count_is_5
- PASS total_plan_row_count_is_58
- PASS no route plan row authorizes action now
- PASS all route plan rows have plain SHA256 values
- PASS every route plan row has a proposed bucket
- PASS no route plan row authorizes delete now
- PASS no route plan row authorizes move or route now
- PASS exactly one current runner is held no-route

## Counts

- script_plan_row_count: 53
- non_script_plan_row_count: 5
- total_plan_row_count: 58
- action_now_row_count: 0
- bad_sha_row_count: 0
- blank_bucket_row_count: 0
- delete_now_row_count: 0
- move_route_now_row_count: 0
- current_runner_route_plan_row_count: 1
- leave_in_place_row_count: 1
- dry_run_required_row_count: 56

final_verdict: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_STRESS_BENCH_PASS
