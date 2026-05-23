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
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Wrote empty file: " + $Path) }
    if ($Raw.Contains([char]0)) { throw ("NUL byte found after write: " + $Path) }
    if ($Raw.Contains([char]0xFFFD)) { throw ("Replacement character found after write: " + $Path) }
}

function Copy-TextSnapshot {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Dest
    )
    if (Test-Path -LiteralPath $Source) {
        $Raw = Get-Content -LiteralPath $Source -Raw -Encoding UTF8
        Write-Utf8Text -Path $Dest -Text $Raw
    } else {
        Write-Utf8Text -Path $Dest -Text ("MISSING SNAPSHOT SOURCE: " + $Source)
    }
}

function Assert-Needle {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle
    )
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if (-not $Raw.Contains($Needle)) {
        throw ("Verification needle missing in " + $Path + ": " + $Needle)
    }
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== WHIRLPOOL MULE RUN 001 PACKET BUILD START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$Head = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$Short = Get-GitLine rev-parse --short HEAD
$Status = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") { throw ("Wrong branch: " + $Branch) }
if ($Head -ne $Origin) { throw "HEAD does not match origin/main. Stop before packet build." }
if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Repo is dirty. Stop before packet build."
}

$ExpectedBase = "6b9336bfa400b4f6d3c6792f4734f8f840361fd4"
if ($Head -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $Head + ". Stop and reassess before sending mule.")
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$WorkshopRoot = Join-Path $env:USERPROFILE "Desktop\MR_KLEEN_MULE_WORKSHOP_LOCAL"
$PacketRoot = Join-Path $WorkshopRoot ("WHIRLPOOL_RUN_001_" + $Stamp)
$Jobs = Join-Path $PacketRoot "JOBS"
$Snapshot = Join-Path $PacketRoot "STATE_SNAPSHOT"
$Dump = Join-Path $PacketRoot "MULE_OUTPUT_DUMP_ONLY"

New-Item -ItemType Directory -Path $Jobs,$Snapshot,$Dump -Force | Out-Null

$ReadFirst = @"
# MULE READ FIRST - Whirlpool Run 001

Packet date: 2026-05-20
Packet base HEAD:
$Head

Repo:
$Repo

Mission:
Run one bounded full mule pass to test the Whirlpool work rhythm.

Whirlpool meaning for this packet:
- fix only the proven leak;
- park healthy support;
- avoid hammering one lane because more could be done;
- rotate to the next real seam only after proof;
- keep outside-worker output as support evidence, not command authority.

## Required first action

Run:

.\RUN_STALE_CHECKER_FROM_HERE.ps1

If stale check fails, stop immediately.

## Hard boundaries

- Local packet only.
- Do not edit repo files.
- Do not stage files.
- Do not commit.
- Do not push.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not promote tools, suits, rules, maps, watches, or mule outputs.
- Write outputs only into MULE_OUTPUT_DUMP_ONLY.

## Authority order

Use the state snapshot as frozen packet evidence only.

ACTIVE_ANCHOR and current user command own active work.

Mule output is recommendation/support evidence only.

## Output discipline

Every job output must include:
- Evidence;
- Inference;
- Recommendation;
- Disposition: APPLY / ADAPT / PARK / REJECT / NEEDS PROOF;
- Proof needed;
- Boundary.
"@

$OutputContract = @"
# OUTPUT CONTRACT - Whirlpool Run 001

Write all output only to:

MULE_OUTPUT_DUMP_ONLY

Required outputs:

1. STALE_CHECK_RESULT timestamped text file from stale checker.
2. STALE_CHECK_RESULT_SUMMARY.md
3. EXECUTIVE_SUMMARY.md
4. DISPOSITION_MATRIX.md
5. JOB_00_WHIRLPOOL_RHYTHM_AUDIT.md
6. JOB_01_CURRENT_STATE_AND_ANCHOR_CHECK.md
7. JOB_02_NEXT_THREE_RUN_PLAN.md
8. JOB_03_TOP_SEAMS_AND_STOP_CONDITIONS.md
9. JOB_04_MULE_BATCH_RISK_REVIEW.md
10. JOB_05_EXACT_NEXT_ACTION_RECOMMENDATION.md
11. MANIFEST_RETURN.md
12. NEXT_ACTION_RECOMMENDATION.md

No repo edits.

No adoption.

No promotion.
"@

$Manifest = @"
# Whirlpool Mule Run 001 Packet Manifest

Date: 2026-05-20
Base HEAD:
$Head
Base short:
$Short
Repo:
$Repo

## Required order

