Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_20260608"
$FinalVerdict = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_READY_WITH_STRESS_BENCH_PASS"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_ROUGH_LOCAL_IMPORT_20260608"
$AfterImportNextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "1548fab246f0326041952107581b60e70669828f"

$OldPrepCardPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md"
$OldPrepCardSha = "83967BAB53B170BAD53AEAC21BE042B6129B7C13B9934AC110D729011E1B6F8E"

$OldPrepReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt"
$OldPrepReceiptSha = "73AA76F428746BC7C6971F928AF580FEC9AA590627141261B52A66419C4F6AE7"

$OldPrepRoughLocalPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md"
$OldPrepRoughLocalSha = "23BC00D620F2340918B9650916A036E65D5062E20214FB5582533E501B821ABC"

$OldPrepRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt"
$OldPrepRoughReceiptSha = "5A60A3AECBCDAE882989F616ABBC190A78E6F1BFFA4DDEDA8165CDD8AD5CB4BF"

$NextObjectSelectorPath = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608.md"
$NextObjectSelectorSha = "15431564C9AC544972669D29641031B04425077CA6848C4CD73432EBFDCF942A"

$ReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_20260608.md"
$ReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_RECEIPT_20260608.txt"
$StressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_STRESS_BENCH_20260608.md"

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Blocker {
    param([string]$Message)
    $script:Blockers.Add($Message) | Out-Null
}

function Escape-Cell {
    param([AllowNull()][string]$Value)
    if ($null -eq $Value) { return "" }
    return (($Value -replace "\|", "\|") -replace "`r?`n", " ")
}

function Get-RootFileClass {
    param(
        [Parameter(Mandatory=$true)][System.IO.FileInfo]$File,
        [Parameter(Mandatory=$true)][string]$CurrentScriptPath
    )

    if ($File.FullName -ieq $CurrentScriptPath) {
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

function Parse-CorrectPrepTableRows {
    param([Parameter(Mandatory=$true)][string[]]$Lines)

    $Rows = New-Object System.Collections.Generic.List[object]

    foreach ($Line in $Lines) {
        if ($Line -notmatch '^\|') { continue }
        if ($Line -match '^\|---') { continue }
        if ($Line -match '^\| Name \|') { continue }

        $Parts = $Line -split '\|'
        if ($Parts.Count -lt 6) { continue }

        $Name = $Parts[1].Trim()
        $SizeText = $Parts[2].Trim()
        $Sha = $Parts[3].Trim()
        $PrepClass = $Parts[4].Trim()
        $Include = $Parts[5].Trim()

        if ($Name.Length -eq 0) { continue }

        if ($SizeText -notmatch '^\d+$') {
            throw "TABLE_PARSE_BAD_SIZE_FIELD: $Line"
        }

        if ($Sha -notmatch '^[A-F0-9]{64}$') {
            throw "TABLE_PARSE_BAD_SHA_FIELD: $Line"
        }

        if ($Include -notin @("YES", "NO")) {
            throw "TABLE_PARSE_BAD_INCLUDE_FIELD: $Line"
        }

        $Rows.Add([pscustomobject]@{
            Name = $Name
            SizeBytes = [int64]$SizeText
            Sha256 = $Sha
            PrepClass = $PrepClass
            IncludeInHeldDecision = $Include
        }) | Out-Null
    }

    return $Rows.ToArray()
}

$Blockers = New-Object System.Collections.Generic.List[string]
$StressResults = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]

Write-Host "=== ROOT HELD GROUP READ ONLY PREP CARD V0_2 WITH STRESS BENCH ==="

if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
    Add-Blocker "ROOT_NOT_FOUND: $Root"
}
if (-not (Test-Path -LiteralPath $LaneDir -PathType Container)) {
    Add-Blocker "LANE_DIR_NOT_FOUND: $LaneDir"
}
if (-not (Test-Path -LiteralPath $GitTop -PathType Container)) {
    Add-Blocker "GIT_TOP_NOT_FOUND: $GitTop"
}

$RequiredFiles = [ordered]@{
    OldPrepCard = [ordered]@{ Path = $OldPrepCardPath; Sha256 = $OldPrepCardSha }
    OldPrepReceipt = [ordered]@{ Path = $OldPrepReceiptPath; Sha256 = $OldPrepReceiptSha }
    OldPrepRoughLocal = [ordered]@{ Path = $OldPrepRoughLocalPath; Sha256 = $OldPrepRoughLocalSha }
    OldPrepRoughReceipt = [ordered]@{ Path = $OldPrepRoughReceiptPath; Sha256 = $OldPrepRoughReceiptSha }
    NextObjectSelector = [ordered]@{ Path = $NextObjectSelectorPath; Sha256 = $NextObjectSelectorSha }
}

