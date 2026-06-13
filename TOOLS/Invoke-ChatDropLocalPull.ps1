[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string]$SourceChatDrop = (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Chat Drop'),
    [string]$PeerChatDrop = (Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) '123') 'Chat Drop'),
    [string]$OutputRoot = (Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) '123') '_CHAT_DROP_LOCAL_PULLS'),
    [string]$IntentionalNegativeTestName = '',
    [string]$ExpectedFailureContains = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:PullRoot = $null
$script:ReportOut = $null
$script:EvidenceOutputRoot = $OutputRoot
$script:LastCleanPoint = 'SCRIPT_START'
$script:FirstFailingPoint = ''
$script:NegativeTestRows = New-Object System.Collections.Generic.List[object]

$currentFiles = @(
    '00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__V0_1_20260613.md',
    'CHAT_DROP_COPY__CLEAR_LENS_ENTRY_SUIT_AND_OUTSIDE_AGENT_IDENTITY_CARD_V0_1_20260613.md',
    'CHAT_DROP_COPY__COLLABORATIVE_STEERING_STACK_AND_GATE_DISCIPLINE_V0_1_20260613.md',
    'CHAT_DROP_COPY__PULL_MEANS_LOCAL_FILES_RULE_V0_1_20260613.md',
    'CHAT_DROP_COPY__HELPER_ERROR_EVIDENCE_LOGGING_RULE_V0_1_20260613.md',
    'CHAT_DROP_COPY__HELPER_ERROR_CATALOG_RULE_V0_1_20260613.md',
    'CHAT_DROP_COPY__HELPER_GAP_AND_CAUSE_LADDER_RULE_V0_1_20260613.md',
    'CHAT_DROP_COPY__WEB_SEARCH_CRAWL_LADDER_RULE_V0_1_20260613.md',
    'CHAT_DROP_COPY__SAFE_CODING_HELPER_SEED_RULE_V0_1_20260613.md',
    'CHAT_DROP_COPY__HELPER_THINKING_LOGIC_LADDER_RULE_V0_1_20260613.md',
    'CHAT_DROP_COPY__DEEP_SEARCH_EXTENDED_SEARCH_DISCIPLINE_CARD_V0_4_20260613.md',
    'CHAT_DROP_COPY__HOUSE_SEMANTIC_NERVOUS_SYSTEM_CURRENT_CUSTODY_ANCHOR_ADDENDUM_V0_2_20260607.md',
    'CHAT_DROP_COPY__TWO_LOCATION_CHAT_DROP_AND_HELPER_PREFLIGHT_RULE_ADDENDUM_20260607.md',
    'CHAT_DROP_COPY__MULE_STANDING_ISSUE_LEDGER_V0_1_20260607.md',
    'CHAT_DROP_COPY__ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_1_20260608.md',
    'CHAT_DROP_COPY__MULE_RAW_CUSTODY_HOUSE_ROUTING_SELF_APPLYING_GATE_ADDENDUM_V0_1_20260607.md'
)

$frontDoorTargets = @(
    'README.md',
    'CURRENT_TRUTH_INDEX.txt',
    'FRONT_DOOR_UPDATE_BOARD.md',
    'ACTIVE_ANCHOR.txt',
    'AGENTS.md',
    'PUBLIC_NOTES\CHAT_DROP_ANCHOR_NAMING_AND_FRESHNESS_RULE_V0_1_20260613.md',
    'PUBLIC_NOTES\CHAT_DROP_PULL_MEANS_LOCAL_FILES_RULE_V0_1_20260613.md',
    'PUBLIC_NOTES\HELPER_ERROR_EVIDENCE_LOGGING_RULE_V0_1_20260613.md',
    'PUBLIC_NOTES\HELPER_ERROR_CATALOG_RULE_V0_1_20260613.md',
    'PUBLIC_NOTES\HELPER_GAP_AND_CAUSE_LADDER_RULE_V0_1_20260613.md',
    'PUBLIC_NOTES\WEB_SEARCH_CRAWL_LADDER_RULE_V0_1_20260613.md',
    'PUBLIC_NOTES\SAFE_CODING_HELPER_SEED_RULE_V0_1_20260613.md',
    'PUBLIC_NOTES\HELPER_THINKING_LOGIC_LADDER_RULE_V0_1_20260613.md',
    'TOOLS\ChatDropFreshnessScanner.ps1',
    'TOOLS\Invoke-ChatDropLocalPull.ps1',
    'TOOLS\Invoke-HelperErrorCatalogBuild.ps1',
    'TOOLS\HelperGapCauseScanner.ps1',
    'TOOLS\Invoke-CleanWebCrawl.ps1',
    'TOOLS\New-SafeCodingHelperPacket.ps1',
    'TOOLS\Test-SafeCodingHelperPacket.ps1',
    'TOOLS\Invoke-HelperThinkingPatternBuild.ps1'
)

