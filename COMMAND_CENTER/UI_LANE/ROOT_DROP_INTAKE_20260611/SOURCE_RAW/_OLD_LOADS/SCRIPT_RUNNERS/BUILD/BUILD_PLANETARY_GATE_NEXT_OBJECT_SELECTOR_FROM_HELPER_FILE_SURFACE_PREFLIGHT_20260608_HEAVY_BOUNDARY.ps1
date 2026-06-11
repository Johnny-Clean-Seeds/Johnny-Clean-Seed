Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608"
$FinalVerdict = "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_READY_WITH_SCOPE_LIMIT_NOTE"
$SelectedNextBuildChunk = "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_PREP_CARD_20260608"
$AlternateNextBuildChunk = "USER_REVIEW_NEXT_OBJECT_DECISION_CARD_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "521d4dd79b022592b143e08696138c7cf7611898"

$Expected = [ordered]@{
    LaneCloseoutCard = [ordered]@{
        Path = Join-Path $LaneDir "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
        Sha256 = "BA9DABB8BF4CEA36A742C2F393FD4D3E9BD73D70C5A3EFE9273D43EAE956DD72"
    }
    LaneCloseoutReceipt = [ordered]@{
        Path = Join-Path $LaneDir "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608.txt"
        Sha256 = "3302308EE81F885700B3EF5CEA5807A76EE4E1A04BF6968ECB2BFC1B4296CE60"
    }
    LaneCloseoutRoughLocalLedger = [ordered]@{
        Path = Join-Path $LaneDir "ROUGH_LOCAL__HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
        Sha256 = "38505DAE4DD4292CDBFA8441E78952F57D06BF94B7B4B09BCE2F4F0E37D1FF2F"
    }
    LaneCloseoutRoughLocalReceipt = [ordered]@{
        Path = Join-Path $LaneDir "ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608.txt"
        Sha256 = "3E20324A2B3D8B8608C3FA35012FF65D3CC6965AA45A26B891CBC8C6A83017C8"
    }
    ParentSelectorReport = [ordered]@{
        Path = Join-Path $LaneDir "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608.md"
        Sha256 = "81ECA10E1284CCA033D475965AC4209C864827651C75A88585B90FA754622BC3"
    }
    ParentSelectorReceipt = [ordered]@{
        Path = Join-Path $LaneDir "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_RECEIPT_20260608.txt"
        Sha256 = "771333660B99960485C102C7972E46EDA80F91A12388F0FB4A24EBB21C2468F9"
    }
}

$GitImportRel = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/HELPER_FILE_SURFACE_PREFLIGHT_20260606/ROUGH_LOCAL_GIT_IMPORT_20260608/HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT"
$GitImportFiles = [ordered]@{
    GitRoughLocalLedger = [ordered]@{
        Path = Join-Path $GitTop (($GitImportRel + "/ROUGH_LOCAL__HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md") -replace "/", "\")
        Sha256 = "38505DAE4DD4292CDBFA8441E78952F57D06BF94B7B4B09BCE2F4F0E37D1FF2F"
    }
    GitRoughLocalReceipt = [ordered]@{
        Path = Join-Path $GitTop (($GitImportRel + "/ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608.txt") -replace "/", "\")
        Sha256 = "3E20324A2B3D8B8608C3FA35012FF65D3CC6965AA45A26B891CBC8C6A83017C8"
    }
    GitImportPacketReceipt = [ordered]@{
        Path = Join-Path $GitTop (($GitImportRel + "/ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_GIT_IMPORT_PACKET_RECEIPT_20260608.md") -replace "/", "\")
        Sha256 = "C5755F2D28A80464CE9D38682792634DB19ADB9F1ED52E2A7FE2D0E2C5739A60"
    }
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Blocker {
    param([string]$Message)
    $script:Blockers.Add($Message) | Out-Null
}

$Blockers = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]

Write-Host "=== PLANETARY GATE NEXT OBJECT SELECTOR FROM HELPER FILE SURFACE PREFLIGHT ==="

if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
    Add-Blocker "ROOT_NOT_FOUND: $Root"
}
if (-not (Test-Path -LiteralPath $LaneDir -PathType Container)) {
    Add-Blocker "LANE_DIR_NOT_FOUND: $LaneDir"
}
if (-not (Test-Path -LiteralPath $GitTop -PathType Container)) {
    Add-Blocker "GIT_TOP_NOT_FOUND: $GitTop"
}

foreach ($Key in $Expected.Keys) {
    $Path = [string]$Expected[$Key].Path
    $Want = [string]$Expected[$Key].Sha256

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Blocker "REQUIRED_LOCAL_FILE_MISSING: $Key :: $Path"
        continue
    }

    $Got = Get-Sha256 -Path $Path
    if ($Got -ne $Want) {
        Add-Blocker "LOCAL_SHA256_MISMATCH: $Key :: expected $Want :: got $Got :: path $Path"
        continue
    }

    $VerifiedLines.Add("$Key SHA256 confirmed: $Got") | Out-Null
}

foreach ($Key in $GitImportFiles.Keys) {
    $Path = [string]$GitImportFiles[$Key].Path
    $Want = [string]$GitImportFiles[$Key].Sha256

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Blocker "REQUIRED_GIT_IMPORT_FILE_MISSING: $Key :: $Path"
        continue
    }

    $Got = Get-Sha256 -Path $Path
    if ($Got -ne $Want) {
        Add-Blocker "GIT_IMPORT_SHA256_MISMATCH: $Key :: expected $Want :: got $Got :: path $Path"
        continue
    }

    $VerifiedLines.Add("$Key SHA256 confirmed: $Got") | Out-Null
}

