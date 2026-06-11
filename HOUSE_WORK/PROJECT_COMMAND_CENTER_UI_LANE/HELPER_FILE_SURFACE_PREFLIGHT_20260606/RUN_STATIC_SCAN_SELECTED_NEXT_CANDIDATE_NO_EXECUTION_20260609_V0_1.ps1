$ErrorActionPreference = "Stop"

$Base = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$CandidatePath = Join-Path $Base "BUILD_POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_NO_EXECUTION_20260609_V0_1.ps1"
$StaticGateCsv = Join-Path $Base "STATIC_GATE__GENERATED_HELPER_REPAIR_COLLECTION_PARAMETER_BINDING_NO_EXECUTION_20260609.csv"
$SelectorCsv = Join-Path $Base "SELECTOR__GENERATED_HELPER_CANDIDATES_FOR_STATIC_GATE_NO_EXECUTION_20260609.csv"

$ScanCsv = Join-Path $Base "STATIC_SCAN__POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_NO_EXECUTION_20260609.csv"
$ScanReport = Join-Path $Base "STATIC_SCAN__POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_NO_EXECUTION_20260609.md"
$ReceiptPath = Join-Path $Base "HASH_RECEIPT__POST_DELTA_REVIEW_ROUTE_RECONSIDERATION_SELECTOR_STATIC_SCAN_NO_EXECUTION_20260609.txt"

$CandidateName = Split-Path $CandidatePath -Leaf
$CandidateHash = (Get-FileHash -LiteralPath $CandidatePath -Algorithm SHA256).Hash
$StaticGateHash = (Get-FileHash -LiteralPath $StaticGateCsv -Algorithm SHA256).Hash
$SelectorHash = (Get-FileHash -LiteralPath $SelectorCsv -Algorithm SHA256).Hash

$Gates = @(Import-Csv -LiteralPath $StaticGateCsv)
$Raw = Get-Content -LiteralPath $CandidatePath -Raw

$Tokens = $null
$ParseErrors = $null
[System.Management.Automation.Language.Parser]::ParseFile($CandidatePath, [ref]$Tokens, [ref]$ParseErrors) | Out-Null
$ParseErrorCount = @($ParseErrors).Count

$ScanRows = @()

