$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$GitRepo = Join-Path $ProjectRoot "Jxhnny_Kl33N_Seedz"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$RuleCard = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md"
$RuleReceipt = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_RECEIPT_20260608.txt"
$FieldTestReport = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_GENERATED_RUNNER_DEFECT_FAMILY_20260608.md"
$FieldApplyReport = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_3_20260608.md"
$FieldApplyReceipt = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_RECEIPT_V0_3_20260608.txt"

$IncidentFolder = Join-Path $Lane "INCIDENTS\FREEZE_EVIDENCE__SAFE_TEMPLATE_FIELD_APPLY_SELF_CHECK_AND_COPY_PATH_CHAIN__20260608"
$FreezeV01 = Join-Path $IncidentFolder "ERROR_FREEZE__SAFE_TEMPLATE_FIELD_APPLY_V0_1_SELF_CHECK_FALSE_POSITIVE_20260608.md"
$FreezeV02 = Join-Path $IncidentFolder "ERROR_FREEZE__SAFE_TEMPLATE_FIELD_APPLY_V0_2_MISSING_PARENT_COPY_20260608.md"
$FixNoteV03 = Join-Path $IncidentFolder "FIX_NOTE__SAFE_TEMPLATE_FIELD_APPLY_V0_3_PARENT_FIRST_AND_CODE_AWARE_CHECK_20260608.md"

$RoughLedger = Join-Path $Lane "ROUGH_LOCAL__GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_20260608.md"
$RoughReceipt = Join-Path $Lane "ROUGH_LOCAL_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_RECEIPT_20260608.txt"

$ImportDir = Join-Path $GitRepo "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROUGH_LOCAL_IMPORT_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROUGH_LOCAL_IMPORT_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROUGH_LOCAL_IMPORT_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_NOT_COMMITTED

DoesNotProve:
This blocker file does not prove the rule card failed. It proves this bounded rough_local Git import stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROUGH_LOCAL IMPORT GENERATED RUNNER SAFE TEMPLATE RULE CARD CHAIN BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROUGH_LOCAL_IMPORT_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_NOT_COMMITTED"
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

"=== ROUGH_LOCAL IMPORT: GENERATED RUNNER SAFE TEMPLATE RULE CARD CHAIN ==="

try {
    $RuleHash = Require-Hash -Path $RuleCard -ExpectedSha256 "E0013BA267527AF2201B934E8AEEB55710835EF0CC3ECD78250729E6ECB8FB26" -Name "rule card"
    $RuleReceiptHash = Require-Hash -Path $RuleReceipt -ExpectedSha256 "13E18217CB7DE53B4C7749CB7D7D7AB454B3A8EB111A5167D3C384ABF75863F4" -Name "rule receipt"
    $FieldTestHash = Require-Hash -Path $FieldTestReport -ExpectedSha256 "4BCB354B10B28066AB4A78BF9861F6EDB9795A323362678BB97B175427AD99A0" -Name "selector field test report"
    $FieldApplyHash = Require-Hash -Path $FieldApplyReport -ExpectedSha256 "CB29519867976D554AFCB3A498670C5CA816CABD5775010FD6F3040F32FCCEDA" -Name "V0_3 field apply report"
    $FieldApplyReceiptHash = Require-Hash -Path $FieldApplyReceipt -ExpectedSha256 "A344FBF9C079A2AAE970B3D3BC9AF6179C890A998AC7AE9F9AFBF699B68E0DBE" -Name "V0_3 field apply receipt"
    $FreezeV01Hash = Require-Hash -Path $FreezeV01 -ExpectedSha256 "9DA8854834B56030309845DE0C567C5E9AD30EFC899361E38C8E36D734CAADE0" -Name "V0_1 false-positive freeze"
    $FreezeV02Hash = Require-Hash -Path $FreezeV02 -ExpectedSha256 "73CE0F2FB8BC8DA8C4CEFF6B5E1394DBD8C1E6147EB70C18CBC6F8ECA43A307C" -Name "V0_2 missing-parent freeze"
    $FixNoteV03Hash = Require-Hash -Path $FixNoteV03 -ExpectedSha256 "253EA8CC37C67E2E2BA05B5EBC9FE3D4C8A41DC7E9FA82A423BA2A3C537129A1" -Name "V0_3 fix note"

    "local rule-card chain hashes verified: YES"

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
# ROUGH_LOCAL__GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_20260608

Status: ROUGH_LOCAL_HASH_LEDGER / GIT_SAFE_POINTER_CANDIDATE / LOCAL_EVIDENCE_NOT_INCLUDED / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Nested Git repo:
$GitTop

Purpose:
Carry the generated-runner safe-template rule-card chain into Git as hash-truth without importing full local evidence.

Boundary:
Full local evidence remains local.
Git receives only this rough_local ledger, the local ledger receipt, and the Git import receipt.
No full incident folder is staged.
No failed runner copies are staged.
No raw logs are staged unless explicitly approved later.

Source chain:

01 generated-runner safe-template rule card:
$RuleCard
SHA256:
$RuleHash

02 generated-runner safe-template rule card receipt:
$RuleReceipt
SHA256:
$RuleReceiptHash

03 generated-runner defect-family selector field test:
$FieldTestReport
SHA256:
$FieldTestHash

04 V0_3 field-apply report:
$FieldApplyReport
SHA256:
$FieldApplyHash

05 V0_3 field-apply receipt:
$FieldApplyReceipt
SHA256:
$FieldApplyReceiptHash

06 V0_1 false-positive freeze:
$FreezeV01
SHA256:
$FreezeV01Hash

07 V0_2 missing-parent freeze:
$FreezeV02
SHA256:
$FreezeV02Hash

08 V0_3 fix note:
$FixNoteV03
SHA256:
$FixNoteV03Hash

Result:
The generated-runner safe-template rule card is locally built and field-applied through V0_3.

Key rules carried:
01 Use WriteAllText safe writer.
02 Create parent folders before writes.
03 Create parent folders before copies.
04 Stop hard on blockers.
05 Do not print success after blocker.
06 Do not claim COMMITTED without commit proof.
07 Use code-aware checks when checking code behavior.
08 Freeze failures before fixing them.
09 Preserve rough_local Git boundary.

DoesNotProve:
This rough_local ledger does not prove doctrine, global tool safety, all future generated runners, Git push state, source truth, current truth index, cleanup approval, routing approval, mutation authority, or project completion.
"@

    Write-TextFile -Path $RoughLedger -Text $LedgerText
    $RoughLedgerHash = (Get-FileHash -LiteralPath $RoughLedger -Algorithm SHA256).Hash

    $ReceiptText = @"
ROUGH_LOCAL_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_RECEIPT_20260608
Created: $Timestamp

rough_local_ledger_path: $RoughLedger
rough_local_ledger_sha256: $RoughLedgerHash

rule_card_sha256: $RuleHash
rule_receipt_sha256: $RuleReceiptHash
field_test_report_sha256: $FieldTestHash
field_apply_report_v0_3_sha256: $FieldApplyHash
field_apply_receipt_v0_3_sha256: $FieldApplyReceiptHash
v0_1_false_positive_freeze_sha256: $FreezeV01Hash
v0_2_missing_parent_freeze_sha256: $FreezeV02Hash
v0_3_fix_note_sha256: $FixNoteV03Hash

git_boundary: FULL_LOCAL_EVIDENCE_NOT_STAGED_BY_DEFAULT
git_safe_default: ROUGH_LOCAL_HASH_LEDGER_PLUS_IMPORT_RECEIPT

final_verdict: ROUGH_LOCAL_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_READY
"@

    Write-TextFile -Path $RoughReceipt -Text $ReceiptText
    $RoughReceiptHash = (Get-FileHash -LiteralPath $RoughReceipt -Algorithm SHA256).Hash

    New-Item -ItemType Directory -Path $ImportDir -Force | Out-Null

    $ImportLedgerPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughLedger))
    $ImportReceiptLocalPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughReceipt))
    $ImportPacketReceiptPath = Join-Path $ImportDir "ROUGH_LOCAL_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

    $ImportLedgerHash = Copy-FileSafe -Source $RoughLedger -Destination $ImportLedgerPath
    $ImportReceiptLocalHash = Copy-FileSafe -Source $RoughReceipt -Destination $ImportReceiptLocalPath

    if ($ImportLedgerHash -ne $RoughLedgerHash) {
        Write-BlockerAndExit -Reason "IMPORT_LEDGER_HASH_MISMATCH" -Detail "import=$ImportLedgerHash source=$RoughLedgerHash"
    }

    if ($ImportReceiptLocalHash -ne $RoughReceiptHash) {
        Write-BlockerAndExit -Reason "IMPORT_RECEIPT_HASH_MISMATCH" -Detail "import=$ImportReceiptLocalHash source=$RoughReceiptHash"
    }

    $ImportPacketReceiptText = @"
