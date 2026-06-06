<#
SCRIPT NAME:
EXECUTE_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_V1_20260606.ps1

PURPOSE:
Execute the Command Center UI lane live install only if final run authorization is present.

THIS SCRIPT CAN COPY FILES ONLY WHEN ALL EXECUTION FLAGS AND GATES PASS.

DEFAULT MODE:
Dry-run only.

REQUIRED TO EXECUTE:
- -ExecuteInstall
- exact run authorization phrase from the run authorization gate
- current run authorization status accepted
- current work entry clear
- copy plan hashes still match
- target state still matches assumptions

THIS SCRIPT DOES NOT:
- promote doctrine
- install watcher
- install automation
- commit
- push
- cleanup/delete/archive/dedupe outside rollback rules
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [switch]$ExecuteInstall,

    [Parameter(Mandatory = $false)]
    [string]$RunAuthorizationPhrase = "",

    [Parameter(Mandatory = $false)]
    [string]$AuthorizedBy = "UNSPECIFIED"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$RequiredRunPhrase = "I AUTHORIZE RUNNING THE COMMAND CENTER UI LANE LIVE INSTALL NOW"

$CommandCenterRoot = Join-Path $Root "COMMAND_CENTER"
$WorkEntryRoot = Join-Path $CommandCenterRoot "WORK_ENTRYPOINT"
$UiLaneRoot = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$PlanGateRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_EXECUTION_PLAN_GATE"
$RunAuthRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_RUN_AUTHORIZATION_GATE"
$ExecutionRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_EXECUTION"
$RunRoot = Join-Path $ExecutionRoot ("COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_V1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$PlanStatusMd = Join-Path $PlanGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_STATUS.md"
$RunAuthStatusMd = Join-Path $RunAuthRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_STATUS.md"

$DryRunReport = Join-Path $RunRoot "DRY_RUN_REPORT__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_V1_20260606.md"
$ExecutionReceipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_V1_20260606.md"
$AfterHashLedger = Join-Path $RunRoot "HASH_LEDGER_TARGET_AFTER__COMMAND_CENTER_UI_LANE_V1_20260606.md"

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

function Add-ExecError {
    param([string]$Category, [string]$Phase, [string]$Message, [string]$Resolution = "")

    $script:errors += [pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
    }
}

New-Dir $ExecutionRoot
New-Dir $RunRoot

$errors = @()
$actions = @()
$executionStatus = "LIVE_INSTALL_EXECUTION_DRY_RUN_ONLY"
$copiedCount = 0
$verifiedCount = 0

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"
$planStatus = "UNKNOWN"
$copyPlanManifestJson = "UNKNOWN"
$proposedTargetRoot = "UNKNOWN"
$targetExistsBefore = "UNKNOWN"
$runAuthorizationStatus = "UNKNOWN"
$runAuthorizationAccepted = "UNKNOWN"

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-ExecError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Work entrypoint is required."
    }
    else {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION" -SelectedLane "COMMAND_CENTER_UI_LANE" | Out-Null
        $actions += ("RAN_WORK_ENTRYPOINT: " + $WorkEntryScript)
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-ExecError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-ExecError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Stop execution."
        }
        if ($openSideQuestRequired -ne "False") {
            Add-ExecError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error harvest."
        }
    }

    if (-not (Test-Path -LiteralPath $PlanStatusMd)) {
        Add-ExecError -Category "EXECUTION_PLAN_STATUS_MISSING" -Phase "READ_PLAN" -Message $PlanStatusMd -Resolution "Run execution plan gate."
    }
    else {
        $planText = Get-Content -LiteralPath $PlanStatusMd -Raw -ErrorAction Stop
        $planStatus = Get-InlineValue -Text $planText -Name "PlanStatus"
        $copyPlanManifestJson = Get-InlineValue -Text $planText -Name "CopyPlanManifestJson"
        $proposedTargetRoot = Get-InlineValue -Text $planText -Name "ProposedTargetRoot"
        $targetExistsBefore = Get-InlineValue -Text $planText -Name "TargetExistsBefore"

        if ($planStatus -ne "LIVE_INSTALL_EXECUTION_PLAN_READY_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION_GATE") {
            Add-ExecError -Category "EXECUTION_PLAN_NOT_READY" -Phase "READ_PLAN" -Message ("PlanStatus=" + $planStatus) -Resolution "Stop execution."
        }
        if ($copyPlanManifestJson -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $copyPlanManifestJson)) {
            Add-ExecError -Category "COPY_PLAN_MANIFEST_JSON_MISSING" -Phase "READ_PLAN" -Message $copyPlanManifestJson -Resolution "Regenerate execution plan."
        }
    }

    if (-not (Test-Path -LiteralPath $RunAuthStatusMd)) {
        Add-ExecError -Category "RUN_AUTHORIZATION_STATUS_MISSING" -Phase "READ_RUN_AUTHORIZATION" -Message $RunAuthStatusMd -Resolution "Run final run authorization gate before execution."
    }
    else {
        $runAuthText = Get-Content -LiteralPath $RunAuthStatusMd -Raw -ErrorAction Stop
        $runAuthorizationStatus = Get-InlineValue -Text $runAuthText -Name "AuthorizationStatus"
        $runAuthorizationAccepted = Get-InlineValue -Text $runAuthText -Name "AuthorizationAccepted"

        if ($runAuthorizationStatus -ne "LIVE_INSTALL_RUN_AUTHORIZATION_LOCKED_FOR_EXECUTION_RUN") {
            Add-ExecError -Category "RUN_AUTHORIZATION_NOT_LOCKED" -Phase "READ_RUN_AUTHORIZATION" -Message ("AuthorizationStatus=" + $runAuthorizationStatus) -Resolution "Stop execution."
        }
        if ($runAuthorizationAccepted -ne "true") {
            Add-ExecError -Category "RUN_AUTHORIZATION_NOT_ACCEPTED" -Phase "READ_RUN_AUTHORIZATION" -Message ("AuthorizationAccepted=" + $runAuthorizationAccepted) -Resolution "Stop execution."
        }
    }

    if ($ExecuteInstall) {
        if ($RunAuthorizationPhrase -ne $RequiredRunPhrase) {
            Add-ExecError -Category "RUN_AUTHORIZATION_PHRASE_MISMATCH" -Phase "EXECUTION_AUTHORIZATION" -Message "ExecuteInstall supplied without exact run phrase." -Resolution ("Use exact phrase: " + $RequiredRunPhrase)
        }
    }
    else {
        $actions += "NO_EXECUTE_FLAG_DRY_RUN_ONLY"
    }

    $rows = @()
    if ($copyPlanManifestJson -ne "UNKNOWN" -and (Test-Path -LiteralPath $copyPlanManifestJson)) {
        $rows = @(Get-Content -LiteralPath $copyPlanManifestJson -Raw -ErrorAction Stop | ConvertFrom-Json)
        foreach ($row in $rows) {
            $sourcePath = [string]$row.SourcePath
            $targetPath = [string]$row.ProposedTargetPath
            $expectedHash = [string]$row.ExpectedSHA256
            $rel = [string]$row.RelativePath

            if (-not (Test-Path -LiteralPath $sourcePath)) {
                Add-ExecError -Category "SOURCE_FILE_MISSING" -Phase "VERIFY_SOURCE" -Message $sourcePath -Resolution "Stop execution."
                continue
            }

            $currentHash = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash
            if ($currentHash -ne $expectedHash) {
                Add-ExecError -Category "SOURCE_HASH_MISMATCH" -Phase "VERIFY_SOURCE" -Message ("RelativePath=" + $rel) -Resolution "Stop execution and rerun plan."
            }

            if (-not (Test-PathInsideRoot -PathToCheck $targetPath -RootPath $proposedTargetRoot)) {
                Add-ExecError -Category "TARGET_PATH_OUTSIDE_ROOT" -Phase "VERIFY_TARGET" -Message $targetPath -Resolution "Stop execution."
            }

            if ($targetExistsBefore -eq "false" -and (Test-Path -LiteralPath $targetPath)) {
                Add-ExecError -Category "TARGET_FILE_UNEXPECTEDLY_EXISTS" -Phase "VERIFY_TARGET" -Message $targetPath -Resolution "Stop execution and rerun prep/plan."
            }
        }
    }

    if ($ExecuteInstall -and @($errors).Count -eq 0) {
        if ($targetExistsBefore -eq "false" -and (Test-Path -LiteralPath $proposedTargetRoot)) {
            Add-ExecError -Category "TARGET_ROOT_UNEXPECTEDLY_EXISTS" -Phase "PRE_COPY_TARGET_CHECK" -Message $proposedTargetRoot -Resolution "Stop execution and rerun prep."
        }
    }

    if ($ExecuteInstall -and @($errors).Count -eq 0) {
        New-Dir $proposedTargetRoot
        $actions += ("CREATED_TARGET_ROOT: " + $proposedTargetRoot)

        foreach ($row in $rows) {
            $sourcePath = [string]$row.SourcePath
            $targetPath = [string]$row.ProposedTargetPath
            $targetParent = Split-Path -Parent $targetPath
            New-Dir $targetParent
            Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
            $copiedCount += 1
        }

        foreach ($row in $rows) {
            $targetPath = [string]$row.ProposedTargetPath
            $expectedHash = [string]$row.ExpectedSHA256
            if (-not (Test-Path -LiteralPath $targetPath)) {
                Add-ExecError -Category "TARGET_FILE_MISSING_AFTER_COPY" -Phase "VERIFY_AFTER_COPY" -Message $targetPath -Resolution "Rollback required."
            }
            else {
                $actualHash = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash
                if ($actualHash -ne $expectedHash) {
                    Add-ExecError -Category "TARGET_HASH_MISMATCH_AFTER_COPY" -Phase "VERIFY_AFTER_COPY" -Message $targetPath -Resolution "Rollback required."
                }
                else {
                    $verifiedCount += 1
                }
            }
        }

        if (@($errors).Count -eq 0) {
            $executionStatus = "LIVE_INSTALL_EXECUTION_COMPLETE"
        }
        else {
            $executionStatus = "LIVE_INSTALL_EXECUTION_COMPLETED_WITH_VERIFY_ERRORS"
        }
    }
}
catch {
    Add-ExecError -Category "LIVE_INSTALL_EXECUTION_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review error ledger."
    if ($ExecuteInstall) {
        $executionStatus = "LIVE_INSTALL_EXECUTION_EXCEPTION"
    }
}

