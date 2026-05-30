# CHECK_ROOT_LAYER_SKIPPED_ISSUE_HISTORY_V1_20260530.ps1
# Read/report audit for possible skipped lower-root issue history.
# Boundary: read/report only. No Git writes. No commit. No push. No delete. No move. No doctrine.

[CmdletBinding()]
param([int]$MaxTopFindings = 160)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Add-Line {
    param(
        [Parameter(Mandatory=$true, Position=0)][object]$Lines,
        [Parameter(Mandatory=$true, Position=1)][AllowEmptyString()][string]$Text
    )
    $Lines.Add($Text) | Out-Null
}

function Add-Finding {
    param(
        [Parameter(Mandatory=$true)][AllowEmptyCollection()][System.Collections.Generic.List[object]]$Findings,
        [Parameter(Mandatory=$true)][string]$Severity,
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Class,
        [Parameter(Mandatory=$true)][string]$Message
    )
    $Findings.Add([pscustomobject]@{
        Severity = $Severity
        Path = $Path
        Class = $Class
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
$StatusShort = @(& git -C $RepoRoot status --short)
$Tracked = @(& git -C $RepoRoot ls-files)
if ($LASTEXITCODE -ne 0) { throw "git ls-files failed." }

$Records = New-Object System.Collections.Generic.List[object]
$Findings = New-Object System.Collections.Generic.List[object]
$CandidatePathPattern = "ISSUE|ERROR|FAIL|BLOCK|SKIP|NO.?OP|HELPER|GATE|AUDIT|RUN_|LOCK_SAVE|CHECK_|INTAKE|ROOT|LOWER|POWERPLAY|REPAIR|RECEIPT|REPORT"

foreach ($Rel in $Tracked) {
    if ([string]::IsNullOrWhiteSpace($Rel)) { continue }
    if (!($Rel.ToUpperInvariant() -match $CandidatePathPattern)) { continue }

    $Full = Join-Path $RepoRoot ($Rel -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    if (!(Test-Path -LiteralPath $Full)) { continue }

    $Content = Read-TextSafe -Path $Full
    $Text = $Rel + "`n" + $Content
    $Sha = (Get-FileHash -Algorithm SHA256 -LiteralPath $Full).Hash

    $HasIssue = Has-Any -Text $Text -Patterns @("(?i)issue|failure|failed|blocker|error|nonzero|dirty|mismatch|missing path|missing source|skipped|skip-only|no-op")
    $HasLowerRoot = Has-Any -Text $Text -Patterns @("(?i)lower[- ]layer|lower[- ]level|root issue|root cause|cause even lower|route/tool/script|binding|environment|parser pass|runtime fail|one-object|many-object|empty collection|empty string|git ignored|target-not-run|helper output treated as authority|proof/report movement")
    $HasSeparation = Has-Any -Text $Text -Patterns @("(?i)upper object|lower object|separate|do not judge|freeze upper|repair the base|repair only the lower|drop one layer|source triage, not proof")
    $HasRuntimeProof = Has-Any -Text $Text -Patterns @("(?i)runtime|rerun|EndState: CLEAN_CLOSE|CLEAN_CLOSE|receipt|hash|HEAD|status --short|Code Gate|direct branch proof")
    $HasDisposition = Has-Any -Text $Text -Patterns @("(?i)confirmed|suspect|false positive|already handled|duplicate|stale|parked|out-of-scope|proof-only|superseded|return trigger")
    $MentionsParserOnly = Has-Any -Text $Text -Patterns @("(?i)parser pass|passed parser|syntax pass")
    $MentionsRuntime = Has-Any -Text $Text -Patterns @("(?i)runtime|rerun|direct run|live run|EndState")
    $MentionsNoOpCommitRisk = Has-Any -Text $Text -Patterns @("(?i)no-op.*commit|commit.*no-op|skipped-target commit|commit message truth")
    $HasNoOpGuard = Has-Any -Text $Text -Patterns @("(?i)No-op runs do not commit|NO-OP NO-COMMIT|no Git writes|no commit")

    $Class = "NOT_A_SKIPPED_LOWER_ROOT_SIGNAL"
    $Severity = "INFO"
    $Message = "No skipped lower-root signal detected by heuristic."

    if ($HasIssue -and $HasLowerRoot -and $HasSeparation -and $HasRuntimeProof) {
        $Class = "ALREADY_HANDLED_OR_RULE_SURFACE"
        $Message = "Lower-root issue pattern has separation and proof language."
    }
    elseif ($HasIssue -and $HasLowerRoot -and !$HasSeparation) {
        $Class = "POSSIBLE_SKIPPED_LOWER_ROOT_REVIEW"
        $Severity = "WATCH"
        $Message = "Issue mentions lower/root/tool failure language without clear upper/lower separation."
    }
    elseif ($HasIssue -and $MentionsParserOnly -and !$MentionsRuntime) {
        $Class = "PARSER_PASS_RUNTIME_PROOF_REVIEW"
        $Severity = "WATCH"
        $Message = "Parser/syntax signal appears without obvious runtime or rerun proof."
    }
    elseif ($HasIssue -and $MentionsNoOpCommitRisk -and !$HasNoOpGuard) {
        $Class = "NOOP_COMMIT_TRUTH_REVIEW"
        $Severity = "WATCH"
        $Message = "No-op/commit truth risk appears without obvious no-commit guard."
    }
    elseif ($HasIssue -and !$HasDisposition -and ($Rel -match "(?i)TODO|SORTING_BENCH|REPORT|RECEIPT")) {
        $Class = "MISSING_DISPOSITION_REVIEW"
        $Severity = "WATCH"
        $Message = "Issue-like artifact lacks obvious disposition or return trigger."
    }

    $Records.Add([pscustomobject]@{
        Path = $Rel
        SHA256 = $Sha
        HasIssueSignal = $HasIssue
        HasLowerRootSignal = $HasLowerRoot
        HasUpperLowerSeparation = $HasSeparation
        HasRuntimeOrRerunProof = $HasRuntimeProof
        HasDisposition = $HasDisposition
        VerdictClass = $Class
        Severity = $Severity
    }) | Out-Null

    if ($Severity -ne "INFO") {
        Add-Finding -Findings $Findings -Severity $Severity -Path $Rel -Class $Class -Message $Message
    }
}

$RecordsCsv = Join-Path $ReportRoot "ROOT_LAYER_SKIPPED_ISSUE_HISTORY_AUDIT_RECORDS_$RunId.csv"
$FindingsCsv = Join-Path $ReportRoot "ROOT_LAYER_SKIPPED_ISSUE_HISTORY_AUDIT_FINDINGS_$RunId.csv"
$ReportMd = Join-Path $ReportRoot "ROOT_LAYER_SKIPPED_ISSUE_HISTORY_AUDIT_REPORT_$RunId.md"

$Records.ToArray() | Export-Csv -LiteralPath $RecordsCsv -NoTypeInformation -Encoding UTF8
$Findings.ToArray() | Export-Csv -LiteralPath $FindingsCsv -NoTypeInformation -Encoding UTF8

$Reviewed = $Records.Count
$Handled = @($Records | Where-Object { $_.VerdictClass -eq "ALREADY_HANDLED_OR_RULE_SURFACE" }).Count
$Possible = @($Records | Where-Object { $_.VerdictClass -eq "POSSIBLE_SKIPPED_LOWER_ROOT_REVIEW" }).Count
$ParserOnly = @($Records | Where-Object { $_.VerdictClass -eq "PARSER_PASS_RUNTIME_PROOF_REVIEW" }).Count
$NoOp = @($Records | Where-Object { $_.VerdictClass -eq "NOOP_COMMIT_TRUTH_REVIEW" }).Count
$MissingDisposition = @($Records | Where-Object { $_.VerdictClass -eq "MISSING_DISPOSITION_REVIEW" }).Count
$WatchTotal = @($Findings | Where-Object { $_.Severity -eq "WATCH" }).Count

$Final = "PASS_WITH_WATCH"
if ($WatchTotal -eq 0) { $Final = "PASS" }

$Md = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $Md -Text "# Root-Layer Skipped Issue History Audit"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "RunId: $RunId"
Add-Line -Lines $Md -Text "Mode: READ_REPORT_ONLY"
Add-Line -Lines $Md -Text "Head: $Head"
Add-Line -Lines $Md -Text "StatusShortCount: $(@($StatusShort).Count)"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "## Verdict"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text '````text'
Add-Line -Lines $Md -Text $Final
Add-Line -Lines $Md -Text '````'
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "## Counts"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "- Records reviewed: $Reviewed"
Add-Line -Lines $Md -Text "- Already handled or rule surface: $Handled"
Add-Line -Lines $Md -Text "- Possible skipped lower-root review: $Possible"
Add-Line -Lines $Md -Text "- Parser-pass/runtime-proof review: $ParserOnly"
Add-Line -Lines $Md -Text "- No-op/commit-truth review: $NoOp"
Add-Line -Lines $Md -Text "- Missing disposition review: $MissingDisposition"
Add-Line -Lines $Md -Text "- Watch findings: $WatchTotal"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "## Top findings"
Add-Line -Lines $Md -Text ""
$Top = @($Findings | Select-Object -First $MaxTopFindings)
if ($Top.Count -eq 0) {
    Add-Line -Lines $Md -Text "No watch findings."
} else {
    foreach ($F in $Top) {
        Add-Line -Lines $Md -Text "- [$($F.Severity)] $($F.Path) :: $($F.Class) :: $($F.Message)"
    }
}
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "## Classification boundary"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "This helper does not repair records. It separates confirmed proof-bearing lower-root surfaces from watch-only suspects that need human/assistant review."
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "## Outputs"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "- Records CSV: $RecordsCsv"
Add-Line -Lines $Md -Text "- Findings CSV: $FindingsCsv"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "## Boundary"
Add-Line -Lines $Md -Text ""
Add-Line -Lines $Md -Text "Read/report only. No Git writes. No commit. No push. No delete. No move. No doctrine."
[System.IO.File]::WriteAllText($ReportMd, ($Md -join "`r`n"), [System.Text.UTF8Encoding]::new($false))

Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
Write-Host "ROOT_LAYER_SKIPPED_ISSUE_HISTORY_AUDIT_COMPLETE"
Write-Host "EndState: CLEAN_CLOSE"
Write-Host "RunId: $RunId"
Write-Host "Head: $Head"
Write-Host "FinalVerdict: $Final"
Write-Host "RecordsReviewed: $Reviewed"
Write-Host "AlreadyHandledOrRuleSurface: $Handled"
Write-Host "PossibleSkippedLowerRootReview: $Possible"
Write-Host "ParserPassRuntimeProofReview: $ParserOnly"
Write-Host "NoOpCommitTruthReview: $NoOp"
Write-Host "MissingDispositionReview: $MissingDisposition"
Write-Host "WatchFindings: $WatchTotal"
Write-Host "Report: $ReportMd"
Write-Host "RecordsCsv: $RecordsCsv"
Write-Host "FindingsCsv: $FindingsCsv"
Write-Host "BoundaryHeld: read/report only; no Git writes; no commit; no push; no delete; no move; no doctrine."
Write-Host "NextCleanMove: classify watch rows before creating any repair wave."
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"
