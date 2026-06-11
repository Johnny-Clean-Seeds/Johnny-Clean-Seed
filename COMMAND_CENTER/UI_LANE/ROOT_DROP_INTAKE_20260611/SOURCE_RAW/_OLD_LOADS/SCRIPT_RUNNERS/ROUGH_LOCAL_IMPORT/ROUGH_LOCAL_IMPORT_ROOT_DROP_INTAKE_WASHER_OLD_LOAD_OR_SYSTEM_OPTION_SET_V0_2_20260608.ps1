$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$GitRepo = Join-Path $ProjectRoot "Jxhnny_Kl33N_Seedz"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$OldSystemOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.md"
$OldSystemOptionSetReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_RECEIPT_V0_2_20260608.txt"

$OldSystemReviewReport = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608.md"
$OldSystemReviewReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_RECEIPT_20260608.txt"

$OldSystemFreeze = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW__20260608\ERROR_FREEZE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW_20260608.md"
$OldSystemFixNote = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW__20260608\FIX_NOTE__OLD_SYSTEM_REVIEW_V0_2_MISSING_AT_REVIEW_RECORD_20260608.md"
$OldSystemIncidentReceipt = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW__20260608\HASH_RECEIPT__OLD_SYSTEM_REVIEW_V0_2_FIX_20260608.txt"

$Queue = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_20260608.md"
$QueueReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_REVIEW_QUEUE_FROM_MULTI_FILE_DRY_RUN_RECEIPT_20260608.txt"

$SupportOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.md"
$SupportOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_V0_2_20260608.md"

$SourceOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"
$SourceOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SOURCE_AUTHORITY_CANDIDATE_OPTION_SET_20260608.md"

$HelperOptionSet = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"
$HelperOptionRough = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_HELPER_CANDIDATE_OPTION_SET_20260608.md"

$WasherSchema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"

$RoughLedger = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.md"
$RoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_RECEIPT_20260608.txt"

$ImportDir = Join-Path $GitRepo "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_NOT_COMMITTED

DoesNotProve:
This blocker file does not prove the old/system option set failed. It proves this bounded rough_local Git import stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROUGH_LOCAL IMPORT ROOT DROP WASHER OLD/SYSTEM OPTION SET V0_2 BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_NOT_COMMITTED"
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

"=== ROUGH_LOCAL IMPORT: ROOT DROP INTAKE WASHER OLD LOAD OR SYSTEM OPTION SET V0_2 ==="

