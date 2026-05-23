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

function Get-GitStatusPathList {
    $Lines = @(Run-Git status --short)
    $Out = New-Object System.Collections.Generic.List[string]

    foreach ($Line in $Lines) {
        if ([string]::IsNullOrWhiteSpace($Line)) { continue }

        $Path = $Line
        if ($Line.Length -ge 4) {
            $Path = $Line.Substring(3).Trim()
        }

        if ($Path.Contains(" -> ")) {
            $Path = ($Path -split " -> ")[-1].Trim()
        }

        $Out.Add($Path.Replace("\", "/"))
    }

    return $Out.ToArray()
}

if (-not (Test-Path ".git")) {
    throw "Not inside Mr.Kleen repo home."
}

Write-Host "XxXxX ===== POWERSHELL DELIVERY LINT RECOVERY V2 START ===== XxXxX"

Run-Git fetch origin main | Out-Null

$Branch = Git-Line branch --show-current
$HeadBefore = Git-Line rev-parse HEAD
$OriginBefore = Git-Line rev-parse origin/main

if ($Branch -ne "main") {
    throw "Wrong branch: $Branch"
}

if ($HeadBefore -ne $OriginBefore) {
    throw "HEAD does not match origin/main. Stop recovery."
}

$SkeletonPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\MR_KLEEN_SAVE_PACKAGE_SKELETON_20260520.md"
$CodeCabinetRulePath = "BRAIN_LEARNING\CODE_CABINET_BRIDGE_METHOD_RULE_20260520.md"
$PowerShellTodoPath = "HOUSE_WORK\TODO\POWERSHELL_COMMAND_SAFETY_TODO_20260520.md"
$PasteGuardPath = "BRAIN_LEARNING\POWERSHELL_PASTE_FALSE_SUCCESS_GUARD_20260520.md"
$TodoControlBoardPath = "HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$NewRulePath = "BRAIN_LEARNING\POWERSHELL_COPY_DELIVERY_LINT_AND_SCRIPT_EXECUTION_RULE_20260520.md"
$TriagePath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\POWERSHELL_DELIVERY_REPEAT_FAILURE_WEAKEST_LINK_TRIAGE_20260520.md"
$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\POWERSHELL_DELIVERY_LINT_REPAIR_INSTANTIATION_20260520.md"
$ReceiptPath = "PROOF_HISTORY\POWERSHELL_DELIVERY_LINT_REPAIR_RECEIPT_20260520.txt"

$ExpectedDirtyBeforeRecovery = @(
    $InstantiationPath,
    $NewRulePath,
    $TriagePath,
    $PowerShellTodoPath,
    $PasteGuardPath,
    $CodeCabinetRulePath,
    $SkeletonPath,
    $TodoControlBoardPath
) | ForEach-Object { $_.Replace("\", "/") }

$CurrentDirty = @(Get-GitStatusPathList)
$Unexpected = @($CurrentDirty | Where-Object { $ExpectedDirtyBeforeRecovery -notcontains $_ })
$MissingExpected = @($ExpectedDirtyBeforeRecovery | Where-Object { $CurrentDirty -notcontains $_ })

if ($Unexpected.Count -gt 0) {
    Write-Host "Unexpected dirty paths:"
    $Unexpected | ForEach-Object { Write-Host $_ }
    throw "Recovery stopped: dirty state contains unexpected paths."
}

if ($MissingExpected.Count -gt 0) {
    Write-Host "Expected dirty paths not present:"
    $MissingExpected | ForEach-Object { Write-Host $_ }
    throw "Recovery stopped: dirty state does not match failed run."
}

if (Test-Path $ReceiptPath) {
    throw "Receipt already exists. Stop before overwrite: $ReceiptPath"
}

$RequiredFiles = @(
    $SkeletonPath,
    $CodeCabinetRulePath,
    $PowerShellTodoPath,
    $PasteGuardPath,
    $TodoControlBoardPath,
    $NewRulePath,
    $TriagePath,
    $InstantiationPath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredFiles) {
    Assert-CleanTextFile -Path $Path
}

Require-Text -Path $NewRulePath -Needle "Before sending PowerShell or long code"
Require-Text -Path $NewRulePath -Needle "For downloaded ps1 files"
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
- This save used a recovery path after a required-text check mismatch stopped the first run before git add/commit.
- Recovery V1 stopped safely because dirty-path parsing wrapped the path list as one object; Recovery V2 fixed the parser and allowed only the expected dirty paths.

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
- recovery path completed after the first run stopped on an overly strict case-sensitive required-text check;
- Recovery V1 stopped safely because dirty-path parsing wrapped the path list as one object;
- Recovery V2 completed after checking only the expected dirty paths;
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

## Recovery

First run stopped before git add/commit because one required-text check was too strict:

Required needle:
Downloaded ps1 files

Actual saved text:
For downloaded ps1 files

Recovery V1 stopped safely because dirty-path parsing wrapped the whole path list as one object.

Recovery V2 fixed the parser and allowed only the expected dirty paths from the stopped run, then completed anchor/status/receipt/save.

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

- expected dirty paths only during recovery;
- target files from the stopped run existed and were readable;
- required inputs existed and were readable;
- files were readable UTF-8 text;
- files were nonempty;
- no NUL bytes;
- no Unicode replacement characters;
- no placeholder markers;
- required phrases verified;
- branch main;
- HEAD equals origin/main before save;
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
Require-Text -Path $ReceiptPath -Needle "expected dirty paths only during recovery"
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
