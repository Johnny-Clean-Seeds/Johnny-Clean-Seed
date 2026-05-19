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

$CardPath = "PUBLIC_NOTES\ASSISTANT_HOME_MODEL_CARD_001.txt"

Write-Host ""
Write-Host "ASSISTANT HOME MODEL CARD 001 CHECK"
Write-Host ""

if (Test-Path $CardPath) {
    Pass "Card exists: $CardPath"
} else {
    Fail "Missing card: $CardPath"
}

$Needles = @(
    "The model is the base.",
    "The world is the toolbag.",
    "Use suit theory as a placement and fit judge.",
    "Treat analogy as hypothesis, not proof.",
    "Problems are learning opportunities.",
    "Housekeeping is part of the walking cycle.",
    "If an idea is not applied, capture it cleanly.",
    "Use web research, algorithms, templates, bit strings, scripts, maps, and outside methods when they fit the model.",
    "Done is not PASS.",
    "Evidence before repair.",
    "It must not outrank CURRENT_TRUTH_INDEX.",
    "It must not outrank ACTIVE_GUIDES."
)

foreach ($Needle in $Needles) {
    if (ContainsText $CardPath $Needle) {
        Pass "Card contains: $Needle"
    } else {
        Fail "Card missing: $Needle"
    }
}

if ($Failed.Count -eq 0) {
    Write-Host ""
    Write-Host "VERDICT: PASS"
    exit 0
} else {
    Write-Host ""
    Write-Host "VERDICT: FAIL"
    exit 1
}
