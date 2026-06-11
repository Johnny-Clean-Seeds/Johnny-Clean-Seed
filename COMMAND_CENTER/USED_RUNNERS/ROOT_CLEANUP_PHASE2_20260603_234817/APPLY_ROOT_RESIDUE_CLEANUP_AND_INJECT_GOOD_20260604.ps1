# APPLY_ROOT_RESIDUE_CLEANUP_AND_INJECT_GOOD_20260604.ps1
# Purpose: apply the root-no-loose-files rule to the current known active mess.
# Boundary:
# - Moves/parks known root residue only.
# - Injects rule/fixture material into intended project lanes.
# - Writes manifest, review report, and cleanup receipt.
# - Updates CURRENT_HOUSE_WORK_STATUS.md if present.
# - Does NOT delete user originals.
# - Does NOT run target helper.
# - Does NOT run generated runner.
# - Does NOT create zip packages.
# - Does NOT commit or push.

$ErrorActionPreference = "Stop"

$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$Root = Join-Path $HOME "Desktop\123"
$Repo = Join-Path $Root "Jxhnny_Kl33N_Seedz"

if (-not (Test-Path -LiteralPath $Root)) {
    throw "Root not found: $Root"
}
if (-not (Test-Path -LiteralPath $Repo)) {
    throw "Repo not found: $Repo"
}

$BrainDir = Join-Path $Repo "BRAIN_LEARNING"
$ProofDir = Join-Path $Repo "PROOF_HISTORY"
$StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$RowDir = Join-Path $Repo "HOUSE_WORK\IDEA_CONCEPT_COLLECTION_ROOM\HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_20260603"

$CommandCenter = Join-Path $Root "COMMAND_CENTER"
$CustodyRoot = Join-Path $CommandCenter "ROOT_RESIDUE_CUSTODY\20260604_$RunId"
$PacketCustody = Join-Path $CustodyRoot "HANDOFF_AND_CORRECTION_PACKETS"
$ZipCustody = Join-Path $CustodyRoot "ZIP_ARTIFACTS_PROOF_ONLY"
$RunnerArchive = Join-Path $CommandCenter "USED_RUNNERS\20260604"
$DuplicateCustody = Join-Path $CustodyRoot "DUPLICATE_OR_CONFLICT"

$DirsToMake = @(
    $BrainDir,
    $ProofDir,
    $RowDir,
    $CustodyRoot,
    $PacketCustody,
    $ZipCustody,
    $RunnerArchive,
    $DuplicateCustody
)
foreach ($d in $DirsToMake) {
    New-Item -ItemType Directory -Force -Path $d | Out-Null
}

function Get-Sha256OrBlank {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    }
    return ""
}

function Get-UniqueDestination {
    param(
        [string]$DestinationPath
    )
    if (-not (Test-Path -LiteralPath $DestinationPath)) {
        return $DestinationPath
    }

    $parent = Split-Path -Parent $DestinationPath
    $leaf = Split-Path -Leaf $DestinationPath
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    return (Join-Path $parent ("DUPLICATE_{0}_{1}" -f $stamp, $leaf))
}

$Rows = New-Object System.Collections.Generic.List[object]

function Add-ActionRow {
    param(
        [string]$Name,
        [string]$Kind,
        [string]$Classification,
        [string]$SourcePath,
        [string]$DestinationPath,
        [string]$Action,
        [string]$SourceSha,
        [string]$DestinationSha,
        [string]$Status,
        [string]$Notes
    )
    $Rows.Add([pscustomobject]@{
        Name = $Name
        Kind = $Kind
        Classification = $Classification
        SourcePath = $SourcePath
        DestinationPath = $DestinationPath
        Action = $Action
        SourceSha256 = $SourceSha
        DestinationSha256 = $DestinationSha
        Status = $Status
        Notes = $Notes
    }) | Out-Null
}

