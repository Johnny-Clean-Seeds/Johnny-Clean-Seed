# SAVE_AND_APPLY_SAME_SHAPE_HOUSE_WALK_V1.0.ps1
# Local-only fix/apply for Before/After Same-Shape House Walk.
# Saves the method, patches router if present, creates a mule-review BASELINE snapshot using a reusable comparison contract,
# writes receipt, and archives this script from Desktop\123 when applicable.
# No Git. No push. No public export. No doctrine.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$Root = Join-Path $Desktop "ASSISTANT_LOCAL"
$ChatRules = Join-Path $Root "CHAT_RULES_LOCAL_ONLY"
$WalkRoot = Join-Path $Root "HOUSE_WALKS"
$ContractDir = Join-Path $WalkRoot "CONTRACTS"
$SnapshotDir = Join-Path $WalkRoot "SNAPSHOTS"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$Closeout = Join-Path $Root ("PORCH_CLOSEOUT\SAME_SHAPE_HOUSE_WALK_METHOD_V1.0_{0}" -f $Stamp)

New-Item -ItemType Directory -Path $ChatRules,$WalkRoot,$ContractDir,$SnapshotDir,$ReceiptDir,$Closeout -Force | Out-Null

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

$MethodPath = Join-Path $ChatRules "BEFORE_AFTER_SAME_SHAPE_HOUSE_WALK_METHOD_V1.0.md"
$IssuePath = Join-Path $ChatRules "BEFORE_AFTER_SAME_SHAPE_CURRENT_ISSUE_APPLICATION_20260522_V1.0.md"
$MethodDrop = Join-Path $Desktop "CHAT_DROP_COPY__BEFORE_AFTER_SAME_SHAPE_HOUSE_WALK_METHOD_V1.0.md"
$RouterPath = Join-Path $ChatRules "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$RouterDrop = Join-Path $Desktop "CHAT_DROP_COPY__CHAT_COCKPIT_ROUTER_MAP_V1.0.md"

$Method = @'
# Before/After Same-Shape House Walk Method — V1.0

STATUS: ACROSS-BOARD ASSISTANT DIRECTION-FEEL / COMPARISON METHOD

PURPOSE:
Make direction-feel evidence-based instead of vibe-based.

BOUNDARY:
- Local-only assistant behavior support.
- Not doctrine.
- Not Git.
- Not public.
- Does not replace Mr.Kleen.
- Does not rewrite ACTIVE_GUIDES.
- Does not rewrite CURRENT_TRUTH_INDEX.
- Does not authorize cleanup, deletion, merge, promotion, or broad rewrite.

WHEN THIS FIRES:
Use this before and after mule reviews, porch tracker/teleporter closeouts, local saves, chat-rule installs, file moves, receipt repairs, review passes, Git/public boundary checks, or any task where we need to know whether things got cleaner or dirtier.

CORE RULE:
The AFTER walk must use the exact same comparison contract as the BASELINE walk unless the user explicitly approves a changed checklist.

SAME MEANS:
- same paths;
- same depth;
- same filters;
- same file names and patterns;
- same ordering;
- same labels;
- same count logic;
- same hash fields;
- same receipt checks;
- same boundary checks;
- same blocker checks;
- same next-action field;
- same output sections.

DO NOT:
- improve the second walk;
- widen it;
- narrow it;
- rename fields;
- reorder sections;
- add smarter checks into the direct comparison.

If a new concern appears after baseline, put it under:
ADDED AFTER BASELINE

That new section is useful, but it is not part of the direct comparison.

COMPARISON LABELS:
- UNCHANGED CLEAN
- CHANGED EXPECTED
- CHANGED DIRTY
- MISSING BEFORE
- MISSING AFTER
- NEW UNKNOWN
- RESOLVED BLOCKER
- NEW BLOCKER
- NOT COMPARABLE / ADDED AFTER BASELINE

SHORT FORM:
Do the same walk twice. Compare by section. Add new checks separately. Do not change the ruler while measuring.
'@

$Issue = @'
# Before/After Same-Shape House Walk — Current Issue Application — 20260522 — V1.0

STATUS: CURRENT ISSUE FIX / LOCAL-ONLY CHAT BEHAVIOR SUPPORT

INTENDED JOB:
The new house-walk method should let us feel direction by evidence. Before mule review, capture a baseline. After mule review, run the exact same walk and compare section by section.

