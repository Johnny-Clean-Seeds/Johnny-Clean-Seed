$ErrorActionPreference = "Stop"

function Run-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(& git @Args 2>&1)
    if ($LASTEXITCODE -ne 0) {
        $Output | ForEach-Object { Write-Host $_ }
        throw "Git failed: git $($Args -join ' ')"
    }
    return $Output
}

function Git-Line {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(Run-Git @Args)
    if ($Output.Count -lt 1) {
        throw "Git returned no output: git $($Args -join ' ')"
    }
    return (([string]($Output | Select-Object -First 1))).Trim()
}

function Get-FirstMatch {
    param(
        [string]$Text,
        [string[]]$Patterns,
        [string]$Default = ""
    )

    foreach ($Pattern in $Patterns) {
        $Match = [regex]::Match($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($Match.Success) {
            if ($Match.Groups.Count -gt 1) {
                return ($Match.Groups[1].Value -replace '\s+', ' ').Trim()
            }
            return ($Match.Value -replace '\s+', ' ').Trim()
        }
    }

    return $Default
}

function Get-Kind {
    param([string]$Path, [string]$Text)

    $UpperPath = $Path.ToUpperInvariant()
    $UpperText = $Text.ToUpperInvariant()

    if ($UpperPath -match 'SOFT_SUITS') { return "Soft Suit" }
    if ($UpperPath -match 'GEAR_RACK|CODE_CABINET') { return "Tool / Gear" }
    if ($UpperPath -match 'BRAIN_LEARNING') { return "Rule / Learning" }
    if ($UpperPath -match 'IDEA_BAG') { return "Idea / Candidate" }
    if ($UpperPath -match 'TODO') { return "TODO / Live-use Watch" }
    if ($UpperPath -match 'SOURCE_ORE') { return "Source Ore" }
    if ($UpperText -match 'SOFT SUIT') { return "Soft Suit" }
    if ($UpperText -match 'TOOL|GEAR|CODE CABINET|SKELETON') { return "Tool / Gear" }
    if ($UpperText -match 'RULE|GATE|LATCH|GUARD') { return "Rule / Learning" }
    return "Concept / Support"
}

function Get-ProofTier {
    param([string]$Text)

    $Upper = $Text.ToUpperInvariant()

    if ($Upper -match 'PASS WITH GUARDRAILS|PASS AS|PASS:|VERDICT: PASS') { return "Proven / PASS with guardrails" }
    if ($Upper -match 'ADOPTED|LOCKED|SAVED CLEAN|HEAD EQUALS ORIGIN/MAIN|HEAD == ORIGIN/MAIN') { return "Saved / Locked" }
    if ($Upper -match 'LIVE-USE|LIVE USE|WATCH REMAINS OPEN|SECOND / VARIED') { return "Live-use / Watch" }
    if ($Upper -match 'PARKED|SOURCE-ORE|CANDIDATE|NOT READY') { return "Parked / Source ore" }
    return "Unclear / Needs review"
}

function Get-BoundaryShort {
    param([string]$Text)

    $Upper = $Text.ToUpperInvariant()
    $Bits = New-Object System.Collections.Generic.List[string]

    if ($Upper -match 'NO DOCTRINE') { $Bits.Add("no doctrine") | Out-Null }
    if ($Upper -match 'NO ACTIVE GUIDE') { $Bits.Add("no active guide rewrite") | Out-Null }
    if ($Upper -match 'NO CURRENT_TRUTH_INDEX') { $Bits.Add("no CURRENT_TRUTH_INDEX rewrite") | Out-Null }
    if ($Upper -match 'NO PROMOTION|NO CLOSURE|NO SCRIPT PROMOTION') { $Bits.Add("no promotion/closure") | Out-Null }
    if ($Upper -match 'NO DASHBOARD|NO AUTOMATION|NO RUNTIME') { $Bits.Add("no dashboard/automation/runtime") | Out-Null }

    if ($Bits.Count -eq 0) { return "boundary not obvious" }
    return ($Bits -join "; ")
}

if (-not (Test-Path ".git")) {
    throw "Not inside Mr.Kleen repo home."
}

Write-Host "XxXxX ===== PROVEN SUIT TOOL IDEA UNLOAD READ START ===== XxXxX"

Run-Git fetch origin main | Out-Null

$Branch = Git-Line branch --show-current
$Head = Git-Line rev-parse HEAD
$Origin = Git-Line rev-parse origin/main
$Short = Git-Line rev-parse --short HEAD
$Status = @(Run-Git status --short)

if ($Branch -ne "main") {
    throw "Wrong branch: $Branch"
}

if ($Head -ne $Origin) {
    throw "HEAD does not match origin/main. Stop before unload read."
}

if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Status is not clean. Stop before unload read."
}

$Roots = @(
    "HOUSE_WORK\WORK_SHED\SOFT_SUITS",
    "HOUSE_WORK\WORK_SHED\GEAR_RACK",
    "HOUSE_WORK\WORK_SHED\SORTING_BENCH",
    "HOUSE_WORK\WORK_SHED\IDEA_BAG",
    "BRAIN_LEARNING",
    "HOUSE_WORK\TODO",
    "SOURCE_ORE"
) | Where-Object { Test-Path $_ }

