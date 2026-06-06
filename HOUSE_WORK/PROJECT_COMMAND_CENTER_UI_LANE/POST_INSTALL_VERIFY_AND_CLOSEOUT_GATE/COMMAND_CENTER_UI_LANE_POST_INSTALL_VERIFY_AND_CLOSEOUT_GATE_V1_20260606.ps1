<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE_V1_20260606.ps1

PURPOSE:
Verify the completed Command Center UI lane live install and write closeout status.

THIS IS POST-INSTALL VERIFY ONLY.

THIS SCRIPT DOES:
- run/read Command Center work entrypoint
- locate the latest live-install execution receipt
- require LIVE_INSTALL_EXECUTION_COMPLETE
- require ExecuteInstall True
- require CopiedCount == expected copy plan file count
- require VerifiedCount == expected copy plan file count
- require ErrorCount == 0
- read current execution plan copy manifest
- verify target files still exist
- verify target hashes still match expected hashes
- write installed status, closeout packet, target-after hash ledger, receipt, and error ledger

THIS SCRIPT DOES NOT:
- copy files
- delete files
- archive files
- dedupe files
- promote doctrine
- install watcher
- install automation
- commit
- push
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
$PlanGateRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_EXECUTION_PLAN_GATE"
$ExecutionRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_EXECUTION"
$CloseoutRoot = Join-Path $UiLaneRoot "POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE"
$RunRoot = Join-Path $CloseoutRoot ("COMMAND_CENTER_UI_LANE_POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE_V1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$PlanStatusMd = Join-Path $PlanGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_STATUS.md"

$CurrentInstalledStatusMd = Join-Path $CloseoutRoot "CURRENT_COMMAND_CENTER_UI_LANE_INSTALLED_STATUS.md"
$CurrentInstalledStatusJson = Join-Path $CloseoutRoot "CURRENT_COMMAND_CENTER_UI_LANE_INSTALLED_STATUS.json"

$CloseoutPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_POST_INSTALL_VERIFY_AND_CLOSEOUT_PACKET_V1_20260606.md"
$TargetAfterHashLedger = Join-Path $RunRoot "HASH_LEDGER_TARGET_AFTER_CLOSEOUT__COMMAND_CENTER_UI_LANE_V1_20260606.md"
$TargetVerificationLedger = Join-Path $RunRoot "TARGET_VERIFICATION_LEDGER__COMMAND_CENTER_UI_LANE_V1_20260606.md"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE_V1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_POST_INSTALL_CLOSEOUT_GATE.txt"

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

function Add-CloseoutError {
    param([string]$Category, [string]$Phase, [string]$Message, [string]$Resolution = "")

    $script:errors += [pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
    }
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

function Find-LatestExecutionReceipt {
    param([string]$BasePath)

    if (-not (Test-Path -LiteralPath $BasePath)) {
        return $null
    }

    $items = Get-ChildItem -LiteralPath $BasePath -File -Recurse -Force -Filter "RECEIPT__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_V1_20260606.md" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending

    if (@($items).Count -lt 1) {
        return $null
    }

    return $items[0].FullName
}

New-Dir $UiLaneRoot
New-Dir $CloseoutRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"

$planStatus = "UNKNOWN"
$copyPlanManifestJson = "UNKNOWN"
$plannedCopyCount = "UNKNOWN"
$proposedTargetRoot = "UNKNOWN"

$latestExecutionReceipt = "UNKNOWN"
$executionStatus = "UNKNOWN"
$executeInstall = "UNKNOWN"
$copiedCount = "UNKNOWN"
$verifiedCount = "UNKNOWN"
$executionErrorCount = "UNKNOWN"
$executionReportTargetRoot = "UNKNOWN"

$actualTargetFileCount = 0
$manifestTargetFileCount = 0
$missingTargetCount = 0
$hashMismatchCount = 0
$extraTargetFileCount = 0
$verifiedTargetCount = 0
$closeoutStatus = "POST_INSTALL_VERIFY_BLOCKED"
$nextLegalObject = "FIX_POST_INSTALL_VERIFY_BLOCKERS"

$targetRows = @()
$verifyRows = @()

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-CloseoutError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Work entrypoint required before closeout."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_POST_INSTALL_CLOSEOUT_GATE: " + $WorkEntryScript)
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-CloseoutError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint before closeout."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"
        $actions += ("READ_WORK_ENTRY_STATUS: " + $WorkEntryStatusMd)

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-CloseoutError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Resolve work entry/pre-run block first."
        }

        if ($openSideQuestRequired -ne "False") {
            Add-CloseoutError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error-triggered helper harvest first."
        }
    }

    if (-not (Test-Path -LiteralPath $PlanStatusMd)) {
        Add-CloseoutError -Category "PLAN_STATUS_MISSING" -Phase "READ_PLAN" -Message $PlanStatusMd -Resolution "Execution plan status required for target verification."
    }
    else {
        $planText = Get-Content -LiteralPath $PlanStatusMd -Raw -ErrorAction Stop
        $planStatus = Get-InlineValue -Text $planText -Name "PlanStatus"
        $copyPlanManifestJson = Get-InlineValue -Text $planText -Name "CopyPlanManifestJson"
        $plannedCopyCount = Get-InlineValue -Text $planText -Name "CopyPlanFileCount"
        $proposedTargetRoot = Get-InlineValue -Text $planText -Name "ProposedTargetRoot"
        $actions += ("READ_EXECUTION_PLAN_STATUS: " + $PlanStatusMd)

        if ($planStatus -ne "LIVE_INSTALL_EXECUTION_PLAN_READY_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION_GATE") {
            Add-CloseoutError -Category "PLAN_STATUS_NOT_READY" -Phase "READ_PLAN" -Message ("PlanStatus=" + $planStatus) -Resolution "Review execution plan before closeout."
        }

        if ($copyPlanManifestJson -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $copyPlanManifestJson)) {
            Add-CloseoutError -Category "COPY_PLAN_MANIFEST_JSON_MISSING" -Phase "READ_PLAN" -Message ("CopyPlanManifestJson=" + $copyPlanManifestJson) -Resolution "Regenerate execution plan."
        }

        if ($proposedTargetRoot -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $proposedTargetRoot)) {
            Add-CloseoutError -Category "TARGET_ROOT_MISSING_AFTER_INSTALL" -Phase "READ_PLAN" -Message ("ProposedTargetRoot=" + $proposedTargetRoot) -Resolution "Live install did not create target root or target was moved."
        }
    }

    $receiptPath = Find-LatestExecutionReceipt -BasePath $ExecutionRoot
    if ($null -eq $receiptPath) {
        Add-CloseoutError -Category "LIVE_INSTALL_EXECUTION_RECEIPT_MISSING" -Phase "READ_EXECUTION_RECEIPT" -Message $ExecutionRoot -Resolution "Run live install execution before closeout."
    }
    else {
        $latestExecutionReceipt = $receiptPath
        $receiptText = Get-Content -LiteralPath $latestExecutionReceipt -Raw -ErrorAction Stop
        $executionStatus = Get-InlineValue -Text $receiptText -Name "ExecutionStatus"
        $executeInstall = Get-InlineValue -Text $receiptText -Name "ExecuteInstall"
        $copiedCount = Get-InlineValue -Text $receiptText -Name "CopiedCount"
        $verifiedCount = Get-InlineValue -Text $receiptText -Name "VerifiedCount"
        $executionErrorCount = Get-InlineValue -Text $receiptText -Name "ErrorCount"
        $executionReportTargetRoot = Get-InlineValue -Text $receiptText -Name "ProposedTargetRoot"
        $actions += ("READ_LATEST_LIVE_INSTALL_EXECUTION_RECEIPT: " + $latestExecutionReceipt)

        if ($executionStatus -ne "LIVE_INSTALL_EXECUTION_COMPLETE") {
            Add-CloseoutError -Category "LIVE_INSTALL_NOT_COMPLETE" -Phase "READ_EXECUTION_RECEIPT" -Message ("ExecutionStatus=" + $executionStatus) -Resolution "Do not close out incomplete install."
        }

        if ($executeInstall -ne "True") {
            Add-CloseoutError -Category "EXECUTE_INSTALL_NOT_TRUE" -Phase "READ_EXECUTION_RECEIPT" -Message ("ExecuteInstall=" + $executeInstall) -Resolution "Receipt must prove actual execution, not dry run."
        }

        if ($executionErrorCount -ne "0") {
            Add-CloseoutError -Category "LIVE_INSTALL_EXECUTION_ERROR_COUNT_NOT_ZERO" -Phase "READ_EXECUTION_RECEIPT" -Message ("ErrorCount=" + $executionErrorCount) -Resolution "Review execution errors before closeout."
        }
    }

    $manifestRows = @()
    if ($copyPlanManifestJson -ne "UNKNOWN" -and (Test-Path -LiteralPath $copyPlanManifestJson)) {
        $manifestRows = @(Get-Content -LiteralPath $copyPlanManifestJson -Raw -ErrorAction Stop | ConvertFrom-Json)
        $manifestTargetFileCount = @($manifestRows).Count
        $actions += ("READ_COPY_PLAN_MANIFEST_JSON: " + $copyPlanManifestJson)

        if ([string]$manifestTargetFileCount -ne [string]$plannedCopyCount) {
            Add-CloseoutError -Category "MANIFEST_COUNT_DIFFERS_FROM_PLAN_STATUS" -Phase "VERIFY_MANIFEST" -Message ("ManifestCount=" + $manifestTargetFileCount + " PlannedCopyCount=" + $plannedCopyCount) -Resolution "Review plan/current status mismatch."
        }

        if ([string]$copiedCount -ne [string]$manifestTargetFileCount) {
            Add-CloseoutError -Category "COPIED_COUNT_DIFFERS_FROM_MANIFEST" -Phase "VERIFY_EXECUTION_COUNTS" -Message ("CopiedCount=" + $copiedCount + " ManifestCount=" + $manifestTargetFileCount) -Resolution "Review install execution receipt."
        }

        if ([string]$verifiedCount -ne [string]$manifestTargetFileCount) {
            Add-CloseoutError -Category "VERIFIED_COUNT_DIFFERS_FROM_MANIFEST" -Phase "VERIFY_EXECUTION_COUNTS" -Message ("VerifiedCount=" + $verifiedCount + " ManifestCount=" + $manifestTargetFileCount) -Resolution "Review install execution receipt."
        }

        foreach ($row in $manifestRows) {
            $rel = [string]$row.RelativePath
            $targetPath = [string]$row.ProposedTargetPath
            $expectedHash = [string]$row.ExpectedSHA256
            $exists = Test-Path -LiteralPath $targetPath
            $actualHash = "MISSING"
            $sizeBytes = ""
            $verdict = "MISSING"

            if (-not $exists) {
                $missingTargetCount += 1
            }
            else {
                $item = Get-Item -LiteralPath $targetPath -ErrorAction Stop
                $sizeBytes = $item.Length
                $actualHash = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash
                if ($actualHash -eq $expectedHash) {
                    $verifiedTargetCount += 1
                    $verdict = "PASS"
                }
                else {
                    $hashMismatchCount += 1
                    $verdict = "HASH_MISMATCH"
                }
            }

            $verifyRows += [pscustomobject]@{
                RelativePath = $rel
                TargetPath = $targetPath
                ExpectedSHA256 = $expectedHash
                ActualSHA256 = $actualHash
                SizeBytes = $sizeBytes
                Exists = $exists
                Verdict = $verdict
            }
        }
    }

    if ($proposedTargetRoot -ne "UNKNOWN" -and (Test-Path -LiteralPath $proposedTargetRoot)) {
        $targetFiles = @(Get-ChildItem -LiteralPath $proposedTargetRoot -File -Recurse -Force -ErrorAction Stop)
        $actualTargetFileCount = @($targetFiles).Count

        foreach ($f in $targetFiles) {
            $rel = Get-RelPath -BasePath $proposedTargetRoot -FullPath $f.FullName
            $hash = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash
            $targetRows += [pscustomobject]@{
                RelativePath = $rel
                FullPath = $f.FullName
                SizeBytes = $f.Length
                SHA256 = $hash
            }
        }

        $manifestRelSet = @{}
        foreach ($vr in $verifyRows) {
            $manifestRelSet[[string]$vr.RelativePath] = $true
        }

        foreach ($tr in $targetRows) {
            if (-not $manifestRelSet.ContainsKey([string]$tr.RelativePath)) {
                $extraTargetFileCount += 1
            }
        }
    }

    if ($missingTargetCount -ne 0) {
        Add-CloseoutError -Category "TARGET_FILES_MISSING_AFTER_INSTALL" -Phase "VERIFY_TARGET" -Message ("MissingTargetCount=" + $missingTargetCount) -Resolution "Investigate target root; install not closed."
    }

    if ($hashMismatchCount -ne 0) {
        Add-CloseoutError -Category "TARGET_HASH_MISMATCH_AFTER_INSTALL" -Phase "VERIFY_TARGET" -Message ("HashMismatchCount=" + $hashMismatchCount) -Resolution "Investigate target hashes; install not closed."
    }

    if ($extraTargetFileCount -ne 0) {
        Add-CloseoutError -Category "TARGET_HAS_EXTRA_FILES" -Phase "VERIFY_TARGET" -Message ("ExtraTargetFileCount=" + $extraTargetFileCount) -Resolution "Review target folder before closeout. Extra files are not automatically deleted."
    }

    if ([string]$verifiedTargetCount -ne [string]$manifestTargetFileCount) {
        Add-CloseoutError -Category "VERIFIED_TARGET_COUNT_DIFFERS_FROM_MANIFEST" -Phase "VERIFY_TARGET" -Message ("VerifiedTargetCount=" + $verifiedTargetCount + " ManifestCount=" + $manifestTargetFileCount) -Resolution "Closeout requires every manifest file to verify."
    }
}
catch {
    Add-CloseoutError -Category "POST_INSTALL_CLOSEOUT_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review closeout error ledger."
}

