$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"

$SourceOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SourceOptionSetReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$SourceOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SourceOptionRoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"

$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$OutputV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_V0_2_20260608.txt"
$CardsFolderBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_CARDS_20260608"
$CardsFolderV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_CARDS_V0_2_20260608"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the support candidate review failed. It proves this bounded support-candidate review runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER SUPPORT CANDIDATE REVIEW BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_NOT_COMPLETE"
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

function Classify-SupportCandidate {
    param(
        [string]$Path,
        [string]$Sha256,
        [string]$Text
    )

    $name = [System.IO.Path]::GetFileName($Path)
    $signals = New-Object System.Collections.Generic.List[string]
    $cautions = New-Object System.Collections.Generic.List[string]

    $supportClass = "SUPPORT_CANDIDATE_NEEDS_REVIEW"
    $recommendedDisposition = "KEEP_AS_SUPPORT_CANDIDATE_PENDING_REVIEW"
    $authorityBoundary = "SUPPORT_ONLY_NOT_EXECUTOR_NOT_DOCTRINE"

    if ($name -match 'ROOT_DROP_INTAKE_WASHER|WASHER|INTAKE|GATE|RULE') {
        $signals.Add("Name carries root-drop/intake/washer/gate/rule support signal.")
        $supportClass = "SUPPORT_GUARDRAIL_CANDIDATE"
        $recommendedDisposition = "KEEP_AS_SUPPORT_GUARDRAIL_CANDIDATE"
    }

    if ($Text -match 'DoesNotProve|blocked|Blocked|authority|Authority|support|Support|guardrail|Guardrail|gate|Gate') {
        $signals.Add("Content carries support/boundary/DoesNotProve vocabulary.")
    }

    if ($Text -match 'Move-Item|Remove-Item|Rename-Item|git\s+commit|git\s+add|git\s+push') {
        $cautions.Add("Content contains possible mutation/Git command text. Treat as support only until a separate executor review exists.")
        $authorityBoundary = "SUPPORT_ONLY_WITH_MUTATION_LANGUAGE_CAUTION"
    }

    if ($Text -match 'ACTIVE_GUIDE|DOCTRINE|CURRENT_TRUTH|SOURCE_AUTHORITY') {
        $cautions.Add("Content mentions authority states. Do not promote by mention alone.")
    }

    if ($signals.Count -eq 0) {
        $signals.Add("No strong support signal found by bounded dry-run.")
        $supportClass = "WEAK_SUPPORT_CANDIDATE"
        $recommendedDisposition = "KEEP_PENDING_MANUAL_REVIEW"
    }

    if ($cautions.Count -eq 0) {
        $cautions.Add("No hard caution found by bounded dry-run.")
    }

    return [pscustomobject]@{
        SupportClass = $supportClass
        RecommendedDisposition = $recommendedDisposition
        AuthorityBoundary = $authorityBoundary
        Signals = ($signals -join " ")
        Cautions = ($cautions -join " ")
    }
}

"=== ROOT DROP INTAKE WASHER SUPPORT CANDIDATE REVIEW DRY-RUN ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "review queue"
$QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "review queue receipt"

$SourceOptionSetHash = Require-Hash -Path $SourceOptionSet -ExpectedSha256 "F1A44A706670489D5715B1726449C3D6DD8DB83DE6E497C5D73982CC40DF775F" -Name "source authority option set"
$SourceOptionSetReceiptHash = Require-Hash -Path $SourceOptionSetReceipt -ExpectedSha256 "9A42577D4BD29ECDDEDA19685891ECCE7F41ABF469346F792A5B416323CACE18" -Name "source authority option set receipt"
$SourceOptionRoughHash = Require-Hash -Path $SourceOptionRough -ExpectedSha256 "7BAE7F5EA6B1673BDFF91F13BE4981D26871E99B65C944E371D5E15220843FCA" -Name "source authority option rough_local ledger"
$SourceOptionRoughReceiptHash = Require-Hash -Path $SourceOptionRoughReceipt -ExpectedSha256 "980634FA3699D5FD3D5AF7D98035355674F4A7C9DD622DC7E57E6B935535DBDE" -Name "source authority option rough_local receipt"

$HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper candidate option set"
$HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper candidate option rough_local ledger"
$WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$CardsFolder = Choose-FolderPath -Base $CardsFolderBase -Fallback $CardsFolderV2
New-Item -ItemType Directory -Path $CardsFolder -Force | Out-Null

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$QueueText = Get-Content -LiteralPath $Queue -Raw
$Blocks = Get-QueueItemBlocks -Text $QueueText
$SupportItems = New-Object System.Collections.Generic.List[object]

foreach ($m in $Blocks) {
    $block = $m.Value
    $bucket = Get-Field -Text $block -FieldName "queue_bucket"
    if ($bucket -ne "SUPPORT_REVIEW") {
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
        Write-BlockerAndExit -Reason "SUPPORT_CANDIDATE_MISSING" -Detail $observedPath
    }

    $actualSha = (Get-FileHash -LiteralPath $observedPath -Algorithm SHA256).Hash
    if ($actualSha -ne $observedSha) {
        Write-BlockerAndExit -Reason "SUPPORT_CANDIDATE_HASH_DRIFT" -Detail "path=$observedPath actual=$actualSha expected=$observedSha"
    }

    $content = Get-Content -LiteralPath $observedPath -Raw
    $class = Classify-SupportCandidate -Path $observedPath -Sha256 $actualSha -Text $content

    $SupportItems.Add([pscustomobject]@{
        ObservedPath = $observedPath
        ObservedSha = $actualSha
        ObservedSize = $observedSize
        CandidateRole = $candidateRole
        AuthorityState = $authorityState
        SuggestedRoute = $suggestedRoute
        Decision = $decision
        SourceCardPath = $sourceCardPath
        SourceCardSha = $sourceCardSha
        SupportClass = $class.SupportClass
        RecommendedDisposition = $class.RecommendedDisposition
        AuthorityBoundary = $class.AuthorityBoundary
        Signals = $class.Signals
        Cautions = $class.Cautions
    })
}

if ($SupportItems.Count -ne 2) {
    Write-BlockerAndExit -Reason "SUPPORT_CANDIDATE_COUNT_MISMATCH" -Detail "actual=$($SupportItems.Count) expected=2"
}

$ReviewCards = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($item in $SupportItems) {
    $index += 1
    $safeStem = Get-SafeFileStem -Name ([System.IO.Path]::GetFileName($item.ObservedPath))
    $cardPath = Join-Path $CardsFolder ("SUPPORT_REVIEW_CARD_{0:D2}__{1}.md" -f $index, $safeStem)

    $CardText = @"
# ROOT_DROP_INTAKE_WASHER_SUPPORT_REVIEW_CARD_$("{0:D2}" -f $index)

Status: SUPPORT_CANDIDATE_REVIEW_DRY_RUN / READ_ONLY / NO_PROMOTION / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

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

support_class:
$($item.SupportClass)

recommended_disposition:
$($item.RecommendedDisposition)

authority_boundary:
$($item.AuthorityBoundary)

support_signals:
$($item.Signals)

cautions:
$($item.Cautions)

blocked_actions:
- promote to doctrine
- promote to active guide
- treat as executor
- move
- delete
- rename
- route
- cleanup
- stage full file
- commit full file
- push
- source rewrite
- current truth index rewrite

proof_need:
- explicit user approval before promotion
- separate active-support authority card if promoted later
- no executor behavior without executor proof
- rough_local pointer if Git needs trace
- before/after receipt for any future mutation

DoesNotProve:
This support review card does not prove the support candidate is active support, doctrine, active guide, executor authority, cleanup authority, routing authority, Git-safe as full content, source authority, or project complete.
"@

    Write-TextFile -Path $cardPath -Text $CardText
    $cardHash = (Get-FileHash -LiteralPath $cardPath -Algorithm SHA256).Hash

    $ReviewCards.Add([pscustomobject]@{
        Index = $index
        ObservedPath = $item.ObservedPath
        ObservedSha = $item.ObservedSha
        SupportClass = $item.SupportClass
        RecommendedDisposition = $item.RecommendedDisposition
        AuthorityBoundary = $item.AuthorityBoundary
        ReviewCardPath = $cardPath
        ReviewCardSha256 = $cardHash
    })
}

$ClassGroups = $ReviewCards | Group-Object SupportClass | Sort-Object Name
$ClassLines = foreach ($g in $ClassGroups) {
    "- $($g.Name): $($g.Count)"
}

