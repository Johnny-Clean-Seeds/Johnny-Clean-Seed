[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string[]]$ChatDropRoots = @(
        'C:\Users\13527\Desktop\123\Chat Drop',
        'C:\Users\13527\Desktop\Chat Drop'
    ),
    [string]$OutputRoot = 'C:\Users\13527\Desktop\123\_HELPER_DRY_RUNS'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}

if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
    throw "REPO_ROOT_MISSING: $RepoRoot"
}

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$runRoot = Join-Path $OutputRoot "HELPER_DRY_RUN_SUITE_$stamp"
$reportRoot = Join-Path $runRoot 'REPORTS'
$logRoot = Join-Path $runRoot 'LOGS'
New-Item -ItemType Directory -Force -Path $reportRoot, $logRoot | Out-Null

$findings = New-Object System.Collections.Generic.List[object]

function Add-Finding {
    param(
        [string]$Helper,
        [string]$DryTask,
        [string]$Status,
        [string]$Evidence,
        [string]$LowestCause,
        [string]$Recommendation,
        [string]$DoesNotProve
    )

    $findings.Add([PSCustomObject]@{
        Helper = $Helper
        DryTask = $DryTask
        Status = $Status
        Evidence = $Evidence
        LowestCause = $LowestCause
        Recommendation = $Recommendation
        DoesNotProve = $DoesNotProve
    })
}

function Test-FileContains {
    param(
        [string]$Path,
        [string]$Needle
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $false
    }

    $text = Get-Content -LiteralPath $Path -Raw
    return ($text.IndexOf($Needle, [System.StringComparison]::OrdinalIgnoreCase) -ge 0)
}

function Test-Card {
    param(
        [string]$Helper,
        [string]$DryTask,
        [string]$PublicPath,
        [string]$ChatDropName,
        [string[]]$RequiredText
    )

    $fullPublicPath = Join-Path $RepoRoot $PublicPath
    if (Test-Path -LiteralPath $fullPublicPath -PathType Leaf) {
        Add-Finding $Helper $DryTask 'DRY_CLEAR' $fullPublicPath 'helper presence and helper state' 'Keep current public pointer.' 'Does not prove the card is doctrine or complete for all tasks.'
    } else {
        Add-Finding $Helper $DryTask 'HELPER_GAP_DETECTED' $fullPublicPath 'helper presence and helper state' 'Create or restore the missing public helper card if current authority still wants it.' 'Does not prove Chat Drop mirrors are missing.'
    }

    foreach ($needle in $RequiredText) {
        if (Test-FileContains -Path $fullPublicPath -Needle $needle) {
            Add-Finding $Helper "required text: $needle" 'DRY_CLEAR' $fullPublicPath 'helper contract shape' 'Required boundary text is visible.' 'Does not prove the helper is sufficient for live mutation.'
        } else {
            Add-Finding $Helper "required text: $needle" 'HELPER_GAP_DETECTED' $fullPublicPath 'helper contract shape' 'Add the missing boundary/contract text before relying on this helper.' 'Does not prove the helper should be promoted.'
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($ChatDropName)) {
        foreach ($root in $ChatDropRoots) {
            $chatPath = Join-Path $root $ChatDropName
            if (Test-Path -LiteralPath $chatPath -PathType Leaf) {
                Add-Finding $Helper 'Chat Drop mirror check' 'DRY_CLEAR' $chatPath 'public, board, and Chat Drop sync' 'Mirror is present in required Chat Drop folder.' 'Does not prove the mirror is newest unless anchor/hash checks also pass.'
            } else {
                Add-Finding $Helper 'Chat Drop mirror check' 'HELPER_STALE_DETECTED' $chatPath 'public, board, and Chat Drop sync' 'Update both required Chat Drop folders or remove the helper from the active load list.' 'Does not prove the public card is wrong.'
            }
        }
    }
}

function Test-ScriptParse {
    param(
        [string]$Helper,
        [string]$RelativePath
    )

    $path = Join-Path $RepoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Add-Finding $Helper 'PowerShell parse' 'HELPER_GAP_DETECTED' $path 'helper presence and helper state' 'Restore missing script before using this helper.' 'Does not prove the helper card is missing.'
        return
    }

    try {
        $tokens = $null
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors) | Out-Null
        if ($errors.Count -gt 0) {
            Add-Finding $Helper 'PowerShell parse' 'HELPER_STALE_DETECTED' (($errors | ForEach-Object { $_.Message }) -join '; ') 'command, tool, and environment shape' 'Repair parser errors before live use.' 'Does not prove the route logic is wrong.'
        } else {
            Add-Finding $Helper 'PowerShell parse' 'DRY_CLEAR' $path 'command, tool, and environment shape' 'Script parses cleanly.' 'Does not prove runtime behavior.'
        }
    } catch {
        Add-Finding $Helper 'PowerShell parse' 'SCRIPT_ERROR' $_.Exception.Message 'command, tool, and environment shape' 'Repair parser invocation or script environment.' 'Does not prove the script contents are invalid.'
    }
}

