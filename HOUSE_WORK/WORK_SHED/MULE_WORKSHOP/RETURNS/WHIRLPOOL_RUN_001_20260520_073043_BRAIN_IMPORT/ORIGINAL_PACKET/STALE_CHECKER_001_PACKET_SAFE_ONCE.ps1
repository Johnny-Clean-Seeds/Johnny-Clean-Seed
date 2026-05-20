$ErrorActionPreference = "Stop"

function Fail-Stale {
    param([string]$Message)
    $Out = Join-Path $env:MRKLEEN_WHIRLPOOL_DUMP_ONLY ("STALE_CHECK_RESULT_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")
    @"
MULE PACKET STALE CHECK
Date: $(Get-Date -Format o)
Expected HEAD: 6b9336bfa400b4f6d3c6792f4734f8f840361fd4
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

$Expected = "6b9336bfa400b4f6d3c6792f4734f8f840361fd4"
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

