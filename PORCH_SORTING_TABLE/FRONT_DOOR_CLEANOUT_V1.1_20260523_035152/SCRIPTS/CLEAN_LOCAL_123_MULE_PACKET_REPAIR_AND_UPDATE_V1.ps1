# CLEAN_LOCAL_123_MULE_PACKET_REPAIR_AND_UPDATE_V1.ps1
# THIS CODE IS FOR LOCAL.
# Purpose: repair the local Desktop\123 mule packet after duplicated _0 addendum naming,
# add the Next Spin Sequencer update, and park new proven-better / boss-routing ideas cleanly.
# Boundary: local-only Desktop\123 / COMMAND_CENTER. No Git. No doctrine. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX.

$ErrorActionPreference = "Stop"

function Write-Section {
    param([string]$Text)
    Write-Host ""
    Write-Host "=== $Text ==="
}

function Get-Sha256 {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return "" }
    return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
}

function Count-Marker {
    param(
        [string]$Text,
        [string]$Pattern
    )
    return ([regex]::Matches($Text, $Pattern)).Count
}

$Root = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root "COMMAND_CENTER"
$Pickup = Join-Path $CommandCenter "PICKUP"
$Receipts = Join-Path $CommandCenter "RECEIPTS"

if (-not (Test-Path -LiteralPath $Root)) { throw "Missing Desktop\123 root: $Root" }
if (-not (Test-Path -LiteralPath $CommandCenter)) { throw "Missing COMMAND_CENTER: $CommandCenter" }
if (-not (Test-Path -LiteralPath $Pickup)) { throw "Missing PICKUP: $Pickup" }
if (-not (Test-Path -LiteralPath $Receipts)) { New-Item -ItemType Directory -Force -Path $Receipts | Out-Null }

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$RepairName = "MULE_PACKET_CLEANUP_$Stamp"

$BackupDir = Join-Path $Pickup "_BACKUPS\$RepairName"
$SupersededDir = Join-Path $Pickup "_SUPERSEDED\$RepairName"
$ReceiptSupersededDir = Join-Path $Receipts "_SUPERSEDED\$RepairName"
$NotesDir = Join-Path $Pickup "_PARKING_NOTES"
$TodoDir = Join-Path $CommandCenter "TODO"

New-Item -ItemType Directory -Force -Path $BackupDir, $SupersededDir, $ReceiptSupersededDir, $NotesDir, $TodoDir | Out-Null

$OldHandoff = Join-Path $Pickup "MULE_HANDOFF_GUEST_BOUNDARY_GATES_THREE_SPINS_ALPHA_OMEGA_0.md"
$OldAddendum = Join-Path $Pickup "MULE_PACKET_ADDENDUM_GATE_ORDER_REVIEW_0.md"
$ReadFirst = Join-Path $Pickup "MULE_READ_FIRST_CURRENT_GATE_ORDER_REVIEW.md"
$OldReceipt = Join-Path $Receipts "LOCAL_123_MULE_PACKET_GATE_ORDER_REVIEW_UPDATE_RECEIPT_0.txt"

$NewHandoff = Join-Path $Pickup "MULE_HANDOFF_GUEST_BOUNDARY_GATES_THREE_SPINS_ALPHA_OMEGA_$Stamp.md"
$NewAddendum = Join-Path $Pickup "MULE_PACKET_ADDENDUM_GATE_ORDER_REVIEW_$Stamp.md"
$OrderedList = Join-Path $NotesDir "MULE_PACKET_CLEANUP_ORDERED_THOUGHT_LIST_$Stamp.md"
$ParkingTodo = Join-Path $NotesDir "PARKING_TODO_PROVEN_BETTER_ADOPTION_BOSS_ROUTING_$Stamp.md"
$Receipt = Join-Path $Receipts "LOCAL_123_MULE_PACKET_CLEANUP_AND_SEQUENCER_UPDATE_RECEIPT_$Stamp.txt"

$ExpectedOld = @($OldHandoff, $OldAddendum, $ReadFirst, $OldReceipt)
$BeforeRows = @()

