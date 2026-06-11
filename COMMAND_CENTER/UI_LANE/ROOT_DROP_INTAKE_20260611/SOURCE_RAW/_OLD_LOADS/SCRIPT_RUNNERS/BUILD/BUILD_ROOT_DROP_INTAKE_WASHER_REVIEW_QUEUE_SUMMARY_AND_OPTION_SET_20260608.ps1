$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"
$MultiFileReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_FIELD_TEST_ON_MORE_THAN_ONE_FILE_20260608.md"
$MultiFileReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"
$Schema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$SummaryBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608.md"
$SummaryV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_RECEIPT_V0_2_20260608.txt"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the queue failed. It proves this bounded summary/option-set runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER REVIEW QUEUE SUMMARY/OPTION SET BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_NOT_COMPLETE"
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

function Get-QueueItemBlocks {
    param([string]$Text)

    $matches = [regex]::Matches($Text, '(?ms)^## QUEUE_ITEM_\d+\s*\r?\n.*?(?=^## QUEUE_ITEM_\d+\s*\r?\n|\z)')
    return $matches
}

function Get-Field {
    param(
        [string]$Block,
        [string]$FieldName
    )

    $escaped = [regex]::Escape($FieldName)
    $pattern = "(?ms)^$escaped\s*:\s*\r?\n(?<value>.*?)(?=\r?\n[A-Za-z0-9_ -]+:\s*\r?\n|\r?\nblocked_actions:|\r?\nDoesNotProve:|\z)"
    $m = [regex]::Match($Block, $pattern)
    if (-not $m.Success) {
        return ""
    }

    return $m.Groups["value"].Value.Trim()
}

"=== ROOT DROP INTAKE WASHER REVIEW QUEUE SUMMARY AND OPTION SET ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "washer review queue"
$QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "washer review queue receipt"
$MultiFileReportHash = Require-Hash -Path $MultiFileReport -ExpectedSha256 "DE306B2A5A7BAF7D3B6E5AD39C972098F57E9701E1709A52F70A7503913E9E9E" -Name "multi-file washer field-test report"
$MultiFileReceiptHash = Require-Hash -Path $MultiFileReceipt -ExpectedSha256 "5770A63B7B719A9502921BC23556C74CC98B865E052DA94DEA15B3B5EEDFCF2F" -Name "multi-file washer field-test receipt"
$SchemaHash = Require-Hash -Path $Schema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

$SummaryPath = Choose-OutputPath -Base $SummaryBase -Fallback $SummaryV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$QueueText = Get-Content -LiteralPath $Queue -Raw
$Blocks = Get-QueueItemBlocks -Text $QueueText

if ($Blocks.Count -ne 12) {
    Write-BlockerAndExit -Reason "QUEUE_ITEM_COUNT_MISMATCH" -Detail "actual=$($Blocks.Count) expected=12 path=$Queue"
}

$Items = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($m in $Blocks) {
    $index += 1
    $block = $m.Value
    $bucket = Get-Field -Block $block -FieldName "queue_bucket"
    $observedPath = Get-Field -Block $block -FieldName "observed_path"
    $observedSha = Get-Field -Block $block -FieldName "observed_sha256"
    $candidateRole = Get-Field -Block $block -FieldName "candidate_role"
    $authorityState = Get-Field -Block $block -FieldName "authority_state"
    $suggestedRoute = Get-Field -Block $block -FieldName "suggested_route"
    $decision = Get-Field -Block $block -FieldName "next_human_decision"

    $Items.Add([pscustomobject]@{
        Index = $index
        Bucket = $bucket
        ObservedPath = $observedPath
        ObservedSha = $observedSha
        CandidateRole = $candidateRole
        AuthorityState = $authorityState
        SuggestedRoute = $suggestedRoute
        Decision = $decision
    })
}

$BucketGroups = $Items | Group-Object Bucket | Sort-Object Name
$BucketLines = foreach ($g in $BucketGroups) {
    "- $($g.Name): $($g.Count)"
}

$OptionBlocks = @"
## OPTION SET

### OPTION A — HOLD EVERYTHING READ-ONLY

Meaning:
Keep the current queue as a review surface only. No file action.

Use when:
You want to inspect names and hashes before deciding any route.

Allowed:
Read, compare, discuss, make notes.

Blocked:
Move, delete, cleanup, Git full-file staging, source promotion.

### OPTION B — REVIEW HELPER CANDIDATES FIRST

Queue bucket:
NEEDS_HELPER_REVIEW

Count:
7

Meaning:
Look at the helper/script-like root files first and decide whether they are still useful, superseded, or should later get a proper tool lane.

Blocked:
Do not run them merely because they are scripts. Do not stage them whole by default.

### OPTION C — REVIEW SOURCE AUTHORITY CANDIDATE

Queue bucket:
NEEDS_SOURCE_AUTHORITY_REVIEW

Count:
1

Meaning:
Inspect the single likely source candidate and decide whether it is active source, source candidate only, or old/stale.

Blocked:
Do not promote to source authority by location alone.

### OPTION D — REVIEW SUPPORT CANDIDATES

Queue bucket:
SUPPORT_REVIEW

Count:
2

Meaning:
Check whether these should stay as support guardrails/candidates or become active support later.

Blocked:
No doctrine/active-guide promotion without explicit later proof.

### OPTION E — REVIEW OLD/SYSTEM ITEMS

