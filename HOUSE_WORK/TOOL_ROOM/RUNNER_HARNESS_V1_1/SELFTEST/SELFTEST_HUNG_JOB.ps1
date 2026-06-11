param([string]$RunId, [string]$RunDir)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

[pscustomobject]@{
  Status = "STARTED"
  RunId = $RunId
  StartedUtc = (Get-Date).ToUniversalTime().ToString("o")
  ChildPid = $PID
  RequiresKeyboardInput = $false
  TestKind = "EXPECTED_HUNG"
} | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $RunDir "CHILD_STARTED_$RunId.json")

Start-Sleep -Seconds 60
exit 0
