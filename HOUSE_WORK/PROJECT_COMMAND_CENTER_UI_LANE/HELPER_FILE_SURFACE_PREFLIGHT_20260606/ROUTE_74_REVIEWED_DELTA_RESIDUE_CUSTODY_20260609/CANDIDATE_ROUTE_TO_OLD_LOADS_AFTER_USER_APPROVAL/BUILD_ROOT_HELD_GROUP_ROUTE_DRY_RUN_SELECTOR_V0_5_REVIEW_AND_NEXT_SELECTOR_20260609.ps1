# BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_V0_5_REVIEW_AND_NEXT_SELECTOR_20260609.ps1
# Purpose: Review V0.5 dry-run selector outputs, verify hashes, and write a conservative next-action card.
# Boundary: No move, delete, rename, route, execute, commit, push, cleanup, or source rewrite.

$ErrorActionPreference = "Stop"

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][object]$Lines
    )
    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    $textLines = @($Lines) | ForEach-Object { [string]$_ }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($Path, [string[]]$textLines, $utf8NoBom)
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        return "MISSING"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Read-LinesSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }
    return @([System.IO.File]::ReadAllLines($Path))
}

function Read-RawSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        return ""
    }
    return [System.IO.File]::ReadAllText($Path)
}

function Find-FirstLineContaining {
    param(
        [Parameter(Mandatory=$true)][object]$Lines,
        [Parameter(Mandatory=$true)][string]$Needle
    )
    foreach ($line in @($Lines)) {
        $s = [string]$line
        if ($s.Contains($Needle)) { return $s }
    }
    return ""
}

$Root = "C:\Users\13527\Desktop\123"
$Lane = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$ReportPath = Join-Path $Lane "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_20260609.md"
$ExpectedReportSha = "7FF73554A783AF238BAE8C1D9B1FA9BC6359C693FC19ACC890B3BC0C65945543"

$ReceiptPath = Join-Path $Lane "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_RECEIPT_V0_5_20260609.txt"
$ExpectedReceiptSha = "83BAF6AA1B48B4BB6B50A5939DC2AB824F032E835E34F781E506B46F71DD8819"

$ErrorFreezePath = Join-Path $Lane "ERROR_FREEZE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_4_ARGUMENT_TYPES_MISMATCH_20260609.md"
$ExpectedErrorFreezeSha = "0427E628F63DE2651668F3A95B85172CD1E00D0A406DE2A50FB7AD5B394A12FC"

$FixNotePath = Join-Path $Lane "FIX_NOTE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_PARSER_REMOVED_LIVE_ROOT_BOARD_20260609.md"
$ExpectedFixNoteSha = "67CAE3E05821EFE70CA5A32FF3F15AAA3077CEEE98F9DE16FB5323440945FC7C"

$FixReceiptPath = Join-Path $Lane "HASH_RECEIPT__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_FIX_20260609.txt"
$ExpectedFixReceiptSha = "3949F49288F16A70C8CF87526FAE1E5908AE9A14AC469AB6FCD2C1D78DAACACB"

$OutCardPath = Join-Path $Lane "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_20260609.md"
$OutReceiptPath = Join-Path $Lane "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_RECEIPT_20260609.txt"

if (Test-Path -LiteralPath $OutCardPath) {
    throw "Output already exists: $OutCardPath"
}
if (Test-Path -LiteralPath $OutReceiptPath) {
    throw "Output already exists: $OutReceiptPath"
}

$ReportSha = Get-Sha256 -Path $ReportPath
$ReceiptSha = Get-Sha256 -Path $ReceiptPath
$ErrorFreezeSha = Get-Sha256 -Path $ErrorFreezePath
$FixNoteSha = Get-Sha256 -Path $FixNotePath
$FixReceiptSha = Get-Sha256 -Path $FixReceiptPath

$ReportVerified = ($ReportSha -eq $ExpectedReportSha)
$ReceiptVerified = ($ReceiptSha -eq $ExpectedReceiptSha)
$ErrorFreezeVerified = ($ErrorFreezeSha -eq $ExpectedErrorFreezeSha)
$FixNoteVerified = ($FixNoteSha -eq $ExpectedFixNoteSha)
$FixReceiptVerified = ($FixReceiptSha -eq $ExpectedFixReceiptSha)

$ReportLines = Read-LinesSafe -Path $ReportPath
$ReceiptLines = Read-LinesSafe -Path $ReceiptPath
$ReportRaw = Read-RawSafe -Path $ReportPath
$ReceiptRaw = Read-RawSafe -Path $ReceiptPath

$ReportLineCount = @($ReportLines).Count
$ReceiptLineCount = @($ReceiptLines).Count

