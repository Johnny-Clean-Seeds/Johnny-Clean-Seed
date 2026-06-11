$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$MultiFileReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_FIELD_TEST_ON_MORE_THAN_ONE_FILE_20260608.md"
$MultiFileReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"
$CardsFolder = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_CARDS_20260608"
$Schema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$QueueBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_V0_2_20260608.txt"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the washer schema failed. It proves this bounded review-queue runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER REVIEW QUEUE BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_NOT_COMPLETE"
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

function Get-CardField {
    param(
        [string]$Text,
        [string]$FieldName
    )

    $escaped = [regex]::Escape($FieldName)
    $pattern = "(?ms)^$escaped\s*:\s*\r?\n(?<value>.*?)(?=\r?\n[A-Za-z0-9_ -]+:\s*\r?\n|\r?\n##|\z)"
    $m = [regex]::Match($Text, $pattern)
    if (-not $m.Success) {
        return ""
    }

    return $m.Groups["value"].Value.Trim()
}

function Get-QueueBucket {
    param(
        [string]$CandidateRole,
        [string]$AuthorityState,
        [string]$SuggestedRoute,
        [string]$ObservedPath
    )

    $fileName = [System.IO.Path]::GetFileName($ObservedPath)

    if ($CandidateRole -eq "ACTIVE_SOURCE_CANDIDATE") {
        return "NEEDS_SOURCE_AUTHORITY_REVIEW"
    }

    if ($CandidateRole -eq "HELPER_CANDIDATE") {
        return "NEEDS_HELPER_REVIEW"
    }

    if ($CandidateRole -eq "SUPPORT_GUARDRAIL_CANDIDATE") {
        return "SUPPORT_REVIEW"
    }

    if ($CandidateRole -eq "RECEIPT" -or $AuthorityState -eq "HASH_POINTER_ONLY") {
        return "HASH_POINTER_REVIEW"
    }

    if ($SuggestedRoute -eq "OLD_LOAD_REVIEW" -or $fileName -eq "desktop.ini") {
        return "OLD_LOAD_OR_SYSTEM_REVIEW"
    }

    return "UNKNOWN_REVIEW"
}

function Get-NextHumanDecision {
    param(
        [string]$QueueBucket,
        [string]$CandidateRole
    )

    switch ($QueueBucket) {
        "NEEDS_SOURCE_AUTHORITY_REVIEW" { return "Decide whether this is active source, source candidate only, or old/stale source." }
        "NEEDS_HELPER_REVIEW" { return "Decide whether this helper/script should be retained, routed to tools, superseded, or ignored." }
        "SUPPORT_REVIEW" { return "Decide whether this stays as support guardrail, becomes active support, or remains candidate only." }
        "HASH_POINTER_REVIEW" { return "Decide whether hash pointer is enough or whether full local evidence needs separate approval." }
        "OLD_LOAD_OR_SYSTEM_REVIEW" { return "Decide whether this is system noise, old load, or safe to ignore later." }
        default { return "Review manually before any route, move, cleanup, or promotion." }
    }
}

"=== ROOT DROP INTAKE WASHER REVIEW QUEUE BUILD ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$SchemaHash = Require-Hash -Path $Schema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"
$MultiFileReportHash = Require-Hash -Path $MultiFileReport -ExpectedSha256 "DE306B2A5A7BAF7D3B6E5AD39C972098F57E9701E1709A52F70A7503913E9E9E" -Name "multi-file washer field-test report"
$MultiFileReceiptHash = Require-Hash -Path $MultiFileReceipt -ExpectedSha256 "5770A63B7B719A9502921BC23556C74CC98B865E052DA94DEA15B3B5EEDFCF2F" -Name "multi-file washer field-test receipt"

