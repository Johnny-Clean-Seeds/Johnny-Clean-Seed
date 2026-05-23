$ErrorActionPreference = "Stop"

function Invoke-GitChecked {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(& git @Args 2>&1)
    if ($LASTEXITCODE -ne 0) {
        $Output | ForEach-Object { Write-Host $_ }
        throw ("Git failed: git " + ($Args -join " "))
    }
    return $Output
}

function Get-GitLine {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(Invoke-GitChecked @Args)
    if ($Output.Count -lt 1) {
        throw ("Git returned no output: git " + ($Args -join " "))
    }
    return ([string]($Output | Select-Object -First 1)).Trim()
}

function Write-Utf8Text {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )

    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8

    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) {
        throw ("Wrote empty file: " + $Path)
    }
    if ($Raw.Contains([char]0)) {
        throw ("NUL byte found after write: " + $Path)
    }
    if ($Raw.Contains([char]0xFFFD)) {
        throw ("Replacement character found after write: " + $Path)
    }
}

function Assert-Needle {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle
    )

    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if (-not $Raw.Contains($Needle)) {
        throw ("Verification needle missing in " + $Path + ": " + $Needle)
    }
}

function Get-RelativePathSafe {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$FullName
    )

    $RootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd('\')
    $FileFull = [System.IO.Path]::GetFullPath($FullName)
    if (-not $FileFull.StartsWith($RootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw ("File is not under root: " + $FullName)
    }
    return $FileFull.Substring($RootFull.Length).TrimStart('\')
}

function Copy-TreeFiles {
    param(
        [Parameter(Mandatory = $true)][string]$SourceDir,
        [Parameter(Mandatory = $true)][string]$DestDir
    )

    if (-not (Test-Path -LiteralPath $SourceDir)) {
        throw ("Source folder missing: " + $SourceDir)
    }

    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null

    $Files = @(Get-ChildItem -LiteralPath $SourceDir -File -Recurse -Force)
    foreach ($File in $Files) {
        $Rel = Get-RelativePathSafe -Root $SourceDir -FullName $File.FullName
        $Dest = Join-Path $DestDir $Rel
        $Parent = Split-Path -Parent $Dest
        if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
            New-Item -ItemType Directory -Path $Parent -Force | Out-Null
        }
        Copy-Item -LiteralPath $File.FullName -Destination $Dest -Force
    }
    return $Files
}

function Build-InventoryMarkdown {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Title
    )

    $Lines = New-Object System.Collections.Generic.List[string]
    $Lines.Add("## " + $Title) | Out-Null
    $Lines.Add("") | Out-Null
    $Files = @(Get-ChildItem -LiteralPath $Root -File -Recurse -Force | Sort-Object FullName)
    if ($Files.Count -eq 0) {
        $Lines.Add("No files found.") | Out-Null
    } else {
        $Lines.Add("| File | Bytes | SHA256 |") | Out-Null
        $Lines.Add("|---|---:|---|") | Out-Null
        foreach ($File in $Files) {
            $Rel = Get-RelativePathSafe -Root $Root -FullName $File.FullName
            $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $File.FullName).Hash
            $Lines.Add("| " + ($Rel -replace "\|", "\|") + " | " + $File.Length + " | " + $Hash + " |") | Out-Null
        }
    }
    return ($Lines -join [Environment]::NewLine)
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== MULE RETURN KNOWN-PATH IMPORT START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$BaseHead = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$BaseShort = Get-GitLine rev-parse --short HEAD
$Status = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") {
    throw ("Wrong branch: " + $Branch)
}

if ($BaseHead -ne $Origin) {
    throw "HEAD does not match origin/main. Stop before mule return import."
}

if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Repo is dirty. Stop before mule return import."
}

$ExpectedCurrent = "fe54daee837b79210ca1ba07dca57b6ee4ead280"
if ($BaseHead -ne $ExpectedCurrent) {
    throw ("Current HEAD changed. Expected " + $ExpectedCurrent + " but found " + $BaseHead + ". Stop and reassess before importing mule return.")
}

$WorkshopRoot = Join-Path $env:USERPROFILE "Desktop\MR_KLEEN_MULE_WORKSHOP_LOCAL"
if (-not (Test-Path -LiteralPath $WorkshopRoot)) {
    throw ("Known mule workshop root missing: " + $WorkshopRoot)
}

