<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_V1_20260606.ps1

PURPOSE:
Build the exact live-install execution plan for the Command Center UI lane.

THIS IS NOT LIVE INSTALL.
THIS DOES NOT COPY FILES.
THIS DOES NOT CREATE THE TARGET FOLDER.
THIS DOES NOT EXECUTE THE PLAN.

STATUS:
LIVE_INSTALL_EXECUTION_PLAN_GATE / PLAN_ONLY / NO_LIVE_INSTALL / NO_DOCTRINE_PROMOTION

LEGAL OUTCOMES:
- LIVE_INSTALL_EXECUTION_PLAN_READY_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION_GATE
- LIVE_INSTALL_EXECUTION_PLAN_BLOCKED

NEXT LEGAL OBJECT IF READY:
COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1
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
$AuthGateRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_HUMAN_AUTHORIZATION_GATE"
$PlanGateRoot = Join-Path $UiLaneRoot "LIVE_INSTALL_EXECUTION_PLAN_GATE"
$RunRoot = Join-Path $PlanGateRoot ("COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_V1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"
$AuthStatusMd = Join-Path $AuthGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_STATUS.md"
$AuthStatusJson = Join-Path $AuthGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_HUMAN_AUTHORIZATION_STATUS.json"

$CurrentPlanStatusMd = Join-Path $PlanGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_STATUS.md"
$CurrentPlanStatusJson = Join-Path $PlanGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_STATUS.json"

$ExecutionPlanPacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_PACKET_V1_20260606.md"
$CopyPlanManifest = Join-Path $RunRoot "COPY_PLAN_MANIFEST__COMMAND_CENTER_UI_LANE_V1_20260606.md"
$CopyPlanManifestJson = Join-Path $RunRoot "COPY_PLAN_MANIFEST__COMMAND_CENTER_UI_LANE_V1_20260606.json"
$ExecutionSteps = Join-Path $RunRoot "EXECUTION_STEPS__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_V1_20260606.md"
$VerificationPlan = Join-Path $RunRoot "VERIFY_AFTER_INSTALL_PLAN__COMMAND_CENTER_UI_LANE_V1_20260606.md"
$RollbackExecutionPlan = Join-Path $RunRoot "ROLLBACK_EXECUTION_PLAN__COMMAND_CENTER_UI_LANE_V1_20260606.md"
$StopConditions = Join-Path $RunRoot "STOP_CONDITIONS__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_V1_20260606.md"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_V1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_V1_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_EXECUTION_PLAN_GATE.txt"

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

function Add-PlanError {
    param([string]$Category, [string]$Phase, [string]$Message, [string]$Resolution = "")

    $script:errors += [pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
    }
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

New-Dir $AuthGateRoot
New-Dir $PlanGateRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$openSideQuestRequired = "UNKNOWN"
$authorizationStatus = "UNKNOWN"
$authorizationAccepted = "UNKNOWN"
$authNextLegalObject = "UNKNOWN"
$authorizedBy = "UNKNOWN"
$lockedTerms = "UNKNOWN"
$proposedSourceRoot = "UNKNOWN"
$proposedTargetRoot = "UNKNOWN"
$proposedInstallFileCount = "UNKNOWN"
$targetExistsBefore = "UNKNOWN"
$collisionCount = "UNKNOWN"
$prepPacket = "UNKNOWN"
$installManifest = "UNKNOWN"
$installManifestJson = "UNKNOWN"
$sourceHashLedger = "UNKNOWN"
$targetBeforeHashLedger = "UNKNOWN"
$collisionMap = "UNKNOWN"
$rollbackPlan = "UNKNOWN"
$manifestRows = @()
$copyRows = @()
$sourceMismatchCount = 0
$targetUnexpectedExistsCount = 0
$targetPathOutsideCount = 0
$planStatus = "LIVE_INSTALL_EXECUTION_PLAN_BLOCKED"
$nextLegalObject = "FIX_LIVE_INSTALL_EXECUTION_PLAN_BLOCKERS"

try {
    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-PlanError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Write/install Command Center work entrypoint before execution plan gate."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += ("RAN_WORK_ENTRYPOINT_FOR_EXECUTION_PLAN_GATE: " + $WorkEntryScript)
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-PlanError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run work entrypoint before execution plan gate."
    }
    else {
        $workText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $workEntryStatus = Get-InlineValue -Text $workText -Name "WorkEntryStatus"
        $openSideQuestRequired = Get-InlineValue -Text $workText -Name "OpenSideQuestRequired"
        $actions += ("READ_WORK_ENTRY_STATUS: " + $WorkEntryStatusMd)

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-PlanError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message ("WorkEntryStatus=" + $workEntryStatus) -Resolution "Resolve work entry/pre-run block first."
        }

        if ($openSideQuestRequired -ne "False") {
            Add-PlanError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message ("OpenSideQuestRequired=" + $openSideQuestRequired) -Resolution "Route to error-triggered helper harvest first."
        }
    }

    if (-not (Test-Path -LiteralPath $AuthStatusMd)) {
        Add-PlanError -Category "AUTHORIZATION_STATUS_MISSING" -Phase "READ_AUTHORIZATION" -Message $AuthStatusMd -Resolution "Run human authorization gate before execution plan gate."
    }
    else {
        $authText = Get-Content -LiteralPath $AuthStatusMd -Raw -ErrorAction Stop
        $authorizationStatus = Get-InlineValue -Text $authText -Name "AuthorizationStatus"
        $authorizationAccepted = Get-InlineValue -Text $authText -Name "AuthorizationAccepted"
        $authNextLegalObject = Get-InlineValue -Text $authText -Name "NextLegalObject"
        $authorizedBy = Get-InlineValue -Text $authText -Name "AuthorizedBy"
        $lockedTerms = Get-InlineValue -Text $authText -Name "LockedTerms"
        $actions += ("READ_AUTHORIZATION_STATUS: " + $AuthStatusMd)

        if ($authorizationStatus -ne "LIVE_INSTALL_HUMAN_AUTHORIZATION_LOCKED_FOR_EXECUTION_PLAN") {
            Add-PlanError -Category "AUTHORIZATION_NOT_LOCKED_FOR_EXECUTION_PLAN" -Phase "READ_AUTHORIZATION" -Message ("AuthorizationStatus=" + $authorizationStatus) -Resolution "Run human authorization gate with exact required phrase."
        }

        if ($authorizationAccepted -ne "true") {
            Add-PlanError -Category "AUTHORIZATION_NOT_ACCEPTED" -Phase "READ_AUTHORIZATION" -Message ("AuthorizationAccepted=" + $authorizationAccepted) -Resolution "Execution plan cannot be prepared without accepted authorization."
        }

        if ($authNextLegalObject -ne "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_V1") {
            Add-PlanError -Category "AUTH_NEXT_OBJECT_UNEXPECTED" -Phase "READ_AUTHORIZATION" -Message ("NextLegalObject=" + $authNextLegalObject) -Resolution "Review authorization gate status."
        }

        if ($lockedTerms -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $lockedTerms)) {
            Add-PlanError -Category "LOCKED_TERMS_MISSING" -Phase "READ_AUTHORIZATION" -Message ("LockedTerms=" + $lockedTerms) -Resolution "Regenerate authorization gate locked terms."
        }
    }

    if ($lockedTerms -ne "UNKNOWN" -and (Test-Path -LiteralPath $lockedTerms)) {
        $lockedText = Get-Content -LiteralPath $lockedTerms -Raw -ErrorAction Stop
        $proposedSourceRoot = Get-InlineValue -Text $lockedText -Name "ProposedSourceRoot"
        $proposedTargetRoot = Get-InlineValue -Text $lockedText -Name "ProposedTargetRoot"
        $proposedInstallFileCount = Get-InlineValue -Text $lockedText -Name "ProposedInstallFileCount"
        $targetExistsBefore = Get-InlineValue -Text $lockedText -Name "TargetExistsBefore"
        $collisionCount = Get-InlineValue -Text $lockedText -Name "CollisionCount"
        $prepPacket = Get-InlineValue -Text $lockedText -Name "PrepPacket"
        $installManifest = Get-InlineValue -Text $lockedText -Name "InstallManifest"
        $installManifestJson = Get-InlineValue -Text $lockedText -Name "InstallManifestJson"
        $sourceHashLedger = Get-InlineValue -Text $lockedText -Name "SourceHashLedger"
        $targetBeforeHashLedger = Get-InlineValue -Text $lockedText -Name "TargetBeforeHashLedger"
        $collisionMap = Get-InlineValue -Text $lockedText -Name "CollisionMap"
        $rollbackPlan = Get-InlineValue -Text $lockedText -Name "RollbackPlan"
        $actions += ("READ_LOCKED_TERMS: " + $lockedTerms)

        $requiredFiles = @(
            @{ Name = "PrepPacket"; Path = $prepPacket },
            @{ Name = "InstallManifest"; Path = $installManifest },
            @{ Name = "InstallManifestJson"; Path = $installManifestJson },
            @{ Name = "SourceHashLedger"; Path = $sourceHashLedger },
            @{ Name = "TargetBeforeHashLedger"; Path = $targetBeforeHashLedger },
            @{ Name = "CollisionMap"; Path = $collisionMap },
            @{ Name = "RollbackPlan"; Path = $rollbackPlan }
        )

        foreach ($f in $requiredFiles) {
            if ($f.Path -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $f.Path)) {
                Add-PlanError -Category "LOCKED_EVIDENCE_FILE_MISSING" -Phase "READ_LOCKED_TERMS" -Message ($f.Name + "=" + $f.Path) -Resolution "Regenerate prep/auth evidence before execution plan."
            }
        }

        if ($targetExistsBefore -eq "false" -and (Test-Path -LiteralPath $proposedTargetRoot)) {
            Add-PlanError -Category "TARGET_CHANGED_SINCE_PREP" -Phase "TARGET_STATE_CHECK" -Message ("Target did not exist at prep but exists now: " + $proposedTargetRoot) -Resolution "Rerun prep gate or inspect target before planning install."
        }

        if ($collisionCount -ne "0") {
            Add-PlanError -Category "COLLISIONS_REQUIRE_SPECIAL_PLAN" -Phase "LOCKED_TERMS_CHECK" -Message ("CollisionCount=" + $collisionCount) -Resolution "This V1 plan only handles zero-collision install."
        }
    }

    if ($installManifestJson -ne "UNKNOWN" -and (Test-Path -LiteralPath $installManifestJson)) {
        $raw = Get-Content -LiteralPath $installManifestJson -Raw -ErrorAction Stop
        $manifestRows = @($raw | ConvertFrom-Json)
        $actions += ("READ_INSTALL_MANIFEST_JSON: " + $installManifestJson)

        if (@($manifestRows).Count -lt 1) {
            Add-PlanError -Category "INSTALL_MANIFEST_EMPTY" -Phase "READ_MANIFEST" -Message $installManifestJson -Resolution "Regenerate prep manifest."
        }

        foreach ($row in $manifestRows) {
            $sourcePath = [string]$row.SourcePath
            $targetPath = [string]$row.ProposedTargetPath
            $rel = [string]$row.RelativePath
            $expectedHash = [string]$row.SourceSHA256
            $currentHash = "MISSING"
            $sourceExists = Test-Path -LiteralPath $sourcePath
            $targetExistsNow = Test-Path -LiteralPath $targetPath
            $targetInsideRoot = Test-PathInsideRoot -PathToCheck $targetPath -RootPath $proposedTargetRoot

            if (-not $sourceExists) {
                Add-PlanError -Category "SOURCE_FILE_MISSING" -Phase "VERIFY_MANIFEST_SOURCE" -Message $sourcePath -Resolution "Source file missing since prep; rerun prep gate."
            }
            else {
                $currentHash = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash
                if ($currentHash -ne $expectedHash) {
                    $sourceMismatchCount += 1
                    Add-PlanError -Category "SOURCE_HASH_CHANGED_SINCE_PREP" -Phase "VERIFY_MANIFEST_SOURCE" -Message ("RelativePath=" + $rel) -Resolution "Rerun prep gate before execution planning."
                }
            }

            if (-not $targetInsideRoot) {
                $targetPathOutsideCount += 1
                Add-PlanError -Category "TARGET_PATH_OUTSIDE_PROPOSED_ROOT" -Phase "VERIFY_TARGET_PATHS" -Message $targetPath -Resolution "Reject plan; target path must be inside proposed target root."
            }

            if ($targetExistsBefore -eq "false" -and $targetExistsNow) {
                $targetUnexpectedExistsCount += 1
                Add-PlanError -Category "TARGET_FILE_UNEXPECTEDLY_EXISTS" -Phase "VERIFY_TARGET_STATE" -Message $targetPath -Resolution "Target changed since prep; rerun prep gate."
            }

            $copyRows += [pscustomobject]@{
                RelativePath = $rel
                SourcePath = $sourcePath
                ProposedTargetPath = $targetPath
                ExpectedSHA256 = $expectedHash
                CurrentSourceSHA256 = $currentHash
                SourceExistsNow = $sourceExists
                TargetExistsNow = $targetExistsNow
                TargetInsideRoot = $targetInsideRoot
                CopyAction = "COPY_IF_FINAL_AUTHORIZED"
            }
        }
    }
}
catch {
    Add-PlanError -Category "EXECUTION_PLAN_GATE_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review execution plan error ledger."
}

