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

function Replace-Required {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Old,
        [Parameter(Mandatory = $true)][string]$New,
        [Parameter(Mandatory = $true)][string]$Label
    )
    if (-not $Text.Contains($Old)) {
        throw ("Required replacement target missing: " + $Label)
    }
    return $Text.Replace($Old, $New)
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== TODO CONTROL SURFACE STALE HEADING SAVE START ===== XxXxX"

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

$ExpectedBase = "392208c1965174d2a59252afff88cd00351cdd7d"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess.")
}

$BoardPath = "HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md"
$IndexPath = "HOUSE_WORK\TODO\TODO_INDEX_20260518.md"
$TracePath = "HOUSE_WORK\TODO\TODO_TRACE_TRIAGE_GATE_20260518.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ProofPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\TODO_CONTROL_SURFACE_STALE_HEADING_REPAIR_20260520.md"
$ReceiptPath = "PROOF_HISTORY\TODO_CONTROL_SURFACE_STALE_HEADING_REPAIR_RECEIPT_20260520.txt"

foreach ($Path in @($BoardPath,$IndexPath,$TracePath,$AnchorPath,$StatusPath)) {
    if (-not (Test-Path -LiteralPath $Path)) { throw ("Required file missing: " + $Path) }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Required file empty: " + $Path) }
}

Assert-Needle -Path $BoardPath -Needle "Authority: support only; not command authority"
Assert-Needle -Path $BoardPath -Needle "## Current Recommended Next Move"
Assert-Needle -Path $BoardPath -Needle "Next active work:"
Assert-Needle -Path $IndexPath -Needle "Authority: support only; not command authority"
Assert-Needle -Path $IndexPath -Needle "## Current Recommended Next Boss"
Assert-Needle -Path $TracePath -Needle "This gate does not override ACTIVE_ANCHOR.txt"

$Board = Get-Content -LiteralPath $BoardPath -Raw -Encoding UTF8
$Index = Get-Content -LiteralPath $IndexPath -Raw -Encoding UTF8

$Board = Replace-Required -Text $Board -Old "Authority: support only; not command authority" -New @'
Authority: support only; not command authority

Current-control note:
ACTIVE_ANCHOR.txt and the current user command select active work. Any older "current recommended" or "next active work" wording in this board is historical support unless ACTIVE_ANCHOR.txt selects it again.
'@ -Label "board authority note"

$Board = Replace-Required -Text $Board -Old "## Current Recommended Next Move" -New "## Historical Support Recommendation - Not Current Active Move" -Label "board current recommended heading"

$Board = $Board.Replace("Next recommended move:", "Historical next recommendation at time of that board entry:")
$Board = $Board.Replace("Next active work:", "Historical correction next-work note:")

$BoardNote = @'

---

## 2026-05-20 - Stale-Heading Demotion Repair

Status: NARROW WORDING REPAIR / SUPPORT SURFACE ONLY.

Reason:
This board contained old "current recommended" and "next active work" wording. That wording could misroute future starts by sounding like live command authority.

Repair:
- Added a current-control note under authority.
- Demoted "Current Recommended Next Move" to a historical support recommendation.
- Demoted "Next recommended move" and "Next active work" labels to historical wording.

Current rule:
ACTIVE_ANCHOR.txt and current user command select active work. This board ranks and preserves context only.

Boundary:
- no doctrine;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no promotion.
'@

if (-not $Board.Contains("## 2026-05-20 - Stale-Heading Demotion Repair")) {
    $Board = $Board.TrimEnd() + [Environment]::NewLine + $BoardNote + [Environment]::NewLine
}

$Index = Replace-Required -Text $Index -Old "Authority: support only; not command authority" -New @'
Authority: support only; not command authority

Current-control note:
ACTIVE_ANCHOR.txt and the current user command select active work. Any older "Current Recommended" or item-level "Next action" wording in this index is historical support unless selected again by ACTIVE_ANCHOR.txt or current user command.
'@ -Label "index authority note"

$Index = Replace-Required -Text $Index -Old "## Current Recommended Next Boss" -New "## Historical Support Recommendation - Not Current Active Boss" -Label "index current recommended heading"

$IndexNote = @'

---

## 2026-05-20 - Stale-Heading Demotion Repair

Status: NARROW WORDING REPAIR / SUPPORT INDEX ONLY.