function Set-CleanPoint {
    param([Parameter(Mandatory = $true)][string]$Point)
    $script:LastCleanPoint = $Point
}

function Set-FailingPoint {
    param([Parameter(Mandatory = $true)][string]$Point)
    if ([string]::IsNullOrWhiteSpace($script:FirstFailingPoint)) {
        $script:FirstFailingPoint = $Point
    }
}

function Resolve-ExistingDirectory {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        throw "MISSING_${Label}: $Path"
    }

    return (Resolve-Path -LiteralPath $Path).Path
}

function Resolve-RepoRoot {
    param([string]$InputRoot)

    if ([string]::IsNullOrWhiteSpace($InputRoot)) {
        $InputRoot = Split-Path -Parent $PSScriptRoot
    }

    $resolved = Resolve-ExistingDirectory -Path $InputRoot -Label 'REPO_ROOT'
    foreach ($required in @('README.md', 'CURRENT_TRUTH_INDEX.txt', 'FRONT_DOOR_UPDATE_BOARD.md')) {
        $path = Join-Path $resolved $required
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "REPO_ROOT_FRONT_DOOR_MISSING: $path"
        }
    }

    return $resolved
}

function Get-Sha256 {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "HASH_SOURCE_MISSING: $Path"
    }

    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Copy-VerifiedFile {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        throw "COPY_SOURCE_MISSING: $Source"
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Force

    $sourceHash = Get-Sha256 -Path $Source
    $destHash = Get-Sha256 -Path $Destination
    if ($sourceHash -ne $destHash) {
        throw "COPY_HASH_MISMATCH: $Source -> $Destination"
    }

    return $destHash
}

function Get-ChatDropStatus {
    param([System.IO.FileSystemInfo]$Item)

    if ($Item.PSIsContainer) {
        if ($Item.Name -in @('_OLD_LOADS', '_SYNC_REPORTS', '_CLEANUP_REPORTS', 'RECEIPTS')) {
            return 'NOT_DEFAULT_LOAD'
        }
        return 'DIRECTORY_REVIEW_REQUIRED'
    }

    switch -Wildcard ($Item.Name) {
        '00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__*' { return 'CURRENT_ANCHOR_LOAD_FIRST' }
        '00_ANCHOR__UPDATE_REQUIRED__*' { return 'UPDATE_REQUIRED_ANCHOR' }
        'CHAT_DROP_COPY__HOUSE_SEMANTIC_NERVOUS_SYSTEM_CUSTODY_ANCHOR_ADDENDUM_20260607.md' { return 'SUPERSEDED_BY_V0_2_FOR_MIRROR_LAW' }
        'CHAT_DROP_COPY__LIVING_SYSTEM_*' { return 'SUPPORT_ONLY_UNLESS_TASK_NAMES_LIVING_SYSTEM' }
        'CHAT_DROP_COPY__SCISSOR_SEW_SMELL_BONE_NERVE_TOOL_GRAMMAR_CANDIDATE_V1.md' { return 'CANDIDATE_SUPPORT_ONLY' }
        default {
            if ($currentFiles -contains $Item.Name) { return 'CURRENT_HELPER_OR_SUPPORT' }
            if ($Item.Name -like 'CHAT_DROP_COPY__*.md') { return 'UNCLASSIFIED_CHAT_DROP_COPY_CHECK_ANCHOR' }
            return 'UNCLASSIFIED_TOP_LEVEL_ITEM'
        }
    }
}

