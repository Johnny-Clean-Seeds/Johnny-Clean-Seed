$ErrorActionPreference = "Stop"

function Fail($Message) {
    throw "STOP. $Message"
}

function Assert-PathExists {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        Fail "Expected path missing: $Path"
    }
}

function Assert-ReceiptHash {
    param(
        [Parameter(Mandatory=$true)][string]$Label,
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$ExpectedHash
    )
    Assert-PathExists -Path $Path
    $ActualHash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($ActualHash -ne $ExpectedHash) {
        Fail "Hash mismatch for $Label`nPath: $Path`nExpected: $ExpectedHash`nActual:   $ActualHash"
    }
    return $ActualHash
}

if (-not (Test-Path -LiteralPath ".git")) {
    Fail "Run this in Mr.Kleen repo root: C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
}

$RepoRoot = (Get-Location).Path
$Branch = (git branch --show-current).Trim()
$StartHead = (git rev-parse --short HEAD).Trim()

$Date = "20260521"
$CC = "C:\Users\13527\Desktop\123\COMMAND_CENTER"

$ExpectedRepoFiles = @(
    "BRAIN_LEARNING\CHILD_SHELL_LEVEL0_LEVEL1_WATCHER_ROUTE_PROOF_RULE_$Date.md",
    "BRAIN_LEARNING\PROBLEM_SOLVER_SWEEP_AND_SINGLE_BOSS_COLLAPSE_RULE_$Date.md",
    "BRAIN_LEARNING\FILE_FIRST_ARTIFACT_WITH_LAUNCHER_BALANCE_RULE_$Date.md",
    "HOUSE_WORK\WORK_SHED\GEAR_RACK\RULE_MACHINES\PROBLEM_SOLVER_SWEEP_SINGLE_BOSS_COLLAPSE_CARD_$Date.md",
    "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_REVIEW_$Date.md",
    "PROOF_HISTORY\CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_RECEIPT_$Date.txt",
    "ACTIVE_ANCHOR.txt",
    "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
)

foreach ($Path in $ExpectedRepoFiles) {
    Assert-PathExists -Path $Path
}

$Level0Receipt = Join-Path $CC "CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000001-CHILD-SHELL-PROBE.receipt.txt"
$Level0InstallReceipt = Join-Path $CC "RECEIPTS\CHILD_SHELL_LEVEL0_ROUTE_INSTALL_RECEIPT_20260521_034024.txt"
$Level1Receipt = Join-Path $CC "CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000002-READ-COMMAND-CENTER-STATUS.receipt.txt"
$Level1InstallReceipt = Join-Path $CC "RECEIPTS\CHILD_SHELL_LEVEL1_READ_STATUS_INSTALL_RECEIPT_20260521_034321.txt"
$WatcherSelfTestReceipt = Join-Path $CC "CHILD_SHELL\OUTBOX\CHILDJOB-20260521-000004-WATCHER-PID-REPAIR-SELFTEST.receipt.txt"
$WatcherRepairReceipt = Join-Path $CC "RECEIPTS\CHILD_SHELL_WATCHER_PID_COLLISION_REPAIR_RECEIPT_20260521_035256.txt"

$Level0Hash = Assert-ReceiptHash -Label "Level 0 probe consumption" -Path $Level0Receipt -ExpectedHash "92D929697B7A556D470D3AB2E3C0A605BA6D3FD31CA397E261DFFB897519D59D"
$Level0InstallHash = Assert-ReceiptHash -Label "Level 0 install" -Path $Level0InstallReceipt -ExpectedHash "25326BF28B5C74FA05B767A96DD140B8A85A0821783FC4432A0AAE0F0794310D"
$Level1Hash = Assert-ReceiptHash -Label "Level 1 read-status consumption" -Path $Level1Receipt -ExpectedHash "77ACC8F139188DC4153FD776B34B0D393091EAE2681514FF06E1A0F2D6CA7F31"
$Level1InstallHash = Assert-ReceiptHash -Label "Level 1 install" -Path $Level1InstallReceipt -ExpectedHash "64AE57E6C02E3646C1FE3AF1AB7128821AC75167ACF8A16F7DD40EB8CB888F66"
$WatcherSelfTestHash = Assert-ReceiptHash -Label "Watcher PID repair self-test" -Path $WatcherSelfTestReceipt -ExpectedHash "CEB432FB18B672129EA5DA5565E146E24E2F21C2501134D62254DA66E0095E6C"
$WatcherRepairHash = Assert-ReceiptHash -Label "Watcher PID repair receipt" -Path $WatcherRepairReceipt -ExpectedHash "5E124F7C8AA2F1F63B4CB3138AFDFF123732E68FFE069BFAE752359B9B8619C7"

$StatusBefore = git status --short
if ($LASTEXITCODE -ne 0) {
    Fail "git status failed before repair."
}

