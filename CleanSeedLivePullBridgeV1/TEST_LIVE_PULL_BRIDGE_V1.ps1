$ErrorActionPreference = 'Stop'
$Build = Split-Path -Parent $MyInvocation.MyCommand.Path
$Start = Join-Path $Build 'START_LIVE_PULL_BRIDGE_V1.ps1'
$Stop = Join-Path $Build 'STOP_LIVE_PULL_BRIDGE_V1.ps1'
& $Start | Out-Host
Start-Sleep -Seconds 1
$base = 'http://127.0.0.1:8791'
$status = Invoke-RestMethod -Uri "$base/status" -Method Get
$manifest = Invoke-RestMethod -Uri "$base/manifest" -Method Get
$delta = Invoke-RestMethod -Uri "$base/delta" -Method Get
$file = Invoke-RestMethod -Uri "$base/file?root=PROJECT&path=CURRENT_TRUTH_INDEX.txt" -Method Get
$checkpoint = Invoke-RestMethod -Uri "$base/checkpoint" -Method Post
$bad = $null
try { $bad = Invoke-RestMethod -Uri "$base/file?root=PROJECT&path=..%2F..%2Fsecret.txt" -Method Get } catch { $bad = 'PATH_TRAVERSAL_BLOCKED_EXPECTED' }
[pscustomobject]@{
  status_server_running = $status.server_running
  status_bind_host = $status.bind_host
  status_port = $status.port
  manifest_file_count = $manifest.file_count
  manifest_folder_count = $manifest.folder_count
  delta_checkpoint_exists = $delta.checkpoint_exists
  file_allowed = $file.allowed
  file_sha256 = $file.sha256
  checkpoint_path = $checkpoint.checkpoint_path
  checkpoint_sha256 = $checkpoint.checkpoint_sha256
  traversal_test = $bad
  project_files_edited = $checkpoint.project_files_edited
  ACTIVE_GUIDES_edited = $checkpoint.ACTIVE_GUIDES_edited
  CURRENT_TRUTH_INDEX_edited = $checkpoint.CURRENT_TRUTH_INDEX_edited
} | ConvertTo-Json -Depth 4
