# CHECK_INTAKE_GATE_KEY_HASH_JOIN_V1_20260530.ps1
# Read/report audit for Intake Gate keying and hash-to-receipt joins.
# Boundary: read/report only. No Git writes. No commit. No push. No delete. No move. No doctrine.

[CmdletBinding()]
param([switch]$Strict, [int]$MaxTopFindings = 120)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Add-Line {
    param(
        [Parameter(Mandatory=$true)][AllowEmptyCollection()][System.Collections.Generic.List[string]]$Lines,
        [Parameter(Mandatory=$true)][AllowEmptyString()][string]$Text
    )
    $Lines.Add($Text) | Out-Null
}

function Add-Finding {
    param(
        [Parameter(Mandatory=$true)][AllowEmptyCollection()][System.Collections.Generic.List[object]]$Findings,
        [Parameter(Mandatory=$true)][string]$Severity,
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Field,
        [Parameter(Mandatory=$true)][string]$Message
    )
    $Findings.Add([pscustomobject]@{
        Severity = $Severity
        Path = $Path
        Field = $Field
        Message = $Message
    }) | Out-Null
}

function Resolve-HouseRoot {
    $Path = Join-Path $env:USERPROFILE "Desktop\123"
    if (Test-Path -LiteralPath $Path) { return (Resolve-Path -LiteralPath $Path).Path }
    throw "Missing house root: $Path"
}

function Resolve-RepoRoot {
    param([Parameter(Mandatory=$true)][string]$HouseRoot)
    $Candidates = @((Join-Path $HouseRoot "Jxhnny_Kl33N_Seedz"), (Get-Location).Path)
    foreach ($Candidate in $Candidates) {
        if ($Candidate -and (Test-Path -LiteralPath (Join-Path $Candidate ".git"))) {
            return (Resolve-Path -LiteralPath $Candidate).Path
        }
    }
    throw "Missing repo root."
}

function Read-TextSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    try { return [System.IO.File]::ReadAllText($Path) } catch { return "" }
}

function Has-Any {
    param(
        [Parameter(Mandatory=$true)][AllowEmptyString()][string]$Text,
        [Parameter(Mandatory=$true)][string[]]$Patterns
    )
    foreach ($Pattern in $Patterns) {
        if ($Text -match $Pattern) { return $true }
    }
    return $false
}

$HouseRoot = Resolve-HouseRoot
$RepoRoot = Resolve-RepoRoot -HouseRoot $HouseRoot
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$ReportRoot = Join-Path $HouseRoot "_MISC_DRAWER\READ_REPORTS"
if (!(Test-Path -LiteralPath $ReportRoot)) { New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null }

$Head = (& git -C $RepoRoot rev-parse HEAD).Trim()
$Tracked = @(& git -C $RepoRoot ls-files)
if ($LASTEXITCODE -ne 0) { throw "git ls-files failed." }

$Records = New-Object System.Collections.Generic.List[object]
$Findings = New-Object System.Collections.Generic.List[object]

