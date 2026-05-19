$ErrorActionPreference = "Stop"

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
Write-Host "PUBLIC FORMAT AND WORD KEYS 001 CHECK"
Write-Host ""

$ReadmeNeedles = @(
    "# Johnny Clean Seed",
    "## Start here",
    "## Authority map",
    "## Public/local boundary",
    "## Word-key support",
    "Root guide files are public pointer/reference files",
    "Do not promote, delete, move, overwrite, or call PASS from this public view alone.",
    "PUBLIC_NOTES/WORD_KEYS_AND_PUBLIC_LANGUAGE_NOTES_001.txt"
)

foreach ($Needle in $ReadmeNeedles) {
    if (ContainsText "README.md" $Needle) {
        Pass "README.md contains: $Needle"
    } else {
        Fail "README.md missing: $Needle"
    }
}

$MapNeedles = @(
    "WHAT THIS FILE IS",
    "WHAT THIS FILE IS NOT",
    "ROOT POINTER RULE",
    "WORD-KEY RULE",
    "Root guide files are public pointer/reference surfaces.",
    "They are not mirror doctrine bodies.",
    "Word-key support exists without replacing ACTIVE_GUIDES.",
    "The word-key note becomes a hidden override."
)

foreach ($Needle in $MapNeedles) {
    if (ContainsText "PUBLIC_HOUSE_MAP.txt" $Needle) {
        Pass "PUBLIC_HOUSE_MAP.txt contains: $Needle"
    } else {
        Fail "PUBLIC_HOUSE_MAP.txt missing: $Needle"
    }
}

$WordCard = "PUBLIC_NOTES\WORD_KEYS_AND_PUBLIC_LANGUAGE_NOTES_001.txt"

$WordNeedles = @(
    "Words are keys.",
    "Use the word that matches the role.",
    "Do not call a pointer a mirror.",
    "ACTIVE GUIDE",
    "POINTER",
    "REFERENCE",
    "EVIDENCE",
    "SOURCE-ORE",
    "TEST LANE",
    "PUBLIC NOTE",
    "PASS",
    "YIELD",
    "MIRROR",
    "PARKING",
    "Treat analogy as hypothesis, not proof.",
    "It must not outrank CURRENT_TRUTH_INDEX.txt.",
    "It must not outrank ACTIVE_GUIDES."
)

foreach ($Needle in $WordNeedles) {
    if (ContainsText $WordCard $Needle) {
        Pass "WORD CARD contains: $Needle"
    } else {
        Fail "WORD CARD missing: $Needle"
    }
}

$RootPointers = @(
    "README_START_HERE.txt",
    "CLEAN_SEED_WRAP_GUIDE.txt",
    "CLEAN_SEED_ALIGNMENT_CHECK.txt"
)

foreach ($Root in $RootPointers) {
    if (ContainsText $Root "ROOT POINTER") {
        Pass "$Root remains root pointer"
    } else {
        Fail "$Root lost ROOT POINTER label"
    }
}

$ActiveGuides = @(
    "ACTIVE_GUIDES\README_START_HERE.txt",
    "ACTIVE_GUIDES\CLEAN_SEED_WRAP_GUIDE.txt",
    "ACTIVE_GUIDES\CLEAN_SEED_ALIGNMENT_CHECK.txt"
)

foreach ($Guide in $ActiveGuides) {
    if (Test-Path $Guide) {
        Pass "Active guide still exists: $Guide"
    } else {
        Fail "Missing active guide: $Guide"
    }
}

Write-Host ""

if ($Failed.Count -eq 0) {
    Write-Host "VERDICT: PASS"
    exit 0
} else {
    Write-Host "VERDICT: FAIL"
    exit 1
}
