Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_ROUGH_LOCAL_IMPORT_20260608"
$FinalVerdict = "ROUGH_LOCAL_ROOT_HELD_GROUP_READ_ONLY_REVIEW_V0_2_COMMITTED_TO_NESTED_REPO"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneRel = "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$LaneDir = Join-Path $Root $LaneRel
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "890f8fa23ebee28eb3c3bd99cd396868fde402d6"

$ReviewReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$ReviewReportSha = "5926E984B853D3422023BF6AA5F4180A81C3AFE716FB6E18F09906102CBCD20D"

$ReviewReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608.txt"
$ReviewReceiptSha = "E34E00686A9014E543944F7FE22EE7462E21885FE26AD641BB57B0A4E1B49902"

$ReviewStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_STRESS_BENCH_20260608.md"
$ReviewStressSha = "553987B342C485816CDF39AC534BBA5875D5DC8C3CB0BF2CF321813A08BBFD3A"

$PrepCardPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_20260608.md"
$PrepCardSha = "5E7F2234E72DC05D318E24767BDC057912274BEA5368507208CEF4CDDAD460C1"

$PrepStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_STRESS_BENCH_20260608.md"
$PrepStressSha = "BDFD4FED741CBFCB3B1DF8DFF0E3D5EF31E17BC3D190EC907EB04C5D962587CD"

$PrepRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_20260608.md"
$PrepRoughLedgerSha = "B972BDBF87A4A1AC0AF5E4E594AA53422BE786D0CF533BC8CDDEC968664DC8CD"

$PrepRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_RECEIPT_20260608.txt"
$PrepRoughReceiptSha = "FA9C6A9F828D7EC608F6F4F9ACC49D293930B6E6B10BBE18379FBEBE8C99F843"

$PrepGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2\ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$PrepGitImportPacketSha = "35EEF6AB14FE49558DF35444C50363CAE64A7D45C05F7D43923BE29AAE1A8F4D"

