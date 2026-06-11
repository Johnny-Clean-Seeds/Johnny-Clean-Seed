<#
BUILD_64_ROW_HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_INPUT_SURFACE_DIAGNOSTIC_NO_EXECUTION_20260609_V0_2.ps1
Purpose: Tiny input-surface diagnostic after repeated generated collection helper failures.
Scope: NO coverage verdict. NO route/cleanup/execution. Writes diagnostic files only.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RunStamp = '20260609'
$Root = Join-Path $env:USERPROFILE 'Desktop\123'
$LaneDir = Join-Path $Root 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'

if (-not (Test-Path -LiteralPath $LaneDir -PathType Container)) {
    throw "Lane directory not found: $LaneDir"
}

$OutPrefix = 'HELPER_SCRIPT_REVIEW_QUEUE_HSRB_001_006_INPUT_SURFACE_DIAGNOSTIC_NO_EXECUTION_V0_2_20260609'
$OutputCsvPath = Join-Path $LaneDir ($OutPrefix + '.csv')
$OutputMdPath = Join-Path $LaneDir ($OutPrefix + '.md')
$OutputPrintPath = Join-Path $LaneDir ($OutPrefix + '_COPY_PRINT.txt')
$OutputReceiptPath = Join-Path $LaneDir ($OutPrefix + '_RECEIPT.txt')
$FixNotePath = Join-Path $LaneDir 'FIX_NOTE__HSRB_001_006_INPUT_SURFACE_DIAGNOSTIC_V0_2_COLLECTION_CONTRACT_REDESIGN_20260609.md'
$FixReceiptPath = Join-Path $LaneDir 'HASH_RECEIPT__HSRB_001_006_INPUT_SURFACE_DIAGNOSTIC_V0_2_REPAIR_20260609.txt'
$FreezePath = Join-Path $LaneDir 'ERROR_FREEZE__HSRB_001_006_COVERAGE_ROLLUP_AND_DIAGNOSTIC_COLLECTION_FAILURES_20260609.md'

function Add-Line {
    param(
        [Parameter(Mandatory=$true)] [System.Collections.Generic.List[string]] $Target,
        [Parameter(Mandatory=$false)] [AllowEmptyString()] [string] $Text = ''
    )
    [void]$Target.Add($Text)
}

function Write-LinesUtf8 {
    param(
        [Parameter(Mandatory=$true)] [string] $Path,
        [Parameter(Mandatory=$true)] [System.Collections.Generic.List[string]] $Lines
    )
    if ($null -eq $Lines) { throw "Lines list is null for $Path" }
    $Encoding = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($Path, $Lines.ToArray(), $Encoding)
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)] [string] $Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Read-CsvRowsIntoList {
    param(
        [Parameter(Mandatory=$true)] [string] $Path,
        [Parameter(Mandatory=$true)] [System.Collections.Generic.List[object]] $Target
    )
    if ($null -eq $Target) { throw "Target row list is null" }
    Import-Csv -LiteralPath $Path | ForEach-Object { [void]$Target.Add($_) }
}

# Freeze the known failures in one file. Do not infer coverage from these failures.
$FreezeLines = [System.Collections.Generic.List[string]]::new()
Add-Line -Target $FreezeLines -Text '# ERROR FREEZE: HSRB-001..006 COVERAGE/DIAGNOSTIC HELPER FAILURES'
Add-Line -Target $FreezeLines -Text ''
Add-Line -Target $FreezeLines -Text 'status: GENERATED_POWERSHELL_COLLECTION_CONTRACT_DEFECT'
Add-Line -Target $FreezeLines -Text 'coverage_verdict_produced: False'
Add-Line -Target $FreezeLines -Text 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Add-Line -Target $FreezeLines -Text ''
Add-Line -Target $FreezeLines -Text 'failure_1: COVERAGE_ROLLUP_V0_1 line 210 foreach ($batchFile in @($BatchFiles)) -> Argument types do not match'
Add-Line -Target $FreezeLines -Text 'failure_2: COVERAGE_ROLLUP_V0_2 line 313 .Count -> property Count cannot be found'
Add-Line -Target $FreezeLines -Text 'failure_3: COVERAGE_ROLLUP_V0_3 line 373 .ToArray() -> System.String does not contain ToArray'
Add-Line -Target $FreezeLines -Text 'failure_4: INPUT_SURFACE_DIAGNOSTIC_V0_1 line 147 Add-Line $freeze1 -> Lines was null'
Add-Line -Target $FreezeLines -Text ''
Add-Line -Target $FreezeLines -Text 'does_not_prove: queue damage, duplicate coverage, missing coverage, route action, cleanup action, execution action, commit, push, delete, move, or rename'
Write-LinesUtf8 -Path $FreezePath -Lines $FreezeLines
$FreezeSha = Get-Sha256 -Path $FreezePath

