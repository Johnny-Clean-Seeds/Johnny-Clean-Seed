Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_ROUGH_LOCAL_IMPORT_20260608"
$FinalVerdict = "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_COMMITTED_TO_NESTED_REPO"
$NextBuildChunk = "USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneRel = "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$LaneDir = Join-Path $Root $LaneRel
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "a713660d17f481cbb59a4309d4fae5d6a03c84ef"

$RoutePlanReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md"
$RoutePlanReportSha = "FBDA72FCC368B608EE2802B7FDC9941A451446E7E7A8AD1D9D69C7FA137405E0"

$RoutePlanReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_RECEIPT_20260608.txt"
$RoutePlanReceiptSha = "9BF504598C1352D7E06BC6F836116FCDA85A9E90681B46FCFED91A0DB1352C08"

$RoutePlanStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_STRESS_BENCH_20260608.md"
$RoutePlanStressSha = "708238059F594CCAD99C93D2CC8B21285851E7EAEA4A58E663DFCD2DB0A8E4BD"

$NonScriptQueueRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$NonScriptQueueRoughLedgerSha = "9F1F7FCE144848D3A5619C23D4685DC77AC03EC95630264D56B0B2206E332D70"

$NonScriptQueueRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$NonScriptQueueRoughReceiptSha = "2B0621AAE1B2A9B9846251C14A7C915D49CF66373CF88DAADCCE1F2945E468C9"

$NonScriptQueueGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1\ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$NonScriptQueueGitImportPacketSha = "1CE8471CA8EBE19C9D69B1566903855D8937ACB82DA0339B8DF1C517CCA03061"

