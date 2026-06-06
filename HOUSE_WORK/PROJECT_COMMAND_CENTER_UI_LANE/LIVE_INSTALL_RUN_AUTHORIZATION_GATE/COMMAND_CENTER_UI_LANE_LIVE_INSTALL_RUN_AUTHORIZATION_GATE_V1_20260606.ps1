<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1_20260606.ps1

PURPOSE:
Ask for and record explicit final human authorization to run the already-built live-install execution script.

THIS GATE DOES NOT RUN INSTALL.
THIS GATE DOES NOT COPY FILES.
THIS GATE DOES NOT CREATE THE TARGET FOLDER.
THIS GATE ONLY LOCKS OR REJECTS RUN AUTHORIZATION.

REQUIRED AUTHORIZATION PHRASE:
I AUTHORIZE RUNNING THE COMMAND CENTER UI LANE LIVE INSTALL NOW

LEGAL OUTCOMES:
- LIVE_INSTALL_RUN_AUTHORIZATION_PENDING
- LIVE_INSTALL_RUN_AUTHORIZATION_LOCKED_FOR_EXECUTION_RUN
- LIVE_INSTALL_RUN_AUTHORIZATION_REJECTED_PHRASE_MISMATCH
- LIVE_INSTALL_RUN_AUTHORIZATION_BLOCKED_BY_GATE_ERRORS

NEXT LEGAL OBJECT IF LOCKED:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_RUN_V1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [switch]$AuthorizeRunInstall,

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
$RequiredPhrase = "I AUTHORIZE RUNNING THE COMMAND CENTER UI LANE LIVE INSTALL NOW"

