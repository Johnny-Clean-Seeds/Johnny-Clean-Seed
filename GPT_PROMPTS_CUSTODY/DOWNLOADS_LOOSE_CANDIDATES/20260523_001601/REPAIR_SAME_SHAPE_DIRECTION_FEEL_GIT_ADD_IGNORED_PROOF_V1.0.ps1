# REPAIR_SAME_SHAPE_DIRECTION_FEEL_GIT_ADD_IGNORED_PROOF_V1.0.ps1
# Repairs failed save where brain files were written but git add stopped because PROOF_HISTORY is ignored.
# Does not rewrite content. It stages expected dirty files, force-adds the ignored PROOF_HISTORY receipt, commits, pushes,
# and verifies HEAD == origin/main with clean status.

$ErrorActionPreference = "Stop"

function Invoke-GitChecked {
    param(
        [Parameter(Mandatory=$true)][string]$Repo,
        [Parameter(Mandatory=$true)][string[]]$Args,
        [switch]$AllowOutput
    )
    Push-Location $Repo
    try {
        $Output = & git @Args 2>&1
        $Code = $LASTEXITCODE
        if ($Code -ne 0) {
            throw "git $($Args -join ' ') failed with exit $Code`n$Output"
        }
        return $Output
    } finally {
        Pop-Location
    }
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$BrainRepo = Join-Path $Desktop "Jxhnny_Kleen_C3dz"
$AssistantRoot = Join-Path $Desktop "ASSISTANT_LOCAL"
$ReceiptDir = Join-Path $AssistantRoot "_RECEIPTS"
$Closeout = Join-Path $AssistantRoot ("PORCH_CLOSEOUT\SAME_SHAPE_DIRECTION_FEEL_GIT_REPAIR_{0}" -f $Stamp)

if (-not (Test-Path -LiteralPath (Join-Path $BrainRepo ".git"))) {
    throw "BLOCKED: Mr.Kleen repo not found or not a git repo: $BrainRepo"
}

New-Item -ItemType Directory -Path $ReceiptDir,$Closeout -Force | Out-Null

$Branch = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","--abbrev-ref","HEAD")).Trim()
if ($Branch -ne "main") {
    throw "BLOCKED: brain repo is not on main. Current branch: $Branch"
}

$OldHead = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","HEAD")).Trim()

Invoke-GitChecked -Repo $BrainRepo -Args @("fetch","origin","main") | Out-Null
$RemoteBefore = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","origin/main")).Trim()
if ($OldHead -ne $RemoteBefore) {
    throw "BLOCKED: local HEAD does not match origin/main. Local: $OldHead Remote: $RemoteBefore"
}

$RuleRel = "BRAIN_LEARNING\BEFORE_AFTER_SAME_SHAPE_HOUSE_WALK_DIRECTION_FEEL_RULE_20260522.md"
$CaptureRel = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\SAME_SHAPE_HOUSE_WALK_WEARING_FEEL_CAPTURE_20260522.md"
$StatusRel = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$ProofCandidates = Get-ChildItem -LiteralPath (Join-Path $BrainRepo "PROOF_HISTORY") -Filter "SAME_SHAPE_HOUSE_WALK_DIRECTION_FEEL_LOCK_RECEIPT_20260522_*.txt" -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending

if ($ProofCandidates.Count -lt 1) {
    throw "BLOCKED: expected PROOF_HISTORY receipt not found."
}

$ProofRel = "PROOF_HISTORY\$($ProofCandidates[0].Name)"

$ExpectedRel = @($RuleRel,$CaptureRel,$StatusRel,$ProofRel)

foreach ($Rel in $ExpectedRel) {
    $Full = Join-Path $BrainRepo $Rel
    if (-not (Test-Path -LiteralPath $Full)) {
        throw "BLOCKED: expected save target missing: $Rel"
    }
}

# Check dirty state. Allow only expected same-shape files.
$StatusLines = Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short","--untracked-files=all")
$Unexpected = @()

foreach ($Line in $StatusLines) {
    $Text = [string]$Line
    if ($Text.Trim().Length -eq 0) { continue }

    $PathPart = $Text.Substring(3).Trim()
    $PathNorm = $PathPart -replace "/", "\"

    $Allowed = $false
    foreach ($Rel in $ExpectedRel) {
        if ($PathNorm -eq $Rel) { $Allowed = $true }
    }

    if (-not $Allowed) {
        $Unexpected += $Text
    }
}

if ($Unexpected.Count -gt 0) {
    throw "BLOCKED: unexpected dirty brain repo files present. Inspect before committing.`n$($Unexpected -join "`n")"
}

# Stage normal tracked/unignored files.
Invoke-GitChecked -Repo $BrainRepo -Args @("add",$RuleRel,$CaptureRel,$StatusRel) | Out-Null

# Force-add ignored proof receipt.
Invoke-GitChecked -Repo $BrainRepo -Args @("add","-f",$ProofRel) | Out-Null

$Staged = Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short")
if (($Staged -join "`n").Trim().Length -eq 0) {
    throw "BLOCKED: no staged changes after repair add."
}

Invoke-GitChecked -Repo $BrainRepo -Args @("commit","-m","Add same-shape direction feel rule") | Out-Null
Invoke-GitChecked -Repo $BrainRepo -Args @("push","origin","main") | Out-Null

$NewHead = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","HEAD")).Trim()
Invoke-GitChecked -Repo $BrainRepo -Args @("fetch","origin","main") | Out-Null
$RemoteAfter = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","origin/main")).Trim()
$FinalStatus = Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short")

if ($NewHead -ne $RemoteAfter) {
    throw "BLOCKED: push verification failed. Local: $NewHead Remote: $RemoteAfter"
}
if (($FinalStatus -join "`n").Trim().Length -ne 0) {
    throw "BLOCKED: brain repo not clean after repair.`n$($FinalStatus -join "`n")"
}

$RuleHash = Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $BrainRepo $RuleRel)
$CaptureHash = Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $BrainRepo $CaptureRel)
$StatusHash = Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $BrainRepo $StatusRel)
$ProofHash = Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $BrainRepo $ProofRel)

$ScriptArchive = "Not running from porch"
if ($PSCommandPath) {
    $SelfFull = [System.IO.Path]::GetFullPath($PSCommandPath)
    $PorchFull = [System.IO.Path]::GetFullPath($Porch)
    if ($SelfFull.StartsWith($PorchFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        $ArchivePath = Join-Path $Closeout (Split-Path -Leaf $PSCommandPath)
        Move-Item -LiteralPath $PSCommandPath -Destination $ArchivePath -Force
        if (-not (Test-Path -LiteralPath $ArchivePath)) { throw "BLOCKED: script archive failed: $ArchivePath" }
        $ScriptArchive = $ArchivePath
    }
}

$LocalRepairReceipt = Join-Path $ReceiptDir ("SAME_SHAPE_DIRECTION_FEEL_GIT_REPAIR_RECEIPT_$Stamp.txt")
$Lines = @()
$Lines += "SAME-SHAPE DIRECTION-FEEL GIT REPAIR RECEIPT"
$Lines += "Timestamp: $Stamp"
$Lines += "Verdict: PASS / IGNORED PROOF RECEIPT FORCE-ADDED / COMMITTED / PUSHED / CLEAN"
$Lines += ""
$Lines += "Old HEAD: $OldHead"
$Lines += "New HEAD: $NewHead"
$Lines += "Remote HEAD: $RemoteAfter"
$Lines += ""
$Lines += "Repaired cause:"
$Lines += "- Prior save failed at git add because PROOF_HISTORY is ignored."
$Lines += "- This repair force-added only the expected proof receipt and committed the expected same-shape files."
$Lines += ""
$Lines += "Brain files committed:"
$Lines += "- $RuleRel"
$Lines += "  SHA256: $($RuleHash.Hash)"
$Lines += "- $CaptureRel"
$Lines += "  SHA256: $($CaptureHash.Hash)"
$Lines += "- $ProofRel"
$Lines += "  SHA256: $($ProofHash.Hash)"
$Lines += "- $StatusRel"
$Lines += "  SHA256: $($StatusHash.Hash)"
$Lines += ""
$Lines += "Installer archive:"
$Lines += "- $ScriptArchive"
$Lines += ""
$Lines += "Boundary:"
$Lines += "- No content rewrite by repair."
$Lines += "- No doctrine promotion."
$Lines += "- No ACTIVE_GUIDES rewrite."
$Lines += "- No CURRENT_TRUTH_INDEX rewrite."
$Lines += "- No automation."
$Lines += "- No dashboard."
$Lines += "- No broad cleanup."
$Lines += "- Final status clean."

Set-Content -LiteralPath $LocalRepairReceipt -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "SAME-SHAPE DIRECTION-FEEL GIT REPAIR COMPLETE"
Write-Host "Local repair receipt: $LocalRepairReceipt"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteAfter"
Write-Host "Status: clean"
Write-Host "Verdict: PASS / COMMITTED AND PUSHED / NO DOCTRINE PROMOTION"
