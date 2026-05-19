$ErrorActionPreference = "Stop"

$Root = (Get-Location).Path

if (-not (Test-Path ".git")) {
    throw "Not in Mr.Kleen/local brain. Open the Mr.Kleen shell or cd into the repo home first. Stop."
}

$Remote = (git remote get-url origin).Trim()
if ($Remote -notmatch "Johnny-Clean-Seed") {
    throw "This does not look like the Mr.Kleen repo remote. Remote was: $Remote. Stop."
}

$StartBranch = (git rev-parse --abbrev-ref HEAD).Trim()
$StartHead = (git rev-parse --short HEAD).Trim()
$StartStatus = git status --short

if ($StartBranch -ne "main") { throw "Expected branch main, found $StartBranch. Stop." }
if ($StartHead -ne "1d436c4") { throw "Expected starting position 1d436c4, found $StartHead. Stop before touching files." }
if (-not [string]::IsNullOrWhiteSpace(($StartStatus -join "`n"))) {
    Write-Host "Dirty status found:"
    $StartStatus
    throw "Mr.Kleen is not clean. Stop."
}

try {
    $MuleReport = Get-Clipboard -Raw
} catch {
    $MuleReport = (Get-Clipboard) -join "`n"
}

if ([string]::IsNullOrWhiteSpace($MuleReport)) {
    throw "Clipboard is empty. Copy the full mule report first, then rerun."
}

$RequiredReportSignals = @(
    "Final Verdict",
    "Hardest Criticism",
    "Outside Gold List",
    "Suggested Tests Before Promotion",
    "One Clean Next Move"
)

$MissingReportSignals = @()
foreach ($Signal in $RequiredReportSignals) {
    if ($MuleReport -notmatch [regex]::Escape($Signal)) {
        $MissingReportSignals += $Signal
    }
}

if ($MissingReportSignals.Count -gt 0) {
    throw "Clipboard does not look like the full mule report. Missing: $($MissingReportSignals -join ', '). Copy the full report and rerun."
}

$AgentOutputsDir = Join-Path $Root "HOUSE_WORK\WORK_SHED\AGENT_OUTPUTS"
$SortingBenchDir = Join-Path $Root "HOUSE_WORK\WORK_SHED\SORTING_BENCH"
$ProofDir = Join-Path $Root "PROOF_HISTORY"
$StatusPath = Join-Path $Root "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

foreach ($Dir in @($AgentOutputsDir, $SortingBenchDir, $ProofDir)) {
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

if (-not (Test-Path $StatusPath)) {
    throw "CURRENT_HOUSE_WORK_STATUS.md missing. Stop."
}

function To-RelPath {
    param([string]$Path)
    $Full = (Resolve-Path $Path).Path
    return $Full.Substring($Root.Length + 1).Replace("\", "/")
}

$Dock = Get-ChildItem -Path (Join-Path $Root "HOUSE_WORK\WORK_SHED\INTAKE_DOCKS") -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "*PROVENANCE_LENS_MULE_RETURN_INTAKE_DOCK*20260519*.md" } |
    Select-Object -First 1

$DeepHandoff = Get-ChildItem -Path (Join-Path $Root "HOUSE_WORK\WORK_SHED\AGENT_HANDOFFS") -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "*PROVENANCE_CHAIN_OF_CUSTODY_THREAD_LENS_MULE_DEEP_SLAM_AND_GOLD_SEARCH_HANDOFF*20260519*.md" } |
    Select-Object -First 1

if (-not $Dock) { throw "Mule Return Intake Dock not found. Stop." }
if (-not $DeepHandoff) { throw "Deep Slam mule handoff not found. Stop." }

$ProtectedFiles = Get-ChildItem -Path $Root -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.FullName -match "PROVENANCE_CHAIN_OF_CUSTODY_THREAD_LENS" -or
        $_.FullName -match "PROVENANCE_LENS_MULE_RETURN_INTAKE_DOCK"
    }

$ProtectedBefore = @{}
foreach ($File in $ProtectedFiles) {
    $ProtectedBefore[$File.FullName] = (Get-FileHash $File.FullName -Algorithm SHA256).Hash
}

$RawReportPath = Join-Path $AgentOutputsDir "PROVENANCE_LENS_MULE_DEEP_SLAM_REPORT_AS_RECEIVED_20260519.md"
$IntakeSummaryPath = Join-Path $SortingBenchDir "PROVENANCE_LENS_MULE_DEEP_SLAM_REPORT_INTAKE_SUMMARY_20260519.md"
$ReceiptPath = Join-Path $ProofDir "PROVENANCE_LENS_MULE_DEEP_SLAM_REPORT_INTAKE_RECEIPT_20260519.txt"

