$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$RuleCard = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md"
$RuleReceipt = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_RECEIPT_20260608.txt"
$FieldTestReport = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_GENERATED_RUNNER_DEFECT_FAMILY_20260608.md"

$OutputBase = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_20260608.md"
$OutputV2 = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_V0_2_20260608.txt"

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

function Stop-WithBlocker {
    param(
        [string]$Reason,
        [string]$Detail
    )

    $BlockerPath = Join-Path $Lane "BLOCKER__GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $BlockerText = @"
# BLOCKER__GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the rule card failed globally. It proves this bounded field-apply runner stopped before a valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== GENERATED RUNNER SAFE TEMPLATE FIELD APPLY BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_NOT_COMPLETE"
    exit 1
}

function Require-Hash {
    param(
        [string]$Path,
        [string]$ExpectedSha256,
        [string]$Name
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Stop-WithBlocker -Reason "MISSING_REQUIRED_FILE" -Detail "$Name :: $Path"
    }

    $actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($actual -ne $ExpectedSha256) {
        Stop-WithBlocker -Reason "HASH_MISMATCH" -Detail "$Name :: actual=$actual expected=$ExpectedSha256 path=$Path"
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

    Stop-WithBlocker -Reason "OUTPUT_COLLISION" -Detail "Both base and V0_2 output paths exist for $Base"
}

"=== GENERATED RUNNER SAFE TEMPLATE RULE CARD FIELD APPLY ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Stop-WithBlocker -Reason "MISSING_LANE" -Detail $Lane
}

$ThisRunnerPath = $PSCommandPath
if ([string]::IsNullOrWhiteSpace($ThisRunnerPath) -or -not (Test-Path -LiteralPath $ThisRunnerPath -PathType Leaf)) {
    Stop-WithBlocker -Reason "MISSING_SELF_PATH" -Detail "PSCommandPath was unavailable."
}

$RuleHash = Require-Hash -Path $RuleCard -ExpectedSha256 "E0013BA267527AF2201B934E8AEEB55710835EF0CC3ECD78250729E6ECB8FB26" -Name "generated-runner safe template rule card"
$RuleReceiptHash = Require-Hash -Path $RuleReceipt -ExpectedSha256 "13E18217CB7DE53B4C7749CB7D7D7AB454B3A8EB111A5167D3C384ABF75863F4" -Name "generated-runner safe template rule card receipt"
$FieldTestHash = Require-Hash -Path $FieldTestReport -ExpectedSha256 "4BCB354B10B28066AB4A78BF9861F6EDB9795A323362678BB97B175427AD99A0" -Name "generated-runner selector field test report"

$ThisRunnerText = Get-Content -LiteralPath $ThisRunnerPath -Raw
$ThisRunnerHash = (Get-FileHash -LiteralPath $ThisRunnerPath -Algorithm SHA256).Hash

$Checks = [ordered]@{
    HasErrorActionStop = ($ThisRunnerText -match '\$ErrorActionPreference\s*=\s*"Stop"')
    HasStrictMode = ($ThisRunnerText -match 'Set-StrictMode\s+-Version\s+Latest')
    HasSafeWriteAllText = ($ThisRunnerText -match '\[System\.IO\.File\]::WriteAllText')
    HasUtf8NoBom = ($ThisRunnerText -match '\[System\.Text\.UTF8Encoding\]::new\(\$false\)')
    HasStopWithBlocker = ($ThisRunnerText -match 'function\s+Stop-WithBlocker')
    HasExitNonZero = ($ThisRunnerText -match 'exit\s+1')
    AvoidsMandatoryLinesWriter = -not ($ThisRunnerText -match 'param\s*\([^)]*\[string\[\]\]\s*\$Lines')
    AvoidsWriteUtf8FileLinesPattern = -not ($ThisRunnerText -match 'Write-Utf8File\s+-Path\s+.*-Lines')
    AvoidsCommittedClaim = -not ($ThisRunnerText -match 'final_verdict:\s*.*COMMITTED')
    AvoidsGitCommands = -not ($ThisRunnerText -match 'git\s+-C|git\s+add|git\s+commit|git\s+push')
}

$FailedChecks = @()
foreach ($k in $Checks.Keys) {
    if (-not $Checks[$k]) {
        $FailedChecks += $k
    }
}