foreach ($Gate in $Gates) {
  $GateId = [string]$Gate.GateId
  $GateName = [string]$Gate.GateName
  $FixtureId = [string]$Gate.FixtureId

  $StaticVerdict = "STATIC_GATE_BLOCKED_REPAIR_REQUIRED"
  $Evidence = "No passing evidence found."

  if ($GateId -eq "CPB-SG-001") {
    $HasArrayNorm = [bool]($Raw -match '@\(')
    $HasArrayCount = [bool]($Raw -match '@\([^\)]*\)\.Count')
    if ($HasArrayNorm -eq $true) {
      if ($HasArrayCount -eq $true) {
        $StaticVerdict = "STATIC_GATE_PASS"
        $Evidence = "Found array normalization and array-count pattern."
      }
    }
    if ($StaticVerdict -ne "STATIC_GATE_PASS") {
      $Evidence = "Missing clear @(...).Count evidence for maybe-empty collection count."
    }
  }

  if ($GateId -eq "CPB-SG-002") {
    $HasForeachArray = [bool]($Raw -match 'foreach\s*\([^\)]*\s+in\s+@\(')
    if ($HasForeachArray -eq $true) {
      $StaticVerdict = "STATIC_GATE_PASS"
      $Evidence = "Found foreach over explicit array-wrapped source."
    }
    if ($HasForeachArray -eq $false) {
      $Evidence = "No clear foreach (... in @(...)) evidence."
    }
  }

  if ($GateId -eq "CPB-SG-003") {
    $HasSafeRows = [bool]($Raw -match '\$SafeRows\s*=\s*@\(')
    $HasGroupObject = [bool]($Raw -match 'Group-Object')
    if ($HasGroupObject -eq $false) {
      $StaticVerdict = "STATIC_GATE_PASS_NOT_APPLICABLE"
      $Evidence = "No Group-Object usage found."
    }
    if ($HasGroupObject -eq $true) {
      if ($HasSafeRows -eq $true) {
        $StaticVerdict = "STATIC_GATE_PASS"
        $Evidence = "Found SafeRows array-normalized source before Group-Object."
      }
    }
    if ($HasGroupObject -eq $true) {
      if ($HasSafeRows -eq $false) {
        $Evidence = "Group-Object appears without clear SafeRows array-normalized source."
      }
    }
  }

  if ($GateId -eq "CPB-SG-004") {
    $HasHereString = [bool]($Raw -match '@"')
    $HasSetContent = [bool]($Raw -match 'Set-Content\s+-LiteralPath')
    $HasAllowEmpty = [bool]($Raw -match 'AllowEmptyString')
    if ($HasHereString -eq $true) {
      if ($HasSetContent -eq $true) {
        $StaticVerdict = "STATIC_GATE_PASS"
        $Evidence = "Found here-string plus Set-Content evidence."
      }
    }
    if ($HasAllowEmpty -eq $true) {
      $StaticVerdict = "STATIC_GATE_PASS"
      $Evidence = "Found AllowEmptyString writer evidence."
    }
    if ($StaticVerdict -ne "STATIC_GATE_PASS") {
      $Evidence = "No clear blank-safe writer evidence."
    }
  }

  if ($GateId -eq "CPB-SG-005") {
    $HasNullAppend = [bool]($Raw -match '\+=\s*\$null')
    $HasStringCastLineHandling = [bool]($Raw -match '\[string\]\$_')
    if ($HasNullAppend -eq $false) {
      if ($HasStringCastLineHandling -eq $true) {
        $StaticVerdict = "STATIC_GATE_PASS"
        $Evidence = "Found string-cast line handling and no direct null append."
      }
    }
    if ($HasNullAppend -eq $false) {
      if ($HasStringCastLineHandling -eq $false) {
        $StaticVerdict = "STATIC_GATE_REVIEW_REQUIRED"
        $Evidence = "No direct null append found, but no clear string-cast line-list control either."
      }
    }
    if ($HasNullAppend -eq $true) {
      $Evidence = "Potential null line-list append found."
    }
  }

  if ($GateId -eq "CPB-SG-006") {
    $HasPscustomobject = [bool]($Raw -match '\[pscustomobject\]')
    $HasExportCsv = [bool]($Raw -match 'Export-Csv')
    if ($HasExportCsv -eq $false) {
      $StaticVerdict = "STATIC_GATE_PASS_NOT_APPLICABLE"
      $Evidence = "No Export-Csv usage found."
    }
    if ($HasExportCsv -eq $true) {
      if ($HasPscustomobject -eq $true) {
        $StaticVerdict = "STATIC_GATE_PASS"
        $Evidence = "Found pscustomobject rows and Export-Csv."
      }
    }
    if ($HasExportCsv -eq $true) {
      if ($HasPscustomobject -eq $false) {
        $Evidence = "Export-Csv found without clear pscustomobject row schema."
      }
    }
  }

  if ($GateId -eq "CPB-SG-007") {
    $ArrayCount = [bool]($Raw -match '@\([^\)]*\)\.Count')
    $DirectCountRisk = [bool]($Raw -match '\$[A-Za-z0-9_]+\s*\.Count')
    if ($ArrayCount -eq $true) {
      if ($DirectCountRisk -eq $false) {
        $StaticVerdict = "STATIC_GATE_PASS"
        $Evidence = "Array-count pattern found and no simple direct .Count risk detected."
      }
    }
    if ($ArrayCount -eq $true) {
      if ($DirectCountRisk -eq $true) {
        $StaticVerdict = "STATIC_GATE_REVIEW_REQUIRED"
        $Evidence = "Array-count pattern found, but direct .Count also appears and needs review."
      }
    }
    if ($ArrayCount -eq $false) {
      $Evidence = "No clear @(...).Count pattern found."
    }
  }

  if ($GateId -eq "CPB-SG-008") {
    $HasArrayParam = [bool]($Raw -match '\[[A-Za-z]+\[\]\]')
    $HasArrayCall = [bool]($Raw -match '@\(')
    if ($HasArrayParam -eq $true) {
      if ($HasArrayCall -eq $true) {
        $StaticVerdict = "STATIC_GATE_PASS"
        $Evidence = "Found explicit array parameter and array-wrapped source evidence."
      }
    }
    if ($StaticVerdict -ne "STATIC_GATE_PASS") {
      $StaticVerdict = "STATIC_GATE_REVIEW_REQUIRED"
      $Evidence = "No clear explicit array parameter plus @(...)."
    }
  }

  if ($GateId -eq "CPB-SG-009") {
    $HasIssueCount = [bool]($Raw -match 'IssueCount|BlockerCount|blocker_count|issue_count')
    $HasReviewVerdict = [bool]($Raw -match 'REVIEW_REQUIRED|BLOCKED|BLOCKER|BLOCKED_REPAIR_REQUIRED')
    if ($HasIssueCount -eq $true) {
      if ($HasReviewVerdict -eq $true) {
        $StaticVerdict = "STATIC_GATE_PASS"
        $Evidence = "Found issue/blocker count and blocked/review verdict vocabulary."
      }
    }
    if ($StaticVerdict -ne "STATIC_GATE_PASS") {
      $Evidence = "No clear blocker/issue-count verdict dominance evidence."
    }
  }

  if ($GateId -eq "CPB-SG-010") {
    $HasHashReceipt = [bool]($Raw -match 'Get-FileHash|SHA256|receipt')
    $HasDiffOrDuplicate = [bool]($Raw -match 'duplicate|diff|missing|extra|selected|unique')
    $HasGateLanguage = [bool]($Raw -match 'static|dry-run|dry_run|DoesNotProve|NO_EXECUTION')
    if ($HasHashReceipt -eq $true) {
      if ($HasDiffOrDuplicate -eq $true) {
        if ($HasGateLanguage -eq $true) {
          $StaticVerdict = "STATIC_GATE_PASS"
          $Evidence = "Found hash/receipt, diff-or-duplicate evidence, and gate/boundary language."
        }
      }
    }
    if ($StaticVerdict -ne "STATIC_GATE_PASS") {
      $Evidence = "Missing one or more generated-rollup authority proof signals."
    }
  }

  if ($ParseErrorCount -gt 0) {
    $StaticVerdict = "STATIC_GATE_BLOCKED_REPAIR_REQUIRED"
    $Evidence = "Candidate has PowerShell parser errors; static gate blocked before gate-specific acceptance."
  }

  $ScanRows += [pscustomobject]@{
    GateId = $GateId
    FixtureId = $FixtureId
    GateName = $GateName
    CandidateName = $CandidateName
    CandidatePath = $CandidatePath
    CandidateSHA256 = $CandidateHash
    StaticVerdict = $StaticVerdict
    Evidence = $Evidence
  }
}

