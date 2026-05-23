$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$Pickup = Join-Path $CommandCenter "PICKUP"
$Receipts = Join-Path $CommandCenter "RECEIPTS"
$Backups = Join-Path $Pickup "_BACKUPS"
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

foreach ($d in @($CommandCenter, $Pickup, $Receipts, $Backups)) {
    if (-not (Test-Path -LiteralPath $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

$AddendumPath = Join-Path $Pickup ("MULE_PACKET_ADDENDUM_GATE_ORDER_REVIEW_0.md" -f $Now)
$ReadFirstPath = Join-Path $Pickup "MULE_READ_FIRST_CURRENT_GATE_ORDER_REVIEW.md"
$ReceiptPath = Join-Path $Receipts ("LOCAL_123_MULE_PACKET_GATE_ORDER_REVIEW_UPDATE_RECEIPT_0.txt" -f $Now)

$AddendumContent = @'
# Mule Packet Addendum — Gate Order / Clean-Fit Gate Search / Resident Parking Update

Status: LOCAL 123 MULE PACKET UPDATE / READ FIRST
Scope: update mule on new gate-order logic, Alpha Omega/Hindsight order, Cube/final-ideas parking, and the next review task.
Boundary: local only, no Git, no doctrine, no gate promotion, no CONSOLIDATOR activation.

## 1. New Changes Mule Must Know

### A. Guest Boundary Gate Set

Current candidate gate family includes:

- Problem Solving Gate
- Boundaries Gate
- Permission Gate
- Guest Boundary Gate
- Return-Home Gate
- Enforcement Ladder Gate
- Creative Gate / Wildcard / Emergence
- Future Plans / Idea-Leading / Giving Room for Growth
- Proof / Receipt Gate
- Final Judge
- CONSOLIDATOR Candidate
- Alpha Omega Candidate
- Hindsight Lens / Neighbor

The gate set exists to stop bloat from becoming mess:
each gate must have a real job, clean boundary, neighbor relationship, proof requirement, and return-home condition.

### B. Hindsight Before Alpha Omega Close

Correct order:

`Alpha opens fresh -> work/gates/proof run -> hindsight review -> Omega closes -> final clean status`

Hindsight is not the first door.
Hindsight is the rearview mirror before final exit.

Alpha Omega may use hindsight, but hindsight is a neighbor/lens, not swallowed into Alpha Omega.

### C. Alpha Omega Job

Alpha Omega judges the whole loop.

Alpha side:
- what opened the loop;
- what seed problem/source/boundary started it;
- what gate fires first.

Omega side:
- what survived;
- what was applied;
- what was parked;
- what was rejected;
- what proof exists;
- what returned home;
- whether user got clean status.

Blocked:
- Alpha Omega becoming king gate;
- replacing proof;
- replacing Final Judge;
- forcing all gates into one;
- activating CONSOLIDATOR.

### D. CONSOLIDATOR Later

CONSOLIDATOR is not active yet.

When activated later, its job is:
- find ambiguity;
- identify duplicate/overlapping gate logic;
- place old gate logic into the better gate;
- add new logic to the gate that naturally owns it;
- keep broad ideas packed into one clean gate when possible;
- preserve distinct gates when merging would flatten useful difference.

CONSOLIDATOR must not flatten living gates too early.

### E. Cube / Final Ideas

Only Cube / final ideas content stays out of Git.

It is local-only resident parking / extended parking material.

Preferred local parking path:

`Desktop\123\COMMAND_CENTER\RESIDENT_PARKING\DAY_DREAMS\CUBE_FINAL_IDEAS`

If older Day Dreams material exists in:

`Desktop\123\COMMAND_CENTER\PICKUP\DAY_DREAMS`

treat it as local symbolic/finals source material only.

Cube / final ideas are:
- useful for finals/presentation/symbolic layer;
- allowed as optional mule-visible reference;
- not part of Final Order;
- not gate order;
- not doctrine;
- not proof;
- not authority;
- not CONSOLIDATOR input unless explicitly pulled later.

## 2. Mule Task Now

Walk the house/check the gate set and run three full conceptual spins.

The task is not to bloat.

The task is to find more gate ideas only if they cleanly fit the build.

A new gate cleanly fits only if it has:
- a distinct job;
- a clear trigger;
- a boundary;
- a neighbor relationship;
- a proof/receipt need;
- a return-home or close condition;
- no better home inside an existing gate.

If it can live inside an existing gate, do not create a new gate.

## 3. Three Spins

### Spin 1 — Practical Fit

Check:
- Does each gate solve a real exposed issue?
- Is the gate too broad?
- Is the gate too narrow?
- Is it only a step inside another gate?
- Is it necessary for guest/front-door/boundary/order work?

### Spin 2 — Logical Order / Neighbor Fit

Find the most logical order.

Candidate order to inspect:

1. Alpha opens fresh
2. Problem Solving Gate
3. Boundaries Gate
4. Permission Gate
5. Guest Boundary Gate
6. Creative Gate / Wildcard / Emergence
7. Future Plans / Idea-Leading / Giving Room for Growth
8. Return-Home Gate
9. Enforcement Ladder Gate
10. Proof / Receipt Gate
11. Hindsight Lens
12. Omega closes
13. Final Judge / final clean status

Mule should challenge this order if another order makes cleaner sense.

### Spin 3 — Consolidation Readiness

Find:
- ambiguity;
- overlap;
- duplicate logic;
- gate logic that belongs under another gate;
- broad idea that should stay packed into one gate;
- new friends/neighbors;
- gates that are not ready;
- gates that should be parked.

Do not activate CONSOLIDATOR.
Only prepare the consolidation question.

## 4. Output Required From Mule

Return a report with:

1. Verdict:
   PASS / PASS WITH GUARDRAILS / PARTIAL / FAIL

2. Best gate order:
   list gates in clean operating order.

3. Gate table:
   - gate name;
   - job;
   - trigger;
   - boundary;
   - neighbor before/after;
   - proof/receipt;
   - whether it stays separate or should be packed into another gate.

4. New gate ideas that cleanly fit:
   include only if they pass the clean-fit test.

5. Gates that should not exist separately:
   name where their logic should move.

6. CONSOLIDATOR prep:
   what ambiguity CONSOLIDATOR should later resolve.

7. Alpha Omega inspection:
   whether it is gate, lens, or checklist;
   where hindsight belongs;
   what Alpha Omega must never do.

8. Cube/final-ideas boundary:
   confirm Cube/final ideas stay local-only resident parking and out of Final Order.

## 5. Hard Boundary

No doctrine promotion.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No CONSOLIDATOR activation.
No public authority change.
No Git for Cube/final ideas content.
No treating local Day Dreams/Cube material as gate logic unless explicitly pulled.

'@

$ReadFirstContent = @'
# MULE READ FIRST — Current Gate Order Review Packet

Status: LOCAL 123 READ-FIRST POINTER
Purpose: tell mule what changed after the original packet and where to start.

## Read Order

1. This file.
2. `MULE_PACKET_ADDENDUM_GATE_ORDER_REVIEW_<timestamp>.md`
3. Existing mule handoff packet if present:
   `MULE_HANDOFF_GUEST_BOUNDARY_GATES_THREE_SPINS_ALPHA_OMEGA_*.md`
4. Optional local-only resident parking if needed:
   `COMMAND_CENTER\RESIDENT_PARKING\DAY_DREAMS\CUBE_FINAL_IDEAS`
5. Older Day Dreams pickup only as local symbolic source material:
   `COMMAND_CENTER\PICKUP\DAY_DREAMS`

## Main Task

Look for more gate ideas that cleanly fit the build and ensure the gate order makes the most logical sense.

Do not bloat.
Do not promote.
Do not activate CONSOLIDATOR.
Do not put Cube/final ideas in Git or Final Order.

## Key New Rule

Hindsight happens before Alpha Omega closes:

`Alpha opens fresh -> work/gates/proof run -> hindsight review -> Omega closes -> final clean status`

'@

Set-Content -LiteralPath $AddendumPath -Value $AddendumContent -Encoding UTF8
Set-Content -LiteralPath $ReadFirstPath -Value $ReadFirstContent -Encoding UTF8

$ExistingPacket = Get-ChildItem -LiteralPath $Pickup -Filter "MULE_HANDOFF_GUEST_BOUNDARY_GATES_THREE_SPINS_ALPHA_OMEGA*.md" -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

$AppendedTo = "<none found>"
$BackupPath = "<none>"

if ($ExistingPacket) {
    $AppendedTo = $ExistingPacket.FullName
    $BackupPath = Join-Path $Backups ("0.before_gate_order_addendum_1.md" -f $ExistingPacket.BaseName, $Now)
    Copy-Item -LiteralPath $ExistingPacket.FullName -Destination $BackupPath -Force

    $AppendBlock = @"

---

# APPENDED LOCAL UPDATE — Gate Order Review / Clean-Fit Gate Search — $Now

This existing mule packet has a newer local addendum.

Read:
`$AddendumPath`

Core update:
- Hindsight happens before Alpha Omega closes.
- Cube/final ideas stay local-only Resident Parking, out of Git and out of Final Order.
- Mule should look for more gate ideas only if they cleanly fit.
- Mule should inspect the most logical gate order.
- CONSOLIDATOR remains inactive until ambiguity/overlap is proven through spins.
"@

    Add-Content -LiteralPath $ExistingPacket.FullName -Value $AppendBlock -Encoding UTF8
}

$AddendumHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $AddendumPath).Hash
$ReadFirstHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReadFirstPath).Hash

$ExistingHash = "<none>"
$BackupHash = "<none>"
if ($ExistingPacket) {
    $ExistingHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ExistingPacket.FullName).Hash
    $BackupHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $BackupPath).Hash
}

