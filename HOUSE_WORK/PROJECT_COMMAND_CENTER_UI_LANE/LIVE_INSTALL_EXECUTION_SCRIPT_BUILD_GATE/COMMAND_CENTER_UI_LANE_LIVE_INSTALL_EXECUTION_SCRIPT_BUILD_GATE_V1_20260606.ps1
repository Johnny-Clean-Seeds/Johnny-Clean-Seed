<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1_20260606.ps1

PURPOSE:
Build the live-install execution script from the locked final authorization and execution plan.

THIS IS NOT LIVE INSTALL.
THIS DOES NOT RUN THE EXECUTION SCRIPT.
THIS DOES NOT COPY FILES.
THIS DOES NOT CREATE THE TARGET FOLDER.

STATUS:
LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE / BUILD_SCRIPT_ONLY / NO_LIVE_INSTALL / NO_DOCTRINE_PROMOTION

NEXT LEGAL OBJECT IF READY:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [switch]$NoEntryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DateTag = "20260606"
$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

$CommandCenterRoot = Join-Path $Root "COMMAND_CENTER"
$WorkEntryRoot = Join-Path $CommandCenterRoot "WORK_ENTRYPOINT"
$UiLaneRoot = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$FinalAuthRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE"
$ScriptBuildRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE"
$RunRoot = Join-Path $ScriptBuildRoot ("COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$FinalAuthStatusMd = Join-Path $FinalAuthRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_STATUS.md"
$CurrentBuildStatusMd = Join-Path $ScriptBuildRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_STATUS.md"
$CurrentBuildStatusJson = Join-Path $ScriptBuildRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_STATUS.json"

$BuiltScript = Join-Path $ScriptBuildRoot "EXECUTE_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_V1_20260606.ps1"
$BuildPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_PACKET_V1_20260606.md"
$SyntaxReport = Join-Path $RunRoot "SYNTAX_REPORT__LIVE_INSTALL_EXECUTION_SCRIPT_V1_20260606.md"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_EXECUTION_SCRIPT_BUILD_GATE.txt"

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

function Add-BuildError {
    param([string]$Category, [string]$Phase, [string]$Message, [string]$Resolution = "")

    $script:errors += [pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
    }
}

function Test-PowerShellSyntax {
    param([string]$Path)

    $tokens = $null
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$parseErrors) | Out-Null

    return [pscustomobject]@{
        ErrorCount = @($parseErrors).Count
        Errors = $parseErrors
    }
}

