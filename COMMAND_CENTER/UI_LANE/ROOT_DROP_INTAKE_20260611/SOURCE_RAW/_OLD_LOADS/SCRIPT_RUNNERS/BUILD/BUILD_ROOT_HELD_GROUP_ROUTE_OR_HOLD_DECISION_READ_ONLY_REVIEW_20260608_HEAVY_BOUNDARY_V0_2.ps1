Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_20260608"
$FinalVerdict = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_READY_WITH_SCOPE_LIMIT_NOTE"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_ROUGH_LOCAL_IMPORT_20260608"
$AfterImportNextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "1548fab246f0326041952107581b60e70669828f"

$Expected = [ordered]@{
    PrepCard = [ordered]@{
        Path = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md"
        Sha256 = "83967BAB53B170BAD53AEAC21BE042B6129B7C13B9934AC110D729011E1B6F8E"
    }
    PrepReceipt = [ordered]@{
        Path = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt"
        Sha256 = "73AA76F428746BC7C6971F928AF580FEC9AA590627141261B52A66419C4F6AE7"
    }
    PrepRoughLocalLedger = [ordered]@{
        Path = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md"
        Sha256 = "23BC00D620F2340918B9650916A036E65D5062E20214FB5582533E501B821ABC"
    }
    PrepRoughLocalReceipt = [ordered]@{
        Path = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt"
        Sha256 = "5A60A3AECBCDAE882989F616ABBC190A78E6F1BFFA4DDEDA8165CDD8AD5CB4BF"
    }
    NextObjectSelector = [ordered]@{
        Path = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608.md"
        Sha256 = "15431564C9AC544972669D29641031B04425077CA6848C4CD73432EBFDCF942A"
    }
    NextObjectSelectorReceipt = [ordered]@{
        Path = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_RECEIPT_20260608.txt"
        Sha256 = "ACB984B6CCEDC16B8DB1EFC98F7B94FC0BAB61629A9218A6173A566AE513017F"
    }
}