0. Run STALE_CHECKER_001.ps1 through RUN_STALE_CHECKER_FROM_HERE.ps1.
1. Read MULE_READ_FIRST.md.
2. Read OUTPUT_CONTRACT.md.
3. Read STATE_SNAPSHOT files.
4. Complete jobs in JOBS folder in numeric order.
5. Write outputs only to MULE_OUTPUT_DUMP_ONLY.

## Jobs

- JOB_00_WHIRLPOOL_RHYTHM_AUDIT.md
- JOB_01_CURRENT_STATE_AND_ANCHOR_CHECK.md
- JOB_02_NEXT_THREE_RUN_PLAN.md
- JOB_03_TOP_SEAMS_AND_STOP_CONDITIONS.md
- JOB_04_MULE_BATCH_RISK_REVIEW.md
- JOB_05_EXACT_NEXT_ACTION_RECOMMENDATION.md

## Hard boundaries

- Local packet only.
- No repo edits.
- No commits.
- No pushes.
- No doctrine.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No dashboard/automation/runtime/knowledge graph/full lesson index.
- No promotion.
- Output proposals only.
"@

$StaleChecker = @'
$ErrorActionPreference = "Stop"

function Fail-Stale {
    param([string]$Message)
    $Out = Join-Path "MULE_OUTPUT_DUMP_ONLY" ("STALE_CHECK_RESULT_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")
    @"
MULE PACKET STALE CHECK
Date: $(Get-Date -Format o)
Expected HEAD: __EXPECTED_HEAD__
Current HEAD: $CurrentHead
origin/main: $OriginHead
Branch: $Branch

RESULT: STALE/BLOCKED

$Message

Rule: If stale/blocked, mule must stop and request a fresh packet. Do not continue from stale context.
"@ | Set-Content -LiteralPath $Out -Encoding UTF8
    throw $Message
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Run this from the repo root recorded in the packet, not from inside the packet folder."
}

git fetch origin main | Out-Null

$Expected = "__EXPECTED_HEAD__"
$Branch = (git branch --show-current).Trim()
$CurrentHead = (git rev-parse HEAD).Trim()
$OriginHead = (git rev-parse origin/main).Trim()
$Status = @(git status --short)

if ($Branch -ne "main") { Fail-Stale "wrong branch: $Branch" }
if ($CurrentHead -ne $OriginHead) { Fail-Stale "HEAD does not match origin/main" }
if ($CurrentHead -ne $Expected) { Fail-Stale "packet stale: current HEAD differs from packet base" }
if ($Status.Count -ne 0) { Fail-Stale "repo dirty before mule run" }

$RequiredRepoFiles = @(
    "ACTIVE_ANCHOR.txt",
    "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md",
    "HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md",
    "HOUSE_WORK\TODO\TODO_INDEX_20260518.md",
    "HOUSE_WORK\TODO\TODO_TRACE_TRIAGE_GATE_20260518.md"
)

foreach ($Path in $RequiredRepoFiles) {
    if (-not (Test-Path -LiteralPath $Path)) { Fail-Stale "required repo file missing: $Path" }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { Fail-Stale "required repo file empty: $Path" }
}

$PacketRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $PacketRoot "PACKET_FILE_HASHES.txt"))) { Fail-Stale "PACKET_FILE_HASHES.txt missing" }

$HashLines = Get-Content -LiteralPath (Join-Path $PacketRoot "PACKET_FILE_HASHES.txt") -Encoding UTF8 | Where-Object { $_ -match " \| " }
foreach ($Line in $HashLines) {
    $Parts = $Line -split " \| ", 2
    $Rel = $Parts[0]
    $ExpectedHash = $Parts[1]
    $Path = Join-Path $PacketRoot $Rel
    if (-not (Test-Path -LiteralPath $Path)) { Fail-Stale "packet file missing: $Rel" }
    $Actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    if ($Actual -ne $ExpectedHash) { Fail-Stale "packet file hash mismatch: $Rel" }
}

$Out = Join-Path $PacketRoot "MULE_OUTPUT_DUMP_ONLY"
if (-not (Test-Path -LiteralPath $Out)) { New-Item -ItemType Directory -Path $Out -Force | Out-Null }

$Latest = Join-Path $Out "STALE_CHECK_RESULT_LATEST.txt"
$Timestamped = Join-Path $Out ("STALE_CHECK_RESULT_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")

$Text = @"
MULE PACKET STALE CHECK
Date: $(Get-Date -Format o)
Expected HEAD: $Expected
Current HEAD: $CurrentHead
origin/main: $OriginHead
Branch: $Branch

RESULT: PASS - packet matches current clean repo state

