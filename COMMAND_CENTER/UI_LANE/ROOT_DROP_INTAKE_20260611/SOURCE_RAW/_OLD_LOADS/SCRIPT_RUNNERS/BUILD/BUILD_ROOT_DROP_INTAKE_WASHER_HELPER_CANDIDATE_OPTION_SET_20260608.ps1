$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$HelperReviewReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$HelperReviewReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$HelperCardsFolder = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_CARDS_20260608"
$QueueSummary = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608.md"
$QueueSummaryReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_RECEIPT_20260608.txt"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$OutputV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_V0_2_20260608.txt"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the helper review failed. It proves this bounded helper-candidate option-set runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER HELPER CANDIDATE OPTION SET BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_NOT_COMPLETE"
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

function Get-Field {
    param(
        [string]$Text,
        [string]$FieldName
    )

    $escaped = [regex]::Escape($FieldName)
    $pattern = "(?ms)^$escaped\s*:\s*\r?\n(?<value>.*?)(?=\r?\n[A-Za-z0-9_ -]+:\s*\r?\n|\r?\nblocked_actions:|\r?\nproof_need:|\r?\nDoesNotProve:|\z)"
    $m = [regex]::Match($Text, $pattern)
    if (-not $m.Success) {
        return ""
    }

    return $m.Groups["value"].Value.Trim()
}

"=== ROOT DROP INTAKE WASHER HELPER CANDIDATE OPTION SET ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$HelperReviewHash = Require-Hash -Path $HelperReviewReport -ExpectedSha256 "6F790D59EE2BDD05ABCEF99F4292EFEDAE58FEA64B3A28C3AB2BC41E950E5188" -Name "helper candidate review dry-run report"
$HelperReviewReceiptHash = Require-Hash -Path $HelperReviewReceipt -ExpectedSha256 "748B06757515A20C8C07974BC856EF1762B1AB81127196819742557E81976FE7" -Name "helper candidate review dry-run receipt"
$QueueSummaryHash = Require-Hash -Path $QueueSummary -ExpectedSha256 "BD659A643AE3865FAB2FCEB0DC7C1700BBE4EF4F26D3803C6E0FB52127D61869" -Name "queue summary/option set"
$QueueSummaryReceiptHash = Require-Hash -Path $QueueSummaryReceipt -ExpectedSha256 "B43450672DF855F495B7492FD5DEA15961493EF1EC5C6BD12D8545DD2A7EE8FF" -Name "queue summary/option set receipt"

