$ErrorActionPreference = 'Stop'
$Build = Split-Path -Parent $MyInvocation.MyCommand.Path
$PidPath = Join-Path $Build 'bridge_v1.pid'
if (!(Test-Path -LiteralPath $PidPath)) {
  Write-Output 'NOT_RUNNING'
  exit 0
}
$pidValue = Get-Content -LiteralPath $PidPath
$proc = Get-Process -Id ([int]$pidValue) -ErrorAction SilentlyContinue
if ($proc) {
  Stop-Process -Id $proc.Id -Force
  Start-Sleep -Milliseconds 300
  Write-Output "STOPPED PID=$pidValue"
} else {
  Write-Output "PID_NOT_RUNNING PID=$pidValue"
}
Remove-Item -LiteralPath $PidPath -Force -ErrorAction SilentlyContinue
