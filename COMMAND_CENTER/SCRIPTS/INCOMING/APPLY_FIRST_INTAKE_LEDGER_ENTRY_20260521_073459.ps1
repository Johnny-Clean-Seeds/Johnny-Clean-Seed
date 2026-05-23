$ErrorActionPreference = "Stop"

$House = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
if (-not (Test-Path -LiteralPath $House)) {
    throw "STOP. House path not found: $House"
}

Set-Location -LiteralPath $House

if (-not (Test-Path -LiteralPath ".git")) {
    throw "STOP. Not in Mr.Kleen git house: $House"
}

$StartBranch = (git branch --show-current).Trim()
$StartHead = (git rev-parse HEAD).Trim()
$StartOrigin = ""
try { $StartOrigin = (git rev-parse origin/$StartBranch).Trim() } catch { $StartOrigin = "[missing origin/$StartBranch]" }

if ($StartBranch -ne "main") {
    throw "STOP. Expected branch main, got: $StartBranch"
}

$StartStatus = @(git status --short)
if ($StartStatus.Count -gt 0) {
    throw "STOP. House is dirty before ledger entry. Clean/checkpoint first.`n$($StartStatus -join "`n")"
}

$Date = Get-Date -Format "yyyyMMdd"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$LedgerDir = "HOUSE_WORK\WORK_SHED\LEDGERS\INTAKE_LEDGER"
$ReceiptDir = "PROOF_HISTORY"
$IndexDir = "HOUSE_WORK\INDEXES"

New-Item -ItemType Directory -Force -Path $LedgerDir, $ReceiptDir, $IndexDir | Out-Null

$ExistingEntries = @(Get-ChildItem -LiteralPath $LedgerDir -File -Filter "INTAKE_LEDGER_ENTRY_*.md" -ErrorAction SilentlyContinue)
$Counter = $ExistingEntries.Count + 1
$CounterText = "{0:D6}" -f $Counter
$ObjectId = "INTAKE-$Date-$CounterText-DATA-ORDER-OUROBOROS"

$EntryPath = Join-Path $LedgerDir "INTAKE_LEDGER_ENTRY_${Date}_${CounterText}_DATA_ORDER_OUROBOROS.md"
$ReceiptPath = Join-Path $ReceiptDir "FIRST_INTAKE_LEDGER_ENTRY_RECEIPT_$Stamp.txt"
$StatusPath = Join-Path $IndexDir "CURRENT_HOUSE_WORK_STATUS.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"

$SourceArchitecture = "BRAIN_LEARNING\DATA_ORDER_OUROBOROS_LEDGER_ARCHITECTURE_20260521.md"
$SourceCard = "HOUSE_WORK\WORK_SHED\GEAR_RACK\RULE_MACHINES\INTAKE_LEDGER_OUROBOROS_CARD_20260521.md"
$SourceReview = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\DATA_ORDER_OUROBOROS_LEDGER_INSTALL_REVIEW_20260521.md"
$SourceReceipt = "PROOF_HISTORY\DATA_ORDER_OUROBOROS_LEDGER_INSTALL_RECEIPT_20260521.txt"

$RequiredSources = @($SourceArchitecture, $SourceCard, $SourceReview, $SourceReceipt)
foreach ($Source in $RequiredSources) {
    if (-not (Test-Path -LiteralPath $Source)) {
        throw "STOP. Required source missing for first ledger entry: $Source"
    }
}

if (Test-Path -LiteralPath $EntryPath) {
    throw "STOP. Refusing to overwrite existing ledger entry: $EntryPath"
}
if (Test-Path -LiteralPath $ReceiptPath) {
    throw "STOP. Refusing to overwrite existing receipt: $ReceiptPath"
}

$ArchHash = (Get-FileHash -LiteralPath $SourceArchitecture -Algorithm SHA256).Hash
$CardHash = (Get-FileHash -LiteralPath $SourceCard -Algorithm SHA256).Hash
$ReviewHash = (Get-FileHash -LiteralPath $SourceReview -Algorithm SHA256).Hash
$SourceReceiptHash = (Get-FileHash -LiteralPath $SourceReceipt -Algorithm SHA256).Hash

$Entry = @"
# Intake Ledger Entry - Data Order / Ouroboros Ledger First Live Use

## Object ID

$ObjectId

## Entry Type

First live intake-ledger entry / architecture save custody object.

## Entry Time

$(Get-Date -Format o)

## Source Event

Data Order / Ouroboros Ledger architecture save completed and pushed cleanly.

## Source Commit

b98a3e8ab803cb240513851ce48c00f4f35e3f5e

## Source Objects

- $SourceArchitecture
- $SourceCard
- $SourceReview
- $SourceReceipt

## Source Hashes

- Architecture SHA256: $ArchHash
- Intake Ledger Ouroboros Card SHA256: $CardHash
- Install Review SHA256: $ReviewHash
- Install Receipt SHA256: $SourceReceiptHash

## Lane

Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> Data Collection

## Stage Classification

Data Collection:
The completed architecture save entered as a new custody object.

Inventory:
This ledger entry assigns object ID, source, hashes, lane, relations, and status.

Housekeeping:
Object is placed under HOUSE_WORK\WORK_SHED\LEDGERS\INTAKE_LEDGER.

Data Management:
Status is PASS WITH LEDGER-LOOP WATCH.

Workflow:
Use this first entry as the proof seed for future intake-ledger entries.

## Parent / Stack Relation

Parent architecture:
DATA_ORDER_OUROBOROS_LEDGER_ARCHITECTURE_20260521

Related stack:
- stale-checker replacement
- data collection
- inventory
- housekeeping
- data management
- workflow
- rule bloom
- stack capture
- source-ore receipts
- hash proof
- file-first packets
- Broad-Bite collapse

## Proof Level

Receipt-backed and git-backed.

## Status

ACTIVE PROOF SEED / PASS WITH LEDGER-LOOP WATCH

## Next Allowed Action

Use Intake Ledger Ouroboros Card on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster.

## Stale Watch

Flag future related work if it lacks:

- object ID
- source
- hash where applicable
- lane
- status
- relation
- next action

## Boundary

This ledger entry does not rewrite doctrine.
This ledger entry does not rewrite ACTIVE_GUIDES.
This ledger entry does not rewrite CURRENT_TRUTH_INDEX.
This ledger entry does not install a runtime checker.
This ledger entry does not expand bridge permissions.
This ledger entry does not create junctions or symlinks.
"@

Set-Content -LiteralPath $EntryPath -Value $Entry -Encoding UTF8

$EntryHash = (Get-FileHash -LiteralPath $EntryPath -Algorithm SHA256).Hash

$StatusEntry = @"

## $Stamp - First Intake Ledger Entry created

Start position: $StartBranch @ $StartHead

Ledger object:
- $EntryPath

Object ID:
$ObjectId

Meaning:
First live use of Intake Ledger Ouroboros Card. The Data Order / Ouroboros Ledger architecture save has been inventoried as a custody object with source hashes, lane, status, relation, and next action.

Boundary:
No doctrine rewrite, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime checker install, no bridge permission expansion, no junction/symlink teleporter.

Next move:
Use intake-ledger entry format on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusEntry -Encoding UTF8

$Anchor = @"
ACTIVE ANCHOR

Current position:
main @ pending first Intake Ledger entry save

Current boss:
First live use of Intake Ledger Ouroboros Card.

Current verdict target:
PASS AS FIRST LEDGER ENTRY / LEDGER-LOOP WATCH.

Object ID:
$ObjectId

Installed intent:
Every entering object should be collectable, inventoried, housekept, managed, and routed through workflow with identity, hash, relation, status, and next action.

Next allowed move:
Use intake-ledger entry format on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster.

Blocked moves:
- Do not treat this as doctrine.
- Do not rewrite ACTIVE_GUIDES from this save.
- Do not rewrite CURRENT_TRUTH_INDEX from this save.
- Do not install a runtime checker from this save.
- Do not expand bridge permissions.
- Do not create junction/symlink teleporters.
"@

Set-Content -LiteralPath $AnchorPath -Value $Anchor -Encoding UTF8

$Receipt = @"
FIRST INTAKE LEDGER ENTRY RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PENDING COMMIT AT RECEIPT WRITE

Start:
Branch: $StartBranch
HEAD: $StartHead
Origin: $StartOrigin
Initial status: clean

Object ID:
$ObjectId

Ledger entry:
$EntryPath

Entry SHA256:
$EntryHash

Source commit:
b98a3e8ab803cb240513851ce48c00f4f35e3f5e

Source hashes:
Architecture: $ArchHash
Card: $CardHash
Review: $ReviewHash
Source receipt: $SourceReceiptHash

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No runtime checker install.
No bridge permission expansion.
No junction/symlink teleporter.

Next allowed move:
Use intake-ledger entry format on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$AllFiles = @($EntryPath, $ReceiptPath, $StatusPath, $AnchorPath)

foreach ($Path in $AllFiles) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "STOP. Expected file missing: $Path"
    }
    if ((Get-Item -LiteralPath $Path).Length -le 0) {
        throw "STOP. Expected file empty: $Path"
    }
}

$Needles = @(
    @{ Path = $EntryPath; Text = $ObjectId },
    @{ Path = $EntryPath; Text = "Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> Data Collection" },
    @{ Path = $EntryPath; Text = "ACTIVE PROOF SEED / PASS WITH LEDGER-LOOP WATCH" },
    @{ Path = $EntryPath; Text = "Stale Watch" },
    @{ Path = $ReceiptPath; Text = "FIRST INTAKE LEDGER ENTRY RECEIPT" },
    @{ Path = $StatusPath; Text = "First Intake Ledger Entry created" },
    @{ Path = $AnchorPath; Text = "PASS AS FIRST LEDGER ENTRY / LEDGER-LOOP WATCH" }
)

foreach ($Needle in $Needles) {
    $Content = Get-Content -LiteralPath $Needle.Path -Raw
    if ($Content -notlike "*$($Needle.Text)*") {
        throw "STOP. Proof needle missing from $($Needle.Path): $($Needle.Text)"
    }
}

$PostWriteStatus = @(git status --short)
if ($PostWriteStatus.Count -eq 0) {
    throw "STOP. No git changes detected after ledger entry write."
}

git add -f -- $AllFiles

$Staged = @(git diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "STOP. No staged files after git add."
}

$ExpectedStaged = foreach ($Path in $AllFiles) {
    $Path.Replace("\", "/")
}

foreach ($Expected in $ExpectedStaged) {
    if ($Staged -notcontains $Expected) {
        throw "STOP. Expected staged file missing: $Expected`nStaged:`n$($Staged -join "`n")"
    }
}