Write-Section "BACKUP TARGETS"
foreach ($Path in $ExpectedOld) {
    if (Test-Path -LiteralPath $Path) {
        $Item = Get-Item -LiteralPath $Path
        $Hash = Get-Sha256 -Path $Path
        $BackupPath = Join-Path $BackupDir $Item.Name
        Copy-Item -LiteralPath $Path -Destination $BackupPath -Force
        $BeforeRows += [PSCustomObject]@{
            Name = $Item.Name
            Path = $Path
            Length = $Item.Length
            SHA256 = $Hash
            BackupPath = $BackupPath
        }
        Write-Host "Backed up: $Path"
        Write-Host "SHA256: $Hash"
    } else {
        $BeforeRows += [PSCustomObject]@{
            Name = Split-Path $Path -Leaf
            Path = $Path
            Length = 0
            SHA256 = "MISSING"
            BackupPath = ""
        }
        Write-Host "MISSING, not backed up: $Path"
    }
}

$OriginalHandoffText = ""
if (Test-Path -LiteralPath $OldHandoff) {
    $OriginalHandoffText = Get-Content -Raw -LiteralPath $OldHandoff
} else {
    throw "Cannot repair because source handoff is missing: $OldHandoff"
}

# Remove duplicated old local append blocks from the handoff.
$BaseHandoffText = [regex]::Replace(
    $OriginalHandoffText,
    "(?s)\r?\n---\r?\n\r?\n# APPENDED LOCAL UPDATE — Gate Order Review / Clean-Fit Gate Search — 20260523_031048.*$",
    ""
).TrimEnd()

$AppendBlock = @"

---

# APPENDED LOCAL UPDATE — Gate Order Review / Clean-Fit Gate Search / Sequencer + Proven-Better Adoption / Boss Routing — $Stamp

This existing mule packet has a repaired local addendum.

Read:
`$NewAddendum`

Why this repair exists:
- Previous updater wrote `_0` packet names instead of timestamped names.
- Previous updater appended the same gate-order update twice.
- The packet did not yet know the Next Spin Sequencer gate saved at Mr.Kleen `main @ ab6656f`.
- New user rules arrived while cleanup was active, so they are routed by importance instead of mashed into the active task.

Core update:
- Hindsight happens before Alpha Omega closes.
- Cube/final ideas stay local-only Resident Parking, out of Git and out of Final Order.
- Mule should look for more gate ideas only if they cleanly fit.
- Mule should inspect the most logical gate order.
- Next Spin Sequencer is support-rule / technology-scaffold material saved with guardrails; no doctrine promotion.
- Proven-Better Adoption logic should be considered during gate review: proven + more efficient + clean fit + boundary-safe means adopt/adapt through proof lane.
- Multiple live ideas must be separated into active task, parking note, or TODO.
- Ideas must be routed by boss / parent importance before they interrupt active work.
- CONSOLIDATOR remains inactive until ambiguity/overlap is proven through spins.
"@

$NewHandoffText = ($BaseHandoffText + $AppendBlock).TrimEnd() + [Environment]::NewLine
Set-Content -LiteralPath $NewHandoff -Value $NewHandoffText -Encoding UTF8

$AddendumText = @"
# Mule Packet Addendum — Gate Order / Clean-Fit Gate Search / Sequencer / Proven-Better Adoption / Boss Routing

Status: LOCAL 123 MULE PACKET UPDATE / READ FIRST
Timestamp: $Stamp
Scope: update mule on repaired gate-order logic, Next Spin Sequencer, Alpha Omega/Hindsight order, Cube/final-ideas parking, Proven-Better Adoption, and boss-importance routing.
Boundary: local only, no Git, no doctrine, no gate promotion, no CONSOLIDATOR activation.

## 0. Repair Reason

The prior packet area had three repair needs:

1. `_0` packet/receipt naming instead of timestamped names.
2. duplicated appended gate-order update in the existing handoff packet.
3. stale packet state: Next Spin Sequencer was saved after the updater ran.

This repair creates timestamped local packet files, backs up the old files, supersedes stale `_0` files, and adds a clean current pointer.

## 1. Ordered Thought / Idea List

### Active Task — Importance: BLOCKER / ACTIVE CLEANUP

Local mule packet cleanup.

Reason:
- Current mule packet must be reliable before mule runs.
- Stale/duplicated packet creates bad handoff risk.

Action:
- repair packet names;
- remove duplicate append;
- add Next Spin Sequencer update;
- update read-first pointer;
- write receipt;
- keep local-only.

