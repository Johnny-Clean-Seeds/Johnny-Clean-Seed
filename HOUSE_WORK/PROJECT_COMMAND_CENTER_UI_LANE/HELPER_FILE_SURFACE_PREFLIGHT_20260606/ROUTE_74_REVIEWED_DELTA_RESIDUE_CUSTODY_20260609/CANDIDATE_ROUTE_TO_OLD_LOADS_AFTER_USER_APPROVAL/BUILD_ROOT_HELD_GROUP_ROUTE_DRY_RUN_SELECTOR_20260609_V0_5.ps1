<#
ROOT HELD GROUP ROUTE DRY-RUN SELECTOR 20260609 V0.5
Status: DRY_RUN_SELECTOR_BUILDER_REPAIR_V0_5 / READ_ONLY_CLASSIFICATION / NO_PHYSICAL_ROUTING

Repair reason:
  V0.1 failed on scalar .Count under strict mode.
  V0.2 failed on strict parameter binding shape.
  V0.3 failed on unescaped Windows path regex.
  V0.4 still failed with Argument types do not match.
  V0.5 stops the brittle expected-row parser chain. It verifies route-plan proof candidates and creates a live-root receptionist ticket board only.

Boundary:
  This script does not move, delete, rename, route, execute helper scripts, commit, push, or rewrite source.
  It writes only report/receipt/freeze/fix-note files into the existing helper-file surface preflight lane.
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = (Join-Path $env:USERPROFILE 'Desktop\123'),
    [string]$RepoRel = 'Jxhnny_Kl33N_Seedz',
    [string]$LaneRel = 'HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606',
    [string]$ExpectedHead = 'bdc74ff82837fe30a10f7f5047d0b54b65321016'
)

$ErrorActionPreference = 'Stop'

$ReportName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_20260609.md'
$ReceiptName = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_RECEIPT_V0_5_20260609.txt'
$ErrorFreezeName = 'ERROR_FREEZE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_4_ARGUMENT_TYPES_MISMATCH_20260609.md'
$FixNoteName = 'FIX_NOTE__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_PARSER_REMOVED_LIVE_ROOT_BOARD_20260609.md'
$FixReceiptName = 'HASH_RECEIPT__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_V0_5_FIX_20260609.txt'

function Count-Items($Value) {
    if ($null -eq $Value) { return 0 }
    return @($Value).Length
}

function Add-Line($List, $Text) {
    [void]$List.Add([string]$Text)
}

function Escape-Md($Text) {
    if ($null -eq $Text) { return '' }
    $s = [string]$Text
    $s = $s -replace '\|','\\|'
    $s = $s -replace "`r?`n", ' '
    return $s
}

function Get-Sha256Safe($Path) {
    try {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
        return ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash).ToUpperInvariant()
    } catch {
        return ('HASH_READ_FAILED: ' + $_.Exception.Message)
    }
}

function Run-Git($RepoPath, $ArgsArray) {
    try {
        $out = @(& git -C $RepoPath @ArgsArray 2>&1)
        $code = $LASTEXITCODE
        return [pscustomobject]@{ Code = $code; Output = $out }
    } catch {
        return [pscustomobject]@{ Code = 999; Output = @($_.Exception.Message) }
    }
}

