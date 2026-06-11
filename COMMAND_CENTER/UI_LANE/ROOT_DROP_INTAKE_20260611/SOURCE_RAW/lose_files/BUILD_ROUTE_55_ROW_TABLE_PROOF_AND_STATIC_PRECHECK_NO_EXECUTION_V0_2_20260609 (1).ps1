<#
ROUTE 55 ROW TABLE PROOF + STATIC PRECHECK — NO EXECUTION
Status: LOCAL_RUNNER / READ_ONLY_SOURCE_SCAN / STATIC_REVIEW_ONLY / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH

Official gate preserved exactly:
  USER_DECISION_REQUIRED_ROUTE_55_CANDIDATES_OR_HOLD

Gate-name correction:
  Do not rename the active gate to ROUTE_55_EXECUTOR_PRECHECK_OR_HOLD_DECISION.
  That phrase is only a descriptive next-work label, not an official gate name.

Purpose:
  Resume the Route 55 work from the known blocker: exact 55-row proof is required before any executor run.
  This runner searches the local project for route-plan/selector CSV evidence, builds a 55-row no-execution action table,
  preserves the 3 held rows, verifies source hashes/sizes, destination parent state, collision state, and writes reports.

This script writes report artifacts only. It does NOT move, delete, rename, route, execute helpers, commit, or push.
#>

