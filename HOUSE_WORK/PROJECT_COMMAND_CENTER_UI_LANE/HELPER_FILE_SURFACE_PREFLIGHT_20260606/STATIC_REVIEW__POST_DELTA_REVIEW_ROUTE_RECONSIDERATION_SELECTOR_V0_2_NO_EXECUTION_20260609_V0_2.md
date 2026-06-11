# STATIC REVIEW: POST-DELTA ROUTE RECONSIDERATION SELECTOR V0_2 V0_2 CHECKER

Status:
STATIC_REVIEW_BUILT / SELECTOR_NOT_EXECUTED / NO_ROUTE / NO_CLEANUP

Repair note:
Prior static review V0_1 is invalid because the checker raised an Invalid pattern error while building required checks. This V0_2 review uses literal Contains checks for dollar-sign script fragments instead of fragile regex.

Prior bad static review:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\STATIC_REVIEW__POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_V0_2_NO_EXECUTION_20260609_V0_1.md

Prior bad static review SHA256:
273287979B990B40C967BC87688832CC8D57A9A227D478C4C2473CC36795511E

Selector script:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\BUILD_POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_V0_2_NO_EXECUTION_20260609.ps1

Selector script SHA256:
B549D36B85E3A125E3DAEC9FF0FBFEF6DBAA28C29065103866B7F4E3E2F7B72A

Build receipt:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\HASH_RECEIPT__BUILD_POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_V0_2_NO_EXECUTION_20260609.txt

Build receipt SHA256:
86BDB58A6A2CF128BD752C2284A973B4AEEF5083E59264946817D914D4222D63

Contract:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\CONTRACT__POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_V0_2_NO_EXECUTION_20260609.md

Contract SHA256:
A6B16536F01203E4384F5CB2BD13AE675E7CB184774DAB1786B8EECCA58A8FF6

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
10

Write command hits:
- line 186: Set-Content :: Set-Content -LiteralPath $FreezePath -Encoding UTF8
- line 633: Export-Csv :: Export-Csv -LiteralPath $PlanRowsCsvPath -NoTypeInformation -Encoding UTF8
- line 634: Export-Csv :: Export-Csv -LiteralPath $ReviewedDeltaCsvPath -NoTypeInformation -Encoding UTF8
- line 635: Export-Csv :: Export-Csv -LiteralPath $RouteCandidatesCsvPath -NoTypeInformation -Encoding UTF8
- line 636: Export-Csv :: Export-Csv -LiteralPath $HoldOrLeaveCsvPath -NoTypeInformation -Encoding UTF8
- line 637: Export-Csv :: Export-Csv -LiteralPath $NewDeltaCsvPath -NoTypeInformation -Encoding UTF8
- line 638: Export-Csv :: Export-Csv -LiteralPath $CollisionCsvPath -NoTypeInformation -Encoding UTF8
- line 639: Export-Csv :: Export-Csv -LiteralPath $ParentMissingCsvPath -NoTypeInformation -Encoding UTF8
- line 712: Set-Content :: Set-Content -LiteralPath $ReportPath -Encoding UTF8
- line 749: Set-Content :: Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

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
- HasScalarSafeReturn: True
- HasAddObjectRow: True
- HasNoExecutionLabel: True
- HasReadyVerdict: True
- HasBlockedNewDeltaVerdict: True
- HasBlockedChanged58Verdict: True
- HasBlockedChangedDeltaVerdict: True
- HasBlockedCollisionVerdict: True
- HasBlockedParentMissingVerdict: True
- HasProposedBucketRead: True
- HasRouteCandidateFunction: True
- HasRouteCandidateDerivation: True
- HasHoldOrLeaveFunction: True
- HasHoldCurrentRunnerBucket: True
- HasHoldZeroByteBucket: True
- HasLeaveInPlaceBucket: True
- HasParentMissingRows: True
- HasParentMissingCsv: True
- HasRouteCandidatesCsv: True
- HasHoldOrLeaveCsv: True
- HasPhysicalActionsZero: True

Failed required text checks:
none

Command names observed:
Add-ObjectRow
Assert-OutputPathInBase
Convert-ToRoutePlanRecordV02
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
Split-MarkdownRow
Test-HoldOrLeaveBucket
Test-MarkdownDataRow
Test-MarkdownSeparatorRow
Test-Path
Test-RouteCandidateByContract
Where-Object
Write-FreezeEvidence

Static verdict:
STATIC_REVIEW_PASS_READY_FOR_SINGLE_NO_EXECUTION_V0_2_RUN

Boundary:
This static review did not execute the selector script.
This static review does not route, move, delete, rename, clean up, execute helpers, commit, or push.
A PASS verdict only allows the user to consider one later no-execution selector run.

Next single action:
RUN_POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_V0_2_ONCE_NO_EXECUTION

Final scoped verdict:
STATIC_REVIEW_PASS_READY_FOR_SINGLE_NO_EXECUTION_V0_2_RUN
