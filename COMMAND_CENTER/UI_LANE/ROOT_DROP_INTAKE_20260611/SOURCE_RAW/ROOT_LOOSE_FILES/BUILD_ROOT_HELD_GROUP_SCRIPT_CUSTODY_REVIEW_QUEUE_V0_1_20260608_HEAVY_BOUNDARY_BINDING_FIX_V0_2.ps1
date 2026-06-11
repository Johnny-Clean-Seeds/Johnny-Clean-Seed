Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608"
$FinalVerdict = "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_READY_WITH_STRESS_BENCH_PASS"
$NextBuildChunk = "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_ROUGH_LOCAL_IMPORT_20260608"
$AfterImportNextBuildChunk = "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "ecb70637776aff6001356c305089509ea5281ad1"

$OptionReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608.md"
$OptionReportSha = "A481C79DA3206ADBB1A1BC43226CBFFB3F8AE2012A94539375D6EC35960D2965"

$OptionReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608.txt"
$OptionReceiptSha = "6D3D51A37A5C9D7979E1E3F3C1289B6585AF41658FE99F022C6E8CD425AC5DC5"

$OptionStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_STRESS_BENCH_20260608.md"
$OptionStressSha = "28F86A1766538C96197029314E1A20217AB798970F010B6A79C4A54BF3E348FA"

$OptionRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608.md"
$OptionRoughLedgerSha = "61F2F5892616CB334F7B9B7B7991B5998EDDFE66865731D4E656A92431A01C61"

$OptionRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608.txt"
$OptionRoughReceiptSha = "DAC82432BFD9716713438D1E4601FB20FFBE4D8021B8C6191C2940B283B26BFF"

$OptionGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2\ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$OptionGitImportPacketSha = "B263EAE0A5051F07024B7FC5AD3EB2399AEC7E60252925077DBE2A03CEAE39B8"

$ReviewReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$ReviewReportSha = "5926E984B853D3422023BF6AA5F4180A81C3AFE716FB6E18F09906102CBCD20D"

$ReviewStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_STRESS_BENCH_20260608.md"
$ReviewStressSha = "553987B342C485816CDF39AC534BBA5875D5DC8C3CB0BF2CF321813A08BBFD3A"

$ReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$ReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$StressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_STRESS_BENCH_20260608.md"

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

