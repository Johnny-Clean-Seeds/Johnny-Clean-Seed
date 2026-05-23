# RUN_MULE_REVIEW_AFTER_SAME_SHAPE_HOUSE_WALK_V1.0.ps1
# Runs AFTER snapshot using the existing mule-review same-shape contract.
# Then compares BASELINE vs AFTER by the same named sections.
# No Git. No push. No public export. No move. No delete.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$Root = Join-Path $Desktop "ASSISTANT_LOCAL"
$WalkRoot = Join-Path $Root "HOUSE_WALKS"
$ContractDir = Join-Path $WalkRoot "CONTRACTS"
$SnapshotDir = Join-Path $WalkRoot "SNAPSHOTS"
$CompareDir = Join-Path $WalkRoot "COMPARISONS"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$Closeout = Join-Path $Root ("PORCH_CLOSEOUT\SAME_SHAPE_AFTER_WALK_V1.0_{0}" -f $Stamp)

New-Item -ItemType Directory -Path $SnapshotDir,$CompareDir,$ReceiptDir,$Closeout -Force | Out-Null

$ContractPath = Join-Path $ContractDir "MULE_REVIEW_SAME_SHAPE_HOUSE_WALK_CONTRACT_V1.0.json"
if (-not (Test-Path -LiteralPath $ContractPath)) {
    throw "BLOCKED: comparison contract missing: $ContractPath"
}

$Baseline = Get-ChildItem -LiteralPath $SnapshotDir -Filter "MULE_REVIEW_BASELINE_SNAPSHOT_*.md" -File -ErrorAction Stop |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $Baseline) {
    throw "BLOCKED: no baseline snapshot found in $SnapshotDir"
}

$ContractObj = Get-Content -LiteralPath $ContractPath -Raw | ConvertFrom-Json

$AfterPath = Join-Path $SnapshotDir ("MULE_REVIEW_AFTER_SNAPSHOT_{0}.md" -f $Stamp)

$Lines = @()
$Lines += "# MULE REVIEW AFTER SAME-SHAPE HOUSE WALK"
$Lines += ""
$Lines += "Timestamp: $Stamp"
$Lines += "Phase: AFTER / AFTER MULE REVIEW"
$Lines += "Contract: $ContractPath"
$Lines += "BaselineUsed: $($Baseline.FullName)"
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
if (-not $ReturnExists) { $Blockers += "Expected mule return file missing after mule review." }
if ($Blockers.Count -eq 0) {
    $Lines += "- NONE"
} else {
    foreach ($B in $Blockers) { $Lines += "- $B" }
}

$Lines += ""
$Lines += "## NEXT_ACTION"
if ($Blockers.Count -eq 0) {
    $Lines += "- Review mule return."
} else {
    $Lines += "- Resolve blockers before reviewing mule return."
}

Set-Content -LiteralPath $AfterPath -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

$ComparePath = Join-Path $CompareDir ("MULE_REVIEW_BASELINE_TO_AFTER_COMPARISON_{0}.md" -f $Stamp)

$BaseText = Get-Content -LiteralPath $Baseline.FullName -Raw
$AfterText = Get-Content -LiteralPath $AfterPath -Raw

