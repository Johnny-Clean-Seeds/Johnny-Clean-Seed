param(
  [string]$RootPath = "C:\Users\13527\Desktop\123",
  [string]$Base = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606",
  [string]$ApprovalPacketPath = "",
  [string]$ApprovalReceiptPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

function Fail-Closed {
  param([string]$Message)
  throw "STOP: $Message"
}

function Get-HashStrict {
  param([string]$PathText)
  if ([string]::IsNullOrWhiteSpace($PathText)) { Fail-Closed "blank path passed to hash function." }
  if (-not (Test-Path -LiteralPath $PathText)) { Fail-Closed "missing file: $PathText" }
  return (Get-FileHash -LiteralPath $PathText -Algorithm SHA256).Hash
}

function Resolve-LatestFile {
  param(
    [string]$Folder,
    [string]$Pattern,
    [string]$Label
  )
  $Matches = @(Get-ChildItem -LiteralPath $Folder -Filter $Pattern -File -Force | Sort-Object LastWriteTimeUtc -Descending)
  if ($Matches.Count -lt 1) { Fail-Closed "could not find $Label with pattern $Pattern in $Folder" }
  return [string]$Matches[0].FullName
}

function Read-TextStrict {
  param([string]$PathText)
  if (-not (Test-Path -LiteralPath $PathText)) { Fail-Closed "missing text file: $PathText" }
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
  if (-not (Test-Path -LiteralPath $PathText)) { Fail-Closed "missing csv file: $PathText" }
  $Item = Get-Item -LiteralPath $PathText
  if ($Item.Length -eq 0) { return @() }
  return @(Import-Csv -LiteralPath $PathText)
}

function Test-Truthy {
  param([object]$Value)
  if ($null -eq $Value) { return $false }
  $Text = ([string]$Value).Trim()
  return @("TRUE","YES","1") -contains $Text.ToUpperInvariant()
}

function Test-Falsy {
  param([object]$Value)
  if ($null -eq $Value) { return $false }
  $Text = ([string]$Value).Trim()
  return @("FALSE","NO","0","") -contains $Text.ToUpperInvariant()
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
    Fail-Closed "output path outside helper preflight work area: $FullPath"
  }
}

if (-not (Test-Path -LiteralPath $RootPath)) { Fail-Closed "root path missing: $RootPath" }
if (-not (Test-Path -LiteralPath $Base)) { Fail-Closed "base path missing: $Base" }

if ([string]::IsNullOrWhiteSpace($ApprovalReceiptPath)) {
  $ApprovalReceiptPath = Resolve-LatestFile -Folder $Base -Pattern "HASH_RECEIPT__ROUTE_55_CANDIDATES_APPROVAL_PACKET_NO_EXECUTION_*.txt" -Label "Route 55 approval receipt"
}
if ([string]::IsNullOrWhiteSpace($ApprovalPacketPath)) {
  $ApprovalPacketPath = Resolve-LatestFile -Folder $Base -Pattern "APPROVAL_PACKET__ROUTE_55_CANDIDATES_NO_EXECUTION_*.md" -Label "Route 55 approval packet"
}

$ApprovalReceiptText = Read-TextStrict -PathText $ApprovalReceiptPath
$ApprovalPacketText = Read-TextStrict -PathText $ApprovalPacketPath

$ExpectedApprovalPacketHash = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "approval_packet_sha256"
$ActualApprovalPacketHash = Get-HashStrict -PathText $ApprovalPacketPath
if (-not [string]::IsNullOrWhiteSpace($ExpectedApprovalPacketHash)) {
  if ($ActualApprovalPacketHash -ne $ExpectedApprovalPacketHash) {
    Fail-Closed "approval packet hash mismatch. Expected $ExpectedApprovalPacketHash found $ActualApprovalPacketHash"
  }
}