if ($FailedChecks.Count -gt 0) {
    Stop-WithBlocker -Reason "SAFE_TEMPLATE_SELF_CHECK_FAILED" -Detail ($FailedChecks -join "; ")
}

$OutputPath = Choose-OutputPath -Base $OutputBase -V2 $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -V2 $ReceiptV2
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$CheckLines = foreach ($k in $Checks.Keys) {
    "- $k`: $($Checks[$k])"
}

$ReportText = @"
# GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_20260608

Status: FIELD_APPLY_REPORT / GENERATED_RUNNER_SAFE_TEMPLATE_USED / NO_GIT / NO_SCRIPT_EXECUTION_BEYOND_THIS_BOUNDED_RUNNER / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Applied rule card:
$RuleCard
SHA256:
$RuleHash

Rule receipt:
$RuleReceipt
SHA256:
$RuleReceiptHash

Prior selector field-test report:
$FieldTestReport
SHA256:
$FieldTestHash

Runner being field-applied:
$ThisRunnerPath
SHA256:
$ThisRunnerHash

Purpose:
Apply the generated-runner safe template rule card to the next generated runner before trusting its output.

This runner is the first field application of the new rule card.

## SELF-CHECK RESULTS

$($CheckLines -join "`r`n")

## INTERPRETATION

The generated runner passed the local rule-card shape check.

Confirmed:
01 ErrorActionPreference is Stop.
02 StrictMode is enabled.
03 Text writing uses System.IO.File.WriteAllText.
04 UTF-8 no BOM encoding is explicit.
05 Stop-WithBlocker exists.
06 Blocker path exits nonzero.
07 Mandatory Lines array writer pattern is absent.
08 Write-Utf8File -Lines pattern is absent.
09 COMMITTED success claim is absent.
10 Git commands are absent.

## FIELD APPLY VERDICT

The rule card is usable as a generation constraint for the next bounded runner.

The field application does not prove all future runners are safe. It proves only that this generated runner followed the new safe-template requirements.

## NEXT RECOMMENDED BUILD CHUNK

ROUGH_LOCAL_IMPORT_FOR_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608

Purpose:
Create a Git-safe rough_local import packet for the standing rule card and this field-apply report.

Boundary:
Full local evidence stays local. Git gets rule-card/receipt/field-apply hash truth only unless user explicitly approves more.

## DOESNOTPROVE

This field-apply report does not prove doctrine, global tool safety, all future generated runners, Git commit state, Git push state, source truth, current truth index, cleanup approval, routing approval, mutation authority, or project completion.

## FINAL RETURN FIELDS

output_report_path:
$OutputPath

output_report_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

rule_card_sha256_confirmed:
$RuleHash

rule_receipt_sha256_confirmed:
$RuleReceiptHash

field_test_report_sha256_confirmed:
$FieldTestHash

field_applied_runner_path:
$ThisRunnerPath

field_applied_runner_sha256:
$ThisRunnerHash

safe_template_self_check_passed:
YES

git_commit_or_push_done:
NO

next_build_chunk_selected:
ROUGH_LOCAL_IMPORT_FOR_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608

final_verdict:
GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

rule_card_path: $RuleCard
rule_card_sha256: $RuleHash

rule_receipt_path: $RuleReceipt
rule_receipt_sha256: $RuleReceiptHash

field_test_report_path: $FieldTestReport
field_test_report_sha256: $FieldTestHash

field_applied_runner_path: $ThisRunnerPath
field_applied_runner_sha256: $ThisRunnerHash

safe_template_self_check_passed: YES

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
git_commit_or_push_done: NO

final_verdict: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

# Patch hashes into report after receipt exists.
$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== GENERATED RUNNER SAFE TEMPLATE FIELD APPLY COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"rule_card_sha256_confirmed: $RuleHash"
"rule_receipt_sha256_confirmed: $RuleReceiptHash"
"field_test_report_sha256_confirmed: $FieldTestHash"
"field_applied_runner_path: $ThisRunnerPath"
"field_applied_runner_sha256: $ThisRunnerHash"
"safe_template_self_check_passed: YES"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608"
"final_verdict: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_READY_WITH_SCOPE_LIMIT_NOTE"
