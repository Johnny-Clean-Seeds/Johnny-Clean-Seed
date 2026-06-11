Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Base = 'C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606'
$RepoRoot = 'C:\Users\13527\Desktop\123'

$Expected = @(
    [pscustomobject]@{ Label='hsrb_004_selected_batch_csv'; File='HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_004_V0_1_20260609.csv'; Sha='CD5A144CFAB6A56FA37C3D83A3D63F70B18292D6DFF8D5AE8313C1F91A18C47D' },
    [pscustomobject]@{ Label='hsrb_004_selector_report_md'; File='HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_V0_1_20260609.md'; Sha='DA9BC5A0CB426ADA37739073610796F8EA99E195676C69501219DD2B5B171BCE' },
    [pscustomobject]@{ Label='hsrb_004_selector_receipt'; File='HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'; Sha='647FCE8F77E02DBE0E79895B3312F71863442430C35994F53721B343BA85BB56' },
    [pscustomobject]@{ Label='hsrb_004_static_summary_csv'; File='STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_SUMMARY_V0_1_20260609.csv'; Sha='B91829990D3AE011A8F7D8221487BC9302079ECF55CF722CE7C138DA67244C8C' },
    [pscustomobject]@{ Label='hsrb_004_static_packet_md'; File='STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_V0_1_20260609.md'; Sha='ACB93394A06256D4EC421E37233F7D64C04E8EF12AAA691B02D2B8FAAF175B8A' },
    [pscustomobject]@{ Label='hsrb_004_static_packet_receipt'; File='STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_RECEIPT_V0_1_20260609.txt'; Sha='7C55B2BBA90D4EAAB3A963843FFD8A5E579850577761C552A657145EA999AFF2' },
    [pscustomobject]@{ Label='hsrb_004_contract_closeout_risk_csv'; File='HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'; Sha='48C296DD5346E2D70B0AED39B3107B933072F26DE68CF3B03E151FB11B41D4B0' },
    [pscustomobject]@{ Label='hsrb_004_contract_closeout_md'; File='HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_V0_1_20260609.md'; Sha='6E1F661BAA33AD00B73A64E5C28B58AE981E1D20741EA958CA9F4A27AAF53BAE' },
    [pscustomobject]@{ Label='hsrb_004_contract_closeout_receipt'; File='HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_NO_EXECUTION_RECEIPT_V0_1_20260609.txt'; Sha='B3B78AB562CE6D4F759DCB53AB5C1D2A0C9391856C7A77C99195CEAFE0D2A999' }
)

function Get-Sha256([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Get-PropValue($Obj, [string[]]$Names) {
    if ($null -eq $Obj) { return '' }
    $props = @($Obj.PSObject.Properties.Name)
    foreach ($name in $Names) {
        if ($props -contains $name) {
            $v = $Obj.$name
            if ($null -ne $v) { return [string]$v }
        }
    }
    return ''
}

function To-BoolText([string]$Value) {
    if ([string]::IsNullOrWhiteSpace($Value)) { return 'False' }
    $v = $Value.Trim().ToLowerInvariant()
    if ($v -in @('true','1','yes','y')) { return 'True' }
    return 'False'
}

function BoolFromText([string]$Value) {
    return (To-BoolText $Value) -eq 'True'
}

function Find-SourcePath([string]$FileName, $RowA, $RowB, $RowC) {
    $candidateValues = @()
    $candidateValues += (Get-PropValue $RowA @('SourcePath','SourceFilePath','FullPath','FilePath','Path','ResolvedPath','LivePath'))
    $candidateValues += (Get-PropValue $RowB @('SourcePath','SourceFilePath','FullPath','FilePath','Path','ResolvedPath','LivePath'))
    $candidateValues += (Get-PropValue $RowC @('SourcePath','SourceFilePath','FullPath','FilePath','Path','ResolvedPath','LivePath'))
    foreach ($p in $candidateValues) {
        if (-not [string]::IsNullOrWhiteSpace($p) -and (Test-Path -LiteralPath $p -PathType Leaf)) { return $p }
    }
    if (-not [string]::IsNullOrWhiteSpace($FileName)) {
        $found = Get-ChildItem -LiteralPath $RepoRoot -Recurse -File -Filter $FileName -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -ne $found) { return $found.FullName }
    }
    return ''
}

function Get-DispositionBucket([string]$FileName, [string]$Disposition) {
    $f = $FileName.ToUpperInvariant()
    $d = $Disposition.ToUpperInvariant()
    if ($d -match 'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD' -or $f -match 'HELPER_FILE_SURFACE_PREFLIGHT.*LANE_CLOSEOUT_CARD') {
        return 'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_REVIEW_ONLY'
    }
    if ($d -match 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR' -or $f -match 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR') {
        return 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_REVIEW_ONLY'
    }
    if ($d -match 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY' -or $f -match 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY') {
        return 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY_REVIEW_ONLY'
    }
    return 'UNKNOWN_DISPOSITION_BUCKET'
}

function Count-Matching($Rows, [scriptblock]$Predicate) {
    $n = 0
    foreach ($row in $Rows) {
        if (& $Predicate $row) { $n++ }
    }
    return $n
}

function Read-CsvRows([string]$Path) {
    $rows = @()
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        foreach ($r in (Import-Csv -LiteralPath $Path)) { $rows += $r }
    }
    return $rows
}

