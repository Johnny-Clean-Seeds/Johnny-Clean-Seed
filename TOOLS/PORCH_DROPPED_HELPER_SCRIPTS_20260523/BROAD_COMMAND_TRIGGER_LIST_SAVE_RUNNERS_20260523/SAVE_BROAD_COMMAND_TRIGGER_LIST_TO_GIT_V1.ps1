$ErrorActionPreference = "Stop"

# THIS CODE IS FOR LOCAL.
# Purpose: compare the Desktop\123 root copy and the downloaded chat copy of
# BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md, then save the correct object(s)
# into the Mr.Kleen Git repo with receipt proof and push to origin/main.

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"
$PorchRoot = Join-Path $env:USERPROFILE "Desktop\123"
$FileName = "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md"
$Root123File = Join-Path $PorchRoot $FileName
$ExpectedChatHash = "9BC2FA5CA87012E0D80A26DD506CAF384B7DDE7FC3BFC9CE12AA1730DDEBBE72"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

function Invoke-GitChecked {
    param([Parameter(Mandatory=$true)][string[]]$Args)
    $out = & git @Args 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Args -join ' ') failed:`n$out"
    }
    return $out
}

function Get-Sha256Upper {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing file: $Path"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Ensure-Dir {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Copy-WithBackupIfNeeded {
    param(
        [Parameter(Mandatory=$true)][string]$Source,
        [Parameter(Mandatory=$true)][string]$Destination,
        [Parameter(Mandatory=$true)][string]$BackupDir,
        [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Report
    )
    Ensure-Dir (Split-Path -Parent $Destination)
    Ensure-Dir $BackupDir

    $sourceHash = Get-Sha256Upper $Source
    if (Test-Path -LiteralPath $Destination -PathType Leaf) {
        $destHash = Get-Sha256Upper $Destination
        if ($destHash -eq $sourceHash) {
            $Report.Add("UNCHANGED DESTINATION: $Destination")
            $Report.Add("UNCHANGED HASH: $destHash")
            return
        }
        $backupName = ((Split-Path -Leaf $Destination) + ".before_$Stamp.bak")
        $backupPath = Join-Path $BackupDir $backupName
        Copy-Item -LiteralPath $Destination -Destination $backupPath -Force
        $backupHash = Get-Sha256Upper $backupPath
        $Report.Add("BACKUP CREATED: $backupPath")
        $Report.Add("BACKUP HASH: $backupHash")
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    $newHash = Get-Sha256Upper $Destination
    $Report.Add("COPIED SOURCE: $Source")
    $Report.Add("TO DESTINATION: $Destination")
    $Report.Add("DESTINATION HASH: $newHash")
}

function Get-CandidateFiles {
    $roots = @(
        (Join-Path $env:USERPROFILE "Downloads"),
        (Join-Path $env:USERPROFILE "Desktop"),
        (Join-Path $env:USERPROFILE "Desktop\123")
    ) | Where-Object { Test-Path -LiteralPath $_ -PathType Container }

    $items = New-Object System.Collections.Generic.List[object]
    foreach ($root in $roots) {
        Get-ChildItem -LiteralPath $root -Filter "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523*.md" -File -ErrorAction SilentlyContinue | ForEach-Object {
            $items.Add($_)
        }
    }

    return $items | Sort-Object LastWriteTime -Descending -Unique
}

if (-not (Test-Path -LiteralPath $Repo -PathType Container)) {
    throw "Repo folder not found: $Repo"
}
Set-Location -LiteralPath $Repo
if (-not (Test-Path -LiteralPath (Join-Path $Repo ".git") -PathType Container)) {
    throw "Not a Git repo: $Repo"
}

$branch = (Invoke-GitChecked @("branch", "--show-current") | Select-Object -First 1).Trim()
if ($branch -ne "main") {
    throw "Wrong branch. Expected main, found $branch"
}

$startingStatus = (Invoke-GitChecked @("status", "--short")) -join "`n"
if ($startingStatus.Trim().Length -gt 0) {
    Write-Host "REPO IS DIRTY BEFORE SAVE. STOPPING." -ForegroundColor Yellow
    Write-Host $startingStatus
    throw "Clean the repo or checkpoint the existing work before saving this list. No files changed by this script."
}

if (-not (Test-Path -LiteralPath $Root123File -PathType Leaf)) {
    throw "Desktop\123 root file not found: $Root123File"
}

