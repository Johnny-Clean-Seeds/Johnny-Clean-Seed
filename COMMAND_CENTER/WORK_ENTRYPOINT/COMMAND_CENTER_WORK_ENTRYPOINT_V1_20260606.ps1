<#
SCRIPT NAME:
COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1

PURPOSE:
This is the normal file-facing way to start or prepare Command Center work.

It calls the Command Center pre-run gate adapter first. The adapter calls the tested-working
error-triggered helper harvest gate. Then this entrypoint reads the pre-run status and writes
a current work-entry status.

STATUS:
COMMAND_CENTER_WORK_ENTRYPOINT / START_OR_READY_GATE / NO_LIVE_INSTALL

THIS SCRIPT DOES:
- runs COMMAND_CENTER_PRE_RUN_GATE_ADAPTER__ERROR_TRIGGERED_HELPER_HARVEST_V1_20260606.ps1
- reads CURRENT_COMMAND_CENTER_PRE_RUN_GATE_STATUS.md/json
- writes CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md/json
- writes receipt
- tells the next file/action whether to proceed or pause into error harvest

THIS SCRIPT DOES NOT:
- run the selected main action by default
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

RULE:
This is the front file-facing entrypoint for getting files ready to process work.
Do not bypass it for helper/code actions unless an emergency repair explicitly says why.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [string]$WorkIntent = "READY_NEXT_COMMAND_CENTER_ACTION",

    [Parameter(Mandatory = $false)]
    [string]$SelectedLane = "COMMAND_CENTER_UI_LANE",

    [Parameter(Mandatory = $false)]
    [switch]$NoAdapterRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

$CommandCenterRoot = Join-Path $Root "COMMAND_CENTER"
$EntryRoot = Join-Path $CommandCenterRoot "WORK_ENTRYPOINT"
$PreRunRoot = Join-Path $CommandCenterRoot "PRE_RUN_GATES"
$ReceiptRoot = Join-Path $CommandCenterRoot "RECEIPTS\WORK_ENTRYPOINT"
$RunRoot = Join-Path $ReceiptRoot ("COMMAND_CENTER_WORK_ENTRYPOINT_" + $RunStamp)

$PreRunAdapter = Join-Path $PreRunRoot "COMMAND_CENTER_PRE_RUN_GATE_ADAPTER__ERROR_TRIGGERED_HELPER_HARVEST_V1_20260606.ps1"
$PreRunStatusMd = Join-Path $PreRunRoot "CURRENT_COMMAND_CENTER_PRE_RUN_GATE_STATUS.md"
$PreRunStatusJson = Join-Path $PreRunRoot "CURRENT_COMMAND_CENTER_PRE_RUN_GATE_STATUS.json"

$CurrentEntryStatusMd = Join-Path $EntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$CurrentEntryStatusJson = Join-Path $EntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.json"

$EntryOutput = Join-Path $RunRoot "OUTPUT__COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.txt"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.md"

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

function Get-TextFlag {
    param(
        [string]$Text,
        [string]$Name
    )

    $pattern = "(?im)^\s*" + [regex]::Escape($Name) + "\s*:\s*(.+?)\s*$"
    $m = [regex]::Match($Text, $pattern)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return "UNKNOWN"
}

New-Dir $CommandCenterRoot
New-Dir $EntryRoot
New-Dir $ReceiptRoot
New-Dir $RunRoot

$errors = @()
$actions = @()
$adapterStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"
$workEntryStatus = "WORK_ENTRY_BLOCKED"
$nextAction = "Review entrypoint error ledger."

