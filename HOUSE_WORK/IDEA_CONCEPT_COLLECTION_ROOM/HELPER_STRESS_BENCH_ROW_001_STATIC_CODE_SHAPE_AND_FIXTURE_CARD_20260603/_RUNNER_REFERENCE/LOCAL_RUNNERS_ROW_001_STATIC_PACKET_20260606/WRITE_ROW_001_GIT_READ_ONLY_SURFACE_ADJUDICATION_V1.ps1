param(
  [string]$ExpectedRepo = "$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz",
  [string]$TargetPath = "$env:USERPROFILE\Desktop\123\_TOOLS_AND_SCRIPTS\ROOT_LOOSE_HELPERS_20260603\READ_ONLY_INSPECT\READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Stop-Clean {
  param([string]$Reason, [string]$Detail = "")
  Write-Host "ROW_001_GIT_SURFACE_ADJUDICATION_STOPPED"
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

if (-not (Test-Path -LiteralPath $TargetPath)) {
  Stop-Clean "TARGET_PATH_NOT_FOUND" $TargetPath
}

$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$DateKey = Get-Date -Format "yyyyMMdd"
$Head = (& git rev-parse HEAD).Trim()
$OriginMain = (& git rev-parse origin/main).Trim()
$StatusBefore = (& git status --short) -join "`n"

$PacketDir = Join-Path $Repo "HOUSE_WORK\IDEA_CONCEPT_COLLECTION_ROOM\HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_$DateKey"
$ProofDir = Join-Path $Repo "PROOF_HISTORY"
New-Item -ItemType Directory -Path $PacketDir -Force | Out-Null
New-Item -ItemType Directory -Path $ProofDir -Force | Out-Null

$ReportPath = Join-Path $PacketDir "ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_$DateKey.md"
$TablePath = Join-Path $PacketDir "ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_TABLE_$DateKey.csv"
$ReceiptPath = Join-Path $ProofDir "ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_RECEIPT_$DateKey.txt"

$TargetText = Get-Content -LiteralPath $TargetPath -Raw
$TargetLines = Get-Content -LiteralPath $TargetPath
$TargetSha = Get-Sha256 $TargetPath

$tokens = $null
$parseErrors = $null
$ast = [System.Management.Automation.Language.Parser]::ParseFile($TargetPath, [ref]$tokens, [ref]$parseErrors)

$rows = New-Object System.Collections.Generic.List[object]
$failures = New-Object System.Collections.Generic.List[string]
$watches = New-Object System.Collections.Generic.List[string]

$commandAsts = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)

