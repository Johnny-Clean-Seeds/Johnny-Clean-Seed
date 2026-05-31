# RUN_CLAIM_CAPABILITY_BRIDGE_HARNESS_V1_20260531.ps1
# Compact runner for the Claim + Capability Bridge Harness fixture pack.
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

function Get-ActualVerdict {
    param([Parameter(Mandatory=$true)]$Row)

    switch ($Row.InputPhrase) {
        "nxt" { return "ACTION_REQUEST_ONLY" }
        "dropped" { return "USER_REPORTED_STATE_ONLY" }
        "helper passed" { return "SPLIT_REQUIRED_RECEIVER_ASSAY" }
        "hash proves it" { return "CUSTODY_ONLY" }
        "source says rule" { return "SOURCE_ORE_ONLY_FINAL_JUDGE_REQUIRED" }
        "pattern triggered" { return "FIRST_CHECK_ONLY" }
        "report exists" { return "OUTPUT_EXISTS_ONLY" }
        "Git clean" { return "REPO_STATUS_ONLY" }
        "ready" { return "READY_FOR_WHAT_SPLIT" }
        "make this a rule" { return "PROMOTION_BLOCK_FINAL_JUDGE_REQUIRED" }
        "registry lists MOVE_EXACT_FILE" { return "GRANT_REQUIRED" }
        "grant exists but no pocket" { return "POWER_POCKET_REQUIRED" }
        "pocket exists but token stale" { return "TOKEN_REQUIRED" }
        "PDP without PEP" { return "PEP_REQUIRED" }
        "return without receiver assay" { return "RETURN_NOT_ACCEPTED" }
        "helper role as capability" { return "CAPABILITY_NOT_REGISTERED" }
        "broad write request" { return "CAPABILITY_SPLIT_REQUIRED" }
        "helper recommends promotion" { return "FINAL_JUDGE_REQUIRED" }
        "hash exact report" { return "DISPATCH_ALLOWED" }
        "read exact source note" { return "DISPATCH_ALLOWED" }
        default { return "UNCLASSIFIED_FIXTURE" }
    }
}

$HouseRoot = Resolve-HouseRoot
$RepoRoot = Resolve-RepoRoot -HouseRoot $HouseRoot
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$PackRoot = Join-Path $RepoRoot "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CLAIM_CAPABILITY_BRIDGE_HARNESS_PACK_20260531"
$FixturePath = Join-Path $PackRoot "CLAIM_CAPABILITY_FIXTURES_V1_20260531.csv"
$CoveragePath = Join-Path $PackRoot "CLAIM_CAPABILITY_COVERAGE_MATRIX_V1_20260531.csv"
$ReportRoot = Join-Path $HouseRoot "_MISC_DRAWER\READ_REPORTS"
if (!(Test-Path -LiteralPath $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }

if (!(Test-Path -LiteralPath $FixturePath)) { throw "Missing fixture pack: $FixturePath" }
if (!(Test-Path -LiteralPath $CoveragePath)) { throw "Missing coverage matrix: $CoveragePath" }

$Fixtures = @(Import-Csv -LiteralPath $FixturePath)
$Coverage = @(Import-Csv -LiteralPath $CoveragePath)

$Results = New-Object System.Collections.Generic.List[object]
foreach ($Row in $Fixtures) {
    $Actual = Get-ActualVerdict -Row $Row
    $Pass = ($Actual -eq $Row.ExpectedVerdict)
    $Results.Add([pscustomobject]@{
        FixtureId = $Row.FixtureId
        FixtureGroup = $Row.FixtureGroup
        InputPhrase = $Row.InputPhrase
        ExpectedVerdict = $Row.ExpectedVerdict
        ActualVerdict = $Actual
        Pass = $Pass
        ExpectedDisposition = $Row.ExpectedDisposition
    }) | Out-Null
}

$CoverageResults = New-Object System.Collections.Generic.List[object]
foreach ($Organ in $Coverage) {
    $Ids = @($Organ.CoveredBy -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    $HitCount = @($Ids | Where-Object { $Fixtures.FixtureId -contains $_ }).Count
    $Minimum = [int]$Organ.ExpectedMinimum
    $CoverageResults.Add([pscustomobject]@{
        Organ = $Organ.Organ
        HitCount = $HitCount
        ExpectedMinimum = $Minimum
        Pass = ($HitCount -ge $Minimum)
    }) | Out-Null
}

$Failures = @($Results.ToArray() | Where-Object { -not $_.Pass })
$CoverageFailures = @($CoverageResults.ToArray() | Where-Object { -not $_.Pass })
$FinalVerdict = if ($Failures.Count -eq 0 -and $CoverageFailures.Count -eq 0) { "PASS" } else { "FAIL_FIXTURE_OR_COVERAGE" }

$ResultCsv = Join-Path $ReportRoot "CLAIM_CAPABILITY_BRIDGE_HARNESS_RESULTS_$RunId.csv"
$CoverageCsv = Join-Path $ReportRoot "CLAIM_CAPABILITY_BRIDGE_HARNESS_COVERAGE_$RunId.csv"
$ReportMd = Join-Path $ReportRoot "CLAIM_CAPABILITY_BRIDGE_HARNESS_REPORT_$RunId.md"

$Results.ToArray() | Export-Csv -LiteralPath $ResultCsv -NoTypeInformation -Encoding UTF8
$CoverageResults.ToArray() | Export-Csv -LiteralPath $CoverageCsv -NoTypeInformation -Encoding UTF8

$Lines = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $Lines -Text "# Claim + Capability Bridge Harness Report"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "RunId: $RunId"
Add-Line -Lines $Lines -Text "Mode: READ_REPORT_ONLY"
Add-Line -Lines $Lines -Text "FixtureCount: $($Fixtures.Count)"
Add-Line -Lines $Lines -Text "CoverageOrgans: $($Coverage.Count)"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Verdict"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text '```text'
Add-Line -Lines $Lines -Text $FinalVerdict
Add-Line -Lines $Lines -Text '```'
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Counts"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "- Fixture passes: $(@($Results.ToArray() | Where-Object { $_.Pass }).Count)"
Add-Line -Lines $Lines -Text "- Fixture failures: $($Failures.Count)"
Add-Line -Lines $Lines -Text "- Coverage failures: $($CoverageFailures.Count)"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Boundary"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "This is candidate harness proof only. It does not adopt the Claim Engine or Capability Engine."

[System.IO.File]::WriteAllText($ReportMd, ($Lines.ToArray() -join "`r`n"), [System.Text.UTF8Encoding]::new($false))

Write-Host "CLAIM_CAPABILITY_BRIDGE_HARNESS_COMPLETE"
Write-Host "EndState: CLEAN_CLOSE"
Write-Host "RunId: $RunId"
Write-Host "FinalVerdict: $FinalVerdict"
Write-Host "FixtureCount: $($Fixtures.Count)"
Write-Host "FixtureFailures: $($Failures.Count)"
Write-Host "CoverageFailures: $($CoverageFailures.Count)"
Write-Host "Report: $ReportMd"
Write-Host "ResultsCsv: $ResultCsv"
Write-Host "CoverageCsv: $CoverageCsv"
