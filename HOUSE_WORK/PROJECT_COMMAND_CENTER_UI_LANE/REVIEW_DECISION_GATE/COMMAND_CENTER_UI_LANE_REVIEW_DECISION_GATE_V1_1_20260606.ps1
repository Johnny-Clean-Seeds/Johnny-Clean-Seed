<#
SCRIPT NAME:
COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_V1_1_20260606.ps1

PURPOSE:
Repair and replace the V1 review decision gate parser.

V1 blocked after ReviewStatus was ready because it expected these values as inline fields:
Review Packet:
Decision Card:

But CURRENT_COMMAND_CENTER_UI_LANE_REVIEW_STATUS.md stores them as section headers:

# Review Packet
<path>

# Decision Card
<path>

V1.1 reads both shapes:
- inline field value
- section-next-line path
- latest file fallback

STATUS:
COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_V1_1 / REPAIR / REPORT_ONLY / NO_LIVE_INSTALL

THIS SCRIPT DOES:
- run/read Command Center work entrypoint again
- read CURRENT_COMMAND_CENTER_UI_LANE_REVIEW_STATUS.md/json
- parse review packet and decision card robustly
- require no open side quest
- require UI_LANE_REVIEW_PACKET_READY
- write a V1.1 review decision gate packet
- write current decision gate status
- write next-object card
- write receipt and error ledger
- record the V1 parser mismatch as a live repair finding

THIS SCRIPT DOES NOT:
- live install Command Center
- prepare install mutation
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
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [ValidateSet("REVIEW_ONLY_CONTINUE", "PARK_FOR_LATER", "PREPARE_LIVE_INSTALL_GATE")]
    [string]$Decision = "PREPARE_LIVE_INSTALL_GATE",

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
$ReviewRoot = Join-Path $UiLaneRoot "REVIEW_ENTRY"
$DecisionGateRoot = Join-Path $UiLaneRoot "REVIEW_DECISION_GATE"
$RunRoot = Join-Path $DecisionGateRoot ("COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_V1_1_" + $RunStamp)

$WorkEntryScript = Join-Path $WorkEntryRoot "COMMAND_CENTER_WORK_ENTRYPOINT_V1_20260606.ps1"
$WorkEntryStatusMd = Join-Path $WorkEntryRoot "CURRENT_COMMAND_CENTER_WORK_ENTRY_STATUS.md"

$CurrentReviewStatusMd = Join-Path $ReviewRoot "CURRENT_COMMAND_CENTER_UI_LANE_REVIEW_STATUS.md"
$CurrentReviewStatusJson = Join-Path $ReviewRoot "CURRENT_COMMAND_CENTER_UI_LANE_REVIEW_STATUS.json"

$CurrentDecisionGateStatusMd = Join-Path $DecisionGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_STATUS.md"
$CurrentDecisionGateStatusJson = Join-Path $DecisionGateRoot "CURRENT_COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_STATUS.json"

$DecisionGatePacket = Join-Path $RunRoot "COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_PACKET_V1_1_20260606.md"
$NextObjectCard = Join-Path $RunRoot "NEXT_OBJECT_CARD__COMMAND_CENTER_UI_LANE_LIVE_INSTALL_PREP_GATE_V1_20260606.md"
$ParkCard = Join-Path $RunRoot "PARK_CARD__COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_V1_1_20260606.md"
$Receipt = Join-Path $RunRoot "RECEIPT__COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_V1_1_20260606.md"
$ErrorLedger = Join-Path $RunRoot "ERROR_LEDGER__COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_V1_1_20260606.md"
$RepairFinding = Join-Path $RunRoot "REPAIR_FINDING__V1_SECTION_PATH_PARSER_MISMATCH_20260606.md"
$EntryOutput = Join-Path $RunRoot "OUTPUT__WORK_ENTRYPOINT_VERIFY_FOR_DECISION_GATE_V1_1.txt"

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
    param(
        [string]$Text,
        [string]$Name
    )

    $pattern = "(?im)^\s*" + [regex]::Escape($Name) + "\s*:\s*(.+?)\s*$"
    $m = [regex]::Match($Text, $pattern)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return "UNKNOWN"
}

