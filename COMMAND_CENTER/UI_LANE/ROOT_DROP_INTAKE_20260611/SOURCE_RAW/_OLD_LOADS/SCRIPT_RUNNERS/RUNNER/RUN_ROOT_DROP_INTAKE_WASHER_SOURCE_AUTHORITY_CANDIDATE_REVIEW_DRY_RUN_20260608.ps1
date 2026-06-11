$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"
$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionSetReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$OutputV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_V0_2_20260608.txt"
$CardBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_CARD_20260608.md"
$CardV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_CARD_V0_2_20260608.md"

$KnownActiveSourceHash = "7F7B61C0915966EA3222587BA97B1ED8BCC47FC62739526B0542C557DA3156F7"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the source candidate is invalid. It proves this bounded source-authority candidate review runner stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER SOURCE AUTHORITY CANDIDATE REVIEW BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_NOT_COMPLETE"
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

function Get-SourceSignalClassification {
    param(
        [string]$Path,
        [string]$Text,
        [string]$Sha256
    )

    $name = [System.IO.Path]::GetFileName($Path)
    $sourceSignals = New-Object System.Collections.Generic.List[string]
    $blockers = New-Object System.Collections.Generic.List[string]

    if ($name -match '^PLANETARY_HOUSE_GATE_MASTER_INDEX') {
        $sourceSignals.Add("Name matches planetary house gate master index family.")
    }

    if ($Text -match 'PLANETARY|planetary|gate|GATE') {
        $sourceSignals.Add("Content contains planetary/gate vocabulary.")
    }

    if ($Text -match 'INTAKE|intake|GUARD_MEMBRANE|guard membrane') {
        $sourceSignals.Add("Content contains intake/guard membrane vocabulary.")
    }

    if ($Sha256 -eq $KnownActiveSourceHash) {
        $sourceSignals.Add("Hash matches the known active source object hash carried by this lane.")
    } else {
        $blockers.Add("Hash does not match known active source hash carried by this lane.")
    }

    $authorityRecommendation = "SOURCE_CANDIDATE_ONLY"
    $authorityStatus = "NOT_PROMOTED_BY_THIS_DRY_RUN"
    $nextAuthorityNeeded = "SOURCE_AUTHORITY_CONFIRMATION_WITH_EXPLICIT_USER_APPROVAL"

    if ($Sha256 -eq $KnownActiveSourceHash -and $sourceSignals.Count -ge 3) {
        $authorityRecommendation = "MATCHES_KNOWN_ACTIVE_SOURCE_HASH_BUT_STILL_NO_NEW_PROMOTION"
        $authorityStatus = "MATCHES_KNOWN_ACTIVE_SOURCE_HASH"
        $nextAuthorityNeeded = "CONFIRM_THIS_REMAINS_ACTIVE_SOURCE_OBJECT_FOR_CURRENT_LANE"
    }

    if ($sourceSignals.Count -eq 0) {
        $authorityRecommendation = "NOT_ENOUGH_SOURCE_SIGNAL"
        $authorityStatus = "CANDIDATE_ONLY_LOW_SIGNAL"
        $nextAuthorityNeeded = "MANUAL_REVIEW"
    }

    if ($blockers.Count -eq 0) {
        $blockers.Add("No hard content/hash blocker found by this bounded dry-run.")
    }

    return [pscustomobject]@{
        SourceSignals = ($sourceSignals -join " ")
        Blockers = ($blockers -join " ")
        AuthorityRecommendation = $authorityRecommendation
        AuthorityStatus = $authorityStatus
        NextAuthorityNeeded = $nextAuthorityNeeded
    }
}

"=== ROOT DROP INTAKE WASHER SOURCE AUTHORITY CANDIDATE REVIEW DRY-RUN ==="

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "review queue"
$QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "review queue receipt"
$HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper candidate option set"
$HelperOptionSetReceiptHash = Require-Hash -Path $HelperOptionSetReceipt -ExpectedSha256 "41C7142E6E618BE77C5F40EB12D62F66A52CE2A5C180EB775FFA078AFEC52513" -Name "helper candidate option set receipt"
$HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper candidate option rough_local ledger"
$HelperOptionRoughReceiptHash = Require-Hash -Path $HelperOptionRoughReceipt -ExpectedSha256 "47BB4E9FDC5D51866E746BC5AC718A57ECAE24F70BF13D8CE5D3C4BF4D18899A" -Name "helper candidate option rough_local receipt"
$WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$CardPath = Choose-OutputPath -Base $CardBase -Fallback $CardV2

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$QueueText = Get-Content -LiteralPath $Queue -Raw
$Blocks = Get-QueueItemBlocks -Text $QueueText
$SourceItems = New-Object System.Collections.Generic.List[object]

