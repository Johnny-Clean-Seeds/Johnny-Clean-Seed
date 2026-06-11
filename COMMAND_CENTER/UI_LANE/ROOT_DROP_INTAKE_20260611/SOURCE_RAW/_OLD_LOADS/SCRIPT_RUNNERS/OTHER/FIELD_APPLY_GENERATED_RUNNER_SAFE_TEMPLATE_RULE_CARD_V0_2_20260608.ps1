$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$RuleCard = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md"
$RuleReceipt = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_RECEIPT_20260608.txt"
$FieldTestReport = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_GENERATED_RUNNER_DEFECT_FAMILY_20260608.md"
$PriorBlocker = Join-Path $Lane "BLOCKER__GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_20260608.md"
$FailedRunner = Join-Path $env:USERPROFILE "Downloads\FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1"

$IncidentFolder = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__SAFE_TEMPLATE_FIELD_APPLY_SELF_CHECK_FALSE_POSITIVE__20260608"
$FreezePath = Join-Path $IncidentFolder "ERROR_FREEZE__SAFE_TEMPLATE_FIELD_APPLY_SELF_CHECK_FALSE_POSITIVE_20260608.md"
$FixNotePath = Join-Path $IncidentFolder "FIX_NOTE__CODE_AWARE_SELF_CHECK_FOR_SAFE_TEMPLATE_FIELD_APPLY_20260608.md"
$FailedRunnerCopy = Join-Path $IncidentFolder "FAILED_RUNNER_COPY__FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1"

$OutputBase = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_2_20260608.md"
$OutputV3 = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_3_20260608.md"
$ReceiptBase = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_V0_2_20260608.txt"
$ReceiptV3 = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_V0_3_20260608.txt"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_V0_2_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $BlockerText = @"
# BLOCKER__GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_V0_2_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_V0_2_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the rule card failed globally. It proves this bounded V0_2 field-apply runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== GENERATED RUNNER SAFE TEMPLATE FIELD APPLY V0_2 BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_V0_2_NOT_COMPLETE"
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
        [string]$V3
    )

    if (-not (Test-Path -LiteralPath $Base -PathType Leaf)) {
        return $Base
    }

    if (-not (Test-Path -LiteralPath $V3 -PathType Leaf)) {
        return $V3
    }

    Stop-WithBlocker -Reason "OUTPUT_COLLISION" -Detail "Both base and V0_3 output paths exist for $Base"
}

function Get-CodeLikeText {
    param([string]$Text)

    # Remove here-string bodies so report prose does not trigger command/proof checks.
    $withoutHereStrings = [regex]::Replace(
        $Text,
        '(?ms)@["'']\r?\n.*?\r?\n["'']@',
        ''
    )

    $lines = $withoutHereStrings -split "`r?`n"
    $codeLines = foreach ($line in $lines) {
        $trim = $line.Trim()
        if ($trim.Length -eq 0) {
            continue
        }

        if ($trim.StartsWith("#")) {
            continue
        }

        $line
    }

    return ($codeLines -join "`n")
}

"=== GENERATED RUNNER SAFE TEMPLATE RULE CARD FIELD APPLY V0_2 ==="

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

$PriorBlockerHash = $null
if (Test-Path -LiteralPath $PriorBlocker -PathType Leaf) {
    $PriorBlockerHash = (Get-FileHash -LiteralPath $PriorBlocker -Algorithm SHA256).Hash
} else {
    Stop-WithBlocker -Reason "MISSING_PRIOR_BLOCKER_FREEZE" -Detail $PriorBlocker
}

if ($PriorBlockerHash -ne "7AF806829BB686BCD6A7EB3770D05C2458D0F920399758E2A08A7893C68BF834") {
    Stop-WithBlocker -Reason "PRIOR_BLOCKER_HASH_MISMATCH" -Detail "actual=$PriorBlockerHash expected=7AF806829BB686BCD6A7EB3770D05C2458D0F920399758E2A08A7893C68BF834 path=$PriorBlocker"
}

$FailedRunnerHash = "MISSING"
if (Test-Path -LiteralPath $FailedRunner -PathType Leaf) {
    Copy-Item -LiteralPath $FailedRunner -Destination $FailedRunnerCopy -Force
    $FailedRunnerHash = (Get-FileHash -LiteralPath $FailedRunner -Algorithm SHA256).Hash
    $FailedRunnerCopyHash = (Get-FileHash -LiteralPath $FailedRunnerCopy -Algorithm SHA256).Hash
} else {
    $FailedRunnerCopyHash = "NOT_COPIED_SOURCE_MISSING"
}

