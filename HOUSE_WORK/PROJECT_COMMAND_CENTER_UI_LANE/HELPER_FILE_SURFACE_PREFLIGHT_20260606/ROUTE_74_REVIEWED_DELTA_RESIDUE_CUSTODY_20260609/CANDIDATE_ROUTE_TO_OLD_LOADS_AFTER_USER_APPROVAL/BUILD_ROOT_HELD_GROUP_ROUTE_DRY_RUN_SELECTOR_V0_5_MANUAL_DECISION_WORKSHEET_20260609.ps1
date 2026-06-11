<#
ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 MANUAL DECISION WORKSHEET 20260609
Status: USER_DECISION_WORKSHEET_BUILDER / READ_ONLY / NO_PHYSICAL_ROUTING

Purpose:
  Build an editable review worksheet from the verified V0.5 user-review packet.

Boundary:
  This script does not move, delete, rename, route, execute helper scripts, commit, push, clean, or rewrite source.
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = (Join-Path $env:USERPROFILE 'Desktop\123'),
    [string]$LaneRel = 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606',
    [string]$ExpectedPacketSha = '38D59D51507A5869B821CAD8834DC5EF38B2720EDFC044D49EC8A4772A3F2328',
    [string]$ExpectedPacketReceiptSha = '8C8EAB1472271BEC433FE4E2779BC1624EFC255C9D178EF47B2C16574AFF70D5'
)

$ErrorActionPreference = 'Stop'

function GetSha256Safe($Path) {
    try {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 'MISSING' }
        return ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash).ToUpperInvariant()
    } catch {
        return ('HASH_READ_FAILED: ' + $_.Exception.Message)
    }
}

function CountSafe($Value) {
    if ($null -eq $Value) { return 0 }
    return @($Value).Length
}

function CleanCell($Text) {
    if ($null -eq $Text) { return '' }
    $s = ([string]$Text).Trim()
    $s = $s.Trim([char]96)
    return $s.Trim()
}

function EscapeMd($Text) {
    if ($null -eq $Text) { return '' }
    $s = [string]$Text
    $s = $s.Replace('|', '&#124;')
    $s = $s.Replace("`r", ' ')
    $s = $s.Replace("`n", ' ')
    return $s
}

function CsvCell($Text) {
    if ($null -eq $Text) { return '""' }
    $s = [string]$Text
    $s = $s.Replace('"', '""')
    return ('"' + $s + '"')
}

function WriteLines($Path, $Lines) {
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($line in $Lines) { [void]$out.Add([string]$line) }
    $enc = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($Path, $out.ToArray(), $enc)
}

$LanePath = Join-Path $ProjectRoot $LaneRel
$PacketPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_V0_2_20260609.md'
$PacketReceiptPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_RECEIPT_V0_2_20260609.txt'

$OutWorksheetMdPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_20260609.md'
$OutWorksheetCsvPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_20260609.csv'
$OutReceiptPath = Join-Path $LanePath 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_RECEIPT_20260609.txt'

if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) { throw ('Project root not found: ' + $ProjectRoot) }
if (-not (Test-Path -LiteralPath $LanePath -PathType Container)) { throw ('Lane path not found: ' + $LanePath) }
foreach ($p in @($OutWorksheetMdPath, $OutWorksheetCsvPath, $OutReceiptPath)) {
    if (Test-Path -LiteralPath $p -PathType Leaf) { throw ('Output already exists. Refusing overwrite: ' + $p) }
}

$PacketSha = GetSha256Safe $PacketPath
$PacketReceiptSha = GetSha256Safe $PacketReceiptPath
$PacketVerified = ($PacketSha -eq $ExpectedPacketSha)
$PacketReceiptVerified = ($PacketReceiptSha -eq $ExpectedPacketReceiptSha)

$Blockers = New-Object System.Collections.ArrayList
if (-not $PacketVerified) { [void]$Blockers.Add('USER_REVIEW_PACKET_HASH_MISMATCH_OR_MISSING') }
if (-not $PacketReceiptVerified) { [void]$Blockers.Add('USER_REVIEW_PACKET_RECEIPT_HASH_MISMATCH_OR_MISSING') }

