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

Write-Host "XxXxX ===== BOSS GHOST TODO MAP V3 CLEAN FIX START ===== XxXxX"

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

$BossGhostTodoPath = "HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md"
$TodoControlBoardPath = "HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md"
$TodoWeakestRulePath = "BRAIN_LEARNING\TODO_PROOF_RANKED_WEAKEST_LINK_SELECTION_RULE_20260520.md"
$TodoFirstRulePath = "BRAIN_LEARNING\TODO_FIRST_WORK_CONTROL_RULE_20260520.md"
$HandoffRulePath = "BRAIN_LEARNING\HANDOFF_ASSISTANT_SAFE_SAVE_METHOD_RULE_20260520.md"
$HandoffCardPath = "HOUSE_WORK\WORK_SHED\AGENT_HANDOFFS\HANDOFF_ASSISTANT_SAFE_SAVE_METHOD_CARD_20260520.md"
$DeliveryLintRulePath = "BRAIN_LEARNING\POWERSHELL_COPY_DELIVERY_LINT_AND_SCRIPT_EXECUTION_RULE_20260520.md"
$SkeletonPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\MR_KLEEN_SAVE_PACKAGE_SKELETON_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\BOSS_GHOST_TODO_TRIAGE_MAP_INSTANTIATION_20260520.md"
$MapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md"
$ResolverRulePath = "BRAIN_LEARNING\DOWNLOADED_PS1_RESOLVER_AND_SOURCE_VALIDATION_RULE_20260520.md"
$DeliveryFixPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\DOWNLOADED_PS1_RESOLVER_SOURCE_VALIDATION_FIX_20260520.md"
$ReceiptPath = "PROOF_HISTORY\BOSS_GHOST_TODO_TRIAGE_MAP_AND_DELIVERY_FIX_RECEIPT_20260520.txt"

