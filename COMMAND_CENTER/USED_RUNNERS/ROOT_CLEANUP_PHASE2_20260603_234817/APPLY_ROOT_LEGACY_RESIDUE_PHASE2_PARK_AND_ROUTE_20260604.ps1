# APPLY_ROOT_LEGACY_RESIDUE_PHASE2_PARK_AND_ROUTE_20260604.ps1
# Purpose: Phase 2 root cleanup for older/legacy residue still visible after known active-mess cleanup.
# Boundary:
# - Routes obvious legacy loose scripts/source notes/packages out of root into custody/review lanes.
# - Does not delete anything.
# - Does not run target helper.
# - Does not run generated runners.
# - Does not create zip packages.
# - Does not commit or push.
# - Parks large/unclear packages with return trigger instead of pretending they are injected/solved.

$ErrorActionPreference = "Stop"

$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$Root = Join-Path $HOME "Desktop\123"
$Repo = Join-Path $Root "Jxhnny_Kl33N_Seedz"

if (-not (Test-Path -LiteralPath $Root)) { throw "Root not found: $Root" }
if (-not (Test-Path -LiteralPath $Repo)) { throw "Repo not found: $Repo" }

$ProofDir = Join-Path $Repo "PROOF_HISTORY"
$StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$CommandCenter = Join-Path $Root "COMMAND_CENTER"
$UsedRunners = Join-Path $CommandCenter "USED_RUNNERS\ROOT_CLEANUP_PHASE2_$RunId"
$CustodyBase = Join-Path $Root "_LOCAL_CUSTODY_AND_RECEIPTS\ROOT_LEGACY_RESIDUE_PHASE2_$RunId"
$PackageParking = Join-Path $CustodyBase "PARKED_PACKAGES_PENDING_REVIEW"
$SourceParking = Join-Path $Root "_SOURCE_RESEARCH_NOTES\ROOT_SOURCE_NOTES_$RunId"
$ToolParking = Join-Path $Root "_TOOLS_AND_SCRIPTS\ROW_001_LEGACY_WRITERS_$RunId"

foreach ($d in @($ProofDir,$CommandCenter,$UsedRunners,$CustodyBase,$PackageParking,$SourceParking,$ToolParking)) {
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
    param([string]$DestinationPath)
    if (-not (Test-Path -LiteralPath $DestinationPath)) { return $DestinationPath }
    $parent = Split-Path -Parent $DestinationPath
    $leaf = Split-Path -Leaf $DestinationPath
    return (Join-Path $parent ("DUPLICATE_{0}_{1}" -f (Get-Date -Format "yyyyMMdd_HHmmss"), $leaf))
}

$Rows = New-Object System.Collections.Generic.List[object]
function Add-Row {
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
        [string]$ReturnTrigger,
        [string]$Notes
    )
    $Rows.Add([pscustomobject]@{
        Name=$Name
        Kind=$Kind
        Classification=$Classification
        SourcePath=$SourcePath
        DestinationPath=$DestinationPath
        Action=$Action
        SourceSha256=$SourceSha
        DestinationSha256=$DestinationSha
        Status=$Status
        ReturnTrigger=$ReturnTrigger
        Notes=$Notes
    }) | Out-Null
}

function Move-Or-Park {
    param(
        [string]$Name,
        [string]$Kind,
        [string]$Classification,
        [string]$SourcePath,
        [string]$DestinationPath,
        [string]$ReturnTrigger,
        [string]$Notes
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        Add-Row -Name $Name -Kind $Kind -Classification $Classification -SourcePath $SourcePath -DestinationPath $DestinationPath -Action "NOOP_MISSING" -SourceSha "" -DestinationSha "" -Status "NOT_PRESENT" -ReturnTrigger $ReturnTrigger -Notes $Notes
        return
    }

    $sourceSha = Get-Sha256OrBlank -Path $SourcePath
    $dest = Get-UniqueDestination -DestinationPath $DestinationPath
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
    Move-Item -LiteralPath $SourcePath -Destination $dest
    $destSha = Get-Sha256OrBlank -Path $dest
    Add-Row -Name $Name -Kind $Kind -Classification $Classification -SourcePath $SourcePath -DestinationPath $dest -Action "MOVED_OUT_OF_ROOT" -SourceSha $sourceSha -DestinationSha $destSha -Status "ROUTED_OR_PARKED" -ReturnTrigger $ReturnTrigger -Notes $Notes
}

$BeforeRoot = Get-ChildItem -LiteralPath $Root -Force | Sort-Object Name | Select-Object Name,FullName,PSIsContainer

