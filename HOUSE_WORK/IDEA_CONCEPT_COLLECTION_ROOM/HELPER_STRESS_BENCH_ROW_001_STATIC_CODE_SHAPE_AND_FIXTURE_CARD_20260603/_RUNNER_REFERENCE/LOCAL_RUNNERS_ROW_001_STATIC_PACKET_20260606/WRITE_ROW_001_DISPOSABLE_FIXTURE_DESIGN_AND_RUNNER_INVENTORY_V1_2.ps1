param(
  [string]$ExpectedRepo = "$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz",
  [string]$TargetPath = "$env:USERPROFILE\Desktop\123\_TOOLS_AND_SCRIPTS\ROOT_LOOSE_HELPERS_20260603\READ_ONLY_INSPECT\READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Stop-Clean {
  param([string]$Reason, [string]$Detail = "")
  Write-Host "ROW_001_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_STOPPED"
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

$DateKey = Get-Date -Format "yyyyMMdd"
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$Head = (& git rev-parse HEAD).Trim()
$OriginMain = (& git rev-parse origin/main).Trim()
$StatusBefore = (& git status --short) -join "`n"

$PacketDir = Join-Path $Repo "HOUSE_WORK\IDEA_CONCEPT_COLLECTION_ROOM\HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_$DateKey"
$ProofDir = Join-Path $Repo "PROOF_HISTORY"
$RunnerDir = Join-Path $Repo "_LOCAL_RUNNERS\ROW_001_STATIC_PACKET"
$FixtureRootProposed = Join-Path $Repo "_LOCAL_FIXTURES\ROW_001_READ_ONLY_INSPECT_ACTIVE_TASK_V0_$DateKey"

New-Item -ItemType Directory -Path $PacketDir -Force | Out-Null
New-Item -ItemType Directory -Path $ProofDir -Force | Out-Null

$StaticReport = Join-Path $PacketDir "HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_REPORT_$DateKey.md"
$GitAdjudication = Join-Path $PacketDir "ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_$DateKey.md"
$AuthorityAdjudication = Join-Path $PacketDir "ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_$DateKey.md"
$UnknownAuthorityFinalCloseout = Join-Path $PacketDir "ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_$DateKey.md"

$RequiredInputs = @(
  $StaticReport,
  $GitAdjudication,
  $AuthorityAdjudication,
  $UnknownAuthorityFinalCloseout
)

$MissingInputs = @($RequiredInputs | Where-Object { -not (Test-Path -LiteralPath $_) })
if ($MissingInputs.Count -gt 0) {
  Stop-Clean "REQUIRED_STATIC_PROOF_MISSING" ($MissingInputs -join " | ")
}

$FixtureDesignPath = Join-Path $PacketDir "ROW_001_DISPOSABLE_FIXTURE_DESIGN_$DateKey.md"
$RunnerInventoryPath = Join-Path $PacketDir "ROW_001_LOCAL_RUNNER_CLUTTER_INVENTORY_$DateKey.csv"
$CloseoutPlanPath = Join-Path $PacketDir "ROW_001_RUNNER_CLUTTER_CLOSEOUT_PLAN_$DateKey.md"
$ErrorCapturePath = Join-Path $PacketDir "ROW_001_FIXTURE_DESIGN_RUNNER_ERROR_CAPTURE_$DateKey.md"
$ReceiptPath = Join-Path $ProofDir "ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_RECEIPT_$DateKey.txt"

$TargetSha = Get-Sha256 $TargetPath

$RunnerRows = @()
if (Test-Path -LiteralPath $RunnerDir) {
  $RunnerRows = @(Get-ChildItem -LiteralPath $RunnerDir -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    [pscustomobject]@{
      Path = (Resolve-Path -LiteralPath $_.FullName -Relative)
      Name = $_.Name
      Bytes = $_.Length
      Sha256 = Get-Sha256 $_.FullName
      CurrentDisposition = "USED_LOCAL_RUNNER_REFERENCE_DO_NOT_DELETE_BLIND"
    }
  })
}