$RequiredInputs = @(
    $BossGhostTodoPath,
    $TodoControlBoardPath,
    $TodoWeakestRulePath,
    $TodoFirstRulePath,
    $HandoffRulePath,
    $HandoffCardPath,
    $DeliveryLintRulePath,
    $SkeletonPath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

foreach ($Target in @($InstantiationPath, $MapPath, $ResolverRulePath, $DeliveryFixPath, $ReceiptPath)) {
    if (Test-Path $Target) {
        throw "Target already exists. Stop before overwrite: $Target"
    }
}

# Source inputs are checked for custody/readability only.
# Do not use brittle exact-text or narrow regex checks on source files.
# Exact required-text checks are reserved for created or patched artifacts below.

$Instantiation = @"
# Boss/Ghost TODO Triage Map - Code Cabinet Instantiation

Date: 2026-05-20

## Status

CODE CABINET INSTANTIATION / MAP PLUS DELIVERY-FIX PATCH.

## Skeleton Used

$SkeletonPath

## Trigger

TODO weakest-link triage ranked Boss/Ghost Rule-Firing Cycle Flow as the top remaining route after PowerShell delivery lint was worked.

V1 stopped safely before writing because an exact source text check was too brittle.

V2 found the browser-renamed downloaded file only after a resolver command, then stopped safely before writing because a source regex check was still too brittle.

## Task

Create a boss/ghost TODO-board triage map.

Also patch the safe save method so future downloaded ps1 commands use a resolver and future source validation does not use brittle exact source-text checks.

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No whole-house reorder.

No script promotion.

## Next Required Move After Save

Continue TODO weakest-link triage using the map and the corrected downloaded-script delivery method.
"@

$Map = @'
# Boss/Ghost TODO Board Triage Map

Date: 2026-05-20

## Status

MAP ONLY / PASS WITH GUARDRAILS.

## Core Finding

The TODO room has been behaving too much like a flat pile.

The current route is not to repair every TODO.

The current route is to map parent bosses, ghosts, child tasks, parked candidates, completion standards, proof needs, and blocked moves so future TODO work is selected by proof.

## Current Parent Boss Groups

### Parent Boss A - Rule Activation / Work-Order Control

Meaning:
Rules exist, but the correct rule does not always fire before action.

Current child/ghost items:
- PowerShell delivery lint / copy safety.
- Boss/Ghost sorting for TODO and idea capture.
- Packet top-block habit.
- Mule start card / short kickoff.
- Rule firing cycle flow.
- Completion standard drift.
- Surface-command mimicry.
- Worker-custody slip.
- Mule duplicate-work risk.
- Loose idea/tool debris.
- Cycle disconnect.
- Rule storage mistaken for rule firing.

Current disposition:
- PowerShell delivery lint has been worked and saved with guardrails.
- Handoff safe save method has been worked and saved with guardrails.
- Downloaded ps1 resolver and non-brittle source validation are now part of the safe method.
- Boss/Ghost sorting is the current map route.
- Remaining children should not be worked as separate bosses until ranked under this parent.

Completion standard:
Closed only when repeated live work shows control-state-first, rule confirmation, TODO weakest-link triage, and completion-standard declaration before house-touching action.

Proof needed:
- saved map;
- later live-use evidence where assistant groups TODOs by parent boss and lets proof select top route;
- no flat-list hand-picking;
- no TODO work that bypasses ACTIVE_ANCHOR.

Blocked moves:
- do not repair every listed ghost;
- do not create a dashboard;
- do not install automation;
- do not promote this to doctrine;
- do not rewrite active guides;
- do not rewrite CURRENT_TRUTH_INDEX.

### Parent Boss B - Recursive Carryover / Point-of-Work Link Failure

Meaning:
A fix can happen at the visible point, but the learning/carryover link can fail afterward.

Current child/ghost items:
- Artifact Self-Check After Send.
- Compose-Review-Reflect-Capture live-use watch.
- Source Note Quiet Self-Proof live-use watch.

Current disposition:
- Artifact Self-Check has first real package proof but remains open for varied artifacts.
- Compose-Review has live-use proof but remains in watch.
- Source Note self-proof has save proof but remains in live-use watch.

Completion standard:
Closed only after varied future tasks prove the assistant checks artifacts, captures source-note pressure, and carries fix lessons into the right lane without user reminder.

Proof needed:
- live artifact checks across different artifact types;
- source-note disposition on future notes;
- clear no-premature-injection calls.

Blocked moves:
- do not close from one artifact package;
- do not promote from one or two tests;
- do not treat memory as house capture.

### Parent Boss C - Growth / Candidate Maturity / Scaffold Exit

Meaning:
Growth Cycle and living-root material should support maturity decisions only when natural triggers appear.

Current child/ghost items:
- Growth Cycle Stage Readiness / Scaffold Exit.
- Living Root Words Refinement.

Current disposition:
- Parked / future live-use only.
- Not current weakest link.

Completion standard:
Used only when a natural decision appears about promotion, expansion, compression, scaffold exit, candidate maturity, method defaulting, or rule shortening.

Proof needed:
- real trigger;
- before/after decision quality;
- no forced biology/growth doctrine.

Blocked moves:
- do not force Growth Cycle;
- do not open motto/root-word work from pressure alone;
- do not promote source ore to doctrine.

### Parent Boss D - Mule / Handoff Flow

Meaning:
Mule and handoff work need bounded packets and short start cards, but only when real mule work appears.

Current child/ghost items:
- Packet top-block dense handoff.
- Mule start card and short kickoff.
- Mule duplicate-work risk under Parent Boss A.

Current disposition:
- Support TODOs.
- Not top route until a mule/handoff task is active.

Completion standard:
Mule packets are short, scoped, deduped, and tied to current house state.

Proof needed:
- next actual mule handoff uses the method;
- no overpacked mule prompt;
- no duplicate work sent.

Blocked moves:
- do not start a mule pass just to test the method;
- do not create dashboard;
- do not rewrite all packet templates.

## Current Weakest Link After This Map

The current weakest link remains under Parent Boss A:

Rule Activation / Work-Order Control.

The specific active seam is:

Boss/Ghost sorting must become the TODO-room method at point of use.

This map completes the first step: the flat pile has been grouped into parent bosses and child ghosts.

## Next Route Selected By Proof

Next top route after this map should be one of:

1. Use this map to update/drive TODO control behavior in live work.
2. Continue triage on the remaining Parent Boss A child that most blocks point-of-work rule firing.
3. If no immediate child blocks, move to Recursive Carryover / Artifact Self-Check varied live-use.

The list should decide by proof at the next re-entry.

## Boundary

This map is not authority.

This map is not doctrine.

This map is not an active guide.

This map does not reorder the whole house.

This map does not bypass ACTIVE_ANCHOR.

This map does not close all TODOs.

This map does not promote any parked candidate.
'@

$ResolverRule = @'
# Downloaded ps1 Resolver and Source Validation Rule

Date: 2026-05-20

## Status

ACTIVE DELIVERY-SAFETY PATCH / SUPPORT RULE.

## Trigger

Repeated downloaded-script runs failed for two different delivery reasons:

1. The run command assumed the script was at Downloads with an exact filename.
2. Browser-renamed files such as "(1)" were not accepted until a resolver was used.
3. Source validation inside the save script used brittle exact-text or narrow regex checks on existing source files.
4. Those checks stopped safe scripts even when the source concept was present.

## Rule

For downloaded ps1 scripts:

- do not rely only on a hardcoded Downloads exact filename;
- resolve the newest matching script from expected locations before parser-checking;
- accept browser-renamed copies such as "(1)";
- print the found path before running;
- parser-check the resolved file;
- run only the resolved file.

For source validation inside save scripts:

- source files should be checked for existence, readability, nonempty content, NUL bytes, replacement characters, and obvious placeholders;
- broad concept checks are allowed only when necessary;
- brittle exact phrase checks are not allowed on old/source files;
- exact phrase checks should be reserved for artifacts the current script creates or patches;
- if a preflight check fails before writes, treat it as no repo damage and diagnose the check instead of rerunning blindly.

## Standard Resolver Shape

Use this pattern and change only the file stem:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $name="FILE_STEM*.ps1"; $roots=@("$env:USERPROFILE\Downloads","$env:USERPROFILE\Desktop","$env:USERPROFILE\OneDrive\Desktop") | Where-Object { Test-Path $_ }; $p=Get-ChildItem -Path $roots -Filter $name -File -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1; if(-not $p){throw "Script file not found. Download FILE_STEM.ps1, then run this again."}; Write-Host "FOUND SCRIPT:" $p.FullName; $t=$null; $e=$null; [System.Management.Automation.Language.Parser]::ParseFile($p.FullName,[ref]$t,[ref]$e) | Out-Null; if($e.Count){$e | Format-List | Out-String | Write-Host; throw "Parser errors in downloaded script"}; & $p.FullName

## Boundary

This is not automation.

This is not a promoted tool.

This does not rewrite active guides.

This does not rewrite CURRENT_TRUTH_INDEX.
'@

$DeliveryFix = @'
# Downloaded ps1 Resolver / Source Validation Fix

Date: 2026-05-20

## Status

PASS WITH GUARDRAILS AS DELIVERY METHOD PATCH.

## Failure Pattern

The earlier safe-save method still allowed two repeated delivery failures:

- exact Downloads path failed when the browser renamed or misplaced the file;
- brittle source validation failed when a source file did not match exact wording or narrow regex wording.

## Fix

The safe downloaded script command now needs a file resolver.

Save scripts should validate old/source files for custody and readability, not exact phrasing.

Exact phrase checks belong on current-run artifacts created or patched by the script.

## Result

The method is tighter:

- find file first;
- print found path;
- parse resolved file;
- run resolved file;
- avoid brittle source text checks;
- still stop on real dirty state, missing file, unreadable file, parser error, or final proof failure.

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No script promotion.
'@

Write-NewCleanFile -Path $InstantiationPath -Text $Instantiation
Write-NewCleanFile -Path $MapPath -Text $Map
Write-NewCleanFile -Path $ResolverRulePath -Text $ResolverRule
Write-NewCleanFile -Path $DeliveryFixPath -Text $DeliveryFix

Require-Text -Path $InstantiationPath -Needle "MAP PLUS DELIVERY-FIX PATCH"
Require-Text -Path $MapPath -Needle "The TODO room has been behaving too much like a flat pile"
Require-Text -Path $MapPath -Needle "Parent Boss A - Rule Activation / Work-Order Control"
Require-Text -Path $MapPath -Needle "This map is not authority"
Require-Text -Path $ResolverRulePath -Needle "do not rely only on a hardcoded Downloads exact filename"
Require-Text -Path $ResolverRulePath -Needle "brittle exact phrase checks are not allowed on old/source files"
Require-Text -Path $DeliveryFixPath -Needle "find file first"

$BossGhostMarker = "2026-05-20 - Boss/Ghost TODO Board Triage Map"
$BossGhostAppend = @"
---

## $BossGhostMarker

Status: MAP PRODUCED / NO BROAD REPAIR.

Saved map:
$MapPath

Meaning:
- TODO board was grouped into parent boss families;
- child/ghost items were placed under larger seams;
- flat-list risk was addressed by map/disposition only;
- no whole-house reorder occurred.

Boundary:
- no doctrine;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no repair-every-boss action.
"@

$BoardMarker = "2026-05-20 - Boss/Ghost TODO Map Completed"
$BoardAppend = @"
---

## $BoardMarker

Status: MAP ONLY / PASS WITH GUARDRAILS.

Meaning:
- Boss/Ghost Rule-Firing Cycle Flow was worked as a map/disposition pass;
- TODO items are now grouped into parent boss families for future proof-ranked routing;
- PowerShell delivery lint remains worked;
- Handoff safe save method remains locked;
- downloaded ps1 resolver/source-validation patch is now saved;
- next route must still be selected by weakest-link proof, not hand-pick.

Map:
$MapPath

Next:
- continue TODO weakest-link triage from the map;
- do not repair every boss from the board alone.
"@

$HandoffRuleMarker = "2026-05-20 - Downloaded ps1 Resolver and Source Validation Patch"
$HandoffRuleAppend = @"
---

## $HandoffRuleMarker

Downloaded ps1 commands must resolve the file before parser-checking.

Do not assume the file is only at Downloads with an exact filename.

Use a resolver that searches expected locations and accepts browser-renamed copies such as `(1)`.

Save scripts should not use brittle exact-text checks against existing source files.

Source file checks should prove custody/readability/nonempty/no obvious corruption.

Exact text checks should be reserved for artifacts created or patched by the current script.
"@

$HandoffCardMarker = "2026-05-20 - Resolver Run Command Patch"
$HandoffCardAppend = @"
---

## $HandoffCardMarker

For downloaded ps1 files, use a resolver command:

- search expected locations;
- accept browser-renamed copies;
- print FOUND SCRIPT path;
- parser-check the resolved path;
- run the resolved path.

Do not use hardcoded Downloads exact-path commands as the only route.
"@

$DeliveryLintMarker = "2026-05-20 - Non-Brittle Source Validation Patch"
$DeliveryLintAppend = @"
---

## $DeliveryLintMarker

Delivery lint now includes two added checks:

1. Use a downloaded-script resolver before parser-checking.
2. Do not require brittle exact source phrases from existing files.

Old/source files:
- existence;
- readable UTF-8;
- nonempty;
- no NUL;
- no replacement characters;
- no obvious placeholders.

Current-run artifacts:
- exact required text checks allowed.
"@

$SkeletonMarker = "2026-05-20 - Resolver and Source Validation Step"
$SkeletonAppend = @"
---

## $SkeletonMarker

For future long ps1 saves:

- deliver as downloadable ps1;
- run with file resolver;
- parser-check resolved path;
- avoid brittle source exact-text validation;
- reserve exact checks for generated/patched artifacts;
- stop before writes on dirty repo;
- final proof must show HEAD equals origin/main and status clean.
"@

Append-Once -Path $BossGhostTodoPath -Marker $BossGhostMarker -Text $BossGhostAppend
Append-Once -Path $TodoControlBoardPath -Marker $BoardMarker -Text $BoardAppend
Append-Once -Path $HandoffRulePath -Marker $HandoffRuleMarker -Text $HandoffRuleAppend
Append-Once -Path $HandoffCardPath -Marker $HandoffCardMarker -Text $HandoffCardAppend
Append-Once -Path $DeliveryLintRulePath -Marker $DeliveryLintMarker -Text $DeliveryLintAppend
Append-Once -Path $SkeletonPath -Marker $SkeletonMarker -Text $SkeletonAppend

$Anchor = @"
CURRENT MR.KLEEN POSITION

After Boss/Ghost TODO Board Triage Map plus downloaded ps1 resolver/source-validation fix.

Base before save:
$HeadBefore

Current ball:
- Boss/Ghost Rule-Firing Cycle Flow was worked as a map/disposition pass.
- TODO board flat-list risk is now mapped into parent boss groups.
- Parent Boss A remains Rule Activation / Work-Order Control.
- Downloaded ps1 run method now requires a resolver, parser check, then run.
- Save scripts should avoid brittle exact source-text validation.
- PowerShell Delivery Lint and Handoff Safe Save Method are patched with this fix.
- Next route must still be selected by weakest-link proof from the map.

Next allowed move:
- Continue TODO weakest-link triage using the boss/ghost map.
- Let proof select the next top route.
- Use the resolver run shape for future downloaded ps1 files.
- Use quiet source-note proof for notes.
- Use Artifact Self-Check for created/sent artifacts.

Blocked moves:
- Do not treat the map as authority.
- Do not repair every boss from the map.
- Do not bypass ACTIVE_ANCHOR.
- Do not hardcode only Downloads exact-name ps1 paths.
- Do not use brittle exact source-text checks against old/source files.
- Do not install doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
"@

Set-Content -LiteralPath $AnchorPath -Value $Anchor -Encoding UTF8
Assert-CleanTextFile -Path $AnchorPath

$StatusAppend = @"

---

## 2026-05-20 - Boss/Ghost TODO Board Triage Map plus Delivery Fix

Status: PASS WITH GUARDRAILS / MAP PLUS DELIVERY-FIX PATCH.

Base before save:
$HeadBefore

Saved:
$InstantiationPath
$MapPath
$ResolverRulePath
$DeliveryFixPath
$ReceiptPath

Updated:
$BossGhostTodoPath
$TodoControlBoardPath
$HandoffRulePath
$HandoffCardPath
$DeliveryLintRulePath
$SkeletonPath
$AnchorPath
$StatusPath

Meaning:
- Boss/Ghost top route was worked as a map/disposition pass;
- TODO flat-list risk was mapped into parent boss groups;
- child/ghost TODOs were grouped under larger seams;
- V1 stopped safely before writing because of brittle exact source-text validation;
- V2 proved the need for a downloaded ps1 resolver and then stopped safely before writing because source regex validation was still brittle;
- V3 removed brittle source text validation, kept generated-artifact validation, and saved the resolver/source-validation patch;
- no broad repair or whole-house reorder occurred.

Boundary:
- no doctrine install;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard/automation/runtime/knowledge graph/full lesson index;
- no repair-every-boss action;
- no script promotion.

Next move:
- continue TODO weakest-link triage using the boss/ghost map.
"@

Append-Once -Path $StatusPath -Marker "2026-05-20 - Boss/Ghost TODO Board Triage Map plus Delivery Fix" -Text $StatusAppend

$ChangedForHash = @(
    $InstantiationPath,
    $MapPath,
    $ResolverRulePath,
    $DeliveryFixPath,
    $BossGhostTodoPath,
    $TodoControlBoardPath,
    $HandoffRulePath,
    $HandoffCardPath,
    $DeliveryLintRulePath,
    $SkeletonPath,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashTableText -Paths $ChangedForHash

$Receipt = @"
# Boss/Ghost TODO Triage Map and Delivery Fix Receipt

Date: 2026-05-20

## Result

PASS WITH GUARDRAILS / MAP PLUS DELIVERY-FIX PATCH.

## Base Before Save

Branch: $Branch
HEAD before save: $HeadBefore
origin/main before save: $OriginBefore

## V1 / V2 Stops

V1 stopped safely before writing because an exact text source check was too brittle.

V2 proved the downloaded ps1 resolver was needed because the browser-created copy had a renamed path.

V2 then stopped safely before writing because source regex validation was still too brittle.

## Files

$HashList

## Meaning

Boss/Ghost Rule-Firing Cycle Flow was worked as the proof-ranked next route.

The output is a TODO-board boss/ghost triage map, not a broad repair.

The safe save method is also patched so future downloaded ps1 commands use a resolver and future save scripts avoid brittle source text checks.

## Boundary

No doctrine install.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No repair-every-boss action.

No script promotion.

The map does not bypass ACTIVE_ANCHOR.

## Artifact Self-Check

This save created and checked a real Mr.Kleen artifact package.

Checks performed:

- target files did not already exist before writing;
- required inputs existed and were readable;
- source files were validated for custody/readability, not brittle exact phrasing;
- generated artifacts were checked for required phrases;
- files were readable UTF-8 text;
- files were nonempty;
- no NUL bytes;
- no Unicode replacement characters;
- no placeholder markers;
- branch main;
- HEAD equals origin/main before save;
- clean status before save;
- final commit/push/fetch requires HEAD equals origin/main and status clean.

## Proof Limit

This receipt proves the map/disposition pass and delivery-method patch.

It does not close all TODOs.

It does not prove the remaining TODO board has been fully triaged.

It does not promote the map to authority.

It does not promote a script to tool.
"@

Write-NewCleanFile -Path $ReceiptPath -Text $Receipt
Require-Text -Path $ReceiptPath -Needle "PASS WITH GUARDRAILS / MAP PLUS DELIVERY-FIX PATCH"
Require-Text -Path $ReceiptPath -Needle "It does not promote a script to tool"

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Run-Git add -- $InstantiationPath $MapPath $ResolverRulePath $DeliveryFixPath $BossGhostTodoPath $TodoControlBoardPath $HandoffRulePath $HandoffCardPath $DeliveryLintRulePath $SkeletonPath $AnchorPath $StatusPath | Out-Null
Run-Git add -f -- $ReceiptPath | Out-Null

$Staged = @(Run-Git diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "Nothing staged. Stop."
}

Run-Git commit -m "Map boss ghost TODO and fix script delivery" | Out-Null
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
Write-Host "BOSS GHOST TODO MAP AND DELIVERY FIX SAVED"
Write-Host "Commit: $Short"
Write-Host "HEAD: $Head"
Write-Host "origin/main: $Origin"
Write-Host "Status: clean"
Write-Host "Map: $MapPath"
Write-Host "Delivery rule: $ResolverRulePath"
Write-Host "Delivery fix: $DeliveryFixPath"
Write-Host "Instantiation: $InstantiationPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt bytes: $ReceiptBytes"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS / MAP PLUS DELIVERY-FIX PATCH"
Write-Host "Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; no repair-every-boss action; no script promotion"
Write-Host "Next move: continue TODO weakest-link triage using the boss/ghost map"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
