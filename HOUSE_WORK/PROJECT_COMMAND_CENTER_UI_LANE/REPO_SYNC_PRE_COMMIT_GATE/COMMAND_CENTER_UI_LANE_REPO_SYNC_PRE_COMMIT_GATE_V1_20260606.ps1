<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_GATE_V1_20260606.ps1

PURPOSE:
Bridge the proven WorkRoot install into the actual Git repo root before commit.

WHY THIS EXISTS:
The previous save/commit gate correctly blocked because WorkRoot is not a Git repo.
Actual GitRoot is:
C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz

DEFAULT MODE:
Pending/plan-only. No copy. No commit. No push.

AUTHORIZED MODE:
If the exact authorization phrase is supplied, copy approved Command Center UI lane files
from WorkRoot into GitRoot, verify hashes after copy, and write a synced-file manifest for
the next save/commit gate.

REQUIRED SYNC AUTHORIZATION PHRASE:
I AUTHORIZE SYNCING THE COMMAND CENTER UI LANE INTO THE REPO

THIS SCRIPT DOES NOT:
- commit
- push
- delete
- archive
- dedupe
- promote doctrine
- install watcher
- install automation
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$WorkRoot = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [string]$GitRoot = "C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz",

    [Parameter(Mandatory = $false)]
    [switch]$AuthorizeRepoSync,

    [Parameter(Mandatory = $false)]
    [string]$AuthorizationPhrase = "",

    [Parameter(Mandatory = $false)]
    [string]$AuthorizedBy = "UNSPECIFIED",

    [Parameter(Mandatory = $false)]
    [switch]$NoEntryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DateTag = "20260606"
$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$RequiredPhrase = "I AUTHORIZE SYNCING THE COMMAND CENTER UI LANE INTO THE REPO"

$CommandCenterRoot = Join-Path $WorkRoot "COMMAND_CENTER"
$WorkEntryRoot = Join-Path $CommandCenterRoot "WORK_ENTRYPOINT"
$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"

$WorkUiLaneRoot = Join-Path $WorkRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$InstalledStatusMd = Join-Path $WorkUiLaneRoot "POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE\CURRENT_COMMAND_CENTER_UI_LANE_INSTALLED_STATUS.md"

$RepoUiLaneRoot = Join-Path $GitRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$RepoCommandCenterUiLaneRoot = Join-Path $GitRoot "COMMAND_CENTER\UI_LANE"

$SyncGateRoot = Join-Path $WorkUiLaneRoot "REPO_SYNC_PRE_COMMIT_GATE"
$RunRoot = Join-Path $SyncGateRoot ("COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_GATE_V1_" + $RunStamp)

$CurrentSyncStatusMd = Join-Path $SyncGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_STATUS.md"
$CurrentSyncStatusJson = Join-Path $SyncGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_STATUS.json"

$SyncPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_PACKET_V1_20260606.md"
$CopyPlanManifest = Join-Path $RunRoot "REPO_SYNC_COPY_PLAN_MANIFEST__COMMAND_CENTER_UI_LANE_V1_20260606.md"
$CopyPlanManifestJson = Join-Path $RunRoot "REPO_SYNC_COPY_PLAN_MANIFEST__COMMAND_CENTER_UI_LANE_V1_20260606.json"
$SyncedFilesManifest = Join-Path $RunRoot "SYNCED_FILES_MANIFEST__COMMAND_CENTER_UI_LANE_REPO_SYNC_V1_20260606.txt"
$SyncedFilesManifestJson = Join-Path $RunRoot "SYNCED_FILES_MANIFEST__COMMAND_CENTER_UI_LANE_REPO_SYNC_V1_20260606.json"
$GitStatusBeforeFile = Join-Path $RunRoot "GIT_STATUS_BEFORE__COMMAND_CENTER_UI_LANE_REPO_SYNC_V1_20260606.txt"
$GitStatusAfterFile = Join-Path $RunRoot "GIT_STATUS_AFTER__COMMAND_CENTER_UI_LANE_REPO_SYNC_V1_20260606.txt"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1_20260606.md"
$PendingCard = Join-Path $RunRoot "PENDING_CARD__COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_V1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_GATE_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_GATE_V1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_REPO_SYNC_PRE_COMMIT_GATE.txt"

function New-Dir {
    param([string]$Path)
    [System.IO.Directory]::CreateDirectory($Path) | Out-Null
}

