$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$Lane = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$IncidentFolder = Join-Path $Lane 'INCIDENTS\FREEZE_EVIDENCE__BOUNDED_GIT_SNAPSHOT_NO_WORKTREE_FALSE_COMPLETE__20260608'
$Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

function New-UniquePath {
    param([Parameter(Mandatory=$true)][string]$BasePath)
    if (-not (Test-Path -LiteralPath $BasePath)) { return $BasePath }
    $dir = Split-Path -Parent $BasePath
    $name = [System.IO.Path]::GetFileNameWithoutExtension($BasePath)
    $ext = [System.IO.Path]::GetExtension($BasePath)
    for ($i = 2; $i -lt 100; $i++) {
        $candidate = Join-Path $dir ("{0}_V0_{1}{2}" -f $name, $i, $ext)
        if (-not (Test-Path -LiteralPath $candidate)) { return $candidate }
    }
    throw "Could not find available versioned path for $BasePath"
}

function Write-Utf8File {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string[]]$Lines
    )
    $dir = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $Lines | Set-Content -LiteralPath $Path -Encoding UTF8
}

if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    throw "Missing ProjectRoot: $ProjectRoot"
}
if (-not (Test-Path -LiteralPath $Lane -PathType Container)) {
    throw "Missing lane folder: $Lane"
}
New-Item -ItemType Directory -Path $IncidentFolder -Force | Out-Null

$Targets = @(
    [pscustomobject]@{
        Path = Join-Path $Lane 'GIT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_RULE_20260608.md'
        Sha256 = 'ADDFCE93724523B971E46EF027F5915219F3FFB44BC5DA08A79CE31471A3F2D5'
        Role = 'rough_local boundary rule card'
    },
    [pscustomobject]@{
        Path = Join-Path $Lane 'ROUGH_LOCAL__FREEZE_EVIDENCE_POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608.md'
        Sha256 = '83699918316AD2ED2F49F103C7C0DFA676FC02268CDACAE1C03A87269CEB7474'
        Role = 'Git-safe rough_local hash ledger'
    },
    [pscustomobject]@{
        Path = Join-Path $Lane 'GIT_ROUGH_LOCAL_BOUNDARY_FIX_RECEIPT_20260608.txt'
        Sha256 = '9B3A2EBB6641119E17F6483EDB3E4E57F626F783CACB6AE4CC1C9A4D6A2BE13A'
        Role = 'local receipt for boundary fix'
    }
)

$VerifiedLines = New-Object System.Collections.Generic.List[string]
$TargetOk = $true
foreach ($t in $Targets) {
    if (-not (Test-Path -LiteralPath $t.Path -PathType Leaf)) {
        $TargetOk = $false
        $VerifiedLines.Add("MISSING: $($t.Path)")
        continue
    }
    $hash = (Get-FileHash -LiteralPath $t.Path -Algorithm SHA256).Hash
    $match = ($hash -eq $t.Sha256)
    if (-not $match) { $TargetOk = $false }
    $VerifiedLines.Add("path: $($t.Path)")
    $VerifiedLines.Add("role: $($t.Role)")
    $VerifiedLines.Add("sha256: $hash")
    $VerifiedLines.Add("expected_sha256: $($t.Sha256)")
    $VerifiedLines.Add("hash_match: $match")
    $VerifiedLines.Add('')
}

$GitTop = $null
$GitWorktree = $false
$GitError = $null
try {
    $GitTopRaw = & git -C $ProjectRoot rev-parse --show-toplevel 2>&1
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace(($GitTopRaw | Out-String))) {
        $GitTop = (($GitTopRaw | Select-Object -First 1) -as [string]).Trim()
        $GitWorktree = $true
    } else {
        $GitError = ($GitTopRaw | Out-String).Trim()
    }
} catch {
    $GitError = $_.Exception.Message
}
if ([string]::IsNullOrWhiteSpace($GitError)) { $GitError = 'git rev-parse returned no usable worktree for ProjectRoot.' }

$FixedRunnerPath = New-UniquePath (Join-Path $Lane 'RUN_BOUNDED_GIT_SNAPSHOT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_V0_2_STOP_ON_BLOCKER_20260608.ps1')
$FixedRunnerLines = @'
$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\13527\Desktop\123'
$Lane = Join-Path $ProjectRoot 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$CommitMessage = 'Add rough local hash boundary ledger'

