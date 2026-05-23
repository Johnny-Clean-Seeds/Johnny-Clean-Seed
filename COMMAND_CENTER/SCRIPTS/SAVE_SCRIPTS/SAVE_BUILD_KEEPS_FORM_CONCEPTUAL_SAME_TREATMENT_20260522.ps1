& {
    $ErrorActionPreference = "Stop"

    Remove-Item Function:\Git -ErrorAction SilentlyContinue

    $Repo = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $ExpectedBase = "0dcc8b4ba19b06ce6fea980a26433645b48c4b93"

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
        throw "Repo dirty before conceptual form addendum save. Stop.`n$PreStatus"
    }

    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $DateOnly = Get-Date -Format "yyyyMMdd"

    $RuleRel = "BRAIN_LEARNING/BUILD_KEEPS_FORM_CONCEPTUAL_SAME_TREATMENT_RULE_$DateOnly.md"
    $DissectionRel = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/BUILD_KEEPS_FORM_CONCEPTUAL_SAME_TREATMENT_DISSECTION_$Stamp.md"
    $TodoRel = "HOUSE_WORK/TODO/BUILD_KEEPS_FORM_CONCEPTUAL_SAME_TREATMENT_TODO_$Stamp.md"
    $ReceiptRel = "PROOF_HISTORY/BUILD_KEEPS_FORM_CONCEPTUAL_SAME_TREATMENT_RECEIPT_$Stamp.txt"

    $AllRel = @($RuleRel, $DissectionRel, $TodoRel, $ReceiptRel)

    foreach ($Rel in $AllRel) {
        $Full = Join-Path $Repo ($Rel -replace "/","\")
        New-Item -ItemType Directory -Force -Path (Split-Path $Full) | Out-Null
    }

    $Rule = @"
# Build Keeps Form / Conceptual Same-Treatment Rule

Date: $Stamp

Status: active scope-and-form rule.

## Rule

The current project is not the final Clean Seed Build, but it must be treated with the same form discipline while it is being built.

Conceptually, the assistant should handle the current project as if form matters now.

This does not mean the current project is final.

It means the current project must keep the skeleton, spine, lanes, proof, source custody, boundaries, and compression routes that allow final Clean Seed form to emerge later.

## Why this matters

The scope shift corrected the language: this is the project to build Clean Seed, not the finished Clean Seed Build.

That correction must not become permission for loose sprawl.

The build can be messy, broad, bloat-tolerant, and growth-heavy, but it still needs recognizable house shape.

## Form discipline during build

The project keeps form when material enters through:

1. A clear lane.
2. Source custody.
3. Proof boundary.
4. Authority boundary.
5. Phase awareness.
6. Artifact scope.
7. Parking route.
8. Recovery route.
9. Next-move route.
10. Evidence-chain links.
11. Scaffolds when temporary support is needed.
12. Ladders when the work needs a step-up path.
13. Future Whirlpool, powerplay, or wrap compression route.

## Current-stage standard

Current growth does not require final polish.

It does require shaped intake.

Useful bloat may enter when it improves coverage, preserves source pressure, captures variants, or reveals repeated structure.

Useful bloat must still be held by form.

## Form failure

The build loses form when:

1. Scope shift becomes an excuse for shapeless intake.
2. Current growth tolerance blurs authority or proof.
3. Other Noise enters active build artifacts without lane fit.
4. Live task instructions are injected into durable artifacts.
5. Source ore becomes authority.
6. Helper output becomes authority.
7. Receipts, hashes, base, or links are missing from durable saves.
8. Bloat has no parking, recovery, or compression route.
9. Rules become final-clean too early and stop growth.
10. Rules become so loose they stop guiding action.

## Operating phrase

Not final yet, but form still matters now.

Messy growth is allowed.

Formless growth is not.
"@

    $Dissection = @"
# Build Keeps Form / Conceptual Same-Treatment Dissection

Date: $Stamp

Base:

$ExpectedBase

## Source correction

The user clarified that even though the scope shifted, the current project should still be treated with form discipline.

The wording nuance is important:

The current project is not the final Clean Seed Build.

But conceptually, while building, it should be treated as something that must keep form.

## Fit with prior house rules

This repair links to:

1. Project Rule Placement / No Chat Rules.
2. Project to Build Clean Seed Scope Boundary.
3. Build Keeps Form.
4. Current Growth Bloat Tolerance / Polish-Then-Whirlpool.
5. Clean Seed Build vs Other Noise Phase Boundary.
6. Completion Revision / Second-Pass Editing.
7. Linking Papers / Evidence Chain.
8. Alarm Debugger Cabinet.

## Revision pass

Draft risk checked:

The addendum could accidentally say the current project is already the final Clean Seed Build.

Revision result:

The final wording keeps the distinction clean.

It says the current project is not the final thing, but it must be handled with the same form discipline while building.

## Evidence-chain links

Upstream base:

$ExpectedBase

Prior scope repair:

BRAIN_LEARNING/PROJECT_RULE_PLACEMENT_NO_CHAT_RULES_RULE_20260522.md

BRAIN_LEARNING/PROJECT_TO_BUILD_CLEAN_SEED_SCOPE_BOUNDARY_RULE_20260522.md

This addendum:

$RuleRel

Receipt:

$ReceiptRel

## Verdict

PASS WITH GUARDRAILS.

This is a scope/form addendum, not doctrine promotion.
"@

    $Todo = @"
# Build Keeps Form / Conceptual Same-Treatment TODO

Date: $Stamp

## Current state

The conceptual same-treatment form rule has been saved.

## Use next

Use this rule when scope shift, useful bloat, or messy growth could be misunderstood as permission for formless intake.

## Check

Ask:

1. Is this current project material or final Clean Seed Build material?
2. Even if current-stage messy, does it keep lane, proof, source, and phase shape?
3. Does it need a scaffold?
4. Does it need a ladder?
5. Does it need a parking, recovery, or compression route?
6. Does it preserve evidence links?
7. Does it avoid pretending to be final-clean too early?

## Blocked

Do not use scope shift as permission for shapeless intake.

Do not pretend the current project is the final Clean Seed Build.

Do not let useful bloat bypass lanes, source custody, proof, or phase boundaries.

Do not rewrite doctrine.

Do not rewrite ACTIVE_GUIDES.

Do not rewrite CURRENT_TRUTH_INDEX.

Do not promote without proof.
"@

    $Receipt = @"
BUILD KEEPS FORM / CONCEPTUAL SAME-TREATMENT RECEIPT

Date:
$Stamp

Base before save:
$ExpectedBase

Saved files:
$RuleRel
$DissectionRel
$TodoRel

Verdict:
PASS WITH GUARDRAILS / CONCEPTUAL SAME-TREATMENT FORM ADDENDUM SAVED / NO PROMOTION

Boundary:
No doctrine rewrite.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation install.
No promotion.
No authority transfer.

Core rule:
The current project is not the final Clean Seed Build, but it must be treated with form discipline while building. Not final yet, but form still matters now.
"@

    $Map = [ordered]@{
        $RuleRel = $Rule
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
main after Build Keeps Form conceptual same-treatment save

Base before save:
main @ 0dcc8b4

Saved:
Build Keeps Form / Conceptual Same-Treatment Rule.
Dissection, TODO, and receipt.

Verdict:
PASS WITH GUARDRAILS / CONCEPTUAL SAME-TREATMENT FORM ADDENDUM SAVED / NO PROMOTION

Next allowed move:
Continue project-to-build-Clean-Seed work while treating the build with form discipline: lanes, custody, proof, phase, scaffolds, ladders, parking, recovery, and compression route.

Blocked:
Do not use scope shift as permission for shapeless intake.
Do not pretend the current project is the final Clean Seed Build.
Do not blur authority or proof.
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
        ""
        "## $DateOnly — Build Keeps Form / Conceptual Same-Treatment Save"
        ""
        "Base before save: main @ 0dcc8b4"
        "Full base hash: $ExpectedBase"
        "State: PASS WITH GUARDRAILS / CONCEPTUAL SAME-TREATMENT FORM ADDENDUM SAVED / NO PROMOTION"
        "Saved rule: $RuleRel"
        "Saved dissection: $DissectionRel"
        "Saved TODO: $TodoRel"
        "Receipt: $ReceiptRel"
        "Promotion: none"
        "Authority changes: none"
        "Next allowed move: continue current project-to-build-Clean-Seed work while treating the build with form discipline."
        "Blocked: no shapeless intake, no pretending current project is final Clean Seed Build, no authority/proof blur, no doctrine/guide/index rewrite, no automation install, no promotion without proof."
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
        $DissectionRel,
        $TodoRel
    ) | Out-Null

    Run-Git @("add","-f","--",$ReceiptRel) | Out-Null

    $CachedCheck = & git.exe -c safe.directory="$Repo" -C "$Repo" diff --cached --check 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Cached diff --check failed.`n$($CachedCheck | Out-String)"
    }

    Run-Git @("commit","-m","Add build form conceptual same treatment") | Out-Null

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
    $ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Repo ($ReceiptRel -replace "/","\"))).Hash

    Write-Host "BUILD KEEPS FORM CONCEPTUAL SAME-TREATMENT SAVE COMPLETE"
    Write-Host "Old base: $ExpectedBase"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Status: clean"
    Write-Host "Rule: $RuleRel"
    Write-Host "Rule SHA256: $RuleHash"
    Write-Host "Receipt: $ReceiptRel"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Verdict: PASS WITH GUARDRAILS / CONCEPTUAL SAME-TREATMENT FORM ADDENDUM SAVED / NO PROMOTION"
}
