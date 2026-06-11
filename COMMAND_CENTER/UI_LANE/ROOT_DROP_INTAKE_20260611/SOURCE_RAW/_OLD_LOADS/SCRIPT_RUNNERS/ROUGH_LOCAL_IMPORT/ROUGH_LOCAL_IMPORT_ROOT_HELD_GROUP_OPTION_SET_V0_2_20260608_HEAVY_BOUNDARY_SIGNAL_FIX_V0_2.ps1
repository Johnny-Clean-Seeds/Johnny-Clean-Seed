Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_ROUGH_LOCAL_IMPORT_20260608"
$FinalVerdict = "ROUGH_LOCAL_ROOT_HELD_GROUP_OPTION_SET_V0_2_COMMITTED_TO_NESTED_REPO"
$NextBuildChunk = "USER_APPROVED_ROOT_HELD_GROUP_NEXT_ACTION_SELECTOR_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneRel = "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$LaneDir = Join-Path $Root $LaneRel
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "b91be645fb0800f93b649074309d94175c192b2a"

$OptionReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608.md"
$OptionReportSha = "A481C79DA3206ADBB1A1BC43226CBFFB3F8AE2012A94539375D6EC35960D2965"

$OptionReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608.txt"
$OptionReceiptSha = "6D3D51A37A5C9D7979E1E3F3C1289B6585AF41658FE99F022C6E8CD425AC5DC5"

$OptionStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_STRESS_BENCH_20260608.md"
$OptionStressSha = "28F86A1766538C96197029314E1A20217AB798970F010B6A79C4A54BF3E348FA"

$ReviewReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$ReviewReportSha = "5926E984B853D3422023BF6AA5F4180A81C3AFE716FB6E18F09906102CBCD20D"

$ReviewRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$ReviewRoughLedgerSha = "D84815EB025893BFCEF44B232A8E1A2BDE2D41C463AD7572AD2FD083A6E32632"

$ReviewRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_RECEIPT_20260608.txt"
$ReviewRoughReceiptSha = "2FBFCB76AD79EC7E39F01BE597D58A699033266B7E47C837A7919B7578D8E31F"

$ReviewGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2\ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$ReviewGitImportPacketSha = "D05023D1D6BCD215CA0D1C7EFC597DE04F0A983117A28CD4037125EDB131B4B8"