function Get-SectionNextLineValue {
    param(
        [string]$Text,
        [string]$SectionName
    )

    $lines = $Text -split "`r?`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $clean = $lines[$i].Trim()
        if ($clean -eq ("# " + $SectionName) -or $clean -eq ("## " + $SectionName) -or $clean -eq $SectionName) {
            for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                $candidate = $lines[$j].Trim()
                if ([string]::IsNullOrWhiteSpace($candidate)) {
                    continue
                }
                if ($candidate.StartsWith("#")) {
                    break
                }
                return $candidate
            }
        }
    }

    return "UNKNOWN"
}

function Find-LatestFile {
    param(
        [string]$BasePath,
        [string]$Filter
    )

    if (-not (Test-Path -LiteralPath $BasePath)) {
        return "UNKNOWN"
    }

    $hit = Get-ChildItem -LiteralPath $BasePath -Filter $Filter -File -Recurse -Force -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($null -eq $hit) { return "UNKNOWN" }
    return $hit.FullName
}

function Resolve-ReviewPath {
    param(
        [string]$ReviewText,
        [string]$InlineName,
        [string]$SectionName,
        [string]$FallbackFilter
    )

    $inline = Get-InlineValue -Text $ReviewText -Name $InlineName
    if ($inline -ne "UNKNOWN" -and (Test-Path -LiteralPath $inline)) {
        return [pscustomobject]@{
            Path = $inline
            Method = "INLINE_FIELD"
        }
    }

    $section = Get-SectionNextLineValue -Text $ReviewText -SectionName $SectionName
    if ($section -ne "UNKNOWN" -and (Test-Path -LiteralPath $section)) {
        return [pscustomobject]@{
            Path = $section
            Method = "SECTION_NEXT_LINE"
        }
    }

    $fallback = Find-LatestFile -BasePath $ReviewRoot -Filter $FallbackFilter
    if ($fallback -ne "UNKNOWN" -and (Test-Path -LiteralPath $fallback)) {
        return [pscustomobject]@{
            Path = $fallback
            Method = "LATEST_FILE_FALLBACK"
        }
    }

    return [pscustomobject]@{
        Path = "UNKNOWN"
        Method = "NOT_FOUND"
    }
}

function Add-DecisionError {
    param(
        [string]$Category,
        [string]$Phase,
        [string]$Message,
        [string]$Resolution = ""
    )

    $script:errors += [pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
    }
}

New-Dir $UiLaneRoot
New-Dir $DecisionGateRoot
New-Dir $RunRoot

$errors = @()
$actions = @()

$workEntryStatus = "UNKNOWN"
$entryOpenSideQuest = "UNKNOWN"
$reviewStatus = "UNKNOWN"
$reviewOpenSideQuest = "UNKNOWN"
$reviewErrorCount = "UNKNOWN"
$reviewPacket = "UNKNOWN"
$reviewPacketMethod = "UNKNOWN"
$reviewDecisionCard = "UNKNOWN"
$reviewDecisionCardMethod = "UNKNOWN"
$decisionGateStatus = "DECISION_GATE_BLOCKED"
$finalDecision = "NO_DECISION"
$nextLegalObject = "NONE"
$priorV1Status = "UNKNOWN"
$priorV1ErrorCount = "UNKNOWN"

