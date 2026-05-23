$ErrorActionPreference = "Stop"

function Invoke-Git {
    param(
        [Parameter(Mandatory=$true)][string[]]$Args
    )
    & git @Args
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Args -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Try-GitRoot {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $Out = & git -C $Path rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0 -and $Out) {
        return ($Out | Select-Object -First 1)
    }
    return $null
}

function Resolve-RepoRoot {
    $Candidates = @(
        "$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz",
        "$env:USERPROFILE\Desktop\123",
        "$env:USERPROFILE\Desktop\Jxhnny_Kleen_C3dz",
        "$env:USERPROFILE\Desktop\Jxhnny_Kl33N_Seedz"
    ) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique

    foreach ($Candidate in $Candidates) {
        $Root = Try-GitRoot -Path $Candidate
        if ($Root) { return $Root }
    }

    $SearchBase = "$env:USERPROFILE\Desktop\123"
    if (Test-Path -LiteralPath $SearchBase) {
        $Dirs = Get-ChildItem -LiteralPath $SearchBase -Directory -ErrorAction SilentlyContinue
        foreach ($Dir in $Dirs) {
            $Root = Try-GitRoot -Path $Dir.FullName
            if ($Root) { return $Root }
        }
    }

    throw "Could not find a Git repo root. Checked Desktop\123\Jxhnny_Kl33N_Seedz, Desktop\123, old Mr.Kleen path, and direct children of Desktop\123."
}

$Repo = Resolve-RepoRoot
Set-Location -LiteralPath $Repo

$Branch = (& git branch --show-current).Trim()
if (-not $Branch) { $Branch = "main" }

$BeforeHead = (& git rev-parse HEAD).Trim()
$BeforeShort = (& git rev-parse --short HEAD).Trim()

$Date = "20260523"
$RuleDir = Join-Path $Repo "BRAIN_LEARNING"
$BenchDir = Join-Path $Repo "HOUSE_WORK\WORK_SHED\SORTING_BENCH"
$ReceiptDir = Join-Path $Repo "PROOF_HISTORY"
$StatusPath = Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

New-Item -ItemType Directory -Path $RuleDir,$BenchDir,$ReceiptDir -Force | Out-Null

$Rule1Path = Join-Path $RuleDir "SUCCESS_PATTERN_AUDIT_RULE_20260523.md"
$Rule2Path = Join-Path $RuleDir "MISSING_HOME_PLACEMENT_AUDIT_RULE_20260523.md"
$CapturePath = Join-Path $BenchDir "SUCCESS_PATTERN_AND_HOME_PLACEMENT_RULE_SPLIT_CAPTURE_20260523.md"
$ReceiptPath = Join-Path $ReceiptDir "SUCCESS_PATTERN_HOME_PLACEMENT_RULE_SPLIT_SAVE_RECEIPT_20260523.txt"

$Rule1 = @'
# Success Pattern Audit Rule — 2026-05-23

Status: behavior rule candidate saved to house memory lane  
Boundary: not doctrine, not ACTIVE_GUIDE, not CURRENT_TRUTH_INDEX, not automation, not Steiner application.

## Rule

When a work pass lands cleanly, do not only celebrate and move on.

Run a Success Pattern Audit.

## Ask

1. What worked?
2. Why did it work?
3. What lane was clean?
4. What did the assistant avoid doing wrong?
5. What conditions, gates, order, or method made the result better?
6. What part of the behavior should be repeatable?

## Source event

The Steiner-first research paper pass landed cleanly because the route stayed research-first:
- no forced relation;
- no fake promotion;
- no trying to make Steiner serve the project before listening to him;
- source was allowed to have its own spine before application.

## Use

Use this rule after strong successful passes, especially when the user says the result landed cleanly or when a normally messy kind of task suddenly works.

## Blocked

- Do not convert success into doctrine automatically.
- Do not skip proof because success felt good.
- Do not merge this rule with Missing Home Placement Audit.
- Do not use this rule to praise the assistant instead of extracting a repeatable method.

## Output

The output is a short success explanation and a repeatable pattern candidate.
'@

$Rule2 = @'
# Missing Home Placement Audit Rule — 2026-05-23

Status: behavior rule candidate saved to house memory lane  
Boundary: not doctrine, not ACTIVE_GUIDE, not CURRENT_TRUTH_INDEX, not automation, not Steiner application.

## Rule

After a successful pattern is identified, ask why that working behavior is not already preserved in the house.

This is separate from Success Pattern Audit.

Success Pattern Audit explains why the pass worked.
Missing Home Placement Audit checks whether the house already has a home for that working behavior.

## Ask

