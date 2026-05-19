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

$Path = "PUBLIC_NOTES\BRAIN_PROGRESS_LOCK_001_20260517.txt"

Write-Host ""
Write-Host "BRAIN PROGRESS LOCK 001 CHECK"
Write-Host ""

if (Test-Path $Path) {
    Pass "Progress lock note exists"
} else {
    Fail "Missing progress lock note"
}

$Needles = @(
    "The repo home is the assistant/model brain for this build.",
    "The model is the base.",
    "The world is the toolbag.",
    "Use suit theory as a placement and fit judge.",
    "Treat analogy as hypothesis, not proof.",
    "Every mistake or leak should become a power play.",
    "Housekeeping is part of the walking cycle.",
    "Words are keys.",
    "Do not call a pointer a mirror.",
    "Future repo-home change gates should use the full closeout chain",
    "It must not outrank CURRENT_TRUTH_INDEX.txt.",
    "It must not outrank ACTIVE_GUIDES."
)

foreach ($Needle in $Needles) {
    if (ContainsText $Path $Needle) {
        Pass "Lock contains: $Needle"
    } else {
        Fail "Lock missing: $Needle"
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
