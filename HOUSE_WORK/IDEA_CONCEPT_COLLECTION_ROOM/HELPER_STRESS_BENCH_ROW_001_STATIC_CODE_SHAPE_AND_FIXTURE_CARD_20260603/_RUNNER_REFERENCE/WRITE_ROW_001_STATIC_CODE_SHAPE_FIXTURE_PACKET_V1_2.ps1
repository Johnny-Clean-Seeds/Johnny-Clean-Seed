param(
  [string]$ExpectedRepo = "$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz",
  [string]$TargetName = "READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1",
  [string]$TargetPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Stop-Clean {
  param([string]$Reason, [string]$Detail = "")
  Write-Host "ROW_001_PACKET_STOPPED"
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

function Get-LineNumberForIndex {
  param([string]$Text, [int]$Index)
  if ($Index -le 0) { return 1 }
  return (($Text.Substring(0, $Index) -split "`r?`n").Count)
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

$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$DateKey = Get-Date -Format "yyyyMMdd"

$Head = (& git rev-parse HEAD).Trim()
$OriginMain = (& git rev-parse origin/main).Trim()
$StatusBefore = (& git status --short) -join "`n"

$PacketDir = Join-Path $Repo "HOUSE_WORK\IDEA_CONCEPT_COLLECTION_ROOM\HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_$DateKey"
$ProofDir = Join-Path $Repo "PROOF_HISTORY"
New-Item -ItemType Directory -Path $PacketDir -Force | Out-Null
New-Item -ItemType Directory -Path $ProofDir -Force | Out-Null

$RunnerCopyDir = Join-Path $PacketDir "_RUNNER_REFERENCE"
New-Item -ItemType Directory -Path $RunnerCopyDir -Force | Out-Null
if (-not [string]::IsNullOrWhiteSpace($PSCommandPath) -and (Test-Path -LiteralPath $PSCommandPath)) {
  Copy-Item -LiteralPath $PSCommandPath -Destination (Join-Path $RunnerCopyDir (Split-Path -Leaf $PSCommandPath)) -Force
}

$ErrorCapturePath = Join-Path $PacketDir "ROW_001_LOWER_LAYER_ROUTE_ERROR_CAPTURE_$DateKey.md"
$RuleCapturePath = Join-Path $PacketDir "ROW_001_RULE_CONCEPT_IDEA_LIFECYCLE_CAPTURE_$DateKey.md"
$ReportPath = Join-Path $PacketDir "HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_REPORT_$DateKey.md"
$FixturePath = Join-Path $PacketDir "HELPER_STRESS_BENCH_ROW_001_FIXTURE_CARD_$DateKey.md"
$CommandCsvPath = Join-Path $PacketDir "HELPER_STRESS_BENCH_ROW_001_COMMAND_TABLE_$DateKey.csv"
$RiskCsvPath = Join-Path $PacketDir "HELPER_STRESS_BENCH_ROW_001_RISK_SURFACE_TABLE_$DateKey.csv"
$ManifestPath = Join-Path $ProofDir "HELPER_STRESS_BENCH_ROW_001_STATIC_PACKET_MANIFEST_$DateKey.csv"
$ReceiptPath = Join-Path $ProofDir "HELPER_STRESS_BENCH_ROW_001_STATIC_PACKET_RECEIPT_$DateKey.txt"

$priorErrorText = @'
InvalidOperation: C:\Users\13527\Downloads\WRITE_ROW_001_STATIC_CODE_SHAPE_FIXTURE_PACKET_V1.ps1:33
Line |
  33 |  $Repo = (& git rev-parse --show-toplevel 2>$null).Trim()
     |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | You cannot call a method on a null-valued expression.
'@

$errorCapture = @"
# Row 001 Lower-Layer Route Error Capture

Date: $DateKey
RunId: $RunId

## Failure Class

LOWER_LAYER_REPO_DISCOVERY_NULL_TRIM_FAILURE

## Exact Error

$priorErrorText

## Cause

The previous runner was saved under Downloads and executed while the shell stood in Desktop\123 instead of the Git repo.

The command git rev-parse --show-toplevel returned null or empty, then the script called .Trim() on that null value.

## Repair Installed Here

This runner proves the expected repo path first, changes into the repo, checks that git top is non-empty, and only then calls .Trim().

This runner is meant to be copied into and run from a known repo-local runner folder, not executed from Downloads by habit.

## Boundary

Target helper executed: false
Git add/commit/push: false
Root cleanup: false
Pointer/state mutation: false
"@
Write-Utf8NoBom $ErrorCapturePath $errorCapture

$ruleCapture = @"
# Row 001 Rule / Concept / Idea Lifecycle Capture

Date: $DateKey
RunId: $RunId

## Captured Rule

Useful rules, concepts, ideas, lower-layer repairs, and behavior corrections should be captured when they appear and locked/saved when the timing is right.

Do not force promotion too early when it would interrupt the active lane.

Do not let live discoveries evaporate.

## Lifecycle

1. Capture now when the signal appears.
2. Park if not ready.
3. Prove and fit before promotion.
4. Lock/save when timing is right.
5. Preserve the route back.

## Current Application

This packet captures the route error and rule lifecycle now, while keeping execution blocked for the target helper.

## Boundary

This is a support capture, not doctrine promotion.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No watcher.
No commit or push from this script.
"@
Write-Utf8NoBom $RuleCapturePath $ruleCapture

if (-not [string]::IsNullOrWhiteSpace($TargetPath)) {
  if (-not (Test-Path -LiteralPath $TargetPath)) {
    Stop-Clean "TARGET_PATH_NOT_FOUND" $TargetPath
  }
  $Target = Get-Item -LiteralPath $TargetPath
} else {
  $searchRoots = @(
    $Repo,
    (Join-Path $Repo "HOUSE_WORK"),
    (Join-Path $Repo "BRAIN_LEARNING"),
    (Join-Path $Repo "PROOF_HISTORY"),
    "$env:USERPROFILE\Desktop\123"
  ) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique

  $found = foreach ($root in $searchRoots) {
    Get-ChildItem -LiteralPath $root -Recurse -File -Filter $TargetName -ErrorAction SilentlyContinue |
      Where-Object { $_.FullName -notmatch '\\\.git\\' }
  }

  $found = @($found | Sort-Object FullName -Unique)

  if ($found.Count -lt 1) {
    $emptyCommandCsv = "Command,Line,Text`n"
    $emptyRiskCsv = "Class,Line,Hit,Evidence`n"
    Write-Utf8NoBom $CommandCsvPath $emptyCommandCsv
    Write-Utf8NoBom $RiskCsvPath $emptyRiskCsv

    $report = @"
# Helper Stress Bench Row 001 Static Code Shape Report

Date: $DateKey
RunId: $RunId
Target: $TargetName
Verdict: TARGET_NOT_FOUND_STATIC_REVIEW_BLOCKED

## Boundary

No target helper was run.
No Git add/commit/push was performed.
No root cleanup was performed.

## Finding

The target script was not found in the bounded search roots.

## Search Roots

$($searchRoots -join "`n")

## Next Legal Move

Provide an exact TargetPath or place the target in a known repo/local lane, then rerun this script with -TargetPath.
"@
    Write-Utf8NoBom $ReportPath $report

    $fixture = @"
# Helper Stress Bench Row 001 Fixture Card

Date: $DateKey
RunId: $RunId
Target: $TargetName
StaticVerdict: TARGET_NOT_FOUND_STATIC_REVIEW_BLOCKED

## Stop Line

Do not run the helper. The target path must be located first.
"@
    Write-Utf8NoBom $FixturePath $fixture

    $filesForManifest = @($ErrorCapturePath,$RuleCapturePath,$ReportPath,$FixturePath,$CommandCsvPath,$RiskCsvPath)
    $manifestRows = @("Path,SHA256,Bytes")
    foreach ($p in $filesForManifest) {
      $item = Get-Item -LiteralPath $p
      $rel = Resolve-Path -LiteralPath $p -Relative
      $manifestRows += "$(Csv-Escape $rel),$(Get-Sha256 $p),$($item.Length)"
    }
    Write-Utf8NoBom $ManifestPath ($manifestRows -join "`n")

    $statusAfter = (& git status --short) -join "`n"
    $receipt = @"
HELPER_STRESS_BENCH_ROW_001_STATIC_PACKET_RECEIPT
RunId: $RunId
Date: $DateKey
Target: $TargetName
Verdict: TARGET_NOT_FOUND_STATIC_REVIEW_BLOCKED
Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)
Report: $ReportPath
ReportSha256: $(Get-Sha256 $ReportPath)
FixtureCard: $FixturePath
FixtureCardSha256: $(Get-Sha256 $FixturePath)
ErrorCapture: $ErrorCapturePath
ErrorCaptureSha256: $(Get-Sha256 $ErrorCapturePath)
RuleCapture: $RuleCapturePath
RuleCaptureSha256: $(Get-Sha256 $RuleCapturePath)
Manifest: $ManifestPath
ManifestSha256: $(Get-Sha256 $ManifestPath)
TargetHelperExecuted: False
GitAddCommitPush: False
RootCleanup: False
PointerStateMutation: False
StatusBefore:
$StatusBefore
StatusAfter:
$statusAfter
FinalLine: ROW_001_STATIC_REVIEW_BLOCKED_TARGET_NOT_FOUND
"@
    Write-Utf8NoBom $ReceiptPath $receipt

    Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
    Write-Host "ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_PACKET_STOPPED_TARGET_NOT_FOUND"
    Write-Host "RunId: $RunId"
    Write-Host "Verdict: TARGET_NOT_FOUND_STATIC_REVIEW_BLOCKED"
    Write-Host "Report: $ReportPath"
    Write-Host "ReportSha256: $(Get-Sha256 $ReportPath)"
    Write-Host "FixtureCard: $FixturePath"
    Write-Host "FixtureCardSha256: $(Get-Sha256 $FixturePath)"
    Write-Host "ErrorCapture: $ErrorCapturePath"
    Write-Host "ErrorCaptureSha256: $(Get-Sha256 $ErrorCapturePath)"
    Write-Host "RuleCapture: $RuleCapturePath"
    Write-Host "RuleCaptureSha256: $(Get-Sha256 $RuleCapturePath)"
    Write-Host "Manifest: $ManifestPath"
    Write-Host "ManifestSha256: $(Get-Sha256 $ManifestPath)"
    Write-Host "Receipt: $ReceiptPath"
    Write-Host "ReceiptSha256: $(Get-Sha256 $ReceiptPath)"
    Write-Host "Head: $Head"
    Write-Host "OriginMain: $OriginMain"
    Write-Host "HeadEqualsOrigin: $($Head -eq $OriginMain)"
    Write-Host "TargetHelperExecuted: False"
    Write-Host "GitAddCommitPush: False"
    Write-Host "RootCleanup: False"
    Write-Host "PointerStateMutation: False"
    Write-Host "FinalGitStatusShort:"
    if ([string]::IsNullOrWhiteSpace($statusAfter)) { Write-Host "<clean>" } else { Write-Host $statusAfter }
    Write-Host "NEXT: RERUN_WITH_EXACT_TARGETPATH_OR_PLACE_TARGET_IN_KNOWN_LANE"
    Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"
    exit 0
  }

  $Target = $found |
    Sort-Object @{Expression={ if ($_.FullName.StartsWith($Repo, [System.StringComparison]::OrdinalIgnoreCase)) { 0 } else { 1 } }},
                @{Expression={ $_.FullName.Length }},
                FullName |
    Select-Object -First 1
}

$TargetFull = $Target.FullName
$TargetSha = Get-Sha256 $TargetFull
$TargetText = Get-Content -LiteralPath $TargetFull -Raw
$TargetLines = ($TargetText -split "`r?`n").Count
$TargetBytes = (Get-Item -LiteralPath $TargetFull).Length

$tokens = $null
$parseErrors = $null
$ast = [System.Management.Automation.Language.Parser]::ParseFile($TargetFull, [ref]$tokens, [ref]$parseErrors)

$commandAsts = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)
$commands = foreach ($c in $commandAsts) {
  $name = $c.GetCommandName()
  if ([string]::IsNullOrWhiteSpace($name)) { $name = "<dynamic-or-unknown>" }
  [pscustomobject]@{
    Command = $name
    Line = $c.Extent.StartLineNumber
    Text = ($c.Extent.Text -replace "`r|`n"," ").Trim()
  }
}

$functionAsts = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
$assignmentAsts = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true)
$paramAsts = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.ParamBlockAst] }, $true)