$Files = @()
foreach ($Root in $Roots) {
    $Files += Get-ChildItem -Path $Root -File -Recurse -Include *.md,*.txt -ErrorAction SilentlyContinue
}

$Rows = @()

foreach ($File in ($Files | Sort-Object LastWriteTime -Descending)) {
    $Rel = $File.FullName.Replace((Get-Location).Path + "\", "")
    $Text = Get-Content -LiteralPath $File.FullName -Raw -Encoding UTF8
    $Upper = $Text.ToUpperInvariant()

    $IsCandidate =
        ($Upper -match 'PASS|PASS WITH GUARDRAILS|ADOPTED|LOCKED|SAVED CLEAN|LIVE-USE|LIVE USE|SOFT SUIT|CODE CABINET|GEAR|TOOL|RULE|GATE|LATCH|GUARD|SOURCE-ORE|PARKED|CANDIDATE|PROOF|RECEIPT')

    if (-not $IsCandidate) {
        continue
    }

    $Title = Get-FirstMatch -Text $Text -Patterns @(
        '^\s*#\s+([^\r\n]+)',
        'Name:\s*([^\r\n]+)',
        'Title:\s*([^\r\n]+)'
    ) -Default $File.BaseName

    $StatusLine = Get-FirstMatch -Text $Text -Patterns @(
        'Status:\s*([^\r\n]+)',
        'Verdict:\s*([^\r\n]+)',
        'Result:\s*([^\r\n]+)'
    ) -Default "unknown"

    $Purpose = Get-FirstMatch -Text $Text -Patterns @(
        '## Purpose\s+([\s\S]{1,350}?)(?:\r?\n##|\z)',
        '## Meaning\s+([\s\S]{1,350}?)(?:\r?\n##|\z)',
        'Meaning:\s*([\s\S]{1,250}?)(?:\r?\n[A-Z][A-Za-z ]+:|\r?\n##|\z)'
    ) -Default ""

    $Kind = Get-Kind -Path $Rel -Text $Text
    $Tier = Get-ProofTier -Text $Text
    $Boundary = Get-BoundaryShort -Text $Text

    $Score = 0
    if ($Tier -eq "Proven / PASS with guardrails") { $Score += 10 }
    if ($Tier -eq "Saved / Locked") { $Score += 8 }
    if ($Tier -eq "Live-use / Watch") { $Score += 6 }
    if ($Kind -eq "Soft Suit") { $Score += 7 }
    if ($Kind -eq "Tool / Gear") { $Score += 6 }
    if ($Kind -eq "Rule / Learning") { $Score += 5 }
    if ($Kind -eq "Idea / Candidate") { $Score += 3 }
    if ($Rel -match 'RECEIPT|PROOF_HISTORY') { $Score += 4 }
    if ($Tier -eq "Parked / Source ore") { $Score -= 2 }
    if ($Rel -match 'TODO|SOURCE_ORE') { $Score -= 1 }

    $Rows += [pscustomobject]@{
        Score = $Score
        Kind = $Kind
        Tier = $Tier
        Path = $Rel
        Title = $Title
        Status = $StatusLine
        Boundary = $Boundary
        Purpose = ($Purpose -replace '\s+', ' ').Trim()
        Modified = $File.LastWriteTime
        Bytes = $File.Length
    }
}

$Ranked = @($Rows | Sort-Object @{Expression="Score";Descending=$true}, @{Expression="Modified";Descending=$true})
$ByKind = @($Rows | Group-Object Kind | Sort-Object Count -Descending)
$ByTier = @($Rows | Group-Object Tier | Sort-Object Count -Descending)

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "PROVEN SUIT / TOOL / IDEA UNLOAD READ"
Write-Host "Branch: $Branch"
Write-Host "HEAD: $Head"
Write-Host "origin/main: $Origin"
Write-Host "Short: $Short"
Write-Host "Status: clean"
Write-Host "Mode: READ ONLY"
Write-Host ""
Write-Host "===== COUNTS BY KIND ====="
foreach ($Group in $ByKind) {
    Write-Host "- $($Group.Name): $($Group.Count)"
}
Write-Host ""
Write-Host "===== COUNTS BY PROOF TIER ====="
foreach ($Group in $ByTier) {
    Write-Host "- $($Group.Name): $($Group.Count)"
}
Write-Host ""
Write-Host "===== TOP UNLOAD CANDIDATES ====="
$Index = 1
foreach ($Row in ($Ranked | Select-Object -First 30)) {
    Write-Host ""
    Write-Host "[$Index] Score=$($Row.Score)"
    Write-Host "Kind: $($Row.Kind)"
    Write-Host "Tier: $($Row.Tier)"
    Write-Host "Path: $($Row.Path)"
    Write-Host "Title: $($Row.Title)"
    Write-Host "Status: $($Row.Status)"
    Write-Host "Boundary: $($Row.Boundary)"
    if (-not [string]::IsNullOrWhiteSpace($Row.Purpose)) {
        Write-Host "Purpose/Meaning: $($Row.Purpose)"
    }
    $Index += 1
}
Write-Host ""
Write-Host "===== UNLOAD RULE ====="
Write-Host "Unload means list, group, disposition, and park/adopt/keep-watch by proof."
Write-Host "Do not promote from this read."
Write-Host "Do not close live-use watches unless closure proof is explicit."
Write-Host "Do not merge source ore into doctrine."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