function Get-ReceptionistRole($Name, $Ext, $SizeBytes) {
    $lowerExt = ''
    if ($null -ne $Ext) { $lowerExt = ([string]$Ext).ToLowerInvariant() }
    $fileName = [string]$Name
    $size = 0
    if ($null -ne $SizeBytes) { $size = [int64]$SizeBytes }

    if ($fileName -ieq 'desktop.ini') {
        return [pscustomobject]@{ Role='SYSTEM_FILE_LEAVE_IN_PLACE'; State='VERIFIED_PRESENT'; Authority='ORIENTS_ONLY'; Risk='BLOCKED_RISK_SYSTEM_FILE'; Confidence='HIGH_CONFIDENCE'; Proposal='PROPOSE_LEAVE_IN_PLACE'; Reason='Windows/system metadata candidate; not deletion proof.' }
    }
    if ($lowerExt -in @('.ps1','.bat','.cmd','.exe','.vbs','.js','.py','.psm1')) {
        return [pscustomobject]@{ Role='EXECUTABLE_HELPER_REVIEW_REQUIRED'; State='VERIFIED_PRESENT'; Authority='EXECUTION_CANDIDATE_ONLY'; Risk='HIGH_RISK_EXECUTABLE'; Confidence='HIGH_CONFIDENCE'; Proposal='PROPOSE_REVIEW_AS_HELPER'; Reason='Executable or script-like file; review only, never auto-run.' }
    }
    if ($fileName -match '(?i)receipt|hash_receipt') {
        return [pscustomobject]@{ Role='RECEIPT'; State='VERIFIED_PRESENT'; Authority='PROVES_PAST_ACTION'; Risk='LOW_RISK_POINTER'; Confidence='HIGH_CONFIDENCE'; Proposal='PROPOSE_INDEX_AS_PROOF_HISTORY'; Reason='Name indicates receipt/proof object; receipt is proof, not active order.' }
    }
    if ($fileName -match '(?i)error_freeze|failure|incident') {
        return [pscustomobject]@{ Role='ERROR_FREEZE'; State='VERIFIED_PRESENT'; Authority='PROVES_PAST_ACTION'; Risk='MEDIUM_RISK_CUSTODY_DECISION'; Confidence='HIGH_CONFIDENCE'; Proposal='PROPOSE_INDEX_AS_PROOF_HISTORY'; Reason='Name indicates failure freeze or incident evidence.' }
    }
    if ($fileName -match '(?i)fix_note|repair') {
        return [pscustomobject]@{ Role='FIX_NOTE'; State='VERIFIED_PRESENT'; Authority='SUPPORTS_DECISION'; Risk='LOW_RISK_SUPPORT'; Confidence='MEDIUM_CONFIDENCE'; Proposal='PROPOSE_KEEP_AS_SUPPORT'; Reason='Name indicates repair/fix support note.' }
    }
    if ($fileName -match '(?i)route|ledger|closeout|option|queue|review|plan') {
        return [pscustomobject]@{ Role='LEDGER'; State='VERIFIED_PRESENT'; Authority='SUPPORTS_DECISION'; Risk='MEDIUM_RISK_CUSTODY_DECISION'; Confidence='MEDIUM_CONFIDENCE'; Proposal='PROPOSE_KEEP_AS_SUPPORT'; Reason='Name indicates planning/review/ledger object; not movement authority.' }
    }
    if ($size -eq 0) {
        return [pscustomobject]@{ Role='OLD_LOAD_OR_SUPERSEDED'; State='VERIFIED_PRESENT'; Authority='ORIENTS_ONLY'; Risk='MEDIUM_RISK_OLD_LOAD'; Confidence='LOW_CONFIDENCE'; Proposal='PROPOSE_USER_DECISION'; Reason='Zero-byte file is a review signal only; not trash proof.' }
    }
    if ($lowerExt -in @('.md','.txt','.json','.csv','.log')) {
        return [pscustomobject]@{ Role='SUPPORT_GUARDRAIL'; State='VERIFIED_PRESENT'; Authority='ORIENTS_ONLY'; Risk='LOW_RISK_SUPPORT'; Confidence='MEDIUM_CONFIDENCE'; Proposal='PROPOSE_KEEP_AS_SUPPORT'; Reason='Text/support-like file; review as support unless current source proof says otherwise.' }
    }

    return [pscustomobject]@{ Role='UNKNOWN_NEEDS_USER'; State='USER_DECISION_REQUIRED'; Authority='USER_APPROVAL_REQUIRED'; Risk='MEDIUM_RISK_CUSTODY_DECISION'; Confidence='LOW_CONFIDENCE'; Proposal='PROPOSE_USER_DECISION'; Reason='No strong controlled-label match; user review required.' }
}

