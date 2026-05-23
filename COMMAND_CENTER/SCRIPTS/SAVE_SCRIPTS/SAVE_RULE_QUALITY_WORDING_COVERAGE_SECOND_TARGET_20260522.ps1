& {
    $ErrorActionPreference = "Stop"

    Remove-Item Function:\Git -ErrorAction SilentlyContinue

    $Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $ExpectedBase = "2ccee62dce83abc7cef16ca962e5bc4878443479"

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
        throw "Repo dirty before Rule Quality / Wording Coverage target save. Stop.`n$PreStatus"
    }

    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DateOnly = Get-Date -Format "yyyyMMdd"

    $TargetRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/REPAIR_TARGETS/RULE_QUALITY_WORDING_COVERAGE_SECOND_REPAIR_TARGET_$Stamp.md"
    $FiringCardRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/RULE_QUALITY_WORDING_COVERAGE_ALARM_FIRING_CARD_$Stamp.md"
    $TodoRel = "HOUSE_WORK/TODO/RULE_QUALITY_WORDING_COVERAGE_REPAIR_TODO_$Stamp.md"
    $ReceiptRel = "PROOF_HISTORY/RULE_QUALITY_WORDING_COVERAGE_SECOND_REPAIR_TARGET_RECEIPT_$Stamp.txt"

    $TargetPath = Join-Path $Repo ($TargetRel -replace "/","\")
    $FiringCardPath = Join-Path $Repo ($FiringCardRel -replace "/","\")
    $TodoPath = Join-Path $Repo ($TodoRel -replace "/","\")
    $ReceiptPath = Join-Path $Repo ($ReceiptRel -replace "/","\")

    foreach ($Path in @($TargetPath,$FiringCardPath,$TodoPath,$ReceiptPath)) {
        New-Item -ItemType Directory -Force -Path (Split-Path $Path) | Out-Null
    }

    $Target = @"
# Rule Quality / Wording Coverage — Second Alarm-Cabinet Repair Target

Date: $Stamp

Base:

$ExpectedBase

## Status

Alarm Debugger Cabinet repair target.

Evidence/candidate only.

No promotion.

No doctrine rewrite.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No automation install.

## Source chain

Upstream cabinet:

HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_20260522.md

Upstream first repair target:

HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/REPAIR_TARGETS/SOURCE_LANE_ARTIFACT_PLACEMENT_FIRST_REPAIR_TARGET_20260522_050405.md

Reason for this target:

The Source / Lane / Artifact Placement group was repaired first because it failed visibly when live task instruction was injected into artifact content.

This second repair target handles the paired weakness: rule quality and wording coverage.

## Repair target group

Rule Quality / Wording Coverage Alarms.

Primary alarms:

1. Broad Words / Concept-Family Coverage Alarm.
2. Vague Rule Alarm.
3. False Linearity Alarm.
4. Revise Rule Alarm.
5. Overfit-to-Current-Route Alarm.

## Damage this group prevents

This group prevents rules and artifacts from becoming:

1. Too narrow to catch neighboring failure forms.
2. Too vague to guide action.
3. Falsely linear in a recursive/circular build.
4. Overfit to the current chat, tool, route, correction, or assistant mistake.
5. Saved too rough because the revision rule did not fire.
6. Bloated with current-task mechanics instead of durable concept.
7. Clean-looking but operationally weak.
8. Broad in wording but unclear in use.
9. Compressed before coverage is understood.
10. Detached from the evidence chain.

## Current known failure evidence

The assistant previously took live user instruction and injected it into artifact content.

That was a Source / Lane failure and also a Rule Quality failure.

The rule quality part was:

1. Overfit to current route.
2. False linearity risk.
3. Failure to revise deeply before save.
4. Failure to separate directive from durable concept.
5. Weak Filing Cabinet use before delivery.

## Phase-weighted severity

Current phase:

Messy active growth / useful-bloat tolerated.

Default severity:

WARNING.

Escalates to BLOCKER when writing durable house material, handoffs, rules, receipts, current-position notes, proof claims, authority-adjacent files, or save scripts.

WATCH when in loose ideation or source-ore discussion.

## Better alarm definition for this group

A better Rule Quality / Wording Coverage alarm fires when wording would reduce the house's ability to act cleanly.

It should detect:

1. Narrow phrase capture.
2. Vague slogan language.
3. False one-way gate.
4. Current-route overfit.
5. Missing revision pass.
6. Missing evidence links.
7. Misplaced live instruction.
8. Premature compression.
9. Dirty bloat claiming authority.
10. Useful bloat being deleted too early.

## Firing proof standard

This group is working only if it changes output before save or delivery.

Valid proof examples:

1. It causes a draft to be revised before the user catches the issue.
2. It removes current-chat wording from a durable artifact.
3. It changes a false gate into phase-weighted wording.
4. It broadens a narrow rule to concept-family coverage.
5. It sharpens a vague sentence into actionable behavior.
6. It adds a missing evidence-chain link.
7. It blocks promotion language.
8. It parks a useful but misplaced idea instead of forcing it into the artifact.

If the user catches the issue first, the alarm was late or failed-to-fire.

## Primary repair move

Create and use a pre-save Rule Quality firing card for durable work.

Before a durable artifact or handoff is delivered or saved, ask:

1. Is this rule/artifact too narrow?
2. Is it too vague?
3. Is it falsely linear?
4. Is it overfit to the current route?
5. Did live instruction get copied into the artifact?
6. Did the revision pass actually happen?
7. Did the evidence-chain links survive?
8. Is the bloat useful coverage or dirty authority fog?
9. Is the wording right for the current growth phase?
10. Should anything be parked instead of injected?

## Relationship to previous saved rules

Supports:

BRAIN_LEARNING/COMPLETION_REVISION_SECOND_PASS_EDITING_RULE_20260522.md

Supports:

BRAIN_LEARNING/LINKING_PAPERS_EVIDENCE_CHAIN_RULE_20260522.md

Supports:

BRAIN_LEARNING/DIRECTIVE_TO_ARTIFACT_SEPARATION_RULE_20260522.md

Supports:

BRAIN_LEARNING/BROAD_WORDS_CONCEPT_FAMILY_COVERAGE_RULE_20260522.md

Supports:

BRAIN_LEARNING/CLEAN_SEED_BUILD_VS_OTHER_NOISE_PHASE_BOUNDARY_RULE_20260522.md

## Verdict

PASS WITH GUARDRAILS / SECOND ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION

## Next suggested target

Tool / Script / Copy Safety Alarms.

Reason:

Recent work still produced paste-fence trash and heavy code-box friction. The delivery method improved with downloadable scripts, but the group needs a clean firing card so local execution support does not keep causing avoidable friction.
"@

    $FiringCard = @"
# Rule Quality / Wording Coverage Alarm Firing Card

Date: $Stamp

Base:

$ExpectedBase

## Purpose

This card is the point-of-work alarm check for durable house writing.

Use it before delivering or saving durable artifacts, rules, handoffs, reports, receipts, scripts, packets, or current-position notes.

## Fast firing check

Before delivery/save, ask:

1. Too narrow?
2. Too vague?
3. Falsely linear?
4. Overfit to current route?
5. Live instruction injected?
6. Revision pass performed?
7. Evidence-chain links present?
8. Useful bloat preserved?
9. Dirty bloat blocked from authority?
10. Correct phase strictness?

## Classification

If the work is casual chat:

WATCH unless it creates durable house material.

If the work is a durable artifact:

WARNING minimum.

If the work touches authority, proof, save, handoff, mule, current status, or rule material:

BLOCKER until the card is checked.

## PASS conditions

This card passes when:

1. The durable concept is written at concept/failure-family level.
2. Current task mechanics are not pasted as the rule.
3. Wording is actionable.
4. Circular/recursive flow is preserved unless a real gate exists.
5. Required links and proof references are named.
6. The revision rule has been used.
7. The result is clean enough for the current growth phase.

## Fail states

FAILED-TO-FIRE:

The user catches overfit, vagueness, false linearity, or missing revision before the assistant catches it.

LATE:

The issue is found only after save/delivery.

PARTIAL:

The issue is named but not fixed or parked.

WORKING:

The issue is caught and corrected before delivery/save.

## Boundary

This card does not promote any rule.

This card does not rewrite doctrine.

This card does not rewrite ACTIVE_GUIDES.

This card does not rewrite CURRENT_TRUTH_INDEX.

This card only improves firing quality for durable house writing.
"@

    $Todo = @"
# Rule Quality / Wording Coverage Repair TODO

Date: $Stamp

## Current state

Second Alarm Debugger Cabinet repair target saved.

Group:

Rule Quality / Wording Coverage Alarms.

## Next uses

Use the firing card on the next durable house artifact or handoff.

Classify the alarm result as:

1. WORKING.
2. PARTIAL.
3. LATE.
4. FAILED-TO-FIRE.
5. DECORATIVE / NO PROOF.

## Watch points

1. Do not let live user instruction become artifact content.
2. Do not let broad wording become vague wording.
3. Do not let recursive growth become false linearity.
4. Do not save without a second-pass revision.
5. Do not leave papers unlinked.
6. Do not overcompress useful bloat during active growth.
7. Do not let dirty bloat claim authority.

## Likely next cabinet repair target

Tool / Script / Copy Safety Alarms.

Reason:

Local execution and paste ergonomics have caused repeated avoidable friction.
"@

    $Receipt = @"
RULE QUALITY / WORDING COVERAGE SECOND REPAIR TARGET RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Saved target:
$TargetRel

Saved firing card:
$FiringCardRel

Saved TODO:
$TodoRel

Verdict:
PASS WITH GUARDRAILS / SECOND ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION

Source chain:
HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_20260522.md
HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/REPAIR_TARGETS/SOURCE_LANE_ARTIFACT_PLACEMENT_FIRST_REPAIR_TARGET_20260522_050405.md
BRAIN_LEARNING/COMPLETION_REVISION_SECOND_PASS_EDITING_RULE_20260522.md
BRAIN_LEARNING/LINKING_PAPERS_EVIDENCE_CHAIN_RULE_20260522.md

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No promotion.
No authority transfer.

Next suggested target:
Tool / Script / Copy Safety Alarms.
"@

    Write-CleanText -Path $TargetPath -Text ($Target + "`n")
    Write-CleanText -Path $FiringCardPath -Text ($FiringCard + "`n")
    Write-CleanText -Path $TodoPath -Text ($Todo + "`n")
    Write-CleanText -Path $ReceiptPath -Text ($Receipt + "`n")

    $AnchorPath = Join-Path $Repo "ACTIVE_ANCHOR.txt"
    $Anchor = @"
ACTIVE ANCHOR

Current position:
main after Rule Quality / Wording Coverage second alarm-cabinet repair target save

Base before save:
main @ 2ccee62

Saved:
Rule Quality / Wording Coverage second repair target.
Rule Quality / Wording Coverage firing card.
Followup TODO and receipt.

Verdict:
PASS WITH GUARDRAILS / SECOND ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION

Next allowed move:
Use the firing card on the next durable house artifact or handoff. Likely next cabinet target is Tool / Script / Copy Safety.

Blocked:
Do not promote the repair target.
Do not rewrite doctrine.
Do not rewrite ACTIVE_GUIDES.
Do not rewrite CURRENT_TRUTH_INDEX.
Do not install automation.
Do not skip revision or evidence-chain links on durable house work.
"@

    Write-CleanText -Path $AnchorPath -Text ($Anchor + "`n")

    $StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $ExistingStatus = Get-Content -LiteralPath $StatusPath -Raw
    if (-not $ExistingStatus.EndsWith("`n")) {
        $ExistingStatus += "`n"
    }

    $StatusAppend = @(
        ""
        "## $DateOnly — Rule Quality / Wording Coverage Second Alarm-Cabinet Repair Target"
        ""
        "Base before save: main @ 2ccee62"
        "Full base hash: $ExpectedBase"
        "State: PASS WITH GUARDRAILS / SECOND ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION"
        "Saved target: $TargetRel"
        "Saved firing card: $FiringCardRel"
        "Saved TODO: $TodoRel"
        "Receipt: $ReceiptRel"
        "Source chain: Alarm Debugger Cabinet Inventory; Source/Lane/Artifact Placement first repair target; Completion Revision rule; Linking Papers rule."
        "Promotion: none"
        "Authority changes: none"
        "Next allowed move: use the firing card on the next durable house artifact or handoff; likely next cabinet target is Tool / Script / Copy Safety."
        "Blocked: no doctrine/guide/index rewrite, no automation install, no promotion, no skipped revision, no orphan artifacts."
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
        $TargetRel,
        $FiringCardRel,
        $TodoRel
    ) | Out-Null

    Run-Git @("add","-f","--",$ReceiptRel) | Out-Null

    $CachedCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --cached --check 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Cached diff --check failed.`n$($CachedCheck | Out-String)"
    }

    Run-Git @("commit","-m","Add rule quality alarm repair target") | Out-Null

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

    $TargetHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $TargetPath).Hash
    $FiringCardHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $FiringCardPath).Hash
    $ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

    Write-Host "RULE QUALITY / WORDING COVERAGE TARGET SAVE COMPLETE"
    Write-Host "Old base: $ExpectedBase"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Status: clean"
    Write-Host "Target: $TargetRel"
    Write-Host "Target SHA256: $TargetHash"
    Write-Host "Firing card: $FiringCardRel"
    Write-Host "Firing card SHA256: $FiringCardHash"
    Write-Host "Receipt: $ReceiptRel"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Verdict: PASS WITH GUARDRAILS / SECOND ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION"
}