$Receipt = @"
LOCAL 123 MULE PACKET GATE ORDER REVIEW UPDATE RECEIPT

Timestamp: $Now

Updated local 123 mule packet area:
- $Pickup

Read-first pointer:
- $ReadFirstPath
  SHA256: $ReadFirstHash

New addendum:
- $AddendumPath
  SHA256: $AddendumHash

Existing packet appended:
- $AppendedTo
  SHA256 after append: $ExistingHash

Backup before append:
- $BackupPath
  SHA256: $BackupHash

Task added for mule:
- look for more gate ideas that cleanly fit the build;
- ensure gate order is logical;
- run three conceptual spins;
- inspect Alpha Omega and hindsight placement;
- prepare CONSOLIDATOR questions without activating it;
- keep Cube/final ideas local-only and out of Final Order.

Boundary:
- Local 123 only.
- No Git.
- No doctrine.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No CONSOLIDATOR activation.
- No gate promotion.
- No Cube/final ideas in Git.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

Write-Host ""
Write-Host "LOCAL 123 MULE PACKET GATE ORDER REVIEW UPDATE COMPLETE"
Write-Host "Pickup: $Pickup"
Write-Host "Read first: $ReadFirstPath"
Write-Host "Read first SHA256: $ReadFirstHash"
Write-Host "Addendum: $AddendumPath"
Write-Host "Addendum SHA256: $AddendumHash"
Write-Host "Existing packet appended: $AppendedTo"
Write-Host "Existing packet SHA256 after append: $ExistingHash"
Write-Host "Backup before append: $BackupPath"
Write-Host "Backup SHA256: $BackupHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS / LOCAL 123 MULE PACKET UPDATED / NO GIT"
