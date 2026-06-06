<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE_V1_20260606.ps1

PURPOSE:
Ask for and record explicit human authorization for a future live-install execution plan.

THIS IS NOT LIVE INSTALL.
THIS DOES NOT COPY FILES.
THIS DOES NOT CREATE THE TARGET FOLDER.
THIS DOES NOT EXECUTE INSTALL.

REQUIRED AUTHORIZATION PHRASE:
I AUTHORIZE PREPARING THE COMMAND CENTER UI LANE LIVE INSTALL EXECUTION PLAN

LEGAL OUTCOMES:
- LIVE_INSTALL_HUMAN_AUTHORIZATION_PENDING
- LIVE_INSTALL_HUMAN_AUTHORIZATION_LOCKED_FOR_EXECUTION_PLAN
- LIVE_INSTALL_HUMAN_AUTHORIZATION_REJECTED_PHRASE_MISMATCH
- LIVE_INSTALL_HUMAN_AUTHORIZATION_BLOCKED_BY_GATE_ERRORS
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [switch]$AuthorizePrepareExecutionPlan,

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
$RequiredPhrase = "I AUTHORIZE PREPARING THE COMMAND CENTER UI LANE LIVE INSTALL EXECUTION PLAN"

$CommandCenterRoot = Join-Path $Root "COMMAND_CENTER"
$WorkEntryRoot = Join-Path $CommandCenterRoot "WORK_ENTRYPOINT"
$UiLaneRoot = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$PrepGateRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_PREP_GATE"
$AuthGateRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE"
$RunRoot = Join-Path $AuthGateRoot ("COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE_V1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$PrepStatusMd = Join-Path $PrepGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_PREP_GATE_STATUS.md"
$PrepStatusJson = Join-Path $PrepGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_PREP_GATE_STATUS.json"

$CurrentAuthStatusMd = Join-Path $AuthGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_STATUS.md"
$CurrentAuthStatusJson = Join-Path $AuthGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_STATUS.json"

$AuthorizationPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_PACKET_V1_20260606.md"
$LockedTerms = Join-Path $RunRoot "LOCKED_TERMS__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_V1_20260606.md"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_V1_20260606.md"
$PendingCard = Join-Path $RunRoot "PENDING_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_AUTHORIZATION_V1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE_V1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_HUMAN_AUTHORIZATION_GATE.txt"

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

function Add-AuthError {
    param([string]$Category, [string]$Phase, [string]$Message, [string]$Resolution = "")

    $script:errors += [pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
    }
}

New-Dir $AuthGateRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"
$prepStatus = "UNKNOWN"
$prepNextLegalObject = "UNKNOWN"
$proposedSourceRoot = "UNKNOWN"
$proposedTargetRoot = "UNKNOWN"
$proposedInstallFileCount = "UNKNOWN"
$targetExistsBefore = "UNKNOWN"
$collisionCount = "UNKNOWN"
$installManifest = "UNKNOWN"
$installManifestJson = "UNKNOWN"
$sourceHashLedger = "UNKNOWN"
$targetBeforeHashLedger = "UNKNOWN"
$collisionMap = "UNKNOWN"
$rollbackPlan = "UNKNOWN"
$prepPacket = "UNKNOWN"
$prepErrorCount = "UNKNOWN"

$authorizationStatus = "LIVE_INSTALL_HUMAN_AUTHORIZATION_PENDING"
$nextLegalObject = "WAIT_FOR_EXPLICIT_HUMAN_AUTHORIZATION"
$authorizationAccepted = "false"

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-AuthError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Write/install Command Center work entrypoint before authorization gate."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_HUMAN_AUTHORIZATION_GATE: " + $WorkEntryScript)
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-AuthError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint before authorization gate."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"
        $actions += ("READ_WORK_ENTRY_STATUS: " + $WorkEntryStatusMd)

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-AuthError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Resolve work entry/pre-run block first."
        }

        if ($openSideQuestRequired -ne "False") {
            Add-AuthError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error-triggered helper harvest first."
        }
    }

    if (-not (Test-Path -LiteralPath $PrepStatusMd)) {
        Add-AuthError -Category "PREP_STATUS_MISSING" -Phase "READ_PREP_STATUS" -Message $PrepStatusMd -Resolution "Run live-install prep gate before authorization gate."
    }
    else {
        $prepText = Get-Content -LiteralPath $PrepStatusMd -Raw -ErrorAction Stop
        $prepStatus = Get-InlineValue -Text $prepText -Name "PrepStatus"
        $prepNextLegalObject = Get-InlineValue -Text $prepText -Name "NextLegalObject"
        $proposedSourceRoot = Get-InlineValue -Text $prepText -Name "ProposedSourceRoot"
        $proposedTargetRoot = Get-InlineValue -Text $prepText -Name "ProposedTargetRoot"
        $proposedInstallFileCount = Get-InlineValue -Text $prepText -Name "ProposedInstallFileCount"
        $targetExistsBefore = Get-InlineValue -Text $prepText -Name "TargetExistsBefore"
        $collisionCount = Get-InlineValue -Text $prepText -Name "CollisionCount"
        $installManifest = Get-InlineValue -Text $prepText -Name "InstallManifest"
        $installManifestJson = Get-InlineValue -Text $prepText -Name "InstallManifestJson"
        $sourceHashLedger = Get-InlineValue -Text $prepText -Name "SourceHashLedger"
        $targetBeforeHashLedger = Get-InlineValue -Text $prepText -Name "TargetBeforeHashLedger"
        $collisionMap = Get-InlineValue -Text $prepText -Name "CollisionMap"
        $rollbackPlan = Get-InlineValue -Text $prepText -Name "RollbackPlan"
        $prepPacket = Get-InlineValue -Text $prepText -Name "PrepPacket"
        $prepErrorCount = Get-InlineValue -Text $prepText -Name "ErrorCount"
        $actions += ("READ_LIVE_INSTALL_PREP_STATUS: " + $PrepStatusMd)

        if ($prepStatus -ne "LIVE_INSTALL_PREP_READY_FOR_HUMAN_AUTHORIZATION_GATE") {
            Add-AuthError -Category "PREP_GATE_NOT_READY" -Phase "READ_PREP_STATUS" -Message ("PrepStatus=" + $prepStatus) -Resolution "Fix prep gate blockers before authorization."
        }

        if ($prepNextLegalObject -ne "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE_V1") {
            Add-AuthError -Category "PREP_NEXT_OBJECT_UNEXPECTED" -Phase "READ_PREP_STATUS" -Message ("NextLegalObject=" + $prepNextLegalObject) -Resolution "Review prep gate next object."
        }

        if ($prepErrorCount -ne "0") {
            Add-AuthError -Category "PREP_ERROR_COUNT_NOT_ZERO" -Phase "READ_PREP_STATUS" -Message ("ErrorCount=" + $prepErrorCount) -Resolution "Fix prep errors before authorization."
        }

        $requiredPrepFiles = @(
            @{ Name = "InstallManifest"; Path = $installManifest },
            @{ Name = "InstallManifestJson"; Path = $installManifestJson },
            @{ Name = "SourceHashLedger"; Path = $sourceHashLedger },
            @{ Name = "TargetBeforeHashLedger"; Path = $targetBeforeHashLedger },
            @{ Name = "CollisionMap"; Path = $collisionMap },
            @{ Name = "RollbackPlan"; Path = $rollbackPlan },
            @{ Name = "PrepPacket"; Path = $prepPacket }
        )

        foreach ($f in $requiredPrepFiles) {
            if ($f.Path -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $f.Path)) {
                Add-AuthError -Category "PREP_EVIDENCE_FILE_MISSING" -Phase "READ_PREP_STATUS" -Message ($f.Name + "=" + $f.Path) -Resolution "Regenerate prep gate evidence before authorization."
            }
        }
    }

    if ($AuthorizePrepareExecutionPlan) {
        if ($AuthorizationPhrase -eq $RequiredPhrase) {
            $authorizationAccepted = "true"
            $authorizationStatus = "LIVE_INSTALL_HUMAN_AUTHORIZATION_LOCKED_FOR_EXECUTION_PLAN"
            $nextLegalObject = "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_V1"
            $actions += "EXPLICIT_HUMAN_AUTHORIZATION_ACCEPTED_FOR_EXECUTION_PLAN_PREPARATION"
        }
        else {
            Add-AuthError -Category "AUTHORIZATION_PHRASE_MISMATCH" -Phase "HUMAN_AUTHORIZATION" -Message "Authorization switch was supplied, but phrase did not match required phrase." -Resolution ("Use exact phrase: " + $RequiredPhrase)
            $authorizationAccepted = "false"
            $authorizationStatus = "LIVE_INSTALL_HUMAN_AUTHORIZATION_REJECTED_PHRASE_MISMATCH"
            $nextLegalObject = "WAIT_FOR_EXPLICIT_HUMAN_AUTHORIZATION"
        }
    }
    else {
        $authorizationAccepted = "false"
        $authorizationStatus = "LIVE_INSTALL_HUMAN_AUTHORIZATION_PENDING"
        $nextLegalObject = "WAIT_FOR_EXPLICIT_HUMAN_AUTHORIZATION"
        $actions += "NO_AUTHORIZATION_SUPPLIED_PENDING_ONLY"
    }

    if (@($errors).Count -gt 0) {
        if ($authorizationStatus -eq "LIVE_INSTALL_HUMAN_AUTHORIZATION_LOCKED_FOR_EXECUTION_PLAN") {
            $authorizationStatus = "LIVE_INSTALL_HUMAN_AUTHORIZATION_BLOCKED_BY_GATE_ERRORS"
            $authorizationAccepted = "false"
            $nextLegalObject = "FIX_HUMAN_AUTHORIZATION_GATE_BLOCKERS"
        }
        elseif ($authorizationStatus -eq "LIVE_INSTALL_HUMAN_AUTHORIZATION_PENDING") {
            $nextLegalObject = "FIX_HUMAN_AUTHORIZATION_GATE_BLOCKERS"
        }
    }
}
catch {
    Add-AuthError -Category "HUMAN_AUTHORIZATION_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review authorization gate error ledger."
    $authorizationStatus = "LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE_EXCEPTION"
    $authorizationAccepted = "false"
    $nextLegalObject = "FIX_HUMAN_AUTHORIZATION_GATE_EXCEPTION"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE LIVE INSTALL HUMAN AUTHORIZATION GATE V1"
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
$errorLines += "This error ledger does not approve live install or doctrine promotion."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$lockedLines = @()
$lockedLines += "# LOCKED TERMS"
$lockedLines += "## COMMAND CENTER UI LANE LIVE INSTALL V1"
$lockedLines += ""
$lockedLines += ("GeneratedUtc: " + (Get-UtcNow))
$lockedLines += ("RunStamp: " + $RunStamp)
$lockedLines += ("AuthorizationStatus: " + $authorizationStatus)
$lockedLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$lockedLines += ("AuthorizedBy: " + $AuthorizedBy)
$lockedLines += ""
$lockedLines += "# Exact Proposed Boundary"
$lockedLines += ""
$lockedLines += ("ProposedSourceRoot: " + $proposedSourceRoot)
$lockedLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$lockedLines += ("ProposedInstallFileCount: " + $proposedInstallFileCount)
$lockedLines += ("TargetExistsBefore: " + $targetExistsBefore)
$lockedLines += ("CollisionCount: " + $collisionCount)
$lockedLines += ""
$lockedLines += "# Exact Evidence Files"
$lockedLines += ""
$lockedLines += ("PrepStatus: " + $prepStatus)
$lockedLines += ("PrepPacket: " + $prepPacket)
$lockedLines += ("InstallManifest: " + $installManifest)
$lockedLines += ("InstallManifestJson: " + $installManifestJson)
$lockedLines += ("SourceHashLedger: " + $sourceHashLedger)
$lockedLines += ("TargetBeforeHashLedger: " + $targetBeforeHashLedger)
$lockedLines += ("CollisionMap: " + $collisionMap)
$lockedLines += ("RollbackPlan: " + $rollbackPlan)
$lockedLines += ""
$lockedLines += "# Required Phrase"
$lockedLines += ""
$lockedLines += $RequiredPhrase
$lockedLines += ""
$lockedLines += "# Still Not Authorized Here"
$lockedLines += ""
$lockedLines += "LiveInstallExecutionAuthorized: false"
$lockedLines += "DoctrinePromotionAuthorized: false"
$lockedLines += "WatcherAuthorized: false"
$lockedLines += "AutomationAuthorized: false"
$lockedLines += "CleanupAuthorized: false"
$lockedLines += "CommitAuthorized: false"
$lockedLines += "PushAuthorized: false"
$lockedLines | Set-Content -LiteralPath $LockedTerms -Encoding UTF8

$packetLines = @()
$packetLines += "# COMMAND CENTER UI LANE LIVE INSTALL HUMAN AUTHORIZATION PACKET"
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
$packetLines += "# Prep Evidence"
$packetLines += ""
$packetLines += ("PrepStatus: " + $prepStatus)
$packetLines += ("PrepNextLegalObject: " + $prepNextLegalObject)
$packetLines += ("ProposedSourceRoot: " + $proposedSourceRoot)
$packetLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$packetLines += ("ProposedInstallFileCount: " + $proposedInstallFileCount)
$packetLines += ("TargetExistsBefore: " + $targetExistsBefore)
$packetLines += ("CollisionCount: " + $collisionCount)
$packetLines += ("PrepPacket: " + $prepPacket)
$packetLines += ("InstallManifest: " + $installManifest)
$packetLines += ("RollbackPlan: " + $rollbackPlan)
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
$packetLines += "LiveInstallExecutionAuthorized: false"
$packetLines += "DoctrinePromotionAuthorized: false"
$packetLines += "CopiedFilesToTarget: false"
$packetLines += "CreatedTargetFolder: false"
$packetLines += "CommitAuthorized: false"
$packetLines += "PushAuthorized: false"
$packetLines += "WatcherAuthorized: false"
$packetLines += "AutomationAuthorized: false"
$packetLines | Set-Content -LiteralPath $AuthorizationPacket -Encoding UTF8

$nextLines = @()
$nextLines += "# NEXT OBJECT CARD"
$nextLines += "## COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_V1"
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
    $nextLines += "The next legal object may build a live-install execution plan."
}
else {
    $nextLines += "The next legal object is not allowed yet. Human authorization is pending or blocked."
}
$nextLines += ""
$nextLines += "# Still Not Authorized Here"
$nextLines += ""
$nextLines += "LiveInstallExecutionAuthorized: false"
$nextLines += "This card does not execute install."
$nextLines | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$pendingLines = @()
$pendingLines += "# PENDING CARD"
$pendingLines += "## COMMAND CENTER UI LANE LIVE INSTALL AUTHORIZATION V1"
$pendingLines += ""
$pendingLines += ("GeneratedUtc: " + (Get-UtcNow))
$pendingLines += ("AuthorizationStatus: " + $authorizationStatus)
$pendingLines += ""
$pendingLines += "# Required Phrase"
$pendingLines += ""
$pendingLines += $RequiredPhrase
$pendingLines += ""
$pendingLines += "# Run Shape To Authorize Execution Plan Preparation"
$pendingLines += ""
$pendingLines += 'pwsh -NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '" -AuthorizePrepareExecutionPlan -AuthorizationPhrase "' + $RequiredPhrase + '" -AuthorizedBy "Jonathon"'
$pendingLines += ""
$pendingLines += "# Boundary"
$pendingLines += ""
$pendingLines += "This pending card does not approve install."
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
    PrepStatus = $prepStatus
    ProposedSourceRoot = $proposedSourceRoot
    ProposedTargetRoot = $proposedTargetRoot
    ProposedInstallFileCount = $proposedInstallFileCount
    TargetExistsBefore = $targetExistsBefore
    CollisionCount = $collisionCount
    AuthorizationPacket = $AuthorizationPacket
    LockedTerms = $LockedTerms
    NextObjectCard = $NextObjectCard
    PendingCard = $PendingCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
    LiveInstallExecutionAuthorized = $false
    DoctrinePromotionAuthorized = $false
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentAuthStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE LIVE INSTALL HUMAN AUTHORIZATION STATUS"
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
$statusLines += ("PrepStatus: " + $prepStatus)
$statusLines += ("ProposedSourceRoot: " + $proposedSourceRoot)
$statusLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$statusLines += ("ProposedInstallFileCount: " + $proposedInstallFileCount)
$statusLines += ("TargetExistsBefore: " + $targetExistsBefore)
$statusLines += ("CollisionCount: " + $collisionCount)
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
$statusLines += "LiveInstallExecutionAuthorized: false"
$statusLines += "DoctrinePromotionAuthorized: false"
$statusLines += "CopiedFilesToTarget: false"
$statusLines += "CreatedTargetFolder: false"
$statusLines += "CommitAuthorized: false"
$statusLines += "PushAuthorized: false"
$statusLines += "WatcherAuthorized: false"
$statusLines += "AutomationAuthorized: false"
$statusLines | Set-Content -LiteralPath $CurrentAuthStatusMd -Encoding UTF8

$receiptLines = @()
$receiptLines += "# RECEIPT"
$receiptLines += "## COMMAND CENTER UI LANE LIVE INSTALL HUMAN AUTHORIZATION GATE V1"
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
$receiptLines += ("CurrentAuthStatus: " + $CurrentAuthStatusMd)
$receiptLines += ("CurrentAuthStatusJson: " + $CurrentAuthStatusJson)
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
$receiptLines += "LiveInstallExecutionAuthorized: false"
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
$receiptLines += "This receipt does not approve live install execution."
$receiptLines += "This receipt does not promote doctrine."
$receiptLines += "This receipt does not authorize cleanup."
$receiptLines | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host ""
Write-Host "Command Center UI lane live-install human authorization gate complete."
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
Write-Host "Current authorization status:"
Write-Host $CurrentAuthStatusMd
Write-Host ""
Write-Host "Authorization packet:"
Write-Host $AuthorizationPacket
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE_FINALIZED"