function Get-ReviewSnapshotScriptNames {
    param([AllowNull()][AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines)

    $Names = New-Object System.Collections.Generic.HashSet[string]
    $InTable = $false

    foreach ($Line in $Lines) {
        if ($Line -eq "## Route-or-hold decision table") {
            $InTable = $true
            continue
        }

        if ($InTable -and $Line -match '^## ' -and $Line -ne "## Route-or-hold decision table") {
            break
        }

        if (-not $InTable) { continue }
        if ($Line -notmatch '^\|') { continue }
        if ($Line -match '^\|---') { continue }
        if ($Line -match '^\| Name \|') { continue }

        $Parts = $Line -split '\|'
        if ($Parts.Count -lt 8) { continue }

        $Name = $Parts[1].Trim()
        $PrepClass = $Parts[4].Trim()
        $ReviewClass = $Parts[5].Trim()

        if (
            $PrepClass -eq "ROOT_LEVEL_SCRIPT_HELD_NOT_EXECUTE_WITHOUT_REVIEW" -or
            $ReviewClass -match "SCRIPT"
        ) {
            [void]$Names.Add($Name)
        }
    }

    return $Names
}

function Get-ScriptCustodyClass {
    param(
        [Parameter(Mandatory=$true)][System.IO.FileInfo]$File,
        [Parameter(Mandatory=$true)][string]$CurrentScriptPath
    )

    if ($File.FullName -ieq $CurrentScriptPath) {
        return "CURRENT_SCRIPT_CUSTODY_QUEUE_RUNNER"
    }

    if ($File.Name -like "BUILD_*") {
        return "BUILD_RUNNER_SCRIPT"
    }

    if ($File.Name -like "ROUGH_LOCAL_IMPORT_*") {
        return "ROUGH_LOCAL_IMPORT_RUNNER_SCRIPT"
    }

    if ($File.Name -like "WRITE_*") {
        return "WRITE_OR_GENERATOR_SCRIPT"
    }

    if ($File.Name -like "RUN_*") {
        return "RUNNER_SCRIPT"
    }

    return "ROOT_SCRIPT_OTHER"
}

function Get-ScriptDecision {
    param(
        [Parameter(Mandatory=$true)][string]$CustodyClass,
        [Parameter(Mandatory=$true)][string]$SeenInReviewSnapshot
    )

    if ($CustodyClass -eq "CURRENT_SCRIPT_CUSTODY_QUEUE_RUNNER") {
        return [ordered]@{
            Decision = "EXCLUDE_CURRENT_RUNNER_FROM_ACTION"
            ActionNow = "NO"
            Reason = "This is the active script custody queue runner. It is listed for custody visibility only."
        }
    }

    if ($SeenInReviewSnapshot -eq "YES") {
        return [ordered]@{
            Decision = "HOLD_FOR_SCRIPT_CUSTODY_REVIEW_NO_EXECUTE"
            ActionNow = "NO"
            Reason = "Script was already present in the corrected V0_2 review snapshot. It remains held; no execution or routing is authorized."
        }
    }

    return [ordered]@{
        Decision = "HOLD_AS_POST_REVIEW_ROOT_SCRIPT_NO_EXECUTE"
        ActionNow = "NO"
        Reason = "Script appeared after the corrected V0_2 review snapshot. It is outside that snapshot and must be held for separate custody review."
    }
}

$Blockers = New-Object System.Collections.Generic.List[string]
$StressResults = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]

Write-Host "=== ROOT HELD GROUP SCRIPT CUSTODY REVIEW QUEUE V0_1 BINDING_FIX_V0_2 ==="

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
    OptionReportV02 = [ordered]@{ Path = $OptionReportPath; Sha256 = $OptionReportSha }
    OptionReceiptV02 = [ordered]@{ Path = $OptionReceiptPath; Sha256 = $OptionReceiptSha }
    OptionStressBenchV02 = [ordered]@{ Path = $OptionStressPath; Sha256 = $OptionStressSha }
    OptionRoughLedgerV02 = [ordered]@{ Path = $OptionRoughLedgerPath; Sha256 = $OptionRoughLedgerSha }
    OptionRoughReceiptV02 = [ordered]@{ Path = $OptionRoughReceiptPath; Sha256 = $OptionRoughReceiptSha }
    OptionGitImportPacketV02 = [ordered]@{ Path = $OptionGitImportPacketPath; Sha256 = $OptionGitImportPacketSha }
    ReviewReportV02 = [ordered]@{ Path = $ReviewReportPath; Sha256 = $ReviewReportSha }
    ReviewStressBenchV02 = [ordered]@{ Path = $ReviewStressPath; Sha256 = $ReviewStressSha }
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

$OptionText = ""
$OptionReceiptText = ""
$OptionStressText = ""
$ReviewText = ""
$ReviewLines = @()
$ReviewStressText = ""

if (Test-Path -LiteralPath $OptionReportPath -PathType Leaf) {
    $OptionText = Get-Content -LiteralPath $OptionReportPath -Raw
}
if (Test-Path -LiteralPath $OptionReceiptPath -PathType Leaf) {
    $OptionReceiptText = Get-Content -LiteralPath $OptionReceiptPath -Raw
}
if (Test-Path -LiteralPath $OptionStressPath -PathType Leaf) {
    $OptionStressText = Get-Content -LiteralPath $OptionStressPath -Raw
}
if (Test-Path -LiteralPath $ReviewReportPath -PathType Leaf) {
    $ReviewText = Get-Content -LiteralPath $ReviewReportPath -Raw
    $ReviewLines = @(Get-Content -LiteralPath $ReviewReportPath)
}
if (Test-Path -LiteralPath $ReviewStressPath -PathType Leaf) {
    $ReviewStressText = Get-Content -LiteralPath $ReviewStressPath -Raw
}

