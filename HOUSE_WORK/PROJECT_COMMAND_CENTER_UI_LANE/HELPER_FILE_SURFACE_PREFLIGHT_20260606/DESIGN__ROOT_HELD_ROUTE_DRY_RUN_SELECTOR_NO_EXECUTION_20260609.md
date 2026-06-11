# ROOT-HELD ROUTE DRY-RUN SELECTOR DESIGN

Status:
DESIGN_CARD / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_SCRIPT_BUILT

Scope card used:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\SCOPE__ROOT_HELD_ROUTE_DRY_RUN_EXPANSION_NO_EXECUTION_20260609.md

Scope card SHA256:
583F1A74AE5975E5F06C2CBBB70BB4297A4C83CA556ABD327C8AE2CE97FFCAE7

Decision card used:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\DECISION__ROOT_HELD_ROUTE_PLAN_PAUSE_REVIEW_NO_EXECUTION_20260609.md

Decision card SHA256:
ED22B19E77279936BF2191658E11077B343B7898466A9D8B14EE9646ED878951

Root route plan used:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md

Root route plan SHA256:
FBDA72FCC368B608EE2802B7FDC9941A451446E7E7A8AD1D9D69C7FA137405E0

Purpose:
Define the design for a future dry-run selector before any selector script is built.

This card does not build a selector.
This card does not execute a selector.
This card does not move, delete, rename, route, clean up, commit, push, or promote doctrine.

Design goal:
A future selector must compare the plan-only route surface against the current live root and produce a dry-run report only. It must prove exact source truth, exact destination intent, collision state, live-root delta state, and stop conditions before any physical route can even be discussed.

Input surfaces:
1. ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md
2. SCOPE__ROOT_HELD_ROUTE_DRY_RUN_EXPANSION_NO_EXECUTION_20260609.md
3. Current live root:
   C:\Users\13527\Desktop\123

Required parser behavior:
The future selector must parse the route-plan table as data.
It must not infer rows from prose.
It must preserve Name, SHA256, SizeBytes, ProposedBucket, FutureActionOnly, ActionNow, RequiresDryRun, RequiresUserApproval, and Reason.
It must treat ActionNow other than NO as a stop condition.
It must treat blank SHA256, malformed SHA256, or changed SHA256 as a stop condition.

Required live-root scan:
The future selector must scan only the approved root boundary:
C:\Users\13527\Desktop\123

It must not recurse into unrelated project subtrees unless explicitly required for collision proof.
It must identify top-level live-root files by name, size, and SHA256.
It must detect:
- matched planned files
- planned files missing from live root
- planned files with changed SHA256
- planned files with changed size
- live-root files not present in the route plan
- current runner hold rows
- leave-in-place rows
- zero-byte review rows

Destination design:
The future selector must translate ProposedBucket into exact destination paths, but only as dry-run output.

Bucket-to-path mapping must be explicit.
No bucket may be treated as valid unless it maps to an exact folder under the approved local custody surface.

Destination proof must include:
- exact destination folder
- exact destination file path
- whether destination folder exists
- whether destination file already exists
- whether destination collision exists
- whether proposed destination would overwrite anything

Collision policy:
Any destination collision is a stop condition.
The selector must not auto-version, overwrite, rename, or repair collisions.
Collision repair requires a later user-approved design card.

Recursive dry-run expansion:
If any proposed destination bucket is folder-like, old-load-like, rough-local-like, or custody-like, the selector must show enough path detail to prove the exact file-level destination.
Folder-level movement is not allowed.
Bulk movement is not allowed.
Every route row must remain file-level.

Unreviewed delta policy:
Any current live-root file not in the route plan must be marked:
ROOT_DELTA_UNREVIEWED_HOLD

Unreviewed root delta files block route recommendation.
They do not authorize cleanup.
They do not authorize deletion.
They do not authorize movement.

Helper execution boundary:
The selector may hash script files.
The selector may list script file names.
The selector may classify script file custody status.
The selector may not run script files.
The selector may not dot-source script files.
The selector may not import helper logic.
The selector may not invoke generated runners.

PowerShell construction rule for future selector:
Because the generated rollup family failed from scalar/list/empty collection behavior, the future selector must use explicit collection-safe construction.

Required implementation constraints for any later script:
- initialize arrays explicitly
- never pass null into mandatory collection parameters
- avoid implicit scalar/list conversion
- avoid .ToArray() on possibly scalar objects
- avoid relying on .Count where an object may be scalar
- use explicit row objects
- separate SourceActionNow from SelectorActionNow
- freeze evidence on failure before downstream patching

Output files required from future selector:
1. dry-run report markdown
2. dry-run CSV row table
3. live-root delta CSV
4. collision CSV
5. hash receipt
6. DoesNotProve section

Required output counts:
- route_plan_row_count
- live_root_file_count
- matched_source_count
- missing_source_count
- changed_hash_count
- changed_size_count
- live_root_delta_unreviewed_count
- proposed_route_count
- hold_count
- destination_collision_count
- action_now_count, expected 0
- execution_authority_count, expected 0
- delete_now_count, expected 0
- move_now_count, expected 0

Stop conditions:
The future selector must stop with NO_ROUTE_RECOMMENDATION if:
- any source file is missing
- any source hash changed
- any source size changed without explanation
- any live-root delta file is unreviewed
- any destination collision exists
- any exact source path is missing
- any exact destination path is missing
- any row requests action now
- any row requests delete now
- any row requests move now
- any row requests execution now
- any authority field is unclear

Passing dry-run still does not prove:
A passing dry-run does not authorize route execution.
A passing dry-run does not authorize cleanup.
A passing dry-run does not authorize deletion.
A passing dry-run does not authorize rename.
A passing dry-run does not authorize commit or push.
A passing dry-run only permits a later user approval decision card.

Allowed next work:
Build a no-execution selector build contract card.

Not allowed:
No selector script yet.
No route execution.
No cleanup.
No move.
No delete.
No rename.
No helper execution.
No commit.
No push.
No doctrine promotion.

Next single action:
BUILD_SELECTOR_BUILD_CONTRACT_CARD_NO_EXECUTION

Final scoped verdict:
ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_DESIGN_DEFINED__SELECTOR_NOT_BUILT__LIVE_ROOT_DELTA_EXACT_SOURCE_EXACT_DESTINATION_COLLISION_AND_COLLECTION_SAFE_CONTRACT_REQUIRED__NO_EXECUTION_ROUTE_CLEANUP_MOVE_DELETE_RENAME_COMMIT_OR_PUSH_AUTHORIZED
