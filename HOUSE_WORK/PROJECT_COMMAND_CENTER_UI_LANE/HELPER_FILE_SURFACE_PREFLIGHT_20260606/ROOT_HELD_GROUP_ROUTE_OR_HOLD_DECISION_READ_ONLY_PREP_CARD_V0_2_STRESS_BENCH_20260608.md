# ROOT HELD GROUP READ ONLY PREP CARD V0_2 STRESS BENCH 20260608

Status: STRESS_BENCH / FORMAT_VALIDATION / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH
Created: 2026-06-08 21:01:55 -04:00
Active object: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_20260608

## Stress results

- PASS parsed_row_count_matches_observed_root_file_count: 48
- PASS no literal PowerShell object-expression markers in SHA cells
- PASS all parsed SHA cells are plain 64-character uppercase hex
- PASS parsed rows match root snapshot names, sizes, and hashes
- PASS exactly one current runner script excluded from held decision
- PASS hostile object-expression SHA row rejected by strict parser

## Counts

- observed_root_top_level_file_count: 48
- parsed_row_count: 48
- bad_marker_row_count: 0
- bad_sha_row_count: 0
- parsed_snapshot_mismatch_count: 0
- current_runner_excluded_count: 1

final_verdict: ROOT_HELD_GROUP_PREP_CARD_V0_2_STRESS_BENCH_PASS