foreach ($cmd in $commandAsts) {
  $name = $cmd.GetCommandName()
  $text = ($cmd.Extent.Text -replace "`r|`n"," ").Trim()
  $line = $cmd.Extent.StartLineNumber

  if ($name -eq "git") {
    if ($text -eq "& git @GitArgs 2>`$null" -or $text -eq "& git @GitArgs 2>$null") {
      $rows.Add([pscustomobject]@{
        Class="GIT_WRAPPER_SURFACE"
        Line=$line
        Verdict="WATCH_ALLOWLIST_CALLERS_REQUIRED"
        Evidence=$text
        Reason="Generic GitArgs wrapper is acceptable only if every caller is hard-coded to an allowed read-only command."
      })
    } elseif ($text -eq "& git status --short 2>`$null" -or $text -eq "& git status --short 2>$null") {
      $rows.Add([pscustomobject]@{
        Class="READ_ONLY_GIT_DIRECT"
        Line=$line
        Verdict="READ_ONLY_CONFIRMED"
        Evidence=$text
        Reason="git status --short is a read-only repo status probe."
      })
    } else {
      $rows.Add([pscustomobject]@{
        Class="UNKNOWN_GIT_DIRECT"
        Line=$line
        Verdict="BLOCKED_UNKNOWN_GIT"
        Evidence=$text
        Reason="Direct git invocation is not recognized as read-only."
      })
      $failures.Add("Unknown direct git invocation at line $line: $text") | Out-Null
    }
  }

  if ($name -eq "Read-GitValue") {
    if ($text -match 'Read-GitValue\s+-WorkDir\s+\$RepoRoot\s+-GitArgs\s+@\("rev-parse",\s*"HEAD"\)\s+-Fallback') {
      $rows.Add([pscustomobject]@{
        Class="READ_GIT_VALUE_CALLER"
        Line=$line
        Verdict="READ_ONLY_CONFIRMED"
        Evidence=$text
        Reason="Caller is hard-coded to git rev-parse HEAD."
      })
    } elseif ($text -match 'Read-GitValue\s+-WorkDir\s+\$RepoRoot\s+-GitArgs\s+@\("rev-parse",\s*"origin/main"\)\s+-Fallback') {
      $rows.Add([pscustomobject]@{
        Class="READ_GIT_VALUE_CALLER"
        Line=$line
        Verdict="READ_ONLY_CONFIRMED"
        Evidence=$text
        Reason="Caller is hard-coded to git rev-parse origin/main."
      })
    } else {
      $rows.Add([pscustomobject]@{
        Class="READ_GIT_VALUE_CALLER"
        Line=$line
        Verdict="BLOCKED_UNKNOWN_GITARGS"
        Evidence=$text
        Reason="Read-GitValue caller is not in the read-only allowlist."
      })
      $failures.Add("Unknown Read-GitValue caller at line $line: $text") | Out-Null
    }
  }
}

# Guard against plain text mutation commands even if static command AST did not mark them as direct git commands.
$mutationPattern = 'git\s+(add|commit|push|reset|checkout|clean|rm|mv|restore|switch|stash|tag|branch|merge|rebase|cherry-pick|revert|config)\b'
foreach ($m in [regex]::Matches($TargetText, $mutationPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
  $line = (($TargetText.Substring(0, $m.Index) -split "`r?`n").Count)
  $rows.Add([pscustomobject]@{
    Class="TEXT_GIT_MUTATION_WORD"
    Line=$line
    Verdict="BLOCKED_MUTATION_WORD_PRESENT"
    Evidence=$m.Value
    Reason="Mutation-shaped git text appears in source."
  })
  $failures.Add("Mutation-shaped git text found at line $line: $($m.Value)") | Out-Null
}

$rows = @($rows | Sort-Object Line, Class, Evidence -Unique)

if ($rows.Count -eq 0) {
  $watches.Add("No git surfaces found; this adjudicator may be pointed at the wrong target.") | Out-Null
}

$unknownCount = @($rows | Where-Object { $_.Verdict -like "BLOCKED*" }).Count
$confirmedCount = @($rows | Where-Object { $_.Verdict -eq "READ_ONLY_CONFIRMED" }).Count
$watchCount = @($rows | Where-Object { $_.Verdict -like "WATCH*" }).Count

if (@($parseErrors).Count -gt 0) {
  $FinalVerdict = "BLOCKED_PARSE_ERROR"
} elseif ($failures.Count -gt 0 -or $unknownCount -gt 0) {
  $FinalVerdict = "GIT_SURFACE_UNRESOLVED_OR_BLOCKED"
} elseif ($confirmedCount -ge 3 -and $watchCount -ge 1) {
  $FinalVerdict = "GIT_SURFACE_READ_ONLY_CONFIRMED_SCANNER_REPAIR_NEEDED"
} else {
  $FinalVerdict = "GIT_SURFACE_PARTIAL_WATCH"
}

$table = "Class,Line,Verdict,Evidence,Reason`n" + (($rows | ForEach-Object {
  "$(Csv-Escape $_.Class),$(Csv-Escape $_.Line),$(Csv-Escape $_.Verdict),$(Csv-Escape $_.Evidence),$(Csv-Escape $_.Reason)"
}) -join "`n")
Write-Utf8NoBom $TablePath $table

$rowText = if ($rows.Count -gt 0) {
  (($rows | ForEach-Object { "- line $($_.Line) [$($_.Class)] $($_.Verdict): $($_.Evidence)" }) -join "`n")
} else {
  "- none"
}

$failureText = if ($failures.Count -gt 0) { (($failures | ForEach-Object { "- $_" }) -join "`n") } else { "- none" }
$watchText = if ($watches.Count -gt 0) { (($watches | ForEach-Object { "- $_" }) -join "`n") } else { "- none" }

$Report = @"
# Row 001 Git Read-Only Surface Adjudication

Date: $DateKey
RunId: $RunId
TargetPath: $TargetPath
TargetSha256: $TargetSha
FinalVerdict: $FinalVerdict

## Boundary

This adjudication is static review only.

The target helper was not run.
No Git add, commit, push, reset, checkout, clean, or root cleanup was performed.
No pointer/state file was mutated.

## Repo Proof

Repo: $Repo
Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)