try {
    if (-not (Test-Path -LiteralPath $PreRunAdapter)) {
        $errors += [pscustomobject]@{
            Category = "PRE_RUN_ADAPTER_MISSING"
            Phase = "PREFLIGHT"
            Message = $PreRunAdapter
            Resolution = "Write/install Command Center pre-run gate adapter before using work entrypoint."
        }
    }
    else {
        $actions += "FOUND_PRE_RUN_ADAPTER: $PreRunAdapter"

        if (-not $NoAdapterRun) {
            & $PreRunAdapter *>&1 | Tee-Object -FilePath $EntryOutput | Out-Host
            $actions += "RAN_PRE_RUN_ADAPTER: $PreRunAdapter"
        }
        else {
            $actions += "ADAPTER_RUN_SKIPPED_BY_FLAG"
        }
    }

    if (-not (Test-Path -LiteralPath $PreRunStatusMd)) {
        $errors += [pscustomobject]@{
            Category = "PRE_RUN_STATUS_MISSING"
            Phase = "READ_PRE_RUN_STATUS"
            Message = $PreRunStatusMd
            Resolution = "Run pre-run adapter before entrypoint can clear work."
        }
    }
    else {
        $statusText = Get-Content -LiteralPath $PreRunStatusMd -Raw -ErrorAction Stop
        $actions += "READ_PRE_RUN_STATUS: $PreRunStatusMd"

        $adapterStatus = Get-TextFlag -Text $statusText -Name "AdapterStatus"
        $openSideQuestRequired = Get-TextFlag -Text $statusText -Name "OpenSideQuestRequired"

        if ($adapterStatus -eq "PRE_RUN_CLEAR_READY_FOR_MAIN_ACTION" -and $openSideQuestRequired -eq "False") {
            $workEntryStatus = "WORK_ENTRY_READY_FOR_SELECTED_ACTION"
            $nextAction = "Proceed to selected Command Center action. Live install remains separately gated."
        }
        elseif ($adapterStatus -eq "PRE_RUN_BLOCKED_ERROR_HARVEST_REQUIRED" -or $openSideQuestRequired -eq "True") {
            $workEntryStatus = "WORK_ENTRY_PAUSED_ERROR_HARVEST_REQUIRED"
            $nextAction = "Pause selected work and route to error-triggered helper harvest."
        }
        else {
            $workEntryStatus = "WORK_ENTRY_BLOCKED_PRE_RUN_STATUS_UNKNOWN"
            $nextAction = "Do not run selected action. Review pre-run gate status and adapter error ledger."
            $errors += [pscustomobject]@{
                Category = "PRE_RUN_STATUS_NOT_CLEAR"
                Phase = "READ_PRE_RUN_STATUS"
                Message = "AdapterStatus=$adapterStatus; OpenSideQuestRequired=$openSideQuestRequired"
                Resolution = "Review CURRENT_COMMAND_CENTER_PRE_RUN_GATE_STATUS.md."
            }
        }
    }
}
catch {
    $workEntryStatus = "WORK_ENTRY_EXCEPTION"
    $nextAction = "Do not run selected action. Review entrypoint error ledger."
    $errors += [pscustomobject]@{
        Category = "WORK_ENTRYPOINT_EXCEPTION"
        Phase = "TOP_LEVEL"
        Message = $_.Exception.Message
        Resolution = "Review entrypoint error ledger."
    }
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER WORK ENTRYPOINT V1"
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
$errorLines += "This entrypoint error ledger does not approve live install or doctrine promotion."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    WorkEntryStatus = $workEntryStatus
    WorkIntent = $WorkIntent
    SelectedLane = $SelectedLane
    AdapterStatus = $adapterStatus
    OpenSideQuestRequired = $openSideQuestRequired
    NextAction = $nextAction
    PreRunAdapter = $PreRunAdapter
    PreRunStatusMd = $PreRunStatusMd
    PreRunStatusJson = $PreRunStatusJson
    CurrentEntryStatusMd = $CurrentEntryStatusMd
    CurrentEntryStatusJson = $CurrentEntryStatusJson
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentEntryStatusJson -Encoding UTF8

$statusMd = @()
$statusMd += "# CURRENT COMMAND CENTER WORK ENTRY STATUS"
$statusMd += ""
$statusMd += "GeneratedUtc: $($statusObj.GeneratedUtc)"
$statusMd += "RunStamp: $RunStamp"
$statusMd += "WorkEntryStatus: $workEntryStatus"
$statusMd += "WorkIntent: $WorkIntent"
$statusMd += "SelectedLane: $SelectedLane"
$statusMd += "AdapterStatus: $adapterStatus"
$statusMd += "OpenSideQuestRequired: $openSideQuestRequired"
$statusMd += "ErrorCount: $(@($errors).Count)"
$statusMd += ""
$statusMd += "# Next Action"
$statusMd += ""
$statusMd += $nextAction
$statusMd += ""
$statusMd += "# Required Files"
$statusMd += ""
$statusMd += "PreRunAdapter: $PreRunAdapter"
$statusMd += "PreRunStatusMd: $PreRunStatusMd"
$statusMd += "PreRunStatusJson: $PreRunStatusJson"
$statusMd += "CurrentEntryStatusJson: $CurrentEntryStatusJson"
$statusMd += "Receipt: $Receipt"
$statusMd += "ErrorLedger: $ErrorLedger"
$statusMd += ""
$statusMd += "# Rule"
$statusMd += ""
$statusMd += "This is the normal file-facing way to get ready for Command Center work."
$statusMd += "It calls the pre-run gate adapter first."
$statusMd += "If clear, selected work may continue under its own separate gate."
$statusMd += "If blocked, selected work pauses and error harvest takes over."
$statusMd += ""
$statusMd += "# Boundary"
$statusMd += ""
$statusMd += "This status does not run or approve live install."
$statusMd += "This status does not promote doctrine."
$statusMd += "This status does not authorize cleanup, deletion, archive, dedupe, commit, push, watcher, automation, or live mutation."
$statusMd | Set-Content -LiteralPath $CurrentEntryStatusMd -Encoding UTF8

$receiptText = @"
# RECEIPT
## COMMAND CENTER WORK ENTRYPOINT V1

GeneratedUtc: $(Get-UtcNow)
RunStamp: $RunStamp

WorkEntryStatus:
$workEntryStatus

WorkIntent:
$WorkIntent

SelectedLane:
$SelectedLane

AdapterStatus:
$adapterStatus

OpenSideQuestRequired:
$openSideQuestRequired

CurrentEntryStatusMd:
$CurrentEntryStatusMd

CurrentEntryStatusJson:
$CurrentEntryStatusJson

PreRunAdapter:
$PreRunAdapter

PreRunStatusMd:
$PreRunStatusMd

EntryOutput:
$EntryOutput

ErrorLedger:
$ErrorLedger

ErrorCount:
$(@($errors).Count)

Actions:
$($actions -join "`n")

NoMutationFlags:
RanSelectedMainAction: false
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
Write-Host "Command Center work entrypoint complete."
Write-Host "WorkEntryStatus:"
Write-Host $workEntryStatus
Write-Host ""
Write-Host "AdapterStatus:"
Write-Host $adapterStatus
Write-Host ""
Write-Host "OpenSideQuestRequired:"
Write-Host $openSideQuestRequired
Write-Host ""
Write-Host "Current work entry status:"
Write-Host $CurrentEntryStatusMd
Write-Host ""
Write-Host "Receipt:"
Write-Host $Receipt
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_WORK_ENTRYPOINT_FINALIZED"

