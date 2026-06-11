Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_ROUGH_LOCAL_IMPORT_20260608"
$FinalVerdict = "ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_COMMITTED_TO_NESTED_REPO"
$NextBuildChunk = "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneRel = "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$LaneDir = Join-Path $Root $LaneRel
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "ecb70637776aff6001356c305089509ea5281ad1"

$QueueReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$QueueReportSha = "7852B77BA614A172B328AC2B422E0EF0D4443D4F0FDE0A84F75A218E0206EB2B"

$QueueReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$QueueReceiptSha = "6EA3AB7A96C4613B698A4542049378D1D604C40EA7E356C00D1B1025FCF70947"

$QueueStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_STRESS_BENCH_20260608.md"
$QueueStressSha = "2CB8467E1373490461583E4560819E9CE1201505661F6E01EBCA4374CDD8B818"

$OptionRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_20260608.md"
$OptionRoughLedgerSha = "61F2F5892616CB334F7B9B7B7991B5998EDDFE66865731D4E656A92431A01C61"

$OptionRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_RECEIPT_20260608.txt"
$OptionRoughReceiptSha = "DAC82432BFD9716713438D1E4601FB20FFBE4D8021B8C6191C2940B283B26BFF"

$OptionGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2\ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_OPTION_SET_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$OptionGitImportPacketSha = "B263EAE0A5051F07024B7FC5AD3EB2399AEC7E60252925077DBE2A03CEAE39B8"

$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1"
$GitImportDir = Join-Path $GitTop ($GitImportRel -replace "/", "\")

$LocalRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$LocalRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"

$GitRoughLedgerRel = "$GitImportRel/ROUGH_LOCAL__ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$GitRoughReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$GitImportPacketReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

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

Write-Host "=== ROUGH_LOCAL IMPORT: ROOT HELD GROUP SCRIPT CUSTODY QUEUE V0_1 ==="

$RequiredFiles = [ordered]@{
    QueueReport = [ordered]@{ Path = $QueueReportPath; Sha256 = $QueueReportSha }
    QueueReceipt = [ordered]@{ Path = $QueueReceiptPath; Sha256 = $QueueReceiptSha }
    QueueStress = [ordered]@{ Path = $QueueStressPath; Sha256 = $QueueStressSha }
    OptionRoughLedger = [ordered]@{ Path = $OptionRoughLedgerPath; Sha256 = $OptionRoughLedgerSha }
    OptionRoughReceipt = [ordered]@{ Path = $OptionRoughReceiptPath; Sha256 = $OptionRoughReceiptSha }
    OptionGitImportPacket = [ordered]@{ Path = $OptionGitImportPacketPath; Sha256 = $OptionGitImportPacketSha }
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
    "Status: SCRIPT_CUSTODY_REVIEW_QUEUE / USER_APPROVED_OPTION_B / READ_ONLY / STRESS_BENCHED",
    "review_snapshot_script_count: 42",
    "current_root_script_count: 53",
    "scripts_seen_in_review_snapshot_count: 42",
    "post_review_root_script_count: 11",
    "current_runner_count: 1",
    "action_now_row_count: 0",
    "execute_now_decision_count: 0",
    "move_delete_route_decision_count: 0",
    "next_build_chunk_selected: ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_ROUGH_LOCAL_IMPORT_20260608",
    "after_import_next_build_chunk_selected: ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608",
    "final_verdict: ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $ReportSignals) {
    if ($QueueText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "QUEUE_REPORT_SIGNAL_MISSING: $Signal"
    }
}

$ReceiptSignals = @(
    "review_snapshot_script_count: 42",
    "current_root_script_count: 53",
    "scripts_seen_in_review_snapshot_count: 42",
    "post_review_root_script_count: 11",
    "current_runner_count: 1",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "execute_now_decision_count: 0",
    "move_delete_route_decision_count: 0",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "git_commit_or_push_done: NO",
    "final_verdict: ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_READY_WITH_STRESS_BENCH_PASS"
)

foreach ($Signal in $ReceiptSignals) {
    if ($QueueReceiptText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "QUEUE_RECEIPT_SIGNAL_MISSING: $Signal"
    }
}

$StressSignals = @(
    "ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_STRESS_BENCH_PASS",
    "review_snapshot_script_count: 42",
    "current_root_script_count: 53",
    "scripts_seen_in_review_snapshot_count: 42",
    "post_review_root_script_count: 11",
    "current_runner_count: 1",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "execute_now_decision_count: 0",
    "move_delete_route_decision_count: 0",
    "blank_decision_row_count: 0"
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
    Write-Host "final_verdict: ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_ROUGH_LOCAL_IMPORT_BLOCKED"
    exit 2
}

New-Item -ItemType Directory -Force -Path $GitImportDir | Out-Null

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$RoughLedgerLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP SCRIPT CUSTODY QUEUE V0_1 20260608",
    "",
    "Status: ROUGH_LOCAL_POINTER_LEDGER / SCRIPT_CUSTODY_QUEUE / USER_APPROVED_OPTION_B / STRESS_BENCH_CONFIRMED / GIT_IMPORT_PACKET / NOT_FULL_LOCAL_EVIDENCE / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE",
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
    "- review_snapshot_script_count: 42",
    "- current_root_script_count: 53",
    "- scripts_seen_in_review_snapshot_count: 42",
    "- post_review_root_script_count: 11",
    "- current_runner_count: 1",
    "- action_now_row_count: 0",
    "- bad_sha_row_count: 0",
    "- execute_now_decision_count: 0",
    "- move_delete_route_decision_count: 0",
    "- files_moved_count: 0",
    "- files_deleted_count: 0",
    "- files_renamed_count: 0",
    "- files_routed_count: 0",
    "- files_executed_count: 0",
    "- git_head_before_import: $($GitHeadBefore.Trim())",
    "- git_status_before_import: CLEAN",
    "",
    "## Parent option-set proof",
    "",
    "- option_rough_local_path: $OptionRoughLedgerPath",
    "- option_rough_local_sha256: $OptionRoughLedgerSha",
    "- option_git_import_packet_sha256: $OptionGitImportPacketSha",
    "",
    "## Import decision",
    "",
    "Import only pointer truth for the V0_1 script custody queue into nested Git.",
    "Do not import full local root evidence. Do not move, delete, route, execute, rewrite, promote, push, or clean up.",
    "",
    "## Next selected action",
    "",
    "next_build_chunk_selected: $NextBuildChunk",
    "",
    "## DoesNotProve",
    "",
    "This rough_local import proves only that the script custody queue pointer ledger and receipt were imported into nested Git. It does not approve script execution, movement, deletion, routing, cleanup, source rewrite, doctrine promotion, or push.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_POINTER_LEDGER_READY"
)

