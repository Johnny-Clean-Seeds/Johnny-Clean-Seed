$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$IncidentsRoot = Join-Path $Lane "INCIDENTS"
$IncidentFolder = Join-Path $IncidentsRoot "FREEZE_EVIDENCE__GENERATED_RUNNER_LINE_WRITER_DEEP_LAYER__20260608"

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

New-Item -ItemType Directory -Path $IncidentFolder -Force | Out-Null

function Write-TextFile {
    param(
        [string]$Path,
        [string]$Text
    )

    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    [System.IO.File]::WriteAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256OrMissing {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    }

    return "MISSING"
}

function New-UniquePath {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return $Path
    }

    $dir = Split-Path -Parent $Path
    $name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $ext = [System.IO.Path]::GetExtension($Path)

    for ($i = 2; $i -lt 100; $i++) {
        $candidate = Join-Path $dir ("{0}_V0_{1}{2}" -f $name, $i, $ext)
        if (-not (Test-Path -LiteralPath $candidate)) {
            return $candidate
        }
    }

    throw "Could not create unique path for $Path"
}

$OldFieldTestRunner = Join-Path ([Environment]::GetFolderPath("UserProfile")) "Downloads\RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1"
$FixedFieldTestRunner = Join-Path ([Environment]::GetFolderPath("UserProfile")) "Downloads\RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_V0_2_FREEZE_EVIDENCE_20260608.ps1"
$FailedGitFreezeRunner = Join-Path ([Environment]::GetFolderPath("UserProfile")) "Downloads\FREEZE_GIT_SNAPSHOT_NO_WORKTREE_AND_WRITE_FIXED_RUNNER_20260608.ps1"

$RulePath = Join-Path $Lane "GIT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_RULE_20260608.md"
$LedgerPath = Join-Path $Lane "ROUGH_LOCAL__FREEZE_EVIDENCE_POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608.md"
$BoundaryReceiptPath = Join-Path $Lane "GIT_ROUGH_LOCAL_BOUNDARY_FIX_RECEIPT_20260608.txt"

$ErrorFreezePath = New-UniquePath (Join-Path $IncidentFolder "ERROR_FREEZE__GENERATED_RUNNER_LINE_WRITER_DEEP_LAYER_20260608.md")
$DeepLayerReportPath = New-UniquePath (Join-Path $IncidentFolder "DEEP_LAYER_ROOT_CAUSE__GENERATED_RUNNER_LINE_WRITER_AND_FALSE_COMPLETE_20260608.md")
$FixNotePath = New-UniquePath (Join-Path $IncidentFolder "FIX_NOTE__SAFE_TEXT_WRITER_AND_STOP_ON_BLOCKER_PATTERN_20260608.md")
$CorrectedGitRunnerPath = New-UniquePath (Join-Path $Lane "RUN_BOUNDED_GIT_SNAPSHOT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_V0_3_STOP_ON_BLOCKER_SAFE_WRITER_20260608.ps1")
$ReceiptPath = New-UniquePath (Join-Path $IncidentFolder "HASH_RECEIPT__GENERATED_RUNNER_DEEP_LAYER_FREEZE_20260608.txt")

$OldFieldTestRunnerHash = Get-Sha256OrMissing $OldFieldTestRunner
$FixedFieldTestRunnerHash = Get-Sha256OrMissing $FixedFieldTestRunner
$FailedGitFreezeRunnerHash = Get-Sha256OrMissing $FailedGitFreezeRunner
$RuleHash = Get-Sha256OrMissing $RulePath
$LedgerHash = Get-Sha256OrMissing $LedgerPath
$BoundaryReceiptHash = Get-Sha256OrMissing $BoundaryReceiptPath

$ErrorFreezeText = @"
# ERROR_FREEZE__GENERATED_RUNNER_LINE_WRITER_DEEP_LAYER_20260608

Status: FREEZE_EVIDENCE / DEEP_LAYER_REQUIRED / GENERATED_RUNNER_DEFECT_FAMILY / NOT_FIXED_BY_SURFACE_RETRY

Created: $Timestamp

Working root:
$ProjectRoot

Lane:
$Lane

Incident folder:
$IncidentFolder

Observed failure chain:

