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

function Write-Utf8Text {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )
    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }
    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Wrote empty file: " + $Path) }
    if ($Raw.Contains([char]0)) { throw ("NUL byte found after write: " + $Path) }
    if ($Raw.Contains([char]0xFFFD)) { throw ("Replacement character found after write: " + $Path) }
}

function Append-IfMissing {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Text
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        Write-Utf8Text -Path $Path -Text $Text
        return
    }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if (-not $Raw.Contains($Needle)) {
        Add-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    }
}

function Assert-Needle {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle
    )
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if (-not $Raw.Contains($Needle)) {
        throw ("Verification needle missing in " + $Path + ": " + $Needle)
    }
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== RELEVANT ROOT KEY SELECTOR VARIED PROOF SAVE START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$BaseHead = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$BaseShort = Get-GitLine rev-parse --short HEAD
$Status = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") { throw ("Wrong branch: " + $Branch) }
if ($BaseHead -ne $Origin) { throw "HEAD does not match origin/main. Stop before save." }
if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Repo is dirty. Stop before save."
}

$ExpectedBase = "d872fd0a2abe3c98924f85d54e926208c79df7cd"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess.")
}

$SelectorTodoPath = "HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md"
$NoRuleKingTodoPath = "HOUSE_WORK\TODO\NO_RULE_KING_BETTER_FIT_PROMOTION_LIVE_USE_TODO_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$RcePath = "HOUSE_WORK\WORK_SHED\RELATION_MAPS\RULE_CONCEPT_EVENT_LINK_MAP_SEED_20260520.md"
$CardPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\RULE_FIRING_CONFIRMATION_CARD_20260520.md"
$GatePath = "BRAIN_LEARNING\RULE_FIRING_CONFIRMATION_BEFORE_ACTION_GATE_20260520.md"

foreach ($Path in @($SelectorTodoPath,$NoRuleKingTodoPath,$AnchorPath,$StatusPath,$RcePath,$CardPath,$GatePath)) {
    if (-not (Test-Path -LiteralPath $Path)) { throw ("Required file missing: " + $Path) }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Required file empty: " + $Path) }
}

Assert-Needle -Path $SelectorTodoPath -Needle "uses only relevant root keys and tools"
Assert-Needle -Path $SelectorTodoPath -Needle "Live Use 001 - TODO Triage Read"
Assert-Needle -Path $NoRuleKingTodoPath -Needle "cooperative family rather than a monarchy"
Assert-Needle -Path $AnchorPath -Needle "Route selection under Rule-Firing Confirmation Card"
Assert-Needle -Path $GatePath -Needle "Before any nontrivial Mr.Kleen house-touching action"

$ProofPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\RELEVANT_ROOT_KEY_SELECTOR_VARIED_LIVE_USE_PROOF_20260520.md"
$NoRuleKingProofPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\NO_RULE_KING_GUARD_DURING_SELECTOR_ROUTE_PROOF_20260520.md"
$ReceiptPath = "PROOF_HISTORY\RELEVANT_ROOT_KEY_SELECTOR_VARIED_LIVE_USE_RECEIPT_20260520.txt"

$Proof = @'
# Relevant Root Key / Tool Selector - Varied Live Use Proof

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: varied live-use proof / no promotion
Base HEAD before save: d872fd0a2abe3c98924f85d54e926208c79df7cd
Authority: proof/disposition only

## What happened

After RCE / Report Gate partial proof, the current anchor said to return to route selection under the Rule-Firing Confirmation Card.

The assistant selected:

HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md

Reason:
The active problem was route selection without newest-file pressure, support-rule pressure, or crowning one tool/rule.

The read also included:

HOUSE_WORK\TODO\NO_RULE_KING_BETTER_FIT_PROMOTION_LIVE_USE_TODO_20260520.md

Reason:
A selector can become a hidden king if it starts commanding action instead of serving fit.

## Card use before action

State:
main @ d872fd0, clean by last proof.

Intended action:
use the card to select the next route, then read the most relevant selector seam.

Fired gate:
Rule-Firing Confirmation Before Action Gate.

