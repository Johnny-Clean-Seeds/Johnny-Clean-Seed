$ErrorActionPreference = "Stop"

function Stop-Fail {
    param([Parameter(Mandatory=$true)][string]$Message)
    throw "STOP. $Message"
}

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

function Assert-Hash {
    param(
        [Parameter(Mandatory=$true)][string]$Label,
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$ExpectedHash
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        Stop-Fail "Missing $Label`: $Path"
    }
    $Actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($Actual -ne $ExpectedHash) {
        Stop-Fail "Hash mismatch for $Label`nPath: $Path`nExpected: $ExpectedHash`nActual:   $Actual"
    }
    return $Actual
}

if (-not (Test-Path -LiteralPath ".git")) {
    Stop-Fail "Run this in Mr.Kleen repo root: C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
}

$RepoRoot = (Get-Location).Path
$Branch = (git branch --show-current).Trim()
$StartHead = (git rev-parse --short HEAD).Trim()
$StartFullHead = (git rev-parse HEAD).Trim()

$StatusBefore = git status --short
if ($LASTEXITCODE -ne 0) {
    Stop-Fail "git status failed before save."
}
if (-not [string]::IsNullOrWhiteSpace(($StatusBefore | Out-String).Trim())) {
    Stop-Fail "Repo is not clean before watcher liveness save.`n$($StatusBefore | Out-String)"
}

$Date = "20260521"
$CC = "$env:USERPROFILE\Desktop\123\COMMAND_CENTER"
$ChildRoot = "$CC\CHILD_SHELL"
$WatchDir = "$ChildRoot\WATCHER"

$EnsureHelper = "$WatchDir\ENSURE_CHILD_SHELL_WATCHER_RUNNING.ps1"
$EnsureReceipt = "$WatchDir\ENSURE_CHILD_SHELL_WATCHER_LAST_RECEIPT.txt"
$SelfTestReceipt = "$ChildRoot\OUTBOX\CHILDJOB-20260521-000006-WATCHER-LIVENESS-STALE-PID-RESTART.receipt.txt"
$ProofReceiptSource = "$CC\RECEIPTS\CHILD_SHELL_WATCHER_LIVENESS_STALE_PID_DURABILITY_RECEIPT_20260521_041759.txt"

$EnsureHelperHash = Assert-Hash -Label "ensure helper" -Path $EnsureHelper -ExpectedHash "D2322D81EE126DF077F6F4B79526FFACAA7DF63EC873C1A4A74DEA65E6DEC449"
$EnsureReceiptHash = Assert-Hash -Label "ensure receipt" -Path $EnsureReceipt -ExpectedHash "097084DB4922AD40980B4C560BEE2EAB47445F427BE2B322999864ECE78CE06C"
$SelfTestReceiptHash = Assert-Hash -Label "watcher liveness self-test receipt" -Path $SelfTestReceipt -ExpectedHash "EED54160EC90BB858157243BFDCED816C8F9DB21CF10A216C58356EF75485558"
$ProofReceiptSourceHash = Assert-Hash -Label "watcher liveness proof receipt" -Path $ProofReceiptSource -ExpectedHash "AD85F61684B74BC8A4DD852ADE014B9E1546FEB351EB452814E4F9877C6B3D42"

$JobMatches = @(Get-ChildItem -LiteralPath $ChildRoot -Recurse -Force -Filter "CHILDJOB-20260521-000006-WATCHER-LIVENESS-STALE-PID-RESTART.childjob.json" -ErrorAction SilentlyContinue)
if ($JobMatches.Count -lt 1) {
    Stop-Fail "Missing self-test job file for 000006 under Child Shell."
}
$SelfTestJobPath = $JobMatches[0].FullName
$SelfTestJobHash = Assert-Hash -Label "watcher liveness self-test job" -Path $SelfTestJobPath -ExpectedHash "AB41B642478A15E1F05E94125FFC50BE8D0860AFADD0EF957097573C07C6D046"