New-Dir $ScriptBuildRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"
$authorizationStatus = "UNKNOWN"
$authorizationAccepted = "UNKNOWN"
$finalAuthNextObject = "UNKNOWN"
$lockedTerms = "UNKNOWN"
$copyPlanManifestJson = "UNKNOWN"
$planStatus = "UNKNOWN"
$copyPlanFileCount = "UNKNOWN"
$buildStatus = "LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_BLOCKED"
$nextLegalObject = "FIX_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_BLOCKERS"
$syntaxErrorCount = "UNKNOWN"
$scriptHash = "UNKNOWN"

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-BuildError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Work entrypoint required before script build."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_EXECUTION_SCRIPT_BUILD_GATE: " + $WorkEntryScript)
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-BuildError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"
        $actions += ("READ_WORK_ENTRY_STATUS: " + $WorkEntryStatusMd)

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-BuildError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Resolve work entry/pre-run block first."
        }

        if ($openSideQuestRequired -ne "False") {
            Add-BuildError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error-triggered helper harvest first."
        }
    }

    if (-not (Test-Path -LiteralPath $FinalAuthStatusMd)) {
        Add-BuildError -Category "FINAL_AUTH_STATUS_MISSING" -Phase "READ_FINAL_AUTH" -Message $FinalAuthStatusMd -Resolution "Run final authorization gate before script build."
    }
    else {
        $authText = Get-Content -LiteralPath $FinalAuthStatusMd -Raw -ErrorAction Stop
        $authorizationStatus = Get-InlineValue -Text $authText -Name "AuthorizationStatus"
        $authorizationAccepted = Get-InlineValue -Text $authText -Name "AuthorizationAccepted"
        $finalAuthNextObject = Get-InlineValue -Text $authText -Name "NextLegalObject"
        $lockedTerms = Get-InlineValue -Text $authText -Name "LockedTerms"
        $actions += ("READ_FINAL_AUTH_STATUS: " + $FinalAuthStatusMd)

        if ($authorizationStatus -ne "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_LOCKED_FOR_EXECUTION_SCRIPT_BUILD") {
            Add-BuildError -Category "FINAL_AUTH_NOT_LOCKED_FOR_SCRIPT_BUILD" -Phase "READ_FINAL_AUTH" -Message ("AuthorizationStatus=" + $authorizationStatus) -Resolution "Run final authorization with exact phrase."
        }

        if ($authorizationAccepted -ne "true") {
            Add-BuildError -Category "FINAL_AUTH_NOT_ACCEPTED" -Phase "READ_FINAL_AUTH" -Message ("AuthorizationAccepted=" + $authorizationAccepted) -Resolution "Script build not allowed."
        }

        if ($finalAuthNextObject -ne "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1") {
            Add-BuildError -Category "FINAL_AUTH_NEXT_OBJECT_UNEXPECTED" -Phase "READ_FINAL_AUTH" -Message ("NextLegalObject=" + $finalAuthNextObject) -Resolution "Review final authorization status."
        }

        if ($lockedTerms -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $lockedTerms)) {
            Add-BuildError -Category "LOCKED_TERMS_MISSING" -Phase "READ_FINAL_AUTH" -Message ("LockedTerms=" + $lockedTerms) -Resolution "Regenerate final authorization locked terms."
        }
    }

    if ($lockedTerms -ne "UNKNOWN" -and (Test-Path -LiteralPath $lockedTerms)) {
        $lockedText = Get-Content -LiteralPath $lockedTerms -Raw -ErrorAction Stop
        $planStatus = Get-InlineValue -Text $lockedText -Name "PlanStatus"
        $copyPlanManifestJson = Get-InlineValue -Text $lockedText -Name "CopyPlanManifestJson"
        $copyPlanFileCount = Get-InlineValue -Text $lockedText -Name "CopyPlanFileCount"
        $actions += ("READ_LOCKED_TERMS: " + $lockedTerms)

        if ($planStatus -ne "LIVE_INSTALL_EXECUTION_PLAN_READY_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION_GATE") {
            Add-BuildError -Category "LOCKED_PLAN_NOT_READY" -Phase "READ_LOCKED_TERMS" -Message ("PlanStatus=" + $planStatus) -Resolution "Regenerate plan/final auth."
        }

        if ($copyPlanManifestJson -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $copyPlanManifestJson)) {
            Add-BuildError -Category "COPY_PLAN_MANIFEST_JSON_MISSING" -Phase "READ_LOCKED_TERMS" -Message ("CopyPlanManifestJson=" + $copyPlanManifestJson) -Resolution "Regenerate execution plan."
        }
    }

    if (@($errors).Count -eq 0) {
        @'
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

'@ | Set-Content -LiteralPath $BuiltScript -Encoding UTF8
        $actions += ("WROTE_EXECUTION_SCRIPT: " + $BuiltScript)

        $syntax = Test-PowerShellSyntax -Path $BuiltScript
        $syntaxErrorCount = [string]$syntax.ErrorCount

        $syntaxLines = @()
        $syntaxLines += "# SYNTAX REPORT"
        $syntaxLines += "## LIVE INSTALL EXECUTION SCRIPT V1"
        $syntaxLines += ""
        $syntaxLines += ("GeneratedUtc: " + (Get-UtcNow))
        $syntaxLines += ("BuiltScript: " + $BuiltScript)
        $syntaxLines += ("SyntaxErrorCount: " + $syntax.ErrorCount)
        $syntaxLines += ""
        foreach ($pe in $syntax.Errors) {
            $syntaxLines += ("- " + $pe.Message)
        }
        $syntaxLines | Set-Content -LiteralPath $SyntaxReport -Encoding UTF8

        if ($syntax.ErrorCount -gt 0) {
            Add-BuildError -Category "BUILT_SCRIPT_SYNTAX_ERROR" -Phase "SYNTAX_CHECK" -Message ("SyntaxErrorCount=" + $syntax.ErrorCount) -Resolution "Repair built execution script before run authorization."
        }
        else {
            $scriptHash = (Get-FileHash -LiteralPath $BuiltScript -Algorithm SHA256).Hash
            $buildStatus = "LIVE_INSTALL_EXECUTION_SCRIPT_BUILT_READY_FOR_RUN_AUTHORIZATION_GATE"
            $nextLegalObject = "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1"
        }
    }
}
catch {
    Add-BuildError -Category "EXECUTION_SCRIPT_BUILD_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review build gate error ledger."
}

