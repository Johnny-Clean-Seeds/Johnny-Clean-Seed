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

function Join-Text {
    param([object[]]$Lines)
    if ($null -eq $Lines) { return "" }
    return (($Lines | ForEach-Object { [string]$_ }) -join [Environment]::NewLine)
}

function Write-Utf8 {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][object[]]$Lines
    )

    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }

    $Text = Join-Text -Lines $Lines
    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8

    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) {
        throw ("Wrote empty file: " + $Path)
    }
    if ($Raw.Contains([char]0)) {
        throw ("NUL byte found after write: " + $Path)
    }
    if ($Raw.Contains([char]0xFFFD)) {
        throw ("Replacement character found after write: " + $Path)
    }
}

function Write-Utf8Text {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )

    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8

    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) {
        throw ("Wrote empty file: " + $Path)
    }
    if ($Raw.Contains([char]0)) {
        throw ("NUL byte found after write: " + $Path)
    }
    if ($Raw.Contains([char]0xFFFD)) {
        throw ("Replacement character found after write: " + $Path)
    }
}

function Read-FileOrNote {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    }
    return ("MISSING: " + $Path)
}

function Escape-SingleQuotedPowerShell {
    param([string]$Text)
    return ($Text -replace "'", "''")
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== LOCAL MULE BIG OVERALL JOB PACKET BUILD START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$Head = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$Short = Get-GitLine rev-parse --short HEAD
$Status = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") {
    throw ("Wrong branch: " + $Branch)
}

if ($Head -ne $Origin) {
    throw "HEAD does not match origin/main. Stop before local mule packet."
}

if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Repo is dirty. Stop before local mule packet."
}

$Required = @(
    "ACTIVE_ANCHOR.txt",
    "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md",
    "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md",
    "HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md",
    "HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md",
    "BRAIN_LEARNING\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_RULE_20260520.md",
    "BRAIN_LEARNING\NO_RULE_KING_BETTER_FIT_PROMOTION_RULE_20260520.md"
)

foreach ($Path in $Required) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw ("Required file missing: " + $Path)
    }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) {
        throw ("Required file empty: " + $Path)
    }
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BaseLocal = Join-Path $env:USERPROFILE "Desktop\MR_KLEEN_MULE_WORKSHOP_LOCAL"
$WorkshopRoot = Join-Path $BaseLocal ("BIG_OVERALL_JOB_" + $Stamp)
$JobsDir = Join-Path $WorkshopRoot "JOBS"
$StateDir = Join-Path $WorkshopRoot "STATE_SNAPSHOT"
$DumpDir = Join-Path $WorkshopRoot "MULE_OUTPUT_DUMP_ONLY"

New-Item -ItemType Directory -Path $WorkshopRoot -Force | Out-Null
New-Item -ItemType Directory -Path $JobsDir -Force | Out-Null
New-Item -ItemType Directory -Path $StateDir -Force | Out-Null
New-Item -ItemType Directory -Path $DumpDir -Force | Out-Null

$AnchorText = Read-FileOrNote "ACTIVE_ANCHOR.txt"
$StatusTail = (Get-Content -LiteralPath "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md" -Tail 180 -Encoding UTF8) -join [Environment]::NewLine
$BossGhostMap = Read-FileOrNote "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md"
$BossGhostTodo = Read-FileOrNote "HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md"
$SelectorTodo = Read-FileOrNote "HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md"
$NoRuleKing = Read-FileOrNote "BRAIN_LEARNING\NO_RULE_KING_BETTER_FIT_PROMOTION_RULE_20260520.md"
$SelectorRule = Read-FileOrNote "BRAIN_LEARNING\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_RULE_20260520.md"

$TodoOrder = (Get-ChildItem -Path "HOUSE_WORK\TODO" -File | Sort-Object LastWriteTime -Descending | Select-Object LastWriteTime,Length,Name | Format-Table -Auto | Out-String)
$RecentCommits = (Invoke-GitChecked log --oneline -12) -join [Environment]::NewLine

