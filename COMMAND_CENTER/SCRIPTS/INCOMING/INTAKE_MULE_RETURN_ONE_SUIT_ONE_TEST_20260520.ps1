# INTAKE_MULE_RETURN_ONE_SUIT_ONE_TEST_20260520.ps1
# Run this inside Mr.Kleen repo home.
# Purpose: raw intake of mule return files only. No adoption. No doctrine. No guide rewrite.

$ErrorActionPreference = "Stop"

trap {
    Write-Host "MULE RETURN INTAKE FAIL"
    Write-Host $_.Exception.Message
    exit 1
}

function Invoke-GitChecked {
    param([Parameter(Mandatory = $true)][string[]]$GitArgs)
    $Output = & git @GitArgs 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "git $($GitArgs -join ' ') failed:`n$($Output -join "`n")"
    }
    return $Output
}

function Write-Utf8FileSafe {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )
    $Dir = Split-Path $Path
    if (-not [string]::IsNullOrWhiteSpace($Dir)) {
        New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    }
    Set-Content -Path $Path -Value $Text -Encoding UTF8
}

if (-not (Test-Path ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen shell first."
}

$Inside = ((Invoke-GitChecked @("rev-parse", "--is-inside-work-tree")) -join "").Trim()
if ($Inside -ne "true") {
    throw "Git says this is not a work tree."
}

$BranchBefore = ((Invoke-GitChecked @("branch", "--show-current")) -join "").Trim()
$HeadBefore = ((Invoke-GitChecked @("rev-parse", "HEAD")) -join "").Trim()

$PreStatus = Invoke-GitChecked @("status", "--short")
if ($PreStatus.Count -gt 0) {
    throw "Working tree is not clean before mule return intake. Stop and inspect git status."
}

Invoke-GitChecked @("fetch", "origin", "main") | Out-Null
$OriginBefore = ((Invoke-GitChecked @("rev-parse", "origin/main")) -join "").Trim()
if ($HeadBefore -ne $OriginBefore) {
    throw "HEAD does not match origin/main. Stop before intake."
}

$Desktop = [Environment]::GetFolderPath("Desktop")
$DefaultReturnFolderName = "RECURRING_NON_RECURSIVE_FAILURE_MULE_RETURN_20260520_001"

$CandidateFolders = @(
    (Join-Path $Desktop $DefaultReturnFolderName),
    (Join-Path $Desktop "MULE_RETURN"),
    (Join-Path $Desktop "mule_return")
) | Where-Object { Test-Path $_ }

if ($CandidateFolders.Count -eq 0) {
    Write-Host "Could not find a return folder automatically."
    Write-Host "Expected one of:"
    Write-Host "  $DefaultReturnFolderName"
    Write-Host "  MULE_RETURN"
    Write-Host "  mule_return"
    Write-Host "on Desktop:"
    Write-Host "  $Desktop"
    throw "Mule return folder not found on Desktop."
}

$SourceReturn = $CandidateFolders | Select-Object -First 1

$Required = @(
    "MANIFEST.md",
    "FAILURE_PATTERN_REPORT.md",
    "EVIDENCE_MATRIX.md",
    "RECURSIVE_LINK_BREAK_DIAGNOSIS.md",
    "FIX_CANDIDATES_DISPOSITION.md",
    "NEXT_ACTION_RECOMMENDATION.md"
)

$Missing = @()
foreach ($File in $Required) {
    $Path = Join-Path $SourceReturn $File
    if (-not (Test-Path $Path)) {
        $Missing += $File
    }
}

if ($Missing.Count -gt 0) {
    throw "Missing required mule return files:`n$($Missing -join "`n")"
}

$DestDir = "HOUSE_WORK\WORK_SHED\AGENT_OUTPUTS\RECURRING_NON_RECURSIVE_FAILURE_MULE_RETURN_20260520_001"
New-Item -ItemType Directory -Force -Path $DestDir | Out-Null

$HashLines = @()
foreach ($File in $Required) {
    $Src = Join-Path $SourceReturn $File
    $Dst = Join-Path $DestDir $File
    Copy-Item -Path $Src -Destination $Dst -Force
    $Hash = (Get-FileHash -Algorithm SHA256 -Path $Dst).Hash
    $Len = (Get-Item $Dst).Length
    $HashLines += "- $File"
    $HashLines += "  Source: $Src"
    $HashLines += "  Dest: $Dst"
    $HashLines += "  Bytes: $Len"
    $HashLines += "  SHA256: $Hash"
}

$IntakeNotePath = Join-Path $DestDir "INTAKE_NOTE.md"
$IntakeNote = @"
# Intake Note — Recurring Non-Recursive Failure Mule Return

Date: 2026-05-20
Status: RAW RETURN INTAKE ONLY
Authority: not adopted; not doctrine; not active guide; not TODO installation

## Source

Desktop source folder:
$SourceReturn

## Meaning

The mule return was copied into the Mr.Kleen build for review and disposition.

This intake does not adopt mule recommendations.

Next allowed action:
Read the return files, then disposition each recommendation as accept, adapt, park, block, or needs-proof.

