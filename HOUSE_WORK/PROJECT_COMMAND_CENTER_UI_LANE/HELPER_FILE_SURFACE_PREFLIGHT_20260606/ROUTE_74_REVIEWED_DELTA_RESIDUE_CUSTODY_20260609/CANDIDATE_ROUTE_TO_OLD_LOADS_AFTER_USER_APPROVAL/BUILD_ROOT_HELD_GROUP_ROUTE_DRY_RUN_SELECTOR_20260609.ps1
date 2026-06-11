<#
ROOT HELD GROUP ROUTE DRY-RUN SELECTOR 20260609
Status: DRY_RUN_SELECTOR_BUILDER / READ_ONLY_CLASSIFICATION / NO_PHYSICAL_ROUTING

Purpose:
  Build a live-root delta and receptionist-style ticket report for the current root-held route-plan pause point.

Boundary:
  This script does not move, delete, rename, route, execute helper scripts, commit, push, or rewrite source.
  It writes only a report and receipt into the existing helper-file surface preflight lane.
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = (Join-Path $env:USERPROFILE 'Desktop\123'),
    [string]$RepoRel = 'Jxhnny_Kl33N_Seedz',
    [string]$LaneRel = 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606',
    [string]$ExpectedHead = 'bdc74ff82837fe30a10f7f5047d0b54b65321016'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RunStamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$ReportName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260609.md'
$ReceiptName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_RECEIPT_20260609.txt'

function New-RowObject {
    param([hashtable]$Values)
    return [pscustomobject]$Values
}

function Get-Sha256Safe {
    param([Parameter(Mandatory=$true)][string]$Path)
    try {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
    } catch {
        return "HASH_READ_FAILED: $($_.Exception.Message)"
    }
}

function Escape-Md {
    param([AllowNull()][string]$Text)
    if ($null -eq $Text) { return '' }
    return ($Text -replace '\|','\\|' -replace "`r?`n", ' ')
}

function Invoke-GitSafe {
    param(
        [Parameter(Mandatory=$true)][string]$RepoPath,
        [Parameter(Mandatory=$true)][string[]]$GitArgs
    )
    try {
        $output = & git -C $RepoPath @GitArgs 2>&1
        $code = $LASTEXITCODE
        return [pscustomobject]@{ Code = $code; Output = ([array]$output) }
    } catch {
        return [pscustomobject]@{ Code = 999; Output = @($_.Exception.Message) }
    }
}