if (@($errors).Count -gt 0) {
    $buildStatus = "LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_BLOCKED"
    $nextLegalObject = "FIX_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_BLOCKERS"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE LIVE INSTALL EXECUTION SCRIPT BUILD GATE V1"
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

$packetLines = @()
$packetLines += "# COMMAND CENTER UI LANE LIVE INSTALL EXECUTION SCRIPT BUILD PACKET"
$packetLines += "## V1"
$packetLines += ""
$packetLines += ("GeneratedUtc: " + (Get-UtcNow))
$packetLines += ("RunStamp: " + $RunStamp)
$packetLines += ("BuildStatus: " + $buildStatus)
$packetLines += ("NextLegalObject: " + $nextLegalObject)
$packetLines += ("BuiltScript: " + $BuiltScript)
$packetLines += ("BuiltScriptSHA256: " + $scriptHash)
$packetLines += ("SyntaxReport: " + $SyntaxReport)
$packetLines += ("SyntaxErrorCount: " + $syntaxErrorCount)
$packetLines += ("CopyPlanManifestJson: " + $copyPlanManifestJson)
$packetLines += ("CopyPlanFileCount: " + $copyPlanFileCount)
$packetLines += ("ErrorCount: " + @($errors).Count)
$packetLines += ""
$packetLines += "# Boundary"
$packetLines += ""
$packetLines += "LiveInstallExecutionRunAuthorized: false"
$packetLines += "CopiedFilesToTarget: false"
$packetLines += "CreatedTargetFolder: false"
$packetLines += "DoctrinePromotionAuthorized: false"
$packetLines | Set-Content -LiteralPath $BuildPacket -Encoding UTF8

$nextLines = @()
$nextLines += "# NEXT OBJECT CARD"
$nextLines += "## COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1"
$nextLines += ""
$nextLines += ("GeneratedUtc: " + (Get-UtcNow))
$nextLines += ("BuildStatus: " + $buildStatus)
$nextLines += ("BuiltScript: " + $BuiltScript)
$nextLines += ("BuiltScriptSHA256: " + $scriptHash)
$nextLines += ""
$nextLines += "# Purpose"
$nextLines += ""
$nextLines += "Ask for final explicit authorization to run the built live-install execution script."
$nextLines += ""
$nextLines += "# Still Not Authorized Here"
$nextLines += ""
$nextLines += "LiveInstallExecutionRunAuthorized: false"
$nextLines += "This card does not run install."
$nextLines | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    BuildStatus = $buildStatus
    NextLegalObject = $nextLegalObject
    BuiltScript = $BuiltScript
    BuiltScriptSHA256 = $scriptHash
    SyntaxReport = $SyntaxReport
    SyntaxErrorCount = $syntaxErrorCount
    CopyPlanManifestJson = $copyPlanManifestJson
    CopyPlanFileCount = $copyPlanFileCount
    BuildPacket = $BuildPacket
    NextObjectCard = $NextObjectCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
    LiveInstallExecutionRunAuthorized = $false
    DoctrinePromotionAuthorized = $false
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentBuildStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE LIVE INSTALL EXECUTION SCRIPT BUILD STATUS"
$statusLines += ""
$statusLines += ("GeneratedUtc: " + $statusObj.GeneratedUtc)
$statusLines += ("RunStamp: " + $RunStamp)
$statusLines += ("BuildStatus: " + $buildStatus)
$statusLines += ("NextLegalObject: " + $nextLegalObject)
$statusLines += ("BuiltScript: " + $BuiltScript)
$statusLines += ("BuiltScriptSHA256: " + $scriptHash)
$statusLines += ("SyntaxReport: " + $SyntaxReport)
$statusLines += ("SyntaxErrorCount: " + $syntaxErrorCount)
$statusLines += ("CopyPlanManifestJson: " + $copyPlanManifestJson)
$statusLines += ("CopyPlanFileCount: " + $copyPlanFileCount)
$statusLines += ("BuildPacket: " + $BuildPacket)
$statusLines += ("NextObjectCard: " + $NextObjectCard)
$statusLines += ("Receipt: " + $Receipt)
$statusLines += ("ErrorLedger: " + $ErrorLedger)
$statusLines += ("ErrorCount: " + @($errors).Count)
$statusLines += ""
$statusLines += "# Authorization Flags"
$statusLines += ""
$statusLines += "LiveInstallExecutionRunAuthorized: false"
$statusLines += "CopiedFilesToTarget: false"
$statusLines += "CreatedTargetFolder: false"
$statusLines += "DoctrinePromotionAuthorized: false"
$statusLines += "CommitAuthorized: false"
$statusLines += "PushAuthorized: false"
$statusLines += "WatcherAuthorized: false"
$statusLines += "AutomationAuthorized: false"
$statusLines | Set-Content -LiteralPath $CurrentBuildStatusMd -Encoding UTF8

$receiptLines = @()
$receiptLines += "# RECEIPT"
$receiptLines += "## COMMAND CENTER UI LANE LIVE INSTALL EXECUTION SCRIPT BUILD GATE V1"
$receiptLines += ""
$receiptLines += ("Date: " + $DateTag)
$receiptLines += ("GeneratedUtc: " + (Get-UtcNow))
$receiptLines += ("RunStamp: " + $RunStamp)
$receiptLines += ("BuildStatus: " + $buildStatus)
$receiptLines += ("NextLegalObject: " + $nextLegalObject)
$receiptLines += ("BuiltScript: " + $BuiltScript)
$receiptLines += ("BuiltScriptSHA256: " + $scriptHash)
$receiptLines += ("SyntaxReport: " + $SyntaxReport)
$receiptLines += ("BuildPacket: " + $BuildPacket)
$receiptLines += ("CurrentBuildStatus: " + $CurrentBuildStatusMd)
$receiptLines += ("CurrentBuildStatusJson: " + $CurrentBuildStatusJson)
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
$receiptLines += "RanBuiltExecutionScript: false"
$receiptLines += "CopiedFilesToTarget: false"
$receiptLines += "CreatedTargetFolder: false"
$receiptLines += "LiveInstallExecutionRunAuthorized: false"
$receiptLines += "DoctrinePromoted: false"
$receiptLines += "DeletedProjectWork: false"
$receiptLines += "ArchivedProjectWork: false"
$receiptLines += "DedupedProjectWork: false"
$receiptLines += "Committed: false"
$receiptLines += "Pushed: false"
$receiptLines += "WatcherInstalled: false"
$receiptLines += "AutomationInstalled: false"
$receiptLines += ""
$receiptLines += "# DoesNotProve"
$receiptLines += ""
$receiptLines += "This receipt does not run live install."
$receiptLines += "This receipt does not promote doctrine."
$receiptLines += "This receipt does not authorize cleanup."
$receiptLines | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host ""
Write-Host "Command Center UI lane live-install execution script build gate complete."
Write-Host "BuildStatus:"
Write-Host $buildStatus
Write-Host ""
Write-Host "NextLegalObject:"
Write-Host $nextLegalObject
Write-Host ""
Write-Host "BuiltScript:"
Write-Host $BuiltScript
Write-Host ""
Write-Host "BuiltScriptSHA256:"
Write-Host $scriptHash
Write-Host ""
Write-Host "SyntaxErrorCount:"
Write-Host $syntaxErrorCount
Write-Host ""
Write-Host "Current build status:"
Write-Host $CurrentBuildStatusMd
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_FINALIZED"


