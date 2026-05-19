$ErrorActionPreference = "Stop"

$RepoRoot = Get-Location
$Failed = @()

function Fail {
    param([string]$Message)
    $script:Failed += $Message
    Write-Host "FAIL - $Message"
}

function Pass {
    param([string]$Message)
    Write-Host "PASS - $Message"
}

function ContainsText {
    param(
        [string]$Path,
        [string]$Needle
    )
    if (-not (Test-Path $Path)) { return $false }
    $Text = Get-Content -LiteralPath $Path -Raw
    return $Text.Contains($Needle)
}

Write-Host ""
Write-Host "FRESH PUBLIC ENTRY TEST 001"
Write-Host "RepoRoot: $RepoRoot"
Write-Host ""

# 1. Public front door exists.
if (Test-Path "README.md") { Pass "README.md exists as public front door" } else { Fail "Missing README.md" }

# 2. Public house map exists.
if (Test-Path "PUBLIC_HOUSE_MAP.txt") { Pass "PUBLIC_HOUSE_MAP.txt exists" } else { Fail "Missing PUBLIC_HOUSE_MAP.txt" }

# 3. Current truth index exists.
if (Test-Path "CURRENT_TRUTH_INDEX.txt") { Pass "CURRENT_TRUTH_INDEX.txt exists" } else { Fail "Missing CURRENT_TRUTH_INDEX.txt" }

# 4. Active guide packet exists.
$ActiveGuides = @(
    "ACTIVE_GUIDES\README_START_HERE.txt",
    "ACTIVE_GUIDES\CLEAN_SEED_WRAP_GUIDE.txt",
    "ACTIVE_GUIDES\CLEAN_SEED_ALIGNMENT_CHECK.txt"
)

foreach ($Guide in $ActiveGuides) {
    if (Test-Path $Guide) {
        Pass "Active guide exists: $Guide"
    } else {
        Fail "Missing active guide: $Guide"
    }
}

# 5. Root files must be pointers, not competing guide bodies.
$RootPointers = @(
    @{
        Path = "README_START_HERE.txt"
        Target = "ACTIVE_GUIDES\README_START_HERE.txt"
    },
    @{
        Path = "CLEAN_SEED_WRAP_GUIDE.txt"
        Target = "ACTIVE_GUIDES\CLEAN_SEED_WRAP_GUIDE.txt"
    },
    @{
        Path = "CLEAN_SEED_ALIGNMENT_CHECK.txt"
        Target = "ACTIVE_GUIDES\CLEAN_SEED_ALIGNMENT_CHECK.txt"
    }
)

foreach ($Pointer in $RootPointers) {
    $Path = $Pointer.Path
    $Target = $Pointer.Target

    if (-not (Test-Path $Path)) {
        Fail "Missing root pointer: $Path"
        continue
    }

    if (ContainsText $Path "ROOT POINTER") {
        Pass "$Path is labeled ROOT POINTER"
    } else {
        Fail "$Path is not labeled ROOT POINTER"
    }

    if (ContainsText $Path $Target) {
        Pass "$Path points to $Target"
    } else {
        Fail "$Path does not point to $Target"
    }

    if (ContainsText $Path "Not the active guide body.") {
        Pass "$Path says it is not the active guide body"
    } else {
        Fail "$Path missing non-authority body warning"
    }
}

# 6. README must route a fresh reader correctly.
$ReadmeNeedles = @(
    "CURRENT_TRUTH_INDEX.txt",
    "ACTIVE_GUIDES/README_START_HERE.txt",
    "ACTIVE_GUIDES/CLEAN_SEED_WRAP_GUIDE.txt",
    "ACTIVE_GUIDES/CLEAN_SEED_ALIGNMENT_CHECK.txt",
    "AGENTS.md",
    "PROOF_HISTORY/",
    "PUBLIC_NOTES/",
    "TEST_LANES/",
    "Shed/",
    "Do not promote, delete, move, overwrite, or call PASS from this home view alone."
)

foreach ($Needle in $ReadmeNeedles) {
    if (ContainsText "README.md" $Needle) {
        Pass "README.md contains: $Needle"
    } else {
        Fail "README.md missing: $Needle"
    }
}

# 7. House map must classify rooms.
$MapNeedles = @(
    "ROOT POINTER RULE",
    "Root guide files are pointer/reference surfaces.",
    "ACTIVE_GUIDES/",
    "AGENTS.md",
    "PROOF_HISTORY/",
    "PUBLIC_NOTES/",
    "TEST_LANES/",
    "Shed/",
    "Not active doctrine by itself.",
    "Not a fourth active guide",
    "Not active doctrine by volume",
    "Not active doctrine unless deliberately promoted",
    "Not active doctrine by existence"
)

foreach ($Needle in $MapNeedles) {
    if (ContainsText "PUBLIC_HOUSE_MAP.txt" $Needle) {
        Pass "PUBLIC_HOUSE_MAP.txt contains: $Needle"
    } else {
        Fail "PUBLIC_HOUSE_MAP.txt missing: $Needle"
    }
}

# 8. Fresh-entry answer synthesis.
Write-Host ""
Write-Host "FRESH ENTRY ANSWERS"
Write-Host ""
Write-Host "1. First file to check: README.md, then CURRENT_TRUTH_INDEX.txt."
Write-Host "2. Active authority packet: ACTIVE_GUIDES three-file packet."
Write-Host "3. Evidence only: PROOF_HISTORY."
Write-Host "4. Source/test lanes: PUBLIC_NOTES, TEST_LANES, Shed unless promoted."
Write-Host "5. Blocked actions: no cleanup, deletion, promotion, overwrite, or PASS from public view alone."
Write-Host "6. Cleanup can start: NO. It needs a named gate and approval."
Write-Host ""

if ($Failed.Count -eq 0) {
    Write-Host "VERDICT: PASS"
    exit 0
} else {
    Write-Host "VERDICT: FAIL"
    exit 1
}

