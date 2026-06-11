$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$SourceReviewReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$SourceReviewReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$SourceReviewCard = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_CARD_20260608.md"
$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$SourceCandidate = Join-Path $ProjectRoot "PLANETARY_HOUSE_GATE_MASTER_INDEX_WITH_INTAKE_TOOLBELT_V0_3_RAW_COMBINED_WITH_GUARD_MEMBRANE_20260607.md"
$KnownActiveSourceHash = "7F7B61C0915966EA3222587BA97B1ED8BCC47FC62739526B0542C557DA3156F7"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$OutputV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_V0_2_20260608.txt"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the source candidate is invalid. It proves this bounded source-authority option-set runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER SOURCE AUTHORITY OPTION SET BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_NOT_COMPLETE"
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

"=== ROOT DROP INTAKE WASHER SOURCE AUTHORITY CANDIDATE OPTION SET ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$SourceReviewReportHash = Require-Hash -Path $SourceReviewReport -ExpectedSha256 "D3813D05C3B9E1969F0A83FF84D528441E91A1430551E490D0194816FCA1D5D6" -Name "source authority candidate review dry-run report"
$SourceReviewReceiptHash = Require-Hash -Path $SourceReviewReceipt -ExpectedSha256 "238E07D63A1A37C026EA5B932A4B5F8AF7B8878CAC22A9A86CF0038300CE9B36" -Name "source authority candidate review dry-run receipt"
$SourceReviewCardHash = Require-Hash -Path $SourceReviewCard -ExpectedSha256 "C1961F1D3357218A2FB8D474C19F5E4489BDBFE1F16CA86F9FD0C7F244813F11" -Name "source authority candidate review card"
$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "root-drop washer review queue"
$HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper candidate option set"
$HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper candidate option rough_local ledger"
$WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"
$SourceCandidateHash = Require-Hash -Path $SourceCandidate -ExpectedSha256 $KnownActiveSourceHash -Name "known active source candidate"

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$MatchesKnownActive = ($SourceCandidateHash -eq $KnownActiveSourceHash)
$RecommendedOption = "OPTION_A_CONFIRM_EXISTING_ACTIVE_SOURCE_CUSTODY_WITH_NO_REWRITE"

$OptionSetText = @"
# ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608

Status: SOURCE_AUTHORITY_CANDIDATE_OPTION_SET / READ_ONLY / NO_PROMOTION_BY_THIS_FILE / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Source authority candidate:
$SourceCandidate

Source authority candidate SHA256:
$SourceCandidateHash

Known active source hash:
$KnownActiveSourceHash

Matches known active source hash:
$MatchesKnownActive

Source review report:
$SourceReviewReport

Source review report SHA256:
$SourceReviewReportHash

Source review receipt:
$SourceReviewReceipt

Source review receipt SHA256:
$SourceReviewReceiptHash

Source review card:
$SourceReviewCard

Source review card SHA256:
$SourceReviewCardHash

Root-drop washer review queue:
$Queue

Root-drop washer review queue SHA256:
$QueueHash

Helper candidate option set:
$HelperOptionSet

Helper candidate option set SHA256:
$HelperOptionSetHash

Helper candidate rough_local ledger:
$HelperOptionRough

Helper candidate rough_local ledger SHA256:
$HelperOptionRoughHash

Washer schema:
$WasherSchema

Washer schema SHA256:
$WasherSchemaHash

Purpose:
Condense the single source-authority candidate review into a small option set without changing source authority.

## OPTION SET

### OPTION A — CONFIRM EXISTING ACTIVE SOURCE CUSTODY WITH NO REWRITE

Meaning:
The candidate hash matches the known active source hash already carried by this lane.

Use when:
The goal is to record that the washer found the known active source object and did not create a new authority.

Allowed:
Record custody, cite hash, preserve source path.

Blocked:
No rewrite, no promotion event, no move, no Git full-content import, no source mutation.

Recommendation:
SELECTED.

### OPTION B — KEEP AS SOURCE CANDIDATE ONLY

Meaning:
Treat it as a source candidate but do not confirm current active custody.

Use when:
The user wants another explicit source review before confirming lane authority.

Allowed:
Park as candidate.

Blocked:
Do not use as current authority until confirmed.

Recommendation:
Not selected because hash matches known active source hash.

### OPTION C — PARK AS OLD/STALE SOURCE CANDIDATE

Meaning:
Treat the source-looking file as old or stale.

Use when:
Hash mismatch, wrong lane, or superseded source proof appears.

Allowed:
Mark as stale candidate only.

Blocked:
No delete or cleanup.

Recommendation:
Not selected because hash matches known active source hash.

### OPTION D — ROUGH_LOCAL HASH POINTER ONLY

Meaning:
Git receives only a rough_local pointer record, not the full source object.