try {
    if (Test-Path -LiteralPath $CurrentDecisionGateStatusMd) {
        $priorText = Get-Content -LiteralPath $CurrentDecisionGateStatusMd -Raw -ErrorAction SilentlyContinue
        $priorV1Status = Get-InlineValue -Text $priorText -Name "DecisionGateStatus"
        $priorV1ErrorCount = Get-InlineValue -Text $priorText -Name "ErrorCount"
        $actions += "READ_PRIOR_DECISION_GATE_STATUS: $CurrentDecisionGateStatusMd"
    }

    $findingText = @"
# REPAIR FINDING
## V1 SECTION PATH PARSER MISMATCH

GeneratedUtc: $(Get-UtcNow)
RunStamp: $RunStamp

Finding:
The V1 decision gate could block even when the UI review packet was ready because it expected Review Packet and Decision Card as inline colon fields.

PriorObservedStatus:
$priorV1Status

PriorObservedErrorCount:
$priorV1ErrorCount

Cause:
CURRENT_COMMAND_CENTER_UI_LANE_REVIEW_STATUS.md writes Review Packet and Decision Card as markdown sections with the path on the next non-empty line.

Repair:
V1.1 reads inline fields, section-next-line values, and latest-file fallback.

Category:
STATUS_PARSER_SHAPE_MISMATCH

DoesNotProve:
This finding does not approve live install or doctrine promotion.
"@
    $findingText | Set-Content -LiteralPath $RepairFinding -Encoding UTF8
    $actions += "WROTE_REPAIR_FINDING: $RepairFinding"

    if (-not (Test-Path -LiteralPath $WorkEntryScript)) {
        Add-DecisionError -Category "WORK_ENTRYPOINT_MISSING" -Phase "PREFLIGHT" -Message $WorkEntryScript -Resolution "Write/install Command Center work entrypoint before decision gate."
    }
    elseif (-not $NoEntryRun) {
        & $WorkEntryScript -WorkIntent "COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_V1_1" -SelectedLane "COMMAND_CENTER_UI_LANE" *>&1 |
            Tee-Object -FilePath $EntryOutput | Out-Host
        $actions += "RAN_WORK_ENTRYPOINT_FOR_DECISION_GATE_V1_1: $WorkEntryScript"
    }
    else {
        $actions += "WORK_ENTRYPOINT_RUN_SKIPPED_BY_FLAG"
    }

    if (-not (Test-Path -LiteralPath $WorkEntryStatusMd)) {
        Add-DecisionError -Category "WORK_ENTRY_STATUS_MISSING" -Phase "READ_WORK_ENTRY" -Message $WorkEntryStatusMd -Resolution "Run Command Center work entrypoint before decision gate."
    }
    else {
        $entryText = Get-Content -LiteralPath $WorkEntryStatusMd -Raw -ErrorAction Stop
        $actions += "READ_WORK_ENTRY_STATUS: $WorkEntryStatusMd"
        $workEntryStatus = Get-InlineValue -Text $entryText -Name "WorkEntryStatus"
        $entryOpenSideQuest = Get-InlineValue -Text $entryText -Name "OpenSideQuestRequired"

        if ($workEntryStatus -ne "WORK_ENTRY_READY_FOR_SELECTED_ACTION") {
            Add-DecisionError -Category "WORK_ENTRY_NOT_READY" -Phase "READ_WORK_ENTRY" -Message "WorkEntryStatus=$workEntryStatus" -Resolution "Do not continue decision gate. Resolve pre-run block first."
        }

        if ($entryOpenSideQuest -ne "False") {
            Add-DecisionError -Category "OPEN_SIDE_QUEST_REQUIRED" -Phase "READ_WORK_ENTRY" -Message "OpenSideQuestRequired=$entryOpenSideQuest" -Resolution "Pause decision gate and route to error-triggered helper harvest."
        }
    }

    if (-not (Test-Path -LiteralPath $CurrentReviewStatusMd)) {
        Add-DecisionError -Category "UI_REVIEW_STATUS_MISSING" -Phase "READ_UI_REVIEW_STATUS" -Message $CurrentReviewStatusMd -Resolution "Run UI lane review entry before decision gate."
    }
    else {
        $reviewText = Get-Content -LiteralPath $CurrentReviewStatusMd -Raw -ErrorAction Stop
        $actions += "READ_UI_REVIEW_STATUS: $CurrentReviewStatusMd"

        $reviewStatus = Get-InlineValue -Text $reviewText -Name "ReviewStatus"
        $reviewOpenSideQuest = Get-InlineValue -Text $reviewText -Name "OpenSideQuestRequired"
        $reviewErrorCount = Get-InlineValue -Text $reviewText -Name "ErrorCount"

        $resolvedPacket = Resolve-ReviewPath -ReviewText $reviewText -InlineName "ReviewPacket" -SectionName "Review Packet" -FallbackFilter "COMMAND_CENTER_UI_LANE_REVIEW_PACKET_V1_20260606.md"
        $reviewPacket = $resolvedPacket.Path
        $reviewPacketMethod = $resolvedPacket.Method

        $resolvedDecision = Resolve-ReviewPath -ReviewText $reviewText -InlineName "DecisionCard" -SectionName "Decision Card" -FallbackFilter "COMMAND_CENTER_UI_LANE_REVIEW_DECISION_CARD_V1_20260606.md"
        $reviewDecisionCard = $resolvedDecision.Path
        $reviewDecisionCardMethod = $resolvedDecision.Method

        $actions += "RESOLVED_REVIEW_PACKET_METHOD_$reviewPacketMethod: $reviewPacket"
        $actions += "RESOLVED_REVIEW_DECISION_CARD_METHOD_$reviewDecisionCardMethod: $reviewDecisionCard"

        if ($reviewStatus -ne "UI_LANE_REVIEW_PACKET_READY") {
            Add-DecisionError -Category "UI_REVIEW_NOT_READY" -Phase "READ_UI_REVIEW_STATUS" -Message "ReviewStatus=$reviewStatus" -Resolution "Fix or regenerate UI lane review packet before decision."
        }

        if ($reviewOpenSideQuest -ne "False") {
            Add-DecisionError -Category "UI_REVIEW_SIDE_QUEST_OPEN" -Phase "READ_UI_REVIEW_STATUS" -Message "OpenSideQuestRequired=$reviewOpenSideQuest" -Resolution "Route to error-triggered helper harvest before decision."
        }

        if ($reviewErrorCount -ne "0") {
            Add-DecisionError -Category "UI_REVIEW_ERROR_COUNT_NOT_ZERO" -Phase "READ_UI_REVIEW_STATUS" -Message "ErrorCount=$reviewErrorCount" -Resolution "Resolve review entry errors before decision."
        }

        if ($reviewPacket -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $reviewPacket)) {
            Add-DecisionError -Category "UI_REVIEW_PACKET_MISSING" -Phase "READ_UI_REVIEW_STATUS" -Message "ReviewPacket=$reviewPacket Method=$reviewPacketMethod" -Resolution "Regenerate UI lane review entry packet."
        }

        if ($reviewDecisionCard -eq "UNKNOWN" -or -not (Test-Path -LiteralPath $reviewDecisionCard)) {
            Add-DecisionError -Category "UI_REVIEW_DECISION_CARD_MISSING" -Phase "READ_UI_REVIEW_STATUS" -Message "DecisionCard=$reviewDecisionCard Method=$reviewDecisionCardMethod" -Resolution "Regenerate UI lane review entry decision card."
        }
    }

    if (@($errors).Count -eq 0) {
        if ($Decision -eq "PREPARE_LIVE_INSTALL_GATE") {
            $decisionGateStatus = "DECISION_GATE_READY_PREPARE_LIVE_INSTALL_GATE"
            $finalDecision = "PREPARE_LIVE_INSTALL_GATE"
            $nextLegalObject = "COMMAND_CENTER_UI_LANE_LIVE_INSTALL_PREP_GATE_V1"
        }
        elseif ($Decision -eq "REVIEW_ONLY_CONTINUE") {
            $decisionGateStatus = "DECISION_GATE_REVIEW_ONLY_CONTINUE"
            $finalDecision = "REVIEW_ONLY_CONTINUE"
            $nextLegalObject = "COMMAND_CENTER_UI_LANE_REVIEW_CONTINUATION"
        }
        elseif ($Decision -eq "PARK_FOR_LATER") {
            $decisionGateStatus = "DECISION_GATE_PARKED_FOR_LATER"
            $finalDecision = "PARK_FOR_LATER"
            $nextLegalObject = "PARKED_COMMAND_CENTER_UI_LANE_REVIEW"
        }
    }
    else {
        $decisionGateStatus = "DECISION_GATE_BLOCKED_BY_EVIDENCE_OR_SIDE_QUEST"
        $finalDecision = "BLOCKED"
        $nextLegalObject = "FIX_DECISION_GATE_BLOCKERS"
    }
}
catch {
    Add-DecisionError -Category "DECISION_GATE_V1_1_EXCEPTION" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review error ledger and repair before next step."
    $decisionGateStatus = "DECISION_GATE_EXCEPTION"
    $finalDecision = "BLOCKED"
    $nextLegalObject = "FIX_DECISION_GATE_EXCEPTION"
}

