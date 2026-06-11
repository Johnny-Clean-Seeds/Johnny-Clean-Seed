$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$GitRepo = Join-Path $ProjectRoot "Jxhnny_Kl33N_Seedz"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$CloseoutCard = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.md"
$CloseoutReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_RECEIPT_20260608.txt"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueSummary = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_SUMMARY_AND_OPTION_SET_20260608.md"

$HelperRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$SourceRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SupportRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"
$OldSystemRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.md"

$SupportFreeze = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE__20260608\ERROR_FREEZE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE_20260608.md"
$OldSystemFreeze = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW__20260608\ERROR_FREEZE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW_20260608.md"

$RoughLedger = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.md"
$RoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_RECEIPT_20260608.txt"

$ImportDir = Join-Path $GitRepo "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_NOT_COMMITTED

DoesNotProve:
This blocker file does not prove the queue closeout failed. It proves this bounded rough_local Git import stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROUGH_LOCAL IMPORT ROOT DROP WASHER QUEUE CLOSEOUT BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_NOT_COMMITTED"
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

"=== ROUGH_LOCAL IMPORT: ROOT DROP INTAKE WASHER QUEUE CLOSEOUT ==="

try {
    $CloseoutCardHash = Require-Hash -Path $CloseoutCard -ExpectedSha256 "A5136F34466F5B480409C62B1BC212FA93195D80500C63F606F8AC8801747A51" -Name "queue closeout card"
    $CloseoutReceiptHash = Require-Hash -Path $CloseoutReceipt -ExpectedSha256 "8F7ECF520CFA44A71FB43729A58A93075EF195604A27EF8EFA1EDE2735952CB4" -Name "queue closeout receipt"

    $QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "review queue"
    $QueueSummaryHash = Require-Hash -Path $QueueSummary -ExpectedSha256 "BD659A643AE3865FAB2FCEB0DC7C1700BBE4EF4F26D3803C6E0FB52127D61869" -Name "review queue summary"

    $HelperRoughHash = Require-Hash -Path $HelperRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper rough_local"
    $SourceRoughHash = Require-Hash -Path $SourceRough -ExpectedSha256 "7BAE7F5EA6B1673BDFF91F13BE4981D26871E99B65C944E371D5E15220843FCA" -Name "source rough_local"
    $SupportRoughHash = Require-Hash -Path $SupportRough -ExpectedSha256 "6C649C373DBC910D5E6B4F7BFCB0393330FC042DE7692D8F844E2592F58816D9" -Name "support rough_local"
    $OldSystemRoughHash = Require-Hash -Path $OldSystemRough -ExpectedSha256 "6336441DBE5255B09FD0FF4B9245381E6279E3D93F595680051CA91A97F27D96" -Name "old/system rough_local"

    $SupportFreezeHash = Require-Hash -Path $SupportFreeze -ExpectedSha256 "A871B1A2557061B0FB6C6AE5F56A05076CACEC65EDC8B0ECC11FD90063F0D642" -Name "support failure freeze"
    $OldSystemFreezeHash = Require-Hash -Path $OldSystemFreeze -ExpectedSha256 "0EA466DC840BD32F49B4D632BCE3C0F683A402761CF2AD7011C0797764D900F9" -Name "old/system failure freeze"

    "local closeout hashes verified: YES"

    if (-not (Test-Path -LiteralPath $GitRepo -PathType Container)) {
        Write-BlockerAndExit -Reason "MISSING_GIT_REPO_FOLDER" -Detail $GitRepo
    }

    $GitTop = (& git -C $GitRepo rev-parse --show-toplevel 2>$null)
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($GitTop)) {
        Write-BlockerAndExit -Reason "NESTED_FOLDER_NOT_GIT_WORKTREE" -Detail $GitRepo
    }

    $GitTop = $GitTop.Trim()
    "git_top: $GitTop"

    $CurrentHead = (& git -C $GitTop rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0 -or $CurrentHead -ne "26075496675f05fafccf50512deafda8f43568ca") {
        Write-BlockerAndExit -Reason "UNEXPECTED_GIT_HEAD" -Detail "actual=$CurrentHead expected=26075496675f05fafccf50512deafda8f43568ca"
    }

    $ExistingStaged = @(& git -C $GitTop diff --cached --name-only)
    if ($LASTEXITCODE -ne 0) {
        Write-BlockerAndExit -Reason "GIT_STAGED_CHECK_FAILED" -Detail "git diff --cached --name-only failed"
    }

    if ($ExistingStaged.Count -gt 0) {
        Write-BlockerAndExit -Reason "EXISTING_STAGED_CHANGES" -Detail ($ExistingStaged -join "; ")
    }

    $PreStatus = @(& git -C $GitTop status --short)
    if ($LASTEXITCODE -ne 0) {
        Write-BlockerAndExit -Reason "PRE_IMPORT_STATUS_FAILED" -Detail "git status --short failed"
    }

    if ($PreStatus.Count -ne 0) {
        Write-BlockerAndExit -Reason "PRE_IMPORT_GIT_STATUS_NOT_CLEAN" -Detail ($PreStatus -join "; ")
    }

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $LedgerText = @"
# ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608