if ($ApprovalPacketText -notmatch "USER_DECISION_REQUIRED_ROUTE_55_CANDIDATES_OR_HOLD") {
  Fail-Closed "approval packet does not preserve official gate USER_DECISION_REQUIRED_ROUTE_55_CANDIDATES_OR_HOLD."
}
if ($ApprovalPacketText -notmatch "APPROVE_BUILD_ROUTE_EXECUTOR_FOR_55_CANDIDATES_ONLY") {
  Fail-Closed "approval packet does not contain approved build-only decision option."
}
if ($ApprovalPacketText -notmatch "DO_NOT_ROUTE_HOLD_POSITION") {
  Fail-Closed "approval packet does not contain hold decision option."
}

$RouteCandidatesCsvPath = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "route_candidates_csv_path"
$HoldOrLeaveCsvPath = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "hold_or_leave_csv_path"
$NewDeltaCsvPath = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "new_delta_csv_path"
$CollisionCsvPath = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "collision_csv_path"
$ParentMissingCsvPath = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "parent_missing_csv_path"

if ([string]::IsNullOrWhiteSpace($RouteCandidatesCsvPath)) {
  $RouteCandidatesCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_ROUTE_CANDIDATES*.csv" -Label "Route 55 route candidates CSV"
}
if ([string]::IsNullOrWhiteSpace($HoldOrLeaveCsvPath)) {
  $HoldOrLeaveCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_HOLD_OR_LEAVE_ROWS*.csv" -Label "Route 55 hold-or-leave CSV"
}
if ([string]::IsNullOrWhiteSpace($NewDeltaCsvPath)) {
  $NewDeltaCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_NEW_DELTA_ROWS*.csv" -Label "Route 55 new delta CSV"
}
if ([string]::IsNullOrWhiteSpace($CollisionCsvPath)) {
  $CollisionCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_DESTINATION_COLLISIONS*.csv" -Label "Route 55 collision CSV"
}
if ([string]::IsNullOrWhiteSpace($ParentMissingCsvPath)) {
  $ParentMissingCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_DESTINATION_PARENT_MISSING*.csv" -Label "Route 55 parent missing CSV"
}

$PlanRowsCsvPath = Resolve-LatestFile -Folder $Base -Pattern "POST_DELTA_RECONSIDERATION_V0_2_58_PLAN_ROWS*.csv" -Label "V0.2 58 plan rows CSV"

$ExpectedRouteCandidatesHash = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "route_candidates_csv_sha256"
$ExpectedHoldOrLeaveHash = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "hold_or_leave_csv_sha256"
$ExpectedNewDeltaHash = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "new_delta_csv_sha256"
$ExpectedCollisionHash = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "collision_csv_sha256"
$ExpectedParentMissingHash = Get-ReceiptValue -ReceiptText $ApprovalReceiptText -Key "parent_missing_csv_sha256"

$ActualRouteCandidatesHash = Get-HashStrict -PathText $RouteCandidatesCsvPath
$ActualHoldOrLeaveHash = Get-HashStrict -PathText $HoldOrLeaveCsvPath
$ActualNewDeltaHash = Get-HashStrict -PathText $NewDeltaCsvPath
$ActualCollisionHash = Get-HashStrict -PathText $CollisionCsvPath
$ActualParentMissingHash = Get-HashStrict -PathText $ParentMissingCsvPath
$ActualPlanRowsHash = Get-HashStrict -PathText $PlanRowsCsvPath

if (-not [string]::IsNullOrWhiteSpace($ExpectedRouteCandidatesHash) -and $ActualRouteCandidatesHash -ne $ExpectedRouteCandidatesHash) { Fail-Closed "route candidates CSV hash mismatch." }
if (-not [string]::IsNullOrWhiteSpace($ExpectedHoldOrLeaveHash) -and $ActualHoldOrLeaveHash -ne $ExpectedHoldOrLeaveHash) { Fail-Closed "hold-or-leave CSV hash mismatch." }
if (-not [string]::IsNullOrWhiteSpace($ExpectedNewDeltaHash) -and $ActualNewDeltaHash -ne $ExpectedNewDeltaHash) { Fail-Closed "new delta CSV hash mismatch." }
if (-not [string]::IsNullOrWhiteSpace($ExpectedCollisionHash) -and $ActualCollisionHash -ne $ExpectedCollisionHash) { Fail-Closed "collision CSV hash mismatch." }
if (-not [string]::IsNullOrWhiteSpace($ExpectedParentMissingHash) -and $ActualParentMissingHash -ne $ExpectedParentMissingHash) { Fail-Closed "parent missing CSV hash mismatch." }