$rootHash = Get-Sha256Upper $Root123File
$candidates = @(Get-CandidateFiles)
$chatCandidates = @()
foreach ($candidate in $candidates) {
    $candidateFull = $candidate.FullName
    if ([System.IO.Path]::GetFullPath($candidateFull) -eq [System.IO.Path]::GetFullPath($Root123File)) {
        continue
    }
    $candidateHash = Get-Sha256Upper $candidateFull
    if ($candidateHash -eq $ExpectedChatHash) {
        $chatCandidates += [PSCustomObject]@{
            FullName = $candidateFull
            Hash = $candidateHash
            LastWriteTime = $candidate.LastWriteTime
        }
    }
}

$chatFile = $null
if ($rootHash -eq $ExpectedChatHash) {
    $chatFile = $Root123File
} elseif ($chatCandidates.Count -gt 0) {
    $chatFile = ($chatCandidates | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
} else {
    Write-Host "Could not find the downloaded chat copy with expected hash." -ForegroundColor Yellow
    Write-Host "Expected SHA256: $ExpectedChatHash"
    Write-Host "Root Desktop\123 SHA256: $rootHash"
    Write-Host "Download the chat file first, or put it in Downloads/Desktop with a non-overwriting duplicate name like:"
    Write-Host "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523_CHAT_COPY.md"
    throw "Missing verified chat copy. No files changed by this script."
}

$chatHash = Get-Sha256Upper $chatFile
$sourceSame = ($rootHash -eq $chatHash)

$BrainDir = Join-Path $Repo "BRAIN_LEARNING"
$SourceOreDir = Join-Path $Repo "SOURCE_ORE"
$SortingDir = Join-Path $Repo "HOUSE_WORK\WORK_SHED\SORTING_BENCH"
$BackupDir = Join-Path $SortingDir "_BACKUPS"
$ProofDir = Join-Path $Repo "PROOF_HISTORY"
$StatusFile = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
Ensure-Dir $BrainDir
Ensure-Dir $SourceOreDir
Ensure-Dir $SortingDir
Ensure-Dir $ProofDir
Ensure-Dir (Split-Path -Parent $StatusFile)

$CanonicalDest = Join-Path $BrainDir "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md"
$RootVariantDest = Join-Path $SourceOreDir "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523_ROOT_123_VARIANT.md"
$CompareNote = Join-Path $SortingDir "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_COMPARE_AND_GIT_SAVE_20260523.md"
$ReceiptPath = Join-Path $ProofDir "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_GIT_SAVE_RECEIPT_20260523_$Stamp.txt"

$report = New-Object System.Collections.Generic.List[string]
$report.Add("BROAD COMMAND RECURSIVE TRIGGER LIST GIT SAVE")
$report.Add("Timestamp: $Stamp")
$report.Add("Repo: $Repo")
$report.Add("Branch: $branch")
$report.Add("Old HEAD: $((Invoke-GitChecked @('rev-parse','HEAD') | Select-Object -First 1).Trim())")
$report.Add("Root 123 file: $Root123File")
$report.Add("Root 123 SHA256: $rootHash")
$report.Add("Verified chat file: $chatFile")
$report.Add("Verified chat SHA256: $chatHash")
$report.Add("Expected chat SHA256: $ExpectedChatHash")
$report.Add("Same content: $sourceSame")
$report.Add("Boundary: Git save only. No doctrine promotion. No ACTIVE_GUIDE rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation.")
$report.Add("")

Copy-WithBackupIfNeeded -Source $chatFile -Destination $CanonicalDest -BackupDir $BackupDir -Report $report
if (-not $sourceSame) {
    Copy-WithBackupIfNeeded -Source $Root123File -Destination $RootVariantDest -BackupDir $BackupDir -Report $report
}

$compareLines = New-Object System.Collections.Generic.List[string]
$compareLines.Add("# Broad Command Recursive Trigger List — Compare and Git Save — 20260523")
$compareLines.Add("")
$compareLines.Add("Status: Git save comparison note")
$compareLines.Add("Boundary: source custody / behavior-rule save support only; not doctrine promotion by itself.")
$compareLines.Add("")
$compareLines.Add("## Source Files")
$compareLines.Add("")
$compareLines.Add("- Desktop\\123 root file: `$Root123File`")
$compareLines.Add("- Desktop\\123 root SHA256: `$rootHash`")
$compareLines.Add("- Verified chat/download file: `$chatFile`")
$compareLines.Add("- Verified chat/download SHA256: `$chatHash`")
$compareLines.Add("- Expected chat/download SHA256: `$ExpectedChatHash`")
$compareLines.Add("")
$compareLines.Add("## Comparison Verdict")
$compareLines.Add("")
if ($sourceSame) {
    $compareLines.Add("Verdict: SAME CONTENT. Saved one canonical Git copy at `BRAIN_LEARNING/BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md`.")
} else {
    $compareLines.Add("Verdict: DIFFERENT CONTENT. Saved the verified chat corrected copy as canonical behavior-rule material and preserved the Desktop\\123 root copy as a source-ore variant.")
}
$compareLines.Add("")
$compareLines.Add("## Corrected Principle")
$compareLines.Add("")
$compareLines.Add("Use the smallest complete recursive branch that can carry the job. If that branch finds deeper pressure, escalate cleanly. If the idea fits, wear it. If it is dirty but useful, rename it and wear the clean function.")
$compareLines.Add("")
$compareLines.Add("## Blocked")
$compareLines.Add("")
$compareLines.Add("- Do not frame depth as waste.")
$compareLines.Add("- Do not overwrite one same-named source without hash comparison.")
$compareLines.Add("- Do not promote the list into doctrine without a separate promotion route and proof.")
$compareLines.Add("- Do not treat a filename match as content proof.")
Set-Content -LiteralPath $CompareNote -Value $compareLines -Encoding UTF8
$report.Add("COMPARE NOTE: $CompareNote")
$report.Add("COMPARE NOTE HASH: $(Get-Sha256Upper $CompareNote)")

$statusLine = "- 2026-05-23: Broad Command Recursive Trigger List Git save staged. Same-content verdict: $sourceSame. Canonical: BRAIN_LEARNING/BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md. Receipt: PROOF_HISTORY/$(Split-Path -Leaf $ReceiptPath)."
Add-Content -LiteralPath $StatusFile -Value $statusLine -Encoding UTF8
$report.Add("STATUS UPDATED: $StatusFile")
$report.Add("STATUS HASH: $(Get-Sha256Upper $StatusFile)")

$report.Add("")
$report.Add("Saved paths:")
$report.Add("- $CanonicalDest")
if (-not $sourceSame) { $report.Add("- $RootVariantDest") }
$report.Add("- $CompareNote")
$report.Add("- $StatusFile")
$report.Add("- $ReceiptPath")

Set-Content -LiteralPath $ReceiptPath -Value $report -Encoding UTF8

$pathsToAdd = @(
    $CanonicalDest,
    $CompareNote,
    $StatusFile
)
if (-not $sourceSame) { $pathsToAdd += $RootVariantDest }
foreach ($p in $pathsToAdd) {
    Invoke-GitChecked @("add", "--", $p) | Out-Null
}
Invoke-GitChecked @("add", "-f", "--", $ReceiptPath) | Out-Null

$staged = (Invoke-GitChecked @("diff", "--cached", "--name-status")) -join "`n"
if ($staged.Trim().Length -eq 0) {
    throw "Nothing staged. No commit made."
}

$commitMessage = "Save broad command recursive trigger list"
Invoke-GitChecked @("commit", "-m", $commitMessage) | Out-Null
Invoke-GitChecked @("push", "origin", "main") | Out-Null

$head = (Invoke-GitChecked @("rev-parse", "HEAD") | Select-Object -First 1).Trim()
$origin = (Invoke-GitChecked @("rev-parse", "origin/main") | Select-Object -First 1).Trim()
$finalStatus = (Invoke-GitChecked @("status", "--short")) -join "`n"

Write-Host "BROAD COMMAND RECURSIVE TRIGGER LIST SAVE COMPLETE" -ForegroundColor Green
Write-Host "Mode same-content: $sourceSame"
Write-Host "Root hash: $rootHash"
Write-Host "Chat hash: $chatHash"
Write-Host "HEAD: $head"
Write-Host "Origin main: $origin"
if ($head -eq $origin) {
    Write-Host "Remote match: YES" -ForegroundColor Green
} else {
    Write-Host "Remote match: NO" -ForegroundColor Yellow
}
if ($finalStatus.Trim().Length -eq 0) {
    Write-Host "Final status: clean" -ForegroundColor Green
} else {
    Write-Host "Final status not clean:" -ForegroundColor Yellow
    Write-Host $finalStatus
}
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $(Get-Sha256Upper $ReceiptPath)"
