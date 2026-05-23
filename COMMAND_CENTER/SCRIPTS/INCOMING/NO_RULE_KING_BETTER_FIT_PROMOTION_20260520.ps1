$ErrorActionPreference = "Stop"

function Invoke-GitChecked {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(& git @Args 2>&1)
    if ($LASTEXITCODE -ne 0) {
        $Output | ForEach-Object { Write-Host $_ }
        throw ("Git failed: git " + ($Args -join " "))
    }
    return $Output
}

function Get-GitLine {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(Invoke-GitChecked @Args)
    if ($Output.Count -lt 1) {
        throw ("Git returned no output: git " + ($Args -join " "))
    }
    return ([string]($Output | Select-Object -First 1)).Trim()
}

function Join-TextLines {
    param([object[]]$Lines)
    if ($null -eq $Lines) { return "" }
    return (($Lines | ForEach-Object { [string]$_ }) -join [Environment]::NewLine)
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

    foreach ($Bad in @("[PLACEHOLDER]", "TODO: fill", "lorem ipsum")) {
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
        [object[]]$Lines
    )

    Assert-CleanTextFile -Path $Path
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8

    if ($Raw -match [regex]::Escape($Marker)) {
        throw ("Append marker already exists. Stop to avoid duplicate: " + $Path + " / " + $Marker)
    }

    $AppendText = Join-TextLines -Lines $Lines
    $NewText = $Raw.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $AppendText
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

function Get-HashText {
    param([Parameter(Mandatory = $true)][string[]]$Paths)

    $Rows = New-Object System.Collections.Generic.List[string]

    foreach ($Path in $Paths) {
        Assert-CleanTextFile -Path $Path
        $Item = Get-Item -LiteralPath $Path
        $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        $Rows.Add(("- " + $Path + " | bytes=" + $Item.Length + " | sha256=" + $Hash)) | Out-Null
    }

    return ($Rows -join [Environment]::NewLine)
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home."
}

Write-Host "XxXxX ===== NO RULE KING BETTER FIT PROMOTION START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$HeadBefore = Get-GitLine rev-parse HEAD
$OriginBefore = Get-GitLine rev-parse origin/main
$StatusBefore = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") {
    throw ("Wrong branch: " + $Branch)
}

if ($HeadBefore -ne $OriginBefore) {
    throw "HEAD does not match origin/main. Stop before save."
}

if ($StatusBefore.Count -ne 0) {
    Write-Host "Dirty status before save:"
    $StatusBefore | ForEach-Object { Write-Host $_ }
    throw "Mr.Kleen is not clean. Stop before save."
}

$UnloadMapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\PROVEN_SUIT_TOOL_IDEA_UNLOAD_MAP_20260520.md"
$BossGhostMapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md"
$TodoWeakestRulePath = "BRAIN_LEARNING\TODO_PROOF_RANKED_WEAKEST_LINK_SELECTION_RULE_20260520.md"
$CodeCabinetRulePath = "BRAIN_LEARNING\CODE_CABINET_BRIDGE_METHOD_RULE_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$RulePath = "BRAIN_LEARNING\NO_RULE_KING_BETTER_FIT_PROMOTION_RULE_20260520.md"
$DispositionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\NO_RULE_KING_BETTER_FIT_PROMOTION_CLARIFICATION_20260520.md"
$TodoPath = "HOUSE_WORK\TODO\NO_RULE_KING_BETTER_FIT_PROMOTION_LIVE_USE_TODO_20260520.md"
$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\NO_RULE_KING_BETTER_FIT_PROMOTION_INSTANTIATION_20260520.md"
$ReceiptPath = "PROOF_HISTORY\NO_RULE_KING_BETTER_FIT_PROMOTION_RECEIPT_20260520.txt"

