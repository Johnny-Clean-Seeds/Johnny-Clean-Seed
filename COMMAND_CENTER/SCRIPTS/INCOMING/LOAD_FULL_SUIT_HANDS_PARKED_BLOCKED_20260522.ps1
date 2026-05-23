param(
    [string]$RepoPath = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz",
    [string]$ExpectedHead = "b643057a7a350b092007c169f718f1ea0d022c2c",
    [switch]$NoPush
)

$ErrorActionPreference = "Stop"

function Get-GitOutput {
    param(
        [Parameter(Mandatory=$true)][string[]]$Args
    )
    $output = & git @Args 2>&1
    if ($LASTEXITCODE -ne 0) {
        $joined = ($output | Out-String).Trim()
        throw "git $($Args -join ' ') failed. $joined"
    }
    return (($output | Out-String).Trim())
}

function Invoke-GitChecked {
    param(
        [Parameter(Mandatory=$true)][string[]]$Args
    )
    $output = & git @Args 2>&1
    if ($LASTEXITCODE -ne 0) {
        $joined = ($output | Out-String).Trim()
        throw "git $($Args -join ' ') failed. $joined"
    }
    return $output
}

function Write-TextFile {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Text
    )
    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    $Text | Set-Content -Path $Path -Encoding UTF8
}

function Require-Contains {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string[]]$Needles
    )
    $text = Get-Content -Path $Path -Raw
    foreach ($needle in $Needles) {
        if ($text -notlike "*$needle*") {
            throw "Self-check failed. Missing required text in $Path : $needle"
        }
    }
}

$RepoRoot = (Resolve-Path $RepoPath).Path
if (-not (Test-Path (Join-Path $RepoRoot ".git"))) {
    throw "Not in Mr.Kleen repo. Expected .git at: $RepoRoot"
}

$GitBase = @("-c", "safe.directory=$RepoRoot", "-C", $RepoRoot)

$Branch = Get-GitOutput ($GitBase + @("branch", "--show-current"))
if ($Branch -ne "main") {
    throw "Wrong branch. Expected main; got $Branch"
}

$HeadFull = Get-GitOutput ($GitBase + @("rev-parse", "HEAD"))
if ($HeadFull -ne $ExpectedHead) {
    throw "Wrong base. Expected $ExpectedHead but repo is at $HeadFull. Stop and checkpoint first."
}

$StatusBefore = Get-GitOutput ($GitBase + @("status", "--short"))
if ($StatusBefore) {
    throw "Repo is not clean before write. Stop. Dirty status:`n$StatusBefore"
}

$DateStamp = (Get-Date).ToString("yyyyMMdd")
$TimeStamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$ShortBase = $HeadFull.Substring(0,7)

$LoadTestPath = Join-Path $RepoRoot "HOUSE_WORK\WORK_SHED\GEAR_RACK\SUIT_LOAD_TESTS\FULL_SUIT_HANDS_PARKED_BLOCKED_COMBINED_LOAD_TEST_$DateStamp.md"
$InventoryPath = Join-Path $RepoRoot "HOUSE_WORK\WORK_SHED\SORTING_BENCH\SUIT_HANDS_PARKED_BLOCKED_INVENTORY_MAP_$DateStamp.md"
$TodoPath = Join-Path $RepoRoot "HOUSE_WORK\TODO\FULL_SUIT_LOAD_FOLLOWUP_TODO_$DateStamp.md"
$StatusPath = Join-Path $RepoRoot "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$AnchorPath = Join-Path $RepoRoot "ACTIVE_ANCHOR.txt"
$AnchorBackupRel = "PROOF_HISTORY\ACTIVE_ANCHOR_BEFORE_FULL_SUIT_LOAD_TEST_$TimeStamp.txt"
$AnchorBackupPath = Join-Path $RepoRoot $AnchorBackupRel
$ReceiptPath = Join-Path $RepoRoot "PROOF_HISTORY\FULL_SUIT_HANDS_PARKED_BLOCKED_LOAD_TEST_RECEIPT_$TimeStamp.txt"

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $LoadTestPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $InventoryPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $TodoPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $ReceiptPath) | Out-Null

