param([string]$RunId, [string]$RunDir)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$StartedUtc = (Get-Date).ToUniversalTime().ToString("o")

[pscustomobject]@{
  Status = "STARTED"
  RunId = $RunId
  StartedUtc = $StartedUtc
  ChildPid = $PID
  RequiresKeyboardInput = $false
  TestKind = "PASS_DELAYED"
} | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $RunDir "CHILD_STARTED_$RunId.json")

Start-Sleep -Seconds 3

[pscustomobject]@{
  Status = "COMPLETE"
  RunId = $RunId
  StartedUtc = $StartedUtc
  FinishedUtc = (Get-Date).ToUniversalTime().ToString("o")
  ChildPid = $PID
  RequiresKeyboardInput = $false
  ProofType = "SELFTEST_DELAYED_PASS"
} | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $RunDir "CHILD_COMPLETE_$RunId.json")

exit 0
