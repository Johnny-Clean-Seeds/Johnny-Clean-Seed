Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608"
$FinalVerdict = "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_READY_WITH_SCOPE_LIMIT_NOTE"
$NextBuildChunk = "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_ROUGH_LOCAL_IMPORT_20260608"
$AlternateNextBuildChunk = "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "e877a6e4b242ef67ee25cef2cd4d756ce3af193d"

$Expected = [ordered]@{
    SelectorReport = [ordered]@{
        Path = Join-Path $LaneDir "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608.md"
        Sha256 = "81ECA10E1284CCA033D475965AC4209C864827651C75A88585B90FA754622BC3"
    }
    SelectorReceipt = [ordered]@{
        Path = Join-Path $LaneDir "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_RECEIPT_20260608.txt"
        Sha256 = "771333660B99960485C102C7972E46EDA80F91A12388F0FB4A24EBB21C2468F9"
    }
    QueueCloseoutCard = [ordered]@{
        Path = Join-Path $LaneDir "ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.md"
        Sha256 = "A5136F34466F5B480409C62B1BC212FA93195D80500C63F606F8AC8801747A51"
    }
    QueueCloseoutReceipt = [ordered]@{
        Path = Join-Path $LaneDir "ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_RECEIPT_20260608.txt"
        Sha256 = "8F7ECF520CFA44A71FB43729A58A93075EF195604A27EF8EFA1EDE2735952CB4"
    }
    QueueCloseoutRoughLocalLedger = [ordered]@{
        Path = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.md"
        Sha256 = "338DBFE97ECCA89DE9CB20D1AD8103DE84456CC88D44ED7E62ECC79A3E547AB1"
    }
    QueueCloseoutRoughLocalReceipt = [ordered]@{
        Path = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_RECEIPT_20260608.txt"
        Sha256 = "E31B3EF98C1B3F5F673C014B8062BA30B735985C24C68DAB5F7EF3B06316AFFA"
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

Write-Host "=== HELPER FILE SURFACE PREFLIGHT LANE CLOSEOUT CARD ==="

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

$SelectorText = ""
$QueueText = ""
if (Test-Path -LiteralPath $Expected.SelectorReport.Path -PathType Leaf) {
    $SelectorText = Get-Content -LiteralPath $Expected.SelectorReport.Path -Raw
}
if (Test-Path -LiteralPath $Expected.QueueCloseoutCard.Path -PathType Leaf) {
    $QueueText = Get-Content -LiteralPath $Expected.QueueCloseoutCard.Path -Raw
}

$RequiredSelectorSignals = @(
    "queue_items_accounted",
    "queue_items_unaccounted",
    "git_status_confirmed",
    "selected_next_build_chunk",
    "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608",
    "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_READY_WITH_SCOPE_LIMIT_NOTE"
)

foreach ($Signal in $RequiredSelectorSignals) {
    if ($SelectorText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "SELECTOR_SIGNAL_MISSING: $Signal"
    }
}

$RequiredQueueSignals = @(
    "original_queue_items",
    "accounted_queue_items",
    "unaccounted_queue_items",
    "files_moved_count",
    "files_deleted_count",
    "files_renamed_count",
    "files_overwritten_count",
    "ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_READY_WITH_SCOPE_LIMIT_NOTE"
)

foreach ($Signal in $RequiredQueueSignals) {
    if ($QueueText -notmatch [regex]::Escape($Signal)) {
        Add-Blocker "QUEUE_CLOSEOUT_SIGNAL_MISSING: $Signal"
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

$ReportPath = Join-Path $LaneDir "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md"
$ReceiptPath = Join-Path $LaneDir "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608.txt"

if (Test-Path -LiteralPath $ReportPath -PathType Leaf) {
    Add-Blocker "OUTPUT_REPORT_ALREADY_EXISTS_NO_OVERWRITE: $ReportPath"
}
if (Test-Path -LiteralPath $ReceiptPath -PathType Leaf) {
    Add-Blocker "OUTPUT_RECEIPT_ALREADY_EXISTS_NO_OVERWRITE: $ReceiptPath"
}

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$ReportLines = New-Object System.Collections.Generic.List[string]

$ReportLines.Add("# HELPER FILE SURFACE PREFLIGHT LANE CLOSEOUT CARD 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: LANE_CLOSEOUT_CARD / HEAVY_BOUNDARY_CHECK / NOT_CLEANUP_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Close the HELPER_FILE_SURFACE_PREFLIGHT_20260606 lane after the root-drop intake washer queue closeout and selector pass.") | Out-Null
$ReportLines.Add("This card preserves the verified state and selects the next safe action without cleanup, file movement, source replay, helper execution, doctrine promotion, commit, or push.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Verified load-bearing evidence") | Out-Null
$ReportLines.Add("") | Out-Null

foreach ($Line in $VerifiedLines) {
    $ReportLines.Add("- $Line") | Out-Null
}

$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Verified selector result") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- selector report path: $($Expected.SelectorReport.Path)") | Out-Null
$ReportLines.Add("- selector report sha256: $($Expected.SelectorReport.Sha256)") | Out-Null
$ReportLines.Add("- selector receipt path: $($Expected.SelectorReceipt.Path)") | Out-Null
$ReportLines.Add("- selector receipt sha256: $($Expected.SelectorReceipt.Sha256)") | Out-Null
$ReportLines.Add("- selected next build chunk: HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608") | Out-Null
$ReportLines.Add("- alternate next build chunk: PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Queue closeout carried into lane closeout") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- queue items accounted: 12") | Out-Null
$ReportLines.Add("- queue items unaccounted: 0") | Out-Null
$ReportLines.Add("- helper items accounted: 7") | Out-Null
$ReportLines.Add("- source items accounted: 1") | Out-Null
$ReportLines.Add("- support items accounted: 2") | Out-Null
$ReportLines.Add("- old/system items accounted: 2") | Out-Null
$ReportLines.Add("- files moved count: 0") | Out-Null
$ReportLines.Add("- files deleted count: 0") | Out-Null
$ReportLines.Add("- files renamed count: 0") | Out-Null
$ReportLines.Add("- source files copied count: 0") | Out-Null
$ReportLines.Add("- files overwritten count: 0") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Git state") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- git_top: $GitTop") | Out-Null
$ReportLines.Add("- git_head_confirmed: $($GitHead.Trim())") | Out-Null
$ReportLines.Add("- git_status_confirmed: CLEAN") | Out-Null
$ReportLines.Add("- git_commit_or_push_done_by_this_card: NO") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Lane verdict") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("The helper-file surface preflight lane has enough verified closeout evidence to move to rough_local import of this lane closeout card.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This does not authorize cleanup. It does not authorize deleting root-held files. It does not authorize helper execution. It does not authorize source rewrite. It does not authorize doctrine promotion. It does not authorize commit or push except the next explicitly selected rough_local import packet for this closeout card.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next selected action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("next_build_chunk_selected: $NextBuildChunk") | Out-Null
$ReportLines.Add("alternate_next_build_chunk_after_import: $AlternateNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## DoesNotProve") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This lane closeout card proves only that the verified washer queue closeout and selector evidence supports lane closeout. It does not prove the whole project is clean, public-safe, ready for cleanup, ready for source replay, ready for helper execution, ready for doctrine promotion, ready for push, or ready for root-held file movement.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND ==="
    foreach ($Blocker in $Blockers) {
        Write-Host $Blocker
    }
    Write-Host "final_verdict: HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_BLOCKED"
    exit 2
}

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "git_top: $GitTop",
    "git_head_confirmed: $($GitHead.Trim())",
    "git_status_confirmed: CLEAN",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_overwritten_count: 0",
    "git_commit_or_push_done: NO",
    "next_build_chunk_selected: $NextBuildChunk",
    "does_not_prove: project complete; cleanup approved; source replay approved; helper execution approved; doctrine promotion approved; push approved",
    "final_verdict: $FinalVerdict"
)

$ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptSha = Get-Sha256 -Path $ReceiptPath

Write-Host "=== HELPER FILE SURFACE PREFLIGHT LANE CLOSEOUT CARD COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "queue_items_accounted: 12"
Write-Host "queue_items_unaccounted: 0"
Write-Host "git_head_confirmed: $($GitHead.Trim())"
Write-Host "git_status_confirmed: CLEAN"
Write-Host "files_moved_count: 0"
Write-Host "files_deleted_count: 0"
Write-Host "files_renamed_count: 0"
Write-Host "files_overwritten_count: 0"
Write-Host "git_commit_or_push_done: NO"
Write-Host "next_build_chunk_selected: $NextBuildChunk"
Write-Host "final_verdict: $FinalVerdict"
