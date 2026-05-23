# BUILD_ASSISTANT_LOCAL_MINIMAL_PACKET_V1.0.ps1
# Builds the mule-approved minimal ASSISTANT_LOCAL support packet.
# Uses same-shape baseline -> build -> after -> comparison.
# Local-only. No Git. No push. No public export. No doctrine.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$Root = Join-Path $Desktop "ASSISTANT_LOCAL"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$Closeout = Join-Path $Root ("PORCH_CLOSEOUT\ASSISTANT_LOCAL_MINIMAL_PACKET_BUILD_{0}" -f $Stamp)

$IndexDir = Join-Path $Root "INDEX"
$ParkingDir = Join-Path $Root "PARKING"
$DataLogsDir = Join-Path $Root "DATA_LOGS"
$InvalidDir = Join-Path $Root "INVALID_RECEIPTS"
$ChatRulesDir = Join-Path $Root "CHAT_RULES_LOCAL_ONLY"
$WalkRoot = Join-Path $Root "HOUSE_WALKS"
$ContractDir = Join-Path $WalkRoot "CONTRACTS"
$SnapshotDir = Join-Path $WalkRoot "SNAPSHOTS"
$CompareDir = Join-Path $WalkRoot "COMPARISONS"

if (-not (Test-Path -LiteralPath $Root)) { throw "BLOCKED: ASSISTANT_LOCAL missing: $Root" }

New-Item -ItemType Directory -Path $ReceiptDir,$Closeout,$IndexDir,$ParkingDir,$DataLogsDir,$InvalidDir,$ChatRulesDir,$ContractDir,$SnapshotDir,$CompareDir -Force | Out-Null