$RequiredInputs = @(
    $UnloadMapPath,
    $BossGhostMapPath,
    $TodoWeakestRulePath,
    $CodeCabinetRulePath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

foreach ($Target in @($RulePath, $DispositionPath, $TodoPath, $InstantiationPath, $ReceiptPath)) {
    if (Test-Path -LiteralPath $Target) {
        throw ("Target already exists. Stop before overwrite: " + $Target)
    }
}

$RuleLines = @(
    "# No Rule King / Better-Fit Promotion Rule",
    "",
    "Date: 2026-05-20",
    "",
    "## Status",
    "",
    "ACTIVE SUPPORT RULE / FAMILY-OF-RULES CLARIFICATION.",
    "",
    "## User Clarification",
    "",
    "No one rule is king ding-a-ling in our home.",
    "",
    "The house is not a monarchy.",
    "",
    "Rules, tools, suits, concepts, ideas, TODOs, proof receipts, and maps must work together as neighbors.",
    "",
    "## Rule",
    "",
    "No single rule becomes absolute ruler of the house.",
    "",
    "A rule can guide, block, test, sort, or protect inside its lane, but it does not overrule the whole model by age, loudness, title, or previous save.",
    "",
    "When a new idea, rule, suit, or tool arrives and the proof shows it is clearly better, the house should not protect the old item from embarrassment.",
    "",
    "If the new item fits the core, respects neighboring lanes, reduces bloat, improves working proof, and does not violate authority boundaries, then it may be adapted, adopted, or promoted through the proper proof path.",
    "",
    "## Better-Fit Promotion Gate",
    "",
    "A newer item may outrank or supersede an older item only when all of these are true:",
    "",
    "1. It fits the core model.",
    "2. It has the right lane and authority level.",
    "3. It respects neighboring rules and does not create rule-fighting.",
    "4. It reduces bloat or confusion rather than adding more fog.",
    "5. It proves better behavior at the point of work.",
    "6. It preserves useful prior meaning through copy-continuity.",
    "7. It leaves a receipt showing what changed, why, and what did not change.",
    "",
    "## Old Rule Treatment",
    "",
    "An old rule is not sacred by age alone.",
    "",
    "An old rule should be preserved, adapted, narrowed, merged, parked, superseded, or retired based on proof and fit.",
    "",
    "Do not delete useful old meaning just because a newer idea is exciting.",
    "",
    "Do not keep a weaker old rule just because it got there first.",
    "",
    "## Anti-Bloat Boundary",
    "",
    "New does not mean better.",
    "",
    "Better means cleaner fit, stronger proof, better neighbor behavior, less fog, and better work at the point of use.",
    "",
    "If the new item is attractive but unproved, park it.",
    "",
    "If it fights the house, reject or quarantine it.",
    "",
    "If it fits and works, promote through proof.",
    "",
    "## Boundary",
    "",
    "No doctrine install.",
    "",
    "No active guide rewrite.",
    "",
    "No CURRENT_TRUTH_INDEX rewrite.",
    "",
    "No dashboard.",
    "",
    "No automation.",
    "",
    "No runtime.",
    "",
    "No knowledge graph.",
    "",
    "No full lesson index.",
    "",
    "This rule clarifies rule-family behavior and better-fit promotion only."
)

$DispositionLines = @(
    "# No Rule King / Better-Fit Promotion Clarification",
    "",
    "Date: 2026-05-20",
    "",
    "## Status",
    "",
    "PASS WITH GUARDRAILS / CLARIFICATION SAVED.",
    "",
    "## Trigger",
    "",
    "The user clarified that no single rule should become king of the house.",
    "",
    "The house must work as a family system where rules and ideas cooperate, and where a better new fit can replace or supersede an older weaker fit through proof.",
    "",
    "## Disposition",
    "",
    "This clarification is saved as a support rule.",
    "",
    "It strengthens the existing neighbor policy, proof-ranked routing, copy-continuity, and anti-bloat behavior.",
    "",
    "It does not make the newest idea king either.",
    "",
    "It says better-fit proof decides.",
    "",
    "## What This Prevents",
    "",
    "- rule monarchy;",
    "- frozen old rules;",
    "- fear of replacing a weaker pattern;",
    "- new-rule excitement without proof;",
    "- bloat disguised as growth;",
    "- rule-fighting between neighbors.",
    "",
    "## What This Allows",
    "",
    "- new ideas to be tested fairly;",
    "- older rules to be refined or superseded;",
    "- better-fit promotion when proof is in the pudding;",
    "- clean adaptation when the house learns;",
    "- preserving useful prior meaning while improving the working route.",
    "",
    "## Boundary",
    "",
    "No doctrine.",
    "",
    "No active guide rewrite.",
    "",
    "No CURRENT_TRUTH_INDEX rewrite.",
    "",
    "No promotion from excitement alone.",
    "",
    "No deletion of prior useful meaning.",
    "",
    "No dashboard, automation, runtime, knowledge graph, or full lesson index."
)

$TodoLines = @(
    "# TODO - No Rule King / Better-Fit Promotion Live Use",
    "",
    "Date: 2026-05-20",
    "Lane: HOUSE_WORK / TODO",
    "Status: open live-use watch / support TODO, not authority",
    "Parent: Rule Activation / Work-Order Control",
    "",
    "## Purpose",
    "",
    "Watch whether the assistant treats rules as a cooperative family rather than a monarchy.",
    "",
    "## Trigger",
    "",
    "Use when a new idea, rule, suit, tool, or pattern appears to be better than an existing one.",
    "",
    "## Required Check",
    "",
    "Before adopting the new item, check:",
    "",
    "- core fit;",
    "- lane fit;",
    "- neighbor fit;",
    "- proof at point of work;",
    "- bloat risk;",
    "- copy-continuity with useful prior meaning;",
    "- authority boundary;",
    "- receipt path.",
    "",
    "## Pass Evidence",
    "",
    "A future live use passes when a better-fit item is adopted, adapted, parked, blocked, or superseded through proof rather than age, excitement, fear, or hierarchy.",
    "",
    "## Boundary",
    "",
    "This TODO does not promote anything by itself.",
    "",
    "It does not rewrite doctrine.",
    "",
    "It does not rewrite active guides.",
    "",
    "It does not rewrite CURRENT_TRUTH_INDEX."
)

$InstantiationLines = @(
    "# No Rule King / Better-Fit Promotion - Code Cabinet Instantiation",
    "",
    "Date: 2026-05-20",
    "",
    "## Status",
    "",
    "CODE CABINET INSTANTIATION / CLARIFICATION SAVE.",
    "",
    "## Trigger",
    "",
    "The user clarified that no rule is king ding-a-ling in the house and that a better new idea/rule should be promoted when it fits, proves, and is not bloat.",
    "",
    "## Task",
    "",
    "Save the clarification as a support rule, disposition note, and live-use TODO.",
    "",
    "## Boundary",
    "",
    "No doctrine.",
    "",
    "No active guide rewrite.",
    "",
    "No CURRENT_TRUTH_INDEX rewrite.",
    "",
    "No dashboard.",
    "",
    "No automation.",
    "",
    "No runtime.",
    "",
    "No knowledge graph.",
    "",
    "No full lesson index.",
    "",
    "## Next Required Move After Save",
    "",
    "Continue choosing the next proof-ranked route using unload map and Boss/Ghost map."
)

Write-NewCleanFile -Path $RulePath -Text (Join-TextLines -Lines $RuleLines)
Write-NewCleanFile -Path $DispositionPath -Text (Join-TextLines -Lines $DispositionLines)
Write-NewCleanFile -Path $TodoPath -Text (Join-TextLines -Lines $TodoLines)
Write-NewCleanFile -Path $InstantiationPath -Text (Join-TextLines -Lines $InstantiationLines)

Require-Text -Path $RulePath -Needle "No single rule becomes absolute ruler of the house."
Require-Text -Path $RulePath -Needle "If it fits and works, promote through proof."
Require-Text -Path $DispositionPath -Needle "It does not make the newest idea king either."
Require-Text -Path $TodoPath -Needle "support TODO, not authority"
Require-Text -Path $InstantiationPath -Needle "CLARIFICATION SAVE"

$StatusMarker = "2026-05-20 - No Rule King / Better-Fit Promotion Clarification"
$StatusAppend = @(
    "---",
    "",
    "## 2026-05-20 - No Rule King / Better-Fit Promotion Clarification",
    "",
    "Status: PASS WITH GUARDRAILS / CLARIFICATION SAVE.",
    "",
    ("Base before save: " + $HeadBefore),
    "",
    "Saved:",
    $RulePath,
    $DispositionPath,
    $TodoPath,
    $InstantiationPath,
    $ReceiptPath,
    "",
    "Meaning:",
    "- no single rule is king of the house;",
    "- rules, tools, suits, concepts, and ideas must work together as neighbors;",
    "- new ideas/rules may supersede older ones only by better-fit proof;",
    "- old rules are not sacred by age alone;",
    "- new ideas are not promoted by excitement alone;",
    "- copy-continuity and anti-bloat checks still apply.",
    "",
    "Boundary:",
    "- no doctrine install;",
    "- no active guide rewrite;",
    "- no CURRENT_TRUTH_INDEX rewrite;",
    "- no dashboard/automation/runtime/knowledge graph/full lesson index;",
    "- no promotion from this clarification alone.",
    "",
    "Next move:",
    "- continue choosing the next proof-ranked route using unload map and Boss/Ghost map."
)

Append-Once -Path $StatusPath -Marker $StatusMarker -Lines $StatusAppend

$AnchorLines = @(
    "CURRENT MR.KLEEN POSITION",
    "",
    "After No Rule King / Better-Fit Promotion clarification.",
    "",
    ("Base before save: " + $HeadBefore),
    "",
    "Current ball:",
    "- No single rule is king of the house.",
    "- Rules, tools, suits, concepts, ideas, maps, TODOs, and proof receipts must work as neighbors.",
    "- New items can supersede older items when proof shows better fit, lower bloat, cleaner neighbor behavior, and stronger point-of-work behavior.",
    "- Old rules are not sacred by age alone.",
    "- New ideas are not promoted by excitement alone.",
    "",
    "Next allowed move:",
    "- Continue choosing the next proof-ranked route using unload map and Boss/Ghost map.",
    "- Use the Better-Fit Promotion Gate when a newer item appears better than an older one.",
    "",
    "Blocked moves:",
    "- Do not make any one rule king.",
    "- Do not promote from excitement alone.",
    "- Do not protect weaker old rules from better proof.",
    "- Do not delete useful prior meaning without copy-continuity.",
    "- Do not install doctrine.",
    "- Do not rewrite active guides.",
    "- Do not rewrite CURRENT_TRUTH_INDEX.",
    "- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index."
)

Set-Content -LiteralPath $AnchorPath -Value (Join-TextLines -Lines $AnchorLines) -Encoding UTF8
Assert-CleanTextFile -Path $AnchorPath

$ChangedForHash = @(
    $RulePath,
    $DispositionPath,
    $TodoPath,
    $InstantiationPath,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashText -Paths $ChangedForHash

$ReceiptLines = @(
    "# No Rule King / Better-Fit Promotion Receipt",
    "",
    "Date: 2026-05-20",
    "",
    "## Result",
    "",
    "PASS WITH GUARDRAILS / CLARIFICATION SAVE.",
    "",
    "## Base Before Save",
    "",
    ("Branch: " + $Branch),
    ("HEAD before save: " + $HeadBefore),
    ("origin/main before save: " + $OriginBefore),
    "",
    "## Files",
    "",
    $HashList,
    "",
    "## Meaning",
    "",
    "The house now has a saved clarification that no single rule is king.",
    "",
    "Rules, tools, suits, concepts, and ideas work as neighbors.",
    "",
    "A new item can supersede an older item only when better-fit proof shows core fit, lane fit, neighbor fit, non-bloat, stronger point-of-work behavior, copy-continuity, and clean authority boundary.",
    "",
    "## Boundary",
    "",
    "No doctrine install.",
    "",
    "No active guide rewrite.",
    "",
    "No CURRENT_TRUTH_INDEX rewrite.",
    "",
    "No dashboard.",
    "",
    "No automation.",
    "",
    "No runtime.",
    "",
    "No knowledge graph.",
    "",
    "No full lesson index.",
    "",
    "No promotion from this clarification alone.",
    "",
    "## Artifact Self-Check",
    "",
    "This save created and checked a real Mr.Kleen artifact package.",
    "",
    "Checks performed:",
    "",
    "- target files did not already exist before writing;",
    "- required inputs existed and were readable;",
    "- generated artifacts checked for required phrases;",
    "- files readable as UTF-8 text;",
    "- files nonempty;",
    "- no NUL bytes;",
    "- no Unicode replacement characters;",
    "- no placeholder markers;",
    "- branch main;",
    "- HEAD equals origin/main before save;",
    "- clean status before save;",
    "- final commit/push/fetch requires HEAD equals origin/main and status clean.",
    "",
    "## Proof Limit",
    "",
    "This receipt proves the clarification save.",
    "",
    "It does not promote a new doctrine.",
    "",
    "It does not close the live-use TODO."
)

Write-NewCleanFile -Path $ReceiptPath -Text (Join-TextLines -Lines $ReceiptLines)
Require-Text -Path $ReceiptPath -Needle "no single rule is king"
Require-Text -Path $ReceiptPath -Needle "It does not promote a new doctrine"

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Invoke-GitChecked add -- $RulePath $DispositionPath $TodoPath $InstantiationPath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "Nothing staged. Stop."
}

Invoke-GitChecked commit -m "Clarify no rule king better fit promotion" | Out-Null
Invoke-GitChecked push origin main | Out-Null
Invoke-GitChecked fetch origin main | Out-Null

$Head = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$Short = Get-GitLine rev-parse --short HEAD
$FinalStatus = @(Invoke-GitChecked status --short)

if ($Head -ne $Origin) {
    throw "Final proof failed: HEAD does not match origin/main."
}

if ($FinalStatus.Count -ne 0) {
    Write-Host "Final dirty status:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final proof failed: status not clean."
}

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "NO RULE KING BETTER FIT PROMOTION SAVED"
Write-Host ("Commit: " + $Short)
Write-Host ("HEAD: " + $Head)
Write-Host ("origin/main: " + $Origin)
Write-Host "Status: clean"
Write-Host ("Rule: " + $RulePath)
Write-Host ("Disposition: " + $DispositionPath)
Write-Host ("TODO: " + $TodoPath)
Write-Host ("Instantiation: " + $InstantiationPath)
Write-Host ("Receipt: " + $ReceiptPath)
Write-Host ("Receipt bytes: " + $ReceiptBytes)
Write-Host ("Receipt SHA256: " + $ReceiptHash)
Write-Host "Verdict: PASS WITH GUARDRAILS / CLARIFICATION SAVE"
Write-Host "Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; no promotion from this clarification alone"
Write-Host "Next move: continue choosing the next proof-ranked route using unload map and Boss/Ghost map"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
