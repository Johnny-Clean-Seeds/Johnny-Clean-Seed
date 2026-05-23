& {
    $ErrorActionPreference = "Stop"

    Remove-Item Function:\Git -ErrorAction SilentlyContinue

    $Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $ExpectedBase = "45fb1a8e7a7aa3e1dc4dbba4ee2bf17cd36385fa"

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
        throw "Repo dirty before project scope repair save. Stop.`n$PreStatus"
    }

    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DateOnly = Get-Date -Format "yyyyMMdd"

    $RuleRel = "BRAIN_LEARNING/PROJECT_RULE_PLACEMENT_NO_CHAT_RULES_RULE_$DateOnly.md"
    $ScopeRel = "BRAIN_LEARNING/PROJECT_TO_BUILD_CLEAN_SEED_SCOPE_BOUNDARY_RULE_$DateOnly.md"
    $RepairRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/PROJECT_SCOPE_SHIFT_RULE_PLACEMENT_REPAIR_$Stamp.md"
    $TodoRel = "HOUSE_WORK/TODO/PROJECT_SCOPE_RULE_PLACEMENT_FOLLOWUP_TODO_$Stamp.md"
    $ReceiptRel = "PROOF_HISTORY/PROJECT_SCOPE_RULE_PLACEMENT_REPAIR_RECEIPT_$Stamp.txt"

    $AllRel = @($RuleRel,$ScopeRel,$RepairRel,$TodoRel,$ReceiptRel)

    foreach ($Rel in $AllRel) {
        $Full = Join-Path $Repo ($Rel -replace "/","\")
        New-Item -ItemType Directory -Force -Path (Split-Path $Full) | Out-Null
    }

    $Rule = @"
# Project Rule Placement / No Chat Rules Rule

Date: $Stamp

Status: active project-placement rule.

## Rule

Project-related rules are not chat rules.

If the user gives a project-related instruction, correction, method, boundary, workflow, operating preference, scope shift, or recurring rule, it belongs in the project/house as durable project material when accepted.

Chat and memory may temporarily carry the assistant, but they are not the final home for project rules.

## Trigger

This rule fires when the user gives material that changes how the project should be built, saved, sorted, handed off, tested, revised, linked, parked, compressed, or protected.

If the material is already present but incomplete, too narrow, wrongly scoped, poorly worded, or not expressed in the durable concept the user just clarified, the house needs a repair, revision, or parked candidate.

## Placement standard

Accepted project rules should be placed in the project with local plus Git proof unless blocked.

The save should include the correct lane, receipt, base, hash/proof when relevant, commit, push, remote match, and final clean status.

## Memory cue

A memory update is a cue that durable project material may exist.

Memory is not the rule's project home.

When memory is updated for project behavior, the assistant must check whether the project/house needs the same concept saved, repaired, or parked.

## Boundary

This rule does not mean every casual remark becomes a repo save.

It applies to project-relevant material that changes durable behavior, scope, method, boundary, workflow, or future project handling.

If uncertain, park the material as candidate/source rather than pretending it is active authority.
"@

    $Scope = @"
# Project To Build Clean Seed / Clean Seed Build Scope Boundary Rule

Date: $Stamp

Status: active scope-boundary rule.

## Rule

The current work is the project to build Clean Seed.

"Clean Seed Build" is the target build/form/stage being produced and refined, not a label that should swallow every project rule, side method, repair, scaffold, handoff process, or current-stage construction aid.

## Why this matters

The project contains multiple kinds of material:

1. Current project operating rules.
2. Build-stage methods.
3. Candidate rules.
4. Scaffolds.
5. Handoffs.
6. Receipts and proof.
7. Alarm/debugger material.
8. Whirlpool and growth-compression material.
9. Parked ideas and source ore.
10. Final Clean Seed Build material.

These should not be blurred together.

## Clean separation

Project material may belong in the house even when it is not final Clean Seed Build doctrine.

Final Clean Seed Build form comes later through proof, revision, compression, and wrap.

Current-stage project rules can guide the building process without pretending they are final doctrine.

## Noise boundary repair

The earlier distinction should be understood as project-fit versus not-current-fit material.

The better distinction is:

- Project-relevant material: goes into the project/house in the correct lane when accepted.
- Not-current-fit or later-phase material: parks as source ore, candidate, scaffold, or idea-horizon material.
- Final Clean Seed Build material: only emerges after the proper proof, revision, compression, and wrap stage.

## Boundary

Do not call project rules chat rules.

Do not force all project material into final Clean Seed Build form too early.

Do not let unrelated noise enter active authority.

Do not lose project-relevant corrections by leaving them only in chat or memory.
"@

    $Repair = @"
# Project Scope Shift / Rule Placement Repair

Date: $Stamp

Base:

$ExpectedBase

## Trigger

The user corrected the scope:

The work is not simply "Clean Seed Build" as if the build is already final.

This is the project to build Clean Seed.

The user also clarified that project-related rules are not chat rules and should go into the project.

## Repair

This save repairs the placement language forward.

It adds:

1. Project Rule Placement / No Chat Rules Rule.
2. Project To Build Clean Seed / Clean Seed Build Scope Boundary Rule.

## Revision pass

Checked for:

1. No live instruction stuffing.
2. No false linearity.
3. No doctrine rewrite.
4. No ACTIVE_GUIDES rewrite.
5. No CURRENT_TRUTH_INDEX rewrite.
6. No promotion.
7. Clear separation between project-stage material and final Clean Seed Build form.
8. Evidence-chain links through base, receipt, files, and next route.

## Verdict

PASS WITH GUARDRAILS.

The correction belongs in the project and is saved as scope/placement behavior, not doctrine promotion.
"@

    $Todo = @"
# Project Scope / Rule Placement Followup TODO

Date: $Stamp

## Current state

Project scope and rule placement correction has been saved.

## Use next

When the user gives project-relevant rules, corrections, workflows, or methods, treat them as project material and route them into the house when accepted.

Use the correct lane:

1. Active behavior rule.
2. Candidate rule.
3. Scaffold.
4. Handoff method.
5. Alarm/debugger material.
6. TODO.
7. Proof/evidence.
8. Parked source ore.

## Watch

1. Do not call project rules chat rules.
2. Do not leave durable project corrections only in memory.
3. Do not force current-stage project material into final Clean Seed Build doctrine.
4. Do not let other noise bleed into current project authority.
5. Do not promote without proof.
"@

    $Receipt = @"
PROJECT SCOPE RULE PLACEMENT REPAIR RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Saved files:
$RuleRel
$ScopeRel
$RepairRel
$TodoRel

Verdict:
PASS WITH GUARDRAILS / PROJECT SCOPE AND RULE PLACEMENT REPAIR SAVED / NO PROMOTION

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No promotion.
No authority transfer.

Key correction:
Project-related rules are not chat rules. The current work is the project to build Clean Seed; final Clean Seed Build form is a later proof/wrap/compression result.
"@

    $Map = [ordered]@{
        $RuleRel = $Rule
        $ScopeRel = $Scope
        $RepairRel = $Repair
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
main after project scope and rule-placement repair

Base before save:
main @ 45fb1a8

Saved:
Project Rule Placement / No Chat Rules Rule.
Project To Build Clean Seed / Clean Seed Build Scope Boundary Rule.
Repair note, TODO, and receipt.

Verdict:
PASS WITH GUARDRAILS / PROJECT SCOPE REPAIR SAVED / NO PROMOTION

Next allowed move:
Continue project work with the corrected scope: project-related rules belong in the project/house when accepted; final Clean Seed Build form comes later through proof, compression, and wrap.

Blocked:
Do not call project rules chat rules.
Do not leave durable project rules only in memory.
Do not force current project scaffolds into final Clean Seed Build doctrine.
Do not rewrite doctrine.
Do not rewrite ACTIVE_GUIDES.
Do not rewrite CURRENT_TRUTH_INDEX.
Do not install automation.
Do not promote without proof.
"@

    Write-CleanText -Path $AnchorPath -Text ($Anchor + "`n")

    $StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $ExistingStatus = Get-Content -LiteralPath $StatusPath -Raw
    if (-not $ExistingStatus.EndsWith("`n")) {
        $ExistingStatus += "`n"
    }

    $StatusAppend = @(
        "",
        "## $DateOnly — Project Scope and Rule-Placement Repair",
        "",
        "Base before save: main @ 45fb1a8",
        "Full base hash: $ExpectedBase",
        "State: PASS WITH GUARDRAILS / PROJECT SCOPE AND RULE PLACEMENT REPAIR SAVED / NO PROMOTION",
        "Saved project rule placement: $RuleRel",
        "Saved project scope boundary: $ScopeRel",
        "Saved repair note: $RepairRel",
        "Saved TODO: $TodoRel",
        "Receipt: $ReceiptRel",
        "Promotion: none",
        "Authority changes: none",
        "Next allowed move: continue project work with corrected scope; project-related rules go into the project/house when accepted, final Clean Seed Build form comes later through proof/compression/wrap.",
        "Blocked: no chat-only project rules, no memory-only durable project rules, no forced final-build doctrine, no doctrine/guide/index rewrite, no automation install, no promotion without proof."
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
        $RuleRel,
        $ScopeRel,
        $RepairRel,
        $TodoRel
    ) | Out-Null

    Run-Git @("add","-f","--",$ReceiptRel) | Out-Null

    $CachedCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --cached --check 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Cached diff --check failed.`n$($CachedCheck | Out-String)"
    }

    Run-Git @("commit","-m","Repair project scope rule placement") | Out-Null

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

    $RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($RuleRel -replace "/","\"))).Hash
    $ScopeHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($ScopeRel -replace "/","\"))).Hash
    $ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($ReceiptRel -replace "/","\"))).Hash

    Write-Host "PROJECT SCOPE RULE PLACEMENT REPAIR SAVE COMPLETE"
    Write-Host "Old base: $ExpectedBase"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Status: clean"
    Write-Host "Rule: $RuleRel"
    Write-Host "Rule SHA256: $RuleHash"
    Write-Host "Scope: $ScopeRel"
    Write-Host "Scope SHA256: $ScopeHash"
    Write-Host "Receipt: $ReceiptRel"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Verdict: PASS WITH GUARDRAILS / PROJECT SCOPE AND RULE PLACEMENT REPAIR SAVED / NO PROMOTION"
}