$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1"
$GitImportDir = Join-Path $GitTop ($GitImportRel -replace "/", "\")

$LocalRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md"
$LocalRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_RECEIPT_20260608.txt"

$GitRoughLedgerRel = "$GitImportRel/ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md"
$GitRoughReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_RECEIPT_20260608.txt"
$GitImportPacketReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

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

Write-Host "=== ROUGH_LOCAL IMPORT: ROOT HELD GROUP ROUTE PLAN ONLY V0_1 ==="

$RequiredFiles = [ordered]@{
    RoutePlanReport = [ordered]@{ Path = $RoutePlanReportPath; Sha256 = $RoutePlanReportSha }
    RoutePlanReceipt = [ordered]@{ Path = $RoutePlanReceiptPath; Sha256 = $RoutePlanReceiptSha }
    RoutePlanStress = [ordered]@{ Path = $RoutePlanStressPath; Sha256 = $RoutePlanStressSha }
    NonScriptQueueRoughLedger = [ordered]@{ Path = $NonScriptQueueRoughLedgerPath; Sha256 = $NonScriptQueueRoughLedgerSha }
    NonScriptQueueRoughReceipt = [ordered]@{ Path = $NonScriptQueueRoughReceiptPath; Sha256 = $NonScriptQueueRoughReceiptSha }
    NonScriptQueueGitImportPacket = [ordered]@{ Path = $NonScriptQueueGitImportPacketPath; Sha256 = $NonScriptQueueGitImportPacketSha }
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

$RoutePlanText = Get-Content -LiteralPath $RoutePlanReportPath -Raw
$RoutePlanReceiptText = Get-Content -LiteralPath $RoutePlanReceiptPath -Raw
$RoutePlanStressText = Get-Content -LiteralPath $RoutePlanStressPath -Raw

$ReportSignals = @(
    "Status: ROUTE_PLAN_ONLY / READ_ONLY / STRESS_BENCHED",
    "route_plan_scope: LOCKED_CUSTODY_QUEUES_ONLY",
    "live_root_delta_check_required_before_any_future_route: YES",
    "script_plan_row_count: 53",
    "non_script_plan_row_count: 5",
    "total_plan_row_count: 58",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "blank_bucket_row_count: 0",
    "delete_now_row_count: 0",
    "move_route_now_row_count: 0",
    "current_runner_route_plan_row_count: 1",
    "leave_in_place_row_count: 1",
    "dry_run_required_row_count: 56",
    "next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_ROUGH_LOCAL_IMPORT_20260608",
    "after_import_next_build_chunk_selected: USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $ReportSignals) {
    if ($RoutePlanText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "ROUTE_PLAN_REPORT_SIGNAL_MISSING: $Signal"
    }
}

$ReceiptSignals = @(
    "route_plan_scope: LOCKED_CUSTODY_QUEUES_ONLY",
    "live_root_delta_check_required_before_any_future_route: YES",
    "script_plan_row_count: 53",
    "non_script_plan_row_count: 5",
    "total_plan_row_count: 58",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "blank_bucket_row_count: 0",
    "delete_now_row_count: 0",
    "move_route_now_row_count: 0",
    "current_runner_route_plan_row_count: 1",
    "leave_in_place_row_count: 1",
    "dry_run_required_row_count: 56",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "git_commit_or_push_done: NO",
    "final_verdict: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $ReceiptSignals) {
    if ($RoutePlanReceiptText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "ROUTE_PLAN_RECEIPT_SIGNAL_MISSING: $Signal"
    }
}

$StressSignals = @(
    "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_STRESS_BENCH_PASS",
    "script_plan_row_count: 53",
    "non_script_plan_row_count: 5",
    "total_plan_row_count: 58",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "blank_bucket_row_count: 0",
    "delete_now_row_count: 0",
    "move_route_now_row_count: 0",
    "current_runner_route_plan_row_count: 1",
    "leave_in_place_row_count: 1",
    "dry_run_required_row_count: 56"
)

foreach ($Signal in $StressSignals) {
    if ($RoutePlanStressText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "ROUTE_PLAN_STRESS_SIGNAL_MISSING: $Signal"
    }
}

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

foreach ($OutputPath in @($LocalRoughLedgerPath, $LocalRoughReceiptPath, $GitRoughLedgerPath, $GitRoughReceiptPath, $GitImportPacketReceiptPath)) {
    if (Test-Path -LiteralPath $OutputPath -PathType Leaf) {
        Add-Blocker "OUTPUT_ALREADY_EXISTS_NO_OVERWRITE: $OutputPath"
    }
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND BEFORE WRITE ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_ROUGH_LOCAL_IMPORT_BLOCKED"
    exit 2
}

New-Item -ItemType Directory -Force -Path $GitImportDir | Out-Null

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$RoughLedgerLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP ROUTE PLAN ONLY V0_1 20260608",
    "",
    "Status: ROUGH_LOCAL_POINTER_LEDGER / ROUTE_PLAN_ONLY / STRESS_BENCH_CONFIRMED / GIT_IMPORT_PACKET / NOT_FULL_LOCAL_EVIDENCE / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE",
    "Created: $Now",
    "Active object: $ActiveObject",
    "",
    "## Source route plan report",
    "",
    "- path: $RoutePlanReportPath",
    "- sha256: $RoutePlanReportSha",
    "",
    "## Source route plan receipt",
    "",
    "- path: $RoutePlanReceiptPath",
    "- sha256: $RoutePlanReceiptSha",
    "",
    "## Source route plan stress bench",
    "",
    "- path: $RoutePlanStressPath",
    "- sha256: $RoutePlanStressSha",
    "",
    "## Carried route-plan facts",
    "",
    "- route_plan_scope: LOCKED_CUSTODY_QUEUES_ONLY",
    "- live_root_delta_check_required_before_any_future_route: YES",
    "- script_plan_row_count: 53",
    "- non_script_plan_row_count: 5",
    "- total_plan_row_count: 58",
    "- action_now_row_count: 0",
    "- bad_sha_row_count: 0",
    "- blank_bucket_row_count: 0",
    "- delete_now_row_count: 0",
    "- move_route_now_row_count: 0",
    "- current_runner_route_plan_row_count: 1",
    "- leave_in_place_row_count: 1",
    "- dry_run_required_row_count: 56",
    "- files_moved_count: 0",
    "- files_deleted_count: 0",
    "- files_renamed_count: 0",
    "- files_routed_count: 0",
    "- files_executed_count: 0",
    "- git_head_before_import: $($GitHeadBefore.Trim())",
    "- git_status_before_import: CLEAN",
    "",
    "## Parent non-script queue proof",
    "",
    "- non_script_queue_rough_local_path: $NonScriptQueueRoughLedgerPath",
    "- non_script_queue_rough_local_sha256: $NonScriptQueueRoughLedgerSha",
    "- non_script_queue_git_import_packet_sha256: $NonScriptQueueGitImportPacketSha",
    "",
    "## Import decision",
    "",
    "Import only pointer truth for the V0_1 route-plan-only card into nested Git.",
    "Do not import full local root evidence. Do not move, delete, route, execute, rewrite, promote, push, or clean up.",
    "",
    "## Next selected action",
    "",
    "next_build_chunk_selected: $NextBuildChunk",
    "",
    "## DoesNotProve",
    "",
    "This rough_local import proves only that the route-plan-only pointer ledger and receipt were imported into nested Git. It does not approve file movement, deletion, routing, cleanup, execution, source rewrite, doctrine promotion, or push.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_POINTER_LEDGER_READY"
)

$RoughLedgerLines | Set-Content -LiteralPath $LocalRoughLedgerPath -Encoding UTF8
$LocalRoughLedgerSha = Get-Sha256 -Path $LocalRoughLedgerPath

$RoughReceiptLines = @(
    "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "source_route_plan_report_path: $RoutePlanReportPath",
    "source_route_plan_report_sha256: $RoutePlanReportSha",
    "source_route_plan_receipt_path: $RoutePlanReceiptPath",
    "source_route_plan_receipt_sha256: $RoutePlanReceiptSha",
    "source_route_plan_stress_path: $RoutePlanStressPath",
    "source_route_plan_stress_sha256: $RoutePlanStressSha",
    "rough_local_ledger_path: $LocalRoughLedgerPath",
    "rough_local_ledger_sha256: $LocalRoughLedgerSha",
    "git_head_before_import: $($GitHeadBefore.Trim())",
    "git_status_before_import: CLEAN",
    "route_plan_scope: LOCKED_CUSTODY_QUEUES_ONLY",
    "live_root_delta_check_required_before_any_future_route: YES",
    "script_plan_row_count: 53",
    "non_script_plan_row_count: 5",
    "total_plan_row_count: 58",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "blank_bucket_row_count: 0",
    "delete_now_row_count: 0",
    "move_route_now_row_count: 0",
    "current_runner_route_plan_row_count: 1",
    "leave_in_place_row_count: 1",
    "dry_run_required_row_count: 56",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "next_build_chunk_selected: $NextBuildChunk",
    "does_not_prove: live root has no new files; file safe to move; file safe to delete; file safe to route; source safe to rewrite; doctrine safe to promote; push approved",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_RECEIPT_READY"
)

$RoughReceiptLines | Set-Content -LiteralPath $LocalRoughReceiptPath -Encoding UTF8
$LocalRoughReceiptSha = Get-Sha256 -Path $LocalRoughReceiptPath

Copy-Item -LiteralPath $LocalRoughLedgerPath -Destination $GitRoughLedgerPath -Force
Copy-Item -LiteralPath $LocalRoughReceiptPath -Destination $GitRoughReceiptPath -Force

$ImportPacketLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP ROUTE PLAN ONLY V0_1 GIT IMPORT PACKET RECEIPT 20260608",
    "",
    "Status: GIT_IMPORT_PACKET_RECEIPT / EXACT_STAGED_SET_REQUIRED / NO_PUSH / ROUTE_PLAN_ONLY",
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
    "## Route plan source evidence",
    "",
    "- route_plan_report_path: $RoutePlanReportPath",
    "- route_plan_report_sha256: $RoutePlanReportSha",
    "- route_plan_receipt_path: $RoutePlanReceiptPath",
    "- route_plan_receipt_sha256: $RoutePlanReceiptSha",
    "- route_plan_stress_path: $RoutePlanStressPath",
    "- route_plan_stress_sha256: $RoutePlanStressSha",
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
    "This import stages and commits exactly three files. It does not push. It does not move, delete, route, execute, clean up, rewrite source, or promote doctrine.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_GIT_IMPORT_PACKET_RECEIPT_READY"
)