$CommandCenterRoot = Join-Path $Root "COMMAND_CENTER"
$WorkEntryRoot = Join-Path $CommandCenterRoot "WORK_ENTRYPOINT"
$UiLaneRoot = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE"
$ScriptBuildRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_GATE"
$RunAuthRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_RUN_AUTHORIZATION_GATE"
$RunRoot = Join-Path $RunAuthRoot ("COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$BuildStatusMd = Join-Path $ScriptBuildRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_STATUS.md"
$BuildStatusJson = Join-Path $ScriptBuildRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_SCRIPT_BUILD_STATUS.json"

$CurrentRunAuthStatusMd = Join-Path $RunAuthRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_STATUS.md"
$CurrentRunAuthStatusJson = Join-Path $RunAuthRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_STATUS.json"

$AuthorizationPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_PACKET_V1_20260606.md"
$LockedTerms = Join-Path $RunRoot "LOCKED_TERMS__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_RUN_V1_20260606.md"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_RUN_V1_20260606.md"
$PendingCard = Join-Path $RunRoot "PENDING_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_V1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_RUN_AUTHORIZATION_GATE.txt"

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

function Add-RunAuthError {
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

New-Dir $RunAuthRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"
$buildStatus = "UNKNOWN"
$buildNextLegalObject = "UNKNOWN"
$builtScript = "UNKNOWN"
$builtScriptSHA256 = "UNKNOWN"
$syntaxErrorCount = "UNKNOWN"
$copyPlanManifestJson = "UNKNOWN"
$copyPlanFileCount = "UNKNOWN"
$buildErrorCount = "UNKNOWN"
$currentBuiltScriptHash = "UNKNOWN"
$currentBuiltScriptSyntaxErrors = "UNKNOWN"

$authorizationStatus = "LIVE_INSTALL_RUN_AUTHORIZATION_PENDING"
$authorizationAccepted = "false"
$nextLegalObject = "WAIT_FOR_LIVE_INSTALL_RUN_AUTHORIZATION"

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-RunAuthError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Work entrypoint required before run authorization."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_RUN_AUTHORIZATION_GATE: " + $WorkEntryScript)
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-RunAuthError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint before run authorization."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"
        $actions += ("READ_WORK_ENTRY_STATUS: " + $WorkEntryStatusMd)

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-RunAuthError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Resolve work entry/pre-run block first."
        }

        if ($openSideQuestRequired -ne "False") {
            Add-RunAuthError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error-triggered helper harvest first."
        }
    }

    if (-not (Test-Path -LiteralPath $BuildStatusMd)) {
        Add-RunAuthError -Category "EXECUTION_SCRIPT_BUILD_STATUS_MISSING" -Phase "READ_SCRIPT_BUILD" -Message $BuildStatusMd -Resolution "Run execution script build gate before run authorization."
    }
    else {
        $buildText = Get-Content -LiteralPath $BuildStatusMd -Raw -ErrorAction Stop
        $buildStatus = Get-InlineValue -Text $buildText -Name "BuildStatus"
        $buildNextLegalObject = Get-InlineValue -Text $buildText -Name "NextLegalObject"
        $builtScript = Get-InlineValue -Text $buildText -Name "BuiltScript"
        $builtScriptSHA256 = Get-InlineValue -Text $buildText -Name "BuiltScriptSHA256"
        $syntaxErrorCount = Get-InlineValue -Text $buildText -Name "SyntaxErrorCount"
        $copyPlanManifestJson = Get-InlineValue -Text $buildText -Name "CopyPlanManifestJson"
        $copyPlanFileCount = Get-InlineValue -Text $buildText -Name "CopyPlanFileCount"
        $buildErrorCount = Get-InlineValue -Text $buildText -Name "ErrorCount"
        $actions += ("READ_EXECUTION_SCRIPT_BUILD_STATUS: " + $BuildStatusMd)

        if ($buildStatus -ne "LIVE_INSTALL_EXECUTION_SCRIPT_BUILT_READY_FOR_RUN_AUTHORIZATION_GATE") {
            Add-RunAuthError -Category "EXECUTION_SCRIPT_BUILD_NOT_READY" -Phase "READ_SCRIPT_BUILD" -Message ("BuildStatus=" + $buildStatus) -Resolution "Fix script build blockers before run authorization."
        }

        if ($buildNextLegalObject -ne "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_V1") {
            Add-RunAuthError -Category "SCRIPT_BUILD_NEXT_OBJECT_UNEXPECTED" -Phase "READ_SCRIPT_BUILD" -Message ("NextLegalObject=" + $buildNextLegalObject) -Resolution "Review script build status."
        }

        if ($buildErrorCount -ne "0") {
            Add-RunAuthError -Category "SCRIPT_BUILD_ERROR_COUNT_NOT_ZERO" -Phase "READ_SCRIPT_BUILD" -Message ("ErrorCount=" + $buildErrorCount) -Resolution "Fix script build errors."
        }

        if ($syntaxErrorCount -ne "0") {
            Add-RunAuthError -Category "BUILT_SCRIPT_SYNTAX_ERROR_COUNT_NOT_ZERO" -Phase "READ_SCRIPT_BUILD" -Message ("SyntaxErrorCount=" + $syntaxErrorCount) -Resolution "Repair built script before run authorization."
        }

        if ($builtScript -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $builtScript)) {
            Add-RunAuthError -Category "BUILT_SCRIPT_MISSING" -Phase "READ_SCRIPT_BUILD" -Message ("BuiltScript=" + $builtScript) -Resolution "Regenerate execution script build gate."
        }
        else {
            $currentBuiltScriptHash = (Get-FileHash -LiteralPath $builtScript -Algorithm SHA256).Hash
            if ($currentBuiltScriptHash -ne $builtScriptSHA256) {
                Add-RunAuthError -Category "BUILT_SCRIPT_HASH_CHANGED" -Phase "VERIFY_BUILT_SCRIPT" -Message ("CurrentHash=" + $currentBuiltScriptHash + " ExpectedHash=" + $builtScriptSHA256) -Resolution "Regenerate execution script build gate before run authorization."
            }

            $syntax = Test-PowerShellSyntax -Path $builtScript
            $currentBuiltScriptSyntaxErrors = [string]$syntax.ErrorCount
            if ($syntax.ErrorCount -ne 0) {
                Add-RunAuthError -Category "BUILT_SCRIPT_CURRENT_SYNTAX_ERRORS" -Phase "VERIFY_BUILT_SCRIPT" -Message ("CurrentSyntaxErrorCount=" + $syntax.ErrorCount) -Resolution "Repair built execution script before run authorization."
            }
        }

        if ($copyPlanManifestJson -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $copyPlanManifestJson)) {
            Add-RunAuthError -Category "COPY_PLAN_MANIFEST_JSON_MISSING" -Phase "READ_SCRIPT_BUILD" -Message ("CopyPlanManifestJson=" + $copyPlanManifestJson) -Resolution "Regenerate execution plan/build gate."
        }
    }

    if ($AuthorizeRunInstall) {
        if ($AuthorizationPhrase -eq $RequiredPhrase) {
            $authorizationAccepted = "true"
            $authorizationStatus = "LIVE_INSTALL_RUN_AUTHORIZATION_LOCKED_FOR_EXECUTION_RUN"
            $nextLegalObject = "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_RUN_V1"
            $actions += "EXPLICIT_RUN_AUTHORIZATION_ACCEPTED_FOR_LIVE_INSTALL_EXECUTION"
        }
        else {
            Add-RunAuthError -Category "RUN_AUTHORIZATION_PHRASE_MISMATCH" -Phase "RUN_HUMAN_AUTHORIZATION" -Message "Authorization switch was supplied, but phrase did not match required phrase." -Resolution ("Use exact phrase: " + $RequiredPhrase)
            $authorizationAccepted = "false"
            $authorizationStatus = "LIVE_INSTALL_RUN_AUTHORIZATION_REJECTED_PHRASE_MISMATCH"
            $nextLegalObject = "WAIT_FOR_LIVE_INSTALL_RUN_AUTHORIZATION"
        }
    }
    else {
        $authorizationAccepted = "false"
        $authorizationStatus = "LIVE_INSTALL_RUN_AUTHORIZATION_PENDING"
        $nextLegalObject = "WAIT_FOR_LIVE_INSTALL_RUN_AUTHORIZATION"
        $actions += "NO_RUN_AUTHORIZATION_SUPPLIED_PENDING_ONLY"
    }

    if (@($errors).Count -gt 0) {
        if ($authorizationStatus -eq "LIVE_INSTALL_RUN_AUTHORIZATION_LOCKED_FOR_EXECUTION_RUN") {
            $authorizationStatus = "LIVE_INSTALL_RUN_AUTHORIZATION_BLOCKED_BY_GATE_ERRORS"
            $authorizationAccepted = "false"
            $nextLegalObject = "FIX_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_BLOCKERS"
        }
        elseif ($authorizationStatus -eq "LIVE_INSTALL_RUN_AUTHORIZATION_PENDING") {
            $nextLegalObject = "FIX_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_BLOCKERS"
        }
    }
}
catch {
    Add-RunAuthError -Category "RUN_AUTHORIZATION_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review run authorization gate error ledger."
    $authorizationStatus = "LIVE_INSTALL_RUN_AUTHORIZATION_GATE_EXCEPTION"
    $authorizationAccepted = "false"
    $nextLegalObject = "FIX_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_EXCEPTION"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE LIVE INSTALL RUN AUTHORIZATION GATE V1"
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
$errorLines += "This error ledger does not run live install."
$errorLines += "This error ledger does not promote doctrine."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$lockedLines = @()
$lockedLines += "# LOCKED TERMS"
$lockedLines += "## COMMAND CENTER UI LANE LIVE INSTALL EXECUTION RUN V1"
$lockedLines += ""
$lockedLines += ("GeneratedUtc: " + (Get-UtcNow))
$lockedLines += ("RunStamp: " + $RunStamp)
$lockedLines += ("AuthorizationStatus: " + $authorizationStatus)
$lockedLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$lockedLines += ("AuthorizedBy: " + $AuthorizedBy)
$lockedLines += ""
$lockedLines += "# Exact Built Script"
$lockedLines += ""
$lockedLines += ("BuiltScript: " + $builtScript)
$lockedLines += ("BuiltScriptSHA256: " + $builtScriptSHA256)
$lockedLines += ("CurrentBuiltScriptSHA256: " + $currentBuiltScriptHash)
$lockedLines += ("CurrentBuiltScriptSyntaxErrors: " + $currentBuiltScriptSyntaxErrors)
$lockedLines += ("CopyPlanManifestJson: " + $copyPlanManifestJson)
$lockedLines += ("CopyPlanFileCount: " + $copyPlanFileCount)
$lockedLines += ""
$lockedLines += "# Required Phrase"
$lockedLines += ""
$lockedLines += $RequiredPhrase
$lockedLines += ""
$lockedLines += "# Still Not Executed Here"
$lockedLines += ""
$lockedLines += "LiveInstallExecutedHere: false"
$lockedLines += "CopiedFilesToTargetHere: false"
$lockedLines += "CreatedTargetFolderHere: false"
$lockedLines += "DoctrinePromotionAuthorized: false"
$lockedLines | Set-Content -LiteralPath $LockedTerms -Encoding UTF8

$packetLines = @()
$packetLines += "# COMMAND CENTER UI LANE LIVE INSTALL RUN AUTHORIZATION PACKET"
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
$packetLines += "# Built Script Evidence"
$packetLines += ""
$packetLines += ("BuildStatus: " + $buildStatus)
$packetLines += ("BuildNextLegalObject: " + $buildNextLegalObject)
$packetLines += ("BuiltScript: " + $builtScript)
$packetLines += ("BuiltScriptSHA256: " + $builtScriptSHA256)
$packetLines += ("CurrentBuiltScriptSHA256: " + $currentBuiltScriptHash)
$packetLines += ("SyntaxErrorCount: " + $syntaxErrorCount)
$packetLines += ("CurrentBuiltScriptSyntaxErrors: " + $currentBuiltScriptSyntaxErrors)
$packetLines += ("CopyPlanFileCount: " + $copyPlanFileCount)
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
$packetLines += "LiveInstallExecutedHere: false"
$packetLines += "CopiedFilesToTargetHere: false"
$packetLines += "CreatedTargetFolderHere: false"
$packetLines += "DoctrinePromotionAuthorized: false"
$packetLines += "CommitAuthorized: false"
$packetLines += "PushAuthorized: false"
$packetLines += "WatcherAuthorized: false"
$packetLines += "AutomationAuthorized: false"
$packetLines | Set-Content -LiteralPath $AuthorizationPacket -Encoding UTF8

$nextLines = @()
$nextLines += "# NEXT OBJECT CARD"
$nextLines += "## COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_RUN_V1"
$nextLines += ""
$nextLines += ("GeneratedUtc: " + (Get-UtcNow))
$nextLines += ("RunStamp: " + $RunStamp)
$nextLines += ("AuthorizationStatus: " + $authorizationStatus)
$nextLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$nextLines += ("BuiltScript: " + $builtScript)
$nextLines += ("BuiltScriptSHA256: " + $builtScriptSHA256)
$nextLines += ("SourceAuthorizationPacket: " + $AuthorizationPacket)
$nextLines += ("LockedTerms: " + $LockedTerms)
$nextLines += ""
$nextLines += "# Legal Meaning"
$nextLines += ""
if ($authorizationAccepted -eq "true") {
    $nextLines += "The next legal object may run the built live-install execution script using the exact run phrase."
}
else {
    $nextLines += "The next legal object is not allowed yet. Run authorization is pending or blocked."
}
$nextLines += ""
$nextLines += "# Still Not Executed Here"
$nextLines += ""
$nextLines += "LiveInstallExecutedHere: false"
$nextLines | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$pendingLines = @()
$pendingLines += "# PENDING CARD"
$pendingLines += "## COMMAND CENTER UI LANE LIVE INSTALL RUN AUTHORIZATION V1"
$pendingLines += ""
$pendingLines += ("GeneratedUtc: " + (Get-UtcNow))
$pendingLines += ("AuthorizationStatus: " + $authorizationStatus)
$pendingLines += ""
$pendingLines += "# Required Phrase"
$pendingLines += ""
$pendingLines += $RequiredPhrase
$pendingLines += ""
$pendingLines += "# Run Shape To Authorize Actual Live Install Execution"
$pendingLines += ""
$pendingLines += 'pwsh -NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '" -AuthorizeRunInstall -AuthorizationPhrase "' + $RequiredPhrase + '" -AuthorizedBy "Jonathon"'
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
    BuildStatus = $buildStatus
    BuiltScript = $builtScript
    BuiltScriptSHA256 = $builtScriptSHA256
    CurrentBuiltScriptSHA256 = $currentBuiltScriptHash
    CurrentBuiltScriptSyntaxErrors = $currentBuiltScriptSyntaxErrors
    CopyPlanManifestJson = $copyPlanManifestJson
    CopyPlanFileCount = $copyPlanFileCount
    AuthorizationPacket = $AuthorizationPacket
    LockedTerms = $LockedTerms
    NextObjectCard = $NextObjectCard
    PendingCard = $PendingCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
    LiveInstallExecutedHere = $false
    DoctrinePromotionAuthorized = $false
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentRunAuthStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE LIVE INSTALL RUN AUTHORIZATION STATUS"
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
$statusLines += ("BuildStatus: " + $buildStatus)
$statusLines += ("BuiltScript: " + $builtScript)
$statusLines += ("BuiltScriptSHA256: " + $builtScriptSHA256)
$statusLines += ("CurrentBuiltScriptSHA256: " + $currentBuiltScriptHash)
$statusLines += ("CurrentBuiltScriptSyntaxErrors: " + $currentBuiltScriptSyntaxErrors)
$statusLines += ("CopyPlanManifestJson: " + $copyPlanManifestJson)
$statusLines += ("CopyPlanFileCount: " + $copyPlanFileCount)
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
$statusLines += "LiveInstallExecutedHere: false"
$statusLines += "CopiedFilesToTargetHere: false"
$statusLines += "CreatedTargetFolderHere: false"
$statusLines += "DoctrinePromotionAuthorized: false"
$statusLines += "CommitAuthorized: false"
$statusLines += "PushAuthorized: false"
$statusLines += "WatcherAuthorized: false"
$statusLines += "AutomationAuthorized: false"
$statusLines | Set-Content -LiteralPath $CurrentRunAuthStatusMd -Encoding UTF8

$receiptLines = @()
$receiptLines += "# RECEIPT"
$receiptLines += "## COMMAND CENTER UI LANE LIVE INSTALL RUN AUTHORIZATION GATE V1"
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
$receiptLines += ("CurrentRunAuthStatus: " + $CurrentRunAuthStatusMd)
$receiptLines += ("CurrentRunAuthStatusJson: " + $CurrentRunAuthStatusJson)
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
$receiptLines += "LiveInstallExecutedHere: false"
$receiptLines += "CopiedFilesToTargetHere: false"
$receiptLines += "CreatedTargetFolderHere: false"
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
Write-Host "Command Center UI lane live-install run authorization gate complete."
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
Write-Host "BuiltScript:"
Write-Host $builtScript
Write-Host ""
Write-Host "Current run authorization status:"
Write-Host $CurrentRunAuthStatusMd
Write-Host ""
Write-Host "Authorization packet:"
Write-Host $AuthorizationPacket
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_LIVE_INSTALL_RUN_AUTHORIZATION_GATE_FINALIZED"

