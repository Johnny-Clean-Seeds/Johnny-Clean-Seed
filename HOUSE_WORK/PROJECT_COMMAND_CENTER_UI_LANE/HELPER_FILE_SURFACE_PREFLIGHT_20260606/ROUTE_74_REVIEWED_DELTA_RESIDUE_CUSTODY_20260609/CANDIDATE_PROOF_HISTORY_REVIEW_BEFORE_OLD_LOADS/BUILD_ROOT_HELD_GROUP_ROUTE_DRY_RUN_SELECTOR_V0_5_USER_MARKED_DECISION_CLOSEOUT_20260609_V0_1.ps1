# MARKED DECISION CLOSEOUT FOR ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5
# Generated: 2026-06-09
# Purpose: verify the user-marked decision copy and write a closeout card.
# Boundary: no move, delete, rename, route, execute, commit, or push.

$ErrorActionPreference = "Stop"

$LanePath = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$MarkedCsvPath = Join-Path $LanePath "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_V0_1_20260609.csv"
$MarkedMdPath = Join-Path $LanePath "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_V0_1_20260609.md"
$MarkedReceiptPath = Join-Path $LanePath "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_RECEIPT_V0_1_20260609.txt"

$ExpectedMarkedCsvSha = "DB41FAF1985E4FA729934CB8258F9084FCC725A476ABB9072FAAC58662A75A5D"
$ExpectedMarkedMdSha = "DD0A2E7951D6783BC2BC823EE51BFE49657A790C2EE5D4C4B0155546416EDB5F"
$ExpectedMarkedReceiptSha = "595214E86DE6929792ACAB6739DA4C8AAF309C4B996BD775B5516AA0101DE665"

$CloseoutPath = Join-Path $LanePath "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_V0_1_20260609.md"
$CloseoutReceiptPath = Join-Path $LanePath "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_RECEIPT_V0_1_20260609.txt"

