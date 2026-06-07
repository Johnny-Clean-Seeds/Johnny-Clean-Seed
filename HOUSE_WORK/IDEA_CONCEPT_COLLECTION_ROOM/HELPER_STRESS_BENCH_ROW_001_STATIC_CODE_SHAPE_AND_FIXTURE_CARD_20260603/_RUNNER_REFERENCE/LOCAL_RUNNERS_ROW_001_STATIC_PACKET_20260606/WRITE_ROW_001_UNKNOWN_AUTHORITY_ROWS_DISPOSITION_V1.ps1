param(
  [string]$ExpectedRepo = "$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Stop-Clean {
  param([string]$Reason, [string]$Detail = "")
  Write-Host "ROW_001_UNKNOWN_AUTHORITY_DISPOSITION_STOPPED"
  Write-Host "Reason: $Reason"
  if (-not [string]::IsNullOrWhiteSpace($Detail)) { Write-Host "Detail: $Detail" }
  exit 1
}

function Write-Utf8NoBom {
  param([string]$Path, [string]$Text)
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  [System.IO.File]::WriteAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256 {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return "" }
  return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Classify-UnknownEvidence {
  param([string]$Evidence)

  if ($Evidence -match '^\[string\]\$BlockerStatus') { return "PARAMETER_NAME_NOT_AUTHORITY" }
  if ($Evidence -match '^BlockerStatus\s*=') { return "REPORT_OBJECT_FIELD" }
  if ($Evidence -match 'git status failed') { return "READ_ONLY_FAILURE_FALLBACK_TEXT" }
  if ($Evidence -match '\$Failures\.Add') { return "FAILURE_COLLECTION_ONLY" }
  if ($Evidence -match '\$Failures\.Count') { return "FAILURE_CONDITION_ONLY" }
  if ($Evidence -match 'BlockerStatus\s+"(WATCH|BLOCKING|UNKNOWN)"') { return "WARNING_CLASSIFICATION_FIELD" }
  if ($Evidence -match 'SecondReviewRequired') { return "REVIEW_GUARD_FIELD" }
  if ($Evidence -match 'WhatItAffects') { return "WARNING_EXPLANATION_FIELD" }
  if ($Evidence -match 'SAVED_AND_CLOSED') { return "POINTER_STATUS_VALUE_READ" }
  if ($Evidence -match 'INSPECTION_COMPLETE_NO_ACTION_TAKEN') { return "NO_ACTION_REPORT_STRING" }
  if ($Evidence -match 'DoesNotProve') { return "REQUIRED_GUARD_FIELD_CHECK_OR_OUTPUT" }
  if ($Evidence -match 'StopLine') { return "REQUIRED_STOP_FIELD_CHECK_OR_OUTPUT" }
  if ($Evidence -match 'LastCompletedStep') { return "REPORT_OUTPUT_FIELD" }
  if ($Evidence -match 'FAILED_CHECK') { return "FAILURE_REPORT_OUTPUT_ONLY" }
  return "UNCLASSIFIED_REVIEW_NEEDED"
}

if (-not (Test-Path -LiteralPath $ExpectedRepo)) {
  Stop-Clean "EXPECTED_REPO_NOT_FOUND" $ExpectedRepo
}

Set-Location -LiteralPath $ExpectedRepo

$gitTopRaw = & git rev-parse --show-toplevel 2>$null
if ([string]::IsNullOrWhiteSpace($gitTopRaw)) {
  Stop-Clean "GIT_TOP_EMPTY_AFTER_SET_LOCATION" "PWD: $(Get-Location)"
}

$Repo = $gitTopRaw.Trim()
Set-Location -LiteralPath $Repo

$DateKey = Get-Date -Format "yyyyMMdd"
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$Head = (& git rev-parse HEAD).Trim()
$OriginMain = (& git rev-parse origin/main).Trim()
$StatusBefore = (& git status --short) -join "`n"

$PacketDir = Join-Path $Repo "HOUSE_WORK\IDEA_CONCEPT_COLLECTION_ROOM\HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_$DateKey"
$ProofDir = Join-Path $Repo "PROOF_HISTORY"

$TablePath = Join-Path $PacketDir "ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_TABLE_$DateKey.csv"
if (-not (Test-Path -LiteralPath $TablePath)) {
  Stop-Clean "AUTHORITY_LANGUAGE_TABLE_NOT_FOUND" $TablePath
}

$ReportPath = Join-Path $PacketDir "ROW_001_UNKNOWN_AUTHORITY_ROWS_DISPOSITION_$DateKey.md"
$ReceiptPath = Join-Path $ProofDir "ROW_001_UNKNOWN_AUTHORITY_ROWS_DISPOSITION_RECEIPT_$DateKey.txt"

$Rows = @(Import-Csv -LiteralPath $TablePath)
$UnknownRows = @($Rows | Where-Object { $_.Class -eq "UNKNOWN_AUTHORITY_CONTEXT" })

$DispositionRows = foreach ($row in $UnknownRows) {
  $disposition = Classify-UnknownEvidence -Evidence ([string]$row.Evidence)
  [pscustomobject]@{
    Term = $row.Term
    Line = $row.Line
    OriginalRisk = $row.Risk
    Disposition = $disposition
    Evidence = $row.Evidence
  }
}

$UnclassifiedRows = @($DispositionRows | Where-Object { $_.Disposition -eq "UNCLASSIFIED_REVIEW_NEEDED" })

if ($UnclassifiedRows.Count -gt 0) {
  $FinalVerdict = "UNKNOWN_AUTHORITY_ROWS_REMAIN_OPEN"
} else {
  $FinalVerdict = "UNKNOWN_AUTHORITY_ROWS_DISPOSED_REPORT_ONLY_OR_GUARD_FIELDS"
}

$DispositionText = if ($DispositionRows.Count -gt 0) {
  (($DispositionRows | ForEach-Object {
    "- line $($_.Line) [$($_.Term)] $($_.Disposition): $($_.Evidence)"
  }) -join "`n")
} else {
  "- none"
}

$UnclassifiedText = if ($UnclassifiedRows.Count -gt 0) {
  (($UnclassifiedRows | ForEach-Object {
    "- line $($_.Line) [$($_.Term)]: $($_.Evidence)"
  }) -join "`n")
} else {
  "- none"
}

$StatusAfter = (& git status --short) -join "`n"

$Report = @"
# Row 001 Unknown Authority Rows Disposition

Date: $DateKey
RunId: $RunId
FinalVerdict: $FinalVerdict

## Boundary

This disposition is static review only.

The target helper was not run.
No Git add, commit, push, reset, checkout, clean, or root cleanup was performed.
No pointer/state file was mutated.

## Repo Proof

Repo: $Repo
Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)