01 FIRST FAILURE — selector field-test runner

Command:
pwsh -NoProfile -ExecutionPolicy Bypass -File `$env:USERPROFILE\Downloads\RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1

Observed error:
RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1: Cannot bind argument to parameter 'Lines' because it is an empty collection.

Failed runner path:
$OldFieldTestRunner

Failed runner SHA256:
$OldFieldTestRunnerHash

Meaning:
The runner's line-writing helper rejected an empty collection before it could write the report.

02 SECOND FAILURE — bounded Git snapshot false-complete after blocker

Observed blocker:
BLOCKER_NO_GIT_WORKTREE: ProjectRoot is not inside a Git worktree: C:\Users\13527\Desktop\123

Observed follow-on faults:
GitTop stayed empty.
Commands continued interactively after the blocker.
git -C received wrong/null values.
No files were staged.
No commit hash existed.
A false final line printed: BOUNDED_GIT_SNAPSHOT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_COMMITTED.

Meaning:
The blocker was real, but the surrounding run shape allowed later pasted commands to keep going and produce a false-complete narrative.

03 THIRD FAILURE — freeze/repair runner

Command:
pwsh -NoProfile -ExecutionPolicy Bypass -File `$env:USERPROFILE\Downloads\FREEZE_GIT_SNAPSHOT_NO_WORKTREE_AND_WRITE_FIXED_RUNNER_20260608.ps1

Observed error:
Write-Utf8File: C:\Users\13527\Downloads\FREEZE_GIT_SNAPSHOT_NO_WORKTREE_AND_WRITE_FIXED_RUNNER_20260608.ps1:228
Cannot bind argument to parameter 'Lines' because it is an empty string.

Failed freeze runner path:
$FailedGitFreezeRunner

Failed freeze runner SHA256:
$FailedGitFreezeRunnerHash

Meaning:
The repair runner repeated the same line-writer family defect. It tried to write a generated file using a brittle Lines parameter and failed when the generated text resolved to an empty string.

Freeze Evidence rule applied:
This is not a normal retry. This is a deeper-layer generated-runner defect family. The surface failures must be filed together and traced to the shared generator/template pattern before continuing.

Blocked until fixed:
- More generated runners using mandatory Lines arrays.
- False-complete final verdicts after a blocker.
- Any Git commit claim from C:\Users\13527\Desktop\123 until a real Git worktree is identified or created under explicit approval.

DoesNotProve:
This freeze does not prove Git state, commit state, script safety, doctrine, active guide status, source truth, cleanup approval, routing approval, or completion.
"@

$DeepLayerText = @"
# DEEP_LAYER_ROOT_CAUSE__GENERATED_RUNNER_LINE_WRITER_AND_FALSE_COMPLETE_20260608

Status: DEEP_LAYER_ROOT_CAUSE / GENERATED_RUNNER_TEMPLATE_DEFECT / FALSE_COMPLETE_GUARD_REQUIRED

Created: $Timestamp

Root cause family:

GENERATED_RUNNER_LINE_WRITER_DEFECT

Pattern:
Generated PowerShell helpers used functions such as Add-Line or Write-Utf8File with parameters that reject empty collections or empty strings. Then the generated code called those functions with empty or unresolved content.

Symptoms:
- Cannot bind argument to parameter 'Lines' because it is an empty collection.
- Cannot bind argument to parameter 'Lines' because it is an empty string.
- Report/file generation fails before closeout.
- Repair runner repeats the defect because the broken pattern exists in the generator shape, not just one script.

Second root cause family:

FALSE_COMPLETE_AFTER_BLOCKER

Pattern:
A blocker occurred, but the remaining pasted commands continued in the interactive shell. Because variables were null or empty, later Git commands failed, but the final status line still printed a success verdict.

Symptoms:
- BLOCKER_NO_GIT_WORKTREE was real.
- GitTop was null.
- git -C calls failed.
- files_committed_count was 0.
- commit_hash was empty.
- final verdict still claimed committed.

Required fix pattern:

01 Use one safe text writer:
[System.IO.File]::WriteAllText(path, text, UTF8 without BOM)

02 Do not require non-empty Lines arrays for file writing.

03 Build text as a here-string or one string, not as a mandatory array parameter.

