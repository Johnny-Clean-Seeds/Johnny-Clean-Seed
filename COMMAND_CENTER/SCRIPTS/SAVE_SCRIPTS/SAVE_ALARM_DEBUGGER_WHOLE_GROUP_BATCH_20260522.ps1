& {
    $ErrorActionPreference = "Stop"

    Remove-Item Function:\Git -ErrorAction SilentlyContinue

    $Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $ExpectedBase = "2db751f63a450908ffa4edec355855d666b0bd56"

    function Run-Git {
        param([Parameter(Mandatory=$true)][string[]]$GitArgs)

        $out = & git.exe -c safe.directory="$Repo" -C "$Repo" @GitArgs 2>&1
        $code = $LASTEXITCODE

        if ($code -ne 0) {
            throw "git.exe $($GitArgs -join ' ') failed.`n$($out | Out-String)"
        }

        return @($out)
    }

    function Write-CleanText {
        param(
            [Parameter(Mandatory=$true)][string]$Path,
            [Parameter(Mandatory=$true)][string]$Text
        )

        $Clean = [regex]::Replace($Text, '[ \t]+(?=\r?\n)', '')
        $Clean = [regex]::Replace($Clean, '[ \t]+\z', '')
        [System.IO.File]::WriteAllText($Path, $Clean, [System.Text.UTF8Encoding]::new($false))
    }

    function Rel-Path {
        param([Parameter(Mandatory=$true)][string]$FullPath)
        return $FullPath.Substring($Repo.Length + 1).Replace("\","/")
    }

    if (-not (Test-Path (Join-Path $Repo ".git"))) {
        throw "Not in Mr.Kleen repo: $Repo"
    }

    $Branch = (Run-Git @("branch","--show-current") | Out-String).Trim()
    if ($Branch -ne "main") {
        throw "Wrong branch. Expected main; got $Branch"
    }

    $Head = (Run-Git @("rev-parse","HEAD") | Out-String).Trim()
    if ($Head -ne $ExpectedBase) {
        throw "Wrong base. Expected $ExpectedBase but got $Head"
    }

    $RemoteBefore = ((Run-Git @("ls-remote","origin","refs/heads/main") | Out-String).Trim() -split "\s+")[0]
    if ($RemoteBefore -ne $ExpectedBase) {
        throw "Remote mismatch before save. Local $Head / Remote $RemoteBefore"
    }

    $PreStatus = (Run-Git @("status","--short") | Out-String).Trim()
    if ($PreStatus) {
        throw "Repo dirty before whole-group alarm batch save. Stop.`n$PreStatus"
    }

    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DateOnly = Get-Date -Format "yyyyMMdd"

    $MemoryTriggerRel = "BRAIN_LEARNING/MEMORY_UPDATE_IS_NOT_HOUSE_RULE_SAVE_REPAIR_TRIGGER_$DateOnly.md"
    $BatchMapRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_WHOLE_GROUP_BATCH_REPAIR_MAP_$Stamp.md"
    $ScaffoldRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/SCAFFOLDS_AND_LADDERS/ALARM_DEBUGGER_SCAFFOLDS_AND_LADDERS_$Stamp.md"
    $LinksRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_RESOURCE_AND_EVIDENCE_LINK_MAP_$Stamp.md"
    $FiringCardRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/ALARM_DEBUGGER_WHOLE_GROUP_BATCH_FIRING_CARD_$Stamp.md"
    $TodoRel = "HOUSE_WORK/TODO/ALARM_DEBUGGER_WHOLE_GROUP_BATCH_FOLLOWUP_TODO_$Stamp.md"
    $ReceiptRel = "PROOF_HISTORY/ALARM_DEBUGGER_WHOLE_GROUP_BATCH_SAVE_RECEIPT_$Stamp.txt"

    $AllRel = @(
        $MemoryTriggerRel,
        $BatchMapRel,
        $ScaffoldRel,
        $LinksRel,
        $FiringCardRel,
        $TodoRel,
        $ReceiptRel
    )

    foreach ($Rel in $AllRel) {
        $Full = Join-Path $Repo ($Rel -replace "/","\")
        New-Item -ItemType Directory -Force -Path (Split-Path $Full) | Out-Null
    }

    $SourceLinks = [ordered]@{
        "Alarm cabinet inventory" = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_20260522.md"
        "Source/Lane/Artifact repair target" = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/REPAIR_TARGETS/SOURCE_LANE_ARTIFACT_PLACEMENT_FIRST_REPAIR_TARGET_20260522_050405.md"
        "Source/Lane/Artifact firing card" = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/SOURCE_LANE_ARTIFACT_PLACEMENT_ALARM_FIRING_CARD_20260522_050405.md"
        "Rule Quality/Wording repair target" = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/REPAIR_TARGETS/RULE_QUALITY_WORDING_COVERAGE_SECOND_REPAIR_TARGET_20260522_050634.md"
        "Rule Quality/Wording firing card" = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/RULE_QUALITY_WORDING_COVERAGE_ALARM_FIRING_CARD_20260522_050634.md"
        "Tool/Script/Copy repair target" = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/REPAIR_TARGETS/TOOL_SCRIPT_COPY_SAFETY_THIRD_REPAIR_TARGET_20260522_050951.md"
        "Tool/Script/Copy firing card" = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/TOOL_SCRIPT_COPY_SAFETY_ALARM_FIRING_CARD_20260522_050951.md"
        "Completion revision rule" = "BRAIN_LEARNING/COMPLETION_REVISION_SECOND_PASS_EDITING_RULE_20260522.md"
        "Linking papers rule" = "BRAIN_LEARNING/LINKING_PAPERS_EVIDENCE_CHAIN_RULE_20260522.md"
        "Local Git save trigger" = "BRAIN_LEARNING/LOCAL_GIT_SAVE_TRIGGER_RULE_20260522.md"
        "Mule filing handoff method" = "BRAIN_LEARNING/MULE_FILING_CABINET_DEEP_HANDOFF_METHOD_RULE_20260522.md"
        "Clean Seed Build vs Other Noise boundary" = "BRAIN_LEARNING/CLEAN_SEED_BUILD_VS_OTHER_NOISE_PHASE_BOUNDARY_RULE_20260522.md"
        "Broad growth package receipt" = "PROOF_HISTORY/BROAD_GROWTH_RULE_PACKAGE_SAVE_RECEIPT_20260522_035009.txt"
    }

    $LinkRows = foreach ($Entry in $SourceLinks.GetEnumerator()) {
        $Full = Join-Path $Repo ($Entry.Value -replace "/","\")
        $Exists = Test-Path $Full
        if ($Exists) {
            $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Full).Hash
            "- $($Entry.Key): $($Entry.Value) [PRESENT] SHA256 $Hash"
        } else {
            "- $($Entry.Key): $($Entry.Value) [MISSING]"
        }
    }

    $RequiredCabinet = Join-Path $Repo ($SourceLinks["Alarm cabinet inventory"] -replace "/","\")
    if (-not (Test-Path $RequiredCabinet)) {
        throw "Required cabinet inventory missing: $RequiredCabinet"
    }

    $MemoryTrigger = @"
# Memory Update Is Not a House Rule / Save Repair Trigger

Date: $Stamp

Status: active save-discipline and repair-trigger rule.

## Rule

A ChatGPT memory update is not a Mr.Kleen house rule.

A memory update is a signal that durable house-relevant material may exist and may need to be saved, repaired, or linked into the local Mr.Kleen house and Git.

If the material is durable and house-relevant, the Local + Git Save Trigger must fire from the work type itself unless the user explicitly blocks saving or the route is unsafe.

## Why this matters

Memory can help the assistant remember behavior across chats.

Memory does not create a local file.

Memory does not create a Git commit.

Memory does not create a proof receipt.

Memory does not update ACTIVE_ANCHOR or CURRENT_HOUSE_WORK_STATUS.

Memory does not become a rule in Mr.Kleen until it is saved to the house with proof.

## Repair action

When a memory update captures a durable rule, method, correction, alarm, debugger, handoff pattern, save discipline, or phase boundary, ask whether it belongs in the house.

If it belongs, save it through the normal route:

1. Verify base.
2. Write the file to the correct lane.
3. Link the source/evidence chain.
4. Write receipt.
5. Stage including ignored proof receipts when intentional.
6. Commit.
7. Push.
8. Verify remote HEAD and clean status.

## Boundary

This does not mean every casual memory becomes a house file.

This means house-relevant memory updates create a repair/save obligation.

If the idea is not current-fit, park it instead of promoting it.
"@

    $BatchMap = @"
# Alarm / Debugger Whole-Group Batch Repair Map

Date: $Stamp

Base:

$ExpectedBase

Status:

PASS WITH GUARDRAILS / WHOLE-GROUP BATCH MAP SAVED / NO PROMOTION

## Purpose

This file moves the alarm/debugger cabinet from one-at-a-time repair targets into a whole-group repair map.

The earlier one-by-one targets were useful scaffolding, but the cabinet now needs a batch view so the groups can be compared together, weighted by phase, linked to evidence, and given ladders toward stronger proof.

## Draft view before revision

Initial batch shape:

1. Authority / Promotion.
2. Proof / PASS / Save Integrity.
3. Source / Lane / Artifact Placement.
4. Loss / Destructive Action.
5. Route / Root / Next-Move.
6. Rule Quality / Wording Coverage.
7. Growth / Bloat / Whirlpool.
8. Tool / Script / Copy Safety.
9. Agent / Mule / Bridge Lifecycle.
10. Meta Alarm Governors.

Initial concern:

The group set is sound, but individual target saves can create local progress without showing how the whole cabinet works together.

## Revision pass applied

Completion Revision / Second-Pass Editing was applied.

Checks performed:

1. Did the work stay whole-group instead of making only one more target?
2. Did the map preserve primary homes and cross-links?
3. Did the map include tools/resources/links?
4. Did the map include scaffolds and ladders?
5. Did it avoid promoting alarms/debuggers?
6. Did it avoid doctrine, ACTIVE_GUIDES, and CURRENT_TRUTH_INDEX rewrite?
7. Did it preserve the evidence chain?
8. Did it capture the memory-update-not-rule correction?
9. Did it avoid false linearity?
10. Did it support current messy-growth phase without overblocking useful work?

Result:

PASS WITH WATCH.

## Final revised view

The alarm/debugger cabinet should be handled as ten connected groups.

Each group needs:

1. Primary purpose.
2. Protected damage type.
3. Default severity.
4. Phase weight.
5. Proof that it fired or failed.
6. Current status.
7. Cross-links.
8. Scaffold if still immature.
9. Ladder to stronger proof or later promotion review.
10. Next repair or watch point.

## Whole group table

| Group | Primary damage protected | Default severity | Current status | Phase weight | Next whole-group move |
|---|---|---:|---|---|---|
| Authority / Promotion | Wrong authority source or premature promotion | BLOCKER | mostly working | all phases, highest in wrap/promotion | keep as hard blocker |
| Proof / PASS / Save Integrity | false completion or dirty save truth | BLOCKER | working with proof | all phases | keep aggressive |
| Source / Lane / Artifact Placement | wrong material in wrong lane/artifact | BLOCKER during writing, WARNING in discussion | first repair target saved | build/stabilization | test firing before next artifact |
| Loss / Destructive Action | deleted source/proof/recovery | BLOCKER | less tested | all phases, high during Whirlpool | add pre-delete/pre-collapse proof gate later |
| Route / Root / Next-Move | wrong task/root/boss | WARNING, BLOCKER for authority/save/delete | partial | build/stabilization | pair with rule firing before saves |
| Rule Quality / Wording Coverage | vague, narrow, overfit, false-linear rules | WARNING | second repair target saved | build/stabilization/wrap | use revision rule before delivery/save |
| Growth / Bloat / Whirlpool | useful bloat deleted or dirty bloat promoted | WATCH/WARNING | conceptually active | build/Whirlpool | preserve source pressure, seek powerplays later |
| Tool / Script / Copy Safety | local execution and paste failures | WARNING/BLOCKER for scripts | third repair target saved | all active save phases | prefer ps1 artifacts plus launchers |
| Agent / Mule / Bridge Lifecycle | helper output or bridge becomes accidental authority | WARNING/BLOCKER for authority writes | working enough, messy | build/stabilization | keep mule/bridge output evidence-only |
| Meta Alarm Governors | alarm system becomes decorative or overblocking | meta | newly clarified | all phases | tune friction to phase |

## Cross-link rules

1. Source/Lane links to Rule Quality when an artifact is being written.
2. Proof/PASS links to Tool Safety whenever scripts, Git, receipts, hashes, or remote checks are involved.
3. Authority/Promotion links to Mule/Bridge whenever helper output exists.
4. Growth/Bloat links to Loss Prevention before Whirlpool or compression.
5. Meta Governors sit above all groups and decide severity by phase.
6. Revision and Linking rules apply to every durable artifact, not just mule handoffs.
7. Memory Update Is Not House Rule applies when ChatGPT memory captured a durable house idea.

## What changed after the deeper second look

1. The next work should not continue only one group at a time.
2. The cabinet needs a batch map plus scaffolds and ladders.
3. Memory updates must be treated as save/repair signals when house-relevant.
4. The downloadable ps1 plus short launcher delivery pattern belongs under Tool / Script / Copy Safety.
5. The evidence links need their own file so future work can see what the batch was built from.
6. The whole cabinet should remain candidate/evidence until tested in real events.
"@

    $Scaffold = @"
# Alarm / Debugger Scaffolds and Ladders

Date: $Stamp

Base:

$ExpectedBase

## Definitions

A scaffold is temporary support used to build, test, or hold a weak structure while it matures.

A scaffold must not become permanent authority by accident.

A ladder is an ordered path from current status to stronger proof, repair, test, or later promotion review.

A ladder should show the next step up without pretending the top has already been reached.

## Cabinet scaffolds

### Scaffold 1 — Whole-group batch map

Purpose:

Hold all ten groups together so the house can compare severity, proof, phase, cross-links, and repair targets.

Risk:

The batch map could look like authority.

Guard:

Mark it candidate/evidence only until repeated live use proves the groups.

### Scaffold 2 — Firing cards

Purpose:

Turn alarm names into action checks.

Risk:

Cards can become decorative if they do not change behavior.

Guard:

Each firing card needs real event evidence: fired, late, partial, failed-to-fire, or working.

### Scaffold 3 — Short launcher plus ps1 artifact

Purpose:

Avoid screen-filling code blocks and paste errors while preserving executable local work.

Risk:

Generated scripts can become stale after base changes.

Guard:

Each script must verify base and stop on mismatch.

### Scaffold 4 — Clean bloat appendix / idea bag

Purpose:

Allow useful bloat without forcing it into active rules too early.

Risk:

Clean bloat can become noise if ungrouped.

Guard:

Every bloat item needs a primary home, cross-link, or parking decision.

### Scaffold 5 — Memory update signal

Purpose:

Catch house-relevant durable ideas that were only stored in ChatGPT memory.

Risk:

Memory can be mistaken for house proof.

Guard:

Memory is a trigger, not a rule. House rule requires local file plus Git proof.

## Ladders

### Ladder A — Alarm existence to alarm proof

1. Alarm named.
2. Primary home assigned.
3. Protected damage type defined.
4. Severity by phase defined.
5. Firing card written.
6. Real event observed.
7. Status labeled: working, partial, late, failed-to-fire, decorative/no-proof.
8. Repair target created if weak.
9. Second event confirms improvement.
10. Later promotion review only if repeatedly reliable.

### Ladder B — One target to whole cabinet

1. Save cabinet inventory.
2. Save top weak targets.
3. Build whole-group batch map.
4. Link evidence and resources.
5. Add scaffolds/ladders.
6. Test groups in real work.
7. Whirlpool duplicate/weak patterns later.
8. Promote only through separate proof route.

### Ladder C — Useful bloat to dense growth

1. Capture bloat.
2. Sort into primary home.
3. Cross-link neighbor groups.
4. Watch repeated pressure.
5. Identify powerplay candidate.
6. Collapse only when one clean move solves several issues.
7. Preserve source/proof/recovery.
8. Retire scaffold after dense rule is proven.

### Ladder D — Draft to final

1. Draft the artifact.
2. Run completion revision.
3. Check links and evidence chain.
4. Add missing tools/resources if needed.
5. Remove overfit current-chat wording.
6. Preserve useful broad coverage.
7. Save only after final view passes.
8. Commit/push and verify clean.

## Current verdict

PASS WITH GUARDRAILS / SCAFFOLDS AND LADDERS SAVED / NO PROMOTION
"@

    $Links = @"
# Alarm / Debugger Resource and Evidence Link Map

Date: $Stamp

Base:

$ExpectedBase

## Purpose

This file satisfies the Linking Papers / Evidence Chain rule for the whole-group alarm/debugger batch.

It names the source and support papers used by the batch map.

## Source / support links

$($LinkRows -join "`n")

## Tool and resource methods used

- Local + Git Save Trigger: used to require local file, receipt, commit, push, remote match, and clean status.
- Completion Revision / Second-Pass Editing: used to create draft view, final revised view, and deeper second look.
- Linking Papers / Evidence Chain: used to preserve source paths, receipts, hashes, and downstream TODO.
- Filing Cabinet Method: used to assign groups, primary homes, cross-links, scaffolds, and ladders.
- Tool / Script / Copy Safety: used to deliver this as a ps1 artifact plus short launcher instead of screen-filling code.
- Git diff checks: used to block whitespace/error saves.
- Proof receipt force-add discipline: used because PROOF_HISTORY can be ignored.

## Evidence-chain status

The batch map is evidence/candidate material.

It supports future alarm/debugger testing.

It does not promote alarms.

It does not rewrite doctrine.

It does not rewrite ACTIVE_GUIDES.

It does not rewrite CURRENT_TRUTH_INDEX.
"@

    $FiringCard = @"
# Alarm / Debugger Whole-Group Batch Firing Card

Date: $Stamp

Base:

$ExpectedBase

## Fired because

The user challenged the one-by-one repair flow and asked why the whole group was not handled at once.

Additional required inputs:

1. Use edit/revise rule.
2. Use draft/final.
3. Use tools/resources.
4. Use links.
5. Use scaffolds.
6. Use ladders.
7. Treat memory update as signal that a house rule/save may be missing.

## Rules that fired

1. Local + Git Save Trigger.
2. Completion Revision / Second-Pass Editing Rule.
3. Linking Papers / Evidence Chain Rule.
4. Filing Cabinet Method.
5. Tool / Script / Copy Safety.
6. Memory Update Is Not House Rule Trigger.
7. Phase-Weighted Importance.
8. Alarm Friction Stage Match.

## Result

PASS WITH WATCH.

The right move is a whole-group batch map, not another single repair target.

The map remains evidence/candidate material and does not promote the cabinet.

## Blocked

No doctrine rewrite.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No automation install.

No broad Whirlpool run.

No promotion.

No treating memory update as house proof.
"@

    $Todo = @"
# Alarm / Debugger Whole-Group Batch Followup TODO

Date: $Stamp

## Current state

The whole alarm/debugger group set has a batch repair map, evidence link map, scaffolds, ladders, and firing card.

## Next use

Use the batch map when deciding future alarm/debugger work.

Do not keep making isolated targets unless the batch map points to a specific weak group.

## Next proof needed

1. Use Source/Lane/Artifact firing card before the next artifact save.
2. Use Rule Quality/Wording firing card before the next rule-like artifact.
3. Use Tool/Script/Copy Safety before the next generated ps1.
4. Record whether the alarm fired, fired late, was partial, or failed-to-fire.
5. Update the cabinet with real firing evidence after enough events.

## Later Whirlpool

After repeated firing evidence accumulates, run a Whirlpool/powerplay pass to collapse duplicate alarms, merge weak overlaps, and retire scaffolds.

## Blocked

Do not promote the whole cabinet yet.

Do not treat batch map as doctrine.

Do not delete useful bloat by default.

Do not skip evidence links.

Do not skip revision before durable saves.
"@

    $Receipt = @"
ALARM DEBUGGER WHOLE-GROUP BATCH SAVE RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Saved files:
$MemoryTriggerRel
$BatchMapRel
$ScaffoldRel
$LinksRel
$FiringCardRel
$TodoRel

Verdict:
PASS WITH GUARDRAILS / WHOLE-GROUP ALARM DEBUGGER BATCH MAP SAVED / NO PROMOTION

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No broad Whirlpool run.
No promotion.
No authority transfer.

Revision applied:
Yes. Draft view, second-pass revision, final revised view, links, tools/resources, scaffolds, and ladders included.

Linking applied:
Yes. Resource/evidence link map saved and source/support files named with presence/hash where available.

Memory correction applied:
Yes. Memory update is a signal, not a house rule, and house-relevant memory must trigger local plus Git save/repair when appropriate.
"@

    $Map = [ordered]@{
        $MemoryTriggerRel = $MemoryTrigger
        $BatchMapRel = $BatchMap
        $ScaffoldRel = $Scaffold
        $LinksRel = $Links
        $FiringCardRel = $FiringCard
        $TodoRel = $Todo
        $ReceiptRel = $Receipt
    }

    foreach ($Pair in $Map.GetEnumerator()) {
        $Path = Join-Path $Repo ($Pair.Key -replace "/","\")
        Write-CleanText -Path $Path -Text ($Pair.Value + "`n")
    }

    $AnchorPath = Join-Path $Repo "ACTIVE_ANCHOR.txt"
    $Anchor = @"
ACTIVE ANCHOR

Current position:
main after whole-group alarm/debugger batch map save

Base before save:
main @ 2db751f

Saved:
Memory Update Is Not House Rule trigger.
Whole-group Alarm/Debugger Batch Repair Map.
Alarm/Debugger Scaffolds and Ladders.
Alarm/Debugger Resource and Evidence Link Map.
Whole-group firing card.
Followup TODO and receipt.

Verdict:
PASS WITH GUARDRAILS / WHOLE-GROUP BATCH MAP SAVED / NO PROMOTION

Next allowed move:
Use the whole-group batch map before creating more individual alarm repair targets. Use firing evidence to decide whether a group is working, late, partial, decorative/no-proof, or failed-to-fire.

Blocked:
Do not promote the cabinet.
Do not treat memory update as house proof.
Do not skip revision or evidence links.
Do not rewrite doctrine.
Do not rewrite ACTIVE_GUIDES.
Do not rewrite CURRENT_TRUTH_INDEX.
Do not install automation.
"@

    Write-CleanText -Path $AnchorPath -Text ($Anchor + "`n")

    $StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $ExistingStatus = Get-Content -LiteralPath $StatusPath -Raw
    if (-not $ExistingStatus.EndsWith("`n")) {
        $ExistingStatus += "`n"
    }

    $StatusAppend = @(
        ""
        "## $DateOnly — Alarm/Debugger Whole-Group Batch Map Save"
        ""
        "Base before save: main @ 2db751f"
        "Full base hash: $ExpectedBase"
        "State: PASS WITH GUARDRAILS / WHOLE-GROUP ALARM DEBUGGER BATCH MAP SAVED / NO PROMOTION"
        "Saved memory trigger: $MemoryTriggerRel"
        "Saved batch map: $BatchMapRel"
        "Saved scaffolds/ladders: $ScaffoldRel"
        "Saved links/resources: $LinksRel"
        "Saved firing card: $FiringCardRel"
        "Saved TODO: $TodoRel"
        "Receipt: $ReceiptRel"
        "Promotion: none"
        "Authority changes: none"
        "Next allowed move: use the whole-group batch map before creating more individual alarm repair targets and gather real firing evidence."
        "Blocked: no cabinet promotion, no memory-as-proof, no skipped revision, no orphan artifacts, no doctrine/guide/index rewrite, no automation install."
    ) -join "`n"

    Write-CleanText -Path $StatusPath -Text ($ExistingStatus + $StatusAppend + "`n")

    $DiffCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --check 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Working diff --check failed.`n$($DiffCheck | Out-String)"
    }

    Run-Git @(
        "add","--",
        "ACTIVE_ANCHOR.txt",
        "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md",
        $MemoryTriggerRel,
        $BatchMapRel,
        $ScaffoldRel,
        $LinksRel,
        $FiringCardRel,
        $TodoRel
    ) | Out-Null

    Run-Git @("add","-f","--",$ReceiptRel) | Out-Null

    $CachedCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --cached --check 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Cached diff --check failed.`n$($CachedCheck | Out-String)"
    }

    Run-Git @("commit","-m","Add alarm debugger whole group batch map") | Out-Null

    $NewHead = (Run-Git @("rev-parse","HEAD") | Out-String).Trim()

    Run-Git @("push","origin","main") | Out-Null

    $FinalStatus = (Run-Git @("status","--short") | Out-String).Trim()
    if ($FinalStatus) {
        throw "Final status is not clean.`n$FinalStatus"
    }

    $RemoteHead = ((Run-Git @("ls-remote","origin","refs/heads/main") | Out-String).Trim() -split "\s+")[0]
    if ($RemoteHead -ne $NewHead) {
        throw "Remote mismatch. Local $NewHead / Remote $RemoteHead"
    }

    $BatchHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($BatchMapRel -replace "/","\"))).Hash
    $ScaffoldHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($ScaffoldRel -replace "/","\"))).Hash
    $LinksHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($LinksRel -replace "/","\"))).Hash
    $ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($ReceiptRel -replace "/","\"))).Hash

    Write-Host "ALARM DEBUGGER WHOLE-GROUP BATCH SAVE COMPLETE"
    Write-Host "Old base: $ExpectedBase"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Status: clean"
    Write-Host "Batch map: $BatchMapRel"
    Write-Host "Batch map SHA256: $BatchHash"
    Write-Host "Scaffolds/ladders: $ScaffoldRel"
    Write-Host "Scaffolds/ladders SHA256: $ScaffoldHash"
    Write-Host "Links/resources: $LinksRel"
    Write-Host "Links/resources SHA256: $LinksHash"
    Write-Host "Receipt: $ReceiptRel"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Verdict: PASS WITH GUARDRAILS / WHOLE-GROUP ALARM DEBUGGER BATCH MAP SAVED / NO PROMOTION"
}
