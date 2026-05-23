$ErrorActionPreference = "Stop"

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"
$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$VideoId = "Dgbci0GC1vk"
$Title = "Inside a Jumping Spider's Brain | ScienceTake | The New York Times"

Set-Location $Repo
if (-not (Test-Path ".git")) { throw "Not in Mr.Kleen repo: $Repo" }

$Pre = git status --short
if ($Pre) { throw "Mr.Kleen not clean. Stop.`n$Pre" }

$Old = git rev-parse HEAD

$SourceFolder = Get-ChildItem $Root123 -Recurse -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -eq $VideoId } |
    Sort-Object FullName |
    Select-Object -First 1

if (-not $SourceFolder) { throw "Source folder not found under Desktop\123 for $VideoId" }

$Full = Join-Path $SourceFolder.FullName "TRANSCRIPT_CLEAN_FULL_$VideoId.txt"
$Note = Join-Path $SourceFolder.FullName "SOURCE_INTAKE_NOTE_$VideoId.txt"
$Rcpt = Join-Path $SourceFolder.FullName "TRANSCRIPT_FULL_RECEIPT_$VideoId.txt"

foreach ($P in @($Full,$Note,$Rcpt)) {
    if (-not (Test-Path $P)) { throw "Missing source file: $P" }
}

$FH = (Get-FileHash -Algorithm SHA256 $Full).Hash
$NH = (Get-FileHash -Algorithm SHA256 $Note).Hash
$RH = (Get-FileHash -Algorithm SHA256 $Rcpt).Hash

$Out = "HOUSE_WORK/WORK_SHED/SOURCE_ORE/YOUTUBE_SOURCE_INTAKE_20260522/$VideoId"
$Idx = "HOUSE_WORK/WORK_SHED/INDEXES/YOUTUBE_SOURCE_INTAKE_INDEX_20260522.md"
$Status = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"
$Proof = "PROOF_HISTORY/YOUTUBE_JUMPING_SPIDER_BRAIN_SOURCE_INTAKE_RECEIPT_20260522.txt"

New-Item -ItemType Directory -Force -Path $Out,(Split-Path $Idx),(Split-Path $Status),(Split-Path $Proof) | Out-Null

$Rec = Join-Path $Out "JUMPING_SPIDER_BRAIN_COMPACT_COGNITION_SOURCE_ORE_20260522.md"
$NoteCopy = Join-Path $Out "SOURCE_INTAKE_NOTE_$VideoId.txt"
$RcptCopy = Join-Path $Out "SOURCE_CAPTURE_RECEIPT_$VideoId.txt"

Copy-Item $Note $NoteCopy -Force
Copy-Item $Rcpt $RcptCopy -Force

@"
# Jumping Spider Brain / Compact Cognition Source Ore 20260522

Video ID: $VideoId

Title seen: $Title

Local source folder: $($SourceFolder.FullName)

Full transcript local path: $Full

Full transcript SHA256: $FH

Source note SHA256: $NH

Source receipt SHA256: $RH

Clean frame: spider cognition, tiny brain computation, sensory processing, embodied intelligence, perception-action loops, neural economy, prediction, attention, and compact biological decision systems.

Source-safety boundary: full raw transcript remains in Desktop\123. Git stores intake record, note copy, receipt copy, paths, hashes, and framed source-ore only. Not doctrine. Not active guide. Not CURRENT_TRUTH_INDEX. Not automation. Not medical advice.
"@ | Set-Content $Rec -Encoding UTF8

Add-Content $Idx -Encoding UTF8 -Value @"

## Dgbci0GC1vk - Jumping spider brain / compact cognition source
Source-safe intake added for spider cognition, tiny-brain computation, embodied intelligence, sensory processing, attention, prediction, and compact decision-system material. Full transcript remains in Desktop\123. Git stores source-safe record, note, receipt copy, and hashes only.
"@

Add-Content $Status -Encoding UTF8 -Value @"

## 20260522 - Jumping spider brain source intake gathered
Saved source-safe Git intake record for Dgbci0GC1vk. Full raw transcript remains in Desktop\123; Git stores note, receipt copy, hashes, record, index/status update, and proof only. Boundary: no doctrine promotion, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no medical-advice install.
"@

$All = @($Rec,$NoteCopy,$RcptCopy,$Idx,$Status,$Proof)

@"
YOUTUBE JUMPING SPIDER BRAIN SOURCE INTAKE RECEIPT 20260522
Old HEAD: $Old
Source root: $Root123
Source folder: $($SourceFolder.FullName)
Destination: $Out
Included: Dgbci0GC1vk
Boundary: source-safe Git intake only; full raw transcript remains in Desktop\123; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no medical-advice install.

Files:
$((($All | Where-Object { $_ -ne $Proof }) | ForEach-Object { "- $_" }) -join "`n")
"@ | Set-Content $Proof -Encoding UTF8

$Manifest = ($All | ForEach-Object { (Get-FileHash -Algorithm SHA256 $_).Hash + "  " + $_ }) -join "`n"
Add-Content $Proof -Encoding UTF8 -Value "`nSHA256 MANIFEST:`n$Manifest"

git add -- $Rec $NoteCopy $RcptCopy $Idx $Status
if ($LASTEXITCODE) { throw "git add failed" }

git add -f -- $Proof
if ($LASTEXITCODE) { throw "proof receipt add failed" }

git commit -m "Add jumping spider brain source intake"
if ($LASTEXITCODE) { throw "commit failed" }

git push origin main
if ($LASTEXITCODE) { throw "push failed" }

$New = git rev-parse HEAD
$Remote = git rev-parse origin/main
$Clean = git status --short

if ($New -ne $Remote) { throw "HEAD != origin/main" }
if ($Clean) { throw "Final status not clean:`n$Clean" }

Write-Host "PASS - JUMPING SPIDER BRAIN SOURCE INTAKE GATHERED AND PUSHED"
Write-Host "Old HEAD: $Old"
Write-Host "New HEAD: $New"
Write-Host "Remote HEAD: $Remote"
Write-Host "Final status: clean"
Write-Host "Receipt: $Proof"