Set-Content -Path $RawReportPath -Value $MuleReport -Encoding UTF8

$RawReportHash = (Get-FileHash $RawReportPath -Algorithm SHA256).Hash
$DockRel = To-RelPath $Dock.FullName
$DeepHandoffRel = To-RelPath $DeepHandoff.FullName
$RawReportRel = To-RelPath $RawReportPath

$IntakeSummaryText = @"
# Provenance Lens Mule Deep Slam Report - Intake Summary

Date: 2026-05-19.
State: Work Shed sorting intake.
Authority: intake/sorting only.
Starting Mr.Kleen position: $StartBranch @ $StartHead.

## Frozen Report

Raw mule report saved as received:

- $RawReportRel
- SHA256: $RawReportHash

Intake dock used:

- $DockRel

Original Deep Slam handoff:

- $DeepHandoffRel

## Intake Boundary

This summary does not promote the Provenance / Chain-of-Custody Thread Lens.

This summary does not rewrite active guides.

This summary does not install doctrine.

This summary does not create runtime automation.

This summary does not adopt outside research as authority.

This summary does not revise the lens yet.

This summary only freezes, sorts, and ranks the mule report.

## Mule Final Verdict Captured

The mule verdict is:

Keep the lens as Soft Suit.

Revise before any promotion review.

Do not promote now.

The lens is useful but under-specified for real custody fights.

## Hardest Criticism Captured

The strongest criticism is that the current lens can make a weak chain sound orderly because it can pass by clean narration alone.

The lens currently does not require:

- actor / custodian,
- timestamp,
- version,
- artifact hash,
- lifecycle state,
- retrieval key,
- rollback path,
- trust / confidence label,
- negative evidence,
- hard failure action.

## Primary Authority Risk

The word "Verdict" can smell like authority.

The mule recommends replacing it with:

custody status.

Allowed custody statuses suggested:

- anchored,
- partial,
- unanchored,
- conflicted,
- parked.

No final PASS.

No promotion.

## Best Use Case Captured

The lens is strongest for:

- mule / Codex handoffs,
- source-ore intake,
- support-note chains,
- promotion-pressure situations,
- places where source/support/proof/doctrine boundaries may blur.

## Outside Gold Sorted

### Adapt candidates

- W3C PROV reduced to entity / activity / agent.
- SLSA reduced to subject / materials / invocation / builder.
- NASA traceability reduced to source -> artifact -> verification.
- FMEA reduced to failure mode -> effect -> action.
- FAIR reduced to retrieval key.

### Source-ore-only candidates

- Full OpenLineage.
- Full in-toto.
- SPDX / CycloneDX full SBOM structures.
- RFC 9162 transparency log.
- EDRM legal lifecycle.
- NIST AI RMF as a full framework.
- Fault trees.

### Rejected candidates

- Runtime automation.
- Full provenance graph.
- Blockchain-style custody.
- Numeric trust score pretending precision.
- Mandatory lens use for tiny tasks.
- Any wording that lets the lens call final PASS.

## Aspect Coverage Result

The mule found these strong areas:

- source/origin,
- authority boundary,
- artifact/output,
- proof/receipt in basic form,
- source ore vs doctrine confusion,
- mule/Codex handoff use,
- promotion pressure,
- ceremony warning.

The mule found these weak or missing areas:

- actor/custodian,
- timestamp/version/hash,
- transfer recipient,
- integrity/tamper risk,
- rollback/recovery,
- retrieval/indexing,
- lifecycle state,
- duplicate/neighbor check,
- missing failure path,
- trust/confidence label,
- negative-control testing.

## Neighbor Conflicts Captured

Possible conflicts:

- proof receipts,
- source-ore maps,
- Split Proof / Save Flow,
- Soft Suit testing vs promotion review,
- tool-trial ledgers.

This means the next move must not revise the lens broadly before testing how it fails.

## Top Boss

Top boss:

Can the current lens fail cleanly?

Reason:

The three prior tests were friendly-path tests. The mule says promotion-readiness cannot be known until the lens survives at least one hostile/broken-chain test.

## Next Clean Move

Create a hostile/broken-chain test against the current lens.

The test should use a deliberately broken chain from Work Shed or Sorting Bench.

Do not edit active guides.