Blocked:
- no doctrine rewrite by intake;
- no active guide rewrite by intake;
- no CURRENT_TRUTH_INDEX rewrite by intake;
- no dashboard, automation, knowledge graph, runtime, or full lesson index;
- no rule install until disposition.
"@
Write-Utf8FileSafe -Path $IntakeNotePath -Text $IntakeNote
$IntakeHash = (Get-FileHash -Algorithm SHA256 -Path $IntakeNotePath).Hash
$HashLines += "- INTAKE_NOTE.md"
$HashLines += "  Dest: $IntakeNotePath"
$HashLines += "  SHA256: $IntakeHash"

$ReceiptPath = "PROOF_HISTORY\RECURRING_NON_RECURSIVE_FAILURE_MULE_RETURN_INTAKE_RECEIPT_20260520.txt"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$AnchorText = @"
ACTIVE BALL: Recurring Non-Recursive Failure mule return intaken raw.

BASE BEFORE INTAKE: main @ $($HeadBefore.Substring(0,7))

CURRENT PROVEN ITEMS:
- Mule return files copied into $DestDir.
- Intake is raw only; no adoption yet.
- Next move is read/disposition: accept, adapt, park, block, needs-proof.

NEXT ALLOWED MOVE:
- Read MANIFEST.md first.
- Then read FAILURE_PATTERN_REPORT.md, EVIDENCE_MATRIX.md, RECURSIVE_LINK_BREAK_DIAGNOSIS.md, FIX_CANDIDATES_DISPOSITION.md, NEXT_ACTION_RECOMMENDATION.md.
- Build smallest save package only after disposition.

BLOCKED:
- Do not install mule recommendations by intake.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not build dashboard, automation, knowledge graph, runtime, or full lesson index.
"@
Write-Utf8FileSafe -Path $AnchorPath -Text $AnchorText

$StatusText = Get-Content -Path $StatusPath -Raw
$StatusAdd = @"

## Recurring Non-Recursive Failure Mule Return Intake

Status: RAW INTAKE SAVED
Date: 2026-05-20
Base before intake: main @ $($HeadBefore.Substring(0,7))

Source:
- $SourceReturn

Saved:
- $DestDir\MANIFEST.md
- $DestDir\FAILURE_PATTERN_REPORT.md
- $DestDir\EVIDENCE_MATRIX.md
- $DestDir\RECURSIVE_LINK_BREAK_DIAGNOSIS.md
- $DestDir\FIX_CANDIDATES_DISPOSITION.md
- $DestDir\NEXT_ACTION_RECOMMENDATION.md
- $DestDir\INTAKE_NOTE.md
- $ReceiptPath

Updated:
- $AnchorPath
- $StatusPath

Meaning:
- Mule return was intaken as raw evidence only.
- No adoption yet.
- Next required move is disposition.

Boundary:
- No doctrine rewrite.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No dashboard, automation, knowledge graph, runtime, or full lesson index.
"@
if ($StatusText -notmatch "Recurring Non-Recursive Failure Mule Return Intake") {
    $StatusText = $StatusText.TrimEnd() + $StatusAdd
}
Write-Utf8FileSafe -Path $StatusPath -Text $StatusText

$AnchorHash = (Get-FileHash -Algorithm SHA256 -Path $AnchorPath).Hash
$StatusHash = (Get-FileHash -Algorithm SHA256 -Path $StatusPath).Hash

$Receipt = @"
RECURRING NON-RECURSIVE FAILURE MULE RETURN INTAKE RECEIPT
Date: 2026-05-20

Branch before intake:
$BranchBefore

HEAD before intake:
$HeadBefore

origin/main before intake:
$OriginBefore

Source return folder:
$SourceReturn

Destination:
$DestDir

Files:
$($HashLines -join "`n")

Updated:
- $AnchorPath
  SHA256: $AnchorHash
- $StatusPath
  SHA256: $StatusHash

Verdict:
PASS — raw mule return intake saved.

Meaning:
- Mule return copied into build.
- No recommendations adopted yet.
- Next move is read/disposition.

Boundary:
- No doctrine rewrite.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No dashboard, automation, knowledge graph, runtime, or full lesson index.
"@
Write-Utf8FileSafe -Path $ReceiptPath -Text $Receipt

git add -- $DestDir $AnchorPath $StatusPath
git add -f -- $ReceiptPath

$Staged = Invoke-GitChecked @("diff", "--cached", "--name-only")
if ($Staged.Count -eq 0) {
    throw "Nothing staged for mule return intake."
}

Invoke-GitChecked @("commit", "-m", "Intake recurring non recursive mule return") | Out-Null
Invoke-GitChecked @("push", "origin", "main") | Out-Null

$FinalStatus = Invoke-GitChecked @("status", "--short")
$FinalHead = ((Invoke-GitChecked @("rev-parse", "HEAD")) -join "").Trim()
Invoke-GitChecked @("fetch", "origin", "main") | Out-Null
$FinalOrigin = ((Invoke-GitChecked @("rev-parse", "origin/main")) -join "").Trim()

if ($FinalStatus.Count -gt 0) {
    throw "Final status not clean:`n$($FinalStatus -join "`n")"
}
if ($FinalHead -ne $FinalOrigin) {
    throw "Final HEAD does not match origin/main."
}

Write-Host "MULE RETURN INTAKE PASS"
Write-Host "Branch: $BranchBefore"
Write-Host "HEAD: $FinalHead"
Write-Host "origin/main: $FinalOrigin"
Write-Host "Status: clean"
Write-Host "Source: $SourceReturn"
Write-Host "Dest: $DestDir"
Write-Host "Receipt: $ReceiptPath"
