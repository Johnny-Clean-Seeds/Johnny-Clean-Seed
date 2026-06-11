# STATIC REVIEW: POST-DELTA ROUTE RECONSIDERATION SELECTOR V0_1

Status:
STATIC_REVIEW_BUILT / SELECTOR_NOT_EXECUTED / NO_ROUTE / NO_CLEANUP

Selector script:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\BUILD_POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_NO_EXECUTION_20260609_V0_1.ps1

Selector script SHA256:
35DF0CD2FCDCD2F2C6249A0FCB95AA17ECA49D4E669FD7A8CA3DE9A99B3BC6B7

Build receipt:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\HASH_RECEIPT__BUILD_POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_NO_EXECUTION_20260609_V0_1.txt

Build receipt SHA256:
F0555B12BA217C52CD14F15D2078E495848FA8D776A919C8D6CCF21ABE0AAFCD

Contract:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\CONTRACT__POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_NO_EXECUTION_20260609.md

Contract SHA256:
1052463FB42BB79DA7AA4AFFD361067E3B834FBE442BDA15532B27CFA3EE3D4B

AST parse error count:
0

Forbidden command AST hit count:
0

Forbidden command AST hits:
none

Forbidden text token hit count:
0

Forbidden text token hits:
none

Write command hit count:
7

Write command hits:
- line 154: Set-Content :: Set-Content -LiteralPath $FreezePath -Encoding UTF8
- line 534: Export-Csv :: Export-Csv -LiteralPath $PlanRowsCsvPath -NoTypeInformation -Encoding UTF8
- line 535: Export-Csv :: Export-Csv -LiteralPath $ReviewedDeltaCsvPath -NoTypeInformation -Encoding UTF8
- line 536: Export-Csv :: Export-Csv -LiteralPath $NewDeltaCsvPath -NoTypeInformation -Encoding UTF8
- line 537: Export-Csv :: Export-Csv -LiteralPath $CollisionCsvPath -NoTypeInformation -Encoding UTF8
- line 601: Set-Content :: Set-Content -LiteralPath $ReportPath -Encoding UTF8
- line 629: Set-Content :: Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

Unexpected write command hit count:
0

Required text checks:
- HasStrictMode: True
- HasErrorActionStop: True
- HasOutputPathBoundFunction: True
- HasOutputPathBoundCalls: True
- HasFreezeFunction: True
- HasCatchBlock: True
- HasFreezeVerdict: True
- HasNewObjectListFactory: True
- HasScalarSafeReturn: False
- HasAddObjectRow: True
- HasNoExecutionLabel: True
- HasReadyVerdict: True
- HasBlockedNewDeltaVerdict: True
- HasBlockedChanged58Verdict: True
- HasBlockedChangedDeltaVerdict: True
- HasBlockedCollisionVerdict: True
- HasPhysicalActionsZero: True

Failed required text checks:
HasScalarSafeReturn

Command names observed:
Add-ObjectRow
Assert-OutputPathInBase
Convert-ToRoutePlanRecord
Export-Csv
ForEach-Object
Get-Cell
Get-ChildItem
Get-Content
Get-Date
Get-FileHash
Get-Item
Import-Csv
Join-Path
New-ObjectList
Normalize-Header
Read-RoutePlanRowsFromMarkdown
Resolve-PathLike
Set-Content
Set-StrictMode
Sort-Object
Split-MarkdownRow
Split-Path
Test-MarkdownDataRow
Test-MarkdownSeparatorRow
Test-Path
Where-Object
Write-FreezeEvidence

Static verdict:
STATIC_REVIEW_FAIL_REQUIRED_TEXT_CHECK

Boundary:
This static review did not execute the selector script.
This static review does not route, move, delete, rename, clean up, execute helpers, commit, or push.
A PASS verdict only allows the user to consider one later no-execution selector run.

Next single action:
RUN_POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_ONCE_NO_EXECUTION

Final scoped verdict:
STATIC_REVIEW_FAIL_REQUIRED_TEXT_CHECK