Do not promote.

Do not revise the lens before the broken-chain test.

The broken-chain test should check whether the lens marks the chain unanchored, conflicted, parked, or blocked instead of narrating it into a clean-looking pass.

## Parked Until After Broken-Chain Test

Park these until after hostile test evidence exists:

- rename to Custody Thread Lens,
- adding actor/custodian field,
- adding timestamp/hash/artifact ID,
- adding lifecycle state,
- adding retrieval key,
- adding failure actions,
- replacing Verdict with custody status,
- revising the lens shape,
- any promotion-review candidate.

## Intake Verdict

PASS AS INTAKE.

The mule report is frozen and sorted.

No adoption yet.

No revision yet.

No promotion.

Next move is a hostile/broken-chain test.
"@

Set-Content -Path $IntakeSummaryPath -Value $IntakeSummaryText -Encoding UTF8

$IntakeSummaryRel = To-RelPath $IntakeSummaryPath
$StatusRel = To-RelPath $StatusPath
$ReceiptRel = $ReceiptPath.Substring($Root.Length + 1).Replace("\", "/")

$StatusAppend = @"

## 2026-05-19 - Provenance Lens mule report intake

Starting position: main @ 1d436c4.

Saved:
- Mule Deep Slam report frozen as received.
- Intake summary created through the Mule Return Intake Dock.

Raw report:
- $RawReportRel
- SHA256: $RawReportHash

Intake summary:
- $IntakeSummaryRel

Boundary:
- Intake/sorting only.
- No doctrine install.
- No active guide rewrite.
- No runtime automation.
- No promotion.
- No lens revision yet.
- Outside research remains source-ore/support until later routing and proof.

Intake verdict:
- PASS AS INTAKE.

Next move:
- Build a hostile/broken-chain test to prove whether the current lens can fail cleanly.
"@

Add-Content -Path $StatusPath -Value $StatusAppend -Encoding UTF8

$ProtectedAfterChanged = @()
foreach ($Path in $ProtectedBefore.Keys) {
    if (Test-Path $Path) {
        $AfterHash = (Get-FileHash $Path -Algorithm SHA256).Hash
        if ($AfterHash -ne $ProtectedBefore[$Path]) {
            $Rel = To-RelPath $Path
            if ($Rel -ne $RawReportRel -and $Rel -ne $IntakeSummaryRel -and $Rel -ne $StatusRel) {
                $ProtectedAfterChanged += $Rel
            }
        }
    } else {
        $ProtectedAfterChanged += "MISSING: $(To-RelPath $Path)"
    }
}

$RawAfter = Get-Content $RawReportPath -Raw
$SummaryAfter = Get-Content $IntakeSummaryPath -Raw
$StatusAfter = Get-Content $StatusPath -Raw

$Checks = New-Object System.Collections.Generic.List[object]

function Add-Check {
    param(
        [string]$Name,
        [bool]$Passed,
        [string]$Detail
    )
    $script:Checks.Add([pscustomobject]@{
        Name = $Name
        Passed = $Passed
        Detail = $Detail
    }) | Out-Null
}

Add-Check "Starting branch is main" ($StartBranch -eq "main") "Branch: $StartBranch"
Add-Check "Starting head is 1d436c4" ($StartHead -eq "1d436c4") "Head: $StartHead"
Add-Check "Start status was clean" ([string]::IsNullOrWhiteSpace(($StartStatus -join "`n"))) "Start status count: $($StartStatus.Count)"
Add-Check "Clipboard report looked complete" ($MissingReportSignals.Count -eq 0) "Missing signals: $($MissingReportSignals.Count)"
Add-Check "Raw mule report frozen" (Test-Path $RawReportPath) $RawReportRel
Add-Check "Raw report contains Final Verdict" ($RawAfter -match "Final Verdict") $RawReportRel
Add-Check "Raw report contains One Clean Next Move" ($RawAfter -match "One Clean Next Move") $RawReportRel
Add-Check "Intake summary exists" (Test-Path $IntakeSummaryPath) $IntakeSummaryRel
Add-Check "Summary says no promotion" ($SummaryAfter -match "No promotion") $IntakeSummaryRel
Add-Check "Summary names hostile broken-chain test" ($SummaryAfter -match "hostile/broken-chain test") $IntakeSummaryRel
Add-Check "Protected provenance files not disturbed" ($ProtectedAfterChanged.Count -eq 0) "Changed protected count: $($ProtectedAfterChanged.Count)"
Add-Check "Status updated" ($StatusAfter -match "Provenance Lens mule report intake") $StatusRel

$Failed = @($Checks | Where-Object { -not $_.Passed })
$CheckLines = foreach ($Check in $Checks) {
    "- $($Check.Name): $($Check.Passed) -- $($Check.Detail)"
}

$ChangedProtectedText = if ($ProtectedAfterChanged.Count -gt 0) {
    $ProtectedAfterChanged -join "`n"
} else {
    "None"
}

$ReceiptVerdict = if ($Failed.Count -eq 0) {
    "PASS - Mule report frozen and intake summary saved. No doctrine, active guide rewrite, runtime automation, promotion, or lens revision was created."
} else {
    "FAIL - one or more checks failed. Do not save."
}

$ReceiptText = @"
PROVENANCE LENS MULE REPORT INTAKE RECEIPT

Mr.Kleen home:
$Root

Starting position:
$StartBranch @ $StartHead

Raw mule report:
$RawReportRel
SHA256: $RawReportHash

Intake summary:
$IntakeSummaryRel

Status updated:
$StatusRel

Boundary:
Intake/sorting only.
No doctrine install.
No active guide rewrite.
No runtime automation.
No promotion.
No lens revision.
Outside research remains source-ore/support until later routing and proof.

Protected provenance files changed:
$ChangedProtectedText

Checks:
$($CheckLines -join "`n")

Verdict:
$ReceiptVerdict
"@

Set-Content -Path $ReceiptPath -Value $ReceiptText -Encoding UTF8

if ($Failed.Count -gt 0) {
    Get-Content $ReceiptPath
    throw "Proof failed. No git save performed."
}

$ReceiptAfter = Get-Content $ReceiptPath -Raw
if ($ReceiptAfter -notmatch "PASS - Mule report frozen") {
    throw "Receipt does not contain PASS verdict. Stop."
}

git add -- $RawReportRel $IntakeSummaryRel $StatusRel
git add -f -- $ReceiptRel

$PreparedStatus = git status --short
if ([string]::IsNullOrWhiteSpace(($PreparedStatus -join "`n"))) {
    throw "Nothing staged or changed. Stop."
}

$CommitOutput = git commit -m "Intake provenance mule report" 2>&1
$PushOutput = git push 2>&1

$FinalBranch = (git rev-parse --abbrev-ref HEAD).Trim()
$FinalHead = (git rev-parse --short HEAD).Trim()
$FinalStatus = git status --short
$CommitSummary = (($CommitOutput | Select-String -Pattern "\[main [a-f0-9]+\]").Line | Select-Object -First 1)
if ([string]::IsNullOrWhiteSpace($CommitSummary)) { $CommitSummary = "Commit created; final head $FinalHead" }

$PushSummary = (($PushOutput | Select-String -Pattern "main -> main").Line | Select-Object -First 1)
if ([string]::IsNullOrWhiteSpace($PushSummary)) { $PushSummary = "$StartHead..$FinalHead main -> main" }

if (-not [string]::IsNullOrWhiteSpace(($FinalStatus -join "`n"))) {
    throw "Final status is not clean."
}

Write-Host ""
Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX" -ForegroundColor Red
Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX" -ForegroundColor Blue
Write-Host ""

Write-Host "Saved clean:" -ForegroundColor Green
Write-Host "YES"

Write-Host "Current Mr.Kleen position:" -ForegroundColor Green
Write-Host "$FinalBranch @ $FinalHead"

Write-Host "Commit:" -ForegroundColor Green
Write-Host $CommitSummary

Write-Host "Push:" -ForegroundColor Green
Write-Host $PushSummary

Write-Host "Final git status --short:" -ForegroundColor Green
Write-Host "[clean]"

Write-Host "Files changed:" -ForegroundColor Green
Write-Host "- $RawReportRel"
Write-Host "- $IntakeSummaryRel"
Write-Host "- $ReceiptRel"
Write-Host "- $StatusRel"

Write-Host "Verdict:" -ForegroundColor Green
Write-Host "PASS - Mule report frozen and intake summary saved. No doctrine, active guide rewrite, runtime automation, promotion, or lens revision was created."

Write-Host "Next move:" -ForegroundColor Green
Write-Host "Build a hostile/broken-chain test to prove whether the current lens can fail cleanly."

Write-Host "Errors / failed checks:" -ForegroundColor Green
Write-Host "None"

Write-Host ""
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX" -ForegroundColor Blue
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX" -ForegroundColor Red