$RouteRows = @(Import-CsvSafe -PathText $RouteCandidatesCsvPath)
$HoldRows = @(Import-CsvSafe -PathText $HoldOrLeaveCsvPath)
$NewDeltaRows = @(Import-CsvSafe -PathText $NewDeltaCsvPath)
$CollisionRows = @(Import-CsvSafe -PathText $CollisionCsvPath)
$ParentMissingRows = @(Import-CsvSafe -PathText $ParentMissingCsvPath)
$PlanRows = @(Import-CsvSafe -PathText $PlanRowsCsvPath)

if ($RouteRows.Count -ne 55) { Fail-Closed "expected 55 route candidates, found $($RouteRows.Count)." }
if ($HoldRows.Count -ne 3) { Fail-Closed "expected 3 hold-or-leave rows, found $($HoldRows.Count)." }
if ($NewDeltaRows.Count -ne 0) { Fail-Closed "expected 0 new delta rows, found $($NewDeltaRows.Count)." }
if ($CollisionRows.Count -ne 0) { Fail-Closed "expected 0 collision rows, found $($CollisionRows.Count)." }
if ($ParentMissingRows.Count -ne 0) { Fail-Closed "expected 0 parent-missing rows, found $($ParentMissingRows.Count)." }
if ($PlanRows.Count -ne 58) { Fail-Closed "expected 58 plan rows, found $($PlanRows.Count)." }

$PlanByName = @{}
foreach ($PlanRow in $PlanRows) {
  $Name = Get-Prop -Row $PlanRow -Names @("Name")
  if (-not [string]::IsNullOrWhiteSpace($Name)) { $PlanByName[$Name] = $PlanRow }
}

$ActionRows = New-Object System.Collections.ArrayList
$IssueRows = New-Object System.Collections.ArrayList

