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
                return $Match.Groups[1].Value.Trim()
            }
            return $Match.Value.Trim()
        }
    }

    return $Default
}

function Add-Reason {
    param(
        [System.Collections.Generic.List[string]]$Reasons,
        [bool]$Condition,
        [string]$Reason
    )

    if ($Condition) {
        $Reasons.Add($Reason) | Out-Null
    }
}

if (-not (Test-Path ".git")) {
    throw "Not inside Mr.Kleen repo home."
}

Write-Host "XxXxX ===== TODO WEAKEST LINK TRIAGE READ V2 START ===== XxXxX"

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
    throw "HEAD does not match origin/main. Stop before triage."
}

if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Status is not clean. Stop before triage."
}

$TodoRoot = "HOUSE_WORK\TODO"
if (-not (Test-Path $TodoRoot)) {
    throw "TODO root missing: $TodoRoot"
}

$TodoFiles = @(Get-ChildItem -Path $TodoRoot -File -Recurse | Sort-Object @{ Expression = "LastWriteTime"; Descending = $true })
if ($TodoFiles.Count -lt 1) {
    throw "No TODO files found."
}

$Rows = @()

foreach ($File in $TodoFiles) {
    $Rel = $File.FullName.Replace((Get-Location).Path + "\", "")
    $Text = Get-Content -LiteralPath $File.FullName -Raw -Encoding UTF8

    $StatusLine = Get-FirstMatch -Text $Text -Patterns @(
        'Status:\s*([^\r\n]+)',
        '## Status\s+([^\r\n#]+)'
    ) -Default "unknown"

    $ParentBoss = Get-FirstMatch -Text $Text -Patterns @(
        'Parent Boss:\s*([^\r\n]+)',
        'Parent boss:\s*([^\r\n]+)',
        'Parent:\s*([^\r\n]+)'
    ) -Default "unlabeled"

    $Purpose = Get-FirstMatch -Text $Text -Patterns @(
        '## Purpose\s+([\s\S]{1,300}?)(?:\r?\n##|\z)',
        '## Trigger\s+([\s\S]{1,300}?)(?:\r?\n##|\z)',
        '## Problem\s+([\s\S]{1,300}?)(?:\r?\n##|\z)'
    ) -Default ""

    $Upper = $Text.ToUpperInvariant()
    $Score = 0
    $Reasons = New-Object System.Collections.Generic.List[string]

    Add-Reason $Reasons ($Upper -match 'OPEN|ACTIVE|LIVE-USE|WATCH|TRIAGE') "open/active language"
    if ($Upper -match 'OPEN|ACTIVE|LIVE-USE|WATCH|TRIAGE') { $Score += 8 }

    Add-Reason $Reasons ($Upper -match 'BLOCK|BLOCKED|BLOCKER') "blocking language"
    if ($Upper -match 'BLOCK|BLOCKED|BLOCKER') { $Score += 7 }

    Add-Reason $Reasons ($Upper -match 'FAIL|FAILURE|FALSE|DRIFT|WRONG|MUD') "failure/drift language"
    if ($Upper -match 'FAIL|FAILURE|FALSE|DRIFT|WRONG|MUD') { $Score += 6 }

    Add-Reason $Reasons ($Upper -match 'PROOF|PASS|GUARD|RECEIPT') "proof/pass risk"
    if ($Upper -match 'PROOF|PASS|GUARD|RECEIPT') { $Score += 5 }

    Add-Reason $Reasons ($Upper -match 'RULE|TRIGGER|FIRING|ACTIVATION|WORK-ORDER|CONTROL') "rule activation/control"
    if ($Upper -match 'RULE|TRIGGER|FIRING|ACTIVATION|WORK-ORDER|CONTROL') { $Score += 5 }

    Add-Reason $Reasons ($Upper -match 'ARTIFACT|POWERSHELL|CODE|COPY|PASTE|DELIVERY') "artifact/code delivery surface"
    if ($Upper -match 'ARTIFACT|POWERSHELL|CODE|COPY|PASTE|DELIVERY') { $Score += 4 }

    Add-Reason $Reasons ($Upper -match 'MULE|HANDOFF|PACKET') "mule/handoff surface"
    if ($Upper -match 'MULE|HANDOFF|PACKET') { $Score += 3 }

    Add-Reason $Reasons ($Upper -match 'FUTURE|PARKED|LATER|CANDIDATE') "parked/future language"
    if ($Upper -match 'FUTURE|PARKED|LATER|CANDIDATE') { $Score -= 3 }

    Add-Reason $Reasons ($Rel -match 'README|INDEX') "support/index file"
    if ($Rel -match 'README|INDEX') { $Score -= 8 }

    Add-Reason $Reasons ($Rel -match 'CONTROL_BOARD') "control board, not ordinary TODO"
    if ($Rel -match 'CONTROL_BOARD') { $Score -= 5 }

    $Rows += [pscustomobject]@{
        Path = $Rel
        ParentBoss = $ParentBoss
        Status = $StatusLine
        Score = $Score
        Reasons = ($Reasons -join "; ")
        Modified = $File.LastWriteTime
        Bytes = $File.Length
        Purpose = ($Purpose -replace '\s+', ' ').Trim()
    }
}

$Ranked = @($Rows | Sort-Object @{ Expression = "Score"; Descending = $true }, @{ Expression = "Modified"; Descending = $true })
$Groups = @($Rows | Group-Object ParentBoss | Sort-Object @{ Expression = "Count"; Descending = $true })

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "TODO WEAKEST LINK TRIAGE READ V2"
Write-Host "Branch: $Branch"
Write-Host "HEAD: $Head"
Write-Host "origin/main: $Origin"
Write-Host "Short: $Short"
Write-Host "Status: clean"
Write-Host ""
Write-Host "===== PARENT BOSS GROUPS ====="
foreach ($Group in $Groups) {
    Write-Host "- $($Group.Name) | items=$($Group.Count)"
}
Write-Host ""
Write-Host "===== PROOF-RANKED TODO CANDIDATES ====="
$Top = @($Ranked | Select-Object -First 12)
$Index = 1
foreach ($Row in $Top) {
    Write-Host ""
    Write-Host "[$Index] Score=$($Row.Score)"
    Write-Host "Path: $($Row.Path)"
    Write-Host "ParentBoss: $($Row.ParentBoss)"
    Write-Host "Status: $($Row.Status)"
    Write-Host "Reasons: $($Row.Reasons)"
    Write-Host "Bytes: $($Row.Bytes)"
    if (-not [string]::IsNullOrWhiteSpace($Row.Purpose)) {
        Write-Host "Purpose/Trigger: $($Row.Purpose)"
    }
    $Index += 1
}
Write-Host ""
Write-Host "===== TRIAGE RULE ====="
Write-Host "Do not hand-pick."
Write-Host "Group by parent boss, collapse child symptoms, rank biggest issue / weakest link, then work the top proof route."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
