Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608"
$FinalVerdict = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_READY_WITH_STRESS_BENCH_PASS"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_ROUGH_LOCAL_IMPORT_20260608"
$AfterImportNextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "890f8fa23ebee28eb3c3bd99cd396868fde402d6"

$PrepCardPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_20260608.md"
$PrepCardSha = "5E7F2234E72DC05D318E24767BDC057912274BEA5368507208CEF4CDDAD460C1"

$PrepReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_RECEIPT_20260608.txt"
$PrepReceiptSha = "88C98D9B1B4C2C665DA2E0AEB357B58E1467FB9AF37907996083BCAD91841A9D"

$PrepStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_STRESS_BENCH_20260608.md"
$PrepStressSha = "BDFD4FED741CBFCB3B1DF8DFF0E3D5EF31E17BC3D190EC907EB04C5D962587CD"

$PrepRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_20260608.md"
$PrepRoughLedgerSha = "B972BDBF87A4A1AC0AF5E4E594AA53422BE786D0CF533BC8CDDEC968664DC8CD"

$PrepRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_RECEIPT_20260608.txt"
$PrepRoughReceiptSha = "FA9C6A9F828D7EC608F6F4F9ACC49D293930B6E6B10BBE18379FBEBE8C99F843"

$GitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2\ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$GitImportPacketSha = "35EEF6AB14FE49558DF35444C50363CAE64A7D45C05F7D43923BE29AAE1A8F4D"

$ReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$ReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608.txt"
$StressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_STRESS_BENCH_20260608.md"

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
    param([AllowNull()][AllowEmptyCollection()][string[]]$Lines)

    $Rows = New-Object System.Collections.Generic.List[object]
    $InTable = $false

    if ($null -eq $Lines -or $Lines.Count -eq 0) {
        return $Rows.ToArray()
    }

    foreach ($Line in $Lines) {
        if ($Line -eq "## Observed root file rows") {
            $InTable = $true
            continue
        }

        if ($InTable -and $Line -match '^## ' -and $Line -ne "## Observed root file rows") {
            break
        }

        if (-not $InTable) { continue }
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
            throw "PREP_TABLE_BAD_SIZE_FIELD: $Line"
        }

        if ($Sha -notmatch '^[A-F0-9]{64}$') {
            throw "PREP_TABLE_BAD_SHA_FIELD: $Line"
        }

        if ($Include -notin @("YES", "NO")) {
            throw "PREP_TABLE_BAD_INCLUDE_FIELD: $Line"
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
            LaterRouteCandidate = "NO"
            Reason = "Prep snapshot row no longer exists at root review time. Missing does not prove deletion authority."
        }
    }

    if ($HashMatchNow -ne "YES") {
        return [ordered]@{
            ReviewClass = "HASH_CHANGED_SINCE_PREP"
            Decision = "BLOCK_ROUTE_DECISION_UNTIL_USER_REVIEW"
            LaterRouteCandidate = "NO"
            Reason = "File exists but hash changed since V0_2 prep snapshot. Do not classify from stale evidence."
        }
    }

    switch ($PrepClass) {
        "CURRENT_RUNNER_SCRIPT_EXCLUDE_FROM_HELD_DECISION" {
            return [ordered]@{
                ReviewClass = "CURRENT_RUNNER_EXCLUDED"
                Decision = "EXCLUDE_FROM_HELD_GROUP_DECISION"
                LaterRouteCandidate = "SCRIPT_HISTORY_REVIEW_LATER"
                Reason = "This was the active V0_2 prep runner at snapshot time. It is not a held source object."
            }
        }
        "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE" {
            return [ordered]@{
                ReviewClass = "WINDOWS_SYSTEM_METADATA"
                Decision = "LEAVE_IN_PLACE"
                LaterRouteCandidate = "NO"
                Reason = "desktop.ini is system metadata. Do not delete or route from this review."
            }
        }
        "KNOWN_SOURCE_AUTHORITY_OBJECT_REVIEW_ONLY_NO_REWRITE" {
            return [ordered]@{
                ReviewClass = "SOURCE_AUTHORITY_OBJECT"
                Decision = "HOLD_AS_SOURCE_AUTHORITY_REVIEW_ONLY"
                LaterRouteCandidate = "SOURCE_CUSTODY_REVIEW_ONLY"
                Reason = "Known source-looking authority object. No rewrite, route, or source replay from this review."
            }
        }
        "ZERO_BYTE_ROOT_FILE_REVIEW_ONLY_NO_DELETE" {
            return [ordered]@{
                ReviewClass = "ZERO_BYTE_REVIEW_ONLY"
                Decision = "HOLD_PENDING_MANUAL_REVIEW"
                LaterRouteCandidate = "MANUAL_REVIEW_REQUIRED"
                Reason = "Zero-byte does not mean trash. No delete authority exists."
            }
        }
        "ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE_WITHOUT_REVIEW" {
            if ($Name -like "BUILD_*") {
                return [ordered]@{
                    ReviewClass = "ROOT_BUILD_RUNNER_SCRIPT"
                    Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
                    LaterRouteCandidate = "SCRIPT_REVIEW_OR_RUNNER_HISTORY_LATER"
                    Reason = "Generated/root-level build runner. Review as script artifact before route/archive decision."
                }
            }

            if ($Name -like "ROUGH_LOCAL_IMPORT_*") {
                return [ordered]@{
                    ReviewClass = "ROOT_IMPORT_RUNNER_SCRIPT"
                    Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
                    LaterRouteCandidate = "SCRIPT_REVIEW_OR_RUNNER_HISTORY_LATER"
                    Reason = "Generated/root-level rough_local import runner. Review as script artifact before route/archive decision."
                }
            }

            if ($Name -like "RUN_*") {
                return [ordered]@{
                    ReviewClass = "ROOT_RUNNER_SCRIPT"
                    Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
                    LaterRouteCandidate = "SCRIPT_REVIEW_LATER"
                    Reason = "Root-level runner script. Do not execute from route/hold review."
                }
            }

            return [ordered]@{
                ReviewClass = "ROOT_SCRIPT"
                Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
                LaterRouteCandidate = "SCRIPT_REVIEW_LATER"
                Reason = "Root-level script must not be executed, moved, or promoted without separate script review."
            }
        }
        default {
            if ($Ext -ieq ".md") {
                return [ordered]@{
                    ReviewClass = "ROOT_MARKDOWN_DOCUMENT"
                    Decision = "HOLD_PENDING_DOCUMENT_CUSTODY_REVIEW"
                    LaterRouteCandidate = "DOCUMENT_CUSTODY_REVIEW_LATER"
                    Reason = "Root-level document candidate. Needs document custody decision before routing."
                }
            }

            if ($Ext -ieq ".txt") {
                return [ordered]@{
                    ReviewClass = "ROOT_TEXT_OR_RECEIPT_DOCUMENT"
                    Decision = "HOLD_PENDING_TEXT_CUSTODY_REVIEW"
                    LaterRouteCandidate = "TEXT_CUSTODY_REVIEW_LATER"
                    Reason = "Root-level text candidate. Needs custody decision before routing."
                }
            }

            return [ordered]@{
                ReviewClass = "ROOT_HELD_CANDIDATE"
                Decision = "HOLD_PENDING_ROUTE_OR_HOLD_OPTION_SET"
                LaterRouteCandidate = "ROUTE_OR_HOLD_OPTION_SET_LATER"
                Reason = "No safe route decision without a user-approved option set."
            }
        }
    }
}

$Blockers = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]
$StressResults = New-Object System.Collections.Generic.List[string]

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

