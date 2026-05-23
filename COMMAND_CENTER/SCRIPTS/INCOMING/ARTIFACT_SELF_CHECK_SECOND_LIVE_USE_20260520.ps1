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

Write-Host "XxXxX ===== ARTIFACT SELF CHECK SECOND LIVE USE START ===== XxXxX"

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

$ArtifactTodoPath = "HOUSE_WORK\TODO\ARTIFACT_SELF_CHECK_AFTER_SEND_TODO_20260520.md"
$ComposeTodoPath = "HOUSE_WORK\TODO\COMPOSE_REVIEW_REFLECT_CAPTURE_LIVE_USE_TODO_20260520.md"
$BossGhostMapPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\BOSS_GHOST_TODO_BOARD_TRIAGE_MAP_20260520.md"
$ResolverRulePath = "BRAIN_LEARNING\DOWNLOADED_PS1_RESOLVER_AND_SOURCE_VALIDATION_RULE_20260520.md"
$DeliveryFixPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\DOWNLOADED_PS1_RESOLVER_SOURCE_VALIDATION_FIX_20260520.md"
$HandoffCardPath = "HOUSE_WORK\WORK_SHED\AGENT_HANDOFFS\HANDOFF_ASSISTANT_SAFE_SAVE_METHOD_CARD_20260520.md"
$SkeletonPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\MR_KLEEN_SAVE_PACKAGE_SKELETON_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$InstantiationPath = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CODE_CABINET\ARTIFACT_SELF_CHECK_SECOND_LIVE_USE_INSTANTIATION_20260520.md"
$DispositionPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\ARTIFACT_SELF_CHECK_SECOND_LIVE_USE_POWERSHELL_DELIVERY_20260520.md"
$ReceiptPath = "PROOF_HISTORY\ARTIFACT_SELF_CHECK_SECOND_LIVE_USE_RECEIPT_20260520.txt"

$RequiredInputs = @(
    $ArtifactTodoPath,
    $ComposeTodoPath,
    $BossGhostMapPath,
    $ResolverRulePath,
    $DeliveryFixPath,
    $HandoffCardPath,
    $SkeletonPath,
    $AnchorPath,
    $StatusPath
)

foreach ($Path in $RequiredInputs) {
    Assert-CleanTextFile -Path $Path
}

foreach ($Target in @($InstantiationPath, $DispositionPath, $ReceiptPath)) {
    if (Test-Path $Target) {
        throw "Target already exists. Stop before overwrite: $Target"
    }
}

$Instantiation = @"
# Artifact Self-Check Second Live Use - Code Cabinet Instantiation

Date: 2026-05-20

## Status

CODE CABINET INSTANTIATION / SECOND VARIED LIVE USE.

## Skeleton Used

$SkeletonPath

## Trigger

Read-only TODO triage showed that Artifact Self-Check After Send remains an open child TODO under Recursive Carryover / Point-of-Work Link Failure.

The recent PowerShell delivery package is a later user-facing artifact case:

- downloadable ps1 delivery;
- resolver command;
- parser check;
- save package;
- receipt;
- final clean synced Git proof.

## Task

Record Artifact Self-Check second/varied live use.

Do not close the TODO.

Do not promote the method.

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

Continue TODO weakest-link triage using the boss/ghost map.
"@

$Disposition = @'
# Artifact Self-Check Second Live Use - PowerShell Delivery Artifact

Date: 2026-05-20

## Status

PASS WITH GUARDRAILS AS SECOND / VARIED LIVE USE.

## Parent

Recursive Carryover / Point-of-Work Link Failure.

## TODO

HOUSE_WORK\TODO\ARTIFACT_SELF_CHECK_AFTER_SEND_TODO_20260520.md

## Artifact Checked

Recent user-facing artifact/package:

- BOSS_GHOST_TODO_MAP_V3_CLEAN_DELIVERY_FIX_20260520.ps1 delivery path;
- downloaded ps1 resolver run command;
- parser check before execution;
- generated Boss/Ghost TODO map;
- generated downloaded ps1 resolver/source-validation rule;
- generated delivery fix note;
- generated receipt;
- updated anchor/status.

## What Failed Before The Check Stabilized

V1:
- stopped before writing because exact source-text validation was brittle.

V2:
- hardcoded Downloads exact path failed;
- resolver found browser-renamed copy;
- source regex validation was still brittle;
- stopped before writing.

