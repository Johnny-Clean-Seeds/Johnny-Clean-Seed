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

function Write-CleanFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )

    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    Assert-CleanTextFile -Path $Path
}

function Write-NewOnlyFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )

    if (Test-Path -LiteralPath $Path) {
        throw ("Target already exists. Stop before overwrite: " + $Path)
    }

    Write-CleanFile -Path $Path -Text $Text
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

function Normalize-GitStatusLine {
    param([string]$Line)
    return (($Line.Trim()) -replace "\\","/")
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home."
}

Write-Host "XxXxX ===== RELEVANT ROOT KEY SELECTOR FIRST LIVE USE RECOVERY START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$HeadBefore = Get-GitLine rev-parse HEAD
$OriginBefore = Get-GitLine rev-parse origin/main
$StatusBeforeRaw = @(Invoke-GitChecked status --short)
$StatusBefore = @($StatusBeforeRaw | ForEach-Object { Normalize-GitStatusLine -Line ([string]$_) })

if ($Branch -ne "main") {
    throw ("Wrong branch: " + $Branch)
}

if ($HeadBefore -ne $OriginBefore) {
    throw "HEAD does not match origin/main. Stop before recovery."
}

$LiveUsePath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RELEVANT_ROOT_KEY_SELECTOR_FIRST_LIVE_USE_TODO_TRIAGE_20260520.md"
$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\RELEVANT_ROOT_KEY_SELECTOR_FIRST_LIVE_USE_INSTANTIATION_20260520.md"

$AllowedDirty = @(
    "?? HOUSE_WORK/WORK_SHED/SORTING_BENCH/RELEVANT_ROOT_KEY_SELECTOR_FIRST_LIVE_USE_TODO_TRIAGE_20260520.md",
    "?? HOUSE_WORK/WORK_SHED/GEAR_RACK/CODE_CABINET/RELEVANT_ROOT_KEY_SELECTOR_FIRST_LIVE_USE_INSTANTIATION_20260520.md"
)

$UnexpectedDirty = @()
foreach ($Line in $StatusBefore) {
    if (-not ($AllowedDirty -contains $Line)) {
        $UnexpectedDirty += $Line
    }
}

if ($UnexpectedDirty.Count -gt 0) {
    Write-Host "Unexpected dirty status:"
    $UnexpectedDirty | ForEach-Object { Write-Host $_ }
    throw "Recovery blocked: dirty status includes paths outside expected two untracked files."
}

$SelectorRulePath = "BRAIN_LEARNING\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_RULE_20260520.md"
$SelectorTodoPath = "HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md"
$PocketPath = "HOUSE_WORK\WORK_SHED\IDEA_BAG\RELEVANT_ROOT_KEY_AND_TOOL_USE_POCKET_LIST_20260520.md"
$BossGhostMapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ReceiptPath = "PROOF_HISTORY\RELEVANT_ROOT_KEY_SELECTOR_FIRST_LIVE_USE_RECEIPT_20260520.txt"

