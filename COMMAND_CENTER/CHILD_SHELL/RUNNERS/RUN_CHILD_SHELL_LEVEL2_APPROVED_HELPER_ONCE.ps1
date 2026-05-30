$ErrorActionPreference = "Stop"

function Reject-Job {
    param(
        [Parameter(Mandatory=$true)][string]$Reason,
        [Parameter(Mandatory=$true)][System.IO.FileInfo]$JobFile,
        [Parameter(Mandatory=$false)][string]$JobId = ""
    )

    $Root123 = "$env:USERPROFILE\Desktop\123"
    $CC = Join-Path $Root123 "COMMAND_CENTER"
    $ChildRoot = Join-Path $CC "CHILD_SHELL"
    $Rejected = Join-Path $ChildRoot "REJECTED"

    if ([string]::IsNullOrWhiteSpace($JobId)) {
        $JobId = $JobFile.BaseName
    }

    $RejectNote = Join-Path $Rejected "$JobId.level2.rejected.txt"
    Set-Content -LiteralPath $RejectNote -Value "Rejected Level2 job: $Reason`nJob file: $($JobFile.FullName)`nDate: $(Get-Date -Format o)" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Rejected Level2 job: $Reason"
}

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$HelperOutput = Join-Path $ChildRoot "HELPER_OUTPUT"
$AllowlistPath = Join-Path $ChildRoot "ALLOWLIST_LEVEL2_APPROVED_HELPERS.json"

New-Item -ItemType Directory -Force -Path $Inbox, $Outbox, $Rejected, $Processed, $HelperOutput | Out-Null

if (-not (Test-Path -LiteralPath $AllowlistPath)) {
    throw "STOP. Level2 allowlist missing: $AllowlistPath"
}

$Jobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
if ($Jobs.Count -eq 0) {
    Write-Host "CHILD SHELL LEVEL2 RUNNER: NO JOB FOUND"
    return
}

$JobFile = $Jobs[0]
$JobRaw = Get-Content -LiteralPath $JobFile.FullName -Raw

try {
    $Job = $JobRaw | ConvertFrom-Json
}
catch {
    Reject-Job -Reason "malformed JSON: $($_.Exception.Message)" -JobFile $JobFile
}

$JobId = [string]$Job.job_id
$Action = [string]$Job.allowed_action
$HelperName = [string]$Job.helper_name

if ([string]::IsNullOrWhiteSpace($JobId)) {
    Reject-Job -Reason "missing job_id" -JobFile $JobFile
}

if ($Action -ne "run_approved_helper") {
    Reject-Job -Reason "blocked action: $Action" -JobFile $JobFile -JobId $JobId
}

if ([string]::IsNullOrWhiteSpace($HelperName)) {
    Reject-Job -Reason "missing helper_name" -JobFile $JobFile -JobId $JobId
}

$ReceiptPath = Join-Path $Outbox "$JobId.receipt.txt"
if (Test-Path -LiteralPath $ReceiptPath) {
    Reject-Job -Reason "receipt already exists: $ReceiptPath" -JobFile $JobFile -JobId $JobId
}

$Allowlist = Get-Content -LiteralPath $AllowlistPath -Raw | ConvertFrom-Json
$AllowedHelper = @($Allowlist.helpers | Where-Object { $_.helper_name -eq $HelperName }) | Select-Object -First 1

if ($null -eq $AllowedHelper) {
    Reject-Job -Reason "helper not allowlisted: $HelperName" -JobFile $JobFile -JobId $JobId
}

$HelperPath = [string]$AllowedHelper.helper_path
$ExpectedHelperHash = [string]$AllowedHelper.helper_sha256
$AllowedWriteRoot = [string]$AllowedHelper.allowed_write_root

if (-not (Test-Path -LiteralPath $HelperPath)) {
    Reject-Job -Reason "allowlisted helper path missing: $HelperPath" -JobFile $JobFile -JobId $JobId
}

$ActualHelperHash = (Get-FileHash -LiteralPath $HelperPath -Algorithm SHA256).Hash
if ($ActualHelperHash -ne $ExpectedHelperHash) {
    Reject-Job -Reason "helper hash mismatch. Expected $ExpectedHelperHash actual $ActualHelperHash" -JobFile $JobFile -JobId $JobId
}

$AllowlistHash = (Get-FileHash -LiteralPath $AllowlistPath -Algorithm SHA256).Hash
$JobHash = (Get-FileHash -LiteralPath $JobFile.FullName -Algorithm SHA256).Hash

$OutputPath = Join-Path $HelperOutput "$JobId.helper-output.txt"
if (Test-Path -LiteralPath $OutputPath) {
    Reject-Job -Reason "helper output already exists: $OutputPath" -JobFile $JobFile -JobId $JobId
}

