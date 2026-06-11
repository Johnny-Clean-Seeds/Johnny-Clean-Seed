Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608"
$FinalVerdict = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_READY_WITH_STRESS_BENCH_PASS"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_ROUGH_LOCAL_IMPORT_20260608"
$AfterImportNextBuildChunk = "USER_APPROVED_ROOT_HELD_GROUP_NEXT_ACTION_SELECTOR_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "b91be645fb0800f93b649074309d94175c192b2a"

$ReviewReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$ReviewReportSha = "5926E984B853D3422023BF6AA5F4180A81C3AFE716FB6E18F09906102CBCD20D"

$ReviewReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608.txt"
$ReviewReceiptSha = "E34E00686A9014E543944F7FE22EE7462E21885FE26AD641BB57B0A4E1B49902"

$ReviewStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_STRESS_BENCH_20260608.md"
$ReviewStressSha = "553987B342C485816CDF39AC534BBA5875D5DC8C3CB0BF2CF321813A08BBFD3A"

$ReviewRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$ReviewRoughLedgerSha = "D84815EB025893BFCEF44B232A8E1A2BDE2D41C463AD7572AD2FD083A6E32632"

$ReviewRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608.txt"
$ReviewRoughReceiptSha = "2FBFCB76AD79EC7E39F01BE597D58A699033266B7E47C837A7919B7578D8E31F"

$ReviewGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2\ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$ReviewGitImportPacketSha = "D05023D1D6BCD215CA0D1C7EFC597DE04F0A983117A28CD4037125EDB131B4B8"

$ReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608.md"
$ReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608.txt"
$StressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_STRESS_BENCH_20260608.md"

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Blocker {
    param([string]$Message)
    $script:Blockers.Add($Message) | Out-Null
}

$Blockers = New-Object System.Collections.Generic.List[string]
$StressResults = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]

Write-Host "=== ROOT HELD GROUP ROUTE OR HOLD DECISION OPTION SET V0_2 ==="

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
    ReviewReportV02 = [ordered]@{ Path = $ReviewReportPath; Sha256 = $ReviewReportSha }
    ReviewReceiptV02 = [ordered]@{ Path = $ReviewReceiptPath; Sha256 = $ReviewReceiptSha }
    ReviewStressBenchV02 = [ordered]@{ Path = $ReviewStressPath; Sha256 = $ReviewStressSha }
    ReviewRoughLedgerV02 = [ordered]@{ Path = $ReviewRoughLedgerPath; Sha256 = $ReviewRoughLedgerSha }
    ReviewRoughReceiptV02 = [ordered]@{ Path = $ReviewRoughReceiptPath; Sha256 = $ReviewRoughReceiptSha }
    ReviewGitImportPacketV02 = [ordered]@{ Path = $ReviewGitImportPacketPath; Sha256 = $ReviewGitImportPacketSha }
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

$ReviewText = ""
$ReviewReceiptText = ""
$ReviewStressText = ""
$ReviewRoughText = ""

if (Test-Path -LiteralPath $ReviewReportPath -PathType Leaf) {
    $ReviewText = Get-Content -LiteralPath $ReviewReportPath -Raw
}
if (Test-Path -LiteralPath $ReviewReceiptPath -PathType Leaf) {
    $ReviewReceiptText = Get-Content -LiteralPath $ReviewReceiptPath -Raw
}
if (Test-Path -LiteralPath $ReviewStressPath -PathType Leaf) {
    $ReviewStressText = Get-Content -LiteralPath $ReviewStressPath -Raw
}
if (Test-Path -LiteralPath $ReviewRoughLedgerPath -PathType Leaf) {
    $ReviewRoughText = Get-Content -LiteralPath $ReviewRoughLedgerPath -Raw
}

