$ErrorActionPreference = "Stop"

function Run-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(& git @Args 2>&1)
    if ($LASTEXITCODE -ne 0) {
        $Output | ForEach-Object { Write-Host $_ }
        throw ("Git failed: git " + ($Args -join ' '))
    }
    return $Output
}

function Git-Line {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(Run-Git @Args)
    if ($Output.Count -lt 1) {
        throw ("Git returned no output: git " + ($Args -join ' '))
    }
    return ([string]($Output | Select-Object -First 1)).Trim()
}

function Assert-CleanTextFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw ("Missing required file: " + $Path)
    }

    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8

    if ([string]::IsNullOrWhiteSpace($Raw)) {
        throw ("File is empty: " + $Path)
    }

    if ($Raw.Contains([char]0)) {
        throw ("NUL byte found: " + $Path)
    }

    if ($Raw.Contains([char]0xFFFD)) {
        throw ("Replacement character found: " + $Path)
    }

    foreach ($Bad in @('[PLACEHOLDER]', 'TODO: fill', 'lorem ipsum')) {
        if ($Raw.Contains($Bad)) {
            throw ("Bad placeholder marker found in file: " + $Path)
        }
    }
}

function Write-NewCleanFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )

    if (Test-Path -LiteralPath $Path) {
        throw ("Target already exists. Stop before overwrite: " + $Path)
    }

    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    Assert-CleanTextFile -Path $Path
}

function Append-Once {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Marker,
        [Parameter(Mandatory = $true)][string[]]$Lines
    )

    Assert-CleanTextFile -Path $Path
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8

    if ($Raw -match [regex]::Escape($Marker)) {
        throw ("Append marker already exists. Stop to avoid duplicate: " + $Path + " / " + $Marker)
    }

    $TextToAppend = $Lines -join [Environment]::NewLine
    $NewText = $Raw.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $TextToAppend
    Set-Content -LiteralPath $Path -Value $NewText -Encoding UTF8
    Assert-CleanTextFile -Path $Path
}

function Require-Text {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle
    )

    Assert-CleanTextFile -Path $Path
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8

    if (-not $Raw.Contains($Needle)) {
        throw ("Required text missing from " + $Path + " : " + $Needle)
    }
}

function Join-Lines {
    param([Parameter(Mandatory = $true)][string[]]$Lines)
    return ($Lines -join [Environment]::NewLine)
}

function Get-HashTableText {
    param([Parameter(Mandatory = $true)][string[]]$Paths)

    $Out = New-Object System.Collections.Generic.List[string]

    foreach ($Path in $Paths) {
        Assert-CleanTextFile -Path $Path
        $Item = Get-Item -LiteralPath $Path
        $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        $Out.Add(("- " + $Path + " | bytes=" + $Item.Length + " | sha256=" + $Hash)) | Out-Null
    }

    return ($Out -join [Environment]::NewLine)
}

