$ErrorActionPreference = "Continue"

$RepoRoot = (Get-Location).Path
$ToolDir = "HOUSE_WORK\WORK_SHED\INCOMING_FILE_PARKING\MOVED_IGNORED_FILES_20260519_20260519_162022\02_TOOL_CANDIDATES"

$Checkers = @(
    "CHECK_ASSISTANT_HOME_MODEL_CARD_001.ps1",
    "CHECK_ASSISTANT_SUIT_OPERATING_SYSTEM_001.ps1",
    "CHECK_BRAIN_PROGRESS_LOCK_001.ps1",
    "CHECK_DUPLICATE_GUIDE_SURFACE_SYNC_001.ps1",
    "CHECK_FRESH_PUBLIC_ENTRY_TEST_001.ps1"
)

Write-Host ""
Write-Host "FAST SAFE CHECKER BATCH 001"
Write-Host "RepoRoot: $RepoRoot"

$Results = @()

foreach ($Name in $Checkers) {
    $Path = Join-Path $ToolDir $Name

    Write-Host ""
    Write-Host "===== RUNNING: $Name ====="

    if (-not (Test-Path $Path)) {
        Write-Host "MISSING - $Path"
        $Results += [pscustomobject]@{
            Checker = $Name
            ExitCode = "MISSING"
            Verdict = "MISSING"
        }
        continue
    }

    $OutputFile = Join-Path $env:TEMP ("mr_kleen_checker_" + [guid]::NewGuid().ToString() + ".txt")

    & pwsh -NoProfile -ExecutionPolicy Bypass -File $Path *> $OutputFile
    $ExitCode = $LASTEXITCODE

    Get-Content -LiteralPath $OutputFile

    $VerdictLine = Select-String -Path $OutputFile -Pattern "VERDICT:" | Select-Object -Last 1
    if ($VerdictLine) {
        $Verdict = $VerdictLine.Line
    } elseif ($ExitCode -eq 0) {
        $Verdict = "NO VERDICT / EXIT 0"
    } else {
        $Verdict = "NO VERDICT / EXIT $ExitCode"
    }

    Remove-Item -LiteralPath $OutputFile -Force -ErrorAction SilentlyContinue

    $Results += [pscustomobject]@{
        Checker = $Name
        ExitCode = $ExitCode
        Verdict = $Verdict
    }
}

Write-Host ""
Write-Host "===== BATCH RESULT TABLE ====="
$Results | Format-Table -AutoSize

$Failed = @($Results | Where-Object { $_.ExitCode -ne 0 -or $_.Verdict -notmatch "VERDICT: PASS" })

Write-Host ""
if ($Failed.Count -eq 0) {
    Write-Host "BATCH VERDICT: PASS"
    exit 0
} else {
    Write-Host "BATCH VERDICT: FAIL"
    exit 1
}
