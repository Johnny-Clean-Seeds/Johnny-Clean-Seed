param(
  [string]$RootPath = "C:\Users\13527\Desktop\123",
  [string]$Base = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606",
  [string]$ActionTablePath = "",
  [string]$RunReceiptPath = "",
  [string]$HoldOrLeaveCsvPath = "",
  [string]$ReviewedDeltaCsvPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

function Stop-Closeout {
  param([string]$Message)
  throw "STOP: $Message"
}

function Resolve-LatestFile {
  param(
    [string]$Folder,
    [string]$Pattern,
    [string]$Label,
    [switch]$Required
  )
  $Matches = @(Get-ChildItem -LiteralPath $Folder -Filter $Pattern -File -Force | Sort-Object LastWriteTimeUtc -Descending)
  if ($Matches.Count -lt 1) {
    if ($Required.IsPresent) { Stop-Closeout "could not find $Label with pattern $Pattern in $Folder" }
    return ""
  }
  return [string]$Matches[0].FullName
}

function Get-HashStrict {
  param([string]$PathText)
  if ([string]::IsNullOrWhiteSpace($PathText)) { Stop-Closeout "blank path passed to hash function." }
  if (-not (Test-Path -LiteralPath $PathText)) { Stop-Closeout "missing file: $PathText" }
  return (Get-FileHash -LiteralPath $PathText -Algorithm SHA256).Hash
}

function Get-ReceiptValue {
  param(
    [string]$ReceiptText,
    [string]$Key
  )
  $Pattern = "(?m)^" + [regex]::Escape($Key) + ":\s*(.+?)\s*$"
  $Match = [regex]::Match($ReceiptText, $Pattern)
  if (-not $Match.Success) { return "" }
  return [string]$Match.Groups[1].Value.Trim()
}

function Import-CsvSafe {
  param([string]$PathText)
  if (-not (Test-Path -LiteralPath $PathText)) { Stop-Closeout "missing CSV: $PathText" }
  $Item = Get-Item -LiteralPath $PathText
  if ($Item.Length -eq 0) { return @() }
  return @(Import-Csv -LiteralPath $PathText)
}

function Get-Prop {
  param(
    [object]$Row,
    [string[]]$Names
  )
  foreach ($Name in $Names) {
    $Prop = $Row.PSObject.Properties[$Name]
    if ($null -ne $Prop) { return [string]$Prop.Value }
  }
  return ""
}

function Resolve-PathMaybe {
  param(
    [string]$PathText,
    [string]$FallbackName
  )
  if (-not [string]::IsNullOrWhiteSpace($PathText)) {
    return [System.IO.Path]::GetFullPath($PathText)
  }
  if (-not [string]::IsNullOrWhiteSpace($FallbackName)) {
    return [System.IO.Path]::GetFullPath((Join-Path $RootPath $FallbackName))
  }
  return ""
}

function Assert-InBase {
  param([string]$PathText)
  $FullBase = [System.IO.Path]::GetFullPath($Base).TrimEnd("\")
  $FullPath = [System.IO.Path]::GetFullPath($PathText)
  if (-not $FullPath.StartsWith($FullBase, [System.StringComparison]::OrdinalIgnoreCase)) {
    Stop-Closeout "output path outside helper preflight area: $FullPath"
  }
}

function Add-Issue {
  param(
    [System.Collections.ArrayList]$List,
    [string]$Class,
    [string]$Name,
    [string]$PathText,
    [string]$Issue
  )
  [void]$List.Add([pscustomobject]@{
    IssueClass = $Class
    Name = $Name
    Path = $PathText
    Issue = $Issue
  })
}

if (-not (Test-Path -LiteralPath $RootPath)) { Stop-Closeout "root path missing: $RootPath" }
if (-not (Test-Path -LiteralPath $Base)) { Stop-Closeout "base path missing: $Base" }

if ([string]::IsNullOrWhiteSpace($ActionTablePath)) {
  $ActionTablePath = Resolve-LatestFile -Folder $Base -Pattern "ROUTE_55_EXECUTOR_ACTION_TABLE_APPROVED_FOR_BUILD_NOT_RUN_V0_1_*.csv" -Label "Route 55 action table" -Required
}
if ([string]::IsNullOrWhiteSpace($RunReceiptPath)) {
  $RunReceiptPath = Resolve-LatestFile -Folder $Base -Pattern "HASH_RECEIPT__ROUTE_55_EXECUTOR_RUN_*.txt" -Label "Route 55 executor run receipt" -Required
}
if ([string]::IsNullOrWhiteSpace($HoldOrLeaveCsvPath)) {
  $HoldOrLeaveCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_HOLD_OR_LEAVE_ROWS*.csv" -Label "Route 55 hold-or-leave CSV" -Required
}
if ([string]::IsNullOrWhiteSpace($ReviewedDeltaCsvPath)) {
  $ReviewedDeltaCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_74_REVIEWED_DELTA_ROWS*.csv" -Label "V0.2 74 reviewed-delta CSV"
}

$ReportPath = Join-Path $Base "ROUTE_55_EXECUTOR_CLOSEOUT_VERIFICATION_REPORT_V0_1_$RunStamp.md"
$IssueCsvPath = Join-Path $Base "ROUTE_55_EXECUTOR_CLOSEOUT_VERIFICATION_ISSUES_V0_1_$RunStamp.csv"
$RouteCloseoutCsvPath = Join-Path $Base "ROUTE_55_EXECUTOR_CLOSEOUT_55_DESTINATION_PROOF_V0_1_$RunStamp.csv"
$HoldCloseoutCsvPath = Join-Path $Base "ROUTE_55_EXECUTOR_CLOSEOUT_3_HOLD_PROOF_V0_1_$RunStamp.csv"
$ReviewedDeltaCloseoutCsvPath = Join-Path $Base "ROUTE_55_EXECUTOR_CLOSEOUT_74_REVIEWED_DELTA_PROOF_V0_1_$RunStamp.csv"
$ReceiptPath = Join-Path $Base "HASH_RECEIPT__ROUTE_55_EXECUTOR_CLOSEOUT_VERIFICATION_V0_1_$RunStamp.txt"

foreach ($OutPath in @($ReportPath,$IssueCsvPath,$RouteCloseoutCsvPath,$HoldCloseoutCsvPath,$ReviewedDeltaCloseoutCsvPath,$ReceiptPath)) {
  Assert-InBase -PathText $OutPath
  if (Test-Path -LiteralPath $OutPath) { Stop-Closeout "output already exists: $OutPath" }
}

$ActionTableHash = Get-HashStrict -PathText $ActionTablePath
$RunReceiptHash = Get-HashStrict -PathText $RunReceiptPath
$HoldOrLeaveHash = Get-HashStrict -PathText $HoldOrLeaveCsvPath
$ReviewedDeltaHash = ""
if (-not [string]::IsNullOrWhiteSpace($ReviewedDeltaCsvPath)) { $ReviewedDeltaHash = Get-HashStrict -PathText $ReviewedDeltaCsvPath }

$RunReceiptText = Get-Content -LiteralPath $RunReceiptPath -Raw
$ReceiptFinalVerdict = Get-ReceiptValue -ReceiptText $RunReceiptText -Key "final_verdict"
$ReceiptExecutedMoveCount = Get-ReceiptValue -ReceiptText $RunReceiptText -Key "executed_move_count"
$ReceiptValidationIssueCount = Get-ReceiptValue -ReceiptText $RunReceiptText -Key "validation_issue_count"
$ReceiptRouteRowCount = Get-ReceiptValue -ReceiptText $RunReceiptText -Key "route_row_count"
$ReceiptPhysicalActions = Get-ReceiptValue -ReceiptText $RunReceiptText -Key "physical_actions"

$IssueRows = [System.Collections.ArrayList]::new()

if ($ReceiptFinalVerdict -ne "ROUTE_55_EXECUTOR_RUN_COMPLETE_VERIFY_CLOSEOUT_REQUIRED") {
  Add-Issue -List $IssueRows -Class "RUN_RECEIPT" -Name "final_verdict" -PathText $RunReceiptPath -Issue "expected ROUTE_55_EXECUTOR_RUN_COMPLETE_VERIFY_CLOSEOUT_REQUIRED, found $ReceiptFinalVerdict"
}
if ($ReceiptRouteRowCount -ne "55") {
  Add-Issue -List $IssueRows -Class "RUN_RECEIPT" -Name "route_row_count" -PathText $RunReceiptPath -Issue "expected 55, found $ReceiptRouteRowCount"
}
if ($ReceiptValidationIssueCount -ne "0") {
  Add-Issue -List $IssueRows -Class "RUN_RECEIPT" -Name "validation_issue_count" -PathText $RunReceiptPath -Issue "expected 0, found $ReceiptValidationIssueCount"
}
if ($ReceiptExecutedMoveCount -ne "55") {
  Add-Issue -List $IssueRows -Class "RUN_RECEIPT" -Name "executed_move_count" -PathText $RunReceiptPath -Issue "expected 55, found $ReceiptExecutedMoveCount"
}
if ($ReceiptPhysicalActions -ne "move=55 delete=0 rename=0 route=55 cleanup=0 execute_helpers=0 commit=0 push=0") {
  Add-Issue -List $IssueRows -Class "RUN_RECEIPT" -Name "physical_actions" -PathText $RunReceiptPath -Issue "unexpected physical action line: $ReceiptPhysicalActions"
}

$ActionRows = @(Import-CsvSafe -PathText $ActionTablePath)
$HoldRows = @(Import-CsvSafe -PathText $HoldOrLeaveCsvPath)
$ReviewedDeltaRows = @()
if (-not [string]::IsNullOrWhiteSpace($ReviewedDeltaCsvPath)) { $ReviewedDeltaRows = @(Import-CsvSafe -PathText $ReviewedDeltaCsvPath) }

if ($ActionRows.Count -ne 55) { Add-Issue -List $IssueRows -Class "ACTION_TABLE" -Name "row_count" -PathText $ActionTablePath -Issue "expected 55, found $($ActionRows.Count)" }
if ($HoldRows.Count -ne 3) { Add-Issue -List $IssueRows -Class "HOLD_TABLE" -Name "row_count" -PathText $HoldOrLeaveCsvPath -Issue "expected 3, found $($HoldRows.Count)" }
if (-not [string]::IsNullOrWhiteSpace($ReviewedDeltaCsvPath) -and $ReviewedDeltaRows.Count -ne 74) {
  Add-Issue -List $IssueRows -Class "REVIEWED_DELTA_TABLE" -Name "row_count" -PathText $ReviewedDeltaCsvPath -Issue "expected 74, found $($ReviewedDeltaRows.Count)"
}
if ([string]::IsNullOrWhiteSpace($ReviewedDeltaCsvPath)) {
  Add-Issue -List $IssueRows -Class "REVIEWED_DELTA_TABLE" -Name "missing_csv" -PathText $Base -Issue "could not find V0.2 74 reviewed-delta CSV; closeout cannot prove reviewed-delta files stayed untouched."
}

$RouteProofRows = [System.Collections.ArrayList]::new()
foreach ($Row in $ActionRows) {
  $Name = Get-Prop -Row $Row -Names @("Name")
  $SourcePath = Resolve-PathMaybe -PathText (Get-Prop -Row $Row -Names @("SourcePath")) -FallbackName $Name
  $DestinationPath = Resolve-PathMaybe -PathText (Get-Prop -Row $Row -Names @("DestinationPath")) -FallbackName ""
  $ExpectedHash = (Get-Prop -Row $Row -Names @("ExpectedSHA256","SHA256","LiveSHA256")).Trim().ToUpperInvariant()
  $ExpectedSize = (Get-Prop -Row $Row -Names @("ExpectedSizeBytes","SizeBytes","LiveSizeBytes")).Trim()

  $SourceExists = (-not [string]::IsNullOrWhiteSpace($SourcePath)) -and (Test-Path -LiteralPath $SourcePath)
  $DestinationExists = (-not [string]::IsNullOrWhiteSpace($DestinationPath)) -and (Test-Path -LiteralPath $DestinationPath)
  $DestinationHash = ""
  $DestinationSize = ""
  $HashMatch = $false
  $SizeMatch = $false

  if ($DestinationExists) {
    $DestinationHash = (Get-FileHash -LiteralPath $DestinationPath -Algorithm SHA256).Hash
    $DestinationSize = [string](Get-Item -LiteralPath $DestinationPath).Length
    if (-not [string]::IsNullOrWhiteSpace($ExpectedHash)) { $HashMatch = $DestinationHash.Equals($ExpectedHash, [System.StringComparison]::OrdinalIgnoreCase) }
    if (-not [string]::IsNullOrWhiteSpace($ExpectedSize)) { $SizeMatch = ($DestinationSize -eq $ExpectedSize) }
  }

  if ($SourceExists) { Add-Issue -List $IssueRows -Class "ROUTE_55_SOURCE" -Name $Name -PathText $SourcePath -Issue "source still exists after route" }
  if (-not $DestinationExists) { Add-Issue -List $IssueRows -Class "ROUTE_55_DESTINATION" -Name $Name -PathText $DestinationPath -Issue "destination missing after route" }
  if ($DestinationExists -and -not $HashMatch) { Add-Issue -List $IssueRows -Class "ROUTE_55_DESTINATION" -Name $Name -PathText $DestinationPath -Issue "destination hash mismatch" }
  if ($DestinationExists -and -not $SizeMatch) { Add-Issue -List $IssueRows -Class "ROUTE_55_DESTINATION" -Name $Name -PathText $DestinationPath -Issue "destination size mismatch" }

  [void]$RouteProofRows.Add([pscustomobject]@{
    Name = $Name
    SourcePath = $SourcePath
    SourceExistsAfterRoute = $SourceExists
    DestinationPath = $DestinationPath
    DestinationExistsAfterRoute = $DestinationExists
    ExpectedSHA256 = $ExpectedHash
    DestinationSHA256 = $DestinationHash
    HashMatch = $HashMatch
    ExpectedSizeBytes = $ExpectedSize
    DestinationSizeBytes = $DestinationSize
    SizeMatch = $SizeMatch
  })
}

$HoldProofRows = [System.Collections.ArrayList]::new()
foreach ($Row in $HoldRows) {
  $Name = Get-Prop -Row $Row -Names @("Name")
  $HoldPath = Resolve-PathMaybe -PathText (Get-Prop -Row $Row -Names @("SourcePath","LivePath")) -FallbackName $Name
  $ExpectedHash = (Get-Prop -Row $Row -Names @("LiveSHA256","ExpectedSHA256","SHA256")).Trim().ToUpperInvariant()
  $ExpectedSize = (Get-Prop -Row $Row -Names @("LiveSizeBytes","ExpectedSizeBytes","SizeBytes")).Trim()

  $Exists = (-not [string]::IsNullOrWhiteSpace($HoldPath)) -and (Test-Path -LiteralPath $HoldPath)
  $ActualHash = ""
  $ActualSize = ""
  $HashMatch = $false
  $SizeMatch = $false

  if ($Exists) {
    $ActualHash = (Get-FileHash -LiteralPath $HoldPath -Algorithm SHA256).Hash
    $ActualSize = [string](Get-Item -LiteralPath $HoldPath).Length
    if (-not [string]::IsNullOrWhiteSpace($ExpectedHash)) { $HashMatch = $ActualHash.Equals($ExpectedHash, [System.StringComparison]::OrdinalIgnoreCase) }
    if (-not [string]::IsNullOrWhiteSpace($ExpectedSize)) { $SizeMatch = ($ActualSize -eq $ExpectedSize) }
  }

  if (-not $Exists) { Add-Issue -List $IssueRows -Class "HOLD_ROW" -Name $Name -PathText $HoldPath -Issue "hold row missing after route" }
  if ($Exists -and -not $HashMatch) { Add-Issue -List $IssueRows -Class "HOLD_ROW" -Name $Name -PathText $HoldPath -Issue "hold row hash mismatch" }
  if ($Exists -and -not $SizeMatch) { Add-Issue -List $IssueRows -Class "HOLD_ROW" -Name $Name -PathText $HoldPath -Issue "hold row size mismatch" }

  [void]$HoldProofRows.Add([pscustomobject]@{
    Name = $Name
    HoldPath = $HoldPath
    ExistsAfterRoute = $Exists
    ExpectedSHA256 = $ExpectedHash
    ActualSHA256 = $ActualHash
    HashMatch = $HashMatch
    ExpectedSizeBytes = $ExpectedSize
    ActualSizeBytes = $ActualSize
    SizeMatch = $SizeMatch
  })
}

$ReviewedDeltaProofRows = [System.Collections.ArrayList]::new()
foreach ($Row in $ReviewedDeltaRows) {
  $Name = Get-Prop -Row $Row -Names @("Name")
  $DeltaPath = Resolve-PathMaybe -PathText (Get-Prop -Row $Row -Names @("SourcePath","LivePath")) -FallbackName $Name
  $ExpectedHash = (Get-Prop -Row $Row -Names @("LiveSHA256","ExpectedSHA256","SHA256")).Trim().ToUpperInvariant()
  $ExpectedSize = (Get-Prop -Row $Row -Names @("LiveSizeBytes","ExpectedSizeBytes","SizeBytes")).Trim()

  $Exists = (-not [string]::IsNullOrWhiteSpace($DeltaPath)) -and (Test-Path -LiteralPath $DeltaPath)
  $ActualHash = ""
  $ActualSize = ""
  $HashMatch = $false
  $SizeMatch = $false

  if ($Exists) {
    $ActualHash = (Get-FileHash -LiteralPath $DeltaPath -Algorithm SHA256).Hash
    $ActualSize = [string](Get-Item -LiteralPath $DeltaPath).Length
    if (-not [string]::IsNullOrWhiteSpace($ExpectedHash)) { $HashMatch = $ActualHash.Equals($ExpectedHash, [System.StringComparison]::OrdinalIgnoreCase) }
    if (-not [string]::IsNullOrWhiteSpace($ExpectedSize)) { $SizeMatch = ($ActualSize -eq $ExpectedSize) }
  }

  if (-not $Exists) { Add-Issue -List $IssueRows -Class "REVIEWED_DELTA" -Name $Name -PathText $DeltaPath -Issue "reviewed delta missing after route" }
  if ($Exists -and -not $HashMatch) { Add-Issue -List $IssueRows -Class "REVIEWED_DELTA" -Name $Name -PathText $DeltaPath -Issue "reviewed delta hash mismatch" }
  if ($Exists -and -not [string]::IsNullOrWhiteSpace($ExpectedSize) -and -not $SizeMatch) { Add-Issue -List $IssueRows -Class "REVIEWED_DELTA" -Name $Name -PathText $DeltaPath -Issue "reviewed delta size mismatch" }

  [void]$ReviewedDeltaProofRows.Add([pscustomobject]@{
    Name = $Name
    DeltaPath = $DeltaPath
    ExistsAfterRoute = $Exists
    ExpectedSHA256 = $ExpectedHash
    ActualSHA256 = $ActualHash
    HashMatch = $HashMatch
    ExpectedSizeBytes = $ExpectedSize
    ActualSizeBytes = $ActualSize
    SizeMatch = $SizeMatch
  })
}

$RouteProofRows | Export-Csv -LiteralPath $RouteCloseoutCsvPath -NoTypeInformation -Encoding UTF8
$HoldProofRows | Export-Csv -LiteralPath $HoldCloseoutCsvPath -NoTypeInformation -Encoding UTF8
$ReviewedDeltaProofRows | Export-Csv -LiteralPath $ReviewedDeltaCloseoutCsvPath -NoTypeInformation -Encoding UTF8
$IssueRows | Export-Csv -LiteralPath $IssueCsvPath -NoTypeInformation -Encoding UTF8

$RouteProofHash = Get-HashStrict -PathText $RouteCloseoutCsvPath
$HoldProofHash = Get-HashStrict -PathText $HoldCloseoutCsvPath
$ReviewedDeltaProofHash = Get-HashStrict -PathText $ReviewedDeltaCloseoutCsvPath
$IssueCsvHash = Get-HashStrict -PathText $IssueCsvPath

$RouteMovedProofCount = @($RouteProofRows | Where-Object { $_.SourceExistsAfterRoute -eq $false -and $_.DestinationExistsAfterRoute -eq $true -and $_.HashMatch -eq $true -and $_.SizeMatch -eq $true }).Count
$HoldVerifiedCount = @($HoldProofRows | Where-Object { $_.ExistsAfterRoute -eq $true -and $_.HashMatch -eq $true -and $_.SizeMatch -eq $true }).Count
$ReviewedDeltaVerifiedCount = @($ReviewedDeltaProofRows | Where-Object { $_.ExistsAfterRoute -eq $true -and $_.HashMatch -eq $true }).Count
$IssueCount = @($IssueRows).Count

$FinalVerdict = "ROUTE_55_CLOSEOUT_VERIFIED_READY_FOR_HOLD_ROWS_REVIEW"
$NextSingleAction = "REVIEW_3_HOLD_OR_LEAVE_ROWS_SEPARATELY_NO_CLEANUP"
if ($IssueCount -ne 0) {
  $FinalVerdict = "ROUTE_55_CLOSEOUT_BLOCKED_REVIEW_ISSUES"
  $NextSingleAction = "INSPECT_ROUTE_55_CLOSEOUT_ISSUES_NO_CLEANUP"
}

$ReportText = @"
# ROUTE 55 EXECUTOR CLOSEOUT VERIFICATION V0_1

Status:
CLOSEOUT_VERIFICATION / POST_ROUTE_55 / NO_CLEANUP / NO_DELETE / NO_RENAME / NO_COMMIT / NO_PUSH

Run receipt:
$RunReceiptPath

Run receipt SHA256:
$RunReceiptHash

Action table:
$ActionTablePath

Action table SHA256:
$ActionTableHash

Hold-or-leave CSV:
$HoldOrLeaveCsvPath

Hold-or-leave CSV SHA256:
$HoldOrLeaveHash

Reviewed-delta CSV:
$ReviewedDeltaCsvPath

Reviewed-delta CSV SHA256:
$ReviewedDeltaHash

Counts:
- route_row_count: $($ActionRows.Count)
- route_moved_and_hash_verified_count: $RouteMovedProofCount
- hold_or_leave_count: $($HoldRows.Count)
- hold_verified_unchanged_count: $HoldVerifiedCount
- reviewed_delta_count: $($ReviewedDeltaRows.Count)
- reviewed_delta_verified_unchanged_count: $ReviewedDeltaVerifiedCount
- issue_count: $IssueCount

Output CSVs:
- route_closeout_csv: $RouteCloseoutCsvPath
- route_closeout_csv_sha256: $RouteProofHash
- hold_closeout_csv: $HoldCloseoutCsvPath
- hold_closeout_csv_sha256: $HoldProofHash
- reviewed_delta_closeout_csv: $ReviewedDeltaCloseoutCsvPath
- reviewed_delta_closeout_csv_sha256: $ReviewedDeltaProofHash
- issue_csv: $IssueCsvPath
- issue_csv_sha256: $IssueCsvHash

Final verdict:
$FinalVerdict

Next single action:
$NextSingleAction

Boundary:
This closeout verifier does not clean root.
This closeout verifier does not delete, rename, move, route, execute helpers, commit, or push.
It verifies the Route 55 move result and preserves the separate hold-row review boundary.

Physical actions:
move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0
"@

$ReportText | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportHash = Get-HashStrict -PathText $ReportPath

$ReceiptText = @"
report_path: $ReportPath
report_sha256: $ReportHash
route_closeout_csv_path: $RouteCloseoutCsvPath
route_closeout_csv_sha256: $RouteProofHash
hold_closeout_csv_path: $HoldCloseoutCsvPath
hold_closeout_csv_sha256: $HoldProofHash
reviewed_delta_closeout_csv_path: $ReviewedDeltaCloseoutCsvPath
reviewed_delta_closeout_csv_sha256: $ReviewedDeltaProofHash
issue_csv_path: $IssueCsvPath
issue_csv_sha256: $IssueCsvHash
run_receipt_path: $RunReceiptPath
run_receipt_sha256: $RunReceiptHash
action_table_path: $ActionTablePath
action_table_sha256: $ActionTableHash
route_row_count: $($ActionRows.Count)
route_moved_and_hash_verified_count: $RouteMovedProofCount
hold_or_leave_count: $($HoldRows.Count)
hold_verified_unchanged_count: $HoldVerifiedCount
reviewed_delta_count: $($ReviewedDeltaRows.Count)
reviewed_delta_verified_unchanged_count: $ReviewedDeltaVerifiedCount
issue_count: $IssueCount
final_verdict: $FinalVerdict
next_single_action: $NextSingleAction
physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0
"@

$ReceiptText | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptHash = Get-HashStrict -PathText $ReceiptPath

"=== ROUTE 55 CLOSEOUT VERIFICATION COMPLETE ==="
"report_path: $ReportPath"
"report_sha256: $ReportHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"route_row_count: $($ActionRows.Count)"
"route_moved_and_hash_verified_count: $RouteMovedProofCount"
"hold_or_leave_count: $($HoldRows.Count)"
"hold_verified_unchanged_count: $HoldVerifiedCount"
"reviewed_delta_count: $($ReviewedDeltaRows.Count)"
"reviewed_delta_verified_unchanged_count: $ReviewedDeltaVerifiedCount"
"issue_count: $IssueCount"
"final_verdict: $FinalVerdict"
"next_single_action: $NextSingleAction"
"physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0"
