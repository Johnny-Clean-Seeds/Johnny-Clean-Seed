Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_ROUGH_LOCAL_IMPORT_20260608"
$FinalVerdict = "ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_COMMITTED_TO_NESTED_REPO"
$NextBuildChunk = "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneRel = "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$LaneDir = Join-Path $Root $LaneRel
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"
$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT"
$GitImportDir = Join-Path $GitTop ($GitImportRel -replace "/", "\")

$ExpectedGitHead = "e877a6e4b242ef67ee25cef2cd4d756ce3af193d"

$LaneCloseoutCardPath = Join-Path $LaneDir "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
$LaneCloseoutCardSha = "BA9DABB8BF4CEA36A742C2F393FD4D3E9BD73D70C5A3EFE9273D43EAE956DD72"

$LaneCloseoutReceiptPath = Join-Path $LaneDir "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608.txt"
$LaneCloseoutReceiptSha = "3302308EE81F885700B3EF5CEA5807A76EE4E1A04BF6968ECB2BFC1B4296CE60"

$SelectorReportPath = Join-Path $LaneDir "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608.md"
$SelectorReportSha = "81ECA10E1284CCA033D475965AC4209C864827651C75A88585B90FA754622BC3"

$SelectorReceiptPath = Join-Path $LaneDir "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_RECEIPT_20260608.txt"
$SelectorReceiptSha = "771333660B99960485C102C7972E46EDA80F91A12388F0FB4A24EBB21C2468F9"

$QueueCloseoutRoughLocalPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.md"
$QueueCloseoutRoughLocalSha = "338DBFE97ECCA89DE9CB20D1AD8103DE84456CC88D44ED7E62ECC79A3E547AB1"

$LocalRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
$LocalRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608.txt"

$GitRoughLedgerRel = "$GitImportRel/ROUGH_LOCAL__HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
$GitRoughReceiptRel = "$GitImportRel/ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608.txt"
$GitImportPacketReceiptRel = "$GitImportRel/ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

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

Write-Host "=== ROUGH_LOCAL IMPORT: HELPER FILE SURFACE PREFLIGHT LANE CLOSEOUT ==="

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
    LaneCloseoutCard = [ordered]@{ Path = $LaneCloseoutCardPath; Sha256 = $LaneCloseoutCardSha }
    LaneCloseoutReceipt = [ordered]@{ Path = $LaneCloseoutReceiptPath; Sha256 = $LaneCloseoutReceiptSha }
    SelectorReport = [ordered]@{ Path = $SelectorReportPath; Sha256 = $SelectorReportSha }
    SelectorReceipt = [ordered]@{ Path = $SelectorReceiptPath; Sha256 = $SelectorReceiptSha }
    QueueCloseoutRoughLocal = [ordered]@{ Path = $QueueCloseoutRoughLocalPath; Sha256 = $QueueCloseoutRoughLocalSha }
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

$CardText = ""
if (Test-Path -LiteralPath $LaneCloseoutCardPath -PathType Leaf) {
    $CardText = Get-Content -LiteralPath $LaneCloseoutCardPath -Raw
}

$RequiredCardSignals = @(
    "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_READY_WITH_SCOPE_LIMIT_NOTE",
    "next_build_chunk_selected: HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_ROUGH_LOCAL_IMPORT_20260608",
    "queue items accounted: 12",
    "queue items unaccounted: 0",
    "git_status_confirmed: CLEAN",
    "git_commit_or_push_done_by_this_card: NO"
)

foreach ($Signal in $RequiredCardSignals) {
    if ($CardText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "LANE_CLOSEOUT_SIGNAL_MISSING: $Signal"
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
    Write-Host "final_verdict: HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_ROUGH_LOCAL_IMPORT_BLOCKED"
    exit 2
}

New-Item -ItemType Directory -Force -Path $GitImportDir | Out-Null

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$RoughLedgerLines = @(
    "# ROUGH_LOCAL HELPER FILE SURFACE PREFLIGHT LANE CLOSEOUT CARD 20260608",
    "",
    "Status: ROUGH_LOCAL_POINTER_LEDGER / GIT_IMPORT_PACKET / NOT_FULL_LOCAL_EVIDENCE / NOT_CLEANUP_ORDER / NOT_DOCTRINE",
    "Created: $Now",
    "Active object: $ActiveObject",
    "",
    "## Source local closeout card",
    "",
    "- path: $LaneCloseoutCardPath",
    "- sha256: $LaneCloseoutCardSha",
    "",
    "## Source local receipt",
    "",
    "- path: $LaneCloseoutReceiptPath",
    "- sha256: $LaneCloseoutReceiptSha",
    "",
    "## Parent selector proof",
    "",
    "- selector report path: $SelectorReportPath",
    "- selector report sha256: $SelectorReportSha",
    "- selector receipt path: $SelectorReceiptPath",
    "- selector receipt sha256: $SelectorReceiptSha",
    "",
    "## Parent washer rough_local proof",
    "",
    "- queue closeout rough_local path: $QueueCloseoutRoughLocalPath",
    "- queue closeout rough_local sha256: $QueueCloseoutRoughLocalSha",
    "",
    "## Carried closeout facts",
    "",
    "- queue_items_accounted: 12",
    "- queue_items_unaccounted: 0",
    "- files_moved_count: 0",
    "- files_deleted_count: 0",
    "- files_renamed_count: 0",
    "- files_overwritten_count: 0",
    "- git_head_before_import: $($GitHeadBefore.Trim())",
    "- git_status_before_import: CLEAN",
    "",
    "## Import decision",
    "",
    "Import only pointer truth for the helper-file surface preflight lane closeout card into the nested Git repo.",
    "Do not import full local evidence. Do not run cleanup. Do not execute helper candidates. Do not rewrite source. Do not promote doctrine. Do not push.",
    "",
    "## Next selected action",
    "",
    "next_build_chunk_selected: $NextBuildChunk",
    "",
    "## DoesNotProve",
    "",
    "This rough_local import proves only that the lane closeout pointer ledger and receipt were imported into nested Git. It does not prove the whole project is clean, public-safe, ready for cleanup, ready for source replay, ready for helper execution, ready for doctrine promotion, or ready for push.",
    "",
    "final_verdict: ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_POINTER_LEDGER_READY"
)

$RoughLedgerLines | Set-Content -LiteralPath $LocalRoughLedgerPath -Encoding UTF8
$LocalRoughLedgerSha = Get-Sha256 -Path $LocalRoughLedgerPath

$RoughReceiptLines = @(
    "ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "source_lane_closeout_card_path: $LaneCloseoutCardPath",
    "source_lane_closeout_card_sha256: $LaneCloseoutCardSha",
    "source_lane_closeout_receipt_path: $LaneCloseoutReceiptPath",
    "source_lane_closeout_receipt_sha256: $LaneCloseoutReceiptSha",
    "rough_local_ledger_path: $LocalRoughLedgerPath",
    "rough_local_ledger_sha256: $LocalRoughLedgerSha",
    "git_head_before_import: $($GitHeadBefore.Trim())",
    "git_status_before_import: CLEAN",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_overwritten_count: 0",
    "next_build_chunk_selected: $NextBuildChunk",
    "does_not_prove: project complete; cleanup approved; source replay approved; helper execution approved; doctrine promotion approved; push approved",
    "final_verdict: ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_RECEIPT_READY"
)

$RoughReceiptLines | Set-Content -LiteralPath $LocalRoughReceiptPath -Encoding UTF8
$LocalRoughReceiptSha = Get-Sha256 -Path $LocalRoughReceiptPath

Copy-Item -LiteralPath $LocalRoughLedgerPath -Destination $GitRoughLedgerPath -Force
Copy-Item -LiteralPath $LocalRoughReceiptPath -Destination $GitRoughReceiptPath -Force

$ImportPacketLines = @(
    "# ROUGH_LOCAL HELPER FILE SURFACE PREFLIGHT LANE CLOSEOUT GIT IMPORT PACKET RECEIPT 20260608",
    "",
    "Status: GIT_IMPORT_PACKET_RECEIPT / EXACT_STAGED_SET_REQUIRED / NO_PUSH",
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
    "This import stages and commits exactly three files. It does not push. It does not cleanup. It does not move root-held files. It does not execute helper scripts. It does not promote doctrine.",
    "",
    "final_verdict: ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_GIT_IMPORT_PACKET_RECEIPT_READY"
)

$ImportPacketLines | Set-Content -LiteralPath $GitImportPacketReceiptPath -Encoding UTF8
$ImportPacketSha = Get-Sha256 -Path $GitImportPacketReceiptPath

$ExpectedStageRel = @(
    $GitRoughLedgerRel,
    $GitRoughReceiptRel,
    $GitImportPacketReceiptRel
)

Write-Host "local lane closeout hashes verified: YES"
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

& git -C $GitTop commit -m "Add helper file surface preflight lane closeout rough local ledger"
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
Write-Host "=== HELPER FILE SURFACE PREFLIGHT LANE CLOSEOUT ROUGH_LOCAL IMPORT COMMITTED ==="
Write-Host "commit_hash: $CommitHash"
Write-Host "commit_message: Add helper file surface preflight lane closeout rough local ledger"
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
