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
    throw "STOP. House is dirty before save. Clean/checkpoint first.`n$($StartStatus -join "`n")"
}

$Date = Get-Date -Format "yyyyMMdd"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$BrainDir = "BRAIN_LEARNING"
$GearDir = "HOUSE_WORK\WORK_SHED\GEAR_RACK\RULE_MACHINES"
$SortingDir = "HOUSE_WORK\WORK_SHED\SORTING_BENCH"
$IndexDir = "HOUSE_WORK\INDEXES"
$ProofDir = "PROOF_HISTORY"

New-Item -ItemType Directory -Force -Path $BrainDir, $GearDir, $SortingDir, $IndexDir, $ProofDir | Out-Null

$ArchitecturePath = Join-Path $BrainDir "DATA_ORDER_OUROBOROS_LEDGER_ARCHITECTURE_$Date.md"
$CardPath = Join-Path $GearDir "INTAKE_LEDGER_OUROBOROS_CARD_$Date.md"
$ReviewPath = Join-Path $SortingDir "DATA_ORDER_OUROBOROS_LEDGER_INSTALL_REVIEW_$Date.md"
$ReceiptPath = Join-Path $ProofDir "DATA_ORDER_OUROBOROS_LEDGER_INSTALL_RECEIPT_$Date.txt"
$StatusPath = Join-Path $IndexDir "CURRENT_HOUSE_WORK_STATUS.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"

$NewTargets = @($ArchitecturePath, $CardPath, $ReviewPath, $ReceiptPath)
foreach ($Target in $NewTargets) {
    if (Test-Path -LiteralPath $Target) {
        throw "STOP. Refusing to overwrite existing file: $Target"
    }
}

$Architecture = @'
# Data Order / Ouroboros Ledger Architecture

## Status

House learning / architecture support.

Not doctrine.
Not ACTIVE_GUIDES.
Not CURRENT_TRUTH_INDEX.
Not Hard Suit.

## Purpose

Create a clear ordered loop for how material enters, receives identity, gets placed, becomes managed state, turns into workflow, and returns as new intake.

This is the larger architecture behind replacing loose stale-checking with ledgered intake.

## Core Loop

Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> new Data Collection

This is not a flat checklist.

It is an ouroboros loop.

The end feeds the beginning.

Workflow produces outputs and actions.
Outputs and actions create new material.
New material returns to Data Collection.

## Planet / Orbit Image

Each stage is its own room/orbit:

1. Data Collection
2. Inventory
3. Housekeeping
4. Data Management
5. Workflow

They remain distinct, but they move as one system.

## Stage 1: Data Collection

Raw entry point.

Things that enter:

- files
- rules
- ideas
- fixes
- corrections
- source ore
- receipts
- logs
- mule returns
- user critiques
- assistant failures
- outside concepts
- work packets

Purpose:

Capture incoming material without losing it or crowning it too early.

## Stage 2: Inventory

Identity and custody.

Every entering object gets:

- unique ID
- timestamp
- source
- type
- content hash where applicable
- parent relation
- stack relation
- current lane
- proof status

Purpose:

Make loose material accountable.

## Stage 3: Housekeeping

Placement and cleanup.

Actions:

- place in room/lane
- tag duplicates
- quarantine strange material
- separate active from parked
- separate source ore from authority
- clean naming
- protect neighbors

Purpose:

Stop clutter from becoming fog.

## Stage 4: Data Management

Living state.

Tracks:

- status
- freshness
- relation map
- version
- proof level
- retrieval path
- active/provisional/parked/rejected/collapsed state
- next allowed move

Purpose:

Keep material usable over time.

## Stage 5: Workflow

Action routing.

Decides:

- use now
- test
- save
- send to mule
- make packet
- collapse rule family
- archive
- wait
- return to collection

Purpose:

Turn managed state into clean work.

## Stale Checker Collapse

The stale checker does not need to exist only as a separate gate.

Better principle:

Ledger beats checker.

If every entering object signs in, gets an ID, gets a hash, gets a lane, and gets relations, then stale material becomes easier to detect through broken custody.

Stale warning signs:

- no ledger entry
- missing source
- wrong hash
- outdated parent
- duplicate role
- broken relation
- unplaced file
- active object with no status
- workflow action without inventory
- collapsed rule with missing parent stack

## Ledger Rule

If it enters, it gets an ID.
If it changes, it gets a hash.
If it relates, it gets a link.
If it stacks, the stack gets captured.
If it collapses, parent IDs are preserved.

## Rule Bloom Connection

Rule Bloom says:

Issue -> active provisional rule/idea -> stack capture -> firing evidence -> grouping -> collapse/compress -> promote, park, or retire

This belongs inside the same loop.

A correction enters through Data Collection.
Inventory gives it identity.
Housekeeping places it in rule-bloom/stack lane.
Data Management tracks status and evidence.
Workflow tests or collapses it.

## Broad-Bite Collapse Connection

Broad-Bite says:

Small Rule. Wide Bite.

A pile of provisional rules is allowed temporarily if it reveals a hidden family. Later, the stack collapses into a dense bulldog rule.

Rule Bloom creates pressure.
Inventory preserves the stack.
Data Management tracks evidence.
Broad-Bite collapse compresses the family.

## Black-Hole / White-Hole Source Pattern

Source-pattern only. Not physics doctrine.

Black-hole side:

Data Collection + Inventory

Meaning:

- intake
- boundary
- capture
- compression
- identity
- nothing passes casually

White-hole side:

Workflow / Output

Meaning:

- release
- action
- manifestation
- packet
- rule
- receipt
- output

Ouroboros bridge:

Output returns as new input.

Short form:

Intake compresses.
Workflow releases.
Output returns.

## Condensing Ideas Into Solid Things

A useful condensation should make something solid.

Solid things include:

- rule
- card
- route
- packet
- file
- receipt
- ledger entry
- ID scheme
- workflow
- proof structure
- readback
- handoff

Test:

Can this idea be held, placed, run, verified, or reused?

If not, it is not condensed enough yet.

## Engine Framing

Other systems may use similar concepts to produce outputs directly.

Clean Seed is taking the longer route:

Build the output-producing machine.

This route is slower at first because it creates:

- intake
- inventory
- housekeeping
- data management
- workflow
- proof
- rule compression
- reusable packets

Once the loop is coherent, work should move faster because the system stops rebuilding from scratch.

## Weak PC / Strong Engine Framing

The practical target is not raw PC power.

The target is structure carrying the load.

A weaker PC can punch above its weight when the system uses:

- file-first packets
- hashes
- IDs
- ledgers
- clean rooms
- compressed rules
- receipts
- reusable workflows
- smaller active context
- clear next actions

Bulldog phrase:

Weak box. Strong engine.

## Large Model / Company Framing

This architecture may also help larger models and companies.

Same structural logic, different engine size.

On a weak PC:

Structure creates leverage and access.

On a huge model:

Structure amplifies enormous power and reduces wasted capacity.

Provisional value claim:

A clean operating environment can make any model perform above its raw baseline by reducing live context burden and improving routing, auditability, proof, and output reliability.

## Working Mottos

Small Rule. Wide Bite.

Catch the family, not the symptom.

Bloom every fix. Collect every stack. Collapse only after pattern proof.

Ledger beats checker.

Every guest signs in before it gets a room or a job.

Collect. Count. Clean. Manage. Move. Return.

Intake compresses. Workflow releases. Output returns.

Condense until it can work.

Build the engine slow. Let it bite fast.

Weak box. Strong engine.

Same machine logic. Different engine size.

## Boundary

This architecture does not rewrite doctrine.
This architecture does not rewrite ACTIVE_GUIDES.
This architecture does not rewrite CURRENT_TRUTH_INDEX.
This architecture does not promote source ore into authority.
This architecture does not install a runtime checker.
This architecture does not expand bridge permissions.
This architecture does not create junctions or symlinks.
'@

$Card = @'
# Intake Ledger Ouroboros Card

## Status

Rule-machine support card.

## Core Order

Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> Data Collection

## One-Line Machine

Collect. Count. Clean. Manage. Move. Return.

## Core Ledger Claim

Stale checking improves when intake identity is unavoidable.

A separate checker is weaker than a system where every entering object has custody.

## Intake Object Fields

Each entering object should eventually be able to carry:

- object ID
- human label
- source
- entry time
- type
- lane/room
- content hash when applicable
- parent ID
- stack ID
- relation links
- proof level
- status
- next allowed action
- owner/actor if relevant
- collapse target if merged
- retirement reason if retired

## ID Direction

Do not rely on pi or golden ratio for proof uniqueness.

Golden ratio or pi may be explored as naming flavor, rhythm, sequence aesthetics, or human-facing style.

Proof identity should rely on:

- timestamp
- monotonic counter
- short human label
- content SHA256
- optional UUID-style entropy

Example:

Human ID:
BITE-PHI-000021

Custody ID:
20260521-000021-RULEBLOOM

Proof:
SHA256 content hash

Relation:
parent stack ID + collapse target ID

## Stale Warning Flags

Flag an object as stale/suspicious when:

- no ledger entry
- no source
- no hash for hashable content
- wrong hash
- outdated parent
- duplicate active role
- broken relation
- unplaced file
- active object with no status
- workflow action without inventory
- collapsed rule with missing parent stack
- source ore treated as authority
- Soft Suit treated as Hard Suit without proof

## Rule Bloom Relation

When an issue is addressed:

1. collect it
2. inventory it
3. place it
4. manage proof/status
5. route the next action

When a stack appears:

1. give stack identity
2. preserve item identities
3. group without early collapse
4. watch firing evidence
5. collapse only after pattern proof

## File-First Relation

Large work should travel as a file packet when practical.

Chat steers.
Files carry the pile.
Receipts prove the route.

## Next Live Test

Use this card on the next incoming bulky file, rule stack, source-ore packet, or correction cluster.
'@

$Review = @'
# Data Order / Ouroboros Ledger Install Review

## Active Boss

Install the Data Order / Ouroboros Ledger architecture as house learning and rule-machine support.

## Lane

Architecture support / data-order learning / rule-machine support.

## Why

Recent work showed that stale checking is not mainly a separate checker problem.

The deeper route is:

Every entering object needs custody, identity, placement, status, relation, and next action.

## Broadening Result

The family is larger than stale checking.

It includes:

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

## Installed Support Objects

1. Data Order / Ouroboros Ledger Architecture
2. Intake Ledger Ouroboros Card
3. Install Review
4. Proof Receipt
5. Current House Work Status update
6. Active Anchor update

## Boundary

No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No runtime checker install.
No bridge permission expansion.
No junction/symlink teleporter.
No source-ore authority promotion.

## Next Live Test

Use the Intake Ledger Ouroboros Card on the next bulky file, incoming packet, rule stack, or correction cluster.
'@

Set-Content -LiteralPath $ArchitecturePath -Value $Architecture -Encoding UTF8
Set-Content -LiteralPath $CardPath -Value $Card -Encoding UTF8
Set-Content -LiteralPath $ReviewPath -Value $Review -Encoding UTF8

$StatusEntry = @"

## $Stamp - Data Order / Ouroboros Ledger architecture installed

Start position: $StartBranch @ $StartHead

Installed support package:

- $ArchitecturePath
- $CardPath
- $ReviewPath
- $ReceiptPath

Verdict target: PASS WITH LEDGER-LOOP WATCH.

Meaning:
Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> new Data Collection is now captured as a provisional architecture loop. Ledgered intake is the preferred replacement direction for loose stale-checking.

Boundary:
No doctrine rewrite, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime checker install, no bridge permission expansion, no junction/symlink teleporter.

Next move:
Use the Intake Ledger Ouroboros Card on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusEntry -Encoding UTF8

$Anchor = @"
ACTIVE ANCHOR

Current position:
main @ pending Data Order / Ouroboros Ledger save

Current boss:
Data Order / Ouroboros Ledger architecture.

Current verdict target:
PASS WITH LEDGER-LOOP WATCH.

Installed intent:
Use Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> return as the ordered loop for ledgered intake and stale-check replacement.

Next allowed move:
Use the Intake Ledger Ouroboros Card on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster.

Blocked moves:
- Do not treat this as doctrine.
- Do not rewrite ACTIVE_GUIDES from this install.
- Do not rewrite CURRENT_TRUTH_INDEX from this install.
- Do not install a runtime checker from this save.
- Do not expand bridge permissions.
- Do not create junction/symlink teleporters.
- Do not use pi/golden ratio as proof uniqueness by itself.
"@

Set-Content -LiteralPath $AnchorPath -Value $Anchor -Encoding UTF8

$FilesForHash = @($ArchitecturePath, $CardPath, $ReviewPath, $StatusPath, $AnchorPath)
$HashLines = foreach ($Path in $FilesForHash) {
    $Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    "$Path | SHA256: $Hash"
}

$Receipt = @"
DATA ORDER / OUROBOROS LEDGER INSTALL RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PENDING COMMIT AT RECEIPT WRITE

Start:
Branch: $StartBranch
HEAD: $StartHead
Origin: $StartOrigin
Initial status: clean

Installed:
$ArchitecturePath
$CardPath
$ReviewPath
$StatusPath
$AnchorPath

Hashes:
$($HashLines -join "`n")

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No runtime checker install.
No bridge permission expansion.
No junction/symlink teleporter.
No source-ore authority promotion.