$RequiredInputs = @(
    $SelectorRulePath,
    $SelectorTodoPath,
    $PocketPath,
    $BossGhostMapPath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

Require-Text -Path $SelectorRulePath -Needle "Default selector size: two to five keys."
Require-Text -Path $SelectorTodoPath -Needle "does not crown one rule or one tool"
Require-Text -Path $BossGhostMapPath -Needle "The current weakest link remains under Parent Boss A:"
Require-Text -Path $AnchorPath -Needle "Use this selector on the next nontrivial Mr.Kleen move as live-use proof."

if (Test-Path -LiteralPath $ReceiptPath) {
    throw ("Receipt already exists. Stop before overwrite: " + $ReceiptPath)
}

$LiveUseLines = @(
    "# Relevant Root Key Selector First Live Use - TODO Triage",
    "",
    "Date: 2026-05-20",
    "",
    "## Status",
    "",
    "PASS WITH GUARDRAILS / FIRST LIVE USE.",
    "",
    "## Recovery Note",
    "",
    "The first save script stopped before commit because a verification needle expected a single backslash path while the generated file contained a doubled backslash path.",
    "",
    "Recovery checked dirty status and allowed only the two expected untracked target files before continuing.",
    "",
    "## Control State",
    "",
    "Current clean point before recovery save: " + $HeadBefore,
    "",
    "The active instruction was next after the Relevant Root Key And Tool Use Selector save.",
    "",
    "The anchor required using the selector on the next nontrivial Mr.Kleen move as live-use proof.",
    "",
    "## Selected Root Keys",
    "",
    "Selected keys:",
    "",
    "1. Control state first.",
    "2. Boss first, ghosts under it.",
    "3. Use the tools that fit.",
    "4. No random moves.",
    "",
    "These four keys were enough. The whole root list was not recited.",
    "",
    "## Selected Tool",
    "",
    "Direct PowerShell read only.",
    "",
    "Reason:",
    "",
    "The task needed current repo state, current anchor, selector TODO, Boss/Ghost map, and open TODO order.",
    "",
    "A save script was not needed before reading.",
    "",
    "No web, dashboard, automation, mule, or broad artifact generation was needed.",
    "",
    "## What The Keys Allowed",
    "",
    "- Control state first allowed checking the current anchor before action.",
    "- Boss first, ghosts under it allowed the TODO room to be read through parent-boss grouping instead of flat order.",
    "- Use the tools that fit allowed a direct PowerShell read rather than a save script or broad scan.",
    "- No random moves blocked hand-picking the newest TODO or highest visible item by pile-order.",
    "",
    "## What The Keys Blocked",
    "",
    "- no promotion of the selector;",
    "- no promotion of Living Root Words;",
    "- no doctrine rewrite;",
    "- no active guide rewrite;",
    "- no CURRENT_TRUTH_INDEX rewrite;",
    "- no dashboard, automation, runtime, knowledge graph, or full lesson index;",
    "- no whole-list root key recitation;",
    "- no tool use just because a tool exists.",
    "",
    "## Read Result",
    "",
    "The read confirmed:",
    "",
    "- the anchor says Relevant Root Key And Tool Use Selector is the current ball;",
    "- the selector TODO requires live-use proof where the assistant names control state, selects relevant keys/tools, acts inside boundary, and does not crown a rule/tool;",
    "- the Boss/Ghost map says the current weakest link remains under Parent Boss A: Rule Activation / Work-Order Control;",
    "- the map says Boss/Ghost sorting must become the TODO-room method at point of use;",
    "- open TODO order includes the selector live-use TODO, No Rule King TODO, Compose-Review, Artifact Self-Check, TODO control board, Boss/Ghost Rule-Firing Cycle Flow, and PowerShell Command Safety.",
    "",
    "## Verdict",
    "",
    "PASS WITH GUARDRAILS as first live use.",
    "",
    "The selector fired before action, narrowed root keys, selected a fitting tool, stayed inside boundary, and produced a next-route read.",
    "",
    "Guardrail:",
    "",
    "This does not close the selector live-use TODO.",
    "",
    "It proves one live-use instance only.",
    "",
    "## Next Route",
    "",
    "Next proof-ranked route remains Parent Boss A.",
    "",
    "Specific next read target:",
    "",
    "HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md",
    "",
    "Reason:",
    "",
    "The Boss/Ghost map says the current weakest link remains Rule Activation / Work-Order Control and that Boss/Ghost sorting must become the TODO-room method at point of use.",
    "",
    "The next move should inspect that TODO before saving a repair.",
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
    "No closure or promotion from this first live use."
)

$InstantiationLines = @(
    "# Relevant Root Key Selector First Live Use - Code Cabinet Instantiation",
    "",
    "Date: 2026-05-20",
    "",
    "## Status",
    "",
    "CODE CABINET INSTANTIATION / FIRST LIVE USE RECOVERY SAVE.",
    "",
    "## Trigger",
    "",
    "The first live-use save stopped before commit on a path verification mismatch.",
    "",
    "## Recovery Gate",
    "",
    "Recovery allowed only two expected untracked target files before continuing.",
    "",
    "## Task",
    "",
    "Save first live-use proof for the Relevant Root Key And Tool Use Selector.",
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
    "No closure or promotion from this first live use.",
    "",
    "## Next Required Move After Save",
    "",
    "Read BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md before any repair."
)

Write-CleanFile -Path $LiveUsePath -Text (Join-TextLines -Lines $LiveUseLines)
Write-CleanFile -Path $InstantiationPath -Text (Join-TextLines -Lines $InstantiationLines)

Require-Text -Path $LiveUsePath -Needle "PASS WITH GUARDRAILS / FIRST LIVE USE."
Require-Text -Path $LiveUsePath -Needle "These four keys were enough. The whole root list was not recited."
Require-Text -Path $LiveUsePath -Needle "HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md"
Require-Text -Path $InstantiationPath -Needle "FIRST LIVE USE RECOVERY SAVE"

$TodoAppendMarker = "Live Use 001 - TODO Triage Read"
$TodoAppendLines = @(
    "---",
    "",
    "## Live Use 001 - TODO Triage Read",
    "",
    "Status: PASS WITH GUARDRAILS / first live use.",
    "",
    "Selected keys:",
    "- Control state first.",
    "- Boss first, ghosts under it.",
    "- Use the tools that fit.",
    "- No random moves.",
    "",
    "Selected tool:",
    "- Direct PowerShell read only.",
    "",
    "Recovery note:",
    "- First save attempt stopped before commit on a generated path verification mismatch.",
    "- Recovery continued only after dirty status showed no unexpected dirty paths.",
    "",
    "Result:",
    "- selector fired before action;",
    "- root keys were narrowed instead of recited as a whole list;",
    "- direct read was used instead of broad tool use;",
    "- Boss/Ghost map selected Parent Boss A as remaining route;",
    "- next read target: HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md.",
    "",
    "Guardrail:",
    "- TODO remains open for more varied live use."
)

Append-Once -Path $SelectorTodoPath -Marker $TodoAppendMarker -Lines $TodoAppendLines

$StatusMarker = "2026-05-20 - Relevant Root Key Selector First Live Use"
$StatusAppendLines = @(
    "---",
    "",
    "## 2026-05-20 - Relevant Root Key Selector First Live Use",
    "",
    "Status: PASS WITH GUARDRAILS / FIRST LIVE USE / RECOVERED SAVE.",
    "",
    ("Base before save: " + $HeadBefore),
    "",
    "Saved:",
    $LiveUsePath,
    $InstantiationPath,
    $ReceiptPath,
    "",
    "Updated:",
    $SelectorTodoPath,
    $AnchorPath,
    $StatusPath,
    "",
    "Meaning:",
    "- selector fired before action;",
    "- selected four relevant root keys instead of reciting the whole list;",
    "- selected direct PowerShell read only as fitting tool;",
    "- acted inside boundary;",
    "- Boss/Ghost map selected Parent Boss A as remaining route;",
    "- next read target is BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md.",
    "",
    "Recovery:",
    "- first save attempt stopped before commit due to path verification mismatch;",
    "- recovery allowed only expected dirty target files before continuing.",
    "",
    "Boundary:",
    "- no doctrine install;",
    "- no active guide rewrite;",
    "- no CURRENT_TRUTH_INDEX rewrite;",
    "- no dashboard/automation/runtime/knowledge graph/full lesson index;",
    "- no closure or promotion from this first live use.",
    "",
    "Next move:",
    "- read HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md before repair."
)

Append-Once -Path $StatusPath -Marker $StatusMarker -Lines $StatusAppendLines

$AnchorLines = @(
    "CURRENT MR.KLEEN POSITION",
    "",
    "After Relevant Root Key Selector First Live Use.",
    "",
    ("Base before save: " + $HeadBefore),
    "",
    "Current ball:",
    "- Relevant Root Key And Tool Use Selector has first live-use proof.",
    "- Recovery was required because the first save attempt stopped before commit on a path verification mismatch.",
    "- Dirty-state recovery allowed only expected target files before continuing.",
    "- The live use selected four keys: Control state first, Boss first ghosts under it, Use the tools that fit, No random moves.",
    "- Tool choice was direct PowerShell read only.",
    "- Boss/Ghost map selected Parent Boss A as the remaining route.",
    "- Selector TODO remains open for more varied live use.",
    "",
    "Next allowed move:",
    "- Read HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md before repair.",
    "- Keep using selector: pick only relevant keys/tools.",
    "",
    "Blocked moves:",
    "- Do not close selector TODO from one live use.",
    "- Do not promote selector or Living Root Words.",
    "- Do not hand-pick TODOs by newest file order.",
    "- Do not rewrite doctrine.",
    "- Do not rewrite active guides.",
    "- Do not rewrite CURRENT_TRUTH_INDEX.",
    "- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index."
)

Set-Content -LiteralPath $AnchorPath -Value (Join-TextLines -Lines $AnchorLines) -Encoding UTF8
Assert-CleanTextFile -Path $AnchorPath

$ChangedForHash = @(
    $LiveUsePath,
    $InstantiationPath,
    $SelectorTodoPath,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashText -Paths $ChangedForHash

$ReceiptLines = @(
    "# Relevant Root Key Selector First Live Use Receipt",
    "",
    "Date: 2026-05-20",
    "",
    "## Result",
    "",
    "PASS WITH GUARDRAILS / FIRST LIVE USE / RECOVERED SAVE.",
    "",
    "## Base Before Save",
    "",
    ("Branch: " + $Branch),
    ("HEAD before save: " + $HeadBefore),
    ("origin/main before save: " + $OriginBefore),
    "",
    "## Recovery Gate",
    "",
    "The first save script stopped before commit because generated text used a doubled backslash path while the verification needle used a single backslash path.",
    "",
    "Recovery checked dirty status before continuing.",
    "",
    "Allowed dirty paths:",
    "",
    "- HOUSE_WORK/WORK_SHED/SORTING_BENCH/RELEVANT_ROOT_KEY_SELECTOR_FIRST_LIVE_USE_TODO_TRIAGE_20260520.md",
    "- HOUSE_WORK/WORK_SHED/GEAR_RACK/CODE_CABINET/RELEVANT_ROOT_KEY_SELECTOR_FIRST_LIVE_USE_INSTANTIATION_20260520.md",
    "",
    "No other dirty paths were allowed.",
    "",
    "## Files",
    "",
    $HashList,
    "",
    "## Claim Proven",
    "",
    "This receipt proves one live-use instance of the Relevant Root Key And Tool Use Selector.",
    "",
    "The assistant selected relevant keys, selected direct PowerShell read only as fitting tool, acted inside boundary, and used Boss/Ghost map to select the next route.",
    "",
    "## Proof Limit",
    "",
    "This does not close the selector TODO.",
    "",
    "This does not promote the selector.",
    "",
    "This does not promote Living Root Words.",
    "",
    "This does not repair the Boss/Ghost Rule-Firing Cycle Flow TODO yet.",
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
    "No closure or promotion from this first live use.",
    "",
    "## Final Check Required",
    "",
    "Commit, push, fetch, HEAD equals origin/main, and status clean."
)

Write-NewOnlyFile -Path $ReceiptPath -Text (Join-TextLines -Lines $ReceiptLines)
Require-Text -Path $ReceiptPath -Needle "PASS WITH GUARDRAILS / FIRST LIVE USE / RECOVERED SAVE."
Require-Text -Path $ReceiptPath -Needle "This does not close the selector TODO."

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Invoke-GitChecked add -- $LiveUsePath $InstantiationPath $SelectorTodoPath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "Nothing staged. Stop."
}

Invoke-GitChecked commit -m "Record root selector first live use" | Out-Null
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
Write-Host "RELEVANT ROOT KEY SELECTOR FIRST LIVE USE RECOVERY SAVED"
Write-Host ("Commit: " + $Short)
Write-Host ("HEAD: " + $Head)
Write-Host ("origin/main: " + $Origin)
Write-Host "Status: clean"
Write-Host ("Live use: " + $LiveUsePath)
Write-Host ("Instantiation: " + $InstantiationPath)
Write-Host ("Updated TODO: " + $SelectorTodoPath)
Write-Host ("Receipt: " + $ReceiptPath)
Write-Host ("Receipt bytes: " + $ReceiptBytes)
Write-Host ("Receipt SHA256: " + $ReceiptHash)
Write-Host "Verdict: PASS WITH GUARDRAILS / FIRST LIVE USE / RECOVERED SAVE"
Write-Host "Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; no closure or promotion from this first live use"
Write-Host "Next move: read HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md before repair"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
