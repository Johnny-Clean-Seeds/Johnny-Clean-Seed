# ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY REVIEW V0_2 STRESS BENCH 20260608

Status: REVIEW_STRESS_BENCH / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH
Created: 2026-06-08 21:06:30 -04:00
Active object: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608

## Stress results

- PASS all 48 prep rows still exist and hash-match current root
- PASS no prep rows missing at review time
- PASS no prep rows changed hash at review time
- PASS all prep rows carry plain 64-character SHA256 cells
- PASS exactly one V0_2 prep current-runner row excluded
- PASS every prep row received a review decision

## Counts

- prep_rows_parsed: 48
- prep_rows_hash_matched_now: 48
- prep_rows_missing_now: 0
- prep_rows_hash_changed_now: 0
- bad_sha_row_count: 0
- current_runner_excluded_count: 1
- empty_decision_row_count: 0
- extra_root_files_not_in_prep_snapshot_count: 3
- extra_root_scripts_not_in_prep_snapshot_count: 3
- extra_root_non_scripts_not_in_prep_snapshot_count: 0

final_verdict: ROOT_HELD_GROUP_REVIEW_V0_2_STRESS_BENCH_PASS
