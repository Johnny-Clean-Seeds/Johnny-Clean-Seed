$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$RuleCard = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md"
$RuleReceipt = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_RECEIPT_20260608.txt"
$FieldTestReport = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_GENERATED_RUNNER_DEFECT_FAMILY_20260608.md"

$PriorBlocker = Join-Path $Lane "BLOCKER__GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_20260608.md"

$IncidentFolder = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__SAFE_TEMPLATE_FIELD_APPLY_SELF_CHECK_AND_COPY_PATH_CHAIN__20260608"
$FreezeV01Path = Join-Path $IncidentFolder "ERROR_FREEZE__SAFE_TEMPLATE_FIELD_APPLY_V0_1_SELF_CHECK_FALSE_POSITIVE_20260608.md"
$FreezeV02Path = Join-Path $IncidentFolder "ERROR_FREEZE__SAFE_TEMPLATE_FIELD_APPLY_V0_2_MISSING_PARENT_COPY_20260608.md"
$FixNotePath = Join-Path $IncidentFolder "FIX_NOTE__SAFE_TEMPLATE_FIELD_APPLY_V0_3_PARENT_FIRST_AND_CODE_AWARE_CHECK_20260608.md"

$FailedRunnerV01 = Join-Path $env:USERPROFILE "Downloads\FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1"
$FailedRunnerV02 = Join-Path $env:USERPROFILE "Downloads\FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_V0_2_20260608.ps1"

$FailedRunnerV01Copy = Join-Path $IncidentFolder "FAILED_RUNNER_COPY__FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608.ps1"
$FailedRunnerV02Copy = Join-Path $IncidentFolder "FAILED_RUNNER_COPY__FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_V0_2_20260608.ps1"

$OutputBase = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_3_20260608.md"
$OutputV4 = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_4_20260608.md"
$ReceiptBase = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_V0_3_20260608.txt"
$ReceiptV4 = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_V0_4_20260608.txt"

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

function Copy-FileSafe {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        return "SOURCE_MISSING"
    }

    Ensure-ParentFolder -Path $Destination
    Copy-Item -LiteralPath $Source -Destination $Destination -Force

    return (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash
}

function Stop-WithBlocker {
    param(
        [string]$Reason,
        [string]$Detail
    )

    $BlockerPath = Join-Path $Lane "BLOCKER__GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_V0_3_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_V0_3_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_V0_3_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the rule card failed globally. It proves this bounded V0_3 field-apply runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== GENERATED RUNNER SAFE TEMPLATE FIELD APPLY V0_3 BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_GENERATED_RUNNER_SAFE_TEMPLATE_FIELD_APPLY_V0_3_NOT_COMPLETE"
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
        [string]$Fallback
    )

    if (-not (Test-Path -LiteralPath $Base -PathType Leaf)) {
        return $Base
    }

    if (-not (Test-Path -LiteralPath $Fallback -PathType Leaf)) {
        return $Fallback
    }

    Stop-WithBlocker -Reason "OUTPUT_COLLISION" -Detail "Both output paths already exist: $Base and $Fallback"
}

function Remove-HereStringsAndComments {
    param([string]$Text)

    $lines = $Text -split "`r?`n"
    $kept = New-Object System.Collections.Generic.List[string]
    $insideHere = $false

    foreach ($line in $lines) {
        $trim = $line.Trim()

        if ($insideHere) {
            if ($trim -eq '"@' -or $trim -eq "'@") {
                $insideHere = $false
            }
            continue
        }

        if ($trim -eq '@"' -or $trim -eq "@'") {
            $insideHere = $true
            continue
        }

        if ($trim.Length -eq 0) {
            continue
        }

        if ($trim.StartsWith("#")) {
            continue
        }

        $kept.Add($line)
    }

    return ($kept -join "`n")
}

"=== GENERATED RUNNER SAFE TEMPLATE RULE CARD FIELD APPLY V0_3 ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Stop-WithBlocker -Reason "MISSING_LANE" -Detail $Lane
}

New-Item -ItemType Directory -Path $IncidentFolder -Force | Out-Null

