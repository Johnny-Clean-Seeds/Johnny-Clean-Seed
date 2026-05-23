param(
    [Parameter(Mandatory=$true)][string]$CommandCenterPath,
    [Parameter(Mandatory=$true)][string]$ChildRoot,
    [Parameter(Mandatory=$true)][string]$JobId,
    [Parameter(Mandatory=$true)][string]$PackagePath,
    [Parameter(Mandatory=$true)][string]$ResultPath
)

$ErrorActionPreference = "Stop"

function Stop-Level3 {
    param([Parameter(Mandatory=$true)][string]$Message)
    throw "LEVEL3 STOP: $Message"
}

function Get-NormalRelativePath {
    param([Parameter(Mandatory=$true)][string]$RelativePath)
    $Clean = $RelativePath.Replace("/", "\").Trim()
    if ([string]::IsNullOrWhiteSpace($Clean)) {
        Stop-Level3 "empty relative path"
    }
    if ([System.IO.Path]::IsPathRooted($Clean)) {
        Stop-Level3 "rooted path blocked: $RelativePath"
    }
    if ($Clean -match '(^|\\)\.\.(\\|$)') {
        Stop-Level3 "parent traversal blocked: $RelativePath"
    }
    return $Clean
}

function Test-AllowedWriteTarget {
    param(
        [Parameter(Mandatory=$true)][string]$RelativePath,
        [Parameter(Mandatory=$true)][string]$Mode
    )

    $AllowedCreatePrefixes = @(
        "BRAIN_LEARNING\",
        "HOUSE_WORK\WORK_SHED\SORTING_BENCH\",
        "HOUSE_WORK\WORK_SHED\GEAR_RACK\RULE_MACHINES\",
        "PROOF_HISTORY\"
    )

    $AllowedAppendOrReplace = @(
        "ACTIVE_ANCHOR.txt",
        "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md",
        "BRAIN_LEARNING\CHILD_SHELL_LEVEL2_APPROVED_HELPER_ROUTE_PROOF_RULE_20260521.md",
        "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CHILD_SHELL_LEVEL2_APPROVED_HELPER_REPAIR_AND_PROOF_REVIEW_20260521.md",
        "BRAIN_LEARNING\POST_LEVEL2_BRIDGE_STATE_AND_STALE_RULE_UPDATE_RULE_20260521.md",
        "HOUSE_WORK\WORK_SHED\GEAR_RACK\RULE_MACHINES\POST_LEVEL2_BRIDGE_STATE_CARD_20260521.md",
        "HOUSE_WORK\WORK_SHED\QUEUE\LEVEL2_APPROVED_HELPER_ROUTE_SELECTED_NEXT_20260521.md",
        "BRAIN_LEARNING\CHILD_SHELL_WATCHER_LIVENESS_STALE_PID_DURABILITY_RULE_20260521.md",
        "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CHILD_SHELL_WATCHER_LIVENESS_STALE_PID_DURABILITY_REVIEW_20260521.md"
    )

    if ($Mode -eq "create_new") {
        foreach ($Prefix in $AllowedCreatePrefixes) {
            if ($RelativePath.StartsWith($Prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
                return $true
            }
        }
        return $false
    }

    if (($Mode -eq "append") -or ($Mode -eq "replace")) {
        foreach ($Exact in $AllowedAppendOrReplace) {
            if ($RelativePath.Equals($Exact, [System.StringComparison]::OrdinalIgnoreCase)) {
                return $true
            }
        }
        return $false
    }

    return $false
}

function Assert-PathUnderRoot {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Root
    )
    $ResolvedPath = [System.IO.Path]::GetFullPath($Path)
    $ResolvedRoot = [System.IO.Path]::GetFullPath($Root).TrimEnd("\")
    if ($ResolvedPath.Equals($ResolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return
    }
    $RootWithSlash = "$ResolvedRoot\"
    if (-not $ResolvedPath.StartsWith($RootWithSlash, [System.StringComparison]::OrdinalIgnoreCase)) {
        Stop-Level3 "path outside approved root: $Path"
    }
}

function Invoke-Git {
    param(
        [Parameter(Mandatory=$true)][string]$RepoPath,
        [Parameter(Mandatory=$true)][string[]]$Arguments
    )

    $Output = & git -C $RepoPath @Arguments 2>&1
    $ExitCode = $LASTEXITCODE
    if ($ExitCode -ne 0) {
        Stop-Level3 "git $($Arguments -join ' ') failed with exit code $ExitCode. Output: $($Output -join "`n")"
    }
    return ($Output -join "`n")
}

function Get-ContentSha256 {
    param([Parameter(Mandatory=$true)][string]$Content)
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
    $Sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([System.BitConverter]::ToString($Sha.ComputeHash($Bytes))).Replace("-", "")
    }
    finally {
        $Sha.Dispose()
    }
}

if (Test-Path -LiteralPath $ResultPath) {
    Stop-Level3 "result already exists: $ResultPath"
}

if (-not (Test-Path -LiteralPath $PackagePath)) {
    Stop-Level3 "package missing: $PackagePath"
}

$Package = Get-Content -LiteralPath $PackagePath -Raw | ConvertFrom-Json

if ([string]$Package.package_id -ne $JobId) {
    Stop-Level3 "package_id does not match job_id"
}
if ([string]$Package.action -ne "run_approved_house_save_package") {
    Stop-Level3 "blocked package action: $($Package.action)"
}
if ([string]$Package.helper_name -ne "run_bounded_mr_kleen_save_package") {
    Stop-Level3 "blocked package helper: $($Package.helper_name)"
}

$RepoPath = [string]$Package.mr_kleen_repo
$ExpectedBaseHead = [string]$Package.expected_base_head
$CommitMessage = [string]$Package.commit_message

if ($RepoPath -ne "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz") {
    Stop-Level3 "package repo path is not the approved Mr.Kleen repo"
}
if (-not (Test-Path -LiteralPath $RepoPath)) {
    Stop-Level3 "repo path missing: $RepoPath"
}
if ([string]::IsNullOrWhiteSpace($CommitMessage) -or $CommitMessage.Contains("`n") -or $CommitMessage.Contains("`r")) {
    Stop-Level3 "commit message missing or multiline"
}

$Branch = (Invoke-Git -RepoPath $RepoPath -Arguments @("rev-parse", "--abbrev-ref", "HEAD")).Trim()
if ($Branch -ne "main") {
    Stop-Level3 "repo branch is not main: $Branch"
}

$HeadBefore = (Invoke-Git -RepoPath $RepoPath -Arguments @("rev-parse", "HEAD")).Trim()
if ((-not [string]::IsNullOrWhiteSpace($ExpectedBaseHead)) -and ($HeadBefore -ne $ExpectedBaseHead)) {
    Stop-Level3 "repo HEAD mismatch. Expected $ExpectedBaseHead actual $HeadBefore"
}

$OriginBefore = (Invoke-Git -RepoPath $RepoPath -Arguments @("rev-parse", "origin/main")).Trim()
if ($OriginBefore -ne $HeadBefore) {
    Stop-Level3 "origin/main does not match HEAD before Level3 save"
}

$StatusBefore = Invoke-Git -RepoPath $RepoPath -Arguments @("status", "--porcelain=v1")
if (-not [string]::IsNullOrWhiteSpace($StatusBefore)) {
    Stop-Level3 "repo dirty before Level3 save: $StatusBefore"
}

$Files = @($Package.files)
if ($Files.Count -eq 0) {
    Stop-Level3 "package contains no files"
}
if ($Files.Count -gt 20) {
    Stop-Level3 "package file count exceeds bounded limit"
}

$Seen = @{}
$Written = New-Object System.Collections.Generic.List[object]
$RelativePaths = New-Object System.Collections.Generic.List[string]

foreach ($File in $Files) {
    $RelativePath = Get-NormalRelativePath -RelativePath ([string]$File.relative_path)
    $Mode = [string]$File.mode
    $Content = [string]$File.content
    $ExpectedContentHash = [string]$File.content_sha256

    if ($Seen.ContainsKey($RelativePath.ToLowerInvariant())) {
        Stop-Level3 "duplicate package path: $RelativePath"
    }
    $Seen[$RelativePath.ToLowerInvariant()] = $true

    if (-not (Test-AllowedWriteTarget -RelativePath $RelativePath -Mode $Mode)) {
        Stop-Level3 "path or mode outside approved lanes: $Mode $RelativePath"
    }

    $ActualContentHash = Get-ContentSha256 -Content $Content
    if ($ActualContentHash -ne $ExpectedContentHash) {
        Stop-Level3 "content hash mismatch for $RelativePath"
    }

    $TargetPath = Join-Path $RepoPath $RelativePath
    Assert-PathUnderRoot -Path $TargetPath -Root $RepoPath
    $Parent = Split-Path -Parent $TargetPath
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
    }

    if ($Mode -eq "create_new") {
        if (Test-Path -LiteralPath $TargetPath) {
            Stop-Level3 "create_new target already exists: $RelativePath"
        }
        Set-Content -LiteralPath $TargetPath -Value $Content -Encoding UTF8
    }
    elseif ($Mode -eq "append") {
        if (-not (Test-Path -LiteralPath $TargetPath)) {
            Stop-Level3 "append target missing: $RelativePath"
        }
        Add-Content -LiteralPath $TargetPath -Value $Content -Encoding UTF8
    }
    elseif ($Mode -eq "replace") {
        if (-not (Test-Path -LiteralPath $TargetPath)) {
            Stop-Level3 "replace target missing: $RelativePath"
        }
        Set-Content -LiteralPath $TargetPath -Value $Content -Encoding UTF8
    }
    else {
        Stop-Level3 "blocked mode: $Mode"
    }

    $FinalHash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
    $Written.Add([pscustomobject]@{
        relative_path = $RelativePath
        mode = $Mode
        final_sha256 = $FinalHash
    }) | Out-Null
    $RelativePaths.Add($RelativePath) | Out-Null
}

$StatusAfterWrite = Invoke-Git -RepoPath $RepoPath -Arguments @("status", "--porcelain=v1")
if ([string]::IsNullOrWhiteSpace($StatusAfterWrite)) {
    Stop-Level3 "package produced no repo changes"
}

$ApprovedSet = @{}
foreach ($RelativePath in $RelativePaths) {
    $ApprovedSet[$RelativePath.Replace("\", "/")] = $true
}

foreach ($Line in ($StatusAfterWrite -split "`n")) {
    if ([string]::IsNullOrWhiteSpace($Line)) { continue }
    $StatusPath = $Line.Substring(3).Trim()
    if (-not $ApprovedSet.ContainsKey($StatusPath)) {
        Stop-Level3 "unapproved changed path after package write: $StatusPath"
    }
}

$GitAddArgs = New-Object System.Collections.Generic.List[string]
$GitAddArgs.Add("add") | Out-Null
$GitAddArgs.Add("-f") | Out-Null
$GitAddArgs.Add("--") | Out-Null
foreach ($RelativePath in $RelativePaths) {
    $GitAddArgs.Add($RelativePath.Replace("\", "/")) | Out-Null
}
Invoke-Git -RepoPath $RepoPath -Arguments $GitAddArgs.ToArray() | Out-Null

$CachedPaths = Invoke-Git -RepoPath $RepoPath -Arguments @("diff", "--cached", "--name-only")
foreach ($Path in ($CachedPaths -split "`n")) {
    if ([string]::IsNullOrWhiteSpace($Path)) { continue }
    if (-not $ApprovedSet.ContainsKey($Path.Trim())) {
        Stop-Level3 "unapproved staged path: $Path"
    }
}

$CommitOutput = Invoke-Git -RepoPath $RepoPath -Arguments @("commit", "-m", $CommitMessage)
$CommitFullHash = (Invoke-Git -RepoPath $RepoPath -Arguments @("rev-parse", "HEAD")).Trim()
$CommitShortHash = (Invoke-Git -RepoPath $RepoPath -Arguments @("rev-parse", "--short", "HEAD")).Trim()

$PushOutput = Invoke-Git -RepoPath $RepoPath -Arguments @("push", "origin", "main")

$FinalStatus = Invoke-Git -RepoPath $RepoPath -Arguments @("status", "--porcelain=v1")
if (-not [string]::IsNullOrWhiteSpace($FinalStatus)) {
    Stop-Level3 "repo dirty after Level3 push: $FinalStatus"
}

$OriginAfter = (Invoke-Git -RepoPath $RepoPath -Arguments @("rev-parse", "origin/main")).Trim()
if ($OriginAfter -ne $CommitFullHash) {
    Stop-Level3 "origin/main does not match HEAD after Level3 push"
}

$ResultParent = Split-Path -Parent $ResultPath
if ($ResultParent -and -not (Test-Path -LiteralPath $ResultParent)) {
    New-Item -ItemType Directory -Force -Path $ResultParent | Out-Null
}

$Result = [ordered]@{
    verdict = "PASS / LEVEL3 BOUNDED HOUSE SAVE PACKAGE CONSUMED"
    job_id = $JobId
    action = "run_approved_house_save_package"
    helper_name = "run_bounded_mr_kleen_save_package"
    package_path = $PackagePath
    mr_kleen_repo = $RepoPath
    head_before = $HeadBefore
    files_written = $Written.ToArray()
    commit_short_hash = $CommitShortHash
    commit_full_hash = $CommitFullHash
    commit_output = $CommitOutput
    push_result = $PushOutput
    final_git_status = "clean"
    origin_main = $OriginAfter
    boundary = @(
        "bounded Level3 house-save package only",
        "exact package hash required",
        "exact approved file list only",
        "approved write lanes only",
        "no delete",
        "no arbitrary shell",
        "no raw shell expansion",
        "no broad filesystem crawl",
        "no permission expansion",
        "no junction or symlink teleporter",
        "no ACTIVE_GUIDES rewrite",
        "no CURRENT_TRUTH_INDEX rewrite",
        "no doctrine rewrite"
    )
}

$Result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ResultPath -Encoding UTF8
