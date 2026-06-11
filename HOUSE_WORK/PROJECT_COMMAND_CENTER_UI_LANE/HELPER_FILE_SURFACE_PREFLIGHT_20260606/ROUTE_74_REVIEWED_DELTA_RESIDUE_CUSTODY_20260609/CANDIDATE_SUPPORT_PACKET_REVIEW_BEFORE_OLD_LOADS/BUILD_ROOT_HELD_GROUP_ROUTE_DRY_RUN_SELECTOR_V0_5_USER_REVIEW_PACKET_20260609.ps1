<#
ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER REVIEW PACKET 20260609
Status: USER_REVIEW_PACKET_BUILDER / READ_ONLY / NO_PHYSICAL_ROUTING

Purpose:
  Read the verified V0.5 conservative live-root board and produce a smaller user-review packet.
  This does not repair the removed parser and does not create an executor.

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

$V05ReportName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_20260609.md'
$V05ReceiptName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_RECEIPT_V0_5_20260609.txt'
$ReviewCardName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_V0_2_20260609.md'
$ReviewReceiptName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_RECEIPT_V0_2_20260609.txt'
$OutPacketName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_20260609.md'
$OutReceiptName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_RECEIPT_20260609.txt'

function Count-Items($Value) {
    if ($null -eq $Value) { return 0 }
    return @($Value).Length
}

function Add-Line($List, $Text) {
    [void]$List.Add([string]$Text)
}

function Escape-Md($Text) {
    if ($null -eq $Text) { return '' }
    $s = [string]$Text
    $s = $s.Replace('|', '\|')
    $s = $s.Replace("`r", ' ')
    $s = $s.Replace("`n", ' ')
    return $s
}

function Clean-Cell($Text) {
    if ($null -eq $Text) { return '' }
    $s = ([string]$Text).Trim()
    $s = $s.Trim([char]96)
    return $s.Trim()
}

function Get-Sha256Safe($Path) {
    try {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 'MISSING' }
        return ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash).ToUpperInvariant()
    } catch {
        return ('HASH_READ_FAILED: ' + $_.Exception.Message)
    }
}

function Write-Utf8NoBom($Path, $Lines) {
    $enc = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($Path, [string[]]@($Lines), $enc)
}

function Add-RowsTable($Lines, $Rows, $Title, $EmptyLine) {
    Add-Line $Lines ('### ' + $Title)
    Add-Line $Lines ''
    $rowCount = Count-Items $Rows
    if ($rowCount -eq 0) {
        Add-Line $Lines $EmptyLine
        Add-Line $Lines ''
        return
    }
    Add-Line $Lines '| TicketID | FileName | RoleLabel | RiskLabel | ProposalLabel | UserDecisionNeeded | ActionNow | ReviewDefault |'
    Add-Line $Lines '|---|---|---|---|---|---|---|---|'
    foreach ($r in @($Rows)) {
        $reviewDefault = 'HOLD_PENDING_USER_REVIEW'
        if ($r.RoleLabel -eq 'SYSTEM_FILE_LEAVE_IN_PLACE') { $reviewDefault = 'LEAVE_IN_PLACE' }
        elseif ($r.RoleLabel -eq 'EXECUTABLE_HELPER_REVIEW_REQUIRED') { $reviewDefault = 'SPECIALIST_HELPER_REVIEW_REQUIRED' }
        elseif ($r.RiskLabel -like 'HIGH_*') { $reviewDefault = 'HIGH_RISK_HOLD' }
        elseif ($r.RiskLabel -like 'BLOCKED_*') { $reviewDefault = 'BLOCKED_HOLD' }
        Add-Line $Lines ('| ' + (Escape-Md $r.TicketID) + ' | `' + (Escape-Md $r.FileName) + '` | ' + (Escape-Md $r.RoleLabel) + ' | ' + (Escape-Md $r.RiskLabel) + ' | ' + (Escape-Md $r.ProposalLabel) + ' | ' + (Escape-Md $r.UserDecisionNeeded) + ' | ' + (Escape-Md $r.ActionNow) + ' | ' + (Escape-Md $reviewDefault) + ' |')
    }
    Add-Line $Lines ''
}

$LanePath = Join-Path $ProjectRoot $LaneRel
$V05ReportPath = Join-Path $LanePath $V05ReportName
$V05ReceiptPath = Join-Path $LanePath $V05ReceiptName
$ReviewCardPath = Join-Path $LanePath $ReviewCardName
$ReviewReceiptPath = Join-Path $LanePath $ReviewReceiptName
$OutPacketPath = Join-Path $LanePath $OutPacketName
$OutReceiptPath = Join-Path $LanePath $OutReceiptName