Queue bucket:
OLD_LOAD_OR_SYSTEM_REVIEW

Count:
2

Meaning:
These are likely old/system/noise review items. They still should not be deleted by this queue.

Blocked:
No cleanup until a separate cleanup executor exists and the user approves.

### OPTION F — BUILD A LATER ACTION PLAN ONLY

Meaning:
Create a later action plan from the queue, still without doing the action.

Use when:
You want a clean next packet for "what should happen later" while preserving the no-move/no-cleanup boundary.
"@

$QueueLines = foreach ($item in $Items) {
    "- ITEM_$("{0:D2}" -f $item.Index): [$($item.Bucket)] $($item.ObservedPath) :: role=$($item.CandidateRole) :: route=$($item.SuggestedRoute)"
}

$SummaryText = @"
# ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608

Status: SUMMARY_AND_OPTION_SET / READ_ONLY / HUMAN_DECISION_SURFACE / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Source queue:
$Queue

Source queue SHA256:
$QueueHash

Source queue receipt:
$QueueReceipt

Source queue receipt SHA256:
$QueueReceiptHash

Source multi-file field-test report:
$MultiFileReport

Source multi-file field-test report SHA256:
$MultiFileReportHash

Source multi-file field-test receipt:
$MultiFileReceipt

Source multi-file field-test receipt SHA256:
$MultiFileReceiptHash

Source washer schema:
$Schema

Source washer schema SHA256:
$SchemaHash

Purpose:
Condense the root-drop washer review queue into a small human decision surface.

This file does not authorize action. It only presents options.

## QUEUE SNAPSHOT

Items read:
$($Items.Count)

Bucket counts:
$($BucketLines -join "`r`n")

## QUEUE LINE SUMMARY

$($QueueLines -join "`r`n")

$OptionBlocks

## RECOMMENDED NEXT MOVE

Recommended next move:
OPTION B — REVIEW HELPER CANDIDATES FIRST

Reason:
The largest bucket is helper review with 7 items. Helper/script candidates have the highest risk of accidental execution or stale runner confusion. They should be sorted before any cleanup or source-promotion talk.

## STILL BLOCKED

- move
- delete
- rename
- route
- cleanup
- stage full root files
- commit full root files
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite
- script execution merely because a script exists

## NEXT RECOMMENDED BUILD CHUNK

ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608

Purpose:
Review only the 7 helper candidates from the queue and classify each as:
- likely current helper
- superseded helper
- unsafe/stale runner candidate
- needs deeper review
- rough_local hash pointer only

Still read-only. No execution. No cleanup. No Git.

## DOESNOTPROVE

This option set does not prove any file is safe, current, source authority, stale, cleanable, movable, deletable, routable, Git-safe, doctrine, active guide, current truth, or project complete.

## FINAL RETURN FIELDS

summary_path:
$SummaryPath

summary_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

queue_sha256_confirmed:
$QueueHash

queue_receipt_sha256_confirmed:
$QueueReceiptHash

multi_file_report_sha256_confirmed:
$MultiFileReportHash

multi_file_receipt_sha256_confirmed:
$MultiFileReceiptHash

schema_sha256_confirmed:
$SchemaHash

queue_items_read:
$($Items.Count)

recommended_option:
OPTION_B_REVIEW_HELPER_CANDIDATES_FIRST

files_moved_count:
0

files_deleted_count:
0

files_renamed_count:
0

source_files_copied_count:
0

files_overwritten_count:
0

git_commit_or_push_done:
NO

next_build_chunk_selected:
ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $SummaryPath -Text $SummaryText
$SummaryHash = (Get-FileHash -LiteralPath $SummaryPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_RECEIPT_20260608
Created: $Timestamp

summary_path: $SummaryPath
summary_sha256: $SummaryHash

queue_path: $Queue
queue_sha256: $QueueHash

queue_receipt_path: $QueueReceipt
queue_receipt_sha256: $QueueReceiptHash

multi_file_report_sha256: $MultiFileReportHash
multi_file_receipt_sha256: $MultiFileReceiptHash
schema_sha256: $SchemaHash

queue_items_read: $($Items.Count)

bucket_counts:
$($BucketLines -join "`r`n")

recommended_option: OPTION_B_REVIEW_HELPER_CANDIDATES_FIRST

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$SummaryText = $SummaryText.Replace("summary_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "summary_sha256:`r`n$SummaryHash")
$SummaryText = $SummaryText.Replace("summary_sha256:`nTO_BE_FILLED_AFTER_CREATION", "summary_sha256:`n$SummaryHash")
$SummaryText = $SummaryText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$SummaryText = $SummaryText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $SummaryPath -Text $SummaryText

$FinalSummaryHash = (Get-FileHash -LiteralPath $SummaryPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER REVIEW QUEUE SUMMARY AND OPTION SET COMPLETE ==="
"summary_path: $SummaryPath"
"summary_sha256: $FinalSummaryHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"queue_sha256_confirmed: $QueueHash"
"queue_receipt_sha256_confirmed: $QueueReceiptHash"
"multi_file_report_sha256_confirmed: $MultiFileReportHash"
"multi_file_receipt_sha256_confirmed: $MultiFileReceiptHash"
"schema_sha256_confirmed: $SchemaHash"
"queue_items_read: $($Items.Count)"
"bucket_counts:"
$BucketLines
"recommended_option: OPTION_B_REVIEW_HELPER_CANDIDATES_FIRST"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE"