$RunnerCsvLines = New-Object System.Collections.Generic.List[string]
$RunnerCsvLines.Add("Path,Name,Bytes,Sha256,CurrentDisposition") | Out-Null
foreach ($row in $RunnerRows) {
  $RunnerCsvLines.Add("$(Csv-Escape $row.Path),$(Csv-Escape $row.Name),$($row.Bytes),$(Csv-Escape $row.Sha256),$(Csv-Escape $row.CurrentDisposition)") | Out-Null
}
$RunnerInventoryCsvText = $RunnerCsvLines -join "`n"
Write-Utf8NoBom $RunnerInventoryPath $RunnerInventoryCsvText
$RunnerInventorySha = Get-Sha256 $RunnerInventoryPath
$RunnerCount = @($RunnerRows).Count

$ProofInputLines = New-Object System.Collections.Generic.List[string]
foreach ($inputPath in $RequiredInputs) {
  $ProofInputLines.Add("- $inputPath") | Out-Null
  $ProofInputLines.Add("  - SHA256: $(Get-Sha256 $inputPath)") | Out-Null
}
$ProofInputText = $ProofInputLines -join "`n"

$ErrorCaptureLines = @(
  "# Row 001 Fixture Design Runner Error Capture",
  "",
  "Date: $DateKey",
  "RunId: $RunId",
  "",
  "## Failure Class 1",
  "",
  "POWERSHELL_JOIN_PATH_ARRAY_ARGUMENT_BINDING_ERROR",
  "",
  "## Exact Error 1",
  "",
  "Join-Path: _LOCAL_RUNNERS\ROW_001_STATIC_PACKET\WRITE_ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_V1.ps1:79",
  "Cannot convert System.Object[] to the type System.String required by parameter AdditionalChildPath.",
  "",
  "## Lower-Layer Cause 1",
  "",
  "The V1 runner placed several Join-Path calls inside a PowerShell array without assigning each path separately first.",
  "",
  "## Failure Class 2",
  "",
  "POWERSHELL_UNSET_VARIABLE_FIXTURE_DESIGN",
  "",
  "## Exact Error 2",
  "",
  "InvalidOperation: _LOCAL_RUNNERS\ROW_001_STATIC_PACKET\WRITE_ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_V1_1.ps1:307",
  "The variable '$FixtureDesign' cannot be retrieved because it has not been set.",
  "",
  "## Lower-Layer Cause 2",
  "",
  "The V1.1 runner reached its write call before the fixture design text variable had been assigned.",
  "",
  "## Repair In This V1.2 Runner",
  "",
  "This runner builds every output text variable before writing.",
  "It assigns required proof paths separately before building the required input list.",
  "It checks required output variables before writing final report files.",
  "",
  "## Boundary",
  "",
  "Target helper executed: false",
  "Fixture executed: false",
  "Git add/commit/push: false",
  "Root cleanup: false",
  "Runner cleanup: false",
  "Pointer/state mutation: false"
)
$ErrorCaptureText = $ErrorCaptureLines -join "`n"
Write-Utf8NoBom $ErrorCapturePath $ErrorCaptureText
$ErrorCaptureSha = Get-Sha256 $ErrorCapturePath

