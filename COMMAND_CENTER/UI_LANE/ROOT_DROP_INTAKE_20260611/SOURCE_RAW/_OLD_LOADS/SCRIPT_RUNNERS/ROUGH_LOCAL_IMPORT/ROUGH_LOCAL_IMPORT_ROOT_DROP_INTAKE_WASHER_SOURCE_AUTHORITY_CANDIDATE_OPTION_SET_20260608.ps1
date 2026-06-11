$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$GitRepo = Join-Path $ProjectRoot "Jxhnny_Kl33N_Seedz"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$SourceOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SourceOptionSetReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$SourceReviewReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$SourceReviewReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$SourceReviewCard = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_CARD_20260608.md"
$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$SourceCandidate = Join-Path $ProjectRoot "PLANETARY_HOUSE_GATE_MASTER_INDEX_WITH_INTAKE_TOOLBELT_V0_3_RAW_COMBINED_WITH_GUARD_MEMBRANE_20260607.md"

$RoughLedger = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$RoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"

$ImportDir = Join-Path $GitRepo "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET"

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

function Copy-FileSafe {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        throw "MISSING_COPY_SOURCE: $Source"
    }

    Ensure-ParentFolder -Path $Destination
    Copy-Item -LiteralPath $Source -Destination $Destination -Force

    return (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash
}

