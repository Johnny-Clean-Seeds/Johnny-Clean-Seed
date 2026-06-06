<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1_20260606.ps1

PURPOSE:
Ask for and record explicit final human authorization to build the live-install execution script.

THIS IS STILL NOT LIVE INSTALL.
THIS DOES NOT COPY FILES.
THIS DOES NOT CREATE THE TARGET FOLDER.
THIS DOES NOT EXECUTE INSTALL.

REQUIRED AUTHORIZATION PHRASE:
I AUTHORIZE BUILDING THE COMMAND CENTER UI LANE LIVE INSTALL EXECUTION SCRIPT

LEGAL OUTCOMES:
- LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_PENDING
- LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_LOCKED_FOR_EXECUTION_SCRIPT_BUILD
- LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_REJECTED_PHRASE_MISMATCH
- LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_BLOCKED_BY_GATE_ERRORS

NEXT LEGAL OBJECT IF LOCKED:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [switch]$AuthorizeBuildExecutionScript,

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
$RequiredPhrase = "I AUTHORIZE BUILDING THE COMMAND CENTER UI LANE LIVE INSTALL EXECUTION SCRIPT"

$CommandCenterRoot = Join-Path $Root "COMMAND_CENTER"
$WorkEntryRoot = Join-Path $CommandCenterRoot "WORK_ENTRYPOINT"
$UiLaneRoot = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$PlanGateRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_EXECUTION_PLAN_GATE"
$FinalAuthRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE"
$RunRoot = Join-Path $FinalAuthRoot ("COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$PlanStatusMd = Join-Path $PlanGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_STATUS.md"
$PlanStatusJson = Join-Path $PlanGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_STATUS.json"

$CurrentFinalAuthStatusMd = Join-Path $FinalAuthRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_STATUS.md"
$CurrentFinalAuthStatusJson = Join-Path $FinalAuthRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_STATUS.json"

$AuthorizationPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_PACKET_V1_20260606.md"
$LockedTerms = Join-Path $RunRoot "LOCKED_TERMS__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_V1_20260606.md"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1_20260606.md"
$PendingCard = Join-Path $RunRoot "PENDING_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_V1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_FINAL_EXECUTION_AUTHORIZATION_GATE.txt"

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

function Add-FinalAuthError {
    param([string]$Category, [string]$Phase, [string]$Message, [string]$Resolution = "")

    $script:errors += [pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
    }
}

New-Dir $FinalAuthRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"
$planStatus = "UNKNOWN"
$planNextLegalObject = "UNKNOWN"
$copyPlanFileCount = "UNKNOWN"
$sourceMismatchCount = "UNKNOWN"
$targetUnexpectedExistsCount = "UNKNOWN"
$targetPathOutsideCount = "UNKNOWN"
$planErrorCount = "UNKNOWN"
$executionPlanPacket = "UNKNOWN"
$copyPlanManifest = "UNKNOWN"
$copyPlanManifestJson = "UNKNOWN"
$executionSteps = "UNKNOWN"
$verificationPlan = "UNKNOWN"
$rollbackExecutionPlan = "UNKNOWN"
$stopConditions = "UNKNOWN"
$proposedSourceRoot = "UNKNOWN"
$proposedTargetRoot = "UNKNOWN"
$targetExistsBefore = "UNKNOWN"
$collisionCount = "UNKNOWN"

$authorizationStatus = "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_PENDING"
$authorizationAccepted = "false"
$nextLegalObject = "WAIT_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION"

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-FinalAuthError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Write/install Command Center work entrypoint before final authorization gate."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_FINAL_EXECUTION_AUTHORIZATION_GATE: " + $WorkEntryScript)
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-FinalAuthError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint before final authorization gate."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"
        $actions += ("READ_WORK_ENTRY_STATUS: " + $WorkEntryStatusMd)

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-FinalAuthError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Resolve work entry/pre-run block first."
        }

        if ($openSideQuestRequired -ne "False") {
            Add-FinalAuthError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error-triggered helper harvest first."
        }
    }

    if (-not (Test-Path -LiteralPath $PlanStatusMd)) {
        Add-FinalAuthError -Category "EXECUTION_PLAN_STATUS_MISSING" -Phase "READ_EXECUTION_PLAN" -Message $PlanStatusMd -Resolution "Run execution plan gate before final authorization."
    }
    else {
        $planText = Get-Content -LiteralPath $PlanStatusMd -Raw -ErrorAction Stop
        $planStatus = Get-InlineValue -Text $planText -Name "PlanStatus"
        $planNextLegalObject = Get-InlineValue -Text $planText -Name "NextLegalObject"
        $copyPlanFileCount = Get-InlineValue -Text $planText -Name "CopyPlanFileCount"
        $sourceMismatchCount = Get-InlineValue -Text $planText -Name "SourceMismatchCount"
        $targetUnexpectedExistsCount = Get-InlineValue -Text $planText -Name "TargetUnexpectedExistsCount"
        $targetPathOutsideCount = Get-InlineValue -Text $planText -Name "TargetPathOutsideCount"
        $planErrorCount = Get-InlineValue -Text $planText -Name "ErrorCount"
        $executionPlanPacket = Get-InlineValue -Text $planText -Name "ExecutionPlanPacket"
        $copyPlanManifest = Get-InlineValue -Text $planText -Name "CopyPlanManifest"
        $copyPlanManifestJson = Get-InlineValue -Text $planText -Name "CopyPlanManifestJson"
        $executionSteps = Get-InlineValue -Text $planText -Name "ExecutionSteps"
        $verificationPlan = Get-InlineValue -Text $planText -Name "VerificationPlan"
        $rollbackExecutionPlan = Get-InlineValue -Text $planText -Name "RollbackExecutionPlan"
        $stopConditions = Get-InlineValue -Text $planText -Name "StopConditions"
        $proposedSourceRoot = Get-InlineValue -Text $planText -Name "ProposedSourceRoot"
        $proposedTargetRoot = Get-InlineValue -Text $planText -Name "ProposedTargetRoot"
        $targetExistsBefore = Get-InlineValue -Text $planText -Name "TargetExistsBefore"
        $collisionCount = Get-InlineValue -Text $planText -Name "CollisionCount"
        $actions += ("READ_EXECUTION_PLAN_STATUS: " + $PlanStatusMd)

        if ($planStatus -ne "LIVE_INSTALL_EXECUTION_PLAN_READY_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION_GATE") {
            Add-FinalAuthError -Category "EXECUTION_PLAN_NOT_READY" -Phase "READ_EXECUTION_PLAN" -Message ("PlanStatus=" + $planStatus) -Resolution "Fix execution plan blockers before final authorization."
        }

        if ($planNextLegalObject -ne "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1") {
            Add-FinalAuthError -Category "PLAN_NEXT_OBJECT_UNEXPECTED" -Phase "READ_EXECUTION_PLAN" -Message ("NextLegalObject=" + $planNextLegalObject) -Resolution "Review execution plan next object."
        }

        if ($planErrorCount -ne "0") {
            Add-FinalAuthError -Category "PLAN_ERROR_COUNT_NOT_ZERO" -Phase "READ_EXECUTION_PLAN" -Message ("ErrorCount=" + $planErrorCount) -Resolution "Fix execution plan errors before final authorization."
        }

        if ($sourceMismatchCount -ne "0") {
            Add-FinalAuthError -Category "SOURCE_MISMATCH_COUNT_NOT_ZERO" -Phase "READ_EXECUTION_PLAN" -Message ("SourceMismatchCount=" + $sourceMismatchCount) -Resolution "Rerun prep/plan before final authorization."
        }

        if ($targetUnexpectedExistsCount -ne "0") {
            Add-FinalAuthError -Category "TARGET_UNEXPECTED_EXISTS_COUNT_NOT_ZERO" -Phase "READ_EXECUTION_PLAN" -Message ("TargetUnexpectedExistsCount=" + $targetUnexpectedExistsCount) -Resolution "Rerun prep/plan before final authorization."
        }

        if ($targetPathOutsideCount -ne "0") {
            Add-FinalAuthError -Category "TARGET_PATH_OUTSIDE_COUNT_NOT_ZERO" -Phase "READ_EXECUTION_PLAN" -Message ("TargetPathOutsideCount=" + $targetPathOutsideCount) -Resolution "Reject plan."
        }

        $requiredPlanFiles = @(
            @{ Name = "ExecutionPlanPacket"; Path = $executionPlanPacket },
            @{ Name = "CopyPlanManifest"; Path = $copyPlanManifest },
            @{ Name = "CopyPlanManifestJson"; Path = $copyPlanManifestJson },
            @{ Name = "ExecutionSteps"; Path = $executionSteps },
            @{ Name = "VerificationPlan"; Path = $verificationPlan },
            @{ Name = "RollbackExecutionPlan"; Path = $rollbackExecutionPlan },
            @{ Name = "StopConditions"; Path = $stopConditions }
        )

        foreach ($f in $requiredPlanFiles) {
            if ($f.Path -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $f.Path)) {
                Add-FinalAuthError -Category "PLAN_EVIDENCE_FILE_MISSING" -Phase "READ_EXECUTION_PLAN" -Message ($f.Name + "=" + $f.Path) -Resolution "Regenerate execution plan before final authorization."
            }
        }
    }

    if ($AuthorizeBuildExecutionScript) {
        if ($AuthorizationPhrase -eq $RequiredPhrase) {
            $authorizationAccepted = "true"
            $authorizationStatus = "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_LOCKED_FOR_EXECUTION_SCRIPT_BUILD"
            $nextLegalObject = "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1"
            $actions += "EXPLICIT_FINAL_AUTHORIZATION_ACCEPTED_FOR_EXECUTION_SCRIPT_BUILD"
        }
        else {
            Add-FinalAuthError -Category "FINAL_AUTHORIZATION_PHRASE_MISMATCH" -Phase "FINAL_HUMAN_AUTHORIZATION" -Message "Authorization switch was supplied, but phrase did not match required phrase." -Resolution ("Use exact phrase: " + $RequiredPhrase)
            $authorizationAccepted = "false"
            $authorizationStatus = "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_REJECTED_PHRASE_MISMATCH"
            $nextLegalObject = "WAIT_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION"
        }
    }
    else {
        $authorizationAccepted = "false"
        $authorizationStatus = "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_PENDING"
        $nextLegalObject = "WAIT_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION"
        $actions += "NO_FINAL_AUTHORIZATION_SUPPLIED_PENDING_ONLY"
    }

    if (@($errors).Count -gt 0) {
        if ($authorizationStatus -eq "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_LOCKED_FOR_EXECUTION_SCRIPT_BUILD") {
            $authorizationStatus = "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_BLOCKED_BY_GATE_ERRORS"
            $authorizationAccepted = "false"
            $nextLegalObject = "FIX_FINAL_EXECUTION_AUTHORIZATION_GATE_BLOCKERS"
        }
        elseif ($authorizationStatus -eq "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_PENDING") {
            $nextLegalObject = "FIX_FINAL_EXECUTION_AUTHORIZATION_GATE_BLOCKERS"
        }
    }
}
catch {
    Add-FinalAuthError -Category "FINAL_EXECUTION_AUTHORIZATION_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review final authorization gate error ledger."
    $authorizationStatus = "LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_EXCEPTION"
    $authorizationAccepted = "false"
    $nextLegalObject = "FIX_FINAL_EXECUTION_AUTHORIZATION_GATE_EXCEPTION"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE LIVE INSTALL FINAL EXECUTION AUTHORIZATION GATE V1"
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
$errorLines += "This error ledger does not approve live install execution."
$errorLines += "This error ledger does not promote doctrine."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$lockedLines = @()
$lockedLines += "# LOCKED TERMS"
$lockedLines += "## COMMAND CENTER UI LANE LIVE INSTALL EXECUTION SCRIPT BUILD V1"
$lockedLines += ""
$lockedLines += ("GeneratedUtc: " + (Get-UtcNow))
$lockedLines += ("RunStamp: " + $RunStamp)
$lockedLines += ("AuthorizationStatus: " + $authorizationStatus)
$lockedLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$lockedLines += ("AuthorizedBy: " + $AuthorizedBy)
$lockedLines += ""
$lockedLines += "# Exact Execution Plan Source"
$lockedLines += ""
$lockedLines += ("PlanStatus: " + $planStatus)
$lockedLines += ("ExecutionPlanPacket: " + $executionPlanPacket)
$lockedLines += ("CopyPlanManifest: " + $copyPlanManifest)
$lockedLines += ("CopyPlanManifestJson: " + $copyPlanManifestJson)
$lockedLines += ("ExecutionSteps: " + $executionSteps)
$lockedLines += ("VerificationPlan: " + $verificationPlan)
$lockedLines += ("RollbackExecutionPlan: " + $rollbackExecutionPlan)
$lockedLines += ("StopConditions: " + $stopConditions)
$lockedLines += ""
$lockedLines += "# Exact Boundary"
$lockedLines += ""
$lockedLines += ("ProposedSourceRoot: " + $proposedSourceRoot)
$lockedLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$lockedLines += ("CopyPlanFileCount: " + $copyPlanFileCount)
$lockedLines += ("TargetExistsBefore: " + $targetExistsBefore)
$lockedLines += ("CollisionCount: " + $collisionCount)
$lockedLines += ""
$lockedLines += "# Required Phrase"
$lockedLines += ""
$lockedLines += $RequiredPhrase
$lockedLines += ""
$lockedLines += "# Still Not Authorized Here"
$lockedLines += ""
$lockedLines += "LiveInstallExecutionRunAuthorized: false"
$lockedLines += "CopiedFilesToTarget: false"
$lockedLines += "CreatedTargetFolder: false"
$lockedLines += "DoctrinePromotionAuthorized: false"
$lockedLines += "WatcherAuthorized: false"
$lockedLines += "AutomationAuthorized: false"
$lockedLines | Set-Content -LiteralPath $LockedTerms -Encoding UTF8

$packetLines = @()
$packetLines += "# COMMAND CENTER UI LANE LIVE INSTALL FINAL EXECUTION AUTHORIZATION PACKET"
$packetLines += "## V1"
$packetLines += ""
$packetLines += ("GeneratedUtc: " + (Get-UtcNow))
$packetLines += ("RunStamp: " + $RunStamp)
$packetLines += ("AuthorizationStatus: " + $authorizationStatus)
$packetLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$packetLines += ("AuthorizedBy: " + $AuthorizedBy)
$packetLines += ("NextLegalObject: " + $nextLegalObject)
$packetLines += ("ErrorCount: " + @($errors).Count)
$packetLines += ""
$packetLines += "# Required Phrase"
$packetLines += ""
$packetLines += $RequiredPhrase
$packetLines += ""
$packetLines += "# Execution Plan Evidence"
$packetLines += ""
$packetLines += ("PlanStatus: " + $planStatus)
$packetLines += ("PlanNextLegalObject: " + $planNextLegalObject)
$packetLines += ("CopyPlanFileCount: " + $copyPlanFileCount)
$packetLines += ("SourceMismatchCount: " + $sourceMismatchCount)
$packetLines += ("TargetUnexpectedExistsCount: " + $targetUnexpectedExistsCount)
$packetLines += ("TargetPathOutsideCount: " + $targetPathOutsideCount)
$packetLines += ("PlanErrorCount: " + $planErrorCount)
$packetLines += ("ExecutionPlanPacket: " + $executionPlanPacket)
$packetLines += ("CopyPlanManifest: " + $copyPlanManifest)
$packetLines += ("StopConditions: " + $stopConditions)
$packetLines += ""
$packetLines += "# Work Readiness"
$packetLines += ""
$packetLines += ("WorkEntryStatus: " + $workEntryStatus)
$packetLines += ("OpenSideQuestRequired: " + $openSideQuestRequired)
$packetLines += ""
$packetLines += "# Files Written"
$packetLines += ""
$packetLines += ("LockedTerms: " + $LockedTerms)
$packetLines += ("NextObjectCard: " + $NextObjectCard)
$packetLines += ("PendingCard: " + $PendingCard)
$packetLines += ("Receipt: " + $Receipt)
$packetLines += ("ErrorLedger: " + $ErrorLedger)
$packetLines += ""
$packetLines += "# Boundary"
$packetLines += ""
$packetLines += "LiveInstallExecutionRunAuthorized: false"
$packetLines += "CopiedFilesToTarget: false"
$packetLines += "CreatedTargetFolder: false"
$packetLines += "DoctrinePromotionAuthorized: false"
$packetLines += "CommitAuthorized: false"
$packetLines += "PushAuthorized: false"
$packetLines += "WatcherAuthorized: false"
$packetLines += "AutomationAuthorized: false"
$packetLines | Set-Content -LiteralPath $AuthorizationPacket -Encoding UTF8

$nextLines = @()
$nextLines += "# NEXT OBJECT CARD"
$nextLines += "## COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE_V1"
$nextLines += ""
$nextLines += ("GeneratedUtc: " + (Get-UtcNow))
$nextLines += ("RunStamp: " + $RunStamp)
$nextLines += ("AuthorizationStatus: " + $authorizationStatus)
$nextLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$nextLines += ("SourceAuthorizationPacket: " + $AuthorizationPacket)
$nextLines += ("LockedTerms: " + $LockedTerms)
$nextLines += ""
$nextLines += "# Legal Meaning"
$nextLines += ""
if ($authorizationAccepted -eq "true") {
    $nextLines += "The next legal object may build the install execution script."
}
else {
    $nextLines += "The next legal object is not allowed yet. Final human authorization is pending or blocked."
}
$nextLines += ""
$nextLines += "# Still Not Authorized Here"
$nextLines += ""
$nextLines += "LiveInstallExecutionRunAuthorized: false"
$nextLines += "This card does not run install."
$nextLines | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$pendingLines = @()
$pendingLines += "# PENDING CARD"
$pendingLines += "## COMMAND CENTER UI LANE LIVE INSTALL FINAL EXECUTION AUTHORIZATION V1"
$pendingLines += ""
$pendingLines += ("GeneratedUtc: " + (Get-UtcNow))
$pendingLines += ("AuthorizationStatus: " + $authorizationStatus)
$pendingLines += ""
$pendingLines += "# Required Phrase"
$pendingLines += ""
$pendingLines += $RequiredPhrase
$pendingLines += ""
$pendingLines += "# Run Shape To Authorize Execution Script Build"
$pendingLines += ""
$pendingLines += 'pwsh -NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '" -AuthorizeBuildExecutionScript -AuthorizationPhrase "' + $RequiredPhrase + '" -AuthorizedBy "Jonathon"'
$pendingLines += ""
$pendingLines += "# Boundary"
$pendingLines += ""
$pendingLines += "This pending card does not run install."
$pendingLines | Set-Content -LiteralPath $PendingCard -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    AuthorizationStatus = $authorizationStatus
    AuthorizationAccepted = $authorizationAccepted
    AuthorizedBy = $AuthorizedBy
    NextLegalObject = $nextLegalObject
    RequiredPhrase = $RequiredPhrase
    WorkEntryStatus = $workEntryStatus
    OpenSideQuestRequired = $openSideQuestRequired
    PlanStatus = $planStatus
    CopyPlanFileCount = $copyPlanFileCount
    SourceMismatchCount = $sourceMismatchCount
    TargetUnexpectedExistsCount = $targetUnexpectedExistsCount
    TargetPathOutsideCount = $targetPathOutsideCount
    AuthorizationPacket = $AuthorizationPacket
    LockedTerms = $LockedTerms
    NextObjectCard = $NextObjectCard
    PendingCard = $PendingCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
    LiveInstallExecutionRunAuthorized = $false
    DoctrinePromotionAuthorized = $false
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentFinalAuthStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE LIVE INSTALL FINAL EXECUTION AUTHORIZATION STATUS"
$statusLines += ""
$statusLines += ("GeneratedUtc: " + $statusObj.GeneratedUtc)
$statusLines += ("RunStamp: " + $RunStamp)
$statusLines += ("AuthorizationStatus: " + $authorizationStatus)
$statusLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$statusLines += ("AuthorizedBy: " + $AuthorizedBy)
$statusLines += ("NextLegalObject: " + $nextLegalObject)
$statusLines += ("RequiredPhrase: " + $RequiredPhrase)
$statusLines += ("WorkEntryStatus: " + $workEntryStatus)
$statusLines += ("OpenSideQuestRequired: " + $openSideQuestRequired)
$statusLines += ("PlanStatus: " + $planStatus)
$statusLines += ("CopyPlanFileCount: " + $copyPlanFileCount)
$statusLines += ("SourceMismatchCount: " + $sourceMismatchCount)
$statusLines += ("TargetUnexpectedExistsCount: " + $targetUnexpectedExistsCount)
$statusLines += ("TargetPathOutsideCount: " + $targetPathOutsideCount)
$statusLines += ("ErrorCount: " + @($errors).Count)
$statusLines += ""
$statusLines += "# Files"
$statusLines += ""
$statusLines += ("AuthorizationPacket: " + $AuthorizationPacket)
$statusLines += ("LockedTerms: " + $LockedTerms)
$statusLines += ("NextObjectCard: " + $NextObjectCard)
$statusLines += ("PendingCard: " + $PendingCard)
$statusLines += ("Receipt: " + $Receipt)
$statusLines += ("ErrorLedger: " + $ErrorLedger)
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
$statusLines | Set-Content -LiteralPath $CurrentFinalAuthStatusMd -Encoding UTF8

$receiptLines = @()
$receiptLines += "# RECEIPT"
$receiptLines += "## COMMAND CENTER UI LANE LIVE INSTALL FINAL EXECUTION AUTHORIZATION GATE V1"
$receiptLines += ""
$receiptLines += ("Date: " + $DateTag)
$receiptLines += ("GeneratedUtc: " + (Get-UtcNow))
$receiptLines += ("RunStamp: " + $RunStamp)
$receiptLines += ("AuthorizationStatus: " + $authorizationStatus)
$receiptLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$receiptLines += ("AuthorizedBy: " + $AuthorizedBy)
$receiptLines += ("NextLegalObject: " + $nextLegalObject)
$receiptLines += ("RequiredPhrase: " + $RequiredPhrase)
$receiptLines += ("AuthorizationPacket: " + $AuthorizationPacket)
$receiptLines += ("LockedTerms: " + $LockedTerms)
$receiptLines += ("CurrentFinalAuthStatus: " + $CurrentFinalAuthStatusMd)
$receiptLines += ("CurrentFinalAuthStatusJson: " + $CurrentFinalAuthStatusJson)
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
$receiptLines += "OpenedVSCode: false"
$receiptLines += "ClosedVSCode: false"
$receiptLines += ""
$receiptLines += "# DoesNotProve"
$receiptLines += ""
$receiptLines += "This receipt does not run live install."
$receiptLines += "This receipt does not promote doctrine."
$receiptLines += "This receipt does not authorize cleanup."
$receiptLines | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host ""
Write-Host "Command Center UI lane live-install final execution authorization gate complete."
Write-Host "AuthorizationStatus:"
Write-Host $authorizationStatus
Write-Host ""
Write-Host "AuthorizationAccepted:"
Write-Host $authorizationAccepted
Write-Host ""
Write-Host "NextLegalObject:"
Write-Host $nextLegalObject
Write-Host ""
Write-Host "RequiredPhrase:"
Write-Host $RequiredPhrase
Write-Host ""
Write-Host "Current final authorization status:"
Write-Host $CurrentFinalAuthStatusMd
Write-Host ""
Write-Host "Authorization packet:"
Write-Host $AuthorizationPacket
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_FINALIZED"