if (Test-Path $AnchorPath) {
    Copy-Item -Path $AnchorPath -Destination $AnchorBackupPath -Force
}

$LoadTest = @"
# Full Suit + Hands + Parked + Blocked Combined Load Test

Date: $DateStamp  
Base before save: main @ $ShortBase  
Full base hash: $HeadFull  
Route: all-in-one combined load test  
Verdict: PASS WITH GUARDRAILS / INTAKE + ORIENTATION + COMBINED TEST ONLY  
Promotion state: NO PROMOTION  
Authority state: NO DOCTRINE, ACTIVE_GUIDE, CURRENT_TRUTH_INDEX, DASHBOARD, RUNTIME, OR AUTOMATION INSTALL

## Purpose

This file brings the current hands, Hard Suit, Soft Suit candidates, parked/intake-ready material, and blocked moves into the house as one combined placement/load test.

The test is intentionally not a one-by-one proof. It checks the full batch as a load system: whether the parts can sit in the same house without authority drift, lane collision, proof confusion, or accidental promotion.

## Load Test Rule

All listed parts are included in this test at once.

That does not mean every Soft Suit candidate is promoted, worn as an active boss, or allowed to command active files. The combined test rack can hold all candidates for neighbor/conflict inspection, while the operating rule remains:

- Hard Suit = proven operating baseline.
- Soft Suit = candidate/test lane.
- Parked = held without authority.
- Blocked = explicit no-go list.
- Active-file dump = prohibited unless a separate proof route promotes the item.

## Hands / Active Grip

1. Orientation only.
2. No unsent file.
3. No hidden edit.
4. No active repo mutation.

Load judgment: CLEAN. The hands are empty enough to run a combined intake test without silently carrying an old task.

## Hard Suit Baseline

1. Pause-before-work.
2. Task-scoped rule + neighbor search before action.
3. Dense-idea intake.
4. Proof-before-PASS.
5. No doctrine/guide/index rewrite without routed proof.
6. File-first for large packets.
7. Artifact self-check.
8. Clean copy-block discipline.
9. PowerShell `param(...)` first.
10. External issue stays external.
11. Bridge lifecycle cleanup.

Load judgment: PASS. These are treated as operating guardrails for the combined test.

## Soft Suit / Candidate Rack

1. Rule-Firing Confirmation Card.
2. Relevant Root Key Selector.
3. Provenance / Chain-of-Custody Thread Lens.
4. Gear Rack Load Gate.
5. Boss/Ghost rule firing cycle.
6. Fog Alarm.
7. Broad-Bite / solidifying condensation.
8. Stale-checker route attachment fix.
9. Hub watcher quiet-window batch digestion.
10. Broken-bridge disintegration lifecycle.
11. Compounding personality / Planetary Influence / Valence Council lane.

Load judgment: PASS WITH GUARDRAILS.

These are all present in the same candidate rack for combined-effect inspection. They do not all become active bosses. Their shared test question is:

Can these candidates coexist with the Hard Suit baseline without taking the wrong authority, hiding proof gaps, creating fog, or turning parked/source material into doctrine?

Current answer: yes, as candidates only.

## Parked / Intake-Ready Rack

1. Dreamforger/Suno source ore.
2. Mule return material.
3. `123_NON_GIT_AUDIT_20260522` intake batch.
4. Command Center local-only material.
5. Public/Neocities review lane.
6. Exact Chat Wake Bridge proof.
7. Older/superseded bridge scripts.

Load judgment: PASS WITH GUARDRAILS.

These can be held in the house only as parked/intake/source/proof material. They do not command the house. They are not adopted by being listed here.

## Blocked Moves

