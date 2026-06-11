Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_20260609_V0_3.ps1
# Purpose: review-only coverage rollup for the 64-row helper script review queue across HSRB-001..HSRB-006.
# Repair scope: freezes V0.1 and V0.2 runner collection/count failures; replaces fragile array/Count patterns with explicit List counters.
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

function New-ObjectList {
    return (New-Object System.Collections.Generic.List[object])
}

function ConvertTo-ObjectList {
    param([AllowNull()][object]$Value)
    $list = New-Object System.Collections.Generic.List[object]
    if ($null -eq $Value) { return $list }
    if ($Value -is [string]) {
        $list.Add($Value) | Out-Null
        return $list
    }
    if ($Value -is [System.Collections.IEnumerable]) {
        foreach ($item in $Value) { $list.Add($item) | Out-Null }
        return $list
    }
    $list.Add($Value) | Out-Null
    return $list
}

function ConvertTo-StringList {
    param([AllowNull()][object]$Value)
    $list = New-Object System.Collections.Generic.List[string]
    if ($null -eq $Value) { return $list }
    if ($Value -is [string]) {
        if (-not [string]::IsNullOrWhiteSpace($Value)) { $list.Add($Value) | Out-Null }
        return $list
    }
    if ($Value -is [System.Collections.IEnumerable]) {
        foreach ($item in $Value) {
            if ($null -ne $item) {
                $s = [string]$item
                if (-not [string]::IsNullOrWhiteSpace($s)) { $list.Add($s) | Out-Null }
            }
        }
        return $list
    }
    $single = [string]$Value
    if (-not [string]::IsNullOrWhiteSpace($single)) { $list.Add($single) | Out-Null }
    return $list
}

function Get-UniqueSortedStringList {
    param([AllowNull()][object]$Value)
    $inputList = ConvertTo-StringList -Value $Value
    $seen = @{}
    foreach ($item in $inputList) {
        if (-not $seen.ContainsKey($item)) { $seen[$item] = $true }
    }
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($key in ($seen.Keys | Sort-Object)) { $out.Add([string]$key) | Out-Null }
    return $out
}