Use when:
We need durable Git trace but do not want to stage full source content.

Allowed:
Rough_local ledger and import receipt.

Blocked:
Full source file import unless explicitly approved.

Recommendation:
Useful as next Git-safe pointer.

### OPTION E — DEFER

Meaning:
Do nothing else now.

Use when:
User wants to pause before recording more hash pointers.

Allowed:
Stop here.

Blocked:
Everything else remains blocked.

## SELECTED RECOMMENDATION

$RecommendedOption

Reason:
The source candidate hash equals the known active source hash. The correct move is to confirm existing custody, not create new authority and not rewrite source.

## AUTHORITY RESULT

source_authority_status:
MATCHES_KNOWN_ACTIVE_SOURCE_HASH

source_authority_action:
CONFIRM_EXISTING_CUSTODY_ONLY

source_promotion_done:
NO

source_rewrite_done:
NO

current_truth_index_rewrite_done:
NO

## STILL BLOCKED

- promote source by location alone
- promote source by name alone
- move
- delete
- rename
- route
- cleanup
- stage full source file
- commit full source file
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

## NEXT RECOMMENDED BUILD CHUNK

ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608

Purpose:
Carry this source-authority candidate option set into Git as rough_local hash truth only.

Still blocked:
Full source file staging, source mutation, cleanup, routing, and current truth rewrite.

## DOESNOTPROVE

This option set does not prove the source object is complete, correct, doctrine, active guide, safe to move, safe to route, safe to clean, Git-safe as full content, or project complete. It only records that the reviewed candidate matches the known active source hash and should be treated as existing custody, not new promotion.

## FINAL RETURN FIELDS

option_set_path:
$OutputPath

option_set_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

source_candidate_path:
$SourceCandidate

source_candidate_sha256:
$SourceCandidateHash

known_active_source_hash:
$KnownActiveSourceHash

matches_known_active_source_hash:
$MatchesKnownActive

source_review_report_sha256_confirmed:
$SourceReviewReportHash

source_review_receipt_sha256_confirmed:
$SourceReviewReceiptHash

source_review_card_sha256_confirmed:
$SourceReviewCardHash

queue_sha256_confirmed:
$QueueHash

helper_option_set_sha256_confirmed:
$HelperOptionSetHash

helper_option_rough_local_sha256_confirmed:
$HelperOptionRoughHash

washer_schema_sha256_confirmed:
$WasherSchemaHash

selected_recommendation:
$RecommendedOption

source_promotion_done:
NO

source_rewrite_done:
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
ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $OptionSetText
$OptionSetHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_20260608
Created: $Timestamp

option_set_path: $OutputPath
option_set_sha256: $OptionSetHash

source_candidate_path: $SourceCandidate
source_candidate_sha256: $SourceCandidateHash
known_active_source_hash: $KnownActiveSourceHash
matches_known_active_source_hash: $MatchesKnownActive

source_review_report_sha256: $SourceReviewReportHash
source_review_receipt_sha256: $SourceReviewReceiptHash
source_review_card_sha256: $SourceReviewCardHash
queue_sha256: $QueueHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
washer_schema_sha256: $WasherSchemaHash

selected_recommendation: $RecommendedOption
source_promotion_done: NO
source_rewrite_done: NO

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
scripts_executed_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$OptionSetText = $OptionSetText.Replace("option_set_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "option_set_sha256:`r`n$OptionSetHash")
$OptionSetText = $OptionSetText.Replace("option_set_sha256:`nTO_BE_FILLED_AFTER_CREATION", "option_set_sha256:`n$OptionSetHash")
$OptionSetText = $OptionSetText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$OptionSetText = $OptionSetText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $OptionSetText

$FinalOptionSetHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER SOURCE AUTHORITY CANDIDATE OPTION SET COMPLETE ==="
"option_set_path: $OutputPath"
"option_set_sha256: $FinalOptionSetHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"source_candidate_path: $SourceCandidate"
"source_candidate_sha256: $SourceCandidateHash"
"known_active_source_hash: $KnownActiveSourceHash"
"matches_known_active_source_hash: $MatchesKnownActive"
"source_review_report_sha256_confirmed: $SourceReviewReportHash"
"source_review_receipt_sha256_confirmed: $SourceReviewReceiptHash"
"source_review_card_sha256_confirmed: $SourceReviewCardHash"
"queue_sha256_confirmed: $QueueHash"
"helper_option_set_sha256_confirmed: $HelperOptionSetHash"
"helper_option_rough_local_sha256_confirmed: $HelperOptionRoughHash"
"washer_schema_sha256_confirmed: $WasherSchemaHash"
"selected_recommendation: $RecommendedOption"
"source_promotion_done: NO"
"source_rewrite_done: NO"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_READY_WITH_SCOPE_LIMIT_NOTE"