$errorLines = @()
$errorLines += "# ERROR LEDGER"
$errorLines += "## COMMAND CENTER UI LANE REVIEW DECISION GATE V1.1"
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
$errorLines += "This error ledger does not approve live install or doctrine promotion."
$errorLines | Set-Content -LiteralPath $ErrorLedger -Encoding UTF8

$livePrepAllowed = if ($finalDecision -eq "PREPARE_LIVE_INSTALL_GATE") { "true" } else { "false" }

$packet = @()
$packet += "# COMMAND CENTER UI LANE REVIEW DECISION GATE PACKET"
$packet += "## V1.1"
$packet += ""
$packet += "GeneratedUtc: $(Get-UtcNow)"
$packet += "RunStamp: $RunStamp"
$packet += "DecisionGateStatus: $decisionGateStatus"
$packet += "Decision: $finalDecision"
$packet += "RequestedDecision: $Decision"
$packet += "NextLegalObject: $nextLegalObject"
$packet += "ErrorCount: $(@($errors).Count)"
$packet += ""
$packet += "# V1 Repair Finding"
$packet += ""
$packet += "RepairFinding: $RepairFinding"
$packet += "PriorV1Status: $priorV1Status"
$packet += "PriorV1ErrorCount: $priorV1ErrorCount"
$packet += "RepairCategory: STATUS_PARSER_SHAPE_MISMATCH"
$packet += ""
$packet += "# Readiness"
$packet += ""
$packet += "WorkEntryStatus: $workEntryStatus"
$packet += "EntryOpenSideQuestRequired: $entryOpenSideQuest"
$packet += "ReviewStatus: $reviewStatus"
$packet += "ReviewOpenSideQuestRequired: $reviewOpenSideQuest"
$packet += "ReviewErrorCount: $reviewErrorCount"
$packet += ""
$packet += "# Source Evidence"
$packet += ""
$packet += "WorkEntryStatusFile: $WorkEntryStatusMd"
$packet += "UiReviewStatusFile: $CurrentReviewStatusMd"
$packet += "UiReviewStatusJson: $CurrentReviewStatusJson"
$packet += "ReviewPacket: $reviewPacket"
$packet += "ReviewPacketResolveMethod: $reviewPacketMethod"
$packet += "ReviewDecisionCard: $reviewDecisionCard"
$packet += "ReviewDecisionCardResolveMethod: $reviewDecisionCardMethod"
$packet += ""
$packet += "# Decision Meaning"
$packet += ""
$packet += "REVIEW_ONLY_CONTINUE means keep reviewing or strengthening the UI lane without preparing live install."
$packet += "PARK_FOR_LATER means stop this lane cleanly with a park card."
$packet += "PREPARE_LIVE_INSTALL_GATE means the next legal object may be a separate live-install preparation gate."
$packet += ""
$packet += "# Boundaries"
$packet += ""
$packet += "LiveInstallAuthorized: false"
$packet += "DoctrinePromotionAuthorized: false"
$packet += "LiveInstallGatePreparationAllowed: $livePrepAllowed"
$packet += ""
$packet += "# Not Authorized"
$packet += ""
$packet += "- Live Command Center install."
$packet += "- Doctrine promotion."
$packet += "- Cleanup/delete/archive/dedupe."
$packet += "- Commit/push."
$packet += "- Watcher/automation."
$packet += ""
$packet += "# DoesNotProve"
$packet += ""
$packet += "This decision gate does not install anything."
$packet += "This decision gate does not promote doctrine."
$packet += "This decision gate does not authorize cleanup, deletion, archive, dedupe, commit, push, watcher, automation, or live mutation."
$packet | Set-Content -LiteralPath $DecisionGatePacket -Encoding UTF8

