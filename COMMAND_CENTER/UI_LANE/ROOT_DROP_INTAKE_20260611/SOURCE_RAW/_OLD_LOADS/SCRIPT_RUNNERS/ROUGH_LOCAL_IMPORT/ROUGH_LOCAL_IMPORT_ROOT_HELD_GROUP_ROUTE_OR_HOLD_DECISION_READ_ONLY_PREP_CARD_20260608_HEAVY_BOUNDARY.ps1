Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_ROUGH_LOCAL_IMPORT_20260608"
$FinalVerdict = "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_COMMITTED_TO_NESTED_REPO"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneRel = "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$LaneDir = Join-Path $Root $LaneRel
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD"
$GitImportDir = Join-Path $GitTop ($GitImportRel -replace "/", "\")

$ExpectedGitHead = "521d4dd79b022592b143e08696138c7cf7611898"

$PrepCardPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md"
$PrepCardSha = "83967BAB53B170BAD53AEAC21BE042B6129B7C13B9934AC110D729011E1B6F8E"

$PrepReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt"
$PrepReceiptSha = "73AA76F428746BC7C6971F928AF580FEC9AA590627141261B52A66419C4F6AE7"

$NextObjectSelectorPath = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608.md"
$NextObjectSelectorSha = "15431564C9AC544972669D29641031B04425077CA6848C4CD73432EBFDCF942A"

$NextObjectSelectorReceiptPath = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_RECEIPT_20260608.txt"
$NextObjectSelectorReceiptSha = "ACB984B6CCEDC16B8DB1EFC98F7B94FC0BAB61629A9218A6173A566AE513017F"

$LaneCloseoutRoughLocalPath = Join-Path $LaneDir "ROUGH_LOCAL__HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
$LaneCloseoutRoughLocalSha = "38505DAE4DD4292CDBFA8441E78952F57D06BF94B7B4B09BCE2F4F0E37D1FF2F"

$LocalRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md"
$LocalRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt"

$GitRoughLedgerRel = "$GitImportRel/ROUGH_LOCAL__ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608.md"
$GitRoughReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608.txt"
$GitImportPacketReceiptRel = "$GitImportRel/ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

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

Write-Host "=== ROUGH_LOCAL IMPORT: ROOT HELD GROUP READ ONLY PREP CARD ==="

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
    PrepCard = [ordered]@{ Path = $PrepCardPath; Sha256 = $PrepCardSha }
    PrepReceipt = [ordered]@{ Path = $PrepReceiptPath; Sha256 = $PrepReceiptSha }
    NextObjectSelector = [ordered]@{ Path = $NextObjectSelectorPath; Sha256 = $NextObjectSelectorSha }
    NextObjectSelectorReceipt = [ordered]@{ Path = $NextObjectSelectorReceiptPath; Sha256 = $NextObjectSelectorReceiptSha }
    LaneCloseoutRoughLocal = [ordered]@{ Path = $LaneCloseoutRoughLocalPath; Sha256 = $LaneCloseoutRoughLocalSha }
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

$PrepText = ""
if (Test-Path -LiteralPath $PrepCardPath -PathType Leaf) {
    $PrepText = Get-Content -LiteralPath $PrepCardPath -Raw
}

$RequiredPrepSignals = @(
    "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_READY_WITH_SCOPE_LIMIT_NOTE",
    "next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_ROUGH_LOCAL_IMPORT_20260608",
    "after_import_next_build_chunk_selected: ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_20260608",
    "observed_root_top_level_file_count: 42",
    "held_decision_candidate_count: 40",
    "root_level_script_held_not_execute_count: 36",
    "desktop_ini_leave_in_place_count: 1",
    "zero_byte_review_only_no_delete_count: 1",
    "known_source_authority_object_review_only_count: 1",
    "current_runner_script_excluded_count: 1",
    "The next review must not move, delete, rename, route, execute, rewrite, commit, push, or promote anything.",
    "no cleanup",
    "no delete",
    "no rename",
    "no move",
    "no routing yet",
    "no helper execution",
    "no source replay",
    "no source rewrite",
    "no doctrine promotion"
)

foreach ($Signal in $RequiredPrepSignals) {
    if ($PrepText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "PREP_CARD_SIGNAL_MISSING: $Signal"
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
    Write-Host "final_verdict: ROOT_HELD_GROUP_READ_ONLY_PREP_CARD_ROUGH_LOCAL_IMPORT_BLOCKED"
    exit 2
}

New-Item -ItemType Directory -Force -Path $GitImportDir | Out-Null

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$RoughLedgerLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP ROUTE OR HOLD DECISION READ ONLY PREP CARD 20260608",
    "",
    "Status: ROUGH_LOCAL_POINTER_LEDGER / GIT_IMPORT_PACKET / NOT_FULL_LOCAL_EVIDENCE / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE",
    "Created: $Now",
    "Active object: $ActiveObject",
    "",
    "## Source local prep card",
    "",
    "- path: $PrepCardPath",
    "- sha256: $PrepCardSha",
    "",
    "## Source local receipt",
    "",
    "- path: $PrepReceiptPath",
    "- sha256: $PrepReceiptSha",
    "",
    "## Parent selector proof",
    "",
    "- selector path: $NextObjectSelectorPath",
    "- selector sha256: $NextObjectSelectorSha",
    "- selector receipt path: $NextObjectSelectorReceiptPath",
    "- selector receipt sha256: $NextObjectSelectorReceiptSha",
    "",
    "## Parent lane closeout proof",
    "",
    "- lane closeout rough_local path: $LaneCloseoutRoughLocalPath",
    "- lane closeout rough_local sha256: $LaneCloseoutRoughLocalSha",
    "",
    "## Carried root snapshot facts",
    "",
    "- observed_root_top_level_file_count: 42",
    "- held_decision_candidate_count: 40",
    "- root_level_script_held_not_execute_count: 36",
    "- desktop_ini_leave_in_place_count: 1",
    "- zero_byte_review_only_no_delete_count: 1",
    "- known_source_authority_object_review_only_count: 1",
    "- current_runner_script_excluded_count: 1",
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
    "Import only pointer truth for the read-only prep card into the nested Git repo.",
    "Do not import full local root evidence. Do not clean up. Do not move root-held files. Do not delete. Do not route. Do not execute root scripts. Do not rewrite source. Do not promote doctrine. Do not push.",
    "",
    "## Next selected action",
    "",
    "next_build_chunk_selected: $NextBuildChunk",
    "",
    "## DoesNotProve",
    "",
    "This rough_local import proves only that the root-held read-only prep card pointer ledger and receipt were imported into nested Git. It does not prove the root files are safe, public-safe, stale, trash, route-ready, delete-ready, move-ready, source-ready, helper-ready, doctrine-ready, pushed, or cleaned.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_POINTER_LEDGER_READY"
)

$RoughLedgerLines | Set-Content -LiteralPath $LocalRoughLedgerPath -Encoding UTF8
$LocalRoughLedgerSha = Get-Sha256 -Path $LocalRoughLedgerPath

$RoughReceiptLines = @(
    "ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "source_prep_card_path: $PrepCardPath",
    "source_prep_card_sha256: $PrepCardSha",
    "source_prep_receipt_path: $PrepReceiptPath",
    "source_prep_receipt_sha256: $PrepReceiptSha",
    "rough_local_ledger_path: $LocalRoughLedgerPath",
    "rough_local_ledger_sha256: $LocalRoughLedgerSha",
    "git_head_before_import: $($GitHeadBefore.Trim())",
    "git_status_before_import: CLEAN",
    "observed_root_top_level_file_count: 42",
    "held_decision_candidate_count: 40",
    "root_level_script_held_not_execute_count: 36",
    "desktop_ini_leave_in_place_count: 1",
    "zero_byte_review_only_no_delete_count: 1",
    "known_source_authority_object_review_only_count: 1",
    "current_runner_script_excluded_count: 1",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "next_build_chunk_selected: $NextBuildChunk",
    "does_not_prove: root files safe; cleanup approved; movement approved; deletion approved; routing approved; source replay approved; helper execution approved; doctrine promotion approved; push approved",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_RECEIPT_READY"
)

$RoughReceiptLines | Set-Content -LiteralPath $LocalRoughReceiptPath -Encoding UTF8
$LocalRoughReceiptSha = Get-Sha256 -Path $LocalRoughReceiptPath

Copy-Item -LiteralPath $LocalRoughLedgerPath -Destination $GitRoughLedgerPath -Force
Copy-Item -LiteralPath $LocalRoughReceiptPath -Destination $GitRoughReceiptPath -Force

$ImportPacketLines = @(
    "# ROUGH_LOCAL ROOT HELD GROUP READ ONLY PREP CARD GIT IMPORT PACKET RECEIPT 20260608",
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
    "This import stages and commits exactly three files. It does not push. It does not cleanup. It does not move, delete, route, or execute root files. It does not rewrite source. It does not promote doctrine.",
    "",
    "final_verdict: ROUGH_LOCAL_ROOT_HELD_GROUP_READ_ONLY_PREP_CARD_GIT_IMPORT_PACKET_RECEIPT_READY"
)

$ImportPacketLines | Set-Content -LiteralPath $GitImportPacketReceiptPath -Encoding UTF8
$ImportPacketSha = Get-Sha256 -Path $GitImportPacketReceiptPath

$ExpectedStageRel = @(
    $GitRoughLedgerRel,
    $GitRoughReceiptRel,
    $GitImportPacketReceiptRel
)

Write-Host "local root-held prep hashes verified: YES"
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

& git -C $GitTop commit -m "Add root held group read only prep rough local ledger"
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
Write-Host "=== ROOT HELD GROUP READ ONLY PREP ROUGH_LOCAL IMPORT COMMITTED ==="
Write-Host "commit_hash: $CommitHash"
Write-Host "commit_message: Add root held group read only prep rough local ledger"
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
