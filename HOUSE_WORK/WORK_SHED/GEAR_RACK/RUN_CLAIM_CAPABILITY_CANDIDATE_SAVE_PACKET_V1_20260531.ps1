# RUN_CLAIM_CAPABILITY_CANDIDATE_SAVE_PACKET_V1_20260531.ps1
# Verifier for the Claim + Capability Candidate Save Packet.
# Boundary: read/report only. No Git writes. No commit. No push. No delete. No move. No doctrine.

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Add-Line {
    param(
        [Parameter(Mandatory=$true)][object]$Lines,
        [Parameter(Mandatory=$true)][AllowEmptyString()][string]$Text
    )
    $Lines.Add($Text) | Out-Null
}

function Resolve-HouseRoot {
    $Path = Join-Path $env:USERPROFILE "Desktop\123"
    if (Test-Path -LiteralPath $Path) { return (Resolve-Path -LiteralPath $Path).Path }
    throw "Missing house root: $Path"
}

function Resolve-RepoRoot {
    param([Parameter(Mandatory=$true)][string]$HouseRoot)
    $Candidate = Join-Path $HouseRoot "Jxhnny_Kl33N_Seedz"
    if (Test-Path -LiteralPath (Join-Path $Candidate ".git")) { return (Resolve-Path -LiteralPath $Candidate).Path }
    throw "Missing repo root: $Candidate"
}

function Resolve-ItemPath {
    param(
        [Parameter(Mandatory=$true)][string]$RepoRoot,
        [Parameter(Mandatory=$true)]$Row
    )

    if ($Row.LocationType -eq "REPO") {
        return Join-Path $RepoRoot ($Row.Path -replace "/", "\")
    }
    return $Row.Path
}

$HouseRoot = Resolve-HouseRoot
$RepoRoot = Resolve-RepoRoot -HouseRoot $HouseRoot
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$PackRoot = Join-Path $RepoRoot "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CLAIM_CAPABILITY_CANDIDATE_SAVE_PACKET_20260531"
$ItemsPath = Join-Path $PackRoot "CLAIM_CAPABILITY_CANDIDATE_SAVE_PACKET_ITEMS_V1_20260531.csv"
$ReportRoot = Join-Path $HouseRoot "_MISC_DRAWER\READ_REPORTS"
if (!(Test-Path -LiteralPath $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }

if (!(Test-Path -LiteralPath $ItemsPath)) { throw "Missing packet items: $ItemsPath" }

$Items = @(Import-Csv -LiteralPath $ItemsPath)
$Results = New-Object System.Collections.Generic.List[object]

foreach ($Row in $Items) {
    $Path = Resolve-ItemPath -RepoRoot $RepoRoot -Row $Row
    $Exists = Test-Path -LiteralPath $Path
    $HashPass = $true
    $SignalPass = $false
    $ActualHash = ""

    if ($Exists) {
        if (![string]::IsNullOrWhiteSpace($Row.SHA256)) {
            $ActualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
            $HashPass = ($ActualHash -eq $Row.SHA256)
        }
        if (![string]::IsNullOrWhiteSpace($Row.RequiredSignal)) {
            $SignalPass = [System.IO.File]::ReadAllText($Path).Contains($Row.RequiredSignal)
        } else {
            $SignalPass = $true
        }
    }

    $Results.Add([pscustomobject]@{
        ItemKey = $Row.ItemKey
        ItemType = $Row.ItemType
        LocationType = $Row.LocationType
        Exists = $Exists
        HashPass = $HashPass
        SignalPass = $SignalPass
        ActualHash = $ActualHash
        Path = $Row.Path
    }) | Out-Null
}

$BridgeReport = Join-Path $HouseRoot "_MISC_DRAWER\READ_REPORTS\CLAIM_CAPABILITY_BRIDGE_HARNESS_REPORT_20260531_040120.md"
$LiveReplayReport = Join-Path $HouseRoot "_MISC_DRAWER\READ_REPORTS\CLAIM_CAPABILITY_LIVE_REPLAY_REPORT_20260531_040120.md"
$BridgeText = [System.IO.File]::ReadAllText($BridgeReport)
$LiveReplayText = [System.IO.File]::ReadAllText($LiveReplayReport)

$BridgePass = (
    $BridgeText.Contains("PASS") -and
    $BridgeText.Contains("FixtureCount: 20") -and
    $BridgeText.Contains("Fixture failures: 0") -and
    $BridgeText.Contains("Coverage failures: 0")
)
$LiveReplayPass = (
    $LiveReplayText.Contains("PASS") -and
    $LiveReplayText.Contains("ReplayCount: 2") -and
    $LiveReplayText.Contains("Replay failures: 0")
)

$Failures = @($Results.ToArray() | Where-Object { -not ($_.Exists -and $_.HashPass -and $_.SignalPass) })
$FinalVerdict = if ($Failures.Count -eq 0 -and $BridgePass -and $LiveReplayPass) { "PASS" } else { "FAIL_PACKET" }

$ResultCsv = Join-Path $ReportRoot "CLAIM_CAPABILITY_CANDIDATE_SAVE_PACKET_RESULTS_$RunId.csv"
$ReportMd = Join-Path $ReportRoot "CLAIM_CAPABILITY_CANDIDATE_SAVE_PACKET_REPORT_$RunId.md"

$Results.ToArray() | Export-Csv -LiteralPath $ResultCsv -NoTypeInformation -Encoding UTF8

$Lines = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $Lines -Text "# Claim + Capability Candidate Save Packet Report"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "RunId: $RunId"
Add-Line -Lines $Lines -Text "Mode: READ_REPORT_ONLY"
Add-Line -Lines $Lines -Text "ItemCount: $($Items.Count)"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Verdict"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text '```text'
Add-Line -Lines $Lines -Text $FinalVerdict
Add-Line -Lines $Lines -Text '```'
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Counts"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "- Item passes: $(@($Results.ToArray() | Where-Object { $_.Exists -and $_.HashPass -and $_.SignalPass }).Count)"
Add-Line -Lines $Lines -Text "- Item failures: $($Failures.Count)"
Add-Line -Lines $Lines -Text "- Bridge report pass: $BridgePass"
Add-Line -Lines $Lines -Text "- Live replay report pass: $LiveReplayPass"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Boundary"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "This verifies candidate packet support only. It does not adopt the Claim Engine or Capability Engine."

[System.IO.File]::WriteAllText($ReportMd, ($Lines.ToArray() -join "`r`n"), [System.Text.UTF8Encoding]::new($false))

Write-Host "CLAIM_CAPABILITY_CANDIDATE_SAVE_PACKET_COMPLETE"
Write-Host "EndState: CLEAN_CLOSE"
Write-Host "RunId: $RunId"
Write-Host "FinalVerdict: $FinalVerdict"
Write-Host "ItemCount: $($Items.Count)"
Write-Host "ItemFailures: $($Failures.Count)"
Write-Host "BridgeReportPass: $BridgePass"
Write-Host "LiveReplayReportPass: $LiveReplayPass"
Write-Host "Report: $ReportMd"
Write-Host "ResultsCsv: $ResultCsv"
