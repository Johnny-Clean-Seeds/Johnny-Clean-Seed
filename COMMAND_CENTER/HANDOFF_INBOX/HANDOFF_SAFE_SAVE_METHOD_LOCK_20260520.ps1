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

Write-Host "XxXxX ===== HANDOFF SAFE SAVE METHOD LOCK START ===== XxXxX"

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

$CodeCabinetRulePath = "BRAIN_LEARNING\CODE_CABINET_BRIDGE_METHOD_RULE_20260520.md"
$DeliveryLintRulePath = "BRAIN_LEARNING\POWERSHELL_COPY_DELIVERY_LINT_AND_SCRIPT_EXECUTION_RULE_20260520.md"
$SkeletonPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\MR_KLEEN_SAVE_PACKAGE_SKELETON_20260520.md"
$WeakestLinkRulePath = "BRAIN_LEARNING\TODO_PROOF_RANKED_WEAKEST_LINK_SELECTION_RULE_20260520.md"
$TodoControlBoardPath = "HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$HandoffRulePath = "BRAIN_LEARNING\HANDOFF_ASSISTANT_SAFE_SAVE_METHOD_RULE_20260520.md"
$HandoffCardPath = "HOUSE_WORK\WORK_SHED\AGENT_HANDOFFS\HANDOFF_ASSISTANT_SAFE_SAVE_METHOD_CARD_20260520.md"
$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\HANDOFF_SAFE_SAVE_METHOD_INSTANTIATION_20260520.md"
$DispositionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\SAVE_METHOD_DELIVERY_LINT_HANDOFF_DISPOSITION_20260520.md"
$ReceiptPath = "PROOF_HISTORY\HANDOFF_ASSISTANT_SAFE_SAVE_METHOD_RECEIPT_20260520.txt"

