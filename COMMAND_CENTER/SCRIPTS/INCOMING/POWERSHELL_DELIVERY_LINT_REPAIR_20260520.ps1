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

Write-Host "XxXxX ===== POWERSHELL DELIVERY LINT REPAIR START ===== XxXxX"

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

$SkeletonPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\MR_KLEEN_SAVE_PACKAGE_SKELETON_20260520.md"
$CodeCabinetRulePath = "BRAIN_LEARNING\CODE_CABINET_BRIDGE_METHOD_RULE_20260520.md"
$PowerShellTodoPath = "HOUSE_WORK\TODO\POWERSHELL_COMMAND_SAFETY_TODO_20260520.md"
$PasteGuardPath = "BRAIN_LEARNING\POWERSHELL_PASTE_FALSE_SUCCESS_GUARD_20260520.md"
$PasteDissectionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\POWERSHELL_PASTE_FAILURE_DISSECTION_20260520.md"
$TodoWeakestRulePath = "BRAIN_LEARNING\TODO_PROOF_RANKED_WEAKEST_LINK_SELECTION_RULE_20260520.md"
$TodoControlBoardPath = "HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$NewRulePath = "BRAIN_LEARNING\POWERSHELL_COPY_DELIVERY_LINT_AND_SCRIPT_EXECUTION_RULE_20260520.md"
$TriagePath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\POWERSHELL_DELIVERY_REPEAT_FAILURE_WEAKEST_LINK_TRIAGE_20260520.md"
$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\POWERSHELL_DELIVERY_LINT_REPAIR_INSTANTIATION_20260520.md"
$ReceiptPath = "PROOF_HISTORY\POWERSHELL_DELIVERY_LINT_REPAIR_RECEIPT_20260520.txt"