function Get-ReceptionistRole {
    param(
        [Parameter(Mandatory=$true)][System.IO.FileInfo]$FileInfo,
        [AllowNull()][string]$DeltaStatus
    )
    $name = $FileInfo.Name
    $ext = $FileInfo.Extension.ToLowerInvariant()
    $size = [int64]$FileInfo.Length

    if ($name -ieq 'desktop.ini') {
        return [pscustomobject]@{
            Role='SYSTEM_FILE_LEAVE_IN_PLACE'; State='VERIFIED_PRESENT'; Authority='ORIENTS_ONLY'; Risk='BLOCKED_RISK_SYSTEM_FILE'; Confidence='HIGH_CONFIDENCE'; Proposal='PROPOSE_LEAVE_IN_PLACE'; Reason='Windows/system metadata candidate; not deletion proof.'
        }
    }
    if ($ext -in @('.ps1','.bat','.cmd','.exe','.vbs','.js','.py','.psm1')) {
        return [pscustomobject]@{
            Role='EXECUTABLE_HELPER_REVIEW_REQUIRED'; State='VERIFIED_PRESENT'; Authority='EXECUTION_CANDIDATE_ONLY'; Risk='HIGH_RISK_EXECUTABLE'; Confidence='HIGH_CONFIDENCE'; Proposal='PROPOSE_REVIEW_AS_HELPER'; Reason='Executable or script-like file; review only, never auto-run.'
        }
    }
    if ($name -match '(?i)receipt|hash_receipt') {
        return [pscustomobject]@{
            Role='RECEIPT'; State='VERIFIED_PRESENT'; Authority='PROVES_PAST_ACTION'; Risk='LOW_RISK_POINTER'; Confidence='HIGH_CONFIDENCE'; Proposal='PROPOSE_INDEX_AS_PROOF_HISTORY'; Reason='Name indicates receipt/proof object; receipt is proof, not active order.'
        }
    }
    if ($name -match '(?i)error_freeze|failure|incident') {
        return [pscustomobject]@{
            Role='ERROR_FREEZE'; State='VERIFIED_PRESENT'; Authority='PROVES_PAST_ACTION'; Risk='MEDIUM_RISK_CUSTODY_DECISION'; Confidence='HIGH_CONFIDENCE'; Proposal='PROPOSE_INDEX_AS_PROOF_HISTORY'; Reason='Name indicates failure freeze or incident evidence.'
        }
    }
    if ($name -match '(?i)fix_note|repair') {
        return [pscustomobject]@{
            Role='FIX_NOTE'; State='VERIFIED_PRESENT'; Authority='SUPPORTS_DECISION'; Risk='LOW_RISK_SUPPORT'; Confidence='MEDIUM_CONFIDENCE'; Proposal='PROPOSE_KEEP_AS_SUPPORT'; Reason='Name indicates repair/fix support note.'
        }
    }
    if ($name -match '(?i)route|ledger|closeout|option|queue|review|plan') {
        return [pscustomobject]@{
            Role='LEDGER'; State='VERIFIED_PRESENT'; Authority='SUPPORTS_DECISION'; Risk='MEDIUM_RISK_CUSTODY_DECISION'; Confidence='MEDIUM_CONFIDENCE'; Proposal='PROPOSE_KEEP_AS_SUPPORT'; Reason='Name indicates planning/review/ledger object; not movement authority.'
        }
    }
    if ($size -eq 0) {
        return [pscustomobject]@{
            Role='OLD_LOAD_OR_SUPERSEDED'; State='VERIFIED_PRESENT'; Authority='ORIENTS_ONLY'; Risk='MEDIUM_RISK_OLD_LOAD'; Confidence='LOW_CONFIDENCE'; Proposal='PROPOSE_USER_DECISION'; Reason='Zero-byte file is a review signal only; not trash proof.'
        }
    }
    if ($ext -in @('.md','.txt','.json','.csv','.log')) {
        return [pscustomobject]@{
            Role='SUPPORT_GUARDRAIL'; State='VERIFIED_PRESENT'; Authority='ORIENTS_ONLY'; Risk='LOW_RISK_SUPPORT'; Confidence='MEDIUM_CONFIDENCE'; Proposal='PROPOSE_KEEP_AS_SUPPORT'; Reason='Text/support-like file; review as support unless current source proof says otherwise.'
        }
    }

    return [pscustomobject]@{
        Role='UNKNOWN_NEEDS_USER'; State='USER_DECISION_REQUIRED'; Authority='USER_APPROVAL_REQUIRED'; Risk='MEDIUM_RISK_CUSTODY_DECISION'; Confidence='LOW_CONFIDENCE'; Proposal='PROPOSE_USER_DECISION'; Reason='No strong controlled-label match; user review required.'
    }
}

function Extract-ExpectedRootRows {
    param([Parameter(Mandatory=$true)][string[]]$InputFilePaths)

    $rows = New-Object System.Collections.Generic.List[object]
    foreach ($inputPath in [array]$InputFilePaths) {
        if (-not (Test-Path -LiteralPath $inputPath -PathType Leaf)) { continue }
        $lines = [array](Get-Content -LiteralPath $inputPath -ErrorAction Stop)
        $lineNo = 0
        foreach ($line in $lines) {
            $lineNo++
            $paths = [regex]::Matches($line, 'C:\\Users\\13527\\Desktop\\123\\[^`|\]\)\s,]+')
            if ($paths.Count -eq 0) { continue }
            $hashMatch = [regex]::Match($line, '(?i)\b[A-F0-9]{64}\b')
            $hash = if ($hashMatch.Success) { $hashMatch.Value.ToUpperInvariant() } else { $null }
            foreach ($p in $paths) {
                $pathText = $p.Value.Trim().Trim('`').Trim()
                try {
                    $parent = Split-Path -LiteralPath $pathText -Parent
                    if ($parent -ne $ProjectRoot) { continue }
                } catch { continue }
                $rows.Add([pscustomobject]@{
                    ExpectedPath = $pathText
                    ExpectedName = Split-Path -Leaf $pathText
                    ExpectedHash = $hash
                    SourceProofFile = $inputPath
                    SourceLine = $lineNo
                }) | Out-Null
            }
        }
    }
    return [array]$rows
}