### Update A — Importance: ACTIVE-ROUTE CHILD

Next Spin Sequencer Gate / Creative Room Technology Scaffolds.

Known state:
- Mr.Kleen position: `main @ ab6656f`
- Full HEAD: `ab6656f4139234bff1f10044256c00701c99426f`
- Verdict: `PASS WITH GUARDRAILS / SUPPORT RULE + TECHNOLOGY SCAFFOLDS SAVED / NO DOCTRINE PROMOTION`

Saved files:
- `BRAIN_LEARNING\NEXT_SPIN_SEQUENCER_GATE_CREATIVE_ROOM_TECH_RULE_20260523.md`
- `HOUSE_WORK\WORK_SHED\SORTING_BENCH\CREATIVE_ROOM_TECH_SCAFFOLDS_NEXT_SPIN_SEQUENCER_FIT_MAP_20260523.md`
- `HOUSE_WORK\WORK_SHED\SORTING_BENCH\TEMPLATES\NEXT_SPIN_SEQUENCE_CARD_TEMPLATE_20260523.md`
- `PROOF_HISTORY\NEXT_SPIN_SEQUENCER_GATE_CREATIVE_ROOM_TECH_SAVE_RECEIPT_20260523_031904.txt`

Mule instruction:
- Treat as support-rule/scaffold material.
- Use it to think about next ordered motion when gate review reaches continuation/sequence planning.
- Do not promote it to doctrine.
- Do not rewrite active guides from it.

### Update B — Importance: PARENT SUPPORT / GATE LOGIC

Proven-Better Adoption Gate.

Rule shape:
- `UNPROVEN` -> test / park / TODO.
- `PROVEN BUT NOT CLEAN FIT` -> adapt / merge / park.
- `PROVEN + MORE EFFICIENT + CLEAN FIT + BOUNDARY-SAFE` -> adopt or adapt through the proper proof lane.
- `PROVEN BUT HIGHER-BOSS CONFLICT` -> hold and escalate to parent boss.
- `OLD RULE ONLY WINS BY AGE` -> not enough.

Mule instruction:
- When reviewing gates, do not protect old structure by inertia.
- Existing gates are not sacred because they are older.
- Newer ideas do not win by novelty either.
- Proof + efficiency + clean fit + boundary safety decides adoption.

### Update C — Importance: OPERATING DISCIPLINE / ROUTER

Multi-Idea Parking / TODO Handling.

Rule shape:
- one active task;
- extra ideas get named;
- each gets lane, importance, reason, status, and return trigger;
- use parking note / TODO instead of mashing ideas into the active packet.

Mule instruction:
- If gate review creates multiple candidate gates, do not collapse them into one vague blob.
- Separate them by lane and importance.
- Return parked ideas with a clear return trigger.

### Update D — Importance: PARENT ROUTING / BOSS ORDER

Boss-Importance Idea Routing.

Route order:
1. BLOCKER
2. Parent boss
3. Active-route child
4. Neighbor support
5. Parked source ore
6. TODO
7. Rejected stale

Mule instruction:
- Hold each idea long enough to classify it.
- Do not let a lower-importance idea hijack active cleanup.
- Do not bury a high-importance blocker in parking.
- Report importance and return trigger for anything parked.

## 2. Gate Family Mule Must Review

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
- Hindsight Lens / Neighbor
- Alpha Omega Candidate
- Final Judge
- CONSOLIDATOR Candidate
- Proven-Better Adoption Gate Candidate
- Multi-Idea Parking / TODO Handling Gate Candidate
- Boss-Importance Idea Routing Gate Candidate
- Next Spin Sequencer support scaffold

The gate set exists to stop bloat from becoming mess:
each gate must have a real job, clean boundary, neighbor relationship, proof requirement, and return-home condition.

## 3. Hindsight Before Alpha Omega Close

Correct order:

`Alpha opens fresh -> work/gates/proof run -> hindsight review -> Omega closes -> final clean status`

Hindsight is not the first door.
Hindsight is the rearview mirror before final exit.
Alpha Omega may use hindsight, but hindsight is a neighbor/lens, not swallowed into Alpha Omega.

## 4. Alpha Omega Job

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

