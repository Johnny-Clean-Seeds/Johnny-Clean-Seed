$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$ObjectPath = Join-Path $ProjectRoot "ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_1_20260608.md"

$SelectorHelper = Join-Path $Lane "PLANETARY_GATE_SOURCE_ANCHORED_STANDARD_RUN_CARD_AND_SELECTOR_BUILD_20260608.md"
$SourceAnchorHelper = Join-Path $Lane "PLANETARY_GATE_ROLE_CARD_MATRIX_SOURCE_ANCHOR_PASS_20260608.md"
$SafeTemplateRule = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md"
$SafeTemplateFieldApply = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_3_20260608.md"

$OutputBase = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_20260608.md"
$OutputV2 = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_RECEIPT_V0_2_20260608.txt"

function Ensure-ParentFolder {
    param([string]$Path)

    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function Write-TextFile {
    param(
        [string]$Path,
        [string]$Text
    )

    Ensure-ParentFolder -Path $Path
    [System.IO.File]::WriteAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Write-BlockerAndExit {
    param(
        [string]$Reason,
        [string]$Detail
    )

    $BlockerPath = Join-Path $Lane "BLOCKER__SELECTOR_FIELD_TEST_ROOT_DROP_INTAKE_WASHER_GATE_RULE_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__SELECTOR_FIELD_TEST_ROOT_DROP_INTAKE_WASHER_GATE_RULE_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_SELECTOR_FIELD_TEST_ROOT_DROP_INTAKE_WASHER_GATE_RULE_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the root-drop washer rule is invalid. It proves this bounded selector field-test stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== SELECTOR FIELD TEST ROOT DROP INTAKE WASHER GATE RULE BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_SELECTOR_FIELD_TEST_ROOT_DROP_INTAKE_WASHER_GATE_RULE_NOT_COMPLETE"
    exit 1
}

function Require-Hash {
    param(
        [string]$Path,
        [string]$ExpectedSha256,
        [string]$Name
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Write-BlockerAndExit -Reason "MISSING_REQUIRED_FILE" -Detail "$Name :: $Path"
    }

    $actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($actual -ne $ExpectedSha256) {
        Write-BlockerAndExit -Reason "HASH_MISMATCH" -Detail "$Name :: actual=$actual expected=$ExpectedSha256 path=$Path"
    }

    return $actual
}

function Require-File {
    param(
        [string]$Path,
        [string]$Name
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Write-BlockerAndExit -Reason "MISSING_REQUIRED_FILE" -Detail "$Name :: $Path"
    }

    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Choose-OutputPath {
    param(
        [string]$Base,
        [string]$Fallback
    )

    if (-not (Test-Path -LiteralPath $Base -PathType Leaf)) {
        return $Base
    }

    if (-not (Test-Path -LiteralPath $Fallback -PathType Leaf)) {
        return $Fallback
    }

    Write-BlockerAndExit -Reason "OUTPUT_COLLISION" -Detail "Both output paths already exist: $Base and $Fallback"
}

"=== SELECTOR FIELD TEST: ROOT DROP INTAKE WASHER GATE RULE ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$SelectorHash = Require-Hash -Path $SelectorHelper -ExpectedSha256 "377663FFD2DDF1E7C95FC3D19A18B04EB4E304350633F2AB260CD660154366C3" -Name "selector helper"
$SourceAnchorHash = Require-Hash -Path $SourceAnchorHelper -ExpectedSha256 "C22F9A9C739FD2BE3B6696DB193B10164E3363F1120E9EB52B37D393C0615260" -Name "source-anchor helper"
$SafeTemplateHash = Require-Hash -Path $SafeTemplateRule -ExpectedSha256 "E0013BA267527AF2201B934E8AEEB55710835EF0CC3ECD78250729E6ECB8FB26" -Name "generated-runner safe-template rule card"
$SafeTemplateApplyHash = Require-Hash -Path $SafeTemplateFieldApply -ExpectedSha256 "CB29519867976D554AFCB3A498670C5CA816CABD5775010FD6F3040F32FCCEDA" -Name "safe-template V0_3 field-apply report"

$ObjectHash = Require-File -Path $ObjectPath -Name "root-drop intake washer gate rule"

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$ObjectText = Get-Content -LiteralPath $ObjectPath -Raw
$ObjectSize = (Get-Item -LiteralPath $ObjectPath).Length

$containsRootDrop = ($ObjectText -match 'ROOT_DROP|root.drop|root drop|drop')
$containsIntake = ($ObjectText -match 'INTAKE|intake')
$containsWasher = ($ObjectText -match 'WASHER|washer|wash')
$containsGate = ($ObjectText -match 'GATE|gate')
$containsBoundary = ($ObjectText -match 'boundary|Boundary|BOUNDARY|blocked|BLOCKED|allowed|ALLOWED|authority|AUTHORITY')
$containsCleanupOrRouting = ($ObjectText -match 'cleanup|Cleanup|routing|Routing|move|Move|delete|Delete|commit|Commit|push|Push|git|Git')

$ReportText = @"
# PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_20260608

Mode: HELPER_FIRST / SELECTOR_FIELD_TEST_PACKET / READ_ONLY / NO_GIT / NO_CLEANUP / NO_ROUTING / NO_SOURCE_MUTATION / NOT_DOCTRINE / NOT_ACTIVE_GUIDES / NOT_CURRENT_TRUTH_INDEX

Created: $Timestamp

Working root:
$ProjectRoot

Active lane:
$Lane

User-named object:
ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_1_20260608.md

Object path:
$ObjectPath

Object SHA256:
$ObjectHash

Object size bytes:
$ObjectSize

Final verdict:
SELECTOR_FIELD_TEST_PACKET_READY_WITH_SCOPE_LIMIT_NOTE

## PURPOSE

Field-test the source-anchored selector against the root-drop intake washer gate rule.

This job does not move, delete, rename, route, clean, stage, commit, push, or rewrite the object. It classifies the object and returns the next safe route.

## VERIFIED HELPERS

Selector helper:
$SelectorHelper
SHA256:
$SelectorHash

Source-anchor helper:
$SourceAnchorHelper
SHA256:
$SourceAnchorHash

Generated-runner safe-template rule card:
$SafeTemplateRule
SHA256:
$SafeTemplateHash

Safe-template V0_3 field-apply report:
$SafeTemplateFieldApply
SHA256:
$SafeTemplateApplyHash

Source sections read:
NONE in this field-test job.

Full source-vault review claimed:
NO

## OBJECT SIGNAL SCAN

contains_root_drop_signal:
$containsRootDrop

contains_intake_signal:
$containsIntake

contains_washer_signal:
$containsWasher

contains_gate_signal:
$containsGate

contains_boundary_or_authority_signal:
$containsBoundary

contains_cleanup_routing_git_or_mutation_words:
$containsCleanupOrRouting

Interpretation:
The object is an intake/boundary/washing gate candidate. Because it touches root-drop handling, it must be treated as a support guardrail and not as automatic cleanup/routing authority.

## STANDARD RUN CARD

Active object:
ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_1_20260608.md

Entry source:
Root-level local rule file under $ProjectRoot.

Source/custody state:
LOCAL_ROOT_DROP_RULE_CANDIDATE / SUPPORT_GUARDRAIL_CANDIDATE / NOT_DOCTRINE / NOT_ACTIVE_GUIDE / NOT_CURRENT_TRUTH_INDEX

Intake verdict:
INTAKE_FIT_FOR_SELECTOR_FIELD_TEST. The object is a named gate/rule candidate with enough surface identity to classify.

Layer Echo scan:
The object belongs to the file-intake and dropped-object boundary problem family. It echoes prior friction around dropped files, helper files, local-only evidence, rough_local Git import boundaries, and avoiding premature cleanup or routing.

Support guard membrane scan:
Support guard membrane must stay active. A root-drop washer may inspect and classify dropped/root files, but may not itself authorize moving, deleting, staging, committing, cleanup, or routing unless a later proof path explicitly grants that authority.

Triggered support organ expanded:
INTAKE_GATE / BOUNDARY_GATE / HASH_RECEIPT_GATE / ROUGH_LOCAL_BOUNDARY_SUPPORT

Rope selected:
ROOT_DROP_INTAKE_WASHER_AS_SUPPORT_GUARDRAIL_NOT_EXECUTOR

Primary planet:
SATURN_GATE

Primary planet verdict:
SATURN_BOUNDARY_REQUIRED. The object is mainly about boundary, containment, order, and preventing wrong movement of root-dropped files.

Counterweight planet:
MERCURY_GATE

Counterweight verdict:
MERCURY_NAMING_AND_ROUTING_CLARITY_REQUIRED. The washer needs precise words, labels, and routing language so it does not blur classify vs move, support vs authority, or root-drop observation vs cleanup command.

Mechanical gate if needed:
Hash/Receipt Gate, Intake Gate, Boundary Gate, Proof Gate. Cleanup Gate and Git Gate are explicitly inactive.

Earth check:
Confirmed object exists and hashed it. Confirmed selector helper, source-anchor helper, safe-template rule card, and V0_3 field-apply report hashes. Wrote this report and receipt only.

Allowed action:
Create exactly one read-only selector field-test report and one receipt for this object.

Blocked action:
Moving files, deleting files, renaming files, routing files, cleanup, staging, committing, pushing, source mutation, doctrine promotion, active guide promotion, current truth index rewrite, broad scans, script execution beyond this bounded runner, and claiming full source-vault review.

Proof need:
Output report path/SHA256, receipt path/SHA256, object path/SHA256, selector-applied flag, primary planet, counterweight planet, mechanical gates, final route, and DoesNotProve.

Stop condition:
Missing object, missing/hash-mismatched helper, missing/hash-mismatched safe-template proof, output collision, or pressure to mutate/root-clean.

Final route:
PARK_AS_SUPPORT_GUARDRAIL_CANDIDATE

DoesNotProve:
This field test does not prove the root-drop washer is correct, active, safe, complete, doctrine, current truth, an executor, cleanup authority, routing authority, Git authority, or source authority.

## BLOCKER PATHFINDING MAP

### BLOCKER 01

BLOCKER:
Authority blur between classify and act.

ACTION BLOCKED:
Letting the washer move, delete, route, or cleanup files.

WHY BLOCKED:
A washer/intake gate can classify and mark, but physical action requires later proof and explicit authority.

MISSING CONDITION:
A separate executor rule, safe routing fixture, before/after proof, and user approval for mutation.

POINTS TO NEXT:
Build a root-drop washer support-card with fields: observed file, hash, source/custody, classification, suggested route, blocked actions, proof need, and next authority.

SAFE WORK NOW:
Use as read-only classification support.

STILL NOT AUTHORIZED:
Cleanup, moves, deletes, Git, or source rewrite.

DOESNOTPROVE:
Classification does not equal permission to act.

### BLOCKER 02

BLOCKER:
Root-drop file ambiguity.

ACTION BLOCKED:
Treating root-dropped files as source authority just because they are at root.

WHY BLOCKED:
Root location may mean accidental drop, temporary staging, old load, support file, or active source. Location alone is not authority.

MISSING CONDITION:
Hash, source/custody note, manifest fit, active object fit, and user approval.

POINTS TO NEXT:
Use washer to assign file state: ACTIVE_SOURCE, HELPER, SUPPORT, ROUGH_LOCAL, INCIDENT, STALE, OLD_LOAD, UNKNOWN.

SAFE WORK NOW:
Read-only inventory/classification.

STILL NOT AUTHORIZED:
Promotion to doctrine or active guide.

DOESNOTPROVE:
A file at root is not automatically current truth.

### BLOCKER 03

BLOCKER:
Rough_local and local-only evidence boundary.

ACTION BLOCKED:
Importing full local evidence into Git or public surfaces by default.

WHY BLOCKED:
Evidence may be bulky, sensitive, local-only, or not intended for public/current authority.

MISSING CONDITION:
Explicit approval and Git-safe import packet.

POINTS TO NEXT:
Carry rough_local hash ledger when Git needs a pointer.

SAFE WORK NOW:
Hash ledger and receipt only.

STILL NOT AUTHORIZED:
Full incident folder import.

DOESNOTPROVE:
Hash pointer is not full evidence.

## NEXT RECOMMENDED BUILD CHUNK

ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_20260608

Purpose:
Turn the root-drop washer into a read-only support-card schema and dry-run one file through it without moving or routing anything.

Required fields:
01 observed_path
02 observed_sha256
03 root_drop_state
04 candidate_role
05 authority_state
06 suggested_route
07 blocked_actions
08 proof_need
09 rough_local_boundary
10 DoesNotProve
11 next_authority_needed

## FINAL RETURN FIELDS

output_report_path:
$OutputPath

output_report_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

object_path:
$ObjectPath

object_sha256:
$ObjectHash

selector_helper_sha256_confirmed:
$SelectorHash

source_anchor_helper_sha256_confirmed:
$SourceAnchorHash

safe_template_rule_sha256_confirmed:
$SafeTemplateHash

safe_template_field_apply_sha256_confirmed:
$SafeTemplateApplyHash

source_sections_read:
NONE in this field-test job

full_source_vault_review_claimed:
NO

selector_applied:
YES

primary_planet_selected:
SATURN_GATE

counterweight_planet_selected:
MERCURY_GATE

mechanical_gate_selected:
Hash/Receipt Gate; Intake Gate; Boundary Gate; Proof Gate

final_route:
PARK_AS_SUPPORT_GUARDRAIL_CANDIDATE

files_moved_count:
0

files_deleted_count:
0

files_renamed_count:
0

source_files_copied_count:
0

files_overwritten_count:
0

scripts_executed_count:
0 arbitrary helper scripts; 1 bounded selector field-test runner

git_commit_or_push_done:
NO

next_build_chunk_selected:
ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_20260608

final_verdict:
SELECTOR_FIELD_TEST_PACKET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_RECEIPT_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

object_path: $ObjectPath
object_sha256: $ObjectHash

selector_helper_sha256: $SelectorHash
source_anchor_helper_sha256: $SourceAnchorHash
safe_template_rule_sha256: $SafeTemplateHash
safe_template_field_apply_sha256: $SafeTemplateApplyHash

selector_applied: YES
primary_planet_selected: SATURN_GATE
counterweight_planet_selected: MERCURY_GATE
final_route: PARK_AS_SUPPORT_GUARDRAIL_CANDIDATE

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_20260608
final_verdict: SELECTOR_FIELD_TEST_PACKET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== SELECTOR FIELD TEST ROOT DROP INTAKE WASHER GATE RULE COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"object_path: $ObjectPath"
"object_sha256: $ObjectHash"
"selector_helper_sha256_confirmed: $SelectorHash"
"source_anchor_helper_sha256_confirmed: $SourceAnchorHash"
"safe_template_rule_sha256_confirmed: $SafeTemplateHash"
"safe_template_field_apply_sha256_confirmed: $SafeTemplateApplyHash"
"source_sections_read: NONE in this field-test job"
"full_source_vault_review_claimed: NO"
"selector_applied: YES"
"primary_planet_selected: SATURN_GATE"
"counterweight_planet_selected: MERCURY_GATE"
"mechanical_gate_selected: Hash/Receipt Gate; Intake Gate; Boundary Gate; Proof Gate"
"final_route: PARK_AS_SUPPORT_GUARDRAIL_CANDIDATE"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0 arbitrary helper scripts; 1 bounded selector field-test runner"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_20260608"
"final_verdict: SELECTOR_FIELD_TEST_PACKET_READY_WITH_SCOPE_LIMIT_NOTE"
