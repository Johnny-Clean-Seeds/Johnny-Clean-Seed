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