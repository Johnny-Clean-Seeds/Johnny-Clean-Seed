# ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608

Status: SUPPORT_CARD_SCHEMA / READ_ONLY / INTAKE_WASHER / NOT_EXECUTOR / NOT_DOCTRINE / NOT_ACTIVE_GUIDE / NOT_CURRENT_TRUTH_INDEX

Created: 2026-06-08 18:41:53

Working root:
C:\Users\13527\Desktop\123

Lane:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606

Purpose:
Define the read-only support-card shape for root-drop intake washer work.

This schema classifies root-dropped files and suggests a route, but it does not move, delete, rename, stage, commit, push, clean, or promote anything.

## SOURCE PROOF

Root-drop washer rule:
C:\Users\13527\Desktop\123\ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_1_20260608.md
SHA256:
ADDC4E8A2DA3226660663DAF61801AC505ED5F417B624F3E2CF58024A59FD4A9

Selector field-test report:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_20260608.md
SHA256:
E04A18A9156CA14F72F06E0DA52D6D3D398403DCFF631632A1A4A4B1155618A9

Selector field-test receipt:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_RECEIPT_20260608.txt
SHA256:
2EB4F22BFD7DCDA3D09E46037BE2B8AEEF66B76B7C95744BD470427C504A8698

Generated-runner safe-template rule:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md
SHA256:
E0013BA267527AF2201B934E8AEEB55710835EF0CC3ECD78250729E6ECB8FB26

Safe-template V0_3 field-apply:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_3_20260608.md
SHA256:
CB29519867976D554AFCB3A498670C5CA816CABD5775010FD6F3040F32FCCEDA

## REQUIRED SUPPORT CARD FIELDS

01 observed_path
The exact path of the file being inspected.

02 observed_sha256
The SHA256 of the file being inspected.

03 observed_size_bytes
Size in bytes.

04 root_drop_state
Allowed values:
- ROOT_PRESENT
- NOT_AT_ROOT
- MISSING
- UNKNOWN

05 candidate_role
Allowed values:
- ACTIVE_SOURCE_CANDIDATE
- HELPER_CANDIDATE
- SUPPORT_GUARDRAIL_CANDIDATE
- ROUGH_LOCAL_LEDGER
- INCIDENT_EVIDENCE
- RECEIPT
- OLD_LOAD_OR_STALE
- UNKNOWN

06 authority_state
Allowed values:
- SOURCE_AUTHORITY
- SUPPORT_ONLY
- HASH_POINTER_ONLY
- LOCAL_EVIDENCE_ONLY
- CANDIDATE_ONLY
- UNKNOWN

07 suggested_route
Allowed values:
- PARK_AS_SUPPORT_GUARDRAIL
- KEEP_AT_ROOT_PENDING_REVIEW
- ROUGH_LOCAL_HASH_LEDGER_ONLY
- INCIDENT_FOLDER_ONLY
- CANDIDATE_FOR_LATER_PROMOTION
- OLD_LOAD_REVIEW
- UNKNOWN

08 blocked_actions
Must list actions this card does not authorize.

09 proof_need
Must list what proof is needed before any stronger action.

10 rough_local_boundary
Must say whether Git-safe hash pointer is enough or full content approval is needed.

11 next_authority_needed
Must identify what authority/gate would be needed next.

12 DoesNotProve
Must name what the card does not prove.

## STANDING BOUNDARY

This schema is read-only.

It may classify, hash, and suggest.

It may not:
- move
- delete
- rename
- route
- cleanup
- stage
- commit
- push
- rewrite source
- promote to doctrine
- promote to active guide
- rewrite current truth index
- claim full source-vault review

## DEFAULT PLANET ROUTE

Primary planet:
SATURN_GATE

Reason:
Root-drop intake needs boundary, containment, custody, and blocked-action clarity.

Counterweight planet:
MERCURY_GATE

Reason:
Washer support cards need naming and route-language precision so classify does not become act.

Mechanical gates:
Hash/Receipt Gate; Intake Gate; Boundary Gate; Proof Gate

## DOESNOTPROVE

This schema does not prove any file is safe, current, source authority, stale, cleanable, movable, deletable, routable, Git-safe, doctrine, active guide, current truth, or project complete.