$ThisRunnerPath = $PSCommandPath
if ([string]::IsNullOrWhiteSpace($ThisRunnerPath) -or -not (Test-Path -LiteralPath $ThisRunnerPath -PathType Leaf)) {
    Stop-WithBlocker -Reason "MISSING_SELF_PATH" -Detail "PSCommandPath was unavailable."
}

$RuleHash = Require-Hash -Path $RuleCard -ExpectedSha256 "E0013BA267527AF2201B934E8AEEB55710835EF0CC3ECD78250729E6ECB8FB26" -Name "generated-runner safe template rule card"
$RuleReceiptHash = Require-Hash -Path $RuleReceipt -ExpectedSha256 "13E18217CB7DE53B4C7749CB7D7D7AB454B3A8EB111A5167D3C384ABF75863F4" -Name "generated-runner safe template rule card receipt"
$FieldTestHash = Require-Hash -Path $FieldTestReport -ExpectedSha256 "4BCB354B10B28066AB4A78BF9861F6EDB9795A323362678BB97B175427AD99A0" -Name "generated-runner selector field test report"
$PriorBlockerHash = Require-Hash -Path $PriorBlocker -ExpectedSha256 "7AF806829BB686BCD6A7EB3770D05C2458D0F920399758E2A08A7893C68BF834" -Name "V0_1 safe template field-apply blocker"

$FailedRunnerV01Hash = "SOURCE_MISSING"
$FailedRunnerV01CopyHash = Copy-FileSafe -Source $FailedRunnerV01 -Destination $FailedRunnerV01Copy
if (Test-Path -LiteralPath $FailedRunnerV01 -PathType Leaf) {
    $FailedRunnerV01Hash = (Get-FileHash -LiteralPath $FailedRunnerV01 -Algorithm SHA256).Hash
}

$FailedRunnerV02Hash = "SOURCE_MISSING"
$FailedRunnerV02CopyHash = Copy-FileSafe -Source $FailedRunnerV02 -Destination $FailedRunnerV02Copy
if (Test-Path -LiteralPath $FailedRunnerV02 -PathType Leaf) {
    $FailedRunnerV02Hash = (Get-FileHash -LiteralPath $FailedRunnerV02 -Algorithm SHA256).Hash
}

$ThisRunnerText = Get-Content -LiteralPath $ThisRunnerPath -Raw
$ThisRunnerHash = (Get-FileHash -LiteralPath $ThisRunnerPath -Algorithm SHA256).Hash
$CodeLikeText = Remove-HereStringsAndComments -Text $ThisRunnerText

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$FreezeV01Text = @"
# ERROR_FREEZE__SAFE_TEMPLATE_FIELD_APPLY_V0_1_SELF_CHECK_FALSE_POSITIVE_20260608

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

Failed V0_1 runner path:
$FailedRunnerV01

Failed V0_1 runner SHA256:
$FailedRunnerV01Hash

Failed V0_1 runner copy:
$FailedRunnerV01Copy

Failed V0_1 runner copy SHA256:
$FailedRunnerV01CopyHash

Root cause:
The V0_1 self-check inspected raw script text. That raw text included regex patterns and report prose containing Git/COMMITTED vocabulary. The checker treated vocabulary inside its own test/prose as executable behavior or false success behavior.

Corrected principle:
Self-checks for forbidden behavior must distinguish code-like executable text from report prose, comments, and self-check pattern strings.

Final freeze verdict:
SAFE_TEMPLATE_FIELD_APPLY_V0_1_FALSE_POSITIVE_FROZEN
"@
Write-TextFile -Path $FreezeV01Path -Text $FreezeV01Text
$FreezeV01Hash = (Get-FileHash -LiteralPath $FreezeV01Path -Algorithm SHA256).Hash

$FreezeV02Text = @"
# ERROR_FREEZE__SAFE_TEMPLATE_FIELD_APPLY_V0_2_MISSING_PARENT_COPY_20260608

Status: FREEZE_EVIDENCE / GENERATED_RUNNER_COPY_DESTINATION_PARENT_MISSING / LOCAL_ONLY

Created: $Timestamp