$RequiredInputs = @(
    $CodeCabinetRulePath,
    $DeliveryLintRulePath,
    $SkeletonPath,
    $WeakestLinkRulePath,
    $TodoControlBoardPath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

foreach ($Target in @($HandoffRulePath, $HandoffCardPath, $InstantiationPath, $DispositionPath, $ReceiptPath)) {
    if (Test-Path $Target) {
        throw "Target already exists. Stop before overwrite: $Target"
    }
}

$Instantiation = @"
# Handoff Safe Save Method - Code Cabinet Instantiation

Date: 2026-05-20

## Status

CODE CABINET INSTANTIATION / HANDOFF SAVE METHOD LOCK.

## Skeleton Used

$SkeletonPath

## Trigger

The user asked to make sure the current safe save method is used all the time and known by every new handoff assistant.

The problem came from repeated PowerShell delivery failures:

- prose pasted into PowerShell;
- Markdown fence text pasted into PowerShell;
- downloaded ps1 blocked by execution policy until process-scope bypass was used;
- validation mismatch created a partial dirty state;
- recovery had to be narrow and expected-dirty-only;
- parser/lint failure later broke a read-only triage script.

## Task

Save a handoff-facing safe save method card and support rule.

Patch Code Cabinet / Delivery Lint references so new handoff assistants know the standard.

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No script promotion.

## Next Required Move After Save

Continue TODO weakest-link triage on remaining open TODOs.
"@

$HandoffRule = @'
# Handoff Assistant Safe Save Method Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE / HANDOFF SUPPORT.

## Purpose

Make the current safe save method portable to future handoff assistants.

A new handoff assistant must not relearn the same PowerShell delivery mistakes.

## Rule

For Mr.Kleen saves that require long PowerShell or multiple coordinated files, use the safe save method:

1. Use Code Cabinet / bridge method.
2. Prefer a downloadable ps1 file for long scripts.
3. Provide one run command.
4. Include process-scope execution-policy bypass for downloaded ps1 files.
5. Parser/lint check the ps1 before running when possible.
6. Keep chat prose out of PowerShell copy material.
7. Keep Markdown fence text out of PowerShell copy material.
8. Stop on the first error.
9. If failure happens before commit, do not rerun blindly.
10. Inspect dirty paths.
11. Allow only expected dirty paths.
12. Recover narrowly to receipt, commit, push, fetch, HEAD equals origin/main, and final clean status.

## Standard Run Command Shape

Use this shape for downloaded ps1 files:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $p="$env:USERPROFILE\Downloads\FILE.ps1"; $t=$null; $e=$null; [System.Management.Automation.Language.Parser]::ParseFile($p,[ref]$t,[ref]$e) | Out-Null; if($e.Count){$e | Format-List | Out-String | Write-Host; throw "Parser errors in downloaded script"}; & $p

## Why This Exists

This method exists because the repeated failure was delivery/lint/recovery, not Git.

Git repeatedly proved clean when the final guarded proof ran.

The weak link was sending/running long PowerShell safely.

## Handoff Requirement

Every new handoff assistant working in Mr.Kleen must know:

- long scripts use Code Cabinet;
- delivery must be linted before send;
- downloaded ps1 gets process-scope bypass run command;
- parser check should happen before execution when possible;
- partial dirty state requires narrow recovery, not rerun;
- final proof must include commit, HEAD, origin/main, and status clean.

## Boundary

This rule does not install doctrine.

This rule does not rewrite active guides.

This rule does not rewrite CURRENT_TRUTH_INDEX.

This rule does not create automation.

This rule does not create runtime.

This rule does not promote scripts to tools.

It is a handoff/save-method safety rule.
'@

$HandoffCard = @'
# Handoff Assistant Safe Save Method Card

Date: 2026-05-20

## Read This First For Mr.Kleen Save Work

Use this method for long save scripts and multi-file Mr.Kleen changes.

## Safe Save Flow

Code Cabinet -> downloadable ps1 when long -> one run command -> parser/lint check -> execute -> receipt -> commit -> push -> fetch -> HEAD equals origin/main -> status clean.

## Run Command For Downloaded ps1

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $p="$env:USERPROFILE\Downloads\FILE.ps1"; $t=$null; $e=$null; [System.Management.Automation.Language.Parser]::ParseFile($p,[ref]$t,[ref]$e) | Out-Null; if($e.Count){$e | Format-List | Out-String | Write-Host; throw "Parser errors in downloaded script"}; & $p

## Hard Bans

Do not put prose inside PowerShell copy material.

Do not let Markdown fence text enter PowerShell.

Do not rerun blindly after a failed partial save.

Do not trust printed PASS after any earlier error.

Do not claim saved without final HEAD equals origin/main and status clean.

## Recovery Rule

If a script stops before commit:

1. fetch origin main;
2. confirm HEAD equals origin/main;
3. inspect git status;
4. allow only expected dirty paths;
5. verify required files and markers;
6. write receipt;
7. commit;
8. push;
9. fetch;
10. confirm HEAD equals origin/main;
11. confirm status clean.

## Boundary

This is a handoff/save method card.

It is not doctrine.

It is not an active guide.

It is not CURRENT_TRUTH_INDEX.

It is not automation or runtime.
'@

$Disposition = @"
# Save Method / Delivery Lint Handoff Disposition

Date: 2026-05-20

## Status

PASS WITH GUARDRAILS.

## Trigger

The user asked to make sure the safe save method is used every time and that new handoff assistants know it.

## Evidence

Recent failures proved the weak link:

- prose pasted into PowerShell;
- Markdown fence text pasted into PowerShell;
- execution policy blocked unsigned downloaded ps1;
- validation mismatch caused partial dirty state;
- recovery had to allow only expected dirty paths;
- parser/lint failure broke a read-only triage script.

## Disposition

The correct future method is now preserved as:

- handoff behavior rule;
- handoff card;
- Code Cabinet patch;
- delivery lint patch;
- status/anchor continuation.

## Saved

$HandoffRulePath

$HandoffCardPath

$InstantiationPath

$DispositionPath

## Patched

$CodeCabinetRulePath

$DeliveryLintRulePath

$SkeletonPath

$TodoControlBoardPath

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No script promotion.

## Next Move

Continue TODO weakest-link triage on remaining open TODOs.
"@

Write-NewCleanFile -Path $InstantiationPath -Text $Instantiation
Write-NewCleanFile -Path $HandoffRulePath -Text $HandoffRule
Write-NewCleanFile -Path $HandoffCardPath -Text $HandoffCard
Write-NewCleanFile -Path $DispositionPath -Text $Disposition

$CodeCabinetMarker = "2026-05-20 - Handoff Safe Save Method Patch"
$CodeCabinetAppend = @"
---

## $CodeCabinetMarker

Handoff patch:

New handoff assistants must use the safe save method for long Mr.Kleen save scripts.

Required flow:

Code Cabinet -> downloadable ps1 when long -> one run command -> parser/lint check -> execute -> receipt -> commit -> push -> fetch -> HEAD equals origin/main -> status clean.

Do not rely on giant chat copy blocks for long PowerShell when delivery errors have repeated.

Handoff card:

$HandoffCardPath
"@

$DeliveryMarker = "2026-05-20 - Handoff Parser Lint Patch"
$DeliveryAppend = @"
---

## $DeliveryMarker

Downloaded ps1 delivery should include parser/lint check before execution when possible.

Standard run-command shape:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; `$p="`$env:USERPROFILE\Downloads\FILE.ps1"; `$t=`$null; `$e=`$null; [System.Management.Automation.Language.Parser]::ParseFile(`$p,[ref]`$t,[ref]`$e) | Out-Null; if(`$e.Count){`$e | Format-List | Out-String | Write-Host; throw "Parser errors in downloaded script"}; & `$p

If a script fails before commit, recover narrowly from expected dirty paths only.
"@

$SkeletonMarker = "2026-05-20 - Handoff Save Method Step"
$SkeletonAppend = @"
---

## $SkeletonMarker

For handoff-ready long save scripts, add this before final send:

- downloadable ps1 preferred for long scripts;
- one run command only;
- process-scope execution-policy bypass;
- parser/lint check before execution when possible;
- no prose or Markdown fence text in PowerShell input;
- recovery path must allow only expected dirty paths;
- final proof must show HEAD equals origin/main and status clean.
"@

$BoardMarker = "2026-05-20 - Handoff Safe Save Method Locked"
$BoardAppend = @"
---

## $BoardMarker

Status: SUPPORT METHOD LOCKED.

Meaning:
- future handoff assistants must use the safe save method for long Mr.Kleen save scripts;
- Code Cabinet and delivery lint are the required route;
- downloadable ps1 plus parser/lint run command is preferred for long scripts;
- partial failures recover only through expected-dirty-path proof;
- no giant unsafe chat-copy PowerShell when delivery errors repeat.

Next:
- continue TODO weakest-link triage on remaining open TODOs.
"@

Append-Once -Path $CodeCabinetRulePath -Marker $CodeCabinetMarker -Text $CodeCabinetAppend
Append-Once -Path $DeliveryLintRulePath -Marker $DeliveryMarker -Text $DeliveryAppend
Append-Once -Path $SkeletonPath -Marker $SkeletonMarker -Text $SkeletonAppend
Append-Once -Path $TodoControlBoardPath -Marker $BoardMarker -Text $BoardAppend

Require-Text -Path $HandoffRulePath -Needle "Handoff Requirement"
Require-Text -Path $HandoffRulePath -Needle "Parser errors in downloaded script"
Require-Text -Path $HandoffCardPath -Needle "Safe Save Flow"
Require-Text -Path $DispositionPath -Needle "PASS WITH GUARDRAILS"
Require-Text -Path $CodeCabinetRulePath -Needle "Handoff Safe Save Method Patch"
Require-Text -Path $DeliveryLintRulePath -Needle "Handoff Parser Lint Patch"
Require-Text -Path $SkeletonPath -Needle "Handoff Save Method Step"
Require-Text -Path $TodoControlBoardPath -Needle "Handoff Safe Save Method Locked"

$Anchor = @"
CURRENT MR.KLEEN POSITION

After Handoff Safe Save Method lock.

Base before save:
$HeadBefore

Current ball:
- Future handoff assistants have a saved safe save method card.
- Long Mr.Kleen save scripts should use Code Cabinet and downloadable ps1 delivery.
- Downloaded ps1 run commands should include process-scope execution-policy bypass and parser/lint check before execution when possible.
- Partial failures before commit require narrow expected-dirty-path recovery.
- PowerShell delivery/lint weakness is now captured as handoff method, not just a one-off fix.

Next allowed move:
- Continue TODO weakest-link triage on remaining open TODOs.
- Use the handoff safe save method for future long scripts.
- Use quiet source-note proof for notes.
- Use Artifact Self-Check for created/sent artifacts.

Blocked moves:
- Do not use giant unsafe chat-copy PowerShell when delivery errors have repeated.
- Do not put prose or Markdown fence text into PowerShell copy material.
- Do not rerun blindly after partial failure.
- Do not promote this into automation/runtime/tooling.
- Do not install doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
"@

Set-Content -LiteralPath $AnchorPath -Value $Anchor -Encoding UTF8
Assert-CleanTextFile -Path $AnchorPath

$StatusAppend = @"

---

## 2026-05-20 - Handoff Safe Save Method Lock

Status: PASS WITH GUARDRAILS.

Base before save:
$HeadBefore

Saved:
$InstantiationPath
$HandoffRulePath
$HandoffCardPath
$DispositionPath
$ReceiptPath

Updated:
$CodeCabinetRulePath
$DeliveryLintRulePath
$SkeletonPath
$TodoControlBoardPath
$AnchorPath
$StatusPath

Meaning:
- future handoff assistants have a saved safe save method;
- Code Cabinet plus delivery lint is required for long Mr.Kleen save scripts;
- downloaded ps1 delivery should use process-scope execution-policy bypass and parser/lint check where possible;
- partial failures must recover through expected-dirty-path proof only;
- this locks the method without doctrine or runtime promotion.

Boundary:
- no doctrine install;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard/automation/runtime/knowledge graph/full lesson index;
- no script promotion.

Next move:
- continue TODO weakest-link triage on remaining open TODOs.
"@

Append-Once -Path $StatusPath -Marker "2026-05-20 - Handoff Safe Save Method Lock" -Text $StatusAppend

$ChangedForHash = @(
    $InstantiationPath,
    $HandoffRulePath,
    $HandoffCardPath,
    $DispositionPath,
    $CodeCabinetRulePath,
    $DeliveryLintRulePath,
    $SkeletonPath,
    $TodoControlBoardPath,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashTableText -Paths $ChangedForHash

$Receipt = @"
# Handoff Assistant Safe Save Method Receipt

Date: 2026-05-20

## Result

PASS WITH GUARDRAILS.

## Base Before Save

Branch: $Branch
HEAD before save: $HeadBefore
origin/main before save: $OriginBefore

## Files

$HashList

## Meaning

The safe save method is now saved for future handoff assistants.

The required method is:

- Code Cabinet / bridge method;
- downloadable ps1 for long scripts;
- one run command;
- process-scope execution-policy bypass;
- parser/lint check before execution when possible;
- no prose or Markdown fence text in PowerShell input;
- stop on first error;
- if failure occurs before commit, recover only from expected dirty paths;
- final proof requires commit, push, fetch, HEAD equals origin/main, and status clean.

## Artifact Self-Check

This save created and checked a real Mr.Kleen artifact package.

Checks performed:

- target files did not already exist before writing;
- required inputs existed and were readable;
- files were readable UTF-8 text;
- files were nonempty;
- no NUL bytes;
- no Unicode replacement characters;
- no placeholder markers;
- required phrases verified;
- branch main;
- HEAD equals origin/main before save;
- clean status before save;
- final commit/push/fetch requires HEAD equals origin/main and status clean.

## Boundary

No doctrine install.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No script promotion.

## Proof Limit

This receipt proves the handoff save method lock.

It does not prove remaining TODO board triage.

It does not promote a runtime tool.
"@

Write-NewCleanFile -Path $ReceiptPath -Text $Receipt
Require-Text -Path $ReceiptPath -Needle "safe save method is now saved"
Require-Text -Path $ReceiptPath -Needle "expected dirty paths"

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Run-Git add -- $InstantiationPath $HandoffRulePath $HandoffCardPath $DispositionPath $CodeCabinetRulePath $DeliveryLintRulePath $SkeletonPath $TodoControlBoardPath $AnchorPath $StatusPath | Out-Null
Run-Git add -f -- $ReceiptPath | Out-Null

$Staged = @(Run-Git diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "Nothing staged. Stop."
}

Run-Git commit -m "Lock handoff safe save method" | Out-Null
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
Write-Host "HANDOFF SAFE SAVE METHOD LOCK SAVED"
Write-Host "Commit: $Short"
Write-Host "HEAD: $Head"
Write-Host "origin/main: $Origin"
Write-Host "Status: clean"
Write-Host "Rule: $HandoffRulePath"
Write-Host "Card: $HandoffCardPath"
Write-Host "Disposition: $DispositionPath"
Write-Host "Instantiation: $InstantiationPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt bytes: $ReceiptBytes"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS"
Write-Host "Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; no script promotion"
Write-Host "Next move: continue TODO weakest-link triage on remaining open TODOs"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
