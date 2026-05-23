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
    if ([string]::IsNullOrWhiteSpace($Raw)) {
        throw ("Wrote empty file: " + $Path)
    }
    if ($Raw.Contains([char]0)) {
        throw ("NUL byte found after write: " + $Path)
    }
    if ($Raw.Contains([char]0xFFFD)) {
        throw ("Replacement character found after write: " + $Path)
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

Write-Host "XxXxX ===== DISCUSSION IDEAS + RULES LOCK SAVE START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$BaseHead = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$BaseShort = Get-GitLine rev-parse --short HEAD
$Status = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") {
    throw ("Wrong branch: " + $Branch)
}

if ($BaseHead -ne $Origin) {
    throw "HEAD does not match origin/main. Stop before save."
}

if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Repo is dirty. Stop before save."
}

$ExpectedBase = "e9bc566bb432817f266e6604595172f5e95afb21"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed from expected mule/discussion base. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess before saving.")
}

$BrainRulePath = "BRAIN_LEARNING\DISCOVERY_PATH_RULE_FIRE_AND_GOOD_FOG_LEARNING_RULE_20260520.md"
$DissectionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\DISCUSSION_DISSECTION_RULE_FIRE_ALARM_GOOD_FOG_AND_RCE_LINKS_20260520.md"
$RelationMapPath = "HOUSE_WORK\WORK_SHED\RELATION_MAPS\RULE_CONCEPT_EVENT_LINK_MAP_SEED_20260520.md"
$MuleStatePath = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\MULE_DONE_RETURN_INTAKE_READY_STATE_NOTE_20260520.md"
$TodoPath = "HOUSE_WORK\TODO\RULE_CONCEPT_EVENT_LINK_MAP_AND_REPORT_GATE_LIVE_USE_TODO_20260520.md"
$ReceiptPath = "PROOF_HISTORY\DISCUSSION_IDEA_RULE_LOCK_SAVE_RECEIPT_20260520.txt"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$BrainRule = @'
# Discovery Path, Rule-Firing Alarm, Good Fog, And Rule-Concept-Event Learning Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support rule / learning pattern
Parent Boss: Rule Activation / Work-Order Control
Neighbor Boss: Memory Health / Placement-Keying / Good Fog Compression
Authority: not doctrine, not active guide, not CURRENT_TRUTH_INDEX, not command surface

## Core rule

Do not save only the final fix.

When a weakness is discovered, save the route that exposed it:

1. event / failure signal;
2. user correction or outside signal;
3. rule that should have fired;
4. why it did not fire;
5. concept family the failure belongs to;
6. clean fix or next proof path;
7. lane and authority boundary;
8. later compression condition.

## Rule-not-fired alarm

If the right rule should naturally fire and does not, that failure is itself an alarm.

This is not a minor wording miss. It means the system has a rule that exists but is not being obeyed at the point of work.

Required response:

1. name the missed trigger;
2. name the rule that should have fired;
3. name the competing gate or fog that suppressed it;
4. classify the failure under Rule Activation / Work-Order Control;
5. capture how the issue was found;
6. prepare save/disposition if project-relevant;
7. do not keep working as if the miss was harmless.

## Report gate binding

For house-walk / full-report / feel-report / step-back / do-it-right requests, the report composition gate must fire before final answer.

Required report pattern:

1. raw feel pass;
2. pause/check pass;
3. rewritten final report.

The check pass must inspect control state, drift risk, mule custody, proof state, and what not to touch.

## Good fog distinction

Not all fog is dirty.

Dirty fog blocks action through stale state, misplacement, false authority, duplicate rules, retrieval failure, or old proof used for new claims.

Solid good fog is real growth residue: discovery paths, corrections, scars, repeated lessons, relation history, and accumulated context.

Good fog is not deleted by default. It is held, indexed, pathed, compressed in season, and turned into cleaner retrieval structure when enough pattern exists.

