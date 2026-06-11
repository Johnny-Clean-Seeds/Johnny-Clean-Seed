param(
  [string]$ActionTablePath = "C:\\Users\\13527\\Desktop\\123\\HOUSE_WORK\\PROJECT_COMMAND_CENTER_UI_LANE\\HELPER_FILE_SURFACE_PREFLIGHT_20260606\\ROUTE_55_EXECUTOR_ACTION_TABLE_APPROVED_FOR_BUILD_NOT_RUN_V0_1_20260609_204546.csv",
  [string]$ExpectedActionTableSHA256 = "0FE829D5089DF3D5591E6B53D0055B4F967F48F6AE540EA0F2D7C041A6510D06",
  [string]$ApprovalPhrase = "",
  [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RequiredApprovalPhrase = "APPROVE_RUN_ROUTE_55_EXECUTOR_ONLY"
$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

function Stop-Route55 {
  param([string]$Message)
  throw "STOP: $Message"
}

function Get-HashStrict {
  param([string]$PathText)
  if ([string]::IsNullOrWhiteSpace($PathText)) { Stop-Route55 "blank path passed to hash function." }
  if (-not (Test-Path -LiteralPath $PathText)) { Stop-Route55 "missing file: $PathText" }
  return (Get-FileHash -LiteralPath $PathText -Algorithm SHA256).Hash
}

function Test-ChildPath {
  param(
    [string]$Parent,
    [string]$Child
  )
  $ParentFull = [System.IO.Path]::GetFullPath($Parent).TrimEnd("\")
  $ChildFull = [System.IO.Path]::GetFullPath($Child)
  return $ChildFull.StartsWith($ParentFull, [System.StringComparison]::OrdinalIgnoreCase)
}

$Base = Split-Path -Parent $ActionTablePath
$ReportPath = Join-Path $Base "ROUTE_55_EXECUTOR_RUN_REPORT_$RunStamp.md"
$ReceiptPath = Join-Path $Base "HASH_RECEIPT__ROUTE_55_EXECUTOR_RUN_$RunStamp.txt"

if (-not (Test-Path -LiteralPath $ActionTablePath)) { Stop-Route55 "action table missing: $ActionTablePath" }

$ActualActionTableSHA256 = Get-HashStrict -PathText $ActionTablePath
if ($ActualActionTableSHA256 -ne $ExpectedActionTableSHA256) {
  Stop-Route55 "action table hash mismatch. Expected $ExpectedActionTableSHA256 found $ActualActionTableSHA256"
}

$Rows = @(Import-Csv -LiteralPath $ActionTablePath)
if ($Rows.Count -ne 55) { Stop-Route55 "expected 55 route rows, found $($Rows.Count)." }

$ValidationIssues = New-Object System.Collections.ArrayList

foreach ($Row in $Rows) {
  $IssueList = New-Object System.Collections.ArrayList

  if ([string]::IsNullOrWhiteSpace($Row.SourcePath)) { [void]$IssueList.Add("blank source") }
  if ([string]::IsNullOrWhiteSpace($Row.DestinationPath)) { [void]$IssueList.Add("blank destination") }
  if ($Row.ApprovedForRun -ne "NO") { [void]$IssueList.Add("ApprovedForRun must remain NO before execution") }
  if ($Row.DeleteAllowed -ne "NO") { [void]$IssueList.Add("DeleteAllowed must be NO") }
  if ($Row.RenameAllowed -ne "NO") { [void]$IssueList.Add("RenameAllowed must be NO") }
  if ($Row.OverwriteAllowed -ne "NO") { [void]$IssueList.Add("OverwriteAllowed must be NO") }
  if ($Row.CommitAllowed -ne "NO") { [void]$IssueList.Add("CommitAllowed must be NO") }
  if ($Row.PushAllowed -ne "NO") { [void]$IssueList.Add("PushAllowed must be NO") }

  if (-not [string]::IsNullOrWhiteSpace($Row.SourcePath) -and -not (Test-Path -LiteralPath $Row.SourcePath)) { [void]$IssueList.Add("source missing") }
  if (-not [string]::IsNullOrWhiteSpace($Row.DestinationParent) -and -not (Test-Path -LiteralPath $Row.DestinationParent)) { [void]$IssueList.Add("destination parent missing") }
  if (-not [string]::IsNullOrWhiteSpace($Row.DestinationPath) -and (Test-Path -LiteralPath $Row.DestinationPath)) { [void]$IssueList.Add("destination already exists") }

  if (-not [string]::IsNullOrWhiteSpace($Row.SourcePath) -and (Test-Path -LiteralPath $Row.SourcePath)) {
    $NowHash = Get-HashStrict -PathText $Row.SourcePath
    if (-not $NowHash.Equals($Row.ExpectedSHA256, [System.StringComparison]::OrdinalIgnoreCase)) { [void]$IssueList.Add("source hash changed") }
    $NowSize = [string](Get-Item -LiteralPath $Row.SourcePath).Length
    if ($NowSize -ne [string]$Row.ExpectedSizeBytes) { [void]$IssueList.Add("source size changed") }
  }

  if ($IssueList.Count -gt 0) {
    [void]$ValidationIssues.Add([pscustomobject]@{
      RouteID = $Row.RouteID
      Name = $Row.Name
      SourcePath = $Row.SourcePath
      DestinationPath = $Row.DestinationPath
      Issues = ($IssueList -join "; ")
    })
  }
}

$ExecutedCount = 0
$FinalVerdict = "ROUTE_55_EXECUTOR_NOT_RUN_APPROVAL_REQUIRED"

if ($ValidationIssues.Count -ne 0) {
  $FinalVerdict = "ROUTE_55_EXECUTOR_BLOCKED_VALIDATION_FAILED"
} elseif (($ApprovalPhrase -eq $RequiredApprovalPhrase) -and $Execute.IsPresent) {
  foreach ($Row in $Rows) {
    Move-Item -LiteralPath $Row.SourcePath -Destination $Row.DestinationPath -ErrorAction Stop
    $ExecutedCount++
  }
  $FinalVerdict = "ROUTE_55_EXECUTOR_RUN_COMPLETE_VERIFY_CLOSEOUT_REQUIRED"
}

$IssueBlock = "none"
if ($ValidationIssues.Count -gt 0) {
  $IssueBlock = (($ValidationIssues | ForEach-Object { "- $($_.RouteID) $($_.Name): $($_.Issues)" }) -join "`r`n")
}

$ReportText = @"
# ROUTE 55 EXECUTOR RUN REPORT

Status:
EXECUTOR_REPORT / ROUTE_55_ONLY / NO_DELETE / NO_RENAME / NO_CLEANUP / NO_COMMIT / NO_PUSH

Action table:
$ActionTablePath

Action table SHA256:
$ActualActionTableSHA256

Required approval phrase:
$RequiredApprovalPhrase

Approval phrase matched:
$(($ApprovalPhrase -eq $RequiredApprovalPhrase))

Execute switch present:
$($Execute.IsPresent)

Row count:
$($Rows.Count)

Validation issue count:
$($ValidationIssues.Count)

Executed move count:
$ExecutedCount

Validation issues:
$IssueBlock

Final verdict:
$FinalVerdict

Physical actions:
move=$ExecutedCount delete=0 rename=0 route=$ExecutedCount cleanup=0 execute_helpers=0 commit=0 push=0

DoesNotProve:
This run report does not prove route closeout.
After any execution, a separate closeout must verify sources removed, destinations present, hashes match, and hold rows stayed held.
"@

$ReportText | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportHash = Get-HashStrict -PathText $ReportPath

$ReceiptText = @"
report_path: $ReportPath
report_sha256: $ReportHash
action_table_path: $ActionTablePath
action_table_sha256: $ActualActionTableSHA256
route_row_count: $($Rows.Count)
validation_issue_count: $($ValidationIssues.Count)
executed_move_count: $ExecutedCount
final_verdict: $FinalVerdict
physical_actions: move=$ExecutedCount delete=0 rename=0 route=$ExecutedCount cleanup=0 execute_helpers=0 commit=0 push=0
"@

$ReceiptText | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptHash = Get-HashStrict -PathText $ReceiptPath

"=== ROUTE 55 EXECUTOR FINISHED ==="
"report_path: $ReportPath"
"report_sha256: $ReportHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"route_row_count: $($Rows.Count)"
"validation_issue_count: $($ValidationIssues.Count)"
"executed_move_count: $ExecutedCount"
"final_verdict: $FinalVerdict"
"physical_actions: move=$ExecutedCount delete=0 rename=0 route=$ExecutedCount cleanup=0 execute_helpers=0 commit=0 push=0"