ACTUAL FAILURE RISK:
The assistant had been describing the method but had not yet saved it locally, patched the router, or applied it to the current mule-review setup as a baseline.

CURRENT ISSUES FIXED BY THIS PASS:
1. Method needed a local chat-rule file.
2. Method needed Desktop pickup.
3. Router needed a route line for direction-feel / same-shape house walks.
4. Current mule review needed a BASELINE snapshot before kickoff.
5. Future AFTER walk needed the exact same contract.

MISSING ACTIVE PARTS:
- saved method;
- current issue application;
- router route;
- comparison contract;
- baseline snapshot;
- receipt.

FIX APPLIED:
This pass saves the method, saves this current issue application, patches router if present, creates a fixed mule-review comparison contract, writes a BASELINE snapshot, and writes a receipt.

DISPOSITION:
ADOPT across-board as a comparison/direction-feel method.
ADAPT current application to mule-review baseline.
Do not promote to doctrine.
Do not Git/public push.
'@

Set-Content -LiteralPath $MethodPath -Value $Method -Encoding UTF8
Set-Content -LiteralPath $IssuePath -Value $Issue -Encoding UTF8
Copy-Item -LiteralPath $MethodPath -Destination $MethodDrop -Force

$RouterPatched = "NO - router map not found"
if (Test-Path -LiteralPath $RouterPath) {
    $Router = Get-Content -LiteralPath $RouterPath -Raw
    if ($Router -notmatch "Before/After Same-Shape House Walk") {
        $RouterAdd = @'

---

## Router Addendum — Before/After Same-Shape House Walk

ASSISTANT: for direction-feel, house walk, before/after comparison, mule-before/mule-after, porch closeout comparison, or "know what changed," go to house rules for Before/After Same-Shape House Walk.

Use:
`BEFORE_AFTER_SAME_SHAPE_HOUSE_WALK_METHOD_V1.0.md`

Baseline and after-walk must use the same comparison contract.
New checks after baseline go only under ADDED AFTER BASELINE.
'@
        Add-Content -LiteralPath $RouterPath -Value $RouterAdd -Encoding UTF8
        $RouterPatched = "YES - same-shape addendum appended"
    } else {
        $RouterPatched = "ALREADY PRESENT"
    }
    Copy-Item -LiteralPath $RouterPath -Destination $RouterDrop -Force
}

$ContractPath = Join-Path $ContractDir "MULE_REVIEW_SAME_SHAPE_HOUSE_WALK_CONTRACT_V1.0.json"

$Contract = [ordered]@{
    contract_name = "MULE_REVIEW_SAME_SHAPE_HOUSE_WALK_CONTRACT_V1.0"
    rule = "AFTER must repeat BASELINE exactly: same paths, depth, filters, ordering, labels, counts, hashes, receipt checks, boundary checks, blocker checks, next-action field, and output sections."
    paths = [ordered]@{
        root = $Root
        chat_rules = $ChatRules
        mule_review = (Join-Path $Root "MULE_REVIEW")
        returns = (Join-Path $Root "MULE_REVIEW\RETURNS")
        receipts = $ReceiptDir
        porch = $Porch
        desktop = $Desktop
    }
    expected_files = @(
        "MULE_REVIEW\MULE_REVIEW_ASSISTANT_LOCAL_STABILIZATION_HANDOFF_V1.md",
        "MULE_REVIEW\MULE_KICKOFF_ASSISTANT_LOCAL_STABILIZATION_REVIEW_V1.md",
        "MULE_REVIEW\ASSISTANT_LOCAL_BROAD_STABILIZATION_PACKET_V1.5.md",
        "CHAT_RULES_LOCAL_ONLY\CHAT_COCKPIT_ROUTER_MAP_V1.0.md",
        "CHAT_RULES_LOCAL_ONLY\WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md",
        "CHAT_RULES_LOCAL_ONLY\WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md",
        "CHAT_RULES_LOCAL_ONLY\BEFORE_AFTER_SAME_SHAPE_HOUSE_WALK_METHOD_V1.0.md"
    )
    desktop_pickups = @(
        "MULE_HANDOFF_ASSISTANT_LOCAL_STABILIZATION_REVIEW_V1.md",
        "CHAT_DROP_COPY__CHAT_COCKPIT_ROUTER_MAP_V1.0.md",
        "CHAT_DROP_COPY__WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md",
        "CHAT_DROP_COPY__WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md",
        "CHAT_DROP_COPY__BEFORE_AFTER_SAME_SHAPE_HOUSE_WALK_METHOD_V1.0.md"
    )
    receipt_patterns = @(
        "MULE_RECENT_CHAT_RULES_PATCH_RECEIPT_*.txt",
        "WHY_WE_SUCK_METHOD_V1.1_SAVE_RECEIPT_*.txt",
        "CHAT_COCKPIT_ROUTER_MAP_TELEPORTER_RECEIPT_*.txt",
        "PORCH_TELEPORTER_VALIDATION_REPAIR_RECEIPT_*.txt"
    )
    return_file = "MULE_REVIEW\RETURNS\MULE_RETURN_ASSISTANT_LOCAL_STABILIZATION_REVIEW_V1.md"
    output_sections = @(
        "ROOT_LANE_CHECK",
        "EXPECTED_FILE_CHECK",
        "DESKTOP_PICKUP_CHECK",
        "RECEIPT_CHECK",
        "PORCH_CHECK",
        "RETURN_FOLDER_CHECK",
        "BOUNDARY_CHECK",
        "BLOCKER_CHECK",
        "NEXT_ACTION"
    )
} | ConvertTo-Json -Depth 8