foreach ($Key in $RequiredFiles.Keys) {
    $Path = [string]$RequiredFiles[$Key].Path
    $Want = [string]$RequiredFiles[$Key].Sha256

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

$OldPrepText = ""
if (Test-Path -LiteralPath $OldPrepCardPath -PathType Leaf) {
    $OldPrepText = Get-Content -LiteralPath $OldPrepCardPath -Raw
}

if ($OldPrepText -notmatch [regex]::Escape('$(@{')) {
    Add-Blocker "OLD_PREP_DEFECT_MARKER_NOT_FOUND_LITERAL_OBJECT_EXPRESSION"
}
if ($OldPrepText -notmatch "Sha256=[A-F0-9]{64}") {
    Add-Blocker "OLD_PREP_EMBEDDED_SHA_MARKER_NOT_FOUND"
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

foreach ($OutputPath in @($ReportPath, $ReceiptPath, $StressPath)) {
    if (Test-Path -LiteralPath $OutputPath -PathType Leaf) {
        Add-Blocker "OUTPUT_ALREADY_EXISTS_NO_OVERWRITE: $OutputPath"
    }
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND BEFORE SNAPSHOT ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_PREP_CARD_V0_2_BLOCKED_BEFORE_WRITE"
    exit 2
}

$RootFileRows = New-Object System.Collections.Generic.List[object]
$RootFiles = @(Get-ChildItem -LiteralPath $Root -File -Force | Sort-Object Name)

foreach ($File in $RootFiles) {
    $Class = Get-RootFileClass -File $File -CurrentScriptPath $PSCommandPath
    $Sha = Get-Sha256 -Path $File.FullName

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

$ObservedRootFileCount = $RootFileRows.Count
$HeldDecisionCandidateCount = @($RootFileRows | Where-Object { $_.IncludeInHeldDecision -eq "YES" }).Count
$ScriptHeldCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE_WITHOUT_REVIEW" }).Count
$DesktopIniCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE" }).Count
$ZeroByteCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "ZERO_BYTE_ROOT_FILE_REVIEW_ONLY_NO_DELETE" }).Count
$SourceObjectCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "KNOWN_SOURCE_AUTHORITY_OBJECT_REVIEW_ONLY_NO_REWRITE" }).Count
$CurrentRunnerExcludedCount = @($RootFileRows | Where-Object { $_.PrepClass -eq "CURRENT_RUNNER_SCRIPT_EXCLUDE_FROM_HELD_DECISION" }).Count

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$ReportLines = New-Object System.Collections.Generic.List[string]

$ReportLines.Add("# ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY PREP CARD V0_2 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: READ_ONLY_PREP_CARD / SUPERSEDES_BAD_SHA_TABLE / HEAVY_BOUNDARY_CHECK / STRESS_BENCHED / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Supersession reason") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This V0_2 prep card supersedes ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md because the old prep table wrote SHA cells as literal PowerShell object-expression text instead of plain 64-character SHA256 values.") | Out-Null
$ReportLines.Add("Old prep card path: $OldPrepCardPath") | Out-Null
$ReportLines.Add("Old prep card sha256: $OldPrepCardSha") | Out-Null
$ReportLines.Add("Old prep rough_local path: $OldPrepRoughLocalPath") | Out-Null
$ReportLines.Add("Old prep rough_local sha256: $OldPrepRoughLocalSha") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Re-snapshot the current root-held group with a clean, machine-readable table format before any route-or-hold review continues.") | Out-Null
$ReportLines.Add("This card does not move, delete, rename, route, execute, rewrite, commit, push, or promote anything.") | Out-Null
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
$ReportLines.Add("Important: this V0_2 snapshot is current-at-run-time. It intentionally supersedes the earlier 42-row prep snapshot because the earlier table format was defective.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Observed root file rows") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| Name | SizeBytes | SHA256 | PrepClass | IncludeInHeldDecision |") | Out-Null
$ReportLines.Add("|---|---:|---|---|---|") | Out-Null

$TableRowLines = New-Object System.Collections.Generic.List[string]

foreach ($Row in $RootFileRows) {
    $SafeName = Escape-Cell $Row.Name
    $Line = "| $SafeName | $($Row.SizeBytes) | $($Row.Sha256) | $($Row.PrepClass) | $($Row.IncludeInHeldDecision) |"
    $TableRowLines.Add($Line) | Out-Null
    $ReportLines.Add($Line) | Out-Null
}

