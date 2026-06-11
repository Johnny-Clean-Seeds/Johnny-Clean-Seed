$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$GitRepo = Join-Path $ProjectRoot "Jxhnny_Kl33N_Seedz"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$QueueCloseoutCard = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.md"
$QueueCloseoutReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_RECEIPT_20260608.txt"
$QueueCloseoutRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.md"
$QueueCloseoutRoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_RECEIPT_20260608.txt"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueSummary = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608.md"
$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$HelperRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$SourceRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SupportRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"
$OldSystemRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.md"

$OutputBase = Join-Path $Lane "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608.md"
$OutputV2 = Join-Path $Lane "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_RECEIPT_V0_2_20260608.txt"

function Ensure-ParentFolder {
    param([string]$Path)

    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function Write-TextFile {
    param(
        [string]$Path,
        [string]$Text
    )

    Ensure-ParentFolder -Path $Path
    [System.IO.File]::WriteAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Write-BlockerAndExit {
    param(
        [string]$Reason,
        [string]$Detail
    )

    $BlockerPath = Join-Path $Lane "BLOCKER__PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the washer closeout failed. It proves this bounded selector runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== HELPER FILE SURFACE PREFLIGHT CLOSEOUT OR NEXT SELECTOR BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_NOT_COMPLETE"
    exit 1
}

function Require-Hash {
    param(
        [string]$Path,
        [string]$ExpectedSha256,
        [string]$Name
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Write-BlockerAndExit -Reason "MISSING_REQUIRED_FILE" -Detail "$Name :: $Path"
    }

    $actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($actual -ne $ExpectedSha256) {
        Write-BlockerAndExit -Reason "HASH_MISMATCH" -Detail "$Name :: actual=$actual expected=$ExpectedSha256 path=$Path"
    }

    return $actual
}

function Choose-OutputPath {
    param(
        [string]$Base,
        [string]$Fallback
    )

    if (-not (Test-Path -LiteralPath $Base -PathType Leaf)) {
        return $Base
    }

    if (-not (Test-Path -LiteralPath $Fallback -PathType Leaf)) {
        return $Fallback
    }

    Write-BlockerAndExit -Reason "OUTPUT_COLLISION" -Detail "Both output paths already exist: $Base and $Fallback"
}

"=== PLANETARY GATE HELPER FILE SURFACE PREFLIGHT CLOSEOUT OR NEXT SELECTOR ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$QueueCloseoutCardHash = Require-Hash -Path $QueueCloseoutCard -ExpectedSha256 "A5136F34466F5B480409C62B1BC212FA93195D80500C63F606F8AC8801747A51" -Name "queue closeout card"
$QueueCloseoutReceiptHash = Require-Hash -Path $QueueCloseoutReceipt -ExpectedSha256 "8F7ECF520CFA44A71FB43729A58A93075EF195604A27EF8EFA1EDE2735952CB4" -Name "queue closeout receipt"
$QueueCloseoutRoughHash = Require-Hash -Path $QueueCloseoutRough -ExpectedSha256 "338DBFE97ECCA89DE9CB20D1AD8103DE84456CC88D44ED7E62ECC79A3E547AB1" -Name "queue closeout rough_local ledger"
$QueueCloseoutRoughReceiptHash = Require-Hash -Path $QueueCloseoutRoughReceipt -ExpectedSha256 "E31B3EF98C1B3F5F673C014B8062BA30B735985C24C68DAB5F7EF3B06316AFFA" -Name "queue closeout rough_local receipt"

$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "washer review queue"
$QueueSummaryHash = Require-Hash -Path $QueueSummary -ExpectedSha256 "BD659A643AE3865FAB2FCEB0DC7C1700BBE4EF4F26D3803C6E0FB52127D61869" -Name "washer review queue summary"
$WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer support card schema"

$HelperRoughHash = Require-Hash -Path $HelperRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper option rough_local"
$SourceRoughHash = Require-Hash -Path $SourceRough -ExpectedSha256 "7BAE7F5EA6B1673BDFF91F13BE4981D26871E99B65C944E371D5E15220843FCA" -Name "source option rough_local"
$SupportRoughHash = Require-Hash -Path $SupportRough -ExpectedSha256 "6C649C373DBC910D5E6B4F7BFCB0393330FC042DE7692D8F844E2592F58816D9" -Name "support option rough_local"
$OldSystemRoughHash = Require-Hash -Path $OldSystemRough -ExpectedSha256 "6336441DBE5255B09FD0FF4B9245381E6279E3D93F595680051CA91A97F27D96" -Name "old/system option rough_local"

if (-not (Test-Path -LiteralPath $GitRepo -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_GIT_REPO_FOLDER" -Detail $GitRepo
}

$GitTop = (& git -C $GitRepo rev-parse --show-toplevel 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($GitTop)) {
    Write-BlockerAndExit -Reason "NESTED_FOLDER_NOT_GIT_WORKTREE" -Detail $GitRepo
}

$GitTop = $GitTop.Trim()
$GitHead = (& git -C $GitTop rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($GitHead)) {
    Write-BlockerAndExit -Reason "GIT_HEAD_CHECK_FAILED" -Detail "git rev-parse HEAD failed"
}

if ($GitHead -ne "e877a6e4b242ef67ee25cef2cd4d756ce3af193d") {
    Write-BlockerAndExit -Reason "UNEXPECTED_GIT_HEAD" -Detail "actual=$GitHead expected=e877a6e4b242ef67ee25cef2cd4d756ce3af193d"
}

$GitStatus = @(& git -C $GitTop status --short)
if ($LASTEXITCODE -ne 0) {
    Write-BlockerAndExit -Reason "GIT_STATUS_CHECK_FAILED" -Detail "git status --short failed"
}

$GitStatusLabel = "CLEAN"
if ($GitStatus.Count -ne 0) {
    $GitStatusLabel = "NOT_CLEAN"
    Write-BlockerAndExit -Reason "GIT_STATUS_NOT_CLEAN" -Detail ($GitStatus -join "; ")
}

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$SelectedNext = "HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608"
$AlternateNext = "PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608"

$ReportText = @"
# PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608

Status: SELECTOR_CARD / LANE_DECISION_POINT / READ_ONLY / NO_CLEANUP / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Nested Git repo:
$GitTop

Nested Git HEAD:
$GitHead

Nested Git status:
$GitStatusLabel

Purpose:
Select the next safe step after the root-drop intake washer queue was fully closeout-accounted and rough_local-imported.

## VERIFIED INPUTS

Queue closeout card:
$QueueCloseoutCard

Queue closeout card SHA256:
$QueueCloseoutCardHash

Queue closeout receipt:
$QueueCloseoutReceipt

Queue closeout receipt SHA256:
$QueueCloseoutReceiptHash

Queue closeout rough_local ledger:
$QueueCloseoutRough

Queue closeout rough_local ledger SHA256:
$QueueCloseoutRoughHash

Queue closeout rough_local receipt:
$QueueCloseoutRoughReceipt

Queue closeout rough_local receipt SHA256:
$QueueCloseoutRoughReceiptHash

Washer review queue SHA256:
$QueueHash

Washer review queue summary SHA256:
$QueueSummaryHash

Washer schema SHA256:
$WasherSchemaHash

Helper rough_local SHA256:
$HelperRoughHash

Source rough_local SHA256:
$SourceRoughHash

Support rough_local SHA256:
$SupportRoughHash

Old/system rough_local SHA256:
$OldSystemRoughHash

## WASHER RESULT

Queue accounting:
- original queue items: 12
- accounted queue items: 12
- unaccounted queue items: 0

Bucket accounting:
- helper candidates: 7
- source authority candidates: 1
- support candidates: 2
- old/system candidates: 2

Mutation accounting:
- files moved: 0
- files deleted: 0
- files renamed: 0
- files overwritten: 0
- cleanup done: NO
- full file Git import done: NO
- rough_local pointer imports done: YES

Latest rough_local closeout commit:
e877a6e4b242ef67ee25cef2cd4d756ce3af193d

## DECISION

The washer itself is complete for this lane slice.

The next safest step is not cleanup. The next safest step is lane closeout, because the helper-file surface preflight now has a complete bounded washer result and should preserve the final state before any next-object selection.

Selected next build chunk:
$SelectedNext

Alternate after lane closeout:
$AlternateNext

## WHY NOT CLEANUP NOW

The washer classified files. It did not grant cleanup authority.

Old/system classification does not mean trash.

Support classification does not mean active guide or executor.

Helper candidate classification does not mean run helper.

Source candidate match does not mean rewrite source.

## NEXT ACTION CARD

Recommended immediate next script:
BUILD_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.ps1

Expected output object:
HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_20260608.md

Purpose:
Close the broader helper-file surface preflight lane around:
- root-drop washer queue closeout
- rough_local hash boundary
- generated-runner failure freezes
- no-cleanup/no-move/no-full-file-import boundary
- current nested Git HEAD and clean status
- next object selector handoff

After that:
ROUGH_LOCAL_IMPORT_FOR_HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_20260608

Then:
PLANETARY_GATE_NEXT_OBJECT_SELECTOR_FROM_HELPER_FILE_SURFACE_PREFLIGHT_20260608

## STILL BLOCKED

- cleanup
- delete
- move
- rename
- route
- restore missing file
- recreate missing file
- run helper candidates
- stage full helper files
- stage full support files
- stage full old/system files
- stage full source file
- commit full source/support/helper/old-system files
- push
- promote support to doctrine
- promote support to active guide
- treat support as executor
- source rewrite
- current truth index rewrite

## DOESNOTPROVE

This selector does not prove the helper-file surface preflight lane is fully closed, project complete, cleanup authorized, routing authorized, helper execution authorized, support promotion authorized, source rewrite authorized, or full-file Git import authorized.

It only selects the next safe step after the washer queue closeout.

## FINAL RETURN FIELDS

output_report_path:
$OutputPath

output_report_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

queue_closeout_card_sha256_confirmed:
$QueueCloseoutCardHash

queue_closeout_rough_local_sha256_confirmed:
$QueueCloseoutRoughHash

queue_items_accounted:
12

queue_items_unaccounted:
0

git_head_confirmed:
$GitHead

git_status_confirmed:
$GitStatusLabel

selected_next_build_chunk:
$SelectedNext

alternate_next_build_chunk:
$AlternateNext

files_moved_count:
0

files_deleted_count:
0

files_renamed_count:
0

files_overwritten_count:
0

git_commit_or_push_done:
NO

next_build_chunk_selected:
$SelectedNext

final_verdict:
PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_RECEIPT_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

queue_closeout_card_sha256: $QueueCloseoutCardHash
queue_closeout_receipt_sha256: $QueueCloseoutReceiptHash
queue_closeout_rough_local_sha256: $QueueCloseoutRoughHash
queue_closeout_rough_local_receipt_sha256: $QueueCloseoutRoughReceiptHash

queue_sha256: $QueueHash
queue_summary_sha256: $QueueSummaryHash
washer_schema_sha256: $WasherSchemaHash

helper_rough_local_sha256: $HelperRoughHash
source_rough_local_sha256: $SourceRoughHash
support_rough_local_sha256: $SupportRoughHash
old_system_rough_local_sha256: $OldSystemRoughHash

queue_items_accounted: 12
queue_items_unaccounted: 0

git_head_confirmed: $GitHead
git_status_confirmed: $GitStatusLabel

selected_next_build_chunk: $SelectedNext
alternate_next_build_chunk: $AlternateNext

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
files_overwritten_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: $SelectedNext
final_verdict: PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== PLANETARY GATE HELPER FILE SURFACE PREFLIGHT CLOSEOUT OR NEXT SELECTOR COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"queue_closeout_card_sha256_confirmed: $QueueCloseoutCardHash"
"queue_closeout_rough_local_sha256_confirmed: $QueueCloseoutRoughHash"
"queue_items_accounted: 12"
"queue_items_unaccounted: 0"
"git_head_confirmed: $GitHead"
"git_status_confirmed: $GitStatusLabel"
"selected_next_build_chunk: $SelectedNext"
"alternate_next_build_chunk: $AlternateNext"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"files_overwritten_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: $SelectedNext"
"final_verdict: PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_READY_WITH_SCOPE_LIMIT_NOTE"
