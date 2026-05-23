# LOCK_SAVE_FRUSTRATION_RETRACE_AND_TRANSCRIPT_INVENTORY_20260523.ps1
# Purpose:
# 1. Verify the current Clean Seed / Mr.Kleen home after the clean switch.
# 2. Lock/save the Frustration Bell Retrace Rule.
# 3. Find transcript/source-text files after the folder move.
# 4. Write a receipt and transcript inventory.
# 5. If home cannot be found/verified, write a mule roof-repair work order instead of rebuilding blindly.
#
# Boundary:
# - Preferred porch/root: C:\Users\13527\Desktop\123
# - Preferred active home: C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz
# - No Steiner application.
# - No doctrine promotion.
# - No ACTIVE_GUIDES rewrite.
# - No CURRENT_TRUTH_INDEX rewrite.
# - No file moves/deletes.
# - No secret/token/password material is copied into Git.
# - If home is invalid, write work order only.

$ErrorActionPreference = "Stop"

function Write-Utf8File {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Text
    )
    $Dir = Split-Path -Parent $Path
    if ($Dir -and -not (Test-Path -LiteralPath $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
}

function Append-Utf8File {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Text
    )
    $Dir = Split-Path -Parent $Path
    if ($Dir -and -not (Test-Path -LiteralPath $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
    Add-Content -LiteralPath $Path -Value $Text -Encoding UTF8
}

function Get-Sha256OrBlank {
    param([Parameter(Mandatory=$true)][string]$Path)
    try {
        if (Test-Path -LiteralPath $Path -PathType Leaf) {
            return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        }
    } catch {
        return ""
    }
    return ""
}

function New-RoofWorkOrder {
    param(
        [Parameter(Mandatory=$true)][string]$Reason,
        [Parameter(Mandatory=$true)][string]$PorchPath,
        [Parameter(Mandatory=$true)][string]$ExpectedHome
    )

    $Ts = Get-Date -Format "yyyyMMdd_HHmmss"
    $Base = if (Test-Path -LiteralPath $PorchPath) { $PorchPath } else { [Environment]::GetFolderPath("Desktop") }
    $OrderDir = Join-Path $Base "_ROOF_WORK_ORDERS"
    New-Item -ItemType Directory -Path $OrderDir -Force | Out-Null

    $OrderPath = Join-Path $OrderDir "MULE_ROOF_REPAIR_HOME_VERIFY_OR_BUILD_ORDER_$Ts.md"
    $ReceiptPath = Join-Path $OrderDir "MULE_ROOF_REPAIR_HOME_VERIFY_OR_BUILD_ORDER_RECEIPT_$Ts.txt"

    $Order = @"
# Mule Roof Repair Work Order — Home Verify or Build

Status: WORK ORDER ONLY  
Created: $Ts  
Reason: $Reason

## Expected routing

Porch/root/drop surface:

``````
$PorchPath
``````

Assistant active home/work zone:

``````
$ExpectedHome
``````

## Boundary

Do not move, delete, flatten, rename, or scatter project files.

Do not rewrite ACTIVE_GUIDES.

Do not rewrite CURRENT_TRUTH_INDEX.

Do not import Steiner/source files into doctrine.

Do not push secrets, tokens, passwords, keys, env files, certificates, or private local material to Git.

Do not rebuild over an existing home until inventory proves what is present, what is missing, and what is safe.

## Job

1. Verify whether the expected home exists.
2. If it exists, verify whether it is a Git worktree.
3. If it is not a Git worktree, report the actual top-level folders and likely home candidates.
4. If the expected home is missing, build a clean home only to the known home spec:
   - keep Desktop\123 as porch/root/drop surface;
   - create/use Desktop\123\Jxhnny_Kl33N_Seedz as active home;
   - preserve old material in archive/source custody;
   - keep audit/receipt folders visible;
   - do not create shed/bridge sprawl in the clean home;
   - do not move/copy secret material into tracked Git.
5. Produce a receipt with paths, hashes where applicable, Git state, and final verdict.

## Return required

- Home path verified or created.
- Git top-level.
- `git status --short`.
- Secret/token/password tracking check.
- Transcript/source file locations if found.
- Any blockers.
"@

    Write-Utf8File -Path $OrderPath -Text $Order

    $OrderHash = Get-Sha256OrBlank -Path $OrderPath
    $Receipt = @"
MULE ROOF REPAIR WORK ORDER RECEIPT

Created: $Ts
Reason: $Reason

Work order:
$OrderPath

Work order SHA256:
$OrderHash

Boundary:
Work order only. No rebuild performed by this runner.

Verdict:
BLOCKED / HOME NOT VERIFIED / MULE ROOF WORK ORDER WRITTEN
"@
    Write-Utf8File -Path $ReceiptPath -Text $Receipt

    Write-Host "HOME NOT VERIFIED"
    Write-Host "Roof work order written:"
    Write-Host $OrderPath
    Write-Host "Receipt:"
    Write-Host $ReceiptPath
    return
}

$Ts = Get-Date -Format "yyyyMMdd_HHmmss"
$Porch = Join-Path ([Environment]::GetFolderPath("Desktop")) "123"
$ExpectedHome = Join-Path $Porch "Jxhnny_Kl33N_Seedz"

Write-Host "CHECKING PORCH / HOME"
Write-Host "Porch: $Porch"
Write-Host "Expected home: $ExpectedHome"

if (-not (Test-Path -LiteralPath $Porch -PathType Container)) {
    New-RoofWorkOrder -Reason "Porch/root Desktop\123 not found." -PorchPath $Porch -ExpectedHome $ExpectedHome
    exit 2
}

if (-not (Test-Path -LiteralPath $ExpectedHome -PathType Container)) {
    New-RoofWorkOrder -Reason "Expected active home folder not found." -PorchPath $Porch -ExpectedHome $ExpectedHome
    exit 2
}

$RepoTop = ""
try {
    $RepoTop = (& git -C $ExpectedHome rev-parse --show-toplevel 2>$null).Trim()
} catch {
    $RepoTop = ""
}

if (-not $RepoTop) {
    New-RoofWorkOrder -Reason "Expected active home exists but is not verified as a Git worktree." -PorchPath $Porch -ExpectedHome $ExpectedHome
    exit 2
}

$RepoTopFull = (Resolve-Path -LiteralPath $RepoTop).Path
$ExpectedHomeFull = (Resolve-Path -LiteralPath $ExpectedHome).Path

if ($RepoTopFull -ne $ExpectedHomeFull) {
    # This is not automatically fatal, but it is suspicious after a clean switch.
    $TopNote = "WARNING: Git top-level differs from expected home. RepoTop=$RepoTopFull ExpectedHome=$ExpectedHomeFull"
} else {
    $TopNote = "Git top-level matches expected home."
}

Set-Location -LiteralPath $RepoTopFull

$Branch = (& git branch --show-current).Trim()
$Head = (& git rev-parse --short HEAD).Trim()
$HeadFull = (& git rev-parse HEAD).Trim()
$OriginHead = ""
try { $OriginHead = (& git rev-parse origin/main 2>$null).Trim() } catch { $OriginHead = "" }
$StatusBefore = (& git status --short) -join "`r`n"

$BrainDir = Join-Path $RepoTopFull "BRAIN_LEARNING"
$SortingDir = Join-Path $RepoTopFull "HOUSE_WORK\WORK_SHED\SORTING_BENCH"
$ProofDir = Join-Path $RepoTopFull "PROOF_HISTORY"
$IndexDir = Join-Path $RepoTopFull "HOUSE_WORK\INDEXES"

New-Item -ItemType Directory -Path $BrainDir,$SortingDir,$ProofDir,$IndexDir -Force | Out-Null

$RulePath = Join-Path $BrainDir "FRUSTRATION_BELL_RETRACE_RULE_20260523.md"
$CapturePath = Join-Path $SortingDir "FRUSTRATION_BELL_RETRACE_CHAT_BEHAVIOR_CAPTURE_20260523.md"
$TranscriptInventoryPath = Join-Path $SortingDir "TRANSCRIPT_INVENTORY_AFTER_CLEAN_SWITCH_20260523.md"
$ReceiptPath = Join-Path $ProofDir "FRUSTRATION_BELL_RETRACE_AND_TRANSCRIPT_INVENTORY_SAVE_RECEIPT_20260523.txt"
$StatusPath = Join-Path $IndexDir "CURRENT_HOUSE_WORK_STATUS.md"

$RuleText = @"
# Frustration Bell Retrace Rule

Status: SUPPORT RULE / CHAT BEHAVIOR REPAIR  
Date: 2026-05-23  
Scope: Clean Seed / Mr.Kleen chat behavior, route repair, confusion handling

## Rule

When the user gets angry, sharp, frustrated, loud, jokingly threatening, or messy in wording, do not treat the heat itself as the core problem and do not stop work by default.

Treat the heat as a routing bell.

First assumption:

**I may have gotten off-route.**

The assistant must gently pause and retrace its own path:

1. What did the user actually ask for?
2. What did I turn it into?
3. Did I add an unnecessary route, tool, folder hunt, clipboard step, image road, or file operation?
4. Did I miss a simpler visible move?
5. Did I ignore the active root, home, porch, source, or boundary?
6. Did I use language like "I see" or "aha" before proving I actually saw?
7. What earlier context most likely resolves the confusion?

## Do not label the user as the problem

Avoid framing the repair as:

- "the user seems upset";
- "the user is angry";
- "the user is emotional";
- "the user is confused."

Better repair frame:

**I may have messed up the route. Hold on. Let me retrace the steps.**

## "I see" standard

Do not say "I see" or "aha" just because a clean-looking explanation appeared.

"I see" is earned only after the assistant has:

1. compared the plausible causes;
2. checked the current instruction;
3. checked relevant recent context;
4. checked path/file/source facts when relevant;
5. identified the likely mismatch with evidence.

## Continue-work standard

Do not freeze just because the user is mad.

If one route is clearly more probable and safe, continue with that route.

Ask or stop only when:

1. two or more routes are genuinely close in probability;
2. the next action risks moving, deleting, overwriting, committing, promoting, or exposing private material;
3. local proof is missing for a claim that would affect authority or state;
4. the user explicitly says stop, pause, or do not continue.

## Short form

**When user heat rises, do not label the user. Retrace the assistant route. Find the root mismatch. Continue if the best path is clear; pause only when uncertainty or risk is real.**
"@

$CaptureText = @"
# Frustration Bell Retrace — Chat Behavior Capture

Status: SORTING BENCH CAPTURE  
Date: 2026-05-23  
Source event: user correction after desktop icon / transcript / folder-route frustration

## Source insight

The user clarified that their anger/frustration is often not a stop condition. It is frequently a signal that the assistant has gone off-route, overcomplicated a simple task, or failed to trace the root instruction.

The user emphasized:

- do not make anger the main story;
- pin the repair on assistant route error first;
- gently pause without freezing;
- retrace steps;
- only say "I see" when the evidence truly supports it;
- continue work when one route is clearly more probable;
- ask only when the odds are genuinely close or risk is real;
- go farther back in context when that resolves the confusion.

## Placement

This belongs in chat behavior / cockpit repair / confusion handling.

It does not replace the cockpit router.

It supports the cockpit by adding a heat/frustration handling move before the assistant spirals into the wrong rule family.

## Boundary

No doctrine promotion.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No personality claim about the user.

This is a behavior repair rule for assistant routing.

## Candidate return trigger

Return to this rule whenever:

- the user says "what are you doing";
- the user says "stop";
- the user says the assistant is being weird;
- the assistant starts overexplaining instead of doing the direct task;
- a simple local file task becomes a maze;
- the assistant labels user emotion instead of tracing its own route.
"@

Write-Utf8File -Path $RulePath -Text $RuleText
Write-Utf8File -Path $CapturePath -Text $CaptureText

# Transcript/source inventory after the clean switch.
$SearchRootsRaw = @(
    $Porch,
    $ExpectedHome,
    (Join-Path ([Environment]::GetFolderPath("Desktop")) ""),
    (Join-Path $env:USERPROFILE "Downloads"),
    (Join-Path $env:USERPROFILE "Documents")
)

$SearchRoots = $SearchRootsRaw |
    Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Container) } |
    ForEach-Object { (Resolve-Path -LiteralPath $_).Path } |
    Select-Object -Unique