$RepoPath = Join-Path $ProjectRoot $RepoRel
$LanePath = Join-Path $ProjectRoot $LaneRel
$ReportPath = Join-Path $LanePath $ReportName
$ReceiptPath = Join-Path $LanePath $ReceiptName
$ErrorFreezePath = Join-Path $LanePath $ErrorFreezeName
$FixNotePath = Join-Path $LanePath $FixNoteName
$FixReceiptPath = Join-Path $LanePath $FixReceiptName

$Blockers = New-Object System.Collections.ArrayList
$Warnings = New-Object System.Collections.ArrayList

if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) { throw ('Project root not found: ' + $ProjectRoot) }
if (-not (Test-Path -LiteralPath $LanePath -PathType Container)) { throw ('Lane path not found. Refusing to create new lane folder during dry-run selector repair: ' + $LanePath) }

foreach ($outPath in @($ReportPath,$ReceiptPath,$ErrorFreezePath,$FixNotePath,$FixReceiptPath)) {
    if (Test-Path -LiteralPath $outPath -PathType Leaf) { throw ('Output already exists. Refusing overwrite: ' + $outPath) }
}

$gitAvailable = $true
try { $null = & git --version 2>&1 } catch { $gitAvailable = $false }
if (-not $gitAvailable) { [void]$Blockers.Add('GIT_NOT_AVAILABLE') }

$gitHead = $null
$gitStatusLines = @()
if (Test-Path -LiteralPath $RepoPath -PathType Container) {
    if ($gitAvailable) {
        $headResult = Run-Git $RepoPath @('rev-parse','HEAD')
        if ($headResult.Code -eq 0 -and (Count-Items $headResult.Output) -gt 0) {
            $gitHead = ([string]@($headResult.Output)[0]).Trim()
        } else {
            [void]$Blockers.Add('GIT_HEAD_READ_FAILED')
        }
        $statusResult = Run-Git $RepoPath @('status','--porcelain')
        if ($statusResult.Code -eq 0) { $gitStatusLines = @($statusResult.Output) } else { [void]$Blockers.Add('GIT_STATUS_READ_FAILED') }
        if ($null -ne $gitHead -and $gitHead -ne $ExpectedHead) { [void]$Blockers.Add(('EXPECTED_HEAD_MISMATCH expected=' + $ExpectedHead + ' actual=' + $gitHead)) }
        if ((Count-Items $gitStatusLines) -gt 0) { [void]$Blockers.Add(('GIT_STATUS_NOT_CLEAN count=' + (Count-Items $gitStatusLines))) }
    }
} else {
    [void]$Blockers.Add(('REPO_PATH_NOT_FOUND ' + $RepoPath))
}

$routeProofCandidates = @()
foreach ($base in @($LanePath,$RepoPath)) {
    if (Test-Path -LiteralPath $base -PathType Container) {
        $found = @(Get-ChildItem -LiteralPath $base -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'ROOT_HELD_GROUP_ROUTE_PLAN_ONLY|ROOT_HELD_GROUP_ROUTE|HELD_GROUP_ROUTE' } | Select-Object -ExpandProperty FullName)
        if ((Count-Items $found) -gt 0) { $routeProofCandidates += $found }
    }
}
$routeProofCandidates = @($routeProofCandidates | Where-Object { $null -ne $_ -and ([string]$_).Trim().Length -gt 0 } | Sort-Object -Unique)
if ((Count-Items $routeProofCandidates) -eq 0) { [void]$Blockers.Add('ROUTE_PLAN_PROOF_OBJECTS_NOT_FOUND_BY_NAME_SEARCH') }

