$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"
$Summary = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608.md"
$SummaryReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_RECEIPT_20260608.txt"
$Schema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$OutputV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_V0_2_20260608.txt"
$CardsFolderBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_CARDS_20260608"
$CardsFolderV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_CARDS_V0_2_20260608"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the helper queue failed. It proves this bounded helper-candidate review runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER HELPER CANDIDATE REVIEW BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_NOT_COMPLETE"
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

function Get-SafeFileStem {
    param([string]$Name)

    $safe = [regex]::Replace($Name, '[^A-Za-z0-9._-]+', '_')
    if ($safe.Length -gt 90) {
        $safe = $safe.Substring(0, 90)
    }
    return $safe
}

function Classify-HelperByNameAndContent {
    param(
        [string]$Path,
        [string]$Text
    )

    $name = [System.IO.Path]::GetFileName($Path)

    $versionSignal = "UNVERSIONED_OR_SINGLE"
    $riskClass = "NEEDS_DEEPER_REVIEW"
    $suggestedDisposition = "KEEP_ROOT_PENDING_HELPER_REVIEW"
    $reason = New-Object System.Collections.Generic.List[string]

    if ($name -match 'V0_3|V0\.3') {
        $versionSignal = "NEWER_VERSION_SIGNAL"
        $reason.Add("Name has V0_3 signal.")
    }
    elseif ($name -match 'V0_2|V0\.2') {
        $versionSignal = "MIDDLE_VERSION_SIGNAL"
        $reason.Add("Name has V0_2 signal.")
    }
    elseif ($name -match 'V0_1|V0\.1') {
        $versionSignal = "OLDER_VERSION_SIGNAL"
        $reason.Add("Name has V0_1 signal.")
    }

    if ($name -match 'UNSAFE|FAILED|BROKEN|ERROR|FREEZE') {
        $riskClass = "UNSAFE_OR_FAILURE_EVIDENCE_CANDIDATE"
        $suggestedDisposition = "KEEP_AS_LOCAL_EVIDENCE_OR_SUPERSEDED_HELPER"
        $reason.Add("Name carries failure/unsafe/freeze signal.")
    }
    elseif ($Text -match 'Write-Utf8File\s+-Path\s+.*-Lines' -or $Text -match '\[string\[\]\]\s*\$Lines') {
        $riskClass = "STALE_LINE_WRITER_PATTERN_CANDIDATE"
        $suggestedDisposition = "DO_NOT_RUN_KEEP_FOR_EVIDENCE_REVIEW"
        $reason.Add("Content appears to contain old line-writer pattern.")
    }
    elseif ($Text -match '\[System\.IO\.File\]::WriteAllText' -and $Text -match 'Write-BlockerAndExit|Stop-WithBlocker') {
        $riskClass = "SAFE_TEMPLATE_SHAPE_CANDIDATE"
        $suggestedDisposition = "POSSIBLE_CURRENT_HELPER_CANDIDATE_REVIEW"
        $reason.Add("Content includes safe writer and blocker function signal.")
    }
    elseif ($Text -match 'git\s+-C|git\s+add|git\s+commit|git\s+push') {
        $riskClass = "GIT_TOUCHING_HELPER_CANDIDATE"
        $suggestedDisposition = "DO_NOT_RUN_WITHOUT_EXACT_STAGED_SET_REVIEW"
        $reason.Add("Content appears to contain Git operations.")
    }
    elseif ($Text -match 'Remove-Item|Move-Item|Rename-Item|Copy-Item') {
        $riskClass = "FILE_MUTATION_HELPER_CANDIDATE"
        $suggestedDisposition = "DO_NOT_RUN_WITHOUT_MUTATION_AUTHORITY"
        $reason.Add("Content appears to contain file operation command signals.")
    }
    else {
        $reason.Add("No decisive safe/current/stale signal found by bounded dry-run.")
    }

    return [pscustomobject]@{
        VersionSignal = $versionSignal
        RiskClass = $riskClass
        SuggestedDisposition = $suggestedDisposition
        Reason = ($reason -join " ")
    }
}

"=== ROOT DROP INTAKE WASHER HELPER CANDIDATE REVIEW DRY-RUN ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "review queue"
$QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "review queue receipt"
$SummaryHash = Require-Hash -Path $Summary -ExpectedSha256 "BD659A643AE3865FAB2FCEB0DC7C1700BBE4EF4F26D3803C6E0FB52127D61869" -Name "review queue summary/option set"
$SummaryReceiptHash = Require-Hash -Path $SummaryReceipt -ExpectedSha256 "B43450672DF855F495B7492FD5DEA15961493EF1EC5C6BD12D8545DD2A7EE8FF" -Name "review queue summary/option set receipt"
$SchemaHash = Require-Hash -Path $Schema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$CardsFolder = Choose-FolderPath -Base $CardsFolderBase -Fallback $CardsFolderV2