Core loop:
Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> Data Collection

Mottos:
Ledger beats checker.
Collect. Count. Clean. Manage. Move. Return.
Intake compresses. Workflow releases. Output returns.
Weak box. Strong engine.

Next allowed move:
Use the Intake Ledger Ouroboros Card on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$AllFiles = @($ArchitecturePath, $CardPath, $ReviewPath, $ReceiptPath, $StatusPath, $AnchorPath)

foreach ($Path in $AllFiles) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "STOP. Expected file missing: $Path"
    }
    if ((Get-Item -LiteralPath $Path).Length -le 0) {
        throw "STOP. Expected file empty: $Path"
    }
}

$Needles = @(
    @{ Path = $ArchitecturePath; Text = "Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> new Data Collection" },
    @{ Path = $ArchitecturePath; Text = "Ledger beats checker." },
    @{ Path = $ArchitecturePath; Text = "Weak box. Strong engine." },
    @{ Path = $CardPath; Text = "Collect. Count. Clean. Manage. Move. Return." },
    @{ Path = $CardPath; Text = "Do not rely on pi or golden ratio for proof uniqueness." },
    @{ Path = $ReviewPath; Text = "The family is larger than stale checking." },
    @{ Path = $ReceiptPath; Text = "No doctrine rewrite." },
    @{ Path = $AnchorPath; Text = "PASS WITH LEDGER-LOOP WATCH" }
)