$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2"
$GitImportDir = Join-Path $GitTop ($GitImportRel -replace "/", "\")

$LocalRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$LocalRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608.txt"

$GitRoughLedgerRel = "$GitImportRel/ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$GitRoughReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608.txt"
$GitImportPacketReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

$GitRoughLedgerPath = Join-Path $GitTop ($GitRoughLedgerRel -replace "/", "\")
$GitRoughReceiptPath = Join-Path $GitTop ($GitRoughReceiptRel -replace "/", "\")
$GitImportPacketReceiptPath = Join-Path $GitTop ($GitImportPacketReceiptRel -replace "/", "\")

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Blocker {
    param([string]$Message)
    $script:Blockers.Add($Message) | Out-Null
}

$Blockers = New-Object System.Collections.Generic.List[string]

Write-Host "=== ROUGH_LOCAL IMPORT: ROOT HELD GROUP READ ONLY REVIEW V0_2 ==="

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
    PrepCardV02 = [ordered]@{ Path = $PrepCardPath; Sha256 = $PrepCardSha }
    PrepStressBenchV02 = [ordered]@{ Path = $PrepStressPath; Sha256 = $PrepStressSha }
    PrepRoughLocalLedgerV02 = [ordered]@{ Path = $PrepRoughLedgerPath; Sha256 = $PrepRoughLedgerSha }
    PrepRoughLocalReceiptV02 = [ordered]@{ Path = $PrepRoughReceiptPath; Sha256 = $PrepRoughReceiptSha }
    PrepGitImportPacketReceiptV02 = [ordered]@{ Path = $PrepGitImportPacketPath; Sha256 = $PrepGitImportPacketSha }
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
    }
}

$ReviewText = ""
$ReviewReceiptText = ""
$ReviewStressText = ""

if (Test-Path -LiteralPath $ReviewReportPath -PathType Leaf) {
    $ReviewText = Get-Content -LiteralPath $ReviewReportPath -Raw
}
if (Test-Path -LiteralPath $ReviewReceiptPath -PathType Leaf) {
    $ReviewReceiptText = Get-Content -LiteralPath $ReviewReceiptPath -Raw
}
if (Test-Path -LiteralPath $ReviewStressPath -PathType Leaf) {
    $ReviewStressText = Get-Content -LiteralPath $ReviewStressPath -Raw
}

$RequiredReviewSignals = @(
    "V0_2_CORRECTED_PREP_CARD",
    "prep_rows_parsed: 48",
    "prep_rows_hash_matched_now: 48",
    "prep_rows_missing_now: 0",
    "prep_rows_hash_changed_now: 0",
    "extra_root_non_scripts_not_in_prep_snapshot_count: 0",
    "decision_hold_count: 46",
    "decision_leave_count: 1",
    "decision_exclude_count: 1",
    "decision_block_count: 0",
    "next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_ROUGH_LOCAL_IMPORT_20260608",
    "after_import_next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $RequiredReviewSignals) {
    if ($ReviewText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "REVIEW_V0_2_SIGNAL_MISSING: $Signal"
    }
}

$RequiredReceiptSignals = @(
    "prep_rows_parsed: 48",
    "prep_rows_hash_matched_now: 48",
    "prep_rows_missing_now: 0",
    "prep_rows_hash_changed_now: 0",
    "decision_block_count: 0",
    "git_status_confirmed: CLEAN",
    "git_commit_or_push_done: NO",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $RequiredReceiptSignals) {
    if ($ReviewReceiptText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "REVIEW_RECEIPT_V0_2_SIGNAL_MISSING: $Signal"
    }
}

$RequiredStressSignals = @(
    "ROOT_HELD_GROUP_REVIEW_V0_2_STRESS_BENCH_PASS",
    "prep_rows_parsed: 48",
    "prep_rows_hash_matched_now: 48",
    "prep_rows_missing_now: 0",
    "prep_rows_hash_changed_now: 0",
    "empty_decision_row_count: 0"
)

foreach ($Signal in $RequiredStressSignals) {
    if ($ReviewStressText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "REVIEW_STRESS_V0_2_SIGNAL_MISSING: $Signal"
    }
}

$GitHeadBefore = ""
$GitStatusBefore = ""

if (Test-Path -LiteralPath $GitTop -PathType Container) {
    $GitHeadBefore = (& git -C $GitTop rev-parse HEAD 2>&1)
    if ($LASTEXITCODE -ne 0) {
        Add-Blocker "GIT_HEAD_READ_FAILED_BEFORE: $GitHeadBefore"
    } elseif ($GitHeadBefore.Trim() -ne $ExpectedGitHead) {
        Add-Blocker "GIT_HEAD_MISMATCH_BEFORE: expected $ExpectedGitHead :: got $($GitHeadBefore.Trim())"
    }

    $GitStatusBefore = (& git -C $GitTop status --short 2>&1)
    if ($LASTEXITCODE -ne 0) {
        Add-Blocker "GIT_STATUS_READ_FAILED_BEFORE: $GitStatusBefore"
    } elseif (($GitStatusBefore | Out-String).Trim().Length -ne 0) {
        Add-Blocker "GIT_STATUS_NOT_CLEAN_BEFORE: $($GitStatusBefore | Out-String)"
    }
}

$Outputs = @(
    $LocalRoughLedgerPath,
    $LocalRoughReceiptPath,
    $GitRoughLedgerPath,
    $GitRoughReceiptPath,
    $GitImportPacketReceiptPath
)

foreach ($OutputPath in $Outputs) {
    if (Test-Path -LiteralPath $OutputPath -PathType Leaf) {
        Add-Blocker "OUTPUT_ALREADY_EXISTS_NO_OVERWRITE: $OutputPath"
    }
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND BEFORE WRITE ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_REVIEW_V0_2_ROUGH_LOCAL_IMPORT_BLOCKED"
    exit 2
}

New-Item -ItemType Directory -Force -Path $GitImportDir | Out-Null

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$RoughLedgerLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP READ ONLY REVIEW V0_2 20260608",
    "",
    "Status: ROUGH_LOCAL_POINTER_LEDGER / REVIEW_DECISION_TABLE / STRESS_BENCH_CONFIRMED / GIT_IMPORT_PACKET / NOT_FULL_LOCAL_EVIDENCE / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE",
    "Created: $Now",
    "Active object: $ActiveObject",
    "",
    "## Source review report",
    "",
    "- path: $ReviewReportPath",
    "- sha256: $ReviewReportSha",
    "",
    "## Source review receipt",
    "",
    "- path: $ReviewReceiptPath",
    "- sha256: $ReviewReceiptSha",
    "",
    "## Review stress bench proof",
    "",
    "- path: $ReviewStressPath",
    "- sha256: $ReviewStressSha",
    "- prep_rows_parsed: 48",
    "- prep_rows_hash_matched_now: 48",
    "- prep_rows_missing_now: 0",
    "- prep_rows_hash_changed_now: 0",
    "- empty_decision_row_count: 0",
    "",
    "## Parent corrected prep proof",
    "",
    "- prep_card_v0_2_path: $PrepCardPath",
    "- prep_card_v0_2_sha256: $PrepCardSha",
    "- prep_stress_bench_v0_2_path: $PrepStressPath",
    "- prep_stress_bench_v0_2_sha256: $PrepStressSha",
    "- prep_rough_local_path: $PrepRoughLedgerPath",
    "- prep_rough_local_sha256: $PrepRoughLedgerSha",
    "- prep_git_import_packet_sha256: $PrepGitImportPacketSha",
    "",
    "## Carried review facts",
    "",
    "- prep_rows_parsed: 48",
    "- prep_rows_hash_matched_now: 48",
    "- prep_rows_missing_now: 0",
    "- prep_rows_hash_changed_now: 0",
    "- current_root_top_level_file_count: 51",
    "- extra_root_files_not_in_prep_snapshot_count: 3",
    "- extra_root_scripts_not_in_prep_snapshot_count: 3",
    "- extra_root_non_scripts_not_in_prep_snapshot_count: 0",
    "- decision_hold_count: 46",
    "- decision_leave_count: 1",
    "- decision_exclude_count: 1",
    "- decision_block_count: 0",
    "- files_moved_count: 0",
    "- files_deleted_count: 0",
    "- files_renamed_count: 0",
    "- files_routed_count: 0",
    "- files_executed_count: 0",
    "- git_head_before_import: $($GitHeadBefore.Trim())",
    "- git_status_before_import: CLEAN",
    "",
    "## Import decision",
    "",
    "Import only pointer truth for the corrected V0_2 review and stress bench into the nested Git repo.",
    "Do not import full local root evidence. Do not clean up. Do not move root-held files. Do not delete. Do not route. Do not execute root scripts. Do not rewrite source. Do not promote doctrine. Do not push.",
    "",
    "## Next selected action",
    "",
    "next_build_chunk_selected: $NextBuildChunk",
    "",
    "## DoesNotProve",
    "",
    "This rough_local import proves only that the corrected V0_2 review pointer ledger and receipt were imported into nested Git. It does not prove the root files are safe, public-safe, stale, trash, route-ready, delete-ready, move-ready, source-ready, helper-ready, doctrine-ready, pushed, or cleaned.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_READ_ONLY_REVIEW_V0_2_POINTER_LEDGER_READY"
)

$RoughLedgerLines | Set-Content -LiteralPath $LocalRoughLedgerPath -Encoding UTF8
$LocalRoughLedgerSha = Get-Sha256 -Path $LocalRoughLedgerPath

$RoughReceiptLines = @(
    "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "source_review_report_path: $ReviewReportPath",
    "source_review_report_sha256: $ReviewReportSha",
    "source_review_receipt_path: $ReviewReceiptPath",
    "source_review_receipt_sha256: $ReviewReceiptSha",
    "review_stress_bench_path: $ReviewStressPath",
    "review_stress_bench_sha256: $ReviewStressSha",
    "rough_local_ledger_path: $LocalRoughLedgerPath",
    "rough_local_ledger_sha256: $LocalRoughLedgerSha",
    "git_head_before_import: $($GitHeadBefore.Trim())",
    "git_status_before_import: CLEAN",
    "prep_rows_parsed: 48",
    "prep_rows_hash_matched_now: 48",
    "prep_rows_missing_now: 0",
    "prep_rows_hash_changed_now: 0",
    "current_root_top_level_file_count: 51",
    "extra_root_files_not_in_prep_snapshot_count: 3",
    "extra_root_scripts_not_in_prep_snapshot_count: 3",
    "extra_root_non_scripts_not_in_prep_snapshot_count: 0",
    "decision_hold_count: 46",
    "decision_leave_count: 1",
    "decision_exclude_count: 1",
    "decision_block_count: 0",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "next_build_chunk_selected: $NextBuildChunk",
    "does_not_prove: root files safe; cleanup approved; movement approved; deletion approved; routing approved; source replay approved; helper execution approved; doctrine promotion approved; push approved",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_READ_ONLY_REVIEW_V0_2_RECEIPT_READY"
)

$RoughReceiptLines | Set-Content -LiteralPath $LocalRoughReceiptPath -Encoding UTF8
$LocalRoughReceiptSha = Get-Sha256 -Path $LocalRoughReceiptPath

Copy-Item -LiteralPath $LocalRoughLedgerPath -Destination $GitRoughLedgerPath -Force
Copy-Item -LiteralPath $LocalRoughReceiptPath -Destination $GitRoughReceiptPath -Force

$ImportPacketLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP READ ONLY REVIEW V0_2 GIT IMPORT PACKET RECEIPT 20260608",
    "",
    "Status: GIT_IMPORT_PACKET_RECEIPT / EXACT_STAGED_SET_REQUIRED / NO_PUSH / REVIEW_DECISION_TABLE",
    "Created: $Now",
    "Active object: $ActiveObject",
    "",
    "## Local rough_local files",
    "",
    "- rough_local_ledger_path: $LocalRoughLedgerPath",
    "- rough_local_ledger_sha256: $LocalRoughLedgerSha",
    "- rough_local_receipt_path: $LocalRoughReceiptPath",
    "- rough_local_receipt_sha256: $LocalRoughReceiptSha",
    "",
    "## Corrected review source evidence",
    "",
    "- review_report_v0_2_path: $ReviewReportPath",
    "- review_report_v0_2_sha256: $ReviewReportSha",
    "- review_receipt_v0_2_path: $ReviewReceiptPath",
    "- review_receipt_v0_2_sha256: $ReviewReceiptSha",
    "- review_stress_bench_path: $ReviewStressPath",
    "- review_stress_bench_sha256: $ReviewStressSha",
    "",
    "## Git import files",
    "",
    "- $GitRoughLedgerRel",
    "- $GitRoughReceiptRel",
    "- $GitImportPacketReceiptRel",
    "",
    "## Git before import",
    "",
    "- git_head_before_import: $($GitHeadBefore.Trim())",
    "- git_status_before_import: CLEAN",
    "",
    "## Boundary",
    "",
    "This import stages and commits exactly three files. It does not push. It does not cleanup. It does not move, delete, route, or execute root files. It does not rewrite source. It does not promote doctrine.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_READ_ONLY_REVIEW_V0_2_GIT_IMPORT_PACKET_RECEIPT_READY"
)

