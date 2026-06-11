$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$GitRepo = Join-Path $ProjectRoot "Jxhnny_Kl33N_Seedz"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$OptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$OptionSetReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"
$HelperReviewReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_20260608.md"
$HelperReviewReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_REVIEW_DRY_RUN_RECEIPT_20260608.txt"
$QueueSummary = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608.md"
$QueueSummaryReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_RECEIPT_20260608.txt"

$RoughLedger = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$RoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt"

$ImportDir = Join-Path $GitRepo "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_NOT_COMMITTED

DoesNotProve:
This blocker file does not prove the helper option set failed. It proves this bounded rough_local Git import stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROUGH_LOCAL IMPORT ROOT DROP WASHER HELPER OPTION SET BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_NOT_COMMITTED"
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

"=== ROUGH_LOCAL IMPORT: ROOT DROP INTAKE WASHER HELPER CANDIDATE OPTION SET ==="

try {
    $OptionSetHash = Require-Hash -Path $OptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper candidate option set"
    $OptionSetReceiptHash = Require-Hash -Path $OptionSetReceipt -ExpectedSha256 "41C7142E6E618BE77C5F40EB12D62F66A52CE2A5C180EB775FFA078AFEC52513" -Name "helper candidate option set receipt"
    $HelperReviewHash = Require-Hash -Path $HelperReviewReport -ExpectedSha256 "6F790D59EE2BDD05ABCEF99F4292EFEDAE58FEA64B3A28C3AB2BC41E950E5188" -Name "helper review dry-run report"
    $HelperReviewReceiptHash = Require-Hash -Path $HelperReviewReceipt -ExpectedSha256 "748B06757515A20C8C07974BC856EF1762B1AB81127196819742557E81976FE7" -Name "helper review dry-run receipt"
    $QueueSummaryHash = Require-Hash -Path $QueueSummary -ExpectedSha256 "BD659A643AE3865FAB2FCEB0DC7C1700BBE4EF4F26D3803C6E0FB52127D61869" -Name "queue summary/option set"
    $QueueSummaryReceiptHash = Require-Hash -Path $QueueSummaryReceipt -ExpectedSha256 "B43450672DF855F495B7492FD5DEA15961493EF1EC5C6BD12D8545DD2A7EE8FF" -Name "queue summary/option set receipt"

    "local helper option-set hashes verified: YES"

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
# ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608

Status: ROUGH_LOCAL_HASH_LEDGER / GIT_SAFE_POINTER_CANDIDATE / HELPER_OPTION_SET_POINTER / FULL_HELPER_FILES_NOT_INCLUDED / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Nested Git repo:
$GitTop

Purpose:
Carry the root-drop intake washer helper-candidate option set into Git as hash-truth without importing full helper scripts or review cards.

Boundary:
Full helper files remain local.
Helper review cards remain local.
Git receives only this rough_local ledger, the local ledger receipt, and the Git import receipt.
No helper script is staged as runnable authority.
No helper script was executed.
No cleanup or routing is authorized.

Source chain:

01 helper candidate option set:
$OptionSet
SHA256:
$OptionSetHash

02 helper candidate option set receipt:
$OptionSetReceipt
SHA256:
$OptionSetReceiptHash

03 helper candidate review dry-run report:
$HelperReviewReport
SHA256:
$HelperReviewHash

04 helper candidate review dry-run receipt:
$HelperReviewReceipt
SHA256:
$HelperReviewReceiptHash

05 review queue summary/option set:
$QueueSummary
SHA256:
$QueueSummaryHash

06 review queue summary/option set receipt:
$QueueSummaryReceipt
SHA256:
$QueueSummaryReceiptHash

Classification result:
helper_candidates_reviewed: 7
possible_current_runnable_candidates_count: 5
evidence_only_or_superseded_count: 2
risk_counts:
- SAFE_TEMPLATE_SHAPE_CANDIDATE: 5
- UNSAFE_OR_FAILURE_EVIDENCE_CANDIDATE: 2

Standing boundary:
Possible current helper candidate does not mean approved to run.

Required before any execution:
01 exact command review
02 expected output declared
03 blocker behavior confirmed
04 mutation authority if file operations exist
05 exact staged set if Git operations exist
06 explicit user approval

Blocked by default:
- execute helper
- move
- delete
- rename
- route
- cleanup
- stage full root helper files
- commit full root helper files
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

DoesNotProve:
This rough_local ledger does not prove any helper is safe, current, stale, superseded, executable, Git-safe, cleanup-safe, doctrine, active guide, current truth, source authority, or project complete.
"@

    Write-TextFile -Path $RoughLedger -Text $LedgerText
    $RoughLedgerHash = (Get-FileHash -LiteralPath $RoughLedger -Algorithm SHA256).Hash

    $ReceiptText = @"
ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_20260608
Created: $Timestamp

rough_local_ledger_path: $RoughLedger
rough_local_ledger_sha256: $RoughLedgerHash

option_set_sha256: $OptionSetHash
option_set_receipt_sha256: $OptionSetReceiptHash
helper_review_report_sha256: $HelperReviewHash
helper_review_receipt_sha256: $HelperReviewReceiptHash
queue_summary_sha256: $QueueSummaryHash
queue_summary_receipt_sha256: $QueueSummaryReceiptHash

helper_candidates_reviewed: 7
possible_current_runnable_candidates_count: 5
evidence_only_or_superseded_count: 2

git_boundary: FULL_HELPER_FILES_NOT_STAGED_BY_DEFAULT
git_safe_default: ROUGH_LOCAL_HASH_LEDGER_PLUS_IMPORT_RECEIPT

final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_READY
"@

    Write-TextFile -Path $RoughReceipt -Text $ReceiptText
    $RoughReceiptHash = (Get-FileHash -LiteralPath $RoughReceipt -Algorithm SHA256).Hash

    New-Item -ItemType Directory -Path $ImportDir -Force | Out-Null

    $ImportLedgerPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughLedger))
    $ImportReceiptLocalPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughReceipt))
    $ImportPacketReceiptPath = Join-Path $ImportDir "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

    $ImportLedgerHash = Copy-FileSafe -Source $RoughLedger -Destination $ImportLedgerPath
    $ImportReceiptLocalHash = Copy-FileSafe -Source $RoughReceipt -Destination $ImportReceiptLocalPath

    if ($ImportLedgerHash -ne $RoughLedgerHash) {
        Write-BlockerAndExit -Reason "IMPORT_LEDGER_HASH_MISMATCH" -Detail "import=$ImportLedgerHash source=$RoughLedgerHash"
    }

    if ($ImportReceiptLocalHash -ne $RoughReceiptHash) {
        Write-BlockerAndExit -Reason "IMPORT_RECEIPT_HASH_MISMATCH" -Detail "import=$ImportReceiptLocalHash source=$RoughReceiptHash"
    }

    $ImportPacketReceiptText = @"
# ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_GIT_IMPORT_PACKET_RECEIPT_20260608

Status: GIT_SAFE_IMPORT_PACKET_RECEIPT / ROUGH_LOCAL_HASH_TRUTH / FULL_HELPER_FILES_NOT_INCLUDED

Created: $Timestamp

Nested Git repo:
$GitTop

Import directory:
$ImportDir

Imported Git-safe files:

01 ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md
SHA256:
$RoughLedgerHash

02 ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_RECEIPT_20260608.txt
SHA256:
$RoughReceiptHash

Boundary:
Full helper files, helper review cards, and runnable scripts remain local.
Git receives only the rough_local hash truth packet.

DoesNotProve:
This import packet does not include full helper files, runnable authority, doctrine, active guides, current truth index, cleanup approval, routing approval, mutation authority, execution approval, or project completion.
"@

    Write-TextFile -Path $ImportPacketReceiptPath -Text $ImportPacketReceiptText
    $ImportPacketReceiptHash = (Get-FileHash -LiteralPath $ImportPacketReceiptPath -Algorithm SHA256).Hash

    $ImportedPaths = @($ImportLedgerPath, $ImportReceiptLocalPath, $ImportPacketReceiptPath)
    $RelTargets = @()

    foreach ($p in $ImportedPaths) {
        $RelTargets += [System.IO.Path]::GetRelativePath($GitTop, $p).Replace("\","/")
    }

    "=== STAGING EXACT ROOT-DROP WASHER HELPER OPTION SET ROUGH_LOCAL IMPORT PACKET ==="

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
        "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_ALREADY_PRESENT_NO_COMMIT_NEEDED"
        exit 0
    }

    "=== EXACT STAGED SET CONFIRMED ==="
    $Staged

    $CommitMessage = "Add root drop washer helper option rough local ledger"

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
    "=== ROOT-DROP WASHER HELPER OPTION SET ROUGH_LOCAL IMPORT COMMITTED ==="
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
    "next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_REVIEW_DRY_RUN_20260608"
    "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_COMMITTED_TO_NESTED_REPO"
}
catch {
    Write-BlockerAndExit -Reason "UNHANDLED_EXCEPTION" -Detail $_.Exception.Message
}