$mutationCommands = @(
  "Set-Content","Add-Content","Out-File","New-Item","Remove-Item","Move-Item","Copy-Item","Rename-Item",
  "Clear-Content","Set-Item","Remove-ItemProperty","Set-ItemProperty","New-ItemProperty",
  "git","Remove-Variable","Set-Variable","Export-Csv","ConvertTo-Json","Start-Transcript","Stop-Transcript"
)

$executionCommands = @(
  "Invoke-Expression","iex","Start-Process","Invoke-Command","Start-Job","Register-ObjectEvent",
  "pwsh","powershell","cmd","wscript","cscript","schtasks","robocopy","xcopy",
  "Invoke-WebRequest","Invoke-RestMethod","curl","wget"
)

$protectedRegex = '(ACTIVE_GUIDES|CURRENT_TRUTH_INDEX|ACTIVE_ANCHOR|START_HERE_CURRENT_HOUSE_LEDGER|\.git|origin/main|git\s+add|git\s+commit|git\s+push|Remove-Item|Move-Item|Rename-Item|root cleanup|cleanup)'
$passSurfaceRegex = '(PASS|FAIL|VERDICT|FinalClean|HeadEqualsOrigin|Receipt|SHA256|LOCK|SAVED|COMPLETE)'
$dynamicRegex = '(?m)^\s*[\.\&]\s+|\[scriptblock\]::Create|Invoke-Expression|\biex\b'

