Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608"
$FinalVerdict = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_READY_WITH_SCOPE_LIMIT_NOTE"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_ROUGH_LOCAL_IMPORT_20260608"
$AfterImportNextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "521d4dd79b022592b143e08696138c7cf7611898"

$Expected = [ordered]@{
    NextObjectSelectorReport = [ordered]@{
        Path = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608.md"
        Sha256 = "15431564C9AC544972669D29641031B04425077CA6848C4CD73432EBFDCF942A"
    }
    NextObjectSelectorReceipt = [ordered]@{
        Path = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_RECEIPT_20260608.txt"
        Sha256 = "ACB984B6CCEDC16B8DB1EFC98F7B94FC0BAB61629A9218A6173A566AE513017F"
    }
    LaneCloseoutCard = [ordered]@{
        Path = Join-Path $LaneDir "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
        Sha256 = "BA9DABB8BF4CEA36A742C2F393FD4D3E9BD73D70C5A3EFE9273D43EAE956DD72"
    }
    LaneCloseoutRoughLocalLedger = [ordered]@{
        Path = Join-Path $LaneDir "ROUGH_LOCAL__HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
        Sha256 = "38505DAE4DD4292CDBFA8441E78952F57D06BF94B7B4B09BCE2F4F0E37D1FF2F"
    }
    LaneCloseoutRoughLocalReceipt = [ordered]@{
        Path = Join-Path $LaneDir "ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608.txt"
        Sha256 = "3E20324A2B3D8B8608C3FA35012FF65D3CC6965AA45A26B891CBC8C6A83017C8"
    }
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Blocker {
    param([string]$Message)
    $script:Blockers.Add($Message) | Out-Null
}

function Get-RootFileClass {
    param(
        [Parameter(Mandatory=$true)][System.IO.FileInfo]$File,
        [Parameter(Mandatory=$true)][string]$CurrentScriptPath
    )

    if ($File.FullName -eq $CurrentScriptPath) {
        return "CURRENT_RUNNER_SCRIPT_EXCLUDE_FROM_HELD_DECISION"
    }

    if ($File.Name -ieq "desktop.ini") {
        return "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE"
    }

    if ($File.Extension -ieq ".ps1") {
        return "ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE_WITHOUT_REVIEW"
    }

    if ($File.Name -like "PLANETARY_HOUSE_GATE_MASTER_INDEX_WITH_INTAKE_TOOLBELT*") {
        return "KNOWN_SOURCE_AUTHORITY_OBJECT_REVIEW_ONLY_NO_REWRITE"
    }

    if ($File.Length -eq 0) {
        return "ZERO_BYTE_ROOT_FILE_REVIEW_ONLY_NO_DELETE"
    }

    return "ROOT_HELD_CANDIDATE_NEEDS_READ_ONLY_REVIEW"
}

$Blockers = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]

Write-Host "=== ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY PREP CARD ==="

if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
    Add-Blocker "ROOT_NOT_FOUND: $Root"
}
if (-not (Test-Path -LiteralPath $LaneDir -PathType Container)) {
    Add-Blocker "LANE_DIR_NOT_FOUND: $LaneDir"
}
if (-not (Test-Path -LiteralPath $GitTop -PathType Container)) {
    Add-Blocker "GIT_TOP_NOT_FOUND: $GitTop"
}

foreach ($Key in $Expected.Keys) {
    $Path = [string]$Expected[$Key].Path
    $Want = [string]$Expected[$Key].Sha256

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Blocker "REQUIRED_FILE_MISSING: $Key :: $Path"
        continue
    }

    $Got = Get-Sha256 -Path $Path
    if ($Got -ne $Want) {
        Add-Blocker "SHA256_MISMATCH: $Key :: expected $Want :: got $Got :: path $Path"
        continue
    }

    $VerifiedLines.Add("$Key SHA256 confirmed: $Got") | Out-Null
}

$SelectorText = ""
if (Test-Path -LiteralPath $Expected.NextObjectSelectorReport.Path -PathType Leaf) {
    $SelectorText = Get-Content -LiteralPath $Expected.NextObjectSelectorReport.Path -Raw
}

$RequiredSelectorSignals = @(
    "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_READY_WITH_SCOPE_LIMIT_NOTE",
    "selected_next_build_chunk: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608",
    "The next known open house problem is the held root group",
    "read-only prep, not cleanup or routing",
    "no cleanup",
    "no delete",
    "no rename",
    "no move",
    "no helper execution",
    "no source replay",
    "no doctrine promotion",
    "no push"
)

foreach ($Signal in $RequiredSelectorSignals) {
    if ($SelectorText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "SELECTOR_SIGNAL_MISSING: $Signal"
    }
}

$GitHead = ""
$GitStatus = ""