$RequiredOptionSignals = @(
    "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_READY_WITH_STRESS_BENCH_PASS",
    "recommended_now_label: BUILD_SCRIPT_CUSTODY_REVIEW_QUEUE",
    "No move, delete, route, execute, commit, or push is allowed from this option-set card"
)

foreach ($Signal in $RequiredOptionSignals) {
    if (
        $OptionText -notmatch [regex]::Escape($Signal) -and
        $OptionReceiptText -notmatch [regex]::Escape($Signal)
    ) {
        Add-Blocker "OPTION_SET_SIGNAL_MISSING: $Signal"
    }
}

$RequiredOptionStressSignals = @(
    "ROOT_HELD_GROUP_OPTION_SET_V0_2_STRESS_BENCH_PASS",
    "option_count: 5",
    "options_without_user_approval_count: 0",
    "options_doing_write_action_now_count: 0",
    "options_missing_stop_line_language_count: 0",
    "recommended_now_option: B"
)

foreach ($Signal in $RequiredOptionStressSignals) {
    if ($OptionStressText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "OPTION_STRESS_SIGNAL_MISSING: $Signal"
    }
}

$RequiredReviewSignals = @(
    "prep_rows_parsed: 48",
    "prep_rows_hash_matched_now: 48",
    "prep_rows_missing_now: 0",
    "prep_rows_hash_changed_now: 0",
    "decision_block_count: 0",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $RequiredReviewSignals) {
    if ($ReviewText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "REVIEW_SIGNAL_MISSING: $Signal"
    }
}

if ($ReviewStressText -notmatch [regex]::Escape("ROOT_HELD_GROUP_REVIEW_V0_2_STRESS_BENCH_PASS")) {
    Add-Blocker "REVIEW_STRESS_PASS_SIGNAL_MISSING"
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
    Write-Host "=== BLOCKERS FOUND BEFORE SCRIPT CUSTODY QUEUE WRITE ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_BLOCKED_BEFORE_WRITE"
    exit 2
}

$ReviewLineArray = @($ReviewLines | ForEach-Object { [string]$_ })
$ReviewSnapshotScriptNames = Get-ReviewSnapshotScriptNames -Lines $ReviewLineArray
$ReviewSnapshotScriptCount = $ReviewSnapshotScriptNames.Count

$CurrentScripts = @(Get-ChildItem -LiteralPath $Root -File -Force | Where-Object { $_.Extension -ieq ".ps1" } | Sort-Object Name)
$CurrentScriptCount = $CurrentScripts.Count

$QueueRows = New-Object System.Collections.Generic.List[object]

foreach ($File in $CurrentScripts) {
    $SeenInReviewSnapshot = "NO"
    if ($ReviewSnapshotScriptNames.Contains($File.Name)) {
        $SeenInReviewSnapshot = "YES"
    }

    $CustodyClass = Get-ScriptCustodyClass -File $File -CurrentScriptPath $PSCommandPath
    $Decision = Get-ScriptDecision -CustodyClass $CustodyClass -SeenInReviewSnapshot $SeenInReviewSnapshot
    $Sha = Get-Sha256 -Path $File.FullName

    $QueueRows.Add([pscustomobject]@{
        Name = $File.Name
        SizeBytes = [int64]$File.Length
        Sha256 = $Sha
        LastWriteTime = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        SeenInReviewSnapshot = $SeenInReviewSnapshot
        IsCurrentRunner = $(if ($File.FullName -ieq $PSCommandPath) { "YES" } else { "NO" })
        CustodyClass = $CustodyClass
        Decision = [string]$Decision.Decision
        ActionNow = [string]$Decision.ActionNow
        Reason = [string]$Decision.Reason
    }) | Out-Null
}