[void]$Warnings.Add('EXPECTED_ROUTE_PLAN_ROW_PARSING_DISABLED_IN_V0_5_AFTER_REPEATED_GENERATED_PARSER_FAILURES; live-root ticket board is conservative and non-mutating.')

$liveFiles = @(Get-ChildItem -LiteralPath $ProjectRoot -File -Force -ErrorAction Stop | Sort-Object Name)
$tickets = New-Object System.Collections.ArrayList
$ticketIndex = 0
foreach ($fileInfo in $liveFiles) {
    $ticketIndex++
    $hash = Get-Sha256Safe $fileInfo.FullName
    $role = Get-ReceptionistRole $fileInfo.Name $fileInfo.Extension $fileInfo.Length

    # V0.5 is intentionally conservative: because expected route-plan row parsing is disabled, every live root file is review-current, not movement-ready.
    $delta = 'LIVE_ROOT_PRESENT_REVIEW_REQUIRED'
    $state = $role.State
    $risk = $role.Risk
    $proposal = $role.Proposal
    $reason = $role.Reason + ' V0.5 did not compare against route-plan rows; no movement eligibility is inferred.'
    if ($risk -notmatch '^HIGH|^BLOCKED' -and $proposal -ne 'PROPOSE_LEAVE_IN_PLACE') { $risk = 'MEDIUM_RISK_CUSTODY_DECISION' }
    if ($proposal -ne 'PROPOSE_LEAVE_IN_PLACE') { $proposal = 'PROPOSE_USER_DECISION' }
    if ($state -eq 'VERIFIED_PRESENT') { $state = 'HELD_PENDING_REVIEW' }

    $userDecision = 'YES'
    if ($role.Role -eq 'SYSTEM_FILE_LEAVE_IN_PLACE') { $userDecision = 'NO' }

    [void]$tickets.Add([pscustomobject]@{
        TicketID = ('RHG-DRY-{0:D3}' -f $ticketIndex)
        FileName = $fileInfo.Name
        CurrentPath = $fileInfo.FullName
        CurrentHash = $hash
        SizeBytes = $fileInfo.Length
        Extension = $fileInfo.Extension
        LastWrite = $fileInfo.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
        DeltaStatus = $delta
        RoleLabel = $role.Role
        StateLabel = $state
        AuthorityLabel = $role.Authority
        RiskLabel = $risk
        ConfidenceLabel = $role.Confidence
        ProposalLabel = $proposal
        Reason = $reason
        UserDecisionNeeded = $userDecision
        BlockedActions = 'move;delete;rename;route;execute;commit;push;cleanup'
        ActionNow = 'NO'
    })
}

$ticketsArray = @($tickets)
$deltaGroups = @($ticketsArray | Group-Object DeltaStatus | Sort-Object Name)
$roleGroups = @($ticketsArray | Group-Object RoleLabel | Sort-Object Name)
$riskGroups = @($ticketsArray | Group-Object RiskLabel | Sort-Object Name)
$actionNowYes = @($ticketsArray | Where-Object { $_.ActionNow -ne 'NO' })
if ((Count-Items $actionNowYes) -gt 0) { [void]$Blockers.Add(('ACTION_NOW_NON_NO_ROWS count=' + (Count-Items $actionNowYes))) }

$verdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_WRITTEN_WITH_CONSERVATIVE_LIVE_ROOT_REVIEW_REQUIRED'
if ((Count-Items $Blockers) -gt 0) { $verdict = 'ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_V0_5_WRITTEN_WITH_BLOCKERS_REVIEW_REQUIRED' }

