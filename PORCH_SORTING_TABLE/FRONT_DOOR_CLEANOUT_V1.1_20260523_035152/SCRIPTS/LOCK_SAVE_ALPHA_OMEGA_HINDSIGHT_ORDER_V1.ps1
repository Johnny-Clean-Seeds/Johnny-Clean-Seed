$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"
if (-not (Test-Path -LiteralPath $Repo)) {
    throw "Mr.Kleen repo not found at $Repo"
}

Set-Location -LiteralPath $Repo

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not in a Git repo. Expected Mr.Kleen at $Repo"
}

$Branch = (git branch --show-current).Trim()
if ($Branch -ne "main") {
    throw "Expected branch main, found '$Branch'"
}

$PreStatus = git --no-pager status --short
if ($PreStatus) {
    Write-Host "PRE-STATUS WAS NOT CLEAN:"
    $PreStatus | ForEach-Object { Write-Host $_ }
    throw "Stop: repo must be clean before this Alpha Omega hindsight save."
}

$OldHead = (git rev-parse HEAD).Trim()
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

$RulePath = "BRAIN_LEARNING\ALPHA_OMEGA_HINDSIGHT_NEIGHBOR_ORDER_20260523.md"
$InspectionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\ALPHA_OMEGA_HINDSIGHT_ORDER_INSPECTION_20260523.md"
$ReceiptPath = "PROOF_HISTORY\ALPHA_OMEGA_HINDSIGHT_ORDER_SAVE_RECEIPT_$Now.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$Paths = @($RulePath, $InspectionPath, $ReceiptPath, $StatusPath)
foreach ($p in $Paths) {
    $parent = Split-Path -Parent $p
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

$RuleContent = @'
# Alpha Omega + Hindsight Neighbor Order — 2026-05-23

Status: SUPPORT RULE / LOOP-JUDGING ORDER / NOT DOCTRINE
Scope: define where hindsight belongs relative to Alpha Omega Gate.
Boundary: this does not rewrite ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, doctrine, mule handoffs, runtime, automation, dashboard, or public authority.

## 1. Core Rule

Hindsight should happen before Alpha Omega closes the loop.

Correct order:

`Alpha opens -> fresh work happens -> gates run -> proof/receipts checked -> hindsight review -> Alpha Omega closes`

## 2. Alpha Side

Alpha is the clean opening.

Alpha asks:
- What opened this loop?
- What is the seed problem?
- What source started it?
- What boundary applies?
- Which gate should fire first?
- Are we reacting too fast?

Alpha should not use hindsight as the first doorway.

Reason:
History can bias the start. The beginning needs clean classification and current source/boundary first.

## 3. Hindsight Position

Hindsight is a neighbor/lens that feeds Alpha Omega.

Hindsight asks:
- Have we seen this before?
- Did it repeat?
- Was it repaired?
- Did old proof show the same pattern?
- Is it still open?
- Did the house run past it while busy?

Hindsight happens after fresh evidence and proof/receipt checks exist.

## 4. Omega Side

Omega uses hindsight to close cleanly.

Omega asks:
- Now that fresh work and history have both been checked, what is the true ending?
- What survived?
- What was applied?
- What was parked?
- What was rejected?
- What still needs proof?
- What returned home?
- Did the user receive clean status?

## 5. Relationship to Final Judge

Final Judge checks whether an object did its job.

Alpha Omega checks whether the whole loop started clean, moved clean, ended clean, and returned clean.

Hindsight feeds Alpha Omega before the close.

## 6. Relationship to CONSOLIDATOR

CONSOLIDATOR should not merge gates until hindsight shows repeated overlap or ambiguity.

Alpha Omega then judges whether the consolidation loop started and ended cleanly.

## 7. Blocked Moves

Blocked:
- using hindsight as the opening door;
- swallowing hindsight fully into Alpha Omega until Alpha Omega becomes too fat;
- letting Alpha Omega become a king gate;
- replacing proof;
- activating CONSOLIDATOR from this rule;
- updating mule handoff from this save;
- claiming doctrine promotion.

## 8. Short Form

Hindsight is not the door in.

Hindsight is the rearview mirror before the final exit.

Alpha opens fresh.
Hindsight reviews after evidence.
Omega closes clean.
'@
$InspectionContent = @'
# Alpha Omega Hindsight Order Inspection — 2026-05-23

Status: SORTING BENCH INSPECTION / SUPPORT NOTE
Scope: inspect the placement of hindsight relative to Alpha Omega Gate.
Boundary: this is not a mule handoff update, not CONSOLIDATOR activation, and not doctrine.

## Finding

Alpha Omega should use hindsight, but hindsight should remain a neighbor/lens before Omega closure.

This prevents Alpha Omega from becoming too broad or acting like a king gate.

## Clean Order

1. Alpha opens.
2. Current/fresh work happens.
3. Gates run.
4. Proof/receipt gate checks evidence.
5. Hindsight reviews repetition/history/repair trail.
6. Omega closes the loop.
7. Final clean status returns to user.

## Why This Fits

The house already learned that Git/history can bias discovery when used too early.

Same principle applies here:
- do not start with hindsight;
- do use hindsight before final closure;
- do not let hindsight become authority by itself.

## Consequence for Future CONSOLIDATOR

CONSOLIDATOR should wait until hindsight shows repeated ambiguity/overlap.

Then Alpha Omega judges whether the consolidation loop opened cleanly, merged cleanly, preserved distinct jobs, and closed cleanly.

## Verdict

KEEP / PASS WITH GUARDRAILS as support ordering.

No mule handoff update.
No doctrine promotion.
No CONSOLIDATOR activation.
'@

Set-Content -LiteralPath $RulePath -Value $RuleContent -Encoding UTF8
Set-Content -LiteralPath $InspectionPath -Value $InspectionContent -Encoding UTF8

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$InspectionHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $InspectionPath).Hash