Write-Utf8Text -Path (Join-Path $StateDir "ACTIVE_ANCHOR.txt") -Text $AnchorText
Write-Utf8Text -Path (Join-Path $StateDir "CURRENT_HOUSE_STATUS_TAIL.txt") -Text $StatusTail
Write-Utf8Text -Path (Join-Path $StateDir "BOSS_GHOST_MAP.txt") -Text $BossGhostMap
Write-Utf8Text -Path (Join-Path $StateDir "BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO.txt") -Text $BossGhostTodo
Write-Utf8Text -Path (Join-Path $StateDir "SELECTOR_TODO.txt") -Text $SelectorTodo
Write-Utf8Text -Path (Join-Path $StateDir "NO_RULE_KING_RULE.txt") -Text $NoRuleKing
Write-Utf8Text -Path (Join-Path $StateDir "RELEVANT_SELECTOR_RULE.txt") -Text $SelectorRule
Write-Utf8Text -Path (Join-Path $StateDir "TODO_ORDER.txt") -Text $TodoOrder
Write-Utf8Text -Path (Join-Path $StateDir "RECENT_COMMITS.txt") -Text $RecentCommits

$RepoEsc = Escape-SingleQuotedPowerShell $Repo
$HeadEsc = Escape-SingleQuotedPowerShell $Head
$DumpEsc = Escape-SingleQuotedPowerShell $DumpDir