1. Is this working pattern already covered by an existing rule?
2. If yes, why did that rule not visibly fire before?
3. If no, what kind of home does it need?
4. Is it a new rule, a scaffold, a checklist, a note, a Soft Suit candidate, or only a one-time lesson?
5. Should it be captured, parked, adapted, installed later, or blocked?
6. What source event, boundary, proof need, and return trigger belong with it?

## Source event

The Steiner-first research pass exposed a useful behavior:
research first, no forced relation, no fake promotion, and no application before the source had its own spine.

The follow-up correction was that this is not one rule. It is two:
1. Success Pattern Audit.
2. Missing Home Placement Audit.

## Use

Use this rule after Success Pattern Audit when the successful method looks reusable or when the user asks why a good working behavior is not already in the home.

## Blocked

- Do not install a new rule just because a success felt good.
- Do not treat missing-home as proof that the house failed.
- Do not collapse this rule into Success Pattern Audit.
- Do not use this rule to pull source material into doctrine.
- Do not apply Steiner or any other source just because the success event came from a source-research pass.

## Output

The output is a placement decision:
existing rule fired, existing rule failed to fire, capture candidate, park, adapt, install later, or block.
'@

$Capture = @"
# Success Pattern + Missing Home Placement Rule Split Capture — 2026-05-23

Status: sorting bench capture  
Boundary: saved as rule split and source event capture only; no doctrine, no ACTIVE_GUIDE rewrite, no CURRENT_TRUTH_INDEX rewrite, no automation, no Steiner application.

## Trigger

User correction after the Steiner-first research paper pass:

The assistant observed that the pass worked because the lane was clean:
research first, no forced relation, no fake promotion, and no trying to make Steiner serve the project before listening to him.

User then identified that the insight contains two rules, not one.

## Split

### Rule 1: Success Pattern Audit

Purpose: identify why a successful pass worked and what made the method repeatable.

### Rule 2: Missing Home Placement Audit

Purpose: after a successful pattern is identified, check whether the house already preserves it, whether a rule failed to fire, or whether a new placement candidate should be captured.

## Why the split matters

Failure audits catch broken patterns.
Success audits catch working patterns.
Missing-home audits catch useful working patterns that have not yet been placed.

The first rule explains success.
The second rule checks home placement.

## Current disposition

Saved as BRAIN_LEARNING behavior rules and sorting-bench capture.

No promotion.
No active guide change.
No Steiner application.
No hard-suit promotion.
No doctrine install.

## Future proof need

Use the two-rule split on a later clean success event and verify that it:
1. identifies the success pattern without ego/praise drift;
2. checks existing house coverage;
3. chooses capture, park, adapt, install-later, or block;
4. avoids automatic promotion.
"@

$Rule1 | Set-Content -LiteralPath $Rule1Path -Encoding UTF8
$Rule2 | Set-Content -LiteralPath $Rule2Path -Encoding UTF8
$Capture | Set-Content -LiteralPath $CapturePath -Encoding UTF8

$TouchedForHash = @($Rule1Path,$Rule2Path,$CapturePath)

if (Test-Path -LiteralPath $StatusPath) {
    $StatusAppend = @"

## 2026-05-23 — Success Pattern / Missing Home Placement rule split saved

Current save: Success Pattern Audit Rule and Missing Home Placement Audit Rule split.

Boundary:
- rule split only;
- no doctrine promotion;
- no ACTIVE_GUIDES rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no automation;
- no Steiner application;
- Steiner research remains source material until separately reviewed and placed.

Files:
- BRAIN_LEARNING/SUCCESS_PATTERN_AUDIT_RULE_20260523.md
- BRAIN_LEARNING/MISSING_HOME_PLACEMENT_AUDIT_RULE_20260523.md
- HOUSE_WORK/WORK_SHED/SORTING_BENCH/SUCCESS_PATTERN_AND_HOME_PLACEMENT_RULE_SPLIT_CAPTURE_20260523.md
- PROOF_HISTORY/SUCCESS_PATTERN_HOME_PLACEMENT_RULE_SPLIT_SAVE_RECEIPT_20260523.txt
"@
    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8
    $TouchedForHash += $StatusPath
}