if (-not $ExecuteInstall) {
    if (@($errors).Count -eq 0) {
        $executionStatus = "LIVE_INSTALL_DRY_RUN_READY_BUT_NOT_EXECUTED"
    }
    else {
        $executionStatus = "LIVE_INSTALL_DRY_RUN_BLOCKED"
    }
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE LIVE INSTALL EXECUTION V1"
$errorLines += ""
$errorLines += ("GeneratedUtc: " + (Get-UtcNow))
$errorLines += ("ErrorCount: " + @($errors).Count)
$errorLines += ""
$errorLines += "| Category | Phase | Message | Resolution |"
$errorLines += "|---|---|---|---|"
foreach ($e in $errors) {
    $errorLines += ("| " + (Escape-Md $e.Category) + " | " + (Escape-Md $e.Phase) + " | " + (Escape-Md $e.Message) + " | " + (Escape-Md $e.Resolution) + " |")
}
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

if (Test-Path -LiteralPath $proposedTargetRoot) {
    $hashLines = @()
    $hashLines += "# TARGET AFTER HASH LEDGER"
    $hashLines += ("GeneratedUtc: " + (Get-UtcNow))
    $hashLines += ("TargetRoot: " + $proposedTargetRoot)
    $hashLines += ""
    $hashLines += "| RelativePath | SizeBytes | SHA256 | FullPath |"
    $hashLines += "|---|---:|---|---|"
    $files = Get-ChildItem -LiteralPath $proposedTargetRoot -File -Recurse -Force -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        $rel = $f.FullName.Substring(([System.IO.Path]::GetFullPath($proposedTargetRoot)).TrimEnd("\").Length).TrimStart("\")
        $h = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash
        $hashLines += ("| " + (Escape-Md $rel) + " | " + $f.Length + " | " + $h + " | " + (Escape-Md $f.FullName) + " |")
    }
    $hashLines | Set-Content -LiteralPath $AfterHashLedger -Encoding UTF8
}

$reportPath = if ($ExecuteInstall) { $ExecutionReceipt } else { $DryRunReport }

$reportLines = @()
$reportLines += "# COMMAND CENTER UI LANE LIVE INSTALL EXECUTION REPORT"
$reportLines += ""
$reportLines += ("GeneratedUtc: " + (Get-UtcNow))
$reportLines += ("RunStamp: " + $RunStamp)
$reportLines += ("ExecutionStatus: " + $executionStatus)
$reportLines += ("ExecuteInstall: " + $ExecuteInstall)
$reportLines += ("AuthorizedBy: " + $AuthorizedBy)
$reportLines += ("CopiedCount: " + $copiedCount)
$reportLines += ("VerifiedCount: " + $verifiedCount)
$reportLines += ("ErrorCount: " + @($errors).Count)
$reportLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$reportLines += ("CopyPlanManifestJson: " + $copyPlanManifestJson)
$reportLines += ("AfterHashLedger: " + $AfterHashLedger)
$reportLines += ("ErrorLedger: " + $ErrorLedger)
$reportLines += ""
$reportLines += "# Boundary"
$reportLines += ""
$reportLines += "DoctrinePromoted: false"
$reportLines += "WatcherInstalled: false"
$reportLines += "AutomationInstalled: false"
$reportLines += "Committed: false"
$reportLines += "Pushed: false"
$reportLines | Set-Content -LiteralPath $reportPath -Encoding UTF8

Write-Host ""
Write-Host "Command Center UI lane live-install execution script complete."
Write-Host "ExecutionStatus:"
Write-Host $executionStatus
Write-Host ""
Write-Host "ExecuteInstall:"
Write-Host $ExecuteInstall
Write-Host ""
Write-Host "CopiedCount:"
Write-Host $copiedCount
Write-Host ""
Write-Host "VerifiedCount:"
Write-Host $verifiedCount
Write-Host ""
Write-Host "Report:"
Write-Host $reportPath
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_FINALIZED"