if (-not (Test-Path -LiteralPath $CardsFolder -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_CARDS_FOLDER" -Detail $CardsFolder
}

$CardFiles = @(Get-ChildItem -LiteralPath $CardsFolder -Force -File -Filter "*.md" | Sort-Object Name)

if ($CardFiles.Count -ne 12) {
    Write-BlockerAndExit -Reason "UNEXPECTED_CARD_COUNT" -Detail "actual=$($CardFiles.Count) expected=12 folder=$CardsFolder"
}

$QueuePath = Choose-OutputPath -Base $QueueBase -Fallback $QueueV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$Items = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($card in $CardFiles) {
    $index += 1
    $text = Get-Content -LiteralPath $card.FullName -Raw
    $cardHash = (Get-FileHash -LiteralPath $card.FullName -Algorithm SHA256).Hash

    $observedPath = Get-CardField -Text $text -FieldName "observed_path"
    $observedHash = Get-CardField -Text $text -FieldName "observed_sha256"
    $observedSize = Get-CardField -Text $text -FieldName "observed_size_bytes"
    $candidateRole = Get-CardField -Text $text -FieldName "candidate_role"
    $authorityState = Get-CardField -Text $text -FieldName "authority_state"
    $suggestedRoute = Get-CardField -Text $text -FieldName "suggested_route"
    $notes = Get-CardField -Text $text -FieldName "classification_notes"

    if ([string]::IsNullOrWhiteSpace($observedPath)) {
        Write-BlockerAndExit -Reason "CARD_PARSE_FAILED" -Detail "Missing observed_path in $($card.FullName)"
    }

    $bucket = Get-QueueBucket -CandidateRole $candidateRole -AuthorityState $authorityState -SuggestedRoute $suggestedRoute -ObservedPath $observedPath
    $decision = Get-NextHumanDecision -QueueBucket $bucket -CandidateRole $candidateRole

    $Items.Add([pscustomobject]@{
        QueueIndex = $index
        QueueBucket = $bucket
        ObservedPath = $observedPath
        ObservedSha256 = $observedHash
        ObservedSizeBytes = $observedSize
        CandidateRole = $candidateRole
        AuthorityState = $authorityState
        SuggestedRoute = $suggestedRoute
        NextHumanDecision = $decision
        ClassificationNotes = $notes
        SourceCardPath = $card.FullName
        SourceCardSha256 = $cardHash
    })
}

$BucketGroups = $Items | Group-Object QueueBucket | Sort-Object Name
$BucketLines = foreach ($g in $BucketGroups) {
    "- $($g.Name): $($g.Count)"
}

$QueueItemBlocks = foreach ($item in $Items) {
    @"
## QUEUE_ITEM_$("{0:D2}" -f $item.QueueIndex)

queue_bucket:
$($item.QueueBucket)

observed_path:
$($item.ObservedPath)

observed_sha256:
$($item.ObservedSha256)

observed_size_bytes:
$($item.ObservedSizeBytes)

candidate_role:
$($item.CandidateRole)

authority_state:
$($item.AuthorityState)

suggested_route:
$($item.SuggestedRoute)

next_human_decision:
$($item.NextHumanDecision)

classification_notes:
$($item.ClassificationNotes)

source_card_path:
$($item.SourceCardPath)

source_card_sha256:
$($item.SourceCardSha256)

blocked_actions:
move; delete; rename; route; cleanup; stage; commit; push; source rewrite; doctrine promotion; active guide promotion; current truth index rewrite

DoesNotProve:
This queue item does not prove the observed file is safe, current, source authority, stale, cleanable, movable, deletable, routable, Git-safe, doctrine, active guide, current truth, or project complete.

"@
}

$QueueText = @"
# ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608

Status: REVIEW_QUEUE / READ_ONLY / FROM_MULTI_FILE_DRY_RUN / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Source schema:
$Schema

Source schema SHA256:
$SchemaHash

Source multi-file report:
$MultiFileReport

Source multi-file report SHA256:
$MultiFileReportHash

Source multi-file receipt:
$MultiFileReceipt

Source multi-file receipt SHA256:
$MultiFileReceiptHash

Source cards folder:
$CardsFolder

Cards read:
$($Items.Count)

Purpose:
Convert the root-drop intake washer multi-file dry-run cards into a human review queue.

This queue does not execute any route, move, cleanup, Git action, or promotion.

## QUEUE BUCKET COUNTS

$($BucketLines -join "`r`n")

## REVIEW RULE

Each item needs a human decision before any physical file action.

Allowed now:
- inspect
- classify
- compare hashes
- decide next authority needed
- create a later action plan

Still blocked:
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

## QUEUE ITEMS

$($QueueItemBlocks -join "`r`n")

## NEXT RECOMMENDED BUILD CHUNK

ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608

Purpose:
Summarize the queue into a small human-readable option set:
- keep/root-pending-review
- candidate support
- helper review
- possible source candidate
- old/system review
- rough_local pointer only

No physical action until explicitly approved.

## DOESNOTPROVE

This review queue does not prove any file is safe, current, source authority, stale, cleanable, movable, deletable, routable, Git-safe, doctrine, active guide, current truth, or project complete.

## FINAL RETURN FIELDS

queue_path:
$QueuePath

queue_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

cards_folder:
$CardsFolder

cards_read_count:
$($Items.Count)

schema_sha256_confirmed:
$SchemaHash

multi_file_report_sha256_confirmed:
$MultiFileReportHash

multi_file_receipt_sha256_confirmed:
$MultiFileReceiptHash

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
ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $QueuePath -Text $QueueText
$QueueHash = (Get-FileHash -LiteralPath $QueuePath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608
Created: $Timestamp

queue_path: $QueuePath
queue_sha256: $QueueHash

cards_folder: $CardsFolder
cards_read_count: $($Items.Count)

schema_path: $Schema
schema_sha256: $SchemaHash

multi_file_report_path: $MultiFileReport
multi_file_report_sha256: $MultiFileReportHash

multi_file_receipt_path: $MultiFileReceipt
multi_file_receipt_sha256: $MultiFileReceiptHash

queue_bucket_counts:
$($BucketLines -join "`r`n")

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$QueueText = $QueueText.Replace("queue_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "queue_sha256:`r`n$QueueHash")
$QueueText = $QueueText.Replace("queue_sha256:`nTO_BE_FILLED_AFTER_CREATION", "queue_sha256:`n$QueueHash")
$QueueText = $QueueText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$QueueText = $QueueText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $QueuePath -Text $QueueText

$FinalQueueHash = (Get-FileHash -LiteralPath $QueuePath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER REVIEW QUEUE COMPLETE ==="
"queue_path: $QueuePath"
"queue_sha256: $FinalQueueHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"cards_folder: $CardsFolder"
"cards_read_count: $($Items.Count)"
"schema_sha256_confirmed: $SchemaHash"
"multi_file_report_sha256_confirmed: $MultiFileReportHash"
"multi_file_receipt_sha256_confirmed: $MultiFileReceiptHash"
"queue_bucket_counts:"
$BucketLines
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_READY_WITH_SCOPE_LIMIT_NOTE"