# Route obvious loose scripts.
$ScriptNames = @(
    "APPLY_ROOT_RESIDUE_CLEANUP_AND_INJECT_GOOD_20260604.ps1",
    "WRITE_ROW_001_AUTHORITY_LANGUAGE_SURFACE_ADJUDICATION_V1.ps1",
    "WRITE_ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_V1_1.ps1",
    "WRITE_ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_V1_2.ps1",
    "WRITE_ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_V1.ps1",
    "WRITE_ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_V1_2.ps1",
    "WRITE_ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_V1_3.ps1",
    "WRITE_ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_V1.ps1",
    "WRITE_ROW_001_STATIC_CODE_SHAPE_FIXTURE_PACKET_V1_2.ps1",
    "WRITE_ROW_001_UNKNOWN_AUTHORITY_ROWS_DISPOSITION_V1.ps1",
    "WRITE_ROW_001_UNKNOWN_AUTHORITY_ROWS_FINAL_CLOSEOUT_V1.ps1"
)

foreach ($name in $ScriptNames) {
    $src = Join-Path $Root $name
    $dest = if ($name -like "APPLY_ROOT_RESIDUE*") { Join-Path $UsedRunners $name } else { Join-Path $ToolParking $name }
    Move-Or-Park -Name $name -Kind "FILE" -Classification "WRONG_LANE_SCRIPT_OR_RUNNER" -SourcePath $src -DestinationPath $dest -ReturnTrigger "Return only when Row 001 writer/runner provenance is reviewed or a Code Gate/harness task explicitly needs it." -Notes "Loose root script moved out of root; not executed."
}

# Route loose source note.
Move-Or-Park -Name "rawnotes.txt" -Kind "FILE" -Classification "WRONG_LANE_SOURCE_NOTE" -SourcePath (Join-Path $Root "rawnotes.txt") -DestinationPath (Join-Path $SourceParking "rawnotes.txt") -ReturnTrigger "Return when source-note intake/review is the active task." -Notes "Loose source note parked in source research notes; not deleted."

# Park large/unclear package folders, preserving them for future review/injection.
$PackageFolders = @(
    "HELPER_CAPABILITY_SYSTEM_V2_3_HOUSE_HARNESS_PACK_V0_2",
    "HELPER_CAPABILITY_SYSTEM_V2_3_INDIVIDUAL_PACKAGES_ONLY_V0_2 - 1",
    "HELPER_CONTEXT_AUTHORITY_PROOF_RESEARCH_PACK_20260531",
    "HOUSE_DOCK_CONTROL_ROOM",
    "HOUSE_DOCK_CONTROL_ROOM_SAVE_PACKET_V1",
    "LOWER_CAUSE_SEARCH_METHOD_LAB_20260601",
    "PARKING_GATE_CONTROL_SURFACE_V1"
)

foreach ($name in $PackageFolders) {
    Move-Or-Park -Name $name -Kind "FOLDER" -Classification "UNCLEAR_OR_LARGE_PACKAGE_PARK_WITH_RETURN_TRIGGER" -SourcePath (Join-Path $Root $name) -DestinationPath (Join-Path $PackageParking $name) -ReturnTrigger "Review only as an explicit future package-injection task; do not treat parked package as installed or ready." -Notes "Large/unclear root package parked to stop root workspace contamination; not claimed as injected/proved."
}

# Write package parking README.
$ReadmePath = Join-Path $PackageParking "README_RETURN_TRIGGER.md"
$Readme = @"
# Root Legacy Residue Phase 2 Parking

RunId: $RunId

These folders were moved out of Desktop\123 root because root cleanup was blocked by old/legacy package residue.

They are parked, not installed.

Return trigger:

Review only as an explicit future package-injection task. For each package, extract good material, test/prove it, inject into the correct durable project lane, update paths/pointers/manifests/status, or reject/park with reason.

Do not treat these parked packages as ready or live project surfaces.
"@
Set-Content -LiteralPath $ReadmePath -Value $Readme -Encoding UTF8 -NoNewline
$ReadmeSha = Get-Sha256OrBlank -Path $ReadmePath

# Final root inventory.
$AllowedRootNames = @(
    "Jxhnny_Kl33N_Seedz",
    "COMMAND_CENTER",
    "_CHAT_DROPS",
    "_LOCAL_CUSTODY_AND_RECEIPTS",
    "_MEDIA_ASSETS",
    "_MISC_DRAWER",
    "_SOURCE_RESEARCH_NOTES",
    "_TOOLS_AND_SCRIPTS",
    "_TRANSCRIPT_CUSTODY",
    "desktop.ini"
)

