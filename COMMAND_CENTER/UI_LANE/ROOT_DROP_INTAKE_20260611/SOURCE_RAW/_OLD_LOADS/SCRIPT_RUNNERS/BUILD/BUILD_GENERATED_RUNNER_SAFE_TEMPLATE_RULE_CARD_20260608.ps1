$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$FieldTestReport = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_GENERATED_RUNNER_DEFECT_FAMILY_20260608.md"
$DeepIncidentFolder = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__GENERATED_RUNNER_LINE_WRITER_DEEP_LAYER__20260608"
$DeepLayerReport = Join-Path $DeepIncidentFolder "DEEP_LAYER_ROOT_CAUSE__GENERATED_RUNNER_LINE_WRITER_AND_FALSE_COMPLETE_20260608.md"
$FixNote = Join-Path $DeepIncidentFolder "FIX_NOTE__SAFE_TEXT_WRITER_AND_STOP_ON_BLOCKER_PATTERN_20260608.md"
$DeepReceipt = Join-Path $DeepIncidentFolder "HASH_RECEIPT__GENERATED_RUNNER_DEEP_LAYER_FREEZE_20260608.txt"
$CorrectedGitRunner = Join-Path $Lane "RUN_BOUNDED_GIT_SNAPSHOT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_V0_3_STOP_ON_BLOCKER_SAFE_WRITER_20260608.ps1"

$RuleCardBase = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md"
$RuleCardV2 = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_RECEIPT_V0_2_20260608.txt"

function Write-TextFile {
    param(
        [string]$Path,
        [string]$Text
    )

    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    [System.IO.File]::WriteAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Require-Hash {
    param(
        [string]$Path,
        [string]$ExpectedSha256,
        [string]$Name
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "MISSING_REQUIRED_FILE: $Name :: $Path"
    }

    $actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($actual -ne $ExpectedSha256) {
        throw "HASH_MISMATCH: $Name :: actual=$actual expected=$ExpectedSha256 path=$Path"
    }

    return $actual
}

function Choose-OutputPath {
    param(
        [string]$Base,
        [string]$V2
    )

    if (-not (Test-Path -LiteralPath $Base -PathType Leaf)) {
        return $Base
    }

    if (-not (Test-Path -LiteralPath $V2 -PathType Leaf)) {
        return $V2
    }

    throw "BLOCKER_OUTPUT_COLLISION: both base and V0_2 exist for $Base"
}

"=== GENERATED RUNNER SAFE TEMPLATE RULE CARD BUILD ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    throw "MISSING_LANE: $Lane"
}

$FieldTestHash = Require-Hash -Path $FieldTestReport -ExpectedSha256 "4BCB354B10B28066AB4A78BF9861F6EDB9795A323362678BB97B175427AD99A0" -Name "generated-runner selector field test report"
$DeepLayerHash = Require-Hash -Path $DeepLayerReport -ExpectedSha256 "5584FEED2B9FB713463B2C63F02D0BC866AB5B20D332D236BE1B304BDA65E16A" -Name "deep-layer root-cause report"
$FixNoteHash = Require-Hash -Path $FixNote -ExpectedSha256 "B7CA2AE7D5F33594DE772EAF0485D8A01612547A6E662892FAAC97B8F8D021EC" -Name "fix note"
$DeepReceiptHash = Require-Hash -Path $DeepReceipt -ExpectedSha256 "098424D043022C8B0C0D2DE5A47CABCBE7D58B03EF39BCA65A256595B91388D9" -Name "deep freeze receipt"
$CorrectedRunnerHash = Require-Hash -Path $CorrectedGitRunner -ExpectedSha256 "F00FE67E139E3A0F5CC87DEE0EEAD2464D601E151DEA73B37B9FBB86CEB8197E" -Name "corrected safe Git runner"

$RuleCardPath = Choose-OutputPath -Base $RuleCardBase -V2 $RuleCardV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -V2 $ReceiptV2

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$RuleText = @"
# GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608

Status: ACTIVE_LOCAL_RULE_CARD / GENERATED_RUNNER_TEMPLATE_GUARD / STOP_ON_BLOCKER_RULE / FREEZE_EVIDENCE_COMPANION / NOT_DOCTRINE / NOT_GIT_AUTHORITY

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Purpose:
Install a standing local rule card for generated PowerShell runners so the same defect family does not repeat.

This rule card exists because the selector field test identified the real issue as:

GENERATED_RUNNER_LINE_WRITER_DEFECT plus FALSE_COMPLETE_AFTER_BLOCKER.

Source proof surfaces used:

01 selector field-test report:
$FieldTestReport
SHA256:
$FieldTestHash

02 deep-layer root-cause report:
$DeepLayerReport
SHA256:
$DeepLayerHash

03 fix note:
$FixNote
SHA256:
$FixNoteHash

04 deep-layer freeze receipt:
$DeepReceipt
SHA256:
$DeepReceiptHash

05 corrected safe Git runner example:
$CorrectedGitRunner
SHA256:
$CorrectedRunnerHash

## CORE RULE

Generated runners must not use brittle line-writing helper functions that reject empty collections or empty strings.

Required writer shape:

[System.IO.File]::WriteAllText(path, text, [System.Text.UTF8Encoding]::new($false))

Allowed:
- write one complete string
- write a here-string
- write an explicitly joined string
- create parent folders before writing
- write UTF-8 without BOM unless a task explicitly needs another encoding

Blocked by default:
- Mandatory Lines array writer for generated text
- Add-Line wrappers that reject empty collections
- Write-Utf8File wrappers that reject empty strings
- report generation that depends on non-empty array binding
- final success lines printed after a blocker
- commit success claims without a real commit hash