function Write-BlockerAndExit {
    param(
        [string]$Reason,
        [string]$Detail
    )

    $BlockerPath = Join-Path $Lane "BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_NOT_COMMITTED

DoesNotProve:
This blocker file does not prove the source option set failed. It proves this bounded rough_local Git import stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROUGH_LOCAL IMPORT ROOT DROP WASHER SOURCE OPTION SET BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_NOT_COMMITTED"
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

"=== ROUGH_LOCAL IMPORT: ROOT DROP INTAKE WASHER SOURCE AUTHORITY OPTION SET ==="

try {
    $SourceOptionSetHash = Require-Hash -Path $SourceOptionSet -ExpectedSha256 "F1A44A706670489D5715B1726449C3D6DD8DB83DE6E497C5D73982CC40DF775F" -Name "source authority candidate option set"
    $SourceOptionSetReceiptHash = Require-Hash -Path $SourceOptionSetReceipt -ExpectedSha256 "9A42577D4BD29ECDDEDA19685891ECCE7F41ABF469346F792A5B416323CACE18" -Name "source authority candidate option set receipt"
    $SourceReviewReportHash = Require-Hash -Path $SourceReviewReport -ExpectedSha256 "D3813D05C3B9E1969F0A83FF84D528441E91A1430551E490D0194816FCA1D5D6" -Name "source authority candidate review report"
    $SourceReviewReceiptHash = Require-Hash -Path $SourceReviewReceipt -ExpectedSha256 "238E07D63A1A37C026EA5B932A4B5F8AF7B8878CAC22A9A86CF0038300CE9B36" -Name "source authority candidate review receipt"
    $SourceReviewCardHash = Require-Hash -Path $SourceReviewCard -ExpectedSha256 "C1961F1D3357218A2FB8D474C19F5E4489BDBFE1F16CA86F9FD0C7F244813F11" -Name "source authority candidate review card"
    $HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper candidate option set"
    $HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper candidate option rough_local ledger"
    $WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"
    $SourceCandidateHash = Require-Hash -Path $SourceCandidate -ExpectedSha256 "7F7B61C0915966EA3222587BA97B1ED8BCC47FC62739526B0542C557DA3156F7" -Name "known active source candidate"

    "local source option-set hashes verified: YES"

    if (-not (Test-Path -LiteralPath $GitRepo -PathType Container)) {
        Write-BlockerAndExit -Reason "MISSING_GIT_REPO_FOLDER" -Detail $GitRepo
    }

    $GitTop = (& git -C $GitRepo rev-parse --show-toplevel 2>$null)
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($GitTop)) {
        Write-BlockerAndExit -Reason "NESTED_FOLDER_NOT_GIT_WORKTREE" -Detail $GitRepo
    }

    $GitTop = $GitTop.Trim()
    "git_top: $GitTop"

    $ExistingStaged = @(& git -C $GitTop diff --cached --name-only)
    if ($LASTEXITCODE -ne 0) {
        Write-BlockerAndExit -Reason "GIT_STAGED_CHECK_FAILED" -Detail "git diff --cached --name-only failed"
    }

    if ($ExistingStaged.Count -gt 0) {
        Write-BlockerAndExit -Reason "EXISTING_STAGED_CHANGES" -Detail ($ExistingStaged -join "; ")
    }

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $LedgerText = @"
# ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608

Status: ROUGH_LOCAL_HASH_LEDGER / GIT_SAFE_POINTER_CANDIDATE / SOURCE_CUSTODY_POINTER / FULL_SOURCE_FILE_NOT_INCLUDED / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Nested Git repo:
$GitTop

Purpose:
Carry the root-drop intake washer source-authority candidate option set into Git as hash-truth without importing the full source object or creating a new source-promotion event.

Boundary:
Full source object remains local.
Git receives only this rough_local ledger, the local ledger receipt, and the Git import receipt.
No full source file is staged.
No source rewrite is authorized.
No current truth index rewrite is authorized.

Source chain:

01 source authority candidate option set:
$SourceOptionSet
SHA256:
$SourceOptionSetHash

02 source authority candidate option set receipt:
$SourceOptionSetReceipt
SHA256:
$SourceOptionSetReceiptHash

03 source authority candidate review report:
$SourceReviewReport
SHA256:
$SourceReviewReportHash

04 source authority candidate review receipt:
$SourceReviewReceipt
SHA256:
$SourceReviewReceiptHash

05 source authority candidate review card:
$SourceReviewCard
SHA256:
$SourceReviewCardHash

06 helper candidate option set:
$HelperOptionSet
SHA256:
$HelperOptionSetHash

07 helper candidate option rough_local ledger:
$HelperOptionRough
SHA256:
$HelperOptionRoughHash

08 washer schema:
$WasherSchema
SHA256:
$WasherSchemaHash

09 source candidate:
$SourceCandidate
SHA256:
$SourceCandidateHash

Source custody result:
matches_known_active_source_hash: TRUE
selected_recommendation: OPTION_A_CONFIRM_EXISTING_ACTIVE_SOURCE_CUSTODY_WITH_NO_REWRITE
source_promotion_done: NO
source_rewrite_done: NO
current_truth_index_rewrite_done: NO

Standing boundary:
Hash match confirms existing custody for this lane. It does not create a new promotion event and does not authorize source mutation.

Blocked by default:
- source promotion by location alone
- source promotion by name alone
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

DoesNotProve:
This rough_local ledger does not prove the source object is complete, correct, doctrine, active guide, safe to move, safe to route, safe to clean, Git-safe as full content, or project complete.
"@

    Write-TextFile -Path $RoughLedger -Text $LedgerText
    $RoughLedgerHash = (Get-FileHash -LiteralPath $RoughLedger -Algorithm SHA256).Hash

    $ReceiptText = @"
ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_20260608
Created: $Timestamp

rough_local_ledger_path: $RoughLedger
rough_local_ledger_sha256: $RoughLedgerHash

source_option_set_sha256: $SourceOptionSetHash
source_option_set_receipt_sha256: $SourceOptionSetReceiptHash
source_review_report_sha256: $SourceReviewReportHash
source_review_receipt_sha256: $SourceReviewReceiptHash
source_review_card_sha256: $SourceReviewCardHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
washer_schema_sha256: $WasherSchemaHash
source_candidate_sha256: $SourceCandidateHash

matches_known_active_source_hash: TRUE
selected_recommendation: OPTION_A_CONFIRM_EXISTING_ACTIVE_SOURCE_CUSTODY_WITH_NO_REWRITE
source_promotion_done: NO
source_rewrite_done: NO

git_boundary: FULL_SOURCE_FILE_NOT_STAGED_BY_DEFAULT
git_safe_default: ROUGH_LOCAL_HASH_LEDGER_PLUS_IMPORT_RECEIPT

final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_READY
"@

    Write-TextFile -Path $RoughReceipt -Text $ReceiptText
    $RoughReceiptHash = (Get-FileHash -LiteralPath $RoughReceipt -Algorithm SHA256).Hash

    New-Item -ItemType Directory -Path $ImportDir -Force | Out-Null

    $ImportLedgerPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughLedger))
    $ImportReceiptLocalPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughReceipt))
    $ImportPacketReceiptPath = Join-Path $ImportDir "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

    $ImportLedgerHash = Copy-FileSafe -Source $RoughLedger -Destination $ImportLedgerPath
    $ImportReceiptLocalHash = Copy-FileSafe -Source $RoughReceipt -Destination $ImportReceiptLocalPath

    if ($ImportLedgerHash -ne $RoughLedgerHash) {
        Write-BlockerAndExit -Reason "IMPORT_LEDGER_HASH_MISMATCH" -Detail "import=$ImportLedgerHash source=$RoughLedgerHash"
    }

    if ($ImportReceiptLocalHash -ne $RoughReceiptHash) {
        Write-BlockerAndExit -Reason "IMPORT_RECEIPT_HASH_MISMATCH" -Detail "import=$ImportReceiptLocalHash source=$RoughReceiptHash"
    }

    $ImportPacketReceiptText = @"
# ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_GIT_IMPORT_PACKET_RECEIPT_20260608

Status: GIT_SAFE_IMPORT_PACKET_RECEIPT / ROUGH_LOCAL_HASH_TRUTH / FULL_SOURCE_FILE_NOT_INCLUDED

