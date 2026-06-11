$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"

$SupportOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.md"
$SupportOptionSetReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$SupportOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"
$SupportOptionRoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_RECEIPT_20260608.txt"

$SourceOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SourceOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"

$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"

$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608.md"
$OutputV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_RECEIPT_V0_2_20260608.txt"
$CardsFolderBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_CARDS_20260608"
$CardsFolderV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_CARDS_V0_2_20260608"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the old/system queue failed. It proves this bounded old-load/system review runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER OLD LOAD OR SYSTEM REVIEW BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_NOT_COMPLETE"
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

function Choose-FolderPath {
    param(
        [string]$Base,
        [string]$Fallback
    )

    if (-not (Test-Path -LiteralPath $Base -PathType Container)) {
        return $Base
    }

    if (-not (Test-Path -LiteralPath $Fallback -PathType Container)) {
        return $Fallback
    }

    Write-BlockerAndExit -Reason "OUTPUT_FOLDER_COLLISION" -Detail "Both output folders already exist: $Base and $Fallback"
}

function Get-QueueItemBlocks {
    param([string]$Text)

    return [regex]::Matches($Text, '(?ms)^## QUEUE_ITEM_\d+\s*\r?\n.*?(?=^## QUEUE_ITEM_\d+\s*\r?\n|\z)')
}

function Get-Field {
    param(
        [string]$Text,
        [string]$FieldName
    )

    $escaped = [regex]::Escape($FieldName)
    $pattern = "(?ms)^$escaped\s*:\s*\r?\n(?<value>.*?)(?=\r?\n[A-Za-z0-9_ -]+:\s*\r?\n|\r?\nblocked_actions:|\r?\nDoesNotProve:|\z)"
    $m = [regex]::Match($Text, $pattern)
    if (-not $m.Success) {
        return ""
    }

    return $m.Groups["value"].Value.Trim()
}

function Get-SafeFileStem {
    param([string]$Name)

    $safe = [regex]::Replace($Name, '[^A-Za-z0-9._-]+', '_')
    if ($safe.Length -gt 90) {
        $safe = $safe.Substring(0, 90)
    }
    return $safe
}

function Classify-OldSystemCandidate {
    param(
        [System.IO.FileInfo]$File,
        [string]$Text
    )

    $name = $File.Name
    $class = "OLD_LOAD_OR_SYSTEM_CANDIDATE_NEEDS_REVIEW"
    $recommended = "KEEP_PENDING_OLD_LOAD_OR_SYSTEM_REVIEW"
    $boundary = "NO_CLEANUP_AUTHORITY"
    $signals = New-Object System.Collections.Generic.List[string]
    $cautions = New-Object System.Collections.Generic.List[string]

    if ($name -eq "desktop.ini") {
        $class = "WINDOWS_SYSTEM_METADATA_CANDIDATE"
        $recommended = "IGNORE_OR_LEAVE_IN_PLACE_PENDING_SYSTEM_FILE_POLICY"
        $signals.Add("Name is desktop.ini, a common Windows folder metadata file.")
        $cautions.Add("Do not delete by project cleanup logic without explicit system-file policy.")
    }
    elseif ($File.Length -eq 0) {
        $class = "ZERO_BYTE_OLD_LOAD_CANDIDATE"
        $recommended = "KEEP_PENDING_MANUAL_REVIEW"
        $signals.Add("File is zero bytes.")
        $cautions.Add("Zero bytes does not prove safe to delete.")
    }
    elseif ($name -match 'OLD|STALE|BACKUP|COPY|TEMP|TMP|draft|DRAFT') {
        $class = "NAMED_OLD_OR_TEMP_CANDIDATE"
        $recommended = "KEEP_PENDING_OLD_LOAD_REVIEW"
        $signals.Add("Name carries old/stale/backup/copy/temp/draft signal.")
        $cautions.Add("Name signal is not deletion authority.")
    }
    elseif ($Text -match 'old load|OLD_LOAD|stale|superseded|DoesNotProve|receipt|hash') {
        $class = "TEXTUAL_OLD_OR_PROOF_CANDIDATE"
        $recommended = "KEEP_PENDING_MANUAL_REVIEW"
        $signals.Add("Content carries old/proof/hash/DoesNotProve vocabulary.")
        $cautions.Add("Proof/history files may be preserved even when not active authority.")
    }
    else {
        $signals.Add("No decisive system/old-load signal found by bounded dry-run.")
        $cautions.Add("Needs manual review. No cleanup authorized.")
    }

    return [pscustomobject]@{
        OldSystemClass = $class
        RecommendedDisposition = $recommended
        AuthorityBoundary = $boundary
        Signals = ($signals -join " ")
        Cautions = ($cautions -join " ")
    }
}