## 5. CONSOLIDATOR Later

CONSOLIDATOR is not active yet.

When activated later, its job is:
- find ambiguity;
- identify duplicate/overlapping gate logic;
- place old gate logic into the better gate;
- add new logic to the gate that naturally owns it;
- keep broad ideas packed into one clean gate when possible;
- preserve distinct gates when merging would flatten useful difference.

CONSOLIDATOR must not flatten living gates too early.

## 6. Cube / Final Ideas Boundary

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

## 7. Mule Task Now

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

## 8. Three Spins

### Spin 1 — Practical Fit

Check:
- Does each gate solve a real exposed issue?
- Is the gate too broad?
- Is the gate too narrow?
- Is it only a step inside another gate?
- Is it necessary for guest/front-door/boundary/order work?
- Has any newer candidate proven cleaner and more efficient than old structure?

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
8. Multi-Idea Parking / TODO Handling
9. Boss-Importance Idea Routing
10. Proven-Better Adoption
11. Return-Home Gate
12. Enforcement Ladder Gate
13. Proof / Receipt Gate
14. Hindsight Lens
15. Omega closes
16. Final Judge / final clean status
17. Next Spin Sequencer support for the next ordered continuation

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
- gates that should be parked;
- proven-better candidates that should be adopted/adapted after proof.

Do not activate CONSOLIDATOR.
Only prepare the consolidation question.

## 9. Output Required From Mule

Return a report with:

1. Verdict:
   PASS / PASS WITH GUARDRAILS / PARTIAL / FAIL

2. Best gate order:
   list gates in clean operating order.

3. Gate table:
   - gate name;
   - job;
   - trigger;
   - importance level;
   - boundary;
   - neighbor before/after;
   - proof/receipt;
   - whether it stays separate, should be packed into another gate, or should be parked/TODO.

4. New gate ideas that cleanly fit:
   include only if they pass the clean-fit test.

5. Gates that should not exist separately:
   name where their logic should move.

6. Proven-Better Adoption judgment:
   - which ideas are proven;
   - which are more efficient;
   - whether they cleanly fit;
   - whether adoption/adaptation is blocked by a higher boss.

7. CONSOLIDATOR prep:
   what ambiguity CONSOLIDATOR should later resolve.

8. Alpha Omega inspection:
   whether it is gate, lens, or checklist;
   where hindsight belongs;
   what Alpha Omega must never do.

9. Cube/final-ideas boundary:
   confirm Cube/final ideas stay local-only resident parking and out of Final Order.

10. Parking/TODO list:
   all non-active ideas with lane, importance, reason, status, and return trigger.

## 10. Hard Boundary

No doctrine promotion.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No CONSOLIDATOR activation.
No public authority change.
No Git for Cube/final ideas content.
No treating local Day Dreams/Cube material as gate logic unless explicitly pulled.
No hiding duplicate/stale packet problems under PASS language.
"@

Set-Content -LiteralPath $NewAddendum -Value ($AddendumText.TrimEnd() + [Environment]::NewLine) -Encoding UTF8

$ReadFirstText = @"
# MULE READ FIRST — Current Gate Order Review Packet

Status: LOCAL 123 READ-FIRST POINTER / REPAIRED
Timestamp: $Stamp
Purpose: tell mule what changed after the original packet and where to start.

## Read Order

1. This file.
2. `MULE_PACKET_ADDENDUM_GATE_ORDER_REVIEW_$Stamp.md`
3. Existing repaired mule handoff packet:
   `MULE_HANDOFF_GUEST_BOUNDARY_GATES_THREE_SPINS_ALPHA_OMEGA_$Stamp.md`
4. Parking / TODO note:
   `_PARKING_NOTES\PARKING_TODO_PROVEN_BETTER_ADOPTION_BOSS_ROUTING_$Stamp.md`
5. Ordered thought list:
   `_PARKING_NOTES\MULE_PACKET_CLEANUP_ORDERED_THOUGHT_LIST_$Stamp.md`
6. Optional local-only resident parking if needed:
   `COMMAND_CENTER\RESIDENT_PARKING\DAY_DREAMS\CUBE_FINAL_IDEAS`
7. Older Day Dreams pickup only as local symbolic source material:
   `COMMAND_CENTER\PICKUP\DAY_DREAMS`

