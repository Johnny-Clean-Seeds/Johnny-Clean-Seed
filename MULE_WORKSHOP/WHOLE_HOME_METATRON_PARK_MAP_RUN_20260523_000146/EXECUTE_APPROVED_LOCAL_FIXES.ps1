$ErrorActionPreference = 'Stop'

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$root = 'C:\Users\13527\Desktop\123'
$runDir = 'C:\Users\13527\Desktop\123\MULE_WORKSHOP\WHOLE_HOME_METATRON_PARK_MAP_RUN_20260523_000146'
$custody = 'C:\Users\13527\Desktop\123\GPT_PROMPTS_CUSTODY'
$receipts = Join-Path $custody 'RECEIPTS'
$issueReview = Join-Path $custody 'ISSUE_REVIEW'
$currentNonActive = Join-Path $custody 'CURRENT_NON_ACTIVE_RECURSIVE_CLEANOUTS'
$downloadsDest = Join-Path $custody "DOWNLOADS_LOOSE_CANDIDATES\$stamp"
$workOrderDest = Join-Path $runDir 'SOURCE_WORK_ORDERS'

foreach ($p in @($runDir, $custody, $receipts)) {
  if (-not (Test-Path -LiteralPath $p)) {
    throw "Required path missing: $p"
  }
}

foreach ($p in @($issueReview, $currentNonActive, $downloadsDest, $workOrderDest)) {
  New-Item -ItemType Directory -Force -Path $p | Out-Null
}

$resolvedCustody = (Resolve-Path -LiteralPath $custody).Path
foreach ($p in @($issueReview, $currentNonActive, $downloadsDest)) {
  $rp = (Resolve-Path -LiteralPath $p).Path
  if (-not $rp.StartsWith($resolvedCustody, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Destination escaped custody: $rp"
  }
}

$resolvedRun = (Resolve-Path -LiteralPath $runDir).Path
$resolvedWork = (Resolve-Path -LiteralPath $workOrderDest).Path
if (-not $resolvedWork.StartsWith($resolvedRun, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Work order destination escaped run dir: $resolvedWork"
}

$moved = New-Object System.Collections.Generic.List[object]

function Move-WithHash {
  param(
    [Parameter(Mandatory = $true)][string]$SourcePath,
    [Parameter(Mandatory = $true)][string]$DestinationDirectory
  )
  if (-not (Test-Path -LiteralPath $SourcePath)) {
    return
  }
  $item = Get-Item -LiteralPath $SourcePath -Force
  $hash = ''
  if (-not $item.PSIsContainer) {
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $item.FullName).Hash
  }
  $dest = Join-Path $DestinationDirectory $item.Name
  if (Test-Path -LiteralPath $dest) {
    $base = [IO.Path]::GetFileNameWithoutExtension($item.Name)
    $ext = [IO.Path]::GetExtension($item.Name)
    $dest = Join-Path $DestinationDirectory "$base`__$stamp$ext"
  }
  Move-Item -LiteralPath $item.FullName -Destination $dest
  $moved.Add([pscustomobject]@{
    Source = $item.FullName
    Destination = $dest
    SHA256 = $hash
    Length = if ($item.PSIsContainer) { $null } else { $item.Length }
  }) | Out-Null
}

Move-WithHash -SourcePath (Join-Path $root 'MULE_WHOLE_HOME_METATRON_PARK_MAP_WORK_ORDER_V1.md') -DestinationDirectory $workOrderDest

$rx = '(?i)^(CHAT_|MULE_|GPT_|NEW_CHAT|FINAL_CHAT|INSTALL_CHAT|CLEAN_CHAT|SAVE_CHAT|FIX_GPT|UPDATE_RULE|COMPLETE_CHAT|LOCK_|COLLECT_|BUILD_ASSISTANT|REPAIR_|RUN_MULE|SAVE_|PATCH_|ASSISTANT_LOCAL|MAIL_ROOM|CHILDJOB|SAM_REVIEW|CHILD_SHELL|COMMON_SENSE|DENSE_IDEA|INCIDENT_|README_INCIDENT|CPT_|NEOCITIES_|CODEX_SINGLE|TECH_MODEL|GOLD_|EVIDENCE_|CURRENT_TRUTH_INDEX|CLOSED_LOOP|ASSISTANT_CONSTRAINT|ROBLOX_BRIDGE|01_recursive|03_localbot|Core_Promotion|Sam_Packet|API_MCP|README_V6)'
Get-ChildItem -Force -File -LiteralPath 'C:\Users\13527\Downloads' |
  Where-Object { $_.Name -match $rx } |
  Sort-Object Name |
  ForEach-Object {
    Move-WithHash -SourcePath $_.FullName -DestinationDirectory $downloadsDest
  }

$receiptLines = @()
$receiptLines += 'WHOLE HOME METATRON PARK MAP EXECUTION RECEIPT'
$receiptLines += "timestamp: $stamp"
$receiptLines += 'actor: mule/local Codex'
$receiptLines += 'scope: approved local fixes after baseline; no CURRENT writes; no public export; no private prompt contents published'
$receiptLines += "run_dir: $runDir"
$receiptLines += "custody: $custody"
$receiptLines += "created_lanes: $issueReview ; $currentNonActive ; $downloadsDest ; $workOrderDest"
$receiptLines += "moved_count: $($moved.Count)"
$receiptLines += 'moved_files:'
foreach ($m in $moved) {
  $receiptLines += ('- {0} -> {1} | sha256={2} | bytes={3}' -f $m.Source, $m.Destination, $m.SHA256, $m.Length)
}
$receiptLines += 'blocked_items: Desktop-level GPT_Prompts missing was not created; CURRENT was not written; ambiguous Downloads false positives were left in place for issue review/out-of-scope judgment.'
$receiptLines += 'boundary_statement: local-only; no Git commit; no push; project repo public-safe note only; CURRENT read-only verification only.'
$receiptLines += 'verdict: DONE / REVIEW, NOT PASS'

$receiptPath = Join-Path $runDir "WHOLE_HOME_EXECUTION_RECEIPT_$stamp.txt"
$receiptCustody = Join-Path $receipts "WHOLE_HOME_EXECUTION_RECEIPT_$stamp.txt"
Set-Content -LiteralPath $receiptPath -Value $receiptLines -Encoding UTF8
Set-Content -LiteralPath $receiptCustody -Value $receiptLines -Encoding UTF8

[pscustomobject]@{
  MovedCount = $moved.Count
  Receipt = $receiptPath
  CustodyReceipt = $receiptCustody
  DownloadsDest = $downloadsDest
  WorkOrderDest = $workOrderDest
} | ConvertTo-Json