$PidFile = "$WatchDir\CHILD_SHELL_WATCHER.pid"
$WatcherPid = "[missing]"
$WatcherState = "UNKNOWN"
if (Test-Path -LiteralPath $PidFile) {
    $WatcherPid = (Get-Content -LiteralPath $PidFile -Raw).Trim()
    if ($WatcherPid -match '^\d+$') {
        $Proc = Get-Process -Id ([int]$WatcherPid) -ErrorAction SilentlyContinue
        if ($null -ne $Proc) { $WatcherState = "RUNNING" } else { $WatcherState = "STALE_OR_STOPPED" }
    } else {
        $WatcherState = "PID_FILE_NON_NUMERIC"
    }
}

$RulePath = "BRAIN_LEARNING\CHILD_SHELL_WATCHER_LIVENESS_STALE_PID_DURABILITY_RULE_$Date.md"
$ReviewPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CHILD_SHELL_WATCHER_LIVENESS_STALE_PID_DURABILITY_REVIEW_$Date.md"
$Level2QueuePath = "HOUSE_WORK\WORK_SHED\QUEUE\LEVEL2_APPROVED_HELPER_ROUTE_SELECTED_NEXT_$Date.md"
$ProofPath = "PROOF_HISTORY\CHILD_SHELL_WATCHER_LIVENESS_STALE_PID_DURABILITY_LOCK_RECEIPT_$Date.txt"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

foreach ($P in @($RulePath,$ReviewPath,$Level2QueuePath,$ProofPath)) {
    if (Test-Path -LiteralPath $P) { Stop-Fail "Refusing overwrite: $P" }
}

$RuleText = @"
# Child Shell Watcher Liveness / Stale-PID Durability Rule — $Date

## Status

PASS / STALE PID DETECTED, WATCHER RESTARTED, DROP JOB CONSUMED

## What Is Proved

The Child Shell watcher liveness helper can recover from a stale PID file.

The proof stopped the existing watcher, forced PID value `999999`, ran the ensure helper, restarted the watcher, and confirmed the restarted watcher consumed a dropped Level 1 read-status job.

## Proof Chain

Initial PID:

8908

Initial state:

RUNNING

Forced stale PID:

999999

Restarted watcher PID:

13520

Restarted watcher state:

RUNNING

Self-test job:

CHILDJOB-20260521-000006-WATCHER-LIVENESS-STALE-PID-RESTART

## Validated Local Proof Objects

Ensure helper:

$EnsureHelper

SHA256:

$EnsureHelperHash

Ensure receipt:

$EnsureReceipt

SHA256:

$EnsureReceiptHash

Self-test job:

$SelfTestJobPath

SHA256:

$SelfTestJobHash

Self-test receipt:

$SelfTestReceipt

SHA256:

$SelfTestReceiptHash

Proof receipt:

$ProofReceiptSource

SHA256:

$ProofReceiptSourceHash

## Meaning

The watcher route has now moved from "works when alive" to "can recover from stale PID by using the ensure helper."

This is durability proof for watcher liveness, not a promotion to broader execution.

## Boundary

This does not prove assistant-direct local execution from chat.

This does not prove Level 2 approved-helper execution.

This does not prove Level 3 Mr.Kleen house-save execution.

This does not allow arbitrary shell execution, raw shell expansion, broad filesystem crawl, delete, permission expansion, junction/symlink teleporter, doctrine install, ACTIVE_GUIDES rewrite, or CURRENT_TRUTH_INDEX rewrite.

## Next Selected Boss

Level 2 approved-helper route is selected next, but it must be separately designed, bounded, allowlisted, tested, and saved.

Do not skip directly to Level 3.
"@

$ReviewText = @"
# Child Shell Watcher Liveness / Stale-PID Durability Review — $Date

## Verdict

PASS / LOCK SAVE READY

## Live Proof Result

`CHILD SHELL WATCHER LIVENESS STALE PID DURABILITY PROVED`

Verdict:

`PASS / STALE PID DETECTED, WATCHER RESTARTED, DROP JOB CONSUMED`

## Event Order

