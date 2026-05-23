& {
    $ErrorActionPreference = "Stop"

    Remove-Item Function:\Git -ErrorAction SilentlyContinue

    $Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $ExpectedBase = "f62bd3d9a49e0ee9604861c91e7e945cb6073ace"

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
        throw "Repo dirty before save. Stop.`n$PreStatus"
    }

    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DateOnly = Get-Date -Format "yyyyMMdd"

    $SaveTriggerRel = "BRAIN_LEARNING/LOCAL_GIT_SAVE_TRIGGER_RULE_$DateOnly.md"
    $MuleMethodRel = "BRAIN_LEARNING/MULE_FILING_CABINET_DEEP_HANDOFF_METHOD_RULE_$DateOnly.md"
    $RevisionRel = "BRAIN_LEARNING/COMPLETION_REVISION_SECOND_PASS_EDITING_RULE_$DateOnly.md"
    $LinkingRel = "BRAIN_LEARNING/LINKING_PAPERS_EVIDENCE_CHAIN_RULE_$DateOnly.md"
    $TemplateRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/HANDOFF_METHODS/MULE_FILING_CABINET_DEEP_HANDOFF_TEMPLATE_$DateOnly.md"
    $DissectionRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/MULE_FILING_SAVE_REVISION_LINKING_METHOD_DISSECTION_$Stamp.md"
    $TodoRel = "HOUSE_WORK/TODO/MULE_FILING_SAVE_REVISION_LINKING_METHOD_TODO_$Stamp.md"
    $ReceiptRel = "PROOF_HISTORY/MULE_FILING_SAVE_REVISION_LINKING_METHOD_RECEIPT_$Stamp.txt"

    $AllRel = @(
        $SaveTriggerRel,
        $MuleMethodRel,
        $RevisionRel,
        $LinkingRel,
        $TemplateRel,
        $DissectionRel,
        $TodoRel,
        $ReceiptRel
    )

    foreach ($Rel in $AllRel) {
        $Full = Join-Path $Repo ($Rel -replace "/","\")
        New-Item -ItemType Directory -Force -Path (Split-Path $Full) | Out-Null
    }

    $SaveTrigger = @"
# Local + Git Save Trigger Rule

Date: $Stamp

Status: active save-discipline rule.

## Rule

Any durable house-relevant material must be saved to the local Mr.Kleen house and pushed to Git when it is accepted into the house.

This trigger fires from the work type itself.

It must not depend on the user saying save.

## Triggers

This applies to durable house material, including:

1. Rules.
2. Methods.
3. Handoff processes.
4. Receipts.
5. Proof results.
6. Current-position notes.
7. Candidate systems.
8. Lessons from problems.
9. Mule or helper process standards.
10. Alarm/debugger filing structures.
11. Parking decisions.
12. Phase-boundary decisions.
13. Growth-stage operating behavior.
14. Editing/revision methods.
15. Linking-paper/evidence-chain methods.

## Save proof

A valid save must:

1. Verify repo.
2. Verify branch and base.
3. Verify remote base when relevant.
4. Verify clean status before write.
5. Write files to correct lanes.
6. Write a receipt.
7. Stage expected files.
8. Force-add ignored proof receipts when intentionally saving proof.
9. Run diff checks.
10. Commit.
11. Push.
12. Confirm remote HEAD matches local HEAD.
13. Confirm final status clean.

## Exceptions

Do not save when the user explicitly says not to save.

Do not save when blocked by safety, dirty state, wrong base, missing proof, unclear authority, destructive risk, or wrong phase.

When blocked, stop and name the blocker.

## Boundary

This rule does not promote material.

This rule does not rewrite doctrine.

This rule does not rewrite ACTIVE_GUIDES.

This rule does not rewrite CURRENT_TRUTH_INDEX.
"@

    $MuleMethod = @"
# Mule Filing-Cabinet Deep Handoff Method Rule

Date: $Stamp

Status: active handoff-method rule.

## Rule

Deep mule or helper work must be handed off as a filing-cabinet task room, not as a loose request.

The handoff must explain what the work is trying to become, what files and lanes matter, what boundaries apply, what phases to run, what clean bloat is desired, what final sweep is required, and what return files must come back.

## Task-room contents

A deep handoff should contain:

1. Mission.
2. Current base.
3. Scope.
4. Required read-first files.
5. Allowed search lanes.
6. Starting structure.
7. Known recent lessons.
8. Required work phases.
9. Desired clean-bloat behavior.
10. Final sweep requirements.
11. Return-file requirements.
12. Boundaries.
13. Verdict options.
14. What must not be promoted.

## Filing-cabinet standard

For classification work, require:

1. Primary home.
2. Cross-links.
3. Protected damage type.
4. Severity.
5. Phase where it matters most.
6. Proof that it fired or failed.
7. Current status.
8. Weakness.
9. Next tightening move.

## Clean-bloat standard

Clean bloat is useful added coverage.

It may name missing failure families, preserve source pressure, add useful variants, support future Whirlpool compression, or improve proof, routing, recovery, authority boundaries, and phase handling.

Clean bloat is not random noise.

## Deep-review phases

A deep filing-cabinet handoff should usually require:

1. Understand the mission.
2. Inspect the starting structure.
3. Deep-dive through relevant house material.
4. Add clean bloat.
5. Mix from start to finish.
6. Run a final hard sweep.

## Boundary

A mule handoff is not authority.

A mule return is not authority.

The house later decides whether to save, test, park, revise, or promote through a separate proof route.
"@

    $Revision = @"
# Completion Revision / Second-Pass Editing Rule

Date: $Stamp

Status: active completion-quality rule.

## Rule

After completing any durable artifact, script, rule package, handoff, report, save block, packet, or house file, the assistant must perform a real second-pass revision before delivery or save.

This is not optional polish.

It is part of completion.

## What the revision pass checks

The revision pass must check:

1. Is the work complete for the requested task?
2. Is the scope correct?
3. Is the wording clean enough for the current phase?
4. Did the work accidentally inject live task instructions into the artifact?
5. Did the work overfit to the current chat or current route?
6. Did it create false linearity in a circular/recursive system?
7. Did it preserve authority boundaries?
8. Did it preserve source, proof, and recovery links?
9. Did it include necessary receipts, hashes, base, and next route when relevant?
10. Did it leave out an obvious stronger structure?
11. Did a deeper second look reveal missing ideas, missing solutions, or better grouping?
12. Did it use the filing cabinet or closest prior template when applicable?

## Deeper attempt requirement

The assistant must make one real deeper attempt after the first draft.

This means looking again for:

1. Better grouping.
2. Missing failure families.
3. Cleaner wording.
4. Stronger proof chain.
5. Better lane placement.
6. Needed cross-links.
7. Unnecessary bloat.
8. Useful bloat that should remain.
9. False promotion language.
10. Missing blocked moves.

## Current-stage standard

During messy growth, the revision pass does not need to make everything final-clean.

It must make the work clean enough, correctly placed, broad enough where coverage is needed, and safe enough for the house.

Final wrap polish happens later.
"@

    $Linking = @"
# Linking Papers / Evidence Chain Rule

Date: $Stamp

Status: active evidence-chain rule.

## Rule

Durable house work must preserve its paper trail.

A saved object should not become an orphan.

When relevant, it must name or link its source, upstream handoff, base commit, proof receipt, hash, return file, related TODO, and next route.

## Evidence chain standard

A durable artifact should answer:

1. What did this come from?
2. What base was checked?
3. What files or source material support it?
4. What receipt proves it was saved?
5. What hash identifies it?
6. What does it support?
7. What lane owns it?
8. What is the next allowed move?
9. What is blocked?
10. What should not be promoted?

## Handoff chain standard

A mule or helper handoff should link:

1. The base.
2. The mission.
3. Read-first files.
4. Search lanes.
5. Return location.
6. Required output files.
7. Boundaries.
8. Receipt and SHA256 when created.

A mule or helper return intake should link:

1. Source return path.
2. Copied house path.
3. Manifest.
4. Receipt.
5. Hashes.
6. Base before save.
7. Final local/remote proof.

## Clean linking

Do not overstuff unrelated context.

Link the papers needed to understand custody, proof, source, and next movement.

The goal is chain-of-custody, not clutter.
"@

    $Template = @"
# Mule Filing-Cabinet Deep Handoff Template

Date: $Stamp

Status: Gear Rack handoff method template.

## Required sections

1. Job ID.
2. Current base.
3. Mission.
4. Scope.
5. Core idea.
6. Starting structure.
7. Required read-first files.
8. Allowed search lanes.
9. Required work phases.
10. Clean-bloat instructions.
11. Final sweep instructions.
12. Output files required.
13. Report section requirements.
14. Verdict options.
15. Boundaries.
16. Evidence-chain links.

## Completion requirements

Before sending the handoff, revise it.

Check:

1. It has a clear mission.
2. It names the base.
3. It names the files and lanes.
4. It tells the helper what the work is trying to become.
5. It requests a final sweep.
6. It requests return files.
7. It preserves boundaries.
8. It avoids promotion.
9. It preserves the paper trail.
"@

    $Dissection = @"
# Mule Filing, Save Trigger, Revision, and Linking Method Dissection

Date: $Stamp

Base:

$ExpectedBase

## Purpose

This save captures the full method stack that was missing from the earlier mule filing method:

1. Mule filing-cabinet deep handoff method.
2. Local + Git save trigger.
3. Completion revision / second-pass editing rule.
4. Linking papers / evidence-chain rule.

## Why this matters

The previous method had a final sweep, but it did not explicitly make revision and evidence linking mandatory across durable work.

That was incomplete.

This package makes completion mean more than producing a first draft.

Completion now requires a second-pass quality check and a paper trail.

## Fit verdict

PASS WITH GUARDRAILS.

This is an operating-method package.

It does not rewrite doctrine.

It does not rewrite ACTIVE_GUIDES.

It does not rewrite CURRENT_TRUTH_INDEX.

It does not install automation.

It does not promote mule output.
"@

    $Todo = @"
# Mule Filing / Save Trigger / Revision / Linking TODO

Date: $Stamp

## Current state

The method stack has been saved as active behavior material:

1. Local + Git Save Trigger.
2. Mule Filing-Cabinet Deep Handoff Method.
3. Completion Revision / Second-Pass Editing.
4. Linking Papers / Evidence Chain.

## Use next

Use the full stack on the next durable house-relevant artifact or handoff.

## Watch

1. Do not deliver first drafts as final house material.
2. Do not leave artifacts orphaned from their receipts or source.
3. Do not skip Git push for durable house saves.
4. Do not stuff live instructions into artifacts.
5. Do not make false linear gates.
6. Do not use final-wrap strictness during messy growth.
7. Do not treat mule output as authority.

## Blocked

No doctrine rewrite.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No automation install.

No promotion without a separate proof route.
"@

    $Receipt = @"
MULE FILING / SAVE TRIGGER / REVISION / LINKING METHOD RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Saved files:
$SaveTriggerRel
$MuleMethodRel
$RevisionRel
$LinkingRel
$TemplateRel
$DissectionRel
$TodoRel

Verdict:
PASS WITH GUARDRAILS / FULL METHOD STACK SAVED / NO PROMOTION

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No promotion.
No authority transfer.

Key correction:
The editing/revision rule and linking-papers/evidence-chain rule are now explicit parts of durable completion, not optional afterthoughts.
"@

    $Map = [ordered]@{
        $SaveTriggerRel = $SaveTrigger
        $MuleMethodRel = $MuleMethod
        $RevisionRel = $Revision
        $LinkingRel = $Linking
        $TemplateRel = $Template
        $DissectionRel = $Dissection
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
main after mule filing, save trigger, revision, and linking method save

Base before save:
main @ f62bd3d

Saved:
Local + Git Save Trigger.
Mule Filing-Cabinet Deep Handoff Method.
Completion Revision / Second-Pass Editing Rule.
Linking Papers / Evidence Chain Rule.
Gear Rack mule filing handoff template.
Dissection, TODO, and receipt.

Verdict:
PASS WITH GUARDRAILS / FULL METHOD STACK SAVED / NO PROMOTION

Next allowed move:
Use the full method stack on durable house-relevant work: save locally and to Git, revise before delivery/save, and preserve evidence links.

Blocked:
Do not skip revision for durable work.
Do not leave artifacts orphaned.
Do not skip Git push for durable house saves.
Do not treat mule output as authority.
Do not rewrite doctrine.
Do not rewrite ACTIVE_GUIDES.
Do not rewrite CURRENT_TRUTH_INDEX.
Do not install automation.
Do not promote without a separate proof route.
"@

    Write-CleanText -Path $AnchorPath -Text ($Anchor + "`n")

    $StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $ExistingStatus = Get-Content -LiteralPath $StatusPath -Raw
    if (-not $ExistingStatus.EndsWith("`n")) {
        $ExistingStatus += "`n"
    }

    $StatusAppend = @(
        ""
        "## $DateOnly — Mule Filing / Save Trigger / Revision / Linking Method Save"
        ""
        "Base before save: main @ f62bd3d"
        "Full base hash: $ExpectedBase"
        "State: PASS WITH GUARDRAILS / FULL METHOD STACK SAVED / NO PROMOTION"
        "Saved local-Git save trigger: $SaveTriggerRel"
        "Saved mule filing method: $MuleMethodRel"
        "Saved completion revision rule: $RevisionRel"
        "Saved linking papers rule: $LinkingRel"
        "Saved handoff template: $TemplateRel"
        "Saved dissection: $DissectionRel"
        "Saved TODO: $TodoRel"
        "Receipt: $ReceiptRel"
        "Promotion: none"
        "Authority changes: none"
        "Next allowed move: use the full method stack on durable house work: save local plus Git, revise before delivery/save, and preserve evidence-chain links."
        "Blocked: no skipped revision, no orphan artifacts, no skipped Git push for durable saves, no mule-output authority, no doctrine/guide/index rewrite, no automation install, no promotion without proof."
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
        $SaveTriggerRel,
        $MuleMethodRel,
        $RevisionRel,
        $LinkingRel,
        $TemplateRel,
        $DissectionRel,
        $TodoRel
    ) | Out-Null

    Run-Git @("add","-f","--",$ReceiptRel) | Out-Null

    $CachedCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --cached --check 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Cached diff --check failed.`n$($CachedCheck | Out-String)"
    }

    Run-Git @("commit","-m","Add full mule filing save revision linking method") | Out-Null

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

    $RevisionHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($RevisionRel -replace "/","\"))).Hash
    $LinkingHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($LinkingRel -replace "/","\"))).Hash
    $ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($ReceiptRel -replace "/","\"))).Hash

    Write-Host "FULL METHOD STACK SAVE COMPLETE"
    Write-Host "Old base: $ExpectedBase"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Status: clean"
    Write-Host "Revision rule: $RevisionRel"
    Write-Host "Revision SHA256: $RevisionHash"
    Write-Host "Linking rule: $LinkingRel"
    Write-Host "Linking SHA256: $LinkingHash"
    Write-Host "Receipt: $ReceiptRel"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Verdict: PASS WITH GUARDRAILS / FULL METHOD STACK SAVED / NO PROMOTION"
}