git commit -m "Record first intake ledger entry"

$CommitHead = (git rev-parse HEAD).Trim()
if ($CommitHead -eq $StartHead) {
    throw "STOP. Commit did not advance HEAD."
}

git push origin $StartBranch

$FinalHead = (git rev-parse HEAD).Trim()
$FinalOrigin = (git rev-parse origin/$StartBranch).Trim()
$FinalStatus = @(git status --short)
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

if ($FinalHead -ne $FinalOrigin) {
    throw "STOP. HEAD does not match origin/$StartBranch after push.`nHEAD: $FinalHead`nORIGIN: $FinalOrigin"
}

if ($FinalStatus.Count -gt 0) {
    throw "STOP. Final status dirty:`n$($FinalStatus -join "`n")"
}

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "FIRST INTAKE LEDGER ENTRY APPLIED TO HOUSE"
Write-Host "Verdict: PASS AS FIRST LEDGER ENTRY / LEDGER-LOOP WATCH"
Write-Host "Start: $StartBranch @ $StartHead"
Write-Host "Commit: $FinalHead"
Write-Host "Origin: $FinalOrigin"
Write-Host "Object ID: $ObjectId"
Write-Host "Ledger Entry: $EntryPath"
Write-Host "Entry SHA256: $EntryHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Status: clean"
Write-Host "Boundary: no doctrine rewrite; no ACTIVE_GUIDES rewrite; no CURRENT_TRUTH_INDEX rewrite; no runtime checker install; no bridge permission expansion; no junction/symlink teleporter."
Write-Host "Next: use intake-ledger entry format on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