foreach ($m in $Blocks) {
    $block = $m.Value
    $bucket = Get-Field -Text $block -FieldName "queue_bucket"
    if ($bucket -ne "NEEDS_SOURCE_AUTHORITY_REVIEW") {
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

    $SourceItems.Add([pscustomobject]@{
        ObservedPath = $observedPath
        ObservedSha = $observedSha
        ObservedSize = $observedSize
        CandidateRole = $candidateRole
        AuthorityState = $authorityState
        SuggestedRoute = $suggestedRoute
        Decision = $decision
        SourceCardPath = $sourceCardPath
        SourceCardSha = $sourceCardSha
    })
}

if ($SourceItems.Count -ne 1) {
    Write-BlockerAndExit -Reason "SOURCE_AUTHORITY_CANDIDATE_COUNT_MISMATCH" -Detail "actual=$($SourceItems.Count) expected=1"
}

$Item = $SourceItems[0]

if (-not (Test-Path -LiteralPath $Item.ObservedPath -PathType Leaf)) {
    Write-BlockerAndExit -Reason "SOURCE_CANDIDATE_MISSING" -Detail $Item.ObservedPath
}

$ActualObservedHash = (Get-FileHash -LiteralPath $Item.ObservedPath -Algorithm SHA256).Hash
if ($ActualObservedHash -ne $Item.ObservedSha) {
    Write-BlockerAndExit -Reason "SOURCE_CANDIDATE_HASH_DRIFT" -Detail "path=$($Item.ObservedPath) actual=$ActualObservedHash expected=$($Item.ObservedSha)"
}

$ObservedContent = Get-Content -LiteralPath $Item.ObservedPath -Raw
$ObservedInfo = Get-Item -LiteralPath $Item.ObservedPath
$SourceClass = Get-SourceSignalClassification -Path $Item.ObservedPath -Text $ObservedContent -Sha256 $ActualObservedHash

$CardText = @"
# ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_CARD_20260608

Status: SOURCE_AUTHORITY_CANDIDATE_REVIEW_CARD / READ_ONLY / NO_PROMOTION / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

observed_path:
$($Item.ObservedPath)

observed_sha256:
$ActualObservedHash

observed_size_bytes:
$($ObservedInfo.Length)

queue_candidate_role:
$($Item.CandidateRole)

queue_authority_state:
$($Item.AuthorityState)

queue_suggested_route:
$($Item.SuggestedRoute)

queue_next_human_decision:
$($Item.Decision)

source_signals:
$($SourceClass.SourceSignals)

blockers_or_cautions:
$($SourceClass.Blockers)

authority_status:
$($SourceClass.AuthorityStatus)

authority_recommendation:
$($SourceClass.AuthorityRecommendation)

next_authority_needed:
$($SourceClass.NextAuthorityNeeded)

blocked_actions:
- source promotion by location alone
- source promotion by name alone
- move
- delete
- rename
- route
- cleanup
- stage full file
- commit full file
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

proof_need:
- explicit confirmation that this object is the current active source for the lane
- active source hash confirmation
- clear boundary between source authority and support helper
- no mutation before source custody is confirmed
- rough_local pointer only if Git needs a trace and full content is not approved

DoesNotProve:
This source authority candidate review card does not prove the file is active source, current truth, doctrine, active guide, safe to move, safe to route, safe to clean, Git-safe as full content, or project complete.
"@

Write-TextFile -Path $CardPath -Text $CardText
$CardHash = (Get-FileHash -LiteralPath $CardPath -Algorithm SHA256).Hash

$ReportText = @"
# ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_20260608

Status: SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN / READ_ONLY / NO_PROMOTION / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

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

Prior helper candidate option set:
$HelperOptionSet

Prior helper candidate option set SHA256:
$HelperOptionSetHash

Prior helper candidate option set receipt:
$HelperOptionSetReceipt

Prior helper candidate option set receipt SHA256:
$HelperOptionSetReceiptHash

Prior helper option rough_local ledger:
$HelperOptionRough

Prior helper option rough_local ledger SHA256:
$HelperOptionRoughHash

Prior helper option rough_local receipt:
$HelperOptionRoughReceipt

Prior helper option rough_local receipt SHA256:
$HelperOptionRoughReceiptHash

Washer schema:
$WasherSchema

Washer schema SHA256:
$WasherSchemaHash

Purpose:
Review the single source-authority candidate from the root-drop washer queue without promoting, moving, routing, staging, committing, pushing, or rewriting it.

## SOURCE CANDIDATE

observed_path:
$($Item.ObservedPath)

observed_sha256:
$ActualObservedHash

observed_size_bytes:
$($ObservedInfo.Length)

queue_candidate_role:
$($Item.CandidateRole)

queue_authority_state:
$($Item.AuthorityState)

queue_suggested_route:
$($Item.SuggestedRoute)

queue_next_human_decision:
$($Item.Decision)

review_card_path:
$CardPath

review_card_sha256:
$CardHash

## DRY-RUN CLASSIFICATION

source_signals:
$($SourceClass.SourceSignals)

blockers_or_cautions:
$($SourceClass.Blockers)

authority_status:
$($SourceClass.AuthorityStatus)

authority_recommendation:
$($SourceClass.AuthorityRecommendation)

next_authority_needed:
$($SourceClass.NextAuthorityNeeded)

## INTERPRETATION

The source-authority candidate has been identified and hashed. This dry-run does not promote it. It only separates "candidate/source signal" from "confirmed current authority."

The object may match the known active source hash carried by this lane, but this report still does not rewrite current truth or create new source authority.

## RECOMMENDED NEXT MOVE

ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608

Purpose:
Create a small option set:
- confirm as current active source for this lane
- keep as source candidate only
- park as old/stale source candidate
- rough_local hash pointer only
- defer

Still read-only. No cleanup. No routing. No Git.

## STILL BLOCKED

- promote source by location alone
- promote source by name alone
- move
- delete
- rename
- route
- cleanup
- stage full file
- commit full file
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

## DOESNOTPROVE

This dry run does not prove the file is active source, current truth, doctrine, active guide, safe to move, safe to route, safe to clean, Git-safe as full content, or project complete.

## FINAL RETURN FIELDS

output_report_path:
$OutputPath

output_report_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

review_card_path:
$CardPath

review_card_sha256:
$CardHash

source_candidate_path:
$($Item.ObservedPath)

source_candidate_sha256:
$ActualObservedHash

known_active_source_hash:
$KnownActiveSourceHash

matches_known_active_source_hash:
$($ActualObservedHash -eq $KnownActiveSourceHash)

queue_sha256_confirmed:
$QueueHash

queue_receipt_sha256_confirmed:
$QueueReceiptHash

helper_option_set_sha256_confirmed:
$HelperOptionSetHash

helper_option_rough_local_sha256_confirmed:
$HelperOptionRoughHash

washer_schema_sha256_confirmed:
$WasherSchemaHash

source_authority_candidates_reviewed:
1

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
ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

review_card_path: $CardPath
review_card_sha256: $CardHash

source_candidate_path: $($Item.ObservedPath)
source_candidate_sha256: $ActualObservedHash
known_active_source_hash: $KnownActiveSourceHash
matches_known_active_source_hash: $($ActualObservedHash -eq $KnownActiveSourceHash)

queue_sha256: $QueueHash
queue_receipt_sha256: $QueueReceiptHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_set_receipt_sha256: $HelperOptionSetReceiptHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
helper_option_rough_local_receipt_sha256: $HelperOptionRoughReceiptHash
washer_schema_sha256: $WasherSchemaHash

source_authority_candidates_reviewed: 1

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
scripts_executed_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER SOURCE AUTHORITY CANDIDATE REVIEW DRY-RUN COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"review_card_path: $CardPath"
"review_card_sha256: $CardHash"
"source_candidate_path: $($Item.ObservedPath)"
"source_candidate_sha256: $ActualObservedHash"
"known_active_source_hash: $KnownActiveSourceHash"
"matches_known_active_source_hash: $($ActualObservedHash -eq $KnownActiveSourceHash)"
"queue_sha256_confirmed: $QueueHash"
"queue_receipt_sha256_confirmed: $QueueReceiptHash"
"helper_option_set_sha256_confirmed: $HelperOptionSetHash"
"helper_option_rough_local_sha256_confirmed: $HelperOptionRoughHash"
"washer_schema_sha256_confirmed: $WasherSchemaHash"
"source_authority_candidates_reviewed: 1"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"scripts_executed_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_READY_WITH_SCOPE_LIMIT_NOTE"