if (-not (Test-Path -LiteralPath $HelperCardsFolder -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_HELPER_REVIEW_CARDS_FOLDER" -Detail $HelperCardsFolder
}

$CardFiles = @(Get-ChildItem -LiteralPath $HelperCardsFolder -Force -File -Filter "*.md" | Sort-Object Name)
if ($CardFiles.Count -ne 7) {
    Write-BlockerAndExit -Reason "HELPER_REVIEW_CARD_COUNT_MISMATCH" -Detail "actual=$($CardFiles.Count) expected=7 folder=$HelperCardsFolder"
}

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$Items = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($card in $CardFiles) {
    $index += 1
    $text = Get-Content -LiteralPath $card.FullName -Raw
    $cardHash = (Get-FileHash -LiteralPath $card.FullName -Algorithm SHA256).Hash

    $observedPath = Get-Field -Text $text -FieldName "observed_path"
    $observedSha = Get-Field -Text $text -FieldName "observed_sha256"
    $sizeBytes = Get-Field -Text $text -FieldName "observed_size_bytes"
    $versionSignal = Get-Field -Text $text -FieldName "version_signal"
    $riskClass = Get-Field -Text $text -FieldName "helper_risk_class"
    $suggestedDisposition = Get-Field -Text $text -FieldName "suggested_disposition"
    $dryRunReason = Get-Field -Text $text -FieldName "dry_run_reason"

    if ([string]::IsNullOrWhiteSpace($observedPath)) {
        Write-BlockerAndExit -Reason "CARD_PARSE_FAILED" -Detail "Missing observed_path in $($card.FullName)"
    }

    if (-not (Test-Path -LiteralPath $observedPath -PathType Leaf)) {
        Write-BlockerAndExit -Reason "OBSERVED_HELPER_MISSING" -Detail $observedPath
    }

    $actualHash = (Get-FileHash -LiteralPath $observedPath -Algorithm SHA256).Hash
    if ($actualHash -ne $observedSha) {
        Write-BlockerAndExit -Reason "OBSERVED_HELPER_HASH_DRIFT" -Detail "path=$observedPath actual=$actualHash expected=$observedSha"
    }

    $option = "OPTION_DEEPER_REVIEW_NEEDED"
    $finalRecommendation = "Keep read-only until reviewed."
    $executionStatus = "DO_NOT_EXECUTE"

    if ($riskClass -eq "SAFE_TEMPLATE_SHAPE_CANDIDATE") {
        $option = "OPTION_POSSIBLE_CURRENT_RUNNABLE_CANDIDATE"
        $finalRecommendation = "Keep as possible current helper candidate, but require command review before any execution."
    }
    elseif ($riskClass -eq "UNSAFE_OR_FAILURE_EVIDENCE_CANDIDATE") {
        $option = "OPTION_EVIDENCE_ONLY_OR_SUPERSEDED"
        $finalRecommendation = "Keep as local evidence/superseded helper candidate. Do not run."
    }
    elseif ($riskClass -eq "GIT_TOUCHING_HELPER_CANDIDATE") {
        $option = "OPTION_GIT_TOUCHING_REVIEW_ONLY"
        $finalRecommendation = "Do not run unless exact staged-set review and Git authority exist."
    }
    elseif ($riskClass -eq "FILE_MUTATION_HELPER_CANDIDATE") {
        $option = "OPTION_MUTATION_REVIEW_ONLY"
        $finalRecommendation = "Do not run unless mutation authority and before/after receipt plan exist."
    }
    elseif ($riskClass -eq "STALE_LINE_WRITER_PATTERN_CANDIDATE") {
        $option = "OPTION_STALE_RUNNER_EVIDENCE"
        $finalRecommendation = "Treat as stale/failure-family evidence unless later proven otherwise. Do not run."
    }

    $Items.Add([pscustomobject]@{
        Index = $index
        ObservedPath = $observedPath
        ObservedSha = $observedSha
        SizeBytes = $sizeBytes
        VersionSignal = $versionSignal
        RiskClass = $riskClass
        SuggestedDisposition = $suggestedDisposition
        Option = $option
        FinalRecommendation = $finalRecommendation
        ExecutionStatus = $executionStatus
        DryRunReason = $dryRunReason
        ReviewCardPath = $card.FullName
        ReviewCardSha256 = $cardHash
    })
}

$OptionGroups = $Items | Group-Object Option | Sort-Object Name
$OptionCountLines = foreach ($g in $OptionGroups) {
    "- $($g.Name): $($g.Count)"
}

$RiskGroups = $Items | Group-Object RiskClass | Sort-Object Name
$RiskCountLines = foreach ($g in $RiskGroups) {
    "- $($g.Name): $($g.Count)"
}

$ItemBlocks = foreach ($item in $Items) {
    @"
## HELPER_OPTION_ITEM_$("{0:D2}" -f $item.Index)

observed_path:
$($item.ObservedPath)

observed_sha256:
$($item.ObservedSha)

observed_size_bytes:
$($item.SizeBytes)

version_signal:
$($item.VersionSignal)

helper_risk_class:
$($item.RiskClass)

suggested_disposition_from_review:
$($item.SuggestedDisposition)

option_bucket:
$($item.Option)

final_recommendation:
$($item.FinalRecommendation)

execution_status:
$($item.ExecutionStatus)

dry_run_reason:
$($item.DryRunReason)

review_card_path:
$($item.ReviewCardPath)

review_card_sha256:
$($item.ReviewCardSha256)

DoesNotProve:
This helper option item does not prove the helper is safe, current, stale, superseded, executable, Git-safe, cleanup-safe, doctrine, active guide, current truth, or project complete.

"@
}

$CurrentCandidateLines = foreach ($item in ($Items | Where-Object { $_.Option -eq "OPTION_POSSIBLE_CURRENT_RUNNABLE_CANDIDATE" })) {
    "- $($item.ObservedPath)"
}

$EvidenceOnlyLines = foreach ($item in ($Items | Where-Object { $_.Option -eq "OPTION_EVIDENCE_ONLY_OR_SUPERSEDED" -or $_.Option -eq "OPTION_STALE_RUNNER_EVIDENCE" })) {
    "- $($item.ObservedPath)"
}

if ($CurrentCandidateLines.Count -eq 0) {
    $CurrentCandidateLines = @("- NONE")
}

if ($EvidenceOnlyLines.Count -eq 0) {
    $EvidenceOnlyLines = @("- NONE")
}

$OptionSetText = @"
# ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608

Status: HELPER_CANDIDATE_OPTION_SET / READ_ONLY / DO_NOT_EXECUTE / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Source helper review report:
$HelperReviewReport

Source helper review report SHA256:
$HelperReviewHash

Source helper review receipt:
$HelperReviewReceipt

Source helper review receipt SHA256:
$HelperReviewReceiptHash

Source helper cards folder:
$HelperCardsFolder

Source queue summary:
$QueueSummary

Source queue summary SHA256:
$QueueSummaryHash

Source queue summary receipt:
$QueueSummaryReceipt

Source queue summary receipt SHA256:
$QueueSummaryReceiptHash

Purpose:
Condense the 7 helper candidate review cards into a small option set.

This option set does not execute, move, delete, route, stage, commit, push, or promote any helper.

## OPTION COUNTS

$($OptionCountLines -join "`r`n")

## RISK COUNTS

$($RiskCountLines -join "`r`n")

## POSSIBLE CURRENT RUNNABLE CANDIDATES

$($CurrentCandidateLines -join "`r`n")

Boundary:
These are not approved to run. They are only possible current helper candidates. They still require exact command review, expected output, blocker behavior, and authority check before execution.

## EVIDENCE ONLY / SUPERSEDED CANDIDATES

$($EvidenceOnlyLines -join "`r`n")

Boundary:
These should not be run. Keep as local evidence or superseded helper candidates unless a later review proves otherwise.

## HELPER OPTION ITEMS

$($ItemBlocks -join "`r`n")

## RECOMMENDED NEXT MOVE

Recommended:
ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608

Reason:
The helper option set is useful as hash-truth, but the full helper files and cards should remain local. Git should receive rough_local pointer material only unless explicitly approved.

## STILL BLOCKED

- execute any helper
- move files
- delete files
- rename files
- route files
- cleanup
- stage full root files
- commit full root files
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

## DOESNOTPROVE

This option set does not prove any helper is safe, current, stale, superseded, executable, Git-safe, cleanup-safe, doctrine, active guide, current truth, or project complete.

## FINAL RETURN FIELDS

option_set_path:
$OutputPath

option_set_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

helper_review_report_sha256_confirmed:
$HelperReviewHash

helper_review_receipt_sha256_confirmed:
$HelperReviewReceiptHash

queue_summary_sha256_confirmed:
$QueueSummaryHash

queue_summary_receipt_sha256_confirmed:
$QueueSummaryReceiptHash

helper_candidates_reviewed:
$($Items.Count)

possible_current_runnable_candidates_count:
$(($Items | Where-Object { $_.Option -eq "OPTION_POSSIBLE_CURRENT_RUNNABLE_CANDIDATE" }).Count)

evidence_only_or_superseded_count:
$(($Items | Where-Object { $_.Option -eq "OPTION_EVIDENCE_ONLY_OR_SUPERSEDED" -or $_.Option -eq "OPTION_STALE_RUNNER_EVIDENCE" }).Count)

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
0

git_commit_or_push_done:
NO

next_build_chunk_selected:
ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $OptionSetText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_20260608
Created: $Timestamp

option_set_path: $OutputPath
option_set_sha256: $OutputHash

helper_review_report_sha256: $HelperReviewHash
helper_review_receipt_sha256: $HelperReviewReceiptHash
queue_summary_sha256: $QueueSummaryHash
queue_summary_receipt_sha256: $QueueSummaryReceiptHash

helper_candidates_reviewed: $($Items.Count)
possible_current_runnable_candidates_count: $(($Items | Where-Object { $_.Option -eq "OPTION_POSSIBLE_CURRENT_RUNNABLE_CANDIDATE" }).Count)
evidence_only_or_superseded_count: $(($Items | Where-Object { $_.Option -eq "OPTION_EVIDENCE_ONLY_OR_SUPERSEDED" -or $_.Option -eq "OPTION_STALE_RUNNER_EVIDENCE" }).Count)

option_counts:
$($OptionCountLines -join "`r`n")

risk_counts:
$($RiskCountLines -join "`r`n")

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
scripts_executed_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$OptionSetText = $OptionSetText.Replace("option_set_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "option_set_sha256:`r`n$OutputHash")
$OptionSetText = $OptionSetText.Replace("option_set_sha256:`nTO_BE_FILLED_AFTER_CREATION", "option_set_sha256:`n$OutputHash")
$OptionSetText = $OptionSetText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$OptionSetText = $OptionSetText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $OptionSetText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER HELPER CANDIDATE OPTION SET COMPLETE ==="
"option_set_path: $OutputPath"
"option_set_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"helper_review_report_sha256_confirmed: $HelperReviewHash"
"helper_review_receipt_sha256_confirmed: $HelperReviewReceiptHash"
"queue_summary_sha256_confirmed: $QueueSummaryHash"
"queue_summary_receipt_sha256_confirmed: $QueueSummaryReceiptHash"
"helper_candidates_reviewed: $($Items.Count)"
"possible_current_runnable_candidates_count: $(($Items | Where-Object { $_.Option -eq "OPTION_POSSIBLE_CURRENT_RUNNABLE_CANDIDATE" }).Count)"
"evidence_only_or_superseded_count: $(($Items | Where-Object { $_.Option -eq "OPTION_EVIDENCE_ONLY_OR_SUPERSEDED" -or $_.Option -eq "OPTION_STALE_RUNNER_EVIDENCE" }).Count)"
"option_counts:"
$OptionCountLines
"risk_counts:"
$RiskCountLines
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE"
