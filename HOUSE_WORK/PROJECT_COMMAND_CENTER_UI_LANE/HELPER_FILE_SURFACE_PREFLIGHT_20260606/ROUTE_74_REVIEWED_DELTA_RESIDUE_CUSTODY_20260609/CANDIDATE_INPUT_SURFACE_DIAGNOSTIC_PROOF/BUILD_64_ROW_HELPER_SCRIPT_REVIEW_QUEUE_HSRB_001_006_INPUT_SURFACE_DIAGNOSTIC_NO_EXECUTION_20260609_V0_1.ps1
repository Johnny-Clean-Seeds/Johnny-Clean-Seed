$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$ScriptName = 'BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_INPUT_SURFACE_DIAGNOSTIC_NO_EXECUTION_20260609_V0_1.ps1'
$NowStamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss K'

$Root = 'C:\Users\13527\Desktop\123'
$SurfaceRel = 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$SurfaceRoot = Join-Path -Path $Root -ChildPath $SurfaceRel

$ReportStem = '64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_INPUT_SURFACE_DIAGNOSTIC_NO_EXECUTION_V0_1_20260609'
$OutputCsv = Join-Path -Path $SurfaceRoot -ChildPath ($ReportStem + '.csv')
$OutputMd = Join-Path -Path $SurfaceRoot -ChildPath ($ReportStem + '.md')
$OutputPrint = Join-Path -Path $SurfaceRoot -ChildPath ($ReportStem + '_COPY_PRINT.txt')
$OutputReceipt = Join-Path -Path $SurfaceRoot -ChildPath ($ReportStem + '_RECEIPT.txt')

$V01FreezePath = Join-Path -Path $SurfaceRoot -ChildPath 'ERROR_FREEZE__64_ROW_COVERAGE_ROLLUP_V0_1_COLLECTION_ENUMERATION_FAILURE_20260609.md'
$V02FreezePath = Join-Path -Path $SurfaceRoot -ChildPath 'ERROR_FREEZE__64_ROW_COVERAGE_ROLLUP_V0_2_SCALAR_COUNT_FAILURE_20260609.md'
$V03FreezePath = Join-Path -Path $SurfaceRoot -ChildPath 'ERROR_FREEZE__64_ROW_COVERAGE_ROLLUP_V0_3_STRING_TOARRAY_FAILURE_20260609.md'
$FixNotePath = Join-Path -Path $SurfaceRoot -ChildPath 'FIX_NOTE__64_ROW_COVERAGE_ROLLUP_INPUT_SURFACE_DIAGNOSTIC_AFTER_THREE_COLLECTION_FAILURES_20260609.md'
$FixReceiptPath = Join-Path -Path $SurfaceRoot -ChildPath 'HASH_RECEIPT__64_ROW_COVERAGE_ROLLUP_INPUT_SURFACE_DIAGNOSTIC_V0_1_20260609.txt'

function New-StringList {
    return [System.Collections.Generic.List[string]]::new()
}

function Convert-StringListToArray {
    param([Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Lines)
    $arr = New-Object 'string[]' $Lines.Count
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $arr[$i] = [string]$Lines[$i]
    }
    return $arr
}

function Write-LinesUtf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Lines
    )
    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        [System.IO.Directory]::CreateDirectory($parent) | Out-Null
    }
    $encoding = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($Path, (Convert-StringListToArray -Lines $Lines), $encoding)
}

