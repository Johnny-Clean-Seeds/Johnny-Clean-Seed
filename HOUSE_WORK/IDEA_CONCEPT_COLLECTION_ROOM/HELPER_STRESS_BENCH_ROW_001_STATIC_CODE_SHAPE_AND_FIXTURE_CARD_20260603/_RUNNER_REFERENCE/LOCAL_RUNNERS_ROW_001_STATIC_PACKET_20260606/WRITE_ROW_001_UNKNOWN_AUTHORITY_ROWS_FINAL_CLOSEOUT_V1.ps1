param(
  [string]$ExpectedRepo = "$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Stop-Clean {
  param([string]$Reason, [string]$Detail = "")
  Write-Host "ROW_001_UNKNOWN_AUTHORITY_FINAL_CLOSEOUT_STOPPED"
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

function Csv-Escape {
  param([object]$Value)
  $s = [string]$Value
  if ($s -match '[,"\r\n]') { return '"' + ($s -replace '"','""') + '"' }
  return $s
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

$DispositionReportPath = Join-Path $PacketDir "ROW_001_UNKNOWN_AUTHORITY_ROWS_DISPOSITION_$DateKey.md"
$AuthorityTablePath = Join-Path $PacketDir "ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_TABLE_$DateKey.csv"

if (-not (Test-Path -LiteralPath $DispositionReportPath)) {
  Stop-Clean "DISPOSITION_REPORT_NOT_FOUND" $DispositionReportPath
}

if (-not (Test-Path -LiteralPath $AuthorityTablePath)) {
  Stop-Clean "AUTHORITY_TABLE_NOT_FOUND" $AuthorityTablePath
}

$ReportPath = Join-Path $PacketDir "ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_$DateKey.md"
$TablePath = Join-Path $PacketDir "ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_TABLE_$DateKey.csv"
$ReceiptPath = Join-Path $ProofDir "ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_RECEIPT_$DateKey.txt"

$DispositionReportText = Get-Content -LiteralPath $DispositionReportPath -Raw
$AuthorityRows = @(Import-Csv -LiteralPath $AuthorityTablePath)
$UnknownRows = @($AuthorityRows | Where-Object { $_.Class -eq "UNKNOWN_AUTHORITY_CONTEXT" })

$OpenRows = @(
  [pscustomobject]@{
    Line="297"
    Term="LOCK"
    Evidence='} elseif ($UnknownWarnings.Count -gt 0 -or $BlockingWarnings.Count -gt 0) {'
    Disposition="WARNING_BLOCKER_CONDITION_CHECK"
    WhySafe="This line checks warning collections to stop or route separately. It does not lock, save, mutate, or authorize execution."
  },
  [pscustomobject]@{
    Line="342"
    Term="LOCK"
    Evidence='$WarningExplanationLines.Add("BlockerStatus: $($Warning.BlockerStatus)") | Out-Null'
    Disposition="WARNING_EXPLANATION_OUTPUT_FIELD"
    WhySafe="This line writes a warning explanation into an in-memory output list. It does not write files or create authority."
  },
  [pscustomobject]@{
    Line="357"
    Term="LOCK"
    Evidence='} elseif ($UnknownWarnings.Count -gt 0 -or $BlockingWarnings.Count -gt 0) {'
    Disposition="FINAL_VERDICT_WARNING_BLOCKER_CONDITION_CHECK"
    WhySafe="This line routes the final verdict to WATCH_STOP when unknown or blocking warnings exist. It is a stop guard, not authority escalation."
  }
)

$MissingExpected = New-Object System.Collections.Generic.List[string]
foreach ($row in $OpenRows) {
  $match = @($UnknownRows | Where-Object { [string]$_.Line -eq [string]$row.Line -and [string]$_.Term -eq [string]$row.Term })
  if ($match.Count -lt 1) {
    $MissingExpected.Add(("Expected open row not found in authority table: line {0} term {1}" -f $row.Line, $row.Term)) | Out-Null
  }
}

$HasOpenVerdict = $DispositionReportText -match 'UNKNOWN_AUTHORITY_ROWS_REMAIN_OPEN'
$HasBadNext = $DispositionReportText -match 'STATIC_CLEARED_FOR_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_CLUTTER_CLOSEOUT'

$Blockers = New-Object System.Collections.Generic.List[string]
if ($MissingExpected.Count -gt 0) {
  foreach ($m in $MissingExpected) { $Blockers.Add($m) | Out-Null }
}

if (-not $HasOpenVerdict) {
  $Blockers.Add("Prior disposition report did not contain UNKNOWN_AUTHORITY_ROWS_REMAIN_OPEN; this closeout may be pointed at the wrong report.") | Out-Null
}

$FinalVerdict = if ($Blockers.Count -gt 0) {
  "UNKNOWN_AUTHORITY_FINAL_CLOSEOUT_BLOCKED"
} else {
  "UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSED_REPORT_ONLY_OR_GUARD_FIELDS"
}

$Table = "Line,Term,Disposition,WhySafe,Evidence`n" + (($OpenRows | ForEach-Object {
  "$(Csv-Escape $_.Line),$(Csv-Escape $_.Term),$(Csv-Escape $_.Disposition),$(Csv-Escape $_.WhySafe),$(Csv-Escape $_.Evidence)"
}) -join "`n")
Write-Utf8NoBom $TablePath $Table

$OpenRowsText = (($OpenRows | ForEach-Object {
  "- line $($_.Line) [$($_.Term)] $($_.Disposition): $($_.WhySafe)"
}) -join "`n")

$BlockerText = if ($Blockers.Count -gt 0) {
  (($Blockers | ForEach-Object { "- $_" }) -join "`n")
} else {
  "- none"
}

$BadNextText = if ($HasBadNext) {
  "Observed and corrected: prior runner printed NEXT: STATIC_CLEARED_FOR_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_CLUTTER_CLOSEOUT while its own final verdict was UNKNOWN_AUTHORITY_ROWS_REMAIN_OPEN."
} else {
  "No bad NEXT line found in the saved report text. Console output still showed the contradiction and this closeout records the guard rule."
}

$StatusAfter = (& git status --short) -join "`n"

$Report = @"
# Row 001 Unknown Authority Rows Final Closeout

Date: $DateKey
RunId: $RunId
FinalVerdict: $FinalVerdict

## Boundary

This closeout is static review only.

The target helper was not run.
No Git add, commit, push, reset, checkout, clean, or root cleanup was performed.
No pointer/state file was mutated.

## Repo Proof

Repo: $Repo
Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)

## Source Inputs

DispositionReport: $DispositionReportPath
DispositionReportSha256: $(Get-Sha256 $DispositionReportPath)

AuthorityTable: $AuthorityTablePath
AuthorityTableSha256: $(Get-Sha256 $AuthorityTablePath)

## Open Rows Closed

$OpenRowsText

## Runner Output Contradiction

$BadNextText

Rule correction: a runner must not print a STATIC_CLEARED next line when its own final verdict remains open. Verdict controls next route; optimistic NEXT text does not override the verdict.

## Blockers

$BlockerText

## Decision

$FinalVerdict

If the final verdict is UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSED_REPORT_ONLY_OR_GUARD_FIELDS, then the authority-language concern is closed for static review.

This still does not authorize running the target helper. The next legal lane is disposable fixture design, plus deliberate runner-clutter closeout.
"@

Write-Utf8NoBom $ReportPath $Report
$ReportSha = Get-Sha256 $ReportPath
$TableSha = Get-Sha256 $TablePath

$Receipt = @"
ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_RECEIPT
RunId: $RunId
Date: $DateKey
FinalVerdict: $FinalVerdict

DispositionReport: $DispositionReportPath
DispositionReportSha256: $(Get-Sha256 $DispositionReportPath)

AuthorityTable: $AuthorityTablePath
AuthorityTableSha256: $(Get-Sha256 $AuthorityTablePath)

Report: $ReportPath
ReportSha256: $ReportSha

Table: $TablePath
TableSha256: $TableSha

Counts:
UnknownRowsTotal: $($UnknownRows.Count)
FinalOpenRowsClosed: $($OpenRows.Count)
BlockerCount: $($Blockers.Count)
BadNextContradictionObserved: $HasBadNext

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
Write-Host "ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_COMPLETE"
Write-Host "RunId: $RunId"
Write-Host "FinalVerdict: $FinalVerdict"
Write-Host "UnknownRowsTotal: $($UnknownRows.Count)"
Write-Host "FinalOpenRowsClosed: $($OpenRows.Count)"
Write-Host "BlockerCount: $($Blockers.Count)"
Write-Host "BadNextContradictionObserved: $HasBadNext"
Write-Host "Report: $ReportPath"
Write-Host "ReportSha256: $ReportSha"
Write-Host "Table: $TablePath"
Write-Host "TableSha256: $TableSha"
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
if ($FinalVerdict -eq "UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSED_REPORT_ONLY_OR_GUARD_FIELDS") {
  Write-Host "NEXT: DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_CLUTTER_CLOSEOUT"
} else {
  Write-Host "NEXT: REVIEW_BLOCKERS_BEFORE_FIXTURE"
}
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"
