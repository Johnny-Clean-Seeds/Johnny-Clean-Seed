$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-Sha256Upper {
    param([Parameter(Mandatory=$true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Ensure-Directory {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Write-Utf8File {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string[]]$Lines
    )
    $parent = Split-Path -Parent $Path
    if ($parent) { Ensure-Directory -Path $parent }
    Set-Content -LiteralPath $Path -Value $Lines -Encoding utf8
}

function Is-GitRepo {
    param([Parameter(Mandatory=$true)][string]$Path)
    return (Test-Path -LiteralPath (Join-Path $Path ".git"))
}

function Resolve-RepoPath {
    $desktop = Join-Path $env:USERPROFILE "Desktop"
    $desktop123 = Join-Path $desktop "123"

    $priority = New-Object System.Collections.Generic.List[string]
    $priority.Add((Join-Path $desktop123 "Jxhnny_Kl33N_Seedz")) | Out-Null
    $priority.Add((Join-Path $desktop123 "Jxhnny_Kleen_C3dz")) | Out-Null
    $priority.Add((Join-Path $desktop "Jxhnny_Kl33N_Seedz")) | Out-Null
    $priority.Add((Join-Path $desktop "Jxhnny_Kleen_C3dz")) | Out-Null
    $priority.Add((Get-Location).Path) | Out-Null

    foreach ($p in ($priority | Select-Object -Unique)) {
        if ((Test-Path -LiteralPath $p) -and (Is-GitRepo -Path $p)) {
            return (Resolve-Path -LiteralPath $p).Path
        }
    }

    $searchRoots = @($desktop123, $desktop) | Where-Object { Test-Path -LiteralPath $_ }
    $matches = New-Object System.Collections.Generic.List[string]
    foreach ($root in $searchRoots) {
        $dirs = @(Get-ChildItem -LiteralPath $root -Directory -Recurse -Depth 2 -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'Jxhnny|Kleen|Kl33N|C3dz|Seedz|Seed' })
        foreach ($d in $dirs) {
            if (Is-GitRepo -Path $d.FullName) {
                $matches.Add((Resolve-Path -LiteralPath $d.FullName).Path) | Out-Null
            }
        }
    }

    $unique = @($matches | Select-Object -Unique)
    if ($unique.Count -eq 1) { return $unique[0] }
    if ($unique.Count -gt 1) {
        Write-Host "BLOCKED: more than one possible repo was found. Pick the right one and rerun from inside it."
        $unique | ForEach-Object { Write-Host ("- {0}" -f $_) }
        exit 5
    }

    throw "Repo not found. Expected a Git repo under Desktop or Desktop\123, such as Desktop\123\Jxhnny_Kl33N_Seedz."
}

$Repo = Resolve-RepoPath
$Desktop123 = Join-Path $env:USERPROFILE "Desktop\123"
$FileName = "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md"
$ExpectedChatHash = "9BC2FA5CA87012E0D80A26DD506CAF384B7DDE7FC3BFC9CE12AA1730DDEBBE72"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$DateOnly = Get-Date -Format "yyyyMMdd"

$RootPath = Join-Path $Desktop123 $FileName
$BrainDir = Join-Path $Repo "BRAIN_LEARNING"
$SourceOreDir = Join-Path $Repo "SOURCE_ORE"
$SortDir = Join-Path $Repo "HOUSE_WORK\WORK_SHED\SORTING_BENCH"
$ReceiptDir = Join-Path $Repo "PROOF_HISTORY"
$StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$CanonicalPath = Join-Path $BrainDir $FileName
$VariantPath = Join-Path $SourceOreDir "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523_ROOT_123_VARIANT.md"
$CompareNotePath = Join-Path $SortDir ("BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_COMPARE_AND_SAVE_NOTE_{0}.md" -f $DateOnly)
$ReceiptPath = Join-Path $ReceiptDir ("BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_GIT_SAVE_RECEIPT_{0}.txt" -f $Stamp)

Write-Host ("Resolved repo: {0}" -f $Repo)
Set-Location -LiteralPath $Repo

$branch = (git branch --show-current).Trim()
if ($LASTEXITCODE -ne 0) { throw "git branch check failed." }
if ($branch -ne "main") {
    throw ("Wrong branch: {0}. Expected main." -f $branch)
}

$startStatus = @(git status --porcelain)
if ($LASTEXITCODE -ne 0) { throw "git status failed before save." }
if ($startStatus.Count -gt 0) {
    Write-Host "BLOCKED: repo is not clean before this save. I will not mix unrelated changes into this commit."
    Write-Host "Current git status --porcelain:"
    $startStatus | ForEach-Object { Write-Host $_ }
    exit 2
}

$rootExists = Test-Path -LiteralPath $RootPath
$rootHash = "MISSING"
if ($rootExists) {
    $rootHash = Get-Sha256Upper -Path $RootPath
}

$searchRoots = @(
    (Join-Path $env:USERPROFILE "Downloads"),
    (Join-Path $env:USERPROFILE "Desktop"),
    $Desktop123
) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -Unique

$candidates = New-Object System.Collections.Generic.List[object]
foreach ($root in $searchRoots) {
    $items = @(Get-ChildItem -LiteralPath $root -File -Filter "BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523*.md" -ErrorAction SilentlyContinue)
    foreach ($item in $items) {
        $hash = Get-Sha256Upper -Path $item.FullName
        $candidates.Add([pscustomobject]@{
            FullName = $item.FullName
            Name = $item.Name
            Hash = $hash
            LastWriteTime = $item.LastWriteTime
            IsRoot123Exact = ($item.FullName -ieq $RootPath)
            IsExpectedChatHash = ($hash -ieq $ExpectedChatHash)
        }) | Out-Null
    }
}

$expectedMatches = @($candidates | Where-Object { $_.IsExpectedChatHash } | Sort-Object @{Expression='IsRoot123Exact';Descending=$true}, LastWriteTime -Descending)
if ($expectedMatches.Count -lt 1) {
    Write-Host "BLOCKED: no local markdown copy matched the expected uploaded-chat SHA256."
    Write-Host ("Expected uploaded-chat SHA256: {0}" -f $ExpectedChatHash)
    Write-Host ("Desktop 123 root exists: {0}" -f $rootExists)
    Write-Host ("Desktop 123 root SHA256: {0}" -f $rootHash)
    Write-Host "Meaning: the root file is probably a different variant, or the uploaded chat copy has not been downloaded to this PC."
    Write-Host "Fix: download BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md from chat, then rerun this V1.2 script."
    exit 3
}

$source = $expectedMatches[0]
$sourcePath = $source.FullName
$sourceHash = $source.Hash

Ensure-Directory -Path $BrainDir
Ensure-Directory -Path $SourceOreDir
Ensure-Directory -Path $SortDir
Ensure-Directory -Path $ReceiptDir
Ensure-Directory -Path (Split-Path -Parent $StatusPath)

Copy-Item -LiteralPath $sourcePath -Destination $CanonicalPath -Force
$canonicalHash = Get-Sha256Upper -Path $CanonicalPath
if ($canonicalHash -ine $ExpectedChatHash) {
    throw ("Canonical copy hash mismatch. Expected {0}; got {1}" -f $ExpectedChatHash, $canonicalHash)
}

$variantSaved = $false
$variantHash = "NONE"
if ($rootExists -and ($rootHash -ine $ExpectedChatHash)) {
    Copy-Item -LiteralPath $RootPath -Destination $VariantPath -Force
    $variantHash = Get-Sha256Upper -Path $VariantPath
    $variantSaved = $true
}

$dedupeVerdict = "UNKNOWN"
if ($rootExists -and ($rootHash -ieq $ExpectedChatHash)) {
    $dedupeVerdict = "SAME_HASH_DEDUPED_ONE_CANONICAL_FILE"
} elseif ($rootExists -and ($rootHash -ine $ExpectedChatHash)) {
    $dedupeVerdict = "DIFFERENT_HASH_CANONICAL_PLUS_ROOT_VARIANT_SAVED"
} else {
    $dedupeVerdict = "ROOT_123_COPY_MISSING_CANONICAL_CHAT_COPY_SAVED"
}

$compareLines = @(
    "# Broad Command Recursive Trigger List - Compare and Git Save Note",
    "",
    ("Date: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")),
    "Status: GIT SAVE NOTE",
    "Boundary: save and custody only; no doctrine promotion; no ACTIVE_GUIDE rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation.",
    "",
    "## Inputs",
    ("- Expected uploaded-chat SHA256: {0}" -f $ExpectedChatHash),
    ("- Verified source path: {0}" -f $sourcePath),
    ("- Verified source SHA256: {0}" -f $sourceHash),
    ("- Desktop 123 root path: {0}" -f $RootPath),
    ("- Desktop 123 root exists: {0}" -f $rootExists),
    ("- Desktop 123 root SHA256: {0}" -f $rootHash),
    "",
    "## Placement",
    ("- Canonical Git file: {0}" -f $CanonicalPath),
    ("- Canonical Git SHA256: {0}" -f $canonicalHash),
    ("- Root variant saved: {0}" -f $variantSaved),
    ("- Root variant path: {0}" -f $(if ($variantSaved) { $VariantPath } else { "NONE" })),
    ("- Root variant SHA256: {0}" -f $variantHash),
    "",
    "## Verdict",
    $dedupeVerdict,
    "",
    "Corrected principle preserved:",
    "Use the smallest complete recursive branch that can carry the job. If that branch finds deeper pressure, escalate cleanly. If the idea fits, wear it. If it is dirty but useful, rename it and wear the clean function."
)
Write-Utf8File -Path $CompareNotePath -Lines $compareLines

if (-not (Test-Path -LiteralPath $StatusPath)) {
    Write-Utf8File -Path $StatusPath -Lines @("# Current House Work Status", "")
}
$statusLines = @(
    "",
    ("## {0} - Broad Command Recursive Trigger List Git Save" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")),
    ("- Repo: {0}" -f $Repo),
    ("- Saved canonical file: BRAIN_LEARNING/{0}" -f $FileName),
    ("- Expected uploaded-chat SHA256: {0}" -f $ExpectedChatHash),
    ("- Canonical SHA256: {0}" -f $canonicalHash),
    ("- Desktop 123 root SHA256: {0}" -f $rootHash),
    ("- Dedupe verdict: {0}" -f $dedupeVerdict),
    "- Boundary: no doctrine promotion, no ACTIVE_GUIDE rewrite, no CURRENT_TRUTH_INDEX rewrite, no automation."
)
Add-Content -LiteralPath $StatusPath -Value $statusLines -Encoding utf8

$receiptLines = @(
    "BROAD COMMAND RECURSIVE TRIGGER LIST GIT SAVE RECEIPT",
    ("Timestamp: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")),
    ("Repo: {0}" -f $Repo),
    ("Branch: {0}" -f $branch),
    ("Expected uploaded-chat SHA256: {0}" -f $ExpectedChatHash),
    ("Verified source path: {0}" -f $sourcePath),
    ("Verified source SHA256: {0}" -f $sourceHash),
    ("Desktop 123 root path: {0}" -f $RootPath),
    ("Desktop 123 root exists: {0}" -f $rootExists),
    ("Desktop 123 root SHA256: {0}" -f $rootHash),
    ("Canonical path: {0}" -f $CanonicalPath),
    ("Canonical SHA256: {0}" -f $canonicalHash),
    ("Variant saved: {0}" -f $variantSaved),
    ("Variant path: {0}" -f $(if ($variantSaved) { $VariantPath } else { "NONE" })),
    ("Variant SHA256: {0}" -f $variantHash),
    ("Compare note: {0}" -f $CompareNotePath),
    ("Dedupe verdict: {0}" -f $dedupeVerdict),
    "Boundary: Git save only; no doctrine promotion; no ACTIVE_GUIDE rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation.",
    "Pre-commit validation: source hash matched expected uploaded-chat SHA256 and canonical copy rehashed clean."
)
Write-Utf8File -Path $ReceiptPath -Lines $receiptLines

$relCanonical = "BRAIN_LEARNING/$FileName"
$relCompare = ("HOUSE_WORK/WORK_SHED/SORTING_BENCH/{0}" -f (Split-Path -Leaf $CompareNotePath))
$relReceipt = ("PROOF_HISTORY/{0}" -f (Split-Path -Leaf $ReceiptPath))
$relStatus = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"
$relVariant = "SOURCE_ORE/BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523_ROOT_123_VARIANT.md"

$addPaths = @($relCanonical, $relCompare, $relReceipt, $relStatus)
if ($variantSaved) { $addPaths += $relVariant }

git add -f -- $addPaths
if ($LASTEXITCODE -ne 0) { throw "git add failed." }

$pending = @(git status --porcelain)
if ($pending.Count -lt 1) {
    throw "No git changes detected after save. Refusing empty commit."
}

Write-Host "PENDING CHANGES TO COMMIT"
$pending | ForEach-Object { Write-Host $_ }

git commit -m "Add broad command recursive trigger list"
if ($LASTEXITCODE -ne 0) { throw "git commit failed." }

git push origin main
if ($LASTEXITCODE -ne 0) { throw "git push failed." }

$localHead = (git rev-parse HEAD).Trim()
$remoteHead = (git rev-parse origin/main).Trim()
$finalStatus = @(git status --porcelain)

$postPushLines = @(
    "",
    "POST-PUSH VALIDATION 1",
    ("Local HEAD: {0}" -f $localHead),
    ("Origin/main: {0}" -f $remoteHead),
    ("HEAD equals origin/main: {0}" -f ($localHead -eq $remoteHead)),
    ("Git status clean before receipt proof update: {0}" -f ($finalStatus.Count -eq 0))
)
Add-Content -LiteralPath $ReceiptPath -Value $postPushLines -Encoding utf8

git add -f -- $relReceipt
git commit -m "Update broad command save receipt proof"
if ($LASTEXITCODE -ne 0) { throw "final receipt commit failed." }

git push origin main
if ($LASTEXITCODE -ne 0) { throw "final receipt push failed." }

$localHead2 = (git rev-parse HEAD).Trim()
$remoteHead2 = (git rev-parse origin/main).Trim()
$finalStatus2 = @(git status --porcelain)

Write-Host ""
Write-Host "RESULT: PASS / BROAD COMMAND TRIGGER LIST SAVED TO GIT"
Write-Host ("Repo: {0}" -f $Repo)
Write-Host ("Canonical: {0}" -f $CanonicalPath)
Write-Host ("Canonical SHA256: {0}" -f $canonicalHash)
Write-Host ("Desktop 123 root SHA256: {0}" -f $rootHash)
Write-Host ("Dedupe verdict: {0}" -f $dedupeVerdict)
Write-Host ("Variant saved: {0}" -f $variantSaved)
Write-Host ("Receipt: {0}" -f $ReceiptPath)
Write-Host ("Local HEAD: {0}" -f $localHead2)
Write-Host ("Origin/main: {0}" -f $remoteHead2)
Write-Host ("HEAD equals origin/main: {0}" -f ($localHead2 -eq $remoteHead2))
Write-Host ("Final git status clean: {0}" -f ($finalStatus2.Count -eq 0))
if ($finalStatus2.Count -gt 0) {
    Write-Host "FINAL STATUS DETAILS"
    $finalStatus2 | ForEach-Object { Write-Host $_ }
}