Rule: If stale/blocked, mule must stop and request a fresh packet. Do not continue from stale context.
"@

$Text | Set-Content -LiteralPath $Latest -Encoding UTF8
$Text | Set-Content -LiteralPath $Timestamped -Encoding UTF8

Write-Host $Text
'@.Replace("__EXPECTED_HEAD__", $Head)

$RunStale = @'
$ErrorActionPreference = "Stop"
$PacketRoot = Split-Path -Parent $PSScriptRoot
$RepoFile = Join-Path $PacketRoot "REPO_ROOT.txt"
if (-not (Test-Path -LiteralPath $RepoFile)) { throw "REPO_ROOT.txt missing" }
$Repo = (Get-Content -LiteralPath $RepoFile -Raw -Encoding UTF8).Trim()
if (-not (Test-Path -LiteralPath $Repo)) { throw "Repo path missing: $Repo" }
Push-Location $Repo
try {
    & (Join-Path $PacketRoot "STALE_CHECKER_001.ps1")
}
finally {
    Pop-Location
}
'@

$Job00 = @"
# JOB 00 - Whirlpool Rhythm Audit

Mission:
Judge whether the house is now using Whirlpool rhythm cleanly.

Read:
- STATE_SNAPSHOT\ACTIVE_ANCHOR.txt
- STATE_SNAPSHOT\CURRENT_STATUS_TAIL.txt
- STATE_SNAPSHOT\TODO_CONTROL_BOARD.txt
- STATE_SNAPSHOT\TODO_INDEX.txt
- STATE_SNAPSHOT\TODO_TRACE_TRIAGE_GATE.txt
- STATE_SNAPSHOT\RECENT_COMMITS.txt

Questions:
1. What evidence shows Whirlpool behavior is already happening?
2. What evidence shows possible fake Whirlpool / support-rule whirlpool?
3. Which lanes are healthy enough to park?
4. Which lanes still leak and need proof-ranked next action?
5. What should stop immediately?

Output:
MULE_OUTPUT_DUMP_ONLY\JOB_00_WHIRLPOOL_RHYTHM_AUDIT.md
"@

$Job01 = @"
# JOB 01 - Current State And Anchor Check

Mission:
Read the current anchor/status snapshot and judge the real current route state.

Must include:
- current active ball;
- last completed move;
- blocked moves;
- support-only items;
- open watches;
- whether any old support surface still appears to compete with ACTIVE_ANCHOR.

Output:
MULE_OUTPUT_DUMP_ONLY\JOB_01_CURRENT_STATE_AND_ANCHOR_CHECK.md
"@

$Job02 = @"
# JOB 02 - Next Three Run Plan

Mission:
Design the controlled three-run mule phase, but do not start it.

The user wants:
1. one full run;
2. then three runs;
3. then inspect what we are dealing with.

Your job:
- propose what each of the next 3 mule packets should test;
- keep each bounded;
- define what proves PASS / PARTIAL / FAIL;
- define stop conditions;
- define what must be intaken before the next run starts;
- define whether the 3 runs should be sequential or parallel.

Hard rule:
Do not recommend running 3 until Run 001 is intaken/dispositioned.

Output:
MULE_OUTPUT_DUMP_ONLY\JOB_02_NEXT_THREE_RUN_PLAN.md
"@

$Job03 = @"
# JOB 03 - Top Seams And Stop Conditions

Mission:
Name the top seams the house should inspect next after this first Whirlpool mule run.

Use current evidence, not newest-file pressure.

Must include:
- top 5 seams;
- parent boss family;
- why each seam matters;
- proof needed;
- whether to apply/adapt/park/reject/needs-proof;
- stop condition for each seam.

Output:
MULE_OUTPUT_DUMP_ONLY\JOB_03_TOP_SEAMS_AND_STOP_CONDITIONS.md
"@

$Job04 = @"
# JOB 04 - Mule Batch Risk Review

Mission:
Audit the risk of running 3 mule passes after this one.

Look for:
- stale context risk;
- duplicate-work risk;
- support-rule whirlpool risk;
- command-authority confusion;
- intake burden;
- proof-history clutter;
- batch vs sequential decision.

Must output a clear recommendation:
- run 3 sequentially;
- run 3 parallel;
- run fewer;
- do not run 3 yet.

Output:
MULE_OUTPUT_DUMP_ONLY\JOB_04_MULE_BATCH_RISK_REVIEW.md
"@

$Job05 = @"
# JOB 05 - Exact Next Action Recommendation

Mission:
Give the assistant and user one exact next action after this packet returns.