1. Watcher was initially running at PID `8908`.
2. Controlled stop succeeded.
3. PID file was forced to stale value `999999`.
4. Ensure helper detected `STALE_OR_STOPPED`.
5. Ensure helper started/restarted watcher.
6. Watcher restarted at PID `13520`.
7. Restarted watcher consumed job `000006`.
8. Level 1 read-status receipt appeared.

## Validated Receipt Hashes

Ensure helper SHA256:

$EnsureHelperHash

Ensure receipt SHA256:

$EnsureReceiptHash

Self-test job SHA256:

$SelfTestJobHash

Self-test receipt SHA256:

$SelfTestReceiptHash

Proof receipt SHA256:

$ProofReceiptSourceHash

## Boundary Held

Command Center Child Shell watcher control only.

No Mr.Kleen repo write through Child Shell.

No git through Child Shell.

No doctrine install.

No raw shell expansion.

No broad filesystem crawl.

No permission expansion.

No junction/symlink teleporter.

## Next

Level 2 approved-helper route is selected after this save. It remains blocked until separately installed and proved.
"@

$Level2QueueText = @"
# Level 2 Approved-Helper Route — Selected Next — $Date

## Status

SELECTED NEXT / NOT INSTALLED

## Why Selected

Level 0 job consumption passed.

Level 1 read-status passed.

No-script watcher drop passed with guardrail.

Watcher liveness / stale-PID restart durability passed.

The trigger lane is now stable enough to design Level 2.

## Boundary

Level 2 is not Level 3.

Level 2 must only run named approved helpers.

Level 2 must not execute arbitrary shell text.

Level 2 must not perform Mr.Kleen repo house-save execution until Level 3 is separately designed and proved.

## Minimum Level 2 Requirements

- explicit allowlist of helper names;
- helper path hash checks;
- input contract;
- output receipt;
- no delete;
- no raw shell expansion;
- no broad filesystem crawl;
- no permission expansion;
- no junction/symlink teleporter;
- stop on mismatch;
- proof receipt before promotion.

## Next Action

Design the smallest Level 2 approved-helper route.
"@

$ProofText = @"
CHILD SHELL WATCHER LIVENESS / STALE PID DURABILITY LOCK RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / WATCHER LIVENESS DURABILITY SAVED

Repo:
$RepoRoot

Branch before save:
$Branch

HEAD before save:
$StartHead

HEAD full before save:
$StartFullHead

Saved files:
$RulePath
$ReviewPath
$Level2QueuePath
$ProofPath
$AnchorPath
$StatusPath

Validated objects:
Ensure helper: $EnsureHelper
Ensure helper SHA256: $EnsureHelperHash

Ensure receipt: $EnsureReceipt
Ensure receipt SHA256: $EnsureReceiptHash

Self-test job: $SelfTestJobPath
Self-test job SHA256: $SelfTestJobHash

Self-test receipt: $SelfTestReceipt
Self-test receipt SHA256: $SelfTestReceiptHash

Proof receipt: $ProofReceiptSource
Proof receipt SHA256: $ProofReceiptSourceHash

Watcher PID file at save time:
$WatcherPid

Watcher process state at save time:
$WatcherState

Meaning:
Watcher stale-PID restart durability is proved. The watcher can be checked, stale PID can be detected, watcher can be restarted, and the restarted watcher can consume a dropped Level 1 read-status job.

Boundary:
No assistant-direct local execution claim.
No Level 2 execution yet.
No Level 3 execution.
No arbitrary shell execution.
No raw shell expansion.
No broad filesystem crawl.
No delete.
No permission expansion.
No junction/symlink teleporter.
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.

Next:
Level 2 approved-helper route is selected next and must be built as a separate bounded proof.
"@

$AnchorText = @"
Current active ball:
Watcher liveness / stale-PID restart durability locked and saved. Level 2 approved-helper route selected next, not installed.

Current proof:
Level 0 PASS.
Level 1 PASS.
No-script drop job 000005 PASS and saved.
Watcher liveness/stale-PID restart job 000006 PASS.
Watcher PID at save time: $WatcherPid.
Watcher state at save time: $WatcherState.
Level 2 not installed.
Level 3 not installed.

