<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_20260606.ps1

PURPOSE:
Prepare and optionally perform the local Git save/commit for the completed Command Center UI lane install.

DEFAULT MODE:
Pending/plan-only. No git add. No commit.

AUTHORIZED MODE:
If the exact authorization phrase is supplied, stage only the approved Command Center UI lane paths and create one local Git commit.

REQUIRED COMMIT AUTHORIZATION PHRASE:
I AUTHORIZE COMMITTING THE COMMAND CENTER UI LANE INSTALL

THIS SCRIPT DOES:
- run/read Command Center work entrypoint
- read post-install closeout status
- require POST_INSTALL_VERIFY_AND_CLOSEOUT_COMPLETE
- inspect Git state
- define approved pathspecs
- pending mode: write commit plan only
- authorized mode: git add approved pathspecs only, commit locally, write receipt

THIS SCRIPT DOES NOT:
- push
- cleanup/delete/archive/dedupe
- promote doctrine
- install watcher
- install automation
- add root drop scripts unless already inside approved pathspecs
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

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
$RequiredPhrase = "I AUTHORIZE COMMITTING THE COMMAND CENTER UI LANE INSTALL"

$CommandCenterRoot = Join-Path $Root "COMMAND_CENTER"
$WorkEntryRoot = Join-Path $CommandCenterRoot "WORK_ENTRYPOINT"
$UiLaneRoot = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$CloseoutRoot = Join-Path $UiLaneRoot "POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE"
$SaveCommitRoot = Join-Path $UiLaneRoot "SAVE_AND_COMMIT_GATE"
$RunRoot = Join-Path $SaveCommitRoot ("COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$InstalledStatusMd = Join-Path $CloseoutRoot "CURRENT_COMMAND_CENTER_UI_LANE_INSTALLED_STATUS.md"
$InstalledStatusJson = Join-Path $CloseoutRoot "CURRENT_COMMAND_CENTER_UI_LANE_INSTALLED_STATUS.json"

$CurrentSaveCommitStatusMd = Join-Path $SaveCommitRoot "CURRENT_COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_STATUS.md"
$CurrentSaveCommitStatusJson = Join-Path $SaveCommitRoot "CURRENT_COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_STATUS.json"

$SaveCommitPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_PACKET_V1_20260606.md"
$ApprovedPathspecsFile = Join-Path $RunRoot "APPROVED_PATHSPECS__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_20260606.md"
$GitStatusBeforeFile = Join-Path $RunRoot "GIT_STATUS_BEFORE__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_20260606.txt"
$GitStatusAfterFile = Join-Path $RunRoot "GIT_STATUS_AFTER__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_20260606.txt"
$StagedFilesFile = Join-Path $RunRoot "STAGED_FILES__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_20260606.txt"
$CommitOutputFile = Join-Path $RunRoot "GIT_COMMIT_OUTPUT__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_20260606.txt"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_PUSH_GATE_V1_20260606.md"
$PendingCard = Join-Path $RunRoot "PENDING_CARD__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_V1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_SAVE_AND_COMMIT_GATE.txt"

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

    $out = & git -C $Root @ArgList 2>&1
    $code = $LASTEXITCODE

    return [pscustomobject]@{
        ExitCode = $code
        Output = @($out)
        Text = (@($out) -join "`n")
    }
}

function Get-PorcelainPath {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return "" }
    if ($Line.Length -lt 4) { return "" }
    return $Line.Substring(3).Trim()
}

