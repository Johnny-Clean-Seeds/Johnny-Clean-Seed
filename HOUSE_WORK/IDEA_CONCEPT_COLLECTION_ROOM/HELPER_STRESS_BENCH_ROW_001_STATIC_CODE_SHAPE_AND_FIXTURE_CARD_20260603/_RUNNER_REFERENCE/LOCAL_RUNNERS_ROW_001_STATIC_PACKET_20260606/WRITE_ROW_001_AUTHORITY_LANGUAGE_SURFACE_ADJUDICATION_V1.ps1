param(
  [string]$ExpectedRepo = "$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz",
  [string]$TargetPath = "$env:USERPROFILE\Desktop\123\_TOOLS_AND_SCRIPTS\ROOT_LOOSE_HELPERS_20260603\READ_ONLY_INSPECT\READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Stop-Clean {
  param([string]$Reason, [string]$Detail = "")
  Write-Host "ROW_001_AUTHORITY_LANGUAGE_ADJUDICATION_STOPPED"
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

function Classify-AuthorityLine {
  param(
    [string]$LineText,
    [string]$Term
  )

  $trim = $LineText.Trim()

  if ($trim.StartsWith("#")) {
    return "COMMENT_OR_HEADER"
  }

  if ($trim -match '^\$FinalVerdict\s*=') {
    return "VERDICT_ASSIGNMENT_HEAD"
  }

  if ($trim -match '^"(STOP|WATCH_STOP|PASS_WITH_WATCH|PASS|FAIL|FAILURE|WARNING|NEXT_|DoesNotProve|StopLine|Pointer|Repo|SaveReceipts|Receipt|Card|Source|Resolution|Active|Allowed|Blocked|Files|Evidence|WARNING_COUNT|BLOCKING_WARNING_COUNT|NON_BLOCKING_WARNING_COUNT|WATCH_WARNING_COUNT|UNKNOWN_WARNING_COUNT)') {
    return "REPORT_OUTPUT_STRING"
  }

  if ($trim -match '^"(STOP|WATCH_STOP|PASS_WITH_WATCH|PASS)\s*/') {
    return "FINAL_VERDICT_STRING"
  }

  if ($trim -match '^\$[A-Za-z0-9_]*' -and $trim -match '=') {
    return "VARIABLE_ASSIGNMENT_OR_CALCULATION"
  }

  if ($trim -match 'Get-PropertyValue|Get-ArrayText|Where-Object|Add-WarningObject') {
    return "STATE_READ_OR_WARNING_CLASSIFICATION"
  }

  if ($trim -match '^\$[A-Za-z0-9_]+$') {
    return "VARIABLE_REFERENCE"
  }

  return "UNKNOWN_AUTHORITY_CONTEXT"
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

$ReportPath = Join-Path $PacketDir "ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_$DateKey.md"
$TablePath = Join-Path $PacketDir "ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_TABLE_$DateKey.csv"
$ReceiptPath = Join-Path $ProofDir "ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_RECEIPT_$DateKey.txt"

$TargetText = Get-Content -LiteralPath $TargetPath -Raw
$TargetLines = Get-Content -LiteralPath $TargetPath
$TargetSha = Get-Sha256 $TargetPath

$tokens = $null
$parseErrors = $null
$ast = [System.Management.Automation.Language.Parser]::ParseFile($TargetPath, [ref]$tokens, [ref]$parseErrors)

$terms = @("PASS","FAIL","VERDICT","FinalVerdict","LOCK","SAVED","COMPLETE","Receipt","Receipts","SHA256","DoesNotProve","StopLine","NO_MUTATION")
$rows = New-Object System.Collections.Generic.List[object]
$blocked = New-Object System.Collections.Generic.List[string]
$watch = New-Object System.Collections.Generic.List[string]

for ($i = 0; $i -lt $TargetLines.Count; $i++) {
  $lineNumber = $i + 1
  $line = [string]$TargetLines[$i]

  foreach ($term in $terms) {
    if ($line -match [regex]::Escape($term)) {
      $class = Classify-AuthorityLine -LineText $line -Term $term
      $risk = switch ($class) {
        "UNKNOWN_AUTHORITY_CONTEXT" { "WATCH_REVIEW" }
        "FINAL_VERDICT_STRING" { "REPORT_ONLY_WITH_AUTHORITY_WORDING_WATCH" }
        "REPORT_OUTPUT_STRING" { "REPORT_ONLY" }
        "VERDICT_ASSIGNMENT_HEAD" { "REPORT_CONTROL" }
        "VARIABLE_ASSIGNMENT_OR_CALCULATION" { "VARIABLE_OR_REPORT_CONTROL" }
        "STATE_READ_OR_WARNING_CLASSIFICATION" { "STATE_READ_OR_WARNING_ONLY" }
        "VARIABLE_REFERENCE" { "VARIABLE_REFERENCE_ONLY" }
        "COMMENT_OR_HEADER" { "COMMENT_ONLY" }
        default { "WATCH_REVIEW" }
      }

      $rows.Add([pscustomobject]@{
        Term=$term
        Line=$lineNumber
        Class=$class
        Risk=$risk
        Evidence=$line.Trim()
      }) | Out-Null
    }
  }
}

$rows = @($rows | Sort-Object Line, Term, Evidence -Unique)

$commandAsts = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)
$commandNames = @($commandAsts | ForEach-Object { $_.GetCommandName() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)

$writeCommands = @(
  "Set-Content","Add-Content","Out-File","Export-Csv","New-Item","Remove-Item","Move-Item","Copy-Item","Rename-Item",
  "Clear-Content","Set-Item","Remove-ItemProperty","Set-ItemProperty","New-ItemProperty","Start-Transcript","Stop-Transcript"
)

$foundWriteCommands = @($commandNames | Where-Object { $writeCommands -contains $_ })

$hasFinalVerdict = $TargetText -match '\$FinalVerdict\s*='
$hasNoMutationVerdicts = $TargetText -match 'NO_MUTATION'
$hasDoesNotProveOutput = $TargetText -match 'DoesNotProve'
$hasStopLineOutput = $TargetText -match 'StopLine'
$unknownAuthorityRows = @($rows | Where-Object { $_.Class -eq "UNKNOWN_AUTHORITY_CONTEXT" })
$finalVerdictRows = @($rows | Where-Object { $_.Class -eq "FINAL_VERDICT_STRING" -or $_.Evidence -match '^\s*"(STOP|WATCH_STOP|PASS_WITH_WATCH|PASS)\s*/' })

if (@($parseErrors).Count -gt 0) {
  $blocked.Add("Target has parse errors; authority language cannot be adjudicated safely.") | Out-Null
}

if ($foundWriteCommands.Count -gt 0) {
  $blocked.Add("Write-capable commands appear in target command surface: $($foundWriteCommands -join ', ')") | Out-Null
}

if (-not $hasFinalVerdict) {
  $blocked.Add("No FinalVerdict control found.") | Out-Null
}

if (-not $hasNoMutationVerdicts) {
  $watch.Add("No NO_MUTATION marker found in verdict strings.") | Out-Null
}

if (-not $hasDoesNotProveOutput) {
  $watch.Add("No DoesNotProve output found.") | Out-Null
}

if (-not $hasStopLineOutput) {
  $watch.Add("No StopLine output found.") | Out-Null
}

if ($unknownAuthorityRows.Count -gt 0) {
  $watch.Add("Unknown authority-language contexts require manual review: $($unknownAuthorityRows.Count)") | Out-Null
}

$reportOnlyRows = @($rows | Where-Object { $_.Risk -in @("REPORT_ONLY","REPORT_ONLY_WITH_AUTHORITY_WORDING_WATCH","REPORT_CONTROL","VARIABLE_OR_REPORT_CONTROL","STATE_READ_OR_WARNING_ONLY","VARIABLE_REFERENCE_ONLY","COMMENT_ONLY") })

if ($blocked.Count -gt 0) {
  $FinalVerdict = "AUTHORITY_LANGUAGE_BLOCKED_REPAIR_REQUIRED"
} elseif ($finalVerdictRows.Count -gt 0 -and $hasNoMutationVerdicts -and $hasDoesNotProveOutput -and $hasStopLineOutput) {
  $FinalVerdict = "AUTHORITY_LANGUAGE_REPORT_ONLY_WITH_WATCH"
} else {
  $FinalVerdict = "AUTHORITY_LANGUAGE_PARTIAL_WATCH"
}

$table = "Term,Line,Class,Risk,Evidence`n" + (($rows | ForEach-Object {
  "$(Csv-Escape $_.Term),$(Csv-Escape $_.Line),$(Csv-Escape $_.Class),$(Csv-Escape $_.Risk),$(Csv-Escape $_.Evidence)"
}) -join "`n")
Write-Utf8NoBom $TablePath $table

$rowText = if ($rows.Count -gt 0) {
  (($rows | ForEach-Object { "- line $($_.Line) [$($_.Term)] $($_.Class) / $($_.Risk): $($_.Evidence)" }) -join "`n")
} else {
  "- none"
}

$blockedText = if ($blocked.Count -gt 0) { (($blocked | ForEach-Object { "- $_" }) -join "`n") } else { "- none" }
$watchText = if ($watch.Count -gt 0) { (($watch | ForEach-Object { "- $_" }) -join "`n") } else { "- none" }
$commandText = if ($commandNames.Count -gt 0) { ($commandNames -join ", ") } else { "[none]" }
$writeCommandText = if ($foundWriteCommands.Count -gt 0) { ($foundWriteCommands -join ", ") } else { "[none]" }

$Report = @"
# Row 001 Authority-Language Surface Adjudication

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

## Why This Exists

The Row 001 static packet flagged authority-language terms such as PASS, FAIL, LOCK, Receipt, SHA256, SAVED, and COMPLETE.

This addendum decides whether those terms are report-only wording or fake authority / mutation-risk surfaces.

## Command Surface Check

CommandsObserved: $commandText
WriteCapableCommandsObserved: $writeCommandText

## Required Guard Markers

HasFinalVerdict: $hasFinalVerdict
HasNoMutationVerdicts: $hasNoMutationVerdicts
HasDoesNotProveOutput: $hasDoesNotProveOutput
HasStopLineOutput: $hasStopLineOutput

## Authority-Language Rows

$rowText

## Blockers

$blockedText

## Watches

$watchText

## Decision

$FinalVerdict

If this verdict is `AUTHORITY_LANGUAGE_REPORT_ONLY_WITH_WATCH`, the authority words are not the active execution blocker by themselves. They remain wording/watch surfaces and should be preserved as report-only unless a later fixture proves they mislead the caller.

This does not authorize running the target helper yet. It only closes or narrows the authority-language static concern.
"@
Write-Utf8NoBom $ReportPath $Report

$StatusAfter = (& git status --short) -join "`n"

$Receipt = @"
ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_RECEIPT
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
AuthorityRows: $($rows.Count)
ReportOnlyOrControlRows: $($reportOnlyRows.Count)
UnknownAuthorityRows: $($unknownAuthorityRows.Count)
FinalVerdictRows: $($finalVerdictRows.Count)
WriteCapableCommandsObserved: $($foundWriteCommands.Count)
BlockerCount: $($blocked.Count)
WatchCount: $($watch.Count)

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
Write-Host "ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_COMPLETE"
Write-Host "RunId: $RunId"
Write-Host "FinalVerdict: $FinalVerdict"
Write-Host "TargetPath: $TargetPath"
Write-Host "TargetSha256: $TargetSha"
Write-Host "AuthorityRows: $($rows.Count)"
Write-Host "ReportOnlyOrControlRows: $($reportOnlyRows.Count)"
Write-Host "UnknownAuthorityRows: $($unknownAuthorityRows.Count)"
Write-Host "FinalVerdictRows: $($finalVerdictRows.Count)"
Write-Host "WriteCapableCommandsObserved: $($foundWriteCommands.Count)"
Write-Host "BlockerCount: $($blocked.Count)"
Write-Host "WatchCount: $($watch.Count)"
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