Why it fired:
current anchor said to return to route selection under the card.

Selected relevant keys:
- Rule-Firing Confirmation Card;
- Relevant Root Key / Tool Use Selector;
- No Rule King guard.

Held / not active:
- Habit / MAA lens unless repeated pattern or transfer decision appears;
- RCE/report gate, because it is now PASS/PARTIAL and not the next active route.

Selected tool:
Direct PowerShell read only.

Blocked:
no save yet, no promotion, no doctrine, no active guide, no CURRENT_TRUTH_INDEX, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index.

Disposition:
read-only selector inspection.

## Result

PASS as varied live use.

The selector:
- named control state;
- selected only the relevant keys;
- selected only the relevant tool;
- explained allow/block briefly;
- stayed inside boundary;
- avoided newest-file pressure;
- avoided crowning one rule or tool;
- read the selected TODOs and status evidence.

## What this proves

This proves a second, varied use of the selector beyond the earlier TODO triage read.

This does not promote the selector.

This does not close the TODO.

This does not make the selector a command authority.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No promotion.
'@

$NoRuleKingProof = @'
# No Rule King Guard During Selector Route - Partial Live Use Proof

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: partial guard proof / TODO remains open
Parent: Rule Activation / Work-Order Control
Authority: proof/disposition only

## Trigger

The next route selected the Relevant Root Key / Tool Use Selector.

That creates a risk:
the selector itself could become king if it starts commanding action instead of serving fit.

## Check

Before saving any proof or taking action, the route read also inspected:

HOUSE_WORK\TODO\NO_RULE_KING_BETTER_FIT_PROMOTION_LIVE_USE_TODO_20260520.md

## Result

PASS / PARTIAL.

Passed:
- the selector was treated as a support tool, not authority;
- the card stayed the active gate before action;
- no rule, tool, suit, TODO, or map was promoted;
- the action stayed read-only.

Still open:
- no better-fit item was adopted, adapted, parked, blocked, or superseded in this event;
- therefore the full No Rule King / Better-Fit TODO remains open.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard, automation, runtime, knowledge graph, or full lesson index.

No promotion from this guard proof.
'@

$SelectorTodoAppend = @'

---

## Live Use 002 - Route Selection Under Confirmation Card

Status: PASS / varied live use.

Proof:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\RELEVANT_ROOT_KEY_SELECTOR_VARIED_LIVE_USE_PROOF_20260520.md

Selected keys:
- Rule-Firing Confirmation Card;
- Relevant Root Key / Tool Use Selector;
- No Rule King guard.

Held:
- Habit / MAA lens unless repeated pattern or transfer decision appears.
- RCE/report gate because it is PASS/PARTIAL and not current active route.

Selected tool:
- Direct PowerShell read only.

Result:
- selector fired before route action;
- newest-file pressure was blocked;
- support-rule pressure was blocked;
- only relevant TODOs were read;
- No Rule King guard was included to prevent selector monarchy.

Guardrail:
- TODO remains open.
- No promotion from second proof.
'@

$NoRuleKingTodoAppend = @'

---

## Guard Use 001 - Selector Route Did Not Become King

Status: PASS / PARTIAL.

Proof:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\NO_RULE_KING_GUARD_DURING_SELECTOR_ROUTE_PROOF_20260520.md

Trigger:
The Relevant Root Key / Tool Use Selector was selected as a route, which could have made the selector itself into a hidden king.

Result:
- selector stayed support-only;
- card remained point-of-work gate;
- route stayed read-only;
- no item was promoted.

Still open:
No better-fit item was adopted, adapted, parked, blocked, or superseded in this event.
'@

$RceAppend = @'

## Entry 16 - Relevant Root Key Selector Varied Live Use

Rule:
Before route work, select only the relevant root keys and tools instead of reciting or crowning the whole stack.

Concept:
Relevant root key selection; tool fit; anti-newest-file pressure; support rule not authority.

Event:
After RCE / Report Gate partial proof, the assistant selected the Relevant Root Key / Tool Use Selector route under the Rule-Firing Confirmation Card and read only the selector TODO, No Rule King TODO, and status tail.

