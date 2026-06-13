[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string]$ThinkingNotesPath = 'C:\Users\13527\Desktop\project_draft notes\thinkinnotes.txt',
    [string]$OutputRoot = 'C:\Users\13527\Desktop\123\_HELPER_THINKING_PATTERN_RUNS'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
$runRoot = Join-Path $OutputRoot ('HELPER_THINKING_PATTERN_RUN_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
$reportRoot = Join-Path $runRoot 'REPORTS'
New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

$notesFound = Test-Path -LiteralPath $ThinkingNotesPath -PathType Leaf
$sourceHash = ''
$sourceLength = 0
if ($notesFound) {
    $sourceHash = (Get-FileHash -LiteralPath $ThinkingNotesPath -Algorithm SHA256).Hash
    $sourceLength = (Get-Item -LiteralPath $ThinkingNotesPath).Length
    Copy-Item -LiteralPath $ThinkingNotesPath -Destination (Join-Path $runRoot 'SOURCE_thinkinnotes.txt') -Force
}

$layers = @(
    [PSCustomObject]@{ Layer = 'KNOWING'; Job = 'Retrieve facts, terms, paths, duties, and status.'; Blocked = 'Do not infer authority from memory.'; Proof = 'Name exact source or say missing.' },
    [PSCustomObject]@{ Layer = 'CHOOSING'; Job = 'Use a small rule or decision table.'; Blocked = 'Do not wander or invent a new lane.'; Proof = 'Decision row or rule named.' },
    [PSCustomObject]@{ Layer = 'PROVING'; Job = 'Return receipt, warnings, errors, and DoesNotProve.'; Blocked = 'Do not call run output PASS by itself.'; Proof = 'Proof object and failure condition named.' },
    [PSCustomObject]@{ Layer = 'COMPARING'; Job = 'Match today to prior cases.'; Blocked = 'Do not force weak analogy.'; Proof = 'Similar case and difference named.' },
    [PSCustomObject]@{ Layer = 'REFLECTING'; Job = 'Compare expected versus actual.'; Blocked = 'Do not hide mismatch.'; Proof = 'Mismatch or clean match recorded.' },
    [PSCustomObject]@{ Layer = 'LEARNING'; Job = 'Propose candidate update only.'; Blocked = 'Do not install itself.'; Proof = 'Candidate, scope, test, and promotion gate named.' }
)

$school = @(
    [PSCustomObject]@{ Grade = 'Kindergarten'; Capability = 'Name and home'; PassCondition = 'Helper knows what it is and where it lives.' },
    [PSCustomObject]@{ Grade = 'Grade 1'; Capability = 'Duty/input/output'; PassCondition = 'Helper has one job and IO contract.' },
    [PSCustomObject]@{ Grade = 'Grade 2'; Capability = 'Proof return'; PassCondition = 'Helper returns proof, warnings, errors, next safe action.' },
    [PSCustomObject]@{ Grade = 'Grade 3'; Capability = 'If/then refusal'; PassCondition = 'Helper blocks false pass and missing proof.' },
    [PSCustomObject]@{ Grade = 'Grade 4'; Capability = 'Decision table'; PassCondition = 'Helper chooses inside a small table.' },
    [PSCustomObject]@{ Grade = 'Grade 5'; Capability = 'Case comparison'; PassCondition = 'Helper compares to prior cases with differences.' },
    [PSCustomObject]@{ Grade = 'Grade 6'; Capability = 'Pattern recognition'; PassCondition = 'Helper names known failure family and proof needed.' },
    [PSCustomObject]@{ Grade = 'Grade 7'; Capability = 'Reflection'; PassCondition = 'Helper compares expected versus actual.' },
    [PSCustomObject]@{ Grade = 'Grade 8'; Capability = 'Candidate maker'; PassCondition = 'Helper proposes but does not install.' },
    [PSCustomObject]@{ Grade = 'Grade 9'; Capability = 'Supervised reasoning'; PassCondition = 'Helper combines proof, cases, rules, and toolbelts under review.' }
)

$stringRows = @(
    'DROP','NAME','SPECIES','HOME','VOCABULARY','CONTEXT','DUTY','INPUT','OUTPUT','PROOF','RULE','DECISION','CASE','PATTERN','TUNNEL','TEST','RETURN','REFLECT','PROMOTE/PARK/BLOCK'
) | ForEach-Object -Begin { $i = 0 } -Process {
    $i++
    [PSCustomObject]@{
        Order = $i
        Step = $_
        Rule = 'Add only this layer when it is needed and provable.'
    }
}

$sourceRow = [PSCustomObject]@{
    ThinkingNotesPath = $ThinkingNotesPath
    Found = $notesFound
    SHA256 = $sourceHash
    Length = $sourceLength
    DoesNotProve = 'Source notes do not become authority by being copied or summarized.'
}

$sourceRow | Export-Csv -LiteralPath (Join-Path $reportRoot 'THINKING_SOURCE_PROOF.csv') -NoTypeInformation -Encoding UTF8
$layers | Export-Csv -LiteralPath (Join-Path $reportRoot 'THINKING_SAFE_LAYERS.csv') -NoTypeInformation -Encoding UTF8
$school | Export-Csv -LiteralPath (Join-Path $reportRoot 'HELPER_SCHOOL_LADDER.csv') -NoTypeInformation -Encoding UTF8
$stringRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'HELPER_LONG_STRING.csv') -NoTypeInformation -Encoding UTF8