function Route-KnownItem {
    param(
        [string]$Name,
        [string]$Kind,
        [string]$Classification,
        [string]$SourcePath,
        [string]$DestinationPath,
        [string]$Notes
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        Add-ActionRow -Name $Name -Kind $Kind -Classification $Classification -SourcePath $SourcePath -DestinationPath $DestinationPath -Action "NOOP_MISSING" -SourceSha "" -DestinationSha "" -Status "NOT_PRESENT" -Notes "Source not present at root; no move needed. $Notes"
        return
    }

    $sourceSha = Get-Sha256OrBlank -Path $SourcePath
    $destParent = Split-Path -Parent $DestinationPath
    New-Item -ItemType Directory -Force -Path $destParent | Out-Null

    if (Test-Path -LiteralPath $DestinationPath) {
        $destSha = Get-Sha256OrBlank -Path $DestinationPath

        if ($Kind -eq "FILE" -and $sourceSha -and $destSha -and ($sourceSha -eq $destSha)) {
            $dupDest = Get-UniqueDestination -DestinationPath (Join-Path $DuplicateCustody $Name)
            Move-Item -LiteralPath $SourcePath -Destination $dupDest
            $dupSha = Get-Sha256OrBlank -Path $dupDest
            Add-ActionRow -Name $Name -Kind $Kind -Classification $Classification -SourcePath $SourcePath -DestinationPath $dupDest -Action "MOVED_DUPLICATE_TO_CUSTODY_DEST_ALREADY_MATCHED" -SourceSha $sourceSha -DestinationSha $dupSha -Status "ROUTED_FROM_ROOT" -Notes "Destination already existed with matching hash; root duplicate moved to custody. $Notes"
            return
        }

        $conflictDest = Get-UniqueDestination -DestinationPath (Join-Path $DuplicateCustody $Name)
        Move-Item -LiteralPath $SourcePath -Destination $conflictDest
        $conflictSha = Get-Sha256OrBlank -Path $conflictDest
        Add-ActionRow -Name $Name -Kind $Kind -Classification $Classification -SourcePath $SourcePath -DestinationPath $conflictDest -Action "MOVED_TO_CONFLICT_CUSTODY_DEST_ALREADY_EXISTS" -SourceSha $sourceSha -DestinationSha $conflictSha -Status "PARKED_CONFLICT" -Notes "Destination already existed; did not overwrite. Manual review may be needed. $Notes"
        return
    }

    Move-Item -LiteralPath $SourcePath -Destination $DestinationPath
    $destShaAfter = Get-Sha256OrBlank -Path $DestinationPath
    Add-ActionRow -Name $Name -Kind $Kind -Classification $Classification -SourcePath $SourcePath -DestinationPath $DestinationPath -Action "MOVED_TO_PROJECT_OR_CUSTODY_LANE" -SourceSha $sourceSha -DestinationSha $destShaAfter -Status "ROUTED_FROM_ROOT" -Notes $Notes
}

$BeforeRoot = Get-ChildItem -LiteralPath $Root -Force | Sort-Object Name | Select-Object Name, FullName, PSIsContainer

