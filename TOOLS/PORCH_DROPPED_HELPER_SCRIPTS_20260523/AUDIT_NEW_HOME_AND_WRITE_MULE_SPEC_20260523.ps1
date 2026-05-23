param()

$ErrorActionPreference = "Stop"

function Add-Issue {
    param(
        [System.Collections.Generic.List[string]]$List,
        [string]$Text
    )
    $List.Add($Text) | Out-Null
}

function Run-Git {
    param(
        [string]$Repo,
        [string[]]$Args
    )
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "git"
    foreach ($a in @("-C", $Repo) + $Args) { [void]$psi.ArgumentList.Add($a) }
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $p = [System.Diagnostics.Process]::Start($psi)
    $p.WaitForExit()
    [pscustomobject]@{
        ExitCode = $p.ExitCode
        StdOut   = $p.StandardOutput.ReadToEnd().Trim()
        StdErr   = $p.StandardError.ReadToEnd().Trim()
    }
}

$PorchRoot = "C:\Users\13527\Desktop\123"
$Home = Join-Path $PorchRoot "Jxhnny_Kl33N_Seedz"
$Now = Get-Date -Format "yyyyMMdd_HHmmss"

$Critical = New-Object System.Collections.Generic.List[string]
$Warnings = New-Object System.Collections.Generic.List[string]
$Facts = New-Object System.Collections.Generic.List[string]

if (-not (Test-Path -LiteralPath $PorchRoot -PathType Container)) {
    throw "Porch root does not exist: $PorchRoot"
}

$AuditBase = if (Test-Path -LiteralPath $Home -PathType Container) {
    Join-Path $Home "_HOME_AUDIT"
} else {
    Join-Path $PorchRoot "_HOME_AUDIT"
}
New-Item -ItemType Directory -Path $AuditBase -Force | Out-Null

$InventoryCsv = Join-Path $AuditBase "NEW_HOME_TOP_LEVEL_INVENTORY_$Now.csv"
$SpecPath = Join-Path $AuditBase "NEW_HOME_SPEC_$Now.md"
$ReceiptPath = Join-Path $AuditBase "NEW_HOME_AUDIT_RECEIPT_$Now.txt"
$MuleOrderPath = Join-Path $AuditBase "MULE_REBUILD_OR_REPAIR_NEW_HOME_TO_SPEC_$Now.md"

Add-Issue $Facts "Porch root: $PorchRoot"
Add-Issue $Facts "Active home: $Home"
Add-Issue $Facts "Audit base: $AuditBase"

$HomeExists = Test-Path -LiteralPath $Home -PathType Container
if (-not $HomeExists) {
    Add-Issue $Critical "ACTIVE HOME MISSING: $Home"
} else {
    Add-Issue $Facts "Active home exists."
}

$TopItems = @()
if ($HomeExists) {
    $TopItems = Get-ChildItem -LiteralPath $Home -Force -ErrorAction Stop | Sort-Object PSIsContainer, Name
    $TopItems | Select-Object @{Name="Type";Expression={ if ($_.PSIsContainer) { "Directory" } else { "File" } }}, Name, FullName, LastWriteTime, Length |
        Export-Csv -LiteralPath $InventoryCsv -NoTypeInformation -Encoding UTF8
} else {
    @() | Export-Csv -LiteralPath $InventoryCsv -NoTypeInformation -Encoding UTF8
}

$GitAvailable = $false
try {
    $null = Get-Command git -ErrorAction Stop
    $GitAvailable = $true
    Add-Issue $Facts "git command available."
} catch {
    Add-Issue $Warnings "git command not available in this shell; Git validation skipped."
}

$GitTop = ""
$GitBranch = ""
$GitHead = ""
$GitRemote = ""
$GitStatus = ""
$TrackedSecretHits = @()
$CloudflaredTracked = @()