Set-Content -LiteralPath $ContractPath -Value $Contract -Encoding UTF8

$ContractObj = Get-Content -LiteralPath $ContractPath -Raw | ConvertFrom-Json

$SnapshotPath = Join-Path $SnapshotDir ("MULE_REVIEW_BASELINE_SNAPSHOT_{0}.md" -f $Stamp)

$Lines = @()
$Lines += "# MULE REVIEW BASELINE SAME-SHAPE HOUSE WALK"
$Lines += ""
$Lines += "Timestamp: $Stamp"
$Lines += "Phase: BASELINE / BEFORE MULE REVIEW"
$Lines += "Contract: $ContractPath"
$Lines += "Mode: READ ONLY / NO MOVE / NO DELETE / NO GIT / NO PUSH"
$Lines += ""
$Lines += "## ROOT_LANE_CHECK"
foreach ($Prop in $ContractObj.paths.PSObject.Properties) {
    $Exists = Test-Path -LiteralPath $Prop.Value
    $Lines += "- $($Prop.Name): $($Prop.Value)"
    $Lines += "  Exists: $Exists"
}

$Lines += ""
$Lines += "## EXPECTED_FILE_CHECK"
foreach ($Rel in $ContractObj.expected_files) {
    $Path = Join-Path $Root $Rel
    $Exists = Test-Path -LiteralPath $Path
    $Lines += "- $Rel"
    $Lines += "  Path: $Path"
    $Lines += "  Exists: $Exists"
    if ($Exists) {
        $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Path
        $Lines += "  SHA256: $($Hash.Hash)"
    } else {
        $Lines += "  SHA256: MISSING"
    }
}

$Lines += ""
$Lines += "## DESKTOP_PICKUP_CHECK"
foreach ($Name in $ContractObj.desktop_pickups) {
    $Path = Join-Path $Desktop $Name
    $Exists = Test-Path -LiteralPath $Path
    $Lines += "- $Name"
    $Lines += "  Path: $Path"
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
if ($Loose.Count -gt 0) {
    foreach ($File in $Loose) { $Lines += "  LooseFile: $($File.Name)" }
} else {
    $Lines += "  LooseFile: NONE"
}

$Lines += ""
$Lines += "## RETURN_FOLDER_CHECK"
$ReturnPath = Join-Path $Root $ContractObj.return_file
$ReturnExists = Test-Path -LiteralPath $ReturnPath
$Lines += "- ExpectedReturn: $ReturnPath"
$Lines += "  Exists: $ReturnExists"
if ($ReturnExists) {
    $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $ReturnPath
    $Lines += "  SHA256: $($Hash.Hash)"
} else {
    $Lines += "  SHA256: MISSING"
}

$Lines += ""
$Lines += "## BOUNDARY_CHECK"
$Lines += "- Git: NOT CHECKED HERE / LOCAL-ONLY ASSISTANT ROOT"
$Lines += "- Push: NOT ATTEMPTED"
$Lines += "- PublicExport: NOT ATTEMPTED"
$Lines += "- DoctrineRewrite: NOT ATTEMPTED"
$Lines += "- ACTIVE_GUIDESRewrite: NOT ATTEMPTED"
$Lines += "- CURRENT_TRUTH_INDEXRewrite: NOT ATTEMPTED"

$Lines += ""
$Lines += "## BLOCKER_CHECK"
$Blockers = @()
foreach ($Rel in $ContractObj.expected_files) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $Rel))) { $Blockers += "Missing expected file: $Rel" }
}
foreach ($Name in $ContractObj.desktop_pickups) {
    if (-not (Test-Path -LiteralPath (Join-Path $Desktop $Name))) { $Blockers += "Missing Desktop pickup: $Name" }
}
if ($Loose.Count -gt 0) { $Blockers += "Porch root has loose files: $($Loose.Count)" }
if ($ReturnExists) { $Blockers += "Return file already exists before mule review; check if rerun." }
if ($Blockers.Count -eq 0) {
    $Lines += "- NONE"
} else {
    foreach ($B in $Blockers) { $Lines += "- $B" }
}

