# CONTRACT: POST-DELTA ROUTE RECONSIDERATION SELECTOR V0_2

Status:
CONTRACT_BUILT / SCRIPT_NOT_BUILT / SCRIPT_NOT_EXECUTED / NO_ROUTE / NO_CLEANUP

Design source:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\DESIGN__POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_V0_2_NO_EXECUTION_20260609.md

Design SHA256:
5BD6866B9FA873C3226321843FA06E9AB224F1F338DBBB7B250B8CFE2D2F968D

Diagnosis source:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\DIAGNOSIS__POST_DELTA_SELECTOR_V0_1_DESTINATION_DERIVATION_DEFECT_NO_EXECUTION_20260609.md

Diagnosis SHA256:
1EF6DD2D34D06E3EBF310BF0D0D90A7698A8BED1D3C75739600F53F4B33C9B09

Route plan source:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md

Route plan SHA256:
FBDA72FCC368B608EE2802B7FDC9941A451446E7E7A8AD1D9D69C7FA137405E0

74-delta rollup CSV:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROLLUP__74_LIVE_ROOT_DELTA_BATCH_REVIEW_COVERAGE_NO_EXECUTION_20260609.csv

74-delta rollup CSV SHA256:
5067CCF18DD293E7A003515396D89DF3E3B95C53102915892E516083921F4BE7

V0_1 plan rows CSV:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\POST_DELTA_RECONSIDERATION_58_PLAN_ROWS_20260609_V0_1_20260609_172237.csv

V0_1 plan rows CSV SHA256:
2AECC9AE09023E9F1821A92205B062E7F780D72417020D320DD8FC79557F80A9

V0_1 collision CSV:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\POST_DELTA_RECONSIDERATION_COLLISIONS_20260609_V0_1_20260609_172237.csv

V0_1 collision CSV SHA256:
51AC182F5422EE19C01AE2AE99491214B5C5F2399F593106E9DAF19FF472EE2C

Verified preconditions:
- plan_rows_count: 58
- v0_1_collision_rows_count: 58
- v0_1_blank_destination_count: 58
- v0_1_nonblank_destination_count: 0
- changed_or_missing_plan_count: 0
- delta_rollup_rows: 74
- not_active_authority_count: 74
- do_not_execute_count: 74
- physical_action_authorized_no_count: 74

Contract purpose:
This contract governs a future Selector V0_2 script. Selector V0_2 must repair the V0_1 destination derivation defect by deriving destination candidates from ProposedBucket plus Name. This contract does not authorize routing.

Mandatory source contract:
Selector V0_2 must parse the 58-row route-plan table using these fields:
- QueueType
- Name
- SHA256
- SizeBytes
- SeenInReviewSnapshot
- IsCurrentRunner
- CustodyClass
- SourceDecision
- ProposedBucket
- FutureActionOnly
- ActionNow
- RequiresDryRun
- RequiresUserApproval
- Reason

Mandatory derivation contract:
For route-candidate rows, derive:

DestinationPath = Join-Path RootPath ProposedBucket Name

Mandatory route-candidate conditions:
A row is a route candidate only when all are true:
- ActionNow equals NO
- RequiresDryRun equals YES
- RequiresUserApproval equals YES
- FutureActionOnly equals FUTURE_ROUTE_AFTER_USER_APPROVAL_AND_DRY_RUN_ONLY
- ProposedBucket is not LEAVE_IN_PLACE
- ProposedBucket is not HOLD_IN_ROOT_CURRENT_RUNNER_NO_ROUTE
- ProposedBucket is not HOLD_ZERO_BYTE_REVIEW_NO_DELETE

Mandatory hold-or-leave classification:
Rows with these ProposedBucket values must be classified separately as hold-or-leave rows, not destination collisions:
- HOLD_IN_ROOT_CURRENT_RUNNER_NO_ROUTE
- HOLD_ZERO_BYTE_REVIEW_NO_DELETE
- LEAVE_IN_PLACE