"=== ROOT DROP INTAKE WASHER OLD LOAD OR SYSTEM REVIEW DRY-RUN ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "review queue"
$QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "review queue receipt"

$SupportOptionSetHash = Require-Hash -Path $SupportOptionSet -ExpectedSha256 "77853EF98286012AD8D294966CBB367C729172E69D55E3EBA2874E72A725FD4C" -Name "support option set V0_2"
$SupportOptionSetReceiptHash = Require-Hash -Path $SupportOptionSetReceipt -ExpectedSha256 "D3219945274CE514594A5F322A14E43AAC350E0A51D3FB978393D305463A16BF" -Name "support option set V0_2 receipt"
$SupportOptionRoughHash = Require-Hash -Path $SupportOptionRough -ExpectedSha256 "6C649C373DBC910D5E6B4F7BFCB0393330FC042DE7692D8F844E2592F58816D9" -Name "support option set V0_2 rough_local ledger"
$SupportOptionRoughReceiptHash = Require-Hash -Path $SupportOptionRoughReceipt -ExpectedSha256 "DE2D9045123E6431FCD048C4DB6700BF93369EB604D674959C89BBE6B7CFFAD6" -Name "support option set V0_2 rough_local receipt"

$SourceOptionSetHash = Require-Hash -Path $SourceOptionSet -ExpectedSha256 "F1A44A706670489D5715B1726449C3D6DD8DB83DE6E497C5D73982CC40DF775F" -Name "source option set"
$SourceOptionRoughHash = Require-Hash -Path $SourceOptionRough -ExpectedSha256 "7BAE7F5EA6B1673BDFF91F13BE4981D26871E99B65C944E371D5E15220843FCA" -Name "source option rough_local"

$HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper option set"
$HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper option rough_local"

$WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$CardsFolder = Choose-FolderPath -Base $CardsFolderBase -Fallback $CardsFolderV2
New-Item -ItemType Directory -Path $CardsFolder -Force | Out-Null

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$QueueText = Get-Content -LiteralPath $Queue -Raw
$Blocks = Get-QueueItemBlocks -Text $QueueText
$OldSystemItems = New-Object System.Collections.Generic.List[object]

foreach ($m in $Blocks) {
    $block = $m.Value
    $bucket = Get-Field -Text $block -FieldName "queue_bucket"
    if ($bucket -ne "OLD_LOAD_OR_SYSTEM_REVIEW") {
        continue
    }

    $observedPath = Get-Field -Text $block -FieldName "observed_path"
    $observedSha = Get-Field -Text $block -FieldName "observed_sha256"
    $observedSize = Get-Field -Text $block -FieldName "observed_size_bytes"
    $candidateRole = Get-Field -Text $block -FieldName "candidate_role"
    $authorityState = Get-Field -Text $block -FieldName "authority_state"
    $suggestedRoute = Get-Field -Text $block -FieldName "suggested_route"
    $decision = Get-Field -Text $block -FieldName "next_human_decision"
    $sourceCardPath = Get-Field -Text $block -FieldName "source_card_path"
    $sourceCardSha = Get-Field -Text $block -FieldName "source_card_sha256"

    if (-not (Test-Path -LiteralPath $observedPath -PathType Leaf)) {
        Write-BlockerAndExit -Reason "OLD_SYSTEM_CANDIDATE_MISSING" -Detail $observedPath
    }

    $actualSha = (Get-FileHash -LiteralPath $observedPath -Algorithm SHA256).Hash
    if ($actualSha -ne $observedSha) {
        Write-BlockerAndExit -Reason "OLD_SYSTEM_CANDIDATE_HASH_DRIFT" -Detail "path=$observedPath actual=$actualSha expected=$observedSha"
    }

    $fileInfo = Get-Item -LiteralPath $observedPath
    $content = ""
    try {
        $content = Get-Content -LiteralPath $observedPath -Raw -ErrorAction Stop
    }
    catch {
        $content = ""
    }

    $class = Classify-OldSystemCandidate -File $fileInfo -Text $content

    $OldSystemItems.Add([pscustomobject]@{
        ObservedPath = $observedPath
        ObservedSha = $actualSha
        ObservedSize = $observedSize
        CandidateRole = $candidateRole
        AuthorityState = $authorityState
        SuggestedRoute = $suggestedRoute
        Decision = $decision
        SourceCardPath = $sourceCardPath
        SourceCardSha = $sourceCardSha
        OldSystemClass = $class.OldSystemClass
        RecommendedDisposition = $class.RecommendedDisposition
        AuthorityBoundary = $class.AuthorityBoundary
        Signals = $class.Signals
        Cautions = $class.Cautions
    })
}