1. Treating public files as local truth.
2. Promoting source ore into doctrine.
3. Rewriting active guides/current truth index from a candidate.
4. Installing dashboard/runtime/automation without separate route.
5. Calling first-use tests promoted.
6. Assuming anything newer than `$ShortBase` without fresh proof.

Load judgment: PASS. The block list is compatible with the Hard Suit and prevents the Soft Suit/parked racks from drifting into authority.

## Combined Conflict Scan

### Authority Drift

PASS. Nothing in this load test grants doctrine, active-guide, current-truth-index, runtime, dashboard, or automation authority.

### Neighbor Conflict

PASS WITH WATCH. Several candidates touch nearby lanes:
- Rule firing, selector, fog alarm, and Boss/Ghost cycle all touch routing.
- Provenance lens and stale-checker both touch proof/custody.
- Hub watcher and bridge lifecycle both touch bridge operations.
- Broad-Bite and compounding personality both touch architecture growth.

They can coexist only if each one keeps its lane and does not become rule king.

### Proof Gap

PASS WITH WATCH. This file proves placement and combined compatibility only. It does not prove promotion, runtime behavior, automation, or doctrine readiness.

### Soft Suit Load

PASS WITH GUARDRAILS. All candidates are included in one rack test, but only as candidates. Any future active-boss use must still respect the Soft Suit cap and must name the active triad or smaller loadout.

### Parked-Material Safety

PASS. Parked material remains parked. Source ore remains source ore. Public remains public. Bridge proof remains proof, not identity or autonomous authority.

## Final Test Verdict

PASS WITH GUARDRAILS / ALL-IN-ONE LOAD TEST SAVED.

This package brings the whole current load into the house as one inventory and combined-effect test. It does not promote, install, rewrite doctrine, rewrite active guides, rewrite CURRENT_TRUTH_INDEX, create automation, or activate a dashboard.

## Next Allowed Moves

1. Use this inventory as the current suit/load orientation.
2. Pick one follow-up proof route from the TODO file.
3. Run a separate promotion review only if the user explicitly routes promotion.
4. Keep the block list active until a later proved change replaces it.

## Stop Conditions

Stop if the next move tries to:
- promote the whole batch;
- treat parked material as adopted;
- rewrite doctrine from this file;
- install runtime/dashboard/automation from this file;
- ignore Soft Suit active-boss limits;
- claim a newer repo position without fresh git proof.
"@

$Inventory = @"
# Suit / Hands / Parked / Blocked Inventory Map

Date: $DateStamp  
Base before save: main @ $ShortBase  
Full base hash: $HeadFull  
State: house inventory + placement map  
Promotion state: none

## Hands

| Item | State | House Meaning |
|---|---|---|
| Orientation only | Active grip | Current working orientation; not a mutation |
| No unsent file | Clear hand | No hidden file waiting to be sent |
| No hidden edit | Clear hand | No unreported repo/file edit |
| No active repo mutation | Clear hand | No current local change assumed |

## Hard Suit

| Item | Role |
|---|---|
| Pause-before-work | Tempo / intake gate |
| Task-scoped rule + neighbor search before action | Local-law gate |
| Dense-idea intake | Cluster capture route |
| Proof-before-PASS | Verdict gate |
| No doctrine/guide/index rewrite without routed proof | Authority guard |
| File-first for large packets | Packaging guard |
| Artifact self-check | QA guard |
| Clean copy-block discipline | User execution guard |
| PowerShell `param(...)` first | Script syntax guard |
| External issue stays external | Boundary guard |
| Bridge lifecycle cleanup | Broken/stale bridge guard |

## Soft Suit Candidate Rack