$Lines += ""
$Lines += "## NEXT_ACTION"
if ($Blockers.Count -eq 0) {
    $Lines += "- Send mule kickoff."
} else {
    $Lines += "- Resolve blockers before mule kickoff."
}

Set-Content -LiteralPath $SnapshotPath -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

$MethodHash = Get-FileHash -Algorithm SHA256 -LiteralPath $MethodPath
$IssueHash = Get-FileHash -Algorithm SHA256 -LiteralPath $IssuePath
$ContractHash = Get-FileHash -Algorithm SHA256 -LiteralPath $ContractPath
$SnapshotHash = Get-FileHash -Algorithm SHA256 -LiteralPath $SnapshotPath
$DropHash = Get-FileHash -Algorithm SHA256 -LiteralPath $MethodDrop

$RouterHashText = "Router map not found"
if (Test-Path -LiteralPath $RouterPath) { $RouterHashText = (Get-FileHash -Algorithm SHA256 -LiteralPath $RouterPath).Hash }

$ReceiptPath = Join-Path $ReceiptDir ("SAME_SHAPE_HOUSE_WALK_METHOD_AND_BASELINE_RECEIPT_{0}.txt" -f $Stamp)

$ReceiptLines = @()
$ReceiptLines += "SAME-SHAPE HOUSE WALK METHOD AND BASELINE RECEIPT"
$ReceiptLines += "Timestamp: $Stamp"
$ReceiptLines += "Verdict: PASS / METHOD SAVED AND BASELINE CAPTURED / NO GIT / NO PUSH"
$ReceiptLines += ""
$ReceiptLines += "Saved method:"
$ReceiptLines += "- $MethodPath"
$ReceiptLines += "  SHA256: $($MethodHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Saved current issue application:"
$ReceiptLines += "- $IssuePath"
$ReceiptLines += "  SHA256: $($IssueHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Desktop pickup:"
$ReceiptLines += "- $MethodDrop"
$ReceiptLines += "  SHA256: $($DropHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Router:"
$ReceiptLines += "- Patch status: $RouterPatched"
$ReceiptLines += "- Router SHA256: $RouterHashText"
$ReceiptLines += ""
$ReceiptLines += "Comparison contract:"
$ReceiptLines += "- $ContractPath"
$ReceiptLines += "  SHA256: $($ContractHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Baseline snapshot:"
$ReceiptLines += "- $SnapshotPath"
$ReceiptLines += "  SHA256: $($SnapshotHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Porch closeout:"
$ReceiptLines += "- Script archive: $ScriptArchive"
$ReceiptLines += "- Closeout folder: $Closeout"
$ReceiptLines += ""
$ReceiptLines += "Boundary:"
$ReceiptLines += "- Local-only assistant behavior support."
$ReceiptLines += "- Baseline read-only."
$ReceiptLines += "- No move except archiving this script from porch."
$ReceiptLines += "- No delete."
$ReceiptLines += "- No Git."
$ReceiptLines += "- No push."
$ReceiptLines += "- No public export."
$ReceiptLines += "- Not doctrine."
$ReceiptLines += "- Not ACTIVE_GUIDES."
$ReceiptLines += "- Not CURRENT_TRUTH_INDEX."

Set-Content -LiteralPath $ReceiptPath -Value ($ReceiptLines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "SAME-SHAPE HOUSE WALK METHOD APPLIED"
Write-Host "Method: $MethodPath"
Write-Host "Contract: $ContractPath"
Write-Host "Baseline: $SnapshotPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Verdict: PASS / METHOD SAVED AND BASELINE CAPTURED / NO GIT / NO PUSH"
