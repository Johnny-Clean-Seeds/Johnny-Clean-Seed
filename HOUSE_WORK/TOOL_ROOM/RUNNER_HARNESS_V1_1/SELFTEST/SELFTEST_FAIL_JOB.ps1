param([string]$RunId, [string]$RunDir)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

[pscustomobject]@{
  Status = "STARTED"
  RunId = $RunId
  StartedUtc = (Get-Date).ToUniversalTime().ToString("o")
  ChildPid = $PID
  RequiresKeyboardInput = $false
  TestKind = "EXPECTED_FAIL"
} | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $RunDir "CHILD_STARTED_$RunId.json")

[pscustomobject]@{
  Status = "FAILED"
  RunId = $RunId
  FinishedUtc = (Get-Date).ToUniversalTime().ToString("o")
  ChildPid = $PID
  RequiresKeyboardInput = $false
  Error = "EXPECTED_SELFTEST_FAILURE"
} | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $RunDir "CHILD_FAILED_$RunId.json")

exit 23
