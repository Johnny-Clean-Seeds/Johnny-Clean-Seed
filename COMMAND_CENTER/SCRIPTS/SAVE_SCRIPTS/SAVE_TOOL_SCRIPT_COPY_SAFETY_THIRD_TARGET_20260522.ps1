& {
    $ErrorActionPreference = "Stop"

    Remove-Item Function:\Git -ErrorAction SilentlyContinue

    $Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $ExpectedBase = "7c8e0a10c3c94074fb17bd2bba8659defd9d483e"

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

    $RemoteHeadBefore = ((Run-Git @("ls-remote","origin","refs/heads/main") | Out-String).Trim() -split "\s+")[0]
    if ($RemoteHeadBefore -ne $ExpectedBase) {
        throw "Remote mismatch before save. Local $Head / Remote $RemoteHeadBefore"
    }

    $PreStatus = (Run-Git @("status","--short") | Out-String).Trim()
    if ($PreStatus) {
        throw "Repo dirty before Tool / Script / Copy Safety target save. Stop.`n$PreStatus"
    }

    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DateOnly = Get-Date -Format "yyyyMMdd"

    $TargetRel = "HOUSE_WORK/WORK_SHED/GEAR_RACK/ALARM_DEBUGGER_CABINET/REPAIR_TARGETS/TOOL_SCRIPT_COPY_SAFETY_THIRD_REPAIR_TARGET_$Stamp.md"
    $CardRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/TOOL_SCRIPT_COPY_SAFETY_ALARM_FIRING_CARD_$Stamp.md"
    $TodoRel = "HOUSE_WORK/TODO/TOOL_SCRIPT_COPY_SAFETY_REPAIR_TARGET_TODO_$Stamp.md"
    $ReceiptRel = "PROOF_HISTORY/TOOL_SCRIPT_COPY_SAFETY_THIRD_REPAIR_TARGET_RECEIPT_$Stamp.txt"

    $TargetPath = Join-Path $Repo ($TargetRel -replace "/","\")
    $CardPath = Join-Path $Repo ($CardRel -replace "/","\")
    $TodoPath = Join-Path $Repo ($TodoRel -replace "/","\")
    $ReceiptPath = Join-Path $Repo ($ReceiptRel -replace "/","\")

    foreach ($Path in @($TargetPath,$CardPath,$TodoPath,$ReceiptPath)) {
        New-Item -ItemType Directory -Force -Path (Split-Path $Path) | Out-Null
    }

    $Target = @"
# Tool / Script / Copy Safety — Third Alarm-Cabinet Repair Target

Date: $Stamp

Base:

$ExpectedBase

Status:

Alarm Debugger Cabinet repair target.
Evidence/candidate only.
No promotion.
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.

## Primary home

Alarm Debugger Cabinet / Repair Targets

## Group

Tool / Script / Copy Safety Alarms

## Why this is the third target

This lane has caused repeated workflow friction:

1. Long scripts filled the chat viewport.
2. Markdown fences were pasted into PowerShell after successful runs.
3. Downloaded scripts were blocked by execution policy until unblocked/bypassed.
4. A PowerShell function name collision caused `git -c` to be interpreted incorrectly.
5. Ignored proof receipts required intentional `git add -f`.
6. Some recovery scripts needed better base/status/state gating.
7. Script delivery needed to shift from giant chat blocks to downloadable `.ps1` files with short launchers.

This did not corrupt the house because save gates caught the major failures, but it created avoidable drag.

## Protected damage type

This target protects against local execution confusion, partial writes, false recovery proof, paste pollution, script rerun mistakes, stale-base scripts, ignored-proof misses, and user-interface burden from giant code blocks.

## Default severity

WARNING during normal planning or explanation.

BLOCKER during save, recovery, commit, push, file mutation, or repo-state repair scripts.

## Current evidence

Recent observed events:

1. Unsigned script blocking was real.
2. Markdown fence paste-trash happened after a successful save.
3. `Git` function collision broke recovery commands until `git.exe` was used explicitly.
4. Ignored `PROOF_HISTORY` receipts required force-add behavior.
5. Long visible code blocks caused screen/viewport burden.
6. Downloadable `.ps1` plus short launcher worked better for large scripts.
7. Base mismatch protection is necessary because a generated script can become stale after another save.

## Firing status

PARTIAL / WORKING WITH GAPS

The Git and proof gates are working.

The delivery-shape and copy/paste safety alarm fired late, after user correction.

The filing-cabinet/template-reuse alarm is still weak because the assistant has repeatedly generated large new scripts rather than always routing through a known skeleton/file delivery pattern first.

## Better alarm definition

A Tool / Script / Copy Safety alarm is working when it changes the delivery or execution route before the user hits avoidable friction.

It should ask:

1. Is this script too long for chat?
2. Should this be a `.ps1` file plus a short launcher?
3. Is the script base-bound and therefore likely to go stale?
4. Does it use `git.exe` explicitly instead of risky function names?
5. Does it force-add intentional ignored proof receipts?
6. Does it stop if the repo is dirty or the base is wrong?
7. Does it verify remote/local match and final clean state?
8. Does it avoid markdown fence paste-trash?
9. Does it give only copyable text when the user actually needs to paste?
10. Does it reduce screen movement and paste burden?

## Repair target

Make `.ps1` artifact delivery the default for large local scripts.

Use short launcher commands in chat.

Keep visible code blocks minimal unless the user explicitly requests full visible code.

Use `git.exe` explicitly inside generated scripts.

Keep base checks strict.

Make stale scripts stop safely.

Force-add proof receipts when saving ignored proof lanes.

Run a completion revision pass before giving a script.

Link the script purpose, base, expected output, receipt, and next route.

## Not solved yet

This target does not fully install a reusable script skeleton.

This target does not promote a tool.

This target does not replace all future scripting with artifacts.

This target only marks Tool / Script / Copy Safety as the third active repair lane and defines what the alarm must catch.

## Next tightening move

Create or reuse a standard local-save script skeleton after one more live-use proof, so future scripts are generated from the skeleton rather than rebuilt from scratch.
"@

    $Card = @"
# Tool / Script / Copy Safety Alarm Firing Card

Date: $Stamp

Base:

$ExpectedBase

## Alarm group

Tool / Script / Copy Safety

## Primary alarm

Large local scripts should be delivered as `.ps1` artifacts with short launcher commands unless the user asks for full visible code.

## Triggers

This card should fire when:

1. A script is long enough to fill the screen.
2. A save/recovery route requires many lines.
3. A script is base-bound and may go stale.
4. A command block could accidentally include markdown fences.
5. Git operations are used inside PowerShell.
6. `PROOF_HISTORY` or ignored paths must be committed.
7. A dirty repo or wrong base could cause partial state.
8. The user reports screen drag, flicker, or paste burden.
9. A local helper script should reuse a known filing-cabinet skeleton.
10. A previous execution failure shows a repeatable script pattern.

## Required behavior

When this alarm fires, the assistant should:

1. Prefer `.ps1` file artifact plus short launcher.
2. Keep the launcher short and pasteable.
3. Avoid long visible code blocks.
4. Use `git.exe` explicitly in PowerShell scripts.
5. Remove or avoid risky function names that shadow external commands.
6. Include strict expected-base checks.
7. Include clean-status checks before writing.
8. Include diff checks before commit.
9. Force-add intentional ignored proof receipts.
10. Verify final local/remote HEAD match.
11. Verify final status clean.
12. Warn if a previously generated script is stale.

## Severity

WATCH in discussion.

WARNING when creating scripts.

BLOCKER when the script mutates Mr.Kleen, commits, pushes, repairs, deletes, moves, or rewrites tracked house files.

## Proof that it fired

Proof may include:

1. A downloadable script instead of a long chat block.
2. A short launcher only.
3. A script self-check line count and SHA256.
4. A safe stop on base mismatch.
5. A final save receipt and clean Git proof.
6. User-visible reduction of copy/paste burden.

## Current verdict

PASS WITH GUARDRAILS / THIRD REPAIR TARGET SELECTED / NO PROMOTION
"@

    $Todo = @"
# Tool / Script / Copy Safety Repair Target TODO

Date: $Stamp

## Current state

Tool / Script / Copy Safety has been selected as the third Alarm Debugger Cabinet repair target.

## Next work

1. Use `.ps1` artifacts plus short launchers for large local scripts.
2. Avoid screen-filling code boxes unless requested.
3. Keep copy blocks only for exact paste/run material.
4. Use `git.exe` explicitly in generated scripts.
5. Keep strict expected-base checks.
6. Keep ignored proof receipt force-add handling.
7. Add stale-script warnings when a script was generated against an older base.
8. Look for or create a reusable local-save script skeleton after more proof.

## Watch

1. Do not let artifact delivery hide the content from self-check.
2. Do not skip script self-checks.
3. Do not let stale scripts run after the base changes.
4. Do not treat a launcher as proof of save.
5. Do not call a script complete until the output proves local/remote clean state.

## Blocked

No tool promotion.

No doctrine rewrite.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No automation install.
"@

    $Receipt = @"
TOOL / SCRIPT / COPY SAFETY THIRD REPAIR TARGET RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Saved target:
$TargetRel

Saved firing card:
$CardRel

Saved TODO:
$TodoRel

Verdict:
PASS WITH GUARDRAILS / THIRD ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No promotion.
No authority transfer.

Key target:
Tool / Script / Copy Safety must reduce avoidable execution friction by preferring file artifacts plus short launchers for large scripts, preventing stale-base runs, preserving proof, and avoiding paste pollution.
"@

    Write-CleanText -Path $TargetPath -Text ($Target + "`n")
    Write-CleanText -Path $CardPath -Text ($Card + "`n")
    Write-CleanText -Path $TodoPath -Text ($Todo + "`n")
    Write-CleanText -Path $ReceiptPath -Text ($Receipt + "`n")

    $AnchorPath = Join-Path $Repo "ACTIVE_ANCHOR.txt"
    $Anchor = @"
ACTIVE ANCHOR

Current position:
main after Tool / Script / Copy Safety third alarm-cabinet repair target save

Base before save:
main @ 7c8e0a1

Saved:
Tool / Script / Copy Safety third repair target.
Tool / Script / Copy Safety firing card.
Followup TODO and receipt.

Verdict:
PASS WITH GUARDRAILS / THIRD ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION

Next allowed move:
Use the Tool / Script / Copy Safety alarm for large local scripts and prefer `.ps1` artifact delivery plus short launcher commands.

Blocked:
Do not promote this target.
Do not install automation.
Do not rewrite doctrine.
Do not rewrite ACTIVE_GUIDES.
Do not rewrite CURRENT_TRUTH_INDEX.
Do not run stale scripts after base changes.
Do not use long screen-filling code blocks unless requested.
"@

    Write-CleanText -Path $AnchorPath -Text ($Anchor + "`n")

    $StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $ExistingStatus = Get-Content -LiteralPath $StatusPath -Raw
    if (-not $ExistingStatus.EndsWith("`n")) {
        $ExistingStatus += "`n"
    }

    $StatusAppend = @(
        ""
        "## $DateOnly — Tool / Script / Copy Safety Third Alarm-Cabinet Repair Target"
        ""
        "Base before save: main @ 7c8e0a1"
        "Full base hash: $ExpectedBase"
        "State: PASS WITH GUARDRAILS / THIRD ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION"
        "Saved target: $TargetRel"
        "Saved firing card: $CardRel"
        "Saved TODO: $TodoRel"
        "Receipt: $ReceiptRel"
        "Promotion: none"
        "Authority changes: none"
        "Next allowed move: use this alarm to prefer `.ps1` artifact delivery plus short launchers for large local scripts."
        "Blocked: no stale script runs, no automation install, no doctrine/guide/index rewrite, no promotion."
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
        $CardRel,
        $TodoRel
    ) | Out-Null

    Run-Git @("add","-f","--",$ReceiptRel) | Out-Null

    $CachedCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --cached --check 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Cached diff --check failed.`n$($CachedCheck | Out-String)"
    }

    Run-Git @("commit","-m","Add tool script copy safety repair target") | Out-Null

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
    $CardHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CardPath).Hash
    $ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

    Write-Host "TOOL / SCRIPT / COPY SAFETY TARGET SAVE COMPLETE"
    Write-Host "Old base: $ExpectedBase"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Status: clean"
    Write-Host "Target: $TargetRel"
    Write-Host "Target SHA256: $TargetHash"
    Write-Host "Firing card: $CardRel"
    Write-Host "Firing card SHA256: $CardHash"
    Write-Host "Receipt: $ReceiptRel"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Verdict: PASS WITH GUARDRAILS / THIRD ALARM CABINET REPAIR TARGET SAVED / NO PROMOTION"
}