$Patterns = @(
    "*TRANSCRIPT*",
    "*transcript*",
    "*.vtt",
    "*CAPTION*",
    "*caption*",
    "*YOUTUBE*",
    "*youtube*",
    "RUDOLF_STEINER*",
    "*STEINER*",
    "*Steiner*"
)

$Found = New-Object System.Collections.Generic.List[object]

foreach ($Root in $SearchRoots) {
    foreach ($Pattern in $Patterns) {
        try {
            Get-ChildItem -LiteralPath $Root -Recurse -File -Filter $Pattern -ErrorAction SilentlyContinue |
                ForEach-Object {
                    $Found.Add($_)
                }
        } catch {
            # Continue inventory; one inaccessible folder should not kill the save.
        }
    }
}

$Dedup = $Found |
    Sort-Object FullName -Unique |
    Sort-Object LastWriteTime -Descending

$InventoryRows = New-Object System.Collections.Generic.List[string]
$InventoryRows.Add("# Transcript / Source Inventory After Clean Switch")
$InventoryRows.Add("")
$InventoryRows.Add("Status: INVENTORY ONLY")
$InventoryRows.Add("Date: 2026-05-23")
$InventoryRows.Add("")
$InventoryRows.Add("Porch/root/drop surface:")
$InventoryRows.Add("")
$InventoryRows.Add("``````")
$InventoryRows.Add($Porch)
$InventoryRows.Add("``````")
$InventoryRows.Add("")
$InventoryRows.Add("Active home/work zone:")
$InventoryRows.Add("")
$InventoryRows.Add("``````")
$InventoryRows.Add($ExpectedHome)
$InventoryRows.Add("``````")
$InventoryRows.Add("")
$InventoryRows.Add("Boundary: this inventory records locations only. It does not move, delete, import, or promote transcripts/source files.")
$InventoryRows.Add("")
$InventoryRows.Add("Search roots:")
$InventoryRows.Add("")
foreach ($Root in $SearchRoots) {
    $InventoryRows.Add("- ``$Root``")
}
$InventoryRows.Add("")
$InventoryRows.Add("Found count: $($Dedup.Count)")
$InventoryRows.Add("")
$InventoryRows.Add("| LastWriteTime | Size | SHA256 | Path |")
$InventoryRows.Add("|---|---:|---|---|")

