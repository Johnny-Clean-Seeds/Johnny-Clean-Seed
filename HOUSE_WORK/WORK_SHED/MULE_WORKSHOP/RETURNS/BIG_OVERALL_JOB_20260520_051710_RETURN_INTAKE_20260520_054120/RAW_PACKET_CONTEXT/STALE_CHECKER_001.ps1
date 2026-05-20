$ErrorActionPreference = "Stop"

function Invoke-GitChecked {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(& git @Args 2>&1)
    if ($LASTEXITCODE -ne 0) {
        $Output | ForEach-Object { Write-Host $_ }
        throw ("Git failed: git " + ($Args -join " "))
    }
    return $Output
}

function Get-GitLine {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(Invoke-GitChecked @Args)
    if ($Output.Count -lt 1) {
        throw ("Git returned no output: git " + ($Args -join " "))
    }
    return ([string]($Output | Select-Object -First 1)).Trim()
}

$ExpectedRepo = 'C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz'
$ExpectedHead = 'e9bc566bb432817f266e6604595172f5e95afb21'
$DumpDir = 'C:\Users\13527\Desktop\MR_KLEEN_MULE_WORKSHOP_LOCAL\BIG_OVERALL_JOB_20260520_051710\MULE_OUTPUT_DUMP_ONLY'
$ResultPath = Join-Path $DumpDir ("STALE_CHECK_RESULT_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")

Set-Location $ExpectedRepo

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$Head = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$Status = @(Invoke-GitChecked status --short)

$Problems = New-Object System.Collections.Generic.List[string]

if ($Branch -ne "main") { $Problems.Add("branch is not main: " + $Branch) | Out-Null }
if ($Head -ne $Origin) { $Problems.Add("HEAD does not equal origin/main") | Out-Null }
if ($Head -ne $ExpectedHead) { $Problems.Add("packet stale: current HEAD differs from packet base") | Out-Null }
if ($Status.Count -ne 0) { $Problems.Add("repo dirty") | Out-Null }

$Required = @(
    "ACTIVE_ANCHOR.txt",
    "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md",
    "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md",
    "HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md",
    "HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md"
)

foreach ($Path in $Required) {
    if (-not (Test-Path -LiteralPath $Path)) {
        $Problems.Add("missing required file: " + $Path) | Out-Null
    } else {
        $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
        if ([string]::IsNullOrWhiteSpace($Raw)) {
            $Problems.Add("empty required file: " + $Path) | Out-Null
        }
    }
}

$Lines = New-Object System.Collections.Generic.List[string]
$Lines.Add("MULE PACKET STALE CHECK") | Out-Null
$Lines.Add("Date: " + (Get-Date).ToString("s")) | Out-Null
$Lines.Add("Expected HEAD: " + $ExpectedHead) | Out-Null
$Lines.Add("Current HEAD: " + $Head) | Out-Null
$Lines.Add("origin/main: " + $Origin) | Out-Null
$Lines.Add("Branch: " + $Branch) | Out-Null
$Lines.Add("") | Out-Null

if ($Problems.Count -eq 0) {
    $Lines.Add("RESULT: PASS - packet matches current clean repo state") | Out-Null
} else {
    $Lines.Add("RESULT: STALE/BLOCKED") | Out-Null
    $Lines.Add("") | Out-Null
    foreach ($Problem in $Problems) {
        $Lines.Add("- " + $Problem) | Out-Null
    }
}

$Lines.Add("") | Out-Null
$Lines.Add("Rule: If stale/blocked, mule must stop and request a fresh packet. Do not continue from stale context.") | Out-Null

Set-Content -LiteralPath $ResultPath -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "STALE CHECK RESULT:"
Get-Content -LiteralPath $ResultPath -Raw -Encoding UTF8
