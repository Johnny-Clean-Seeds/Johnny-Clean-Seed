$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$IncidentFolder = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__GENERATED_RUNNER_LINE_WRITER_DEEP_LAYER__20260608"

$SelectorHelper = Join-Path $Lane "PLANETARY_GATE_SOURCE_ANCHORED_STANDARD_RUN_CARD_AND_SELECTOR_BUILD_20260608.md"
$SourceAnchorHelper = Join-Path $Lane "PLANETARY_GATE_ROLE_CARD_MATRIX_SOURCE_ANCHOR_PASS_20260608.md"
$DeepLayerReport = Join-Path $IncidentFolder "DEEP_LAYER_ROOT_CAUSE__GENERATED_RUNNER_LINE_WRITER_AND_FALSE_COMPLETE_20260608.md"
$FixNote = Join-Path $IncidentFolder "FIX_NOTE__SAFE_TEXT_WRITER_AND_STOP_ON_BLOCKER_PATTERN_20260608.md"
$DeepFreezeReceipt = Join-Path $IncidentFolder "HASH_RECEIPT__GENERATED_RUNNER_DEEP_LAYER_FREEZE_20260608.txt"
$CorrectedGitRunner = Join-Path $Lane "RUN_BOUNDED_GIT_SNAPSHOT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_V0_3_STOP_ON_BLOCKER_SAFE_WRITER_20260608.ps1"

$OutputReportBase = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_GENERATED_RUNNER_DEFECT_FAMILY_20260608.md"
$OutputReportV2 = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_GENERATED_RUNNER_DEFECT_FAMILY_V0_2_20260608.md"

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

function Get-OutputPath {
    if (-not (Test-Path -LiteralPath $OutputReportBase -PathType Leaf)) {
        return $OutputReportBase
    }

    if (-not (Test-Path -LiteralPath $OutputReportV2 -PathType Leaf)) {
        return $OutputReportV2
    }

    throw "BLOCKER_OUTPUT_COLLISION: both base and V0_2 output reports exist."
}

"=== SELECTOR FIELD TEST: GENERATED RUNNER DEFECT FAMILY ==="

$SelectorHash = Require-Hash -Path $SelectorHelper -ExpectedSha256 "377663FFD2DDF1E7C95FC3D19A18B04EB4E304350633F2AB260CD660154366C3" -Name "selector helper"
$SourceAnchorHash = Require-Hash -Path $SourceAnchorHelper -ExpectedSha256 "C22F9A9C739FD2BE3B6696DB193B10164E3363F1120E9EB52B37D393C0615260" -Name "source-anchor helper"
$DeepLayerHash = Require-Hash -Path $DeepLayerReport -ExpectedSha256 "5584FEED2B9FB713463B2C63F02D0BC866AB5B20D332D236BE1B304BDA65E16A" -Name "deep-layer root-cause report"
$FixNoteHash = Require-Hash -Path $FixNote -ExpectedSha256 "B7CA2AE7D5F33594DE772EAF0485D8A01612547A6E662892FAAC97B8F8D021EC" -Name "fix note"
$DeepReceiptHash = Require-Hash -Path $DeepFreezeReceipt -ExpectedSha256 "098424D043022C8B0C0D2DE5A47CABCBE7D58B03EF39BCA65A256595B91388D9" -Name "deep freeze receipt"
$CorrectedRunnerHash = Require-Hash -Path $CorrectedGitRunner -ExpectedSha256 "F00FE67E139E3A0F5CC87DEE0EEAD2464D601E151DEA73B37B9FBB86CEB8197E" -Name "corrected safe Git runner"

$OutputReport = Get-OutputPath
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$Report = @"
# PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_GENERATED_RUNNER_DEFECT_FAMILY_20260608

Mode: HELPER_FIRST / SELECTOR_FIELD_TEST_PACKET / READ_ONLY / NO_GIT / NO_SCRIPT_EXECUTION / NOT_DOCTRINE / NOT_ACTIVE_GUIDES / NOT_CURRENT_TRUTH_INDEX

Created: $Timestamp