if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) { throw ('Project root not found: ' + $ProjectRoot) }
if (-not (Test-Path -LiteralPath $LanePath -PathType Container)) { throw ('Lane path not found: ' + $LanePath) }
foreach ($outPath in @($OutPacketPath, $OutReceiptPath)) {
    if (Test-Path -LiteralPath $outPath -PathType Leaf) { throw ('Output already exists. Refusing overwrite: ' + $outPath) }
}

$V05ReportSha = Get-Sha256Safe $V05ReportPath
$V05ReceiptSha = Get-Sha256Safe $V05ReceiptPath
$ReviewCardSha = Get-Sha256Safe $ReviewCardPath
$ReviewReceiptSha = Get-Sha256Safe $ReviewReceiptPath

$V05ReportVerified = ($V05ReportSha -eq $ExpectedV05ReportSha)
$V05ReceiptVerified = ($V05ReceiptSha -eq $ExpectedV05ReceiptSha)
$ReviewCardVerified = ($ReviewCardSha -eq $ExpectedReviewCardSha)
$ReviewReceiptVerified = ($ReviewReceiptSha -eq $ExpectedReviewReceiptSha)

$blockers = New-Object System.Collections.Generic.List[string]
if (-not $V05ReportVerified) { [void]$blockers.Add('V0_5_REPORT_HASH_MISMATCH_OR_MISSING') }
if (-not $V05ReceiptVerified) { [void]$blockers.Add('V0_5_RECEIPT_HASH_MISMATCH_OR_MISSING') }
if (-not $ReviewCardVerified) { [void]$blockers.Add('V0_5_REVIEW_CARD_HASH_MISMATCH_OR_MISSING') }
if (-not $ReviewReceiptVerified) { [void]$blockers.Add('V0_5_REVIEW_RECEIPT_HASH_MISMATCH_OR_MISSING') }

if (-not (Test-Path -LiteralPath $V05ReportPath -PathType Leaf)) { throw ('V0.5 report not found: ' + $V05ReportPath) }
$reportLines = @([System.IO.File]::ReadAllLines($V05ReportPath))
$reportRaw = [System.IO.File]::ReadAllText($V05ReportPath)

$tickets = New-Object System.Collections.Generic.List[object]
foreach ($line in $reportLines) {
    $trimmed = ([string]$line).Trim()
    if (-not $trimmed.StartsWith('| RHG-DRY-')) { continue }
    $parts = @($trimmed.Split('|'))
    if ((Count-Items $parts) -lt 11) { continue }
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
    [void]$tickets.Add($ticket)
}

$ticketCount = Count-Items $tickets
if ($ticketCount -eq 0) { [void]$blockers.Add('NO_TICKETS_PARSED_FROM_V0_5_REPORT') }

$actionNowNonNo = @($tickets | Where-Object { $_.ActionNow -ne 'NO' })
$systemLeave = @($tickets | Where-Object { $_.RoleLabel -eq 'SYSTEM_FILE_LEAVE_IN_PLACE' })
$helperReview = @($tickets | Where-Object { $_.RoleLabel -eq 'EXECUTABLE_HELPER_REVIEW_REQUIRED' })
$highOrBlockedRisk = @($tickets | Where-Object { $_.RiskLabel -like 'HIGH_*' -or $_.RiskLabel -like 'BLOCKED_*' })
$userDecisionRows = @($tickets | Where-Object { $_.UserDecisionNeeded -eq 'YES' })
$nonSystemRows = @($tickets | Where-Object { $_.RoleLabel -ne 'SYSTEM_FILE_LEAVE_IN_PLACE' })

if ((Count-Items $actionNowNonNo) -gt 0) { [void]$blockers.Add('ACTION_NOW_NON_NO_ROWS_FOUND') }

$parserDisabledSignal = $false
if ($reportRaw.Contains('parser disabled') -or $reportRaw.Contains('PARSER') -or $reportRaw.Contains('conservative')) { $parserDisabledSignal = $true }
if (-not $parserDisabledSignal) { [void]$blockers.Add('PARSER_DISABLED_OR_CONSERVATIVE_SIGNAL_NOT_FOUND') }