$RequiredSignals = @(
    "prep_rows_parsed: 48",
    "prep_rows_hash_matched_now: 48",
    "prep_rows_missing_now: 0",
    "prep_rows_hash_changed_now: 0",
    "extra_root_files_not_in_prep_snapshot_count: 3",
    "extra_root_scripts_not_in_prep_snapshot_count: 3",
    "extra_root_non_scripts_not_in_prep_snapshot_count: 0",
    "decision_hold_count: 46",
    "decision_leave_count: 1",
    "decision_exclude_count: 1",
    "decision_block_count: 0",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $RequiredSignals) {
    if ($ReviewText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "REVIEW_SIGNAL_MISSING: $Signal"
    }
}

$RequiredReceiptSignals = @(
    "git_status_confirmed: CLEAN",
    "git_commit_or_push_done: NO",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0"
)

foreach ($Signal in $RequiredReceiptSignals) {
    if ($ReviewReceiptText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "REVIEW_RECEIPT_SIGNAL_MISSING: $Signal"
    }
}

if ($ReviewStressText -notmatch [regex]::Escape("ROOT_HELD_GROUP_REVIEW_V0_2_STRESS_BENCH_PASS")) {
    Add-Blocker "REVIEW_STRESS_PASS_SIGNAL_MISSING"
}
if ($ReviewRoughText -notmatch [regex]::Escape("ROUGH_LOCAL_ROOT_HELD_GROUP_READ_ONLY_REVIEW_V0_2_POINTER_LEDGER_READY")) {
    Add-Blocker "REVIEW_ROUGH_LOCAL_POINTER_LEDGER_READY_SIGNAL_MISSING"
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
    Write-Host "=== BLOCKERS FOUND BEFORE OPTION SET WRITE ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_OPTION_SET_V0_2_BLOCKED_BEFORE_WRITE"
    exit 2
}

$OptionRows = @(
    [pscustomobject]@{
        OptionId = "A"
        Name = "Hold all root-held files in place"
        ActionType = "NO_ACTION"
        RequiresUserApproval = "YES"
        DoesNow = "Nothing"
        DoesNotDo = "Does not move, delete, route, execute, commit, or push"
        UseWhen = "User wants to stop safely and preserve current state"
        Risk = "LOW"
        RecommendedNow = "SAFE_DEFAULT"
    },
    [pscustomobject]@{
        OptionId = "B"
        Name = "Build script custody review queue"
        ActionType = "READ_ONLY_NEXT_CARD"
        RequiresUserApproval = "YES"
        DoesNow = "Creates a read-only list of root-level scripts, including the 42 in-snapshot scripts and 3 post-snapshot scripts"
        DoesNotDo = "Does not execute scripts or move them"
        UseWhen = "User wants to sort runner/import/build scripts before any old-load routing"
        Risk = "LOW"
        RecommendedNow = "YES"
    },
    [pscustomobject]@{
        OptionId = "C"
        Name = "Build non-script custody review queue"
        ActionType = "READ_ONLY_NEXT_CARD"
        RequiresUserApproval = "YES"
        DoesNow = "Creates a read-only list for the source authority object, zero-byte file, root documents, and desktop.ini leave-in-place rule"
        DoesNotDo = "Does not rewrite source or delete zero-byte files"
        UseWhen = "User wants to separate source/support/history/system metadata before routing"
        Risk = "LOW"
        RecommendedNow = "YES_AFTER_B"
    },
    [pscustomobject]@{
        OptionId = "D"
        Name = "Build route plan only"
        ActionType = "PLAN_ONLY"
        RequiresUserApproval = "YES"
        DoesNow = "Drafts a future route map such as script-history, _OLD_LOADS, support, source-custody, and leave-in-place buckets"
        DoesNotDo = "Does not actually move files"
        UseWhen = "User wants a routing map before any physical file operation"
        Risk = "LOW"
        RecommendedNow = "AFTER_B_AND_C"
    },
    [pscustomobject]@{
        OptionId = "E"
        Name = "Execute approved route plan later"
        ActionType = "WRITE_ACTION_LATER_ONLY"
        RequiresUserApproval = "YES_EXPLICIT"
        DoesNow = "Nothing in this option set"
        DoesNotDo = "No execution is allowed from this option-set card"
        UseWhen = "Only after B/C/D exist, user approves exact destinations, and a dry-run route script passes"
        Risk = "HIGH_IF_DONE_TOO_EARLY"
        RecommendedNow = "NO"
    }
)