Mandatory destination parent classification:
If a derived destination parent folder does not exist, classify the row as DESTINATION_PARENT_MISSING. Do not classify parent-missing as a file collision.

Mandatory collision classification:
A destination collision can be counted only when:
- the row is a route candidate
- a concrete DestinationPath was derived
- the destination path exists
- the destination path is not the same as the source path

Mandatory delta contract:
Selector V0_2 must consume the 74-delta review rollup. It must not re-block simply because the 74 reviewed-delta files still exist in root. It must treat a delta file as reviewed only if name and SHA256 still match the rollup.

Mandatory new-delta contract:
Selector V0_2 must still block if any live-root file exists outside:
- the 58 route-plan rows
- the 74 reviewed-delta rows
- desktop.ini

Mandatory output contract:
Selector V0_2 may write only:
- markdown report
- 58-plan verification CSV
- 74-reviewed-delta verification CSV
- route-candidates CSV
- hold-or-leave CSV
- new-delta CSV
- destination-collisions CSV
- destination-parent-missing CSV
- hash receipt
- freeze file only on failure

Forbidden behavior:
Selector V0_2 must not move files.
Selector V0_2 must not delete files.
Selector V0_2 must not rename files.
Selector V0_2 must not route files.
Selector V0_2 must not clean root.
Selector V0_2 must not execute helpers.
Selector V0_2 must not call git commit.
Selector V0_2 must not call git push.
Selector V0_2 must not rewrite source authority.
Selector V0_2 must not promote doctrine.

Required static review before any run:
A later Selector V0_2 script must pass static review before execution. Static review must prove:
- AST parse errors equal 0
- forbidden command AST hits equal 0
- forbidden text token hits equal 0
- unexpected write command hits equal 0
- output path bounds exist
- freeze branch exists
- scalar-safe collection handling exists
- route-candidate derivation from ProposedBucket exists
- hold-or-leave classification exists
- destination-parent-missing classification exists
- physical action counters are printed and all zero

Required runtime proof:
A later Selector V0_2 run must print:
- selector script path
- selector script SHA256
- route plan SHA256
- delta rollup SHA256
- plan row count
- reviewed delta row count
- route candidate count
- hold-or-leave count
- new unreviewed delta count
- changed planned count
- changed reviewed delta count
- destination collision count
- destination parent missing count
- final verdict
- artifact writes
- physical action counters, all zero

Required V0_2 verdict values:
- ROUTE_RECONSIDERATION_V0_2_READY_FOR_USER_APPROVAL
- ROUTE_RECONSIDERATION_V0_2_BLOCKED_NEW_DELTA
- ROUTE_RECONSIDERATION_V0_2_BLOCKED_CHANGED_58_PLAN
- ROUTE_RECONSIDERATION_V0_2_BLOCKED_CHANGED_REVIEWED_DELTA
- ROUTE_RECONSIDERATION_V0_2_BLOCKED_DESTINATION_COLLISION
- ROUTE_RECONSIDERATION_V0_2_BLOCKED_DESTINATION_PARENT_MISSING
- ROUTE_RECONSIDERATION_V0_2_FAILED_FREEZE_WRITTEN

Hard boundary:
A READY verdict does not authorize routing. It only means a later route operation may be separately reviewed by the user.

DoesNotProve:
This contract does not build Selector V0_2.
This contract does not run Selector V0_2.
This contract does not approve routing.
This contract does not move, delete, rename, clean up, execute helpers, commit, push, rewrite source, or promote doctrine.

Next single action:
BUILD_POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_V0_2_NO_EXECUTION

Final scoped verdict:
POST_DELTA_SELECTOR_V0_2_CONTRACT_BUILT__SCRIPT_NOT_BUILT_SCRIPT_NOT_EXECUTED__NO_ROUTE_CLEANUP_MOVE_DELETE_RENAME_COMMIT_OR_PUSH_AUTHORIZED
