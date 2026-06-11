$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$OldSystemReviewReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608.md"
$OldSystemReviewReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$OldSystemCardsFolder = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_CARDS_V0_2_20260608"

$OldSystemFreeze = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW__20260608\ERROR_FREEZE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW_20260608.md"
$OldSystemFixNote = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW__20260608\FIX_NOTE__OLD_SYSTEM_REVIEW_V0_2_MISSING_AT_REVIEW_RECORD_20260608.md"
$OldSystemIncidentReceipt = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW__20260608\HASH_RECEIPT__OLD_SYSTEM_REVIEW_V0_2_FIX_20260608.txt"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"

$SupportOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.md"
$SupportOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"

$SourceOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SourceOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"

$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"

$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.md"
$OutputV3 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_3_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_RECEIPT_V0_2_20260608.txt"
$ReceiptV3 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_RECEIPT_V0_3_20260608.txt"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the old/system review failed. It proves this bounded old/system option-set runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER OLD LOAD OR SYSTEM OPTION SET V0_2 BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_NOT_COMPLETE"
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

function Get-Field {
    param(
        [string]$Text,
        [string]$FieldName
    )

    $escaped = [regex]::Escape($FieldName)
    $pattern = "(?ms)^$escaped\s*:\s*\r?\n(?<value>.*?)(?=\r?\n[A-Za-z0-9_ -]+:\s*\r?\n|\r?\nblocked_actions:|\r?\nproof_need:|\r?\nDoesNotProve:|\z)"
    $m = [regex]::Match($Text, $pattern)
    if (-not $m.Success) {
        return ""
    }

    return $m.Groups["value"].Value.Trim()
}

"=== ROOT DROP INTAKE WASHER OLD LOAD OR SYSTEM OPTION SET V0_2 ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$OldSystemReviewReportHash = Require-Hash -Path $OldSystemReviewReport -ExpectedSha256 "A572A9510D84402B285C3B6D7CEE74676F4CA315D6519323B8818300B400F571" -Name "old/system review dry-run V0_2 report"
$OldSystemReviewReceiptHash = Require-Hash -Path $OldSystemReviewReceipt -ExpectedSha256 "9138F329F22179CB95EEF0767B6EFDDB54FC38CA799B8D22D35193802D26B46D" -Name "old/system review dry-run V0_2 receipt"

$OldSystemFreezeHash = Require-Hash -Path $OldSystemFreeze -ExpectedSha256 "0EA466DC840BD32F49B4D632BCE3C0F683A402761CF2AD7011C0797764D900F9" -Name "old/system V0_1 failure freeze"
$OldSystemFixNoteHash = Require-Hash -Path $OldSystemFixNote -ExpectedSha256 "9468B560DB0CE77AC88F38391D41C9FE0EC2BC5524F576F6141EF1D628482DA9" -Name "old/system V0_2 fix note"
$OldSystemIncidentReceiptHash = Require-Hash -Path $OldSystemIncidentReceipt -ExpectedSha256 "9E14CD3C696A5A254AC227BBBCFCB83F8CC70E8064D92DBF214AA37AE0EF6F5D" -Name "old/system V0_2 incident receipt"

$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "root-drop washer review queue"
$QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "root-drop washer review queue receipt"

$SupportOptionSetHash = Require-Hash -Path $SupportOptionSet -ExpectedSha256 "77853EF98286012AD8D294966CBB367C729172E69D55E3EBA2874E72A725FD4C" -Name "support candidate option set V0_2"
$SupportOptionRoughHash = Require-Hash -Path $SupportOptionRough -ExpectedSha256 "6C649C373DBC910D5E6B4F7BFCB0393330FC042DE7692D8F844E2592F58816D9" -Name "support candidate rough_local V0_2"

$SourceOptionSetHash = Require-Hash -Path $SourceOptionSet -ExpectedSha256 "F1A44A706670489D5715B1726449C3D6DD8DB83DE6E497C5D73982CC40DF775F" -Name "source authority option set"
$SourceOptionRoughHash = Require-Hash -Path $SourceOptionRough -ExpectedSha256 "7BAE7F5EA6B1673BDFF91F13BE4981D26871E99B65C944E371D5E15220843FCA" -Name "source authority rough_local"

$HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper candidate option set"
$HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper candidate rough_local"

$WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

