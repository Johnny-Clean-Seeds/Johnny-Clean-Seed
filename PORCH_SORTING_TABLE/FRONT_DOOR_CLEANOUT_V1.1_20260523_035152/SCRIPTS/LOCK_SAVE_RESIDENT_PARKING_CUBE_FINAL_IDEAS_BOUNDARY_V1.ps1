$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"
$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$ResidentRoot = Join-Path $CommandCenter "RESIDENT_PARKING"
$CubeParking = Join-Path $ResidentRoot "DAY_DREAMS\CUBE_FINAL_IDEAS"
$LocalReceipts = Join-Path $CommandCenter "RECEIPTS"

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
    throw "Stop: repo must be clean before this checkpoint save."
}

$OldHead = (git rev-parse HEAD).Trim()
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

# Git-safe files. These do not include Cube/final-ideas content.
$BoundaryPath = "HOUSE_WORK\WORK_SHED\PARKING\RESIDENT_PARKING_CUBE_FINAL_IDEAS_LOCAL_ONLY_BOUNDARY_20260523.md"
$CheckpointPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CHAT_CHECKPOINT_CUBE_FINAL_IDEAS_LOCAL_ONLY_20260523.md"
$ReceiptPath = "PROOF_HISTORY\RESIDENT_PARKING_CUBE_FINAL_IDEAS_BOUNDARY_RECEIPT_$Now.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

# Local-only files. These stay outside Git repo.
$LocalIndexPath = Join-Path $CubeParking "INDEX.md"
$LocalCubePath = Join-Path $CubeParking "CUBE_FINAL_IDEAS_LOCAL_ONLY_RESIDENT_PARKING_20260523.md"
$LocalReceiptPath = Join-Path $LocalReceipts "CUBE_FINAL_IDEAS_LOCAL_ONLY_RESIDENT_PARKING_RECEIPT_$Now.txt"