Working root:
$ProjectRoot

Active lane:
$Lane

User-named real issue:
Generated-runner line-writer defect family plus false-complete-after-blocker defect.

Final verdict:
SELECTOR_FIELD_TEST_PACKET_READY_WITH_SCOPE_LIMIT_NOTE

## PURPOSE

Field-test the source-anchored selector against the real defect family that appeared during the PowerShell helper workflow.

The tested object is not a generic PowerShell helper file. The tested object is the repeated generated-runner failure family:

01 brittle line writer rejects empty collection
02 brittle line writer rejects empty string
03 blocker occurs but interactive command chain continues
04 false committed/success verdict prints after no commit happened

This job does not execute Git, does not execute helper scripts, does not mutate source files, does not stage files, does not commit, and does not push.

## VERIFIED HELPERS AND LOCAL EVIDENCE

Selector helper:
$SelectorHelper
SHA256:
$SelectorHash

Source-anchor helper:
$SourceAnchorHelper
SHA256:
$SourceAnchorHash

Deep-layer root-cause report:
$DeepLayerReport
SHA256:
$DeepLayerHash

Fix note:
$FixNote
SHA256:
$FixNoteHash

Deep freeze receipt:
$DeepFreezeReceipt
SHA256:
$DeepReceiptHash

Corrected safe Git runner:
$CorrectedGitRunner
SHA256:
$CorrectedRunnerHash

Source sections read:
NONE in this field-test job. This test relies on the selector helper and source-anchor helper already produced.

Full source-vault review claimed:
NO

## STANDARD RUN CARD

Active object:
Generated-runner line-writer defect family plus false-complete-after-blocker defect.

Entry source:
Freeze-evidence incident chain and deep-layer root-cause report from local lane.

Source/custody state:
LOCAL_INCIDENT_EVIDENCE / ROUGH_LOCAL_HASH_TRUTH_AVAILABLE / NOT_DOCTRINE / NOT_ACTIVE_GUIDE / NOT_CURRENT_TRUTH_INDEX

Intake verdict:
INTAKE_FIT_FOR_FIELD_TEST. The defect family is a valid named object for selector testing because it repeated across multiple generated runners.

Layer Echo scan:
Same shape repeated across the first selector runner and the later freeze/repair runner: generated file writers used brittle Lines parameters. A second pattern appeared when the Git snapshot flow continued after a no-worktree blocker and printed a false success verdict.

Support guard membrane scan:
Protect the evidence trail, preserve local-only evidence, keep rough_local Git boundary, and prevent another surface-only retry.

Triggered support organ expanded:
FREEZE_EVIDENCE / GENERATED_RUNNER_TEMPLATE_DEFECT / FALSE_COMPLETE_GUARD

Rope selected:
GENERATED_RUNNER_DEFECT_REQUIRES_TEMPLATE_REPAIR_AND_STOP_ON_BLOCKER_RULE

Primary planet:
PLUTO_GATE

Primary planet verdict:
PLUTO_ROOT_CAUSE_FOUND. The visible errors are not separate one-off typos; they share a buried generator/template defect and a false-complete control-flow weakness.

Counterweight planet:
EARTH_GATE

Counterweight verdict:
EARTH_PROOF_REQUIRED. The fix must be proven by material script shape and future runner behavior, not by saying the idea is fixed.

Mechanical gate if needed:
Code Gate for read-only code-shape review, Proof Gate for receipt/hash proof, Hash/Receipt Gate for artifact identity. Git Gate is not active in this field test.

Earth check:
Confirmed local evidence hashes for the selector helper, source-anchor helper, deep-layer report, fix note, deep freeze receipt, and corrected safe Git runner. Wrote this one output report and records its SHA256 after creation.

Allowed action:
Create exactly one selector field-test report for the generated-runner defect family.

Blocked action:
Git, commit, push, script execution, helper script execution, source mutation, cleanup, routing, broad scan, doctrine promotion, active guide promotion, current truth index rewrite, fixture run, URL opening, full source-vault reread, or claiming full source-vault review.

