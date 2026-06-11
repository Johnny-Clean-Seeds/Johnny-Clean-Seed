# STATIC SCAN: V0.2 GENERATED HELPER COLLECTION / PARAMETER-BINDING

Status:
STATIC_GATE_SCAN_BLOCKED_REPAIR_REQUIRED_NO_EXECUTION / NO_EXECUTION / NO_SCRIPT_REPAIR / NO_PHYSICAL_ACTION

Candidate:
BUILD_ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_NO_EXECUTION_20260609_V0_2.ps1

Candidate path:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\BUILD_ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_NO_EXECUTION_20260609_V0_2.ps1

Candidate SHA256:
BBB99DCA95BF612B6492A2B2E091A8869DD5CBAF982F4316E5F3470C4D055E20

Candidate parser error count:
0

Candidate parser errors:
none

Source static gate CSV:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\STATIC_GATE__GENERATED_HELPER_REPAIR_COLLECTION_PARAMETER_BINDING_NO_EXECUTION_20260609.csv

Source static gate CSV SHA256:
564ECC2560DA57D85D6777288BDD1009510EFCB5FF291D9E32D0E7C9691AA8EB

Source selector CSV:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\SELECTOR__GENERATED_HELPER_CANDIDATES_FOR_STATIC_GATE_NO_EXECUTION_20260609.csv

Source selector CSV SHA256:
0EA56AA647141BE95106B476336EA62BC80ABD838E27062044C2D67BCDCF6C19

Prior corrected V0.1 scan report:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\STATIC_SCAN__ONE_GENERATED_HELPER_COLLECTION_PARAMETER_BINDING_NO_EXECUTION_V0_2_20260609.md

Prior corrected V0.1 scan report SHA256:
427DACD7458E01EE249877C6FFEC646AD22681EFA90FDE3B343BB00900851616

Counts:
- total_gate_count: 10
- pass_or_not_applicable_count: 5
- review_required_count: 1
- blocked_repair_required_count: 4

Gate scan rows:

GateId     StaticVerdict                       Evidence
------     -------------                       --------
CPB-SG-001 STATIC_GATE_BLOCKED_REPAIR_REQUIRED Array wrapping exists, but clear @(...).Count evidence is missing.
CPB-SG-002 STATIC_GATE_PASS                    Found foreach over explicit array-wrapped source.
CPB-SG-003 STATIC_GATE_PASS_NOT_APPLICABLE     No Group-Object usage found.
CPB-SG-004 STATIC_GATE_BLOCKED_REPAIR_REQUIRED No clear blank-safe writer evidence.
CPB-SG-005 STATIC_GATE_REVIEW_REQUIRED         No direct null append found, but no clear string-cast line-list
                                               control either.
CPB-SG-006 STATIC_GATE_PASS                    Found pscustomobject rows and Export-Csv.
CPB-SG-007 STATIC_GATE_BLOCKED_REPAIR_REQUIRED No clear @(...).Count pattern found.
CPB-SG-008 STATIC_GATE_PASS                    Found explicit array parameter and array-wrapped source evidence.
CPB-SG-009 STATIC_GATE_BLOCKED_REPAIR_REQUIRED No clear blocker/issue-count verdict dominance evidence.
CPB-SG-010 STATIC_GATE_PASS                    Found hash/receipt, diff-or-duplicate evidence, and gate/boundary
                                               language.



Control meaning:
This is a static text scan only.
The candidate was not executed.
If blocked_repair_required_count is greater than zero, the candidate remains blocked.

DoesNotProve:
This scan does not execute the candidate helper.
This scan does not repair the candidate helper.
This scan does not authorize route, cleanup, delete, rename, move, commit, push, source rewrite, doctrine promotion, or helper execution.
This scan does not prove runtime safety.

Next single action:
DECIDE_REPAIR_THIS_CANDIDATE_OR_SCAN_NEXT_GENERATED_HELPER_NO_EXECUTION

Final verdict:
STATIC_GATE_SCAN_BLOCKED_REPAIR_REQUIRED_NO_EXECUTION