$RepoPath = Join-Path $ProjectRoot $RepoRel
$LanePath = Join-Path $ProjectRoot $LaneRel
$ReportPath = Join-Path $LanePath $ReportName
$ReceiptPath = Join-Path $LanePath $ReceiptName
$Blockers = New-Object System.Collections.Generic.List[string]
$Warnings = New-Object System.Collections.Generic.List[string]

if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    throw "Project root not found: $ProjectRoot"
}
if (-not (Test-Path -LiteralPath $LanePath -PathType Container)) {
    throw "Lane path not found. Refusing to create new lane folder during dry-run selector: $LanePath"
}
if (Test-Path -LiteralPath $ReportPath -PathType Leaf) {
    throw "Output report already exists. Refusing overwrite: $ReportPath"
}
if (Test-Path -LiteralPath $ReceiptPath -PathType Leaf) {
    throw "Output receipt already exists. Refusing overwrite: $ReceiptPath"
}

$gitAvailable = $true
try { $null = & git --version 2>&1 } catch { $gitAvailable = $false }
if (-not $gitAvailable) { $Blockers.Add('GIT_NOT_AVAILABLE') | Out-Null }

$gitHead = $null
$gitStatusLines = @()
if (Test-Path -LiteralPath $RepoPath -PathType Container) {
    if ($gitAvailable) {
        $headResult = Invoke-GitSafe -RepoPath $RepoPath -GitArgs @('rev-parse','HEAD')
        if ($headResult.Code -eq 0 -and $headResult.Output.Count -gt 0) {
            $gitHead = ([string]$headResult.Output[0]).Trim()
        } else {
            $Blockers.Add('GIT_HEAD_READ_FAILED') | Out-Null
        }
        $statusResult = Invoke-GitSafe -RepoPath $RepoPath -GitArgs @('status','--porcelain')
        if ($statusResult.Code -eq 0) {
            $gitStatusLines = [array]$statusResult.Output
        } else {
            $Blockers.Add('GIT_STATUS_READ_FAILED') | Out-Null
        }
        if ($gitHead -and ($gitHead -ne $ExpectedHead)) {
            $Blockers.Add("EXPECTED_HEAD_MISMATCH expected=$ExpectedHead actual=$gitHead") | Out-Null
        }
        if ($gitStatusLines.Count -gt 0) {
            $Blockers.Add("GIT_STATUS_NOT_CLEAN count=$($gitStatusLines.Count)") | Out-Null
        }
    }
} else {
    $Blockers.Add("REPO_PATH_NOT_FOUND $RepoPath") | Out-Null
}

$routeProofCandidates = @()
foreach ($base in @($LanePath, $RepoPath)) {
    if (Test-Path -LiteralPath $base -PathType Container) {
        $routeProofCandidates += Get-ChildItem -LiteralPath $base -Recurse -File -Force -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match 'ROOT_HELD_GROUP_ROUTE_PLAN_ONLY|ROOT_HELD_GROUP_ROUTE|HELD_GROUP_ROUTE' } |
            Select-Object -ExpandProperty FullName
    }
}
$routeProofCandidates = [array]($routeProofCandidates | Sort-Object -Unique)
if ($routeProofCandidates.Count -eq 0) {
    $Blockers.Add('ROUTE_PLAN_PROOF_OBJECTS_NOT_FOUND_BY_NAME_SEARCH') | Out-Null
}

$expectedRows = [array](Extract-ExpectedRootRows -InputFilePaths $routeProofCandidates)
$expectedByPath = @{}
foreach ($row in $expectedRows) {
    if (-not $expectedByPath.ContainsKey($row.ExpectedPath)) {
        $expectedByPath[$row.ExpectedPath] = $row
    }
}
if ($expectedByPath.Keys.Count -eq 0) {
    $Warnings.Add('NO_EXPECTED_ROOT_ROWS_PARSED_FROM_ROUTE_PLAN_PROOF_FILES; report will still snapshot live root and block route execution.') | Out-Null
}

