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

function Build-InventoryMarkdown {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Title
    )

    $Lines = New-Object System.Collections.Generic.List[string]
    $Lines.Add("## " + $Title) | Out-Null
    $Lines.Add("") | Out-Null

    if (-not (Test-Path -LiteralPath $Root)) {
        $Lines.Add("MISSING: " + $Root) | Out-Null
        return ($Lines -join [Environment]::NewLine)
    }

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

function Get-StatusPathFromLine {
    param([string]$Line)

    if ($Line.Length -lt 4) {
        throw ("Unexpected git status line: " + $Line)
    }

    $PathPart = $Line.Substring(3).Trim()

    if ($PathPart.Contains(" -> ")) {
        $PathPart = ($PathPart -split " -> ")[-1].Trim()
    }

    $PathPart = $PathPart.Trim('"')
    return ($PathPart -replace "\\","/")
}

function Is-AllowedDirtyPath {
    param([string]$Path)

    $Exact = @(
        "ACTIVE_ANCHOR.txt",
        "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md",
        "BRAIN_LEARNING/MULE_RETURN_KNOWN_PATH_PICKUP_AND_BRAIN_IMPORT_RULE_20260520.md",
        "PROOF_HISTORY/MULE_RETURN_KNOWN_PATH_IMPORT_RECEIPT_20260520.txt"
    )

    if ($Exact -contains $Path) {
        return $true
    }

    if ($Path.StartsWith("HOUSE_WORK/WORK_SHED/MULE_WORKSHOP/RETURNS/", [System.StringComparison]::OrdinalIgnoreCase)) {
        return $true
    }

    return $false
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== MULE RETURN IMPORT RECOVERY START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$Head = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$Short = Get-GitLine rev-parse --short HEAD

if ($Branch -ne "main") {
    throw ("Wrong branch: " + $Branch)
}

$ExpectedHead = "fe54daee837b79210ca1ba07dca57b6ee4ead280"
if ($Head -ne $ExpectedHead) {
    throw ("Unexpected HEAD for recovery. Expected " + $ExpectedHead + " but found " + $Head)
}

if ($Head -ne $Origin) {
    throw "HEAD does not match origin/main. Stop recovery."
}

$StatusLines = @(Invoke-GitChecked status --short --untracked-files=all)
if ($StatusLines.Count -eq 0) {
    throw "Repo is clean. Nothing to recover."
}

$Unexpected = New-Object System.Collections.Generic.List[string]
foreach ($Line in $StatusLines) {
    $PathPart = Get-StatusPathFromLine -Line $Line
    if (-not (Is-AllowedDirtyPath -Path $PathPart)) {
        $Unexpected.Add($Line) | Out-Null
    }
}

if ($Unexpected.Count -gt 0) {
    Write-Host "Unexpected dirty paths:"
    $Unexpected | ForEach-Object { Write-Host $_ }
    throw "Recovery blocked because dirty state includes paths outside mule return import."
}

$ReturnRoot = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS"
if (-not (Test-Path -LiteralPath $ReturnRoot)) {
    throw ("Return root missing: " + $ReturnRoot)
}

$ReturnDirItem = Get-ChildItem -LiteralPath $ReturnRoot -Directory -Filter "BIG_OVERALL_JOB_*_RETURN_INTAKE_*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $ReturnDirItem) {
    throw "No partial return intake directory found to recover."
}

$ReturnDir = $ReturnDirItem.FullName
$ReturnDirRel = Get-RelativePathSafe -Root $Repo -FullName $ReturnDir
$RawReturnDir = Join-Path $ReturnDir "RAW_RETURN_DUMP"
$RawPacketDir = Join-Path $ReturnDir "RAW_PACKET_CONTEXT"
$IntakeReportPath = Join-Path $ReturnDir "INTAKE_REPORT.md"
$DispositionPath = Join-Path $ReturnDir "INITIAL_DISPOSITION_MATRIX.md"

foreach ($Path in @($RawReturnDir,$RawPacketDir,$IntakeReportPath,$DispositionPath)) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw ("Partial import missing required recovery path: " + $Path)
    }
}

$RawReturnCount = @(Get-ChildItem -LiteralPath $RawReturnDir -File -Recurse -Force).Count
$RawPacketCount = @(Get-ChildItem -LiteralPath $RawPacketDir -File -Recurse -Force).Count