function Get-FirstMatch {
    param(
        [string]$Text,
        [string[]]$Patterns,
        [string]$Default = ''
    )

    foreach ($Pattern in $Patterns) {
        $Match = [regex]::Match($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($Match.Success) {
            if ($Match.Groups.Count -gt 1) {
                return (($Match.Groups[1].Value -replace '\s+', ' ').Trim())
            }
            return (($Match.Value -replace '\s+', ' ').Trim())
        }
    }

    return $Default
}

function Get-Kind {
    param([string]$Path, [string]$Text)

    $UpperPath = $Path.ToUpperInvariant()
    $UpperText = $Text.ToUpperInvariant()

    if ($UpperPath -match 'SOFT_SUITS') { return 'Soft Suit' }
    if ($UpperPath -match 'GEAR_RACK|CODE_CABINET') { return 'Tool / Gear' }
    if ($UpperPath -match 'BRAIN_LEARNING') { return 'Rule / Learning' }
    if ($UpperPath -match 'IDEA_BAG') { return 'Idea / Candidate' }
    if ($UpperPath -match 'TODO') { return 'TODO / Live-use Watch' }
    if ($UpperPath -match 'SOURCE_ORE') { return 'Source Ore' }
    if ($UpperText -match 'SOFT SUIT') { return 'Soft Suit' }
    if ($UpperText -match 'TOOL|GEAR|CODE CABINET|SKELETON') { return 'Tool / Gear' }
    if ($UpperText -match 'RULE|GATE|LATCH|GUARD') { return 'Rule / Learning' }

    return 'Concept / Support'
}

function Get-ProofTier {
    param([string]$Text)

    $Upper = $Text.ToUpperInvariant()

    if ($Upper -match 'PASS WITH GUARDRAILS|PASS AS|PASS:|VERDICT: PASS') { return 'Proven / PASS with guardrails' }
    if ($Upper -match 'ADOPTED|LOCKED|SAVED CLEAN|HEAD EQUALS ORIGIN/MAIN|HEAD == ORIGIN/MAIN') { return 'Saved / Locked' }
    if ($Upper -match 'LIVE-USE|LIVE USE|WATCH REMAINS OPEN|SECOND / VARIED') { return 'Live-use / Watch' }
    if ($Upper -match 'PARKED|SOURCE-ORE|SOURCE ORE|CANDIDATE|NOT READY') { return 'Parked / Source ore' }

    return 'Unclear / Needs review'
}

function Get-Disposition {
    param(
        [string]$Kind,
        [string]$Tier,
        [string]$Text
    )

    $Upper = $Text.ToUpperInvariant()

    if ($Tier -eq 'Proven / PASS with guardrails' -and ($Kind -eq 'Tool / Gear' -or $Kind -eq 'Rule / Learning')) {
        return 'KEEP ACTIVE SUPPORT / USE AT POINT OF WORK'
    }

    if ($Tier -eq 'Proven / PASS with guardrails' -and $Kind -eq 'Soft Suit') {
        return 'KEEP AS PROVEN SOFT SUIT / WATCH BEFORE PROMOTION'
    }

    if ($Tier -eq 'Saved / Locked') {
        return 'KEEP SAVED / USE AS REFERENCE'
    }

    if ($Tier -eq 'Live-use / Watch') {
        return 'KEEP WATCH / NEED MORE VARIED LIVE USE'
    }

    if ($Tier -eq 'Parked / Source ore') {
        return 'PARK / DO NOT PROMOTE'
    }

    if ($Kind -eq 'TODO / Live-use Watch') {
        return 'TRIAGE BY BOSS/GHOST MAP'
    }

    if ($Upper -match 'REJECT|INVALID|FAIL') {
        return 'REVIEW BEFORE USE'
    }

    return 'REVIEW / SORT LATER'
}

function Get-BoundaryShort {
    param([string]$Text)

    $Upper = $Text.ToUpperInvariant()
    $Bits = New-Object System.Collections.Generic.List[string]

    if ($Upper -match 'NO DOCTRINE') { $Bits.Add('no doctrine') | Out-Null }
    if ($Upper -match 'NO ACTIVE GUIDE') { $Bits.Add('no active guide rewrite') | Out-Null }
    if ($Upper -match 'NO CURRENT_TRUTH_INDEX') { $Bits.Add('no CURRENT_TRUTH_INDEX rewrite') | Out-Null }
    if ($Upper -match 'NO PROMOTION|NO CLOSURE|NO SCRIPT PROMOTION') { $Bits.Add('no promotion/closure') | Out-Null }
    if ($Upper -match 'NO DASHBOARD|NO AUTOMATION|NO RUNTIME') { $Bits.Add('no dashboard/automation/runtime') | Out-Null }

    if ($Bits.Count -eq 0) { return 'boundary not obvious from quick scan' }
    return ($Bits -join '; ')
}

if (-not (Test-Path -LiteralPath '.git')) {
    throw 'Not inside Mr.Kleen repo home.'
}

Write-Host 'XxXxX ===== PROVEN SUIT TOOL IDEA UNLOAD SAVE V2 START ===== XxXxX'

Run-Git fetch origin main | Out-Null

$Branch = Git-Line branch --show-current
$HeadBefore = Git-Line rev-parse HEAD
$OriginBefore = Git-Line rev-parse origin/main
$StatusBefore = @(Run-Git status --short)

if ($Branch -ne 'main') {
    throw ('Wrong branch: ' + $Branch)
}

if ($HeadBefore -ne $OriginBefore) {
    throw 'HEAD does not match origin/main. Stop before save.'
}

if ($StatusBefore.Count -ne 0) {
    Write-Host 'Dirty status before save:'
    $StatusBefore | ForEach-Object { Write-Host $_ }
    throw 'Mr.Kleen is not clean. Stop before save.'
}

$BossGhostMapPath = 'HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md'
$ResolverRulePath = 'BRAIN_LEARNING\DOWNLOADED_PS1_RESOLVER_AND_SOURCE_VALIDATION_RULE_20260520.md'
$ArtifactTodoPath = 'HOUSE_WORK\TODO\ARTIFACT_SELF_CHECK_AFTER_SEND_TODO_20260520.md'
$HandoffCardPath = 'HOUSE_WORK\WORK_SHED\AGENT_HANDOFFS\HANDOFF_ASSISTANT_SAFE_SAVE_METHOD_CARD_20260520.md'
$SkeletonPath = 'HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\MR_KLEEN_SAVE_PACKAGE_SKELETON_20260520.md'
$AnchorPath = 'ACTIVE_ANCHOR.txt'
$StatusPath = 'HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md'

$InstantiationPath = 'HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\PROVEN_SUIT_TOOL_IDEA_UNLOAD_INSTANTIATION_20260520.md'
$UnloadMapPath = 'HOUSE_WORK\WORK_SHED\SORTING_BENCH\PROVEN_SUIT_TOOL_IDEA_UNLOAD_MAP_20260520.md'
$IndexPath = 'HOUSE_WORK\WORK_SHED\INDEXES\PROVEN_SUIT_TOOL_IDEA_UNLOAD_INDEX_20260520.md'
$ReceiptPath = 'PROOF_HISTORY\PROVEN_SUIT_TOOL_IDEA_UNLOAD_RECEIPT_20260520.txt'

$RequiredInputs = @(
    $BossGhostMapPath,
    $ResolverRulePath,
    $ArtifactTodoPath,
    $HandoffCardPath,
    $SkeletonPath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

foreach ($Target in @($InstantiationPath, $UnloadMapPath, $IndexPath, $ReceiptPath)) {
    if (Test-Path -LiteralPath $Target) {
        throw ('Target already exists. Stop before overwrite: ' + $Target)
    }
}

$Roots = @(
    'HOUSE_WORK\WORK_SHED\SOFT_SUITS',
    'HOUSE_WORK\WORK_SHED\GEAR_RACK',
    'HOUSE_WORK\WORK_SHED\SORTING_BENCH',
    'HOUSE_WORK\WORK_SHED\IDEA_BAG',
    'BRAIN_LEARNING',
    'HOUSE_WORK\TODO',
    'SOURCE_ORE'
) | Where-Object { Test-Path -LiteralPath $_ }

$Files = @()
foreach ($Root in $Roots) {
    $Files += Get-ChildItem -Path $Root -File -Recurse -Include *.md,*.txt -ErrorAction SilentlyContinue
}

$Rows = @()

foreach ($File in ($Files | Sort-Object LastWriteTime -Descending)) {
    $Rel = $File.FullName.Replace((Get-Location).Path + '\', '')
    $Text = Get-Content -LiteralPath $File.FullName -Raw -Encoding UTF8
    $Upper = $Text.ToUpperInvariant()

    $IsCandidate = ($Upper -match 'PASS|PASS WITH GUARDRAILS|ADOPTED|LOCKED|SAVED CLEAN|LIVE-USE|LIVE USE|SOFT SUIT|CODE CABINET|GEAR|TOOL|RULE|GATE|LATCH|GUARD|SOURCE-ORE|SOURCE ORE|PARKED|CANDIDATE|PROOF|RECEIPT')

    if (-not $IsCandidate) {
        continue
    }

    $Title = Get-FirstMatch -Text $Text -Patterns @(
        '^\s*#\s+([^\r\n]+)',
        'Name:\s*([^\r\n]+)',
        'Title:\s*([^\r\n]+)'
    ) -Default $File.BaseName

    $StatusLine = Get-FirstMatch -Text $Text -Patterns @(
        'Status:\s*([^\r\n]+)',
        'Verdict:\s*([^\r\n]+)',
        'Result:\s*([^\r\n]+)'
    ) -Default 'unknown'

    $Purpose = Get-FirstMatch -Text $Text -Patterns @(
        '## Purpose\s+([\s\S]{1,350}?)(?:\r?\n##|\z)',
        '## Meaning\s+([\s\S]{1,350}?)(?:\r?\n##|\z)',
        'Meaning:\s*([\s\S]{1,250}?)(?:\r?\n[A-Z][A-Za-z ]+:|\r?\n##|\z)'
    ) -Default ''

    $Kind = Get-Kind -Path $Rel -Text $Text
    $Tier = Get-ProofTier -Text $Text
    $Boundary = Get-BoundaryShort -Text $Text
    $Disposition = Get-Disposition -Kind $Kind -Tier $Tier -Text $Text

    $Score = 0
    if ($Tier -eq 'Proven / PASS with guardrails') { $Score += 10 }
    if ($Tier -eq 'Saved / Locked') { $Score += 8 }
    if ($Tier -eq 'Live-use / Watch') { $Score += 6 }
    if ($Kind -eq 'Soft Suit') { $Score += 7 }
    if ($Kind -eq 'Tool / Gear') { $Score += 6 }
    if ($Kind -eq 'Rule / Learning') { $Score += 5 }
    if ($Kind -eq 'Idea / Candidate') { $Score += 3 }
    if ($Rel -match 'RECEIPT|PROOF_HISTORY') { $Score += 4 }
    if ($Tier -eq 'Parked / Source ore') { $Score -= 2 }
    if ($Rel -match 'TODO|SOURCE_ORE') { $Score -= 1 }

    $Rows += [pscustomobject]@{
        Score = $Score
        Kind = $Kind
        Tier = $Tier
        Disposition = $Disposition
        Path = $Rel
        Title = $Title
        Status = $StatusLine
        Boundary = $Boundary
        Purpose = ($Purpose -replace '\s+', ' ').Trim()
        Modified = $File.LastWriteTime
        Bytes = $File.Length
    }
}

$Rows = @($Rows | Sort-Object @{Expression='Score';Descending=$true}, @{Expression='Modified';Descending=$true})
$ByKind = @($Rows | Group-Object Kind | Sort-Object Count -Descending)
$ByTier = @($Rows | Group-Object Tier | Sort-Object Count -Descending)
$ByDisposition = @($Rows | Group-Object Disposition | Sort-Object Count -Descending)

$InstantiationLines = @(
    '# Proven Suit / Tool / Idea Unload - Code Cabinet Instantiation',
    '',
    'Date: 2026-05-20',
    '',
    '## Status',
    '',
    'CODE CABINET INSTANTIATION / UNLOAD MAP ONLY.',
    '',
    '## Trigger',
    '',
    'The user asked to unload all proven suit concepts, tools, and ideas.',
    '',
    'The read-only unload showed the house contains many proven/saved/watched/parked items and needs grouping before any promotion or cleanup.',
    '',
    '## Task',
    '',
    'Create a saved unload map and index.',
    '',
    'This is a grouping/disposition pass only.',
    '',
    'It does not promote anything.',
    '',
    'It does not close live-use watches.',
    '',
    'It does not merge source ore into doctrine.',
    '',
    '## Boundary',
    '',
    'No doctrine.',
    '',
    'No active guide rewrite.',
    '',
    'No CURRENT_TRUTH_INDEX rewrite.',
    '',
    'No dashboard.',
    '',
    'No automation.',
    '',
    'No runtime.',
    '',
    'No knowledge graph.',
    '',
    'No full lesson index.',
    '',
    'No script promotion.',
    '',
    '## Next Required Move After Save',
    '',
    'Use the unload map to choose the next proof-ranked route without hand-picking or promoting too early.'
)

$MapLines = New-Object System.Collections.Generic.List[string]

$MapLines.Add('# Proven Suit / Tool / Idea Unload Map') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('Date: 2026-05-20') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('## Status') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('UNLOAD MAP ONLY / PASS WITH GUARDRAILS.') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('## Purpose') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('Unload proven suit concepts, tools, ideas, live-use watches, parked/source-ore items, and saved support rules into one map so the house can reuse them without accidental promotion.') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('## Source State') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add(('- Branch: ' + $Branch)) | Out-Null
$MapLines.Add(('- Base HEAD: ' + $HeadBefore)) | Out-Null
$MapLines.Add('- Mode: save generated from clean synced state') | Out-Null
$MapLines.Add(('- Candidate count: ' + $Rows.Count)) | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('## Counts By Kind') | Out-Null
$MapLines.Add('') | Out-Null
foreach ($Group in $ByKind) {
    $MapLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$MapLines.Add('') | Out-Null
$MapLines.Add('## Counts By Proof Tier') | Out-Null
$MapLines.Add('') | Out-Null
foreach ($Group in $ByTier) {
    $MapLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$MapLines.Add('') | Out-Null
$MapLines.Add('## Counts By Disposition') | Out-Null
$MapLines.Add('') | Out-Null
foreach ($Group in $ByDisposition) {
    $MapLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$MapLines.Add('') | Out-Null
$MapLines.Add('## Disposition Rules') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('- Proven tools/rules stay active support at point of work, not doctrine.') | Out-Null
$MapLines.Add('- Proven Soft Suit items stay proven/watch unless explicit promotion proof exists.') | Out-Null
$MapLines.Add('- Saved/locked items stay reference material unless selected by proof.') | Out-Null
$MapLines.Add('- Live-use watches remain open until varied closure proof exists.') | Out-Null
$MapLines.Add('- Parked/source-ore items remain parked/source ore.') | Out-Null
$MapLines.Add('- TODO/live-use items route through Boss/Ghost map.') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('## Top Unload Candidates') | Out-Null
$MapLines.Add('') | Out-Null

$IndexNumber = 1
foreach ($Row in ($Rows | Select-Object -First 60)) {
    $MapLines.Add(('### ' + $IndexNumber + '. ' + $Row.Title)) | Out-Null
    $MapLines.Add('') | Out-Null
    $MapLines.Add(('- Score: ' + $Row.Score)) | Out-Null
    $MapLines.Add(('- Kind: ' + $Row.Kind)) | Out-Null
    $MapLines.Add(('- Proof tier: ' + $Row.Tier)) | Out-Null
    $MapLines.Add(('- Disposition: ' + $Row.Disposition)) | Out-Null
    $MapLines.Add(('- Path: ' + $Row.Path)) | Out-Null
    $MapLines.Add(('- Status: ' + $Row.Status)) | Out-Null
    $MapLines.Add(('- Boundary: ' + $Row.Boundary)) | Out-Null
    if (-not [string]::IsNullOrWhiteSpace($Row.Purpose)) {
        $MapLines.Add(('- Purpose/meaning: ' + $Row.Purpose)) | Out-Null
    }
    $MapLines.Add('') | Out-Null
    $IndexNumber += 1
}

$MapLines.Add('## Full Inventory') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('| # | Score | Kind | Tier | Disposition | Path | Title |') | Out-Null
$MapLines.Add('|---:|---:|---|---|---|---|---|') | Out-Null
$IndexNumber = 1
foreach ($Row in $Rows) {
    $SafeTitle = ([string]$Row.Title) -replace '\|','/'
    $SafePath = ([string]$Row.Path) -replace '\|','/'
    $MapLines.Add(('| ' + $IndexNumber + ' | ' + $Row.Score + ' | ' + $Row.Kind + ' | ' + $Row.Tier + ' | ' + $Row.Disposition + ' | ' + $SafePath + ' | ' + $SafeTitle + ' |')) | Out-Null
    $IndexNumber += 1
}

$MapLines.Add('') | Out-Null
$MapLines.Add('## Boundary') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('This unload map is not doctrine.') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('It does not rewrite active guides.') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('It does not rewrite CURRENT_TRUTH_INDEX.') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('It does not promote Soft Suit, source ore, TODOs, candidates, or tools.') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('It does not close live-use watches.') | Out-Null
$MapLines.Add('') | Out-Null
$MapLines.Add('It is a retrieval/disposition map for future proof-ranked work.') | Out-Null

$IndexLines = New-Object System.Collections.Generic.List[string]
$IndexLines.Add('# Proven Suit / Tool / Idea Unload Index') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('Date: 2026-05-20') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('## Status') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('INDEX FOR UNLOAD MAP.') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('## Main Map') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add($UnloadMapPath) | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('## Counts') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add(('Candidate count: ' + $Rows.Count)) | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('### By kind') | Out-Null
$IndexLines.Add('') | Out-Null
foreach ($Group in $ByKind) {
    $IndexLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$IndexLines.Add('') | Out-Null
$IndexLines.Add('### By proof tier') | Out-Null
$IndexLines.Add('') | Out-Null
foreach ($Group in $ByTier) {
    $IndexLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$IndexLines.Add('') | Out-Null
$IndexLines.Add('### By disposition') | Out-Null
$IndexLines.Add('') | Out-Null
foreach ($Group in $ByDisposition) {
    $IndexLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$IndexLines.Add('') | Out-Null
$IndexLines.Add('## Use') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('Use this index to enter the unload map quickly.') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('Do not promote from this index.') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('Do not close watches from this index.') | Out-Null
$IndexLines.Add('') | Out-Null
$IndexLines.Add('Use Boss/Ghost and proof-ranked routing for next action.') | Out-Null

Write-NewCleanFile -Path $InstantiationPath -Text (Join-Lines -Lines $InstantiationLines)
Write-NewCleanFile -Path $UnloadMapPath -Text ($MapLines -join [Environment]::NewLine)
Write-NewCleanFile -Path $IndexPath -Text ($IndexLines -join [Environment]::NewLine)

Require-Text -Path $InstantiationPath -Needle 'UNLOAD MAP ONLY'
Require-Text -Path $UnloadMapPath -Needle 'Full Inventory'
Require-Text -Path $UnloadMapPath -Needle 'It does not close live-use watches'
Require-Text -Path $IndexPath -Needle 'Use this index to enter the unload map quickly'

$AnchorLines = @(
    'CURRENT MR.KLEEN POSITION',
    '',
    'After Proven Suit / Tool / Idea Unload Map.',
    '',
    ('Base before save: ' + $HeadBefore),
    '',
    'Current ball:',
    '- Proven suit concepts, tools, ideas, live-use watches, source ore, and support rules were unloaded into a saved map.',
    ('- Candidate count: ' + $Rows.Count),
    ('- Main map: ' + $UnloadMapPath),
    ('- Index: ' + $IndexPath),
    '- This is a grouping/disposition map only.',
    '- No promotion, closure, doctrine, active guide rewrite, or CURRENT_TRUTH_INDEX rewrite occurred.',
    '',
    'Next allowed move:',
    '- Use the unload map to choose the next proof-ranked route.',
    '- Continue TODO weakest-link triage using Boss/Ghost map if no direct unload route is selected.',
    '- Keep proven tools/rules as point-of-work support.',
    '- Keep Soft Suit items in proven/watch unless explicit promotion proof exists.',
    '- Keep source ore parked unless selected through adopt gate.',
    '',
    'Blocked moves:',
    '- Do not promote from the unload map.',
    '- Do not close live-use watches from the unload map alone.',
    '- Do not merge source ore into doctrine.',
    '- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.'
)

Set-Content -LiteralPath $AnchorPath -Value (Join-Lines -Lines $AnchorLines) -Encoding UTF8
Assert-CleanTextFile -Path $AnchorPath

$StatusLines = New-Object System.Collections.Generic.List[string]
$StatusLines.Add('---') | Out-Null
$StatusLines.Add('') | Out-Null
$StatusLines.Add('## 2026-05-20 - Proven Suit / Tool / Idea Unload Map') | Out-Null
$StatusLines.Add('') | Out-Null
$StatusLines.Add('Status: PASS WITH GUARDRAILS / UNLOAD MAP ONLY.') | Out-Null
$StatusLines.Add('') | Out-Null
$StatusLines.Add(('Base before save: ' + $HeadBefore)) | Out-Null
$StatusLines.Add('') | Out-Null
$StatusLines.Add('Saved:') | Out-Null
$StatusLines.Add($InstantiationPath) | Out-Null
$StatusLines.Add($UnloadMapPath) | Out-Null
$StatusLines.Add($IndexPath) | Out-Null
$StatusLines.Add($ReceiptPath) | Out-Null
$StatusLines.Add('') | Out-Null
$StatusLines.Add('Updated:') | Out-Null
$StatusLines.Add($AnchorPath) | Out-Null
$StatusLines.Add($StatusPath) | Out-Null
$StatusLines.Add('') | Out-Null
$StatusLines.Add('Counts by kind:') | Out-Null
foreach ($Group in $ByKind) {
    $StatusLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$StatusLines.Add('') | Out-Null
$StatusLines.Add('Meaning:') | Out-Null
$StatusLines.Add('- proven suit concepts, tools, ideas, live-use watches, source ore, and support rules were grouped into one unload map;') | Out-Null
$StatusLines.Add(('- candidate count: ' + $Rows.Count + ';')) | Out-Null
$StatusLines.Add('- dispositions were assigned as keep active support, proven/watch, saved reference, live-use watch, parked/source ore, TODO triage, or review;') | Out-Null
$StatusLines.Add('- no promotion or closure occurred.') | Out-Null
$StatusLines.Add('') | Out-Null
$StatusLines.Add('Boundary:') | Out-Null
$StatusLines.Add('- no doctrine install;') | Out-Null
$StatusLines.Add('- no active guide rewrite;') | Out-Null
$StatusLines.Add('- no CURRENT_TRUTH_INDEX rewrite;') | Out-Null
$StatusLines.Add('- no dashboard/automation/runtime/knowledge graph/full lesson index;') | Out-Null
$StatusLines.Add('- no script promotion;') | Out-Null
$StatusLines.Add('- no source-ore promotion;') | Out-Null
$StatusLines.Add('- no live-use watch closure.') | Out-Null
$StatusLines.Add('') | Out-Null
$StatusLines.Add('Next move:') | Out-Null
$StatusLines.Add('- choose the next proof-ranked route using the unload map and Boss/Ghost map.') | Out-Null

Append-Once -Path $StatusPath -Marker '2026-05-20 - Proven Suit / Tool / Idea Unload Map' -Lines $StatusLines.ToArray()

$ChangedForHash = @(
    $InstantiationPath,
    $UnloadMapPath,
    $IndexPath,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashTableText -Paths $ChangedForHash

$ReceiptLines = New-Object System.Collections.Generic.List[string]
$ReceiptLines.Add('# Proven Suit / Tool / Idea Unload Receipt') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('Date: 2026-05-20') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('## Result') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('PASS WITH GUARDRAILS / UNLOAD MAP ONLY.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('## Base Before Save') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add(('Branch: ' + $Branch)) | Out-Null
$ReceiptLines.Add(('HEAD before save: ' + $HeadBefore)) | Out-Null
$ReceiptLines.Add(('origin/main before save: ' + $OriginBefore)) | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('## Files') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add($HashList) | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('## Counts') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add(('Candidate count: ' + $Rows.Count)) | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('### By kind') | Out-Null
$ReceiptLines.Add('') | Out-Null
foreach ($Group in $ByKind) {
    $ReceiptLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('### By proof tier') | Out-Null
$ReceiptLines.Add('') | Out-Null
foreach ($Group in $ByTier) {
    $ReceiptLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('### By disposition') | Out-Null
$ReceiptLines.Add('') | Out-Null
foreach ($Group in $ByDisposition) {
    $ReceiptLines.Add(('- ' + $Group.Name + ': ' + $Group.Count)) | Out-Null
}
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('## Meaning') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('This save unloads proven suits, tools, concepts, ideas, live-use watches, source ore, and support rules into a retrieval/disposition map.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('It does not promote anything.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('It does not close live-use watches.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('It does not merge source ore into doctrine.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('## Boundary') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No doctrine install.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No active guide rewrite.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No CURRENT_TRUTH_INDEX rewrite.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No dashboard.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No automation.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No runtime.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No knowledge graph.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No full lesson index.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No script promotion.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No source-ore promotion.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('No live-use watch closure.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('## Artifact Self-Check') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('This save created and checked a real Mr.Kleen artifact package.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('Checks performed:') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('- target files did not already exist before writing;') | Out-Null
$ReceiptLines.Add('- source files validated for custody/readability;') | Out-Null
$ReceiptLines.Add('- generated artifacts checked for required phrases;') | Out-Null
$ReceiptLines.Add('- files readable as UTF-8 text;') | Out-Null
$ReceiptLines.Add('- files nonempty;') | Out-Null
$ReceiptLines.Add('- no NUL bytes;') | Out-Null
$ReceiptLines.Add('- no Unicode replacement characters;') | Out-Null
$ReceiptLines.Add('- no placeholder markers;') | Out-Null
$ReceiptLines.Add('- branch main;') | Out-Null
$ReceiptLines.Add('- HEAD equals origin/main before save;') | Out-Null
$ReceiptLines.Add('- clean status before save;') | Out-Null
$ReceiptLines.Add('- final commit/push/fetch requires HEAD equals origin/main and status clean.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('## Proof Limit') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('This receipt proves the unload map and index save.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('It does not prove promotion.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('It does not prove closure.') | Out-Null
$ReceiptLines.Add('') | Out-Null
$ReceiptLines.Add('It does not prove all source ore is mature.') | Out-Null

Write-NewCleanFile -Path $ReceiptPath -Text ($ReceiptLines -join [Environment]::NewLine)
Require-Text -Path $ReceiptPath -Needle 'PASS WITH GUARDRAILS / UNLOAD MAP ONLY'
Require-Text -Path $ReceiptPath -Needle 'It does not prove promotion'

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Run-Git add -- $InstantiationPath $UnloadMapPath $IndexPath $AnchorPath $StatusPath | Out-Null
Run-Git add -f -- $ReceiptPath | Out-Null

$Staged = @(Run-Git diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw 'Nothing staged. Stop.'
}

Run-Git commit -m 'Unload proven suits tools and ideas' | Out-Null
Run-Git push origin main | Out-Null
Run-Git fetch origin main | Out-Null

$Head = Git-Line rev-parse HEAD
$Origin = Git-Line rev-parse origin/main
$Short = Git-Line rev-parse --short HEAD
$FinalStatus = @(Run-Git status --short)

if ($Head -ne $Origin) {
    throw 'Final proof failed: HEAD does not match origin/main.'
}

if ($FinalStatus.Count -ne 0) {
    Write-Host 'Final dirty status:'
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw 'Final proof failed: status not clean.'
}

Write-Host ''
Write-Host 'XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX'
Write-Host 'PROVEN SUIT TOOL IDEA UNLOAD SAVED'
Write-Host ('Commit: ' + $Short)
Write-Host ('HEAD: ' + $Head)
Write-Host ('origin/main: ' + $Origin)
Write-Host 'Status: clean'
Write-Host ('Map: ' + $UnloadMapPath)
Write-Host ('Index: ' + $IndexPath)
Write-Host ('Instantiation: ' + $InstantiationPath)
Write-Host ('Receipt: ' + $ReceiptPath)
Write-Host ('Receipt bytes: ' + $ReceiptBytes)
Write-Host ('Receipt SHA256: ' + $ReceiptHash)
Write-Host ('Candidate count: ' + $Rows.Count)
Write-Host 'Verdict: PASS WITH GUARDRAILS / UNLOAD MAP ONLY'
Write-Host 'Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; no script promotion; no source-ore promotion; no live-use watch closure'
Write-Host 'Next move: choose next proof-ranked route using unload map and Boss/Ghost map'
Write-Host 'XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX'
