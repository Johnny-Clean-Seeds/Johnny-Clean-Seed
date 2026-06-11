<#
SCRIPT NAME:
COMMAND_CENTER_PRE_RUN_GATE_ADAPTER__ERROR_TRIGGERED_HELPER_HARVEST_V1_20260606.ps1

PURPOSE:
Make Command Center call the tested-working error-triggered helper harvest gate
before future helper/code actions.

This is the file-facing adapter so the human does not have to remember the raw gate command.

STATUS:
COMMAND_CENTER_PRE_RUN_GATE / ADAPTER / CALLS_TESTED_WORKING_HELPER / NO_LIVE_INSTALL

THIS SCRIPT DOES:
- runs the tested-working harvest gate with -SkipPriorV1ErrorLedger
- reads CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT.md
- writes CURRENT_COMMAND_CENTER_PRE_RUN_GATE_STATUS.md/json
- writes a pre-run receipt
- tells the next file/action whether to proceed or pause into error harvest

THIS SCRIPT DOES NOT:
- run the target main action
- promote tools
- live install Command Center
- promote doctrine
- delete project files
- archive project files
- dedupe project files
- commit
- push
- create watcher
- create automation
- open VS Code
- close VS Code
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

$ToolRoot = Join-Path $Root "_TOOLS_AND_SCRIPTS\HELPER_TOOL_CODES"
$CommandCenterRoot = Join-Path $Root "COMMAND_CENTER"
$PreRunRoot = Join-Path $CommandCenterRoot "PRE_RUN_GATES"
$ReceiptRoot = Join-Path $CommandCenterRoot "RECEIPTS\PRE_RUN_GATES"
$RunRoot = Join-Path $ReceiptRoot ("COMMAND_CENTER_PRE_RUN_GATE_" + $RunStamp)

$GateScript = Join-Path $ToolRoot "02_TESTED_WORKING_TOOLS\ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_20260606\ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_20260606.ps1"
$HarvestContext = Join-Path $ToolRoot "00_TOOL_INDEX\CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT.md"
$HarvestContextJson = Join-Path $ToolRoot "00_TOOL_INDEX\CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT.json"

$CurrentStatusMd = Join-Path $PreRunRoot "CURRENT_COMMAND_CENTER_PRE_RUN_GATE_STATUS.md"
$CurrentStatusJson = Join-Path $PreRunRoot "CURRENT_COMMAND_CENTER_PRE_RUN_GATE_STATUS.json"
$GateOutput = Join-Path $RunRoot "GATE_OUTPUT__COMMAND_CENTER_PRE_RUN_GATE.txt"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_PRE_RUN_GATE_ADAPTER__ERROR_TRIGGERED_HELPER_HARVEST_V1.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_PRE_RUN_GATE_ADAPTER__ERROR_TRIGGERED_HELPER_HARVEST_V1.md"

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

function Get-Flag {
    param(
        [string]$Text,
        [string]$Name
    )

    $pattern = "(?im)^\s*" + [regex]::Escape($Name) + "\s*:\s*(True|False)\s*$"
    $m = [regex]::Match($Text, $pattern)
    if ($m.Success) { return $m.Groups[1].Value }
    return "UNKNOWN"
}

New-Dir $PreRunRoot
New-Dir $ReceiptRoot
New-Dir $RunRoot

$errors = @()
$actions = @()
$openFlag = "UNKNOWN"
$adapterStatus = "COMMAND_CENTER_PRE_RUN_GATE_BLOCKED"
$harvestStatus = "UNKNOWN"