$StatusAppend = @"

## 2026-05-23 — Alpha Omega Hindsight Neighbor Order

Status: SAVED BY SCRIPT / SUPPORT RULE / NO DOCTRINE PROMOTION
Old base before save: $OldHead

Saved:
- $RulePath
- $InspectionPath
- $ReceiptPath

Meaning:
- hindsight belongs before Alpha Omega closes the loop;
- Alpha opens fresh without history bias;
- work/gates/proof run before hindsight;
- hindsight feeds Omega closure as a neighbor/lens;
- Alpha Omega remains whole-loop judge, not a king gate or proof replacement.

Boundary:
No ACTIVE_GUIDE rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine promotion. No mule handoff update. No CONSOLIDATOR activation. No Alpha Omega promotion. No cleanup/delete/move. No runtime, automation, dashboard, or public authority change.
"@

if (Test-Path -LiteralPath $StatusPath) {
    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
} else {
    Set-Content -LiteralPath $StatusPath -Value ("# Current House Work Status`r`n" + $StatusAppend) -Encoding UTF8
}

$StatusHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $StatusPath).Hash

$ReceiptContent = @"
ALPHA OMEGA HINDSIGHT ORDER SAVE RECEIPT

Timestamp: $Now
Repo: $Repo
Branch: $Branch
Old HEAD: $OldHead

Verdict intended by save:
PASS WITH GUARDRAILS / SUPPORT RULE SAVED / NO DOCTRINE PROMOTION

Saved files:
- $RulePath
  SHA256: $RuleHash
- $InspectionPath
  SHA256: $InspectionHash
- $StatusPath
  SHA256 after append: $StatusHash

Core idea saved:
Hindsight happens after fresh work/gates/proof and before Alpha Omega closes. Alpha opens fresh. Hindsight feeds Omega closure. Alpha Omega stays a whole-loop judge, not a king gate, proof replacement, or CONSOLIDATOR trigger.

Boundary:
- No mule handoff update.
- No CONSOLIDATOR activation.
- No Alpha Omega promotion.
- No ACTIVE_GUIDE rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No doctrine promotion.
- No cleanup/delete/move.
- No runtime, automation, dashboard, or public authority change.

Final Git HEAD, remote match, and clean status are verified by script output after commit/push.
"@

Set-Content -LiteralPath $ReceiptPath -Value $ReceiptContent -Encoding UTF8
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

git add -- $RulePath $InspectionPath $StatusPath
git add -f -- $ReceiptPath

$Cached = git --no-pager diff --cached --name-only
if (-not $Cached) {
    throw "No staged changes found. Alpha Omega hindsight save did not produce expected dirty paths."
}

$Expected = @(
    $RulePath.Replace("\","/"),
    $InspectionPath.Replace("\","/"),
    $ReceiptPath.Replace("\","/"),
    $StatusPath.Replace("\","/")
)

$Missing = @()
foreach ($e in $Expected) {
    if ($Cached -notcontains $e) { $Missing += $e }
}
if ($Missing.Count -gt 0) {
    Write-Host "STAGED FILES:"
    $Cached | ForEach-Object { Write-Host $_ }
    throw ("Missing expected staged files: " + ($Missing -join ", "))
}

git commit -m "Save Alpha Omega hindsight order"

$NewHead = (git rev-parse HEAD).Trim()

git push origin main

git fetch origin main | Out-Null
$RemoteHead = (git rev-parse origin/main).Trim()

$FinalStatus = git --no-pager status --short

if ($NewHead -ne $RemoteHead) {
    throw "Remote mismatch after push. Local HEAD $NewHead != origin/main $RemoteHead"
}

if ($FinalStatus) {
    Write-Host "FINAL STATUS WAS NOT CLEAN:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final status not clean."
}

Write-Host ""
Write-Host "ALPHA OMEGA HINDSIGHT ORDER SAVE COMPLETE"
Write-Host "Old base: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Rule: $RulePath"
Write-Host "Rule SHA256: $RuleHash"
Write-Host "Inspection: $InspectionPath"
Write-Host "Inspection SHA256: $InspectionHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / SUPPORT RULE SAVED / NO DOCTRINE PROMOTION / NO MULE HANDOFF UPDATE"