$riskRows = New-Object System.Collections.Generic.List[object]

foreach ($cmd in $commands) {
  if ($mutationCommands -contains $cmd.Command) {
    $riskRows.Add([pscustomobject]@{Class="MUTATION_COMMAND"; Line=$cmd.Line; Hit=$cmd.Command; Evidence=$cmd.Text})
  }
  if ($executionCommands -contains $cmd.Command) {
    $riskRows.Add([pscustomobject]@{Class="EXECUTION_COMMAND"; Line=$cmd.Line; Hit=$cmd.Command; Evidence=$cmd.Text})
  }
  if ($cmd.Command -eq "<dynamic-or-unknown>") {
    $riskRows.Add([pscustomobject]@{Class="DYNAMIC_COMMAND"; Line=$cmd.Line; Hit=$cmd.Command; Evidence=$cmd.Text})
  }
}

foreach ($m in [regex]::Matches($TargetText, $protectedRegex)) {
  $riskRows.Add([pscustomobject]@{Class="PROTECTED_OR_STATE_SURFACE"; Line=(Get-LineNumberForIndex $TargetText $m.Index); Hit=$m.Value; Evidence=$m.Value})
}

foreach ($m in [regex]::Matches($TargetText, $passSurfaceRegex)) {
  $riskRows.Add([pscustomobject]@{Class="PASS_SURFACE_WORD"; Line=(Get-LineNumberForIndex $TargetText $m.Index); Hit=$m.Value; Evidence=$m.Value})
}