$nextObjectText = @"
# NEXT OBJECT CARD
## COMMAND_CENTER_UI_LANE_LIVE_INSTALL_PREP_GATE_V1

GeneratedUtc: $(Get-UtcNow)
RunStamp: $RunStamp

SourceDecisionGate:
$DecisionGatePacket

DecisionGateStatus:
$decisionGateStatus

Decision:
$finalDecision

NextLegalObject:
$nextLegalObject

Purpose:
Prepare a separate live-install gate only if explicitly continued.

RequiredInputs:
- Current Command Center work entry status
- Current UI lane review status
- UI lane review packet
- UI lane review decision card
- This V1.1 decision gate packet
- No open side quest
- No review errors

MustProveBeforeAnyInstall:
- exact target install location
- exact files to be installed
- before/after hashes
- rollback path
- no mutation outside allowed target
- no doctrine promotion unless separately authorized
- no watcher/automation unless separately authorized
- human gate copy block says install is authorized

LiveInstallAuthorizedHere:
false

DoesNotProve:
This card does not approve live install.
It only names the next possible gate.
"@
$nextObjectText | Set-Content -LiteralPath $NextObjectCard -Encoding UTF8

$parkText = @"
# PARK CARD
## COMMAND CENTER UI LANE REVIEW DECISION GATE V1.1