V3:
- used resolver-first delivery;
- avoided brittle source text validation;
- checked generated/patched artifacts;
- committed, pushed, fetched, and proved clean.

## Artifact Self-Check Evidence

Checks satisfied by the V3 package:

- downloaded script file was found by resolver;
- parser check passed before execution;
- script ran from the resolved path;
- target files were created intentionally;
- generated files were checked as readable UTF-8 text;
- generated files were nonempty;
- no NUL bytes;
- no replacement characters;
- no placeholder markers;
- required generated/patched phrases verified;
- receipt recorded proof;
- final HEAD equaled origin/main;
- final status was clean.

## Disposition

Artifact Self-Check fired on a second, different artifact type: downloaded PowerShell delivery plus Mr.Kleen save package.

This is stronger than the first live-use but still not enough to close or promote the TODO.

## Still Needed Before Closure

More varied artifact types, such as:

- handoff packet;
- standalone markdown report;
- zip/package;
- document;
- spreadsheet;
- slide deck;
- PDF;
- image output.

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No promotion.

No closure of Artifact Self-Check.

No closure of Compose-Review-Reflect-Capture.
'@

Write-NewCleanFile -Path $InstantiationPath -Text $Instantiation
Write-NewCleanFile -Path $DispositionPath -Text $Disposition

Require-Text -Path $InstantiationPath -Needle "SECOND VARIED LIVE USE"
Require-Text -Path $DispositionPath -Needle "PASS WITH GUARDRAILS AS SECOND / VARIED LIVE USE"
Require-Text -Path $DispositionPath -Needle "This is stronger than the first live-use but still not enough to close or promote the TODO"

$ArtifactMarker = "2026-05-20 - Artifact Self-Check Second Live Use"
$ArtifactAppend = @"
---

## $ArtifactMarker

Status: PASS WITH GUARDRAILS AS SECOND / VARIED LIVE USE.

Artifact type:
- downloadable PowerShell script delivery plus Mr.Kleen save package.

Evidence:
- V1 stopped before writing because exact source-text validation was brittle;
- V2 proved downloaded ps1 resolver was needed and stopped before writing because source regex validation was still brittle;
- V3 used resolver-first delivery, parser check, non-brittle source validation, generated-artifact checks, receipt, commit, push, fetch, HEAD equals origin/main, and final clean status.

Routed home:
- $DispositionPath

Disposition:
- stronger second live-use proof;
- TODO remains open for more varied artifact types;
- no closure;
- no promotion.
"@

$ComposeMarker = "2026-05-20 - Artifact Self-Check Second Live Use Relation"
$ComposeAppend = @"
---

## $ComposeMarker

Status: RELATED PROOF ONLY / WATCH REMAINS OPEN.

Meaning:
- Artifact Self-Check recorded a second varied live use on downloaded PowerShell delivery plus save package.
- Compose-Review-Reflect-Capture remains related but distinct.
- This update does not close Compose-Review and does not promote it.

Related proof:
- $DispositionPath
"@

Append-Once -Path $ArtifactTodoPath -Marker $ArtifactMarker -Text $ArtifactAppend
Append-Once -Path $ComposeTodoPath -Marker $ComposeMarker -Text $ComposeAppend

$Anchor = @"
CURRENT MR.KLEEN POSITION

After Artifact Self-Check second live use.

Base before save:
$HeadBefore

Current ball:
- Artifact Self-Check After Send recorded a second/varied live-use proof.
- The artifact case was downloaded PowerShell delivery plus Mr.Kleen save package.
- V1/V2 failures were used as evidence, but V3 delivered the clean proof.
- Artifact Self-Check remains open for more varied artifacts.
- Compose-Review-Reflect-Capture remains related but distinct and open.
- Boss/Ghost map remains the TODO triage map.
- Downloaded ps1 resolver/source-validation fix remains active method.

Next allowed move:
- Continue TODO weakest-link triage using the boss/ghost map.
- Let proof select the next top route.
- Use resolver-first downloaded ps1 delivery.
- Use Artifact Self-Check for created/sent artifacts.

Blocked moves:
- Do not close Artifact Self-Check from this second live-use alone.
- Do not promote Artifact Self-Check.
- Do not close Compose-Review from this proof.
- Do not install doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
"@

