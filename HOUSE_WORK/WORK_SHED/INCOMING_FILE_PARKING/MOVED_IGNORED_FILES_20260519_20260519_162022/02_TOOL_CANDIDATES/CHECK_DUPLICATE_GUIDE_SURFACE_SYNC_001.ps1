$ErrorActionPreference = "Stop"

$RepoRoot = Get-Location

$Pairs = @(
    @{
        Root = "README_START_HERE.txt"
        Active = "ACTIVE_GUIDES\README_START_HERE.txt"
        Needles = @("ROOT POINTER", "ACTIVE_GUIDES\README_START_HERE.txt", "Not the active guide body.")
    },
    @{
        Root = "CLEAN_SEED_WRAP_GUIDE.txt"
        Active = "ACTIVE_GUIDES\CLEAN_SEED_WRAP_GUIDE.txt"
        Needles = @("ROOT POINTER", "ACTIVE_GUIDES\CLEAN_SEED_WRAP_GUIDE.txt", "Not the active guide body.")
    },
    @{
        Root = "CLEAN_SEED_ALIGNMENT_CHECK.txt"
        Active = "ACTIVE_GUIDES\CLEAN_SEED_ALIGNMENT_CHECK.txt"
        Needles = @("ROOT POINTER", "ACTIVE_GUIDES\CLEAN_SEED_ALIGNMENT_CHECK.txt", "Not the active guide body.")
    }
)

$Failed = @()

function Add-Fail {
    param([string]$Message)
    $script:Failed += $Message
    Write-Host "FAIL - $Message"
}

Write-Host ""
Write-Host "DUPLICATE GUIDE SURFACE SYNC 001 CHECK"
Write-Host "RepoRoot: $RepoRoot"
Write-Host ""

foreach ($p in $Pairs) {
    if (-not (Test-Path $p.Root)) {
        Add-Fail "Missing root pointer: $($p.Root)"
        continue
    }

    if (-not (Test-Path $p.Active)) {
        Add-Fail "Missing active guide: $($p.Active)"
        continue
    }

    $Text = Get-Content -LiteralPath $p.Root -Raw

    foreach ($Needle in $p.Needles) {
        if ($Text.Contains($Needle)) {
            Write-Host "PASS - $($p.Root) contains $Needle"
        } else {
            Add-Fail "$($p.Root) missing $Needle"
        }
    }

    $RootHash = (Get-FileHash $p.Root -Algorithm SHA256).Hash
    $ActiveHash = (Get-FileHash $p.Active -Algorithm SHA256).Hash

    if ($RootHash -ne $ActiveHash) {
        Write-Host "PASS - $($p.Root) is no longer a duplicate body"
        Write-Host "  root=$RootHash"
        Write-Host "  active=$ActiveHash"
    } else {
        Add-Fail "$($p.Root) still hash-matches active guide; expected pointer, not duplicate body."
    }
}

if (Test-Path "README.md") {
    $Readme = Get-Content "README.md" -Raw
    if ($Readme.Contains("Root guide copies are public mirror/reference copies")) {
        Write-Host "PASS - README.md still labels root guide copies"
    } else {
        Add-Fail "README.md missing root guide copy label"
    }
} else {
    Add-Fail "Missing README.md"
}

if (Test-Path "PUBLIC_HOUSE_MAP.txt") {
    $Map = Get-Content "PUBLIC_HOUSE_MAP.txt" -Raw
    if ($Map.Contains("DUPLICATE SURFACE RULE")) {
        Write-Host "PASS - PUBLIC_HOUSE_MAP.txt still contains duplicate surface rule"
    } else {
        Add-Fail "PUBLIC_HOUSE_MAP.txt missing duplicate surface rule"
    }
} else {
    Add-Fail "Missing PUBLIC_HOUSE_MAP.txt"
}

Write-Host ""

if ($Failed.Count -eq 0) {
    Write-Host "VERDICT: PASS"
    exit 0
} else {
    Write-Host "VERDICT: FAIL"
    exit 1
}