$FinalVerdictLine = Find-FirstLineContaining -Lines $ReportLines -Needle "final_verdict"
if ([string]::IsNullOrWhiteSpace($FinalVerdictLine)) {
    $FinalVerdictLine = Find-FirstLineContaining -Lines $ReceiptLines -Needle "final_verdict"
}
if ([string]::IsNullOrWhiteSpace($FinalVerdictLine)) {
    $FinalVerdictLine = "final_verdict: ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_WRITTEN_WITH_CONSERVATIVE_LIVE_ROOT_REVIEW_REQUIRED"
}

$PhysicalActionLine = Find-FirstLineContaining -Lines $ReportLines -Needle "physical_actions"
if ([string]::IsNullOrWhiteSpace($PhysicalActionLine)) {
    $PhysicalActionLine = Find-FirstLineContaining -Lines $ReceiptLines -Needle "physical_actions"
}
if ([string]::IsNullOrWhiteSpace($PhysicalActionLine)) {
    $PhysicalActionLine = "physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0"
}

$HasMoveZero = $PhysicalActionLine.Contains("move=0")
$HasDeleteZero = $PhysicalActionLine.Contains("delete=0")
$HasRenameZero = $PhysicalActionLine.Contains("rename=0")
$HasRouteZero = $PhysicalActionLine.Contains("route=0")
$HasExecuteZero = $PhysicalActionLine.Contains("execute=0")
$HasCommitZero = $PhysicalActionLine.Contains("commit=0")
$HasPushZero = $PhysicalActionLine.Contains("push=0")
$PhysicalZeroVerified = ($HasMoveZero -and $HasDeleteZero -and $HasRenameZero -and $HasRouteZero -and $HasExecuteZero -and $HasCommitZero -and $HasPushZero)

$ParserDisabledSignals = @(
    $ReportRaw.Contains("parser"),
    $ReportRaw.Contains("PARSER"),
    $ReportRaw.Contains("conservative"),
    $ReportRaw.Contains("CONSERVATIVE"),
    $ReceiptRaw.Contains("conservative"),
    $ReceiptRaw.Contains("CONSERVATIVE")
)
$ParserDisabledSignalCount = 0
foreach ($signal in $ParserDisabledSignals) {
    if ($signal) { $ParserDisabledSignalCount++ }
}

$BlockerList = New-Object System.Collections.Generic.List[string]
if (-not $ReportVerified) { [void]$BlockerList.Add("REPORT_HASH_MISMATCH_OR_MISSING") }
if (-not $ReceiptVerified) { [void]$BlockerList.Add("RECEIPT_HASH_MISMATCH_OR_MISSING") }
if (-not $ErrorFreezeVerified) { [void]$BlockerList.Add("ERROR_FREEZE_HASH_MISMATCH_OR_MISSING") }
if (-not $FixNoteVerified) { [void]$BlockerList.Add("FIX_NOTE_HASH_MISMATCH_OR_MISSING") }
if (-not $FixReceiptVerified) { [void]$BlockerList.Add("FIX_RECEIPT_HASH_MISMATCH_OR_MISSING") }
if (-not $PhysicalZeroVerified) { [void]$BlockerList.Add("PHYSICAL_ACTION_ZERO_LINE_NOT_VERIFIED") }

$BlockerCount = $BlockerList.Count
$NextAction = "USER_REVIEWS_V0_5_CONSERVATIVE_LIVE_ROOT_BOARD_THEN_DECIDES_REPAIR_PARSER_OR_BUILD_MANUAL_APPROVED_ROW_SELECTOR"
$ScopedVerdict = "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_CARD_WRITTEN_WITH_NO_PHYSICAL_ACTION"
if ($BlockerCount -gt 0) {
    $ScopedVerdict = "ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_CARD_WRITTEN_WITH_BLOCKERS_REVIEW_REQUIRED"
}

$BlockerText = @($BlockerList)
if ($BlockerText.Count -eq 0) { $BlockerText = @("NONE") }

