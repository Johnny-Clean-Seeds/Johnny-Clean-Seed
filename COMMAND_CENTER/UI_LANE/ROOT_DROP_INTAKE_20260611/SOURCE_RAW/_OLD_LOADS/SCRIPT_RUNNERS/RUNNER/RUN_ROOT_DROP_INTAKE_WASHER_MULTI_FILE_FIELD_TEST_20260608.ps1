$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$Schema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"
$SchemaDryRun = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_DRY_RUN__ROOT_DROP_RULE_20260608.md"
$SchemaReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_RECEIPT_20260608.txt"
$SchemaRoughLocal = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_20260608.md"
$SchemaRoughLocalReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_RECEIPT_20260608.txt"

$OutputBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_FIELD_TEST_ON_MORE_THAN_ONE_FILE_20260608.md"
$OutputV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_FIELD_TEST_ON_MORE_THAN_ONE_FILE_V0_2_20260608.md"
$ReceiptBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"
$ReceiptV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_RECEIPT_V0_2_20260608.txt"

$CardsFolderBase = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_CARDS_20260608"
$CardsFolderV2 = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_CARDS_V0_2_20260608"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROOT_DROP_INTAKE_WASHER_MULTI_FILE_FIELD_TEST_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROOT_DROP_INTAKE_WASHER_MULTI_FILE_FIELD_TEST_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROOT_DROP_INTAKE_WASHER_MULTI_FILE_FIELD_TEST_NOT_COMPLETE

DoesNotProve:
This blocker file does not prove the washer schema failed. It proves this bounded multi-file field-test stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROOT DROP INTAKE WASHER MULTI-FILE FIELD TEST BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROOT_DROP_INTAKE_WASHER_MULTI_FILE_FIELD_TEST_NOT_COMPLETE"
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

function Get-SafeFileStem {
    param([string]$Name)

    $safe = [regex]::Replace($Name, '[^A-Za-z0-9._-]+', '_')
    if ($safe.Length -gt 90) {
        $safe = $safe.Substring(0, 90)
    }
    return $safe
}

function Classify-RootFile {
    param(
        [System.IO.FileInfo]$File
    )

    $name = $File.Name
    $ext = $File.Extension.ToLowerInvariant()

    $candidateRole = "UNKNOWN"
    $authorityState = "CANDIDATE_ONLY"
    $suggestedRoute = "KEEP_AT_ROOT_PENDING_REVIEW"
    $roughLocalBoundary = "Hash pointer is enough for Git by default. Full content requires later approval."
    $notes = New-Object System.Collections.Generic.List[string]

    if ($name -eq "desktop.ini") {
        $candidateRole = "OLD_LOAD_OR_STALE"
        $authorityState = "SUPPORT_ONLY"
        $suggestedRoute = "OLD_LOAD_REVIEW"
        $notes.Add("Windows metadata/system file. Not project source authority.")
    }
    elseif ($ext -eq ".ps1") {
        $candidateRole = "HELPER_CANDIDATE"
        $authorityState = "CANDIDATE_ONLY"
        $suggestedRoute = "CANDIDATE_FOR_LATER_PROMOTION"
        $notes.Add("PowerShell helper/script candidate. Must not be run merely because present at root.")
    }
    elseif ($name -match '^PLANETARY_HOUSE_GATE_MASTER_INDEX') {
        $candidateRole = "ACTIVE_SOURCE_CANDIDATE"
        $authorityState = "CANDIDATE_ONLY"
        $suggestedRoute = "KEEP_AT_ROOT_PENDING_REVIEW"
        $notes.Add("Looks like a major source object. This dry-run does not claim source authority.")
    }
    elseif ($name -match '^ROOT_DROP_INTAKE_WASHER') {
        $candidateRole = "SUPPORT_GUARDRAIL_CANDIDATE"
        $authorityState = "CANDIDATE_ONLY"
        $suggestedRoute = "PARK_AS_SUPPORT_GUARDRAIL"
        $notes.Add("Root-drop washer rule candidate. Support guardrail, not executor.")
    }
    elseif ($name -match 'RECEIPT|HASH|ROUGH_LOCAL') {
        $candidateRole = "RECEIPT"
        $authorityState = "HASH_POINTER_ONLY"
        $suggestedRoute = "ROUGH_LOCAL_HASH_LEDGER_ONLY"
        $notes.Add("Receipt/hash/pointer-like file.")
    }
    elseif ($ext -eq ".txt" -or $ext -eq ".md") {
        $candidateRole = "SUPPORT_GUARDRAIL_CANDIDATE"
        $authorityState = "CANDIDATE_ONLY"
        $suggestedRoute = "KEEP_AT_ROOT_PENDING_REVIEW"
        $notes.Add("Text/markdown support candidate.")
    }

    if ($File.Length -eq 0) {
        $candidateRole = "UNKNOWN"
        $authorityState = "UNKNOWN"
        $suggestedRoute = "OLD_LOAD_REVIEW"
        $notes.Add("Zero-byte file. Needs review before use.")
    }

    return [pscustomobject]@{
        CandidateRole = $candidateRole
        AuthorityState = $authorityState
        SuggestedRoute = $suggestedRoute
        RoughLocalBoundary = $roughLocalBoundary
        Notes = ($notes -join " ")
    }
}