$SeenInReviewCount = @($QueueRows | Where-Object { $_.SeenInReviewSnapshot -eq "YES" }).Count
$PostReviewScriptCount = @($QueueRows | Where-Object { $_.SeenInReviewSnapshot -eq "NO" }).Count
$CurrentRunnerCount = @($QueueRows | Where-Object { $_.IsCurrentRunner -eq "YES" }).Count
$ActionNowCount = @($QueueRows | Where-Object { $_.ActionNow -ne "NO" }).Count
$BadShaRows = @($QueueRows | Where-Object { $_.Sha256 -notmatch '^[A-F0-9]{64}$' })
$ExecuteNowRows = @($QueueRows | Where-Object { $_.Decision -match "EXECUTE_NOW|RUN_NOW|APPROVED_TO_EXECUTE" })
$MoveDeleteRouteRows = @($QueueRows | Where-Object { $_.Decision -match "MOVE|DELETE|ROUTE" -and $_.Decision -notmatch "NO_EXECUTE" })
$DecisionBlankRows = @($QueueRows | Where-Object { [string]::IsNullOrWhiteSpace($_.Decision) })

$CustodyClassGroups = $QueueRows | Group-Object CustodyClass | Sort-Object Name
$DecisionGroups = $QueueRows | Group-Object Decision | Sort-Object Name

# Stress bench before write.
if ($ReviewSnapshotScriptCount -ne 42) {
    Add-Blocker "STRESS_FAIL_REVIEW_SNAPSHOT_SCRIPT_COUNT: expected 42 :: got $ReviewSnapshotScriptCount"
} else {
    $StressResults.Add("PASS review_snapshot_script_count_is_42") | Out-Null
}

if ($CurrentScriptCount -lt $ReviewSnapshotScriptCount) {
    Add-Blocker "STRESS_FAIL_CURRENT_SCRIPT_COUNT_LESS_THAN_REVIEW_SNAPSHOT: current $CurrentScriptCount :: snapshot $ReviewSnapshotScriptCount"
} else {
    $StressResults.Add("PASS current_script_count_not_less_than_review_snapshot") | Out-Null
}

if ($SeenInReviewCount -ne $ReviewSnapshotScriptCount) {
    Add-Blocker "STRESS_FAIL_REVIEW_SNAPSHOT_SCRIPTS_NOT_ALL_PRESENT_CURRENTLY: seen_currently $SeenInReviewCount :: snapshot $ReviewSnapshotScriptCount"
} else {
    $StressResults.Add("PASS all review-snapshot scripts still present in current root") | Out-Null
}

if ($CurrentRunnerCount -ne 1) {
    Add-Blocker "STRESS_FAIL_CURRENT_RUNNER_COUNT: expected 1 :: got $CurrentRunnerCount"
} else {
    $StressResults.Add("PASS exactly one current runner identified") | Out-Null
}

if ($ActionNowCount -ne 0) {
    Add-Blocker "STRESS_FAIL_ACTION_NOW_ROWS: $ActionNowCount"
} else {
    $StressResults.Add("PASS no script row authorizes action now") | Out-Null
}

if ($BadShaRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_BAD_SHA_ROWS: $($BadShaRows.Count)"
} else {
    $StressResults.Add("PASS all script rows have plain SHA256 values") | Out-Null
}

if ($ExecuteNowRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_EXECUTE_NOW_DECISIONS: $($ExecuteNowRows.Count)"
} else {
    $StressResults.Add("PASS no script decision authorizes execution") | Out-Null
}

if ($MoveDeleteRouteRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_MOVE_DELETE_ROUTE_DECISIONS: $($MoveDeleteRouteRows.Count)"
} else {
    $StressResults.Add("PASS no script decision authorizes move/delete/route") | Out-Null
}