if ($HomeExists -and $GitAvailable) {
    $r = Run-Git -Repo $Home -Args @("rev-parse", "--show-toplevel")
    if ($r.ExitCode -ne 0) {
        Add-Issue $Critical "Active home is not a readable Git repo: $($r.StdErr)"
    } else {
        $GitTop = $r.StdOut
        $ExpectedNorm = (Resolve-Path -LiteralPath $Home).Path.TrimEnd('\')
        $GitTopNorm = (Resolve-Path -LiteralPath $GitTop).Path.TrimEnd('\')
        if ($GitTopNorm -ne $ExpectedNorm) {
            Add-Issue $Critical "Git top-level mismatch. Expected [$ExpectedNorm], got [$GitTopNorm]."
        } else {
            Add-Issue $Facts "Git top-level matches active home."
        }

        $GitBranch = (Run-Git -Repo $Home -Args @("branch", "--show-current")).StdOut
        $GitHead = (Run-Git -Repo $Home -Args @("rev-parse", "--short", "HEAD")).StdOut
        $remoteResult = Run-Git -Repo $Home -Args @("ls-remote", "origin", "refs/heads/main")
        if ($remoteResult.ExitCode -eq 0 -and $remoteResult.StdOut) { $GitRemote = $remoteResult.StdOut }
        else { Add-Issue $Warnings "Could not verify origin/main through ls-remote. $($remoteResult.StdErr)" }

        $GitStatus = (Run-Git -Repo $Home -Args @("status", "--short")).StdOut
        if ([string]::IsNullOrWhiteSpace($GitStatus)) {
            Add-Issue $Facts "Git status --short is clean."
        } else {
            Add-Issue $Warnings "Git status --short is not clean. Review before any lock/save."
        }

        $tracked = (Run-Git -Repo $Home -Args @("ls-files")).StdOut -split "`r?`n" | Where-Object { $_ }
        $secretNameRegex = '(?i)(token|secret|password|passwd|credential|apikey|api_key|auth|private[_-]?key|\.env)'
        $TrackedSecretHits = $tracked | Where-Object { $_ -match $secretNameRegex }
        if ($TrackedSecretHits.Count -gt 0) {
            Add-Issue $Critical "Secret/token/password-named files appear tracked by Git. See receipt list."
        } else {
            Add-Issue $Facts "No secret/token/password-named tracked files detected by filename scan."
        }

        $CloudflaredTracked = $tracked | Where-Object { $_ -match '(?i)cloudflared\.exe$' }
        if ($CloudflaredTracked.Count -gt 0) {
            Add-Issue $Warnings "cloudflared.exe appears tracked. GitHub may warn over 50 MB; consider artifact/vendor lane later."
        }
    }
}

$LooseRootItems = Get-ChildItem -LiteralPath $PorchRoot -Force -ErrorAction Stop | Where-Object { $_.Name -ne "Jxhnny_Kl33N_Seedz" }
$LooseRootCount = $LooseRootItems.Count
if ($LooseRootCount -gt 0) {
    Add-Issue $Warnings "Porch root has loose/sibling items besides Jxhnny_Kl33N_Seedz. This may be valid drop material, but needs porch tracker before moving. Count: $LooseRootCount"
} else {
    Add-Issue $Facts "Porch root contains only active home."
}

$ForbiddenPathHits = @()
$DuplicateNameGroups = @()
$DuplicateContentGroups = @()
$SecretNamedLocalFiles = @()

if ($HomeExists) {
    $ForbiddenPathHits = Get-ChildItem -LiteralPath $Home -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '\\.git(\\|$)' -and $_.FullName -match '(?i)(\\shed\\|\\bridge\\|\\old[_-]?home\\)' } |
        Select-Object -First 50
    if ($ForbiddenPathHits.Count -gt 0) {
        Add-Issue $Warnings "Possible old shed/bridge/old-home path names found inside active home. Review before treating home as clean."
    } else {
        Add-Issue $Facts "No obvious shed/bridge/old-home path names found in active home scan."
    }

    $allFiles = Get-ChildItem -LiteralPath $Home -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '\\.git(\\|$)' }

    $DuplicateNameGroups = $allFiles | Group-Object Name | Where-Object { $_.Count -gt 1 } | Select-Object -First 25
    if ($DuplicateNameGroups.Count -gt 0) {
        Add-Issue $Warnings "Duplicate filenames exist in active home. May be valid, but review before claiming zero duplicate filename groups."
    } else {
        Add-Issue $Facts "Duplicate filename groups: zero."
    }

    $hashRows = foreach ($f in $allFiles) {
        try {
            $h = Get-FileHash -Algorithm SHA256 -LiteralPath $f.FullName -ErrorAction Stop
            [pscustomobject]@{ Hash=$h.Hash; Path=$f.FullName; Name=$f.Name }
        } catch {}
    }
    $DuplicateContentGroups = $hashRows | Group-Object Hash | Where-Object { $_.Count -gt 1 } | Select-Object -First 25
    if ($DuplicateContentGroups.Count -gt 0) {
        Add-Issue $Warnings "Duplicate content groups exist in active home. Review before claiming zero duplicate content groups."
    } else {
        Add-Issue $Facts "Duplicate content groups: zero."
    }

    $SecretNamedLocalFiles = $allFiles | Where-Object { $_.Name -match '(?i)(token|secret|password|passwd|credential|apikey|api_key|auth|private[_-]?key|\.env)' } | Select-Object -First 100
    if ($SecretNamedLocalFiles.Count -gt 0) {
        Add-Issue $Warnings "Secret/token/password-named local files exist. This is allowed only if local-only and untracked. Review list in receipt."
    }
}