if (-not (Test-Path -LiteralPath $OldSystemCardsFolder -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_OLD_SYSTEM_REVIEW_CARDS_FOLDER" -Detail $OldSystemCardsFolder
}

$CardFiles = @(Get-ChildItem -LiteralPath $OldSystemCardsFolder -Force -File -Filter "*.md" | Sort-Object Name)
if ($CardFiles.Count -ne 2) {
    Write-BlockerAndExit -Reason "OLD_SYSTEM_REVIEW_CARD_COUNT_MISMATCH" -Detail "actual=$($CardFiles.Count) expected=2 folder=$OldSystemCardsFolder"
}

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV3
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV3
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$Items = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($card in $CardFiles) {
    $index += 1
    $text = Get-Content -LiteralPath $card.FullName -Raw
    $cardHash = (Get-FileHash -LiteralPath $card.FullName -Algorithm SHA256).Hash

    $observedPath = Get-Field -Text $text -FieldName "observed_path"
    $queueObservedSha = Get-Field -Text $text -FieldName "queue_observed_sha256"
    $currentSha = Get-Field -Text $text -FieldName "current_sha256"
    $queueObservedSize = Get-Field -Text $text -FieldName "queue_observed_size_bytes"
    $currentSize = Get-Field -Text $text -FieldName "current_size_bytes"
    $currentStatus = Get-Field -Text $text -FieldName "current_status"
    $oldSystemClass = Get-Field -Text $text -FieldName "old_system_class"
    $recommendedDisposition = Get-Field -Text $text -FieldName "recommended_disposition"
    $authorityBoundary = Get-Field -Text $text -FieldName "authority_boundary"
    $signals = Get-Field -Text $text -FieldName "old_system_signals"
    $cautions = Get-Field -Text $text -FieldName "cautions"

    if ([string]::IsNullOrWhiteSpace($observedPath)) {
        Write-BlockerAndExit -Reason "CARD_PARSE_FAILED" -Detail "Missing observed_path in $($card.FullName)"
    }

    $actualStatus = "MISSING_AT_OPTION_SET_TIME"
    $actualSha = "NOT_AVAILABLE_MISSING_AT_OPTION_SET_TIME"

    if (Test-Path -LiteralPath $observedPath -PathType Leaf) {
        $actualStatus = "PRESENT_AT_OPTION_SET_TIME"
        $actualSha = (Get-FileHash -LiteralPath $observedPath -Algorithm SHA256).Hash

        if ($currentSha -ne "NOT_AVAILABLE_MISSING_AT_REVIEW_TIME" -and $actualSha -ne $currentSha) {
            Write-BlockerAndExit -Reason "OLD_SYSTEM_CANDIDATE_HASH_DRIFT_AFTER_REVIEW" -Detail "path=$observedPath actual=$actualSha review_current=$currentSha"
        }
    }

    $option = "OPTION_KEEP_PENDING_MANUAL_REVIEW"
    $finalRecommendation = "Keep pending manual review. No cleanup authorized."
    $cleanupStatus = "NO_CLEANUP"

    if ($oldSystemClass -eq "WINDOWS_SYSTEM_METADATA_CANDIDATE" -or $oldSystemClass -eq "WINDOWS_SYSTEM_METADATA_MISSING_AT_REVIEW_TIME") {
        $option = "OPTION_IGNORE_OR_LEAVE_SYSTEM_METADATA_IN_PLACE"
        $finalRecommendation = "Ignore or leave in place pending system-file policy. Do not delete, recreate, route, or commit full file."
    }
    elseif ($oldSystemClass -eq "ZERO_BYTE_OLD_LOAD_CANDIDATE") {
        $option = "OPTION_KEEP_ZERO_BYTE_OLD_LOAD_PENDING_MANUAL_REVIEW"
        $finalRecommendation = "Keep pending manual review. Zero-byte does not mean safe to delete."
    }
    elseif ($oldSystemClass -eq "OLD_SYSTEM_CANDIDATE_MISSING_AT_REVIEW_TIME") {
        $option = "OPTION_RECORD_MISSING_AT_REVIEW_TIME_NO_ACTION"
        $finalRecommendation = "Record missing-at-review-time only. Do not restore, recreate, or infer cleanup."
    }
    elseif ($oldSystemClass -eq "NAMED_OLD_OR_TEMP_CANDIDATE" -or $oldSystemClass -eq "TEXTUAL_OLD_OR_PROOF_CANDIDATE") {
        $option = "OPTION_KEEP_PENDING_OLD_LOAD_REVIEW"
        $finalRecommendation = "Keep pending old-load review. Proof/history may still need preservation."
    }

    $Items.Add([pscustomobject]@{
        Index = $index
        ObservedPath = $observedPath
        QueueObservedSha = $queueObservedSha
        ReviewCurrentSha = $currentSha
        OptionSetCurrentSha = $actualSha
        QueueObservedSize = $queueObservedSize
        ReviewCurrentSize = $currentSize
        ReviewCurrentStatus = $currentStatus
        OptionSetCurrentStatus = $actualStatus
        OldSystemClass = $oldSystemClass
        RecommendedDisposition = $recommendedDisposition
        AuthorityBoundary = $authorityBoundary
        Option = $option
        FinalRecommendation = $finalRecommendation
        CleanupStatus = $cleanupStatus
        Signals = $signals
        Cautions = $cautions
        ReviewCardPath = $card.FullName
        ReviewCardSha256 = $cardHash
    })
}

$OptionGroups = $Items | Group-Object Option | Sort-Object Name
$OptionCountLines = @(
    foreach ($g in $OptionGroups) {
        "- $($g.Name): $($g.Count)"
    }
)

$ClassGroups = $Items | Group-Object OldSystemClass | Sort-Object Name
$ClassCountLines = @(
    foreach ($g in $ClassGroups) {
        "- $($g.Name): $($g.Count)"
    }
)

$ReviewStatusGroups = $Items | Group-Object ReviewCurrentStatus | Sort-Object Name
$ReviewStatusLines = @(
    foreach ($g in $ReviewStatusGroups) {
        "- $($g.Name): $($g.Count)"
    }
)

$OptionSetStatusGroups = $Items | Group-Object OptionSetCurrentStatus | Sort-Object Name
$OptionSetStatusLines = @(
    foreach ($g in $OptionSetStatusGroups) {
        "- $($g.Name): $($g.Count)"
    }
)

$SystemMetadataLines = @(
    foreach ($item in ($Items | Where-Object { $_.Option -eq "OPTION_IGNORE_OR_LEAVE_SYSTEM_METADATA_IN_PLACE" })) {
        "- $($item.ObservedPath)"
    }
)

$ZeroByteLines = @(
    foreach ($item in ($Items | Where-Object { $_.Option -eq "OPTION_KEEP_ZERO_BYTE_OLD_LOAD_PENDING_MANUAL_REVIEW" })) {
        "- $($item.ObservedPath)"
    }
)

if ($SystemMetadataLines.Count -eq 0) {
    $SystemMetadataLines = @("- NONE")
}

if ($ZeroByteLines.Count -eq 0) {
    $ZeroByteLines = @("- NONE")
}

$ItemBlocks = @(
    foreach ($item in $Items) {
        @"
## OLD_SYSTEM_OPTION_ITEM_$("{0:D2}" -f $item.Index)

observed_path:
$($item.ObservedPath)

queue_observed_sha256:
$($item.QueueObservedSha)

review_current_sha256:
$($item.ReviewCurrentSha)

option_set_current_sha256:
$($item.OptionSetCurrentSha)

review_current_status:
$($item.ReviewCurrentStatus)

option_set_current_status:
$($item.OptionSetCurrentStatus)

old_system_class:
$($item.OldSystemClass)

recommended_disposition_from_review:
$($item.RecommendedDisposition)

authority_boundary:
$($item.AuthorityBoundary)

option_bucket:
$($item.Option)

final_recommendation:
$($item.FinalRecommendation)

cleanup_status:
$($item.CleanupStatus)

old_system_signals:
$($item.Signals)

cautions:
$($item.Cautions)

review_card_path:
$($item.ReviewCardPath)

review_card_sha256:
$($item.ReviewCardSha256)

DoesNotProve:
This old/system option item does not prove the file is trash, stale, safe to delete, safe to restore, safe to move, safe to route, Git-safe as full content, doctrine, active guide, source authority, or project complete.

"@
    }
)

$OptionSetText = @"
# ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608

Status: OLD_LOAD_OR_SYSTEM_OPTION_SET / V0_2 / READ_ONLY / NO_CLEANUP / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Source old/system review report:
$OldSystemReviewReport

Source old/system review report SHA256:
$OldSystemReviewReportHash

Source old/system review receipt:
$OldSystemReviewReceipt

Source old/system review receipt SHA256:
$OldSystemReviewReceiptHash

Source old/system review cards folder:
$OldSystemCardsFolder

V0_1 failure freeze:
$OldSystemFreeze

V0_1 failure freeze SHA256:
$OldSystemFreezeHash

V0_2 fix note:
$OldSystemFixNote

V0_2 fix note SHA256:
$OldSystemFixNoteHash

Incident receipt:
$OldSystemIncidentReceipt

Incident receipt SHA256:
$OldSystemIncidentReceiptHash

Source queue:
$Queue

Source queue SHA256:
$QueueHash

Source queue receipt:
$QueueReceipt

Source queue receipt SHA256:
$QueueReceiptHash

Prior support option set SHA256:
$SupportOptionSetHash

Prior support rough_local SHA256:
$SupportOptionRoughHash

Prior source option set SHA256:
$SourceOptionSetHash

Prior source rough_local SHA256:
$SourceOptionRoughHash

Prior helper option set SHA256:
$HelperOptionSetHash

Prior helper rough_local SHA256:
$HelperOptionRoughHash

Washer schema SHA256:
$WasherSchemaHash

Purpose:
Condense the 2 old-load/system review cards into a small option set.

This option set does not cleanup, delete, restore, recreate, move, route, stage, commit, push, or rewrite anything.

## OPTION COUNTS

$($OptionCountLines -join "`r`n")

## OLD/SYSTEM CLASS COUNTS

$($ClassCountLines -join "`r`n")

## REVIEW CURRENT STATUS COUNTS

$($ReviewStatusLines -join "`r`n")

## OPTION-SET CURRENT STATUS COUNTS

$($OptionSetStatusLines -join "`r`n")

## SYSTEM METADATA / LEAVE IN PLACE

$($SystemMetadataLines -join "`r`n")

Boundary:
System metadata candidate does not mean trash. Leave or ignore pending system-file policy. No deletion, restoration, or recreation.

## ZERO-BYTE OLD LOAD / MANUAL REVIEW

$($ZeroByteLines -join "`r`n")

Boundary:
Zero-byte does not mean safe to delete. Keep pending manual review.

## OLD/SYSTEM OPTION ITEMS

$($ItemBlocks -join "`r`n")

## SELECTED RECOMMENDATION

Selected:
LEAVE_ALL_OLD_SYSTEM_CANDIDATES_IN_PLACE_WITH_NO_CLEANUP

Reason:
One item is Windows system metadata candidate and one item is zero-byte old-load candidate. Neither is deletion authority.

## STILL BLOCKED

- cleanup
- delete
- move
- rename
- route
- restore missing file
- recreate missing file
- classify as trash
- system-file deletion
- proof/history deletion
- stage full files
- commit full files
- push
- source rewrite
- current truth index rewrite

## NEXT RECOMMENDED BUILD CHUNK

ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608

Purpose:
Carry the old/system option set into Git as rough_local hash truth only.

Still blocked:
Full old/system file staging, cleanup, deletion, routing, mutation, restoration, recreation, and current truth rewrite.

## DOESNOTPROVE

This option set does not prove any old/system candidate is trash, stale, safe to delete, safe to restore, safe to move, safe to route, Git-safe as full content, doctrine, active guide, source authority, or project complete.

## FINAL RETURN FIELDS

option_set_path:
$OutputPath

option_set_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

old_system_review_report_sha256_confirmed:
$OldSystemReviewReportHash

old_system_review_receipt_sha256_confirmed:
$OldSystemReviewReceiptHash

v0_1_failure_freeze_sha256_confirmed:
$OldSystemFreezeHash

v0_2_fix_note_sha256_confirmed:
$OldSystemFixNoteHash

incident_receipt_sha256_confirmed:
$OldSystemIncidentReceiptHash

queue_sha256_confirmed:
$QueueHash

queue_receipt_sha256_confirmed:
$QueueReceiptHash

support_option_set_sha256_confirmed:
$SupportOptionSetHash

support_option_rough_local_sha256_confirmed:
$SupportOptionRoughHash

source_option_set_sha256_confirmed:
$SourceOptionSetHash

source_option_rough_local_sha256_confirmed:
$SourceOptionRoughHash

helper_option_set_sha256_confirmed:
$HelperOptionSetHash

helper_option_rough_local_sha256_confirmed:
$HelperOptionRoughHash

washer_schema_sha256_confirmed:
$WasherSchemaHash

old_system_candidates_reviewed:
$($Items.Count)

system_metadata_candidate_count:
$(($Items | Where-Object { $_.Option -eq "OPTION_IGNORE_OR_LEAVE_SYSTEM_METADATA_IN_PLACE" }).Count)

zero_byte_old_load_candidate_count:
$(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_ZERO_BYTE_OLD_LOAD_PENDING_MANUAL_REVIEW" }).Count)

selected_recommendation:
LEAVE_ALL_OLD_SYSTEM_CANDIDATES_IN_PLACE_WITH_NO_CLEANUP

cleanup_done:
NO

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

scripts_executed_count:
0

git_commit_or_push_done:
NO

next_build_chunk_selected:
ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $OptionSetText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_RECEIPT_V0_2_20260608
Created: $Timestamp

option_set_path: $OutputPath
option_set_sha256: $OutputHash

old_system_review_report_sha256: $OldSystemReviewReportHash
old_system_review_receipt_sha256: $OldSystemReviewReceiptHash
v0_1_failure_freeze_sha256: $OldSystemFreezeHash
v0_2_fix_note_sha256: $OldSystemFixNoteHash
incident_receipt_sha256: $OldSystemIncidentReceiptHash

queue_sha256: $QueueHash
queue_receipt_sha256: $QueueReceiptHash
support_option_set_sha256: $SupportOptionSetHash
support_option_rough_local_sha256: $SupportOptionRoughHash
source_option_set_sha256: $SourceOptionSetHash
source_option_rough_local_sha256: $SourceOptionRoughHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
washer_schema_sha256: $WasherSchemaHash

old_system_candidates_reviewed: $($Items.Count)
system_metadata_candidate_count: $(($Items | Where-Object { $_.Option -eq "OPTION_IGNORE_OR_LEAVE_SYSTEM_METADATA_IN_PLACE" }).Count)
zero_byte_old_load_candidate_count: $(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_ZERO_BYTE_OLD_LOAD_PENDING_MANUAL_REVIEW" }).Count)

selected_recommendation: LEAVE_ALL_OLD_SYSTEM_CANDIDATES_IN_PLACE_WITH_NO_CLEANUP
cleanup_done: NO

option_counts:
$($OptionCountLines -join "`r`n")

old_system_class_counts:
$($ClassCountLines -join "`r`n")

review_current_status_counts:
$($ReviewStatusLines -join "`r`n")

option_set_current_status_counts:
$($OptionSetStatusLines -join "`r`n")

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
scripts_executed_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$OptionSetText = $OptionSetText.Replace("option_set_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "option_set_sha256:`r`n$OutputHash")
$OptionSetText = $OptionSetText.Replace("option_set_sha256:`nTO_BE_FILLED_AFTER_CREATION", "option_set_sha256:`n$OutputHash")
$OptionSetText = $OptionSetText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$OptionSetText = $OptionSetText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $OptionSetText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER OLD LOAD OR SYSTEM OPTION SET V0_2 COMPLETE ==="
"option_set_path: $OutputPath"
"option_set_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"old_system_review_report_sha256_confirmed: $OldSystemReviewReportHash"
"old_system_review_receipt_sha256_confirmed: $OldSystemReviewReceiptHash"
"v0_1_failure_freeze_sha256_confirmed: $OldSystemFreezeHash"
"v0_2_fix_note_sha256_confirmed: $OldSystemFixNoteHash"
"incident_receipt_sha256_confirmed: $OldSystemIncidentReceiptHash"
"queue_sha256_confirmed: $QueueHash"
"queue_receipt_sha256_confirmed: $QueueReceiptHash"
"support_option_set_sha256_confirmed: $SupportOptionSetHash"
"support_option_rough_local_sha256_confirmed: $SupportOptionRoughHash"
"source_option_set_sha256_confirmed: $SourceOptionSetHash"
"source_option_rough_local_sha256_confirmed: $SourceOptionRoughHash"
"helper_option_set_sha256_confirmed: $HelperOptionSetHash"
"helper_option_rough_local_sha256_confirmed: $HelperOptionRoughHash"
"washer_schema_sha256_confirmed: $WasherSchemaHash"
"old_system_candidates_reviewed: $($Items.Count)"
"system_metadata_candidate_count: $(($Items | Where-Object { $_.Option -eq "OPTION_IGNORE_OR_LEAVE_SYSTEM_METADATA_IN_PLACE" }).Count)"
"zero_byte_old_load_candidate_count: $(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_ZERO_BYTE_OLD_LOAD_PENDING_MANUAL_REVIEW" }).Count)"
"selected_recommendation: LEAVE_ALL_OLD_SYSTEM_CANDIDATES_IN_PLACE_WITH_NO_CLEANUP"
"cleanup_done: NO"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_READY_WITH_SCOPE_LIMIT_NOTE"
