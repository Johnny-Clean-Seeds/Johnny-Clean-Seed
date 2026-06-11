<#
ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER REVIEW PACKET V0.2 20260609
Status: USER_REVIEW_PACKET_BUILDER / READ_ONLY / NO_PHYSICAL_ROUTING

Purpose:
  Repair V0.1 user-review packet builder failure:
  ARGUMENT_TYPES_DO_NOT_MATCH.

Boundary:
  This script does not move, delete, rename, route, execute helper scripts, commit, push, clean, or rewrite source.
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = (Join-Path $env:USERPROFILE 'Desktop\123'),
    [string]$LaneRel = 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606',
    [string]$ExpectedV05ReportSha = '7FF73554A783AF238BAE8C1D9B1FA9BC6359C693FC19ACC890B3BC0C65945543',
    [string]$ExpectedV05ReceiptSha = '83BAF6AA1B48B4BB6B50A5939DC2AB824F032E835E34F781E506B46F71DD8819',
    [string]$ExpectedReviewCardSha = '27EF576560656F28091410B53357A875803ABA2F593930F00BC78BA1606D1FA0',
    [string]$ExpectedReviewReceiptSha = '638973843C45F0950164E92323E820E5D470A3DDF2A77B4F4BB1D661CE5786F5'
)

$ErrorActionPreference = 'Stop'

function Get-Sha256Safe {
    param([string]$Path)
    try {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 'MISSING' }
        return ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash).ToUpperInvariant()
    } catch {
        return ('HASH_READ_FAILED: ' + $_.Exception.Message)
    }
}

function Count-ItemsSafe {
    param([object]$Value)
    if ($null -eq $Value) { return 0 }
    return @($Value).Length
}

function Clean-Cell {
    param([object]$Text)
    if ($null -eq $Text) { return '' }
    $s = ([string]$Text).Trim()
    $s = $s.Trim([char]96)
    return $s.Trim()
}

function Escape-MdCell {
    param([object]$Text)
    if ($null -eq $Text) { return '' }
    $s = [string]$Text
    $s = $s.Replace('|', '&#124;')
    $s = $s.Replace("`r", ' ')
    $s = $s.Replace("`n", ' ')
    return $s
}

function Write-LinesNoBom {
    param(
        [string]$Path,
        [System.Collections.ArrayList]$Lines
    )
    $stringLines = New-Object System.Collections.Generic.List[string]
    foreach ($line in $Lines) { [void]$stringLines.Add([string]$line) }
    $enc = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($Path, $stringLines.ToArray(), $enc)
}

$LanePath = Join-Path $ProjectRoot $LaneRel

$V05ReportPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_20260609.md'
$V05ReceiptPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_RECEIPT_V0_5_20260609.txt'
$ReviewCardPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_V0_2_20260609.md'
$ReviewReceiptPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_RECEIPT_V0_2_20260609.txt'

$ErrorFreezePath = Join-Path $LanePath 'ERROR_FREEZE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_1_ARGUMENT_TYPES_MISMATCH_20260609.md'
$FixNotePath = Join-Path $LanePath 'FIX_NOTE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_2_BORING_PACKET_WRITER_20260609.md'
$FixReceiptPath = Join-Path $LanePath 'HASH_RECEIPT__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_2_FIX_20260609.txt'
$OutPacketPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_2_20260609.md'
$OutReceiptPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_RECEIPT_V0_2_20260609.txt'

if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) { throw ('Project root not found: ' + $ProjectRoot) }
if (-not (Test-Path -LiteralPath $LanePath -PathType Container)) { throw ('Lane path not found: ' + $LanePath) }

foreach ($outPath in @($ErrorFreezePath, $FixNotePath, $FixReceiptPath, $OutPacketPath, $OutReceiptPath)) {
    if (Test-Path -LiteralPath $outPath -PathType Leaf) { throw ('Output already exists. Refusing overwrite: ' + $outPath) }
}

$V05ReportSha = Get-Sha256Safe -Path $V05ReportPath
$V05ReceiptSha = Get-Sha256Safe -Path $V05ReceiptPath
$ReviewCardSha = Get-Sha256Safe -Path $ReviewCardPath
$ReviewReceiptSha = Get-Sha256Safe -Path $ReviewReceiptPath

