$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$GitRepo = Join-Path $ProjectRoot "Jxhnny_Kl33N_Seedz"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$SupportOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.md"
$SupportOptionSetReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"

$SupportReviewReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$SupportReviewReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"

$SourceOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SourceOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"

$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"

$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$V01Freeze = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE__20260608\ERROR_FREEZE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE_20260608.md"
$V02FixNote = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE__20260608\FIX_NOTE__SUPPORT_OPTION_SET_V0_2_ARRAY_WRAP_20260608.md"
$IncidentReceipt = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE__20260608\HASH_RECEIPT__SUPPORT_OPTION_SET_V0_2_FIX_20260608.txt"

$RoughLedger = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"
$RoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_RECEIPT_20260608.txt"

$ImportDir = Join-Path $GitRepo "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_NOT_COMMITTED

DoesNotProve:
This blocker file does not prove the support option set failed. It proves this bounded rough_local Git import stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROUGH_LOCAL IMPORT ROOT DROP WASHER SUPPORT OPTION SET V0_2 BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_NOT_COMMITTED"
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

"=== ROUGH_LOCAL IMPORT: ROOT DROP INTAKE WASHER SUPPORT CANDIDATE OPTION SET V0_2 ==="

try {
    $SupportOptionSetHash = Require-Hash -Path $SupportOptionSet -ExpectedSha256 "77853EF98286012AD8D294966CBB367C729172E69D55E3EBA2874E72A725FD4C" -Name "support candidate option set V0_2 output"
    $SupportOptionSetReceiptHash = Require-Hash -Path $SupportOptionSetReceipt -ExpectedSha256 "D3219945274CE514594A5F322A14E43AAC350E0A51D3FB978393D305463A16BF" -Name "support candidate option set V0_2 receipt"

    $V01FreezeHash = Require-Hash -Path $V01Freeze -ExpectedSha256 "A871B1A2557061B0FB6C6AE5F56A05076CACEC65EDC8B0ECC11FD90063F0D642" -Name "V0_1 scalar Count failure freeze"
    $V02FixNoteHash = Require-Hash -Path $V02FixNote -ExpectedSha256 "AC026B24260013E83289E36139296D57287111DE5F8DB9B99E31B86A3483123E" -Name "V0_2 array-wrap fix note"
    $IncidentReceiptHash = Require-Hash -Path $IncidentReceipt -ExpectedSha256 "01FC1F9CCE14DA3071A2534C57F5F0BFD7377B5BF77F19153EE5356760ABB9BF" -Name "V0_2 incident receipt"

    $SupportReviewReportHash = Require-Hash -Path $SupportReviewReport -ExpectedSha256 "56BC9E4F1720DA4CE8A1A0E0A976C2AA774AB45767F9B02F03E73E3C324EAFDB" -Name "support candidate review dry-run report"
    $SupportReviewReceiptHash = Require-Hash -Path $SupportReviewReceipt -ExpectedSha256 "946E0E16805091DF846D6F2273CAAE5DA79585B4D18F30ECD541435D73EC07D3" -Name "support candidate review dry-run receipt"

    $QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "root-drop washer review queue"
    $QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "root-drop washer review queue receipt"

    $SourceOptionSetHash = Require-Hash -Path $SourceOptionSet -ExpectedSha256 "F1A44A706670489D5715B1726449C3D6DD8DB83DE6E497C5D73982CC40DF775F" -Name "source option set"
    $SourceOptionRoughHash = Require-Hash -Path $SourceOptionRough -ExpectedSha256 "7BAE7F5EA6B1673BDFF91F13BE4981D26871E99B65C944E371D5E15220843FCA" -Name "source option rough_local ledger"

    $HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper option set"
    $HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper option rough_local ledger"

    $WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

    "local support option-set V0_2 hashes verified: YES"

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
# ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608

Status: ROUGH_LOCAL_HASH_LEDGER / GIT_SAFE_POINTER_CANDIDATE / SUPPORT_OPTION_SET_POINTER / V0_2_REPAIR_INCLUDED / FULL_SUPPORT_FILES_NOT_INCLUDED / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Nested Git repo:
$GitTop

Purpose:
Carry the repaired root-drop intake washer support-candidate option set into Git as hash-truth without importing full support files, full review cards, or the incident folder.

Boundary:
Full support files remain local.
Support review cards remain local.
Incident evidence remains local.
Git receives only this rough_local ledger, the local ledger receipt, and the Git import receipt.

Source chain:

01 support candidate option set V0_2:
$SupportOptionSet
SHA256:
$SupportOptionSetHash

02 support candidate option set V0_2 receipt:
$SupportOptionSetReceipt
SHA256:
$SupportOptionSetReceiptHash

03 V0_1 scalar Count failure freeze:
$V01Freeze
SHA256:
$V01FreezeHash

04 V0_2 array-wrap fix note:
$V02FixNote
SHA256:
$V02FixNoteHash

05 incident receipt:
$IncidentReceipt
SHA256:
$IncidentReceiptHash

06 support candidate review report:
$SupportReviewReport
SHA256:
$SupportReviewReportHash

07 support candidate review receipt:
$SupportReviewReceipt
SHA256:
$SupportReviewReceiptHash

08 root-drop washer review queue:
$Queue
SHA256:
$QueueHash

09 root-drop washer review queue receipt:
$QueueReceipt
SHA256:
$QueueReceiptHash

10 source option set:
$SourceOptionSet
SHA256:
$SourceOptionSetHash

11 source option rough_local:
$SourceOptionRough
SHA256:
$SourceOptionRoughHash

12 helper option set:
$HelperOptionSet
SHA256:
$HelperOptionSetHash

13 helper option rough_local:
$HelperOptionRough
SHA256:
$HelperOptionRoughHash

14 washer schema:
$WasherSchema
SHA256:
$WasherSchemaHash

Support option result:
support_candidates_reviewed: 2
support_guardrail_candidate_count: 1
support_candidate_pending_review_count: 1
selected_recommendation: KEEP_BOTH_AS_SUPPORT_CANDIDATES_WITH_NO_PROMOTION
promotion_done: NO

V0_1 failure result:
failure_family: GENERATED_RUNNER_SCALAR_COUNT_STRICTMODE
failed_line: if (`$GuardrailLines.Count -eq 0)
fix: array-wrap singleton/multiple/empty collections before `.Count`

Blocked by default:
- promote to doctrine
- promote to active guide
- treat as executor
- move
- delete
- rename
- route
- cleanup
- stage full support files
- commit full support files
- push
- source rewrite
- current truth index rewrite

DoesNotProve:
This rough_local ledger does not prove any support candidate is active support, doctrine, active guide, executor authority, cleanup authority, routing authority, Git-safe as full content, source authority, or project complete.
"@

    Write-TextFile -Path $RoughLedger -Text $LedgerText
    $RoughLedgerHash = (Get-FileHash -LiteralPath $RoughLedger -Algorithm SHA256).Hash

    $ReceiptText = @"
ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_RECEIPT_20260608
Created: $Timestamp

rough_local_ledger_path: $RoughLedger
rough_local_ledger_sha256: $RoughLedgerHash

support_option_set_sha256: $SupportOptionSetHash
support_option_set_receipt_sha256: $SupportOptionSetReceiptHash
v0_1_failure_freeze_sha256: $V01FreezeHash
v0_2_fix_note_sha256: $V02FixNoteHash
incident_receipt_sha256: $IncidentReceiptHash
support_review_report_sha256: $SupportReviewReportHash
support_review_receipt_sha256: $SupportReviewReceiptHash
queue_sha256: $QueueHash
queue_receipt_sha256: $QueueReceiptHash
source_option_set_sha256: $SourceOptionSetHash
source_option_rough_local_sha256: $SourceOptionRoughHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
washer_schema_sha256: $WasherSchemaHash

support_candidates_reviewed: 2
support_guardrail_candidate_count: 1
support_candidate_pending_review_count: 1
selected_recommendation: KEEP_BOTH_AS_SUPPORT_CANDIDATES_WITH_NO_PROMOTION
promotion_done: NO

git_boundary: FULL_SUPPORT_FILES_NOT_STAGED_BY_DEFAULT
git_safe_default: ROUGH_LOCAL_HASH_LEDGER_PLUS_IMPORT_RECEIPT

final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_READY
"@

    Write-TextFile -Path $RoughReceipt -Text $ReceiptText
    $RoughReceiptHash = (Get-FileHash -LiteralPath $RoughReceipt -Algorithm SHA256).Hash

    New-Item -ItemType Directory -Path $ImportDir -Force | Out-Null

    $ImportLedgerPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughLedger))
    $ImportReceiptLocalPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughReceipt))
    $ImportPacketReceiptPath = Join-Path $ImportDir "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

    $ImportLedgerHash = Copy-FileSafe -Source $RoughLedger -Destination $ImportLedgerPath
    $ImportReceiptLocalHash = Copy-FileSafe -Source $RoughReceipt -Destination $ImportReceiptLocalPath

    if ($ImportLedgerHash -ne $RoughLedgerHash) {
        Write-BlockerAndExit -Reason "IMPORT_LEDGER_HASH_MISMATCH" -Detail "import=$ImportLedgerHash source=$RoughLedgerHash"
    }

    if ($ImportReceiptLocalHash -ne $RoughReceiptHash) {
        Write-BlockerAndExit -Reason "IMPORT_RECEIPT_HASH_MISMATCH" -Detail "import=$ImportReceiptLocalHash source=$RoughReceiptHash"
    }

    $ImportPacketReceiptText = @"
# ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608

Status: GIT_SAFE_IMPORT_PACKET_RECEIPT / ROUGH_LOCAL_HASH_TRUTH / SUPPORT_OPTION_SET_POINTER / FULL_SUPPORT_FILES_NOT_INCLUDED

Created: $Timestamp

Nested Git repo:
$GitTop

Import directory:
$ImportDir

Imported Git-safe files:

01 ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md
SHA256:
$RoughLedgerHash

02 ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_RECEIPT_20260608.txt
SHA256:
$RoughReceiptHash

Boundary:
Full support files remain local.
Support review cards remain local.
Incident evidence remains local.
Git receives only the rough_local hash truth packet.

DoesNotProve:
This import packet does not include full support files, active support promotion, doctrine, active guides, executor authority, cleanup approval, routing approval, mutation authority, or project completion.
"@

    Write-TextFile -Path $ImportPacketReceiptPath -Text $ImportPacketReceiptText
    $ImportPacketReceiptHash = (Get-FileHash -LiteralPath $ImportPacketReceiptPath -Algorithm SHA256).Hash

    $ImportedPaths = @($ImportLedgerPath, $ImportReceiptLocalPath, $ImportPacketReceiptPath)
    $RelTargets = @()

    foreach ($p in $ImportedPaths) {
        $RelTargets += [System.IO.Path]::GetRelativePath($GitTop, $p).Replace("\","/")
    }

    "=== STAGING EXACT ROOT-DROP WASHER SUPPORT OPTION SET V0_2 ROUGH_LOCAL IMPORT PACKET ==="

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
        "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_ALREADY_PRESENT_NO_COMMIT_NEEDED"
        exit 0
    }

    "=== EXACT STAGED SET CONFIRMED ==="
    $Staged

    $CommitMessage = "Add root drop washer support option rough local ledger"

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
    "=== ROOT-DROP WASHER SUPPORT OPTION SET V0_2 ROUGH_LOCAL IMPORT COMMITTED ==="
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
    "next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608"
    "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_COMMITTED_TO_NESTED_REPO"
}
catch {
    Write-BlockerAndExit -Reason "UNHANDLED_EXCEPTION" -Detail $_.Exception.Message
}