Created: $Timestamp

Nested Git repo:
$GitTop

Import directory:
$ImportDir

Imported Git-safe files:

01 ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md
SHA256:
$RoughLedgerHash

02 ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt
SHA256:
$RoughReceiptHash

Boundary:
Full source object remains local.
Git receives only the rough_local hash truth packet.
No source-promotion event is created by this import.

DoesNotProve:
This import packet does not include the full source file, new source promotion, doctrine, active guides, current truth index rewrite, cleanup approval, routing approval, mutation authority, or project completion.
"@

    Write-TextFile -Path $ImportPacketReceiptPath -Text $ImportPacketReceiptText
    $ImportPacketReceiptHash = (Get-FileHash -LiteralPath $ImportPacketReceiptPath -Algorithm SHA256).Hash

    $ImportedPaths = @($ImportLedgerPath, $ImportReceiptLocalPath, $ImportPacketReceiptPath)
    $RelTargets = @()

    foreach ($p in $ImportedPaths) {
        $RelTargets += [System.IO.Path]::GetRelativePath($GitTop, $p).Replace("\","/")
    }

    "=== STAGING EXACT ROOT-DROP WASHER SOURCE OPTION SET ROUGH_LOCAL IMPORT PACKET ==="

    foreach ($rel in $RelTargets) {
        & git -C $GitTop add -- $rel
        if ($LASTEXITCODE -ne 0) {
            Write-BlockerAndExit -Reason "GIT_ADD_FAILED" -Detail $rel
        }
    }

    $Staged = @(& git -C $GitTop diff --cached --name-only)
    if ($LASTEXITCODE -ne 0) {
        Write-BlockerAndExit -Reason "GIT_STAGED_CHECK_FAILED_AFTER_ADD" -Detail "git diff --cached --name-only failed after add"
    }

    $expectedSorted = $RelTargets | Sort-Object
    $stagedSorted = $Staged | Sort-Object

    if (($expectedSorted -join "`n") -ne ($stagedSorted -join "`n")) {
        foreach ($rel in $RelTargets) {
            & git -C $GitTop reset -- $rel | Out-Null
        }

        Write-BlockerAndExit -Reason "STAGED_SET_NOT_EXACT" -Detail "Expected: $($expectedSorted -join '; ') Actual: $($stagedSorted -join '; ')"
    }

    if ($Staged.Count -eq 0) {
        ""
        "=== NO NEW GIT CHANGES ==="
        "rough_local_ledger_path: $RoughLedger"
        "rough_local_ledger_sha256: $RoughLedgerHash"
        "rough_local_receipt_path: $RoughReceipt"
        "rough_local_receipt_sha256: $RoughReceiptHash"
        "import_packet_receipt_sha256: $ImportPacketReceiptHash"
        "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_ALREADY_PRESENT_NO_COMMIT_NEEDED"
        exit 0
    }

    "=== EXACT STAGED SET CONFIRMED ==="
    $Staged

    $CommitMessage = "Add root drop washer source option rough local ledger"

    "=== COMMITTING ==="
    & git -C $GitTop commit -m $CommitMessage
    if ($LASTEXITCODE -ne 0) {
        Write-BlockerAndExit -Reason "GIT_COMMIT_FAILED" -Detail $CommitMessage
    }

    $CommitHash = (& git -C $GitTop rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($CommitHash)) {
        Write-BlockerAndExit -Reason "COMMIT_HASH_MISSING_AFTER_COMMIT" -Detail "git rev-parse HEAD failed or returned empty"
    }

    $StatusShort = @(& git -C $GitTop status --short)
    if ($LASTEXITCODE -ne 0) {
        Write-BlockerAndExit -Reason "POST_COMMIT_STATUS_FAILED" -Detail "git status --short failed"
    }

    ""
    "=== ROOT-DROP WASHER SOURCE OPTION SET ROUGH_LOCAL IMPORT COMMITTED ==="
    "commit_hash: $CommitHash"
    "commit_message: $CommitMessage"
    "files_committed_count: $($RelTargets.Count)"
    "files_committed:"
    $RelTargets
    ""
    "rough_local_ledger_path: $RoughLedger"
    "rough_local_ledger_sha256: $RoughLedgerHash"
    "rough_local_receipt_path: $RoughReceipt"
    "rough_local_receipt_sha256: $RoughReceiptHash"
    "import_packet_receipt_sha256: $ImportPacketReceiptHash"
    ""
    "post_commit_status_short:"
    if ($StatusShort.Count -eq 0) {
        "CLEAN"
    } else {
        $StatusShort
    }
    ""
    "next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_20260608"
    "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_COMMITTED_TO_NESTED_REPO"
}
catch {
    Write-BlockerAndExit -Reason "UNHANDLED_EXCEPTION" -Detail $_.Exception.Message
}