$DispositionGroups = $ReviewCards | Group-Object RecommendedDisposition | Sort-Object Name
$DispositionLines = foreach ($g in $DispositionGroups) {
    "- $($g.Name): $($g.Count)"
}

$CardSummary = foreach ($card in $ReviewCards) {
    @"
## SUPPORT_ITEM_$("{0:D2}" -f $card.Index)

observed_path:
$($card.ObservedPath)

observed_sha256:
$($card.ObservedSha)

support_class:
$($card.SupportClass)

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

$ReportText = @"
# ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_20260608

Status: SUPPORT_CANDIDATE_REVIEW_DRY_RUN / READ_ONLY / NO_PROMOTION / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

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

Prior source option set:
$SourceOptionSet

Prior source option set SHA256:
$SourceOptionSetHash

Prior source option set receipt:
$SourceOptionSetReceipt

Prior source option set receipt SHA256:
$SourceOptionSetReceiptHash

Prior source option rough_local ledger:
$SourceOptionRough

Prior source option rough_local ledger SHA256:
$SourceOptionRoughHash

Prior source option rough_local receipt:
$SourceOptionRoughReceipt

Prior source option rough_local receipt SHA256:
$SourceOptionRoughReceiptHash

Prior helper option set:
$HelperOptionSet

Prior helper option set SHA256:
$HelperOptionSetHash

Prior helper option rough_local ledger:
$HelperOptionRough

Prior helper option rough_local ledger SHA256:
$HelperOptionRoughHash

Washer schema:
$WasherSchema

Washer schema SHA256:
$WasherSchemaHash

Purpose:
Review the 2 support candidates from the root-drop washer queue without promoting, moving, routing, staging, committing, pushing, rewriting, or treating them as executors.

Support candidates reviewed:
$($ReviewCards.Count)

Review cards folder:
$CardsFolder

## SUPPORT CLASS COUNTS

$($ClassLines -join "`r`n")

## RECOMMENDED DISPOSITION COUNTS

$($DispositionLines -join "`r`n")

## REVIEW ITEMS

$($CardSummary -join "`r`n")

## INTERPRETATION

The washer successfully separated support candidates from helper candidates and source candidate.

Support candidates remain support candidates only. This dry-run does not make them active guides, doctrine, executors, cleanup rules, or routing authority.

## RECOMMENDED NEXT MOVE

ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608

Purpose:
Create a small option set for the 2 support candidates:
- keep as support guardrail candidate
- promote later to active support after approval
- rough_local pointer only
- defer
- reject/old-load review

Still read-only. No promotion. No cleanup. No Git.

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

## DOESNOTPROVE

This dry run does not prove any support candidate is active support, doctrine, active guide, executor authority, cleanup authority, routing authority, Git-safe as full content, source authority, or project complete.

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

support_candidates_reviewed:
$($ReviewCards.Count)

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
ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

review_cards_folder: $CardsFolder
support_candidates_reviewed: $($ReviewCards.Count)

queue_sha256: $QueueHash
queue_receipt_sha256: $QueueReceiptHash
source_option_set_sha256: $SourceOptionSetHash
source_option_set_receipt_sha256: $SourceOptionSetReceiptHash
source_option_rough_local_sha256: $SourceOptionRoughHash
source_option_rough_local_receipt_sha256: $SourceOptionRoughReceiptHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
washer_schema_sha256: $WasherSchemaHash

support_class_counts:
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

next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER SUPPORT CANDIDATE REVIEW DRY-RUN COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"review_cards_folder: $CardsFolder"
"support_candidates_reviewed: $($ReviewCards.Count)"
"queue_sha256_confirmed: $QueueHash"
"queue_receipt_sha256_confirmed: $QueueReceiptHash"
"source_option_set_sha256_confirmed: $SourceOptionSetHash"
"source_option_rough_local_sha256_confirmed: $SourceOptionRoughHash"
"helper_option_set_sha256_confirmed: $HelperOptionSetHash"
"helper_option_rough_local_sha256_confirmed: $HelperOptionRoughHash"
"washer_schema_sha256_confirmed: $WasherSchemaHash"
"support_class_counts:"
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
"next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE"