04 If a blocker is hit, write a blocker report and Exit 1.

05 Never print final_verdict: COMMITTED unless:
- Git worktree exists.
- exact files are verified.
- exact staged set matches expected.
- git commit exits 0.
- rev-parse HEAD returns a non-empty commit hash.

06 If running in a pasted interactive shell, do not continue after blocker text. Use packaged runner scripts for multi-step operations.

07 Freeze evidence before fix every time.

Updated rule:
When a helper file or generated runner fails, investigate deeper-layer causes: generator template, parameter pattern, path assumption, stale helper, authority mismatch, or false-complete reporting. Capture the deeper layer in the freeze evidence and closeout.

DoesNotProve:
This root-cause report does not by itself fix Git, create a commit, approve source mutation, approve cleanup, or prove future runners are safe. It defines the defect family and the required guard pattern.
"@

$FixNoteText = @"
# FIX_NOTE__SAFE_TEXT_WRITER_AND_STOP_ON_BLOCKER_PATTERN_20260608

Status: FIX_NOTE / GENERATED_RUNNER_REPAIR_PATTERN / ROUGH_LOCAL_GIT_BOUNDARY_SAFE_RUNNER

Created: $Timestamp

Problem:
The generated runner family used brittle line-writing helpers and allowed false-complete output after blockers.

Fix applied in the new runner:
A corrected bounded Git snapshot runner is written with these protections:

01 Safe text writing only:
[System.IO.File]::WriteAllText(path, text, UTF8 without BOM)

02 No mandatory Lines collection writer.

03 No empty-string writer parameter.

04 Hard stop on missing Git worktree.

05 Hard stop on existing staged changes.

06 Hard stop on hash mismatch.

07 Hard stop on staged-set mismatch.

08 No final committed verdict unless commit hash exists.

09 If no worktree exists, it writes a blocker report and exits nonzero.

10 It stages only the rough_local boundary rule, rough_local ledger, and boundary receipt.

Corrected runner path:
$CorrectedGitRunnerPath

Important:
The corrected runner is written but not executed by this freeze script.

Current Git blocker remains:
C:\Users\13527\Desktop\123 is not proven to be inside a Git worktree.

Next safe move:
Run the corrected runner only after deciding whether C:\Users\13527\Desktop\123 should become the Git worktree or whether there is another correct repo root.

DoesNotProve:
This fix note does not prove a Git commit, does not approve git init, does not approve push, and does not authorize full incident evidence in Git.
"@

$CorrectedGitRunnerText = @'
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ProjectRoot = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$IncidentsRoot = Join-Path $Lane "INCIDENTS"
$BlockerFolder = Join-Path $IncidentsRoot "BLOCKER__BOUNDED_GIT_SNAPSHOT_NO_WORKTREE__20260608"

$Targets = @(
    [pscustomobject]@{
        Path = Join-Path $Lane "GIT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_RULE_20260608.md"
        Sha256 = "ADDFCE93724523B971E46EF027F5915219F3FFB44BC5DA08A79CE31471A3F2D5"
        Role = "rough_local boundary rule card"
    },
    [pscustomobject]@{
        Path = Join-Path $Lane "ROUGH_LOCAL__FREEZE_EVIDENCE_POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608.md"
        Sha256 = "83699918316AD2ED2F49F103C7C0DFA676FC02268CDACAE1C03A87269CEB7474"
        Role = "Git-safe rough_local hash ledger"
    },
    [pscustomobject]@{
        Path = Join-Path $Lane "GIT_ROUGH_LOCAL_BOUNDARY_FIX_RECEIPT_20260608.txt"
        Sha256 = "9B3A2EBB6641119E17F6483EDB3E4E57F626F783CACB6AE4CC1C9A4D6A2BE13A"
        Role = "boundary fix receipt"
    }
)

