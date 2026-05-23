$ErrorActionPreference = "Stop"

function Run-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)

    $Output = @(& git @Args 2>&1)
    if ($LASTEXITCODE -ne 0) {
        $Output | ForEach-Object { Write-Host $_ }
        throw "Git failed: git $($Args -join ' ')"
    }
    return $Output
}

function Git-Line {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)

    $Output = @(Run-Git @Args)
    if ($Output.Count -lt 1) {
        throw "Git returned no output: git $($Args -join ' ')"
    }

    return (([string]($Output | Select-Object -First 1))).Trim()
}

function Assert-CleanTextFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Missing required file: $Path"
    }

    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8

    if ([string]::IsNullOrWhiteSpace($Raw)) {
        throw "File is empty: $Path"
    }

    if ($Raw.Contains([char]0)) {
        throw "NUL byte found: $Path"
    }

    if ($Raw.Contains([char]0xFFFD)) {
        throw "Replacement character found: $Path"
    }

    foreach ($Bad in @("[PLACEHOLDER]", "TODO: fill", "lorem ipsum")) {
        if ($Raw.Contains($Bad)) {
            throw "Bad placeholder marker found in file: $Path"
        }
    }
}

function Write-NewCleanFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )

    if (Test-Path $Path) {
        throw "Target already exists. Stop before overwrite: $Path"
    }

    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    Assert-CleanTextFile -Path $Path
}

function Append-Once {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Marker,
        [Parameter(Mandatory = $true)][string]$Text
    )

    Assert-CleanTextFile -Path $Path

    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($Raw -match [regex]::Escape($Marker)) {
        throw "Append marker already exists. Stop to avoid duplicate: $Path / $Marker"
    }

    $NewText = $Raw.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $Text
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
        throw "Required text missing from $Path : $Needle"
    }
}

function Get-HashTableText {
    param([Parameter(Mandatory = $true)][string[]]$Paths)

    $Rows = @()

    foreach ($Path in $Paths) {
        Assert-CleanTextFile -Path $Path
        $Rows += [pscustomobject]@{
            Path = $Path
            Bytes = (Get-Item -LiteralPath $Path).Length
            SHA256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        }
    }

    return (($Rows | ForEach-Object {
        "- $($_.Path) | bytes=$($_.Bytes) | sha256=$($_.SHA256)"
    }) -join [Environment]::NewLine)
}

if (-not (Test-Path ".git")) {
    throw "Not inside Mr.Kleen repo home."
}

Write-Host "XxXxX ===== TODO WEAKEST LINK SELECTION REPAIR START ===== XxXxX"

Run-Git fetch origin main | Out-Null

$Branch = Git-Line branch --show-current
$HeadBefore = Git-Line rev-parse HEAD
$OriginBefore = Git-Line rev-parse origin/main
$StatusBefore = @(Run-Git status --short)

if ($Branch -ne "main") {
    throw "Wrong branch: $Branch"
}

if ($HeadBefore -ne $OriginBefore) {
    throw "HEAD does not match origin/main. Stop before save."
}

if ($StatusBefore.Count -ne 0) {
    Write-Host "Dirty status before save:"
    $StatusBefore | ForEach-Object { Write-Host $_ }
    throw "Mr.Kleen is not clean. Stop before save."
}

$SkeletonPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\MR_KLEEN_SAVE_PACKAGE_SKELETON_20260520.md"
$ExistingRulePath = "BRAIN_LEARNING\TODO_FIRST_WORK_CONTROL_RULE_20260520.md"
$NewRulePath = "BRAIN_LEARNING\TODO_PROOF_RANKED_WEAKEST_LINK_SELECTION_RULE_20260520.md"
$DissectionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\TODO_PICK_LANGUAGE_MUD_CORRECTION_20260520.md"
$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\TODO_WEAKEST_LINK_SELECTION_REPAIR_INSTANTIATION_20260520.md"
$TodoControlBoard = "HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ReceiptPath = "PROOF_HISTORY\TODO_WEAKEST_LINK_SELECTION_REPAIR_RECEIPT_20260520.txt"
$TodoRoot = "HOUSE_WORK\TODO"