foreach ($Item in $Dedup) {
    $Hash = Get-Sha256OrBlank -Path $Item.FullName
    $Size = $Item.Length
    $Last = $Item.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    $PathEscaped = $Item.FullName.Replace("|","\|")
    $InventoryRows.Add("| $Last | $Size | $Hash | ``$PathEscaped`` |")
}

if ($Dedup.Count -eq 0) {
    $InventoryRows.Add("")
    $InventoryRows.Add("No transcript/caption/Steiner source files found in the searched roots.")
}

Write-Utf8File -Path $TranscriptInventoryPath -Text ($InventoryRows -join "`r`n")

# Append status if file exists, otherwise create a minimal status note.
$StatusEntry = @"

## 2026-05-23 — Frustration Bell Retrace + Transcript Inventory Save

Position before save: $Branch @ $Head

Saved:
- BRAIN_LEARNING/FRUSTRATION_BELL_RETRACE_RULE_20260523.md
- HOUSE_WORK/WORK_SHED/SORTING_BENCH/FRUSTRATION_BELL_RETRACE_CHAT_BEHAVIOR_CAPTURE_20260523.md
- HOUSE_WORK/WORK_SHED/SORTING_BENCH/TRANSCRIPT_INVENTORY_AFTER_CLEAN_SWITCH_20260523.md
- PROOF_HISTORY/FRUSTRATION_BELL_RETRACE_AND_TRANSCRIPT_INVENTORY_SAVE_RECEIPT_20260523.txt