$ImportPacketLines | Set-Content -LiteralPath $GitImportPacketReceiptPath -Encoding UTF8
$ImportPacketSha = Get-Sha256 -Path $GitImportPacketReceiptPath

$ExpectedStageRel = @(
    $GitRoughLedgerRel,
    $GitRoughReceiptRel,
    $GitImportPacketReceiptRel
)

Write-Host "corrected root-held review hashes verified: YES"
Write-Host "rough_local_ledger_sha256: $LocalRoughLedgerSha"
Write-Host "rough_local_receipt_sha256: $LocalRoughReceiptSha"
Write-Host "import_packet_receipt_sha256: $ImportPacketSha"
Write-Host "git_top: $GitTop"

& git -C $GitTop add -- $ExpectedStageRel
if ($LASTEXITCODE -ne 0) {
    Write-Host "final_verdict: GIT_ADD_FAILED"
    exit 2
}

$Staged = @(& git -C $GitTop diff --cached --name-only)
if ($LASTEXITCODE -ne 0) {
    Write-Host "final_verdict: GIT_STAGED_SET_READ_FAILED"
    exit 2
}

$ExpectedSorted = $ExpectedStageRel | Sort-Object
$StagedSorted = $Staged | Sort-Object

$ExpectedJoined = ($ExpectedSorted -join "`n").Trim()
$StagedJoined = ($StagedSorted -join "`n").Trim()