$liveFiles = [array](Get-ChildItem -LiteralPath $ProjectRoot -File -Force -ErrorAction Stop | Sort-Object Name)
$liveByPath = @{}
foreach ($f in $liveFiles) { $liveByPath[$f.FullName] = $f }

$tickets = New-Object System.Collections.Generic.List[object]
$allPaths = New-Object System.Collections.Generic.HashSet[string]
foreach ($p in $expectedByPath.Keys) { [void]$allPaths.Add($p) }
foreach ($p in $liveByPath.Keys) { [void]$allPaths.Add($p) }

$ticketIndex = 0
foreach ($path in ([array]$allPaths | Sort-Object)) {
    $ticketIndex++
    $expected = if ($expectedByPath.ContainsKey($path)) { $expectedByPath[$path] } else { $null }
    $fileInfo = if ($liveByPath.ContainsKey($path)) { $liveByPath[$path] } else { $null }
    $delta = 'UNKNOWN'
    $currentHash = $null
    $expectedHash = $null
    $name = Split-Path -Leaf $path
    $size = $null
    $ext = [System.IO.Path]::GetExtension($name)
    $lastWrite = $null

    if ($null -ne $expected) { $expectedHash = $expected.ExpectedHash }

    if ($null -ne $fileInfo) {
        $currentHash = Get-Sha256Safe -Path $fileInfo.FullName
        $size = $fileInfo.Length
        $lastWrite = $fileInfo.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
        if ($null -eq $expected) { $delta = 'NEW_SINCE_ROUTE_PLAN_OR_NOT_PARSED_FROM_PLAN' }
        elseif ($expectedHash -and $currentHash -and $currentHash -eq $expectedHash) { $delta = 'HASH_MATCHED' }
        elseif ($expectedHash -and $currentHash -and $currentHash -ne $expectedHash) { $delta = 'HASH_CHANGED' }
        else { $delta = 'VERIFIED_PRESENT_EXPECTED_HASH_NOT_AVAILABLE' }
    } else {
        $delta = 'MISSING_AT_REVIEW'
    }

    if ($null -ne $fileInfo) {
        $role = Get-ReceptionistRole -FileInfo $fileInfo -DeltaStatus $delta
    } else {
        $role = [pscustomobject]@{
            Role='UNKNOWN_NEEDS_USER'; State='MISSING_AT_REVIEW'; Authority='USER_APPROVAL_REQUIRED'; Risk='MEDIUM_RISK_CUSTODY_DECISION'; Confidence='LOW_CONFIDENCE'; Proposal='PROPOSE_USER_DECISION'; Reason='Expected object was not present during live-root dry run.'
        }
    }

    if ($delta -eq 'HASH_CHANGED') {
        $role.Risk = 'BLOCKED_RISK_AUTHORITY_CONFLICT'
        $role.Confidence = 'HIGH_CONFIDENCE'
        $role.Proposal = 'PROPOSE_BLOCK'
        $role.Reason = $role.Reason + ' Hash differs from expected route-plan proof; block before any route.'
    } elseif ($delta -eq 'NEW_SINCE_ROUTE_PLAN_OR_NOT_PARSED_FROM_PLAN') {
        $role.State = 'NEW_SINCE_LAST_SNAPSHOT'
        if ($role.Risk -notmatch '^HIGH|^BLOCKED') { $role.Risk = 'MEDIUM_RISK_CUSTODY_DECISION' }
        $role.Proposal = 'PROPOSE_USER_DECISION'
        $role.Reason = $role.Reason + ' New/not-parsed relative to expected route-plan set; user review needed.'
    }

    $tickets.Add([pscustomobject]@{
        TicketID = ('RHG-DRY-{0:D3}' -f $ticketIndex)
        FileName = $name
        CurrentPath = $path
        ExpectedHash = $expectedHash
        CurrentHash = $currentHash
        SizeBytes = $size
        Extension = $ext
        LastWrite = $lastWrite
        DeltaStatus = $delta
        RoleLabel = $role.Role
        StateLabel = $role.State
        AuthorityLabel = $role.Authority
        RiskLabel = $role.Risk
        ConfidenceLabel = $role.Confidence
        ProposalLabel = $role.Proposal
        Reason = $role.Reason
        UserDecisionNeeded = if ($role.Proposal -match 'USER_DECISION|BLOCK|REVIEW') { 'YES' } else { 'NO' }
        BlockedActions = 'move;delete;rename;route;execute;commit;push;cleanup'
        ActionNow = 'NO'
    }) | Out-Null
}

