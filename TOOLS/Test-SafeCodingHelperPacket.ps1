[CmdletBinding()]
param(
    [string]$PacketRoot,
    [string]$OutputRoot = 'C:\Users\13527\Desktop\123\_SAFE_CODING_HELPER_VALIDATIONS'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-LatestPacketRoot {
    $defaultRoot = 'C:\Users\13527\Desktop\123\_SAFE_CODING_HELPER_PACKETS'
    if (-not (Test-Path -LiteralPath $defaultRoot -PathType Container)) {
        throw "DEFAULT_PACKET_ROOT_MISSING: $defaultRoot"
    }
    $latest = Get-ChildItem -LiteralPath $defaultRoot -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($null -eq $latest) {
        throw "NO_SAFE_CODING_PACKETS_FOUND: $defaultRoot"
    }
    return $latest.FullName
}

function Add-Row {
    param(
        [System.Collections.Generic.List[object]]$Rows,
        [string]$Check,
        [string]$Status,
        [string]$Evidence,
        [string]$Fix
    )

    $Rows.Add([PSCustomObject]@{
        Check = $Check
        Status = $Status
        Evidence = $Evidence
        Fix = $Fix
        DoesNotProve = 'This validation does not authorize code edits, execution, installs, Git/GitHub work, cleanup, or promotion.'
    })
}

function Test-CsvNeedles {
    param(
        [System.Collections.Generic.List[object]]$Rows,
        [string]$Check,
        [string]$Path,
        [string[]]$Needles
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Row $Rows $Check 'HELPER_GAP_DETECTED' $Path 'Regenerate packet with this report.'
        return
    }

    $csvRows = @(Import-Csv -LiteralPath $Path)
    if ($csvRows.Count -eq 0) {
        Add-Row $Rows $Check 'HELPER_GAP_DETECTED' $Path 'Regenerate packet with non-empty report rows.'
        return
    }

    $joined = ($csvRows | ConvertTo-Json -Depth 6)
    $missing = @($Needles | Where-Object { $joined.IndexOf($_, [System.StringComparison]::OrdinalIgnoreCase) -lt 0 })
    if ($missing.Count -eq 0) {
        Add-Row $Rows $Check 'DRY_CLEAR' $Path 'No fix needed.'
    } else {
        Add-Row $Rows $Check 'HELPER_GAP_DETECTED' $Path ('Missing required signal(s): ' + ($missing -join ', '))
    }
}

if ([string]::IsNullOrWhiteSpace($PacketRoot)) {
    $PacketRoot = Get-LatestPacketRoot
}

if (-not (Test-Path -LiteralPath $PacketRoot -PathType Container)) {
    throw "PACKET_ROOT_MISSING: $PacketRoot"
}

$PacketRoot = (Resolve-Path -LiteralPath $PacketRoot).Path
New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
$runRoot = Join-Path $OutputRoot ('SAFE_CODING_PACKET_VALIDATION_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
$reportRoot = Join-Path $runRoot 'REPORTS'
New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

$rows = New-Object System.Collections.Generic.List[object]
$packet = Join-Path $PacketRoot 'SAFE_CODING_HELPER_PACKET.md'
$manifest = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_HELPER_PACKET_MANIFEST.csv'
$chain = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_HELPER_CHAIN.csv'
$microRoute = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_MICRO_ROUTE.csv'
$riskGates = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_RISK_GATES.csv'
$decisionTable = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_DECISION_TABLE.csv'
$testLadder = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_TEST_LADDER.csv'
$anchorMap = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_ANCHOR_MAP.csv'
$knowledgeLedger = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_KNOWLEDGE_LEDGER.csv'
$pickRules = Join-Path $PacketRoot 'REPORTS\SAFE_CODING_PICK_RULES.csv'

if (Test-Path -LiteralPath $packet -PathType Leaf) {
    $text = Get-Content -LiteralPath $packet -Raw
    Add-Row $rows 'packet file exists' 'DRY_CLEAR' $packet 'Keep packet as evidence.'
    foreach ($section in @('## One Job', '## Narrow Intelligence Order', '## Coding Anchor Map', '## Allowed Actions', '## Blocked Actions', '## Refusal And Ask Rules', '## Tiny Fixture Suggestion', '## Test Ladder', '## Proof Needed Before Mutation', '## Does Not Prove')) {
        if ($text.IndexOf($section, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            Add-Row $rows "section present: $section" 'DRY_CLEAR' $packet 'No fix needed.'
        } else {
            Add-Row $rows "section present: $section" 'HELPER_GAP_DETECTED' $packet 'Regenerate or repair packet with required section.'
        }
    }
} else {
    Add-Row $rows 'packet file exists' 'HELPER_GAP_DETECTED' $packet 'Regenerate packet.'
}

if (Test-Path -LiteralPath $manifest -PathType Leaf) {
    $manifestRows = @(Import-Csv -LiteralPath $manifest)
    $mutating = @($manifestRows | Where-Object { $_.MutationAuthorized -ne 'False' -and $_.MutationAuthorized -ne 'false' })
    if ($mutating.Count -eq 0) {
        Add-Row $rows 'manifest mutation closed' 'DRY_CLEAR' $manifest 'No fix needed.'
    } else {
        Add-Row $rows 'manifest mutation closed' 'HELPER_STALE_DETECTED' $manifest 'Regenerate packet with mutation closed.'
    }
} else {
    Add-Row $rows 'manifest exists' 'HELPER_GAP_DETECTED' $manifest 'Regenerate packet with manifest.'
}

if (Test-Path -LiteralPath $chain -PathType Leaf) {
    $chainRows = @(Import-Csv -LiteralPath $chain)
    $expected = @('read_context_helper', 'plan_patch_helper', 'fixture_helper', 'parse_lint_helper', 'apply_patch_helper', 'verify_helper', 'receipt_helper')
    $found = @($chainRows | ForEach-Object { $_.Stage })
    $missing = @($expected | Where-Object { $found -notcontains $_ })
    if ($missing.Count -eq 0) {
        Add-Row $rows 'chain stages complete' 'DRY_CLEAR' $chain 'No fix needed.'
    } else {
        Add-Row $rows 'chain stages complete' 'HELPER_GAP_DETECTED' $chain ('Add missing stages: ' + ($missing -join ', '))
    }
} else {
    Add-Row $rows 'chain ledger exists' 'HELPER_GAP_DETECTED' $chain 'Regenerate packet with chain ledger.'
}

Test-CsvNeedles $rows 'micro route report complete' $microRoute @('task_intake', 'surface_name', 'risk_classify', 'proof_before_action', 'return_or_refuse')
Test-CsvNeedles $rows 'risk gates report complete' $riskGates @('mutation_authority', 'target_surface', 'dirty_worktree', 'test_route', 'dependency_or_network')
Test-CsvNeedles $rows 'decision table report complete' $decisionTable @('PLAN_ONLY', 'ASK_USER', 'BLOCK', 'SPLIT_TASK', 'YIELD_DIRTY')
Test-CsvNeedles $rows 'test ladder report complete' $testLadder @('parse', 'lint_or_type', 'tiny_fixture', 'focused_existing_test', 'broader_regression')
Test-CsvNeedles $rows 'anchor map report complete' $anchorMap @('read_context_helper', 'plan_patch_helper', 'apply_patch_helper', 'verify_helper', 'receipt_helper')
Test-CsvNeedles $rows 'knowledge ledger report complete' $knowledgeLedger @('language_shape', 'risk_surface', 'project_pattern', 'test_signal', 'authority_state')
Test-CsvNeedles $rows 'pick rules report complete' $pickRules @('read_context_helper', 'ASK_USER', 'plan_patch_helper', 'SPLIT_TASK', 'green pass')

$rows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_PACKET_VALIDATION.csv') -NoTypeInformation -Encoding UTF8
$issues = @($rows | Where-Object { $_.Status -ne 'DRY_CLEAR' })
$issues | Export-Csv -LiteralPath (Join-Path $reportRoot 'OPEN_SAFE_CODING_PACKET_ISSUES.csv') -NoTypeInformation -Encoding UTF8

@(
    'SAFE CODING HELPER PACKET VALIDATION',
    '',
    "PacketRoot: $PacketRoot",
    "ReportRoot: $reportRoot",
    "OpenIssues: $($issues.Count)",
    '',
    'DoesNotProve:',
    'This validation does not authorize code edits, execution, installs, Git/GitHub work, cleanup, or promotion.'
) | Set-Content -LiteralPath (Join-Path $runRoot 'OPEN_THIS_FIRST.txt') -Encoding UTF8

Write-Output "SAFE_CODING_PACKET_VALIDATION_COMPLETE: $runRoot"
Write-Output "OPEN_ISSUES: $($issues.Count)"
Write-Output 'DOES_NOT_PROVE: Validation only; no code edits, execution, installs, Git/GitHub work, cleanup, or promotion authorized.'

if ($issues.Count -gt 0) {
    exit 1
}