## Placement-keying health test

Compounded memory becomes healthy only when it is stored, pathed, placed, keyed, indexed, and related correctly.

The question is not "how much memory exists?"

The question is:

Can the system find the right memory, in the right lane, at the right moment, with the right authority, without dragging the whole fog into the room?

If yes: good seed / good core / healthy brain.

If no: weird conditions appear, including drift, bloat, stale proof, crossed lanes, false authority, and rule misfires.

## Rule-Concept-Event triangle

Important rules should not live as isolated text.

Each important rule should link to:

- Rule: what should happen;
- Concept: what pattern the rule belongs to;
- Event: when/how the weakness, discovery, or proof appeared.

This triangle supports trigger firing, retrieval, stale checking, proof history, and later compression of good fog.

## Boundary

This save does not promote any rule to doctrine or active-guide authority.

This save does not process mule return contents.

This save prepares the house to intake mule return and preserve the current discussion learning without allowing source ore or mule output to become command authority.
'@

$Dissection = @'
# Discussion Dissection - Rule-Fire Alarm, Good Fog, Placement Health, And RCE Links

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: dissected discussion cluster / saved support learning
Base HEAD: e9bc566bb432817f266e6604595172f5e95afb21
Authority: sorting/support only

## Why this file exists

A dense discussion exposed a rule-activation weakness and several linked memory-health ideas.

The Dissect Rule should naturally fire when a dense useful idea cluster appears. If it does not fire, that itself is an alarm: a rule exists but is not being obeyed.

This file records the cluster as atomic ideas, not as one vague mood.

## Event chain

1. User asked for a full house walk and report.
2. Assistant gave a useful one-pass report, but did not use the required write -> pause -> rewrite report style.
3. User asked whether the report was done in the required style.
4. Assistant admitted the gate failed.
5. User asked why the gate did not fire.
6. Assistant diagnosed the failure as "rule exists is not rule fired."
7. User clarified that learning must remember how the issue was found, not only the final fix.
8. User named "solid good fog" as real accumulated growth fog, not dirty bloat.
9. User clarified that memory health depends on whether items are stored, pathed, placed, keyed, and integrated as a system.
10. User said the Dissect Rule should naturally fire, and if it does not, an alarm should fire that a rule is not being obeyed.
11. User added the need to link rules to concepts to events.
12. Mule completed work, but mule return has not yet been ingested.

## Atomic idea/rule candidates

### 1. Discovery path must be saved

Learning is not only the final rule or final answer. The house must preserve how the weakness was found.

Disposition: save as support learning.
Lane: BRAIN_LEARNING + PROOF_HISTORY context.
Authority: support rule, not doctrine.

### 2. Rule-not-fired alarm

When a rule should naturally fire and does not, the failure is itself a signal requiring capture.

Disposition: save as Rule Activation / Work-Order Control repair.
Lane: BRAIN_LEARNING and sorting-bench proof context.
Authority: support rule, not active guide.

### 3. Report gate trigger binding

House walk / full report / feel it / step back / do it right must trigger write -> pause -> rewrite.

Disposition: save as trigger binding and live-use TODO.
Lane: BRAIN_LEARNING + TODO.
Authority: output-composition support rule.

### 4. Good fog vs dirty fog

Some fog is valid growth residue. It should not be panic-deleted. It needs pathing, indexing, compression, and seasonal pruning.

Disposition: save as memory-health concept.
Lane: BRAIN_LEARNING.
Authority: support concept, not command surface.

### 5. Placement-keying health

The brain is healthy only if memories are stored, pathed, placed, keyed, indexed, related, and retrieved correctly.

Disposition: save as memory/system health test.
Lane: BRAIN_LEARNING and relation map.
Authority: support concept.

### 6. Rule-Concept-Event link map

Rules should link to the concept they express and the event that proved or exposed them.