"=== ROOT DROP INTAKE WASHER MULTI-FILE FIELD TEST ==="

if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_PROJECT_ROOT" -Detail $ProjectRoot
}

if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_LANE" -Detail $Lane
}

$SchemaHash = Require-Hash -Path $Schema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer support-card schema"
$SchemaDryRunHash = Require-Hash -Path $SchemaDryRun -ExpectedSha256 "D4C259530B55406DCAD612FD0CF3E74DC04C1B18E425140C0AC8B7132B3C3A15" -Name "washer dry-run card"
$SchemaReceiptHash = Require-Hash -Path $SchemaReceipt -ExpectedSha256 "70D9CAD70D21162A1143D5B074852AE2A66F34814F95D2E8A42502E8C3A283A2" -Name "washer schema/dry-run receipt"
$SchemaRoughLocalHash = Require-Hash -Path $SchemaRoughLocal -ExpectedSha256 "98E8BF180A50A729685C4B7A46FD89F1473AAB2E3CB58776507AFBB6CBE199CA" -Name "washer rough_local schema chain ledger"
$SchemaRoughLocalReceiptHash = Require-Hash -Path $SchemaRoughLocalReceipt -ExpectedSha256 "91DAAB8ECFC427FA252EFE4F42DBC88C6E22D3933636803E7EAAACD3180F3DC4" -Name "washer rough_local schema chain receipt"

$OutputPath = Choose-OutputPath -Base $OutputBase -Fallback $OutputV2
$ReceiptPath = Choose-OutputPath -Base $ReceiptBase -Fallback $ReceiptV2
$CardsFolder = Choose-FolderPath -Base $CardsFolderBase -Fallback $CardsFolderV2

New-Item -ItemType Directory -Path $CardsFolder -Force | Out-Null

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$RootFiles = @(Get-ChildItem -LiteralPath $ProjectRoot -Force -File | Sort-Object Name | Select-Object -First 12)

if ($RootFiles.Count -lt 2) {
    Write-BlockerAndExit -Reason "NOT_ENOUGH_ROOT_FILES" -Detail "Need at least two root-level files for this field test."
}

$Cards = New-Object System.Collections.Generic.List[object]