GeneratedUtc: $(Get-UtcNow)
RunStamp: $RunStamp

DecisionGateStatus:
$decisionGateStatus

Decision:
$finalDecision

ErrorCount:
$(@($errors).Count)

ReturnTrigger:
Return when user asks to continue Command Center UI lane review or live-install preparation.

RequiredNextRead:
$CurrentDecisionGateStatusMd

DoesNotProve:
This park card does not approve live install or doctrine promotion.
"@
$parkText | Set-Content -LiteralPath $ParkCard -Encoding UTF8

$statusObj = [pscustomobject]@{
    GeneratedUtc = Get-UtcNow
    RunStamp = $RunStamp
    DecisionGateVersion = "V1.1"
    DecisionGateStatus = $decisionGateStatus
    Decision = $finalDecision
    RequestedDecision = $Decision
    NextLegalObject = $nextLegalObject
    WorkEntryStatus = $workEntryStatus
    EntryOpenSideQuestRequired = $entryOpenSideQuest
    ReviewStatus = $reviewStatus
    ReviewOpenSideQuestRequired = $reviewOpenSideQuest
    ReviewErrorCount = $reviewErrorCount
    ReviewPacket = $reviewPacket
    ReviewPacketResolveMethod = $reviewPacketMethod
    ReviewDecisionCard = $reviewDecisionCard
    ReviewDecisionCardResolveMethod = $reviewDecisionCardMethod
    ErrorCount = @($errors).Count
    RepairFinding = $RepairFinding
    DecisionGatePacket = $DecisionGatePacket
    NextObjectCard = $NextObjectCard
    ParkCard = $ParkCard
    Receipt = $Receipt
    ErrorLedger = $ErrorLedger
    LiveInstallAuthorized = $false
    DoctrinePromotionAuthorized = $false
    LiveInstallGatePreparationAllowed = ($finalDecision -eq "PREPARE_LIVE_INSTALL_GATE")
}

$statusObj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $CurrentDecisionGateStatusJson -Encoding UTF8

$statusMd = @()
$statusMd += "# CURRENT COMMAND CENTER UI LANE REVIEW DECISION GATE STATUS"
$statusMd += ""
$statusMd += "GeneratedUtc: $($statusObj.GeneratedUtc)"
$statusMd += "RunStamp: $RunStamp"
$statusMd += "DecisionGateVersion: V1.1"
$statusMd += "DecisionGateStatus: $decisionGateStatus"
$statusMd += "Decision: $finalDecision"
$statusMd += "RequestedDecision: $Decision"
$statusMd += "NextLegalObject: $nextLegalObject"
$statusMd += "WorkEntryStatus: $workEntryStatus"
$statusMd += "EntryOpenSideQuestRequired: $entryOpenSideQuest"
$statusMd += "ReviewStatus: $reviewStatus"
$statusMd += "ReviewOpenSideQuestRequired: $reviewOpenSideQuest"
$statusMd += "ReviewErrorCount: $reviewErrorCount"
$statusMd += "ReviewPacket: $reviewPacket"
$statusMd += "ReviewPacketResolveMethod: $reviewPacketMethod"
$statusMd += "ReviewDecisionCard: $reviewDecisionCard"
$statusMd += "ReviewDecisionCardResolveMethod: $reviewDecisionCardMethod"
$statusMd += "ErrorCount: $(@($errors).Count)"
$statusMd += ""
$statusMd += "# Repair"
$statusMd += ""
$statusMd += "RepairFinding: $RepairFinding"
$statusMd += "RepairCategory: STATUS_PARSER_SHAPE_MISMATCH"
$statusMd += ""
$statusMd += "# Main Files"
$statusMd += ""
$statusMd += "DecisionGatePacket: $DecisionGatePacket"
$statusMd += "NextObjectCard: $NextObjectCard"
$statusMd += "ParkCard: $ParkCard"
$statusMd += "Receipt: $Receipt"
$statusMd += "ErrorLedger: $ErrorLedger"
$statusMd += ""
$statusMd += "# Authorization Flags"
$statusMd += ""
$statusMd += "LiveInstallAuthorized: false"
$statusMd += "DoctrinePromotionAuthorized: false"
$statusMd += "CleanupAuthorized: false"
$statusMd += "CommitAuthorized: false"
$statusMd += "PushAuthorized: false"
$statusMd += "WatcherAuthorized: false"
$statusMd += "AutomationAuthorized: false"
$statusMd += "LiveInstallGatePreparationAllowed: $livePrepAllowed"
$statusMd += ""
$statusMd += "# Next"
$statusMd += ""
if ($finalDecision -eq "PREPARE_LIVE_INSTALL_GATE") {
    $statusMd += "Next clean move: build COMMAND_CENTER_UI_LANE_LIVE_INSTALL_PREP_GATE_V1."
}
elseif ($finalDecision -eq "REVIEW_ONLY_CONTINUE") {
    $statusMd += "Next clean move: continue review only; do not prepare live install gate yet."
}
elseif ($finalDecision -eq "PARK_FOR_LATER") {
    $statusMd += "Next clean move: keep this lane parked until user returns."
}
else {
    $statusMd += "Next clean move: fix decision gate blockers."
}
$statusMd | Set-Content -LiteralPath $CurrentDecisionGateStatusMd -Encoding UTF8

