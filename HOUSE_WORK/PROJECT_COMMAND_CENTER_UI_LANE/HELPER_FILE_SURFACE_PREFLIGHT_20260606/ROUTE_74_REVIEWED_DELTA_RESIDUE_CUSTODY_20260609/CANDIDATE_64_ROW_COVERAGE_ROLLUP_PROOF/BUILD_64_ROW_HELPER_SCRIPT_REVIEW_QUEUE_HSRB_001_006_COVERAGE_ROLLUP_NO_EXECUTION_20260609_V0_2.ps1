Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_20260609_V0_2.ps1
# Purpose: review-only coverage rollup for the 64-row helper script review queue across HSRB-001..HSRB-006.
# No execution, route, cleanup, rename, move, delete, commit, push, clipboard, Start-Process, or Invoke-Expression authority.

function Write-LinesUtf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [AllowEmptyCollection()][AllowNull()][string[]]$Lines
    )
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    if ($null -eq $Lines) { $Lines = @() }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($Path, [string[]]$Lines, $utf8NoBom)
}

function Write-CsvUtf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [AllowEmptyCollection()][AllowNull()][object[]]$Rows
    )
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    if ($null -eq $Rows) { $Rows = @() }
    $Rows | Export-Csv -LiteralPath $Path -NoTypeInformation -Encoding UTF8
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Get-PropValue {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [Parameter(Mandatory=$true)][string[]]$Names
    )
    $props = @($Row.PSObject.Properties)
    foreach ($name in $Names) {
        $match = $props | Where-Object { $_.Name -ieq $name } | Select-Object -First 1
        if ($null -ne $match) {
            $value = [string]$match.Value
            if (-not [string]::IsNullOrWhiteSpace($value)) { return $value.Trim() }
        }
    }
    return ''
}

function New-RowKey {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [Parameter(Mandatory=$true)][int]$Ordinal
    )
    $ticket = Get-PropValue -Row $Row -Names @('TicketID','TicketId','ticket_id','ReviewTicketID','ReviewTicketId','Ticket','Id','ID')
    $fileName = Get-PropValue -Row $Row -Names @('FileName','Filename','file_name','Name','ObjectName','Path','FullName','RelativePath','SourcePath')
    $declaredSha = Get-PropValue -Row $Row -Names @('DeclaredSHA256','DeclaredSha256','declared_sha256','SourceSHA256','SourceSha256','SHA256','Sha256','FileSHA256','FileSha256')
    $actualSha = Get-PropValue -Row $Row -Names @('ActualSHA256','ActualSha256','actual_sha256','ComputedSHA256','ComputedSha256')

    if (-not [string]::IsNullOrWhiteSpace($ticket)) { return ('T:' + $ticket) }
    if (-not [string]::IsNullOrWhiteSpace($fileName) -and -not [string]::IsNullOrWhiteSpace($declaredSha)) { return ('F:' + $fileName + '|S:' + $declaredSha) }
    if (-not [string]::IsNullOrWhiteSpace($fileName) -and -not [string]::IsNullOrWhiteSpace($actualSha)) { return ('F:' + $fileName + '|A:' + $actualSha) }
    if (-not [string]::IsNullOrWhiteSpace($fileName)) { return ('F:' + $fileName) }
    return ('ROW:' + $Ordinal.ToString('0000'))
}

function Import-CsvRows {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return @() }
    $rows = Import-Csv -LiteralPath $Path
    if ($null -eq $rows) { return @() }
    return @($rows)
}


function ConvertTo-ObjectArray {
    param([AllowNull()][object]$Value)
    if ($null -eq $Value) { return @() }
    if ($Value -is [string]) { return ,$Value }
    if ($Value -is [System.Collections.IEnumerable]) {
        $list = New-Object System.Collections.Generic.List[object]
        foreach ($item in $Value) { $list.Add($item) | Out-Null }
        return $list.ToArray()
    }
    return ,$Value
}

function Get-VersionNumber {
    param([Parameter(Mandatory=$true)][string]$Name)
    $matches = [regex]::Matches($Name, 'V(?<major>\d+)_(?<minor>\d+)')
    if ($matches.Count -eq 0) { return 0 }
    $m = $matches[$matches.Count - 1]
    return ([int]$m.Groups['major'].Value * 1000) + [int]$m.Groups['minor'].Value
}