Must include:
- exact first read target for intake;
- whether a save is justified by mule output alone;
- what to do if stale;
- what to do if partial;
- what to do if the mule recommends another mule pass;
- exact boundary.

Output:
MULE_OUTPUT_DUMP_ONLY\JOB_05_EXACT_NEXT_ACTION_RECOMMENDATION.md
MULE_OUTPUT_DUMP_ONLY\NEXT_ACTION_RECOMMENDATION.md
"@

Write-Utf8Text -Path (Join-Path $PacketRoot "MULE_READ_FIRST.md") -Text $ReadFirst
Write-Utf8Text -Path (Join-Path $PacketRoot "OUTPUT_CONTRACT.md") -Text $OutputContract
Write-Utf8Text -Path (Join-Path $PacketRoot "MANIFEST.md") -Text $Manifest
Write-Utf8Text -Path (Join-Path $PacketRoot "REPO_ROOT.txt") -Text $Repo
Write-Utf8Text -Path (Join-Path $PacketRoot "STALE_CHECKER_001.ps1") -Text $StaleChecker
Write-Utf8Text -Path (Join-Path $PacketRoot "RUN_STALE_CHECKER_FROM_HERE.ps1") -Text $RunStale

Write-Utf8Text -Path (Join-Path $Jobs "JOB_00_WHIRLPOOL_RHYTHM_AUDIT.md") -Text $Job00
Write-Utf8Text -Path (Join-Path $Jobs "JOB_01_CURRENT_STATE_AND_ANCHOR_CHECK.md") -Text $Job01
Write-Utf8Text -Path (Join-Path $Jobs "JOB_02_NEXT_THREE_RUN_PLAN.md") -Text $Job02
Write-Utf8Text -Path (Join-Path $Jobs "JOB_03_TOP_SEAMS_AND_STOP_CONDITIONS.md") -Text $Job03
Write-Utf8Text -Path (Join-Path $Jobs "JOB_04_MULE_BATCH_RISK_REVIEW.md") -Text $Job04
Write-Utf8Text -Path (Join-Path $Jobs "JOB_05_EXACT_NEXT_ACTION_RECOMMENDATION.md") -Text $Job05