$RequiredInputs = @(
    $SkeletonPath,
    $CodeCabinetRulePath,
    $PowerShellTodoPath,
    $PasteGuardPath,
    $PasteDissectionPath,
    $TodoWeakestRulePath,
    $TodoControlBoardPath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

foreach ($Target in @($NewRulePath, $TriagePath, $InstantiationPath, $ReceiptPath)) {
    if (Test-Path $Target) {
        throw "Target already exists. Stop before overwrite: $Target"
    }
}

$Instantiation = @"
# PowerShell Delivery Lint Repair - Code Cabinet Instantiation

Date: 2026-05-20

## Status

CODE CABINET INSTANTIATION / WEAKEST-LINK TODO ROUTE.

## Skeleton Used

$SkeletonPath

## Trigger

TODO weakest-link triage identified PowerShell command-safety delivery as the top route.

The repeated failures were:

- chat prose pasted into PowerShell;
- Markdown fence text pasted into PowerShell;
- downloaded ps1 blocked by execution policy until process bypass was used.

The existing TODO already said the paste block lint checklist was parked and could become useful if command paste errors repeated.

The errors repeated.

## Task

Move the paste block lint checklist from parked idea to active delivery rule.

Patch the command-safety TODO.

Patch the PowerShell paste guard.

Patch the Code Cabinet bridge method and save-package skeleton with delivery-lint requirements.

Record the weakest-link triage result.

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No script promotion to runtime tool.

## Next Required Move After Save

Use the delivery lint rule on the next PowerShell/code delivery.

Then continue TODO weakest-link triage on the remaining board.
"@

$NewRule = @'
# PowerShell Copy Delivery Lint / Script Execution Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Parent Boss

Rule Activation / Work-Order Control.

## Problem

PowerShell command-safety failures repeated after the paste guard existed.

The failure was no longer only false PASS.

The active weak link was delivery:

- prose got pasted into PowerShell;
- Markdown code-fence markers got pasted into PowerShell;
- a downloaded ps1 file was blocked by execution policy until a process-scope bypass command was used.

## Rule

Before sending PowerShell or long code for the user to run, the assistant must choose a delivery form and lint it.

## Allowed Delivery Forms

### 1. One-line command

Use when the task is simple.

The line must contain only executable PowerShell.

No prose.

No Markdown fences.

### 2. Code-only block

Use only when the user is expected to copy the block from ChatGPT.

The block content must be PowerShell only.

No intro sentence inside the block.

No trailing instruction inside the block.

No Markdown fence text should be copied by the user.

### 3. Downloaded ps1 file plus run command

Use when the script is long.

Provide the file as an artifact.

Give one run command.

For downloaded ps1 files on this machine, include process-scope execution-policy bypass in the run command:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & "$env:USERPROFILE\Downloads\FILE.ps1"

## Required Lint Before Sending

Check:

1. Is there any prose inside the code?
2. Is there any Markdown fence text that the user may paste into PowerShell?
3. Is the block too long for safe chat copy?
4. Should this be a downloadable ps1 instead?
5. If using a ps1, is the run command included with process-scope bypass?
6. Does the command start with a guard and final proof?
7. Does the final proof block say exactly what to paste back?
8. Does the command avoid false PASS after an error?

## Repeated-Failure Escalation

If paste errors repeat, do not keep resending the same delivery style.

Escalate to the safer form:

- from loose chat text to code-only block;
- from giant code-only block to downloaded ps1;
- from unsigned ps1 failure to process-scope bypass run command;
- from repeated user paste confusion to one-line command or file artifact.

## Boundary

This rule does not create automation.

This rule does not create runtime.

This rule does not promote scripts to tools.

This rule does not rewrite active guides.

This rule does not rewrite CURRENT_TRUTH_INDEX.

This rule is delivery safety for PowerShell/code work.
'@

$Triage = @"
# PowerShell Delivery Repeat Failure - Weakest-Link Triage

Date: 2026-05-20

## Status

TOP ROUTE / WEAKEST-LINK TODO TRIAGE RESULT.

## Base

$HeadBefore

## Triage Result

Top route:

PowerShell Command Safety / Copy Delivery Lint.

## Why This Ranked First

This route ranked first because it blocked current work repeatedly after the TODO weakest-link rule was saved.

Observed repeat failures:

- explanatory prose was pasted into PowerShell;
- Markdown fence text was pasted into PowerShell;
- a downloaded ps1 file was blocked by execution policy;
- the fix required process-scope execution-policy bypass;
- every Mr.Kleen save depends on safe command delivery.

## TODO Evidence

The existing PowerShell Command Safety TODO already contained this parked future improvement:

Paste block lint checklist.

It said the checklist may become useful if command paste errors repeat.

Command paste errors repeated.

Therefore the parked item is no longer parked.

It becomes active delivery behavior.

## Existing Support Evidence

Existing rule:

$PasteGuardPath

Existing dissection:

$PasteDissectionPath

Existing Code Cabinet bridge:

$CodeCabinetRulePath

Existing save skeleton:

$SkeletonPath

## Disposition

- Activate paste block lint checklist.
- Add downloaded ps1 execution-policy run-command rule.
- Patch Code Cabinet and skeleton to require delivery-lint before sending long code.
- Keep this under Parent Boss: Rule Activation / Work-Order Control.
- Do not create a broad tool framework.

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
"@

Write-NewCleanFile -Path $InstantiationPath -Text $Instantiation
Write-NewCleanFile -Path $NewRulePath -Text $NewRule
Write-NewCleanFile -Path $TriagePath -Text $Triage

$TodoMarker = "2026-05-20 - Paste Block Lint Activated By Repeat Failure"
$TodoAppend = @"
---

## $TodoMarker

Status: ACTIVE CHILD ISSUE / MOVED FROM PARKED TO ACTIVE.

Reason:
- command paste errors repeated after the paste guard existed;
- prose was pasted into PowerShell;
- Markdown fence text was pasted into PowerShell;
- downloaded ps1 execution was blocked by execution policy until process-scope bypass was used.

Action:
- Paste block lint checklist is now active, not parked.
- Long scripts should use Code Cabinet delivery-lint before send.
- Downloaded ps1 scripts should include process-scope execution-policy bypass in the run command.
- If chat copy keeps failing, escalate delivery form instead of resending the same style.

Saved rule:
$NewRulePath

Weakest-link triage:
$TriagePath

Boundary:
- no broad PowerShell framework;
- no automation;
- no dashboard;
- no runtime;
- no script promotion;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite.
"@

$PasteGuardMarker = "2026-05-20 - Delivery Lint Escalation Patch"
$PasteGuardAppend = @"
---

## $PasteGuardMarker

Repeat-failure patch:

PowerShell paste hygiene now includes delivery-lint before sending.

If a long script is sent through chat and copy/paste errors repeat, do not simply resend the same style.

Escalate delivery:

1. one-line command for simple work;
2. code-only block for medium work;
3. downloadable ps1 file for long work;
4. process-scope execution-policy bypass run command for downloaded ps1 files.

Downloaded ps1 run command shape:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & `"`$env:USERPROFILE\Downloads\FILE.ps1`"

Boundary:
- this is delivery safety;
- not automation;
- not runtime;
- not script/tool promotion.
"@

$CodeCabinetMarker = "2026-05-20 - Delivery Lint Bridge Patch"
$CodeCabinetAppend = @"
---

## $CodeCabinetMarker

Long-code bridge patch:

Before sending long code, the Code Cabinet bridge must include delivery-lint.

Check:

- should this be a downloadable ps1 instead of a giant chat block;
- if chat block, code only;
- no prose inside the code;
- no Markdown fence text expected to be pasted into PowerShell;
- if downloaded ps1, include process-scope execution-policy bypass run command;
- final copy-back block must be clear.

This patch exists because repeated copy/paste failures proved delivery form was the weakest link.
"@

$SkeletonMarker = "2026-05-20 - Delivery Lint Step Patch"
$SkeletonAppend = @"
---

## $SkeletonMarker

Add delivery-lint before final send:

For long PowerShell/save packages, check delivery form before sending.

Allowed forms:

1. one-line command;
2. code-only block;
3. downloadable ps1 file plus one run command.

If using a downloaded ps1 file, include:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & `"`$env:USERPROFILE\Downloads\FILE.ps1`"

Do not let prose, Markdown fence text, or explanatory chat become part of PowerShell input.
"@

$BoardMarker = "2026-05-20 - Weakest-Link Triage Result PowerShell Delivery"
$BoardAppend = @"
---

## $BoardMarker

Status: TOP ROUTE WORKED / PASS WITH GUARDRAILS.

Triage result:
- PowerShell Command Safety / Copy Delivery Lint was the proof-ranked weakest link.

Reason:
- repeated paste/delivery failures blocked current work;
- this affected every future Mr.Kleen save package;
- the existing TODO already had a parked paste block lint checklist waiting for repeated errors.

Disposition:
- paste block lint moved from parked to active;
- delivery lint rule saved;
- Code Cabinet and save skeleton patched;
- no broad framework created.

Next:
- use delivery lint on the next PowerShell/code delivery;
- continue TODO weakest-link triage on remaining open TODOs.
"@

Append-Once -Path $PowerShellTodoPath -Marker $TodoMarker -Text $TodoAppend
Append-Once -Path $PasteGuardPath -Marker $PasteGuardMarker -Text $PasteGuardAppend
Append-Once -Path $CodeCabinetRulePath -Marker $CodeCabinetMarker -Text $CodeCabinetAppend
Append-Once -Path $SkeletonPath -Marker $SkeletonMarker -Text $SkeletonAppend
Append-Once -Path $TodoControlBoardPath -Marker $BoardMarker -Text $BoardAppend

Require-Text -Path $NewRulePath -Needle "Before sending PowerShell or long code"
Require-Text -Path $NewRulePath -Needle "Downloaded ps1 files"
Require-Text -Path $TriagePath -Needle "Top route:"
Require-Text -Path $TriagePath -Needle "Paste block lint checklist"
Require-Text -Path $PowerShellTodoPath -Needle "MOVED FROM PARKED TO ACTIVE"
Require-Text -Path $PasteGuardPath -Needle "delivery-lint before sending"
Require-Text -Path $CodeCabinetRulePath -Needle "delivery-lint"
Require-Text -Path $SkeletonPath -Needle "Add delivery-lint before final send"
Require-Text -Path $TodoControlBoardPath -Needle "PowerShell Command Safety / Copy Delivery Lint"

$Anchor = @"
CURRENT MR.KLEEN POSITION

After PowerShell Delivery Lint / Weakest-Link TODO route.

Base before save:
$HeadBefore

Current ball:
- TODO weakest-link triage selected PowerShell Command Safety / Copy Delivery Lint as top route.
- Paste block lint checklist moved from parked to active because delivery failures repeated.
- Long PowerShell/code must be delivery-linted before send.
- Downloaded ps1 files should include process-scope execution-policy bypass run command.
- Code Cabinet and save package skeleton were patched for delivery-lint.

Next allowed move:
- Continue TODO weakest-link triage on remaining open TODOs.
- Use delivery lint on the next PowerShell/code delivery.
- Use Code Cabinet for long scripts.
- Use quiet source-note proof for notes.
- Use Artifact Self-Check for created/sent artifacts.

Blocked moves:
- Do not resend the same unsafe delivery style after paste failures repeat.
- Do not put prose or Markdown fence text into PowerShell copy material.
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

## 2026-05-20 - PowerShell Delivery Lint / Weakest-Link TODO Route

Status: PASS WITH GUARDRAILS.

Base before save:
$HeadBefore

Saved:
$InstantiationPath
$NewRulePath
$TriagePath
$ReceiptPath

Updated:
$PowerShellTodoPath
$PasteGuardPath
$CodeCabinetRulePath
$SkeletonPath
$TodoControlBoardPath
$AnchorPath
$StatusPath

Meaning:
- TODO weakest-link triage selected PowerShell delivery safety as top route;
- paste block lint moved from parked to active due repeated errors;
- Code Cabinet and save skeleton now require delivery-lint before long code is sent;
- downloaded ps1 execution-policy bypass run command is captured;
- no broad framework was created.

Boundary:
- no doctrine install;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard/automation/runtime/knowledge graph/full lesson index;
- no script promotion.

Next move:
- continue TODO weakest-link triage on remaining open TODOs;
- use delivery lint on next PowerShell/code delivery.
"@

Append-Once -Path $StatusPath -Marker "2026-05-20 - PowerShell Delivery Lint / Weakest-Link TODO Route" -Text $StatusAppend

$ChangedForHash = @(
    $InstantiationPath,
    $NewRulePath,
    $TriagePath,
    $PowerShellTodoPath,
    $PasteGuardPath,
    $CodeCabinetRulePath,
    $SkeletonPath,
    $TodoControlBoardPath,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashTableText -Paths $ChangedForHash

$Receipt = @"
# PowerShell Delivery Lint Repair Receipt

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

TODO weakest-link triage selected PowerShell Command Safety / Copy Delivery Lint as the top route.

The existing PowerShell TODO had a parked Paste block lint checklist.

Repeated paste and execution-policy failures proved the parked item should become active.

The delivery-lint rule was saved.

PowerShell paste guard was patched.

Code Cabinet bridge method was patched.

Mr.Kleen save package skeleton was patched.

The TODO control board records this route as worked.

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

This receipt proves the PowerShell delivery-lint repair.

It does not prove the remaining TODO board has been fully triaged.

It does not close all command-safety concerns permanently.
"@

Write-NewCleanFile -Path $ReceiptPath -Text $Receipt
Require-Text -Path $ReceiptPath -Needle "PowerShell Command Safety / Copy Delivery Lint"
Require-Text -Path $ReceiptPath -Needle "It does not prove the remaining TODO board has been fully triaged"

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Run-Git add -- $InstantiationPath $NewRulePath $TriagePath $PowerShellTodoPath $PasteGuardPath $CodeCabinetRulePath $SkeletonPath $TodoControlBoardPath $AnchorPath $StatusPath | Out-Null
Run-Git add -f -- $ReceiptPath | Out-Null

$Staged = @(Run-Git diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "Nothing staged. Stop."
}

Run-Git commit -m "Add PowerShell delivery lint guard" | Out-Null
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
Write-Host "POWERSHELL DELIVERY LINT REPAIR SAVED"
Write-Host "Commit: $Short"
Write-Host "HEAD: $Head"
Write-Host "origin/main: $Origin"
Write-Host "Status: clean"
Write-Host "Rule: $NewRulePath"
Write-Host "Triage: $TriagePath"
Write-Host "Instantiation: $InstantiationPath"
Write-Host "TODO updated: $PowerShellTodoPath"
Write-Host "Paste guard patched: $PasteGuardPath"
Write-Host "Code Cabinet patched: $CodeCabinetRulePath"
Write-Host "Skeleton patched: $SkeletonPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt bytes: $ReceiptBytes"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS"
Write-Host "Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; no script promotion"
Write-Host "Next move: continue TODO weakest-link triage on remaining open TODOs"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