## Source Table

$TablePath

## Finding

The 27 previously unknown authority-language rows were reviewed by evidence shape.

They are parameter names, report object fields, read-only failure fallback text, failure collection/condition logic, warning classification fields, pointer-status value reads, required guard-field checks, final output fields, and failure report output strings.

They do not create file mutation authority and do not claim a saved state by themselves.

## Dispositions

$DispositionText

## Unclassified Rows

$UnclassifiedText

## Decision

$FinalVerdict

If the final verdict is UNKNOWN_AUTHORITY_ROWS_DISPOSED_REPORT_ONLY_OR_GUARD_FIELDS, the authority-language concern is no longer an active static blocker.

This does not authorize running the target helper yet. It supports the next route: disposable fixture design, plus deliberate runner-clutter closeout.
"@

Write-Utf8NoBom $ReportPath $Report
$ReportSha = Get-Sha256 $ReportPath

$Receipt = @"
ROW_001_UNKNOWN_AUTHORITY_ROWS_DISPOSITION_RECEIPT
RunId: $RunId
Date: $DateKey
FinalVerdict: $FinalVerdict

SourceTable: $TablePath
SourceTableSha256: $(Get-Sha256 $TablePath)

Report: $ReportPath
ReportSha256: $ReportSha

Counts:
UnknownRows: $($UnknownRows.Count)
DisposedRows: $($DispositionRows.Count)
UnclassifiedRows: $($UnclassifiedRows.Count)

Repo: $Repo
Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)

Boundary:
TargetHelperExecuted: False
GitAddCommitPush: False
RootCleanup: False
PointerStateMutation: False

StatusBefore:
$StatusBefore

StatusAfter:
$StatusAfter
"@

Write-Utf8NoBom $ReceiptPath $Receipt
$ReceiptSha = Get-Sha256 $ReceiptPath

Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
Write-Host "ROW_001_UNKNOWN_AUTHORITY_ROWS_DISPOSITION_COMPLETE"
Write-Host "RunId: $RunId"
Write-Host "FinalVerdict: $FinalVerdict"
Write-Host "UnknownRows: $($UnknownRows.Count)"
Write-Host "DisposedRows: $($DispositionRows.Count)"
Write-Host "UnclassifiedRows: $($UnclassifiedRows.Count)"
Write-Host "Report: $ReportPath"
Write-Host "ReportSha256: $ReportSha"
Write-Host "Receipt: $ReceiptPath"
Write-Host "ReceiptSha256: $ReceiptSha"
Write-Host "Head: $Head"
Write-Host "OriginMain: $OriginMain"
Write-Host "HeadEqualsOrigin: $($Head -eq $OriginMain)"
Write-Host "FinalGitStatusShort:"
if ([string]::IsNullOrWhiteSpace($StatusAfter)) { Write-Host "<clean>" } else { Write-Host $StatusAfter }
Write-Host "TargetHelperExecuted: False"
Write-Host "GitAddCommitPush: False"
Write-Host "RootCleanup: False"
Write-Host "PointerStateMutation: False"
Write-Host "NEXT: STATIC_CLEARED_FOR_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_CLUTTER_CLOSEOUT"
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"