$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD"
$ExpectedGitImport = [ordered]@{
    GitPrepRoughLocalLedger = [ordered]@{
        Path = Join-Path $GitTop (($GitImportRel + "/ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md") -replace "/", "\")
        Sha256 = "23BC00D620F2340918B9650916A036E65D5062E20214FB5582533E501B821ABC"
    }
    GitPrepRoughLocalReceipt = [ordered]@{
        Path = Join-Path $GitTop (($GitImportRel + "/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt") -replace "/", "\")
        Sha256 = "5A60A3AECBCDAE882989F616ABBC190A78E6F1BFFA4DDEDA8165CDD8AD5CB4BF"
    }
    GitPrepImportPacketReceipt = [ordered]@{
        Path = Join-Path $GitTop (($GitImportRel + "/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_GIT_IMPORT_PACKET_RECEIPT_20260608.md") -replace "/", "\")
        Sha256 = "BA1ACB2236E22BFB253FCB994847458B3BD71F576EECC6B4A0E9B526358DAA2E"
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

function Escape-Cell {
    param([AllowNull()][string]$Value)
    if ($null -eq $Value) { return "" }
    return (($Value -replace "\|", "\|") -replace "`r?`n", " ")
}

function Parse-PrepRows {
    param([AllowEmptyCollection()][AllowNull()][string[]]$Lines)

    $Rows = New-Object System.Collections.Generic.List[object]

    if ($null -eq $Lines -or $Lines.Count -eq 0) {
        return @()
    }

    foreach ($Line in $Lines) {
        if ([string]::IsNullOrWhiteSpace($Line)) {
            continue
        }

        if ($Line -match '^\| (?<Name>.*?) \| (?<Size>\d+) \| `(?<Sha>[^`]+)` \| (?<Class>[^|]+) \| (?<Include>[^|]+) \|$') {
            if ($Matches.Name -eq "Name") { continue }

            $Rows.Add([pscustomobject]@{
                Name = [string]$Matches.Name
                SizeBytes = [int64]$Matches.Size
                Sha256 = [string]$Matches.Sha
                PrepClass = ([string]$Matches.Class).Trim()
                IncludeInHeldDecision = ([string]$Matches.Include).Trim()
            }) | Out-Null
        }
    }

    return @($Rows)
}

function Get-DecisionFromPrepRow {
    param(
        [Parameter(Mandatory=$true)][object]$Row,
        [Parameter(Mandatory=$true)][string]$ExistsNow,
        [Parameter(Mandatory=$true)][string]$HashMatchNow
    )

    $Name = [string]$Row.Name
    $PrepClass = [string]$Row.PrepClass
    $Ext = [System.IO.Path]::GetExtension($Name)

    if ($ExistsNow -ne "YES") {
        return [ordered]@{
            ReviewClass = "MISSING_AT_REVIEW_TIME"
            Decision = "BLOCK_ROUTE_DECISION_UNTIL_USER_REVIEW"
            Reason = "Prep snapshot row no longer exists at root review time. Missing does not prove deletion authority."
            LaterRouteCandidate = "NO"
        }
    }

    if ($HashMatchNow -ne "YES") {
        return [ordered]@{
            ReviewClass = "HASH_CHANGED_SINCE_PREP"
            Decision = "BLOCK_ROUTE_DECISION_UNTIL_USER_REVIEW"
            Reason = "File exists but hash changed since prep snapshot. Do not classify from stale evidence."
            LaterRouteCandidate = "NO"
        }
    }

    switch ($PrepClass) {
        "CURRENT_RUNNER_SCRIPT_EXCLUDE_FROM_HELD_DECISION" {
            return [ordered]@{
                ReviewClass = "CURRENT_RUNNER_EXCLUDED"
                Decision = "EXCLUDE_FROM_HELD_GROUP_DECISION"
                Reason = "This was the active prep runner at snapshot time. It is not a held source object."
                LaterRouteCandidate = "SCRIPT_HISTORY_REVIEW_LATER"
            }
        }
        "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE" {
            return [ordered]@{
                ReviewClass = "WINDOWS_SYSTEM_METADATA"
                Decision = "LEAVE_IN_PLACE"
                Reason = "desktop.ini is system metadata. Do not delete or route from this review."
                LaterRouteCandidate = "NO"
            }
        }
        "KNOWN_SOURCE_AUTHORITY_OBJECT_REVIEW_ONLY_NO_REWRITE" {
            return [ordered]@{
                ReviewClass = "SOURCE_AUTHORITY_OBJECT"
                Decision = "HOLD_AS_SOURCE_AUTHORITY_REVIEW_ONLY"
                Reason = "Known source-looking authority object. No rewrite, no route, no source replay from this review."
                LaterRouteCandidate = "SOURCE_CUSTODY_REVIEW_ONLY"
            }
        }
        "ZERO_BYTE_ROOT_FILE_REVIEW_ONLY_NO_DELETE" {
            return [ordered]@{
                ReviewClass = "ZERO_BYTE_REVIEW_ONLY"
                Decision = "HOLD_PENDING_MANUAL_REVIEW"
                Reason = "Zero-byte does not mean trash. No delete authority exists."
                LaterRouteCandidate = "MANUAL_REVIEW_REQUIRED"
            }
        }
        "ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE_WITHOUT_REVIEW" {
            if ($Name -like "BUILD_*") {
                return [ordered]@{
                    ReviewClass = "ROOT_BUILD_RUNNER_SCRIPT"
                    Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
                    Reason = "Generated/root-level build runner. Review as script artifact before any route/archive decision."
                    LaterRouteCandidate = "SCRIPT_REVIEW_OR_RUNNER_HISTORY_LATER"
                }
            }
            if ($Name -like "ROUGH_LOCAL_IMPORT_*") {
                return [ordered]@{
                    ReviewClass = "ROOT_IMPORT_RUNNER_SCRIPT"
                    Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
                    Reason = "Generated/root-level rough_local import runner. Review as script artifact before any route/archive decision."
                    LaterRouteCandidate = "SCRIPT_REVIEW_OR_RUNNER_HISTORY_LATER"
                }
            }
            if ($Name -like "RUN_*") {
                return [ordered]@{
                    ReviewClass = "ROOT_RUNNER_SCRIPT"
                    Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
                    Reason = "Root-level runner script. Do not execute from route/hold review."
                    LaterRouteCandidate = "SCRIPT_REVIEW_LATER"
                }
            }
            return [ordered]@{
                ReviewClass = "ROOT_SCRIPT"
                Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
                Reason = "Root-level script must not be executed, moved, or promoted without separate script review."
                LaterRouteCandidate = "SCRIPT_REVIEW_LATER"
            }
        }
        default {
            if ($Ext -ieq ".md") {
                return [ordered]@{
                    ReviewClass = "ROOT_MARKDOWN_DOCUMENT"
                    Decision = "HOLD_PENDING_DOCUMENT_CUSTODY_REVIEW"
                    Reason = "Root-level document candidate. Needs document custody decision before routing."
                    LaterRouteCandidate = "DOCUMENT_CUSTODY_REVIEW_LATER"
                }
            }
            if ($Ext -ieq ".txt") {
                return [ordered]@{
                    ReviewClass = "ROOT_TEXT_OR_RECEIPT_DOCUMENT"
                    Decision = "HOLD_PENDING_TEXT_CUSTODY_REVIEW"
                    Reason = "Root-level text candidate. Needs custody decision before routing."
                    LaterRouteCandidate = "TEXT_CUSTODY_REVIEW_LATER"
                }
            }
            return [ordered]@{
                ReviewClass = "ROOT_HELD_CANDIDATE"
                Decision = "HOLD_PENDING_ROUTE_OR_HOLD_OPTION_SET"
                Reason = "No safe route decision without user-approved option set."
                LaterRouteCandidate = "ROUTE_OR_HOLD_OPTION_SET_LATER"
            }
        }
    }
}

$Blockers = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]

Write-Host "=== ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY REVIEW V0_2 ==="

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
        Add-Blocker "REQUIRED_LOCAL_FILE_MISSING: $Key :: $Path"
        continue
    }

    $Got = Get-Sha256 -Path $Path
    if ($Got -ne $Want) {
        Add-Blocker "LOCAL_SHA256_MISMATCH: $Key :: expected $Want :: got $Got :: path $Path"
        continue
    }

    $VerifiedLines.Add("$Key SHA256 confirmed: $Got") | Out-Null
}

foreach ($Key in $ExpectedGitImport.Keys) {
    $Path = [string]$ExpectedGitImport[$Key].Path
    $Want = [string]$ExpectedGitImport[$Key].Sha256

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Blocker "REQUIRED_GIT_IMPORT_FILE_MISSING: $Key :: $Path"
        continue
    }

    $Got = Get-Sha256 -Path $Path
    if ($Got -ne $Want) {
        Add-Blocker "GIT_IMPORT_SHA256_MISMATCH: $Key :: expected $Want :: got $Got :: path $Path"
        continue
    }

    $VerifiedLines.Add("$Key SHA256 confirmed: $Got") | Out-Null
}

$PrepText = ""
$PrepLines = @()
if (Test-Path -LiteralPath $Expected.PrepCard.Path -PathType Leaf) {
    $PrepText = Get-Content -LiteralPath $Expected.PrepCard.Path -Raw
    $PrepLines = @(Get-Content -LiteralPath $Expected.PrepCard.Path)
}

$RequiredPrepSignals = @(
    "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_READY_WITH_SCOPE_LIMIT_NOTE",
    "observed_root_top_level_file_count: 42",
    "held_decision_candidate_count: 40",
    "root_level_script_held_not_execute_count: 36",
    "desktop_ini_leave_in_place_count: 1",
    "zero_byte_review_only_no_delete_count: 1",
    "known_source_authority_object_review_only_count: 1",
    "current_runner_script_excluded_count: 1",
    "after_import_next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_20260608",
    "The next review must not move, delete, rename, route, execute, rewrite, commit, push, or promote anything."
)

foreach ($Signal in $RequiredPrepSignals) {
    if ($PrepText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "PREP_SIGNAL_MISSING: $Signal"
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

$ReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_20260608.md"
$ReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_RECEIPT_20260608.txt"

if (Test-Path -LiteralPath $ReportPath -PathType Leaf) {
    Add-Blocker "OUTPUT_REPORT_ALREADY_EXISTS_NO_OVERWRITE: $ReportPath"
}
if (Test-Path -LiteralPath $ReceiptPath -PathType Leaf) {
    Add-Blocker "OUTPUT_RECEIPT_ALREADY_EXISTS_NO_OVERWRITE: $ReceiptPath"
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND BEFORE PARSE/WRITE ==="
    foreach ($Blocker in $Blockers) {
        Write-Host $Blocker
    }
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_BLOCKED"
    exit 2
}

$PrepRows = @(Parse-PrepRows -Lines $PrepLines)

if ($PrepRows.Count -ne 42) {
    Write-Host "=== PREP ROW PARSE BLOCKER ==="
    Write-Host "PREP_ROW_COUNT_MISMATCH: expected 42 parsed rows from prep card :: got $($PrepRows.Count)"
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_BLOCKED"
    exit 2
}

$ReviewRows = New-Object System.Collections.Generic.List[object]
$MissingCount = 0
$HashChangedCount = 0
$HashMatchedCount = 0

foreach ($Row in $PrepRows) {
    $CurrentPath = Join-Path $Root ([string]$Row.Name)
    $ExistsNow = "NO"
    $HashNow = ""
    $HashMatchNow = "NO"
    $SizeNow = ""
    $LastWriteNow = ""

    if (Test-Path -LiteralPath $CurrentPath -PathType Leaf) {
        $ExistsNow = "YES"
        $FileInfo = Get-Item -LiteralPath $CurrentPath -Force
        $SizeNow = [string]$FileInfo.Length
        $LastWriteNow = $FileInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        $HashNow = Get-Sha256 -Path $CurrentPath

        if ($HashNow -eq [string]$Row.Sha256) {
            $HashMatchNow = "YES"
            $HashMatchedCount++
        } else {
            $HashChangedCount++
        }
    } else {
        $MissingCount++
    }

    $Decision = Get-DecisionFromPrepRow -Row $Row -ExistsNow $ExistsNow -HashMatchNow $HashMatchNow

    $ReviewRows.Add([pscustomobject]@{
        Name = [string]$Row.Name
        PrepSizeBytes = [int64]$Row.SizeBytes
        CurrentSizeBytes = $SizeNow
        PrepSha256 = [string]$Row.Sha256
        CurrentSha256 = $HashNow
        ExistsNow = $ExistsNow
        HashMatchNow = $HashMatchNow
        PrepClass = [string]$Row.PrepClass
        IncludeInHeldDecision = [string]$Row.IncludeInHeldDecision
        ReviewClass = [string]$Decision.ReviewClass
        Decision = [string]$Decision.Decision
        LaterRouteCandidate = [string]$Decision.LaterRouteCandidate
        Reason = [string]$Decision.Reason
        LastWriteNow = $LastWriteNow
    }) | Out-Null
}

if ($MissingCount -gt 0) {
    Write-Host "=== REVIEW BLOCKER ==="
    Write-Host "PREP_ROWS_MISSING_AT_REVIEW_TIME: $MissingCount"
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_BLOCKED"
    exit 2
}
if ($HashChangedCount -gt 0) {
    Write-Host "=== REVIEW BLOCKER ==="
    Write-Host "PREP_ROWS_HASH_CHANGED_AT_REVIEW_TIME: $HashChangedCount"
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_BLOCKED"
    exit 2
}

$CurrentRootFiles = @(Get-ChildItem -LiteralPath $Root -File -Force | Sort-Object Name)
$ExtraRootFiles = @()
$PrepNameSet = @{}
foreach ($Row in $PrepRows) {
    $PrepNameSet[[string]$Row.Name] = $true
}

foreach ($File in $CurrentRootFiles) {
    if (-not $PrepNameSet.ContainsKey($File.Name)) {
        $ExtraRootFiles += $File
    }
}

$ExtraRootFileCount = @($ExtraRootFiles).Count
$ExtraRootScriptCount = @($ExtraRootFiles | Where-Object { $_.Extension -ieq ".ps1" }).Count
$ExtraRootNonScriptCount = $ExtraRootFileCount - $ExtraRootScriptCount

if ($ExtraRootNonScriptCount -gt 0) {
    Write-Host "=== REVIEW BLOCKER ==="
    Write-Host "EXTRA_NON_SCRIPT_ROOT_FILES_AFTER_PREP_SNAPSHOT: $ExtraRootNonScriptCount"
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_BLOCKED"
    exit 2
}

$DecisionCounts = $ReviewRows | Group-Object Decision | Sort-Object Name
$ReviewClassCounts = $ReviewRows | Group-Object ReviewClass | Sort-Object Name

$DecisionHoldCount = @($ReviewRows | Where-Object { $_.Decision -match "^HOLD" }).Count
$DecisionLeaveCount = @($ReviewRows | Where-Object { $_.Decision -eq "LEAVE_IN_PLACE" }).Count
$DecisionExcludeCount = @($ReviewRows | Where-Object { $_.Decision -match "^EXCLUDE" }).Count
$DecisionBlockCount = @($ReviewRows | Where-Object { $_.Decision -match "^BLOCK" }).Count

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$ReportLines = New-Object System.Collections.Generic.List[string]

$ReportLines.Add("# ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY REVIEW 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: READ_ONLY_REVIEW / DECISION_TABLE / HEAVY_BOUNDARY_CHECK / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("Repair: V0_2 safe prep-row parse and blocker-before-parse fix after V0_1 Parse-PrepRows empty-lines failure.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Review the root-held prep snapshot and produce a route-or-hold decision table without moving, deleting, renaming, routing, executing, rewriting, committing, pushing, or promoting anything.") | Out-Null
$ReportLines.Add("This review uses the prep-card snapshot as the review set. New runner scripts created after the prep snapshot are recorded as extra root files, not silently added to the held decision set.") | Out-Null
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
$ReportLines.Add("- git_commit_or_push_done_by_this_review: NO") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Snapshot verification") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- prep_rows_parsed: $($PrepRows.Count)") | Out-Null
$ReportLines.Add("- prep_rows_hash_matched_now: $HashMatchedCount") | Out-Null
$ReportLines.Add("- prep_rows_missing_now: $MissingCount") | Out-Null
$ReportLines.Add("- prep_rows_hash_changed_now: $HashChangedCount") | Out-Null
$ReportLines.Add("- current_root_top_level_file_count: $(@($CurrentRootFiles).Count)") | Out-Null
$ReportLines.Add("- extra_root_files_not_in_prep_snapshot_count: $ExtraRootFileCount") | Out-Null
$ReportLines.Add("- extra_root_scripts_not_in_prep_snapshot_count: $ExtraRootScriptCount") | Out-Null
$ReportLines.Add("- extra_root_non_scripts_not_in_prep_snapshot_count: $ExtraRootNonScriptCount") | Out-Null
$ReportLines.Add("") | Out-Null

if ($ExtraRootFileCount -gt 0) {
    $ReportLines.Add("### Extra root files not included in prep snapshot") | Out-Null
    $ReportLines.Add("") | Out-Null
    $ReportLines.Add("| Name | SizeBytes | SHA256 | Handling |") | Out-Null
    $ReportLines.Add("|---|---:|---|---|") | Out-Null
    foreach ($File in $ExtraRootFiles) {
        $ExtraSha = Get-Sha256 -Path $File.FullName
        $Handling = "AFTER_PREP_RUNNER_ARTIFACT_NOT_PART_OF_THIS_HELD_REVIEW"
        if ($File.Extension -ine ".ps1") {
            $Handling = "EXTRA_NON_SCRIPT_BLOCKER_IF_PRESENT"
        }
        $ReportLines.Add("| $(Escape-Cell $File.Name) | $($File.Length) | `$ExtraSha` | $Handling |") | Out-Null
    }
    $ReportLines.Add("") | Out-Null
}

$ReportLines.Add("## Decision summary") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- decision_hold_count: $DecisionHoldCount") | Out-Null
$ReportLines.Add("- decision_leave_count: $DecisionLeaveCount") | Out-Null
$ReportLines.Add("- decision_exclude_count: $DecisionExcludeCount") | Out-Null
$ReportLines.Add("- decision_block_count: $DecisionBlockCount") | Out-Null
$ReportLines.Add("") | Out-Null

$ReportLines.Add("### Decision counts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| Decision | Count |") | Out-Null
$ReportLines.Add("|---|---:|") | Out-Null
foreach ($Group in $DecisionCounts) {
    $ReportLines.Add("| $(Escape-Cell $Group.Name) | $($Group.Count) |") | Out-Null
}
$ReportLines.Add("") | Out-Null

$ReportLines.Add("### Review class counts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| ReviewClass | Count |") | Out-Null
$ReportLines.Add("|---|---:|") | Out-Null
foreach ($Group in $ReviewClassCounts) {
    $ReportLines.Add("| $(Escape-Cell $Group.Name) | $($Group.Count) |") | Out-Null
}
$ReportLines.Add("") | Out-Null

$ReportLines.Add("## Route-or-hold decision table") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| Name | ExistsNow | HashMatchNow | PrepClass | ReviewClass | Decision | LaterRouteCandidate | Reason |") | Out-Null
$ReportLines.Add("|---|---|---|---|---|---|---|---|") | Out-Null

foreach ($Row in $ReviewRows) {
    $ReportLines.Add("| $(Escape-Cell $Row.Name) | $($Row.ExistsNow) | $($Row.HashMatchNow) | $(Escape-Cell $Row.PrepClass) | $(Escape-Cell $Row.ReviewClass) | $(Escape-Cell $Row.Decision) | $(Escape-Cell $Row.LaterRouteCandidate) | $(Escape-Cell $Row.Reason) |") | Out-Null
}

$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Review verdict") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("The root-held group has been reviewed from the prep snapshot as read-only evidence.") | Out-Null
$ReportLines.Add("The review produces decisions only. It does not perform routing, cleanup, deletion, movement, script execution, source rewrite, doctrine promotion, commit, or push.") | Out-Null
$ReportLines.Add("The next safe step is to rough_local import this review, then build an option set for what the user may approve later.") | Out-Null
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
$ReportLines.Add("- no commit or push from this review card") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next selected action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("next_build_chunk_selected: $NextBuildChunk") | Out-Null
$ReportLines.Add("after_import_next_build_chunk_selected: $AfterImportNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## DoesNotProve") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This review proves only that the prep snapshot was reviewed read-only and a route-or-hold decision table was produced. It does not prove the root files are safe, public-safe, stale, trash, route-ready, delete-ready, move-ready, source-ready, helper-ready, doctrine-ready, pushed, or cleaned.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "repair: V0_2 safe prep-row parse and blocker-before-parse fix after V0_1 Parse-PrepRows empty-lines failure",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "prep_rows_parsed: $($PrepRows.Count)",
    "prep_rows_hash_matched_now: $HashMatchedCount",
    "prep_rows_missing_now: $MissingCount",
    "prep_rows_hash_changed_now: $HashChangedCount",
    "current_root_top_level_file_count: $(@($CurrentRootFiles).Count)",
    "extra_root_files_not_in_prep_snapshot_count: $ExtraRootFileCount",
    "extra_root_scripts_not_in_prep_snapshot_count: $ExtraRootScriptCount",
    "extra_root_non_scripts_not_in_prep_snapshot_count: $ExtraRootNonScriptCount",
    "decision_hold_count: $DecisionHoldCount",
    "decision_leave_count: $DecisionLeaveCount",
    "decision_exclude_count: $DecisionExcludeCount",
    "decision_block_count: $DecisionBlockCount",
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

Write-Host "=== ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY REVIEW V0_2 COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "prep_rows_parsed: $($PrepRows.Count)"
Write-Host "prep_rows_hash_matched_now: $HashMatchedCount"
Write-Host "prep_rows_missing_now: $MissingCount"
Write-Host "prep_rows_hash_changed_now: $HashChangedCount"
Write-Host "current_root_top_level_file_count: $(@($CurrentRootFiles).Count)"
Write-Host "extra_root_files_not_in_prep_snapshot_count: $ExtraRootFileCount"
Write-Host "extra_root_scripts_not_in_prep_snapshot_count: $ExtraRootScriptCount"
Write-Host "extra_root_non_scripts_not_in_prep_snapshot_count: $ExtraRootNonScriptCount"
Write-Host "decision_hold_count: $DecisionHoldCount"
Write-Host "decision_leave_count: $DecisionLeaveCount"
Write-Host "decision_exclude_count: $DecisionExcludeCount"
Write-Host "decision_block_count: $DecisionBlockCount"
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
