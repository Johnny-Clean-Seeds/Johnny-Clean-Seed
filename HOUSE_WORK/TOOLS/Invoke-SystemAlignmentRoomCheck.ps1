[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string]$RoomRoot
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
}
if ([string]::IsNullOrWhiteSpace($RoomRoot)) {
    $RoomRoot = Join-Path $RepoRoot 'HOUSE_WORK\SYSTEM_ALIGNMENT_ROOM\HELPER_LOGIC_RULE_MIRROR_20260531'
}

$DesktopRoot = Split-Path -Parent $RepoRoot
$ToolName = 'SYSTEM_ALIGNMENT_CHECK_V1_20260531'
$ReportPath = Join-Path $RoomRoot "${ToolName}_REPORT.md"
$ReceiptPath = Join-Path $RoomRoot "${ToolName}_RECEIPT.txt"

function Get-Sha256OrMissing {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 'MISSING' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-RequiredPath {
    param(
        [System.Collections.Generic.List[object]]$List,
        [string]$Name,
        [string]$Path,
        [string]$Role,
        [string]$Boundary
    )
    $exists = Test-Path -LiteralPath $Path
    $kind = if ($exists) {
        if (Test-Path -LiteralPath $Path -PathType Container) { 'Directory' } else { 'File' }
    } else {
        'Missing'
    }
    $sha = if ($kind -eq 'File') { Get-Sha256OrMissing -Path $Path } else { $kind }
    $List.Add([pscustomobject]@{
        Name = $Name
        Path = $Path
        Role = $Role
        Boundary = $Boundary
        Exists = $exists
        Kind = $kind
        Sha256 = $sha
    }) | Out-Null
}

New-Item -ItemType Directory -Force -Path $RoomRoot | Out-Null

$ideaRun = Join-Path $RepoRoot 'HOUSE_WORK\IDEA_CONCEPT_COLLECTION_ROOM\PAST_WEEK_20260524_20260531\RUN_20260531_141441'
$themeCsv = Join-Path $ideaRun 'PAST_WEEK_IDEA_CONCEPT_SYNTHESIS_V1_20260531_THEME_CLUSTER_LEDGER.csv'
$sourceRoomCsv = Join-Path $ideaRun 'PAST_WEEK_IDEA_CONCEPT_SYNTHESIS_V1_20260531_SOURCE_ROOM_SUMMARY.csv'

$required = [System.Collections.Generic.List[object]]::new()
Add-RequiredPath $required 'Start Here Current House Ledger' (Join-Path $RepoRoot 'START_HERE_CURRENT_HOUSE_LEDGER.md') 'front door pointer' 'pointer only'
Add-RequiredPath $required 'Active Anchor' (Join-Path $RepoRoot 'ACTIVE_ANCHOR.txt') 'current active anchor' 'support only'
Add-RequiredPath $required 'Front Door Ledger' (Join-Path $RepoRoot 'HOUSE_WORK\WORK_SHED\INDEXES\LIVING_SYSTEM_FRONT_DOOR_LEDGER_V1_4_20260530.md') 'entry route' 'not doctrine'
Add-RequiredPath $required 'Recursive House Flow Spine' (Join-Path $RepoRoot 'HOUSE_WORK\WORK_SHED\INDEXES\RECURSIVE_HOUSE_FLOW_SPINE_V1_20260530.md') 'shared mirror loop' 'not doctrine'
Add-RequiredPath $required 'Chat Source URL Ledger Map Key' (Join-Path $RepoRoot 'HOUSE_WORK\WORK_SHED\INDEXES\LIVING_SYSTEM_CHAT_SOURCE_URL_LEDGER_MAP_KEY_V1_5_20260530.md') 'chat load compressor' 'not authority'
Add-RequiredPath $required 'Claim Engine Pointer' (Join-Path $RepoRoot 'BRAIN_LEARNING\CLAIM_ENGINE_V2_2_CANDIDATE_POINTER_20260531.md') 'language gate pointer' 'candidate support'
Add-RequiredPath $required 'Helper Capability Pointer' (Join-Path $RepoRoot 'BRAIN_LEARNING\HELPER_CAPABILITY_SYSTEM_V2_3_CANDIDATE_POINTER_20260531.md') 'power gate pointer' 'candidate support'
Add-RequiredPath $required 'Bridge Harness Route Index' (Join-Path $RepoRoot 'HOUSE_WORK\WORK_SHED\INDEXES\CLAIM_CAPABILITY_BRIDGE_HARNESS_ROUTE_INDEX_20260531.md') 'bridge route' 'candidate support'
Add-RequiredPath $required 'Front Door Wiring TODO' (Join-Path $RepoRoot 'HOUSE_WORK\TODO\CLAIM_CAPABILITY_FRONT_DOOR_WIRING_NEXT_WORK_20260531.md') 'next bite' 'not adoption'
Add-RequiredPath $required 'Shape Contract Gate Rule' (Join-Path $RepoRoot 'BRAIN_LEARNING\GENERATED_HELPER_SHAPE_CONTRACT_GATE_RULE_20260531.md') 'generated helper lower-layer guard' 'support standard'
Add-RequiredPath $required 'Proof Surface Class Rule' (Join-Path $RepoRoot 'BRAIN_LEARNING\HELPER_PROOF_SURFACE_CLASS_BEFORE_PAIR_STRENGTH_RULE_20260531.md') 'receipt proof distinction' 'does not approve save writers'
Add-RequiredPath $required 'Lower-Layer Diagnosis Rule' (Join-Path $RepoRoot 'BRAIN_LEARNING\KNOW_DONT_THINK_LOWER_LAYER_DIAGNOSIS_RULE_20260531.md') 'evidence before descent' 'no speculative repair'
Add-RequiredPath $required 'Idea Concept Master Index' (Join-Path $ideaRun 'PAST_WEEK_IDEA_CONCEPT_SYNTHESIS_V1_20260531_MASTER_INDEX.md') 'past-week concept map' 'support collection'
Add-RequiredPath $required 'Theme Cluster Ledger' $themeCsv 'theme counts' 'support collection'
Add-RequiredPath $required 'Source Room Summary' $sourceRoomCsv 'local/repo source rooms' 'support collection'
Add-RequiredPath $required 'Local Current Plan' (Join-Path $DesktopRoot '_LOCAL_CUSTODY_AND_RECEIPTS\ROOT_LOOSE_DOCS_20260531_033722\CURRENT_PLAN.txt') 'game plan source' 'context only'
Add-RequiredPath $required 'Local Helper Capability Pack Readme' (Join-Path $DesktopRoot 'HELPER_CAPABILITY_SYSTEM_V2_3_HOUSE_HARNESS_PACK_V0_2\00_START_HERE\README_START_HERE.md') 'local helper-file support' 'candidate support, not tested'
Add-RequiredPath $required 'Local Helper Capability Coverage Matrix' (Join-Path $DesktopRoot 'HELPER_CAPABILITY_SYSTEM_V2_3_HOUSE_HARNESS_PACK_V0_2\06_TEST_HARNESS\COVERAGE_MATRIX_V0_2.md') 'coverage ideas' 'candidate support, not tested'
Add-RequiredPath $required 'toyBOX Roadmap Context' (Join-Path $DesktopRoot '_LOCAL_CUSTODY_AND_RECEIPTS\ROOT_LOOSE_DOCS_20260531_033722\PROJECT_ROADMAP_AND_PHASE_LOCK.txt') 'separate project context' 'ACTIVE_INSTALL_PACKAGE controls implementation'

$themes = @()
if (Test-Path -LiteralPath $themeCsv -PathType Leaf) {
    $themes = @(Import-Csv -LiteralPath $themeCsv)
}

$rootFiles = @(Get-ChildItem -LiteralPath $DesktopRoot -File -Force | Select-Object Name, Length, Attributes)
$missing = @($required | Where-Object { -not $_.Exists })
$requiredRows = foreach ($row in $required) {
    "| $($row.Name) | $($row.Kind) | $($row.Exists) | $($row.Role) | $($row.Boundary) |"
}
$themeRows = foreach ($row in $themes) {
    "| $($row.Theme) | $($row.UniqueConcepts) | $($row.UseNow) | $($row.NextWork) | $($row.WantLater) |"
}
$rootRows = foreach ($row in $rootFiles) {
    "| $($row.Name) | $($row.Length) | $($row.Attributes) |"
}

$verdict = if ($missing.Count -eq 0) { 'ALIGNMENT_SURFACES_PRESENT' } else { 'MISSING_ALIGNMENT_SURFACES' }

$report = @"
# System Alignment Check V1

Date: 2026-05-31
Status: VERIFICATION REPORT / NOT DOCTRINE
WorkKey: HELPER-LOGIC-RULE-MIRROR-20260531-V1

## Verdict

$verdict

Missing required surfaces: $($missing.Count)

## Required Surfaces

| Surface | Kind | Exists | Role | Boundary |
|---|---|---:|---|---|
$($requiredRows -join "`r`n")

## Concept Theme Counts

| Theme | UniqueConcepts | UseNow | NextWork | WantLater |
|---|---:|---:|---:|---:|
$($themeRows -join "`r`n")

## Desktop Root Files

| Name | Length | Attributes |
|---|---:|---|
$($rootRows -join "`r`n")

## Current Join

The current join is:

    Front Door -> Claim split -> Capability legality -> Helper/task boundary -> Return contract -> Receiver assay -> Disposition

## Next Bite

Build `CLAIM-CAPABILITY-FRONT-DOOR-WIRING-20260531-V1` as candidate support only.

## Boundary

This report does not adopt doctrine, rewrite ACTIVE_GUIDES, rewrite CURRENT_TRUTH_INDEX, install watchers, install automation, retire stale routes, or grant helper authority.
"@

Set-Content -LiteralPath $ReportPath -Value $report -Encoding UTF8

$reportHash = Get-Sha256OrMissing -Path $ReportPath
$receipt = @"
SYSTEM_ALIGNMENT_CHECK_V1_20260531_RECEIPT
Status: $verdict
RepoRoot: $RepoRoot
RoomRoot: $RoomRoot
RequiredSurfaces: $($required.Count)
MissingRequiredSurfaces: $($missing.Count)
ThemeRows: $($themes.Count)
DesktopRootFileCount: $($rootFiles.Count)
Report: $ReportPath
ReportSha256: $reportHash
Boundary: verification only; no adoption; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX; no watcher; no automation; no helper authority.
"@

Set-Content -LiteralPath $ReceiptPath -Value $receipt -Encoding UTF8

Write-Host 'SYSTEM_ALIGNMENT_CHECK_COMPLETE'
Write-Host "Status: $verdict"
Write-Host "MissingRequiredSurfaces: $($missing.Count)"
Write-Host "Report: $ReportPath"
Write-Host "ReportSha256: $reportHash"
Write-Host "Receipt: $ReceiptPath"