foreach ($RouteRow in $RouteRows) {
  $Name = Get-Prop -Row $RouteRow -Names @("Name")
  $SourcePath = Get-Prop -Row $RouteRow -Names @("SourcePath","LivePath")
  $DestinationPath = Get-Prop -Row $RouteRow -Names @("DestinationPath","DerivedDestinationPath")
  $DestinationParent = Get-Prop -Row $RouteRow -Names @("DestinationParent","DerivedDestinationParent")
  $ProposedBucket = Get-Prop -Row $RouteRow -Names @("ProposedBucket")
  $RequiresDryRun = Get-Prop -Row $RouteRow -Names @("RequiresDryRun")
  $RequiresUserApproval = Get-Prop -Row $RouteRow -Names @("RequiresUserApproval")
  $FutureActionOnly = Get-Prop -Row $RouteRow -Names @("FutureActionOnly")
  $ChangedOrMissing = Get-Prop -Row $RouteRow -Names @("ChangedOrMissing")
  $DestinationCollision = Get-Prop -Row $RouteRow -Names @("DestinationCollision")
  $DestinationParentExists = Get-Prop -Row $RouteRow -Names @("DestinationParentExists")
  $DestinationExists = Get-Prop -Row $RouteRow -Names @("DestinationExists")

  $IssueList = New-Object System.Collections.ArrayList

  if ([string]::IsNullOrWhiteSpace($Name)) { [void]$IssueList.Add("blank Name") }
  if ([string]::IsNullOrWhiteSpace($SourcePath)) { [void]$IssueList.Add("blank SourcePath") }
  if ([string]::IsNullOrWhiteSpace($DestinationPath)) { [void]$IssueList.Add("blank DestinationPath") }
  if ([string]::IsNullOrWhiteSpace($DestinationParent)) { [void]$IssueList.Add("blank DestinationParent") }
  if (-not (Test-Truthy -Value $RequiresDryRun)) { [void]$IssueList.Add("RequiresDryRun is not YES/TRUE") }
  if (-not (Test-Truthy -Value $RequiresUserApproval)) { [void]$IssueList.Add("RequiresUserApproval is not YES/TRUE") }
  if ($FutureActionOnly -ne "FUTURE_ROUTE_AFTER_USER_APPROVAL_AND_DRY_RUN_ONLY") { [void]$IssueList.Add("FutureActionOnly not route-after-approval-only") }
  if (-not (Test-Falsy -Value $ChangedOrMissing)) { [void]$IssueList.Add("ChangedOrMissing is not false") }
  if (-not (Test-Falsy -Value $DestinationCollision)) { [void]$IssueList.Add("DestinationCollision is not false") }
  if (-not (Test-Truthy -Value $DestinationParentExists)) { [void]$IssueList.Add("DestinationParentExists is not true") }
  if (-not (Test-Falsy -Value $DestinationExists)) { [void]$IssueList.Add("DestinationExists is not false") }

  if (-not [string]::IsNullOrWhiteSpace($SourcePath) -and -not (Test-Path -LiteralPath $SourcePath)) { [void]$IssueList.Add("source missing now") }
  if (-not [string]::IsNullOrWhiteSpace($DestinationParent) -and -not (Test-Path -LiteralPath $DestinationParent)) { [void]$IssueList.Add("destination parent missing now") }
  if (-not [string]::IsNullOrWhiteSpace($DestinationPath) -and (Test-Path -LiteralPath $DestinationPath)) { [void]$IssueList.Add("destination exists now") }

  $ExpectedHash = ""
  $ExpectedSize = ""
  if ($PlanByName.ContainsKey($Name)) {
    $PlanRow = $PlanByName[$Name]
    $ExpectedHash = Get-Prop -Row $PlanRow -Names @("LiveSHA256","ExpectedSHA256","SHA256")
    $ExpectedSize = Get-Prop -Row $PlanRow -Names @("LiveSizeBytes","ExpectedSizeBytes","SizeBytes")
  } else {
    [void]$IssueList.Add("missing matching plan row for hash/size proof")
  }

  $ActualHash = ""
  $ActualSize = ""
  if (-not [string]::IsNullOrWhiteSpace($SourcePath) -and (Test-Path -LiteralPath $SourcePath)) {
    $ActualHash = Get-HashStrict -PathText $SourcePath
    $ActualSize = [string](Get-Item -LiteralPath $SourcePath).Length
  }

  if ([string]::IsNullOrWhiteSpace($ExpectedHash)) {
    [void]$IssueList.Add("blank expected hash")
  } elseif (-not [string]::IsNullOrWhiteSpace($ActualHash) -and -not $ActualHash.Equals($ExpectedHash, [System.StringComparison]::OrdinalIgnoreCase)) {
    [void]$IssueList.Add("source hash mismatch")
  }

  if ([string]::IsNullOrWhiteSpace($ExpectedSize)) {
    [void]$IssueList.Add("blank expected size")
  } elseif (-not [string]::IsNullOrWhiteSpace($ActualSize) -and $ActualSize -ne $ExpectedSize) {
    [void]$IssueList.Add("source size mismatch")
  }

  if ($IssueList.Count -gt 0) {
    [void]$IssueRows.Add([pscustomobject]@{
      Name = $Name
      SourcePath = $SourcePath
      DestinationPath = $DestinationPath
      Issues = ($IssueList -join "; ")
    })
  }

  [void]$ActionRows.Add([pscustomobject]@{
    RouteID = ("ROUTE55-{0:D3}" -f ($ActionRows.Count + 1))
    Name = $Name
    SourcePath = $SourcePath
    DestinationPath = $DestinationPath
    DestinationParent = $DestinationParent
    ProposedBucket = $ProposedBucket
    ExpectedSHA256 = $ExpectedHash
    CurrentSHA256 = $ActualHash
    ExpectedSizeBytes = $ExpectedSize
    CurrentSizeBytes = $ActualSize
    Action = "MOVE_FILE_ONLY_AFTER_EXPLICIT_APPROVAL"
    ApprovedForBuild = "YES"
    ApprovedForRun = "NO"
    DeleteAllowed = "NO"
    RenameAllowed = "NO"
    OverwriteAllowed = "NO"
    CommitAllowed = "NO"
    PushAllowed = "NO"
  })
}