$ScanRows | Export-Csv -LiteralPath $ScanCsv -NoTypeInformation -Encoding UTF8

$TotalGateCount = $ScanRows.Count
$PassCount = @($ScanRows | Where-Object { $_.StaticVerdict -eq "STATIC_GATE_PASS" -or $_.StaticVerdict -eq "STATIC_GATE_PASS_NOT_APPLICABLE" }).Count
$ReviewCount = @($ScanRows | Where-Object { $_.StaticVerdict -eq "STATIC_GATE_REVIEW_REQUIRED" }).Count
$BlockedCount = @($ScanRows | Where-Object { $_.StaticVerdict -eq "STATIC_GATE_BLOCKED_REPAIR_REQUIRED" }).Count

$FinalVerdict = "STATIC_GATE_SCAN_REVIEW_REQUIRED_NO_EXECUTION"

if ($BlockedCount -gt 0) {
  $FinalVerdict = "STATIC_GATE_SCAN_BLOCKED_REPAIR_REQUIRED_NO_EXECUTION"
}

$CanPass = $false
if ($BlockedCount -eq 0) {
  if ($ReviewCount -eq 0) {
    if ($TotalGateCount -eq 10) {
      $CanPass = $true
    }
  }
}

if ($CanPass -eq $true) {
  $FinalVerdict = "STATIC_GATE_SCAN_PASS_NO_EXECUTION"
}