$ticketsArray = [array]$tickets
$deltaGroups = $ticketsArray | Group-Object DeltaStatus | Sort-Object Name
$roleGroups = $ticketsArray | Group-Object RoleLabel | Sort-Object Name
$riskGroups = $ticketsArray | Group-Object RiskLabel | Sort-Object Name
$actionNowYes = [array]($ticketsArray | Where-Object { $_.ActionNow -ne 'NO' })
if ($actionNowYes.Count -gt 0) { $Blockers.Add("ACTION_NOW_NON_NO_ROWS count=$($actionNowYes.Count)") | Out-Null }

$verdict = if ($Blockers.Count -gt 0) {
    'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_WRITTEN_WITH_BLOCKERS_REVIEW_REQUIRED'
} elseif ($ticketsArray | Where-Object { $_.DeltaStatus -in @('HASH_CHANGED','MISSING_AT_REVIEW','NEW_SINCE_ROUTE_PLAN_OR_NOT_PARSED_FROM_PLAN') }) {
    'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_WRITTEN_WITH_LIVE_DELTAS_REVIEW_REQUIRED'
} else {
    'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_READY_WITH_NO_PHYSICAL_ACTION'
}

$report = New-Object System.Collections.Generic.List[string]
$report.Add('# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR 20260609') | Out-Null
$report.Add('') | Out-Null
$report.Add('Status: DRY_RUN_SELECTOR / RECEPTIONIST_TICKET_BOARD / READ_ONLY_REPORT / NOT_ROUTE_ORDER / NOT_CLEANUP_ORDER') | Out-Null
$report.Add('') | Out-Null
$report.Add('## 1. Active Object') | Out-Null
$report.Add('') | Out-Null
$report.Add('`USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608`') | Out-Null
$report.Add('') | Out-Null
$report.Add('This report uses the receptionist pattern: see, name, ticket, propose, review, learn, then maybe later move. This report performs no physical route.') | Out-Null
$report.Add('') | Out-Null
$report.Add('## 2. Boundary') | Out-Null
$report.Add('') | Out-Null
$report.Add('- files_moved_count: 0') | Out-Null
$report.Add('- files_deleted_count: 0') | Out-Null
$report.Add('- files_renamed_count: 0') | Out-Null
$report.Add('- files_routed_count: 0') | Out-Null
$report.Add('- files_executed_count: 0') | Out-Null
$report.Add('- commits_count: 0') | Out-Null
$report.Add('- pushes_count: 0') | Out-Null
$report.Add('- action_now_yes_rows: ' + $actionNowYes.Count) | Out-Null
$report.Add('') | Out-Null
$report.Add('## 3. Git and Route-Plan Proof Check') | Out-Null
$report.Add('') | Out-Null
$report.Add('| Check | Result |') | Out-Null
$report.Add('|---|---|') | Out-Null
$report.Add('| Project root | `' + (Escape-Md $ProjectRoot) + '` |') | Out-Null
$report.Add('| Nested repo | `' + (Escape-Md $RepoPath) + '` |') | Out-Null
$report.Add('| Expected HEAD | `' + $ExpectedHead + '` |') | Out-Null
$report.Add('| Actual HEAD | `' + (Escape-Md $gitHead) + '` |') | Out-Null
$report.Add('| Git status entries | `' + $gitStatusLines.Count + '` |') | Out-Null
$report.Add('| Route proof candidates found | `' + $routeProofCandidates.Count + '` |') | Out-Null
$report.Add('| Expected root rows parsed | `' + $expectedByPath.Keys.Count + '` |') | Out-Null
$report.Add('| Live root top-level file count | `' + $liveFiles.Count + '` |') | Out-Null
$report.Add('') | Out-Null
if ($routeProofCandidates.Count -gt 0) {
    $report.Add('### Route Proof Candidate Files') | Out-Null
    $report.Add('') | Out-Null
    foreach ($rp in $routeProofCandidates) { $report.Add('- `' + (Escape-Md $rp) + '`') | Out-Null }
    $report.Add('') | Out-Null
}
if ($Blockers.Count -gt 0) {
    $report.Add('## 4. Blockers') | Out-Null
    $report.Add('') | Out-Null
    foreach ($b in [array]$Blockers) { $report.Add('- ' + (Escape-Md $b)) | Out-Null }
    $report.Add('') | Out-Null
}
if ($Warnings.Count -gt 0) {
    $report.Add('## 5. Warnings') | Out-Null
    $report.Add('') | Out-Null
    foreach ($w in [array]$Warnings) { $report.Add('- ' + (Escape-Md $w)) | Out-Null }
    $report.Add('') | Out-Null
}
$report.Add('## 6. Delta Summary') | Out-Null
$report.Add('') | Out-Null
$report.Add('| DeltaStatus | Count |') | Out-Null
$report.Add('|---|---:|') | Out-Null
foreach ($g in [array]$deltaGroups) { $report.Add('| ' + (Escape-Md $g.Name) + ' | ' + $g.Count + ' |') | Out-Null }
$report.Add('') | Out-Null
$report.Add('## 7. Role Summary') | Out-Null
$report.Add('') | Out-Null
$report.Add('| RoleLabel | Count |') | Out-Null
$report.Add('|---|---:|') | Out-Null
foreach ($g in [array]$roleGroups) { $report.Add('| ' + (Escape-Md $g.Name) + ' | ' + $g.Count + ' |') | Out-Null }
$report.Add('') | Out-Null
$report.Add('## 8. Risk Summary') | Out-Null
$report.Add('') | Out-Null
$report.Add('| RiskLabel | Count |') | Out-Null
$report.Add('|---|---:|') | Out-Null
foreach ($g in [array]$riskGroups) { $report.Add('| ' + (Escape-Md $g.Name) + ' | ' + $g.Count + ' |') | Out-Null }
$report.Add('') | Out-Null
$report.Add('## 9. Receptionist Ticket Board') | Out-Null
$report.Add('') | Out-Null
$report.Add('| TicketID | FileName | DeltaStatus | RoleLabel | StateLabel | RiskLabel | ConfidenceLabel | ProposalLabel | UserDecisionNeeded | ActionNow |') | Out-Null
$report.Add('|---|---|---|---|---|---|---|---|---|---|') | Out-Null
foreach ($t in $ticketsArray) {
    $report.Add('| ' + (Escape-Md $t.TicketID) + ' | `' + (Escape-Md $t.FileName) + '` | ' + (Escape-Md $t.DeltaStatus) + ' | ' + (Escape-Md $t.RoleLabel) + ' | ' + (Escape-Md $t.StateLabel) + ' | ' + (Escape-Md $t.RiskLabel) + ' | ' + (Escape-Md $t.ConfidenceLabel) + ' | ' + (Escape-Md $t.ProposalLabel) + ' | ' + (Escape-Md $t.UserDecisionNeeded) + ' | ' + (Escape-Md $t.ActionNow) + ' |') | Out-Null
}
$report.Add('') | Out-Null
$report.Add('## 10. Ticket Detail') | Out-Null
$report.Add('') | Out-Null
foreach ($t in $ticketsArray) {
    $report.Add('### ' + (Escape-Md $t.TicketID) + ' — `' + (Escape-Md $t.FileName) + '`') | Out-Null
    $report.Add('') | Out-Null
    $report.Add('- current_path: `' + (Escape-Md $t.CurrentPath) + '`') | Out-Null
    $report.Add('- expected_sha256: `' + (Escape-Md $t.ExpectedHash) + '`') | Out-Null
    $report.Add('- current_sha256: `' + (Escape-Md $t.CurrentHash) + '`') | Out-Null
    $report.Add('- size_bytes: `' + (Escape-Md ([string]$t.SizeBytes)) + '`') | Out-Null
    $report.Add('- last_write: `' + (Escape-Md $t.LastWrite) + '`') | Out-Null
    $report.Add('- authority_label: `' + (Escape-Md $t.AuthorityLabel) + '`') | Out-Null
    $report.Add('- blocked_actions: `' + (Escape-Md $t.BlockedActions) + '`') | Out-Null
    $report.Add('- reason: ' + (Escape-Md $t.Reason)) | Out-Null
    $report.Add('- action_now: `NO`') | Out-Null
    $report.Add('') | Out-Null
}
$report.Add('## 11. Stress Bench') | Out-Null
$report.Add('') | Out-Null
$report.Add('| Stress Item | Result |') | Out-Null
$report.Add('|---|---|') | Out-Null
$report.Add('| No move | PASS |') | Out-Null
$report.Add('| No delete | PASS |') | Out-Null
$report.Add('| No rename | PASS |') | Out-Null
$report.Add('| No route execution | PASS |') | Out-Null
$report.Add('| No helper execution | PASS |') | Out-Null
$report.Add('| No commit | PASS |') | Out-Null
$report.Add('| No push | PASS |') | Out-Null
$report.Add('| ActionNow defaults to NO | ' + ($(if ($actionNowYes.Count -eq 0) { 'PASS' } else { 'FAIL' })) + ' |') | Out-Null
$report.Add('| Blockers present | ' + ($(if ($Blockers.Count -eq 0) { 'NO' } else { 'YES' })) + ' |') | Out-Null
$report.Add('') | Out-Null
$report.Add('## 12. DoesNotProve') | Out-Null
$report.Add('') | Out-Null
$report.Add('This dry-run selector report proves only that the live root was snapshotted, route-plan proof candidates were searched, expected rows were parsed where possible, receptionist tickets were generated, and no physical file action was performed.') | Out-Null
$report.Add('') | Out-Null
$report.Add('It does not prove that any file should move, any destination is approved, any helper is safe to run, cleanup is approved, Git push is approved, route execution is approved, source is correct, or the project is complete.') | Out-Null
$report.Add('') | Out-Null
$report.Add('## 13. Next Single Action') | Out-Null
$report.Add('') | Out-Null
if ($Blockers.Count -gt 0) {
    $report.Add('Review blockers and repair the same failure family before any executor or physical route is designed.') | Out-Null
} else {
    $report.Add('User reviews the ticket board and explicitly marks which rows, if any, may become approved-for-later movement candidates. No executor exists yet.') | Out-Null
}
$report.Add('') | Out-Null
$report.Add('Final scoped verdict: `' + $verdict + '`') | Out-Null