foreach ($Rel in $Tracked) {
    if ([string]::IsNullOrWhiteSpace($Rel)) { continue }
    $Upper = $Rel.ToUpperInvariant()
    if (!($Upper -match "INTAKE|LIVING_OBJECT|TRUE_PATHING|ORGANIC_PATHING|HASH_TO_RECEIPT|KEY_HASH|REPAIR_WAVE|PROTOCOL_STACK")) { continue }

    $Full = Join-Path $RepoRoot ($Rel -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    if (!(Test-Path -LiteralPath $Full)) { continue }

    $Content = Read-TextSafe -Path $Full
    $Text = $Rel + "`n" + $Content
    $Sha = (Get-FileHash -Algorithm SHA256 -LiteralPath $Full).Hash

    $HasKey = Has-Any -Text $Text -Patterns @("(?i)WorkKey:|Key tag|Key tags|controlled key|Tag Forge|TAG =|KEY =|Registry key")
    $HasHash = Has-Any -Text $Text -Patterns @("(?i)SHA256|Hash|Fixity|Manifest|BagIt")
    $HasReceiptPurpose = Has-Any -Text $Text -Patterns @("(?i)Receipt|Proof pointer|What hash proves|what hash does not prove|hash-to-receipt|Hash-to-Receipt|Proof purpose")
    $HasRoute = Has-Any -Text $Text -Patterns @("(?i)Route|Map|Ledger|Relation|Tunnel|Bridge|Return path|Route index")
    $HasBoundary = Has-Any -Text $Text -Patterns @("(?i)Boundary|not doctrine|no ACTIVE_GUIDES|no CURRENT_TRUTH_INDEX|Forbidden|Do not")
    $HasReturn = Has-Any -Text $Text -Patterns @("(?i)Return path|Next clean move|Next condition|Return trigger|Re-audit|Compare")
    $HasCurrentness = Has-Any -Text $Text -Patterns @("(?i)Currentness|CURRENT_|FRESH_CANDIDATE|PROOF_ONLY|SOURCE_ORE|Disposition|SUPERSEDED|PARKED")
    $HasNoOp = Has-Any -Text $Text -Patterns @("(?i)No-Op|NO-OP|RepairedTargets\s*==\s*0|Skip-Only|SkippedTargets|Commit Message Truth|Rerun Safety")
    $HasReportGuard = Has-Any -Text $Text -Patterns @("(?i)AllowEmptyCollection|AllowEmptyString|@\(|Array Normalization|Report Writer Binding")

    $Warn = 0
    $Block = 0

    if (!$HasKey) {
        $Severity = if ($Strict) { "BLOCKER_ADJACENT_REVIEW" } else { "WATCH" }
        Add-Finding -Findings $Findings -Severity $Severity -Path $Rel -Field "Keying" -Message "Missing obvious controlled key/tag/WorkKey marker."
        if ($Strict) { $Block++ } else { $Warn++ }
    }
    if (!$HasHash) {
        Add-Finding -Findings $Findings -Severity "BLOCKER_ADJACENT_REVIEW" -Path $Rel -Field "Hash" -Message "Missing obvious hash/fixity/manifest marker."
        $Block++
    }
    if (!$HasReceiptPurpose) {
        Add-Finding -Findings $Findings -Severity "WATCH" -Path $Rel -Field "HashToReceiptPurpose" -Message "Hash/proof relationship may lack receipt/purpose/exclusion language."
        $Warn++
    }
    if (!$HasRoute) {
        Add-Finding -Findings $Findings -Severity "WATCH" -Path $Rel -Field "RouteLedgerMap" -Message "Missing obvious route/ledger/map/relation marker."
        $Warn++
    }
    if (!$HasBoundary) {
        Add-Finding -Findings $Findings -Severity "WATCH" -Path $Rel -Field "Boundary" -Message "Missing obvious boundary/not-doctrine marker."
        $Warn++
    }
    if (!$HasReturn) {
        Add-Finding -Findings $Findings -Severity "WATCH" -Path $Rel -Field "Return" -Message "Missing obvious return/next condition."
        $Warn++
    }
    if (!$HasCurrentness) {
        Add-Finding -Findings $Findings -Severity "WATCH" -Path $Rel -Field "CurrentnessDisposition" -Message "Missing obvious currentness/disposition marker."
        $Warn++
    }

    $Verdict = "PASS"
    if ($Block -gt 0) { $Verdict = "BLOCKER_ADJACENT_REVIEW" }
    elseif ($Warn -gt 0) { $Verdict = "WATCH" }

    $Records.Add([pscustomobject]@{
        Path = $Rel
        SHA256 = $Sha
        HasKeying = $HasKey
        HasHash = $HasHash
        HasReceiptPurpose = $HasReceiptPurpose
        HasRouteLedgerMap = $HasRoute
        HasBoundary = $HasBoundary
        HasReturn = $HasReturn
        HasCurrentnessDisposition = $HasCurrentness
        HasNoOpGuard = $HasNoOp
        HasReportWriterGuard = $HasReportGuard
        Verdict = $Verdict
        WarnCount = $Warn
        BlockCount = $Block
    }) | Out-Null
}

$RecordsCsv = Join-Path $ReportRoot "INTAKE_GATE_KEY_HASH_JOIN_AUDIT_RECORDS_$RunId.csv"
$FindingsCsv = Join-Path $ReportRoot "INTAKE_GATE_KEY_HASH_JOIN_AUDIT_FINDINGS_$RunId.csv"
$ReportMd = Join-Path $ReportRoot "INTAKE_GATE_KEY_HASH_JOIN_AUDIT_REPORT_$RunId.md"

$Records | Export-Csv -LiteralPath $RecordsCsv -NoTypeInformation -Encoding UTF8
$Findings | Export-Csv -LiteralPath $FindingsCsv -NoTypeInformation -Encoding UTF8

$Pass = @($Records | Where-Object { $_.Verdict -eq "PASS" }).Count
$Watch = @($Records | Where-Object { $_.Verdict -eq "WATCH" }).Count
$Blocker = @($Records | Where-Object { $_.Verdict -eq "BLOCKER_ADJACENT_REVIEW" }).Count
$WatchFindings = @($Findings | Where-Object { $_.Severity -eq "WATCH" }).Count
$BlockFindings = @($Findings | Where-Object { $_.Severity -like "BLOCK*" }).Count

$Final = "PASS"
if ($Blocker -gt 0 -or $BlockFindings -gt 0) { $Final = "BLOCKER_ADJACENT_REVIEW" }
elseif ($Watch -gt 0 -or $WatchFindings -gt 0) { $Final = "PASS_WITH_WATCH" }

$Md = New-Object System.Collections.Generic.List[string]
Add-Line $Md "# Intake Gate Key / Hash Join Audit Report"
Add-Line $Md ""
Add-Line $Md "RunId: $RunId"
Add-Line $Md "Mode: READ_REPORT_ONLY"
Add-Line $Md "Head: $Head"
Add-Line $Md ""
Add-Line $Md "## Verdict"
Add-Line $Md ""
Add-Line $Md "````text"
Add-Line $Md $Final
Add-Line $Md "````"
Add-Line $Md ""
Add-Line $Md "## Counts"
Add-Line $Md ""
Add-Line $Md "- Records: $($Records.Count)"
Add-Line $Md "- PASS: $Pass"
Add-Line $Md "- WATCH: $Watch"
Add-Line $Md "- BLOCKER_ADJACENT_REVIEW: $Blocker"
Add-Line $Md "- WATCH findings: $WatchFindings"
Add-Line $Md "- BLOCK findings: $BlockFindings"
Add-Line $Md ""
Add-Line $Md "## Top findings"
Add-Line $Md ""
$Top = @($Findings | Select-Object -First $MaxTopFindings)
if ($Top.Count -eq 0) {
    Add-Line $Md "No findings."
} else {
    foreach ($F in $Top) {
        Add-Line $Md "- [$($F.Severity)] $($F.Path) :: $($F.Field) :: $($F.Message)"
    }
}
Add-Line $Md ""
Add-Line $Md "## Outputs"
Add-Line $Md ""
Add-Line $Md "- Records CSV: $RecordsCsv"
Add-Line $Md "- Findings CSV: $FindingsCsv"
Add-Line $Md ""
Add-Line $Md "## Boundary"
Add-Line $Md ""
Add-Line $Md "Read/report only. No Git writes. No commit. No push. No delete. No move. No doctrine."
[System.IO.File]::WriteAllText($ReportMd, ($Md -join "`r`n"), [System.Text.UTF8Encoding]::new($false))

Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
Write-Host "INTAKE_GATE_KEY_HASH_JOIN_AUDIT_COMPLETE"
Write-Host "EndState: CLEAN_CLOSE"
Write-Host "RunId: $RunId"
Write-Host "Head: $Head"
Write-Host "FinalVerdict: $Final"
Write-Host "Records: $($Records.Count)"
Write-Host "Pass: $Pass"
Write-Host "Watch: $Watch"
Write-Host "BlockerAdjacentReview: $Blocker"
Write-Host "WatchFindings: $WatchFindings"
Write-Host "BlockFindings: $BlockFindings"
Write-Host "Report: $ReportMd"
Write-Host "RecordsCsv: $RecordsCsv"
Write-Host "FindingsCsv: $FindingsCsv"
Write-Host "BoundaryHeld: read/report only; no Git writes; no commit; no push; no delete; no move; no doctrine."
Write-Host "NextCleanMove: Repair only named Intake Gate key/hash gaps if needed."
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"