$Tickets = New-Object System.Collections.ArrayList
if (Test-Path -LiteralPath $PacketPath -PathType Leaf) {
    $packetLines = [System.IO.File]::ReadAllLines($PacketPath)
    foreach ($line in $packetLines) {
        $trimmed = ([string]$line).Trim()
        if (-not $trimmed.StartsWith('| RHG-DRY-')) { continue }
        $parts = $trimmed.Split('|')
        if ((CountSafe $parts) -lt 9) { continue }
        $ticket = [pscustomobject]@{
            TicketID = CleanCell $parts[1]
            FileName = CleanCell $parts[2]
            RoleLabel = CleanCell $parts[3]
            RiskLabel = CleanCell $parts[4]
            ProposalLabel = CleanCell $parts[5]
            UserDecisionNeeded = CleanCell $parts[6]
            ActionNow = CleanCell $parts[7]
            ReviewDefault = CleanCell $parts[8]
        }
        [void]$Tickets.Add($ticket)
    }
} else {
    [void]$Blockers.Add('USER_REVIEW_PACKET_FILE_NOT_FOUND')
}

$TicketCount = CountSafe $Tickets
if ($TicketCount -eq 0) { [void]$Blockers.Add('NO_TICKETS_PARSED_FROM_USER_REVIEW_PACKET') }

$SystemCount = 0
$NonSystemCount = 0
$HelperCount = 0
$HighRiskCount = 0
$ActionNowNonNoCount = 0
foreach ($t in $Tickets) {
    if ($t.RoleLabel -eq 'SYSTEM_FILE_LEAVE_IN_PLACE') { $SystemCount++ } else { $NonSystemCount++ }
    if ($t.RoleLabel -eq 'EXECUTABLE_HELPER_REVIEW_REQUIRED') { $HelperCount++ }
    if (($t.RiskLabel -like 'HIGH_*') -or ($t.RiskLabel -like 'BLOCKED_*')) { $HighRiskCount++ }
    if ($t.ActionNow -ne 'NO') { $ActionNowNonNoCount++ }
}
if ($ActionNowNonNoCount -gt 0) { [void]$Blockers.Add('ACTION_NOW_NON_NO_ROWS_FOUND') }