function Invoke-HelperCommand {
    param(
        [string]$Helper,
        [string]$DryTask,
        [scriptblock]$Command,
        [string]$ExpectedText,
        [bool]$ExpectFailure = $false
    )

    $logName = ($Helper -replace '[^A-Za-z0-9_-]', '_') + '_' + ($DryTask -replace '[^A-Za-z0-9_-]', '_') + '.log'
    $logPath = Join-Path $logRoot $logName
    $output = ''
    $exitCode = 0
    $oldErrorActionPreference = $ErrorActionPreference

    try {
        $ErrorActionPreference = 'Continue'
        $global:LASTEXITCODE = 0
        $output = (& $Command *>&1 | Out-String -Width 260)
        $exitCode = if ($null -eq $global:LASTEXITCODE) { 0 } else { $global:LASTEXITCODE }
    } catch {
        $output = (($output, $_.Exception.Message) -join [Environment]::NewLine).Trim()
        $exitCode = 1
    } finally {
        $ErrorActionPreference = $oldErrorActionPreference
    }

    $output | Set-Content -LiteralPath $logPath -Encoding UTF8
    $hasExpected = if ([string]::IsNullOrWhiteSpace($ExpectedText)) { $true } else { $output -like ('*' + $ExpectedText + '*') }

    if ($ExpectFailure) {
        if ($exitCode -ne 0 -and $hasExpected) {
            Add-Finding $Helper $DryTask 'INTENTIONAL_NEGATIVE_TEST' $logPath 'proof, receipt, and DoesNotProve' 'Expected failure was logged with expected signal.' 'Does not prove other failure paths are covered.'
        } else {
            Add-Finding $Helper $DryTask 'HELPER_STALE_DETECTED' $logPath 'proof, receipt, and DoesNotProve' 'Expected negative test did not fail cleanly; inspect log and repair.' 'Does not prove production path is bad.'
        }
        return
    }

    if ($exitCode -eq 0 -and $hasExpected) {
        Add-Finding $Helper $DryTask 'DRY_CLEAR' $logPath 'proof, receipt, and DoesNotProve' 'Dry task produced the expected scoped signal.' 'Does not prove all helper tasks are covered.'
    } else {
        Add-Finding $Helper $DryTask 'HELPER_STALE_DETECTED' $logPath 'proof, receipt, and DoesNotProve' 'Dry task missed its expected signal or exited dirty; inspect log and repair.' 'Does not prove the helper idea is wrong.'
    }
}

