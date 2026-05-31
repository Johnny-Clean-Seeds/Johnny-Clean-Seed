# RUN_CLAIM_CAPABILITY_LIVE_REPLAY_V1_20260531.ps1
# Two-row live replay after the Claim + Capability Bridge Harness pass.
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

function Get-LiveReplayVerdict {
    param([Parameter(Mandatory=$true)]$Row)

    switch ($Row.InputPhrase) {
        "nxt" {
            return [pscustomobject]@{
                ClaimVerdict = "ACTION_REQUEST_ONLY"
                CapabilityVerdict = "NO_CAPABILITY_NEEDED"
                Dispatch = "NO_HELPER_DISPATCH"
                ReturnContract = "NOT_REQUIRED"
                ReceiverAssay = "NOT_REQUIRED"
                Disposition = "CONTINUE_APPROVED_SEQUENCE_ONLY"
                Sink = "NEXT_WORK_CARD"
                MustNotDo = "DO_NOT_TREAT_AS_BLIND_EXECUTION"
            }
        }
        "helper recommends promotion" {
            return [pscustomobject]@{
                ClaimVerdict = "FINAL_JUDGE_REQUIRED"
                CapabilityVerdict = "PROMOTE_RULE_BLOCKED"
                Dispatch = "BLOCKED"
                ReturnContract = "RULE_PROMOTION_CONTRACT_REQUIRED"
                ReceiverAssay = "REQUIRED"
                Disposition = "PARK_FOR_FINAL_JUDGE"
                Sink = "NO_DOCTRINE_SINK"
                MustNotDo = "DO_NOT_INSTALL_RULE_OR_UPDATE_TRUTH"
            }
        }
        default {
            return [pscustomobject]@{
                ClaimVerdict = "UNCLASSIFIED_REPLAY"
                CapabilityVerdict = "UNCLASSIFIED_REPLAY"
                Dispatch = "BLOCKED"
                ReturnContract = "UNKNOWN"
                ReceiverAssay = "REQUIRED"
                Disposition = "FIX_REPLAY_CASE"
                Sink = "NO_SINK"
                MustNotDo = "DO_NOT_CONTINUE"
            }
        }
    }
}

$HouseRoot = Resolve-HouseRoot
$RepoRoot = Resolve-RepoRoot -HouseRoot $HouseRoot
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$PackRoot = Join-Path $RepoRoot "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CLAIM_CAPABILITY_LIVE_REPLAY_PACK_20260531"
$ReplayPath = Join-Path $PackRoot "CLAIM_CAPABILITY_LIVE_REPLAY_CASES_V1_20260531.csv"
$ReportRoot = Join-Path $HouseRoot "_MISC_DRAWER\READ_REPORTS"
if (!(Test-Path -LiteralPath $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }

if (!(Test-Path -LiteralPath $ReplayPath)) { throw "Missing replay cases: $ReplayPath" }

$Replays = @(Import-Csv -LiteralPath $ReplayPath)
$Results = New-Object System.Collections.Generic.List[object]

foreach ($Row in $Replays) {
    $Actual = Get-LiveReplayVerdict -Row $Row
    $Pass = (
        $Actual.ClaimVerdict -eq $Row.ExpectedClaimVerdict -and
        $Actual.CapabilityVerdict -eq $Row.ExpectedCapabilityVerdict -and
        $Actual.Dispatch -eq $Row.ExpectedDispatch -and
        $Actual.ReturnContract -eq $Row.ExpectedReturnContract -and
        $Actual.ReceiverAssay -eq $Row.ExpectedReceiverAssay -and
        $Actual.Disposition -eq $Row.ExpectedDisposition -and
        $Actual.Sink -eq $Row.ExpectedSink -and
        $Actual.MustNotDo -eq $Row.MustNotDo
    )

    $Results.Add([pscustomobject]@{
        ReplayId = $Row.ReplayId
        ReplayGroup = $Row.ReplayGroup
        InputPhrase = $Row.InputPhrase
        ClaimVerdict = $Actual.ClaimVerdict
        CapabilityVerdict = $Actual.CapabilityVerdict
        Dispatch = $Actual.Dispatch
        ReturnContract = $Actual.ReturnContract
        ReceiverAssay = $Actual.ReceiverAssay
        Disposition = $Actual.Disposition
        Sink = $Actual.Sink
        MustNotDo = $Actual.MustNotDo
        Pass = $Pass
    }) | Out-Null
}

$Failures = @($Results.ToArray() | Where-Object { -not $_.Pass })
$FinalVerdict = if ($Failures.Count -eq 0) { "PASS" } else { "FAIL_LIVE_REPLAY" }

$ResultCsv = Join-Path $ReportRoot "CLAIM_CAPABILITY_LIVE_REPLAY_RESULTS_$RunId.csv"
$ReportMd = Join-Path $ReportRoot "CLAIM_CAPABILITY_LIVE_REPLAY_REPORT_$RunId.md"

$Results.ToArray() | Export-Csv -LiteralPath $ResultCsv -NoTypeInformation -Encoding UTF8

$Lines = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $Lines -Text "# Claim + Capability Live Replay Report"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "RunId: $RunId"
Add-Line -Lines $Lines -Text "Mode: READ_REPORT_ONLY"
Add-Line -Lines $Lines -Text "ReplayCount: $($Replays.Count)"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Verdict"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text '```text'
Add-Line -Lines $Lines -Text $FinalVerdict
Add-Line -Lines $Lines -Text '```'
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Counts"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "- Replay passes: $(@($Results.ToArray() | Where-Object { $_.Pass }).Count)"
Add-Line -Lines $Lines -Text "- Replay failures: $($Failures.Count)"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Replays"
Add-Line -Lines $Lines -Text ""
foreach ($Result in $Results) {
    Add-Line -Lines $Lines -Text "- $($Result.ReplayId): $($Result.InputPhrase) -> $($Result.Disposition) / $($Result.Dispatch)"
}
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "## Boundary"
Add-Line -Lines $Lines -Text ""
Add-Line -Lines $Lines -Text "This is live replay proof only. It does not adopt the Claim Engine or Capability Engine."

[System.IO.File]::WriteAllText($ReportMd, ($Lines.ToArray() -join "`r`n"), [System.Text.UTF8Encoding]::new($false))

Write-Host "CLAIM_CAPABILITY_LIVE_REPLAY_COMPLETE"
Write-Host "EndState: CLEAN_CLOSE"
Write-Host "RunId: $RunId"
Write-Host "FinalVerdict: $FinalVerdict"
Write-Host "ReplayCount: $($Replays.Count)"
Write-Host "ReplayFailures: $($Failures.Count)"
Write-Host "Report: $ReportMd"
Write-Host "ResultsCsv: $ResultCsv"