$Packet = Get-ChildItem -LiteralPath $WorkshopRoot -Directory -Filter "BIG_OVERALL_JOB_*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $Packet) {
    throw ("No BIG_OVERALL_JOB packet found under known mule workshop root: " + $WorkshopRoot)
}

$PacketRoot = $Packet.FullName
$DumpDir = Join-Path $PacketRoot "MULE_OUTPUT_DUMP_ONLY"
$JobsDir = Join-Path $PacketRoot "JOBS"
$StateSnapshotDir = Join-Path $PacketRoot "STATE_SNAPSHOT"
$StaleCheckerPath = Join-Path $PacketRoot "STALE_CHECKER_001.ps1"

if (-not (Test-Path -LiteralPath $DumpDir)) {
    throw ("Mule output dump missing: " + $DumpDir)
}

$ReturnFilesBeforeChecker = @(Get-ChildItem -LiteralPath $DumpDir -File -Force | Sort-Object Name)
if ($ReturnFilesBeforeChecker.Count -eq 0) {
    throw ("Mule output dump contains no files: " + $DumpDir)
}

$CheckerResultText = "STALE_CHECKER_NOT_RUN"
$CheckerResultFile = $null
if (Test-Path -LiteralPath $StaleCheckerPath) {
    try {
        $CheckerOutput = @(& $StaleCheckerPath 2>&1)
        $CheckerResultText = ($CheckerOutput | ForEach-Object { [string]$_ }) -join [Environment]::NewLine
    } catch {
        $CheckerResultText = "STALE_CHECKER_EXECUTION_FAILED: " + $_.Exception.Message
    }

    $CheckerResultFile = Get-ChildItem -LiteralPath $DumpDir -File -Filter "STALE_CHECK_RESULT_*.txt" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReturnName = $Packet.Name + "_RETURN_INTAKE_" + $Stamp
$ReturnDir = Join-Path "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS" $ReturnName
$RawReturnDir = Join-Path $ReturnDir "RAW_RETURN_DUMP"
$RawPacketDir = Join-Path $ReturnDir "RAW_PACKET_CONTEXT"

New-Item -ItemType Directory -Path $RawReturnDir -Force | Out-Null
New-Item -ItemType Directory -Path $RawPacketDir -Force | Out-Null

$CopiedReturnFiles = Copy-TreeFiles -SourceDir $DumpDir -DestDir $RawReturnDir

foreach ($TopFile in @("MANIFEST.md","MULE_READ_FIRST.md","OUTPUT_CONTRACT.md","STALE_CHECKER_001.ps1","RUN_STALE_CHECKER_FROM_HERE.ps1","PACKET_FILE_HASHES.txt")) {
    $Src = Join-Path $PacketRoot $TopFile
    if (Test-Path -LiteralPath $Src) {
        Copy-Item -LiteralPath $Src -Destination (Join-Path $RawPacketDir $TopFile) -Force
    }
}

if (Test-Path -LiteralPath $JobsDir) {
    Copy-TreeFiles -SourceDir $JobsDir -DestDir (Join-Path $RawPacketDir "JOBS") | Out-Null
}

if (Test-Path -LiteralPath $StateSnapshotDir) {
    Copy-TreeFiles -SourceDir $StateSnapshotDir -DestDir (Join-Path $RawPacketDir "STATE_SNAPSHOT") | Out-Null
}

$ReturnFilesAfterChecker = @(Get-ChildItem -LiteralPath $DumpDir -File -Force | Sort-Object Name)
$ReturnInventory = Build-InventoryMarkdown -Root $RawReturnDir -Title "Raw return dump inventory"
$PacketInventory = Build-InventoryMarkdown -Root $RawPacketDir -Title "Raw packet context inventory"

$MulePacketBase = "e9bc566bb432817f266e6604595172f5e95afb21"
$StaleMeaning = "Packet was built from e9bc566. Current repo is fe54dae because the discussion-learning save happened after packet creation. This makes the return STALE FOR ADOPTION but VALID FOR CUSTODY IMPORT. It must be read/dispositioned before any application."

$IntakeReportPath = Join-Path $ReturnDir "INTAKE_REPORT.md"
$DispositionPath = Join-Path $ReturnDir "INITIAL_DISPOSITION_MATRIX.md"
$RulePath = "BRAIN_LEARNING\MULE_RETURN_KNOWN_PATH_PICKUP_AND_BRAIN_IMPORT_RULE_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ReceiptPath = "PROOF_HISTORY\MULE_RETURN_KNOWN_PATH_IMPORT_RECEIPT_20260520.txt"

$IntakeReport = @"
# Mule Return Intake Report - Known Path Import

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / MULE_WORKSHOP / RETURNS
Status: raw return imported into brain custody
Authority: custody/intake only; not adoption

## Known-path pickup

The assistant created the mule packet and already knew the workshop path.

Known workshop root:
$WorkshopRoot

Selected latest packet:
$PacketRoot

Known output dump:
$DumpDir

Imported return lane:
$ReturnDir

## Repo state at import

Repo: $Repo
Branch: $Branch
Current HEAD: $BaseHead
Current short: $BaseShort
origin/main: $Origin
Status before import: clean

Mule packet base:
$MulePacketBase

Stale meaning:
$StaleMeaning

## Stale checker output

```text
$CheckerResultText
```

## Custody rule

This import copies the mule return into brain custody while preserving the original local workshop.

The original mule dump is not deleted. This is the clean version of "move to brain": place a custody copy in the brain lane, keep source evidence intact, then read/disposition from the imported brain copy.

## What this import does

- Finds the latest local mule packet automatically.
- Reads known MULE_OUTPUT_DUMP_ONLY location.
- Copies raw return files into brain custody.
- Copies packet context and job specs into brain custody.
- Creates inventory and initial disposition.
- Saves a rule so future mule returns are picked up automatically instead of asking the user where they are.

## What this import does not do

- Does not adopt mule recommendations.
- Does not rewrite doctrine.
- Does not rewrite active guides.
- Does not rewrite CURRENT_TRUTH_INDEX.
- Does not promote stale checker, relation map, tools, suits, or rules.
- Does not decide final recommendations.

$ReturnInventory

$PacketInventory
"@

Write-Utf8Text -Path $IntakeReportPath -Text $IntakeReport

$DispositionLines = New-Object System.Collections.Generic.List[string]
$DispositionLines.Add("# Initial Disposition Matrix - Mule Return Known-Path Import") | Out-Null
$DispositionLines.Add("") | Out-Null
$DispositionLines.Add("Date: 2026-05-20") | Out-Null
$DispositionLines.Add("Status: initial custody disposition only") | Out-Null
$DispositionLines.Add("Rule: no mule output adopted during import.") | Out-Null
$DispositionLines.Add("") | Out-Null
$DispositionLines.Add("| Return file | Initial disposition | Reason | Next handling |") | Out-Null
$DispositionLines.Add("|---|---|---|---|") | Out-Null

foreach ($File in @(Get-ChildItem -LiteralPath $RawReturnDir -File -Recurse -Force | Sort-Object FullName)) {
    $Rel = Get-RelativePathSafe -Root $RawReturnDir -FullName $File.FullName
    $Disposition = "NEEDS READING"
    $Reason = "Imported into brain custody only; not yet inspected for content."
    $Next = "Read in manifest/order, then apply/adapt/park/reject/needs-proof."
    if ($Rel -match "STALE_BLOCKED|STALE_CHECK_RESULT") {
        $Disposition = "STALE/CUSTODY SIGNAL"
        $Reason = "Stale/check output must be read before applying recommendations."
        $Next = "Use to judge adoption boundary."
    }
    if ($Rel -match "README_OUTPUT_DUMP_ONLY|RETURN_MANIFEST_TEMPLATE") {
        $Disposition = "PACKET SUPPORT"
        $Reason = "Template/support file, not recommendation."
        $Next = "Keep as custody context."
    }
    $DispositionLines.Add("| " + ($Rel -replace "\|", "\|") + " | " + $Disposition + " | " + $Reason + " | " + $Next + " |") | Out-Null
}

Write-Utf8Text -Path $DispositionPath -Text ($DispositionLines -join [Environment]::NewLine)

$Rule = @'
# Mule Return Known-Path Pickup And Brain Import Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support rule / routine correction
Parent Boss: Mule Workshop / Return Intake / Rule Activation
Authority: not doctrine, not active guide, not CURRENT_TRUTH_INDEX, not dashboard

## Core correction

If the assistant created the mule packet, recorded the workshop path, and the user says the mule is done, the assistant must not ask where the files are.

The routine is:

1. Use the known mule workshop root.
2. Locate the latest or explicitly named mule packet.
3. Find its `MULE_OUTPUT_DUMP_ONLY` folder.
4. Run/read stale checker if available.
5. Copy the return into a brain custody lane.
6. Preserve the original local workshop evidence.
7. Create an intake report and initial disposition matrix.
8. Commit/push the custody import if the user asked to move/save it to the brain.
9. Only after custody import, read and disposition the return contents.

## Important wording

"Move to brain" in this workflow means place a custody copy into the Mr.Kleen repo/remote brain.

Do not delete the original mule workshop folder unless the user explicitly asks for cleanup after proof. Preserving source evidence is part of clean custody.

## Alarm condition

If the assistant knows the path and still asks the user where the files are, this is a rule-not-fired event.

The missed rule must trigger the rule-not-fired alarm:

- missed rule: known-path mule pickup;
- concept: worker return custody / retrieval routine;
- event: user says mule is done after assistant created packet;
- correction: auto-locate and import with PowerShell.

## Stale boundary

A stale checker result can block adoption but should not block custody import.

If the repo moved after packet creation, import the return as stale/needs-review source material and clearly mark it as not adopted.

## Rule-Concept-Event link

Rule:
Known mule return paths must be auto-used for pickup/import.

Concept:
Path/place/key memory health; worker return custody; rule exists must fire at the point of work.

Event:
After a local mule packet was created, the user said the mule was done and then corrected the assistant for asking where the files were even though the path was already known.

Proof state:
First live repair/import run created this rule and imported the known-path mule return into brain custody.

Boundary:
This rule does not make mule output command authority. It only governs pickup, custody, and intake routing.
'@

Write-Utf8Text -Path $RulePath -Text $Rule

$Anchor = @"
# ACTIVE ANCHOR

Date: 2026-05-20
Base before save: $BaseHead
Current active ball after this save: Mule return imported into brain custody; read/disposition next

## Last completed move

Imported the known-path mule return into Mr.Kleen brain custody.

Known local packet:
$PacketRoot

Imported brain lane:
$ReturnDir

Rule added:
$RulePath

## Current control state

Mule return files are now in the brain as raw custody material.

They are not adopted.

The return is stale for direct adoption because the packet was built from e9bc566 while current repo state is fe54dae after the discussion-learning save.

The return is valid for custody import and ordered intake.

## Next allowed move

Read the imported intake report and raw return files in order.

Start with:

1. $IntakeReportPath
2. $DispositionPath
3. raw return manifest/summary files if present
4. all remaining raw return files

Then create a full return disposition before applying any recommendation.

## Blocked moves

- Do not treat mule output as command authority.
- Do not cherry-pick one recommendation before reading the full imported return.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not promote stale checker, relation map, tools, suits, or rules from custody import alone.
"@

Write-Utf8Text -Path $AnchorPath -Text $Anchor

$StatusAppend = @"

---

## 2026-05-20 - Mule return known-path import

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Known mule packet:
$PacketRoot

Known mule dump:
$DumpDir

Imported brain return lane:
$ReturnDir

Saved rule:
$RulePath

Meaning:
The assistant knew the mule path and should have auto-used it. The known-path pickup/import rule now reflects the real routine: locate the local workshop, get the dump files with PowerShell, place custody copies in the brain, preserve originals, create intake report/disposition, and only then read/adopt.

Boundary:
Custody import only. No mule output adopted. No doctrine rewrite. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No dashboard, automation, runtime, knowledge graph, full lesson index, or promotion.

Next:
Read imported mule return files in order and build full disposition before any adoption/save.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $RulePath -Needle "must not ask where the files are"
Assert-Needle -Path $RulePath -Needle "Stale checker result can block adoption but should not block custody import"
Assert-Needle -Path $IntakeReportPath -Needle "Imported return lane"
Assert-Needle -Path $DispositionPath -Needle "no mule output adopted during import"
Assert-Needle -Path $AnchorPath -Needle "Mule return imported into brain custody"

$HashTargets = @(
    $RulePath,
    $IntakeReportPath,
    $DispositionPath,
    $AnchorPath,
    $StatusPath
)

$HashLines = New-Object System.Collections.Generic.List[string]
foreach ($Path in $HashTargets) {
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    $HashLines.Add("- " + $Path + " | sha256=" + $Hash) | Out-Null
}

$RawReturnCount = @(Get-ChildItem -LiteralPath $RawReturnDir -File -Recurse -Force).Count
$RawPacketCount = @(Get-ChildItem -LiteralPath $RawPacketDir -File -Recurse -Force).Count

$Receipt = @"
MULE RETURN KNOWN-PATH IMPORT RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Known local mule packet:
$PacketRoot

Known mule dump:
$DumpDir

Imported brain custody lane:
$ReturnDir

Raw return files imported:
$RawReturnCount

Raw packet context files imported:
$RawPacketCount

Rule saved:
$RulePath

Reports saved:
- $IntakeReportPath
- $DispositionPath

Hashes:
$($HashLines -join [Environment]::NewLine)

Stale meaning:
$StaleMeaning

Boundary held:
- custody import only;
- no mule output adoption;
- no doctrine rewrite;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no tool/suit/stale-checker/relation-map promotion;
- original local mule workshop preserved.

Next move:
Read imported return intake report and returned files in order; full disposition before adoption/save.
"@

Write-Utf8Text -Path $ReceiptPath -Text $Receipt
Assert-Needle -Path $ReceiptPath -Needle "KNOWN-PATH IMPORT RECEIPT"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) {
    throw "No changes detected after mule return import."
}