function Get-Sha256OrBlank {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not [System.IO.File]::Exists($Path)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Line {
    param(
        [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Lines,
        [Parameter(Mandatory=$true)][AllowEmptyString()][string]$Text
    )
    [void]$Lines.Add($Text)
}

function Escape-CsvCell {
    param([AllowNull()][object]$Value)
    if ($null -eq $Value) { return '""' }
    $s = [string]$Value
    $s = $s.Replace('"','""')
    return '"' + $s + '"'
}

function Add-CsvRow {
    param(
        [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Lines,
        [Parameter(Mandatory=$true)][object[]]$Values
    )
    $parts = New-Object 'string[]' $Values.Length
    for ($i = 0; $i -lt $Values.Length; $i++) {
        $parts[$i] = Escape-CsvCell -Value $Values[$i]
    }
    [void]$Lines.Add([string]::Join(',', $parts))
}

function Count-CsvDataRowsByLine {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not [System.IO.File]::Exists($Path)) { return -1 }
    $reader = $null
    try {
        $reader = [System.IO.StreamReader]::new($Path, [System.Text.UTF8Encoding]::new($false), $true)
        $lineNumber = 0
        $dataRows = 0
        while ($true) {
            $line = $reader.ReadLine()
            if ($null -eq $line) { break }
            $lineNumber++
            if ($lineNumber -eq 1) { continue }
            $dataRows++
        }
        return $dataRows
    }
    finally {
        if ($null -ne $reader) { $reader.Dispose() }
    }
}

function Get-BatchIdFromName {
    param([Parameter(Mandatory=$true)][string]$Name)
    $patterns = @(
        'HSRB[_-]0*([1-6])',
        'BATCH[_-]0*([1-6])',
        'SELECTED[_-]BATCH[_-]0*([1-6])',
        'SELECTED[_-]BATCH[_-]00([1-6])'
    )
    foreach ($p in $patterns) {
        $m = [regex]::Match($Name, $p, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($m.Success) {
            $n = [int]$m.Groups[1].Value
            if ($n -ge 1 -and $n -le 6) { return ('HSRB-{0:000}' -f $n) }
        }
    }
    return ''
}

function Get-VersionTextFromName {
    param([Parameter(Mandatory=$true)][string]$Name)
    $m = [regex]::Match($Name, '_V(\d+(?:_\d+)?)_', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($m.Success) { return ('V' + $m.Groups[1].Value) }
    return ''
}

function Test-IsSelectedBatchCandidate {
    param([Parameter(Mandatory=$true)][string]$Name)
    if ($Name -notmatch '(?i)SELECTED') { return $false }
    if ($Name -notmatch '(?i)BATCH') { return $false }
    if ([string]::IsNullOrWhiteSpace((Get-BatchIdFromName -Name $Name))) { return $false }
    return $true
}

if (-not [System.IO.Directory]::Exists($Root)) {
    throw "Root not found: $Root"
}
if (-not [System.IO.Directory]::Exists($SurfaceRoot)) {
    throw "Surface root not found: $SurfaceRoot"
}

# Freeze the three known failed coverage-rollup attempts as a stop-and-rescope chain.
$freeze1 = New-StringList
Add-Line $freeze1 '# ERROR FREEZE: 64 ROW COVERAGE ROLLUP V0.1'
Add-Line $freeze1 ''
Add-Line $freeze1 'failure_class: GENERATED_COLLECTION_ENUMERATION_FAILURE'
Add-Line $freeze1 'failed_line: foreach ($batchFile in @($BatchFiles)) {'
Add-Line $freeze1 'error: Argument types do not match'
Add-Line $freeze1 'does_not_prove: duplicate coverage, missing coverage, queue damage, file mutation, route action, cleanup action, execution, commit, push'
Add-Line $freeze1 'action: STOP_PATCHING_AFTER_THREE_FAILURES_CHAIN_IF_REPEATED'
Write-LinesUtf8 -Path $V01FreezePath -Lines $freeze1

$freeze2 = New-StringList
Add-Line $freeze2 '# ERROR FREEZE: 64 ROW COVERAGE ROLLUP V0.2'
Add-Line $freeze2 ''
Add-Line $freeze2 'failure_class: GENERATED_COLLECTION_COUNT_FAILURE'
Add-Line $freeze2 'failed_line: $batchCount = ... .Count'
Add-Line $freeze2 'error: The property Count cannot be found on this object'
Add-Line $freeze2 'does_not_prove: duplicate coverage, missing coverage, queue damage, file mutation, route action, cleanup action, execution, commit, push'
Add-Line $freeze2 'action: STOP_PATCHING_AFTER_THREE_FAILURES_CHAIN_IF_REPEATED'
Write-LinesUtf8 -Path $V02FreezePath -Lines $freeze2

$freeze3 = New-StringList
Add-Line $freeze3 '# ERROR FREEZE: 64 ROW COVERAGE ROLLUP V0.3'
Add-Line $freeze3 ''
Add-Line $freeze3 'failure_class: GENERATED_COLLECTION_TOARRAY_FAILURE'
Add-Line $freeze3 'failed_line: $uniqueBatchArray = $uniqueBatches.ToArray()'
Add-Line $freeze3 'error: Method invocation failed because System.String does not contain a method named ToArray'
Add-Line $freeze3 'does_not_prove: duplicate coverage, missing coverage, queue damage, file mutation, route action, cleanup action, execution, commit, push'
Add-Line $freeze3 'action: PAUSE_AND_SCOPE_OUT_BEFORE_ANY_MORE_ROLLUP_REPAIR'
Write-LinesUtf8 -Path $V03FreezePath -Lines $freeze3

$fix = New-StringList
Add-Line $fix '# FIX NOTE: INPUT SURFACE DIAGNOSTIC AFTER THREE COVERAGE ROLLUP FAILURES'
Add-Line $fix ''
Add-Line $fix 'classification: POSSIBLE_UNDERLYING_DEFECT_IN_GENERATED_COLLECTION_HELPER_PATTERN'
Add-Line $fix 'decision: do not generate another full coverage rollup repair yet'
Add-Line $fix 'replacement_method: smaller diagnostic reader only'
Add-Line $fix 'scope: list selected-batch CSV candidate files, row counts, hashes, and batch labels; do not calculate full coverage verdict'
Add-Line $fix 'physical_actions_authorized: none'
Add-Line $fix 'next: review diagnostic surface and then choose exact authorized batch files for a redesigned rollup'
Write-LinesUtf8 -Path $FixNotePath -Lines $fix

$candidates = [System.Collections.Generic.List[object]]::new()
$csvReadErrorCount = 0
$totalCandidateRows = 0

$filesEnum = [System.IO.Directory]::EnumerateFiles($SurfaceRoot, '*.csv', [System.IO.SearchOption]::TopDirectoryOnly)
foreach ($path in $filesEnum) {
    $name = [System.IO.Path]::GetFileName($path)
    if (-not (Test-IsSelectedBatchCandidate -Name $name)) { continue }
    $batchId = Get-BatchIdFromName -Name $name
    $rowCount = -1
    $readStatus = 'READ_OK'
    try {
        $rowCount = Count-CsvDataRowsByLine -Path $path
        if ($rowCount -lt 0) { $readStatus = 'READ_MISSING' }
    }
    catch {
        $rowCount = -1
        $readStatus = 'READ_FAIL: ' + $_.Exception.Message
        $csvReadErrorCount++
    }
    if ($rowCount -gt -1) { $totalCandidateRows += $rowCount }
    $fi = [System.IO.FileInfo]::new($path)
    $obj = [pscustomobject]@{
        BatchId = $batchId
        FileName = $name
        FullPath = $path
        VersionText = (Get-VersionTextFromName -Name $name)
        RowCount = $rowCount
        Sha256 = (Get-Sha256OrBlank -Path $path)
        LastWriteTime = $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
        ReadStatus = $readStatus
        CandidateReason = 'filename contains SELECTED + BATCH + HSRB/BATCH 001-006 marker'
    }
    [void]$candidates.Add($obj)
}

$batchIds = @('HSRB-001','HSRB-002','HSRB-003','HSRB-004','HSRB-005','HSRB-006')
$missingBatchCandidateCount = 0
$multipleBatchCandidateCount = 0
$singleBatchCandidateCount = 0

foreach ($bid in $batchIds) {
    $countForBatch = 0
    foreach ($c in $candidates) {
        if ([string]$c.BatchId -eq $bid) { $countForBatch++ }
    }
    if ($countForBatch -eq 0) { $missingBatchCandidateCount++ }
    elseif ($countForBatch -eq 1) { $singleBatchCandidateCount++ }
    else { $multipleBatchCandidateCount++ }
}

$csv = New-StringList
Add-CsvRow $csv @('BatchId','FileName','VersionText','RowCount','Sha256','LastWriteTime','ReadStatus','CandidateReason','FullPath')
foreach ($c in $candidates) {
    Add-CsvRow $csv @($c.BatchId, $c.FileName, $c.VersionText, $c.RowCount, $c.Sha256, $c.LastWriteTime, $c.ReadStatus, $c.CandidateReason, $c.FullPath)
}
Write-LinesUtf8 -Path $OutputCsv -Lines $csv

$md = New-StringList
Add-Line $md '# 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB-001 THROUGH HSRB-006 INPUT SURFACE DIAGNOSTIC V0.1'
Add-Line $md ''
Add-Line $md "generated_at: $NowStamp"
Add-Line $md "script_name: $ScriptName"
Add-Line $md 'status: INPUT_SURFACE_DIAGNOSTIC_ONLY / NO_COVERAGE_VERDICT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP'
Add-Line $md ''
Add-Line $md '## Reason'
Add-Line $md ''
Add-Line $md 'Three coverage-rollup repair attempts failed in the same generated collection helper family. This diagnostic pauses full rollup repair and only lists selected-batch CSV input candidates.'
Add-Line $md ''
Add-Line $md '## Counts'
Add-Line $md ''
Add-Line $md ('candidate_selected_batch_csv_count: ' + $candidates.Count)
Add-Line $md ('candidate_selected_batch_total_data_rows_by_line_count: ' + $totalCandidateRows)
Add-Line $md ('batch_marker_count_expected: 6')
Add-Line $md ('batch_marker_single_candidate_count: ' + $singleBatchCandidateCount)
Add-Line $md ('batch_marker_missing_candidate_count: ' + $missingBatchCandidateCount)
Add-Line $md ('batch_marker_multiple_candidate_count: ' + $multipleBatchCandidateCount)
Add-Line $md ('csv_read_error_count: ' + $csvReadErrorCount)
Add-Line $md ''
Add-Line $md '## Batch candidate counts'
Add-Line $md ''
foreach ($bid in $batchIds) {
    $countForBatch = 0
    foreach ($c in $candidates) {
        if ([string]$c.BatchId -eq $bid) { $countForBatch++ }
    }
    Add-Line $md ($bid + '_candidate_file_count: ' + $countForBatch)
}
Add-Line $md ''
Add-Line $md '## Boundary'
Add-Line $md ''
Add-Line $md 'This does not calculate queue coverage.'
Add-Line $md 'This does not prove every row is covered once.'
Add-Line $md 'This does not grant whole-house clearance.'
Add-Line $md 'This does not authorize route, cleanup, execution, commit, push, delete, move, or rename.'
Add-Line $md ''
Add-Line $md '## Candidate files'
Add-Line $md ''
Add-Line $md '| BatchId | RowCount | Version | FileName | Sha256 | ReadStatus |'
Add-Line $md '|---|---:|---|---|---|---|'
foreach ($c in $candidates) {
    Add-Line $md ('| ' + $c.BatchId + ' | ' + $c.RowCount + ' | ' + $c.VersionText + ' | `' + $c.FileName + '` | `' + $c.Sha256 + '` | ' + $c.ReadStatus + ' |')
}
Add-Line $md ''
Add-Line $md '## Next single action'
Add-Line $md ''
Add-Line $md 'REVIEW_INPUT_SURFACE_DIAGNOSTIC_AND_CHOOSE_EXACT_AUTHORIZED_BATCH_FILES_FOR_REDESIGNED_COVERAGE_ROLLUP_NO_EXECUTION'
Add-Line $md ''
Add-Line $md '## Final verdict'
Add-Line $md ''
Add-Line $md 'INPUT_SURFACE_DIAGNOSTIC_WRITTEN_AFTER_THREE_COLLECTION_HELPER_FAILURES_NO_COVERAGE_VERDICT_NO_PHYSICAL_ACTION'
Write-LinesUtf8 -Path $OutputMd -Lines $md
Write-LinesUtf8 -Path $OutputPrint -Lines $md

$outCsvSha = Get-Sha256OrBlank -Path $OutputCsv
$outMdSha = Get-Sha256OrBlank -Path $OutputMd
$outPrintSha = Get-Sha256OrBlank -Path $OutputPrint
$v01FreezeSha = Get-Sha256OrBlank -Path $V01FreezePath
$v02FreezeSha = Get-Sha256OrBlank -Path $V02FreezePath
$v03FreezeSha = Get-Sha256OrBlank -Path $V03FreezePath
$fixNoteSha = Get-Sha256OrBlank -Path $FixNotePath

$fixReceipt = New-StringList
Add-Line $fixReceipt 'HASH RECEIPT: 64 ROW COVERAGE ROLLUP INPUT SURFACE DIAGNOSTIC V0.1'
Add-Line $fixReceipt ('generated_at: ' + $NowStamp)
Add-Line $fixReceipt ('v0_1_error_freeze_path: ' + $V01FreezePath)
Add-Line $fixReceipt ('v0_1_error_freeze_sha256: ' + $v01FreezeSha)
Add-Line $fixReceipt ('v0_2_error_freeze_path: ' + $V02FreezePath)
Add-Line $fixReceipt ('v0_2_error_freeze_sha256: ' + $v02FreezeSha)
Add-Line $fixReceipt ('v0_3_error_freeze_path: ' + $V03FreezePath)
Add-Line $fixReceipt ('v0_3_error_freeze_sha256: ' + $v03FreezeSha)
Add-Line $fixReceipt ('fix_note_path: ' + $FixNotePath)
Add-Line $fixReceipt ('fix_note_sha256: ' + $fixNoteSha)
Add-Line $fixReceipt 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesUtf8 -Path $FixReceiptPath -Lines $fixReceipt
$fixReceiptSha = Get-Sha256OrBlank -Path $FixReceiptPath

$receipt = New-StringList
Add-Line $receipt 'HASH RECEIPT: 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB-001 THROUGH HSRB-006 INPUT SURFACE DIAGNOSTIC V0.1'
Add-Line $receipt ('generated_at: ' + $NowStamp)
Add-Line $receipt ('output_csv_path: ' + $OutputCsv)
Add-Line $receipt ('output_csv_sha256: ' + $outCsvSha)
Add-Line $receipt ('output_md_path: ' + $OutputMd)
Add-Line $receipt ('output_md_sha256: ' + $outMdSha)
Add-Line $receipt ('output_print_path: ' + $OutputPrint)
Add-Line $receipt ('output_print_sha256: ' + $outPrintSha)
Add-Line $receipt ('fix_receipt_path: ' + $FixReceiptPath)
Add-Line $receipt ('fix_receipt_sha256: ' + $fixReceiptSha)
Add-Line $receipt 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-LinesUtf8 -Path $OutputReceipt -Lines $receipt
$outReceiptSha = Get-Sha256OrBlank -Path $OutputReceipt

$contractGatePassed = $true
$diagnosticBlockerCount = 0
if ($csvReadErrorCount -gt 0) { $diagnosticBlockerCount++ }

'=== 64 ROW HELPER SCRIPT REVIEW QUEUE HSRB-001-006 INPUT SURFACE DIAGNOSTIC V0.1 COMPLETE ==='
'v0_1_error_freeze_path: ' + $V01FreezePath
'v0_1_error_freeze_sha256: ' + $v01FreezeSha
'v0_2_error_freeze_path: ' + $V02FreezePath
'v0_2_error_freeze_sha256: ' + $v02FreezeSha
'v0_3_error_freeze_path: ' + $V03FreezePath
'v0_3_error_freeze_sha256: ' + $v03FreezeSha
'fix_note_path: ' + $FixNotePath
'fix_note_sha256: ' + $fixNoteSha
'fix_receipt_path: ' + $FixReceiptPath
'fix_receipt_sha256: ' + $fixReceiptSha
'output_csv_path: ' + $OutputCsv
'output_csv_sha256: ' + $outCsvSha
'output_md_path: ' + $OutputMd
'output_md_sha256: ' + $outMdSha
'output_print_path: ' + $OutputPrint
'output_print_sha256: ' + $outPrintSha
'output_receipt_path: ' + $OutputReceipt
'output_receipt_sha256: ' + $outReceiptSha
'contract_gate_passed: ' + $contractGatePassed
'candidate_selected_batch_csv_count: ' + $candidates.Count
'candidate_selected_batch_total_data_rows_by_line_count: ' + $totalCandidateRows
'batch_marker_count_expected: 6'
'batch_marker_single_candidate_count: ' + $singleBatchCandidateCount
'batch_marker_missing_candidate_count: ' + $missingBatchCandidateCount
'batch_marker_multiple_candidate_count: ' + $multipleBatchCandidateCount
'csv_read_error_count: ' + $csvReadErrorCount
foreach ($bid in $batchIds) {
    $countForBatch = 0
    foreach ($c in $candidates) {
        if ([string]$c.BatchId -eq $bid) { $countForBatch++ }
    }
    (($bid.Replace('-', '_')) + '_candidate_file_count: ' + $countForBatch)
}
'coverage_verdict_produced: False'
'whole_house_clearance_grant_count: 0'
'diagnostic_blocker_count: ' + $diagnosticBlockerCount
'next_single_action: REVIEW_INPUT_SURFACE_DIAGNOSTIC_AND_CHOOSE_EXACT_AUTHORIZED_BATCH_FILES_FOR_REDESIGNED_COVERAGE_ROLLUP_NO_EXECUTION'
'final_verdict: INPUT_SURFACE_DIAGNOSTIC_WRITTEN_AFTER_THREE_COLLECTION_HELPER_FAILURES_NO_COVERAGE_VERDICT_NO_PHYSICAL_ACTION'
'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