function Get-BatchNumberFromName {
    param([Parameter(Mandatory=$true)][string]$Name)
    $m = [regex]::Match($Name, 'SELECTED_BATCH[_-](?<n>\d{3})')
    if ($m.Success) { return $m.Groups['n'].Value }
    $m = [regex]::Match($Name, 'HSRB[_-](?<n>\d{3})')
    if ($m.Success) { return $m.Groups['n'].Value }
    $m = [regex]::Match($Name, 'BATCH[_-](?<n>\d{3})')
    if ($m.Success) { return $m.Groups['n'].Value }
    return ''
}

function Select-LatestByBatch {
    param([Parameter(Mandatory=$true)][object[]]$Files)
    $latest = @{}
    foreach ($file in (ConvertTo-ObjectArray -Value $Files)) {
        $batch = Get-BatchNumberFromName -Name $file.Name
        if ([string]::IsNullOrWhiteSpace($batch)) { continue }
        if ([int]$batch -lt 1 -or [int]$batch -gt 6) { continue }
        $version = Get-VersionNumber -Name $file.Name
        if (-not $latest.ContainsKey($batch)) {
            $latest[$batch] = [pscustomobject]@{ Batch=$batch; File=$file; Version=$version }
            continue
        }
        $prior = $latest[$batch]
        if ($version -gt $prior.Version -or ($version -eq $prior.Version -and $file.LastWriteTime -gt $prior.File.LastWriteTime)) {
            $latest[$batch] = [pscustomobject]@{ Batch=$batch; File=$file; Version=$version }
        }
    }
    return $latest
}

$NowStamp = '20260609'
$Root = (Get-Location).Path
$SurfaceRel = 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$SurfaceDir = Join-Path $Root $SurfaceRel
if (-not (Test-Path -LiteralPath $SurfaceDir)) {
    throw "Required helper file surface not found: $SurfaceDir"
}

$V01ErrorFreezePath = Join-Path $SurfaceDir 'ERROR_FREEZE__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_1_COLLECTION_CAST_FAILURE_20260609.md'
$FixNotePath = Join-Path $SurfaceDir 'FIX_NOTE__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_2_SAFE_COLLECTION_ENUMERATION_20260609.md'
$FixReceiptPath = Join-Path $SurfaceDir 'HASH_RECEIPT__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_2_REPAIR_20260609.txt'

