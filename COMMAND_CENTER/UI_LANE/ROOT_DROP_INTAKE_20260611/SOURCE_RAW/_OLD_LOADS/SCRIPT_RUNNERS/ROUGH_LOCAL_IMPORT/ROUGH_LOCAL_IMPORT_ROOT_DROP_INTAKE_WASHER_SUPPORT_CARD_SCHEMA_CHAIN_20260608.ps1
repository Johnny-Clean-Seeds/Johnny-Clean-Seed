$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$GitRepo = Join-Path $ProjectRoot "Jxhnny_Kl33N_Seedz"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$WasherRule = Join-Path $ProjectRoot "ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_1_20260608.md"
$SelectorReport = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_20260608.md"
$SelectorReceipt = Join-Path $Lane "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_ROOT_DROP_INTAKE_WASHER_GATE_RULE_RECEIPT_20260608.txt"
$Schema = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_20260608.md"
$DryRunCard = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_DRY_RUN__ROOT_DROP_RULE_20260608.md"
$SchemaReceipt = Join-Path $Lane "ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_AND_DRY_RUN_RECEIPT_20260608.txt"
$SafeTemplateRule = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_AND_STOP_ON_BLOCKER_RULE_CARD_20260608.md"
$SafeTemplateApply = Join-Path $Lane "GENERATED_RUNNER_SAFE_TEMPLATE_RULE_CARD_FIELD_APPLY_TO_NEXT_RUNNER_V0_3_20260608.md"

$RoughLedger = Join-Path $Lane "ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_20260608.md"
$RoughReceipt = Join-Path $Lane "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_RECEIPT_20260608.txt"

$ImportDir = Join-Path $GitRepo "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN"

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

    $BlockerPath = Join-Path $Lane "BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_20260608.md"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $BlockerText = @"
# BLOCKER__ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_20260608

Created: $Timestamp

Reason:
$Reason

Detail:
$Detail

Final verdict:
BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_NOT_COMMITTED

DoesNotProve:
This blocker file does not prove the washer schema failed. It proves this bounded rough_local Git import stopped before valid completion.
"@

    Write-TextFile -Path $BlockerPath -Text $BlockerText
    $BlockerHash = (Get-FileHash -LiteralPath $BlockerPath -Algorithm SHA256).Hash

    ""
    "=== ROUGH_LOCAL IMPORT ROOT DROP INTAKE WASHER SCHEMA CHAIN BLOCKED ==="
    "blocker_path: $BlockerPath"
    "blocker_sha256: $BlockerHash"
    "reason: $Reason"
    "detail: $Detail"
    "final_verdict: BLOCKER_ROUGH_LOCAL_IMPORT_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_NOT_COMMITTED"
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

"=== ROUGH_LOCAL IMPORT: ROOT DROP INTAKE WASHER SUPPORT CARD SCHEMA CHAIN ==="