if ($OldSystemItems.Count -ne 2) {
    Write-BlockerAndExit -Reason "OLD_SYSTEM_CANDIDATE_COUNT_MISMATCH" -Detail "actual=$($OldSystemItems.Count) expected=2"
}

$ReviewCards = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($item in $OldSystemItems) {
    $index += 1
    $safeStem = Get-SafeFileStem -Name ([System.IO.Path]::GetFileName($item.ObservedPath))
    $cardPath = Join-Path $CardsFolder ("OLD_SYSTEM_REVIEW_CARD_{0:D2}__{1}.md" -f $index, $safeStem)

    $CardText = @"
# ROOT_DROP_INTAKE_WASHER_OLD_SYSTEM_REVIEW_CARD_$("{0:D2}" -f $index)

Status: OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN / READ_ONLY / NO_CLEANUP / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

observed_path:
$($item.ObservedPath)

observed_sha256:
$($item.ObservedSha)

observed_size_bytes:
$($item.ObservedSize)

queue_candidate_role:
$($item.CandidateRole)

queue_authority_state:
$($item.AuthorityState)

queue_suggested_route:
$($item.SuggestedRoute)

queue_next_human_decision:
$($item.Decision)

source_card_path:
$($item.SourceCardPath)

source_card_sha256:
$($item.SourceCardSha)

old_system_class:
$($item.OldSystemClass)

recommended_disposition:
$($item.RecommendedDisposition)

authority_boundary:
$($item.AuthorityBoundary)

old_system_signals:
$($item.Signals)

cautions:
$($item.Cautions)

blocked_actions:
- cleanup
- delete
- move
- rename
- route
- stage full file
- commit full file
- push
- classify as trash
- system-file deletion
- proof/history deletion
- source rewrite
- current truth index rewrite

proof_need:
- explicit user approval before cleanup
- cleanup executor separate from washer
- before/after receipt for any future mutation
- system-file policy for system metadata
- old-load policy for stale/proof/history files
- rough_local pointer if Git needs trace

DoesNotProve:
This old/system review card does not prove the file is trash, stale, safe to delete, safe to move, safe to route, Git-safe as full content, doctrine, active guide, source authority, or project complete.
"@

    Write-TextFile -Path $cardPath -Text $CardText
    $cardHash = (Get-FileHash -LiteralPath $cardPath -Algorithm SHA256).Hash

    $ReviewCards.Add([pscustomobject]@{
        Index = $index
        ObservedPath = $item.ObservedPath
        ObservedSha = $item.ObservedSha
        OldSystemClass = $item.OldSystemClass
        RecommendedDisposition = $item.RecommendedDisposition
        AuthorityBoundary = $item.AuthorityBoundary
        ReviewCardPath = $cardPath
        ReviewCardSha256 = $cardHash
    })
}

$ClassGroups = $ReviewCards | Group-Object OldSystemClass | Sort-Object Name
$ClassLines = @(
    foreach ($g in $ClassGroups) {
        "- $($g.Name): $($g.Count)"
    }
)

$DispositionGroups = $ReviewCards | Group-Object RecommendedDisposition | Sort-Object Name
$DispositionLines = @(
    foreach ($g in $DispositionGroups) {
        "- $($g.Name): $($g.Count)"
    }
)

$CardSummary = @(
    foreach ($card in $ReviewCards) {
        @"
## OLD_SYSTEM_ITEM_$("{0:D2}" -f $card.Index)

observed_path:
$($card.ObservedPath)

observed_sha256:
$($card.ObservedSha)

old_system_class:
$($card.OldSystemClass)

recommended_disposition:
$($card.RecommendedDisposition)

authority_boundary:
$($card.AuthorityBoundary)

review_card_path:
$($card.ReviewCardPath)

review_card_sha256:
$($card.ReviewCardSha256)

"@
    }
)