function Write-Lines([string]$Path, [string[]]$Lines) {
    [System.IO.File]::WriteAllLines($Path, $Lines, [System.Text.UTF8Encoding]::new($false))
}

$v01ErrorFreezePath = Join-Path $Base 'ERROR_FREEZE__HSRB_004_DISPOSITION_INDEX_V0_1_LIST_ARRAY_ARGUMENT_TYPE_MISMATCH_20260609.md'
$v02ErrorFreezePath = Join-Path $Base 'ERROR_FREEZE__HSRB_004_DISPOSITION_INDEX_V0_2_VERIFY_ROWS_ARGUMENT_TYPE_MISMATCH_20260609.md'
$v03FixNotePath = Join-Path $Base 'FIX_NOTE__HSRB_004_DISPOSITION_INDEX_V0_3_ARRAY_ENUMERATION_REPAIR_20260609.md'
$v03FixReceiptPath = Join-Path $Base 'HASH_RECEIPT__HSRB_004_DISPOSITION_INDEX_V0_3_REPAIR_20260609.txt'

Write-Lines $v01ErrorFreezePath @(
    '# ERROR FREEZE - HSRB-004 Disposition Index V0.1',
    '',
    'Status: ERROR_FREEZE / SAME_OBJECT_REPAIR_REQUIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Observed failure: V0.1 stopped at line 208 on `$indexRowsArray = @($indexRows)` with `Argument types do not match`.',
    '',
    'Interpretation: generated helper-output defect in list-to-array conversion. HSRB-004 upstream selector, static packet, and contract-first decision closeout remain valid.',
    '',
    'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$v01ErrorFreezeSha = Get-Sha256 $v01ErrorFreezePath

Write-Lines $v02ErrorFreezePath @(
    '# ERROR FREEZE - HSRB-004 Disposition Index V0.2',
    '',
    'Status: ERROR_FREEZE / SAME_OBJECT_REPAIR_REQUIRED / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Observed failure: V0.2 stopped at line 328 on `foreach ($v in @($verifyRows))` with `Argument types do not match`.',
    '',
    'Interpretation: V0.2 fixed the first list-array defect but preserved another generated array-cast defect during markdown verification table construction.',
    '',
    'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$v02ErrorFreezeSha = Get-Sha256 $v02ErrorFreezePath

Write-Lines $v03FixNotePath @(
    '# FIX NOTE - HSRB-004 Disposition Index V0.3',
    '',
    'Status: SAME_OBJECT_REPAIR / CONTRACT_FIRST / NO_EXECUTION / NO_ROUTE / NO_CLEANUP',
    '',
    'Repair: replaced fragile generated generic-list and array casts with native PowerShell array accumulation and direct foreach enumeration.',
    '',
    'Preserved contract: TicketID, filename, declared SHA256, actual SHA256, source existence, disposition bucket, risk markers, no-clearance fields, blocker dominance, and physical action zero checks remain enforced.',
    '',
    'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$v03FixNoteSha = Get-Sha256 $v03FixNotePath

Write-Lines $v03FixReceiptPath @(
    'HSRB-004 DISPOSITION INDEX V0.3 REPAIR RECEIPT',
    "v0_1_error_freeze_path: $v01ErrorFreezePath",
    "v0_1_error_freeze_sha256: $v01ErrorFreezeSha",
    "v0_2_error_freeze_path: $v02ErrorFreezePath",
    "v0_2_error_freeze_sha256: $v02ErrorFreezeSha",
    "fix_note_path: $v03FixNotePath",
    "fix_note_sha256: $v03FixNoteSha",
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
)
$v03FixReceiptSha = Get-Sha256 $v03FixReceiptPath

$verifyRows = @()
$inputsVerified = $true
foreach ($e in $Expected) {
    $p = Join-Path $Base $e.File
    $exists = Test-Path -LiteralPath $p -PathType Leaf
    $actual = Get-Sha256 $p
    $match = ($exists -and ($actual -eq $e.Sha))
    if (-not $match) { $inputsVerified = $false }
    $verifyRows += [pscustomobject]@{ Input=$e.Label; Exists=$exists; HashMatch=$match; SHA256=$actual; ExpectedSHA256=$e.Sha; Path=$p }
}

$selectedCsv = Join-Path $Base 'HELPER_SCRIPT_REVIEW_NEXT_BATCH_SELECTOR_HSRB_004_FROM_64_QUEUE_NO_EXECUTION_SELECTED_BATCH_004_V0_1_20260609.csv'
$summaryCsv = Join-Path $Base 'STATIC_REVIEW_PACKET_BATCH_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_CHAIN_SUMMARY_V0_1_20260609.csv'
$riskCsv = Join-Path $Base 'HSRB_004_STATIC_REVIEW_DECISION_CLOSEOUT_CONTRACT_FIRST_RISK_MARKER_INDEX_V0_1_20260609.csv'

$selectedRows = Read-CsvRows $selectedCsv
$summaryRows = Read-CsvRows $summaryCsv
$riskRows = Read-CsvRows $riskCsv

$selectedByFile = @{}
foreach ($r in $selectedRows) {
    $fn = Get-PropValue $r @('FileName','Name','LeafName')
    if (-not [string]::IsNullOrWhiteSpace($fn) -and -not $selectedByFile.ContainsKey($fn)) { $selectedByFile[$fn] = $r }
}
$riskByFile = @{}
foreach ($r in $riskRows) {
    $fn = Get-PropValue $r @('FileName','Name','LeafName')
    if (-not [string]::IsNullOrWhiteSpace($fn) -and -not $riskByFile.ContainsKey($fn)) { $riskByFile[$fn] = $r }
}

$indexRows = @()
foreach ($s in $summaryRows) {
    $fileName = Get-PropValue $s @('FileName','Name','LeafName')
    $sel = $null
    $risk = $null
    if ($selectedByFile.ContainsKey($fileName)) { $sel = $selectedByFile[$fileName] }
    if ($riskByFile.ContainsKey($fileName)) { $risk = $riskByFile[$fileName] }

    $ticketId = Get-PropValue $risk @('TicketID','TicketId','ticket_id','QueueTicketID')
    if ([string]::IsNullOrWhiteSpace($ticketId)) { $ticketId = Get-PropValue $s @('TicketID','TicketId','ticket_id','QueueTicketID') }
    if ([string]::IsNullOrWhiteSpace($ticketId)) { $ticketId = Get-PropValue $sel @('TicketID','TicketId','ticket_id','QueueTicketID') }

    $declaredSha = Get-PropValue $risk @('DeclaredSHA256','DeclaredSha256','SHA256','SourceSHA256','DeclaredHash')
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = Get-PropValue $s @('DeclaredSHA256','DeclaredSha256','SHA256','SourceSHA256','DeclaredHash') }
    if ([string]::IsNullOrWhiteSpace($declaredSha)) { $declaredSha = Get-PropValue $sel @('DeclaredSHA256','DeclaredSha256','SHA256','SourceSHA256','DeclaredHash') }

    $sourcePath = Find-SourcePath $fileName $risk $s $sel
    $sourceExists = -not [string]::IsNullOrWhiteSpace($sourcePath)
    $actualSha = ''
    if ($sourceExists) { $actualSha = Get-Sha256 $sourcePath }
    if ([string]::IsNullOrWhiteSpace($actualSha)) { $actualSha = Get-PropValue $risk @('ActualSHA256','ActualSha256','ComputedSHA256','ActualHash') }
    if ([string]::IsNullOrWhiteSpace($actualSha)) { $actualSha = Get-PropValue $s @('ActualSHA256','ActualSha256','ComputedSHA256','ActualHash') }

    $hashMatch = (-not [string]::IsNullOrWhiteSpace($declaredSha)) -and (-not [string]::IsNullOrWhiteSpace($actualSha)) -and ($declaredSha.ToUpperInvariant() -eq $actualSha.ToUpperInvariant())
    $staticDisposition = Get-PropValue $risk @('StaticDisposition','Disposition','IndexRole','DispositionBucket')
    if ([string]::IsNullOrWhiteSpace($staticDisposition)) { $staticDisposition = Get-PropValue $s @('StaticDisposition','Disposition','IndexRole','DispositionBucket') }
    $bucket = Get-DispositionBucket $fileName $staticDisposition

    $containsGit = BoolFromText (Get-PropValue $risk @('ContainsGitCommand','contains_git_command','GitCommand','ContainsGit'))
    if (-not $containsGit) { $containsGit = BoolFromText (Get-PropValue $s @('ContainsGitCommand','contains_git_command','GitCommand','ContainsGit')) }
    if (-not $containsGit -and $sourceExists) {
        $txt = Get-Content -LiteralPath $sourcePath -Raw -ErrorAction SilentlyContinue
        if ($txt -match '(?im)\bgit\b') { $containsGit = $true }
    }

    $containsCopy = BoolFromText (Get-PropValue $risk @('ContainsCopyItem','contains_copy_item','CopyItem','ContainsCopy'))
    if (-not $containsCopy) { $containsCopy = BoolFromText (Get-PropValue $s @('ContainsCopyItem','contains_copy_item','CopyItem','ContainsCopy')) }
    $containsMove = BoolFromText (Get-PropValue $risk @('ContainsMoveItem','contains_move_item','MoveItem','ContainsMove'))
    if (-not $containsMove) { $containsMove = BoolFromText (Get-PropValue $s @('ContainsMoveItem','contains_move_item','MoveItem','ContainsMove')) }
    $containsRemove = BoolFromText (Get-PropValue $risk @('ContainsRemoveItem','contains_remove_item','RemoveItem','ContainsRemove'))
    if (-not $containsRemove) { $containsRemove = BoolFromText (Get-PropValue $s @('ContainsRemoveItem','contains_remove_item','RemoveItem','ContainsRemove')) }
    $containsRename = BoolFromText (Get-PropValue $risk @('ContainsRenameItem','contains_rename_item','RenameItem','ContainsRename'))
    if (-not $containsRename) { $containsRename = BoolFromText (Get-PropValue $s @('ContainsRenameItem','contains_rename_item','RenameItem','ContainsRename')) }
    $containsStart = BoolFromText (Get-PropValue $risk @('ContainsStartProcess','contains_start_process','StartProcess'))
    if (-not $containsStart) { $containsStart = BoolFromText (Get-PropValue $s @('ContainsStartProcess','contains_start_process','StartProcess')) }
    $containsInvoke = BoolFromText (Get-PropValue $risk @('ContainsInvokeExpression','contains_invoke_expression','InvokeExpression'))
    if (-not $containsInvoke) { $containsInvoke = BoolFromText (Get-PropValue $s @('ContainsInvokeExpression','contains_invoke_expression','InvokeExpression')) }
    $containsClipboard = BoolFromText (Get-PropValue $risk @('ContainsSetClipboard','contains_set_clipboard','SetClipboard'))
    if (-not $containsClipboard) { $containsClipboard = BoolFromText (Get-PropValue $s @('ContainsSetClipboard','contains_set_clipboard','SetClipboard')) }

    $riskClass = if ($containsMove -or $containsRemove -or $containsRename -or $containsStart -or $containsInvoke) { 'HIGH_RISK_COMMAND_MARKER_REVIEW_REQUIRED' }
        elseif ($containsGit -or $containsCopy -or $containsClipboard) { 'REVIEW_ONLY_RISK_MARKER_PRESERVED_NOT_CLEARANCE' }
        else { 'NO_COMMAND_RISK_MARKER_DETECTED_REVIEW_ONLY' }

    $indexRows += [pscustomobject]@{
        TicketID=$ticketId
        FileName=$fileName
        DispositionBucket=$bucket
        ReviewDecision='HOLD_AS_REVIEW_ONLY_EVIDENCE_NOT_EXECUTION_OR_ROUTE_AUTHORITY'
        RiskClassification=$riskClass
        DeclaredSHA256=$declaredSha
        ActualSHA256=$actualSha
        SourcePath=$sourcePath
        SourceExists=[string]$sourceExists
        HashMatch=[string]$hashMatch
        ContainsGitCommand=[string]$containsGit
        ContainsCopyItem=[string]$containsCopy
        ContainsMoveItem=[string]$containsMove
        ContainsRemoveItem=[string]$containsRemove
        ContainsRenameItem=[string]$containsRename
        ContainsStartProcess=[string]$containsStart
        ContainsInvokeExpression=[string]$containsInvoke
        ContainsSetClipboard=[string]$containsClipboard
        ExecutionClearance='NO'
        RouteClearance='NO'
        CleanupClearance='NO'
        DoctrinePromotion='NO'
        ActionNow='NO'
    }
}

$selectedBatchRows = 0; foreach ($r in $selectedRows) { $selectedBatchRows++ }
$indexRowCount = 0; foreach ($r in $indexRows) { $indexRowCount++ }
$blankTicketIdCount = Count-Matching $indexRows { param($r) [string]::IsNullOrWhiteSpace($r.TicketID) }
$missingFilenameCount = Count-Matching $indexRows { param($r) [string]::IsNullOrWhiteSpace($r.FileName) }
$missingDeclaredShaCount = Count-Matching $indexRows { param($r) [string]::IsNullOrWhiteSpace($r.DeclaredSHA256) }
$missingActualShaCount = Count-Matching $indexRows { param($r) [string]::IsNullOrWhiteSpace($r.ActualSHA256) }
$sourceHashMismatchCount = Count-Matching $indexRows { param($r) $r.HashMatch -ne 'True' }
$sourceMissingCount = Count-Matching $indexRows { param($r) $r.SourceExists -ne 'True' }
$unknownDispositionBucketCount = Count-Matching $indexRows { param($r) $r.DispositionBucket -eq 'UNKNOWN_DISPOSITION_BUCKET' }
$containsCopyItemCount = Count-Matching $indexRows { param($r) $r.ContainsCopyItem -eq 'True' }
$containsGitCommandCount = Count-Matching $indexRows { param($r) $r.ContainsGitCommand -eq 'True' }
$containsMoveItemCount = Count-Matching $indexRows { param($r) $r.ContainsMoveItem -eq 'True' }
$containsRemoveItemCount = Count-Matching $indexRows { param($r) $r.ContainsRemoveItem -eq 'True' }
$containsRenameItemCount = Count-Matching $indexRows { param($r) $r.ContainsRenameItem -eq 'True' }
$containsStartProcessCount = Count-Matching $indexRows { param($r) $r.ContainsStartProcess -eq 'True' }
$containsInvokeExpressionCount = Count-Matching $indexRows { param($r) $r.ContainsInvokeExpression -eq 'True' }
$containsSetClipboardCount = Count-Matching $indexRows { param($r) $r.ContainsSetClipboard -eq 'True' }
$highRiskCommandMarkerRowCount = Count-Matching $indexRows { param($r) $r.RiskClassification -eq 'HIGH_RISK_COMMAND_MARKER_REVIEW_REQUIRED' }
$riskMarkedRowCount = Count-Matching $indexRows { param($r) $r.RiskClassification -match 'RISK_MARKER' }
$unclassifiedRiskMarkerCount = Count-Matching $indexRows { param($r) (($r.ContainsGitCommand -eq 'True') -or ($r.ContainsCopyItem -eq 'True') -or ($r.ContainsSetClipboard -eq 'True')) -and ($r.RiskClassification -notmatch 'RISK_MARKER') }
$executionClearanceCount = Count-Matching $indexRows { param($r) $r.ExecutionClearance -ne 'NO' }
$routeClearanceCount = Count-Matching $indexRows { param($r) $r.RouteClearance -ne 'NO' }
$cleanupClearanceCount = Count-Matching $indexRows { param($r) $r.CleanupClearance -ne 'NO' }
$doctrinePromotionCount = Count-Matching $indexRows { param($r) $r.DoctrinePromotion -ne 'NO' }
$actionNowNonNoCount = Count-Matching $indexRows { param($r) $r.ActionNow -ne 'NO' }
$helperFileSurfacePreflightLaneCloseoutCardCount = Count-Matching $indexRows { param($r) $r.DispositionBucket -eq 'HELPER_FILE_SURFACE_PREFLIGHT_LANE_CLOSEOUT_CARD_REVIEW_ONLY' }
$planetaryGateHelperFileSurfacePreflightCloseoutOrNextSelectorCount = Count-Matching $indexRows { param($r) $r.DispositionBucket -eq 'PLANETARY_GATE_HELPER_FILE_SURFACE_PREFLIGHT_CLOSEOUT_OR_NEXT_SELECTOR_REVIEW_ONLY' }
$planetaryGateNextObjectSelectorHeavyBoundaryCount = Count-Matching $indexRows { param($r) $r.DispositionBucket -eq 'PLANETARY_GATE_NEXT_OBJECT_SELECTOR_HEAVY_BOUNDARY_REVIEW_ONLY' }

$blockerCount = 0
if (-not $inputsVerified) { $blockerCount++ }
if ($selectedBatchRows -ne 3) { $blockerCount++ }
if ($indexRowCount -ne 3) { $blockerCount++ }
$blockerCount += $blankTicketIdCount
$blockerCount += $missingFilenameCount
$blockerCount += $missingDeclaredShaCount
$blockerCount += $missingActualShaCount
$blockerCount += $sourceHashMismatchCount
$blockerCount += $sourceMissingCount
$blockerCount += $unknownDispositionBucketCount
$blockerCount += $highRiskCommandMarkerRowCount
$blockerCount += $unclassifiedRiskMarkerCount
$blockerCount += $executionClearanceCount
$blockerCount += $routeClearanceCount
$blockerCount += $cleanupClearanceCount
$blockerCount += $doctrinePromotionCount
$blockerCount += $actionNowNonNoCount

$contractGatePassed = ($blockerCount -eq 0)
$nextAction = if ($contractGatePassed) { 'BUILD_HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_CLOSEOUT_NO_EXECUTION' } else { 'STOP_AND_REVIEW_HSRB_004_DISPOSITION_INDEX_BLOCKERS_NO_EXECUTION' }
$verdict = if ($contractGatePassed) { 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_V0_3_WRITTEN_WITH_REVIEW_ONLY_GIT_MARKERS_NO_PHYSICAL_ACTION' } else { 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_V0_3_WRITTEN_WITH_BLOCKERS_NO_PHYSICAL_ACTION' }

$outCsv = Join-Path $Base 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_V0_3_20260609.csv'
$outMd = Join-Path $Base 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_V0_3_20260609.md'
$outPrint = Join-Path $Base 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_COPY_PRINT_V0_3_20260609.txt'
$outReceipt = Join-Path $Base 'HSRB_004_HELPER_FILE_SURFACE_PREFLIGHT_AND_PLANETARY_GATE_SELECTOR_DISPOSITION_INDEX_NO_EXECUTION_RECEIPT_V0_3_20260609.txt'

$indexRows | Export-Csv -LiteralPath $outCsv -NoTypeInformation -Encoding UTF8
$outCsvSha = Get-Sha256 $outCsv

$md = @()
$md += '# HSRB-004 Helper File Surface Preflight and Planetary Gate Selector Disposition Index - No Execution - V0.3'
$md += ''
$md += 'Status: INDEX_ONLY / CONTRACT_FIRST / REVIEW_ONLY / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH'
$md += ''
$md += '## Purpose'
$md += 'Classify the HSRB-004 helper file surface preflight and planetary gate selector chain after contract-first static review closeout.'
$md += ''
$md += '## Boundary'
$md += 'This index is proof and review organization only. Git markers are preserved as review evidence and do not grant execution, routing, cleanup, doctrine promotion, commit, or push authority.'
$md += ''
$md += '## Repair chain'
$md += ''
$md += ('- V0.1 error freeze SHA256: `{0}`' -f $v01ErrorFreezeSha)
$md += ('- V0.2 error freeze SHA256: `{0}`' -f $v02ErrorFreezeSha)
$md += ('- V0.3 fix note SHA256: `{0}`' -f $v03FixNoteSha)
$md += ''
$md += '## Verified inputs'
$md += ''
$md += '| Input | Exists | HashMatch | SHA256 |'
$md += '| --- | ---: | ---: | --- |'
foreach ($v in $verifyRows) {
    $md += ('| {0} | {1} | {2} | `{3}` |' -f $v.Input, $v.Exists, $v.HashMatch, $v.SHA256)
}
$md += ''
$md += '## Counts'
$countLines = @(
    "contract_gate_passed: $contractGatePassed",
    'selected_batch_id: HSRB-004',
    "selected_batch_rows: $selectedBatchRows",
    "index_rows: $indexRowCount",
    "blank_ticket_id_count: $blankTicketIdCount",
    "missing_filename_count: $missingFilenameCount",
    "missing_declared_sha256_count: $missingDeclaredShaCount",
    "missing_actual_sha256_count: $missingActualShaCount",
    "source_hash_mismatch_count: $sourceHashMismatchCount",
    "source_missing_count: $sourceMissingCount",
    "unknown_disposition_bucket_count: $unknownDispositionBucketCount",
    "helper_file_surface_preflight_lane_closeout_card_count: $helperFileSurfacePreflightLaneCloseoutCardCount",
    "planetary_gate_helper_file_surface_preflight_closeout_or_next_selector_count: $planetaryGateHelperFileSurfacePreflightCloseoutOrNextSelectorCount",
    "planetary_gate_next_object_selector_heavy_boundary_count: $planetaryGateNextObjectSelectorHeavyBoundaryCount",
    "contains_copy_item_count: $containsCopyItemCount",
    "contains_git_command_count: $containsGitCommandCount",
    "contains_move_item_count: $containsMoveItemCount",
    "contains_remove_item_count: $containsRemoveItemCount",
    "contains_rename_item_count: $containsRenameItemCount",
    "contains_start_process_count: $containsStartProcessCount",
    "contains_invoke_expression_count: $containsInvokeExpressionCount",
    "contains_set_clipboard_count: $containsSetClipboardCount",
    "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount",
    "risk_marked_row_count: $riskMarkedRowCount",
    "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount",
    "execution_clearance_count: $executionClearanceCount",
    "route_clearance_count: $routeClearanceCount",
    "cleanup_clearance_count: $cleanupClearanceCount",
    "doctrine_promotion_count: $doctrinePromotionCount",
    "action_now_non_no_count: $actionNowNonNoCount",
    "blocker_count: $blockerCount"
)
foreach ($line in $countLines) { $md += ('- ' + $line) }
$md += ''
$md += '## Index table'
$md += ''
$md += '| TicketID | FileName | DispositionBucket | ReviewDecision | RiskClassification | Git | SHA256 |'
$md += '| --- | --- | --- | --- | --- | ---: | --- |'
foreach ($r in $indexRows) {
    $md += ('| {0} | `{1}` | {2} | {3} | {4} | {5} | `{6}` |' -f $r.TicketID, $r.FileName, $r.DispositionBucket, $r.ReviewDecision, $r.RiskClassification, $r.ContainsGitCommand, $r.DeclaredSHA256)
}
$md += ''
$md += '## Interpretation'
$md += ''
$md += '- HSRB-004 remains review-only disposition work.'
$md += '- Git markers are preserved as review evidence only.'
$md += '- No execution, route, cleanup, doctrine promotion, commit, or push clearance is granted.'
$md += ''
$md += '## Next single action'
$md += ''
$md += $nextAction
$md += ''
$md += "Final verdict: $verdict"
$md += ''
$md += 'Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Lines $outMd ([string[]]$md)
Copy-Item -LiteralPath $outMd -Destination $outPrint -Force
$outMdSha = Get-Sha256 $outMd
$outPrintSha = Get-Sha256 $outPrint

$receipt = @()
$receipt += 'HSRB-004 HELPER FILE SURFACE PREFLIGHT AND PLANETARY GATE SELECTOR DISPOSITION INDEX RECEIPT V0.3'
$receipt += "v0_1_error_freeze_path: $v01ErrorFreezePath"
$receipt += "v0_1_error_freeze_sha256: $v01ErrorFreezeSha"
$receipt += "v0_2_error_freeze_path: $v02ErrorFreezePath"
$receipt += "v0_2_error_freeze_sha256: $v02ErrorFreezeSha"
$receipt += "fix_note_path: $v03FixNotePath"
$receipt += "fix_note_sha256: $v03FixNoteSha"
$receipt += "fix_receipt_path: $v03FixReceiptPath"
$receipt += "fix_receipt_sha256: $v03FixReceiptSha"
$receipt += "output_index_csv_path: $outCsv"
$receipt += "output_index_csv_sha256: $outCsvSha"
$receipt += "output_index_md_path: $outMd"
$receipt += "output_index_md_sha256: $outMdSha"
$receipt += "output_index_print_path: $outPrint"
$receipt += "output_index_print_sha256: $outPrintSha"
$receipt += "contract_gate_passed: $contractGatePassed"
$receipt += 'selected_batch_id: HSRB-004'
$receipt += "selected_batch_rows: $selectedBatchRows"
$receipt += "index_rows: $indexRowCount"
$receipt += "blocker_count: $blockerCount"
$receipt += "final_verdict: $verdict"
$receipt += 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
Write-Lines $outReceipt ([string[]]$receipt)
$outReceiptSha = Get-Sha256 $outReceipt

Write-Output '=== HSRB-004 HELPER FILE SURFACE PREFLIGHT AND PLANETARY GATE SELECTOR DISPOSITION INDEX V0.3 COMPLETE ==='
Write-Output "v0_1_error_freeze_path: $v01ErrorFreezePath"
Write-Output "v0_1_error_freeze_sha256: $v01ErrorFreezeSha"
Write-Output "v0_2_error_freeze_path: $v02ErrorFreezePath"
Write-Output "v0_2_error_freeze_sha256: $v02ErrorFreezeSha"
Write-Output "fix_note_path: $v03FixNotePath"
Write-Output "fix_note_sha256: $v03FixNoteSha"
Write-Output "fix_receipt_path: $v03FixReceiptPath"
Write-Output "fix_receipt_sha256: $v03FixReceiptSha"
Write-Output "output_index_csv_path: $outCsv"
Write-Output "output_index_csv_sha256: $outCsvSha"
Write-Output "output_index_md_path: $outMd"
Write-Output "output_index_md_sha256: $outMdSha"
Write-Output "output_index_print_path: $outPrint"
Write-Output "output_index_print_sha256: $outPrintSha"
Write-Output "output_receipt_path: $outReceipt"
Write-Output "output_receipt_sha256: $outReceiptSha"
Write-Output "contract_gate_passed: $contractGatePassed"
Write-Output 'selected_batch_id: HSRB-004'
Write-Output "selected_batch_rows: $selectedBatchRows"
Write-Output "index_rows: $indexRowCount"
Write-Output "blank_ticket_id_count: $blankTicketIdCount"
Write-Output "missing_filename_count: $missingFilenameCount"
Write-Output "missing_declared_sha256_count: $missingDeclaredShaCount"
Write-Output "missing_actual_sha256_count: $missingActualShaCount"
Write-Output "source_hash_mismatch_count: $sourceHashMismatchCount"
Write-Output "source_missing_count: $sourceMissingCount"
Write-Output "unknown_disposition_bucket_count: $unknownDispositionBucketCount"
Write-Output "helper_file_surface_preflight_lane_closeout_card_count: $helperFileSurfacePreflightLaneCloseoutCardCount"
Write-Output "planetary_gate_helper_file_surface_preflight_closeout_or_next_selector_count: $planetaryGateHelperFileSurfacePreflightCloseoutOrNextSelectorCount"
Write-Output "planetary_gate_next_object_selector_heavy_boundary_count: $planetaryGateNextObjectSelectorHeavyBoundaryCount"
Write-Output "contains_copy_item_count: $containsCopyItemCount"
Write-Output "contains_git_command_count: $containsGitCommandCount"
Write-Output "contains_move_item_count: $containsMoveItemCount"
Write-Output "contains_remove_item_count: $containsRemoveItemCount"
Write-Output "contains_rename_item_count: $containsRenameItemCount"
Write-Output "contains_start_process_count: $containsStartProcessCount"
Write-Output "contains_invoke_expression_count: $containsInvokeExpressionCount"
Write-Output "contains_set_clipboard_count: $containsSetClipboardCount"
Write-Output "high_risk_command_marker_row_count: $highRiskCommandMarkerRowCount"
Write-Output "risk_marked_row_count: $riskMarkedRowCount"
Write-Output "unclassified_risk_marker_count: $unclassifiedRiskMarkerCount"
Write-Output "execution_clearance_count: $executionClearanceCount"
Write-Output "route_clearance_count: $routeClearanceCount"
Write-Output "cleanup_clearance_count: $cleanupClearanceCount"
Write-Output "doctrine_promotion_count: $doctrinePromotionCount"
Write-Output "action_now_non_no_count: $actionNowNonNoCount"
Write-Output "blocker_count: $blockerCount"
Write-Output "next_single_action: $nextAction"
Write-Output "final_verdict: $verdict"
Write-Output 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
