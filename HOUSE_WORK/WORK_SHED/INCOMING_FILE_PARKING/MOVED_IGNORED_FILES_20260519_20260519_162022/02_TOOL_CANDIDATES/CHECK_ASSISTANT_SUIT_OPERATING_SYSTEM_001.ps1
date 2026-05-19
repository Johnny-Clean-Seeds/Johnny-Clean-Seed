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
Write-Host "ASSISTANT SUIT OPERATING SYSTEM 001 CHECK"
Write-Host ""

$Note = "PUBLIC_NOTES\ASSISTANT_SUIT_OPERATING_SYSTEM_001.txt"

$Needles = @(
    'The assistant should wear it.',
    'This note is not active doctrine.',
    'It must not outrank CURRENT_TRUTH_INDEX.txt.',
    'It must not outrank ACTIVE_GUIDES.',
    'The assistant may shape work only when the shaping fits the model.',
    'What room is this in?',
    'What neighboring lane could be harmed by a bad repair?',
    'Is the assistant wearing the suit, or just talking about it?',
    'When an issue is resolved, the assistant must not walk away after symptom repair.',
    'A resolved issue must pay rent.',
    'After a failure, repeated issue, checker mismatch, command leak, stale surface conflict, or user correction:',
    'Every meaningful issue should strengthen at least one of:',
    'If the same issue appears three times, or a connected pattern appears, treat it as system evidence.',
    'Proof controls movement.',
    'Commit and push must sit behind proof.',
    'A failed checker is a stop sign, not a speed bump.',
    'Do not repair content when the checker is the failed part.',
    'A checker must not scan itself for a forbidden phrase that it stores inside itself unless it excludes its own rule table or uses a safe encoded/literal strategy.',
    'Words are keys.',
    'Do not repair from a stale window.',
    'Chat alone is not lock/save.',
    'Do not fix one room by damaging another.',
    'The assistant should wear the suit.'
)

foreach ($Needle in $Needles) {
    if (ContainsText $Note $Needle) {
        Pass "Suit note contains: $Needle"
    } else {
        Fail "Suit note missing: $Needle"
    }
}

if (Test-Path "ACTIVE_GUIDES\README_START_HERE.txt") {
    Pass "Active guide present"
} else {
    Fail "Missing active guide"
}

if (Test-Path "ACTIVE_GUIDES\CLEAN_SEED_WRAP_GUIDE.txt") {
    Pass "Wrap guide present"
} else {
    Fail "Missing wrap guide"
}

if (Test-Path "ACTIVE_GUIDES\CLEAN_SEED_ALIGNMENT_CHECK.txt") {
    Pass "Alignment guide present"
} else {
    Fail "Missing alignment guide"
}

Write-Host ""

if ($Failed.Count -eq 0) {
    Write-Host "VERDICT: PASS"
    exit 0
} else {
    Write-Host "VERDICT: FAIL"
    exit 1
}
