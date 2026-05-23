$ErrorActionPreference = "Stop"

function Stop-IfDirty {
    param([string]$Context)
    $Status = @(git status --short)
    if ($Status.Count -gt 0) {
        throw "STOP. House is dirty during $Context.`n$($Status -join "`n")"
    }
}

function Assert-Needle {
    param(
        [string]$Path,
        [string]$Text
    )
    $Content = Get-Content -LiteralPath $Path -Raw
    if ($Content -notlike "*$Text*") {
        throw "STOP. Proof needle missing from $Path: $Text"
    }
}

function Commit-And-Push {
    param(
        [string[]]$Files,
        [string]$Message
    )

    foreach ($Path in $Files) {
        if (-not (Test-Path -LiteralPath $Path)) {
            throw "STOP. Expected file missing before commit: $Path"
        }
        if ((Get-Item -LiteralPath $Path).Length -le 0) {
            throw "STOP. Expected file empty before commit: $Path"
        }
    }

    git add -f -- $Files

    $Staged = @(git diff --cached --name-only)
    if ($Staged.Count -eq 0) {
        return "SKIPPED_NO_STAGED_CHANGES"
    }

    $Before = (git rev-parse HEAD).Trim()
    git commit -m $Message
    $After = (git rev-parse HEAD).Trim()

    if ($Before -eq $After) {
        throw "STOP. Commit did not advance HEAD for message: $Message"
    }

    $Branch = (git branch --show-current).Trim()
    git push origin $Branch

    $Origin = (git rev-parse "origin/$Branch").Trim()
    if ($After -ne $Origin) {
        throw "STOP. HEAD does not match origin after push.`nHEAD: $After`nORIGIN: $Origin"
    }

    Stop-IfDirty "after commit $Message"

    return $After
}

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
try { $StartOrigin = (git rev-parse "origin/$StartBranch").Trim() } catch { $StartOrigin = "[missing origin/$StartBranch]" }

if ($StartBranch -ne "main") {
    throw "STOP. Expected branch main, got: $StartBranch"
}

Stop-IfDirty "start"

$Date = Get-Date -Format "yyyyMMdd"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$LedgerDir = "HOUSE_WORK\WORK_SHED\LEDGERS\INTAKE_LEDGER"
$TemplateDir = "HOUSE_WORK\WORK_SHED\LEDGERS\INTAKE_LEDGER\TEMPLATES"
$ProofDir = "PROOF_HISTORY"
$IndexDir = "HOUSE_WORK\INDEXES"

New-Item -ItemType Directory -Force -Path $LedgerDir, $TemplateDir, $ProofDir, $IndexDir | Out-Null

$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"

$WaveResults = New-Object System.Collections.Generic.List[string]

# WAVE 1: First intake ledger entry, if not already present.

$ExistingFirstEntry = @(Get-ChildItem -LiteralPath $LedgerDir -File -Filter "*DATA_ORDER_OUROBOROS*.md" -ErrorAction SilentlyContinue | Sort-Object Name | Select-Object -First 1)

if ($ExistingFirstEntry.Count -gt 0) {
    $WaveResults.Add("Wave 1: SKIPPED - first Data Order/Ouroboros ledger entry already exists: $($ExistingFirstEntry[0].FullName)")
}
else {
    $ExistingEntries = @(Get-ChildItem -LiteralPath $LedgerDir -File -Filter "INTAKE_LEDGER_ENTRY_*.md" -ErrorAction SilentlyContinue)
    $Counter = $ExistingEntries.Count + 1
    $CounterText = "{0:D6}" -f $Counter
    $ObjectId = "INTAKE-$Date-$CounterText-DATA-ORDER-OUROBOROS"

    $EntryPath = Join-Path $LedgerDir "INTAKE_LEDGER_ENTRY_${Date}_${CounterText}_DATA_ORDER_OUROBOROS.md"
    $ReceiptPath = Join-Path $ProofDir "FIRST_INTAKE_LEDGER_ENTRY_RECEIPT_$Stamp.txt"

    $SourceArchitecture = "BRAIN_LEARNING\DATA_ORDER_OUROBOROS_LEDGER_ARCHITECTURE_20260521.md"
    $SourceCard = "HOUSE_WORK\WORK_SHED\GEAR_RACK\RULE_MACHINES\INTAKE_LEDGER_OUROBOROS_CARD_20260521.md"
    $SourceReview = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\DATA_ORDER_OUROBOROS_LEDGER_INSTALL_REVIEW_20260521.md"
    $SourceReceipt = "PROOF_HISTORY\DATA_ORDER_OUROBOROS_LEDGER_INSTALL_RECEIPT_20260521.txt"

    $RequiredSources = @($SourceArchitecture, $SourceCard, $SourceReview, $SourceReceipt)
    foreach ($Source in $RequiredSources) {
        if (-not (Test-Path -LiteralPath $Source)) {
            throw "STOP. Required source missing for Wave 1: $Source"
        }
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

    Add-Content -LiteralPath $StatusPath -Value @"

## $Stamp - First Intake Ledger Entry created

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
"@ -Encoding UTF8

    Set-Content -LiteralPath $AnchorPath -Value @"
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
"@ -Encoding UTF8

    Set-Content -LiteralPath $ReceiptPath -Value @"
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
"@ -Encoding UTF8

    Assert-Needle -Path $EntryPath -Text $ObjectId
    Assert-Needle -Path $EntryPath -Text "ACTIVE PROOF SEED / PASS WITH LEDGER-LOOP WATCH"
    Assert-Needle -Path $ReceiptPath -Text "FIRST INTAKE LEDGER ENTRY RECEIPT"

    $Commit = Commit-And-Push -Files @($EntryPath, $ReceiptPath, $StatusPath, $AnchorPath) -Message "Record first intake ledger entry"
    $WaveResults.Add("Wave 1: PASS - first intake ledger entry saved at $Commit | Object ID: $ObjectId | Entry SHA256: $EntryHash")
}

# WAVE 2: Add intake ledger README and template kit, if missing.

$ReadmePath = Join-Path $LedgerDir "README_INTAKE_LEDGER_$Date.md"
$TemplatePath = Join-Path $TemplateDir "INTAKE_LEDGER_ENTRY_TEMPLATE_$Date.md"
$IndexPath = Join-Path $LedgerDir "INTAKE_LEDGER_INDEX_$Date.md"
$Wave2ReceiptPath = Join-Path $ProofDir "INTAKE_LEDGER_WORKING_KIT_RECEIPT_$Stamp.txt"

$Wave2Files = @($ReadmePath, $TemplatePath, $IndexPath, $Wave2ReceiptPath, $StatusPath, $AnchorPath)

if ((Test-Path -LiteralPath $ReadmePath) -and (Test-Path -LiteralPath $TemplatePath) -and (Test-Path -LiteralPath $IndexPath)) {
    $WaveResults.Add("Wave 2: SKIPPED - intake ledger README/template/index already exist for $Date")
}
else {
    if (Test-Path -LiteralPath $Wave2ReceiptPath) {
        throw "STOP. Refusing to overwrite Wave 2 receipt: $Wave2ReceiptPath"
    }

    Set-Content -LiteralPath $ReadmePath -Value @'
# Intake Ledger README

## Purpose

This ledger records objects that enter the Clean Seed / Mr.Kleen working system.

The aim is not paperwork for its own sake.

The aim is custody.

Ledger beats checker because stale, duplicate, loose, or ghost material becomes visible when every entering object has identity, source, status, relation, and next action.

## Core Order

Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> Data Collection

## Short Machine

Collect. Count. Clean. Manage. Move. Return.

## Entry Rule

If it enters, it gets an ID.
If it changes, it gets a hash.
If it relates, it gets a link.
If it stacks, the stack gets captured.
If it collapses, parent IDs are preserved.

## When To Use

Use this ledger for:

- bulky files
- incoming packets
- rule stacks
- source-ore jobs
- correction clusters
- mule returns
- major receipts
- work packets
- architecture captures

## Not For

Do not ledger every tiny chat sentence.

Use the ledger when the object needs custody, retrieval, proof, relation, or future action.

## Boundary

This ledger is support infrastructure.

It does not rewrite doctrine.
It does not rewrite ACTIVE_GUIDES.
It does not rewrite CURRENT_TRUTH_INDEX.
It does not install a runtime checker.
'@ -Encoding UTF8

    Set-Content -LiteralPath $TemplatePath -Value @'
# Intake Ledger Entry Template

## Object ID

[ID]

## Human Label

[LABEL]

## Entry Type

[file / rule / idea / fix / packet / receipt / source-ore / correction-stack / mule-return / other]

## Entry Time

[TIMESTAMP]

## Source

[SOURCE]

## Source Hash

[SHA256 or N/A]

## Lane

Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> Data Collection

## Stage Classification

Data Collection:
[How it entered]

Inventory:
[ID/hash/source/type]

Housekeeping:
[Placement/cleanup/quarantine]

Data Management:
[Status/relation/freshness/proof]

Workflow:
[Next action]

## Parent / Stack Relation

Parent:
[PARENT ID or N/A]

Stack:
[STACK ID or N/A]

Related:
[RELATED IDs or N/A]

## Proof Level

[unverified / readback-backed / receipt-backed / git-backed / tested]

## Status

[active provisional / held idea / parked / rejected / collapsed / proof seed / done]

## Next Allowed Action

[NEXT ACTION]

## Stale Watch

Flag if missing:

- object ID
- source
- hash where applicable
- lane
- status
- relation
- next action

## Boundary

[BOUNDARY]
'@ -Encoding UTF8

    $Entries = @(Get-ChildItem -LiteralPath $LedgerDir -File -Filter "INTAKE_LEDGER_ENTRY_*.md" -ErrorAction SilentlyContinue | Sort-Object Name)
    $EntryLines = foreach ($Entry in $Entries) {
        $Hash = (Get-FileHash -LiteralPath $Entry.FullName -Algorithm SHA256).Hash
        "- $($Entry.Name) | SHA256: $Hash"
    }
    if ($EntryLines.Count -eq 0) { $EntryLines = @("- No intake ledger entries found yet.") }

    Set-Content -LiteralPath $IndexPath -Value @"
# Intake Ledger Index

Created: $(Get-Date -Format o)

## Purpose

Index of intake ledger entries and support files.

## Entries

$($EntryLines -join "`n")

## Support Files

- README_INTAKE_LEDGER_$Date.md
- TEMPLATES/INTAKE_LEDGER_ENTRY_TEMPLATE_$Date.md

## Watch

Keep this index lightweight. It is a finding surface, not the ledger itself.
"@ -Encoding UTF8

    $ReadmeHash = (Get-FileHash -LiteralPath $ReadmePath -Algorithm SHA256).Hash
    $TemplateHash = (Get-FileHash -LiteralPath $TemplatePath -Algorithm SHA256).Hash
    $IndexHash = (Get-FileHash -LiteralPath $IndexPath -Algorithm SHA256).Hash

    Add-Content -LiteralPath $StatusPath -Value @"

## $Stamp - Intake Ledger working kit created

Files:
- $ReadmePath
- $TemplatePath
- $IndexPath

Meaning:
The ledger now has a README, reusable entry template, and lightweight index.

Boundary:
No doctrine rewrite, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime checker install.
"@ -Encoding UTF8

    Set-Content -LiteralPath $AnchorPath -Value @"
ACTIVE ANCHOR

Current position:
main @ pending Intake Ledger working kit save

Current boss:
Intake Ledger working kit.

Current verdict target:
PASS AS LEDGER WORKING KIT.

Next allowed move:
Use intake-ledger entry format on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster.

Blocked moves:
- Do not treat ledger README/template as doctrine.
- Do not ledger every tiny chat sentence.
- Do not rewrite ACTIVE_GUIDES from this save.
- Do not rewrite CURRENT_TRUTH_INDEX from this save.
- Do not install runtime checker from this save.
"@ -Encoding UTF8

    Set-Content -LiteralPath $Wave2ReceiptPath -Value @"
INTAKE LEDGER WORKING KIT RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PENDING COMMIT AT RECEIPT WRITE

Start branch:
$StartBranch

Start head:
$StartHead

Files:
$ReadmePath | SHA256: $ReadmeHash
$TemplatePath | SHA256: $TemplateHash
$IndexPath | SHA256: $IndexHash

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No runtime checker install.
No bridge permission expansion.
No junction/symlink teleporter.

Next:
Use intake-ledger entry format on the next real incoming object.
"@ -Encoding UTF8

    Assert-Needle -Path $ReadmePath -Text "Ledger beats checker"
    Assert-Needle -Path $TemplatePath -Text "Intake Ledger Entry Template"
    Assert-Needle -Path $IndexPath -Text "Intake Ledger Index"
    Assert-Needle -Path $Wave2ReceiptPath -Text "INTAKE LEDGER WORKING KIT RECEIPT"

    $Commit = Commit-And-Push -Files $Wave2Files -Message "Add intake ledger working kit"
    $WaveResults.Add("Wave 2: PASS - intake ledger README/template/index saved at $Commit")
}

# WAVE 3: Create a compact next-use packet and stop for user input.

$NextPacketPath = Join-Path $LedgerDir "NEXT_USE_PACKET_$Date.md"
$Wave3ReceiptPath = Join-Path $ProofDir "INTAKE_LEDGER_NEXT_USE_PACKET_RECEIPT_$Stamp.txt"

if ((Test-Path -LiteralPath $NextPacketPath)) {
    $WaveResults.Add("Wave 3: SKIPPED - next-use packet already exists for $Date")
}
else {
    Set-Content -LiteralPath $NextPacketPath -Value @'
# Intake Ledger Next-Use Packet

## Purpose

This packet defines when the next ledger entry should be made.

## Use On The Next

- bulky file
- incoming packet
- rule stack
- source-ore job
- correction cluster
- mule return
- proof-gap object
- artifact delivery failure
- file-first work packet

## Required Fields

Minimum entry must include:

- object ID
- source
- type
- lane
- hash when applicable
- status
- relation or "none"
- next action
- boundary

## Stop Condition

Stop and ask for user input when there is no new object to intake.

Do not invent an object just to fill the ledger.

## Boundary

Ledger entries must represent real objects or real correction clusters.
'@ -Encoding UTF8

    $NextPacketHash = (Get-FileHash -LiteralPath $NextPacketPath -Algorithm SHA256).Hash

    Set-Content -LiteralPath $Wave3ReceiptPath -Value @"
INTAKE LEDGER NEXT USE PACKET RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PENDING COMMIT AT RECEIPT WRITE

Packet:
$NextPacketPath

Packet SHA256:
$NextPacketHash

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No runtime checker install.

Stop condition:
Stop and ask for user input when there is no new object to intake.
"@ -Encoding UTF8

    Add-Content -LiteralPath $StatusPath -Value @"

## $Stamp - Intake Ledger next-use packet created

Packet:
- $NextPacketPath

Meaning:
The next ledger entry should only be made when a real incoming object/stack appears. Do not invent ledger work.

Next move:
Wait for next bulky file, incoming packet, rule stack, source-ore job, correction cluster, mule return, proof-gap object, or artifact delivery failure.
"@ -Encoding UTF8

    Set-Content -LiteralPath $AnchorPath -Value @"
ACTIVE ANCHOR

Current position:
main @ pending Intake Ledger next-use packet save

Current boss:
Intake Ledger next-use stop point.

Current verdict target:
PASS / READY FOR NEXT REAL INTAKE OBJECT.

Next allowed move:
Wait for the next real object to intake.

Blocked moves:
- Do not invent a ledger object.
- Do not create more architecture without a new input.
- Do not rewrite ACTIVE_GUIDES.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not install runtime checker.
"@ -Encoding UTF8

    Assert-Needle -Path $NextPacketPath -Text "Do not invent an object just to fill the ledger."
    Assert-Needle -Path $Wave3ReceiptPath -Text "INTAKE LEDGER NEXT USE PACKET RECEIPT"

    $Commit = Commit-And-Push -Files @($NextPacketPath, $Wave3ReceiptPath, $StatusPath, $AnchorPath) -Message "Add intake ledger next use packet"
    $WaveResults.Add("Wave 3: PASS - next-use packet saved at $Commit | Packet SHA256: $NextPacketHash")
}

$FinalHead = (git rev-parse HEAD).Trim()
$FinalOrigin = (git rev-parse "origin/$StartBranch").Trim()
Stop-IfDirty "final"

if ($FinalHead -ne $FinalOrigin) {
    throw "STOP. Final HEAD does not match origin.`nHEAD: $FinalHead`nORIGIN: $FinalOrigin"
}

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "LEDGER NEXT WAVES COMPLETE"
Write-Host "Verdict: PASS / STOPPED AT NEXT REAL INTAKE OBJECT"
Write-Host "Start: $StartBranch @ $StartHead"
Write-Host "Final: $StartBranch @ $FinalHead"
Write-Host "Origin: $FinalOrigin"
foreach ($Result in $WaveResults) {
    Write-Host $Result
}
Write-Host "Status: clean"
Write-Host "Boundary: no doctrine rewrite; no ACTIVE_GUIDES rewrite; no CURRENT_TRUTH_INDEX rewrite; no runtime checker install; no bridge permission expansion; no junction/symlink teleporter."
Write-Host "Need user now: YES - next wave needs a real incoming object, packet, rule stack, source-ore job, correction cluster, mule return, or proof-gap object."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