| Candidate | Current State | Guardrail |
|---|---|---|
| Rule-Firing Confirmation Card | Candidate / live-use guard | Cannot become rule king |
| Relevant Root Key Selector | Candidate / selector support | Selector only; not authority |
| Provenance / Chain-of-Custody Thread Lens | Candidate / custody support | Proof lens only |
| Gear Rack Load Gate | Candidate / load support | Must protect neighbor lanes |
| Boss/Ghost rule firing cycle | Candidate / routing repair | Must not over-trigger |
| Fog Alarm | Candidate / pause-router | Alert/router, not doctrine |
| Broad-Bite / solidifying condensation | Candidate / design test | Must produce usable solid |
| Stale-checker route attachment fix | Candidate / workflow guard | Must attach before output |
| Hub watcher quiet-window batch digestion | Candidate / bridge intake | Bounded collect only |
| Broken-bridge disintegration lifecycle | Candidate / cleanup guard | Retire/archive without deleting evidence |
| Compounding personality / Planetary Influence / Valence Council lane | Candidate / architecture target | Bounded seed only; no engine install |

## Parked / Intake-Ready

| Item | State | Boundary |
|---|---|---|
| Dreamforger/Suno source ore | Parked/source ore | Not doctrine, not proof of sentience |
| Mule return material | Intake-ready | Must be inspected before adoption |
| `123_NON_GIT_AUDIT_20260522` intake batch | Saved intake | Not automatically adopted |
| Command Center local-only material | Local-only | Not Mr.Kleen doctrine unless routed |
| Public/Neocities review lane | Public lane | Public is not local truth |
| Exact Chat Wake Bridge proof | Proof with limits | Not signed identity or autonomous verification |
| Older/superseded bridge scripts | Park/retire candidates | Must not remain active/confusing |

## Blocked

| Blocked Move | Reason |
|---|---|
| Treating public files as local truth | Violates public/local boundary |
| Promoting source ore into doctrine | Violates authority/proof boundary |
| Rewriting active guides/current truth index from a candidate | Violates promotion path |
| Installing dashboard/runtime/automation without separate route | Violates runtime authority |
| Calling first-use tests promoted | Violates proof maturity |
| Assuming anything newer than `$ShortBase` without fresh proof | Violates checkpoint proof |

## Current Placement Sentence

The house is holding the full current load as a tested inventory rack: Hard Suit operating guardrails active, Soft Suit candidates included for combined-effect inspection only, parked material held without authority, and blocked moves active as hard stops.
"@

$Todo = @"
# Full Suit Load Follow-Up TODO

Date: $DateStamp  
Base before save: main @ $ShortBase  
Created from: full suit + hands + parked + blocked combined load test

## Rule

Do not promote the whole batch.

This TODO exists to choose the next clean proof route after the all-in-one load test.

## Open Follow-Up Routes

1. Run a three-boss Soft Suit active-triad test.
   - Candidate triad suggestion: Rule-Firing Confirmation Card + Relevant Root Key Selector + Fog Alarm.
   - Purpose: test routing without rule-king drift.

2. Run bridge-lifecycle cleanup against older/superseded bridge scripts.
   - Purpose: mark ACTIVE/STANDBY/PARKED/BROKEN/RETIRED and detach stale active paths.

3. Run parked/intake disposition on mule return material.
   - Purpose: inspect every returned file before adoption.

4. Run provenance/stale-checker combined test.
   - Purpose: prove custody + before-output attachment, not after-the-fact checking.

5. Run `123_NON_GIT_AUDIT_20260522` intake review.
   - Purpose: separate source, candidate rule, proof, and blocked authority.

6. Run compounding personality / Planetary Influence / Valence Council seed artifact.
   - Purpose: bounded architecture seed only, no personality engine install.

7. Run Broad-Bite / solidifying condensation test.
   - Purpose: prove whether a condensed idea makes a stable object, route, file, rule, receipt, workflow, or proof structure.

## Stop Conditions

Stop if any route tries to:
- adopt parked material without inspection;
- promote all candidates at once;
- rewrite doctrine/active guides/current truth index;
- create runtime/dashboard/automation without a separate route;
- ignore the current base proof;
- call this combined load test a promotion.
"@