## Main Task

Look for more gate ideas that cleanly fit the build and ensure the gate order makes the most logical sense.

Do not bloat.
Do not promote.
Do not activate CONSOLIDATOR.
Do not put Cube/final ideas in Git or Final Order.
Do not treat old structure as sacred by age.
Do not let lower-importance ideas hijack the active route.

## Key New Rules

Hindsight happens before Alpha Omega closes:

`Alpha opens fresh -> work/gates/proof run -> hindsight review -> Omega closes -> final clean status`

Proven-Better Adoption:

`PROVEN + MORE EFFICIENT + CLEAN FIT + BOUNDARY-SAFE -> adopt/adapt through proof lane`

Multi-Idea Handling:

`ONE ACTIVE TASK + PARKING/TODO FOR EXTRA IDEAS`

Boss-Importance Routing:

`BLOCKER -> PARENT BOSS -> ACTIVE CHILD -> NEIGHBOR SUPPORT -> PARKED SOURCE ORE -> TODO -> REJECTED STALE`

Next Spin Sequencer:

Use as support scaffold for next ordered continuation. No doctrine promotion.
"@

Set-Content -LiteralPath $ReadFirst -Value ($ReadFirstText.TrimEnd() + [Environment]::NewLine) -Encoding UTF8

$OrderedListText = @"
# Mule Packet Cleanup — Ordered Thought / Idea List

Status: LOCAL PARKING NOTE + EXECUTION ORDER
Timestamp: $Stamp
Boundary: Desktop\123 local-only. No Git. No doctrine promotion.

## Ordered Execution

1. ACTIVE CLEANUP / BLOCKER
   - Repair local mule packet before mule runs.
   - Reason: current packet had duplicate append and `_0` naming.

2. ACTIVE UPDATE / CHILD OF CLEANUP
   - Add Next Spin Sequencer gate/scaffold update.
   - Reason: mule packet was created before Sequencer save at `main @ ab6656f`.

3. PARENT SUPPORT / GATE LOGIC
   - Add Proven-Better Adoption Gate as review candidate.
   - Reason: proven + more efficient + clean fit should be adopted/adapted through proof lane.

4. ROUTER DISCIPLINE / MULTI-ITEM HANDLING
   - Use parking/TODO when more than one idea appears.
   - Reason: prevent side-mutation and mashed logic.

5. PARENT ROUTING / IMPORTANCE
   - Hold ideas, classify them, then route by boss importance.
   - Reason: blockers can interrupt; lower items must not hijack.

6. BOUNDARY
   - Local-only, no Git, no doctrine, no ACTIVE_GUIDES, no CURRENT_TRUTH_INDEX, no CONSOLIDATOR activation.

## Current Verdict Target

`PASS WITH GUARDRAILS / LOCAL 123 MULE PACKET REPAIRED + UPDATED / NO GIT`

## Return Trigger

Use this note when mule returns, or when gate-order review begins.
"@

Set-Content -LiteralPath $OrderedList -Value ($OrderedListText.TrimEnd() + [Environment]::NewLine) -Encoding UTF8

$ParkingTodoText = @"
# Parking / TODO — Proven-Better Adoption + Boss-Importance Routing

Status: LOCAL PARKING TODO
Timestamp: $Stamp
Boundary: local-only support note, not doctrine, not Git.

## Item 1 — Proven-Better Adoption Gate

Lane: gate-review candidate / parent support
Importance: parent support
Reason: old rules should not win by age; new ideas should not win by novelty. Proof + efficiency + clean fit + boundary safety decides.
Status: parked for mule gate review
Return trigger: when mule reviews gate order / consolidation readiness.

Decision logic:
- UNPROVEN -> test / park / TODO.
- PROVEN BUT NOT CLEAN FIT -> adapt / merge / park.
- PROVEN + MORE EFFICIENT + CLEAN FIT + BOUNDARY-SAFE -> adopt/adapt through proof lane.
- PROVEN BUT HIGHER-BOSS CONFLICT -> hold and escalate.
- OLD RULE ONLY WINS BY AGE -> not enough.

## Item 2 — Multi-Idea Parking / TODO Handling

Lane: operating discipline
Importance: active support
Reason: more than one live idea must not become one blob.
Status: active support note
Return trigger: any packet or turn with more than one idea/task/object.