@(
    '# Helper Thinking Pattern Packet',
    '',
    "Created: $(Get-Date -Format o)",
    "RepoRoot: $RepoRoot",
    "ThinkingNotesPath: $ThinkingNotesPath",
    "Found: $notesFound",
    "SHA256: $sourceHash",
    '',
    '## Safe Split',
    '',
    'KNOWING -> CHOOSING -> PROVING -> COMPARING -> REFLECTING -> LEARNING',
    '',
    '## Immediate Target',
    '',
    'Bring useful helpers to Grade 2 and Grade 3 before higher reasoning layers.',
    '',
    '## Long String',
    '',
    'DROP -> NAME -> SPECIES -> HOME -> VOCABULARY -> CONTEXT -> DUTY -> INPUT -> OUTPUT -> PROOF -> RULE -> DECISION -> CASE -> PATTERN -> TUNNEL -> TEST -> RETURN -> REFLECT -> PROMOTE/PARK/BLOCK',
    '',
    '## Reports',
    '',
    (Join-Path $reportRoot 'THINKING_SOURCE_PROOF.csv'),
    (Join-Path $reportRoot 'THINKING_SAFE_LAYERS.csv'),
    (Join-Path $reportRoot 'HELPER_SCHOOL_LADDER.csv'),
    (Join-Path $reportRoot 'HELPER_LONG_STRING.csv'),
    '',
    '## Does Not Prove',
    '',
    'This packet does not prove helpers are intelligent, safe to edit, autonomous, or ready for doctrine promotion.'
) | Set-Content -LiteralPath (Join-Path $runRoot 'HELPER_THINKING_PATTERN_PACKET.md') -Encoding UTF8

@(
    'HELPER THINKING PATTERN RUN',
    '',
    "Packet: $(Join-Path $runRoot 'HELPER_THINKING_PATTERN_PACKET.md')",
    "Reports: $reportRoot",
    '',
    'DoesNotProve:',
    'Visible thinking-pattern scaffolding only; no hidden chain-of-thought, mutation, Git, cleanup, or doctrine authority.'
) | Set-Content -LiteralPath (Join-Path $runRoot 'OPEN_THIS_FIRST.txt') -Encoding UTF8

Write-Output "HELPER_THINKING_PATTERN_BUILT: $runRoot"
Write-Output "SOURCE_FOUND: $notesFound"
Write-Output 'DOES_NOT_PROVE: This packet is bounded scaffolding, not intelligence or authority.'