$AllowedStatusPatterns = @(
    "BRAIN_LEARNING/CHILD_SHELL_LEVEL0_LEVEL1_WATCHER_ROUTE_PROOF_RULE_20260521.md",
    "BRAIN_LEARNING/PROBLEM_SOLVER_SWEEP_AND_SINGLE_BOSS_COLLAPSE_RULE_20260521.md",
    "BRAIN_LEARNING/FILE_FIRST_ARTIFACT_WITH_LAUNCHER_BALANCE_RULE_20260521.md",
    "HOUSE_WORK/WORK_SHED/GEAR_RACK/RULE_MACHINES/PROBLEM_SOLVER_SWEEP_SINGLE_BOSS_COLLAPSE_CARD_20260521.md",
    "HOUSE_WORK/WORK_SHED/SORTING_BENCH/CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_REVIEW_20260521.md",
    "PROOF_HISTORY/CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_RECEIPT_20260521.txt",
    "ACTIVE_ANCHOR.txt",
    "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"
)

$Unexpected = New-Object System.Collections.Generic.List[string]
foreach ($Line in $StatusBefore) {
    $Hit = $false
    foreach ($Allowed in $AllowedStatusPatterns) {
        if ($Line -like "*$Allowed") {
            $Hit = $true
            break
        }
    }
    if (-not $Hit -and -not [string]::IsNullOrWhiteSpace($Line)) {
        $Unexpected.Add($Line)
    }
}

if ($Unexpected.Count -gt 0) {
    Fail "Unexpected dirty paths present. Refusing repair commit.`n$($Unexpected -join "`n")"
}

# Reset partial staging from the failed attempt so this repair controls exactly what is committed.
git reset -- @($ExpectedRepoFiles | Where-Object { $_ -ne "PROOF_HISTORY\CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_RECEIPT_$Date.txt" })
if ($LASTEXITCODE -ne 0) {
    Fail "git reset failed."
}

# Stage expected non-ignored files normally.
$NonIgnored = $ExpectedRepoFiles | Where-Object { $_ -ne "PROOF_HISTORY\CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_RECEIPT_$Date.txt" }
git add -- $NonIgnored
if ($LASTEXITCODE -ne 0) {
    Fail "git add failed for non-ignored expected files."
}

# Force-add the ignored proof receipt only.
$ProofPath = "PROOF_HISTORY\CHILD_SHELL_WATCHER_AND_PROBLEM_SOLVER_LOCK_SAVE_RECEIPT_$Date.txt"
git add -f -- $ProofPath
if ($LASTEXITCODE -ne 0) {
    Fail "git add -f failed for ignored PROOF_HISTORY receipt."
}

$Staged = git diff --cached --name-only
if ([string]::IsNullOrWhiteSpace(($Staged | Out-String).Trim())) {
    Fail "Nothing staged after repair."
}

git commit -m "Lock child shell watcher and problem solver gates"
if ($LASTEXITCODE -ne 0) {
    Fail "git commit failed."
}

git push
if ($LASTEXITCODE -ne 0) {
    Fail "git push failed."
}

$FinalHead = (git rev-parse --short HEAD).Trim()
$FinalFullHead = (git rev-parse HEAD).Trim()
$OriginHead = (git rev-parse --short origin/main).Trim()
$FinalStatus = git status --short

if (-not [string]::IsNullOrWhiteSpace(($FinalStatus | Out-String).Trim())) {
    Fail "Final repo status is not clean.`n$($FinalStatus | Out-String)"
}

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL LOCK SAVE GIT ADD IGNORED PROOF REPAIRED"
Write-Host "Verdict: PASS / SAVED AND PUSHED"
Write-Host "Issue: git add failed because PROOF_HISTORY is ignored."
Write-Host "Fix: staged expected files only and force-added the one intended PROOF_HISTORY receipt."
Write-Host "Branch: $Branch"
Write-Host "Previous HEAD: $StartHead"
Write-Host "Current HEAD: $FinalHead"
Write-Host "Current HEAD full: $FinalFullHead"
Write-Host "Origin main: $OriginHead"
Write-Host "Status: clean"
Write-Host "Saved files:"
foreach ($Path in $ExpectedRepoFiles) {
    Write-Host "- $Path"
}
Write-Host "Validated proof receipts:"
Write-Host "- Level0 probe: $Level0Hash"
Write-Host "- Level0 install: $Level0InstallHash"
Write-Host "- Level1 read-status: $Level1Hash"
Write-Host "- Level1 install: $Level1InstallHash"
Write-Host "- Watcher self-test: $WatcherSelfTestHash"
Write-Host "- Watcher PID repair: $WatcherRepairHash"
Write-Host "Boundary: no doctrine rewrite; no ACTIVE_GUIDES rewrite; no CURRENT_TRUTH_INDEX rewrite; no Level2/Level3 promotion; no raw shell expansion; no delete; no permission expansion; no junction/symlink teleporter; no broad filesystem crawl."
Write-Host "Next: Level1 watcher read-status drops are allowed; Level2 approved-helper route remains the next separate boss if selected."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
