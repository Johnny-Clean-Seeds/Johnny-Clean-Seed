# ERROR FREEZE — HSRB-005 STATIC REVIEW DECISION CLOSEOUT V0.3 VERDICT WORDING OVERCLAIM

Status: ERROR_FREEZE / MICRO_CONTRACT_WORDING_DEFECT / NO_PHYSICAL_ACTION

Observed issue:
- V0.3 contract data passed and reported contains_move_item_count: 0 and high_risk_command_marker_row_count: 0.
- V0.3 final verdict still said CLASSIFIED_REVIEW_ONLY_HIGH_RISK_MARKERS, which overclaims high-risk markers when the reconciled count is zero.

Interpretation:
- V0.1 move/high-risk count was a false positive produced by broad row-text fallback scanning.
- Static packet V0.1 and V0.3 risk CSV agree that HSRB-005 has copy/git markers but no move/high-risk command markers.
- The correction is not to reintroduce the false-positive move count; the correction is to remove the high-risk overclaim from the verdict language.

v0_1_reported_contains_move_item_count: 6
v0_1_reported_high_risk_command_marker_row_count: 6
v0_1_reported_missing_actual_sha256_count: 18
static_summary_contains_move_item_count: 0
v0_3_risk_index_contains_move_item_count: 0
v0_3_verdict_overclaim_count: 1

Blocked interpretation: V0.3 did not authorize physical action, but its verdict wording was too broad and must not be carried forward uncorrected.