if ($IssueRows.Count -ne 0) {
  $IssuePath = Join-Path $Base "ROUTE_55_EXECUTOR_PACKAGE_BUILD_BLOCKERS_V0_1_$RunStamp.csv"
  Assert-InBase -PathText $IssuePath
  $IssueRows | Export-Csv -LiteralPath $IssuePath -NoTypeInformation -Encoding UTF8
  $IssueHash = Get-HashStrict -PathText $IssuePath
  Fail-Closed "route 55 executor package blocked by $($IssueRows.Count) action-table issue(s). blocker_csv=$IssuePath blocker_sha256=$IssueHash"
}

$ActionTablePath = Join-Path $Base "ROUTE_55_EXECUTOR_ACTION_TABLE_APPROVED_FOR_BUILD_NOT_RUN_V0_1_$RunStamp.csv"
$ExecutorPath = Join-Path $Base "ROUTE_55_EXECUTOR_APPROVED_ONLY_DO_NOT_RUN_UNLESS_APPROVED_V0_1_$RunStamp.ps1"
$StaticReviewPath = Join-Path $Base "STATIC_REVIEW__ROUTE_55_EXECUTOR_APPROVED_ONLY_NO_RUN_V0_1_$RunStamp.md"
$ReportPath = Join-Path $Base "ROUTE_55_EXECUTOR_PACKAGE_BUILD_REPORT_NO_RUN_V0_1_$RunStamp.md"
$ReceiptPath = Join-Path $Base "HASH_RECEIPT__ROUTE_55_EXECUTOR_PACKAGE_BUILD_NO_RUN_V0_1_$RunStamp.txt"

foreach ($OutPath in @($ActionTablePath,$ExecutorPath,$StaticReviewPath,$ReportPath,$ReceiptPath)) {
  Assert-InBase -PathText $OutPath
  if (Test-Path -LiteralPath $OutPath) { Fail-Closed "output already exists: $OutPath" }
}

$ActionRows | Export-Csv -LiteralPath $ActionTablePath -NoTypeInformation -Encoding UTF8
$ActionTableHash = Get-HashStrict -PathText $ActionTablePath