## STOP_ON_BLOCKER RULE

If a blocker occurs, the runner must stop.

Required blocker behavior:

01 Write a blocker/evidence report if the job has write permission.
02 Print the blocker path and SHA256 if a blocker report was written.
03 Print a blocker final verdict.
04 Exit nonzero.
05 Do not continue to later stage/add/commit/hash/final-success steps.
06 Do not print a success verdict after a blocker.

Blocked pattern:
A script or pasted command chain detects a blocker, then later commands keep running with null/empty variables and print success.

## SUCCESS_REQUIRES_PROOF RULE

A final success verdict is legal only if the material proof exists.

For Git commit success, all must be true:

01 Git worktree exists.
02 Existing staged set is empty before bounded staging.
03 Target files exist.
04 Target file hashes match expected.
05 Exact staged set equals expected staged set.
06 git commit exits 0.
07 git rev-parse HEAD returns a non-empty commit hash.
08 Final status is captured after commit.
09 Final return includes commit hash and committed file list.

If any are false:
Do not print COMMITTED.
Print a blocker verdict.

## FREEZE_EVIDENCE COMPANION RULE

When a generated runner fails:

01 Freeze the exact command used.
02 Freeze the exact error text.
03 Preserve the failed runner path and SHA256.
04 Preserve the environment/root/lane.
05 Identify whether the issue is surface-only or deeper-layer.
06 If helper/generated-runner issue appears, inspect deeper layer:
   - generator/template defect
   - unsafe parameter pattern
   - path assumption
   - stale helper
   - authority mismatch
   - false-complete reporting
07 Write a fix note.
08 Preserve fixed artifact path and SHA256.
09 Write hash receipt.
10 Close out with DoesNotProve.

Do not erase the failed trail.

## GENERATED RUNNER TEMPLATE REQUIREMENTS

Every generated PowerShell runner should include:

01 `$ErrorActionPreference = "Stop"
02 Set-StrictMode -Version Latest
03 one safe Write-TextFile function using WriteAllText
04 no mandatory Lines array writer
05 explicit expected hashes for required inputs
06 hard blocker exits
07 exact output path collision handling
08 no broad scans unless authorized
09 no Git unless mode says Git is active
10 no final success without proof
11 final return fields
12 DoesNotProve

## SAFE WRITE FUNCTION

Use this shape:

function Write-TextFile {
    param(
        [string]`$Path,
        [string]`$Text
    )

    `$parent = Split-Path -Parent `$Path
    if (-not [string]::IsNullOrWhiteSpace(`$parent)) {
        New-Item -ItemType Directory -Path `$parent -Force | Out-Null
    }

    [System.IO.File]::WriteAllText(`$Path, `$Text, [System.Text.UTF8Encoding]::new(`$false))
}

## BLOCKER EXIT FUNCTION

Use this shape when a blocker report is needed:

function Write-BlockerAndExit {
    param(
        [string]`$Reason,
        [string]`$Detail
    )

    # write blocker report using Write-TextFile
    # hash blocker report
    # print blocker path, hash, reason
    # print final_verdict: BLOCKER_...
    exit 1
}

## AUTHORITY BOUNDARY

This rule card does not authorize:
- running arbitrary scripts
- Git commit
- Git push
- source mutation
- cleanup
- routing
- doctrine promotion
- active guide promotion
- current truth index rewrite
- broad codebase rewrite

This rule card only defines the local generated-runner safety shape.

## DOESNOTPROVE

This rule card does not prove all existing runners are fixed. It does not prove script safety, runtime behavior, Git truth, public truth, source truth, doctrine, active guides, current truth index, cleanup approval, routing approval, mutation authority, push approval, or project completion.

## NEXT RECOMMENDED BUILD CHUNK

GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_20260608

Purpose:
Apply this rule card to the next generated runner before using it, confirming:
- safe writer
- stop-on-blocker
- no false success
- exact proof before final verdict
- Freeze Evidence companion behavior
"@

Write-TextFile -Path $RuleCardPath -Text $RuleText
$RuleCardHash = (Get-FileHash -LiteralPath $RuleCardPath -Algorithm SHA256).Hash

$ReceiptText = @"
GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_RECEIPT_20260608
Created: $Timestamp

rule_card_path: $RuleCardPath
rule_card_sha256: $RuleCardHash

selector_field_test_report_path: $FieldTestReport
selector_field_test_report_sha256: $FieldTestHash

deep_layer_report_path: $DeepLayerReport
deep_layer_report_sha256: $DeepLayerHash

fix_note_path: $FixNote
fix_note_sha256: $FixNoteHash

deep_freeze_receipt_path: $DeepReceipt
deep_freeze_receipt_sha256: $DeepReceiptHash

corrected_safe_git_runner_path: $CorrectedGitRunner
corrected_safe_git_runner_sha256: $CorrectedRunnerHash

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
git_commit_or_push_done: NO

final_verdict: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

"=== GENERATED RUNNER SAFE TEMPLATE RULE CARD COMPLETE ==="
"rule_card_path: $RuleCardPath"
"rule_card_sha256: $RuleCardHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"field_test_report_sha256_confirmed: $FieldTestHash"
"deep_layer_report_sha256_confirmed: $DeepLayerHash"
"fix_note_sha256_confirmed: $FixNoteHash"
"deep_freeze_receipt_sha256_confirmed: $DeepReceiptHash"
"corrected_safe_git_runner_sha256_confirmed: $CorrectedRunnerHash"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_20260608"
"final_verdict: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_READY_WITH_SCOPE_LIMIT_NOTE"