$Targets = @(
    [pscustomobject]@{
        Path = Join-Path $Lane 'GIT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_RULE_20260608.md'
        Sha256 = 'ADDFCE93724523B971E46EF027F5915219F3FFB44BC5DA08A79CE31471A3F2D5'
    },
    [pscustomobject]@{
        Path = Join-Path $Lane 'ROUGH_LOCAL__FREEZE_EVIDENCE_POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608.md'
        Sha256 = '83699918316AD2ED2F49F103C7C0DFA676FC02268CDACAE1C03A87269CEB7474'
    },
    [pscustomobject]@{
        Path = Join-Path $Lane 'GIT_ROUGH_LOCAL_BOUNDARY_FIX_RECEIPT_20260608.txt'
        Sha256 = '9B3A2EBB6641119E17F6483EDB3E4E57F626F783CACB6AE4CC1C9A4D6A2BE13A'
    }
)

'=== BOUNDED GIT SNAPSHOT V0_2 PREFLIGHT ==='
if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    'final_verdict: BLOCKER_PROJECT_ROOT_MISSING'
    exit 10
}

$GitTopRaw = & git -C $ProjectRoot rev-parse --show-toplevel 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace(($GitTopRaw | Out-String))) {
    'BLOCKER_NO_GIT_WORKTREE: ProjectRoot is not inside a Git worktree.'
    "project_root: $ProjectRoot"
    'files_staged_count: 0'
    'git_commit_or_push_done: NO'
    'final_verdict: BLOCKER_NO_GIT_WORKTREE'
    exit 20
}

$GitTop = (($GitTopRaw | Select-Object -First 1) -as [string]).Trim()
if ([string]::IsNullOrWhiteSpace($GitTop)) {
    'BLOCKER_NO_GIT_WORKTREE: GitTop was blank after rev-parse.'
    'files_staged_count: 0'
    'git_commit_or_push_done: NO'
    'final_verdict: BLOCKER_NO_GIT_WORKTREE'
    exit 21
}

"git_top: $GitTop"

$AlreadyStaged = @(& git -C $GitTop diff --cached --name-only)
if ($LASTEXITCODE -ne 0) {
    'final_verdict: BLOCKER_GIT_STATUS_FAILED'
    exit 22
}
if ($AlreadyStaged.Count -gt 0) {
    'BLOCKER_EXISTING_STAGED_CHANGES:'
    $AlreadyStaged
    'files_staged_count: 0_by_this_runner'
    'git_commit_or_push_done: NO'
    'final_verdict: BLOCKER_EXISTING_STAGED_CHANGES'
    exit 23
}

