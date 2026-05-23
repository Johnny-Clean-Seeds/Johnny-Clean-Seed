$ErrorActionPreference = "Stop"

function Write-Utf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Value
    )
    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
    }
    Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8
}

function Assert-CleanGit {
    $Status = git status --short
    if ($LASTEXITCODE -ne 0) {
        throw "STOP. git status failed."
    }
    if (-not [string]::IsNullOrWhiteSpace(($Status | Out-String).Trim())) {
        throw "STOP. Mr.Kleen repo is not clean before save. Resolve or show status first.`n$($Status | Out-String)"
    }
}

function Assert-ReceiptHash {
    param(
        [Parameter(Mandatory=$true)][string]$Label,
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$ExpectedHash
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "STOP. Missing proof receipt for $Label`: $Path"
    }
    $ActualHash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($ActualHash -ne $ExpectedHash) {
        throw "STOP. Hash mismatch for $Label`nPath: $Path`nExpected: $ExpectedHash`nActual:   $ActualHash"
    }
    return $ActualHash
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "STOP. Run this in Mr.Kleen: C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
}

$RepoRoot = (Get-Location).Path
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Date = Get-Date -Format "yyyyMMdd"
$BaseHead = (git rev-parse --short HEAD).Trim()
$BaseBranch = (git branch --show-current).Trim()

Assert-CleanGit

$CC = "C:\Users\13527\Desktop\123\COMMAND_CENTER"

$Level0Receipt = Join-Path $CC "CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000001-CHILD-SHELL-PROBE.receipt.txt"
$Level0InstallReceipt = Join-Path $CC "RECEIPTS\CHILD_SHELL_LEVEL0_ROUTE_INSTALL_RECEIPT_20260521_034024.txt"
$Level1Receipt = Join-Path $CC "CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000002-READ-COMMAND-CENTER-STATUS.receipt.txt"
$Level1InstallReceipt = Join-Path $CC "RECEIPTS\CHILD_SHELL_LEVEL1_READ_STATUS_INSTALL_RECEIPT_20260521_034321.txt"
$WatcherSelfTestReceipt = Join-Path $CC "CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000004-WATCHER-PID-REPAIR-SELFTEST.receipt.txt"
$WatcherRepairReceipt = Join-Path $CC "RECEIPTS\CHILD_SHELL_WATCHER_PID_COLLISION_REPAIR_RECEIPT_20260521_035256.txt"

$Level0Hash = Assert-ReceiptHash -Label "Level 0 probe consumption" -Path $Level0Receipt -ExpectedHash "92D929697B7A556D470D3AB2E3C0A605BA6D3FD31CA397E261DFFB897519D59D"
$Level0InstallHash = Assert-ReceiptHash -Label "Level 0 install" -Path $Level0InstallReceipt -ExpectedHash "25326BF28B5C74FA05B767A96DD140B8A85A0821783FC4432A0AAE0F0794310D"
$Level1Hash = Assert-ReceiptHash -Label "Level 1 read-status consumption" -Path $Level1Receipt -ExpectedHash "77ACC8F139188DC4153FD776B34B0D393091EAE2681514FF06E1A0F2D6CA7F31"
$Level1InstallHash = Assert-ReceiptHash -Label "Level 1 install" -Path $Level1InstallReceipt -ExpectedHash "64AE57E6C02E3646C1FE3AF1AB7128821AC75167ACF8A16F7DD40EB8CB888F66"
$WatcherSelfTestHash = Assert-ReceiptHash -Label "Watcher PID repair self-test" -Path $WatcherSelfTestReceipt -ExpectedHash "CEB432FB18B672129EA5DA5565E146E24E2F21C2501134D62254DA66E0095E6C"
$WatcherRepairHash = Assert-ReceiptHash -Label "Watcher PID repair receipt" -Path $WatcherRepairReceipt -ExpectedHash "5E124F7C8AA2F1F63B4CB3138AFDFF123732E68FFE069BFAE752359B9B8619C7"

$ProofPath = "PROOF_HISTORY\CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_RECEIPT_$Date.txt"
$ReviewPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_REVIEW_$Date.md"
$ChildShellRulePath = "BRAIN_LEARNING\CHILD_SHELL_LEVEL0_LEVEL1_WATCHER_ROUTE_PROOF_RULE_$Date.md"
$ProblemSolverRulePath = "BRAIN_LEARNING\PROBLEM_SOLVER_SWEEP_AND_SINGLE_BOSS_COLLAPSE_RULE_$Date.md"
$ArtifactRulePath = "BRAIN_LEARNING\FILE_FIRST_ARTIFACT_WITH_LAUNCHER_BALANCE_RULE_$Date.md"
$GearCardPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\RULE_MACHINES\PROBLEM_SOLVER_SWEEP_SINGLE_BOSS_COLLAPSE_CARD_$Date.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$ExistingTargets = @($ProofPath, $ReviewPath, $ChildShellRulePath, $ProblemSolverRulePath, $ArtifactRulePath, $GearCardPath)
foreach ($Target in $ExistingTargets) {
    if (Test-Path -LiteralPath $Target) {
        throw "STOP. Refusing to overwrite existing target: $Target"
    }
}