Set-Content -LiteralPath $AnchorPath -Value $Anchor -Encoding UTF8
Assert-CleanTextFile -Path $AnchorPath

$StatusAppend = @"

---

## 2026-05-20 - Artifact Self-Check Second Live Use

Status: PASS WITH GUARDRAILS AS SECOND / VARIED LIVE USE.

Base before save:
$HeadBefore

Saved:
$InstantiationPath
$DispositionPath
$ReceiptPath

Updated:
$ArtifactTodoPath
$ComposeTodoPath
$AnchorPath
$StatusPath

Meaning:
- Artifact Self-Check fired on downloaded PowerShell delivery plus Mr.Kleen save package;
- V1/V2 failures were preserved as evidence of artifact-check pressure;
- V3 clean proof supplied the successful live-use;
- Artifact Self-Check remains open for more varied artifacts;
- Compose-Review remains distinct and open.

Boundary:
- no doctrine install;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard/automation/runtime/knowledge graph/full lesson index;
- no script promotion;
- no closure/promotion of Artifact Self-Check.

Next move:
- continue TODO weakest-link triage using the boss/ghost map.
"@

Append-Once -Path $StatusPath -Marker "2026-05-20 - Artifact Self-Check Second Live Use" -Text $StatusAppend

$ChangedForHash = @(
    $InstantiationPath,
    $DispositionPath,
    $ArtifactTodoPath,
    $ComposeTodoPath,
    $AnchorPath,
    $StatusPath
)

$HashList = Get-HashTableText -Paths $ChangedForHash

$Receipt = @"
# Artifact Self-Check Second Live Use Receipt

Date: 2026-05-20

## Result

PASS WITH GUARDRAILS AS SECOND / VARIED LIVE USE.

## Base Before Save

Branch: $Branch
HEAD before save: $HeadBefore
origin/main before save: $OriginBefore

## Files

$HashList

## Meaning

Artifact Self-Check After Send recorded a second, more varied live-use proof.

The artifact type was downloaded PowerShell delivery plus Mr.Kleen save package.

V1/V2 failures are preserved as evidence, while V3 provides the successful clean proof.

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

No closure of Artifact Self-Check.

No closure of Compose-Review-Reflect-Capture.

## Artifact Self-Check

This save created and checked a real Mr.Kleen artifact package.

Checks performed:

- target files did not already exist before writing;
- source files validated for custody/readability;
- generated artifacts checked for required phrases;
- files readable as UTF-8 text;
- files nonempty;
- no NUL bytes;
- no Unicode replacement characters;
- no placeholder markers;
- branch main;
- HEAD equals origin/main before save;
- clean status before save;
- final commit/push/fetch requires HEAD equals origin/main and status clean.

## Proof Limit

This receipt proves second/varied live-use proof.

It does not close the TODO.

It does not promote the method.

It does not prove future non-PowerShell artifact types.
"@

Write-NewCleanFile -Path $ReceiptPath -Text $Receipt
Require-Text -Path $ReceiptPath -Needle "PASS WITH GUARDRAILS AS SECOND / VARIED LIVE USE"
Require-Text -Path $ReceiptPath -Needle "It does not close the TODO"

$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash
$ReceiptBytes = (Get-Item -LiteralPath $ReceiptPath).Length

Run-Git add -- $InstantiationPath $DispositionPath $ArtifactTodoPath $ComposeTodoPath $AnchorPath $StatusPath | Out-Null
Run-Git add -f -- $ReceiptPath | Out-Null

$Staged = @(Run-Git diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "Nothing staged. Stop."
}

Run-Git commit -m "Record artifact self check second use" | Out-Null
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
Write-Host "ARTIFACT SELF CHECK SECOND LIVE USE SAVED"
Write-Host "Commit: $Short"
Write-Host "HEAD: $Head"
Write-Host "origin/main: $Origin"
Write-Host "Status: clean"
Write-Host "Disposition: $DispositionPath"
Write-Host "Instantiation: $InstantiationPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt bytes: $ReceiptBytes"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS WITH GUARDRAILS AS SECOND / VARIED LIVE USE"
Write-Host "Boundary: no doctrine; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no dashboard/automation/runtime/knowledge graph/full lesson index; no script promotion; no closure/promotion"
Write-Host "Next move: continue TODO weakest-link triage using the boss/ghost map"
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