if (Test-Path -LiteralPath $GitTop -PathType Container) {
    $GitHead = (& git -C $GitTop rev-parse HEAD 2>&1)
    if ($LASTEXITCODE -ne 0) {
        Add-Blocker "GIT_HEAD_READ_FAILED: $GitHead"
    } elseif ($GitHead.Trim() -ne $ExpectedGitHead) {
        Add-Blocker "GIT_HEAD_MISMATCH: expected $ExpectedGitHead :: got $($GitHead.Trim())"
    }

    $GitStatus = (& git -C $GitTop status --short 2>&1)
    if ($LASTEXITCODE -ne 0) {
        Add-Blocker "GIT_STATUS_READ_FAILED: $GitStatus"
    } elseif (($GitStatus | Out-String).Trim().Length -ne 0) {
        Add-Blocker "GIT_STATUS_NOT_CLEAN: $($GitStatus | Out-String)"
    }
}

$ReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md"
$ReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt"

if (Test-Path -LiteralPath $ReportPath -PathType Leaf) {
    Add-Blocker "OUTPUT_REPORT_ALREADY_EXISTS_NO_OVERWRITE: $ReportPath"
}
if (Test-Path -LiteralPath $ReceiptPath -PathType Leaf) {
    Add-Blocker "OUTPUT_RECEIPT_ALREADY_EXISTS_NO_OVERWRITE: $ReceiptPath"
}

$RootFileRows = New-Object System.Collections.Generic.List[object]

if (Test-Path -LiteralPath $Root -PathType Container) {
    $RootFiles = @(Get-ChildItem -LiteralPath $Root -File -Force | Sort-Object Name)

    foreach ($File in $RootFiles) {
        $Class = Get-RootFileClass -File $File -CurrentScriptPath $PSCommandPath
        $Sha = ""
        try {
            $Sha = Get-Sha256 -Path $File.FullName
        } catch {
            $Sha = "HASH_FAILED: $($_.Exception.Message)"
        }

        $IncludeInHeldDecision = "YES"
        if ($Class -eq "CURRENT_RUNNER_SCRIPT_EXCLUDE_FROM_HELD_DECISION") {
            $IncludeInHeldDecision = "NO"
        }
        if ($Class -eq "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE") {
            $IncludeInHeldDecision = "NO"
        }

        $RootFileRows.Add([pscustomobject]@{
            Name = $File.Name
            FullName = $File.FullName
            SizeBytes = $File.Length
            LastWriteTime = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
            Sha256 = $Sha
            PrepClass = $Class
            IncludeInHeldDecision = $IncludeInHeldDecision
        }) | Out-Null
    }
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND BEFORE WRITE ==="
    foreach ($Blocker in $Blockers) {
        Write-Host $Blocker
    }
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_BLOCKED"
    exit 2
}

$ObservedRootFileCount = $RootFileRows.Count
$HeldDecisionCandidateCount = @($RootFileRows | Where-Object { $_.IncludeInHeldDecision -eq "YES" }).Count
$ScriptHeldCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE_WITHOUT_REVIEW" }).Count
$DesktopIniCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE" }).Count
$ZeroByteCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "ZERO_BYTE_ROOT_FILE_REVIEW_ONLY_NO_DELETE" }).Count
$SourceObjectCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "KNOWN_SOURCE_AUTHORITY_OBJECT_REVIEW_ONLY_NO_REWRITE" }).Count
$CurrentRunnerExcludedCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "CURRENT_RUNNER_SCRIPT_EXCLUDE_FROM_HELD_DECISION" }).Count

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$ReportLines = New-Object System.Collections.Generic.List[string]

$ReportLines.Add("# ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY PREP CARD 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: READ_ONLY_PREP_CARD / HEAVY_BOUNDARY_CHECK / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Prepare the next root-held group review without moving, deleting, renaming, routing, executing, rewriting, committing, pushing, or promoting anything.") | Out-Null
$ReportLines.Add("This prep card records the current top-level root file surface as observed at run time and sets the next action as read-only review.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Verified load-bearing evidence") | Out-Null
$ReportLines.Add("") | Out-Null

foreach ($Line in $VerifiedLines) {
    $ReportLines.Add("- $Line") | Out-Null
}

$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Git state") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- git_top: $GitTop") | Out-Null
$ReportLines.Add("- git_head_confirmed: $($GitHead.Trim())") | Out-Null
$ReportLines.Add("- git_status_confirmed: CLEAN") | Out-Null
$ReportLines.Add("- git_commit_or_push_done_by_this_prep_card: NO") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Current root top-level file snapshot") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- observed_root_top_level_file_count: $ObservedRootFileCount") | Out-Null
$ReportLines.Add("- held_decision_candidate_count: $HeldDecisionCandidateCount") | Out-Null
$ReportLines.Add("- root_level_script_held_not_execute_count: $ScriptHeldCount") | Out-Null
$ReportLines.Add("- desktop_ini_leave_in_place_count: $DesktopIniCount") | Out-Null
$ReportLines.Add("- zero_byte_review_only_no_delete_count: $ZeroByteCount") | Out-Null
$ReportLines.Add("- known_source_authority_object_review_only_count: $SourceObjectCount") | Out-Null
$ReportLines.Add("- current_runner_script_excluded_count: $CurrentRunnerExcludedCount") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Important: this snapshot is current-at-run-time. It may include newly generated runner scripts in root. It does not replace older reported 15-held count by itself. The next review must decide from the observed file rows, not from memory.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Observed root file rows") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| Name | SizeBytes | SHA256 | PrepClass | IncludeInHeldDecision |") | Out-Null
$ReportLines.Add("|---|---:|---|---|---|") | Out-Null