Invoke-GitChecked add -- $RulePath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReturnDir $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "No staged files before commit."
}

Invoke-GitChecked commit -m "Import mule return from known path" | Out-Null
Invoke-GitChecked push origin main | Out-Null
Invoke-GitChecked fetch origin main | Out-Null

$FinalHead = Get-GitLine rev-parse HEAD
$FinalOrigin = Get-GitLine rev-parse origin/main
$FinalShort = Get-GitLine rev-parse --short HEAD
$FinalStatus = @(Invoke-GitChecked status --short)

if ($FinalHead -ne $FinalOrigin) {
    throw "Final proof failed: HEAD does not match origin/main."
}

if ($FinalStatus.Count -ne 0) {
    Write-Host "Final dirty status:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final proof failed: status not clean."
}

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "MULE RETURN KNOWN-PATH IMPORT SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Known packet:"
Write-Host ("- " + $PacketRoot)
Write-Host "Known dump:"
Write-Host ("- " + $DumpDir)
Write-Host "Imported brain lane:"
Write-Host ("- " + $ReturnDir)
Write-Host ""
Write-Host "Saved rule:"
Write-Host ("- " + $RulePath)
Write-Host ""
Write-Host "Saved reports:"
Write-Host ("- " + $IntakeReportPath)
Write-Host ("- " + $DispositionPath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Counts:"
Write-Host ("- Raw return files imported: " + $RawReturnCount)
Write-Host ("- Raw packet context files imported: " + $RawPacketCount)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS: known-path mule pickup routine repaired."
Write-Host "- PASS: mule return files placed in brain custody."
Write-Host "- PASS: original local workshop preserved."
Write-Host "- PASS: mule output remains not adopted."
Write-Host ""
Write-Host "Boundary:"
Write-Host "- No doctrine rewrite."
Write-Host "- No active guide rewrite."
Write-Host "- No CURRENT_TRUTH_INDEX rewrite."
Write-Host "- No dashboard, automation, runtime, knowledge graph, or full lesson index."
Write-Host "- No stale-checker/relation-map/tool/suit promotion."
Write-Host "- No mule output adoption."
Write-Host ""
Write-Host "Next move:"
Write-Host "- Read imported return intake report and raw return files in order."
Write-Host "- Build full disposition before adoption/save."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