$ReportText = @"
# ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608

Status: OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN / READ_ONLY / NO_CLEANUP / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

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

Prior support option set:
$SupportOptionSet

Prior support option set SHA256:
$SupportOptionSetHash

Prior support option set receipt:
$SupportOptionSetReceipt

Prior support option set receipt SHA256:
$SupportOptionSetReceiptHash

Prior support option rough_local ledger:
$SupportOptionRough

Prior support option rough_local ledger SHA256:
$SupportOptionRoughHash

Prior support option rough_local receipt:
$SupportOptionRoughReceipt

Prior support option rough_local receipt SHA256:
$SupportOptionRoughReceiptHash

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
Review the 2 old-load/system candidates from the root-drop washer queue without cleaning, deleting, moving, routing, staging, committing, pushing, or rewriting anything.

Old/system candidates reviewed:
$($ReviewCards.Count)

Review cards folder:
$CardsFolder

## OLD/SYSTEM CLASS COUNTS

$($ClassLines -join "`r`n")

## RECOMMENDED DISPOSITION COUNTS

$($DispositionLines -join "`r`n")

## REVIEW ITEMS

$($CardSummary -join "`r`n")

## INTERPRETATION

The washer has reached the final queue bucket: old-load/system review.

This bucket is high-risk for accidental cleanup because "old/system" can look disposable. This dry-run deliberately does not delete anything.

## RECOMMENDED NEXT MOVE

ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_20260608

Purpose:
Create a small option set for the 2 old/system candidates:
- leave in place
- ignore/system metadata
- old-load review later
- rough_local pointer only
- defer

Still read-only. No cleanup. No routing. No Git.

## STILL BLOCKED

- cleanup
- delete
- move
- rename
- route
- stage full files
- commit full files
- push
- classify as trash
- system-file deletion
- proof/history deletion
- source rewrite
- current truth index rewrite

## DOESNOTPROVE

This dry run does not prove any old/system candidate is trash, stale, safe to delete, safe to move, safe to route, Git-safe as full content, doctrine, active guide, source authority, or project complete.

## FINAL RETURN FIELDS

output_report_path:
$OutputPath

output_report_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

review_cards_folder:
$CardsFolder

old_system_candidates_reviewed:
$($ReviewCards.Count)

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
ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_RECEIPT_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

review_cards_folder: $CardsFolder
old_system_candidates_reviewed: $($ReviewCards.Count)

queue_sha256: $QueueHash
queue_receipt_sha256: $QueueReceiptHash
support_option_set_sha256: $SupportOptionSetHash
support_option_set_receipt_sha256: $SupportOptionSetReceiptHash
support_option_rough_local_sha256: $SupportOptionRoughHash
support_option_rough_local_receipt_sha256: $SupportOptionRoughReceiptHash
source_option_set_sha256: $SourceOptionSetHash
source_option_rough_local_sha256: $SourceOptionRoughHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
washer_schema_sha256: $WasherSchemaHash

old_system_class_counts:
$($ClassLines -join "`r`n")

recommended_disposition_counts:
$($DispositionLines -join "`r`n")

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
scripts_executed_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER OLD LOAD OR SYSTEM REVIEW DRY-RUN COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"review_cards_folder: $CardsFolder"
"old_system_candidates_reviewed: $($ReviewCards.Count)"
"queue_sha256_confirmed: $QueueHash"
"queue_receipt_sha256_confirmed: $QueueReceiptHash"
"support_option_set_sha256_confirmed: $SupportOptionSetHash"
"support_option_rough_local_sha256_confirmed: $SupportOptionRoughHash"
"source_option_set_sha256_confirmed: $SourceOptionSetHash"
"source_option_rough_local_sha256_confirmed: $SourceOptionRoughHash"
"helper_option_set_sha256_confirmed: $HelperOptionSetHash"
"helper_option_rough_local_sha256_confirmed: $HelperOptionRoughHash"
"washer_schema_sha256_confirmed: $WasherSchemaHash"
"old_system_class_counts:"
$ClassLines
"recommended_disposition_counts:"
$DispositionLines
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE"