Boundary:
- no Steiner application;
- no doctrine promotion;
- no ACTIVE_GUIDES rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no transcript move/import;
- no secret/token/password material copied into Git.

Verdict:
PASS PENDING FINAL GIT PUSH PROOF.
"@

Append-Utf8File -Path $StatusPath -Text $StatusEntry

$ExpectedRelative = @(
    "BRAIN_LEARNING/FRUSTRATION_BELL_RETRACE_RULE_20260523.md",
    "HOUSE_WORK/WORK_SHED/SORTING_BENCH/FRUSTRATION_BELL_RETRACE_CHAT_BEHAVIOR_CAPTURE_20260523.md",
    "HOUSE_WORK/WORK_SHED/SORTING_BENCH/TRANSCRIPT_INVENTORY_AFTER_CLEAN_SWITCH_20260523.md",
    "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"
)

# Secret/token/password tracking check.
$TrackedRisk = @()
try {
    $TrackedRisk = & git ls-files |
        Where-Object { $_ -match '(?i)(secret|token|password|passwd|apikey|api_key|credential|credentials|\.env|private|key\.pem|id_rsa|id_ed25519)' }
} catch {
    $TrackedRisk = @("TRACKED_RISK_CHECK_FAILED: $($_.Exception.Message)")
}

$StatusMid = (& git status --short) -join "`r`n"