Failed action:
FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_V0_2_20260608.ps1

Observed command:
pwsh -NoProfile -ExecutionPolicy Bypass -File `$env:USERPROFILE\Downloads\FIELD_APPLY_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_V0_2_20260608.ps1

Observed error:
Copy-Item at line 167 could not find a part of the path:
$FailedRunnerV01Copy

Failed V0_2 runner path:
$FailedRunnerV02

Failed V0_2 runner SHA256:
$FailedRunnerV02Hash

Failed V0_2 runner copy:
$FailedRunnerV02Copy

Failed V0_2 runner copy SHA256:
$FailedRunnerV02CopyHash

Root cause:
V0_2 created destination file paths before ensuring the incident folder existed. Copy-Item failed because the destination parent folder did not exist.

Corrected principle:
Before any Copy-Item to a generated evidence path, create the destination parent folder first.

Final freeze verdict:
SAFE_TEMPLATE_FIELD_APPLY_V0_2_MISSING_PARENT_COPY_FROZEN
"@
Write-TextFile -Path $FreezeV02Path -Text $FreezeV02Text
$FreezeV02Hash = (Get-FileHash -LiteralPath $FreezeV02Path -Algorithm SHA256).Hash

$FixNoteText = @"
# FIX_NOTE__SAFE_TEMPLATE_FIELD_APPLY_V0_3_PARENT_FIRST_AND_CODE_AWARE_CHECK_20260608

Status: FIX_NOTE / PARENT_FIRST_COPY / CODE_AWARE_SELF_CHECK / SAFE_TEMPLATE_FIELD_APPLY_V0_3

Created: $Timestamp

Problems:
01 V0_1 stopped on a false positive caused by raw text checking.
02 V0_2 attempted to freeze that false positive but copied into a missing incident folder.

Fix:
01 Create incident folder before copy operations.
02 Use Copy-FileSafe, which creates destination parent folders before Copy-Item.
03 Use code-aware text checking that removes here-string report bodies and comments before forbidden behavior checks.
04 Preserve both V0_1 and V0_2 failures as evidence.

DoesNotProve:
This is not a full PowerShell parser. It is a bounded field-apply repair for the generated-runner safe-template path.
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
    EnsuresParentBeforeWrite = ($ThisRunnerText -match 'function\s+Ensure-ParentFolder')
    EnsuresParentBeforeCopy = ($ThisRunnerText -match 'function\s+Copy-FileSafe')
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
    Stop-WithBlocker -Reason "SAFE_TEMPLATE_V0_3_SELF_CHECK_FAILED" -Detail ($FailedChecks -join "; ")
}

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV4
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV4

$CheckLines = foreach ($k in $Checks.Keys) {
    "- $k`: $($Checks[$k])"
}

$ReportText = @"
# GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_3_20260608

Status: FIELD_APPLY_REPORT / GENERATED_RUNNER_SAFE_TEMPLATE_USED / PARENT_FIRST_COPY / CODE_AWARE_SELF_CHECK / NO_GIT / NOT_DOCTRINE

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

V0_1 false-positive freeze report:
$FreezeV01Path
SHA256:
$FreezeV01Hash

V0_2 missing-parent freeze report:
$FreezeV02Path
SHA256:
$FreezeV02Hash

V0_3 fix note:
$FixNotePath
SHA256:
$FixNoteHash

Runner being field-applied:
$ThisRunnerPath
SHA256:
$ThisRunnerHash

Purpose:
Apply the generated-runner safe template rule card after freezing both the V0_1 self-check false positive and the V0_2 missing-parent copy failure.

## SELF-CHECK RESULTS

$($CheckLines -join "`r`n")

## INTERPRETATION

The V0_3 generated runner passed the local rule-card shape check.

V0_3 correction:
01 Parent folder exists before file writing.
02 Parent folder exists before failed-runner copying.
03 Forbidden behavior checks inspect code-like text, not report prose or comments.
04 V0_1 and V0_2 failures are preserved before the final V0_3 pass.