$receiptText = @"
# RECEIPT
## COMMAND CENTER UI LANE REVIEW DECISION GATE V1.1

Date: $DateTag
GeneratedUtc: $(Get-UtcNow)
RunStamp: $RunStamp

DecisionGateStatus:
$decisionGateStatus

Decision:
$finalDecision

RequestedDecision:
$Decision

NextLegalObject:
$nextLegalObject

WorkEntryStatus:
$workEntryStatus

EntryOpenSideQuestRequired:
$entryOpenSideQuest

ReviewStatus:
$reviewStatus

ReviewOpenSideQuestRequired:
$reviewOpenSideQuest

ReviewErrorCount:
$reviewErrorCount

ReviewPacket:
$reviewPacket

ReviewPacketResolveMethod:
$reviewPacketMethod

ReviewDecisionCard:
$reviewDecisionCard

ReviewDecisionCardResolveMethod:
$reviewDecisionCardMethod

RepairFinding:
$RepairFinding

DecisionGatePacket:
$DecisionGatePacket

NextObjectCard:
$NextObjectCard

ParkCard:
$ParkCard

CurrentDecisionGateStatus:
$CurrentDecisionGateStatusMd

CurrentDecisionGateStatusJson:
$CurrentDecisionGateStatusJson

EntryOutput:
$EntryOutput

ErrorLedger:
$ErrorLedger

ErrorCount:
$(@($errors).Count)

Actions:
$($actions -join "`n")

NoMutationFlags:
LiveCommandCenterInstall: false
DoctrinePromoted: false
PreparedLiveInstallCode: false
DeletedProjectWork: false
ArchivedProjectWork: false
DedupedProjectWork: false
Committed: false
Pushed: false
WatcherInstalled: false
AutomationInstalled: false
OpenedVSCode: false
ClosedVSCode: false

DoesNotProve:
This receipt does not approve live install.
This receipt does not promote doctrine.
This receipt does not authorize cleanup.
"@
$receiptText | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host ""
Write-Host "Command Center UI lane review decision gate V1.1 complete."
Write-Host "DecisionGateStatus:"
Write-Host $decisionGateStatus
Write-Host ""
Write-Host "Decision:"
Write-Host $finalDecision
Write-Host ""
Write-Host "NextLegalObject:"
Write-Host $nextLegalObject
Write-Host ""
Write-Host "WorkEntryStatus:"
Write-Host $workEntryStatus
Write-Host ""
Write-Host "OpenSideQuestRequired:"
Write-Host $entryOpenSideQuest
Write-Host ""
Write-Host "ReviewPacketResolveMethod:"
Write-Host $reviewPacketMethod
Write-Host ""
Write-Host "ReviewDecisionCardResolveMethod:"
Write-Host $reviewDecisionCardMethod
Write-Host ""
Write-Host "Decision gate packet:"
Write-Host $DecisionGatePacket
Write-Host ""
Write-Host "Current decision gate status:"
Write-Host $CurrentDecisionGateStatusMd
Write-Host ""
Write-Host "ErrorCount:"
Write-Host @($errors).Count
Write-Host ""
Write-Host "DONE_MARKER: COMMAND_CENTER_UI_LANE_REVIEW_DECISION_GATE_V1_1_FINALIZED"