# Stage only expected paths and receipt later.
foreach ($Rel in $ExpectedRelative) {
    if (Test-Path -LiteralPath (Join-Path $RepoTopFull $Rel)) {
        & git add -- $Rel | Out-Null
    }
}

# Build initial receipt before commit, then stage it.
$RuleHash = Get-Sha256OrBlank -Path $RulePath
$CaptureHash = Get-Sha256OrBlank -Path $CapturePath
$InventoryHash = Get-Sha256OrBlank -Path $TranscriptInventoryPath
$StatusHash = Get-Sha256OrBlank -Path $StatusPath

$RiskText = if ($TrackedRisk -and $TrackedRisk.Count -gt 0) { ($TrackedRisk -join "`r`n") } else { "None found by filename scan." }

$ReceiptTextPre = @"
FRUSTRATION BELL RETRACE + TRANSCRIPT INVENTORY SAVE RECEIPT

Created: $Ts

Repo:
$RepoTopFull

Porch/root:
$Porch

Active home:
$ExpectedHome

Git:
Branch: $Branch
HEAD before save: $HeadFull
Origin/main before save: $OriginHead
Top-level check: $TopNote

Saved files:
BRAIN_LEARNING/FRUSTRATION_BELL_RETRACE_RULE_20260523.md
SHA256: $RuleHash

HOUSE_WORK/WORK_SHED/SORTING_BENCH/FRUSTRATION_BELL_RETRACE_CHAT_BEHAVIOR_CAPTURE_20260523.md
SHA256: $CaptureHash

HOUSE_WORK/WORK_SHED/SORTING_BENCH/TRANSCRIPT_INVENTORY_AFTER_CLEAN_SWITCH_20260523.md
SHA256: $InventoryHash

HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
SHA256: $StatusHash

Transcript/source inventory found count:
$($Dedup.Count)

Tracked risk-name check:
$RiskText

Boundary:
No Steiner application.
No doctrine promotion.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No transcript move/import.
No delete.
No file scatter.
No secret/token/password material intentionally added.

Git status before save:
$StatusBefore

Git status after writing expected files:
$StatusMid

Verdict before commit:
EXPECTED FILES WRITTEN / READY TO COMMIT
"@

Write-Utf8File -Path $ReceiptPath -Text $ReceiptTextPre
& git add -- "PROOF_HISTORY/FRUSTRATION_BELL_RETRACE_AND_TRANSCRIPT_INVENTORY_SAVE_RECEIPT_20260523.txt" | Out-Null

$Staged = (& git diff --cached --name-only) -join "`r`n"

# Refuse to continue if unexpected staged files somehow appeared.
$Allowed = @(
    "BRAIN_LEARNING/FRUSTRATION_BELL_RETRACE_RULE_20260523.md",
    "HOUSE_WORK/WORK_SHED/SORTING_BENCH/FRUSTRATION_BELL_RETRACE_CHAT_BEHAVIOR_CAPTURE_20260523.md",
    "HOUSE_WORK/WORK_SHED/SORTING_BENCH/TRANSCRIPT_INVENTORY_AFTER_CLEAN_SWITCH_20260523.md",
    "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md",
    "PROOF_HISTORY/FRUSTRATION_BELL_RETRACE_AND_TRANSCRIPT_INVENTORY_SAVE_RECEIPT_20260523.txt"
)

$UnexpectedStaged = @()
foreach ($Name in (($Staged -split "`r?`n") | Where-Object { $_ })) {
    if ($Allowed -notcontains $Name) {
        $UnexpectedStaged += $Name
    }
}

if ($UnexpectedStaged.Count -gt 0) {
    Write-Host "UNEXPECTED STAGED FILES. ABORTING BEFORE COMMIT."
    $UnexpectedStaged | ForEach-Object { Write-Host $_ }
    throw "Unexpected staged files found. Commit aborted."
}

if (-not $Staged) {
    Write-Host "NO STAGED CHANGES. NOTHING TO COMMIT."
    exit 0
}

& git commit -m "Save frustration retrace rule and transcript inventory" | Out-Host

$HeadAfterCommit = (& git rev-parse HEAD).Trim()
$HeadAfterShort = (& git rev-parse --short HEAD).Trim()

