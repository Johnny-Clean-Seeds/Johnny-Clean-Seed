$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$FailedRunnerPath = "$env:USERPROFILE\Downloads\BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.ps1"
$ThisRunnerPath = "$env:USERPROFILE\Downloads\BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.ps1"

$IncidentDir = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE__20260608"

$SupportReviewReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$SupportReviewReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$SupportReviewCardsFolder = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_CARDS_20260608"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"

$SourceOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SourceOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"

$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"

$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.md"
$OutputV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_RECEIPT_V0_2_20260608.txt"

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

function Copy-FileIfPresent {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (Test-Path -LiteralPath $Source -PathType Leaf) {
        Ensure-ParentFolder -Path $Destination
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        return (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash
    }

    return "MISSING_SOURCE_COPY"
}

function Write-BlockerAndExit {
    param(
        [string]$Reason,
        [string]$Detail
    )

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the support candidate review failed. It proves this bounded support-candidate option-set V0_2 runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER SUPPORT CANDIDATE OPTION SET V0_2 BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_NOT_COMPLETE"
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

function Write-FailureFreeze {
    param(
        [string]$FailedRunnerCopyHash,
        [string]$FixedRunnerCopyHash
    )

    New-Item -ItemType Directory -Path $IncidentDir -Force | Out-Null
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $FreezePath = Join-Path $IncidentDir "ERROR_FREEZE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE_20260608.md"
    $FixPath = Join-Path $IncidentDir "FIX_NOTE__SUPPORT_OPTION_SET_V0_2_ARRAY_WRAP_20260608.md"
    $ReceiptPath = Join-Path $IncidentDir "HASH_RECEIPT__SUPPORT_OPTION_SET_V0_2_FIX_20260608.txt"

    $FreezeText = @"
# ERROR_FREEZE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE_20260608

Status: ERROR_FREEZE / GENERATED_RUNNER_DEFECT_FAMILY / SUPPORT_OPTION_SET_V0_1_FAILED

Created: $Timestamp

Failed command:
pwsh -NoProfile -ExecutionPolicy Bypass -File `$ScriptPath

Failed runner:
$FailedRunnerPath

Reported error:
ParentContainsErrorRecordException: C:\Users\13527\Downloads\BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.ps1:254

Line:
if (`$GuardrailLines.Count -eq 0) {

Error text:
The property 'Count' cannot be found on this object. Verify that the property exists.

Working root:
$ProjectRoot

Lane:
$Lane

Suspected cause:
A PowerShell foreach expression assigned to `$GuardrailLines returned a scalar string when only one support guardrail line existed. Under StrictMode Latest, `.Count` on that scalar string failed. This is a generated-runner robustness defect, not a washer support-candidate failure.

Blocked actions:
- do not claim support option set complete from V0_1
- do not re-run V0_1
- do not promote support candidates
- do not move files
- do not delete files
- do not route files
- do not stage full support files
- do not commit full support files

Failed runner copy SHA256:
$FailedRunnerCopyHash

Fixed runner copy SHA256:
$FixedRunnerCopyHash

DoesNotProve:
This freeze does not prove the support candidates are invalid. It proves V0_1 failed on scalar `.Count` handling and required V0_2 repair.
"@

    Write-TextFile -Path $FreezePath -Text $FreezeText
    $FreezeHash = (Get-FileHash -LiteralPath $FreezePath -Algorithm SHA256).Hash

    $FixText = @"
# FIX_NOTE__SUPPORT_OPTION_SET_V0_2_ARRAY_WRAP_20260608

Status: FIX_NOTE / V0_2_REPAIR / ARRAY_COUNT_SAFE / PARENT_FIRST_WRITE

Created: $Timestamp

Fix:
V0_2 wraps filtered line collections in array subexpressions before counting:
`$GuardrailLines = @(...)
`$PendingLines = @(...)

Reason:
PowerShell can collapse a single-item pipeline result into a scalar. In StrictMode Latest, `.Count` may fail on that scalar. Array wrapping preserves count behavior for zero, one, or many items.

Additional boundary:
V0_2 also freezes the V0_1 error and copies the failed/fixed runners into the incident folder when available.

No scope change:
- still read-only
- no promotion
- no moves
- no cleanup
- no routing
- no Git
- no script execution beyond this bounded runner

Freeze hash:
$FreezeHash

Failed runner copy SHA256:
$FailedRunnerCopyHash

Fixed runner copy SHA256:
$FixedRunnerCopyHash

DoesNotProve:
This fix note does not prove support candidates are active support, doctrine, active guide, executor authority, cleanup authority, routing authority, or project complete.
"@

    Write-TextFile -Path $FixPath -Text $FixText
    $FixHash = (Get-FileHash -LiteralPath $FixPath -Algorithm SHA256).Hash

    $ReceiptText = @"
HASH_RECEIPT__SUPPORT_OPTION_SET_V0_2_FIX_20260608
Created: $Timestamp

freeze_path: $FreezePath
freeze_sha256: $FreezeHash

fix_note_path: $FixPath
fix_note_sha256: $FixHash

failed_runner_copy_sha256: $FailedRunnerCopyHash
fixed_runner_copy_sha256: $FixedRunnerCopyHash

final_verdict: SUPPORT_OPTION_SET_V0_1_FAILURE_FROZEN_AND_V0_2_FIX_READY
"@

    Write-TextFile -Path $ReceiptPath -Text $ReceiptText
    $ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

    return [pscustomobject]@{
        FreezePath = $FreezePath
        FreezeHash = $FreezeHash
        FixPath = $FixPath
        FixHash = $FixHash
        IncidentReceiptPath = $ReceiptPath
        IncidentReceiptHash = $ReceiptHash
    }
}

"=== ROOT DROP INTAKE WASHER SUPPORT CANDIDATE OPTION SET V0_2 ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

New-Item -ItemType Directory -Path $IncidentDir -Force | Out-Null

$FailedRunnerCopy = Join-Path $IncidentDir "FAILED_RUNNER_COPY__BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.ps1"
$FixedRunnerCopy = Join-Path $IncidentDir "FIXED_RUNNER_COPY__BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.ps1"

$FailedRunnerCopyHash = Copy-FileIfPresent -Source $FailedRunnerPath -Destination $FailedRunnerCopy
$FixedRunnerCopyHash = Copy-FileIfPresent -Source $ThisRunnerPath -Destination $FixedRunnerCopy
$Freeze = Write-FailureFreeze -FailedRunnerCopyHash $FailedRunnerCopyHash -FixedRunnerCopyHash $FixedRunnerCopyHash

$SupportReviewReportHash = Require-Hash -Path $SupportReviewReport -ExpectedSha256 "56BC9E4F1720DA4CE8A1A0E0A976C2AA774AB45767F9B02F03E73E3C324EAFDB" -Name "support candidate review dry-run report"
$SupportReviewReceiptHash = Require-Hash -Path $SupportReviewReceipt -ExpectedSha256 "946E0E16805091DF846D6F2273CAAE5DA79585B4D18F30ECD541435D73EC07D3" -Name "support candidate review dry-run receipt"

$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "root-drop washer review queue"
$QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "root-drop washer review queue receipt"

$SourceOptionSetHash = Require-Hash -Path $SourceOptionSet -ExpectedSha256 "F1A44A706670489D5715B1726449C3D6DD8DB83DE6E497C5D73982CC40DF775F" -Name "source authority candidate option set"
$SourceOptionRoughHash = Require-Hash -Path $SourceOptionRough -ExpectedSha256 "7BAE7F5EA6B1673BDFF91F13BE4981D26871E99B65C944E371D5E15220843FCA" -Name "source authority candidate rough_local ledger"

$HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper candidate option set"
$HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper candidate rough_local ledger"

$WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

if (-not (Test-Path -LiteralPath $SupportReviewCardsFolder -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_SUPPORT_REVIEW_CARDS_FOLDER" -Detail $SupportReviewCardsFolder
}

$CardFiles = @(Get-ChildItem -LiteralPath $SupportReviewCardsFolder -Force -File -Filter "*.md" | Sort-Object Name)
if ($CardFiles.Count -ne 2) {
    Write-BlockerAndExit -Reason "SUPPORT_REVIEW_CARD_COUNT_MISMATCH" -Detail "actual=$($CardFiles.Count) expected=2 folder=$SupportReviewCardsFolder"
}

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$Items = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($card in $CardFiles) {
    $index += 1
    $text = Get-Content -LiteralPath $card.FullName -Raw
    $cardHash = (Get-FileHash -LiteralPath $card.FullName -Algorithm SHA256).Hash

    $observedPath = Get-Field -Text $text -FieldName "observed_path"
    $observedSha = Get-Field -Text $text -FieldName "observed_sha256"
    $observedSize = Get-Field -Text $text -FieldName "observed_size_bytes"
    $supportClass = Get-Field -Text $text -FieldName "support_class"
    $recommendedDisposition = Get-Field -Text $text -FieldName "recommended_disposition"
    $authorityBoundary = Get-Field -Text $text -FieldName "authority_boundary"
    $signals = Get-Field -Text $text -FieldName "support_signals"
    $cautions = Get-Field -Text $text -FieldName "cautions"

    if ([string]::IsNullOrWhiteSpace($observedPath)) {
        Write-BlockerAndExit -Reason "CARD_PARSE_FAILED" -Detail "Missing observed_path in $($card.FullName)"
    }

    if (-not (Test-Path -LiteralPath $observedPath -PathType Leaf)) {
        Write-BlockerAndExit -Reason "OBSERVED_SUPPORT_CANDIDATE_MISSING" -Detail $observedPath
    }

    $actualHash = (Get-FileHash -LiteralPath $observedPath -Algorithm SHA256).Hash
    if ($actualHash -ne $observedSha) {
        Write-BlockerAndExit -Reason "OBSERVED_SUPPORT_CANDIDATE_HASH_DRIFT" -Detail "path=$observedPath actual=$actualHash expected=$observedSha"
    }

    $option = "OPTION_KEEP_AS_SUPPORT_CANDIDATE_PENDING_REVIEW"
    $finalRecommendation = "Keep as support candidate pending manual review. Do not promote."
    $promotionStatus = "NO_PROMOTION"

    if ($supportClass -eq "SUPPORT_GUARDRAIL_CANDIDATE" -or $recommendedDisposition -eq "KEEP_AS_SUPPORT_GUARDRAIL_CANDIDATE") {
        $option = "OPTION_KEEP_AS_SUPPORT_GUARDRAIL_CANDIDATE"
        $finalRecommendation = "Keep as support guardrail candidate. Still not doctrine, active guide, executor, cleanup authority, or routing authority."
    }
    elseif ($supportClass -eq "SUPPORT_CANDIDATE_NEEDS_REVIEW" -or $recommendedDisposition -eq "KEEP_AS_SUPPORT_CANDIDATE_PENDING_REVIEW") {
        $option = "OPTION_KEEP_AS_SUPPORT_CANDIDATE_PENDING_REVIEW"
        $finalRecommendation = "Keep as support candidate pending review. Needs explicit later approval before promotion."
    }
    elseif ($supportClass -eq "WEAK_SUPPORT_CANDIDATE") {
        $option = "OPTION_DEFER_OR_OLD_LOAD_REVIEW"
        $finalRecommendation = "Defer or route to old-load review later. No cleanup authorized."
    }

    $Items.Add([pscustomobject]@{
        Index = $index
        ObservedPath = $observedPath
        ObservedSha = $observedSha
        ObservedSize = $observedSize
        SupportClass = $supportClass
        RecommendedDisposition = $recommendedDisposition
        AuthorityBoundary = $authorityBoundary
        Option = $option
        FinalRecommendation = $finalRecommendation
        PromotionStatus = $promotionStatus
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

$ClassGroups = $Items | Group-Object SupportClass | Sort-Object Name
$ClassCountLines = @(
    foreach ($g in $ClassGroups) {
        "- $($g.Name): $($g.Count)"
    }
)

$GuardrailLines = @(
    foreach ($item in ($Items | Where-Object { $_.Option -eq "OPTION_KEEP_AS_SUPPORT_GUARDRAIL_CANDIDATE" })) {
        "- $($item.ObservedPath)"
    }
)

$PendingLines = @(
    foreach ($item in ($Items | Where-Object { $_.Option -eq "OPTION_KEEP_AS_SUPPORT_CANDIDATE_PENDING_REVIEW" })) {
        "- $($item.ObservedPath)"
    }
)

if ($GuardrailLines.Count -eq 0) {
    $GuardrailLines = @("- NONE")
}

if ($PendingLines.Count -eq 0) {
    $PendingLines = @("- NONE")
}

$ItemBlocks = @(
    foreach ($item in $Items) {
        @"
## SUPPORT_OPTION_ITEM_$("{0:D2}" -f $item.Index)

observed_path:
$($item.ObservedPath)

observed_sha256:
$($item.ObservedSha)

observed_size_bytes:
$($item.ObservedSize)

support_class:
$($item.SupportClass)

recommended_disposition_from_review:
$($item.RecommendedDisposition)

authority_boundary:
$($item.AuthorityBoundary)

option_bucket:
$($item.Option)

final_recommendation:
$($item.FinalRecommendation)

promotion_status:
$($item.PromotionStatus)

support_signals:
$($item.Signals)

cautions:
$($item.Cautions)

review_card_path:
$($item.ReviewCardPath)

review_card_sha256:
$($item.ReviewCardSha256)

DoesNotProve:
This support option item does not prove the support candidate is active support, doctrine, active guide, executor authority, cleanup authority, routing authority, Git-safe as full content, source authority, or project complete.

"@
    }
)

$OptionSetText = @"
# ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608

Status: SUPPORT_CANDIDATE_OPTION_SET / V0_2_REPAIR / ERROR_FREEZE_INCLUDED / READ_ONLY / NO_PROMOTION / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

V0_1 failure frozen:
$($Freeze.FreezePath)

V0_1 failure freeze SHA256:
$($Freeze.FreezeHash)

V0_2 fix note:
$($Freeze.FixPath)

V0_2 fix note SHA256:
$($Freeze.FixHash)

Incident receipt:
$($Freeze.IncidentReceiptPath)

Incident receipt SHA256:
$($Freeze.IncidentReceiptHash)

Source support review report:
$SupportReviewReport

Source support review report SHA256:
$SupportReviewReportHash

Source support review receipt:
$SupportReviewReceipt

Source support review receipt SHA256:
$SupportReviewReceiptHash

Source support review cards folder:
$SupportReviewCardsFolder

Source queue:
$Queue

Source queue SHA256:
$QueueHash

Source queue receipt:
$QueueReceipt

Source queue receipt SHA256:
$QueueReceiptHash

Prior source option set:
$SourceOptionSet

Prior source option set SHA256:
$SourceOptionSetHash

Prior source option rough_local:
$SourceOptionRough

Prior source option rough_local SHA256:
$SourceOptionRoughHash

Prior helper option set:
$HelperOptionSet

Prior helper option set SHA256:
$HelperOptionSetHash

Prior helper option rough_local:
$HelperOptionRough

Prior helper option rough_local SHA256:
$HelperOptionRoughHash

Washer schema:
$WasherSchema

Washer schema SHA256:
$WasherSchemaHash

Purpose:
Condense the 2 support candidate review cards into a small option set and freeze the V0_1 scalar Count failure.

This option set does not promote, execute, move, delete, route, stage, commit, push, or rewrite anything.

## OPTION COUNTS

$($OptionCountLines -join "`r`n")

## SUPPORT CLASS COUNTS

$($ClassCountLines -join "`r`n")

## KEEP AS SUPPORT GUARDRAIL CANDIDATE

$($GuardrailLines -join "`r`n")

Boundary:
Support guardrail candidate does not mean doctrine, active guide, executor, cleanup authority, or routing authority.

## KEEP AS SUPPORT CANDIDATE PENDING REVIEW

$($PendingLines -join "`r`n")

Boundary:
Support candidate pending review requires explicit later approval before promotion.

## SUPPORT OPTION ITEMS

$($ItemBlocks -join "`r`n")

## SELECTED RECOMMENDATION

Selected:
KEEP_BOTH_AS_SUPPORT_CANDIDATES_WITH_NO_PROMOTION

Reason:
One item is a support guardrail candidate and one item still needs support review. Neither should be promoted by this dry-run.

## V0_2 FIX APPLIED

Fix applied:
Array-wrap singleton/multiple/empty line collections before `.Count`.

Reason:
PowerShell can collapse a one-item result into a scalar. StrictMode Latest can then reject `.Count`.

## STILL BLOCKED

- promote to doctrine
- promote to active guide
- treat as executor
- move
- delete
- rename
- route
- cleanup
- stage full files
- commit full files
- push
- source rewrite
- current truth index rewrite

## NEXT RECOMMENDED BUILD CHUNK

ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608

Purpose:
Carry the repaired support candidate option set into Git as rough_local hash truth only.

Still blocked:
Full support file staging, active-guide promotion, doctrine promotion, executor authority, cleanup, routing, and mutation.

## DOESNOTPROVE

This option set does not prove any support candidate is active support, doctrine, active guide, executor authority, cleanup authority, routing authority, Git-safe as full content, source authority, or project complete.

## FINAL RETURN FIELDS

option_set_path:
$OutputPath

option_set_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

v0_1_failure_freeze_path:
$($Freeze.FreezePath)

v0_1_failure_freeze_sha256:
$($Freeze.FreezeHash)

v0_2_fix_note_path:
$($Freeze.FixPath)

v0_2_fix_note_sha256:
$($Freeze.FixHash)

incident_receipt_path:
$($Freeze.IncidentReceiptPath)

incident_receipt_sha256:
$($Freeze.IncidentReceiptHash)

support_review_report_sha256_confirmed:
$SupportReviewReportHash

support_review_receipt_sha256_confirmed:
$SupportReviewReceiptHash

queue_sha256_confirmed:
$QueueHash

queue_receipt_sha256_confirmed:
$QueueReceiptHash

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

support_candidates_reviewed:
$($Items.Count)

support_guardrail_candidate_count:
$(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_AS_SUPPORT_GUARDRAIL_CANDIDATE" }).Count)

support_candidate_pending_review_count:
$(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_AS_SUPPORT_CANDIDATE_PENDING_REVIEW" }).Count)

selected_recommendation:
KEEP_BOTH_AS_SUPPORT_CANDIDATES_WITH_NO_PROMOTION

promotion_done:
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
ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $OptionSetText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_RECEIPT_V0_2_20260608
Created: $Timestamp

option_set_path: $OutputPath
option_set_sha256: $OutputHash

v0_1_failure_freeze_sha256: $($Freeze.FreezeHash)
v0_2_fix_note_sha256: $($Freeze.FixHash)
incident_receipt_sha256: $($Freeze.IncidentReceiptHash)

support_review_report_sha256: $SupportReviewReportHash
support_review_receipt_sha256: $SupportReviewReceiptHash
queue_sha256: $QueueHash
queue_receipt_sha256: $QueueReceiptHash
source_option_set_sha256: $SourceOptionSetHash
source_option_rough_local_sha256: $SourceOptionRoughHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
washer_schema_sha256: $WasherSchemaHash

support_candidates_reviewed: $($Items.Count)
support_guardrail_candidate_count: $(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_AS_SUPPORT_GUARDRAIL_CANDIDATE" }).Count)
support_candidate_pending_review_count: $(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_AS_SUPPORT_CANDIDATE_PENDING_REVIEW" }).Count)

selected_recommendation: KEEP_BOTH_AS_SUPPORT_CANDIDATES_WITH_NO_PROMOTION
promotion_done: NO

option_counts:
$($OptionCountLines -join "`r`n")

support_class_counts:
$($ClassCountLines -join "`r`n")

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
scripts_executed_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$OptionSetText = $OptionSetText.Replace("option_set_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "option_set_sha256:`r`n$OutputHash")
$OptionSetText = $OptionSetText.Replace("option_set_sha256:`nTO_BE_FILLED_AFTER_CREATION", "option_set_sha256:`n$OutputHash")
$OptionSetText = $OptionSetText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$OptionSetText = $OptionSetText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $OptionSetText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER SUPPORT CANDIDATE OPTION SET V0_2 COMPLETE ==="
"option_set_path: $OutputPath"
"option_set_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"v0_1_failure_freeze_path: $($Freeze.FreezePath)"
"v0_1_failure_freeze_sha256: $($Freeze.FreezeHash)"
"v0_2_fix_note_path: $($Freeze.FixPath)"
"v0_2_fix_note_sha256: $($Freeze.FixHash)"
"incident_receipt_path: $($Freeze.IncidentReceiptPath)"
"incident_receipt_sha256: $($Freeze.IncidentReceiptHash)"
"support_review_report_sha256_confirmed: $SupportReviewReportHash"
"support_review_receipt_sha256_confirmed: $SupportReviewReceiptHash"
"queue_sha256_confirmed: $QueueHash"
"queue_receipt_sha256_confirmed: $QueueReceiptHash"
"source_option_set_sha256_confirmed: $SourceOptionSetHash"
"source_option_rough_local_sha256_confirmed: $SourceOptionRoughHash"
"helper_option_set_sha256_confirmed: $HelperOptionSetHash"
"helper_option_rough_local_sha256_confirmed: $HelperOptionRoughHash"
"washer_schema_sha256_confirmed: $WasherSchemaHash"
"support_candidates_reviewed: $($Items.Count)"
"support_guardrail_candidate_count: $(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_AS_SUPPORT_GUARDRAIL_CANDIDATE" }).Count)"
"support_candidate_pending_review_count: $(($Items | Where-Object { $_.Option -eq "OPTION_KEEP_AS_SUPPORT_CANDIDATE_PENDING_REVIEW" }).Count)"
"selected_recommendation: KEEP_BOTH_AS_SUPPORT_CANDIDATES_WITH_NO_PROMOTION"
"promotion_done: NO"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROUGH_LOCAL_IMPORT_FOR_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_READY_WITH_SCOPE_LIMIT_NOTE"