foreach ($Needle in $Needles) {
    $Content = Get-Content -LiteralPath $Needle.Path -Raw
    if ($Content -notlike "*$($Needle.Text)*") {
        throw "STOP. Proof needle missing from $($Needle.Path): $($Needle.Text)"
    }
}

$PostWriteStatus = @(git status --short)
if ($PostWriteStatus.Count -eq 0) {
    throw "STOP. No git changes detected after write."
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

git commit -m "Add data order ouroboros ledger"

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
Write-Host "DATA ORDER OUROBOROS LEDGER APPLIED TO HOUSE"
Write-Host "Verdict: PASS WITH LEDGER-LOOP WATCH"
Write-Host "Start: $StartBranch @ $StartHead"
Write-Host "Commit: $FinalHead"
Write-Host "Origin: $FinalOrigin"
Write-Host "Architecture: $ArchitecturePath"
Write-Host "Card: $CardPath"
Write-Host "Review: $ReviewPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Status: clean"
Write-Host "Boundary: no doctrine rewrite; no ACTIVE_GUIDES rewrite; no CURRENT_TRUTH_INDEX rewrite; no runtime checker install; no bridge permission expansion; no junction/symlink teleporter."
Write-Host "Next: use Intake Ledger Ouroboros Card on the next bulky file, incoming packet, rule stack, source-ore job, or correction cluster."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