& git push origin $Branch | Out-Host

$OriginAfter = ""
try { $OriginAfter = (& git rev-parse origin/$Branch 2>$null).Trim() } catch { $OriginAfter = "" }
$StatusAfter = (& git status --short) -join "`r`n"
$ReceiptHashFinalBeforeRewrite = Get-Sha256OrBlank -Path $ReceiptPath

# Update receipt after push, then amend commit so the receipt contains final proof.
$FinalReceiptText = @"
FRUSTRATION BELL RETRACE + TRANSCRIPT INVENTORY SAVE RECEIPT

Created: $Ts

Repo:
$RepoTopFull

Porch/root:
$Porch

Active home:
$ExpectedHome

Git:
Branch: $Branch
HEAD before save: $HeadFull
Origin/main before save: $OriginHead
Commit after save: $HeadAfterCommit
Commit short: $HeadAfterShort
Origin/$Branch after push: $OriginAfter
Top-level check: $TopNote

Saved files:
BRAIN_LEARNING/FRUSTRATION_BELL_RETRACE_RULE_20260523.md
SHA256: $RuleHash

HOUSE_WORK/WORK_SHED/SORTING_BENCH/FRUSTRATION_BELL_RETRACE_CHAT_BEHAVIOR_CAPTURE_20260523.md
SHA256: $CaptureHash

HOUSE_WORK/WORK_SHED/SORTING_BENCH/TRANSCRIPT_INVENTORY_AFTER_CLEAN_SWITCH_20260523.md
SHA256: $InventoryHash

HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
SHA256: $StatusHash

PROOF_HISTORY/FRUSTRATION_BELL_RETRACE_AND_TRANSCRIPT_INVENTORY_SAVE_RECEIPT_20260523.txt
SHA256 before final receipt rewrite:
$ReceiptHashFinalBeforeRewrite

Transcript/source inventory found count:
$($Dedup.Count)

Tracked risk-name check:
$RiskText

Boundary:
No Steiner application.
No doctrine promotion.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No transcript move/import.
No delete.
No file scatter.
No secret/token/password material intentionally added.

Git status before save:
$StatusBefore

Git status after writing expected files:
$StatusMid

Git status after push before final receipt amend:
$StatusAfter

Verdict:
PASS / FRUSTRATION BELL RETRACE RULE SAVED / TRANSCRIPT INVENTORY SAVED / PUSH ATTEMPT COMPLETED

Note:
If final receipt amend changes commit hash, trust the terminal final proof lines below over this pre-amend commit hash.
"@

Write-Utf8File -Path $ReceiptPath -Text $FinalReceiptText
& git add -- "PROOF_HISTORY/FRUSTRATION_BELL_RETRACE_AND_TRANSCRIPT_INVENTORY_SAVE_RECEIPT_20260523.txt" | Out-Null
& git commit --amend --no-edit | Out-Host

$HeadAfterAmend = (& git rev-parse HEAD).Trim()
$HeadAfterAmendShort = (& git rev-parse --short HEAD).Trim()

# Force-with-lease is needed because receipt amend changes the commit after first push.
& git push --force-with-lease origin $Branch | Out-Host

$OriginFinal = ""
try { $OriginFinal = (& git rev-parse origin/$Branch 2>$null).Trim() } catch { $OriginFinal = "" }
$FinalStatus = (& git status --short) -join "`r`n"
$ReceiptHashFinal = Get-Sha256OrBlank -Path $ReceiptPath

Write-Host ""
Write-Host "FINAL SAVE RESULT"
Write-Host "Repo: $RepoTopFull"
Write-Host "Branch: $Branch"
Write-Host "HEAD: $HeadAfterAmendShort"
Write-Host "HEAD full: $HeadAfterAmend"
Write-Host "Origin/$Branch: $OriginFinal"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHashFinal"
Write-Host "Transcript inventory: $TranscriptInventoryPath"
Write-Host "Transcript/source found count: $($Dedup.Count)"
Write-Host "Final git status --short:"
if ($FinalStatus) { Write-Host $FinalStatus } else { Write-Host "[clean]" }

if ($HeadAfterAmend -eq $OriginFinal -and -not $FinalStatus) {
    Write-Host "Verdict: PASS / SAVED CLEAN / ORIGIN MATCHES"
} else {
    Write-Host "Verdict: PARTIAL / CHECK FINAL STATUS OR ORIGIN MATCH"
}