function Get-UtcNow {
    return (Get-Date).ToUniversalTime().ToString("o")
}

function Escape-Md {
    param([object]$Text)
    if ($null -eq $Text) { return "" }
    return ([string]$Text).Replace("|", "\|").Replace("`r", " ").Replace("`n", " ")
}

function Get-InlineValue {
    param([string]$Text, [string]$Name)
    $pattern = "(?im)^\s*" + [regex]::Escape($Name) + "\s*:\s*(.+?)\s*$"
    $m = [regex]::Match($Text, $pattern)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return "UNKNOWN"
}

function Get-RelPath {
    param([string]$BasePath, [string]$FullPath)
    $b = [System.IO.Path]::GetFullPath($BasePath).TrimEnd("\")
    $f = [System.IO.Path]::GetFullPath($FullPath)
    if ($f.StartsWith($b, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $f.Substring($b.Length).TrimStart("\")
    }
    return $f
}

function Add-SyncError {
    param([string]$Category, [string]$Phase, [string]$Message, [string]$Resolution = "")

    $script:errors += [pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
    }
}

function Invoke-GitCapture {
    param([string[]]$ArgList)

    $out = & git -C $GitRoot @ArgList 2>&1
    $code = $LASTEXITCODE

    return [pscustomobject]@{
        ExitCode = $code
        Output = @($out)
        Text = (@($out) -join "`n")
    }
}

function Test-PathInsideRoot {
    param([string]$PathToCheck, [string]$RootPath)

    try {
        $rootFull = [System.IO.Path]::GetFullPath($RootPath).TrimEnd("\")
        $pathFull = [System.IO.Path]::GetFullPath($PathToCheck)
        return $pathFull.StartsWith($rootFull + "\", [System.StringComparison]::OrdinalIgnoreCase)
    }
    catch {
        return $false
    }
}

New-Dir $WorkUiLaneRoot
New-Dir $SyncGateRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"

$closeoutStatus = "UNKNOWN"
$installedNextLegalObject = "UNKNOWN"
$manifestTargetFileCount = "UNKNOWN"
$actualTargetFileCount = "UNKNOWN"
$verifiedTargetCount = "UNKNOWN"
$installedErrorCount = "UNKNOWN"

$gitInsideWorkTree = "UNKNOWN"
$gitTopLevel = "UNKNOWN"
$gitBranch = "UNKNOWN"
$headBefore = "UNKNOWN"
$headAfter = "UNKNOWN"
$statusBeforeCount = 0
$statusAfterCount = 0

$syncStatus = "REPO_SYNC_PRE_COMMIT_PENDING_AUTHORIZATION"
$nextLegalObject = "WAIT_FOR_REPO_SYNC_AUTHORIZATION"
$syncAuthorized = "false"
$syncedHere = "false"
$committedHere = "false"
$pushedHere = "false"

$copyRows = @()
$syncedRows = @()
$sourceFileCount = 0
$targetVerifiedCount = 0
$targetHashMismatchCount = 0
$targetMissingAfterSyncCount = 0
$targetPathOutsideRepoCount = 0

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-SyncError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Work entrypoint required before repo sync."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_GATE" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_REPO_SYNC_PRE_COMMIT_GATE: " + $WorkEntryScript)
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-SyncError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint before repo sync."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"
        $actions += ("READ_WORK_ENTRY_STATUS: " + $WorkEntryStatusMd)

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-SyncError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Resolve work entry/pre-run block first."
        }

        if ($openSideQuestRequired -ne "False") {
            Add-SyncError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error-triggered helper harvest first."
        }
    }

    if (-not (Test-Path -LiteralPath $InstalledStatusMd)) {
        Add-SyncError -Category "INSTALLED_STATUS_MISSING" -Phase "READ_INSTALLED_STATUS" -Message $InstalledStatusMd -Resolution "Run post-install closeout before repo sync."
    }
    else {
        $installedText = Get-Content -LiteralPath $InstalledStatusMd -Raw -ErrorAction Stop
        $closeoutStatus = Get-InlineValue -Text $installedText -Name "CloseoutStatus"
        $installedNextLegalObject = Get-InlineValue -Text $installedText -Name "NextLegalObject"
        $manifestTargetFileCount = Get-InlineValue -Text $installedText -Name "ManifestTargetFileCount"
        $actualTargetFileCount = Get-InlineValue -Text $installedText -Name "ActualTargetFileCount"
        $verifiedTargetCount = Get-InlineValue -Text $installedText -Name "VerifiedTargetCount"
        $installedErrorCount = Get-InlineValue -Text $installedText -Name "ErrorCount"
        $actions += ("READ_INSTALLED_STATUS: " + $InstalledStatusMd)

        if ($closeoutStatus -ne "POST_INSTALL_VERIFY_AND_CLOSEOUT_COMPLETE") {
            Add-SyncError -Category "CLOSEOUT_NOT_COMPLETE" -Phase "READ_INSTALLED_STATUS" -Message ("CloseoutStatus=" + $closeoutStatus) -Resolution "Do not repo-sync until closeout passes."
        }

        if ($installedNextLegalObject -ne "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1") {
            Add-SyncError -Category "INSTALLED_NEXT_OBJECT_UNEXPECTED" -Phase "READ_INSTALLED_STATUS" -Message ("NextLegalObject=" + $installedNextLegalObject) -Resolution "Review installed status next object."
        }

        if ($manifestTargetFileCount -ne $actualTargetFileCount -or $manifestTargetFileCount -ne $verifiedTargetCount -or $installedErrorCount -ne "0") {
            Add-SyncError -Category "INSTALLED_COUNTS_NOT_CLEAN" -Phase "READ_INSTALLED_STATUS" -Message ("Manifest=" + $manifestTargetFileCount + " Actual=" + $actualTargetFileCount + " Verified=" + $verifiedTargetCount + " ErrorCount=" + $installedErrorCount) -Resolution "Re-run post-install closeout."
        }
    }

    if (-not (Test-Path -LiteralPath $GitRoot)) {
        Add-SyncError -Category "GIT_ROOT_MISSING" -Phase "GIT_PREFLIGHT" -Message $GitRoot -Resolution "Use the actual repo root."
    }
    else {
        $inside = Invoke-GitCapture -ArgList @("rev-parse", "--is-inside-work-tree")
        if ($inside.ExitCode -ne 0) {
            Add-SyncError -Category "GIT_ROOT_NOT_REPO" -Phase "GIT_PREFLIGHT" -Message $inside.Text -Resolution "Use actual GitRoot containing .git."
        }
        else {
            $gitInsideWorkTree = (($inside.Output | Select-Object -First 1) -as [string])
            $actions += "GIT_REPO_CONFIRMED"
        }

        $top = Invoke-GitCapture -ArgList @("rev-parse", "--show-toplevel")
        if ($top.ExitCode -eq 0) {
            $gitTopLevel = (($top.Output | Select-Object -First 1) -as [string])
        }

        $branch = Invoke-GitCapture -ArgList @("branch", "--show-current")
        if ($branch.ExitCode -eq 0) {
            $gitBranch = (($branch.Output | Select-Object -First 1) -as [string])
        }

        $head = Invoke-GitCapture -ArgList @("rev-parse", "HEAD")
        if ($head.ExitCode -eq 0) {
            $headBefore = (($head.Output | Select-Object -First 1) -as [string])
        }

        $statusBefore = Invoke-GitCapture -ArgList @("status", "--porcelain=v1")
        if ($statusBefore.ExitCode -eq 0) {
            @($statusBefore.Output) | Set-Content -LiteralPath $GitStatusBeforeFile -Encoding UTF8
            $statusBeforeCount = @($statusBefore.Output).Count
            $actions += ("WROTE_GIT_STATUS_BEFORE: " + $GitStatusBeforeFile)
        }
    }

    $sourceMappings = @(
        [pscustomobject]@{
            Label = "WORK_PROJECT_COMMAND_CENTER_UI_LANE"
            SourceRoot = $WorkUiLaneRoot
            TargetRoot = $RepoUiLaneRoot
            RepoPrefix = "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE"
        },
        [pscustomobject]@{
            Label = "WORK_COMMAND_CENTER_UI_LANE_INSTALL_TARGET"
            SourceRoot = (Join-Path $WorkRoot "COMMAND_CENTER\UI_LANE")
            TargetRoot = $RepoCommandCenterUiLaneRoot
            RepoPrefix = "COMMAND_CENTER/UI_LANE"
        }
    )

    foreach ($m in $sourceMappings) {
        if (-not (Test-Path -LiteralPath $m.SourceRoot)) {
            Add-SyncError -Category "SYNC_SOURCE_ROOT_MISSING" -Phase "BUILD_COPY_PLAN" -Message ($m.Label + "=" + $m.SourceRoot) -Resolution "Source root missing; cannot sync."
            continue
        }

        $files = @(Get-ChildItem -LiteralPath $m.SourceRoot -File -Recurse -Force -ErrorAction Stop)
        foreach ($f in $files) {
            $rel = Get-RelPath -BasePath $m.SourceRoot -FullPath $f.FullName
            $targetPath = Join-Path $m.TargetRoot $rel
            $repoRel = ($m.RepoPrefix.TrimEnd("/") + "/" + ($rel.Replace("\", "/")))
            $sourceHash = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash
            $insideRepo = Test-PathInsideRoot -PathToCheck $targetPath -RootPath $GitRoot
            if (-not $insideRepo) {
                $targetPathOutsideRepoCount += 1
                Add-SyncError -Category "TARGET_PATH_OUTSIDE_GIT_ROOT" -Phase "BUILD_COPY_PLAN" -Message $targetPath -Resolution "Reject sync target outside GitRoot."
            }

            $copyRows += [pscustomobject]@{
                Label = $m.Label
                RelativePath = $rel
                RepoRelativePath = $repoRel
                SourcePath = $f.FullName
                TargetPath = $targetPath
                SizeBytes = $f.Length
                SourceSHA256 = $sourceHash
                TargetInsideGitRoot = $insideRepo
            }
        }
    }

    $sourceFileCount = @($copyRows).Count

    if ($sourceFileCount -lt 1) {
        Add-SyncError -Category "NO_SOURCE_FILES_FOR_REPO_SYNC" -Phase "BUILD_COPY_PLAN" -Message "SourceFileCount=0" -Resolution "Review source roots."
    }

    if ($AuthorizeRepoSync) {
        if ($AuthorizationPhrase -ne $RequiredPhrase) {
            Add-SyncError -Category "REPO_SYNC_AUTHORIZATION_PHRASE_MISMATCH" -Phase "SYNC_AUTHORIZATION" -Message "AuthorizeRepoSync was supplied, but phrase did not match required phrase." -Resolution ("Use exact phrase: " + $RequiredPhrase)
        }
        else {
            $syncAuthorized = "true"
            $actions += "REPO_SYNC_AUTHORIZATION_ACCEPTED"
        }
    }
    else {
        $actions += "NO_REPO_SYNC_AUTHORIZATION_SUPPLIED_PENDING_ONLY"
    }

    if ($AuthorizeRepoSync -and $syncAuthorized -eq "true" -and @($errors).Count -eq 0) {
        foreach ($r in $copyRows) {
            $targetParent = Split-Path -Parent $r.TargetPath
            New-Dir $targetParent
            Copy-Item -LiteralPath $r.SourcePath -Destination $r.TargetPath -Force
        }
        $actions += ("COPIED_APPROVED_FILES_TO_GIT_ROOT: " + $sourceFileCount)

        foreach ($r in $copyRows) {
            $exists = Test-Path -LiteralPath $r.TargetPath
            $actualHash = "MISSING"
            $verdict = "MISSING_AFTER_SYNC"

            if (-not $exists) {
                $targetMissingAfterSyncCount += 1
            }
            else {
                $actualHash = (Get-FileHash -LiteralPath $r.TargetPath -Algorithm SHA256).Hash
                if ($actualHash -eq $r.SourceSHA256) {
                    $targetVerifiedCount += 1
                    $verdict = "PASS"
                }
                else {
                    $targetHashMismatchCount += 1
                    $verdict = "HASH_MISMATCH"
                }
            }

            $syncedRows += [pscustomobject]@{
                RepoRelativePath = $r.RepoRelativePath
                SourcePath = $r.SourcePath
                TargetPath = $r.TargetPath
                ExpectedSHA256 = $r.SourceSHA256
                ActualSHA256 = $actualHash
                Verdict = $verdict
            }
        }

        if ($targetMissingAfterSyncCount -ne 0 -or $targetHashMismatchCount -ne 0) {
            Add-SyncError -Category "REPO_SYNC_VERIFY_FAILED" -Phase "VERIFY_AFTER_SYNC" -Message ("MissingAfterSync=" + $targetMissingAfterSyncCount + " HashMismatch=" + $targetHashMismatchCount) -Resolution "Inspect repo sync target files."
        }
        else {
            $syncedHere = "true"
            $syncStatus = "REPO_SYNC_PRE_COMMIT_COMPLETE"
            $nextLegalObject = "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1"
        }
    }

    $statusAfter = Invoke-GitCapture -ArgList @("status", "--porcelain=v1")
    if ($statusAfter.ExitCode -eq 0) {
        @($statusAfter.Output) | Set-Content -LiteralPath $GitStatusAfterFile -Encoding UTF8
        $statusAfterCount = @($statusAfter.Output).Count
        $actions += ("WROTE_GIT_STATUS_AFTER: " + $GitStatusAfterFile)
    }

    $headAfterResult = Invoke-GitCapture -ArgList @("rev-parse", "HEAD")
    if ($headAfterResult.ExitCode -eq 0) {
        $headAfter = (($headAfterResult.Output | Select-Object -First 1) -as [string])
    }

    if (-not $AuthorizeRepoSync -and @($errors).Count -eq 0) {
        $syncStatus = "REPO_SYNC_PRE_COMMIT_PENDING_AUTHORIZATION"
        $nextLegalObject = "WAIT_FOR_REPO_SYNC_AUTHORIZATION"
    }

    if (@($errors).Count -gt 0) {
        $syncStatus = "REPO_SYNC_PRE_COMMIT_BLOCKED"
        $nextLegalObject = "FIX_REPO_SYNC_PRE_COMMIT_BLOCKERS"
    }
}
catch {
    Add-SyncError -Category "REPO_SYNC_PRE_COMMIT_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review repo sync error ledger."
    $syncStatus = "REPO_SYNC_PRE_COMMIT_GATE_EXCEPTION"
    $nextLegalObject = "FIX_REPO_SYNC_PRE_COMMIT_GATE_EXCEPTION"
}

$copyRows | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CopyPlanManifestJson -Encoding UTF8
$syncedRows | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $SyncedFilesManifestJson -Encoding UTF8
@($syncedRows | ForEach-Object { $_.RepoRelativePath }) | Set-Content -LiteralPath $SyncedFilesManifest -Encoding UTF8

$copyLines = @()
$copyLines += "# REPO SYNC COPY PLAN MANIFEST"
$copyLines += "## COMMAND CENTER UI LANE V1"
$copyLines += ""
$copyLines += ("GeneratedUtc: " + (Get-UtcNow))
$copyLines += ("WorkRoot: " + $WorkRoot)
$copyLines += ("GitRoot: " + $GitRoot)
$copyLines += ("SourceFileCount: " + $sourceFileCount)
$copyLines += ("TargetPathOutsideRepoCount: " + $targetPathOutsideRepoCount)
$copyLines += ""
$copyLines += "| RepoRelativePath | SizeBytes | SourceSHA256 | SourcePath | TargetPath |"
$copyLines += "|---|---:|---|---|---|"
foreach ($r in $copyRows) {
    $copyLines += ("| " + (Escape-Md $r.RepoRelativePath) + " | " + $r.SizeBytes + " | " + $r.SourceSHA256 + " | " + (Escape-Md $r.SourcePath) + " | " + (Escape-Md $r.TargetPath) + " |")
}
$copyLines | Set-Content -LiteralPath $CopyPlanManifest -Encoding UTF8

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE REPO SYNC PRE COMMIT GATE V1"
$errorLines += ""
$errorLines += ("GeneratedUtc: " + (Get-UtcNow))
$errorLines += ("ErrorCount: " + @($errors).Count)
$errorLines += ""
$errorLines += "| Category | Phase | Message | Resolution |"
$errorLines += "|---|---|---|---|"
foreach ($e in $errors) {
    $errorLines += ("| " + (Escape-Md $e.Category) + " | " + (Escape-Md $e.Phase) + " | " + (Escape-Md $e.Message) + " | " + (Escape-Md $e.Resolution) + " |")
}
$errorLines += ""
$errorLines += "# DoesNotProve"
$errorLines += ""
$errorLines += "This error ledger does not commit or push."
$errorLines += "This error ledger does not promote doctrine."
$errorLines += "This error ledger does not authorize cleanup."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$pendingLines = @()
$pendingLines += "# PENDING CARD"
$pendingLines += "## COMMAND CENTER UI LANE REPO SYNC PRE COMMIT V1"
$pendingLines += ""
$pendingLines += ("GeneratedUtc: " + (Get-UtcNow))
$pendingLines += ("RepoSyncStatus: " + $syncStatus)
$pendingLines += ""
$pendingLines += "# Required Phrase"
$pendingLines += ""
$pendingLines += $RequiredPhrase
$pendingLines += ""
$pendingLines += "# Sync Command"
$pendingLines += ""
$pendingLines += 'pwsh -NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '" -AuthorizeRepoSync -AuthorizationPhrase "' + $RequiredPhrase + '" -AuthorizedBy "Jonathon"'
$pendingLines += ""
$pendingLines += "# Boundary"
$pendingLines += ""
$pendingLines += "This pending card does not commit or push."
$pendingLines += "This pending card does not cleanup/delete/archive/dedupe."
$pendingLines | Set-Content -LiteralPath $PendingCard -Encoding UTF8

$packetLines = @()
$packetLines += "# COMMAND CENTER UI LANE REPO SYNC PRE COMMIT PACKET"
$packetLines += "## V1"
$packetLines += ""
$packetLines += ("GeneratedUtc: " + (Get-UtcNow))
$packetLines += ("RunStamp: " + $RunStamp)
$packetLines += ("RepoSyncStatus: " + $syncStatus)
$packetLines += ("NextLegalObject: " + $nextLegalObject)
$packetLines += ("RepoSyncAuthorized: " + $syncAuthorized)
$packetLines += ("SyncedHere: " + $syncedHere)
$packetLines += ("CommittedHere: " + $committedHere)
$packetLines += ("PushedHere: " + $pushedHere)
$packetLines += ("AuthorizedBy: " + $AuthorizedBy)
$packetLines += ("ErrorCount: " + @($errors).Count)
$packetLines += ""
$packetLines += "# Roots"
$packetLines += ""
$packetLines += ("WorkRoot: " + $WorkRoot)
$packetLines += ("GitRoot: " + $GitRoot)
$packetLines += ("GitTopLevel: " + $gitTopLevel)
$packetLines += ("GitBranch: " + $gitBranch)
$packetLines += ("HeadBefore: " + $headBefore)
$packetLines += ("HeadAfter: " + $headAfter)
$packetLines += ""
$packetLines += "# Counts"
$packetLines += ""
$packetLines += ("SourceFileCount: " + $sourceFileCount)
$packetLines += ("TargetVerifiedCount: " + $targetVerifiedCount)
$packetLines += ("TargetMissingAfterSyncCount: " + $targetMissingAfterSyncCount)
$packetLines += ("TargetHashMismatchCount: " + $targetHashMismatchCount)
$packetLines += ("GitStatusBeforeCount: " + $statusBeforeCount)
$packetLines += ("GitStatusAfterCount: " + $statusAfterCount)
$packetLines += ""
$packetLines += "# Files"
$packetLines += ""
$packetLines += ("CopyPlanManifest: " + $CopyPlanManifest)
$packetLines += ("CopyPlanManifestJson: " + $CopyPlanManifestJson)
$packetLines += ("SyncedFilesManifest: " + $SyncedFilesManifest)
$packetLines += ("SyncedFilesManifestJson: " + $SyncedFilesManifestJson)
$packetLines += ("GitStatusBeforeFile: " + $GitStatusBeforeFile)
$packetLines += ("GitStatusAfterFile: " + $GitStatusAfterFile)
$packetLines += ("PendingCard: " + $PendingCard)
$packetLines += ("NextObjectCard: " + $NextObjectCard)
$packetLines += ("Receipt: " + $Receipt)
$packetLines += ("ErrorLedger: " + $ErrorLedger)
$packetLines += ""
$packetLines += "# Boundary"
$packetLines += ""
$packetLines += "CommittedHere: false"
$packetLines += "PushedHere: false"
$packetLines += "DeletedFilesHere: false"
$packetLines += "ArchivedFilesHere: false"
$packetLines += "DedupedFilesHere: false"
$packetLines += "DoctrinePromotedHere: false"
$packetLines | Set-Content -LiteralPath $SyncPacket -Encoding UTF8

$nextLines = @()
$nextLines += "# NEXT OBJECT CARD"
$nextLines += "## COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1"
$nextLines += ""
$nextLines += ("GeneratedUtc: " + (Get-UtcNow))
$nextLines += ("RepoSyncStatus: " + $syncStatus)
$nextLines += ("SyncedHere: " + $syncedHere)
$nextLines += ("SyncedFilesManifest: " + $SyncedFilesManifest)
$nextLines += ("SourceRepoSyncPacket: " + $SyncPacket)
$nextLines += ""
$nextLines += "# Legal Meaning"
$nextLines += ""
if ($syncStatus -eq "REPO_SYNC_PRE_COMMIT_COMPLETE") {
    $nextLines += "The next legal object may prepare a V1.1 save/commit gate using GitRoot and the synced-file manifest."
}
else {
    $nextLines += "Save/commit is not legal until repo sync is complete."
}
$nextLines += ""
$nextLines += "# Still Not Authorized Here"
$nextLines += ""
$nextLines += "CommittedHere: false"
$nextLines += "PushedHere: false"
$nextLines += "CleanupHere: false"
$nextLines | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    RepoSyncStatus = $syncStatus
    NextLegalObject = $nextLegalObject
    RepoSyncAuthorized = $syncAuthorized
    SyncedHere = $syncedHere
    CommittedHere = $committedHere
    PushedHere = $pushedHere
    WorkRoot = $WorkRoot
    GitRoot = $GitRoot
    GitTopLevel = $gitTopLevel
    GitBranch = $gitBranch
    HeadBefore = $headBefore
    HeadAfter = $headAfter
    WorkEntryStatus = $workEntryStatus
    OpenSideQuestRequired = $openSideQuestRequired
    InstalledStatus = $InstalledStatusMd
    CloseoutStatus = $closeoutStatus
    SourceFileCount = $sourceFileCount
    TargetVerifiedCount = $targetVerifiedCount
    TargetMissingAfterSyncCount = $targetMissingAfterSyncCount
    TargetHashMismatchCount = $targetHashMismatchCount
    CopyPlanManifest = $CopyPlanManifest
    CopyPlanManifestJson = $CopyPlanManifestJson
    SyncedFilesManifest = $SyncedFilesManifest
    SyncedFilesManifestJson = $SyncedFilesManifestJson
    GitStatusBeforeFile = $GitStatusBeforeFile
    GitStatusAfterFile = $GitStatusAfterFile
    SyncPacket = $SyncPacket
    PendingCard = $PendingCard
    NextObjectCard = $NextObjectCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentSyncStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE REPO SYNC PRE COMMIT STATUS"
$statusLines += ""
$statusLines += ("GeneratedUtc: " + $statusObj.GeneratedUtc)
$statusLines += ("RunStamp: " + $RunStamp)
$statusLines += ("RepoSyncStatus: " + $syncStatus)
$statusLines += ("NextLegalObject: " + $nextLegalObject)
$statusLines += ("RepoSyncAuthorized: " + $syncAuthorized)
$statusLines += ("SyncedHere: " + $syncedHere)
$statusLines += ("CommittedHere: " + $committedHere)
$statusLines += ("PushedHere: " + $pushedHere)
$statusLines += ("AuthorizedBy: " + $AuthorizedBy)
$statusLines += ("WorkRoot: " + $WorkRoot)
$statusLines += ("GitRoot: " + $GitRoot)
$statusLines += ("GitTopLevel: " + $gitTopLevel)
$statusLines += ("GitBranch: " + $gitBranch)
$statusLines += ("HeadBefore: " + $headBefore)
$statusLines += ("HeadAfter: " + $headAfter)
$statusLines += ("WorkEntryStatus: " + $workEntryStatus)
$statusLines += ("OpenSideQuestRequired: " + $openSideQuestRequired)
$statusLines += ("InstalledStatus: " + $InstalledStatusMd)
$statusLines += ("CloseoutStatus: " + $closeoutStatus)
$statusLines += ("SourceFileCount: " + $sourceFileCount)
$statusLines += ("TargetVerifiedCount: " + $targetVerifiedCount)
$statusLines += ("TargetMissingAfterSyncCount: " + $targetMissingAfterSyncCount)
$statusLines += ("TargetHashMismatchCount: " + $targetHashMismatchCount)
$statusLines += ("ErrorCount: " + @($errors).Count)
$statusLines += ""
$statusLines += "# Files"
$statusLines += ""
$statusLines += ("SyncPacket: " + $SyncPacket)
$statusLines += ("CopyPlanManifest: " + $CopyPlanManifest)
$statusLines += ("CopyPlanManifestJson: " + $CopyPlanManifestJson)
$statusLines += ("SyncedFilesManifest: " + $SyncedFilesManifest)
$statusLines += ("SyncedFilesManifestJson: " + $SyncedFilesManifestJson)
$statusLines += ("GitStatusBeforeFile: " + $GitStatusBeforeFile)
$statusLines += ("GitStatusAfterFile: " + $GitStatusAfterFile)
$statusLines += ("PendingCard: " + $PendingCard)
$statusLines += ("NextObjectCard: " + $NextObjectCard)
$statusLines += ("Receipt: " + $Receipt)
$statusLines += ("ErrorLedger: " + $ErrorLedger)
$statusLines += ""
$statusLines += "# Boundary"
$statusLines += ""
$statusLines += "CommittedHere: false"
$statusLines += "PushedHere: false"
$statusLines += "DeletedFilesHere: false"
$statusLines += "ArchivedFilesHere: false"
$statusLines += "DedupedFilesHere: false"
$statusLines += "DoctrinePromotedHere: false"
$statusLines | Set-Content -LiteralPath $CurrentSyncStatusMd -Encoding UTF8

$receiptLines = @()
$receiptLines += "# RECEIPT"
$receiptLines += "## COMMAND CENTER UI LANE REPO SYNC PRE COMMIT GATE V1"
$receiptLines += ""
$receiptLines += ("Date: " + $DateTag)
$receiptLines += ("GeneratedUtc: " + (Get-UtcNow))
$receiptLines += ("RunStamp: " + $RunStamp)
$receiptLines += ("RepoSyncStatus: " + $syncStatus)
$receiptLines += ("NextLegalObject: " + $nextLegalObject)
$receiptLines += ("RepoSyncAuthorized: " + $syncAuthorized)
$receiptLines += ("SyncedHere: " + $syncedHere)
$receiptLines += ("CommittedHere: " + $committedHere)
$receiptLines += ("PushedHere: " + $pushedHere)
$receiptLines += ("WorkRoot: " + $WorkRoot)
$receiptLines += ("GitRoot: " + $GitRoot)
$receiptLines += ("SourceFileCount: " + $sourceFileCount)
$receiptLines += ("TargetVerifiedCount: " + $targetVerifiedCount)
$receiptLines += ("SyncPacket: " + $SyncPacket)
$receiptLines += ("CurrentSyncStatus: " + $CurrentSyncStatusMd)
$receiptLines += ("CurrentSyncStatusJson: " + $CurrentSyncStatusJson)
$receiptLines += ("EntryOutput: " + $EntryOutput)
$receiptLines += ("ErrorLedger: " + $ErrorLedger)
$receiptLines += ("ErrorCount: " + @($errors).Count)
$receiptLines += ""
$receiptLines += "# Actions"
$receiptLines += ""
foreach ($a in $actions) {
    $receiptLines += $a
}
$receiptLines += ""
$receiptLines += "# NoMutationFlags"
$receiptLines += ""
$receiptLines += ("SyncedHere: " + $syncedHere)
$receiptLines += "CommittedHere: false"
$receiptLines += "PushedHere: false"
$receiptLines += "DeletedFilesHere: false"
$receiptLines += "ArchivedFilesHere: false"
$receiptLines += "DedupedFilesHere: false"
$receiptLines += "DoctrinePromotedHere: false"
$receiptLines += "WatcherInstalledHere: false"
$receiptLines += "AutomationInstalledHere: false"
$receiptLines += ""
$receiptLines += "# DoesNotProve"
$receiptLines += ""
$receiptLines += "This receipt does not commit or push."
$receiptLines += "This receipt does not promote doctrine."
$receiptLines += "This receipt does not authorize cleanup."
$receiptLines | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host ""
Write-Host "Command Center UI lane repo sync pre-commit gate complete."
Write-Host "RepoSyncStatus:"
Write-Host $syncStatus
Write-Host ""
Write-Host "NextLegalObject:"
Write-Host $nextLegalObject
Write-Host ""
Write-Host "RepoSyncAuthorized:"
Write-Host $syncAuthorized
Write-Host ""
Write-Host "SyncedHere:"
Write-Host $syncedHere
Write-Host ""
Write-Host "CommittedHere:"
Write-Host $committedHere
Write-Host ""
Write-Host "PushedHere:"
Write-Host $pushedHere
Write-Host ""
Write-Host "WorkRoot:"
Write-Host $WorkRoot
Write-Host ""
Write-Host "GitRoot:"
Write-Host $GitRoot
Write-Host ""
Write-Host "SourceFileCount:"
Write-Host $sourceFileCount
Write-Host ""
Write-Host "TargetVerifiedCount:"
Write-Host $targetVerifiedCount
Write-Host ""
Write-Host "Current repo sync status:"
Write-Host $CurrentSyncStatusMd
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_GATE_FINALIZED"