Disposition: create seed relation map.
Lane: WORK_SHED / RELATION_MAPS.
Authority: index/reference only; not dashboard, not knowledge graph, not active doctrine.

### 7. Mule done means intake next

Mule being done changes control state, but his output is not command authority. Return must be frozen, checked for staleness, read by manifest, and dispositioned.

Disposition: save next-state note.
Lane: MULE_WORKSHOP support.
Authority: intake boundary only.

## Neighbor checks

No conflict with No Rule King: none of these rules becomes king.

No conflict with Relevant Root Key Selector: this save is a targeted point-of-work save, not a full root-word recitation.

No conflict with mule boundary: this save records chat-side discussion and current intake state; it does not ingest or promote mule output.

No conflict with source-ore boundary: ideas are saved as support learning / relation map / TODO, not doctrine.

## Proof needed later

- Next full house report should demonstrate write -> pause -> rewrite.
- Next mule intake should demonstrate freeze -> stale check -> manifest first -> full disposition.
- Next repeated rule miss should fire the rule-not-fired alarm before normal work continues.
- Relation map should be used at least once before any promotion or expansion.
'@

$RelationMap = @'
# Rule-Concept-Event Link Map Seed

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / RELATION_MAPS
Status: seed relation map / reference index
Authority: support index only; not dashboard; not knowledge graph; not doctrine

## Purpose

Make good fog walkable by linking rules to concepts and events.

Rule = what should happen.
Concept = why / what family the rule belongs to.
Event = when/how the house found, failed, proved, or needed it.

## Entry 01 - Full House Report Style Gate

Rule:
Full house walks / feel reports / step-back reports must use raw feel pass -> pause/check pass -> rewritten final report unless the user asks for a quick answer.

Concept:
Output-composition gate; report method trigger binding; rule exists is not rule fired.

Event:
User asked for a full house walk while mule was working. Assistant wrote a useful one-pass report but skipped the required write -> pause -> rewrite method. User caught the miss by asking whether the report was done in the required style.

Trigger phrases:
house walk; walk it all over; feel it; full report; do the report right; step back; look at it all for what it is and needs to be.

Proof state:
Needs next live-use proof.

Neighbor rules:
Control state first; worker present, hands off; no rule king; relevant root key selector.

## Entry 02 - Rule-Not-Fired Alarm

Rule:
If a rule should naturally fire and does not, the failure itself must trigger an alarm and capture.

Concept:
Rule Activation / Work-Order Control; dispatch gate failure; rule exists is not rule fired.

Event:
Report style gate did not fire. User asked why. Diagnosis showed the rule existed as preference/method but did not interrupt output composition.

Trigger phrases:
why did that not fire; why is that not firing; this rule should have fired; you missed the rule; did you do it the way you were supposed to.

Proof state:
Saved as support learning; needs live-use on next missed-trigger event.

Neighbor rules:
Dissect Rule; Discovery Capture Interrupt; problem-to-self-repair; no random moves.

## Entry 03 - Discovery Path Learning

Rule:
Do not only save the answer. Save the route that exposed the need for the answer.

Concept:
How-we-found-out proof; growth-cycle learning; good fog formation.

Event:
User clarified that learning happens by remembering how the issue was found out, even if those discovery traces compound over time.

Trigger phrases:
how we found out; this is how we learn; remember how we found it; discovery path; save the route.

Proof state:
Saved as support learning; should appear in future receipts/dissections when a failure reveals a new pattern.

Neighbor rules:
Evidence before repair; proof history; source ore not command; later compression.

## Entry 04 - Solid Good Fog

Rule:
Do not treat all compounded memory fog as dirty bloat. Distinguish dirty fog from solid good fog.

Concept:
Memory maturity; lived accumulation; growth residue; seasonal compression.

Event:
User explained that many memories can compound into fog, but some fog is solid and real, like the fog people get as they grow older.

Trigger phrases:
good fog; solid fog; real fog; memory fog; as we grow older; not dirty fog.