$AfterRoot = Get-ChildItem -LiteralPath $Root -Force | Sort-Object Name | Select-Object Name,FullName,PSIsContainer
$Unexpected = @()
foreach ($x in $AfterRoot) {
    if ($x.Name -notin $AllowedRootNames) { $Unexpected += $x.FullName }
}

$FinalRootVerdict = if ($Unexpected.Count -eq 0) { "ROOT_NO_LOOSE_FILES_CHECK_PASS" } else { "ROOT_UNEXPECTED_DIRECT_ITEMS_REMAIN_FOR_REVIEW" }

$ManifestPath = Join-Path $ProofDir "ROOT_LEGACY_RESIDUE_PHASE2_MANIFEST_20260604_$RunId.csv"
$Rows | Export-Csv -LiteralPath $ManifestPath -NoTypeInformation -Encoding UTF8
$ManifestSha = Get-Sha256OrBlank -Path $ManifestPath

$UnexpectedText = if ($Unexpected.Count -eq 0) { "None." } else { ($Unexpected -join "`n") }

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
        if ([string]::IsNullOrWhiteSpace($GitStatusShort)) { $GitStatusShort = "CLEAN" }
    }
}
finally { Pop-Location }

$ReceiptPath = Join-Path $ProofDir "ROOT_LEGACY_RESIDUE_PHASE2_RECEIPT_20260604_$RunId.txt"
$Receipt = @"
ROOT_LEGACY_RESIDUE_PHASE2_RECEIPT_20260604
RunId: $RunId

Verdict:
APPLY_ROOT_LEGACY_RESIDUE_PHASE2_DONE
ROOT_LEGACY_SCRIPTS_ROUTED
ROOT_LEGACY_PACKAGES_PARKED_WITH_RETURN_TRIGGER
$FinalRootVerdict
TARGET_HELPER_NOT_RUN
NO_TARGET_HELPER_RESULT_EXISTS
NO_COMMIT_NO_PUSH

Boundary:
- Obvious loose legacy scripts/source notes/packages were moved out of root.
- Large/unclear packages were parked with return trigger, not claimed as installed.
- No file deletion.
- No target helper execution.
- No generated runner execution.
- No zip creation.
- No commit or push.

ManifestPath: $ManifestPath
ManifestSha256: $ManifestSha

ParkingReadme: $ReadmePath
ParkingReadmeSha256: $ReadmeSha

UnexpectedDirectRootItems:
$UnexpectedText

GitHead: $GitHead
GitOriginMain: $GitOrigin
HeadEqualsOrigin: $HeadEqualsOrigin
GitStatusShort:
$GitStatusShort
"@
Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8 -NoNewline
$ReceiptSha = Get-Sha256OrBlank -Path $ReceiptPath

if (Test-Path -LiteralPath $StatusPath) {
    $Append = @"

## Root Legacy Residue Phase 2 — 2026-06-04

- RunId: `$RunId`
- Receipt: `PROOF_HISTORY/ROOT_LEGACY_RESIDUE_PHASE2_RECEIPT_20260604_$RunId.txt`
- ReceiptSha256: `$ReceiptSha`
- Manifest: `PROOF_HISTORY/ROOT_LEGACY_RESIDUE_PHASE2_MANIFEST_20260604_$RunId.csv`
- ManifestSha256: `$ManifestSha`
- Verdict: `APPLY_ROOT_LEGACY_RESIDUE_PHASE2_DONE / ROOT_LEGACY_PACKAGES_PARKED_WITH_RETURN_TRIGGER / $FinalRootVerdict`
- Boundary: old/legacy root residue parked or routed; packages not installed; no target helper run; no commit/push by script.
"@
    Add-Content -LiteralPath $StatusPath -Value $Append -Encoding UTF8
}

Write-Host "ROOT_LEGACY_RESIDUE_PHASE2_COMPLETE"
Write-Host "RunId: $RunId"
Write-Host "ManifestPath: $ManifestPath"
Write-Host "ManifestSha256: $ManifestSha"
Write-Host "ReceiptPath: $ReceiptPath"
Write-Host "ReceiptSha256: $ReceiptSha"
Write-Host "FinalRootVerdict: $FinalRootVerdict"
Write-Host "TargetHelperStatus: TARGET_HELPER_NOT_RUN / NO_TARGET_HELPER_RESULT_EXISTS"
Write-Host "Git: NO_COMMIT_NO_PUSH"
if ($Unexpected.Count -gt 0) {
    Write-Host "UnexpectedDirectRootItems:"
    $Unexpected | ForEach-Object { Write-Host $_ }
}
