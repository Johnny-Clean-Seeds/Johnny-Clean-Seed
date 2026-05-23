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