$ChildShellRule = @"
# Child Shell Level 0 / Level 1 / Watcher Route Proof Rule — $Date

## Status

PASS AS LOCAL COMMAND CENTER ROUTE PROOF / NOT HOUSE-SAVE EXECUTION

## What Is Proved

Level 0 proved that the Child Shell can consume one allowlisted probe job and produce an OUTBOX receipt.

Level 1 proved that the Child Shell can consume one allowlisted Command Center read-status job and produce an OUTBOX receipt.

Watcher trigger repair proved that a running watcher can accept a dropped Level 1 read-status childjob, route it through the Child Shell lane, and produce a self-test OUTBOX receipt after the PowerShell `$PID collision was repaired.

## Proof Receipts

Level 0 probe receipt:

$Level0Receipt

SHA256:

$Level0Hash

Level 0 install receipt:

$Level0InstallReceipt

SHA256:

$Level0InstallHash

Level 1 read-status receipt:

$Level1Receipt

SHA256:

$Level1Hash

Level 1 install receipt:

$Level1InstallReceipt

SHA256:

$Level1InstallHash

Watcher PID repair self-test receipt:

$WatcherSelfTestReceipt

SHA256:

$WatcherSelfTestHash

Watcher PID repair receipt:

$WatcherRepairReceipt

SHA256:

$WatcherRepairHash

## Boundary

This does not prove arbitrary local execution.

This does not prove Level 2 approved-helper execution.

This does not prove Level 3 Mr.Kleen house-save execution.

This does not allow raw shell expansion.

This does not allow delete, broad filesystem crawl, permission expansion, junction/symlink teleporter, doctrine install, ACTIVE_GUIDES rewrite, or CURRENT_TRUTH_INDEX rewrite.

## Active Use

Use the watcher route only for allowlisted childjobs in the Command Center Child Shell lane until Level 2/Level 3 are separately designed, proved, and saved.

## Next Allowed Boss

Design a bounded Level 2 approved-helper route only if it is needed. Otherwise keep using Level 1 read-status watcher drops as the live trigger path.
"@

$ProblemSolverRule = @"
# Problem Solver Sweep and Single-Boss Collapse Rule — $Date

## Status

ACTIVE PROVISIONAL RULE / SAVED AFTER LIVE FAILURE REPAIR

## Trigger

Use this when a task hits an execution issue, generated artifact issue, command issue, proof issue, or overcorrection issue.

## Required Sweep

1. Name the active issue.
2. Name the concrete root cause.
3. Capture the prevention rule or stack.
4. Patch the failing artifact or route.
5. Test the patched route.
6. Report the fix proof.
7. Return to the original task outcome.

## Collapse Requirement

During an active blocker, solve one boss only.

Do not fan out into broad infrastructure, extra architecture, rule-folder expansion, unrelated scripts, or multi-branch analysis unless the user explicitly selects that route.

## Live Example

The watcher failed because PowerShell variable names are case-insensitive and `$Pid collided with the read-only automatic `$PID variable.

Correct response:

Repair the watcher variable names only, rerun the watcher self-test, and return to the watcher task.

Incorrect response:

Build a large general Problem Solver infrastructure package while the active blocker is still only the PID collision.

## Balanced Rule

Problem solving should be connected, not sprawling.

Small blocker gets small patch.

Whole connected task gets one clean sweep.

Proof decides completion.
"@

$ArtifactRule = @"
# File-First Artifact With Launcher Balance Rule — $Date

## Status

ACTIVE PROVISIONAL RULE / SAVED AFTER OVERCORRECTION REPAIR

## Original Error

Sending duplicate artifacts for one file, such as a `.ps1` plus a wrapper `.zip`, creates unnecessary bloat and confusion.

## Overcorrection

Stopping the launcher command created the opposite failure because the user still needed the exact command to run the downloaded artifact.

## Balanced Rule

One File = One Download means no duplicate wrapper artifact for a single file.

It does not mean omit the launcher command.

Correct delivery:

1. One artifact link.
2. One clean launcher block when the user must run or use the artifact.

## Clean Copy Block Requirement

The launcher copy block must contain only the exact runnable command.

No explanation inside the block.

No extra chat text in the block.

Use the actual known file location, not assumed Downloads, when the user has shown or stated a different folder.
"@

$GearCard = @"
# Problem Solver Sweep + Single-Boss Collapse Card — $Date

## Call This Card When

A task hits an issue and the assistant starts to drift into broad analysis or multiple fixes.

## Collapse Sentence

The active blocker is one thing. Solve that one thing first.

## Route

Issue -> root cause -> prevention stack -> smallest patch -> test -> proof -> return to original task.

## Blocks

Do not add unrelated infrastructure.

Do not make multiple repair artifacts.

Do not convert a one-line bug into a full subsystem unless selected.

Do not continue without proof.

## Current Proven Pattern

PowerShell `$PID collision in watcher route:

Patch variable names.

Rerun watcher self-test.

Save proof.

Return to Child Shell route.
"@

$Review = @"
# Child Shell Watcher and Problem Solver Lock-Save Review — $Date

## Verdict

PASS / APPLY ALL ACCEPTED STACK

## Inputs Locked

- Child Shell Level 0 probe consumption.
- Child Shell Level 1 read-status consumption.
- Child Shell watcher trigger route after PID collision repair.
- File-first artifact balance correction.
- Overcorrection Repair Gate.
- Problem Solver Sweep.
- Single-Boss Collapse Analysis Gate.

## Proof State

Level 0: proved job consumption.

Level 1: proved safe read-status job consumption.

Watcher: proved running and self-tested after `$PID collision repair.

Level 2: not installed.

Level 3: not installed.

## Root Cause Captured

The watcher failure came from assigning to `$Pid, which collides with PowerShell's read-only automatic `$PID variable because PowerShell variable names are case-insensitive.

## Prevention Stack

Use `$WatcherPidText, `$ExistingWatcherPidText, `$WatcherProcess, or similar non-automatic names for process IDs.

When an issue interrupts a task, perform one connected Problem Solver sweep.

During an active blocker, apply Single-Boss Collapse before creating more code or analysis.

When sending file-first artifacts, send one artifact plus one launcher command when needed.

## Boundary Held

No doctrine rewrite.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No Level 2/Level 3 promotion.

No raw shell expansion.

No broad filesystem crawl.

No permission expansion.

No junction/symlink teleporter.

No delete route.

No Mr.Kleen repo write happened through the Command Center Child Shell route.
"@

$Receipt = @"
CHILD SHELL WATCHER AND PROBLEM SOLVER LOCK SAVE RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / APPLY ALL ACCEPTED STACK SAVED

Repo:
$RepoRoot

Branch before save:
$BaseBranch

HEAD before save:
$BaseHead

Saved files:
$ChildShellRulePath
$ProblemSolverRulePath
$ArtifactRulePath
$GearCardPath
$ReviewPath
$ProofPath

Validated Command Center proof receipts:
Level 0 probe receipt: $Level0Receipt
Level 0 probe SHA256: $Level0Hash

Level 0 install receipt: $Level0InstallReceipt
Level 0 install SHA256: $Level0InstallHash

Level 1 read-status receipt: $Level1Receipt
Level 1 read-status SHA256: $Level1Hash

Level 1 install receipt: $Level1InstallReceipt
Level 1 install SHA256: $Level1InstallHash

Watcher repair self-test receipt: $WatcherSelfTestReceipt
Watcher repair self-test SHA256: $WatcherSelfTestHash

Watcher PID repair receipt: $WatcherRepairReceipt
Watcher PID repair SHA256: $WatcherRepairHash

Applied rules:
- Child Shell Level 0 / Level 1 / watcher route proof boundary.
- File-first artifact with launcher balance.
- Overcorrection Repair Gate.
- Problem Solver Sweep.
- Single-Boss Collapse Analysis Gate.

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No Level 2/Level 3 promotion.
No raw shell expansion.
No delete route.
No permission expansion.
No junction/symlink teleporter.
No broad filesystem crawl.
No Command Center route was used to write Mr.Kleen repo files.

Next:
Use watcher route for Level 1 read-status childjob drops only, or design Level 2 approved-helper route as the next separate boss.
"@

Write-Utf8 -Path $ChildShellRulePath -Value $ChildShellRule
Write-Utf8 -Path $ProblemSolverRulePath -Value $ProblemSolverRule
Write-Utf8 -Path $ArtifactRulePath -Value $ArtifactRule
Write-Utf8 -Path $GearCardPath -Value $GearCard
Write-Utf8 -Path $ReviewPath -Value $Review
Write-Utf8 -Path $ProofPath -Value $Receipt

$Anchor = @"
Current active ball:
Child Shell Level 0, Level 1, watcher trigger, PID collision repair, and related Problem Solver/Collapse/Artifact-balance rules have been locked as an apply-all save.

Current proof:
Level 0 PASS.
Level 1 PASS.
Watcher trigger PASS after PID collision repair.
Level 2 not installed.
Level 3 not installed.

Next allowed boss:
Use watcher route for Level 1 read-status childjob drops only, or design Level 2 approved-helper route as a separate bounded boss.

Boundary:
No raw shell expansion. No Command Center house-save execution. No Level 2/Level 3 promotion without separate proof.
"@

Write-Utf8 -Path $AnchorPath -Value $Anchor

$StatusAppend = @"

## $Date — Child Shell watcher and Problem Solver apply-all save

Verdict: PASS / APPLY ALL ACCEPTED STACK SAVED.

Proof locked:
- Level 0 Child Shell probe job consumption.
- Level 1 Command Center read-status job consumption.
- Watcher trigger route after PowerShell PID collision repair.
- File-first artifact balance rule.
- Problem Solver Sweep.
- Single-Boss Collapse Analysis Gate.

Next: Level 1 watcher read-status drops are allowed. Level 2/Level 3 remain blocked until separately installed and proved.

Boundary: no doctrine rewrite, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no raw shell expansion, no permission expansion, no junction/symlink teleporter, no broad filesystem crawl.
"@

if (Test-Path -LiteralPath $StatusPath) {
    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
}
else {
    Write-Utf8 -Path $StatusPath -Value $StatusAppend.TrimStart()
}

$CreatedHashes = @()
foreach ($Path in @($ChildShellRulePath, $ProblemSolverRulePath, $ArtifactRulePath, $GearCardPath, $ReviewPath, $ProofPath, $AnchorPath, $StatusPath)) {
    $CreatedHashes += "$Path SHA256: $((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash)"
}

git add -- $ChildShellRulePath $ProblemSolverRulePath $ArtifactRulePath $GearCardPath $ReviewPath $ProofPath $AnchorPath $StatusPath
if ($LASTEXITCODE -ne 0) {
    throw "STOP. git add failed."
}

$Staged = git diff --cached --name-only
if ([string]::IsNullOrWhiteSpace(($Staged | Out-String).Trim())) {
    throw "STOP. Nothing staged. Save did not create changes."
}

git commit -m "Lock child shell watcher and problem solver gates"
if ($LASTEXITCODE -ne 0) {
    throw "STOP. git commit failed."
}

git push
if ($LASTEXITCODE -ne 0) {
    throw "STOP. git push failed."
}

$FinalHead = (git rev-parse --short HEAD).Trim()
$FinalFullHead = (git rev-parse HEAD).Trim()
$OriginHead = (git rev-parse --short origin/main).Trim()
$FinalStatus = git status --short

if (-not [string]::IsNullOrWhiteSpace(($FinalStatus | Out-String).Trim())) {
    throw "STOP. Save committed but final repo status is not clean.`n$($FinalStatus | Out-String)"
}

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL WATCHER AND PROBLEM SOLVER APPLY-ALL LOCK SAVED"
Write-Host "Verdict: PASS / SAVED AND PUSHED"
Write-Host "Branch: $BaseBranch"
Write-Host "Previous HEAD: $BaseHead"
Write-Host "Current HEAD: $FinalHead"
Write-Host "Current HEAD full: $FinalFullHead"
Write-Host "Origin main: $OriginHead"
Write-Host "Status: clean"
Write-Host "Saved files:"
foreach ($Path in @($ChildShellRulePath, $ProblemSolverRulePath, $ArtifactRulePath, $GearCardPath, $ReviewPath, $ProofPath, $AnchorPath, $StatusPath)) {
    Write-Host "- $Path"
}
Write-Host "Validated proof receipts:"
Write-Host "- Level0 probe: $Level0Hash"
Write-Host "- Level0 install: $Level0InstallHash"
Write-Host "- Level1 read-status: $Level1Hash"
Write-Host "- Level1 install: $Level1InstallHash"
Write-Host "- Watcher self-test: $WatcherSelfTestHash"
Write-Host "- Watcher PID repair: $WatcherRepairHash"
Write-Host "Boundary: no doctrine rewrite; no ACTIVE_GUIDES rewrite; no CURRENT_TRUTH_INDEX rewrite; no Level2/Level3 promotion; no raw shell expansion; no delete; no permission expansion; no junction/symlink teleporter; no broad filesystem crawl."
Write-Host "Next: Level1 watcher read-status drops are allowed; Level2 approved-helper route remains the next separate boss if selected."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