$FixtureDesignLines = @(
  "# Row 001 Disposable Fixture Design",
  "",
  "Date: $DateKey",
  "RunId: $RunId",
  "Target: $TargetPath",
  "TargetSha256: $TargetSha",
  "DesignVerdict: DISPOSABLE_FIXTURE_DESIGN_READY_NOT_EXECUTED",
  "",
  "## Boundary",
  "",
  "This is design only.",
  "",
  "The target helper was not run.",
  "No Git add, commit, push, reset, checkout, clean, or root cleanup was performed.",
  "No pointer/state file was mutated.",
  "No fixture execution occurred in this step.",
  "",
  "## Static Proof Inputs",
  "",
  $ProofInputText,
  "",
  "## Fixture Mission",
  "",
  "Test READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1 only against disposable artificial inputs before any real project-state run.",
  "",
  "The fixture must prove whether the helper reads only expected fixture paths, writes nothing, does not mutate Git, does not clean root, does not modify pointer/state files, returns bounded report text, treats missing or malformed pointer data as watch/stop/report only, emits DoesNotProve and StopLine, separates PASS wording from save/lock authority, and keeps NO_MUTATION truthful.",
  "",
  "## Proposed Fixture Root",
  "",
  $FixtureRootProposed,
  "",
  "This design file does not create the fixture root yet.",
  "",
  "## Disposable Fixture Cases",
  "",
  "### Case 001 — Missing pointer file",
  "",
  "Purpose: prove missing pointer returns a pointer-missing card or watch result, not mutation.",
  "",
  "Expected: no files written by target helper; no Git mutation; output includes pointer missing condition; output includes stop/next legal action; output includes no-mutation claim only as report text.",
  "",
  "### Case 002 — Malformed pointer JSON",
  "",
  "Purpose: prove invalid JSON returns warning/blocking report only.",
  "",
  "Expected: no repair attempt; no overwrite; no cleanup; warning/blocker output only.",
  "",
  "### Case 003 — Valid minimal pointer, active task open",
  "",
  "Purpose: prove a minimal active pointer can be inspected without mutation.",
  "",
  "Expected: output card returns active task fields; no mutation; no Git mutation; no claim of real project proof.",
  "",
  "### Case 004 — Valid SAVED_AND_CLOSED pointer",
  "",
  "Purpose: prove status value read does not become save authority.",
  "",
  "Expected: output can say card type, but must not claim it saved anything now; no mutation; DoesNotProve and StopLine retained.",
  "",
  "### Case 005 — ExpectedRepoHead mismatch",
  "",
  "Purpose: prove repo-head mismatch becomes WATCH only.",
  "",
  "Expected: warning category GIT_READ_STATUS_MISMATCH; no repair; no Git mutation; no root cleanup.",
  "",
  "## Required Harness Rules For Later Execution",
  "",
  "A later fixture-run harness must snapshot fixture tree before and after, snapshot repo status before and after, run target helper only with fixture paths, verify no files changed except fixture-run report files written by the harness itself, verify target helper stdout and stderr only, capture exit code, preserve command/cwd/target hash/fixture hash, stop on first unexpected write, avoid real pointer/state files, and avoid PASS unless all checks pass.",
  "",
  "## Explicit Non-Authority",
  "",
  "This design does not authorize running the target helper.",
  "This design does not promote the helper.",
  "This design does not repair the helper.",
  "This design does not clean _LOCAL_RUNNERS.",
  "",
  "Next legal move: BUILD_DISPOSABLE_FIXTURE_RUN_HARNESS_OR_CLOSEOUT_RUNNER_CLUTTER_BY_PLAN"
)
$FixtureDesignText = $FixtureDesignLines -join "`n"

$RunnerCloseoutPlanLines = @(
  "# Row 001 Local Runner Clutter Closeout Plan",
  "",
  "Date: $DateKey",
  "RunId: $RunId",
  "PlanVerdict: RUNNER_CLUTTER_INVENTORIED_NOT_CLOSED",
  "",
  "## Boundary",
  "",
  "This is an inventory and plan only.",
  "",
  "No runner files were deleted.",
  "No runner files were moved.",
  "No runner files were added to Git.",
  "No ignore file was edited.",
  "No cleanup was performed.",
  "",
  "## Runner Folder",
  "",
  $RunnerDir,
  "",
  "## Runner Inventory",
  "",
  "InventoryCsv: $RunnerInventoryPath",
  "InventorySha256: $RunnerInventorySha",
  "RunnerCount: $RunnerCount",
  "",
  "## Problem",
  "",
  "_LOCAL_RUNNERS is currently untracked. It was useful for file-first recovery, but it should not remain ambiguous.",
  "",
  "## Acceptable Closeout Options",
  "",
  "Option A — Keep local-only and ignored.",
  "Option B — Archive selected runner files as evidence copies with hashes.",
  "Option C — Delete after evidence is preserved.",
  "",
  "## Recommended Closeout",
  "",
  "Option B for the specific Row 001 recovery runners, then Option A or C for the working local runner folder.",
  "",
  "Reason: the repeated runner failures are part of the lower-layer learning evidence, but the live _LOCAL_RUNNERS folder should not become a tracked junk lane by accident.",
  "",
  "## Stop Line",
  "",
  "Do not delete or move _LOCAL_RUNNERS until a closeout action is explicitly selected."
)
$RunnerCloseoutPlanText = $RunnerCloseoutPlanLines -join "`n"

foreach ($varName in @("FixtureDesignText","RunnerCloseoutPlanText","RunnerInventoryCsvText","ErrorCaptureText")) {
  $var = Get-Variable -Name $varName -ErrorAction SilentlyContinue
  if ($null -eq $var -or [string]::IsNullOrWhiteSpace([string]$var.Value)) {
    Stop-Clean "INTERNAL_OUTPUT_TEXT_NOT_READY" $varName
  }
}