function Add-Line {
    param(
        [System.Collections.Generic.List[string]]$Lines,
        [AllowNull()][string]$Text = ''
    )

    if ($null -eq $Lines) {
        throw 'ADD_LINE_TARGET_MISSING'
    }

    [void]$Lines.Add($Text)
}

function Add-EvidenceSignal {
    param(
        [Parameter(Mandatory = $true)][ValidateSet('INTENTIONAL_NEGATIVE_TEST', 'CLEARED_SUSPECT')][string]$Status,
        [Parameter(Mandatory = $true)][string]$SuspectedIssue,
        [Parameter(Mandatory = $true)][string]$Trigger,
        [Parameter(Mandatory = $true)][string]$EvidenceChecked,
        [Parameter(Mandatory = $true)][string]$ExpectedResult,
        [Parameter(Mandatory = $true)][string]$ActualResult,
        [Parameter(Mandatory = $true)][string]$WhyPassedFailedOrCleared,
        [Parameter(Mandatory = $true)][string]$WatchNote,
        [Parameter(Mandatory = $true)][string]$DoesNotProve
    )

    $script:NegativeTestRows.Add([PSCustomObject]@{
        Status = $Status
        SuspectedIssue = $SuspectedIssue
        Trigger = $Trigger
        EvidenceChecked = $EvidenceChecked
        ExpectedResult = $ExpectedResult
        ActualResult = $ActualResult
        WhyPassedFailedOrCleared = $WhyPassedFailedOrCleared
        WatchNote = $WatchNote
        DoesNotProve = $DoesNotProve
    })
}

function Write-EvidenceSignalReport {
    if (-not $script:ReportOut) {
        return
    }

    $path = Join-Path $script:ReportOut 'NEGATIVE_TESTS_AND_CLEARED_SUSPECTS.csv'
    if ($script:NegativeTestRows.Count -gt 0) {
        $script:NegativeTestRows | Export-Csv -LiteralPath $path -NoTypeInformation -Encoding UTF8
    }
}

function Get-MarkdownFence {
    param([AllowNull()][string]$Text)

    $max = 3
    foreach ($match in [regex]::Matches([string]$Text, '`+')) {
        if ($match.Value.Length -ge $max) {
            $max = $match.Value.Length + 1
        }
    }

    return ('`' * [Math]::Max(4, $max))
}