Write-TextFile -Path $LoadTestPath -Text $LoadTest
Write-TextFile -Path $InventoryPath -Text $Inventory
Write-TextFile -Path $TodoPath -Text $Todo

$StatusAppend = @"

---

## Full Suit + Hands + Parked + Blocked Combined Load Test - $DateStamp

Base before save: main @ $ShortBase  
Full base hash: $HeadFull  
State: PASS WITH GUARDRAILS / SAVED AS INVENTORY + COMBINED LOAD TEST ONLY  
Promotion: none  
Authority changes: none  
Files:
- HOUSE_WORK/WORK_SHED/GEAR_RACK/SUIT_LOAD_TESTS/FULL_SUIT_HANDS_PARKED_BLOCKED_COMBINED_LOAD_TEST_$DateStamp.md
- HOUSE_WORK/WORK_SHED/SORTING_BENCH/SUIT_HANDS_PARKED_BLOCKED_INVENTORY_MAP_$DateStamp.md
- HOUSE_WORK/TODO/FULL_SUIT_LOAD_FOLLOWUP_TODO_$DateStamp.md

Current holding:
- Hands clear/orientation only.
- Hard Suit guardrails active.
- Soft Suit candidates tested together as a combined rack, not promoted.
- Parked/intake material held without authority.
- Blocked moves remain hard stops.

Next move: choose one follow-up proof route from `HOUSE_WORK/TODO/FULL_SUIT_LOAD_FOLLOWUP_TODO_$DateStamp.md`.
"@

if (-not (Test-Path $StatusPath)) {
    Write-TextFile -Path $StatusPath -Text "# Current House Work Status`n"
}
Add-Content -Path $StatusPath -Value $StatusAppend -Encoding UTF8

$Anchor = @"
ACTIVE ANCHOR

Base before this save:
main @ $ShortBase
Full hash: $HeadFull

Current active lane:
Full Suit + Hands + Parked + Blocked Combined Load Test

Current state:
PASS WITH GUARDRAILS / house inventory + combined load test saved only

Hands:
- Orientation only.
- No unsent file.
- No hidden edit.
- No active repo mutation.

Hard Suit:
- Pause-before-work.
- Task-scoped rule + neighbor search before action.
- Dense-idea intake.
- Proof-before-PASS.
- No doctrine/guide/index rewrite without routed proof.
- File-first for large packets.
- Artifact self-check.
- Clean copy-block discipline.
- PowerShell param first.
- External issue stays external.
- Bridge lifecycle cleanup.

Soft Suit candidate rack:
- Rule-Firing Confirmation Card.
- Relevant Root Key Selector.
- Provenance / Chain-of-Custody Thread Lens.
- Gear Rack Load Gate.
- Boss/Ghost rule firing cycle.
- Fog Alarm.
- Broad-Bite / solidifying condensation.
- Stale-checker route attachment fix.
- Hub watcher quiet-window batch digestion.
- Broken-bridge disintegration lifecycle.
- Compounding personality / Planetary Influence / Valence Council lane.

Parked / intake-ready:
- Dreamforger/Suno source ore.
- Mule return material.
- 123_NON_GIT_AUDIT_20260522 intake batch.
- Command Center local-only material.
- Public/Neocities review lane.
- Exact Chat Wake Bridge proof.
- Older/superseded bridge scripts.

Blocked:
- Treating public files as local truth.
- Promoting source ore into doctrine.
- Rewriting active guides/current truth index from a candidate.
- Installing dashboard/runtime/automation without separate route.
- Calling first-use tests promoted.
- Assuming anything newer than this base without fresh proof.

Next allowed move:
Choose one proof-ranked follow-up route from HOUSE_WORK/TODO/FULL_SUIT_LOAD_FOLLOWUP_TODO_$DateStamp.md.

Previous ACTIVE_ANCHOR backup:
$AnchorBackupRel