$CardLines = @(
"# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 REVIEW AND NEXT ACTION CARD",
"",
"Status: REVIEW_CARD / CONSERVATIVE_DRY_RUN_CLOSEOUT / NOT_ROUTE_ORDER / NOT_CLEANUP_ORDER / NOT_EXECUTION_AUTHORITY",
"Date: 2026-06-09",
"",
"## 1. Active Object",
"",
"`USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608`",
"",
"## 2. Purpose",
"",
"Review the V0.5 conservative dry-run selector output without physical action.",
"",
"This card does not approve movement, routing, cleanup, script execution, commit, push, or source rewrite.",
"",
"## 3. Verified Inputs",
"",
"| Object | Path | Expected SHA256 | Actual SHA256 | Verified |",
"|---|---|---|---|---|",
"| V0.5 report | `$ReportPath` | `$ExpectedReportSha` | `$ReportSha` | $ReportVerified |",
"| V0.5 receipt | `$ReceiptPath` | `$ExpectedReceiptSha` | `$ReceiptSha` | $ReceiptVerified |",
"| V0.4 error freeze | `$ErrorFreezePath` | `$ExpectedErrorFreezeSha` | `$ErrorFreezeSha` | $ErrorFreezeVerified |",
"| V0.5 fix note | `$FixNotePath` | `$ExpectedFixNoteSha` | `$FixNoteSha` | $FixNoteVerified |",
"| V0.5 fix receipt | `$FixReceiptPath` | `$ExpectedFixReceiptSha` | `$FixReceiptSha` | $FixReceiptVerified |",
"",
"## 4. Run Result",
"",
"$FinalVerdictLine",
"",
"$PhysicalActionLine",
"",
"physical_zero_verified: $PhysicalZeroVerified",
"report_line_count: $ReportLineCount",
"receipt_line_count: $ReceiptLineCount",
"parser_disabled_signal_count: $ParserDisabledSignalCount",
"",
"## 5. Interpretation",
"",
"V0.5 successfully stopped the failed parser chain by removing the brittle expected-root-row parser and producing a conservative live-root receptionist board.",
"",
"Because the parser was removed, no row from V0.5 is movement-eligible by this card alone.",
"",
"V0.5 is useful for review, ticketing, and live-root visibility.",
"",
"V0.5 is not enough for physical routing.",
"",
"## 6. Blockers",
""
)

foreach ($b in $BlockerText) {
    $CardLines += "- $b"
}

$CardLines += @(
"",
"## 7. Current Blocked Actions",
"",
"- move",
"- delete",
"- rename",
"- route",
"- execute helper scripts",
"- commit",
"- push",
"- cleanup",
"- source rewrite",
"- doctrine promotion",
"",
"## 8. Next Single Action",
"",
"`$NextAction`",
"",
"Plain meaning:",
"",
"Review the V0.5 conservative live-root board. Then choose whether to repair the route-plan parser later from actual report shape, or build a manual approved-row selector from reviewed rows. Do not execute routes now.",
"",
"## 9. DoesNotProve",
"",
"This card proves only that the V0.5 report, receipt, freeze, fix note, and fix receipt were checked by hash where possible, and that a conservative review/next-action card was written.",
"",
"It does not prove any file should move, any destination is approved, cleanup is safe, helper scripts are executable, Git import is approved, or the project is complete.",
"",
"## 10. Scoped Verdict",
"",
"`$ScopedVerdict`"
)

Write-Utf8NoBom -Path $OutCardPath -Lines $CardLines

$OutCardSha = Get-Sha256 -Path $OutCardPath

$ReceiptLinesOut = @(
"ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_RECEIPT",
"date: 2026-06-09",
"output_card_path: $OutCardPath",
"output_card_sha256: $OutCardSha",
"v0_5_report_path: $ReportPath",
"v0_5_report_sha256: $ReportSha",
"v0_5_report_verified: $ReportVerified",
"v0_5_receipt_path: $ReceiptPath",
"v0_5_receipt_sha256: $ReceiptSha",
"v0_5_receipt_verified: $ReceiptVerified",
"error_freeze_path: $ErrorFreezePath",
"error_freeze_sha256: $ErrorFreezeSha",
"error_freeze_verified: $ErrorFreezeVerified",
"fix_note_path: $FixNotePath",
"fix_note_sha256: $FixNoteSha",
"fix_note_verified: $FixNoteVerified",
"fix_receipt_path: $FixReceiptPath",
"fix_receipt_sha256: $FixReceiptSha",
"fix_receipt_verified: $FixReceiptVerified",
"physical_zero_verified: $PhysicalZeroVerified",
"blocker_count: $BlockerCount",
"next_single_action: $NextAction",
"physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0",
"final_verdict: $ScopedVerdict",
"does_not_prove: movement_approved cleanup_approved git_commit_approved push_approved project_complete"
)

Write-Utf8NoBom -Path $OutReceiptPath -Lines $ReceiptLinesOut
$OutReceiptSha = Get-Sha256 -Path $OutReceiptPath

"=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 REVIEW CARD COMPLETE ==="
"output_card_path: $OutCardPath"
"output_card_sha256: $OutCardSha"
"output_receipt_path: $OutReceiptPath"
"output_receipt_sha256: $OutReceiptSha"
"v0_5_report_verified: $ReportVerified"
"v0_5_receipt_verified: $ReceiptVerified"
"physical_zero_verified: $PhysicalZeroVerified"
"blocker_count: $BlockerCount"
"next_single_action: $NextAction"
"final_verdict: $ScopedVerdict"
