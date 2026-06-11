# ROOT-HELD ROUTE DRY-RUN SELECTOR BUILD CONTRACT

Status:
BUILD_CONTRACT_CARD / NO_SCRIPT_BUILT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP

Design card used:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\DESIGN__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_NO_EXECUTION_20260609.md

Design card SHA256:
FED6FB14053332D7BC2F8A5C6256DE0CC9E691ABF22CA24CB03B78DF6AD7688E

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
Define the contract for a later dry-run selector script before any script is written.

This card does not build a script.
This card does not run a script.
This card does not move, delete, rename, route, clean up, commit, push, or promote doctrine.

Future script name:
BUILD_ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_NO_EXECUTION_20260609_V0_1.ps1

Future script purpose:
Produce dry-run evidence only. The script may read approved inputs, scan the approved live root boundary, calculate hashes, compare rows, and write dry-run report outputs.

Future script may write only:
- dry-run report markdown
- dry-run row CSV
- live-root delta CSV
- destination collision CSV
- hash receipt
- freeze evidence if the script fails

Future script must not:
- move files
- delete files
- rename files
- route files
- clean folders
- execute helper scripts
- dot-source scripts
- import script logic
- call generated runners
- commit
- push
- rewrite source authority
- promote doctrine

Approved input files:
1. ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md
2. SCOPE__ROOT_HELD_ROUTE_DRY_RUN_EXPANSION_NO_EXECUTION_20260609.md
3. DESIGN__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_NO_EXECUTION_20260609.md

Approved live root boundary:
C:\Users\13527\Desktop\123

Required route-plan parser contract:
- parse only the markdown route-plan table
- preserve each row as a row object
- preserve QueueType
- preserve Name
- preserve SHA256
- preserve SizeBytes
- preserve ProposedBucket
- preserve FutureActionOnly
- preserve ActionNow
- preserve RequiresDryRun
- preserve RequiresUserApproval
- preserve Reason
- reject malformed SHA256
- reject blank source names
- reject ActionNow other than NO

Required collection-safe PowerShell contract:
- initialize arrays explicitly with System.Collections.Generic.List[object]
- add rows with .Add()
- never rely on implicit scalar/list conversion
- never call .ToArray() on an unknown object
- never call .Count on an object that may be scalar
- never pass null or empty collection into a mandatory parameter
- use explicit if checks before loops
- write freeze evidence on failure
- stop before downstream patching when contract checks fail

Required source matching contract:
For each route-plan row, match live-root top-level file by Name.
Then verify:
- source file exists
- source SHA256 matches route-plan SHA256
- source SizeBytes matches route-plan SizeBytes
- current runner row remains held
- leave-in-place row remains leave-in-place
- zero-byte review row remains held, not deleted

Required live-root delta contract:
Scan top-level live-root files.
Any top-level live-root file not represented in the route plan must be marked:
ROOT_DELTA_UNREVIEWED_HOLD

Any ROOT_DELTA_UNREVIEWED_HOLD count above 0 blocks route recommendation.

Required destination mapping contract:
The future script must map ProposedBucket to exact destination folders as dry-run text only.

Every proposed route row must include:
- exact source path
- exact destination folder
- exact destination file path
- destination folder exists true or false
- destination file exists true or false
- collision true or false
- route recommendation

Collision policy:
If destination file exists, mark collision true.
Any collision blocks route recommendation.
The script may not auto-version, overwrite, rename, or repair collisions.

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
- action_now_count
- execution_authority_count
- delete_now_count
- move_now_count
- stop_condition_count

Expected safe counts:
- action_now_count: 0
- execution_authority_count: 0
- delete_now_count: 0
- move_now_count: 0

Required final verdict rules:
If any stop condition exists:
NO_ROUTE_RECOMMENDATION

If no stop condition exists:
DRY_RUN_PASS_PENDING_USER_APPROVAL

Even DRY_RUN_PASS_PENDING_USER_APPROVAL does not authorize physical action.

Required DoesNotProve section:
The future script must state that the dry-run does not authorize route execution, cleanup, deletion, rename, helper execution, commit, push, source rewrite, or doctrine promotion.

Allowed next work:
Build the future selector script only after this contract is accepted.

Not allowed:
No script build by this card.
No script execution.
No route execution.
No cleanup.
No move.
No delete.
No rename.
No commit.
No push.
No doctrine promotion.

Next single action:
BUILD_ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_SCRIPT_NO_EXECUTION_V0_1

Final scoped verdict:
ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_BUILD_CONTRACT_DEFINED__SCRIPT_NOT_BUILT__COLLECTION_SAFE_READ_ONLY_DRY_RUN_OUTPUTS_ONLY__NO_EXECUTION_ROUTE_CLEANUP_MOVE_DELETE_RENAME_COMMIT_OR_PUSH_AUTHORIZED