## What Was Checked

The Row 001 static packet previously flagged all `git` commands as mutation surfaces.

This addendum checks whether the actual Git surfaces are read-only probes or unresolved mutation risks.

## Findings

$rowText

## Failures

$failureText

## Watches

$watchText

## Decision

$FinalVerdict

If this verdict is `GIT_SURFACE_READ_ONLY_CONFIRMED_SCANNER_REPAIR_NEEDED`, then the target helper's Git calls are not the active repair blocker. The lower-layer repair is the scanner classification rule: read-only Git probes should be allowlisted separately from Git mutation commands.

The target helper may still need a wording/authority-surface review for PASS/LOCK/Receipt language before any execution path.
"@
Write-Utf8NoBom $ReportPath $Report

$StatusAfter = (& git status --short) -join "`n"

$Receipt = @"
ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_RECEIPT
RunId: $RunId
Date: $DateKey
TargetPath: $TargetPath
TargetSha256: $TargetSha
FinalVerdict: $FinalVerdict

Repo: $Repo
Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)

Counts:
ParseErrorCount: $(@($parseErrors).Count)
Rows: $($rows.Count)
ConfirmedReadOnlyRows: $confirmedCount
WatchRows: $watchCount
BlockedRows: $unknownCount
FailureCount: $($failures.Count)

Outputs:
Report: $ReportPath
ReportSha256: $(Get-Sha256 $ReportPath)
Table: $TablePath
TableSha256: $(Get-Sha256 $TablePath)

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

Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
Write-Host "ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_COMPLETE"
Write-Host "RunId: $RunId"
Write-Host "FinalVerdict: $FinalVerdict"
Write-Host "TargetPath: $TargetPath"
Write-Host "TargetSha256: $TargetSha"
Write-Host "ConfirmedReadOnlyRows: $confirmedCount"
Write-Host "WatchRows: $watchCount"
Write-Host "BlockedRows: $unknownCount"
Write-Host "FailureCount: $($failures.Count)"
Write-Host "Report: $ReportPath"
Write-Host "ReportSha256: $(Get-Sha256 $ReportPath)"
Write-Host "Table: $TablePath"
Write-Host "TableSha256: $(Get-Sha256 $TablePath)"
Write-Host "Receipt: $ReceiptPath"
Write-Host "ReceiptSha256: $(Get-Sha256 $ReceiptPath)"
Write-Host "Head: $Head"
Write-Host "OriginMain: $OriginMain"
Write-Host "HeadEqualsOrigin: $($Head -eq $OriginMain)"
Write-Host "FinalGitStatusShort:"
if ([string]::IsNullOrWhiteSpace($StatusAfter)) { Write-Host "<clean>" } else { Write-Host $StatusAfter }
Write-Host "TargetHelperExecuted: False"
Write-Host "GitAddCommitPush: False"
Write-Host "RootCleanup: False"
Write-Host "PointerStateMutation: False"
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"