if ($DecisionBlankRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_BLANK_DECISION_ROWS: $($DecisionBlankRows.Count)"
} else {
    $StressResults.Add("PASS every script row has a custody decision") | Out-Null
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND DURING SCRIPT CUSTODY QUEUE STRESS BENCH ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_STRESS_BENCH_BLOCKED"
    exit 2
}

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$StressLines = New-Object System.Collections.Generic.List[string]
$StressLines.Add("# ROOT HELD GROUP SCRIPT CUSTODY REVIEW QUEUE V0_1 STRESS BENCH 20260608") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("Status: SCRIPT_CUSTODY_QUEUE_STRESS_BENCH / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH") | Out-Null
$StressLines.Add("Created: $Now") | Out-Null
$StressLines.Add("Active object: $ActiveObject") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("## Stress results") | Out-Null
$StressLines.Add("") | Out-Null
foreach ($Result in $StressResults) { $StressLines.Add("- $Result") | Out-Null }
$StressLines.Add("") | Out-Null
$StressLines.Add("## Counts") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("- review_snapshot_script_count: $ReviewSnapshotScriptCount") | Out-Null
$StressLines.Add("- current_root_script_count: $CurrentScriptCount") | Out-Null
$StressLines.Add("- scripts_seen_in_review_snapshot_count: $SeenInReviewCount") | Out-Null
$StressLines.Add("- post_review_root_script_count: $PostReviewScriptCount") | Out-Null
$StressLines.Add("- current_runner_count: $CurrentRunnerCount") | Out-Null
$StressLines.Add("- action_now_row_count: $ActionNowCount") | Out-Null
$StressLines.Add("- bad_sha_row_count: $($BadShaRows.Count)") | Out-Null
$StressLines.Add("- execute_now_decision_count: $($ExecuteNowRows.Count)") | Out-Null
$StressLines.Add("- move_delete_route_decision_count: $($MoveDeleteRouteRows.Count)") | Out-Null
$StressLines.Add("- blank_decision_row_count: $($DecisionBlankRows.Count)") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("final_verdict: ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_STRESS_BENCH_PASS") | Out-Null