$ImportPacketLines | Set-Content -LiteralPath $GitImportPacketReceiptPath -Encoding UTF8
$ImportPacketSha = Get-Sha256 -Path $GitImportPacketReceiptPath

$ExpectedStageRel = @(
    $GitRoughLedgerRel,
    $GitRoughReceiptRel,
    $GitImportPacketReceiptRel
)

Write-Host "route plan hashes verified: YES"
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
$ExpectedSorted = $ExpectedStageRel | Sort-Object
$StagedSorted = $Staged | Sort-Object

if ((($ExpectedSorted -join "`n").Trim()) -ne (($StagedSorted -join "`n").Trim())) {
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

& git -C $GitTop commit -m "Add root held group route plan rough local ledger"
if ($LASTEXITCODE -ne 0) {
    Write-Host "final_verdict: GIT_COMMIT_FAILED"
    exit 2
}

$CommitHash = (& git -C $GitTop rev-parse HEAD).Trim()
$PostStatus = (& git -C $GitTop status --short)

if (($PostStatus | Out-String).Trim().Length -ne 0) {
    Write-Host "=== POST COMMIT STATUS NOT CLEAN ==="
    $PostStatus | ForEach-Object { Write-Host $_ }
    Write-Host "final_verdict: POST_COMMIT_STATUS_NOT_CLEAN"
    exit 2
}

Write-Host ""
Write-Host "=== ROOT HELD GROUP ROUTE PLAN ONLY V0_1 ROUGH_LOCAL IMPORT COMMITTED ==="
Write-Host "commit_hash: $CommitHash"
Write-Host "commit_message: Add root held group route plan rough local ledger"
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