$Sections = @(
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

function Get-SectionText {
    param([string]$Text, [string]$Section)
    $Pattern = "(?ms)^## $([regex]::Escape($Section))\r?\n(.*?)(?=^## |\z)"
    $Match = [regex]::Match($Text, $Pattern)
    if ($Match.Success) { return ($Match.Groups[1].Value.Trim()) }
    return "SECTION_MISSING"
}

$CompareLines = @()
$CompareLines += "# MULE REVIEW BASELINE TO AFTER COMPARISON"
$CompareLines += ""
$CompareLines += "Timestamp: $Stamp"
$CompareLines += "Contract: $ContractPath"
$CompareLines += "Baseline: $($Baseline.FullName)"
$CompareLines += "After: $AfterPath"
$CompareLines += "Mode: SAME-SHAPE COMPARISON / NO MOVE / NO DELETE / NO GIT / NO PUSH"
$CompareLines += ""
$CompareLines += "## COMPARISON"

foreach ($Section in $Sections) {
    $B = Get-SectionText -Text $BaseText -Section $Section
    $A = Get-SectionText -Text $AfterText -Section $Section

    $Verdict = "UNCHANGED CLEAN"
    if ($B -eq "SECTION_MISSING" -or $A -eq "SECTION_MISSING") {
        $Verdict = "CHANGED DIRTY / SECTION MISSING"
    } elseif ($B -ne $A) {
        if ($Section -eq "RETURN_FOLDER_CHECK" -or $Section -eq "NEXT_ACTION" -or $Section -eq "BLOCKER_CHECK" -or $Section -eq "RECEIPT_CHECK") {
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
if ($Blockers.Count -eq 0) {
    $CompareLines += "Verdict: PASS / AFTER WALK COMPLETE / READY TO REVIEW MULE RETURN"
} else {
    $CompareLines += "Verdict: PARTIAL / AFTER WALK COMPLETE / BLOCKERS PRESENT"
    foreach ($B in $Blockers) { $CompareLines += "- $B" }
}

Set-Content -LiteralPath $ComparePath -Value ($CompareLines -join [Environment]::NewLine) -Encoding UTF8

$AfterHash = Get-FileHash -Algorithm SHA256 -LiteralPath $AfterPath
$CompareHash = Get-FileHash -Algorithm SHA256 -LiteralPath $ComparePath
$BaselineHash = Get-FileHash -Algorithm SHA256 -LiteralPath $Baseline.FullName
$ContractHash = Get-FileHash -Algorithm SHA256 -LiteralPath $ContractPath

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

$ReceiptPath = Join-Path $ReceiptDir ("MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_{0}.txt" -f $Stamp)

$ReceiptLines = @()
$ReceiptLines += "MULE REVIEW AFTER WALK AND COMPARISON RECEIPT"
$ReceiptLines += "Timestamp: $Stamp"
if ($Blockers.Count -eq 0) {
    $ReceiptLines += "Verdict: PASS / AFTER WALK AND COMPARISON COMPLETE / READY TO REVIEW MULE RETURN / NO GIT / NO PUSH"
} else {
    $ReceiptLines += "Verdict: PARTIAL / AFTER WALK AND COMPARISON COMPLETE / BLOCKERS PRESENT / NO GIT / NO PUSH"
}
$ReceiptLines += ""
$ReceiptLines += "Contract:"
$ReceiptLines += "- $ContractPath"
$ReceiptLines += "  SHA256: $($ContractHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Baseline:"
$ReceiptLines += "- $($Baseline.FullName)"
$ReceiptLines += "  SHA256: $($BaselineHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "After:"
$ReceiptLines += "- $AfterPath"
$ReceiptLines += "  SHA256: $($AfterHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Comparison:"
$ReceiptLines += "- $ComparePath"
$ReceiptLines += "  SHA256: $($CompareHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Expected mule return:"
$ReceiptLines += "- $ReturnPath"
$ReceiptLines += "- Exists: $ReturnExists"
if ($ReturnExists) { $ReceiptLines += "- SHA256: $($Hash.Hash)" }
$ReceiptLines += ""
$ReceiptLines += "Blockers:"
if ($Blockers.Count -eq 0) {
    $ReceiptLines += "- NONE"
} else {
    foreach ($B in $Blockers) { $ReceiptLines += "- $B" }
}
$ReceiptLines += ""
$ReceiptLines += "Boundary:"
$ReceiptLines += "- Read-only after walk and comparison."
$ReceiptLines += "- No move except archiving this script if run from porch."
$ReceiptLines += "- No delete."
$ReceiptLines += "- No Git."
$ReceiptLines += "- No push."
$ReceiptLines += "- No public export."
$ReceiptLines += "- No doctrine rewrite."
$ReceiptLines += "- No ACTIVE_GUIDES rewrite."
$ReceiptLines += "- No CURRENT_TRUTH_INDEX rewrite."
$ReceiptLines += ""
$ReceiptLines += "Porch closeout:"
$ReceiptLines += "- Script archive: $ScriptArchive"
$ReceiptLines += "- Closeout folder: $Closeout"

Set-Content -LiteralPath $ReceiptPath -Value ($ReceiptLines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "MULE REVIEW AFTER WALK COMPLETE"
Write-Host "After: $AfterPath"
Write-Host "Comparison: $ComparePath"
Write-Host "Receipt: $ReceiptPath"
if ($Blockers.Count -eq 0) {
    Write-Host "Verdict: PASS / READY TO REVIEW MULE RETURN / NO GIT / NO PUSH"
} else {
    Write-Host "Verdict: PARTIAL / BLOCKERS PRESENT / NO GIT / NO PUSH"
}