foreach ($p in @($BoundaryPath, $CheckpointPath, $ReceiptPath, $StatusPath)) {
    $parent = Split-Path -Parent $p
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

foreach ($d in @($CommandCenter, $ResidentRoot, $CubeParking, $LocalReceipts)) {
    if (-not (Test-Path -LiteralPath $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

$BoundaryContent = @'
# Resident Parking Boundary — Cube / Final Ideas Local-Only — 2026-05-23

Status: SUPPORT BOUNDARY / GIT-SAFE POINTER / NO CUBE CONTENT
Scope: define that Cube / final ideas material is local-only resident parking while the checkpoint and boundary may be saved to Git.
Boundary: this file intentionally does not copy the Cube / final ideas content.

## 1. Core Rule

Only the Cube / final ideas material stays out of Git.

Everything else about the boundary/checkpoint may be saved as a Git-safe pointer, as long as it does not copy the Cube content itself.

## 2. Placement

Cube / final ideas belong in local-only Resident Parking:

`Desktop\123\COMMAND_CENTER\RESIDENT_PARKING\DAY_DREAMS\CUBE_FINAL_IDEAS`

This location is:
- local-only;
- mule-visible;
- not Git;
- not doctrine;
- not proof;
- not final-order control.

## 3. Why

Cube / final ideas may add useful finals/presentation/reflection material, but they can also add fog to the endgame.

Therefore:
- keep them available;
- keep them out of active gate order;
- keep them out of Git;
- let mule see them only as parked reference.

## 4. Final Order Boundary

Cube / final ideas are not:
- a gate;
- a judge;
- proof;
- doctrine;
- authority;
- final order;
- CONSOLIDATOR input unless explicitly pulled later.

Clean final order remains:

`Alpha opens fresh -> work/gates/proof run -> hindsight review -> Omega closes -> final clean status`

## 5. Return Trigger

Pull the Cube / final ideas out of Resident Parking only when:
- the user asks for finals/presentation/symbolic layer;
- mule needs optional local visual/concept context;
- a future design pass explicitly asks for Day Dreams / Cube final ideas.

## 6. Short Form

Git may hold the boundary.

Local Resident Parking holds the Cube / final ideas.
'@
$CheckpointContent = @'
# Chat Checkpoint — Cube Final Ideas Local-Only Boundary — 2026-05-23

Status: GIT-SAFE CHECKPOINT / DOES NOT CONTAIN CUBE CONTENT
Purpose: preserve the current chat continuation point while keeping Cube / final ideas local-only.

## Current Position

Latest active direction:
- Guest boundary gates saved.
- Alpha Omega / Hindsight order saved.
- Mule handoff already exists and should not be updated in this step.
- CONSOLIDATOR remains not active.
- Cube / final ideas must stay out of Git and out of Final Order.

## Critical Boundary

Only the Cube / final ideas material is local-only.

It belongs in:

`Desktop\123\COMMAND_CENTER\RESIDENT_PARKING\DAY_DREAMS\CUBE_FINAL_IDEAS`

The Git side may record:
- that the boundary exists;
- where the local resident parking lives;
- hashes/receipt names;
- that mule may view it locally.

The Git side must not copy the Cube / final ideas content.

## Final Order

Final Order remains practical:

`Alpha opens fresh -> work/gates/proof run -> hindsight review -> Omega closes -> final clean status`

Cube / final ideas are outside that order.

## Next Chat Pickup

Start from this checkpoint.

If working with mule:
- use the existing mule handoff already placed;
- allow mule to read local Resident Parking if needed;
- do not update the mule handoff unless explicitly requested.

If working on finals:
- pull Cube / final ideas from local Resident Parking;
- treat as symbolic/finals/daydream material only.
'@
$LocalCubeContent = @'
# Cube / Final Ideas — Local Resident Parking

Status: LOCAL-ONLY / RESIDENT PARKING / MULE-VISIBLE / NOT GIT
Scope: parked Cube / final ideas for later finals, symbolic layer, presentation thinking, or daydream reference.
Boundary: do not commit this content to Git.

## Source Direction

User clarified:
- the only thing not on Git is the Cube / final ideas;
- this material can add fog at times to the endgame;
- it may still help mule stay in the loop;
- park it in Resident Parking / Extended Parking;
- keep it available in this chat/new-chat checkpoint path.

Preserved source wording:
- “findal ideas”

Clean working wording:
- final ideas

## Placement

This material lives here:

`Desktop\123\COMMAND_CENTER\RESIDENT_PARKING\DAY_DREAMS\CUBE_FINAL_IDEAS`

Mule may read it locally.

Do not Git-add this folder.

## Allowed Use

Allowed:
- symbolic/finals reference;
- visual idea memory;
- daydream material;
- mule-visible optional context;
- future finals/presentation discussion.

Blocked:
- final gate order;
- proof;
- doctrine;
- authority;
- operating sequence;
- CONSOLIDATOR input unless explicitly pulled later;
- ACTIVE_GUIDES;
- CURRENT_TRUTH_INDEX.

## Short Form

Keep the Cube / final ideas available.

Keep them out of Git.

Keep them out of Final Order.
'@
$LocalIndexContent = @'
# CUBE_FINAL_IDEAS Resident Parking Index

Status: LOCAL-ONLY / MULE-VISIBLE / NOT GIT

## Entries

- `CUBE_FINAL_IDEAS_LOCAL_ONLY_RESIDENT_PARKING_20260523.md`

## Boundary

This folder is for Cube / final ideas only.

It is local-only.

Mule may read it.

Do not commit this folder to Git.
'@

Set-Content -LiteralPath $BoundaryPath -Value $BoundaryContent -Encoding UTF8
Set-Content -LiteralPath $CheckpointPath -Value $CheckpointContent -Encoding UTF8
Set-Content -LiteralPath $LocalCubePath -Value $LocalCubeContent -Encoding UTF8
Set-Content -LiteralPath $LocalIndexPath -Value $LocalIndexContent -Encoding UTF8

$BoundaryHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $BoundaryPath).Hash
$CheckpointHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CheckpointPath).Hash
$LocalCubeHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $LocalCubePath).Hash
$LocalIndexHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $LocalIndexPath).Hash

