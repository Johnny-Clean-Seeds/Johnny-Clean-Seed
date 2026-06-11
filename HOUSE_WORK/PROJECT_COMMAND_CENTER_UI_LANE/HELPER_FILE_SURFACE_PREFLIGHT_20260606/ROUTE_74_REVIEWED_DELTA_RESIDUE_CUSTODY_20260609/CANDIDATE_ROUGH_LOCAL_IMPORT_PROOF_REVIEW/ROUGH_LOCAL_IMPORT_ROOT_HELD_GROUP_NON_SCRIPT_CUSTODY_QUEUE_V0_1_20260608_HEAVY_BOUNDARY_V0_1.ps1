Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_ROUGH_LOCAL_IMPORT_20260608"
$FinalVerdict = "ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_QUEUE_V0_1_COMMITTED_TO_NESTED_REPO"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneRel = "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$LaneDir = Join-Path $Root $LaneRel
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "deb16fa806cf8dc7d57a28c8ee653c2f59e321ac"

$QueueReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$QueueReportSha = "561F28FABEDC9F75620B7BE44E35DB8E678C7BE116F8BF390EBB4712953676B9"

$QueueReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$QueueReceiptSha = "25D3B81B6BE7574EF0CB3479C4C82869749D5F9611AD19FB58D21EF3467B8BE4"

$QueueStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_STRESS_BENCH_20260608.md"
$QueueStressSha = "418E9A80E21A172CF51F1516ACB91A9E32BC21F5DAD44550DB718047FD1F9A2D"

$ScriptQueueRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$ScriptQueueRoughLedgerSha = "0D1A89C2AAF3DC3DAC8FD1EDCCEA4EF7266BD4C6512CD2A2DB0BC0B02F745747"

$ScriptQueueRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$ScriptQueueRoughReceiptSha = "902C22F6FF50E03E0A2276E94DCE328564296E5BBA7589429034B9D624D5FA50"

$ScriptQueueGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1\ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$ScriptQueueGitImportPacketSha = "B6912304C74A90349782A86CA5D04CEC4957181894084170B693DADAA0FEB659"

