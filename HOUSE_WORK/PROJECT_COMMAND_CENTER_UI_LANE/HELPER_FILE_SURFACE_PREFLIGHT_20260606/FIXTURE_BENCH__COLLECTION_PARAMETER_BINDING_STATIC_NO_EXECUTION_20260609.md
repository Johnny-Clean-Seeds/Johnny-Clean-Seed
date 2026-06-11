# FIXTURE BENCH: COLLECTION / PARAMETER-BINDING STATIC GATE

Status:
COLLECTION_PARAMETER_BINDING_STATIC_FIXTURE_BENCH_WRITTEN_NO_EXECUTION / NO_EXECUTION / NO_SCRIPT_REPAIR / NO_PHYSICAL_ACTION

Source repair contract:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\CONTRACT__GENERATED_POWERSHELL_COLLECTION_PARAMETER_BINDING_REPAIR_NO_EXECUTION_20260609.md

Source repair contract SHA256:
C7BFD89A012441CBDF5D9E0E501649A19E862F1AA46C04FC11AF35C6CC9164C8

Source defect index:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\INDEX__GENERATED_POWERSHELL_COLLECTION_PARAMETER_BINDING_DEFECT_NO_EXECUTION_20260609.csv

Source defect index SHA256:
0DA2358D1217B81FFBDAB39123DC359B3FAE46E6210D5FDD5826F3D59E34EDF3

Purpose:
Create a static fixture bench for generated PowerShell helpers before any helper in this defect family is repaired, trusted, or promoted.

Fixture count:
10

Fixtures:

FixtureId DefectFamily                      ExpectedStaticVerdict
--------- ------------                      ---------------------
CPB-001   ZERO_ROW_COLLECTION               BLOCK_BAD_PATTERN
CPB-002   ONE_ROW_SCALAR_COLLECTION         REQUIRE_ARRAY_NORMALIZATION
CPB-003   MANY_ROW_COLLECTION               REQUIRE_SAFE_GROUP_SOURCE
CPB-004   EMPTY_STRING_LINE_BINDING         REQUIRE_BLANK_SAFE_WRITER
CPB-005   NULL_LINE_LIST_FACTORY            REQUIRE_STRING_CAST_AND_NULL_CONTROL
CPB-006   CSV_STABLE_FIELD_CONTRACT         REQUIRE_STABLE_ROW_SCHEMA
CPB-007   COUNT_PROPERTY_FAILURE            REQUIRE_ARRAY_COUNT
CPB-008   LIST_ARRAY_ARGUMENT_TYPE_MISMATCH REQUIRE_EXPLICIT_ARRAY_PARAMETER
CPB-009   VERDICT_DOMINANCE                 REQUIRE_BLOCKER_DOMINANCE
CPB-010   GENERATED_ROLLUP_TRUST_GATE       REQUIRE_ROLLUP_AUTHORITY_PROOF



Bench rule:
A future generated helper must be checked against this fixture bench before acceptance. The bench is static first. It is not a live execution harness yet.

Acceptance requirements for future helper:
- Must use array normalization for zero/one/many row collections.
- Must handle blank Markdown lines safely.
- Must not pass null line lists into unsafe writer functions.
- Must use stable CSV/report object schemas.
- Must make blocker counts dominate final verdict.
- Must not treat generated rollups as active authority without proof gates.
- Must include DoesNotProve boundary.
- Must write receipt hashes.
- Must not route, cleanup, delete, rename, commit, or push unless a later explicit gate authorizes it.

DoesNotProve:
This fixture bench does not repair any script.
This fixture bench does not execute any helper.
This fixture bench does not authorize route, cleanup, delete, rename, move, commit, push, source rewrite, doctrine promotion, or helper execution.
This fixture bench only defines static proof requirements.

Next single action:
BUILD_STATIC_GATE_FOR_GENERATED_HELPER_REPAIR_NO_EXECUTION

Final verdict:
COLLECTION_PARAMETER_BINDING_STATIC_FIXTURE_BENCH_WRITTEN_NO_EXECUTION