$V05ReportVerified = ($V05ReportSha -eq $ExpectedV05ReportSha)
$V05ReceiptVerified = ($V05ReceiptSha -eq $ExpectedV05ReceiptSha)
$ReviewCardVerified = ($ReviewCardSha -eq $ExpectedReviewCardSha)
$ReviewReceiptVerified = ($ReviewReceiptSha -eq $ExpectedReviewReceiptSha)

$Blockers = New-Object System.Collections.ArrayList
if (-not $V05ReportVerified) { [void]$Blockers.Add('V0_5_REPORT_HASH_MISMATCH_OR_MISSING') }
if (-not $V05ReceiptVerified) { [void]$Blockers.Add('V0_5_RECEIPT_HASH_MISMATCH_OR_MISSING') }
if (-not $ReviewCardVerified) { [void]$Blockers.Add('V0_5_REVIEW_CARD_HASH_MISMATCH_OR_MISSING') }
if (-not $ReviewReceiptVerified) { [void]$Blockers.Add('V0_5_REVIEW_RECEIPT_HASH_MISMATCH_OR_MISSING') }

$Tickets = New-Object System.Collections.ArrayList
$ReportRaw = ''
if (Test-Path -LiteralPath $V05ReportPath -PathType Leaf) {
    $ReportRaw = [System.IO.File]::ReadAllText($V05ReportPath)
    $ReportLines = [System.IO.File]::ReadAllLines($V05ReportPath)
    foreach ($line in $ReportLines) {
        $trimmed = ([string]$line).Trim()
        if (-not $trimmed.StartsWith('| RHG-DRY-')) { continue }
        $parts = $trimmed.Split('|')
        if (@($parts).Length -lt 11) { continue }
        $ticket = [pscustomobject]@{
            TicketID = Clean-Cell $parts[1]
            FileName = Clean-Cell $parts[2]
            DeltaStatus = Clean-Cell $parts[3]
            RoleLabel = Clean-Cell $parts[4]
            StateLabel = Clean-Cell $parts[5]
            RiskLabel = Clean-Cell $parts[6]
            ConfidenceLabel = Clean-Cell $parts[7]
            ProposalLabel = Clean-Cell $parts[8]
            UserDecisionNeeded = Clean-Cell $parts[9]
            ActionNow = Clean-Cell $parts[10]
        }
        [void]$Tickets.Add($ticket)
    }
} else {
    [void]$Blockers.Add('V0_5_REPORT_FILE_NOT_FOUND')
}

$ActionNowNonNo = New-Object System.Collections.ArrayList
$SystemLeave = New-Object System.Collections.ArrayList
$HelperReview = New-Object System.Collections.ArrayList
$HighOrBlockedRisk = New-Object System.Collections.ArrayList
$UserDecisionRows = New-Object System.Collections.ArrayList
$NonSystemRows = New-Object System.Collections.ArrayList

foreach ($ticket in $Tickets) {
    if ($ticket.ActionNow -ne 'NO') { [void]$ActionNowNonNo.Add($ticket) }
    if ($ticket.RoleLabel -eq 'SYSTEM_FILE_LEAVE_IN_PLACE') { [void]$SystemLeave.Add($ticket) }
    if ($ticket.RoleLabel -eq 'EXECUTABLE_HELPER_REVIEW_REQUIRED') { [void]$HelperReview.Add($ticket) }
    if (($ticket.RiskLabel -like 'HIGH_*') -or ($ticket.RiskLabel -like 'BLOCKED_*')) { [void]$HighOrBlockedRisk.Add($ticket) }
    if ($ticket.UserDecisionNeeded -eq 'YES') { [void]$UserDecisionRows.Add($ticket) }
    if ($ticket.RoleLabel -ne 'SYSTEM_FILE_LEAVE_IN_PLACE') { [void]$NonSystemRows.Add($ticket) }
}