# Known loose residue from the active mess.
$KnownItems = @(
    @{
        Name = "REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_V1_1.md"
        Kind = "FILE"
        Classification = "WRONG_LANE_RULE_CANDIDATE"
        Source = (Join-Path $Root "REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_V1_1.md")
        Destination = (Join-Path $BrainDir "REPEATED_USER_CORRECTION_TO_LIVING_RULE_TRIGGER_20260604.md")
        Notes = "Parent repeated-correction rule candidate injected into BRAIN_LEARNING."
    },
    @{
        Name = "MULE_ROOT_NO_LOOSE_FILES_RULE_V1.md"
        Kind = "FILE"
        Classification = "WRONG_LANE_RULE_CANDIDATE"
        Source = (Join-Path $Root "MULE_ROOT_NO_LOOSE_FILES_RULE_V1.md")
        Destination = (Join-Path $BrainDir "MULE_ROOT_NO_LOOSE_FILES_RULE_20260604.md")
        Notes = "Child root-no-loose-files rule candidate injected into BRAIN_LEARNING."
    },
    @{
        Name = "ROW_001_DISPOSABLE_FIXTURE_DESIGN_V1.md"
        Kind = "FILE"
        Classification = "WRONG_LANE_FIXTURE"
        Source = (Join-Path $Root "ROW_001_DISPOSABLE_FIXTURE_DESIGN_V1.md")
        Destination = (Join-Path $RowDir "ROW_001_DISPOSABLE_FIXTURE_DESIGN_V1.md")
        Notes = "Row 001 design injected into Helper Stress Bench Row 001 lane."
    },
    @{
        Name = "SHA256_MANIFEST_ROW_001_DISPOSABLE_FIXTURE_V1.csv"
        Kind = "FILE"
        Classification = "WRONG_LANE_MANIFEST"
        Source = (Join-Path $Root "SHA256_MANIFEST_ROW_001_DISPOSABLE_FIXTURE_V1.csv")
        Destination = (Join-Path $RowDir "SHA256_MANIFEST_ROW_001_DISPOSABLE_FIXTURE_V1.csv")
        Notes = "Row 001 manifest injected into Helper Stress Bench Row 001 lane."
    },
    @{
        Name = "ROW_001_DISPOSABLE_FIXTURE_V1"
        Kind = "FOLDER"
        Classification = "WRONG_LANE_FIXTURE_FOLDER"
        Source = (Join-Path $Root "ROW_001_DISPOSABLE_FIXTURE_V1")
        Destination = (Join-Path $RowDir "ROW_001_DISPOSABLE_FIXTURE_V1")
        Notes = "Row 001 inert fixture folder injected into Helper Stress Bench Row 001 lane."
    },
    @{
        Name = "MULE_HANDOFF_ROW_001_RULE_CAPTURE_20260604"
        Kind = "FOLDER"
        Classification = "WRONG_LANE_HANDOFF_PACKET"
        Source = (Join-Path $Root "MULE_HANDOFF_ROW_001_RULE_CAPTURE_20260604")
        Destination = (Join-Path $PacketCustody "MULE_HANDOFF_ROW_001_RULE_CAPTURE_20260604")
        Notes = "Handoff packet moved to local custody, not live root."
    },
    @{
        Name = "MULE_CORRECTION_V2_INJECT_GOOD_UPDATE_PATHS_20260604"
        Kind = "FOLDER"
        Classification = "WRONG_LANE_CORRECTION_PACKET"
        Source = (Join-Path $Root "MULE_CORRECTION_V2_INJECT_GOOD_UPDATE_PATHS_20260604")
        Destination = (Join-Path $PacketCustody "MULE_CORRECTION_V2_INJECT_GOOD_UPDATE_PATHS_20260604")
        Notes = "Correction packet moved to local custody, not live root."
    },
    @{
        Name = "MULE_CORRECTION_APPLY_ROOT_RULE_AND_FULL_NEXT_JOB_20260604"
        Kind = "FOLDER"
        Classification = "WRONG_LANE_CORRECTION_PACKET"
        Source = (Join-Path $Root "MULE_CORRECTION_APPLY_ROOT_RULE_AND_FULL_NEXT_JOB_20260604")
        Destination = (Join-Path $PacketCustody "MULE_CORRECTION_APPLY_ROOT_RULE_AND_FULL_NEXT_JOB_20260604")
        Notes = "Older correction packet moved to local custody, not live root."
    },
    @{
        Name = "MULE_CORRECTION_V2_1_FLAT_NO_NESTED_ZIPS_20260604"
        Kind = "FOLDER"
        Classification = "WRONG_LANE_CORRECTION_PACKET"
        Source = (Join-Path $Root "MULE_CORRECTION_V2_1_FLAT_NO_NESTED_ZIPS_20260604")
        Destination = (Join-Path $PacketCustody "MULE_CORRECTION_V2_1_FLAT_NO_NESTED_ZIPS_20260604")
        Notes = "Flat correction packet moved to local custody, not live root."
    },
    @{
        Name = "MULE_HANDOFF_ACTIVE_MESS_RULES_ROW001_PACKAGING_20260604.md"
        Kind = "FILE"
        Classification = "WRONG_LANE_HANDOFF_PACKET"
        Source = (Join-Path $Root "MULE_HANDOFF_ACTIVE_MESS_RULES_ROW001_PACKAGING_20260604.md")
        Destination = (Join-Path $PacketCustody "MULE_HANDOFF_ACTIVE_MESS_RULES_ROW001_PACKAGING_20260604.md")
        Notes = "Active handoff moved to local custody after processing."
    },
    @{
        Name = "WRITE_PACKAGING_LINK_CLUSTER_RULE_20260604.ps1"
        Kind = "FILE"
        Classification = "WRONG_LANE_SCRIPT_USED"
        Source = (Join-Path $Root "WRITE_PACKAGING_LINK_CLUSTER_RULE_20260604.ps1")
        Destination = (Join-Path $RunnerArchive "WRITE_PACKAGING_LINK_CLUSTER_RULE_20260604.ps1")
        Notes = "Used runner archived to COMMAND_CENTER used runners."
    },
    @{
        Name = "ROW_001_DISPOSABLE_FIXTURE_V1.zip"
        Kind = "FILE"
        Classification = "WRONG_LANE_ZIP_PROOF_ONLY"
        Source = (Join-Path $Root "ROW_001_DISPOSABLE_FIXTURE_V1.zip")
        Destination = (Join-Path $ZipCustody "ROW_001_DISPOSABLE_FIXTURE_V1.zip")
        Notes = "Zip preserved proof-only in custody; live injected fixture is folder/markdown/csv."
    },
    @{
        Name = "MULE_HANDOFF_ROW_001_RULE_CAPTURE_20260604.zip"
        Kind = "FILE"
        Classification = "WRONG_LANE_ZIP_SUPERSEDED_BAD_PACKAGING"
        Source = (Join-Path $Root "MULE_HANDOFF_ROW_001_RULE_CAPTURE_20260604.zip")
        Destination = (Join-Path $ZipCustody "MULE_HANDOFF_ROW_001_RULE_CAPTURE_20260604.zip")
        Notes = "Known nested-zip/bad-packaging artifact; preserved proof-only, not live carry."
    },
    @{
        Name = "MULE_CORRECTION_V2_INJECT_GOOD_UPDATE_PATHS_20260604.zip"
        Kind = "FILE"
        Classification = "WRONG_LANE_ZIP_SUPERSEDED"
        Source = (Join-Path $Root "MULE_CORRECTION_V2_INJECT_GOOD_UPDATE_PATHS_20260604.zip")
        Destination = (Join-Path $ZipCustody "MULE_CORRECTION_V2_INJECT_GOOD_UPDATE_PATHS_20260604.zip")
        Notes = "Superseded zip moved proof-only to custody."
    },
    @{
        Name = "MULE_CORRECTION_V2_1_FLAT_NO_NESTED_ZIPS_20260604.zip"
        Kind = "FILE"
        Classification = "WRONG_LANE_ZIP_PROOF_ONLY_FLAT"
        Source = (Join-Path $Root "MULE_CORRECTION_V2_1_FLAT_NO_NESTED_ZIPS_20260604.zip")
        Destination = (Join-Path $ZipCustody "MULE_CORRECTION_V2_1_FLAT_NO_NESTED_ZIPS_20260604.zip")
        Notes = "Flat packet zip preserved proof-only; not live root."
    },
    @{
        Name = "MULE_CORRECTION_APPLY_ROOT_RULE_AND_FULL_NEXT_JOB_20260604.zip"
        Kind = "FILE"
        Classification = "WRONG_LANE_ZIP_SUPERSEDED"
        Source = (Join-Path $Root "MULE_CORRECTION_APPLY_ROOT_RULE_AND_FULL_NEXT_JOB_20260604.zip")
        Destination = (Join-Path $ZipCustody "MULE_CORRECTION_APPLY_ROOT_RULE_AND_FULL_NEXT_JOB_20260604.zip")
        Notes = "Older correction zip moved proof-only to custody."
    }
)