$LocalReceipt = @"
CUBE FINAL IDEAS LOCAL-ONLY RESIDENT PARKING RECEIPT

Timestamp: $Now

Local-only Resident Parking folder:
- $CubeParking

Local-only files:
- $LocalIndexPath
  SHA256: $LocalIndexHash
- $LocalCubePath
  SHA256: $LocalCubeHash

Boundary:
- The Cube / final ideas content is local-only.
- Mule may read it locally.
- Do not Git-add this folder.
- Not doctrine.
- Not proof.
- Not gate order.
- Not Final Order.
- Not CONSOLIDATOR input unless explicitly pulled later.
"@

Set-Content -LiteralPath $LocalReceiptPath -Value $LocalReceipt -Encoding UTF8
$LocalReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $LocalReceiptPath).Hash

$StatusAppend = @"

## 2026-05-23 — Cube Final Ideas Local-Only Resident Parking Boundary

Status: SAVED BY SCRIPT / GIT-SAFE BOUNDARY + LOCAL-ONLY PARKING / NO DOCTRINE PROMOTION
Old base before save: $OldHead

Git-safe saved files:
- $BoundaryPath
- $CheckpointPath
- $ReceiptPath

Local-only Resident Parking:
- $CubeParking
- $LocalIndexPath
- $LocalCubePath
- $LocalReceiptPath

Meaning:
- only the Cube / final ideas material stays out of Git;
- Cube / final ideas are local-only, mule-visible resident parking;
- Git stores only the boundary/checkpoint and hashes, not the Cube content;
- Cube / final ideas stay out of Final Order and gate order.

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
RESIDENT PARKING CUBE FINAL IDEAS BOUNDARY RECEIPT

Timestamp: $Now
Repo: $Repo
Branch: $Branch
Old HEAD: $OldHead

Verdict intended by save:
PASS WITH GUARDRAILS / GIT-SAFE BOUNDARY SAVED / CUBE FINAL IDEAS LOCAL-ONLY

Git-safe saved files:
- $BoundaryPath
  SHA256: $BoundaryHash
- $CheckpointPath
  SHA256: $CheckpointHash
- $StatusPath
  SHA256 after append: $StatusHash

Local-only Resident Parking files:
- $LocalIndexPath
  SHA256: $LocalIndexHash
- $LocalCubePath
  SHA256: $LocalCubeHash
- $LocalReceiptPath
  SHA256: $LocalReceiptHash

Core idea:
Only Cube / final ideas content is not on Git. It is stored in local-only Resident Parking for mule-visible Day Dreams / finals reference. Git stores only boundary and checkpoint.

Boundary:
- Cube / final ideas content not committed to Git.
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

git add -- $BoundaryPath $CheckpointPath $StatusPath
git add -f -- $ReceiptPath

$Cached = git --no-pager diff --cached --name-only
if (-not $Cached) {
    throw "No staged changes found. Resident Parking boundary save did not produce expected dirty paths."
}

$Expected = @(
    $BoundaryPath.Replace("\","/"),
    $CheckpointPath.Replace("\","/"),
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

git commit -m "Save Cube final ideas resident parking boundary"

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
Write-Host "CUBE FINAL IDEAS RESIDENT PARKING BOUNDARY SAVE COMPLETE"
Write-Host "Old base: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Git boundary: $BoundaryPath"
Write-Host "Git boundary SHA256: $BoundaryHash"
Write-Host "Git checkpoint: $CheckpointPath"
Write-Host "Git checkpoint SHA256: $CheckpointHash"
Write-Host "Git receipt: $ReceiptPath"
Write-Host "Git receipt SHA256: $ReceiptHash"
Write-Host "Local Resident Parking folder: $CubeParking"
Write-Host "Local index SHA256: $LocalIndexHash"
Write-Host "Local Cube final ideas SHA256: $LocalCubeHash"
Write-Host "Local receipt SHA256: $LocalReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / GIT-SAFE BOUNDARY SAVED / CUBE FINAL IDEAS LOCAL-ONLY"