if (@($errors).Count -eq 0) {
    $closeoutStatus = "POST_INSTALL_VERIFY_AND_CLOSEOUT_COMPLETE"
    $nextLegalObject = "COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1"
}
else {
    $closeoutStatus = "POST_INSTALL_VERIFY_AND_CLOSEOUT_BLOCKED"
    $nextLegalObject = "FIX_POST_INSTALL_VERIFY_AND_CLOSEOUT_BLOCKERS"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE POST INSTALL VERIFY AND CLOSEOUT GATE V1"
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
$errorLines += "This error ledger does not authorize commit, push, cleanup, doctrine promotion, watcher, or automation."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$verifyLines = @()
$verifyLines += "# TARGET VERIFICATION LEDGER"
$verifyLines += "## COMMAND CENTER UI LANE V1"
$verifyLines += ""
$verifyLines += ("GeneratedUtc: " + (Get-UtcNow))
$verifyLines += ("ManifestTargetFileCount: " + $manifestTargetFileCount)
$verifyLines += ("VerifiedTargetCount: " + $verifiedTargetCount)
$verifyLines += ("MissingTargetCount: " + $missingTargetCount)
$verifyLines += ("HashMismatchCount: " + $hashMismatchCount)
$verifyLines += ""
$verifyLines += "| RelativePath | Exists | Verdict | ExpectedSHA256 | ActualSHA256 | SizeBytes | TargetPath |"
$verifyLines += "|---|---|---|---|---|---:|---|"
foreach ($r in $verifyRows) {
    $verifyLines += ("| " + (Escape-Md $r.RelativePath) + " | " + $r.Exists + " | " + (Escape-Md $r.Verdict) + " | " + $r.ExpectedSHA256 + " | " + $r.ActualSHA256 + " | " + $r.SizeBytes + " | " + (Escape-Md $r.TargetPath) + " |")
}
$verifyLines | Set-Content -LiteralPath $TargetVerificationLedger -Encoding UTF8

$hashLines = @()
$hashLines += "# TARGET AFTER CLOSEOUT HASH LEDGER"
$hashLines += "## COMMAND CENTER UI LANE V1"
$hashLines += ""
$hashLines += ("GeneratedUtc: " + (Get-UtcNow))
$hashLines += ("TargetRoot: " + $proposedTargetRoot)
$hashLines += ("ActualTargetFileCount: " + $actualTargetFileCount)
$hashLines += ""
$hashLines += "| RelativePath | SizeBytes | SHA256 | FullPath |"
$hashLines += "|---|---:|---|---|"
foreach ($r in $targetRows) {
    $hashLines += ("| " + (Escape-Md $r.RelativePath) + " | " + $r.SizeBytes + " | " + $r.SHA256 + " | " + (Escape-Md $r.FullPath) + " |")
}
$hashLines | Set-Content -LiteralPath $TargetAfterHashLedger -Encoding UTF8

$packetLines = @()
$packetLines += "# COMMAND CENTER UI LANE POST INSTALL VERIFY AND CLOSEOUT PACKET"
$packetLines += "## V1"
$packetLines += ""
$packetLines += ("GeneratedUtc: " + (Get-UtcNow))
$packetLines += ("RunStamp: " + $RunStamp)
$packetLines += ("CloseoutStatus: " + $closeoutStatus)
$packetLines += ("NextLegalObject: " + $nextLegalObject)
$packetLines += ("ErrorCount: " + @($errors).Count)
$packetLines += ""
$packetLines += "# Execution Receipt"
$packetLines += ""
$packetLines += ("LatestExecutionReceipt: " + $latestExecutionReceipt)
$packetLines += ("ExecutionStatus: " + $executionStatus)
$packetLines += ("ExecuteInstall: " + $executeInstall)
$packetLines += ("CopiedCount: " + $copiedCount)
$packetLines += ("VerifiedCount: " + $verifiedCount)
$packetLines += ("ExecutionErrorCount: " + $executionErrorCount)
$packetLines += ""
$packetLines += "# Target Verification"
$packetLines += ""
$packetLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$packetLines += ("ManifestTargetFileCount: " + $manifestTargetFileCount)
$packetLines += ("ActualTargetFileCount: " + $actualTargetFileCount)
$packetLines += ("VerifiedTargetCount: " + $verifiedTargetCount)
$packetLines += ("MissingTargetCount: " + $missingTargetCount)
$packetLines += ("HashMismatchCount: " + $hashMismatchCount)
$packetLines += ("ExtraTargetFileCount: " + $extraTargetFileCount)
$packetLines += ""
$packetLines += "# Files Written"
$packetLines += ""
$packetLines += ("TargetVerificationLedger: " + $TargetVerificationLedger)
$packetLines += ("TargetAfterHashLedger: " + $TargetAfterHashLedger)
$packetLines += ("NextObjectCard: " + $NextObjectCard)
$packetLines += ("Receipt: " + $Receipt)
$packetLines += ("ErrorLedger: " + $ErrorLedger)
$packetLines += ""
$packetLines += "# Boundary"
$packetLines += ""
$packetLines += "CopiedFilesHere: false"
$packetLines += "DeletedFilesHere: false"
$packetLines += "ArchivedFilesHere: false"
$packetLines += "DedupedFilesHere: false"
$packetLines += "DoctrinePromotedHere: false"
$packetLines += "CommittedHere: false"
$packetLines += "PushedHere: false"
$packetLines += "WatcherInstalledHere: false"
$packetLines += "AutomationInstalledHere: false"
$packetLines | Set-Content -LiteralPath $CloseoutPacket -Encoding UTF8

$nextLines = @()
$nextLines += "# NEXT OBJECT CARD"
$nextLines += "## COMMAND_CENTER_UI_LANE_SAVE_AND_COMMIT_GATE_V1"
$nextLines += ""
$nextLines += ("GeneratedUtc: " + (Get-UtcNow))
$nextLines += ("CloseoutStatus: " + $closeoutStatus)
$nextLines += ("SourceCloseoutPacket: " + $CloseoutPacket)
$nextLines += ("InstalledStatus: " + $CurrentInstalledStatusMd)
$nextLines += ""
$nextLines += "# Legal Meaning"
$nextLines += ""
if ($closeoutStatus -eq "POST_INSTALL_VERIFY_AND_CLOSEOUT_COMPLETE") {
    $nextLines += "The next legal object may prepare a save/commit gate."
}
else {
    $nextLines += "Save/commit is not legal until closeout blockers are fixed."
}
$nextLines += ""
$nextLines += "# Still Not Authorized Here"
$nextLines += ""
$nextLines += "CommittedHere: false"
$nextLines += "PushedHere: false"
$nextLines += "CleanupHere: false"
$nextLines += "DoctrinePromotedHere: false"
$nextLines | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    CloseoutStatus = $closeoutStatus
    NextLegalObject = $nextLegalObject
    WorkEntryStatus = $workEntryStatus
    OpenSideQuestRequired = $openSideQuestRequired
    LatestExecutionReceipt = $latestExecutionReceipt
    ExecutionStatus = $executionStatus
    ExecuteInstall = $executeInstall
    CopiedCount = $copiedCount
    VerifiedCount = $verifiedCount
    ExecutionErrorCount = $executionErrorCount
    ProposedTargetRoot = $proposedTargetRoot
    CopyPlanManifestJson = $copyPlanManifestJson
    ManifestTargetFileCount = $manifestTargetFileCount
    ActualTargetFileCount = $actualTargetFileCount
    VerifiedTargetCount = $verifiedTargetCount
    MissingTargetCount = $missingTargetCount
    HashMismatchCount = $hashMismatchCount
    ExtraTargetFileCount = $extraTargetFileCount
    CloseoutPacket = $CloseoutPacket
    TargetVerificationLedger = $TargetVerificationLedger
    TargetAfterHashLedger = $TargetAfterHashLedger
    NextObjectCard = $NextObjectCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
    Installed = ($closeoutStatus -eq "POST_INSTALL_VERIFY_AND_CLOSEOUT_COMPLETE")
    CommittedHere = $false
    PushedHere = $false
    DoctrinePromotedHere = $false
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentInstalledStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE INSTALLED STATUS"
$statusLines += ""
$statusLines += ("GeneratedUtc: " + $statusObj.GeneratedUtc)
$statusLines += ("RunStamp: " + $RunStamp)
$statusLines += ("CloseoutStatus: " + $closeoutStatus)
$statusLines += ("NextLegalObject: " + $nextLegalObject)
$statusLines += ("WorkEntryStatus: " + $workEntryStatus)
$statusLines += ("OpenSideQuestRequired: " + $openSideQuestRequired)
$statusLines += ("LatestExecutionReceipt: " + $latestExecutionReceipt)
$statusLines += ("ExecutionStatus: " + $executionStatus)
$statusLines += ("ExecuteInstall: " + $executeInstall)
$statusLines += ("CopiedCount: " + $copiedCount)
$statusLines += ("VerifiedCount: " + $verifiedCount)
$statusLines += ("ExecutionErrorCount: " + $executionErrorCount)
$statusLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$statusLines += ("CopyPlanManifestJson: " + $copyPlanManifestJson)
$statusLines += ("ManifestTargetFileCount: " + $manifestTargetFileCount)
$statusLines += ("ActualTargetFileCount: " + $actualTargetFileCount)
$statusLines += ("VerifiedTargetCount: " + $verifiedTargetCount)
$statusLines += ("MissingTargetCount: " + $missingTargetCount)
$statusLines += ("HashMismatchCount: " + $hashMismatchCount)
$statusLines += ("ExtraTargetFileCount: " + $extraTargetFileCount)
$statusLines += ("ErrorCount: " + @($errors).Count)
$statusLines += ""
$statusLines += "# Files"
$statusLines += ""
$statusLines += ("CloseoutPacket: " + $CloseoutPacket)
$statusLines += ("TargetVerificationLedger: " + $TargetVerificationLedger)
$statusLines += ("TargetAfterHashLedger: " + $TargetAfterHashLedger)
$statusLines += ("NextObjectCard: " + $NextObjectCard)
$statusLines += ("Receipt: " + $Receipt)
$statusLines += ("ErrorLedger: " + $ErrorLedger)
$statusLines += ""
$statusLines += "# Boundary"
$statusLines += ""
$statusLines += "CopiedFilesHere: false"
$statusLines += "DeletedFilesHere: false"
$statusLines += "ArchivedFilesHere: false"
$statusLines += "DedupedFilesHere: false"
$statusLines += "DoctrinePromotedHere: false"
$statusLines += "CommittedHere: false"
$statusLines += "PushedHere: false"
$statusLines += "WatcherInstalledHere: false"
$statusLines += "AutomationInstalledHere: false"
$statusLines | Set-Content -LiteralPath $CurrentInstalledStatusMd -Encoding UTF8

$receiptLines = @()
$receiptLines += "# RECEIPT"
$receiptLines += "## COMMAND CENTER UI LANE POST INSTALL VERIFY AND CLOSEOUT GATE V1"
$receiptLines += ""
$receiptLines += ("Date: " + $DateTag)
$receiptLines += ("GeneratedUtc: " + (Get-UtcNow))
$receiptLines += ("RunStamp: " + $RunStamp)
$receiptLines += ("CloseoutStatus: " + $closeoutStatus)
$receiptLines += ("NextLegalObject: " + $nextLegalObject)
$receiptLines += ("CloseoutPacket: " + $CloseoutPacket)
$receiptLines += ("CurrentInstalledStatus: " + $CurrentInstalledStatusMd)
$receiptLines += ("CurrentInstalledStatusJson: " + $CurrentInstalledStatusJson)
$receiptLines += ("TargetVerificationLedger: " + $TargetVerificationLedger)
$receiptLines += ("TargetAfterHashLedger: " + $TargetAfterHashLedger)
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
$receiptLines += "CopiedFilesHere: false"
$receiptLines += "DeletedFilesHere: false"
$receiptLines += "ArchivedFilesHere: false"
$receiptLines += "DedupedFilesHere: false"
$receiptLines += "DoctrinePromotedHere: false"
$receiptLines += "CommittedHere: false"
$receiptLines += "PushedHere: false"
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
Write-Host "Command Center UI lane post-install verify and closeout gate complete."
Write-Host "CloseoutStatus:"
Write-Host $closeoutStatus
Write-Host ""
Write-Host "NextLegalObject:"
Write-Host $nextLegalObject
Write-Host ""
Write-Host "LatestExecutionReceipt:"
Write-Host $latestExecutionReceipt
Write-Host ""
Write-Host "ManifestTargetFileCount:"
Write-Host $manifestTargetFileCount
Write-Host ""
Write-Host "ActualTargetFileCount:"
Write-Host $actualTargetFileCount
Write-Host ""
Write-Host "VerifiedTargetCount:"
Write-Host $verifiedTargetCount
Write-Host ""
Write-Host "MissingTargetCount:"
Write-Host $missingTargetCount
Write-Host ""
Write-Host "HashMismatchCount:"
Write-Host $hashMismatchCount
Write-Host ""
Write-Host "ExtraTargetFileCount:"
Write-Host $extraTargetFileCount
Write-Host ""
Write-Host "Current installed status:"
Write-Host $CurrentInstalledStatusMd
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_POST_INSTALL_VERIFY_AND_CLOSEOUT_GATE_FINALIZED"