Rule:
- one active task;
- extra ideas get named;
- each gets lane, importance, reason, status, and return trigger;
- use parking note / TODO instead of mashing.

## Item 3 — Boss-Importance Idea Routing

Lane: parent routing
Importance: parent support
Reason: idea handling needs boss order.
Status: parked for gate review
Return trigger: when deciding whether an idea interrupts, joins, parks, or waits.

Route order:
1. BLOCKER
2. Parent boss
3. Active-route child
4. Neighbor support
5. Parked source ore
6. TODO
7. Rejected stale
"@

Set-Content -LiteralPath $ParkingTodo -Value ($ParkingTodoText.TrimEnd() + [Environment]::NewLine) -Encoding UTF8

# Move stale _0 files out of active pickup/receipt surface after new files are written.
Write-Section "SUPERSEDE STALE _0 FILES"
foreach ($Path in @($OldHandoff, $OldAddendum)) {
    if (Test-Path -LiteralPath $Path) {
        $Dest = Join-Path $SupersededDir (Split-Path $Path -Leaf)
        Move-Item -LiteralPath $Path -Destination $Dest -Force
        Write-Host "Moved stale active packet file to superseded: $Dest"
    }
}

if (Test-Path -LiteralPath $OldReceipt) {
    $Dest = Join-Path $ReceiptSupersededDir (Split-Path $OldReceipt -Leaf)
    Move-Item -LiteralPath $OldReceipt -Destination $Dest -Force
    Write-Host "Moved stale receipt to superseded: $Dest"
}

# Validation
$NewHandoffFinal = Get-Content -Raw -LiteralPath $NewHandoff
$NewAddendumFinal = Get-Content -Raw -LiteralPath $NewAddendum
$ReadFirstFinal = Get-Content -Raw -LiteralPath $ReadFirst
$ParkingFinal = Get-Content -Raw -LiteralPath $ParkingTodo

$AppendCount = Count-Marker -Text $NewHandoffFinal -Pattern "# APPENDED LOCAL UPDATE"
$SequencerCount = Count-Marker -Text ($NewHandoffFinal + $NewAddendumFinal + $ReadFirstFinal) -Pattern "Next Spin|NEXT SPIN|Sequencer|SEQUENCER"
$ProvenBetterCount = Count-Marker -Text ($NewAddendumFinal + $ReadFirstFinal + $ParkingFinal) -Pattern "Proven-Better|PROVEN \+ MORE EFFICIENT|proven \+ more efficient|OLD RULE ONLY WINS"
$BossRoutingCount = Count-Marker -Text ($NewAddendumFinal + $ReadFirstFinal + $ParkingFinal) -Pattern "Boss-Importance|boss importance|BLOCKER|Parent boss|ACTIVE-ROUTE"
$BadPlaceholderCount = Count-Marker -Text ($NewHandoffFinal + $NewAddendumFinal + $ReadFirstFinal) -Pattern '\$AddendumPath'
$ActiveZeroFiles = @(Get-ChildItem -LiteralPath $Pickup -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'GATE_ORDER_REVIEW_0|ALPHA_OMEGA_0' }).Count
$OldReceiptStillActive = Test-Path -LiteralPath $OldReceipt

$ValidationErrors = New-Object System.Collections.Generic.List[string]
if ($AppendCount -ne 1) { $ValidationErrors.Add("Expected exactly 1 appended local update in repaired handoff; found $AppendCount") }
if ($SequencerCount -lt 3) { $ValidationErrors.Add("Sequencer update did not appear enough times; count $SequencerCount") }
if ($ProvenBetterCount -lt 3) { $ValidationErrors.Add("Proven-Better logic did not appear enough times; count $ProvenBetterCount") }
if ($BossRoutingCount -lt 3) { $ValidationErrors.Add("Boss routing logic did not appear enough times; count $BossRoutingCount") }
if ($BadPlaceholderCount -ne 0) { $ValidationErrors.Add("Bad `$AddendumPath placeholder remains; count $BadPlaceholderCount") }
if ($ActiveZeroFiles -ne 0) { $ValidationErrors.Add("Stale _0 packet files still active in PICKUP root; count $ActiveZeroFiles") }
if ($OldReceiptStillActive) { $ValidationErrors.Add("Old _0 receipt still active in RECEIPTS root") }