try {
    $WasherRuleHash = Require-Hash -Path $WasherRule -ExpectedSha256 "ADDC4E8A2DA3226660663DAF61801AC505ED5F417B624F3E2CF58024A59FD4A9" -Name "root-drop intake washer rule"
    $SelectorReportHash = Require-Hash -Path $SelectorReport -ExpectedSha256 "E04A18A9156CA14F72F06E0DA52D6D3D398403DCFF631632A1A4A4B1155618A9" -Name "root-drop selector report"
    $SelectorReceiptHash = Require-Hash -Path $SelectorReceipt -ExpectedSha256 "2EB4F22BFD7DCDA3D09E46037BE2B8AEEF66B76B7C95744BD470427C504A8698" -Name "root-drop selector receipt"
    $SchemaHash = Require-Hash -Path $Schema -ExpectedSha256 "3DABB1A98075F3FEF20A6B4F1042C49EE8024001227120D9E35C3DCE79A3F5D0" -Name "root-drop washer support card schema"
    $DryRunHash = Require-Hash -Path $DryRunCard -ExpectedSha256 "D4C259530B55406DCAD612FD0CF3E74DC04C1B18E425140C0AC8B7132B3C3A15" -Name "root-drop washer dry-run card"
    $SchemaReceiptHash = Require-Hash -Path $SchemaReceipt -ExpectedSha256 "70D9CAD70D21162A1143D5B074852AE2A66F34814F95D2E8A42502E8C3A283A2" -Name "root-drop washer schema/dry-run receipt"
    $SafeTemplateRuleHash = Require-Hash -Path $SafeTemplateRule -ExpectedSha256 "E0013BA267527AF2201B934E8AEEB55710835EF0CC3ECD78250729E6ECB8FB26" -Name "generated-runner safe-template rule card"
    $SafeTemplateApplyHash = Require-Hash -Path $SafeTemplateApply -ExpectedSha256 "CB29519867976D554AFCB3A498670C5CA816CABD5775010FD6F3040F32FCCEDA" -Name "safe-template V0_3 field-apply report"

    "local washer schema chain hashes verified: YES"

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
# ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_20260608

Status: ROUGH_LOCAL_HASH_LEDGER / GIT_SAFE_POINTER_CANDIDATE / SUPPORT_GUARDRAIL_POINTER / FULL_LOCAL_EVIDENCE_NOT_INCLUDED / NOT_DOCTRINE

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Nested Git repo:
$GitTop

Purpose:
Carry the root-drop intake washer support-card schema chain into Git as hash-truth without turning the washer into an executor.

Boundary:
Full local evidence remains local.
Git receives only this rough_local ledger, the local ledger receipt, and the Git import receipt.
No source file is moved.
No cleanup is authorized.
No routing is authorized.
No full evidence folder is staged.
No root file is staged by default.

Source chain:

01 root-drop intake washer rule:
$WasherRule
SHA256:
$WasherRuleHash

02 root-drop washer selector field-test report:
$SelectorReport
SHA256:
$SelectorReportHash

03 root-drop washer selector field-test receipt:
$SelectorReceipt
SHA256:
$SelectorReceiptHash

04 support-card schema:
$Schema
SHA256:
$SchemaHash

05 support-card dry-run card:
$DryRunCard
SHA256:
$DryRunHash

06 support-card schema/dry-run receipt:
$SchemaReceipt
SHA256:
$SchemaReceiptHash

07 generated-runner safe-template rule:
$SafeTemplateRule
SHA256:
$SafeTemplateRuleHash

08 safe-template V0_3 field-apply:
$SafeTemplateApply
SHA256:
$SafeTemplateApplyHash

Selector classification:
Primary planet: SATURN_GATE
Counterweight planet: MERCURY_GATE
Mechanical gates: Hash/Receipt Gate; Intake Gate; Boundary Gate; Proof Gate
Route: PARK_AS_SUPPORT_GUARDRAIL

Standing rule:
The root-drop washer is a read-only support guardrail unless a later proof path explicitly authorizes executor behavior.

Blocked by default:
- move
- delete
- rename
- route
- cleanup
- stage
- commit root object
- push
- source rewrite
- doctrine promotion
- active guide promotion
- current truth index rewrite

DoesNotProve:
This rough_local ledger does not prove the washer is active, complete, doctrine, current truth, an executor, cleanup authority, routing authority, Git authority, source authority, or project complete.
"@

    Write-TextFile -Path $RoughLedger -Text $LedgerText
    $RoughLedgerHash = (Get-FileHash -LiteralPath $RoughLedger -Algorithm SHA256).Hash

    $ReceiptText = @"
ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_RECEIPT_20260608
Created: $Timestamp

rough_local_ledger_path: $RoughLedger
rough_local_ledger_sha256: $RoughLedgerHash

washer_rule_sha256: $WasherRuleHash
selector_report_sha256: $SelectorReportHash
selector_receipt_sha256: $SelectorReceiptHash
schema_sha256: $SchemaHash
dry_run_card_sha256: $DryRunHash
schema_receipt_sha256: $SchemaReceiptHash
safe_template_rule_sha256: $SafeTemplateRuleHash
safe_template_field_apply_sha256: $SafeTemplateApplyHash

git_boundary: FULL_LOCAL_EVIDENCE_NOT_STAGED_BY_DEFAULT
git_safe_default: ROUGH_LOCAL_HASH_LEDGER_PLUS_IMPORT_RECEIPT

final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_READY
"@

    Write-TextFile -Path $RoughReceipt -Text $ReceiptText
    $RoughReceiptHash = (Get-FileHash -LiteralPath $RoughReceipt -Algorithm SHA256).Hash

    New-Item -ItemType Directory -Path $ImportDir -Force | Out-Null

    $ImportLedgerPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughLedger))
    $ImportReceiptLocalPath = Join-Path $ImportDir ([System.IO.Path]::GetFileName($RoughReceipt))
    $ImportPacketReceiptPath = Join-Path $ImportDir "ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_GIT_IMPORT_PACKET_RECEIPT_20260608.md"

    $ImportLedgerHash = Copy-FileSafe -Source $RoughLedger -Destination $ImportLedgerPath
    $ImportReceiptLocalHash = Copy-FileSafe -Source $RoughReceipt -Destination $ImportReceiptLocalPath

    if ($ImportLedgerHash -ne $RoughLedgerHash) {
        Write-BlockerAndExit -Reason "IMPORT_LEDGER_HASH_MISMATCH" -Detail "import=$ImportLedgerHash source=$RoughLedgerHash"
    }

    if ($ImportReceiptLocalHash -ne $RoughReceiptHash) {
        Write-BlockerAndExit -Reason "IMPORT_RECEIPT_HASH_MISMATCH" -Detail "import=$ImportReceiptLocalHash source=$RoughReceiptHash"
    }

    $ImportPacketReceiptText = @"
# ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_GIT_IMPORT_PACKET_RECEIPT_20260608

Status: GIT_SAFE_IMPORT_PACKET_RECEIPT / ROUGH_LOCAL_HASH_TRUTH / FULL_LOCAL_EVIDENCE_NOT_INCLUDED

Created: $Timestamp

Nested Git repo:
$GitTop

Import directory:
$ImportDir

Imported Git-safe files:

01 ROUGH_LOCAL__ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_20260608.md
SHA256:
$RoughLedgerHash

02 ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_RECEIPT_20260608.txt
SHA256:
$RoughReceiptHash

Boundary:
Full root-drop intake washer local evidence remains local.
Git receives only the rough_local hash truth packet.

DoesNotProve:
This import packet does not include full local evidence, root object content as authority, doctrine, active guides, current truth index, cleanup approval, routing approval, mutation authority, or project completion.
"@

    Write-TextFile -Path $ImportPacketReceiptPath -Text $ImportPacketReceiptText
    $ImportPacketReceiptHash = (Get-FileHash -LiteralPath $ImportPacketReceiptPath -Algorithm SHA256).Hash

    $ImportedPaths = @($ImportLedgerPath, $ImportReceiptLocalPath, $ImportPacketReceiptPath)
    $RelTargets = @()

    foreach ($p in $ImportedPaths) {
        $RelTargets += [System.IO.Path]::GetRelativePath($GitTop, $p).Replace("\","/")
    }

    "=== STAGING EXACT ROOT-DROP WASHER ROUGH_LOCAL IMPORT PACKET ==="

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
        "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_ALREADY_PRESENT_NO_COMMIT_NEEDED"
        exit 0
    }

    "=== EXACT STAGED SET CONFIRMED ==="
    $Staged

    $CommitMessage = "Add root drop washer rough local ledger"

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
    "=== ROOT-DROP WASHER ROUGH_LOCAL IMPORT COMMITTED ==="
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
    "next_build_chunk_selected: ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_FIELD_TEST_ON_MORE_THAN_ONE_FILE_20260608"
    "final_verdict: ROUGH_LOCAL_ROOT_DROP_INTAKE_WASHER_SUPPORT_CARD_SCHEMA_CHAIN_COMMITTED_TO_NESTED_REPO"
}
catch {
    Write-BlockerAndExit -Reason "UNHANDLED_EXCEPTION" -Detail $_.Exception.Message
}
