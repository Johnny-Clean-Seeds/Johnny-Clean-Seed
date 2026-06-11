<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1_20260606.ps1

PURPOSE:
Commit the repo-synced Command Center UI lane changes from the actual Git repo root.

WHY V1.1 EXISTS:
V1 correctly blocked because WorkRoot was not a Git repo.
Repo sync then copied approved WorkRoot UI lane files into the actual GitRoot.
V1.1 reads the repo-sync manifest and stages only those synced repo-relative files.

DEFAULT MODE:
Pending/plan-only. No git add. No commit. No push.

AUTHORIZED MODE:
If the exact authorization phrase is supplied, stage only synced manifest files and create one local Git commit.

REQUIRED COMMIT AUTHORIZATION PHRASE:
I AUTHORIZE COMMITTING THE REPO SYNCED COMMAND CENTER UI LANE INSTALL

THIS SCRIPT DOES:
- run/read Command Center work entrypoint from WorkRoot
- read repo-sync pre-commit status
- require REPO_SYNC_PRE_COMMIT_COMPLETE
- require SyncedHere true
- require ErrorCount 0
- require GitRoot is a repo
- inspect Git status before/after
- block if pre-existing staged files outside the synced manifest exist
- pending mode: write commit plan only
- authorized mode: git add only synced manifest files, then local commit

THIS SCRIPT DOES NOT:
- push
- cleanup/delete/archive/dedupe
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
    [switch]$AuthorizeCommit,

    [Parameter(Mandatory = $false)]
    [string]$AuthorizationPhrase = "",

    [Parameter(Mandatory = $false)]
    [string]$AuthorizedBy = "UNSPECIFIED",

    [Parameter(Mandatory = $false)]
    [string]$CommitMessage = "Install Command Center UI lane",

    [Parameter(Mandatory = $false)]
    [switch]$NoEntryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DateTag = "20260606"
$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$RequiredPhrase = "I AUTHORIZE COMMITTING THE REPO SYNCED COMMAND CENTER UI LANE INSTALL"

$WorkCommandCenterRoot = Join-Path $WorkRoot "COMMAND_CENTER"
$WorkEntryRoot = Join-Path $WorkCommandCenterRoot "WORK_ENTRYPOINT"
$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"

$WorkUiLaneRoot = Join-Path $WorkRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$RepoSyncRoot = Join-Path $WorkUiLaneRoot "REPO_SYNC_PRE_COMMIT_GATE"
$RepoSyncStatusMd = Join-Path $RepoSyncRoot "CURRENT_COMMAND_CENTER_UI_LANE_REPO_SYNC_PRE_COMMIT_STATUS.md"

$SaveCommitRoot = Join-Path $WorkUiLaneRoot "SAVE_AND_COMMIT_GATE"
$RunRoot = Join-Path $SaveCommitRoot ("COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1_" + $RunStamp)

$CurrentSaveCommitStatusMd = Join-Path $SaveCommitRoot "CURRENT_COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_STATUS_V1_1.md"
$CurrentSaveCommitStatusJson = Join-Path $SaveCommitRoot "CURRENT_COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_STATUS_V1_1.json"

$SaveCommitPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_PACKET_V1_1_20260606.md"
$ApprovedSyncedFiles = Join-Path $RunRoot "APPROVED_SYNCED_FILES__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_1_20260606.txt"
$GitStatusBeforeFile = Join-Path $RunRoot "GIT_STATUS_BEFORE__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_1_20260606.txt"
$GitStatusAfterFile = Join-Path $RunRoot "GIT_STATUS_AFTER__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_1_20260606.txt"
$PreExistingStagedFile = Join-Path $RunRoot "PRE_EXISTING_STAGED_FILES__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_1_20260606.txt"
$StagedFilesFile = Join-Path $RunRoot "STAGED_FILES__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_1_20260606.txt"
$CommitOutputFile = Join-Path $RunRoot "GIT_COMMIT_OUTPUT__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_1_20260606.txt"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_PUSH_GATE_V1_20260606.md"
$PendingCard = Join-Path $RunRoot "PENDING_CARD__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_SAVE_AND_COMMIT_GATE_V1_1.txt"

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