Next allowed boss:
Design smallest Level 2 approved-helper route with explicit allowlist, helper hash checks, receipts, and no arbitrary shell.

Boundary:
Do not claim assistant-direct local execution from chat.
Do not claim Level 2/Level 3 execution before proof.
Do not skip to house-save execution through Child Shell.
"@

Write-Utf8 $RulePath $RuleText
Write-Utf8 $ReviewPath $ReviewText
Write-Utf8 $Level2QueuePath $Level2QueueText
Write-Utf8 $ProofPath $ProofText
Write-Utf8 $AnchorPath $AnchorText

$StatusAppend = @"

## $Date — Watcher liveness / stale-PID durability lock

Verdict: PASS / WATCHER LIVENESS DURABILITY SAVED.

Proof: stale PID value 999999 was detected as STALE_OR_STOPPED; watcher restarted at PID 13520; restarted watcher consumed CHILDJOB-20260521-000006-WATCHER-LIVENESS-STALE-PID-RESTART.

Validated proof receipt: $ProofReceiptSource.

Validated proof receipt SHA256: $ProofReceiptSourceHash.

Watcher PID at save time: $WatcherPid.

Watcher state at save time: $WatcherState.

Next: Level 2 approved-helper route selected next, but not installed.

Boundary: no assistant-direct local execution claim, no Level2/Level3 promotion, no raw shell expansion, no broad filesystem crawl, no delete, no permission expansion, no junction/symlink teleporter.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $RulePath $ReviewPath $Level2QueuePath $AnchorPath $StatusPath
if ($LASTEXITCODE -ne 0) { Stop-Fail "git add failed for non-ignored files." }

git add -f -- $ProofPath
if ($LASTEXITCODE -ne 0) { Stop-Fail "git add -f failed for PROOF_HISTORY receipt." }

$Staged = git diff --cached --name-only
if ([string]::IsNullOrWhiteSpace(($Staged | Out-String).Trim())) {
    Stop-Fail "Nothing staged."
}

git commit -m "Lock watcher liveness durability"
if ($LASTEXITCODE -ne 0) { Stop-Fail "git commit failed." }

git push
if ($LASTEXITCODE -ne 0) { Stop-Fail "git push failed." }

$FinalHead = (git rev-parse --short HEAD).Trim()
$FinalFullHead = (git rev-parse HEAD).Trim()
$OriginHead = (git rev-parse --short origin/main).Trim()
$FinalStatus = git status --short

if (-not [string]::IsNullOrWhiteSpace(($FinalStatus | Out-String).Trim())) {
    Stop-Fail "Final repo status is not clean.`n$($FinalStatus | Out-String)"
}

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "WATCHER LIVENESS DURABILITY LOCK SAVED"
Write-Host "Verdict: PASS / SAVED AND PUSHED"
Write-Host "Branch: $Branch"
Write-Host "Previous HEAD: $StartHead"
Write-Host "Current HEAD: $FinalHead"
Write-Host "Current HEAD full: $FinalFullHead"
Write-Host "Origin main: $OriginHead"
Write-Host "Status: clean"
Write-Host "Saved files:"
Write-Host "- $RulePath"
Write-Host "- $ReviewPath"
Write-Host "- $Level2QueuePath"
Write-Host "- $ProofPath"
Write-Host "- $AnchorPath"
Write-Host "- $StatusPath"
Write-Host "Validated proof receipt: $ProofReceiptSource"
Write-Host "Validated proof receipt SHA256: $ProofReceiptSourceHash"
Write-Host "Watcher PID at save time: $WatcherPid"
Write-Host "Watcher process state at save time: $WatcherState"
Write-Host "Next: Level2 approved-helper route selected next, not installed."
Write-Host "Boundary: no assistant-direct local execution claim; no Level2/Level3 promotion; no raw shell expansion; no broad filesystem crawl; no delete; no permission expansion; no junction/symlink teleporter."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