$V01FreezeLines = @(
    '# ERROR FREEZE - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.1 COLLECTION CAST FAILURE',
    '',
    'failed_script: BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_20260609_V0_1.ps1',
    'failed_line: 210',
    'failed_statement: foreach ($batchFile in @($BatchFiles)) {',
    'error: Argument types do not match',
    '',
    'classification: RUNNER_COLLECTION_ENUMERATION_DEFECT',
    'scope: coverage rollup runner only; no route, cleanup, execution, commit, push, or physical action was authorized or observed',
    'does_not_prove: does not prove the 64-row queue is uncovered, duplicated, or damaged',
    'required_repair: enumerate generic collections through explicit safe object-array conversion and rerun the same coverage contract',
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $V01ErrorFreezePath -Lines $V01FreezeLines
$V01ErrorFreezeSha = Get-Sha256 -Path $V01ErrorFreezePath

$FixNoteLines = @(
    '# FIX NOTE - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.2 SAFE COLLECTION ENUMERATION',
    '',
    'repair_scope: replace fragile array-subexpression enumeration over generic lists with ConvertTo-ObjectArray safe enumeration',
    'preserves_contract: yes',
    'preserves_no_execution_boundary: yes',
    'preserves_no_route_cleanup_boundary: yes',
    'coverage_result_authority: V0.2 output only; V0.1 failed before producing a valid coverage result',
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $FixNotePath -Lines $FixNoteLines
$FixNoteSha = Get-Sha256 -Path $FixNotePath

$FixReceiptLines = @(
    'HASH RECEIPT - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.2 REPAIR',
    'v0_1_error_freeze_path: ' + $V01ErrorFreezePath,
    'v0_1_error_freeze_sha256: ' + $V01ErrorFreezeSha,
    'fix_note_path: ' + $FixNotePath,
    'fix_note_sha256: ' + $FixNoteSha,
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $FixReceiptPath -Lines $FixReceiptLines
$FixReceiptSha = Get-Sha256 -Path $FixReceiptPath

$QueueCandidates = @(
    Get-ChildItem -LiteralPath $SurfaceDir -File -Filter '*.csv' |
        Where-Object {
            $_.Name -match 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS' -and
            $_.Name -notmatch 'SELECTED_BATCH' -and
            $_.Name -notmatch 'REMAINING_AFTER' -and
            $_.Name -notmatch 'SUMMARY' -and
            $_.Name -notmatch 'ROLLUP'
        }
)
if ($QueueCandidates.Count -eq 0) {
    $QueueCandidates = @(
        Get-ChildItem -LiteralPath $SurfaceDir -File -Filter '*.csv' |
            Where-Object {
                $_.Name -match '64' -and $_.Name -match 'QUEUE' -and
                $_.Name -notmatch 'SELECTED_BATCH' -and
                $_.Name -notmatch 'REMAINING_AFTER' -and
                $_.Name -notmatch 'SUMMARY' -and
                $_.Name -notmatch 'ROLLUP'
            }
    )
}
$QueueFile = $QueueCandidates | Sort-Object @{Expression={Get-VersionNumber -Name $_.Name};Descending=$true}, LastWriteTime -Descending | Select-Object -First 1

$SelectedCandidates = @(
    Get-ChildItem -LiteralPath $SurfaceDir -File -Filter '*.csv' |
        Where-Object {
            $_.Name -match 'SELECTED_BATCH' -and
            $_.Name -notmatch 'REMAINING_AFTER' -and
            $_.Name -notmatch 'ROLLUP'
        }
)
$LatestByBatch = Select-LatestByBatch -Files $SelectedCandidates

$BatchFiles = New-Object System.Collections.Generic.List[object]
foreach ($n in 1..6) {
    $key = $n.ToString('000')
    if ($LatestByBatch.ContainsKey($key)) {
        $BatchFiles.Add([pscustomobject]@{
            BatchId = ('HSRB-' + $key)
            BatchNumber = $key
            Path = $LatestByBatch[$key].File.FullName
            FileName = $LatestByBatch[$key].File.Name
            VersionNumber = $LatestByBatch[$key].Version
            SHA256 = Get-Sha256 -Path $LatestByBatch[$key].File.FullName
        }) | Out-Null
    }
}

$QueueRows = @()
$QueueFound = $false
$QueueSha = ''
if ($null -ne $QueueFile) {
    $QueueFound = $true
    $QueueRows = Import-CsvRows -Path $QueueFile.FullName
    $QueueSha = Get-Sha256 -Path $QueueFile.FullName
}

$QueueKeyToRows = @{}
$QueueDuplicateKeys = New-Object System.Collections.Generic.List[string]
$queueOrdinal = 0
foreach ($row in (ConvertTo-ObjectArray -Value $QueueRows)) {
    $queueOrdinal++
    $key = New-RowKey -Row $row -Ordinal $queueOrdinal
    if (-not $QueueKeyToRows.ContainsKey($key)) {
        $QueueKeyToRows[$key] = New-Object System.Collections.Generic.List[object]
    } else {
        $QueueDuplicateKeys.Add($key) | Out-Null
    }
    $QueueKeyToRows[$key].Add($row) | Out-Null
}

$Coverage = @{}
foreach ($key in $QueueKeyToRows.Keys) {
    $Coverage[$key] = New-Object System.Collections.Generic.List[string]
}

$SelectedRowsRaw = 0
$SelectedRowsNotInQueue = New-Object System.Collections.Generic.List[object]
$BatchSummary = New-Object System.Collections.Generic.List[object]

foreach ($batchFile in (ConvertTo-ObjectArray -Value $BatchFiles)) {
    $rows = Import-CsvRows -Path $batchFile.Path
    $rowsArray = ConvertTo-ObjectArray -Value $rows
    $SelectedRowsRaw += $rowsArray.Count
    $batchMatched = 0
    $batchNotInQueue = 0
    $ordinal = 0
    foreach ($row in $rowsArray) {
        $ordinal++
        $key = New-RowKey -Row $row -Ordinal $ordinal
        if ($Coverage.ContainsKey($key)) {
            $Coverage[$key].Add($batchFile.BatchId) | Out-Null
            $batchMatched++
        } else {
            $batchNotInQueue++
            $SelectedRowsNotInQueue.Add([pscustomobject]@{
                BatchId = $batchFile.BatchId
                RowOrdinal = $ordinal
                RowKey = $key
                FileName = Get-PropValue -Row $row -Names @('FileName','Filename','file_name','Name','ObjectName','Path','FullName','RelativePath','SourcePath')
                TicketID = Get-PropValue -Row $row -Names @('TicketID','TicketId','ticket_id','ReviewTicketID','ReviewTicketId','Ticket','Id','ID')
            }) | Out-Null
        }
    }
    $BatchSummary.Add([pscustomobject]@{
        BatchId = $batchFile.BatchId
        SelectedBatchCsv = $batchFile.FileName
        SelectedBatchCsvSHA256 = $batchFile.SHA256
        SelectedRows = $rowsArray.Count
        RowsMatchedToQueue = $batchMatched
        RowsNotInQueue = $batchNotInQueue
        VersionNumber = $batchFile.VersionNumber
    }) | Out-Null
}

$CoverageRows = New-Object System.Collections.Generic.List[object]
$Uncovered = 0
$DuplicateCoverage = 0
$Covered = 0
$coverageOrdinal = 0
foreach ($key in ($QueueKeyToRows.Keys | Sort-Object)) {
    $coverageOrdinal++
    $row = $QueueKeyToRows[$key][0]
    $batches = ConvertTo-ObjectArray -Value $Coverage[$key]
    $batchList = ($batches | Sort-Object -Unique) -join ';'
    $batchCount = (ConvertTo-ObjectArray -Value ($batches | Sort-Object -Unique)).Count
    if ($batchCount -eq 0) { $Uncovered++ } else { $Covered++ }
    if ($batchCount -gt 1) { $DuplicateCoverage++ }
    $CoverageRows.Add([pscustomobject]@{
        QueueOrdinal = $coverageOrdinal
        RowKey = $key
        TicketID = Get-PropValue -Row $row -Names @('TicketID','TicketId','ticket_id','ReviewTicketID','ReviewTicketId','Ticket','Id','ID')
        FileName = Get-PropValue -Row $row -Names @('FileName','Filename','file_name','Name','ObjectName','Path','FullName','RelativePath','SourcePath')
        DeclaredSHA256 = Get-PropValue -Row $row -Names @('DeclaredSHA256','DeclaredSha256','declared_sha256','SourceSHA256','SourceSha256','SHA256','Sha256','FileSHA256','FileSha256')
        CoveredByBatchList = $batchList
        CoveredByBatchCount = $batchCount
        CoverageStatus = $(if ($batchCount -eq 0) { 'UNCOVERED' } elseif ($batchCount -gt 1) { 'DUPLICATE_COVERAGE_REVIEW' } else { 'COVERED_ONCE' })
        ActionAuthority = 'NO'
        SourceActionPreservedAsEvidence = 'YES'
        RecursiveDryRunExpansionRequired = 'YES'
        WholeHouseClearanceGrant = 'NO'
    }) | Out-Null
}

$BatchSummaryCsv = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_BATCH_SUMMARY_NO_EXECUTION_V0_2_20260609.csv'
$CoverageCsv = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_ROW_COVERAGE_NO_EXECUTION_V0_2_20260609.csv'
$NotInQueueCsv = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_SELECTED_ROWS_NOT_IN_QUEUE_NO_EXECUTION_V0_2_20260609.csv'
$ReportPath = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_V0_2_20260609.md'
$PrintPath = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_COPY_PRINT_V0_2_20260609.txt'
$ReceiptPath = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_RECEIPT_V0_2_20260609.txt'

Write-CsvUtf8 -Path $BatchSummaryCsv -Rows (ConvertTo-ObjectArray -Value $BatchSummary)
Write-CsvUtf8 -Path $CoverageCsv -Rows (ConvertTo-ObjectArray -Value $CoverageRows)
Write-CsvUtf8 -Path $NotInQueueCsv -Rows (ConvertTo-ObjectArray -Value $SelectedRowsNotInQueue)

$QueueRowsCount = (ConvertTo-ObjectArray -Value $QueueRows).Count
$UniqueQueueKeyCount = (ConvertTo-ObjectArray -Value $QueueKeyToRows.Keys).Count
$BatchFilesFoundCount = (ConvertTo-ObjectArray -Value $BatchFiles).Count
$MissingBatchCount = 6 - $BatchFilesFoundCount
$SelectedRowsNotInQueueCount = (ConvertTo-ObjectArray -Value $SelectedRowsNotInQueue).Count
$QueueDuplicateKeyCount = (ConvertTo-ObjectArray -Value ($QueueDuplicateKeys | Sort-Object -Unique)).Count
$WholeHouseClearanceGrantCount = 0
$WholeHouseClearanceBoundaryExplicitCount = $QueueRowsCount
$PhysicalMove = 0
$PhysicalDelete = 0
$PhysicalRename = 0
$PhysicalRoute = 0
$PhysicalExecute = 0
$PhysicalCommit = 0
$PhysicalPush = 0

$Blockers = New-Object System.Collections.Generic.List[string]
if (-not $QueueFound) { $Blockers.Add('MISSING_64_ROW_QUEUE_CSV') | Out-Null }
if ($QueueRowsCount -ne 64) { $Blockers.Add('QUEUE_ROW_COUNT_NOT_64') | Out-Null }
if ($UniqueQueueKeyCount -ne $QueueRowsCount) { $Blockers.Add('QUEUE_KEYS_NOT_UNIQUE') | Out-Null }
if ($BatchFilesFoundCount -ne 6) { $Blockers.Add('MISSING_HSRB_SELECTED_BATCH_FILE') | Out-Null }
if ($Uncovered -ne 0) { $Blockers.Add('UNCOVERED_QUEUE_ROWS') | Out-Null }
if ($DuplicateCoverage -ne 0) { $Blockers.Add('DUPLICATE_QUEUE_ROW_COVERAGE') | Out-Null }
if ($SelectedRowsNotInQueueCount -ne 0) { $Blockers.Add('SELECTED_ROWS_NOT_IN_QUEUE') | Out-Null }
if ($WholeHouseClearanceGrantCount -ne 0) { $Blockers.Add('WHOLE_HOUSE_CLEARANCE_GRANT_PRESENT') | Out-Null }
if (($PhysicalMove + $PhysicalDelete + $PhysicalRename + $PhysicalRoute + $PhysicalExecute + $PhysicalCommit + $PhysicalPush) -ne 0) { $Blockers.Add('PHYSICAL_ACTION_NONZERO') | Out-Null }

$BlockerCount = (ConvertTo-ObjectArray -Value $Blockers).Count
$ContractGatePassed = ($BlockerCount -eq 0)
$NextSingleAction = if ($ContractGatePassed) { 'BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_CLOSEOUT_NO_EXECUTION' } else { 'STOP_AND_REVIEW_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_COVERAGE_ROLLUP_BLOCKERS_NO_EXECUTION' }
$FinalVerdict = if ($ContractGatePassed) { 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_2_VERIFIED_ALL_64_ROWS_COVERED_ONCE_REVIEW_ONLY_NO_PHYSICAL_ACTION' } else { 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_2_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }

$BatchSummarySha = Get-Sha256 -Path $BatchSummaryCsv
$CoverageSha = Get-Sha256 -Path $CoverageCsv
$NotInQueueSha = Get-Sha256 -Path $NotInQueueCsv

$ReportLines = @(
    '# 64-ROW HELPER SCRIPT REVIEW QUEUE HSRB-001..006 COVERAGE ROLLUP V0.2',
    '',
    'Status: REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH',
    '',
    'Purpose: confirm whether HSRB-001 through HSRB-006 cover the 64-row helper script review queue exactly once, without converting any source action wording into action authority.',
    '',
    '## Inputs',
    '',
    '- queue_csv_path: ' + $(if ($QueueFound) { $QueueFile.FullName } else { 'MISSING' }),
    '- queue_csv_sha256: ' + $QueueSha,
    '- batch_files_found: ' + $BatchFilesFoundCount,
    '- selected_rows_raw_total: ' + $SelectedRowsRaw,
    '',
    '## Coverage counts',
    '',
    '- queue_rows: ' + $QueueRowsCount,
    '- unique_queue_key_count: ' + $UniqueQueueKeyCount,
    '- queue_duplicate_key_count: ' + $QueueDuplicateKeyCount,
    '- covered_queue_row_count: ' + $Covered,
    '- uncovered_queue_row_count: ' + $Uncovered,
    '- duplicate_coverage_queue_row_count: ' + $DuplicateCoverage,
    '- selected_rows_not_in_queue_count: ' + $SelectedRowsNotInQueueCount,
    '',
    '## Authority boundary counts',
    '',
    '- action_authority_count: 0',
    '- route_clearance_count: 0',
    '- cleanup_clearance_count: 0',
    '- execution_clearance_count: 0',
    '- doctrine_promotion_count: 0',
    '- recursive_dry_run_expansion_required_count: ' + $QueueRowsCount,
    '- whole_house_clearance_grant_count: ' + $WholeHouseClearanceGrantCount,
    '- whole_house_clearance_boundary_explicit_count: ' + $WholeHouseClearanceBoundaryExplicitCount,
    '',
    'Note: whole_house_clearance_boundary_explicit_count means rows explicitly carry a no-whole-house-clearance boundary. It is not a grant count.',
    '',
    '## V0.1 repair freeze',
    '',
    '- v0_1_error_freeze_path: ' + $V01ErrorFreezePath,
    '- v0_1_error_freeze_sha256: ' + $V01ErrorFreezeSha,
    '- fix_note_path: ' + $FixNotePath,
    '- fix_note_sha256: ' + $FixNoteSha,
    '- fix_receipt_path: ' + $FixReceiptPath,
    '- fix_receipt_sha256: ' + $FixReceiptSha,
    '',
    '## Outputs',
    '',
    '- batch_summary_csv_path: ' + $BatchSummaryCsv,
    '- batch_summary_csv_sha256: ' + $BatchSummarySha,
    '- row_coverage_csv_path: ' + $CoverageCsv,
    '- row_coverage_csv_sha256: ' + $CoverageSha,
    '- selected_rows_not_in_queue_csv_path: ' + $NotInQueueCsv,
    '- selected_rows_not_in_queue_csv_sha256: ' + $NotInQueueSha,
    '',
    '## Contract',
    '',
    '- contract_gate_passed: ' + $ContractGatePassed,
    '- blocker_count: ' + $BlockerCount,
    '- blockers: ' + $(if ($BlockerCount -eq 0) { 'NONE' } else { ((ConvertTo-ObjectArray -Value $Blockers) -join ';') }),
    '- next_single_action: ' + $NextSingleAction,
    '- final_verdict: ' + $FinalVerdict,
    '- physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)

Write-LinesUtf8 -Path $ReportPath -Lines $ReportLines
Write-LinesUtf8 -Path $PrintPath -Lines $ReportLines

$ReportSha = Get-Sha256 -Path $ReportPath
$PrintSha = Get-Sha256 -Path $PrintPath

$ReceiptLines = @(
    'HASH RECEIPT - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.2',
    'v0_1_error_freeze_path: ' + $V01ErrorFreezePath,
    'v0_1_error_freeze_sha256: ' + $V01ErrorFreezeSha,
    'fix_note_path: ' + $FixNotePath,
    'fix_note_sha256: ' + $FixNoteSha,
    'fix_receipt_path: ' + $FixReceiptPath,
    'fix_receipt_sha256: ' + $FixReceiptSha,
    'batch_summary_csv_path: ' + $BatchSummaryCsv,
    'batch_summary_csv_sha256: ' + $BatchSummarySha,
    'row_coverage_csv_path: ' + $CoverageCsv,
    'row_coverage_csv_sha256: ' + $CoverageSha,
    'selected_rows_not_in_queue_csv_path: ' + $NotInQueueCsv,
    'selected_rows_not_in_queue_csv_sha256: ' + $NotInQueueSha,
    'report_path: ' + $ReportPath,
    'report_sha256: ' + $ReportSha,
    'print_path: ' + $PrintPath,
    'print_sha256: ' + $PrintSha,
    'contract_gate_passed: ' + $ContractGatePassed,
    'blocker_count: ' + $BlockerCount,
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $ReceiptPath -Lines $ReceiptLines
$ReceiptSha = Get-Sha256 -Path $ReceiptPath

Write-Host '=== 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB-001..006 COVERAGE ROLLUP V0.2 COMPLETE ==='
Write-Host ('v0_1_error_freeze_path: ' + $V01ErrorFreezePath)
Write-Host ('v0_1_error_freeze_sha256: ' + $V01ErrorFreezeSha)
Write-Host ('fix_note_path: ' + $FixNotePath)
Write-Host ('fix_note_sha256: ' + $FixNoteSha)
Write-Host ('fix_receipt_path: ' + $FixReceiptPath)
Write-Host ('fix_receipt_sha256: ' + $FixReceiptSha)
Write-Host ('output_batch_summary_csv_path: ' + $BatchSummaryCsv)
Write-Host ('output_batch_summary_csv_sha256: ' + $BatchSummarySha)
Write-Host ('output_row_coverage_csv_path: ' + $CoverageCsv)
Write-Host ('output_row_coverage_csv_sha256: ' + $CoverageSha)
Write-Host ('output_selected_rows_not_in_queue_csv_path: ' + $NotInQueueCsv)
Write-Host ('output_selected_rows_not_in_queue_csv_sha256: ' + $NotInQueueSha)
Write-Host ('output_report_path: ' + $ReportPath)
Write-Host ('output_report_sha256: ' + $ReportSha)
Write-Host ('output_print_path: ' + $PrintPath)
Write-Host ('output_print_sha256: ' + $PrintSha)
Write-Host ('output_receipt_path: ' + $ReceiptPath)
Write-Host ('output_receipt_sha256: ' + $ReceiptSha)
Write-Host ('contract_gate_passed: ' + $ContractGatePassed)
Write-Host ('queue_csv_verified: ' + $QueueFound)
Write-Host ('queue_rows: ' + $QueueRowsCount)
Write-Host ('unique_queue_key_count: ' + $UniqueQueueKeyCount)
Write-Host ('queue_duplicate_key_count: ' + $QueueDuplicateKeyCount)
Write-Host ('hsrb_selected_batch_files_found: ' + $BatchFilesFoundCount)
Write-Host ('missing_hsrb_selected_batch_file_count: ' + $MissingBatchCount)
Write-Host ('selected_rows_raw_total: ' + $SelectedRowsRaw)
Write-Host ('covered_queue_row_count: ' + $Covered)
Write-Host ('uncovered_queue_row_count: ' + $Uncovered)
Write-Host ('duplicate_coverage_queue_row_count: ' + $DuplicateCoverage)
Write-Host ('selected_rows_not_in_queue_count: ' + $SelectedRowsNotInQueueCount)
Write-Host ('action_authority_count: 0')
Write-Host ('route_clearance_count: 0')
Write-Host ('cleanup_clearance_count: 0')
Write-Host ('execution_clearance_count: 0')
Write-Host ('doctrine_promotion_count: 0')
Write-Host ('recursive_dry_run_expansion_required_count: ' + $QueueRowsCount)
Write-Host ('whole_house_clearance_grant_count: ' + $WholeHouseClearanceGrantCount)
Write-Host ('whole_house_clearance_boundary_explicit_count: ' + $WholeHouseClearanceBoundaryExplicitCount)
Write-Host ('blocker_count: ' + $BlockerCount)
Write-Host ('blockers: ' + $(if ($BlockerCount -eq 0) { 'NONE' } else { ((ConvertTo-ObjectArray -Value $Blockers) -join ';') }))
Write-Host ('next_single_action: ' + $NextSingleAction)
Write-Host ('final_verdict: ' + $FinalVerdict)
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

if (-not $ContractGatePassed) { exit 2 }
exit 0