# ROUGH_LOCAL_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_GIT_IMPORT_PACKET_RECEIPT_20260608

Status: GIT_SAFE_IMPORT_PACKET_RECEIPT / ROUGH_LOCAL_HASH_TRUTH / FULL_LOCAL_EVIDENCE_NOT_INCLUDED

Created: $Timestamp

Nested Git repo:
$GitTop

Import directory:
$ImportDir

Imported Git-safe files:

01 ROUGH_LOCAL__GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_20260608.md
SHA256:
$RoughLedgerHash

02 ROUGH_LOCAL_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_RECEIPT_20260608.txt
SHA256:
$RoughReceiptHash

Boundary:
Full generated-runner safe-template incident evidence remains local.
Git receives only the rough_local hash truth packet.

DoesNotProve:
This import packet does not include full local evidence, failed script copies, fixed script copies, raw incident logs, doctrine, active guides, current truth index, cleanup approval, routing approval, mutation authority, or project completion.
"@

    Write-TextFile -Path $ImportPacketReceiptPath -Text $ImportPacketReceiptText
    $ImportPacketReceiptHash = (Get-FileHash -LiteralPath $ImportPacketReceiptPath -Algorithm SHA256).Hash

    $ImportedPaths = @($ImportLedgerPath, $ImportReceiptLocalPath, $ImportPacketReceiptPath)
    $RelTargets = @()

    foreach ($p in $ImportedPaths) {
        $RelTargets += [System.IO.Path]::GetRelativePath($GitTop, $p).Replace("\","/")
    }

    "=== STAGING EXACT SAFE-TEMPLATE ROUGH_LOCAL IMPORT PACKET ==="

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
        "final_verdict: ROUGH_LOCAL_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_ALREADY_PRESENT_NO_COMMIT_NEEDED"
        exit 0
    }

    "=== EXACT STAGED SET CONFIRMED ==="
    $Staged

    $CommitMessage = "Add generated runner safe template rough local ledger"

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
    "=== SAFE-TEMPLATE ROUGH_LOCAL IMPORT COMMITTED ==="
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
    "next_build_chunk_selected: SELECTOR_FIELD_TEST_NEXT_OBJECT"
    "final_verdict: ROUGH_LOCAL_GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_CHAIN_COMMITTED_TO_NESTED_REPO"
}
catch {
    Write-BlockerAndExit -Reason "UNHANDLED_EXCEPTION" -Detail $_.Exception.Message
}