function Add-SaveCommitError {
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

function Normalize-RepoPath {
    param([string]$PathText)

    if ($null -eq $PathText) { return "" }
    $p = ([string]$PathText).Trim().Replace("\", "/")
    if ($p.StartsWith('"') -and $p.EndsWith('"')) {
        $p = $p.Trim('"')
    }
    return $p
}

function Get-PorcelainPath {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return "" }
    if ($Line.Length -lt 4) { return "" }
    $p = $Line.Substring(3).Trim()
    if ($p.Contains(" -> ")) {
        $parts = $p.Split(" -> ")
        return (Normalize-RepoPath $parts[-1])
    }
    return (Normalize-RepoPath $p)
}

function Test-ManifestContainsPath {
    param([string]$PathText, [hashtable]$ManifestSet)

    $p = Normalize-RepoPath $PathText
    return $ManifestSet.ContainsKey($p)
}

New-Dir $SaveCommitRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"

$repoSyncStatus = "UNKNOWN"
$repoSyncNextLegalObject = "UNKNOWN"
$repoSyncAuthorized = "UNKNOWN"
$syncedHere = "UNKNOWN"
$repoSyncErrorCount = "UNKNOWN"
$syncedFilesManifest = "UNKNOWN"
$syncedFilesManifestJson = "UNKNOWN"
$repoSyncGitRoot = "UNKNOWN"
$repoSyncHeadBefore = "UNKNOWN"
$repoSyncHeadAfter = "UNKNOWN"
$sourceFileCount = "UNKNOWN"
$targetVerifiedCount = "UNKNOWN"

$gitInsideWorkTree = "UNKNOWN"
$gitTopLevel = "UNKNOWN"
$gitBranch = "UNKNOWN"
$headBefore = "UNKNOWN"
$headAfter = "UNKNOWN"

$manifestPaths = @()
$manifestSet = @{}
$preExistingStaged = @()
$preExistingStagedOutsideManifest = @()
$stagedAfterAdd = @()
$stagedAfterAddOutsideManifest = @()
$statusBeforeLines = @()
$statusAfterLines = @()

$saveCommitStatus = "SAVE_AND_COMMIT_V1_1_PENDING_AUTHORIZATION"
$nextLegalObject = "WAIT_FOR_COMMIT_AUTHORIZATION"
$commitAuthorized = "false"
$committedHere = "false"
$pushedHere = "false"
$commitExitCode = "NOT_RUN"

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-SaveCommitError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Work entrypoint required before save/commit."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_SAVE_AND_COMMIT_GATE_V1_1: " + $WorkEntryScript)
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-SaveCommitError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint before save/commit."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"
        $actions += ("READ_WORK_ENTRY_STATUS: " + $WorkEntryStatusMd)

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-SaveCommitError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Resolve work entry/pre-run block first."
        }

        if ($openSideQuestRequired -ne "False") {
            Add-SaveCommitError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error-triggered helper harvest first."
        }
    }

    if (-not (Test-Path -LiteralPath $RepoSyncStatusMd)) {
        Add-SaveCommitError -Category "REPO_SYNC_STATUS_MISSING" -Phase "READ_REPO_SYNC_STATUS" -Message $RepoSyncStatusMd -Resolution "Run repo sync pre-commit gate before save/commit V1.1."
    }
    else {
        $syncText = Get-Content -LiteralPath $RepoSyncStatusMd -Raw -ErrorAction Stop
        $repoSyncStatus = Get-InlineValue -Text $syncText -Name "RepoSyncStatus"
        $repoSyncNextLegalObject = Get-InlineValue -Text $syncText -Name "NextLegalObject"
        $repoSyncAuthorized = Get-InlineValue -Text $syncText -Name "RepoSyncAuthorized"
        $syncedHere = Get-InlineValue -Text $syncText -Name "SyncedHere"
        $repoSyncErrorCount = Get-InlineValue -Text $syncText -Name "ErrorCount"
        $syncedFilesManifest = Get-InlineValue -Text $syncText -Name "SyncedFilesManifest"
        $syncedFilesManifestJson = Get-InlineValue -Text $syncText -Name "SyncedFilesManifestJson"
        $repoSyncGitRoot = Get-InlineValue -Text $syncText -Name "GitRoot"
        $repoSyncHeadBefore = Get-InlineValue -Text $syncText -Name "HeadBefore"
        $repoSyncHeadAfter = Get-InlineValue -Text $syncText -Name "HeadAfter"
        $sourceFileCount = Get-InlineValue -Text $syncText -Name "SourceFileCount"
        $targetVerifiedCount = Get-InlineValue -Text $syncText -Name "TargetVerifiedCount"
        $actions += ("READ_REPO_SYNC_STATUS: " + $RepoSyncStatusMd)

        if ($repoSyncStatus -ne "REPO_SYNC_PRE_COMMIT_COMPLETE") {
            Add-SaveCommitError -Category "REPO_SYNC_NOT_COMPLETE" -Phase "READ_REPO_SYNC_STATUS" -Message ("RepoSyncStatus=" + $repoSyncStatus) -Resolution "Run authorized repo sync before save/commit."
        }

        if ($repoSyncNextLegalObject -ne "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1") {
            Add-SaveCommitError -Category "REPO_SYNC_NEXT_OBJECT_UNEXPECTED" -Phase "READ_REPO_SYNC_STATUS" -Message ("NextLegalObject=" + $repoSyncNextLegalObject) -Resolution "Review repo sync output."
        }

        if ($repoSyncAuthorized -ne "true" -or $syncedHere -ne "true") {
            Add-SaveCommitError -Category "REPO_SYNC_NOT_AUTHORIZED_OR_NOT_SYNCED" -Phase "READ_REPO_SYNC_STATUS" -Message ("RepoSyncAuthorized=" + $repoSyncAuthorized + " SyncedHere=" + $syncedHere) -Resolution "Authorize and run repo sync before commit."
        }

        if ($repoSyncErrorCount -ne "0") {
            Add-SaveCommitError -Category "REPO_SYNC_ERROR_COUNT_NOT_ZERO" -Phase "READ_REPO_SYNC_STATUS" -Message ("ErrorCount=" + $repoSyncErrorCount) -Resolution "Fix repo sync errors before commit."
        }

        if ($repoSyncGitRoot -ne "UNKNOWN") {
            $expected = [System.IO.Path]::GetFullPath($GitRoot).TrimEnd("\")
            $actual = [System.IO.Path]::GetFullPath($repoSyncGitRoot).TrimEnd("\")
            if (-not [string]::Equals($expected, $actual, [System.StringComparison]::OrdinalIgnoreCase)) {
                Add-SaveCommitError -Category "GIT_ROOT_DIFFERS_FROM_REPO_SYNC_STATUS" -Phase "READ_REPO_SYNC_STATUS" -Message ("GateGitRoot=" + $GitRoot + " RepoSyncGitRoot=" + $repoSyncGitRoot) -Resolution "Use the same GitRoot as repo sync."
            }
        }
    }

    if ($syncedFilesManifest -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $syncedFilesManifest)) {
        Add-SaveCommitError -Category "SYNCED_FILES_MANIFEST_MISSING" -Phase "READ_SYNCED_MANIFEST" -Message ("SyncedFilesManifest=" + $syncedFilesManifest) -Resolution "Regenerate repo sync gate."
    }
    else {
        $manifestPaths = @(Get-Content -LiteralPath $syncedFilesManifest -ErrorAction Stop | ForEach-Object { Normalize-RepoPath $_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)
        foreach ($p in $manifestPaths) {
            $manifestSet[$p] = $true
        }
        $manifestPaths | Set-Content -LiteralPath $ApprovedSyncedFiles -Encoding UTF8
        $actions += ("READ_SYNCED_FILES_MANIFEST: " + $syncedFilesManifest)
    }

    if (@($manifestPaths).Count -lt 1) {
        Add-SaveCommitError -Category "SYNCED_FILES_MANIFEST_EMPTY" -Phase "READ_SYNCED_MANIFEST" -Message "Approved synced manifest has zero files." -Resolution "Regenerate repo sync gate."
    }

    if (-not (Test-Path -LiteralPath $GitRoot)) {
        Add-SaveCommitError -Category "GIT_ROOT_MISSING" -Phase "GIT_PREFLIGHT" -Message $GitRoot -Resolution "Use actual repo root."
    }
    else {
        $inside = Invoke-GitCapture -ArgList @("rev-parse", "--is-inside-work-tree")
        if ($inside.ExitCode -ne 0) {
            Add-SaveCommitError -Category "GIT_ROOT_NOT_REPO" -Phase "GIT_PREFLIGHT" -Message $inside.Text -Resolution "Use actual GitRoot containing .git."
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
        if ($statusBefore.ExitCode -ne 0) {
            Add-SaveCommitError -Category "GIT_STATUS_BEFORE_FAILED" -Phase "GIT_STATUS" -Message $statusBefore.Text -Resolution "Review Git status manually."
        }
        else {
            $statusBeforeLines = @($statusBefore.Output | ForEach-Object { [string]$_ })
            $statusBeforeLines | Set-Content -LiteralPath $GitStatusBeforeFile -Encoding UTF8
            $actions += ("WROTE_GIT_STATUS_BEFORE: " + $GitStatusBeforeFile)
        }

        $preStaged = Invoke-GitCapture -ArgList @("diff", "--cached", "--name-only")
        if ($preStaged.ExitCode -ne 0) {
            Add-SaveCommitError -Category "GIT_PRE_EXISTING_STAGED_CHECK_FAILED" -Phase "GIT_DIFF_CACHED" -Message $preStaged.Text -Resolution "Review staged files manually."
        }
        else {
            $preExistingStaged = @($preStaged.Output | ForEach-Object { Normalize-RepoPath $_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
            $preExistingStaged | Set-Content -LiteralPath $PreExistingStagedFile -Encoding UTF8

            foreach ($p in $preExistingStaged) {
                if (-not (Test-ManifestContainsPath -PathText $p -ManifestSet $manifestSet)) {
                    $preExistingStagedOutsideManifest += $p
                }
            }

            if (@($preExistingStagedOutsideManifest).Count -gt 0) {
                Add-SaveCommitError -Category "PRE_EXISTING_STAGED_OUTSIDE_SYNC_MANIFEST" -Phase "GIT_DIFF_CACHED" -Message ("Count=" + @($preExistingStagedOutsideManifest).Count) -Resolution "Unstage or commit unrelated staged files before this gated commit."
            }
        }
    }

    if ($AuthorizeCommit) {
        if ($AuthorizationPhrase -ne $RequiredPhrase) {
            Add-SaveCommitError -Category "COMMIT_AUTHORIZATION_PHRASE_MISMATCH" -Phase "COMMIT_AUTHORIZATION" -Message "AuthorizeCommit was supplied, but phrase did not match required phrase." -Resolution ("Use exact phrase: " + $RequiredPhrase)
        }
        else {
            $commitAuthorized = "true"
            $actions += "COMMIT_AUTHORIZATION_ACCEPTED"
        }
    }
    else {
        $actions += "NO_COMMIT_AUTHORIZATION_SUPPLIED_PENDING_ONLY"
    }

    if ($AuthorizeCommit -and $commitAuthorized -eq "true" -and @($errors).Count -eq 0) {
        $addArgs = @("add", "--") + $manifestPaths
        $addResult = Invoke-GitCapture -ArgList $addArgs
        if ($addResult.ExitCode -ne 0) {
            Add-SaveCommitError -Category "GIT_ADD_SYNCED_MANIFEST_FAILED" -Phase "GIT_ADD" -Message $addResult.Text -Resolution "Review synced manifest paths."
        }
        else {
            $actions += "GIT_ADD_SYNCED_MANIFEST_COMPLETE"
        }

        if (@($errors).Count -eq 0) {
            $stagedResult = Invoke-GitCapture -ArgList @("diff", "--cached", "--name-only")
            if ($stagedResult.ExitCode -ne 0) {
                Add-SaveCommitError -Category "GIT_STAGED_LIST_FAILED" -Phase "GIT_DIFF_CACHED" -Message $stagedResult.Text -Resolution "Review staged files manually."
            }
            else {
                $stagedAfterAdd = @($stagedResult.Output | ForEach-Object { Normalize-RepoPath $_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
                $stagedAfterAdd | Set-Content -LiteralPath $StagedFilesFile -Encoding UTF8

                foreach ($p in $stagedAfterAdd) {
                    if (-not (Test-ManifestContainsPath -PathText $p -ManifestSet $manifestSet)) {
                        $stagedAfterAddOutsideManifest += $p
                    }
                }

                if (@($stagedAfterAddOutsideManifest).Count -gt 0) {
                    Add-SaveCommitError -Category "STAGED_AFTER_ADD_OUTSIDE_SYNC_MANIFEST" -Phase "GIT_DIFF_CACHED" -Message ("Count=" + @($stagedAfterAddOutsideManifest).Count) -Resolution "Abort commit; staged set contains paths outside synced manifest."
                }
            }
        }

        if (@($errors).Count -eq 0) {
            if (@($stagedAfterAdd).Count -lt 1) {
                $saveCommitStatus = "SAVE_AND_COMMIT_V1_1_NO_CHANGES_TO_COMMIT"
                $nextLegalObject = "COMMAND_CENTER_UI_LANE_PUSH_GATE_V1_NOT_NEEDED_UNLESS_PRIOR_COMMIT_EXISTS"
                $actions += "NO_STAGED_CHANGES_NO_COMMIT_CREATED"
            }
            else {
                $commitResult = Invoke-GitCapture -ArgList @("commit", "-m", $CommitMessage)
                $commitExitCode = [string]$commitResult.ExitCode
                @($commitResult.Output | ForEach-Object { [string]$_ }) | Set-Content -LiteralPath $CommitOutputFile -Encoding UTF8

                if ($commitResult.ExitCode -ne 0) {
                    Add-SaveCommitError -Category "GIT_COMMIT_FAILED" -Phase "GIT_COMMIT" -Message $commitResult.Text -Resolution "Review Git commit output."
                    $saveCommitStatus = "SAVE_AND_COMMIT_V1_1_BLOCKED"
                    $nextLegalObject = "FIX_SAVE_AND_COMMIT_V1_1_BLOCKERS"
                }
                else {
                    $committedHere = "true"
                    $saveCommitStatus = "SAVE_AND_COMMIT_V1_1_COMPLETE"
                    $nextLegalObject = "COMMAND_CENTER_UI_LANE_PUSH_GATE_V1"
                    $actions += ("GIT_COMMIT_COMPLETE: " + $CommitMessage)
                }
            }
        }
    }

    $headAfterResult = Invoke-GitCapture -ArgList @("rev-parse", "HEAD")
    if ($headAfterResult.ExitCode -eq 0) {
        $headAfter = (($headAfterResult.Output | Select-Object -First 1) -as [string])
    }

    $statusAfter = Invoke-GitCapture -ArgList @("status", "--porcelain=v1")
    if ($statusAfter.ExitCode -eq 0) {
        $statusAfterLines = @($statusAfter.Output | ForEach-Object { [string]$_ })
        $statusAfterLines | Set-Content -LiteralPath $GitStatusAfterFile -Encoding UTF8
        $actions += ("WROTE_GIT_STATUS_AFTER: " + $GitStatusAfterFile)
    }

    if (-not $AuthorizeCommit -and @($errors).Count -eq 0) {
        $saveCommitStatus = "SAVE_AND_COMMIT_V1_1_PENDING_AUTHORIZATION"
        $nextLegalObject = "WAIT_FOR_COMMIT_AUTHORIZATION"
    }

    if (@($errors).Count -gt 0) {
        $saveCommitStatus = "SAVE_AND_COMMIT_V1_1_BLOCKED"
        $nextLegalObject = "FIX_SAVE_AND_COMMIT_V1_1_BLOCKERS"
    }
}
catch {
    Add-SaveCommitError -Category "SAVE_AND_COMMIT_V1_1_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review save/commit V1.1 error ledger."
    $saveCommitStatus = "SAVE_AND_COMMIT_V1_1_GATE_EXCEPTION"
    $nextLegalObject = "FIX_SAVE_AND_COMMIT_V1_1_GATE_EXCEPTION"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE SAVE AND COMMIT GATE V1.1"
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
$errorLines += "This error ledger does not push."
$errorLines += "This error ledger does not promote doctrine."
$errorLines += "This error ledger does not authorize cleanup."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$pendingLines = @()
$pendingLines += "# PENDING CARD"
$pendingLines += "## COMMAND CENTER UI LANE SAVE AND COMMIT V1.1"
$pendingLines += ""
$pendingLines += ("GeneratedUtc: " + (Get-UtcNow))
$pendingLines += ("SaveCommitStatus: " + $saveCommitStatus)
$pendingLines += ""
$pendingLines += "# Required Phrase"
$pendingLines += ""
$pendingLines += $RequiredPhrase
$pendingLines += ""
$pendingLines += "# Commit Command"
$pendingLines += ""
$pendingLines += 'pwsh -NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '" -AuthorizeCommit -AuthorizationPhrase "' + $RequiredPhrase + '" -AuthorizedBy "Jonathon" -CommitMessage "Install Command Center UI lane"'
$pendingLines += ""
$pendingLines += "# Boundary"
$pendingLines += ""
$pendingLines += "This pending card does not push."
$pendingLines += "This pending card does not cleanup/delete/archive/dedupe."
$pendingLines | Set-Content -LiteralPath $PendingCard -Encoding UTF8

$packetLines = @()
$packetLines += "# COMMAND CENTER UI LANE SAVE AND COMMIT PACKET"
$packetLines += "## V1.1"
$packetLines += ""
$packetLines += ("GeneratedUtc: " + (Get-UtcNow))
$packetLines += ("RunStamp: " + $RunStamp)
$packetLines += ("SaveCommitStatus: " + $saveCommitStatus)
$packetLines += ("NextLegalObject: " + $nextLegalObject)
$packetLines += ("CommitAuthorized: " + $commitAuthorized)
$packetLines += ("CommittedHere: " + $committedHere)
$packetLines += ("PushedHere: " + $pushedHere)
$packetLines += ("AuthorizedBy: " + $AuthorizedBy)
$packetLines += ("CommitMessage: " + $CommitMessage)
$packetLines += ("CommitExitCode: " + $commitExitCode)
$packetLines += ("ErrorCount: " + @($errors).Count)
$packetLines += ""
$packetLines += "# Git"
$packetLines += ""
$packetLines += ("GitRoot: " + $GitRoot)
$packetLines += ("GitInsideWorkTree: " + $gitInsideWorkTree)
$packetLines += ("GitTopLevel: " + $gitTopLevel)
$packetLines += ("GitBranch: " + $gitBranch)
$packetLines += ("HeadBefore: " + $headBefore)
$packetLines += ("HeadAfter: " + $headAfter)
$packetLines += ("ManifestPathCount: " + @($manifestPaths).Count)
$packetLines += ("PreExistingStagedCount: " + @($preExistingStaged).Count)
$packetLines += ("PreExistingStagedOutsideManifestCount: " + @($preExistingStagedOutsideManifest).Count)
$packetLines += ("StagedAfterAddCount: " + @($stagedAfterAdd).Count)
$packetLines += ("StagedAfterAddOutsideManifestCount: " + @($stagedAfterAddOutsideManifest).Count)
$packetLines += ""
$packetLines += "# Source Repo Sync"
$packetLines += ""
$packetLines += ("RepoSyncStatus: " + $repoSyncStatus)
$packetLines += ("RepoSyncAuthorized: " + $repoSyncAuthorized)
$packetLines += ("SyncedHere: " + $syncedHere)
$packetLines += ("SourceFileCount: " + $sourceFileCount)
$packetLines += ("TargetVerifiedCount: " + $targetVerifiedCount)
$packetLines += ("SyncedFilesManifest: " + $syncedFilesManifest)
$packetLines += ""
$packetLines += "# Files"
$packetLines += ""
$packetLines += ("ApprovedSyncedFiles: " + $ApprovedSyncedFiles)
$packetLines += ("GitStatusBeforeFile: " + $GitStatusBeforeFile)
$packetLines += ("GitStatusAfterFile: " + $GitStatusAfterFile)
$packetLines += ("PreExistingStagedFile: " + $PreExistingStagedFile)
$packetLines += ("StagedFilesFile: " + $StagedFilesFile)
$packetLines += ("CommitOutputFile: " + $CommitOutputFile)
$packetLines += ("PendingCard: " + $PendingCard)
$packetLines += ("NextObjectCard: " + $NextObjectCard)
$packetLines += ("Receipt: " + $Receipt)
$packetLines += ("ErrorLedger: " + $ErrorLedger)
$packetLines += ""
$packetLines += "# Boundary"
$packetLines += ""
$packetLines += "PushedHere: false"
$packetLines += "CleanupHere: false"
$packetLines += "DoctrinePromotedHere: false"
$packetLines += "WatcherInstalledHere: false"
$packetLines += "AutomationInstalledHere: false"
$packetLines | Set-Content -LiteralPath $SaveCommitPacket -Encoding UTF8

$nextLines = @()
$nextLines += "# NEXT OBJECT CARD"
$nextLines += "## COMMAND_CENTER_UI_LANE_PUSH_GATE_V1"
$nextLines += ""
$nextLines += ("GeneratedUtc: " + (Get-UtcNow))
$nextLines += ("SaveCommitStatus: " + $saveCommitStatus)
$nextLines += ("CommittedHere: " + $committedHere)
$nextLines += ("HeadAfter: " + $headAfter)
$nextLines += ("SourceSaveCommitPacket: " + $SaveCommitPacket)
$nextLines += ""
$nextLines += "# Legal Meaning"
$nextLines += ""
if ($saveCommitStatus -eq "SAVE_AND_COMMIT_V1_1_COMPLETE") {
    $nextLines += "A later push gate may be prepared if push is explicitly authorized."
}
elseif ($saveCommitStatus -eq "SAVE_AND_COMMIT_V1_1_NO_CHANGES_TO_COMMIT") {
    $nextLines += "No new commit was created because there were no staged manifest changes."
}
else {
    $nextLines += "Push is not legal until save/commit is complete."
}
$nextLines += ""
$nextLines += "# Still Not Authorized Here"
$nextLines += ""
$nextLines += "PushedHere: false"
$nextLines += "CleanupHere: false"
$nextLines += "DoctrinePromotedHere: false"
$nextLines | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    SaveCommitStatus = $saveCommitStatus
    NextLegalObject = $nextLegalObject
    CommitAuthorized = $commitAuthorized
    CommittedHere = $committedHere
    PushedHere = $pushedHere
    AuthorizedBy = $AuthorizedBy
    CommitMessage = $CommitMessage
    CommitExitCode = $commitExitCode
    WorkRoot = $WorkRoot
    GitRoot = $GitRoot
    WorkEntryStatus = $workEntryStatus
    OpenSideQuestRequired = $openSideQuestRequired
    RepoSyncStatus = $repoSyncStatus
    RepoSyncAuthorized = $repoSyncAuthorized
    SyncedHere = $syncedHere
    SourceFileCount = $sourceFileCount
    TargetVerifiedCount = $targetVerifiedCount
    SyncedFilesManifest = $syncedFilesManifest
    GitBranch = $gitBranch
    HeadBefore = $headBefore
    HeadAfter = $headAfter
    ManifestPathCount = @($manifestPaths).Count
    PreExistingStagedCount = @($preExistingStaged).Count
    PreExistingStagedOutsideManifestCount = @($preExistingStagedOutsideManifest).Count
    StagedAfterAddCount = @($stagedAfterAdd).Count
    StagedAfterAddOutsideManifestCount = @($stagedAfterAddOutsideManifest).Count
    SaveCommitPacket = $SaveCommitPacket
    ApprovedSyncedFiles = $ApprovedSyncedFiles
    GitStatusBeforeFile = $GitStatusBeforeFile
    GitStatusAfterFile = $GitStatusAfterFile
    PreExistingStagedFile = $PreExistingStagedFile
    StagedFilesFile = $StagedFilesFile
    CommitOutputFile = $CommitOutputFile
    PendingCard = $PendingCard
    NextObjectCard = $NextObjectCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentSaveCommitStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE SAVE AND COMMIT STATUS V1.1"
$statusLines += ""
$statusLines += ("GeneratedUtc: " + $statusObj.GeneratedUtc)
$statusLines += ("RunStamp: " + $RunStamp)
$statusLines += ("SaveCommitStatus: " + $saveCommitStatus)
$statusLines += ("NextLegalObject: " + $nextLegalObject)
$statusLines += ("CommitAuthorized: " + $commitAuthorized)
$statusLines += ("CommittedHere: " + $committedHere)
$statusLines += ("PushedHere: " + $pushedHere)
$statusLines += ("AuthorizedBy: " + $AuthorizedBy)
$statusLines += ("CommitMessage: " + $CommitMessage)
$statusLines += ("CommitExitCode: " + $commitExitCode)
$statusLines += ("WorkRoot: " + $WorkRoot)
$statusLines += ("GitRoot: " + $GitRoot)
$statusLines += ("WorkEntryStatus: " + $workEntryStatus)
$statusLines += ("OpenSideQuestRequired: " + $openSideQuestRequired)
$statusLines += ("RepoSyncStatus: " + $repoSyncStatus)
$statusLines += ("RepoSyncAuthorized: " + $repoSyncAuthorized)
$statusLines += ("SyncedHere: " + $syncedHere)
$statusLines += ("SourceFileCount: " + $sourceFileCount)
$statusLines += ("TargetVerifiedCount: " + $targetVerifiedCount)
$statusLines += ("SyncedFilesManifest: " + $syncedFilesManifest)
$statusLines += ("GitBranch: " + $gitBranch)
$statusLines += ("HeadBefore: " + $headBefore)
$statusLines += ("HeadAfter: " + $headAfter)
$statusLines += ("ManifestPathCount: " + @($manifestPaths).Count)
$statusLines += ("PreExistingStagedCount: " + @($preExistingStaged).Count)
$statusLines += ("PreExistingStagedOutsideManifestCount: " + @($preExistingStagedOutsideManifest).Count)
$statusLines += ("StagedAfterAddCount: " + @($stagedAfterAdd).Count)
$statusLines += ("StagedAfterAddOutsideManifestCount: " + @($stagedAfterAddOutsideManifest).Count)
$statusLines += ("ErrorCount: " + @($errors).Count)
$statusLines += ""
$statusLines += "# Files"
$statusLines += ""
$statusLines += ("SaveCommitPacket: " + $SaveCommitPacket)
$statusLines += ("ApprovedSyncedFiles: " + $ApprovedSyncedFiles)
$statusLines += ("GitStatusBeforeFile: " + $GitStatusBeforeFile)
$statusLines += ("GitStatusAfterFile: " + $GitStatusAfterFile)
$statusLines += ("PreExistingStagedFile: " + $PreExistingStagedFile)
$statusLines += ("StagedFilesFile: " + $StagedFilesFile)
$statusLines += ("CommitOutputFile: " + $CommitOutputFile)
$statusLines += ("PendingCard: " + $PendingCard)
$statusLines += ("NextObjectCard: " + $NextObjectCard)
$statusLines += ("Receipt: " + $Receipt)
$statusLines += ("ErrorLedger: " + $ErrorLedger)
$statusLines += ""
$statusLines += "# Boundary"
$statusLines += ""
$statusLines += "PushedHere: false"
$statusLines += "CleanupHere: false"
$statusLines += "DoctrinePromotedHere: false"
$statusLines += "WatcherInstalledHere: false"
$statusLines += "AutomationInstalledHere: false"
$statusLines | Set-Content -LiteralPath $CurrentSaveCommitStatusMd -Encoding UTF8

$receiptLines = @()
$receiptLines += "# RECEIPT"
$receiptLines += "## COMMAND CENTER UI LANE SAVE AND COMMIT GATE V1.1"
$receiptLines += ""
$receiptLines += ("Date: " + $DateTag)
$receiptLines += ("GeneratedUtc: " + (Get-UtcNow))
$receiptLines += ("RunStamp: " + $RunStamp)
$receiptLines += ("SaveCommitStatus: " + $saveCommitStatus)
$receiptLines += ("NextLegalObject: " + $nextLegalObject)
$receiptLines += ("CommitAuthorized: " + $commitAuthorized)
$receiptLines += ("CommittedHere: " + $committedHere)
$receiptLines += ("PushedHere: " + $pushedHere)
$receiptLines += ("HeadBefore: " + $headBefore)
$receiptLines += ("HeadAfter: " + $headAfter)
$receiptLines += ("SaveCommitPacket: " + $SaveCommitPacket)
$receiptLines += ("CurrentSaveCommitStatus: " + $CurrentSaveCommitStatusMd)
$receiptLines += ("CurrentSaveCommitStatusJson: " + $CurrentSaveCommitStatusJson)
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
$receiptLines += ("CommittedHere: " + $committedHere)
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
$receiptLines += "This receipt does not push."
$receiptLines += "This receipt does not promote doctrine."
$receiptLines += "This receipt does not authorize cleanup."
$receiptLines | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host ""
Write-Host "Command Center UI lane save and commit gate V1.1 complete."
Write-Host "SaveCommitStatus:"
Write-Host $saveCommitStatus
Write-Host ""
Write-Host "NextLegalObject:"
Write-Host $nextLegalObject
Write-Host ""
Write-Host "CommitAuthorized:"
Write-Host $commitAuthorized
Write-Host ""
Write-Host "CommittedHere:"
Write-Host $committedHere
Write-Host ""
Write-Host "PushedHere:"
Write-Host $pushedHere
Write-Host ""
Write-Host "GitRoot:"
Write-Host $GitRoot
Write-Host ""
Write-Host "HeadBefore:"
Write-Host $headBefore
Write-Host ""
Write-Host "HeadAfter:"
Write-Host $headAfter
Write-Host ""
Write-Host "ManifestPathCount:"
Write-Host @($manifestPaths).Count
Write-Host ""
Write-Host "PreExistingStagedOutsideManifestCount:"
Write-Host @($preExistingStagedOutsideManifest).Count
Write-Host ""
Write-Host "StagedAfterAddCount:"
Write-Host @($stagedAfterAdd).Count
Write-Host ""
Write-Host "StagedAfterAddOutsideManifestCount:"
Write-Host @($stagedAfterAddOutsideManifest).Count
Write-Host ""
Write-Host "Current save/commit status:"
Write-Host $CurrentSaveCommitStatusMd
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_1_FINALIZED"