$ThisRunnerText = Get-Content -LiteralPath $ThisRunnerPath -Raw
$ThisRunnerHash = (Get-FileHash -LiteralPath $ThisRunnerPath -Algorithm SHA256).Hash
$CodeLikeText = Get-CodeLikeText -Text $ThisRunnerText

# Freeze the V0_1 false positive before reporting V0_2 success.
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$FreezeText = @"
# ERROR_FREEZE__SAFE_TEMPLATE_FIELD_APPLY_SELF_CHECK_FALSE_POSITIVE_20260608

Status: FREEZE_EVIDENCE / GENERATED_RUNNER_SELF_CHECK_FALSE_POSITIVE / LOCAL_ONLY

Created: $Timestamp

Failed action:
FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1

Observed blocker:
SAFE_TEMPLATE_SELF_CHECK_FAILED

Observed details:
AvoidsCommittedClaim; AvoidsGitCommands

Prior blocker path:
$PriorBlocker

Prior blocker SHA256:
$PriorBlockerHash

Failed runner path:
$FailedRunner

Failed runner SHA256:
$FailedRunnerHash

Failed runner copy:
$FailedRunnerCopy

Failed runner copy SHA256:
$FailedRunnerCopyHash

Root cause:
The V0_1 self-check inspected raw script text. That raw text included regex patterns and report prose containing Git/COMMITTED vocabulary. The checker treated vocabulary inside its own test/prose as executable Git behavior or false success behavior.

Corrected principle:
Self-checks for forbidden behavior must distinguish code-like executable text from report prose, comments, and the self-check regex strings themselves.

Final freeze verdict:
SAFE_TEMPLATE_FIELD_APPLY_FALSE_POSITIVE_FROZEN_BEFORE_V0_2_FIX
"@
Write-TextFile -Path $FreezePath -Text $FreezeText
$FreezeHash = (Get-FileHash -LiteralPath $FreezePath -Algorithm SHA256).Hash

$FixNoteText = @"
# FIX_NOTE__CODE_AWARE_SELF_CHECK_FOR_SAFE_TEMPLATE_FIELD_APPLY_20260608

Status: FIX_NOTE / CODE_AWARE_SELF_CHECK / SAFE_TEMPLATE_FIELD_APPLY_V0_2

Created: $Timestamp

Problem:
V0_1 correctly stopped, but for the wrong reason. It used raw text checks that matched its own test/prose vocabulary.

Fix:
V0_2 uses a code-like text pass for forbidden-behavior checks. Here-string report bodies and comments are removed before checking for executable Git invocation or proof-claim behavior.

Preserved:
The prior blocker is preserved.
The failed runner is copied when available.
The false-positive cause is recorded before the V0_2 pass.

DoesNotProve:
This fix does not prove a full PowerShell parser. It is a bounded improvement sufficient for this rule-card field-apply runner.
"@
Write-TextFile -Path $FixNotePath -Text $FixNoteText
$FixNoteHash = (Get-FileHash -LiteralPath $FixNotePath -Algorithm SHA256).Hash

$Checks = [ordered]@{
    HasErrorActionStop = ($ThisRunnerText -match '\$ErrorActionPreference\s*=\s*"Stop"')
    HasStrictMode = ($ThisRunnerText -match 'Set-StrictMode\s+-Version\s+Latest')
    HasSafeWriteAllText = ($ThisRunnerText -match '\[System\.IO\.File\]::WriteAllText')
    HasUtf8NoBom = ($ThisRunnerText -match '\[System\.Text\.UTF8Encoding\]::new\(\$false\)')
    HasStopWithBlocker = ($ThisRunnerText -match 'function\s+Stop-WithBlocker')
    HasExitNonZero = ($ThisRunnerText -match 'exit\s+1')
    AvoidsMandatoryLinesWriter = -not ($ThisRunnerText -match 'param\s*\([^)]*\[string\[\]\]\s*\$Lines')
    AvoidsWriteUtf8FileLinesPattern = -not ($CodeLikeText -match 'Write-Utf8File\s+-Path\s+.*-Lines')
    AvoidsActualCommittedVerdict = -not ($CodeLikeText -match '^\s*"final_verdict:\s*[^"]*COMMITTED[^"]*"\s*$')
    AvoidsActualGitInvocation = -not ($CodeLikeText -match '(^|\n)\s*(&\s*)?git\s+(-C|add|commit|push|status|rev-parse)\b')
}

$FailedChecks = @()
foreach ($k in $Checks.Keys) {
    if (-not $Checks[$k]) {
        $FailedChecks += $k
    }
}

if ($FailedChecks.Count -gt 0) {
    Stop-WithBlocker -Reason "SAFE_TEMPLATE_V0_2_SELF_CHECK_FAILED" -Detail ($FailedChecks -join "; ")
}