$ReportLines = New-Object System.Collections.Generic.List[string]
$ReportLines.Add("# ROOT HELD GROUP SCRIPT CUSTODY REVIEW QUEUE V0_1 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: SCRIPT_CUSTODY_REVIEW_QUEUE / USER_APPROVED_OPTION_B / READ_ONLY / STRESS_BENCHED / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Build a read-only custody queue for root-level PowerShell scripts after user approval of Option B. This queue does not execute, move, delete, route, rename, commit, push, or promote any script.") | Out-Null
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
$ReportLines.Add("- git_commit_or_push_done_by_this_queue_card: NO") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Queue summary") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- review_snapshot_script_count: $ReviewSnapshotScriptCount") | Out-Null
$ReportLines.Add("- current_root_script_count: $CurrentScriptCount") | Out-Null
$ReportLines.Add("- scripts_seen_in_review_snapshot_count: $SeenInReviewCount") | Out-Null
$ReportLines.Add("- post_review_root_script_count: $PostReviewScriptCount") | Out-Null
$ReportLines.Add("- current_runner_count: $CurrentRunnerCount") | Out-Null
$ReportLines.Add("- action_now_row_count: $ActionNowCount") | Out-Null
$ReportLines.Add("- execute_now_decision_count: $($ExecuteNowRows.Count)") | Out-Null
$ReportLines.Add("- move_delete_route_decision_count: $($MoveDeleteRouteRows.Count)") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Custody class counts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| CustodyClass | Count |") | Out-Null
$ReportLines.Add("|---|---:|") | Out-Null
foreach ($Group in $CustodyClassGroups) {
    $ReportLines.Add("| $(Escape-Cell $Group.Name) | $($Group.Count) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Decision counts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| Decision | Count |") | Out-Null
$ReportLines.Add("|---|---:|") | Out-Null
foreach ($Group in $DecisionGroups) {
    $ReportLines.Add("| $(Escape-Cell $Group.Name) | $($Group.Count) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Script custody queue") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| Name | SizeBytes | SHA256 | LastWriteTime | SeenInReviewSnapshot | IsCurrentRunner | CustodyClass | Decision | ActionNow | Reason |") | Out-Null
$ReportLines.Add("|---|---:|---|---|---|---|---|---|---|---|") | Out-Null
foreach ($Row in $QueueRows) {
    $ReportLines.Add("| $(Escape-Cell $Row.Name) | $($Row.SizeBytes) | $($Row.Sha256) | $($Row.LastWriteTime) | $($Row.SeenInReviewSnapshot) | $($Row.IsCurrentRunner) | $(Escape-Cell $Row.CustodyClass) | $(Escape-Cell $Row.Decision) | $($Row.ActionNow) | $(Escape-Cell $Row.Reason) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Recommended handling from this queue") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Hold all root-level scripts pending later custody sorting. The next safe action is to import this queue, then build the non-script custody review queue. No script should be executed or physically routed from this card.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Stop lines") | Out-Null
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
$ReportLines.Add("- no commit or push from this queue card") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next selected action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("next_build_chunk_selected: $NextBuildChunk") | Out-Null
$ReportLines.Add("after_import_next_build_chunk_selected: $AfterImportNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## DoesNotProve") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This queue proves only that root-level scripts were listed and classified for custody review. It does not prove any script is safe to execute, move, delete, route, rewrite, commit, push, or promote.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

$StressLines | Set-Content -LiteralPath $StressPath -Encoding UTF8
$StressSha = Get-Sha256 -Path $StressPath

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "stress_bench_path: $StressPath",
    "stress_bench_sha256: $StressSha",
    "parent_option_report_path: $OptionReportPath",
    "parent_option_report_sha256: $OptionReportSha",
    "parent_option_rough_local_sha256: $OptionRoughLedgerSha",
    "review_report_path: $ReviewReportPath",
    "review_report_sha256: $ReviewReportSha",
    "git_top: $GitTop",
    "git_head_confirmed: $($GitHead.Trim())",
    "git_status_confirmed: CLEAN",
    "review_snapshot_script_count: $ReviewSnapshotScriptCount",
    "current_root_script_count: $CurrentScriptCount",
    "scripts_seen_in_review_snapshot_count: $SeenInReviewCount",
    "post_review_root_script_count: $PostReviewScriptCount",
    "current_runner_count: $CurrentRunnerCount",
    "action_now_row_count: $ActionNowCount",
    "bad_sha_row_count: $($BadShaRows.Count)",
    "execute_now_decision_count: $($ExecuteNowRows.Count)",
    "move_delete_route_decision_count: $($MoveDeleteRouteRows.Count)",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "git_commit_or_push_done: NO",
    "next_build_chunk_selected: $NextBuildChunk",
    "after_import_next_build_chunk_selected: $AfterImportNextBuildChunk",
    "does_not_prove: script safe to execute; script safe to move; script safe to delete; script safe to route; source safe to rewrite; doctrine safe to promote; push approved",
    "final_verdict: $FinalVerdict"
)

$ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptSha = Get-Sha256 -Path $ReceiptPath

Write-Host "=== ROOT HELD GROUP SCRIPT CUSTODY REVIEW QUEUE V0_1 COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "stress_bench_path: $StressPath"
Write-Host "stress_bench_sha256: $StressSha"
Write-Host "review_snapshot_script_count: $ReviewSnapshotScriptCount"
Write-Host "current_root_script_count: $CurrentScriptCount"
Write-Host "scripts_seen_in_review_snapshot_count: $SeenInReviewCount"
Write-Host "post_review_root_script_count: $PostReviewScriptCount"
Write-Host "current_runner_count: $CurrentRunnerCount"
Write-Host "action_now_row_count: $ActionNowCount"
Write-Host "bad_sha_row_count: $($BadShaRows.Count)"
Write-Host "execute_now_decision_count: $($ExecuteNowRows.Count)"
Write-Host "move_delete_route_decision_count: $($MoveDeleteRouteRows.Count)"
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