New-Item -ItemType Directory -Path $CardsFolder -Force | Out-Null

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$QueueText = Get-Content -LiteralPath $Queue -Raw
$Blocks = Get-QueueItemBlocks -Text $QueueText

$HelperItems = New-Object System.Collections.Generic.List[object]

foreach ($m in $Blocks) {
    $block = $m.Value
    $bucket = Get-Field -Block $block -FieldName "queue_bucket"
    if ($bucket -ne "NEEDS_HELPER_REVIEW") {
        continue
    }

    $observedPath = Get-Field -Block $block -FieldName "observed_path"
    $observedSha = Get-Field -Block $block -FieldName "observed_sha256"
    $candidateRole = Get-Field -Block $block -FieldName "candidate_role"
    $authorityState = Get-Field -Block $block -FieldName "authority_state"
    $suggestedRoute = Get-Field -Block $block -FieldName "suggested_route"
    $sourceCardPath = Get-Field -Block $block -FieldName "source_card_path"
    $sourceCardSha = Get-Field -Block $block -FieldName "source_card_sha256"

    if (-not (Test-Path -LiteralPath $observedPath -PathType Leaf)) {
        Write-BlockerAndExit -Reason "HELPER_CANDIDATE_MISSING" -Detail $observedPath
    }

    $actualSha = (Get-FileHash -LiteralPath $observedPath -Algorithm SHA256).Hash
    if ($actualSha -ne $observedSha) {
        Write-BlockerAndExit -Reason "HELPER_CANDIDATE_HASH_DRIFT" -Detail "path=$observedPath actual=$actualSha expected=$observedSha"
    }

    $content = Get-Content -LiteralPath $observedPath -Raw
    $class = Classify-HelperByNameAndContent -Path $observedPath -Text $content
    $fileInfo = Get-Item -LiteralPath $observedPath

    $HelperItems.Add([pscustomobject]@{
        ObservedPath = $observedPath
        ObservedSha = $observedSha
        SizeBytes = $fileInfo.Length
        CandidateRole = $candidateRole
        AuthorityState = $authorityState
        SuggestedRoute = $suggestedRoute
        SourceCardPath = $sourceCardPath
        SourceCardSha = $sourceCardSha
        VersionSignal = $class.VersionSignal
        RiskClass = $class.RiskClass
        SuggestedDisposition = $class.SuggestedDisposition
        Reason = $class.Reason
    })
}

if ($HelperItems.Count -ne 7) {
    Write-BlockerAndExit -Reason "HELPER_CANDIDATE_COUNT_MISMATCH" -Detail "actual=$($HelperItems.Count) expected=7"
}

$ReviewCards = New-Object System.Collections.Generic.List[object]
$index = 0

foreach ($item in $HelperItems) {
    $index += 1
    $safeStem = Get-SafeFileStem -Name ([System.IO.Path]::GetFileName($item.ObservedPath))
    $cardPath = Join-Path $CardsFolder ("HELPER_REVIEW_CARD_{0:D2}__{1}.md" -f $index, $safeStem)

    $CardText = @"
# ROOT_DROP_INTAKE_WASHER_HELPER_REVIEW_CARD_$("{0:D2}" -f $index)

Status: HELPER_CANDIDATE_REVIEW_DRY_RUN / READ_ONLY / DO_NOT_EXECUTE / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

observed_path:
$($item.ObservedPath)

observed_sha256:
$($item.ObservedSha)

observed_size_bytes:
$($item.SizeBytes)

candidate_role:
$($item.CandidateRole)

authority_state:
$($item.AuthorityState)

suggested_route_from_queue:
$($item.SuggestedRoute)

source_card_path:
$($item.SourceCardPath)

source_card_sha256:
$($item.SourceCardSha)

version_signal:
$($item.VersionSignal)

helper_risk_class:
$($item.RiskClass)

suggested_disposition:
$($item.SuggestedDisposition)

dry_run_reason:
$($item.Reason)

blocked_actions:
- execute script
- move
- delete
- rename
- route
- cleanup
- stage
- commit
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

proof_need:
- explicit user approval before execution
- exact command review before execution
- expected output declared before execution
- blocker behavior confirmed before execution
- mutation authority if file operations exist
- exact staged set if Git operations exist
- rough_local hash ledger if only pointer should enter Git

DoesNotProve:
This helper review card does not prove the helper is safe, current, stale, superseded, executable, Git-safe, cleanup-safe, doctrine, active guide, current truth, or project complete.
"@

    Write-TextFile -Path $cardPath -Text $CardText
    $cardHash = (Get-FileHash -LiteralPath $cardPath -Algorithm SHA256).Hash

    $ReviewCards.Add([pscustomobject]@{
        Index = $index
        ObservedPath = $item.ObservedPath
        ObservedSha = $item.ObservedSha
        RiskClass = $item.RiskClass
        SuggestedDisposition = $item.SuggestedDisposition
        VersionSignal = $item.VersionSignal
        CardPath = $cardPath
        CardHash = $cardHash
    })
}

