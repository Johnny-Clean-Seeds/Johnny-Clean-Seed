Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Runner = Join-Path $ToolDir "RUN_FILE_FIRST_JOB_V1_1.ps1"
$SelfTestDir = Join-Path $ToolDir "SELFTEST"
$ReportsDir = Join-Path $ToolDir "RUN_REPORTS"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$RunRoot = Join-Path $ReportsDir "SELFTEST_RUN_$Stamp"

New-Item -ItemType Directory -Force -Path $RunRoot | Out-Null

$Cases = @(
  [pscustomobject]@{
    Name = "PASS_DELAYED"
    Script = Join-Path $SelfTestDir "SELFTEST_PASS_DELAYED_JOB.ps1"
    TimeoutSeconds = 15
    ExpectedStatus = "PASS"
  },
  [pscustomobject]@{
    Name = "EXPECTED_FAIL"
    Script = Join-Path $SelfTestDir "SELFTEST_FAIL_JOB.ps1"
    TimeoutSeconds = 15
    ExpectedStatus = "FAIL"
  },
  [pscustomobject]@{
    Name = "EXPECTED_HUNG"
    Script = Join-Path $SelfTestDir "SELFTEST_HUNG_JOB.ps1"
    TimeoutSeconds = 5
    ExpectedStatus = "HUNG"
  }
)

$Rows = foreach ($case in $Cases) {
  $Receipt = & $Runner -JobScript $case.Script -JobName $case.Name -OutputRoot $RunRoot -TimeoutSeconds $case.TimeoutSeconds

  [pscustomobject]@{
    Name = $case.Name
    ExpectedStatus = $case.ExpectedStatus
    ObservedStatus = $Receipt.Status
    Passed = ($Receipt.Status -eq $case.ExpectedStatus)
    RunDir = $Receipt.RunDir
    ParentReceipt = (Join-Path $Receipt.RunDir "PARENT_RECEIPT_$($Receipt.RunId).json")
    RequiresKeyboardInput = $Receipt.RequiresKeyboardInput
    ChildExited = $Receipt.ChildExited
    ChildKilled = $Receipt.ChildKilled
    ChildExitCode = $Receipt.ChildExitCode
    FailureReason = $Receipt.FailureReason
  }
}

$Verdict = if (@($Rows | Where-Object { -not $_.Passed }).Count -eq 0) { "PASS" } else { "FAIL" }

$Summary = [pscustomobject]@{
  Status = $Verdict
  CreatedUtc = (Get-Date).ToUniversalTime().ToString("o")
  ToolDir = $ToolDir
  RunRoot = $RunRoot
  ProofType = "RUNNER_HARNESS_V1_1_PASS_FAIL_HUNG_SELFTEST"
  RequiresKeyboardInput = $false
  Cases = $Rows
}

$SummaryPath = Join-Path $RunRoot "RUNNER_HARNESS_V1_1_SELFTEST_SUMMARY_$Stamp.json"
$LatestPath = Join-Path $ReportsDir "RUNNER_HARNESS_V1_1_SELFTEST_LATEST.json"

$Summary | ConvertTo-Json -Depth 14 | Set-Content -Encoding UTF8 -LiteralPath $SummaryPath
Copy-Item -LiteralPath $SummaryPath -Destination $LatestPath -Force

$Summary