$ScanBlock = ($ScanRows |
  Select-Object GateId, StaticVerdict, Evidence |
  Format-Table -AutoSize -Wrap |
  Out-String
)

$ParseErrorBlock = "none"
if ($ParseErrorCount -gt 0) {
  $ParseErrorBlock = (@($ParseErrors) | ForEach-Object { "Line=$($_.Extent.StartLineNumber) Column=$($_.Extent.StartColumnNumber) Message=$($_.Message)" }) -join " | "
}

$Text = @"
# STATIC SCAN: POST DELTA REVIEW ROUTE RECONSIDERATION SELECTOR

Status:
$FinalVerdict / NO_EXECUTION / NO_SCRIPT_REPAIR / NO_PHYSICAL_ACTION

Candidate:
$CandidateName

Candidate path:
$CandidatePath

Candidate SHA256:
$CandidateHash

Candidate parser error count:
$ParseErrorCount

Candidate parser errors:
$ParseErrorBlock

Source static gate CSV:
$StaticGateCsv

Source static gate CSV SHA256:
$StaticGateHash

Source selector CSV:
$SelectorCsv

Source selector CSV SHA256:
$SelectorHash

Counts:
- total_gate_count: $TotalGateCount
- pass_or_not_applicable_count: $PassCount
- review_required_count: $ReviewCount
- blocked_repair_required_count: $BlockedCount

Gate scan rows:
$ScanBlock

Control meaning:
This is a static text scan only.
The candidate was not executed.
If blocked_repair_required_count is greater than zero, the candidate remains blocked.

DoesNotProve:
This scan does not execute the candidate helper.
This scan does not repair the candidate helper.
This scan does not authorize route, cleanup, delete, rename, move, commit, push, source rewrite, doctrine promotion, or helper execution.
This scan does not prove runtime safety.

Next single action:
DECIDE_REPAIR_THIS_CANDIDATE_OR_SCAN_NEXT_GENERATED_HELPER_NO_EXECUTION

Final verdict:
$FinalVerdict
"@

$Text | Set-Content -LiteralPath $ScanReport -Encoding UTF8

$ScanCsvHash = (Get-FileHash -LiteralPath $ScanCsv -Algorithm SHA256).Hash
$ScanReportHash = (Get-FileHash -LiteralPath $ScanReport -Algorithm SHA256).Hash

$ReceiptText = @"
scan_report_path: $ScanReport
scan_report_sha256: $ScanReportHash
scan_csv_path: $ScanCsv
scan_csv_sha256: $ScanCsvHash
candidate_name: $CandidateName
candidate_path: $CandidatePath
candidate_sha256: $CandidateHash
candidate_parser_error_count: $ParseErrorCount
source_static_gate_csv_sha256: $StaticGateHash
source_selector_csv_sha256: $SelectorHash
total_gate_count: $TotalGateCount
pass_or_not_applicable_count: $PassCount
review_required_count: $ReviewCount
blocked_repair_required_count: $BlockedCount
final_verdict: $FinalVerdict
next_single_action: DECIDE_REPAIR_THIS_CANDIDATE_OR_SCAN_NEXT_GENERATED_HELPER_NO_EXECUTION
physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0
"@

$ReceiptText | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

"=== POST DELTA REVIEW ROUTE RECONSIDERATION STATIC SCAN WRITTEN ==="
"scan_report_path: $ScanReport"
"scan_report_sha256: $ScanReportHash"
"scan_csv_path: $ScanCsv"
"scan_csv_sha256: $ScanCsvHash"
"receipt_path: $ReceiptPath"
"receipt_sha256: $ReceiptHash"
"candidate_name: $CandidateName"
"candidate_sha256: $CandidateHash"
"candidate_parser_error_count: $ParseErrorCount"
"total_gate_count: $TotalGateCount"
"pass_or_not_applicable_count: $PassCount"
"review_required_count: $ReviewCount"
"blocked_repair_required_count: $BlockedCount"
"final_verdict: $FinalVerdict"
"next_single_action: DECIDE_REPAIR_THIS_CANDIDATE_OR_SCAN_NEXT_GENERATED_HELPER_NO_EXECUTION"
"physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0"
