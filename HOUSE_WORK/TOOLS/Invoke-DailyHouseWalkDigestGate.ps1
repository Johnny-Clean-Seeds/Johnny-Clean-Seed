param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-GitStrict {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $Output = & git @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Arguments -join ' ') failed with exit code $LASTEXITCODE. Output: $($Output -join ' ')"
    }
    return @($Output)
}

$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = (Resolve-Path (Join-Path $ToolDir "..\..")).Path
$OriginalLocation = (Get-Location).Path

try {
Set-Location $Root

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Daily digest gate must run from inside Mr.Kleen repo."
}

$Now = Get-Date
$TodayStamp = $Now.ToString("yyyyMMdd")
$WindowStart = Get-Date -Year $Now.Year -Month $Now.Month -Day $Now.Day -Hour 7 -Minute 0 -Second 0
$WindowEnd = Get-Date -Year $Now.Year -Month $Now.Month -Day $Now.Day -Hour 9 -Minute 30 -Second 0

$DailyLogDir = Join-Path $Root "HOUSE_WORK\DAILY_LOGS\HOUSE_WALK_DIGESTS"
$DailyLogDirExists = Test-Path -LiteralPath $DailyLogDir
if ($DailyLogDirExists) {
    $TodayLogs = @(Get-ChildItem -LiteralPath $DailyLogDir -File -ErrorAction Stop |
        Where-Object { $_.Name -like "DAILY_HOUSE_WALK_DIGEST_$TodayStamp*" })
} else {
    $TodayLogs = @()
}

$Near8Logs = @()
foreach ($Log in $TodayLogs) {
    $Text = Get-Content $Log.FullName -Raw
    if ($Text -match "Near-8 Digest:\s*YES") {
        $Near8Logs += $Log
    }
}

$Near8WindowNow = ($Now -ge $WindowStart -and $Now -le $WindowEnd)
$WindowPassed = ($Now -gt $WindowEnd)

if ($Near8Logs.Count -gt 0) {
    $Action = "SATISFIED - near-8 daily digest already exists. Do not self-initiate another daily digest unless user asks or a real event requires it."
} elseif ($Near8WindowNow) {
    $Action = "DUE_NOW - no near-8 digest exists and current time is near the daily window. Run and save the digest before new Mr.Kleen work unless blocked."
} elseif ($WindowPassed) {
    $Action = "MISSED_WINDOW_DUE_ON_CONTACT - no near-8 digest exists and the window has passed. Run and save one at first Mr.Kleen contact unless blocked."
} else {
    $Action = "NOT_YET_DUE - near-8 window has not arrived. Do not self-initiate unless user asks or a real event requires a walk."
}

$Branch = ((Invoke-GitStrict @("rev-parse", "--abbrev-ref", "HEAD")) -join "`n").Trim()
$Head = ((Invoke-GitStrict @("rev-parse", "--short", "HEAD")) -join "`n").Trim()
$Status = Invoke-GitStrict @("status", "--short")
$StatusText = if ([string]::IsNullOrWhiteSpace(($Status -join "`n"))) { "[clean]" } else { ($Status -join "; ") }

Write-Host "XxXxX ===== DAILY DIGEST BRAIN GATE START ===== XxXxX" -ForegroundColor Green
Write-Host "Inspection only: YES"
Write-Host "No timer: YES"
Write-Host "Current local time: $($Now.ToString("yyyy-MM-dd HH:mm:ss zzz"))"
Write-Host "Near-8 window: 07:00 through 09:30 local"
Write-Host "Today logs found: $($TodayLogs.Count)"
Write-Host "Near-8 digest logs found: $($Near8Logs.Count)"
Write-Host "Daily log dir exists: $DailyLogDirExists"
Write-Host "Repo position: $Branch @ $Head"
Write-Host "Git status: $StatusText"
Write-Host "Action: $Action"
Write-Host "XxXxX ===== DAILY DIGEST BRAIN GATE END ===== XxXxX" -ForegroundColor Green
} finally {
    Set-Location $OriginalLocation
}