$RelTargets = @()
foreach ($t in $Targets) {
    if (-not (Test-Path -LiteralPath $t.Path -PathType Leaf)) {
        "missing_target: $($t.Path)"
        'final_verdict: BLOCKER_TARGET_FILE_MISSING'
        exit 24
    }
    $actualHash = (Get-FileHash -LiteralPath $t.Path -Algorithm SHA256).Hash
    if ($actualHash -ne $t.Sha256) {
        "hash_mismatch_path: $($t.Path)"
        "actual_sha256: $actualHash"
        "expected_sha256: $($t.Sha256)"
        'final_verdict: BLOCKER_TARGET_HASH_MISMATCH'
        exit 25
    }
    $rel = [System.IO.Path]::GetRelativePath($GitTop, $t.Path).Replace('\','/')
    if ($rel.StartsWith('..')) {
        "target_outside_git_worktree: $($t.Path)"
        "git_top: $GitTop"
        'final_verdict: BLOCKER_TARGET_OUTSIDE_GIT_WORKTREE'
        exit 26
    }
    $RelTargets += $rel
    "verified: $rel"
}

foreach ($rel in $RelTargets) {
    & git -C $GitTop add -- $rel
    if ($LASTEXITCODE -ne 0) {
        "git_add_failed: $rel"
        'final_verdict: BLOCKER_GIT_ADD_FAILED'
        exit 27
    }
}

$Staged = @(& git -C $GitTop diff --cached --name-only)
$expected = ($RelTargets | Sort-Object) -join "`n"
$actual = ($Staged | Sort-Object) -join "`n"
if ($expected -ne $actual) {
    'BLOCKER_STAGED_SET_NOT_EXACT'
    'EXPECTED_STAGED:'
    $RelTargets | Sort-Object
    'ACTUAL_STAGED:'
    $Staged | Sort-Object
    foreach ($rel in $RelTargets) { & git -C $GitTop reset -- $rel | Out-Null }
    'git_commit_or_push_done: NO'
    'final_verdict: BLOCKER_STAGED_SET_NOT_EXACT'
    exit 28
}

& git -C $GitTop commit -m $CommitMessage
if ($LASTEXITCODE -ne 0) {
    foreach ($rel in $RelTargets) { & git -C $GitTop reset -- $rel | Out-Null }
    'git_commit_or_push_done: NO'
    'final_verdict: BLOCKER_GIT_COMMIT_FAILED'
    exit 29
}

$CommitHash = (& git -C $GitTop rev-parse HEAD).Trim()
$StatusShort = @(& git -C $GitTop status --short)

'=== BOUNDED GIT SNAPSHOT COMPLETE ==='
"commit_hash: $CommitHash"
"commit_message: $CommitMessage"
"files_committed_count: $($RelTargets.Count)"
'files_committed:'
$RelTargets
'post_commit_status_short:'
if ($StatusShort.Count -eq 0) { 'CLEAN' } else { $StatusShort }
'final_verdict: BOUNDED_GIT_SNAPSHOT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_COMMITTED'
'@ -split "`r?`n"

Write-Utf8File -Path $FixedRunnerPath -Lines $FixedRunnerLines
$FixedRunnerHash = (Get-FileHash -LiteralPath $FixedRunnerPath -Algorithm SHA256).Hash

$ErrorFreezePath = New-UniquePath (Join-Path $IncidentFolder 'ERROR_FREEZE__BOUNDED_GIT_SNAPSHOT_NO_WORKTREE_FALSE_COMPLETE_20260608.md')
$FixNotePath = New-UniquePath (Join-Path $IncidentFolder 'FIX_NOTE__BOUNDED_GIT_SNAPSHOT_STOP_ON_NO_WORKTREE_20260608.md')
$BlockerReportPath = New-UniquePath (Join-Path $Lane 'GIT_SNAPSHOT_BLOCKER__PROJECT_ROOT_NO_WORKTREE_20260608.md')
$ReceiptPath = New-UniquePath (Join-Path $IncidentFolder 'HASH_RECEIPT__GIT_SNAPSHOT_BLOCKER_NO_WORKTREE_20260608.txt')

$CriticalLines = @(
    'Observed failed command set: bounded Git snapshot for rough_local hash truth boundary.',
    'True blocker: BLOCKER_NO_GIT_WORKTREE: ProjectRoot is not inside a Git worktree: C:\Users\13527\Desktop\123',
    'Secondary error: InvalidOperation: You cannot call a method on a null-valued expression.',
    'Secondary error: fatal: cannot change to ''diff'': No such file or directory',
    'Secondary error: Value cannot be null. (Parameter ''relativeTo'')',
    'Secondary error: fatal: cannot change to ''commit'': No such file or directory',
    'Secondary error: git commit failed',
    'Invalid later print: final_verdict: BOUNDED_GIT_SNAPSHOT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_COMMITTED',
    'Invalid later print reason: GitTop was null and RelTargets was empty; no staged files and no commit hash existed.'
)

$ErrorLines = @(
    '# ERROR_FREEZE__BOUNDED_GIT_SNAPSHOT_NO_WORKTREE_FALSE_COMPLETE_20260608',
    '',
    'Status: FREEZE_EVIDENCE / GIT_SNAPSHOT_BLOCKED / FALSE_COMPLETE_INVALID / LOCAL_ONLY',
    '',
    "Created: $Timestamp",
    '',
    "ProjectRoot: $ProjectRoot",
    "Lane: $Lane",
    '',
    'Incident summary:',
    'A bounded Git snapshot was attempted, but ProjectRoot was not inside a Git worktree. The interactive paste continued after the blocker, producing null GitTop errors and an invalid false-complete print.',
    '',
    'Frozen critical evidence:'
) + $CriticalLines + @(
    '',
    'Git preflight result from this freeze script:',
    "git_worktree_found: $GitWorktree",
    "git_top: $GitTop",
    "git_error: $GitError",
    '',
    'Target file verification:'
) + $VerifiedLines.ToArray() + @(
    '',
    'True result:',
    'git_commit_or_push_done: NO',
    'files_staged_count: 0',
    'files_committed_count: 0',
    'final_verdict: GIT_SNAPSHOT_BLOCKED_NO_WORKTREE_FALSE_COMPLETE_FROZEN',
    '',
    'DoesNotProve:',
    'This freeze does not prove Git truth, commit, push, public repo truth, worktree location, source mutation, cleanup, routing, doctrine promotion, or project completion.'
)

$FixLines = @(
    '# FIX_NOTE__BOUNDED_GIT_SNAPSHOT_STOP_ON_NO_WORKTREE_20260608',
    '',
    'Status: FIX_NOTE / SCRIPT_CONTROL_FLOW_REPAIR / NO_GIT_COMMIT_DONE',
    '',
    "Created: $Timestamp",
    '',
    'Problem:',
    'The bounded Git snapshot instructions were pasted interactively. After BLOCKER_NO_GIT_WORKTREE, later pasted commands still ran with GitTop null. This created secondary errors and an invalid false-complete print.',
    '',
    'Fix:',
    'Use a script file with hard exit on no Git worktree before any relative path calculation, git diff, git add, or git commit. Never print committed verdict unless commit hash exists and files_committed_count is nonzero/exact.',
    '',
    'Fixed runner written:',
    $FixedRunnerPath,
    '',
    'fixed_runner_sha256:',
    $FixedRunnerHash,
    '',
    'Current blocker still active:',
    'ProjectRoot is not inside a Git worktree, so the bounded snapshot cannot commit from this root yet.',
    '',
    'Next legal choices:',
    '01 Locate the correct Git worktree and run the V0_2 runner there if the target files are inside that worktree.',
    '02 Initialize/connect a Git repo for this project root only if user explicitly approves that repository action.',
    '03 Keep the rough_local boundary local until a Git worktree decision is made.',
    '',
    'DoesNotProve:',
    'This fix note does not approve git init, remote setup, commit, push, broad scan, cleanup, source mutation, or staging any incident evidence.'
)

$BlockerLines = @(
    '# GIT_SNAPSHOT_BLOCKER__PROJECT_ROOT_NO_WORKTREE_20260608',
    '',
    'Status: BLOCKER_REPORT / ROUGH_LOCAL_GIT_SNAPSHOT_NOT_DONE / PATH_AUTHORITY_NEEDED',
    '',
    "Created: $Timestamp",
    '',
    'Requested task:',
    'Commit rough_local hash truth boundary rule, ledger, and receipt to Git.',
    '',
    'Actual result:',
    'BLOCKED. The project root is not inside a Git worktree.',
    '',
    "ProjectRoot: $ProjectRoot",
    "git_worktree_found: $GitWorktree",
    "git_top: $GitTop",
    "git_error: $GitError",
    '',
    'Git-safe target files verified:'
) + $VerifiedLines.ToArray() + @(
    '',
    'Blocked action:',
    'git add / git commit / git push from this project root.',
    '',
    'Why blocked:',
    'No Git worktree was found at the current project root, so relative path calculation and staging cannot be trusted.',
    '',
    'Missing condition:',
    'A valid Git worktree containing the target files, or explicit user approval to initialize/connect a repository for this root.',
    '',
    'Safe work now:',
    'Keep the local rough_local rule, ledger, and receipt in local custody. Preserve this blocker report and fixed runner.',
    '',
    'Still not authorized:',
    'git init, remote setup, broad scan, cleanup, source mutation, staging incident folder, staging failed/fixed script copies, commit, or push.',
    '',
    'Final verdict:',
    'GIT_SNAPSHOT_BLOCKED_PROJECT_ROOT_NO_WORKTREE'
)

Write-Utf8File -Path $ErrorFreezePath -Lines $ErrorLines
Write-Utf8File -Path $FixNotePath -Lines $FixLines
Write-Utf8File -Path $BlockerReportPath -Lines $BlockerLines

$ErrorHash = (Get-FileHash -LiteralPath $ErrorFreezePath -Algorithm SHA256).Hash
$FixHash = (Get-FileHash -LiteralPath $FixNotePath -Algorithm SHA256).Hash
$BlockerHash = (Get-FileHash -LiteralPath $BlockerReportPath -Algorithm SHA256).Hash

$ReceiptLines = @(
    'HASH_RECEIPT__GIT_SNAPSHOT_BLOCKER_NO_WORKTREE_20260608',
    "Created: $Timestamp",
    '',
    "error_freeze_path: $ErrorFreezePath",
    "error_freeze_sha256: $ErrorHash",
    '',
    "fix_note_path: $FixNotePath",
    "fix_note_sha256: $FixHash",
    '',
    "blocker_report_path: $BlockerReportPath",
    "blocker_report_sha256: $BlockerHash",
    '',
    "fixed_runner_path: $FixedRunnerPath",
    "fixed_runner_sha256: $FixedRunnerHash",
    '',
    "git_worktree_found: $GitWorktree",
    "git_top: $GitTop",
    'git_commit_or_push_done: NO',
    'files_staged_count: 0',
    'files_committed_count: 0',
    'invalid_false_complete_frozen: YES',
    'final_verdict: GIT_SNAPSHOT_BLOCKED_NO_WORKTREE_FALSE_COMPLETE_FROZEN'
)
Write-Utf8File -Path $ReceiptPath -Lines $ReceiptLines
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

'=== GIT SNAPSHOT FAILURE FREEZE COMPLETE ==='
"error_freeze_path: $ErrorFreezePath"
"error_freeze_sha256: $ErrorHash"
"fix_note_path: $FixNotePath"
"fix_note_sha256: $FixHash"
"blocker_report_path: $BlockerReportPath"
"blocker_report_sha256: $BlockerHash"
"fixed_runner_path: $FixedRunnerPath"
"fixed_runner_sha256: $FixedRunnerHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"git_worktree_found: $GitWorktree"
"git_top: $GitTop"
'git_commit_or_push_done: NO'
'files_staged_count: 0'
'files_committed_count: 0'
'invalid_false_complete_frozen: YES'
'final_verdict: GIT_SNAPSHOT_BLOCKED_NO_WORKTREE_FALSE_COMPLETE_FROZEN'