function Write-FailureReport {
    param([string]$Message)

    if (-not $script:ReportOut) {
        New-Item -ItemType Directory -Force -Path $script:EvidenceOutputRoot | Out-Null
        $fallbackRoot = Join-Path $script:EvidenceOutputRoot ('CHAT_DROP_LOCAL_PULL_FAILED_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
        $script:ReportOut = Join-Path $fallbackRoot 'REPORTS'
    }

    New-Item -ItemType Directory -Force -Path $script:ReportOut | Out-Null

    if ([string]::IsNullOrWhiteSpace($script:FirstFailingPoint)) {
        Set-FailingPoint -Point ('EXCEPTION_AFTER_' + $script:LastCleanPoint)
    }

    if (-not [string]::IsNullOrWhiteSpace($IntentionalNegativeTestName)) {
        $expected = if ([string]::IsNullOrWhiteSpace($ExpectedFailureContains)) {
            'Route should fail and save evidence.'
        } else {
            'Route should fail with text containing: ' + $ExpectedFailureContains
        }

        $actual = 'Route failed with: ' + $Message
        $matched = if ([string]::IsNullOrWhiteSpace($ExpectedFailureContains)) {
            $true
        } else {
            $Message -like ('*' + $ExpectedFailureContains + '*')
        }
        $why = if ($matched) {
            'Negative test behaved as expected and saved failure evidence.'
        } else {
            'Negative test failed, but not with the expected error text; review needed.'
        }

        Add-EvidenceSignal `
            -Status 'INTENTIONAL_NEGATIVE_TEST' `
            -SuspectedIssue $IntentionalNegativeTestName `
            -Trigger 'Intentional bad input supplied to helper runner.' `
            -EvidenceChecked ('LastCleanPoint=' + $script:LastCleanPoint + '; FirstFailingPoint=' + $script:FirstFailingPoint) `
            -ExpectedResult $expected `
            -ActualResult $actual `
            -WhyPassedFailedOrCleared $why `
            -WatchNote 'Use this row to teach future helpers what a clean blocked failure looks like.' `
            -DoesNotProve 'Does not prove every failure path works or that production output was clean.'
        Write-EvidenceSignalReport
    }

    $failurePath = Join-Path $script:ReportOut 'FAILED.txt'
    @(
        'CHAT_DROP_LOCAL_PULL_FAILED',
        '',
        "Time: $(Get-Date -Format o)",
        "Reason: $Message",
        "LastCleanPoint: $script:LastCleanPoint",
        "FirstFailingPoint: $script:FirstFailingPoint",
        '',
        'EvidenceStored:',
        $script:ReportOut,
        '',
        'DoesNotProve:',
        'No Chat Drop bundle is clean when this file exists.'
    ) | Set-Content -LiteralPath $failurePath -Encoding UTF8

    [PSCustomObject]@{
        Time = Get-Date -Format o
        Verdict = 'CHAT_DROP_LOCAL_PULL_FAILED'
        Reason = $Message
        LastCleanPoint = $script:LastCleanPoint
        FirstFailingPoint = $script:FirstFailingPoint
        ReportsFolder = $script:ReportOut
    } | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath (Join-Path $script:ReportOut 'ERROR_RECORD.json') -Encoding UTF8
}

try {
    Set-CleanPoint -Point 'ENTERED_TRY'
    $RepoRoot = Resolve-RepoRoot -InputRoot $RepoRoot
    Set-CleanPoint -Point 'REPO_ROOT_RESOLVED'
    $SourceChatDrop = Resolve-ExistingDirectory -Path $SourceChatDrop -Label 'SOURCE_CHAT_DROP'
    Set-CleanPoint -Point 'SOURCE_CHAT_DROP_RESOLVED'
    $PeerChatDrop = Resolve-ExistingDirectory -Path $PeerChatDrop -Label 'PEER_CHAT_DROP'
    Set-CleanPoint -Point 'PEER_CHAT_DROP_RESOLVED'

    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
    $script:PullRoot = Join-Path $OutputRoot "CHAT_DROP_LOCAL_PULL_CURRENT_$stamp"
    $filesOut = Join-Path $script:PullRoot 'FILES'
    $script:ReportOut = Join-Path $script:PullRoot 'REPORTS'
    New-Item -ItemType Directory -Force -Path $filesOut, $script:ReportOut | Out-Null
    Set-CleanPoint -Point 'EVIDENCE_FOLDERS_CREATED'

    Write-Host '=== CHAT DROP LOCAL PULL ==='
    Write-Host 'Plain pull means local files. This script does not clone, fetch, pull from GitHub, or use Git remotes.'
    Write-Host "Repo root:        $RepoRoot"
    Write-Host "Source Chat Drop: $SourceChatDrop"
    Write-Host "Peer Chat Drop:   $PeerChatDrop"
    Write-Host "Pull bundle:      $script:PullRoot"
    Write-Host ''

    $frontDoorRows = foreach ($rel in $frontDoorTargets) {
        $path = Join-Path $RepoRoot $rel
        $status = if (Test-Path -LiteralPath $path -PathType Leaf) { 'FOUND' } else { 'MISSING' }
        [PSCustomObject]@{
            Kind = 'FRONT_DOOR'
            Status = $status
            RelativePath = $rel
            FullPath = $path
            SHA256 = if ($status -eq 'FOUND') { Get-Sha256 -Path $path } else { '' }
        }
    }
    $frontDoorRows | Export-Csv -LiteralPath (Join-Path $script:ReportOut 'FRONT_DOOR_WALK.csv') -NoTypeInformation -Encoding UTF8
    Set-CleanPoint -Point 'FRONT_DOOR_WALK_RECORDED'

    $missingFrontDoor = @($frontDoorRows | Where-Object { $_.Status -ne 'FOUND' })
    if ($missingFrontDoor.Count -gt 0) {
        $missingFrontDoor | Select-Object RelativePath, FullPath | Format-Table -AutoSize | Out-String | Set-Content -LiteralPath (Join-Path $script:ReportOut 'FRONT_DOOR_MISSING.txt') -Encoding UTF8
        Set-FailingPoint -Point 'FRONT_DOOR_TARGET_CHECK'
        throw "FRONT_DOOR_TARGETS_MISSING: $($missingFrontDoor.Count). See $script:ReportOut\FRONT_DOOR_MISSING.txt"
    }
    Set-CleanPoint -Point 'FRONT_DOOR_TARGETS_VERIFIED'

    $surfaceRows = foreach ($root in @($SourceChatDrop, $PeerChatDrop)) {
        foreach ($item in Get-ChildItem -LiteralPath $root -Force) {
            [PSCustomObject]@{
                Root = $root
                Name = $item.Name
                Type = if ($item.PSIsContainer) { 'Directory' } else { 'File' }
                Status = Get-ChatDropStatus -Item $item
                FullPath = $item.FullName
            }
        }
    }
    $surfaceRows | Export-Csv -LiteralPath (Join-Path $script:ReportOut 'CHAT_DROP_LOAD_SURFACE.csv') -NoTypeInformation -Encoding UTF8
    foreach ($row in $surfaceRows) {
        if ($row.Status -in @('NOT_DEFAULT_LOAD', 'SUPERSEDED_BY_V0_2_FOR_MIRROR_LAW', 'SUPPORT_ONLY_UNLESS_TASK_NAMES_LIVING_SYSTEM', 'CANDIDATE_SUPPORT_ONLY')) {
            Add-EvidenceSignal `
                -Status 'CLEARED_SUSPECT' `
                -SuspectedIssue ('Apparent Chat Drop stale/support item: ' + $row.Name) `
                -Trigger ('Top-level load-surface scan under ' + $row.Root) `
                -EvidenceChecked ('Anchor classification status: ' + $row.Status) `
                -ExpectedResult 'Classify without loading by default or blocking the route.' `
                -ActualResult 'Classified as non-default-load, support-only, candidate, or superseded history.' `
                -WhyPassedFailedOrCleared 'The anchor and scanner classification made this a cleared suspect rather than a blocker.' `
                -WatchNote 'Do not delete or load by default; revisit only if the active task names this support lane.' `
                -DoesNotProve 'Does not prove the item is useless, current doctrine, or safe to delete.'
        }
    }
    Write-EvidenceSignalReport
    Set-CleanPoint -Point 'CHAT_DROP_LOAD_SURFACE_RECORDED'

    $blockers = New-Object System.Collections.Generic.List[string]
    $manifestRows = New-Object System.Collections.Generic.List[object]
    $order = 0

    foreach ($name in $currentFiles) {
        $sourcePath = Join-Path $SourceChatDrop $name
        $peerPath = Join-Path $PeerChatDrop $name

        if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
            Set-FailingPoint -Point 'SOURCE_CHAT_DROP_REQUIRED_FILE_CHECK'
            $blockers.Add("SOURCE_CHAT_DROP_MISSING: $sourcePath")
            continue
        }
        if (-not (Test-Path -LiteralPath $peerPath -PathType Leaf)) {
            Set-FailingPoint -Point 'PEER_CHAT_DROP_REQUIRED_FILE_CHECK'
            $blockers.Add("PEER_CHAT_DROP_MISSING: $peerPath")
            continue
        }

        $sourceHash = Get-Sha256 -Path $sourcePath
        $peerHash = Get-Sha256 -Path $peerPath
        if ($sourceHash -ne $peerHash) {
            Set-FailingPoint -Point 'CHAT_DROP_HASH_COMPARE'
            $blockers.Add("CHAT_DROP_HASH_MISMATCH: $name")
            continue
        }

        $order++
        $pulledPath = Join-Path $filesOut $name
        $pulledHash = Copy-VerifiedFile -Source $sourcePath -Destination $pulledPath

        $manifestRows.Add([PSCustomObject]@{
            LoadOrder = $order
            FileName = $name
            SourcePath = $sourcePath
            PeerPath = $peerPath
            PulledPath = $pulledPath
            SourceSHA256 = $sourceHash
            PeerSHA256 = $peerHash
            PulledSHA256 = $pulledHash
            PeerStatus = 'MATCHES_SOURCE_CHAT_DROP'
        })
    }

    if ($blockers.Count -gt 0) {
        $blockers | Set-Content -LiteralPath (Join-Path $script:ReportOut 'BLOCKERS.txt') -Encoding UTF8
        Set-FailingPoint -Point 'CHAT_DROP_REQUIRED_FILE_OR_HASH_BLOCKERS'
        throw "CHAT_DROP_LOCAL_PULL_BLOCKED: $($blockers.Count) blockers. See $script:ReportOut\BLOCKERS.txt"
    }
    Set-CleanPoint -Point 'CHAT_DROP_REQUIRED_FILES_HASH_VERIFIED'

    if ($manifestRows.Count -ne $currentFiles.Count) {
        Set-FailingPoint -Point 'MANIFEST_COUNT_CHECK'
        throw "MANIFEST_COUNT_MISMATCH: expected $($currentFiles.Count), got $($manifestRows.Count)"
    }

    $manifestCsv = Join-Path $script:PullRoot 'CHAT_DROP_LOCAL_PULL_MANIFEST.csv'
    $manifestRows | Export-Csv -LiteralPath $manifestCsv -NoTypeInformation -Encoding UTF8
    Write-EvidenceSignalReport
    Set-CleanPoint -Point 'MANIFEST_WRITTEN'

    $combinedPath = Join-Path $script:PullRoot 'CHAT_DROP_PULL_COMBINED_FOR_ASSISTANT.md'
    $combined = New-Object System.Collections.Generic.List[string]
    Add-Line $combined '# CHAT DROP PULL COMBINED FOR ASSISTANT'
    Add-Line $combined ''
    Add-Line $combined "Created: $(Get-Date -Format o)"
    Add-Line $combined "Source Chat Drop: $SourceChatDrop"
    Add-Line $combined "Peer Chat Drop verified: $PeerChatDrop"
    Add-Line $combined "Repo front door verified: $RepoRoot"
    Add-Line $combined ''
    Add-Line $combined '## Helper Use'
    Add-Line $combined ''
    Add-Line $combined '- `00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__V0_1_20260613.md` loaded first.'
    Add-Line $combined '- `CHAT_DROP_COPY__PULL_MEANS_LOCAL_FILES_RULE_V0_1_20260613.md` used for pull-language routing.'
    Add-Line $combined '- `CHAT_DROP_COPY__HELPER_ERROR_EVIDENCE_LOGGING_RULE_V0_1_20260613.md` used for evidence logging and false-pass blocking.'
    Add-Line $combined '- `CHAT_DROP_COPY__HELPER_ERROR_CATALOG_RULE_V0_1_20260613.md` used for reusable helper error families and clean fixes.'
    Add-Line $combined '- `CHAT_DROP_COPY__HELPER_GAP_AND_CAUSE_LADDER_RULE_V0_1_20260613.md` used for missing/stale helper detection and lower-cause routing.'
    Add-Line $combined '- `CHAT_DROP_COPY__WEB_SEARCH_CRAWL_LADDER_RULE_V0_1_20260613.md` used for bounded web crawl/search evidence collection.'
    Add-Line $combined '- `CHAT_DROP_COPY__SAFE_CODING_HELPER_SEED_RULE_V0_1_20260613.md` used for no-mutation coding helper packet setup.'
    Add-Line $combined '- `CHAT_DROP_COPY__HELPER_THINKING_LOGIC_LADDER_RULE_V0_1_20260613.md` used for bounded thinking-pattern capture without hidden chain-of-thought.'
    Add-Line $combined '- Intentional negative tests and cleared suspects are saved under `REPORTS\NEGATIVE_TESTS_AND_CLEARED_SUSPECTS.csv` when present.'
    Add-Line $combined '- `CHAT_DROP_COPY__MULE_STANDING_ISSUE_LEDGER_V0_1_20260607.md` used for two-copy law, load-surface check, and visible final return.'
    Add-Line $combined '- `TOOLS\Invoke-ChatDropLocalPull.ps1` built this bundle.'
    Add-Line $combined ''
    Add-Line $combined '## Load Order'
    Add-Line $combined ''
    foreach ($row in $manifestRows) {
        Add-Line $combined ('{0}. `{1}`' -f $row.LoadOrder, $row.FileName)
    }
    Add-Line $combined ''
    Add-Line $combined '## Files'
    Add-Line $combined ''

    foreach ($row in $manifestRows) {
        $content = Get-Content -LiteralPath $row.PulledPath -Raw
        $fence = Get-MarkdownFence -Text $content

        Add-Line $combined ''
        Add-Line $combined '---'
        Add-Line $combined ''
        $fileHeading = '## FILE {0}: {1}' -f $row.LoadOrder, $row.FileName
        Add-Line $combined $fileHeading
        Add-Line $combined ''
        Add-Line $combined ('SourceSHA256: `{0}`' -f $row.SourceSHA256)
        Add-Line $combined ('PeerStatus: `{0}`' -f $row.PeerStatus)
        Add-Line $combined ''
        Add-Line $combined ($fence + ' markdown')
        Add-Line $combined ($content.TrimEnd())
        Add-Line $combined $fence
    }

    Add-Line $combined ''
    Add-Line $combined '## Does Not Prove'
    Add-Line $combined ''
    Add-Line $combined 'This bundle does not authorize cleanup, deletion, rename, Git, GitHub, doctrine promotion, or source authority. It proves only the named local Chat Drop files were copied into this bundle after both required Chat Drop folders matched by hash.'

    $combined | Set-Content -LiteralPath $combinedPath -Encoding UTF8

    if (-not (Test-Path -LiteralPath $combinedPath -PathType Leaf)) {
        Set-FailingPoint -Point 'COMBINED_OUTPUT_EXISTS_CHECK'
        throw ('COMBINED_OUTPUT_MISSING: ' + $combinedPath)
    }

    $combinedText = Get-Content -LiteralPath $combinedPath -Raw
    if ($combinedText.Length -lt 1000 -or $combinedText -notmatch '## Files' -or $combinedText -notmatch '## FILE 1:') {
        Set-FailingPoint -Point 'COMBINED_OUTPUT_MARKER_CHECK'
        throw ('COMBINED_OUTPUT_FAILED_VALIDATION: ' + $combinedPath)
    }
    Set-CleanPoint -Point 'COMBINED_OUTPUT_VALIDATED'

    $readMePath = Join-Path $script:PullRoot 'OPEN_THIS_FIRST.txt'
    @(
        'CHAT DROP LOCAL PULL CURRENT',
        '',
        'Open/drop this file into ChatGPT:',
        $combinedPath,
        '',
        'Manifest:',
        $manifestCsv,
        '',
        'Individual pulled files:',
        $filesOut,
        '',
        'Reports:',
        $script:ReportOut,
        '',
        'Intentional negative tests / cleared suspects report when present:',
        (Join-Path $script:ReportOut 'NEGATIVE_TESTS_AND_CLEARED_SUSPECTS.csv'),
        '',
        'No delete, rename, cleanup, commit, push, clone, fetch, GitHub pull, source replay, fixture run, or doctrine promotion was performed.',
        'Plain pull means local files here.'
    ) | Set-Content -LiteralPath $readMePath -Encoding UTF8
    Set-CleanPoint -Point 'OPEN_THIS_FIRST_WRITTEN'

    Write-Host ''
    Write-Host '=== CHAT DROP LOCAL PULL COMPLETE ==='
    Write-Host ('Changed/created folder: ' + $script:PullRoot)
    Write-Host ('Drop into assistant:    ' + $combinedPath)
    Write-Host ('Manifest:              ' + $manifestCsv)
    Write-Host ('Reports:               ' + $script:ReportOut)
    Write-Host ''
    Write-Host 'VERDICT: CHAT_DROP_LOCAL_PULL_PASS'
}
catch {
    $message = $_.Exception.Message
    Write-FailureReport -Message $message
    Write-Host ''
    Write-Host 'VERDICT: CHAT_DROP_LOCAL_PULL_FAILED'
    Write-Host ('ERROR_TEXT: ' + $message)
    Write-Error $message
    exit 1
}
