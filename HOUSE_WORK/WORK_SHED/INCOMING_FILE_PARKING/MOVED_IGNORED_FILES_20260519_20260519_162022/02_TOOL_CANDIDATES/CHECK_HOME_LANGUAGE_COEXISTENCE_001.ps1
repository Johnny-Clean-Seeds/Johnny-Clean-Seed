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
Write-Host "HOME LANGUAGE / CURRENT TRUTH CLARITY CHECK - CORRECTED"
Write-Host ""

$ReadmeNeedles = @(
    '# Johnny Clean Seed — Repo Home Front Door',
    'This repo home is the assistant/model brain for this build.',
    'Current working home:',
    'C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz',
    'If this home is synced with `origin/main` and the working tree is clean, this home is the current room truth.',
    'Use `home`, `house`, or `brain` when judging function and authority.',
    'Use `public` only when describing exposure, access boundary, or a named folder such as `PUBLIC_NOTES`.',
    'PUBLIC_NOTES/CURRENT_HOME_TRUTH_CLARITY_LOCK_001.txt'
)

foreach ($Needle in $ReadmeNeedles) {
    if (ContainsText 'README.md' $Needle) {
        Pass "README.md contains: $Needle"
    } else {
        Fail "README.md missing: $Needle"
    }
}

$MapNeedles = @(
    'CURRENT HOME TRUTH',
    'C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz',
    'If this home is synced with origin/main and git status is clean, this home is the current room truth.',
    'SCAN-SOURCE RULE',
    'Treat disagreeing surfaces as stale until proven current.',
    'Root guide files are pointer/reference surfaces.',
    'They are not mirror doctrine bodies.'
)

foreach ($Needle in $MapNeedles) {
    if (ContainsText 'PUBLIC_HOUSE_MAP.txt' $Needle) {
        Pass "PUBLIC_HOUSE_MAP.txt contains: $Needle"
    } else {
        Fail "PUBLIC_HOUSE_MAP.txt missing: $Needle"
    }
}

$CoexistNeedles = @(
    'Current working home:',
    'C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz',
    'A stale window does not outrank the current room.',
    'Do not let stale windows outrank synced clean home truth.',
    'It must not outrank CURRENT_TRUTH_INDEX.txt.',
    'It must not outrank ACTIVE_GUIDES.'
)

foreach ($Needle in $CoexistNeedles) {
    if (ContainsText 'PUBLIC_NOTES\HOME_LANGUAGE_COEXISTENCE_RULE_001.txt' $Needle) {
        Pass "Coexistence note contains: $Needle"
    } else {
        Fail "Coexistence note missing: $Needle"
    }
}

$ClarityNeedles = @(
    'CURRENT_HOME_TRUTH_CLARITY_LOCK_001',
    'If this home is synced with origin/main and git status is clean, this home is the current room truth.',
    'If another surface disagrees with the synced clean home, treat that surface as stale until proven current.',
    'The window is not the room.',
    'The room is the synced clean local home.',
    'It must not outrank CURRENT_TRUTH_INDEX.txt.',
    'It must not outrank ACTIVE_GUIDES.'
)

foreach ($Needle in $ClarityNeedles) {
    if (ContainsText 'PUBLIC_NOTES\CURRENT_HOME_TRUTH_CLARITY_LOCK_001.txt' $Needle) {
        Pass "Clarity lock contains: $Needle"
    } else {
        Fail "Clarity lock missing: $Needle"
    }
}

$Forbidden = @(
    @{ Path = 'README.md'; Bad = 'public GitHub repository' },
    @{ Path = 'README.md'; Bad = 'public reference house' },
    @{ Path = 'README.md'; Bad = 'Root guide copies are public mirror/reference copies' },
    @{ Path = 'PUBLIC_HOUSE_MAP.txt'; Bad = 'root mirror copies' },
    @{ Path = 'PUBLIC_HOUSE_MAP.txt'; Bad = 'Root copies are public mirrors/reference surfaces' }
)

foreach ($Item in $Forbidden) {
    if (ContainsText $Item.Path $Item.Bad) {
        Fail "$($Item.Path) contains forbidden stale/corrupt text: $($Item.Bad)"
    } else {
        Pass "$($Item.Path) does not contain forbidden stale/corrupt text: $($Item.Bad)"
    }
}

$RootPointers = @(
    'README_START_HERE.txt',
    'CLEAN_SEED_WRAP_GUIDE.txt',
    'CLEAN_SEED_ALIGNMENT_CHECK.txt'
)

foreach ($Root in $RootPointers) {
    if (ContainsText $Root 'ROOT POINTER') {
        Pass "$Root remains root pointer"
    } else {
        Fail "$Root lost ROOT POINTER label"
    }
}

$ActiveGuides = @(
    'ACTIVE_GUIDES\README_START_HERE.txt',
    'ACTIVE_GUIDES\CLEAN_SEED_WRAP_GUIDE.txt',
    'ACTIVE_GUIDES\CLEAN_SEED_ALIGNMENT_CHECK.txt'
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



