Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Lane = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$CsvPath = Join-Path $Lane "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_20260609.csv"
$OutCsvPath = Join-Path $Lane "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_V0_1_20260609.csv"
$OutMdPath = Join-Path $Lane "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_V0_1_20260609.md"
$ReceiptPath = Join-Path $Lane "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_MANUAL_DECISION_WORKSHEET_USER_MARKED_RECEIPT_V0_1_20260609.txt"

if (-not (Test-Path -LiteralPath $CsvPath -PathType Leaf)) {
    throw "Source worksheet CSV not found: $CsvPath"
}

$SourceHash = (Get-FileHash -LiteralPath $CsvPath -Algorithm SHA256).Hash
$ExpectedSourceHash = "2A29F825FEDE1EB4EA5EA3F9F22F733803F09944F57F4538EFDEF2C28BE0BF40"
if ($SourceHash -ne $ExpectedSourceHash) {
    throw "Source worksheet hash mismatch. Expected $ExpectedSourceHash but found $SourceHash"
}

$rows = @(Import-Csv -LiteralPath $CsvPath)

foreach ($r in $rows) {
    $fileName = [string]$r.FileName
    $role = [string]$r.RoleLabel

    if ($fileName -ieq "desktop.ini") {
        $r.UserDecision = "HOLD"
        $r.UserNote = "System metadata; leave in place. No movement."
    }
    elseif ($fileName.ToLowerInvariant().EndsWith(".ps1")) {
        $r.UserDecision = "REVIEW"
        $r.UserNote = "Executable helper/script; specialist helper review required before any later action. No execution."
    }
    elseif (($role -eq "LEDGER") -or ($role -eq "SUPPORT_GUARDRAIL") -or ($role -eq "OLD_LOAD_OR_SUPERSEDED")) {
        $r.UserDecision = "HOLD"
        $r.UserNote = "Non-executable custody/support/proof object; hold pending later review. No movement."
    }
    else {
        $r.UserDecision = "REVIEW"
        $r.UserNote = "Conservative fallback review. No movement."
    }
}

$rows | Export-Csv -LiteralPath $OutCsvPath -NoTypeInformation -Encoding UTF8

$holdCount = ($rows | Where-Object { $_.UserDecision -eq "HOLD" } | Measure-Object).Count
$reviewCount = ($rows | Where-Object { $_.UserDecision -eq "REVIEW" } | Measure-Object).Count
$blockCount = ($rows | Where-Object { $_.UserDecision -eq "BLOCK" } | Measure-Object).Count
$laterCount = ($rows | Where-Object { $_.UserDecision -eq "LATER_APPROVED_ROW_CANDIDATE" } | Measure-Object).Count
$totalCount = ($rows | Measure-Object).Count

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 - USER MARKED DECISION COPY V0.1")
$md.Add("")
$md.Add("Status: USER_MARKED_DECISION_COPY / REVIEW_ONLY / NO_ROUTE / NO_CLEANUP / NO_PHYSICAL_ACTION")
$md.Add("")
$md.Add("## Source")
$md.Add("")
$md.Add("- source_csv_path: ``$CsvPath``")
$md.Add("- source_csv_sha256: ``$SourceHash``")
$md.Add("")
$md.Add("## Decision counts")
$md.Add("")
$md.Add("- total_rows: $totalCount")
$md.Add("- HOLD: $holdCount")
$md.Add("- REVIEW: $reviewCount")
$md.Add("- BLOCK: $blockCount")
$md.Add("- LATER_APPROVED_ROW_CANDIDATE: $laterCount")
$md.Add("")
$md.Add("## Meaning")
$md.Add("")
$md.Add("This marked copy uses the conservative decision rule:")
$md.Add("")
$md.Add("- desktop.ini -> HOLD")
$md.Add("- PowerShell helper/script rows -> REVIEW")
$md.Add("- non-executable custody/support/proof rows -> HOLD")
$md.Add("- fallback -> REVIEW")
$md.Add("")
$md.Add("This does not approve movement. REVIEW does not approve execution. HOLD does not approve cleanup. LATER_APPROVED_ROW_CANDIDATE count is zero.")
$md.Add("")
$md.Add("## Rows")
$md.Add("")

foreach ($r in $rows) {
    $md.Add(("### {0}" -f $r.TicketID))
    $md.Add("")
    $md.Add(("- File: ``{0}``" -f $r.FileName))
    $md.Add(("- Role: ``{0}``" -f $r.RoleLabel))
    $md.Add(("- Risk: ``{0}``" -f $r.RiskLabel))
    $md.Add(("- UserDecision: ``{0}``" -f $r.UserDecision))
    $md.Add(("- UserNote: {0}" -f $r.UserNote))
    $md.Add("")
}

$md.Add("## Physical actions")
$md.Add("")
$md.Add("move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0")
$md.Add("")
$md.Add("## Final verdict")
$md.Add("")
$md.Add("ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_COPY_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION")

$md | Set-Content -LiteralPath $OutMdPath -Encoding UTF8

$OutCsvHash = (Get-FileHash -LiteralPath $OutCsvPath -Algorithm SHA256).Hash
$OutMdHash = (Get-FileHash -LiteralPath $OutMdPath -Algorithm SHA256).Hash

$receipt = New-Object System.Collections.Generic.List[string]
$receipt.Add("ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER MARKED DECISION COPY RECEIPT V0.1")
$receipt.Add("source_csv_path: $CsvPath")
$receipt.Add("source_csv_sha256: $SourceHash")
$receipt.Add("output_marked_csv_path: $OutCsvPath")
$receipt.Add("output_marked_csv_sha256: $OutCsvHash")
$receipt.Add("output_marked_md_path: $OutMdPath")
$receipt.Add("output_marked_md_sha256: $OutMdHash")
$receipt.Add("total_rows: $totalCount")
$receipt.Add("decision_hold_count: $holdCount")
$receipt.Add("decision_review_count: $reviewCount")
$receipt.Add("decision_block_count: $blockCount")
$receipt.Add("decision_later_approved_row_candidate_count: $laterCount")
$receipt.Add("physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0")
$receipt.Add("does_not_prove: This marked copy does not approve movement, cleanup, execution, commit, push, route, or later executor action.")
$receipt.Add("final_verdict: ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_COPY_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION")
$receipt | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

"=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 USER MARKED DECISION COPY V0.1 COMPLETE ==="
"source_csv_path: $CsvPath"
"source_csv_sha256: $SourceHash"
"output_marked_csv_path: $OutCsvPath"
"output_marked_csv_sha256: $OutCsvHash"
"output_marked_md_path: $OutMdPath"
"output_marked_md_sha256: $OutMdHash"
"output_receipt_path: $ReceiptPath"
"output_receipt_sha256: $ReceiptHash"
"total_rows: $totalCount"
"decision_hold_count: $holdCount"
"decision_review_count: $reviewCount"
"decision_block_count: $blockCount"
"decision_later_approved_row_candidate_count: $laterCount"
"next_single_action: USER_REVIEWS_MARKED_COPY_COUNTS_THEN_BUILDS_DECISION_CLOSEOUT_NO_ROUTE_OR_CLEANUP"
"final_verdict: ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_USER_MARKED_DECISION_COPY_V0_1_WRITTEN_WITH_NO_PHYSICAL_ACTION"
"physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0"