Boundary:
This anchor does not promote the batch, install doctrine, rewrite active guides, rewrite CURRENT_TRUTH_INDEX, create runtime, create dashboard, or create automation.
"@

Write-TextFile -Path $AnchorPath -Text $Anchor

Require-Contains -Path $LoadTestPath -Needles @(
    "PASS WITH GUARDRAILS / INTAKE + ORIENTATION + COMBINED TEST ONLY",
    "All listed parts are included in this test at once.",
    "NO PROMOTION",
    "Soft Suit / Candidate Rack",
    "Parked / Intake-Ready Rack",
    "Blocked Moves"
)

Require-Contains -Path $InventoryPath -Needles @(
    "Suit / Hands / Parked / Blocked Inventory Map",
    "Hard Suit",
    "Soft Suit Candidate Rack",
    "Parked / Intake-Ready",
    "Blocked"
)

Require-Contains -Path $TodoPath -Needles @(
    "Do not promote the whole batch.",
    "Open Follow-Up Routes",
    "Stop Conditions"
)

Require-Contains -Path $AnchorPath -Needles @(
    "Full Suit + Hands + Parked + Blocked Combined Load Test",
    "PASS WITH GUARDRAILS",
    "Previous ACTIVE_ANCHOR backup",
    "Boundary:"
)

$ChangedRel = @(
    "ACTIVE_ANCHOR.txt",
    "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md",
    "HOUSE_WORK/WORK_SHED/GEAR_RACK/SUIT_LOAD_TESTS/FULL_SUIT_HANDS_PARKED_BLOCKED_COMBINED_LOAD_TEST_$DateStamp.md",
    "HOUSE_WORK/WORK_SHED/SORTING_BENCH/SUIT_HANDS_PARKED_BLOCKED_INVENTORY_MAP_$DateStamp.md",
    "HOUSE_WORK/TODO/FULL_SUIT_LOAD_FOLLOWUP_TODO_$DateStamp.md"
)

if (Test-Path $AnchorBackupPath) {
    $ChangedRel += ($AnchorBackupRel -replace "\\","/")
}