$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1"
$GitImportDir = Join-Path $GitTop ($GitImportRel -replace "/", "\")

$LocalRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$LocalRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"

$GitRoughLedgerRel = "$GitImportRel/ROUGH_LOCAL__ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$GitRoughReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$GitImportPacketReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

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

Write-Host "=== ROUGH_LOCAL IMPORT: ROOT HELD GROUP NON-SCRIPT CUSTODY QUEUE V0_1 ==="

$RequiredFiles = [ordered]@{
    QueueReport = [ordered]@{ Path = $QueueReportPath; Sha256 = $QueueReportSha }
    QueueReceipt = [ordered]@{ Path = $QueueReceiptPath; Sha256 = $QueueReceiptSha }
    QueueStress = [ordered]@{ Path = $QueueStressPath; Sha256 = $QueueStressSha }
    ScriptQueueRoughLedger = [ordered]@{ Path = $ScriptQueueRoughLedgerPath; Sha256 = $ScriptQueueRoughLedgerSha }
    ScriptQueueRoughReceipt = [ordered]@{ Path = $ScriptQueueRoughReceiptPath; Sha256 = $ScriptQueueRoughReceiptSha }
    ScriptQueueGitImportPacket = [ordered]@{ Path = $ScriptQueueGitImportPacketPath; Sha256 = $ScriptQueueGitImportPacketSha }
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

$QueueText = Get-Content -LiteralPath $QueueReportPath -Raw
$QueueReceiptText = Get-Content -LiteralPath $QueueReceiptPath -Raw
$QueueStressText = Get-Content -LiteralPath $QueueStressPath -Raw

$ReportSignals = @(
    "Status: NON_SCRIPT_CUSTODY_REVIEW_QUEUE / READ_ONLY / STRESS_BENCHED",
    "review_snapshot_non_script_count: 5",
    "current_root_non_script_count: 5",
    "non_scripts_seen_in_review_snapshot_count: 5",
    "post_review_non_script_count: 0",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "next_build_chunk_selected: ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_ROUGH_LOCAL_IMPORT_20260608",
    "after_import_next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608",
    "final_verdict: ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $ReportSignals) {
    if ($QueueText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "QUEUE_REPORT_SIGNAL_MISSING: $Signal"
    }
}

$ReceiptSignals = @(
    "review_snapshot_non_script_count: 5",
    "current_root_non_script_count: 5",
    "non_scripts_seen_in_review_snapshot_count: 5",
    "post_review_non_script_count: 0",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "blank_decision_row_count: 0",
    "delete_now_row_count: 0",
    "move_route_now_row_count: 0",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "git_commit_or_push_done: NO",
    "final_verdict: ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $ReceiptSignals) {
    if ($QueueReceiptText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "QUEUE_RECEIPT_SIGNAL_MISSING: $Signal"
    }
}

$StressSignals = @(
    "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_QUEUE_V0_1_STRESS_BENCH_PASS",
    "review_snapshot_non_script_count: 5",
    "current_root_non_script_count: 5",
    "post_review_non_script_count: 0",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "blank_decision_row_count: 0",
    "delete_now_row_count: 0",
    "move_route_now_row_count: 0"
)

foreach ($Signal in $StressSignals) {
    if ($QueueStressText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "QUEUE_STRESS_SIGNAL_MISSING: $Signal"
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
    Write-Host "final_verdict: ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_QUEUE_ROUGH_LOCAL_IMPORT_BLOCKED"
    exit 2
}

New-Item -ItemType Directory -Force -Path $GitImportDir | Out-Null

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$RoughLedgerLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP NON-SCRIPT CUSTODY QUEUE V0_1 20260608",
    "",
    "Status: ROUGH_LOCAL_POINTER_LEDGER / NON_SCRIPT_CUSTODY_QUEUE / STRESS_BENCH_CONFIRMED / GIT_IMPORT_PACKET / NOT_FULL_LOCAL_EVIDENCE / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE",
    "Created: $Now",
    "Active object: $ActiveObject",
    "",
    "## Source queue report",
    "",
    "- path: $QueueReportPath",
    "- sha256: $QueueReportSha",
    "",
    "## Source queue receipt",
    "",
    "- path: $QueueReceiptPath",
    "- sha256: $QueueReceiptSha",
    "",
    "## Source queue stress bench",
    "",
    "- path: $QueueStressPath",
    "- sha256: $QueueStressSha",
    "",
    "## Carried queue facts",
    "",
    "- review_snapshot_non_script_count: 5",
    "- current_root_non_script_count: 5",
    "- non_scripts_seen_in_review_snapshot_count: 5",
    "- post_review_non_script_count: 0",
    "- action_now_row_count: 0",
    "- bad_sha_row_count: 0",
    "- blank_decision_row_count: 0",
    "- delete_now_row_count: 0",
    "- move_route_now_row_count: 0",
    "- files_moved_count: 0",
    "- files_deleted_count: 0",
    "- files_renamed_count: 0",
    "- files_routed_count: 0",
    "- files_executed_count: 0",
    "- git_head_before_import: $($GitHeadBefore.Trim())",
    "- git_status_before_import: CLEAN",
    "",
    "## Parent script-queue proof",
    "",
    "- script_queue_rough_local_path: $ScriptQueueRoughLedgerPath",
    "- script_queue_rough_local_sha256: $ScriptQueueRoughLedgerSha",
    "- script_queue_git_import_packet_sha256: $ScriptQueueGitImportPacketSha",
    "",
    "## Import decision",
    "",
    "Import only pointer truth for the V0_1 non-script custody queue into nested Git.",
    "Do not import full local root evidence. Do not move, delete, route, execute, rewrite, promote, push, or clean up.",
    "",
    "## Next selected action",
    "",
    "next_build_chunk_selected: $NextBuildChunk",
    "",
    "## DoesNotProve",
    "",
    "This rough_local import proves only that the non-script custody queue pointer ledger and receipt were imported into nested Git. It does not approve file movement, deletion, routing, cleanup, source rewrite, doctrine promotion, or push.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_QUEUE_V0_1_POINTER_LEDGER_READY"
)

$RoughLedgerLines | Set-Content -LiteralPath $LocalRoughLedgerPath -Encoding UTF8
$LocalRoughLedgerSha = Get-Sha256 -Path $LocalRoughLedgerPath

$RoughReceiptLines = @(
    "ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_QUEUE_V0_1_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "source_queue_report_path: $QueueReportPath",
    "source_queue_report_sha256: $QueueReportSha",
    "source_queue_receipt_path: $QueueReceiptPath",
    "source_queue_receipt_sha256: $QueueReceiptSha",
    "source_queue_stress_path: $QueueStressPath",
    "source_queue_stress_sha256: $QueueStressSha",
    "rough_local_ledger_path: $LocalRoughLedgerPath",
    "rough_local_ledger_sha256: $LocalRoughLedgerSha",
    "git_head_before_import: $($GitHeadBefore.Trim())",
    "git_status_before_import: CLEAN",
    "review_snapshot_non_script_count: 5",
    "current_root_non_script_count: 5",
    "non_scripts_seen_in_review_snapshot_count: 5",
    "post_review_non_script_count: 0",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "blank_decision_row_count: 0",
    "delete_now_row_count: 0",
    "move_route_now_row_count: 0",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "next_build_chunk_selected: $NextBuildChunk",
    "does_not_prove: file safe to move; file safe to delete; file safe to route; source safe to rewrite; doctrine safe to promote; push approved",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_QUEUE_V0_1_RECEIPT_READY"
)

$RoughReceiptLines | Set-Content -LiteralPath $LocalRoughReceiptPath -Encoding UTF8
$LocalRoughReceiptSha = Get-Sha256 -Path $LocalRoughReceiptPath

Copy-Item -LiteralPath $LocalRoughLedgerPath -Destination $GitRoughLedgerPath -Force
Copy-Item -LiteralPath $LocalRoughReceiptPath -Destination $GitRoughReceiptPath -Force

$ImportPacketLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP NON-SCRIPT CUSTODY QUEUE V0_1 GIT IMPORT PACKET RECEIPT 20260608",
    "",
    "Status: GIT_IMPORT_PACKET_RECEIPT / EXACT_STAGED_SET_REQUIRED / NO_PUSH / NON_SCRIPT_CUSTODY_QUEUE",
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
    "## Queue source evidence",
    "",
    "- queue_report_path: $QueueReportPath",
    "- queue_report_sha256: $QueueReportSha",
    "- queue_receipt_path: $QueueReceiptPath",
    "- queue_receipt_sha256: $QueueReceiptSha",
    "- queue_stress_path: $QueueStressPath",
    "- queue_stress_sha256: $QueueStressSha",
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
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_QUEUE_V0_1_GIT_IMPORT_PACKET_RECEIPT_READY"
)

$ImportPacketLines | Set-Content -LiteralPath $GitImportPacketReceiptPath -Encoding UTF8
$ImportPacketSha = Get-Sha256 -Path $GitImportPacketReceiptPath

$ExpectedStageRel = @(
    $GitRoughLedgerRel,
    $GitRoughReceiptRel,
    $GitImportPacketReceiptRel
)

Write-Host "non-script custody queue hashes verified: YES"
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

& git -C $GitTop commit -m "Add root held group non-script custody queue rough local ledger"
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
Write-Host "=== ROOT HELD GROUP NON-SCRIPT CUSTODY QUEUE V0_1 ROUGH_LOCAL IMPORT COMMITTED ==="
Write-Host "commit_hash: $CommitHash"
Write-Host "commit_message: Add root held group non-script custody queue rough local ledger"
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
