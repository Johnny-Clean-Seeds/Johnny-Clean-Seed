$ErrorActionPreference = "Stop"

$Root123 = "C:\Users\13527\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"

if (-not (Test-Path -LiteralPath $CC)) {
    throw "STOP. Command Center not found: $CC"
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Receipts = Join-Path $CC "RECEIPTS"

New-Item -ItemType Directory -Force -Path $ChildRoot, $Inbox, $Outbox, $Rejected, $Processed, $Runners, $Receipts | Out-Null

$ReadmePath = Join-Path $ChildRoot "README_CHILD_SHELL_LEVEL0.md"
$AllowlistPath = Join-Path $ChildRoot "ALLOWLIST_LEVEL0.json"
$RunnerPath = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL0_ONCE.ps1"
$JobId = "CHILDJOB-$(Get-Date -Format yyyyMMdd)-000001-CHILD-SHELL-PROBE"
$JobPath = Join-Path $Inbox "$JobId.childjob.json"
$InstallReceiptPath = Join-Path $Receipts "CHILD_SHELL_LEVEL0_ROUTE_INSTALL_RECEIPT_$Stamp.txt"

if (Test-Path -LiteralPath $InstallReceiptPath) {
    throw "STOP. Refusing to overwrite receipt: $InstallReceiptPath"
}

$Readme = @'
# Child Shell Level 0 Route

## Purpose

Create the smallest callable Child Shell route.

## Level 0 Allowed Action

probe_child_shell_route

## Boundary

Command Center local only.
No Mr.Kleen repo write.
No git.
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No raw shell expansion.
No delete.
No overwrite outside Child Shell route lanes.
No bridge permission expansion.
No junction or symlink teleporter.

## Route

INBOX receives `.childjob.json` files.
RUNNERS/RUN_CHILD_SHELL_LEVEL0_ONCE.ps1 consumes one allowlisted job.
OUTBOX receives receipt.
REJECTED receives malformed or blocked jobs.
PROCESSED receives accepted jobs after receipt.

## Proof

A route is not proven because a job file exists.

A route is proven only when an allowlisted job is consumed and an OUTBOX receipt is written.
'@

Set-Content -LiteralPath $ReadmePath -Value $Readme -Encoding UTF8

$Allowlist = @'
{
  "level": 0,
  "allowed_actions": [
    "probe_child_shell_route"
  ],
  "blocked": [
    "git",
    "mr_kleen_write",
    "doctrine_install",
    "active_guides_rewrite",
    "current_truth_index_rewrite",
    "raw_shell",
    "delete",
    "overwrite_outside_child_shell",
    "permission_expansion",
    "junction_symlink_teleporter",
    "network_service"
  ]
}
'@

Set-Content -LiteralPath $AllowlistPath -Value $Allowlist -Encoding UTF8

$Runner = @'
$ErrorActionPreference = "Stop"

$Root123 = "C:\Users\13527\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$AllowlistPath = Join-Path $ChildRoot "ALLOWLIST_LEVEL0.json"

if (-not (Test-Path -LiteralPath $AllowlistPath)) {
    throw "STOP. Allowlist missing: $AllowlistPath"
}

$Jobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
if ($Jobs.Count -eq 0) {
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
    Write-Host "CHILD SHELL LEVEL0 RUNNER"
    Write-Host "Verdict: NO JOB FOUND"
    Write-Host "Inbox: $Inbox"
    Write-Host "Boundary: no action taken"
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
    return
}

$JobFile = $Jobs[0]
$JobRaw = Get-Content -LiteralPath $JobFile.FullName -Raw

try {
    $Job = $JobRaw | ConvertFrom-Json
}
catch {
    $RejectPath = Join-Path $Rejected "$($JobFile.BaseName).rejected.txt"
    Set-Content -LiteralPath $RejectPath -Value "Rejected malformed JSON: $($JobFile.FullName)`n$($_.Exception.Message)" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Rejected malformed job: $($JobFile.FullName)"
}

$JobId = [string]$Job.job_id
$Action = [string]$Job.allowed_action

if ([string]::IsNullOrWhiteSpace($JobId)) {
    $RejectPath = Join-Path $Rejected "$($JobFile.BaseName).rejected.txt"
    Set-Content -LiteralPath $RejectPath -Value "Rejected missing job_id: $($JobFile.FullName)" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Rejected missing job_id."
}

if ($Action -ne "probe_child_shell_route") {
    $RejectPath = Join-Path $Rejected "$JobId.rejected.txt"
    Set-Content -LiteralPath $RejectPath -Value "Rejected blocked action: $Action" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Rejected blocked action: $Action"
}

$ReceiptPath = Join-Path $Outbox "$JobId.receipt.txt"
if (Test-Path -LiteralPath $ReceiptPath) {
    throw "STOP. Receipt already exists: $ReceiptPath"
}

$JobHash = (Get-FileHash -LiteralPath $JobFile.FullName -Algorithm SHA256).Hash
$CCExists = Test-Path -LiteralPath $CC
$ChildRootExists = Test-Path -LiteralPath $ChildRoot
$InboxExists = Test-Path -LiteralPath $Inbox
$OutboxExists = Test-Path -LiteralPath $Outbox
$RejectedExists = Test-Path -LiteralPath $Rejected
$ProcessedExists = Test-Path -LiteralPath $Processed
$AllowlistHash = (Get-FileHash -LiteralPath $AllowlistPath -Algorithm SHA256).Hash

$Receipt = @"
CHILD SHELL LEVEL0 JOB RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / LEVEL0 PROBE JOB CONSUMED

Job ID:
$JobId

Action:
$Action

Job file:
$($JobFile.FullName)

Job SHA256:
$JobHash

Route exists:
Command Center: $CCExists
Child Root: $ChildRootExists
Inbox: $InboxExists
Outbox: $OutboxExists
Rejected: $RejectedExists
Processed: $ProcessedExists

Allowlist:
$AllowlistPath

Allowlist SHA256:
$AllowlistHash

Boundary:
Command Center local only.
No Mr.Kleen repo write.
No git.
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No raw shell expansion.
No delete.
No overwrite outside Child Shell route lanes.
No bridge permission expansion.
No junction or symlink teleporter.

Next:
Assistant may judge this receipt as Level 0 Child Shell route proof only. It does not prove Level 1 read status or Level 3 house save execution.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Processed $JobFile.Name) -Force