$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2"
$GitImportDir = Join-Path $GitTop ($GitImportRel -replace "/", "\")

$LocalRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608.md"
$LocalRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608.txt"

$GitRoughLedgerRel = "$GitImportRel/ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608.md"
$GitRoughReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608.txt"
$GitImportPacketReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

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

Write-Host "=== ROUGH_LOCAL IMPORT: ROOT HELD GROUP OPTION SET V0_2 SIGNAL_FIX_V0_2 ==="

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
    ParentReviewReportV02 = [ordered]@{ Path = $ReviewReportPath; Sha256 = $ReviewReportSha }
    ParentReviewRoughLedgerV02 = [ordered]@{ Path = $ReviewRoughLedgerPath; Sha256 = $ReviewRoughLedgerSha }
    ParentReviewRoughReceiptV02 = [ordered]@{ Path = $ReviewRoughReceiptPath; Sha256 = $ReviewRoughReceiptSha }
    ParentReviewGitImportPacketV02 = [ordered]@{ Path = $ReviewGitImportPacketPath; Sha256 = $ReviewGitImportPacketSha }
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

$OptionText = ""
$OptionReceiptText = ""
$OptionStressText = ""

if (Test-Path -LiteralPath $OptionReportPath -PathType Leaf) {
    $OptionText = Get-Content -LiteralPath $OptionReportPath -Raw
}
if (Test-Path -LiteralPath $OptionReceiptPath -PathType Leaf) {
    $OptionReceiptText = Get-Content -LiteralPath $OptionReceiptPath -Raw
}
if (Test-Path -LiteralPath $OptionStressPath -PathType Leaf) {
    $OptionStressText = Get-Content -LiteralPath $OptionStressPath -Raw
}

$RequiredOptionSignals = @(
    "Status: OPTION_SET / USER_DECISION_SURFACE / READ_ONLY / STRESS_BENCHED",
    "Recommended next action is Option B: build a read-only script custody review queue.",
    "No move, delete, route, execute, commit, or push is allowed from this option-set card",
    "next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_ROUGH_LOCAL_IMPORT_20260608",
    "after_import_next_build_chunk_selected: USER_APPROVED_ROOT_HELD_GROUP_NEXT_ACTION_SELECTOR_20260608",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $RequiredOptionSignals) {
    if ($OptionText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "OPTION_SET_SIGNAL_MISSING: $Signal"
    }
}

$RequiredReceiptSignals = @(
    "option_count: 5",
    "recommended_now_option: B",
    "recommended_now_label: BUILD_SCRIPT_CUSTODY_REVIEW_QUEUE",
    "git_status_confirmed: CLEAN",
    "git_commit_or_push_done: NO",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $RequiredReceiptSignals) {
    if ($OptionReceiptText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "OPTION_RECEIPT_SIGNAL_MISSING: $Signal"
    }
}

$RequiredStressSignals = @(
    "ROOT_HELD_GROUP_OPTION_SET_V0_2_STRESS_BENCH_PASS",
    "option_count: 5",
    "options_without_user_approval_count: 0",
    "options_doing_write_action_now_count: 0",
    "options_missing_stop_line_language_count: 0",
    "recommended_now_option: B"
)

foreach ($Signal in $RequiredStressSignals) {
    if ($OptionStressText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "OPTION_STRESS_SIGNAL_MISSING: $Signal"
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
    Write-Host "final_verdict: ROOT_HELD_GROUP_OPTION_SET_V0_2_ROUGH_LOCAL_IMPORT_BLOCKED"
    exit 2
}

New-Item -ItemType Directory -Force -Path $GitImportDir | Out-Null

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$RoughLedgerLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP OPTION SET V0_2 20260608",
    "",
    "Status: ROUGH_LOCAL_POINTER_LEDGER / OPTION_SET / USER_DECISION_SURFACE / STRESS_BENCH_CONFIRMED / IMPORT_SIGNAL_LOCATION_FIX / GIT_IMPORT_PACKET / NOT_FULL_LOCAL_EVIDENCE / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE",
    "Created: $Now",
    "Active object: $ActiveObject",
    "",
    "## Source option set report",
    "",
    "- path: $OptionReportPath",
    "- sha256: $OptionReportSha",
    "",
    "## Source option set receipt",
    "",
    "- path: $OptionReceiptPath",
    "- sha256: $OptionReceiptSha",
    "",
    "## Option set stress bench proof",
    "",
    "- path: $OptionStressPath",
    "- sha256: $OptionStressSha",
    "- option_count: 5",
    "- options_without_user_approval_count: 0",
    "- options_doing_write_action_now_count: 0",
    "- options_missing_stop_line_language_count: 0",
    "- recommended_now_option: B",
    "",
    "## Parent review proof",
    "",
    "- review_report_v0_2_path: $ReviewReportPath",
    "- review_report_v0_2_sha256: $ReviewReportSha",
    "- review_rough_local_path: $ReviewRoughLedgerPath",
    "- review_rough_local_sha256: $ReviewRoughLedgerSha",
    "- review_git_import_packet_sha256: $ReviewGitImportPacketSha",
    "",
    "## Carried option facts",
    "",
    "- option_count: 5",
    "- recommended_now_option: B",
    "- recommended_now_label: BUILD_SCRIPT_CUSTODY_REVIEW_QUEUE",
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
    "Import only pointer truth for the V0_2 option set and stress bench into the nested Git repo.",
    "Do not import full local root evidence. Do not clean up. Do not move root-held files. Do not delete. Do not route. Do not execute root scripts. Do not rewrite source. Do not promote doctrine. Do not push.",
    "",
    "## Next selected action",
    "",
    "next_build_chunk_selected: $NextBuildChunk",
    "",
    "## DoesNotProve",
    "",
    "This rough_local import proves only that the V0_2 option set pointer ledger and receipt were imported into nested Git. It does not prove any option has been selected by the user, and it does not approve file movement, deletion, routing, script execution, source rewrite, doctrine promotion, push, or cleanup.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_OPTION_SET_V0_2_POINTER_LEDGER_READY"
)

$RoughLedgerLines | Set-Content -LiteralPath $LocalRoughLedgerPath -Encoding UTF8
$LocalRoughLedgerSha = Get-Sha256 -Path $LocalRoughLedgerPath

$RoughReceiptLines = @(
    "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "source_option_report_path: $OptionReportPath",
    "source_option_report_sha256: $OptionReportSha",
    "source_option_receipt_path: $OptionReceiptPath",
    "source_option_receipt_sha256: $OptionReceiptSha",
    "option_stress_bench_path: $OptionStressPath",
    "option_stress_bench_sha256: $OptionStressSha",
    "rough_local_ledger_path: $LocalRoughLedgerPath",
    "rough_local_ledger_sha256: $LocalRoughLedgerSha",
    "git_head_before_import: $($GitHeadBefore.Trim())",
    "git_status_before_import: CLEAN",
    "option_count: 5",
    "recommended_now_option: B",
    "recommended_now_label: BUILD_SCRIPT_CUSTODY_REVIEW_QUEUE",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "next_build_chunk_selected: $NextBuildChunk",
    "does_not_prove: user selected option; file safe to move; file safe to delete; file safe to route; script safe to execute; source safe to rewrite; doctrine safe to promote; push approved",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_OPTION_SET_V0_2_RECEIPT_READY"
)

$RoughReceiptLines | Set-Content -LiteralPath $LocalRoughReceiptPath -Encoding UTF8
$LocalRoughReceiptSha = Get-Sha256 -Path $LocalRoughReceiptPath

Copy-Item -LiteralPath $LocalRoughLedgerPath -Destination $GitRoughLedgerPath -Force
Copy-Item -LiteralPath $LocalRoughReceiptPath -Destination $GitRoughReceiptPath -Force

$ImportPacketLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP OPTION SET V0_2 GIT IMPORT PACKET RECEIPT 20260608",
    "",
    "Status: GIT_IMPORT_PACKET_RECEIPT / EXACT_STAGED_SET_REQUIRED / NO_PUSH / OPTION_SET",
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
    "## Option set source evidence",
    "",
    "- option_report_v0_2_path: $OptionReportPath",
    "- option_report_v0_2_sha256: $OptionReportSha",
    "- option_receipt_v0_2_path: $OptionReceiptPath",
    "- option_receipt_v0_2_sha256: $OptionReceiptSha",
    "- option_stress_bench_path: $OptionStressPath",
    "- option_stress_bench_sha256: $OptionStressSha",
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
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_OPTION_SET_V0_2_GIT_IMPORT_PACKET_RECEIPT_READY"
)

$ImportPacketLines | Set-Content -LiteralPath $GitImportPacketReceiptPath -Encoding UTF8
$ImportPacketSha = Get-Sha256 -Path $GitImportPacketReceiptPath

$ExpectedStageRel = @(
    $GitRoughLedgerRel,
    $GitRoughReceiptRel,
    $GitImportPacketReceiptRel
)

Write-Host "root-held option set hashes verified: YES"
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

& git -C $GitTop commit -m "Add root held group option set rough local ledger"
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
Write-Host "=== ROOT HELD GROUP OPTION SET V0_2 ROUGH_LOCAL IMPORT COMMITTED ==="
Write-Host "commit_hash: $CommitHash"
Write-Host "commit_message: Add root held group option set rough local ledger"
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