function Get-PropValue {
    param(
        [Parameter(Mandatory=$true)]$Row,
        [Parameter(Mandatory=$true)][string[]]$Names
    )
    $props = ConvertTo-ObjectList -Value $Row.PSObject.Properties
    foreach ($name in $Names) {
        foreach ($prop in $props) {
            if ($prop.Name -ieq $name) {
                $value = [string]$prop.Value
                if (-not [string]::IsNullOrWhiteSpace($value)) { return $value.Trim() }
            }
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
    $list = New-Object System.Collections.Generic.List[object]
    if (-not (Test-Path -LiteralPath $Path)) { return $list }
    $rows = Import-Csv -LiteralPath $Path
    foreach ($row in (ConvertTo-ObjectList -Value $rows)) { $list.Add($row) | Out-Null }
    return $list
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
    param([Parameter(Mandatory=$true)]$Files)
    $latest = @{}
    foreach ($file in (ConvertTo-ObjectList -Value $Files)) {
        $batch = Get-BatchNumberFromName -Name $file.Name
        if ([string]::IsNullOrWhiteSpace($batch)) { continue }
        $batchInt = [int]$batch
        if ($batchInt -lt 1 -or $batchInt -gt 6) { continue }
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
$V02ErrorFreezePath = Join-Path $SurfaceDir 'ERROR_FREEZE__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_2_COUNT_PROPERTY_FAILURE_20260609.md'
$FixNotePath = Join-Path $SurfaceDir 'FIX_NOTE__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_3_EXPLICIT_LIST_COUNTERS_20260609.md'
$FixReceiptPath = Join-Path $SurfaceDir 'HASH_RECEIPT__64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_3_REPAIR_20260609.txt'

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
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $V01ErrorFreezePath -Lines $V01FreezeLines
$V01ErrorFreezeSha = Get-Sha256 -Path $V01ErrorFreezePath

$V02FreezeLines = @(
    '# ERROR FREEZE - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.2 COUNT PROPERTY FAILURE',
    '',
    'failed_script: BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_20260609_V0_2.ps1',
    'failed_line: 313',
    'failed_statement: $batchCount = (ConvertTo-ObjectArray -Value ($batches | Sort-Object -Unique)).Count',
    "error: The property 'Count' cannot be found on this object. Verify that the property exists.",
    '',
    'classification: RUNNER_COUNT_ON_SCALAR_OR_PIPE_OUTPUT_DEFECT',
    'scope: coverage rollup runner only; no route, cleanup, execution, commit, push, or physical action was authorized or observed',
    'does_not_prove: does not prove the 64-row queue is uncovered, duplicated, or damaged',
    'required_repair: avoid Count on pipeline/scalar output; build explicit list collections and count those lists only',
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $V02ErrorFreezePath -Lines $V02FreezeLines
$V02ErrorFreezeSha = Get-Sha256 -Path $V02ErrorFreezePath

$FixNoteLines = @(
    '# FIX NOTE - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.3 EXPLICIT LIST COUNTERS',
    '',
    'repair_scope: replace fragile array-subexpression enumeration and Count-on-pipeline/scalar patterns with explicit Generic.List objects and explicit counters',
    'repeated_failure_classification: POSSIBLE_UNDERLYING_DEFECT_IN_GENERATED_COLLECTION_HELPER_PATTERN_UNTIL_V0_3_PROVES_PASS',
    'preserves_contract: yes',
    'preserves_no_execution_boundary: yes',
    'preserves_no_route_cleanup_boundary: yes',
    'coverage_result_authority: V0.3 output only; V0.1 and V0.2 failed before producing valid coverage results',
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $FixNotePath -Lines $FixNoteLines
$FixNoteSha = Get-Sha256 -Path $FixNotePath

$FixReceiptLines = @(
    'HASH RECEIPT - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.3 REPAIR',
    'v0_1_error_freeze_path: ' + $V01ErrorFreezePath,
    'v0_1_error_freeze_sha256: ' + $V01ErrorFreezeSha,
    'v0_2_error_freeze_path: ' + $V02ErrorFreezePath,
    'v0_2_error_freeze_sha256: ' + $V02ErrorFreezeSha,
    'fix_note_path: ' + $FixNotePath,
    'fix_note_sha256: ' + $FixNoteSha,
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
Write-LinesUtf8 -Path $FixReceiptPath -Lines $FixReceiptLines
$FixReceiptSha = Get-Sha256 -Path $FixReceiptPath

$AllCsvFiles = ConvertTo-ObjectList -Value (Get-ChildItem -LiteralPath $SurfaceDir -File -Filter '*.csv')
$QueueCandidates = New-Object System.Collections.Generic.List[object]
foreach ($file in $AllCsvFiles) {
    if ($file.Name -match 'HELPER_SCRIPT_REVIEW_QUEUE_FROM_64_REVIEW_ROWS' -and $file.Name -notmatch 'SELECTED_BATCH' -and $file.Name -notmatch 'REMAINING_AFTER' -and $file.Name -notmatch 'SUMMARY' -and $file.Name -notmatch 'ROLLUP') {
        $QueueCandidates.Add($file) | Out-Null
    }
}
if ($QueueCandidates.Count -eq 0) {
    foreach ($file in $AllCsvFiles) {
        if ($file.Name -match '64' -and $file.Name -match 'QUEUE' -and $file.Name -notmatch 'SELECTED_BATCH' -and $file.Name -notmatch 'REMAINING_AFTER' -and $file.Name -notmatch 'SUMMARY' -and $file.Name -notmatch 'ROLLUP') {
            $QueueCandidates.Add($file) | Out-Null
        }
    }
}
$QueueFile = $null
foreach ($file in ($QueueCandidates | Sort-Object @{Expression={Get-VersionNumber -Name $_.Name};Descending=$true}, LastWriteTime -Descending)) {
    $QueueFile = $file
    break
}

$SelectedCandidates = New-Object System.Collections.Generic.List[object]
foreach ($file in $AllCsvFiles) {
    if ($file.Name -match 'SELECTED_BATCH' -and $file.Name -notmatch 'REMAINING_AFTER' -and $file.Name -notmatch 'ROLLUP') {
        $SelectedCandidates.Add($file) | Out-Null
    }
}
$LatestByBatch = Select-LatestByBatch -Files $SelectedCandidates

$BatchFiles = New-Object System.Collections.Generic.List[object]
for ($i = 1; $i -le 6; $i++) {
    $key = $i.ToString('000')
    if ($LatestByBatch.ContainsKey($key)) {
        $selected = $LatestByBatch[$key]
        $BatchFiles.Add([pscustomobject]@{
            BatchId = ('HSRB-' + $key)
            BatchNumber = $key
            Path = $selected.File.FullName
            FileName = $selected.File.Name
            VersionNumber = $selected.Version
            SHA256 = Get-Sha256 -Path $selected.File.FullName
        }) | Out-Null
    }
}

$QueueRows = New-Object System.Collections.Generic.List[object]
$QueueFound = $false
$QueueSha = ''
$QueuePathOut = 'MISSING'
if ($null -ne $QueueFile) {
    $QueueFound = $true
    $QueuePathOut = $QueueFile.FullName
    $QueueRows = Import-CsvRows -Path $QueueFile.FullName
    $QueueSha = Get-Sha256 -Path $QueueFile.FullName
}

$QueueKeyToRows = @{}
$QueueDuplicateKeys = New-Object System.Collections.Generic.List[string]
$queueOrdinal = 0
foreach ($row in $QueueRows) {
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

foreach ($batchFile in $BatchFiles) {
    $rowsArray = Import-CsvRows -Path $batchFile.Path
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
    $uniqueBatches = Get-UniqueSortedStringList -Value $Coverage[$key]
    $uniqueBatchArray = $uniqueBatches.ToArray()
    $batchList = [string]::Join(';', $uniqueBatchArray)
    $batchCount = $uniqueBatches.Count
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

$BatchSummaryCsv = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_BATCH_SUMMARY_NO_EXECUTION_V0_3_20260609.csv'
$CoverageCsv = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_ROW_COVERAGE_NO_EXECUTION_V0_3_20260609.csv'
$NotInQueueCsv = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_SELECTED_ROWS_NOT_IN_QUEUE_NO_EXECUTION_V0_3_20260609.csv'
$ReportPath = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_V0_3_20260609.md'
$PrintPath = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_COPY_PRINT_V0_3_20260609.txt'
$ReceiptPath = Join-Path $SurfaceDir 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_NO_EXECUTION_RECEIPT_V0_3_20260609.txt'

Write-CsvUtf8 -Path $BatchSummaryCsv -Rows $BatchSummary.ToArray()
Write-CsvUtf8 -Path $CoverageCsv -Rows $CoverageRows.ToArray()
Write-CsvUtf8 -Path $NotInQueueCsv -Rows $SelectedRowsNotInQueue.ToArray()

$QueueRowsCount = $QueueRows.Count
$UniqueQueueKeyCount = $QueueKeyToRows.Keys.Count
$BatchFilesFoundCount = $BatchFiles.Count
$MissingBatchCount = 6 - $BatchFilesFoundCount
$SelectedRowsNotInQueueCount = $SelectedRowsNotInQueue.Count
$QueueDuplicateKeyUniqueList = Get-UniqueSortedStringList -Value $QueueDuplicateKeys
$QueueDuplicateKeyCount = $QueueDuplicateKeyUniqueList.Count
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

$BlockerCount = $Blockers.Count
$ContractGatePassed = ($BlockerCount -eq 0)
$NextSingleAction = if ($ContractGatePassed) { 'BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_CLOSEOUT_NO_EXECUTION' } else { 'STOP_AND_REVIEW_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_COVERAGE_ROLLUP_BLOCKERS_NO_EXECUTION' }
$FinalVerdict = if ($ContractGatePassed) { 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_3_VERIFIED_ALL_64_ROWS_COVERED_ONCE_REVIEW_ONLY_NO_PHYSICAL_ACTION' } else { 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_COVERAGE_ROLLUP_V0_3_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }
$BlockerStringList = ConvertTo-StringList -Value $Blockers
$BlockersText = if ($BlockerCount -eq 0) { 'NONE' } else { [string]::Join(';', $BlockerStringList.ToArray()) }

$BatchSummarySha = Get-Sha256 -Path $BatchSummaryCsv
$CoverageSha = Get-Sha256 -Path $CoverageCsv
$NotInQueueSha = Get-Sha256 -Path $NotInQueueCsv

$ReportLines = @(
    '# 64-ROW HELPER SCRIPT REVIEW QUEUE HSRB-001..006 COVERAGE ROLLUP V0.3',
    '',
    'Status: REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH',
    '',
    'Purpose: confirm whether HSRB-001 through HSRB-006 cover the 64-row helper script review queue exactly once, without converting any source action wording into action authority.',
    '',
    '## Inputs',
    '',
    '- queue_csv_path: ' + $QueuePathOut,
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
    '## Repair freezes',
    '',
    '- v0_1_error_freeze_path: ' + $V01ErrorFreezePath,
    '- v0_1_error_freeze_sha256: ' + $V01ErrorFreezeSha,
    '- v0_2_error_freeze_path: ' + $V02ErrorFreezePath,
    '- v0_2_error_freeze_sha256: ' + $V02ErrorFreezeSha,
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
    '- blockers: ' + $BlockersText,
    '- next_single_action: ' + $NextSingleAction,
    '- final_verdict: ' + $FinalVerdict,
    '- physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)

Write-LinesUtf8 -Path $ReportPath -Lines $ReportLines
Write-LinesUtf8 -Path $PrintPath -Lines $ReportLines

$ReportSha = Get-Sha256 -Path $ReportPath
$PrintSha = Get-Sha256 -Path $PrintPath

$ReceiptLines = @(
    'HASH RECEIPT - 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB 001 006 COVERAGE ROLLUP V0.3',
    'v0_1_error_freeze_path: ' + $V01ErrorFreezePath,
    'v0_1_error_freeze_sha256: ' + $V01ErrorFreezeSha,
    'v0_2_error_freeze_path: ' + $V02ErrorFreezePath,
    'v0_2_error_freeze_sha256: ' + $V02ErrorFreezeSha,
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

Write-Host '=== 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB-001..006 COVERAGE ROLLUP V0.3 COMPLETE ==='
Write-Host ('v0_1_error_freeze_path: ' + $V01ErrorFreezePath)
Write-Host ('v0_1_error_freeze_sha256: ' + $V01ErrorFreezeSha)
Write-Host ('v0_2_error_freeze_path: ' + $V02ErrorFreezePath)
Write-Host ('v0_2_error_freeze_sha256: ' + $V02ErrorFreezeSha)
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
Write-Host ('blockers: ' + $BlockersText)
Write-Host ('next_single_action: ' + $NextSingleAction)
Write-Host ('final_verdict: ' + $FinalVerdict)
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'

if (-not $ContractGatePassed) { exit 2 }
exit 0