# Stress bench: prove option set shape before writing.
if ($OptionRows.Count -ne 5) {
    Add-Blocker "STRESS_FAIL_OPTION_COUNT: expected 5 :: got $($OptionRows.Count)"
} else {
    $StressResults.Add("PASS option_count_is_5") | Out-Null
}

$MissingApproval = @($OptionRows | Where-Object { $_.RequiresUserApproval -notmatch "^YES" })
if ($MissingApproval.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_OPTION_WITHOUT_USER_APPROVAL: $($MissingApproval.Count)"
} else {
    $StressResults.Add("PASS every option requires user approval") | Out-Null
}

$UnsafeNow = @($OptionRows | Where-Object { $_.DoesNow -match "move|delete|execute|commit|push" -and $_.ActionType -ne "WRITE_ACTION_LATER_ONLY" })
if ($UnsafeNow.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_OPTION_DOES_WRITE_ACTION_NOW: $($UnsafeNow.Count)"
} else {
    $StressResults.Add("PASS no option performs write action now") | Out-Null
}

$MissingNoDo = @($OptionRows | Where-Object { $_.DoesNotDo -notmatch "move|delete|execute|commit|push" })
if ($MissingNoDo.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_OPTION_MISSING_STOP_LINE_LANGUAGE: $($MissingNoDo.Count)"
} else {
    $StressResults.Add("PASS every option carries stop-line language") | Out-Null
}

$RecommendedNow = @($OptionRows | Where-Object { $_.RecommendedNow -eq "YES" })
if ($RecommendedNow.Count -ne 1 -or $RecommendedNow[0].OptionId -ne "B") {
    Add-Blocker "STRESS_FAIL_RECOMMENDED_NOW_NOT_OPTION_B"
} else {
    $StressResults.Add("PASS recommended immediate next option is B: script custody review queue") | Out-Null
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND DURING OPTION SET STRESS BENCH ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_OPTION_SET_V0_2_STRESS_BENCH_BLOCKED"
    exit 2
}

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$StressLines = New-Object System.Collections.Generic.List[string]
$StressLines.Add("# ROOT HELD GROUP ROUTE OR HOLD DECISION OPTION SET V0_2 STRESS BENCH 20260608") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("Status: OPTION_SET_STRESS_BENCH / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH") | Out-Null
$StressLines.Add("Created: $Now") | Out-Null
$StressLines.Add("Active object: $ActiveObject") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("## Stress results") | Out-Null
$StressLines.Add("") | Out-Null
foreach ($Result in $StressResults) { $StressLines.Add("- $Result") | Out-Null }
$StressLines.Add("") | Out-Null
$StressLines.Add("## Counts") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("- option_count: $($OptionRows.Count)") | Out-Null
$StressLines.Add("- options_without_user_approval_count: $($MissingApproval.Count)") | Out-Null
$StressLines.Add("- options_doing_write_action_now_count: $($UnsafeNow.Count)") | Out-Null
$StressLines.Add("- options_missing_stop_line_language_count: $($MissingNoDo.Count)") | Out-Null
$StressLines.Add("- recommended_now_option: B") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("final_verdict: ROOT_HELD_GROUP_OPTION_SET_V0_2_STRESS_BENCH_PASS") | Out-Null