$FixLines = [System.Collections.Generic.List[string]]::new()
Add-Line -Target $FixLines -Text '# FIX NOTE: INPUT SURFACE DIAGNOSTIC V0.2 COLLECTION CONTRACT REDESIGN'
Add-Line -Target $FixLines -Text ''
Add-Line -Target $FixLines -Text 'change: replaces coverage math with tiny input-surface reader only'
Add-Line -Target $FixLines -Text 'change: uses caller-owned generic lists; no returned empty collections'
Add-Line -Target $FixLines -Text 'change: line buffers are initialized before Add-Line'
Add-Line -Target $FixLines -Text 'change: no .Count assumption on ambiguous pipeline output'
Add-Line -Target $FixLines -Text 'change: no coverage verdict is produced'
Add-Line -Target $FixLines -Text 'scope: diagnostic only; no execution/route/cleanup authority'
Write-LinesUtf8 -Path $FixNotePath -Lines $FixLines
$FixNoteSha = Get-Sha256 -Path $FixNotePath

$BatchIds = [string[]]@('001','002','003','004','005','006')
$RowsOut = [System.Collections.Generic.List[object]]::new()
$CandidateFileCount = 0
$CsvReadErrorCount = 0
$TotalCandidateRows = 0
$MissingBatchMarkerCount = 0
$DuplicateBatchMarkerCount = 0
$ExpectedBatchMarkerCount = 6

foreach ($BatchId in $BatchIds) {
    $PatternA = "*HSRB_$BatchId*SELECTED*BATCH*.csv"
    $PatternB = "*SELECTED*BATCH*$BatchId*.csv"
    $FilesForBatch = [System.Collections.Generic.List[object]]::new()

    Get-ChildItem -LiteralPath $LaneDir -File -Filter $PatternA | ForEach-Object { [void]$FilesForBatch.Add($_) }
    Get-ChildItem -LiteralPath $LaneDir -File -Filter $PatternB | ForEach-Object {
        $Already = $false
        foreach ($Existing in $FilesForBatch) {
            if ($Existing.FullName -eq $_.FullName) { $Already = $true }
        }
        if (-not $Already) { [void]$FilesForBatch.Add($_) }
    }

    if ($FilesForBatch.Count -eq 0) { $MissingBatchMarkerCount++ }
    if ($FilesForBatch.Count -gt 1) { $DuplicateBatchMarkerCount++ }

    foreach ($FileObj in $FilesForBatch) {
        $CandidateFileCount++
        $FileRows = [System.Collections.Generic.List[object]]::new()
        $ReadStatus = 'READ_OK'
        $ReadError = ''
        try {
            Read-CsvRowsIntoList -Path $FileObj.FullName -Target $FileRows
        } catch {
            $CsvReadErrorCount++
            $ReadStatus = 'READ_ERROR'
            $ReadError = $_.Exception.Message
        }
        $RowCount = $FileRows.Count
        $TotalCandidateRows += $RowCount
        $Sha = ''
        try { $Sha = Get-Sha256 -Path $FileObj.FullName } catch { $Sha = '' }

        [void]$RowsOut.Add([pscustomobject]@{
            BatchId = ('HSRB-' + $BatchId)
            CandidateFileName = $FileObj.Name
            CandidateFilePath = $FileObj.FullName
            CandidateFileSha256 = $Sha
            CsvReadStatus = $ReadStatus
            CsvReadError = $ReadError
            RowCount = $RowCount
            DiagnosticOnly = 'YES'
            CoverageVerdictProduced = 'NO'
            WholeHouseClearanceGrant = 'NO'
            PhysicalActionAuthority = 'NO'
        })
    }
}

$RowsOut | Export-Csv -LiteralPath $OutputCsvPath -NoTypeInformation -Encoding UTF8
$OutputCsvSha = Get-Sha256 -Path $OutputCsvPath

$ContractGatePassed = $true
$BlockerCount = 0
if ($CsvReadErrorCount -ne 0) { $ContractGatePassed = $false; $BlockerCount++ }
if ($CandidateFileCount -lt 1) { $ContractGatePassed = $false; $BlockerCount++ }