function Write-TextFile {
    param(
        [string]$Path,
        [string]$Text
    )

    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    [System.IO.File]::WriteAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Write-BlockerAndExit {
    param(
        [string]$Reason,
        [string]$Detail
    )

    New-Item -ItemType Directory -Path $BlockerFolder -Force | Out-Null
    $path = Join-Path $BlockerFolder "BLOCKER__BOUNDED_GIT_SNAPSHOT_20260608.md"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $text = @"
# BLOCKER__BOUNDED_GIT_SNAPSHOT_20260608

Status: BLOCKER / NO_GIT_COMMIT / ROUGH_LOCAL_HASH_BOUNDARY_NOT_COMMITTED

Created: $timestamp

Reason:
$Reason

Detail:
$Detail

ProjectRoot:
$ProjectRoot

Lane:
$Lane

Safe state:
No commit was attempted after this blocker.

Next required decision:
Choose the real Git worktree or explicitly approve initializing a Git repository for this project root.

DoesNotProve:
This blocker does not prove Git truth, commit state, push state, public repo state, cleanup approval, source mutation approval, or project completion.
"@
    Write-TextFile -Path $path -Text $text
    $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash

    "=== BOUNDED GIT SNAPSHOT BLOCKED ==="
    "blocker_path: $path"
    "blocker_sha256: $hash"
    "reason: $Reason"
    "final_verdict: BLOCKER_NO_GIT_WORKTREE_OR_SCOPE"
    exit 1
}

"=== BOUNDED GIT SNAPSHOT V0_3 PREFLIGHT ==="

if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    Write-BlockerAndExit -Reason "MISSING_PROJECT_ROOT" -Detail $ProjectRoot
}

$GitTopOutput = & git -C $ProjectRoot rev-parse --show-toplevel 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($GitTopOutput)) {
    Write-BlockerAndExit -Reason "BLOCKER_NO_GIT_WORKTREE" -Detail "ProjectRoot is not inside a Git worktree: $ProjectRoot"
}

$GitTop = $GitTopOutput.Trim()
"git_top: $GitTop"

$ExistingStaged = @(& git -C $GitTop diff --cached --name-only)
if ($LASTEXITCODE -ne 0) {
    Write-BlockerAndExit -Reason "GIT_STAGED_CHECK_FAILED" -Detail "git diff --cached failed"
}

if ($ExistingStaged.Count -gt 0) {
    Write-BlockerAndExit -Reason "BLOCKER_EXISTING_STAGED_CHANGES" -Detail ($ExistingStaged -join "`n")
}

$RelTargets = New-Object System.Collections.Generic.List[string]