# Archive this installer first so porch baseline is not polluted by the script itself.
$ScriptArchive = "Not running from porch"
if ($PSCommandPath) {
    $SelfFull = [System.IO.Path]::GetFullPath($PSCommandPath)
    $PorchFull = [System.IO.Path]::GetFullPath($Porch)
    if ($SelfFull.StartsWith($PorchFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        $ArchivePath = Join-Path $Closeout (Split-Path -Leaf $PSCommandPath)
        Move-Item -LiteralPath $PSCommandPath -Destination $ArchivePath -Force
        if (-not (Test-Path -LiteralPath $ArchivePath)) { throw "BLOCKED: script archive failed: $ArchivePath" }
        $ScriptArchive = $ArchivePath
    }
}

$Targets = [ordered]@{
    "ASSISTANT_LOCAL_INDEX" = Join-Path $IndexDir "ASSISTANT_LOCAL_INDEX_V1.md"
    "PARKING_LEDGER" = Join-Path $ParkingDir "PARKING_LEDGER_V1.md"
    "SESSION_LOG" = Join-Path $DataLogsDir "SESSION_LOG_20260522.md"
    "GAP_BACKFILL" = Join-Path $DataLogsDir "GAP_BACKFILL_20260520_20260521.md"
    "INVALID_RECEIPTS_INDEX" = Join-Path $InvalidDir "INVALID_RECEIPTS_INDEX_V1.md"
    "REVIEW_SURFACES_RULE" = Join-Path $ChatRulesDir "REVIEW_SURFACES_HOUSE_BASE_CLEAN_ROOM_V1.md"
}

$RouterPath = Join-Path $ChatRulesDir "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$RouterDrop = Join-Path $Desktop "CHAT_DROP_COPY__CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$MuleReturnPath = Join-Path $Root "MULE_REVIEW\RETURNS\MULE_RETURN_ASSISTANT_LOCAL_STABILIZATION_REVIEW_V1.md"

$ContractPath = Join-Path $ContractDir "ASSISTANT_LOCAL_MINIMAL_PACKET_SAME_SHAPE_CONTRACT_V1.0.json"

$Contract = [ordered]@{
    contract_name = "ASSISTANT_LOCAL_MINIMAL_PACKET_SAME_SHAPE_CONTRACT_V1.0"
    rule = "AFTER repeats BASELINE exactly. Same paths, labels, count logic, hashes, receipt checks, boundary checks, blocker checks, and output sections."
    root = $Root
    target_files = @(
        $Targets["ASSISTANT_LOCAL_INDEX"],
        $Targets["PARKING_LEDGER"],
        $Targets["SESSION_LOG"],
        $Targets["GAP_BACKFILL"],
        $Targets["INVALID_RECEIPTS_INDEX"],
        $Targets["REVIEW_SURFACES_RULE"],
        $RouterPath,
        $RouterDrop
    )
    required_dirs = @(
        $IndexDir,
        $ParkingDir,
        $DataLogsDir,
        $InvalidDir,
        $ChatRulesDir,
        $ReceiptDir,
        $WalkRoot
    )
    receipt_patterns = @(
        "MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_20260522_190913.txt",
        "MULE_AFTER_WALK_BLOCKER_REPAIR_RECEIPT_20260522_190913.txt",
        "SAME_SHAPE_DIRECTION_FEEL_GIT_REPAIR_RECEIPT_20260522_191843.txt",
        "MULE_RECENT_CHAT_RULES_PATCH_RECEIPT_*.txt",
        "WHY_WE_SUCK_METHOD_V1.1_SAVE_RECEIPT_*.txt",
        "CHAT_COCKPIT_ROUTER_MAP_TELEPORTER_RECEIPT_*.txt",
        "PORCH_TELEPORTER_VALIDATION_REPAIR_RECEIPT_*.txt"
    )
    output_sections = @(
        "ROOT_LANE_CHECK",
        "TARGET_FILE_CHECK",
        "RECEIPT_CHECK",
        "PORCH_CHECK",
        "MULE_RETURN_CHECK",
        "BOUNDARY_CHECK",
        "BLOCKER_CHECK",
        "NEXT_ACTION"
    )
} | ConvertTo-Json -Depth 8

Set-Content -LiteralPath $ContractPath -Value $Contract -Encoding UTF8
$ContractObj = Get-Content -LiteralPath $ContractPath -Raw | ConvertFrom-Json

function New-Snapshot {
    param(
        [string]$Phase,
        [string]$OutPath
    )

    $Lines = @()
    $Lines += "# ASSISTANT_LOCAL MINIMAL PACKET SAME-SHAPE WALK"
    $Lines += ""
    $Lines += "Timestamp: $Stamp"
    $Lines += "Phase: $Phase"
    $Lines += "Contract: $ContractPath"
    $Lines += "Mode: READ ONLY SNAPSHOT / NO DELETE / NO GIT / NO PUSH"
    $Lines += ""

    $Lines += "## ROOT_LANE_CHECK"
    foreach ($Dir in $ContractObj.required_dirs) {
        $Exists = Test-Path -LiteralPath $Dir
        $Lines += "- $Dir"
        $Lines += "  Exists: $Exists"
    }

    $Lines += ""
    $Lines += "## TARGET_FILE_CHECK"
    foreach ($Path in $ContractObj.target_files) {
        $Exists = Test-Path -LiteralPath $Path
        $Lines += "- $Path"
        $Lines += "  Exists: $Exists"
        if ($Exists) {
            $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Path
            $Lines += "  SHA256: $($Hash.Hash)"
        } else {
            $Lines += "  SHA256: MISSING"
        }
    }

    $Lines += ""
    $Lines += "## RECEIPT_CHECK"
    foreach ($Pattern in $ContractObj.receipt_patterns) {
        $Found = Get-ChildItem -LiteralPath $ReceiptDir -Filter $Pattern -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
        $Lines += "- Pattern: $Pattern"
        $Lines += "  Count: $($Found.Count)"
        if ($Found.Count -gt 0) {
            $Latest = $Found | Select-Object -First 1
            $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Latest.FullName
            $Lines += "  Latest: $($Latest.FullName)"
            $Lines += "  LatestSHA256: $($Hash.Hash)"
        } else {
            $Lines += "  Latest: NONE"
            $Lines += "  LatestSHA256: NONE"
        }
    }

    $Lines += ""
    $Lines += "## PORCH_CHECK"
    $Loose = Get-ChildItem -LiteralPath $Porch -File -ErrorAction SilentlyContinue | Sort-Object Name
    $Lines += "- Porch: $Porch"
    $Lines += "  LooseRootFileCount: $($Loose.Count)"
    if ($Loose.Count -eq 0) {
        $Lines += "  LooseFile: NONE"
    } else {
        foreach ($File in $Loose) { $Lines += "  LooseFile: $($File.Name)" }
    }

    $Lines += ""
    $Lines += "## MULE_RETURN_CHECK"
    $ReturnExists = Test-Path -LiteralPath $MuleReturnPath
    $Lines += "- MuleReturn: $MuleReturnPath"
    $Lines += "  Exists: $ReturnExists"
    if ($ReturnExists) {
        $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $MuleReturnPath
        $Lines += "  SHA256: $($Hash.Hash)"
    } else {
        $Lines += "  SHA256: MISSING"
    }

    $Lines += ""
    $Lines += "## BOUNDARY_CHECK"
    $Lines += "- Git: NOT USED"
    $Lines += "- Push: NOT USED"
    $Lines += "- PublicExport: NOT USED"
    $Lines += "- DoctrineRewrite: NOT USED"
    $Lines += "- ACTIVE_GUIDESRewrite: NOT USED"
    $Lines += "- CURRENT_TRUTH_INDEXRewrite: NOT USED"
    $Lines += "- Automation: NOT USED"
    $Lines += "- Dashboard: NOT USED"

    $Lines += ""
    $Lines += "## BLOCKER_CHECK"
    $Blockers = @()
    if (-not (Test-Path -LiteralPath $MuleReturnPath)) { $Blockers += "Missing mule return file." }
    if ($Loose.Count -gt 0) { $Blockers += "Porch root has loose files: $($Loose.Count)" }
    foreach ($Dir in $ContractObj.required_dirs) {
        if (-not (Test-Path -LiteralPath $Dir)) { $Blockers += "Missing required dir: $Dir" }
    }
    if ($Blockers.Count -eq 0) {
        $Lines += "- NONE"
    } else {
        foreach ($B in $Blockers) { $Lines += "- $B" }
    }

    $Lines += ""
    $Lines += "## NEXT_ACTION"
    if ($Phase -like "BASELINE*") {
        if ($Blockers.Count -eq 0) { $Lines += "- Build minimal local packet." } else { $Lines += "- Resolve blockers before build." }
    } else {
        if ($Blockers.Count -eq 0) { $Lines += "- Use packet; report saved surfaces." } else { $Lines += "- Resolve blockers before using packet." }
    }

    Set-Content -LiteralPath $OutPath -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

    return [PSCustomObject]@{
        Blockers = $Blockers
        LooseCount = $Loose.Count
    }
}

function Get-SectionText {
    param([string]$Text, [string]$Section)
    $Pattern = "(?ms)^## $([regex]::Escape($Section))\r?\n(.*?)(?=^## |\z)"
    $Match = [regex]::Match($Text, $Pattern)
    if ($Match.Success) { return ($Match.Groups[1].Value.Trim()) }
    return "SECTION_MISSING"
}

$BaselinePath = Join-Path $SnapshotDir ("ASSISTANT_LOCAL_MINIMAL_PACKET_BASELINE_{0}.md" -f $Stamp)
$BaselineResult = New-Snapshot -Phase "BASELINE / BEFORE MINIMAL PACKET BUILD" -OutPath $BaselinePath

if ($BaselineResult.Blockers.Count -gt 0) {
    throw "BLOCKED: baseline has blockers. Resolve before build.`n$($BaselineResult.Blockers -join "`n")"
}

# --- BUILD PACKET ---

$LatestReceipt = {
    param([string]$Pattern)
    $F = Get-ChildItem -LiteralPath $ReceiptDir -Filter $Pattern -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($F) { return $F.FullName }
    return "NONE FOUND"
}

$IndexContent = @"
# ASSISTANT_LOCAL Index — V1

STATUS: LOCAL-ONLY NAVIGATION INDEX / NOT PROOF / NOT DOCTRINE

PURPOSE:
Give future chats and local support passes a small front map for `ASSISTANT_LOCAL`.

BOUNDARY:
- Local-only assistant support.
- No Git.
- No public export.
- Not doctrine.
- Not ACTIVE_GUIDES.
- Not CURRENT_TRUTH_INDEX.
- Not proof by itself.

READ ORDER:
1. This index.
2. Latest relevant receipt in `_RECEIPTS`.
3. The specific lane file needed for the task.
4. Source files or hashes when making proof claims.

LANES:
- `_RECEIPTS`: local proof receipts and repair receipts.
- `CHAT_RULES_LOCAL_ONLY`: assistant chat behavior support and router cards.
- `ASSISTANT_LOCAL_JOURNAL`: reflection, character/naming, and non-proof journal notes.
- `DATA_LOGS`: operational session/event logs. These point to receipts; they are not proof alone.
- `PARKING`: custody for parked ideas, candidates, deferred fixes, and return triggers.
- `INVALID_RECEIPTS`: index for invalid, superseded, or repair-dependent receipts.
- `MULE_REVIEW`: mule handoffs, packets, and returns.
- `HOUSE_WALKS`: same-shape baseline/after/comparison snapshots.
- `PORCH_CLOSEOUT`: archived porch scripts and moved intake files.

SOURCE-CHECK RULE:
Memory may orient. It cannot prove. When a claim depends on saved local output, verify path, receipt, current existence, and hash when available.

CURRENT SAFE NEXT ACTION:
Use this packet as a local support layer. Do not promote it. Do not use it to rewrite Mr.Kleen doctrine or active guides.
"@

$ParkingContent = @"
# PARKING_LEDGER_V1

STATUS: LOCAL-ONLY PARKING CUSTODY LEDGER / NOT AUTHORITY

RULE:
A parked item is only real parking when it has a name, source, lane, reason, status, return trigger, boundary, and proof pointer.

| ID | Name | Source | Lane | Reason | Status | Return Trigger | Boundary | Proof Pointer |
|---|---|---|---|---|---|---|---|---|
| PARK-20260522-001 | Gap backfill 20260520-20260521 | Mule return and stabilization packet | DATA_LOGS | Missing live logs are known, but source is incomplete | NEEDS MORE SOURCE | User provides source or approves unknown-marked backfill | Do not fake same-day logs | `DATA_LOGS\GAP_BACKFILL_20260520_20260521.md` |
| PARK-20260522-002 | Current Desktop chat drop-copy visibility | Same-shape blocker repair | CHAT_RULES_LOCAL_ONLY / Desktop pickup | New-chat pickup surface matters but should not broad-export old rules | PARTIAL / SELECTIVE ONLY | User asks for selected pickup or source changes | Copy only selected current sources; receipt required | `_RECEIPTS\MULE_AFTER_WALK_BLOCKER_REPAIR_RECEIPT_20260522_190913.txt` |
| PARK-20260522-003 | Same-shape direction-feel method | User instruction and brain save | CHAT_RULES_LOCAL_ONLY / BRAIN_LEARNING | Harness-not-cage method needs trigger-based use | ACTIVE SUPPORT | Direction comparison, mule, porch, proof, carryover, Git/public boundary | Do not force full armor on tiny chat mistakes | `_RECEIPTS\SAME_SHAPE_DIRECTION_FEEL_GIT_REPAIR_RECEIPT_20260522_191843.txt` |
| PARK-20260522-004 | Minimal packet future refinement | Mule return | INDEX / PARKING / DATA_LOGS / INVALID_RECEIPTS | First pass should stay small and inspectable | BUILT V1 | Volume or live-use proof shows needed split | No dashboard, automation, database, broad cleanup | current build receipt |
"@

$SessionContent = @"
# SESSION_LOG_20260522

STATUS: OPERATIONAL SESSION LOG / LOCAL-ONLY / NOT PROOF BY ITSELF

RULE:
This log summarizes events and points to receipts. It does not replace receipts.

## Session events

### Assistant-local stabilization
- `ASSISTANT_LOCAL` used as local-only assistant support root.
- Chat rules, mule review, receipts, porch closeout, and house-walk lanes were used as support surfaces.

### Mule review
- Mule review return was created and read after same-shape AFTER repair passed.
- Mule return SHA256 reported: `331BCC191D3051AE62EB51D058B2DA476868638EC1BED69AE29310907FF4183D`.
- Mule found real gaps: `INDEX`, `PARKING`, `DATA_LOGS`, `INVALID_RECEIPTS`, and `REVIEW_SURFACE_RULE`.
- Mule marked `GAP_BACKFILL` as real but needing more source.

### Same-shape house walk
- Baseline receipt: `_RECEIPTS\SAME_SHAPE_HOUSE_WALK_METHOD_AND_BASELINE_RECEIPT_20260522_190459.txt`
- Initial after-walk found blockers.
- Repair receipt: `_RECEIPTS\MULE_AFTER_WALK_BLOCKER_REPAIR_RECEIPT_20260522_190913.txt`
- Current after-walk PASS receipt: `_RECEIPTS\MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_20260522_190913.txt`

### Direction-feel save
- Same-shape direction-feel was saved to chat-support and Mr.Kleen brain.
- Repair receipt: `_RECEIPTS\SAME_SHAPE_DIRECTION_FEEL_GIT_REPAIR_RECEIPT_20260522_191843.txt`
- Mr.Kleen final saved position reported: `8d8787d790d2565f368e13d74192566155f04b57`.

### Minimal local packet
- This V1 packet builds the small mule-approved support set.
- It does not build dashboard, automation, database, public export, Git route, or doctrine.
"@

$GapContent = @"
# GAP_BACKFILL_20260520_20260521

STATUS: HONEST BACKFILL / NEEDS MORE SOURCE / NOT LIVE SAME-DAY LOG

BOUNDARY:
This is not a reconstructed live daily log. It is a gap marker.

KNOWN:
- Mule review identified missing data-log coverage for `20260520` and `20260521`.
- The need is real because receipts and later session state show operational events happened without a dedicated `DATA_LOGS` lane.
- The current source available to this build is not enough to reconstruct complete same-day logs.

UNKNOWN:
- Full exact event sequence for each date.
- Complete receipt set for each date.
- Which items were reflection, operational data, proof, or parking on those days.

RULE:
Do not fake missing logs. Mark unknowns. Add source later if provided.

RETURN TRIGGER:
When user provides source material, receipt list, or asks for gap reconstruction with evidence.
"@

$InvalidContent = @"
# INVALID_RECEIPTS_INDEX_V1

STATUS: LOCAL-ONLY PROOF HYGIENE INDEX / DO NOT DELETE RECEIPTS

RULE:
Bad proof is still evidence. Preserve receipts in place. Mark invalid, superseded, partial, or repair-dependent so they are not reused naked.

| Receipt | Claimed/Observed State | Current Status | Reason | Repair/Superseding Proof |
|---|---|---|---|---|
| `CHAT_RULES_LOCAL_ONLY\RECEIPTS\CHAT_RULES_DESKTOP_DROP_COPY_RECEIPT_20260522_172809.txt` | PASS printed after error | INVALID / SUPERSEDED | Run threw before copy completion, then still printed PASS | `CHAT_RULES_LOCAL_ONLY\RECEIPTS\CHAT_RULES_DESKTOP_DROP_COPY_REPAIR_RECEIPT_20260522_172936.txt` |
| `_RECEIPTS\PORCH_TELEPORTER_ROOT_CLOSEOUT_RECEIPT_20260522_181234.txt` | Closeout receipt | REPAIR-DEPENDENT / SUPERSEDED | Later validation said prior teleporter hit interactive PowerShell else-branch issue before final proof | `_RECEIPTS\PORCH_TELEPORTER_VALIDATION_REPAIR_RECEIPT_20260522_181337.txt` |
| `_RECEIPTS\MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_20260522_190704.txt` | PARTIAL / blockers present | SUPERSEDED BY REPAIR | Missing Desktop pickups and 3 loose porch files | `_RECEIPTS\MULE_AFTER_WALK_BLOCKER_REPAIR_RECEIPT_20260522_190913.txt` and `_RECEIPTS\MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_20260522_190913.txt` |

USE:
Before trusting an older PASS receipt, check this index and the latest repair receipt.
"@

$ReviewSurfaceContent = @"
# REVIEW_SURFACES_HOUSE_BASE_CLEAN_ROOM_V1

STATUS: LOCAL CHAT-RULE SUPPORT / REVIEW SURFACE SELECTOR / NOT DOCTRINE

PURPOSE:
Choose the right review surface before critique, proof, or design work.

## House Chat

Use when:
- full project context matters;
- Mr.Kleen / Clean Seed house rules matter;
- saved state, receipts, lanes, mule, porch, Git, public/private boundaries, or proof routing matter.

Behavior:
- use memory for orientation;
- verify saved claims with files/receipts/hashes when possible;
- do not treat memory as proof.

## Base Project Chat

Use when:
- project awareness helps, but the task needs restraint;
- the answer should avoid dragging full old context;
- the user wants clean next-step routing without a full house walk.

Behavior:
- keep assumptions low;
- use only relevant project rules;
- ask for source when proof is needed.

## Clean-Room Chat

Use when:
- outside critique is needed;
- the reviewer should not inherit project assumptions;
- user wants a fresh/unloaded read.

Behavior:
- do not assume house rules unless provided;
- judge the provided artifact on its own surface;
- clearly state missing context.

## Source-check rule

When the claim depends on saved local output, open/check the source, receipt, hash, or current file existence. If unavailable, say source missing instead of claiming proof.

## Boundary

This file chooses a review surface. It is not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX, and not proof by itself.
"@

Set-Content -LiteralPath $Targets["ASSISTANT_LOCAL_INDEX"] -Value $IndexContent -Encoding UTF8
Set-Content -LiteralPath $Targets["PARKING_LEDGER"] -Value $ParkingContent -Encoding UTF8
Set-Content -LiteralPath $Targets["SESSION_LOG"] -Value $SessionContent -Encoding UTF8
Set-Content -LiteralPath $Targets["GAP_BACKFILL"] -Value $GapContent -Encoding UTF8
Set-Content -LiteralPath $Targets["INVALID_RECEIPTS_INDEX"] -Value $InvalidContent -Encoding UTF8
Set-Content -LiteralPath $Targets["REVIEW_SURFACES_RULE"] -Value $ReviewSurfaceContent -Encoding UTF8

$RouterPatchStatus = "ROUTER NOT FOUND"
if (Test-Path -LiteralPath $RouterPath) {
    $RouterText = Get-Content -LiteralPath $RouterPath -Raw
    if ($RouterText -notmatch "REVIEW_SURFACES_HOUSE_BASE_CLEAN_ROOM_V1") {
        $Addendum = @'

---

## Router Addendum — Review Surfaces and Source Check

ASSISTANT: for review surface choice, critique mode, house/base/clean-room distinction, or source-check routing, go to:

`CHAT_RULES_LOCAL_ONLY\REVIEW_SURFACES_HOUSE_BASE_CLEAN_ROOM_V1.md`

Rule:
Memory may orient. It cannot prove. When the route depends on actual house/local files, open the source or state source missing before claiming proof.
'@
        Add-Content -LiteralPath $RouterPath -Value $Addendum -Encoding UTF8
        $RouterPatchStatus = "PATCHED"
    } else {
        $RouterPatchStatus = "ALREADY PRESENT"
    }
    Copy-Item -LiteralPath $RouterPath -Destination $RouterDrop -Force
}

$AfterPath = Join-Path $SnapshotDir ("ASSISTANT_LOCAL_MINIMAL_PACKET_AFTER_{0}.md" -f $Stamp)
$AfterResult = New-Snapshot -Phase "AFTER / AFTER MINIMAL PACKET BUILD" -OutPath $AfterPath

$ComparePath = Join-Path $CompareDir ("ASSISTANT_LOCAL_MINIMAL_PACKET_BASELINE_TO_AFTER_{0}.md" -f $Stamp)

$BaseText = Get-Content -LiteralPath $BaselinePath -Raw
$AfterText = Get-Content -LiteralPath $AfterPath -Raw
$Sections = @(
    "ROOT_LANE_CHECK",
    "TARGET_FILE_CHECK",
    "RECEIPT_CHECK",
    "PORCH_CHECK",
    "MULE_RETURN_CHECK",
    "BOUNDARY_CHECK",
    "BLOCKER_CHECK",
    "NEXT_ACTION"
)

$CompareLines = @()
$CompareLines += "# ASSISTANT_LOCAL MINIMAL PACKET BASELINE TO AFTER COMPARISON"
$CompareLines += ""
$CompareLines += "Timestamp: $Stamp"
$CompareLines += "Contract: $ContractPath"
$CompareLines += "Baseline: $BaselinePath"
$CompareLines += "After: $AfterPath"
$CompareLines += "Mode: SAME-SHAPE COMPARISON / LOCAL ONLY"
$CompareLines += ""
$CompareLines += "## COMPARISON"

foreach ($Section in $Sections) {
    $B = Get-SectionText -Text $BaseText -Section $Section
    $A = Get-SectionText -Text $AfterText -Section $Section

    $Verdict = "UNCHANGED CLEAN"
    if ($B -eq "SECTION_MISSING" -or $A -eq "SECTION_MISSING") {
        $Verdict = "CHANGED DIRTY / SECTION MISSING"
    } elseif ($B -ne $A) {
        if ($Section -eq "TARGET_FILE_CHECK" -or $Section -eq "NEXT_ACTION") {
            $Verdict = "CHANGED EXPECTED"
        } elseif ($Section -eq "RECEIPT_CHECK") {
            $Verdict = "CHANGED EXPECTED OR NEEDS REVIEW"
        } else {
            $Verdict = "CHANGED DIRTY OR NEEDS REVIEW"
        }
    }

    $CompareLines += "### $Section"
    $CompareLines += "Verdict: $Verdict"
    $CompareLines += ""
}

$CompareLines += "## ADDED AFTER BASELINE"
$CompareLines += "- NONE"
$CompareLines += ""
$CompareLines += "## FINAL JUDGE"
if ($AfterResult.Blockers.Count -eq 0) {
    $CompareLines += "Verdict: PASS / MINIMAL LOCAL PACKET BUILT / READY FOR USE"
} else {
    $CompareLines += "Verdict: PARTIAL / MINIMAL LOCAL PACKET BUILT WITH BLOCKERS"
    foreach ($B in $AfterResult.Blockers) { $CompareLines += "- $B" }
}

Set-Content -LiteralPath $ComparePath -Value ($CompareLines -join [Environment]::NewLine) -Encoding UTF8

$ReceiptPath = Join-Path $ReceiptDir ("ASSISTANT_LOCAL_MINIMAL_PACKET_BUILD_RECEIPT_{0}.txt" -f $Stamp)

$Hashes = @()
foreach ($Key in $Targets.Keys) {
    $Path = $Targets[$Key]
    $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Path
    $Hashes += [PSCustomObject]@{ Key=$Key; Path=$Path; SHA256=$Hash.Hash }
}
if (Test-Path -LiteralPath $RouterPath) {
    $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $RouterPath
    $Hashes += [PSCustomObject]@{ Key="ROUTER_MAP"; Path=$RouterPath; SHA256=$Hash.Hash }
}
if (Test-Path -LiteralPath $RouterDrop) {
    $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $RouterDrop
    $Hashes += [PSCustomObject]@{ Key="ROUTER_DESKTOP_DROP"; Path=$RouterDrop; SHA256=$Hash.Hash }
}

$ContractHash = Get-FileHash -Algorithm SHA256 -LiteralPath $ContractPath
$BaselineHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BaselinePath
$AfterHash = Get-FileHash -Algorithm SHA256 -LiteralPath $AfterPath
$CompareHash = Get-FileHash -Algorithm SHA256 -LiteralPath $ComparePath

$ReceiptLines = @()
$ReceiptLines += "ASSISTANT_LOCAL MINIMAL PACKET BUILD RECEIPT"
$ReceiptLines += "Timestamp: $Stamp"
if ($AfterResult.Blockers.Count -eq 0) {
    $ReceiptLines += "Verdict: PASS / MINIMAL LOCAL PACKET BUILT / SAME-SHAPE COMPARED / NO GIT / NO PUSH"
} else {
    $ReceiptLines += "Verdict: PARTIAL / MINIMAL LOCAL PACKET BUILT WITH BLOCKERS / NO GIT / NO PUSH"
}
$ReceiptLines += ""
$ReceiptLines += "Built files:"
foreach ($Item in $Hashes) {
    $ReceiptLines += "- $($Item.Key): $($Item.Path)"
    $ReceiptLines += "  SHA256: $($Item.SHA256)"
}
$ReceiptLines += ""
$ReceiptLines += "Same-shape proof:"
$ReceiptLines += "- Contract: $ContractPath"
$ReceiptLines += "  SHA256: $($ContractHash.Hash)"
$ReceiptLines += "- Baseline: $BaselinePath"
$ReceiptLines += "  SHA256: $($BaselineHash.Hash)"
$ReceiptLines += "- After: $AfterPath"
$ReceiptLines += "  SHA256: $($AfterHash.Hash)"
$ReceiptLines += "- Comparison: $ComparePath"
$ReceiptLines += "  SHA256: $($CompareHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Router patch status: $RouterPatchStatus"
$ReceiptLines += ""
$ReceiptLines += "Script archive:"
$ReceiptLines += "- $ScriptArchive"
$ReceiptLines += ""
$ReceiptLines += "Blockers:"
if ($AfterResult.Blockers.Count -eq 0) {
    $ReceiptLines += "- NONE"
} else {
    foreach ($B in $AfterResult.Blockers) { $ReceiptLines += "- $B" }
}
$ReceiptLines += ""
$ReceiptLines += "Boundary:"
$ReceiptLines += "- Local-only packet."
$ReceiptLines += "- No Git."
$ReceiptLines += "- No push."
$ReceiptLines += "- No public export."
$ReceiptLines += "- No doctrine promotion."
$ReceiptLines += "- No ACTIVE_GUIDES rewrite."
$ReceiptLines += "- No CURRENT_TRUTH_INDEX rewrite."
$ReceiptLines += "- No dashboard."
$ReceiptLines += "- No automation."
$ReceiptLines += "- No broad cleanup."
$ReceiptLines += "- Gap backfill marks unknowns; it does not fake live logs."

Set-Content -LiteralPath $ReceiptPath -Value ($ReceiptLines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "ASSISTANT_LOCAL MINIMAL PACKET BUILD COMPLETE"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Baseline: $BaselinePath"
Write-Host "After: $AfterPath"
Write-Host "Comparison: $ComparePath"
Write-Host "Router patch: $RouterPatchStatus"
if ($AfterResult.Blockers.Count -eq 0) {
    Write-Host "Verdict: PASS / MINIMAL LOCAL PACKET BUILT / NO GIT / NO PUSH"
} else {
    Write-Host "Verdict: PARTIAL / BLOCKERS PRESENT / NO GIT / NO PUSH"
}