foreach ($item in $KnownItems) {
    Route-KnownItem -Name $item.Name -Kind $item.Kind -Classification $item.Classification -SourcePath $item.Source -DestinationPath $item.Destination -Notes $item.Notes
}

# Verify Row 001 fixture after injection.
$RowFixtureDir = Join-Path $RowDir "ROW_001_DISPOSABLE_FIXTURE_V1"
$RowFixtureForbidden = @()
$RowFixtureFileCount = 0
if (Test-Path -LiteralPath $RowFixtureDir) {
    $RowFixtureFiles = Get-ChildItem -LiteralPath $RowFixtureDir -Recurse -File -Force
    $RowFixtureFileCount = @($RowFixtureFiles).Count
    foreach ($f in $RowFixtureFiles) {
        if ($f.Extension.ToLowerInvariant() -notin @(".md", ".csv")) {
            $RowFixtureForbidden += $f.FullName
        }
    }
}

$RowReviewPath = Join-Path $RowDir "ROW_001_STATIC_FIXTURE_REVIEW_20260604.md"
$RowReviewVerdict = if ($RowFixtureForbidden.Count -eq 0 -and (Test-Path -LiteralPath $RowFixtureDir)) { "PASS_STATIC_FIXTURE_REVIEW" } elseif (Test-Path -LiteralPath $RowFixtureDir) { "BLOCK_STATIC_FIXTURE_REVIEW" } else { "WATCH_STATIC_FIXTURE_REVIEW" }