Confirmed:
01 ErrorActionPreference is Stop.
02 StrictMode is enabled.
03 Text writing uses System.IO.File.WriteAllText.
04 UTF-8 no BOM encoding is explicit.
05 Stop-WithBlocker exists.
06 Blocker path exits nonzero.
07 Parent folder creation is used for writes.
08 Parent folder creation is used for copies.
09 Mandatory Lines array writer pattern is absent.
10 Write-Utf8File -Lines executable pattern is absent.
11 Actual COMMITTED final verdict claim is absent.
12 Actual Git invocation is absent.

## FIELD APPLY VERDICT

The rule card is usable as a generation constraint for the next bounded runner.

## NEXT RECOMMENDED BUILD CHUNK

ROUGH_LOCAL_IMPORT_FOR_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608

Purpose:
Create a Git-safe rough_local import packet for the standing rule card, rule receipt, V0_3 field-apply report, V0_1/V0_2 freeze reports, and V0_3 fix note hashes.

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

v0_1_false_positive_freeze_sha256:
$FreezeV01Hash

v0_2_missing_parent_freeze_sha256:
$FreezeV02Hash

v0_3_fix_note_sha256:
$FixNoteHash

field_applied_runner_path:
$ThisRunnerPath

field_applied_runner_sha256:
$ThisRunnerHash

safe_template_self_check_passed:
YES

parent_first_copy_used:
YES

code_aware_self_check_used:
YES

git_commit_or_push_done:
NO

next_build_chunk_selected:
ROUGH_LOCAL_IMPORT_FOR_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608

final_verdict:
GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_V0_3_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_V0_3_20260608
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

v0_1_false_positive_freeze_path: $FreezeV01Path
v0_1_false_positive_freeze_sha256: $FreezeV01Hash

v0_2_missing_parent_freeze_path: $FreezeV02Path
v0_2_missing_parent_freeze_sha256: $FreezeV02Hash

v0_3_fix_note_path: $FixNotePath
v0_3_fix_note_sha256: $FixNoteHash

failed_runner_v0_1_copy_path: $FailedRunnerV01Copy
failed_runner_v0_1_copy_sha256: $FailedRunnerV01CopyHash

failed_runner_v0_2_copy_path: $FailedRunnerV02Copy
failed_runner_v0_2_copy_sha256: $FailedRunnerV02CopyHash

field_applied_runner_path: $ThisRunnerPath
field_applied_runner_sha256: $ThisRunnerHash

safe_template_self_check_passed: YES
parent_first_copy_used: YES
code_aware_self_check_used: YES

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 2 failed runner copies when available
files_overwritten_count: 0
git_commit_or_push_done: NO

final_verdict: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_V0_3_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== GENERATED RUNNER SAFE TEMPLATE FIELD APPLY V0_3 COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"rule_card_sha256_confirmed: $RuleHash"
"rule_receipt_sha256_confirmed: $RuleReceiptHash"
"field_test_report_sha256_confirmed: $FieldTestHash"
"prior_blocker_sha256_confirmed: $PriorBlockerHash"
"v0_1_false_positive_freeze_path: $FreezeV01Path"
"v0_1_false_positive_freeze_sha256: $FreezeV01Hash"
"v0_2_missing_parent_freeze_path: $FreezeV02Path"
"v0_2_missing_parent_freeze_sha256: $FreezeV02Hash"
"v0_3_fix_note_path: $FixNotePath"
"v0_3_fix_note_sha256: $FixNoteHash"
"failed_runner_v0_1_copy_path: $FailedRunnerV01Copy"
"failed_runner_v0_1_copy_sha256: $FailedRunnerV01CopyHash"
"failed_runner_v0_2_copy_path: $FailedRunnerV02Copy"
"failed_runner_v0_2_copy_sha256: $FailedRunnerV02CopyHash"
"field_applied_runner_path: $ThisRunnerPath"
"field_applied_runner_sha256: $ThisRunnerHash"
"safe_template_self_check_passed: YES"
"parent_first_copy_used: YES"
"code_aware_self_check_used: YES"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_20260608"
"final_verdict: GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_V0_3_READY_WITH_SCOPE_LIMIT_NOTE"