$index = 0
foreach ($file in $RootFiles) {
    $index += 1
    $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
    $class = Classify-RootFile -File $file
    $safeStem = Get-SafeFileStem -Name $file.Name
    $cardPath = Join-Path $CardsFolder ("CARD_{0:D2}__{1}.md" -f $index, $safeStem)

    $CardText = @"
# ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_CARD_$("{0:D2}" -f $index)

Status: SUPPORT_CARD_DRY_RUN / READ_ONLY / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Schema used:
$Schema

Schema SHA256:
$SchemaHash

observed_path:
$($file.FullName)

observed_sha256:
$hash

observed_size_bytes:
$($file.Length)

root_drop_state:
ROOT_PRESENT

candidate_role:
$($class.CandidateRole)

authority_state:
$($class.AuthorityState)

suggested_route:
$($class.SuggestedRoute)

blocked_actions:
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
- user approval before physical route/move
- before/after receipt for any future mutation
- hash receipt before and after any future file action
- separate authority card if washer becomes an executor
- rough_local ledger if Git receives only a pointer

rough_local_boundary:
$($class.RoughLocalBoundary)

next_authority_needed:
ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_FIELD_TEST_REVIEW

classification_notes:
$($class.Notes)

DoesNotProve:
This dry-run card does not prove the file is active, safe, stale, current, source authority, executor authority, cleanup authority, routing authority, Git authority, or project complete.
"@

    Write-TextFile -Path $cardPath -Text $CardText
    $cardHash = (Get-FileHash -LiteralPath $cardPath -Algorithm SHA256).Hash

    $Cards.Add([pscustomobject]@{
        Index = $index
        ObservedPath = $file.FullName
        ObservedHash = $hash
        SizeBytes = $file.Length
        CandidateRole = $class.CandidateRole
        AuthorityState = $class.AuthorityState
        SuggestedRoute = $class.SuggestedRoute
        CardPath = $cardPath
        CardHash = $cardHash
    })
}

$CardSummaryLines = foreach ($c in $Cards) {
    @"
### CARD_$("{0:D2}" -f $c.Index)

observed_path:
$($c.ObservedPath)

observed_sha256:
$($c.ObservedHash)

observed_size_bytes:
$($c.SizeBytes)

candidate_role:
$($c.CandidateRole)

authority_state:
$($c.AuthorityState)

suggested_route:
$($c.SuggestedRoute)

card_path:
$($c.CardPath)

card_sha256:
$($c.CardHash)

"@
}

$RoleCounts = $Cards | Group-Object CandidateRole | Sort-Object Name
$RoleCountLines = foreach ($g in $RoleCounts) {
    "- $($g.Name): $($g.Count)"
}

$ReportText = @"
# ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_FIELD_TEST_ON_MORE_THAN_ONE_FILE_20260608

Status: MULTI_FILE_FIELD_TEST / READ_ONLY / SUPPORT_CARD_SCHEMA_APPLIED / NO_MOVES / NO_ROUTING / NO_GIT / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Schema:
$Schema

Schema SHA256:
$SchemaHash

Prior single-file dry run:
$SchemaDryRun

Prior single-file dry run SHA256:
$SchemaDryRunHash

Prior schema/dry-run receipt:
$SchemaReceipt

Prior schema/dry-run receipt SHA256:
$SchemaReceiptHash

Prior rough_local schema-chain ledger:
$SchemaRoughLocal

Prior rough_local schema-chain ledger SHA256:
$SchemaRoughLocalHash

Prior rough_local schema-chain receipt:
$SchemaRoughLocalReceipt

Prior rough_local schema-chain receipt SHA256:
$SchemaRoughLocalReceiptHash

Purpose:
Apply the root-drop intake washer support-card schema to more than one root-level file without moving, routing, deleting, staging, committing, or promoting any file.

Scope:
Immediate root-level files only.
Maximum inspected files:
12

Actual inspected files:
$($Cards.Count)

Cards folder:
$CardsFolder

## ROLE COUNTS

$($RoleCountLines -join "`r`n")

## CARD SUMMARY

$($CardSummaryLines -join "`r`n")

## INTERPRETATION

The washer schema can classify multiple root-level files without acting on them.

The field test confirms the useful boundary:
classification is allowed; physical action is not.

The strongest repeated finding is that root location alone does not prove authority. The washer needs hash, role, authority state, suggested route, blocked actions, and proof need before any later move/routing executor can be considered.

## FINAL ROUTE

PARK_AS_SUPPORT_GUARDRAIL_WITH_MULTI_FILE_DRY_RUN_PROOF