Reason:
This index contained a "Current Recommended Next Boss" section from an older route. The section can stay as historical context, but it must not sound like current command authority.

Repair:
- Added a current-control note under authority.
- Demoted "Current Recommended Next Boss" to historical support wording.

Current rule:
ACTIVE_ANCHOR.txt and current user command select active work. This index is a sorted support map only.

Boundary:
- no doctrine;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no promotion.
'@

if (-not $Index.Contains("## 2026-05-20 - Stale-Heading Demotion Repair")) {
    $Index = $Index.TrimEnd() + [Environment]::NewLine + $IndexNote + [Environment]::NewLine
}

Write-Utf8Text -Path $BoardPath -Text $Board
Write-Utf8Text -Path $IndexPath -Text $Index

$Proof = @'
# TODO Control Surface Stale-Heading Repair

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: narrow wording repair / no promotion
Base HEAD before save: 392208c1965174d2a59252afff88cd00351cdd7d
Authority: proof/disposition only

## Rule-Firing Confirmation Card use

State:
main @ 392208c, clean by last proof.

Intended action:
repair stale/live-looking wording in TODO control surfaces.

Fired gate:
Rule-Firing Confirmation Before Action Gate.

Why it fired:
This is a nontrivial Mr.Kleen house-touching action.

Relevant keys:
- Rule-Firing Confirmation Card;
- Relevant Root Key / Tool Use Selector;
- No Rule King guard;
- TODO Trace Triage Gate;
- ACTIVE_ANCHOR owns current active route.

Blocked:
no doctrine, no active guide, no CURRENT_TRUTH_INDEX, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, no promotion, no broad TODO rewrite.

Proof needed:
narrow wording change only; old current-looking headings demoted; support authority preserved; final clean commit/push.

Disposition:
save narrow repair.

## What the read showed

TODO_CONTROL_BOARD_20260518.md already said it was support only and not command authority.

But it also contained stale/live-looking labels such as:

- Current Recommended Next Move;
- Next recommended move;
- Next active work.

TODO_INDEX_20260518.md already said it was support only and not command authority.

But it also contained:

- Current Recommended Next Boss;
- item-level Next action notes that can look active if read without anchor.

## Why repair was justified

This was not a broad rewrite.

The stale-heading issue touches entry, route selection, authority clarity, and active-work selection. The current anchor says work must be selected by ACTIVE_ANCHOR/current command, not newest-file pressure or stale support surfaces.

Leaving "current recommended" wording in old support files creates active-command fog.

## What changed

TODO Control Board:
- added a current-control note under authority;
- demoted "Current Recommended Next Move" to "Historical Support Recommendation - Not Current Active Move";
- demoted "Next recommended move" labels to historical next recommendation wording;
- demoted "Next active work" labels to historical correction next-work note wording;
- appended a narrow stale-heading demotion note.

TODO Index:
- added a current-control note under authority;
- demoted "Current Recommended Next Boss" to "Historical Support Recommendation - Not Current Active Boss";
- appended a narrow stale-heading demotion note.

## What did not change

- TODO Trace Triage Gate was read and left unchanged.
- No TODO routes were re-ranked.
- No bosses were promoted.
- No TODOs were closed.
- No doctrine was changed.
- No active guide was changed.
- No CURRENT_TRUTH_INDEX was changed.

## Verdict

PASS as narrow stale-heading repair.

The support surfaces now preserve history without pretending to be current active command surfaces.

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

Write-Utf8Text -Path $ProofPath -Text $Proof

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Current active ball after this save: Route selection under Rule-Firing Confirmation Card

## Last completed move

Saved narrow stale-heading repair for TODO control surfaces.

Files repaired:
- HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md
- HOUSE_WORK\TODO\TODO_INDEX_20260518.md

Proof:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\TODO_CONTROL_SURFACE_STALE_HEADING_REPAIR_20260520.md

Verdict:
PASS as narrow wording repair.

Meaning:
Old "current recommended" and "next active work" labels were demoted to historical support wording so they cannot compete with ACTIVE_ANCHOR.txt or current user command.

## Current control state

Rule-Firing Confirmation Card remains active before nontrivial Mr.Kleen house-touching action.

Relevant Root Key / Tool Use Selector remains support-only.

Habit / MAA lens remains support-only.

