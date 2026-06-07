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

$FixtureDesignPath = Join-Path $PacketDir "ROW_001_DISPOSABLE_FIXTURE_DESIGN_$DateKey.md"
$RunnerInventoryPath = Join-Path $PacketDir "ROW_001_LOCAL_RUNNER_CLUTTER_INVENTORY_$DateKey.csv"
$CloseoutPlanPath = Join-Path $PacketDir "ROW_001_RUNNER_CLUTTER_CLOSEOUT_PLAN_$DateKey.md"
$ErrorCapturePath = Join-Path $PacketDir "ROW_001_FIXTURE_DESIGN_RUNNER_V1_JOIN_PATH_ERROR_CAPTURE_$DateKey.md"
$ReceiptPath = Join-Path $ProofDir "ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_RECEIPT_$DateKey.txt"

$TargetSha = Get-Sha256 $TargetPath

$PriorJoinPathErrorText = @'
Join-Path: _LOCAL_RUNNERS\ROW_001_STATIC_PACKET\WRITE_ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_V1.ps1:79
Line |
  79 |    Join-Path $PacketDir "HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE …
     |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot convert 'System.Object[]' to the type 'System.String' required by parameter 'AdditionalChildPath'.
     | Specified method is not supported.
'@

$JoinPathErrorCapture = @"
# Row 001 Fixture Design Runner V1 Join-Path Error Capture

Date: $DateKey
RunId: $RunId

## Failure Class

POWERSHELL_JOIN_PATH_ARRAY_ARGUMENT_BINDING_ERROR

## Exact Error

$PriorJoinPathErrorText

## Lower-Layer Cause

The V1 runner placed several `Join-Path` calls inside a PowerShell array without wrapping each call in parentheses.

PowerShell interpreted the comma-separated following values as extra child path arguments to the first `Join-Path` call, producing a `System.Object[]` binding error.

## Repair In This V1.1 Runner

Each `Join-Path` call inside `$RequiredInputs` is wrapped in parentheses before being placed in the array.

## Boundary

Target helper executed: false
Fixture executed: false
Git add/commit/push: false
Root cleanup: false
Runner cleanup: false
Pointer/state mutation: false
"@

Write-Utf8NoBom $ErrorCapturePath $JoinPathErrorCapture

$RequiredInputs = @(
  (Join-Path $PacketDir "HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_REPORT_$DateKey.md"),
  (Join-Path $PacketDir "ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_$DateKey.md"),
  (Join-Path $PacketDir "ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_$DateKey.md"),
  (Join-Path $PacketDir "ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_$DateKey.md")
)

$MissingInputs = @($RequiredInputs | Where-Object { -not (Test-Path -LiteralPath $_) })

if ($MissingInputs.Count -gt 0) {
  Stop-Clean "REQUIRED_STATIC_PROOF_MISSING" ($MissingInputs -join " | ")
}

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

$RunnerCsv = "Path,Name,Bytes,Sha256,CurrentDisposition`n" + (($RunnerRows | ForEach-Object {
  "$(Csv-Escape $_.Path),$(Csv-Escape $_.Name),$($_.Bytes),$(Csv-Escape $_.Sha256),$(Csv-Escape $_.CurrentDisposition)"
}) -join "`n")
Write-Utf8NoBom $RunnerInventoryPath $RunnerCsv

$RunnerCount = $RunnerRows.Count
$RunnerInventorySha = Get-Sha256 $RunnerInventoryPath

$ProofInputLines = (($RequiredInputs | ForEach-Object {
  "- $_`n  - SHA256: $(Get-Sha256 $_)"
}) -join "`n")

$FixtureDesign = @"
# Row 001 Disposable Fixture Design

Date: $DateKey
RunId: $RunId
Target: $TargetPath
TargetSha256: $TargetSha
DesignVerdict: DISPOSABLE_FIXTURE_DESIGN_READY_NOT_EXECUTED

## Boundary

This is design only.

The target helper was not run.
No Git add, commit, push, reset, checkout, clean, or root cleanup was performed.
No pointer/state file was mutated.
No fixture execution occurred in this step.

## Static Proof Inputs

$ProofInputLines

## Fixture Mission

Test `READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1` only against disposable, artificial inputs before any real project-state run.

The fixture must prove whether the helper:

1. reads only expected fixture paths;
2. writes nothing;
3. does not mutate Git;
4. does not clean root;
5. does not modify pointer/state files;
6. returns bounded report text;
7. treats missing or malformed pointer data as watch/stop/report only;
8. emits `DoesNotProve` and `StopLine`;
9. separates `PASS` wording from save/lock authority;
10. keeps `NO_MUTATION` truthful.

## Proposed Fixture Root

`$FixtureRootProposed`

This design file does not create the fixture root yet.

## Disposable Fixture Cases

### Case 001 — Missing pointer file

Purpose: prove missing pointer returns a pointer-missing card or watch result, not mutation.

Inputs:
- disposable base root;
- disposable repo root;
- pointer path points to a missing file.

Expected:
- no files written by target helper;
- no Git mutation;
- output includes pointer missing condition;
- output includes stop/next legal action;
- output includes no-mutation claim only as report text.

### Case 002 — Malformed pointer JSON

Purpose: prove invalid JSON returns warning/blocking report only.

Inputs:
- pointer file containing deliberately malformed JSON.

Expected:
- no repair attempt;
- no overwrite;
- no cleanup;
- warning/blocker output only.

### Case 003 — Valid minimal pointer, active task open

Purpose: prove a minimal active pointer can be inspected without mutation.