$RequiredFiles = [ordered]@{
    PrepCardV02 = [ordered]@{ Path = $PrepCardPath; Sha256 = $PrepCardSha }
    PrepReceiptV02 = [ordered]@{ Path = $PrepReceiptPath; Sha256 = $PrepReceiptSha }
    PrepStressBenchV02 = [ordered]@{ Path = $PrepStressPath; Sha256 = $PrepStressSha }
    PrepRoughLocalLedgerV02 = [ordered]@{ Path = $PrepRoughLedgerPath; Sha256 = $PrepRoughLedgerSha }
    PrepRoughLocalReceiptV02 = [ordered]@{ Path = $PrepRoughReceiptPath; Sha256 = $PrepRoughReceiptSha }
    GitImportPacketReceiptV02 = [ordered]@{ Path = $GitImportPacketPath; Sha256 = $GitImportPacketSha }
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

$PrepText = ""
$PrepLines = @()
$PrepStressText = ""

if (Test-Path -LiteralPath $PrepCardPath -PathType Leaf) {
    $PrepText = Get-Content -LiteralPath $PrepCardPath -Raw
    $PrepLines = @(Get-Content -LiteralPath $PrepCardPath)
}

if (Test-Path -LiteralPath $PrepStressPath -PathType Leaf) {
    $PrepStressText = Get-Content -LiteralPath $PrepStressPath -Raw
}

$RequiredPrepSignals = @(
    "SUPERSEDES_BAD_SHA_TABLE",
    "observed_root_top_level_file_count: 48",
    "held_decision_candidate_count: 46",
    "root_level_script_held_not_execute_count: 42",
    "desktop_ini_leave_in_place_count: 1",
    "zero_byte_review_only_no_delete_count: 1",
    "known_source_authority_object_review_only_count: 1",
    "current_runner_script_excluded_count: 1",
    "next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_ROUGH_LOCAL_IMPORT_20260608",
    "after_import_next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $RequiredPrepSignals) {
    if ($PrepText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "PREP_V0_2_SIGNAL_MISSING: $Signal"
    }
}

$RequiredStressSignals = @(
    "ROOT_HELD_GROUP_PREP_CARD_V0_2_STRESS_BENCH_PASS",
    "parsed_row_count: 48",
    "bad_marker_row_count: 0",
    "bad_sha_row_count: 0",
    "parsed_snapshot_mismatch_count: 0",
    "current_runner_excluded_count: 1"
)

foreach ($Signal in $RequiredStressSignals) {
    if ($PrepStressText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "PREP_STRESS_SIGNAL_MISSING: $Signal"
    }
}

if ($PrepText -match [regex]::Escape('$(@')) {
    Add-Blocker "PREP_V0_2_CONTAINS_BAD_OBJECT_EXPRESSION_MARKER"
}
if ($PrepText -match "Sha256=[A-F0-9]{64}") {
    Add-Blocker "PREP_V0_2_CONTAINS_EMBEDDED_OBJECT_SHA_MARKER"
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
    Write-Host "=== BLOCKERS FOUND BEFORE REVIEW ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_REVIEW_V0_2_BLOCKED_BEFORE_WRITE"
    exit 2
}

$PrepRows = @(Parse-PrepRows -Lines $PrepLines)

if ($PrepRows.Count -ne 48) {
    Write-Host "=== PREP V0_2 ROW PARSE BLOCKER ==="
    Write-Host "PREP_V0_2_ROW_COUNT_MISMATCH: expected 48 :: got $($PrepRows.Count)"
    Write-Host "final_verdict: ROOT_HELD_GROUP_REVIEW_V0_2_BLOCKED_BEFORE_WRITE"
    exit 2
}

$BadShaRows = @($PrepRows | Where-Object { $_.Sha256 -notmatch '^[A-F0-9]{64}$' })
if ($BadShaRows.Count -ne 0) {
    Write-Host "=== PREP V0_2 SHA BLOCKER ==="
    Write-Host "PREP_V0_2_BAD_SHA_ROWS: $($BadShaRows.Count)"
    Write-Host "final_verdict: ROOT_HELD_GROUP_REVIEW_V0_2_BLOCKED_BEFORE_WRITE"
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

$CurrentRootFiles = @(Get-ChildItem -LiteralPath $Root -File -Force | Sort-Object Name)
$PrepNameSet = @{}
foreach ($Row in $PrepRows) { $PrepNameSet[[string]$Row.Name] = $true }

$ExtraRootFiles = @()
foreach ($File in $CurrentRootFiles) {
    if (-not $PrepNameSet.ContainsKey($File.Name)) {
        $ExtraRootFiles += $File
    }
}

$ExtraRootFileCount = @($ExtraRootFiles).Count
$ExtraRootScriptCount = @($ExtraRootFiles | Where-Object { $_.Extension -ieq ".ps1" }).Count
$ExtraRootNonScriptCount = $ExtraRootFileCount - $ExtraRootScriptCount

$DecisionCounts = $ReviewRows | Group-Object Decision | Sort-Object Name
$ReviewClassCounts = $ReviewRows | Group-Object ReviewClass | Sort-Object Name

$DecisionHoldCount = @($ReviewRows | Where-Object { $_.Decision -match "^HOLD" }).Count
$DecisionLeaveCount = @($ReviewRows | Where-Object { $_.Decision -eq "LEAVE_IN_PLACE" }).Count
$DecisionExcludeCount = @($ReviewRows | Where-Object { $_.Decision -match "^EXCLUDE" }).Count
$DecisionBlockCount = @($ReviewRows | Where-Object { $_.Decision -match "^BLOCK" }).Count

# Stress bench before write.
if ($HashMatchedCount -ne 48) {
    Add-Blocker "STRESS_FAIL_HASH_MATCHED_COUNT: expected 48 :: got $HashMatchedCount"
} else {
    $StressResults.Add("PASS all 48 prep rows still exist and hash-match current root") | Out-Null
}

if ($MissingCount -ne 0) {
    Add-Blocker "STRESS_FAIL_MISSING_PREP_ROWS: $MissingCount"
} else {
    $StressResults.Add("PASS no prep rows missing at review time") | Out-Null
}

if ($HashChangedCount -ne 0) {
    Add-Blocker "STRESS_FAIL_HASH_CHANGED_PREP_ROWS: $HashChangedCount"
} else {
    $StressResults.Add("PASS no prep rows changed hash at review time") | Out-Null
}

if ($BadShaRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_BAD_SHA_ROWS: $($BadShaRows.Count)"
} else {
    $StressResults.Add("PASS all prep rows carry plain 64-character SHA256 cells") | Out-Null
}

$CurrentRunnerExcluded = @($ReviewRows | Where-Object { $_.ReviewClass -eq "CURRENT_RUNNER_EXCLUDED" })
if ($CurrentRunnerExcluded.Count -ne 1) {
    Add-Blocker "STRESS_FAIL_CURRENT_RUNNER_EXCLUDED_COUNT: expected 1 :: got $($CurrentRunnerExcluded.Count)"
} else {
    $StressResults.Add("PASS exactly one V0_2 prep current-runner row excluded") | Out-Null
}

$BadDecisionRows = @($ReviewRows | Where-Object { $_.Decision -eq "" -or $null -eq $_.Decision })
if ($BadDecisionRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_EMPTY_DECISION_ROWS: $($BadDecisionRows.Count)"
} else {
    $StressResults.Add("PASS every prep row received a review decision") | Out-Null
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND DURING REVIEW STRESS BENCH ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_REVIEW_V0_2_STRESS_BENCH_BLOCKED"
    exit 2
}

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$StressLines = New-Object System.Collections.Generic.List[string]
$StressLines.Add("# ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY REVIEW V0_2 STRESS BENCH 20260608") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("Status: REVIEW_STRESS_BENCH / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH") | Out-Null
$StressLines.Add("Created: $Now") | Out-Null
$StressLines.Add("Active object: $ActiveObject") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("## Stress results") | Out-Null
$StressLines.Add("") | Out-Null
foreach ($Result in $StressResults) { $StressLines.Add("- $Result") | Out-Null }
$StressLines.Add("") | Out-Null
$StressLines.Add("## Counts") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("- prep_rows_parsed: $($PrepRows.Count)") | Out-Null
$StressLines.Add("- prep_rows_hash_matched_now: $HashMatchedCount") | Out-Null
$StressLines.Add("- prep_rows_missing_now: $MissingCount") | Out-Null
$StressLines.Add("- prep_rows_hash_changed_now: $HashChangedCount") | Out-Null
$StressLines.Add("- bad_sha_row_count: $($BadShaRows.Count)") | Out-Null
$StressLines.Add("- current_runner_excluded_count: $($CurrentRunnerExcluded.Count)") | Out-Null
$StressLines.Add("- empty_decision_row_count: $($BadDecisionRows.Count)") | Out-Null
$StressLines.Add("- extra_root_files_not_in_prep_snapshot_count: $ExtraRootFileCount") | Out-Null
$StressLines.Add("- extra_root_scripts_not_in_prep_snapshot_count: $ExtraRootScriptCount") | Out-Null
$StressLines.Add("- extra_root_non_scripts_not_in_prep_snapshot_count: $ExtraRootNonScriptCount") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("final_verdict: ROOT_HELD_GROUP_REVIEW_V0_2_STRESS_BENCH_PASS") | Out-Null

$ReportLines = New-Object System.Collections.Generic.List[string]

$ReportLines.Add("# ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY REVIEW V0_2 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: READ_ONLY_REVIEW / DECISION_TABLE / V0_2_CORRECTED_PREP_CARD / STRESS_BENCHED / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Review the corrected V0_2 root-held prep snapshot and produce a route-or-hold decision table without moving, deleting, renaming, routing, executing, rewriting, committing, pushing, or promoting anything.") | Out-Null
$ReportLines.Add("This review intentionally ignores the superseded bad SHA-table prep card and uses only the corrected V0_2 prep card plus its stress bench and rough_local import proof.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Verified load-bearing evidence") | Out-Null
$ReportLines.Add("") | Out-Null
foreach ($Line in $VerifiedLines) { $ReportLines.Add("- $Line") | Out-Null }
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
    $ReportLines.Add("### Extra root files not included in V0_2 prep snapshot") | Out-Null
    $ReportLines.Add("") | Out-Null
    $ReportLines.Add("| Name | SizeBytes | SHA256 | Handling |") | Out-Null
    $ReportLines.Add("|---|---:|---|---|") | Out-Null
    foreach ($File in $ExtraRootFiles) {
        $ExtraSha = Get-Sha256 -Path $File.FullName
        $Handling = "AFTER_PREP_ARTIFACT_OUTSIDE_THIS_REVIEW_SNAPSHOT"
        $ReportLines.Add("| $(Escape-Cell $File.Name) | $($File.Length) | $ExtraSha | $Handling |") | Out-Null
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
$ReportLines.Add("The corrected V0_2 root-held group snapshot has been reviewed as read-only evidence.") | Out-Null
$ReportLines.Add("The review produces decisions only. It does not perform routing, cleanup, deletion, movement, script execution, source rewrite, doctrine promotion, commit, or push.") | Out-Null
$ReportLines.Add("The next safe step is to rough_local import this review, then build an option set for later user-approved action.") | Out-Null
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
$ReportLines.Add("This review proves only that the corrected V0_2 prep snapshot was reviewed read-only and a route-or-hold decision table was produced. It does not prove the root files are safe, public-safe, stale, trash, route-ready, delete-ready, move-ready, source-ready, helper-ready, doctrine-ready, pushed, or cleaned.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

$StressLines | Set-Content -LiteralPath $StressPath -Encoding UTF8
$StressSha = Get-Sha256 -Path $StressPath

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "stress_bench_path: $StressPath",
    "stress_bench_sha256: $StressSha",
    "prep_card_v0_2_path: $PrepCardPath",
    "prep_card_v0_2_sha256: $PrepCardSha",
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
Write-Host "stress_bench_path: $StressPath"
Write-Host "stress_bench_sha256: $StressSha"
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
