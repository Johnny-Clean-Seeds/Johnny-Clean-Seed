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

Write-Host "XxXxX ===== RELEVANT ROOT KEY TOOL SELECTOR START ===== XxXxX"

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

$LivingRootPath = "BRAIN_LEARNING\LIVING_ROOT_WORDS_AND_RULE_ACTIVATION_KEYS_20260520.md"
$NoRuleKingPath = "BRAIN_LEARNING\NO_RULE_KING_BETTER_FIT_PROMOTION_RULE_20260520.md"
$UnloadMapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\PROVEN_SUIT_TOOL_IDEA_UNLOAD_MAP_20260520.md"
$BossGhostMapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$RulePath = "BRAIN_LEARNING\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_RULE_20260520.md"
$DispositionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_DISPOSITION_20260520.md"
$PocketPath = "HOUSE_WORK\WORK_SHED\IDEA_BAG\RELEVANT_ROOT_KEY_AND_TOOL_USE_POCKET_LIST_20260520.md"
$TodoPath = "HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md"
$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_INSTANTIATION_20260520.md"
$ReceiptPath = "PROOF_HISTORY\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_RECEIPT_20260520.txt"

$RequiredInputs = @(
    $LivingRootPath,
    $NoRuleKingPath,
    $UnloadMapPath,
    $BossGhostMapPath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

Require-Text -Path $LivingRootPath -Needle "Root words are not slogans."
Require-Text -Path $LivingRootPath -Needle "Do not recite the whole list unless the task is about the list."
Require-Text -Path $NoRuleKingPath -Needle "No single rule becomes absolute ruler of the house."
Require-Text -Path $NoRuleKingPath -Needle "If it fits and works, promote through proof."

foreach ($Target in @($RulePath, $DispositionPath, $PocketPath, $TodoPath, $InstantiationPath, $ReceiptPath)) {
    if (Test-Path -LiteralPath $Target) {
        throw ("Target already exists. Stop before overwrite: " + $Target)
    }
}

$RuleLines = @(
    "# Relevant Root Key And Tool Use Selector Rule",
    "",
    "Date: 2026-05-20",
    "",
    "## Status",
    "",
    "ACTIVE SUPPORT RULE / POINT-OF-WORK SELECTOR.",
    "",
    "## Purpose",
    "",
    "Turn Living Root Words into a practical relevant-use selector without making them king.",
    "",
    "The assistant should not recite every root key or tool just because the list exists.",
    "",
    "The assistant should select only the keys and tools that fit the current task, then use them to route, stop, park, save, cite, or prove the work.",
    "",
    "## Rule",
    "",
    "Before nontrivial Mr.Kleen work, select a small set of relevant operating keys and tools.",
    "",
    "Default selector size: two to five keys.",
    "",
    "Use fewer when the task is simple.",
    "",
    "Use more only when the task genuinely crosses lanes.",
    "",
    "A selected key must change a decision, not decorate the response.",
    "",
    "A selected tool must serve evidence, creation, validation, search, proof, or handoff. Do not use tools just to touch tools.",
    "",
    "## Selector Method",
    "",
    "1. Name the control state.",
    "2. Pick the relevant root keys only.",
    "3. Pick the relevant tools only.",
    "4. State what each selected key/tool allows or blocks.",
    "5. Act only inside the selected lane and authority boundary.",
    "6. Keep unneeded keys/tools silent.",
    "7. If a better-fit rule or tool appears, apply the No Rule King gate.",
    "",
    "## Tool Fit Rule",
    "",
    "Use relevant tools, not every tool literally.",
    "",
    "Examples:",
    "",
    "- Use file search when uploaded files or current file text are the evidence surface.",
    "- Use web only when freshness, external facts, direct sources, or current data matter.",
    "- Use PowerShell scripts when Mr.Kleen needs real repo artifacts or proof packages.",
    "- Use simple direct commands when a full script would be bloat.",
    "- Use artifact creation only when the user needs a file or durable output.",
    "- Use no tool when reasoning over already provided text is enough.",
    "",
    "## No Rule King Guard",
    "",
    "This selector does not crown Living Root Words.",
    "",
    "Living Root Words remain a support layer.",
    "",
    "No single root key overrules the house.",
    "",
    "No tool is used because it is available.",
    "",
    "A newer key or method may supersede this selector only through better-fit proof, anti-bloat, neighbor fit, copy-continuity, and receipt.",
    "",
    "## Fail Signals",
    "",
    "- reciting the entire root list when the task does not ask for it;",
    "- using every tool because tools exist;",
    "- treating a support key as doctrine;",
    "- skipping proof because a key sounded right;",
    "- selecting a key but not changing behavior;",
    "- ignoring a better-fit new method because an older rule exists.",
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
    "No promotion of Living Root Words to active guide."
)

$DispositionLines = @(
    "# Relevant Root Key And Tool Use Selector Disposition",
    "",
    "Date: 2026-05-20",
    "",
    "## Status",
    "",
    "PASS WITH GUARDRAILS / POINT-OF-WORK SELECTOR SAVE.",
    "",
    "## Trigger",
    "",
    "After the No Rule King clarification, the Living Root Words route was rechecked.",
    "",
    "The decision was not to crown Living Root Words.",
    "",
    "The decision was to make a narrow relevant-use selector that makes root keys and tools fire only when they fit the current task.",
    "",
    "## Decision",
    "",
    "Living Root Words stays support / operating key layer.",
    "",
    "The selector becomes a small point-of-work method:",
    "",
    "- choose two to five relevant keys;",
    "- choose only tools that serve the task;",
    "- explain what the selected keys/tools allow or block;",
    "- keep the rest silent;",
    "- use No Rule King if a better-fit method appears.",
    "",
    "## Why This Fits",
    "",
    "It solves the repeated failure mode where rules exist but do not fire.",
    "",
    "It does not make one rule king.",
    "",
    "It reduces bloat by preventing whole-list recitation.",
    "",
    "It strengthens tool choice by making relevance explicit.",
    "",
    "It keeps proof and authority boundaries intact.",
    "",
    "## Boundary",
    "",
    "No doctrine.",
    "",
    "No active guide rewrite.",
    "",
    "No CURRENT_TRUTH_INDEX rewrite.",
    "",
    "No promotion of Living Root Words.",
    "",
    "No dashboard, automation, runtime, knowledge graph, or full lesson index."
)

$PocketLines = @(
    "# Relevant Root Key And Tool Use Pocket List",
    "",
    "Date: 2026-05-20",
    "Lane: HOUSE_WORK / WORK_SHED / IDEA_BAG",
    "Status: pocket list / support card, not authority",
    "",
    "## Use",
    "",
    "At task start, choose only what fits.",
    "",
    "Do not recite the whole list unless the task is about the list.",
    "",
    "## Fast Selector",
    "",
    "### 1. Control State",
    "",
    "What controls this task right now?",
    "",
    "- current commit/state",
    "- user command",
    "- active boss",
    "- worker custody",
    "- proof condition",
    "- file/artifact boundary",
    "",
    "### 2. Pick 2-5 Root Keys",
    "",
    "Common picks:",
    "",
    "- Control state first",
    "- Rule exists is not rule fired",
    "- Boss first, ghosts under it",
    "- Complete means proven to this task's standard",
    "- Use the tools that fit",
    "- Open intake, bounded authority",
    "- Current task first, later issue parked",
    "- Source ore is not command",
    "- Proof is claim-scoped",
    "- No random moves",
    "",
    "### 3. Pick Fitting Tools",
    "",
    "- none: direct reasoning is enough",
    "- file search: current uploaded files are evidence",
    "- web: current external facts or sources matter",
    "- PowerShell command: read/check Mr.Kleen state",
    "- downloadable PowerShell script: save real artifacts with proof",
    "- artifact file: user needs durable output",
    "- mule/handoff: bounded outside critique is needed",
    "",
    "### 4. State Allow / Block",
    "",
    "For each selected key or tool, say what it allows or blocks.",
    "",
    "### 5. Act",
    "",
    "Move only inside the selected lane.",
    "",
    "## No Rule King Reminder",
    "",
    "This pocket list is a helper, not a ruler.",
    "",
    "Better-fit proof can narrow, replace, or supersede it."
)

$TodoLines = @(
    "# TODO - Relevant Root Key And Tool Use Selector Live Use",
    "",
    "Date: 2026-05-20",
    "Lane: HOUSE_WORK / TODO",
    "Status: open live-use watch / support TODO, not authority",
    "Parent: Rule Activation / Work-Order Control",
    "",
    "## Purpose",
    "",
    "Watch whether the assistant uses only relevant root keys and tools instead of reciting or overusing them.",
    "",
    "## Trigger",
    "",
    "Any nontrivial Mr.Kleen work after this save.",
    "",
    "## Pass Evidence",
    "",
    "A pass needs a real task where the assistant:",
    "",
    "- names control state;",
    "- selects only relevant keys;",
    "- selects only relevant tools;",
    "- explains allow/block briefly;",
    "- acts inside boundary;",
    "- proves the task to its own standard;",
    "- does not crown one rule or one tool.",
    "",
    "## Failure Evidence",
    "",
    "- no key selected before nontrivial action;",
    "- whole list recited without need;",
    "- tool used without fit;",
    "- support rule treated as doctrine;",
    "- better-fit rule blocked because old rule existed.",
    "",
    "## Boundary",
    "",
    "This TODO does not promote the selector.",
    "",
    "It does not rewrite doctrine.",
    "",
    "It does not rewrite active guides.",
    "",
    "It does not rewrite CURRENT_TRUTH_INDEX."
)

$InstantiationLines = @(
    "# Relevant Root Key And Tool Use Selector - Code Cabinet Instantiation",
    "",
    "Date: 2026-05-20",
    "",
    "## Status",
    "",
    "CODE CABINET INSTANTIATION / POINT-OF-WORK SELECTOR SAVE.",
    "",
    "## Trigger",
    "",
    "The Living Root Words route was reattempted after the No Rule King clarification.",
    "",
    "## Task",
    "",
    "Save a narrow relevant-use selector that makes Living Root Words practical without crowning them.",
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
    "No promotion of Living Root Words to active guide.",
    "",
    "## Next Required Move After Save",
    "",
    "Use this selector on the next nontrivial Mr.Kleen move as live-use proof."
)

Write-NewCleanFile -Path $RulePath -Text (Join-TextLines -Lines $RuleLines)
Write-NewCleanFile -Path $DispositionPath -Text (Join-TextLines -Lines $DispositionLines)
Write-NewCleanFile -Path $PocketPath -Text (Join-TextLines -Lines $PocketLines)
Write-NewCleanFile -Path $TodoPath -Text (Join-TextLines -Lines $TodoLines)
Write-NewCleanFile -Path $InstantiationPath -Text (Join-TextLines -Lines $InstantiationLines)

Require-Text -Path $RulePath -Needle "Default selector size: two to five keys."
Require-Text -Path $RulePath -Needle "This selector does not crown Living Root Words."
Require-Text -Path $DispositionPath -Needle "Living Root Words stays support / operating key layer."
Require-Text -Path $PocketPath -Needle "Better-fit proof can narrow, replace, or supersede it."
Require-Text -Path $TodoPath -Needle "does not crown one rule or one tool"
Require-Text -Path $InstantiationPath -Needle "POINT-OF-WORK SELECTOR SAVE"

$StatusMarker = "2026-05-20 - Relevant Root Key And Tool Use Selector"
$StatusAppend = @(
    "---",
    "",
    "## 2026-05-20 - Relevant Root Key And Tool Use Selector",
    "",
    "Status: PASS WITH GUARDRAILS / POINT-OF-WORK SELECTOR SAVE.",
    "",
    ("Base before save: " + $HeadBefore),
    "",
    "Saved:",
    $RulePath,
    $DispositionPath,
    $PocketPath,
    $TodoPath,
    $InstantiationPath,
    $ReceiptPath,
    "",
    "Meaning:",
    "- Living Root Words stays support / operating key layer;",
    "- no root key becomes king;",
    "- no tool is used just because it exists;",
    "- before nontrivial work, select two to five relevant root keys and fitting tools;",
    "- selected keys/tools must change routing, stopping, proof, placement, or action;",
    "- better-fit proof can narrow, replace, or supersede this selector.",
    "",
    "Boundary:",
    "- no doctrine install;",
    "- no active guide rewrite;",
    "- no CURRENT_TRUTH_INDEX rewrite;",
    "- no dashboard/automation/runtime/knowledge graph/full lesson index;",
    "- no promotion of Living Root Words to active guide.",
    "",
    "Next move:",
    "- use this selector on the next nontrivial Mr.Kleen move as live-use proof."
)

Append-Once -Path $StatusPath -Marker $StatusMarker -Lines $StatusAppend

$AnchorLines = @(
    "CURRENT MR.KLEEN POSITION",
    "",
    "After Relevant Root Key And Tool Use Selector save.",
    "",
    ("Base before save: " + $HeadBefore),
    "",
    "Current ball:",
    "- Living Root Words was rechecked under No Rule King.",
    "- It stays support / operating key layer.",
    "- A narrow relevant-use selector was saved.",
    "- Before nontrivial Mr.Kleen work, select two to five relevant root keys and fitting tools.",
    "- Selected keys/tools must change routing, stopping, proof, placement, or action.",
    "- Do not recite whole lists or use tools just because they exist.",
    "",
    "Next allowed move:",
    "- Use this selector on the next nontrivial Mr.Kleen move as live-use proof.",
    "- Continue proof-ranked routing with unload map and Boss/Ghost map.",
    "",
    "Blocked moves:",
    "- Do not crown Living Root Words.",
    "- Do not crown No Rule King.",
    "- Do not crown any tool.",
    "- Do not promote this selector to active guide.",
    "- Do not rewrite doctrine.",
    "- Do not rewrite CURRENT_TRUTH_INDEX.",
    "- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index."
)

Set-Content -LiteralPath $AnchorPath -Value (Join-TextLines -Lines $AnchorLines) -Encoding UTF8
Assert-CleanTextFile -Path $AnchorPath

$ChangedForHash = @(
    $RulePath,
    $DispositionPath,
    $PocketPath,
    $TodoPath,
    $InstantiationPath,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashText -Paths $ChangedForHash

$ReceiptLines = @(
    "# Relevant Root Key And Tool Use Selector Receipt",
    "",
    "Date: 2026-05-20",
    "",
    "## Result",
    "",
    "PASS WITH GUARDRAILS / POINT-OF-WORK SELECTOR SAVE.",
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
    "## Source Checks",
    "",
    "Checked Living Root Words source:",
    "",
    "- Root words are not slogans.",
    "- Do not recite the whole list unless the task is about the list.",
    "",
    "Checked No Rule King source:",
    "",
    "- No single rule becomes absolute ruler of the house.",
    "- If it fits and works, promote through proof.",
    "",
    "## Meaning",
    "",
    "This save turns Living Root Words into a practical relevant-use selector while keeping it below doctrine and active guide authority.",
    "",
    "The selector says to choose two to five relevant root keys and only fitting tools before nontrivial work.",
    "",
    "It blocks whole-list recitation, tool-for-tool's-sake behavior, and rule monarchy.",
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
    "No promotion of Living Root Words to active guide.",
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
    "This receipt proves the point-of-work selector save.",
    "",
    "It does not prove live-use success yet.",
    "",
    "It does not promote the selector to active guide."
)

Write-NewCleanFile -Path $ReceiptPath -Text (Join-TextLines -Lines $ReceiptLines)
Require-Text -Path $ReceiptPath -Needle "PASS WITH GUARDRAILS / POINT-OF-WORK SELECTOR SAVE"
Require-Text -Path $ReceiptPath -Needle "It does not prove live-use success yet."

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Invoke-GitChecked add -- $RulePath $DispositionPath $PocketPath $TodoPath $InstantiationPath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "Nothing staged. Stop."
}

Invoke-GitChecked commit -m "Add relevant root key tool selector" | Out-Null
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
Write-Host "RELEVANT ROOT KEY TOOL SELECTOR SAVED"
Write-Host ("Commit: " + $Short)
Write-Host ("HEAD: " + $Head)
Write-Host ("origin/main: " + $Origin)
Write-Host "Status: clean"
Write-Host ("Rule: " + $RulePath)
Write-Host ("Disposition: " + $DispositionPath)
Write-Host ("Pocket list: " + $PocketPath)
Write-Host ("TODO: " + $TodoPath)
Write-Host ("Instantiation: " + $InstantiationPath)
Write-Host ("Receipt: " + $ReceiptPath)
Write-Host ("Receipt bytes: " + $ReceiptBytes)
Write-Host ("Receipt SHA256: " + $ReceiptHash)
Write-Host "Verdict: PASS WITH GUARDRAILS / POINT-OF-WORK SELECTOR SAVE"
Write-Host "Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; no promotion of Living Root Words to active guide"
Write-Host "Next move: use this selector on the next nontrivial Mr.Kleen move as live-use proof"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