foreach ($m in [regex]::Matches($TargetText, $dynamicRegex)) {
  $riskRows.Add([pscustomobject]@{Class="DYNAMIC_OR_INVOCATION_SURFACE"; Line=(Get-LineNumberForIndex $TargetText $m.Index); Hit=$m.Value.Trim(); Evidence=$m.Value.Trim()})
}

$riskRows = @($riskRows | Sort-Object Class, Line, Hit -Unique)

$parseErrorCount = @($parseErrors).Count
$mutationCount = @($riskRows | Where-Object { $_.Class -eq "MUTATION_COMMAND" }).Count
$executionCount = @($riskRows | Where-Object { $_.Class -in @("EXECUTION_COMMAND","DYNAMIC_COMMAND","DYNAMIC_OR_INVOCATION_SURFACE") }).Count
$protectedCount = @($riskRows | Where-Object { $_.Class -eq "PROTECTED_OR_STATE_SURFACE" }).Count
$passSurfaceCount = @($riskRows | Where-Object { $_.Class -eq "PASS_SURFACE_WORD" }).Count

if ($parseErrorCount -gt 0) {
  $verdict = "BLOCKED_STATIC_PARSE_ERROR"
} elseif ($mutationCount -gt 0 -or $executionCount -gt 0) {
  $verdict = "REPAIR_BEFORE_RUN"
} elseif ($protectedCount -gt 0 -or $passSurfaceCount -gt 0) {
  $verdict = "SAFE_STATIC_ONLY_WITH_WATCH_SURFACES"
} else {
  $verdict = "SAFE_STATIC_ONLY_CANDIDATE"
}

$commandCsv = "Command,Line,Text`n" + (($commands | ForEach-Object {
  "$(Csv-Escape $_.Command),$(Csv-Escape $_.Line),$(Csv-Escape $_.Text)"
}) -join "`n")
Write-Utf8NoBom $CommandCsvPath $commandCsv