$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Stress bench summary") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Stress bench must pass before this card is considered usable by the next read-only review.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next review rules") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("The next review may read only the V0_2 observed root-level held candidates and produce a route-or-hold decision table.") | Out-Null
$ReportLines.Add("The next review must not move, delete, rename, route, execute, rewrite, commit, push, or promote anything.") | Out-Null
$ReportLines.Add("The next review must separate ROOT_HELD_CANDIDATE, ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE, WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE, ZERO_BYTE_REVIEW_ONLY, CURRENT_RUNNER_EXCLUDE, and KNOWN_SOURCE_AUTHORITY_OBJECT_REVIEW_ONLY.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Stop lines carried forward") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- no cleanup") | Out-Null
$ReportLines.Add("- no delete") | Out-Null
$ReportLines.Add("- no rename") | Out-Null
$ReportLines.Add("- no move") | Out-Null
$ReportLines.Add("- no routing yet") | Out-Null
$ReportLines.Add("- no helper execution") | Out-Null
$ReportLines.Add("- no root script execution") | Out-Null
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
$ReportLines.Add("This V0_2 prep card proves only that the root-held group has been re-snapshotted with a clean table format and stress-bench checks. It does not prove the root files are safe, public-safe, stale, trash, route-ready, delete-ready, move-ready, source-ready, helper-ready, doctrine-ready, committed, pushed, or cleaned.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

# Stress bench: in-memory table shape tests before writing.
$ParsedRows = @(Parse-CorrectPrepTableRows -Lines $ReportLines.ToArray())

if ($ParsedRows.Count -ne $ObservedRootFileCount) {
    Add-Blocker "STRESS_FAIL_PARSED_ROW_COUNT: expected $ObservedRootFileCount :: got $($ParsedRows.Count)"
} else {
    $StressResults.Add("PASS parsed_row_count_matches_observed_root_file_count: $ObservedRootFileCount") | Out-Null
}

$BadMarkerRows = @($TableRowLines | Where-Object { $_ -match [regex]::Escape('$(@') -or $_ -match 'Sha256=' })
if ($BadMarkerRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_BAD_SHA_MARKER_PRESENT_IN_TABLE_ROWS: $($BadMarkerRows.Count)"
} else {
    $StressResults.Add("PASS no literal PowerShell object-expression markers in SHA cells") | Out-Null
}

$BadShaRows = @($ParsedRows | Where-Object { $_.Sha256 -notmatch '^[A-F0-9]{64}$' })
if ($BadShaRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_NON_PLAIN_SHA_ROWS: $($BadShaRows.Count)"
} else {
    $StressResults.Add("PASS all parsed SHA cells are plain 64-character uppercase hex") | Out-Null
}

$MismatchRows = New-Object System.Collections.Generic.List[string]
foreach ($Parsed in $ParsedRows) {
    $Original = $RootFileRows | Where-Object { $_.Name -eq $Parsed.Name } | Select-Object -First 1
    if ($null -eq $Original) {
        $MismatchRows.Add("NO_ORIGINAL_FOR_PARSED_ROW: $($Parsed.Name)") | Out-Null
        continue
    }

    if ($Original.Sha256 -ne $Parsed.Sha256) {
        $MismatchRows.Add("SHA_MISMATCH: $($Parsed.Name)") | Out-Null
    }

    if ([int64]$Original.SizeBytes -ne [int64]$Parsed.SizeBytes) {
        $MismatchRows.Add("SIZE_MISMATCH: $($Parsed.Name)") | Out-Null
    }
}

if ($MismatchRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_PARSED_ROWS_DO_NOT_MATCH_ROOT_SNAPSHOT: $($MismatchRows.Count)"
} else {
    $StressResults.Add("PASS parsed rows match root snapshot names, sizes, and hashes") | Out-Null
}

$CurrentRunnerRows = @($ParsedRows | Where-Object { $_.PrepClass -eq "CURRENT_RUNNER_SCRIPT_EXCLUDE_FROM_HELD_DECISION" })
if ($CurrentRunnerRows.Count -ne 1) {
    Add-Blocker "STRESS_FAIL_CURRENT_RUNNER_EXCLUDE_COUNT: expected 1 :: got $($CurrentRunnerRows.Count)"
} else {
    $StressResults.Add("PASS exactly one current runner script excluded from held decision") | Out-Null
}

$HostileBadRow = "| BAD.ps1 | 123 | `$(@{Name=BAD.ps1; Sha256=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA}.Sha256) | ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE_WITHOUT_REVIEW | YES |"
try {
    [void](Parse-CorrectPrepTableRows -Lines @($HostileBadRow))
    Add-Blocker "STRESS_FAIL_HOSTILE_OBJECT_EXPRESSION_ROW_WAS_ACCEPTED"
} catch {
    $StressResults.Add("PASS hostile object-expression SHA row rejected by strict parser") | Out-Null
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND DURING STRESS BENCH ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_PREP_CARD_V0_2_STRESS_BENCH_BLOCKED"
    exit 2
}

$StressLines = New-Object System.Collections.Generic.List[string]
$StressLines.Add("# ROOT HELD GROUP READ ONLY PREP CARD V0_2 STRESS BENCH 20260608") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("Status: STRESS_BENCH / FORMAT_VALIDATION / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH") | Out-Null
$StressLines.Add("Created: $Now") | Out-Null
$StressLines.Add("Active object: $ActiveObject") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("## Stress results") | Out-Null
$StressLines.Add("") | Out-Null

foreach ($Result in $StressResults) {
    $StressLines.Add("- $Result") | Out-Null
}

$StressLines.Add("") | Out-Null
$StressLines.Add("## Counts") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("- observed_root_top_level_file_count: $ObservedRootFileCount") | Out-Null
$StressLines.Add("- parsed_row_count: $($ParsedRows.Count)") | Out-Null
$StressLines.Add("- bad_marker_row_count: $($BadMarkerRows.Count)") | Out-Null
$StressLines.Add("- bad_sha_row_count: $($BadShaRows.Count)") | Out-Null
$StressLines.Add("- parsed_snapshot_mismatch_count: $($MismatchRows.Count)") | Out-Null
$StressLines.Add("- current_runner_excluded_count: $($CurrentRunnerRows.Count)") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("final_verdict: ROOT_HELD_GROUP_PREP_CARD_V0_2_STRESS_BENCH_PASS") | Out-Null

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$StressLines | Set-Content -LiteralPath $StressPath -Encoding UTF8
$StressSha = Get-Sha256 -Path $StressPath

$ReceiptLines = @(
    "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "supersedes_report_path: $OldPrepCardPath",
    "supersedes_report_sha256: $OldPrepCardSha",
    "supersession_reason: PREP_CARD_ROW_SHA_INTERPOLATION_BUG",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "stress_bench_path: $StressPath",
    "stress_bench_sha256: $StressSha",
    "observed_root_top_level_file_count: $ObservedRootFileCount",
    "held_decision_candidate_count: $HeldDecisionCandidateCount",
    "root_level_script_held_not_execute_count: $ScriptHeldCount",
    "desktop_ini_leave_in_place_count: $DesktopIniCount",
    "zero_byte_review_only_no_delete_count: $ZeroByteCount",
    "known_source_authority_object_review_only_count: $SourceObjectCount",
    "current_runner_script_excluded_count: $CurrentRunnerExcludedCount",
    "stress_parsed_row_count: $($ParsedRows.Count)",
    "stress_bad_marker_row_count: $($BadMarkerRows.Count)",
    "stress_bad_sha_row_count: $($BadShaRows.Count)",
    "stress_parsed_snapshot_mismatch_count: $($MismatchRows.Count)",
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

Write-Host "=== ROOT HELD GROUP READ ONLY PREP CARD V0_2 WITH STRESS BENCH COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "stress_bench_path: $StressPath"
Write-Host "stress_bench_sha256: $StressSha"
Write-Host "supersedes_report_sha256: $OldPrepCardSha"
Write-Host "supersession_reason: PREP_CARD_ROW_SHA_INTERPOLATION_BUG"
Write-Host "observed_root_top_level_file_count: $ObservedRootFileCount"
Write-Host "held_decision_candidate_count: $HeldDecisionCandidateCount"
Write-Host "root_level_script_held_not_execute_count: $ScriptHeldCount"
Write-Host "desktop_ini_leave_in_place_count: $DesktopIniCount"
Write-Host "zero_byte_review_only_no_delete_count: $ZeroByteCount"
Write-Host "known_source_authority_object_review_only_count: $SourceObjectCount"
Write-Host "current_runner_script_excluded_count: $CurrentRunnerExcludedCount"
Write-Host "stress_parsed_row_count: $($ParsedRows.Count)"
Write-Host "stress_bad_marker_row_count: $($BadMarkerRows.Count)"
Write-Host "stress_bad_sha_row_count: $($BadShaRows.Count)"
Write-Host "stress_parsed_snapshot_mismatch_count: $($MismatchRows.Count)"
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