Proof state:
Saved as memory-health concept; needs later compression/indexing practice.

Neighbor rules:
Anti-bloat; memory pruning; source ore parking; proof-history compression.

## Entry 05 - Placement-Keying Health

Rule:
Memory is healthy only when stored, pathed, placed, keyed, indexed, and related correctly so the whole system works together.

Concept:
Good seed / good core / healthy brain; retrieval architecture; system integration.

Event:
User clarified that the trick is whether memories are stored, pathed, placed, keyed, and whether everything is in place as a cooperating system.

Trigger phrases:
stored pathed placed keyed; system working together; everything in place; good seed; good core; healthy brain; weird conditions.

Proof state:
Saved as memory/system health test; should guide future memory compression and relation mapping.

Neighbor rules:
Authority boundary; lane placement; relation map; stale check.

## Entry 06 - Mule Done / Intake First

Rule:
Mule return is incoming material, not command authority. Freeze, stale-check, read manifest first, inspect all returned files, and disposition before any save/adoption.

Concept:
Worker present -> return intake; custody; source ore boundary; mule sharpens, house decides.

Event:
User said mule is done after a local-only mule packet was built from e9bc566. The house must not blindly save mule recommendations or stale the packet.

Trigger phrases:
mule is done; mule returned; he finished; bring him back; intake; return package.

Proof state:
Ready for next intake; no mule output ingested in this save.

Neighbor rules:
Stale checker; no direct repo edits; output dump only; full return disposition.

## Entry 07 - Rule-Concept-Event Link Map

Rule:
Important rules should be linked to concept and event so they are retrievable and not isolated text.

Concept:
Traceability triangle; good fog indexing; event-triggered retrieval.

Event:
User said "somehow we need to link rules to concepts to events."

Trigger phrases:
link rules to concepts to events; relation map; why did this matter; what event caused this; concept family.

Proof state:
Seed map created; needs first real use before promotion or expansion.

Neighbor rules:
No dashboard unless selected; no knowledge graph unless selected; support index only.
'@

$MuleState = @'
# Mule Done - Return Intake Ready State Note

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / MULE_WORKSHOP
Status: intake-ready state note
Base HEAD for mule packet: e9bc566bb432817f266e6604595172f5e95afb21
Authority: local intake boundary only

## State

The mule was sent a local-only big overall job packet built from base HEAD e9bc566bb432817f266e6604595172f5e95afb21.

The mule is now reported done.

Mule output has not been pasted, uploaded, read, frozen, stale-checked, manifested, or dispositioned in this save.

## Boundary

Mule output is not command authority.

No mule recommendation becomes doctrine, active guide, CURRENT_TRUTH_INDEX, tool promotion, suit promotion, TODO closure, or repo change without intake and proof.

## Next required intake sequence

1. Freeze the returned dump folder as received.
2. Confirm packet base and current repo HEAD.
3. Run or read stale-check result.
4. Read return manifest first.
5. List every returned file.
6. Inspect every returned file in order.
7. Disposition each item: apply, adapt, park, reject, needs proof, or stale/blocked.
8. Only then decide whether a repo save is justified.

## Blocked

- Do not cherry-pick the best-looking mule idea before full return inventory.
- Do not let mule rewrite the house.
- Do not keep editing local repo during intake if the packet depends on e9bc566.
- Do not process mule output as truth without stale/custody proof.
'@

$Todo = @'
# TODO - Rule-Concept-Event Link Map And Report Gate Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: open / live-use proof needed
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Memory Health / Placement-Keying / Good Fog Compression

## Purpose

Prove that the discussion save becomes action, not another stored-but-unfired rule.

## Required live uses

### 1. Full report gate

Next time user asks for house walk / feel report / full report / step back / do the report right:

- run raw feel pass;
- pause/check control state, drift, custody, proof, and blocked moves;
- rewrite final report;
- do not push commands unless the report proves a command is needed.