$OutputParent = Split-Path -Parent $OutputPath
$ResolvedOutputParent = [System.IO.Path]::GetFullPath($OutputParent)
$ResolvedAllowedRoot = [System.IO.Path]::GetFullPath($AllowedWriteRoot)
if (-not $ResolvedOutputParent.StartsWith($ResolvedAllowedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    Reject-Job -Reason "helper output path outside allowed root" -JobFile $JobFile -JobId $JobId
}

try {
    & $HelperPath -CommandCenterPath $CC -JobId $JobId -OutputPath $OutputPath
}
catch {
    Reject-Job -Reason "helper threw exception: $($_.Exception.Message)" -JobFile $JobFile -JobId $JobId
}

if (-not (Test-Path -LiteralPath $OutputPath)) {
    Reject-Job -Reason "helper did not create expected output: $OutputPath" -JobFile $JobFile -JobId $JobId
}

$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$Receipt = @"
CHILD SHELL LEVEL2 APPROVED HELPER CONSUMED
Date: $(Get-Date -Format o)

Verdict:
PASS / LEVEL2 APPROVED HELPER JOB CONSUMED

Job ID:
$JobId

Action:
$Action

Helper name:
$HelperName

Helper path:
$HelperPath

Helper SHA256:
$ActualHelperHash

Allowlist:
$AllowlistPath

Allowlist SHA256:
$AllowlistHash

Job file:
$($JobFile.FullName)

Job SHA256:
$JobHash

Helper output:
$OutputPath

Helper output SHA256:
$OutputHash

Boundary:
Command Center Child Shell Level2 approved-helper only.
No arbitrary shell.
No raw shell expansion.
No Mr.Kleen repo write.
No git.
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No delete.
No broad filesystem crawl.
No permission expansion.
No junction/symlink teleporter.

What this proves:
A watcher-dispatched Level2 job can run one named allowlisted helper after helper hash validation and produce an OUTBOX receipt.

What this does not prove:
Assistant-direct local execution from chat.
Level3 Mr.Kleen house-save execution.
Arbitrary command execution.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8
Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Processed $JobFile.Name) -Force

$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL LEVEL2 APPROVED HELPER CONSUMED"
Write-Host "Verdict: PASS / LEVEL2 APPROVED HELPER JOB CONSUMED"
Write-Host "Job ID: $JobId"
Write-Host "Action: $Action"
Write-Host "Helper name: $HelperName"
Write-Host "Helper SHA256: $ActualHelperHash"
Write-Host "Allowlist SHA256: $AllowlistHash"
Write-Host "Helper output: $OutputPath"
Write-Host "Helper output SHA256: $OutputHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Boundary: Command Center Child Shell Level2 approved-helper only; no arbitrary shell; no raw shell expansion; no Mr.Kleen repo write; no git; no doctrine install; no delete; no broad filesystem crawl; no permission expansion; no junction/symlink teleporter."
Write-Host "Next: assistant may judge Level2 approved-helper proof only; Level3 remains blocked."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"

<!-- LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:F12F14A305F6AE9C -->
## Living Object Registry V2 — First-Wave Bounded Repair Note

Status: SELECTED_FIRST_WAVE_REPAIR / NOT_DOCTRINE
WorkKey: LIVING-OBJECT-REGISTRY-V2-FIRST-WAVE-BOUNDED-REPAIR-20260530-V1
RunId: 20260530_150214

Object path: COMMAND_CENTER/CHILD_SHELL/RUNNERS/RUN_CHILD_SHELL_LEVEL2_APPROVED_HELPER_ONCE.ps1
Species: HELPER_OBJECT
Owner room: UNKNOWN_OWNER_ROOM
Authority class: HELPER_SUPPORT_NOT_JUDGE
Repair field: RouteEvidence
Failure family: HELPER WITHOUT ASSAY
Suggested stitch: HELPER STITCH
Repair reason: Helper object should include route evidence fields.

Registry key tags:
- LIVING_OBJECT_REGISTRY_V2
- FIRST_WAVE_REPAIR
- HELPER_OBJECT
- RouteEvidence

Ledger home: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Map / route home: HOUSE_WORK/WORK_SHED/INDEXES/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR_ROUTE_INDEX_20260530.md
Proof pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Currentness: CURRENT_SUPPORT_REPAIR_NOTE
Disposition: KEEP_WITH_OBJECT_UNTIL_REAUDIT

Allowed action:
- Repair only this named audit gap by adding contract/route/proof/return metadata.

Forbidden actions:
- Do not promote this object to doctrine.
- Do not treat this block as proof of full cleanliness.
- Do not repair unrelated gaps from this block.
- Do not delete or move this object.

Boundary:
- selected ticket path only
- no doctrine
- no ACTIVE_GUIDES
- no CURRENT_TRUTH_INDEX
- no broad refactor
- no delete
- no move
- no automation

## Helper assay fields

Task: Repair selected first-wave registry gap only.
Route tested: selected repair ticket -> target object -> route index -> receipt -> return TODO.
Source: first-wave selected repair plan.
Target: COMMAND_CENTER/CHILD_SHELL/RUNNERS/RUN_CHILD_SHELL_LEVEL2_APPROVED_HELPER_ONCE.ps1
Relation: bounded registry repair / selected named gap.
Toolbelt: Living Object Contract; Helper Control Shell; Route Court; Policy Gate.
Proof/source pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Verdict: HELPER_CONTRACT_REPAIRED_PENDING_REAUDIT
<!-- /LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:RouteEvidence -->