$ForbiddenListText = if ($RowFixtureForbidden.Count -eq 0) { "None." } else { ($RowFixtureForbidden -join "`n") }

$RowReview = @"
# Row 001 Static Fixture Review

Date: 2026-06-04
RunId: $RunId
Status: STATIC FIXTURE REVIEW / TARGET HELPER NOT RUN

## Verdict

$RowReviewVerdict

## Fixture path

$RowFixtureDir

## File count

$RowFixtureFileCount

## Forbidden executable surfaces found

$ForbiddenListText

## Required target-helper status

TARGET_HELPER_NOT_RUN

NO_TARGET_HELPER_RESULT_EXISTS

RUNNER_LAYER_UNSTABLE

STATIC_FIXTURE_REVIEW_ONLY

## Boundary

No target helper execution.
No generated runner.
No launcher.
No watcher.
No automation.
No zip extraction into root.
"@
Set-Content -LiteralPath $RowReviewPath -Value $RowReview -Encoding UTF8 -NoNewline
$RowReviewSha = Get-Sha256OrBlank -Path $RowReviewPath

# Verify packaging rule.
$PackagingRulePath = Join-Path $BrainDir "PACKAGING_LINK_CLUSTER_AND_NO_NESTED_ZIPS_RULE_20260604.md"
$PackagingReceiptPath = Join-Path $ProofDir "PACKAGING_LINK_CLUSTER_AND_NO_NESTED_ZIPS_RULE_RECEIPT_20260604.txt"
$ExpectedPackagingRuleSha = "789C82E2213B8BB9DA0E2D364F62CDB21DE2D3525510F51406C4805CC7A3D9BB"
$ExpectedPackagingReceiptSha = "5F5DA0C2E42F7137CF5ED7ED5FBEF4924E78BC79E6A0015B9F9DD9AADE6CB799"
$PackagingRuleSha = Get-Sha256OrBlank -Path $PackagingRulePath
$PackagingReceiptSha = Get-Sha256OrBlank -Path $PackagingReceiptPath
$PackagingRuleStatus = if ($PackagingRuleSha -eq $ExpectedPackagingRuleSha) { "PACKAGING_LINK_CLUSTER_RULE_VERIFIED" } elseif ($PackagingRuleSha) { "PACKAGING_RULE_HASH_MISMATCH" } else { "PACKAGING_RULE_MISSING" }
$PackagingReceiptStatus = if ($PackagingReceiptSha -eq $ExpectedPackagingReceiptSha) { "NO_NESTED_ZIPS_RULE_RECEIPT_VERIFIED" } elseif ($PackagingReceiptSha) { "PACKAGING_RECEIPT_HASH_MISMATCH" } else { "PACKAGING_RECEIPT_MISSING" }

