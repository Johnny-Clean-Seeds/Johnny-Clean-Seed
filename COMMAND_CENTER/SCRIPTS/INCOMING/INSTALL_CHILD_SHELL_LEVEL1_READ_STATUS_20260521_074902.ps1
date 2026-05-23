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

$ReadmePath = Join-Path $ChildRoot "README_CHILD_SHELL_LEVEL1.md"
$AllowlistPath = Join-Path $ChildRoot "ALLOWLIST_LEVEL1.json"
$RunnerPath = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"
$JobId = "CHILDJOB-$(Get-Date -Format yyyyMMdd)-000002-READ-COMMAND-CENTER-STATUS"
$JobPath = Join-Path $Inbox "$JobId.childjob.json"
$InstallReceiptPath = Join-Path $Receipts "CHILD_SHELL_LEVEL1_READ_STATUS_INSTALL_RECEIPT_$Stamp.txt"

if (Test-Path -LiteralPath $InstallReceiptPath) {
    throw "STOP. Refusing to overwrite receipt: $InstallReceiptPath"
}

$Readme = @'
# Child Shell Level 1 Read-Status Route

## Purpose

Prove a controlled read-status route after Level 0 probe proof.

## Level 1 Allowed Action

read_command_center_status

## Boundary

Command Center local read only.
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
No broad filesystem crawl.

## Route

INBOX receives `.childjob.json` files.
RUNNERS/RUN_CHILD_SHELL_LEVEL1_ONCE.ps1 consumes one allowlisted read-status job.
OUTBOX receives receipt.
REJECTED receives malformed or blocked jobs.
PROCESSED receives accepted jobs after receipt.

## Proof

A read-status route is proved only when an allowlisted read job is consumed and an OUTBOX receipt includes selected safe file hashes and content snippets.
'@

Set-Content -LiteralPath $ReadmePath -Value $Readme -Encoding UTF8