$RoughLedgerLines | Set-Content -LiteralPath $LocalRoughLedgerPath -Encoding UTF8
$LocalRoughLedgerSha = Get-Sha256 -Path $LocalRoughLedgerPath

$RoughReceiptLines = @(
    "ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_RECEIPT_20260608",
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
    "review_snapshot_script_count: 42",
    "current_root_script_count: 53",
    "scripts_seen_in_review_snapshot_count: 42",
    "post_review_root_script_count: 11",
    "current_runner_count: 1",
    "action_now_row_count: 0",
    "bad_sha_row_count: 0",
    "execute_now_decision_count: 0",
    "move_delete_route_decision_count: 0",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "next_build_chunk_selected: $NextBuildChunk",
    "does_not_prove: script safe to execute; script safe to move; script safe to delete; script safe to route; source safe to rewrite; doctrine safe to promote; push approved",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_RECEIPT_READY"
)

$RoughReceiptLines | Set-Content -LiteralPath $LocalRoughReceiptPath -Encoding UTF8
$LocalRoughReceiptSha = Get-Sha256 -Path $LocalRoughReceiptPath

Copy-Item -LiteralPath $LocalRoughLedgerPath -Destination $GitRoughLedgerPath -Force
Copy-Item -LiteralPath $LocalRoughReceiptPath -Destination $GitRoughReceiptPath -Force

$ImportPacketLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP SCRIPT CUSTODY QUEUE V0_1 GIT IMPORT PACKET RECEIPT 20260608",
    "",
    "Status: GIT_IMPORT_PACKET_RECEIPT / EXACT_STAGED_SET_REQUIRED / NO_PUSH / SCRIPT_CUSTODY_QUEUE",
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
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_QUEUE_V0_1_GIT_IMPORT_PACKET_RECEIPT_READY"
)

$ImportPacketLines | Set-Content -LiteralPath $GitImportPacketReceiptPath -Encoding UTF8
$ImportPacketSha = Get-Sha256 -Path $GitImportPacketReceiptPath

$ExpectedStageRel = @(
    $GitRoughLedgerRel,
    $GitRoughReceiptRel,
    $GitImportPacketReceiptRel
)

Write-Host "script custody queue hashes verified: YES"
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

& git -C $GitTop commit -m "Add root held group script custody queue rough local ledger"
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
Write-Host "=== ROOT HELD GROUP SCRIPT CUSTODY QUEUE V0_1 ROUGH_LOCAL IMPORT COMMITTED ==="
Write-Host "commit_hash: $CommitHash"
Write-Host "commit_message: Add root held group script custody queue rough local ledger"
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
