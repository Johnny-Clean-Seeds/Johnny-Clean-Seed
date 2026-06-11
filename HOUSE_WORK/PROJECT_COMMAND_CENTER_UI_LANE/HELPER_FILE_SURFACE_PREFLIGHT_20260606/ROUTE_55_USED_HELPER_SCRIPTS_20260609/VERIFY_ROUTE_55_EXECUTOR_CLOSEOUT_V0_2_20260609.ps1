param(
  [string]$RootPath = "C:\Users\13527\Desktop\123",
  [string]$Base = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606",
  [string]$ActionTablePath = "",
  [string]$HoldOrLeaveCsvPath = "",
  [string]$ExecutorRunReceiptPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

function Stop-Closeout {
  param([string]$Message)
  throw "STOP: $Message"
}

function Get-HashIfExists {
  param([string]$PathText)
  if ([string]::IsNullOrWhiteSpace($PathText)) { return "" }
  if (-not (Test-Path -LiteralPath $PathText)) { return "" }
  return (Get-FileHash -LiteralPath $PathText -Algorithm SHA256).Hash
}

function Get-SizeIfExists {
  param([string]$PathText)
  if ([string]::IsNullOrWhiteSpace($PathText)) { return "" }
  if (-not (Test-Path -LiteralPath $PathText)) { return "" }
  return [string](Get-Item -LiteralPath $PathText -Force).Length
}

function Resolve-LatestFile {
  param(
    [string]$Folder,
    [string]$Pattern,
    [string]$Label
  )
  $Matches = @(Get-ChildItem -LiteralPath $Folder -Filter $Pattern -File -Force | Sort-Object LastWriteTimeUtc -Descending)
  if ($Matches.Count -lt 1) { Stop-Closeout "could not find $Label with pattern $Pattern in $Folder" }
  return [string]$Matches[0].FullName
}

function Read-TextStrict {
  param([string]$PathText)
  if (-not (Test-Path -LiteralPath $PathText)) { Stop-Closeout "missing text file: $PathText" }
  return Get-Content -LiteralPath $PathText -Raw
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
  if (-not (Test-Path -LiteralPath $PathText)) { Stop-Closeout "missing csv file: $PathText" }
  $Item = Get-Item -LiteralPath $PathText -Force
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

function Assert-InBase {
  param([string]$PathText)
  $FullBase = [System.IO.Path]::GetFullPath($Base).TrimEnd("\")
  $FullPath = [System.IO.Path]::GetFullPath($PathText)
  if (-not $FullPath.StartsWith($FullBase, [System.StringComparison]::OrdinalIgnoreCase)) {
    Stop-Closeout "output path outside helper preflight work area: $FullPath"
  }
}

if (-not (Test-Path -LiteralPath $RootPath)) { Stop-Closeout "root path missing: $RootPath" }
if (-not (Test-Path -LiteralPath $Base)) { Stop-Closeout "base path missing: $Base" }

if ([string]::IsNullOrWhiteSpace($ActionTablePath)) {
  $ActionTablePath = Resolve-LatestFile -Folder $Base -Pattern "ROUTE_55_EXECUTOR_ACTION_TABLE_APPROVED_FOR_BUILD_NOT_RUN_V0_1_*.csv" -Label "Route 55 action table"
}

if ([string]::IsNullOrWhiteSpace($ExecutorRunReceiptPath)) {
  $RunReceipts = @(Get-ChildItem -LiteralPath $Base -Filter "HASH_RECEIPT__ROUTE_55_EXECUTOR_RUN_*.txt" -File -Force | Sort-Object LastWriteTimeUtc -Descending)
  foreach ($Receipt in $RunReceipts) {
    $Text = Get-Content -LiteralPath $Receipt.FullName -Raw
    if (($Text -match "executed_move_count:\s*55") -and ($Text -match "final_verdict:\s*ROUTE_55_EXECUTOR_RUN_COMPLETE_VERIFY_CLOSEOUT_REQUIRED")) {
      $ExecutorRunReceiptPath = [string]$Receipt.FullName
      break
    }
  }
  if ([string]::IsNullOrWhiteSpace($ExecutorRunReceiptPath)) { Stop-Closeout "could not find Route 55 executor run receipt with executed_move_count 55." }
}

if ([string]::IsNullOrWhiteSpace($HoldOrLeaveCsvPath)) {
  $ApprovalReceiptPath = Resolve-LatestFile -Folder $Base -Pattern "HASH_RECEIPT__ROUTE_55_CANDIDATES_APPROVAL_PACKET_NO_EXECUTION_*.txt" -Label "Route 55 approval receipt"
  $ApprovalReceiptText = Read-TextStrict -PathText $ApprovalReceiptPath
  $HoldOrLeaveCsvPath = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "hold_or_leave_csv_path"
  if ([string]::IsNullOrWhiteSpace($HoldOrLeaveCsvPath)) {
    $HoldOrLeaveCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_HOLD_OR_LEAVE_ROWS*.csv" -Label "Route 55 hold-or-leave CSV"
  }
}

$ActionTableHash = Get-HashIfExists -PathText $ActionTablePath
$ExecutorRunReceiptText = Read-TextStrict -PathText $ExecutorRunReceiptPath
$ExecutorRunReceiptHash = Get-HashIfExists -PathText $ExecutorRunReceiptPath
$HoldOrLeaveCsvHash = Get-HashIfExists -PathText $HoldOrLeaveCsvPath

if ($ExecutorRunReceiptText -notmatch "executed_move_count:\s*55") { Stop-Closeout "executor run receipt does not prove executed_move_count 55." }
if ($ExecutorRunReceiptText -notmatch "physical_actions:\s*move=55 delete=0 rename=0 route=55 cleanup=0 execute_helpers=0 commit=0 push=0") { Stop-Closeout "executor run receipt does not show the expected physical action counters." }

$ActionRows = @(Import-CsvSafe -PathText $ActionTablePath)
$HoldRows = @(Import-CsvSafe -PathText $HoldOrLeaveCsvPath)

if ($ActionRows.Count -ne 55) { Stop-Closeout "expected 55 action rows, found $($ActionRows.Count)." }
if ($HoldRows.Count -ne 3) { Stop-Closeout "expected 3 hold-or-leave rows, found $($HoldRows.Count)." }

$RouteVerifyRows = [System.Collections.ArrayList]::new()
$HoldVerifyRows = [System.Collections.ArrayList]::new()
$IssueRows = [System.Collections.ArrayList]::new()

foreach ($Row in $ActionRows) {
  $RouteID = Get-Prop -Row $Row -Names @("RouteID")
  $Name = Get-Prop -Row $Row -Names @("Name")
  $SourcePath = Get-Prop -Row $Row -Names @("SourcePath")
  $DestinationPath = Get-Prop -Row $Row -Names @("DestinationPath")
  $ExpectedSHA256 = (Get-Prop -Row $Row -Names @("ExpectedSHA256")).Trim().ToUpperInvariant()
  $ExpectedSizeBytes = Get-Prop -Row $Row -Names @("ExpectedSizeBytes")

  $SourceExists = $false
  if (-not [string]::IsNullOrWhiteSpace($SourcePath)) { $SourceExists = Test-Path -LiteralPath $SourcePath }

  $DestinationExists = $false
  if (-not [string]::IsNullOrWhiteSpace($DestinationPath)) { $DestinationExists = Test-Path -LiteralPath $DestinationPath }

  $DestinationSHA256 = Get-HashIfExists -PathText $DestinationPath
  $DestinationSizeBytes = Get-SizeIfExists -PathText $DestinationPath

  $Issues = [System.Collections.ArrayList]::new()
  if ([string]::IsNullOrWhiteSpace($RouteID)) { [void]$Issues.Add("blank RouteID") }
  if ([string]::IsNullOrWhiteSpace($Name)) { [void]$Issues.Add("blank Name") }
  if ([string]::IsNullOrWhiteSpace($SourcePath)) { [void]$Issues.Add("blank SourcePath") }
  if ([string]::IsNullOrWhiteSpace($DestinationPath)) { [void]$Issues.Add("blank DestinationPath") }
  if ($SourceExists) { [void]$Issues.Add("source still exists after route") }
  if (-not $DestinationExists) { [void]$Issues.Add("destination missing after route") }
  if ([string]::IsNullOrWhiteSpace($ExpectedSHA256)) { [void]$Issues.Add("blank expected SHA256") }
  if ($DestinationExists -and -not [string]::IsNullOrWhiteSpace($ExpectedSHA256) -and -not $DestinationSHA256.Equals($ExpectedSHA256, [System.StringComparison]::OrdinalIgnoreCase)) { [void]$Issues.Add("destination SHA256 mismatch") }
  if ([string]::IsNullOrWhiteSpace($ExpectedSizeBytes)) { [void]$Issues.Add("blank expected size") }
  if ($DestinationExists -and -not [string]::IsNullOrWhiteSpace($ExpectedSizeBytes) -and $DestinationSizeBytes -ne $ExpectedSizeBytes) { [void]$Issues.Add("destination size mismatch") }

  $Verified = ($Issues.Count -eq 0)

  $RouteVerify = [pscustomobject]@{
    RouteID = $RouteID
    Name = $Name
    SourcePath = $SourcePath
    DestinationPath = $DestinationPath
    SourceExistsAfterRoute = $SourceExists
    DestinationExistsAfterRoute = $DestinationExists
    ExpectedSHA256 = $ExpectedSHA256
    DestinationSHA256 = $DestinationSHA256
    ExpectedSizeBytes = $ExpectedSizeBytes
    DestinationSizeBytes = $DestinationSizeBytes
    RouteVerified = $Verified
    Issues = ($Issues -join "; ")
  }
  [void]$RouteVerifyRows.Add($RouteVerify)

  if (-not $Verified) {
    [void]$IssueRows.Add([pscustomobject]@{
      Scope = "ROUTE_55_MOVED_ROW"
      Name = $Name
      SourcePath = $SourcePath
      DestinationPath = $DestinationPath
      Issues = ($Issues -join "; ")
    })
  }
}

foreach ($Row in $HoldRows) {
  $Name = Get-Prop -Row $Row -Names @("Name")
  $HoldPath = Get-Prop -Row $Row -Names @("LivePath","SourcePath","RootPath","FilePath")
  if ([string]::IsNullOrWhiteSpace($HoldPath) -and -not [string]::IsNullOrWhiteSpace($Name)) {
    $HoldPath = Join-Path $RootPath $Name
  }
  $ExpectedSHA256 = (Get-Prop -Row $Row -Names @("LiveSHA256","ExpectedSHA256","SHA256")).Trim().ToUpperInvariant()
  $ExpectedSizeBytes = Get-Prop -Row $Row -Names @("LiveSizeBytes","ExpectedSizeBytes","SizeBytes")
  $ProposedBucket = Get-Prop -Row $Row -Names @("ProposedBucket")
  $FutureActionOnly = Get-Prop -Row $Row -Names @("FutureActionOnly")

  $HoldExists = $false
  if (-not [string]::IsNullOrWhiteSpace($HoldPath)) { $HoldExists = Test-Path -LiteralPath $HoldPath }

  $ActualSHA256 = Get-HashIfExists -PathText $HoldPath
  $ActualSizeBytes = Get-SizeIfExists -PathText $HoldPath

  $Issues = [System.Collections.ArrayList]::new()
  if ([string]::IsNullOrWhiteSpace($Name)) { [void]$Issues.Add("blank hold Name") }
  if ([string]::IsNullOrWhiteSpace($HoldPath)) { [void]$Issues.Add("blank hold path") }
  if (-not $HoldExists) { [void]$Issues.Add("hold path missing now") }
  if ([string]::IsNullOrWhiteSpace($ExpectedSHA256)) { [void]$Issues.Add("blank expected hold SHA256") }
  if ($HoldExists -and -not [string]::IsNullOrWhiteSpace($ExpectedSHA256) -and -not $ActualSHA256.Equals($ExpectedSHA256, [System.StringComparison]::OrdinalIgnoreCase)) { [void]$Issues.Add("hold SHA256 mismatch") }
  if ([string]::IsNullOrWhiteSpace($ExpectedSizeBytes)) { [void]$Issues.Add("blank expected hold size") }
  if ($HoldExists -and -not [string]::IsNullOrWhiteSpace($ExpectedSizeBytes) -and $ActualSizeBytes -ne $ExpectedSizeBytes) { [void]$Issues.Add("hold size mismatch") }

  $Verified = ($Issues.Count -eq 0)

  $HoldVerify = [pscustomobject]@{
    Name = $Name
    HoldPath = $HoldPath
    ProposedBucket = $ProposedBucket
    FutureActionOnly = $FutureActionOnly
    HoldExists = $HoldExists
    ExpectedSHA256 = $ExpectedSHA256
    ActualSHA256 = $ActualSHA256
    ExpectedSizeBytes = $ExpectedSizeBytes
    ActualSizeBytes = $ActualSizeBytes
    HoldVerifiedUnchanged = $Verified
    Issues = ($Issues -join "; ")
  }
  [void]$HoldVerifyRows.Add($HoldVerify)

  if (-not $Verified) {
    [void]$IssueRows.Add([pscustomobject]@{
      Scope = "HOLD_OR_LEAVE_ROW"
      Name = $Name
      SourcePath = $HoldPath
      DestinationPath = ""
      Issues = ($Issues -join "; ")
    })
  }
}

$RouteVerifiedCount = @($RouteVerifyRows | Where-Object { $_.RouteVerified -eq $true }).Count
$RouteIssueCount = 55 - $RouteVerifiedCount
$HoldVerifiedCount = @($HoldVerifyRows | Where-Object { $_.HoldVerifiedUnchanged -eq $true }).Count
$HoldIssueCount = 3 - $HoldVerifiedCount
$IssueCount = @($IssueRows).Count

$FinalVerdict = "ROUTE_55_CLOSEOUT_BLOCKED_REVIEW_ISSUES_FOUND"
$NextSingleAction = "REVIEW_ROUTE_55_CLOSEOUT_ISSUES"

if (($RouteVerifiedCount -eq 55) -and ($HoldVerifiedCount -eq 3) -and ($IssueCount -eq 0)) {
  $FinalVerdict = "ROUTE_55_CLOSEOUT_VERIFIED_READY_FOR_HOLD_ROWS_REVIEW"
  $NextSingleAction = "REVIEW_3_HOLD_OR_LEAVE_ROWS"
} elseif (($RouteVerifiedCount -eq 55) -and ($HoldIssueCount -gt 0)) {
  $FinalVerdict = "ROUTE_55_CLOSEOUT_ROUTE_VERIFIED_HOLD_ROWS_REQUIRE_REVIEW"
  $NextSingleAction = "REVIEW_3_HOLD_OR_LEAVE_ROWS_WITH_MISSING_OR_CHANGED_HOLD_EVIDENCE"
} elseif ($RouteIssueCount -gt 0) {
  $FinalVerdict = "ROUTE_55_CLOSEOUT_BLOCKED_ROUTE_ROW_ISSUES_FOUND"
  $NextSingleAction = "FREEZE_AND_REVIEW_ROUTE_55_MOVED_ROW_ISSUES"
}

$RouteVerifyCsvPath = Join-Path $Base "ROUTE_55_CLOSEOUT_ROUTE_VERIFICATION_V0_2_$RunStamp.csv"
$HoldVerifyCsvPath = Join-Path $Base "ROUTE_55_CLOSEOUT_HOLD_VERIFICATION_V0_2_$RunStamp.csv"
$IssueCsvPath = Join-Path $Base "ROUTE_55_CLOSEOUT_ISSUES_V0_2_$RunStamp.csv"
$ReportPath = Join-Path $Base "ROUTE_55_CLOSEOUT_REPORT_V0_2_$RunStamp.md"
$ReceiptPath = Join-Path $Base "HASH_RECEIPT__ROUTE_55_CLOSEOUT_V0_2_$RunStamp.txt"

foreach ($OutPath in @($RouteVerifyCsvPath,$HoldVerifyCsvPath,$IssueCsvPath,$ReportPath,$ReceiptPath)) {
  Assert-InBase -PathText $OutPath
}

$RouteVerifyRows | Export-Csv -LiteralPath $RouteVerifyCsvPath -NoTypeInformation -Encoding UTF8
$HoldVerifyRows | Export-Csv -LiteralPath $HoldVerifyCsvPath -NoTypeInformation -Encoding UTF8
$IssueRows | Export-Csv -LiteralPath $IssueCsvPath -NoTypeInformation -Encoding UTF8

$RouteVerifyCsvHash = Get-HashIfExists -PathText $RouteVerifyCsvPath
$HoldVerifyCsvHash = Get-HashIfExists -PathText $HoldVerifyCsvPath
$IssueCsvHash = Get-HashIfExists -PathText $IssueCsvPath

$IssueBlock = "none"
if ($IssueCount -gt 0) {
  $IssueBlock = (($IssueRows | ForEach-Object { "- [$($_.Scope)] $($_.Name): $($_.Issues)" }) -join "`r`n")
}

$ReportText = @"
# ROUTE 55 EXECUTOR CLOSEOUT REPORT V0_2

Status:
CLOSEOUT_REVIEW_BUILT / NO_NEW_PHYSICAL_ACTION / ROUTE_55_ONLY

Executor run receipt:
$ExecutorRunReceiptPath

Executor run receipt SHA256:
$ExecutorRunReceiptHash

Action table:
$ActionTablePath

Action table SHA256:
$ActionTableHash

Hold-or-leave CSV:
$HoldOrLeaveCsvPath

Hold-or-leave CSV SHA256:
$HoldOrLeaveCsvHash

Counts:
- route_row_count: $($ActionRows.Count)
- route_moved_and_hash_verified_count: $RouteVerifiedCount
- route_issue_count: $RouteIssueCount
- hold_or_leave_count: $($HoldRows.Count)
- hold_verified_unchanged_count: $HoldVerifiedCount
- hold_issue_count: $HoldIssueCount
- issue_count: $IssueCount

Output hashes:
- route_verify_csv_sha256: $RouteVerifyCsvHash
- hold_verify_csv_sha256: $HoldVerifyCsvHash
- issue_csv_sha256: $IssueCsvHash

Issues:
$IssueBlock

Final verdict:
$FinalVerdict

Next single action:
$NextSingleAction

Boundary:
This closeout verifier did not move, delete, rename, route, cleanup, execute helpers, commit, or push.
If hold rows show missing or changed evidence, that is a hold-row review issue, not proof that the 55 routed files failed.

Physical actions:
move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0
"@

$ReportText | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportHash = Get-HashIfExists -PathText $ReportPath

$ReceiptText = @"
report_path: $ReportPath
report_sha256: $ReportHash
route_verify_csv_path: $RouteVerifyCsvPath
route_verify_csv_sha256: $RouteVerifyCsvHash
hold_verify_csv_path: $HoldVerifyCsvPath
hold_verify_csv_sha256: $HoldVerifyCsvHash
issue_csv_path: $IssueCsvPath
issue_csv_sha256: $IssueCsvHash
executor_run_receipt_path: $ExecutorRunReceiptPath
executor_run_receipt_sha256: $ExecutorRunReceiptHash
action_table_path: $ActionTablePath
action_table_sha256: $ActionTableHash
hold_or_leave_csv_path: $HoldOrLeaveCsvPath
hold_or_leave_csv_sha256: $HoldOrLeaveCsvHash
route_row_count: $($ActionRows.Count)
route_moved_and_hash_verified_count: $RouteVerifiedCount
route_issue_count: $RouteIssueCount
hold_or_leave_count: $($HoldRows.Count)
hold_verified_unchanged_count: $HoldVerifiedCount
hold_issue_count: $HoldIssueCount
issue_count: $IssueCount
final_verdict: $FinalVerdict
next_single_action: $NextSingleAction
physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0
"@

$ReceiptText | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptHash = Get-HashIfExists -PathText $ReceiptPath

"=== ROUTE 55 CLOSEOUT VERIFY V0_2 COMPLETE ==="
"report_path: $ReportPath"
"report_sha256: $ReportHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"route_row_count: $($ActionRows.Count)"
"route_moved_and_hash_verified_count: $RouteVerifiedCount"
"route_issue_count: $RouteIssueCount"
"hold_or_leave_count: $($HoldRows.Count)"
"hold_verified_unchanged_count: $HoldVerifiedCount"
"hold_issue_count: $HoldIssueCount"
"issue_count: $IssueCount"
"final_verdict: $FinalVerdict"
"next_single_action: $NextSingleAction"
"physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0"