$ExecutorText = @'
param(
  [string]$ActionTablePath = "__ACTION_TABLE_PATH__",
  [string]$ExpectedActionTableSHA256 = "__ACTION_TABLE_SHA256__",
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
'@

$ExecutorText = $ExecutorText.Replace("__ACTION_TABLE_PATH__", $ActionTablePath.Replace("\","\\"))
$ExecutorText = $ExecutorText.Replace("__ACTION_TABLE_SHA256__", $ActionTableHash)

$ExecutorText | Set-Content -LiteralPath $ExecutorPath -Encoding UTF8
$ExecutorHash = Get-HashStrict -PathText $ExecutorPath

$Tokens = $null
$ParseErrors = $null
$Ast = [System.Management.Automation.Language.Parser]::ParseFile($ExecutorPath, [ref]$Tokens, [ref]$ParseErrors)

$CommandAsts = @(
  $Ast.FindAll({
    param($Node)
    $Node -is [System.Management.Automation.Language.CommandAst]
  }, $true)
)
$CommandNames = @($CommandAsts | ForEach-Object { $_.GetCommandName() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)

$ForbiddenCommandNames = @(
  "Remove-Item",
  "Rename-Item",
  "Start-Process",
  "Invoke-Expression",
  "Invoke-Command",
  "Start-Job",
  "Start-ThreadJob",
  "pwsh",
  "powershell",
  "git"
)

$ForbiddenCommandHits = @($CommandNames | Where-Object { $ForbiddenCommandNames -contains $_ })
$MoveItemCommandHits = @($CommandNames | Where-Object { $_ -eq "Move-Item" })

$ExecutorRawText = Read-TextStrict -PathText $ExecutorPath
$ForbiddenTextTokens = @("Remove-Item","Rename-Item","Start-Process","Invoke-Expression","Invoke-Command","git commit","git push","pwsh","powershell")
$ForbiddenTextHits = @()
foreach ($Token in $ForbiddenTextTokens) {
  if ($ExecutorRawText.IndexOf($Token, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
    $ForbiddenTextHits += $Token
  }
}

$ParseErrorCount = @($ParseErrors).Count
$ForbiddenCommandHitCount = @($ForbiddenCommandHits).Count
$ForbiddenTextHitCount = @($ForbiddenTextHits).Count
$MoveItemCommandHitCount = @($MoveItemCommandHits).Count

$StaticVerdict = "ROUTE_55_EXECUTOR_STATIC_REVIEW_PASS_NOT_RUN"
if ($ParseErrorCount -ne 0) {
  $StaticVerdict = "ROUTE_55_EXECUTOR_STATIC_REVIEW_FAIL_PARSE"
} elseif ($ForbiddenCommandHitCount -ne 0) {
  $StaticVerdict = "ROUTE_55_EXECUTOR_STATIC_REVIEW_FAIL_FORBIDDEN_COMMAND"
} elseif ($ForbiddenTextHitCount -ne 0) {
  $StaticVerdict = "ROUTE_55_EXECUTOR_STATIC_REVIEW_FAIL_FORBIDDEN_TEXT"
} elseif ($MoveItemCommandHitCount -ne 1) {
  $StaticVerdict = "ROUTE_55_EXECUTOR_STATIC_REVIEW_FAIL_MOVE_ITEM_COUNT"
} elseif ($ExecutorRawText -notmatch "APPROVE_RUN_ROUTE_55_EXECUTOR_ONLY") {
  $StaticVerdict = "ROUTE_55_EXECUTOR_STATIC_REVIEW_FAIL_APPROVAL_PHRASE"
} elseif ($ExecutorRawText -notmatch "OverwriteAllowed must be NO") {
  $StaticVerdict = "ROUTE_55_EXECUTOR_STATIC_REVIEW_FAIL_OVERWRITE_GUARD"
}

$StaticReviewText = @"
# STATIC REVIEW: ROUTE 55 EXECUTOR

Status:
STATIC_REVIEW_BUILT / EXECUTOR_NOT_RUN / ROUTE_55_ONLY

Executor script:
$ExecutorPath

Executor script SHA256:
$ExecutorHash

Action table:
$ActionTablePath

Action table SHA256:
$ActionTableHash

Parse error count:
$ParseErrorCount

Forbidden command hit count:
$ForbiddenCommandHitCount

Forbidden text hit count:
$ForbiddenTextHitCount

Move-Item command hit count:
$MoveItemCommandHitCount

Required approval phrase:
APPROVE_RUN_ROUTE_55_EXECUTOR_ONLY

Static verdict:
$StaticVerdict

Boundary:
This static review did not run the executor.
This build did not move, delete, rename, cleanup, execute helpers, commit, or push.

Next single action:
USER_DECISION_REQUIRED_RUN_ROUTE_55_EXECUTOR_OR_HOLD

Physical actions:
move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0
"@

$StaticReviewText | Set-Content -LiteralPath $StaticReviewPath -Encoding UTF8
$StaticReviewHash = Get-HashStrict -PathText $StaticReviewPath

$ReportText = @"
# ROUTE 55 EXECUTOR PACKAGE BUILD REPORT

Status:
EXECUTOR_PACKAGE_BUILT / EXECUTOR_NOT_RUN / ROUTE_55_ONLY / NO_PHYSICAL_ACTION

Official parent gate:
USER_DECISION_REQUIRED_ROUTE_55_CANDIDATES_OR_HOLD

Build decision consumed:
APPROVE_BUILD_ROUTE_EXECUTOR_FOR_55_CANDIDATES_ONLY

Approval packet:
$ApprovalPacketPath

Approval packet SHA256:
$ActualApprovalPacketHash

Approval receipt:
$ApprovalReceiptPath

Route candidates CSV:
$RouteCandidatesCsvPath

Route candidates CSV SHA256:
$ActualRouteCandidatesHash

Hold-or-leave CSV:
$HoldOrLeaveCsvPath

Hold-or-leave row count:
$($HoldRows.Count)

Action table:
$ActionTablePath

Action table SHA256:
$ActionTableHash

Executor script:
$ExecutorPath

Executor script SHA256:
$ExecutorHash

Static review:
$StaticReviewPath

Static review SHA256:
$StaticReviewHash

Counts:
- route_candidate_count: $($RouteRows.Count)
- hold_or_leave_count: $($HoldRows.Count)
- new_delta_count: $($NewDeltaRows.Count)
- collision_count: $($CollisionRows.Count)
- parent_missing_count: $($ParentMissingRows.Count)
- action_table_issue_count: $($IssueRows.Count)

Static verdict:
$StaticVerdict

Hard boundary:
The executor package was built but not run.
The 3 hold-or-leave rows are excluded.
No overwrite is authorized.
No delete is authorized.
No rename is authorized.
No cleanup is authorized.
No helper execution is authorized.
No commit is authorized.
No push is authorized.

Next single action:
USER_DECISION_REQUIRED_RUN_ROUTE_55_EXECUTOR_OR_HOLD

Physical actions:
move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0

Final scoped verdict:
ROUTE_55_EXECUTOR_PACKAGE_BUILT_AND_STATIC_REVIEWED__EXECUTOR_NOT_RUN__NO_PHYSICAL_ACTION_TAKEN
"@

$ReportText | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportHash = Get-HashStrict -PathText $ReportPath

$ReceiptText = @"
report_path: $ReportPath
report_sha256: $ReportHash
action_table_path: $ActionTablePath
action_table_sha256: $ActionTableHash
executor_script_path: $ExecutorPath
executor_script_sha256: $ExecutorHash
static_review_path: $StaticReviewPath
static_review_sha256: $StaticReviewHash
approval_packet_path: $ApprovalPacketPath
approval_packet_sha256: $ActualApprovalPacketHash
route_candidates_csv_path: $RouteCandidatesCsvPath
route_candidates_csv_sha256: $ActualRouteCandidatesHash
hold_or_leave_count: $($HoldRows.Count)
route_candidate_count: $($RouteRows.Count)
new_delta_count: $($NewDeltaRows.Count)
collision_count: $($CollisionRows.Count)
parent_missing_count: $($ParentMissingRows.Count)
static_verdict: $StaticVerdict
executor_run: NO
next_single_action: USER_DECISION_REQUIRED_RUN_ROUTE_55_EXECUTOR_OR_HOLD
physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0
"@

$ReceiptText | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptHash = Get-HashStrict -PathText $ReceiptPath

"=== ROUTE 55 EXECUTOR PACKAGE BUILT — EXECUTOR NOT RUN ==="
"report_path: $ReportPath"
"report_sha256: $ReportHash"
"action_table_path: $ActionTablePath"
"action_table_sha256: $ActionTableHash"
"executor_script_path: $ExecutorPath"
"executor_script_sha256: $ExecutorHash"
"static_review_path: $StaticReviewPath"
"static_review_sha256: $StaticReviewHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"route_candidate_count: $($RouteRows.Count)"
"hold_or_leave_count: $($HoldRows.Count)"
"static_verdict: $StaticVerdict"
"next_single_action: USER_DECISION_REQUIRED_RUN_ROUTE_55_EXECUTOR_OR_HOLD"
"physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0"