$cards = @(
    @{
        Helper = 'Clear Lens Entry Suit'
        PublicPath = 'PUBLIC_NOTES\CLEAR_LENS_ENTRY_SUIT_AND_OUTSIDE_AGENT_IDENTITY_CARD_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__CLEAR_LENS_ENTRY_SUIT_AND_OUTSIDE_AGENT_IDENTITY_CARD_V0_1_20260613.md'
        DryTask = 'Declare outside/local identity and helper-use signal.'
        RequiredText = @('Required Identity Plate', 'Helper-Use Signal', 'Does Not Prove')
    },
    @{
        Helper = 'Collaborative Steering Stack'
        PublicPath = 'PUBLIC_NOTES\COLLABORATIVE_STEERING_STACK_AND_GATE_DISCIPLINE_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__COLLABORATIVE_STEERING_STACK_AND_GATE_DISCIPLINE_V0_1_20260613.md'
        DryTask = 'Sort steering into hard stop, additive steer, correction, or new drop.'
        RequiredText = @('Agreement Posture', 'Steering Stack', 'Does Not Prove')
    },
    @{
        Helper = 'Pull Means Local Files'
        PublicPath = 'PUBLIC_NOTES\CHAT_DROP_PULL_MEANS_LOCAL_FILES_RULE_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__PULL_MEANS_LOCAL_FILES_RULE_V0_1_20260613.md'
        DryTask = 'Interpret plain pull as local files unless Git is explicit.'
        RequiredText = @('Plain `pull`', 'GitHub', 'Does Not Prove')
    },
    @{
        Helper = 'Helper Error Evidence Logging'
        PublicPath = 'PUBLIC_NOTES\HELPER_ERROR_EVIDENCE_LOGGING_RULE_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__HELPER_ERROR_EVIDENCE_LOGGING_RULE_V0_1_20260613.md'
        DryTask = 'Log errors, intentional negative tests, and cleared suspects.'
        RequiredText = @('Negative Test And Cleared Suspect Rule', 'INTENTIONAL_NEGATIVE_TEST', 'Does Not Prove')
    },
    @{
        Helper = 'Helper Error Catalog'
        PublicPath = 'PUBLIC_NOTES\HELPER_ERROR_CATALOG_RULE_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__HELPER_ERROR_CATALOG_RULE_V0_1_20260613.md'
        DryTask = 'Build reusable bounded helper error families and clean fixes.'
        RequiredText = @('Intentional Negative Tests', 'Invoke-HelperErrorCatalogBuild.ps1', 'Does Not Prove')
    },
    @{
        Helper = 'Helper Gap And Cause Ladder'
        PublicPath = 'PUBLIC_NOTES\HELPER_GAP_AND_CAUSE_LADDER_RULE_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__HELPER_GAP_AND_CAUSE_LADDER_RULE_V0_1_20260613.md'
        DryTask = 'Detect missing/stale helpers and name lowest cause.'
        RequiredText = @('Lower-Cause Ladder', 'HELPER_GAP_DETECTED', 'Does Not Prove')
    },
    @{
        Helper = 'Web Search Crawl Ladder'
        PublicPath = 'PUBLIC_NOTES\WEB_SEARCH_CRAWL_LADDER_RULE_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__WEB_SEARCH_CRAWL_LADDER_RULE_V0_1_20260613.md'
        DryTask = 'Run bounded same-host seed crawl and log evidence.'
        RequiredText = @('Crawl Levels', 'Robots And Rate Guard', 'Invoke-CleanWebCrawl.ps1', 'Does Not Prove')
    },
    @{
        Helper = 'Safe Coding Helper Seed'
        PublicPath = 'PUBLIC_NOTES\SAFE_CODING_HELPER_SEED_RULE_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__SAFE_CODING_HELPER_SEED_RULE_V0_1_20260613.md'
        DryTask = 'Create a no-mutation coding helper packet outside the tracked repo.'
        RequiredText = @('one narrow job', 'Coding Anchor Map', 'SAFE_CODING_KNOWLEDGE_LEDGER.csv', 'New-SafeCodingHelperPacket.ps1', 'Does Not Prove')
    },
    @{
        Helper = 'Helper Thinking Logic Ladder'
        PublicPath = 'PUBLIC_NOTES\HELPER_THINKING_LOGIC_LADDER_RULE_V0_1_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__HELPER_THINKING_LOGIC_LADDER_RULE_V0_1_20260613.md'
        DryTask = 'Build bounded thinking-pattern reports from user note files.'
        RequiredText = @('Safe Thinking Split', 'Invoke-HelperThinkingPatternBuild.ps1', 'Does Not Prove')
    },
    @{
        Helper = 'Deep Search Extended Discipline'
        PublicPath = 'PUBLIC_NOTES\CHAT_DROP_COPY__DEEP_SEARCH_EXTENDED_SEARCH_DISCIPLINE_CARD_V0_4_20260613.md'
        ChatDropName = 'CHAT_DROP_COPY__DEEP_SEARCH_EXTENDED_SEARCH_DISCIPLINE_CARD_V0_4_20260613.md'
        DryTask = 'Restrict deep search behavior to search/research tasks.'
        RequiredText = @('Status:', 'search', 'DoesNotProve')
    }
)