[System.IO.File]::WriteAllLines($ReportPath, [string[]]$report, [System.Text.UTF8Encoding]::new($false))
$ReportHash = Get-Sha256Safe -Path $ReportPath

$receipt = @(
    'ROOT HELD GROUP ROUTE DRY-RUN SELECTOR RECEIPT 20260609',
    "created_at: $(Get-Date -Format o)",
    "script_result: REPORT_WRITTEN",
    "report_path: $ReportPath",
    "report_sha256: $ReportHash",
    "project_root: $ProjectRoot",
    "repo_path: $RepoPath",
    "expected_head: $ExpectedHead",
    "actual_head: $gitHead",
    "git_status_entry_count: $($gitStatusLines.Count)",
    "route_proof_candidate_count: $($routeProofCandidates.Count)",
    "expected_root_rows_parsed_count: $($expectedByPath.Keys.Count)",
    "live_root_top_level_file_count: $($liveFiles.Count)",
    "ticket_count: $($ticketsArray.Count)",
    "blocker_count: $($Blockers.Count)",
    "warning_count: $($Warnings.Count)",
    'files_moved_count: 0',
    'files_deleted_count: 0',
    'files_renamed_count: 0',
    'files_routed_count: 0',
    'files_executed_count: 0',
    'commits_count: 0',
    'pushes_count: 0',
    "final_verdict: $verdict",
    'does_not_prove: movement approved; cleanup approved; executor approved; helper safe; source correct; project complete'
)
[System.IO.File]::WriteAllLines($ReceiptPath, [string[]]$receipt, [System.Text.UTF8Encoding]::new($false))
$ReceiptHash = Get-Sha256Safe -Path $ReceiptPath

Write-Host '=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR COMPLETE ==='
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportHash"
Write-Host "output_receipt_path: $ReceiptPath"
Write-Host "output_receipt_sha256: $ReceiptHash"
Write-Host "final_verdict: $verdict"
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
