$ErrorActionPreference = 'Stop'
$Build = Split-Path -Parent $MyInvocation.MyCommand.Path
$Python = (Get-Command python -ErrorAction Stop).Source
$Script = Join-Path $Build 'cleanseed_live_pull_bridge_v1.py'
$Log = Join-Path $Build 'bridge_v1.log'
$PidPath = Join-Path $Build 'bridge_v1.pid'
if (Test-Path -LiteralPath $PidPath) {
  $existing = Get-Content -LiteralPath $PidPath -ErrorAction SilentlyContinue
  if ($existing -and (Get-Process -Id ([int]$existing) -ErrorAction SilentlyContinue)) {
    Write-Output "ALREADY_RUNNING PID=$existing"
    exit 0
  }
}
$p = Start-Process -FilePath $Python -ArgumentList @($Script, '--host', '127.0.0.1', '--port', '8791') -WorkingDirectory $Build -PassThru -WindowStyle Hidden -RedirectStandardOutput $Log -RedirectStandardError (Join-Path $Build 'bridge_v1.err.log')
Start-Sleep -Milliseconds 800
Write-Output "STARTED PID=$($p.Id) URL=http://127.0.0.1:8791"