$Allowlist = @'
{
  "level": 1,
  "allowed_actions": [
    "read_command_center_status"
  ],
  "allowed_read_files": [
    "README_START_HERE.md",
    "CURRENT_CONTEXT_CART.md",
    "NEXT_ON_THE_PLATE.md",
    "BLOCKED_MOVES.md",
    "ROOM_INDEX.md"
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
    "network_service",
    "broad_filesystem_crawl"
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
$AllowlistPath = Join-Path $ChildRoot "ALLOWLIST_LEVEL1.json"

if (-not (Test-Path -LiteralPath $AllowlistPath)) {
    throw "STOP. Allowlist missing: $AllowlistPath"
}

$Jobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
if ($Jobs.Count -eq 0) {
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
    Write-Host "CHILD SHELL LEVEL1 RUNNER"
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

if ($Action -ne "read_command_center_status") {
    $RejectPath = Join-Path $Rejected "$JobId.rejected.txt"
    Set-Content -LiteralPath $RejectPath -Value "Rejected blocked action: $Action" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Rejected blocked action: $Action"
}

$ReceiptPath = Join-Path $Outbox "$JobId.receipt.txt"
if (Test-Path -LiteralPath $ReceiptPath) {
    throw "STOP. Receipt already exists: $ReceiptPath"
}

$AllowedFiles = @(
    "README_START_HERE.md",
    "CURRENT_CONTEXT_CART.md",
    "NEXT_ON_THE_PLATE.md",
    "BLOCKED_MOVES.md",
    "ROOM_INDEX.md"
)

$ReadResults = New-Object System.Collections.Generic.List[string]

foreach ($Name in $AllowedFiles) {
    $FilePath = Join-Path $CC $Name
    if (Test-Path -LiteralPath $FilePath) {
        $Hash = (Get-FileHash -LiteralPath $FilePath -Algorithm SHA256).Hash
        $Content = Get-Content -LiteralPath $FilePath -Raw
        if ($Content.Length -gt 1800) {
            $Content = $Content.Substring(0, 1800) + "`n[TRUNCATED BY LEVEL1 RECEIPT]"
        }
        $ReadResults.Add(@"
----- $Name -----
Path: $FilePath
SHA256: $Hash
Content:
$Content
"@)
    }
    else {
        $ReadResults.Add(@"
----- $Name -----
Path: $FilePath
MISSING
"@)
    }
}

$JobHash = (Get-FileHash -LiteralPath $JobFile.FullName -Algorithm SHA256).Hash
$AllowlistHash = (Get-FileHash -LiteralPath $AllowlistPath -Algorithm SHA256).Hash

$Receipt = @"
CHILD SHELL LEVEL1 READ STATUS RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / LEVEL1 READ-STATUS JOB CONSUMED

Job ID:
$JobId

Action:
$Action

Job file:
$($JobFile.FullName)

Job SHA256:
$JobHash

Allowlist:
$AllowlistPath

Allowlist SHA256:
$AllowlistHash

Safe read results:
$($ReadResults -join "`n")

Boundary:
Command Center local read only.
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
No broad filesystem crawl.

Next:
Assistant may judge this receipt as Level 1 read-status route proof only. It does not prove Level 2 approved helper or Level 3 house save execution.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Processed $JobFile.Name) -Force

$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL LEVEL1 READ STATUS CONSUMED"
Write-Host "Verdict: PASS / LEVEL1 READ-STATUS JOB CONSUMED"
Write-Host "Job ID: $JobId"
Write-Host "Action: $Action"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Boundary: Command Center local read only; no Mr.Kleen repo write; no git; no doctrine install; no raw shell expansion; no delete; no permission expansion; no junction/symlink teleporter; no broad filesystem crawl."
Write-Host "Next: Level 2 approved-helper route or watcher/trigger path can be designed after assistant judges this receipt."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
'@

Set-Content -LiteralPath $RunnerPath -Value $Runner -Encoding UTF8

$Job = @"
{
  "job_id": "$JobId",
  "created_at": "$(Get-Date -Format o)",
  "requested_by": "assistant_via_user_local_install",
  "route": "COMMAND_CENTER/CHILD_SHELL",
  "allowed_action": "read_command_center_status",
  "target_path": "$($CC.Replace('\','\\'))",
  "input_files": [
    "README_START_HERE.md",
    "CURRENT_CONTEXT_CART.md",
    "NEXT_ON_THE_PLATE.md",
    "BLOCKED_MOVES.md",
    "ROOM_INDEX.md"
  ],
  "expected_receipt": "$($Outbox.Replace('\','\\'))\\$JobId.receipt.txt",
  "boundary": [
    "Command Center local read only",
    "no Mr.Kleen repo write",
    "no git",
    "no doctrine install",
    "no ACTIVE_GUIDES rewrite",
    "no CURRENT_TRUTH_INDEX rewrite",
    "no raw shell expansion",
    "no delete",
    "no overwrite outside Child Shell route lanes",
    "no bridge permission expansion",
    "no junction or symlink teleporter",
    "no broad filesystem crawl"
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
CHILD SHELL LEVEL1 READ STATUS INSTALL RECEIPT
Date: $(Get-Date -Format o)

Verdict:
INSTALLED LEVEL1 READ-STATUS ROUTE / RUNNING JOB NEXT

Files:
Readme: $ReadmePath
Readme SHA256: $ReadmeHash

Allowlist: $AllowlistPath
Allowlist SHA256: $AllowlistHash

Runner: $RunnerPath
Runner SHA256: $RunnerHash

Read-status job: $JobPath
Read-status job SHA256: $JobHash

Boundary:
Command Center local read only.
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
No broad filesystem crawl.

Next:
Run the Level1 runner once and judge OUTBOX receipt.
"@

Set-Content -LiteralPath $InstallReceiptPath -Value $InstallReceipt -Encoding UTF8
$InstallReceiptHash = (Get-FileHash -LiteralPath $InstallReceiptPath -Algorithm SHA256).Hash

& $RunnerPath

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL LEVEL1 READ STATUS ROUTE INSTALLED"
Write-Host "Verdict: INSTALLED LEVEL1 READ-STATUS ROUTE / JOB RUN ATTEMPTED"
Write-Host "Readme: $ReadmePath"
Write-Host "Allowlist: $AllowlistPath"
Write-Host "Runner: $RunnerPath"
Write-Host "Read Status Job: $JobPath"
Write-Host "Install Receipt: $InstallReceiptPath"
Write-Host "Install Receipt SHA256: $InstallReceiptHash"
Write-Host "Boundary: Command Center local read only; no Mr.Kleen repo write; no git; no doctrine install; no raw shell expansion; no delete; no permission expansion; no junction/symlink teleporter; no broad filesystem crawl."
Write-Host "Next: send CHILD SHELL LEVEL1 READ STATUS CONSUMED block and this install block to assistant."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