$Verdict = if ($Critical.Count -gt 0) { "FAIL / REPAIR OR REBUILD NEEDED BEFORE USING NEW HOME AS ACTIVE" }
elseif ($Warnings.Count -gt 0) { "PASS WITH GUARDRAILS / ACTIVE HOME FOUND / REVIEW WARNINGS BEFORE LOCK-SAVE" }
else { "PASS / ACTIVE HOME FOUND AND BASIC CHECKS CLEAN" }

@"
# New Home Local Spec — $Now

## Fixed routing

- Porch/drop root: `C:\Users\13527\Desktop\123`
- Active home/work zone: `C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz`
- Old assumed home blocked unless later proof reauthorizes it: `C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz`

## Role split

- `Desktop\123` is the porch/drop surface.
- `Desktop\123\Jxhnny_Kl33N_Seedz` is the assistant's active local home.
- Dropped files enter through porch logic/source custody before they are moved, installed, promoted, or committed.
- Audit material belongs in `_HOME_AUDIT`.
- Secret/token/password-named files are local-only unless explicitly proven safe and intentionally tracked.

## Rebuild-to-spec minimum if home is missing or invalid

A mule repair/rebuild must produce:

1. The active home folder at the exact path above.
2. A readable Git repo at that exact folder when project Git is intended.
3. A `_HOME_AUDIT` folder with receipt and inventory.
4. No broad crawl, no delete, no destructive overwrite.
5. No tracked token/secret/password/private-key files.
6. No promotion, doctrine rewrite, ACTIVE_GUIDES rewrite, or CURRENT_TRUTH_INDEX rewrite as part of home repair.
7. A final receipt with paths, hashes where applicable, git status, HEAD, origin/main comparison if available, and remaining blockers.

## Current audit verdict

$Verdict
"@ | Set-Content -LiteralPath $SpecPath -Encoding UTF8