try {
    $OldSystemOptionSetHash = Require-Hash -Path $OldSystemOptionSet -ExpectedSha256 "F10A98EFC3E8D16AFA83807669631473267E40E4BCA35899AE6924F8430BCC4D" -Name "old/system option set V0_2"
    $OldSystemOptionSetReceiptHash = Require-Hash -Path $OldSystemOptionSetReceipt -ExpectedSha256 "57D65B525010C919698778F883814892D6570088CC71B8FE92390570C8ACE9DA" -Name "old/system option set V0_2 receipt"

    $OldSystemReviewReportHash = Require-Hash -Path $OldSystemReviewReport -ExpectedSha256 "A572A9510D84402B285C3B6D7CEE74676F4CA315D6519323B8818300B400F571" -Name "old/system review dry-run V0_2 report"
    $OldSystemReviewReceiptHash = Require-Hash -Path $OldSystemReviewReceipt -ExpectedSha256 "9138F329F22179CB95EEF0767B6EFDDB54FC38CA799B8D22D35193802D26B46D" -Name "old/system review dry-run V0_2 receipt"

    $OldSystemFreezeHash = Require-Hash -Path $OldSystemFreeze -ExpectedSha256 "0EA466DC840BD32F49B4D632BCE3C0F683A402761CF2AD7011C0797764D900F9" -Name "old/system V0_1 failure freeze"
    $OldSystemFixNoteHash = Require-Hash -Path $OldSystemFixNote -ExpectedSha256 "9468B560DB0CE77AC88F38391D41C9FE0EC2BC5524F576F6141EF1D628482DA9" -Name "old/system V0_2 fix note"
    $OldSystemIncidentReceiptHash = Require-Hash -Path $OldSystemIncidentReceipt -ExpectedSha256 "9E14CD3C696A5A254AC227BBBCFCB83F8CC70E8064D92DBF214AA37AE0EF6F5D" -Name "old/system incident receipt"

    $QueueHash = Require-Hash -Path $Queue -ExpectedSha256 "5DA3E1C62606B97ACD21391A7704FA10D9C10EE1EE614FCD955956D6954070FD" -Name "root-drop washer review queue"
    $QueueReceiptHash = Require-Hash -Path $QueueReceipt -ExpectedSha256 "DF1D8F35CA5EF9C17FA9F4BB7BA5C4102AB8521296BE932E760B49545DAE24AF" -Name "root-drop washer review queue receipt"

    $SupportOptionSetHash = Require-Hash -Path $SupportOptionSet -ExpectedSha256 "77853EF98286012AD8D294966CBB367C729172E69D55E3EBA2874E72A725FD4C" -Name "support option set V0_2"
    $SupportOptionRoughHash = Require-Hash -Path $SupportOptionRough -ExpectedSha256 "6C649C373DBC910D5E6B4F7BFCB0393330FC042DE7692D8F844E2592F58816D9" -Name "support option rough_local V0_2"

    $SourceOptionSetHash = Require-Hash -Path $SourceOptionSet -ExpectedSha256 "F1A44A706670489D5715B1726449C3D6DD8DB83DE6E497C5D73982CC40DF775F" -Name "source option set"
    $SourceOptionRoughHash = Require-Hash -Path $SourceOptionRough -ExpectedSha256 "7BAE7F5EA6B1673BDFF91F13BE4981D26871E99B65C944E371D5E15220843FCA" -Name "source option rough_local"

    $HelperOptionSetHash = Require-Hash -Path $HelperOptionSet -ExpectedSha256 "E51EE8D26AC928AE23FBB46459C8FAFF28E66E67B60E88ECDD6BB1A7066770E8" -Name "helper option set"
    $HelperOptionRoughHash = Require-Hash -Path $HelperOptionRough -ExpectedSha256 "1471518275D8355E631ACE084CCFFA275BD30DCAA650103CE4E1ADEBB2CA9D00" -Name "helper option rough_local"

    $WasherSchemaHash = Require-Hash -Path $WasherSchema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "washer schema"

    "local old/system option-set V0_2 hashes verified: YES"

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
# ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608

Status: ROUGH_LOCAL_HASH_LEDGER / GIT_SAFE_POINTER_CANDIDATE / OLD_SYSTEM_OPTION_SET_POINTER / FULL_OLD_SYSTEM_FILES_NOT_INCLUDED / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Nested Git repo:
$GitTop

Purpose:
Carry the repaired root-drop intake washer old-load/system option set into Git as hash-truth without importing full old/system files, full review cards, or the incident folder.

Boundary:
Full old/system files remain local.
Old/system review cards remain local.
Incident evidence remains local.
Git receives only this rough_local ledger, the local ledger receipt, and the Git import receipt.

Source chain:

01 old/system option set V0_2:
$OldSystemOptionSet
SHA256:
$OldSystemOptionSetHash

02 old/system option set V0_2 receipt:
$OldSystemOptionSetReceipt
SHA256:
$OldSystemOptionSetReceiptHash

03 old/system review report V0_2:
$OldSystemReviewReport
SHA256:
$OldSystemReviewReportHash

04 old/system review receipt V0_2:
$OldSystemReviewReceipt
SHA256:
$OldSystemReviewReceiptHash

05 V0_1 desktop.ini failure freeze:
$OldSystemFreeze
SHA256:
$OldSystemFreezeHash

06 V0_2 missing-at-review fix note:
$OldSystemFixNote
SHA256:
$OldSystemFixNoteHash

07 old/system incident receipt:
$OldSystemIncidentReceipt
SHA256:
$OldSystemIncidentReceiptHash

08 review queue:
$Queue
SHA256:
$QueueHash

09 review queue receipt:
$QueueReceipt
SHA256:
$QueueReceiptHash

10 support option set V0_2:
$SupportOptionSet
SHA256:
$SupportOptionSetHash

11 support option rough_local V0_2:
$SupportOptionRough
SHA256:
$SupportOptionRoughHash

12 source option set:
$SourceOptionSet
SHA256:
$SourceOptionSetHash

13 source option rough_local:
$SourceOptionRough
SHA256:
$SourceOptionRoughHash

14 helper option set:
$HelperOptionSet
SHA256:
$HelperOptionSetHash

15 helper option rough_local:
$HelperOptionRough
SHA256:
$HelperOptionRoughHash

16 washer schema:
$WasherSchema
SHA256:
$WasherSchemaHash

Old/system option result:
old_system_candidates_reviewed: 2
system_metadata_candidate_count: 1
zero_byte_old_load_candidate_count: 1
selected_recommendation: LEAVE_ALL_OLD_SYSTEM_CANDIDATES_IN_PLACE_WITH_NO_CLEANUP
cleanup_done: NO

V0_1 failure result:
failure_family: OLD_SYSTEM_REVIEW_MISSING_AT_REVIEW_TIME
failed_item: C:\Users\13527\Desktop\123\desktop.ini
fix: V0_2 records missing-at-review-time/present-at-review-time as custody state instead of crashing

Blocked by default:
- cleanup
- delete
- move
- rename
- route
- restore missing file
- recreate missing file
- classify as trash
- system-file deletion
- proof/history deletion
- stage full old/system files
- commit full old/system files
- push
- source rewrite
- current truth index rewrite

DoesNotProve:
This rough_local ledger does not prove any old/system candidate is trash, stale, safe to delete, safe to restore, safe to move, safe to route, Git-safe as full content, doctrine, active guide, source authority, or project complete.
"@

    Write-TextFile -Path $RoughLedger -Text $LedgerText
    $RoughLedgerHash = (Get-FileHash -LiteralPath $RoughLedger -Algorithm SHA256).Hash

    $ReceiptText = @"
ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_RECEIPT_20260608
Created: $Timestamp

rough_local_ledger_path: $RoughLedger
rough_local_ledger_sha256: $RoughLedgerHash

old_system_option_set_sha256: $OldSystemOptionSetHash
old_system_option_set_receipt_sha256: $OldSystemOptionSetReceiptHash
old_system_review_report_sha256: $OldSystemReviewReportHash
old_system_review_receipt_sha256: $OldSystemReviewReceiptHash
v0_1_failure_freeze_sha256: $OldSystemFreezeHash
v0_2_fix_note_sha256: $OldSystemFixNoteHash
incident_receipt_sha256: $OldSystemIncidentReceiptHash
queue_sha256: $QueueHash
queue_receipt_sha256: $QueueReceiptHash
support_option_set_sha256: $SupportOptionSetHash
support_option_rough_local_sha256: $SupportOptionRoughHash
source_option_set_sha256: $SourceOptionSetHash
source_option_rough_local_sha256: $SourceOptionRoughHash
helper_option_set_sha256: $HelperOptionSetHash
helper_option_rough_local_sha256: $HelperOptionRoughHash
washer_schema_sha256: $WasherSchemaHash

old_system_candidates_reviewed: 2
system_metadata_candidate_count: 1
zero_byte_old_load_candidate_count: 1
selected_recommendation: LEAVE_ALL_OLD_SYSTEM_CANDIDATES_IN_PLACE_WITH_NO_CLEANUP
cleanup_done: NO

git_boundary: FULL_OLD_SYSTEM_FILES_NOT_STAGED_BY_DEFAULT
git_safe_default: ROUGH_LOCAL_HASH_LEDGER_PLUS_IMPORT_RECEIPT

final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_READY
"@

    Write-TextFile -Path $RoughReceipt -Text $ReceiptText
    $RoughReceiptHash = (Get-FileHash -LiteralPath $RoughReceipt -Algorithm SHA256).Hash

    New-Item -ItemType Directory -Path $ImportDir -Force | Out-Null

    $ImportLedgerPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughLedger))
    $ImportReceiptLocalPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughReceipt))
    $ImportPacketReceiptPath = Join-Path $ImportDir "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

    $ImportLedgerHash = Copy-FileSafe -Source $RoughLedger -Destination $ImportLedgerPath
    $ImportReceiptLocalHash = Copy-FileSafe -Source $RoughReceipt -Destination $ImportReceiptLocalPath

    if ($ImportLedgerHash -ne $RoughLedgerHash) {
        Write-BlockerAndExit -Reason "IMPORT_LEDGER_HASH_MISMATCH" -Detail "import=$ImportLedgerHash source=$RoughLedgerHash"
    }

    if ($ImportReceiptLocalHash -ne $RoughReceiptHash) {
        Write-BlockerAndExit -Reason "IMPORT_RECEIPT_HASH_MISMATCH" -Detail "import=$ImportReceiptLocalHash source=$RoughReceiptHash"
    }

    $ImportPacketReceiptText = @"
# ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_GIT_IMPORT_PACKET_RECEIPT_20260608

Status: GIT_SAFE_IMPORT_PACKET_RECEIPT / ROUGH_LOCAL_HASH_TRUTH / OLD_SYSTEM_OPTION_SET_POINTER / FULL_OLD_SYSTEM_FILES_NOT_INCLUDED

Created: $Timestamp

Nested Git repo:
$GitTop

Import directory:
$ImportDir

Imported Git-safe files:

01 ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_20260608.md
SHA256:
$RoughLedgerHash

02 ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_RECEIPT_20260608.txt
SHA256:
$RoughReceiptHash

Boundary:
Full old/system files remain local.
Old/system review cards remain local.
Incident evidence remains local.
Git receives only the rough_local hash truth packet.

DoesNotProve:
This import packet does not include full old/system files, cleanup approval, deletion approval, restore/recreate approval, active support promotion, doctrine, active guides, executor authority, routing approval, mutation authority, or project completion.
"@

    Write-TextFile -Path $ImportPacketReceiptPath -Text $ImportPacketReceiptText
    $ImportPacketReceiptHash = (Get-FileHash -LiteralPath $ImportPacketReceiptPath -Algorithm SHA256).Hash

    $ImportedPaths = @($ImportLedgerPath, $ImportReceiptLocalPath, $ImportPacketReceiptPath)
    $RelTargets = @()

    foreach ($p in $ImportedPaths) {
        $RelTargets += [System.IO.Path]::GetRelativePath($GitTop, $p).Replace("\","/")
    }

    "=== STAGING EXACT ROOT-DROP WASHER OLD/SYSTEM OPTION SET V0_2 ROUGH_LOCAL IMPORT PACKET ==="

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
        "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_ALREADY_PRESENT_NO_COMMIT_NEEDED"
        exit 0
    }

    "=== EXACT STAGED SET CONFIRMED ==="
    $Staged

    $CommitMessage = "Add root drop washer old system option rough local ledger"

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
    "=== ROOT-DROP WASHER OLD/SYSTEM OPTION SET V0_2 ROUGH_LOCAL IMPORT COMMITTED ==="
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
    "next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_QUEUE_CLOSEOUT_AND_NEXT_ACTION_CARD_20260608"
    "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_OPTION_SET_V0_2_COMMITTED_TO_NESTED_REPO"
}
catch {
    Write-BlockerAndExit -Reason "UNHANDLED_EXCEPTION" -Detail $_.Exception.Message
}