if ($RawReturnCount -lt 1) {
    throw "Raw return dump is empty. Recovery blocked."
}

$WorkshopRoot = Join-Path $env:USERPROFILE "Desktop\MR_KLEEN_MULE_WORKSHOP_LOCAL"
$KnownPacket = Get-ChildItem -LiteralPath $WorkshopRoot -Directory -Filter "BIG_OVERALL_JOB_*" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$KnownPacketPath = if ($KnownPacket) { $KnownPacket.FullName } else { "UNKNOWN_AFTER_PARTIAL_IMPORT" }
$KnownDumpPath = if ($KnownPacket) { Join-Path $KnownPacket.FullName "MULE_OUTPUT_DUMP_ONLY" } else { "UNKNOWN_AFTER_PARTIAL_IMPORT" }

$RulePath = "BRAIN_LEARNING\MULE_RETURN_KNOWN_PATH_PICKUP_AND_BRAIN_IMPORT_RULE_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$ReceiptPath = "PROOF_HISTORY\MULE_RETURN_KNOWN_PATH_IMPORT_RECEIPT_20260520.txt"

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

Stale checker result can block adoption but should not block custody import.

If the repo moved after packet creation, import the return as stale/needs-review source material and clearly mark it as not adopted.

## Rule-Concept-Event link

Rule:
Known mule return paths must be auto-used for pickup/import.

Concept:
Path/place/key memory health; worker return custody; rule exists must fire at the point of work.

Event:
After a local mule packet was created, the user said the mule was done and then corrected the assistant for asking where the files were even though the path was already known.

Proof state:
First live repair/import run created this rule and imported the known-path mule return into brain custody. This recovery save also records the proof-guard catch: an exact verification needle mismatch stopped the first script after writes but before commit, and recovery completed from allowed dirty state only.

Boundary:
This rule does not make mule output command authority. It only governs pickup, custody, and intake routing.
'@

Write-Utf8Text -Path $RulePath -Text $Rule
Assert-Needle -Path $RulePath -Needle "Stale checker result can block adoption but should not block custody import"

$ReturnInventory = Build-InventoryMarkdown -Root $RawReturnDir -Title "Raw return dump inventory"
$PacketInventory = Build-InventoryMarkdown -Root $RawPacketDir -Title "Raw packet context inventory"

$RecoveredReport = @"
# Mule Return Intake Report - Known Path Import

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / MULE_WORKSHOP / RETURNS
Status: raw return imported into brain custody / recovered after proof-guard stop
Authority: custody/intake only; not adoption

## Known-path pickup

The assistant created the mule packet and already knew the workshop path.

Known workshop root:
$WorkshopRoot

Selected/latest packet:
$KnownPacketPath

Known/latest output dump:
$KnownDumpPath

Imported return lane:
$ReturnDirRel

## Recovery note

The first import script correctly stopped before commit because a verification needle was too exact and did not match the written rule text.

Failure type:
proof guard stopped after writes, before git add/commit.

Recovery method:
allowed-dirty-state recovery only. Recovery verified that dirty paths were limited to mule return import paths, rewrote the rule with the required exact stale-boundary line, rebuilt receipt, then commits the custody import.

## Repo state at recovery

Repo: $Repo
Branch: $Branch
Current HEAD before recovery commit: $Head
Current short before recovery commit: $Short
origin/main before recovery commit: $Origin

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

Write-Utf8Text -Path $IntakeReportPath -Text $RecoveredReport
Assert-Needle -Path $IntakeReportPath -Needle "recovered after proof-guard stop"

$Anchor = @"
# ACTIVE ANCHOR

Date: 2026-05-20
Base before recovery save: $Head
Current active ball after this save: Mule return imported into brain custody; read/disposition next

## Last completed move

Recovered the known-path mule return import after the first import script stopped on an exact verification-needle mismatch.

Known/latest local packet:
$KnownPacketPath

Imported brain lane:
$ReturnDirRel

Rule added/repaired:
$RulePath

## Current control state

Mule return files are now in the brain as raw custody material.

They are not adopted.

The return was created from an older packet base than the current discussion-learning save, so it must be treated as custody/source material until read and dispositioned.

## Next allowed move

Read the imported intake report and raw return files in order.

Start with:

1. $($IntakeReportPath.Replace($Repo + "\",""))
2. $($DispositionPath.Replace($Repo + "\",""))
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
Assert-Needle -Path $AnchorPath -Needle "Mule return imported into brain custody"

$StatusAppend = @"

---

## 2026-05-20 - Mule return known-path import recovery

Base before recovery save: $Head
Base short: $Short
Status before recovery: dirty only in allowed mule return import paths

Known/latest mule packet:
$KnownPacketPath

Known/latest mule dump:
$KnownDumpPath

Imported brain return lane:
$ReturnDirRel

Saved/repaired rule:
$RulePath

Failure repaired:
The first import script stopped after writes but before commit because an exact verification needle was too strict. Recovery checked dirty state, allowed only mule return import paths, rewrote the rule with exact stale-boundary wording, and completed the custody import.

Meaning:
The assistant knew the mule path and should have auto-used it. The known-path pickup/import rule now reflects the real routine: locate the local workshop, get the dump files with PowerShell, place custody copies in the brain, preserve originals, create intake report/disposition, and only then read/adopt.

Boundary:
Custody import only. No mule output adopted. No doctrine rewrite. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No dashboard, automation, runtime, knowledge graph, full lesson index, or promotion.

Next:
Read imported mule return files in order and build full disposition before any adoption/save.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

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

$Receipt = @"
MULE RETURN KNOWN-PATH IMPORT RECOVERY RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD before recovery commit: $Head
Base short before recovery commit: $Short
origin/main before recovery commit: $Origin

Recovery cause:
The first import script wrote the mule return import files, then stopped before git add/commit because the verification needle expected exact wording that was not present in the rule file.

Recovery guard:
Dirty-state check allowed only these lanes:
- ACTIVE_ANCHOR.txt
- HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
- BRAIN_LEARNING/MULE_RETURN_KNOWN_PATH_PICKUP_AND_BRAIN_IMPORT_RULE_20260520.md
- HOUSE_WORK/WORK_SHED/MULE_WORKSHOP/RETURNS/*
- PROOF_HISTORY/MULE_RETURN_KNOWN_PATH_IMPORT_RECEIPT_20260520.txt

Known/latest local mule packet:
$KnownPacketPath

Known/latest mule dump:
$KnownDumpPath

Imported brain custody lane:
$ReturnDirRel

Raw return files imported:
$RawReturnCount

Raw packet context files imported:
$RawPacketCount

Rule saved/repaired:
$RulePath

Reports saved:
- $($IntakeReportPath.Replace($Repo + "\",""))
- $($DispositionPath.Replace($Repo + "\",""))

Hashes:
$($HashLines -join [Environment]::NewLine)

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
Assert-Needle -Path $ReceiptPath -Needle "KNOWN-PATH IMPORT RECOVERY RECEIPT"

$DirtyAfterRepair = @(Invoke-GitChecked status --short --untracked-files=all)
if ($DirtyAfterRepair.Count -eq 0) {
    throw "No dirty paths after recovery writes; nothing to commit."
}

foreach ($Line in $DirtyAfterRepair) {
    $PathPart = Get-StatusPathFromLine -Line $Line
    if (-not (Is-AllowedDirtyPath -Path $PathPart)) {
        throw ("Unexpected dirty path after recovery writes: " + $Line)
    }
}

Invoke-GitChecked add -- $RulePath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReturnDirRel $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) {
    throw "No staged files before commit."
}

Invoke-GitChecked commit -m "Recover mule return known path import" | Out-Null
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
Write-Host "MULE RETURN KNOWN-PATH IMPORT RECOVERED AND SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Imported brain lane:"
Write-Host ("- " + $ReturnDirRel)
Write-Host ""
Write-Host "Saved/repaired rule:"
Write-Host ("- " + $RulePath)
Write-Host ""
Write-Host "Saved reports:"
Write-Host ("- " + $($IntakeReportPath.Replace($Repo + "\","")))
Write-Host ("- " + $($DispositionPath.Replace($Repo + "\","")))
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Counts:"
Write-Host ("- Raw return files imported: " + $RawReturnCount)
Write-Host ("- Raw packet context files imported: " + $RawPacketCount)
Write-Host ""
Write-Host "Failure repaired:"
Write-Host "- Exact verification needle mismatch stopped first script after writes and before commit."
Write-Host "- Recovery allowed only mule return import dirty paths."
Write-Host "- Rule now contains exact stale-boundary wording."
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