$OutputPath = Choose-OutputPath -Base $OutputBase -V3 $OutputV3
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -V3 $ReceiptV3

$CheckLines = foreach ($k in $Checks.Keys) {
    "- $k`: $($Checks[$k])"
}

$ReportText = @"
# GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_2_20260608

Status: FIELD_APPLY_REPORT / GENERATED_RUNNER_SAFE_TEMPLATE_USED / CODE_AWARE_SELF_CHECK / NO_GIT / NOT_DOCTRINE

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

Prior V0_1 blocker:
$PriorBlocker
SHA256:
$PriorBlockerHash

False-positive freeze report:
$FreezePath
SHA256:
$FreezeHash

False-positive fix note:
$FixNotePath
SHA256:
$FixNoteHash

Runner being field-applied:
$ThisRunnerPath
SHA256:
$ThisRunnerHash

Purpose:
Apply the generated-runner safe template rule card to this V0_2 generated runner after freezing the V0_1 self-check false positive.

## SELF-CHECK RESULTS

$($CheckLines -join "`r`n")

## INTERPRETATION

The V0_2 generated runner passed the local rule-card shape check.

The prior field-apply blocker was valid as a stop event but not valid as proof that the runner contained actual Git behavior. It proved the self-check itself was too literal.

V0_2 correction:
Forbidden behavior is checked against code-like text, not report prose or comments.

Confirmed:
01 ErrorActionPreference is Stop.
02 StrictMode is enabled.
03 Text writing uses System.IO.File.WriteAllText.
04 UTF-8 no BOM encoding is explicit.
05 Stop-WithBlocker exists.
06 Blocker path exits nonzero.
07 Mandatory Lines array writer pattern is absent.
08 Write-Utf8File -Lines executable pattern is absent.
09 Actual COMMITTED final verdict claim is absent.
10 Actual Git invocation is absent.

## FIELD APPLY VERDICT

The rule card is usable as a generation constraint for the next bounded runner.

## NEXT RECOMMENDED BUILD CHUNK

ROUGH_LOCAL_IMPORT_FOR_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608

Purpose:
Create a Git-safe rough_local import packet for the standing rule card, receipt, V0_2 field-apply report, and false-positive freeze/fix note hashes.

Boundary:
Full local evidence stays local. Git gets hash-truth pointer material only unless the user explicitly approves more.

## DOESNOTPROVE

This field-apply report does not prove doctrine, global parser completeness, global tool safety, all future generated runners, Git commit state, Git push state, source truth, current truth index, cleanup approval, routing approval, mutation authority, or project completion.

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

prior_blocker_sha256_confirmed:
$PriorBlockerHash

false_positive_freeze_sha256:
$FreezeHash

false_positive_fix_note_sha256:
$FixNoteHash

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
GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_V0_2_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_V0_2_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

rule_card_path: $RuleCard
rule_card_sha256: $RuleHash

rule_receipt_path: $RuleReceipt
rule_receipt_sha256: $RuleReceiptHash

field_test_report_path: $FieldTestReport
field_test_report_sha256: $FieldTestHash

prior_blocker_path: $PriorBlocker
prior_blocker_sha256: $PriorBlockerHash

false_positive_freeze_path: $FreezePath
false_positive_freeze_sha256: $FreezeHash

false_positive_fix_note_path: $FixNotePath
false_positive_fix_note_sha256: $FixNoteHash

field_applied_runner_path: $ThisRunnerPath
field_applied_runner_sha256: $ThisRunnerHash

safe_template_self_check_passed: YES
code_aware_self_check_used: YES

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 1 failed runner copy when available
files_overwritten_count: 0
git_commit_or_push_done: NO

final_verdict: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_V0_2_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== GENERATED RUNNER SAFE TEMPLATE FIELD APPLY V0_2 COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"rule_card_sha256_confirmed: $RuleHash"
"rule_receipt_sha256_confirmed: $RuleReceiptHash"
"field_test_report_sha256_confirmed: $FieldTestHash"
"prior_blocker_sha256_confirmed: $PriorBlockerHash"
"false_positive_freeze_path: $FreezePath"
"false_positive_freeze_sha256: $FreezeHash"
"false_positive_fix_note_path: $FixNotePath"
"false_positive_fix_note_sha256: $FixNoteHash"
"failed_runner_copy_path: $FailedRunnerCopy"
"failed_runner_copy_sha256: $FailedRunnerCopyHash"
"field_applied_runner_path: $ThisRunnerPath"
"field_applied_runner_sha256: $ThisRunnerHash"
"safe_template_self_check_passed: YES"
"code_aware_self_check_used: YES"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608"
"final_verdict: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_V0_2_READY_WITH_SCOPE_LIMIT_NOTE"