foreach ($card in $cards) {
    Test-Card -Helper $card.Helper -DryTask $card.DryTask -PublicPath $card.PublicPath -ChatDropName $card.ChatDropName -RequiredText $card.RequiredText
}

Test-ScriptParse 'Chat Drop Freshness Scanner' 'TOOLS\ChatDropFreshnessScanner.ps1'
Test-ScriptParse 'Chat Drop Local Pull Runner' 'TOOLS\Invoke-ChatDropLocalPull.ps1'
Test-ScriptParse 'Helper Error Catalog Builder' 'TOOLS\Invoke-HelperErrorCatalogBuild.ps1'
Test-ScriptParse 'Helper Gap Cause Scanner' 'TOOLS\HelperGapCauseScanner.ps1'
Test-ScriptParse 'Helper Dry Run Suite' 'TOOLS\Invoke-HelperDryRunSuite.ps1'
Test-ScriptParse 'Clean Web Crawl Runner' 'TOOLS\Invoke-CleanWebCrawl.ps1'
Test-ScriptParse 'Safe Coding Helper Packet Maker' 'TOOLS\New-SafeCodingHelperPacket.ps1'
Test-ScriptParse 'Safe Coding Helper Packet Validator' 'TOOLS\Test-SafeCodingHelperPacket.ps1'
Test-ScriptParse 'Helper Thinking Pattern Builder' 'TOOLS\Invoke-HelperThinkingPatternBuild.ps1'

Invoke-HelperCommand 'Chat Drop Freshness Scanner' 'read-only freshness scan' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\ChatDropFreshnessScanner.ps1')
} 'PULL_LANGUAGE_RULE' $false

Invoke-HelperCommand 'Helper Gap Cause Scanner' 'read-only helper gap scan' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\HelperGapCauseScanner.ps1') -RequireClean
} 'HELPER_CAUSE_LADDER_CLEAR' $false

Invoke-HelperCommand 'Helper Error Catalog Builder' 'build bounded error catalog' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-HelperErrorCatalogBuild.ps1') -RepoRoot $RepoRoot -OutputRoot (Join-Path $runRoot 'HELPER_ERROR_CATALOGS')
} 'HELPER_ERROR_CATALOG_BUILT' $false

$pullRunRoot = Join-Path $runRoot 'CHAT_DROP_LOCAL_PULL_RUNS'
Invoke-HelperCommand 'Chat Drop Local Pull Runner' 'clean local bundle run' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-ChatDropLocalPull.ps1') -OutputRoot $pullRunRoot
} 'CHAT_DROP_LOCAL_PULL_PASS' $false

Invoke-HelperCommand 'Chat Drop Local Pull Runner' 'intentional missing peer negative test' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-ChatDropLocalPull.ps1') -OutputRoot $pullRunRoot -PeerChatDrop 'C:\Users\13527\Desktop\123\NO_SUCH_CHAT_DROP_TEST' -IntentionalNegativeTestName 'missing peer Chat Drop blocks route' -ExpectedFailureContains 'MISSING_PEER_CHAT_DROP'
} 'MISSING_PEER_CHAT_DROP' $true

$webRunRoot = Join-Path $runRoot 'WEB_CRAWL_RUNS'
Invoke-HelperCommand 'Clean Web Crawl Runner' 'bounded public repo crawl' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-CleanWebCrawl.ps1') -OutputRoot $webRunRoot -SeedUrls 'https://github.com/Johnny-Clean-Seeds/Johnny-Clean-Seed' -MaxPages 6 -MaxDepth 1
} 'WEB_CRAWL_ROBOTS.csv' $false

Invoke-HelperCommand 'Clean Web Crawl Runner' 'intentional invalid seed negative test' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-CleanWebCrawl.ps1') -OutputRoot $webRunRoot -SeedUrls 'not-a-url' -IntentionalNegativeTestName 'invalid seed URL blocks crawl route' -ExpectedFailureContains 'INVALID_SEED_URL'
} 'INVALID_SEED_URL' $true