$riskCsv = "Class,Line,Hit,Evidence`n" + (($riskRows | ForEach-Object {
  "$(Csv-Escape $_.Class),$(Csv-Escape $_.Line),$(Csv-Escape $_.Hit),$(Csv-Escape $_.Evidence)"
}) -join "`n")
Write-Utf8NoBom $RiskCsvPath $riskCsv

$parseErrorText = if ($parseErrorCount -gt 0) {
  (($parseErrors | ForEach-Object { "- line $($_.Extent.StartLineNumber): $($_.Message)" }) -join "`n")
} else { "- none" }

$commandText = if (@($commands).Count -gt 0) {
  (($commands | Select-Object -First 120 | ForEach-Object { "- line $($_.Line): $($_.Command) -- $($_.Text)" }) -join "`n")
} else { "- none" }

$riskText = if (@($riskRows).Count -gt 0) {
  (($riskRows | Select-Object -First 180 | ForEach-Object { "- [$($_.Class)] line $($_.Line): $($_.Hit)" }) -join "`n")
} else { "- none" }

$report = @"
# Helper Stress Bench Row 001 Static Code Shape Report

Date: $DateKey
RunId: $RunId
Target: $TargetName
TargetPath: $TargetFull
TargetSha256: $TargetSha
Verdict: $verdict

## Boundary

This packet is static review only.

The target helper was not run.
The target helper was not dot-sourced.
The target helper was not imported.
No Git add, commit, push, reset, checkout, clean, or cleanup was performed by this review script.

## Repo State

Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)

## Target Shape

Lines: $TargetLines
Bytes: $TargetBytes
ParseErrorCount: $parseErrorCount
FunctionCount: $(@($functionAsts).Count)
ParamBlockCount: $(@($paramAsts).Count)
AssignmentCount: $(@($assignmentAsts).Count)
CommandCount: $(@($commands).Count)
MutationSurfaceCount: $mutationCount
ExecutionSurfaceCount: $executionCount
ProtectedOrStateSurfaceCount: $protectedCount
PassSurfaceWordCount: $passSurfaceCount

## Parse Errors

$parseErrorText

## Command Surface

$commandText

## Risk / Watch Surface

$riskText

## Decision

$verdict

If verdict is SAFE_STATIC_ONLY_CANDIDATE, the script may be considered for a later Code Gate path.
If verdict is SAFE_STATIC_ONLY_WITH_WATCH_SURFACES, fixture review must explain the watch surfaces first.
If verdict is REPAIR_BEFORE_RUN, do not run the helper; repair or replace risky surfaces first.
If verdict is BLOCKED_STATIC_PARSE_ERROR, do not run the helper; fix parse errors first.
"@
Write-Utf8NoBom $ReportPath $report

$fixture = @"
# Helper Stress Bench Row 001 Fixture Card

Date: $DateKey
RunId: $RunId
Target: $TargetName
TargetPath: $TargetFull
TargetSha256: $TargetSha
StaticVerdict: $verdict

## Fixture Purpose

This card defines what must be proven before $TargetName can be considered for execution later.

## Allowed Future Fixture Inputs

- A disposable fixture folder outside protected project authority.
- Tiny sample files made only for the fixture.
- No real ACTIVE_GUIDES.
- No real CURRENT_TRUTH_INDEX.
- No real ACTIVE_ANCHOR.
- No real Git mutation.
- No root cleanup.
- No deletes, moves, renames, commits, pushes, resets, or checkouts.

## Must Prove Before Any Real Run

1. The helper reads only expected paths.
2. The helper writes nothing, or writes only inside a declared disposable fixture output folder.
3. The helper does not emit fake PASS authority without independent proof.
4. The helper does not touch protected files.
5. The helper does not call Git mutation commands.
6. The helper does not invoke nested PowerShell, shell commands, jobs, watchers, web calls, or dynamic scriptblocks.
7. The helper returns a bounded report object that can be judged without side effects.

## Current Static Counts

ParseErrorCount: $parseErrorCount
MutationSurfaceCount: $mutationCount
ExecutionSurfaceCount: $executionCount
ProtectedOrStateSurfaceCount: $protectedCount
PassSurfaceWordCount: $passSurfaceCount

## Current Fixture Decision

$verdict

## Stop Line

Do not run $TargetName yet.
"@
Write-Utf8NoBom $FixturePath $fixture

