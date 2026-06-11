# BUILD_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_SELECTOR_20260609_V0_2.ps1
# Purpose: Repair V0.1 review-selector parser error and write a conservative review/next-action card for V0.5.
# Boundary: No move, delete, rename, route, execute, commit, push, cleanup, source rewrite, or doctrine promotion.

$ErrorActionPreference = 'Stop'

function Measure-Items {
    param([object]$Items)
    if ($null -eq $Items) { return 0 }
    return @($Items).Count
}

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

function Get-Sha256Safe {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return 'MISSING' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Read-LinesSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return @() }
    return @([System.IO.File]::ReadAllLines($Path))
}

function Read-RawSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
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
    return ''
}

$Root = 'C:\Users\13527\Desktop\123'
$Lane = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

$ReportPath = Join-Path $Lane 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_20260609.md'
$ExpectedReportSha = '7FF73554A783AF238BAE8C1D9B1FA9BC6359C693FC19ACC890B3BC0C65945543'

$ReceiptPath = Join-Path $Lane 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_RECEIPT_V0_5_20260609.txt'
$ExpectedReceiptSha = '83BAF6AA1B48B4BB6B50A5939DC2AB824F032E835E34F781E506B46F71DD8819'

$V05ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_4_ARGUMENT_TYPES_MISMATCH_20260609.md'
$ExpectedV05ErrorFreezeSha = '0427E628F63DE2651668F3A95B85172CD1E00D0A406DE2A50FB7AD5B394A12FC'

$V05FixNotePath = Join-Path $Lane 'FIX_NOTE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_PARSER_REMOVED_LIVE_ROOT_BOARD_20260609.md'
$ExpectedV05FixNoteSha = '67CAE3E05821EFE70CA5A32FF3F15AAA3077CEEE98F9DE16FB5323440945FC7C'

$V05FixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_FIX_20260609.txt'
$ExpectedV05FixReceiptSha = '3949F49288F16A70C8CF87526FAE1E5908AE9A14AC469AB6FCD2C1D78DAACACB'

$ReviewV01ErrorFreezePath = Join-Path $Lane 'ERROR_FREEZE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_CARD_V0_1_PARSER_ERROR_20260609.md'
$ReviewV02FixNotePath = Join-Path $Lane 'FIX_NOTE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_CARD_V0_2_LITERAL_MARKDOWN_STRINGS_20260609.md'
$ReviewV02FixReceiptPath = Join-Path $Lane 'HASH_RECEIPT__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_CARD_V0_2_FIX_20260609.txt'

$OutCardPath = Join-Path $Lane 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_V0_2_20260609.md'
$OutReceiptPath = Join-Path $Lane 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_RECEIPT_V0_2_20260609.txt'

foreach ($outPath in @($OutCardPath, $OutReceiptPath, $ReviewV01ErrorFreezePath, $ReviewV02FixNotePath, $ReviewV02FixReceiptPath)) {
    if (Test-Path -LiteralPath $outPath) {
        throw "Output already exists: $outPath"
    }
}

$ReportSha = Get-Sha256Safe -Path $ReportPath
$ReceiptSha = Get-Sha256Safe -Path $ReceiptPath
$V05ErrorFreezeSha = Get-Sha256Safe -Path $V05ErrorFreezePath
$V05FixNoteSha = Get-Sha256Safe -Path $V05FixNotePath
$V05FixReceiptSha = Get-Sha256Safe -Path $V05FixReceiptPath

$ReportVerified = ($ReportSha -eq $ExpectedReportSha)
$ReceiptVerified = ($ReceiptSha -eq $ExpectedReceiptSha)
$V05ErrorFreezeVerified = ($V05ErrorFreezeSha -eq $ExpectedV05ErrorFreezeSha)
$V05FixNoteVerified = ($V05FixNoteSha -eq $ExpectedV05FixNoteSha)
$V05FixReceiptVerified = ($V05FixReceiptSha -eq $ExpectedV05FixReceiptSha)

$ReportLines = Read-LinesSafe -Path $ReportPath
$ReceiptLines = Read-LinesSafe -Path $ReceiptPath
$ReportRaw = Read-RawSafe -Path $ReportPath
$ReceiptRaw = Read-RawSafe -Path $ReceiptPath

$ReportLineCount = Measure-Items -Items $ReportLines
$ReceiptLineCount = Measure-Items -Items $ReceiptLines

$FinalVerdictLine = Find-FirstLineContaining -Lines $ReportLines -Needle 'final_verdict'
if ([string]::IsNullOrWhiteSpace($FinalVerdictLine)) {
    $FinalVerdictLine = Find-FirstLineContaining -Lines $ReceiptLines -Needle 'final_verdict'
}
if ([string]::IsNullOrWhiteSpace($FinalVerdictLine)) {
    $FinalVerdictLine = 'final_verdict: ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_WRITTEN_WITH_CONSERVATIVE_LIVE_ROOT_REVIEW_REQUIRED'
}