$FileHashLines = foreach ($rel in $ChangedRel) {
    $full = Join-Path $RepoRoot ($rel -replace "/","\")
    if (Test-Path $full) {
        $hash = (Get-FileHash -Algorithm SHA256 -Path $full).Hash
        "$rel`t$hash"
    }
}

$Receipt = @"
FULL SUIT + HANDS + PARKED + BLOCKED LOAD TEST RECEIPT
Date: $TimeStamp
Base before save: main @ $ShortBase
Full base hash: $HeadFull
Branch: $Branch

VERDICT:
PASS WITH GUARDRAILS / ALL-IN-ONE LOAD TEST SAVED

SCOPE:
House inventory + combined-effect load test only.

INCLUDED:
Hands:
1. Orientation only.
2. No unsent file.
3. No hidden edit.
4. No active repo mutation.

Hard Suit:
1. Pause-before-work.
2. Task-scoped rule + neighbor search before action.
3. Dense-idea intake.
4. Proof-before-PASS.
5. No doctrine/guide/index rewrite without routed proof.
6. File-first for large packets.
7. Artifact self-check.
8. Clean copy-block discipline.
9. PowerShell param first.
10. External issue stays external.
11. Bridge lifecycle cleanup.

Soft Suit candidate rack:
1. Rule-Firing Confirmation Card.
2. Relevant Root Key Selector.
3. Provenance / Chain-of-Custody Thread Lens.
4. Gear Rack Load Gate.
5. Boss/Ghost rule firing cycle.
6. Fog Alarm.
7. Broad-Bite / solidifying condensation.
8. Stale-checker route attachment fix.
9. Hub watcher quiet-window batch digestion.
10. Broken-bridge disintegration lifecycle.
11. Compounding personality / Planetary Influence / Valence Council lane.

Parked / intake-ready:
1. Dreamforger/Suno source ore.
2. Mule return material.
3. 123_NON_GIT_AUDIT_20260522 intake batch.
4. Command Center local-only material.
5. Public/Neocities review lane.
6. Exact Chat Wake Bridge proof.
7. Older/superseded bridge scripts.

Blocked:
1. Treating public files as local truth.
2. Promoting source ore into doctrine.
3. Rewriting active guides/current truth index from a candidate.
4. Installing dashboard/runtime/automation without separate route.
5. Calling first-use tests promoted.
6. Assuming anything newer than $ShortBase without fresh proof.

BOUNDARIES HELD:
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No dashboard install.
No runtime install.
No automation install.
No promotion.
No parked-source adoption.
No public/local boundary collapse.

SELF-CHECK:
Required phrases present in load test, inventory, TODO, and ACTIVE_ANCHOR.
File hashes recorded below.

FILE HASHES:
$($FileHashLines -join "`n")
"@

Write-TextFile -Path $ReceiptPath -Text $Receipt
Require-Contains -Path $ReceiptPath -Needles @(
    "PASS WITH GUARDRAILS / ALL-IN-ONE LOAD TEST SAVED",
    "No doctrine install.",
    "No promotion.",
    "FILE HASHES:"
)

$ReceiptRel = ("PROOF_HISTORY/FULL_SUIT_HANDS_PARKED_BLOCKED_LOAD_TEST_RECEIPT_$TimeStamp.txt")
$AllRel = $ChangedRel + @($ReceiptRel)

Invoke-GitChecked ($GitBase + @("diff", "--check")) | Out-Null

foreach ($rel in $AllRel) {
    Invoke-GitChecked ($GitBase + @("add", "--", $rel)) | Out-Null
}

$StatusAfterWrite = Get-GitOutput ($GitBase + @("status", "--short"))
if (-not $StatusAfterWrite) {
    throw "No changes staged/written. Stop."
}

Invoke-GitChecked ($GitBase + @("commit", "-m", "Record full suit combined load test")) | Out-Null

$NewHead = Get-GitOutput ($GitBase + @("rev-parse", "HEAD"))
$NewShort = $NewHead.Substring(0,7)

if (-not $NoPush) {
    $pushOutput = & git @GitBase push origin main 2>&1
    if ($LASTEXITCODE -ne 0) {
        $pushText = ($pushOutput | Out-String).Trim()
        if ($pushText -match "fetch first|rejected|non-fast-forward") {
            Write-Host "Push rejected because remote moved. Attempting guarded pull --rebase, then push."
            Invoke-GitChecked ($GitBase + @("pull", "--rebase", "origin", "main")) | Out-Null
            Invoke-GitChecked ($GitBase + @("push", "origin", "main")) | Out-Null
            $NewHead = Get-GitOutput ($GitBase + @("rev-parse", "HEAD"))
            $NewShort = $NewHead.Substring(0,7)
        } else {
            throw "git push origin main failed. $pushText"
        }
    }
}

$FinalStatus = Get-GitOutput ($GitBase + @("status", "--short"))
if ($FinalStatus) {
    throw "Final repo status is not clean:`n$FinalStatus"
}

$RemoteHead = ""
if (-not $NoPush) {
    $RemoteHead = Get-GitOutput ($GitBase + @("ls-remote", "origin", "refs/heads/main"))
}

Write-Host "FULL SUIT LOAD TEST SAVE COMPLETE"
Write-Host "Base before:" $HeadFull
Write-Host "New HEAD:" $NewHead
if (-not $NoPush) {
    Write-Host "Remote refs/heads/main:" $RemoteHead
}
Write-Host "Status: clean"
Write-Host "Receipt:" $ReceiptPath
Write-Host "Verdict: PASS WITH GUARDRAILS / COMBINED LOAD TEST SAVED / NO PROMOTION"