try {
    if (-not (Test-Path -LiteralPath $GateScript)) {
        $errors += [pscustomobject]@{
            Category = "TESTED_WORKING_GATE_MISSING"
            Phase = "PREFLIGHT"
            Message = $GateScript
            Resolution = "Promote ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1 to tested-working before using Command Center pre-run adapter."
        }
    }
    else {
        $actions += "FOUND_TESTED_WORKING_GATE: $GateScript"

        & $GateScript -SkipPriorV1ErrorLedger *>&1 | Tee-Object -FilePath $GateOutput | Out-Host
        $actions += "RAN_TESTED_WORKING_GATE_WITH_SKIP_PRIOR_V1_ERROR_LEDGER"
    }

    if (-not (Test-Path -LiteralPath $HarvestContext)) {
        $errors += [pscustomobject]@{
            Category = "HARVEST_CONTEXT_MISSING"
            Phase = "READ_CONTEXT"
            Message = $HarvestContext
            Resolution = "Run the tested-working harvest gate before proceeding."
        }
    }
    else {
        $contextText = Get-Content -LiteralPath $HarvestContext -Raw -ErrorAction Stop
        $actions += "READ_HARVEST_CONTEXT: $HarvestContext"
        $openFlag = Get-Flag -Text $contextText -Name "OpenSideQuestRequired"

        if ($contextText -match "(?im)^\s*Status\s*:\s*(.+?)\s*$") {
            $harvestStatus = $matches[1].Trim()
        }

        if ($openFlag -eq "False") {
            $adapterStatus = "PRE_RUN_CLEAR_READY_FOR_MAIN_ACTION"
        }
        elseif ($openFlag -eq "True") {
            $adapterStatus = "PRE_RUN_BLOCKED_ERROR_HARVEST_REQUIRED"
        }
        else {
            $adapterStatus = "PRE_RUN_BLOCKED_CONTEXT_FLAG_UNKNOWN"
            $errors += [pscustomobject]@{
                Category = "HARVEST_CONTEXT_FLAG_UNKNOWN"
                Phase = "READ_CONTEXT"
                Message = "Could not read OpenSideQuestRequired flag from context."
                Resolution = "Review CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT.md."
            }
        }
    }
}
catch {
    $adapterStatus = "COMMAND_CENTER_PRE_RUN_GATE_EXCEPTION"
    $errors += [pscustomobject]@{
        Category = "PRE_RUN_GATE_ADAPTER_EXCEPTION"
        Phase = "TOP_LEVEL"
        Message = $_.Exception.Message
        Resolution = "Review adapter error ledger. Do not run main action until gate is clear."
    }
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER PRE-RUN GATE ADAPTER"
$errorLines += ""
$errorLines += "GeneratedUtc: $(Get-UtcNow)"
$errorLines += "ErrorCount: $(@($errors).Count)"
$errorLines += ""
$errorLines += "| Category | Phase | Message | Resolution |"
$errorLines += "|---|---|---|---|"
foreach ($e in $errors) {
    $errorLines += "| $(Escape-Md $e.Category) | $(Escape-Md $e.Phase) | $(Escape-Md $e.Message) | $(Escape-Md $e.Resolution) |"
}
$errorLines += ""
$errorLines += "DoesNotProve:"
$errorLines += "This adapter error ledger does not approve live install or doctrine promotion."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    AdapterStatus = $adapterStatus
    OpenSideQuestRequired = $openFlag
    HarvestStatus = $harvestStatus
    GateScript = $GateScript
    HarvestContext = $HarvestContext
    HarvestContextJson = $HarvestContextJson
    GateOutput = $GateOutput
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
    NextAction = if ($adapterStatus -eq "PRE_RUN_CLEAR_READY_FOR_MAIN_ACTION") {
        "Continue main Command Center action."
    }
    elseif ($adapterStatus -eq "PRE_RUN_BLOCKED_ERROR_HARVEST_REQUIRED") {
        "Pause main quest and route to error-triggered helper harvest."
    }
    else {
        "Do not run main action. Review adapter/gate error ledger."
    }
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentStatusJson -Encoding UTF8

$statusMd = @()
$statusMd += "# CURRENT COMMAND CENTER PRE-RUN GATE STATUS"
$statusMd += ""
$statusMd += "GeneratedUtc: $($statusObj.GeneratedUtc)"
$statusMd += "RunStamp: $RunStamp"
$statusMd += "AdapterStatus: $adapterStatus"
$statusMd += "OpenSideQuestRequired: $openFlag"
$statusMd += "HarvestStatus: $harvestStatus"
$statusMd += "ErrorCount: $(@($errors).Count)"
$statusMd += ""
$statusMd += "# Next Action"
$statusMd += ""
$statusMd += $statusObj.NextAction
$statusMd += ""
$statusMd += "# Files"
$statusMd += ""
$statusMd += "GateScript: $GateScript"
$statusMd += "HarvestContext: $HarvestContext"
$statusMd += "HarvestContextJson: $HarvestContextJson"
$statusMd += "GateOutput: $GateOutput"
$statusMd += "Receipt: $Receipt"
$statusMd += "ErrorLedger: $ErrorLedger"
$statusMd += ""
$statusMd += "# Rule"
$statusMd += ""
$statusMd += "Before future helper/code actions, Command Center calls the tested-working harvest gate."
$statusMd += "If OpenSideQuestRequired is True, the main action pauses and error harvest takes over."
$statusMd += "If OpenSideQuestRequired is False, the main action may continue."
$statusMd += ""
$statusMd += "# DoesNotProve"
$statusMd += ""
$statusMd += "This status does not approve live install."
$statusMd += "This status does not promote doctrine."
$statusMd += "This status does not authorize cleanup, deletion, archive, dedupe, commit, push, watcher, automation, or live mutation."
$statusMd | Set-Content -LiteralPath $CurrentStatusMd -Encoding UTF8

$receiptText = @"
# RECEIPT
## COMMAND CENTER PRE-RUN GATE ADAPTER

GeneratedUtc: $(Get-UtcNow)
RunStamp: $RunStamp

AdapterStatus:
$adapterStatus

OpenSideQuestRequired:
$openFlag

HarvestStatus:
$harvestStatus

CurrentStatusMd:
$CurrentStatusMd

CurrentStatusJson:
$CurrentStatusJson

GateScript:
$GateScript

HarvestContext:
$HarvestContext

GateOutput:
$GateOutput

ErrorLedger:
$ErrorLedger

ErrorCount:
$(@($errors).Count)

Actions:
$($actions -join "`n")

NoMutationFlags:
RanTargetMainAction: false
PromotedTool: false
OpenedVSCode: false
ClosedVSCode: false
DeletedProjectWork: false
ArchivedProjectWork: false
DedupedProjectWork: false
LiveCommandCenterInstall: false
DoctrinePromoted: false
Committed: false
Pushed: false
WatcherInstalled: false
AutomationInstalled: false

DoesNotProve:
This receipt does not approve live install.
This receipt does not promote doctrine.
This receipt does not authorize cleanup.
"@
$receiptText | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host ""
Write-Host "Command Center pre-run gate adapter complete."
Write-Host "AdapterStatus:"
Write-Host $adapterStatus
Write-Host ""
Write-Host "OpenSideQuestRequired:"
Write-Host $openFlag
Write-Host ""
Write-Host "Current status:"
Write-Host $CurrentStatusMd
Write-Host ""
Write-Host "Receipt:"
Write-Host $Receipt
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_PRE_RUN_GATE_ADAPTER_FINALIZED"

