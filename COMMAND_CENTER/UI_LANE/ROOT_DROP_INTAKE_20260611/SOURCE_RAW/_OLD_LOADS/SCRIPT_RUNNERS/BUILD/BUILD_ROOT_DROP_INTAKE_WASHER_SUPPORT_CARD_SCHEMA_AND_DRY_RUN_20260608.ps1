$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$WasherRule = Join-Path $ProjectRoot "ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_1_20260608.md"
$SelectorReport = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_20260608.md"
$SelectorReceipt = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_RECEIPT_20260608.txt"
$SafeTemplateRule = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md"
$SafeTemplateApply = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_3_20260608.md"

$SchemaBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"
$SchemaV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_V0_2_20260608.md"
$DryRunBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_DRY_RUN__ROOT_DROP_RULE_20260608.md"
$DryRunV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_DRY_RUN__ROOT_DROP_RULE_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_RECEIPT_V0_2_20260608.txt"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the root-drop washer idea failed. It proves this bounded schema/dry-run runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER SUPPORT CARD SCHEMA/DRY-RUN BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_NOT_COMPLETE"
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

"=== ROOT DROP INTAKE WASHER SUPPORT CARD SCHEMA AND DRY-RUN ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$WasherRuleHash = Require-Hash -Path $WasherRule -ExpectedSha256 "ADDC4E8A2DA3226660663DAF61801AC505ED5F417B624F3E2CF58024A59FD4A9" -Name "root-drop intake washer rule"
$SelectorReportHash = Require-Hash -Path $SelectorReport -ExpectedSha256 "E04A18A9156CA14F72F06E0DA52D6D3D398403DCFF631632A1A4A4B1155618A9" -Name "root-drop selector field-test report"
$SelectorReceiptHash = Require-Hash -Path $SelectorReceipt -ExpectedSha256 "2EB4F22BFD7DCDA3D09E46037BE2B8AEEF66B76B7C95744BD470427C504A8698" -Name "root-drop selector field-test receipt"
$SafeTemplateHash = Require-Hash -Path $SafeTemplateRule -ExpectedSha256 "E0013BA267527AF2201B934E8AEEB55710835EF0CC3ECD78250729E6ECB8FB26" -Name "generated-runner safe-template rule card"
$SafeTemplateApplyHash = Require-Hash -Path $SafeTemplateApply -ExpectedSha256 "CB29519867976D554AFCB3A498670C5CA816CABD5775010FD6F3040F32FCCEDA" -Name "safe-template V0_3 field-apply report"

$SchemaPath = Choose-OutputPath -Base $SchemaBase -Fallback $SchemaV2
$DryRunPath = Choose-OutputPath -Base $DryRunBase -Fallback $DryRunV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$ObservedPath = $WasherRule
$ObservedHash = $WasherRuleHash
$ObservedSize = (Get-Item -LiteralPath $ObservedPath).Length

$SchemaText = @"
# ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608

Status: SUPPORT_CARD_SCHEMA / READ_ONLY / INTAKE_WASHER / NOT_EXECUTOR / NOT_DOCTRINE / NOT_ACTIVE_GUIDE / NOT_CURRENT_TRUTH_INDEX

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Purpose:
Define the read-only support-card shape for root-drop intake washer work.

This schema classifies root-dropped files and suggests a route, but it does not move, delete, rename, stage, commit, push, clean, or promote anything.

## SOURCE PROOF

Root-drop washer rule:
$WasherRule
SHA256:
$WasherRuleHash

Selector field-test report:
$SelectorReport
SHA256:
$SelectorReportHash

Selector field-test receipt:
$SelectorReceipt
SHA256:
$SelectorReceiptHash

Generated-runner safe-template rule:
$SafeTemplateRule
SHA256:
$SafeTemplateHash

Safe-template V0_3 field-apply:
$SafeTemplateApply
SHA256:
$SafeTemplateApplyHash

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
"@

Write-TextFile -Path $SchemaPath -Text $SchemaText
$SchemaHash = (Get-FileHash -LiteralPath $SchemaPath -Algorithm SHA256).Hash

$DryRunText = @"
# ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_DRY_RUN__ROOT_DROP_RULE_20260608

Status: SUPPORT_CARD_DRY_RUN / READ_ONLY / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Schema used:
$SchemaPath
SHA256:
$SchemaHash

Observed path:
$ObservedPath

Observed SHA256:
$ObservedHash

Observed size bytes:
$ObservedSize

root_drop_state:
ROOT_PRESENT

candidate_role:
SUPPORT_GUARDRAIL_CANDIDATE

authority_state:
CANDIDATE_ONLY

suggested_route:
PARK_AS_SUPPORT_GUARDRAIL

blocked_actions:
- move
- delete
- rename
- route
- cleanup
- stage
- commit
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

proof_need:
- user approval before any physical route/move
- proof fixture before executor behavior
- before/after receipt for any future mutation
- hash receipt before and after any future file action
- separate authority card if the washer becomes an executor
- rough_local ledger if Git receives only a pointer

rough_local_boundary:
Git-safe pointer only by default. Full file/evidence import requires explicit later approval.

next_authority_needed:
ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_FIELD_TEST_ON_MORE_THAN_ONE_FILE_20260608

classification_summary:
The root-drop washer rule is not an executor. It is a support guardrail candidate. It may help classify dropped files but cannot itself authorize cleanup or routing.

DoesNotProve:
This dry-run does not prove the washer rule is active, complete, doctrine, current truth, source authority, executor authority, cleanup authority, routing authority, Git authority, or project complete.
"@

Write-TextFile -Path $DryRunPath -Text $DryRunText
$DryRunHash = (Get-FileHash -LiteralPath $DryRunPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_RECEIPT_20260608
Created: $Timestamp

schema_path: $SchemaPath
schema_sha256: $SchemaHash

dry_run_card_path: $DryRunPath
dry_run_card_sha256: $DryRunHash

observed_path: $ObservedPath
observed_sha256: $ObservedHash

washer_rule_sha256: $WasherRuleHash
selector_report_sha256: $SelectorReportHash
selector_receipt_sha256: $SelectorReceiptHash
safe_template_rule_sha256: $SafeTemplateHash
safe_template_field_apply_sha256: $SafeTemplateApplyHash

primary_planet_selected: SATURN_GATE
counterweight_planet_selected: MERCURY_GATE
final_route: PARK_AS_SUPPORT_GUARDRAIL

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER SUPPORT CARD SCHEMA AND DRY-RUN COMPLETE ==="
"schema_path: $SchemaPath"
"schema_sha256: $SchemaHash"
"dry_run_card_path: $DryRunPath"
"dry_run_card_sha256: $DryRunHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"observed_path: $ObservedPath"
"observed_sha256: $ObservedHash"
"washer_rule_sha256_confirmed: $WasherRuleHash"
"selector_report_sha256_confirmed: $SelectorReportHash"
"selector_receipt_sha256_confirmed: $SelectorReceiptHash"
"safe_template_rule_sha256_confirmed: $SafeTemplateHash"
"safe_template_field_apply_sha256_confirmed: $SafeTemplateApplyHash"
"primary_planet_selected: SATURN_GATE"
"counterweight_planet_selected: MERCURY_GATE"
"final_route: PARK_AS_SUPPORT_GUARDRAIL"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE"