Pass condition:
The final answer visibly reflects the rewritten report quality and does not behave like a one-pass reaction.

### 2. Rule-not-fired alarm

Next time a missed rule is caught:

- name the missed rule;
- name the event that exposed it;
- name the concept family;
- capture how it was found;
- decide lane/disposition.

Pass condition:
The miss becomes a learning/disposition object before normal work continues.

### 3. Rule-Concept-Event map

On the next real rule save or relation save:

- add at least one Rule -> Concept -> Event entry;
- include trigger phrases;
- include proof state;
- include authority boundary.

Pass condition:
The map improves retrieval without becoming a dashboard, knowledge graph, or doctrine surface.

### 4. Mule return intake

When mule return is provided:

- freeze/read manifest first;
- inspect all returned files;
- disposition every item;
- keep mule output in incoming/source/support lanes until proof.

Pass condition:
No single mule recommendation is applied before full return inventory and stale/custody check.

## Not allowed

- Do not promote this TODO to active guide.
- Do not build dashboard or knowledge graph from this TODO alone.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not use this TODO as command authority.
'@

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Base before save: e9bc566bb432817f266e6604595172f5e95afb21
Current active ball after this save: Mule return intake after discussion idea/rule lock save

## Last completed move

Saved the dense discussion learning cluster:

- discovery path / how-we-found-out learning;
- rule-not-fired alarm;
- report gate trigger binding;
- solid good fog distinction;
- placement-keying memory health;
- rule-concept-event link map seed;
- mule done / return intake state.

## Current control state

Mule is reported done.

Mule output has not yet been ingested.

The house should process mule return next through intake, not by blind adoption.

## Next allowed move

Freeze/read the mule return package from the local mule workshop dump folder.

Required sequence:

1. identify packet and dump folder;
2. verify current repo state and packet base;
3. read stale-check result;
4. read return manifest first if present;
5. list every returned file;
6. inspect every returned file;
7. disposition each returned item before save/adoption.

## Blocked moves

- Do not treat mule output as command authority.
- Do not cherry-pick one mule recommendation before full return inventory.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not promote tools, suits, stale checker, relation map, or report gate from this save alone.
- Do not keep creating support-rule loops instead of processing the mule return.

## Boundary

This anchor records state and next intake route. It is not doctrine.
'@

Write-Utf8Text -Path $BrainRulePath -Text $BrainRule
Write-Utf8Text -Path $DissectionPath -Text $Dissection
Write-Utf8Text -Path $RelationMapPath -Text $RelationMap
Write-Utf8Text -Path $MuleStatePath -Text $MuleState
Write-Utf8Text -Path $TodoPath -Text $Todo
Write-Utf8Text -Path $AnchorPath -Text $Anchor

$StatusAppend = @"

---

## 2026-05-20 - Discussion ideas/rules lock save

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved discussion cluster:

- discovery path / how-we-found-out learning;
- rule-not-fired alarm;
- write -> pause -> rewrite full-report trigger binding;
- solid good fog versus dirty fog distinction;
- placement-keying memory health test;
- Rule-Concept-Event link map seed;
- mule done / return intake-ready state.

Current active ball after save:
Mule return intake.

Next allowed move:
Freeze/read the mule return package from the local mule workshop dump folder, stale-check it, read manifest first, inspect all returned files, and disposition before any adoption/save.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, no tool/suit/stale-checker/relation-map promotion, and no mule output adoption in this save.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $BrainRulePath -Needle "Rule-Concept-Event triangle"
Assert-Needle -Path $DissectionPath -Needle "how the issue was found"
Assert-Needle -Path $RelationMapPath -Needle "Entry 07 - Rule-Concept-Event Link Map"
Assert-Needle -Path $MuleStatePath -Needle "Mule output is not command authority"
Assert-Needle -Path $TodoPath -Needle "Full report gate"
Assert-Needle -Path $AnchorPath -Needle "Mule return intake"