Write-Utf8NoBom $FixtureDesignPath $FixtureDesignText
Write-Utf8NoBom $CloseoutPlanPath $RunnerCloseoutPlanText

$FixtureDesignSha = Get-Sha256 $FixtureDesignPath
$CloseoutPlanSha = Get-Sha256 $CloseoutPlanPath

$StatusAfter = (& git status --short) -join "`n"

$ReceiptLines = @(
  "ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_RECEIPT",
  "RunId: $RunId",
  "Date: $DateKey",
  "Verdict: DISPOSABLE_FIXTURE_DESIGN_READY_NOT_EXECUTED / RUNNER_CLUTTER_INVENTORIED_NOT_CLOSED",
  "",
  "Target: $TargetPath",
  "TargetSha256: $TargetSha",
  "",
  "FixtureDesign: $FixtureDesignPath",
  "FixtureDesignSha256: $FixtureDesignSha",
  "",
  "RunnerInventory: $RunnerInventoryPath",
  "RunnerInventorySha256: $RunnerInventorySha",
  "RunnerCount: $RunnerCount",
  "",
  "RunnerCloseoutPlan: $CloseoutPlanPath",
  "RunnerCloseoutPlanSha256: $CloseoutPlanSha",
  "",
  "ErrorCapture: $ErrorCapturePath",
  "ErrorCaptureSha256: $ErrorCaptureSha",
  "",
  "StaticProofInputs:",
  ($RequiredInputs -join "`n"),
  "",
  "Repo: $Repo",
  "Head: $Head",
  "OriginMain: $OriginMain",
  "HeadEqualsOrigin: $($Head -eq $OriginMain)",
  "",
  "Boundary:",
  "TargetHelperExecuted: False",
  "FixtureExecuted: False",
  "GitAddCommitPush: False",
  "RootCleanup: False",
  "RunnerCleanup: False",
  "PointerStateMutation: False",
  "",
  "StatusBefore:",
  $StatusBefore,
  "",
  "StatusAfter:",
  $StatusAfter
)
$ReceiptText = $ReceiptLines -join "`n"
Write-Utf8NoBom $ReceiptPath $ReceiptText
$ReceiptSha = Get-Sha256 $ReceiptPath

Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
Write-Host "ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_COMPLETE"
Write-Host "RunId: $RunId"
Write-Host "Verdict: DISPOSABLE_FIXTURE_DESIGN_READY_NOT_EXECUTED / RUNNER_CLUTTER_INVENTORIED_NOT_CLOSED"
Write-Host "Target: $TargetPath"
Write-Host "TargetSha256: $TargetSha"
Write-Host "FixtureDesign: $FixtureDesignPath"
Write-Host "FixtureDesignSha256: $FixtureDesignSha"
Write-Host "RunnerInventory: $RunnerInventoryPath"
Write-Host "RunnerInventorySha256: $RunnerInventorySha"
Write-Host "RunnerCount: $RunnerCount"
Write-Host "RunnerCloseoutPlan: $CloseoutPlanPath"
Write-Host "RunnerCloseoutPlanSha256: $CloseoutPlanSha"
Write-Host "ErrorCapture: $ErrorCapturePath"
Write-Host "ErrorCaptureSha256: $ErrorCaptureSha"
Write-Host "Receipt: $ReceiptPath"
Write-Host "ReceiptSha256: $ReceiptSha"
Write-Host "Head: $Head"
Write-Host "OriginMain: $OriginMain"
Write-Host "HeadEqualsOrigin: $($Head -eq $OriginMain)"
Write-Host "FinalGitStatusShort:"
if ([string]::IsNullOrWhiteSpace($StatusAfter)) { Write-Host "<clean>" } else { Write-Host $StatusAfter }
Write-Host "TargetHelperExecuted: False"
Write-Host "FixtureExecuted: False"
Write-Host "GitAddCommitPush: False"
Write-Host "RootCleanup: False"
Write-Host "RunnerCleanup: False"
Write-Host "PointerStateMutation: False"
Write-Host "NEXT: BUILD_DISPOSABLE_FIXTURE_RUN_HARNESS_OR_SELECT_RUNNER_CLOSEOUT_OPTION"
Write-Host "XxXxX ===== COPY BACK TO_CHAT END ===== XxXxX"