$filesForManifest = @($ErrorCapturePath,$RuleCapturePath,$ReportPath,$FixturePath,$CommandCsvPath,$RiskCsvPath)
$manifestRows = @("Path,SHA256,Bytes")
foreach ($p in $filesForManifest) {
  $item = Get-Item -LiteralPath $p
  $rel = Resolve-Path -LiteralPath $p -Relative
  $manifestRows += "$(Csv-Escape $rel),$(Get-Sha256 $p),$($item.Length)"
}
Write-Utf8NoBom $ManifestPath ($manifestRows -join "`n")

$statusAfter = (& git status --short) -join "`n"

$receipt = @"
HELPER_STRESS_BENCH_ROW_001_STATIC_PACKET_RECEIPT
RunId: $RunId
Date: $DateKey
Target: $TargetName
TargetPath: $TargetFull
TargetSha256: $TargetSha
Verdict: $verdict

Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)

Counts:
Lines: $TargetLines
Bytes: $TargetBytes
ParseErrorCount: $parseErrorCount
CommandCount: $(@($commands).Count)
MutationSurfaceCount: $mutationCount
ExecutionSurfaceCount: $executionCount
ProtectedOrStateSurfaceCount: $protectedCount
PassSurfaceWordCount: $passSurfaceCount

Outputs:
Report: $ReportPath
ReportSha256: $(Get-Sha256 $ReportPath)
FixtureCard: $FixturePath
FixtureCardSha256: $(Get-Sha256 $FixturePath)
ErrorCapture: $ErrorCapturePath
ErrorCaptureSha256: $(Get-Sha256 $ErrorCapturePath)
RuleCapture: $RuleCapturePath
RuleCaptureSha256: $(Get-Sha256 $RuleCapturePath)
CommandTable: $CommandCsvPath
CommandTableSha256: $(Get-Sha256 $CommandCsvPath)
RiskTable: $RiskCsvPath
RiskTableSha256: $(Get-Sha256 $RiskCsvPath)
Manifest: $ManifestPath
ManifestSha256: $(Get-Sha256 $ManifestPath)

Boundary:
TargetHelperExecuted: False
DotSourced: False
Imported: False
GitAddCommitPush: False
RootCleanup: False
PointerStateMutation: False

StatusBefore:
$StatusBefore

StatusAfter:
$statusAfter

FinalLine:
ROW_001_STATIC_REVIEW_COMPLETE / EXECUTION_STILL_BLOCKED_OR_CODE_GATE_CANDIDATE_SELECTED
"@
Write-Utf8NoBom $ReceiptPath $receipt

Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
Write-Host "ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_PACKET_COMPLETE"
Write-Host "RunId: $RunId"
Write-Host "TargetPath: $TargetFull"
Write-Host "TargetSha256: $TargetSha"
Write-Host "Verdict: $verdict"
Write-Host "Report: $ReportPath"
Write-Host "ReportSha256: $(Get-Sha256 $ReportPath)"
Write-Host "FixtureCard: $FixturePath"
Write-Host "FixtureCardSha256: $(Get-Sha256 $FixturePath)"
Write-Host "ErrorCapture: $ErrorCapturePath"
Write-Host "ErrorCaptureSha256: $(Get-Sha256 $ErrorCapturePath)"
Write-Host "RuleCapture: $RuleCapturePath"
Write-Host "RuleCaptureSha256: $(Get-Sha256 $RuleCapturePath)"
Write-Host "Manifest: $ManifestPath"
Write-Host "ManifestSha256: $(Get-Sha256 $ManifestPath)"
Write-Host "Receipt: $ReceiptPath"
Write-Host "ReceiptSha256: $(Get-Sha256 $ReceiptPath)"
Write-Host "Head: $Head"
Write-Host "OriginMain: $OriginMain"
Write-Host "HeadEqualsOrigin: $($Head -eq $OriginMain)"
Write-Host "FinalGitStatusShort:"
if ([string]::IsNullOrWhiteSpace($statusAfter)) { Write-Host "<clean>" } else { Write-Host $statusAfter }
Write-Host "TargetHelperExecuted: False"
Write-Host "GitAddCommitPush: False"
Write-Host "RootCleanup: False"
Write-Host "PointerStateMutation: False"
Write-Host "ROW_001_STATIC_REVIEW_COMPLETE / EXECUTION_STILL_BLOCKED_OR_CODE_GATE_CANDIDATE_SELECTED"
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"