$LaneRoughText = ""
if (Test-Path -LiteralPath $Expected.LaneCloseoutRoughLocalLedger.Path -PathType Leaf) {
    $LaneRoughText = Get-Content -LiteralPath $Expected.LaneCloseoutRoughLocalLedger.Path -Raw
}

$RequiredSignals = @(
    "ROUGH_LOCAL_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_POINTER_LEDGER_READY",
    "next_build_chunk_selected: PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608",
    "queue_items_accounted: 12",
    "queue_items_unaccounted: 0",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_overwritten_count: 0",
    "Do not run cleanup",
    "Do not execute helper candidates",
    "Do not rewrite source",
    "Do not promote doctrine",
    "Do not push"
)

foreach ($Signal in $RequiredSignals) {
    if ($LaneRoughText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "LANE_ROUGH_LOCAL_SIGNAL_MISSING: $Signal"
    }
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

$ReportPath = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608.md"
$ReceiptPath = Join-Path $LaneDir "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_RECEIPT_20260608.txt"

if (Test-Path -LiteralPath $ReportPath -PathType Leaf) {
    Add-Blocker "OUTPUT_REPORT_ALREADY_EXISTS_NO_OVERWRITE: $ReportPath"
}
if (Test-Path -LiteralPath $ReceiptPath -PathType Leaf) {
    Add-Blocker "OUTPUT_RECEIPT_ALREADY_EXISTS_NO_OVERWRITE: $ReceiptPath"
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND BEFORE WRITE ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_BLOCKED"
    exit 2
}

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$ReportLines = New-Object System.Collections.Generic.List[string]

$ReportLines.Add("# PLANETARY GATE NEXT OBJECT SELECTOR FROM HELPER FILE SURFACE PREFLIGHT 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: NEXT_OBJECT_SELECTOR / HEAVY_BOUNDARY_CHECK / NOT_CLEANUP_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Select the next safe object after helper-file surface preflight lane closeout has been committed as rough_local pointer truth in the nested repo.") | Out-Null
$ReportLines.Add("This selector does not clean, move, delete, rename, execute helpers, rewrite source, promote doctrine, commit, or push.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Verified load-bearing evidence") | Out-Null
$ReportLines.Add("") | Out-Null

foreach ($Line in $VerifiedLines) {
    $ReportLines.Add("- $Line") | Out-Null
}

$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Git state") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- git_top: $GitTop") | Out-Null
$ReportLines.Add("- git_head_confirmed: $($GitHead.Trim())") | Out-Null
$ReportLines.Add("- git_status_confirmed: CLEAN") | Out-Null
$ReportLines.Add("- git_commit_or_push_done_by_this_selector: NO") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Decision logic") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("The root-drop intake washer queue is closed.") | Out-Null
$ReportLines.Add("The helper-file surface preflight lane is closed enough to leave the lane.") | Out-Null
$ReportLines.Add("The next known open house problem is the held root group, but the correct next move is still read-only prep, not cleanup or routing.") | Out-Null
$ReportLines.Add("The selected next object must preserve the same boundary: review/decision first, no movement first.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Selected next object") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("selected_next_build_chunk: $SelectedNextBuildChunk") | Out-Null
$ReportLines.Add("alternate_next_build_chunk: $AlternateNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Stop lines carried forward") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- no cleanup") | Out-Null
$ReportLines.Add("- no delete") | Out-Null
$ReportLines.Add("- no rename") | Out-Null
$ReportLines.Add("- no move") | Out-Null
$ReportLines.Add("- no helper execution") | Out-Null
$ReportLines.Add("- no source replay") | Out-Null
$ReportLines.Add("- no doctrine promotion") | Out-Null
$ReportLines.Add("- no push") | Out-Null
$ReportLines.Add("- no treating rough_local pointer import as full local evidence") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next selected action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("next_build_chunk_selected: $SelectedNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## DoesNotProve") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This selector proves only that the helper-file surface preflight lane can hand off to the next read-only prep object. It does not prove the root held files are classified, public-safe, ready for cleanup, ready for movement, ready for deletion, ready for routing, ready for source replay, ready for helper execution, ready for doctrine promotion, or ready for push.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "git_top: $GitTop",
    "git_head_confirmed: $($GitHead.Trim())",
    "git_status_confirmed: CLEAN",
    "git_commit_or_push_done: NO",
    "selected_next_build_chunk: $SelectedNextBuildChunk",
    "alternate_next_build_chunk: $AlternateNextBuildChunk",
    "does_not_prove: root held files classified; cleanup approved; movement approved; source replay approved; helper execution approved; doctrine promotion approved; push approved",
    "final_verdict: $FinalVerdict"
)

$ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptSha = Get-Sha256 -Path $ReceiptPath

Write-Host "=== PLANETARY GATE NEXT OBJECT SELECTOR FROM HELPER FILE SURFACE PREFLIGHT COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "git_head_confirmed: $($GitHead.Trim())"
Write-Host "git_status_confirmed: CLEAN"
Write-Host "git_commit_or_push_done: NO"
Write-Host "selected_next_build_chunk: $SelectedNextBuildChunk"
Write-Host "alternate_next_build_chunk: $AlternateNextBuildChunk"
Write-Host "next_build_chunk_selected: $SelectedNextBuildChunk"
Write-Host "final_verdict: $FinalVerdict"
