& {
    $ErrorActionPreference = "Stop"

    Remove-Item Function:\Git -ErrorAction SilentlyContinue

    $Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $ExpectedBase = "17e27ef27009e1cce4df7b100f6c4c18e144399f"

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
        throw "Repo dirty before checkpoint save. Stop.`n$PreStatus"
    }

    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DateOnly = Get-Date -Format "yyyyMMdd"

    $CheckpointRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/SCOPE_FORM_ALARM_GROWTH_CURRENT_ROUTE_CHECKPOINT_$Stamp.md"
    $NextRouteRel = "HOUSE_WORK/TODO/SCOPE_FORM_ALARM_GROWTH_NEXT_ROUTE_TODO_$Stamp.md"
    $ReceiptRel = "PROOF_HISTORY/SCOPE_FORM_ALARM_GROWTH_ROUTE_CHECKPOINT_RECEIPT_$Stamp.txt"

    $CheckpointPath = Join-Path $Repo ($CheckpointRel -replace "/","\")
    $NextRoutePath = Join-Path $Repo ($NextRouteRel -replace "/","\")
    $ReceiptPath = Join-Path $Repo ($ReceiptRel -replace "/","\")

    foreach ($Path in @($CheckpointPath,$NextRoutePath,$ReceiptPath)) {
        New-Item -ItemType Directory -Force -Path (Split-Path $Path) | Out-Null
    }

    $Checkpoint = @"
# Scope / Form / Alarm / Growth Current Route Checkpoint

Date: $Stamp

Base:

$ExpectedBase

## Purpose

This checkpoint consolidates the current route after several rule and method saves.

It prevents the house from continuing into more branches without a clean current-position map.

## Current scope

This is the project to build Clean Seed.

It is not the final Clean Seed Build.

Project-related rules, methods, boundaries, workflows, repairs, and recurring instructions belong in the project house with local plus Git proof when accepted.

Chat and memory may carry the assistant temporarily, but accepted project material must land in Mr.Kleen.

## Form discipline

Even though the scope shifted, form still matters.

The current project may be messy and growing, but it must keep skeleton, spine, lanes, source custody, proof boundaries, phase awareness, artifact scope, and later compression routes.

The project is not the final thing, but it must be handled as if form matters now.

## Recent saved supports

Project scope / rule placement repair:

- BRAIN_LEARNING/PROJECT_RULE_PLACEMENT_NO_CHAT_RULES_RULE_20260522.md
- BRAIN_LEARNING/PROJECT_TO_BUILD_CLEAN_SEED_SCOPE_BOUNDARY_RULE_20260522.md
- PROOF_HISTORY/PROJECT_SCOPE_RULE_PLACEMENT_REPAIR_RECEIPT_20260522_052118.txt

Build keeps form addendum:

- BRAIN_LEARNING/BUILD_KEEPS_FORM_CONCEPTUAL_SAME_TREATMENT_RULE_20260522.md
- PROOF_HISTORY/BUILD_KEEPS_FORM_CONCEPTUAL_SAME_TREATMENT_RECEIPT_20260522_052540.txt

Alarm/debugger cabinet:

- HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_20260522.md
- HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_WHOLE_GROUP_BATCH_REPAIR_MAP_20260522_051437.md
- HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/SCAFFOLDS_AND_LADDERS/ALARM_DEBUGGER_SCAFFOLDS_AND_LADDERS_20260522_051437.md
- HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_RESOURCE_AND_EVIDENCE_LINK_MAP_20260522_051437.md

Full method stack:

- BRAIN_LEARNING/COMPLETION_REVISION_SECOND_PASS_EDITING_RULE_20260522.md
- BRAIN_LEARNING/LINKING_PAPERS_EVIDENCE_CHAIN_RULE_20260522.md
- BRAIN_LEARNING/LOCAL_GIT_SAVE_TRIGGER_RULE_20260522.md
- BRAIN_LEARNING/MULE_FILING_CABINET_DEEP_HANDOFF_METHOD_RULE_20260522.md

## Current active interpretation

1. Durable project instructions are house material, not chat rules.
2. Memory updates are cues that house material may need a local plus Git save.
3. The build can accept useful bloat during growth, but not formless bloat.
4. Alarm friction must match the growth stage.
5. Blockers still matter for authority drift, false PASS, dirty save, destructive action, promotion errors, source/lane corruption, and proof loss.
6. Broad words are useful when they cover the concept family without becoming vague.
7. Powerplays are later compression moves that collapse several issues into dense growth.
8. Whirlpool should not delete bloat by default.
9. Completion requires second-pass revision and paper-link/evidence-chain checks.
10. Long scripts should be delivered as files with short launchers to avoid screen/scroll damage.

## Current next lane

Use the alarm/debugger cabinet and full method stack in live work.

Do not make more loose rule piles.

When the next issue appears:

1. Classify the alarm group.
2. Decide severity by phase.
3. Use the filing cabinet.
4. Revise before saving.
5. Link papers and proof.
6. Save local plus Git if durable project material.
7. Park what is not current-fit.

## Blocked

No doctrine rewrite.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No automation install.

No broad Whirlpool run for cosmetic cleanup.

No promotion from candidate material without separate proof route.

No treating mule output, memory, chat, or source ore as authority by itself.
"@

    $NextRoute = @"
# Scope / Form / Alarm / Growth Next Route TODO

Date: $Stamp

## Current base

$ExpectedBase

## Next best move

Continue normal project work using the new method stack.

Do not open a new broad branch unless a real task requires it.

## When a project instruction appears

1. Check whether it is already represented in the house.
2. If absent, incomplete, too narrow, or not expressed in the durable concept, save or repair it.
3. If not current-fit, park it.
4. Use local plus Git proof for durable material.
5. Preserve form: lane, source, proof, phase, artifact scope, and next route.

## When an alarm appears

1. Identify the alarm group.
2. Assign severity for the current phase.
3. If BLOCKER, stop and repair/route.
4. If WARNING, name the risk and continue only with guardrails.
5. If WATCH, preserve useful mess without overblocking growth.

## When producing a durable file

1. Draft.
2. Revise.
3. Check links/papers.
4. Check scope.
5. Check no live-instruction injection.
6. Check no false linearity.
7. Save local plus Git if accepted into the house.

## Hold

Wait for either:

1. A real next project task.
2. Mule return.
3. A failure/alarm that needs classification.
4. A concrete build artifact that needs save/revision.
"@

    $Receipt = @"
SCOPE / FORM / ALARM / GROWTH ROUTE CHECKPOINT RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Saved files:
$CheckpointRel
$NextRouteRel

Verdict:
PASS WITH GUARDRAILS / CURRENT ROUTE CHECKPOINT SAVED / NO PROMOTION

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No broad Whirlpool run.
No promotion.
No authority transfer.

Purpose:
Consolidate current scope, form, alarm cabinet, growth-stage, save-trigger, revision, and linking rules into a current route map before more branching.
"@

    Write-CleanText -Path $CheckpointPath -Text ($Checkpoint + "`n")
    Write-CleanText -Path $NextRoutePath -Text ($NextRoute + "`n")
    Write-CleanText -Path $ReceiptPath -Text ($Receipt + "`n")

    $AnchorPath = Join-Path $Repo "ACTIVE_ANCHOR.txt"
    $Anchor = @"
ACTIVE ANCHOR

Current position:
main after scope/form/alarm/growth current-route checkpoint

Base before save:
main @ 17e27ef

Saved:
Scope/Form/Alarm/Growth current route checkpoint.
Next route TODO.
Receipt.

Verdict:
PASS WITH GUARDRAILS / CURRENT ROUTE CHECKPOINT SAVED / NO PROMOTION

Next allowed move:
Continue normal project work using the full method stack. When the next issue appears, classify it by alarm group, phase severity, and house placement. Save durable project material locally and to Git.

Blocked:
Do not open broad new rule piles without a real task.
Do not run broad Whirlpool for cosmetic cleanup.
Do not treat chat, memory, mule output, or source ore as authority by itself.
Do not rewrite doctrine.
Do not rewrite ACTIVE_GUIDES.
Do not rewrite CURRENT_TRUTH_INDEX.
Do not install automation.
Do not promote without separate proof.
"@

    Write-CleanText -Path $AnchorPath -Text ($Anchor + "`n")

    $StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $ExistingStatus = Get-Content -LiteralPath $StatusPath -Raw
    if (-not $ExistingStatus.EndsWith("`n")) {
        $ExistingStatus += "`n"
    }

    $StatusAppend = @(
        ""
        "## $DateOnly — Scope/Form/Alarm/Growth Current Route Checkpoint"
        ""
        "Base before save: main @ 17e27ef"
        "Full base hash: $ExpectedBase"
        "State: PASS WITH GUARDRAILS / CURRENT ROUTE CHECKPOINT SAVED / NO PROMOTION"
        "Saved checkpoint: $CheckpointRel"
        "Saved next route TODO: $NextRouteRel"
        "Receipt: $ReceiptRel"
        "Promotion: none"
        "Authority changes: none"
        "Next allowed move: continue normal project work using full method stack; classify future issues by alarm group, phase severity, and house placement."
        "Blocked: no broad rule piles without a real task, no cosmetic Whirlpool, no chat/memory/mule/source-ore authority, no doctrine/guide/index rewrite, no automation install, no promotion without proof."
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
        $CheckpointRel,
        $NextRouteRel
    ) | Out-Null

    Run-Git @("add","-f","--",$ReceiptRel) | Out-Null

    $CachedCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --cached --check 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Cached diff --check failed.`n$($CachedCheck | Out-String)"
    }

    Run-Git @("commit","-m","Add scope form alarm growth route checkpoint") | Out-Null

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

    $CheckpointHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CheckpointPath).Hash
    $ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

    Write-Host "SCOPE/FORM/ALARM/GROWTH CHECKPOINT SAVE COMPLETE"
    Write-Host "Old base: $ExpectedBase"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Status: clean"
    Write-Host "Checkpoint: $CheckpointRel"
    Write-Host "Checkpoint SHA256: $CheckpointHash"
    Write-Host "Receipt: $ReceiptRel"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Verdict: PASS WITH GUARDRAILS / CURRENT ROUTE CHECKPOINT SAVED / NO PROMOTION"
}