if (@($errors).Count -eq 0) {
    $planStatus = "LIVE_INSTALL_EXECUTION_PLAN_READY_FOR_FINAL_HUMAN_EXECUTION_AUTHORIZATION_GATE"
    $nextLegalObject = "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1"
}
else {
    $planStatus = "LIVE_INSTALL_EXECUTION_PLAN_BLOCKED"
    $nextLegalObject = "FIX_LIVE_INSTALL_EXECUTION_PLAN_BLOCKERS"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE LIVE INSTALL EXECUTION PLAN GATE V1"
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

$copyLines = @()
$copyLines += "# COPY PLAN MANIFEST"
$copyLines += "## COMMAND CENTER UI LANE V1"
$copyLines += ""
$copyLines += ("GeneratedUtc: " + (Get-UtcNow))
$copyLines += ("CopyPlanFileCount: " + @($copyRows).Count)
$copyLines += ("ProposedSourceRoot: " + $proposedSourceRoot)
$copyLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$copyLines += ""
$copyLines += "| RelativePath | SourceExistsNow | TargetExistsNow | TargetInsideRoot | ExpectedSHA256 | CurrentSourceSHA256 | SourcePath | ProposedTargetPath |"
$copyLines += "|---|---|---|---|---|---|---|---|"
foreach ($r in $copyRows) {
    $copyLines += ("| " + (Escape-Md $r.RelativePath) + " | " + $r.SourceExistsNow + " | " + $r.TargetExistsNow + " | " + $r.TargetInsideRoot + " | " + $r.ExpectedSHA256 + " | " + $r.CurrentSourceSHA256 + " | " + (Escape-Md $r.SourcePath) + " | " + (Escape-Md $r.ProposedTargetPath) + " |")
}
$copyLines += ""
$copyLines += "# Boundary"
$copyLines += ""
$copyLines += "This manifest is plan-only. It does not copy files."
$copyLines | Set-Content -LiteralPath $CopyPlanManifest -Encoding UTF8
$copyRows | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CopyPlanManifestJson -Encoding UTF8

$stepLines = @()
$stepLines += "# EXECUTION STEPS"
$stepLines += "## COMMAND CENTER UI LANE LIVE INSTALL V1"
$stepLines += ""
$stepLines += "Status: PLAN_ONLY"
$stepLines += ("PlanStatus: " + $planStatus)
$stepLines += ""
$stepLines += "# Future Execution Order"
$stepLines += ""
$stepLines += "1. Run Command Center work entrypoint."
$stepLines += "2. Re-read final execution authorization gate."
$stepLines += "3. Re-read this execution plan status."
$stepLines += "4. Verify source files still match expected hashes."
$stepLines += "5. Verify target state still matches target-before assumptions."
if ($targetExistsBefore -eq "false") {
    $stepLines += "6. Create target folder only if final authorization is accepted."
    $stepLines += "7. Copy approved manifest files into the target folder."
    $stepLines += "8. Verify copied target files match expected hashes."
    $stepLines += "9. Write install execution receipt."
}
else {
    $stepLines += "6. Create a full timestamped backup of the existing target folder."
    $stepLines += "7. Copy approved manifest files into the target folder according to collision handling rules."
    $stepLines += "8. Verify copied target files match expected hashes."
    $stepLines += "9. Write install execution receipt and backup pointer."
}
$stepLines += ""
$stepLines += "# Not Executed Here"
$stepLines += ""
$stepLines += "No target folder is created by this plan."
$stepLines += "No files are copied by this plan."
$stepLines += "No backup is created by this plan."
$stepLines | Set-Content -LiteralPath $ExecutionSteps -Encoding UTF8

$verifyLines = @()
$verifyLines += "# VERIFY AFTER INSTALL PLAN"
$verifyLines += "## COMMAND CENTER UI LANE V1"
$verifyLines += ""
$verifyLines += ("GeneratedUtc: " + (Get-UtcNow))
$verifyLines += ""
$verifyLines += "# Required Future Checks"
$verifyLines += ""
$verifyLines += "- Every copied file must exist at proposed target path."
$verifyLines += "- Every copied file SHA-256 must equal the source hash locked in the copy plan."
$verifyLines += "- No extra files may be created outside the proposed target root."
$verifyLines += "- Work entry status must remain clear."
$verifyLines += "- Any mismatch must trigger rollback path and error ledger."
$verifyLines += ""
$verifyLines += ("CopyPlanManifest: " + $CopyPlanManifest)
$verifyLines += ("CopyPlanManifestJson: " + $CopyPlanManifestJson)
$verifyLines | Set-Content -LiteralPath $VerificationPlan -Encoding UTF8

$rollbackLines = @()
$rollbackLines += "# ROLLBACK EXECUTION PLAN"
$rollbackLines += "## COMMAND CENTER UI LANE V1"
$rollbackLines += ""
$rollbackLines += ("GeneratedUtc: " + (Get-UtcNow))
$rollbackLines += ("TargetExistsBefore: " + $targetExistsBefore)
$rollbackLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$rollbackLines += ("PrepRollbackPlan: " + $rollbackPlan)
$rollbackLines += ""
if ($targetExistsBefore -eq "false") {
    $rollbackLines += "# Rollback Shape"
    $rollbackLines += ""
    $rollbackLines += "If future execution creates the target folder and then fails, rollback may remove only this newly created target folder:"
    $rollbackLines += $proposedTargetRoot
    $rollbackLines += ""
    $rollbackLines += "Rollback must not remove parent folders or unrelated files."
}
else {
    $rollbackLines += "# Rollback Shape"
    $rollbackLines += ""
    $rollbackLines += "Future execution must first create a full timestamped backup of the target folder."
    $rollbackLines += "Rollback must restore from that backup and verify target-before hashes."
}
$rollbackLines += ""
$rollbackLines += "# Not Executed Here"
$rollbackLines += ""
$rollbackLines += "No rollback action is performed by this plan."
$rollbackLines | Set-Content -LiteralPath $RollbackExecutionPlan -Encoding UTF8

$stopLines = @()
$stopLines += "# STOP CONDITIONS"
$stopLines += "## COMMAND CENTER UI LANE LIVE INSTALL V1"
$stopLines += ""
$stopLines += "Stop before execution if any of these are true:"
$stopLines += ""
$stopLines += "- Work entrypoint is not clear."
$stopLines += "- OpenSideQuestRequired is True."
$stopLines += "- Final human execution authorization is missing."
$stopLines += "- Source hash changed since plan."
$stopLines += "- Target exists unexpectedly when target did not exist at prep."
$stopLines += "- Any target path is outside proposed target root."
$stopLines += "- Collision count is not zero for this V1 zero-collision plan."
$stopLines += "- Doctrine promotion is requested."
$stopLines += "- Watcher or automation install is requested."
$stopLines += "- Cleanup/delete/archive/dedupe is requested."
$stopLines += "- Commit/push is requested."
$stopLines | Set-Content -LiteralPath $StopConditions -Encoding UTF8

$packetLines = @()
$packetLines += "# COMMAND CENTER UI LANE LIVE INSTALL EXECUTION PLAN PACKET"
$packetLines += "## V1"
$packetLines += ""
$packetLines += ("GeneratedUtc: " + (Get-UtcNow))
$packetLines += ("RunStamp: " + $RunStamp)
$packetLines += ("PlanStatus: " + $planStatus)
$packetLines += ("NextLegalObject: " + $nextLegalObject)
$packetLines += ("ErrorCount: " + @($errors).Count)
$packetLines += ""
$packetLines += "# Authorization Source"
$packetLines += ""
$packetLines += ("AuthorizationStatus: " + $authorizationStatus)
$packetLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$packetLines += ("AuthorizedBy: " + $authorizedBy)
$packetLines += ("LockedTerms: " + $lockedTerms)
$packetLines += ""
$packetLines += "# Proposed Boundary"
$packetLines += ""
$packetLines += ("ProposedSourceRoot: " + $proposedSourceRoot)
$packetLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$packetLines += ("ProposedInstallFileCount: " + $proposedInstallFileCount)
$packetLines += ("TargetExistsBefore: " + $targetExistsBefore)
$packetLines += ("CollisionCount: " + $collisionCount)
$packetLines += ("CopyPlanFileCount: " + @($copyRows).Count)
$packetLines += ("SourceMismatchCount: " + $sourceMismatchCount)
$packetLines += ("TargetUnexpectedExistsCount: " + $targetUnexpectedExistsCount)
$packetLines += ("TargetPathOutsideCount: " + $targetPathOutsideCount)
$packetLines += ""
$packetLines += "# Plan Files"
$packetLines += ""
$packetLines += ("CopyPlanManifest: " + $CopyPlanManifest)
$packetLines += ("CopyPlanManifestJson: " + $CopyPlanManifestJson)
$packetLines += ("ExecutionSteps: " + $ExecutionSteps)
$packetLines += ("VerificationPlan: " + $VerificationPlan)
$packetLines += ("RollbackExecutionPlan: " + $RollbackExecutionPlan)
$packetLines += ("StopConditions: " + $StopConditions)
$packetLines += ("NextObjectCard: " + $NextObjectCard)
$packetLines += ("Receipt: " + $Receipt)
$packetLines += ("ErrorLedger: " + $ErrorLedger)
$packetLines += ""
$packetLines += "# Authorization Flags"
$packetLines += ""
$packetLines += "LiveInstallExecutionAuthorized: false"
$packetLines += "DoctrinePromotionAuthorized: false"
$packetLines += "CopiedFilesToTarget: false"
$packetLines += "CreatedTargetFolder: false"
$packetLines += "CommitAuthorized: false"
$packetLines += "PushAuthorized: false"
$packetLines += "WatcherAuthorized: false"
$packetLines += "AutomationAuthorized: false"
$packetLines | Set-Content -LiteralPath $ExecutionPlanPacket -Encoding UTF8

$nextLines = @()
$nextLines += "# NEXT OBJECT CARD"
$nextLines += "## COMMAND_CENTER_UI_LANE_LIVE_INSTALL_FINAL_EXECUTION_AUTHORIZATION_GATE_V1"
$nextLines += ""
$nextLines += ("GeneratedUtc: " + (Get-UtcNow))
$nextLines += ("RunStamp: " + $RunStamp)
$nextLines += ("PlanStatus: " + $planStatus)
$nextLines += ("SourceExecutionPlanPacket: " + $ExecutionPlanPacket)
$nextLines += ""
$nextLines += "# Purpose"
$nextLines += ""
$nextLines += "Ask for final explicit human authorization to build or run the install execution script."
$nextLines += ""
$nextLines += "# Still Not Authorized Here"
$nextLines += ""
$nextLines += "LiveInstallExecutionAuthorized: false"
$nextLines += "CopiedFilesToTarget: false"
$nextLines += "CreatedTargetFolder: false"
$nextLines | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    PlanStatus = $planStatus
    NextLegalObject = $nextLegalObject
    WorkEntryStatus = $workEntryStatus
    OpenSideQuestRequired = $openSideQuestRequired
    AuthorizationStatus = $authorizationStatus
    AuthorizationAccepted = $authorizationAccepted
    AuthorizedBy = $authorizedBy
    ProposedSourceRoot = $proposedSourceRoot
    ProposedTargetRoot = $proposedTargetRoot
    ProposedInstallFileCount = $proposedInstallFileCount
    TargetExistsBefore = $targetExistsBefore
    CollisionCount = $collisionCount
    CopyPlanFileCount = @($copyRows).Count
    SourceMismatchCount = $sourceMismatchCount
    TargetUnexpectedExistsCount = $targetUnexpectedExistsCount
    TargetPathOutsideCount = $targetPathOutsideCount
    ExecutionPlanPacket = $ExecutionPlanPacket
    CopyPlanManifest = $CopyPlanManifest
    CopyPlanManifestJson = $CopyPlanManifestJson
    ExecutionSteps = $ExecutionSteps
    VerificationPlan = $VerificationPlan
    RollbackExecutionPlan = $RollbackExecutionPlan
    StopConditions = $StopConditions
    NextObjectCard = $NextObjectCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    ErrorCount = @($errors).Count
    LiveInstallExecutionAuthorized = $false
    DoctrinePromotionAuthorized = $false
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentPlanStatusJson -Encoding UTF8

$statusLines = @()
$statusLines += "# CURRENT COMMAND CENTER UI LANE LIVE INSTALL EXECUTION PLAN STATUS"
$statusLines += ""
$statusLines += ("GeneratedUtc: " + $statusObj.GeneratedUtc)
$statusLines += ("RunStamp: " + $RunStamp)
$statusLines += ("PlanStatus: " + $planStatus)
$statusLines += ("NextLegalObject: " + $nextLegalObject)
$statusLines += ("WorkEntryStatus: " + $workEntryStatus)
$statusLines += ("OpenSideQuestRequired: " + $openSideQuestRequired)
$statusLines += ("AuthorizationStatus: " + $authorizationStatus)
$statusLines += ("AuthorizationAccepted: " + $authorizationAccepted)
$statusLines += ("AuthorizedBy: " + $authorizedBy)
$statusLines += ("ProposedSourceRoot: " + $proposedSourceRoot)
$statusLines += ("ProposedTargetRoot: " + $proposedTargetRoot)
$statusLines += ("ProposedInstallFileCount: " + $proposedInstallFileCount)
$statusLines += ("TargetExistsBefore: " + $targetExistsBefore)
$statusLines += ("CollisionCount: " + $collisionCount)
$statusLines += ("CopyPlanFileCount: " + @($copyRows).Count)
$statusLines += ("SourceMismatchCount: " + $sourceMismatchCount)
$statusLines += ("TargetUnexpectedExistsCount: " + $targetUnexpectedExistsCount)
$statusLines += ("TargetPathOutsideCount: " + $targetPathOutsideCount)
$statusLines += ("ErrorCount: " + @($errors).Count)
$statusLines += ""
$statusLines += "# Plan Files"
$statusLines += ""
$statusLines += ("ExecutionPlanPacket: " + $ExecutionPlanPacket)
$statusLines += ("CopyPlanManifest: " + $CopyPlanManifest)
$statusLines += ("CopyPlanManifestJson: " + $CopyPlanManifestJson)
$statusLines += ("ExecutionSteps: " + $ExecutionSteps)
$statusLines += ("VerificationPlan: " + $VerificationPlan)
$statusLines += ("RollbackExecutionPlan: " + $RollbackExecutionPlan)
$statusLines += ("StopConditions: " + $StopConditions)
$statusLines += ("NextObjectCard: " + $NextObjectCard)
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
$statusLines | Set-Content -LiteralPath $CurrentPlanStatusMd -Encoding UTF8

$receiptLines = @()
$receiptLines += "# RECEIPT"
$receiptLines += "## COMMAND CENTER UI LANE LIVE INSTALL EXECUTION PLAN GATE V1"
$receiptLines += ""
$receiptLines += ("Date: " + $DateTag)
$receiptLines += ("GeneratedUtc: " + (Get-UtcNow))
$receiptLines += ("RunStamp: " + $RunStamp)
$receiptLines += ("PlanStatus: " + $planStatus)
$receiptLines += ("NextLegalObject: " + $nextLegalObject)
$receiptLines += ("CopyPlanFileCount: " + @($copyRows).Count)
$receiptLines += ("ExecutionPlanPacket: " + $ExecutionPlanPacket)
$receiptLines += ("CopyPlanManifest: " + $CopyPlanManifest)
$receiptLines += ("CurrentPlanStatus: " + $CurrentPlanStatusMd)
$receiptLines += ("CurrentPlanStatusJson: " + $CurrentPlanStatusJson)
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
Write-Host "Command Center UI lane live-install execution plan gate complete."
Write-Host "PlanStatus:"
Write-Host $planStatus
Write-Host ""
Write-Host "NextLegalObject:"
Write-Host $nextLegalObject
Write-Host ""
Write-Host "CopyPlanFileCount:"
Write-Host @($copyRows).Count
Write-Host ""
Write-Host "SourceMismatchCount:"
Write-Host $sourceMismatchCount
Write-Host ""
Write-Host "TargetUnexpectedExistsCount:"
Write-Host $targetUnexpectedExistsCount
Write-Host ""
Write-Host "TargetPathOutsideCount:"
Write-Host $targetPathOutsideCount
Write-Host ""
Write-Host "Execution plan packet:"
Write-Host $ExecutionPlanPacket
Write-Host ""
Write-Host "Current plan status:"
Write-Host $CurrentPlanStatusMd
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_LIVE_INSTALL_EXECUTION_PLAN_GATE_FINALIZED"

