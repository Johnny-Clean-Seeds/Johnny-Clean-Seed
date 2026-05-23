& {
    $ErrorActionPreference = "Stop"

    Remove-Item Function:\Git -ErrorAction SilentlyContinue

    $Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $ExpectedBase = "446689fb420e001e2215c1339cc21072964fc6f0"

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
        throw "Repo dirty before first alarm repair target save. Stop.`n$PreStatus"
    }

    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DateOnly = Get-Date -Format "yyyyMMdd"

    $CabinetRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_20260522.md"
    $CabinetReceiptRel = "PROOF_HISTORY/ALARM_DEBUGGER_FILING_CABINET_INVENTORY_SAVE_RECEIPT_20260522_050130.txt"

    $CabinetPath = Join-Path $Repo ($CabinetRel -replace "/","\")
    $CabinetReceiptPath = Join-Path $Repo ($CabinetReceiptRel -replace "/","\")

    if (-not (Test-Path $CabinetPath)) {
        throw "Alarm debugger cabinet inventory missing: $CabinetRel"
    }

    if (-not (Test-Path $CabinetReceiptPath)) {
        throw "Alarm debugger cabinet receipt missing: $CabinetReceiptRel"
    }

    $CabinetHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CabinetPath).Hash
    $CabinetReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CabinetReceiptPath).Hash

    $TargetRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/REPAIR_TARGETS/SOURCE_LANE_ARTIFACT_PLACEMENT_FIRST_REPAIR_TARGET_$Stamp.md"
    $FiringCardRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/SOURCE_LANE_ARTIFACT_PLACEMENT_ALARM_FIRING_CARD_$Stamp.md"
    $TodoRel = "HOUSE_WORK/TODO/SOURCE_LANE_ARTIFACT_PLACEMENT_ALARM_REPAIR_TODO_$Stamp.md"
    $ReceiptRel = "PROOF_HISTORY/SOURCE_LANE_ARTIFACT_PLACEMENT_FIRST_REPAIR_TARGET_RECEIPT_$Stamp.txt"

    $TargetPath = Join-Path $Repo ($TargetRel -replace "/","\")
    $FiringCardPath = Join-Path $Repo ($FiringCardRel -replace "/","\")
    $TodoPath = Join-Path $Repo ($TodoRel -replace "/","\")
    $ReceiptPath = Join-Path $Repo ($ReceiptRel -replace "/","\")

    foreach ($Path in @($TargetPath,$FiringCardPath,$TodoPath,$ReceiptPath)) {
        New-Item -ItemType Directory -Force -Path (Split-Path $Path) | Out-Null
    }

    $Target = @"
# Source / Lane / Artifact Placement — First Alarm Repair Target

Date: $Stamp

Base before save:

$ExpectedBase

## Source papers

Alarm debugger cabinet:

$CabinetRel

Cabinet SHA256:

$CabinetHash

Cabinet receipt:

$CabinetReceiptRel

Cabinet receipt SHA256:

$CabinetReceiptHash

## Why this target is first

The alarm/debugger cabinet identifies Source / Lane / Artifact Placement as the weakest important group because a recent artifact-writing failure let live task instruction bleed into artifact content.

That failure exposed a placement problem, not merely a wording problem.

The first repair target should therefore be the placement group that decides what belongs in a durable artifact, what belongs in assistant behavior, what belongs in parking, and what must remain source-only.

## Protected damage type

This group protects against:

1. Live task instructions becoming artifact content.
2. Source ore being treated as active rule material.
3. Parked material leaking into current build authority.
4. Mule or helper output being treated as authority.
5. Other Noise entering Clean Seed Build lanes too early.
6. Artifact scope expanding beyond the requested object.
7. Current-route mechanics being frozen as permanent rules.
8. False linear gates being created from temporary workflow.
9. Durable files losing their source/proof context.
10. Candidate material being written as if promoted.

## Primary alarms in this group

1. Source/Lane Corruption Alarm.
2. Directive-to-Artifact Separation Alarm.
3. Clean Seed Build vs Other Noise Boundary.
4. Parked Material Boundary Alarm.
5. Artifact Scope Alarm.
6. Overfit-to-Current-Route Alarm.
7. Linking Papers / Evidence Chain Rule.
8. Completion Revision / Second-Pass Editing Rule.

## Phase weighting

Current phase:

Messy active growth.

Current severity:

BLOCKER when writing durable artifacts, rules, handoffs, receipts, save packets, authority-adjacent files, or house status.

WARNING during loose discussion.

WATCH when collecting source ore that has not entered the house.

## Better firing standard

This group is working only when it fires before the artifact is delivered or saved.

It should force these questions:

1. What is the artifact being made?
2. What is only a live instruction for how to perform the task?
3. What is durable concept material?
4. What belongs in parking instead of the artifact?
5. What source papers must be linked?
6. What would create false authority or false linearity?
7. What must be named as candidate, evidence, parked, blocked, or promoted?

## Current status

PARTIAL / REPAIR TARGET.

The failure has been identified and rule material has been saved, but the group still needs a live firing card and future proof that it stops the error before output.

## Next tightening move

Use the attached firing card before the next durable artifact/rule/handoff save.

If it catches and changes the output before delivery, record that as a working fire.

If the user catches the placement error again, mark the group LATE or FAILED-TO-FIRE depending on the event.
"@

    $FiringCard = @"
# Source / Lane / Artifact Placement Alarm Firing Card

Date: $Stamp

Base:

$ExpectedBase

## Use when

Use this card before creating or saving any durable:

1. Rule.
2. Method.
3. Handoff.
4. Mule packet.
5. Report.
6. Artifact.
7. Receipt package.
8. Current-status update.
9. Cabinet inventory.
10. Candidate system.

## Step 1 — Separate task directive from artifact content

Ask:

1. What did the user tell the assistant to do?
2. Which parts are instructions for assistant behavior?
3. Which parts are durable concepts that belong in the artifact?
4. Which parts are source ore that should be parked?
5. Which parts are current-route mechanics that should not become a permanent rule?

If live instructions are being copied into the artifact, stop and rewrite at concept level.

## Step 2 — Place material into the right lane

Classify each major piece as:

1. Active build material.
2. Candidate rule.
3. Evidence.
4. Parked source ore.
5. Other Noise.
6. Handoff instruction.
7. Receipt/proof material.
8. TODO/next route.
9. Blocked move.
10. Promotion request.

If a piece lacks a clean lane, park it rather than forcing it into the artifact.

## Step 3 — Check artifact scope

Ask:

1. What is this file supposed to be?
2. Does every section serve that purpose?
3. Did the artifact become a rule stack when it should be a report?
4. Did it become a linear checklist when the model needs recursive movement?
5. Did it include tool-specific details that should remain outside the durable concept?

If scope drift appears, revise before save.

## Step 4 — Link papers

For durable work, name the upstream paper trail:

1. Base commit.
2. Source file or source conversation object.
3. Upstream handoff if any.
4. Cabinet/source inventory if any.
5. Receipt path.
6. Hashes when available.
7. Downstream TODO or next route.

If the paper trail is missing, add it or stop.

## Step 5 — Final revision check

Before delivery/save, check:

1. Clean enough for current phase.
2. Not overfit to current chat wording.
3. Not falsely linear.
4. Not missing source/proof links.
5. Not claiming promotion.
6. Not injecting live task instructions.
7. Not leaving useful correction unparked.
8. Not too vague to guide action.

## Firing labels

WORKING:

The card changes the output before delivery/save.

LATE:

The user catches a placement error after output but before damage.

FAILED-TO-FIRE:

The placement error reaches a durable artifact/save and has to be repaired afterward.

PARTIAL:

Some risk is caught, but another placement issue slips through.

DECORATIVE / NO PROOF:

The card exists but there is no event showing it changed behavior.
"@

    $Todo = @"
# Source / Lane / Artifact Placement Alarm Repair TODO

Date: $Stamp

## Current state

The Source / Lane / Artifact Placement group is selected as the first alarm/debugger cabinet repair target.

Status:

PARTIAL / REPAIR TARGET / NO PROMOTION

## Next live-use test

Use the firing card before the next durable artifact, handoff, rule package, save packet, or report.

Capture whether it:

1. Stopped live instruction injection.
2. Preserved source/lane separation.
3. Prevented false linearity.
4. Required paper links.
5. Improved revision before save.

## Do not do yet

Do not promote this alarm group.

Do not rewrite ACTIVE_GUIDES.

Do not rewrite CURRENT_TRUTH_INDEX.

Do not install automation.

Do not treat this as a final alarm system.

Do not run broad Whirlpool from this target alone.
"@

    $Receipt = @"
SOURCE / LANE / ARTIFACT PLACEMENT FIRST REPAIR TARGET RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Source cabinet:
$CabinetRel

Source cabinet SHA256:
$CabinetHash

Source cabinet receipt:
$CabinetReceiptRel

Source cabinet receipt SHA256:
$CabinetReceiptHash

Saved target:
$TargetRel

Saved firing card:
$FiringCardRel

Saved TODO:
$TodoRel

Verdict:
PASS WITH GUARDRAILS / FIRST ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No broad Whirlpool run.
No promotion.
No authority transfer.

Revision pass:
The target was narrowed from the whole alarm cabinet to the highest-value failed group. The file links its source cabinet, source receipt, base commit, target, firing card, TODO, and proof receipt.

Next route:
Use the firing card before the next durable artifact or save packet, then record whether the alarm fired before delivery.
"@

    Write-CleanText -Path $TargetPath -Text ($Target + "`n")
    Write-CleanText -Path $FiringCardPath -Text ($FiringCard + "`n")
    Write-CleanText -Path $TodoPath -Text ($Todo + "`n")
    Write-CleanText -Path $ReceiptPath -Text ($Receipt + "`n")

    $AnchorPath = Join-Path $Repo "ACTIVE_ANCHOR.txt"
    $Anchor = @"
ACTIVE ANCHOR

Current position:
main after Source / Lane / Artifact Placement first alarm repair target save

Base before save:
main @ 446689f

Saved:
Source / Lane / Artifact Placement first alarm repair target.
Source / Lane / Artifact Placement firing card.
Followup TODO and receipt.

Verdict:
PASS WITH GUARDRAILS / FIRST ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION

Next allowed move:
Use the Source / Lane / Artifact Placement firing card before the next durable artifact, rule, handoff, report, or save packet and record whether it fires before delivery.

Blocked:
Do not promote this alarm group.
Do not rewrite doctrine.
Do not rewrite ACTIVE_GUIDES.
Do not rewrite CURRENT_TRUTH_INDEX.
Do not install automation.
Do not run broad Whirlpool from this target alone.
"@

    Write-CleanText -Path $AnchorPath -Text ($Anchor + "`n")

    $StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $ExistingStatus = Get-Content -LiteralPath $StatusPath -Raw
    if (-not $ExistingStatus.EndsWith("`n")) {
        $ExistingStatus += "`n"
    }

    $StatusAppend = @(
        ""
        "## $DateOnly — Source / Lane / Artifact Placement First Alarm Repair Target"
        ""
        "Base before save: main @ 446689f"
        "Full base hash: $ExpectedBase"
        "State: PASS WITH GUARDRAILS / FIRST ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION"
        "Source cabinet: $CabinetRel"
        "Source cabinet SHA256: $CabinetHash"
        "Source cabinet receipt: $CabinetReceiptRel"
        "Saved target: $TargetRel"
        "Saved firing card: $FiringCardRel"
        "Saved TODO: $TodoRel"
        "Receipt: $ReceiptRel"
        "Promotion: none"
        "Authority changes: none"
        "Next allowed move: use the firing card before the next durable artifact/save packet and record firing quality."
        "Blocked: no doctrine/guide/index rewrite, no automation install, no promotion, no broad Whirlpool from this target alone."
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

    Run-Git @("commit","-m","Target source lane artifact alarms") | Out-Null

    $NewHead = (Run-Git @("rev-parse","HEAD") | Out-String).Trim()

    $Push = & git.exe -c safe.directory="$Repo" -C "$Repo" push origin main 2>&1
    if ($LASTEXITCODE -ne 0) {
        $PushText = ($Push | Out-String)
        if ($PushText -match "fetch first|rejected|non-fast-forward") {
            Write-Host "Push rejected because remote moved. Running guarded pull --rebase, then push."
            Run-Git @("pull","--rebase","origin","main") | Out-Null
            Run-Git @("push","origin","main") | Out-Null
            $NewHead = (Run-Git @("rev-parse","HEAD") | Out-String).Trim()
        } else {
            throw "Push failed.`n$PushText"
        }
    }

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

    Write-Host "SOURCE/LANE/ARTIFACT ALARM TARGET SAVE COMPLETE"
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
    Write-Host "Verdict: PASS WITH GUARDRAILS / FIRST ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION"
}