$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL LEVEL0 JOB CONSUMED"
Write-Host "Verdict: PASS / LEVEL0 PROBE JOB CONSUMED"
Write-Host "Job ID: $JobId"
Write-Host "Action: $Action"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Boundary: Command Center local only; no Mr.Kleen repo write; no git; no doctrine install; no raw shell expansion; no delete; no permission expansion; no junction/symlink teleporter."
Write-Host "Next: Level 1 read-status route can be designed after assistant judges this receipt."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
'@

Set-Content -LiteralPath $RunnerPath -Value $Runner -Encoding UTF8

$Job = @"
{
  "job_id": "$JobId",
  "created_at": "$(Get-Date -Format o)",
  "requested_by": "assistant_via_user_local_install",
  "route": "COMMAND_CENTER/CHILD_SHELL",
  "allowed_action": "probe_child_shell_route",
  "target_path": "$($CC.Replace('\','\\'))",
  "input_files": [],
  "expected_receipt": "$($Outbox.Replace('\','\\'))\\$JobId.receipt.txt",
  "boundary": [
    "Command Center local only",
    "no Mr.Kleen repo write",
    "no git",
    "no doctrine install",
    "no ACTIVE_GUIDES rewrite",
    "no CURRENT_TRUTH_INDEX rewrite",
    "no raw shell expansion",
    "no delete",
    "no overwrite outside Child Shell route lanes",
    "no bridge permission expansion",
    "no junction or symlink teleporter"
  ],
  "stop_conditions": [
    "Command Center missing",
    "allowlist missing",
    "job action not allowlisted",
    "receipt already exists",
    "malformed job"
  ],
  "hash_requirements": []
}
"@

Set-Content -LiteralPath $JobPath -Value $Job -Encoding UTF8

$ReadmeHash = (Get-FileHash -LiteralPath $ReadmePath -Algorithm SHA256).Hash
$AllowlistHash = (Get-FileHash -LiteralPath $AllowlistPath -Algorithm SHA256).Hash
$RunnerHash = (Get-FileHash -LiteralPath $RunnerPath -Algorithm SHA256).Hash
$JobHash = (Get-FileHash -LiteralPath $JobPath -Algorithm SHA256).Hash

$InstallReceipt = @"
CHILD SHELL LEVEL0 ROUTE INSTALL RECEIPT
Date: $(Get-Date -Format o)

Verdict:
INSTALLED LEVEL0 ROUTE / RUNNING PROBE JOB NEXT

Files:
Readme: $ReadmePath
Readme SHA256: $ReadmeHash

Allowlist: $AllowlistPath
Allowlist SHA256: $AllowlistHash

Runner: $RunnerPath
Runner SHA256: $RunnerHash

Probe job: $JobPath
Probe job SHA256: $JobHash

Boundary:
Command Center local only.
No Mr.Kleen repo write.
No git.
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No raw shell expansion.
No delete.
No overwrite outside Child Shell route lanes.
No bridge permission expansion.
No junction or symlink teleporter.

Next:
Run the Level0 runner once and judge OUTBOX receipt.
"@

Set-Content -LiteralPath $InstallReceiptPath -Value $InstallReceipt -Encoding UTF8
$InstallReceiptHash = (Get-FileHash -LiteralPath $InstallReceiptPath -Algorithm SHA256).Hash

# Run Level 0 once to prove the local child-shell route can consume a job.
& $RunnerPath

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL LEVEL0 ROUTE INSTALLED"
Write-Host "Verdict: INSTALLED LEVEL0 ROUTE / PROBE RUN ATTEMPTED"
Write-Host "Readme: $ReadmePath"
Write-Host "Allowlist: $AllowlistPath"
Write-Host "Runner: $RunnerPath"
Write-Host "Probe Job: $JobPath"
Write-Host "Install Receipt: $InstallReceiptPath"
Write-Host "Install Receipt SHA256: $InstallReceiptHash"
Write-Host "Boundary: Command Center local only; no Mr.Kleen repo write; no git; no doctrine install; no raw shell expansion; no delete; no permission expansion; no junction/symlink teleporter."
Write-Host "Next: send CHILD SHELL LEVEL0 JOB CONSUMED block and this install block to assistant."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