function Test-ApprovedPath {
    param([string]$PathText, [string[]]$ApprovedPathspecs)

    $p = $PathText.Replace("\", "/")
    foreach ($a in $ApprovedPathspecs) {
        if ($p.StartsWith($a, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }
    return $false
}

New-Dir $SaveCommitRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$approvedPathspecs = @(
    "HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE",
    "COMMAND_CENTER/UI_LANE",
    "COMMAND_CENTER/PRE_RUN_GATES",
    "COMMAND_CENTER/WORK_ENTRYPOINT",
    "COMMAND_CENTER/RECEIPTS"
)

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"

$closeoutStatus = "UNKNOWN"
$installedNextLegalObject = "UNKNOWN"
$manifestTargetFileCount = "UNKNOWN"
$actualTargetFileCount = "UNKNOWN"
$verifiedTargetCount = "UNKNOWN"
$missingTargetCount = "UNKNOWN"
$hashMismatchCount = "UNKNOWN"
$extraTargetFileCount = "UNKNOWN"
$installedErrorCount = "UNKNOWN"

$gitInsideWorkTree = "UNKNOWN"
$gitBranch = "UNKNOWN"
$headBefore = "UNKNOWN"
$headAfter = "UNKNOWN"
$statusBeforeLines = @()
$statusAfterLines = @()
$approvedDirtyBefore = @()
$outsideDirtyBefore = @()
$stagedFiles = @()
$commitOutput = @()

$saveCommitStatus = "SAVE_AND_COMMIT_PENDING_AUTHORIZATION"
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
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_SAVE_AND_COMMIT_GATE: " + $WorkEntryScript)
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

    if (-not (Test-Path -LiteralPath $InstalledStatusMd)) {
        Add-SaveCommitError -Category "INSTALLED_STATUS_MISSING" -Phase "READ_INSTALLED_STATUS" -Message $InstalledStatusMd -Resolution "Run post-install verify and closeout before save/commit."
    }
    else {
        $installedText = Get-Content -LiteralPath $InstalledStatusMd -Raw -ErrorAction Stop
        $closeoutStatus = Get-InlineValue -Text $installedText -Name "CloseoutStatus"
        $installedNextLegalObject = Get-InlineValue -Text $installedText -Name "NextLegalObject"
        $manifestTargetFileCount = Get-InlineValue -Text $installedText -Name "ManifestTargetFileCount"
        $actualTargetFileCount = Get-InlineValue -Text $installedText -Name "ActualTargetFileCount"
        $verifiedTargetCount = Get-InlineValue -Text $installedText -Name "VerifiedTargetCount"
        $missingTargetCount = Get-InlineValue -Text $installedText -Name "MissingTargetCount"
        $hashMismatchCount = Get-InlineValue -Text $installedText -Name "HashMismatchCount"
        $extraTargetFileCount = Get-InlineValue -Text $installedText -Name "ExtraTargetFileCount"
        $installedErrorCount = Get-InlineValue -Text $installedText -Name "ErrorCount"
        $actions += ("READ_INSTALLED_STATUS: " + $InstalledStatusMd)

        if ($closeoutStatus -ne "POST_INSTALL_VERIFY_AND_CLOSEOUT_COMPLETE") {
            Add-SaveCommitError -Category "CLOSEOUT_NOT_COMPLETE" -Phase "READ_INSTALLED_STATUS" -Message ("CloseoutStatus=" + $closeoutStatus) -Resolution "Do not commit until closeout passes."
        }

        if ($installedNextLegalObject -ne "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1") {
            Add-SaveCommitError -Category "INSTALLED_NEXT_OBJECT_UNEXPECTED" -Phase "READ_INSTALLED_STATUS" -Message ("NextLegalObject=" + $installedNextLegalObject) -Resolution "Review installed status next object."
        }

        if ($manifestTargetFileCount -ne $actualTargetFileCount -or $manifestTargetFileCount -ne $verifiedTargetCount) {
            Add-SaveCommitError -Category "INSTALLED_COUNTS_NOT_ALIGNED" -Phase "READ_INSTALLED_STATUS" -Message ("Manifest=" + $manifestTargetFileCount + " Actual=" + $actualTargetFileCount + " Verified=" + $verifiedTargetCount) -Resolution "Re-run post-install closeout."
        }

        if ($missingTargetCount -ne "0" -or $hashMismatchCount -ne "0" -or $extraTargetFileCount -ne "0" -or $installedErrorCount -ne "0") {
            Add-SaveCommitError -Category "INSTALLED_STATUS_HAS_VERIFY_ERRORS" -Phase "READ_INSTALLED_STATUS" -Message ("Missing=" + $missingTargetCount + " HashMismatch=" + $hashMismatchCount + " Extra=" + $extraTargetFileCount + " ErrorCount=" + $installedErrorCount) -Resolution "Fix closeout blockers before commit."
        }
    }

    $inside = Invoke-GitCapture -ArgList @("rev-parse", "--is-inside-work-tree")
    if ($inside.ExitCode -ne 0) {
        Add-SaveCommitError -Category "GIT_NOT_AVAILABLE_OR_NOT_REPO" -Phase "GIT_PREFLIGHT" -Message $inside.Text -Resolution "Run from repository root with Git available."
    }
    else {
        $gitInsideWorkTree = ($inside.Output | Select-Object -First 1)
        $actions += "GIT_REPO_CONFIRMED"
    }

    $branchResult = Invoke-GitCapture -ArgList @("branch", "--show-current")
    if ($branchResult.ExitCode -eq 0) {
        $gitBranch = (($branchResult.Output | Select-Object -First 1) -as [string])
    }

    $headResult = Invoke-GitCapture -ArgList @("rev-parse", "HEAD")
    if ($headResult.ExitCode -eq 0) {
        $headBefore = (($headResult.Output | Select-Object -First 1) -as [string])
    }

    $statusBefore = Invoke-GitCapture -ArgList @("status", "--porcelain=v1")
    if ($statusBefore.ExitCode -ne 0) {
        Add-SaveCommitError -Category "GIT_STATUS_BEFORE_FAILED" -Phase "GIT_STATUS" -Message $statusBefore.Text -Resolution "Review Git status manually."
    }
    else {
        $statusBeforeLines = @($statusBefore.Output | ForEach-Object { [string]$_ })
        $statusBeforeLines | Set-Content -LiteralPath $GitStatusBeforeFile -Encoding UTF8
        $actions += ("WROTE_GIT_STATUS_BEFORE: " + $GitStatusBeforeFile)

        foreach ($line in $statusBeforeLines) {
            $p = Get-PorcelainPath -Line $line
            if (Test-ApprovedPath -PathText $p -ApprovedPathspecs $approvedPathspecs) {
                $approvedDirtyBefore += $line
            }
            else {
                $outsideDirtyBefore += $line
            }
        }
    }

    $pathLines = @()
    $pathLines += "# APPROVED PATHSPECS"
    $pathLines += "## COMMAND CENTER UI LANE SAVE AND COMMIT V1"
    $pathLines += ""
    $pathLines += ("GeneratedUtc: " + (Get-UtcNow))
    $pathLines += ""
    foreach ($p in $approvedPathspecs) {
        $pathLines += ("- " + $p)
    }
    $pathLines += ""
    $pathLines += "# Explicit Exclusions"
    $pathLines += ""
    $pathLines += "Root-level drop scripts are not staged unless they are inside an approved pathspec."
    $pathLines += "No cleanup/delete/archive/dedupe is performed."
    $pathLines += "No push is performed."
    $pathLines | Set-Content -LiteralPath $ApprovedPathspecsFile -Encoding UTF8

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
        $addArgs = @("add", "--") + $approvedPathspecs
        $addResult = Invoke-GitCapture -ArgList $addArgs
        if ($addResult.ExitCode -ne 0) {
            Add-SaveCommitError -Category "GIT_ADD_FAILED" -Phase "GIT_ADD" -Message $addResult.Text -Resolution "Review approved pathspecs and Git state."
        }
        else {
            $actions += "GIT_ADD_APPROVED_PATHSPECS_COMPLETE"
        }

        if (@($errors).Count -eq 0) {
            $stagedResult = Invoke-GitCapture -ArgList (@("diff", "--cached", "--name-only", "--") + $approvedPathspecs)
            if ($stagedResult.ExitCode -ne 0) {
                Add-SaveCommitError -Category "GIT_STAGED_LIST_FAILED" -Phase "GIT_DIFF_CACHED" -Message $stagedResult.Text -Resolution "Review staged files manually."
            }
            else {
                $stagedFiles = @($stagedResult.Output | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
                $stagedFiles | Set-Content -LiteralPath $StagedFilesFile -Encoding UTF8
                $actions += ("WROTE_STAGED_FILES: " + $StagedFilesFile)
            }
        }

        if (@($errors).Count -eq 0) {
            if (@($stagedFiles).Count -lt 1) {
                $saveCommitStatus = "SAVE_AND_COMMIT_NO_CHANGES_TO_COMMIT"
                $nextLegalObject = "COMMAND_CENTER_UI_LANE_PUSH_GATE_V1_NOT_NEEDED_UNLESS_PRIOR_COMMIT_EXISTS"
                $actions += "NO_STAGED_CHANGES_NO_COMMIT_CREATED"
            }
            else {
                $commitResult = Invoke-GitCapture -ArgList @("commit", "-m", $CommitMessage)
                $commitExitCode = [string]$commitResult.ExitCode
                $commitOutput = @($commitResult.Output | ForEach-Object { [string]$_ })
                $commitOutput | Set-Content -LiteralPath $CommitOutputFile -Encoding UTF8

                if ($commitResult.ExitCode -ne 0) {
                    Add-SaveCommitError -Category "GIT_COMMIT_FAILED" -Phase "GIT_COMMIT" -Message $commitResult.Text -Resolution "Review Git commit output."
                    $saveCommitStatus = "SAVE_AND_COMMIT_BLOCKED"
                    $nextLegalObject = "FIX_SAVE_AND_COMMIT_BLOCKERS"
                }
                else {
                    $committedHere = "true"
                    $saveCommitStatus = "SAVE_AND_COMMIT_COMPLETE"
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
        $saveCommitStatus = "SAVE_AND_COMMIT_PENDING_AUTHORIZATION"
        $nextLegalObject = "WAIT_FOR_COMMIT_AUTHORIZATION"
    }

    if (@($errors).Count -gt 0) {
        $saveCommitStatus = "SAVE_AND_COMMIT_BLOCKED"
        $nextLegalObject = "FIX_SAVE_AND_COMMIT_BLOCKERS"
    }
}
catch {
    Add-SaveCommitError -Category "SAVE_AND_COMMIT_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review save/commit error ledger."
    $saveCommitStatus = "SAVE_AND_COMMIT_GATE_EXCEPTION"
    $nextLegalObject = "FIX_SAVE_AND_COMMIT_GATE_EXCEPTION"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE SAVE AND COMMIT GATE V1"
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
$pendingLines += "## COMMAND CENTER UI LANE SAVE AND COMMIT V1"
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
$packetLines += "## V1"
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
$packetLines += ("GitInsideWorkTree: " + $gitInsideWorkTree)
$packetLines += ("GitBranch: " + $gitBranch)
$packetLines += ("HeadBefore: " + $headBefore)
$packetLines += ("HeadAfter: " + $headAfter)
$packetLines += ("ApprovedDirtyBeforeCount: " + @($approvedDirtyBefore).Count)
$packetLines += ("OutsideDirtyBeforeCount: " + @($outsideDirtyBefore).Count)
$packetLines += ("StagedFileCount: " + @($stagedFiles).Count)
$packetLines += ("StatusBefore: " + $GitStatusBeforeFile)
$packetLines += ("StatusAfter: " + $GitStatusAfterFile)
$packetLines += ("StagedFiles: " + $StagedFilesFile)
$packetLines += ("CommitOutput: " + $CommitOutputFile)
$packetLines += ""
$packetLines += "# Installed Status Source"
$packetLines += ""
$packetLines += ("InstalledStatus: " + $InstalledStatusMd)
$packetLines += ("CloseoutStatus: " + $closeoutStatus)
$packetLines += ("ManifestTargetFileCount: " + $manifestTargetFileCount)
$packetLines += ("ActualTargetFileCount: " + $actualTargetFileCount)
$packetLines += ("VerifiedTargetCount: " + $verifiedTargetCount)
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
if ($saveCommitStatus -eq "SAVE_AND_COMMIT_COMPLETE") {
    $nextLines += "A later push gate may be prepared if push is explicitly authorized."
}
elseif ($saveCommitStatus -eq "SAVE_AND_COMMIT_NO_CHANGES_TO_COMMIT") {
    $nextLines += "No new commit was created because there were no staged approved changes."
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
    WorkEntryStatus = $workEntryStatus
    OpenSideQuestRequired = $openSideQuestRequired
    InstalledStatus = $InstalledStatusMd
    CloseoutStatus = $closeoutStatus
    ManifestTargetFileCount = $manifestTargetFileCount
    ActualTargetFileCount = $actualTargetFileCount
    VerifiedTargetCount = $verifiedTargetCount
    GitBranch = $gitBranch
    HeadBefore = $headBefore
    HeadAfter = $headAfter
    ApprovedPathspecs = $approvedPathspecs
    ApprovedDirtyBeforeCount = @($approvedDirtyBefore).Count
    OutsideDirtyBeforeCount = @($outsideDirtyBefore).Count
    StagedFileCount = @($stagedFiles).Count
    SaveCommitPacket = $SaveCommitPacket
    ApprovedPathspecsFile = $ApprovedPathspecsFile
    GitStatusBeforeFile = $GitStatusBeforeFile
    GitStatusAfterFile = $GitStatusAfterFile
    StagedFilesFile = $StagedFilesFile
    CommitOutputFile = $CommitOutputFile
    PendingCard = $PendingCard
    NextObjectCard = $NextObjectCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
    CleanupHere = $false
    DoctrinePromotedHere = $false
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentSaveCommitStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE SAVE AND COMMIT STATUS"
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
$statusLines += ("WorkEntryStatus: " + $workEntryStatus)
$statusLines += ("OpenSideQuestRequired: " + $openSideQuestRequired)
$statusLines += ("InstalledStatus: " + $InstalledStatusMd)
$statusLines += ("CloseoutStatus: " + $closeoutStatus)
$statusLines += ("ManifestTargetFileCount: " + $manifestTargetFileCount)
$statusLines += ("ActualTargetFileCount: " + $actualTargetFileCount)
$statusLines += ("VerifiedTargetCount: " + $verifiedTargetCount)
$statusLines += ("GitBranch: " + $gitBranch)
$statusLines += ("HeadBefore: " + $headBefore)
$statusLines += ("HeadAfter: " + $headAfter)
$statusLines += ("ApprovedDirtyBeforeCount: " + @($approvedDirtyBefore).Count)
$statusLines += ("OutsideDirtyBeforeCount: " + @($outsideDirtyBefore).Count)
$statusLines += ("StagedFileCount: " + @($stagedFiles).Count)
$statusLines += ("ErrorCount: " + @($errors).Count)
$statusLines += ""
$statusLines += "# Files"
$statusLines += ""
$statusLines += ("SaveCommitPacket: " + $SaveCommitPacket)
$statusLines += ("ApprovedPathspecsFile: " + $ApprovedPathspecsFile)
$statusLines += ("GitStatusBeforeFile: " + $GitStatusBeforeFile)
$statusLines += ("GitStatusAfterFile: " + $GitStatusAfterFile)
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
$receiptLines += "## COMMAND CENTER UI LANE SAVE AND COMMIT GATE V1"
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
Write-Host "Command Center UI lane save and commit gate complete."
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
Write-Host "HeadBefore:"
Write-Host $headBefore
Write-Host ""
Write-Host "HeadAfter:"
Write-Host $headAfter
Write-Host ""
Write-Host "ApprovedDirtyBeforeCount:"
Write-Host @($approvedDirtyBefore).Count
Write-Host ""
Write-Host "OutsideDirtyBeforeCount:"
Write-Host @($outsideDirtyBefore).Count
Write-Host ""
Write-Host "StagedFileCount:"
Write-Host @($stagedFiles).Count
Write-Host ""
Write-Host "Current save/commit status:"
Write-Host $CurrentSaveCommitStatusMd
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_FINALIZED"