$RequiredInputs = @(
    $SkeletonPath,
    $ExistingRulePath,
    $TodoControlBoard,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

foreach ($Target in @($NewRulePath, $DissectionPath, $InstantiationPath, $ReceiptPath)) {
    if (Test-Path $Target) {
        throw "Target already exists. Stop before overwrite: $Target"
    }
}

$TodoFiles = @(Get-ChildItem -Path $TodoRoot -File -Recurse | Sort-Object LastWriteTime -Descending)
if ($TodoFiles.Count -lt 1) {
    throw "No TODO files found. Stop: weakest-link selection needs TODO evidence."
}

$TodoSnapshot = (($TodoFiles | Select-Object -First 30 | ForEach-Object {
    $Rel = $_.FullName.Replace((Get-Location).Path + "\", "")
    "- $Rel | bytes=$($_.Length) | modified=$($_.LastWriteTime)"
}) -join [Environment]::NewLine)

$Instantiation = @"
# TODO Weakest-Link Selection Repair - Code Cabinet Instantiation

Date: 2026-05-20

## Status

CODE CABINET INSTANTIATION / SELECTION-METHOD REPAIR.

## Skeleton Used

$SkeletonPath

## Trigger

The prior rule repair said the next move was to pick one actionable TODO.

The user corrected the wording and method:

The assistant should not hand-pick from a TODO list.

The list/proof must choose by biggest issue / weakest link.

## Task

Save a selection-method rule for TODO triage.

Patch the existing TODO First Work Control rule so selection is evidence-derived, not preference-derived.

Update the TODO control board, anchor, and status.

## Current TODO Evidence

$TodoSnapshot

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No new TODO pile expansion as substitute for working TODOs.

## Next Required Move After Save

Run TODO board triage using proof-ranked weakest-link selection.

The output should identify:

- parent boss groups;
- child TODOs under each parent;
- biggest issue / weakest link;
- why that route beats alternatives;
- next action for the top-ranked route.
"@

$NewRule = @'
# TODO Proof-Ranked Weakest-Link Selection Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Core Correction

The assistant must not "pick" a TODO by preference.

The TODO list must be sorted by proof.

The proof is in the pudding: the biggest issue / weakest link gets worked first.

## Problem

"Pick one actionable TODO" is too muddy.

It can make the assistant choose a convenient item, recent item, easy item, or interesting item instead of the item that best explains the current failure stack.

## Rule

TODO triage must use proof-ranked weakest-link selection.

The assistant must derive the next TODO route from evidence.

## Required Method

When open TODOs exist:

1. Collect current TODO evidence.
2. Group TODOs by parent boss / issue family.
3. Separate parent bosses from child tasks, symptoms, tools, tests, and stale notes.
4. Collapse duplicate or child TODOs under the larger seam.
5. Rank parent bosses by proof of impact.
6. Select the top route from the ranked evidence.
7. State why it outranks the alternatives.
8. Work or dispose that top route.

## Ranking Criteria

Rank higher when the TODO or parent boss:

- blocks current ACTIVE_ANCHOR progress;
- repeats across multiple failures;
- causes point-of-work rule non-firing;
- creates false "done" or false "pass";
- leaves proof incomplete;
- causes wrong-lane action;
- causes active TODOs to be ignored;
- blocks several child TODOs;
- carries high risk of future drift;
- is the weakest link holding the rest back.

Rank lower when the TODO is:

- already covered by a stronger parent;
- only a child symptom;
- stale;
- blocked by missing input;
- a nice-to-have;
- a tool idea with no immediate trigger;
- a future candidate not required by the current route.

## Correct Language

Do not say:

"Pick one TODO."

Say:

"Run TODO weakest-link triage and let the proof-ranked list select the top route."

Or:

"The current weakest link is X because it blocks Y and explains Z."

## User Override

The user may override with a live task.

If the user does, say the live task overrides TODO triage for this turn and route it through the correct proof lanes.

## Boundary

This rule does not install doctrine.

This rule does not rewrite active guides.

This rule does not rewrite CURRENT_TRUTH_INDEX.

This rule does not create automation.

This rule does not create a dashboard.

This rule does not create runtime.

This rule does not make TODOs authority above ACTIVE_ANCHOR.

It makes TODO selection proof-ranked instead of preference-picked.
'@

$Dissection = @"
# TODO Pick Language Mud Correction

Date: 2026-05-20

## Status

REPAIR / SELECTION-METHOD CORRECTION.

## Trigger

After the TODO First Work Control repair, the assistant said the next move was to pick one actionable TODO.

The user corrected the weakness:

The assistant should not pick.

The TODO list should be sorted by proof, biggest issue, and weakest link.

## Issue Class

Selection-method ambiguity.

Muddy wording.

Potential preference-pick failure.

Potential easy-task drift.

## Evidence

The current TODO board has multiple open TODOs.

Current TODO evidence:

$TodoSnapshot

The correct next action is not preference selection.

The correct next action is weakest-link triage.

## Corrected Standard

The list picks through proof.

The assistant groups TODOs into parent bosses, collapses child tasks, ranks by impact, and lets the biggest issue / weakest link become the top route.

## Saved Rule

$NewRulePath

## Patched Rule

$ExistingRulePath

## Board Updated

$TodoControlBoard

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No new TODO pile expansion.

## Next Move

Run TODO weakest-link triage.

Let the proof-ranked list identify the top route.

Then work that route or dispose it with proof.
"@

$ExistingRuleMarker = "2026-05-20 - Weakest-Link Selection Patch"

$ExistingRulePatch = @'
---

## 2026-05-20 - Weakest-Link Selection Patch

Correction:

The phrase "pick one actionable TODO" must not mean preference selection.

TODO selection must be proof-ranked.

The list chooses through evidence:

1. group TODOs by parent boss;
2. collapse child symptoms/tools/tests under the larger seam;
3. rank parent bosses by biggest issue / weakest link;
4. select the top route from proof;
5. state why it outranks alternatives;
6. work or dispose that route.

Correct next-action language:

"Run TODO weakest-link triage."

Not:

"Pick one TODO."
'@

$TodoBoardMarker = "2026-05-20 - TODO Weakest-Link Selection Correction"

$TodoBoardAppend = @"
---

## $TodoBoardMarker

Status: ACTIVE SELECTION-METHOD CORRECTION.

Correction:
- TODO is default work source after clean re-entry.
- TODO selection is not preference picking.
- The proof-ranked list chooses the route.
- The top route is the biggest issue / weakest link.

Required triage method:
1. Group TODOs by parent boss / issue family.
2. Separate parent bosses from child tasks, symptoms, tools, tests, and stale notes.
3. Collapse duplicate or child TODOs under the larger seam.
4. Rank parent bosses by impact and proof.
5. Let the strongest evidence select the top route.
6. State why the top route outranks alternatives.
7. Work or dispose the top route.

Bad language:
- "pick one actionable TODO."

Correct language:
- "run TODO weakest-link triage";
- "the current weakest link is";
- "the proof-ranked top route is."

Next active work:
- run TODO weakest-link triage;
- let the list/proof choose the top route;
- drive that route to active, done, parked, blocked, superseded, merged, or stale review.
"@

Write-NewCleanFile -Path $InstantiationPath -Text $Instantiation
Write-NewCleanFile -Path $NewRulePath -Text $NewRule
Write-NewCleanFile -Path $DissectionPath -Text $Dissection
Append-Once -Path $ExistingRulePath -Marker $ExistingRuleMarker -Text $ExistingRulePatch
Append-Once -Path $TodoControlBoard -Marker $TodoBoardMarker -Text $TodoBoardAppend

Require-Text -Path $InstantiationPath -Needle "biggest issue / weakest link"
Require-Text -Path $NewRulePath -Needle "The proof is in the pudding"
Require-Text -Path $NewRulePath -Needle "TODO triage must use proof-ranked weakest-link selection"
Require-Text -Path $NewRulePath -Needle "Do not say:"
Require-Text -Path $ExistingRulePath -Needle "TODO selection must be proof-ranked"
Require-Text -Path $TodoControlBoard -Needle "The proof-ranked list chooses the route"
Require-Text -Path $DissectionPath -Needle "The list picks through proof"

$Anchor = @"
CURRENT MR.KLEEN POSITION

After TODO Weakest-Link Selection repair.

Base before save:
$HeadBefore

Current ball:
- TODO is default work source after clean re-entry.
- TODO selection is now proof-ranked, not preference-picked.
- "Pick one actionable TODO" was corrected as muddy language.
- The list/proof chooses by parent boss, biggest issue, and weakest link.
- Code Cabinet remained in use for this long save.

Next allowed move:
- Run TODO weakest-link triage.
- Group TODOs by parent boss / issue family.
- Collapse child TODOs under larger seams.
- Rank by biggest issue / weakest link.
- Let the proof-ranked list identify the top route.
- Work or dispose that top route.

Blocked moves:
- Do not hand-pick TODOs by preference.
- Do not choose easy/recent/interesting TODOs over the weakest link.
- Do not say "pick one TODO" as the selection method.
- Do not treat open TODOs as scenery.
- Do not create new TODOs or new rules to avoid doing existing TODOs.
- Do not install doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
"@

Set-Content -LiteralPath $AnchorPath -Value $Anchor -Encoding UTF8
Assert-CleanTextFile -Path $AnchorPath

$StatusAppend = @"

---

## 2026-05-20 - TODO Weakest-Link Selection Repair

Status: PASS WITH GUARDRAILS.

Base before save:
$HeadBefore

Saved:
$InstantiationPath
$NewRulePath
$DissectionPath
$ReceiptPath

Updated:
$ExistingRulePath
$TodoControlBoard
$AnchorPath
$StatusPath

Meaning:
- corrected muddy "pick one TODO" language;
- TODO selection is now proof-ranked, not preference-picked;
- TODO triage must group by parent boss, collapse child issues, rank biggest issue / weakest link, and let proof select the top route;
- next move is TODO weakest-link triage.

Boundary:
- no doctrine install;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard/automation/runtime/knowledge graph/full lesson index;
- no new TODO or rule creation as substitute for doing TODO work.

Next move:
- run TODO weakest-link triage;
- let the proof-ranked list identify the top route;
- work or dispose that route.
"@

Append-Once -Path $StatusPath -Marker "2026-05-20 - TODO Weakest-Link Selection Repair" -Text $StatusAppend

$ChangedForHash = @(
    $InstantiationPath,
    $NewRulePath,
    $DissectionPath,
    $ExistingRulePath,
    $TodoControlBoard,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashTableText -Paths $ChangedForHash

$Receipt = @"
# TODO Weakest-Link Selection Repair Receipt

Date: 2026-05-20

## Result

PASS WITH GUARDRAILS.

## Base Before Save

Branch: $Branch
HEAD before save: $HeadBefore
origin/main before save: $OriginBefore

## Files

$HashList

## Meaning

The muddy "pick one actionable TODO" language was repaired.

TODO remains the default work source after clean re-entry.

TODO selection is now proof-ranked.

The list/proof selects by parent boss, biggest issue, and weakest link.

The next move is TODO weakest-link triage.

## TODO Evidence Snapshot

$TodoSnapshot

## Artifact Self-Check

This save created and checked a real Mr.Kleen artifact package:

- Code Cabinet instantiation;
- TODO proof-ranked weakest-link selection rule;
- failure dissection;
- existing TODO First Work Control rule patch;
- TODO control board update;
- anchor update;
- status update;
- receipt.

Checks performed:

- target files did not already exist before writing;
- required inputs existed and were readable;
- files were readable UTF-8 text;
- files were nonempty;
- no NUL bytes;
- no Unicode replacement characters;
- no placeholder markers;
- required phrases verified;
- branch main;
- HEAD equals origin/main before save;
- clean status before save;
- final commit/push/fetch requires HEAD equals origin/main and status clean.

## Boundary

No doctrine install.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No TODO pile expansion as substitute for doing TODO work.

## Proof Limit

This receipt proves the selection-method repair.

It does not prove the TODO board has been triaged yet.

It does not close any existing TODO by itself.
"@

Write-NewCleanFile -Path $ReceiptPath -Text $Receipt
Require-Text -Path $ReceiptPath -Needle "TODO selection is now proof-ranked"
Require-Text -Path $ReceiptPath -Needle "It does not prove the TODO board has been triaged yet"

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Run-Git add -- $InstantiationPath $NewRulePath $DissectionPath $ExistingRulePath $TodoControlBoard $AnchorPath $StatusPath | Out-Null
Run-Git add -f -- $ReceiptPath | Out-Null

$Staged = @(Run-Git diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "Nothing staged. Stop."
}

Run-Git commit -m "Fix TODO weakest link selection" | Out-Null
Run-Git push origin main | Out-Null
Run-Git fetch origin main | Out-Null

$Head = Git-Line rev-parse HEAD
$Origin = Git-Line rev-parse origin/main
$Short = Git-Line rev-parse --short HEAD
$FinalStatus = @(Run-Git status --short)

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
Write-Host "TODO WEAKEST LINK SELECTION REPAIR SAVED"
Write-Host "Commit: $Short"
Write-Host "HEAD: $Head"
Write-Host "origin/main: $Origin"
Write-Host "Status: clean"
Write-Host "Rule: $NewRulePath"
Write-Host "Patched rule: $ExistingRulePath"
Write-Host "Dissection: $DissectionPath"
Write-Host "Instantiation: $InstantiationPath"
Write-Host "TODO control board updated: $TodoControlBoard"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt bytes: $ReceiptBytes"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS"
Write-Host "Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index"
Write-Host "Next move: run TODO weakest-link triage and let proof-ranked list identify the top route"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