$RiskGroups = $ReviewCards | Group-Object RiskClass | Sort-Object Name
$RiskLines = foreach ($g in $RiskGroups) {
    "- $($g.Name): $($g.Count)"
}

$DispositionGroups = $ReviewCards | Group-Object SuggestedDisposition | Sort-Object Name
$DispositionLines = foreach ($g in $DispositionGroups) {
    "- $($g.Name): $($g.Count)"
}

$CardLines = foreach ($card in $ReviewCards) {
    @"
## HELPER_ITEM_$("{0:D2}" -f $card.Index)

observed_path:
$($card.ObservedPath)

observed_sha256:
$($card.ObservedSha)

version_signal:
$($card.VersionSignal)

helper_risk_class:
$($card.RiskClass)

suggested_disposition:
$($card.SuggestedDisposition)

review_card_path:
$($card.CardPath)

review_card_sha256:
$($card.CardHash)

"@
}

$ReportText = @"
# ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608

Status: HELPER_CANDIDATE_REVIEW_DRY_RUN / READ_ONLY / DO_NOT_EXECUTE / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

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

Source summary/option set:
$Summary

Source summary/option set SHA256:
$SummaryHash

Source summary/option set receipt:
$SummaryReceipt

Source summary/option set receipt SHA256:
$SummaryReceiptHash

Source washer schema:
$Schema

Source washer schema SHA256:
$SchemaHash

Purpose:
Review the 7 helper candidates from the root-drop washer queue without executing, moving, deleting, routing, staging, committing, or promoting any helper.

Helper candidates reviewed:
$($ReviewCards.Count)

Review cards folder:
$CardsFolder

## RISK CLASS COUNTS

$($RiskLines -join "`r`n")

## SUGGESTED DISPOSITION COUNTS

$($DispositionLines -join "`r`n")

## REVIEW ITEMS

$($CardLines -join "`r`n")

## INTERPRETATION

The helper bucket is real and should remain blocked from execution until a separate command review exists.

The washer is doing its job: it separates helper candidates from source, support, and system/old-load candidates without acting on them.

## RECOMMENDED NEXT MOVE

Create a helper candidate option set, then decide whether to:
- keep only latest/current safe-template helpers as runnable candidates
- park old/failed helpers as evidence
- use rough_local hash pointers for Git
- leave everything read-only until user review

## STILL BLOCKED

- execute any helper
- move files
- delete files
- rename files
- route files
- cleanup
- stage full root files
- commit full root files
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

## NEXT RECOMMENDED BUILD CHUNK

ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608

Purpose:
Convert the 7 helper review cards into a small option set: current candidate, stale/failure evidence, deeper review needed, Git rough_local pointer only, or do nothing.

Still read-only. No execution. No cleanup. No Git.

## DOESNOTPROVE

This dry run does not prove any helper is safe, current, stale, superseded, executable, Git-safe, cleanup-safe, doctrine, active guide, current truth, or project complete.

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

helper_candidates_reviewed:
$($ReviewCards.Count)

queue_sha256_confirmed:
$QueueHash

queue_receipt_sha256_confirmed:
$QueueReceiptHash

summary_sha256_confirmed:
$SummaryHash

summary_receipt_sha256_confirmed:
$SummaryReceiptHash

schema_sha256_confirmed:
$SchemaHash

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
ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

review_cards_folder: $CardsFolder
helper_candidates_reviewed: $($ReviewCards.Count)

queue_path: $Queue
queue_sha256: $QueueHash

queue_receipt_sha256: $QueueReceiptHash
summary_sha256: $SummaryHash
summary_receipt_sha256: $SummaryReceiptHash
schema_sha256: $SchemaHash

risk_class_counts:
$($RiskLines -join "`r`n")

suggested_disposition_counts:
$($DispositionLines -join "`r`n")

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
scripts_executed_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER HELPER CANDIDATE REVIEW DRY-RUN COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"review_cards_folder: $CardsFolder"
"helper_candidates_reviewed: $($ReviewCards.Count)"
"queue_sha256_confirmed: $QueueHash"
"queue_receipt_sha256_confirmed: $QueueReceiptHash"
"summary_sha256_confirmed: $SummaryHash"
"summary_receipt_sha256_confirmed: $SummaryReceiptHash"
"schema_sha256_confirmed: $SchemaHash"
"risk_class_counts:"
$RiskLines
"suggested_disposition_counts:"
$DispositionLines
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE"