if ($Critical.Count -gt 0) {
@"
# Mule Rebuild / Repair Order — New Home To Spec — $Now

## Read first

The current active home check did not fully pass. Do not improvise a new project shape. Repair or rebuild only to this exact routing:

- Porch/drop root: `C:\Users\13527\Desktop\123`
- Active home/work zone: `C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz`

## Current critical issues

$($Critical | ForEach-Object { "- $_" } | Out-String)

## Allowed work

- Inspect only the porch root, active home path, audit folder, Git metadata, and needed receipts/manifests.
- If active home is missing, create or restore the exact active home folder only after preserving any found source material in a dated source/archive lane.
- If Git top-level is wrong, report the mismatch and propose the smallest repair.
- If secret/token/password-named files are tracked, stop that tracking plan and report exact files; do not push secrets.
- Write a repair receipt and inventory.

## Blocked work

- No broad crawl.
- No delete.
- No destructive overwrite.
- No doctrine promotion.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No Git history rewrite unless separately approved.
- No moving old archive material into active home without lane and receipt.

## Required return

Return:

1. Active home path.
2. What was missing or wrong.
3. What was repaired or rebuilt.
4. Git top-level, branch, HEAD, origin/main check if available.
5. Secret/token/password tracking result.
6. Remaining blockers.
7. Receipt path and SHA256.
"@ | Set-Content -LiteralPath $MuleOrderPath -Encoding UTF8
}

$receipt = @"
NEW HOME AUDIT RECEIPT

Timestamp: $Now
Porch/drop root:
$PorchRoot

Active home/work zone:
$Home

Spec file:
$SpecPath

Inventory CSV:
$InventoryCsv

Mule repair order if needed:
$(if (Test-Path -LiteralPath $MuleOrderPath) { $MuleOrderPath } else { "NOT CREATED - no critical repair order needed" })

Git top-level:
$GitTop

Git branch:
$GitBranch

Git HEAD short:
$GitHead

Origin/main ls-remote:
$GitRemote

Git status --short:
$(if ([string]::IsNullOrWhiteSpace($GitStatus)) { "[clean or not available]" } else { $GitStatus })

Facts:
$($Facts | ForEach-Object { "- $_" } | Out-String)
Warnings:
$(if ($Warnings.Count -eq 0) { "- None" } else { $Warnings | ForEach-Object { "- $_" } | Out-String })
Critical issues:
$(if ($Critical.Count -eq 0) { "- None" } else { $Critical | ForEach-Object { "- $_" } | Out-String })
Tracked secret/token/password-name hits:
$(if ($TrackedSecretHits.Count -eq 0) { "- None detected" } else { $TrackedSecretHits | ForEach-Object { "- $_" } | Out-String })
Local secret/token/password-name files:
$(if ($SecretNamedLocalFiles.Count -eq 0) { "- None detected by filename scan" } else { $SecretNamedLocalFiles | ForEach-Object { "- $($_.FullName)" } | Out-String })
Possible old shed/bridge/old-home path hits:
$(if ($ForbiddenPathHits.Count -eq 0) { "- None detected" } else { $ForbiddenPathHits | ForEach-Object { "- $($_.FullName)" } | Out-String })
Duplicate filename groups sample:
$(if ($DuplicateNameGroups.Count -eq 0) { "- Zero" } else { $DuplicateNameGroups | ForEach-Object { "- $($_.Name): $($_.Count)" } | Out-String })
Duplicate content groups sample:
$(if ($DuplicateContentGroups.Count -eq 0) { "- Zero" } else { $DuplicateContentGroups | ForEach-Object { "- $($_.Name): $($_.Count)" } | Out-String })
Cloudflared tracked hits:
$(if ($CloudflaredTracked.Count -eq 0) { "- None detected" } else { $CloudflaredTracked | ForEach-Object { "- $_" } | Out-String })

Boundary:
Audit/spec only. No file moves. No delete. No Git commit. No push. No doctrine promotion. No ACTIVE_GUIDES rewrite. No CURRENT_TRUTH_INDEX rewrite.

Verdict:
$Verdict
"@
$receipt | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath).Hash

Write-Host "NEW HOME AUDIT COMPLETE"
Write-Host "Verdict: $Verdict"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Spec: $SpecPath"
Write-Host "Inventory: $InventoryCsv"
if (Test-Path -LiteralPath $MuleOrderPath) { Write-Host "Mule repair order: $MuleOrderPath" }