$codingRunRoot = Join-Path $runRoot 'SAFE_CODING_HELPER_PACKETS'
Invoke-HelperCommand 'Safe Coding Helper Packet Maker' 'create no-mutation packet' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\New-SafeCodingHelperPacket.ps1') -OutputRoot $codingRunRoot -TaskName 'tiny parse check helper' -Language 'PowerShell' -TargetSurface 'TOOLS'
} 'SAFE_CODING_HELPER_PACKET_CREATED' $false

Invoke-HelperCommand 'Safe Coding Helper Packet Validator' 'validate latest suite packet' {
    $latest = Get-ChildItem -LiteralPath $codingRunRoot -Directory | Where-Object { $_.Name -like 'SAFE_CODING_HELPER_PACKET_*' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($null -eq $latest) {
        throw 'NO_SUITE_SAFE_CODING_PACKET_FOUND'
    }
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Test-SafeCodingHelperPacket.ps1') -PacketRoot $latest.FullName -OutputRoot (Join-Path $runRoot 'SAFE_CODING_HELPER_VALIDATIONS')
} 'OPEN_ISSUES: 0' $false

Invoke-HelperCommand 'Safe Coding Helper Packet Maker' 'intentional mutation blocked negative test' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\New-SafeCodingHelperPacket.ps1') -OutputRoot $codingRunRoot -TaskName 'bad mutation request' -Language 'PowerShell' -TargetSurface 'TOOLS' -AllowProjectMutation -IntentionalNegativeTestName 'project mutation flag blocks safe coding seed' -ExpectedFailureContains 'PROJECT_MUTATION_BLOCKED_BY_SAFE_CODING_SEED'
} 'PROJECT_MUTATION_BLOCKED_BY_SAFE_CODING_SEED' $true

$thinkingRunRoot = Join-Path $runRoot 'HELPER_THINKING_PATTERNS'
Invoke-HelperCommand 'Helper Thinking Pattern Builder' 'build bounded thinking reports' {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'TOOLS\Invoke-HelperThinkingPatternBuild.ps1') -RepoRoot $RepoRoot -OutputRoot $thinkingRunRoot
} 'HELPER_THINKING_PATTERN_BUILT' $false

$findingsCsv = Join-Path $reportRoot 'HELPER_DRY_RUN_FINDINGS.csv'
$findings | Export-Csv -LiteralPath $findingsCsv -NoTypeInformation -Encoding UTF8

$openIssues = @($findings | Where-Object { $_.Status -notin @('DRY_CLEAR', 'INTENTIONAL_NEGATIVE_TEST') })
$summaryPath = Join-Path $runRoot 'OPEN_THIS_FIRST.txt'
@(
    'HELPER DRY RUN SUITE',
    '',
    "Created: $(Get-Date -Format o)",
    "RepoRoot: $RepoRoot",
    "RunRoot: $runRoot",
    '',
    "FindingsCsv: $findingsCsv",
    "Logs: $logRoot",
    '',
    "OpenIssueCount: $($openIssues.Count)",
    '',
    'Signals:',
    '- DRY_CLEAR means the scoped dry task had visible evidence.',
    '- INTENTIONAL_NEGATIVE_TEST means a deliberate bad input failed as expected and was logged.',
    '- HELPER_GAP_DETECTED / HELPER_STALE_DETECTED means inspect and repair before relying on that lane.',
    '',
    'DoesNotProve:',
    'This suite does not prove every helper in history, does not authorize cleanup, and does not promote helper cards to doctrine.'
) | Set-Content -LiteralPath $summaryPath -Encoding UTF8

$openIssues | Export-Csv -LiteralPath (Join-Path $reportRoot 'OPEN_HELPER_ISSUES.csv') -NoTypeInformation -Encoding UTF8

Write-Output "HELPER_DRY_RUN_SUITE_COMPLETE: $runRoot"
Write-Output "OPEN_ISSUES: $($openIssues.Count)"
Write-Output "FINDINGS: $findingsCsv"
Write-Output 'DOES_NOT_PROVE: This suite covers the current/live helper surface only, not every historical support file by volume.'

if ($openIssues.Count -gt 0) {
    exit 1
}
