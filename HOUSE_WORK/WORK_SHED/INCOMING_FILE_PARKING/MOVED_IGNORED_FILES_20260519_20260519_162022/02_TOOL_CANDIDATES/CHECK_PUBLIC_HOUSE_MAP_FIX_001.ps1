$ErrorActionPreference = "Stop"

$RepoRoot = Get-Location

function Test-Contains {
    param(
        [string]$Path,
        [string]$Needle
    )
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $txt = Get-Content -LiteralPath $Path -Raw
    return $txt.Contains($Needle)
}

$Results = @()

function Add-Check {
    param(
        [string]$Level,
        [string]$Name,
        [bool]$Pass,
        [string]$Detail
    )
    $script:Results += [pscustomobject]@{
        Level = $Level
        Check = $Name
        Pass = $Pass
        Detail = $Detail
    }
}

Add-Check "REQUIRED" "README.md exists" (Test-Path "README.md") "README.md"
Add-Check "REQUIRED" "PUBLIC_HOUSE_MAP.txt exists" (Test-Path "PUBLIC_HOUSE_MAP.txt") "PUBLIC_HOUSE_MAP.txt"
Add-Check "REQUIRED" "Proof report exists" (Test-Path "PROOF_HISTORY\PUBLIC_HOUSE_MAP_WEAK_LINK_SCAN_001_20260517.txt") "PROOF_HISTORY\PUBLIC_HOUSE_MAP_WEAK_LINK_SCAN_001_20260517.txt"

foreach ($Needle in @(
    "CURRENT_TRUTH_INDEX.txt",
    "ACTIVE_GUIDES/",
    "AGENTS.md",
    "PROOF_HISTORY/",
    "PUBLIC_NOTES/",
    "TEST_LANES/",
    "Shed/",
    "Root guide files are pointer/reference surfaces."
)) {
    Add-Check "REQUIRED" "README contains $Needle" (Test-Contains "README.md" $Needle) $Needle
}

foreach ($Needle in @(
    "DUPLICATE SURFACE RULE",
    "PROOF_HISTORY/",
    "PUBLIC_NOTES/",
    "TEST_LANES/",
    "Shed/",
    "Not a fourth active guide",
    "No deletion, move, cleanup, or broad proof-history reshuffle"
)) {
    Add-Check "REQUIRED" "PUBLIC_HOUSE_MAP contains $Needle" (Test-Contains "PUBLIC_HOUSE_MAP.txt" $Needle) $Needle
}

$GuidePairs = @(
    @("README_START_HERE.txt", "ACTIVE_GUIDES\README_START_HERE.txt"),
    @("CLEAN_SEED_WRAP_GUIDE.txt", "ACTIVE_GUIDES\CLEAN_SEED_WRAP_GUIDE.txt"),
    @("CLEAN_SEED_ALIGNMENT_CHECK.txt", "ACTIVE_GUIDES\CLEAN_SEED_ALIGNMENT_CHECK.txt")
)

foreach ($Pair in $GuidePairs) {
    $RootFile = $Pair[0]
    $ActiveFile = $Pair[1]
    $BothExist = (Test-Path $RootFile) -and (Test-Path $ActiveFile)

    if ($BothExist) {
        $RootHash = (Get-FileHash $RootFile -Algorithm SHA256).Hash
        $ActiveHash = (Get-FileHash $ActiveFile -Algorithm SHA256).Hash
        $Match = ($RootHash -eq $ActiveHash)

        if ($Match) {
            Add-Check "INFO" "Duplicate guide hash match: $RootFile" $true "root=$RootHash active=$ActiveHash"
        } else {
            Add-Check "WARN" "Duplicate guide hash mismatch confirmed: $RootFile" $true "root=$RootHash active=$ActiveHash ; guarded by README.md and PUBLIC_HOUSE_MAP.txt"
        }
    } else {
        Add-Check "WARN" "Duplicate guide pair not both present: $RootFile" $true "Missing root or active copy; router still defines ACTIVE_GUIDES as authority."
    }
}

Write-Host ""
Write-Host "PUBLIC HOUSE MAP FIX CHECK"
Write-Host "RepoRoot: $RepoRoot"
Write-Host ""

$Failed = @()
$Warnings = @()

foreach ($R in $Results) {
    if ($R.Level -eq "WARN") {
        Write-Host "WARN - $($R.Check)"
        $Warnings += $R
    } elseif ($R.Pass) {
        Write-Host "PASS - $($R.Check)"
    } else {
        Write-Host "FAIL - $($R.Check)"
        $Failed += $R
    }
    Write-Host "  $($R.Detail)"
}

Write-Host ""

if ($Failed.Count -eq 0 -and $Warnings.Count -eq 0) {
    Write-Host "VERDICT: PASS"
    exit 0
} elseif ($Failed.Count -eq 0 -and $Warnings.Count -gt 0) {
    Write-Host "VERDICT: PASS WITH GUARDRAILS"
    exit 0
} else {
    Write-Host "VERDICT: FAIL"
    exit 1
}