$freeze = New-Object System.Collections.ArrayList
Add-Line $freeze '# ERROR FREEZE — ROOT HELD ROUTE DRY-RUN SELECTOR V0.4 ARGUMENT TYPES MISMATCH 20260609'
Add-Line $freeze ''
Add-Line $freeze 'Status: ERROR_FREEZE / SCRIPT_DEFECT_CAPTURE / NOT_ROUTE_FAILURE / NOT_USER_ERROR'
Add-Line $freeze ''
Add-Line $freeze '## Trigger'
Add-Line $freeze ''
Add-Line $freeze 'V0.4 failed from the terminal with: `Argument types do not match`. The terminal did not return a useful line pointer. This is recorded as a continued generated-runner parser/input-shape defect in the same dry-run selector chain.'
Add-Line $freeze ''
Add-Line $freeze '## Failure Family'
Add-Line $freeze ''
Add-Line $freeze 'V0.1 failed on scalar `.Count`; V0.2 failed on strict parameter binding; V0.3 failed on unescaped Windows path regex; V0.4 still failed on an argument-type mismatch. The common family is brittle parser/input-shape handling in generated PowerShell.'
Add-Line $freeze ''
Add-Line $freeze '## DoesNotProve'
Add-Line $freeze ''
Add-Line $freeze 'This error does not prove route failure, Git failure, user misuse, file safety, cleanup approval, or movement approval. It proves only a generated-script dry-run selector defect.'

$fix = New-Object System.Collections.ArrayList
Add-Line $fix '# FIX NOTE — ROOT HELD ROUTE DRY-RUN SELECTOR V0.5 PARSER REMOVED / LIVE ROOT BOARD 20260609'
Add-Line $fix ''
Add-Line $fix 'Status: FIX_NOTE / SAME_FAILURE_FAMILY_REPAIR / NO_PHYSICAL_ROUTING'
Add-Line $fix ''
Add-Line $fix '## Fix'
Add-Line $fix ''
Add-Line $fix 'V0.5 stops trying to repair the brittle expected-row parser. It verifies the expected Git head, checks clean Git status, searches for route-plan proof objects by filename, snapshots the live project root, hashes live top-level files, and creates receptionist tickets. Because expected route-plan row parsing is disabled, every non-system live-root file remains review-required and no movement eligibility is inferred.'
Add-Line $fix ''
Add-Line $fix '## Boundary'
Add-Line $fix ''
Add-Line $fix 'This fix does not authorize movement, deletion, cleanup, route execution, helper execution, commit, or push.'