$MdLines = [System.Collections.Generic.List[string]]::new()
Add-Line -Target $MdLines -Text '# HSRB-001..006 INPUT SURFACE DIAGNOSTIC V0.2'
Add-Line -Target $MdLines -Text ''
Add-Line -Target $MdLines -Text 'status: DIAGNOSTIC_ONLY_NO_COVERAGE_VERDICT'
Add-Line -Target $MdLines -Text ('contract_gate_passed: ' + $ContractGatePassed)
Add-Line -Target $MdLines -Text ('candidate_selected_batch_csv_count: ' + $CandidateFileCount)
Add-Line -Target $MdLines -Text ('batch_marker_count_expected: ' + $ExpectedBatchMarkerCount)
Add-Line -Target $MdLines -Text ('missing_batch_marker_count: ' + $MissingBatchMarkerCount)
Add-Line -Target $MdLines -Text ('duplicate_batch_marker_count: ' + $DuplicateBatchMarkerCount)
Add-Line -Target $MdLines -Text ('total_candidate_selected_rows: ' + $TotalCandidateRows)
Add-Line -Target $MdLines -Text ('csv_read_error_count: ' + $CsvReadErrorCount)
Add-Line -Target $MdLines -Text 'coverage_verdict_produced: False'
Add-Line -Target $MdLines -Text 'whole_house_clearance_grant_count: 0'
Add-Line -Target $MdLines -Text ('blocker_count: ' + $BlockerCount)
Add-Line -Target $MdLines -Text 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Add-Line -Target $MdLines -Text ''
Add-Line -Target $MdLines -Text '## Candidate selected-batch CSV files'
Add-Line -Target $MdLines -Text ''
foreach ($Row in $RowsOut) {
    Add-Line -Target $MdLines -Text ('- ' + $Row.BatchId + ' | rows=' + $Row.RowCount + ' | file=' + $Row.CandidateFileName)
}
Add-Line -Target $MdLines -Text ''
Add-Line -Target $MdLines -Text 'final_verdict: INPUT_SURFACE_DIAGNOSTIC_WRITTEN_AFTER_COLLECTION_HELPER_FAILURES_NO_COVERAGE_VERDICT_NO_PHYSICAL_ACTION'
Write-LinesUtf8 -Path $OutputMdPath -Lines $MdLines
$OutputMdSha = Get-Sha256 -Path $OutputMdPath
Copy-Item -LiteralPath $OutputMdPath -Destination $OutputPrintPath -Force
$OutputPrintSha = Get-Sha256 -Path $OutputPrintPath

$FixReceiptLines = [System.Collections.Generic.List[string]]::new()
Add-Line -Target $FixReceiptLines -Text ('freeze_path: ' + $FreezePath)
Add-Line -Target $FixReceiptLines -Text ('freeze_sha256: ' + $FreezeSha)
Add-Line -Target $FixReceiptLines -Text ('fix_note_path: ' + $FixNotePath)
Add-Line -Target $FixReceiptLines -Text ('fix_note_sha256: ' + $FixNoteSha)
Write-LinesUtf8 -Path $FixReceiptPath -Lines $FixReceiptLines
$FixReceiptSha = Get-Sha256 -Path $FixReceiptPath

$ReceiptLines = [System.Collections.Generic.List[string]]::new()
Add-Line -Target $ReceiptLines -Text ('output_csv_path: ' + $OutputCsvPath)
Add-Line -Target $ReceiptLines -Text ('output_csv_sha256: ' + $OutputCsvSha)
Add-Line -Target $ReceiptLines -Text ('output_md_path: ' + $OutputMdPath)
Add-Line -Target $ReceiptLines -Text ('output_md_sha256: ' + $OutputMdSha)
Add-Line -Target $ReceiptLines -Text ('output_print_path: ' + $OutputPrintPath)
Add-Line -Target $ReceiptLines -Text ('output_print_sha256: ' + $OutputPrintSha)
Write-LinesUtf8 -Path $OutputReceiptPath -Lines $ReceiptLines
$OutputReceiptSha = Get-Sha256 -Path $OutputReceiptPath

Write-Output '=== HSRB-001..006 INPUT SURFACE DIAGNOSTIC V0.2 COMPLETE ==='
Write-Output ("failure_freeze_path: $FreezePath")
Write-Output ("failure_freeze_sha256: $FreezeSha")
Write-Output ("fix_note_path: $FixNotePath")
Write-Output ("fix_note_sha256: $FixNoteSha")
Write-Output ("fix_receipt_path: $FixReceiptPath")
Write-Output ("fix_receipt_sha256: $FixReceiptSha")
Write-Output ("output_csv_path: $OutputCsvPath")
Write-Output ("output_csv_sha256: $OutputCsvSha")
Write-Output ("output_md_path: $OutputMdPath")
Write-Output ("output_md_sha256: $OutputMdSha")
Write-Output ("output_print_path: $OutputPrintPath")
Write-Output ("output_print_sha256: $OutputPrintSha")
Write-Output ("output_receipt_path: $OutputReceiptPath")
Write-Output ("output_receipt_sha256: $OutputReceiptSha")
Write-Output ("contract_gate_passed: $ContractGatePassed")
Write-Output ("candidate_selected_batch_csv_count: $CandidateFileCount")
Write-Output ("batch_marker_count_expected: $ExpectedBatchMarkerCount")
Write-Output ("missing_batch_marker_count: $MissingBatchMarkerCount")
Write-Output ("duplicate_batch_marker_count: $DuplicateBatchMarkerCount")
Write-Output ("total_candidate_selected_rows: $TotalCandidateRows")
Write-Output ("csv_read_error_count: $CsvReadErrorCount")
Write-Output 'coverage_verdict_produced: False'
Write-Output 'whole_house_clearance_grant_count: 0'
Write-Output ("blocker_count: $BlockerCount")
Write-Output 'next_single_action: REVIEW_INPUT_SURFACE_DIAGNOSTIC_COUNTS_BEFORE_ANY_COVERAGE_REBUILD'
Write-Output 'final_verdict: INPUT_SURFACE_DIAGNOSTIC_WRITTEN_AFTER_COLLECTION_HELPER_FAILURES_NO_COVERAGE_VERDICT_NO_PHYSICAL_ACTION'
Write-Output 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