$Created = @($NewHandoff, $NewAddendum, $ReadFirst, $OrderedList, $ParkingTodo)
$CreatedRows = foreach ($Path in $Created) {
    $Item = Get-Item -LiteralPath $Path
    [PSCustomObject]@{
        Name = $Item.Name
        Path = $Path
        Length = $Item.Length
        SHA256 = Get-Sha256 -Path $Path
    }
}

$ReceiptText = @"
LOCAL 123 MULE PACKET CLEANUP AND SEQUENCER UPDATE RECEIPT

Timestamp: $Stamp

Verdict:
$(
if ($ValidationErrors.Count -eq 0) {
"PASS WITH GUARDRAILS / LOCAL 123 MULE PACKET REPAIRED + UPDATED / NO GIT"
} else {
"FAIL / VALIDATION ERRORS PRESENT / REVIEW BEFORE USE"
}
)

Scope:
- Desktop\123 local-only
- COMMAND_CENTER\PICKUP
- COMMAND_CENTER\RECEIPTS
- No Git commands run
- No doctrine promotion
- No ACTIVE_GUIDES rewrite
- No CURRENT_TRUTH_INDEX rewrite
- No CONSOLIDATOR activation

Repair actions:
- backed up target files before changing;
- created timestamped repaired handoff;
- created timestamped repaired addendum;
- updated stable read-first pointer;
- created ordered thought / idea list;
- created parking/TODO note;
- moved stale `_0` active packet files to superseded custody;
- moved stale `_0` receipt to superseded custody;
- removed duplicate appended local update from active handoff;
- added Next Spin Sequencer update;
- added Proven-Better Adoption candidate logic;
- added Multi-Idea Parking/TODO handling;
- added Boss-Importance Idea Routing.

Backup directory:
$BackupDir

Superseded packet directory:
$SupersededDir

Superseded receipt directory:
$ReceiptSupersededDir

Created files:
$($CreatedRows | ForEach-Object { "- $($_.Path)`n  SHA256: $($_.SHA256)" } | Out-String)

Validation:
- appended local update count in repaired handoff: $AppendCount
- sequencer marker count: $SequencerCount
- proven-better marker count: $ProvenBetterCount
- boss-routing marker count: $BossRoutingCount
- `$AddendumPath placeholder count: $BadPlaceholderCount
- active `_0 packet files in PICKUP root: $ActiveZeroFiles
- old `_0 receipt still active: $OldReceiptStillActive

Validation errors:
$(
if ($ValidationErrors.Count -eq 0) {
"- NONE"
} else {
$ValidationErrors | ForEach-Object { "- $_" } | Out-String
}
)

Final boundary:
- Local 123 only.
- No Git.
- No doctrine.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No CONSOLIDATOR activation.
- No public authority change.
"@

Set-Content -LiteralPath $Receipt -Value ($ReceiptText.TrimEnd() + [Environment]::NewLine) -Encoding UTF8

Write-Section "FINAL CREATED FILES"
$CreatedRows | Format-Table -AutoSize

Write-Section "RECEIPT"
Write-Host $Receipt
Write-Host "Receipt SHA256: $(Get-Sha256 -Path $Receipt)"

Write-Section "VALIDATION"
Write-Host "Appended local update count: $AppendCount"
Write-Host "Sequencer marker count: $SequencerCount"
Write-Host "Proven-Better marker count: $ProvenBetterCount"
Write-Host "Boss-routing marker count: $BossRoutingCount"
Write-Host "`$AddendumPath placeholder count: $BadPlaceholderCount"
Write-Host "Active _0 packet files in PICKUP root: $ActiveZeroFiles"
Write-Host "Old _0 receipt still active: $OldReceiptStillActive"

if ($ValidationErrors.Count -ne 0) {
    Write-Host ""
    Write-Host "VALIDATION ERRORS:"
    $ValidationErrors | ForEach-Object { Write-Host "- $_" }
    throw "Repair completed file writes but validation failed. Review receipt before use."
}

Write-Section "VERDICT"
Write-Host "PASS WITH GUARDRAILS / LOCAL 123 MULE PACKET REPAIRED + UPDATED / NO GIT"