## NEXT RECOMMENDED BUILD CHUNK

ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608

Purpose:
Create a read-only review queue from the multi-file dry-run cards so the user can decide what, if anything, should later become active source, support, old load, rough_local pointer, or cleanup candidate.

Still blocked:
- moves
- deletes
- renames
- route execution
- cleanup
- Git staging of full root files
- doctrine promotion
- active guide promotion
- current truth index rewrite

## DOESNOTPROVE

This field test does not prove any inspected file is safe, current, source authority, stale, cleanable, movable, deletable, routable, Git-safe, doctrine, active guide, current truth, or project complete.

## FINAL RETURN FIELDS

output_report_path:
$OutputPath

output_report_sha256:
TO_BE_FILLED_AFTER_CREATION

receipt_path:
$ReceiptPath

receipt_sha256:
TO_BE_FILLED_AFTER_CREATION

cards_folder:
$CardsFolder

cards_created_count:
$($Cards.Count)

schema_sha256_confirmed:
$SchemaHash

schema_dry_run_sha256_confirmed:
$SchemaDryRunHash

schema_receipt_sha256_confirmed:
$SchemaReceiptHash

schema_rough_local_sha256_confirmed:
$SchemaRoughLocalHash

schema_rough_local_receipt_sha256_confirmed:
$SchemaRoughLocalReceiptHash

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
ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608

final_verdict:
ROOT_DROP_INTAKE_WASHER_MULTI_FILE_FIELD_TEST_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $OutputPath -Text $ReportText
$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$ReceiptText = @"
ROOT_DROP_INTAKE_WASHER_MULTI_FILE_DRY_RUN_RECEIPT_20260608
Created: $Timestamp

output_report_path: $OutputPath
output_report_sha256: $OutputHash

cards_folder: $CardsFolder
cards_created_count: $($Cards.Count)

schema_path: $Schema
schema_sha256: $SchemaHash

schema_dry_run_sha256: $SchemaDryRunHash
schema_receipt_sha256: $SchemaReceiptHash
schema_rough_local_sha256: $SchemaRoughLocalHash
schema_rough_local_receipt_sha256: $SchemaRoughLocalReceiptHash

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
git_commit_or_push_done: NO

next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608
final_verdict: ROOT_DROP_INTAKE_WASHER_MULTI_FILE_FIELD_TEST_READY_WITH_SCOPE_LIMIT_NOTE
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

$ReportText = $ReportText.Replace("output_report_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`r`n$OutputHash")
$ReportText = $ReportText.Replace("output_report_sha256:`nTO_BE_FILLED_AFTER_CREATION", "output_report_sha256:`n$OutputHash")
$ReportText = $ReportText.Replace("receipt_sha256:`r`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`r`n$ReceiptHash")
$ReportText = $ReportText.Replace("receipt_sha256:`nTO_BE_FILLED_AFTER_CREATION", "receipt_sha256:`n$ReceiptHash")
Write-TextFile -Path $OutputPath -Text $ReportText

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

"=== ROOT DROP INTAKE WASHER MULTI-FILE FIELD TEST COMPLETE ==="
"output_report_path: $OutputPath"
"output_report_sha256: $FinalOutputHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"cards_folder: $CardsFolder"
"cards_created_count: $($Cards.Count)"
"schema_sha256_confirmed: $SchemaHash"
"schema_dry_run_sha256_confirmed: $SchemaDryRunHash"
"schema_receipt_sha256_confirmed: $SchemaReceiptHash"
"schema_rough_local_sha256_confirmed: $SchemaRoughLocalHash"
"schema_rough_local_receipt_sha256_confirmed: $SchemaRoughLocalReceiptHash"
"files_moved_count: 0"
"files_deleted_count: 0"
"files_renamed_count: 0"
"source_files_copied_count: 0"
"files_overwritten_count: 0"
"git_commit_or_push_done: NO"
"next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608"
"final_verdict: ROOT_DROP_INTAKE_WASHER_MULTI_FILE_FIELD_TEST_READY_WITH_SCOPE_LIMIT_NOTE"