foreach ($target in $Targets) {
    if (-not (Test-Path -LiteralPath $target.Path -PathType Leaf)) {
        Write-BlockerAndExit -Reason "MISSING_TARGET_FILE" -Detail $target.Path
    }

    $actualHash = (Get-FileHash -LiteralPath $target.Path -Algorithm SHA256).Hash
    if ($actualHash -ne $target.Sha256) {
        Write-BlockerAndExit -Reason "TARGET_HASH_MISMATCH" -Detail "Path: $($target.Path)`nActual: $actualHash`nExpected: $($target.Sha256)"
    }

    $rel = [System.IO.Path]::GetRelativePath($GitTop, $target.Path).Replace("\","/")
    $RelTargets.Add($rel)

    "verified: $rel"
    "sha256: $actualHash"
    "role: $($target.Role)"
}

foreach ($rel in $RelTargets) {
    & git -C $GitTop add -- $rel
    if ($LASTEXITCODE -ne 0) {
        Write-BlockerAndExit -Reason "GIT_ADD_FAILED" -Detail $rel
    }
}

$Staged = @(& git -C $GitTop diff --cached --name-only)
if ($LASTEXITCODE -ne 0) {
    Write-BlockerAndExit -Reason "GIT_STAGED_VERIFY_FAILED" -Detail "git diff --cached failed after add"
}

$expected = @($RelTargets | Sort-Object)
$actual = @($Staged | Sort-Object)

if (($expected -join "`n") -ne ($actual -join "`n")) {
    foreach ($rel in $RelTargets) {
        & git -C $GitTop reset -- $rel | Out-Null
    }

    Write-BlockerAndExit -Reason "BLOCKER_STAGED_SET_NOT_EXACT" -Detail "Expected:`n$($expected -join "`n")`nActual:`n$($actual -join "`n")"
}

$CommitMessage = "Add rough local hash boundary ledger"
& git -C $GitTop commit -m $CommitMessage
if ($LASTEXITCODE -ne 0) {
    Write-BlockerAndExit -Reason "GIT_COMMIT_FAILED" -Detail "git commit returned nonzero"
}

$CommitHash = (& git -C $GitTop rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($CommitHash)) {
    Write-BlockerAndExit -Reason "GIT_COMMIT_HASH_MISSING" -Detail "rev-parse HEAD failed or returned empty"
}

$StatusShort = @(& git -C $GitTop status --short)

"=== BOUNDED GIT SNAPSHOT COMPLETE ==="
"commit_hash: $CommitHash"
"commit_message: $CommitMessage"
"files_committed_count: $($RelTargets.Count)"
"files_committed:"
$RelTargets
"post_commit_status_short:"
if ($StatusShort.Count -eq 0) { "CLEAN" } else { $StatusShort }
"final_verdict: BOUNDED_GIT_SNAPSHOT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_COMMITTED"
'@

Write-TextFile -Path $ErrorFreezePath -Text $ErrorFreezeText
Write-TextFile -Path $DeepLayerReportPath -Text $DeepLayerText
Write-TextFile -Path $FixNotePath -Text $FixNoteText
Write-TextFile -Path $CorrectedGitRunnerPath -Text $CorrectedGitRunnerText

$ErrorFreezeHash = (Get-FileHash -LiteralPath $ErrorFreezePath -Algorithm SHA256).Hash
$DeepLayerReportHash = (Get-FileHash -LiteralPath $DeepLayerReportPath -Algorithm SHA256).Hash
$FixNoteHash = (Get-FileHash -LiteralPath $FixNotePath -Algorithm SHA256).Hash
$CorrectedGitRunnerHash = (Get-FileHash -LiteralPath $CorrectedGitRunnerPath -Algorithm SHA256).Hash

$ReceiptText = @"
HASH_RECEIPT__GENERATED_RUNNER_DEEP_LAYER_FREEZE_20260608

Created: $Timestamp

error_freeze_path: $ErrorFreezePath
error_freeze_sha256: $ErrorFreezeHash

deep_layer_report_path: $DeepLayerReportPath
deep_layer_report_sha256: $DeepLayerReportHash

fix_note_path: $FixNotePath
fix_note_sha256: $FixNoteHash

corrected_git_runner_path: $CorrectedGitRunnerPath
corrected_git_runner_sha256: $CorrectedGitRunnerHash

old_field_test_runner_path: $OldFieldTestRunner
old_field_test_runner_sha256: $OldFieldTestRunnerHash

fixed_field_test_runner_path: $FixedFieldTestRunner
fixed_field_test_runner_sha256: $FixedFieldTestRunnerHash

failed_git_freeze_runner_path: $FailedGitFreezeRunner
failed_git_freeze_runner_sha256: $FailedGitFreezeRunnerHash

rough_local_boundary_rule_path: $RulePath
rough_local_boundary_rule_sha256: $RuleHash

rough_local_ledger_path: $LedgerPath
rough_local_ledger_sha256: $LedgerHash

boundary_fix_receipt_path: $BoundaryReceiptPath
boundary_fix_receipt_sha256: $BoundaryReceiptHash

git_commands_run: NO
commit_done: NO
final_verdict: GENERATED_RUNNER_DEEP_LAYER_FREEZE_AND_SAFE_RUNNER_WRITTEN
"@

Write-TextFile -Path $ReceiptPath -Text $ReceiptText
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

"=== GENERATED RUNNER DEEP LAYER FREEZE COMPLETE ==="
"incident_folder: $IncidentFolder"
"error_freeze_path: $ErrorFreezePath"
"error_freeze_sha256: $ErrorFreezeHash"
"deep_layer_report_path: $DeepLayerReportPath"
"deep_layer_report_sha256: $DeepLayerReportHash"
"fix_note_path: $FixNotePath"
"fix_note_sha256: $FixNoteHash"
"corrected_git_runner_path: $CorrectedGitRunnerPath"
"corrected_git_runner_sha256: $CorrectedGitRunnerHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"git_commands_run: NO"
"commit_done: NO"
"final_verdict: GENERATED_RUNNER_DEEP_LAYER_FREEZE_AND_SAFE_RUNNER_WRITTEN"