$BlockerCount = CountSafe $Blockers
$NextSingleAction = 'USER_OPENS_WORKSHEET_AND_MARKS_USER_DECISION_COLUMN_WITH_HOLD_REVIEW_LATER_APPROVED_ROW_CANDIDATE_OR_BLOCK_NO_MOVEMENT_NOW'
$FinalVerdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_WRITTEN_WITH_NO_PHYSICAL_ACTION'
if ($BlockerCount -gt 0) { $FinalVerdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_WRITTEN_WITH_BLOCKERS_REVIEW_REQUIRED' }

$Md = New-Object System.Collections.ArrayList
[void]$Md.Add('# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 MANUAL DECISION WORKSHEET 20260609')
[void]$Md.Add('')
[void]$Md.Add('Status: USER_DECISION_WORKSHEET / EDITABLE_REVIEW_SURFACE / NOT_ROUTE_ORDER / NOT_EXECUTION_AUTHORITY')
[void]$Md.Add('Date: 2026-06-09')
[void]$Md.Add('')
[void]$Md.Add('## 1. Purpose')
[void]$Md.Add('')
[void]$Md.Add('This worksheet is the user marking surface for the V0.5 conservative live-root board.')
[void]$Md.Add('It creates no approved movement rows by itself. The user decision column is for review marking only.')
[void]$Md.Add('')
[void]$Md.Add('## 2. Verified Inputs')
[void]$Md.Add('')
[void]$Md.Add('| Object | Path | Expected SHA256 | Actual SHA256 | Verified |')
[void]$Md.Add('|---|---|---|---|---|')
[void]$Md.Add('| user review packet | ' + (EscapeMd $PacketPath) + ' | ' + $ExpectedPacketSha + ' | ' + $PacketSha + ' | ' + $PacketVerified + ' |')
[void]$Md.Add('| user review packet receipt | ' + (EscapeMd $PacketReceiptPath) + ' | ' + $ExpectedPacketReceiptSha + ' | ' + $PacketReceiptSha + ' | ' + $PacketReceiptVerified + ' |')
[void]$Md.Add('')
[void]$Md.Add('## 3. Counts')
[void]$Md.Add('')
[void]$Md.Add('- ticket_count: ' + $TicketCount)
[void]$Md.Add('- system_leave_in_place_count: ' + $SystemCount)
[void]$Md.Add('- non_system_review_count: ' + $NonSystemCount)
[void]$Md.Add('- helper_review_required_count: ' + $HelperCount)
[void]$Md.Add('- high_or_blocked_risk_count: ' + $HighRiskCount)
[void]$Md.Add('- action_now_non_no_count: ' + $ActionNowNonNoCount)
[void]$Md.Add('- blocker_count: ' + $BlockerCount)
[void]$Md.Add('')
[void]$Md.Add('## 4. Allowed User Decision Marks')
[void]$Md.Add('')
[void]$Md.Add('Use only these marks for now:')
[void]$Md.Add('')
[void]$Md.Add('- LEAVE_IN_PLACE')
[void]$Md.Add('- HOLD_PENDING_USER_REVIEW')
[void]$Md.Add('- SPECIALIST_HELPER_REVIEW_REQUIRED')
[void]$Md.Add('- BLOCK_DO_NOT_TOUCH')
[void]$Md.Add('- LATER_APPROVED_ROW_CANDIDATE')
[void]$Md.Add('- NEEDS_MORE_INFO')
[void]$Md.Add('')
[void]$Md.Add('Important: LATER_APPROVED_ROW_CANDIDATE is not movement approval. It only marks a row for a later approved-row selector.')
[void]$Md.Add('')
[void]$Md.Add('## 5. Blockers')
[void]$Md.Add('')
if ($BlockerCount -eq 0) { [void]$Md.Add('- NONE') } else { foreach ($b in $Blockers) { [void]$Md.Add('- ' + (EscapeMd $b)) } }
[void]$Md.Add('')
[void]$Md.Add('## 6. Decision Table')
[void]$Md.Add('')
if ($TicketCount -eq 0) {
    [void]$Md.Add('- NO TICKETS PARSED')
} else {
    [void]$Md.Add('| TicketID | FileName | RoleLabel | RiskLabel | ReviewDefault | UserDecision | UserNote |')
    [void]$Md.Add('|---|---|---|---|---|---|---|')
    foreach ($t in $Tickets) {
        $defaultDecision = $t.ReviewDefault
        if ($t.RoleLabel -eq 'SYSTEM_FILE_LEAVE_IN_PLACE') { $defaultDecision = 'LEAVE_IN_PLACE' }
        $row = '| ' + (EscapeMd $t.TicketID) + ' | ' + (EscapeMd $t.FileName) + ' | ' + (EscapeMd $t.RoleLabel) + ' | ' + (EscapeMd $t.RiskLabel) + ' | ' + (EscapeMd $t.ReviewDefault) + ' | ' + (EscapeMd $defaultDecision) + ' |  |'
        [void]$Md.Add($row)
    }
}
[void]$Md.Add('')
[void]$Md.Add('## 7. Blocked Actions')
[void]$Md.Add('')
foreach ($b in @('move','delete','rename','route','execute helper scripts','commit','push','cleanup','source rewrite','doctrine promotion')) { [void]$Md.Add('- ' + $b) }
[void]$Md.Add('')
[void]$Md.Add('## 8. Next Single Action')
[void]$Md.Add('')
[void]$Md.Add($NextSingleAction)
[void]$Md.Add('')
[void]$Md.Add('## 9. DoesNotProve')
[void]$Md.Add('')
[void]$Md.Add('This worksheet proves only that a user marking surface was created from the V0.5 review packet.')
[void]$Md.Add('It does not prove movement, cleanup, parser repair, executor build, Git import, commit, push, or project completion is approved.')
[void]$Md.Add('')
[void]$Md.Add('## 10. Scoped Verdict')
[void]$Md.Add('')
[void]$Md.Add($FinalVerdict)

WriteLines $OutWorksheetMdPath $Md
$WorksheetMdSha = GetSha256Safe $OutWorksheetMdPath

$Csv = New-Object System.Collections.ArrayList
[void]$Csv.Add('TicketID,FileName,RoleLabel,RiskLabel,ReviewDefault,UserDecision,UserNote')
foreach ($t in $Tickets) {
    $defaultDecision = $t.ReviewDefault
    if ($t.RoleLabel -eq 'SYSTEM_FILE_LEAVE_IN_PLACE') { $defaultDecision = 'LEAVE_IN_PLACE' }
    $csvRow = (CsvCell $t.TicketID) + ',' + (CsvCell $t.FileName) + ',' + (CsvCell $t.RoleLabel) + ',' + (CsvCell $t.RiskLabel) + ',' + (CsvCell $t.ReviewDefault) + ',' + (CsvCell $defaultDecision) + ',' + (CsvCell '')
    [void]$Csv.Add($csvRow)
}
WriteLines $OutWorksheetCsvPath $Csv
$WorksheetCsvSha = GetSha256Safe $OutWorksheetCsvPath

$Receipt = New-Object System.Collections.ArrayList
[void]$Receipt.Add('ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_RECEIPT_20260609')
[void]$Receipt.Add('created_at: ' + (Get-Date -Format o))
[void]$Receipt.Add('packet_path: ' + $PacketPath)
[void]$Receipt.Add('packet_sha256: ' + $PacketSha)
[void]$Receipt.Add('packet_verified: ' + $PacketVerified)
[void]$Receipt.Add('packet_receipt_path: ' + $PacketReceiptPath)
[void]$Receipt.Add('packet_receipt_sha256: ' + $PacketReceiptSha)
[void]$Receipt.Add('packet_receipt_verified: ' + $PacketReceiptVerified)
[void]$Receipt.Add('output_worksheet_md_path: ' + $OutWorksheetMdPath)
[void]$Receipt.Add('output_worksheet_md_sha256: ' + $WorksheetMdSha)
[void]$Receipt.Add('output_worksheet_csv_path: ' + $OutWorksheetCsvPath)
[void]$Receipt.Add('output_worksheet_csv_sha256: ' + $WorksheetCsvSha)
[void]$Receipt.Add('output_receipt_path: ' + $OutReceiptPath)
[void]$Receipt.Add('ticket_count: ' + $TicketCount)
[void]$Receipt.Add('system_leave_in_place_count: ' + $SystemCount)
[void]$Receipt.Add('non_system_review_count: ' + $NonSystemCount)
[void]$Receipt.Add('helper_review_required_count: ' + $HelperCount)
[void]$Receipt.Add('high_or_blocked_risk_count: ' + $HighRiskCount)
[void]$Receipt.Add('action_now_non_no_count: ' + $ActionNowNonNoCount)
[void]$Receipt.Add('blocker_count: ' + $BlockerCount)
[void]$Receipt.Add('next_single_action: ' + $NextSingleAction)
[void]$Receipt.Add('physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0')
[void]$Receipt.Add('final_verdict: ' + $FinalVerdict)
WriteLines $OutReceiptPath $Receipt
$ReceiptSha = GetSha256Safe $OutReceiptPath

Write-Host '=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 MANUAL DECISION WORKSHEET COMPLETE ==='
Write-Host ('output_worksheet_md_path: ' + $OutWorksheetMdPath)
Write-Host ('output_worksheet_md_sha256: ' + $WorksheetMdSha)
Write-Host ('output_worksheet_csv_path: ' + $OutWorksheetCsvPath)
Write-Host ('output_worksheet_csv_sha256: ' + $WorksheetCsvSha)
Write-Host ('output_receipt_path: ' + $OutReceiptPath)
Write-Host ('output_receipt_sha256: ' + $ReceiptSha)
Write-Host ('packet_verified: ' + $PacketVerified)
Write-Host ('packet_receipt_verified: ' + $PacketReceiptVerified)
Write-Host ('ticket_count: ' + $TicketCount)
Write-Host ('system_leave_in_place_count: ' + $SystemCount)
Write-Host ('non_system_review_count: ' + $NonSystemCount)
Write-Host ('helper_review_required_count: ' + $HelperCount)
Write-Host ('high_or_blocked_risk_count: ' + $HighRiskCount)
Write-Host ('action_now_non_no_count: ' + $ActionNowNonNoCount)
Write-Host ('blocker_count: ' + $BlockerCount)
Write-Host ('next_single_action: ' + $NextSingleAction)
Write-Host ('final_verdict: ' + $FinalVerdict)
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