$StaleChecker = @"
`$ErrorActionPreference = "Stop"

function Invoke-GitChecked {
    param([Parameter(ValueFromRemainingArguments = `$true)][string[]]`$Args)
    `$Output = @(& git @Args 2>&1)
    if (`$LASTEXITCODE -ne 0) {
        `$Output | ForEach-Object { Write-Host `$_ }
        throw ("Git failed: git " + (`$Args -join " "))
    }
    return `$Output
}

function Get-GitLine {
    param([Parameter(ValueFromRemainingArguments = `$true)][string[]]`$Args)
    `$Output = @(Invoke-GitChecked @Args)
    if (`$Output.Count -lt 1) {
        throw ("Git returned no output: git " + (`$Args -join " "))
    }
    return ([string](`$Output | Select-Object -First 1)).Trim()
}

`$ExpectedRepo = '$RepoEsc'
`$ExpectedHead = '$HeadEsc'
`$DumpDir = '$DumpEsc'
`$ResultPath = Join-Path `$DumpDir ("STALE_CHECK_RESULT_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")

Set-Location `$ExpectedRepo

Invoke-GitChecked fetch origin main | Out-Null

`$Branch = Get-GitLine branch --show-current
`$Head = Get-GitLine rev-parse HEAD
`$Origin = Get-GitLine rev-parse origin/main
`$Status = @(Invoke-GitChecked status --short)

`$Problems = New-Object System.Collections.Generic.List[string]

if (`$Branch -ne "main") { `$Problems.Add("branch is not main: " + `$Branch) | Out-Null }
if (`$Head -ne `$Origin) { `$Problems.Add("HEAD does not equal origin/main") | Out-Null }
if (`$Head -ne `$ExpectedHead) { `$Problems.Add("packet stale: current HEAD differs from packet base") | Out-Null }
if (`$Status.Count -ne 0) { `$Problems.Add("repo dirty") | Out-Null }

`$Required = @(
    "ACTIVE_ANCHOR.txt",
    "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md",
    "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md",
    "HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md",
    "HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md"
)

foreach (`$Path in `$Required) {
    if (-not (Test-Path -LiteralPath `$Path)) {
        `$Problems.Add("missing required file: " + `$Path) | Out-Null
    } else {
        `$Raw = Get-Content -LiteralPath `$Path -Raw -Encoding UTF8
        if ([string]::IsNullOrWhiteSpace(`$Raw)) {
            `$Problems.Add("empty required file: " + `$Path) | Out-Null
        }
    }
}

`$Lines = New-Object System.Collections.Generic.List[string]
`$Lines.Add("MULE PACKET STALE CHECK") | Out-Null
`$Lines.Add("Date: " + (Get-Date).ToString("s")) | Out-Null
`$Lines.Add("Expected HEAD: " + `$ExpectedHead) | Out-Null
`$Lines.Add("Current HEAD: " + `$Head) | Out-Null
`$Lines.Add("origin/main: " + `$Origin) | Out-Null
`$Lines.Add("Branch: " + `$Branch) | Out-Null
`$Lines.Add("") | Out-Null

if (`$Problems.Count -eq 0) {
    `$Lines.Add("RESULT: PASS - packet matches current clean repo state") | Out-Null
} else {
    `$Lines.Add("RESULT: STALE/BLOCKED") | Out-Null
    `$Lines.Add("") | Out-Null
    foreach (`$Problem in `$Problems) {
        `$Lines.Add("- " + `$Problem) | Out-Null
    }
}

`$Lines.Add("") | Out-Null
`$Lines.Add("Rule: If stale/blocked, mule must stop and request a fresh packet. Do not continue from stale context.") | Out-Null

Set-Content -LiteralPath `$ResultPath -Value (`$Lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "STALE CHECK RESULT:"
Get-Content -LiteralPath `$ResultPath -Raw -Encoding UTF8
"@

Write-Utf8Text -Path (Join-Path $WorkshopRoot "STALE_CHECKER_001.ps1") -Text $StaleChecker

$RunChecker = @(
    '$ErrorActionPreference = "Stop"',
    '$Here = Split-Path -Parent $MyInvocation.MyCommand.Path',
    '& (Join-Path $Here "STALE_CHECKER_001.ps1")'
)
Write-Utf8 -Path (Join-Path $WorkshopRoot "RUN_STALE_CHECKER_FROM_HERE.ps1") -Lines $RunChecker

$ReadFirst = @(
    "# MULE READ FIRST - Big Overall Local Job Packet",
    "",
    "Date: 2026-05-20",
    "Packet base repo: " + $Repo,
    "Packet base HEAD: " + $Head,
    "Packet base short: " + $Short,
    "",
    "## Role",
    "",
    "You are a mule / outside worker.",
    "",
    "You are allowed to do real review work across the house, but you are not allowed to directly edit the repo, commit, push, rewrite doctrine, rewrite active guides, rewrite CURRENT_TRUTH_INDEX, create automation, create dashboards, create runtime, or promote tools/suits/rules.",
    "",
    "Your output must go only inside this packet's output dump folder:",
    "",
    $DumpDir,
    "",
    "## First Action",
    "",
    "Run STALE_CHECKER_001.ps1.",
    "",
    "If it reports STALE/BLOCKED, stop and write only STALE_BLOCKED_REPORT.md in the dump folder.",
    "",
    "If it passes, proceed through the jobs in manifest order.",
    "",
    "## Core Situation",
    "",
    "The house has been doing a lot of support-rule work. The user is worried about drift and circular meta-work.",
    "",
    "The job is to help move back toward real work while protecting the useful support machinery.",
    "",
    "## Output Contract",
    "",
    "Every output file must include:",
    "",
    "- packet base HEAD;",
    "- whether stale checker passed;",
    "- files read;",
    "- finding;",
    "- recommendation;",
    "- proof needed;",
    "- boundary;",
    "- whether the recommendation should be applied, adapted, parked, rejected, or needs proof.",
    "",
    "No direct repo edits."
)
Write-Utf8 -Path (Join-Path $WorkshopRoot "MULE_READ_FIRST.md") -Lines $ReadFirst

$OutputContract = @(
    "# Mule Output Contract",
    "",
    "All mule outputs go in:",
    "",
    $DumpDir,
    "",
    "Required return files:",
    "",
    "1. MANIFEST_RETURN.md",
    "2. EXECUTIVE_SUMMARY.md",
    "3. DISPOSITION_MATRIX.md",
    "4. STALE_CHECK_RESULT copy or summary",
    "5. One output file per completed job",
    "6. NEXT_ACTION_RECOMMENDATION.md",
    "",
    "The mule must not directly change repo files.",
    "",
    "The mule may propose exact files to create/update, but those proposals must remain in the dump folder until the assistant/user intakes them.",
    "",
    "Return disposition values:",
    "",
    "- APPLY",
    "- ADAPT",
    "- PARK",
    "- REJECT",
    "- NEEDS PROOF",
    "- STALE/BLOCKED"
)
Write-Utf8 -Path (Join-Path $WorkshopRoot "OUTPUT_CONTRACT.md") -Lines $OutputContract

$Manifest = @(
    "# Mule Big Overall Job Packet Manifest",
    "",
    "Date: 2026-05-20",
    "Base HEAD: " + $Head,
    "Base short: " + $Short,
    "Repo: " + $Repo,
    "",
    "## Required Order",
    "",
    "0. Run STALE_CHECKER_001.ps1.",
    "1. Read MULE_READ_FIRST.md.",
    "2. Read OUTPUT_CONTRACT.md.",
    "3. Read STATE_SNAPSHOT files.",
    "4. Complete jobs in JOBS folder in numeric order.",
    "5. Write all outputs only to MULE_OUTPUT_DUMP_ONLY.",
    "",
    "## Jobs",
    "",
    "- JOB_00_STALE_CHECKER_AND_PACKET_METHOD_REVIEW.md",
    "- JOB_01_WHOLE_HOUSE_DRIFT_AND_META_LOOP_AUDIT.md",
    "- JOB_02_REAL_WORK_QUEUE_TOP_10.md",
    "- JOB_03_TODO_ROOM_BOSS_GHOST_COLLAPSE.md",
    "- JOB_04_TOOL_SUIT_RULE_LIFECYCLE_AUDIT.md",
    "- JOB_05_MULE_WORKSHOP_CONTRACT_UPGRADE.md",
    "- JOB_06_RECEIPT_AND_STALE_PROOF_HYGIENE.md",
    "- JOB_07_BIG_OVERALL_RECOMMENDATION.md",
    "",
    "## Hard Boundaries",
    "",
    "- Local packet only.",
    "- No repo edits.",
    "- No commits.",
    "- No doctrine.",
    "- No active guide rewrite.",
    "- No CURRENT_TRUTH_INDEX rewrite.",
    "- No dashboard/automation/runtime/knowledge graph/full lesson index.",
    "- No promotion.",
    "- Output proposals only."
)
Write-Utf8 -Path (Join-Path $WorkshopRoot "MANIFEST.md") -Lines $Manifest

$Job00 = @(
    "# JOB 00 - Stale Checker And Packet Method Review",
    "",
    "Mission: Review this packet method and stale checker. If the method is outdated, propose a better local-only packet/stale-check workflow.",
    "",
    "Read:",
    "- STALE_CHECKER_001.ps1",
    "- RUN_STALE_CHECKER_FROM_HERE.ps1",
    "- MULE_READ_FIRST.md",
    "- OUTPUT_CONTRACT.md",
    "- STATE_SNAPSHOT files",
    "",
    "Questions:",
    "- Does the stale checker catch wrong HEAD, dirty repo, missing required files, and stale packet state?",
    "- What stale conditions are missing?",
    "- Should this become a reusable local mule packet skeleton later?",
    "- What is the smallest safe improvement?",
    "",
    "Output:",
    "MULE_OUTPUT_DUMP_ONLY\JOB_00_STALE_CHECKER_REVIEW.md",
    "",
    "Optional candidate output:",
    "MULE_OUTPUT_DUMP_ONLY\STALE_CHECKER_002_CANDIDATE.ps1",
    "",
    "Boundary:",
    "Do not edit repo files. Do not promote checker."
)
Write-Utf8 -Path (Join-Path $JobsDir "JOB_00_STALE_CHECKER_AND_PACKET_METHOD_REVIEW.md") -Lines $Job00

$Job01 = @(
    "# JOB 01 - Whole House Drift And Meta-Loop Audit",
    "",
    "Mission: Determine whether the house is drifting into support-rule/meta-work loops instead of real work.",
    "",
    "Read:",
    "- STATE_SNAPSHOT\ACTIVE_ANCHOR.txt",
    "- STATE_SNAPSHOT\CURRENT_HOUSE_STATUS_TAIL.txt",
    "- STATE_SNAPSHOT\TODO_ORDER.txt",
    "- STATE_SNAPSHOT\BOSS_GHOST_MAP.txt",
    "",
    "Questions:",
    "- Which current items are real work?",
    "- Which current items are support machinery?",
    "- Which watches should stay open but not drive the work?",
    "- Which moves would create another meta-loop?",
    "- What stop condition should prevent rule-on-rule whirlpool?",
    "",
    "Output:",
    "MULE_OUTPUT_DUMP_ONLY\JOB_01_WHOLE_HOUSE_DRIFT_AND_META_LOOP_AUDIT.md"
)
Write-Utf8 -Path (Join-Path $JobsDir "JOB_01_WHOLE_HOUSE_DRIFT_AND_META_LOOP_AUDIT.md") -Lines $Job01

$Job02 = @(
    "# JOB 02 - Real Work Queue Top 10",
    "",
    "Mission: Build a proof-ranked top 10 real-work queue from current house state.",
    "",
    "Real work means a move that changes capability, closes a real seam, proves a working loop, or clears a blocker.",
    "",
    "Do not rank by newest TODO. Do not rank by loudest file. Do not rank support rules as real work unless they block action.",
    "",
    "For each candidate:",
    "- parent boss;",
    "- why real work;",
    "- proof needed;",
    "- first read target;",
    "- stop condition;",
    "- likely save/no-save decision;",
    "- risk of meta-loop.",
    "",
    "Output:",
    "MULE_OUTPUT_DUMP_ONLY\JOB_02_REAL_WORK_QUEUE_TOP_10.md"
)
Write-Utf8 -Path (Join-Path $JobsDir "JOB_02_REAL_WORK_QUEUE_TOP_10.md") -Lines $Job02

$Job03 = @(
    "# JOB 03 - TODO Room Boss/Ghost Collapse",
    "",
    "Mission: Inspect current TODO room and collapse ghosts under parent bosses.",
    "",
    "Read:",
    "- STATE_SNAPSHOT\TODO_ORDER.txt",
    "- STATE_SNAPSHOT\BOSS_GHOST_MAP.txt",
    "- repo TODO files as needed, read-only",
    "",
    "Output a matrix:",
    "- TODO file;",
    "- parent boss;",
    "- state: blocker / watch / support / parked / duplicate / stale / needs proof;",
    "- keep, merge, park, close-candidate, or read-next;",
    "- reason;",
    "- proof required before any change.",
    "",
    "Output:",
    "MULE_OUTPUT_DUMP_ONLY\JOB_03_TODO_ROOM_BOSS_GHOST_COLLAPSE.md"
)
Write-Utf8 -Path (Join-Path $JobsDir "JOB_03_TODO_ROOM_BOSS_GHOST_COLLAPSE.md") -Lines $Job03

$Job04 = @(
    "# JOB 04 - Tool Suit Rule Lifecycle Audit",
    "",
    "Mission: Audit the current tool/suit/rule lifecycle state without promoting anything.",
    "",
    "Use the unload map logic:",
    "- keep active support;",
    "- proven/watch;",
    "- saved reference;",
    "- live-use watch;",
    "- parked/source ore;",
    "- review before use;",
    "- reject/quarantine candidate.",
    "",
    "Questions:",
    "- Which items are doing real work now?",
    "- Which items are watches only?",
    "- Which items look stale or duplicate?",
    "- Which items need a future promotion review?",
    "- Which items should be blocked from promotion because they are bloat?",
    "",
    "Output:",
    "MULE_OUTPUT_DUMP_ONLY\JOB_04_TOOL_SUIT_RULE_LIFECYCLE_AUDIT.md"
)
Write-Utf8 -Path (Join-Path $JobsDir "JOB_04_TOOL_SUIT_RULE_LIFECYCLE_AUDIT.md") -Lines $Job04

$Job05 = @(
    "# JOB 05 - Mule Workshop Contract Upgrade",
    "",
    "Mission: Improve the mule workshop process itself if the current way is old/outdated.",
    "",
    "Design a reusable local-only mule contract:",
    "- specific dump folder;",
    "- ordered manifest;",
    "- stale checker before work;",
    "- no direct repo edits;",
    "- no commits;",
    "- per-file disposition matrix;",
    "- output contract;",
    "- return intake gate;",
    "- stop if stale.",
    "",
    "Output:",
    "MULE_OUTPUT_DUMP_ONLY\JOB_05_MULE_WORKSHOP_CONTRACT_UPGRADE.md",
    "",
    "Optional candidate:",
    "MULE_OUTPUT_DUMP_ONLY\MULE_WORKSHOP_CONTRACT_V2_CANDIDATE.md"
)
Write-Utf8 -Path (Join-Path $JobsDir "JOB_05_MULE_WORKSHOP_CONTRACT_UPGRADE.md") -Lines $Job05

$Job06 = @(
    "# JOB 06 - Receipt And Stale Proof Hygiene",
    "",
    "Mission: Inspect whether receipts/proofs are at risk of stale, overbroad, or claim-mismatched use.",
    "",
    "Questions:",
    "- Which current receipts are claim-scoped and safe?",
    "- Which receipts should not be used globally?",
    "- Which current claims need fresh proof?",
    "- Where could stale proof cause a false PASS?",
    "- What stale-check rules should assistant enforce before using old outputs?",
    "",
    "Output:",
    "MULE_OUTPUT_DUMP_ONLY\JOB_06_RECEIPT_AND_STALE_PROOF_HYGIENE.md"
)
Write-Utf8 -Path (Join-Path $JobsDir "JOB_06_RECEIPT_AND_STALE_PROOF_HYGIENE.md") -Lines $Job06

$Job07 = @(
    "# JOB 07 - Big Overall Recommendation",
    "",
    "Mission: After completing the other jobs, give one consolidated recommendation.",
    "",
    "Must include:",
    "- stale checker result;",
    "- top 3 real next moves;",
    "- what to stop doing;",
    "- what to keep as support only;",
    "- what the mule should do next, if anything;",
    "- what the assistant should do next;",
    "- exact first read target;",
    "- exact first save target only if save is justified;",
    "- risks and stop conditions.",
    "",
    "Output:",
    "MULE_OUTPUT_DUMP_ONLY\JOB_07_BIG_OVERALL_RECOMMENDATION.md",
    "MULE_OUTPUT_DUMP_ONLY\NEXT_ACTION_RECOMMENDATION.md"
)
Write-Utf8 -Path (Join-Path $JobsDir "JOB_07_BIG_OVERALL_RECOMMENDATION.md") -Lines $Job07

$ReturnManifestTemplate = @(
    "# RETURN MANIFEST TEMPLATE",
    "",
    "Packet base HEAD: " + $Head,
    "Stale checker result: PASS / STALE-BLOCKED",
    "",
    "## Files Returned",
    "",
    "| File | Job | Disposition | Notes |",
    "|---|---|---|---|",
    "| JOB_00_STALE_CHECKER_REVIEW.md | 00 |  |  |",
    "| JOB_01_WHOLE_HOUSE_DRIFT_AND_META_LOOP_AUDIT.md | 01 |  |  |",
    "| JOB_02_REAL_WORK_QUEUE_TOP_10.md | 02 |  |  |",
    "| JOB_03_TODO_ROOM_BOSS_GHOST_COLLAPSE.md | 03 |  |  |",
    "| JOB_04_TOOL_SUIT_RULE_LIFECYCLE_AUDIT.md | 04 |  |  |",
    "| JOB_05_MULE_WORKSHOP_CONTRACT_UPGRADE.md | 05 |  |  |",
    "| JOB_06_RECEIPT_AND_STALE_PROOF_HYGIENE.md | 06 |  |  |",
    "| JOB_07_BIG_OVERALL_RECOMMENDATION.md | 07 |  |  |",
    "| NEXT_ACTION_RECOMMENDATION.md | final |  |  |"
)
Write-Utf8 -Path (Join-Path $DumpDir "RETURN_MANIFEST_TEMPLATE.md") -Lines $ReturnManifestTemplate

$ReadmeDump = @(
    "# MULE OUTPUT DUMP ONLY",
    "",
    "All mule outputs go here.",
    "",
    "Do not edit repo files.",
    "",
    "Do not commit.",
    "",
    "Do not write outside this dump folder unless the user/assistant explicitly creates a new packet."
)
Write-Utf8 -Path (Join-Path $DumpDir "README_OUTPUT_DUMP_ONLY.md") -Lines $ReadmeDump

$FinalStatus = @(Invoke-GitChecked status --short)
if ($FinalStatus.Count -ne 0) {
    Write-Host "Repo dirty after local packet build:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Local packet should not dirty repo. Stop."
}

$PacketFiles = Get-ChildItem -LiteralPath $WorkshopRoot -File -Recurse
$ManifestHashLines = $PacketFiles | Sort-Object FullName | ForEach-Object {
    $Rel = $_.FullName.Replace($WorkshopRoot + "\", "")
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash
    "- " + $Rel + " | bytes=" + $_.Length + " | sha256=" + $Hash
}

Write-Utf8 -Path (Join-Path $WorkshopRoot "PACKET_FILE_HASHES.txt") -Lines $ManifestHashLines

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "LOCAL MULE BIG OVERALL JOB PACKET BUILT"
Write-Host ("Repo: " + $Repo)
Write-Host ("Base HEAD: " + $Head)
Write-Host ("Base short: " + $Short)
Write-Host "Repo status after build: clean"
Write-Host ("Workshop: " + $WorkshopRoot)
Write-Host ("Jobs: " + $JobsDir)
Write-Host ("Output dump only: " + $DumpDir)
Write-Host ("Stale checker: " + (Join-Path $WorkshopRoot "STALE_CHECKER_001.ps1"))
Write-Host ("Run checker: " + (Join-Path $WorkshopRoot "RUN_STALE_CHECKER_FROM_HERE.ps1"))
Write-Host "Jobs created: 8"
Write-Host "Boundary: local-only packet; no repo edits; no commit; no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; mule output only to dump folder"
Write-Host "Next move: give the Workshop folder to the mule; mule must run stale checker first and return outputs only in MULE_OUTPUT_DUMP_ONLY"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
