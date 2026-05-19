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
Write-Host "REPEATED FAILED-PROOF CONTAINMENT INVESTIGATION 001 CHECK"
Write-Host ""

$Investigation = "PUBLIC_NOTES\REPEATED_FAILED_PROOF_CONTAINMENT_INVESTIGATION_001.txt"
$Template = "PUBLIC_NOTES\FULL_GATE_PATTERN_WITH_FAIL_CONTAINMENT_001.txt"

$InvestigationNeedles = @(
    "This is a pattern investigation.",
    "A repeated mistake becomes a system signal.",
    "The proof gate and the movement gate were not physically bound together strongly enough.",
    "A checker failure did not always stop the whole lane.",
    "The checker needed a companion.",
    "The companion is containment.",
    "Do not overreact by rewriting active doctrine.",
    "Do investigate repeated same-lane failure.",
    "If proof fails:",
    "Do not commit.",
    "Do not push.",
    "It must not outrank CURRENT_TRUTH_INDEX.txt.",
    "It must not outrank ACTIVE_GUIDES."
)

foreach ($Needle in $InvestigationNeedles) {
    if (ContainsText $Investigation $Needle) {
        Pass "Investigation contains: $Needle"
    } else {
        Fail "Investigation missing: $Needle"
    }
}

$TemplateNeedles = @(
    "Proof controls movement.",
    "Commit and push must sit behind proof.",
    "If proof FAILS:",
    "exit before git add.",
    "If proof PASSES:",
    "Every failed gate should teach the next gate.",
    "Do not repair one lane by violating another.",
    "Do not fix a support note by rewriting ACTIVE_GUIDES without a named authority gate.",
    "It does not outrank CURRENT_TRUTH_INDEX.txt.",
    "It does not outrank ACTIVE_GUIDES."
)

foreach ($Needle in $TemplateNeedles) {
    if (ContainsText $Template $Needle) {
        Pass "Template contains: $Needle"
    } else {
        Fail "Template missing: $Needle"
    }
}

if (Test-Path "ACTIVE_GUIDES\README_START_HERE.txt") {
    Pass "Active guide remains present"
} else {
    Fail "Missing active guide"
}

Write-Host ""

if ($Failed.Count -eq 0) {
    Write-Host "VERDICT: PASS"
    exit 0
} else {
    Write-Host "VERDICT: FAIL"
    exit 1
}