[System.IO.File]::WriteAllLines($ErrorFreezePath, [string[]]$freeze, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllLines($FixNotePath, [string[]]$fix, [System.Text.UTF8Encoding]::new($false))
$ErrorFreezeHash = Get-Sha256Safe $ErrorFreezePath
$FixNoteHash = Get-Sha256Safe $FixNotePath

$report = New-Object System.Collections.ArrayList
Add-Line $report '# ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 20260609'
Add-Line $report ''
Add-Line $report 'Status: DRY_RUN_SELECTOR / RECEPTIONIST_TICKET_BOARD / READ_ONLY_REPORT / NOT_ROUTE_ORDER / NOT_CLEANUP_ORDER'
Add-Line $report ''
Add-Line $report '## 1. Active Object'
Add-Line $report ''
Add-Line $report '`USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608`'
Add-Line $report ''
Add-Line $report 'This report uses the receptionist pattern: see, name, ticket, propose, review, learn, then maybe later move. This report performs no physical route.'
Add-Line $report ''
Add-Line $report '## 2. Failure Capture'
Add-Line $report ''
Add-Line $report ('- error_freeze_path: `' + (Escape-Md $ErrorFreezePath) + '`')
Add-Line $report ('- error_freeze_sha256: `' + (Escape-Md $ErrorFreezeHash) + '`')
Add-Line $report ('- fix_note_path: `' + (Escape-Md $FixNotePath) + '`')
Add-Line $report ('- fix_note_sha256: `' + (Escape-Md $FixNoteHash) + '`')
Add-Line $report ''
Add-Line $report '## 3. Boundary'
Add-Line $report ''
Add-Line $report '- files_moved_count: 0'
Add-Line $report '- files_deleted_count: 0'
Add-Line $report '- files_renamed_count: 0'
Add-Line $report '- files_routed_count: 0'
Add-Line $report '- files_executed_count: 0'
Add-Line $report '- commits_count: 0'
Add-Line $report '- pushes_count: 0'
Add-Line $report ('- action_now_yes_rows: ' + (Count-Items $actionNowYes))
Add-Line $report ''
Add-Line $report '## 4. Git and Route-Plan Proof Check'
Add-Line $report ''
Add-Line $report '| Check | Result |'
Add-Line $report '|---|---|'
Add-Line $report ('| Project root | `' + (Escape-Md $ProjectRoot) + '` |')
Add-Line $report ('| Nested repo | `' + (Escape-Md $RepoPath) + '` |')
Add-Line $report ('| Expected HEAD | `' + (Escape-Md $ExpectedHead) + '` |')
Add-Line $report ('| Actual HEAD | `' + (Escape-Md $gitHead) + '` |')
Add-Line $report ('| Git status entries | `' + (Count-Items $gitStatusLines) + '` |')
Add-Line $report ('| Route proof candidates found | `' + (Count-Items $routeProofCandidates) + '` |')
Add-Line $report '| Expected root rows parsed | `0 - parser disabled in V0.5 after repeated generated-parser defects` |'
Add-Line $report ('| Live root top-level file count | `' + (Count-Items $liveFiles) + '` |')
Add-Line $report ''

if ((Count-Items $routeProofCandidates) -gt 0) {
    Add-Line $report '### Route Proof Candidate Files'
    Add-Line $report ''
    foreach ($rp in $routeProofCandidates) { Add-Line $report ('- `' + (Escape-Md $rp) + '`') }
    Add-Line $report ''
}
if ((Count-Items $Blockers) -gt 0) {
    Add-Line $report '## 5. Blockers'
    Add-Line $report ''
    foreach ($b in $Blockers) { Add-Line $report ('- ' + (Escape-Md $b)) }
    Add-Line $report ''
}
if ((Count-Items $Warnings) -gt 0) {
    Add-Line $report '## 6. Warnings'
    Add-Line $report ''
    foreach ($w in $Warnings) { Add-Line $report ('- ' + (Escape-Md $w)) }
    Add-Line $report ''
}
Add-Line $report '## 7. Delta Summary'
Add-Line $report ''
Add-Line $report '| DeltaStatus | Count |'
Add-Line $report '|---|---:|'
foreach ($g in $deltaGroups) { Add-Line $report ('| ' + (Escape-Md $g.Name) + ' | ' + (Count-Items $g.Group) + ' |') }
Add-Line $report ''
Add-Line $report '## 8. Role Summary'
Add-Line $report ''
Add-Line $report '| RoleLabel | Count |'
Add-Line $report '|---|---:|'
foreach ($g in $roleGroups) { Add-Line $report ('| ' + (Escape-Md $g.Name) + ' | ' + (Count-Items $g.Group) + ' |') }
Add-Line $report ''
Add-Line $report '## 9. Risk Summary'
Add-Line $report ''
Add-Line $report '| RiskLabel | Count |'
Add-Line $report '|---|---:|'
foreach ($g in $riskGroups) { Add-Line $report ('| ' + (Escape-Md $g.Name) + ' | ' + (Count-Items $g.Group) + ' |') }
Add-Line $report ''
Add-Line $report '## 10. Receptionist Ticket Board'
Add-Line $report ''
Add-Line $report '| TicketID | FileName | DeltaStatus | RoleLabel | StateLabel | RiskLabel | ConfidenceLabel | ProposalLabel | UserDecisionNeeded | ActionNow |'
Add-Line $report '|---|---|---|---|---|---|---|---|---|---|'
foreach ($t in $ticketsArray) {
    Add-Line $report ('| ' + (Escape-Md $t.TicketID) + ' | `' + (Escape-Md $t.FileName) + '` | ' + (Escape-Md $t.DeltaStatus) + ' | ' + (Escape-Md $t.RoleLabel) + ' | ' + (Escape-Md $t.StateLabel) + ' | ' + (Escape-Md $t.RiskLabel) + ' | ' + (Escape-Md $t.ConfidenceLabel) + ' | ' + (Escape-Md $t.ProposalLabel) + ' | ' + (Escape-Md $t.UserDecisionNeeded) + ' | ' + (Escape-Md $t.ActionNow) + ' |')
}
Add-Line $report ''
Add-Line $report '## 11. Ticket Detail'
Add-Line $report ''
foreach ($t in $ticketsArray) {
    Add-Line $report ('### ' + (Escape-Md $t.TicketID) + ' — `' + (Escape-Md $t.FileName) + '`')
    Add-Line $report ''
    Add-Line $report ('- current_path: `' + (Escape-Md $t.CurrentPath) + '`')
    Add-Line $report ('- current_sha256: `' + (Escape-Md $t.CurrentHash) + '`')
    Add-Line $report ('- size_bytes: `' + (Escape-Md ([string]$t.SizeBytes)) + '`')
    Add-Line $report ('- last_write: `' + (Escape-Md $t.LastWrite) + '`')
    Add-Line $report ('- authority_label: `' + (Escape-Md $t.AuthorityLabel) + '`')
    Add-Line $report ('- blocked_actions: `' + (Escape-Md $t.BlockedActions) + '`')
    Add-Line $report ('- reason: ' + (Escape-Md $t.Reason))
    Add-Line $report '- action_now: `NO`'
    Add-Line $report ''
}
Add-Line $report '## 12. Stress Bench'
Add-Line $report ''
Add-Line $report '| Stress Item | Result |'
Add-Line $report '|---|---|'
Add-Line $report '| No move | PASS |'
Add-Line $report '| No delete | PASS |'
Add-Line $report '| No rename | PASS |'
Add-Line $report '| No route execution | PASS |'
Add-Line $report '| No helper execution | PASS |'
Add-Line $report '| No commit | PASS |'
Add-Line $report '| No push | PASS |'
if ((Count-Items $actionNowYes) -eq 0) { Add-Line $report '| ActionNow defaults to NO | PASS |' } else { Add-Line $report '| ActionNow defaults to NO | FAIL |' }
if ((Count-Items $Blockers) -eq 0) { Add-Line $report '| Blockers present | NO |' } else { Add-Line $report '| Blockers present | YES |' }
Add-Line $report ''
Add-Line $report '## 13. DoesNotProve'
Add-Line $report ''
Add-Line $report 'This V0.5 dry-run selector report proves only that Git state was checked, route-plan proof candidates were searched, the live root was snapshotted, live top-level files were hashed, receptionist tickets were generated, the V0.4 failure was frozen, and no physical file action was performed.'
Add-Line $report ''
Add-Line $report 'It does not prove that any file should move, any destination is approved, any helper is safe to run, cleanup is approved, Git push is approved, route execution is approved, source is correct, or the project is complete.'
Add-Line $report ''
Add-Line $report '## 14. Next Single Action'
Add-Line $report ''
if ((Count-Items $Blockers) -gt 0) { Add-Line $report 'Review blockers and repair only this dry-run selector chain before any executor or physical route is designed.' } else { Add-Line $report 'User reviews the live-root receptionist ticket board. Because V0.5 intentionally disables expected-row parsing, no row is movement eligible from this report alone.' }
Add-Line $report ''
Add-Line $report ('Final scoped verdict: `' + $verdict + '`')

[System.IO.File]::WriteAllLines($ReportPath, [string[]]$report, [System.Text.UTF8Encoding]::new($false))
$ReportHash = Get-Sha256Safe $ReportPath

$receipt = @(
    'ROOT HELD GROUP ROUTE DRY-RUN SELECTOR RECEIPT V0.5 20260609',
    ('created_at: ' + (Get-Date -Format o)),
    'script_result: REPORT_WRITTEN',
    ('error_freeze_path: ' + $ErrorFreezePath),
    ('error_freeze_sha256: ' + $ErrorFreezeHash),
    ('fix_note_path: ' + $FixNotePath),
    ('fix_note_sha256: ' + $FixNoteHash),
    ('report_path: ' + $ReportPath),
    ('report_sha256: ' + $ReportHash),
    ('project_root: ' + $ProjectRoot),
    ('repo_path: ' + $RepoPath),
    ('expected_head: ' + $ExpectedHead),
    ('actual_head: ' + $gitHead),
    ('git_status_entry_count: ' + (Count-Items $gitStatusLines)),
    ('route_proof_candidate_count: ' + (Count-Items $routeProofCandidates)),
    'expected_root_rows_parsed_count: 0',
    'expected_root_rows_parse_status: DISABLED_IN_V0_5_AFTER_REPEATED_GENERATED_PARSER_FAILURES',
    ('live_root_top_level_file_count: ' + (Count-Items $liveFiles)),
    ('ticket_count: ' + (Count-Items $ticketsArray)),
    ('blocker_count: ' + (Count-Items $Blockers)),
    ('warning_count: ' + (Count-Items $Warnings)),
    'files_moved_count: 0',
    'files_deleted_count: 0',
    'files_renamed_count: 0',
    'files_routed_count: 0',
    'files_executed_count: 0',
    'commits_count: 0',
    'pushes_count: 0',
    ('final_verdict: ' + $verdict),
    'does_not_prove: movement approved; cleanup approved; executor approved; helper safe; source correct; project complete'
)
[System.IO.File]::WriteAllLines($ReceiptPath, [string[]]$receipt, [System.Text.UTF8Encoding]::new($false))
$ReceiptHash = Get-Sha256Safe $ReceiptPath

$fixReceipt = @(
    'HASH RECEIPT ROOT HELD ROUTE DRY-RUN SELECTOR V0.5 FIX 20260609',
    ('created_at: ' + (Get-Date -Format o)),
    ('error_freeze_path: ' + $ErrorFreezePath),
    ('error_freeze_sha256: ' + $ErrorFreezeHash),
    ('fix_note_path: ' + $FixNotePath),
    ('fix_note_sha256: ' + $FixNoteHash),
    ('dry_run_report_path: ' + $ReportPath),
    ('dry_run_report_sha256: ' + $ReportHash),
    ('dry_run_receipt_path: ' + $ReceiptPath),
    ('dry_run_receipt_sha256: ' + $ReceiptHash),
    'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0',
    ('final_verdict: ' + $verdict)
)
[System.IO.File]::WriteAllLines($FixReceiptPath, [string[]]$fixReceipt, [System.Text.UTF8Encoding]::new($false))
$FixReceiptHash = Get-Sha256Safe $FixReceiptPath

Write-Host '=== ROOT HELD GROUP ROUTE DRY-RUN SELECTOR V0.5 COMPLETE ==='
Write-Host ('error_freeze_path: ' + $ErrorFreezePath)
Write-Host ('error_freeze_sha256: ' + $ErrorFreezeHash)
Write-Host ('fix_note_path: ' + $FixNotePath)
Write-Host ('fix_note_sha256: ' + $FixNoteHash)
Write-Host ('fix_receipt_path: ' + $FixReceiptPath)
Write-Host ('fix_receipt_sha256: ' + $FixReceiptHash)
Write-Host ('output_report_path: ' + $ReportPath)
Write-Host ('output_report_sha256: ' + $ReportHash)
Write-Host ('output_receipt_path: ' + $ReceiptPath)
Write-Host ('output_receipt_sha256: ' + $ReceiptHash)
Write-Host ('final_verdict: ' + $verdict)
Write-Host 'physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0'
