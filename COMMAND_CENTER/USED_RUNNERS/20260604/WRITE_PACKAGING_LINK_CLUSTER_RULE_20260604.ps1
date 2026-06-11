# WRITE_PACKAGING_LINK_CLUSTER_RULE_20260604.ps1
# Writes the packaging/link-cluster rule into the local/brain.
# Boundary: writes rule + receipt + optional status append only. No commit. No push. No zip. No target/helper execution.

$ErrorActionPreference = "Stop"

$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$RepoRoot = Join-Path $HOME "Desktop\123\Jxhnny_Kl33N_Seedz"

if (-not (Test-Path -LiteralPath $RepoRoot)) {
    throw "Repo/local-brain path not found: $RepoRoot"
}

$BrainDir = Join-Path $RepoRoot "BRAIN_LEARNING"
$ProofDir = Join-Path $RepoRoot "PROOF_HISTORY"
$StatusPath = Join-Path $RepoRoot "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

New-Item -ItemType Directory -Force -Path $BrainDir | Out-Null
New-Item -ItemType Directory -Force -Path $ProofDir | Out-Null

$RulePath = Join-Path $BrainDir "PACKAGING_LINK_CLUSTER_AND_NO_NESTED_ZIPS_RULE_20260604.md"
$ReceiptPath = Join-Path $ProofDir "PACKAGING_LINK_CLUSTER_AND_NO_NESTED_ZIPS_RULE_RECEIPT_20260604.txt"

$RuleText = @'
# Packaging Link Cluster and No Nested Zips Rule

Date: 2026-06-04
Status: BRAIN LEARNING RULE / PACKAGING PRESENTATION / USER-CORRECTION CAPTURE
WorkKey: PACKAGING-LINK-CLUSTER-NO-NESTED-ZIPS-20260604

## Core rule

When delivering related files, keep the file links visually clustered together.

Do not break a group of related download links apart with small labels, extra headings, or spacing between each individual link.

Use one clear explanatory sentence before the cluster, then place the links together, then add any placement note after the cluster.

## Correct presentation shape

Use this shape:

Here are the files for the packet:

[file 1]  
[file 2]  
[file 3]  

Put them in the same folder. No nested zips.

## Why

The user finds clustered links easier to see and handle.

The problem is not the existence of explanation. The problem is scattering related files with little labels and spaces between them so the group becomes visually broken.

## Packaging construction rule

Do not put zipped folders or `.zip` files inside another `.zip` package unless the user explicitly asks for nested archives.

If files belong together, send one flat zip containing the files directly.

If a separate zip/source artifact also matters, send it separately and plainly say where it goes.

## Delivery rule

For related files:

1. Put the explanation above the cluster.
2. Put all related links together in one clean group.
3. Do not add mini-labels above each individual link.
4. Do not add blank spacing between each individual link.
5. Add the placement note below the cluster.
6. Keep the note plain and direct.

## Bad shape

Avoid this:

Rule file:

[file 1]

Manifest:

[file 2]

Zip:

[file 3]

This breaks the group visually.

## Good shape

Use this:

Here are the files:

[file 1]  
[file 2]  
[file 3]  

Place them together in the same folder.

## Boundary

This rule controls artifact packaging and presentation.

It does not authorize nested archives.
It does not authorize broad refactor.
It does not authorize delete/move of user files.
It does not replace proof receipts or manifests.
It does not require every answer to include files.
It applies when files are being delivered or grouped for a work packet.

## Closeout line

Use this when the rule is followed:

`PACKAGING_LINK_CLUSTER_RULE_APPLIED / NO_NESTED_ZIPS`

Use this when blocked:

`PACKAGING_LINK_CLUSTER_BLOCKED_WITH_REASON`
'@

Set-Content -LiteralPath $RulePath -Value $RuleText -Encoding UTF8 -NoNewline

$RuleHash = (Get-FileHash -LiteralPath $RulePath -Algorithm SHA256).Hash