function Get-Sha256Upper {
    param([string]$Path)
    if (!(Test-Path -LiteralPath $Path)) {
        throw "Missing required file: $Path"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Add-Line {
    param($List, [string]$Text)
    [void]$List.Add($Text)
}

$MarkedCsvSha = Get-Sha256Upper -Path $MarkedCsvPath
$MarkedMdSha = Get-Sha256Upper -Path $MarkedMdPath
$MarkedReceiptSha = Get-Sha256Upper -Path $MarkedReceiptPath

$blockers = New-Object System.Collections.Generic.List[string]

if ($MarkedCsvSha -ne $ExpectedMarkedCsvSha) {
    Add-Line $blockers ("MARKED_CSV_HASH_MISMATCH expected={0} actual={1}" -f $ExpectedMarkedCsvSha, $MarkedCsvSha)
}
if ($MarkedMdSha -ne $ExpectedMarkedMdSha) {
    Add-Line $blockers ("MARKED_MD_HASH_MISMATCH expected={0} actual={1}" -f $ExpectedMarkedMdSha, $MarkedMdSha)
}
if ($MarkedReceiptSha -ne $ExpectedMarkedReceiptSha) {
    Add-Line $blockers ("MARKED_RECEIPT_HASH_MISMATCH expected={0} actual={1}" -f $ExpectedMarkedReceiptSha, $MarkedReceiptSha)
}

$rows = @(Import-Csv -LiteralPath $MarkedCsvPath)

$totalRows = @($rows).Count
$holdRows = @($rows | Where-Object { $_.UserDecision -eq "HOLD" })
$reviewRows = @($rows | Where-Object { $_.UserDecision -eq "REVIEW" })
$blockRows = @($rows | Where-Object { $_.UserDecision -eq "BLOCK" })
$laterRows = @($rows | Where-Object { $_.UserDecision -eq "LATER_APPROVED_ROW_CANDIDATE" })

$blankRows = @($rows | Where-Object { [string]::IsNullOrWhiteSpace($_.UserDecision) })
$invalidRows = @($rows | Where-Object {
    $v = $_.UserDecision
    -not ([string]::IsNullOrWhiteSpace($v)) -and
    $v -ne "HOLD" -and
    $v -ne "REVIEW" -and
    $v -ne "BLOCK" -and
    $v -ne "LATER_APPROVED_ROW_CANDIDATE"
})

if ($totalRows -ne 69) {
    Add-Line $blockers ("TOTAL_ROWS_UNEXPECTED expected=69 actual={0}" -f $totalRows)
}
if (@($holdRows).Count -ne 5) {
    Add-Line $blockers ("HOLD_COUNT_UNEXPECTED expected=5 actual={0}" -f @($holdRows).Count)
}
if (@($reviewRows).Count -ne 64) {
    Add-Line $blockers ("REVIEW_COUNT_UNEXPECTED expected=64 actual={0}" -f @($reviewRows).Count)
}
if (@($blockRows).Count -ne 0) {
    Add-Line $blockers ("BLOCK_COUNT_UNEXPECTED expected=0 actual={0}" -f @($blockRows).Count)
}
if (@($laterRows).Count -ne 0) {
    Add-Line $blockers ("LATER_APPROVED_ROW_CANDIDATE_COUNT_UNEXPECTED expected=0 actual={0}" -f @($laterRows).Count)
}
if (@($blankRows).Count -ne 0) {
    Add-Line $blockers ("BLANK_USER_DECISION_ROWS actual={0}" -f @($blankRows).Count)
}
if (@($invalidRows).Count -ne 0) {
    Add-Line $blockers ("INVALID_USER_DECISION_ROWS actual={0}" -f @($invalidRows).Count)
}

$holdList = @($holdRows | ForEach-Object { "{0} :: {1}" -f $_.TicketID, $_.FileName })
$reviewList = @($reviewRows | ForEach-Object { "{0} :: {1}" -f $_.TicketID, $_.FileName })

$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$lines = New-Object System.Collections.Generic.List[string]
Add-Line $lines "# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER MARKED DECISION CLOSEOUT V0.1"
Add-Line $lines ""
Add-Line $lines ("Created: {0}" -f $now)
Add-Line $lines "Status: DECISION_CLOSEOUT / REVIEW_ONLY / NOT_ROUTE_ORDER / NOT_CLEANUP_ORDER / NOT_EXECUTOR"
Add-Line $lines ""
Add-Line $lines "## Active object"
Add-Line $lines ""
Add-Line $lines "USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608"
Add-Line $lines ""
Add-Line $lines "## Inputs verified"
Add-Line $lines ""
Add-Line $lines ("Marked CSV: {0}" -f $MarkedCsvPath)
Add-Line $lines ("Marked CSV SHA256: {0}" -f $MarkedCsvSha)
Add-Line $lines ""
Add-Line $lines ("Marked MD: {0}" -f $MarkedMdPath)
Add-Line $lines ("Marked MD SHA256: {0}" -f $MarkedMdSha)
Add-Line $lines ""
Add-Line $lines ("Marked receipt: {0}" -f $MarkedReceiptPath)
Add-Line $lines ("Marked receipt SHA256: {0}" -f $MarkedReceiptSha)
Add-Line $lines ""
Add-Line $lines "## Decision counts"
Add-Line $lines ""
Add-Line $lines ("total_rows: {0}" -f $totalRows)
Add-Line $lines ("decision_hold_count: {0}" -f @($holdRows).Count)
Add-Line $lines ("decision_review_count: {0}" -f @($reviewRows).Count)
Add-Line $lines ("decision_block_count: {0}" -f @($blockRows).Count)
Add-Line $lines ("decision_later_approved_row_candidate_count: {0}" -f @($laterRows).Count)
Add-Line $lines ("blank_user_decision_count: {0}" -f @($blankRows).Count)
Add-Line $lines ("invalid_user_decision_count: {0}" -f @($invalidRows).Count)
Add-Line $lines ""
Add-Line $lines "## Meaning"
Add-Line $lines ""
Add-Line $lines "The marked worksheet keeps the route dry-run in review-only mode."
Add-Line $lines "Five rows are held."
Add-Line $lines "Sixty-four rows require review."
Add-Line $lines "Zero rows are blocked by user marking."
Add-Line $lines "Zero rows are marked as later approved-row candidates."
Add-Line $lines ""
Add-Line $lines "Therefore there is no movement candidate set."
Add-Line $lines "There is no approved-row selector to build yet."
Add-Line $lines "There is no route execution authority."
Add-Line $lines ""
Add-Line $lines "## Held rows"
Add-Line $lines ""
foreach ($item in $holdList) {
    Add-Line $lines ("- {0}" -f $item)
}
Add-Line $lines ""
Add-Line $lines "## Review rows"
Add-Line $lines ""
Add-Line $lines "The 64 REVIEW rows remain helper/script custody review candidates. They are not runnable by this closeout."
Add-Line $lines ""
foreach ($item in $reviewList) {
    Add-Line $lines ("- {0}" -f $item)
}
Add-Line $lines ""
Add-Line $lines "## Blockers"
Add-Line $lines ""
if (@($blockers).Count -eq 0) {
    Add-Line $lines "blocker_count: 0"
} else {
    Add-Line $lines ("blocker_count: {0}" -f @($blockers).Count)
    foreach ($b in $blockers) {
        Add-Line $lines ("- {0}" -f $b)
    }
}
Add-Line $lines ""
Add-Line $lines "## Physical action accounting"
Add-Line $lines ""
Add-Line $lines "move: 0"
Add-Line $lines "delete: 0"
Add-Line $lines "rename: 0"
Add-Line $lines "route: 0"
Add-Line $lines "execute: 0"
Add-Line $lines "commit: 0"
Add-Line $lines "push: 0"
Add-Line $lines ""
Add-Line $lines "## Next single action"
Add-Line $lines ""
if (@($blockers).Count -eq 0) {
    Add-Line $lines "BUILD_HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_NO_EXECUTION"
} else {
    Add-Line $lines "STOP_AND_REVIEW_DECISION_CLOSEOUT_BLOCKERS"
}
Add-Line $lines ""
Add-Line $lines "## DoesNotProve"
Add-Line $lines ""
Add-Line $lines "This closeout proves only that the marked decision worksheet was read and counted, and that this closeout performed no physical action."
Add-Line $lines "It does not prove any helper script is safe to run."
Add-Line $lines "It does not approve movement, cleanup, route execution, Git commit, Git push, source rewrite, or doctrine promotion."
Add-Line $lines "It does not create approved rows."
Add-Line $lines ""
Add-Line $lines "## Final verdict"
Add-Line $lines ""
if (@($blockers).Count -eq 0) {
    Add-Line $lines "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION"
} else {
    Add-Line $lines "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION"
}

$lines | Set-Content -LiteralPath $CloseoutPath -Encoding UTF8
$CloseoutSha = Get-Sha256Upper -Path $CloseoutPath

$receiptLines = New-Object System.Collections.Generic.List[string]
Add-Line $receiptLines "ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER MARKED DECISION CLOSEOUT RECEIPT V0.1"
Add-Line $receiptLines ("Created: {0}" -f $now)
Add-Line $receiptLines ("closeout_path: {0}" -f $CloseoutPath)
Add-Line $receiptLines ("closeout_sha256: {0}" -f $CloseoutSha)
Add-Line $receiptLines ("marked_csv_path: {0}" -f $MarkedCsvPath)
Add-Line $receiptLines ("marked_csv_sha256: {0}" -f $MarkedCsvSha)
Add-Line $receiptLines ("marked_md_path: {0}" -f $MarkedMdPath)
Add-Line $receiptLines ("marked_md_sha256: {0}" -f $MarkedMdSha)
Add-Line $receiptLines ("marked_receipt_path: {0}" -f $MarkedReceiptPath)
Add-Line $receiptLines ("marked_receipt_sha256: {0}" -f $MarkedReceiptSha)
Add-Line $receiptLines ("total_rows: {0}" -f $totalRows)
Add-Line $receiptLines ("decision_hold_count: {0}" -f @($holdRows).Count)
Add-Line $receiptLines ("decision_review_count: {0}" -f @($reviewRows).Count)
Add-Line $receiptLines ("decision_block_count: {0}" -f @($blockRows).Count)
Add-Line $receiptLines ("decision_later_approved_row_candidate_count: {0}" -f @($laterRows).Count)
Add-Line $receiptLines ("blank_user_decision_count: {0}" -f @($blankRows).Count)
Add-Line $receiptLines ("invalid_user_decision_count: {0}" -f @($invalidRows).Count)
Add-Line $receiptLines ("blocker_count: {0}" -f @($blockers).Count)
Add-Line $receiptLines "physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0"
if (@($blockers).Count -eq 0) {
    Add-Line $receiptLines "next_single_action: BUILD_HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_NO_EXECUTION"
    Add-Line $receiptLines "final_verdict: ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION"
} else {
    Add-Line $receiptLines "next_single_action: STOP_AND_REVIEW_DECISION_CLOSEOUT_BLOCKERS"
    Add-Line $receiptLines "final_verdict: ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION"
}

$receiptLines | Set-Content -LiteralPath $CloseoutReceiptPath -Encoding UTF8
$ReceiptSha = Get-Sha256Upper -Path $CloseoutReceiptPath

"=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER MARKED DECISION CLOSEOUT V0.1 COMPLETE ==="
"output_closeout_path: $CloseoutPath"
"output_closeout_sha256: $CloseoutSha"
"output_receipt_path: $CloseoutReceiptPath"
"output_receipt_sha256: $ReceiptSha"
"marked_csv_verified: $($MarkedCsvSha -eq $ExpectedMarkedCsvSha)"
"marked_md_verified: $($MarkedMdSha -eq $ExpectedMarkedMdSha)"
"marked_receipt_verified: $($MarkedReceiptSha -eq $ExpectedMarkedReceiptSha)"
"total_rows: $totalRows"
"decision_hold_count: $(@($holdRows).Count)"
"decision_review_count: $(@($reviewRows).Count)"
"decision_block_count: $(@($blockRows).Count)"
"decision_later_approved_row_candidate_count: $(@($laterRows).Count)"
"blank_user_decision_count: $(@($blankRows).Count)"
"invalid_user_decision_count: $(@($invalidRows).Count)"
"blocker_count: $(@($blockers).Count)"
if (@($blockers).Count -eq 0) {
    "next_single_action: BUILD_HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS_NO_EXECUTION"
    "final_verdict: ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION"
} else {
    "next_single_action: STOP_AND_REVIEW_DECISION_CLOSEOUT_BLOCKERS"
    "final_verdict: ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_CLOSEOUT_V0_1_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION"
}
"physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0"