RCE / Report Gate TODO remains PASS / PARTIAL because full report gate is still open.

No Rule King remains open as guard.

Big Overall Job mule return is fully intaken/dispositioned and parked as support evidence.

TODO control board/index are support surfaces only and no longer carry live-looking current recommendation headings.

No item is promoted.

## Next allowed move

Return to route selection under the Rule-Firing Confirmation Card.

Select one route by current anchor/status and active proof need, not newest-file pressure or stale support-surface wording.

Use Habit / MAA only when repeated pattern or transfer decision appears.

Use No Rule King whenever a rule, card, selector, suit, tool, TODO, map, or mule output risks becoming king.

## Blocked moves

- Do not run another mule pass by inertia.
- Do not adopt mule output as command authority.
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

Write-Utf8Text -Path $AnchorPath -Text $Anchor

$StatusAppend = @"

---

## 2026-05-20 - TODO control surface stale-heading repair

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- $ProofPath
- updated $BoardPath
- updated $IndexPath
- updated $AnchorPath
- updated this status file

Verdict:
PASS as narrow stale-heading repair.

Meaning:
TODO control surfaces already said support-only, but old live-looking wording such as Current Recommended Next Move, Current Recommended Next Boss, and Next active work could still misroute starts. These were demoted to historical support wording without changing doctrine, active guides, CURRENT_TRUTH_INDEX, boss order, or TODO states.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, and no promotion.

Next:
Return to route selection under Rule-Firing Confirmation Card.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $BoardPath -Needle "Historical Support Recommendation - Not Current Active Move"
Assert-Needle -Path $BoardPath -Needle "Historical correction next-work note:"
Assert-Needle -Path $IndexPath -Needle "Historical Support Recommendation - Not Current Active Boss"
Assert-Needle -Path $ProofPath -Needle "PASS as narrow stale-heading repair"
Assert-Needle -Path $AnchorPath -Needle "TODO control board/index are support surfaces only"
Assert-Needle -Path $StatusPath -Needle "TODO control surface stale-heading repair"

$HashTargets = @(
    $BoardPath,
    $IndexPath,
    $ProofPath,
    $AnchorPath,
    $StatusPath
)

$HashLines = New-Object System.Collections.Generic.List[string]
foreach ($Path in $HashTargets) {
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    $HashLines.Add("- " + $Path + " | sha256=" + $Hash) | Out-Null
}

$Receipt = @"
TODO CONTROL SURFACE STALE-HEADING REPAIR RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Rule-Firing Confirmation Card used before this save:
- State: clean at 392208c.
- Intended action: repair stale/live-looking wording in TODO control surfaces.
- Fired gate: Rule-Firing Confirmation Before Action Gate.
- Why it fired: TODO surface wording repair is a nontrivial Mr.Kleen house-touching action.
- Blocked: doctrine, active guide, CURRENT_TRUTH_INDEX, dashboard, automation, runtime, knowledge graph, full lesson index, promotion, broad TODO rewrite.
- Proof needed: narrow wording change only, receipt, commit, push, final clean state.
- Disposition: save narrow repair.

Saved/updated:
- $BoardPath
- $IndexPath
- $ProofPath
- $AnchorPath
- $StatusPath

Verdict:
PASS as narrow stale-heading repair.

What changed:
- old current-looking recommendation headings were demoted to historical support wording;
- ACTIVE_ANCHOR/current user command remains active-work authority;
- TODO board/index remain support only.

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
Assert-Needle -Path $ReceiptPath -Needle "PASS as narrow stale-heading repair"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) { throw "No changes detected after writing TODO stale-heading repair package." }

Invoke-GitChecked add -- $BoardPath $IndexPath $ProofPath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) { throw "No staged files before commit." }

Invoke-GitChecked commit -m "Demote stale TODO current headings" | Out-Null
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
Write-Host "TODO CONTROL SURFACE STALE HEADING REPAIR SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $ProofPath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Updated:"
Write-Host ("- " + $BoardPath)
Write-Host ("- " + $IndexPath)
Write-Host ("- " + $AnchorPath)
Write-Host ("- " + $StatusPath)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS: stale live-looking TODO headings demoted."
Write-Host "- PASS: TODO board/index remain support-only."
Write-Host "- PASS: ACTIVE_ANCHOR/current user command remain active-work authority."
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