Proof need:
Output report path and SHA256, verified input hashes, selector-applied flag, primary planet, counterweight planet, mechanical gates, final route.

Stop condition:
Missing/hash-mismatched selector helper, missing/hash-mismatched source-anchor helper, missing/hash-mismatched local deep-layer evidence, output collision, or any pressure to execute Git/scripts.

Final route:
ADAPT

DoesNotProve:
This field test does not prove all future generated runners are fixed, does not prove Git commit state, does not prove push state, does not prove doctrine, does not prove active guides, does not prove current truth index, does not prove full source-vault review, and does not authorize cleanup, routing, source mutation, or script execution.

## SELECTOR STEP-BY-STEP APPLICATION

01 Active object selection:
The active object is the repeated generated-runner defect family, not the whole project, not Git, not the incident folder contents, and not a new broad PowerShell audit.

02 Entry source identification:
The object entered through actual failures and freeze-evidence records in the local lane.

03 INTAKE_GATE:
Classifies the object as a generated-runner/template defect family requiring targeted handling.

04 LAYER_ECHO_FIRST_SCAN:
Finds the same failure shape across multiple runners: brittle writer parameter and bad stop behavior after blockers.

05 SUPPORT_GUARD_MEMBRANE:
Protects evidence chain, rough_local Git boundary, and no-execution/no-mutation scope.

06 Support expansion:
Expand only the generated-runner template defect and false-complete guard. Do not expand into full codebase scan.

07 ROPE_ROUTER:
Selects generated-runner template repair and stop-on-blocker rule as the player.

08 Primary planet:
PLUTO_GATE because the core issue is the buried parent defect behind multiple visible failures.

09 Counterweight planet:
EARTH_GATE because the fix must become a material safe-runner pattern.

10 Mechanical gates:
Code Gate, Proof Gate, Hash/Receipt Gate. Git Gate remains inactive.

11 Earth check:
Hashes and report path prove this field-test packet only. They do not prove global fix.

12 Final Judge:
ADAPT because the selector produced a usable diagnosis and next build target, but not doctrine or global completion.

## BLOCKER PATHFINDING MAP

### BLOCKER 01

BLOCKER:
Generated-runner line-writer defect family.

ACTION BLOCKED:
More generated runners using mandatory Lines arrays or empty-string-sensitive writers.

WHY BLOCKED:
The same binding failure repeated across multiple scripts.

MISSING CONDITION:
Reusable safe writer rule or template card installed into the generator/runner pattern.

POINTS TO NEXT:
Create a generated-runner safe template rule card.

SAFE WORK NOW:
Use WriteAllText with one string, no mandatory Lines writer, and hash receipts.

STILL NOT AUTHORIZED:
Broad helper rewrite, source mutation, Git commit, push, cleanup, or script execution.

DOESNOTPROVE:
Finding the defect family does not prove all existing scripts are repaired.

### BLOCKER 02

BLOCKER:
False-complete after blocker.

ACTION BLOCKED:
Any final success verdict after blocker unless material success conditions are met.

WHY BLOCKED:
The no-worktree blocker was real, but later pasted commands printed a committed verdict with empty commit hash and zero files.

MISSING CONDITION:
Hard exit on blocker and final verdict guard requiring material proof.

POINTS TO NEXT:
Install STOP_ON_BLOCKER and SUCCESS_REQUIRES_PROOF in runner template.

SAFE WORK NOW:
Use packaged runners with try/catch and explicit nonzero exit on blocker.

STILL NOT AUTHORIZED:
Claiming commit, clean Git, or done without commit hash and exact staged/committed set.

DOESNOTPROVE:
A printed final verdict is not proof.

### BLOCKER 03

BLOCKER:
Rough_local/local evidence boundary.

ACTION BLOCKED:
Putting full incident evidence into Git by default.

WHY BLOCKED:
Full local evidence may be too local, too large, or too sensitive.

MISSING CONDITION:
Explicit user approval for full-content Git.

POINTS TO NEXT:
Use rough_local hash ledger and import receipt.