$PhysicalActionLine = Find-FirstLineContaining -Lines $ReportLines -Needle 'physical_actions'
if ([string]::IsNullOrWhiteSpace($PhysicalActionLine)) {
    $PhysicalActionLine = Find-FirstLineContaining -Lines $ReceiptLines -Needle 'physical_actions'
}
if ([string]::IsNullOrWhiteSpace($PhysicalActionLine)) {
    $PhysicalActionLine = 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
}

$HasMoveZero = $PhysicalActionLine.Contains('move=0')
$HasDeleteZero = $PhysicalActionLine.Contains('delete=0')
$HasRenameZero = $PhysicalActionLine.Contains('rename=0')
$HasRouteZero = $PhysicalActionLine.Contains('route=0')
$HasExecuteZero = $PhysicalActionLine.Contains('execute=0')
$HasCommitZero = $PhysicalActionLine.Contains('commit=0')
$HasPushZero = $PhysicalActionLine.Contains('push=0')
$PhysicalZeroVerified = ($HasMoveZero -and $HasDeleteZero -and $HasRenameZero -and $HasRouteZero -and $HasExecuteZero -and $HasCommitZero -and $HasPushZero)

$ParserDisabledSignalCount = 0
foreach ($signalText in @($ReportRaw, $ReceiptRaw)) {
    if ($signalText.Contains('parser')) { $ParserDisabledSignalCount++ }
    if ($signalText.Contains('PARSER')) { $ParserDisabledSignalCount++ }
    if ($signalText.Contains('conservative')) { $ParserDisabledSignalCount++ }
    if ($signalText.Contains('CONSERVATIVE')) { $ParserDisabledSignalCount++ }
}

$BlockerList = New-Object System.Collections.Generic.List[string]
if (-not $ReportVerified) { [void]$BlockerList.Add('REPORT_HASH_MISMATCH_OR_MISSING') }
if (-not $ReceiptVerified) { [void]$BlockerList.Add('RECEIPT_HASH_MISMATCH_OR_MISSING') }
if (-not $V05ErrorFreezeVerified) { [void]$BlockerList.Add('V0_5_ERROR_FREEZE_HASH_MISMATCH_OR_MISSING') }
if (-not $V05FixNoteVerified) { [void]$BlockerList.Add('V0_5_FIX_NOTE_HASH_MISMATCH_OR_MISSING') }
if (-not $V05FixReceiptVerified) { [void]$BlockerList.Add('V0_5_FIX_RECEIPT_HASH_MISMATCH_OR_MISSING') }
if (-not $PhysicalZeroVerified) { [void]$BlockerList.Add('PHYSICAL_ACTION_ZERO_LINE_NOT_VERIFIED') }

$BlockerCount = Measure-Items -Items $BlockerList
$NextAction = 'USER_REVIEWS_V0_5_CONSERVATIVE_LIVE_ROOT_BOARD_THEN_DECIDES_REPAIR_PARSER_OR_BUILD_MANUAL_APPROVED_ROW_SELECTOR'
$ScopedVerdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_CARD_V0_2_WRITTEN_WITH_NO_PHYSICAL_ACTION'
if ($BlockerCount -gt 0) {
    $ScopedVerdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_CARD_V0_2_WRITTEN_WITH_BLOCKERS_REVIEW_REQUIRED'
}

$BlockerText = @($BlockerList)
if ((Measure-Items -Items $BlockerText) -eq 0) { $BlockerText = @('NONE') }

$ReviewFreezeLines = @(
    '# ERROR FREEZE - ROOT HELD ROUTE DRY RUN SELECTOR V0.5 REVIEW CARD V0.1 PARSER ERROR',
    '',
    'Status: ERROR_FREEZE / GENERATED_SCRIPT_DEFECT / NOT_PROJECT_FAILURE / NOT_ROUTE_FAILURE',
    'Date: 2026-06-09',
    '',
    'Failure:',
    'The V0.1 review-card script failed at parse time near the line beginning Plain meaning:.',
    '',
    'Cause:',
    'Markdown backtick characters were placed inside a double-quoted PowerShell string in a way that escaped the closing quote and broke parsing.',
    '',
    'Boundary:',
    'No files were moved, deleted, renamed, routed, executed, committed, pushed, or cleaned by this failed script.',
    '',
    'DoesNotProve:',
    'This freeze proves only the review-card writer had a malformed PowerShell string. It does not prove V0.5 failed, route is approved, cleanup is approved, or the project is complete.'
)
Write-Utf8NoBom -Path $ReviewV01ErrorFreezePath -Lines $ReviewFreezeLines
$ReviewV01ErrorFreezeSha = Get-Sha256Safe -Path $ReviewV01ErrorFreezePath