[CmdletBinding()]
param(
    [string]$RootPath = (Join-Path $env:USERPROFILE 'Desktop\123'),
    [string]$OutputDir = (Join-Path $env:USERPROFILE 'Downloads\ROUTE_55_STATIC_PRECHECK_OUTPUT_20260609'),
    [string]$RoutePlanCsv = '',
    [switch]$AllowComputedShaWhenDeclaredMissing
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptName = 'BUILD_ROUTE_55_ROW_TABLE_PROOF_AND_STATIC_PRECHECK_NO_EXECUTION_V0_2_20260609.ps1'
$OfficialGate = 'USER_DECISION_REQUIRED_ROUTE_55_CANDIDATES_OR_HOLD'
$DescriptiveNextWorkLabel = 'contract-first Route 55 executor/precheck package for the 55 candidates only'
$ForbiddenGateRename = 'ROUTE_55_EXECUTOR_PRECHECK_OR_HOLD_DECISION'
$RunStamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$HardBlockedActions = @('move','delete','rename','route','cleanup','execute_helpers','commit','push')
$HeldRows = @(
    [pscustomobject]@{
        HoldID = 'HOLD-001'
        FileName = 'BUILD_ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608_HEAVY_BOUNDARY_BINDING_FIX_V0_2.ps1'
        RequiredDisposition = 'CURRENT_RUNNER_NO_ROUTE'
    },
    [pscustomobject]@{
        HoldID = 'HOLD-002'
        FileName = 'desktop.ini'
        RequiredDisposition = 'LEAVE_IN_PLACE'
    },
    [pscustomobject]@{
        HoldID = 'HOLD-003'
        FileName = 'HUMAN_ACCEPTANCE_DECISION__HELPER_EXPOSURE_33RD_PROTOCOL_FIRST_LIVE_USE_TEST_20260606.md'
        RequiredDisposition = 'ZERO_BYTE_REVIEW_NO_DELETE'
    }
)

function New-List {
    return [System.Collections.Generic.List[string]]::new()
}

$ReportLines = New-List
$Blockers = New-List
$Watch = New-List
$EvidenceLines = New-List

function Add-Line {
    param(
        [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Lines,
        [AllowEmptyString()][string]$Text
    )
    [void]$Lines.Add($Text)
}

function Add-Blocker {
    param([string]$Text)
    [void]$script:Blockers.Add($Text)
}

function Add-Watch {
    param([string]$Text)
    [void]$script:Watch.Add($Text)
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$LiteralPath)
    if (-not (Test-Path -LiteralPath $LiteralPath -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $LiteralPath -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Get-FileSizeBytes {
    param([Parameter(Mandatory=$true)][string]$LiteralPath)
    if (-not (Test-Path -LiteralPath $LiteralPath -PathType Leaf)) { return '' }
    return ([System.IO.FileInfo]$LiteralPath).Length
}

function Normalize-Text {
    param($Value)
    if ($null -eq $Value) { return '' }
    return ([string]$Value).Trim()
}

function Get-ColumnNames {
    param($Row)
    if ($null -eq $Row) { return @() }
    return @($Row.PSObject.Properties.Name)
}

function Get-FirstColumnName {
    param(
        [string[]]$Available,
        [string[]]$Wanted
    )
    foreach ($want in $Wanted) {
        foreach ($got in $Available) {
            if ($got -ieq $want) { return $got }
        }
    }
    foreach ($want in $Wanted) {
        foreach ($got in $Available) {
            if ($got -match [regex]::Escape($want)) { return $got }
        }
    }
    return ''
}

function Get-RowValue {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [string[]]$Names
    )
    $cols = Get-ColumnNames -Row $Row
    $col = Get-FirstColumnName -Available $cols -Wanted $Names
    if ([string]::IsNullOrWhiteSpace($col)) { return '' }
    return Normalize-Text $Row.$col
}

function Test-HeldFileName {
    param([string]$FileName)
    foreach ($h in $script:HeldRows) {
        if ($FileName -ieq $h.FileName) { return $true }
    }
    return $false
}

function Test-UnderPath {
    param(
        [string]$ChildPath,
        [string]$ParentPath
    )
    if ([string]::IsNullOrWhiteSpace($ChildPath) -or [string]::IsNullOrWhiteSpace($ParentPath)) { return $false }
    try {
        $childFull = [System.IO.Path]::GetFullPath($ChildPath)
        $parentFull = [System.IO.Path]::GetFullPath($ParentPath)
        if (-not $parentFull.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
            $parentFull = $parentFull + [System.IO.Path]::DirectorySeparatorChar
        }
        return $childFull.StartsWith($parentFull, [System.StringComparison]::OrdinalIgnoreCase)
    } catch {
        return $false
    }
}

function Resolve-SourcePath {
    param($Row, [string]$FileName)
    $source = Get-RowValue -Row $Row -Names @('SourcePath','CurrentPath','ObservedPath','Path','FullName','LiteralPath')
    if (-not [string]::IsNullOrWhiteSpace($source)) {
        if ([System.IO.Path]::IsPathRooted($source)) { return $source }
        return (Join-Path $RootPath $source)
    }
    if (-not [string]::IsNullOrWhiteSpace($FileName)) {
        return (Join-Path $RootPath $FileName)
    }
    return ''
}

function Resolve-DestinationPath {
    param($Row, [string]$FileName)
    $dest = Get-RowValue -Row $Row -Names @('PlannedDestinationPath','DestinationPath','ProposedDestinationPath','RouteDestinationPath','TargetPath')
    if (-not [string]::IsNullOrWhiteSpace($dest)) {
        if ([System.IO.Path]::IsPathRooted($dest)) { return $dest }
        return (Join-Path $RootPath $dest)
    }
    $bucket = Get-RowValue -Row $Row -Names @('PlannedBucket','ProposedBucket','Bucket','DestinationBucket','ProposedDestinationBucket')
    if (-not [string]::IsNullOrWhiteSpace($bucket) -and -not [string]::IsNullOrWhiteSpace($FileName)) {
        if ([System.IO.Path]::IsPathRooted($bucket)) { return (Join-Path $bucket $FileName) }
        return (Join-Path (Join-Path $RootPath $bucket) $FileName)
    }
    return ''
}

function Test-RowRouteIntent {
    param($Row, [string]$FileName)
    if (Test-HeldFileName -FileName $FileName) { return $false }
    $decisionText = @(
        Get-RowValue -Row $Row -Names @('Decision','Disposition','RouteDisposition','PrecheckDisposition','CandidateStatus','Status','Action','RequiredDisposition')
    ) -join ' '
    if ($decisionText -match '(?i)HOLD|LEAVE_IN_PLACE|NO_ROUTE|CURRENT_RUNNER|ZERO_BYTE|EXCLUDE|BLOCK') { return $false }
    $dest = Get-RowValue -Row $Row -Names @('PlannedDestinationPath','DestinationPath','ProposedDestinationPath','RouteDestinationPath','TargetPath')
    $bucket = Get-RowValue -Row $Row -Names @('PlannedBucket','ProposedBucket','Bucket','DestinationBucket','ProposedDestinationBucket')
    if (-not [string]::IsNullOrWhiteSpace($dest)) { return $true }
    if (-not [string]::IsNullOrWhiteSpace($bucket)) { return $true }
    if ($decisionText -match '(?i)ROUTE_CANDIDATE|ROUTE_LATER|PROPOSE_ROUTE|ROUTE') { return $true }
    return $false
}

function Import-CsvSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    try {
        $rows = @(Import-Csv -LiteralPath $Path)
        return $rows
    } catch {
        Add-Watch ("CSV_READ_FAIL: {0} :: {1}" -f $Path, $_.Exception.Message)
        return @()
    }
}

function Score-CsvEvidence {
    param([Parameter(Mandatory=$true)][string]$Path)
    $rows = Import-CsvSafe -Path $Path
    if ($rows.Count -eq 0) { return $null }
    $cols = Get-ColumnNames -Row $rows[0]
    $nameCol = Get-FirstColumnName -Available $cols -Wanted @('SourceFileName','FileName','Name')
    $bucketCol = Get-FirstColumnName -Available $cols -Wanted @('PlannedBucket','ProposedBucket','Bucket','DestinationBucket','ProposedDestinationBucket')
    $destCol = Get-FirstColumnName -Available $cols -Wanted @('PlannedDestinationPath','DestinationPath','ProposedDestinationPath','RouteDestinationPath','TargetPath')
    $shaCol = Get-FirstColumnName -Available $cols -Wanted @('SourceSHA256','SHA256','ActualSHA256','CurrentSHA256','Hash','FileSHA256')
    if ([string]::IsNullOrWhiteSpace($nameCol)) { return $null }
    if ([string]::IsNullOrWhiteSpace($bucketCol) -and [string]::IsNullOrWhiteSpace($destCol)) { return $null }

    $candidateRows = [System.Collections.Generic.List[object]]::new()
    foreach ($r in $rows) {
        $fn = Get-RowValue -Row $r -Names @('SourceFileName','FileName','Name')
        if ([string]::IsNullOrWhiteSpace($fn)) { continue }
        if (Test-RowRouteIntent -Row $r -FileName $fn) { [void]$candidateRows.Add($r) }
    }

    $score = 0
    if ($candidateRows.Count -eq 55) { $score += 1000 }
    if ($rows.Count -eq 58) { $score += 250 }
    if ($rows.Count -eq 55) { $score += 200 }
    if ($Path -match '(?i)ROUTE|ROOT_HELD|RECONSIDERATION|APPROVAL|PLAN|SELECTOR') { $score += 100 }
    if (-not [string]::IsNullOrWhiteSpace($shaCol)) { $score += 50 }
    if (-not [string]::IsNullOrWhiteSpace($destCol)) { $score += 40 }
    if (-not [string]::IsNullOrWhiteSpace($bucketCol)) { $score += 30 }

    return [pscustomobject]@{
        Path = $Path
        Score = $score
        TotalRows = $rows.Count
        CandidateRows = $candidateRows.Count
        NameColumn = $nameCol
        BucketColumn = $bucketCol
        DestinationColumn = $destCol
        ShaColumn = $shaCol
        Rows = $rows
    }
}

function Get-CandidateEvidenceFiles {
    $files = [System.Collections.Generic.List[string]]::new()
    if (-not [string]::IsNullOrWhiteSpace($RoutePlanCsv)) {
        if (Test-Path -LiteralPath $RoutePlanCsv -PathType Leaf) { [void]$files.Add((Resolve-Path -LiteralPath $RoutePlanCsv).Path) }
        else { Add-Blocker ("ROUTE_PLAN_CSV_NOT_FOUND: $RoutePlanCsv") }
        return @($files)
    }

    $searchRoots = @()
    if (Test-Path -LiteralPath $RootPath -PathType Container) { $searchRoots += $RootPath }
    $downloads = Join-Path $env:USERPROFILE 'Downloads'
    if (Test-Path -LiteralPath $downloads -PathType Container) { $searchRoots += $downloads }

    foreach ($sr in ($searchRoots | Select-Object -Unique)) {
        try {
            $found = Get-ChildItem -LiteralPath $sr -File -Recurse -Filter '*.csv' -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.FullName -notlike (Join-Path $OutputDir '*') -and
                    $_.Name -match '(?i)ROUTE|ROOT_HELD|RECONSIDERATION|APPROVAL|PLAN|SELECTOR|CANDIDATE|DELTA'
                } |
                Select-Object -ExpandProperty FullName
            foreach ($f in $found) { [void]$files.Add($f) }
        } catch {
            Add-Watch ("SEARCH_FAIL: {0} :: {1}" -f $sr, $_.Exception.Message)
        }
    }
    return @($files | Select-Object -Unique)
}

# Start checks.
if (-not (Test-Path -LiteralPath $RootPath -PathType Container)) {
    Add-Blocker ("ROOT_PATH_NOT_FOUND: $RootPath")
}

if (-not (Test-Path -LiteralPath $OutputDir -PathType Container)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$evidenceFiles = Get-CandidateEvidenceFiles
Add-Line $EvidenceLines ("candidate_csv_evidence_file_count: {0}" -f @($evidenceFiles).Count)

$scores = [System.Collections.Generic.List[object]]::new()
foreach ($f in $evidenceFiles) {
    $s = Score-CsvEvidence -Path $f
    if ($null -ne $s) { [void]$scores.Add($s) }
}

if ($scores.Count -eq 0) {
    Add-Blocker 'NO_USABLE_ROUTE_PLAN_CSV_FOUND_WITH_NAME_AND_DESTINATION_OR_BUCKET_COLUMNS'
}

$best = $null
if ($scores.Count -gt 0) {
    $best = @($scores | Sort-Object -Property Score,CandidateRows,TotalRows -Descending | Select-Object -First 1)[0]
    Add-Line $EvidenceLines ("selected_csv: {0}" -f $best.Path)
    Add-Line $EvidenceLines ("selected_csv_score: {0}" -f $best.Score)
    Add-Line $EvidenceLines ("selected_csv_total_rows: {0}" -f $best.TotalRows)
    Add-Line $EvidenceLines ("selected_csv_route_candidate_rows_detected: {0}" -f $best.CandidateRows)
}

$CandidateTable = [System.Collections.Generic.List[object]]::new()
if ($null -ne $best) {
    $i = 0
    foreach ($r in @($best.Rows)) {
        $rawName = Get-RowValue -Row $r -Names @('SourceFileName','FileName','Name')
        if ([string]::IsNullOrWhiteSpace($rawName)) { continue }
        $leafName = Split-Path -Path $rawName -Leaf
        if ([string]::IsNullOrWhiteSpace($leafName)) { $leafName = $rawName }
        if (-not (Test-RowRouteIntent -Row $r -FileName $leafName)) { continue }

        $i++
        $srcPath = Resolve-SourcePath -Row $r -FileName $leafName
        $destPath = Resolve-DestinationPath -Row $r -FileName $leafName
        $destParent = ''
        if (-not [string]::IsNullOrWhiteSpace($destPath)) {
            $destParent = Split-Path -Path $destPath -Parent
        }

        $declaredSha = Get-RowValue -Row $r -Names @('SourceSHA256','SHA256','DeclaredSHA256','CurrentSHA256','Hash','FileSHA256')
        $actualSha = ''
        $actualSize = ''
        $sourceExists = $false
        if (-not [string]::IsNullOrWhiteSpace($srcPath) -and (Test-Path -LiteralPath $srcPath -PathType Leaf)) {
            $sourceExists = $true
            $actualSha = Get-Sha256 -LiteralPath $srcPath
            $actualSize = Get-FileSizeBytes -LiteralPath $srcPath
        }
        $sourceShaForTable = $declaredSha
        if ([string]::IsNullOrWhiteSpace($sourceShaForTable) -and $AllowComputedShaWhenDeclaredMissing -and -not [string]::IsNullOrWhiteSpace($actualSha)) {
            $sourceShaForTable = $actualSha
        }

        $parentExists = $false
        if (-not [string]::IsNullOrWhiteSpace($destParent)) { $parentExists = Test-Path -LiteralPath $destParent -PathType Container }
        $destExists = $false
        if (-not [string]::IsNullOrWhiteSpace($destPath)) { $destExists = Test-Path -LiteralPath $destPath -PathType Leaf }
        $collisionStatus = 'CLEAR'
        if ($destExists) { $collisionStatus = 'DESTINATION_EXISTS_COLLISION' }
        elseif (-not $parentExists) { $collisionStatus = 'PARENT_MISSING' }

        $plannedBucket = Get-RowValue -Row $r -Names @('PlannedBucket','ProposedBucket','Bucket','DestinationBucket','ProposedDestinationBucket')
        $risk = 'MEDIUM_RISK_ROUTING_CANDIDATE'
        if ($leafName -match '(?i)\.ps1$|\.bat$|\.cmd$|\.vbs$|\.js$') { $risk = 'HIGH_RISK_EXECUTABLE_FILE_ROUTE_CANDIDATE' }

        [void]$CandidateTable.Add([pscustomobject]@{
            Route55RowID = ('R55-{0:000}' -f $i)
            SourcePath = $srcPath
            SourceFileName = $leafName
            SourceSHA256 = $sourceShaForTable
            ActualSHA256AtReview = $actualSha
            SourceSizeBytes = $actualSize
            PlannedDestinationPath = $destPath
            DestinationParentPath = $destParent
            DestinationParentExistsNow = if ($parentExists) { 'YES' } else { 'NO' }
            DestinationAlreadyExistsNow = if ($destExists) { 'YES' } else { 'NO' }
            DestinationCollisionStatus = $collisionStatus
            PlannedBucket = $plannedBucket
            OriginalPlannedRowID = Get-RowValue -Row $r -Names @('OriginalPlannedRowID','PlanRowID','RowID','TicketID','ID')
            ReviewedDeltaRowID = Get-RowValue -Row $r -Names @('ReviewedDeltaRowID','DeltaRowID','ReviewRowID')
            CandidateStatus = 'ROUTE_CANDIDATE_STATIC_REVIEW_ONLY'
            RiskLabel = $risk
            PrecheckDisposition = 'STATIC_REVIEW_ONLY'
            ActionNow = 'NO'
            ApprovedForExecution = 'NO'
            DoesNotProve = 'This row does not authorize movement or execution.'
        })
    }
}

# Validate tables.
if ($CandidateTable.Count -ne 55) {
    Add-Blocker ("ROUTE_55_CANDIDATE_COUNT_NOT_55: detected=$($CandidateTable.Count)")
}
if ($HeldRows.Count -ne 3) {
    Add-Blocker ("HOLD_TABLE_COUNT_NOT_3: detected=$($HeldRows.Count)")
}

foreach ($h in $HeldRows) {
    $foundInCandidates = @($CandidateTable | Where-Object { $_.SourceFileName -ieq $h.FileName })
    if ($foundInCandidates.Count -gt 0) { Add-Blocker ("HELD_ROW_INCLUDED_IN_ROUTE_CANDIDATES: $($h.FileName)") }
}

$seenSources = @{}
$seenDests = @{}
foreach ($row in $CandidateTable) {
    foreach ($field in @('Route55RowID','SourcePath','SourceFileName','PlannedDestinationPath','DestinationParentPath','CandidateStatus','RiskLabel','PrecheckDisposition','ActionNow','ApprovedForExecution','DoesNotProve')) {
        if ([string]::IsNullOrWhiteSpace([string]$row.$field)) { Add-Blocker ("BLANK_REQUIRED_FIELD: $($row.Route55RowID) field=$field file=$($row.SourceFileName)") }
    }
    if ($row.ActionNow -ne 'NO') { Add-Blocker ("ACTION_NOW_NOT_NO: $($row.Route55RowID)") }
    if ($row.ApprovedForExecution -ne 'NO') { Add-Blocker ("APPROVED_FOR_EXECUTION_NOT_NO: $($row.Route55RowID)") }
    if (-not (Test-Path -LiteralPath $row.SourcePath -PathType Leaf)) { Add-Blocker ("SOURCE_MISSING_AT_REVIEW: $($row.Route55RowID) $($row.SourcePath)") }
    if ([string]::IsNullOrWhiteSpace($row.SourceSHA256)) { Add-Blocker ("SOURCE_SHA256_MISSING: $($row.Route55RowID) $($row.SourceFileName)") }
    if (-not [string]::IsNullOrWhiteSpace($row.SourceSHA256) -and -not [string]::IsNullOrWhiteSpace($row.ActualSHA256AtReview) -and ($row.SourceSHA256.ToUpperInvariant() -ne $row.ActualSHA256AtReview.ToUpperInvariant())) {
        Add-Blocker ("SOURCE_HASH_MISMATCH: $($row.Route55RowID) $($row.SourceFileName)")
    }
    if ($row.DestinationParentExistsNow -ne 'YES') { Add-Blocker ("DESTINATION_PARENT_MISSING_OR_STALE: $($row.Route55RowID) $($row.DestinationParentPath)") }
    if ($row.DestinationAlreadyExistsNow -eq 'YES') { Add-Blocker ("DESTINATION_ALREADY_EXISTS_COLLISION: $($row.Route55RowID) $($row.PlannedDestinationPath)") }
    if ($row.SourcePath -ieq $row.PlannedDestinationPath) { Add-Blocker ("SOURCE_EQUALS_DESTINATION: $($row.Route55RowID)") }
    if (-not (Test-UnderPath -ChildPath $row.PlannedDestinationPath -ParentPath $RootPath)) { Add-Blocker ("DESTINATION_OUTSIDE_ROOT: $($row.Route55RowID) $($row.PlannedDestinationPath)") }
    if ($seenSources.ContainsKey($row.SourcePath.ToLowerInvariant())) { Add-Blocker ("DUPLICATE_SOURCE_PATH: $($row.SourcePath)") }
    else { $seenSources[$row.SourcePath.ToLowerInvariant()] = $true }
    if ($seenDests.ContainsKey($row.PlannedDestinationPath.ToLowerInvariant())) { Add-Blocker ("DUPLICATE_DESTINATION_PATH: $($row.PlannedDestinationPath)") }
    else { $seenDests[$row.PlannedDestinationPath.ToLowerInvariant()] = $true }
}

# Write outputs.
$populatedCandidateCsv = Join-Path $OutputDir ("ROUTE_55_CANDIDATE_ACTION_TABLE_POPULATED_STATIC_REVIEW_NO_EXECUTION_V0_2_{0}.csv" -f $RunStamp)
$holdCsv = Join-Path $OutputDir ("ROUTE_55_HOLD_EXCLUSION_TABLE_STATIC_REVIEW_NO_EXECUTION_V0_2_{0}.csv" -f $RunStamp)
$reportPath = Join-Path $OutputDir ("ROUTE_55_ROW_TABLE_PROOF_STATIC_REVIEW_REPORT_V0_2_{0}.md" -f $RunStamp)
$receiptPath = Join-Path $OutputDir ("ROUTE_55_ROW_TABLE_PROOF_STATIC_REVIEW_RECEIPT_V0_2_{0}.txt" -f $RunStamp)

$CandidateTable | Export-Csv -LiteralPath $populatedCandidateCsv -NoTypeInformation -Encoding UTF8
$HeldRows | Export-Csv -LiteralPath $holdCsv -NoTypeInformation -Encoding UTF8

$finalVerdict = 'ROUTE_55_ROW_TABLE_PROOF_STATIC_REVIEW_READY_FOR_USER_REVIEW__NO_EXECUTION_AUTHORIZED'
if ($Blockers.Count -gt 0) {
    $finalVerdict = 'ROUTE_55_ROW_TABLE_PROOF_STATIC_REVIEW_BLOCKED__NO_EXECUTION_AUTHORIZED'
}

Add-Line $ReportLines '# ROUTE 55 ROW TABLE PROOF STATIC REVIEW REPORT V0.2'
Add-Line $ReportLines ''
Add-Line $ReportLines 'Status: STATIC_REVIEW_REPORT / OFFICIAL_GATE_PRESERVED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
Add-Line $ReportLines ''
Add-Line $ReportLines ("Run timestamp: `{0}`" -f $RunStamp)
Add-Line $ReportLines ("RootPath: `{0}`" -f $RootPath)
Add-Line $ReportLines ("OutputDir: `{0}`" -f $OutputDir)
Add-Line $ReportLines ("Runner: `{0}`" -f $ScriptName)
Add-Line $ReportLines ("Official gate: `{0}`" -f $OfficialGate)
Add-Line $ReportLines ("Descriptive next-work label, not a gate: `{0}`" -f $DescriptiveNextWorkLabel)
Add-Line $ReportLines ("Forbidden gate rename: `{0}`" -f $ForbiddenGateRename)
Add-Line $ReportLines ''
Add-Line $ReportLines '## Evidence selection'
Add-Line $ReportLines ''
foreach ($l in $EvidenceLines) { Add-Line $ReportLines $l }
if ($null -ne $best) {
    Add-Line $ReportLines ("selected_csv_sha256: `{0}`" -f (Get-Sha256 -LiteralPath $best.Path))
}
Add-Line $ReportLines ''
Add-Line $ReportLines '## Counts'
Add-Line $ReportLines ''
Add-Line $ReportLines ("route_candidate_rows_detected: `{0}`" -f $CandidateTable.Count)
Add-Line $ReportLines ("hold_exclusion_rows: `{0}`" -f $HeldRows.Count)
Add-Line $ReportLines ("blocker_count: `{0}`" -f $Blockers.Count)
Add-Line $ReportLines ("watch_count: `{0}`" -f $Watch.Count)
Add-Line $ReportLines ''
Add-Line $ReportLines '## Physical action accounting'
Add-Line $ReportLines ''
Add-Line $ReportLines 'move=0'
Add-Line $ReportLines 'delete=0'
Add-Line $ReportLines 'rename=0'
Add-Line $ReportLines 'route=0'
Add-Line $ReportLines 'cleanup=0'
Add-Line $ReportLines 'execute_helpers=0'
Add-Line $ReportLines 'commit=0'
Add-Line $ReportLines 'push=0'
Add-Line $ReportLines ''
Add-Line $ReportLines '## Blockers'
Add-Line $ReportLines ''
if ($Blockers.Count -eq 0) { Add-Line $ReportLines 'None detected.' }
else { foreach ($b in $Blockers) { Add-Line $ReportLines ("- $b") } }
Add-Line $ReportLines ''
Add-Line $ReportLines '## Watch items'
Add-Line $ReportLines ''
if ($Watch.Count -eq 0) { Add-Line $ReportLines 'None detected.' }
else { foreach ($w in $Watch) { Add-Line $ReportLines ("- $w") } }
Add-Line $ReportLines ''
Add-Line $ReportLines '## Output artifacts'
Add-Line $ReportLines ''
Add-Line $ReportLines ("populated_candidate_table: `{0}`" -f $populatedCandidateCsv)
Add-Line $ReportLines ("hold_exclusion_table: `{0}`" -f $holdCsv)
Add-Line $ReportLines ''
Add-Line $ReportLines '## DoesNotProve'
Add-Line $ReportLines ''
Add-Line $ReportLines 'This report does not authorize physical routing.'
Add-Line $ReportLines 'This report does not move, delete, rename, route, cleanup, execute helpers, commit, or push.'
Add-Line $ReportLines 'This report does not include the 3 held rows in route execution authority.'
Add-Line $ReportLines 'This report does not prove an executor may run. A later explicit user approval is still required.'
Add-Line $ReportLines ('This report preserves the official gate exactly: `{0}`' -f $OfficialGate)
Add-Line $ReportLines ''
Add-Line $ReportLines '## Final scoped verdict'
Add-Line $ReportLines ''
Add-Line $ReportLines ("`{0}`" -f $finalVerdict)

[System.IO.File]::WriteAllLines($reportPath, $ReportLines, [System.Text.UTF8Encoding]::new($false))

$receiptLines = New-List
Add-Line $receiptLines 'ROUTE 55 ROW TABLE PROOF STATIC REVIEW RECEIPT V0.2'
Add-Line $receiptLines ("run_timestamp: $RunStamp")
Add-Line $receiptLines ("root_path: $RootPath")
Add-Line $receiptLines ("output_dir: $OutputDir")
Add-Line $receiptLines ("runner: $ScriptName")
Add-Line $receiptLines ("official_gate: $OfficialGate")
Add-Line $receiptLines ("descriptive_next_work_label_not_gate: $DescriptiveNextWorkLabel")
Add-Line $receiptLines ("forbidden_gate_rename: $ForbiddenGateRename")
Add-Line $receiptLines ("candidate_rows: $($CandidateTable.Count)")
Add-Line $receiptLines ("hold_rows: $($HeldRows.Count)")
Add-Line $receiptLines ("blocker_count: $($Blockers.Count)")
Add-Line $receiptLines ("watch_count: $($Watch.Count)")
Add-Line $receiptLines ("report_path: $reportPath")
Add-Line $receiptLines ("report_sha256: $(Get-Sha256 -LiteralPath $reportPath)")
Add-Line $receiptLines ("candidate_table_path: $populatedCandidateCsv")
Add-Line $receiptLines ("candidate_table_sha256: $(Get-Sha256 -LiteralPath $populatedCandidateCsv)")
Add-Line $receiptLines ("hold_table_path: $holdCsv")
Add-Line $receiptLines ("hold_table_sha256: $(Get-Sha256 -LiteralPath $holdCsv)")
Add-Line $receiptLines 'physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0'
Add-Line $receiptLines ("final_verdict: $finalVerdict")
[System.IO.File]::WriteAllLines($receiptPath, $receiptLines, [System.Text.UTF8Encoding]::new($false))

Write-Host '=== ROUTE 55 ROW TABLE PROOF STATIC REVIEW COMPLETE ==='
Write-Host "report_path: $reportPath"
Write-Host "receipt_path: $receiptPath"
Write-Host "candidate_table_path: $populatedCandidateCsv"
Write-Host "hold_table_path: $holdCsv"
Write-Host "blocker_count: $($Blockers.Count)"
Write-Host "final_verdict: $finalVerdict"

if ($Blockers.Count -gt 0) { exit 2 }
exit 0