if ($ExpectedJoined -ne $StagedJoined) {
    Write-Host "=== STAGED SET MISMATCH ==="
    Write-Host "expected:"
    $ExpectedSorted | ForEach-Object { Write-Host $_ }
    Write-Host "actual:"
    $StagedSorted | ForEach-Object { Write-Host $_ }
    Write-Host "final_verdict: EXACT_STAGED_SET_MISMATCH_BLOCKED"
    exit 2
}

Write-Host "=== EXACT STAGED SET CONFIRMED ==="
$StagedSorted | ForEach-Object { Write-Host $_ }

& git -C $GitTop commit -m "Add corrected root held group review rough local ledger"
if ($LASTEXITCODE -ne 0) {
    Write-Host "final_verdict: GIT_COMMIT_FAILED"
    exit 2
}

$CommitHash = (& git -C $GitTop rev-parse HEAD).Trim()
$PostStatus = (& git -C $GitTop status --short)
if ($LASTEXITCODE -ne 0) {
    Write-Host "final_verdict: GIT_STATUS_READ_FAILED_AFTER_COMMIT"
    exit 2
}

if (($PostStatus | Out-String).Trim().Length -ne 0) {
    Write-Host "=== POST COMMIT STATUS NOT CLEAN ==="
    $PostStatus | ForEach-Object { Write-Host $_ }
    Write-Host "final_verdict: POST_COMMIT_STATUS_NOT_CLEAN"
    exit 2
}

Write-Host ""
Write-Host "=== ROOT HELD GROUP READ ONLY REVIEW V0_2 ROUGH_LOCAL IMPORT COMMITTED ==="
Write-Host "commit_hash: $CommitHash"
Write-Host "commit_message: Add corrected root held group review rough local ledger"
Write-Host "files_committed_count: 3"
Write-Host "files_committed:"
$ExpectedStageRel | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "rough_local_ledger_path: $LocalRoughLedgerPath"
Write-Host "rough_local_ledger_sha256: $LocalRoughLedgerSha"
Write-Host "rough_local_receipt_path: $LocalRoughReceiptPath"
Write-Host "rough_local_receipt_sha256: $LocalRoughReceiptSha"
Write-Host "import_packet_receipt_sha256: $ImportPacketSha"
Write-Host ""
Write-Host "post_commit_status_short:"
Write-Host "CLEAN"
Write-Host ""
Write-Host "next_build_chunk_selected: $NextBuildChunk"
Write-Host "final_verdict: $FinalVerdict"