Trigger phrases:
route selection; relevant keys; tool selector; newest-file pressure; support-rule pressure; no random moves.

Proof state:
Second varied live-use proof saved. No promotion.

Boundary:
Support selector only; not doctrine, not active guide, not automation.

## Entry 17 - No Rule King Guard During Selector Route

Rule:
A selector, card, TODO, map, mule output, or support lens must not become king merely because it is useful.

Concept:
No Rule King; better fit; neighbor rules; support hierarchy control.

Event:
During route selection, the assistant read No Rule King alongside the selector because the selector itself could become a hidden authority if not checked.

Trigger phrases:
no rule king; selector becoming king; support pressure; better fit; do not crown.

Proof state:
Partial guard proof saved. Full No Rule King TODO remains open.

Boundary:
No promotion, no doctrine, no active guide.
'@

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Current active ball after this save: Route selection under Rule-Firing Confirmation Card

## Last completed move

Saved varied live-use proof for:

- Relevant Root Key / Tool Use Selector;
- No Rule King guard during selector route.

Verdict:
- Relevant Root Key Selector: PASS as varied live use.
- No Rule King: PASS / PARTIAL as guard proof.

## Current control state

Rule-Firing Confirmation Card has live-use proof and remains active before nontrivial Mr.Kleen house-touching action.

Relevant Root Key / Tool Use Selector has varied proof and remains support-only.

Habit / MAA lens has live-use proof and remains support-only.

RCE / Report Gate TODO has partial proof and remains open.

No Rule King has partial guard proof and remains open.

No item is promoted.

## Next allowed move

Return to route selection under the Rule-Firing Confirmation Card.

Select one route by current anchor/status and active proof need, not newest-file pressure.

Use Habit / MAA only when repeated pattern or transfer decision appears.

Use No Rule King whenever a rule, card, selector, suit, tool, TODO, map, or mule output risks becoming king.

## Blocked moves

- Do not promote the selector from varied proof.
- Do not promote No Rule King from partial proof.
- Do not promote RCE map/report gate from partial proof.
- Do not promote the card from limited proof.
- Do not promote Habit/MAA from limited proof.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
'@

Write-Utf8Text -Path $ProofPath -Text $Proof
Write-Utf8Text -Path $NoRuleKingProofPath -Text $NoRuleKingProof
Append-IfMissing -Path $SelectorTodoPath -Needle "Live Use 002 - Route Selection Under Confirmation Card" -Text $SelectorTodoAppend
Append-IfMissing -Path $NoRuleKingTodoPath -Needle "Guard Use 001 - Selector Route Did Not Become King" -Text $NoRuleKingTodoAppend
Append-IfMissing -Path $RcePath -Needle "Entry 16 - Relevant Root Key Selector Varied Live Use" -Text $RceAppend
Write-Utf8Text -Path $AnchorPath -Text $Anchor

$StatusAppend = @"

---

## 2026-05-20 - Relevant Root Key Selector varied live use

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- $ProofPath
- $NoRuleKingProofPath
- updated $SelectorTodoPath
- updated $NoRuleKingTodoPath
- appended entries to $RcePath
- updated $AnchorPath
- updated this status file

Verdict:
- Relevant Root Key Selector: PASS as varied live use.
- No Rule King: PASS / PARTIAL guard proof.

Meaning:
Route selection used only the relevant keys/tools, blocked newest-file pressure, kept the selector support-only, and read No Rule King to prevent selector monarchy.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, and no promotion.

Next:
Return to route selection under Rule-Firing Confirmation Card.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $ProofPath -Needle "PASS as varied live use"
Assert-Needle -Path $NoRuleKingProofPath -Needle "PASS / PARTIAL"
Assert-Needle -Path $SelectorTodoPath -Needle "Live Use 002 - Route Selection Under Confirmation Card"
Assert-Needle -Path $NoRuleKingTodoPath -Needle "Guard Use 001 - Selector Route Did Not Become King"
Assert-Needle -Path $RcePath -Needle "Entry 16 - Relevant Root Key Selector Varied Live Use"
Assert-Needle -Path $AnchorPath -Needle "Relevant Root Key / Tool Use Selector has varied proof"