$GitHead = "NOT_CHECKED"
$GitStatusShort = "NOT_CHECKED"
$GitDiffCheck = "NOT_CHECKED"
$HeadEqualsOrigin = "NOT_CHECKED"

Push-Location $RepoRoot
try {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $GitHead = (git rev-parse HEAD 2>$null)
        if (-not $GitHead) { $GitHead = "UNKNOWN" }

        $OriginMain = (git rev-parse origin/main 2>$null)
        if (-not $OriginMain) { $OriginMain = "UNKNOWN" }

        if ($GitHead -ne "UNKNOWN" -and $OriginMain -ne "UNKNOWN" -and $GitHead -eq $OriginMain) {
            $HeadEqualsOrigin = "TRUE"
        } elseif ($GitHead -ne "UNKNOWN" -and $OriginMain -ne "UNKNOWN") {
            $HeadEqualsOrigin = "FALSE"
        } else {
            $HeadEqualsOrigin = "UNKNOWN"
        }

        $GitStatusShort = (git status --short | Out-String).Trim()
        if ([string]::IsNullOrWhiteSpace($GitStatusShort)) {
            $GitStatusShort = "CLEAN"
        }

        $DiffCheckOutput = (git diff --check 2>&1 | Out-String).Trim()
        if ([string]::IsNullOrWhiteSpace($DiffCheckOutput)) {
            $GitDiffCheck = "PASS"
        } else {
            $GitDiffCheck = "FINDINGS: $DiffCheckOutput"
        }
    }
}
finally {
    Pop-Location
}

$ReceiptText = @"
PACKAGING_LINK_CLUSTER_AND_NO_NESTED_ZIPS_RULE_RECEIPT_20260604
RunId: $RunId
Verdict: PACKAGING_LINK_CLUSTER_RULE_WRITTEN / NO_NESTED_ZIPS_RULE_CAPTURED / NO_COMMIT / NO_PUSH

RulePath: $RulePath
RuleSha256: $RuleHash

Boundary:
- Wrote rule file.
- Wrote receipt file.
- May append status note if status file exists.
- No zip created.
- No nested archive created.
- No file packaging performed.
- No delete.
- No move of user files.
- No helper/target execution.
- No commit.
- No push.
- ACTIVE_GUIDES untouched by this script.
- CURRENT_TRUTH_INDEX untouched by this script.

GitHead: $GitHead
HeadEqualsOrigin: $HeadEqualsOrigin
GitDiffCheck: $GitDiffCheck
GitStatusShort:
$GitStatusShort

Closeout:
PACKAGING_LINK_CLUSTER_RULE_APPLIED / NO_NESTED_ZIPS
"@

Set-Content -LiteralPath $ReceiptPath -Value $ReceiptText -Encoding UTF8 -NoNewline
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

if (Test-Path -LiteralPath $StatusPath) {
    $StatusAppend = @"

## Packaging Link Cluster Rule Capture — 2026-06-04

- Rule: `BRAIN_LEARNING/PACKAGING_LINK_CLUSTER_AND_NO_NESTED_ZIPS_RULE_20260604.md`
- RuleSha256: `$RuleHash`
- Receipt: `PROOF_HISTORY/PACKAGING_LINK_CLUSTER_AND_NO_NESTED_ZIPS_RULE_RECEIPT_20260604.txt`
- ReceiptSha256: `$ReceiptHash`
- Verdict: `PACKAGING_LINK_CLUSTER_RULE_APPLIED / NO_NESTED_ZIPS`
- Boundary: packaging presentation/construction rule only; no commit/push by writer.
"@
    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
}

Write-Host "PACKAGING_LINK_CLUSTER_RULE_WRITTEN"
Write-Host "RunId: $RunId"
Write-Host "RulePath: $RulePath"
Write-Host "RuleSha256: $RuleHash"
Write-Host "ReceiptPath: $ReceiptPath"
Write-Host "ReceiptSha256: $ReceiptHash"
Write-Host "Verdict: PACKAGING_LINK_CLUSTER_RULE_APPLIED / NO_NESTED_ZIPS / NO_COMMIT / NO_PUSH"