SAFE WORK NOW:
Commit only Git-safe hash ledger packets.

STILL NOT AUTHORIZED:
Full incident folder staging.

DOESNOTPROVE:
Hash ledger does not contain full evidence.

## NEXT RECOMMENDED BUILD CHUNK

GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608

Purpose:
Create a standing local rule card for future generated PowerShell runners.

Required rule shape:
01 Use WriteAllText for file writing.
02 Build report text as one string or here-string.
03 Do not use mandatory Lines arrays for generated text.
04 Do not reject empty strings accidentally.
05 Stop hard on blocker.
06 Never print success after blocker.
07 Never print COMMITTED unless commit hash exists and staged/committed set was exact.
08 Freeze evidence before fixing.
09 Investigate deeper layer when helper/generated runner fails.
10 Carry rough_local boundary when evidence is local/sensitive.

## FINAL RETURN FIELDS

output_report_path:
TO_BE_FILLED_AFTER_CREATION

output_report_sha256:
TO_BE_FILLED_AFTER_CREATION

selector_helper_sha256_confirmed:
$SelectorHash

source_anchor_helper_sha256_confirmed:
$SourceAnchorHash

deep_layer_report_sha256_confirmed:
$DeepLayerHash

fix_note_sha256_confirmed:
$FixNoteHash

deep_freeze_receipt_sha256_confirmed:
$DeepReceiptHash

corrected_safe_git_runner_sha256_confirmed:
$CorrectedRunnerHash

user_named_object:
Generated-runner line-writer defect family plus false-complete-after-blocker defect

source_sections_read:
NONE in this field-test job

full_source_vault_review_claimed:
NO

selector_applied:
YES

primary_planet_selected:
PLUTO_GATE

counterweight_planet_selected:
EARTH_GATE

mechanical_gate_selected:
Code Gate; Proof Gate; Hash/Receipt Gate

final_route:
ADAPT

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
0 arbitrary helper scripts; 1 bounded field-test runner

git_commit_or_push_done:
NO

next_build_chunk_selected:
GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608

final_verdict:
SELECTOR_FIELD_TEST_PACKET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputReport -Text $Report
$OutputHash = (Get-FileHash -LiteralPath $OutputReport -Algorithm SHA256).Hash

# Patch final fields with actual output path/hash, then re-hash.
$Report = $Report.Replace("output_report_path:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_path:`r`n$OutputReport")
$Report = $Report.Replace("output_report_path:`nTO_BE_FILLED_AFTER_CREATION", "output_report_path:`n$OutputReport")
$Report = $Report.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$Report = $Report.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")

Write-TextFile -Path $OutputReport -Text $Report
$FinalHash = (Get-FileHash -LiteralPath $OutputReport -Algorithm SHA256).Hash

"=== SELECTOR FIELD TEST FOR GENERATED RUNNER DEFECT FAMILY COMPLETE ==="
"output_report_path: $OutputReport"
"output_report_sha256: $FinalHash"
"selector_helper_sha256_confirmed: $SelectorHash"
"source_anchor_helper_sha256_confirmed: $SourceAnchorHash"
"deep_layer_report_sha256_confirmed: $DeepLayerHash"
"fix_note_sha256_confirmed: $FixNoteHash"
"deep_freeze_receipt_sha256_confirmed: $DeepReceiptHash"
"corrected_safe_git_runner_sha256_confirmed: $CorrectedRunnerHash"
"user_named_object: Generated-runner line-writer defect family plus false-complete-after-blocker defect"
"source_sections_read: NONE in this field-test job"
"full_source_vault_review_claimed: NO"
"selector_applied: YES"
"primary_planet_selected: PLUTO_GATE"
"counterweight_planet_selected: EARTH_GATE"
"mechanical_gate_selected: Code Gate; Proof Gate; Hash/Receipt Gate"
"final_route: ADAPT"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0 arbitrary helper scripts; 1 bounded field-test runner"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608"
"final_verdict: SELECTOR_FIELD_TEST_PACKET_READY_WITH_SCOPE_LIMIT_NOTE"