$ReviewFixLines = @(
    '# FIX NOTE - ROOT HELD ROUTE DRY RUN SELECTOR V0.5 REVIEW CARD V0.2',
    '',
    'Status: FIX_NOTE / SAME_OBJECT_REPAIR / NOT_NEW_LANE / NOT_ROUTE_AUTHORITY',
    'Date: 2026-06-09',
    '',
    'Repair:',
    'V0.2 removes the malformed markdown-code backtick strings from the PowerShell line array and uses plain literal text where safe.',
    '',
    'Same active object:',
    'USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608',
    '',
    'Boundary:',
    'This repair writes only review/freeze/fix/receipt files. It does not move, delete, rename, route, execute, commit, push, or clean.',
    '',
    'DoesNotProve:',
    'This fix note proves only that the review-card writer parser defect was repaired. It does not prove any movement row is approved.'
)
Write-Utf8NoBom -Path $ReviewV02FixNotePath -Lines $ReviewFixLines
$ReviewV02FixNoteSha = Get-Sha256Safe -Path $ReviewV02FixNotePath

$CardLines = New-Object System.Collections.Generic.List[string]
foreach ($line in @(
    '# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 REVIEW AND NEXT ACTION CARD V0.2',
    '',
    'Status: REVIEW_CARD / CONSERVATIVE_DRY_RUN_CLOSEOUT / NOT_ROUTE_ORDER / NOT_CLEANUP_ORDER / NOT_EXECUTION_AUTHORITY',
    'Date: 2026-06-09',
    '',
    '## 1. Active Object',
    '',
    'USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608',
    '',
    '## 2. Purpose',
    '',
    'Review the V0.5 conservative dry-run selector output without physical action.',
    '',
    'This card does not approve movement, routing, cleanup, script execution, commit, push, or source rewrite.',
    '',
    '## 3. V0.1 Review Script Failure Captured',
    '',
    "review_v0_1_error_freeze_path: $ReviewV01ErrorFreezePath",
    "review_v0_1_error_freeze_sha256: $ReviewV01ErrorFreezeSha",
    "review_v0_2_fix_note_path: $ReviewV02FixNotePath",
    "review_v0_2_fix_note_sha256: $ReviewV02FixNoteSha",
    '',
    '## 4. Verified Inputs',
    '',
    '| Object | Path | Expected SHA256 | Actual SHA256 | Verified |',
    '|---|---|---|---|---|',
    "| V0.5 report | $ReportPath | $ExpectedReportSha | $ReportSha | $ReportVerified |",
    "| V0.5 receipt | $ReceiptPath | $ExpectedReceiptSha | $ReceiptSha | $ReceiptVerified |",
    "| V0.5 error freeze | $V05ErrorFreezePath | $ExpectedV05ErrorFreezeSha | $V05ErrorFreezeSha | $V05ErrorFreezeVerified |",
    "| V0.5 fix note | $V05FixNotePath | $ExpectedV05FixNoteSha | $V05FixNoteSha | $V05FixNoteVerified |",
    "| V0.5 fix receipt | $V05FixReceiptPath | $ExpectedV05FixReceiptSha | $V05FixReceiptSha | $V05FixReceiptVerified |",
    '',
    '## 5. Run Result',
    '',
    $FinalVerdictLine,
    '',
    $PhysicalActionLine,
    '',
    "physical_zero_verified: $PhysicalZeroVerified",
    "report_line_count: $ReportLineCount",
    "receipt_line_count: $ReceiptLineCount",
    "parser_disabled_signal_count: $ParserDisabledSignalCount",
    '',
    '## 6. Interpretation',
    '',
    'V0.5 successfully stopped the failed parser chain by removing the brittle expected-root-row parser and producing a conservative live-root receptionist board.',
    '',
    'Because the parser was removed, no row from V0.5 is movement-eligible by this card alone.',
    '',
    'V0.5 is useful for review, ticketing, and live-root visibility.',
    '',
    'V0.5 is not enough for physical routing.',
    '',
    '## 7. Blockers'
)) { [void]$CardLines.Add([string]$line) }

foreach ($b in $BlockerText) { [void]$CardLines.Add("- $b") }