$NewFiles = @(
    $BrainRulePath,
    $DissectionPath,
    $RelationMapPath,
    $MuleStatePath,
    $TodoPath,
    $ReceiptPath
)

$HashLines = New-Object System.Collections.Generic.List[string]
foreach ($Path in @($BrainRulePath,$DissectionPath,$RelationMapPath,$MuleStatePath,$TodoPath,$AnchorPath,$StatusPath)) {
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    $HashLines.Add("- " + $Path + " | sha256=" + $Hash) | Out-Null
}

$Receipt = @"
DISCUSSION IDEA/RULE LOCK SAVE RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- $BrainRulePath
- $DissectionPath
- $RelationMapPath
- $MuleStatePath
- $TodoPath
- $AnchorPath
- $StatusPath

Core learning saved:
- learning must remember how the weakness was found, not only final fix;
- missed rule firing must trigger a rule-not-obeyed alarm;
- full house reports require raw feel pass -> pause/check -> rewritten final report;
- solid good fog is real growth residue, not dirty bloat by default;
- memory health depends on stored/pathed/placed/keyed/indexed/related retrieval;
- important rules should link Rule -> Concept -> Event;
- mule done means return intake next, not blind adoption.

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
- no tool/suit/stale-checker/relation-map promotion;
- no mule output adoption or processing in this save.

Next move:
Freeze/read mule return package, run stale/custody check, read manifest first, inspect every returned file, and disposition before adoption/save.
"@

Write-Utf8Text -Path $ReceiptPath -Text $Receipt
Assert-Needle -Path $ReceiptPath -Needle "RULE LOCK SAVE RECEIPT"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) {
    throw "No changes detected after writing save package."
}

Invoke-GitChecked add -- $BrainRulePath $DissectionPath $RelationMapPath $MuleStatePath $TodoPath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "No staged files before commit."
}

Invoke-GitChecked commit -m "Lock discussion learning and relation map" | Out-Null
Invoke-GitChecked push origin main | Out-Null
Invoke-GitChecked fetch origin main | Out-Null

$FinalHead = Get-GitLine rev-parse HEAD
$FinalOrigin = Get-GitLine rev-parse origin/main
$FinalShort = Get-GitLine rev-parse --short HEAD
$FinalStatus = @(Invoke-GitChecked status --short)

if ($FinalHead -ne $FinalOrigin) {
    throw "Final proof failed: HEAD does not match origin/main."
}

if ($FinalStatus.Count -ne 0) {
    Write-Host "Final dirty status:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final proof failed: status not clean."
}

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "DISCUSSION IDEAS AND RULES LOCK SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $BrainRulePath)
Write-Host ("- " + $DissectionPath)
Write-Host ("- " + $RelationMapPath)
Write-Host ("- " + $MuleStatePath)
Write-Host ("- " + $TodoPath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Updated:"
Write-Host ("- " + $AnchorPath)
Write-Host ("- " + $StatusPath)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS: dense discussion dissected and saved."
Write-Host "- PASS: Rule -> Concept -> Event seed map created."
Write-Host "- PASS: mule done state saved as intake-ready, not adopted."
Write-Host ""
Write-Host "Boundary:"
Write-Host "- No doctrine rewrite."
Write-Host "- No active guide rewrite."
Write-Host "- No CURRENT_TRUTH_INDEX rewrite."
Write-Host "- No dashboard, automation, runtime, knowledge graph, or full lesson index."
Write-Host "- No tool/suit/stale-checker/relation-map promotion."
Write-Host "- No mule output adoption."
Write-Host ""
Write-Host "Next move:"
Write-Host "- Freeze/read mule return package."
Write-Host "- Stale/custody check."
Write-Host "- Read manifest first."
Write-Host "- Inspect every returned file."
Write-Host "- Disposition before adoption/save."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