$blockerCount = Count-Items $blockers
$nextSingleAction = 'USER_REVIEWS_PACKET_AND_MARKS_EACH_NON_SYSTEM_ROW_HOLD_REVIEW_OR_LATER_APPROVED_ROW_CANDIDATE_NO_MOVEMENT_NOW'
$finalVerdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_WRITTEN_WITH_NO_PHYSICAL_ACTION'
if ($blockerCount -gt 0) { $finalVerdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_WRITTEN_WITH_BLOCKERS_REVIEW_REQUIRED' }

$packet = New-Object System.Collections.Generic.List[string]
Add-Line $packet '# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER REVIEW PACKET 20260609'
Add-Line $packet ''
Add-Line $packet 'Status: USER_REVIEW_PACKET / READ_ONLY / NOT_ROUTE_ORDER / NOT_CLEANUP_ORDER / NOT_EXECUTION_AUTHORITY'
Add-Line $packet 'Date: 2026-06-09'
Add-Line $packet ''
Add-Line $packet '## 1. Active Object'
Add-Line $packet ''
Add-Line $packet 'USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608'
Add-Line $packet ''
Add-Line $packet '## 2. Purpose'
Add-Line $packet ''
Add-Line $packet 'This packet makes the V0.5 conservative live-root receptionist board easier to review.'
Add-Line $packet ''
Add-Line $packet 'It does not repair the removed route-plan parser, does not create approved movement rows, and does not execute routes.'
Add-Line $packet ''
Add-Line $packet '## 3. Verified Inputs'
Add-Line $packet ''
Add-Line $packet '| Object | Path | Expected SHA256 | Actual SHA256 | Verified |'
Add-Line $packet '|---|---|---|---|---|'
Add-Line $packet ('| V0.5 report | `' + (Escape-Md $V05ReportPath) + '` | ' + $ExpectedV05ReportSha + ' | ' + $V05ReportSha + ' | ' + $V05ReportVerified + ' |')
Add-Line $packet ('| V0.5 receipt | `' + (Escape-Md $V05ReceiptPath) + '` | ' + $ExpectedV05ReceiptSha + ' | ' + $V05ReceiptSha + ' | ' + $V05ReceiptVerified + ' |')
Add-Line $packet ('| V0.5 review card | `' + (Escape-Md $ReviewCardPath) + '` | ' + $ExpectedReviewCardSha + ' | ' + $ReviewCardSha + ' | ' + $ReviewCardVerified + ' |')
Add-Line $packet ('| V0.5 review receipt | `' + (Escape-Md $ReviewReceiptPath) + '` | ' + $ExpectedReviewReceiptSha + ' | ' + $ReviewReceiptSha + ' | ' + $ReviewReceiptVerified + ' |')
Add-Line $packet ''
Add-Line $packet '## 4. Summary Counts'
Add-Line $packet ''
Add-Line $packet ('- ticket_count: ' + $ticketCount)
Add-Line $packet ('- system_leave_in_place_count: ' + (Count-Items $systemLeave))
Add-Line $packet ('- helper_review_required_count: ' + (Count-Items $helperReview))
Add-Line $packet ('- high_or_blocked_risk_count: ' + (Count-Items $highOrBlockedRisk))
Add-Line $packet ('- user_decision_required_count: ' + (Count-Items $userDecisionRows))
Add-Line $packet ('- non_system_review_row_count: ' + (Count-Items $nonSystemRows))
Add-Line $packet ('- action_now_non_no_count: ' + (Count-Items $actionNowNonNo))
Add-Line $packet ('- parser_disabled_or_conservative_signal_found: ' + $parserDisabledSignal)
Add-Line $packet ''
Add-Line $packet '## 5. Blockers'
Add-Line $packet ''
if ($blockerCount -eq 0) {
    Add-Line $packet '- NONE'
} else {
    foreach ($b in @($blockers)) { Add-Line $packet ('- ' + (Escape-Md $b)) }
}
Add-Line $packet ''
Add-Line $packet '## 6. Review Buckets'
Add-Line $packet ''
Add-RowsTable $packet $actionNowNonNo 'ActionNow Non-NO Rows' '- NONE'
Add-RowsTable $packet $systemLeave 'Leave In Place Rows' '- NONE'
Add-RowsTable $packet $helperReview 'Helper / Script Review Required Rows' '- NONE'
Add-RowsTable $packet $highOrBlockedRisk 'High Or Blocked Risk Rows' '- NONE'
Add-RowsTable $packet $userDecisionRows 'User Decision Required Rows' '- NONE'
Add-Line $packet '## 7. Full V0.5 Ticket Carry-Forward'
Add-Line $packet ''
Add-RowsTable $packet $tickets 'All Parsed Tickets' '- NO TICKETS PARSED'
Add-Line $packet '## 8. Review Rule'
Add-Line $packet ''
Add-Line $packet 'Default decision for every non-system row is HOLD_PENDING_USER_REVIEW.'
Add-Line $packet ''
Add-Line $packet 'A row may become a later approved-row candidate only after the user explicitly marks it. This packet itself approves zero rows.'
Add-Line $packet ''
Add-Line $packet '## 9. Current Blocked Actions'
Add-Line $packet ''
Add-Line $packet '- move'
Add-Line $packet '- delete'
Add-Line $packet '- rename'
Add-Line $packet '- route'
Add-Line $packet '- execute helper scripts'
Add-Line $packet '- commit'
Add-Line $packet '- push'
Add-Line $packet '- cleanup'
Add-Line $packet '- source rewrite'
Add-Line $packet '- doctrine promotion'
Add-Line $packet ''
Add-Line $packet '## 10. Next Single Action'
Add-Line $packet ''
Add-Line $packet $nextSingleAction
Add-Line $packet ''
Add-Line $packet 'Plain meaning: review the rows and mark decisions. Do not route anything now.'
Add-Line $packet ''
Add-Line $packet '## 11. DoesNotProve'
Add-Line $packet ''
Add-Line $packet 'This packet proves only that the V0.5 board was read into a user-review shape and that no physical action was authorized or performed by this script.'
Add-Line $packet ''
Add-Line $packet 'It does not prove any file should move, any destination is approved, cleanup is safe, helper scripts are executable, Git import is approved, or the project is complete.'
Add-Line $packet ''
Add-Line $packet '## 12. Scoped Verdict'
Add-Line $packet ''
Add-Line $packet $finalVerdict

Write-Utf8NoBom -Path $OutPacketPath -Lines $packet
$OutPacketSha = Get-Sha256Safe $OutPacketPath

$receipt = New-Object System.Collections.Generic.List[string]
Add-Line $receipt 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_REVIEW_PACKET_RECEIPT_20260609'
Add-Line $receipt ('created_at: ' + (Get-Date -Format o))
Add-Line $receipt ('output_packet_path: ' + $OutPacketPath)
Add-Line $receipt ('output_packet_sha256: ' + $OutPacketSha)
Add-Line $receipt ('output_receipt_path: ' + $OutReceiptPath)
Add-Line $receipt ('v0_5_report_verified: ' + $V05ReportVerified)
Add-Line $receipt ('v0_5_receipt_verified: ' + $V05ReceiptVerified)
Add-Line $receipt ('review_card_verified: ' + $ReviewCardVerified)
Add-Line $receipt ('review_receipt_verified: ' + $ReviewReceiptVerified)
Add-Line $receipt ('ticket_count: ' + $ticketCount)
Add-Line $receipt ('system_leave_in_place_count: ' + (Count-Items $systemLeave))
Add-Line $receipt ('helper_review_required_count: ' + (Count-Items $helperReview))
Add-Line $receipt ('high_or_blocked_risk_count: ' + (Count-Items $highOrBlockedRisk))
Add-Line $receipt ('user_decision_required_count: ' + (Count-Items $userDecisionRows))
Add-Line $receipt ('action_now_non_no_count: ' + (Count-Items $actionNowNonNo))
Add-Line $receipt ('blocker_count: ' + $blockerCount)
Add-Line $receipt ('next_single_action: ' + $nextSingleAction)
Add-Line $receipt 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Add-Line $receipt ('final_verdict: ' + $finalVerdict)

Write-Utf8NoBom -Path $OutReceiptPath -Lines $receipt
$OutReceiptSha = Get-Sha256Safe $OutReceiptPath

Write-Host '=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER REVIEW PACKET COMPLETE ==='
Write-Host ('output_packet_path: ' + $OutPacketPath)
Write-Host ('output_packet_sha256: ' + $OutPacketSha)
Write-Host ('output_receipt_path: ' + $OutReceiptPath)
Write-Host ('output_receipt_sha256: ' + $OutReceiptSha)
Write-Host ('ticket_count: ' + $ticketCount)
Write-Host ('system_leave_in_place_count: ' + (Count-Items $systemLeave))
Write-Host ('helper_review_required_count: ' + (Count-Items $helperReview))
Write-Host ('high_or_blocked_risk_count: ' + (Count-Items $highOrBlockedRisk))
Write-Host ('user_decision_required_count: ' + (Count-Items $userDecisionRows))
Write-Host ('action_now_non_no_count: ' + (Count-Items $actionNowNonNo))
Write-Host ('blocker_count: ' + $blockerCount)
Write-Host ('next_single_action: ' + $nextSingleAction)
Write-Host ('final_verdict: ' + $finalVerdict)
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