# Write action manifest.
$ActionManifestPath = Join-Path $ProofDir "ROOT_RESIDUE_CLEANUP_AND_INJECT_GOOD_MANIFEST_20260604_$RunId.csv"
$Rows | Export-Csv -LiteralPath $ActionManifestPath -NoTypeInformation -Encoding UTF8
$ActionManifestSha = Get-Sha256OrBlank -Path $ActionManifestPath

# Final known residue check.
$KnownRemaining = New-Object System.Collections.Generic.List[string]
foreach ($item in $KnownItems) {
    if (Test-Path -LiteralPath $item.Source) {
        $KnownRemaining.Add($item.Source) | Out-Null
    }
}

# Direct root unknown inventory after work.
$AfterRoot = Get-ChildItem -LiteralPath $Root -Force | Sort-Object Name | Select-Object Name, FullName, PSIsContainer

$AllowedRootNames = @(
    "Jxhnny_Kl33N_Seedz",
    "COMMAND_CENTER",
    "MAIL_ROOM",
    "_LOCAL_RUNNERS",
    "_MISC_DRAWER"
)

$UnknownRootDirect = @()
foreach ($x in $AfterRoot) {
    if ($x.Name -notin $AllowedRootNames) {
        # Do not automatically treat all unknowns as residue; list them for user/mule review.
        $UnknownRootDirect += $x.FullName
    }
}

$FinalKnownResidueVerdict = if ($KnownRemaining.Count -eq 0) { "ROOT_KNOWN_RESIDUE_CHECK_PASS" } else { "ROOT_KNOWN_RESIDUE_STILL_PRESENT_BLOCKED" }
$FinalRootVerdict = if ($KnownRemaining.Count -eq 0 -and $UnknownRootDirect.Count -eq 0) { "ROOT_NO_LOOSE_FILES_CHECK_PASS" } elseif ($KnownRemaining.Count -eq 0) { "ROOT_KNOWN_RESIDUE_ROUTED_UNKNOWN_ROOT_ITEMS_REMAIN_FOR_REVIEW" } else { "ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED" }

# Git status proof; no commit/push.
$GitHead = "NOT_CHECKED"
$GitOrigin = "NOT_CHECKED"
$HeadEqualsOrigin = "NOT_CHECKED"
$GitStatusShort = "NOT_CHECKED"
Push-Location $Repo
try {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $GitHead = (git rev-parse HEAD 2>$null)
        if (-not $GitHead) { $GitHead = "UNKNOWN" }
        $GitOrigin = (git rev-parse origin/main 2>$null)
        if (-not $GitOrigin) { $GitOrigin = "UNKNOWN" }
        if ($GitHead -ne "UNKNOWN" -and $GitOrigin -ne "UNKNOWN" -and $GitHead -eq $GitOrigin) {
            $HeadEqualsOrigin = "TRUE"
        } elseif ($GitHead -ne "UNKNOWN" -and $GitOrigin -ne "UNKNOWN") {
            $HeadEqualsOrigin = "FALSE"
        } else {
            $HeadEqualsOrigin = "UNKNOWN"
        }
        $GitStatusShort = (git status --short | Out-String).Trim()
        if ([string]::IsNullOrWhiteSpace($GitStatusShort)) {
            $GitStatusShort = "CLEAN"
        }
    }
}
finally {
    Pop-Location
}

$KnownRemainingText = if ($KnownRemaining.Count -eq 0) { "None." } else { ($KnownRemaining -join "`n") }
$UnknownRootText = if ($UnknownRootDirect.Count -eq 0) { "None." } else { ($UnknownRootDirect -join "`n") }

$ReceiptPath = Join-Path $ProofDir "ROOT_RESIDUE_CLEANUP_AND_INJECT_GOOD_RECEIPT_20260604_$RunId.txt"
$ReceiptText = @"
ROOT_RESIDUE_CLEANUP_AND_INJECT_GOOD_RECEIPT_20260604
RunId: $RunId