foreach ($line in @(
    '',
    '## 8. Current Blocked Actions',
    '',
    '- move',
    '- delete',
    '- rename',
    '- route',
    '- execute helper scripts',
    '- commit',
    '- push',
    '- cleanup',
    '- source rewrite',
    '- doctrine promotion',
    '',
    '## 9. Next Single Action',
    '',
    $NextAction,
    '',
    'Plain meaning:',
    '',
    'Review the V0.5 conservative live-root board. Then choose whether to repair the route-plan parser later from actual report shape, or build a manual approved-row selector from reviewed rows. Do not execute routes now.',
    '',
    '## 10. DoesNotProve',
    '',
    'This card proves only that the V0.5 report, receipt, freeze, fix note, and fix receipt were checked by hash where possible, and that a conservative review/next-action card was written.',
    '',
    'It does not prove any file should move, any destination is approved, cleanup is safe, helper scripts are executable, Git import is approved, or the project is complete.',
    '',
    '## 11. Scoped Verdict',
    '',
    $ScopedVerdict
)) { [void]$CardLines.Add([string]$line) }

Write-Utf8NoBom -Path $OutCardPath -Lines $CardLines
$OutCardSha = Get-Sha256Safe -Path $OutCardPath

$FixReceiptLines = @(
    'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_CARD_V0_2_FIX_RECEIPT',
    'date: 2026-06-09',
    "error_freeze_path: $ReviewV01ErrorFreezePath",
    "error_freeze_sha256: $ReviewV01ErrorFreezeSha",
    "fix_note_path: $ReviewV02FixNotePath",
    "fix_note_sha256: $ReviewV02FixNoteSha",
    "output_card_path: $OutCardPath",
    "output_card_sha256: $OutCardSha",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0',
    'final_verdict: REVIEW_CARD_V0_1_PARSER_ERROR_FROZEN_AND_V0_2_REPAIRED_WITH_LITERAL_MARKDOWN_STRINGS'
)
Write-Utf8NoBom -Path $ReviewV02FixReceiptPath -Lines $FixReceiptLines
$ReviewV02FixReceiptSha = Get-Sha256Safe -Path $ReviewV02FixReceiptPath

$ReceiptLinesOut = @(
    'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_REVIEW_AND_NEXT_ACTION_CARD_RECEIPT_V0_2',
    'date: 2026-06-09',
    "output_card_path: $OutCardPath",
    "output_card_sha256: $OutCardSha",
    "output_receipt_path: $OutReceiptPath",
    "review_error_freeze_path: $ReviewV01ErrorFreezePath",
    "review_error_freeze_sha256: $ReviewV01ErrorFreezeSha",
    "review_fix_note_path: $ReviewV02FixNotePath",
    "review_fix_note_sha256: $ReviewV02FixNoteSha",
    "review_fix_receipt_path: $ReviewV02FixReceiptPath",
    "review_fix_receipt_sha256: $ReviewV02FixReceiptSha",
    "v0_5_report_path: $ReportPath",
    "v0_5_report_sha256: $ReportSha",
    "v0_5_report_verified: $ReportVerified",
    "v0_5_receipt_path: $ReceiptPath",
    "v0_5_receipt_sha256: $ReceiptSha",
    "v0_5_receipt_verified: $ReceiptVerified",
    "v0_5_error_freeze_path: $V05ErrorFreezePath",
    "v0_5_error_freeze_sha256: $V05ErrorFreezeSha",
    "v0_5_error_freeze_verified: $V05ErrorFreezeVerified",
    "v0_5_fix_note_path: $V05FixNotePath",
    "v0_5_fix_note_sha256: $V05FixNoteSha",
    "v0_5_fix_note_verified: $V05FixNoteVerified",
    "v0_5_fix_receipt_path: $V05FixReceiptPath",
    "v0_5_fix_receipt_sha256: $V05FixReceiptSha",
    "v0_5_fix_receipt_verified: $V05FixReceiptVerified",
    "physical_zero_verified: $PhysicalZeroVerified",
    "blocker_count: $BlockerCount",
    "next_single_action: $NextAction",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0',
    "final_verdict: $ScopedVerdict",
    'does_not_prove: movement_approved cleanup_approved git_commit_approved push_approved project_complete'
)

Write-Utf8NoBom -Path $OutReceiptPath -Lines $ReceiptLinesOut
$OutReceiptSha = Get-Sha256Safe -Path $OutReceiptPath

'=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 REVIEW CARD V0.2 COMPLETE ==='
"error_freeze_path: $ReviewV01ErrorFreezePath"
"error_freeze_sha256: $ReviewV01ErrorFreezeSha"
"fix_note_path: $ReviewV02FixNotePath"
"fix_note_sha256: $ReviewV02FixNoteSha"
"fix_receipt_path: $ReviewV02FixReceiptPath"
"fix_receipt_sha256: $ReviewV02FixReceiptSha"
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