Status: ROUGH_LOCAL_HASH_LEDGER / GIT_SAFE_POINTER_CANDIDATE / QUEUE_CLOSEOUT_POINTER / FULL_QUEUE_EVIDENCE_NOT_INCLUDED / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Nested Git repo:
$GitTop

Pre-import Git HEAD:
$CurrentHead

Purpose:
Carry the root-drop intake washer queue closeout into Git as hash-truth without importing full queue evidence, review cards, incident folders, helper files, support files, old/system files, or the full active source object.

Boundary:
Full evidence remains local.
Git receives only this rough_local ledger, the local ledger receipt, and the Git import packet receipt.

Closeout chain:

01 queue closeout card:
$CloseoutCard
SHA256:
$CloseoutCardHash

02 queue closeout receipt:
$CloseoutReceipt
SHA256:
$CloseoutReceiptHash

03 queue:
$Queue
SHA256:
$QueueHash

04 queue summary:
$QueueSummary
SHA256:
$QueueSummaryHash

05 helper rough_local:
$HelperRough
SHA256:
$HelperRoughHash

06 source rough_local:
$SourceRough
SHA256:
$SourceRoughHash

07 support rough_local:
$SupportRough
SHA256:
$SupportRoughHash

08 old/system rough_local:
$OldSystemRough
SHA256:
$OldSystemRoughHash

09 support failure freeze:
$SupportFreeze
SHA256:
$SupportFreezeHash

10 old/system failure freeze:
$OldSystemFreeze
SHA256:
$OldSystemFreezeHash

Queue accounting:
original_queue_items: 12
accounted_queue_items: 12
unaccounted_queue_items: 0
helper_items_accounted: 7
source_items_accounted: 1
support_items_accounted: 2
old_system_items_accounted: 2

Mutation accounting:
files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
cleanup_done: NO
full_file_git_import_done: NO
push_done: NO

Rough_local import commits already present before this closeout:
- helper option rough_local: 716436181fcdbf3703bb1f2b4c2ce633eadb3c7e
- source option rough_local: 747e5b18299a54e660c317d815f37cad91426412
- support option rough_local: 20d71dd747c61e644f30d5e2e1de84cfce187eda
- old/system option rough_local: 26075496675f05fafccf50512deafda8f43568ca

Next recommended after this import:
PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608

Blocked by default:
- cleanup
- delete
- move
- rename
- route
- restore missing file
- recreate missing file
- stage full helper files
- stage full support files
- stage full old/system files
- stage full source file
- commit full source/support/helper/old-system files
- push
- promote support to doctrine
- promote support to active guide
- treat support as executor
- source rewrite
- current truth index rewrite

DoesNotProve:
This rough_local ledger does not prove any candidate is safe to delete, safe to move, safe to route, safe to execute, active doctrine, active guide, executor authority, Git-safe as full content, or project complete. It only preserves the queue closeout as hash-truth pointer.
"@

    Write-TextFile -Path $RoughLedger -Text $LedgerText
    $RoughLedgerHash = (Get-FileHash -LiteralPath $RoughLedger -Algorithm SHA256).Hash

    $ReceiptText = @"
ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_RECEIPT_20260608
Created: $Timestamp

rough_local_ledger_path: $RoughLedger
rough_local_ledger_sha256: $RoughLedgerHash

closeout_card_sha256: $CloseoutCardHash
closeout_receipt_sha256: $CloseoutReceiptHash
queue_sha256: $QueueHash
queue_summary_sha256: $QueueSummaryHash
helper_rough_local_sha256: $HelperRoughHash
source_rough_local_sha256: $SourceRoughHash
support_rough_local_sha256: $SupportRoughHash
old_system_rough_local_sha256: $OldSystemRoughHash
support_failure_freeze_sha256: $SupportFreezeHash
old_system_failure_freeze_sha256: $OldSystemFreezeHash