Verdict:
APPLY_ROOT_RULE_NOW_DONE
WRONG_LANE_ROOT_RESIDUE_FOUND_AND_ROUTED
GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE
$RowReviewVerdict
$PackagingRuleStatus
$PackagingReceiptStatus
$FinalKnownResidueVerdict
$FinalRootVerdict
TARGET_HELPER_NOT_RUN
NO_TARGET_HELPER_RESULT_EXISTS
NO_COMMIT_NO_PUSH

Boundary:
- Known root residue was routed or parked.
- Rule/fixture material was injected into project lanes where planned.
- Row 001 static fixture review was written.
- Packaging rule and receipt were checked.
- No target helper was run.
- No generated runner was created.
- No zip packages were created.
- No zip was extracted into root.
- No delete was performed by this script.
- No commit or push was performed by this script.

ActionManifestPath: $ActionManifestPath
ActionManifestSha256: $ActionManifestSha

RowReviewPath: $RowReviewPath
RowReviewSha256: $RowReviewSha

PackagingRulePath: $PackagingRulePath
PackagingRuleSha256: $PackagingRuleSha
PackagingRuleStatus: $PackagingRuleStatus

PackagingReceiptPath: $PackagingReceiptPath
PackagingReceiptSha256: $PackagingReceiptSha
PackagingReceiptStatus: $PackagingReceiptStatus

KnownResidueRemaining:
$KnownRemainingText

UnknownRootDirectItemsForReview:
$UnknownRootText

GitHead: $GitHead
GitOriginMain: $GitOrigin
HeadEqualsOrigin: $HeadEqualsOrigin
GitStatusShort:
$GitStatusShort
"@
Set-Content -LiteralPath $ReceiptPath -Value $ReceiptText -Encoding UTF8 -NoNewline
$ReceiptSha = Get-Sha256OrBlank -Path $ReceiptPath

# Optional status append.
if (Test-Path -LiteralPath $StatusPath) {
    $Append = @"

## Root Residue Cleanup and Good-Material Injection — 2026-06-04

- RunId: `$RunId`
- Receipt: `PROOF_HISTORY/ROOT_RESIDUE_CLEANUP_AND_INJECT_GOOD_RECEIPT_20260604_$RunId.txt`
- ReceiptSha256: `$ReceiptSha`
- Manifest: `PROOF_HISTORY/ROOT_RESIDUE_CLEANUP_AND_INJECT_GOOD_MANIFEST_20260604_$RunId.csv`
- ManifestSha256: `$ActionManifestSha`
- Row001Review: `HOUSE_WORK/IDEA_CONCEPT_COLLECTION_ROOM/HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE_AND_FIXTURE_CARD_20260603/ROW_001_STATIC_FIXTURE_REVIEW_20260604.md`
- Row001ReviewSha256: `$RowReviewSha`
- Verdict: `APPLY_ROOT_RULE_NOW_DONE / WRONG_LANE_ROOT_RESIDUE_FOUND_AND_ROUTED / GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE / $FinalRootVerdict`
- Boundary: no target helper run; no generated runner; no zip creation; no commit/push by cleanup script.
"@
    Add-Content -LiteralPath $StatusPath -Value $Append -Encoding UTF8
}

Write-Host "ROOT_RESIDUE_CLEANUP_AND_INJECT_GOOD_COMPLETE"
Write-Host "RunId: $RunId"
Write-Host "ManifestPath: $ActionManifestPath"
Write-Host "ManifestSha256: $ActionManifestSha"
Write-Host "ReceiptPath: $ReceiptPath"
Write-Host "ReceiptSha256: $ReceiptSha"
Write-Host "RowReviewPath: $RowReviewPath"
Write-Host "RowReviewSha256: $RowReviewSha"
Write-Host "FinalKnownResidueVerdict: $FinalKnownResidueVerdict"
Write-Host "FinalRootVerdict: $FinalRootVerdict"
Write-Host "TargetHelperStatus: TARGET_HELPER_NOT_RUN / NO_TARGET_HELPER_RESULT_EXISTS"
Write-Host "Git: NO_COMMIT_NO_PUSH"
if ($UnknownRootDirect.Count -gt 0) {
    Write-Host "UnknownRootDirectItemsForReview:"
    $UnknownRootDirect | ForEach-Object { Write-Host $_ }
}