$ReportLines = New-Object System.Collections.Generic.List[string]
$ReportLines.Add("# ROOT HELD GROUP ROUTE OR HOLD DECISION OPTION SET V0_2 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: OPTION_SET / USER_DECISION_SURFACE / READ_ONLY / STRESS_BENCHED / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Present bounded next-action options after the corrected V0_2 root-held review. This card does not authorize physical routing or cleanup.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Verified load-bearing evidence") | Out-Null
$ReportLines.Add("") | Out-Null
foreach ($Line in $VerifiedLines) { $ReportLines.Add("- $Line") | Out-Null }
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Carried review facts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- prep_rows_parsed: 48") | Out-Null
$ReportLines.Add("- prep_rows_hash_matched_now: 48") | Out-Null
$ReportLines.Add("- prep_rows_missing_now: 0") | Out-Null
$ReportLines.Add("- prep_rows_hash_changed_now: 0") | Out-Null
$ReportLines.Add("- current_root_top_level_file_count_at_review: 51") | Out-Null
$ReportLines.Add("- extra_root_files_not_in_prep_snapshot_count: 3") | Out-Null
$ReportLines.Add("- extra_root_scripts_not_in_prep_snapshot_count: 3") | Out-Null
$ReportLines.Add("- extra_root_non_scripts_not_in_prep_snapshot_count: 0") | Out-Null
$ReportLines.Add("- decision_hold_count: 46") | Out-Null
$ReportLines.Add("- decision_leave_count: 1") | Out-Null
$ReportLines.Add("- decision_exclude_count: 1") | Out-Null
$ReportLines.Add("- decision_block_count: 0") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Option table") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| OptionId | Name | ActionType | RequiresUserApproval | DoesNow | DoesNotDo | UseWhen | Risk | RecommendedNow |") | Out-Null
$ReportLines.Add("|---|---|---|---|---|---|---|---|---|") | Out-Null
foreach ($Option in $OptionRows) {
    $ReportLines.Add("| $($Option.OptionId) | $($Option.Name) | $($Option.ActionType) | $($Option.RequiresUserApproval) | $($Option.DoesNow) | $($Option.DoesNotDo) | $($Option.UseWhen) | $($Option.Risk) | $($Option.RecommendedNow) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Recommended next action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Recommended next action is Option B: build a read-only script custody review queue. Reason: the review shows 42 root-level scripts in the V0_2 prep snapshot plus 3 post-snapshot root scripts. Script artifacts are the largest held class, and no script should be executed or moved until script custody is sorted.") | Out-Null
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
$ReportLines.Add("- no commit or push from this option set") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next selected action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("next_build_chunk_selected: $NextBuildChunk") | Out-Null
$ReportLines.Add("after_import_next_build_chunk_selected: $AfterImportNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## DoesNotProve") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This option set proves only that bounded user-decision options were generated from the corrected V0_2 review. It does not prove any file is safe to move, delete, route, execute, rewrite, commit, push, or promote.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

$StressLines | Set-Content -LiteralPath $StressPath -Encoding UTF8
$StressSha = Get-Sha256 -Path $StressPath

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "stress_bench_path: $StressPath",
    "stress_bench_sha256: $StressSha",
    "parent_review_report_path: $ReviewReportPath",
    "parent_review_report_sha256: $ReviewReportSha",
    "parent_review_rough_local_sha256: $ReviewRoughLedgerSha",
    "git_top: $GitTop",
    "git_head_confirmed: $($GitHead.Trim())",
    "git_status_confirmed: CLEAN",
    "option_count: $($OptionRows.Count)",
    "recommended_now_option: B",
    "recommended_now_label: BUILD_SCRIPT_CUSTODY_REVIEW_QUEUE",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "git_commit_or_push_done: NO",
    "next_build_chunk_selected: $NextBuildChunk",
    "after_import_next_build_chunk_selected: $AfterImportNextBuildChunk",
    "does_not_prove: file safe to move; file safe to delete; file safe to route; script safe to execute; source safe to rewrite; doctrine safe to promote; push approved",
    "final_verdict: $FinalVerdict"
)

$ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptSha = Get-Sha256 -Path $ReceiptPath

Write-Host "=== ROOT HELD GROUP ROUTE OR HOLD DECISION OPTION SET V0_2 COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "stress_bench_path: $StressPath"
Write-Host "stress_bench_sha256: $StressSha"
Write-Host "option_count: $($OptionRows.Count)"
Write-Host "recommended_now_option: B"
Write-Host "recommended_now_label: BUILD_SCRIPT_CUSTODY_REVIEW_QUEUE"
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