Copy-TextSnapshot -Source "ACTIVE_ANCHOR.txt" -Dest (Join-Path $Snapshot "ACTIVE_ANCHOR.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md" -Dest (Join-Path $Snapshot "CURRENT_HOUSE_WORK_STATUS.md")
Copy-TextSnapshot -Source "HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md" -Dest (Join-Path $Snapshot "TODO_CONTROL_BOARD.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\TODO\TODO_INDEX_20260518.md" -Dest (Join-Path $Snapshot "TODO_INDEX.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\TODO\TODO_TRACE_TRIAGE_GATE_20260518.md" -Dest (Join-Path $Snapshot "TODO_TRACE_TRIAGE_GATE.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\WORK_SHED\SORTING_BENCH\TODO_CONTROL_SURFACE_STALE_HEADING_REPAIR_20260520.md" -Dest (Join-Path $Snapshot "LAST_TODO_SURFACE_REPAIR_PROOF.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\WORK_SHED\SORTING_BENCH\MULE_RETURN_BIG_OVERALL_FULL_DISPOSITION_20260520.md" -Dest (Join-Path $Snapshot "LAST_MULE_RETURN_DISPOSITION_PROOF.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RELEVANT_ROOT_KEY_SELECTOR_VARIED_LIVE_USE_PROOF_20260520.md" -Dest (Join-Path $Snapshot "RELEVANT_SELECTOR_VARIED_PROOF.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\WORK_SHED\SORTING_BENCH\NO_RULE_KING_GUARD_DURING_SELECTOR_ROUTE_PROOF_20260520.md" -Dest (Join-Path $Snapshot "NO_RULE_KING_SELECTOR_ROUTE_PROOF.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RULE_FIRING_CONFIRMATION_CARD_FIRST_LIVE_USE_PROOF_20260520.md" -Dest (Join-Path $Snapshot "RULE_FIRING_CARD_FIRST_LIVE_USE_PROOF.txt")
Copy-TextSnapshot -Source "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RULE_CONCEPT_EVENT_REPORT_GATE_PARTIAL_LIVE_USE_PROOF_20260520.md" -Dest (Join-Path $Snapshot "RCE_REPORT_GATE_PARTIAL_PROOF.txt")

$StatusTail = (Get-Content -LiteralPath "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md" -Tail 220 -Encoding UTF8) -join [Environment]::NewLine
Write-Utf8Text -Path (Join-Path $Snapshot "CURRENT_STATUS_TAIL.txt") -Text $StatusTail

$RecentCommits = (Invoke-GitChecked log --oneline -12) -join [Environment]::NewLine
Write-Utf8Text -Path (Join-Path $Snapshot "RECENT_COMMITS.txt") -Text $RecentCommits

$FileList = Get-ChildItem -LiteralPath $PacketRoot -Recurse -File |
    Where-Object { $_.FullName -notlike (Join-Path $Dump "*") -and $_.Name -ne "PACKET_FILE_HASHES.txt" } |
    Sort-Object FullName

$HashRows = New-Object System.Collections.Generic.List[string]
foreach ($File in $FileList) {
    $Rel = [System.IO.Path]::GetRelativePath($PacketRoot, $File.FullName)
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $File.FullName).Hash
    $HashRows.Add($Rel + " | " + $Hash) | Out-Null
}
Write-Utf8Text -Path (Join-Path $PacketRoot "PACKET_FILE_HASHES.txt") -Text (($HashRows -join [Environment]::NewLine) + [Environment]::NewLine)

$ReturnTemplate = @"
# RETURN MANIFEST TEMPLATE - Whirlpool Run 001

Packet base HEAD:
$Head

Stale checker result:
PASS / STALE-BLOCKED

## Files Returned

| File | Job | Disposition | Notes |
|---|---|---|---|
| STALE_CHECK_RESULT_SUMMARY.md | stale |  |  |
| EXECUTIVE_SUMMARY.md | summary |  |  |
| DISPOSITION_MATRIX.md | summary |  |  |
| JOB_00_WHIRLPOOL_RHYTHM_AUDIT.md | 00 |  |  |
| JOB_01_CURRENT_STATE_AND_ANCHOR_CHECK.md | 01 |  |  |
| JOB_02_NEXT_THREE_RUN_PLAN.md | 02 |  |  |
| JOB_03_TOP_SEAMS_AND_STOP_CONDITIONS.md | 03 |  |  |
| JOB_04_MULE_BATCH_RISK_REVIEW.md | 04 |  |  |
| JOB_05_EXACT_NEXT_ACTION_RECOMMENDATION.md | 05 |  |  |
| NEXT_ACTION_RECOMMENDATION.md | final |  |  |

Boundary:
No repo files edited. No staging, commit, push, doctrine install, active guide rewrite, CURRENT_TRUTH_INDEX rewrite, dashboard, automation, runtime, knowledge graph, full lesson index, tool promotion, suit promotion, or rule promotion.
"@

Write-Utf8Text -Path (Join-Path $Dump "RETURN_MANIFEST_TEMPLATE.md") -Text $ReturnTemplate
Write-Utf8Text -Path (Join-Path $Dump "README_OUTPUT_DUMP_ONLY.md") -Text "All mule outputs go here. Do not edit repo files. Do not commit. Do not write outside this dump folder."

Assert-Needle -Path (Join-Path $PacketRoot "MULE_READ_FIRST.md") -Needle "Whirlpool Run 001"
Assert-Needle -Path (Join-Path $PacketRoot "OUTPUT_CONTRACT.md") -Needle "NEXT_ACTION_RECOMMENDATION.md"
Assert-Needle -Path (Join-Path $PacketRoot "PACKET_FILE_HASHES.txt") -Needle "MULE_READ_FIRST.md |"
Assert-Needle -Path (Join-Path $Jobs "JOB_02_NEXT_THREE_RUN_PLAN.md") -Needle "Do not recommend running 3 until Run 001 is intaken/dispositioned"
Assert-Needle -Path (Join-Path $Snapshot "ACTIVE_ANCHOR.txt") -Needle "Rule-Firing Confirmation Card"

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "WHIRLPOOL MULE RUN 001 PACKET BUILT"
Write-Host ("Packet: " + $PacketRoot)
Write-Host ("Base HEAD: " + $Head)
Write-Host ("Base short: " + $Short)
Write-Host "Repo status: clean"
Write-Host ""
Write-Host "Send this folder to the mule:"
Write-Host $PacketRoot
Write-Host ""
Write-Host "Mule first action:"
Write-Host ".\RUN_STALE_CHECKER_FROM_HERE.ps1"
Write-Host ""
Write-Host "Return dump folder:"
Write-Host $Dump
Write-Host ""
Write-Host "Boundary:"
Write-Host "- Local packet only."
Write-Host "- No repo edits."
Write-Host "- No commit or push."
Write-Host "- Output only to MULE_OUTPUT_DUMP_ONLY."
Write-Host "- Do not run the 3-pack phase until Run 001 is intaken/dispositioned."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