original_queue_items: 12
accounted_queue_items: 12
unaccounted_queue_items: 0
helper_items_accounted: 7
source_items_accounted: 1
support_items_accounted: 2
old_system_items_accounted: 2

files_moved_count: 0
files_deleted_count: 0
files_renamed_count: 0
source_files_copied_count: 0
files_overwritten_count: 0
cleanup_done: NO
full_file_git_import_done: NO

git_boundary: FULL_QUEUE_EVIDENCE_NOT_STAGED_BY_DEFAULT
git_safe_default: ROUGH_LOCAL_HASH_LEDGER_PLUS_IMPORT_RECEIPT

next_build_chunk_selected: PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608
final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_READY
"@

    Write-TextFile -Path $RoughReceipt -Text $ReceiptText
    $RoughReceiptHash = (Get-FileHash -LiteralPath $RoughReceipt -Algorithm SHA256).Hash

    New-Item -ItemType Directory -Path $ImportDir -Force | Out-Null

    $ImportLedgerPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughLedger))
    $ImportReceiptLocalPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughReceipt))
    $ImportPacketReceiptPath = Join-Path $ImportDir "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

    $ImportLedgerHash = Copy-FileSafe -Source $RoughLedger -Destination $ImportLedgerPath
    $ImportReceiptLocalHash = Copy-FileSafe -Source $RoughReceipt -Destination $ImportReceiptLocalPath

    if ($ImportLedgerHash -ne $RoughLedgerHash) {
        Write-BlockerAndExit -Reason "IMPORT_LEDGER_HASH_MISMATCH" -Detail "import=$ImportLedgerHash source=$RoughLedgerHash"
    }

    if ($ImportReceiptLocalHash -ne $RoughReceiptHash) {
        Write-BlockerAndExit -Reason "IMPORT_RECEIPT_HASH_MISMATCH" -Detail "import=$ImportReceiptLocalHash source=$RoughReceiptHash"
    }

    $ImportPacketReceiptText = @"
# ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_GIT_IMPORT_PACKET_RECEIPT_20260608

Status: GIT_SAFE_IMPORT_PACKET_RECEIPT / ROUGH_LOCAL_HASH_TRUTH / QUEUE_CLOSEOUT_POINTER / FULL_QUEUE_EVIDENCE_NOT_INCLUDED

Created: $Timestamp

Nested Git repo:
$GitTop

Import directory:
$ImportDir

Imported Git-safe files:

01 ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608.md
SHA256:
$RoughLedgerHash

02 ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_RECEIPT_20260608.txt
SHA256:
$RoughReceiptHash

Boundary:
Full queue evidence remains local.
Review cards remain local.
Incident evidence remains local.
Full helper/source/support/old-system files remain out of Git unless explicitly approved.
Git receives only the rough_local hash truth packet.

DoesNotProve:
This import packet does not include full queue evidence, cleanup approval, deletion approval, routing approval, active support promotion, doctrine, active guides, executor authority, mutation authority, or project completion.
"@

    Write-TextFile -Path $ImportPacketReceiptPath -Text $ImportPacketReceiptText
    $ImportPacketReceiptHash = (Get-FileHash -LiteralPath $ImportPacketReceiptPath -Algorithm SHA256).Hash

    $ImportedPaths = @($ImportLedgerPath, $ImportReceiptLocalPath, $ImportPacketReceiptPath)
    $RelTargets = @()

    foreach ($p in $ImportedPaths) {
        $RelTargets += [System.IO.Path]::GetRelativePath($GitTop, $p).Replace("\","/")
    }

    "=== STAGING EXACT ROOT-DROP WASHER QUEUE CLOSEOUT ROUGH_LOCAL IMPORT PACKET ==="

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
        "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_ALREADY_PRESENT_NO_COMMIT_NEEDED"
        exit 0
    }

    "=== EXACT STAGED SET CONFIRMED ==="
    $Staged

    $CommitMessage = "Add root drop washer queue closeout rough local ledger"

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
    "=== ROOT-DROP WASHER QUEUE CLOSEOUT ROUGH_LOCAL IMPORT COMMITTED ==="
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
    "next_build_chunk_selected: PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_20260608"
    "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_COMMITTED_TO_NESTED_REPO"
}
catch {
    Write-BlockerAndExit -Reason "UNHANDLED_EXCEPTION" -Detail $_.Exception.Message
}