Inputs:
- valid JSON with PointerStatus not closed;
- basic active fields;
- blocked powers included.

Expected:
- output card returns active task fields;
- no mutation;
- no Git mutation;
- no claim of real project proof.

### Case 004 — Valid `SAVED_AND_CLOSED` pointer

Purpose: prove status value read does not become save authority.

Inputs:
- valid JSON with `PointerStatus = SAVED_AND_CLOSED`.

Expected:
- output can say card type, but must not claim it saved anything now;
- no mutation;
- `DoesNotProve` and `StopLine` retained.

### Case 005 — ExpectedRepoHead mismatch

Purpose: prove repo-head mismatch becomes WATCH only.

Inputs:
- pass an intentionally wrong ExpectedRepoHead to the target helper inside disposable fixture.

Expected:
- warning category `GIT_READ_STATUS_MISMATCH`;
- no repair;
- no Git mutation;
- no root cleanup.

## Required Harness Rules For Later Execution

A later fixture-run harness must:

1. snapshot fixture tree before and after;
2. snapshot repo status before and after;
3. run target helper only with fixture paths;
4. verify no files changed except fixture-run report files written by the harness itself;
5. verify target helper stdout/stderr only;
6. capture exit code;
7. preserve command, cwd, target hash, and fixture hash;
8. stop on first unexpected write;
9. not run against real pointer/state files;
10. not print PASS unless all checks pass.

## Explicit Non-Authority

This design does not authorize running the target helper.

This design does not promote the helper.

This design does not repair the helper.

This design does not clean `_LOCAL_RUNNERS`.

Next legal move:
`BUILD_DISPOSABLE_FIXTURE_RUN_HARNESS_OR_CLOSEOUT_RUNNER_CLUTTER_BY_PLAN`
"@

Write-Utf8NoBom $FixtureDesignPath $FixtureDesign
$FixtureDesignSha = Get-Sha256 $FixtureDesignPath

$RunnerPlan = @"
# Row 001 Local Runner Clutter Closeout Plan

Date: $DateKey
RunId: $RunId
PlanVerdict: RUNNER_CLUTTER_INVENTORIED_NOT_CLOSED

## Boundary

This is an inventory and plan only.

No runner files were deleted.
No runner files were moved.
No runner files were added to Git.
No ignore file was edited.
No cleanup was performed.

## Runner Folder

`$RunnerDir`

## Runner Inventory

InventoryCsv: `$RunnerInventoryPath`
InventorySha256: `$RunnerInventorySha`
RunnerCount: $RunnerCount

## Problem

`_LOCAL_RUNNERS/` is currently untracked. It was useful for file-first recovery, but it should not remain ambiguous.

## Acceptable Closeout Options

### Option A — Keep Local-Only, Ignored

Use if these runners are disposable operational residue.

Action later:
- add or confirm ignore rule for `_LOCAL_RUNNERS/`;
- keep hash inventory/receipt in tracked proof if the packet is later committed;
- do not track runner bodies.

### Option B — Archive As Evidence Copy

Use if runner source is part of the proof story.

Action later:
- copy selected runner files into a tracked packet evidence folder;
- hash them;
- commit only selected copies, not the working `_LOCAL_RUNNERS/` folder.

### Option C — Delete After Evidence

Use only after hashes and needed source copies are saved.

Action later:
- delete `_LOCAL_RUNNERS/ROW_001_STATIC_PACKET` only after evidence preservation;
- record cleanup receipt.

## Recommended Closeout

Option B for the specific Row 001 recovery runners, then Option A or C for the working local runner folder.

Reason:
The repeated runner failures are part of the lower-layer learning evidence, so the final used runners and failure-chain runners may matter. But the live `_LOCAL_RUNNERS/` folder should not become a tracked junk lane by accident.

## Stop Line

Do not delete or move `_LOCAL_RUNNERS/` until a closeout action is explicitly selected.
"@

Write-Utf8NoBom $CloseoutPlanPath $RunnerPlan
$CloseoutPlanSha = Get-Sha256 $CloseoutPlanPath

$StatusAfter = (& git status --short) -join "`n"

$Receipt = @"
ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_RECEIPT
RunId: $RunId
Date: $DateKey
Verdict: DISPOSABLE_FIXTURE_DESIGN_READY_NOT_EXECUTED / RUNNER_CLUTTER_INVENTORIED_NOT_CLOSED

Target: $TargetPath
TargetSha256: $TargetSha

FixtureDesign: $FixtureDesignPath
FixtureDesignSha256: $FixtureDesignSha

RunnerInventory: $RunnerInventoryPath
RunnerInventorySha256: $RunnerInventorySha
RunnerCount: $RunnerCount

RunnerCloseoutPlan: $CloseoutPlanPath
RunnerCloseoutPlanSha256: $CloseoutPlanSha

ErrorCapture: $ErrorCapturePath
ErrorCaptureSha256: $(Get-Sha256 $ErrorCapturePath)

StaticProofInputs:
$($RequiredInputs -join "`n")

Repo: $Repo
Head: $Head
OriginMain: $OriginMain
HeadEqualsOrigin: $($Head -eq $OriginMain)

Boundary:
TargetHelperExecuted: False
FixtureExecuted: False
GitAddCommitPush: False
RootCleanup: False
RunnerCleanup: False
PointerStateMutation: False

StatusBefore:
$StatusBefore

StatusAfter:
$StatusAfter
"@

Write-Utf8NoBom $ReceiptPath $Receipt
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
Write-Host "ErrorCaptureSha256: $(Get-Sha256 $ErrorCapturePath)"
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
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"