$Hashes = foreach ($Path in $TouchedForHash) {
    $Rel = [System.IO.Path]::GetRelativePath($Repo, $Path).Replace("\","/")
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    "$Rel`t$Hash"
}

$CurrentStatusBeforeAdd = (& git status --short) -join "`r`n"

$Receipt = @"
SUCCESS PATTERN / MISSING HOME PLACEMENT RULE SPLIT SAVE RECEIPT

Date: 2026-05-23
Repo: $Repo
Branch: $Branch
Before HEAD: $BeforeHead

Purpose:
Lock and save two separate rules:
1. Success Pattern Audit.
2. Missing Home Placement Audit.

Source event:
Steiner-first research paper pass landed cleanly because the route stayed research-first:
no forced relation, no fake promotion, no trying to make Steiner serve the project before listening to him.

User correction:
That is two rules in one if read correctly.

Boundary:
No doctrine promotion.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No Steiner application.
No import/move of Steiner files.
No secret/token/password file handling.
No broad cleanup.

Files and SHA256:
$($Hashes -join "`r`n")

Git status before add:
$CurrentStatusBeforeAdd

Verdict:
PENDING COMMIT VALIDATION
"@

$Receipt | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

$FilesToAdd = @($Rule1Path,$Rule2Path,$CapturePath,$ReceiptPath)
if (Test-Path -LiteralPath $StatusPath) { $FilesToAdd += $StatusPath }

$RelFiles = foreach ($Path in $FilesToAdd) {
    [System.IO.Path]::GetRelativePath($Repo, $Path).Replace("\","/")
}

Invoke-Git -Args @("add","-f","--") + $RelFiles

& git diff --cached --quiet
$DiffExit = $LASTEXITCODE
if ($DiffExit -eq 0) {
    Write-Host "NO CHANGES TO COMMIT"
    Write-Host "Repo: $Repo"
    Write-Host "Status:"
    git status --short
    exit 0
}
if ($DiffExit -ne 1) {
    throw "git diff --cached --quiet failed with exit code $DiffExit"
}

Invoke-Git -Args @("commit","-m","Add success pattern home placement audits")

$PushOk = $false
& git push origin $Branch
if ($LASTEXITCODE -eq 0) {
    $PushOk = $true
} else {
    Write-Host "Push failed once. Trying pull --rebase then push."
    Invoke-Git -Args @("pull","--rebase","origin",$Branch)
    Invoke-Git -Args @("push","origin",$Branch)
    $PushOk = $true
}

$AfterHead = (& git rev-parse HEAD).Trim()
$AfterShort = (& git rev-parse --short HEAD).Trim()
$RemoteHead = (& git ls-remote origin "refs/heads/$Branch").Split()[0]

$FinalStatus = (& git status --short) -join "`r`n"
if (-not $FinalStatus) { $FinalStatus = "[clean]" }

$ReceiptFinal = @"
SUCCESS PATTERN / MISSING HOME PLACEMENT RULE SPLIT SAVE RECEIPT

Date: 2026-05-23
Repo: $Repo
Branch: $Branch
Before HEAD: $BeforeHead
After HEAD: $AfterHead
Remote HEAD: $RemoteHead
HEAD matches remote: $($AfterHead -eq $RemoteHead)

Purpose:
Lock and save two separate rules:
1. Success Pattern Audit.
2. Missing Home Placement Audit.

Source event:
Steiner-first research paper pass landed cleanly because the route stayed research-first:
no forced relation, no fake promotion, no trying to make Steiner serve the project before listening to him.

User correction:
That is two rules in one if read correctly.

Boundary:
No doctrine promotion.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No Steiner application.
No import/move of Steiner files.
No secret/token/password file handling.
No broad cleanup.

Files and SHA256:
$($Hashes -join "`r`n")
$([System.IO.Path]::GetRelativePath($Repo, $ReceiptPath).Replace("\","/"))`t$((Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash)

Final git status:
$FinalStatus

Verdict:
PASS / RULE SPLIT LOCKED AND SAVED / PUSH VALIDATED
"@

$ReceiptFinal | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

Invoke-Git -Args @("add","-f","--",[System.IO.Path]::GetRelativePath($Repo, $ReceiptPath).Replace("\","/"))
Invoke-Git -Args @("commit","--amend","--no-edit")
Invoke-Git -Args @("push","--force-with-lease","origin",$Branch)

$AfterHead2 = (& git rev-parse HEAD).Trim()
$RemoteHead2 = (& git ls-remote origin "refs/heads/$Branch").Split()[0]
$FinalStatus2 = (& git status --short) -join "`r`n"
if (-not $FinalStatus2) { $FinalStatus2 = "[clean]" }

if ($AfterHead2 -ne $RemoteHead2) {
    throw "Final validation failed: local HEAD does not match remote HEAD."
}

Write-Host "LOCK SAVE COMPLETE"
Write-Host "Repo: $Repo"
Write-Host "Branch: $Branch"
Write-Host "Commit: $AfterHead2"
Write-Host "Remote matches: $($AfterHead2 -eq $RemoteHead2)"
Write-Host "Final status:"
Write-Host $FinalStatus2
Write-Host "Receipt:"
Write-Host $ReceiptPath
