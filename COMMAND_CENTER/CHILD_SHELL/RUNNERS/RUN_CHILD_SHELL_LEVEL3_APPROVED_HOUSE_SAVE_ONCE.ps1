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

    $RejectNote = Join-Path $Rejected "$JobId.level3.rejected.txt"
    Set-Content -LiteralPath $RejectNote -Value "Rejected Level3 job: $Reason`nJob file: $($JobFile.FullName)`nDate: $(Get-Date -Format o)" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Rejected Level3 job: $Reason"
}

function Assert-UnderRoot {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Root,
        [Parameter(Mandatory=$true)][string]$Reason
    )
    $ResolvedPath = [System.IO.Path]::GetFullPath($Path)
    $ResolvedRoot = [System.IO.Path]::GetFullPath($Root).TrimEnd("\")
    if ($ResolvedPath.Equals($ResolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return
    }
    if (-not $ResolvedPath.StartsWith("$ResolvedRoot\", [System.StringComparison]::OrdinalIgnoreCase)) {
        throw $Reason
    }
}

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$PackageRoot = Join-Path $ChildRoot "HOUSE_SAVE_PACKAGES"
$ResultRoot = Join-Path $ChildRoot "LEVEL3_RESULTS"
$AllowlistPath = Join-Path $ChildRoot "ALLOWLIST_LEVEL3_APPROVED_HOUSE_SAVE_HELPERS.json"

New-Item -ItemType Directory -Force -Path $Inbox, $Outbox, $Rejected, $Processed, $PackageRoot, $ResultRoot | Out-Null

if (-not (Test-Path -LiteralPath $AllowlistPath)) {
    throw "STOP. Level3 allowlist missing: $AllowlistPath"
}

$Jobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
if ($Jobs.Count -eq 0) {
    Write-Host "CHILD SHELL LEVEL3 RUNNER: NO JOB FOUND"
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
$PackagePath = [string]$Job.package_path
$ExpectedPackageHash = [string]$Job.package_sha256

if ([string]::IsNullOrWhiteSpace($JobId)) {
    Reject-Job -Reason "missing job_id" -JobFile $JobFile
}

if ($Action -ne "run_approved_house_save_package") {
    Reject-Job -Reason "blocked action: $Action" -JobFile $JobFile -JobId $JobId
}

if ($HelperName -ne "run_bounded_mr_kleen_save_package") {
    Reject-Job -Reason "helper not approved for Level3: $HelperName" -JobFile $JobFile -JobId $JobId
}

if ([string]::IsNullOrWhiteSpace($PackagePath)) {
    Reject-Job -Reason "missing package_path" -JobFile $JobFile -JobId $JobId
}

if ([string]::IsNullOrWhiteSpace($ExpectedPackageHash)) {
    Reject-Job -Reason "missing package_sha256" -JobFile $JobFile -JobId $JobId
}

$ReceiptPath = Join-Path $Outbox "$JobId.receipt.txt"
if (Test-Path -LiteralPath $ReceiptPath) {
    Reject-Job -Reason "receipt already exists: $ReceiptPath" -JobFile $JobFile -JobId $JobId
}

$ResultPath = Join-Path $ResultRoot "$JobId.level3-result.json"
if (Test-Path -LiteralPath $ResultPath) {
    Reject-Job -Reason "Level3 result already exists: $ResultPath" -JobFile $JobFile -JobId $JobId
}

try {
    Assert-UnderRoot -Path $PackagePath -Root $PackageRoot -Reason "package path outside approved package root"
}
catch {
    Reject-Job -Reason $_.Exception.Message -JobFile $JobFile -JobId $JobId
}

if (-not (Test-Path -LiteralPath $PackagePath)) {
    Reject-Job -Reason "package missing: $PackagePath" -JobFile $JobFile -JobId $JobId
}

$ActualPackageHash = (Get-FileHash -LiteralPath $PackagePath -Algorithm SHA256).Hash
if ($ActualPackageHash -ne $ExpectedPackageHash) {
    Reject-Job -Reason "package hash mismatch. Expected $ExpectedPackageHash actual $ActualPackageHash" -JobFile $JobFile -JobId $JobId
}

$Allowlist = Get-Content -LiteralPath $AllowlistPath -Raw | ConvertFrom-Json
$AllowedHelper = @($Allowlist.helpers | Where-Object { $_.helper_name -eq $HelperName }) | Select-Object -First 1

if ($null -eq $AllowedHelper) {
    Reject-Job -Reason "helper not allowlisted: $HelperName" -JobFile $JobFile -JobId $JobId
}

$HelperPath = [string]$AllowedHelper.helper_path
$ExpectedHelperHash = [string]$AllowedHelper.helper_sha256

if (-not (Test-Path -LiteralPath $HelperPath)) {
    Reject-Job -Reason "allowlisted helper path missing: $HelperPath" -JobFile $JobFile -JobId $JobId
}

$ActualHelperHash = (Get-FileHash -LiteralPath $HelperPath -Algorithm SHA256).Hash
if ($ActualHelperHash -ne $ExpectedHelperHash) {
    Reject-Job -Reason "helper hash mismatch. Expected $ExpectedHelperHash actual $ActualHelperHash" -JobFile $JobFile -JobId $JobId
}

$AllowlistHash = (Get-FileHash -LiteralPath $AllowlistPath -Algorithm SHA256).Hash
$JobHash = (Get-FileHash -LiteralPath $JobFile.FullName -Algorithm SHA256).Hash

try {
    & $HelperPath -CommandCenterPath $CC -ChildRoot $ChildRoot -JobId $JobId -PackagePath $PackagePath -ResultPath $ResultPath
}
catch {
    Reject-Job -Reason "helper threw exception: $($_.Exception.Message)" -JobFile $JobFile -JobId $JobId
}

if (-not (Test-Path -LiteralPath $ResultPath)) {
    Reject-Job -Reason "helper did not create expected Level3 result: $ResultPath" -JobFile $JobFile -JobId $JobId
}

$ResultHash = (Get-FileHash -LiteralPath $ResultPath -Algorithm SHA256).Hash
$Result = Get-Content -LiteralPath $ResultPath -Raw | ConvertFrom-Json

if ([string]$Result.verdict -ne "PASS / LEVEL3 BOUNDED HOUSE SAVE PACKAGE CONSUMED") {
    Reject-Job -Reason "Level3 result verdict not PASS" -JobFile $JobFile -JobId $JobId
}
if ([string]$Result.final_git_status -ne "clean") {
    Reject-Job -Reason "Level3 result final git status not clean" -JobFile $JobFile -JobId $JobId
}
if ([string]$Result.commit_full_hash -ne [string]$Result.origin_main) {
    Reject-Job -Reason "Level3 result origin/main does not match HEAD" -JobFile $JobFile -JobId $JobId
}

$FilesWrittenText = (@($Result.files_written) | ForEach-Object {
    "- $($_.relative_path) [$($_.mode)] SHA256: $($_.final_sha256)"
}) -join "`n"

$BoundaryText = (@($Result.boundary) | ForEach-Object { "- $_" }) -join "`n"

$Receipt = @"
BRIDGE LEVEL3 BOUNDED HOUSE SAVE CONSUMED
Date: $(Get-Date -Format o)

Verdict:
PASS / LEVEL3 BOUNDED HOUSE SAVE PACKAGE CONSUMED

Job ID:
$JobId

Action:
$Action

Approved helper name:
$HelperName

Approved helper path:
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

Input package path:
$PackagePath

Input package SHA256:
$ActualPackageHash

Level3 result:
$ResultPath

Level3 result SHA256:
$ResultHash

Files written:
$FilesWrittenText

Commit short hash:
$($Result.commit_short_hash)

Commit full hash:
$($Result.commit_full_hash)

Push result:
$($Result.push_result)

Final git status:
$($Result.final_git_status)

Origin main:
$($Result.origin_main)

Boundary:
$BoundaryText

What this proves:
A watcher-dispatched Level3 job can consume one exact approved house-save package, write only approved Mr.Kleen support/proof files, commit, push, and verify clean origin/main parity.

What this does not prove:
Assistant-direct local execution from chat.
Arbitrary command execution.
Raw shell expansion.
Unrestricted repo write.
Uncontrolled git.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8
Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Processed $JobFile.Name) -Force

$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "BRIDGE LEVEL3 BOUNDED HOUSE SAVE CONSUMED"
Write-Host "Verdict: PASS / LEVEL3 BOUNDED HOUSE SAVE PACKAGE CONSUMED"
Write-Host "Job ID: $JobId"
Write-Host "Action: $Action"
Write-Host "Approved helper name: $HelperName"
Write-Host "Helper SHA256: $ActualHelperHash"
Write-Host "Input package path: $PackagePath"
Write-Host "Input package SHA256: $ActualPackageHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Commit: $($Result.commit_short_hash)"
Write-Host "Boundary: bounded Level3 house-save package only; exact package hash; exact approved file list; approved write lanes only; no delete; no arbitrary shell; no raw shell expansion; no broad filesystem crawl; no permission expansion."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