$HashTargets = @(
    $ProofPath,
    $NoRuleKingProofPath,
    $SelectorTodoPath,
    $NoRuleKingTodoPath,
    $RcePath,
    $AnchorPath,
    $StatusPath
)

$HashLines = New-Object System.Collections.Generic.List[string]
foreach ($Path in $HashTargets) {
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    $HashLines.Add("- " + $Path + " | sha256=" + $Hash) | Out-Null
}

$Receipt = @"
RELEVANT ROOT KEY SELECTOR VARIED LIVE USE RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Rule-Firing Confirmation Card used before this save:
- State: clean at d872fd0.
- Intended action: save varied live-use proof for Relevant Root Key Selector and No Rule King guard.
- Fired gate: Rule-Firing Confirmation Before Action Gate.
- Why it fired: this is a nontrivial Mr.Kleen house-touching action.
- Blocked: doctrine, active guide, CURRENT_TRUTH_INDEX, dashboard, automation, runtime, knowledge graph, full lesson index, promotion.
- Proof needed: files written, receipt, commit, push, final clean state.
- Disposition: save claim-scoped proof.

Saved:
- $ProofPath
- $NoRuleKingProofPath
- $SelectorTodoPath
- $NoRuleKingTodoPath
- $RcePath
- $AnchorPath
- $StatusPath

Verdict:
- PASS: Relevant Root Key Selector varied live use.
- PASS / PARTIAL: No Rule King guard during selector route.
- GUARDRAIL: no promotion.

Hashes:
$($HashLines -join [Environment]::NewLine)

Boundary held:
- no doctrine rewrite;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no promotion.

Next move:
Return to route selection under Rule-Firing Confirmation Card.
"@

Write-Utf8Text -Path $ReceiptPath -Text $Receipt
Assert-Needle -Path $ReceiptPath -Needle "Relevant Root Key Selector varied live use"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) { throw "No changes detected after writing selector proof package." }

Invoke-GitChecked add -- $ProofPath $NoRuleKingProofPath $SelectorTodoPath $NoRuleKingTodoPath $RcePath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) { throw "No staged files before commit." }

Invoke-GitChecked commit -m "Record relevant selector varied live use" | Out-Null
Invoke-GitChecked push origin main | Out-Null
Invoke-GitChecked fetch origin main | Out-Null

$FinalHead = Get-GitLine rev-parse HEAD
$FinalOrigin = Get-GitLine rev-parse origin/main
$FinalShort = Get-GitLine rev-parse --short HEAD
$FinalStatus = @(Invoke-GitChecked status --short)

if ($FinalHead -ne $FinalOrigin) { throw "Final proof failed: HEAD does not match origin/main." }
if ($FinalStatus.Count -ne 0) {
    Write-Host "Final dirty status:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final proof failed: status not clean."
}

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "RELEVANT ROOT KEY SELECTOR VARIED LIVE USE SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $ProofPath)
Write-Host ("- " + $NoRuleKingProofPath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Updated:"
Write-Host ("- " + $SelectorTodoPath)
Write-Host ("- " + $NoRuleKingTodoPath)
Write-Host ("- " + $RcePath)
Write-Host ("- " + $AnchorPath)
Write-Host ("- " + $StatusPath)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS: Relevant Root Key Selector varied live use."
Write-Host "- PASS / PARTIAL: No Rule King guard during selector route."
Write-Host "- PASS: selector stayed support-only."
Write-Host "- PASS: no promotion."
Write-Host ""
Write-Host "Boundary:"
Write-Host "- No doctrine rewrite."
Write-Host "- No active guide rewrite."
Write-Host "- No CURRENT_TRUTH_INDEX rewrite."
Write-Host "- No dashboard, automation, runtime, knowledge graph, or full lesson index."
Write-Host "- No promotion."
Write-Host ""
Write-Host "Next move:"
Write-Host "- Return to route selection under Rule-Firing Confirmation Card."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