$TicketCount = Count-ItemsSafe $Tickets
if ($TicketCount -eq 0) { [void]$Blockers.Add('NO_TICKETS_PARSED_FROM_V0_5_REPORT') }
if ((Count-ItemsSafe $ActionNowNonNo) -gt 0) { [void]$Blockers.Add('ACTION_NOW_NON_NO_ROWS_FOUND') }

$ParserDisabledSignal = $false
if ($ReportRaw.Contains('parser disabled') -or $ReportRaw.Contains('PARSER') -or $ReportRaw.Contains('conservative')) { $ParserDisabledSignal = $true }
if (-not $ParserDisabledSignal) { [void]$Blockers.Add('PARSER_DISABLED_OR_CONSERVATIVE_SIGNAL_NOT_FOUND') }

$BlockerCount = Count-ItemsSafe $Blockers
$NextSingleAction = 'USER_REVIEWS_PACKET_AND_MARKS_EACH_NON_SYSTEM_ROW_HOLD_REVIEW_OR_LATER_APPROVED_ROW_CANDIDATE_NO_MOVEMENT_NOW'
$FinalVerdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION'
if ($BlockerCount -gt 0) { $FinalVerdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_2_WRITTEN_WITH_BLOCKERS_REVIEW_REQUIRED' }

$Freeze = New-Object System.Collections.ArrayList
[void]$Freeze.Add('# ERROR FREEZE - V0.5 USER REVIEW PACKET V0.1 ARGUMENT TYPES MISMATCH')
[void]$Freeze.Add('')
[void]$Freeze.Add('Status: ERROR_FREEZE / GENERATED_RUNNER_DEFECT / NOT_PROJECT_FAILURE')
[void]$Freeze.Add('Date: 2026-06-09')
[void]$Freeze.Add('')
[void]$Freeze.Add('Failed object: BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_20260609.ps1')
[void]$Freeze.Add('Observed failure: Argument types do not match.')
[void]$Freeze.Add('Failure interpretation: user-review packet builder used a brittle writer shape. This is a script defect, not a V0.5 report failure and not route authorization.')
[void]$Freeze.Add('Physical actions performed by failed packet builder: 0')
[void]$Freeze.Add('DoesNotProve: This freeze does not prove route, cleanup, parser repair, movement, commit, or push is approved.')
Write-LinesNoBom -Path $ErrorFreezePath -Lines $Freeze
$ErrorFreezeSha = Get-Sha256Safe -Path $ErrorFreezePath

$Fix = New-Object System.Collections.ArrayList
[void]$Fix.Add('# FIX NOTE - V0.5 USER REVIEW PACKET V0.2 BORING PACKET WRITER')
[void]$Fix.Add('')
[void]$Fix.Add('Status: FIX_NOTE / SAME_OBJECT_REPAIR / READ_ONLY')
[void]$Fix.Add('Date: 2026-06-09')
[void]$Fix.Add('')
[void]$Fix.Add('Repair: replaced the fragile review table writer with a boring inline packet writer using ArrayList line collection and no array-shaped table-writer parameters.')
[void]$Fix.Add('Kept boundary: no move, delete, rename, route, execute, commit, push, cleanup, source rewrite, or doctrine promotion.')
[void]$Fix.Add('DoesNotProve: This fix note does not approve row movement or parser repair.')
Write-LinesNoBom -Path $FixNotePath -Lines $Fix
$FixNoteSha = Get-Sha256Safe -Path $FixNotePath

$Packet = New-Object System.Collections.ArrayList
[void]$Packet.Add('# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER REVIEW PACKET V0.2 20260609')
[void]$Packet.Add('')
[void]$Packet.Add('Status: USER_REVIEW_PACKET / READ_ONLY / NOT_ROUTE_ORDER / NOT_CLEANUP_ORDER / NOT_EXECUTION_AUTHORITY')
[void]$Packet.Add('Date: 2026-06-09')
[void]$Packet.Add('')
[void]$Packet.Add('## 1. Active Object')
[void]$Packet.Add('')
[void]$Packet.Add('USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608')
[void]$Packet.Add('')
[void]$Packet.Add('## 2. Purpose')
[void]$Packet.Add('')
[void]$Packet.Add('This packet makes the V0.5 conservative live-root receptionist board easier for the user to review.')
[void]$Packet.Add('It does not repair the removed route-plan parser, does not create approved movement rows, and does not execute routes.')
[void]$Packet.Add('')
[void]$Packet.Add('## 3. Verified Inputs')
[void]$Packet.Add('')
[void]$Packet.Add('| Object | Path | Expected SHA256 | Actual SHA256 | Verified |')
[void]$Packet.Add('|---|---|---|---|---|')
[void]$Packet.Add('| V0.5 report | ' + (Escape-MdCell $V05ReportPath) + ' | ' + $ExpectedV05ReportSha + ' | ' + $V05ReportSha + ' | ' + $V05ReportVerified + ' |')
[void]$Packet.Add('| V0.5 receipt | ' + (Escape-MdCell $V05ReceiptPath) + ' | ' + $ExpectedV05ReceiptSha + ' | ' + $V05ReceiptSha + ' | ' + $V05ReceiptVerified + ' |')
[void]$Packet.Add('| V0.5 review card | ' + (Escape-MdCell $ReviewCardPath) + ' | ' + $ExpectedReviewCardSha + ' | ' + $ReviewCardSha + ' | ' + $ReviewCardVerified + ' |')
[void]$Packet.Add('| V0.5 review receipt | ' + (Escape-MdCell $ReviewReceiptPath) + ' | ' + $ExpectedReviewReceiptSha + ' | ' + $ReviewReceiptSha + ' | ' + $ReviewReceiptVerified + ' |')
[void]$Packet.Add('')
[void]$Packet.Add('## 4. Summary Counts')
[void]$Packet.Add('')
[void]$Packet.Add('- ticket_count: ' + $TicketCount)
[void]$Packet.Add('- system_leave_in_place_count: ' + (Count-ItemsSafe $SystemLeave))
[void]$Packet.Add('- helper_review_required_count: ' + (Count-ItemsSafe $HelperReview))
[void]$Packet.Add('- high_or_blocked_risk_count: ' + (Count-ItemsSafe $HighOrBlockedRisk))
[void]$Packet.Add('- user_decision_required_count: ' + (Count-ItemsSafe $UserDecisionRows))
[void]$Packet.Add('- non_system_review_row_count: ' + (Count-ItemsSafe $NonSystemRows))
[void]$Packet.Add('- action_now_non_no_count: ' + (Count-ItemsSafe $ActionNowNonNo))
[void]$Packet.Add('- parser_disabled_or_conservative_signal_found: ' + $ParserDisabledSignal)
[void]$Packet.Add('')
[void]$Packet.Add('## 5. Blockers')
[void]$Packet.Add('')
if ($BlockerCount -eq 0) {
    [void]$Packet.Add('- NONE')
} else {
    foreach ($b in $Blockers) { [void]$Packet.Add('- ' + (Escape-MdCell $b)) }
}
[void]$Packet.Add('')
[void]$Packet.Add('## 6. User Review Buckets')
[void]$Packet.Add('')
[void]$Packet.Add('| Bucket | Count | Default handling |')
[void]$Packet.Add('|---|---:|---|')
[void]$Packet.Add('| ACTION_NOW_NON_NO | ' + (Count-ItemsSafe $ActionNowNonNo) + ' | BLOCK_AND_REVIEW |')
[void]$Packet.Add('| SYSTEM_FILE_LEAVE_IN_PLACE | ' + (Count-ItemsSafe $SystemLeave) + ' | LEAVE_IN_PLACE |')
[void]$Packet.Add('| EXECUTABLE_HELPER_REVIEW_REQUIRED | ' + (Count-ItemsSafe $HelperReview) + ' | SPECIALIST_HELPER_REVIEW_REQUIRED |')
[void]$Packet.Add('| HIGH_OR_BLOCKED_RISK | ' + (Count-ItemsSafe $HighOrBlockedRisk) + ' | HOLD_OR_BLOCK |')
[void]$Packet.Add('| USER_DECISION_REQUIRED | ' + (Count-ItemsSafe $UserDecisionRows) + ' | USER_MARKS_DECISION |')
[void]$Packet.Add('| NON_SYSTEM_REVIEW_ROWS | ' + (Count-ItemsSafe $NonSystemRows) + ' | HOLD_PENDING_USER_REVIEW |')
[void]$Packet.Add('')
[void]$Packet.Add('## 7. Full Parsed Ticket Table')
[void]$Packet.Add('')
if ($TicketCount -eq 0) {
    [void]$Packet.Add('- NO TICKETS PARSED')
} else {
    [void]$Packet.Add('| TicketID | FileName | RoleLabel | RiskLabel | ProposalLabel | UserDecisionNeeded | ActionNow | ReviewDefault |')
    [void]$Packet.Add('|---|---|---|---|---|---|---|---|')
    foreach ($t in $Tickets) {
        $reviewDefault = 'HOLD_PENDING_USER_REVIEW'
        if ($t.RoleLabel -eq 'SYSTEM_FILE_LEAVE_IN_PLACE') { $reviewDefault = 'LEAVE_IN_PLACE' }
        elseif ($t.RoleLabel -eq 'EXECUTABLE_HELPER_REVIEW_REQUIRED') { $reviewDefault = 'SPECIALIST_HELPER_REVIEW_REQUIRED' }
        elseif ($t.RiskLabel -like 'HIGH_*') { $reviewDefault = 'HIGH_RISK_HOLD' }
        elseif ($t.RiskLabel -like 'BLOCKED_*') { $reviewDefault = 'BLOCKED_HOLD' }
        $row = '| ' + (Escape-MdCell $t.TicketID) + ' | ' + (Escape-MdCell $t.FileName) + ' | ' + (Escape-MdCell $t.RoleLabel) + ' | ' + (Escape-MdCell $t.RiskLabel) + ' | ' + (Escape-MdCell $t.ProposalLabel) + ' | ' + (Escape-MdCell $t.UserDecisionNeeded) + ' | ' + (Escape-MdCell $t.ActionNow) + ' | ' + (Escape-MdCell $reviewDefault) + ' |'
        [void]$Packet.Add($row)
    }
}
[void]$Packet.Add('')
[void]$Packet.Add('## 8. Review Rule')
[void]$Packet.Add('')
[void]$Packet.Add('Default decision for every non-system row is HOLD_PENDING_USER_REVIEW.')
[void]$Packet.Add('A row may become a later approved-row candidate only after the user explicitly marks it. This packet itself approves zero rows.')
[void]$Packet.Add('')
[void]$Packet.Add('## 9. Current Blocked Actions')
[void]$Packet.Add('')
foreach ($blocked in @('move','delete','rename','route','execute helper scripts','commit','push','cleanup','source rewrite','doctrine promotion')) { [void]$Packet.Add('- ' + $blocked) }
[void]$Packet.Add('')
[void]$Packet.Add('## 10. Next Single Action')
[void]$Packet.Add('')
[void]$Packet.Add($NextSingleAction)
[void]$Packet.Add('')
[void]$Packet.Add('Plain meaning: review the rows and mark decisions. Do not route anything now.')
[void]$Packet.Add('')
[void]$Packet.Add('## 11. DoesNotProve')
[void]$Packet.Add('')
[void]$Packet.Add('This packet proves only that the V0.5 board was read into a user-review shape and that no physical action was authorized or performed by this script.')
[void]$Packet.Add('It does not prove any file should move, any destination is approved, cleanup is safe, helper scripts are executable, Git import is approved, or the project is complete.')
[void]$Packet.Add('')
[void]$Packet.Add('## 12. Scoped Verdict')
[void]$Packet.Add('')
[void]$Packet.Add($FinalVerdict)

Write-LinesNoBom -Path $OutPacketPath -Lines $Packet
$OutPacketSha = Get-Sha256Safe -Path $OutPacketPath

$FixReceipt = New-Object System.Collections.ArrayList
[void]$FixReceipt.Add('HASH_RECEIPT__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_2_FIX_20260609')
[void]$FixReceipt.Add('created_at: ' + (Get-Date -Format o))
[void]$FixReceipt.Add('error_freeze_path: ' + $ErrorFreezePath)
[void]$FixReceipt.Add('error_freeze_sha256: ' + $ErrorFreezeSha)
[void]$FixReceipt.Add('fix_note_path: ' + $FixNotePath)
[void]$FixReceipt.Add('fix_note_sha256: ' + $FixNoteSha)
[void]$FixReceipt.Add('output_packet_path: ' + $OutPacketPath)
[void]$FixReceipt.Add('output_packet_sha256: ' + $OutPacketSha)
[void]$FixReceipt.Add('physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0')
Write-LinesNoBom -Path $FixReceiptPath -Lines $FixReceipt
$FixReceiptSha = Get-Sha256Safe -Path $FixReceiptPath

$Receipt = New-Object System.Collections.ArrayList
[void]$Receipt.Add('ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_RECEIPT_V0_2_20260609')
[void]$Receipt.Add('created_at: ' + (Get-Date -Format o))
[void]$Receipt.Add('output_packet_path: ' + $OutPacketPath)
[void]$Receipt.Add('output_packet_sha256: ' + $OutPacketSha)
[void]$Receipt.Add('output_receipt_path: ' + $OutReceiptPath)
[void]$Receipt.Add('v0_5_report_verified: ' + $V05ReportVerified)
[void]$Receipt.Add('v0_5_receipt_verified: ' + $V05ReceiptVerified)
[void]$Receipt.Add('review_card_verified: ' + $ReviewCardVerified)
[void]$Receipt.Add('review_receipt_verified: ' + $ReviewReceiptVerified)
[void]$Receipt.Add('ticket_count: ' + $TicketCount)
[void]$Receipt.Add('system_leave_in_place_count: ' + (Count-ItemsSafe $SystemLeave))
[void]$Receipt.Add('helper_review_required_count: ' + (Count-ItemsSafe $HelperReview))
[void]$Receipt.Add('high_or_blocked_risk_count: ' + (Count-ItemsSafe $HighOrBlockedRisk))
[void]$Receipt.Add('user_decision_required_count: ' + (Count-ItemsSafe $UserDecisionRows))
[void]$Receipt.Add('action_now_non_no_count: ' + (Count-ItemsSafe $ActionNowNonNo))
[void]$Receipt.Add('blocker_count: ' + $BlockerCount)
[void]$Receipt.Add('next_single_action: ' + $NextSingleAction)
[void]$Receipt.Add('physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0')
[void]$Receipt.Add('final_verdict: ' + $FinalVerdict)
Write-LinesNoBom -Path $OutReceiptPath -Lines $Receipt
$OutReceiptSha = Get-Sha256Safe -Path $OutReceiptPath

Write-Host '=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER REVIEW PACKET V0.2 COMPLETE ==='
Write-Host ('error_freeze_path: ' + $ErrorFreezePath)
Write-Host ('error_freeze_sha256: ' + $ErrorFreezeSha)
Write-Host ('fix_note_path: ' + $FixNotePath)
Write-Host ('fix_note_sha256: ' + $FixNoteSha)
Write-Host ('fix_receipt_path: ' + $FixReceiptPath)
Write-Host ('fix_receipt_sha256: ' + $FixReceiptSha)
Write-Host ('output_packet_path: ' + $OutPacketPath)
Write-Host ('output_packet_sha256: ' + $OutPacketSha)
Write-Host ('output_receipt_path: ' + $OutReceiptPath)
Write-Host ('output_receipt_sha256: ' + $OutReceiptSha)
Write-Host ('ticket_count: ' + $TicketCount)
Write-Host ('system_leave_in_place_count: ' + (Count-ItemsSafe $SystemLeave))
Write-Host ('helper_review_required_count: ' + (Count-ItemsSafe $HelperReview))
Write-Host ('high_or_blocked_risk_count: ' + (Count-ItemsSafe $HighOrBlockedRisk))
Write-Host ('user_decision_required_count: ' + (Count-ItemsSafe $UserDecisionRows))
Write-Host ('action_now_non_no_count: ' + (Count-ItemsSafe $ActionNowNonNo))
Write-Host ('blocker_count: ' + $BlockerCount)
Write-Host ('next_single_action: ' + $NextSingleAction)
Write-Host ('final_verdict: ' + $FinalVerdict)
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