foreach ($Row in $RootFileRows) {
    $SafeName = ($Row.Name -replace "\|", "\|")
    $ReportLines.Add("| $SafeName | $($Row.SizeBytes) | `$($Row.Sha256)` | $($Row.PrepClass) | $($Row.IncludeInHeldDecision) |") | Out-Null
}

$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next review rules") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("The next review may read only the observed root-level held candidates and produce a route-or-hold decision table.") | Out-Null
$ReportLines.Add("The next review must not move, delete, rename, route, execute, rewrite, commit, push, or promote anything.") | Out-Null
$ReportLines.Add("The next review must separate ROOT_HELD_CANDIDATE, ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE, WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE, ZERO_BYTE_REVIEW_ONLY, and KNOWN_SOURCE_AUTHORITY_OBJECT_REVIEW_ONLY.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Stop lines carried forward") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- no cleanup") | Out-Null
$ReportLines.Add("- no delete") | Out-Null
$ReportLines.Add("- no rename") | Out-Null
$ReportLines.Add("- no move") | Out-Null
$ReportLines.Add("- no routing yet") | Out-Null
$ReportLines.Add("- no helper execution") | Out-Null
$ReportLines.Add("- no source replay") | Out-Null
$ReportLines.Add("- no source rewrite") | Out-Null
$ReportLines.Add("- no doctrine promotion") | Out-Null
$ReportLines.Add("- no commit or push from this prep card") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next selected action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("next_build_chunk_selected: $NextBuildChunk") | Out-Null
$ReportLines.Add("after_import_next_build_chunk_selected: $AfterImportNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## DoesNotProve") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This prep card proves only that the current root-held group review is prepared with a read-only snapshot and stop lines. It does not prove the root files are safe, public-safe, stale, trash, route-ready, delete-ready, move-ready, source-ready, helper-ready, doctrine-ready, committed, pushed, or cleaned.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "observed_root_top_level_file_count: $ObservedRootFileCount",
    "held_decision_candidate_count: $HeldDecisionCandidateCount",
    "root_level_script_held_not_execute_count: $ScriptHeldCount",
    "desktop_ini_leave_in_place_count: $DesktopIniCount",
    "zero_byte_review_only_no_delete_count: $ZeroByteCount",
    "known_source_authority_object_review_only_count: $SourceObjectCount",
    "current_runner_script_excluded_count: $CurrentRunnerExcludedCount",
    "git_top: $GitTop",
    "git_head_confirmed: $($GitHead.Trim())",
    "git_status_confirmed: CLEAN",
    "git_commit_or_push_done: NO",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "next_build_chunk_selected: $NextBuildChunk",
    "after_import_next_build_chunk_selected: $AfterImportNextBuildChunk",
    "does_not_prove: root files safe; cleanup approved; movement approved; deletion approved; routing approved; source replay approved; helper execution approved; doctrine promotion approved; push approved",
    "final_verdict: $FinalVerdict"
)

$ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptSha = Get-Sha256 -Path $ReceiptPath

Write-Host "=== ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY PREP CARD COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "observed_root_top_level_file_count: $ObservedRootFileCount"
Write-Host "held_decision_candidate_count: $HeldDecisionCandidateCount"
Write-Host "root_level_script_held_not_execute_count: $ScriptHeldCount"
Write-Host "desktop_ini_leave_in_place_count: $DesktopIniCount"
Write-Host "zero_byte_review_only_no_delete_count: $ZeroByteCount"
Write-Host "known_source_authority_object_review_only_count: $SourceObjectCount"
Write-Host "current_runner_script_excluded_count: $CurrentRunnerExcludedCount"
Write-Host "git_head_confirmed: $($GitHead.Trim())"
Write-Host "git_status_confirmed: CLEAN"
Write-Host "git_commit_or_push_done: NO"
Write-Host "files_moved_count: 0"
Write-Host "files_deleted_count: 0"
Write-Host "files_renamed_count: 0"
Write-Host "files_routed_count: 0"
Write-Host "files_executed_count: 0"
Write-Host "next_build_chunk_selected: $NextBuildChunk"
Write-Host "after_import_next_build_chunk_selected: $AfterImportNextBuildChunk"
Write-Host "final_verdict: $FinalVerdict"
